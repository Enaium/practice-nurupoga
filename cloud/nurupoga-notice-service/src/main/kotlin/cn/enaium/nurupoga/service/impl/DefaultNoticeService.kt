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

import cn.enaium.nurupoga.mapper.NoticeMapper
import cn.enaium.nurupoga.model.entity.NoticeEntity
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.service.NoticeService
import cn.enaium.nurupoga.util.WrapperUtil.query
import com.baomidou.mybatisplus.core.metadata.IPage
import com.baomidou.mybatisplus.extension.plugins.pagination.Page
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import org.springframework.stereotype.Service

/**
 * @author Enaium
 */
@Service
class DefaultNoticeService : ServiceImpl<NoticeMapper, NoticeEntity>(), NoticeService {
    override fun all(current: Long, size: Long, user: Long): ResultWrapper<IPage<NoticeEntity>> {
        return Builder.success(content = page(Page(current, size), query {
            it.eq("at_user", user)
            it.orderByDesc("unread", "create_time")
        }))
    }

    override fun read(notice: Long): ResultWrapper<Boolean> {
        val byId = getById(notice)
        byId.unread = false
        byId.updateById()
        return Builder.success()
    }

    override fun unreadCount(user: Long): ResultWrapper<Long> {
        return Builder.success(content = count(query {
            it.eq("at_user", user)
            it.eq("unread", true)
        }))
    }
}