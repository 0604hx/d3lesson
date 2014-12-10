<@nerve.header title="chapter03:中国地图实践2--缩放级别">
    <@nerve.d3 />
</@nerve.header>
<style>
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
        fill: #dadada;
        opacity: 0.6;
        stroke:none;
    }
    .hide {display: none;}
</style>
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
            worldG,                      //包含世界地图的group
            chinaG,                      //包含中国地图的group
            cityG                        //包含中国城市的group
            ;
    var scaleLevel = -1;             //缩放级别，0=世界，1=中国，2=省份
    var setting = {
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
                .attr("fill", setting.countryColor)
                .attr("d", worldPath)
                .attr('stroke','#6a6a6a')
                .attr('stroke-width','0.7px')
                .attr("fill", setting.countryColor)
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
                .attr("fill", "#000000")
                .attr("d", path)
                .attr('stroke',setting.strokeColor)
                .attr('stroke-width','0.7px')
                .on("click", provinceClicked)
        ;
        drawCity();
        //默认将中国缩放，不然第一次点击的时候没有放大的动态效果
        transitionChina(false, function(){
            scaleLevel = 0;
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
                            .attr("fill", "#f9f155")
                            .attr("r", 3)
                            .append("title")
                            .text(d.name+" 经度"+ d.g+" 纬度"+ d.l)
                    ;
                }
            }
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
     * 国家被点击，只处理中国的
     */
    function countryClicked(d){
        if(scaleLevel <0)
            return ;
        if(d.id == 156){
            if(scaleLevel == 0){
                worldG.classed("hide", true);
                if(!chinaG){
                    drawChina(china);
                }
                chinaG.classed("hide", false);
                scaleLevel = 1;
                //开启放大的动画
                transitionChina(true, function(){});
            }
        }
    }

    function provinceClicked(d) {
        if (active.node() === this) return reset();
        active.classed("active", false);
        active = d3.select(this).classed("active", true);
        scaleLevel = 2;

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
    }

    function resetBgColor(selector){
        chinaG.selectAll(selector).classed("noactive", false).attr("fill","#000000").attr("opacity", 1);
    }
    /**
     * 还原缩放
     */
    function reset() {
        if(scaleLevel == 2){
            resetBgColor("path");
            scaleLevel = 1;

            active.classed("active", false);
            active = d3.select(null);

            drawCity();
            transitionChina(true);
        }else if(scaleLevel == 1){
            worldG.classed("hide", false);
            transitionChina(false, function(){
                chinaG.classed("hide", true);
                scaleLevel = 0;
            });
        }
    }

    /**
     * 缩放中国地图（从世界地图中放大，或者缩小到世界地图中）
     */
    function transitionChina(show, callBack, dura){
        var tr = show?[0,0]:[width/1.7, height/4];
        var sc = show?1:0.26;
        container.transition()
                .duration(dura||600)
                .call(zoom.translate(tr).scale(sc).event)
                .each("end", callBack||function(){})
        ;
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
        d3.select("body").append("svg")
                .attr("id",id)
                .attr("width",w)
                .attr("height",h)
                .style("position","absolute")
        ;
    }

    var cities;     //中国城市
    var worlds;     //世界地图
    var china;      //中国地图
    window.onload = function(){
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
                });

    }
</script>
<@nerve.footer>
    <@nerve.aboutme/>
</@nerve.footer>