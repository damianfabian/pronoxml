xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/tournament";

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
    let $message := "hola"
    return
  (
    ch:add-value("message", $message),
    ch:use-view((), "xml"),
	ch:use-layout(())
  )
};