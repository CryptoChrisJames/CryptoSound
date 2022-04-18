<template>
    <div class="loginWrapper">
        <buffer />
        <h1 class="desc">
            Sign Up For CryptoSound
        </h1>
        <div class="loginForm">
            <label for="email" class="loginLabel"> Email </label>
            <input v-model="email" type="text" class="loginField" />
            <label for="email" class="loginLabel"> Password </label>
            <input v-model="password" type="password" class="loginField" />
            <label for="email" class="loginLabel"> Confirm Password </label>
            <input v-model="confirmPassword" type="password" class="loginField"/>
            <v-alert v-if="confirmPassword.length > 0 && !passwordIsConfirmed" dense type="error">Passwords must match!</v-alert>
            <v-btn
                v-if="loading == false"
                block
                @click.prevent="signIn()"
                :disabled="!passwordIsConfirmed"
            > 
                Sign Up 
            </v-btn>
            <v-btn 
                v-else
                block
                loading
            >
            </v-btn>
        </div>
        <div class="loginCalloutBody">
            <p>Already have an account?</p>
            <a href="/auth/login"><v-btn small >Click here to login.</v-btn></a>
        </div>
    </div>
</template>

<script>
import Vue from 'vue';
import Buffer from '../../components/atoms/Buffer/Buffer.vue';

export default Vue.extend({
    components: {
        Buffer,
    },
    data() {
        const email = "";
        const password = "";
        const confirmPassword = "";
        const error = "";
        const loading = false;

        return {
            email,
            password,
            confirmPassword,
            error,
            loading,
        };
    },
    computed: {
        passwordIsConfirmed() { return this.password === this.confirmPassword; },
    },
    methods: {
        async signIn() {
            this.loading = true;
            try {
                const signinResponse = await this.$firebase.signUp(this.email, this.password);
                console.log(signinResponse);
                var user = { 
                    email: signinResponse.user.email, 
                    value: signinResponse.user.accessToken,
                    uid: signinResponse.user.uid
                }
                this.$store.commit('user/setCurrentUser', user);
                this.$router.push("/");
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