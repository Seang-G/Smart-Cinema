import { createWebHistory, createRouter } from "vue-router";
import MainHome from "../views/MainHome.vue";


const routes = [
  // {
  //   path: "/",
  //   name: "Home",
  //   component: Home
  // },
];

const router = new createRouter({
  history: createWebHistory(),
  routes
});

export default router;