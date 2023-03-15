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

package cn.enaium.nurupoga.resolver

import cn.enaium.nurupoga.annotation.Optional
import cn.enaium.nurupoga.annotation.OptionalBody
import cn.enaium.nurupoga.exception.OptionalException
import com.fasterxml.jackson.databind.ObjectMapper
import jakarta.servlet.http.HttpServletRequest
import org.springframework.core.MethodParameter
import org.springframework.stereotype.Component
import org.springframework.web.bind.annotation.ValueConstants
import org.springframework.web.bind.support.WebDataBinderFactory
import org.springframework.web.context.request.NativeWebRequest
import org.springframework.web.method.support.HandlerMethodArgumentResolver
import org.springframework.web.method.support.ModelAndViewContainer
import java.lang.reflect.ParameterizedType
import kotlin.reflect.KParameter
import kotlin.reflect.jvm.kotlinFunction

/**
 * @author Enaium
 */
@Component
class OptionalArgumentResolver(val jackson: ObjectMapper) : HandlerMethodArgumentResolver {
    override fun supportsParameter(parameter: MethodParameter): Boolean {
        return parameter.method!!.isAnnotationPresent(OptionalBody::class.java) && parameter.hasParameterAnnotation(
            Optional::class.java
        )
    }

    override fun resolveArgument(
        parameter: MethodParameter,
        mavContainer: ModelAndViewContainer?,
        webRequest: NativeWebRequest,
        binderFactory: WebDataBinderFactory?
    ): Any? {

        val optional = parameter.getParameterAnnotation(Optional::class.java)!!

        val default = optional.default
        var nullable = optional.nullable
        var require = optional.require
        val field = if (optional.value == ValueConstants.DEFAULT_NONE) parameter.parameterName else optional.value

        parameter.toKParameter()?.let {
            nullable = it.type.isMarkedNullable == true
            require = it.type.isMarkedNullable == false
        }

        webRequest.getNativeRequest(HttpServletRequest::class.java)?.let {
            val content: String
            val body = it.getAttribute("body")

            if (body == null) {
                content = it.reader.readText().ifBlank { "{}" }
                it.setAttribute("body", content)
            } else {
                content = body.toString()
            }

            val map = jackson.readValue(
                content,
                Map::class.java
            )

            if (require && !nullable && default == ValueConstants.DEFAULT_NONE) {
                if (!map.containsKey(field) && !it.headerNames.toList().contains(field)) {
                    throw OptionalException("'$field' is require")
                }
            }

            var argument = map[field] ?: it.getHeader(field)

            if (!nullable && default == ValueConstants.DEFAULT_NONE) {
                if (argument == null) {
                    throw OptionalException("the value of '$field' can't be null")
                }
            }

            if (argument == null && default != ValueConstants.DEFAULT_NONE) {
                argument = default
            }


            argument ?: return null


            if (Collection::class.java.isAssignableFrom(parameter.parameterType)) {
                return jackson.readValue(
                    jackson.writeValueAsString(argument), jackson.typeFactory.constructCollectionType(
                        Collection::class.java,
                        (parameter.genericParameterType as ParameterizedType).actualTypeArguments[0] as Class<*>
                    )
                )
            } else {
                binderFactory?.let {
                    val createBinder = binderFactory.createBinder(webRequest, null, parameter.parameterName!!)
                    return createBinder.convertIfNecessary(argument, parameter.parameterType, parameter)
                }
            }

            return argument
        }
        return null
    }

    /**
     * @see <a href="https://github.com/springdoc/springdoc-openapi/blob/d8da2edc90d9d294adb4f71a1240d9a676f6b267/springdoc-openapi-kotlin/src/main/java/org/springdoc/kotlin/SpringDocKotlinConfiguration.kt#L90">springdoc-openapi-kotlin<a/>
     */
    private fun MethodParameter.toKParameter(): KParameter? {
        // ignore return type, see org.springframework.core.MethodParameter.getParameterIndex
        if (parameterIndex == -1) return null
        val kotlinFunction = method?.kotlinFunction ?: return null
        // The first parameter of the kotlin function is the "this" reference and not needed here.
        // See also kotlin.reflect.KCallable.getParameters
        return kotlinFunction.parameters[parameterIndex + 1]
    }
}