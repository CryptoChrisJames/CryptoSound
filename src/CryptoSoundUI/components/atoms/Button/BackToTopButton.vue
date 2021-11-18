<template>
    <div class="buttonWrapper">
        <button 
            class="scpButton"
            v-scroll-to="'#topOfPage'"
        >
            Back To Top
        </button>
    </div>
</template>

<script>
export default {
    name: 'Button',
};
</script>

<style lang="scss" scoped>
.buttonWrapper {
    position: relative;
    display: block;
    margin: 25px auto 0 auto;
    width: 80%;
}

.scpButton {
    display: block;
    margin: 0 auto;
    width: 150px;
    height: 50px;
    font-size: 20px;
    color: white;
    background-color: transparent;
    box-shadow: none;
    border: 2px solid white;
    border-radius: 15px;
    transition: 200ms ease;
    outline: none;
}
</style>