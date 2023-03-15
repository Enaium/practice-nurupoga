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
import {IComment, IPage} from "@/util/model";
import http from "@/util/http";
import CommentItem from "@/components/comment/CommentItem.vue";

const props = defineProps<{
  id: number,
  comment: number,
  acceptable: boolean
}>()

const comment = ref(<IPage<IComment>>{})

const refresh = () => {
  http.post("/comment/all", {
    current: comment.value.current,
    post: props.id,
    comment: props.comment
  }).then(r => {
    comment.value = r.data.content
  })
}

refresh()

const changePage = (page: number) => {
  comment.value.current = page
  refresh()
}
</script>

<template>
  <n-list bordered>
    <n-list-item v-for="c in comment.records">
      <comment-item :key="c.id" :acceptable="props.acceptable" :data="c"/>
    </n-list-item>
    <n-space justify="center" v-if="comment.pages > 1">
      <n-pagination v-model:page="comment.current" :page-count="comment.pages"
                    :on-update:page="changePage"/>
    </n-space>
  </n-list>
</template>

<style scoped>

</style>
