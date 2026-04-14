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
.chansons-page {
  animation: fadeInUp 0.6s ease;
}

.filters {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  flex-wrap: wrap;
}

.search-input {
  flex: 1;
  padding: 0.8rem 1.2rem;
  background: rgba(30, 41, 59, 0.6);
  border: 1px solid rgba(139, 92, 246, 0.2);
  border-radius: 50px;
  color: white;
  font-size: 1rem;
}

.search-input:focus {
  outline: none;
  border-color: #8b5cf6;
}

.genre-select {
  padding: 0.8rem 1.2rem;
  background: rgba(30, 41, 59, 0.6);
  border: 1px solid rgba(139, 92, 246, 0.2);
  border-radius: 50px;
  color: white;
  cursor: pointer;
}

.chansons-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 1.5rem;
}

.chanson-card {
  background: rgba(30, 41, 59, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  overflow: hidden;
  transition: all 0.3s ease;
  border: 1px solid rgba(139, 92, 246, 0.2);
}

.chanson-card:hover {
  transform: translateY(-5px);
  border-color: #8b5cf6;
}

.chanson-header {
  background: linear-gradient(135deg, rgba(139, 92, 246, 0.2), rgba(236, 72, 153, 0.2));
  padding: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chanson-icon i {
  font-size: 2.5rem;
  color: #8b5cf6;
}

.genre-badge {
  padding: 0.3rem 0.8rem;
  background: rgba(139, 92, 246, 0.3);
  border-radius: 50px;
  font-size: 0.75rem;
}

.chanson-body {
  padding: 1.5rem;
}

.chanson-body h3 {
  margin-bottom: 0.75rem;
  font-size: 1.2rem;
}

.chanson-body p {
  margin: 0.5rem 0;
  color: #94a3b8;
  font-size: 0.875rem;
}

.chanson-body p i {
  width: 20px;
  color: #8b5cf6;
}

.chanson-actions {
  display: flex;
  border-top: 1px solid rgba(139, 92, 246, 0.1);
}

.action-btn {
  flex: 1;
  padding: 1rem;
  background: none;
  border: none;
  color: #94a3b8;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1.1rem;
}

.action-btn:hover:not(:disabled) {
  background: rgba(139, 92, 246, 0.2);
  color: #8b5cf6;
}

.action-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(5px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.modal-content {
  background: linear-gradient(135deg, #1e293b, #0f172a);
  border-radius: 20px;
  width: 90%;
  max-width: 600px;
  max-height: 80vh;
  overflow: hidden;
  border: 1px solid rgba(139, 92, 246, 0.3);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid rgba(139, 92, 246, 0.2);
}

.modal-header h2 {
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  color: #94a3b8;
  font-size: 1.5rem;
  cursor: pointer;
  transition: color 0.3s ease;
}

.close-btn:hover {
  color: #ec4899;
}

.modal-body {
  padding: 1.5rem;
  overflow-y: auto;
  max-height: 60vh;
}

.paroles pre {
  white-space: pre-wrap;
  font-family: inherit;
  line-height: 1.6;
  color: #cbd5e1;
}

@media (max-width: 768px) {
  .filters {
    flex-direction: column;
  }
  
  .chansons-grid {
    grid-template-columns: 1fr;
  }
}
</style>

