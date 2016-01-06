define ["angular","angularResource"],(angular) ->
  "use strict"
  # Services
  services = angular.module("App.services",["ngResource"])
  #Получение данных из json-файла
  #  services.factory "dataService",[
  #    "$resource"
  #    ($resource) ->
  #      $resource("app/json/:jsonName",{},
  #        query :
  #          method : "GET"
  #          isArray : true
  #        charge :
  #          method : 'POST'
  #          params : {charge : true}
  #      )
  #  ]
  services.constant(
    "config",{
      base : "http://#{window.location.host}"
      adminTemplatesPath : '/bundles/siteproject/admin/templates'
      adminImgPath : '/bundles/siteproject/admin/images'
      frontendTemplatesPath : '/bundles/siteproject/frontend/templates'
      frontendImgPath : '/bundles/siteproject/frontend/images'
    })
  #Получение списка Меню категорий(nav-categories)
  services.factory "dataService",[
    "$resource"
    ($resource) ->
      $resource("linecategories/:namePage",{},
        query :
          method : "GET"
          isArray : true
        charge :
          method : 'POST'
        #          params : {charge : true}
      )
  ]
  services.service 'RDMStorage',[
    "$q"
    ($q)->
      RDM = {}
      deferred = $q.defer()
      return {
      #    setIsShowRDM : (bool)->
      #      RDM.isShowRDM = bool
      setRDM : (property,value)->
        RDM[property] = value
        deferred.notify(RDM);
      getRDM : ->
        RDM
      observeRDM : ->
        deferred.resolve(RDM)
        deferred.promise;
      }
  ]
  services.service 'svgIconConfig',->
    return {
    clock :
      url : 'svg/clock.svg'
      animation : [
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "r0 32 32"}'
            to :
              val : '{"transform" : "r630 32 32"}'
        }
        {
          el : 'path:nth-child(3)'
          animProperties :
            from :
              val : '{"transform" : "r0 32 32"}'
            to :
              val : '{"transform" : "r80 32 32"}'
        }
      ]
    trash :
      url : 'svg/trash.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "t0 0"}'
            to :
              val : '{"transform" : "t0 -8"}'
        }
      ]
    contract :
      url : 'svg/contract.svg'
      animation : [
        {
          el : 'rect:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "t0 0"}'
              after : '{ "opacity" : 0 }'
            to :
              val : '{"transform" : "t-5 -5"}'
              before : '{ "opacity" : 1 }'
        }
        {
          el : 'rect:nth-child(3)'
          animProperties :
            from :
              val : '{"transform" : "t0 0"}'
              after : '{ "opacity" : 0 }'
            to :
              val : '{"transform" : "t-10 -10"}'
              before : '{ "opacity" : 1 }'
        }
      ]
    maximize :
      url : 'app/svg/maximize.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "t0 0"}'
            to :
              val : '{"transform" : "t-5 -5"}'
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "t0 0"}'
            to :
              val : '{"transform" : "t5 -5"}'
        }
        {
          el : 'path:nth-child(3)'
          animProperties :
            from :
              val : '{"transform" : "t0 0"}'
            to :
              val : '{"transform" : "t-5 5"}'
        }
        {
          el : 'path:nth-child(4)'
          animProperties :
            from :
              val : '{"transform" : "t0 0"}'
            to :
              val : '{"transform" : "t5 5"}'
        }
      ]
    maximizeRotate :
      url : 'app/svg/maximize.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "r0 16 16 t0 0"}'
            to :
              val : '{"transform" : "r180 16 16 t-5 -5"}'
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "r0 48 16 t0 0"}'
            to :
              val : '{"transform" : "r-180 48 16 t5 -5"}'
        }
        {
          el : 'path:nth-child(3)'
          animProperties :
            from :
              val : '{"transform" : "r0 16 48 t0 0"}'
            to :
              val : '{"transform" : "r-180 16 48 t-5 5"}'
        }
        {
          el : 'path:nth-child(4)'
          animProperties :
            from :
              val : '{"transform" : "r0 48 48 t0 0"}'
            to :
              val : '{"transform" : "r180 48 48 t5 5"}'
        }
      ]
    volume :
      url : 'svg/volume.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "t-10 0 s0 32 32"}'
            to :
              val : '{"transform" : "t0 0 s1 32 32", "opacity" : 1}'
              before : '{"transform" : "t-10 0 s0 32 32"}'
              delayFactor : .5
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "t-10 0 s0 32 32"}'
              delayFactor : .25
            to :
              val : '{"transform" : "t0 0 s1 32 32", "opacity" : 1}'
              before : '{"transform" : "t-10 0 s0 32 32"}'
              delayFactor : .25
        }
        {
          el : 'path:nth-child(3)'
          animProperties :
            from :
              val : '{"transform" : "t-10 0 s0 32 32"}'
              delayFactor : .5
            to :
              val : '{"transform" : "t0 0 s1 32 32", "opacity" : 1}'
              before : '{"transform" : "t-10 0 s0 32 32"}'
        }
      ]
    plus :
      url : 'svg/plus.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "r0 32 32", "opacity" : 1}'
            to :
              val : '{"transform" : "r180 32 32", "opacity" : 0}'
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "r0 32 32"}'
            to :
              val : '{"transform" : "r180 32 32"}'
        }
      ]
    plusCross :
      url : 'svg/plus.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "r0 32 32"}'
            to :
              val : '{"transform" : "r45 32 32"}'
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "r0 32 32"}'
            to :
              val : '{"transform" : "r45 32 32"}'
        }
      ]
    hamburger :
      url : 'svg/hamburger.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"path" : "m 5.0916789,20.818994 53.8166421,0"}'
            to :
              val : '{"path" : "m 5.091679,9.771104 53.816642,0"}'
        }
        {
          el : 'path:nth-child(3)'
          animProperties :
            from :
              val : '{"path" : "m 5.0916788,42.95698 53.8166422,0"}'
            to :
              val : '{"path" : "m 5.0916789,54.00487 53.8166421,0"}'
        }
      ]
    hamburgerCross :
      url : 'svg/hamburger.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"path" : "m 5.0916789,20.818994 53.8166421,0"}'
            to :
              val : '{"path" : "M 12.972944,50.936147 51.027056,12.882035"}'
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "s1 1", "opacity" : 1}'
              before : '{"transform" : "s0 0"}'
            to :
              val : '{"opacity" : 0}'
        }
        {
          el : 'path:nth-child(3)'
          animProperties :
            from :
              val : '{"path" : "m 5.0916788,42.95698 53.8166422,0"}'
            to :
              val : '{"path" : "M 12.972944,12.882035 51.027056,50.936147"}'
        }
      ]
    navLeftArrow :
      url : 'svg/nav-left-arrow.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "M 48.592939,9.792208 15.407062,31.887987 48.592939,54.025974"}'
            to :
              val : '{"path" : "M 15.407062,9.792208 48.592939,31.887987 15.407062,54.025974"}'
        }
      ]
    navUpArrow :
      url : 'svg/nav-up-arrow.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "M 9.8831175,48.502029 31.978896,15.316152 54.116883,48.502029"}'
            to :
              val : '{"path" : "M 9.8831175,15.316152 31.978896,48.502029 54.116883,15.316152"}'
        }
      ]
    rightArrow :
      url : 'svg/right-arrow.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "M 34.419061,13.24425 57.580939,32.017897 34.419061,50.75575"}'
            to :
              val : '{"path" : "M 31.580939,13.24425 8.419061,32.017897 31.580939,50.75575"}'
        }
      ]
    downArrow :
      url : 'svg/down-arrow.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "M 14.083963,33.258774 32.85761,56.420652 51.595463,33.258774"}'
            to :
              val : '{"path" : "M 14.083963,30.420652 32.85761,7.258774 51.595463,30.420652"}'
        }
      ]
    smiley :
      url : 'svg/smiley.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "m 19.380224,39.901132 c 0,0 4.860771,5.28501 12.770151,5.28501 7.909379,0 12.770152,-5.28501 12.770152,-5.28501"}'
            to :
              val : '{"path" : "m 19.380224,45.186142 c 0,0 4.860771,-5.28501 12.770151,-5.28501 7.909379,0 12.770152,5.28501 12.770152,5.28501"}'
        }
      ]
    play :
      url : 'svg/play.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "M 18.741071,52 31.30178,42.531655 45.258928,31.887987 18.741071,12 z"}'
            to :
              val : '{"path" : "m 12.5,52 39,0 0,-40 -39,0 z"}'
        }
      ]
    mail :
      url : 'svg/mail.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "m 61.693118,24.434001 -59.386236,0 29.692524,19.897984 z"}'
            to :
              val : '{"path" : "m 61.693118,24.434001 -59.386236,0 29.692524,-19.7269617 z"}'
        }
      ]
    equalizer :
      url : 'svg/equalizer.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "t 0 0"}'
            to :
              val : '{"transform" : "t 0 -30"}'
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "t 0 0"}'
            to :
              val : '{"transform" : "t 0 35"}'
        }
        {
          el : 'path:nth-child(3)'
          animProperties :
            from :
              val : '{"transform" : "t 0 0"}'
            to :
              val : '{"transform" : "t 0 -10"}'
        }
      ]
    glass :
      url : 'svg/glass.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "m 16.778805,44 c 0,0 9.518312,-3.481153 13.221195,-2 10,4 17.153596,2 17.153596,2 L 45,54 20,54 z"}'
            to :
              val : '{"path" : "M 13.183347,29 C 13.183347,29 25,31.439358 30,29 c 12.710171,-6.200932 20,0 20,0 l -5,25 -25,0 z"}'
        }
      ]
    hourglass :
      url : 'svg/hourglass.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "r 0 32 32"}'
            to :
              val : '{"transform" : "r 180 32 32"}'
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "r 0 32 32"}'
              animAfter : '{"path" : "m 31,32 2,0 0,0 9,15 -20,0 9,-15 z"}'
            to :
              val : '{"transform" : "r 180 32 32"}'
              animAfter : '{"path" : "m 22,17 20,0 -9,15 0,0 -2,0 0,0 z"}'
        }
      ]
    padlock :
      url : 'svg/padlock.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"transform" : "t 0 0"}'
            to :
              val : '{"transform" : "t 0 -11"}'
        }
      ]
    zoom :
      url : 'svg/zoom.svg'
      animation : [
        {
          el : 'path:nth-child(1)'
          animProperties :
            from :
              val : '{"transform" : "s 1 1"}'
            to :
              val : '{"transform" : "s 1.1 1.1"}'
        }
        {
          el : 'path:nth-child(2)'
          animProperties :
            from :
              val : '{"transform" : "s 1 1", "stroke-width" : "1"}'
            to :
              val : '{"transform" : "s 2 2", "stroke-width" : "2"}'
        }
      ]
    monitor :
      url : 'svg/monitor.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "m 5,11.75 0,33.75 20.25,0 -6.75,6.75 27,0 -6.75,-6.75 20.25,0 0,-33.75 -54,0 z m 2.65625,2.875 48.6875,0 0,27.8125 -48.6875,0 0,-27.8125 z"}'
            to :
              val : '{"path" : "m 21.875,16.8125 0,30.375 3.375,0 3.5,0 3.25,0 6.75,0 3.375,0 0,-30.375 -20.25,0 z m 3.375,3.375 13.5,0 0,20.25 -13.5,0 0,-20.25 z m 6.75,22.25 c 0.756641,0 1.375,0.618359 1.375,1.375 0,0.756641 -0.618359,1.375 -1.375,1.375 -0.756641,0 -1.375,-0.618359 -1.375,-1.375 0,-0.756641 0.618359,-1.375 1.375,-1.375 z"}'
        }
      ]
    flag :
      url : 'svg/flag.svg'
      animation : [
        {
          el : 'path'
          animProperties :
            from :
              val : '{"path" : "m 11.75,11.75 c 0,0 10.229631,3.237883 20.25,0 10.020369,-3.2378833 20.25,0 20.25,0 l 0,27 c 0,0 -6.573223,-3.833185 -16.007359,0 -9.434136,3.833185 -24.492641,0 -24.492641,0 z"}'
            to :
              val : '{"path" : "m 11.75,11.75 c 0,0 8.373476,-4.8054563 17.686738,0 9.313262,4.805456 22.813262,0 22.813262,0 l 0,27 c 0,0 -11.699747,4.363515 -22.724874,0 C 18.5,34.386485 11.75,38.75 11.75,38.75 z"}'
        }
      ]
    }
  #Получение списка Меню категорий(nav-categories)
  services.factory "svgIcon",[
    () ->
      classReg = (className) ->
        new RegExp('(^|\\s+)' + className + '(\\s+|$)')

      hasClass = (el,c) ->
        if 'classList' in document.documentElement then el.classList.contains(c) else classReg(c).test(el.className)

      extend = (a,b) ->
        for key of b
          if b.hasOwnProperty(key)
            a[key] = b[key]
        a
      mobilecheck = ->
        check = false
        ((a) ->
          if /(android|ipad|playbook|silk|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a) or /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,
            4))
            check = true
          return) navigator.userAgent or navigator.vendor or window.opera
        check
      isMouseLeaveOrEnter = (e,handler) ->
        if e.type != 'mouseout' and e.type != 'mouseover'
          return false
        reltg = if e.relatedTarget then e.relatedTarget else if e.type == 'mouseout' then e.toElement else e.fromElement
        while reltg and reltg != handler
          reltg = reltg.parentNode
        reltg != handler
      ###** svgIcon **###
      svgIcon = (el,config,options) ->
        @el = el
        @options = extend({},@options)
        extend @options,options
        @svg = Snap(@options.size.w,@options.size.h)
        @svg.attr 'viewBox','0 0 128 128'
        @el.appendChild @svg.node
        # state
        @toggled = false
        # click event (if mobile use touchstart)
        @clickevent = if mobilecheck() then 'touchstart' else 'click'
        # icons configuration
        @config = config[@el.getAttribute('data-icon-name')]
        # reverse?
        if hasClass(@el,'si-icon-reverse')
          @reverse = true
        if !@config
          return
        self = this
        # load external svg
        Snap.load @config.url,(f) ->
          g = f.select('g')
          self.svg.append g
          self.options.onLoad()
          self._initEvents()
          if self.options.condition
            if self.reverse
              self.toggle()
          else
            unless self.reverse
              self.toggle()
      #          if self.reverse
      #            self.toggle()
      svgIcon::options =
        speed : 200
        easing : mina.linear
        evtoggle : 'click'
        size :
          w : 64
          h : 64
        condition : false
        setToggle : (condition)->
          @condition = condition
        onLoad : ->
          false
        onToggle : ->
          false
      svgIcon::_initEvents = ->
        self = this
        toggleFn = (ev) ->
          if (ev.type.toLowerCase() == 'mouseover' or ev.type.toLowerCase() == 'mouseout') and isMouseLeaveOrEnter(ev,
            this) or ev.type.toLowerCase() == self.clickevent
            self.toggle true
            self.options.onToggle()
        if @options.evtoggle == 'mouseover'
          @el.addEventListener 'mouseover',toggleFn
          @el.addEventListener 'mouseout',toggleFn
        else
          @el.addEventListener @clickevent,toggleFn
        return
      svgIcon::toggle = (motion) ->
        if !@config.animation
          return
        self = this
        i = 0
        len = @config.animation.length
        while i < len
          a = @config.animation[i]
          el = @svg.select(a.el)
          animProp = if @toggled then a.animProperties.from else a.animProperties.to
          val = animProp.val
          timeout = if motion and animProp.delayFactor then animProp.delayFactor else 0
          if animProp.before
            el.attr JSON.parse(animProp.before)
          if motion
            setTimeout do (el,val,animProp) ->
                ->
                  el.animate JSON.parse(val),self.options.speed,self.options.easing,->
                    if animProp.after
                      @attr JSON.parse(animProp.after)
                    if animProp.animAfter
                      @animate JSON.parse(animProp.animAfter),self.options.speed,self.options.easing
                    return
                  return
            ,timeout * self.options.speed
          else
            el.attr(JSON.parse(val))
          ++i
        @toggled = !@toggled
      svgIcon
  ]
  #Получение списка Меню категорий(nav-categories)
  services.factory "Article",[
    "$http"
    "$q"
    ($http,$q) ->
      #Сохраняем адресс API
      apiUrl = "http://#{window.location.host}"
      # Объявляем класс модели данных
      ArticleModel = (data) ->
        @setData data  if data
      # Добавляем prototype методы каждому объекту
      ArticleModel::setData = (data) ->
        angular.extend this,data
      ArticleModel::update = ->
        # Как-нибудь обрабатываем успешный запрос
        $http.put(apiUrl + "/articles/" + @_id,this).success(->
        ).error (data,status,headers,config) ->
          # Что-нибудь делаем в случае ошибки
      ArticleModel::create = ->
        # Как-нибудь обрабатываем успешный запрос
        $http.post(apiUrl + "/articles/",this).success((r) ->
        ).error (data,status,headers,config) ->
          # Что-нибудь делаем в случае ошибки
          # Объявляем класс, который делаем запрос к API и возвращает объект модели с промисами
      article =
        findAll : (queryName)->
          deferred = $q.defer()
          scope = this
          articles = []
          $http.get(apiUrl + "/#{queryName}").success((array) ->
            array.forEach (data) ->
              articles.push new ArticleModel(data)
              return
            deferred.resolve articles
            return
          ).error ->
            deferred.reject()
            return
          deferred.promise
        findOne : (id,queryName) ->
          deferred = $q.defer()
          scope = this
          data = {}
          $http.get(apiUrl + "/#{queryName}/" + id).success((data) ->
            deferred.resolve new ArticleModel(data)
            return
          ).error ->
            deferred.reject()
            return
          deferred.promise
        createEmpty : ->
          new ArticleModel({})
      article
  ]
  services
