<@nerve.header title="chapter01:创建svg元素">
    <@nerve.d3 />
</@nerve.header>
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
        selectColor:"#6a6a6a"
    }

    // Project from latlng to pixel coords
    //使用墨卡托投影
    var projection = d3.geo.mercator()
            .scale(width/2)                                   //对地图进行缩放
            .translate([width / 2, height / 2])                 //将地图平移到屏幕中间
            .rotate([-105, 0])
            .center([0, 37.5])                                  //设置中心点，调整到屏幕中心
    ;

    // Draw geojson to svg path using the projection
    var path = d3.geo.path().projection(projection);

    //画出中国地图
    function drawChina(ds){
        if(!chinaG)
            chinaG = container.append("g");
        chinaG.selectAll("path")
                .data(ds.features)
                .enter()
                .insert("path")
                .attr("id", function(d){
                    return d.id;
                })
                .attr("fill", function(d,i){
                    console.log(i+"  "+ d.id);
                    return setting.countryColor(i+2);
                })
                .attr("d", path)
                .attr('stroke','#6a6a6a')
                .attr('stroke-width','0.7px')
                .on("mouseover", function(){
                    d3.select(this)
                            .attr("opacity", 0.8);
                })
                .on("mouseout",function(){
                    d3.select(this)
                            .attr("opacity", 1.0);
                })
        ;
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
                .defer(d3.json, "${DATA}/2013GKLQL.json")
                .await(function(error, china, gks){
                    if(error){
                        alert("加载数据出错！"+error);
                        return ;
                    }
                    drawChina(china);
                    console.log(gks);
                });

    }
</script>
<@nerve.footer/>