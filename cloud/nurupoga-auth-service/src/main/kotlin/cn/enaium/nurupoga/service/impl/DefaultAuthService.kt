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
import cn.enaium.nurupoga.mapper.UserInfoMapper
import cn.enaium.nurupoga.mapper.UserMapper
import cn.enaium.nurupoga.mapper.UserRoleMapper
import cn.enaium.nurupoga.model.entity.UserEntity
import cn.enaium.nurupoga.model.entity.UserInfoEntity
import cn.enaium.nurupoga.model.entity.UserRoleEntity
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.model.wrapper.Status
import cn.enaium.nurupoga.service.AuthService
import cn.enaium.nurupoga.util.DigestUtil
import cn.enaium.nurupoga.util.WrapperUtil.query
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import org.springframework.stereotype.Service

@Service
class DefaultAuthService(val userInfoMapper: UserInfoMapper, val userRoleMapper: UserRoleMapper) :
    ServiceImpl<UserMapper, UserEntity>(), AuthService {
    override fun login(username: String, password: String): ResultWrapper<Any> {
        getOne(query {
            it.eq("username", username)
            it.eq("password", DigestUtil.md5(password))
        })?.let {
            if (it.invalid == true) {
                return Builder.fail(status = Status.USER_INVALID)
            } else {
                return Builder.success(content = mapOf("token" to StpUtil.createLoginSession(it.id), "id" to it.id))
            }
        }
        return Builder.fail(status = Status.USER_NOT_MATCH)
    }

    override fun register(username: String, password: String): ResultWrapper<String> {
        getOne(query {
            it.eq("username", username)
        })?.let {
            return Builder.fail(status = Status.USER_EXIST)
        }

        val userEntity = UserEntity().apply {
            this.username = username
            this.password = DigestUtil.md5(password)
        }
        save(userEntity)
        userInfoMapper.insert(UserInfoEntity().apply {
            userId = userEntity.id
        })
        userRoleMapper.insert(UserRoleEntity().apply {
            userId = userEntity.id
        })

        return Builder.success()
    }
}