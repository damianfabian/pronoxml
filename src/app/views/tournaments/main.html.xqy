xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";
import module namespace sl = "http://www.marklogic.com/roxy/search-lib" at "/app/views/helpers/search-lib.xqy";
import module namespace facet = "http://marklogic.com/roxy/facet-lib" at "/app/views/helpers/facet-lib.xqy";
import module namespace c    = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
declare namespace search = "http://marklogic.com/appservices/search";

declare option xdmp:mapping "false";

declare variable $message           := vh:get("message");
declare variable $username          := vh:get("username");
declare variable $searchText          := vh:get("search");
declare variable $searchType          := vh:get("type");
declare variable $q as xs:string?   := vh:get("q");
declare variable $page as xs:int    := vh:get("page");
declare variable $response as element(search:response)?     := vh:get("response");
declare variable $top5 as element(search:response)?     := vh:get("top5");
declare variable $myTournaments as element(search:response)?     := vh:get("myTournaments");

<div class="scrollblock">
    <section id="tournaments">
            <div class="container">
                <div class="row">
                    <div class="span12">
                        <h1 id="folio-headline">Tournaments</h1>
                        <!-- Busquedas -->
                        <div class="row">
                          <!-- Facets -->
                          <div class="span4">
                          {
                            sl:filters($response, $page, $searchText, $searchType)
                          }
                          </div>
                          <!-- Fin Facets -->
                          <!-- Resultados -->
                          <div class="span7 offset1">
                          {
                            sl:template($response, $q, $page)
                          }
                          </div>
                          <!-- Fin Resultados -->
                        </div>
                        <!-- Fin Busqueda -->
                        <!-- /.row -->
                    </div>
                </div>
            </div>
    </section>
</div>,
<section id="contact" class="single-page scrollblock">
    <div class="container">
        <div class="row">
            <div class="span4">
                <div class="row">
                    <h2>Create new tournament</h2>
                </div>
                <!-- Formulario -->
                <div class="row">
                {
                    sl:tournament-form($message)
                }
                </div>
            </div>
            <div class="span8">
                 <div class="row">
                    <div class="span4">
                      <div class="align"> <i class="icon-group-circled">&nbsp;</i> </div>
                      <h2>My Tournaments</h2>
                      { sl:myTournaments($myTournaments) }
                    </div>
                    <!-- /.span3 -->
                    <div class="span4">
                      <div class="align"> <i class="icon-group-circled">&nbsp;</i> </div>
                      <h2>Top 5 Most Popular Tournaments</h2>
                      { sl:top5($top5) }
                    </div>
                    <!-- /.span3 -->
                </div>
            </div>
        </div>
    </div>
</section>
