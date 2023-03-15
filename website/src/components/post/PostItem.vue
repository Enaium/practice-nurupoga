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
import {computed} from "vue";
import Tag from "@/components/Tag.vue"

const props = defineProps<{
  data: IPost
}>()

const timeText = computed(() => {
  if (props.data.type === PostType.QUESTION) {
    if (props.data.answeredTime) {
      return "Answered"
    } else {
      if (props.data.createTime === props.data.updateTime) {
        return "Asked"
      } else {
        return "Replied/Update"
      }
    }
  } else {
    if (props.data.createTime === props.data.updateTime) {
      return "Published"
    } else {
      return "Replied/Update"
    }
  }
})

const timeDate = computed(() => {
  if (props.data.type === PostType.QUESTION) {
    if (props.data.answeredTime) {
      return props.data.answeredTime
    } else {
      if (props.data.createTime === props.data.updateTime) {
        return props.data.createTime
      } else {
        return props.data.updateTime
      }
    }
  } else {
    if (props.data.createTime === props.data.updateTime) {
      return props.data.createTime
    } else {
      return props.data.updateTime
    }
  }
})

const answerText = computed(() => {
  if (props.data.type === PostType.QUESTION) {
    return `${props.data.reply} answer`
  } else {
    return `${props.data.reply} reply`
  }
})
</script>

<template>
  <div style="display: flex;gap: 10px">
    <n-space vertical justify="center" align="end" style="width: 80px">
      <div>{{ props.data.vote }} votes</div>
      <n-tag v-if="props.data.answeredTime"
             :color="{ color: 'forestgreen', textColor: 'white', borderColor: 'forestgreen' }">
        {{ answerText }}
      </n-tag>
      <n-tag v-else-if="props.data.reply > 0 && props.data.type === PostType.QUESTION" type="success">{{ answerText }}</n-tag>
      <div v-else>{{ answerText }}</div>
      <div>{{ props.data.view }} view</div>
    </n-space>
    <n-space class="fill-height" justify="space-between" style="flex: 1" vertical>
      <n-button text @click="this.$router.push({name:'post',query:{id:props.data.id}})">
        {{ props.data.title }}
      </n-button>
      <n-space>
        <Tag :id="t.id" :name="t.name" v-for="t in props.data.tag"/>
      </n-space>
      <n-space justify="end">
        {{ timeText }}
        <n-tooltip trigger="hover">
          <template #trigger>
            <n-time :time="Date.now()" :to="timeDate"
                    type="relative"/>
          </template>
          {{ new Date(timeDate).toLocaleString() }}
        </n-tooltip>
      </n-space>
    </n-space>
  </div>
</template>

<style scoped>

</style>
