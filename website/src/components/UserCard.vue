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
import {FollowType, IUser} from "@/util/model";
import Avatar from "@/components/Avatar.vue";
import {getFollowerCount, getFollowingCount, isFollowing, loginId, userInfo} from "@/util/request";
import http from "@/util/http";
import {FormInst} from "naive-ui";

const props = defineProps<{
  id: number
}>()

const user = ref(<IUser>{})

const me = ref(false)

const following = ref(false)

const followerCount = ref(0)

const followingCount = ref(0)

const editProfile = ref(false)

userInfo(props.id).then(r => {
  user.value = r.content
  isFollowing(props.id).then(res => {
    following.value = res.content
  })
  getFollowerCount(props.id).then(r => {
    followerCount.value = r.content
  })
  getFollowingCount(props.id).then(r => {
    followingCount.value = r.content
  })
})

loginId().then(r => {
  me.value = r.content == props.id
})

const follow = () => {
  http.post("/follow/follow", {target: props.id}).then(r => {
    if (r.data.code === 200) {
      following.value = true
      window.$message.success("Followed")
    }
  })
}

const unfollow = () => {
  http.post("/follow/unfollow", {target: props.id}).then(r => {
    if (r.data.code === 200) {
      following.value = false
      window.$message.success("Unfollowed")
    }
  })
}

const profileRef = ref<FormInst | null>(null)

const publishProfile = () => {
  profileRef.value?.validate((errors) => {
    if (!errors) {
      http.post("/user/publish", {
        nickname: user.value.nickname,
        description: user.value.description,
        avatar: user.value.avatar
      }).then(r => {
        if (r.data.code === 200) {
          window.$message.success("Success")
        }
      })
    } else {
      window.$message.error(errors[0][0].message)
    }
  })

}
</script>

<template>
  <n-card>
    <n-space>
      <avatar :size="64" :avatar="user.avatar" @click="this.$router.push({name:'space',params:{ id:user.id }})"/>
      <n-space class="fill-height" justify="center" vertical>
        <div v-if="user.nickname">{{ user.nickname }}</div>
        <div v-else>{{ user.username }}</div>
      </n-space>
    </n-space>
    <div>
      <n-space>
        <n-button text
                  @click="this.$router.push({name:'space-follows',params:{id:user.id},query:{type:FollowType.FOLLOWERS}})">
          Followers:{{ followerCount }}
        </n-button>
        <n-button text
                  @click="this.$router.push({name:'space-follows',params:{id:user.id},query:{type:FollowType.FOLLOWING}})">
          Following:{{ followingCount }}
        </n-button>
      </n-space>
    </div>
    <div v-if="user.description">{{ user.description }}</div>
    <n-button v-if="me" class="fill-width" type="primary" @click="editProfile = !editProfile">Edit Profile</n-button>
    <div v-else>
      <n-button v-if="following" class="fill-width" type="primary" @click="unfollow">Unfollow</n-button>
      <n-button v-else class="fill-width" type="primary" @click="follow">Follow</n-button>
    </div>
  </n-card>

  <n-modal v-model:show="editProfile" preset="dialog" title="Edit Profile">
    <n-form :model="user" ref="profileRef" label-placement="left" label-width="auto">
      <n-form-item label="Nickname" path="nickname">
        <n-input v-model:value="user.nickname"/>
      </n-form-item>
      <n-form-item label="Description" path="description">
        <n-input v-model:value="user.description"/>
      </n-form-item>
      <n-form-item label="Avatar" path="avatar">
        <n-input v-model:value="user.avatar"/>
      </n-form-item>
      <n-form-item>
        <n-button type="primary" @click="publishProfile">
          Publish
        </n-button>
      </n-form-item>
    </n-form>
  </n-modal>
</template>

<style scoped>

</style>
