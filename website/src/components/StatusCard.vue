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

import {ref} from "vue";
import {getNoticeCount, getRoles, isLogin} from "@/util/request";
import http from "@/util/http";
import {useUserStatus} from "@/store";
import NoticeList from "@/components/notice/NoticeList.vue";
import {RoleType} from "@/util/model";

const userStatus = useUserStatus();

const login = ref(true)

const showNotice = ref(false)

const noticeCount = ref(0)

const options = [
  {
    label: 'Space',
    key: 'space',
    props: {
      onClick: () => {
        window.$router.push({name: "space", params: {id: userStatus.id}})
      }
    }
  },
  {
    label: 'Notice',
    key: 'notice',
    props: {
      onClick: () => {
        showNotice.value = !showNotice.value
      }
    }
  },
  {
    label: 'Logout',
    key: 'logout',
    props: {
      onClick: () => {
        window.$dialog.warning({
          title: 'Warning',
          content: 'Do you want to logout?',
          positiveText: 'Yes',
          negativeText: 'No',
          onPositiveClick: () => {
            http.post("/auth/logout").then(r => {
              if (r.data == 200) {
                window.$message.success("logout")
                userStatus.setId(null)
                userStatus.setToken(null)
              }
            })
          }
        })
      }
    }
  }
]

isLogin().then(r => {
  login.value = r.content
  if (login.value) {
    getNoticeCount(userStatus.getId).then(r => {
      noticeCount.value = r.content
    })
    getRoles().then(r => {
      if (r.content.indexOf(RoleType.OWNER) != -1 || r.content.indexOf(RoleType.ADMIN) != -1) {
        options.push({
          label: 'Backstage',
          key: 'backstage',
          props: {
            onClick: () => {
              window.$router.push({path: "/backstage"})
            }
          }
        },)
      }
    })
  }
})

</script>

<template>
  <n-card title="Welcome to nurupoga?">
    <div v-if="login">
      <n-badge class="fill-width" :value="noticeCount" :max="99">
        <n-dropdown trigger="click" :options="options">
          <n-button class="fill-width">Profile</n-button>
        </n-dropdown>
      </n-badge>
    </div>
    <n-button v-else class="fill-width" type="primary" @click="this.$router.push({name:'login'})">Login</n-button>
  </n-card>
  <n-modal v-model:show="showNotice" preset="dialog" title="Notice">
    <notice-list :user="userStatus.getId" small/>
  </n-modal>
</template>

<style scoped>

</style>
