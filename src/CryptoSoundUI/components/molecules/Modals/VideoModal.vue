<template>
    <modal
        @close="close"
    >
        <template class="modalHeader" v-slot:header>            
            <h1 class="videoname">
                {{ currentVideo.videoName }}
            </h1>
        </template>
        <template class="modalContent" v-slot:content>
            <span v-if="isOpen">
                <div v-html="currentVideo.vimeoLink">
                    {{ currentVideo.vimeoLink }}
                </div>
            </span>
            <p class="description">
                {{ currentVideo.description }}
            </p>
        </template>
        <template v-slot:footer>
            <p class="categories">
                Categories: <br/>
                    <span 
                        v-for="cat in currentVideo.categories" 
                        class="category"
                        :key="cat"
                    >
                        {{ cat }} 
                    </span>
            </p>
        </template>        
    </modal>
</template>

<script>
import Modal from '../../atoms/Modal/Modal.vue';

export default {
    name: 'VideoModal',
    components: {
        Modal,
    },
    props: {
        currentVideo: {
            type: Object,
            default: () => {},
        },
        isOpen: {
            type: Boolean,
            default: false, 
        },
    },
    methods: {
        close() {
            this.$emit('close');
        }
    }
};
</script>

<style>
.modalHeader {
    display: block;
    margin: 0 auto;
    padding: 50px 25px;
}

.videoname {
    text-align: center;
    font-size: 17px;
}

.description {
    padding: 20px 25px;
}

.categories {
    text-align: center;
}

.category {
    padding: 0 15px;
    word-wrap: normal;
}

.modalContent {
    padding: 10% 0;
}
</style>