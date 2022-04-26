<template>
    <div class="atc-button-wrapper">
        <div class="atc-button-container">
            <button
                v-if="!currentlyInCart"
                class="atc-button"
                @click="addToCart(productId)"
            >
                Add <i class="fa-solid fa-cart-shopping"></i>
            </button>
            <button
                v-else
                class="atc-remove-button"
                @click="removeFromCart(productId)"
            >
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
    </div>
</template>

<script>
export default {
    name: "AddToCartButton",
    computed: {
        currentTracksInCart() {
            return this.$store.state.cart.tracks;
        },
        currentlyInCart() {
            var currentCart = this.currentTracksInCart.filter(x => x == this.productId);
            return currentCart.length == 1;
        },
    },
    props: {
        productId: {
            type: String,
            required: true,
        },
        productType: {
            type: String,
            required: true,
        },
    },
    methods: {
        addToCart(id) {
            switch(this.productType) {
                case "track":
                    this.$store.commit('cart/addTrack', id);
                    break;
                case "collection":
                    this.$store.commit('cart/addCollection', id);
                    break;
                case "kit":
                    this.$store.commit('cart/addKit', id);
                    break;
            };
        },
        removeFromCart(id) {
            switch(this.productType) {
                case "track":
                    this.$store.commit('cart/removeTrack', id);
                    break;
                case "collection":
                    this.$store.commit('cart/removeCollection', id);
                    break;
                case "kit":
                    this.$store.commit('cart/removeKit', id);
                    break;
            }
        },
    },
};
</script>

<style lang="scss" scoped>
.atc-button {
    font-family: 'Anurati';
    box-shadow: none;
    border: 1px solid azure;
    font-size: 12px;
    padding: 8px;
    border-radius: 16px;
    z-index: 999;
}

.atc-remove-button {
    font-family: 'Anurati';
    box-shadow: none;
    font-size: 24px;
    padding: 8px;
    z-index: 999;
}
</style>