xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/tournaments";

(: the controller helper library provides methods to control which view and template get rendered :)
import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";

(: The request library provides awesome helper methods to abstract get-request-field :)
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace error = "http://marklogic.com/roxy/error-lib" at "../views/helpers/error-lib.xqy";
import module namespace tm   = "http://marklogic.com/roxy/models/tournament" at "/app/models/tournament-model.xqy";
import module namespace auth  = "http://marklogic.com/roxy/models/authentication" at "/app/models/authentication.xqy";
import module namespace s    = "http://marklogic.com/roxy/models/search"         at "/app/models/search-lib.xqy";
import module namespace json   = "http://marklogic.com/json" at "/roxy/lib/json.xqy";

import module namespace cfg    = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
declare namespace search = "http://marklogic.com/appservices/search";
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
    
    let $search         := req:get("search", "", "type=xs:string")
    let $type_search           := req:get("type_search", "", "type=xs:string") 
    let $status         := "status:active"
    let $query          := ($cfg:TOURNAMENT_COLLECTION, if($type_search) then fn:concat("type:",$type_search) else (), $status, $search)
    let $q as xs:string := fn:string-join($query, " ")
    let $log := xdmp:log($q)
    let $pg             := req:get("page", 1, "type=xs:int")
    let $ps             := req:get("ps", $cfg:DEFAULT-PAGE-LENGTH, "type=xs:int")
    let $username       := (xdmp:get-session-field("username"),req:get("username", "", "type=xs:string"))[1]
    let $response       := s:search($q, $pg, $ps)
    let $send           := req:get("send", "", "type=xs:string")
    let $name           := req:get("name", "", "type=xs:string")
    let $type           := req:get("type", "", "type=xs:string")
    let $message        := if($send) then
                                if($name ne "" and $type ne "") then
                                    tm:save($name, $type, $username)
                                else
                                    <data><message>Please fill all the fields</message></data>
                           else <data/>
                           
    let $redirect       :=  if($message/id and $message/id ne "") then 
                                xdmp:redirect-response(fn:concat("/tournaments/edit/",$message/id))
                            else ()
                            
    let $scripts := <scripts>
                        <script type="text/javascript" src="/js/tournament.js">&nbsp;</script>
                    </scripts>                      
    return
  (
    ch:add-value("message", $message/message/text()),
    ch:add-value("page",$pg),
    ch:add-value("q",$q),
    ch:add-value("search",$search),
    ch:add-value("type",$type_search),
    ch:add-value("response", $response),
    ch:add-value("myTournaments", c:myTournaments($username)),
    ch:add-value("top5", c:top5()),
    ch:add-value("javascripts",$scripts),
    ch:use-view((), "xml"),
	ch:use-layout("master")
  )
};

declare function c:myTournaments($username) as item()*
{
    let $query := fn:concat("user:",$username," col:tournament status:active")
    
    return s:search($query, $cfg:SEARCH-OPTIONS, 1, 10)
};

declare function c:top5() as item()*
{
    let $query := fn:concat("col:tournament status:active")
    
    return s:search($query, $cfg:SEARCH-OPTIONS, 1, 10)
};