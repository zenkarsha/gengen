/*===================================================*/
/* Config
/*===================================================*/
var enable_livereload = true;
var enable_uglify = true;
var enable_native2ascii = true;


/*===================================================*/
/* Include packages
/*===================================================*/
var gulp            = require('gulp');
var gulpif          = require('gulp-if');
var log             = require('fancy-log');
var coffee          = require('gulp-coffee');
var browsersync     = require('browser-sync');
var stylus          = require('gulp-stylus');
var sourcemaps      = require('gulp-sourcemaps');
var nib             = require('nib');
var jeet            = require('jeet');
var prefix          = require('gulp-autoprefixer');
var cp              = require('child_process');
var uglify          = require('gulp-uglify-es').default;
var rupture         = require('rupture');
var browserify      = require('browserify');
var tap             = require('gulp-tap');
var buffer          = require('gulp-buffer');
var coffeeify       = require('coffeeify');
var rename          = require("gulp-rename");
var include         = require("gulp-include");
var n2a             = require('gulp-native2ascii');
var plumber         = require('gulp-plumber');
var clean_css       = require('gulp-clean-css');
var fs              = require('fs');
var del             = require('del');


/*===================================================*/
/* Jekyll tasks
/*===================================================*/
gulp.task('jekyll', function (done) {
  browsersync.notify('Running: $ jekyll build');
  return cp.spawn('jekyll', ['build'], {stdio: 'inherit'}).on('close', done);
});

gulp.task('jekyll-rebuild', ['jekyll', 'stylus', 'coffee', 'js-combine', 'css-combine'], function () {
  if (enable_livereload) {
    browsersync.notify('Running: $ jekyll rebuild');
    browsersync.reload();
  }
});

gulp.task('refresh-page', ['jekyll'], function () {
  if (enable_livereload) {
    browsersync.notify('Running: $ jekyll refresh');
    browsersync.reload('*.html');
  }
});

gulp.task('browser-sync', ['jekyll'], function() {
  browsersync({
    server: {
      baseDir: 'public'
    },
    callbacks: {
      ready: function(error, bs) {
        bs.addMiddleware("*", function (request, response) {
          var content_404 = fs.readFileSync(__dirname + '/public/404.html');
          response.write(content_404);
          response.end();
        });
      }
    }
  });
});


/*===================================================*/
/* Gulp tasks
/*===================================================*/
gulp.task('stylus', function (cb) {
  del(['public/css/app.css'], cb);
  return gulp.src('assets/stylus/all.styl')
    .pipe(plumber())
    .pipe(sourcemaps.init())
    .pipe(stylus({
      use: [nib(), jeet(), rupture()],
      compress: true
    }))
    .pipe(prefix(['last 15 versions', '> 1%', 'ie 8', 'ie 7'], { cascade: true }))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('public/css'))
    .pipe(gulpif(enable_livereload, browsersync.reload({stream:true}))).on('error', log.error);
});

gulp.task('coffee', function(cb) {
  del(['public/js/app.js'], cb);
  return gulp.src([
      'assets/coffee/app.coffee'
    ])
    .pipe(plumber())
    .pipe(include({extensions: 'coffee'})).on('error', log.error)
    .pipe(coffee({bare: true}).on('error', log.error))
    .pipe(gulpif(enable_uglify, uglify()))
    .pipe(gulpif(enable_native2ascii, n2a({reverse: false})))
    .pipe(gulp.dest('public/js'))
    .pipe(gulpif(enable_livereload, browsersync.reload({stream:true}))).on('error', log.error);
});

gulp.task('js-combine', function() {
  return gulp.src([
      'assets/coffee/vendor.coffee'
    ])
    .pipe(plumber())
    .pipe(include({extensions: 'js'})).on('error', log.error)
    .pipe(rename(function (path) {
        path.extname = '.js';
    }))
    .pipe(gulp.dest('public/js'))
    .pipe(gulpif(enable_livereload, browsersync.reload({stream:true}))).on('error', log.error);
});

gulp.task('css-combine', function() {
  return gulp.src([
      'assets/stylus/vendor.styl'
    ])
    .pipe(plumber())
    .pipe(include({extensions: 'css'})).on('error', log.error)
    .pipe(clean_css())
    .pipe(rename(function (path) {
        path.extname = '.css';
    }))
    .pipe(gulp.dest('public/css'))
    .pipe(gulpif(enable_livereload, browsersync.reload({stream:true}))).on('error', log.error);
});


/*===================================================*/
/* Watch out!
/*===================================================*/
gulp.task('watch', function () {
  gulp.watch('assets/stylus/**/*', ['stylus']);
  gulp.watch(['assets/stylus/vendor.styl', 'vendor/*.css'], ['css-combine']);
  gulp.watch('assets/coffee/**/*', ['coffee']);
  gulp.watch(['assets/coffee/vendor.coffee'], ['js-combine']);
  gulp.watch(['images/**/*'], ['jekyll-rebuild']);
  gulp.watch(['index.html', '_config.yml', '_includes/**/*', '_layouts/*', 'template/**/*', 'pages/**/*', 'document/**/*', 'vendor/**/*', 'fonts/**/*'], ['jekyll-rebuild']);
});

gulp.task('default', [
  'stylus',
  'coffee',
  'js-combine',
  'css-combine',
  'browser-sync',
  'watch'
]);
