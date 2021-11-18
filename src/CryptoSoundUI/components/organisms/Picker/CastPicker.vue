<template>
    <div class="pickerWrapper">
        <ul class="castPicker">
            <li v-for="(item, index) in Objs" :key="index" 
                :class="['castPosition', index == currentIndex ? 'selected' : '']"
            >
                <a @click="setIndex(index)">
                    {{ item.role }}
                </a>
            </li>
        </ul>
        <div v-for="(item, index) in Objs" :key="index" :hidden="index != currentIndex"
            class="castPanel"
        >
            <h2 class="castName">{{ item.name }}</h2>
            <img :src="item.headshot" alt="" class="castPhoto">
            <p class="castBio">{{ item.bio }}</p>
        </div>
    </div>
</template>

<script>
export default {
    name: "castPicker",
    data() {
        const Objs = [];
        const currentIndex = 0;
        return {
            Objs,
            currentIndex,
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
};
</script>

<style lang="scss" scoped>
.pickerWrapper {
    padding: 10px 30px;
}

.castPicker {
    list-style-type: none;
    margin: 7px 0;
    padding: 10px 0;
    overflow-x: scroll;
    white-space: nowrap;
    display: block;
    text-align: center;

    @include tablet {
        width: 75%;
        margin: 0 auto;
    }

    @include desktop {
        width: 50%;
        margin: 0 auto;
    }

    @include widescreen {
        width: 30%;
        margin: 0 auto;
    }
}

.castPicker::-webkit-scrollbar-track
{
    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.9);
    border-radius: 10px;
    background-color: rgba(184, 184, 184, 0.747);
}

.castPicker::-webkit-scrollbar
{
    height: 7px;
    width: 12px;
}

.castPicker::-webkit-scrollbar-thumb
{
    border-radius: 10px;
    background-color: azure;
}

.castPosition {
    font-size: 25px;
    font-weight: bold;
    display: inline-block;
    padding: 10px;
    margin-bottom: 15px;
    border-bottom: 1px solid transparent;
    border-top: 1px solid transparent;
    cursor: pointer;
}

.castName {
    color: white;
    font-size: 40px;
    text-align: center;
    padding: 10px;
}

.castPhoto {
    width: 85%;
    height: auto;
    display: block;
    margin: 0 auto;

    @include tablet {
        width: 60%;
    }

    @include desktop {
        width: 50%;
    }

    @include widescreen {
        width: 25%;
    }
}

.grayscale {
    filter: gray; /* IE6-9 */
    -webkit-filter: grayscale(1); /* Google Chrome, Safari 6+ & Opera 15+ */
    filter: grayscale(1);
}

.castBio {
    font-size: 20px;
    display: block;
    margin: 0 auto;
    padding: 35px;

    @include tablet {
        font-size: 30px;
    }

    @include desktop {
        font-size: 35px;
    }

    @include widescreen {
        font-size: 35px;
        padding: 20px 300px;
    }
}

.selected {
    border-bottom: 1px solid azure;
    border-top: 1px solid azure;
    color: $ADYellow;
}
</style>