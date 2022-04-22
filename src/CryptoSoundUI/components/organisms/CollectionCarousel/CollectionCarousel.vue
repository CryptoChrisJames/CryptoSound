<template>
    <div class="cc-wrapper">
        <ul class="horizontal-menu"
        >
        <a
            href="#" @click.prevent="goToPage(obj.name)"
            v-for="obj in collectionObjs"
            :key="obj.id"
        >
            <li
                class="collection-wrapper"
            >
                <img :src="obj.cover" :alt="`Cover for the project ${obj.name}`" class="collection-image">
                <div class="collection-info-wrapper">
                    <p class="collection-info">{{ obj.name }}</p>
                </div>
            </li>
        </a>
        </ul>
    </div>
</template>

<script>
export default {
    name: "CollectionCarousel",
    data() {
        const collectionObjs = [];
        return {
            collectionObjs,
        };
    },
    props: {
        collections: {
            type: Array,
            required: true,
        },
    },
    mounted() {
        this.collectionObjs = this.collections.map((obj) => {
            return {
                cover: obj.cover,
                id: obj.id,
                name: obj.name,
            };
        });
    },
    methods: {
        setIndex(index) {
            this.currentIndex = index;
        },
        goToPage(name) {
            this.$router.push(`collection/${name}`);
        },
    },
}
</script>

<style>
.horizontal-menu {
    list-style-type: none;
    padding: 8px 25px;
    overflow-x: scroll;
    white-space: nowrap;
    display: block;
    overflow: -moz-scrollbars-none;
    scrollbar-width: none;
    -ms-overflow-style: none;
}

.horizontal-menu::-webkit-scrollbar {
    width: 0 !important;
    display: none;
}

.collection-wrapper {
    font-size: 25px;
    font-weight: bold;
    display: inline-block;
    padding: 10px;
    border-bottom: 1px solid transparent;
    border-top: 1px solid transparent;
    cursor: pointer;
}

.collection-image {
    width: 200px;
    height: auto;
}

.collection-info {
    font-weight: 400;
}
</style>