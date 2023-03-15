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
 * FITNESS FOR OpenAPIServiceAspect PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package cn.enaium.nurupoga.configuration

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.http.HttpHeaders
import org.springframework.web.server.WebFilter

/**
 * @author Enaium
 */
@Configuration
class CorsConfiguration {
    @Order(Ordered.HIGHEST_PRECEDENCE)
    @Bean
    fun corsFilter(): WebFilter {
        return WebFilter { exchange, chain ->
            with(exchange.response.headers) {
                this[HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN] = "*"
                this[HttpHeaders.ACCESS_CONTROL_ALLOW_METHODS] = "*"
                this[HttpHeaders.ACCESS_CONTROL_ALLOW_HEADERS] = "*"
                this[HttpHeaders.ACCESS_CONTROL_ALLOW_CREDENTIALS] = "true"
                this[HttpHeaders.ACCESS_CONTROL_MAX_AGE] = "3600"
            }
            chain.filter(exchange)
        }
    }
}