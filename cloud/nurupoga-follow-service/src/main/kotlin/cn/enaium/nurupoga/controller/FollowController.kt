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
import cn.enaium.nurupoga.model.entity.UserInfoEntity
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.service.FollowService
import com.baomidou.mybatisplus.core.metadata.IPage
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

/**
 * @author Enaium
 */
@RestController
class FollowController(val followService: FollowService) {
    /**
     * following or not
     *
     * @param who follower id
     * @param target following id
     */
    @OptionalBody
    @PostMapping("/isFollowing")
    fun isFollowing(@Optional who: Long?, @Optional target: Long): ResultWrapper<Boolean> {
        return followService.isFollowing(who, target)
    }

    /**
     * follow
     *
     * @param target following id
     */
    @OptionalBody
    @PostMapping("/follow")
    fun follow(@Optional target: Long): ResultWrapper<Any> {
        return followService.follow(target)
    }

    /**
     * unfollow
     *
     * @param target following id
     */
    @OptionalBody
    @PostMapping("/unfollow")
    fun unfollow(@Optional target: Long): ResultWrapper<Any> {
        return followService.unfollow(target)
    }

    /**
     * get all followers
     *
     * @param current page current number
     * @param size count of each page
     * @param who user id
     * @return
     */
    @OptionalBody
    @PostMapping("/followers")
    fun followers(
        @Optional(default = "1") current: Long = 1,
        @Optional(default = "10") size: Long = 10,
        @Optional who: Long
    ): ResultWrapper<IPage<Any>> {
        return followService.followers(current, size, who)
    }

    /**
     * get all followings
     *
     * @param current page current number
     * @param size count of each page
     * @param who user id
     */
    @OptionalBody
    @PostMapping("/following")
    fun following(
        @Optional(default = "1") current: Long = 1,
        @Optional(default = "10") size: Long = 10,
        @Optional who: Long
    ): ResultWrapper<IPage<Any>> {
        return followService.following(current, size, who)
    }

    /**
     * get follower count
     *
     * @param who user id
     */
    @OptionalBody
    @PostMapping("/followerCount")
    fun followerCount(@Optional who: Long): ResultWrapper<Long> {
        return followService.followerCount(who)
    }

    /**
     * get following count
     *
     * @param who user id
     */
    @OptionalBody
    @PostMapping("/followingCount")
    fun followingCount(@Optional who: Long): ResultWrapper<Long> {
        return followService.followingCount(who)
    }
}