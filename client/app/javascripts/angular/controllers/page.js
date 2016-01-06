(function() {
  define([], function() {
    return [
      "$scope", "$http", function($scope, $http) {
        $scope.welcomeMessage = "hey this is myctrl2.js!";
        return $scope.$apply();
      }
    ];
  });

}).call(this);

//# sourceMappingURL=../../angular/controllers/page.js.map