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

import {createRouter, createWebHistory} from "vue-router";
import Question from "@/pages/Question.vue";
import Home from "@/layouts/Home.vue";
import Article from "@/pages/Article.vue";
import Tag from "@/pages/Tag.vue";
import Publish from "@/pages/Publish.vue";
import Login from "@/pages/Login.vue";
import Register from "@/pages/Register.vue";
import Post from "@/pages/Post.vue";
import Space from "@/layouts/Space.vue";
import Gitee from "@/pages/Gitee.vue";
import Posts from "@/components/space/Posts.vue";
import Follows from "@/components/space/Follows.vue";
import Notice from "@/pages/Notice.vue";
import Backstage from "@/layouts/Backstage.vue";
import PostManager from "@/pages/backstage/PostManager.vue";
import CommentManager from "@/pages/backstage/CommentManager.vue";
import UserManager from "@/pages/backstage/UserManager.vue";
import {getRoles} from "@/util/request";
import {RoleType} from "@/util/model";

const router = createRouter({
    history: createWebHistory(),
    routes: [
        {
            path: "/",
            component: Home,
            redirect: "question",
            children: [
                {
                    name: "question",
                    path: "question/:order?",
                    props: true,
                    component: Question
                },
                {
                    name: "article",
                    path: "article/:order?",
                    props: true,
                    component: Article
                },
                {
                    name: "tag",
                    path: "tag",
                    component: Tag
                },
                {
                    name: "post",
                    path: "post",
                    component: Post
                },
                {
                    name: "publish",
                    path: "publish/:type",
                    props: true,
                    component: Publish
                },
                {
                    name: "space",
                    path: "space/:id",
                    component: Space,
                    props: true,
                    redirect: {name: "space-posts"},
                    children: [
                        {
                            name: 'space-posts',
                            path: "posts",
                            component: Posts
                        },
                        {
                            name: 'space-follows',
                            path: "follows",
                            component: Follows
                        }
                    ]
                },
                {
                    name: "tag/:id",
                    path: "tag",
                    props: true,
                    component: Tag
                },
                {
                    name: "notice",
                    path: "notice",
                    component: Notice
                }
            ]
        },
        {
            path: "/backstage",
            component: Backstage,
            redirect: {name: "post-manager"},
            children: [
                {
                    path: "post",
                    name: "post-manager",
                    component: PostManager
                },
                {
                    path: "comment",
                    name: "comment-manager",
                    component: CommentManager
                },
                {
                    path: "user",
                    name: "user-manager",
                    component: UserManager
                }
            ]
        },
        {
            path: "/login",
            name: "login",
            component: Login
        },
        {
            path: "/register",
            name: "register",
            component: Register
        },
        {
            path: "/gitee",
            name: "gitee",
            component: Gitee
        }
    ]
})

router.beforeEach(async (to, from, next) => {
    if (to.fullPath.startsWith("/backstage")) {
        const roles = (await getRoles()).content;
        if (roles.indexOf(RoleType.OWNER) != -1 || roles.indexOf(RoleType.ADMIN) != -1) {
            next()
        }
    } else {
        next()
    }
})

export default router