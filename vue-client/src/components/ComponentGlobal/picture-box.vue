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
      // var xhr = new XMLHttpRequest();
      // xhr.onload = function() {
      //   var reader = new FileReader();
      //   reader.onloadend = function() {
      //     callback(reader.result);
      //   }
      //   reader.readAsDataURL(xhr.response);
      // };
      // xhr.open('GET', url);
      // xhr.responseType = 'blob';
      // xhr.send();
      var restRequest = gapi.client.request({
        'path': url
      });
      console.log(restRequest)
    },
    downloaded () {
      let urlImg = this.$options.filters.mediumGoogleImage(this.dataPic)
      this.$http.get(urlImg).then(res => {
        console.log(res.body)
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
