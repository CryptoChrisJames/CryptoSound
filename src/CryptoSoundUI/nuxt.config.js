export default {
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: 'CryptoSound',
    htmlAttrs: {
      lang: 'en'
    },
    generate: {
      dir: 'dist',
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' },
      { property:"og:title", content:"CryptoSound" },
      { property:"og:description", content:"CryptoSound is the brand new, fully custom, independently developed, beat and beat kit-selling web app! Check out these crazy beats today!" },
      { property:"og:image", content:"https://res.cloudinary.com/storycollector/image/upload/v1633620203/CryptoSound/InsomniacCover_rjbcxq.jpg" },
      { property:"og:url", content:"https://crypto-sound.com/" },
      { property:"twitter:title", content:"CryptoSound" },
      { property:"twitter:description", content:"CryptoSound is the brand new, fully custom, independently developed, beat and beat kit-selling web app! Check out these crazy beats today!" },
      { property:"twitter:image", content:"https://res.cloudinary.com/storycollector/image/upload/v1633620203/CryptoSound/InsomniacCover_rjbcxq.jpg" },
      { property:"twitter:url", content:"https://crypto-sound.com/" },
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      { rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.14.0/css/all.min.css', integrity: "sha512-1PKOgIY59xJ8Co8+NE6FZ+LOAZKjy+KY8iq0G4B3CyeY6wYHN3yt9PW0XpSriVlkMXe40PTKnXrLnZ9+fkDaog==", crossorigin: "anonymous" }
    ]
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
    '@/index.css',
    '~/layouts/global.css'
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    '~/plugins/contentful.js',
    '~/plugins/firebase.ts',
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/typescript
    '@nuxt/typescript-build',
    '@nuxtjs/style-resources',
    '@nuxtjs/vuetify',
    'cookie-universal-nuxt',
  ],

  // Modules (https://go.nuxtjs.dev/config-modules)
  modules: [
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    'vue-scrollto/nuxt'
  ],

  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {},

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
  },

  styleResources: {
    scss: [
      './styles/_colors.scss',
      './styles/_variables.scss',
    ]
  },
}
