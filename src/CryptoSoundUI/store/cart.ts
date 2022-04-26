export const state = () => ({
    isCartOpen: false,
    tracks: [] as string[],
    collection: [] as string[],
    kits: [] as string[],
});

export const mutations = {
    toggleCart(state: any) {
        state.isCartOpen = !state.isCartOpen;
    },
    addTrack(state: any, payload: string) {
        state.tracks.push(payload);
    },
    removeTrack(state: any, payload: string) {
        var itemIndex = state.tracks.indexOf(payload);
        state.tracks.splice(itemIndex, 1);
    },
};