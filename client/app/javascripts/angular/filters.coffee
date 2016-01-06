define [
  "angular"
  "jquery"
  "services"
], (angular, $, services) ->
  "use strict"
  # Filters
  filters = angular.module("App.filters", ["App.services"])
  #  #Разбить пробелами по 3 символа
  filters.filter "splitSpace", ->
    (input) ->
      input.toString().replace(/(\d)(?=(\d\d\d)+([^\d]|$))/g, '$1 ')
  filters.filter "discont50", ->
    (quantity) ->
      quantity / 2
  filters