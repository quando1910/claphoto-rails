<template>
  <div id="cp-content-wrap" class="cp-content-wrap">
    <loading-time id="loadingpos"/>
    <picture-box v-if="show" :dataPic="picView" @closeBox="getCloseBox" @nextImg="getNextImg" @prevImg="getPrevImg"/>
    <div class="container view-container">
      <div class="row"> 
        <div class="cp-pagination col-md-10 col-sm-10 view-pic">
          <div v-if="contract">
            <h2>{{contract.group}} - {{contract.school}}</h2>
            <p>{{contract.town}}</p>
            <p>Niên Khóa: {{contract.school_year}}</p>
            <hr>
          </div>
          <nav>
            <ul class="pagination">
              <li>
                <a href="#" aria-label="Previous">
                  <span aria-hidden="true">&laquo;</span>
                </a>
              </li>
              <li v-for="(item,index) in pages" :key="index">
                <router-link :to="{name: 'PicCode', params: {id: $route.params.id}, query: {page: (index +1)}}" :class="{active: $route.query.page == (index + 1) }" replace>{{index + 1}}</router-link>
              </li>
              <li>
                <a href="#" aria-label="Next">
                  <span aria-hidden="true">&raquo;</span>
                </a>
              </li>
            </ul>
          </nav>
        </div>
        <div class="col-md-2 col-sm-2"></div>
        <div class="col-md-10 col-sm-10 view-pic">
          <transition name="fade">
            <div class="cp-grid-isotope gallery" v-if="pictures && ($route.query.page ? $route.query.page : 1)  == (index + 1)" v-for="(itemPics, index) of pictures" :key="index">
              <div class="isotope items">
                <div class="item" v-for="(item, ind) of itemPics.pictureId.split(',')" :key="ind">
                  <figure class="cp-hover-eff"> 
                    <progressive-img class="product-photo" alt="img02" :src="item | smallGoogleImage"/>
                    <figcaption>
                      <h3>{{itemPics.name.split(',')[ind]}}</h3>
                      <a class="open-image" @click="openImage(item, ind)"><i class="fa fa-search"></i> View Large</a> 
                    </figcaption>
                  </figure>
                </div>
              </div>
            </div>
          </transition>
          <div class="cp-pagination">
            <nav>
              <ul class="pagination">
                <li>
                  <a href="#" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                  </a>
                </li>
                <li v-for="(item,index) in pages" :key="index">
                  <router-link :to="{name: 'PicCode', params: {id: $route.params.id}, query: {page: (index +1)}}" :class="{active: $route.query.page == (index + 1) }" replace>{{index + 1}}</router-link>
                </li>
                <li>
                  <a href="#" aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                  </a>
                </li>
              </ul>
            </nav>
          </div>
        </div>
        <div class="col-md-3 col-sm-3 side-bar-pic">
          <side-bar/>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import * as types from '../store/types'
export default {
  name: 'PicCode',
  data () {
    return {
      pos: null,
      currentPage: null,
      show: false,
      pictures: null,
      picArr: null,
      nameArr: null,
      contract: null,
      intervalId: null,
      pages: 0,
      picView: null
    }
  },
  created () {
    $('#loadingpos').show()
    window.addEventListener('load', () => { console.log("It's loaded!"); $(window).trigger("resize"); window.clearInterval(this.intervalId);  $('#loadingpos').hide();})
    this.$http.get(`${types.SHOW_VIEWER}/${this.$route.params.code}`).then(res => {
      this.contract = res.body.contract
      this.pictures = res.body.meta.pic
      this.pages = res.body.meta.count
    })
    this.intervalId = window.setInterval(() => {
        $(window).trigger("resize")
        console.log('resize')
    },4000);
  },
  updated() {
    if ($(".cp-grid-isotope .isotope").length) {
      var $container = $('.cp-grid-isotope .isotope');
      $container.isotope({
        itemSelector: '.item',
        transitionDuration: '0.6s',
        masonry: {
            columnWidth: $container.width() / 12
        },
        layoutMode: 'masonry'
      });
      $(window).resize(function() {
        $container.isotope({
          masonry: {
            columnWidth: $container.width() / 12
          }
        });
      });
    }
    if ($('.gallery').length) {
      $("area[data-rel^='prettyPhoto']").prettyPhoto()
      $(".gallery:first a[data-rel^='prettyPhoto']").prettyPhoto({
        animation_speed:'normal',
        theme:'light_square',
        slideshow:3000, 
        autoplay_slideshow: false
      });
    }
    setTimeout(() => {$(window).trigger("resize")},1500)
  },
  methods: {
    convertPicId (index) {
      index = index? index -1 : 0
      return this.pictures[index].pictureId.split(',')
    },
    openImage (value, index) {
      this.show = true
      this.pos = index
      this.currentPage = this.$route.query.page ? this.$route.query.page : 1
      this.picView = value
    },
    convertPicName (index) {
      index = index? index -1 : 0
      return this.pictures[index].name.split(',')
    },
    getCloseBox (value) {
      this.show = !(value === 1)
    },
    getNextImg (value) {
      this.pos = this.pos + 1
      this.picView = this.pictures[this.currentPage-1].pictureId.split(',')[this.pos]
      $('.pic-view').on('load', function(){
        $('#loadingpos').hide();
      });
    },
    getPrevImg (value) {
      this.pos = this.pos - 1
      this.picView = this.pictures[this.currentPage-1].pictureId.split(',')[this.pos]
      $('.pic-view').on('load', function(){
        $('#loadingpos').hide();
      });
    }
  }
}
</script>
<style>
.product-photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
#loadingpos {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 1200;
}
</style>
