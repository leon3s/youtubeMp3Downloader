angular.module 'app.modules', [
	'app.home'
]

.config ($stateProvider) ->
	$stateProvider
	.state 'app',
		abstract: true
		templateUrl: "modules.view.html"
		controller: 'modulesCtrl'


.controller "modulesCtrl", ($location, $scope) ->
	$scope.query = $location.search().query
	$scope.search = (query) ->
		$location.search('query', query)
		return
