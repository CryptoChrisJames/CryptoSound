<template>
    <div class="coverWrapper">
        <img :src="url" class="cover">
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
    },
};
</script>

<style lang="scss" scoped>
.coverWrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.cover {
    max-height: 100%;
    max-width: 100%;
    width: auto;
    height: auto;
}
</style>