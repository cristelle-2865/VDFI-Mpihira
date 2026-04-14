<template>
  <div class="sorties-page">
    <div class="page-header">
      <h1>
        <i class="fas fa-calendar-alt"></i>
        Nos Sorties
      </h1>
      <p>Concerts et prestations dans les églises - FJKM, FPVM, METM, FLM</p>
    </div>

    <!-- Vue Calendrier ou Liste -->
    <div class="view-toggle">
      <button :class="['toggle-btn', { active: viewMode === 'list' }]" @click="viewMode = 'list'">
        <i class="fas fa-list"></i> Liste
      </button>
      <button :class="['toggle-btn', { active: viewMode === 'calendar' }]" @click="viewMode = 'calendar'">
        <i class="fas fa-calendar-alt"></i> Calendrier
      </button>
    </div>

    <!-- Vue Liste -->
    <div v-if="viewMode === 'list'" class="sorties-list">
      <div v-for="sortie in sorties" :key="sortie.id_sortie" class="sortie-card">
        <div class="sortie-date">
          <div class="date-day">{{ formatDate(sortie.date_sortie, 'day') }}</div>
          <div class="date-month">{{ formatDate(sortie.date_sortie, 'month') }}</div>
        </div>
        <div class="sortie-info">
          <h3>{{ sortie.nom_eglise }}</h3>
          <p><i class="fas fa-map-marker-alt"></i> {{ sortie.nom_lieu }}</p>
          <p><i class="fas fa-clock"></i> {{ formatDate(sortie.date_sortie, 'time') }}</p>
          <p v-if="sortie.description" class="description">{{ sortie.description }}</p>
        </div>
        <div class="sortie-status">
          <span class="badge" :class="getStatusClass(sortie.nom_etat)">
            {{ sortie.nom_etat }}
          </span>
          <button class="detail-btn" @click="voirDetail(sortie)">
            <i class="fas fa-eye"></i> Détails
          </button>
        </div>
      </div>
    </div>

    <!-- Vue Calendrier -->
    <div v-if="viewMode === 'calendar'" class="calendar-view">
      <FullCalendar 
        :events="calendarEvents" 
        :options="calendarOptions"
      />
    </div>

    <!-- Modal Détails -->
    <div v-if="detailModal" class="modal" @click.self="closeDetail">
      <div class="modal-content modal-large">
        <div class="modal-header">
          <h2>{{ selectedSortie?.nom_eglise }}</h2>
          <button class="close-btn" @click="closeDetail"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" v-if="selectedSortie">
          <div class="detail-grid">
            <div class="detail-item">
              <label><i class="fas fa-map-marker-alt"></i> Lieu</label>
              <p>{{ selectedSortie.nom_lieu }}</p>
            </div>
            <div class="detail-item">
              <label><i class="fas fa-calendar"></i> Date</label>
              <p>{{ formatDate(selectedSortie.date_sortie, 'full') }}</p>
            </div>
            <div class="detail-item">
              <label><i class="fas fa-tag"></i> Statut</label>
              <span class="badge" :class="getStatusClass(selectedSortie.nom_etat)">{{ selectedSortie.nom_etat }}</span>
            </div>
            <div class="detail-item full-width">
              <label><i class="fas fa-users"></i> Membres participants</label>
              <div class="membres-list">
                <span v-for="m in selectedSortie.membres" :key="m" class="membre-tag">{{ m }}</span>
              </div>
            </div>
            <div class="detail-item full-width" v-if="selectedSortie.description">
              <label><i class="fas fa-info-circle"></i> Description</label>
              <p>{{ selectedSortie.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Sorties',
  data() {
    return {
      sorties: [],
      loading: true,
      viewMode: 'list',
      detailModal: false,
      selectedSortie: null,
      calendarEvents: []
    }
  },
  computed: {
    calendarOptions() {
      return {
        initialView: 'dayGridMonth',
        locale: 'fr',
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek'
        },
        buttonText: {
          today: 'Aujourd\'hui',
          month: 'Mois',
          week: 'Semaine'
        }
      }
    }
  },
  mounted() {
    this.fetchSorties()
  },
  methods: {
    async fetchSorties() {
      try {
        const response = await axios.get('/api/sorties')
        this.sorties = response.data
        this.calendarEvents = this.sorties.map(s => ({
          id: s.id_sortie,
          title: s.nom_eglise,
          start: s.date_sortie,
          extendedProps: { sortie: s }
        }))
      } catch (error) {
        console.error('Erreur:', error)
        this.sorties = [
          { id_sortie: 1, date_sortie: '2025-07-06 08:00:00', nom_eglise: 'FJKM Ambatonakanga', nom_lieu: 'Ambatonakanga', nom_etat: 'Confirmée', description: 'Culte dominical avec la chorale', membres: ['Fandresena', 'Zo', 'Oniniaina', 'Nathalie', 'Famenontsoa', 'Raphael', 'Aina'] },
          { id_sortie: 2, date_sortie: '2025-07-12 14:00:00', nom_eglise: 'FPVM Alarobia', nom_lieu: 'Ambatomanga', nom_etat: 'Confirmée', description: 'Conférence évangélique', membres: ['Fandresena', 'Tantanantsoa', 'Tsirava', 'Fifaliana', 'Erick', 'Toavina'] },
          { id_sortie: 3, date_sortie: '2025-07-20 09:00:00', nom_eglise: 'METM Ambohidahy', nom_lieu: 'Ankadidramamy', nom_etat: 'Planifiée', description: 'Fête de la musique', membres: ['Fandresena', 'Zo', 'Nathalie', 'Tiavo', 'Raphael', 'Toky'] },
          { id_sortie: 4, date_sortie: '2025-07-27 18:00:00', nom_eglise: 'Astauriat Antanimena', nom_lieu: 'Antanimena', nom_etat: 'Confirmée', description: 'Concert de gospel', membres: ['Fandresena', 'Oniniaina', 'Tsirava', 'Famenontsoa', 'Erick', 'Mitia'] }
        ]
        this.calendarEvents = this.sorties.map(s => ({
          id: s.id_sortie,
          title: s.nom_eglise,
          start: s.date_sortie,
          extendedProps: { sortie: s }
        }))
      } finally {
        this.loading = false
      }
    },
    formatDate(dateString, type) {
      const date = new Date(dateString)
      if (type === 'day') return date.getDate()
      if (type === 'month') return date.toLocaleString('fr', { month: 'short' }).toUpperCase()
      if (type === 'time') return date.toLocaleString('fr', { hour: '2-digit', minute: '2-digit' })
      if (type === 'full') return date.toLocaleDateString('fr', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric', hour: '2-digit', minute: '2-digit' })
      return date.toLocaleDateString('fr')
    },
    getStatusClass(etat) {
      const classes = {
        'Confirmée': 'badge-success',
        'Planifiée': 'badge-info',
        'Terminée': 'badge-info',
        'Annulée': 'badge-danger',
        'En cours': 'badge-warning'
      }
      return classes[etat] || 'badge-warning'
    },
    voirDetail(sortie) {
      this.selectedSortie = sortie
      this.detailModal = true
    },
    closeDetail() {
      this.detailModal = false
      this.selectedSortie = null
    }
  }
}
</script>

<style scoped>
.sorties-page {
  animation: fadeInUp 0.6s ease;
}

.view-toggle {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 2rem;
}

.toggle-btn {
  padding: 0.6rem 1.5rem;
  background: rgba(30, 41, 59, 0.6);
  border: 1px solid rgba(139, 92, 246, 0.2);
  border-radius: 50px;
  color: #cbd5e1;
  cursor: pointer;
  transition: all 0.3s ease;
}

.toggle-btn i {
  margin-right: 8px;
}

.toggle-btn.active {
  background: linear-gradient(135deg, #8b5cf6, #ec4899);
  color: white;
  border-color: transparent;
}

.sorties-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.sortie-card {
  background: rgba(30, 41, 59, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 2rem;
  border: 1px solid rgba(139, 92, 246, 0.2);
  transition: all 0.3s ease;
}

.sortie-card:hover {
  transform: translateX(10px);
  border-color: #8b5cf6;
}

.sortie-date {
  text-align: center;
  min-width: 80px;
  background: linear-gradient(135deg, rgba(139, 92, 246, 0.15), rgba(236, 72, 153, 0.15));
  border-radius: 15px;
  padding: 1rem;
}

.date-day {
  font-size: 2rem;
  font-weight: 800;
  line-height: 1;
}

.date-month {
  font-size: 0.75rem;
  color: #8b5cf6;
}

.sortie-info {
  flex: 1;
}

.sortie-info h3 {
  margin-bottom: 0.5rem;
}

.sortie-info p {
  color: #94a3b8;
  margin: 0.25rem 0;
}

.sortie-info p i {
  width: 20px;
  color: #8b5cf6;
}

.sortie-info .description {
  margin-top: 0.5rem;
  font-size: 0.875rem;
  font-style: italic;
}

.sortie-status {
  text-align: center;
  min-width: 120px;
}

.detail-btn {
  margin-top: 0.5rem;
  padding: 0.4rem 1rem;
  background: none;
  border: 1px solid #8b5cf6;
  border-radius: 50px;
  color: #8b5cf6;
  cursor: pointer;
  transition: all 0.3s ease;
}

.detail-btn:hover {
  background: #8b5cf6;
  color: white;
}

.modal-large {
  width: 90%;
  max-width: 700px;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}

.detail-item {
  margin-bottom: 1rem;
}

.detail-item label {
  display: block;
  font-size: 0.75rem;
  color: #8b5cf6;
  margin-bottom: 0.25rem;
}

.detail-item p {
  color: #cbd5e1;
}

.full-width {
  grid-column: span 2;
}

.membres-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.membre-tag {
  padding: 0.2rem 0.8rem;
  background: rgba(139, 92, 246, 0.2);
  border-radius: 50px;
  font-size: 0.75rem;
}

@media (max-width: 768px) {
  .sortie-card {
    flex-direction: column;
    text-align: center;
  }
  
  .sortie-info p i {
    width: auto;
    margin-right: 8px;
  }
  
  .detail-grid {
    grid-template-columns: 1fr;
  }
  
  .full-width {
    grid-column: span 1;
  }
}
</style>

