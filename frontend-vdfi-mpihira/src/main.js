import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/css/style.css'
import './assets/css/base/variables.css'

const cssModules = import.meta.glob('./assets/css/**/*.css', { eager: true, import: 'default' })
Object.values(cssModules).forEach(css => {
  // Le CSS est déjà injecté par Vite
})

createApp(App)
  .use(router)
  .mount('#app')

