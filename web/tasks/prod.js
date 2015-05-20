/* global -history */

var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

var browserSync = require('browser-sync');
var history = require('connect-history-api-fallback');

var b = require('./assets');

gulp.task('html', ['scripts', 'styles'], function () {
  b.close(); // close watchify

  gulp.src('app/index.html')
    .pipe(gulp.dest('dist'));

  return gulp.src([
    '.tmp/scripts/*.js',
    '.tmp/styles/*.css'
  ], {base: '.tmp'})
    .pipe($.if('*.js', $.uglify()))
    .pipe($.if('*.css', $.csso()))
    .pipe(gulp.dest('dist'));
});

gulp.task('extras', function () {
  return gulp.src([
    'app/*.*',
    '!app/*.html'
  ], {dot: true})
    .pipe(gulp.dest('dist'));
});

gulp.task('connect:dist', function (done) {
  browserSync({
    notify: false,
    port: 9000,
    open: false,
    server: {
      baseDir: ['dist'],
      middleware: [history()]
    },
    ui: false
  }, done);
});

gulp.task('clean', require('del').bind(null, ['.tmp', 'dist']));

gulp.task('build', ['jshint', 'html', 'images', 'extras'], function () {
  return gulp.src('dist/**/*').pipe($.size({title: 'build', gzip: true}));
});

gulp.task('default', ['clean'], function () {
  gulp.start('build');
});
