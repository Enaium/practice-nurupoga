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
import cn.enaium.nurupoga.client.UserServiceClient
import cn.enaium.nurupoga.mapper.UserMapper
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.model.wrapper.Status.*
import cn.enaium.nurupoga.service.FollowService
import com.baomidou.mybatisplus.core.metadata.IPage
import com.baomidou.mybatisplus.extension.plugins.pagination.Page
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Service

/**
 * @author Enaium
 */
@Service
class DefaultFollowService(
    val stringRedisTemplate: StringRedisTemplate,
    val userMapper: UserMapper,
    val userServiceClient: UserServiceClient
) : FollowService {

    val followers = "user:%s:followers"
    val following = "user:%s:following"

    override fun isFollowing(who: Long?, target: Long): ResultWrapper<Boolean> {

        val w = who ?: let {
            return Builder.success(content = false)
        }

        return Builder.success(
            content = stringRedisTemplate.opsForZSet().score(following.format(w), target.toString()) != null
        )
    }

    override fun follow(target: Long): ResultWrapper<Any> {
        if (StpUtil.getLoginIdAsLong() == target) {
            return Builder.fail(status = FOLLOW_SELF)
        }


        userMapper.selectById(target) ?: let {
            return Builder.fail(status = USER_DOESNT_EXIST)
        }

        if (stringRedisTemplate.opsForZSet()
                .score(following.format(StpUtil.getLoginIdAsLong()), target.toString()) != null
        ) {
            return Builder.fail(status = FOLLOWED)
        }

        stringRedisTemplate.opsForZSet().add(following.format(StpUtil.getLoginIdAsLong()), target.toString(), 0.0)
        stringRedisTemplate.opsForZSet().add(followers.format(target), StpUtil.getLoginIdAsString(), 0.0)
        return Builder.success()
    }

    override fun unfollow(target: Long): ResultWrapper<Any> {
        userMapper.selectById(target) ?: let {
            return Builder.fail(status = USER_DOESNT_EXIST)
        }

        stringRedisTemplate.opsForZSet().remove(following.format(StpUtil.getLoginIdAsLong()), target.toString())
        stringRedisTemplate.opsForZSet().remove(followers.format(target), StpUtil.getLoginIdAsString())
        return Builder.success()
    }

    override fun followers(current: Long, size: Long, who: Long): ResultWrapper<IPage<Any>> {

        userMapper.selectById(who) ?: let {
            return Builder.fail(status = USER_DOESNT_EXIST)
        }

        val page = Page<Any>(
            current,
            size,
            stringRedisTemplate.opsForZSet().size(followers.format(who)) ?: 0
        )

        page.records = mutableListOf()
        stringRedisTemplate.opsForZSet().range(followers.format(who), (current - 1) * size, current * size - 1)
            ?.forEach { follower ->
                page.records.add(userServiceClient.info(follower.toLong()).content)
            }

        return Builder.success(content = page)
    }

    override fun following(current: Long, size: Long, who: Long): ResultWrapper<IPage<Any>> {
        userMapper.selectById(who) ?: let {
            return Builder.fail(status = USER_DOESNT_EXIST)
        }
        val page = Page<Any>(
            current,
            size,
            stringRedisTemplate.opsForZSet().size(following.format(who)) ?: 0
        )

        page.records = mutableListOf()
        stringRedisTemplate.opsForZSet().range(following.format(who), (current - 1) * size, current * size - 1)
            ?.forEach { following ->
                page.records.add(userServiceClient.info(following.toLong()).content)
            }
        return Builder.success(content = page)
    }

    override fun followerCount(who: Long): ResultWrapper<Long> {
        return Builder.success(
            content = stringRedisTemplate.opsForZSet().size(followers.format(who))
        )
    }

    override fun followingCount(who: Long): ResultWrapper<Long> {
        return Builder.success(
            content = stringRedisTemplate.opsForZSet().size(following.format(who))
        )
    }
}