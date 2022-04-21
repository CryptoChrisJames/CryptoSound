export const state = () => ({
    isCartOpen: false,
});

export const mutations = {
    toggleCart(state: any) {
        state.isCartOpen = !state.isCartOpen;
    },
};

export const actions = {
}