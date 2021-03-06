define [
  "angular"
  "filters"
  "services"
  "directives"
  "controllers"
  "animations"
#  "angularRoute"
  "angularUiRouter"
  "angularAnimate"
  "angularFileUpload"
  "angularCookies"
  "angularSanitize"
  "angularScroll"
  "angularYmaps"
  "angularMultiSelect"
  "angularResource"
  "lbServices"
  "ngTokenAuth"
#  "angularRender"
  "angularOff",
],(angular,filters,services,directives,controllers,animations) ->
  "use strict"
  # Модуль проложения
  app = angular.module("App",[
#    "ngRoute"
    'ui.router'
    "App.controllers"
    "App.filters"
    "App.services"
    "App.directives"
    "App.animations"
    "angularFileUpload"
    "ngAnimate"
    "ngCookies"
    "ngSanitize"
    "duScroll"
    "yaMap"
    "multi-select"
    "ngResource"
    "lbServices"
    "ng-token-auth"
#    "ngRender"
    "angular-off"
  ])
  app
