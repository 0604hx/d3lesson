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
<script src="${JS}/nerve/nerve_canvas.1.0.js" type="text/javascript"></script>
<script>
width = window.innerWidth;
height = window.innerHeight;

var demo=(function(){
    var x = 0;
    var y =500.5;
    return {
        update:function(cxt){
            cxt.save();
            cxt.beginPath();
            cxt.strokeStyle = "red";
            cxt.lineWidth = .5;
            cxt.moveTo(0,500.5);
            cxt.lineTo(500,500.5);

            cxt.stroke();

           // cxt.fillRect(400,124, 600,340);
            cxt.restore();

            x+=1;
           // y+=1;
            if(x>width)
                x = 0;
            if(y>=height)
                y=0;
            var r = 7;
            var gradient = cxt.createRadialGradient(x,y,0,x,y,r);

            gradient.addColorStop(0.2, 'rgba(255,0,0,0.9)');
            gradient.addColorStop(0.5, 'rgba(220,0,0,0.3)');
            gradient.addColorStop(1, 'rgba(220,0,0,0)');


            cxt.save();
            cxt.beginPath();
            cxt.arc(x-30, y,r, 0, Math.PI*2, true);
            cxt.arc(x, y,r, 0, Math.PI*2, true);

            cxt.shadowBlur = 10;
            cxt.shadowOffsetX = 3;
            cxt.shadowOffsetY = 3;
            cxt.fillStyle = gradient;
            cxt.fill();

            cxt.restore();
            //console.log("00000");

            var colors = ["ec460c", "1e951e", "2692f7", "ea62f6"];
            var cp1 = 60;
            var cp2 = 160;
            var y1 = 150;

            var ctx = cxt;
            for (var i=0; i< colors.length; i++) {
                ctx.beginPath();
                ctx.moveTo(25,75);
                ctx.bezierCurveTo(25,75,cp1,y1,100,y1);
                //ctx.bezierCurveTo(cp2,y1,120,35,190,35);

                cp1 -= 10;  // 使控制点 1 横坐标左移 10 像素
                cp2 += 10;  // 使控制点 2 横坐标右移 10 像素
                y1 += 20;    // 是曲线低点下降 20 像素

                ctx.strokeStyle = "#" + colors[i];
                // 设置线条颜色
                ctx.stroke();
            }

            y1 = 100;
            for(var i=0;i<colors.length;i++){
                cxt.beginPath();
                cxt.moveTo(400,100);
                cxt.quadraticCurveTo(500,y1,500,y1);
                y1 += 20;
                ctx.strokeStyle = "#" + colors[i];
                // 设置线条颜色
                ctx.stroke();
            }
        }
    }
})();
window.onload = function(){
    d3.select(".loading").classed("hide", true);

    nc.init("canvas", width, height);
    nc.addManager("demo", demo);
}
</script>
<@nerve.footer>
    <@nerve.aboutme/>
</@nerve.footer>