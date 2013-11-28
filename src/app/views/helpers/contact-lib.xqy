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

module namespace cv = "http://www.marklogic.com/roxy/contact-view";

import module namespace form = "http://marklogic.com/roxy/form-lib" at "/app/views/helpers/form-lib.xqy";

declare option xdmp:mapping "false";

declare function cv:build-form($action-link, $message)
{
  <div class="cform" id="theme-form">
    <span class="lblerror">{fn:normalize-space($message)}</span>
    <form action="{$action-link}" method="post" class="cform-form">
        <div class="row">
            <div class="span6"> 
                <span class="your-name">
                    <input type="text" name="name" placeholder="Your Name" class="cform-text" size="40" title="your name" />
                </span> 
            </div>
            <div class="span6"> 
                <span class="your-email">
                    <input type="text" name="email" placeholder="Your Email" class="cform-text" size="40" title="your email" />
                </span> 
            </div>
        </div>
        <div class="row">
            <div class="span6"> 
                <span class="company">
                    <input type="text" name="company" placeholder="Your Company" class="cform-text" size="40" title="company" />
                </span> 
            </div>
            <div class="span6"> 
                <span class="website">
                    <input type="text" name="website" placeholder="Your Website" class="cform-text" size="40" title="website" />
                </span> 
            </div>
        </div>
        <div class="row">
            <div class="span12"> 
                <span class="message">
                    <textarea name="message" class="cform-textarea" cols="40" rows="10" title="drop us a line.">&nbsp;</textarea>
                </span> 
            </div>
        </div>
        <div>
          <input type="submit" name="send" value="Send message" class="cform-submit pull-left" />
        </div>
        <div class="cform-response-output">&nbsp;</div>
    </form>
  </div>
};
