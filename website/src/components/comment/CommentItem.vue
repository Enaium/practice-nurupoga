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
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
import {computed, ref} from "vue";
import {IComment, IUser} from "@/util/model";
import {userInfo} from "@/util/request";
import Avatar from "@/components/Avatar.vue";
import http from "@/util/http";
import {useUserStatus} from "@/store";

const props = defineProps<{
  data: IComment
  acceptable: boolean
}>()

const userStatus = useUserStatus();

const user = ref(<IUser>{})

const showEdit = ref(false)

userInfo(props.data.userId).then(r => {
  user.value = r.content
})

const uname = computed(() => user.value.nickname ? user.value.nickname : user.value.username)

const accept = () => {
  window.$dialog.warning({
    title: 'Warning',
    content: 'Do you want to accept this answer?',
    positiveText: 'Yes',
    negativeText: 'No',
    onPositiveClick: () => {
      http.post("/post/accept", {
        post: props.data.postId,
        comment: props.data.id
      })
    }
  })
}

const publish = () => {
  http.post("/comment/publish", {id: props.data.id, content: props.data.content}).then(r => {
    if (r.data.code == 200) {
      window.$message.success("Published success")
    }
  })
}
</script>

<template>
  <n-space justify="space-between" align="center">
    <n-space align="center">
      <avatar :size="32" :avatar="user.avatar"/>
      <div>{{ uname }}</div>
      <div>Replied</div>
      <n-tooltip trigger="hover">
        <template #trigger>
          <n-time :time="Date.now()" :to="props.data.createTime"
                  type="relative"/>
        </template>
        {{ new Date(props.data.createTime).toLocaleString() }}
      </n-tooltip>
    </n-space>
    <div>
      <n-button text type="primary" @click="showEdit = !showEdit" v-if="props.data.userId === userStatus.getId">Edit
      </n-button>
      <n-button v-if="props.acceptable" type="primary" @click="accept">Accept</n-button>
    </div>
  </n-space>
  <md-editor v-model="props.data.content" preview-only/>
  <n-modal v-model:show="showEdit" preset="card" title="Edit Comment">
    <md-editor v-model="props.data.content"/>
    <n-button type="primary" @click="publish">
      Publish
    </n-button>
  </n-modal>
</template>

<style scoped>

</style>
