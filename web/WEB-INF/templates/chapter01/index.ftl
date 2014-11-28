<@nerve.header title="chapter01">
    <@nerve.d3 />
    <style>
        body {margin: 0px; padding: 0px;}
    </style>
</@nerve.header>
<div id="container">
</div>
<script>
    var container,
            width,
            height,
            colors
            ;

    function createChilds(len){
        /*
        生成长度为len的对象数组，数组元素是一个包含了 x，y，width，height 属性的对象
        先使用D3.range 方法得到一个长度为len的数据，其格式为：[0, 1, 2, .... , len-1]
        然后对上述数据调用map方法，得到最终数组
         */
        var data = d3.range(len).map(function(){
           return {
               x:random(width),             //小方框的x坐标
               y:random(height),            //小方框的y坐标
               width:random(100),           //小方框宽度
               height:random(100)           //小方框高度
           };
        });
        //打印data的内容
        console.log("div个数:"+data.length,data);

        container.selectAll("div.child")                            //选择container下的全部class=child的div元素，此时获取的其实是一个空的集合，这里叫他A
                .data(data)                                         //为集合A分配数据，此时，A的长度与data一致，而且每个元素分别对应data中的一个元素
                .enter()                                            //调用enter（）方法，可以理解成进入集合中某一个元素，这里就是div元素
                .append("div")                                      //因为一开始没有div元素，所以要创建一个
                .attr("class","child")                              //给div赋予 child 这个class
                .style("position","absolute")                       //给div设置position属性
                .style("left", function(d){return px(d.x);})      //给div设置左边的位移
                .style("top", function(d){return px(d.y);})       //给div设置顶部的位移
                .style("width", function(d){return px(d.width);}) //给div设置宽度
                .style("height", function(d){return px(d.width);})
                .style("background", function(d, i){               //给div设置背景颜色
                    return colors(i);
                })
                .style("opacity", 0)
                .transition()
                .duration(750)
                .style("opacity", 1)
        ;
        container.selectAll("div.child")
                .data(data)
                .exit()
                .transition()
                .duration(1000)
                .style("opacity", 0)
                .each("end",function(){
                    d3.select(this).remove();
                })

    }

    /**
     * 获取0到max之间的随机整数
     */
    function random(max){
        return (Math.random()*max).toFixed(0);
    }
    function px(v){
        return v+"px";
    }

    window.onload = function(){
        width = window.innerWidth;                  //得到页面宽度
        height = window.innerHeight;                //获取页面高度

        //同时生成随机的颜色值
        colors = d3.scale.category20b();
        //打印颜色
        console.log(colors);
        console.log(colors(0));

        /*
        赋值给container
        同时调用style()方法给container设置相应的style属性
         */
        container = d3.select("#container");
        container.style("position", "relative")
                .style("width", px(width))
                .style("height", px(height))
                .style("overflow",'hidden')
                .on("click",function(){
                    createChilds(random(20));
                })
        ;

        //最后调用页面效果的方法
        createChilds(10);

    }
</script>
<@nerve.footer/>