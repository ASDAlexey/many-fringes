(function() {
  define(["angular", "jquery", "TweenMax", "CSSPlugin"], function(angular, $, TweenMax) {
    "use strict";
    var appAnimations;
    appAnimations = angular.module("App.animations", []);
    appAnimations.animation('.move', function() {
      var imgMoved, iteration, skewTimeline, widthPanorama, windowWidth;
      skewTimeline = new TimelineLite();
      imgMoved = $('.panorama');
      widthPanorama = $('.panorama').width();
      windowWidth = $(window).width();
      iteration = 1;
      setInterval(function() {
        if (iteration % 2 === 1) {
          skewTimeline.to(imgMoved, 70, {
            css: {
              left: "-2000px"
            },
            repeat: 0,
            ease: Linear.easeNone
          });
        } else {
          skewTimeline.to(imgMoved, 70, {
            css: {
              left: "0"
            },
            repeat: 0,
            ease: Linear.easeNone
          });
        }
        return iteration++;
      }, 3);
      return {
        addClass: function(element, className) {
          console.log('addclass');
        }
      };
    });
    return appAnimations;
  });

}).call(this);

//# sourceMappingURL=../angular/animations.js.map