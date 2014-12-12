var PHM = (function() {
    var c = {
        mapScope: "world",
        mapDisplayMode: "countries",
        mapOptions: {
            countries: {
                mapBackgroundColor: "#f2f2f2",
                mapItemsColor: "#991f2b",
                strokeColor: "#fff"
            },
            cities: {
                mapBackgroundColor: "#7598af",
                mapItemsColor: "url(#gradient)",
                strokeColor: "#ccc"
            }
        },
        minZoomLevel: 1,
        maxZoomLevel: 50,
		//这个就是我说的很想避孕套的图标了
        cityIcon: "5.9,-1.2 5.9,-3.5 5.9,-3.5 5.9,-8 4.7,-8 4.7,-9.2 4.2,-9.2 4.2,-8 3.1,-8 3.1,-2.7 2.3,-2.7 2.3,-3.2 2.3,-4.7 2.3,-6.3 0.4,-7.4 -1.2,-6.3 -1.2,-1.9 -2.2,-1.9 -2.2,-7.3 -3.8,-8 -3.8,-9 -4.2,-9 -4.2,-8 -5.9,-7.3	-5.9,-3.2 -5.9,-3.2 -5.9,-1.2 -7.1,-1.2 -7.1,0 7.1,0 7.1,-1.2",
        cityIconScale: "1.7",
        legend: {
            color: {
                1 : "991f2b",
                2 : "cd3e33",
                3 : "d87a37",
                4 : "e5bd45",
                5 : "90b362",
                6 : "6b995c"
            },
            range: {
                world: {
                    1 : {
                        min: 5,
                        max: 6.59
                    },
                    2 : {
                        min: 7,
                        max: 8.59
                    },
                    3 : {
                        min: 9,
                        max: 10.59
                    },
                    4 : {
                        min: 11,
                        max: 12.59
                    },
                    5 : {
                        min: 13,
                        max: 14.59
                    },
                    6 : {
                        min: 15,
                        max: 16.59
                    }
                },
                usa_countries: {
                    1 : {
                        min: 9.2,
                        max: 9.39
                    },
                    2 : {
                        min: 9.4,
                        max: 9.59
                    },
                    3 : {
                        min: 10,
                        max: 10.19
                    },
                    4 : {
                        min: 10.2,
                        max: 10.39
                    },
                    5 : {
                        min: 10.4,
                        max: 10.59
                    },
                    6 : {
                        min: 11,
                        max: 11.29
                    }
                },
                usa_cities: {
                    1 : {
                        min: 4.3,
                        max: 7.29
                    },
                    2 : {
                        min: 7.3,
                        max: 10.29
                    },
                    3 : {
                        min: 10.3,
                        max: 13.29
                    },
                    4 : {
                        min: 13.3,
                        max: 16.29
                    },
                    5 : {
                        min: 16.3,
                        max: 19.29
                    },
                    6 : {
                        min: 19.3,
                        max: 22.29
                    }
                }
            }
        }
    };
    var m, //svg对象
		r, //放置地图的 g 集合
		u, //坐标转换器
		n,	//path
		a,	//zoom元素
		e;	//地图块数据
    var o, l;
	
	//绘制地图
    function j() {
        o = $("#map").width();
        l = $("#map").height();
        d3.json($("body").data("base-url") + c.mapScope + ".json",
        function(w) {
            m = d3.select("#map").append("svg").attr("width", o).attr("height", l);
            $("#map").css("background", c.mapOptions[c.mapDisplayMode].mapBackgroundColor).css("cursor", "move");
            r = m.append("g");
            if (c.mapScope == "world") {
                u = d3.geo.mercator().translate([0, 0]).scale(1).rotate([ - 11.5, 0])
            } else {
                u = d3.geo.albersUsa().translate([0, 0]).scale(1)
            }
            e = topojson.feature(w, w.objects[(c.mapScope == "world") ? "collection": "usa"]);
            e.features = e.features.filter(function(x) {
                return x.id !== 11;
            });
            var g = r.selectAll(".country").data(e.features);
            n = d3.geo.path().projection(u);
            q();
            if (c.mapDisplayMode == "cities") {
                r.append("path").datum(topojson.merge(w, w.objects[(c.mapScope == "world") ? "collection": "usa"].geometries.filter(function(x) {
                    return x.id !== 11
                }))).attr("class", "dropshadow").attr("d", n).style("fill", "#5e8fa7").attr("width", o).attr("height", l).attr("transform", "translate(0,5)")
            }
            g.enter().append("path").attr("class", "country").attr("d", n).attr("id",
            function(y, x) {
                return "c" + y.id
            });
			
            d3.selectAll("path.country").attr("class", "country")
				//给地图块上色，函数的z参数，就是对应元素的data对象(由之前调用data()函数分配）
				.style("fill",function(z) {
					if (c.mapDisplayMode == "countries") {
						//或者具体的时间长， 数据结构在  data.min.js
						var y = mapTimeData[c.mapScope][c.mapDisplayMode][z.id].t;
						var x = d(y);
						return x
					} else {
						return c.mapOptions[c.mapDisplayMode].mapItemsColor
					}
				})
				.style("stroke-width", 1).style("stroke", c.mapOptions[c.mapDisplayMode].strokeColor);
            p();
            
			/*
			一下的3行代码是设置svg的滚轮放大效果
			*/
			d3.behavior.zoom();
            a = d3.behavior.zoom().scaleExtent([c.minZoomLevel, c.maxZoomLevel]).on("zoom", k);
            m.call(a).call(a.event)
        });
    }
	//判断颜色级别
	function d(x) {
        if (c.mapScope == "usa") {
            var w = "usa_" + c.mapDisplayMode
        } else {
            var w = "world"
        }
        var g = false;
        for (i = 1; i <= 6; i++) {
            if (x >= c.legend.range[w][i].min && x <= c.legend.range[w][i].max) {
                g = c.legend.color[i];
                break
            }
        }
        return "#" + g
    }
	
	/**
	完成地图的位移，不然页面时显示不出地图的
	转换过程：
	1. 先获取地图中总的边框大小 (这个时候，path出来的矩形是很小的，需要进行放大）
	2. 计算放大的比例， 就是计算两个矩形的长宽比例，这个很容易理解，不多解释，在下面列出来两种计算方法A跟B
	3. 计算位移， 就是放大的地图后，需要x，y轴移动多少才能显示到用户看到的地图区域、
	4. 执行转换
	*/
    function q(w) {
        var w = w || false;
        var g = n.bounds(e);																//步骤1
		console.log(g);
        //var y = 0.9/Math.max((g[1][0] - g[0][0]) / o, (g[1][1] - g[0][1]) / l);			//步骤2 方法A
		var y = Math.min(o/(g[1][0] - g[0][0]), l/(g[1][1] - g[0][1]));						//步骤2 方法B
        var x = [(o - y * (g[1][0] + g[0][0])) / 2, (l - y * (g[1][1] + g[0][1])) / 2];	
		console.log(x,y);
        if (w) {
            a.scale(y).translate(x).event(m)
        } else {
            u.scale(y).translate(x)
        }
    }
	/*
	使用qtip 来创建鼠标移动的提示
	小弟在以前的项目中也用过qtip，这个挺好用的
	*/
    function p() {
        if (c.mapDisplayMode == "countries") {
            $("path.country").qtip({
                content: {
                    text: function(B, z) {
                        var C = B.target.id.substring(1);
                        var x = mapTimeData[c.mapScope].countries[C].n;
                        var A = mapTimeData[c.mapScope].countries[C].t;
                        var w = d(A);
                        var y = '<div class="top">' + x + '</div><div style="color: ' + w + ';" class="bottom">' + t(String(A.toFixed(2))) + "</div>";
                        return y
                    }
                },
                position: {
                    target: "mouse",
                    adjust: {
                        y: -10
                    },
                    my: "bottom center"
                },
                style: {
                    classes: "qtip-countries"
                }
            });
            d3.selectAll("path.country").style("cursor", "help")
        } else {
			//如果是城市模式，就给城市所在的地点上创建一个小图标（邪恶的我，将这些小图标看成了避孕套。。。）
			//创建好之后，对这些小图标进行qtip操作
            var g = mapTimeData[c.mapScope].cities;
            g.forEach(function(y, x) {
                var w = r.append("g").attr("title", y.n).attr("id", "city_" + x).attr("class", "cities").style("cursor", "help");
                w.append("circle").attr("r", 9).attr("cy", -4).style("fill", "transparent");
                w.append("polygon").attr("points", c.cityIcon).attr("stroke-width", 0).style("fill",
                function() {
                    return d(y.t)
                });
                w.attr("transform", "translate(" + u([y.lng, y.lat])[0] + "," + u([y.lng, y.lat])[1] + ")scale(" + c.cityIconScale + ")")
            });
            $("g.cities").qtip({
                content: {
                    text: function(B, z) {
                        var C = $(B.target).parent()[0].id.substring(5);
                        var x = mapTimeData[c.mapScope].cities[C].n;
                        var A = mapTimeData[c.mapScope].cities[C].t;
                        var w = d(A);
                        var y = '<div class="top">' + x + '</div><div style="color: ' + w + ';" class="bottom">' + t(String(A.toFixed(2))) + "</div>";
                        return y
                    }
                },
                position: {
                    target: "mouse",
                    adjust: {
                        y: -10
                    },
                    my: "bottom center"
                },
                style: {
                    classes: "qtip-countries"
                }
            })
        }
    }
    
    function h() {
        if (c.mapScope == "usa") {
            var w = "usa_" + c.mapDisplayMode
        } else {
            var w = "world"
        }
        var g = $("ul.legend_heat_world");
        g.html("");
        $.each(c.legend.range[w],
        function(x, y) {
            g.append("<li><em></em> " + t(c.legend.range[w][x].min.toFixed(2)) + " - " + t((c.legend.range[w][x].max + 0.01).toFixed(2)) + "</li>")
        })
    }
    function t(g) {
        var x = g.split(".");
        var y = x[0];
        var w = x[1];
        if (y.length == 1) {
            y = "0" + y
        }
        return y + ":" + w
    }
    function v() {
        j();
        f()
    }
    function f() {
        d3.selectAll(".js_zoomBtn").on("click", b);
        var g;
        $(window).on("resize",
        function() {
            clearTimeout(g);
            g = setTimeout(function() {
                $("#map").remove();
                $(".main").append($("<div>", {
                    id: "map"
                }));
                j()
            },
            500)
        });
        $("#js_scopeSelection").on("click", "a",
        function(x) {
            if ($(this).attr("rel") == c.mapScope) {
                return false
            }
            var w = $("#js_scopeSelection");
            c.mapScope = $(this).attr("rel");
            w.html("");
            w.prepend($("<a>", {
                href: "#",
                rel: (c.mapScope == "world") ? "usa": "world",
                html: ((c.mapScope == "world") ? "U.S. Map": "World Map") + ' <span class="caret caret-right"></span>'
            }));
            w.find("a").wrap($("<ul>")).wrap($("<li>"));
            w.append($("<a>", {
                href: "#",
                rel: (c.mapScope == "world") ? "world": "usa",
                html: ((c.mapScope == "world") ? "World Map": "U.S. Map") + ' <span class="caret caret-down"></span>'
            }));
            $("#map").remove();
            $(".main").append($("<div>", {
                id: "map"
            }));
            j();
            h();
            x.preventDefault()
        });
        $("ul.nav").on("click", "a.js_displayMode",
        function(w) {
            c.mapDisplayMode = $(this).attr("rel");
            $("a.js_displayMode").removeClass("active");
            $(this).addClass("active");
            $("#map").remove();
            $(".main").append($("<div>", {
                id: "map"
            }));
            j();
            h();
            w.preventDefault()
        });
        h()
    }
	
	/**
	由点击按钮触发的地图缩小或者放大
	*/
    function b() {
        var z = d3.event.target,
        C = 1,
        A = 0.2,
        y = 1,
        g = [o / 2, l / 2],
        E = a.scaleExtent(),
        w = a.translate(),
        D = [],
        x = [],
        B = {
            x: w[0],
            y: w[1],
            k: a.scale()
        };
        d3.event.preventDefault();
        C = (this.rel === "in") ? 1 : -1;
        y = a.scale() * (1 + A * C);
        if (y < E[0] || y > E[1]) {
            return false
        }
        D = [(g[0] - B.x) / B.k, (g[1] - B.y) / B.k];
        B.k = y;
        x = [D[0] * B.k + B.x, D[1] * B.k + B.y];
        B.x += g[0] - x[0];
        B.y += g[1] - x[1];
        s([B.x, B.y], B.k)
    }
    function s(x, w) {
        var g = this;
        return d3.transition().duration(350).tween("zoom",
        function() {
            var z = d3.interpolate(a.translate(), x),
            y = d3.interpolate(a.scale(), w);
            return function(A) {
                a.scale(y(A)).translate(z(A)).event(m)
            }
        })
    }
	
	/**
	缩放时调用的函数
	*/
    function k() {
        var x = d3.event.translate;
        var z = d3.event.scale;
        var y = l / 1.3;
        var g = o / 1.4;
        x[0] = Math.min(o / 2 * (z - 1) + g * z, Math.max(o / 2 * (1 - z) - g * z, x[0]));
        x[1] = Math.min(l / 2 * (z - 1) + y * z, Math.max(l / 2 * (1 - z) - y * z, x[1]));
        r.attr("transform", "translate(" + x + ")scale(" + z + ")").selectAll("path").style("stroke-width", 1 / d3.event.scale + "px");
		
		//这一步是设置了地图上的套子图标不跟随总地图的放大而放大，删除以下代码的话，在总地图放大后，小图标也会很大，影响视觉
	    d3.selectAll(".cities").attr("transform",
        function() {
            var w = d3.transform(d3.select(this).attr("transform"))["translate"];
            return "translate(" + w[0] + "," + w[1] + ")scale(" + 1 / (d3.event.scale / c.cityIconScale) + ")"
        })
    }
	
	
    return {
        init: function() {
            v()
        }
    }
})();
$(document).ready(function() {
    PHM.init()
});