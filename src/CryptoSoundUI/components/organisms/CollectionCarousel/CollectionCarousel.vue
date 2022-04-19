<template>
    <div class="cc-wrapper">
        <ul class="horizontal-menu">
            <li class="collection-wrapper">test</li>
            <li class="collection-overlay">test</li>
        </ul>
    </div>
</template>

<script>
export default {
    name: "CollectionCarousel",
    data() {
        return {
        };
    },
    props: {
        castObjs: {
            type: Array,
            default: () => [],
        },
    },
    computed: {
        currentObj() {
            return this.Objs[this.currentIndex];
        }
    },
    mounted() {
        this.Objs = this.castObjs.map((obj) => {
            return {
                'name': obj.fields.name,
                'role': obj.fields.role,
                'headshot': obj.fields.castPhoto.fields.file.url,
            };
        });
    },
    methods: {
        setIndex(index) {
            this.currentIndex = index;
        },
    },
}
</script>

<style>

</style>