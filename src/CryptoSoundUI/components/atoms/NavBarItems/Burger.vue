<template>
    <div id="burger" :class="{ 'active' : isPanelOpen }" @click.prevent="toggleNav">
        <slot>
            <button type="button" class="burger-button" title="Menu">
                <span class="burger-bar burger-bar--1"></span>
                <span class="burger-bar burger-bar--2"></span>
                <span class="burger-bar burger-bar--3"></span>
            </button>
        </slot>
    </div>  
</template>

<script>
import { mapMutations } from 'vuex';
export default {
    name: "Burger",
    computed: {
        isPanelOpen() {
            return this.$store.state.isNavOpen;
        },
    },
    methods: {
        ...mapMutations({
            toggleNav: 'toggleNav'
        }),
    },
};
</script>

<style lang="scss" scoped>
.hidden {
    visibility: hidden;
}
button {
    cursor: pointer;
}
/* remove blue outline */
button:focus {
    outline: 0;
}
.burger-button {
    position: relative;
    height: 50px;
    width: 55px;
    display: block;
    z-index: 999;
    border: 0;
    border-radius: 0;
    background-color: transparent;
    pointer-events: all;
    transition: transform .6s cubic-bezier(.165, .84, .44, 1);
}
.burger-bar {
    background-color: white;
    position: absolute;
    top: 50%;
    right: 6px;
    left: 6px;
    height: 3px;
    width: auto;
    margin-top: -1px;
    transition: transform .6s cubic-bezier(.165, .84, .44, 1), opacity .3s cubic-bezier(.165, .84, .44, 1), background-color .6s cubic-bezier(.165, .84, .44, 1);
}
.burger-bar--1 {
    -webkit-transform: translateY(-10px);
    transform: translateY(-10px);
}
.burger-bar--2 {
    transform-origin: 100% 50%;
}
.burger-button:hover .burger-bar--2 {
    transform: scaleX(1);
}
.no-touchevents .burger-bar--2:hover {
    transform: scaleX(1);
}
.burger-bar--3 {
    transform: translateY(10px);
}
#burger.active .burger-button {
    transform: rotate(-180deg);
}
#burger.active .burger-bar {
    background-color: #fff;
}
#burger.active .burger-bar--1 {
    transform: rotate(45deg)
}
#burger.active .burger-bar--2 {
    opacity: 0;
}
#burger.active .burger-bar--3 {
    transform: rotate(-45deg)
}
</style>