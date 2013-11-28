xquery version "1.0-ml";

(: Generates the search template
 : To use this library:
 : call search:template($response)
 : parameters --
 :   $response - the search:response element (needed) :)

module namespace sl = "http://www.marklogic.com/roxy/search-lib";

import module namespace pg = "http://marklogic.com/roxy/pager-lib" at "/app/views/helpers/pager-lib.xqy";
declare namespace search = "http://marklogic.com/appservices/search";

declare function sl:template($response, $q, $page) as item()*
{
    <div class="results">
        <div class="wrapper table-responsive">
            <table class="table table-bordered table-hover tableTournament">
            <thead class="active">
                <tr>
                    <th class="field">Tournament Name</th>
                    <th class="field">Creation Date</th>
                    <th class="field">Type</th>
                    <th class="field">Commands</th>
                </tr>
            </thead>
            <tbody>
                {
                    for $result at $i in $response/search:result
                    let $doc := fn:doc($result/@uri)/tournament
                    order by $doc/name/text() ascending
                    return
                      <tr>
                        <td class="field">{$doc/name/text()}</td>
                        <td class="field">{$doc/date/text()}</td>
                        <td class="field">{$doc/type/text()}</td>
                        <td class="field"><a href="/tournament/details/{$doc/@id}" class="more">More Details</a></td>
                      </tr>
                }
            </tbody>
            </table>
        
        </div>
        { pg:getPaginate($response, $q, $page) }
    </div>
};

declare function sl:tournament-form($message) as item()*
{
   <div class="cform" id="theme-form">
      <form action="/tournaments" method="post" class="cform-form" id="create-form">
        <div class="span4">
          <div class="row"> 
            <div class="error" style="display:none;">
                 <span class="muted">{$message}</span>.<br clear="all"/>
            </div>
          </div>
        </div>
        <div class="span4">
          <div class="row"> 
            <input type="text" name="name" placeholder="Torunament Example: UEFA" class="cform-text required" size="40"  />
          </div>
          <div class="row"> 
            <select id="type" name="type">
                <option>Basketball</option>
                <option>Soccer</option>
                <option>Video Games</option>
            </select>
          </div>
          <div class="row">
            <input type="submit" name="send" value="Submit" class="button"/>
          </div>
        </div>
        <div class="cform-response-output">&nbsp;</div>
      </form>
    </div>
};

declare function sl:myTournaments($myTournaments) as item()*
{
    if(fn:count($myTournaments) > 0) then
        <ul class="list-options">
        {
            for $x in $myTournaments/search:result
            let $doc := fn:doc($x/@uri)/tournament
            order by $doc/name/text() ascending
            return
                <li><a href="/tournament/detail/{$doc/@id}">{$doc/name/text()}</a></li>
        }
        </ul>
    else ()
};

declare function sl:top5($top5) as item()*
{
    if(fn:count($top5) > 0) then
        <ul class="list-options">
        {
            for $x in $top5/search:facet[@name="type"]/search:facet-value
            order by $x/@count
            return
                <li><a href="/tournament/group/{$x/@name}">{fn:concat($x/@name," (",$x/@count,")")}</a></li>
        }
        </ul>
    else ()
};

declare function sl:filters($response, $page, $search, $type) as item()*
{
    <div class="wrapper table-responsive">
        <table class="table table-bordered table-hover tableTournament">
        <thead>
            <tr>
                <th class="field">Filters</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <div class="filter">
                        <form action="/tournaments" method="get" class="search-form" id="search-form">
                            <label for="search">Search</label>
                            <input type="text" name="search" placeholder="Example: UEFA" value="{$search}" />
                            <label for="type">Type</label>
                            <select id="type" name="type_search">
                            {
                                let $options := ("Select One", "Basketball", "Soccer", "Video Games")
                                let $log := xdmp:log($type)
                                for $x in $options
                                return <option value="{$x}">{
                                            if ($x = $type) then attribute selected { 1 } else (),
                                            $x
                                        }
                                        </option>
                                    
                            }
                            </select>
                            <input type="submit" value="Search" />
                            <input type="hidden" name="page" value="{$page}" id="hdPage" />
                        </form>
                    </div>
                </td>
            </tr>
        </tbody>
        </table>
    
    </div>
};