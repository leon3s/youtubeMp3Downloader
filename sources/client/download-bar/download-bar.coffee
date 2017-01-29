angular.module 'app'

.directive 'downloadBar', ->
	restrict: 'E'
	templateUrl: 'download-bar.view.html'
	scope:
		video: '='

	controller: ($scope, $state, $stateParams) ->
		console.log "Download bar inited"
		$scope.download = ->
			$scope.isDownloading = true
			YD.download $scope.video.id

		$scope.play = ->
			shell.openExternal $scope.video.url

		$scope.$on "download:#{$scope.video.id}", (e, data) ->
			console.log "CHILD RECEVING PROGRESS"
			console.log data
			console.log '----------------------'
			if data.percentage is 100
				console.log 'download end'
				$scope.isDownloading = false
				$scope.isEnded = true

			$scope.downloadProgress = data.percentage
			$scope.$apply() unless $scope.$$phase
