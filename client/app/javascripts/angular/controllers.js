(function() {
  define(["angular", "lodash", "jquery", "services", "angularOff"], function(angular, _, $) {
    "use strict";
    var controller, controllers;
    controller = angular.module("App.controllers", ["App.services"]);
    controllers = {};
    controllers.MyCtrl = [
      '$scope', '$upload', function($scope, $upload) {
        $scope.$watch('files', function() {
          return $scope.upload($scope.files);
        });
        return $scope.upload = function(files) {
          var file, i, results;
          if (files && files.length) {
            i = 0;
            results = [];
            while (i < files.length) {
              file = files[i];
              $upload.upload({
                url: 'linecategories/upload',
                fields: {
                  username: 'ASDAlexey'
                },
                file: file
              }).progress(function(evt) {
                var progressPercentage;
                progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
                return console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
              }).success(function(data, status, headers, config) {
                return console.log(data);
              });
              results.push(i++);
            }
            return results;
          }
        };
      }
    ];
    controllers.FileCtrl = [
      '$scope', "$http", "$q", function($scope, $http, $q) {
        $scope.filesObj = {};
        $scope.setFileObj = function(name) {
          return $scope.filesObj[name] = {
            arrFilesServer: [],
            arrFilesBeforeSend: [],
            currentLoadPersent: 0
          };
        };
        $scope.removeServerFile = function() {};
        $scope.removeFile = function(file, nameGroup) {
          return $scope.filesObj[nameGroup].arrFilesBeforeSend.splice($scope.filesObj[nameGroup].arrFilesBeforeSend.indexOf(file), 1);
        };
        return $scope.send = (function(_this) {
          return function(filesObj, url) {
            var bufferArr, currentLoad, promise, total;
            promise = $q.all({});
            bufferArr = {};
            currentLoad = 0;
            total = 0;
            angular.forEach(filesObj, function(value, key) {
              return total += _.sum(value.arrFilesBeforeSend, 'size');
            });
            angular.forEach(filesObj, function(v, k) {
              bufferArr[k] = [];
              return angular.forEach(v.arrFilesBeforeSend, function(value, key) {
                var fd;
                fd = new FormData();
                fd.append(value.id, value.file);
                return promise = promise.then(function() {
                  return $http({
                    url: url,
                    method: "POST",
                    data: fd,
                    transformRequest: angular.identity,
                    headers: {
                      'Content-Type': void 0
                    }
                  }).then(function(res) {
                    bufferArr[k].push(res.data[0]);
                    currentLoad += _.result(_.findWhere(v.arrFilesBeforeSend, {
                      id: res.data[0].id
                    }), 'size');
                    return $scope.currentLoadPersent = parseInt(currentLoad * 100 / total);
                  });
                });
              });
            });
            return promise.then(function() {
              return angular.forEach($scope.filesObj, function(value, key) {
                $scope.filesObj[key].arrFilesServer = _.union($scope.filesObj[key].arrFilesServer, bufferArr[key]);
                $scope.currentLoadPersent = 0;
                return $scope.filesObj[key].arrFilesBeforeSend.length = 0;
              });
            });
          };
        })(this);
      }
    ];
    controllers.UserSessionsCtrl = [
      "$scope", function($scope) {
        return $scope.$on('auth:login-error', function(ev, reason) {
          return $scope.error = reason.errors[0];
        });
      }
    ];
    controllers.UserRegistrationsCtrl = [
      "$scope", "$location", "$auth", function($scope, $location, $auth) {
        $scope.$on('auth:registration-email-error', function(ev, reason) {
          return $scope.error = reason.errors[0];
        });
        return $scope.handleRegBtnClick = function() {
          return $auth.submitRegistration($scope.registrationForm).then(function() {
            return $auth.submitLogin({
              email: $scope.registrationForm.email,
              password: $scope.registrationForm.password
            });
          });
        };
      }
    ];
    controllers.GroupsCtrl = [
      "$scope", function($scope) {
        $scope.groups = ['Group One', 'Group Two'];
        return console.log($scope.groups);
      }
    ];
    controllers.indexCtrl = [
      "$scope", "$location", "config", "$rootScope", "Linecategory", "$sce", function($scope, $location, config, $rootScope, Linecategory, $sce) {
        $scope.absUrl = $location.absUrl();
        $scope.menu = [];
        $scope.config = config;
        $scope.categoryImages = [
          {
            "src": "zodiac.jpg",
            "width": 1920,
            "height": 1080
          }, {
            "src": "devination.jpg",
            "width": 1934,
            "height": 836
          }, {
            "src": "dream_interpretation.jpg",
            "width": 1920,
            "height": 1440
          }, {
            "src": "tests.jpg",
            "width": 1920,
            "height": 1200
          }, {
            "src": "beauty_and_health.jpg",
            "width": 1920,
            "height": 412
          }, {
            "src": "food.jpg",
            "width": 2560,
            "height": 1600
          }, {
            "src": "names.jpg",
            "width": 1920,
            "height": 1363
          }
        ];
        $scope.fullPathCategoryImages = _.each($scope.categoryImages, function(value) {
          return value.src = 'app/images/category-images/' + value.src;
        });
        $scope.linecategories = Linecategory.find({
          filter: {
            include: [
              {
                relation: 'categories',
                scope: {
                  include: {
                    relation: 'categoryImage'
                  }
                }
              }, {
                relation: 'linecategoryImage'
              }
            ]
          }
        });
        return $scope.linecategories.$promise.then(function(data) {
          console.log('/////');
          return console.log(data);
        });
      }
    ];
    controllers.lineCategoryCtrl = [
      "$scope", "$location", "config", "$rootScope", "$stateParams", "Linecategory", "$state", function($scope, $location, config, $rootScope, $stateParams, Linecategory, $state) {
        $scope.absUrl = $location.absUrl();
        $scope.params = $stateParams;
        $scope.$state = $state;
        $scope.sref = function(stateObj) {
          var obj;
          obj = {};
          obj[$state.current.name] = $stateParams[$state.current.name];
          angular.extend(obj, stateObj);
          return "category(" + (angular.toJson(obj)) + ")";
        };
        $scope.getHref = function(str) {
          return "/" + $stateParams[$state.current.name] + "/" + str;
        };
        $scope.linecategory = Linecategory.findOne({
          filter: {
            where: {
              slug: $scope.params.lineCategory
            },
            include: {
              relation: 'categories',
              scope: {
                include: {
                  relation: 'categoryImage'
                }
              }
            }
          }
        });
        return $scope.linecategory.$promise.then(function(data) {
          return console.log(data);
        });
      }
    ];
    controllers.categoryCtrl = [
      "$scope", "$location", "config", "$rootScope", "$stateParams", "Category", function($scope, $location, config, $rootScope, $stateParams, Category) {
        $scope.absUrl = $location.absUrl();
        $scope.params = $stateParams;
        $scope.category = Category.findOne({
          filter: {
            where: {
              slug: $scope.params.category
            },
            include: [
              {
                relation: 'articles',
                scope: {
                  include: {
                    relation: 'articleImage'
                  }
                }
              }, {
                relation: 'categoryImage'
              }
            ]
          }
        });
        return $scope.category.$promise.then(function(data) {
          return console.log(data);
        });
      }
    ];
    controllers.ArticleCtrl = [
      "$scope", "$stateParams", "Article", function($scope, $stateParams, Article) {
        $scope.params = $stateParams;
        $scope.article = Article.findOne({
          filter: {
            where: {
              slug: $stateParams.article
            },
            include: {
              relation: 'articleImage'
            }
          }
        });
        return $scope.article.$promise.then(function(data) {
          return console.log(data);
        });
      }
    ];
    controllers.pageCtrl = [
      "$scope", "$location", "config", "$rootScope", function($scope, $location, config, $rootScope) {
        $scope.config = config;
        return $scope.choise1 = [
          {
            icon: "<img  src=\"https://cdn1.iconfinder.com/data/icons/fatcow/32/opera.png\" />",
            name: "Куплю",
            ticked: true
          }, {
            icon: "<img  src=\"https://cdn1.iconfinder.com/data/icons/fatcow/32/internet_explorer.png\" />",
            name: "Продам",
            ticked: false
          }, {
            icon: "<img  src=\"https://cdn1.iconfinder.com/data/icons/fatcow/32/internet_explorer.png\" />",
            name: "Сниму",
            ticked: false
          }, {
            icon: "<img  src=\"https://cdn1.iconfinder.com/data/icons/fatcow/32/internet_explorer.png\" />",
            name: "Сдам",
            ticked: false
          }
        ];
      }
    ];
    controllers.bodyCtrl = [
      "$scope", "$rootScope", function($scope, $rootScope) {
        return $rootScope.heightObj = {};
      }
    ];
    controllers.DragMenuCtrl = [
      "$scope", "$rootScope", "RDMStorage", function($scope, $rootScope, RDMStorage) {
        var dataTlRDM, degArc;
        $rootScope.degree = 0;
        degArc = 360 / 7;
        $scope.rotateMenu = function(side, count) {
          if (side === 'left') {
            return $rootScope.degree += degArc;
          } else {
            return $rootScope.degree -= degArc;
          }
        };
        dataTlRDM = localStorage.getItem("tlRDM");
        if (dataTlRDM && dataTlRDM === 'true') {
          $rootScope.isShowRDM = false;
        } else {
          $rootScope.isShowRDM = true;
        }
        return $scope.showHideRDM = function() {
          return $rootScope.isShowRDM = !$rootScope.isShowRDM;
        };
      }
    ];
    controllers.popupCtrl = [
      "$scope", "$rootScope", function($scope, $rootScope) {
        $scope.isPopupActive = false;
        return $rootScope.triggerPopupShow = function(mes, product) {
          if (mes == null) {
            mes = '';
          }
          if (product == null) {
            product = '';
          }
          return $scope.isPopupActive = !$scope.isPopupActive;
        };
      }
    ];
    controllers.scrollCtrl = [
      "$scope", "$timeout", "$rootScope", "$location", function($scope, $timeout, $rootScope, $location) {
        $scope.absUrl = $location.absUrl();
        $scope.scrollClick = 0;
        $scope.scrollToElement = function(element, offset, duration) {
          $scope.scrollClick++;
          return $scope.scrollProperty = {
            element: element,
            offset: offset,
            duration: duration
          };
        };
        return $scope.modalToggle = function() {
          return $scope.isModalOpen = !$scope.isModalOpen;
        };
      }
    ];
    controllers.currencylangCtrl = [
      "$scope", function($scope) {
        $scope.currency = [
          {
            icon: "<span class=\"currency rub\"></span>",
            name: "рубль",
            ticked: true
          }, {
            icon: "<span class=\"currency usd\"></span>",
            name: "доллар",
            ticked: false
          }, {
            icon: "<span class=\"currency eur\"></span>",
            name: "евро",
            ticked: false
          }
        ];
        return $scope.lang = [
          {
            icon: "<span class=\"lang ru\"></span>",
            name: "рус.",
            ticked: true
          }, {
            icon: "<span class=\"lang en\"></span>",
            name: "англ.",
            ticked: false
          }
        ];
      }
    ];
    controllers.formValidationCtrl = [
      "$scope", "$http", "$rootScope", "$timeout", function($scope, $http, $rootScope, $timeout) {
        $rootScope.formIsValide = false;
        $scope.form_set_pristine = function(form) {
          if (form.$setPristine) {
            return form.$setPristine();
          }
        };
        $scope.form_set_dirty = function(form) {
          if (form.$setDirty) {
            form.$setDirty();
            return angular.forEach(form, function(input, key) {
              if (typeof input === 'object' && input.$name !== undefined) {
                return form[input.$name].$setViewValue((form[input.$name].$viewValue !== undefined ? form[input.$name].$viewValue : ""));
              }
            });
          }
        };
        $scope.send = (function(_this) {
          return function(dataForm, formValidate) {
            if (formValidate.$valid) {
              $rootScope.formIsValide = true;
              $timeout(function() {
                return $rootScope.hideThank();
              }, 2500);
              $http({
                url: "controllers/mail.php",
                method: "POST",
                data: $scope.dataForm
              }).success(function(data, status, headers, config) {
                return $scope.data = data;
              }).error(function(data, status, headers, config) {
                return $scope.status = status;
              });
              $scope.dataForm = {};
              return $scope.form_set_pristine(formValidate);
            } else {
              return $scope.form_set_dirty(formValidate);
            }
          };
        })(this);
        return $rootScope.hideThank = function() {
          return $rootScope.formIsValide = false;
        };
      }
    ];
    controllers.yaCtrl = [
      "$scope", function($scope) {
        return $scope.geoObjects = [
          {
            geometry: {
              type: "Point",
              coordinates: [37.443915, 55.710896]
            },
            properties: {
              hintContent: "Москва, ул.Верейская ул. д17"
            }
          }
        ];
      }
    ];
    controllers.catCtrl = [
      "$scope", "$location", "config", "$rootScope", function($scope, $location, config, $rootScope) {
        $scope.path = config.path;
        $rootScope.page = $location.path();
        return $scope.config = config;
      }
    ];
    controller.controller(controllers);
    return controller;
  });

}).call(this);

//# sourceMappingURL=controllers.js.map
