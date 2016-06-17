/**
 * Master Controller
 */

angular.module('Dash')
    .controller('MasterCtrl', ['$http', '$scope', '$cookieStore', MasterCtrl]);

function MasterCtrl($http, $scope, $cookieStore) {
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

    $scope.toggleSidebar = function() {
        $scope.toggle = !$scope.toggle;
        $cookieStore.put('toggle', $scope.toggle);
    };

    window.onresize = function() {
        $scope.$apply();
    };

    $scope.getTableData = function(){
      console.log("came here tadaaa");
      $http.get("http://localhost:3000/dashboard/data")
      .then(function (response) {$scope.tableData = response.data;});
    };
}