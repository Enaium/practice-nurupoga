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
import {INotice, IUser, NoticeType} from "@/util/model";
import {computed, onMounted, ref} from "vue";
import {commentInfo, postInfo, userInfo} from "@/util/request";
import http from "@/util/http";

const props = defineProps<{
  data: INotice
}>()

const user = ref(<IUser>{})


userInfo(props.data.userId).then(r => {
  user.value = r.content
})

const uname = computed(() => user.value.nickname ? user.value.nickname : user.value.username)
const type = computed(() => {
  switch (props.data.type) {
    case NoticeType.PUBLISH_COMMENT:
      return "Published a comment"
    case NoticeType.ANSWER_ACCEPTED:
      return "Accepted a answer"
    case NoticeType.PUBLISH_POST:
      return "Published a post"
  }
})


const at = ref(<{
  action: () => any
  content: string
}>{})

switch (props.data.type) {
  case NoticeType.PUBLISH_COMMENT:
    commentInfo(props.data.self).then(r => {
      at.value.content = r.content.content
      at.value.action = () => {
        window.$router.push({name: "post", query: {id: props.data.at, comment: props.data.self}})
      }
    })
    break;
  case NoticeType.PUBLISH_POST:
    postInfo(props.data.self).then(r => {
      at.value.content = r.content.title
      at.value.action = () => {
        window.$router.push({name: "post", query: {id: props.data.self}})
      }
    })
    break;
  case NoticeType.ANSWER_ACCEPTED:
    commentInfo(props.data.at).then(r => {
      at.value.content = r.content.content
      at.value.action = () => {
        window.$router.push({name: "post", query: {id: r.content.postId, comment: r.content.id}})
      }
    })
    break;
}

</script>

<template>
  <n-space>
    <n-button text type="primary" @click="this.$router.push({name:'space',params:{ id:props.data.userId }})">{{ uname }}
    </n-button>
    <div>{{ type }}</div>
    <n-button text type="primary" @click="()=>{at.action(); http.post('/notice/read',{notice:props.data.id})}"
              v-if="at.content">
      {{ at.content.substring(0, 50) + "..." }}
    </n-button>
    <n-tooltip trigger="hover">
      <template #trigger>
        <n-time :time="Date.now()" :to="props.data.createTime"
                type="relative"/>
      </template>
      {{ new Date(props.data.createTime).toLocaleString() }}
    </n-tooltip>
    <div v-if="props.data.unread">
      <n-tag type="error">
        Unread
      </n-tag>
    </div>
    <div v-else>
      <n-tag type="primary">
        Read
      </n-tag>
    </div>
  </n-space>
</template>

<style scoped>

</style>
