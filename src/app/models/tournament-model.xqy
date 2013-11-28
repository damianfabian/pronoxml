xquery version "1.0-ml";

module namespace tm = "http://marklogic.com/roxy/models/tournament";

import module namespace cfg     = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
import module namespace invoke  = "http://marklogic.com/ps/invoke/functions" at "/app/lib/invoke-functions.xqy";
import module namespace ch      = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";
import module namespace req     = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace auth    = "http://marklogic.com/roxy/models/authentication" at "/app/models/authentication.xqy";
import module namespace json    = "http://marklogic.com/json" at "/roxy/lib/json.xqy";
import module namespace tools   = "http://marklogic.com/ps/custom/common-tools" at "/app/lib/common-tools.xqy";

declare namespace search = "http://marklogic.com/appservices/search";
declare namespace cts    = "http://marklogic.com/cts";

declare option xdmp:mapping "false";

declare variable $SEARCH-OPTIONS :=
  <options xmlns="http://marklogic.com/appservices/search">
    <return-query>1</return-query>
  </options>;

declare function tm:save($name as xs:string, $type as xs:string, $username as xs:string) as item()*
{
    let $id     :=  xdmp:wallclock-to-timestamp(fn:current-dateTime())
    let $uri    := fn:concat($cfg:DOCUMENTS_PATH, "/tournament/",$username,"/", $id, ".xml")
    let $save   := xdmp:document-insert($uri, 
                    <tournament id="{$id}">
                    <name>{$name}</name>
                    <date>{fn:current-date()}</date>
                    <administrators>
                        <user>{$username}</user>
                    </administrators>
                    <type>{$type}</type>
                    <status>active</status>
                    </tournament>, xdmp:default-permissions(), "tournament")
    return <data>
                <message>Tournament Saved Successfuly</message>
                <id>{$id}</id>
           </data>

};