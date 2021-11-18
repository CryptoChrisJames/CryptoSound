import galleryItem from './GalleryItem.vue';

export default {
    title: 'Gallery Item',
};

export const GalleryItem = () => ({
    components: { galleryItem },
    computed: {
        image() {
            return '5db78e553358fb000742339b';
        }
    },
    template: `
        <gallery-item
            :videoName="image"
        ></gallery-item>
    `,
})