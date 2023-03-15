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

import cn.enaium.nurupoga.model.wrapper.JsonNodeWrapper
import cn.enaium.nurupoga.util.JacksonUtil.jackson
import com.fasterxml.jackson.core.JsonGenerator
import com.fasterxml.jackson.databind.JsonSerializer
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializerProvider
import com.fasterxml.jackson.databind.module.SimpleModule
import com.fasterxml.jackson.databind.node.ObjectNode
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

/**
 * @author Enaium
 */
@Configuration
class JacksonConfiguration {
    @Bean
    fun objectMapper(): ObjectMapper {
        val jackson = jackson()
        jackson.registerModule(SimpleModule().apply {
            addSerializer(JsonNodeWrapper::class.java, object : JsonSerializer<JsonNodeWrapper>() {
                override fun serialize(value: JsonNodeWrapper, gen: JsonGenerator, serializers: SerializerProvider) {
                    gen.writeObject(jackson.readValue(value.toString(), ObjectNode::class.java))
                }
            })
        })
        return jackson
    }
}