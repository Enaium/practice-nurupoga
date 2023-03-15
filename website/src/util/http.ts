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

import axios from "axios";
import {useUserStatus} from "@/store";

const http = axios.create({
    baseURL: 'http://localhost:8080/api'
})

http.interceptors.request.use(config => {
    if (useUserStatus().token) {
        if (typeof config.headers?.set === 'function') {
            config.headers.set('token', useUserStatus().token);
        }
    }
    return config
}, error => Promise.reject(error))

http.interceptors.response.use(response => {
    if (response.data.code === 2006) {
        window.$router.push({path: "/login"})
    }

    if (response.data.code != 200) {
        window.$message.error(response.data.message)
    }

    return response
}, error => {
    window.$message.error("Request Blocked")
    Promise.reject(error).then(r => r)
})

export default http
