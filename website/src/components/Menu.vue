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
import {h} from "vue";
import {MenuOption} from "naive-ui";
import {RouterLink, useRoute, useRouter} from "vue-router";
import Title from "@/components/Title.vue";

const route = useRoute()

const menuOptions: MenuOption[] = [
  {
    label: () =>
        h(
            RouterLink,
            {
              to: {
                name: 'question'
              },
              style: {
                "font-size": "24px"
              }
            },
            {default: () => 'Question'}
        ),
    key: "question"
  },
  {
    label: () =>
        h(
            RouterLink,
            {
              to: {
                name: 'article'
              },
              style: {
                "font-size": "24px"
              }
            },
            {default: () => 'Article'}
        ),
    key: "article"
  },
  {
    label: () =>
        h(
            RouterLink,
            {
              to: {
                name: 'tag'
              },
              style: {
                "font-size": "24px"
              }
            },
            {default: () => 'Tag'}
        ),
    key: "tag"
  }
]

</script>

<template>
  <n-card>
    <n-space class="shrink" justify="space-between" align="center">
      <n-button text class="fs36" @click="this.$router.push({name:'question'})">
        <Title/>
      </n-button>
      <n-menu :options="menuOptions" mode="horizontal" :value="route.name.toString()"/>
    </n-space>
  </n-card>
</template>

<style scoped>
</style>
