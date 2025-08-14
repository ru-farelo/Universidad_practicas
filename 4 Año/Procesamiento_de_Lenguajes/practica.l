%{
#include <stdlib.h>
#include "practica.tab.h"
%}

%option yylineno

nl                  [\n]
nl2                 [\n]{2}
space               [" "]
slash               [/]
colon               [:]
barra               [-]
method              (GET|POST|PUT|DELETE|HEAD|OPTIONS|TRACE|CONNECT)
version             HTTP\/(0\.9|1\.0|1\.1|2|2\.0)
status_code         ("200 OK"|"201 Created"|"204 No Content"|"400 Bad Request"|"401 Unauthorized"|"403 Forbidden"|"404 Not Found"|"500 Internal Server Error")
local_host          localhost
ipv4                (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])){3}
ipv6                ([0-9a-fA-F]{1,4})(:([0-9a-fA-F]{1,4})){7}|(([0-9a-fA-F]{1,4}:){1,7}:|:|::|::([0-9a-fA-F]{1,4}:){1,6}([0-9a-fA-F]{1,4})?)
port                \:(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5]?[0-9]{1,4})
route               ("/"[a-zA-Z0-9\-._~%]+)*("?"[a-zA-Z0-9\-._~%]+)*
http_url            https?:\/\/[a-zA-Z0-9\-._~%]+(\.[a-zA-Z0-9\-._~%]+)*(:[0-9]+)?(\/[a-zA-Z0-9\-._~%]*)*(\?[a-zA-Z0-9\-._~%=&]*)?(#[a-zA-Z0-9\-._~%]*)?
domain              [^.][a-zA-Z0-9\-._~%]+(\.[a-zA-Z0-9\-._~%]+)*
host_name           [a-zA-Z0-9\-._~%]+
cache_control       (("no-cache"|"no-store"|"max-age"=[0-9]+|"max-stale"=[0-9]+|"min-fresh"=[0-9]+|"must-revalidate"|"proxy-revalidate"|"public"|"private"|"s-maxage"=[0-9]+)(,{space}("no-cache"|"no-store"|"max-age"=[0-9]+|"max-stale"=[0-9]+|"min-fresh"=[0-9]+|"must-revalidate"|"proxy-revalidate"|"public"|"private"|"s-maxage"=[0-9]+))*)?
accept              (("text"|"application"|"image"|"audio"|"video"|"message"|"multipart"|"model")\/[a-zA-Z0-9\-\+\.]+(\;{space}q\=[0-9]\.[0-9])?)(,{space}(("text"|"application"|"image"|"audio"|"video"|"message"|"multipart"|"model")\/[a-zA-Z0-9\-\+\.]+(\;{space}q\=[0-9]\.[0-9])?))*
accept_encoding     (("gzip"|"compress"|"deflate"|"br"|"identity"|"*"|"x-compress"|"x-gzip")(\;{space}q\=[0-9]\.[0-9])?)(,{space}(("gzip"|"compress"|"deflate"|"br"|"identity"|"*"|"x-compress"|"x-gzip")(\;{space}q\=[0-9]\.[0-9])?))*
accept_lenguage     [a-zA-Z]{1,8}(-[a-zA-Z]{1,8})?(\;{space}q=[0-9]\.[0-9])?(,{space}[a-zA-Z]{1,8}(-[a-zA-Z]{1,8})?(\;q=[0-9]\.[0-9])?)*
content_lenght      [0-9]+
content_type        ([a-zA-Z0-9\-\.]+\/[a-zA-Z0-9\-\.]+)
server              [a-zA-Z0-9\ \/\-\.]+(\([a-zA-Z0-9\ \/\-\.]*\))?
day                 (Mon|Tue|Wed|Thu|Fri|Sat|Sun)
date                {day},\ [0-9]{2}\ (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\ [0-9]{4}\ [0-9]{2}:[0-9]{2}:[0-9]{2}\ GMT             

phrase              [a-zA-Z0-9]+
body                .*

%%
{method} { return METHOD;}
{version} { return VERSION;}

{method}{space}({local_host}|{ipv4}|{ipv6}){port}{space}{version} { return REQUEST_LINE_HP;}
{method}{space}("*"|{route}|{slash}){space}{version} { return REQUEST_LINE_RUTE;}
{method}{space}{http_url}{space}{version} { return REQUEST_LINE_HTTP;}
{method}{space}({local_host}|{ipv4}|{ipv6}){port}({route}|{slash}){space}{version} { return REQUEST_LINE_HPR;}
{method}{space}{domain}{port}{space}{version} { return REQUEST_LINE_DOMAIN;}

{version}{space}{status_code} { return RESPONSE_LINE;}

"Host"{colon}{space}({host_name}(\.{host_name})*)({colon}{port})? {return HOST;}
"Cache"{barra}"Control"{colon}{space}{cache_control} {return CACHE_CONTROL;}
"Accept"{colon}{space}{accept} {return ACCEPT;}
("Accept-Encoding"|"Content-Encoding"){colon}{space}{accept_encoding} {return ACCEPT_ENCODING;}
"Accept-Language"{colon}{space}{accept_lenguage} {return ACCEPT_LENGUAGE;}
"Content-Type"{colon}{space}{content_type}   {return ACCEPT_CONTENT_TYPE;}
"Content-Length"{colon}{space}{content_lenght}   {return ACCEPT_CONTENT_LENGHT;}
"User-Agent"{colon}{space}{server}  {return ACCEPT_USER_AGENT;}
"Server"{colon}{space}{server}  {return ACCEPT_SERVER;}
"Date"{colon}{space}{date}  {return DATE;}

{nl}       { return NL; }
{phrase}   { return PHRASE; }
{nl2} {return NEW_LINE_2; }
.          { return OTHER; }


{body} { yylval.sval = strdup(yytext); return BODY;}

<<EOF>>            { return ENDFILE; }
%%
