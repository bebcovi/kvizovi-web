var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

var browserSync = require('browser-sync');

var processors = [
  require('autoprefixer-core')
];

var browserify = require('browserify');
var watchify = require('watchify');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');
var assign = require('lodash.assign');

var customOpts = {
  entries: ['./app/scripts/app.jsx'],
  extensions: ['.jsx'],
  debug: true
};
var opts = assign({}, watchify.args, customOpts);
var b = watchify(browserify(opts));
var bundle = function () {
  return b.bundle()
    .on('error', $.util.log.bind($.util, 'Browserify Error'))
    .pipe(source('bundle.js'))
    .pipe(buffer())
    .pipe($.sourcemaps.init({loadMaps: true}))
    .pipe($.sourcemaps.write('./'))
    .pipe(gulp.dest('.tmp/scripts'))
    .pipe(browserSync.reload({stream: true, once: true}));
};

gulp.task('scripts', bundle);
b.on('update', bundle);
b.on('log', $.util.log);

module.exports = b;

gulp.task('jshint', function () {
  return gulp.src('app/scripts/**/*.js')
    .pipe($.jshint())
    .pipe($.jshint.reporter('jshint-stylish'))
    .pipe($.jshint.reporter('fail'));
});

gulp.task('styles', function () {
  return gulp.src('app/styles/*.scss')
    .pipe($.sass())
    .pipe($.postcss(processors))
    .pipe(gulp.dest('.tmp/styles'))
    .pipe(browserSync.reload({stream: true}));
});

gulp.task('images', function () {
  return gulp.src('app/images/**/*')
    .pipe($.cache($.imagemin({
      progressive: true,
      interlaced: true,
      svgoPlugins: [{cleanupIDs: false}]
    })))
    .pipe(gulp.dest('dist/images'));
});
