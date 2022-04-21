<template>
    <div class="footerAudioPlayerWrapper">
        <div
            class="footerPlayer"
            :class="[!trackSelected ? 'footerHidden' : '']"
        >
            <span class="progressSectionWrapper">
                <span class="currentTime">
                    <span id="current-time" class="time">{{ currentTime }}</span>
                </span>
                <span class="progressWrapper">
                    <input
                        ref="seekSlider"
                        @input="setNewCurrentTime()"
                        type="range"
                        :max="songDuration"
                        :value="currentTimeUnformatted"
                        class="progressBar seek"
                    />
                </span>
                <span class="remainingTime">
                    <span id="duration" class="time">{{ durationTime }}</span>
                </span>
            </span>
            <span class="audioBottomSection">
                <div class="infoSection">
                    <img :src="currentCover" class="currentCover">
                    <div class="infoWrapper">
                        <div class="trackTitle info">{{ currentTrackName }}</div>
                        <div class="trackCreator info">{{ currentCreator }}</div>
                    </div>
                </div>
                <div class="actionsSection">
                    <span class="actions">
                        <i @click="previousTrack()" class="fas fa-step-backward audioAction"></i>
                        <i
                            v-if="isPlaying"
                            @click="playTrackFromFooter()"
                            class="fa-solid fa-pause audioAction"
                        ></i>
                        <i
                            v-else
                            @click="playTrackFromFooter()"
                            class="fa-solid fa-play audioAction"
                        ></i>
                        <i @click="nextTrack()" class="fa-solid fa-step-forward audioAction"></i>
                    </span>
                </div>
                <div v-show="!isMobile" class="volumeSection">
                    <span class="muteSection">
                        <i @click="unmute" v-if="muted || currentVolume == 0" class="fas fa-volume-off"></i>
                        <i @click="mute" v-else class="fa-solid fa-volume-up"></i>
                    </span>
                    <span class="volSliderSection">
                        <input
                            ref="volumeSlider"
                            @input="setVolume()"
                            type="range"
                            :max="100"
                            :value="currentVolume"
                            class="volumeSeek"
                        />
                    </span>
                </div>
            </span>
        </div>
    </div>
</template>

<script>
import isMobile from 'is-mobile';

export default {
    name: 'FooterAudioPlayer',
    data() {
        const currentPlaylist = null;
        const currentTrackSelected = null;
        const currentTrackIndex = null;
        const music = null;
        const songDuration = null;
        const currentTime = null;
        const currentTimeUnformatted = null;
        const trackSelected = false;
        const isPlaying = false;
        const currentVolume = 80;
        const muted = false;
        const previousVolume = null;
        return {
            currentPlaylist,
            currentTrackSelected,
            music,
            songDuration,
            currentTime,
            currentTimeUnformatted,
            trackSelected,
            isPlaying,
            currentTrackIndex,
            currentVolume,
            muted,
            previousVolume,
        };
    },
    mounted() {
        this.$nuxt.$on('playlistUpdate', (payload) => this.playlistUpdate(payload));
        this.$nuxt.$on('playTrack', () => this.playTrack());
        this.$nuxt.$on('pauseTrack', () => this.pauseTrack());
        this.initializePlayer();
    },
    computed: {
        isMobile() {
            return isMobile();
        },
        currentCover() {
            if(this.currentPlaylist) {
                return this.currentPlaylist.cover;
            }
        },
        currentCreator() {
            if(this.currentPlaylist) {
                return this.currentPlaylist.creator;
            }
        },
        currentTrackName() {
            if(this.currentTrackSelected) {
                return this.currentPlaylist.tracks[this.currentTrackIndex].name;
            }
        },
        durationTime() {
            if (this.songDuration) {
                const min = Math.floor(this.songDuration / 60);
                const sec = Math.floor(this.songDuration % 60);
                const returnedSeconds = sec < 10 ? `0${sec}` : `${sec}`;
                return `${min}:${returnedSeconds}`;
            }
        },
    },
    methods: {
        initializePlayer() {
            var music = new Audio();
            music.addEventListener('loadeddata', () => {
                this.songDuration = music.duration;
            });
            music.addEventListener("ended", this.nextTrack);
            music.addEventListener("timeupdate", this.setCurrentTime);
            music.volume = this.currentVolume / 100;
            this.music = music;
        },
        playlistUpdate(payload) {
            this.currentPlaylist = payload.collection;
            this.currentTrackSelected = payload.trackId;
            this.currentTrackIndex = this.currentPlaylist.tracks.findIndex((t) => {
                return t.id == payload.trackId;
            });
            this.playNewPlaylist();
        },
        playNewPlaylist() {
            var newTrack = this.currentPlaylist.tracks.find(t => t.id == this.currentTrackSelected);
            this.$store.commit('music/startPlaying');
            this.$store.commit('music/setCurrentTrack', this.currentTrackSelected);
            this.music.src = newTrack.url;
            this.trackSelected = true;
            this.isPlaying = true;
            this.music.play();
        },
        playTrackFromFooter() {
            if(this.isPlaying) {
                this.isPlaying = false;
                this.$store.commit('music/stopPlaying');
                this.music.pause();
            } else {
                this.isPlaying = true;
                this.$store.commit('music/startPlaying');
                this.music.play();
            }
        },
        nextTrack() {
            this.currentTrackIndex++;
            if(this.currentTrackIndex == this.currentPlaylist.tracks.length) {
                this.currentTrackIndex = 0;
            }
            this.music.src = this.currentPlaylist.tracks[this.currentTrackIndex].url;
            this.currentTrackSelected = this.currentPlaylist.tracks[this.currentTrackIndex].id;
            this.$store.commit('music/setCurrentTrack', this.currentTrackSelected);
            this.$store.commit('music/startPlaying');
            this.isPlaying = true;
            this.music.play();
        },
        previousTrack() {
            if(this.currentTrackIndex == 0){
                this.currentTrackIndex = this.currentPlaylist.tracks.length - 1;
            } else{
                this.currentTrackIndex--;
            }
            this.music.src = this.currentPlaylist.tracks[this.currentTrackIndex].url;
            this.currentTrackSelected = this.currentPlaylist.tracks[this.currentTrackIndex].id;
            this.$store.commit('music/setCurrentTrack', this.currentTrackSelected);
            this.$store.commit('music/startPlaying');
            this.isPlaying = true;
            this.music.play();
        },
        setCurrentTime() {
            this.currentTimeUnformatted = this.music.currentTime;
            const min = Math.floor(this.music.currentTime / 60);
            const sec = Math.floor(this.music.currentTime % 60);
            const returnedSeconds = sec < 10 ? `0${sec}` : `${sec}`;
            this.currentTime = `${min}:${returnedSeconds}`;
        },
        setNewCurrentTime() {
            this.music.currentTime = this.$refs.seekSlider.value;
        },
        playTrack() {
            this.music.play();
            this.isPlaying = true;
            this.$store.commit('music/startPlaying');
        },
        pauseTrack() {
            this.music.pause();
            this.isPlaying = false;
            this.$store.commit('music/stopPlaying');
        },
        setVolume() {
            this.currentVolume = this.$refs.volumeSlider.value;
            this.music.volume = this.currentVolume / 100;
        },
        mute() {
            this.previousVolume = this.currentVolume;
            this.muted = true;
            this.music.volume = 0;
        },
        unmute() {
            this.currentVolume = this.previousVolume;
            this.muted = false;
            this.music.volume = this.currentVolume / 100;
        },
    },
};
</script>

<style lang="scss" scoped>
.footerPlayer {
    background-color:#111116;
    border-top: 1px solid rgb(142, 148, 148);
    display: grid;
    position: fixed;
    width: 100vw;
    height: 110px;
    margin: 0px;
    padding: 0px;
    bottom: 0px;
    z-index: 91;
    transform: translate3d(0, 0, 0);
    transition: 0.3s all ease-out;
}

.footerHidden {
    box-shadow: none;
    transform: translate3d(0, 100%, 0);
}

.progressSectionWrapper {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;

}

.currentTime {
    margin: 0 10px;
    font-size: 12px;
}

.remainingTime {
    margin: 0 10px;
    font-size: 12px;
}

.progressWrapper {
    position: relative;
    display: inline-block;
    width: 77%;
}

.progressBar {
    width:100%;
}

.seek {
    -webkit-appearance: none;
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: 100%;
    height: 10px;

    -webkit-border-radius: 50px;
    -moz-border-radius: 50px;
    border-radius: 50px;
    background-color: azure;
    margin:0 auto;
}

.seek::-webkit-slider-thumb {
    -webkit-appearance: none;
    width: 10px;
    height: 10px;

    -webkit-border-radius: 0px;
    border-radius: 0px;
    background: rgba(38, 38, 44, 0.808); /* Old browsers */
    /*background: -webkit-linear-gradient(top, #80e4df 0%, #75dbd6 13%, #5ec4bf 33%, #57bbb6 47%, #419d99 80%, #378f8b 100%);

    background: -moz-linear-gradient(top, #80e4df 0%, #75dbd6 13%, #5ec4bf 33%, #57bbb6 47%, #419d99 80%, #378f8b 100%);
    background: -o-linear-gradient(top, #80e4df 0%, #75dbd6 13%, #5ec4bf 33%, #57bbb6 47%, #419d99 80%, #378f8b 100%);
    background: linear-gradient(top, #80e4df 0%, #75dbd6 13%, #5ec4bf 33%, #57bbb6 47%, #419d99 80%, #378f8b 100%);*/
}

.actionsSection {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;

    i {
        font-size: 20px;
        padding: 0;
    }
}

.audioAction {
    margin: 0 10px;
}

.currentCover {
    float: left;
    height: 45px;
    width: 45px;
}

.trackCreator {
    color: #b9b9b9;
}

.audioBottomSection {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    margin-bottom: 20px;
}

.infoSection {
    font-size: 10px;
    display: grid;
    overflow: hidden;
    align-items: center;
    justify-content: center;
    grid-auto-flow: column;
    grid-auto-columns: auto;
    gap: 10px;
    margin-left: 7px;
    -webkit-box-pack: start;
    place-content: center start;
}

.trackTitle {
    display: initial;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;

}

.trackCreator {
    display: initial;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
}

.infoWrapper {
    font-size: 12px;
    display: flex;
    flex-direction: column;
}

.infoWrapper>div {
    width: 100%;
}

.info {
    width: 100%;
}

.volumeSection {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;

    i {
    }
}

.volSliderSection {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    width: 100px;
}

.volumeSeek {
    -webkit-appearance: none;
    width: 50%;
    height: 5px;

    -webkit-border-radius: 50px;
    -moz-border-radius: 50px;
    border-radius: 50px;
    background-color: azure;
    margin:0 10px;
    z-index: 5;
}

.volumeSeek::-webkit-slider-thumb {
    -webkit-appearance: none;
    width: 12px;
    height: 12px;

    -webkit-border-radius: 50px;
    border-radius: 50px;
    background: rgba(38, 38, 44, 0.808); /* Old browsers */
    /*background: -webkit-linear-gradient(top, #80e4df 0%, #75dbd6 13%, #5ec4bf 33%, #57bbb6 47%, #419d99 80%, #378f8b 100%);

    background: -moz-linear-gradient(top, #80e4df 0%, #75dbd6 13%, #5ec4bf 33%, #57bbb6 47%, #419d99 80%, #378f8b 100%);
    background: -o-linear-gradient(top, #80e4df 0%, #75dbd6 13%, #5ec4bf 33%, #57bbb6 47%, #419d99 80%, #378f8b 100%);
    background: linear-gradient(top, #80e4df 0%, #75dbd6 13%, #5ec4bf 33%, #57bbb6 47%, #419d99 80%, #378f8b 100%);*/
}
</style>