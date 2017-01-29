module.exports = (gulp, plugins, config) ->
  ->
    gulp.src "./#{config.client.path.src}/client/images/**"
    .pipe plugins.plumber(errorHandler: plugins.notify.onError('Error: '))
    .pipe gulp.dest "./#{config.client.path.build}/images"
