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

import http from "@/util/http";
import {FollowType, IComment, IPage, IPost, IResult, IUser} from "@/util/model";

export const isLogin = async (): Promise<IResult<boolean>> => {
    return (await http.post("/auth/isLogin")).data
}

export const loginId = async (): Promise<IResult<number>> => {
    return (await http.post("/auth/id")).data
}

export const userInfo = async (id: number): Promise<IResult<IUser>> => {
    return (await http.post("/user/info", {id})).data
}

export const postInfo = async (id: number): Promise<IResult<IPost>> => {
    return (await http.post("/post/info", {id})).data
}

export const commentInfo = async (id: number): Promise<IResult<IComment>> => {
    return (await http.post("/comment/info", {id})).data
}

export const isFollowing = async (target: number): Promise<IResult<boolean>> => {
    return (await http.post("/follow/isFollowing", {target})).data
}

export const getFollowerCount = async (who: number): Promise<IResult<number>> => {
    return (await http.post("/follow/followerCount", {who})).data
}

export const getFollowingCount = async (who: number): Promise<IResult<number>> => {
    return (await http.post("/follow/followingCount", {who})).data
}

export const follows = async (type: FollowType, who: number): Promise<IResult<IPage<IUser>>> => {
    return (await http.post(`/follow/${type}`, {who})).data
}

export const getNoticeCount = async (user: number | null): Promise<IResult<number>> => {
    return (await http.post("/notice/unreadCount", {user})).data
}

export const getRoles = async (): Promise<IResult<string[]>> => {
    return (await http.post("/auth/roles")).data
}

export const hasRole = async (role: string): Promise<IResult<boolean>> => {
    return (await http.post("/auth/hasRole", {role})).data
}