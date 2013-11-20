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
          <form action="#" method="post" class="cform-form">
            <div class="row">
              <div class="span6 offset3"> 
                <input type="text" name="name" placeholder="Bill Mckoy" class="cform-text" size="40" title="your name" />
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3">
                <input type="text" name="email" placeholder="Email@dominio.com" class="cform-text" size="40" title="your email" />
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3">
                <input type="text" name="password" placeholder="Password" class="cform-text" size="40" title="your password" />
              </div>
            </div>
            <div class="row">
              <div class="span6 offset3">
                <input type="text" name="password-retype" placeholder="Retype Password" class="cform-text" size="40" title="your password" />
              </div>
            </div>
            <div class="row" style="display: inline-table;margin-top: -1.4em;">
              <div class="span6 offset3">
               <input type="checkbox" name="terms" class="cform-check no-margin" /> <span class="muted text"> Accept Terms</span>
              </div>
            </div>
            <div class="row"> 
              <div class="span6 offset3">
                <input type="submit" value="Submit" class="cform-submit"/>
              </div>
            </div>
            <div class="row" style="display: inline-table;margin-top: -1.4em;">
              <div class="span6 offset3">
                <span>{$message}</span>
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