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
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
import {reactive} from "vue";
import {IAnswer, IComment} from "@/util/model";
import {commentInfo} from "@/util/request";
import CommentItem from "@/components/comment/CommentItem.vue";

const props = defineProps<{
  answer: IAnswer
}>()

const data = reactive({
  comment: <IComment>{}
})

commentInfo(props.answer.commentId).then(r => {
  data.comment = r.content
})
</script>

<template>
  <n-collapse>
    <n-collapse-item>
      <template #header>
        <n-text type="success">
          Answer
        </n-text>
      </template>
      <template #header-extra>
        <n-text type="success">
          Accepted
          <n-tooltip trigger="hover">
            <template #trigger>
              <n-time :time="Date.now()" :to="props.answer.createTime"
                      type="relative"/>
            </template>
            {{ new Date(props.answer.createTime).toLocaleString() }}
          </n-tooltip>
        </n-text>
      </template>
      <comment-item :data="data.comment" :answer="false"/>
    </n-collapse-item>
  </n-collapse>
</template>

<style scoped>

</style>
