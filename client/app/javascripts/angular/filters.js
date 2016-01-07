(function() {
  define(["angular", "jquery", "services"], function(angular, $, services) {
    "use strict";
    var filters;
    filters = angular.module("App.filters", ["App.services"]);
    filters.filter("splitSpace", function() {
      return function(input) {
        return input.toString().replace(/(\d)(?=(\d\d\d)+([^\d]|$))/g, '$1 ');
      };
    });
    filters.filter("discont50", function() {
      return function(quantity) {
        return quantity / 2;
      };
    });
    return filters;
  });

}).call(this);

//# sourceMappingURL=filters.js.map
