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
import {IPage, IPost, PostType} from "@/util/model";
import {h, reactive, ref} from "vue";
import http from "@/util/http";
import dayjs from "dayjs";
import {NSwitch, NSelect, NButton} from "naive-ui";

const postTypeOption = [
  {
    label: PostType.QUESTION,
    value: PostType.QUESTION
  },
  {
    label: PostType.ARTICLE,
    value: PostType.ARTICLE
  }
]

const condition = reactive({
  title: undefined,
  content: undefined,
  type: PostType.QUESTION,
  dateRange: undefined,
  invalid: undefined,
  user: undefined
})

const post = ref(<IPage<IPost>>{})

const refresh = () => {
  http.post("/post/all", {current: post.value.current, ...condition}).then(r => {
    post.value = r.data.content
  })
}

refresh()

const columns = [
  {
    title: "Title",
    key: "title",
    width: 500,
    render(item: IPost) {
      return item.title
    }
  },
  {
    title: "Reply",
    key: 'reply',
    width: 70
  },
  {
    title: "Vote",
    key: 'vote',
    width: 70
  },
  {
    title: "View",
    key: "view",
    width: 70
  },
  {
    title: "Type",
    key: "type",
    width: 150
  },
  {
    title: "User",
    key: "userId",
    width: 100,
    render(item: IPost) {
      return h(
          NButton,
          {
            type: "primary",
            text: true,
            onClick() {
              window.$router.push({name: "space", params: {id: item.userId}})
            }
          },
          {default: () => item.userId}
      )
    }
  },
  {
    title: "Publish Time",
    key: "createTime",
    width: 200,
    render(item: IPost) {
      return dayjs(item.createTime).format("YYYY-MM-DD HH:MM:ss")
    }
  },
  {
    title: "Invalid",
    key: "invalid",
    width: 80,
    render(item: IPost) {
      return h(NSwitch, {
        value: item.invalid,
        onUpdateValue: (value: boolean) => {
          item.invalid = value
        }
      })
    }
  }
]

const changePage = (page: number) => {
  post.value.current = page
  refresh()
}

const confirmEdit = () => {
  window.$dialog.warning({
    title: 'Warning',
    content: 'Do you want to confirm all the edited?',
    positiveText: 'Yes',
    negativeText: 'No',
    onPositiveClick: () => {
      post.value.records.forEach(post => {
        http.post("/post/publish", post).then(r => {
          if (r.data.code != 200) {
            window.$message.error(`The Post "${post.title.substring(0, 20)}" is publish fail`)
          }
        })
      })
    }
  })
}
</script>

<template>
  <n-card title="Condition">
    <n-form>
      <n-form-item label="Title">
        <n-input v-model:value="condition.title" clearable/>
      </n-form-item>
      <n-form-item label="Content">
        <n-input v-model:value="condition.content" clearable/>
      </n-form-item>
      <n-form-item label="Type">
        <n-select v-model:value="condition.type" :options="postTypeOption"/>
      </n-form-item>
      <n-form-item label="Publish Time">
        <n-date-picker v-model:value="condition.dateRange" type="daterange" clearable/>
      </n-form-item>
      <n-form-item label="Invalid">
        <n-switch v-model:value="condition.invalid"/>
      </n-form-item>
      <n-form-item label="User">
        <n-input-number v-model:value="condition.user" clearable/>
      </n-form-item>
      <n-form-item>
        <n-button type="primary" @click="refresh">
          Find
        </n-button>
      </n-form-item>
    </n-form>
  </n-card>
  <div style="margin: 1rem 0"/>
  <n-card title="Posts">
    <n-data-table
        :columns="columns"
        :data="post.records"
        :single-line="false"
        :max-height="500"
    />
    <div style="margin: 1rem 0"/>
    <n-space justify="space-between">
      <n-pagination v-model:page="post.current" :page-count="post.pages"
                    :on-update:page="changePage"/>
      <n-button type="primary" @click="confirmEdit">
        Confirm Edit
      </n-button>
    </n-space>
  </n-card>

</template>

<style scoped>

</style>
