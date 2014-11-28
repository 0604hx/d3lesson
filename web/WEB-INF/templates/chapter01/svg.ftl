<@nerve.header title="chapter01:创建svg元素">
    <@nerve.d3 />
</@nerve.header>
<script>
    var container,
            width,
            height,
            colors
            ;
    var mouseDuration = 250,        //鼠标移动动画时长
            duration = 1000;

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

        container.selectAll("rect.child")                            //选择container下的全部class=child的div元素，此时获取的其实是一个空的集合，这里叫他A
                .data(data)                                         //为集合A分配数据，此时，A的长度与data一致，而且每个元素分别对应data中的一个元素
                .enter()                                            //调用enter（）方法，可以理解成进入集合中某一个元素，这里就是div元素
                .append("rect")                                      //因为一开始没有div元素，所以要创建一个
                .attr("class","child")                              //给div赋予 child 这个class
                .attr("x", function(d){return px(d.x);})      //给div设置左边的位移
                .attr("y", function(d){return px(d.y);})       //给div设置顶部的位移
                .attr("width", function(d){return px(d.width);}) //给div设置宽度
                .attr("height", function(d){return px(d.width);})
                .attr("fill", function(d, i){               //给div设置背景颜色
                    return colors(i);
                })
                .on("mouseenter",function(e){
                    var t = d3.select(this);
//                    t.transition().stop();
                    t.transition()
                            .duration(mouseDuration)
                            .attr("x", parseInt(t.attr("x"))-4)
                            .attr("y", parseInt(t.attr("y"))-4)
                            .attr("width", parseInt(t.attr("width"))+8)
                            .attr("height", parseInt(t.attr("height"))+8)
                    ;
                    d3.event.stopPropagation();
                })
                .on("mouseout",function(e){
                    var t = d3.select(this);
                    t.transition()
                            .duration(mouseDuration)
                            .attr("x", parseInt(t.attr("x"))+4)
                            .attr("y", parseInt(t.attr("y"))+4)
                            .attr("width", parseInt(t.attr("width"))-8)
                            .attr("height", parseInt(t.attr("height"))-8)
                    ;
                    d3.event.stopPropagation();
                })
                .style("opacity", 0)
                .transition()
                .duration(duration)
                .style("opacity", 1)
        ;

        //因为data长度是变动的，如果data长度由大变小，那么div.child 就会有多余的
        //这是就将多余的div剔除，剔除前，来一个动态效果（透明度慢慢降低到隐藏）
        //在each() 方法中加入动画播放完的监听函数， 通过d3.select(this)获取到当前的div
        //最后调用remove（）方法，将元素从dom中删除
        container.selectAll("rect.child")
                .data(data)
                .exit()
                .transition()
                .duration(duration)
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
        ;
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
        container
                .on("click",function(){
                    createChilds(random(20));
                })
        ;

        //最后调用页面效果的方法
        createChilds(10);

    }
</script>
<@nerve.footer/>