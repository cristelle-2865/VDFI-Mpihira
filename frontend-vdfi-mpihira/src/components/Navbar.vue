<template>
  <nav class="navbar">
    <div class="nav-container">
      <!-- Logo -->
      <div class="nav-logo" @click="$router.push('/')">
        <img src="../assets/logos/logo2.0_n.png" alt="VDFI Mpihira Logo" class="logo-image" />
        <!-- <i class="fas fa-music"></i> -->
        <!-- <span>VDFI <span class="logo-highlight">Mpihira</span></span> -->
      </div>

      <!-- Menu Desktop -->
      <div class="nav-menu" :class="{ 'active': isMenuOpen }">
        <router-link to="/" class="nav-link" @click="closeMenu">
          <i class="fas fa-home"></i>
          <span>Accueil</span>
        </router-link>

        <router-link to="/membres" class="nav-link" @click="closeMenu">
          <i class="fas fa-users"></i>
          <span>Membres</span>
        </router-link>

        <router-link to="/chansons" class="nav-link" @click="closeMenu">
          <i class="fas fa-music"></i>
          <span>Chansons</span>
        </router-link>

        <router-link to="/sorties" class="nav-link" @click="closeMenu">
          <i class="fas fa-calendar-alt"></i>
          <span>Sorties</span>
        </router-link>

        <router-link to="/reservations" class="nav-link" @click="closeMenu">
          <i class="fas fa-bookmark"></i>
          <span>Réservations</span>
        </router-link>

        <router-link to="/repertoires" class="nav-link" @click="closeMenu">
          <i class="fas fa-list-ul"></i>
          <span>Répertoires</span>
        </router-link>

        <router-link to="/medias" class="nav-link" @click="closeMenu">
          <i class="fas fa-photo-video"></i>
          <span>Médias</span>
        </router-link>

        <router-link to="/notifications" class="nav-link" @click="closeMenu">
          <i class="fas fa-bell"></i>
          <span>Notifications</span>
        </router-link>
      </div>

      <!-- Bouton Menu Mobile -->
      <div class="nav-toggle" @click="toggleMenu">
        <i class="fas" :class="isMenuOpen ? 'fa-times' : 'fa-bars'"></i>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'Navbar',
  data() {
    return {
      isMenuOpen: false
    }
  },
  methods: {
    toggleMenu() {
      this.isMenuOpen = !this.isMenuOpen
    },
    closeMenu() {
      this.isMenuOpen = false
    }
  },
  watch: {
    '$route'() {
      this.closeMenu()
    }
  }
}
</script>

<style scoped>
@import '../assets/css/components/navbar.css';

/* Styles additionnels pour le logo image */
.nav-logo {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  margin-right: 50px;
}

.logo-image {
  height: 40px;
  width: auto;
  object-fit: contain;
}
</style>

