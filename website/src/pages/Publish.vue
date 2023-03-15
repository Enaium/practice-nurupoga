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
import {IPost, PostType} from "@/util/model";
import {reactive, ref} from "vue";
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
import {FormInst, NTag} from "naive-ui";
import http from "@/util/http";
import {useRoute} from "vue-router";
import {postInfo} from "@/util/request";

const props = defineProps<{
  type: PostType
}>()

const data = reactive({
  post: <IPost><unknown>{
    tag: [],
    type: props.type
  }
})

if (useRoute().query.id) {
  postInfo(Number(useRoute().query.id)).then(r => {
    data.post = r.content
  })
}

const rules = {
  title: {
    required: true,
    message: "Please input title",
    trigger: "blur"
  },
  content: {
    required: true,
    message: "Please input content",
    trigger: "blur"
  },
  tag: {
    validator(rule: unknown, value: string[]) {
      if (value.length > 5) return new Error('Only select a max of 5 tags')
      if (value.length == 0) return new Error('Must select 1 tag')
      return true
    }
  }
}

const publishRef = ref<FormInst | null>(null)

const publish = () => {
  publishRef.value?.validate((errors) => {
    if (!errors) {
      http.post("/post/publish", data.post).then(r => {
        if (r.data.code === 200) {
          window.$router.back()
        }
      })
    } else {
      window.$message.error(errors[0][0].message)
    }
  })
}

const createTag = (tag: string) => {
  http.post("/tag/create", {tag}).then(r => {
    data.post.tag.push(r.data.content)
  })
}

</script>

<template>
  <div style="margin-left: 5rem;margin-right: 5rem">
    <n-form ref="publishRef" :rules="rules" :model="data.post">
      <n-form-item path="title">
        <n-input class="fs28" placeholder="Please input title" v-model:value="data.post.title"/>
      </n-form-item>
      <n-form-item path="tag">
        <n-tag v-for="(tag,index) in data.post.tag" closable @close="data.post.tag.splice(index, 1)" :key="tag.id">
          {{ tag.name }}
        </n-tag>
        <n-dynamic-tags :value="[]" @create="createTag"/>
      </n-form-item>
      <n-form-item path="content">
        <md-editor v-model="data.post.content"/>
      </n-form-item>
      <n-form-item>
        <n-button type="primary" @click="publish">
          Publish
        </n-button>
      </n-form-item>
    </n-form>
  </div>
</template>

<style scoped>

</style>
