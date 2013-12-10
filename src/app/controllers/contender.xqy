xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/contender";

(: the controller helper library provides methods to control which view and template get rendered :)
import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";

(: The request library provides awesome helper methods to abstract get-request-field :)
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace error = "http://marklogic.com/roxy/error-lib" at "../views/helpers/error-lib.xqy";
import module namespace uc   = "http://marklogic.com/roxy/models/contact" at "/app/models/contact-model.xqy";
import module namespace json="http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
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
declare function c:autocomplete() as item()*
{
    let $username   := (xdmp:get-session-field("username"),req:get("username", "", "type=xs:string"))[1]
    let $term       := fn:concat(req:get("term"),"*")
    
    let $config := json:config("custom") , $cx := map:put( $config, "whitespace", "ignore" )
    let $result     := cts:search(fn:collection("contender"), cts:and-query((
                        cts:element-value-query(xs:QName("name"),$term,"wildcarded")   
                       ))) ! <item><id>{fn:base-uri(.)}</id><value>{.//name/text()}</value></item>
    
    
    return  json:transform-to-json($result, $config)
};
