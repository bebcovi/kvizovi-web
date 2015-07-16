import gulp from 'gulp';
import {dev as server} from './helpers/server';
import history from 'connect-history-api-fallback';

gulp.task('connect', ['scripts', 'styles'], done => {
  server.init({
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
  ]).on('change', server.reload);

  gulp.watch('app/styles/**/*.scss', ['styles']);
});

gulp.task('serve', ['connect', 'watch']);
