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


export interface IResult<T> {
    success: boolean
    code: number
    message: string
    content: T
}

export enum PostType {
    QUESTION = "question", ARTICLE = "article"
}

export enum OrderType {
    LATEST = "latest", ANSWERED = "answered", UNANSWERED = "unanswered", REPLY = "reply", UNREPLIED = "unreplied"
}

export enum GiteeType {
    REGISTER = "register", BIND = "bind"
}

export enum FollowType {
    FOLLOWERS = "followers", FOLLOWING = "following"
}

export enum NoticeType {
    PUBLISH_COMMENT = "publish_comment", PUBLISH_POST = "publish_post", ANSWER_ACCEPTED = "answer_has_been_accepted"
}

export enum RoleType {
    OWNER = "owner", ADMIN = "admin", USER = "user", BANNED = "banned",
}

export interface IPage<T> {
    records: T[]
    pages: number
    current: number
}

export interface ITag {
    id: number
    name: string
}

export interface IPost {
    id: number
    userId: number
    title: string
    content: string
    vote: number
    reply: number
    view: number
    tag: ITag[]
    type: PostType
    createTime: number
    updateTime: number
    answeredTime: number
    invalid: boolean
    answer: IAnswer
}

export interface IAnswer {
    id: number
    postId: number
    commentId: number
    createTime: number
}

export interface IComment {
    id: number
    postId: number
    userId: number
    content: string
    vote: number
    type: PostType
    createTime: number
    updateTime: number
    invalid: boolean
}

export interface IUser {
    id: number
    username: string
    createTime: number
    updateTime: number
    invalid: boolean
    nickname: string
    description: string
    avatar: string
}

export interface INotice {
    id: number
    userId: number
    type: NoticeType
    self: number
    at: number
    createTime: number,
    unread: boolean
}