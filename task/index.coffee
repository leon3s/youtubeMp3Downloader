module.exports = (gulp, plugins, config) ->
	->
		gulp.src "./#{config.client.path.src}/client/app.jade"
		.pipe plugins.plumber(errorHandler: plugins.notify.onError('Error: '))
		.pipe plugins.jade { pretty: true, doctype: 'html' }
		.pipe gulp.dest "./#{config.client.path.build}"
