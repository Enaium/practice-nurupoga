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
import cn.enaium.nurupoga.mapper.*
import cn.enaium.nurupoga.model.entity.*
import cn.enaium.nurupoga.model.type.NoticeType
import cn.enaium.nurupoga.model.type.OrderType
import cn.enaium.nurupoga.model.type.PermissionType
import cn.enaium.nurupoga.model.type.RoleType
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.model.wrapper.Status
import cn.enaium.nurupoga.service.PostService
import cn.enaium.nurupoga.util.JacksonUtil.toJsonNode
import cn.enaium.nurupoga.util.WrapperUtil.query
import com.baomidou.mybatisplus.extension.plugins.pagination.Page
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import org.springframework.stereotype.Service

@Service
class DefaultPostService(
    val postAnswerMapper: PostAnswerMapper,
    val postTagMapper: PostTagMapper,
    val commentMapper: CommentMapper,
    val noticeMapper: NoticeMapper
) :
    ServiceImpl<PostMapper, PostEntity>(), PostService {
    override fun publish(
        id: Long?,
        title: String,
        content: String,
        tag: List<TagEntity>,
        type: String,
        invalid: Boolean?
    ): ResultWrapper<String> {

        val update = id != null

        if (!StpUtil.hasPermission(PermissionType.PUBLISH_POST)) {
            return Builder.fail(status = Status.NO_PERMISSION)
        }


        invalid?.let {
            if (!StpUtil.hasPermission(PermissionType.DELETE_POST)) {
                return Builder.fail(status = Status.NO_PERMISSION)
            }
        }




        if (tag.isEmpty()) {
            return Builder.fail(status = Status.NO_TAG)
        }



        if (update) {
            getById(id)?.let {
                var permission = false

                if (it.userId == StpUtil.getLoginIdAsLong()) {
                    permission = true
                }

                if (StpUtil.hasRoleOr(RoleType.OWNER, RoleType.ADMIN)) {
                    permission = true
                }

                if (!permission) {
                    return Builder.fail(status = Status.NO_PERMISSION)
                }
            } ?: return Builder.fail(status = Status.POST_DOESNT_EXIST)
        }

        val postEntity = PostEntity().apply {
            this.id = id
            this.title = title
            this.content = content
            this.type = type
            this.invalid = invalid
        }


        saveOrUpdate(postEntity)

        if (!update) {
            tag.forEach {
                postTagMapper.insert(PostTagEntity().apply {
                    postId = postEntity.id
                    tagId = it.id
                })
            }

            noticeMapper.insert(NoticeEntity().apply {
                this.type = NoticeType.PUBLISH_POST
                this.self = postEntity.id
                this.at = postEntity.id
                this.atUser = postEntity.userId
            })
        }

        return Builder.success()
    }

    override fun all(
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
    ): ResultWrapper<Any> {
        val query = query<Map<String, Any>> { query ->
            if (!title.isNullOrBlank()) {
                query.like("title", title)
            }

            if (!content.isNullOrBlank()) {
                query.like("content", content)
            }
            if (!type.isNullOrBlank()) {
                query.like("type", type)
            }

            user?.let { query.eq("user_id", user) }
            dateRange?.let {
                if (it.size == 2) {
                    query.apply("unix_timestamp(create_time) between ${dateRange[0] / 1000} and ${dateRange[1] / 1000}")
                }
            }

            when (order) {
                OrderType.LATEST -> {
                    query.orderByDesc("update_time")
                }

                OrderType.ANSWERED -> {
                    query.orderByDesc("answered_time")
                }

                OrderType.UNANSWERED -> {
                    query.orderByAsc("answered_time")
                }

                OrderType.REPLY -> {
                    query.orderByDesc("reply")
                }

                OrderType.UNREPLIED -> {
                    query.orderByAsc("reply")
                }
            }


            var permission = false

            invalid?.let {
                if (StpUtil.hasRoleOr(RoleType.OWNER, RoleType.ADMIN)) {
                    permission = true
                }
            }

            if (permission) {
                query.eq("invalid", invalid)
            } else {
                query.eq("invalid", false)
            }
        }


        val any = if (tag != null) {
            getBaseMapper().selectHasTag(Page(current, size), query.eq("tag_id", tag))
        } else {
            getBaseMapper().selectNoTag(Page(current, size), query)
        }


        any.records.forEach {
            it.tag = getBaseMapper().selectAllTag(it.id!!)
        }
        return Builder.success(content = any)
    }

    override fun info(id: Long): ResultWrapper<Any> {
        getById(id)?.let { post ->

            if (post.invalid == true) {
                return Builder.fail(status = Status.POST_INVALID)
            }
            
            val objectNode = toJsonNode(post)
            postAnswerMapper.selectOne(query { it.eq("post_id", id) })?.let {
                objectNode["answer"] = toJsonNode(it).prototype
            }

            objectNode["tag"] = toJsonNode(getBaseMapper().selectAllTag(id)).prototype

            post.view = post.view?.plus(1)
            post.updateById()

            return Builder.success(content = objectNode)
        }

        return Builder.fail(status = Status.POST_DOESNT_EXIST)
    }

    override fun accept(post: Long, comment: Long): ResultWrapper<Any> {
        val postEntity = getById(post) ?: return Builder.fail(status = Status.POST_DOESNT_EXIST)
        if (postEntity.userId != StpUtil.getLoginIdAsLong()) {
            return Builder.success(status = Status.NO_PERMISSION)
        }
        postAnswerMapper.selectOne(query { it.eq("post_id", post) }) ?: let {
            val postAnswerEntity = PostAnswerEntity().apply {
                this.postId = post
                this.commentId = comment
            }

            postAnswerMapper.insert(postAnswerEntity)

            noticeMapper.insert(NoticeEntity().apply {
                type = NoticeType.ANSWER_ACCEPTED
                self = postAnswerEntity.id
                at = postAnswerEntity.commentId
                atUser = commentMapper.selectById(postAnswerEntity.commentId).userId
            })
            return Builder.success()
        }
        return Builder.fail(status = Status.ANSWER_HAS_ACCEPTED)
    }

    override fun voteUp(post: Long): ResultWrapper<Boolean> {
        getBaseMapper().selectById(post)?.let {
            it.vote = it.vote?.plus(1)
            it.updateById()
        }
        return Builder.success()
    }

    override fun voteDown(post: Long): ResultWrapper<Boolean> {
        getBaseMapper().selectById(post)?.let {
            it.vote = it.vote?.minus(1)
        }
        return Builder.success()
    }
}