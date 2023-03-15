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
package cn.enaium.nurupoga.service

import cn.enaium.nurupoga.model.entity.PostEntity
import cn.enaium.nurupoga.model.entity.TagEntity
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import com.baomidou.mybatisplus.extension.service.IService
import org.springframework.transaction.annotation.Transactional

interface PostService : IService<PostEntity> {
    @Transactional
    fun publish(
        id: Long?,
        title: String,
        content: String,
        tag: List<TagEntity>,
        type: String,
        invalid: Boolean?
    ): ResultWrapper<String>

    @Transactional
    fun all(
        current: Long,
        size: Long,
        title: String?,
        content: String?,
        type: String?,
        order: String,
        user: Long?,
        tag: Long?,
        dateRange: List<Long>?,
        invalid: Boolean?
    ): ResultWrapper<Any>

    fun info(id: Long): ResultWrapper<Any>
    @Transactional
    fun accept(post: Long, comment: Long): ResultWrapper<Any>
    fun voteUp(post: Long): ResultWrapper<Boolean>
    fun voteDown(post: Long): ResultWrapper<Boolean>
}