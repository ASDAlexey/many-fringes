(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  define(["angular", "jquery", "lodash", "services", "TweenMax", "bxslider", "Draggable", "snapSVG", "preloadjs"], function(angular, $, _, services, TweenMax, bxSlider, Draggable) {
    "use strict";
    var directive, directives;
    directive = angular.module("App.directives", ["App.services"]);
    directives = {};
    directives.fileInput = [
      "$parse", "$timeout", function($parse, $timeout) {
        return {
          restrict: "A",
          link: function(scope, element, attr) {
            return angular.element(document).ready(function() {
              $(element).parent()[0].ondragover = function() {
                $(element).parent().addClass('hover');
                return false;
              };
              $(element).parent()[0].ondragleave = function() {
                $(element).parent().removeClass('hover');
                return false;
              };
              return element.bind('change', function() {
                var files;
                $parse(attr.fileInput).assign(scope, element[0].files);
                files = scope.files[attr.nameFiles];
                angular.forEach(files, function(file) {
                  var fr;
                  if (!_.findWhere(scope.filesObj[attr.nameFiles].arrFilesBeforeSend, {
                    name: file.name
                  })) {
                    if (file.type === "image/jpeg" || file.type === "image/png") {
                      fr = new FileReader();
                      fr.onload = function(event) {
                        scope.filesObj[attr.nameFiles].arrFilesBeforeSend.push({
                          id: _.uniqueId('file_'),
                          file: file,
                          name: file.name,
                          src: this.result,
                          size: event.total
                        });
                        return scope.$apply();
                      };
                      return fr.readAsDataURL(file);
                    }
                  }
                });
                return element.val(null);

                /*id = 0
                loadImg = (i) ->
                  if i < files.length #загрузка следующего изображения
                    f = files[i]
                    if(f.type is "image/jpeg" or f.type is "image/png")
                      fr = new FileReader()
                      fr.onload = (event)->
                        files[i].id = id
                        scope.filesObj[attr.nameFiles].arrFilesBeforeSend.push {
                          id : _.uniqueId('file_')
                          file : files[i]
                          src : @result
                          size : event.total
                        }
                        scope.$apply()
                      fr.readAsDataURL f #содержимое файла в виде "data URL" — файлы не сохраняются на сервере=
                    loadImg i + 1 #загрузка следующего изображения
                loadImg 0
                 */
              });
            });
          }
        };
      }
    ];

    /*
    directives.fileInput = [
      "$parse"
      ($parse) ->
        restrict : "A"
        link : (scope,element,attr)->
          element.bind 'change',->
            $parse(attr.fileInput).assign(scope,element[0].files)
            files = scope.files
            #поочередное считывание изображений и добавление в массив
            id = 0
            loadImg = (i) ->
              if i < files.length #загрузка следующего изображения
                f = files[i]
                if(f.type is "image/jpeg" or f.type is "image/png")
                  fr = new FileReader()
                  fr.onload = (event)->
                    files[i].id = id
                    scope.arrFilesBeforeSend.push {
                      id:_.uniqueId('file_')
                      file:files[i]
                      src:@result
                      size:event.total
                    }
                    scope.$apply()
                  fr.readAsDataURL f #содержимое файла в виде "data URL" — файлы не сохраняются на сервере=
                loadImg i + 1 #загрузка следующего изображения
            loadImg 0
    ]
     */

    /*directives.a = [
      "$timeout"
      "$location"
      "$rootScope"
      ($timeout,$location,$rootScope) ->
        restrict : "E"
        link : (scope,element)->
          $(element).on "click",(e)->
            e.preventDefault()
            href = $(@).attr('href')
            if href
              $rootScope.persent = 0
              $rootScope.$apply()
              $timeout (->
                $('.preloader').removeClass('hideAnimation').removeClass('hidden')
              ),300
              $timeout (->
                $location.path(href)
              ),1200
    ]
     */
    directives.preloader = [
      "$rootScope", "$timeout", function($rootScope, $timeout) {
        return {
          restrict: "A",
          replace: true,
          link: function(scope, element) {
            var IndicatorPageLoading, Preloader, dataObj, preloader;
            $rootScope.persent = 0;
            IndicatorPageLoading = (function() {
              function IndicatorPageLoading() {}

              IndicatorPageLoading.prototype.manifest = [];

              IndicatorPageLoading.prototype.isUnique = function(el, array) {
                var isFound;
                if (!array.length) {
                  return true;
                }
                isFound = 0;
                array.forEach((function(value, index) {
                  if (value && el === value.src) {
                    return isFound = 1;
                  }
                }));
                if (isFound) {
                  return false;
                } else {
                  return true;
                }
              };

              IndicatorPageLoading.prototype.getManifest = function(scopeBlock) {
                var that;
                this.manifest.length = 0;
                that = this;
                $(scopeBlock).find("*").each(function() {
                  var newSrc, url;
                  if ($(this).css("background-image") !== "none") {
                    url = $(this).css("background-image");
                    url = url.replace(/url\(\"/g, "");
                    url = url.replace(/url\(/g, "");
                    url = url.replace(/\"\)/g, "");
                    url = url.replace(/\)/g, "");
                  } else {
                    if (typeof ($(this).attr("src")) !== "undefined" && $(this).get(0).nodeName.toLowerCase() === "img") {
                      url = $(this).attr("src");
                    }
                  }
                  if (url && that.isUnique(url, that.manifest) && !url.match('gradient')) {
                    newSrc = {};
                    newSrc.src = url;
                    return that.manifest.push(newSrc);
                  }
                });
                return this.manifest;
              };

              IndicatorPageLoading.prototype.handleProgress = function(event) {
                var persent;
                persent = Math.ceil(event.loaded * 100);
                $rootScope.persent = persent;
                return $rootScope.$apply();
              };

              IndicatorPageLoading.prototype.handleComplete = function() {
                return dataObj.hidePreloader();
              };

              IndicatorPageLoading.prototype.initLoadQueue = function(manifest) {
                var preload;
                preload = new createjs.LoadQueue(true);
                preload.on("progress", this.handleProgress);
                preload.on("complete", this.handleComplete);
                return preload.loadManifest(manifest, true);
              };

              IndicatorPageLoading.prototype.hidePreloader = function() {
                this.options.el.addClass('hideAnimation');
                return $timeout(((function(_this) {
                  return function() {
                    return _this.options.el.addClass('hidden');
                  };
                })(this)), 700);
              };

              return IndicatorPageLoading;

            })();
            Preloader = (function(superClass) {
              extend(Preloader, superClass);

              function Preloader(data) {
                this.options = data;
                dataObj.el = data.el;
                dataObj.timeHide = data.timeHide;
                dataObj.hidePreloader = (function(_this) {
                  return function() {
                    return _this.hidePreloader();
                  };
                })(this);
                this.isDOMRendered();
              }

              Preloader.prototype.options = {};

              Preloader.prototype.cashe = {};

              Preloader.prototype.cachedImagesPage = function() {
                var result;
                result = [];
                angular.forEach(this.getManifest(this.options.scopeBlock), (function(_this) {
                  return function(value, key) {
                    if (_this.cashe[value.src] !== value.src) {
                      _this.cashe[value.src] = value.src;
                      return result.push(value);
                    }
                  };
                })(this));
                if (result.length) {
                  return this.initLoadQueue(result);
                } else {
                  $rootScope.persent = 100;
                  $rootScope.$apply();
                  return dataObj.hidePreloader();
                }
              };

              Preloader.prototype.isDOMRendered = function() {
                return scope.$on('$viewContentLoaded', (function(_this) {
                  return function(event) {
                    $rootScope.$broadcast('isDomRender', {
                      isDomRender: true
                    });
                    return $timeout((function() {
                      return _this.cachedImagesPage();
                    }), 300);
                  };
                })(this));

                /*scope.$on '$nodesDOMRendered',(e)=>
                  $rootScope.$broadcast('isDomRender',{
                    isDomRender : true
                  })
                  $timeout (=>
                    @cachedImagesPage()
                  ),300
                 */
              };

              return Preloader;

            })(IndicatorPageLoading);
            dataObj = {};
            return preloader = new Preloader({
              el: $(element),
              timeHide: .7,
              scopeBlock: 'body'
            });
          }
        };
      }
    ];
    directives.cube = [
      "config", "$rootScope", function(config, $rootScope) {
        return {
          restrict: "E",
          replace: true,
          scope: {
            front: "@",
            text: "@",
            hrefLink: "@"
          },
          templateUrl: "app/templates/cube.html",
          link: function(scope, element) {
            var hoverEffect, tl;
            scope.config = config;
            if (cssua.ua && cssua.ua.ie <= 11.0) {
              CSSPlugin.defaultTransformPerspective = 1000;
              TweenMax.set($(element).find('.cont .back'), {
                rotationY: -180
              });
              tl = new TimelineMax({
                paused: true
              });
              tl.to($(element).find('.cont .front'), 1, {
                rotationY: 180
              }).to($(element).find('.cont .back'), 1, {
                rotationY: 0
              }, 0);
              angular.element(element).on("mouseenter touch", function() {
                return tl.play();
              });
              return angular.element(element).on("mouseleave touch", function() {
                return tl.reverse();
              });
            } else {
              TweenMax.to($(element).find('.cont'), 0, {
                rotationY: "17"
              });
              hoverEffect = TweenMax.to($(element).find('.cont'), 0.5, {
                rotationY: "90"
              });
              hoverEffect.pause();
              angular.element(element).on("mouseenter touch", function() {
                return hoverEffect.play();
              });
              return angular.element(element).on("mouseleave touch", function() {
                return hoverEffect.reverse();
              });
            }
          }
        };
      }
    ];
    directives.scrollUp = [
      "$timeout", function($timeout) {
        return {
          restrict: "A",
          link: function(scope, element) {
            return scope.$watch("scrollClick", function(value) {
              if (value) {
                return $('.wrapper').stop().animate({
                  scrollTop: 0
                }, scope.scrollProperty.duration);
              }
            });
          }
        };
      }
    ];
    directives.rotationDragMenu = [
      "$timeout", "$window", "$rootScope", "RDMStorage", "svgIconConfig", "svgIcon", "$location", function($timeout, $window, $rootScope, RDMStorage, svgIconConfig, svgIcon, $location) {
        return {
          restrict: "E",
          replace: true,
          scope: {
            menu: "@"
          },
          templateUrl: "app/templates/rotation-drag-menu.html",
          link: function(scope, element, attrs) {
            return angular.element(document).ready(function() {
              var DrawRotationDragMenu, complete, containerRDM, rotationSnap, svgIconItem, tl, update, updateNullPosition;
              scope.absUrl = $location.absUrl();
              scope.wh = $(window).height();
              $('.wrapper-rotation-drag-menu').css('top', scope.wh);
              angular.element($window).bind('resize', function() {
                scope.wh = $(window).height();
                return $('.wrapper-rotation-drag-menu').css('top', scope.wh);
              });
              DrawRotationDragMenu = (function() {
                function DrawRotationDragMenu(data) {
                  var arrProperty, canvas;
                  this.options = data;
                  canvas = Snap(data.canvas);
                  arrProperty = [
                    {
                      center: {
                        x: 175,
                        y: 175
                      },
                      r: 175,
                      x: -130,
                      y: -10,
                      number: 0,
                      width: 1920,
                      height: 1080,
                      k: 300
                    }, {
                      center: {
                        x: 175,
                        y: 175
                      },
                      r: 175,
                      x: 0,
                      y: 0,
                      number: 1,
                      width: 1934,
                      height: 826,
                      k: 185
                    }, {
                      center: {
                        x: 175,
                        y: 175
                      },
                      r: 175,
                      x: -40,
                      y: 10,
                      number: 2,
                      width: 1920,
                      height: 1440,
                      k: 300
                    }, {
                      center: {
                        x: 175,
                        y: 175
                      },
                      r: 175,
                      x: -50,
                      y: -32,
                      number: 3,
                      width: 1920,
                      height: 1200,
                      k: 250
                    }, {
                      center: {
                        x: 175,
                        y: 175
                      },
                      r: 175,
                      x: -400,
                      y: 0,
                      number: 4,
                      width: 1920,
                      height: 412,
                      k: 175
                    }, {
                      center: {
                        x: 175,
                        y: 175
                      },
                      r: 175,
                      x: -40,
                      y: -10,
                      number: 5,
                      width: 2560,
                      height: 1600,
                      k: 175
                    }, {
                      center: {
                        x: 175,
                        y: 175
                      },
                      r: 175,
                      x: 0,
                      y: -15,
                      number: 6,
                      width: 1960,
                      height: 1363,
                      k: 300
                    }
                  ];
                  angular.forEach(scope.menu, (function(value, key) {
                    var that;
                    that = this;
                    that.path[key] = canvas.path(that.arc(arrProperty[key]));
                    return that.addImageFill(canvas, that.path[key], "app/images/categories_images/" + scope.menu[key].src, arrProperty[key].x, arrProperty[key].y, arrProperty[key].width, arrProperty[key].height, arrProperty[key].k);
                  }), this);
                }

                DrawRotationDragMenu.prototype.canvas = '';

                DrawRotationDragMenu.prototype.options = '';

                DrawRotationDragMenu.prototype.path = [];

                DrawRotationDragMenu.prototype.arc = function(property) {
                  return "M" + property.center.x + "," + property.center.y + " L" + (property.r * Math.cos(property.number * 2 * Math.PI / 7) + property.center.x) + "," + (property.r * Math.sin(property.number * 2 * Math.PI / 7) + property.center.y) + " A" + property.r + "," + property.r + " 0 0,1 " + (property.r * Math.cos(2 * Math.PI / 7 * (property.number + 1)) + property.center.x) + "," + (property.r * Math.sin(2 * Math.PI / 7 * (property.number + 1)) + property.center.y) + " z";
                };

                DrawRotationDragMenu.prototype.circle = function(property) {
                  return 'm ' + property.cx + ' ' + property.cy + ' m -' + property.r + ', 0 a ' + property.r + ',' + property.r + ' 0 1,0 ' + property.r * 2 + ',0 a ' + property.r + ',' + property.r + ' 0 1,0 -' + property.r * 2 + ',0';
                };

                DrawRotationDragMenu.prototype.arrowRight = function() {
                  return 'm25,20 L68,40L25,60z';
                };

                DrawRotationDragMenu.prototype.arrowLeft = function() {
                  return 'm55,20 L12,40 L55,60z';
                };

                DrawRotationDragMenu.prototype.rectangle = function(property) {
                  return "m " + property.x + "," + property.y + " L " + property.x + "," + property.width + " L " + property.height + "," + property.width + " L " + property.height + "," + property.x + " z";
                };

                DrawRotationDragMenu.prototype.el = [];

                DrawRotationDragMenu.prototype.attr = [];

                DrawRotationDragMenu.prototype.attrHover = [];

                DrawRotationDragMenu.prototype.time = [];

                DrawRotationDragMenu.prototype.setAttr = function(attr, attrHover, index) {
                  this.attr[index] = attr;
                  return this.attrHover[index] = attrHover;
                };

                DrawRotationDragMenu.prototype.addImageFill = function(canvas, path, imgSrc, x, y, width, height, k) {
                  var pattern;
                  pattern = canvas.image(imgSrc, 0, 0, k, width * (k / height)).pattern(0, 0, k, width * (k / height));
                  pattern.attr({
                    x: x,
                    y: y
                  });
                  $rootScope.$on('$locationChangeSuccess', function(event) {
                    scope.absUrl = $location.absUrl();
                    console.log('url');
                    console.log(scope.absUrl);
                    scope.$apply();
                    return path.attr("fill", "url(" + scope.absUrl + "#" + pattern.node.id + ")");
                  });
                  return path.attr("fill", "url(" + scope.absUrl + "#" + pattern.node.id + ")");
                };

                DrawRotationDragMenu.prototype.pathAnimateStart = function(path, index) {
                  return path.animate({
                    'stroke-dashoffset': 0.1,
                    fill: this.attrHover[index].fill,
                    stroke: this.attrHover[index]['stroke'],
                    "fill-opacity": this.attrHover[index]['fill-opacity'],
                    'path': this.el[index](this.property[index])
                  }, this.time[index], mina.none);
                };

                DrawRotationDragMenu.prototype.pathAnimateStop = function(path, index) {
                  return path.animate({
                    'stroke-dashoffset': this.pathLenght(path),
                    fill: this.attr[index].fill,
                    "fill-opacity": this.attr[index]['fill-opacity'],
                    stroke: this.attr[index]['stroke'],
                    'path': this.el[index](this.property[index])
                  }, this.time[index], mina.none);
                };

                DrawRotationDragMenu.prototype.pathLenght = function(path) {
                  return path.getTotalLength();
                };

                DrawRotationDragMenu.prototype.pathDash = function(path) {
                  return path.attr({
                    'stroke-dasharray': this.pathLenght(path) + ' ' + this.pathLenght(path),
                    'stroke-dashoffset': this.pathLenght(path)
                  });
                };

                DrawRotationDragMenu.prototype.events = function(canvas, path, index) {
                  canvas.mouseover((function(_this) {
                    return function() {
                      return _this.pathAnimateStart(path, index);
                    };
                  })(this));
                  return canvas.mouseout((function(_this) {
                    return function() {
                      return _this.pathAnimateStop(path, index);
                    };
                  })(this));
                };

                return DrawRotationDragMenu;

              })();
              scope.menu = scope.$eval(scope.menu);
              $timeout(function() {
                return scope.$apply();
              });
              new DrawRotationDragMenu({
                canvas: $(element).find('svg').get(0)
              });
              rotationSnap = 90;
              containerRDM = $(element).find('#rotation-drag-menu');
              updateNullPosition = function() {
                if (this.rotation >= 360) {
                  return $rootScope.degree = this.rotation - 360;
                } else if (this.rotation <= -360) {
                  return $rootScope.degree = this.rotation + 360;
                } else {
                  return $rootScope.degree = this.rotation;
                }
              };
              Draggable.create(containerRDM, {
                type: 'rotation',
                throwProps: true,
                onDrag: updateNullPosition,
                snap: function(endValue) {}
              });
              $rootScope.$watch("degree", function(value) {
                if (value) {
                  return TweenMax.to(containerRDM, 0.5, {
                    rotation: -value
                  });
                }
              });
              svgIconItem = new svgIcon($('.si-icons-default > .si-icon').get(0), svgIconConfig);
              complete = function() {
                return $(".control").css('visibility', 'hidden');
              };
              update = function() {
                return $(".control").css('visibility', 'visible');
              };
              tl = new TimelineLite({
                onComplete: complete,
                onUpdate: update
              });
              tl.to("#rotation-drag-menu", .7, {
                scale: 0,
                ease: Back.easeOut
              }).to($(".control.left"), .5, {
                left: -51,
                opacity: 0
              }, "-=.7").to($(".control.right"), .5, {
                left: -51,
                opacity: 0
              }, "-=.7");
              return $rootScope.$watch('isShowRDM', function(newValue, oldValue) {
                if (newValue) {
                  tl.play();
                  svgIconItem.options.setToggle(true);
                  return localStorage.setItem("tlRDM", false);
                } else {
                  tl.reverse();
                  svgIconItem.options.setToggle(false);
                  localStorage.setItem("tlRDM", true);
                  return $(".control").css('visibility', 'hidden');
                }
              });
            });
          }
        };
      }
    ];
    directives.drawSvg = [
      "$timeout", function($timeout) {
        return {
          restrict: "E",
          replace: true,
          scope: {
            width: "@",
            height: "@",
            elements: "@"
          },
          templateUrl: "app/templates/draw-svg.html",
          link: function(scope, element, attrs) {
            return angular.element(document).ready(function() {
              var DrawSvgPath;
              scope.elements = scope.$eval(scope.elements);
              DrawSvgPath = (function() {
                function DrawSvgPath(data) {
                  var canvas, path;
                  this.elements = data.elements;
                  canvas = Snap(data.canvas);
                  path = [];
                  this.elements.forEach((function(_this) {
                    return function(value, index) {
                      _this.options.push(value);
                      _this.setAttr(value.attr, value.attrHover, index);
                      _this.el.push(_this[value.el]);
                      _this.time.push(value.time);
                      _this.property[index] = value.property;
                      path[index] = canvas.path(_this.el[index](_this.property[index]));
                      path[index].attr(_this.attr[index]);
                      if (_this.attr[index].fill.match(/images/)) {
                        _this.addImageFill(canvas, path[index], _this.attr[index].fill);
                      }
                      _this.pathDash(path[index]);
                      return _this.events(canvas, path[index], index);
                    };
                  })(this));
                }

                DrawSvgPath.prototype.elements = [];

                DrawSvgPath.prototype.options = [];

                DrawSvgPath.prototype.circle = function(property) {
                  return 'm ' + property.cx + ' ' + property.cy + ' m -' + property.r + ', 0 a ' + property.r + ',' + property.r + ' 0 1,0 ' + property.r * 2 + ',0 a ' + property.r + ',' + property.r + ' 0 1,0 -' + property.r * 2 + ',0';
                };

                DrawSvgPath.prototype.arrowRight = function() {
                  return 'm25,20 L68,40L25,60z';
                };

                DrawSvgPath.prototype.arrowLeft = function() {
                  return 'm55,20 L12,40 L55,60z';
                };

                DrawSvgPath.prototype.rectangle = function(property) {
                  return "m " + property.x + "," + property.y + " L " + property.x + "," + property.width + " L " + property.height + "," + property.width + " L " + property.height + "," + property.x + " z";
                };

                DrawSvgPath.prototype.el = [];

                DrawSvgPath.prototype.attr = [];

                DrawSvgPath.prototype.attrHover = [];

                DrawSvgPath.prototype.time = [];

                DrawSvgPath.prototype.property = [];

                DrawSvgPath.prototype.setAttr = function(attr, attrHover, index) {
                  this.attr[index] = attr;
                  return this.attrHover[index] = attrHover;
                };

                DrawSvgPath.prototype.addImageFill = function(canvas, path, imgSrc) {
                  var pattern;
                  pattern = canvas.image(imgSrc, 0, 0, 80, 80).pattern(0, 0, 80, 80);
                  return path.attr("fill", pattern);
                };

                DrawSvgPath.prototype.pathAnimateStart = function(path, index) {
                  return path.animate({
                    'stroke-dashoffset': 0.1,
                    fill: this.attrHover[index].fill,
                    stroke: this.attrHover[index]['stroke'],
                    "fill-opacity": this.attrHover[index]['fill-opacity'],
                    'path': this.el[index](this.property[index])
                  }, this.time[index], mina.none);
                };

                DrawSvgPath.prototype.pathAnimateStop = function(path, index) {
                  return path.animate({
                    'stroke-dashoffset': this.pathLenght(path),
                    fill: this.attr[index].fill,
                    "fill-opacity": this.attr[index]['fill-opacity'],
                    stroke: this.attr[index]['stroke'],
                    'path': this.el[index](this.property[index])
                  }, this.time[index], mina.none);
                };

                DrawSvgPath.prototype.pathLenght = function(path) {
                  return path.getTotalLength();
                };

                DrawSvgPath.prototype.pathDash = function(path) {
                  return path.attr({
                    'stroke-dasharray': this.pathLenght(path) + ' ' + this.pathLenght(path),
                    'stroke-dashoffset': this.pathLenght(path)
                  });
                };

                DrawSvgPath.prototype.events = function(canvas, path, index) {
                  canvas.mouseover((function(_this) {
                    return function() {
                      return _this.pathAnimateStart(path, index);
                    };
                  })(this));
                  return canvas.mouseout((function(_this) {
                    return function() {
                      return _this.pathAnimateStop(path, index);
                    };
                  })(this));
                };

                return DrawSvgPath;

              })();

              /*
                fill : './images/angularjs.jpg' | "red" | "#f00"
               */
              return new DrawSvgPath({
                canvas: $(element).get(0),
                elements: scope.elements
              });
            });
          }
        };
      }
    ];
    directives.imgFilter = [
      "config", "$timeout", "$window", function(config, $timeout, $window) {
        return {
          restrict: "E",
          replace: true,
          scope: {
            image: "="
          },
          template: "<svg version=\"1.1\" baseProfile=\"tiny\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0\" y=\"0\" width=\"100%\" height=\"{{ww/image.width*image.height}}px\" ng-viewBox=\"0 0 100% {{ww/image.width*image.height}}px\" xml:space=\"preserve\"></svg>",
          link: function(scope, element) {
            return angular.element(document).ready(function() {
              var canvas, f, filterChild, image, tw, updateBlur;
              scope.ww = $(window).width();
              angular.element($window).bind('resize', function() {
                return scope.ww = $(window).width();
              });
              canvas = Snap($(element).get(0));
              f = canvas.filter(Snap.filter.blur(5, 5));
              filterChild = f.node.firstChild;
              updateBlur = function(tween) {
                return filterChild.attributes[0].value = 5 * (1 - tw.progress()) + ',' + 5 * (1 - tw.progress());
              };
              image = canvas.image(scope.image.src, 0, 0, "100%", scope.ww / scope.image.width * scope.image.height);
              image.attr({
                filter: f
              });
              tw = TweenLite.to(image.node, 1, {
                onUpdate: updateBlur,
                onUpdateParams: ['{self}']
              });
              tw.pause();
              $(element).parents('li').on('mouseenter', function() {
                return tw.play();
              });
              return $(element).parents('li').on('mouseleave', function() {
                return tw.reverse();
              });
            });
          }
        };
      }
    ];
    directives.scroll = [
      "config", "$timeout", "$window", function(config, $timeout, $window) {
        return {
          restrict: "A",
          link: function(scope, element) {
            var showHideOnScroll, wh;
            wh = $($window).height();
            showHideOnScroll = function() {
              if ($('.wrapper').scrollTop() > wh) {
                return $('#up').addClass('show');
              } else {
                return $('#up').removeClass('show');
              }
            };
            showHideOnScroll();
            return $('.wrapper').on('scroll', showHideOnScroll);
          }
        };
      }
    ];
    directives.chainSlider = [
      "config", "$timeout", "$rootScope", function(config, $timeout, $rootScope) {
        return {
          restrict: "A",
          link: function(scope, element) {
            var ChainSlider;
            return ChainSlider = (function() {
              function ChainSlider(options) {
                this.options = options;
                if (options.lists.length <= 6) {
                  options.el.find('.controlls-slider').hide();
                }
                this.currentGroup = options.lists.slice((this.currentNumber - 1) * 6, this.currentNumber * 6);
                this.currentGroupLength = this.currentGroup.length;
                TweenMax.to(this.currentGroup, 0, {
                  left: 0
                });
                this.options.el.find('.sub-category').html(this.currentGroup);
                this.events();
              }

              ChainSlider.prototype.options = {};

              ChainSlider.prototype.currentNumber = 1;

              ChainSlider.prototype.currentGroup = [];

              ChainSlider.prototype.currentGroupLength = new Number();

              ChainSlider.prototype.isCircleEnd = function(number, side) {
                if (side === 'left' && number === 0) {
                  this.currentNumber = Math.ceil(this.options.lists.length / 6);
                } else if (side === 'right' && number === Math.ceil(this.options.lists.length / 6) + 1) {
                  this.currentNumber = 1;
                }
                return console.log(this.currentNumber);
              };

              ChainSlider.prototype.groupLeftMove = function(leftFrom, leftTo) {
                this.currentGroup = this.options.lists.slice((this.currentNumber - 1) * 6, this.currentNumber * 6);
                TweenMax.to(this.currentGroup, 0, {
                  left: leftFrom
                });
                this.options.el.find('.sub-category').html(this.currentGroup);
                return this.currentGroup.each((function(_this) {
                  return function(index, value) {
                    return TweenMax.to(value, _this.options.time, {
                      left: leftTo,
                      delay: index * _this.options.time / _this.currentGroupLength
                    });
                  };
                })(this));
              };

              ChainSlider.prototype.groupRightMove = function(rightFrom, rightTo) {
                this.currentGroup = this.options.lists.slice((this.currentNumber - 1) * 6, this.currentNumber * 6);
                TweenMax.to(this.currentGroup, 0, {
                  left: rightFrom
                });
                this.options.el.find('.sub-category').html(this.currentGroup);
                return this.currentGroup.each((function(_this) {
                  return function(index, value) {
                    return TweenMax.to(value, _this.options.time, {
                      left: rightTo,
                      delay: _this.options.time - index * _this.options.time / _this.currentGroupLength
                    });
                  };
                })(this));
              };

              ChainSlider.prototype.disableSwitchSlider = function(el) {
                return el.parents('.controlls-slider').find('a').removeClass('switch-slider');
              };

              ChainSlider.prototype.enableSwitchSlider = function(el) {
                return el.parents('.controlls-slider').find('a').addClass('switch-slider');
              };

              ChainSlider.prototype.events = function() {
                return $(element).on("click", ".controlls-slider .switch-slider", (function(_this) {
                  return function(e) {
                    var ect;
                    e.preventDefault();
                    ect = $(e.currentTarget);
                    _this.disableSwitchSlider(ect);
                    if (ect.hasClass('left')) {
                      _this.groupRightMove(0, 2000);
                      $timeout((function() {
                        _this.currentNumber--;
                        _this.isCircleEnd(_this.currentNumber, 'left');
                        return _this.groupRightMove(-2000, 0);
                      }), _this.options.time * 1000 + 100);
                    } else {
                      _this.groupLeftMove(0, -2000);
                      $timeout((function() {
                        _this.currentNumber++;
                        _this.isCircleEnd(_this.currentNumber, 'right');
                        return _this.groupLeftMove(2000, 0);
                      }), _this.options.time * 1000 + 100);
                    }
                    return $timeout((function() {
                      return _this.enableSwitchSlider(ect);
                    }), (_this.options.time * 1000 + 100) * 3);
                  };
                })(this));
              };

              scope.$applyAsync(function() {
                var options, tl;
                options = {
                  el: $(element),
                  lists: $(element).find('.sub-category>li'),
                  time: 1.2
                };
                tl = new TimelineLite();
                return new ChainSlider(options);
              });

              return ChainSlider;

            })();
          }
        };
      }
    ];
    directives.showCube = [
      "config", "$timeout", function(config, $timeout) {
        return {
          restrict: "A",
          link: function(scope, element) {
            return $timeout(function() {
              var choiseGroupShowed, hoverEffect, showArrowLeft, showArrowRight, tl;
              tl = new TimelineLite();
              choiseGroupShowed = $(element).find('.sub-category>li');
              hoverEffect = tl.staggerFrom(choiseGroupShowed, 0.5, {
                scale: 0,
                rotation: -360,
                autoAlpha: 0
              }, 0.2, "stagger");
              hoverEffect.pause();
              showArrowLeft = TweenLite.from($(element).find('.switch-slider.left'), .8, {
                left: "-500px",
                ease: Back.easeOut
              });
              showArrowRight = TweenLite.from($(element).find('.switch-slider.right'), .8, {
                right: "-500px",
                ease: Back.easeOut
              });
              showArrowLeft.pause();
              showArrowRight.pause();
              angular.element(element).on("mouseenter", function() {
                hoverEffect.play();
                showArrowLeft.play();
                return showArrowRight.play();
              });
              return angular.element(element).on("mouseleave", function() {
                hoverEffect.reverse();
                showArrowLeft.reverse();
                return showArrowRight.reverse();
              });
            }, 0);
          }
        };
      }
    ];
    directives.request = [
      "config", function(config) {
        return {
          restrict: "E",
          templateUrl: config.frontendTemplatesPath + "/request.html"
        };
      }
    ];
    directives.thank = [
      "config", function(config) {
        return {
          restrict: "E",
          templateUrl: config.frontendTemplatesPath + "/thank.html"
        };
      }
    ];
    directives.onlyIntNumbersPlus = function() {
      return {
        link: function(scope, element, attrs) {
          return $(element).keydown(function(event) {
            if (event.keyCode === 107 || event.keyCode === 46 || event.keyCode === 8 || event.keyCode === 9 || event.keyCode === 27 || (event.keyCode === 65 && event.ctrlKey === true) || (event.keyCode >= 35 && event.keyCode <= 39)) {
              return;
            } else {
              if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105) && !(event.keyCode === 61 && event.shiftKey === true)) {
                event.preventDefault();
              }
            }
          });
        }
      };
    };
    directives.isValideBorder = function() {
      return {
        restrict: "A",
        scope: {
          isValideBorder: "@",
          borderStyle: "@"
        },
        link: function(scope, element) {
          scope.$watch("formIsValide", function(value) {
            if (!value) {
              $(element).parents('form').find('input').removeAttr('style', '').removeClass('ng-dirty').addClass('ng-pristine');
              $(element).parents('form').removeClass('ng-dirty').addClass('ng-pristine');
            }
            return element.bind('submit', function() {
              if (scope.isValideBorder) {
                return $(element).find('.ng-pristine.ng-invalid').css('border', '1px solid #f00');
              }
            });
          });
          return scope.$watch("borderStyle", function(value) {
            if (value) {
              return $('.wrapper-input input').removeAttr('style');
            }
          });
        }
      };
    };
    directives.getParentHeight = [
      "$rootScope", "$timeout", "$window", function($rootScope, $timeout, $window) {
        return {
          restrict: "A",
          link: function(scope, element) {
            return $timeout(function() {
              var getHeight;
              getHeight = function() {
                var asideHeight, headerHeight, height, heightContent, maintHeight;
                height = $(document).outerHeight();
                headerHeight = $('.header-block').outerHeight();
                asideHeight = 0;
                $('.aside>*').each(function() {
                  return asideHeight += $(this).outerHeight();
                });
                maintHeight = 0;
                $('.wrapper-content>*').each(function() {
                  return maintHeight += $(this).outerHeight();
                });
                if (asideHeight >= maintHeight) {
                  heightContent = asideHeight;
                } else {
                  heightContent = maintHeight;
                }
                if (heightContent < (height - headerHeight)) {
                  return $('.aside').height(height - headerHeight);
                } else {
                  return $('.aside').removeAttr('style');
                }
              };
              getHeight();
              return angular.element($window).bind('resize', function() {
                return getHeight();
              });
            }, 500);
          }
        };
      }
    ];
    directives.change = function() {
      return {
        restrict: "A",
        link: function(scope, element) {
          return $(document).on("click", ".saw-catalogs", function(e) {
            var changecategory;
            e.preventDefault();
            changecategory = $(this).data('changecategory');
            $('.list-catalogs>li').eq(changecategory).trigger('click');
            return $('html, body').animate({
              scrollTop: $(".catalogs").offset().top - 66
            }, 700);
          });
        }
      };
    };
    directives.bxslider = [
      "$timeout", "dataService", "$compile", function($timeout, dataService, $compile) {
        return {
          restrict: "E",
          scope: {
            options: "@",
            url: "@"
          },
          replace: true,
          templateUrl: "app/templates/bxslider-tmpl.html",
          link: function(scope, element, attr) {
            var slider, svgLeft, svgRight;
            slider = '';
            scope.getCountSlides = function() {
              var countSlides, widthSlider;
              widthSlider = $('.header').width() - $('.wrapper-logo').width() - 100;
              countSlides = parseInt(widthSlider / 260);
              return countSlides;
            };
            svgLeft = "<draw-svg width=\"80\" height=\"80\"\n            elements=\"[{attr: {fill: 'none','fill-opacity':0,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: '#ff5a00','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'circle',property: {cx: 40,cy: 40,r: 38},time: 800}, {attr: {fill: '#ff5a00','fill-opacity': .7,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: 'green','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'arrowLeft',time: 800}]\"></draw-svg>";
            svgRight = "              <draw-svg width=\"80\" height=\"80\"\nelements=\"[{attr: {fill: 'none','fill-opacity':0,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: '#ff5a00','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'circle',property: {cx: 40,cy: 40,r: 38},time: 800}, {attr: {fill: '#ff5a00','fill-opacity': .7,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: 'green','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'arrowRight',time: 800}]\"></draw-svg>";
            dataService.query({
              namePage: "" + scope.url
            }, function(data) {
              scope.dataSlider = data;
              return $timeout((function() {
                scope.options = scope.$eval(scope.options);
                scope.options.maxSlides = scope.getCountSlides();
                scope.options.pagerCustom = '.bx-pager';
                slider = $(element).bxSlider(scope.options);
                return $timeout((function() {
                  $('.header .bx-prev').html($compile(svgLeft)(scope));
                  return $('.header .bx-next').html($compile(svgRight)(scope));
                }), 50);
              }), 0);
            });
            return $(window).resize(function() {
              scope.options.maxSlides = scope.getCountSlides();
              slider.reloadSlider();
              return $timeout((function() {
                $('.header .bx-prev').html($compile(svgLeft)(scope));
                return $('.header .bx-next').html($compile(svgRight)(scope));
              }), 50);
            });
          }
        };
      }
    ];
    directives.popularSlider = [
      "$timeout", "dataService", "$compile", function($timeout, dataService, $compile) {
        return {
          restrict: "E",
          scope: {
            options: "@",
            url: "@"
          },
          replace: true,
          templateUrl: "app/templates/popularslider-tmpl.html",
          link: function(scope, element, attr) {
            var slider, svgLeft, svgRight;
            slider = '';
            svgLeft = "<draw-svg width=\"80\" height=\"80\"\n            elements=\"[{attr: {fill: 'none','fill-opacity':0,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: '#ff5a00','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'circle',property: {cx: 40,cy: 40,r: 38},time: 800}, {attr: {fill: '#ff5a00','fill-opacity': .7,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: 'green','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'arrowLeft',time: 800}]\"></draw-svg>";
            svgRight = "              <draw-svg width=\"80\" height=\"80\"\nelements=\"[{attr: {fill: 'none','fill-opacity':0,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: '#ff5a00','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'circle',property: {cx: 40,cy: 40,r: 38},time: 800}, {attr: {fill: '#ff5a00','fill-opacity': .7,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: 'green','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'arrowRight',time: 800}]\"></draw-svg>";
            scope.getCountSlides = function() {
              var countSlides, widthSlider;
              widthSlider = $('.list-category .row .cell:first-child').width() - 100;
              countSlides = parseInt(widthSlider / 260);
              return countSlides;
            };
            dataService.query({
              namePage: "" + scope.url
            }, function(data) {
              scope.dataSlider = data;
              return $timeout((function() {
                scope.options = scope.$eval(scope.options);
                scope.options.maxSlides = scope.getCountSlides();
                scope.options.pagerCustom = '.bx-pager';
                slider = $(element).bxSlider(scope.options);
                return $timeout((function() {
                  $('.wrapper-popular .bx-prev').html($compile(svgLeft)(scope));
                  return $('.wrapper-popular .bx-next').html($compile(svgRight)(scope));
                }), 50);
              }), 0);
            });
            return $(window).resize(function() {
              scope.options.maxSlides = scope.getCountSlides();
              slider.reloadSlider();
              return $timeout((function() {
                $('.wrapper-popular .bx-prev').html($compile(svgLeft)(scope));
                return $('.wrapper-popular .bx-next').html($compile(svgRight)(scope));
              }), 50);
            });
          }
        };
      }
    ];
    directives.angularPreloader = [
      "$window", "$rootScope", "$timeout", "config", function($window, $rootScope, $timeout, config) {
        return {
          restrict: "E",
          templateUrl: config.frontendTemplatesPath + "/angular-preloader.html",
          link: function(scope, element, attr) {
            var GSPreloader, preloader;
            GSPreloader = function(options) {
              var animation, animationOffset, box, closingAnimation, colors, createDot, dot, dotSize, dots, i, isActive, j, parent, radius, rotationIncrement, tl;
              options = options || {};
              parent = options.parent || document.body;
              parent = options.parent || document.body;
              parent = options.parent || document.body;
              element = this.element = document.createElement("div");
              radius = options.radius || 42;
              dotSize = options.dotSize || 15;
              animationOffset = options.animationOffset || 1.8;
              createDot = function(rotation) {
                var dot;
                dot = document.createElement("div");
                element.appendChild(dot);
                TweenMax.set(dot, {
                  width: dotSize,
                  height: dotSize,
                  transformOrigin: -radius + "px 0px",
                  x: radius,
                  backgroundColor: colors[colors.length - 1],
                  borderRadius: "50%",
                  force3D: true,
                  position: "absolute",
                  rotation: rotation
                });
                dot.className = options.dotClass || "preloader-dot";
                return dot;
              };
              i = options.dotCount || 10;
              rotationIncrement = 360 / i;
              colors = options.colors || ["#61AC27", "black"];
              animation = new TimelineLite({
                paused: true
              });
              dots = [];
              isActive = false;
              box = document.createElement("div");
              tl = void 0;
              dot = void 0;
              closingAnimation = void 0;
              j = void 0;
              colors.push(colors.shift());
              TweenMax.set(box, {
                width: radius * 2 + 70,
                height: radius * 2 + 70,
                borderRadius: "50%",
                backgroundColor: options.boxColor || "white",
                border: options.boxBorder || "1px solid #AAA",
                position: "absolute",
                x: "-" + ((radius * 2 + 70) / 2),
                y: "-" + ((radius * 2 + 70) / 2),
                opacity: ((options.boxOpacity != null) ? options.boxOpacity : 0.3)
              });
              box.className = options.boxClass || "preloader-box";
              element.appendChild(box);
              parent.appendChild(element);
              TweenMax.set(element, {
                position: "fixed",
                top: "45%",
                left: "50%",
                perspective: 600,
                overflow: "visible",
                zIndex: 2000
              });
              animation.from(box, 0.1, {
                opacity: 0,
                scale: 0.1,
                ease: Power1.easeOut
              }, animationOffset);
              while (--i > -1) {
                dot = createDot(i * rotationIncrement);
                dots.unshift(dot);
                animation.from(dot, 0.1, {
                  scale: 0.01,
                  opacity: 0,
                  ease: Power1.easeOut
                }, animationOffset);
                tl = new TimelineMax({
                  repeat: -1,
                  repeatDelay: 0.25
                });
                j = 0;
                while (j < colors.length) {
                  tl.to(dot, 2.5, {
                    rotation: "-=360",
                    ease: Power2.easeInOut
                  }, j * 2.9).to(dot, 1.2, {
                    skewX: "+=360",
                    backgroundColor: colors[j],
                    ease: Power2.easeInOut
                  }, 1.6 + 2.9 * j);
                  j++;
                }
                animation.add(tl, i * 0.07);
              }
              if (TweenMax.render) {
                TweenMax.render();
              }
              this.active = function(show) {
                if (!arguments.length) {
                  return isActive;
                }
                if (isActive !== show) {
                  isActive = show;
                  if (closingAnimation) {
                    closingAnimation.kill();
                  }
                  if (isActive) {
                    element.style.visibility = "visible";
                    TweenMax.set([element, box], {
                      rotation: 0
                    });
                    animation.play(animationOffset);
                  } else {
                    closingAnimation = new TimelineLite();
                    if (animation.time() < animationOffset + 0.3) {
                      animation.pause();
                      closingAnimation.to(element, 1, {
                        rotation: -360,
                        ease: Power1.easeInOut
                      }).to(box, 1, {
                        rotation: 360,
                        ease: Power1.easeInOut
                      }, 0);
                    }
                    closingAnimation.staggerTo(dots, 0.3, {
                      scale: 0.01,
                      opacity: 0,
                      ease: Power1.easeIn,
                      overwrite: false
                    }, 0.05, 0).to(box, 0.4, {
                      opacity: 0,
                      scale: 0.2,
                      ease: Power2.easeIn,
                      overwrite: false
                    }, 0).call(function() {
                      animation.pause();
                      closingAnimation = null;
                    }).set(element, {
                      visibility: "hidden"
                    });
                  }
                }
                return this;
              };
            };
            preloader = new GSPreloader({
              radius: 42,
              dotSize: 15,
              dotCount: 10,
              colors: ["red", "#555", "gold", "#FF6600"],
              boxOpacity: 0.2,
              boxBorder: "1px solid #AAA",
              animationOffset: 1.8
            });
            preloader.active(false);
            return $rootScope.$watch("page", function(value) {
              var dNtoLoad;
              if (value) {
                preloader.active(true);
                dNtoLoad = $('#dNtoLoad');
                if (dNtoLoad.hasClass('first-load')) {
                  dNtoLoad.removeClass('first-load');
                } else {
                  dNtoLoad.addClass('dNtoLoad');
                }
                $timeout(function() {
                  return preloader.active(false);
                }, 500);
                return $timeout(function() {
                  return dNtoLoad.removeClass('dNtoLoad');
                }, 1200);
              }
            }, true);
          }
        };
      }
    ];
    directives.eraser = [
      "$timeout", function($timeout) {
        return {
          restrict: "A",
          link: function(scope, element, attr) {
            return $(element).eraser();
          }
        };
      }
    ];
    directives.perfectScrollbar = [
      "$timeout", function($timeout) {
        return {
          restrict: "A",
          link: function(scope, element, attr) {
            return $timeout(function() {
              return $(element).perfectScrollbar({
                maxScrollbarLength: 200,
                useKeyboard: true,
                useBothWheelAxes: true
              });
            }, 0);
          }
        };
      }
    ];
    directives.filters = [
      "$timeout", "$interval", function($timeout, $interval) {
        return {
          restrict: "A",
          scope: {
            filters: "@",
            blurRadius: "@"
          },
          link: function(scope, element, attr) {
            var BLUR_RADIUS, canvas, canvasContext, drawBlur, image;
            BLUR_RADIUS = scope.blurRadius;
            canvas = $(element).find('canvas').attr({
              width: $(window).width(),
              height: $(window).height()
            }).get(0);
            canvasContext = canvas.getContext("2d");
            image = new Image();
            image.src = scope.filters;
            drawBlur = function(borderRadius) {
              var h, w;
              w = 1920;
              h = 1080;
              canvasContext.drawImage(image, 0, 0, w, h);
              return stackBlurCanvasRGBA($(element).find('canvas').get(0).id, 0, 0, w, h, borderRadius);
            };
            image.onload = function() {
              return drawBlur(BLUR_RADIUS);
            };
            angular.element(element).on("mouseenter", function() {
              return $interval(function(i) {
                return drawBlur(5 - i);
              }, 10, 5);
            });
            return angular.element(element).on("mouseleave", function() {
              return drawBlur(BLUR_RADIUS);
            });
          }
        };
      }
    ];
    directive.directive(directives);
    return directive;
  });

}).call(this);

//# sourceMappingURL=directives.js.map
