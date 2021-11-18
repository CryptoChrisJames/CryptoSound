import sectionHead from './SectionHead.vue';

export default {
    title: 'Section Head',
};

export const SectionHead = () => ({
    components: { sectionHead },
    template: `
        <section-head>This is a Header</section-head>
    `,
})