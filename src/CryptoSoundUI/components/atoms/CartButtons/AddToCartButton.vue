<template>
    <div class="atc-button-wrapper">
        <div class="atc-button-container">
            <button class="atc-button">Add <i class="fa-solid fa-cart-shopping"></i></button>
        </div>
    </div>
</template>

<script>
export default {
    name: "AddToCartButton",
    props: {
        productId: {
            type: String,
            required: true,
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
</style>