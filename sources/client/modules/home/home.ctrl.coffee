angular.module "app.home"

.controller "homeCtrl", ($rootScope, $scope, $location) ->
	$scope.$watch ->
		return $location.search().query
	, _.debounce (query) ->
		$scope.videos = []
		unless query
			$scope.isSearching = false
			$scope.$apply() unless $scope.$$phase
			return
		$scope.isSearching = true
		$scope.$apply() unless $scope.$$phase
		youtubeSearch query, (err, videos) ->
			if err
				$scope.err = "Nous n'avons rien trouver"
			else $scope.videos = videos
			$scope.isSearching = false
			$scope.$apply() unless $scope.$$phase
	, 842
