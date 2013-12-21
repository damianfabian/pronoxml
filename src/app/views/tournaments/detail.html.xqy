xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";
import module namespace sl = "http://www.marklogic.com/roxy/search-lib" at "/app/views/helpers/search-lib.xqy";
import module namespace facet = "http://marklogic.com/roxy/facet-lib" at "/app/views/helpers/facet-lib.xqy";
import module namespace c    = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
declare namespace search = "http://marklogic.com/appservices/search";

declare option xdmp:mapping "false";

declare variable $message           := vh:get("message");
declare variable $username          := vh:get("username");
declare variable $id                := vh:get("id");
declare variable $tournament        := vh:get("tournament");

<div class="scrollblock">

    <section id="tournaments">
            <div class="container">
                <div class="row">
                    <div class="span12">
                        <h1 id="folio-headline">Details {$tournament/name/text()}</h1>
                        <!-- Busquedas -->
                        <div class="row">
                          <!-- Facets -->
                          <div class="span4">
                            <div class="wrapper table-responsive">
                            {
                                sl:details-forms($tournament)
                            }
                            </div>
                          </div>
                          <!-- Fin Facets -->
                          <!-- Resultados -->
                          <div class="span7 offset1">
                            <div class="results">
                            {
                                sl:details($tournament)
                            }
                            </div>
                          </div>
                          <!-- Fin Resultados -->
                        </div>
                        <!-- Fin Busqueda -->
                        <!-- /.row -->
                    </div>
                </div>
            </div>
    </section>
   
</div>
