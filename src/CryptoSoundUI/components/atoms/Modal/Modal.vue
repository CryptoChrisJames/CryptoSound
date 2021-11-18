<template>
    <div class="modal-backdrop">
        <div class="modal">
            <div class="modalHeader">
                <slot name="header"></slot>
            </div>
            <div class="modalContent">
                <slot name="content"></slot>
            </div>
            <div class="modalFooter">
                <slot name="footer"></slot>
            </div>
            <button 
                class="closeButton"
                @click="close"
            >
                Close
            </button>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Modal',
    methods: {
        close() {
            this.$emit('close');
        },
    },
};
</script>

<style>
.modal-backdrop {
    position: fixed;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.9);
    display: flex;
    justify-content: center;
    align-items: center;
}

.modal {
    display: block;
    margin: 10% auto;
    padding: 15px 35px;
}

.closeButton {
    display: block;
    margin: 50px auto;
    width: 100%;
    height: 50px;
    color: white;
    background-color: transparent;
    border: none;
}
</style>