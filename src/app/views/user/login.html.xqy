xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

import module namespace uv = "http://www.marklogic.com/roxy/user-view" at "/app/views/helpers/user-lib.xqy";

declare variable $username as xs:string? := vh:get("username");
declare variable $message  as xs:string? := vh:get("message");
declare variable $loggedin as xs:string? := vh:get("loggedin");

<section id="contact" class="single-page scrollblock">
  <div class="container">
    <h1>Login</h1>
    <div class="row">
      <div class="span12">
        <div class="cform" id="theme-form">
          <form action="/user/login" method="post" class="cform-form" id="login-form">
            <div class="row">
              <div class="span6 offset3"> 
                <label class="lblerror">{$message}</label>
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3"> 
                <input type="text" name="username" placeholder="Your Username" class="cform-text required" size="40" title="Username" />
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3">
                <input type="password" name="password" placeholder="********" class="cform-text required" size="40" title="Password" />
              </div>
            </div>
            <div class="row" style="display: inline-table;margin-top: -1.4em;">
              <div class="span6 offset3">
               <input type="checkbox" name="remember" class="cform-check no-margin" /> <span class="muted text"> Keep me signed in</span>
              </div>
            </div>
            <div class="row"> 
              <div class="span6 offset3">
                <input type="submit" value="Login" class="cform-submit"/>
              </div>
            </div>
            <div class="cform-response-output">&nbsp;</div>
          </form>
        </div>
      </div>
      <!-- ./span12 -->
    </div>
    <!-- /.row -->
  </div>
  <!-- /.container -->
</section>