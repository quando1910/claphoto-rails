var gulp = require('gulp'), // Main Gulp module
    concat = require('gulp-concat'); // Gulp File concatenation plugin
    webserver = require('gulp-webserver');
    del = require('del');

// Configuration
var configuration = {
    paths: {
        src: {
            html: 'index.html',
            css: [
                './src/css/bootstrap.min.css',
                './src/css/main.css',
                './css/bootstrap.min.css',
                './css/open-iconic-bootstrap.min.css',
                './css/animate.css',
                './css/owl.carousel.min.css',
                './css/owl.theme.default.min.css',
                './css/icomoon.css',
                './css/style.css'
            ],
            js: [
                './js/jquery.min.js',
                './js/popper.min.js',
                './js/bootstrap.min.js',
                './js/jquery.easing.1.3.js',
                './js/jquery.waypoints.min.js',
                './js/owl.carousel.min.js',
                './js/jquery.animateNumber.min.js',
                './js/google-map.js',
                './js/main.js'
            ],
            fonts: './fonts/*/*.*',
            images: './images/*.*'
        },
        dist: './dist'
    }
};

gulp.task('clean', () => del.sync(['dist/**', '!dist']));

gulp.task('fonts', function () {
    gulp.src(configuration.paths.src.fonts)
        .pipe(gulp.dest(configuration.paths.dist + '/fonts'))
});

gulp.task('images', function () {
    gulp.src(configuration.paths.src.images)
        .pipe(gulp.dest(configuration.paths.dist + '/images'))
});

// Gulp task to copy HTML files to output directory
gulp.task('html', function() {
    gulp.src(configuration.paths.src.html)
        .pipe(gulp.dest(configuration.paths.dist));
});

// Gulp task to concatenate our css files
gulp.task('css', function () {
   gulp.src(configuration.paths.src.css)
       .pipe(gulp.dest(configuration.paths.dist + '/css'))
});

gulp.task('js', function () {
    gulp.src(configuration.paths.src.js)
        .pipe(gulp.dest(configuration.paths.dist + '/js'))
});

gulp.task('watch', () => {
    gulp.watch(configuration.paths.src.css, ['css']);
    gulp.watch(configuration.paths.src.html, ['html']);
});

// Gulp default task
gulp.task('render', ['html', 'css', 'js', 'fonts', 'images']);

gulp.task('default', ['clean', 'render', 'watch'], function() {
    gulp.src('./dist')
      .pipe(webserver({
        host: '0.0.0.0',
        fallback: 'index.html',
        https: false,
        open: true,
        livereload: true
    }));
});