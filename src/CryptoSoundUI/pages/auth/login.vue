<template>
    <div class="loginWrapper">
        <buffer />
        <input v-model="email" type="text" placeholder="email" class="authField">
        <input v-model="password" type="text" placeholder="password" class="authField">
        <button @click.prevent="signIn()"></button>
    </div>
</template>

<script>
import Buffer from '../../components/atoms/Buffer/Buffer.vue';

export default {
    components: {
        Buffer,
    },
    data() {
        const email = "";
        const password = "";
        const error = "";

        return {
            email,
            password,
            error,
        };
    },
    methods: {
        async signIn() {
            const test = await this.$firebase.signIn(this.email, this.password);
            console.log(test);
        },
    },
};
</script>

<style scoped>

</style>