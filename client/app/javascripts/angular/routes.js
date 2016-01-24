(function() {
  define(["angular", "app"], function(angular, app) {
    "use strict";
    var routes;
    app.constant("config", {
      path: "http://" + window.location.host,
      adminTemplatesPath: ("http://" + window.location.host) + '/app' + '/templates',
      frontendTemplatesPath: ("http://" + window.location.host) + '/app' + '/templates',
      frontendImgPath: ("http://" + window.location.host) + '/app' + '/images'
    });
    app.run([
      "$rootScope", "$location", function($rootScope, $location) {
        $rootScope.$on('auth:login-success', function() {
          return $location.path('/');
        });
        return $rootScope.$on('$stateChangeError', function(event, toState, toParams, fromState, fromParams, error) {
          console.log('dd');
          console.log(error);
          if (error.status === 401) {
            return $state.transitionTo("login", {
              returnUrl: $location.url()
            });
          }
        });
      }
    ]);
    routes = app.config([
      '$stateProvider', '$locationProvider', '$urlRouterProvider', 'config', function($stateProvider, $locationProvider, $urlRouterProvider, config) {
        $stateProvider.state('home', {
          url: "/",
          templateUrl: config.frontendTemplatesPath + "/index.html",
          controller: "indexCtrl"
        }).state('lineCategory', {
          url: "/:lineCategory",
          templateUrl: config.frontendTemplatesPath + "/category/list-category.html",
          controller: "lineCategoryCtrl"
        }).state('category', {
          url: "/:lineCategory/:category",
          templateUrl: config.frontendTemplatesPath + "/category/category.html",
          controller: "categoryCtrl"
        }).state('article', {
          url: "/:lineCategory/:category/:article",
          templateUrl: config.frontendTemplatesPath + "/category/article.html",
          controller: "ArticleCtrl"
        });
        $locationProvider.html5Mode({
          enabled: true,
          requireBase: false
        }).hashPrefix('!');
        return $urlRouterProvider.otherwise('/');
      }
    ]);

    /*routes = app.config([
    "$routeProvider"
    "$locationProvider"
    "config"
    ($routeProvider,$locationProvider,config) ->
    $routeProvider
    .when "/",
      templateUrl : "#{config.frontendTemplatesPath}/index.html"
      controller : "indexCtrl"
      redirectTo : (current,path,search) ->
        if search
          if search.goto
            "/" + search.goto
          else
            "/"
    .when "/sign_in",
      templateUrl : "#{config.frontendTemplatesPath}/user_sessions/new.html"
      controller : "UserSessionsCtrl"
    .when "/sign_up",
      templateUrl : "#{config.frontendTemplatesPath}/user_registrations/new.html"
      controller : "UserRegistrationsCtrl"
    .when "/groups",
      templateUrl : "#{config.frontendTemplatesPath}/groups.html"
      controller : "GroupsCtrl"
      resolve :
        auth : [
          "$auth"
          "$location"
          ($auth,$location)->
            $auth.validateUser()
             *              console.log($auth.authenticate('asdalexey@yandex.ru'))
            #isLogged == 0 - Пользователь залогинен и находился на этой странице
            #isLogged == 1 - Пользователь залогинен
            #isLogged == 2 - Пользователь не залогинен
            isLogged = $auth.validateUser().$$state.status
            if isLogged is 2
              $location.path('/groups')
        ]
    .when "/:lineCategory",
      templateUrl : "#{config.frontendTemplatesPath}/category/list-category.html"
      controller : "lineCategoryCtrl"
      resolve : {
        "load" : ($rootScope,$timeout)->
     *            $timeout (->
     *              routeChange = (event,newUrl)->
     *                event.preventDefault()
     *                console.log('start')
     *                $('.preloader').removeClass('hideAnimation').removeClass('hidden')
     *                onRouteChangeOff()
     *                $timeout (->
     *                  console.log(newUrl)
     *                  $location.path(newUrl)
     *                  $rootScope.routLoad = true
     *                ),800
     *              onRouteChangeOff = $rootScope.$on('$locationChangeStart',routeChange)
     *            )
      }
    .when "/:lineCategory/:category",
      templateUrl : "#{config.frontendTemplatesPath}/category/category.html"
      controller : "categoryCtrl"
    .when "/:lineCategory/:category/:article",
      templateUrl : "#{config.frontendTemplatesPath}/category/article.html"
      controller : "articleCtrl"
    .otherwise redirectTo : "/"
    $locationProvider.hashPrefix('!')
    $locationProvider.html5Mode(true)
    ])
     */
    return routes;
  });

}).call(this);

//# sourceMappingURL=routes.js.map
