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

package cn.enaium.nurupoga.configuration

import cn.dev33.satoken.stp.StpUtil
import com.baomidou.mybatisplus.autoconfigure.ConfigurationCustomizer
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor
import com.baomidou.mybatisplus.extension.plugins.inner.OptimisticLockerInnerInterceptor
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor
import org.apache.ibatis.reflection.MetaObject
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import java.util.*


/**
 * @author Enaium
 */
@Configuration
class MyBatisPlusConfiguration {
    @Bean
    fun mybatis(): MybatisPlusInterceptor {
        val interceptor = MybatisPlusInterceptor()
        interceptor.addInnerInterceptor(PaginationInnerInterceptor())
        interceptor.addInnerInterceptor(OptimisticLockerInnerInterceptor())
        return interceptor
    }

    @Bean
    fun autoFill(): MetaObjectHandler {
        return object : MetaObjectHandler {
            override fun insertFill(metaObject: MetaObject) {
                strictInsertFill(metaObject, "userId", { StpUtil.getLoginIdAsLong() }, Long::class.javaObjectType)
                strictInsertFill(metaObject, "createTime", { Date() }, Date::class.java)
                strictInsertFill(metaObject, "updateTime", { Date() }, Date::class.java)
            }

            override fun updateFill(metaObject: MetaObject) {
                setFieldValByName("updateTime", Date(), metaObject)
            }
        }
    }

    @Bean
    fun configurationCustomizer(): ConfigurationCustomizer {
        return ConfigurationCustomizer {
            it.typeHandlerRegistry.register(MutableList::class.java, JacksonTypeHandler::class.java)
            it.typeHandlerRegistry.register(MutableSet::class.java, JacksonTypeHandler::class.java)
        }
    }
}