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

package cn.enaium.nurupoga.model.wrapper/*
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

/**
 * @author Enaium
 */
data class ResultWrapper<T>(val success: Boolean, val code: Int, val message: String, val content: T?)
object Builder {
    fun <T> success(
        status: Status = Status.SUCCESS,
        message: String = status.message,
        content: T? = null
    ): ResultWrapper<T> {
        return ResultWrapper(true, status.code, message, content)
    }

    fun <T> fail(
        status: Status = Status.FAIL,
        message: String = status.message,
        content: T? = null
    ): ResultWrapper<T> {
        return ResultWrapper(false, status.code, message, content)
    }
}

enum class Status(val code: Int, val message: String) {
    SUCCESS(200, "success"),
    FAIL(999, "Fail"),
    PARAM_ERROR(1001, "Param Error"),
    USER_EXIST(2001, "User Exist"),
    USER_NOT_MATCH(2002, "Username Or Password Not Match"),
    NO_TAG(2003, "No tag"),
    POST_DOESNT_EXIST(2004, "This post doesn't exist"),
    ANSWER_HAS_ACCEPTED(2005, "This answer has accepted"),
    NOT_LOGIN(2006, "Not Login"),
    FOLLOW_SELF(2008, "Unable to follow yourself"),
    FOLLOWED(2009, "Followed"),
    GITEE_NOT_REGISTER(2010, "You haven't registered with gitee"),
    USER_DOESNT_EXIST(20011, "The user doesn't exist"),
    POST_INVALID(20012, "The post is invalid"),
    COMMENT_INVALID(20013, "The comment is invalid"),
    USER_INVALID(20014, "The user is invalid"),
    COMMENT_DOESNT_EXIST(2015, "This comment doesn't exist"),
    NO_PERMISSION(3001, "No Permission");
}
