<#global JS=base+"/js"/>
<#global IMAGES = base+"/images"/>
<#global CSS = base+"/css"/>
<#global DATA = base+"/data"/>

<#--头部模板-->
<#macro header title="">
<!DOCTYPE html>
<html>
<head>
    <title><#if title!=''>${title}-</#if>D3系列教程 By 集成显卡</title>
    <meta name="keywords" content="D3 D3.js D3教程 Html5 canvas" />
    <meta name="description" content="D3.js系列教程（JavaEE+freemarker）" />
    <meta name="author" content="集成显卡 zxingming@qq.com" />

    <link href="${CSS}/style.css" rel="stylesheet" />
    <#nested />
</head>
<body>
</#macro>

<#--底部-->
<#macro footer>
    <#nested />
</body>
</html>
</#macro>

<#macro aboutme>
<div class="footer">
    by 集成显卡 1053214511@qq.com
    <a href="blog.csdn.net/ssrc0604hx" target="_blank">我的博客</a>
    建议分辨率：1024*768 以上
</div>
</#macro>