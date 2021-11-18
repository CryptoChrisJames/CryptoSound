<template>
    <div class="pickerWrapper">
        <ul class="crewPicker">
            <li v-for="(item, index) in Objs" :key="index" :class="['crewPosition', index == currentIndex ? 'selected' : '']">
                <a @click="setIndex(index)">
                    {{ item.position }}
                </a>
            </li>
        </ul>
        <div v-for="(item, index) in Objs" :key="item.name" class="crewPanel" :hidden="index != currentIndex">
            <h2 class="crewName">{{ item.name }}</h2>
            <img :src="item.headshot" alt="" class="crewPhoto">
            <p class="crewBio">{{ item.bio }}</p>
        </div>
    </div>
</template>

<script>
export default {
    name: "CrewPicker",
    data() {
        const Objs = [];
        const currentIndex = 0;
        return {
            Objs,
            currentIndex,
        };
    },
    props: {
        prismicObjs: {
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
        this.Objs = this.parsePrismicObjs(this.prismicObjs);
    },
    methods: {
        setIndex(index) {
            this.currentIndex = index;
        },
        parsePrismicObjs(objs) {
            return objs.map((obj) => {
                return {
                    'position': obj.position[0].text,
                    'name': obj.name[0].text,
                    'bio': obj.bio[0].text,
                    'headshot': obj.headshot.url,
                };
            });
        },
    },
};
</script>

<style lang="scss" scoped>
.pickerWrapper {
    padding: 10px 30px;
}

.crewPicker {
    list-style-type: none;
    margin: 7px 0;
    padding: 20px 25px;
    overflow-x: scroll;
    white-space: nowrap;
    display: block;

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

.crewPicker::-webkit-scrollbar-track
{
    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.9);
    border-radius: 10px;
    background-color: rgba(131, 9, 9, 0.747);
}

.crewPicker::-webkit-scrollbar
{
    height: 7px;
    width: 12px;
}

.crewPicker::-webkit-scrollbar-thumb
{
    border-radius: 10px;
    background-color: $ADRed;
}

.crewPosition {
    font-size: 25px;
    font-weight: bold;
    display: inline-block;
    padding: 10px;
    margin-bottom: 15px;
    border-bottom: 1px solid transparent;
    border-top: 1px solid transparent;
    cursor: pointer;
}

.crewName {
    color: $ADRed;
    font-size: 40px;
    text-align: center;
    padding: 10px;
}

.crewPhoto {
    width: 85%;
    height: auto;
    display: block;
    margin: 0 auto;
    filter: gray; /* IE6-9 */
    -webkit-filter: grayscale(1); /* Google Chrome, Safari 6+ & Opera 15+ */
    filter: grayscale(1);

    @include tablet {
        width: 50%;
    }

    @include desktop {
        width: 35%;
    }

    @include widescreen {
        width: 25%;
    }
}

.crewBio {
    font-size: 20px;
    display: block;
    margin: 0 auto;
    padding: 35px 0;

    @include tablet {
        font-size: 30px;
        padding: 30px 100px;
    }

    @include desktop {
        font-size: 35px;
        padding: 20px 150px;
    }

    @include widescreen {
        font-size: 35px;
        padding: 20px 300px;
    }
}

.selected {
  border-bottom: 1px solid $ADRed;
  border-top: 1px solid $ADRed;
  color: $ADYellow;
}
</style>