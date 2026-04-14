<template>
  <nav class="navbar">
    <div class="nav-container">
      <!-- Logo -->
      <div class="nav-logo" @click="$router.push('/')">
        <i class="fas fa-music"></i>
        <span>VDFI <span class="logo-highlight">Mpihira</span></span>
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
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  background: rgba(15, 23, 42, 0.95);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(139, 92, 246, 0.2);
  z-index: 1000;
}

.nav-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 1.5rem;
  font-weight: 700;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.nav-logo:hover {
  transform: scale(1.05);
}

.nav-logo i {
  color: #8b5cf6;
  font-size: 1.8rem;
}

.nav-logo span {
  background: linear-gradient(135deg, #f1f5f9, #cbd5e1);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.logo-highlight {
  background: linear-gradient(135deg, #8b5cf6, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.nav-menu {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0.6rem 1.2rem;
  color: #cbd5e1;
  text-decoration: none;
  font-weight: 500;
  border-radius: 50px;
  transition: all 0.3s ease;
}

.nav-link i {
  font-size: 1rem;
}

.nav-link:hover {
  background: rgba(139, 92, 246, 0.15);
  color: #a78bfa;
  transform: translateY(-2px);
}

.router-link-exact-active {
  background: linear-gradient(135deg, #8b5cf6, #ec4899);
  color: white;
}

.nav-toggle {
  display: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #cbd5e1;
  transition: color 0.3s ease;
}

.nav-toggle:hover {
  color: #8b5cf6;
}

@media (max-width: 1024px) {
  .nav-menu {
    position: fixed;
    top: 70px;
    left: -100%;
    width: 100%;
    height: calc(100vh - 70px);
    background: rgba(15, 23, 42, 0.98);
    backdrop-filter: blur(10px);
    flex-direction: column;
    padding: 2rem;
    transition: left 0.3s ease;
    overflow-y: auto;
  }

  .nav-menu.active {
    left: 0;
  }

  .nav-link {
    width: 100%;
    justify-content: center;
    padding: 1rem;
    font-size: 1.1rem;
  }

  .nav-toggle {
    display: block;
  }
}

@media (max-width: 768px) {
  .nav-container {
    padding: 0.8rem 1.5rem;
  }

  .nav-logo {
    font-size: 1.2rem;
  }

  .nav-logo i {
    font-size: 1.4rem;
  }
}
</style>

