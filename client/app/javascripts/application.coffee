require.config
  waitSeconds : 100
  paths :
  #vendors
#    angular : "vendor/angular"
    angular : "vendor/angular"
    angularUiRouter : "vendor/angular-ui-router.min"
    angularResource : "vendor/angular-resource"
    angularAnimate : "vendor/angular-animate.min"
    angularMessages : "vendor/angular-messages.min"
    angularCookies : "vendor/angular-cookies.min"
    angularSanitize : "vendor/angular-sanitize.min"
    angularTouch : "vendor/angular-touch.min"
    angularLoader : "vendor/angular-loader.min"
#    angularRoute : "vendor/angular-route.min"
    lodash : "vendor/lodash"
    jquery : "vendor/jquery-2.1.1.min"
    text : "vendor/text"
    cssua : "vendor/cssua.min"
    snapSVG : "vendor/snap.svg"
    hammer : "vendor/hammer"
  #plugins
    angularScroll : "plugins/angular-scroll.min"
    angularYmaps : "plugins/ya-map-2.1.min"
    bxslider : "plugins/jquery.bxslider.min"
    photobox : "plugins/photobox"
    angularMultiSelect : "plugins/angular-multi-select"
    ngTokenAuth : "plugins/ng-token-auth.min"
    angularOff : "plugins/angular-off"
#    angularRender : "plugins/angular-render"
    angularFileUpload : "plugins/angular-file-upload"
  #preloader
    preloadjs : "plugins/preloadjs-0.6.0.min"
  #greensock
    gsap : "greensock/jquery.gsap.min"
    TimelineLite : "greensock/TimelineLite.min"
    TimelineMax : "greensock/TimelineMax.min"
    TweenLite : "greensock/TweenLite.min"
    TweenMax : "greensock/TweenMax.min"
    CSSPlugin : "greensock/plugins/CSSPlugin.min"
    DrawSVG : "greensock/plugins/DrawSVGPlugin"
    Draggable : "greensock/utils/Draggable.min"
  #angular app
    app : "angular/app"
    controllers : "angular/controllers"
    directives : "angular/directives"
    services : "angular/services"
    filters : "angular/filters"
    animations : "angular/animations"
    lbServices : "angular/angular-sdk"
    routes : "angular/routes"
  shim :
    angular :
      exports : "angular"
    angularResource : ["angular"]
    angularUiRouter : ["angular"]
    angularAnimate : ["angular"]
    angularMessages : ["angular"]
    angularCookies : ["angular"]
    angularSanitize : ["angular"]
    angularTouch : ["angular"]
    lbServices : ["angular","angularResource"]
#    angularRoute : ["angular"]
    angularLoader : ["angular"]
    angularScroll : ["angular"]
    angularYmaps : ["angular"]
#    angularRender : ["angular"]
    angularMultiSelect : ["angular"]
    angularFileUpload : ["angular"]
    ngTokenAuth : ["angular"]
    angularOff : ["angular"]
    svgIcons : ["snapSVG"]
    lodash : ["jquery"]
    bxslider : ["jquery"]
    photobox : ["jquery"]
    preloadjs : ["jquery"]
  priority : ["angular"]
window.name = "NG_DEFER_BOOTSTRAP!"
require [
  "angular"
  "app"
  "routes"
  "cssua"
],(angular,app) ->
  "use strict"
  angular.element().ready ->
    angular.resumeBootstrap [app["name"]]
