xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

import module namespace cv = "http://www.marklogic.com/roxy/contact-view" at "/app/views/helpers/contact-lib.xqy";

declare variable $username as xs:string? := vh:get("username");
declare variable $message  as xs:string? := vh:get("message");
declare variable $action as xs:string? := vh:get("action");

<section id="contact" class="single-page scrollblock">
  <div class="container">
    <div class="align"><i class="icon-mail-2">&nbsp;</i></div>
    <h1>Contact us now!</h1>
    <div class="row">
      <div class="span12">
      {
        cv:build-form($action, $message)
      }   
      </div>
      <!-- ./span12 -->
    </div>
    <!-- /.row -->
  </div>
  <!-- /.container -->
</section>