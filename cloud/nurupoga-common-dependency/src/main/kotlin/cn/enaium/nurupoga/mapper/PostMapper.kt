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
package cn.enaium.nurupoga.mapper

import cn.enaium.nurupoga.model.entity.PostEntity
import cn.enaium.nurupoga.model.entity.TagEntity
import com.baomidou.mybatisplus.core.conditions.Wrapper
import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.baomidou.mybatisplus.core.metadata.IPage
import com.baomidou.mybatisplus.core.toolkit.Constants
import org.apache.ibatis.annotations.Mapper
import org.apache.ibatis.annotations.Param
import org.apache.ibatis.annotations.Select

@Mapper
interface PostMapper : BaseMapper<PostEntity> {
    @Select(
        """
            select *
            from (select table_post.*, tpa.create_time as answered_time
                from table_post
                    left join table_post_answer tpa on table_post.id = tpa.post_id) as t ${"$"}{ew.customSqlSegment}
               """
    )
    fun selectNoTag(
        page: IPage<Map<String, Any>>,
        @Param(Constants.WRAPPER) wrapper: Wrapper<Map<String, Any>>
    ): IPage<PostEntity>

    @Select(
        """
        select *
        from (select table_post.*, tt.id as tag_id, tt.name as tag_name, tpa.create_time as answered_time
            from table_post
               left join table_post_answer tpa on table_post.id = tpa.post_id
               left join table_post_tag tpt on table_post.id = tpt.post_id
               left join table_tag tt on tpt.tag_id = tt.id) as t ${"$"}{ew.customSqlSegment}
               """
    )
    fun selectHasTag(
        page: IPage<Map<String, Any>>,
        @Param(Constants.WRAPPER) wrapper: Wrapper<Map<String, Any>>
    ): IPage<PostEntity>


    @Select(
        """
            select t.*
        from table_post_tag pt
                 left join table_post p on pt.post_id = p.id
                 left join table_tag t on pt.tag_id = t.id
        where p.id = #{postId}
    """)
    fun selectAllTag(postId: Long): List<TagEntity>
}