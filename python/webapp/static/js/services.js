'use strict';

/* Services */

var Services = angular.module('raspberry.services', ['ngResource', 'ngCookies']);

Services.factory('VoiceService', ['$http', '$log', '$location', '$cookieStore', function(http, logger, location, $cookieStore) {

       
        function VoiceService(http, logger) {
          

            // Fonction de speak
            this.speak = function(phrase) {

                logger.info("Appel speak (/voice)");

                http({
                    method: 'POST',
                    url: '/voice/'+phrase
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
	
Services.factory('BluetoothService',['$http','$resource', function(http, $resource) {

       
        function BluetoothService(http,$resource) {
         
            // Fonction de scan
            this.scan = function() {
               //logger.info("Appel speak (/scan)");
               return $resource('/scan').get();
            };
			
			this.scanServices = function(mac) {

               // logger.info("Appel speak (/scanServices)");

                http({
                    method: 'GET',
                    url: '/scanServices/04:18:0F:0D:25:F6'
                }).success(function(data, status, headers, config) {
					return data;
                }).error(function(data, status, headers, config) {});
			
			};
			};

        // instanciation du service
        return new BluetoothService(http,$resource);
    }]);