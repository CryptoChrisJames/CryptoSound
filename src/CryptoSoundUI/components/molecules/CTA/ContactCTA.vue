<template>
    <div>
        <h2 class="cta">
        Like what you see? We can do the same for you. 
        </h2>
        <h2 class="cta">
        Contact us today for a free quote! 
        </h2>
        <Button
            @action="goToContact()"
        >
        Contact Us!
        </Button>
    </div>    
</template>

<script>
import Button from '../../atoms/Button/Button.vue';

export default {
    name: 'ContactCTA',
    components: {
        Button
    },
    methods: {
        goToContact() {
            this.$router.push('/contact');
        },
    },    
}
</script>

<style lang="scss" scoped>
.cta {
    text-align: center;
    padding: 25px 10px ;
}
</style>