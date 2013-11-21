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

module namespace c = "http://marklogic.com/roxy/controller/user";

(: the controller helper library provides methods to control which view and template get rendered :)
import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";

(: The request library provides awesome helper methods to abstract get-request-field :)
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace error = "http://marklogic.com/roxy/error-lib" at "../views/helpers/error-lib.xqy";
import module namespace usr   = "http://marklogic.com/roxy/models/user" at "/app/models/user-model.xqy";
import module namespace auth  = "http://marklogic.com/roxy/models/authentication" at "/app/models/authentication.xqy";

import module namespace json   = "http://marklogic.com/json" at "/roxy/lib/json.xqy";

import module namespace cfg    = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";

declare option xdmp:mapping "false";

(:
 : Usage Notes:
 :
 : use the ch library to pass variables to the view
 :
 : use the request (req) library to get access to request parameters easily
 :
 :)
declare function c:main() as item()*
{
  let $delete   := req:get("delete", "", "type=xs:string")
  let $edit     := req:get("edit", "", "type=xs:string")
  let $reset    := req:get("reset", "", "type=xs:string")
  let $loggedin := req:get("loggedin", "", "type=xs:string")

  let $user  := 
    if ($edit ne "") then
      usr:get($edit)
    else
      element user-profile
      {
        element firstname { fn:normalize-space(req:get("firstname", "", "type=xs:string")) }, 
        element lastname  { fn:normalize-space(req:get("lastname", "", "type=xs:string")) }, 
        element username  { fn:normalize-space(req:get("username", "", "type=xs:string")) }, 
        element password  { fn:normalize-space(req:get("password", "", "type=xs:string")) },
        element created   { fn:normalize-space(req:get("created", "", "type=xs:string")) }
      }

  let $message := 
    if ($edit ne "") then
    (
      if (($user/firstname eq "") or ($user/lastname eq "") or ($user/username eq "") or ($user/password eq "")) then
        "Please fill in all fields."
      else
        "Press update button to save."
    )
    else
    if ($delete ne "") then
      usr:delete($delete)
    else
    (
      if (($user/firstname eq "") or ($user/lastname eq "") or ($user/username eq "") or ($user/password eq "")) then
        "Please fill in all fields."
      else
        usr:save($user)
    )

  let $edituser := if (($reset ne "") or (fn:starts-with($message, "User Success"))) then () else $user
  let $userlist := usr:getUserList()

  return
  (
    ch:add-value("message", $message),
    ch:add-value("userlist", $userlist),
    ch:add-value("edit", $edit),
    ch:add-value("user", $edituser),
    ch:use-view((), "xml"),
	ch:use-layout(())
  )
  
};

declare function c:register() as item()*
{
    let $user  :=   element user-profile
                    {
                      element username { fn:normalize-space(req:get("username", "", "type=xs:string")) },
                      element name { fn:normalize-space(req:get("name", "", "type=xs:string")) },
                      element email  { fn:normalize-space(req:get("email", "", "type=xs:string")) }, 
                      element password  { fn:normalize-space(req:get("password1", "", "type=xs:string")) },
                      element created   { fn:current-dateTime() }
                    }
    
    let $message :=   if (($user/username eq "") or ($user/name eq "") or ($user/email eq "") or ($user/password eq "")) then
                        "Please fill in all fields."
                      else
                        usr:save($user)
                      
    let $scripts := <scripts>
                        <script type="text/javascript" src="/js/register.js">&nbsp;</script>
                    </scripts>
                    
    let $view :=  if(fn:contains($message,"Successfully")) then
                    let $login := auth:weblogin($user/username/text(), $user/password/text())
                     
                    return 
                    (
                        (:ch:add-value("username", $user/username/text()),
                        ch:add-value("message", $login/message/text()),
                        ch:add-value("loggedin", xdmp:get-session-field("logged-in-user")),
                        ch:use-view(<view format="html">appbuilder/main</view>, "html"), 
                        ch:use-layout(<layout format="html">application</layout>):)
                        xdmp:redirect-response('/')
                    )
                  else
                  ( 
                    ch:add-value("message", $message),
                    ch:use-view((), "xml"),
                    ch:use-layout(<layout format="html">master</layout>)
                    
                  )
    return
    (

      ch:add-value("javascripts", $scripts),
      
      $view
    )
};

declare function c:logout() as item()*
{
  let $username := (xdmp:get-session-field("username"),req:get("username", "", "type=xs:string"))[1]
  
  let $logout := xdmp:set-session-field("logged-in-user", "")
  let $result   := auth:logout($username)

  return xdmp:redirect-response("/")    
};

declare function c:login() as item()*
{
    let $q as xs:string := req:get("q", "", "type=xs:string")
    let $username := (xdmp:get-session-field("username"),req:get("username", "", "type=xs:string"))[1]
    let $password := req:get("password", "", "type=xs:string")
    let $message := if (($username eq "") or ($password eq "")) then
                        "Invalid: please provide username and password."
                    else
                        auth:weblogin($username,$password)/message/text()
    let $scripts := <scripts>
                        <script type="text/javascript" src="/js/login.js">&nbsp;</script>
                        <script type="text/javascript">$(document).ready(function(){{$("#login-form").validate();}});</script>
                    </scripts>                   

    return
    (
        ch:add-value("message", $message),
        ch:add-value("username", $username),
        ch:add-value("javascripts", $scripts),
        if(fn:contains($message, "successful")) then
        (
            xdmp:redirect-response('/')
        )
        else
        (
            ch:use-view(<view format="html">user/login</view>, "html"),
            ch:use-layout(<layout format="html">master</layout>)
        )
        
    )
};
