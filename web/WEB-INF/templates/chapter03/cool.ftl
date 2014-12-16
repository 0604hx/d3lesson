<@nerve.header title="chapter03:中国地图实践2--缩放级别">
    <@nerve.d3 />
</@nerve.header>
<style>
    body {
        overflow: hidden;
        background: #ffffff;
        width: 100%;
        font-family:"Microsoft YaHei", "Oswald", "Open Sans", sans-serif;
        padding:0px; margin: 0px;
    }

    .bg2 {background: url("${IMAGES}/background.png");}
    .noBg {background: none;}

    .box td {text-align: center; padding: 2px;}
    .box tr:hover td {background-color: #92cf28;color:#fff;}

    .background {
        fill: none;
        pointer-events: all;
    }
    .active {
        /*fill: orange;*/
        stroke: none;
    }
    /*没有被选中的省份*/
    .noactive {
        opacity: 0.2;
        /*stroke:none;*/
    }

    .topTitle {position: absolute; top:2px; left:48%;}
    .cityName {pointer-events: none;}

    .content-wrap {}
    .backBg {background: #161616 url(${IMAGES}/pattern_40.gif) top left repeat;color:#ffffff;}
    .whiteBg {background: #dadada;}

    svg text {font-family:"Microsoft YaHei";}
</style>
<div class="loading">
    <div class="ball"></div>
    <div class="ball1"></div>
</div>
<!--隐藏的菜单-->
<div class="menu-wrap whiteBg">
    <nav class="menu-side">
        <h3>程序设置</h3>
        <div>
            背景色：
            <label><input type="radio" name="control_bg" value="backBg" checked="checked"/>黑色</label>
            <label><input type="radio" name="control_bg" value="whiteBg"/>白色</label>
        </div>
        <div>
            城市名：
            <label><input type="radio" name="control_cityname" value="1" checked="checked"/>显示</label>
            <label><input type="radio" name="control_cityname" value="0"/>隐藏</label>
        </div>
        <div>
            地图块颜色：
            <div>
                <span class="c_ c_black"></span>
                <span class="c_ c_blue"></span>
                <span class="c_" style="background: rgb(230,179,61);"></span>
                <span class="c_" style="background: rgb(38,188,213);"></span>
                <span class="c_" style="background: rgb(205,201,125);"></span>
                <span class="c_" style="background:  rgb(217,104,49);"></span>
                <div class="clear"></div>
            </div>
        </div>
        <span id="close-button">关闭</span>
        <div class="about" style="border: 1px solid #d7d7d7;font-weight: normal;padding: 5px;font-size: 12px;">
            <b>说明</b>
        </div>
    </nav>
</div>
<button class="menu-button" id="open-button">Open Menu</button>

<!--svg元素-->
<svg class="content-wrap backBg" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="container" xml:space="preserve">
    <defs>
        <image height="12" width="12" xlink:href="${IMAGES}/icons/globe.png" id="icon_globe"/>
    </defs>
</svg>
<!--div提示框-->
<div id="tooltip" class="hidden box">
    <p>
        <strong class="dataHolder" name="province"></strong>
        排名:<span class="dataHolder" name="sort"></span>
    </p>
    <div>
        高考人数:<span class="dataHolder" name="total"></span>万&nbsp;
        录取率:<span class="dataHolder" name="rate"></span>
    </div>
</div>
<script>
    var container,
            width = window.innerWidth,
            height = window.innerHeight,
            colors
            ;
    var mouseDuration = 250,        //鼠标移动动画时长
            duration = 1000;

    var
            titleP,                     //标题
            worldG,                      //包含世界地图的group
            chinaG,                      //包含中国地图的group
            cityG                        //包含中国城市的group
            ;
    //缩放级别，0=世界，1=中国，2=省份
    //默认为-1，当加载完中国地图后，变成0
    var scaleLevel = -1;
    var setting = {
        cityName:true,
        fill:"#000000",   //"#11273E" 蓝色
        countryColor: d3.scale.linear()
                .domain([1, 34])
                .range([d3.rgb(255, 255, 180),d3.rgb(130, 140, 20)]),
        strokeColor:"#6a6a6a"
    }

    // Project from latlng to pixel coords
    //使用墨卡托投影
    var projection = d3.geo.mercator()
            .scale(width/2)                                   //对地图进行缩放
            .translate([width / 2, height / 2])                 //将地图平移到屏幕中间
            .rotate([-110, 0])
            .center([-5, 38.5])                                  //设置中心点，调整到屏幕中心
    ;


    // Draw geojson to svg path using the projection
    var path = d3.geo.path().projection(projection);
    // Project from latlng to pixel coords
    //var worldProject = d3.geo.mercator().translate([0, 0]).scale(1).rotate([ - 11.5, 0]);
    var worldProject = d3.geo.mercator()
            .scale(width/8.5)
            .translate([width / 2, height / 1.7]);
    //世界地图
    var worldPath = d3.geo.path().projection(worldProject);

    var zoom = d3.behavior.zoom()
            .translate([0, 0])
            .scale(1)
            .scaleExtent([1, 4])
            .on("zoom", zoomed);

    var active = d3.select(null);

    function background(){
        chinaG.append("rect")
                .attr("class", "background")
                .attr("width", width)
                .attr("height", height)
                .on("click", reset)
        ;
    }

    function drawWorld(world){
        if(!worldG){
            worldG = container.append("g").attr("id", "world");
        }
        worldG.selectAll("path")
                .data(topojson.feature(world, world.objects.countries).features)
                .enter()
                .insert("path")
                .attr("class", "feature")
                .attr("id", function(d){
                    return d.id;
                })
                .attr("fill", setting.fill)
                .attr("d", worldPath)
                .attr('stroke','#6a6a6a')
                .attr('stroke-width','0.7px')
                .on("click", countryClicked)
        ;
        drawChina(china);
    }

    //画出中国地图
    function drawChina(ds){
        if(!chinaG){
            chinaG = container.append("g").classed("hide", true);
            background();
        }
        chinaG.selectAll("path")
                .data(ds.geometries)
                .enter()
                .insert("path")
                .attr("id", function(d){
                    return d.id;
                })
                .attr("fill", setting.fill)
                .attr("d", path)
                .attr('stroke',setting.strokeColor)
                .attr('stroke-width','0.5px')
                .on("click", provinceClicked)
        ;
        drawCity();
        //默认将中国缩放，不然第一次点击的时候没有放大的动态效果
        transitionChina(false, function(){
            setLevel(0);
        });
    }

    //绘制城市
    /**
     * 如果是国家一级，就只显示省会城市
     *
     * 如果是省份一级，就显示该省份下全部的城市
    */
    function drawCity(){
        if(!cityG){
            cityG = chinaG.append("g").classed("cityG", true);
            for(var p in cities){
                for(var i=0;i<cities[p].length;i++){
                    var d = cities[p][i];
                    var point = projection([d.g, d.l]);
                    cityG
                            .insert("circle")
                            .attr("id", p+"_"+i)
                            .attr("cx", point[0])
                            .attr("cy", point[1])
                            .classed("city", true)
                            .classed(p, true)
                            .classed("capital", i==0)           //第一位的是省会
                            .classed("normal", i!=0)            //normal 就是普通城市
                            .attr("fill", "#f5f555")
                            .attr("r", 3)
                            .append("title")
                            .text(d.name+" 经度"+ d.g+" 纬度"+ d.l)
                    ;
                }
            }
            showCityName(true);
        }
        var isCountry = active.node() == null;
        cityG.selectAll(".city").classed("hide", true).attr("r", scaleLevel==2?(6/container.scaleValue):3);
        if(isCountry){
            cityG.selectAll(".capital").classed("hide", false);
        }else{
            cityG.selectAll("."+active.attr("id")).classed("hide", false);
        }
    }

    /**
     * 是否显示城市名
     */
    function showCityName(show){
        setting.cityName = show;
        if(show){
            for(var p in cities){
                for(var i=0;i<cities[p].length;i++){
                    var d = cities[p][i];
                    var point = projection([d.g, d.l]);
                    cityG.insert("text")
                            .attr("x", point[0]+2)
                            .attr("y", point[1])
                            .classed("cityName", true)
                            .classed("city", true)
                            .classed("hide", scaleLevel==1&&i>0)
                            .classed(p, true)
                            .classed("capital", i==0)           //第一位的是省会
                            .classed("normal", i!=0)            //normal 就是普通城市
                            .attr("fill", "#ffffff")
                            .attr("font-size", 1)
                            .attr("text-anchor","start")
                            .text(d.name)
                    ;
                }
            }
        }else{
            chinaG.selectAll(".cityName")
                    .attr("opacity", 1)
                    .transition()
                    .duration(duration)
                    .attr("opacity", 0)
                    .each("end", function(){
                        d3.select(this).remove();
                    })
        }
    }

    /**
     * 国家被点击，只处理中国的
     */
    function countryClicked(d) {
        if (scaleLevel < 0)
            return;
        if (d.id == 156) {
            if (scaleLevel == 0) {
                transitionWorld(false);
                if (!chinaG) {
                    drawChina(china);
                }
                chinaG.classed("hide", false);
                setLevel(1);
                //开启放大的动画
                transitionChina(true, function () {
                });
            }
        }
        d3.event.stopPropagation();
    }
    function provinceClicked(d) {
        if (active.node() === this) return reset();
        active.classed("active", false);
        active = d3.select(this).classed("active", true);
        setLevel(2);

        var bounds = path.bounds(d),
                dx = bounds[1][0] - bounds[0][0],
                dy = bounds[1][1] - bounds[0][1],
                x = (bounds[0][0] + bounds[1][0]) / 2,
                y = (bounds[0][1] + bounds[1][1]) / 2,
                scale = .8 / Math.max(dx / width, dy / height),
                translate = [width / 2 - scale * x, height / 2 - scale * y];
        container.scaleValue = scale;
        drawCity();
        container.transition()
                .duration(750)
                .call(zoom.translate(translate).scale(scale).event);

        //设置其他的省份的透明度
        chinaG.selectAll("path").classed("noactive", true);
        resetBgColor("path.active");
        d3.event.stopPropagation();
    }

    function resetBgColor(selector){
        chinaG.selectAll(selector).classed("noactive", false).attr("fill", setting.fill).attr("opacity", 1);
    }
    /**
     * 还原缩放
     */
    function reset() {
        if(scaleLevel == 2){
            resetBgColor("path");
            setLevel(1);

            active.classed("active", false);
            active = d3.select(null);

            drawCity();
            transitionChina(true);
        }else if(scaleLevel == 1){
            transitionWorld(true);
            transitionChina(false, function(){
                chinaG.classed("hide", true);
                setLevel(0);
            });
        }
        d3.event.stopPropagation();
    }
    //世界地图的显隐
    function transitionWorld(show){
        worldG.attr("opacity", show?0:1)
                .transition().duration(750)
                .attr("opacity",show?1:0);
    }
    /**
     * 缩放中国地图（从世界地图中放大，或者缩小到世界地图中）
     */
    function transitionChina(show, callBack, dura){
        toggleCityName(false);
        var tr = show?[0,0]:[width/1.7, height/4];
        var sc = show?1:0.26;
        container.transition()
                .duration(dura||600)
                .call(zoom.translate(tr).scale(sc).event)
                .each("end", function(){
                    toggleCityName(show&&setting.cityName);
                    if(callBack)
                        callBack();
                })
        ;
    }

    function toggleCityName(show){
        cityG.selectAll(".cityName.capital").attr("opacity", show?1:0);
    }

    function zoomed() {
        if(scaleLevel == 0){
            worldG.style("stroke-width", "0.1px");
            worldG.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
        }else{
            chinaG.style("stroke-width", 0.1 / d3.event.scale + "px");
            chinaG.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
        }
    }

    /**
     * 获取0到max之间的随机整数
     */
    function random(max){
        return (Math.random()*max).toFixed(0);
    }
    function px(v){
        if(typeof v === 'string')
            return v.replace("px",'');
        return v+"px";
    }

    /**
     * 创建svg
     */
    function createSVG(id,w,h){
        if(d3.select("#"+id).node()==null){
            d3.select("body").append("svg")
                    .attr("id",id);
        }
        d3.select("#"+id)
                .attr("width",w)
                .attr("height",h)
                .style("position","absolute")
                .style("top", "0px")
                .classed("hide", true)
        ;
    }
    function setLevel(l){
        scaleLevel = l;
        updateTitle();
    }
    function updateTitle(){
        if(!titleP)
            titleP = d3.select("body").append("div").attr("class", "trigger topTitle").attr("id","topTitle");
        titleP.text(scaleLevel?(scaleLevel==1?"中国":active.data()[0].name):"世界地图");
    }

    function onloaded(){
        d3.selectAll(".loading")
                .classed("hide", true);
        container.classed("hide", false);

        bindMunuControl();
    }

    //菜单设置
    function bindMunuControl(){
        d3.selectAll("[name=control_bg]")
                .on("click",function(){
                    var c = d3.select(this).attr("value");
                    //如果选择黑色，那么地图背景为黑色，body为白色
                    if(c == "backBg"){
                        d3.select("#container").classed("whiteBg", false).classed(c, true);
                        d3.select("body").classed(c, false).classed("whiteBg", true);
                        d3.select(".menu-wrap").classed(c, false).classed("whiteBg", true);
                    }else{
                        d3.select("#container").classed("backBg", false).classed(c, true);
                        d3.select("body").classed(c, false).classed("backBg", true);
                        d3.select(".menu-wrap").classed(c, false).classed("backBg", true);
                    }
                })
        ;
        d3.selectAll("[name=control_cityname]")
                .on("click",function(){
                    var c = d3.select(this).attr("value");
                    showCityName(c=="1");
                })
        ;
        d3.selectAll(".c_")
                .on("click", function(){
                    var c = d3.select(this).style("background-color");
                    changePathColor(c);
                })
        ;
    }

    function changePathColor(color){
        setting.fill = color||setting.fill;
        container.selectAll("path").attr("fill", setting.fill);
    }

    var cities;     //中国城市
    var worlds;     //世界地图
    var china;      //中国地图
    window.onload = function(){
        d3.select("body").classed("whiteBg", true);
        //同时生成随机的颜色值
        colors = d3.scale.category20b();

        createSVG("container",width,height);
        /*
        赋值给container
        同时调用style()方法给container设置相应的style属性
         */
        container = d3.select("#container");
        container.scaleValue = 2;

        queue()
                .defer(d3.json, "${DATA}/map-world.json")
                .defer(d3.json, "${DATA}/CHN_adm1_small.json")
                .defer(d3.json, "${DATA}/china_cities.json")
                .await(function(error, world, chn, cs){
                    if(error){
                        alert("加载数据出错！"+error);
                        return ;
                    }
                    cities = cs;
                    worlds = world;
                    china = chn;

                    drawWorld(worlds);
                    //drawChina(chn);
                    console.log(cities);

                    onloaded();
                });
    }
</script>
<@nerve.footer>
    <script src="${JS}/menu.js" type="text/javascript"></script>
    <@nerve.aboutme/>
</@nerve.footer>