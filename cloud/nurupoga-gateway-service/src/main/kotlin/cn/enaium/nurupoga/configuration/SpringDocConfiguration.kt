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

import org.springdoc.core.properties.AbstractSwaggerUiConfigProperties.SwaggerUrl
import org.springdoc.core.properties.SwaggerUiConfigParameters
import org.springdoc.core.properties.SwaggerUiConfigProperties
import org.springframework.beans.factory.annotation.Value
import org.springframework.cloud.gateway.route.RouteDefinition
import org.springframework.cloud.gateway.route.RouteDefinitionLocator
import org.springframework.context.annotation.Configuration
import org.springframework.scheduling.annotation.EnableScheduling
import org.springframework.scheduling.annotation.Scheduled


/**
 * @author Enaium
 */
@Configuration
@EnableScheduling
class SpringDocConfiguration(
    val configProperties: SwaggerUiConfigProperties,
    val routeLocator: RouteDefinitionLocator,
    @Value("\${spring.application.name}") val name: String
) {
    @Scheduled(fixedDelay = 5)
    fun apis() {
        configProperties.urls = routeLocator.routeDefinitions.collectList().block()!!.filter { route: RouteDefinition ->
            route.uri.host != null && route.uri.host != name
        }.distinct().map { route: RouteDefinition ->
            SwaggerUrl().apply {
                name = route.uri.host
                url = "/api/${name.substring(0, name.indexOf("-service"))}/v3/api-docs"
            }
        }.toSet()
    }
}