define [
  "angular"
  "lodash"
  "jquery"
  "services"
#  "angularRender"
  "angularOff"

],(angular,_,$) ->
  "use strict"
  # Controllers
  controller = angular.module("App.controllers",["App.services"])
  controllers = {}
  controllers.MyCtrl = [
    '$scope'
    '$upload'
    ($scope,$upload) ->
      $scope.$watch 'files',->
        $scope.upload $scope.files
      $scope.upload = (files) ->
        if files and files.length
          i = 0
          while i < files.length
            file = files[i]
            $upload.upload(
              url : 'linecategories/upload'
              fields :
                username : 'ASDAlexey'
              file : file
            ).progress((evt) ->
              progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
              console.log 'progress: ' + progressPercentage + '% ' + evt.config.file.name
            ).success (data,status,headers,config) ->
              console.log(data)
            #              console.log 'file ' + config.file.name + 'uploaded. Response: ' + angular.fromJSON(data)
            i++
  ]
  controllers.FileCtrl = [
    '$scope'
    "$http"
    "$q"
    ($scope,$http,$q) ->
      $scope.filesObj = {}
      $scope.setFileObj = (name)->
        $scope.filesObj[name] = {
          arrFilesServer : []
          arrFilesBeforeSend : []
          currentLoadPersent : 0
        }
      $scope.removeServerFile = ()->

      $scope.removeFile = (file,nameGroup)->
        $scope.filesObj[nameGroup].arrFilesBeforeSend.splice($scope.filesObj[nameGroup].arrFilesBeforeSend.indexOf(file),1)
      $scope.send = (filesObj,url)=>
        promise = $q.all({})
        bufferArr = {}
        currentLoad = 0
        total = 0
        angular.forEach filesObj,(value,key) ->
          total += _.sum(value.arrFilesBeforeSend,'size')
        angular.forEach filesObj,(v,k) ->
          bufferArr[k] = []
          angular.forEach v.arrFilesBeforeSend,(value,key) ->
            fd = new FormData()
            fd.append value.id,value.file
            promise = promise.then(->
              $http(
                url : url
                method : "POST"
                data : fd
                transformRequest : angular.identity,
                headers : {'Content-Type' : undefined}
              ).then (res) ->
                bufferArr[k].push res.data[0]
                currentLoad += _.result _.findWhere(v.arrFilesBeforeSend,{id : res.data[0].id}),'size'
                $scope.currentLoadPersent = parseInt(currentLoad * 100 / total)
            )
        promise.then ->
          angular.forEach $scope.filesObj,(value,key) ->
            $scope.filesObj[key].arrFilesServer = _.union($scope.filesObj[key].arrFilesServer,bufferArr[key])
            $scope.currentLoadPersent = 0
            $scope.filesObj[key].arrFilesBeforeSend.length = 0
  ]
  #  controllers.FileCtrl = [
  #    '$scope'
  #    "$http"
  #    "$q"
  #    ($scope,$http,$q) ->
  #      $scope.filesObj={}
  #      $scope.arrFilesServer = []
  #      $scope.arrFilesBeforeSend = []
  #      $scope.currentLoadPersent=0
  #      $scope.send = (arrFiles,url)=>
  #        promise = $q.all({})
  #        currentLoad=0
  #        total=_.sum(arrFiles, 'size')
  #        bufferArr=[]
  #        angular.forEach arrFiles,(value,key) ->
  #          fd = new FormData()
  #          fd.append value.id,value.file
  #          promise = promise.then(->
  #            $http(
  #              url : url
  #              method : "POST"
  #              data : fd
  #              transformRequest : angular.identity,
  #              headers : {'Content-Type' : undefined}
  #            ).then (res) ->
  #              bufferArr.push res.data[0]
  #              currentLoad+=_.result _.findWhere(arrFiles,{id : res.data[0].id}),'size'
  #              $scope.currentLoadPersent=parseInt(currentLoad*100/total)
  #          )
  #        promise.then ->
  #          $scope.arrFilesServer=_.union($scope.arrFilesServer,bufferArr)
  #          $scope.currentLoadPersent=0
  #          $scope.arrFilesBeforeSend.length=0
  #          console.log($scope.arrFilesServer)
  #  ]
  controllers.UserSessionsCtrl = [
    "$scope"
    ($scope) ->
      $scope.$on 'auth:login-error',(ev,reason)->
        $scope.error = reason.errors[0]
  ]
  controllers.UserRegistrationsCtrl = [
    "$scope"
    "$location"
    "$auth"
    ($scope,$location,$auth) ->
      $scope.$on 'auth:registration-email-error',(ev,reason)->
        $scope.error = reason.errors[0]
      $scope.handleRegBtnClick = ->
        $auth.submitRegistration($scope.registrationForm).then ->
          $auth.submitLogin
            email : $scope.registrationForm.email
            password : $scope.registrationForm.password
  ]
  controllers.GroupsCtrl = [
    "$scope"
    ($scope) ->
      $scope.groups = ['Group One','Group Two']
      console.log($scope.groups)
  ]
  controllers.indexCtrl = [
    "$scope"
    "$location"
    "config"
    "$rootScope"
    "Linecategory"
    "$sce"
    ($scope,$location,config,$rootScope,Linecategory,$sce) ->
      $scope.absUrl = $location.absUrl()
      $scope.menu = []
      $scope.config = config
      $scope.categoryImages = [
        {
          "src" : "zodiac.jpg",
          "width" : 1920
          "height" : 1080
        }
        {
          "src" : "devination.jpg"
          "width" : 1934
          "height" : 836
        }
        {
          "src" : "dream_interpretation.jpg"
          "width" : 1920
          "height" : 1440
        }
        {
          "src" : "tests.jpg"
          "width" : 1920
          "height" : 1200
        }
        {
          "src" : "beauty_and_health.jpg"
          "width" : 1920
          "height" : 412
        }
        {
          "src" : "food.jpg"
          "width" : 2560
          "height" : 1600
        }
        {
          "src" : "names.jpg"
          "width" : 1920
          "height" : 1363
        }
      ]
      $scope.fullPathCategoryImages = _.each($scope.categoryImages,(value)->
        value.src = 'app/images/categories_images/' + value.src
      )
      $scope.linecategories = Linecategory.find({filter : {include : ["categories"]}},
        (arr) ->
          console.log(arr)
        (err) ->
          console.log(err))
  ]
  controllers.lineCategoryCtrl = [
    "$scope"
    "$location"
    "config"
    "$rootScope"
    "$stateParams"
    "Linecategory"
    "Article"
    ($scope,$location,config,$rootScope,$stateParams,Linecategory,Article) ->
      $scope.absUrl = $location.absUrl()
      $scope.params = $stateParams;
      console.log($scope.absUrl)
      console.log($scope.params)
      $scope.linecategory = Linecategory.findOne(filter : {where : {slug : $scope.params.lineCategory},include : ["categories","linecategoryImage"]},
        (arr) ->
          console.log(arr)
        (err) ->
          console.log(err)
      )
  ]
  controllers.categoryCtrl = [
    "$scope"
    "$location"
    "config"
    "$rootScope"
    "$stateParams"
    "Article"
    ($scope,$location,config,$rootScope,$stateParams,Articles) ->
      $scope.absUrl = $location.absUrl()
      $scope.params = $stateParams;
#      Articles.findAll("linecategories/#{$scope.params.lineCategory}/categories").then (data) ->
#        $scope.category = _.findWhere(data,{slug : $scope.params.category})
  ]
  controllers.articleCtrl = [
    "$scope"
    ($scope) ->
#      console.log('ArticleCtrl')
  ]
  ###  controllers.ArticleCtrl = [
    "$scope"
    "$location"
    "config"
    "$rootScope"
    "$routeParams"
    "Article"
    ($scope,$location,config,$rootScope,$routeParams,Articles) ->
      $scope.params = $routeParams;
      console.log('ArtilceCtrl')
#      console.log($scope.params)
#          Articles.findOne("linecategories/#{$scope.params.lineCategory}/articles/").then (data) ->
#            $scope.category=_.findWhere(data, {slug: $scope.params.category})
#            console.log($scope.category)
    ]###
  controllers.pageCtrl = [
    "$scope"
    "$location"
    "config"
    "$rootScope"
    ($scope,$location,config,$rootScope) ->
      $scope.config = config;
      $scope.choise1 = [
        {
          icon : "<img  src=\"https://cdn1.iconfinder.com/data/icons/fatcow/32/opera.png\" />"
          name : "Куплю"
          ticked : true
        }
        {
          icon : "<img  src=\"https://cdn1.iconfinder.com/data/icons/fatcow/32/internet_explorer.png\" />"
          name : "Продам"
          ticked : false
        }
        {
          icon : "<img  src=\"https://cdn1.iconfinder.com/data/icons/fatcow/32/internet_explorer.png\" />"
          name : "Сниму"
          ticked : false
        }
        {
          icon : "<img  src=\"https://cdn1.iconfinder.com/data/icons/fatcow/32/internet_explorer.png\" />"
          name : "Сдам"
          ticked : false
        }
      ]
  ]
  controllers.bodyCtrl = [
    "$scope"
    "$rootScope"
    ($scope,$rootScope) ->
      $rootScope.heightObj = {}
  ]
  controllers.DragMenuCtrl = [
    "$scope"
    "$rootScope"
    "RDMStorage"
    ($scope,$rootScope,RDMStorage) ->
      $rootScope.degree = 0
      degArc = 360 / 7
      $scope.rotateMenu = (side,count)->
        if side is 'left'
          $rootScope.degree += degArc
        else
          $rootScope.degree -= degArc
      dataTlRDM = localStorage.getItem("tlRDM")
      if dataTlRDM and dataTlRDM is 'true'
        $rootScope.isShowRDM = false
      else
        $rootScope.isShowRDM = true
      $scope.showHideRDM = ()->
        $rootScope.isShowRDM = !$rootScope.isShowRDM
  ]
  controllers.popupCtrl = [
    "$scope"
    "$rootScope"
    ($scope,$rootScope) ->
      $scope.isPopupActive = false
      $rootScope.triggerPopupShow = (mes = '',product = '')->
        $scope.isPopupActive = !$scope.isPopupActive
  ]
  controllers.scrollCtrl = [
    "$scope"
    "$timeout"
    "$rootScope"
    "$location"
    ($scope,$timeout,$rootScope,$location) ->
      $scope.absUrl = $location.absUrl()
      #      $rootScope.timer = new Date()
      #      $scope.$on('$viewContentLoaded',->
      #        t = new Date() - $rootScope.timer
      #        console.log('View loaded: ' + t)
      #      )
      #      $scope.$on('$nodesDOMRendered',(e)->
      #        console.log('$nodesDOMRendered')
      #        t = new Date() - $rootScope.timer
      #        console.log('View rendered: ' + t)
      #      )

      $scope.scrollClick = 0
      $scope.scrollToElement = (element,offset,duration)->
        $scope.scrollClick++
        $scope.scrollProperty = {
          element : element
          offset : offset
          duration : duration
        }
      #Отмена изменения пути в AngularJS
      $rootScope.routLoad = false
#      routeChange = (event,newUrl)->
#        event.preventDefault()
#        console.log('start')
#        $('.preloader').removeClass('hideAnimation').removeClass('hidden')
##        $rootScope.$off('$locationChangeStart',routeChange)
##        onRouteChangeOff()
#        $timeout (->
#          console.log(newUrl)
#          $location.path(newUrl)
#          $rootScope.routLoad=true
#        ),800
#      $rootScope.$on('$locationChangeStart',routeChange)
#      $rootScope.$on "$routeChangeStart",(event, next, current)->
#        $timeout (->
#          console.log(onRouteChangeOff())
#        ),900
#      $rootScope.$on '$locationChangeSuccess',->
#        $timeout (->
#          if $rootScope.routLoad
#            console.log('success')
#            $rootScope.routLoad=false
##            $rootScope.$on('$locationChangeStart',routeChange)
#            return
#        ),900
##        $rootScope.$on('$locationChangeStart',routeChange)
#      onRouteChange=$rootScope.$on '$locationChangeStart',(e,newUrl) ->
#        e.preventDefault()
#        onRouteChange()
#        $timeout (->
#          $location.path(newUrl)
#        ),1000
#        console.log($location.search())
#        $location.path($location.search().goto)
##        return
#        $('.preloader').removeClass('hideAnimation').removeClass('hidden')
#        next = parseRoute().$$route
#        console.log(next)
  ]
  controllers.currencylangCtrl = [
    "$scope"
    ($scope) ->
      $scope.currency = [
        {
          icon : "<span class=\"currency rub\"></span>"
          name : "рубль"
          ticked : true
        }
        {
          icon : "<span class=\"currency usd\"></span>"
          name : "доллар"
          ticked : false
        }
        {
          icon : "<span class=\"currency eur\"></span>"
          name : "евро"
          ticked : false
        }
      ]
      $scope.lang = [
        {
          icon : "<span class=\"lang ru\"></span>"
          name : "рус."
          ticked : true
        }
        {
          icon : "<span class=\"lang en\"></span>"
          name : "англ."
          ticked : false
        }
      ]
  ]
  controllers.formValidation = [
    "$scope"
    "$http"
    "$rootScope"
    "$timeout"
    ($scope,$http,$rootScope,$timeout) ->
      $scope.choise1 = [
        {
          icon : "<span class=\"choise buy\"></span>"
          name : "Куплю"
          ticked : true
        }
        {
          icon : "<span class=\"choise sell\"></span>"
          name : "Продам"
          ticked : false
        }
        {
          icon : "<span class=\"choise exchange\"></span>"
          name : "Сниму"
          ticked : false
        }
        {
          icon : "<span class=\"choise rent\"></span>"
          name : "Сдам"
          ticked : false
        }
      ]
      $scope.choise2 = [
        {
          icon : ""
          name : "Вид недвижимости"
          ticked : true
        }
        {
          icon : ""
          name : "Квартиры"
          ticked : false
        }
        {
          icon : ""
          name : "Дома, дачи, коттеджи"
          ticked : false
        }
        {
          icon : ""
          name : "Коммерческая недвижимость"
          ticked : false
        }
        {
          icon : ""
          name : "Земельные участки"
          ticked : false
        }
        {
          icon : ""
          name : "Комнаты"
          ticked : false
        }
        {
          icon : ""
          name : "Гаражи и машиноместа"
          ticked : false
        }
        {
          icon : ""
          name : "Недвижимость за рубежом"
          ticked : false
        }
      ]
      $scope.choise3 = [
        {
          icon : ""
          name : "На длительный срок"
          ticked : true
        }
        {
          icon : ""
          name : "На короткий срок"
          ticked : false
        }
      ]
      $rootScope.formIsValide = false
      $scope.form_set_pristine = (form) ->
        if form.$setPristine
          form.$setPristine()
      $scope.form_set_dirty = (form) ->
        if form.$setDirty
          form.$setDirty()
          angular.forEach form,(input,key) ->
            if typeof input is 'object' and input.$name isnt `undefined`
              form[input.$name].$setViewValue (if form[input.$name].$viewValue isnt `undefined` then form[input.$name].$viewValue else "")
      $scope.send = (dataForm,formValidate)=>
        if formValidate.$valid
          $rootScope.formIsValide = true
          $timeout(->
            $rootScope.hideThank()
          ,2500)
          $http(
            url : "controllers/mail.php"
            method : "POST"
            data : $scope.dataForm
          ).success((data,status,headers,config) ->
            $scope.data = data
          ).error (data,status,headers,config) ->
            $scope.status = status
          $scope.dataForm = {}
          $scope.form_set_pristine(formValidate)
        else
          $scope.form_set_dirty(formValidate)
      $rootScope.hideThank = ()->
        $rootScope.formIsValide = false
  ]
  controllers.yaCtrl = [
    "$scope"
    ($scope) ->
      $scope.geoObjects = [
        {
# Геометрия = тип объекта + географические координаты объекта
          geometry :
# Тип геометрии - точка
            type : "Point"
# Координаты точки.
            coordinates : [
              37.443915
              55.710896
            ]
# Свойства
          properties :
            hintContent : "Москва, ул.Верейская ул. д17"
        }
      ]
  ]
  controllers.catCtrl = [
    "$scope"
    "$location"
    "config"
    "$rootScope"
    ($scope,$location,config,$rootScope) ->
      $scope.path = config.path
      $rootScope.page = $location.path()
      $scope.config = config
  ]

  controller.controller(controllers)
  controller
