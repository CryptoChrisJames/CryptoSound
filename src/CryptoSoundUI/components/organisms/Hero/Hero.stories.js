import FSVB from './FullScreenVideoBackground.vue';

export default {
    title: 'FSVB',
};

export const VB = () => ({
    components: { FSVB },
    template: `
        <div>
            <FSVB />
        </div>
    `,
})