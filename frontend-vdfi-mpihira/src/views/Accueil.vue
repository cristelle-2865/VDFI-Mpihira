<!-- Accueil.vue - Version lightmode avec palette automnale -->
<template>
  <div class="accueil">
    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-content">
        <div class="hero-text">
          <div class="hero-badge">
            <i class="fas fa-church"></i>
            <span>Groupe de Louange et d'Adoration</span>
          </div>
          <h1 class="hero-title">
            VDFI <span class="gradient-text">Mpihira</span>
          </h1>
          <p class="hero-description">
            Un groupe dédié à la propagation de l'évangile à travers la musique, 
            la louange et l'adoration. Nous partageons la parole de Dieu par nos 
            chants et nos prestations dans différentes églises.
          </p>
          <div class="hero-buttons">
            <button class="btn-primary" @click="$router.push('/sorties')">
              <i class="fas fa-calendar-alt"></i>
              Voir les sorties
            </button>
            <button class="btn-secondary" @click="$router.push('/reservations')">
              <i class="fas fa-bookmark"></i>
              Réserver
            </button>
          </div>
        </div>
        <div class="hero-image">
          <div class="floating-music-notes">
            <i class="fas fa-music"></i>
            <i class="fas fa-head-side-vr"></i>
            <i class="fas fa-microphone-alt"></i>
          </div>
          <div class="hero-stats">
            <div class="stat-card">
              <i class="fas fa-users"></i>
              <span class="stat-number">{{ stats.membres }}</span>
              <span class="stat-label">Membres</span>
            </div>
            <div class="stat-card">
              <i class="fas fa-music"></i>
              <span class="stat-number">{{ stats.chansons }}</span>
              <span class="stat-label">Chansons</span>
            </div>
            <div class="stat-card">
              <i class="fas fa-calendar-check"></i>
              <span class="stat-number">{{ stats.sorties }}</span>
              <span class="stat-label">Sorties</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Sections Rapides -->
    <section class="quick-sections">
      <div class="section-header">
        <h2>Explorez notre univers</h2>
        <p>Découvrez les différents aspects de notre ministère musical</p>
      </div>

      <div class="sections-grid">
        <div class="section-card" @click="$router.push('/membres')">
          <div class="card-icon">
            <i class="fas fa-users"></i>
          </div>
          <h3>Nos Membres</h3>
          <p>Chanteurs, musiciens, techniciens et responsables unis pour la gloire de Dieu</p>
          <span class="card-link">Voir tous <i class="fas fa-arrow-right"></i></span>
        </div>

        <div class="section-card" @click="$router.push('/chansons')">
          <div class="card-icon">
            <i class="fas fa-music"></i>
          </div>
          <h3>Nos Chansons</h3>
          <p>Paroles, partitions, playbacks et vidéos de nos compositions originales</p>
          <span class="card-link">Écouter <i class="fas fa-arrow-right"></i></span>
        </div>

        <div class="section-card" @click="$router.push('/sorties')">
          <div class="card-icon">
            <i class="fas fa-calendar-alt"></i>
          </div>
          <h3>Nos Sorties</h3>
          <p>Concerts et prestations dans les églises (FJKM, FPVM, METM, FLM)</p>
          <span class="card-link">Voir le calendrier <i class="fas fa-arrow-right"></i></span>
        </div>

        <div class="section-card" @click="$router.push('/medias')">
          <div class="card-icon">
            <i class="fas fa-photo-video"></i>
          </div>
          <h3>Galerie Médias</h3>
          <p>Photos, vidéos et souvenirs de nos événements et prestations</p>
          <span class="card-link">Explorer <i class="fas fa-arrow-right"></i></span>
        </div>
      </div>
    </section>

    <!-- Prochaines Sorties -->
    <section class="upcoming-events" v-if="prochainesSorties.length > 0">
      <div class="section-header">
        <h2>Prochaines Sorties</h2>
        <p>Ne manquez pas nos prochaines prestations</p>
      </div>

      <div class="events-grid">
        <div v-for="sortie in prochainesSorties" :key="sortie.id" class="event-card">
          <div class="event-date">
            <span class="day">{{ formatDate(sortie.date_sortie, 'day') }}</span>
            <span class="month">{{ formatDate(sortie.date_sortie, 'month') }}</span>
          </div>
          <div class="event-info">
            <h3>{{ sortie.nom_eglise }}</h3>
            <p><i class="fas fa-map-marker-alt"></i> {{ sortie.nom_lieu }}</p>
            <p><i class="fas fa-clock"></i> {{ formatDate(sortie.date_sortie, 'time') }}</p>
          </div>
          <div class="event-status">
            <span class="badge" :class="getStatusClass(sortie.nom_etat)">
              {{ sortie.nom_etat }}
            </span>
          </div>
        </div>
      </div>

      <div class="view-all">
        <button class="btn-secondary" @click="$router.push('/sorties')">
          Voir toutes les sorties
          <i class="fas fa-arrow-right"></i>
        </button>
      </div>
    </section>

    <!-- Témoignages -->
    <section class="testimonials">
      <div class="section-header">
        <h2>Ce qu'ils disent de nous</h2>
        <p>Les retours des églises qui nous ont accueillis</p>
      </div>

      <div class="testimonials-grid">
        <div class="testimonial-card">
          <i class="fas fa-quote-left"></i>
          <p>"Une bénédiction pour notre église. Leur musique touche vraiment le cœur."</p>
          <div class="testimonial-author">
            <strong>Pasteur R.</strong>
            <span>FJKM Ambatonakanga</span>
          </div>
        </div>

        <div class="testimonial-card">
          <i class="fas fa-quote-left"></i>
          <p>"Professionnalisme et onction spirituelle. Une équipe hors pair."</p>
          <div class="testimonial-author">
            <strong>Responsable FPVM</strong>
            <span>FPVM Alarobia</span>
          </div>
        </div>

        <div class="testimonial-card">
          <i class="fas fa-quote-left"></i>
          <p>"Nos fidèles ont été édifiés. Nous les recommandons vivement."</p>
          <div class="testimonial-author">
            <strong>Conseil Presbytéral</strong>
            <span>METM Avaradoha</span>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Accueil',
  data() {
    return {
      stats: {
        membres: 20,
        chansons: 9,
        sorties: 9
      },
      prochainesSorties: []
    }
  },
  mounted() {
    this.fetchProchainesSorties()
  },
  methods: {
    async fetchProchainesSorties() {
      try {
        const response = await axios.get('/api/sorties/prochaines')
        this.prochainesSorties = response.data.slice(0, 3)
      } catch (error) {
        console.error('Erreur lors du chargement des sorties:', error)
        this.prochainesSorties = [
          {
            id: 1,
            date_sortie: '2025-07-06 08:00:00',
            nom_eglise: 'FJKM Ambatonakanga',
            nom_lieu: 'Ambatonakanga',
            nom_etat: 'Confirmée'
          },
          {
            id: 2,
            date_sortie: '2025-07-12 14:00:00',
            nom_eglise: 'FPVM Alarobia',
            nom_lieu: 'Ambatomanga',
            nom_etat: 'Confirmée'
          },
          {
            id: 3,
            date_sortie: '2025-07-20 09:00:00',
            nom_eglise: 'METM Ambohidahy',
            nom_lieu: 'Ankadidramamy',
            nom_etat: 'Planifiée'
          }
        ]
      }
    },
    formatDate(dateString, type) {
      const date = new Date(dateString)
      if (type === 'day') {
        return date.getDate()
      } else if (type === 'month') {
        return date.toLocaleString('fr', { month: 'short' }).toUpperCase()
      } else if (type === 'time') {
        return date.toLocaleString('fr', { hour: '2-digit', minute: '2-digit' })
      }
      return date.toLocaleDateString('fr')
    },
    getStatusClass(etat) {
      const classes = {
        'Confirmée': 'badge-success',
        'Planifiée': 'badge-info',
        'Terminée': 'badge-info',
        'Annulée': 'badge-danger'
      }
      return classes[etat] || 'badge-warning'
    }
  }
}
</script>

<style>
@import '../assets/css/views/accueil.css';
</style>

