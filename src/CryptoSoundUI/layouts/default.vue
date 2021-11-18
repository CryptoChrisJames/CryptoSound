<template>
    <div>
        <nav-bar />
        <nuxt />
        <bottom-buffer />
        <footer-audio-player />
    </div>
</template>

<script lang="ts">
import BottomBuffer from '../components/atoms/Buffer/BottomBuffer.vue';
import navBar from '../components/molecules/NavBar/NavBar.vue';
import footerAudioPlayer from '../components/organisms/FooterAudioPlayer/FooterAudioPlayer.vue';
import Vue from 'vue';

export default Vue.extend({
    components: {
        navBar,
        footerAudioPlayer,
        BottomBuffer,
    },
});
</script>
