xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/models/contact";

import module namespace cfg     = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
import module namespace invoke  = "http://marklogic.com/ps/invoke/functions" at "/app/lib/invoke-functions.xqy";
import module namespace ch      = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";
import module namespace req     = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace tools   = "http://marklogic.com/ps/custom/common-tools" at "/app/lib/common-tools.xqy";
import module namespace bm      = "http://marklogic.com/roxy/models/binary" at "/app/models/binary-model.xqy";
import module namespace tm   = "http://marklogic.com/roxy/models/tournament" at "/app/models/tournament-model.xqy";

declare namespace search = "http://marklogic.com/appservices/search";
declare namespace cts    = "http://marklogic.com/cts";

declare option xdmp:mapping "false";

declare variable $SEARCH-OPTIONS :=
  <options xmlns="http://marklogic.com/appservices/search">
    <return-query>1</return-query>
  </options>;

declare function c:save($contender, $description, $tags, $image, $image-ext, $type) as item()*
{
    if(fn:not(c:get-by-name($contender))) then
        let $id         :=  tools:uniqueID()
        let $uri        := fn:concat($cfg:DOCUMENTS_PATH, "/contender/", $id, ".xml")
        let $save-img   := if($image) then bm:save($image, $image-ext) else ()
        return if(fn:not(fn:contains($save-img, "ERROR"))) then
                    let $save       := xdmp:document-insert($uri, 
                                        <contender id="{$id}">
                                        <name>{$contender}</name>
                                        <date>{fn:current-date()}</date>
                                        <type>{$type}</type>
                                        <status>active</status>
                                        <image>{$save-img}</image>
                                        <tags>{fn:tokenize($tags,",") ! <tag>{.}</tag>}</tags>
                                        </contender>, xdmp:default-permissions(), "contender")
                    return <data>
                                <message>Contender Saved Successfuly</message>
                                <id>{$id}</id>
                                <uri>{$uri}</uri>
                           </data>
               else
                    $save-img
    else
        "The contender already exist, please check the field"
};

declare function c:get-by-name($name as xs:string) as item()*
{
    cts:search(fn:collection("contender"),
      cts:element-value-query(xs:QName("name"), $name)
    )
    
};
