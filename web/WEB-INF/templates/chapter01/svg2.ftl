<@nerve.header title="chapter01:创建svg元素2">
    <@nerve.d3 />
<style>

</style>
</@nerve.header>
<div class="controls">
    <button class="control" cmd="circle">创建圆形</button>
    <button class="control" cmd="rect">创建方形</button>
    <button class="control" cmd="line">创建线条</button>
    <button class="control" cmd="clear">删除最近的图形</button>
    <button class="control" cmd="clearAll">清空全部</button>
</div>
<script>
    var container,
            width,
            height,
            colors
            ;
    var mouseDuration = 250,        //鼠标移动动画时长
            duration = 1000;

    var
            count = 0,          //当前存在的元素个数
            g;              //svg 中的g元素，随机图形都在这个g中绘制。关于scg g元素的介绍，请见：http://tutorials.jenkov.com/svg/g-element.html

    /**
     * 获取0到max之间的随机整数
     */
    function random(max){
        return parseInt((Math.random()*max));
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

    function init(){
        buildG();

        //绑定点击事件
        d3.selectAll(".controls .control")
                .on("click", function(){
                    var cmd = d3.select(this)
                            .attr("cmd")
                    ;
                    work(cmd);
                })
        ;
    }

    /**
     * 创建G元素
     */
    function buildG(){
        g = container.append("g");
        g.attr("class", "group")
        ;
    }

    /**
     * 根据cmd命令在执行任务
     */
    function work(cmd){
        cmd = cmd ||'';
        //随机画一个圆形
        if(cmd=='circle'){
            var c = g.append("circle")
                            .attr("class", "child")
                            .attr("cx", random(width))
                            .attr("cy", random(height))
                            .attr("r", random(100) + 20)
                            .attr("fill", colors(count))
            ;
            count ++;
        }
        else if(cmd=='rect'){
            var w = random(100)+20;
            var r = g.append("rect")
                            .attr("class", "child")
                            .attr("x", random(width))
                            .attr("y", random(height))
                            .attr("width", w)
                            .attr('height', w)
                            .attr("fill", colors(count))
                    ;
            count ++ ;
        }
        //随机线条
        else if(cmd=='line'){
            var l= g.append("line")
                            .attr("class", "child")
                            .attr("x1", random(width))
                            .attr("y1", random(height))
                            .attr("x2", random(width))
                            .attr("y2", random(height))
                            .attr("stroke", colors(count))
            ;
            count ++;
        }
        //清除最近添加的元素
        else if(cmd=='clear'){
                lastest.attr("opacity", 1)
                        .transition()
                        .duration(duration)
                        .attr("opacity", 0)
                        .each("end", function(){
                            d3.select(this)
                                    .remove();
                        })
            ;
        }
        //清空全部的元素
        else if(cmd=='clearAll'){
            g.selectAll(".child")
                    .attr("opacity", 1)
                    .transition()
                    .duration(duration)
                    .delay(function(d,i){
                        return 50*i;
                    })
                    .attr("opacity", 0)
                    .each("end", function(){
                        d3.select(this)
                                .remove();
                    })
        }
    }

    window.onload = function(){
        width = window.innerWidth;                  //得到页面宽度
        height = window.innerHeight;                //获取页面高度

        //同时生成随机的颜色值
        colors = d3.scale.category20b();

        createSVG("container",width,height);
        /*
        赋值给container
        同时调用style()方法给container设置相应的style属性
         */
        container = d3.select("#container");

        init();
    }
</script>
<@nerve.footer/>