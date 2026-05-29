<template>
  <footer class="footer">
    <div class="footer-content">
      <div class="footer-section">
        <div class="footer-logo">
          <i class="fas fa-music"></i>
          <span>VDFI Mpihira</span>
        </div>
        <p class="footer-description">
          Groupe de louange et d'adoration dédié à la propagation de l'évangile à travers la musique.
        </p>
        <div class="social-links">
          <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
          <a href="#" class="social-link"><i class="fab fa-youtube"></i></a>
          <a href="#" class="social-link"><i class="fab fa-tiktok"></i></a>
        </div>
      </div>

      <div class="footer-section">
        <h4>Liens Rapides</h4>
        <ul>
          <li><router-link to="/membres"><i class="fas fa-chevron-right"></i> Membres</router-link></li>
          <li><router-link to="/chansons"><i class="fas fa-chevron-right"></i> Chansons</router-link></li>
          <li><router-link to="/sorties"><i class="fas fa-chevron-right"></i> Sorties</router-link></li>
          <li><router-link to="/reservations"><i class="fas fa-chevron-right"></i> Réservations</router-link></li>
        </ul>
      </div>

      <div class="footer-section">
        <h4>Contact</h4>
        <ul>
          <li><i class="fas fa-envelope"></i> contact@vdfimpihira.mg</li>
          <li><i class="fas fa-phone"></i> +261 34 00 000 00</li>
          <li><i class="fas fa-map-marker-alt"></i> Antananarivo, Madagascar</li>
        </ul>
      </div>

      <div class="footer-section">
        <h4>Horaires de Répétition</h4>
        <ul>
          <li><i class="fas fa-calendar"></i> Mardi & Jeudi</li>
          <li><i class="fas fa-clock"></i> 18h00 - 21h00</li>
          <li><i class="fas fa-map-pin"></i> METM Avaradoha</li>
        </ul>
      </div>
    </div>

    <div class="footer-bottom">
      <p>&copy; 2025 VDFI Mpihira. Tous droits réservés.</p>
      <p>Développé avec <i class="fas fa-heart"></i> pour la gloire de Dieu</p>
    </div>
  </footer>
</template>

<script>
export default {
  name: 'Footer'
}
</script>

<style scoped>
@import '../assets/css/components/footer.css';
</style>


