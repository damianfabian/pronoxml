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
import module namespace json ="http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace tools   = "http://marklogic.com/ps/custom/common-tools" at "/app/lib/common-tools.xqy";
import module namespace con   = "http://marklogic.com/roxy/models/contender" at "/app/models/contender-model.xqy";

import module namespace cfg    = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
declare namespace search = "http://marklogic.com/appservices/search";
declare namespace xi = "http://www.w3.org/2001/XInclude";
declare namespace js = "http://marklogic.com/xdmp/json/basic";

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
    (: Search variables :)
    
    let $search         := req:get("search", "", "type=xs:string")
    let $type_search    := req:get("type_search", "", "type=xs:string") 
    let $status         := "status:active"
    let $pg             := req:get("page", 1, "type=xs:int")
    let $ps             := req:get("ps", $cfg:DEFAULT-PAGE-LENGTH, "type=xs:int")
    let $sortField      := req:get("sortField", "", "type=xs:string")
    let $sortOrder      := req:get("sortOrder", "", "type=xs:string")
    let $sortCommand    := if($sortField and $sortOrder) then fn:concat($sortOrder,":",$sortField) else ()
    let $query          := ($cfg:TOURNAMENT_COLLECTION, if($type_search) then fn:concat("type:",$type_search) else (), $status, $sortCommand, $search)
    let $q as xs:string := fn:string-join($query, " ")
    
    (: Create variables :)
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
    ch:add-value("sortField", $sortField),
    ch:add-value("sortOrder", $sortOrder),
    ch:add-value("response", $response),
    ch:add-value("myTournaments", c:myTournaments($username)),
    ch:add-value("top5", c:top5()),
    ch:add-value("javascripts",$scripts),
    ch:use-view((), "xml"),
	ch:use-layout("master")
  )
};

declare function c:detail() as item()*
{
    let $username           := req:get("username", "", "type=xs:string")
    let $id                 := req:get("id", "", "type=xs:string")
    let $tournament         := tm:get-by-id($id)/tournament
    let $message            := ""
    
   let $scripts             := <scripts>
                                   <script type="text/javascript" src="/js/tournament.js">&nbsp;</script>
                                   <script src="/js/bootbox.min.js">&nbsp;</script>
                                   <script src="/js/jquery.form.js">&nbsp;</script>
                               </scripts>
    return
    (
        ch:add-value("message", $message),
        ch:add-value("username",$username),
        ch:add-value("tournament", $tournament),
        ch:add-value("javascripts",$scripts),
        ch:add-value("id",$id),
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

declare function c:invite() as item()*
{
    let $id-tournament := req:get("id")
    let $email         := req:get("email")
    let $to            := <users><user><name/><email>{$email}</email></user></users>
    let $from          := <from><name>Admin</name><email>admin@pronoxml.com</email></from>
    let $message       := "<html><head><title>Get to know Pronoxml</title></head><body><h1>Pronoxml</h1><p>You are invited to try Pronoxml, please follow the link to join us <a href='@1'>Click Here</a></p></body></html>"
    let $message       := tools:format-string($message, fn:concat("http://localhost:8020/invite/",$id-tournament) )
    let $subject       := "Get to know Pronoxml"
    
    return tools:send-email($subject, $to, $from, $message)
};

declare function c:add-user() as item()*
{
    let $id-tournament := req:get("id")
    let $username      := req:get("username")
    let $doc           := tm:get-by-id($id-tournament)/tournament
    return 
    if(fn:not($doc/users[user eq $username])) then
        tm:add-user($doc, $username)
    else
        "The user already exists in the tournament"
};

declare function c:create-and-add-contender() as item()*
{
    let $id             := req:get("id")
    let $name           := req:get("contender")
    let $description    := req:get("description")
    let $image          := req:get("image")
    let $tags           := req:get("tags")
    let $type           := req:get("discipline")
    let $ext            := if($image) then tools:get-extension(req:get("image-filename")) else ()
    
    let $save           := con:save($name, $description, $tags, $image, $ext, $type)
    
    let $doc           := tm:get-by-id($id)/tournament
    return if(fn:not(fn:contains($save/message, "ERROR"))) then
                let $add-contender := tm:add-contender($doc, $save/uri/text())
                return $add-contender
           else
                $save/message
    
};

declare function c:add-contender() as item()*
{
    let $id            := req:get("id")
    let $uri           := req:get("uri")
    let $doc           := tm:get-by-id($id)/tournament
    
    return if(fn:not($doc/contenders/xi:include[@href eq $uri])) then
                let $add-contender := tm:add-contender($doc, $uri)
                return $add-contender
            else
                "The contender already exists"
        
    
};

declare function c:add-match() as item()*
{
    let $id            := req:get("id")
    let $contender1    := req:get("contender1")
    let $contender2    := req:get("contender2")
    let $con1          := fn:doc($contender1)/contender
    let $con2          := fn:doc($contender2)/contender
    let $date          := req:get("date")
    let $doc           := tm:get-by-id($id)/tournament
    
    let $id-match      := tools:uniqueID()
    let $name          := fn:concat($con1/name/text()," Vs ",$con2/name/text())
    let $match         := <match id="{$id-match}">
                            <name>{$name}</name>
                            <date>{tools:parse-date($date)}</date>
                            <dateModified>{fn:current-date()}</dateModified>
                            <status>active</status>
                            <play type="Numeric">
                                <contender id="{$contender1}" />
                                <contender id="{$contender2}" />
                            </play>
                          </match>
    
    let $save          := xdmp:node-insert-child($doc/matches, $match)
    let $config        := json:config("custom") , $cx := map:put( $config, "whitespace", "ignore" )
    
    return json:transform-to-json(<info><message>You created a new match successfuly</message><name>{$name}</name><date>{$match/date/text()}</date></info>, $config)      
    
};

declare function c:forecast() as item()*
{
    let $username           := req:get("username", "", "type=xs:string")
    let $id                 := req:get("id", "", "type=xs:string")
    let $tournament         := tm:get-by-id($id)/tournament
    let $message            := ""
    
   let $scripts             := <scripts>
                                   <script type="text/javascript" src="/js/forecast.js">&nbsp;</script>
                                   <script src="/js/bootbox.min.js">&nbsp;</script>
                               </scripts>
    return
    (
        ch:add-value("message", $message),
        ch:add-value("username",$username),
        ch:add-value("tournament", $tournament),
        ch:add-value("javascripts",$scripts),
        ch:add-value("id",$id),
        ch:use-view((), "xml"),
        ch:use-layout("master")
    )
};

declare function c:save-forecast() as item()*
{
    let $id            := req:get("id")
    let $data          := json:transform-from-json(req:get("data"))
    let $doc           := tm:get-by-id($id)/tournament
    let $username      := (xdmp:get-session-field("username"),req:get("username", "", "type=xs:string"))[1]
    
    let $forecast      :=   for $x in $data/js:json
                            let $id-forecast   := tools:uniqueID()
                            
                            let $item          :=   <forecast id="{$id-forecast}" match-id="{$x/js:idmatch/text()}">
                                                        <user>{$username}</user>
                                                        <status>Active</status> <!--Done, Canceled -->
                                                        <date>{fn:current-date()}</date>
                                                        <play>
                                                        {
                                                            for $y in $x/js:contenders/js:json
                                                            return
                                                                <contender id="{$y/js:id/text()}" value="{$y/js:value/text()}"/>
                                                        }   
                                                        </play>
                                                    </forecast>
                            
                            return if($doc/forecasts/forecast[@match-id eq $x/js:idmatch and user eq $username]) then
                                        xdmp:node-replace($doc/forecasts/forecast[@match-id eq $x/js:idmatch and user eq $username], $item)
                                   else
                                        xdmp:node-insert-child($doc/forecasts, $item)
                            
   
    return "You save the forecast successfuly"    
};