'use strict';

/* Controllers */

// Pour que l'injection de dépendances fonctionne en cas de 'minifying'
RootController.$inject = ['$scope','$log', '$location','RootService'];
function RootController($scope, $log, $location,RootService) {
    $scope.redirections = RootService.redirections();
}


BluetoothController.$inject = ['$rootScope', '$scope', '$log','BluetoothService'];
function BluetoothController($rootScope, $scope,  $log, BluetoothService) {

   $scope.scan = function() {
        $log.info("Scan bluetooth devices");
        $scope.devices = BluetoothService.scan();
    };
	
	$scope.scanServices = function() {
        $log.info("Scan bluetooth device services");
		$log.info("adresse :"+$scope.mac);
        $scope.services = BluetoothService.scanServices($scope.mac);
    }

}

VoiceController.$inject = ['$rootScope', '$scope', '$log','VoiceService'];
function VoiceController($rootScope, $scope,  $log,VoiceService) {

   $scope.speak = function() {
        $log.info("speak :"+$scope.phrase);
        VoiceService.speak($scope.phrase);
    }

}
