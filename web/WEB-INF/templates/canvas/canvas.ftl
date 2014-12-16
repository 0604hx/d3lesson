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

<script src="${JS}/require.js" type="text/javascript"></script>
<script>
width = window.innerWidth;
height = window.innerHeight;

require.config({
    baseUrl:"${JS}/module/"
});

require(['util'], function(util){

    var self = {"name":"go"};

    console.log(util.clone(self));
});
</script>
<@nerve.footer>
    <@nerve.aboutme/>
</@nerve.footer>