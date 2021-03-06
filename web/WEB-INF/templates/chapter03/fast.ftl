<@nerve.header title="chapter03:中国地图实践2--缩放级别(低精度)">
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

    var chinaG                      //包含中国地图的group
        ;
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
            .center([0, 37.5])                                  //设置中心点，调整到屏幕中心
    ;

    // Draw geojson to svg path using the projection
    var path = d3.geo.path().projection(projection);

    var zoom = d3.behavior.zoom()
            .translate([0, 0])
            .scale(1)
            .scaleExtent([1, 4])
            .on("zoom", zoomed);

    var active = d3.select(null);

    function background(){
        container.append("rect")
                .attr("class", "background")
                .attr("width", width)
                .attr("height", height)
                .on("click", reset)
        ;
    }
    //画出中国地图
    function drawChina(ds){
        if(!chinaG){
            //background();
            chinaG = container.append("g");
        }
        chinaG.selectAll("path")
                .data(ds.features)
                .enter()
                .insert("path")
                .attr("id", function(d){
                    if(d.cities)
                        console.log(d.cities);
                    return d.id;
                })
                .attr("fill", "#000000")
                .attr("d", path)
                .attr('stroke',setting.strokeColor)
                .attr('stroke-width','0.7px')
                .on("click", provinceClicked)
                .selectAll("circle")
                .data(function(d){
                    return d.cities||[];
                })
                .enter()
                .insert("circle")
                .attr("cx", function(d){return projection([d.g, d.l])[0];})
                .attr("cy", function(d){return projection([d.g, d.l])[1];})
                .attr("r", 19)
                .attr("fill", "#ff0000")
        ;
    }

    function provinceClicked(d) {
        if (active.node() === this) return reset();
        active.classed("active", false);
        active = d3.select(this).classed("active", true);

        console.log("click!", active.node());

        var bounds = path.bounds(d),
                dx = bounds[1][0] - bounds[0][0],
                dy = bounds[1][1] - bounds[0][1],
                x = (bounds[0][0] + bounds[1][0]) / 2,
                y = (bounds[0][1] + bounds[1][1]) / 2,
                scale = .8 / Math.max(dx / width, dy / height),
                translate = [width / 2 - scale * x, height / 2 - scale * y];

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
        resetBgColor("path");

        active.classed("active", false);
        active = d3.select(null);

        container.transition()
                .duration(750)
                .call(zoom.translate([0, 0]).scale(1).event);
    }

    function zoomed() {
        chinaG.style("stroke-width", 0.1 / d3.event.scale + "px");
        chinaG.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
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

    window.onload = function(){
        //同时生成随机的颜色值
        colors = d3.scale.category20b();

        createSVG("container",width,height);
        /*
        赋值给container
        同时调用style()方法给container设置相应的style属性
         */
        container = d3.select("#container");

        queue()
                .defer(d3.json, "${DATA}/china.json")
                .await(function(error, china){
                    if(error){
                        alert("加载数据出错！"+error);
                        return ;
                    }
                    drawChina(china);
                });

    }
</script>
<@nerve.footer>
    <@nerve.aboutme/>
</@nerve.footer>