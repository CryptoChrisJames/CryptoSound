export const state = () => ({
    isNavOpen: false,
    clearNav: false,
});

export const mutations = {
    toggleNav(state: any) {
        state.isNavOpen = !state.isNavOpen;
    },
    clearNav(state: any) {
        state.clearNav = !state.clearNav;
    },
    makeNavClearOnHeroLoad(state: any) {
        state.clearNav = true;
    },
    makeNavVisible(state: any) {
        state.clearNav = false;
    }
};

export const actions = {
    async nuxtServerInit({dispatch}: any) {
        await dispatch('content/initialLoad');
    }
}