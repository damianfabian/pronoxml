xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

import module namespace uv = "http://www.marklogic.com/roxy/user-view" at "/app/views/helpers/user-lib.xqy";

declare variable $username as xs:string? := vh:get("username");
declare variable $message  as xs:string? := vh:get("message");
declare variable $loggedin as xs:string? := vh:get("loggedin");

<section id="contact" class="single-page scrollblock">
  <div class="container">
    <h1>Come back soon</h1>
  </div>
  <!-- /.container -->
</section>