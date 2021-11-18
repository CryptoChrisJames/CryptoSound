import contentfulHelper from "~/helpers/contentfulHelper";

export const state = () => ({
    contentLoaded: false,
    logo: '',
    videoHeaderLink: '',
    promotions: [],
    collections: [],
});

export const mutations = {
    setAppContent(state, payload) {
        state.contentLoaded = true;
        state.logo = payload.logo;
        state.videoHeaderLink = payload.videoHeaderLink,
        state.promotions = payload.promotions;
        state.collections = payload.collections;
    },
};

export const actions = {
    async initialLoad({commit}) {
        const logo = await this.$contentful.getLogo();
        const videoHeaderLinks = await this.$contentful.getVideoHeaderLinks();
        const promotionalCollections = await this.$contentful.getPromotionCollections();
        const collections = await this.$contentful.getCollections();

        const appContent = {
            logo: logo,
            videoHeaderLink: videoHeaderLinks[0].link,
            promotions: contentfulHelper.parsePromotions(promotionalCollections),
            collections: contentfulHelper.parseCollections(collections.items),
        };

        commit('setAppContent', appContent);
    },
}