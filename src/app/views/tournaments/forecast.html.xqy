xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";
import module namespace sl = "http://www.marklogic.com/roxy/search-lib" at "/app/views/helpers/search-lib.xqy";
import module namespace facet = "http://marklogic.com/roxy/facet-lib" at "/app/views/helpers/facet-lib.xqy";
import module namespace c    = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
declare namespace search = "http://marklogic.com/appservices/search";
declare namespace xi = "http://www.w3.org/2001/XInclude";


declare option xdmp:mapping "false";

declare variable $message           := vh:get("message");
declare variable $username          := vh:get("username");
declare variable $id                := vh:get("id");
declare variable $tournament        := vh:get("tournament");
declare variable $DEFAULT-IMAGE     := "/img/placeholder.png";

<div class="scrollblock">

    <section id="services" class="single-page scrollblock">
      <div class="container">
        
        <h1>{$tournament/name/text()}</h1>
        <!-- Four columns -->
        <div class="row">
          <div class="span3">
            <h2>Web design</h2>
            <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.</p>
          </div>
          <!-- /.span9 -->
          <section id="container-forecasts" class="span9">
          {
            for $item in $tournament/matches/match
            let $names := fn:tokenize($item/name,"Vs")
            let $contenders := fn:doc($item/play/contender/@id)
            let $values := $tournament/forecasts/forecast[@match-id eq $item/@id]/play/contender
            return
            
            <div id="{$item/@id}" class="data-forecast">
                <div class="forecast span3">
                    <h2>{$names[1]}</h2>
                    <div class="item">
                        <img src="{($contenders[1]/contender/image/text(),$DEFAULT-IMAGE)[1]}" />
                        <input type="text" name="{$item/@id}-1" value="{$values[@id eq $contenders[1]/contender/@id]/@value}" contender="{$contenders[1]/contender/@id}"/>
                    </div>
                </div>
                <div class="span2 vsimage"><img src="/img/VS.png" width="80px"/></div>
                <div class="forecast span3">
                    <h2>{$names[2]}</h2>
                    <div class="item">
                        <img src="{($contenders[2]/contender/image/text(),$DEFAULT-IMAGE)[1]}" />
                        <input type="text" name="{$item/@id}-2" value="{$values[@id eq $contenders[2]/contender/@id]/@value}" contender="{$contenders[2]/contender/@id}"/>
                    </div>
                </div>
            </div>
          }
          <div class="span8">
            <hr/>
            <input type="button" class="btnSubmit" id="btnSaveForecast" value="Save" style="margin:10px;"/>
          </div>
          </section>
          
          <!-- /.span9 -->
          
          
        </div>
        <!-- /.row -->
      </div>
      <!-- /.container -->
    </section>
    
</div>
