import gulp from 'gulp';
import $ from './helpers/plugins';
import {dev as server} from './helpers/server';
import autoprefixer from 'autoprefixer-core';

// https://github.com/gulpjs/gulp/blob/master/docs/recipes/fast-browserify-builds-with-watchify.md
import browserify from 'browserify';
import watchify from 'watchify';
import source from 'vinyl-source-stream';

let b = browserify({
  entries: ['./app/scripts/app.jsx'],
  extensions: ['.jsx'],
  debug: true
}, watchify.args);

// only watch for changes in development mode
if (process.env.ENV !== 'production') {
  b = watchify(b);
}

function bundle() {
  return b.bundle()
    .on('error', msg => {
      delete msg.stream;
      $.util.log(msg);
    })
    .pipe(source('bundle.js'))
    .pipe(gulp.dest('.tmp/scripts'))
    .pipe(server.stream({once: true}));
}

gulp.task('scripts', bundle);
b.on('update', bundle);

gulp.task('lint', () => {
  return gulp.src([
    'app/scripts/**/*.{js,jsx}',
    'test/**/*.{js,jsx}',
    'tasks/**/*.js'
  ])
    .pipe($.eslint())
    .pipe($.eslint.format())
    .pipe($.eslint.failAfterError());
});

gulp.task('styles', () => {
  return gulp.src('app/styles/**/*.scss')
    .pipe($.plumber())
    .pipe($.sourcemaps.init())
    .pipe($.sass.sync()).on('error', $.sass.logError)
    .pipe($.postcss([autoprefixer]))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest('.tmp/styles'))
    .pipe(server.stream());
});

gulp.task('images', () => {
  return gulp.src('app/images/**/*')
    .pipe($.cache($.imagemin({
      progressive: true,
      interlaced: true,
      // don't remove IDs from SVGs, they are often used
      // as hooks for embedding and styling
      svgoPlugins: [{cleanupIDs: false}]
    })))
    .pipe(gulp.dest('dist/images'));
});
