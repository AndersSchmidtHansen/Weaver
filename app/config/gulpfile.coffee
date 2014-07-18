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
  slim            : [
                      "app/views/**/*.slim",
                      "app/views/partials/*.slim",
                      "!app/views/index.slim",
                      "!app/views/polymer/*.slim"
                    ]
  sass            : [
                      "#{inputDest}/sass/**/*.scss",
                      "!#{inputDest}/sass/polymer/*.scss"
                    ]
  coffee          : [
                      "#{inputDest}/coffeescript/application.coffee"
                      "#{inputDest}/coffeescript/angular/app.coffee"
                    ]
  coffee_includes : [
                      "#{inputDest}/coffeescript/**/*.coffee",
                      "!#{inputDest}/coffeescript/polymer/*.coffee"
                    ]

  angular_scripts : ["#{inputDest}/coffeescript/angular/**/*.coffee"]


  polymer_html    : ["app/views/polymer/*.slim"]
  polymer_styles  : ["#{inputDest}/sass/polymer/*.scss"]
  polymer_scripts : ["#{inputDest}/coffeescript/polymer/*.coffee"]

  bower           : [
                     "bower_components/deb.js/build/deb.min.js",
                     "bower_components/userapp/userapp.client.js",
                     "bower_components/userapp-angular/angularjs.userapp.js",
                     "!bower_components/platform/*",
                     "!bower_components/polymer/*"
                    ]

# Tasks
gulp.task 'browser-sync', ->
  browserSync.init null,
    notify : false
    server :
      baseDir : "./"

gulp.task "angular-scripts", ->
  gulp.src paths.angular_scripts
  .pipe run.plumber()
  .pipe run.include { extensions : "coffee" }
  .pipe run.notify { message : 'Angular scripts running!' }
  .pipe reload { stream : true, once : true }

gulp.task "slim", ->
  gulp.src paths.slim
  .pipe run.watch()
  .pipe run.plumber()
  .pipe run.slim { pretty : true }
  .pipe gulp.dest "#{outputDest}/html/"
  .pipe run.notify { message : 'HTML files compiled and minified!' }
  .pipe reload { stream : true }

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
  .pipe run.concat( "application.min.js" )
  .pipe run.uglify()
  .pipe run.filesize()
  .pipe gulp.dest "#{outputDest}/js/"
  .pipe run.notify { message : 'Coffeescript compiled and minified!' }
  .pipe reload { stream : true, once : true }

gulp.task "generate-index", ->
  gulp.src "./app/views/index.slim"
  .pipe run.plumber()
  .pipe run.slim { pretty : true }
  .pipe gulp.dest "./"
  .pipe run.notify { message : 'Index file compiled and minified!' }
  .pipe reload { stream : true }

# Polymer Tasks
gulp.task "polymer-html", ->
  gulp.src paths.polymer_html
  .pipe run.plumber()
  .pipe run.slim { pretty : true }
  .pipe gulp.dest "#{outputDest}/html/polymer/"
  .pipe run.notify { message : 'Polymer HTML compiled and minified!' }
  .pipe reload { stream : true }

gulp.task "polymer-styles", ->
  gulp.src paths.polymer_styles
  .pipe run.plumber()
  .pipe run.rubySass { style : 'compressed' }
  .pipe run.autoprefixer 'last 2 version', 'safari 5', 'ie 9', 'ios 6', 'android 4'
  .pipe run.rename { suffix : '.min' }
  .pipe run.minifyCss()
  .pipe run.filesize()
  .pipe gulp.dest "#{outputDest}/css/polymer/"
  .pipe run.notify { message : 'Polymer styles compiled and minified!' }
  .pipe reload { stream : true }

gulp.task "polymer-scripts", ->
  gulp.src paths.polymer_scripts
  .pipe run.plumber()
  .pipe run.include { extensions : "coffee" }
  .pipe run.coffee { bare : true }
  .pipe run.rename { suffix : '.min' }
  .pipe run.uglify()
  .pipe run.filesize()
  .pipe gulp.dest "#{outputDest}/js/polymer/"
  .pipe run.notify { message : 'Polymer scripts compiled and minified!' }
  .pipe reload { stream : true, once : true }

gulp.task "merge-bower", ->
  gulp.src paths.bower
  .pipe run.plumber()
  .pipe run.concat( "plugins.min.js" )
  .pipe run.uglify()
  .pipe run.filesize()
  .pipe gulp.dest "#{outputDest}/js/"


# Default
gulp.task "default", [ "browser-sync", "merge-bower", "watch" ]

# Watch
gulp.task "watch", ['browser-sync'], () ->
  gulp.watch paths.slim,                ["slim"]
  gulp.watch paths.sass,                ["sass"]
  gulp.watch paths.coffee,              ["coffee", "angular-scripts"]
  gulp.watch paths.coffee_includes,     ["coffee"]
  gulp.watch paths.angular_scripts,     ["angular-scripts"]
  gulp.watch paths.polymer_html,        ["polymer-html", "slim"]
  gulp.watch paths.polymer_styles,      ["polymer-styles"]
  gulp.watch paths.polymer_scripts,     ["polymer-scripts"]
  gulp.watch "./app/views/index.slim",  ["generate-index"]