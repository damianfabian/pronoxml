xquery version "1.0-ml";

(: Generates the search template
 : To use this library:
 : call search:template($response)
 : parameters --
 :   $response - the search:response element (needed) :)

module namespace sl = "http://www.marklogic.com/roxy/search-lib";

import module namespace pg = "http://marklogic.com/roxy/pager-lib" at "/app/views/helpers/pager-lib.xqy";
import module namespace xinc="http://marklogic.com/xinclude"  at "/MarkLogic/xinclude/xinclude.xqy";
import module namespace c    = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
import module namespace usr   = "http://marklogic.com/roxy/models/user" at "/app/models/user-model.xqy";
declare namespace search = "http://marklogic.com/appservices/search";

 

declare function sl:template($response, $q, $page, $sortField, $sortOrder) as item()*
{
    <div class="results">
        <div class="wrapper table-responsive">
            <table class="table table-bordered table-hover tableTournament">
            <thead class="active">
                <tr>
                    <th class="field"><a class="linkOrder clickable {if($sortField eq "name") then $sortOrder else "&nbsp;"}" field="name">Tournament Name</a></th>
                    <th class="field"><a class="linkOrder clickable {if($sortField eq "date") then $sortOrder else "&nbsp;"}" field="date">Creation Date</a></th>
                    <th class="field"><a class="linkOrder clickable {if($sortField eq "type") then $sortOrder else "&nbsp;"}"  field="type">Type</a></th>
                    <th class="field">Commands</th>
                </tr>
            </thead>
            <tbody>
                {
                    for $result at $i in $response/search:result
                    let $doc := fn:doc($result/@uri)/tournament
                    return
                      <tr>
                        <td class="field">{$doc/name/text()}</td>
                        <td class="field">{$doc/date/text()}</td>
                        <td class="field">{$doc/type/text()}</td>
                        <td class="field"><a href="/tournaments/detail?id={$doc/@id}" class="more">More Details</a></td>
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
            {
                for $x in $c:DISCIPLINES//discipline
                return
                    <option>{$x/text()}</option>
            }
            </select>
          </div>
          <div class="row">
            <input type="submit" name="send" value="Submit" class="btnSubmit"/>
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
                <li><a href="/tournaments/detail?id={$doc/@id}">{$doc/name/text()}</a></li>
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
                <li><a href="/tournament/group?id={$x/@name}">{fn:concat($x/@name," (",$x/@count,")")}</a></li>
        }
        </ul>
    else ()
};

declare function sl:filters($response, $page, $search, $type, $sortField, $sortOrder) as item()*
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
                                for $x at $y in $options
                                return <option value="{if($y > 1) then $x else ()}">{
                                            if ($x = $type) then attribute selected { 1 } else (),
                                            $x
                                        }
                                        </option>
                                    
                            }
                            </select>
                            <input type="submit" value="Search" />
                            <input type="hidden" name="page" value="{$page}" id="hdPage" />
                            <input type="hidden" name="sortField" value="{$sortField}" id="sortField" />
                            <input type="hidden" name="sortOrder" value="{$sortOrder}" id="sortOrder" />
                        </form>
                    </div>
                </td>
            </tr>
        </tbody>
        </table>
    
    </div>
};

declare function sl:details($tournament as element(tournament)) as item()*
{
    let $fulldoc := xinc:node-expand(fn:doc(fn:base-uri($tournament)))
    return
    <div class="wrapper table-responsive">
        <h2>Users</h2>
        <hr/>
        <table class="table table-bordered table-hover tableTournament">
        <thead>
            <tr>
                <th class="field">Username</th>
                <th class="field">Full Name</th>
                <th class="field">Commands</th>
            </tr>
        </thead>
        <tbody>
        {
            for $user in $tournament/users/user
            let $doc := usr:get($user/text())
            return
            <tr id="{$user/text()}">
                <td>{$user/text()}</td>
                <td>{$doc/name/text()}</td>
                <td>&nbsp;</td>
            </tr>
        }
        </tbody>
        </table>
        
        <h2>Contenders <a id="linkAddContender" class="clickable linkAddContender"><img src="../img/add.png" class="add-contender add-icon"/></a></h2>
        <hr/>
        <table class="table table-bordered table-hover tableTournament">
        <thead>
            <tr>
                <th class="field">Name</th>
                <th class="field">Description</th>
                <th class="field">Date</th>
                <th class="field">Commands</th>
            </tr>
        </thead>
        <tbody>
        {
            
            for $con in $fulldoc//contenders/contender
            return
               <tr id="{$con/@id}">
                <td>{$con/name/text()}</td>
                <td>{$con/description/text()}</td>
                <td>{$con/date/text()}</td>
                <td>&nbsp;</td>
               </tr>
                
        }
        </tbody>
        </table>
        <section id="addContenderModal" title="Add Contender">
            <input type="text" name="autoContender" id="autoContender" style="height:60px;" placeholder="Fill three leters to search a contender" />
        </section>
        <h2>Matches <a id="linkAddMatch" class="clickable linkAddMatch"><img src="../img/add.png" class="add-match add-icon"/></a></h2>
        <hr/>
        <table id="tbMatches" class="table table-bordered table-hover tableTournament">
        <thead>
            <tr>
                <th class="field"><a class="linkOrder clickable" field="name">Date</a></th>
                <th class="field"><a class="linkOrder clickable" field="date">Match</a></th>
                <th class="field">Commands</th>
            </tr>
        </thead>
        <tbody>
        {
            
            for $match in $tournament/matches/match
            return
               <tr id="{$match/@id}">
                <td>{$match/date/text()}</td>
                <td>{$match/name/text()}</td>
                <td>&nbsp;</td>
               </tr>
                
        }
        </tbody>
        </table>
        <section id="addMatchModal" title="Add Match">
           <form name="matchAdd" id="matchAdd">
                <label for="contender1">Contender #1</label>
                 <select name="contender1" id="contender1" class="required">
                 <option value="">Select One</option>
                 {
                     for $con in $fulldoc//contenders/contender
                     return  <option value="{fn:base-uri($con)}">{$con/name}</option>
                 }
                 </select>
                 
                 <img src="/img/VS.png" class="versus" />
                 
                 <label for="contender2">Contender #2</label>
                 <select name="contender2" id="contender2" class="required">
                 <option value="">Select One</option>
                 {
                     for $con in $fulldoc//contenders/contender
                     return  <option value="{fn:base-uri($con)}">{$con/name}</option>
                 }
                 </select>
                 <label for="date">Date</label>
                 <input type="text" name="matchDate" id="matchDate" class="required date" style="height:50px;"/>
                 <p>
                    <input type="button" class="btn btnSubmit" id="btnMatchSave" value="Save"/>
                 </p>
            </form>
        </section>
        <h2><a href="/tournaments/forecast?id={$tournament/@id}" class="more">View forecasts</a></h2>
    </div>
};

declare function sl:details-forms($tournament as element(tournament)) as item()*
{
    <table class="table table-bordered table-hover tableTournament">
    <thead>
        <tr>
            <th class="field">Add/Invite User</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <div class="filter">
                <form class="search-form" id="add-form">
                    <label for="addUser">User</label>
                    <input type="text" name="addUser" id="addUser" class="required" placeholder="Example: ironman" value="" />
                    <label for="inviteUser">Email</label>
                    <input type="text" name="inviteUser" id="inviteUser" class="email required" placeholder="Example: bryan@domain.com" value="" />
                    <input type="button" value="Send" id="btnAddUser" />
                </form>
                </div>
            </td>
        </tr>
    </tbody>
    </table>
    ,
    <table class="table table-bordered table-hover tableTournament">
    <thead>
        <tr>
            <th class="field">Create Contender</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <div class="filter">
                <form class="search-form" id="contender-form" enctype="multipart/form-data" method="post" action="/tournaments/create-and-add-contender" >
                    <label for="contender">Name</label>
                    <input type="text" name="contender" class="required" placeholder="Example: Argentina" />
                    <label for="description">Description</label>
                    <textarea name="description" class="required">&nbsp;</textarea>
                    <label for="image">Image</label>
                    <input type="file" name="image" id="flImageContender" />
                    <label for="tags">Tags</label>
                    <input type="text" name="tags" placeholder="Example: Soccer" />
                    <label for="discipline">Discipline</label>
                    <select name="discipline" id="dlDiscipline" class="required">
                    {
                        for $x in $c:DISCIPLINES//discipline
                        return
                            <option>{$x/text()}</option>
                    }
                    </select>
                    <input type="Submit" value="Send" />
                </form>
                <div id="progress">
                     <div id="bar"></div>
                     <div id="percent">0%</div >
                 </div>
                 <br/>
                 <div id="message"></div>
                </div>
            </td>
        </tr>
    </tbody>
    </table>
    
};