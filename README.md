#d3lesson
d3lesson 是D3.js的系列教程源码，旨在分享我在运用D3.js + canvas在数据可视化方面的经验。

项目是在 java8 下开发，使用servlet作为controller，freemarker作视图。

#Chapter 01
这一章的示例代码主要介绍了d3.js的基本使用，如选择元素，动态修改元素属性、样式，为元素添加动画、鼠标事件监听。

示例中包含了d3.js对html元素（div，p，span这些）的操作（增删改），也包含了对svg元素（circle 圆，rect 矩形，line 线条等）的操作。

这里重点说一下d3中的data函数，如下：
```javascript
//创建一个长度为10的整形数组, 得到的是： [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
var data = d3.range(10);
//然后可以利用这个数组，创建10个对应的div元素，数组中的每个对象对应一个div
//这里选取的是class=test的div（好跟其他的div区别开来），在一开始调用selectAll('div.test')得到的其实是一个空集合
//接着调用data方法，就会根据传入对象的长度，创建相应长度的集合（这时集合里面元素都是空的，是给之后的div预留的空位置）
//再接着调用enter()方法，就是进入具体的集合元素里面，这时可以用append（）、insert（）这些方法创建html元素
//创建好div后，就可以给这个div属性赋值了
//在这里，我给div设置了class属性，接着往div中加入了文字。可以看到每个div就对应了上一步创建的数据中的一个元素，可以使用数据元素的数据了
d3.selectAll("div.test")
    .data(data)
    .enter()
    .append("div")
    .attr("class","test")
    .html(function(d){
        return d;
    })
    ;
```

#Chapter 02
这一章是一个应用实例，在中国地图上展示了2013年大陆各省份高考一本录取率的排行数据，使用颜色的深浅来表示录取率的高低。同时也可以对高考人数进行排行。

#about me
我的邮箱：zxingming@qq.com

我的博客：[blog.csdn.net/ssrc0604hx](http://blog.csdn.net/ssrc0604hx)