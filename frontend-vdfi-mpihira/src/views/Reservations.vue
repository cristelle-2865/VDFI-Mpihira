<template>
  <div class="reservations-page">
    <div class="page-header">
      <h1>
        <i class="fas fa-bookmark"></i>
        Réservations
      </h1>
      <p>Demandes de prestations effectuées par les églises</p>
    </div>

    <!-- Bouton nouvelle réservation -->
    <div class="actions-bar">
      <button class="btn-primary" @click="showForm = true">
        <i class="fas fa-plus"></i> Nouvelle réservation
      </button>
    </div>

    <!-- Filtres -->
    <div class="filters">
      <select v-model="filtreStatut" class="filter-select">
        <option value="tous">Tous les statuts</option>
        <option value="1">Créée</option>
        <option value="2">Validée</option>
        <option value="3">Annulée</option>
        <option value="4">Refusée</option>
      </select>
    </div>

    <!-- Liste des réservations -->
    <div class="reservations-list" v-if="!loading">
      <div v-for="reservation in reservationsFiltrees" :key="reservation.id_reservation" class="reservation-card">
        <div class="reservation-header">
          <h3>{{ reservation.nom_eglise }}</h3>
          <span class="badge" :class="getStatutClass(reservation.id_statut)">
            {{ getStatutLabel(reservation.id_statut) }}
          </span>
        </div>
        <div class="reservation-body">
          <div class="reservation-info">
            <p><i class="fas fa-calendar"></i> {{ formatDate(reservation.date_evenement) }}</p>
            <p><i class="fas fa-clock"></i> {{ getPeriodeLabel(reservation.periode_journee) }}</p>
            <p><i class="fas fa-map-marker-alt"></i> {{ reservation.adresse_eglise }}</p>
            <p><i class="fas fa-envelope"></i> {{ reservation.email_contact }}</p>
            <p><i class="fas fa-phone"></i> {{ reservation.contact }}</p>
          </div>
          <div class="reservation-description" v-if="reservation.description_reservation">
            <p><strong>Description :</strong> {{ reservation.description_reservation }}</p>
          </div>
          <div class="reservation-sono">
            <i class="fas" :class="reservation.sono_complet ? 'fa-check-circle text-success' : 'fa-times-circle text-danger'"></i>
            Sono complet : {{ reservation.sono_complet ? 'Oui' : 'Non' }}
          </div>
        </div>
        <div class="reservation-footer">
          <small>Demandé le {{ formatDate(reservation.date_creation) }}</small>
          <div class="actions" v-if="reservation.id_statut === 1">
            <button class="action-valid" @click="updateStatut(reservation.id_reservation, 2)">Valider</button>
            <button class="action-refuse" @click="updateStatut(reservation.id_reservation, 4)">Refuser</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Formulaire -->
    <div v-if="showForm" class="modal" @click.self="closeForm">
      <div class="modal-content modal-large">
        <div class="modal-header">
          <h2>Nouvelle réservation</h2>
          <button class="close-btn" @click="closeForm"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="submitReservation" class="reservation-form">
            <div class="form-group">
              <label>Nom de l'église *</label>
              <input type="text" v-model="form.nom_eglise" required>
            </div>
            <div class="form-group">
              <label>Adresse *</label>
              <textarea v-model="form.adresse_eglise" rows="2" required></textarea>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Contact *</label>
                <input type="tel" v-model="form.contact" required>
              </div>
              <div class="form-group">
                <label>Email *</label>
                <input type="email" v-model="form.email_contact" required>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Date de l'événement *</label>
                <input type="date" v-model="form.date_evenement" required>
              </div>
              <div class="form-group">
                <label>Période *</label>
                <select v-model="form.periode_journee" required>
                  <option value="matin">Matin</option>
                  <option value="apres-midi">Après-midi</option>
                  <option value="toute-la-journee">Toute la journée</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label>Description</label>
              <textarea v-model="form.description_reservation" rows="3"></textarea>
            </div>
            <div class="form-group">
              <label>
                <input type="checkbox" v-model="form.sono_complet">
                Sono complet nécessaire
              </label>
            </div>
            <div class="form-group">
              <label>Lieu *</label>
              <select v-model="form.id_lieu" required>
                <option v-for="lieu in lieux" :key="lieu.id_lieu" :value="lieu.id_lieu">
                  {{ lieu.nom_lieu }} - {{ lieu.adresse }}
                </option>
              </select>
            </div>
            <div class="form-actions">
              <button type="button" class="btn-secondary" @click="closeForm">Annuler</button>
              <button type="submit" class="btn-primary">Envoyer la demande</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Reservations',
  data() {
    return {
      reservations: [],
      lieux: [],
      loading: true,
      filtreStatut: 'tous',
      showForm: false,
      form: {
        nom_eglise: '',
        adresse_eglise: '',
        contact: '',
        email_contact: '',
        date_evenement: '',
        periode_journee: 'matin',
        description_reservation: '',
        sono_complet: false,
        id_lieu: ''
      }
    }
  },
  computed: {
    reservationsFiltrees() {
      if (this.filtreStatut === 'tous') return this.reservations
      return this.reservations.filter(r => r.id_statut == this.filtreStatut)
    }
  },
  mounted() {
    this.fetchReservations()
    this.fetchLieux()
  },
  methods: {
    async fetchReservations() {
      try {
        const response = await axios.get('/api/reservations')
        this.reservations = response.data
      } catch (error) {
        console.error('Erreur:', error)
        this.reservations = [
          { id_reservation: 1, nom_eglise: 'FJKM Ambatonakanga', adresse_eglise: 'Ambatonakanga, Antananarivo', contact: '0341234567', email_contact: 'contact@ambatonakanga.mg', date_evenement: '2025-07-06', periode_journee: 'matin', description_reservation: 'Culte dominical avec chorale', sono_complet: true, id_statut: 2, date_creation: '2025-06-15 09:00:00' },
          { id_reservation: 2, nom_eglise: 'FPVM Alarobia', adresse_eglise: 'Ambatomanga, Madagascar', contact: '0342345678', email_contact: 'secretariat@fpvm-alarobia.mg', date_evenement: '2025-07-12', periode_journee: 'apres-midi', description_reservation: 'Conférence évangélique', sono_complet: false, id_statut: 2, date_creation: '2025-06-18 10:30:00' },
          { id_reservation: 3, nom_eglise: 'METM Ambohidahy', adresse_eglise: 'Ankadidramamy, Antananarivo', contact: '0343456789', email_contact: 'contact@metm.mg', date_evenement: '2025-07-20', periode_journee: 'toute-la-journee', description_reservation: 'Fête de la musique', sono_complet: true, id_statut: 1, date_creation: '2025-06-25 11:00:00' }
        ]
      } finally {
        this.loading = false
      }
    },
    async fetchLieux() {
      try {
        const response = await axios.get('/api/lieux')
        this.lieux = response.data
      } catch (error) {
        this.lieux = [
          { id_lieu: 1, nom_lieu: 'METM Avaradoha', adresse: 'Avaradoha, Antananarivo' },
          { id_lieu: 2, nom_lieu: 'FPVM Talatanivolonondry', adresse: 'Talatanivolonondry, Antananarivo' },
          { id_lieu: 11, nom_lieu: 'FJKM Ambatonakanga', adresse: 'Ambatonakanga, Antananarivo' }
        ]
      }
    },
    formatDate(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleDateString('fr')
    },
    getPeriodeLabel(periode) {
      const labels = {
        'matin': 'Matin',
        'apres-midi': 'Après-midi',
        'toute-la-journee': 'Toute la journée'
      }
      return labels[periode] || periode
    },
    getStatutClass(statutId) {
      const classes = {
        1: 'badge-warning',
        2: 'badge-success',
        3: 'badge-danger',
        4: 'badge-danger'
      }
      return classes[statutId] || 'badge-info'
    },
    getStatutLabel(statutId) {
      const labels = {
        1: 'Créée',
        2: 'Validée',
        3: 'Annulée',
        4: 'Refusée'
      }
      return labels[statutId] || 'Inconnu'
    },
    async submitReservation() {
      try {
        await axios.post('/api/reservations', this.form)
        this.closeForm()
        this.fetchReservations()
        alert('Réservation envoyée avec succès !')
      } catch (error) {
        console.error('Erreur:', error)
        alert('Erreur lors de l\'envoi')
      }
    },
    async updateStatut(id, statut) {
      try {
        await axios.put(`/api/reservations/${id}/statut`, { id_statut: statut })
        this.fetchReservations()
        alert('Statut mis à jour')
      } catch (error) {
        console.error('Erreur:', error)
      }
    },
    closeForm() {
      this.showForm = false
      this.form = {
        nom_eglise: '',
        adresse_eglise: '',
        contact: '',
        email_contact: '',
        date_evenement: '',
        periode_journee: 'matin',
        description_reservation: '',
        sono_complet: false,
        id_lieu: ''
      }
    }
  }
}
</script>

<style scoped>
.reservations-page {
  animation: fadeInUp 0.6s ease;
}

.actions-bar {
  margin-bottom: 1.5rem;
}

.reservations-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.reservation-card {
  background: rgba(30, 41, 59, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  overflow: hidden;
  border: 1px solid rgba(139, 92, 246, 0.2);
}

.reservation-header {
  padding: 1rem 1.5rem;
  background: rgba(139, 92, 246, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(139, 92, 246, 0.1);
}

.reservation-header h3 {
  margin: 0;
}

.reservation-body {
  padding: 1.5rem;
}

.reservation-info {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.reservation-info p {
  margin: 0;
  color: #94a3b8;
  font-size: 0.875rem;
}

.reservation-info p i {
  width: 20px;
  color: #8b5cf6;
}

.reservation-description {
  margin: 1rem 0;
  padding: 0.75rem;
  background: rgba(139, 92, 246, 0.05);
  border-radius: 10px;
}

.reservation-description p {
  margin: 0;
  color: #cbd5e1;
}

.reservation-sono {
  margin-top: 0.5rem;
  font-size: 0.875rem;
}

.reservation-footer {
  padding: 1rem 1.5rem;
  border-top: 1px solid rgba(139, 92, 246, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

.action-valid, .action-refuse {
  padding: 0.3rem 1rem;
  border: none;
  border-radius: 50px;
  cursor: pointer;
  font-size: 0.8rem;
  transition: all 0.3s ease;
}

.action-valid {
  background: rgba(34, 197, 94, 0.2);
  color: #4ade80;
  border: 1px solid #22c55e;
}

.action-valid:hover {
  background: #22c55e;
  color: white;
}

.action-refuse {
  background: rgba(239, 68, 68, 0.2);
  color: #f87171;
  border: 1px solid #ef4444;
}

.action-refuse:hover {
  background: #ef4444;
  color: white;
}

.reservation-form .form-group {
  margin-bottom: 1rem;
}

.reservation-form label {
  display: block;
  margin-bottom: 0.25rem;
  color: #cbd5e1;
  font-size: 0.875rem;
}

.reservation-form input, 
.reservation-form select, 
.reservation-form textarea {
  width: 100%;
  padding: 0.75rem;
  background: rgba(15, 23, 42, 0.8);
  border: 1px solid rgba(139, 92, 246, 0.2);
  border-radius: 10px;
  color: white;
  font-size: 0.9rem;
}

.reservation-form input:focus,
.reservation-form select:focus,
.reservation-form textarea:focus {
  outline: none;
  border-color: #8b5cf6;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  margin-top: 1.5rem;
}

.text-success {
  color: #4ade80;
}

.text-danger {
  color: #f87171;
}

@media (max-width: 768px) {
  .form-row {
    grid-template-columns: 1fr;
  }
  
  .reservation-info {
    grid-template-columns: 1fr;
  }
  
  .reservation-footer {
    flex-direction: column;
    text-align: center;
  }
}
</style>


