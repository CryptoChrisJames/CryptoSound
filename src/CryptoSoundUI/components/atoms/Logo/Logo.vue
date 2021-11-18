<template>
    <div class="logo-wrapper">
        <router-link to="/">
            <img :src="logoUrl" alt="" class="logo">
        </router-link>
    </div>
</template>

<script>

export default {
    name: 'Logo',
    computed: {
        logoUrl() {
            return this.$store.state.content.logo;
        },
    },
};
</script>

<style lang="scss" scoped>
@import '../../../styles/_colors.scss';
@import '../../../styles/_variables.scss';

.logo {
    height: 50px;

    @include tablet {
        height: 44px;
    }

    @include phone {
        height: 35px;
    }
}

</style>