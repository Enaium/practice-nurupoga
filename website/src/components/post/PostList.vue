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
import {ref, watch} from "vue";
import {IPage, IPost, OrderType, PostType} from "@/util/model";
import http from "@/util/http";
import PostItem from "@/components/post/PostItem.vue";

const props = defineProps<{
  type: PostType
  order: OrderType,
  user: number,
  tag: number
}>()

const post = ref(<IPage<IPost>>{})

const refresh = () => {
  window.$loading.start()
  http.post("/post/all", {
    current: post.value.current,
    type: props.type,
    order: props.order,
    user: props.user,
    tag: props.tag
  }).then(r => {
    post.value = r.data.content
    window.$loading.finish()
  })
}

refresh()

watch(() => props, () => {
  refresh()
}, {
  deep: true
})

watch(() => props.type, () => {
  post.value.current = 1
})

const changePage = (page: number) => {
  post.value.current = page
  refresh()
}
</script>

<template v-if="post">
  <n-list bordered>
    <n-list-item v-for="record in post.records">
      <post-item :key="record.id" :data="record"/>
    </n-list-item>
    <n-space justify="center"  v-if="post.pages > 1">
      <n-pagination v-model:page="post.current" :page-count="post.pages"
                    :on-update:page="changePage"/>
    </n-space>
  </n-list>
</template>

<style scoped>

</style>
