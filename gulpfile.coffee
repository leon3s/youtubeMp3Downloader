gulp            = require 'gulp'
plugins         = require('gulp-load-plugins')()
config					= require('./gulpfile.config.json')

getTask = (name) -> require("./task/#{name}")(gulp, plugins, config)

gulp.task 'jade', getTask 'jade'
gulp.task 'less', getTask 'less'
gulp.task 'index', getTask 'index'
gulp.task 'images', getTask 'images'
gulp.task 'vendors', getTask 'vendors'
gulp.task 'electron', getTask 'electron'
gulp.task 'coffeescript', getTask 'coffeescript'

gulp.task 'build', [
	'jade'
	'less'
	'index'
	'images'
	'vendors'
	'electron'
	'coffeescript'
]

gulp.task 'watch', ['build'], ->
  gulp.watch "./#{config.client.path.src}/client/app.jade", ['index']
  gulp.watch "./#{config.client.path.src}/client/**/*.coffee", ['coffeescript']
  gulp.watch "./#{config.client.path.src}/client/**/*.less", ['less']
  gulp.watch "./#{config.client.path.src}/client/**/*.jade", ['jade']
