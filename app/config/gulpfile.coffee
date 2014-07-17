###
|--------------------------------------------------------------------------
| Gulpfile
|--------------------------------------------------------------------------
|
| Configuration file for Gulp.
|
###

# Load the plugins automatically
gulp        = require "gulp"
run         = require("gulp-load-plugins")()
browserSync = require "browser-sync"
reload      = browserSync.reload

# Input & Output Destinations
inputDest  = "./app/assets"
outputDest = "./public"

paths =
  sass            : ["#{inputDest}/sass/**/*.scss"]
  coffee          : ["#{inputDest}/coffeescript/application.coffee"]
  coffee_includes : ["#{inputDest}/coffeescript/**/*.coffee"]
  slim            : ["./app/views/**/*.slim", "!./app/views/index.slim"]
  bower           : ["./bower_components/**/*.js",
                     "!./bower_components/platform/*",
                     "!./bower_components/polymer/*"]

# Tasks
gulp.task 'browser-sync', ->
  browserSync.init null,
    notify : false
    server :
      baseDir : "./"


gulp.task "sass", ->
  gulp.src paths.sass
  .pipe run.plumber()
  .pipe run.rubySass { style : 'compressed' }
  .pipe run.autoprefixer 'last 2 version', 'safari 5', 'ie 9', 'ios 6', 'android 4'
  .pipe run.rename { suffix : '.min' }
  .pipe run.minifyCss()
  .pipe run.filesize()
  .pipe gulp.dest "#{outputDest}/css/"
  .pipe run.notify { message : 'SASS compiled and minified!' }
  .pipe reload { stream : true }


gulp.task "coffee", ->
  gulp.src paths.coffee
  .pipe run.plumber()
  .pipe run.include { extensions : "coffee" }
  .pipe run.coffee { bare : true }
  .pipe run.rename { suffix : '.min' }
  .pipe run.uglify()
  .pipe run.filesize()
  .pipe gulp.dest "#{outputDest}/js/"
  .pipe run.notify { message : 'Coffeescript compiled and minified!' }
  .pipe reload { stream : true, once : true }


gulp.task "slim", ->
  gulp.src paths.slim
  .pipe run.plumber()
  .pipe run.slim { pretty : true }
  .pipe gulp.dest "#{outputDest}/html/"
  .pipe run.notify { message : 'Index file compiled and minified!' }
  .pipe reload { stream : true }


gulp.task "generate-index", ->
  gulp.src "./app/views/*.slim"
  .pipe run.plumber()
  .pipe run.slim { pretty : true }
  .pipe gulp.dest "./"
  .pipe run.notify { message : 'Index file compiled and minified!' }
  .pipe reload { stream : true }


gulp.task "merge-bower", ->
  gulp.src paths.bower
  .pipe run.plumber()
  .pipe run.concat( "plugins.min.js" )
  .pipe run.uglify()
  .pipe run.filesize()
  .pipe gulp.dest "#{outputDest}/js/"


# Default
gulp.task "default", [ "slim", "sass", "coffee", "generate-index", "browser-sync", "watch"]

# Watch
gulp.task "watch", ['browser-sync'], () ->
  gulp.watch paths.slim,                ["slim"]
  gulp.watch paths.sass,                ["sass"]
  gulp.watch paths.coffee,              ["coffee"]
  gulp.watch paths.coffee_includes,     ["coffee"]
  gulp.watch "./app/views/*.slim",      ["generate-index"]