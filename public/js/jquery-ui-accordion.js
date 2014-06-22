;(function($){var _remove=$.fn.remove,isFF2=$.browser.mozilla&&(parseFloat($.browser.version)<1.9);$.ui={version:"1.6rc5",plugin:{add:function(module,option,set){var proto=$.ui[module].prototype;for(var i in set){proto.plugins[i]=proto.plugins[i]||[];proto.plugins[i].push([option,set[i]]);}},call:function(instance,name,args){var set=instance.plugins[name];if(!set){return;}
for(var i=0;i<set.length;i++){if(instance.options[set[i][0]]){set[i][1].apply(instance.element,args);}}}},contains:function(a,b){return document.compareDocumentPosition?a.compareDocumentPosition(b)&16:a!==b&&a.contains(b);},cssCache:{},css:function(name){if($.ui.cssCache[name]){return $.ui.cssCache[name];}
var tmp=$('<div class="ui-gen"></div>').addClass(name).css({position:'absolute',top:'-5000px',left:'-5000px',display:'block'}).appendTo('body');$.ui.cssCache[name]=!!((!(/auto|default/).test(tmp.css('cursor'))||(/^[1-9]/).test(tmp.css('height'))||(/^[1-9]/).test(tmp.css('width'))||!(/none/).test(tmp.css('backgroundImage'))||!(/transparent|rgba\(0, 0, 0, 0\)/).test(tmp.css('backgroundColor'))));try{$('body').get(0).removeChild(tmp.get(0));}catch(e){}
return $.ui.cssCache[name];},hasScroll:function(el,a){if($(el).css('overflow')=='hidden'){return false;}
var scroll=(a&&a=='left')?'scrollLeft':'scrollTop',has=false;if(el[scroll]>0){return true;}
el[scroll]=1;has=(el[scroll]>0);el[scroll]=0;return has;},isOverAxis:function(x,reference,size){return(x>reference)&&(x<(reference+size));},isOver:function(y,x,top,left,height,width){return $.ui.isOverAxis(y,top,height)&&$.ui.isOverAxis(x,left,width);},keyCode:{BACKSPACE:8,CAPS_LOCK:20,COMMA:188,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,INSERT:45,LEFT:37,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SHIFT:16,SPACE:32,TAB:9,UP:38}};if(isFF2){var attr=$.attr,removeAttr=$.fn.removeAttr,ariaNS="http://www.w3.org/2005/07/aaa",ariaState=/^aria-/,ariaRole=/^wairole:/;$.attr=function(elem,name,value){var set=value!==undefined;return(name=='role'?(set?attr.call(this,elem,name,"wairole:"+value):(attr.apply(this,arguments)||"").replace(ariaRole,"")):(ariaState.test(name)?(set?elem.setAttributeNS(ariaNS,name.replace(ariaState,"aaa:"),value):attr.call(this,elem,name.replace(ariaState,"aaa:"))):attr.apply(this,arguments)));};$.fn.removeAttr=function(name){return(ariaState.test(name)?this.each(function(){this.removeAttributeNS(ariaNS,name.replace(ariaState,""));}):removeAttr.call(this,name));};}
$.fn.extend({remove:function(){$("*",this).add(this).each(function(){$(this).triggerHandler("remove");});return _remove.apply(this,arguments);},enableSelection:function(){return this.attr('unselectable','off').css('MozUserSelect','').unbind('selectstart.ui');},disableSelection:function(){return this.attr('unselectable','on').css('MozUserSelect','none').bind('selectstart.ui',function(){return false;});},scrollParent:function(){var scrollParent;if(($.browser.msie&&(/(static|relative)/).test(this.css('position')))||(/absolute/).test(this.css('position'))){scrollParent=this.parents().filter(function(){return(/(relative|absolute|fixed)/).test($.curCSS(this,'position',1))&&(/(auto|scroll)/).test($.curCSS(this,'overflow',1)+$.curCSS(this,'overflow-y',1)+$.curCSS(this,'overflow-x',1));}).eq(0);}else{scrollParent=this.parents().filter(function(){return(/(auto|scroll)/).test($.curCSS(this,'overflow',1)+$.curCSS(this,'overflow-y',1)+$.curCSS(this,'overflow-x',1));}).eq(0);}
return(/fixed/).test(this.css('position'))||!scrollParent.length?$(document):scrollParent;}});$.extend($.expr[':'],{data:function(elem,i,match){return!!$.data(elem,match[3]);},tabbable:function(elem){var nodeName=elem.nodeName.toLowerCase();function isVisible(element){return!($(element).is(':hidden')||$(element).parents(':hidden').length);}
return(elem.tabIndex>=0&&(('a'==nodeName&&elem.href)||(/input|select|textarea|button/.test(nodeName)&&'hidden'!=elem.type&&!elem.disabled))&&isVisible(elem));}});function getter(namespace,plugin,method,args){function getMethods(type){var methods=$[namespace][plugin][type]||[];return(typeof methods=='string'?methods.split(/,?\s+/):methods);}
var methods=getMethods('getter');if(args.length==1&&typeof args[0]=='string'){methods=methods.concat(getMethods('getterSetter'));}
return($.inArray(method,methods)!=-1);}
$.widget=function(name,prototype){var namespace=name.split(".")[0];name=name.split(".")[1];$.fn[name]=function(options){var isMethodCall=(typeof options=='string'),args=Array.prototype.slice.call(arguments,1);if(isMethodCall&&options.substring(0,1)=='_'){return this;}
if(isMethodCall&&getter(namespace,name,options,args)){var instance=$.data(this[0],name);return(instance?instance[options].apply(instance,args):undefined);}
return this.each(function(){var instance=$.data(this,name);(!instance&&!isMethodCall&&$.data(this,name,new $[namespace][name](this,options)));(instance&&isMethodCall&&$.isFunction(instance[options])&&instance[options].apply(instance,args));});};$[namespace]=$[namespace]||{};$[namespace][name]=function(element,options){var self=this;this.namespace=namespace;this.widgetName=name;this.widgetEventPrefix=$[namespace][name].eventPrefix||name;this.widgetBaseClass=namespace+'-'+name;this.options=$.extend({},$.widget.defaults,$[namespace][name].defaults,$.metadata&&$.metadata.get(element)[name],options);this.element=$(element).bind('setData.'+name,function(event,key,value){if(event.target==element){return self._setData(key,value);}}).bind('getData.'+name,function(event,key){if(event.target==element){return self._getData(key);}}).bind('remove',function(){return self.destroy();});this._init();};$[namespace][name].prototype=$.extend({},$.widget.prototype,prototype);$[namespace][name].getterSetter='option';};$.widget.prototype={_init:function(){},destroy:function(){this.element.removeData(this.widgetName).removeClass(this.widgetBaseClass+'-disabled'+' '+this.namespace+'-state-disabled').removeAttr('aria-disabled');},option:function(key,value){var options=key,self=this;if(typeof key=="string"){if(value===undefined){return this._getData(key);}
options={};options[key]=value;}
$.each(options,function(key,value){self._setData(key,value);});},_getData:function(key){return this.options[key];},_setData:function(key,value){this.options[key]=value;if(key=='disabled'){this.element
[value?'addClass':'removeClass'](this.widgetBaseClass+'-disabled'+' '+
this.namespace+'-state-disabled').attr("aria-disabled",value);}},enable:function(){this._setData('disabled',false);},disable:function(){this._setData('disabled',true);},_trigger:function(type,event,data){var callback=this.options[type],eventName=(type==this.widgetEventPrefix?type:this.widgetEventPrefix+type);event=$.Event(event);event.type=eventName;this.element.trigger(event,data);return!($.isFunction(callback)&&callback.call(this.element[0],event,data)===false||event.isDefaultPrevented());}};$.widget.defaults={disabled:false};$.ui.mouse={_mouseInit:function(){var self=this;this.element.bind('mousedown.'+this.widgetName,function(event){return self._mouseDown(event);}).bind('click.'+this.widgetName,function(event){if(self._preventClickEvent){self._preventClickEvent=false;return false;}});if($.browser.msie){this._mouseUnselectable=this.element.attr('unselectable');this.element.attr('unselectable','on');}
this.started=false;},_mouseDestroy:function(){this.element.unbind('.'+this.widgetName);($.browser.msie&&this.element.attr('unselectable',this._mouseUnselectable));},_mouseDown:function(event){(this._mouseStarted&&this._mouseUp(event));this._mouseDownEvent=event;var self=this,btnIsLeft=(event.which==1),elIsCancel=(typeof this.options.cancel=="string"?$(event.target).parents().add(event.target).filter(this.options.cancel).length:false);if(!btnIsLeft||elIsCancel||!this._mouseCapture(event)){return true;}
this.mouseDelayMet=!this.options.delay;if(!this.mouseDelayMet){this._mouseDelayTimer=setTimeout(function(){self.mouseDelayMet=true;},this.options.delay);}
if(this._mouseDistanceMet(event)&&this._mouseDelayMet(event)){this._mouseStarted=(this._mouseStart(event)!==false);if(!this._mouseStarted){event.preventDefault();return true;}}
this._mouseMoveDelegate=function(event){return self._mouseMove(event);};this._mouseUpDelegate=function(event){return self._mouseUp(event);};$(document).bind('mousemove.'+this.widgetName,this._mouseMoveDelegate).bind('mouseup.'+this.widgetName,this._mouseUpDelegate);($.browser.safari||event.preventDefault());return true;},_mouseMove:function(event){if($.browser.msie&&!event.button){return this._mouseUp(event);}
if(this._mouseStarted){this._mouseDrag(event);return event.preventDefault();}
if(this._mouseDistanceMet(event)&&this._mouseDelayMet(event)){this._mouseStarted=(this._mouseStart(this._mouseDownEvent,event)!==false);(this._mouseStarted?this._mouseDrag(event):this._mouseUp(event));}
return!this._mouseStarted;},_mouseUp:function(event){$(document).unbind('mousemove.'+this.widgetName,this._mouseMoveDelegate).unbind('mouseup.'+this.widgetName,this._mouseUpDelegate);if(this._mouseStarted){this._mouseStarted=false;this._preventClickEvent=true;this._mouseStop(event);}
return false;},_mouseDistanceMet:function(event){return(Math.max(Math.abs(this._mouseDownEvent.pageX-event.pageX),Math.abs(this._mouseDownEvent.pageY-event.pageY))>=this.options.distance);},_mouseDelayMet:function(event){return this.mouseDelayMet;},_mouseStart:function(event){},_mouseDrag:function(event){},_mouseStop:function(event){},_mouseCapture:function(event){return true;}};$.ui.mouse.defaults={cancel:null,distance:1,delay:0};})(jQuery);(function($){$.widget("ui.accordion",{_init:function(){var options=this.options;if(options.navigation){var current=this.element.find("a").filter(options.navigationFilter);if(current.length){if(current.filter(options.header).length){options.active=current;}else{options.active=current.parent().parent().prev();current.addClass("ui-accordion-current");}}}
this.element.addClass("ui-accordion ui-widget ui-helper-reset");var groups=this.element.children().addClass("ui-accordion-group");var headers=options.headers=groups.find("> :first-child").addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-all").bind("mouseenter.accordion",function(){$(this).addClass('ui-state-hover');}).bind("mouseleave.accordion",function(){$(this).removeClass('ui-state-hover');});headers.next().wrap("<div></div>").addClass("ui-accordion-content").parent().addClass("ui-accordion-content-wrap ui-helper-reset ui-widget-content ui-corner-bottom");var active=options.active=findActive(headers,options.active).toggleClass("ui-state-default").toggleClass("ui-state-active").toggleClass("ui-corner-all").toggleClass("ui-corner-top");active.parent().addClass(options.selectedClass);$("<span/>").addClass("ui-icon "+this.options.icons.header).prependTo(headers);active.find(".ui-icon").toggleClass(this.options.icons.header).toggleClass(this.options.icons.headerSelected);if($.browser.msie){this.element.find('a').css('zoom','1');}
this.resize();this.element.attr('role','tablist');var self=this;options.headers.attr('role','tab').bind('keydown',function(event){return self._keydown(event);}).next().attr('role','tabpanel');options.headers.not(options.active||"").attr('aria-expanded','false').attr("tabIndex","-1").next().hide();if(!options.active.length){options.headers.eq(0).attr('tabIndex','0');}else{options.active.attr('aria-expanded','true').attr("tabIndex","0");}
if(!$.browser.safari)
options.headers.find('a').attr('tabIndex','-1');if(options.event){this.element.bind((options.event)+".accordion",clickHandler);}},destroy:function(){this.element.removeClass("ui-accordion ui-widget ui-helper-reset").removeAttr("role").unbind(".accordion");$.removeData(this.element[0],"accordion");var groups=this.element.children().removeClass("ui-accordion-group "+this.options.selectedClass);var headers=this.options.headers.unbind(".accordion").removeClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-all ui-state-active ui-corner-top").removeAttr("role").removeAttr("aria-expanded").removeAttr("tabindex");headers.find("a").removeAttr("tabindex");headers.children(".ui-icon").remove();headers.next().children().removeClass("ui-accordion-content").each(function(){$(this).parent().replaceWith(this);})},_keydown:function(event){if(this.options.disabled||event.altKey||event.ctrlKey)
return;var keyCode=$.ui.keyCode;var length=this.options.headers.length;var currentIndex=this.options.headers.index(event.target);var toFocus=false;switch(event.keyCode){case keyCode.RIGHT:case keyCode.DOWN:toFocus=this.options.headers[(currentIndex+1)%length];break;case keyCode.LEFT:case keyCode.UP:toFocus=this.options.headers[(currentIndex-1+length)%length];break;case keyCode.SPACE:case keyCode.ENTER:return clickHandler.call(this.element[0],{target:event.target});}
if(toFocus){$(event.target).attr('tabIndex','-1');$(toFocus).attr('tabIndex','0');toFocus.focus();return false;}
return true;},resize:function(){var options=this.options,maxHeight;if(options.fillSpace){maxHeight=this.element.parent().height();options.headers.each(function(){maxHeight-=$(this).outerHeight();});var maxPadding=0;options.headers.next().each(function(){maxPadding=Math.max(maxPadding,$(this).innerHeight()-$(this).height());}).height(maxHeight-maxPadding).css('overflow','auto');}else if(options.autoHeight){maxHeight=0;options.headers.next().each(function(){maxHeight=Math.max(maxHeight,$(this).outerHeight());}).height(maxHeight);}},activate:function(index){clickHandler.call(this.element[0],{target:findActive(this.options.headers,index)[0]});}});function scopeCallback(callback,scope){return function(){return callback.apply(scope,arguments);};};function completed(cancel){if(!$.data(this,"accordion")){return;}
var instance=$.data(this,"accordion");var options=instance.options;options.running=cancel?0:--options.running;if(options.running){return;}
if(options.clearStyle){options.toShow.add(options.toHide).css({height:"",overflow:""});}
instance._trigger('change',null,options.data);}
function toggle(toShow,toHide,data,clickedActive,down){var options=$.data(this,"accordion").options;options.toShow=toShow;options.toHide=toHide;options.data=data;var complete=scopeCallback(completed,this);$.data(this,"accordion")._trigger("changestart",null,options.data);options.running=toHide.size()===0?toShow.size():toHide.size();if(options.animated){var animOptions={};if(!options.alwaysOpen&&clickedActive){animOptions={toShow:$([]),toHide:toHide,complete:complete,down:down,autoHeight:options.autoHeight||options.fillSpace};}else{animOptions={toShow:toShow,toHide:toHide,complete:complete,down:down,autoHeight:options.autoHeight||options.fillSpace};}
if(!options.proxied){options.proxied=options.animated;}
if(!options.proxiedDuration){options.proxiedDuration=options.duration;}
options.animated=$.isFunction(options.proxied)?options.proxied(animOptions):options.proxied;options.duration=$.isFunction(options.proxiedDuration)?options.proxiedDuration(animOptions):options.proxiedDuration;var animations=$.ui.accordion.animations,duration=options.duration,easing=options.animated;if(!animations[easing]){animations[easing]=function(options){this.slide(options,{easing:easing,duration:duration||700});};}
animations[easing](animOptions);}else{if(!options.alwaysOpen&&clickedActive){toShow.toggle();}else{toHide.hide();toShow.show();}
complete(true);}
toHide.prev().attr('aria-expanded','false').attr("tabIndex","-1");toShow.prev().attr('aria-expanded','true').attr("tabIndex","0").focus();;}
function clickHandler(event){var options=$.data(this,"accordion").options;if(options.disabled){return false;}
if(!event.target&&!options.alwaysOpen){options.active.parent().toggleClass(options.selectedClass);var toHide=options.active.next(),data={options:options,newHeader:$([]),oldHeader:options.active,newContent:$([]),oldContent:toHide},toShow=(options.active=$([]));toggle.call(this,toShow,toHide,data);return false;}
var clicked=$(event.target);clicked=$(clicked.parents(options.header)[0]||clicked);var clickedActive=clicked[0]==options.active[0];if(options.running||(options.alwaysOpen&&clickedActive)){return false;}
if(!clicked.is(options.header)){return;}
options.active.parent().toggleClass(options.selectedClass);options.active.removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all").find(".ui-icon").removeClass(options.icons.headerSelected).addClass(options.icons.header);if(!clickedActive){clicked.parent().addClass(options.selectedClass);clicked.removeClass("ui-state-default ui-corner-all").addClass("ui-state-active ui-corner-top").find(".ui-icon").removeClass(options.icons.header).addClass(options.icons.headerSelected);}
var toShow=clicked.next(),toHide=options.active.next(),data={options:options,newHeader:clickedActive&&!options.alwaysOpen?$([]):clicked,oldHeader:options.active,newContent:clickedActive&&!options.alwaysOpen?$([]):toShow,oldContent:toHide},down=options.headers.index(options.active[0])>options.headers.index(clicked[0]);options.active=clickedActive?$([]):clicked;toggle.call(this,toShow,toHide,data,clickedActive,down);return false;};function findActive(headers,selector){return selector?typeof selector=="number"?headers.filter(":eq("+selector+")"):headers.not(headers.not(selector)):selector===false?$([]):headers.filter(":eq(0)");}
$.extend($.ui.accordion,{version:"1.6rc5",defaults:{autoHeight:true,alwaysOpen:true,animated:'slide',event:"click",header:"a",icons:{header:"ui-icon-triangle-1-e",headerSelected:"ui-icon-triangle-1-s"},navigationFilter:function(){return this.href.toLowerCase()==location.href.toLowerCase();},running:0,selectedClass:"ui-accordion-selected"},animations:{slide:function(options,additions){options=$.extend({easing:"swing",duration:300},options,additions);if(!options.toHide.size()){options.toShow.animate({height:"show"},options);return;}
var hideHeight=options.toHide.height(),showHeight=options.toShow.height(),difference=showHeight/hideHeight,overflow=options.toShow.css('overflow');options.toShow.css({height:0,overflow:'hidden'}).show();options.toHide.filter(":hidden").each(options.complete).end().filter(":visible").animate({height:"hide"},{step:function(now){var current=(hideHeight-now)*difference;if($.browser.msie||$.browser.opera){current=Math.ceil(current);}
options.toShow.height(current);},duration:options.duration,easing:options.easing,complete:function(){if(!options.autoHeight){options.toShow.css("height","auto");}
options.toShow.css({overflow:overflow});options.complete();}});},bounceslide:function(options){this.slide(options,{easing:options.down?"easeOutBounce":"swing",duration:options.down?1000:200});},easeslide:function(options){this.slide(options,{easing:"easeinout",duration:700});}}});})(jQuery);
