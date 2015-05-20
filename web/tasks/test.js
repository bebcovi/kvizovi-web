/* global -history */

var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

var browserSync = require('browser-sync');
var history = require('connect-history-api-fallback');
var selenium = require('selenium-standalone');

gulp.task('connect:test', ['scripts', 'styles'], function (done) {
  browserSync({
    logLevel: 'silent',
    notify: false,
    open: false,
    port: 9000,
    server: {
      baseDir: ['test/fixtures', '.tmp', 'app'],
      middleware: [history()]
    },
    ui: false
  }, done);
});

gulp.task('selenium', function (done) {
  selenium.install({
    logger: function () { }
  }, function (err) {
    if (err) return done(err);

    selenium.start(function (err, child) {
      if (err) return done(err);
      selenium.child = child;
      done();
    });
  });
});

gulp.task('integration', ['connect:test', 'selenium'], function () {
  return gulp.src('test/*.js', {read: false})
    .pipe($.mocha({timeout: 5000}));
});

gulp.task('test', ['integration'], function () {
  selenium.child.kill();
  browserSync.exit();
});
