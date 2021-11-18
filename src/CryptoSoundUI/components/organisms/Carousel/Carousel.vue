<template>
  <div class="carWrapper">
    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
      <ol class="carousel-indicators">
        <li
          v-for="(img, idx) in urls"
          :key="idx"
          data-target="#carouselExampleIndicators"
          :data-slide-to="idx"
          :class="idx == 0 ? 'active' : ''"
        >
        </li>
      </ol>
      <div class="carousel-inner" role="listbox">
        <img
          v-for="(img, idx) in urls"
          :key="idx"
          :class="['carousel-item', idx == 0 ? 'active' : '']"
          :src="img"
        />
      </div>
      <a href="#carouselExampleIndicators" class="carousel-control-prev" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="false"></span>
        <span class="sr-only">Previous</span>
      </a>
      <a href="#carouselExampleIndicators" class="carousel-control-next" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="false"></span>
        <span class="sr-only">Next</span>
      </a>
    </div>
  </div>
</template>

<script>
import config from '../../../config.js';

export default {
  name: "Carousel",
  data() {
    const urls = [];
    return {
      urls,
    };
  },
  props: {
    imageKeys: {
      type: Array,
      default: () => [],
    },
    imageUrls: {
      type: Array,
      default: () => [],      
    }
  },
  mounted() {
    if(this.imageUrls.length > 0) {
      this.urls = this.imageUrls;
    } else {
      this.urls = this.imageKeys;
    }
  },
  // methods: {
  //   getContent(key) {
  //       return this.getAPIUrl() + key;
  //   },
  //   getAPIUrl() {
  //       return config.currentSecurity() + config.currentEnvAPI() + '/design/';
  //   },
  // }
};
</script>

<style lang="scss" scoped>
.carWrapper {
  margin-bottom: 30px;
}
</style>