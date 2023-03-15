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
import NoticeItem from "@/components/notice/NoticeItem.vue";
import http from "@/util/http";
import {ref} from "vue";
import {INotice, IPage} from "@/util/model";
import {useUserStatus} from "@/store";

const userStatus = useUserStatus();

const props = defineProps<{
  user: number
  small: boolean
}>()

const notice = ref(<IPage<INotice>>{})

const refresh = () => {
  window.$loading.start()
  http.post("/notice/all", {
    user: userStatus.getId,
    current: notice.value.current,
    size: props.small ? 5 : undefined
  }).then(r => {
    notice.value = r.data.content
    window.$loading.finish()
  })
}

refresh()

const changePage = (page: number) => {
  notice.value.current = page
  refresh()
}
</script>

<template>
  <n-list bordered>
    <n-list-item v-for="n in notice.records">
      <notice-item :key="n.id" :data="n"/>
    </n-list-item>
    <n-space justify="center" v-if="notice.pages > 1 && !props.small">
      <n-pagination v-model:page="notice.current" :page-count="notice.pages"
                    :on-update:page="changePage"/>
    </n-space>
  </n-list>
  <div v-if="props.small">
    <n-button text type="primary" @click="this.$router.push({name:'notice'})">See All Notice</n-button>
  </div>
</template>

<style scoped>

</style>
