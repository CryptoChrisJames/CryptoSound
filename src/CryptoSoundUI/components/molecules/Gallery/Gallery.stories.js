import gallery from './Gallery.vue';

export default {
    title: 'Gallery',
};

export const Gallery = () => ({
  components: { gallery },
  template: `
      <gallery></gallery>
  `,
})