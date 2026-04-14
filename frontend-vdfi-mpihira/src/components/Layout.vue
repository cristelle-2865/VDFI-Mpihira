<template>
  <div class="layout">
    <Navbar />
    <main class="main-content">
      <div class="container">
        <slot />
      </div>
    </main>
    <Footer />
  </div>
</template>

<script>
import Navbar from './Navbar.vue'
import Footer from './Footer.vue'

export default {
  name: 'Layout',
  components: {
    Navbar,
    Footer
  }
}
</script>

<style scoped>
.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.main-content {
  flex: 1;
  padding: 100px 20px 40px;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
}

@media (max-width: 768px) {
  .main-content {
    padding: 80px 15px 30px;
  }
}
</style>


