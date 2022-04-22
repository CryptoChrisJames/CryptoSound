<template>
    <div class="collectionPageWrapper">
        <Buffer />
        <Cover :url="currentCollection.cover" :overlay="true">{{ currentCollection.name }}</Cover>
        <Player :currentCollection="currentCollection" />
        <p class="collectionDesc">{{ currentCollection.description }}</p>
    </div>
</template>

<script>
import Cover from '../../components/atoms/Cover/Cover.vue';
import SectionHead from '../../components/atoms/Header/SectionHead.vue';
import Buffer from '../../components/atoms/Buffer/Buffer.vue';
import Player from '../../components/organisms/Player/Player.vue';

export default {
    name: 'Collection',
    components: {
        Cover,
        SectionHead,
        Buffer,
        Player,
    },
    async asyncData({params, store}) {
        const pageLink = params.collection;
        const collections = store.state.content.collections;
        return {
            pageLink,
            collections,
        };
    },
    computed: {
        currentCollection() {
            var currentCollection = this.collections.find(c => c.name == this.pageLink);
            return currentCollection;
        },
    },
};
</script>

<style lang="scss" scoped>
.collectionDesc {
    padding: 10px 50px;
}
</style>