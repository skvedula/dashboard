/**
 * Master Controller
 */

angular.module('Dash')
    .controller('MasterCtrl', ['$http', '$scope', '$cookieStore', '$timeout', MasterCtrl]);

function MasterCtrl($http, $scope, $cookieStore, $timeout) {
    /**
     * Sidebar Toggle & Cookie Control
     */
    var mobileView = 992;

    $scope.getWidth = function() {
        return window.innerWidth;
    };

    $scope.$watch($scope.getWidth, function(newValue, oldValue) {
        if (newValue >= mobileView) {
            if (angular.isDefined($cookieStore.get('toggle'))) {
                $scope.toggle = ! $cookieStore.get('toggle') ? false : true;
            } else {
                $scope.toggle = true;
            }
        } else {
            $scope.toggle = false;
        }

    });

	/*$scope.exportData = function () {
        alasql('SELECT * INTO XLSX("test.xlsx",{headers:true}) FROM ?',[$scope.TransportTableData]);
    }; */
	
    $scope.toggleSidebar = function() {
        $scope.toggle = !$scope.toggle;
        $cookieStore.put('toggle', $scope.toggle);
    };

    window.onresize = function() {
        $scope.$apply();
    };
    $scope.getTableData = function(){
      $http.get("http://172.31.49.151:3000/dashboard/data")
	  //$http.get("http://webtools.fedex.com:3000/dashboard/data")
	  
      .then(function (response) {$scope.tableData = response.data;});
    }; 

    $scope.getHCheckData = function(){
      $http.get("http://172.31.49.151:3000/healthcheck_data")
    //$http.get("http://webtools.fedex.com:3000/dashboard/data")
    
      .then(function (response) {$scope.hcheckData = response.data;});
    }; 	

	$scope.getGuageTableData = function(){
     var update = function() { 
	  $http.get("http://172.31.49.151:3000/gauge_data")
	  .then(function (response) {$scope.guagetableData = response.data;});
	  $timeout(update, 1000);
    }
    $timeout(update, 1000);
    }; 
	
	 $scope.TransportTableData = function(){
      console.log("came here for transport queue");
	  var t_update = function() {
      $http.get("http://172.31.49.151:3000/transport_q")
	   
      .then(function (response) {$scope.transportData = response.data;});
	  $timeout(t_update, 2000);
	  }
	  $timeout(t_update, 2000);
    }; 
	
	$scope.DatabaseImbalanceData = function(){
      console.log("came here for DB Imbalance");
	  var imbalance_update = function() {
      $http.get("http://172.31.49.151:3000/DatabaseImbalanceData")
	   
      .then(function (response) {$scope.DatabaseImbalanceData = response.data;});
	  $timeout(imbalance_update, 2000);
	  }
	  $timeout(imbalance_update, 2000);
    }; 
	
	$scope.DatabaseReplication = function(){
      console.log("came here for DB replication issue");
	  var replication_update = function() {
      $http.get("http://172.31.49.151:3000/DatabaseReplication")
	   
      .then(function (response) {$scope.DatabaseReplication = response.data;});
	  $timeout(replication_update, 2000);
	  }
	  $timeout(replication_update, 2000);
    }; 
	
	$scope.cas_server = function(){
      console.log("came here for cas server issue");
	  var cas_server_update = function() {
      $http.get("http://172.31.49.151:3000/cas_server")
	   
      .then(function (response) {$scope.cas_server = response.data;});
	  $timeout(cas_server_update, 2000);
	  }
	  $timeout(cas_server_update, 2000);
    };

	}