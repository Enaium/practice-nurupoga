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

package cn.enaium.nurupoga.model.wrapper

import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.node.ObjectNode

/**
 * @author Enaium
 */
class JsonNodeWrapper(val prototype: JsonNode) : Iterable<JsonNodeWrapper> {
    override fun iterator(): Iterator<JsonNodeWrapper> {
        return prototype.map { JsonNodeWrapper(it) }.iterator()
    }

    operator fun set(propertyName: String, value: JsonNode) {
        if (prototype is ObjectNode) {
            prototype.replace(propertyName, value)
        }
    }

    operator fun get(propertyName: String): JsonNodeWrapper {
        return JsonNodeWrapper(prototype.get(propertyName))
    }

    operator fun set(propertyName: String, value: Long) {
        if (prototype is ObjectNode) {
            prototype.put(propertyName, value)
        }
    }

    operator fun set(propertyName: String, value: Int) {
        if (prototype is ObjectNode) {
            prototype.put(propertyName, value)
        }
    }

    fun remove(propertyName: String) {
        if (prototype is ObjectNode) {
            prototype.remove(propertyName)
        }
    }

    fun setAll(other: JsonNodeWrapper) {
        if (prototype is ObjectNode) {
            prototype.setAll<JsonNode>(other.prototype as ObjectNode)
        }
    }

    fun asLong(): Long {
        return prototype.asLong()
    }

    fun asInt(): Int {
        return prototype.asInt()
    }

    fun asText(): String {
        return prototype.asText()
    }

    override fun toString(): String {
        return prototype.toString()
    }
}