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
import cn.enaium.nurupoga.model.entity.UserEntity
import cn.enaium.nurupoga.model.entity.UserInfoEntity
import cn.enaium.nurupoga.model.type.PermissionType
import cn.enaium.nurupoga.model.type.RoleType
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.model.wrapper.Status
import cn.enaium.nurupoga.service.UserService
import cn.enaium.nurupoga.util.JacksonUtil.toJsonNode
import cn.enaium.nurupoga.util.WrapperUtil.query
import cn.enaium.nurupoga.util.WrapperUtil.update
import com.baomidou.mybatisplus.extension.plugins.pagination.Page
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import org.springframework.stereotype.Service

@Service
class DefaultUserService(val userInfoMapper: UserInfoMapper) : ServiceImpl<UserMapper, UserEntity>(), UserService {
    override fun info(id: Long): ResultWrapper<Any> {
        val objectNode = toJsonNode(getById(id))
        objectNode.remove("password")
        userInfoMapper.selectOne(query {
            it.eq("user_id", id)
        })?.let {
            it.id = it.userId
            objectNode.setAll(toJsonNode(it))
        }



        return Builder.success(content = objectNode)
    }

    override fun publish(
        id: Long?,
        nickname: String?,
        description: String?,
        avatar: String?,
        invalid: Boolean?
    ): ResultWrapper<Boolean> {
        id?.let {
            if (id != StpUtil.getLoginIdAsLong()) {
                if (!StpUtil.hasRoleOr(RoleType.OWNER, RoleType.ADMIN)) {
                    return Builder.fail(status = Status.NO_PERMISSION)
                }
            }

            getById(id) ?: let {
                return Builder.fail(status = Status.USER_DOESNT_EXIST)
            }
        }

        invalid?.let {
            if (!StpUtil.hasPermission(PermissionType.DELETE_USER)) {
                return Builder.fail(status = Status.NO_PERMISSION)
            }
            val byId = getById(id)
            byId.invalid = invalid
            byId.updateById()
        }

        userInfoMapper.update(UserInfoEntity().apply {
            this.nickname = nickname
            this.description = description
            this.avatar = avatar
        }, update {
            it.eq("user_id", id ?: StpUtil.getLoginIdAsLong())
        })
        return Builder.success()
    }

    override fun all(
        current: Long,
        size: Long,
        id: Long?,
        username: String?,
        nickname: String?,
        description: String?,
        invalid: Boolean?
    ): ResultWrapper<Any> {
        if (!StpUtil.hasRoleOr(RoleType.OWNER, RoleType.ADMIN)) {
            return Builder.fail(status = Status.NO_PERMISSION)
        }


        return Builder.success(content = getBaseMapper().select(Page(current, size), query { query ->
            id?.let {
                query.eq("id", id)
            }
            if (!username.isNullOrBlank()) {
                query.like("username", username)
            }

            if (!nickname.isNullOrBlank()) {
                query.like("nickname", nickname)
            }

            if (!description.isNullOrBlank()) {
                query.like("description", description)
            }

            invalid?.let {
                query.eq("invalid", invalid)
            }
        }))
    }
}