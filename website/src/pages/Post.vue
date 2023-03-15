<!--
  - Copyright (c) 2023 Enaium
  -
  - Permission is hereby granted, free of charge, to any person obtaining a copy
  - of this software and associated documentation files (the "Software"), to deal
  - in the Software without restriction, including without limitation the rights
  - to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  - copies of the Software, and to permit persons to whom the Software is
  - furnished to do so, subject to the following conditions:
  -
  - The above copyright notice and this permission notice shall be included in all
  - copies or substantial portions of the Software.
  -
  - THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  - IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  - FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  - AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  - LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  - OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  - SOFTWARE.
  -->

<script setup lang="ts">
import {useRoute} from "vue-router";
import {computed, reactive, ref} from "vue";
import http from "@/util/http";
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
import AskBanner from "@/components/AskBanner.vue";
import {FormInst} from "naive-ui";
import CommentList from "@/components/comment/CommentList.vue";
import UserCard from "@/components/UserCard.vue";
import {IPost, PostType} from "@/util/model";
import {postInfo} from "@/util/request";
import Answer from "@/components/Answer.vue";
import {useUserStatus} from "@/store";

const route = useRoute()
const userStatus = useUserStatus()

const data = reactive({
  post: <IPost>{},
  comment: {
    content: undefined
  }
})

const timeText = computed(() => {
  return data.post.type === PostType.QUESTION ? "Asked" : "Published";
})

const timeDate = computed(() => {
  return data.post.answeredTime ? data.post.answeredTime : data.post.createTime
})
window.$loading.start()
postInfo(Number(route.query.id)).then(r => {
  data.post = r.content
  window.$loading.finish()
})

if (route.query.comment) {

}

const rules = {
  content: {
    required: true,
    message: "Please input comment",
    trigger: "blur"
  }
}

const commentRef = ref<FormInst | null>(null)

const publish = () => {
  commentRef.value?.validate((errors) => {
    if (!errors) {
      http.post("/comment/publish", {post: data.post.id, content: data.comment.content}).then(r => {
        if (r.data.code === 200) {
          data.comment.content = undefined
        }
      })
    } else {
      window.$message.error(errors[0][0].message)
    }
  })
}
</script>

<template>
  <div class="fill-width">
    <div class="shrink">
      <div style="margin: 1rem 0"/>
      <n-grid :x-gap="12" :y-gap="12" :cols="4" layout-shift-disabled>
        <n-gi :span="3">
          <ask-banner :title="data.post.title" :type="data.post.type"/>
          <n-space vertical>
            <n-card>
              <md-editor v-model="data.post.content" preview-only v-if="data.post.content"/>
              <answer :answer="data.post.answer" v-if="data.post.answer"/>
            </n-card>
            <n-form label-placement="left" :rules="rules" :model="data.comment" ref="commentRef">
              <n-form-item path="content">
                <md-editor v-model="data.comment.content"/>
              </n-form-item>
              <n-form-item>
                <n-button type="primary" @click="publish">
                  Publish
                </n-button>
              </n-form-item>
            </n-form>
            <div id="comment"/>
            <comment-list :id="data.post.id" v-if="data.post.id" :comment="route.query.comment"
                          :acceptable="data.post.userId === userStatus.getId && data.post.type === PostType.QUESTION && !data.post.answer"/>
          </n-space>
        </n-gi>
        <n-gi>
          <n-space vertical>
            <user-card :id="data.post.userId" v-if="data.post.userId"/>
            <n-card>
              <n-space justify="space-between">
                <div>
                  {{ timeText }}
                  <n-tooltip trigger="hover">
                    <template #trigger>
                      <n-time :time="Date.now()" :to="timeDate"
                              type="relative"/>
                    </template>
                    {{ new Date(timeDate).toLocaleString() }}
                  </n-tooltip>
                </div>
                <div>View:{{ data.post.view }}</div>
              </n-space>
              <n-button v-if="data.post.userId === userStatus.getId" type="primary" style="width: 100%"
                        @click="this.$router.push({name:'publish',params:{type:data.post.type},query:{id:data.post.id}})">
                Edit
              </n-button>
              <n-space justify="space-between">
                <n-button @click="()=>{
                  data.post.vote++
                  http.post('/post/voteUp',{post:data.post.id})
                }">
                  <template #icon>
                    <n-icon size="40">
                      <svg aria-hidden="true" class="svg-icon iconArrowUpLg" width="36" height="36" viewBox="0 0 36 36">
                        <path d="M2 25h32L18 9 2 25Z"></path>
                      </svg>
                    </n-icon>
                  </template>
                </n-button>
                <div>
                  {{ data.post.vote }}
                </div>
                <n-button @click="()=>{
                  data.post.vote--
                  http.post('/post/voteDown',{post:data.post.id})
                }">
                  <template #icon>
                    <n-icon size="40">
                      <svg aria-hidden="true" class="svg-icon iconArrowDownLg" width="36" height="36"
                           viewBox="0 0 36 36">
                        <path d="M2 11h32L18 27 2 11Z"></path>
                      </svg>
                    </n-icon>
                  </template>
                </n-button>
              </n-space>
            </n-card>
          </n-space>
        </n-gi>
      </n-grid>
      <n-back-top :right="100"/>
    </div>
  </div>
</template>

<style scoped>
</style>
