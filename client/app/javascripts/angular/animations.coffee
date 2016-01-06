define [
  "angular"
  "jquery"
  "TweenMax"
  "CSSPlugin"
], (angular, $, TweenMax) ->
  "use strict"
  # Animations
  appAnimations = angular.module("App.animations", [])
  appAnimations.animation '.move', ()->
    skewTimeline = new TimelineLite()
    imgMoved = $('.panorama')
    widthPanorama = $('.panorama').width()
    windowWidth = $(window).width()
    iteration = 1
    setInterval(->
      if(iteration % 2 is 1)
#        imgMoved.animate
#          marginLeft: "-2000px"
#        , 100000
#        imgMoved.animate('left', "-2000px", 70000)
        skewTimeline.to(imgMoved, 70, {css: {left: "-2000px"}, repeat: 0, ease: Linear.easeNone})
      else
        skewTimeline.to(imgMoved, 70, {css: {left: "0"}, repeat: 0, ease: Linear.easeNone})
      #        imgMoved.animate
      #          marginLeft: "0"
      #        , 100000
      iteration++
    , 3)
    addClass: (element, className) ->
      console.log('addclass')
      return
  appAnimations