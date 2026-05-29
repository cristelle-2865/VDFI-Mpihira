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

    <!-- Chargement -->
    <div v-if="loading" class="loading-spinner">
      <i class="fas fa-spinner fa-pulse"></i> Chargement...
    </div>

    <!-- Vue Liste -->
    <div v-else-if="viewMode === 'list'" class="sorties-list">
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
          <span class="status-badge" :class="getStatusClass(sortie.nom_etat)">
            {{ sortie.nom_etat }}
          </span>
          <button class="detail-btn" @click="voirDetail(sortie)">
            <i class="fas fa-eye"></i> Détails
          </button>
        </div>
      </div>
    </div>

    <!-- Vue Calendrier -->
    <div v-else-if="viewMode === 'calendar'" class="calendar-view">
      <FullCalendar
        :options="calendarOptions"
      >
        <template v-slot:eventContent="arg">
          <div class="fc-event-custom">
            <strong>{{ arg.event.title }}</strong>
            <small>{{ arg.event.extendedProps.lieu || '' }}</small>
          </div>
        </template>
      </FullCalendar>
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
              <span class="status-badge" :class="getStatusClass(selectedSortie.nom_etat)">{{ selectedSortie.nom_etat }}</span>
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
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'
import frLocale from '@fullcalendar/core/locales/fr'

export default {
  name: 'Sorties',
  components: {
    FullCalendar
  },
  data() {
    return {
      sorties: [],
      loading: true,
      viewMode: 'list',
      detailModal: false,
      selectedSortie: null
    }
  },
  computed: {
    calendarOptions() {
      return {
        plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
        initialView: 'dayGridMonth',
        locale: frLocale,
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek'
        },
        buttonText: {
          today: 'Aujourd\'hui',
          month: 'Mois',
          week: 'Semaine'
        },
        events: this.calendarEvents,
        eventClick: this.handleEventClick,
        height: 'auto',
        firstDay: 1,
        weekends: true,
        nowIndicator: true
      }
    },
    calendarEvents() {
      return this.sorties.map(sortie => ({
        id: sortie.id_sortie,
        title: sortie.nom_eglise,
        start: sortie.date_sortie,
        extendedProps: {
          sortie: sortie,
          lieu: sortie.nom_lieu,
          statut: sortie.nom_etat,
          description: sortie.description
        },
        className: `event-${this.getStatusClass(sortie.nom_etat).replace('status-', '')}`
      }))
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
      } catch (error) {
        console.error('Erreur API:', error)
        // Données mockées pour la démo
        this.sorties = [
          { id_sortie: 1, date_sortie: '2025-07-06 08:00:00', nom_eglise: 'FJKM Ambatonakanga', nom_lieu: 'Ambatonakanga', nom_etat: 'Confirmée', description: 'Culte dominical avec la chorale', membres: ['Fandresena', 'Zo', 'Oniniaina', 'Nathalie', 'Famenontsoa', 'Raphael', 'Aina'] },
          { id_sortie: 2, date_sortie: '2025-07-12 14:00:00', nom_eglise: 'FPVM Alarobia', nom_lieu: 'Ambatomanga', nom_etat: 'Confirmée', description: 'Conférence évangélique', membres: ['Fandresena', 'Tantanantsoa', 'Tsirava', 'Fifaliana', 'Erick', 'Toavina'] },
          { id_sortie: 3, date_sortie: '2025-07-20 09:00:00', nom_eglise: 'METM Ambohidahy', nom_lieu: 'Ankadidramamy', nom_etat: 'Planifiée', description: 'Fête de la musique', membres: ['Fandresena', 'Zo', 'Nathalie', 'Tiavo', 'Raphael', 'Toky'] },
          { id_sortie: 4, date_sortie: '2025-07-27 18:00:00', nom_eglise: 'Astauriat Antanimena', nom_lieu: 'Antanimena', nom_etat: 'Confirmée', description: 'Concert de gospel', membres: ['Fandresena', 'Oniniaina', 'Tsirava', 'Famenontsoa', 'Erick', 'Mitia'] },
          { id_sortie: 5, date_sortie: '2025-08-03 10:00:00', nom_eglise: 'FLM Andohalo', nom_lieu: 'Andohalo', nom_etat: 'Planifiée', description: 'Culte spécial chant choral', membres: ['Fandresena', 'Nathalie', 'Raphael', 'Toavina', 'Mitia'] },
          { id_sortie: 6, date_sortie: '2025-08-15 15:30:00', nom_eglise: 'FJKM Ambohipotsy', nom_lieu: 'Ambohipotsy', nom_etat: 'Confirmée', description: 'Concert anniversaire', membres: ['Fandresena', 'Zo', 'Oniniaina', 'Tsirava', 'Fifaliana', 'Erick', 'Aina', 'Toky'] }
        ]
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
        'Confirmée': 'status-confirmed',
        'Planifiée': 'status-planned',
        'Terminée': 'status-completed',
        'Annulée': 'status-cancelled',
        'En cours': 'status-planned'
      }
      return classes[etat] || 'status-planned'
    },
    voirDetail(sortie) {
      this.selectedSortie = sortie
      this.detailModal = true
    },
    closeDetail() {
      this.detailModal = false
      this.selectedSortie = null
    },
    handleEventClick(info) {
      const sortie = info.event.extendedProps.sortie
      this.voirDetail(sortie)
    }
  }
}
</script>

<style scoped>
@import '../assets/css/views/sorties.css';

/* Styles spécifiques pour FullCalendar */
.sorties-page :deep(.fc) {
  --fc-border-color: var(--color-border);
  --fc-button-bg-color: var(--color-background-alt);
  --fc-button-border-color: var(--color-border);
  --fc-button-hover-bg-color: var(--color-surface);
  --fc-button-active-bg-color: var(--color-accent);
  --fc-today-bg-color: rgba(173, 117, 86, 0.1);
  --fc-event-bg-color: var(--color-accent);
  --fc-event-border-color: var(--color-accent-dark);
  font-family: var(--font-family-lexend);
}

.sorties-page :deep(.fc-toolbar-title) {
  font-size: var(--font-size-h3);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
}

.sorties-page :deep(.fc-button) {
  border-radius: var(--radius-xl);
  padding: 0.4rem 1rem;
  font-weight: var(--font-weight-medium);
  text-transform: capitalize;
  background-color: var(--color-background-alt);
  border-color: var(--color-border);
  color: var(--color-text-secondary);
}

.sorties-page :deep(.fc-button:hover) {
  background-color: var(--color-surface);
  border-color: var(--color-accent);
  color: var(--color-accent-dark);
}

.sorties-page :deep(.fc-button-primary:not(:disabled):active),
.sorties-page :deep(.fc-button-primary:not(:disabled).fc-button-active) {
  background: var(--gradient-primary);
  border-color: transparent;
  color: var(--color-text-light);
}

.sorties-page :deep(.fc-day-today) {
  background: rgba(173, 117, 86, 0.08);
}

.sorties-page :deep(.fc-event) {
  cursor: pointer;
  border-radius: var(--radius-md);
  padding: 2px 4px;
  transition: transform var(--transition-fast);
}

.sorties-page :deep(.fc-event:hover) {
  transform: scale(1.02);
  filter: brightness(1.05);
}

.sorties-page :deep(.event-confirmed) {
  background: linear-gradient(135deg, var(--color-success), var(--color-green-dark));
  border-color: var(--color-success);
}

.sorties-page :deep(.event-planned) {
  background: linear-gradient(135deg, var(--color-warning), var(--color-accent-light));
  border-color: var(--color-warning);
}

.sorties-page :deep(.event-completed) {
  background: linear-gradient(135deg, var(--color-info), var(--color-tertiary));
  border-color: var(--color-info);
}

.sorties-page :deep(.fc-daygrid-day-frame) {
  cursor: pointer;
}

.sorties-page :deep(.fc-daygrid-day-frame:hover) {
  background: rgba(173, 117, 86, 0.05);
}

.sorties-page :deep(.fc-event-custom) {
  display: flex;
  flex-direction: column;
  font-size: 0.75rem;
}

.sorties-page :deep(.fc-event-custom small) {
  font-size: 0.65rem;
  opacity: 0.9;
}

@media (max-width: 768px) {
  .sorties-page :deep(.fc-toolbar) {
    flex-direction: column;
    gap: 1rem;
  }
  
  .sorties-page :deep(.fc-toolbar-chunk) {
    display: flex;
    justify-content: center;
  }
  
  .sorties-page :deep(.fc-event-custom strong) {
    font-size: 0.7rem;
  }
  
  .sorties-page :deep(.fc-event-custom small) {
    display: none;
  }
}
</style>


