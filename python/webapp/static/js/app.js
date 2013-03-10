'use strict';


// Declare app level module which depends on filters, and services
var App = angular.module('raspberry', ['raspberry.services']); // , ['raspberry.filters', 'raspberry.services', 'raspberry.directives']).


// Configuration des routes
App.config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/bluetooth', {templateUrl: '/static/pages/bluetooth.html', controller: BluetoothController});
	$routeProvider.when('/voice', {templateUrl: '/static/pages/voice.html', controller: VoiceController});
    $routeProvider.otherwise({redirectTo: '/'}); 
  }]);

// Intercepteur HTTP pour gérer le timeout de session
// Inspiré de http://www.espeo.pl/2012/02/26/authentication-in-angularjs-application
App.config(function($httpProvider) {
      
    var authentInterceptor = ['$rootScope', '$q', '$log', function (scope, $q, $log) {
        function success(response) {
            return response;
        }
        function error(response) {
            var status = response.status;
            if (status == 401) {
                $log.info('401 -> event:unauthorized');
                scope.$broadcast('event:unauthorized');
            }
            return $q.reject(response);
        }
        return function(promise) {
            return promise.then(success, error);
        };
    }];
    $httpProvider.responseInterceptors.push(authentInterceptor);
});

