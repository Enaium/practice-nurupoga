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
import cn.enaium.nurupoga.mapper.CommentMapper
import cn.enaium.nurupoga.mapper.NoticeMapper
import cn.enaium.nurupoga.mapper.PostAnswerMapper
import cn.enaium.nurupoga.mapper.PostMapper
import cn.enaium.nurupoga.model.entity.CommentEntity
import cn.enaium.nurupoga.model.entity.NoticeEntity
import cn.enaium.nurupoga.model.type.NoticeType
import cn.enaium.nurupoga.model.type.PermissionType
import cn.enaium.nurupoga.model.type.RoleType
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.model.wrapper.Status
import cn.enaium.nurupoga.service.CommentService
import cn.enaium.nurupoga.util.WrapperUtil.query
import com.baomidou.mybatisplus.extension.plugins.pagination.Page
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import org.springframework.stereotype.Service

@Service
class DefaultCommentService(
    val postMapper: PostMapper,
    val noticeMapper: NoticeMapper,
    val postAnswerMapper: PostAnswerMapper
) : ServiceImpl<CommentMapper, CommentEntity>(), CommentService {
    override fun publish(id: Long?, post: Long?, content: String, invalid: Boolean?): ResultWrapper<Any> {
        var post = post
        val update = id != null

        if (update) {
            val byId = getById(id)
            if (byId == null) {
                return Builder.fail(status = Status.COMMENT_DOESNT_EXIST)
            } else {
                post = byId.postId
            }
        }

        if (!StpUtil.hasPermission(PermissionType.PUBLISH_COMMENT)) {
            return Builder.fail(status = Status.NO_PERMISSION)
        }

        if (update) {
            postAnswerMapper.selectOne(query {
                it.eq("comment_id", id)
            })?.let {
                if (!StpUtil.hasRoleOr(RoleType.OWNER, RoleType.ADMIN)) {
                    return Builder.fail(status = Status.ANSWER_HAS_ACCEPTED)
                }
            }
        }


        invalid?.let {
            if (!StpUtil.hasPermission(PermissionType.DELETE_COMMENT)) {
                return Builder.fail(status = Status.NO_PERMISSION)
            }
        }

        val postEntity = postMapper.selectById(post) ?: return Builder.fail(status = Status.POST_DOESNT_EXIST)

        if (postEntity.invalid == true) {
            return Builder.fail(status = Status.POST_INVALID)
        }

        val commentEntity = CommentEntity().apply {
            this.id = id
            this.postId = postEntity.id
            this.content = content
            this.type = postEntity.type
            this.invalid = invalid
        }

        saveOrUpdate(commentEntity)

        if (!update) {
            postEntity.reply = postEntity.reply?.plus(1)
            postEntity.updateById()
            noticeMapper.insert(NoticeEntity().apply {
                type = NoticeType.PUBLISH_COMMENT
                self = commentEntity.id
                at = postEntity.id
                atUser = postEntity.userId
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
        user: Long?,
        post: Long?,
        dateRange: List<Long>?,
        comment: Long?,
        invalid: Boolean?
    ): ResultWrapper<Any> {

        post ?: let {
            if (!StpUtil.hasRoleOr(RoleType.OWNER, RoleType.ADMIN)) {
                return Builder.fail(status = Status.POST_DOESNT_EXIST)
            }
        }

        val page = Page<CommentEntity>(current, size)

        val query = query<CommentEntity> { query ->
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

            post?.let { query.eq("post_id", post) }

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
        return Builder.success(content = comment?.let { getBaseMapper().selectByComment(it, page, query) }
            ?: page(page, query))
    }

    override fun info(id: Long): ResultWrapper<CommentEntity> {

        val comment = getById(id)

        comment?.let {
            if (it.invalid == true) {
                return Builder.fail(status = Status.COMMENT_INVALID)
            }
        }

        return Builder.success(content = comment)
    }
}