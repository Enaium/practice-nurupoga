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
import http from "@/util/http";
import {ref} from "vue";
import {GiteeType} from "@/util/model";
import {useUserStatus} from "@/store";

const route = useRoute()
const userStatus = useUserStatus()

const registered = ref(false)

if (route.query.code) {
  http.post("/gitee/auth", {
    code: route.query.code,
    type: useRoute().query.type
  }).then(r => {
    if (r.data.code === 200) {
      if (r.data.content != null) {
        userStatus.setToken(r.data.content.token)
        userStatus.setId(r.data.content.id)
        window.$router.push({name: "question"})
      } else {
        window.$message.success(r.data.message)
        window.$router.push({name: "login"})
      }
    }

    if (r.data.code != 200) {
      registered.value = false
    }
  });
}

const auth = (type: GiteeType) => {
  const id = "ae6167dc7b35e52d07e8ea6e25d9f70222d3dd2d6bc2cc8d508771a8460ceb34"
  const redirect = encodeURI(`http://localhost:5173/gitee?type=${type}`)
  window.open(`https://gitee.com/oauth/authorize?client_id=${id}&redirect_uri=${redirect}&response_type=code`, "_blank")
}

</script>

<template>
  <n-space justify="center" align="center" style="height: 100vh">
    <n-card v-if="!registered">
      <n-space>
        <n-button type="primary" @click="auth(GiteeType.REGISTER)">
          Register With Gitee
        </n-button>
        <n-button type="primary" @click="auth(GiteeType.BIND)">
          Bind With Gitee
        </n-button>
      </n-space>
    </n-card>
  </n-space>
</template>

<style scoped>

</style>
