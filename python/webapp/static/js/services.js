'use strict';

/* Services */

var Services = angular.module('raspberry.services', ['ngResource', 'ngCookies']);

Services.factory('VoiceService', ['$http', '$log', '$location', '$cookieStore', function(http, logger, location, $cookieStore) {

       
        function VoiceService(http, logger) {
          

            // Fonction de speak
            this.speak = function() {

                logger.info("Appel speak (/voice)");

                http({
                    method: 'POST',
                    url: '/voice'
                }).success(function(data, status, headers, config) {

                   
                }).error(function(data, status, headers, config) {
                    
                });
            };
		};

        // instanciation du service
        return new VoiceService(http, logger);
    }]);

Services.factory('RootService', function( $resource) {

       
        function RootService($resource) {
          

            // Fonction de redirections
            this.redirections = function() {
               //logger.info("Appel redirections (/redirections)");
               return $resource('/redirections').get();
            };
		};

        // instanciation du service
        return new RootService($resource);
    });
	
Services.factory('BluetoothService', function( $resource) {

       
        function BluetoothService($resource) {
         
            // Fonction de scan
            this.scan = function() {
               //logger.info("Appel speak (/scan)");
               return $resource('/scan').get();
            };
		};

        // instanciation du service
        return new BluetoothService($resource);
    });