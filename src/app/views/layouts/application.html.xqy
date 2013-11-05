(:
Copyright 2012 MarkLogic Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
:)
xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

declare variable $view as item()* := vh:get("view");
declare variable $sidebar1 as item()* := vh:get("sidebar1");
declare variable $sidebar2 as item()* := vh:get("sidebar2");
declare variable $title as xs:string? := (vh:get('title'), "New Roxy Application")[1];

'<!DOCTYPE HTML>',
<html>
  <head>
    <title>{$title}</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="description" content="" />
    <meta name="keywords" content="" />
    <noscript>
        <link rel="stylesheet" href="/css/5grid/core.css" />
        <link rel="stylesheet" href="/css/5grid/core-desktop.css" />
        <link rel="stylesheet" href="/css/5grid/core-1200px.css" />
        <link rel="stylesheet" href="/css/5grid/core-noscript.css" />
        <link rel="stylesheet" href="/css/style.css" />
        <link rel="stylesheet" href="/css/style-desktop.css" />
    </noscript>
  </head>
  <body>
    <div id="wrapper">
       	<div id="header-wrapper">
       		<header id="header">
       			<div class="5grid-layout">
       				<div id="menu">
       					<nav class="mobileUI-site-nav">
       						<ul>
       							<li class="active"><a href="index.html">Homepage</a></li>
       							<li><a href="threecolumn.html">Three Column</a></li>
       							<li><a href="twocolumn1.html">Two Column #1</a></li>
       							<li><a href="twocolumn2.html">Two Column #2</a></li>
       							<li><a href="onecolumn.html">One Column</a></li>
       						</ul>
       					</nav>
       				</div>
       			</div>
       			<div id="logo-wrapper">
       				<div class="5grid-layout" id="logo" >
       					<div class="row">
       						<div class="12u"> <!-- Logo -->
       							<div>
       								<h1><a href="#" class="mobileUI-site-name">Pronoxml</a><span class="tagline"> by yuxipacific.com</span></h1>
       							</div>
       						</div>
       					</div>
       				</div>
       			</div>
       		</header>
       	</div>
       	<div class="5grid-layout">
       		<div class="row">
       			<div class="12u">
       				<div id="banner">
       					<div class="image-box"><a href="#"><img src="images/img06.jpg" alt=""/></a>
       						<div class="caption"> <span>Phasellus Etiam Consequat Lorem Ipsum Etiam Veroeros</span> <a href="#" class="button">Amet Consequat</a> </div>
       					</div>
       				</div>
       				<div class="shadow"><a href="#"><img src="css/images/img07.jpg" width="1200" height="50" alt="" /></a></div>
       			</div>
       		</div>
       	</div>
       	<div class="divider">&nbsp;</div>
       	<div id="featured-content-wrapper">
       		<div class="12u" id="feature-content">
       			<div class="5grid-layout">
       				<div class="row">
       					<div class="3u">
       						<section class="first">
       							<h2>Blandit Veroeros Consequat</h2>
       							<p>Morbi id urna ut massa vestibulum tempor. faucibus eget nibh. Pellentesque ultricies felis quis est auctor ut dictum sapien adipiscing. Quisque eget tempus nunc. Curabitur venenaSed et gravida diam. Proin adipiscing nisi ac libero fringilla tincidunt consequat sed amet lorem ipsum dolor.</p>
       							<p><a href="#" class="button">Amet Consequat</a></p>
       						</section>
       					</div>
       					<div class="3u">
       						<section>
       							<h2>Blandit Veroeros Consequat</h2>
       							<p>Mauris posuere eros vel metus laoreet auctor. In sodales tincidunt volutpat. Nunc pulvinar massa id risus porta hendrerit. Nunc nec nibh velit, sit amet consectetur neque dolor.</p>
       							<p><a href="#"><img src="images/img09.jpg" alt="" /></a></p>
       						</section>
       					</div>
       					<div class="3u">
       						<section>
       							<h2>Blandit Veroeros Consequat</h2>
       							<p>Mauris posuere eros vel metus laoreet auctor. In sodales tincidunt volutpat. Nunc pulvinar massa id risus porta hendrerit. Nunc nec nibh velit, sit amet consectetur neque dolor.</p>
       							<p><a href="#"><img src="images/img10.jpg" alt="" /></a></p>
       						</section>
       					</div>
       					<div class="3u">
       						<section class="last">
       							<h2>Blandit Veroeros Consequat</h2>
       							<p>Mauris posuere eros vel metus laoreet auctor. In sodales tincidunt volutpat. Nunc pulvinar massa id risus porta hendrerit. Nunc nec nibh velit, sit amet consectetur neque dolor.</p>
       							<p><a href="#"><img src="images/img11.jpg" alt="" /></a></p>
       						</section>
       					</div>
       				</div>
       			</div>
       		</div>
       	</div>
       	<div id="page-wrapper">
      		<div class="divider">&nbsp;</div>
      		<div class="12u">
      			<div class="5grid-layout" id="page">
      				<div class="row">
      					<div class="7u">
      					{
      					    $view
      					}
      					</div>
      					<div class="1u">&nbsp;</div>
      					<div class="2u" id="sidebar1">
      					{
      					    if($sidebar1) then $sidebar1 else "&nbsp;"
      					}
      					</div>
      					<div class="2u">
      					{
      					    if($sidebar2) then $sidebar2 else "&nbsp;"
      					}
      					</div>
      				</div>
      			</div>
      		</div>
        </div>
    </div>
    <div id="copyright">
       	<p>&copy; Pronoxml | Images: <a href="http://fotogrph.com/">Fotogrph</a> | Design: <a href="http://html5templates.com/">HTML5Templates.com</a></p>
    </div>
    <script src="/css/5grid/jquery.js">&nbsp;</script>
    <script src="/css/5grid/init.js?use=mobile,desktop,1000px&amp;mobileUI=1&amp;mobileUI.theme=none&amp;mobileUI.openerWidth=52">&nbsp;</script>
    <!--[if IE 9]><link rel="stylesheet" href="/css/style-ie9.css" />&nbsp;<![endif]-->
  </body>
</html>