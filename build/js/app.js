var YD, YoutubeMp3Downloader, _, cheerio, request, shell, youtubeSearch;

_ = require('lodash');

request = require('request');

cheerio = require('cheerio');

shell = require('electron').shell;

YoutubeMp3Downloader = require('youtube-mp3-downloader');

YD = new YoutubeMp3Downloader({
  "ffmpegPath": "/usr/bin/ffmpeg",
  "outputPath": "/home/leone/Desktop/",
  "youtubeVideoQuality": "highest",
  "queueParallelism": 2,
  "progressTimeout": 2000
});

youtubeSearch = function(query, callback) {
  var data, qUrl;
  if (!query) {
    return callback(false);
  }
  qUrl = encodeURI("https://www.youtube.com/results?search_query=" + query);
  data = [];
  console.log(qUrl);
  return request(qUrl, function(error, response, body) {
    var $, list;
    console.log(error, response, body);
    if (error) {
      return callback(error);
    }
    if (response.statusCode !== 200) {
      return callback(response.statusCode);
    }
    $ = cheerio.load(body);
    list = $('.yt-uix-tile-link');
    return list.each(function(i) {
      var id, obj, url;
      url = $(this).attr('href');
      if (url.split('/')[1] === 'channel') {
        return;
      }
      if (!(id = url.split('=')[1])) {
        return;
      }
      obj = {
        id: id,
        title: $(this).text(),
        url: "https://www.youtube.com" + url,
        img: "https://i.ytimg.com/vi/" + id + "/hqdefault.jpg"
      };
      data.push(obj);
      if (i === list.length - 1) {
        return callback(null, data);
      }
    });
  });
};

angular.module('app', ['ionic', 'app.modules']).config(function($urlRouterProvider) {
  return $urlRouterProvider.otherwise('/');
}).run(function($rootScope, $state) {
  YD.on("finished", function(data) {
    console.log("FINISHED !!!");
    console.log(data);
    return console.log('----------');
  });
  YD.on("error", function(error) {
    console.log('ERROR!!!');
    console.log(error);
    return console.log('--------');
  });
  YD.on("progress", function(progress) {
    console.log('PROGRREESS !!');
    console.log(progress);
    console.log('--------');
    return $rootScope.$broadcast("download:" + progress.videoId, progress.progress);
  });
});

angular.module('app').directive('downloadBar', function() {
  return {
    restrict: 'E',
    templateUrl: 'download-bar.view.html',
    scope: {
      video: '='
    },
    controller: function($scope, $state, $stateParams) {
      console.log("Download bar inited");
      $scope.download = function() {
        $scope.isDownloading = true;
        return YD.download($scope.video.id);
      };
      $scope.play = function() {
        return shell.openExternal($scope.video.url);
      };
      return $scope.$on("download:" + $scope.video.id, function(e, data) {
        console.log("CHILD RECEVING PROGRESS");
        console.log(data);
        console.log('----------------------');
        if (data.percentage === 100) {
          console.log('download end');
          $scope.isDownloading = false;
          $scope.isEnded = true;
        }
        $scope.downloadProgress = data.percentage;
        if (!$scope.$$phase) {
          return $scope.$apply();
        }
      });
    }
  };
});

angular.module('app.modules', ['app.home']).config(function($stateProvider) {
  return $stateProvider.state('app', {
    abstract: true,
    templateUrl: "modules.view.html",
    controller: 'modulesCtrl'
  });
}).controller("modulesCtrl", function($location, $scope) {
  $scope.query = $location.search().query;
  return $scope.search = function(query) {
    $location.search('query', query);
  };
});

angular.module("app.home", []).config(function($stateProvider) {
  return $stateProvider.state('app.home', {
    url: '/',
    views: {
      menuContent: {
        templateUrl: 'home.view.html',
        controller: 'homeCtrl'
      }
    },
    resolve: {}
  });
});

angular.module("app.home").controller("homeCtrl", function($rootScope, $scope, $location) {
  return $scope.$watch(function() {
    return $location.search().query;
  }, _.debounce(function(query) {
    $scope.videos = [];
    if (!query) {
      $scope.isSearching = false;
      if (!$scope.$$phase) {
        $scope.$apply();
      }
      return;
    }
    $scope.isSearching = true;
    if (!$scope.$$phase) {
      $scope.$apply();
    }
    return youtubeSearch(query, function(err, videos) {
      if (err) {
        $scope.err = "Nous n'avons rien trouver";
      } else {
        $scope.videos = videos;
      }
      $scope.isSearching = false;
      if (!$scope.$$phase) {
        return $scope.$apply();
      }
    });
  }, 842));
});
