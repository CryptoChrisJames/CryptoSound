<template>
    <div class="playerWrapper">
        <div class="player">
            <ul class="tracklist">
                <li
                    class="track"
                    v-for="t in currentCollection.tracks"
                    :key="t.id"
                    @click="currentTrackSelected == t.id && isPlaying ? pauseTrack()
                        : currentTrackSelected == t.id && !isPlaying ? playTrack()
                        : updatePlaylist(t.id)"
                    :class="[ currentTrackSelected == t.id ? 'trackIsSelected' : '']"
                >
                    <div class="trackWrapper">
                        <div class="trackArtworkWrapper">
                            <img
                                :src="currentCollection.cover"
                                class="trackCover"
                            />
                        </div>
                        <div class="trackInfoWrapper">
                            <div class="trackTitle">{{ t.name }}</div>
                            <div class="trackCreator">{{ currentCollection.creator }}</div>
                        </div>
                        <div class="trackStatusWrapper">
                            <i v-if="currentTrackSelected == t.id && isPlaying" class="fa-solid fa-pause"></i>
                            <i v-else class="fa-solid fa-play"></i>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
export default {
    name: "player",
    computed: {
        isPlaying() {
            return this.$store.state.music.isPlaying;
        },
        currentTrackSelected() {
            if (this.$store.state.music.currentTrackSelected) {
                return this.$store.state.music.currentTrackSelected;
            }
        },
    },
    props: {
        currentCollection: {
            type: Object,
            required: true,
            default: () => {}
        },
    },
    methods: {
        updatePlaylist(trackId) {
            this.$nuxt.$emit('playlistUpdate', {
                collection: this.currentCollection,
                trackId: trackId,
            });
        },
        playTrack() {
            this.$nuxt.$emit('playTrack');
        },
        pauseTrack() {
            this.$nuxt.$emit('pauseTrack');
        },
    },
};
</script>

<style lang="scss" scoped>
@import '../../../styles/_mixins.scss';

.player {
    padding: 0 20px;
}

.track {
    height: 77px;
    width: 100%;
    display: flex;
}

.trackWrapper {
    display: flex;
    flex-direction: row;
    align-items: center;
    width: 100%;
    border-bottom: 1px solid #5b5968
}

.trackInfoWrapper {
    display: flex;
    flex-direction: column;
    justify-content: center;
    flex: 1 1;
    margin-left: 12px;
    overflow: hidden;
    font-size: 15px;
    font-weight: bold;
}

.trackCover {
    height: 55px;
    width: 55px;
    border-radius: 5px;
}

.trackStatusWrapper {
    float: right;
    margin: 0 20px;
}

.trackCreator {
    color: #b9b9b9;
}

.trackIsSelected {
    background-color: rgba(114, 114, 128, 0.329);
}
</style>