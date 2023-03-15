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
import {isFollowing, loginId, userInfo} from "@/util/request";
import {ref} from "vue";
import {IUser} from "@/util/model";
import {useRoute} from "vue-router";
import UserCard from "@/components/UserCard.vue";

const props = defineProps<{
  id: number
}>()

const route = useRoute()

const user = ref(<IUser>{})

const me = ref(false)

const following = ref(false)

userInfo(Number(props.id)).then(r => {
  user.value = r.content
  isFollowing(user.value.id).then(res => {
    following.value = res.content
  })
})

loginId().then(r => {
  me.value = r.content == Number(route.query.id)
})

</script>

<template>
  <div class="fill-width" v-if="user.id">
    <div class="shrink">
      <div style="margin: 1rem 0"/>
      <n-grid :x-gap="12" :y-gap="12" :cols="4" layout-shift-disabled>
        <n-gi>
          <user-card :id="props.id" v-if="props.id"/>
        </n-gi>
        <n-gi :span="3">
          <router-view :id="user.id"/>
        </n-gi>
      </n-grid>
    </div>
  </div>
</template>

<style scoped>

</style>
