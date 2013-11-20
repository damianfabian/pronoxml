xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";
import module namespace uv = "http://www.marklogic.com/roxy/user-view" at "/app/views/helpers/user-lib.xqy";

declare option xdmp:mapping "false";

declare variable $message         := vh:get("message");

<section id="contact" class="single-page scrollblock">
  <div class="container">
    <h1>Register</h1>
    <div class="row">
      <div class="span12">
        <div class="cform" id="theme-form">
          <form action="/user/register" method="post" class="cform-form" id="register-form">
            <div class="row">
              <div class="span6 offset3"> 
                <div class="error" style="display:none;">
                    <span></span>.<br clear="all"/>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3"> 
                <input type="text" name="username" placeholder="Username" class="cform-text alphanumeric required" size="40"  />
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3"> 
                <input type="text" name="name" placeholder="Bill Mckoy" class="cform-text text required" size="40" title="your name" />
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3">
                <input type="text" name="email" placeholder="Email@dominio.com" class="cform-text text required email" size="40" title="your email" />
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3">
                <input type="password" name="password1" id="password1" placeholder="Password" class="cform-text required password" size="40" />
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3">
                <input type="password" name="password2" id="password2" placeholder="Retype Password" equalTo="#password1" class="cform-text required" size="40" title="your password" />
              </div>
            </div>
            <div class="row" style="display: inline-table;margin-top: -1.4em;">
              <div class="span6 offset3">
               <span class="muted text"> Accept Terms</span> &nbsp;<input type="checkbox" name="terms" class="cform-check no-margin required" title="Please accept the terms"/> 
              </div>
            </div>
            <div class="row"> 
              <div class="span6 offset3">
                <input type="submit" value="Submit" class="cform-submit"/>
              </div>
            </div>
            <div class="row" style="display: inline-table;margin-top: -1.4em;">
              <div class="span6 offset3">
                <span class="muted">{$message}</span>
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
