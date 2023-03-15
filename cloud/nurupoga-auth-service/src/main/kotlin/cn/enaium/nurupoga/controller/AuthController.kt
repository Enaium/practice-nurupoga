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

package cn.enaium.nurupoga.controller

import cn.dev33.satoken.stp.StpUtil
import cn.enaium.nurupoga.annotation.Optional
import cn.enaium.nurupoga.annotation.OptionalBody
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.service.AuthService
import org.springframework.web.bind.annotation.*

/**
 * @author Enaium
 */
@RestController
class AuthController(val userService: AuthService) {
    /**
     * login
     *
     * @param username limit 18
     * @param password limit 32
     */
    @OptionalBody
    @PostMapping("/login")
    fun login(
        @Optional username: String,
        @Optional password: String
    ): ResultWrapper<Any> {
        return userService.login(username, password)
    }

    /**
     * register
     *
     * @param username limit 18
     * @param password limit 32
     * @return
     */
    @OptionalBody
    @PostMapping("/register")
    fun register(
        @Optional username: String,
        @Optional password: String
    ): ResultWrapper<String> {
        return userService.register(username, password)
    }

    /**
     * logout
     */
    @PostMapping("/logout")
    fun logout(): ResultWrapper<String> {
        StpUtil.logout()
        return Builder.success()
    }

    /**
     * login or not
     * @return
     */
    @PostMapping("/isLogin")
    fun isLogin(): ResultWrapper<Boolean> {
        return Builder.success(content = StpUtil.isLogin())
    }

    /**
     * get current user id
     */
    @PostMapping("/id")
    fun id(): ResultWrapper<Long> {
        return try {
            Builder.success(content = StpUtil.getLoginIdAsLong())
        } catch (e: Exception) {
            Builder.success(content = null)
        }
    }

    /**
     * get the user all roles
     *
     * @param user get the user all roles if the user id isn't null or else get current user
     */
    @PostMapping("/roles")
    @OptionalBody
    fun roles(@Optional user: Long?): ResultWrapper<List<String>> {
        return Builder.success(content = user?.let { StpUtil.getRoleList(it) } ?: let { StpUtil.getRoleList() })
    }

    /**
     * judge the user has or hasn't the role
     *
     * @param user judge the user has or hasn't the role if the user id isn't null or else judge current user
     * @param role
     */
    @PostMapping("/hasRole")
    @OptionalBody
    fun hasRole(@Optional user: Long?, @Optional role: String): ResultWrapper<Boolean> {
        return Builder.success(content = user?.let { StpUtil.hasRole(it, role) } ?: let { StpUtil.hasRole(role) })
    }
}