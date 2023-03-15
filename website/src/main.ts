import {createApp} from 'vue'
import App from '@/App.vue'
import naive from "@/util/naive";
import router from "@/router";
import "@/style.css"
import {createPinia} from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate";

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)

createApp(App).use(naive).use(pinia).use(router).mount('#app')
