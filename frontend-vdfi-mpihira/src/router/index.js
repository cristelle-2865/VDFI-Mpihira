import { createRouter, createWebHistory } from 'vue-router'
import Accueil from '../views/Accueil.vue'

const routes = [
  {
    path: '/',
    name: 'Accueil',
    component: Accueil
  },
  {
    path: '/membres',
    name: 'Membres',
    component: () => import('../views/Membres.vue')
  },
  {
    path: '/chansons',
    name: 'Chansons',
    component: () => import('../views/Chansons.vue')
  },
  {
    path: '/sorties',
    name: 'Sorties',
    component: () => import('../views/Sorties.vue')
  },
  {
    path: '/reservations',
    name: 'Reservations',
    component: () => import('../views/Reservations.vue')
  },
  {
    path: '/repertoires',
    name: 'Repertoires',
    component: () => import('../views/Repertoires.vue')
  },
  {
    path: '/medias',
    name: 'Medias',
    component: () => import('../views/Medias.vue')
  },
  {
    path: '/notifications',
    name: 'Notifications',
    component: () => import('../views/Notifications.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router

