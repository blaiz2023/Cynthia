unit gossnet;

interface
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot, gossio, gosswin;
{$B-} {generate short-circuit boolean evaluation code -> stop evaluating logic as soon as value is known}
//## ==========================================================================================================================================================================================================================
//##
//## MIT License
//##
//## Copyright 2025 Blaiz Enterprises ( http://www.blaizenterprises.com )
//##
//## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
//## files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
//## modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
//## is furnished to do so, subject to the following conditions:
//##
//## The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//##
//## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//## CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//##
//## ==========================================================================================================================================================================================================================
//## Library.................. network (gossnet.pas)
//## Version.................. 4.00.950 (+10)
//## Items.................... 6
//## Last Updated ............ 19jun2025, 07apr2025, 15mar2025, 20feb2025, 18dec2024, 15nov2024, 18aug2024, 04may2024, 23apr2024
//## Lines of Code............ 2,700+
//##
//## main.pas ................ app code
//## gossroot.pas ............ console/gui app startup and control
//## gossio.pas .............. file io
//## gossimg.pas ............. image/graphics
//## gossnet.pas ............. network
//## gosswin.pas ............. 32bit windows api's/xbox controller
//## gosssnd.pas ............. sound/audio/midi/chimes
//## gossgui.pas ............. gui management/controls
//## gossdat.pas ............. app icons (24px and 20px) and help documents (gui only) in txt, bwd or bwp format
//## gosszip.pas ............. zip support
//## gossjpg.pas ............. jpeg support
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | tnetmore               | tobject           | 1.00.003  | 24jun2024   | Helper object for app level net task/data management, 23dec2023: created
//## | tnetbasic              | tnetmore          | 1.00.081  | 18aug2024   | Helper object for server connection servicing, 13apr2024: added vmustlog, 23dec2023: created
//## | dns__*                 | family of procs   | 1.00.070  | 05apr2025   | DNS message handlers
//## | net__*                 | family of procs   | 1.00.420  | 05apr2025   | Create and maintain tcp server and inbound client connections, 15mar2025, 09aug2024, 01par2024: added ssPert support in net__encodeurl(), 06mar2024: queue size fo servers, 30jan2024: Created
//## | ipsec__*               | family of procs   | 1.00.280  | 19jun2025   | Track client IP hits, errors and current ban status, 07apr2025: notthislink(BadBot) tracking, 20feb2025: added ipsec->post2 support, 18aug2024, 03may2024: fixed scanfor/banfor range oversight in ipsec__update(), 07jan2024: created
//## | log__*                 | family of procs   | 1.00.086  | 18jun2025   | Web traffic log for server traffic, 09aug2024, 03apr2024: using filterstr, 01apr2024: optional "__" in "date__logname" only when logname present, 07mar2024: fixed alternative folder, 07jan2024: created
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================

type
   tnetmore        =class;
   tnetbasic       =class;

   //.tnetwork
   pnetwork=^tnetwork;
   tnetwork=record
    init:boolean;//true=record has been initiated and is valid
    slot:longint;//read only -> links to system list
    port:longint;
    sock_ip4:tint4;//direct access to all 4 bytes of address e.g. "sock_ip4.ints[0]" returns first byte which would be 127 for ip=127.0.0.1
    sock:tsocket;
    ownk:tsocket;//owner of this record's "sock" e.g a server that spawns this client socket process
    //.can -> tied to fd_read and fd_write
    canread:boolean;
    canwrite:boolean;
    //.time + used
    time_created:comp;//time this record was created - 06apr2024
    time_idle:comp;//used for idle timeout detection
    used:comp;//number of times this record is reused during a connection -> e.g. keep-alive sends multiple requests down the same connection -> this var "used" increments for each request - 06jan2024
    recycle:comp;//tracks number of times the record is recycled for life of program -> never resets
    //.type
    server:boolean;
    client:boolean;
    //.application level helpers / actions
    more:tnetmore;
    mustclose:boolean;//true=tells application to close the record
    connected:boolean;
    infotag:byte;
    infolastip:string;//purely optional
    infolastmode:byte;//0=none, 1=reading, 2=writing
    end;

   tnet__closeevent=procedure(x:pnetwork);

   //.tipsecurity - record is considered "inuse" when "alen>=1"
   pipsecurity=^tipsecurity;
   tipsecurity=record
    //.ip address as byte array
    alen:byte;//0=record not in use, 1..N=record in use
    aref:longint;
    aref2:longint;
    addr:array[0..40] of byte;//a fully qualified IPv6 address with [..] square brackets uses 41 bytes
    //.counters
    hits:longint;
    bad:longint;//e.g. number of failed login attempts
    post:longint;//e.g. number of post request, e.g. to the contact form "contact.html"
    post2:longint;//e.g. number of "tools-*" post requests, e.g. to "tools-iconmaker.html" - 20feb2025
    conn:longint;//number of simultaneous connections
    notthislink:longint;//number of times a Bad Bot attempted to access secret "notthislink" file
    badrequest:longint;//number of times a bad request is made, e.g. a 502 (Bad Gateway) or 400 (Bad Request) - 18jun2025
    badmail:longint;//19jun2025
    //.bandwidth in bytes consumed both for in and out data transfers
    bytes:comp;
    //.reference
    age32:longint;//time since the record was first created in minutes
    ban:boolean;//true=this ip is banned
    end;

{tnetmore}
   tnetmore=class(tobject)//used by "net__*" procs as an app level helper object
   private

   public
    constructor create; virtual;
    destructor destroy; override;
    procedure clear; virtual;
   end;

{tnetbasic}
   tnetbasic=class(tnetmore)
   private

   public
    //vars
    //.info
    vonce:boolean;
    vstarttime:comp;//start time -> e.g. when request FIRST starts streaming in
    vmustlog:boolean;
    //.login session info
    vsessname:string;
    vsessvalid:boolean;
    vsessindex:longint;
    //.read
    r10:boolean;
    r13:boolean;
    htoobig:boolean;
    hread:comp;//bytes received by server
    hlenscan:longint;
    hlen:longint;
    clen:comp;
    htempfile:longint;//0..N=a large upload was received and was stored on disk as a temp file using the "network.slot" as the id (buffer will be empty), -1=not used
    hmethod:longint;//hmUNKNOWN..hmMAX
    hver:longint;//hvUnknown..hvMax
    hconn:longint;
    hwantdata:boolean;//true=should include data, false=should EXCLUDE data
    hport:longint;
    hhost:string;
    hdesthost:string;//host after mapping
    hdiskhost:string;//e.g. "www_"
    hka:boolean;
    hcookie_k:string;//admin session cookie - 11mar2024
    hua:string;
    hcontenttype:string;//08feb2024
    hreferer:string;
    hrange:string;
    hif_match:string;
    hif_range:string;
    hip:string;
    hpath:string;
    hname:string;
    hnameext:string;//lowercase extension
    hgetdat:string;//data after the question mark e.g. "/index.html?some-data-here"
    hslot:longint;//slot returned from "ipsec__slot()" for tracking the ip address -> sought AFTER the head has been read/partly read
    //.module support - 17aug2024
    hmodule_index:longint;//-1=no module used by default
    hmodule_uploadlimit:longint;//0
    hmodule_multipart:boolean;//false
    hmodule_canmakeraw:boolean;//false
    hmodule_readpost:boolean;//false
    //.write
    writing:boolean;
    wheadlen:comp;
    wlen:comp;
    wsent:comp;//bytes transmitted to client
    wfrom:comp;
    wto:comp;
    wmode:longint;//0=buffer, 1=ram, 2=disk
    wramindex:longint;//for wmode=1 -> for direct access to RAM stored file
    wcode:longint;//used for logs
    wfilename:string;//for wmode 1/2
    wfilesize:comp;//size of file/data (not the amount being streamed)
    wfiledate:tdatetime;//date of file
    wbufsent:longint;
    //.common
    buf:tobject;//can be a tstr8 or tstr9
    splicemem:pdlbyte;
    splicelen:longint;
    //.mail specific vars
    mdata:boolean;//true=within the receiving "data" block command and waiting for the "." on a single line
    //create
    constructor create; override;
    destructor destroy; override;
    //workers
    procedure clear; override;
   end;

var
   //.started
   system_started      :boolean=false;
   //.network
   system_net_session  :boolean=false;
   system_net_sesinfo  :TWSAData;
   system_net_slot     :array[0..system_net_limit-1] of tnetwork;//272 Kb
   system_net_count    :longint=0;//marks the highest slot used -> if this slot is subsequently closed, the count value may linger for stability/speed - 23dec2023
   system_net_sock     :tdynamicinteger=nil;
   system_net_in       :comp=0;//in bytes
   system_net_out      :comp=0;//out bytes
   //.log - 05jan2024
   system_log_folder   :string='';//optional - 07mar2024
   system_log_name     :string='';
   system_log_datename :string='';
   system_log_safename :string='';
   system_log_cache    :tstr8=nil;
   system_log_cachetime:comp=0;
   system_log_varstime1:comp=0;
   system_log_varstime2:comp=0;
   system_log_gmtoffset:string='';
   system_log_gmtnowstr:string='';//to nearest second
   //.ip security
   system_ipsec_slot        :array[-1..system_ipsec_limit-1] of tipsecurity;//840 Kb -> Note: the "-1" entry is there ONLY as a catch for when the ipsec procs return "slot=-1" and an app may pass this on to the global system var "system_ipsec_slot[]" instead of using the safe "ipsec__*" procs which handle this value properly without fault - 07jan2024
   system_ipsec_count       :longint=0;//marks the highest slot used -> if this slot is subsequently closed, the count value may linger for stability/speed - 07jan2024
   system_ipsec_scanfor     :longint=24*60;//1 day in minutes
   system_ipsec_banfor      :longint=7*24*60;//1 week in minutes
   system_ipsec_connlimit   :longint=0;//no limit -> sim. connections
   system_ipsec_postlimit   :longint=0;//no limit -> hits
   system_ipsec_postlimit2  :longint=0;//no limit -> hits
   system_ipsec_badlimit    :longint=0;//no limit -> hits
   system_ipsec_hitlimit    :longint=0;//no limit -> hits
   system_ipsec_badreqlimit :longint=0;//no limit -> hits
   system_ipsec_badmaillimit:longint=0;//no limit -> hits
   system_ipsec_datalimit   :comp=0;//no limit -> in bytes (counts for both upload and download bandwidth)

//start-stop procs -------------------------------------------------------------
procedure gossnet__start;
procedure gossnet__stop;

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function app__bol(xname:string):boolean;
function info__net(xname:string):string;//information specific to this unit of code


//dns support procs ------------------------------------------------------------
function dns__pushquery_A(s:tstr8;xmsgid:word;xdomain:string):boolean;
function dns__pushquery_MX(s:tstr8;xmsgid:word;xdomain:string):boolean;
function dns__pushquery_XXX(s:tstr8;qtype:longint;xmsgid:word;xdomain:string):boolean;

function dns__pullquery_A(s:tstr8;sdelete:boolean;var xlist:string):boolean;
function dns__pullquery_MX(s:tstr8;sdelete:boolean;var xlist:string):boolean;
function dns__pullquery_XXX(s:tstr8;sQtype:longint;sdelete:boolean;var xlist:string):boolean;


//network support procs --------------------------------------------------------
function net__mimefind(xext:string):string;
function net__mimelist(xindex:longint;var xext,xtype:string):boolean;
function net__IP4str(x:longint):string;
function net__IP4strR(x:longint):string;//reversed
function net__strIP4(x:string;var xip4:longint):boolean;
function net__strIP4b(x:string):longint;
function net__strIP4R(x:string;var xip4:longint):boolean;//reversed
function net__strIP4Rb(x:string):longint;
function net__cleanlistIP4(const x:string):string;//one IP4 address per line - 05apr2025


//network procs ----------------------------------------------------------------
//* provides server and inbound client network support
//.sockets
function net__makesession:boolean;
procedure net__closesession;
//.information
procedure net__inccounters(xin,xout:comp);
function net__in:comp;//bytes in
function net__out:comp;//bytes out
function net__total:comp;//total bytes (both ways)
//.tnetwork records
function net__limit:longint;//maximum number of records for system
function net__count:longint;//number of records in use, does not shrink automatically
function net__findcount:longint;//find new "net__count" and update it
procedure net__initrec(x:pnetwork);//used internally by system
function net__sockip4(xsock:tsocket;var xip4:longint):boolean;//lookup client IP address from Windows socket
function net__findbysock(var x:pnetwork;xsock:tsocket):boolean;//09apr2024: fixed + updated
function net__tempfile(xslot:longint;var xfilename:string):boolean;
function net__tempfile_appendto(var a:pnetwork;xfirst:boolean):boolean;
function net__recinfo(var a:pnetwork;var m:tnetbasic;var buf:pobject):boolean;
function net__haverec(var x:pnetwork;xindex:longint):boolean;//we have a network record for that index (index is a slot in the system list of network records)
function net__makerec(var x:pnetwork):boolean;//make a new network record -> at this stage it is neither a client or a server just a basic record
function net__makerec2(var x:pnetwork;xlimit:longint;const xclosetag_list:array of byte;xclose_oldest_event:tnet__closeevent):boolean;
function net__makeclient(var x:pnetwork;xlimit:longint;xsock:tsocket):boolean;//binds socket to network record and marks the record as a client e.g. "record.client=true"
function net__makeclient2(var x:pnetwork;xlimit:longint;xsock,xowner:tsocket;const xclosetag_list:array of byte;xclose_oldest_event:tnet__closeevent):boolean;//06apr2024: recycle support
function net__makeserver(var x:pnetwork;xport,xqueuesize:longint):boolean;//creates a server socket and binds it to the network record.  If the current record is a client, it is closed and a server is started in it's place. To change server port, set the record.port and call this function
function net__makeserver2(var x:pnetwork;xport,xqueuesize:longint;xclosechildren:boolean):boolean;//the xclosechildren option when set to TRUE, forcibly closes all inbound client connections associated with the server socket BEFORE making any modifications to the server
function net__closerec(x:pnetwork):boolean;//close the socket bound to the network record and releases the record back to the system
function net__closerec2(x:pnetwork;xclosesock:boolean):boolean;//optionally the socket can be left intact whilst release the network record
function net__closerec3(x:pnetwork;xclosesock:boolean;xclose_event:tnet__closeevent):boolean;
procedure net__closeonlysocket(var x:pnetwork);//closes the socket bound to the network record but leaves the record otherwise intact
procedure net__closeonlysocket2(var x:pnetwork;xclosechildren:boolean);//meant for a server with children sockets, the children are closed first then the server socket
procedure net__closeonlysocketsBYownk(var x:pnetwork);//use a server record to close all it's children socket connections only, records remain intact
procedure net__closerecBYownk(var x:pnetwork);//use a server record to close all it's children socket connections AND their network records too
procedure net__closerecBYownk2(var x:pnetwork;xclose_event:tnet__closeevent);
function net__socketgood(var x:pnetwork):boolean;//tests a network record's socket and returns TRUE if socket is valid and FALSE if the socket is an "invalid_socket"
function net__connected(var x:pnetwork):boolean;
//function net__closesocket(x:pnetwork):boolean;
procedure net__closeall;//closes the entire network system, including helper objects, and is reserved for use internally within "app__run" during shutdown - don't use directly
function net__accept(s:tsocket):tsocket;//accepts an inbound client connection to the server socket, uses Windows message FD_CONNECT
//.support procs
procedure net__decodestr(var x:string);//decode post data from a html upload stream - 12jun2006
function net__decodestrb(x:string):string;
function net__encodeforhtml(s,d:tstr8):boolean;//encode html data for use in web forms, such as retaining user supplied html code via a <textarea>..</textare> element of a <form>...</form>
function net__encodeforhtml2(s,d:tstr8;xuseincludelist,xuseskiplist:boolean;const xincludelist,xskiplist:array of byte):boolean;//full web support + BWD1 style support - 15apr2024: includelist, 13jun2016, 05mar2016, 12-JUN-2006
function net__encodeforhtmlstr(x:string):string;//same as net__encodeforhtml() but uses strings
function net__encodeforhtmlstr2(x:string;xuseincludelist,xuseskiplist:boolean;const xincludelist,xskiplist:array of byte):string;
function net__encodeurl(s,d:tstr8;xleaveslash:boolean):boolean;//01apr2024: added ssPert (previously missing), 15jan2024, 29dec2023
function net__encodeurlstr(x:string;xleaveslash:boolean):string;
function net__ismultipart(xcontenttype:string;var boundary:string):boolean;

//ipsec procs ----------------------------------------------------------------
//* provides IP tracking for server security and autonomous banning control (automatic engage and disengage)
function ipsec__limit:longint;//maximum number of records for the system
function ipsec__count:longint;//number of records in use, does not shrink automatically
function ipsec__findcount:longint;//find new "ipsec__count" and update it
function ipsec__newslot:longint;
function ipsec__findaddr(var xaddr:string;var xslot:longint):boolean;
//.vals
function ipsec__setvals(xscanfor,xbanfor:longint;xconnlimit,xpostlimit,xpostlimit2,xbadlimit,xhitlimit,xbadreqlimit,xbadmaillimit:longint;xdatalimit:comp):boolean;
function ipsec__getvals(var xscanfor,xbanfor,xconnlimit,xpostlimit,xpostlimit2,xbadlimit,xhitlimit,xbadreqlimit,xbadmaillimit:longint;var xdatalimit:comp):boolean;
function ipsec__scanfor:longint;
function ipsec__banfor:longint;
function ipsec__connlimit:longint;
function ipsec__postlimit:longint;
function ipsec__postlimit2:longint;
function ipsec__badlimit:longint;
function ipsec__hitlimit:longint;
function ipsec__badreqlimit:longint;//18jun2025
function ipsec__badmaillimit:longint;//18jun2025
function ipsec__datalimit:comp;
//.query procs
function ipsec__trackb(xaddr:string;var xnewslot:boolean):longint;
function ipsec__track(xaddr:string;var xslot:longint;var xnewslot:boolean):boolean;
function ipsec__incHit(xslot:longint):boolean;
function ipsec__incBadrequest(xslot:longint):boolean;//18jun2025
function ipsec__incBadmail(xslot:longint):boolean;//19jun2025
function ipsec__incBad(xslot:longint):boolean;
function ipsec__incPost(xslot:longint):boolean;
function ipsec__incPost2(xslot:longint):boolean;//20feb2025
function ipsec__incNotThisLink(xslot:longint):boolean;//07apr2025
function ipsec__incConn(xslot:longint;xinc:boolean):boolean;//sim. connection tracking
function ipsec__incBytes(xslot:longint;xbytes:comp):boolean;
function ipsec__banned(xslot:longint):boolean;
function ipsec__update(xslot:longint):boolean;//03may2024
function ipsec__clearall:boolean;
function ipsec__clearslot(xslot:longint):boolean;//03may2024
function ipsec__slot(xslot:longint;var xaddress:string;var xmins,xconn,xpost,xpost2,xbad,xhits,xbadrequest,xbadmail,xnotthislink:longint;var xbytes:comp;var xbanned:boolean):boolean;
function ipsec__slotBytes(xslot:longint):comp;//18aug2024

//log procs --------------------------------------------------------------------
function log__code(xrootcode,xaltcode:longint):longint;
function log__code2(var a:pnetwork;xaltcode:longint):longint;
function log__addentry(xfolder,xlogname:string;var a:pnetwork;xaltcode:longint):boolean;//03apr2024: using filterstr, 01apr2024: updated "__" optional when logname present (date__logname.txt)
function log__addmailentry(xfolder,xlogname:string;var a:pnetwork;xcode:longint;xbandwidth:comp):boolean;//03apr2024: using filterstr
function log__filterstr(x:string):string;
function log__writemaybe:boolean;
function log__writenow:boolean;
procedure log__fastvars;


implementation


//start-stop procs -------------------------------------------------------------
procedure gossnet__start;
var
   p:longint;
begin
try
//check
if system_started then exit else system_started:=true;

//network support
for p:=0 to (system_net_limit-1) do net__initrec(@system_net_slot[p]);

//ip security support - 03may2024
for p:=low(system_ipsec_slot) to (system_ipsec_limit-1) do ipsec__clearslot(p);
except;end;
end;

procedure gossnet__stop;
begin
try
//check
if not system_started then exit else system_started:=false;

net__closesession;

//.this buffer is left running in the program and ONLY destoyed here -> once it's running not safe to shrink/remove it
if (system_net_sock<>nil) then freeobj(@system_net_sock);
except;end;
end;

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function app__bol(xname:string):boolean;
begin
result:=strbol(app__info(xname));
end;

function info__net(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gossnet.*"
if (strcopy1(xname,1,8)='gossnet.') then strdel1(xname,1,8) else exit;

//get
if      (xname='ver')        then result:='4.00.950'
else if (xname='date')       then result:='19jun2025'
else if (xname='name')       then result:='Network'
else
   begin
   //nil
   end;

except;end;
end;


//dns support procs ------------------------------------------------------------
function dns__pushquery_A(s:tstr8;xmsgid:word;xdomain:string):boolean;
begin
result:=dns__pushquery_XXX(s,1,xmsgid,xdomain);
end;

function dns__pushquery_MX(s:tstr8;xmsgid:word;xdomain:string):boolean;
begin
result:=dns__pushquery_XXX(s,15,xmsgid,xdomain);
end;

function dns__pushquery_XXX(s:tstr8;qtype:longint;xmsgid:word;xdomain:string):boolean;
var
   i,vlen,lp,p,xlen:longint;
   v:string;
begin
//defaults
result:=false;

//check
if not str__lock(@s) then exit;

try
//init
xdomain :=strcopy1(xdomain,1,255)+'.';
xlen    :=low__len(xdomain);
qtype   :=frcrange32(qtype,0,max16);

//init
i:=s.len;
s.addwrd2R(0);//tcp data length - modified last

//header
s.addwrd2R(xmsgid);//.app id for request
s.aadd([1,0]);//header flags - recurse required -> needed to lookup addresses not stored directly at the DNS server we are querying - 04oct2021

//rcounts
s.addwrd2R(1);//qdcount
s.addwrd2R(0);//ancount
s.addwrd2R(0);//nscount
s.addwrd2R(0);//arcount

//question section
//.QNAME
lp:=1;

for p:=1 to xlen do if (xdomain[p-1+stroffset]='.') then
   begin
   v   :=strcopy1(xdomain,lp,p-lp);
   vlen:=low__len(v);
   lp  :=p+1;

   if (vlen>=1) then
      begin
      s.addbyt1(vlen);
      s.sadd(v);
      end
   else break;

   end;

//.finalise with a trailing zero length terminator
s.addbyt1(0);

//.QTYPE -> A=1, CNAME=5, PTR=12, MX=15, TXT=16
s.addwrd2R(qtype);

//.QCLASS -> IN=1 (internet)
s.addwrd2R(1);

//.tcp data length
s.wrd2R[i]:=frcmin32(s.len-i-2,0);

//set
result:=true;
except;end;
//free
str__uaf(@s);
end;

function dns__pullquery_A(s:tstr8;sdelete:boolean;var xlist:string):boolean;
begin
result:=dns__pullquery_XXX(s,1,sdelete,xlist);
end;

function dns__pullquery_MX(s:tstr8;sdelete:boolean;var xlist:string):boolean;
begin
result:=dns__pullquery_XXX(s,15,sdelete,xlist);
end;

function dns__pullquery_XXX(s:tstr8;sQtype:longint;sdelete:boolean;var xlist:string):boolean;
label
   skipend;
var
   a:tstr8;
   xkeeppos,qtype,rdlen,p,slen,xpos,qc,ac:longint;
   xname:string;

   function xreadname:string;
   var
      dlen,dcount,dpos:longint;

      procedure dinc(xby:longint);
      begin
      inc(dpos,xby);
      if (dpos>xpos) then xpos:=dpos;
      end;
   begin
   result:='';
   dpos  :=xpos;
   dcount:=0;

   while true do
   begin
   dlen:=s.bytes[dpos];

   if (dlen=0) then
      begin
      dinc(1);
      break;
      end
   else if (dlen>=192) then
      begin
      inc(dcount);
      if (dcount<=100) then
         begin
         if (dcount<=1) then inc(xpos,2);
         dpos:=2+s.wrd2R[dpos]-49152;
         end
      else break;
      end
   else if (dlen<=63) then
      begin
      dinc(1);
      result:=result+insstr('.',result<>'')+s.str[dpos,dlen];
      dinc(dlen);
      end;

   //inc
   if ((dpos+1)>=slen) then break;
   end;//loop

   end;
begin
//defaults
result:=false;
xlist :='';
a     :=nil;
qtype :=0;//18may2025

//check
if not str__lock(@s) then exit;

try
//init
xpos:=0;
slen:=s.len;
if (slen<2) or (slen<(2+s.wrd2R[0])) then goto skipend;
a   :=str__new8;

//info
inc(xpos,2);//.tcp header
inc(xpos,2);//.dns msg id

//w:=s.wrd2[xpos];//dns header
inc(xpos,2);

{
v:=0;
if bit__true16(w,12) then inc(v,1);
if bit__true16(w,13) then inc(v,2);
if bit__true16(w,14) then inc(v,4);
if bit__true16(w,15) then inc(v,8);
}

qc:=s.wrd2R[xpos];//qdcount
inc(xpos,2);

ac:=s.wrd2R[xpos];//ancount
inc(xpos,2);

//nc:=s.wrd2R[xpos];//nscount
inc(xpos,2);

//mc:=s.wrd2R[xpos];//arcount
inc(xpos,2);

//read past question (if present)
if (qc>=1) then
   begin
   xreadname;
   inc(xpos,2);//qtype
   inc(xpos,2);//qclass
   end;

//read answer
if (ac>=1) then
   begin
   for p:=0 to (ac-1) do
   begin
   //name
   xname:=xreadname;

   //type 2
   qtype:=s.wrd2R[xpos];
   inc(xpos,2);

   //class 2
   inc(xpos,2);

   //ttl 4
   inc(xpos,4);

   //rdlenth
   rdlen:=s.wrd2R[xpos];
   inc(xpos,2);
   xkeeppos:=xpos;

   //rdata
   if (qtype=1) then//A record
      begin
      a.sadd(net__ip4str(s.int4[xpos])+#10);//IPv4 as string
      inc(xpos,4);
      end

   else if (qtype=15) then//MX record
      begin
      //s.wrd2R[xpos];//preference for mail server
      inc(xpos,2);

      a.sadd(xreadname+#10);//mail domain as string
      end;

   //inc rdlen
   xpos:=xkeeppos+rdlen;
   end;//p
   end;

//delete
if sdelete then s.del3(0,2+s.wrd2R[0]);

//check
if (qtype<>sqtype) then goto skipend;

//set
xlist:=a.text;

//successful
result:=true;
skipend:
except;end;
//reset on error
if not result then xlist:='';
//free
str__free(@a);
str__uaf(@s);
end;


//network support procs --------------------------------------------------------
function net__mimefind(xext:string):string;
var
   p:longint;
   n,v:string;
begin
result:='';

for p:=0 to max32 do
begin
if not net__mimelist(p,n,v) then break;

if strmatch(xext,n) then
   begin
   result:=v;
   break;
   end
else if (n='*') then
   begin
   result:=v;
   break;
   end;
end;//p

end;

function net__mimelist(xindex:longint;var xext,xtype:string):boolean;
   procedure xadd(sext,stype:string);
   begin
   result:=true;
   xext  :=strlow(sext);
   xtype :=strlow(stype);
   end;
begin
case xindex of
0:xadd('epub' ,'application/epub+zip');
1:xadd('html','text/html');
2:xadd('htm' ,'text/html');
3:xadd('xml' ,'text/xml');
4:xadd('xhtml','application/xhtml+xml');
5:xadd('txt'  ,'text/plain');
6:xadd('text' ,'text/plain');
7:xadd('css'  ,'text/css');
8:xadd('pdf'  ,'application/pdf');
9:xadd('rtf'  ,'application/rtf');
10:xadd('js'   ,'application/x-javascript');
11:xadd('mocha','application/x-javascript');
12:xadd('pl'   ,'application/x-perl');
13:xadd('png'  ,'image/png');
14:xadd('jpg'  ,'image/jpeg');
15:xadd('jpeg' ,'image/jpeg');
16:xadd('jpe'  ,'image/jpeg');
17:xadd('jif'  ,'image/jpeg');
18:xadd('jfif' ,'image/jpeg');
19:xadd('gif'  ,'image/gif');
20:xadd('ico'  ,'image/x-icon');
21:xadd('bmp'  ,'image/bmp');
22:xadd('tif'  ,'image/tiff');
23:xadd('tiff' ,'image/tiff');
24:xadd('tga' ,'image/x-tga');//22feb2025
25:xadd('tea' ,'image/x-tea');//22feb2025
26:xadd('exe'  ,'application/vnd.microsoft.portable-executable');//05mar2020 -> was: 'exe=application/octet-stream'
27:xadd('eml'  ,'message/rfc822');//15apr2024
28:xadd('zip'  ,'application/zip');//05mar2020 -> was: 'zip=application/x-zip-compressed');
29:xadd('7z'   ,'application/x-7z-compressed');
30:xadd('gz'   ,'application/x-gzip');
31:xadd('z'    ,'application/x-compress');
32:xadd('tgz'  ,'application/x-compressed');
33:xadd('gtar' ,'application/x-gtar');
34:xadd('tar'  ,'application/x-tar');
35:xadd('apk'  ,'application/vnd.android.package-archive');
36:xadd('wav'  ,'audio/wav');
37:xadd('mp3'  ,'audio/mpeg');
38:xadd('mp4'  ,'video/mp4');
39:xadd('wma'  ,'audio/x-ms-wma');
40:xadd('webm' ,'video/webm');
41:xadd('weba' ,'audio/webm');//verified as correct - 24mar2024
42:xadd('webp' ,'image/webp');//verified as correct - 24mar2024
43:xadd('mkv'  ,'video/x-matroska');
44:xadd('mid'  ,'audio/midi');//was audio/x-midi
45:xadd('midi' ,'audio/midi');//was audio/x-midi
46:xadd('bwd'  ,'application/x-bwd');
47:xadd('bwp'  ,'application/x-bwp');
48:xadd('*'    ,'application/octet-stream');//.absolute fallback
else result:=false;
end;//case
end;

function net__IP4str(x:longint):string;
begin
result:=
intstr32(tint4(x).bytes[0])+'.'+
intstr32(tint4(x).bytes[1])+'.'+
intstr32(tint4(x).bytes[2])+'.'+
intstr32(tint4(x).bytes[3]);
end;

function net__IP4strR(x:longint):string;//reversed
begin
result:=
intstr32(tint4(x).bytes[3])+'.'+
intstr32(tint4(x).bytes[2])+'.'+
intstr32(tint4(x).bytes[1])+'.'+
intstr32(tint4(x).bytes[0]);
end;

function net__strIP4b(x:string):longint;
begin
net__strIP4(x,result);
end;

function net__strIP4(x:string;var xip4:longint):boolean;
var
   a:tint4;
   xcount,lp,p:longint;
begin
//defaults
result :=false;
xip4   :=0;
x      :=x+'.';
xcount :=0;
lp     :=1;

//get
for p:=1 to low__len(x) do if (x[p-1+stroffset]='.') then
   begin
   //set
   if (xcount>=0) and (xcount<=3) then a.bytes[xcount]:=frcrange32( strint32( strcopy1(x,lp,p-lp) ),0,255);
   if (xcount>=3) then
      begin
      result:=true;
      xip4:=a.val;
      break;
      end;
   //inc
   inc(xcount);
   lp:=p+1;
   end;
end;

function net__strIP4Rb(x:string):longint;
begin
net__strIP4R(x,result);
end;

function net__strIP4R(x:string;var xip4:longint):boolean;//reversed
var
   s,d:tint4;
begin
result:=net__strip4(x,s.val);
d.bytes[0]:=s.bytes[3];
d.bytes[1]:=s.bytes[2];
d.bytes[2]:=s.bytes[1];
d.bytes[3]:=s.bytes[0];
xip4:=d.val;
end;

function net__cleanlistIP4(const x:string):string;//one IP4 address per line - 05apr2025
var
   a:tstr8;
   xip4,xlen,xpos:longint;
   xline:string;
begin
//defaults
result :='';
xlen   :=low__len(x);
xpos   :=1;
a      :=nil;

try
//init
a:=str__new8;

//get
while low__nextline1(x,xline,xlen,xpos) do if (xline<>'') then
   begin
   xline:=stripwhitespace_lt(xline);
   if (xline<>'') and net__strIP4(xline,xip4) then str__sadd(@a,net__IP4str(xip4)+#10);
   end;

//set - remove duplicates
result:=low__remdup(str__text(@a));
except;end;
//free
str__free(@a);
end;


//network procs ----------------------------------------------------------------
procedure net__inccounters(xin,xout:comp);
begin
if (xin>=1)  then system_net_in :=add64(system_net_in,xin);
if (xout>=1) then system_net_out:=add64(system_net_out,xout);
end;

function net__in:comp;
begin
result:=system_net_in;
end;

function net__out:comp;
begin
result:=system_net_out;
end;

function net__total:comp;
begin
result:=add64(system_net_in,system_net_out);
end;

function net__makesession:boolean;
begin
//defaults
result:=system_net_session;

try
//get
if not system_net_session then
   begin
   //.create BEFORE enabling session, else code may reference it before it's setup
   if (system_net_sock=nil) then system_net_sock:=tdynamicinteger.create;
   //.session
//   system_net_session:=(0=net____WSAStartup(winsocketVersion,system_net_sesinfo));
//   system_net_session:=(0=net____WSAStartup($0202,system_net_sesinfo));
   system_net_session:=(0=net____WSAStartup($1009,system_net_sesinfo));

   //.bring windows message handling online - note: this may already be active, hence why "system_net_sock" was created above
   if system_net_session then
      begin
      app__wproc;
      result:=true;
      end;
   end;
except;end;
end;

procedure net__closesession;
begin
if system_net_session then
   begin
   system_net_session:=false;
   net____WSACleanup;
   end;
net__closeall;
end;

procedure net__closeonlysocket(var x:pnetwork);
begin
net__closeonlysocket2(x,false);
end;

procedure net__closeonlysocket2(var x:pnetwork;xclosechildren:boolean);
var
   a:tsocket;
begin
try
if (x<>nil) and x.init and (x.sock<>invalid_socket) then
   begin
   //.close any children records that have "<child>.ownk=<us>.sock"
   if xclosechildren then net__closeonlysocketsBYownk(x);
   //.close our socket
   a:=x.sock;
   x.sock:=invalid_socket;
   x.sock_ip4.val:=0;
   if (a<>invalid_socket) and (system_net_sock<>nil) then system_net_sock.value[a]:=0;//remove socket mapping
   x.connected:=false;//30jan2024
   net____closesocket(a);
   end;
except;end;
end;

procedure net__closeonlysocketsBYownk(var x:pnetwork);
var
   a:pnetwork;
   xsock:tsocket;
   p:longint;
begin
try
if (x<>nil) and x.init and (x.sock<>invalid_socket) and (system_net_count>=1) then
   begin
   xsock:=x.sock;//allows even our own record to be closed and for us to continue uninterrupted
   for p:=0 to (system_net_count-1) do if system_net_slot[p].init and (system_net_slot[p].ownk=xsock) then
      begin
      a:=@system_net_slot[p];
      net__closeonlysocket2(a,false);
      end;
   end;
except;end;
end;

procedure net__closerecBYownk(var x:pnetwork);
begin
net__closerecBYownk2(x,nil);
end;

procedure net__closerecBYownk2(var x:pnetwork;xclose_event:tnet__closeevent);
var//Note: xclose_event is optional and used for host based connection tracking / info
   a:pnetwork;
   xsock:tsocket;
   p:longint;
begin
try
if (x<>nil) and x.init and (x.sock<>invalid_socket) and (system_net_count>=1) then
   begin
   xsock:=x.sock;//allows even our own record to be closed and for us to continue uninterrupted
   for p:=0 to (system_net_count-1) do if system_net_slot[p].init and (system_net_slot[p].ownk=xsock) then
      begin
      a:=@system_net_slot[p];
      net__closerec3(a,true,xclose_event);
      end;
   end;
except;end;
end;

function net__socketgood(var x:pnetwork):boolean;
begin
result:=(x<>nil) and x.init and (x.sock<>invalid_socket);
end;

function net__connected(var x:pnetwork):boolean;
begin
result:=(x<>nil) and x.init and (x.sock<>invalid_socket) and x.connected;
end;

function net__limit:longint;
begin
result:=high(system_net_slot)+1;
end;

function net__count:longint;
begin
result:=system_net_count;
end;

procedure net__initrec(x:pnetwork);//used internally by system
begin
//check
if (x=nil) then exit;

//clear
with x^ do
begin
init:=false;
slot:=-1;
port:=0;
canread:=false;
canwrite:=false;
sock_ip4.val:=0;
sock:=invalid_socket;
ownk:=invalid_socket;
time_created:=0;
time_idle:=0;
used:=0;
recycle:=0;//this is the only location this variable is set to zero - 06apr2024
server:=false;
client:=false;
more:=nil;
mustclose:=false;
connected:=false;
infotag:=0;
infolastip:='';
infolastmode:=0;//0=none, 1=reading, 2=writing
end;
end;

function net__findcount:longint;
var
   p:longint;
begin
//defaults
result:=system_net_count;
//find
for p:=0 to (system_net_limit-1) do if system_net_slot[p].init then result:=p+1;
//set
system_net_count:=result;
end;

function net__tempfile(xslot:longint;var xfilename:string):boolean;
begin
//defaults
result:=false;
xfilename:='';

//get
if (xslot>=0) then
   begin
   xfilename:=app__subfolder('upload')+'temp'+low__digpad11(xslot,4)+'.tmp';
   result:=true;
   end;
end;

function net__tempfile_appendto(var a:pnetwork;xfirst:boolean):boolean;
label
   skipend;
var//Note: m.htempfile if >=0 should always match a.slot
   m:tnetbasic;//ptr only
   buf:pobject;//ptr only
   e,df:string;
   dfrom:comp;
begin
//defaults
result:=false;
try

//check
if (not net__recinfo(a,m,buf)) or (m.htempfile<0) or (m.htempfile<>a.slot) then exit;

//get
if net__tempfile(m.htempfile,df) then
   begin
   //first
   if xfirst and (not io__remfile(df)) then goto skipend;
   //start position
   dfrom:=frcmin64(io__filesize64(df),0);
   //append data to disk
   result:=io__tofileex64(df,buf,dfrom,false,e);
   //clear
   str__clear(buf);
   end;

skipend:
except;end;
end;

function net__recinfo(var a:pnetwork;var m:tnetbasic;var buf:pobject):boolean;
begin
//defaults
result:=false;
buf:=nil;

try
//get
if (a<>nil) and (a.more<>nil) then
   begin
   if (a.more is tnetbasic) then
      begin
      m:=(a.more as tnetbasic);
      buf   :=@m.buf;
      //successful
      result:=(buf<>nil);
      end;
   end;
except;end;
end;

function net__haverec(var x:pnetwork;xindex:longint):boolean;
begin
if (xindex>=0) and (xindex<system_net_limit) and system_net_slot[xindex].init then
   begin
   x:=@system_net_slot[xindex];
   result:=true;
   end
else result:=false;
end;

function net__makerec(var x:pnetwork):boolean;
begin
result:=net__makerec2(x,system_net_limit,[0],nil);
end;

function net__makerec2(var x:pnetwork;xlimit:longint;const xclosetag_list:array of byte;xclose_oldest_event:tnet__closeevent):boolean;
var//Note: xclose_oldest_event is optional
   i,iold,p,pmax:longint;
   xms64,xtime:comp;

   function xtagmatches(xtag:byte):boolean;
   var
      p:longint;
   begin
   result:=false;
   for p:=low(xclosetag_list) to high(xclosetag_list) do if (xtag=xclosetag_list[p]) then
      begin
      result:=true;
      break;
      end;//p
   end;
begin
//defaults
result:=false;
i:=-1;

try
//check
if (xlimit<=0) then exit;

//init
pmax:=frcmax32(system_net_limit-1,xlimit-1);

//find new
for p:=0 to pmax do if not system_net_slot[p].init then
   begin
   i:=p;
   break;
   end;//p

//find oldest - optional
if (i<0) and assigned(xclose_oldest_event) then
   begin
   //init
   xtime:=ms64;
   iold:=-1;

   //get                                              //close by type
   for p:=0 to pmax do if system_net_slot[p].init and xtagmatches(system_net_slot[p].infotag) and (system_net_slot[p].time_idle<xtime) then
      begin
      xtime:=system_net_slot[p].time_idle;
      iold:=p;
      end;//p

   //set
   if (iold>=0) then
      begin
      xclose_oldest_event(@system_net_slot[iold]);
      if not system_net_slot[iold].init then
         begin
         i:=iold;//make sure the event actually closed the record
         system_net_slot[iold].recycle:=add64(system_net_slot[iold].recycle,1);//track number of times record is recycled
         end;
      end;
   end;//p

//get
if (i>=0) then
   begin
   xms64:=ms64;
   //init the record
   with system_net_slot[i] do
   begin
   init:=true;
   time_created:=xms64;//06apr2024
   time_idle   :=xms64;
   canread     :=true;//assume true till otherwise - 29apr2024
   canwrite    :=true;//same as above
   slot        :=i;
   port        :=0;
   sock_ip4.val:=0;
   sock        :=invalid_socket;
   ownk        :=invalid_socket;
   used        :=0;
   server      :=false;
   client      :=false;
   infotag     :=0;
   infolastip  :='';
   infolastmode:=0;
   mustclose   :=false;//28dec2023
   connected   :=false;//30jan2024
   //.more
   if (more=nil) then
      begin
      more:=app____netmore as tnetmore;//optional
      if (more=nil) then more:=tnetmore.create;//fallback
      end;
   //.clear - 05apr2024
   more.clear;
   end;
   //successful
   result:=true;
   x:=@system_net_slot[i];
   //.count
   system_net_count:=largest32(i+1,system_net_count);
   end;
except;end;
end;

procedure net__closeall;
var
   p:longint;
begin
try
for p:=0 to (system_net_limit-1) do
begin
if system_net_slot[p].init then net__closerec2(@system_net_slot[p],true);
freeobj(@system_net_slot[p].more);//destroy app level helper object
end;
system_net_count:=0;
except;end;
end;

function net__closerec(x:pnetwork):boolean;
begin
result:=net__closerec2(x,true);
end;

function net__closerec2(x:pnetwork;xclosesock:boolean):boolean;
begin
result:=net__closerec3(x,xclosesock,nil);
end;

function net__closerec3(x:pnetwork;xclosesock:boolean;xclose_event:tnet__closeevent):boolean;
begin//xclose_event is optional
//defaults
result:=false;

try
//check
if (x=nil) or (not x.init) or (x.slot<0) or (x.slot>=system_net_limit) then exit;
//xclose_event
if assigned(xclose_event) then
   begin
   xclose_event(@system_net_slot[x.slot]);
   //.the host close event has closed the record -> we don't have anything more to do - 06apr2024
   if (x=nil) or (not x.init) or (x.slot<0) or (x.slot>=system_net_limit) or (not system_net_slot[x.slot].init) then
      begin
      result:=true;
      exit;
      end;
   end;
//release the record
system_net_slot[x.slot].init:=false;
//clear sock/sock ref valus
if (x.sock<>invalid_socket) and (system_net_sock<>nil) then system_net_sock.value[x.sock]:=0;
if xclosesock then net____closesocket(x.sock);
//clear the record
with system_net_slot[x.slot] do
begin
sock_ip4.val:=0;
sock:=invalid_socket;
ownk:=invalid_socket;
time_created:=0;
time_idle:=0;
slot:=-1;
port:=0;
canread:=false;
canwrite:=false;
server:=false;
client:=false;
mustclose:=false;
connected:=false;
infotag:=0;
infolastip:='';
infolastmode:=0;

//.leave objects intact - for maximum stability
if (more<>nil) then more.clear;

//Note: some fields are left unchanged until the record is next created for persistent data tracking
//e.g.:
//.used
//.recycle
end;
//successful
result:=true;
except;end;
end;

function net__sockip4(xsock:tsocket;var xip4:longint):boolean;
var
   a:tsockaddrin;
   sa:longint;
begin
//defaults
result:=false;
try
xip4:=0;
//get
if (xsock<>invalid_socket) then
   begin
   sa:=sizeof(a);
   fillchar(a,sa,#0);
   if (net____getpeername(xsock,a,sa)=0) then
      begin
      //RemoteHost - not available "gethostbyaddr" jams under little stress
      //RemoteAddress - works find since it gets raw "IP address"
      xip4:=a.sin_addr.s_addr;
      result:=true;
      end;
   end;
except;end;
end;

function net__findbysock(var x:pnetwork;xsock:tsocket):boolean;//09apr2024: fixed + updated
var
   i:longint;
begin
//defaults
result:=false;
x:=nil;

try
if (xsock<>invalid_socket) and (system_net_sock<>nil) and (xsock>=0) and (xsock<system_net_sock.count) then
   begin
   i:=system_net_sock.value[xsock]-1;//0=not in use, 1-N => slot(0..N-1) - 08apr2024
   if (i>=0) and (i<system_net_limit) and system_net_slot[i].init then
      begin
      x:=@system_net_slot[i];
      result:=true;
      end;
   end;
except;end;
end;

function net__makeclient(var x:pnetwork;xlimit:longint;xsock:tsocket):boolean;
begin
result:=net__makeclient2(x,xlimit,xsock,invalid_socket,[0],nil);
end;

function net__makeclient2(var x:pnetwork;xlimit:longint;xsock,xowner:tsocket;const xclosetag_list:array of byte;xclose_oldest_event:tnet__closeevent):boolean;//06apr2024: recycle support
var//Note: xclose_oldest_event is optional, but when present, allows for recycling of oldest records/connections, use closetag to recycle client connections and leave servers alone - 06apr2024
   int1:longint;
begin
//defaults
result:=false;

try
//check
if (xsock=invalid_socket) then exit;
//get
if net__makerec2(x,xlimit,xclosetag_list,xclose_oldest_event) then
   begin
   if net__sockip4(xsock,int1) then x.sock_ip4.val:=int1 else x.sock_ip4.val:=0;
   x.sock:=xsock;
   x.ownk:=xowner;//optional - lets system know that a client is tied to a specific server socket process - 22dec2023
   x.client:=true;
   if (x.slot>=0) and (system_net_sock<>nil) then system_net_sock.value[x.sock]:=x.slot+1;//08apr2024
   //successful
   result:=true;
   end;
except;end;
end;

function net__makeserver(var x:pnetwork;xport,xqueuesize:longint):boolean;
begin
result:=net__makeserver2(x,xport,xqueuesize,false);
end;

function net__makeserver2(var x:pnetwork;xport,xqueuesize:longint;xclosechildren:boolean):boolean;
label
   skipend;
var
   a:tsockaddrin;
   xsock:tsocket;
begin
//defaults
result:=false;
xsock:=invalid_socket;

try
//range
xport:=frcrange32(xport,0,maxport);
xqueuesize:=frcmin32(xqueuesize,0);
//check
if (x=nil) or (not x.init) or (x.slot<0) or (x.slot>max32) then exit;

//client
if x.client then
   begin
   x.client:=false;
   net__closeonlysocket2(x,xclosechildren);
   end;
//port=0 - make server offline
if (xport=0) then
   begin
   net__closeonlysocket2(x,xclosechildren);
   result:=true;
   goto skipend;
   end;
//port=new port (port=1..maxport)
if (xport=x.port) and (x.sock<>invalid_socket) and x.server then
   begin
   xsock:=x.sock;//store so at skipend point the system has the right value
   result:=true;
   goto skipend;
   end;
//close any active socket
net__closeonlysocket2(x,xclosechildren);
//session
if not net__makesession then goto skipend;
//get
xsock:=net____makesocket(PF_INET,SOCK_STREAM,IPPROTO_TCP);
if (xsock=invalid_socket) then goto skipend;
//.maketime
//.a
low__cls(@a,sizeof(a));
a.sin_family      :=PF_INET;
a.sin_addr.s_addr :=INADDR_ANY;
a.sin_port        :=low__rword(xport);
//.bind
if (0<>net____bind(xsock,a,sizeof(a))) then goto skipend;
//.styles
net____wsaasyncselect(xsock,app__wproc.window,wm_onmessage_net,longint(FD_READ or FD_WRITE or FD_ACCEPT or FD_CONNECT or FD_CLOSE));
//.listen
if (0<>net____listen(xsock,xqueuesize)) then goto skipend;
//successful
result:=true;

skipend:
except;end;
try
//.always
x.client:=false;
x.server:=true;
x.port  :=xport;
//.successful
if result then
   begin
   x.sock:=xsock;
   if (x.sock<>invalid_socket) and (x.slot>=0) and (system_net_sock<>nil) then system_net_sock.value[x.sock]:=x.slot+1;//08apr2024
   end
//.failed - this socket was only ever created within this proc so no need to close children
else
   begin
   x.sock:=invalid_socket;
   if (xsock<>invalid_socket) and (system_net_sock<>nil) then system_net_sock.value[xsock]:=0;//08apr2024
   net____closesocket(xsock);
   end;
except;end;
end;

function net__accept(s:tsocket):tsocket;
var
   addr:tsockaddrin;
   xsize:longint;
begin
result:=invalid_socket;

try
xsize:=sizeof(addr);
low__cls(@addr,sizeof(addr));
result:=net____accept(s,@addr,@xsize);
except;end;
end;

function net__decodestrb(x:string):string;
begin
result:='';

try
result:=x;
net__decodestr(result);
except;end;
end;

procedure net__decodestr(var x:string);//12jun2006
var
   v,xp,xlen,p:longint;
begin
try
//init
xlen:=low__len(x);
if (xlen=0) then exit;
//get
xp:=0;
p:=1;
repeat
v:=byte(x[p-1+stroffset]);
//decide
if (v=sspercentage) then
   begin
   x[p-1+stroffset+xp]:=char(low__hexint2(strcopy1(x,p+1,2)));
   xp:=xp-2;
   p:=p+2;
   end
else if (v=ssplus) then x[p-1+stroffset+xp]:=#32
else x[p-1+stroffset+xp]:=x[p-1+stroffset];
//inc
inc(p);
until (p>xlen);
//.size
x:=strcopy1(x,1,xlen+xp);
except;end;
end;

function net__encodeforhtml(s,d:tstr8):boolean;//full web support + BWD1 style support - 13jun2016, 05mar2016, 12-JUN-2006
begin
result:=net__encodeforhtml2(s,d,false,false,[0],[0]);
end;

function net__encodeforhtml2(s,d:tstr8;xuseincludelist,xuseskiplist:boolean;const xincludelist,xskiplist:array of byte):boolean;//full web support + BWD1 style support - 15apr2024: includelist, 13jun2016, 05mar2016, 12-JUN-2006
label
   decide,skipone,skipend;
var
   v:byte;
   lsp,slen,p,p2:longint;
   bol1,xincludelistok,xskiplistok:boolean;
begin
result:=false;

try
//defaults
if not low__true2(str__lock(@s),str__lock(@d)) then goto skipend;
//init
d.clear;
slen:=s.len;
lsp:=0;

//check
if (slen<=0) then exit;

//get
xincludelistok:=xuseincludelist and (sizeof(xincludelist)>=1);
xskiplistok:=xuseskiplist and (sizeof(xskiplist)>=1);
p:=0;
repeat
//get
v:=s.pbytes[p];


//.includelist - overrides the skiplist - 15apr2024
if xincludelistok then
   begin
   bol1:=false;
   for p2:=low(xincludelist) to high(xincludelist) do if (v=xincludelist[p2]) then
      begin
      bol1:=true;
      break;
      end;
   case bol1 of
   true:goto decide;
   else begin
      if (v=32) then lsp:=0;
      d.sadd(char(v));
      goto skipone;
      end;
   end;//case
   end;

//.skiplist - 08apr2024
if xskiplistok then
   begin
   for p2:=low(xskiplist) to high(xskiplist) do if (v=xskiplist[p2]) then
      begin
      if (v=32) then lsp:=0;
      d.sadd(char(v));
      goto skipone;
      end;//p2
   end;

//scan  <=60, >=62, "=34, '=39 &=38, space=32, rcode=10/13, tab=9
decide:
case v of
9:d.sadd('&#9;');//**
32:begin
   if (lsp=(p-1)) then d.sadd('&nbsp;') else d.sadd(#32);
   lsp:=p;
   end;
34:d.sadd('&quot;');
38:d.sadd('&amp;');
39:d.sadd('&#39;');//**
60:d.sadd('&lt;');
62:d.sadd('&gt;');
128:d.sadd('&euro;');
129:d.sadd('&#129;');
130:d.sadd('&sbquo;');
131:d.sadd('&fnof;');
132:d.sadd('&bdquo;');
133:d.sadd('&hellip;');
134:d.sadd('&dagger;');
135:d.sadd('&Dagger;');
136:d.sadd('&circ;');
137:d.sadd('&permil;');
138:d.sadd('&Scaron;');
139:d.sadd('&lsaquo;');
140:d.sadd('&OElig;');
141:d.sadd('&#141;');
143:d.sadd('&#143;');
144:d.sadd('&#144;');
145:d.sadd('&lsquo;');
146:d.sadd('&rsquo;');
147:d.sadd('&ldquo;');
148:d.sadd('&rdquo;');
149:d.sadd('&bull;');
150:d.sadd('&ndash;');
151:d.sadd('&mdash;');
152:d.sadd('&tilde;');
153:d.sadd('&trade;');
154:d.sadd('&scaron;');
155:d.sadd('&rsaquo;');
156:d.sadd('&oelig;');
157:d.sadd('&#157;');
159:d.sadd('&Yuml;');
160:d.sadd('&nbsp;');
161:d.sadd('&iexcl;');
162:d.sadd('&cent;');
163:d.sadd('&pound;');
164:d.sadd('&curren;');
165:d.sadd('&yen;');
166:d.sadd('&brvbar;');
167:d.sadd('&sect;');
168:d.sadd('&uml;');
169:d.sadd('&copy;');
170:d.sadd('&ordf;');
171:d.sadd('&laquo;');
172:d.sadd('&not;');
173:d.sadd('&shy;');
174:d.sadd('&reg;');
175:d.sadd('&macr;');
176:d.sadd('&deg;');
177:d.sadd('&plusmn;');
178:d.sadd('&sup2;');
179:d.sadd('&sup3;');
180:d.sadd('&acute;');
181:d.sadd('&micro;');
182:d.sadd('&para;');
183:d.sadd('&middot;');
184:d.sadd('&cedil;');
185:d.sadd('&sup1;');
186:d.sadd('&ordm;');
187:d.sadd('&raquo;');
188:d.sadd('&frac14;');
189:d.sadd('&frac12;');
190:d.sadd('&frac34;');
191:d.sadd('&iquest;');
192:d.sadd('&Agrave;');
193:d.sadd('&Aacute;');
194:d.sadd('&Acirc;');
195:d.sadd('&Atilde;');
196:d.sadd('&Auml;');
197:d.sadd('&Aring;');
198:d.sadd('&AElig;');
199:d.sadd('&Ccedil;');
200:d.sadd('&Egrave;');
201:d.sadd('&Eacute;');
202:d.sadd('&Ecirc;');
203:d.sadd('&Euml;');
204:d.sadd('&Igrave;');
205:d.sadd('&Iacute;');
206:d.sadd('&Icirc;');
207:d.sadd('&Iuml;');
208:d.sadd('&ETH;');
209:d.sadd('&Ntilde;');
210:d.sadd('&Ograve;');
211:d.sadd('&Oacute;');
212:d.sadd('&Ocirc;');
213:d.sadd('&Otilde;');
214:d.sadd('&Ouml;');
215:d.sadd('&times;');
216:d.sadd('&Oslash;');
217:d.sadd('&Ugrave;');
218:d.sadd('&Uacute;');
219:d.sadd('&Ucirc;');
220:d.sadd('&Uuml;');
221:d.sadd('&Yacute;');
222:d.sadd('&THORN;');
223:d.sadd('&szlig;');
224:d.sadd('&agrave;');
225:d.sadd('&aacute;');
226:d.sadd('&acirc;');
227:d.sadd('&atilde;');
228:d.sadd('&auml;');
229:d.sadd('&aring;');
230:d.sadd('&aelig;');
231:d.sadd('&ccedil;');
232:d.sadd('&egrave;');
233:d.sadd('&eacute;');
234:d.sadd('&ecirc;');
235:d.sadd('&euml;');
236:d.sadd('&igrave;');
237:d.sadd('&iacute;');
238:d.sadd('&icirc;');
239:d.sadd('&iuml;');
240:d.sadd('&eth;');
241:d.sadd('&ntilde;');
242:d.sadd('&ograve;');
243:d.sadd('&oacute;');
244:d.sadd('&ocirc;');
245:d.sadd('&otilde;');
246:d.sadd('&ouml;');
247:d.sadd('&divide;');
248:d.sadd('&oslash;');
249:d.sadd('&ugrave;');
250:d.sadd('&uacute;');
251:d.sadd('&ucirc;');
252:d.sadd('&uuml;');
253:d.sadd('&yacute;');
254:d.sadd('&thorn;');
255:d.sadd('&yuml;');
else d.sadd(char(s.pbytes[p]));
end;//case
//.inc
skipone:
inc(p);
until (p>=slen);
//successful
result:=true;

skipend:
except;end;
try
str__uaf(@s);
str__uaf(@d);
except;end;
end;

function net__encodeforhtmlstr(x:string):string;
begin
result:=net__encodeforhtmlstr2(x,false,false,[0],[0]);
end;

function net__encodeforhtmlstr2(x:string;xuseincludelist,xuseskiplist:boolean;const xincludelist,xskiplist:array of byte):string;
var
   s,d:tstr8;
begin
//defaults
result:='';

try
s:=nil;
d:=nil;
//init
s:=str__new8;
d:=str__new8;
s.text:=x;
//get
if net__encodeforhtml2(s,d,xuseincludelist,xuseskiplist,xincludelist,xskiplist) then result:=d.text;
except;end;
try
str__free(@s);
str__free(@d);
except;end;
end;

function net__encodeurl(s,d:tstr8;xleaveslash:boolean):boolean;//01apr2024: added ssPert (previously missing), 15jan2024, 29dec2023
label
   skipend;
var
   slen,p:longint;
   v:byte;
begin
//defaults
result:=false;

try
//check
if not low__true2(str__lock(@s),str__lock(@d)) then goto skipend;
//init
d.clear;
slen:=s.len;
//check
if (slen<=0) then exit;

//get
p:=0;
repeat
v:=s.pbytes[p];
if (v<=32) or (v>=127) or (v=35) or (v=sspert) or (v=43) then
   begin
   //hash and "+" must be encoded (special cases) - fixed 15jan2024
   if (v<>ssSlash) or xleaveslash then d.sadd('%'+low__hex(v)) else d.addbyt1(v);
   end
else d.addbyt1(v);
//inc
inc(p);
until (p>=slen);

//successful
result:=true;
skipend:
except;end;
try
str__uaf(@s);
str__uaf(@d);
except;end;
end;

function net__encodeurlstr(x:string;xleaveslash:boolean):string;
var
   s,d:tstr8;
begin
//defaults
result:='';

try
s:=nil;
d:=nil;
//init
s:=str__new8;
d:=str__new8;
s.text:=x;
//get
if net__encodeurl(s,d,xleaveslash) then result:=d.text;
except;end;
try
str__free(@s);
str__free(@d);
except;end;
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//net

function net__ismultipart(xcontenttype:string;var boundary:string):boolean;
label
   skipend;
const
   m='multipart/form-data;';
var
   mlen,clen,p:longint;
   v:byte;
begin//multipart/form-data
//defaults
result:=false;

try
boundary:='';
mlen:=low__len(m);

//check
clen:=low__len(xcontenttype);
if (clen<=0) then goto skipend;

//get
if strmatch(strcopy1(xcontenttype,1,mlen),m) then
   begin
   for p:=(mlen+1) to clen do
   begin
   v:=ord(xcontenttype[p-1+stroffset]);
   if (v<>9) and (v<>32)  then boundary:=boundary+xcontenttype[p-1+stroffset]
   else if (boundary<>'') then break;
   end;//p
   end;

//.strip "boundary="
if (boundary<>'') then
   begin
   for p:=1 to low__len(boundary) do
   begin
   if (boundary[p-1+stroffset]='=') then
      begin
      boundary:=strcopy1(boundary,p+1,low__len(boundary));
      break;
      end;
   end;//p
   //.finalise
   if (boundary<>'') then boundary:='--'+boundary+#13#10;//protocol spec: CRLF + "--" + "Boundary value" - 08feb2024
   end;

//return result
result:=(boundary<>'');
skipend:
except;end;
end;


//ipsec procs ------------------------------------------------------------------
function ipsec__limit:longint;
begin
result:=system_ipsec_limit;
end;

function ipsec__count:longint;
begin
//result:=system_ipsec_count;
result:=system_ipsec_limit;
end;

function ipsec__findcount:longint;
var
   p:longint;
begin
//defaults
result:=system_ipsec_count;
//find
for p:=0 to (system_ipsec_limit-1) do if (system_ipsec_slot[p].alen>=1) then result:=p+1;
//set
system_ipsec_count:=result;
end;

function ipsec__newslot:longint;
var
   xageslot1,xageslot2,p:longint;
   xage1,xage2:longint;
   bol1:boolean;
begin
//defaults
result:=0;

try
bol1:=false;

//find free slot
for p:=0 to (system_ipsec_limit-1) do if (system_ipsec_slot[p].alen=0) then
   begin
   ipsec__clearslot(p);
   result:=p;
   bol1:=true;
   break;
   end;

//find oldest slot and reuse it
if not bol1 then
   begin
   //init
   xageslot1:=-1;//slot of a non-banned item - this is our preference, so a banned IP remains intact
   xageslot2:=-1;//slot of a banned item - fallback state ONLY if there are NO non-banned slots to choose from
   xage1:=mn32;
   xage2:=xage1;
   //search
   for p:=0 to (system_ipsec_limit-1) do
   begin
   case system_ipsec_slot[p].ban of
   true:begin
      if (system_ipsec_slot[p].age32<xage2) then
         begin
         xage2:=system_ipsec_slot[p].age32;
         xageslot2:=p;
         end;
      end;//begin
   else begin
      if (system_ipsec_slot[p].age32<xage1) then
         begin
         xage1:=system_ipsec_slot[p].age32;
         xageslot1:=p;
         end;
      end;//begin
   end;//case
   end;//p
   //get
   if (xageslot1>=0)      then result:=xageslot1//oldest non-banned slot
   else if (xageslot2>=0) then result:=xageslot2//oldest banned slot
   else                        result:=0;//emergency fallback -> should never happen
   //clear the slot
   ipsec__clearslot(result);
   end;
except;end;
end;

function ipsec__findaddr(var xaddr:string;var xslot:longint):boolean;
var//Note: Assumes xaddr is already lowercase so that comparison is consistent
   alen,aref,aref2,p,p2:longint;
begin
//defaults
result:=false;

try
xslot:=-1;//failed -> all procs understand this value

//check
if (ipsec__count<=0) then exit;

//init
alen:=frcmax32(low__len(xaddr), 1+high(system_ipsec_slot[0].addr) );//ignore any trailing parts of the address -> should not exceed 39 bytes for a FULL IPv6 address with [...] square brackets included
//.address must be 1+ chars in length
if (alen<=0) then exit;
aref:=0;//don't fill it till we need it
aref2:=0;

//find
for p:=0 to (ipsec__count-1) do if (system_ipsec_slot[p].alen=alen) and (system_ipsec_slot[p].aref<>0) then
   begin
   //init
   if (aref=0) then
      begin
      aref:=low__ref32u(xaddr);//never zero
      aref2:=low__ref32u(strcopy1(xaddr,10,alen));//maybe zero
      end;
   //get
   if (system_ipsec_slot[p].aref=aref) and (system_ipsec_slot[p].aref2=aref2) then
      begin
      result:=true;
      xslot:=p;//10jan2024
      for p2:=1 to alen do if (byte(xaddr[p2-1+stroffset])<>system_ipsec_slot[p].addr[p2-1]) then
         begin
         result:=false;
         break;
         end;
      end;
   end;//p
except;end;
end;

function ipsec__setvals(xscanfor,xbanfor:longint;xconnlimit,xpostlimit,xpostlimit2,xbadlimit,xhitlimit,xbadreqlimit,xbadmaillimit:longint;xdatalimit:comp):boolean;
begin
//pass-thru
result:=true;

try
//get
system_ipsec_scanfor   :=frcrange32(xscanfor,60,30*24*60);//1hr to 30dy in minutes
//.banfor -> must equal or greater than "scanfor"
system_ipsec_banfor    :=frcrange32( frcmin32(xbanfor,system_ipsec_scanfor) ,60 ,365*24*60);//1hr to 1yr in minutes
//.xconnlimit
system_ipsec_connlimit:=frcrange32(xconnlimit,0,max32);//0=off, otherwise in the range 1..N
//.xpostlimit
system_ipsec_postlimit:=frcrange32(xpostlimit,0,max32);//0=off, otherwise in the range 1..N
//.xpostlimit2
system_ipsec_postlimit2:=frcrange32(xpostlimit2,0,max32);//0=off, otherwise in the range 1..N
//.xbadlimit
if (xbadlimit<=0) then xbadlimit:=0 else xbadlimit:=frcrange32(xbadlimit,10,max32);//0=off, otherwise in the range 10..N
system_ipsec_badlimit:=xbadlimit;
//.xhitlimit
if (xhitlimit<=0) then xhitlimit:=0 else xhitlimit:=frcrange32(xhitlimit,100,max32);//0=off, otherwise in the range 100..N
system_ipsec_hitlimit:=xhitlimit;
//.xbadreqlimit
system_ipsec_badreqlimit:=frcrange32(xbadreqlimit,0,max32);//0=off, otherwise in the range 1..N
//.xbadmaillimit
system_ipsec_badmaillimit:=frcrange32(xbadmaillimit,0,max32);//0=off, otherwise in the range 1..N
//.xdatalimit
if (xdatalimit<=0) then xdatalimit:=0 else xdatalimit:=frcrange64(xdatalimit,100000,max64);//0=off, otherwise in the range 100,000 (100K)..N
system_ipsec_datalimit:=xdatalimit;
except;end;
end;

function ipsec__getvals(var xscanfor,xbanfor,xconnlimit,xpostlimit,xpostlimit2,xbadlimit,xhitlimit,xbadreqlimit,xbadmaillimit:longint;var xdatalimit:comp):boolean;
begin
//pass-thru
result:=true;

//get
xscanfor      :=system_ipsec_scanfor;
xbanfor       :=system_ipsec_banfor;
xconnlimit    :=system_ipsec_connlimit;
xpostlimit    :=system_ipsec_postlimit;
xpostlimit2   :=system_ipsec_postlimit2;
xbadlimit     :=system_ipsec_badlimit;
xhitlimit     :=system_ipsec_hitlimit;
xbadreqlimit  :=system_ipsec_badreqlimit;
xbadmaillimit :=system_ipsec_badmaillimit;
xdatalimit    :=system_ipsec_datalimit;
end;

function ipsec__scanfor:longint;
begin
result:=system_ipsec_scanfor;
end;

function ipsec__banfor:longint;
begin
result:=system_ipsec_banfor;
end;

function ipsec__connlimit:longint;
begin
result:=system_ipsec_connlimit;
end;

function ipsec__postlimit:longint;
begin
result:=system_ipsec_postlimit;
end;

function ipsec__postlimit2:longint;
begin
result:=system_ipsec_postlimit2;
end;

function ipsec__badlimit:longint;
begin
result:=system_ipsec_badlimit;
end;

function ipsec__hitlimit:longint;
begin
result:=system_ipsec_hitlimit;
end;

function ipsec__badreqlimit:longint;//18jun2025
begin
result:=system_ipsec_badreqlimit;
end;

function ipsec__badmaillimit:longint;//19jun2025
begin
result:=system_ipsec_badmaillimit;
end;

function ipsec__datalimit:comp;
begin
result:=system_ipsec_datalimit;
end;

function ipsec__trackb(xaddr:string;var xnewslot:boolean):longint;
begin
ipsec__track(xaddr,result,xnewslot);
end;

function ipsec__track(xaddr:string;var xslot:longint;var xnewslot:boolean):boolean;
var
   p:longint;
begin
//defaults
result    :=false;
xslot     :=-1;
xnewslot  :=false;

try
//check
if (xaddr='') then exit;

//find existing slot
result:=ipsec__findaddr(xaddr,xslot);

//create new slot
if not result then
   begin
   //.get new slot -> always returns a valid value, even if it has to wipe an existing record (note: in this case the record's lockcount is retained for maximum stability)
   xslot:=ipsec__newslot;
   //.fill in the name information
   system_ipsec_slot[xslot].alen:=frcmax32(low__len(xaddr), 1+high(system_ipsec_slot[0].addr) );//ignore any trailing parts of the address -> should not exceed 39 bytes for a FULL IPv6 address with [...] square brackets included
   system_ipsec_slot[xslot].aref:=low__ref32u(xaddr);//never zero
   system_ipsec_slot[xslot].aref2:=low__ref32u(strcopy1(xaddr,10,system_ipsec_slot[xslot].alen));//maybe zero
   //.fill in the name
   for p:=1 to system_ipsec_slot[xslot].alen do system_ipsec_slot[xslot].addr[p-1]:=byte(xaddr[p-1+stroffset]);
   //successful
   xnewslot:=true;//indicate to host slot is newly created for tracking purposes - 21feb2025
   result:=true;
   end;
except;end;
end;

function ipsec__slotok(xslot:longint):boolean;
begin
result:=(xslot>=0) and (xslot<system_ipsec_limit) and (system_ipsec_slot[xslot].alen>=1);
end;

function ipsec__incHit(xslot:longint):boolean;
begin
result:=true;
if ipsec__slotok(xslot) and (system_ipsec_slot[xslot].hits<max32) then low__iroll(system_ipsec_slot[xslot].hits,1);
end;

function ipsec__incBad(xslot:longint):boolean;
begin
result:=true;
if ipsec__slotok(xslot) and (system_ipsec_slot[xslot].bad<max32) then low__iroll(system_ipsec_slot[xslot].bad,1);
end;

function ipsec__incPost(xslot:longint):boolean;
begin
result:=true;
if ipsec__slotok(xslot) and (system_ipsec_slot[xslot].post<max32) then low__iroll(system_ipsec_slot[xslot].post,1);
end;

function ipsec__incPost2(xslot:longint):boolean;//20feb2025
begin
result:=true;
if ipsec__slotok(xslot) and (system_ipsec_slot[xslot].post2<max32) then low__iroll(system_ipsec_slot[xslot].post2,1);
end;

function ipsec__incNotThisLink(xslot:longint):boolean;//07apr2025
begin
result:=true;
if ipsec__slotok(xslot) and (system_ipsec_slot[xslot].notthislink<max32) then low__iroll(system_ipsec_slot[xslot].notthislink,1);
end;

function ipsec__incBadrequest(xslot:longint):boolean;//18jun2025
begin
result:=true;
if ipsec__slotok(xslot) and (system_ipsec_slot[xslot].badrequest<max32) then low__iroll(system_ipsec_slot[xslot].badrequest,1);
end;

function ipsec__incBadmail(xslot:longint):boolean;//19jun2025
begin
result:=true;
if ipsec__slotok(xslot) and (system_ipsec_slot[xslot].badmail<max32) then low__iroll(system_ipsec_slot[xslot].badmail,1);
end;

function ipsec__incConn(xslot:longint;xinc:boolean):boolean;
begin
if ipsec__slotok(xslot) then
   begin
   system_ipsec_slot[xslot].conn:=frcrange32(system_ipsec_slot[xslot].conn+low__aorb(-1,1,xinc),0,max32-10);//prevent max logic overflow
   //return result => true=too many sim. connections
   result:=(system_ipsec_connlimit>=1) and (system_ipsec_slot[xslot].conn>system_ipsec_connlimit);
   end
else result:=false;
end;

function ipsec__incBytes(xslot:longint;xbytes:comp):boolean;
begin
result:=true;
if ipsec__slotok(xslot) then system_ipsec_slot[xslot].bytes:=add64(system_ipsec_slot[xslot].bytes,xbytes);
end;

function ipsec__banned(xslot:longint):boolean;
begin
result:=ipsec__slotok(xslot) and system_ipsec_slot[xslot].ban;
end;

function ipsec__update(xslot:longint):boolean;//03may2024
label
   skipend;
var
   bol1:boolean;
begin
//pass-thru
result:=true;

try
//get
if ipsec__slotok(xslot) then
   begin
   //.slot is NOT banned and more than "system_ipsec_scanfor" old (e.g. more than 1 day old) -> OK to delete
   if (not system_ipsec_slot[xslot].ban) and (mn32> (system_ipsec_slot[xslot].age32+system_ipsec_scanfor) ) then
      begin
      //was: system_ipsec_slot[xslot].alen:=0;
      ipsec__clearslot(xslot);//03may2024
      goto skipend;
      end;
   //.slot IS banned and has been banned more than "system_ipsec_banfor" (e.g. more than 1 week) -> ok to delete
   if system_ipsec_slot[xslot].ban and (mn32> (system_ipsec_slot[xslot].age32+system_ipsec_banfor) ) then
      begin
      //was: system_ipsec_slot[xslot].alen:=0;
      ipsec__clearslot(xslot);//03may2024
      goto skipend;
      end;
   //.check slot stats to see if it needs to be upgraded to banned
   if not system_ipsec_slot[xslot].ban then
      begin

      //get
      bol1:=false;
      //.post limit
      if (system_ipsec_postlimit>=1) and (system_ipsec_slot[xslot].post>=system_ipsec_postlimit) then bol1:=true;
      //.post2 limit
      if (system_ipsec_postlimit2>=1) and (system_ipsec_slot[xslot].post2>=system_ipsec_postlimit2) then bol1:=true;//20feb2025
      //.bad limit
      if (system_ipsec_badlimit>=1) and (system_ipsec_slot[xslot].bad>=system_ipsec_badlimit) then bol1:=true;
      //.hit limit
      if (system_ipsec_hitlimit>=1) and (system_ipsec_slot[xslot].hits>=system_ipsec_hitlimit) then bol1:=true;
      //.badrequest - 18jun2025
      if (system_ipsec_badreqlimit>=1) and (system_ipsec_slot[xslot].badrequest>=system_ipsec_badreqlimit) then bol1:=true;
      //.badmail - 19jun2025
      if (system_ipsec_badmaillimit>=1) and (system_ipsec_slot[xslot].badmail>=system_ipsec_badmaillimit) then bol1:=true;
      //.data limit
      if (system_ipsec_datalimit>=1) and (system_ipsec_slot[xslot].bytes>=system_ipsec_datalimit) then bol1:=true;
      //.notthislink
      if (system_ipsec_slot[xslot].notthislink>=1) then bol1:=true;

      //set
      if bol1 then system_ipsec_slot[xslot].ban:=true;
      end;
   end;
skipend:
except;end;
end;

function ipsec__clearall:boolean;
var
   p:longint;
begin
result:=true;
//was: for p:=0 to (system_ipsec_limit-1) do system_ipsec_slot[p].alen:=0;
for p:=low(system_ipsec_slot) to (system_ipsec_limit-1) do ipsec__clearslot(p);//03may2024
end;

function ipsec__clearslot(xslot:longint):boolean;//03may2024
var
   p:longint;
begin
result:=true;//pass-thru
if (xslot>=low(system_ipsec_slot)) and (xslot<system_ipsec_limit) then
   begin
   with system_ipsec_slot[xslot] do
   begin
   alen:=0;
   aref:=0;
   aref2:=0;
   for p:=0 to high(addr) do addr[p]:=0;
   //.counters
   hits:=0;
   bad:=0;
   post:=0;
   post2:=0;
   conn:=0;
   notthislink:=0;
   badrequest:=0;
   badmail:=0;//19jun2025
   //.bandwidth consumed
   bytes:=0;
   //.reference
   age32:=mn32;//mark the slot's creation time in minutes
   ban:=false;
   end;//with
   end;//if
end;

function ipsec__slot(xslot:longint;var xaddress:string;var xmins,xconn,xpost,xpost2,xbad,xhits,xbadrequest,xbadmail,xnotthislink:longint;var xbytes:comp;var xbanned:boolean):boolean;
var
   p:longint;
begin
result:=false;
xaddress:='';
xmins:=0;
xconn:=0;
xpost:=0;
xpost2:=0;
xbad:=0;
xhits:=0;
xbytes:=0;
xbadrequest:=0;//18jun2025
xbadmail:=0;//19jun2025
xnotthislink:=0;
xbanned:=false;

//get
if ipsec__slotok(xslot) then
   begin
   //.addr
   low__setlen(xaddress,system_ipsec_slot[xslot].alen);
   for p:=1 to system_ipsec_slot[xslot].alen do xaddress[p-1+stroffset]:=char(system_ipsec_slot[xslot].addr[p-1]);
   //.vals
   xconn         :=system_ipsec_slot[xslot].conn;//sim. connections (actively happening)
   xpost         :=system_ipsec_slot[xslot].post;
   xpost2        :=system_ipsec_slot[xslot].post2;
   xbadrequest   :=system_ipsec_slot[xslot].badrequest;//18jun2025
   xbadmail      :=system_ipsec_slot[xslot].badmail;//19jun2025
   xnotthislink  :=system_ipsec_slot[xslot].notthislink;
   xbad          :=system_ipsec_slot[xslot].bad;
   xhits         :=system_ipsec_slot[xslot].hits;
   xbytes        :=system_ipsec_slot[xslot].bytes;
   xmins         :=frcmin32(mn32-system_ipsec_slot[xslot].age32,0);
   xbanned       :=system_ipsec_slot[xslot].ban;
   //successful
   result:=true;
   end;
end;

function ipsec__slotBytes(xslot:longint):comp;//18aug2024
begin
if ipsec__slotok(xslot) then result:=system_ipsec_slot[xslot].bytes else result:=0;
end;


//## tnetmore ##################################################################
constructor tnetmore.create;
begin
if classnameis('tnetmore') then track__inc(satNetmore,1);
zzadd(self);
inherited create;
end;

destructor tnetmore.destroy;
begin
inherited destroy;
if classnameis('tnetmore') then track__inc(satNetmore,-1);
end;

procedure tnetmore.clear;
begin
//nil
end;

//## tnetbasic #################################################################
constructor tnetbasic.create;
begin
//self
if classnameis('tnetbasic') then track__inc(satNetbasic,1);
inherited create;
//controls
buf:=str__new9;
//clear
htempfile:=-1;
clear;
end;

destructor tnetbasic.destroy;
begin
//controls
str__free(@buf);
//self
inherited destroy;
if classnameis('tnetbasic') then track__inc(satNetbasic,-1);
end;

procedure tnetbasic.clear;
var
   df:string;
begin
try
//.we have a temp file that needs to be removed
if net__tempfile(htempfile,df) then io__remfile(df);
//.info
vonce:=true;//ensures "v*" vars are set only once during a connection
vmustlog:=false;
vstarttime:=0;
vsessname:='';//login session name
vsessvalid:=false;//true=means we are currently logged in
vsessindex:=0;
//.read
htoobig:=false;
hread:=0;
hlenscan:=0;
hlen:=0;
clen:=0;
r10:=false;
r13:=false;
hmethod:=hmUNKNOWN;
hver:=hvUnknown;
hconn:=hcUnspecified;
hwantdata:=false;
hka:=false;
htempfile:=-1;//not in use
hrange:='';
hif_range:='';
hif_match:='';
hua:='';
hcookie_k:='';//11mar2024
hcontenttype:='';
hreferer:='';
hport:=80;
hhost:='';
hdesthost:='';
hdiskhost:='';
hip:='';
hpath:='';
hname:='';
hnameext:='';
hgetdat:='';
hslot:=-1;//10jan2024
//.module support - 17aug2024
hmodule_index:=-1;//-1=no module used by default
hmodule_uploadlimit:=0;
hmodule_multipart:=false;
hmodule_canmakeraw:=false;
hmodule_readpost:=false;
//.write
writing:=false;
wheadlen:=0;
wlen:=0;
wsent:=0;
wfrom:=0;
wto:=0;
wmode:=wsmBuf;//stream mode
wramindex:=-1;
wcode:=0;
wfilename:='';
wfilesize:=0;
wfiledate:=0;
wbufsent:=0;
//.common
str__clear(@buf);
splicemem:=nil;
splicelen:=0;
//.mail specific
mdata:=false;
except;end;
end;

//log procs --------------------------------------------------------------------

function log__code(xrootcode,xaltcode:longint):longint;
begin

if (xaltcode<>0) then result:=xaltcode
else                  result:=xrootcode;

end;

function log__code2(var a:pnetwork;xaltcode:longint):longint;
var
   m:tnetbasic;
   buf:pobject;
begin

if      (xaltcode<>0)          then result:=xaltcode
else if net__recinfo(a,m,buf)  then result:=m.wcode
else                                result:=0;

end;

function log__addentry(xfolder,xlogname:string;var a:pnetwork;xaltcode:longint):boolean;//01apr2024: updated "__" optional when logname present (date__logname.txt)
var//xaltcode=0=has no effect, 1..N=signals that response was interrupted somehow, such as the connection was lost or closed unexpectedly e.g. 502
   m:tnetbasic;//pointer only
   buf:pobject;//pointer only
   dname:string;

   function xip:string;
   begin
   result:=m.hip;
   if (result='') then result:=intstr32(a.sock_ip4.b0)+'.'+intstr32(a.sock_ip4.b1)+'.'+intstr32(a.sock_ip4.b2)+'.'+intstr32(a.sock_ip4.b3);
   end;

   function xmethod:string;
   begin
   case m.hmethod of
   hmGet:     result:='GET';
   hmPost:    result:='POST';
   hmHead:    result:='HEAD';
   hmCONNECT: result:='CONNECT';
   else       result:='UNKNOWN';
   end;//case
   end;

   function xhttpver:string;
   begin
   case m.hver of
   hv0_9:     result:='0.9';
   hv1_0:     result:='1.0';
   hv1_1:     result:='1.1';
   else       result:='?/?';
   end;//case
   end;

   function xpathname:string;
   begin
   //admin check -> don't log the admin's session handle -> omitt it - 21jan2024
   if strmatch(strcopy1(m.hpath,1,7),'/admin/') then result:='/admin/'+m.hname else result:=m.hpath+m.hname;
   end;
begin
//defaults
result:=false;

try
//update fast vars
log__fastvars;

//check
dname:=system_log_datename+insstr('__',xlogname<>'')+xlogname;//01apr20244: updated so that "__" between date and name is now optional (included only when a trailing logname is present)
if (not strmatch(dname,system_log_name)) or (not strmatch(xfolder,system_log_folder)) then
   begin
   //writing a different log now, so finish writing previous log and switch to new log
   log__writenow;
   system_log_folder:=xfolder;
   system_log_name:=dname;
   system_log_safename:=io__safename(dname)+'.txt';
   end;

//check for vars
if not net__recinfo(a,m,buf) then exit;

//init
if (system_log_cache=nil) then system_log_cache:=str__new8;

//add
system_log_cache.sadd(xip+' - - ['+system_log_gmtnowstr+'] "'+log__filterstr(xmethod+#32+insstr('/'+m.hdiskhost,m.hdiskhost<>'')+xpathname+' HTTP/'+xhttpver)+'" '+intstr32( log__code(m.wcode,xaltcode) )+#32+intstr64(frcmin64( sub64(m.wsent,m.wheadlen) ,0))+' "'+strdefb(log__filterstr(m.hreferer),'-')+'" "'+log__filterstr(m.hua)+'" ['+k64(low__aorbcomp(0,sub64(ms64,m.vstarttime),m.vstarttime>=1))+'ms '+k64(a.used)+'u '+k64(a.slot)+'c]'+#10);//ms=time taken to read+process+send the request, u=number of times the connection has been reused (e.g. via keep-alive connection), #=connection slot used for request - 19feb2024

//optionally write to disk
log__writemaybe;

//successful
result:=true;
except;end;
end;

function log__addmailentry(xfolder,xlogname:string;var a:pnetwork;xcode:longint;xbandwidth:comp):boolean;
var
   m:tnetbasic;//pointer only
   buf:pobject;//pointer only
   dname:string;

   function xip:string;
   begin
   result:=intstr32(a.sock_ip4.b0)+'.'+intstr32(a.sock_ip4.b1)+'.'+intstr32(a.sock_ip4.b2)+'.'+intstr32(a.sock_ip4.b3);
   end;
begin
//defaults
result:=false;
try

//update fast vars
log__fastvars;

//check
dname:=system_log_datename+insstr('__',xlogname<>'')+xlogname;//01apr20244: updated so that "__" between date and name is now optional (included only when a trailing logname is present)
if (not strmatch(dname,system_log_name)) or (not strmatch(xfolder,system_log_folder)) then
   begin
   //writing a different log now, so finish writing previous log and switch to new log
   log__writenow;
   system_log_folder:=xfolder;
   system_log_name:=dname;
   system_log_safename:=io__safename(dname)+'.txt';
   end;

//check for vars
if not net__recinfo(a,m,buf) then exit;

//init
if (system_log_cache=nil) then system_log_cache:=str__new8;

//add
system_log_cache.sadd(xip+' - - ['+system_log_gmtnowstr+'] "POST / SMTP/1.0" '+intstr32(xcode)+#32+intstr64(xbandwidth)+' "'+strdefb(log__filterstr(m.hreferer),'-')+'" "'+log__filterstr(m.hua)+'" ['+k64(low__aorbcomp(0,sub64(ms64,m.vstarttime),m.vstarttime>=1))+'ms '+k64(a.used)+'u '+k64(a.slot)+'c]'+#10);//ms=time taken to read+process+send the request, u=number of times the connection has been reused (e.g. via keep-alive connection)

//optionally write to disk
log__writemaybe;

//successful
result:=true;
except;end;
end;

function log__writemaybe:boolean;//writes log to disk after cachetime or if cache is 500K or more
begin
result:=true;//pass-thru
if (system_log_cache<>nil) and ( (system_log_cache.len>=500000) or msok(system_log_cachetime) ) then log__writenow;
end;

function log__filterstr(x:string):string;
begin
result:=x;
swapchars(result,'"','''');
end;

function log__writenow:boolean;
var
   e,df:string;
   dfrom:comp;
begin
//pass-thru
result:=true;
try
//get
if (system_log_cache<>nil) and (system_log_cache.len>=1) then
   begin
   //init
   df:=io__asfolder(strdefb(system_log_folder,app__subfolder('logs')))+system_log_safename;
   dfrom:=frcmin64(io__filesize64(df),0);
   //get
   io__tofileex64(df,@system_log_cache,dfrom,false,e);
   //clear
   system_log_cache.clear;
   //reset timer
   msset(system_log_cachetime,5000);//5s
   end;
except;end;
end;

procedure log__fastvars;
var
   y,m,d,hr,min,sec,msec:word;
   oh,om,f:longint;
begin
try
//gmt offset hour/minute -> update every 30s
if msok(system_log_varstime2) then
   begin
   msset(system_log_varstime2,30000);
   low__gmtOFFSET(oh,om,f);
   system_log_gmtoffset:=low__aorbstr('-','+',f>=0)+low__digpad11(oh,2)+low__digpad11(om,2);
   end;

//year/month/day/hour/minute/second -> update every 1s
if msok(system_log_varstime1) then
   begin
   msset(system_log_varstime1,1000);
   low__decodedate2(date__now,y,m,d);
   low__decodetime2(date__now,hr,min,sec,msec);
   system_log_gmtnowstr:=low__digpad11(d,2)+'/'+low__month1(m,false)+'/'+low__digpad11(y,4)+':'+low__digpad11(hr,2)+':'+low__digpad11(min,2)+':'+low__digpad11(sec,2)+#32+system_log_gmtoffset;
   system_log_datename:=low__digpad11(y,4)+'y-'+low__digpad11(m,2)+'m-'+low__digpad11(d,2)+'d';
   end;
except;end;
end;

end.
