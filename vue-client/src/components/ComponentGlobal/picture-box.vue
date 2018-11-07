<template>
  <div class="pp_overlay1" @click="closeBox">
    <div id="picturebox" class="picture-box">
      <div class="btn-control btn-prev" @click="prevImg"><i class="fa fa-angle-left" aria-hidden="true"></i></div>
      <img class="pic-view" :src="dataPic | mediumGoogleImage">
      <a @click="downloaded"><i class="fa fa-download" aria-hidden="true"></i></a>
      <div class="btn-control btn-next" @click="nextImg"><i class="fa fa-angle-right" aria-hidden="true"></i></div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['dataPic'],
  mounted() {
    $('#picturebox').click(function(event){
      event.stopPropagation()
    });
  },
  methods: {
    toDataURL(url, callback) {
      var xhr = new XMLHttpRequest();
      xhr.onload = function() {
        var reader = new FileReader();
        reader.onloadend = function() {
          callback(reader.result);
        }
        reader.readAsDataURL(xhr.response);
      };
      xhr.open('GET', url);
      xhr.responseType = 'blob';
      xhr.send();
    },
    downloaded () {
      let urlImg = this.$options.filters.mediumGoogleImage(this.dataPic)
      console.log(urlImg)
      this.toDataURL('https://doc-0s-6o-docs.googleusercontent.com/docs/securesc/32ucp6blnn56pdct1gp3dg7avqh3d5lk/s7fm39ql239a927ud5b7jkqj3mff9t4t/1541556000000/09686435642626771864/13247814753082231894/1_h6liVKjfkGgXQ1kXLy_AmwZSGdJlMri?e=view', function(dataUrl) {
        console.log('RESULT:', dataUrl)
      })
    },
    closeBox () {
      this.$emit('closeBox', 1)
    },
    nextImg () {
      this.dataPic = null
      $('#loadingpos').show()
      this.$emit('nextImg', 1)
    },
    prevImg () {
      this.dataPic = null
      $('#loadingpos').show()
      this.$emit('prevImg', 1)
    }
  }
}
</script>
<style>
.pp_overlay1 {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 100vh;
  background-color: rgba(0,0,0,0.8);
  z-index: 1000;
}
.picture-box {
  width: 70%;
  max-height: 600px;
  position: absolute;
  top: 50%;
  z-index: 2000;
  left: 50%;
  transform: translate(-50%, -50%);
  padding: 0 40px;
  background-color: rgba(255,255,255,0.8);
}
.pic-view {
  width: 100%;
  height: 600px;
  object-fit: contain;
}
.fa-angle-left, .fa-angle-right {
  font-size: 100px;
  color: white;
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
}
.fa-download {
  font-size: 60px;
  color: white;
}
.btn-control {
  height: 100%;
}
.btn-next {
  float: right;
  padding-right: 40px;
}
.btn-prev {
  float: left;
}
</style>
