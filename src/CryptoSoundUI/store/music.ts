export const state = () => ({
    currentTrackSelected: null as string,
    isPlaying: false,
});

export const mutations = {
    startPlaying(state: any) {
        state.isPlaying = true;
    },
    stopPlaying(state: any) {
        state.isPlaying = false;
    },
    setCurrentTrack(state: any, payload: any) {
        state.currentTrackSelected = payload;
    }
};

