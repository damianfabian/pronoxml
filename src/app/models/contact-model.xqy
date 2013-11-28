xquery version "1.0-ml";

module namespace usr = "http://marklogic.com/roxy/models/contact";

import module namespace cfg     = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
import module namespace ch      = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";
import module namespace req     = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace tools   = "http://marklogic.com/ps/custom/common-tools" at "/app/lib/common-tools.xqy";

declare option xdmp:mapping "false";

declare function save($contact as element(contact)) as item()*
{
    try{
        let $uri    := fn:concat($cfg:DOCUMENTS_PATH,"/contacts/", $contact/email/text(),"/", fn:current-date(),".xml")
        let $save   := xdmp:document-insert($uri, $contact)
        return "Thanks for your message, we will put it in contact with you"
    }catch($e){
        "Error creating contact", xdmp:log(xdmp:quote($e))
    }
};
