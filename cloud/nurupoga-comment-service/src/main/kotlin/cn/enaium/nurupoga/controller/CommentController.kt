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
import cn.enaium.nurupoga.model.entity.CommentEntity
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.service.CommentService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController

/**
 * @author Enaium
 */
@RestController
class CommentController(val commentService: CommentService) {
    /**
     * publish a comment
     *
     * @param post
     * @param content
     * @return
     */
    @OptionalBody
    @PostMapping("/publish")
    fun publish(
        @Optional id: Long?,
        @Optional post: Long?,
        @Optional content: String,
        @Optional invalid: Boolean?
    ): ResultWrapper<Any> {
        return commentService.publish(id, post, content, invalid)
    }

    /**
     * get all comment
     *
     * @param current page current number
     * @param size count of each page
     * @param post post id
     * @param comment show fist
     */
    @OptionalBody
    @PostMapping("/all")
    fun all(
        @Optional(default = "1") current: Long = 1,
        @Optional(default = "10") size: Long = 10,
        @Optional title: String?,
        @Optional content: String?,
        @Optional type: String?,
        @Optional user: Long?,
        @Optional post: Long?,
        @Optional dateRange: List<Long>?,
        @Optional comment: Long?,
        @Optional invalid: Boolean?
    ): ResultWrapper<Any> {
        return commentService.all(current, size, title, content, type, user, post, dateRange, comment, invalid)
    }

    /**
     * get comment info
     *
     * @param id comment id
     */
    @OptionalBody
    @PostMapping("/info")
    fun info(@Optional id: Long): ResultWrapper<CommentEntity> {
        return commentService.info(id)
    }
}