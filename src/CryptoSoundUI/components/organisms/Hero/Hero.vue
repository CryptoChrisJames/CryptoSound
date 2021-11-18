<template>
    <section ref="hero" class="videoHeaderContainer">
      <div class="videoContainer">
        <iframe
          :src="videoLink"
          frameborder="0"
          webkitallowfullscreen
          mozallowfullscreen
          allowfullscreen
        >
        </iframe>
      </div>
      <div class="videoHeaderContent">
        <slot />
      </div>
    </section>
</template>

<script>
export default {
  name: 'Hero',
  props: {
    videoLink: {
      type: String,
      required: true,
    },
  },
  computed: {
    clearNav() {
      return this.$store.state.clearNav;
    },
  },
  deactivated() {
    this.$store.commit('makeNavVisible');
  },
  mounted() {
    this.$store.commit('makeNavClearOnHeroLoad');
    window.addEventListener('scroll', this.checkVisibility);
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.checkVisibility);
  },
  methods: {
    checkVisibility() {
      if(this.clearNav == false) {
        if(this.$refs.hero.getBoundingClientRect().bottom >= 50){
          this.$store.commit('clearNav');
        }
      }
      else {
        if(this.$refs.hero.getBoundingClientRect().bottom < 50){
          this.$store.commit('clearNav');
        }
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.videoHeaderContainer {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  max-width: 100%;
  height: 100vh;
  width: 100vw;
}

.videoContainer {
  position: absolute;
  top: 0;
  left: 0;
  overflow: hidden;
  height: 100vh;
  width: 100%;
}

.videoContainer iframe {
  min-height: 1020px !important;
  min-width: 1980px !important;
  object-fit: cover;
  position: absolute !important;
  display: block;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  height: 100vh;
  width: 100vw;
}

.videoHeaderContent {
  display: block;
  position: relative;
  height: 100%;
  width: 100%;
  padding: 25px;
  margin-bottom: 0;
  z-index: 10;

  b {
    font-size: 2.5rem;
    font-weight: 900px;
  }

  @include widescreen {
    padding-left: 80px;
    padding-right: 80px;
  }
}
</style>