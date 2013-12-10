xquery version "1.0-ml";

module namespace b = "http://marklogic.com/roxy/models/binary";

import module namespace cfg     = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
import module namespace tools   = "http://marklogic.com/ps/custom/common-tools" at "/app/lib/common-tools.xqy";


declare namespace search = "http://marklogic.com/appservices/search";
declare namespace cts    = "http://marklogic.com/cts";

declare option xdmp:mapping "false";

declare variable $SEARCH-OPTIONS :=
  <options xmlns="http://marklogic.com/appservices/search">
    <return-query>1</return-query>
  </options>;

declare function b:save($image, $ext) as xs:string
{
    try{
     let $id := tools:uniqueID()
     let $uri := fn:concat($cfg:BINARY_PATH, "/",$id,".",$ext)
     let $save := xdmp:document-insert($uri, $image, xdmp:default-permissions(), "binary")
     return $uri
    }
    catch($e){ "ERROR: Image Could'n be saved" }
};