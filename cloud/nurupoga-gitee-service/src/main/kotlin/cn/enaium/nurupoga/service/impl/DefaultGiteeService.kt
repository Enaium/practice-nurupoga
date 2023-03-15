/*
 * Copyright (c) 2023 Enaium
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package cn.enaium.nurupoga.service.impl

import cn.dev33.satoken.stp.StpUtil
import cn.enaium.nurupoga.mapper.GiteeMapper
import cn.enaium.nurupoga.mapper.UserInfoMapper
import cn.enaium.nurupoga.mapper.UserMapper
import cn.enaium.nurupoga.model.entity.GiteeEntity
import cn.enaium.nurupoga.model.entity.UserEntity
import cn.enaium.nurupoga.model.entity.UserInfoEntity
import cn.enaium.nurupoga.model.type.GiteeType
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.model.wrapper.Status.*
import cn.enaium.nurupoga.service.GiteeService
import cn.enaium.nurupoga.util.DigestUtil
import cn.enaium.nurupoga.util.HttpUtil
import cn.enaium.nurupoga.util.JacksonUtil
import cn.enaium.nurupoga.util.WrapperUtil.query
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import com.fasterxml.jackson.databind.node.ObjectNode
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.bind.annotation.RequestMethod
import java.util.*

@Service
class DefaultGiteeService(
    @Value("${'$'}{gitee.redirect}") val redirect: String,
    @Value("${'$'}{gitee.id}") val id: String,
    @Value("${'$'}{gitee.secret}") val secret: String,
    val userMapper: UserMapper,
    val userInfoMapper: UserInfoMapper
) : ServiceImpl<GiteeMapper, GiteeEntity>(), GiteeService {
    override fun auth(code: String, type: String?): ResultWrapper<Any> {
        val json = JacksonUtil.jackson().readValue(
            HttpUtil.send(
                RequestMethod.POST, "https://gitee.com/oauth/token", mapOf(
                    "grant_type" to "authorization_code",
                    "code" to code,
                    "client_id" to id,
                    "redirect_uri" to when (type) {
                        GiteeType.REGISTER -> "$redirect?type=register"
                        GiteeType.BIND -> "$redirect?type=bind"
                        else -> redirect
                    },
                    "client_secret" to secret
                )
            ), ObjectNode::class.java
        )

        if (!json.has("access_token")) {
            return Builder.fail(message = json["error_description"].asText())
        }

        val accessToken = json["access_token"].asText()

        val giteeUser = JacksonUtil.toJsonNode(
            HttpUtil.send(
                RequestMethod.GET, "https://gitee.com/api/v5/user", mapOf("access_token" to accessToken)
            )
        )

        getOne(query {
            it.eq("gitee_id", giteeUser["id"].asInt())
        })?.let {
            if (userMapper.selectById(it.userId).invalid == true) {
                return Builder.fail(status = USER_INVALID)
            } else {
                return Builder.success(
                    content = mapOf(
                        "token" to StpUtil.createLoginSession(it.userId),
                        "id" to it.userId
                    )
                )
            }
        } ?: let {
            when (type) {
                GiteeType.REGISTER -> {
                    val user = UserEntity().apply {
                        username = DigestUtil.md5(UUID.randomUUID().toString()).substring(8, 24)
                        password = DigestUtil.md5(Math.random().toString())
                    }
                    userMapper.insert(user)
                    save(GiteeEntity().apply {
                        userId = user.id
                        giteeId = giteeUser["id"].asInt()
                    })
                    userInfoMapper.insert(UserInfoEntity().apply {
                        this.userId = user.id
                        this.nickname = giteeUser["name"].asText()
                        this.avatar = giteeUser["avatar_url"].asText()
                    })

                    return Builder.success(message = "Register success with gitee")
                }

                GiteeType.BIND -> {
                    save(GiteeEntity().apply {
                        userId = StpUtil.getLoginIdAsLong()
                        giteeId = giteeUser["id"].asInt()
                    })
                    return Builder.success(message = "Bind success with gitee")
                }

                else -> {
                    return Builder.fail(status = FAIL)
                }
            }
        }
    }
}