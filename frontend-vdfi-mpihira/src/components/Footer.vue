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
.footer {
  background: linear-gradient(135deg, #0f172a, #1e1b4b);
  border-top: 1px solid rgba(139, 92, 246, 0.2);
  margin-top: auto;
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 3rem 2rem;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.footer-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
}

.footer-logo i {
  color: #8b5cf6;
}

.footer-logo span {
  background: linear-gradient(135deg, #8b5cf6, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.footer-description {
  color: #94a3b8;
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.social-links {
  display: flex;
  gap: 1rem;
}

.social-link {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(139, 92, 246, 0.1);
  border-radius: 50%;
  color: #a78bfa;
  transition: all 0.3s ease;
}

.social-link:hover {
  background: #8b5cf6;
  color: white;
  transform: translateY(-3px);
}

.footer-section h4 {
  color: #f1f5f9;
  margin-bottom: 1rem;
  font-size: 1.1rem;
}

.footer-section ul {
  list-style: none;
}

.footer-section ul li {
  margin-bottom: 0.75rem;
  color: #94a3b8;
}

.footer-section ul li i {
  width: 25px;
  color: #8b5cf6;
}

.footer-section ul li a {
  color: #94a3b8;
  text-decoration: none;
  transition: color 0.3s ease;
}

.footer-section ul li a:hover {
  color: #a78bfa;
}

.footer-section ul li a i {
  font-size: 0.75rem;
  margin-right: 8px;
}

.footer-bottom {
  text-align: center;
  padding: 1.5rem;
  border-top: 1px solid rgba(139, 92, 246, 0.1);
  color: #64748b;
}

.footer-bottom i {
  color: #ec4899;
}

@media (max-width: 768px) {
  .footer-content {
    grid-template-columns: 1fr;
    text-align: center;
    padding: 2rem 1.5rem;
  }

  .footer-logo {
    justify-content: center;
  }

  .social-links {
    justify-content: center;
  }

  .footer-section ul li i {
    width: auto;
    margin-right: 8px;
  }
}
</style>


