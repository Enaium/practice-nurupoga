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
import {reactive, ref} from "vue";
import {FormInst} from "naive-ui";
import http from "@/util/http";

const data = reactive({
  form: {
    username: '',
    password: '',
    role: 0
  }
})

const rules = {
  username: {
    required: true,
    message: 'Please input username',
    trigger: 'blur'
  },
  password: {
    required: true,
    message: 'Please input password',
    trigger: ['blur']
  }
}

const registerRef = ref<FormInst | null>(null)

const login = () => {
  registerRef.value?.validate((errors) => {
    if (!errors) {
      http.post("/auth/register", data.form).then(r => {
        if (r.data.code === 200) {
          window.$router.push({name: "login"})
        }
      });
    } else {
      window.$message.error(errors[0][0].message)
    }
  })
}
</script>

<template>
  <n-space justify="center" align="center" style="min-height: 100vh">
    <n-card title="User Register" style="min-width: 400px">
      <n-form ref="registerRef" :model="data.form" :rules="rules">
        <n-form-item label="Username" path="username">
          <n-input v-model:value="data.form.username"/>
        </n-form-item>
        <n-form-item label="Password" path="password">
          <n-input type="password" v-model:value="data.form.password"/>
        </n-form-item>

        <n-space justify="space-between" align="center">
          <n-button type="primary" @click="login">
            Register
          </n-button>
          <p>
            Already have an
            <router-link to="/login">
              <n-gradient-text type="success">account</n-gradient-text>
            </router-link>
            ?
          </p>
        </n-space>
      </n-form>
    </n-card>
  </n-space>
</template>

<style scoped>

</style>

