<template>  
    <div class="footer">
        <!-- <p style="justify-content: center; text-align: center; font-size: 10px;">
        Icons made by <a href="https://www.flaticon.com/authors/photo3idea-studio" title="photo3idea_studio">photo3idea_studio</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
        </p> -->
        <div class="contentWrapper">
            <div class="copyrightWrapper">
                <div class="copyright">
                    <span>© Story Collector Productions LLC 2021, All Rights Reserved.</span>
                </div>
            </div>
            <div class="socialWrapper">
                <a href="https://www.facebook.com/AOTLShort"><i class="social fab fa-facebook-square"></i></a>
                <a href="https://www.instagram.com/nu_ren_productions/"><i class="social fab fa-instagram"></i></a>
                <a href="https://vimeo.com/chandonae"><i class="social fab fa-vimeo-v"></i></a>
                <a href="https://www.youtube.com/channel/UCbMEhrBBQ4jTiC7R3RwSMWA"><i class="social fab fa-youtube"></i></a>
            </div>
        </div>
    </div>
</template>

<script>
import Logo from '~/components/atoms/Logo/Logo.vue';

export default {
    name: "FooterComponent",
    components: {
      Logo,
    },
    computed: {
        logoUrl() {
            return this.$store.state.content.logo;
        },
    },
};
</script>

<style lang="scss" scoped>
.footer {
  padding-top: 44px;
}

.copyright {
  text-align: center;
  font-size: 20px;
}

.socialWrapper {
  display: flex;
  padding: 3rem 0px;
  justify-content: center !important;
}

.social {
  padding: 0px 25px;
  font-size: 25px;
}

.social:hover {
}

.contentWrapper {
    display: grid;
    grid-template-columns: 1fr 1fr;

    @include phone{
        grid-template-columns: 1fr;
    }

    @include tablet{
        grid-template-columns: 1fr;
    }
}

.contentWrapper {
  align-items: center;
}
</style>