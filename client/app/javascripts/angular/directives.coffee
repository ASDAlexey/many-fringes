define [
  "angular"
  "jquery"
  "lodash"
  "services"
  "TweenMax"
  "bxslider"
  "Draggable"
#  "svgIcons"
#  "DrawSVG"
  "snapSVG"
  "preloadjs"
#  "photobox"
],(angular,$,_,services,TweenMax,bxSlider,Draggable) ->
  "use strict"

  # Directives
  directive = angular.module("App.directives",["App.services"])
  directives = {}
  directives.fileInput = [
    "$parse"
    "$timeout"
    ($parse,$timeout) ->
      restrict : "A"
      link : (scope,element,attr)->
        angular.element(document).ready ->
          $(element).parent()[0].ondragover = ->
            $(element).parent().addClass('hover')
            false
          $(element).parent()[0].ondragleave = ->
            $(element).parent().removeClass('hover')
            false
          element.bind 'change',->
            $parse(attr.fileInput).assign(scope,element[0].files)
            files = scope.files[attr.nameFiles]
            angular.forEach files,(file) ->
              unless _.findWhere(scope.filesObj[attr.nameFiles].arrFilesBeforeSend,{name : file.name})
                if(file.type is "image/jpeg" or file.type is "image/png")
                  fr = new FileReader()
                  fr.onload = (event)->
                    scope.filesObj[attr.nameFiles].arrFilesBeforeSend.push {
                      id : _.uniqueId('file_')
                      file : file
                      name: file.name
                      src : @result
                      size : event.total
                    }
                    scope.$apply()
                  fr.readAsDataURL file
            element.val(null)
            ###id = 0
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
            loadImg 0###
  ]
  ###
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
  ]###
  #  directives.preloader = [
  #    "$window"
  #    "$timeout"
  #    ($window,$timeout)->
  #      restrict : "A"
  #      link : (scope,element,attrs) ->
  #        class Preloader
  #          constructor : (opt,sB,loader)->
  #            class Getters
  #              getOptions : ->
  #                return opt
  #              getScopedBlock : ->
  #                return sB
  #            getters = new Getters(opt,sB)
  #            options = getters.getOptions()
  #            scopeBlock = getters.getScopedBlock()
  #            @createContent(options)
  #            @loader = @getSvgLoader(options)
  #            @loader.show()
  #            @removeSvgContainerBg(options)
  #            if options.sortByAlphabetical
  #              @setAnimateWords(options)
  #            @setOptions(options)
  #            @initLoadQueue(@getManifest(scopeBlock))
  #          manifest : []
  #          loader : ''
  #          getEffects : {
  #            parallelogram :
  #              open : "M 0,0 0,60 80,60 80,0 z M 80,0 40,30 0,60 40,30 z",
  #              close : ""
  #              path : "M 0,0 0,60 80,60 80,0 Z M 80,0 80,60 0,60 0,0 Z"
  #            lazy_stretch :
  #              open : "M20,15 50,30 50,30 30,30 Z;M0,0 80,0 50,30 20,45 Z;M0,0 80,0 60,45 0,60 Z;M0,0 80,0 80,60 0,60 Z",
  #              close : "M0,0 80,0 60,45 0,60 Z;M0,0 80,0 50,30 20,45 Z;M20,15 50,30 50,30 30,30 Z;M30,30 50,30 50,30 30,30 Z"
  #              path : "M30,30 50,30 50,30 30,30 Z"
  #            circle :
  #              open : "M 40 -21.875 C 11.356078 -21.875 -11.875 1.3560784 -11.875 30 C -11.875 58.643922 11.356078 81.875 40 81.875 C 68.643922 81.875 91.875 58.643922 91.875 30 C 91.875 1.3560784 68.643922 -21.875 40 -21.875 Z",
  #              close : ""
  #              path : "M40,30 c 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 Z"
  #            spill :
  #              open : "M 0,0 c 0,0 63.5,-16.5 80,0 16.5,16.5 0,60 0,60 L 0,60 Z",
  #              close : ""
  #              path : "M 0,0 c 0,0 -16.5,43.5 0,60 16.5,16.5 80,0 80,0 L 0,60 Z"
  #            frame_it :
  #              open : "M 0,0 0,60 80,60 80,0 Z M 40,30 40,30 40,30 40,30 Z",
  #              close : ""
  #              path : "M 0,0 0,60 80,60 80,0 Z M 80,0 80,60 0,60 0,0 Z"
  #            tunnel_vision :
  #              open : "M -18 -26.90625 L -18 86.90625 L 98 86.90625 L 98 -26.90625 L -18 -26.90625 Z M 40 29.96875 C 40.01804 29.96875 40.03125 29.98196 40.03125 30 C 40.03125 30.01804 40.01804 30.03125 40 30.03125 C 39.98196 30.03125 39.96875 30.01804 39.96875 30 C 39.96875 29.98196 39.98196 29.96875 40 29.96875 Z",
  #              close : ""
  #              path : "M -18 -26.90625 L -18 86.90625 L 98 86.90625 L 98 -26.90625 L -18 -26.90625 Z M 40 -25.6875 C 70.750092 -25.6875 95.6875 -0.7500919 95.6875 30 C 95.6875 60.750092 70.750092 85.6875 40 85.6875 C 9.2499078 85.6875 -15.6875 60.750092 -15.6875 30 C -15.6875 -0.7500919 9.2499078 -25.6875 40 -25.6875 Z"
  #            windscreen_wiper :
  #              open : "M 40,100 150,0 -65,0 z",
  #              close : ""
  #              path : "M 40,100 150,0 l 0,0 z"
  #            jammed_blind :
  #              open : "M 0,60 80,60 80,50 0,40 0,60;M 0,60 80,60 80,25 0,40 0,60;M 0,60 80,60 80,25 0,10 0,60;M 0,60 80,60 80,0 0,0 0,60",
  #              close : "M 0,60 80,60 80,20 0,0 0,60;M 0,60 80,60 80,20 0,40 0,60;m 0,60 80,0 0,0 -80,0"
  #              path : "m 0,60 80,0 0,0 -80,0"
  #            parallelogram1 :
  #              open : "M 0,0 0,60 80,60 80,0 z M 80,0 40,30 0,60 40,30 z",
  #              close : ""
  #              path : "M 0,0 0,60 80,60 80,0 Z M 80,0 80,60 0,60 0,0 Z"
  #            parallelogram2 :
  #              open : "M 0,0 80,-10 80,60 0,70 0,0",
  #              close : ""
  #              path : "M 0,70 80,60 80,80 0,80 0,70"
  #            lateral_swipe :
  #              open : "M 40,-65 145,80 -65,80 40,-65",
  #              close : "m 40,-65 0,0 L -65,80 40,-65"
  #              path : "M 40,-65 145,80 40,-65"
  #            wave :
  #              open : "m -5,-5 0,70 90,0 0,-70 z m 5,35 c 0,0 15,20 40,0 25,-20 40,0 40,0 l 0,0 C 80,30 65,10 40,30 15,50 0,30 0,30 z",
  #              close : ""
  #              path : "m -5,-5 0,70 90,0 0,-70 z m 5,5 c 0,0 7.9843788,0 40,0 35,0 40,0 40,0 l 0,60 c 0,0 -3.944487,0 -40,0 -30,0 -40,0 -40,0 z"
  #            origami :
  #              open : "m -10,-10 0,80 100,0 0,-80 z m 50,-30.5 0,70.5 0,70 0,-70 z",
  #              close : ""
  #              path : "m -10,-10 0,80 100,0 0,-80 z M 40,-40.5 120,30 40,100 -40,30 z"
  #            curtain :
  #              open : "m 40,-80 190,0 -305,290 C -100,140 0,0 40,-80 z",
  #              close : ""
  #              path : "m 75,-80 155,0 0,225 C 90,85 100,30 75,-80 z"
  #          }
  #          getSvgLoader : (options)->
  #            new SVGLoader(document.getElementById('loader'),
  #              speedIn : options.speedIn
  #              speedOut : options.speedOut
  #              easingIn : mina[options.easingIn]
  #              easingOut : mina[options.easingOut])
  #          createContent : (options)->
  #            $('body').append(
  #                            """
  #                <div id="loader" class="pageload-overlay" data-opening="#{@getEffects[options.effect].open}" data-closing="#{@getEffects[options.effect].close}">
  #                  <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 80 60" preserveAspectRatio="none">
  #                    <path fill="#{options.bgc}" d="#{@getEffects[options.effect].path}"/>
  #                  </svg>
  #                </div>
  #                <section class='preloader show' style="background-color:##{options.bgc}" id="page">
  #                    <div class='progress'>
  #                      <span id='progress-bar' class="progress-bar"></span>
  #                    </div>
  #                    <h1 class="title-block">TUTMEE представляет...</h1>
  #                    <div class="text-block">
  #                      <span class='wrapper-progress-text'>
  #                    <span id="progress-text">0</span>%
  #                    </span>
  #                    <span class="load-text active">Загружаем</span>
  #                    <span class="change-text active">
  #                      <span class="rw-words rw-words-1"></span>
  #                    </span>
  #                    </div>
  #                </section>
  #              """
  #            )
  #            $('body').addClass('active')
  #          setOptions : (options)->
  #          isUnique : (el,array)->
  #            unless array.length
  #              return true
  #            isFound = 0
  #            array.forEach ((value,index) ->
  #              if value and el is value.src
  #                isFound = 1
  #            )
  #            if isFound
  #              return false
  #            else
  #              return true
  #          sortByAlphabetical : (arr)->
  #            arr.sort()
  #            arr
  #          removeSvgContainerBg : (options)->
  #            $(options.preloaderContainer).css("background-color","")
  #          setAnimateWords : (options)->
  #            words = @sortByAlphabetical(options.words)
  #            words.forEach ((value,index) ->
  #              $('.rw-words').append("<span>#{value}</span>")
  #            )
  #          getManifest : (scopeBlock)->
  #            @manifest.length = 0
  #            that = this
  #            $(scopeBlock).find("*").each(->
  #              unless $(@).css("background-image") is "none"
  #                url = $(@).css("background-image")
  #                url = url.replace(/url\(\"/g,"")
  #                url = url.replace(/url\(/g,"")
  #                url = url.replace(/\"\)/g,"")
  #                url = url.replace(/\)/g,"")
  #              else
  #                url = $(@).attr("src")  if typeof ($(@).attr("src")) isnt "undefined" and $(@).get(0).nodeName.toLowerCase() is "img"
  #              if url and that.isUnique(url,that.manifest)
  #                newSrc = {}
  #                newSrc.src = url
  #                that.manifest.push(newSrc)
  #            )
  #            return @manifest
  #          handleProgress : (event) ->
  #            persent = parseInt(event.loaded * 100)
  #            $('#progress-bar').stop().animate
  #              width : "#{persent}%"
  #            ,
  #              duration : 300
  #              step : (now,fx) ->
  #                $('#progress-text').text(parseInt(now))
  #          handleFileLoad : (event) ->
  #
  #          handleComplete : (loader) ->
  #            that = this
  #            setTimeout(=>
  #              #hideTexts
  #              $('.load-text').removeClass('active')
  #              $('.change-text').removeClass('active')
  #              #      @hideTexts()
  #              $(".load-text").transitionEnd ->
  #                setTimeout(->
  #                  #showTitle
  #                  $('.title-block').addClass('active')
  #                ,100)
  #              $(".title-block").transitionEnd ->
  #                setTimeout(=>
  #                  #scaled
  #                  $('.preloader').addClass('scaled')
  #                  $(".scaled").transitionEnd ->
  #                    loader.hide()
  #                ,100)
  #            ,1200)
  #          hideTexts : ->
  #            $('.load-text').removeClass('active')
  #            $('.change-text').removeClass('active')
  #          initLoadQueue : (manifest)->
  #            preload = new createjs.LoadQueue(true)
  #            preload.on "progress",@handleProgress
  #            preload.on "complete",@handleComplete(@loader)
  #            preload.on "fileload",@handleFileLoad
  #            preload.loadManifest manifest,true
  #        $.fn.preloader = (opts)->
  #          defaults = {}
  #          options = $.extend(defaults,opts or {})
  #          new Preloader(options,this)
  #        $('body').preloader(
  #          words : [
  #            "уникальности"
  #            "привлекательности"
  #            "гармонии"
  #            "качества"
  #            "эффектов"
  #            "роскоши"
  #            "свежести"
  #            "секрета"
  #          ]
  #          preloaderContainer : ".preloader"
  #          sortByAlphabetical : true
  #          bgc : "#fff"
  #          bounce : true
  #          effect : "curtain"
  #          speedIn : 0
  #          speedOut : 600
  #          easingIn : "easeinout"
  #          easingOut : "none"
  #        )
  #  ]
  ###directives.a = [
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
  ]###
  directives.preloader = [
    "$rootScope"
    "$timeout"
    ($rootScope,$timeout) ->
      restrict : "A"
      replace : true
      link : (scope,element)->
        $rootScope.persent = 0
        class IndicatorPageLoading
          manifest : []
          isUnique : (el,array)->
            unless array.length
              return true
            isFound = 0
            array.forEach ((value,index) ->
              if value and el is value.src
                isFound = 1
            )
            if isFound
              return false
            else
              return true
          getManifest : (scopeBlock)->
            @manifest.length = 0
            that = this
            $(scopeBlock).find("*").each(->
              unless $(@).css("background-image") is "none"
                url = $(@).css("background-image")
                url = url.replace(/url\(\"/g,"")
                url = url.replace(/url\(/g,"")
                url = url.replace(/\"\)/g,"")
                url = url.replace(/\)/g,"")
              else
                url = $(@).attr("src")  if typeof ($(@).attr("src")) isnt "undefined" and $(@).get(0).nodeName.toLowerCase() is "img"
              if url and that.isUnique(url,that.manifest) and !url.match('gradient')
                newSrc = {}
                newSrc.src = url
                that.manifest.push(newSrc)
            )
            return @manifest
          handleProgress : (event) ->
            persent = Math.ceil(event.loaded * 100)
            $rootScope.persent = persent
            $rootScope.$apply()
          handleComplete : ->
            dataObj.hidePreloader()
          initLoadQueue : (manifest)->
            preload = new createjs.LoadQueue(true)
            preload.on "progress",@handleProgress
            preload.on "complete",@handleComplete
            preload.loadManifest manifest,true
          hidePreloader : ()->
            @options.el.addClass('hideAnimation')
            $timeout (=>
              @options.el.addClass('hidden')
            ),700
        class Preloader extends IndicatorPageLoading
          constructor : (data)->
            @options = data
            dataObj.el = data.el
            dataObj.timeHide = data.timeHide
            dataObj.hidePreloader = =>
              @hidePreloader()
            @isDOMRendered()
          options : {}
          cashe : {}
          cachedImagesPage : ()->
            result = []
            angular.forEach @getManifest(@options.scopeBlock),(value,key)=>
              unless @cashe[value.src] is value.src
                @cashe[value.src] = value.src
                result.push value
            if result.length
              @initLoadQueue(result)
            else
              $rootScope.persent = 100
              $rootScope.$apply()
              dataObj.hidePreloader()
          isDOMRendered : ->
            scope.$on('$viewContentLoaded',(event) =>
              $rootScope.$broadcast('isDomRender',{
                isDomRender : true
              })
              $timeout (=>
                @cachedImagesPage()
              ),300
            );
            ###scope.$on '$nodesDOMRendered',(e)=>
              $rootScope.$broadcast('isDomRender',{
                isDomRender : true
              })
              $timeout (=>
                @cachedImagesPage()
              ),300###
        dataObj = {}
        preloader = new Preloader(
          el : $(element)
          timeHide : .7
          scopeBlock : 'body'
        )
  ]
  directives.cube = [
    "config"
    "$rootScope"
    "$timeout"
    (config,$rootScope,$timeout) ->
      restrict : "E"
      replace : true,
      scope :
        front : "@"
        text : "@"
        hrefLink : "@"
      templateUrl : "app/templates/cube.html"
      link : (scope,element)->
        scope.config = config
        scope.$applyAsync(()->
          $timeout(->
            if (cssua.ua and cssua.ua.ie <= 11.0)
              CSSPlugin.defaultTransformPerspective = 1000
              TweenMax.set($(element).find('.cont .back'),{
                rotationY : -180
              })
              tl = new TimelineMax({paused : true})
              tl
              .to($(element).find('.cont .front'),1,{rotationY : 180})
              .to($(element).find('.cont .back'),1,{rotationY : 0},0)
              angular.element(element).on "mouseenter touch",->
                tl.play()
              angular.element(element).on "mouseleave touch",->
                tl.reverse()
            else
              TweenMax.to $(element).find('.cont'),0,
                rotationY : "17"
              hoverEffect = TweenMax.to $(element).find('.cont'),0.5,
                rotationY : "90"
              hoverEffect.pause()
              angular.element(element).on "mouseenter touch",->
                hoverEffect.play()
              angular.element(element).on "mouseleave touch",->
                hoverEffect.reverse()
          )
        )
  ]
  directives.scrollUp = [
    "$timeout"
    ($timeout) ->
      restrict : "A"
      link : (scope,element)->
        scope.$watch "scrollClick",(value)->
          if(value)
            $('.wrapper').stop().animate {scrollTop : 0},scope.scrollProperty.duration
  ]
  directives.rotationDragMenu = [
    "$timeout"
    "$window"
    "$rootScope"
    "RDMStorage"
    "svgIconConfig"
    "svgIcon"
    "$location"
    ($timeout,$window,$rootScope,RDMStorage,svgIconConfig,svgIcon,$location)->
      restrict : "E"
      replace : true
      scope :
        menu : "@"
#        absUrl:"@"
      templateUrl : "app/templates/rotation-drag-menu.html"
      link : (scope,element,attrs) ->
        angular.element(document).ready ->
          scope.absUrl = $location.absUrl()
          scope.wh = $(window).height()
          $('.wrapper-rotation-drag-menu').css('top',scope.wh)
          angular.element($window).bind 'resize',->
            scope.wh = $(window).height()
            $('.wrapper-rotation-drag-menu').css('top',scope.wh)
          class DrawRotationDragMenu
            constructor : (data)->
              @options = data
              canvas = Snap(data.canvas)
              arrProperty = [
                {
                  center :
                    x : 175
                    y : 175
                  r : 175
                  x : -130,
                  y : -10
                  number : 0
                  width : 1920
                  height : 1080
                  k : 300
                }
                {
                  center :
                    x : 175
                    y : 175
                  r : 175
                  x : 0,
                  y : 0
                  number : 1
                  width : 1934
                  height : 826
                  k : 185
                }
                {
                  center :
                    x : 175
                    y : 175
                  r : 175
                  x : -40,
                  y : 10
                  number : 2
                  width : 1920
                  height : 1440
                  k : 300
                }
                {
                  center :
                    x : 175
                    y : 175
                  r : 175
                  x : -50,
                  y : -32
                  number : 3
                  width : 1920
                  height : 1200
                  k : 250
                }
                {
                  center :
                    x : 175
                    y : 175
                  r : 175
                  x : -400
                  y : 0
                  number : 4
                  width : 1920
                  height : 412
                  k : 175
                }
                {
                  center :
                    x : 175
                    y : 175
                  r : 175
                  x : -40
                  y : -10
                  number : 5
                  width : 2560
                  height : 1600
                  k : 175
                }
                {
                  center :
                    x : 175
                    y : 175
                  r : 175
                  x : 0
                  y : -15
                  number : 6
                  width : 1960
                  height : 1363
                  k : 300
                }
              ]
              angular.forEach scope.menu,((value,key) ->
                that = this
                that.path[key] = canvas.path(that.arc(
                    arrProperty[key]
                  )
                )
                that.addImageFill(canvas,that.path[key],"app/images/categories_images/#{scope.menu[key].src}",arrProperty[key].x,arrProperty[key].y,arrProperty[key].width,
                  arrProperty[key].height,arrProperty[key].k)
              ),this
            canvas : ''
            options : ''
            path : []
            arc : (property)->
              "M#{property.center.x},#{property.center.y} L#{property.r * Math.cos(property.number * 2 * Math.PI / 7) + property.center.x},#{property.r * Math.sin(property.number * 2 * Math.PI / 7) + property.center.y} A#{property.r},#{property.r} 0 0,1 #{property.r * Math.cos(2 * Math.PI / 7 * (property.number + 1)) + property.center.x},#{property.r * Math.sin(2 * Math.PI / 7 * (property.number + 1)) + property.center.y} z"
            circle : (property) ->
              'm ' + property.cx + ' ' + property.cy + ' m -' + property.r + ', 0 a ' + property.r + ',' + property.r + ' 0 1,0 ' + property.r * 2 + ',0 a ' + property.r + ',' + property.r + ' 0 1,0 -' + property.r * 2 + ',0'
            arrowRight : ->
              'm25,20 L68,40L25,60z'
            arrowLeft : ->
              'm55,20 L12,40 L55,60z'
            rectangle : (property)->
              "m #{property.x},#{property.y} L #{property.x},#{property.width} L #{property.height},#{property.width} L #{property.height},#{property.x} z"
            el : []
            attr : []
            attrHover : []
            time : []
            setAttr : (attr,attrHover,index)->
              @attr[index] = attr
              @attrHover[index] = attrHover
            addImageFill : (canvas,path,imgSrc,x,y,width,height,k)->
              pattern = canvas.image(imgSrc,0,0,k,width * (k / height)).pattern(0,0,k,width * (k / height))
              pattern.attr(
                x : x
                y : y
              )
              $rootScope.$on '$locationChangeSuccess', (event) ->
                scope.absUrl = $location.absUrl()
                console.log('url')
                console.log(scope.absUrl)
                scope.$apply()
                path.attr(
                  "fill","url(#{scope.absUrl}##{pattern.node.id})"
                )
              path.attr(
                "fill","url(#{scope.absUrl}##{pattern.node.id})"
              )
            pathAnimateStart : (path,index)->
              path.animate {'stroke-dashoffset' : 0.1,fill : @attrHover[index].fill,stroke : @attrHover[index]['stroke'],"fill-opacity" : @attrHover[index]['fill-opacity'],'path' : @el[index](@property[index])},@time[index],mina.none
            pathAnimateStop : (path,index)->
              path.animate {'stroke-dashoffset' : @pathLenght(path),fill : @attr[index].fill,"fill-opacity" : @attr[index]['fill-opacity'],stroke : @attr[index]['stroke'],'path' : @el[index](@property[index])},@time[index],mina.none
            pathLenght : (path)->
              path.getTotalLength()
            pathDash : (path)->
              path.attr('stroke-dasharray' : @pathLenght(path) + ' ' + @pathLenght(path),'stroke-dashoffset' : @pathLenght(path))
            events : (canvas,path,index)->
              canvas.mouseover =>
                @pathAnimateStart(path,index)
              canvas.mouseout =>
                @pathAnimateStop(path,index)
          scope.menu = scope.$eval(scope.menu)
          $timeout(->
            scope.$apply()
          )
          new DrawRotationDragMenu(
            canvas : $(element).find('svg').get(0)
          )
          rotationSnap = 90
          containerRDM = $(element).find('#rotation-drag-menu')
          updateNullPosition = ()->
            if @rotation >= 360
              $rootScope.degree = @rotation - 360
            else if @rotation <= -360
              $rootScope.degree = @rotation + 360
            else
              $rootScope.degree = @rotation
          Draggable.create containerRDM,
            type : 'rotation'
            throwProps : true
            onDrag : updateNullPosition
            snap : (endValue) ->
          $rootScope.$watch "degree",(value)->
            if value
              TweenMax.to containerRDM,0.5,
                rotation : -value
          svgIconItem = new svgIcon($('.si-icons-default > .si-icon').get(0),svgIconConfig)
          #анимация вращающегося меня связанная с localStorage(меню помнит последнее нажатия - открытоли ли меню или нет было до перезагрузки и ставляет его таким же)
          complete = ()->
            $(".control").css('visibility','hidden')
          update = ()->
            $(".control").css('visibility','visible')
          tl = new TimelineLite(onComplete : complete,onUpdate : update)
          tl.to "#rotation-drag-menu",.7,
            scale : 0
            ease : Back.easeOut
          .to $(".control.left"),.5,{left : -51,opacity : 0},"-=.7"
          .to $(".control.right"),.5,{left : -51,opacity : 0},"-=.7"
          $rootScope.$watch 'isShowRDM',(newValue,oldValue) ->
            if newValue
              tl.play()
              svgIconItem.options.setToggle(true)
              localStorage.setItem("tlRDM",false)
#              $('.wrapper-rotation-drag-menu').css('overflow','visible')
            else
              tl.reverse()
              svgIconItem.options.setToggle(false)
              localStorage.setItem("tlRDM",true)
              $(".control").css('visibility','hidden')
#              $('.wrapper-rotation-drag-menu').css('overflow','hidden')
  ]
  directives.drawSvg = [
    "$timeout"
    ($timeout)->
      restrict : "E"
      replace : true
      scope :
        width : "@"
        height : "@"
        elements : "@"
      templateUrl : "app/templates/draw-svg.html"
      link : (scope,element,attrs) ->
        angular.element(document).ready ->
          scope.elements = scope.$eval(scope.elements)
          class DrawSvgPath
            constructor : (data)->
              @elements = data.elements
              canvas = Snap(data.canvas)
              path = []
              @elements.forEach (value,index) =>
                @options.push value
                @setAttr(value.attr,value.attrHover,index)
                @el.push @[value.el]
                @time.push value.time
                @property[index] = value.property
                path[index] = canvas.path(@el[index](@property[index]))
                path[index].attr(@attr[index])
                if @attr[index].fill.match(/images/)
                  @addImageFill(canvas,path[index],@attr[index].fill)
                @pathDash(path[index])
                @events(canvas,path[index],index)
            elements : []
            options : []
            circle : (property) ->
              'm ' + property.cx + ' ' + property.cy + ' m -' + property.r + ', 0 a ' + property.r + ',' + property.r + ' 0 1,0 ' + property.r * 2 + ',0 a ' + property.r + ',' + property.r + ' 0 1,0 -' + property.r * 2 + ',0'
            arrowRight : ->
              'm25,20 L68,40L25,60z'
            arrowLeft : ->
              'm55,20 L12,40 L55,60z'
            rectangle : (property)->
              "m #{property.x},#{property.y} L #{property.x},#{property.width} L #{property.height},#{property.width} L #{property.height},#{property.x} z"
            el : []
            attr : []
            attrHover : []
            time : []
            property : []
            setAttr : (attr,attrHover,index)->
              @attr[index] = attr
              @attrHover[index] = attrHover
            addImageFill : (canvas,path,imgSrc)->
              pattern = canvas.image(imgSrc,0,0,80,80).pattern(0,0,80,80)
              path.attr("fill",pattern)
            pathAnimateStart : (path,index)->
              path.animate {'stroke-dashoffset' : 0.1,fill : @attrHover[index].fill,stroke : @attrHover[index]['stroke'],"fill-opacity" : @attrHover[index]['fill-opacity'],'path' : @el[index](@property[index])},@time[index],mina.none
            pathAnimateStop : (path,index)->
              path.animate {'stroke-dashoffset' : @pathLenght(path),fill : @attr[index].fill,"fill-opacity" : @attr[index]['fill-opacity'],stroke : @attr[index]['stroke'],'path' : @el[index](@property[index])},@time[index],mina.none
            pathLenght : (path)->
              path.getTotalLength()
            pathDash : (path)->
              path.attr('stroke-dasharray' : @pathLenght(path) + ' ' + @pathLenght(path),'stroke-dashoffset' : @pathLenght(path))
            events : (canvas,path,index)->
              canvas.mouseover =>
                @pathAnimateStart(path,index)
              canvas.mouseout =>
                @pathAnimateStop(path,index)
          ###
            fill : './images/angularjs.jpg' | "red" | "#f00"
          ###
          new DrawSvgPath(
            canvas : $(element).get(0)
            elements : scope.elements
          )
  ]
  directives.imgFilter = [
    "config"
    "$timeout"
    "$window"
    (config,$timeout,$window) ->
      restrict : "E"
      replace : true
      scope :
        image : "="
      template : """
        <svg version="1.1" baseProfile="tiny" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0" y="0" width="100%" height="{{ww/image.width*image.height}}px" ng-viewBox="0 0 100% {{ww/image.width*image.height}}px" xml:space="preserve"></svg>
      """
      link : (scope,element)->
        angular.element(document).ready ->
          scope.ww = $(window).width()
          angular.element($window).bind 'resize',->
            scope.ww = $(window).width()
          canvas = Snap($(element).get(0))
          f = canvas.filter(Snap.filter.blur(5,5))
          filterChild = f.node.firstChild
          updateBlur = (tween) ->
            filterChild.attributes[0].value = 5 * (1 - tw.progress()) + ',' + 5 * (1 - tw.progress())
          image = canvas.image(scope.image.src,0,0,"100%",scope.ww / scope.image.width * scope.image.height)
          image.attr(
            filter : f
          )
          tw = TweenLite.to(image.node,1,
            onUpdate : updateBlur
            onUpdateParams : ['{self}'])
          tw.pause()
          $(element).parents('li').on 'mouseenter',->
            tw.play()
          $(element).parents('li').on 'mouseleave',->
            tw.reverse()
  ]
  directives.scroll = [
    "config"
    "$timeout"
    "$window"
    (config,$timeout,$window) ->
      restrict : "A"
      link : (scope,element)->
        wh = $($window).height()
        showHideOnScroll = ()->
          if $('.wrapper').scrollTop() > wh
            $('#up').addClass('show')
          else
            $('#up').removeClass('show')
        showHideOnScroll()
        $('.wrapper').on 'scroll',showHideOnScroll
  ]
  directives.chainSlider = [
    "config"
    "$timeout"
    "$rootScope"
    (config,$timeout,$rootScope) ->
      restrict : "A"
      link : (scope,element)->
        class ChainSlider
          constructor : (options)->
            @options = options
            if options.lists.length <= 6
              options.el.find('.controlls-slider').hide()
            @currentGroup = options.lists[(@currentNumber - 1) * 6...(@currentNumber) * 6]
            @currentGroupLength = @currentGroup.length
            TweenMax.to @currentGroup,0,
              left : 0
            @options.el.find('.sub-category').html(@currentGroup)
            @events()
          options : {}
          currentNumber : 1
          currentGroup : []
          currentGroupLength : new Number()
          isCircleEnd : (number,side)->
            if side is 'left' and number is 0
              @currentNumber = Math.ceil(@options.lists.length / 6)
            else if side is 'right' and number is Math.ceil(@options.lists.length / 6) + 1
              @currentNumber = 1
            console.log(@currentNumber)
          groupLeftMove : (leftFrom,leftTo)->
            @currentGroup = @options.lists[(@currentNumber - 1) * 6...(@currentNumber) * 6]
            TweenMax.to @currentGroup,0,
              left : leftFrom
            @options.el.find('.sub-category').html(@currentGroup)
            @currentGroup.each (index,value) =>
              TweenMax.to value,@options.time,
                left : leftTo
                delay : index * @options.time / @currentGroupLength
          groupRightMove : (rightFrom,rightTo)->
            @currentGroup = @options.lists[(@currentNumber - 1) * 6...(@currentNumber) * 6]
            TweenMax.to @currentGroup,0,
              left : rightFrom
            @options.el.find('.sub-category').html(@currentGroup)
            @currentGroup.each (index,value) =>
              TweenMax.to value,@options.time,
                left : rightTo
                delay : (@options.time - index * @options.time / @currentGroupLength)
          disableSwitchSlider : (el)->
            el.parents('.controlls-slider').find('a').removeClass('switch-slider')
          enableSwitchSlider : (el)->
            el.parents('.controlls-slider').find('a').addClass('switch-slider')
          events : ->
            $(element).on "click",".controlls-slider .switch-slider",(e)=>
              e.preventDefault()
              ect = $(e.currentTarget)
              @disableSwitchSlider(ect)
              if(ect.hasClass('left'))
                @groupRightMove(0,2000)
                $timeout (=>
                  @currentNumber--
                  @isCircleEnd(@currentNumber,'left')
                  @groupRightMove(-2000,0)
                ),@options.time * 1000 + 100
              else
                @groupLeftMove(0,-2000)
                $timeout (=>
                  @currentNumber++
                  @isCircleEnd(@currentNumber,'right')
                  @groupLeftMove(2000,0)
                ),@options.time * 1000 + 100
              $timeout (=>
                @enableSwitchSlider(ect)
              ),(@options.time * 1000 + 100) * 3
          scope.$applyAsync(()->
            options =
              el : $(element)
              lists : $(element).find('.sub-category>li')
              time : 1.2
            tl = new TimelineLite()
            new ChainSlider(options)
          )
#        scope.$on '$nodesDOMRendered',(e)=>
#          console.log('render')
#          options =
#            el : $(element)
#            lists : $(element).find('.sub-category>li')
#            time : 1.2
#          tl = new TimelineLite()
#          new ChainSlider(options)
  ]
  directives.showCube = [
    "config"
    "$timeout"
    (config,$timeout) ->
      restrict : "A"
      link : (scope,element)->
        $timeout(->
          #Появление подкатегорий главной страницы
          tl = new TimelineLite();
          choiseGroupShowed = $(element).find('.sub-category>li')
          hoverEffect = tl.staggerFrom(choiseGroupShowed,0.5,{scale : 0,rotation : -360,autoAlpha : 0},0.2,"stagger")
          hoverEffect.pause()
          showArrowLeft = TweenLite.from $(element).find('.switch-slider.left'),.8,
            left : "-500px"
            ease : Back.easeOut
          showArrowRight = TweenLite.from $(element).find('.switch-slider.right'),.8,
            right : "-500px"
            ease : Back.easeOut
          showArrowLeft.pause()
          showArrowRight.pause()
          angular.element(element).on "mouseenter",->
            hoverEffect.play()
            showArrowLeft.play()
            showArrowRight.play()
          angular.element(element).on "mouseleave",->
            hoverEffect.reverse()
            showArrowLeft.reverse()
            showArrowRight.reverse()
        ,0)
  ]
  directives.request = [
    "config"
    (config) ->
      restrict : "E"
      templateUrl : "#{config.frontendTemplatesPath}/request.html"
  ]
  #Директива thank - Спасибо за проявленный интерес
  directives.thank = [
    "config"
    (config) ->
      restrict : "E"
      templateUrl : "#{config.frontendTemplatesPath}/thank.html"
  ]
  directives.onlyIntNumbersPlus = () ->
    link : (scope,element,attrs) ->
      $(element).keydown (event) ->
        if event.keyCode is 107 or event.keyCode is 46 or event.keyCode is 8 or event.keyCode is 9 or event.keyCode is 27 or (event.keyCode is 65 and event.ctrlKey is true) or (event.keyCode >= 35 and event.keyCode <= 39)
          # Ничего не делаем
          return
        else
          # Обеждаемся, что это цифра, и останавливаем событие keypress
          event.preventDefault()  if (event.keyCode < 48 or event.keyCode > 57) and (event.keyCode < 96 or event.keyCode > 105) and !(event.keyCode is 61 and event.shiftKey is true)
        return
  directives.isValideBorder = () ->
    restrict : "A"
    scope :
      isValideBorder : "@"
      borderStyle : "@"
    link : (scope,element)->
      scope.$watch("formIsValide",(value)->
        unless(value)
          $(element).parents('form').find('input').removeAttr('style','').removeClass('ng-dirty').addClass('ng-pristine')
          $(element).parents('form').removeClass('ng-dirty').addClass('ng-pristine')
        element.bind 'submit',->
          if scope.isValideBorder
            $(element).find('.ng-pristine.ng-invalid').css('border','1px solid #f00')
      )
      scope.$watch "borderStyle",(value)->
        if(value)
          $('.wrapper-input input').removeAttr('style')
  directives.getParentHeight = [
    "$rootScope"
    "$timeout"
    "$window"
    ($rootScope,$timeout,$window) ->
      restrict : "A"
      link : (scope,element)->
        $timeout(->
          getHeight = ()->
            height = $(document).outerHeight()
            headerHeight = $('.header-block').outerHeight()
            asideHeight = 0
            $('.aside>*').each(->
              asideHeight += $(@).outerHeight()
            )
            maintHeight = 0
            $('.wrapper-content>*').each(->
              maintHeight += $(@).outerHeight()
            )
            if(asideHeight >= maintHeight)
              heightContent = asideHeight
            else
              heightContent = maintHeight
            if heightContent < (height - headerHeight)
              $('.aside').height(height - headerHeight)
            else
              $('.aside').removeAttr('style')
          getHeight()
          angular.element($window).bind 'resize',->
            getHeight()
        ,500)
  ]
  directives.change = () ->
    restrict : "A"
    link : (scope,element)->
      $(document).on "click",".saw-catalogs",(e)->
        e.preventDefault()
        changecategory = $(@).data('changecategory')
        $('.list-catalogs>li').eq(changecategory).trigger('click')
        $('html, body').animate({
          scrollTop : $(".catalogs").offset().top - 66
        },700);
  directives.bxslider = [
    "$timeout"
    "$compile"
    "Article"
    ($timeout,$compile,Article) ->
      restrict : "E"
      scope : {
        options : "@"
        categoryId : "@"
      }
      replace : true
      templateUrl : "app/templates/bxslider-tmpl.html"
      link : (scope,element,attr) ->
        slider = ''
        scope.getCountSlides = ->
          widthSlider = $('.header').width() - $('.wrapper-logo').width() - 100
          countSlides = parseInt(widthSlider / 260)
          return countSlides
        svgLeft = """
              <draw-svg width="80" height="80"
                          elements="[{attr: {fill: 'none','fill-opacity':0,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: '#ff5a00','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'circle',property: {cx: 40,cy: 40,r: 38},time: 800}, {attr: {fill: '#ff5a00','fill-opacity': .7,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: 'green','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'arrowLeft',time: 800}]"></draw-svg>
              """
        svgRight = """
              <draw-svg width="80" height="80"
									  elements="[{attr: {fill: 'none','fill-opacity':0,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: '#ff5a00','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'circle',property: {cx: 40,cy: 40,r: 38},time: 800}, {attr: {fill: '#ff5a00','fill-opacity': .7,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: 'green','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'arrowRight',time: 800}]"></draw-svg>
              """
        Article.find({
            filter : {
              where : {
                categoryId : scope.categoryId
              },
              limit : 10
              include : {
                relation : 'articleImage'
              }
            }
          }
        ,
          (arr) ->
            scope.dataSlider = arr
            $timeout (->
              scope.options = scope.$eval(scope.options)
              scope.options.maxSlides = scope.getCountSlides()
              scope.options.pagerCustom = '.bx-pager'
              slider = $(element).bxSlider(scope.options)
              $timeout (->
                $('.header .bx-prev').html($compile(svgLeft)(scope))
                $('.header .bx-next').html($compile(svgRight)(scope))
                $(element).parents('.also-articles-slider').addClass('loaded')
              ),50
            ),0
          (err) ->
            console.log(err))
        $(window).resize ->
          scope.options.maxSlides = scope.getCountSlides()
          slider.reloadSlider()
          $timeout (->
            $('.header .bx-prev').html($compile(svgLeft)(scope))
            $('.header .bx-next').html($compile(svgRight)(scope))
          ),50
  ]
  directives.popularSlider = [
    "$timeout"
    "$compile"
    "Article"
    ($timeout,$compile,Article) ->
      restrict : "E"
      scope : {
        options : "@"
        categoryId : "@"
      }
      replace : true
      templateUrl : "app/templates/bxslider-tmpl.html"
      link : (scope,element,attr) ->
        slider = ''
        scope.getCountSlides = ->
          widthSlider = $('.header').width() - $('.wrapper-logo').width() - 100
          countSlides = parseInt(widthSlider / 260)
          return countSlides
        svgLeft = """
              <draw-svg width="80" height="80"
                          elements="[{attr: {fill: 'none','fill-opacity':0,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: '#ff5a00','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'circle',property: {cx: 40,cy: 40,r: 38},time: 800}, {attr: {fill: '#ff5a00','fill-opacity': .7,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: 'green','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'arrowLeft',time: 800}]"></draw-svg>
              """
        svgRight = """
              <draw-svg width="80" height="80"
									  elements="[{attr: {fill: 'none','fill-opacity':0,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: '#ff5a00','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'circle',property: {cx: 40,cy: 40,r: 38},time: 800}, {attr: {fill: '#ff5a00','fill-opacity': .7,stroke: '#ff5a00','stroke-opacity': 1,strokeWidth: 2},attrHover: {fill: 'green','fill-opacity': 0.7,stroke: '#fff','stroke-opacity': 1,strokeWidth: 2},el: 'arrowRight',time: 800}]"></draw-svg>
              """
        Article.find({
            filter : {
              where : {
                categoryId : scope.categoryId
              },
              limit : 10
              include : {
                relation : 'articleImage'
              }
            }
          }
        ,
          (arr) ->
            scope.dataSlider = arr
            $timeout (->
              scope.options = scope.$eval(scope.options)
              scope.options.maxSlides = scope.getCountSlides()
              scope.options.pagerCustom = '.bx-pager'
              slider = $(element).bxSlider(scope.options)
              $timeout (->
                $('.popular .bx-prev').html($compile(svgLeft)(scope))
                $('.popular .bx-next').html($compile(svgRight)(scope))
                $(element).parents('.popular').addClass('loaded')
              ),50
            ),0
          (err) ->
            console.log(err))
        $(window).resize ->
          scope.options.maxSlides = scope.getCountSlides()
          slider.reloadSlider()
          $timeout (->
            $('.header .bx-prev').html($compile(svgLeft)(scope))
            $('.header .bx-next').html($compile(svgRight)(scope))
          ),50
  ]
  #
  #  directives.photobox = () ->
  #    restrict : "A"
  #    link : (scope,element,attrs)->
  #      $(element).photobox('a')
  directives.angularPreloader = [
    "$window"
    "$rootScope"
    "$timeout"
    "config"
    ($window,$rootScope,$timeout,config) ->
      restrict : "E"
#      replace: true
      templateUrl : "#{config.frontendTemplatesPath}/angular-preloader.html"
      link : (scope,element,attr) ->
        GSPreloader = (options) ->
          options = options or {}
          parent = options.parent or document.body
          parent = options.parent or document.body
          parent = options.parent or document.body
          element = @element = document.createElement("div")
          radius = options.radius or 42
          dotSize = options.dotSize or 15
          animationOffset = options.animationOffset or 1.8 #jumps to a more active part of the animation initially (just looks cooler especially when the preloader isn't displayed for very long)
          createDot = (rotation) ->
            dot = document.createElement("div")
            element.appendChild dot
            TweenMax.set dot,
              width : dotSize
              height : dotSize
              transformOrigin : (-radius + "px 0px")
              x : radius
              backgroundColor : colors[colors.length - 1]
              borderRadius : "50%"
              force3D : true
              position : "absolute"
              rotation : rotation

            dot.className = options.dotClass or "preloader-dot"
            dot
          i = options.dotCount or 10
          rotationIncrement = 360 / i
          colors = options.colors or [
              "#61AC27"
              "black"
            ]
          animation = new TimelineLite(paused : true)
          dots = []
          isActive = false
          box = document.createElement("div")
          tl = undefined
          dot = undefined
          closingAnimation = undefined
          j = undefined
          colors.push colors.shift()
          #setup background box
          TweenMax.set box,
            width : radius * 2 + 70
            height : radius * 2 + 70
            borderRadius : "50%"
            backgroundColor : options.boxColor or "white"
            border : options.boxBorder or "1px solid #AAA"
            position : "absolute"
            x : "-#{(radius * 2 + 70) / 2}"
            y : "-#{(radius * 2 + 70) / 2}"
            opacity : ((if (options.boxOpacity?) then options.boxOpacity else 0.3))
          box.className = options.boxClass or "preloader-box"
          element.appendChild box
          parent.appendChild element
          TweenMax.set element,
            position : "fixed"
            top : "45%"
            left : "50%"
            perspective : 600
            overflow : "visible"
            zIndex : 2000
          animation.from box,0.1,
            opacity : 0
            scale : 0.1
            ease : Power1.easeOut
          ,animationOffset
          while --i > -1
            dot = createDot(i * rotationIncrement)
            dots.unshift dot
            animation.from dot,0.1,
              scale : 0.01
              opacity : 0
              ease : Power1.easeOut
            ,animationOffset
            #tuck the repeating parts of the animation into a nested TimelineMax (the intro shouldn't be repeated)
            tl = new TimelineMax(
              repeat : -1
              repeatDelay : 0.25
            )
            j = 0
            while j < colors.length
              tl.to(dot,2.5,
                rotation : "-=360"
                ease : Power2.easeInOut
              ,j * 2.9).to dot,1.2,
                skewX : "+=360"
                backgroundColor : colors[j]
                ease : Power2.easeInOut
              ,1.6 + 2.9 * j
              j++
            #stagger its placement into the master timeline
            animation.add tl,i * 0.07
          TweenMax.render()  if TweenMax.render #trigger the from() tweens' lazy-rendering (otherwise it'd take one tick to render everything in the beginning state, thus things may flash on the screen for a moment initially). There are other ways around this, but TweenMax.render() is probably the simplest in this case.
          #call preloader.active(true) to open the preloader, preloader.active(false) to close it, or preloader.active() to get the current state.
          @active = (show) ->
            return isActive  unless arguments.length
            unless isActive is show
              isActive = show
              closingAnimation.kill()  if closingAnimation #in case the preloader is made active/inactive/active/inactive really fast and there's still a closing animation running, kill it.
              if isActive
                element.style.visibility = "visible"
                TweenMax.set [
                    element
                    box
                  ],
                  rotation : 0

                animation.play animationOffset
              else
                closingAnimation = new TimelineLite()
                if animation.time() < animationOffset + 0.3
                  animation.pause()
                  closingAnimation.to(element,1,
                    rotation : -360
                    ease : Power1.easeInOut
                  ).to box,1,
                    rotation : 360
                    ease : Power1.easeInOut
                  ,0
                closingAnimation.staggerTo(dots,0.3,
                  scale : 0.01
                  opacity : 0
                  ease : Power1.easeIn
                  overwrite : false
                ,0.05,0).to(box,0.4,
                  opacity : 0
                  scale : 0.2
                  ease : Power2.easeIn
                  overwrite : false
                ,0).call(->
                  animation.pause()
                  closingAnimation = null
                  return
                ).set element,
                  visibility : "hidden"
            this
          return
        preloader = new GSPreloader(
          radius : 42
          dotSize : 15
          dotCount : 10
          colors : [
            "red"
            "#555"
            "gold"
            "#FF6600"
          ]
          boxOpacity : 0.2
          boxBorder : "1px solid #AAA"
          animationOffset : 1.8
        )
        preloader.active false
        $rootScope.$watch "page",(value)->
          if(value)
            preloader.active true
            dNtoLoad = $('#dNtoLoad')
            if dNtoLoad.hasClass('first-load')
              dNtoLoad.removeClass('first-load')
            else
              dNtoLoad.addClass('dNtoLoad')
            $timeout(->
              preloader.active false
            ,500)
            $timeout(->
              dNtoLoad.removeClass('dNtoLoad')
            ,1200)
        ,true
  ]
  directives.eraser = [
    "$timeout"
    ($timeout) ->
      restrict : "A"
      link : (scope,element,attr)->
        $(element).eraser();
#        $(element).eraser( {
#          completeRatio: .5,
#          completeFunction: showResetButton
#        });
  ]
  directives.perfectScrollbar = [
    "$timeout"
    ($timeout) ->
      restrict : "A"
      link : (scope,element,attr)->
        $timeout(->
          $(element).perfectScrollbar(
            maxScrollbarLength : 200
            useKeyboard : true
            useBothWheelAxes : true
          )
        ,0)
  ]
  directives.filters = [
    "$timeout"
    "$interval"
    ($timeout,$interval) ->
      restrict : "A"
      scope :
        filters : "@",
        blurRadius : "@"
      link : (scope,element,attr)->
        BLUR_RADIUS = scope.blurRadius
        canvas = $(element).find('canvas').attr({width : $(window).width(),height : $(window).height()}).get(0)
        canvasContext = canvas.getContext("2d")
        image = new Image()
        image.src = scope.filters
        drawBlur = (borderRadius)->
          w = 1920
          h = 1080
          canvasContext.drawImage image,0,0,w,h
          stackBlurCanvasRGBA $(element).find('canvas').get(0).id,0,0,w,h,borderRadius
        image.onload = ->
          drawBlur(BLUR_RADIUS)
        #        loadImg = (i) ->
        #          $timeout(->
        #            loadImg i + 1 #загрузка следующего изображения
        #          ,50)
        #        loadImg 0
        angular.element(element).on "mouseenter",->
          $interval((i)->
            drawBlur(5 - i)
          ,10,5)
        #          drawBlur(0)
        angular.element(element).on "mouseleave",->
          drawBlur(BLUR_RADIUS)
  ]
  directives.addHeight = [
    "$timeout"
    "$window"
    ($timeout,$window) ->
      restrict : "A"
      link : (scope,element,attr)->
        $timeout(()->
          wh=$($window).height()
          $(element).height(wh - 280)
        ,0)
        $(window).resize ()->
          wh = $($window).height()
          $(element).height(wh - 280)
  ]
  directive.directive(directives)
  directive
