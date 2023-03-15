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

import NoticeList from "@/components/notice/NoticeList.vue";
import {useUserStatus} from "@/store";

const userStatus = useUserStatus()

</script>

<template>
  <div class="fill-width">
    <div class="shrink">
      <div style="margin: 1rem 0"/>
      <n-grid :x-gap="12" :y-gap="12" :cols="4" layout-shift-disabled>
        <n-gi :span="3">
          <notice-list :user="userStatus.getId"/>
        </n-gi>
        <n-gi>
          <n-card>

          </n-card>
        </n-gi>
      </n-grid>
    </div>
  </div>
</template>

<style scoped>

</style>
