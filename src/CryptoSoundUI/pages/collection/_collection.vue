<template>
    <div class="collectionPageWrapper">
        <Buffer />
        <Cover :url="currentCollection.cover" :overlay="true">{{ currentCollection.name }}</Cover>
        <Player :currentCollection="currentCollection" />
        <h3 class="copy">Buy the whole collection</h3>
        <div class="cart-option-wrapper">
            <p class="price"><i class="fa-solid fa-dollar-sign"></i>{{ currentCollection.price }}</p>
            <add-to-cart-button :productId="currentCollection.productId"/>
        </div>
        <p class="collectionDesc">{{ currentCollection.description }}</p>
    </div>
</template>

<script>
import Cover from '../../components/atoms/Cover/Cover.vue';
import SectionHead from '../../components/atoms/Header/SectionHead.vue';
import Buffer from '../../components/atoms/Buffer/Buffer.vue';
import Player from '../../components/organisms/Player/Player.vue';
import AddToCartButton from '../../components/atoms/CartButtons/AddToCartButton.vue';

export default {
    name: 'Collection',
    components: {
        Cover,
        SectionHead,
        Buffer,
        Player,
        AddToCartButton,
    },
    async asyncData({params, store}) {
        const pageLink = params.collection;
        const collections = store.state.content.collections;
        return {
            pageLink,
            collections,
        };
    },
    computed: {
        currentCollection() {
            var currentCollection = this.collections.find(c => c.name == this.pageLink);
            return currentCollection;
        },
    },
};
</script>

<style lang="scss" scoped>
.collectionDesc {
    padding: 10px 50px;
}

.cart-option-wrapper {
    width: 50%;
    display: flex;
    height: 54px;
    -webkit-box-pack: justify;
    justify-content: space-between;
    -webkit-box-align: center;
    align-items: center;
    margin: 0 auto;
    padding: 16px;
}

.copy {
    text-align: center;
    padding: 8px 16px;
    font-weight: 400;
    font-size: 24px;
    font-family: 'Roboto-Thin';
}

.price {
    font-family: 'Anurati-Outline';
    font-size: 32px;
}
</style>