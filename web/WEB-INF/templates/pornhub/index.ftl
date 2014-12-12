<!DOCTYPE html>
<!-- saved from url=(0042)http://www.pornhub.com/infographic/longest -->
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>PornHub - Who lasts longest?</title>
		<meta name="description" content="PornHub - Who last longest?">
		<meta name="viewport" content="width=device-width, initial-scale=1">

		<script type="text/javascript" src="${JS}/jquery-1.10.2.js"></script>

        <@nerve.d3 />
		<script type="text/javascript" src="${DATA}/pornhub/jquery.qtip.min.js"></script>

		<link type="text/css" rel="stylesheet" href="${DATA}/pornhub/normalize.min.css" media="all">
		<link type="text/css" rel="stylesheet" href="${DATA}/pornhub/jquery.qtip.min.css" media="all">
	<style>
        @charset "utf-8";

        /* ==========================================================================
           Pages
           ========================================================================== */

        .header, .sidebar, .header *, .sidebar *, .qtip-countries, .qtip-countries *{
            -webkit-touch-callout: none;
            -webkit-user-select: none;
            -khtml-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            overflow: hidden;
            font: 13px/16px "Segoe ui", Arial, Helvetica, sans-serif;
            background: #f2f2f2;
            position: relative;
        }

        #d3Effects{
            width: 0;
            height: 0;
            overflow: hidden;
        }

        h1, h2 {
            margin: 0 0 20px;
            font-weight: normal;
            line-height: 1.1;
        }

        h1 {
            font-size: 20px;
        }

        h2 {
            font-size: 16px;
        }

        p {
            margin: 0 0 15px;
        }

        hr {
            display: block;
            height: 1px;
            margin: 20px 0;
            padding: 0;
            border: 0;
            border-top: 1px solid #b0b0b0;
        }

        ul, ol {
            margin: 0;
            padding: 0;
        }

        .header {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            display: block;
            height: 70px;
            overflow: visible;
            padding: 0 0 0 200px;
            background: #f90;
            position: relative;
        }
            .logo {
                position: absolute;
                top: 0;
                left: 0;
                display: block;
                width: 200px;
                height: 70px;
                overflow: hidden;
                text-indent: -9999px;
                background: #000 url("${DATA}/pornhub/logo.png") no-repeat center;
            }

            .nav-wrap {
                float: left;
                display: block;
                width: 100%;
                overflow: visible;
            }

                .nav-wrap .nav {
                    list-style: none;
                    float: left;
                    display: block;
                    width: 80%;
                }

                    .nav-wrap .nav li {
                        float: left;
                        display: block;
                        width: 33%;
                        text-align: center;
                        font: 39px "bebas_neueregular", Arial, Helvetica, sans-serif;
                        background: #f90;
                        position: relative;
                        text-transform: uppercase;
                    }

                        .nav-wrap .nav li a {
                            display: block;
                            height: 65px;
                            overflow: hidden;
                            line-height: 72px;
                            color: #000;
                            text-decoration: none;
                            border-bottom: 5px solid #f90;
                        }

                        .nav-wrap .nav li a:hover {
                            color: #fff;
                            background: black;
                            border-bottom: 5px solid black;
                        }

                        .nav-wrap .nav li a.active {
                            color: #fff;
                            background: #000;
                            border-bottom: 5px solid #cd3e33;
                        }

                        .nav-wrap .nav li .caret {
                            position: absolute;
                            top: 30px;
                            right: 20px;
                            display: inline-block;
                            height: 0;
                            vertical-align: middle;
                            width: 0;
                        }

                        .nav-wrap .nav li .caret-down {
                            border-left: 8px solid transparent;
                            border-right: 8px solid transparent;
                            border-top: 8px solid;

                        }

                        .nav-wrap .nav li .caret-right {
                            border-top: 8px solid transparent;
                            border-bottom: 8px solid transparent;
                            border-left: 8px solid;
                        }

                            .nav-wrap .nav li ul {
                                display: none;
                            }

                            .nav-wrap .nav li:hover ul {
                                position: absolute;
                                top: 70px;
                                left: 0;
                                right: 0;
                                list-style: none;
                                display: block;
                                overflow: hidden;
                                z-index: 2;
                            }

                                .nav-wrap .nav ul li, .nav-wrap .nav ul li a {
                                    display: block;
                                    width: 100%;
                                    overflow: hidden;
                                }

                .nav-wrap .zoom-wrap {
                    float: right;
                    display: block;
                    width: 20%;
                    overflow: hidden;
                    text-align: center;
                }

                    .nav-wrap .zoom-btns {
                        list-style: none;
                        display: inline-block;
                        overflow: hidden;
                        max-width: 140px;
                    }

                        .nav-wrap .zoom-wrap li {
                            float: left;
                            display: block;
                            height: 70px;
                            padding: 15px;
                            line-height: 70px;
                            text-align: center;
                        }

                            .nav-wrap .zoom-wrap li a {
                                display: inline-block;
                                width: 40px;
                                max-width: 100%;
                                height: 40px;
                                overflow: hidden;
                                line-height: 41px;
                                font-size: 48px;
                                font-weight: 700;
                                color: #fff;
                                text-decoration: none;
                                border-radius: 10px;
                                -webkit-border-radius: 10px;
                                -moz-border-radius: 10px;
                                font-family: Arial, Helvetica, sans-serif;
                            }

                            .nav-wrap .zoom-wrap li .zoom-out {
                                background: #4f2f00;
                                line-height: 32px;
                            }

                            .nav-wrap .zoom-wrap li .zoom-out:hover {
                                background: #6f4f20;
                            }

                            .nav-wrap .zoom-wrap li .zoom-in {
                                background: #000;
                            }

                            .nav-wrap .zoom-wrap li .zoom-in:hover {
                                background: #222;
                            }

        .main-wrap {
            position: absolute;
            top: 70px;
            bottom: 0;
            left: 0;
            right: 0;
            clear: both;
            display: block;
            overflow: hidden;
            padding: 0 0 0 200px;
        }

            .sidebar {
                position: absolute;
                top: 0;
                bottom: 0;
                left: 0;
                width: 130px;
                display: block;
                overflow: auto;
                overflow-x: hidden;
                overflow-y: auto;
                padding: 35px;
                background: #e5e5e5;
            }

                     .sidebar h1 {
                        display: block;
                        width: 125px;
                        height: 59px;
                        overflow: hidden;
                        text-indent: -9999px;
                        background: url("${DATA}/pornhub/who_last_longest.png") no-repeat center;
                    }

                .sidebar h2 {
                    font-size: 14px;
                    font-weight: 700;
                    text-transform: uppercase;
                }

                .sidebar .legend_heat_world {
                    list-style: none;
                    display: block;
                    overflow: hidden;
                }

                    .sidebar .legend_heat_world li {
                        display: block;
                        overflow: hidden;
                        margin: 0 0 10px;
                        line-height: 19px;
                    }

                        .sidebar .legend_heat_world li em {
                            float: left;
                            display: block;
                            width: 18px;
                            height: 19px;
                            overflow: hidden;
                            margin: 0 10px 0 0;
                        }

                    .sidebar .legend_heat_world li:nth-child(1) em {
                        background: #991f2b;
                    }

                    .sidebar .legend_heat_world li:nth-child(2) em {
                        background: #cd3e33;
                    }

                    .sidebar .legend_heat_world li:nth-child(3) em {
                        background: #d87a37;
                    }

                    .sidebar .legend_heat_world li:nth-child(4) em {
                        background: #e5bd45;
                    }

                    .sidebar .legend_heat_world li:nth-child(5) em {
                        background: #90b362;
                    }

                    .sidebar .legend_heat_world li:nth-child(6) em {
                        background: #6b995c;
                    }

            .main {
                position: absolute;
                top: 0;
                bottom: 0;
                left: 200px;
                right: 0;
                display: block;
                overflow: hidden;
                font-size: 0;
                text-align: center;
                vertical-align: middle;
            }
                .main #map{
                    width: 100%;
                    height: 100%;
                    margin: 0 auto;
                    padding: 0;
                }

        /* ==========================================================================
           Media Queries
           ========================================================================== */

        @media only screen and (max-width:969px) {
            .nav-wrap .nav li {
                font-size: 28px;
            }

           .nav-wrap .nav li .caret {
                right: 8px;
            }

            .nav-wrap .zoom-wrap li {
                max-width: 44%;
                height: 70px;
                padding: 15px 3%;
            }
        }

        @media only screen and (max-width:800px) {
            .nav-wrap .nav li {
                font-size: 22px;
            }

           .nav-wrap .nav li .caret {
                right: 6px;
            }
        }

        @media only screen and (max-width:640px) {
            .nav-wrap .nav li .caret {
                top: auto;
                bottom: 10px;
                left: 40%;
                right: auto;
            }
        }

        /* ==========================================================================
           BrowseHappy
           ========================================================================== */

        .browsehappy {
            margin: 0.2em 0;
            background: #ccc;
            color: #000;
            padding: 0.2em 0;
        }

        /* ==========================================================================
           Helper classes
           ========================================================================== */

        .clearfix:before,
        .clearfix:after {
            content: " ";
            display: table;
        }

        .clearfix:after {
            clear: both;
        }

        .clearfix {
            *zoom: 1;
        }

        /* ==========================================================================
           Map tooltip
           ========================================================================== */

        .qtip-countries{
            border: none;
            background: transparent;
            float: left;
        }

        .qtip-countries .qtip-content{
            padding: 0;
            text-align: center;
        }

        .qtip-countries .qtip-content .top{
            font-size: 21px;
            font-family: "Segoe ui", Arial, Helvetica, sans-serif;
            color: white;
            border: 3px white solid;
            background: black;
            line-height: 1;
            padding: 7px 10px;
        }

        .qtip-countries .qtip-content .bottom{
            font-size: 14px;
            font-family: "Segoe ui", Arial, Helvetica, sans-serif;
            border: 3px white solid;
            background: black;
            line-height: 1em;
            padding: 5px 7px 5px 7px;
            margin: 0 auto;
            text-align: center;
            border-top: none;
            display: inline-block;
        }

	</style></head>
	
<body data-base-url="${DATA}/pornhub/">
	<!--[if lt IE 9]>
		<p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/" rel="external nofollow" target="_blank">upgrade your browser</a> to improve your experience.</p>
	<![endif]-->

	<div class="header">
		<a href="http://www.pornhub.com/" rel="externalw" class="logo">PornHub</a>
		<div class="nav-wrap">
			<ul class="nav">
				<li id="js_scopeSelection">
					<a href="http://www.pornhub.com/infographic/longest#" rel="world">World Map <span class="caret caret-down"></span></a>
					<ul>
						<li><a href="http://www.pornhub.com/infographic/longest#" rel="usa">U.S. Map <span class="caret caret-right"></span></a></li>
					</ul>
				</li>
				<li><a class="js_displayMode active" rel="countries" href="http://www.pornhub.com/infographic/longest#">Countries</a></li>
				<li><a class="js_displayMode" rel="cities" href="http://www.pornhub.com/infographic/longest#">Cities</a></li>
			</ul>
			<div class="zoom-wrap">
				<ul class="zoom-btns">
					<li><a href="http://www.pornhub.com/infographic/longest#" rel="out" class="zoom-out js_zoomBtn">-</a></li>
					<li><a href="http://www.pornhub.com/infographic/longest#" rel="in" class="zoom-in js_zoomBtn">+</a></li>
				</ul>
			</div>
		</div>
	</div>

	<div class="main-wrap">
		<div class="sidebar">
			<h1>Who last longest?</h1>
			<p>Which states, cities and countries have the most impressive stamina, according to PornHub viewership statistics?</p>
			<hr>
			<h2>Legend</h2>
			<ul class="legend_heat_world"><li><em></em> 05:00 - 06:60</li><li><em></em> 07:00 - 08:60</li><li><em></em> 09:00 - 10:60</li><li><em></em> 11:00 - 12:60</li><li><em></em> 13:00 - 14:60</li><li><em></em> 15:00 - 16:60</li></ul>
		</div>			
		<div class="main">
			<div id="map"></div>
		</div>
	</div>

	<!-- Those are only declarations for the gradient and drop shadow effect -->
	<svg id="d3Effects" xmlns="http://www.w3.org/2000/svg" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink">
		<lineargradient id="gradient">
			<stop offset="19%" stop-color="#ffffff"></stop>
			<stop offset="40%" stop-color="#e5ebef"></stop>
			<stop offset="55%" stop-color="#e5ebef"></stop>
			<stop offset="76%" stop-color="#ffffff"></stop>
		</lineargradient>
		<defs>
			<filter id="dropshadow" height="130%">
				<fegaussianblur in="SourceAlpha" stdDeviation="1"></fegaussianblur>
				<feoffset dx="0" dy="6" result="offsetblur"></feoffset>
				<fecomponenttransfer>
					<fefunca type="linear" slope="0.2"></fefunca>
				</fecomponenttransfer>
				<femerge>
					<femergenode></femergenode>
					<femergenode in="SourceGraphic"></femergenode>
				</femerge>
			</filter>
		</defs>
	</svg>

	<script type="text/javascript" src="${DATA}/pornhub/data.min.js"></script>
	<script type="text/javascript" src="${DATA}/pornhub/main.js"></script>


<div id="qtip-35" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-35-content" aria-hidden="true" data-qtip-id="35" style="z-index: 15001;"><div class="qtip-content" id="qtip-35-content" aria-atomic="true"><div class="top">Canada</div><div style="color: #d87a37;" class="bottom">09:52</div></div></div><div id="qtip-176" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-176-content" aria-hidden="true" data-qtip-id="176" style="z-index: 15002;"><div class="qtip-content" id="qtip-176-content" aria-atomic="true"><div class="top">Russia</div><div style="color: #cd3e33;" class="bottom">07:46</div></div></div><div id="qtip-142" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-142-content" aria-hidden="true" data-qtip-id="142" style="z-index: 15003;"><div class="qtip-content" id="qtip-142-content" aria-atomic="true"><div class="top">Mongolia</div><div style="color: #cd3e33;" class="bottom">08:55</div></div></div><div id="qtip-38" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-38-content" aria-hidden="true" data-qtip-id="38" style="z-index: 15004;"><div class="qtip-content" id="qtip-38-content" aria-atomic="true"><div class="top">China</div><div style="color: #90b362;" class="bottom">14:34</div></div></div><div id="qtip-529" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-529-content" aria-hidden="false" data-qtip-id="529" style="z-index: 15005; opacity: 1;"><div class="qtip-content" id="qtip-529-content" aria-atomic="true"><div class="top">Russia</div><div style="color: #cd3e33;" class="bottom">07:46</div></div></div><div id="qtip-388" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-388-content" aria-hidden="false" data-qtip-id="388" style="z-index: 15006; opacity: 1;"><div class="qtip-content" id="qtip-388-content" aria-atomic="true"><div class="top">Canada</div><div style="color: #d87a37;" class="bottom">09:52</div></div></div><div id="qtip-473" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-473-content" aria-hidden="true" data-qtip-id="473" style="z-index: 15007;"><div class="qtip-content" id="qtip-473-content" aria-atomic="true"><div class="top">Libya</div><div style="color: #cd3e33;" class="bottom">07:55</div></div></div><div id="qtip-414" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-414-content" aria-hidden="true" data-qtip-id="414" style="z-index: 15008;"><div class="qtip-content" id="qtip-414-content" aria-atomic="true"><div class="top">Egypt</div><div style="color: #991f2b;" class="bottom">06:17</div></div></div><div id="qtip-391" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-391-content" aria-hidden="true" data-qtip-id="391" style="z-index: 15010;"><div class="qtip-content" id="qtip-391-content" aria-atomic="true"><div class="top">China</div><div style="color: #90b362;" class="bottom">14:34</div></div></div><div id="qtip-493" class="qtip qtip-default qtip-countries qtip-pos-bc" tracking="true" role="alert" aria-live="polite" aria-atomic="false" aria-describedby="qtip-493-content" aria-hidden="true" data-qtip-id="493" style="z-index: 15009;"><div class="qtip-content" id="qtip-493-content" aria-atomic="true"><div class="top">Myanmar</div><div style="color: #d87a37;" class="bottom">10:54</div></div></div></body></html>