<template>
    <div class="coverWrapper">
        <img :src="url" class="cover">
        <div v-if="overlay" class="cover-overlay"><p><slot /></p></div>
    </div>
</template>

<script>
export default {
    name: 'Cover',
    props: {
        url: {
            type: String,
            required: true,
        },
        overlay: {
            type: Boolean,
            default: false,
        }
    },
};
</script>

<style lang="scss" scoped>
.coverWrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    position: relative;
}

.cover {
    max-height: 100%;
    max-width: 100%;
    width: auto;
    height: auto;
    display: block;
}

.cover-overlay {
    position: absolute;
    bottom: 0;
    background-image: linear-gradient(rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.85));
    color: #f1f1f1;
    width: 100%;
    color: white;
    font-size: 35px;
    height: 25%;
    text-align: center;
    font-family: 'Anurati-Outline';
    display: flex;
    align-items: center;

    p {
        padding-top: 16px;
        margin: 0 auto;
    }
}
</style>