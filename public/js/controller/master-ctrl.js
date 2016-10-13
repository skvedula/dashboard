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
    //$http.get("http://172.31.49.151:3000/dashboard/data")
$http.get("http://webtools.intranet.fedex.com:3000/dashboard/data")

    .then(function (response) {
response.data.forEach( function (item)
{
	if(item["last_fullbackup"] == null){
item["last_fullbackup"] = "NULL";}
});     
    $scope.tableData = response.data;});
  }; 
	
	 $scope.getDiskSpace = function(){
      //$http.get("http://172.31.49.151:3000/health_check")
	  $http.get("http://webtools.intranet.fedex.com:3000/iplanet/diskspace")
	  
      .then(function (response) {$scope.diskspace = response.data;});
    };
	$scope.getHCheckData = function(){
      //$http.get("http://172.31.49.151:3000/health_check")
	  $http.get("http://webtools.intranet.fedex.com:3000/health_check")
	  
      .then(function (response) {$scope.hcheckData = response.data;});
    };
	
	$scope.getStatusClass = function(status){
      if (status =="Pass" || status > 23 ){ 
	  return 'passStatus';
	  }
	  else if (status >0 && status <= 23 ){ 
	  return 'lessValue';
	  }
	  else if(status=="Fail"){
		  return 'failStatus';
	  }
	      };
		
	// This method is responsible for adding classname to the table data so
		// the corresponding background color is visible according to range
	$scope.getXchangeClass = function(index, status){
		switch(index) {
		  case 1:
			if (status < 750 ){ 
			return 'xchange-green';
			}
			else if (status >800){ 
			return 'xchange-red';
			}
			else if(status >750 && status < 800){
			  return 'xchange-orange';
			}
		  	break;
		  case 2:
			if (status < 1100 ){ 
			return 'xchange-green';
			}
			else if (status >1100){ 
			return 'xchange-red';
			}
				  
		  	break;
		  case 3:
			if (status < 500000 ){ 
			return 'xchange-green';
			}
			else if (status >500000){ 
			return 'xchange-red';
			}	  	
		  	break;	
		  case 4:
			if (status > 20 ){ 
			return 'xchange-green';
			}
			else if (status >0 && status <= 10 ){
			return 'xchange-red';
			}
			else if(status >10 && status < 20){
			  return 'xchange-orange';
			}		  	
		  	break;		  	
		  default:
		  	return '';
		}
	};	
	
	$scope.getGuageTableData = function(){
     var update = function() { 
	  //$http.get("http://172.31.49.151:3000/gauge_data")
	  $http.get("http://webtools.intranet.fedex.com:3000/gauge_data")
	  .then(function (response) {$scope.guagetableData = response.data;});
	  $timeout(update, 1000);
    }
    $timeout(update, 1000);
    }; 
	
	 $scope.TransportTableData = function(){
      console.log("came here for transport queue");
	  var t_update = function() {
      //$http.get("http://172.31.49.151:3000/transport_q")
	  $http.get("http://webtools.intranet.fedex.com:3000/transport_q")
      .then(function (response) {$scope.transportData = response.data;});
	  $timeout(t_update, 2000);
	  }
	  $timeout(t_update, 2000);
    }; 
	
	$scope.DatabaseImbalanceData = function(){
      console.log("came here for DB Imbalance");
	  var imbalance_update = function() {
      //$http.get("http://172.31.49.151:3000/DatabaseImbalanceData")
	  $http.get("http://webtools.intranet.fedex.com:3000/DatabaseImbalanceData")
      .then(function (response) {$scope.DatabaseImbalanceData = response.data;});
	  $timeout(imbalance_update, 2000);
	  }
	  $timeout(imbalance_update, 2000);
    }; 
	
	$scope.DatabaseReplication = function(){
      console.log("came here for DB replication issue");
	  var replication_update = function() {
      //$http.get("http://172.31.49.151:3000/DatabaseReplication")
	  $http.get("http://webtools.intranet.fedex.com:3000/DatabaseReplication")
      .then(function (response) {$scope.DatabaseReplication = response.data;});
	  $timeout(replication_update, 2000);
	  }
	  $timeout(replication_update, 2000);
    }; 
	
	$scope.services_health = function(){
      console.log("came here for Service Health issue");
	  var services_health_update = function() {
      //$http.get("http://172.31.49.151:3000/services_health")
	  $http.get("http://webtools.intranet.fedex.com:3000/services_health") 
      .then(function (response) {$scope.services_health = response.data;});
	  $timeout(services_health_update, 2000);
	  }
	  $timeout(services_health_update, 2000);
    }; 
	
	
	$scope.mailbox_replication = function(){
      console.log("came here for Mailbox replication issue");
	  var mailbox_replication_update = function() {
      //$http.get("http://172.31.49.151:3000/mailbox_replication")
	  $http.get("http://webtools.intranet.fedex.com:3000/mailbox_replication")
      .then(function (response) {$scope.mailbox_replication = response.data;});
	  $timeout(mailbox_replication_update, 2000);
	  }
	  $timeout(mailbox_replication_update, 2000);
    };
	
	$scope.cas_server = function(){
      console.log("came here for cas server issue");
	  var cas_server_update = function() {
      //$http.get("http://172.31.49.151:3000/cas_server")
	  $http.get("http://webtools.intranet.fedex.com:3000/cas_server")
      .then(function (response) {$scope.cas_server = response.data;});
	  $timeout(cas_server_update, 2000);
	  }
	  $timeout(cas_server_update, 2000);
    };
	
	$scope.lastfullbackup = function(){
      console.log("came here for lastFullBackup server issue");
	  var lastfullbackup_update = function() {
      //$http.get("http://172.31.49.151:3000/cas_server")
	  $http.get("http://webtools.intranet.fedex.com:3000/lastfullbackup1")
      .then(function (response) {$scope.lastfullbackup = response.data;});
	  $timeout(lastfullbackup_update, 2000);
	  }
	  $timeout(lastfullbackup_update, 2000);
    };
	
	$scope.lowdiskspace = function(){
      console.log("came here for lowdiskspace server issue");
	  var lowdiskspace_update = function() {
      //$http.get("http://172.31.49.151:3000/cas_server")
	  $http.get("http://webtools.intranet.fedex.com:3000/lowdiskspace1")
      .then(function (response) {$scope.lowdiskspace = response.data;});
	  $timeout(lowdiskspace_update, 2000);
	  }
	  $timeout(lowdiskspace_update, 2000);
    };
	
	$scope.error_table = function(){
      console.log("came here for error server issue");
	  var error_table_update = function() {
      //$http.get("http://172.31.49.151:3000/cas_server")
	  $http.get("http://webtools.intranet.fedex.com:3000/error_table")
      .then(function (response) {$scope.error_table = response.data;});
	  $timeout(error_table_update, 2000);
	  }
	  $timeout(error_table_update, 2000);
    };
	
		$scope.unresponsive_hubcas = function(){
      console.log("came here for cas server issue");
	  var unresponsive_hubcas_update = function() {
      //$http.get("http://172.31.49.151:3000/unresponsive_hubcas")
	  //$http.get("http://webtools.intranet.fedex.com:3000/unresponsive_hubcas")
	  $http.get("http://webtools.intranet.fedex.com:3000/unresponsive_hubcas")
      .then(function (response) {$scope.unresponsive_hubcas = response.data;});
	  $timeout(unresponsive_hubcas_update, 2000);
	  }
	  $timeout(unresponsive_hubcas_update, 2000);
    };

	}