<@nerve.header title="canvas示例:动态轨迹">
    <@nerve.d3 />
</@nerve.header>
<style>
    body {background: #000;}
</style>
<div class="loading">
    <div class="ball"></div>
    <div class="ball1"></div>
</div>
<canvas id="canvas"></canvas>
<script>
width = window.innerWidth;
height = window.innerHeight;

var canvas = document.getElementById("canvas");
var cxt;

var sp = [100,100],
        ep = [400, 480];
function toDo(){
    var list = getPointList();
    cxt.beginPath();
    cxt.moveTo(list[0][0], list[0][1]);
    for(var i=1;i<list.length;i++){
        cxt.lineTo(list[i][0], list[i][1]);
    }
    cxt.strokeStyle = "red";
    cxt.stroke();
}

function getPointList(){
    var pl = [
            sp,
            ep
    ];
    pl[3] = [ep[0], ep[1]];
    pl[1] = getOffetPoint(pl[0], pl[3]);
    pl[2] = getOffetPoint(pl[3], pl[0]);
    pl = smoothSpline(pl, false);
    pl[pl.length-1] = [ep[0], ep[1]];
    console.log(pl);
    return pl;
}
function getOffetPoint(spp, epp) {
    var distance = Math.sqrt(Math.round((spp[0] - epp[0]) * (spp[0] - epp[0]) + (spp[1] - epp[1]) * (spp[1] - epp[1]))) / 3;
    var mp = [
        spp[0],
        spp[1]
    ];
    var angle;
    var deltaAngle = 0.2;
    if (spp[0] != epp[0] && spp[1] != epp[1]) {
        var k = (epp[1] - spp[1]) / (epp[0] - spp[0]);
        angle = Math.atan(k);
    } else if (spp[0] == epp[0]) {
        angle = (spp[1] <= epp[1] ? 1 : -1) * Math.PI / 2;
    } else {
        angle = 0;
    }
    var dX;
    var dY;
    if (spp[0] <= epp[0]) {
        angle -= deltaAngle;
        dX = Math.round(Math.cos(angle) * distance);
        dY = Math.round(Math.sin(angle) * distance);
        mp[0] += dX;
        mp[1] += dY;
    } else {
        angle += deltaAngle;
        dX = Math.round(Math.cos(angle) * distance);
        dY = Math.round(Math.sin(angle) * distance);
        mp[0] -= dX;
        mp[1] -= dY;
    }
    console.log(spp, epp,mp);
    return mp;
}

/**
 * 使用分层贝叶斯方法构造光滑曲线
 */
function smoothSpline(points, isLoop, constraint) {
    var len = points.length;
    var ret = [];
    var distance = 0;
    //对现有的线段长度进行求和
    for (var i = 1; i < len; i++) {
        distance += getDistance(points[i - 1], points[i]);
    }
    var segs = distance / 5;  //
    segs = segs < len ? len : segs;
    console.log(distance, segs);
    for (var i = 0; i < segs; i++) {
        var pos = i / (segs - 1) * (isLoop ? len : len - 1);
        var idx = Math.floor(pos);
        var w = pos - idx;
        var p0;
        var p1 = points[idx % len];
        var p2;
        var p3;
        if (!isLoop) {
            p0 = points[idx === 0 ? idx : idx - 1];
            p2 = points[idx > len - 2 ? len - 1 : idx + 1];
            p3 = points[idx > len - 3 ? len - 1 : idx + 2];
        } else {
            p0 = points[(idx - 1 + len) % len];
            p2 = points[(idx + 1) % len];
            p3 = points[(idx + 2) % len];
        }
        var w2 = w * w;
        var w3 = w * w2;
        ret.push([
            interpolate(p0[0], p1[0], p2[0], p3[0], w, w2, w3),
            interpolate(p0[1], p1[1], p2[1], p3[1], w, w2, w3)
        ]);
    }
    return ret;
}
function interpolate(p0, p1, p2, p3, t, t2, t3) {
    var v0 = (p2 - p0) * 0.5;
    var v1 = (p3 - p1) * 0.5;
    return (2 * (p1 - p2) + v0 + v1) * t3 + (-3 * (p1 - p2) - 2 * v0 - v1) * t2 + v0 * t + p1;
}
function getDistance(v1, v2) {
    console.log(v1, v2);
    return Math.sqrt((v1[0] - v2[0]) * (v1[0] - v2[0]) + (v1[1] - v2[1]) * (v1[1] - v2[1]));
}

/**
 *
 */
var vector = (function(){
    var ArrayCtor = typeof Float32Array === 'undefined' ? Array : Float32Array;
    var vector = {
        create: function (x, y) {
            var out = new ArrayCtor(2);
            out[0] = x || 0;
            out[1] = y || 0;
            return out;
        },
        copy: function (out, v) {
            out[0] = v[0];
            out[1] = v[1];
            return out;
        },
        set: function (out, a, b) {
            out[0] = a;
            out[1] = b;
            return out;
        },
        add: function (out, v1, v2) {
            out[0] = v1[0] + v2[0];
            out[1] = v1[1] + v2[1];
            return out;
        },
        scaleAndAdd: function (out, v1, v2, a) {
            out[0] = v1[0] + v2[0] * a;
            out[1] = v1[1] + v2[1] * a;
            return out;
        },
        sub: function (out, v1, v2) {
            out[0] = v1[0] - v2[0];
            out[1] = v1[1] - v2[1];
            return out;
        },
        len: function (v) {
            return Math.sqrt(this.lenSquare(v));
        },
        lenSquare: function (v) {
            return v[0] * v[0] + v[1] * v[1];
        },
        mul: function (out, v1, v2) {
            out[0] = v1[0] * v2[0];
            out[1] = v1[1] * v2[1];
            return out;
        },
        div: function (out, v1, v2) {
            out[0] = v1[0] / v2[0];
            out[1] = v1[1] / v2[1];
            return out;
        },
        dot: function (v1, v2) {
            return v1[0] * v2[0] + v1[1] * v2[1];
        },
        scale: function (out, v, s) {
            out[0] = v[0] * s;
            out[1] = v[1] * s;
            return out;
        },
        normalize: function (out, v) {
            var d = vector.len(v);
            if (d === 0) {
                out[0] = 0;
                out[1] = 0;
            } else {
                out[0] = v[0] / d;
                out[1] = v[1] / d;
            }
            return out;
        },
        distance: function (v1, v2) {
            return Math.sqrt((v1[0] - v2[0]) * (v1[0] - v2[0]) + (v1[1] - v2[1]) * (v1[1] - v2[1]));
        },
        distanceSquare: function (v1, v2) {
            return (v1[0] - v2[0]) * (v1[0] - v2[0]) + (v1[1] - v2[1]) * (v1[1] - v2[1]);
        },
        negate: function (out, v) {
            out[0] = -v[0];
            out[1] = -v[1];
            return out;
        },
        lerp: function (out, v1, v2, t) {
            out[0] = v1[0] + t * (v2[0] - v1[0]);
            out[1] = v1[1] + t * (v2[1] - v1[1]);
            return out;
        },
        applyTransform: function (out, v, m) {
            var x = v[0];
            var y = v[1];
            out[0] = m[0] * x + m[2] * y + m[4];
            out[1] = m[1] * x + m[3] * y + m[5];
            return out;
        },
        min: function (out, v1, v2) {
            out[0] = Math.min(v1[0], v2[0]);
            out[1] = Math.min(v1[1], v2[1]);
            return out;
        },
        max: function (out, v1, v2) {
            out[0] = Math.max(v1[0], v2[0]);
            out[1] = Math.max(v1[1], v2[1]);
            return out;
        }
    };
    vector.length = vector.len;
    vector.lengthSquare = vector.lenSquare;
    vector.dist = vector.distance;
    vector.distSquare = vector.distanceSquare;
    return vector;
})();

window.onload = function(){
    d3.select(".loading").classed("hide", true);

    canvas.width = width;
    canvas.height = height;

    cxt = canvas.getContext("2d");
    toDo();
}
</script>
<@nerve.footer>
    <@nerve.aboutme/>
</@nerve.footer>