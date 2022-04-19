<template>
    <div class="pageWrapper">
        <Hero :videoLink="videoLink">
            <div class="logoWrapper">
                <img src="~/static/images/CSLogo.png" alt="CryptoSound Logo 2" class="CSLogo2">
            </div>
        </Hero>
        <p class="copy">Check out the latest releases!</p>
        <CollectionCarousel></CollectionCarousel>
        <Promotion
            :promotion="generalPromotion"
            :isGeneral="true"
        />
    </div>
</template>

<script>
import Vue from 'vue';
import Hero from '../components/organisms/Hero/Hero.vue';
import Promotion from '../components/organisms/Promotion/Promotion.vue';
import CollectionCarousel from '../components/organisms/CollectionCarousel/CollectionCarousel.vue';

export default Vue.extend({
    async asyncData({store}) {
        const promotions = store.state.content.promotions;
        const videoLink = store.state.content.videoHeaderLink;
        return {
            promotions,
            videoLink,
        };
    },
    components: {
        Hero,
        Promotion,
        CollectionCarousel
    },
    computed: {
        generalPromotion() {
            return this.promotions.find(p => p.promotionName == "general");
        },
    },
});
</script>

<style lang="scss" scoped>
.logoWrapper{
    height: 100%; 
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.CSLogo2 {
    width: 75%;
    height: auto;
    margin: 0 auto;
}
</style>