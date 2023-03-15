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
import http from "@/util/http";
import {h, reactive, ref} from "vue";
import {IPage, IPost, IUser} from "@/util/model";
import dayjs from "dayjs";
import {NSwitch} from "naive-ui";

const condition = reactive({
  id: undefined,
  username: undefined,
  nickname: undefined,
  description: undefined,
  dateRange: undefined,
  invalid: undefined,
})

const user = ref(<IPage<IUser>>{})

const refresh = () => {
  http.post("/user/all", {current: user.value.current, ...condition}).then(r => {
    user.value = r.data.content
  })
}

refresh()

const columns = [
  {
    title: "ID",
    key: "id"
  },
  {
    title: "Username",
    key: "username"
  },
  {
    title: "Nickname",
    key: "nickname"
  },
  {
    title: "Description",
    key: "description"
  },
  {
    title: "Register Time",
    key: "createTime",
    width: 170,
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
  user.value.current = page
  refresh()
}

const confirmEdit = () => {
  window.$dialog.warning({
    title: 'Warning',
    content: 'Do you want to confirm all the edited?',
    positiveText: 'Yes',
    negativeText: 'No',
    onPositiveClick: () => {
      user.value.records.forEach(user => {
        http.post("/user/publish", user).then(r => {
          if (r.data.code != 200) {
            window.$message.error(`The Post "${user.username.substring(0, 20)}" is publish fail`)
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
      <n-form-item label="ID">
        <n-input-number v-model:value="condition.id" clearable/>
      </n-form-item>
      <n-form-item label="Username">
        <n-input v-model:value="condition.username" clearable/>
      </n-form-item>
      <n-form-item label="Nickname">
        <n-input v-model:value="condition.nickname" clearable/>
      </n-form-item>
      <n-form-item label="Description">
        <n-input v-model:value="condition.description" clearable/>
      </n-form-item>
      <n-form-item label="Publish Time">
        <n-date-picker v-model:value="condition.dateRange" type="daterange" clearable/>
      </n-form-item>
      <n-form-item label="Invalid">
        <n-switch v-model:value="condition.invalid"/>
      </n-form-item>
      <n-form-item>
        <n-button type="primary" @click="refresh">
          Find
        </n-button>
      </n-form-item>
    </n-form>
  </n-card>
  <div style="margin: 1rem 0"/>
  <n-card title="Users">
    <n-data-table
        :columns="columns"
        :data="user.records"
        :single-line="false"
        :max-height="500"
    />
    <div style="margin: 1rem 0"/>
    <n-space justify="space-between">
      <n-pagination v-model:page="user.current" :page-count="user.pages"
                    :on-update:page="changePage"/>
      <n-button type="primary" @click="confirmEdit">
        Confirm Edit
      </n-button>
    </n-space>
  </n-card>
</template>

<style scoped>

</style>
