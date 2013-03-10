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
    }

}

VoiceController.$inject = ['$rootScope', '$scope', '$log'];
function VoiceController($rootScope, $scope,  $log) {

   

}
