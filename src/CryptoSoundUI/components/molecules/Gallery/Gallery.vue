<template>
  <span class="galleryWrapper">
    <div class="galleryContainer" id="work">
      <div
        v-for="item in orderedItems"
        v-bind:key="item.videoName"
      >
        <gallery-item
          :videoContent="item"
        >
          <img :src="item.thumbnail" />
        </gallery-item>
      </div>
    </div>
  </span>
</template>

<script>
import galleryItem from '../../atoms/GalleryItem/GalleryItem.vue';

export default {
  name: 'Gallery',
  components: { 
    galleryItem,
  },
  props: {
    galleryItems: {
      type: Array,
      default: () => [],
    },
  },
  computed: {
    orderedItems() {
      if (this.galleryItems) {
        var items = this.$_.orderBy(this.galleryItems, i => 
          i.displayOrder, ['asc']);
        return items; 
      }
    },
  },
};
</script>

<style lang="scss" scoped>
@import '../../../styles/_variables.scss';
.galleryContainer {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;

  @include tablet {
    grid-template-columns: 1fr 1fr;    
  }
  
  @include phone {
    grid-template-columns: 1fr; 
  }
}
</style>