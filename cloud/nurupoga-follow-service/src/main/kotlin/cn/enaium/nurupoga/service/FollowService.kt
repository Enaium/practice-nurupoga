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

import cn.enaium.nurupoga.model.entity.UserInfoEntity
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import com.baomidou.mybatisplus.core.metadata.IPage
import org.springframework.transaction.annotation.Transactional

/**
 * @author Enaium
 */
interface FollowService {
    @Transactional
    fun isFollowing(who: Long?, target: Long): ResultWrapper<Boolean>

    @Transactional
    fun follow(target: Long): ResultWrapper<Any>

    @Transactional
    fun unfollow(target: Long): ResultWrapper<Any>

    @Transactional
    fun followers(current: Long, size: Long, who: Long): ResultWrapper<IPage<Any>>

    @Transactional
    fun following(current: Long, size: Long, who: Long): ResultWrapper<IPage<Any>>

    fun followerCount(who: Long): ResultWrapper<Long>

    fun followingCount(who: Long): ResultWrapper<Long>
}