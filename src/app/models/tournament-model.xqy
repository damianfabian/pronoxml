xquery version "1.0-ml";

module namespace tm = "http://marklogic.com/roxy/models/tournament";

import module namespace cfg     = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
import module namespace invoke  = "http://marklogic.com/ps/invoke/functions" at "/app/lib/invoke-functions.xqy";
import module namespace ch      = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";
import module namespace req     = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace auth    = "http://marklogic.com/roxy/models/authentication" at "/app/models/authentication.xqy";
import module namespace json    = "http://marklogic.com/json" at "/roxy/lib/json.xqy";
import module namespace tools   = "http://marklogic.com/ps/custom/common-tools" at "/app/lib/common-tools.xqy";
import module namespace usr   = "http://marklogic.com/roxy/models/user" at "/app/models/user-model.xqy";

declare namespace search = "http://marklogic.com/appservices/search";
declare namespace cts    = "http://marklogic.com/cts";
declare namespace xi = "http://www.w3.org/2001/XInclude";

declare option xdmp:mapping "false";

declare variable $SEARCH-OPTIONS :=
  <options xmlns="http://marklogic.com/appservices/search">
    <return-query>1</return-query>
  </options>;

declare function tm:save($name as xs:string, $type as xs:string, $username as xs:string) as item()*
{
    let $id     :=  tools:uniqueID()
    let $uri    := fn:concat($cfg:DOCUMENTS_PATH, "/tournament/",$username,"/", $id, ".xml")
    let $save   := xdmp:document-insert($uri, 
                    <tournament id="{$id}">
                    <name>{$name}</name>
                    <date>{fn:current-date()}</date>
                    <administrator>{$username}</administrator>
                    <type>{$type}</type>
                    <status>active</status>
                    <users/>
                    <contenders/>
                    <matches/>
                    <forecasts/>
                    </tournament>, xdmp:default-permissions(), "tournament")
    return <data>
                <message>Tournament Saved Successfuly</message>
                <id>{$id}</id>
           </data>

};

declare function tm:get-by-id($id as xs:string) as item()
{
    cts:search(fn:collection("tournament"),
      cts:element-attribute-value-query(xs:QName("tournament"),xs:QName("id"), $id)
    )
    
};

declare function tm:add-user($doc as element(tournament), $username as xs:string) as item()
{
    if(usr:get($username)) then
        let $add := xdmp:node-insert-child($doc/users, <user date="{fn:current-date()}">{$username}</user>)
        return "You added the user successfuly"
    else
        "The user doesn't exist, please check the field"
};

declare function tm:add-contender($doc as element(tournament), $contender as xs:string) as item()
{
    if(fn:not($doc/contenders/xi:include[@href eq $contender])) then
        let $add := xdmp:node-insert-child($doc/contenders, <xi:include date="{fn:current-date()}" href="{$contender}" />)
        return "You added the contender successfuly"
    else
        "The contender already exist"
};