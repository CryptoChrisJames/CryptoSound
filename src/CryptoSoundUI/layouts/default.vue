<template>
    <div>
        <nav-bar />
        <nuxt />
        <bottom-buffer />
        <footer-audio-player />
    </div>
</template>

<script>
import BottomBuffer from '../components/atoms/Buffer/BottomBuffer.vue';
import navBar from '../components/molecules/NavBar/NavBar.vue';
import footerAudioPlayer from '../components/organisms/FooterAudioPlayer/FooterAudioPlayer.vue';
import Vue from 'vue';
import { getAuth, onAuthStateChanged } from 'firebase/auth';

export default {
    components: {
        navBar,
        footerAudioPlayer,
        BottomBuffer,
    },
    mounted() {
        this.setupFirebase()
    },
    methods: {
        setupFirebase() {
            onAuthStateChanged(getAuth(), user => {
                if(user) {
                    var currentUser = { 
                        email: user.email, 
                        value: user.accessToken,
                        uid: user.uid
                    }
                    this.$store.commit('user/setCurrentUser', currentUser);
                } else {
                    console.log('signed out');
                }
            })
        }
    },
};
</script>
