var fs = require('fs');
var gulp  = require('gulp');
var shell = require('gulp-shell');
var changed = require('gulp-changed');
var clean = require('gulp-clean');
var luacheck = require("gulp-luacheck");

var SRC = 'src/**/*.lua';
var DEST = 'dist';

// we'll use some settings from nodemcu-tool when uploading with nodemcu-uploader
var nodemcutoolOptions = JSON.parse(fs.readFileSync('.nodemcutool'));
var baudrate = nodemcutoolOptions.baudrate;
var port = nodemcutoolOptions.port;

function upload() {
  //shell("nodemcu-tool  upload --remotename <%= file.relative %> src/<%= file.relative %>")
  return shell("echo uploading <%= file.relative %> ; nodemcu-uploader --port " + port + " --start_baud " + baudrate + " upload src/<%= file.relative %>:<%= file.relative %> > /dev/null 2>&1")
}

gulp.task('default', function() {

  var result = gulp.src(SRC, { base: 'src' })
    .pipe(changed(DEST))
    .pipe(upload())
    .pipe(gulp.dest(DEST));

  return result;
});

gulp.task('all', function() {

  return gulp.src(SRC, { base: 'src' })
    .pipe(upload())
    .pipe(gulp.dest(DEST));
});

gulp.task('clean', function () {
  return gulp.src(DEST, {read: false})
    .pipe(clean());
});

gulp.task("lint", function() {
  return gulp
    .src(SRC)
    .pipe(shell("echo linting: <%= file.path %>"))
    .pipe(luacheck({
      globals: ['file', 'net', 'node', 'mqtt', 'tmr', 'uart', 'wifi', 'ws2812']
    }))
    .pipe(luacheck.reporter())
});
