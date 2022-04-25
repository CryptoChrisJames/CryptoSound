<template>
    <div class="promotionWrapper">
        <section-head>Current Promotion</section-head>
        <p class="promoDesc">{{ promotion.promotionDesc }}</p>
        <a href="#" @click.prevent="goToPage()">
            <Cover :url="promotion.cover" :overlay="true">{{ promotion.name }}</Cover>
        </a>
    </div>

</template>

<script>
import SectionHead from '../../atoms/Header/SectionHead.vue';
import Cover from '../../atoms/Cover/Cover.vue';

export default {
    name: 'Promotion',
    components: {
        SectionHead,
        Cover,
    },
    props: {
        promotion: {
            type: Object,
            required: true,
        },
        isGeneral: {
            type: Boolean,
            required: false,
            default: false,
        },
    },
    methods: {
        goToPage() {
            this.$router.push(`collection/${this.promotion.name}`);
        },
    },
};
</script>

<style lang="scss" scoped>
.promotionWrapper {
    padding-bottom: 25px;;
}

.promoDesc {
    padding: 25px;
}
</style>