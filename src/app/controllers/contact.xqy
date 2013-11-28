xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/contact";

(: the controller helper library provides methods to control which view and template get rendered :)
import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";

(: The request library provides awesome helper methods to abstract get-request-field :)
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace error = "http://marklogic.com/roxy/error-lib" at "../views/helpers/error-lib.xqy";
import module namespace uc   = "http://marklogic.com/roxy/models/contact" at "/app/models/contact-model.xqy";

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
    let $username   := (xdmp:get-session-field("username"),req:get("username", "", "type=xs:string"))[1]
    let $action     := "/contact"
    let $send       := req:get("send")
    let $log := xdmp:log("Iniciando")
    let $log := xdmp:log($send)
    let $contact    :=  element contact
                        {
                          element name { fn:normalize-space(req:get("name", "", "type=xs:string")) }, 
                          element email  { fn:normalize-space(req:get("email", "", "type=xs:string")) }, 
                          element company  { fn:normalize-space(req:get("company", "", "type=xs:string")) }, 
                          element website  { fn:normalize-space(req:get("website", "", "type=xs:string")) },
                          element message   { fn:normalize-space(req:get("message", "", "type=xs:string")) }
                        }
    
    let $message    :=  if($contact/email ne "" and $contact/name ne "" and $contact/company ne "" and $contact/website ne "" and $contact/message ne "" ) then
                            uc:save($contact)
                        else if($send and ($contact/email eq "" or $contact/name eq "" or $contact/company eq "" or $contact/website eq "" or $contact/message eq "" )) then
                            "Please Fill all the fields"
                        else ()
    let $log := xdmp:log($message)   
    let $log := xdmp:log(xdmp:quote($contact))
    return
    (
        ch:add-value("message", $message),
        ch:add-value("action", $action),
        ch:use-view((), "xml"),
        ch:use-layout("master")
    )
};
