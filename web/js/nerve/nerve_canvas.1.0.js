/**
 * Created by zengxm on 2014/11/21.
 */
/**
 * Created by zengxm on 2014/11/21.
 */
(function(window){
    var
        version='1.1',
        Nerve= function (){
        }
        ;

    Nerve.fn = Nerve.prototype = {
        debug:true,
        type:function(obj){
            return typeof obj;
        },
        log:function(obj){
            if(this.debug) console.log(obj);
        }
    };
    Nerve.prototype.type =function(obj){
        return typeof obj;
    }
    /**
     *扩展方法
     * 如果只用一个参数，且参数不为boolean，则是对自身的扩展
     * @type {extend}
     */
    Nerve.extend = Nerve.fn.extend = function(){
        var options, name, src, copy, copyIsArray, clone,
            target = arguments[0] || {},
            i = 1,
            length = arguments.length,
            deep = false;

        // Handle a deep copy situation
        if ( typeof target === "boolean" ) {
            deep = target;

            // Skip the boolean and the target
            target = arguments[ i ] || {};
            i++;
        }

        // Handle case when target is a string or something (possible in deep copy)
        if ( typeof target !== "object" && !jQuery.isFunction(target) ) {
            target = {};
        }

        // Extend jQuery itself if only one argument is passed
        if ( i === length ) {
            target = this;
            i--;
        }

        for ( ; i < length; i++ ) {
            // Only deal with non-null/undefined values
            if ( (options = arguments[ i ]) != null ) {
                // Extend the base object
                for ( name in options ) {
                    src = target[ name ];
                    copy = options[ name ];

                    // Prevent never-ending loop
                    if ( target === copy ) {
                        continue;
                    }

                    if ( copy !== undefined ) {
                        target[ name ] = copy;
                    }
                }
            }
        }
        // Return the modified object
        return target;
    }

    window.Point = function(x,y){
        this.x =x;
        this.y =y;
    }
    window.Nerve = new Nerve();
})(window);

Nerve.extend({
    /**
     * 类似java中的ArrayList
     * 提供的方法：
     * add(obj,index);
     * remove(index);
     * size();
     * get(index);
     */
    List:function(){
        this.list = new Array();

        this.size = function(){
            return this.list.length;
        }

        this.add = function(o, index){

            if (typeof(index) != 'number' || index >= this.size()) {
                this.list.push(o);
            }
            else {

                var size = this.size();
                for(;size>index;size--){
                    this.list[size] = this.list[size-1];
                }
                this.list[index] = o;
                Console.log("add at :"+index)
            }
        }

        this.get = function(index){
            index = index || 0;
            return this.list[index];
        }

        this.remove = function(index){
            if(index>=0 && index < this.size()){
                this.list.splice(index,1);
            }else{
                this.list = [];
            }
        }

        this.print = function(item){
            if(item){
                item.log(this.list);
            }else{
                for(var i=0;i<this.list.length;i++){
                    alert(this.get(i));
                }
            }
        }
    },

    /**
     * 仿java中的Map
     */
    Map:function(){
        this.count = 0;
        this.OBJ = new Object();

        /**
         * 将元素加入到集合中
         * @param {Object} key
         * @param {Object} value
         */
        this.put = function(key,value){
            if(!this.OBJ[key])
                this.count ++;
            this.OBJ[key] = value;
        }

        this.isHave = function(key){
            return this.OBJ[key]?true:false;
        }

        this.get = function(key){
            return this.OBJ[key];
        }

        this.remove = function(key){
            delete this.OBJ[key];
            this.count --;
        }

        this.size = function(){
            return this.count;
        }

        this.clear = function(){
            this.OBJ = new Object();
            this.count = 0;
        }

        /**
         * 是否为空
         * @memberOf {TypeName}
         * @return {TypeName}
         */
        this.isEmpty = function(){
            return this.count == 0;
        }

        this.each = function(callBack){
            if(callBack && typeof(callBack) == 'function'){
                for(var item in this.OBJ){
                    callBack(item,this.OBJ[item]);
                }
            }
        }
    }
});
//定义requestNextAnimationFrame
window.requestNextAnimationFrame =
    (function () {
        var originalWebkitRequestAnimationFrame = undefined,
            wrapper = undefined,
            callback = undefined,
            geckoVersion = 0,
            userAgent = navigator.userAgent,
            index = 0,
            self = this;

        // Workaround for Chrome 10 bug where Chrome
        // does not pass the time to the animation function
        if (window.webkitRequestAnimationFrame) {
            // Define the wrapper
            wrapper = function (time) {
                if (time === undefined) {
                    time = +new Date();
                }
                self.callback(time);
            };

            // Make the switch
            originalWebkitRequestAnimationFrame = window.webkitRequestAnimationFrame;

            window.webkitRequestAnimationFrame = function (callback, element) {
                self.callback = callback;

                // Browser calls the wrapper and wrapper calls the callback
                originalWebkitRequestAnimationFrame(wrapper, element);
            }
        }

        // Workaround for Gecko 2.0, which has a bug in
        // mozRequestAnimationFrame() that restricts animations
        // to 30-40 fps.
        if (window.mozRequestAnimationFrame) {
            // Check the Gecko version. Gecko is used by browsers
            // other than Firefox. Gecko 2.0 corresponds to
            // Firefox 4.0.
            index = userAgent.indexOf('rv:');

            if (userAgent.indexOf('Gecko') != -1) {
                geckoVersion = userAgent.substr(index + 3, 3);

                if (geckoVersion === '2.0') {
                    // Forces the return statement to fall through
                    // to the setTimeout() function.

                    window.mozRequestAnimationFrame = undefined;
                }
            }
        }

        return window.requestAnimationFrame   ||
            window.webkitRequestAnimationFrame ||
            window.mozRequestAnimationFrame    ||
            window.oRequestAnimationFrame      ||
            window.msRequestAnimationFrame     ||
            function (callback, element) {
                var start,
                    finish;
                window.setTimeout( function () {
                    start = +new Date();
                    callback(start);
                    finish = +new Date();
                    self.timeout = 1000 / 60 - (finish - start);
                }, self.timeout);
            };
    }
        )
    ();

var nc = (function(){
    var canvas;
    var context;
    var width = 0, height = 0;
    var paused = true;          //是否暂停
    var managers = {};

    //默认的Canvas设置
    var settings = {
    }
    //十六进制颜色值的正则表达式
    var colorReg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;

    /**
     * 创建画布
     * @param id
     * @param w
     * @param h
     * @private
     */
    var _createCanvas=function(id,w,h){
        var c = document.createElement("canvas");
        c.setAttribute("id", id);
        document.body.appendChild(c);

        canvas = document.getElementById(id);
    }
    var _update=function(){
        if(context && !paused){
            context.clearRect(0,0, width, height);
            for(var n in managers){
                if(managers[n].update)
                    managers[n].update(context);
            }
        }
    }
    return {
        /**
         * 初始化canvas跟context
         * 如果指定id的canvas不存在，则在body末尾添加，并使用w，h作为宽高
         * @param id
         * @param w
         * @param h
         * @param setting
         */
        init:function(id,w,h,setting){
            setting = setting||{};
            id = id||"canvas";  //使用canvas作为默认的id
            Nerve.extend(settings, setting);

            canvas = document.getElementById(id);
            Nerve.log(settings);
            if(!canvas){
                _createCanvas(id,w,h);
            }

            width = canvas.width = w;
            height = canvas.height = h;

            context = canvas.getContext('2d');
            Nerve.extend(context, settings);
            //开始循环
            nc.resume();
            window.requestNextAnimationFrame(nc.update);
        },
        /**
         * 执行画面的更新
         */
        update:function(){
            _update();
           window.requestNextAnimationFrame(nc.update);
        },
        //添加manager，每个manager各自管理自己的child
        addManager:function(name, m){
            managers[name] = m;
            console.log("add manager ok："+name);
        },
        //暂停
        pause:function(){
           paused = true;
        },
        //回复画布的更新
        resume:function(){
          paused = false;
        },
        canvas:function (){return canvas;},
        context:function(){return context;},
        /**
         * 清空画布
         * @param w
         * @param h
         */
        clear:function(f,t,w,h){
            f=f||0; t=t||0;
            w=w||width; h=h||height;
            context.clearRect(f,t,w,h);
        },
        line:function(p1,p2){
            context.moveTo(p1.x, p1.y);
            context.lineTo(p2.x,p2.y);
            context.stroke();
        },
        /**
         * 将document中的xy坐标兑换成canvas里面的坐标
         * @param x
         * @param y
         * @returns {{x: number, y: number}}
         */
        windowToCanvas:function(x, y) {
            var bbox = canvas.getBoundingClientRect();
            return {
                x: x - bbox.left * (canvas.width  / bbox.width),
                y: y - bbox.top  * (canvas.height / bbox.height)
            };
        },
        randomRGBA:function(){
            return 'rgba('+
                (255*Math.random()).toFixed(0)+','+
                (255*Math.random()).toFixed(0)+','+
                (255*Math.random()).toFixed(0)+','+
                (Math.random()).toFixed(2)+')';
        },
        randomRGB:function(){
            return 'rgba('+
                (255*Math.random()).toFixed(0)+','+
                (255*Math.random()).toFixed(0)+','+
                (255*Math.random()).toFixed(0)+
                ',1.0)';
        },
        rgb2Hex:function(that){
            if(/^(rgb|RGB)/.test(that)){
                var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");
                var strHex = "#";
                for(var i=0; i<aColor.length; i++){
                    var hex = Number(aColor[i]).toString(16);
                    if(hex === "0"){
                        hex += hex;
                    }
                    strHex += hex;
                }
                if(strHex.length !== 7){
                    strHex = that;
                }
                return strHex;
            }else if(colorReg.test(that)){
                var aNum = that.replace(/#/,"").split("");
                if(aNum.length === 6){
                    return that;
                }else if(aNum.length === 3){
                    var numHex = "#";
                    for(var i=0; i<aNum.length; i+=1){
                        numHex += (aNum[i]+aNum[i]);
                    }
                    return numHex;
                }
            }else{
                return that;
            }
        },
        hex2Rgb:function(that){
            var sColor = that.toLowerCase();
            if(sColor && colorReg.test(sColor)){
                if(sColor.length === 4){
                    var sColorNew = "#";
                    for(var i=1; i<4; i+=1){
                        sColorNew += sColor.slice(i,i+1).concat(sColor.slice(i,i+1));
                    }
                    sColor = sColorNew;
                }
                //处理六位的颜色值
                var sColorChange = [];
                for(var i=1; i<7; i+=2){
                    sColorChange.push(parseInt("0x"+sColor.slice(i,i+2)));
                }
                return "RGB(" + sColorChange.join(",") + ")";
            }else{
                return sColor;
            }
        }
    }
})();