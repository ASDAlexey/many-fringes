(function() {
  define(["angular", "filters", "services", "directives", "controllers", "animations", "angularUiRouter", "angularAnimate", "angularFileUpload", "angularCookies", "angularSanitize", "angularScroll", "angularYmaps", "angularMultiSelect", "angularResource", "lbServices", "ngTokenAuth", "angularOff"], function(angular, filters, services, directives, controllers, animations) {
    "use strict";
    var app;
    app = angular.module("App", ['ui.router', "App.controllers", "App.filters", "App.services", "App.directives", "App.animations", "angularFileUpload", "ngAnimate", "ngCookies", "ngSanitize", "duScroll", "yaMap", "multi-select", "ngResource", "lbServices", "ng-token-auth", "angular-off"]);
    return app;
  });

}).call(this);

//# sourceMappingURL=app.js.map
