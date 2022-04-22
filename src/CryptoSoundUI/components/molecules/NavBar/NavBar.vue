<template>
  <div id="navApp">
    <div
      class="navigationWrapper"
      :class="[{'navbar-hidden': !showNav}, {'clearNav' : clearNav}]"
    >
      <Logo/>
      <div class="functionIcons">
        <v-row>
          <div class="cart-icon-wrapper" @click="toggleCart">
            <i class="fa-solid fa-cart-shopping centering"></i>
          </div>
          <Burger/>
        </v-row>
      </div>
    </div>
    <Sidebar @click="closeNav()">
      <ul class="sidebar-panel-nav">
        <li @click="closeNav()"><router-link to="/">Home</router-link></li>
        <li @click="closeNav()"><router-link to="/beats" @click="closeNav()">Beats</router-link></li>
        <li @click="closeNav()"><router-link to="/kits" @click="closeNav()">Kits</router-link></li>
        <li @click="closeNav()" v-if="userSignedIn == null"><router-link to="/auth/login" @click="closeNav()">Login</router-link></li>
        <li v-else><v-btn @click="logout()"> Logout </v-btn></li>
      </ul>
    </Sidebar>
  </div>
</template>

<script>
import isMobile from 'is-mobile';
import Burger from '../../atoms/NavBarItems/Burger.vue';
import Sidebar from '../../atoms/NavBarItems/Sidebar.vue';
import Logo from '../../atoms/Logo/Logo.vue';
import Cart from '../../organisms/Cart/Cart.vue';
import { mapMutations } from 'vuex';

export default {
  name: "NavBar",
  data() {
    const lastScrollPosition = 0;
    const showNav = true;
    return {
      lastScrollPosition,
      showNav,
    };
  },
  components: {
    Burger,
    Sidebar,
    Logo,
  },
  computed: {
    isMobile(){
      return isMobile();
    },
    clearNav() {
      return this.$store.state.clearNav;
    },
    contactPage() {
      return this.$route.fullPath.includes("contact");
    },
    aboutPage() {
      return this.$route.fullPath.includes("about");
    },
    userSignedIn() {
      return this.$store.state.user.user;
    },
  },
  mounted() {
      window.addEventListener('scroll', this.onScroll);
  },
  beforeDestroy() {
      window.removeEventListener('scroll', this.onScroll);
  },
  methods: {
    ...mapMutations({
            toggleNav: 'toggleNav',
            toggleCart: 'cart/toggleCart'
        }),
    onScroll() {
      const currentScrollPosition = window.pageYOffset || document.documentElement.scrollTop;
      if(currentScrollPosition < 0) {
          return;
      }
      if (Math.abs(currentScrollPosition - this.lastScrollPosition) < 60) {
          return;
      }
      this.showNav = currentScrollPosition < this.lastScrollPosition;
      this.lastScrollPosition = currentScrollPosition;
    },
    closeNav() {
      this.$store.commit("toggleNav");
      this.showCart = false;
    },
    logout() {
      this.closeNav();
      this.$firebase.logout();
      this.$store.commit("user/logoutUser");
      if(this.$route.fullPath != "/") {
        this.$router.push("/");
      } else {
        this.$router.app.refresh();
      }
    },
  },
};
</script>

<style lang="scss" scoped>
@import '../../../styles/_colors.scss';
@import '../../../styles/_variables.scss';

.navigationWrapper {
  background-color:#111116;
  position: fixed;
  z-index: 999;
  max-width: 1600px;
  width: 100%;
  display: flex;
  height: 68px;
  -webkit-box-pack: justify;
  justify-content: space-between;
  -webkit-box-align: center;
  align-items: center;
  padding: 0 20px;
  transform: translate3d(0, 0, 0);
  transition: 0.3s all ease-out;
}

.functionIcons {
  width: auto;
  height: auto;
  display: inline-block;
  padding-right: 16px;
}

.cart-icon-wrapper {
  display: table;
  margin-right: 17px;
}

.centering {
  display: table-cell;
  vertical-align: middle;
  text-align: center;
}

ul.sidebar-panel-nav {
    list-style-type: none;
    text-align: center;
}

ul.sidebar-panel-nav>li>a {
    color:azure;
    text-decoration: none;
    font-size: 30px;
    display: block;
    padding: 15px 0;
}

.vue-link {
    color:azure;
    text-decoration: none;
    font-size: 30px;
    display: block;
    padding: 15px 0;
}

.clearNav {
  background-color: transparent;
}

.navbar-hidden {
  box-shadow: none;
  transform: translate3d(0, -100%, 0);
}
</style>