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
    line-height: 1.75;
    font-weight: 500;
    margin: 0;
    font-family: 'Anurati-Outline';

    @include phone {
  }
}
</style>