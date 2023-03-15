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
import cn.enaium.nurupoga.mapper.CommentMapper
import cn.enaium.nurupoga.mapper.PostAnswerMapper
import cn.enaium.nurupoga.mapper.PostMapper
import cn.enaium.nurupoga.model.entity.NoticeEntity
import cn.enaium.nurupoga.model.type.NoticeType
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.service.NoticeService
import com.baomidou.mybatisplus.core.metadata.IPage
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController

/**
 * @author Enaium
 */
@RestController
class NoticeController(val noticeService: NoticeService) {
    /**
     * get all notice
     *
     * @param current page current number
     * @param size count of each page
     * @param user user id
     */
    @PostMapping("/all")
    @OptionalBody
    fun all(
        @Optional(default = "1") current: Long = 1,
        @Optional(default = "10") size: Long = 10,
        @Optional user: Long
    ): ResultWrapper<IPage<NoticeEntity>> {
        return noticeService.all(current, size, user)
    }

    /**
     * read a notice
     *
     * @param notice notice id
     */
    @PostMapping("/read")
    @OptionalBody
    fun read(@Optional notice: Long): ResultWrapper<Boolean> {
        return noticeService.read(notice)
    }

    /**
     * unread count
     *
     * @param user user id
     */
    @PostMapping("/unreadCount")
    @OptionalBody
    fun unreadCount(@Optional user: Long): ResultWrapper<Long> {
        return noticeService.unreadCount(user)
    }
}