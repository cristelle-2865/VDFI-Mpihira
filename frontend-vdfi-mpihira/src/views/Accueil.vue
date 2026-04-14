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
        // Données mock en attendant le backend
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

<style scoped>
.accueil {
  animation: fadeInUp 0.6s ease;
}

/* Hero Section */
.hero {
  min-height: 90vh;
  display: flex;
  align-items: center;
  margin-bottom: 4rem;
}

.hero-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}

.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(139, 92, 246, 0.15);
  padding: 8px 16px;
  border-radius: 50px;
  margin-bottom: 1.5rem;
  font-size: 0.875rem;
}

.hero-badge i {
  color: #8b5cf6;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: 800;
  margin-bottom: 1.5rem;
  line-height: 1.2;
}

.gradient-text {
  background: linear-gradient(135deg, #8b5cf6, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.hero-description {
  font-size: 1.125rem;
  color: #94a3b8;
  line-height: 1.6;
  margin-bottom: 2rem;
}

.hero-buttons {
  display: flex;
  gap: 1rem;
}

.hero-image {
  position: relative;
}

.floating-music-notes {
  position: absolute;
  top: 20%;
  right: 10%;
  animation: float 3s ease-in-out infinite;
}

.floating-music-notes i {
  font-size: 2rem;
  color: #8b5cf6;
  opacity: 0.6;
}

.hero-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
  margin-top: 2rem;
}

.stat-card {
  background: rgba(30, 41, 59, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 1.5rem;
  text-align: center;
  border: 1px solid rgba(139, 92, 246, 0.2);
}

.stat-card i {
  font-size: 2rem;
  color: #8b5cf6;
  margin-bottom: 0.5rem;
  display: block;
}

.stat-number {
  font-size: 2rem;
  font-weight: 800;
  display: block;
  background: linear-gradient(135deg, #8b5cf6, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.stat-label {
  font-size: 0.875rem;
  color: #94a3b8;
}

/* Quick Sections */
.quick-sections {
  margin-bottom: 5rem;
}

.section-header {
  text-align: center;
  margin-bottom: 3rem;
}

.section-header h2 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.section-header p {
  color: #94a3b8;
}

.sections-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
}

.section-card {
  background: rgba(30, 41, 59, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 2rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(139, 92, 246, 0.2);
}

.section-card:hover {
  transform: translateY(-10px);
  border-color: #8b5cf6;
}

.card-icon {
  width: 70px;
  height: 70px;
  background: linear-gradient(135deg, rgba(139, 92, 246, 0.2), rgba(236, 72, 153, 0.2));
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.5rem;
}

.card-icon i {
  font-size: 2rem;
  color: #8b5cf6;
}

.section-card h3 {
  margin-bottom: 1rem;
}

.section-card p {
  color: #94a3b8;
  margin-bottom: 1.5rem;
  line-height: 1.6;
}

.card-link {
  color: #8b5cf6;
  font-weight: 600;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  transition: gap 0.3s ease;
}

.section-card:hover .card-link {
  gap: 12px;
}

/* Upcoming Events */
.upcoming-events {
  margin-bottom: 5rem;
}

.events-grid {
  display: grid;
  gap: 1rem;
  margin-bottom: 2rem;
}

.event-card {
  background: rgba(30, 41, 59, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 2rem;
  border: 1px solid rgba(139, 92, 246, 0.2);
  transition: all 0.3s ease;
}

.event-card:hover {
  transform: translateX(10px);
  border-color: #8b5cf6;
}

.event-date {
  text-align: center;
  min-width: 80px;
  background: linear-gradient(135deg, rgba(139, 92, 246, 0.15), rgba(236, 72, 153, 0.15));
  border-radius: 15px;
  padding: 1rem;
}

.event-date .day {
  font-size: 2rem;
  font-weight: 800;
  display: block;
  line-height: 1;
}

.event-date .month {
  font-size: 0.75rem;
  color: #8b5cf6;
}

.event-info {
  flex: 1;
}

.event-info h3 {
  margin-bottom: 0.5rem;
}

.event-info p {
  color: #94a3b8;
  margin: 0.25rem 0;
}

.event-info p i {
  width: 20px;
  color: #8b5cf6;
}

.view-all {
  text-align: center;
  margin-top: 2rem;
}

/* Testimonials */
.testimonials {
  margin-bottom: 5rem;
}

.testimonials-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.testimonial-card {
  background: rgba(30, 41, 59, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 2rem;
  position: relative;
  border: 1px solid rgba(139, 92, 246, 0.2);
}

.testimonial-card i {
  font-size: 2rem;
  color: #8b5cf6;
  opacity: 0.5;
  margin-bottom: 1rem;
}

.testimonial-card p {
  font-style: italic;
  margin-bottom: 1.5rem;
  line-height: 1.6;
}

.testimonial-author strong {
  display: block;
  margin-bottom: 0.25rem;
}

.testimonial-author span {
  font-size: 0.875rem;
  color: #8b5cf6;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
  }
}

@media (max-width: 968px) {
  .hero-content {
    grid-template-columns: 1fr;
    text-align: center;
  }

  .hero-buttons {
    justify-content: center;
  }

  .hero-title {
    font-size: 2.5rem;
  }

  .hero-stats {
    grid-template-columns: repeat(3, 1fr);
  }

  .event-card {
    flex-direction: column;
    text-align: center;
  }

  .event-info p i {
    width: auto;
    margin-right: 8px;
  }
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2rem;
  }

  .section-header h2 {
    font-size: 1.8rem;
  }

  .hero-buttons {
    flex-direction: column;
  }

  .btn-primary, .btn-secondary {
    width: 100%;
  }
}
</style>


