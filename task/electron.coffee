module.exports = (gulp, plugins, config) ->
	->
		gulp.src "./#{config.client.path.src}/electron/main.coffee"
		.pipe plugins.plumber(errorHandler: plugins.notify.onError('Error: <%= error %>'))
		.pipe plugins.coffee { bare: true }
		.pipe plugins.concat 'main.js'
		.pipe gulp.dest "./#{config.client.path.build}/"
