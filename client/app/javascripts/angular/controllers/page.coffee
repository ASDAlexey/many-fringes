define [], ->
  [
    "$scope"
    "$http"
    ($scope, $http) ->
      $scope.welcomeMessage = "hey this is myctrl2.js!"
      $scope.$apply()
  ]