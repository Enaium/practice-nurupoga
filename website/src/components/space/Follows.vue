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
import {useRoute} from "vue-router";
import {follows} from "@/util/request";
import {ref, watch} from "vue";
import {FollowType, IUser} from "@/util/model";
import UserItem from "@/components/space/UserItem.vue";

const props = defineProps<{
  id: number
}>()

const route = useRoute()

const users = ref<IUser[]>()

const refresh = () => {
  if (route.query.type) {
    follows(route.query.type as unknown as FollowType, props.id).then(r => {
      users.value = r.content.records
    })
  }
}

refresh()

watch(() => route.query.type, () => {
  refresh()
})

</script>

<template>
  <n-list bordered>
    <n-list-item v-for="u in users" v-if="users">
      <user-item :key="u.id" :user="u"/>
    </n-list-item>
  </n-list>
</template>

<style scoped>

</style>
