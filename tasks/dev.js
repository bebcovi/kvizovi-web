/* global -history */

var gulp = require('gulp');

var browserSync = require('browser-sync');
var history = require('connect-history-api-fallback');

gulp.task('connect', ['scripts', 'styles'], function (done) {
  browserSync({
    notify: false,
    port: 9000,
    open: false,
    server: {
      baseDir: ['.tmp', 'app'],
      middleware: [history()]
    }
  }, done);
});

gulp.task('watch', ['connect'], function () {
  gulp.watch([
    'app/**/*.html',
    'app/images/**/*'
  ]).on('change', browserSync.reload);

  gulp.watch('app/styles/**/*.scss', ['styles']);
});

gulp.task('serve', ['connect', 'watch']);
