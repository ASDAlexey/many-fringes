/*!
 * VERSION: 0.0.4
 * DATE: 2015-01-19
 * UPDATES AND DOCS AT: http://www.greensock.com
 *
 * @license Copyright (c) 2008-2015, GreenSock. All rights reserved.
 * DrawSVGPlugin is a Club GreenSock membership benefit; You must have a valid membership to use
 * this code without violating the terms of use. Visit http://greensock.com/club/ to sign up or get more details.
 * This work is subject to the software agreement that was issued with your membership.
 *
 * @author: Jack Doyle, jack@greensock.com
 */
var _gsScope="undefined"!= typeof module&&module.exports&&"undefined"!= typeof global?global:this||window;
(_gsScope._gsQueue||(_gsScope._gsQueue=[])).push(function(){
    "use strict";
    function a(a,b,c,d){
        return c=parseFloat(c)-parseFloat(a), d=parseFloat(d)-parseFloat(b), Math.sqrt(c*c+d*d)
    }

    function e(a){
        return "string"!= typeof a&&a.nodeType||(a=_gsScope.TweenLite.selector(a), a.length&&(a=a[0])), a
    }

    function f(a,b,c){
        var e,f,d=a.indexOf(" ");
        return -1===d?(e=void 0!==c?c+"":a, f=a):(e=a.substr(0,d), f=a.substr(d+1)), e=-1!==e.indexOf("%")?parseFloat(e)/100*b:parseFloat(e), f=-1!==f.indexOf("%")?parseFloat(f)/100*b:parseFloat(f), e>f?[f,e]:[e,f]
    }

    function g(b){
        if(!b)return 0;
        b=e(b);
        var d,f,g,h,i,j,k,l,c=b.tagName.toLowerCase();
        if("path"===c)d=b.getTotalLength()||0;else if("rect"===c)f=b.getBBox(), d=2*(f.width+f.height);else if("circle"===c)d=2*Math.PI*parseFloat(b.getAttribute("r"));else if("line"===c)d=a(b.getAttribute("x1"),b.getAttribute("y1"),b.getAttribute("x2"),b.getAttribute("y2"));else if("polyline"===c||"polygon"===c)for(g=b.getAttribute("points").split(" "), d=0, i=g[0].split(","), "polygon"===c&&(g.push(g[0]), -1===g[0].indexOf(",")&&g.push(g[1])), j=1; j<g.length; j++)h=g[j].split(","), 1===h.length&&(h[1]=g[j++]), 2===h.length&&(d+=a(i[0],i[1],h[0],h[1])||0, i=h);else"ellipse"===c&&(k=parseFloat(b.getAttribute("rx")), l=parseFloat(b.getAttribute("ry")), d=Math.PI*(3*(k+l)-Math.sqrt((3*k+l)*(k+3*l))));
        return d||0
    }

    function j(a,b){
        if(!a)return [0,0];
        a=e(a), b=b||g(a)+1;
        var c=h(a),d=c.strokeDasharray||"",f=parseFloat(c.strokeDashoffset);
        return d=-1===d.indexOf(" ")?b:parseFloat(d.split(" ")[0])||1e-5, d>b&&(d=b), [Math.max(0,-f),d-f]
    }

    var i,b=String.fromCharCode(103,114,101,101,110,115,111,99,107,46,99,111,109),c=String.fromCharCode(47,114,101,113,117,105,114,101,115,45,109,101,109,98,101,114,115,104,105,112,47),d=function(a){
        for(var c=[b,String.fromCharCode(99,111,100,101,112,101,110,46,105,111),String.fromCharCode(99,100,112,110,46,105,111),String.fromCharCode(103,97,110,110,111,110,46,116,118),String.fromCharCode(99,111,100,101,99,97,110,121,111,110,46,110,101,116),String.fromCharCode(116,104,101,109,101,102,111,114,101,115,116,46,110,101,116),String.fromCharCode(99,101,114,101,98,114,97,120,46,99,111,46,117,107),String.fromCharCode(116,121,109,112,97,110,117,115,46,110,101,116),String.fromCharCode(116,119,101,101,110,109,97,120,46,99,111,109),String.fromCharCode(116,119,101,101,110,108,105,116,101,46,99,111,109),String.fromCharCode(112,108,110,107,114,46,99,111)],d=c.length; --d> -1;)if(-1!==a.indexOf(c[d]))return !0;
        return -1!==(window?window.location.href:"").indexOf(String.fromCharCode(103,114,101,101,110,115,111,99,107))&&-1!==a.indexOf(String.fromCharCode(108,111,99,97,108,104,111,115,116))
    }(window?window.location.host:""),h=document.defaultView?document.defaultView.getComputedStyle:function(){
    };
    i=_gsScope._gsDefine.plugin({
        propName:"drawSVG",API:2,version:"0.0.4",global:!0,overwriteProps:["drawSVG"],init:function(a,e){
            if(!a.getBBox)return !1;
            if(!d)return true, !1;
            var k,l,m,i=g(a)+1;
            return this._style=a.style, e=== !0||"true"===e?e="0 100%":e?-1===(e+"").indexOf(" ")&&(e="0 "+e):e="0 0", k=j(a,i), l=f(e,i,k[0]), this._length=i+10, 0===k[0]&&0===l[0]?(m=Math.max(1e-5,l[1]-i), this._dash=i+m, this._offset=i-k[1]+m, this._addTween(this,"_offset",this._offset,i-l[1]+m,"drawSVG")):(this._dash=k[1]-k[0]||1e-6, this._offset= -k[0], this._addTween(this,"_dash",this._dash,l[1]-l[0]||1e-5,"drawSVG"), this._addTween(this,"_offset",this._offset,-l[0],"drawSVG")), d
        },set:function(a){
            this._firstPT&&(this._super.setRatio.call(this,a), this._style.strokeDashoffset=this._offset, this._style.strokeDasharray=this._dash+" "+this._length)
        }
    }), i.getLength=g, i.getPosition=j
}), _gsScope._gsDefine&&_gsScope._gsQueue.pop()();