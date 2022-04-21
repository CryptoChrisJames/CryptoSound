<template>
    <div class="cart">
        <transition name="slide">
            <div v-show="isCartOpen" class="cart-wrapper">
            </div>
        </transition>
    </div>
</template>

<script>
export default {
    name: "Cart",
    computed: {
        isCartOpen() {
            return this.$store.state.cart.isCartOpen;
        },
    },
}
</script>

<style>
.cart-wrapper {
    position: fixed;
    display: flex;
    left: 0;
    top: 0;
    height: 100vh;
    width: 100vh;
    z-index: 999;
    padding: 3rem 20px 2rem 20px;
    background-color: #000000;
    -webkit-box-pack: justify;
    justify-content: space-between;
    -webkit-box-align: center;
    align-items: center;
}

.slide-enter-active,
.slide-leave-active {
    transition: transform 0.4s ease-in-out;
}
.slide-enter,
.slide-leave-to {
    transform: translateY(-100%);
    transition: all 150ms ease-in 0s
}
</style>