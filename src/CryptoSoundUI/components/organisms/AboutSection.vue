<template>
  <div class="content">
    <section-head>About Us</section-head>
    <div class="aboutContainer">
      <div class="description">
        <h3 class="desc">
          Story Collector aims to create brilliant stories, vibrant images, and explore 
          themes from the voices that often go unheard. We don't just see filmmaking as an art or a craft,
          but also as a vehicle to share different spectrums of the human experience, and strengthens 
          our communities and culture. We don't see this as some small feat; We believe that this 
          ability comes with great responsibility to provide fair and equal representation of ideas, and we also
          believe that there's no company that better prepared to carry that responsibility than Story Collector.
        </h3>
        <section-head>The Team</section-head>
        <div class="teamSection">
          <div class="teamMemeberWrapper">
            <div class="teamMember">
              <h5>Chandonae Baskin</h5>
              <div class="teamMemeberGif">
              </div>
              <div class="position"><h6>Lead Director | Writer | Producer</h6></div>
            </div>
          </div>
          <div class="teamMemeberWrapper">
            <h5>Christopher James Smith</h5>
            <div class="teamMember">
              <div class="teamMemeberGif">
              </div>
              <div class="position"><h6>Lead Producer | DIT</h6></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import sectionHead from '../atoms/Header/SectionHead.vue';
export default {
  name: 'AboutSection',
  components: { sectionHead },
};
</script>

<style lang="scss" scoped>
.content {
  margin-top: 35px;
  width: 100%;
  @media (min-width: 494px) and (max-width: 765px) {
    display: block;
    margin: 0 auto;
  }
}

.aboutContainer {
  width: 100%;
  position: relative;
}

.teamSection {
  display: grid;
  padding: 0 200px;
  grid-template-columns: 1fr 1fr;

  @include widescreen {
    padding: 0;
  }

  @include desktop {
    padding: 0;
  }

  @include tablet {
    padding: 0;
    grid-template-columns: 1fr;
  }

  @include phone {
    padding: 0;
    grid-template-columns: 1fr;
  }
}

.teamMemeberWrapper {
  margin: 20px;
  padding: 8px;
  text-align: center;
  font-family: 'Roboto', sans-serif;

  h5 {
    font-size: 30px;
    padding: 5px;
  }
}

.teamMemeberGif {
  display: inline-block;
}

.gif {
  width: 275px;
  margin: 15px auto;

  @include desktop {
    width: 300px;
  }

  @include widescreen {
    width: 300px;
  }
}

.description {
  text-align: justify;
}

.desc {
  font-size: 18px;
  padding: 25px;
  text-align: left;
  letter-spacing: .75px;
  font-family: 'Roboto', sans-serif;

  @include tablet {
    padding: 45px;
  }

  @include desktop {
    padding: 45px 25% 45px 25%;
  }

  @include widescreen {
    padding: 45px 25% 45px 25%;
  }
}

.position {
  @include desktop {
    padding: 0 100px;
  }

  @include widescreen {
    padding: 0 100px;
  }
}
</style>