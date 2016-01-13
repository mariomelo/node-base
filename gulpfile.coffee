gulp = require 'gulp'
istanbul = require 'gulp-coffee-istanbul'
nodemon = require 'gulp-nodemon'
mocha = require 'gulp-mocha'

jsFiles = []
specFiles = ['test/**.coffee', 'test/**.js']
coffeeFiles = ['app/**/**.coffee', 'app.coffee', 'config.coffee']

gulp.task 'default', ->
  nodemon(
    script: 'app.coffee'
    ext: 'coffee'
    ignore: [ 'public/**', 'coverage/**' ]
  ).on 'restart', ->
    gulp.start 'test'

gulp.task 'test', ->
  gulp.src jsFiles.concat(coffeeFiles)
    .pipe istanbul({includeUntested: true}) 
    .pipe istanbul.hookRequire()
    .on 'finish', ->
      gulp.src specFiles
        .pipe mocha reporter: 'spec'
        .pipe istanbul.writeReports() 