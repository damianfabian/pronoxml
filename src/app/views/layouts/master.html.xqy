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

import module namespace uv = "http://www.marklogic.com/roxy/user-view" at "/app/views/helpers/user-lib.xqy";

declare variable $view as item()* := vh:get("view");
declare variable $title as xs:string? := (vh:get('title'), "Pronoxml")[1];
declare variable $appName as xs:string? := (vh:get('appName'), "Pronoxml")[1];
declare variable $javascripts as item()* := (vh:get('javascripts'), ())[1];

declare variable $username as xs:string? := (vh:get("username"),xdmp:get-session-field("username"))[1] ;
declare variable $message  as xs:string? := vh:get("message");
declare variable $loggedin as xs:string? := vh:get("loggedin");


'<!DOCTYPE HTML>',
<html lang="en">
    <head>
    <meta charset="utf-8"/>
    <title>{$title}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>
    <!-- Styles -->
    <!-- Favicon -->
    <link rel="shortcut icon" href="img/favicon.ico"/>
    <link href="/css/bootstrap.css" rel="stylesheet"/>
    <link href="/css/style.css" rel="stylesheet"/>
    <link rel='stylesheet' id='prettyphoto-css'  href="/css/prettyPhoto.css" type='text/css' media='all'/>
    <link href="/css/fontello.css" type="text/css" rel="stylesheet"/>
    <!--[if lt IE 7]>
            <link href="/css/fontello-ie7.css" type="text/css" rel="stylesheet"/>  
        <![endif]-->
    <!-- Google Web fonts -->
    <link href='http://fonts.googleapis.com/css?family=Quattrocento:400,700' rel='stylesheet' type='text/css'/>
    <link href='http://fonts.googleapis.com/css?family=Patua+One' rel='stylesheet' type='text/css'/>
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'/>
    <link href="/css/bootstrap-responsive.css" rel="stylesheet"/>
    <link href="/css/jquery-ui.css" rel="stylesheet"/>
    </head>
    <body>
    <!--******************** NAVBAR ********************-->
    <div class="navbar-wrapper">
      <div class="navbar navbar-inverse navbar-fixed-top">
        <div class="navbar-inner">
          <div class="container">
            <!-- Responsive Navbar Part 1: Button for triggering responsive navbar (not covered in tutorial). Include responsive CSS to utilize. -->
            <a class="btnApp btn-navbar" data-toggle="collapse" data-target=".nav-collapse"> 
                <span class="icon-bar">&nbsp;</span> 
                <span class="icon-bar">&nbsp;</span> 
                <span class="icon-bar">&nbsp;</span> 
            </a>
            <h1 class="brand"><a href="/">{$appName}</a></h1>
            <!-- Responsive Navbar Part 2: Place all navbar contents you want collapsed withing .navbar-collapse.collapse. -->
            <nav class="pull-right nav-collapse collapse">
              <ul id="menu-main" class="nav">
               {
                uv:build-user($username, $message, "/user/login", "/user/register", "/user/logout")
              }
              </ul>
            </nav>
          </div>
          <!-- /.container -->
        </div>
        <!-- /.navbar-inner -->
      </div>
      <!-- /.navbar -->
    </div>
    <!-- /.navbar-wrapper -->
    <div id="top">&nbsp;</div>
   
    {
        $view
    }
    <div class="footer-wrapper">
      <div class="container">
        <footer>
          <small>&copy; 2013 Yuxipacific Latam SAS. Todos los derechos reservados.</small>
        </footer>
      </div>
      <!-- ./container -->
    </div>
    
    <!-- Loading the javaScript at the end of the page -->
    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
   
    <!--[if lt IE 9]>
          <script src="http://html5shim.googlecode.com/svn/trunk/html5.js">&nbsp;</script>
        <![endif]-->
   
    <!-- JQuery -->
    <script type="text/javascript" src="/js/jquery.js">&nbsp;</script>
    <script type="text/javascript" src="/js/jquery-ui.js">&nbsp;</script>
    <script type="text/javascript" src="/js/jquery.validate.js">&nbsp;</script>
    <!-- Load ScrollTo -->
    <script type="text/javascript" src="/js/jquery.scrollTo-1.4.2-min.js">&nbsp;</script>
    <!-- Load LocalScroll -->
    <script type="text/javascript" src="/js/jquery.localscroll-1.2.7-min.js">&nbsp;</script>
    <script type="text/javascript" src="/js/bootstrap.js">&nbsp;</script>
    <script type="text/javascript" src="/js/jquery.prettyPhoto.js">&nbsp;</script>
    <script type="text/javascript" src="/js/site.js">&nbsp;</script>
    {
        for $x in $javascripts/script
        return $x
    }
    </body>
</html>
