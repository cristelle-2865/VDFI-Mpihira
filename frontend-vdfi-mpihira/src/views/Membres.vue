<template>
  <div class="membres-page">
    <div class="page-header">
      <h1>
        <i class="fas fa-users"></i>
        Nos Membres
      </h1>
      <p>Découvrez l'équipe de VDFI Mpihira - Chanteurs, musiciens et responsables unis pour la gloire de Dieu</p>
    </div>

    <!-- Filtres par catégorie -->
    <div class="filters">
      <button 
        v-for="cat in categories" 
        :key="cat.value"
        :class="['filter-btn', { active: selectedCategorie === cat.value }]"
        @click="selectedCategorie = cat.value">
        <i :class="cat.icon"></i>
        {{ cat.label }}
      </button>
    </div>

    <!-- Statistiques -->
    <div class="stats-row">
      <div class="stat-box">
        <i class="fas fa-microphone-alt"></i>
        <div>
          <span class="stat-number">{{ chanteursCount }}</span>
          <span class="stat-label">Chanteurs</span>
        </div>
      </div>
      <div class="stat-box">
        <i class="fas fa-guitar"></i>
        <div>
          <span class="stat-number">{{ musiciensCount }}</span>
          <span class="stat-label">Musiciens</span>
        </div>
      </div>
      <div class="stat-box">
        <i class="fas fa-user-tie"></i>
        <div>
          <span class="stat-number">{{ responsablesCount }}</span>
          <span class="stat-label">Responsables</span>
        </div>
      </div>
    </div>

    <!-- Grille des membres -->
    <div class="membres-grid" v-if="!loading">
      <div v-for="membre in membresFiltres" :key="membre.id_membre" class="membre-card">
        <div class="membre-photo">
          <img :src="membre.photo_path || '/default-avatar.png'" :alt="membre.nom">
          <div class="categorie-badge" :class="getCategorieClass(membre.categorie)">
            {{ getCategorieLabel(membre.categorie) }}
          </div>
        </div>
        <div class="membre-info">
          <h3>{{ membre.prenom }} {{ membre.nom }}</h3>
          <p class="role">{{ membre.role || getCategorieLabel(membre.categorie) }}</p>
          <div class="social-icons" v-if="membre.social">
            <a v-if="membre.social.facebook" :href="membre.social.facebook" target="_blank"><i class="fab fa-facebook"></i></a>
            <a v-if="membre.social.instagram" :href="membre.social.instagram" target="_blank"><i class="fab fa-instagram"></i></a>
            <a v-if="membre.social.whatsapp" :href="'https://wa.me/' + membre.social.whatsapp" target="_blank"><i class="fab fa-whatsapp"></i></a>
          </div>
        </div>
      </div>
    </div>

    <div v-if="loading" class="loading-spinner">
      <div class="spinner"></div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Membres',
  data() {
    return {
      membres: [],
      loading: true,
      selectedCategorie: 'tous',
      categories: [
        { value: 'tous', label: 'Tous', icon: 'fas fa-users' },
        { value: 'chanteur', label: 'Chanteurs', icon: 'fas fa-microphone-alt' },
        { value: 'chanteuse', label: 'Chanteuses', icon: 'fas fa-microphone-alt' },
        { value: 'musicien', label: 'Musiciens', icon: 'fas fa-guitar' },
        { value: 'musicienne', label: 'Musiciennes', icon: 'fas fa-guitar' },
        { value: 'responsable', label: 'Responsables', icon: 'fas fa-user-tie' },
        { value: 'chef_de_choeur', label: 'Chefs de Chœur', icon: 'fas fa-chalkboard-user' },
        { value: 'auteur_compositeur', label: 'Auteurs', icon: 'fas fa-pen-fancy' },
        { value: 'technicienne', label: 'Techniciens', icon: 'fas fa-microchip' }
      ]
    }
  },
  computed: {
    membresFiltres() {
      if (this.selectedCategorie === 'tous') {
        return this.membres
      }
      return this.membres.filter(m => m.categorie === this.selectedCategorie)
    },
    chanteursCount() {
      return this.membres.filter(m => m.categorie === 'chanteur' || m.categorie === 'chanteuse').length
    },
    musiciensCount() {
      return this.membres.filter(m => m.categorie === 'musicien' || m.categorie === 'musicienne').length
    },
    responsablesCount() {
      return this.membres.filter(m => m.categorie === 'responsable' || m.categorie === 'chef_de_choeur').length
    }
  },
  mounted() {
    this.fetchMembres()
  },
  methods: {
    async fetchMembres() {
      try {
        const response = await axios.get('/api/membres')
        this.membres = response.data
      } catch (error) {
        console.error('Erreur:', error)
        // Données mock
        this.membres = [
          { id_membre: 1, nom: 'Zoky', prenom: 'Vahatra', role: '1er Responsable', categorie: 'responsable', photo_path: '/photos/ZokyVahatra.jpg' },
          { id_membre: 2, nom: 'Zoky', prenom: 'Holy', role: '1ere Responsable', categorie: 'responsable', photo_path: '/photos/ZokyHoly.jpg' },
          { id_membre: 3, nom: 'RASOAMANANA', prenom: 'Mbolatiana Toky', role: 'Auteur-Compositeur', categorie: 'auteur_compositeur', photo_path: '/photos/Mbola.jpg' },
          { id_membre: 4, nom: 'ANDRIAMANJATO', prenom: 'Lahatriniavo Fandresena', role: 'Chef de Choeur', categorie: 'chef_de_choeur', photo_path: '/photos/Fandresena.jpg' },
          { id_membre: 5, nom: 'ANDINIRINAMALALA', prenom: 'Anjara Tinatia', role: 'Responsable medias', categorie: 'responsable', photo_path: '/photos/Tinatia.jpg' },
          { id_membre: 6, nom: 'RAFIRINGANIRINA', prenom: 'Lovatiana Zo', role: '1ere voix', categorie: 'chanteuse', photo_path: '/photos/Zo.jpg' },
          { id_membre: 7, nom: 'RAKOTOARISOA', prenom: 'Oniniaina', role: '1ere voix', categorie: 'chanteuse', photo_path: '/photos/Oniniaina.jpg' },
          { id_membre: 8, nom: 'RAKOTOMIHAJA', prenom: 'Tantanantsoa', role: '1ere voix', categorie: 'chanteuse', photo_path: '/photos/Tantanantsoa.jpg' },
          { id_membre: 9, nom: 'RAKOTONANAHARY', prenom: 'Tsirava Finiavana', role: '1ere/2eme voix', categorie: 'chanteuse', photo_path: '/photos/Tsirava.jpg' },
          { id_membre: 10, nom: 'RAHARINIRINA', prenom: 'Vonifanja Nathalie', role: '2eme voix', categorie: 'chanteuse', photo_path: '/photos/Nathalie.jpg' },
          { id_membre: 12, nom: 'ANDRIANTSIMANIRY', prenom: 'Iaritiana Famenontsoa', role: '3eme voix', categorie: 'chanteur', photo_path: '/photos/Famenontsoa.jpg' },
          { id_membre: 13, nom: 'RAKOTOMALALA', prenom: 'Fifaliana Mamilalaina', role: '3eme voix', categorie: 'chanteur', photo_path: '/photos/Fifaliana.jpg' },
          { id_membre: 14, nom: 'VAHATRINIAINA', prenom: 'Tiavo', role: '3eme voix', categorie: 'chanteur', photo_path: '/photos/Tiavo.jpg' },
          { id_membre: 15, nom: 'RALAIKOA', prenom: 'Falinirina Raphael Joseph', role: 'Clavieriste', categorie: 'musicien', photo_path: '/photos/Raphael.png' },
          { id_membre: 16, nom: 'NOMENJANAHARY', prenom: 'Sitrakiniaina Erick', role: 'Clavieriste', categorie: 'musicien', photo_path: '/photos/Erick.jpg' },
          { id_membre: 17, nom: 'RAZANADRAKOTO', prenom: 'Nirintsoa Heriniaina', role: 'Guitariste', categorie: 'musicien', photo_path: '/photos/Aina.jpg' },
          { id_membre: 18, nom: 'LALAINAHARIJAONA', prenom: 'Anjara Toavina', role: 'Bassiste', categorie: 'musicien', photo_path: '/photos/Toavina.jpg' },
          { id_membre: 19, nom: 'ANDRY NANTENAINA', prenom: 'Toky', role: 'Batteur', categorie: 'musicien', photo_path: '/photos/Toky.jpg' },
          { id_membre: 20, nom: 'RASOAMANANA', prenom: 'Mitia Talenta', role: 'Violiniste', categorie: 'musicienne', photo_path: '/photos/Mitia.jpg' }
        ]
      } finally {
        this.loading = false
      }
    },
    getCategorieClass(categorie) {
      const classes = {
        'responsable': 'badge-purple',
        'chef_de_choeur': 'badge-blue',
        'auteur_compositeur': 'badge-green',
        'chanteur': 'badge-pink',
        'chanteuse': 'badge-pink',
        'musicien': 'badge-orange',
        'musicienne': 'badge-orange',
        'technicienne': 'badge-gray'
      }
      return classes[categorie] || 'badge-gray'
    },
    getCategorieLabel(categorie) {
      const labels = {
        'responsable': 'Responsable',
        'chef_de_choeur': 'Chef de Chœur',
        'auteur_compositeur': 'Auteur/Compositeur',
        'chanteur': 'Chanteur',
        'chanteuse': 'Chanteuse',
        'musicien': 'Musicien',
        'musicienne': 'Musicienne',
        'technicienne': 'Technicien'
      }
      return labels[categorie] || categorie
    }
  }
}
</script>




