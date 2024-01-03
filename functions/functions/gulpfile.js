var gulp            = require('gulp');
var log             = require('fancy-log');
var rename          = require("gulp-rename");
var include         = require("gulp-include");
var plumber         = require('gulp-plumber');


/*===================================================*/
/* Gulp tasks
/*===================================================*/
gulp.task('js-combine', function() {
  return gulp.src([
      'source.js'
    ])
    .pipe(plumber())
    .pipe(include({extensions: 'js'})).on('error', log.error)
    .pipe(rename(function (path) {
        path.basename = 'index';
        path.extname = '.js';
    }))
    .pipe(gulp.dest('./')).on('error', log.error);
});


/*===================================================*/
/* Watch out!
/*===================================================*/
gulp.task('watch', function () {
  gulp.watch(['source.js', 'partial/**/*', 'poem_gen/**/*'], ['js-combine']);
});

gulp.task('default', [
  'js-combine',
  'watch'
]);
