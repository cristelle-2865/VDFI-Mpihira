<template>
  <div class="chansons-page">
    <div class="page-header">
      <h1>
        <i class="fas fa-music"></i>
        Nos Chansons
      </h1>
      <p>Découvrez nos compositions originales - Paroles, partitions, playbacks et vidéos</p>
    </div>

    <!-- Filtres -->
    <div class="filters">
      <input 
        type="text" 
        v-model="searchTerm" 
        placeholder="Rechercher une chanson..."
        class="search-input">
      <select v-model="selectedGenre" class="genre-select">
        <option value="tous">Tous les genres</option>
        <option value="Gospel">Gospel</option>
        <option value="Adoration">Adoration</option>
        <option value="Louange">Louange</option>
      </select>
    </div>

    <!-- Grille des chansons -->
    <div class="chansons-grid" v-if="!loading">
      <div v-for="chanson in chansonsFiltrees" :key="chanson.id_chanson" class="chanson-card">
        <div class="chanson-header">
          <div class="chanson-icon">
            <i class="fas fa-head-side-vr"></i>
          </div>
          <span class="genre-badge">{{ chanson.genre || 'Gospel' }}</span>
        </div>
        <div class="chanson-body">
          <h3>{{ chanson.titre }}</h3>
          <p class="auteur">
            <i class="fas fa-user-pen"></i>
            {{ chanson.auteur }}
          </p>
          <p class="date">
            <i class="fas fa-calendar"></i>
            {{ formatDate(chanson.date_creation) }}
          </p>
        </div>
        <div class="chanson-actions">
          <button class="action-btn" @click="voirParoles(chanson)" title="Paroles">
            <i class="fas fa-align-left"></i>
          </button>
          <button class="action-btn" @click="voirPartition(chanson)" title="Partition PDF" :disabled="!chanson.partition_pdf">
            <i class="fas fa-file-pdf"></i>
          </button>
          <button class="action-btn" @click="ecouterAudio(chanson)" title="Playback/Audio">
            <i class="fas fa-headphones"></i>
          </button>
          <button class="action-btn" @click="voirVideo(chanson)" title="Clip vidéo">
            <i class="fas fa-video"></i>
          </button>
        </div>
      </div>
    </div>

    <div v-if="loading" class="loading-spinner">
      <div class="spinner"></div>
    </div>

    <!-- Modal Paroles -->
    <div v-if="modalVisible" class="modal" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>{{ selectedChanson?.titre }}</h2>
          <button class="close-btn" @click="closeModal"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
          <div class="paroles">
            <pre>{{ selectedChanson?.paroles || 'Paroles non disponibles' }}</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Chansons',
  data() {
    return {
      chansons: [],
      loading: true,
      searchTerm: '',
      selectedGenre: 'tous',
      modalVisible: false,
      selectedChanson: null
    }
  },
  computed: {
    chansonsFiltrees() {
      let result = this.chansons
      if (this.searchTerm) {
        result = result.filter(c => 
          c.titre.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
          c.auteur.toLowerCase().includes(this.searchTerm.toLowerCase())
        )
      }
      if (this.selectedGenre !== 'tous') {
        result = result.filter(c => c.genre === this.selectedGenre)
      }
      return result
    }
  },
  mounted() {
    this.fetchChansons()
  },
  methods: {
    async fetchChansons() {
      try {
        const response = await axios.get('/api/chansons')
        this.chansons = response.data
      } catch (error) {
        console.error('Erreur:', error)
        this.chansons = [
          { id_chanson: 1, titre: 'Fitiavana tsy mety maty', paroles: 'Paroles de la chanson...', auteur: 'RASOAMANANA Mbolatiana Toky', genre: 'Gospel', date_creation: '2024-01-15', partition_pdf: '/partitions/fitiavana.pdf' },
          { id_chanson: 2, titre: 'Masoandro velona', paroles: 'Paroles de la chanson...', auteur: 'RASOAMANANA Mbolatiana Toky', genre: 'Adoration', date_creation: '2024-02-20', partition_pdf: '/partitions/masoandro.pdf' },
          { id_chanson: 3, titre: 'Voninahitra ho Anao', paroles: 'Paroles de la chanson...', auteur: 'ANDRIAMANJATO Lahatriniavo', genre: 'Louange', date_creation: '2024-03-10', partition_pdf: '/partitions/voninahitra.pdf' },
          { id_chanson: 4, titre: 'Fiderana mandrakizay', paroles: 'Paroles de la chanson...', auteur: 'RASOAMANANA Mbolatiana Toky', genre: 'Gospel', date_creation: '2024-04-05', partition_pdf: '/partitions/fiderana.pdf' },
          { id_chanson: 5, titre: 'Ny finoako', paroles: 'Paroles de la chanson...', auteur: 'ANDRIAMANJATO Lahatriniavo', genre: 'Adoration', date_creation: '2024-05-12', partition_pdf: '/partitions/finoako.pdf' }
        ]
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return d.toLocaleDateString('fr')
    },
    voirParoles(chanson) {
      this.selectedChanson = chanson
      this.modalVisible = true
    },
    voirPartition(chanson) {
      if (chanson.partition_pdf) {
        window.open(chanson.partition_pdf, '_blank')
      } else {
        alert('Partition non disponible pour cette chanson')
      }
    },
    ecouterAudio(chanson) {
      alert('Lecteur audio - Fonctionnalité à venir')
    },
    voirVideo(chanson) {
      alert('Lecteur vidéo - Fonctionnalité à venir')
    },
    closeModal() {
      this.modalVisible = false
      this.selectedChanson = null
    }
  }
}
</script>

<style scoped>
@import '../assets/css/views/chansons.css';
</style>

