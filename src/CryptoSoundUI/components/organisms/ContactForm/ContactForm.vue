<template>
    <div class="content">
        <h3 class="spacing">Thank's for showing interest in our work. We can't wait to work with you!</h3>
        <h5>If you have a project that needs our services, please fill out the form below and we will get in contact with you ASAP.</h5>
        <br />
        <div class="inputField">
            <h3 class="inputTitle">Name</h3>
            <input v-model="name" type="text"/>

            <h3 class="inputTitle">Company</h3>
            <input v-model="company" type="text"/>

            <h3 class="inputTitle">Email</h3>
            <div v-show="!isEmail" class="incompleteSubmission">
                Please add a valid email. 
            </div>
            <input @blur="validateEmail" v-model="email" type="text"/>
            
            <h3 class="inputTitle">What's your approximate budget for this project?</h3>
            <select class="spacing dropDown" v-model="budget" type="text">
                <option value="<5000">Less than $5,000</option>
                <option value="5000-10000">$5,000-$10,000</option>
                <option value="10000-25000">$10,000-$25,000</option>
                <option value=">25000">Greater than $25,000</option>
            </select>

            <h3 class="inputTitle">What service are you interested in?</h3>
            <select class="spacing dropDown" v-model="service" type="text">
                <option value="Video/Film Production">Video/Film Production</option>
                <option value="Audio/Music Production">Audio/Music Production</option>
                <option value="Editing">Editing</option>
                <option value="Film Consultation">Film Consultation</option>
                <option value="Marketing Consultation">Marketing Consultation</option>
                <option value="Other">Other</option>
            </select>

            <h3 class="inputTitle">What are some of the details of your project?</h3>
            <textarea v-model="comments"/>
            <div v-show="incompleteSubmission" class="incompleteSubmission">
                Please fill out all of the fields before submitting your form! 
            </div>
            <h3 v-show="submitted" class="inputTitle">Thanks for contacting us! We will review your submission and respond to you soon.</h3>
            <button @click="submit" class="submit">Submit</button>
        </div>
    </div>
</template>

<script>
import isEmail from 'isemail';
import sectionHead from '../../atoms/Header/SectionHead.vue';

export default {
    'name': 'Contact',
    components: {
        sectionHead,
    },
    data() {
        return {
            name: '',
            company: '',
            email: '',
            comments: '',
            budget: '',
            service: '',
            submitted: false,
            incompleteSubmission: false,
            isEmail: true,
        };
    },
    methods: {
        async submit() {
            if (this.isEmail) {
                if(this.email
                    && this.comments
                    && this.name
                    && this.company
                    && this.budget
                    && this.service) {
                    this.incompleteSubmission = false;
                    const contact = {
                        name: this.name,
                        email: this.email,
                        company: this.company,
                        budget: this.budget,
                        service: this.service,
                        details: this.comments
                    };
                    await this.$store.dispatch("contact/sendContactInfo", contact);
                    this.$emit('contactSent');
                }
                else {
                    this.incompleteSubmission = true;
                }
            }
        },
        validateEmail() {
            this.isEmail = isEmail.validate(this.email, {errorLevel: false});
        },
    },
};
</script>

<style lang="scss" scoped>
.content {
    margin: 0 33%;

    @include tablet {
        margin: 0 25%;
    }

    @include phone {
        margin: 0 10%;
    }

    button {
        background-color: black;
        color: $AOTLYellow;
        width:100%;
        box-shadow: none;
        border: 1px solid $AOTLYellow;
        border-radius: 25px;
        outline: none;
        margin-bottom: 3em;
        transition: 0.5s ease;
    }

    button:hover{
        background-color: $AOTLYellow;
        color: black;
    }

    input {
        color: black;
        margin: 5px;
        width: 85%;
        box-shadow: none;
        background-color: white;
        border: 1px solid lightgray;
        border-top: 0;
        border-left: 0;
        border-right: 0;
        border-radius: 0px;
        margin-bottom: 3em;
        outline: none;
    }

    textarea {
        color: black;
        width:100%;
        height: 155px;
        box-shadow: none;
        background-color: white;
        border: 1px solid lightgray;
        border-radius: 7px;
        outline: none;
        margin-bottom: 1.5em;
        font-size: 25px;
    }

    @media only screen and (min-width: 700px) {
        form{
            width: 75%;
            margin: 0 auto;
        }
    }

    @media only screen and (min-width: 1020px) {
        form{
            width: 50%;
            margin: 0 auto;
        }
    }
}

.spacing {
    margin: 15px 0;
}

.dropDown {
    width: 100%;
    height: 30px;
    outline: none;
    background-color: black;
    color: white;
    border: 2px solid white;
    border-radius: 5px;
}

.incompleteSubmission {
    text-align: center;
    color: red;
    margin-bottom: 20px;
    font-size: 25px;
}

.submit {
    font-size: 25px;
}
</style>