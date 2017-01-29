module.exports = (gulp, plugins, config) ->
  ->
    gulp.src "./#{config.client.path.src}/client/**/*.coffee"
    .pipe plugins.plumber(errorHandler: plugins.notify.onError('Error: <%= error %>'))
    .pipe plugins.coffee { bare: true }
    .pipe plugins.concat 'app.js'
    .pipe gulp.dest "./#{config.client.path.build}/js"
