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

import cn.enaium.nurupoga.mapper.TagMapper
import cn.enaium.nurupoga.model.entity.TagEntity
import cn.enaium.nurupoga.model.wrapper.Builder
import cn.enaium.nurupoga.model.wrapper.ResultWrapper
import cn.enaium.nurupoga.service.TagService
import cn.enaium.nurupoga.util.WrapperUtil.query
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import org.springframework.stereotype.Service

@Service
class DefaultTagService : ServiceImpl<TagMapper, TagEntity>(), TagService {
    override fun create(tag: String): ResultWrapper<Any> {
        getOne(query { it.eq("name", tag) }) ?: save(TagEntity().apply { this.name = tag })
        val one = getOne(query { it.eq("name", tag) })
        return Builder.success(content = mapOf("id" to one.id, "name" to one.name))
    }

    override fun all(): ResultWrapper<Any> {
        return Builder.success(content = getBaseMapper().selectList(null))
    }
}