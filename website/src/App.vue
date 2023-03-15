<script setup lang="ts">
import {useRouter} from "vue-router";
import Message from "@/components/Message.vue";
import Dialog from "@/components/Dialog.vue";
import Loading from "@/components/Loading.vue";

window.$router = useRouter()
</script>

<template>
  <n-message-provider>
    <Message/>
  </n-message-provider>

  <n-dialog-provider>
    <Dialog/>
  </n-dialog-provider>

  <n-loading-bar-provider>
    <Loading/>
  </n-loading-bar-provider>

  <router-view/>
</template>

<style scoped>

</style>
