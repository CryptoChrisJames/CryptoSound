<template>
    <div class="playerWrapper">
        <div class="player">
            <ul class="tracklist">
                <li
                    class="track"
                    v-for="t in currentCollection.tracks"
                    :key="t.id"
                    :class="[ currentTrackSelected == t.id ? 'trackIsSelected' : '']"
                >
                    <div class="trackWrapper">
                        <div class="trackArtworkWrapper" 
                            @click="currentTrackSelected == t.id && isPlaying ? pauseTrack()
                                : currentTrackSelected == t.id && !isPlaying ? playTrack()
                                : updatePlaylist(t.id)">
                            <img
                                :src="currentCollection.cover"
                                class="trackCover"
                            />
                            <div class="trackCoverOverlay">
                                <i v-if="currentTrackSelected == t.id && isPlaying" class="fa-solid fa-pause"></i>
                                <i v-else class="fa-solid fa-play"></i>
                            </div>
                        </div>
                        <div class="trackInfoWrapper"
                            @click="currentTrackSelected == t.id && isPlaying ? pauseTrack()
                                : currentTrackSelected == t.id && !isPlaying ? playTrack()
                                : updatePlaylist(t.id)">
                            <div class="trackTitle">{{ t.name }}</div>
                            <div class="trackPrice"><i class="fa-solid fa-dollar-sign"></i>{{ t.price }}.00 | {{ currentCollection.creator }}</div>
                        </div>
                        <div class="trackStatusWrapper">
                            <add-to-cart-button :productId="t.productId" :productType="'track'" />
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import AddToCartButton from '../../atoms/CartButtons/AddToCartButton.vue';

export default {
    name: "player",
    components: {
        AddToCartButton,
    },
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

.playerWrapper {
    margin: 24px 0;
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
    padding: 0 20px;
}

.trackInfoWrapper {
    display: flex;
    flex-direction: column;
    justify-content: center;
    flex: 1 1;
    margin-left: 12px;
    overflow: hidden;
    font-size: 16px;
    font-weight: bold;
}

.trackArtworkWrapper {
    position: relative;
}

.trackCover {
    display: block;
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

.trackPrice {
    padding-top: 8px;
    font-family: 'Anurati';
}

.trackCoverOverlay {
    position: absolute;
    bottom: 0;
    width: 100%;
    height: 100%;
    color: rgba(20, 20, 20, 0.747);
    font-size: 24px;
    text-align: center;
    border-radius: 5px;
    display: flex;
    align-items: center;

    i.fa-solid {
        margin: 0 auto;
    }
}
</style>