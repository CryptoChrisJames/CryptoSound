<template>
    <h1 class="sectionHead">
        <b><slot /></b>
    </h1>
</template>

<script>
export default {
    name: 'SectionHead',
};
</script>

<style lang="scss" scoped>
.sectionHead {
    width: 100%;
    text-align: center;
    padding: 22px;
    font-size: 48px;
    font-weight: 450;
    margin: 0;
    font-family: 'Roboto-Thin';

    @include phone {
    }
}
</style>