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

module namespace uv = "http://www.marklogic.com/roxy/user-view";

import module namespace form = "http://marklogic.com/roxy/form-lib" at "/app/views/helpers/form-lib.xqy";

(:declare default element namespace "http://www.w3.org/1999/xhtml";:)

declare option xdmp:mapping "false";

declare function uv:build-user($username, $message, $login-link, $register-link, $logout-link)
{
                
   let $loggedInUser := xdmp:get-session-field("logged-in-user")
   return
   if ($loggedInUser ne "") then
   (    
        <li><a title="portfolio" href="#portfolio">Portfolio</a></li>,
        <li><a title="services" href="#services">Services</a></li>,
        <li><a title="news" href="#news">News</a></li>,
        <li><a title="team" href="#team">Team</a></li>,
        <li><a title="contact" href="#contact">Contact</a></li>,
        <li><a title="User" href="#">{$username}</a></li>,
        <li><a href="{$logout-link}" class="logout">Logout</a></li>
       
    )    
    else
    (    
        <li class="loginbar">{uv:build-login($login-link,$register-link, $message)}</li>,
        <li class="loginlinks"><a href="#" class="loginlink">Login</a></li>,
        <li class="loginlinks"><a href="{$register-link}" class="registerlink">Register</a></li>
     )
 };

declare function uv:welcome($username, $profile-link, $logout-link)
{
  <div class="user">
    <div class="welcome">Welcome,<a href="{$profile-link}">{$username}</a>&nbsp;</div>
    <a href="{$logout-link}" class="logout">logout</a>
  </div>
};

declare function uv:build-login($login-link, $register-link, $message)
{
  <div class="login-form">
    <span class="lblerror">{fn:normalize-space($message)}</span>
    <form action="{$login-link}" method="POST" id="login">
      <input type="text" class="pull-left text required"  name="username" placeholder="username" />
      <input type="password" class="pull-left text required" name="password" placeholder="*******" />
      <input type="submit" value="Login"/>
      <input type="button" class="button" value="Cancel" id="login-cancel" />
    </form>
  </div>
};
