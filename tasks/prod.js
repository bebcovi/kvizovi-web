import gulp from 'gulp';
import $ from './helpers/plugins';
import {prod as server} from './helpers/server';
import history from 'connect-history-api-fallback';

gulp.task('html', ['scripts', 'styles'], () => {
  gulp.src('app/index.html')
    .pipe(gulp.dest('dist'));

  return gulp.src([
    '.tmp/scripts/*.js',
    '.tmp/styles/*.css'
  ], {base: '.tmp'})
    .pipe($.if('*.js', $.uglify()))
    .pipe($.if('*.css', $.minifyCss()))
    .pipe(gulp.dest('dist'));
});

gulp.task('extras', () => {
  return gulp.src([
    'app/*.*',
    '!app/*.html'
  ], {dot: true})
    .pipe(gulp.dest('dist'));
});

gulp.task('connect:dist', done => {
  server.init({
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

gulp.task('build', ['lint', 'html', 'images', 'extras'], () => {
  return gulp.src('dist/**/*').pipe($.size({title: 'build', gzip: true}));
});

gulp.task('default', ['clean'], function () {
  gulp.start('build');
});
