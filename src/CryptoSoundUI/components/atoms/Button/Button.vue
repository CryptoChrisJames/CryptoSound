<template>
    <div class="buttonWrapper">
        <button 
            class="scpButton"
            @click="action()"
        >
            <slot/>
        </button>
    </div>
</template>

<script>
export default {
    name: 'Button',
    methods: {
        action() {
            this.$emit('action');
        },
    },
};
</script>

<style lang="scss" scoped>
.buttonWrapper {
    position: relative;
    display: block;
    margin: 0 auto;
    width: 80%;
}

.scpButton {
    display: block;
    margin: 0 auto;
    width: 50%;
    height: 77px;
    font-size: 30px;
    color: white;
    background-color: transparent;
    box-shadow: none;
    border: 2px solid white;
    border-radius: 15px;
    transition: 200ms ease;
    outline: none;
}

.scpButton:hover {
    color: black;
    background-color: white;
}
</style>