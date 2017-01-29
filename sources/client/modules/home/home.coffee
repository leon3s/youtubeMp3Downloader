angular.module "app.home", []

.config ($stateProvider) ->
	$stateProvider
	.state 'app.home',
		url: '/'
		views:
			menuContent:
				templateUrl: 'home.view.html'
				controller: 'homeCtrl'
		resolve: {}
