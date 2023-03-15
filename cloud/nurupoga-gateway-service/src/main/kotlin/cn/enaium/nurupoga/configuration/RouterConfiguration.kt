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

import org.springframework.cloud.gateway.route.RouteLocator
import org.springframework.cloud.gateway.route.builder.PredicateSpec
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

/**
 * @author Enaium
 */
@Configuration
class RouterConfiguration {
    @Bean
    fun routerLocator(builder: RouteLocatorBuilder): RouteLocator {
        return builder.routes()
            .route("auth-service") { r: PredicateSpec ->
                r.path("/api/auth/**").filters { it.stripPrefix(2) }.uri("lb://auth-service")
            }
            .route("comment-service") { r: PredicateSpec ->
                r.path("/api/comment/**").filters { it.stripPrefix(2) }.uri("lb://comment-service")
            }
            .route("gitee-service") { r: PredicateSpec ->
                r.path("/api/gitee/**").filters { it.stripPrefix(2) }.uri("lb://gitee-service")
            }
            .route("notice-service") { r: PredicateSpec ->
                r.path("/api/notice/**").filters { it.stripPrefix(2) }.uri("lb://notice-service")
            }
            .route("post-service") { r: PredicateSpec ->
                r.path("/api/post/**").filters { it.stripPrefix(2) }.uri("lb://post-service")
            }
            .route("tag-service") { r: PredicateSpec ->
                r.path("/api/tag/**").filters { it.stripPrefix(2) }.uri("lb://tag-service")
            }
            .route("user-service") { r: PredicateSpec ->
                r.path("/api/user/**").filters { it.stripPrefix(2) }.uri("lb://user-service")
            }
            .route("follow-service") { r: PredicateSpec ->
                r.path("/api/follow/**").filters { it.stripPrefix(2) }.uri("lb://follow-service")
            }
            .build()
    }
}