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
                <img :src="obj.cover" :alt="cover" class="collection-image">
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
    margin: 7px 0;
    padding: 20px 25px;
    overflow-x: scroll;
    white-space: nowrap;
    display: block;
}

.collection-wrapper {
    font-size: 25px;
    font-weight: bold;
    display: inline-block;
    padding: 10px;
    margin-bottom: 15px;
    border-bottom: 1px solid transparent;
    border-top: 1px solid transparent;
    cursor: pointer;
}

.collection-image {
    width: 200px;
    height: auto;
}
</style>