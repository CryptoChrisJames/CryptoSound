<template>
    <div class="loginWrapper">
        <buffer />
        <h1 class="desc">
            Sign In To CryptoSound
        </h1>
        <div class="loginForm">
            <label for="email" class="loginLabel"> Email </label>
            <input v-model="email" type="text" class="loginField" />
            <label for="email" class="loginLabel"> Password </label>
            <input v-model="password" type="password" class="loginField" />
            <v-btn
                v-if="loading == false"
                block
                @click.prevent="signIn()"
            > 
                Login 
            </v-btn>
            <v-btn 
                v-else
                block
                loading
            >
            </v-btn>
        </div>
        <div class="loginCalloutBody">
            <p>Don't have an account?</p>
            <a href="/auth/signup"><v-btn small >Click here to sign up.</v-btn></a>
        </div>
    </div>
</template>

<script lang="ts">
import Vue from 'vue';
import Buffer from '../../components/atoms/Buffer/Buffer.vue';
import { User } from '../../types/user/user';

export default Vue.extend({
    components: {
        Buffer,
    },
    data() {
        const email: string = "";
        const password: string = "";
        const error: string = "";
        const loading: boolean = false;

        return {
            email,
            password,
            error,
            loading,
        };
    },
    methods: {
        async signIn() {
            this.loading = true;
            try {
                const signinResponse = await this.$signIn(this.email, this.password);
                console.log(signinResponse);
                var user = new User(signinResponse.user.email, signinResponse.user.accessToken);
                this.$store.commit('user/setCurrentUser', user);
            } catch(err) {
                console.log(err);
            }
        },
    },
});
</script>

<style lang="scss" scoped>
.desc {
    padding: 7px;
    text-align: center;
    font-weight: 400;
    margin-bottom: 7px;
}
.loginForm {
    display: block;
    width: 340px;
    margin: 16px auto;
    padding: 16px;
    border: 1px solid rgb(114, 113, 113);
    border-radius: 6px;
}
.loginLabel {
    display: block;
    margin-bottom: 8px;
    font-weight: 400;
    font-size: 25px;
    text-align: left;
}
.loginField{
    margin-top: 4px;
    margin-bottom: 16px;
    display: block;
    width: 100%;
    border: 1px solid rgb(114, 113, 113);
    padding: 5px 12px;
    font-size: 14px;
    font-weight: 500;
    line-height: 20px;
    background-repeat: no-repeat;
    background-position: right 8px center;
    border-radius: 6px;
    outline: none;
    color: azure;
}
.loginCalloutBody {
    margin: 25px 0;
    text-align: center;
    p {
        margin: 5px;
    }
}
</style>