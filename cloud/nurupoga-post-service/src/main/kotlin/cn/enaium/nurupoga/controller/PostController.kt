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
import cn.enaium.nurupoga.model.entity.TagEntity
import cn.enaium.nurupoga.model.type.OrderType
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.service.PostService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController

/**
 * @author Enaium
 */
@RestController
class PostController(val postService: PostService) {
    /**
     * publish a post
     *
     * @param id publish a new post if the id is null or else update post info
     * @param title post title limit 100
     * @param content post content
     * @param tag post tags
     * @param type question or article
     */
    @OptionalBody
    @PostMapping("/publish")
    fun publish(
        @Optional id: Long?,
        @Optional title: String,
        @Optional content: String,
        @Optional tag: List<TagEntity>,
        @Optional type: String,
        @Optional invalid: Boolean?
    ): ResultWrapper<String> {
        return postService.publish(id, title, content, tag, type, invalid)
    }

    /**
     * get all posts
     *
     * @param current page current number
     * @param size count of each page
     * @param type post type, question or article
     * @param order sort by latest or answered or unanswered or reply or unreplied
     * @param user post author
     * @param tag post tags
     */
    @OptionalBody
    @PostMapping("/all")
    fun all(
        @Optional(default = "1") current: Long = 1,
        @Optional(default = "10") size: Long = 10,
        @Optional title: String?,
        @Optional content: String?,
        @Optional type: String?,
        @Optional(default = OrderType.LATEST) order: String = OrderType.LATEST,
        @Optional user: Long?,
        @Optional tag: Long?,
        @Optional dateRange: List<Long>?,
        @Optional invalid: Boolean?
    ): ResultWrapper<Any> {
        return postService.all(current, size, title, content, type, order, user, tag, dateRange, invalid)
    }

    /**
     * get post info
     *
     * @param id post id
     */
    @OptionalBody
    @PostMapping("/info")
    fun info(@Optional id: Long): ResultWrapper<Any> {
        return postService.info(id)
    }

    /**
     * accept an answer
     *
     * @param post post id
     * @param comment comment id
     */
    @OptionalBody
    @PostMapping("/accept")
    fun accept(@Optional post: Long, @Optional comment: Long): ResultWrapper<Any> {
        return postService.accept(post, comment)
    }

    @OptionalBody
    @PostMapping("/voteUp")
    fun voteUp(@Optional post: Long): ResultWrapper<Boolean> {
        return postService.voteUp(post)
    }

    @OptionalBody
    @PostMapping("/voteDown")
    fun voteDown(@Optional post: Long): ResultWrapper<Boolean> {
        return postService.voteDown(post)
    }
}