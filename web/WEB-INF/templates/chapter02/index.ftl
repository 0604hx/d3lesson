<@nerve.header title="chapter02:中国地图实际：2013年各省份高考一本录取率">
    <@nerve.d3 />
</@nerve.header>
<style>
    .box td {text-align: center; padding: 2px;}
    .box tr:hover td {background-color: #92cf28;color:#fff;}
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
<div class="box" style="right: 20px; top:20px; background-color: #eaeaea;">
    <div style="text-align: center; margin-bottom: 10px">
        查看方式：
        <label>
            <input type="radio" name="type" value="rate" checked="checked" onclick="sortByRate()" />录取率
        </label>
        <label>
            <input type="radio" name="type" value="total" onclick="sortByTotal()" />高考人数
        </label>
    </div>
    <table style="width:240px;" cellpadding="0" cellspacing="0">
        <thead>
            <th>排名</th>
            <th>省(市)</th>
            <th>考生数</th>
            <th>录取率</th>
        </thead>
        <tbody id="tbody">
        </tbody>
    </table>
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
                .attr("fill", "#000000")
                .attr("d", path)
                .attr('stroke',setting.strokeColor)
                .attr('stroke-width','0.7px')
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

    //显示标题
    function showTitle(){
        container.append("text")
                .attr("x", width/2)
                .attr("y", 100)
                .attr("text-anchor", "middle")
                .attr("font-family", "sans-serif")
                .attr("font-size", "20px")
                .attr("font-weight", "bold")
                .attr("fill", "black")
                .text(gkData._title)
        ;
    }
    /**
     * 根据录取率排序
     */
    function sortByRate(){
        //首先我们需要对数据进行录取率从大到小的排序
        //因为rate 是 xx.xx% 的格式，所以在对比前需要进行parseFloat 的操作
        var data = gkData.datas.sort(function(d1,d2){
            return parseFloat(d2.rate) - parseFloat(d1.rate);
        });

        //创建过度颜色,注意上一步的排序是从大到小，那么颜色应该是从深到浅
        var rateColors = d3.scale.linear()
                    .domain([1, 340])
                    .range([d3.rgb(130, 140, 20),d3.rgb(255, 255, 180)]);
        /*
        遍历上一步得到是数组
        forEach 参数中的 d 就是遍历到的某个数据， i 就是该对象的下标序号，从0开始
        */
        data.forEach(function(d,i){
            d.sort = i+1;
            //通过d.id 来获取中国地图上对应的省份，因为地图中的省份块是根据省份拼音命名的
            d3.select("#"+ d.id)
                    .transition()
                    .duration(duration)
                    .delay(10*i)
                    .attr("fill", rateColors((i+1)*10))
            ;
        });

        buildTip(data);
        showOnTable(data);
    }

    /**
     * 根据参加高考人数排序
     */
    function sortByTotal(){
        //首先我们需要对数据进行录取率从大到小的排序
        //因为rate 是 xx.xx% 的格式，所以在对比前需要进行parseFloat 的操作
        var data = gkData.datas.sort(function(d1,d2){
            return d2.total - d1.total;
        });

        //创建过度颜色,注意上一步的排序是从大到小，那么颜色应该是从深到浅
        var rateColors = d3.scale.linear()
                .domain([1, 340])
                .range([d3.rgb(20, 120, 140),d3.rgb(180, 230, 255)]);
//                .range([d3.rgb(30, 40, 160),d3.rgb(180, 160, 255)]);
        /*
        遍历上一步得到是数组
        forEach 参数中的 d 就是遍历到的某个数据， i 就是该对象的下标序号，从0开始
        */
        data.forEach(function(d,i){
            d.sort = i+1;
            //通过d.id 来获取中国地图上对应的省份，因为地图中的省份块是根据省份拼音命名的
            d3.select("#"+ d.id)
                    .transition()
                    .duration(duration)
                    .delay(10*i)
                    .attr("fill", rateColors((i+1)*10))
            ;
        });

        buildTip(data);
        showOnTable(data);
    }

    //在table中显示数据
    function showOnTable(data){
        var t = d3.select("#tbody");
        t.selectAll("tr").remove();
        t.selectAll("tr")
                .data(data)
                .enter()
                .insert("tr")
                .html(function(d,i){
                    return "<td>"+(i+1)+"</td>" +
                            "<td>"+ d.province+"</td>" +
                            "<td>"+ d.total+"</td>" +
                            "<td>"+ d.rate+"</td>";
                })
                .style("opacity", 0)
                .transition()
                .duration(100)
                .delay(function(d,i){return 10*i;})
                .style("opacity", 1)
        ;
    }

    /**
     * 创建提示条
     * 提示的创建大致有3种方式
     * 1： 给svg元素里面增加一个title元素，
     *     var t = d3.select(id).append("title").text("我是提示条");
     *      这种方法效果不大理想，而且提示单调
     *
     * 2： 给需要提示的元素添加mouseover， mouseout 事件，当鼠标在该元素上移动时，就显示提示条（动态创建的svg元素），如：
     *      var t = d3.select(id);
     *      t.on('mouseover',function(){
     *          //创建提示条
                svg.append("text")
                  .attr("id", "tooltip")
                  .attr("x", d3.event.x)
                  .attr("y", d3.event.y)
                  .attr("text-anchor", "middle")
                  .attr("font-family", "sans-serif")
                  .attr("font-size", "11px")
                  .attr("font-weight", "bold")
                  .attr("ﬁll", "black")
                  .text("我是svg的提示条");
                })
     *      });
     *
     * 3： 类似方法2，但是提示条不是svg元素，而是普通的html元素（如div），动态修改提示框里面的内容跟提示框的x，y坐标
     *      达到提示的效果，总体来说这个方法较好，较为灵活，而且可以使用css3，同时不用担心提示框超出svg范围的问题
     *
     *      所以，在教程中，都是使用这个方法
     */
    function buildTip(data){
        var t = "#tooltip";
        chinaG.selectAll("path")
                .data(data, function(d){
                    return d.id;
                })
                .on("mouseover",function(d){
                    d3.select(t)
                            .style("left", d3.event.x + "px")
                            .style("top", d3.event.y + "px")
                            .classed("hidden", false)
                            .selectAll(".dataHolder")[0]
                            .forEach(function(h){
                                h = d3.select(h);
                                h.html(d[h.attr('name')]);
                            })
                    ;
                    d3.select(this)
                            .attr("opacity", 0.8);
                })
                .on("mouseout",function(){
                    d3.select(t).classed("hidden", true);
                    d3.select(this)
                            .attr("opacity", 1);
                })
        ;
    }

    /**
     *  保存了高考各省份的录取数据，格式为：
     *  {
        "_title": "2013年一本录取率排名",
        "datas": [
            {
                "enter": 1.5447,                //录取总人数，单位万人
                "id": "TIANJIN",                //省份拼音
                "index": 1,                     //录取率排行
                "province": "天津",             //省份
                "rate": "24.52%",               //录取率
                "total": 6.3                    //总的参加高考人数，单位万人
            },
            {
                "enter": 1.7686,
                "id": "BEIJING",
                "index": 2,
                "province": "北京",
                "rate": "24.33%",
                "total": 7.27
            },
            ..... 其他省份的数据
        }

        注意，陕西跟陕西的拼音是一样的，所以陕西这里用SHAANXI，详见：http://www.guokr.com/question/348575/
    */
    var gkData;
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

                    gkData = gks;
                    if(gkData){
                        showTitle();
                        sortByRate();
                    }
                });

    }
</script>
<@nerve.footer>
    <@nerve.aboutme/>
</@nerve.footer>