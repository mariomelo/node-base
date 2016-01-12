gulp = require 'gulp'
istanbul = require('gulp-coffee-istanbul')

# We'll use mocha here, but any test framework will work
mocha = require('gulp-mocha')

jsFiles = []
specFiles = ['test/**.coffee', 'test/**.js']
coffeeFiles = ['api/**.coffee']

gulp.task 'test', ->
  gulp.src jsFiles.concat(coffeeFiles)
    .pipe istanbul({includeUntested: true}) # Covering files
    .pipe istanbul.hookRequire()
    .on 'finish', ->
      gulp.src specFiles
        .pipe mocha reporter: 'spec'
        .pipe istanbul.writeReports() # Creating the reports after tests run