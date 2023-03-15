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

import cn.enaium.nurupoga.annotation.Optional
import cn.enaium.nurupoga.annotation.OptionalBody
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.service.UserService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController

/**
 * @author Enaium
 */
@RestController
class UserController(val userService: UserService) {
    /**
     * get user info
     *
     * @param id user id
     * @return
     */
    @OptionalBody
    @PostMapping("/info")
    fun info(@Optional id: Long): ResultWrapper<Any> {
        return userService.info(id)
    }

    /**
     * create a user info if the id is null or else update user info
     *
     * @param id
     * @param nickname
     * @param description
     * @param avatar
     * @return
     */
    @OptionalBody
    @PostMapping("/publish")
    fun publish(
        @Optional id: Long?,
        @Optional nickname: String?,
        @Optional description: String?,
        @Optional avatar: String?,
        @Optional invalid: Boolean?
    ): ResultWrapper<Boolean> {
        return userService.publish(id, nickname, description, avatar, invalid)
    }

    @OptionalBody
    @PostMapping("/all")
    fun all(
        @Optional(default = "1") current: Long = 1,
        @Optional(default = "10") size: Long = 10,
        @Optional id: Long?,
        @Optional username: String?,
        @Optional nickname: String?,
        @Optional description: String?,
        @Optional invalid: Boolean?
    ): ResultWrapper<Any> {
        return userService.all(current, size, id, username, nickname, description, invalid)
    }
}