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

package cn.enaium.nurupoga.util

import cn.enaium.nurupoga.util.JacksonUtil.jackson
import org.springframework.web.bind.annotation.RequestMethod
import java.net.URI
import java.net.URLEncoder
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpRequest.BodyPublishers
import java.net.http.HttpResponse

/**
 * @author Enaium
 */
object HttpUtil {
    private fun param(map: Map<String, String>): String {
        val stringBuilder = StringBuilder()
        for (stringStringEntry in map.entries) {
            stringBuilder
                .append(stringStringEntry.key)
                .append("=")
                .append(URLEncoder.encode(stringStringEntry.value, Charsets.UTF_8))
                .append("&")
        }
        return stringBuilder.toString()
    }

    private fun createClient(): HttpClient {
        return HttpClient.newBuilder().build()
    }

    fun send(
        method: RequestMethod,
        url: String,
        map: Map<String, String>,
        type: Type = Type.APPLICATION_X_WWW_FORM_URLENCODED
    ): String {
        return createClient().send(
            HttpRequest.newBuilder().header("Content-Type", type.value)
                .uri(URI.create(url)).method(
                    method.name,
                    BodyPublishers.ofString(
                        when (type) {
                            Type.APPLICATION_JSON -> jackson().writeValueAsString(map)
                            Type.APPLICATION_X_WWW_FORM_URLENCODED -> param(map)
                        }
                    )
                ).build(),
            HttpResponse.BodyHandlers.ofString()
        ).body()
    }

    enum class Type(val value: String) {
        APPLICATION_X_WWW_FORM_URLENCODED("application/x-www-form-urlencoded"),
        APPLICATION_JSON("application/json")
    }
}