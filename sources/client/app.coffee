_ = require 'lodash'
request = require 'request'
cheerio = require 'cheerio'
shell = require('electron').shell
YoutubeMp3Downloader = require 'youtube-mp3-downloader'

YD = new YoutubeMp3Downloader
	"ffmpegPath": "/usr/bin/ffmpeg"
	"outputPath": "/home/leone/Desktop/"
	"youtubeVideoQuality": "highest"
	"queueParallelism": 2
	"progressTimeout": 2000

youtubeSearch = (query, callback) ->
	return callback false unless query
	qUrl = encodeURI "https://www.youtube.com/results?search_query=#{query}"
	data = []
	console.log qUrl
	request qUrl, (error, response, body) ->
		console.log error, response, body
		return callback error if error
		return callback response.statusCode if response.statusCode isnt 200
		$ = cheerio.load(body)
		list = $('.yt-uix-tile-link')
		list.each (i) ->
			url = $(this).attr('href')
			return if url.split('/')[1] == 'channel'
			return unless id = url.split('=')[1]
			obj =
				id: id
				title: $(this).text()
				url: "https://www.youtube.com#{url}"
				img: "https://i.ytimg.com/vi/#{id}/hqdefault.jpg"
			data.push obj
			return callback null, data if i is list.length - 1

## Start angular module
angular.module 'app', [
	'ionic'
	'app.modules'
]

.config ($urlRouterProvider) ->
	$urlRouterProvider.otherwise '/'

.run ($rootScope, $state) ->
	YD.on "finished", (data) ->
		console.log "FINISHED !!!"
		console.log data
		console.log '----------'

	YD.on "error", (error) ->
		console.log 'ERROR!!!'
		console.log error
		console.log '--------'

	YD.on "progress", (progress) ->
		console.log 'PROGRREESS !!'
		console.log progress
		console.log '--------'
		$rootScope.$broadcast "download:#{progress.videoId}", progress.progress

	return;
