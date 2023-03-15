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
import {ref} from "vue";
import {ITag} from "@/util/model";
import {useRoute} from "vue-router";
import PostList from "@/components/post/PostList.vue";
import Tag from "@/components/Tag.vue"

const route = useRoute()

const tag = ref<ITag[]>()

if (!route.query.id) {
  http.post("/tag/all").then(r => {
    tag.value = r.data.content
  })
}
</script>

<template>
  <div class="fill-width">
    <div class="shrink">
      <div style="margin: 1rem 0"/>
      <n-space justify="center" align="center" v-if="!route.query.id">
        <Tag :id="t.id" :name="t.name" v-for="t in tag"/>
      </n-space>
      <post-list :tag="route.query.id" v-else/>
    </div>
  </div>
</template>

<style scoped>
</style>
