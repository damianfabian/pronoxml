(:
Copyright 2012 MarkLogic Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
:)
xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/config";

import module namespace def = "http://marklogic.com/roxy/defaults" at "/roxy/config/defaults.xqy";

declare namespace rest = "http://marklogic.com/appservices/rest";
declare namespace search = "http://marklogic.com/appservices/search";

declare variable $c:RESOURCE-DB := "@ml.resource-db";

declare variable $c:SESSION  := map:map();

declare variable $c:ADMIN   := "admin@pronoxml.com";

declare variable $c:DOCUMENTS_PATH   := "/pronoxml";

declare variable $c:BINARY_PATH   := "/binary";

declare variable $c:TOURNAMENT_COLLECTION   := "col:tournament";

(: Allows unauthenticated requests if set to true :)
declare variable $c:SESSION-AUTHENTICATE := fn:true();

(:
 : ***********************************************
 : Overrides for the Default Roxy control options
 :
 : See /roxy/config/defaults.xqy for the complete list of stuff that you can override.
 : Roxy will check this file (config.xqy) first. If no overrides are provided then it will use the defaults.
 :
 : Go to https://github.com/marklogic/roxy/wiki/Overriding-Roxy-Options for more details
 :
 : ***********************************************
 :)
declare variable $c:ROXY-OPTIONS :=
  <options>
    <layouts>
      <layout format="html">master</layout>
    </layouts>
  </options>;

(:
 : ***********************************************
 : Overrides for the Default Roxy scheme
 :
 : See /roxy/config/defaults.xqy for the default routes
 : Roxy will check this file (config.xqy) first. If no overrides are provided then it will use the defaults.
 :
 : Go to https://github.com/marklogic/roxy/wiki/Roxy-URL-Rewriting for more details
 :
 : ***********************************************
 :)
    declare variable $default-controller := "appbuilder";
    declare variable $default-function := "main";
    
    declare variable $c:ROXY-ROUTES :=
    <routes xmlns="http://marklogic.com/appservices/rest">
    <request uri="^/(css|js|img|font)/(.*)" endpoint="/public/$1/$2"/>
    {
        let $user := xdmp:get-session-field("logged-in-user")(:xdmp:get-current-user():)
        return
          if ($user ne '') then
          (
              <request uri="^/user/detail/(.*)" endpoint="/roxy/query-router.xqy">
                  <uri-param name="controller" default="{$default-controller}">user</uri-param>
                  <uri-param name="func" default="{$default-function}">detail</uri-param>
                  <uri-param name="id">$1</uri-param>
                  <http method="GET"/>
                  <http method="HEAD"/>
                  <http method="POST"/>
              </request>,
              <request uri="^/tournament/detail/(.*)" endpoint="/roxy/update-router.xqy">
                  <uri-param name="controller" default="{$default-controller}">tournament</uri-param>
                  <uri-param name="func" default="{$default-function}">detail</uri-param>
                  <uri-param name="id">$1</uri-param>
                  <http method="GET"/>
                  <http method="HEAD"/>
                  <http method="POST"/>
              </request>,
            $def:ROXY-ROUTES/rest:request
           )
          else
              <request uri="^/favicon.ico$" endpoint="/public/favicon.ico"/>,
              <request uri="^/user/(login|logout|register)" endpoint="/roxy/query-router.xqy">
                  <uri-param name="controller" default="{$default-controller}">user</uri-param>
                  <uri-param name="func" default="{$default-function}">$1</uri-param>
                  <uri-param name="format">html</uri-param>
                  <http method="GET"/>
                  <http method="HEAD"/>
                  <http method="POST"/>
              </request>,
              <request uri="^/.*$" endpoint="/roxy/query-router.xqy">
                  <uri-param name="controller" default="{$default-controller}">appbuilder</uri-param>
                  <uri-param name="func" default="{$default-function}">main</uri-param>
                  <uri-param name="format">html</uri-param>
                  <http method="GET"/>
                  <http method="HEAD"/>
              </request>
    }
    
  </routes>;

(:
 : ***********************************************
 : A decent place to put your appservices search config
 : and various other search options.
 : The examples below are used by the appbuilder style
 : default application.
 : ***********************************************
 :)
declare variable $c:DEFAULT-PAGE-LENGTH as xs:int := 10;

declare variable $c:SEARCH-OPTIONS :=
    <options xmlns="http://marklogic.com/appservices/search">
        <search-option>unfiltered</search-option>
        <term>
          <term-option>case-insensitive</term-option>
        </term>
        <constraint name="col">
          <collection/>
        </constraint>
        <constraint name="type">
           	<range type="xs:string" facet="true">
           	<facet-option>limit=5</facet-option>
           	<element ns="" name="type"/>
           	</range>
        </constraint>
        <constraint name="user">
            <element-query name="administrator" />
        </constraint>
        <constraint name="status">
            <element-query name="status" />
        </constraint>
        <search:operator name="ascending">
            <search:state name="name">
                <search:sort-order>
                    <element ns="" name="name"/>
                </search:sort-order>
            </search:state>
            <search:state name="type">
                <search:sort-order>
                    <element ns="" name="type"/>
                </search:sort-order>
            </search:state>
            <search:state name="date">
                <search:sort-order>
                    <element ns="" name="date"/>
                </search:sort-order>
            </search:state>
        </search:operator>
        <search:operator name="descending">
            <search:state name="name">
                <search:sort-order direction="descending">
                    <element ns="" name="name"/>
                </search:sort-order>
            </search:state>
            <search:state name="type">
                <search:sort-order direction="descending">
                    <element ns="" name="type"/>
                </search:sort-order>
            </search:state>
            <search:state name="date">
                <search:sort-order direction="descending">
                    <element ns="" name="date"/>
                </search:sort-order>
            </search:state>
        </search:operator>
        <return-results>true</return-results>
        <return-query>true</return-query>
    </options>;

(:
 : Labels are used by appbuilder faceting code to provide internationalization
 :)
declare variable $c:LABELS :=
  <labels xmlns="http://marklogic.com/xqutils/labels">
    <label key="facet1">
      <value xml:lang="en">Sample Facet</value>
    </label>
  </labels>;
  
declare variable $c:DISCIPLINES := 
    <disciplines>
        <discipline>Basketball</discipline>
        <discipline>Soccer</discipline>
        <discipline>Tennis</discipline>
        <discipline>Video Games</discipline>
    </disciplines>;