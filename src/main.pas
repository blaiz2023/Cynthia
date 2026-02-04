unit main;

interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define bmp} {$define ico} {$define gif} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define bmp} {$define ico} {$define gif} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot, {$ifdef gui}gossgui,{$endif} {$ifdef snd}gosssnd,{$endif} gosswin, gosswin2, gossio, gossimg, gossnet, gossfast;
{$align on}{$O+}{$W-}{$I-}{$U+}{$V+}{$B-}{$X+}{$T-}{$P+}{$H+}{$J-} { set critical compiler conditionals for proper compilation - 10aug2025 }
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
//## Library.................. app code (main.pas)
//## Version.................. 1.00.6187 (+218)
//## Items.................... 6
//## Last Updated ............ 01feb2026, 30jan2026, 15jan20256, 13dec2025, 11dec2025, 10dec2025, 08dec2025, 09nov2025, 07nov2025, 02nov2025, 24oct2025, 26sep2026, 16sep2025, 09sep2025, 05sep2025, 31aug2025, 21aug2025, 19aug2025, 15aug2025, 11aug2025, 03jul2025, 08mar2025, 18feb2025, 08feb2025, 25jan2025, 12jan2025, 22nov2024, 05apr2021, 22mar2021, 20feb2021
//## Lines of Code............ 5,400+
//##
//## main.pas ................ app code
//## gossroot.pas ............ console/gui app startup and control
//## gossio.pas .............. file io
//## gossimg.pas ............. image/graphics
//## gossnet.pas ............. network
//## gosswin.pas ............. static Win32 api calls
//## gosswin2.pas ............ dynamic Win32 api calls
//## gosssnd.pas ............. sound/audio/midi/chimes
//## gossgui.pas ............. gui management/controls
//## gossdat.pas ............. app icons (24px and 20px) and help documents (gui only) in txt, bwd or bwp format
//## gosszip.pas ............. zip support
//## gossjpg.pas ............. jpeg support
//## gossfast.pas ............ fastdraw support
//## gossgame.pas ............ game support (optional)
//## gamefiles.pas ........... internal files for game (optional)
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | tapp                   | tbasicapp         | 1.00.4863 | 11dec2025   | Play "*.mid/mid/rmi" files swiftly and with ease and reliability - 08dec2025, 07nov2025, 16sep2025, 09sep2025, 04sep2025, 15aug2025, 11aug2025, 03jul2025, 18feb2025, 14feb2025, 05apr2021, 22mar2021, 20feb2021
//## | ttracks                | tbasiccontrol     | 1.00.185  | 11dec2025   | Indicate midi track activity.  Supports mute/unmute per track.  Supports upto 512 tracks. - 14sep2025, 03sep2025, 30aug2025, 03jul2025, 14feb2025
//## | toutput                | tbasicscroll      | 1.00.030  | 16sep2025   | Multiple midi out device settings manager
//## | tchannels              | tbasiccontrol     | 1.00.360  | 16sep2025   | Indicate average volume and peak average volume per channel.  Supports mute/unmute for all 16 channels. - 04sep2025, 30aug2025, 03jul2025, 14feb2025
//## | tnotes                 | tbasiccontrol     | 1.00.252  | 16sep2025   | Indicate note activity.  Supports mute/unmute for all 128 notes. - 03sep2025, 30aug2025, 03jul2025, 14feb2025
//## | tpiano                 | tbasiccontrol     | 1.00.278  | 13dec2025   | Animate piano key depress for each note played. - 16sep2025, 03sep2025, 30aug2025, 03jul2025, 14feb2025
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


const
   //Cynthia Core Options - 16apr2021
   synth_showstyle     =false;//true;

var
   itimerbusy:boolean=false;
   iapp:tobject=nil;

const
   //key highlight styles for piano
   khsOff      =0;
   khsFlat     =1;
   khsShadeUP  =2;
   khsShadeDN  =3;
   khsSubtle   =4;
   khsSubtle2  =5;
   khsEdge     =6;
   khsEdge2    =7;
   khsMax      =7;

type

{toutput}
   toutput=class(tbasicscroll)
   private

    itimersync  :comp;
    ilastindex  :longint;
    isel        :tbasicsel;
    ivol        :tsimpleint;
    ims         :tsimpleint;
    ichs        :tbasicset;
    izerobase   :boolean;
    imidlistRef :string;

    //support procs
    procedure xsave(const xindex:longint);
    procedure xload(const xindex:longint);
    procedure setzerobase(x:boolean);

   public

    //create
    constructor create(xparent:tobject); override;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;

    property zerobase:boolean read izerobase write setzerobase;
   end;

{tchannels}
   tchannels=class(tbasiccontrol)
   private
    ihoverfocus,iflashtimer,iflashtimer2,ipainttimer:comp;
    itemp:tstr8;
    idowny,ivolstarty,ivolbarheight,ivolheight,ihold,iholdms,ialign,ilasthoverindex,ihoverindex,idownindex,idataref:longint;
    izerobase,iflashon2,iflashon,ishowlabels,iup:boolean;
    iclsref:string;

    iarea      :array[0..15] of twinrect;
    iavevol    :array[0..15] of longint;
    iholdvol   :array[0..15] of longint;
    ihold64    :array[0..15] of comp;
    ivoice     :array[0..15] of longint;
    ivoiceref  :array[0..15] of longint;
    ivoicetime :array[0..15] of comp;//detect change in voice index and show highlight on screen for short period of time
    ilabel     :array[0..15] of tbasicimage;
    ilabelref  :array[0..15] of string;
    ichangeref :array[0..15] of string;

    function xfindarea(x,y:longint;var xindex:longint):boolean;
    function getsettings:string;
    procedure setsettings(x:string);
    procedure xclear;
    procedure xbar(const s:tclientinfo;const da:twinrect;xindex,xvol,xholdvol,fn,fnH,xfeather:longint;const xround:boolean);
    function xcalc:boolean;
    procedure setalign(x:longint);
    procedure sethold(xindex:longint);
    function xpert200TOy(xpert200:longint):longint;
    function xyTOpert200(sy:longint;var xpert200:longint):boolean;
    function xmoretime:boolean;

   public

    //options
    oflat:boolean;
    odelayMS:longint;

    //create
    constructor create(xparent:tobject); virtual;
    constructor create2(xparent:tobject;xstart:boolean); virtual;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    procedure _onpaint(sender:tobject); override;
    function _onnotify(sender:tobject):boolean; override;
    function findhold(xindex:longint;var xoutindex,xoutms:longint):boolean;

    //information
    property align       :longint read ialign write setalign;
    property up          :boolean read iup write iup;
    property zerobase    :boolean read izerobase write izerobase;
    property showlabels  :boolean read ishowlabels write ishowlabels;
    property hold        :longint read ihold write sethold;
    property holdms      :longint read iholdms;

    //settings
    property settings:string read getsettings write setsettings;//settings as a single line of text

    //workers
    procedure muteall(xmute:boolean);
    procedure moreVols(xby:longint);
    procedure resetVols;

   end;

{ttracks}
   ttracks=class(tbasiccontrol)
   private

    iflashtimer2,ipainttimer:comp;
    ilastheight,ilasttrackcount,iitemsperrow,idownindex,idataref:longint;
    iclsref,iinforef:string;
    iflashon2,idowntimed:boolean;
    iarea    :array[0..high(mmsys_mid_mutetrack)] of twinrect;
    iflash   :array[0..high(mmsys_mid_mutetrack)] of boolean;
    itime    :array[0..high(mmsys_mid_mutetrack)] of comp;
    iref     :array[0..high(mmsys_mid_mutetrack)] of tint4;

    function xrowcount:longint;
    function xrowheight(xclientheight:longint):longint;
    function xfindarea(x,y:longint;var xindex:longint):boolean;
    function getsettings:string;
    procedure setsettings(x:string);
    procedure xclear;
    function xtrackcount:longint;
    function xcalc:boolean;

   public

    otrackcount:longint;
    oflat:boolean;
    odelayMS:longint;

    //create
    constructor create(xparent:tobject); virtual;
    constructor create2(xparent:tobject;xstart:boolean); virtual;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    function getalignheight(xclientwidth:longint):longint; override;
    procedure _onpaint(sender:tobject); override;
    function _onnotify(sender:tobject):boolean; override;

    //settings
    property settings:string read getsettings write setsettings;//settings as a single line of text

    //workers
    procedure muteall(xmute:boolean);

   end;

{tnotes}
   tnotes=class(tbasiccontrol)
   private

    iflashtimer,ipainttimer,iholdtimer:comp;
    ihold,iholdms,idownindex,idataref,iref:longint;
    iclsref,iinforef:string;
    izerobase,iflashon,idowntimed:boolean;
    iflash   :array[0..127] of boolean;
    ihold64  :array[0..127] of comp;
    inotedc  :array[0..127] of longint;
    itime    :array[0..127] of comp;
    inref    :array[0..127] of longint;
    iarea    :array[0..127] of twinrect;
    ilabels  :array[0..127] of string;

    function xrowcount:longint;
    function xrowheight(xclientheight:longint):longint;
    function xfindarea(x,y:longint;var xindex:longint):boolean;
    function getsettings:string;
    procedure setsettings(x:string);
    procedure xclear;
    function xmakelabel(x:longint):string;
    function xlayout:longint;
    function xnotesperrow:longint;
    function xnoteoffset:longint;
    function findhold(xindex:longint;var xoutindex,xoutms:longint):boolean;
    procedure sethold(xindex:longint);

   public

    olayout:longint;
    olabels:boolean;
    ooutline:boolean;
    oflat:boolean;
    odelayMS:longint;

    //create
    constructor create(xparent:tobject); virtual;
    constructor create2(xparent:tobject;xstart:boolean); virtual;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    function getalignheight(xclientwidth:longint):longint; override;
    procedure _onpaint(sender:tobject); override;
    function _onnotify(sender:tobject):boolean; override;

    //information
    property hold           :longint read ihold write sethold;
    property holdms         :longint read iholdms;
    property zerobase       :boolean read izerobase write izerobase;

    //settings
    property settings       :string read getsettings write setsettings;//settings as a single line of text

    //workers
    procedure muteall(xmute:boolean);
   end;

{tpiano}
   tpianolabel=array[0..5] of char;
   tpianokey=record
      wlist   :byte;
      wcap    :tpianolabel;
      blist   :byte;
      blist2  :byte;//white key reference
      bcap    :tpianolabel;
      flash   :boolean;
      ltime   :comp;
      lnoteon :boolean;
      end;

   tpiano=class(tbasiccontrol)
   private

    ipainttimer:comp;
    ikeystyle,ilabelmode,ikeycount,iwcount,ibcount,idataref,iref:longint;
    iclsref    :string;
    ilist      :array[0..127] of tpianokey;
    wbottom,wside,wtop:longint;
    bbottom,bside,btop:longint;

    procedure xclear;
    function xwhitekey(x:longint;var xlabel:tpianolabel):boolean;
    procedure setkeystyle(x:longint);
    procedure setkeycount(x:longint);
    procedure xsynckeycount;
    procedure setlabelmode(x:longint);

   public

    odelayMS:longint;

    //create
    constructor create(xparent:tobject); virtual;
    constructor create2(xparent:tobject;xstart:boolean); virtual;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    function getalignheight(xclientwidth:longint):longint; override;//13dec2025
    procedure _onpaint(sender:tobject); override;

    //information
    property keystyle:longint read ikeystyle write setkeystyle;//0=flat, 1=highlight base, 2=highlight tip, 3=off
    property keycount:longint read ikeycount write setkeycount;
    property labelmode:longint read ilabelmode write setlabelmode;

   end;

{tapp}
   tapp=class(tbasicapp)
   private

    ibarleft,ibarright:tbasiccontrol;
    ilaststate:char;
    imiddevice:tbasicsel;
    itranspose:tsimpleint;
    ivol:tsimpleint;
    iplaylist:tplaylist;
    ispeed:tsimpleint;
    imode,istyle:tbasicsel;
    iformats:tbasicset;
    ijump:tbasicjump;
    ititlebar,ijumptitle,itrackbar,ipianobar,ichbar,inotesbar,ilistcap,inavcap:tbasictoolbar;
    inav:tbasicnav;
    ilist,iinfo:tbasicmenu;
    isettingspanel,ilistroot:tbasicscroll;
    ijumpanimate,ixboxfeedback,ishowpiano,ishowbars,ishownav,ishowsettings,ishowinfo,ishowvis,ishowlistlinks,iwidespeedrange,ianimateicon,ialwayson,ionacceptonce,lshow,lshowsep,ilargejumptitle,ilargejump,iautoplay,iautotrim,imuststop,imustplay,iplaying,ibuildingcontrol,iloaded:boolean;
    irenderrate,ivollevel,ibarcol,ibarcol2,inavcol,iviscol,ioutcol,iinfcol,ijumpanimateMode,ixboxcontroller:longint;
    ilasttimeref,iflashref,itimer100,itimer350,itimer500,itimerslow,iinfotimer,ifasttimer:comp;
    iplaylistREF,ijumpcap,ilyricref,iinforef,ilasterror,ilastsavefilename,ilastfilename,inavref,isettingsref:string;
    ilastpos,imustpos:longint;
    ilastbeatval,ilastbeatvalBass,ibeatval,ibeatvalBass,imustpertpos:double;
    //.status support
    iff,iintro,iinfoid,iselstart,iselcount,idownindex,inavindex,ifolderindex,ifileindex,inavcount,ifoldercount,ifilecount:longint;
    iisnav,iisfolder,iisfile:boolean;
    //.midi status
    itracks:ttracks;
    ichannels:tchannels;
    ipiano:tpiano;
    inotes:tnotes;
    ijumpstatus:longint;
    ioutput:toutput;

    procedure xcmd0(xcode2:string);
    procedure xcmd(sender:tobject;xcode:longint;xcode2:string);
    procedure __onclick(sender:tobject);
    procedure __ontimer(sender:tobject); override;
    function __oninfo(sender:tobject;xindex:longint;var xtab:string;var xtep,xtepcolor:longint;var xcaption,xcaplabel,xhelp,xcode2:string;var xcode,xshortcut,xindent:longint;var xflash,xenabled,xtitle,xsep,xbold:boolean):boolean;
    function xmasklist:string;
    function xfull_mask:string;
    procedure xnav_mask;
    procedure xloadsettings;
    procedure xsavesettings;
    procedure xsavesettings2(xforce:boolean);
    procedure xautosavesettings;
    procedure xfillinfo;
    procedure xshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
    function xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
    function xintroms:longint;
    function xffms:longint;
    function xonaccept(sender:tobject;xfolder,xfilename:string;xindex,xcount:longint):boolean;
    function getshowplaylist:boolean;
    procedure setshowplaylist(x:boolean);
    function findlistcmd(n:string;var xcaption,xhelp,xcmd:string;var xtep:longint;var xenabled:boolean;xextendedlables:boolean):boolean;
    function canprev:boolean;
    function cannext:boolean;
    function xmustsaveplaylist:boolean;
    procedure xupdatebuttons;
    procedure xbox;
    function playlist__canaddfile:boolean;
    function xdelayMS:longint;
    function xdelayMS2(const xrenderRate:longint):longint;
    function xrenderLabel(const xindex:longint;var xlabel:string):boolean;
    function xrendercount:longint;
    function xrenderDefault:longint;

    //.saveas
    function xlistfilename:string;
    function xcansaveas:boolean;
    procedure xsaveas;

   public

    //create
    constructor create; virtual;
    destructor destroy; override;
    procedure onpaint__bar(sender:tobject);
    //information
    property showplaylist:boolean read getshowplaylist write setshowplaylist;
//    property shownav:boolean read getshownav write setshownav;

   end;


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024


//app procs --------------------------------------------------------------------
//.create / destroy
procedure app__remove;//does not fire "app__create" or "app__destroy"
procedure app__create;
procedure app__destroy;

//.event handlers
function app__onmessage(m,w,l:longint):longint;
procedure app__onpaintOFF;//called when screen was live and visible but is now not live, and output is back to line by line
procedure app__onpaint(sw,sh:longint);
procedure app__ontimer;

//.support procs
function app__netmore:tnetmore;//optional - return a custom "tnetmore" object for a custom helper object for each network record -> once assigned to a network record, the object remains active and ".clear()" proc is used to reduce memory/clear state info when record is reset/reused
function app__findcustomtep(xindex:longint;var xdata:tlistptr):boolean;
function app__syncandsavesettings:boolean;


implementation

{$ifdef gui}
uses
    gossdat;
{$endif}



//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//get
if      (xname='slogan')              then result:=info__app('name')+' by Blaiz Enterprises'
else if (xname='width')               then result:='1600'
else if (xname='height')              then result:='1020'
else if (xname='language')            then result:='english-australia'//for Clyde - 14sep2025
else if (xname='codepage')            then result:='1252'//for Clyde
else if (xname='msix.tags')           then result:='M'//for Clyde - 10dec2025
else if (xname='ver')                 then result:='1.00.6187'
else if (xname='date')                then result:='01feb2025'
else if (xname='name')                then result:='Cynthia'
else if (xname='web.name')            then result:='cynthia'//used for website name
else if (xname='des')                 then result:='Reliably play midi music files'
else if (xname='infoline')            then result:=info__app('name')+#32+info__app('des')+' v'+app__info('ver')+' (c) 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='size')                then result:=low__b(io__filesize64(io__exename),true)
else if (xname='diskname')            then result:=io__extractfilename(io__exename)
else if (xname='service.name')        then result:=info__app('name')
else if (xname='service.displayname') then result:=info__app('service.name')
else if (xname='service.description') then result:=info__app('des')

//.links and values
else if (xname='linkname')            then result:=info__app('name')+' by Blaiz Enterprises.lnk'
else if (xname='linkname.vintage')    then result:=info__app('name')+' (Vintage) by Blaiz Enterprises.lnk'
//.author
else if (xname='author.shortname')    then result:='Blaiz'
else if (xname='author.name')         then result:='Blaiz Enterprises'
else if (xname='portal.name')         then result:='Blaiz Enterprises - Portal'
else if (xname='portal.tep')          then result:=intstr32(tepBE20)
//.software
else if (xname='url.software')        then result:='https://www.blaizenterprises.com/'+info__app('web.name')+'.html'
else if (xname='url.software.zip')    then result:='https://www.blaizenterprises.com/'+info__app('web.name')+'.zip'
//.urls
else if (xname='url.portal')          then result:='https://www.blaizenterprises.com'
else if (xname='url.contact')         then result:='https://www.blaizenterprises.com/contact.html'
else if (xname='url.facebook')        then result:='https://web.facebook.com/blaizenterprises'
else if (xname='url.mastodon')        then result:='https://mastodon.social/@BlaizEnterprises'
else if (xname='url.twitter')         then result:='https://twitter.com/blaizenterprise'
else if (xname='url.x')               then result:=info__app('url.twitter')
else if (xname='url.instagram')       then result:='https://www.instagram.com/blaizenterprises'
else if (xname='url.sourceforge')     then result:='https://sourceforge.net/u/blaiz2023/profile/'
else if (xname='url.github')          then result:='https://github.com/blaiz2023'
//.program/splash
else if (xname='license')             then result:='MIT License'
else if (xname='copyright')           then result:='© 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='splash.web')          then result:='Web Portal: '+app__info('url.portal')

else
   begin
   //nil
   end;

except;end;
end;


//app procs --------------------------------------------------------------------
procedure app__create;
begin
{$ifdef gui}
iapp:=tapp.create;
{$else}

//.starting...
app__writeln('');
//app__writeln('Starting server...');

//.visible - true=live stats, false=standard console output
scn__setvisible(false);


{$endif}
end;

procedure app__remove;
begin
try

except;end;
end;

procedure app__destroy;
begin
try
//save
//.save app settings
app__syncandsavesettings;

//free the app
freeobj(@iapp);
except;end;
end;

function app__findcustomtep(xindex:longint;var xdata:tlistptr):boolean;

  procedure m(const x:array of byte);//map array to pointer record
  begin
  {$ifdef gui}
  xdata:=low__maplist(x);
  {$else}
  xdata.count:=0;
  xdata.bytes:=nil;
  {$endif}
  end;
begin//Provide the program with a set of optional custom "tep" images, supports images in the TEA format (binary text image)
//defaults
//result:=false;

//sample custom image support
{
case xindex of
tepHand20:m(_tephand20);
end;
}
//successful
result:=(xdata.count>=1);
end;

function app__syncandsavesettings:boolean;
begin
//defaults
result:=false;
try
//.settings
{
app__ivalset('powerlevel',ipowerlevel);
app__ivalset('ramlimit',iramlimit);
{}


//.save
app__savesettings;

//successful
result:=true;
except;end;
end;

function app__netmore:tnetmore;//optional - return a custom "tnetmore" object for a custom helper object for each network record -> once assigned to a network record, the object remains active and ".clear()" proc is used to reduce memory/clear state info when record is reset/reused
begin
result:=tnetbasic.create;
end;

function app__onmessage(m,w,l:longint):longint;
begin
//defaults
result:=0;
end;

procedure app__onpaintOFF;//called when screen was live and visible but is now not live, and output is back to line by line
begin
//nil
end;

procedure app__onpaint(sw,sh:longint);
begin
//console app only
end;

procedure app__ontimer;
begin
try
//check
if itimerbusy then exit else itimerbusy:=true;//prevent sync errors

//last timer - once only
if app__lasttimer then
   begin

   end;

//check
if not app__running then exit;


//first timer - once only
if app__firsttimer then
   begin

   end;



except;end;
try
itimerbusy:=false;
except;end;
end;


constructor tapp.create;
const
   vsep=5;
var
   e:string;
   xsubmenu20:longint;

   procedure ladd(n:string);
   var
      xcaption,xhelp,xcmd:string;
      xtep:longint;
      xenabled:boolean;
   begin
   //check
   if (ilistcap=nil) then exit;
   if not findlistcmd(n,xcaption,xhelp,xcmd,xtep,xenabled,false) then
      begin
      showerror('List command not found "'+n+'"');
      exit;
      end;
   //get
   ilistcap.add(xcaption,xtep,0,xcmd,'Playlist|'+xhelp);
   end;

begin


if system_debug then dbstatus(38,'Debug 010 - 21may2021_528am');//yyyy


//win__make_gosswin2_pas;app__halt;


//prevent app from closing immediately -> we control the shutdown process
app__closepaused:=true;


//required graphic support checkers --------------------------------------------
//needers - 26sep2021
need_mm;//required
need_xbox;//required

//init midi device range -> enable "all midi devices" -> "broadcast" option - 13sep2025
mid_setAllowAllDevices(true);


//init sample disk
idisk__init('Sample Midi Music',tep_notes20);

idisk__tofile21('Joan of Arc.mid',programfile__JoanOfArc_mid,true,e);
idisk__tofile21('Roses Are Red.mid',programfile__Roses_Are_Red_mid,true,e);
idisk__tofile21('Titanic.mid',programfile__Titanic_mid,true,e);
idisk__tofile21('The Pink Panther.mid',programfile__The_Pink_Panther_mid,true,e);
idisk__tofile21('We Are The Champions.mid',programfile__We_Are_The_Champions_mid,true,e);
idisk__tofile21('We Will Rock You.mid',programfile__We_Will_Rock_You_mid,true,e);

idisk__tofile21('Marys.mid',programfile__MARYS_MID,true,e);
idisk__tofile21('12 Days of Christmas.mid',programfile__12DAYS_MID,true,e);
idisk__tofile21('Rock.mid',programfile__ROCK_MID,true,e);
idisk__tofile21('2001.mid',programfile__2001_mid,true,e);
idisk__tofile21('Take A Chance On Me.mid',programfile__ABATAKEACHANCEONME_MID,true,e);
idisk__tofile21('A Minor.mid',programfile__AMINOR_MID,true,e);
idisk__tofile21('Hotel California.mid',programfile__HOTCAL_MID,true,e);
idisk__tofile21('I''ll Take You Home Again Kathleen.mid',programfile__ILLTAKEUHOMEAGAINKATHLEEN_MID,true,e);
idisk__tofile21('D 2PRE.mid',programfile__D_2PRE_MID,true,e);
idisk__tofile21('D 4INV.mid',programfile__D_4INV_MID,true,e);
idisk__tofile21('Cum On Feel The Noise.mid',programfile__CUM_ON_FEEL_THE_NOISE_MID,true,e);
idisk__tofile21('0 Diva.mid',programfile__Diva_mid,true,e);
idisk__tofile21('Classical.mid',programfile__Classical_MID,true,e);
idisk__tofile21('Classical 2.mid',programfile__Classical2_MID,true,e);
idisk__tofile21('Maggie.mid',programfile__MAGGIE_MID,true,e);
idisk__tofile21('Rockin.mid',programfile__ROCKIN_MID,true,e);
idisk__tofile21('RRWaltz.mid',programfile__RRWALTZ_MID,true,e);
idisk__tofile21('Bach.mid',programfile__bach_mid,true,e);
idisk__tofile21('Spin Me Round.mid',programfile__Spin_Me_Round_mid,true,e);//20aug2025



//self
inherited create(strint32(app__info('width')),strint32(app__info('height')));
ibuildingcontrol:=true;


//init
xsubmenu20          :=tepDown;
irenderrate         :=0;
ilaststate          :='n';
ifasttimer          :=slowms64;
itimer100           :=slowms64;
itimer350           :=slowms64;
itimer500           :=slowms64;
itimerslow          :=slowms64;
iflashref           :=slowms64;
iinfotimer          :=slowms64;
ilasttimeref        :=0;

//columns
ibarcol             :=0;
inavcol             :=1;
iviscol             :=2;
ioutcol             :=3;
iinfcol             :=4;
ibarcol2            :=5;

//vars
iloaded             :=false;
ilastsavefilename   :='';
ibeatval            :=0;
ibeatvalBass        :=0;
ilastbeatval        :=0;
ilastbeatvalBass    :=0;
ishowlistlinks      :=false;
ialwayson           :=false;
ianimateicon        :=false;
iwidespeedrange     :=false;
ixboxcontroller     :=0;
ixboxfeedback       :=false;
ionacceptonce       :=false;
ilasterror          :='';
inavref             :='';
ilargejump          :=false;
ilargejumptitle     :=false;
iautoplay           :=false;
ijumpstatus         :=0;//off
ijumpanimate        :=true;
ijumpanimateMode    :=0;//low
iautotrim           :=false;
ishownav            :=false;
ishowbars           :=false;
ishowpiano          :=false;
ishowinfo           :=false;
ishowsettings       :=false;
ishowvis            :=false;
iintro              :=0;
iff                 :=0;
ilyricref           :='';
iplaylistREF        :='';
lshow               :=true;
lshowsep            :=true;
ivollevel           :=0;

mm_playmanagement_init(imuststop,imustplay,iplaying,imustpertpos,imustpos,ilastpos,ilastfilename);

//.playlist handler
iplaylist:=tplaylist.create;
iplaylist.fullmask:=xfull_mask;//master mask - 20mar2022
iplaylist.partmask:='';

//.midi handler
mid_setkeepopen(false);//auto closes midi device after 5 seconds of inactivity
mid_enhance(true);//enable enhanced midi features -> e.g. realtime status

//controls
with rootwin do
begin

scroll:=false;
xhead;
xgrad;

xhead.add('Nav',tepNav20,0,'nav.toggle','Navigation Panel | Toggle navigation panel (play folder / play list)');
xhead.add('Play Folder',tepFolder20,0,'show.folder','Play midis in a folder');
xhead.add('Play List',tepNotes20,0,'show.list','Play midis in a playlist');

xhead.add('Prev',tepPrev20,0,'prev','Previous midi');
xhead.add('Rewind',tepRewind20,0,'rewind','Rewind # seconds');
xhead.add('Stop',tepStop20,0,'stop','Stop playback');

xhead.benabled2['stop']:=false;

xhead.add('Play',tepPlay20,0,'play','Toggle playback');
xhead.add('Fast Forward',tepFastForward20,0,'fastforward','Fast forward # seconds');
xhead.add('Next',tepNext20,0,'next','Next midi');
xhead.add('Menu',tepMenu20,0,'menu','Show menu');

xhead.xaddMixer;
xhead.xaddoptions;
xhead.xaddhelp;

//.playback status
with xhigh2 do
begin
ipianobar:=ntitlebar(false,'Piano','View realtime piano key presses');
with ipianobar do
begin
halign:=2;

add('White',tepNone,0,  'piano.labelmode.3','Piano|Turn on white key labels');
add('C + F',tepNone,0,  'piano.labelmode.2','Piano|Turn on key label for middle C + F');
add('C',tepNone,0,      'piano.labelmode.1','Piano|Turn on key label for middle C');
add('Off',tepNone,0,    'piano.labelmode.0','Piano|Turn off key labels');
add('',xsubmenu20,0,'piano.menu','Piano|Show options');
end;
ipiano:=tpiano.create(client);

ijumpcap:='Playback Progress';
ijumptitle:=ntitlebar(false,ijumpcap,'Midi playback progress');
with ijumptitle do
begin
osepv:=5;
oautoheight:=false;//1 line only
halign:=2;

add('Nav',tepNav20,0,'nav.toggle','Navigation Panel | Toggle navigation panel (play folder / play list)');
add('Piano',tepNav20,0,'piano.toggle','Piano Panel | Toggle piano display');
add('Pbar',tepVisual20,0,'jumpanimate.toggle','Playback Progress Bar | Toggle sound animation');
add('Bars',tepVisual20,0,'bars.toggle','Volume Bars | Toggle volume bars');
add('Visual',tepVisual20,0,'vis.toggle','Visualisation Panel | Toggle visualisation panel');
add('Info',tepInfo20,0,'info.toggle','Information Panel | Toggle information panel');
add('Settings',tepSettings20,0,'settings.toggle','Information Panel | Toggle settings sub-panel');
add('',xsubmenu20,0,'jump.menu','Playback Progress|Show options');
end;

ijump:=xhigh2.njump('','Click and/or drag to adjust playback position',0,0);

end;
end;


//------------------------------------------------------------------------------
//navigation column - left -----------------------------------------------------
//------------------------------------------------------------------------------
rootwin.xcols.style:=bcLefttoright;//04feb2025

with rootwin.xcols.makecol(inavcol,100,false) do
begin

ilistroot:=client as tbasicscroll;

//.play from folder
inavcap:=ntoolbar('Navigate files and folders on disk');
with inavcap do
begin
maketitle3('Play Folder',false,false);
opagename:='folder';
normal:=false;
add('Refresh',tepRefresh20,0,'refresh','Navigation|Refresh list');
add('Fav',tepFav20,0,'nav.fav','Navigation|Show favourites list');
add('Back',tepBack20,0,'nav.prev','Navigation|Previous folder');
add('Forward',tepForw20,0,'nav.next','Navigation|Next folder');
add('Add',tepEdit20,0,'list.addfile','Playlist|Add selected file to playlist');
onclick:=__onclick;
end;

inav:=nnav.makenavlist;
inav.hisname:='cynthia';//24may2021
inav.omasklist:=xfull_mask;
inav.oautoheight:=true;
inav.sortstyle:=nlName;//nlSize;
inav.style:=bnNavlist;
inav.ofindname:=true;//21feb2022
inav.opagename:='folder';

//.play from list
ilistcap:=ntoolbar('Navigate files and folders on disk');
with ilistcap do
begin
maketitle3('Play List',false,false);
opagename:='list';
normal:=false;
ladd('edit');
ladd('new');
ladd('open');
ladd('save as');
addsep;
ladd('cut');
ladd('copy');
ladd('copy all');
ladd('paste');
ladd('replace');//19apr2022
ladd('undo');


with xhigh2 do
begin
imode:=nsel('Playback Mode','Playback mode',0);
with imode do
begin
xadd('Once','once','Playback Mode|Play selected midi once');
xadd('Repeat One','repeat1','Playback Mode|Play selected midi repeatedly');
xadd('Repeat All','repeat1','Playback Mode|Play all midis repeatedly');
xadd('All Once','once','Playback Mode|Play all midis once');
xadd('Random','repeat1','Playback Mode|Play midis randomly');
end;
end;

//.event
onclick:=__onclick;
end;

ilist:=nlist('','',nil,0);
ilist.opagename:='list';
ilist.oretainpos:=true;
ilist.onumberfrom:=0;
ilist.help:='Select file to play';
ilist.ocanshowmenu:=true;

//default playback list style
page:='folder';
end;

//------------------------------------------------------------------------------
//information column - right ---------------------------------------------------
//------------------------------------------------------------------------------

with rootwin.xcols.makecol(iinfcol,100,false) do
begin

ititlebar:=ntitlebar(false,'Midi Information','Midi information');
with ititlebar do
begin

add('',tepLess20,0,'vol.dn','Volume|Decrease volume');
add('Vol 100',tepNone,0,'vol.100','Volume|Reset volume to 100%');
add('',tepMore20,0,'vol.up','Volume|Increase volume');

addsep;

add('',tepLess20,0,'speed.dn','Speed|Decrease playback speed');
add('Speed 100',tepNone,0,'speed.100','Speed|Reset playback speed to 100%');
add('',tepMore20,0,'speed.up','Speed|Increase playback speed');

end;


iinfo:=nlistx('','Midi technnical and playback information',22,22,__oninfo);//11aug2025
iinfo.otab     :=tbL100_L500;
iinfo.oscaleh  :=0.70;
iinfo.makepanel;//21aug2025

//settings
isettingspanel:=xhigh2;
isettingspanel.osepv:=5;

with isettingspanel.xpage2('settings','Settings','','',tepSettings20,true) do//page 1
begin

//.formats
with xhigh2.ncols do
begin
makeautoheight;

iformats:=makecol(0,30,false).nset('File Types','File Types | Select midi file types to list in the Navigation panel (left) | Selecting no file type lists all midi file types',7,7);
with iformats do
begin
osepv:=vsep;
itemsperline:=3;
xset(0,'mid', 'mid','File Types|Include ".mid" file type in play list',true);
xset(1,'midi','midi','File Types|Include ".midi" file type in play list',true);
xset(2,'rmi', 'rmi','File Types|Include ".rmi" file type in play list',true);
end;

//.device
imiddevice:=makecol(1,70,false).nmidi('','');
imiddevice.osepv:=vsep;

end;



//.style
istyle:=xhigh2.nsel('Play Style','Select play style',0);
with istyle do
begin
osepv:=vsep;
itemsperline:=4;
xadd('GM','GM','GM');
xadd('GS','GS','GS');
xadd('XG','XG','XG');
xadd('GM2','GM2','GM2');
end;
istyle.visible:=synth_showstyle;//16apr2021

//.transpose
itranspose:=xhigh2.mmiditranspose('','');
itranspose.osepv:=vsep;

//.speed
ispeed:=xhigh2.mint2b('Speed','Playback speed|Restore default playback speed','Playback speed|Set playback speed from 10% (slower) to 1,000% (faster)|Normal playback speed is 100%',10,1000,100,100,'');
ispeed.osepv:=2*vsep;
ispeed.ounit:=' %';

//.volume
ivol:=xhigh2.mmidivol('','');
ivol.osepv:=vsep;

end;//page1

with isettingspanel.xpage2('output','Playback Devices','','',tepVisual20,true) do//page 2
begin
ioutput:=toutput.create(xhigh2.client);
end;

end;

isettingspanel.pageindex:=0;


//------------------------------------------------------------------------------
//visualisation column - middle ------------------------------------------------
//------------------------------------------------------------------------------

with rootwin.xcols.makecol(iviscol,100,false) do
begin

//.tracks
with xhigh do
begin
itrackbar:=ntitlebar(false,'Tracks','Realtime midi data track usage');
with itrackbar do
begin
halign:=2;
add('',tepMute20,0,'tracks.muteall','Tracks|Mute all tracks');
add('',tepUnmute20,0,'tracks.unmuteall','Tracks|Unmute all tracks');
add('',xsubmenu20,0,'tracks.menu','Tracks|Show options');
end;
itracks:=ttracks.create(client);
end;

//.channels
xcols.style:=bcToptobottom;
with xcols.makecol(0,35,false) do
begin
ichbar:=ntitlebar(false,'Channels','Realtime midi data channel usage');
with ichbar do
begin
osepv:=vsep;
halign:=2;

add('Labels',tepEdit20,0,'ch.showlabels','Channels|Toggle channel labels');

add('',tepLess20,0,'ch.lessvols','Channels|Decrease all channel volumes by 10%');
add('100',tepNone,0,'ch.resetvols','Channels|Reset all channel volumes to 100%');
add('',tepMore20,0,'ch.morevols','Channels|Increase all channel volumes by 10%');

add('',tepMute20,0,'ch.muteall','Channels|Mute all channels');
add('',tepUnmute20,0,'ch.unmuteall','Channels|Unmute all channels');
add('',xsubmenu20,0,'ch.menu','Channels|Show options');
end;
ichannels:=tchannels.create(client);
end;

//.notes
with xcols.makecol(1,65,false) do
begin

inotesbar:=ntitlebar(false,'Notes','Realtime midi note usage');
with inotesbar do
begin
osepv:=vsep;
halign:=2;

add('Notes',tepNew20,0,'notes.asnotes','Notes|Show as notes');
add('Numbers',tepNew20,0,'notes.asnumbers','Notes|Show as numbers');

add('',tepMute20,0,'notes.muteall','Notes|Mute all notes');
add('',tepUnmute20,0,'notes.unmuteall','Notes|Unmute all notes');
add('',xsubmenu20,0,'notes.menu','Notes|Show options');
end;

inotes:=tnotes.create(client);
inotes.oautoheight:=true;
end;

end;


//------------------------------------------------------------------------------
//effects bars -----------------------------------------------------------------
//------------------------------------------------------------------------------
with rootwin.xcols.makecol(ibarcol,10,false) do
begin

ibarleft     :=client;
oroundstyle  :=corSlight;
normal       :=false;
onpaint      :=onpaint__bar;

end;

with rootwin.xcols.makecol(ibarcol2,10,false) do
begin

ibarright    :=client;
oroundstyle  :=corSlight;
normal       :=false;
onpaint      :=onpaint__bar;

end;

//events
rootwin.onaccept:=xonaccept;
rootwin.xhead.onclick:=__onclick;
itrackbar.onclick:=__onclick;
ichbar.onclick:=__onclick;
inotesbar.onclick:=__onclick;
ipianobar.onclick:=__onclick;
ijumptitle.onclick:=__onclick;
ititlebar.onclick:=__onclick;
isettingspanel.xtoolbar.onclick:=__onclick;

//.nav
inav.onclick:=__onclick;
inav.xlist.showmenuFill1:=xshowmenuFill1;
inav.xlist.showmenuClick1:=xshowmenuClick1;
//.list
ilist.onclick:=__onclick;
ilist.showmenuFill1:=xshowmenuFill1;
ilist.showmenuClick1:=xshowmenuClick1;
iplaylist.list:=ilist;//connect playlist handler to user list - 20mar2022
//.jump
ijump.onclick:=__onclick;


//animated icon support - 30apr2022
rootwin.xhead.aniAdd(tepIcon24,500);
rootwin.xhead.aniAdd(tepIcon24B,500);
//rootwin.xhead.aniAdd(tepError32,500);


//defaults
ibuildingcontrol:=false;
xloadsettings;
xfillinfo;


//iautoplay
if iautoplay then imustplay:=true;


//finish
createfinish;

end;

destructor tapp.destroy;
begin
try
//settings
xsavesettings;
//controls
mid_stop;
freeobj(@iplaylist);
//self
inherited destroy;
except;end;
end;

procedure tapp.onpaint__bar(sender:tobject);
var
   a:tbasiccontrol;
   s:tclientinfo;
   v,vb:double;

   procedure xbar(const xpert:double;const xstyle:string;xerase:boolean);
   var
      vpos:longint;
   begin

   vpos :=frcrange32( trunc( (1-xpert) * (s.cs.bottom-s.cs.top+1) ) + s.cs.top, s.cs.top, s.cs.bottom);

   if xerase             then a.ffillArea( area__make(s.cs.left,s.cs.top,s.cs.right,vpos),s.back,false);

   if (vpos<s.cs.bottom) then
      begin

      a.fshadeArea2( area__make(s.cs.left,vpos,s.cs.right,s.cs.bottom), s.colhover2.x,s.colhover2.y,s.colhover2.y,s.colhover2.x,5,255,false);

      end;

   end;

   procedure xbar2(const xpert:double;xback,xpeak:longint;const xswapcols:boolean);
   var
      vgap,vpos:longint;
   begin

   if xswapcols then low__swapint(xback,xpeak);

   vpos  :=frcrange32( trunc( (1-xpert) * (s.cs.bottom-s.cs.top+1) ) + s.cs.top, s.cs.top, s.cs.bottom);
   vgap  :=trunc(0.2*(s.cs.right-s.cs.left+1));

   if (vpos<s.cs.bottom) then
      begin

      a.fshadeArea2( area__make(s.cs.left+vgap,vpos,s.cs.right-vgap,s.cs.bottom), xback,xpeak,xpeak,xback,10,255,true);

      end;

   end;
begin

//check
if (sender is tbasiccontrol) then a:=(sender as tbasiccontrol) else exit;

//init
a.infovars2(s,true);
v       :=ilastbeatval;
vb      :=ilastbeatvalBass;

//overal volume indicator
xbar(v,'g-10',true);

//bass volume indicator
xbar2(vb*0.7, int__splice24(0.25+vb,s.back,s.colhover2.y), int__splice24(vb,s.info.hover,s.font), false);

end;

procedure tapp.xupdatebuttons;
var
   xmustalign,xshownav,xplaylist,bol1:boolean;
begin
try
//init
xmustalign :=false;
xshownav   :=ishownav or ((not ishowinfo) and (not ishowvis));


//get
xplaylist:=showplaylist;
bol1:=ishowlistlinks;
rootwin.xhead.bmarked2['show.folder']:=not xplaylist;
rootwin.xhead.bmarked2['show.list']:=xplaylist;

ioutput.zerobase:=ichannels.zerobase;

ichbar.bmarked2['ch.showlabels']:=ichannels.showlabels;

inotesbar.bmarked2['notes.asnotes']:=inotes.olabels;
inotesbar.bmarked2['notes.asnumbers']:=not inotes.olabels;

isettingspanel.xtoolbar.bvisible2[scpage+'output']:=(mid_deviceindex=mmsys_mid_broadcast);

ilistcap.benabled2['list.undo']:=iplaylist.canundo;
ilistcap.benabled2['list.open']:=iplaylist.canopen;
ilistcap.benabled2['list.saveas']:=iplaylist.cansave;
ilistcap.benabled2['list.new']:=iplaylist.cannew;
ilistcap.benabled2['list.cut']:=iplaylist.cancut;
ilistcap.benabled2['list.copy']:=iplaylist.cancopy;
ilistcap.benabled2['list.copyall']:=iplaylist.cancopyall;

ilistcap.bvisible2['list.undo']:=bol1;
ilistcap.bvisible2['list.open']:=bol1;
ilistcap.bvisible2['list.saveas']:=bol1;
ilistcap.bvisible2['list.new']:=bol1;
ilistcap.bvisible2['list.cut']:=bol1;
ilistcap.bvisible2['list.copy']:=bol1;
ilistcap.bvisible2['list.copyall']:=bol1;
ilistcap.bvisible2['list.replace']:=bol1;//19apr2022

inavcap.benabled2['list.addfile']:=playlist__canaddfile;//19aug2025

ititlebar.benabled2['vol.up']   :=(ivollevel<ivol.max);
ititlebar.benabled2['vol.100']  :=(ivollevel<>100);
ititlebar.benabled2['vol.dn']   :=(ivollevel>ivol.min);

ititlebar.benabled2['speed.up'] :=(ispeed.val<ispeed.max);
ititlebar.benabled2['speed.100']:=(ispeed.val<>100);
ititlebar.benabled2['speed.dn'] :=(ispeed.val>ispeed.min);

with ipianobar do
begin
bmarked2['piano.labelmode.0']:=ipiano.labelmode=0;
bmarked2['piano.labelmode.1']:=ipiano.labelmode=1;
bmarked2['piano.labelmode.2']:=ipiano.labelmode=2;
bmarked2['piano.labelmode.3']:=ipiano.labelmode=3;
end;

with ijumptitle do
begin
bmarked2['nav.toggle']         :=xshownav;
bmarked2['piano.toggle']       :=ishowpiano;
bmarked2['info.toggle']        :=ishowinfo;
bmarked2['settings.toggle']    :=ishowsettings;
bmarked2['vis.toggle']         :=ishowvis;
bmarked2['bars.toggle']        :=ishowbars;
bmarked2['jumpanimate.toggle'] :=ijumpanimate;

//bflash2['nav.toggle']:=xshownav;
//bflash2['info.toggle']:=ishowinfo;
//bflash2['vis.toggle']:=ishowvis;
end;

with inavcap do
begin
benabled2['nav.prev']:=inav.canprev;
benabled2['nav.next']:=inav.cannext;
end;

//play
bol1:=iplaying;//imidi.playing;
with rootwin.xhead do
begin
benabled2['rewind']:=(mid_pos>1);
benabled2['stop']:=bol1;
bflash2['play']:=bol1;
bmarked2['play']:=bol1;
benabled2['fastforward']:=(mid_len<>0);
benabled2['prev']:=canprev;//23mar2022
benabled2['next']:=cannext;
bmarked2['nav.toggle']:=xshownav;
//bflash2['nav.toggle']:=xshownav;
end;

//.autotrim
if (mid_trimtolastnote<>iautotrim) then mid_settrimtolastnote(iautotrim);

//.show columns
rootwin.xcols.vis[ibarcol]:=ishowbars;
rootwin.xcols.vis[inavcol]:=xshownav;
rootwin.xcols.vis[iviscol]:=ishowvis;
rootwin.xcols.vis[iinfcol]:=ishowinfo;
rootwin.xcols.vis[ibarcol2]:=ishowbars;//27aug2025

if (isettingspanel.visible<>ishowsettings) then//15aug2025
   begin
   isettingspanel.visible :=ishowsettings;
   xmustalign             :=true;
   end;

if (ipianobar.visible<>ishowpiano) or (ipiano.visible<>ishowpiano) then
   begin
   ipianobar.visible   :=ishowpiano;
   ipiano.visible      :=ishowpiano;
   xmustalign          :=true;
   end;

//.visual panels
itracks.otrackcount:=mid_tracks;

//.jump
ijump.status:=ijumpstatus;
ijump.olarge:=ilargejump;
ijumptitle.olarge:=ilargejumptitle;

//.sync odelayMS - 01feb2026
itracks.odelayMS       :=xdelayMS;
ichannels.odelayMS     :=xdelayMS;
inotes.odelayMS        :=xdelayMS;
ipiano.odelayMS        :=xdelayMS;

//.widespeedrange
if (ispeed.min<>low__aorb(50,10,iwidespeedrange)) then
   begin

   case iwidespeedrange of
   true:ispeed.setparams(10,1000,ispeed.def,ispeed.val);
   else ispeed.setparams(50,200,ispeed.def,ispeed.val);
   end;//case

   end;

//.xmustalign
if xmustalign then gui.fullalignpaint;
except;end;
end;

function tapp.xdelayMS:longint;
begin

result:=xdelayMS2(irenderrate);

end;

function tapp.xdelayMS2(const xrenderRate:longint):longint;
begin

case xrenderRate of
0    :result:=10;//100 fps
1    :result:=17;//60
2    :result:=33;//30
3    :result:=50;//20
4    :result:=100;//10
else result:=10;
end;//case

end;

function tapp.xrenderDefault:longint;
begin

result:=2;

end;

function tapp.xrenderLabel(const xindex:longint;var xlabel:string):boolean;
var
   v:longint;
begin

//get
v     :=round32(1000/xdelayMS2(xindex));

//clean numbers
if (v=59) then v:=60;

//set
xlabel:=intstr32(v)+' fps';
result:=(xindex>=0) and (xindex<=4);

end;

function tapp.xrendercount:longint;
begin

result:=5;

end;

function tapp.findlistcmd(n:string;var xcaption,xhelp,xcmd:string;var xtep:longint;var xenabled:boolean;xextendedlables:boolean):boolean;
var
   str1:string;

   procedure xset(acap,ahelp,acmd:string;atep:longint;aenabled:boolean);
   begin
   xcaption:=acap;
   xhelp:=ahelp;
   xcmd:=acmd;
   xtep:=atep;
   xenabled:=aenabled;
   result:=true;
   end;
begin
//defaults
result:=false;

try
n:=strlow(n);
xcaption:='';
xhelp:='';
xcmd:='';
xtep:=tepNone;
xenabled:=false;
str1:=insstr('...',xextendedlables);
//get
if (n='new')           then xset('New'+str1,'Create new playlist','list.new',tepNew20,iplaylist.cannew)
else if (n='edit')     then xset('Edit','Show edit menu','list.edit',tepEdit20,true)
else if (n='open')     then xset('Open'+str1,'Open playlist from file','list.open',tepOpen20,iplaylist.canopen)
else if (n='save as')  then xset('Save As'+str1,'Save playlist to file','list.saveas',tepSave20,iplaylist.cansave)
else if (n='cut')      then xset('Cut','Cut selected playlist item to Clipboard','list.cut',tepCut20,iplaylist.cancut)
else if (n='copy')     then xset('Copy','Copy selected playlist item to Clipboard','list.copy',tepCopy20,iplaylist.cancopy)
else if (n='copy all') then xset('Copy All','Copy entire playlist to Clipboard','list.copyall',tepCopy20,iplaylist.cancopyall)
else if (n='paste')    then xset('Paste','Paste playlist from Clipboard at end of current playlist','list.paste',tepPaste20,iplaylist.canpaste)
else if (n='replace')  then xset('Replace','Replace playlist with Clipboard playlist','list.replace',tepPaste20,iplaylist.canreplace)
else if (n='undo')     then xset('Undo','Undo last playlist change','list.undo',tepUndo20,iplaylist.canundo);
except;end;
end;

function tapp.playlist__canaddfile:boolean;
begin
result:=(not showplaylist) and (inav.valuestyle=nltFile);
end;

function tapp.getshowplaylist:boolean;
begin
result:=(ilistroot<>nil) and (ilistcap<>nil) and strmatch(ilistroot.page,ilistcap.opagename);
end;

procedure tapp.setshowplaylist(x:boolean);
begin
if (ilistroot<>nil) and (ilistcap<>nil) then ilistroot.page:=low__aorbstr(inavcap.opagename,ilistcap.opagename,x);
end;

function tapp.xonaccept(sender:tobject;xfolder,xfilename:string;xindex,xcount:longint):boolean;
begin
result:=true;

try
if io__fileexists(xfilename) then
   begin
   if not ionacceptonce then
      begin
      ionacceptonce:=true;
      iplaylist.xfillundo;//fill undo
      showplaylist:=true;//switch to play list mode - 20mar2022
      end;
   iplaylist.xaddone(-1,'',xfilename);
   end;
if ionacceptonce and (xindex>=(xcount-1)) then iplaylist.xmask(true);
//reset
if (xindex>=(xcount-1)) then ionacceptonce:=false;//done
except;end;
end;

function tapp.xintroms:longint;
begin
case iintro of
1:result:=2000;
2:result:=5000;
3:result:=10000;
4:result:=30000;
else result:=0;
end;
end;

function tapp.xffms:longint;
begin
case iff of
1:result:=2000;
2:result:=5000;
3:result:=10000;
4:result:=30000;
else result:=1000;
end;
end;

procedure tapp.xshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
label
   skipend;
var
   p,xholdindex,xholdms:longint;
   str1:string;

   procedure ladd(n:string);
   var
      xcaption,xhelp,xcmd:string;
      xtep:longint;
      xenabled:boolean;
   begin
   //check
   if (ilistcap=nil) then exit;
   if not findlistcmd(n,xcaption,xhelp,xcmd,xtep,xenabled,true) then
      begin
      showerror('List command not found "'+n+'"');
      exit;
      end;
   //get
   low__menuitem2(xmenudata,xtep,xcaption,xhelp,xcmd,100,aknone,xenabled);
   end;

   function ides(xsec:longint):string;
   begin
   case xsec of
   0:result:='Select to play entire midi (no intro mode)';
   else result:='Select to play first '+intstr32(xsec)+' seconds of midi';
   end;//case
   end;

   function fdes(xsec:longint):string;
   begin
   result:='Select to rewind and fast forward by '+intstr32(xsec)+' second'+insstr('s',xsec>=2);
   end;

begin
try
//check
if zznil(xmenudata,5000) then exit;

//menu history
xmenuname:='history.'+xstyle;


//main options
if (xstyle='') then
   begin
   low__menutitle(xmenudata,tepnone,'Play Options','Play options');
   if not showplaylist then low__menuitem2(xmenudata,tepRefresh20,'Refresh','Refresh list','refresh',100,aknone,true);
   low__menuitem2(xmenudata,tepStop20,'Stop','Stop playback','stop',100,aknone,iplaying);
   low__menuitem3(xmenudata,tepPlay20,'Play','Toggle playback','play',100,aknone,iplaying,true);
   low__menusep(xmenudata);
   low__menuitem3(xmenudata,tep__yes(iautoplay),'Play on Start','Ticked: Commence play on program start','autoplay',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(iautotrim),'Trim Trailing Silence','Trim Trailing Silence | When ticked, trailing silence is removed from playback | The midi file is not modified','autotrim',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(lshow),'Show Lyrics','Ticked: Show lyrics in the playback progress bar title','lshow',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(lshowsep),'Hyphenate Lyrics','Ticked: Hyphenate the midi lyrics','lshowsep',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(ialwayson),'Always on Midi','Ticked: Remain connected to midi device | Not Ticked: Disconnect from midi device after a short idle period','alwayson',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(ianimateicon),'Animate Icon','Ticked: Animate icon whilst playing','animateicon',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(iwidespeedrange),'Extended Speed Range','Extended Speed Range|Toggle speed range between 50-200% and 10-1,000%','widespeedrange',100,aknone,false,true);
   //.save as
   low__menuitem3(xmenudata,tepSave20,'Save Midi As...','Save selected midi to file','saveas',100,aknone,false,xcansaveas);

   //.render rate
   low__menutitle(xmenudata,tepnone,'Peak Render Rate','Peak render rate options');
   for p:=0 to (xrendercount-1) do
   begin

   xrenderLabel(p,str1);
   low__menuitem3(xmenudata,tep__tick(p=irenderRate),str1,'Peak Render Rate | Set peak render rate for realtime graphic controls','render.rate.'+intstr32(p),100,aknone,false,true);

   end;//p


   //.xbox controller
   low__menutitle(xmenudata,tepnone,'Xbox Controller','Xbox controller options');
   low__menuitem3(xmenudata,tep__tick(ixboxcontroller=0),'Off','Xbox Controller | Do not use an Xbox Controller','xbox.0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ixboxcontroller=1),'Active Only','Xbox Controller | Control Cynthia with an Xbox Controller whilst in the foreground (active)','xbox.1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ixboxcontroller=2),'Active and Inactive','Xbox Controller | Control Cynthia with an Xbox Controller whilst in the foreground (active) or in the background (inactive)','xbox.2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(ixboxfeedback),'Feedback','Xbox Controller | Send vibration feedback to the Xbox controller','xbox.f',100,aknone,false,true);
   //.intro
   low__menutitle(xmenudata,tepnone,'Intro Mode','Play first # seconds of midi');
   low__menuitem3(xmenudata,tep__tick(iintro=0),'Off',ides(0),'intro:0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iintro=1),'2 secs',ides(2),'intro:1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iintro=2),'5 secs',ides(5),'intro:2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iintro=3),'10 secs',ides(10),'intro:3',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iintro=4),'30 secs',ides(30),'intro:4',100,aknone,false,true);
   //.ff and rr time
   low__menutitle(xmenudata,tepnone,'Rewind / Fast Forward By','Rewind / Fast Forward by # seconds');
   low__menuitem3(xmenudata,tep__tick(iff=0),'1 sec',fdes(1),'ff:0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iff=1),'2 secs',fdes(2),'ff:1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iff=2),'5 secs',fdes(5),'ff:2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iff=3),'10 secs',fdes(10),'ff:3',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iff=4),'30 secs',fdes(30),'ff:4',100,aknone,false,true);
   end
else if (xstyle='tracks.menu') then
   begin

   low__menutitle(xmenudata,tepnone,'Display'                                 ,'Display Style|Display style options');
   low__menuitem3(xmenudata,tep__yes(itracks.oflat),'Flat','Display Style|Flat or shaded','tracks.flat',100,aknone,false,true);

   goto skipend;

   end
else if (xstyle='ch.menu') then
   begin

   low__menutitle(xmenudata,tepnone,'Hold Time','Hold modes');

   for p:=0 to max32 do
   begin

   if not ichannels.findhold(p,xholdindex,xholdms) then break;

   low__menuitem3(xmenudata,tep__tick(ichannels.hold=xholdindex),
    low__aorbstr('Off',curdec(xholdms/1000,1,false)+' s',xholdms>0),
    'Channels|Hold '+low__aorbstr('Hold off','Hold for'+#32+k64(xholdms)+' s',xholdms>0),'ch.hold.'+intstr32(xholdindex),100,aknone,false,true);

   end;//p

   low__menutitle(xmenudata,tepnone,'Labels','Label options');
   low__menuitem3(xmenudata,tep__yes(ichannels.showlabels),'Show',   'Labels|Tick to show','ch.showlabels',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(ichannels.up),'Upward',         'Labels|Upward or downward label text direction','ch.up',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ichannels.align=0),'Top',      'Labels|Align label at top','ch.align.0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ichannels.align=1),'Center',   'Labels|Align label in center','ch.align.1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ichannels.align=2),'Bottom',   'Labels|Align label at bottom','ch.align.2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(ichannels.zerobase),'0-15',     'Labels|Number channels 0-15 or 1-16','ch.zerobase',100,aknone,false,true);

   low__menutitle(xmenudata,tepnone,'Display',                       'Display Style|Display style options');
   low__menuitem3(xmenudata,tep__yes(ichannels.oflat),'Flat',        'Display Style|Flat or shaded','ch.flat',100,aknone,false,true);

   goto skipend;

   end
else if (xstyle='notes.menu') then
   begin

   low__menutitle(xmenudata,tepnone,'Hold Time','Hold modes');

   for p:=0 to max32 do
   begin

   if not inotes.findhold(p,xholdindex,xholdms) then break;

   low__menuitem3(xmenudata,tep__tick(inotes.hold=xholdindex),
    low__aorbstr('Off',curdec(xholdms/1000,1,false)+' s',xholdms>0),
    'Notes|Hold '+low__aorbstr('Hold off','Hold for'+#32+k64(xholdms)+' s',xholdms>0),'notes.hold.'+intstr32(xholdindex),100,aknone,false,true);

   end;//p

   low__menutitle(xmenudata,tepnone,'Notes Per Row','Notes|Set the number of notes per row');
   low__menuitem3(xmenudata,tep__tick(2=inotes.olayout),'8 Notes'             ,'Notes|8 notes per row','layout.2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(0=inotes.olayout),'12 Notes'            ,'Notes|12 notes per row','layout.0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(1=inotes.olayout),'12 Notes + Indent 4' ,'Notes|12 notes per row + indent by 4','layout.1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(3=inotes.olayout),'16 Notes'            ,'Notes|16 notes per row','layout.3',100,aknone,false,true);

   low__menutitle(xmenudata,tepnone,'Note Labels'                             ,'Notes|Set note label style');
   low__menuitem3(xmenudata,tep__tick(inotes.olabels),'As Notes'              ,'Notes|As notes','labels.on',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(not inotes.olabels),'As Numbers'        ,'Notes|As numbers','labels.off',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(inotes.zerobase),'0-127'                 ,'Notes|Number notes 0-127 or 1-128','notes.zerobase',100,aknone,false,true);

   low__menutitle(xmenudata,tepnone,'Display'                                 ,'Display Style|Display style options');
   low__menuitem3(xmenudata,tep__yes(inotes.ooutline),'Outline'               ,'Display Style|Outline or underline hold indicator','notes.outline',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(inotes.oflat),'Flat'                     ,'Display Style|Flat or shaded','notes.flat',100,aknone,false,true);

   goto skipend;

   end
else if (xstyle='piano.menu') then
   begin
   low__menutitle(xmenudata,tepnone,'Keyboard Size','Set keyboard size');
   low__menuitem3(xmenudata,tep__tick(ipiano.keycount=37),'37 keys','','piano.keycount.37',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keycount=49),'49 keys','','piano.keycount.49',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keycount=54),'54 keys','','piano.keycount.54',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keycount=61),'61 keys','','piano.keycount.61',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keycount=76),'76 keys','','piano.keycount.76',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keycount=88),'88 keys','','piano.keycount.88',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keycount=128),'128 keys','','piano.keycount.128',100,aknone,false,true);
   low__menutitle(xmenudata,tepnone,'Key Labels','Set key labels');
   low__menuitem3(xmenudata,tep__tick(ipiano.labelmode=0),'Off','','piano.labelmode.0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.labelmode=1),'Middle C','','piano.labelmode.1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.labelmode=2),'Middle C + F','','piano.labelmode.2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.labelmode=3),'White Keys','','piano.labelmode.3',100,aknone,false,true);
   low__menutitle(xmenudata,tepnone,'Key Highlight Style','Set keyboard key highlight style');
   low__menuitem3(xmenudata,tep__tick(ipiano.keystyle=khsOff)     ,'Off','','piano.keystyle.'+intstr32(khsOff),100,aknone,false,true);//15sep2025
   low__menuitem3(xmenudata,tep__tick(ipiano.keystyle=khsFlat)    ,'Flat','','piano.keystyle.'+intstr32(khsFlat),100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keystyle=khsShadeUP) ,'Shade Up','','piano.keystyle.'+intstr32(khsShadeUP),100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keystyle=khsShadeDN) ,'Shade Down','','piano.keystyle.'+intstr32(khsShadeDN),100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keystyle=khsSubtle)  ,'Subtle','','piano.keystyle.'+intstr32(khsSubtle),100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keystyle=khsSubtle2) ,'Subtle 2','','piano.keystyle.'+intstr32(khsSubtle2),100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keystyle=khsEdge)    ,'Leading Edge','','piano.keystyle.'+intstr32(khsEdge),100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ipiano.keystyle=khsEdge2)   ,'Leading Edge 2','','piano.keystyle.'+intstr32(khsEdge2),100,aknone,false,true);
   goto skipend;
   end
else if (xstyle='jump.menu') then
   begin
   low__menutitle(xmenudata,tepnone,'Playback Progress Bar','Playback progress bar options');
   low__menuitem3(xmenudata,tep__yes(ilargejumptitle),'Large Title','Ticked: Show large title/lyrics','largejumptitle',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(ilargejump),'Large Bar','Ticked: Show large playback progress bar','largejump',100,aknone,false,true);

   low__menutitle(xmenudata,tepnone,'Animate Playback Bar','Animate Playback Bar');
   low__menuitem3(xmenudata,tep__yes(ijumpanimate),'Enable','Animate Playback Bar|Toggle sound animation','jumpanimate.toggle',100,aknone,false,true);

   low__menuitem3(xmenudata,tep__tick(ijumpanimateMode=0),'Low','Animate Playback Bar|Animate subtly','jumpanimatemode.0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ijumpanimateMode=1),'Medium','Animate Playback Bar|Animate noticeably','jumpanimatemode.1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ijumpanimateMode=2),'High','Animate Playback Bar|Animate strongly','jumpanimatemode.2',100,aknone,false,true);

   low__menutitle(xmenudata,tepnone,'Status','Playback progress bar status');
   low__menuitem3(xmenudata,tep__tick(ijumpstatus=1),'Elapsed Time','Selected: Show elapsed time in playback progress bar','jumpstatus.1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ijumpstatus=2),'Remaining Time','Selected: Show remaining time in playback progress bar','jumpstatus.2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(ijumpstatus=0),'Off','Selected: Show no status in playback progress bar','jumpstatus.0',100,aknone,false,true);

   low__menutitle(xmenudata,tepnone,'Lyrics','Lyric options');
   low__menuitem3(xmenudata,tep__yes(lshow),'Show Lyrics','Ticked: Show lyrics in the playback progress bar title','lshow',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(lshowsep),'Hyphenate Lyrics','Ticked: Hyphenate the midi lyrics','lshowsep',100,aknone,false,true);
   goto skipend;
   end;

//play list options
if showplaylist or (xstyle='playlist') then
   begin
   low__menutitle(xmenudata,tepNotes20,'Play List Options','Play List options');
   ladd('new');
   ladd('open');
   ladd('save as');
   low__menusep(xmenudata);
   ladd('cut');
   ladd('copy');
   ladd('copy all');
   ladd('paste');
   ladd('replace');
   ladd('undo');
   low__menusep(xmenudata);
   low__menuitem3(xmenudata,tep__yes(ishowlistlinks),'Show Links on Toolbar','Ticked: Show links on toolbar','list.showlinks',100,aknone,false,true);
   end;

skipend:
except;end;
end;

function tapp.xlistfilename:string;
begin
if       showplaylist             then result:=ilist.xgetval2(ilist.itemindex)
else if (inav.valuestyle=nltFile) then result:=inav.value
else                                   result:='';
end;

function tapp.xcansaveas:boolean;
begin
result:=(xlistfilename<>'');
end;

procedure tapp.xsaveas;
var
   str1,sf,df,dext,e:string;
begin
//init
sf:=xlistfilename;
df:=io__extractfilepath(strdefb(ilastsavefilename,sf))+io__extractfilename(sf);
dext:=io__readfileext_low(df);
str1:='';

//get
if gui.popsave(df,dext,'',str1) then
   begin
   ilastsavefilename:=df;
   if not io__copyfile(sf,df,e) then gui.poperror('',e);
   end;
end;

function tapp.xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
begin
if strmatch(strcopy1(xcode2,1,4),'nav.') then result:=false
else
   begin
   result:=true;//handled
   xcmd(nil,0,xcode2);
   end;
end;

procedure tapp.xfillinfo;
begin

case showplaylist of
false:if zzok(inav,7320) then inav.findinfo(iselstart,iselcount,idownindex,inavindex,ifolderindex,ifileindex,inavcount,ifoldercount,ifilecount,iisnav,iisfolder,iisfile);
true:iisfile:=(ilastfilename<>'')
end;//case

low__iroll(iinfoid,1);

end;

function tapp.xmasklist:string;
label
   redo;
var
   xonce,xforce:boolean;
begin
//init
result:='';

try
xonce:=true;
xforce:=false;
//get
redo:
if xforce or iformats.vals[0] then result:=result+'*.mid;';
if xforce or iformats.vals[1] then result:=result+'*.midi;';
if xforce or iformats.vals[2] then result:=result+'*.rmi;';
//check
if xonce and (result='') then
   begin
   xonce:=false;
   xforce:=true;
   goto redo;
   end;
except;end;
end;

function tapp.xfull_mask:string;
begin
result:='*.mid;*.rmi;*.midi';
end;

procedure tapp.xnav_mask;
var
   v:string;
begin
try
v:=xmasklist;
if (v<>inav.omasklist) then inav.omasklist:=v;
except;end;
end;

procedure tapp.xloadsettings;
var
   a:tvars8;
   e,xname:string;
   p:longint;
begin
try
//defaults
a:=nil;
//check
if zznil(prgsettings,5001) then exit;
//init
a:=vnew2(950);
//filter
a.b['show.list']             :=prgsettings.bdef('show.list',false);//20mar2022
a.i['intro']                 :=prgsettings.idef('intro',0);
a.i['ff']                    :=prgsettings.idef('ff',0);//19apr2022
a.i['midvol']                :=prgsettings.idef('midvol',100);
a.i['notelayout']            :=prgsettings.idef('notelayout',1);//layout.1
a.b['notelabels']            :=prgsettings.bdef('notelabels',true);
a.b['autoplay']              :=prgsettings.bdef('autoplay',true);
a.b['autotrim']              :=prgsettings.bdef('autotrim',false);
a.b['largejump']             :=prgsettings.bdef('largejump',true);
a.b['largejumptitle']        :=prgsettings.bdef('largejumptitle',true);
a.b['lshow']                 :=prgsettings.bdef('lshow',true);
a.b['alwayson']              :=prgsettings.bdef('alwayson',false);
a.b['animateicon']           :=prgsettings.bdef('animateicon',true);//30apr2022
a.b['widespeedrange']        :=prgsettings.bdef('widespeedrange',false);//20aug2025
a.i['xboxcontroller']        :=prgsettings.idef('xboxcontroller',0);//25jan2025
a.b['xboxfeedback']          :=prgsettings.bdef('xboxfeedback',false);//25jan2025
a.b['list.showlinks']        :=prgsettings.bdef('list.showlinks',false);//27mar2022
a.b['lshowsep']              :=prgsettings.bdef('lshowsep',false);
a.i['transpose']             :=prgsettings.idef('transpose',0);
a.i['speed']                 :=prgsettings.idef('speed',100);
a.i['mode']                  :=prgsettings.idef('mode',2);
a.i['style']                 :=prgsettings.idef('style',0);
a.i['deviceindex']           :=prgsettings.idef('deviceindex',0);
a.i['formats']               :=prgsettings.idef('formats',7);
a.s['folder']                :=prgsettings.sdef('folder','!:\');//sample drive
a.s['name']                  :=io__extractfilename(prgsettings.sdef('name',''));
a.i['playlist.index']        :=prgsettings.idef('playlist.index',0);
a.s['tracks.mutelist']       :=prgsettings.sdef('tracks.mutelist','');
a.s['channels.levels']       :=prgsettings.sdef('channels.levels','');
a.s['notes.mutelist']        :=prgsettings.sdef('notes.mutelist','');
a.i['pagesright.index']      :=prgsettings.idef('pagesright.index',0);
a.b['shownav']               :=prgsettings.bdef('shownav',true);
a.b['showpiano']             :=prgsettings.bdef('showpiano',true);
a.b['showinfo']              :=prgsettings.bdef('showinfo',true);
a.b['showbars']              :=prgsettings.bdef('showbars',true);
a.b['showsettings']          :=prgsettings.bdef('showsettings',true);//15aug2025
a.b['showvis']               :=prgsettings.bdef('showvis',true);
a.i['jumpstatus']            :=prgsettings.idef('jumpstatus',1);
a.b['jumpanimate']           :=prgsettings.bdef('jumpanimate',true);//27aug2025
a.i['jumpanimatemode']       :=prgsettings.idef('jumpanimatemode',1);//27aug2025
a.i['piano.keystyle']        :=prgsettings.idef('piano.keystyle',khsShadeUP);
a.i['piano.keycount']        :=prgsettings.idef('piano.keycount',88);
a.i['piano.labelmode']       :=prgsettings.idef('piano.labelmode',1);
a.i['render.rate']           :=prgsettings.idef2('render.rate',xrenderDefault,0,xrendercount-1);//0=fastest

//tracks
a.b['tracks.flat']           :=prgsettings.bdef('tracks.flat',false);//28aug2025

//channels
a.b['channels.flat']         :=prgsettings.bdef('channels.flat',false);//28aug2025
a.i['channels.hold']         :=prgsettings.idef('channels.hold',-1);//28aug2025
a.b['channels.zerobase']     :=prgsettings.bdef('channels.zerobase',true);//07sep2025

//notes
a.b['notes.flat']            :=prgsettings.bdef('notes.flat',false);//28aug2025
a.b['notes.outline']         :=prgsettings.bdef('notes.outline',true);//28aug2025
a.b['notes.zerobase']        :=prgsettings.bdef('notes.zerobase',true);//07sep2025
a.i['notes.hold']            :=prgsettings.idef('notes.hold',-1);//28aug2025


//nav
inav.xfromprg2('nav',a);//prg -> nav -> a

//get
lshow                        :=a.b['lshow'];
lshowsep                     :=a.b['lshowsep'];
ialwayson                    :=a.b['alwayson'];//23mar2022
ianimateicon                 :=a.b['animateicon'];//30apr2022
iwidespeedrange              :=a.b['widespeedrange'];
ixboxcontroller              :=frcrange32(a.i['xboxcontroller'],0,2);
ixboxfeedback                :=a.b['xboxfeedback'];
ishowlistlinks               :=a.b['list.showlinks'];
iintro                       :=frcrange32(a.i['intro'],0,4);
iff                          :=frcrange32(a.i['ff'],0,4);//19apr2022
mmsys_mid_basevol            :=frcrange32(a.i['midvol'],0,200);
itranspose.val               :=frcrange32(a.i['transpose'],-127,127);
ispeed.val                   :=frcrange32(a.i['speed'],10,1000);
imode.val                    :=frcrange32(a.i['mode'],0,mmMax);
istyle.val                   :=frcrange32(a.i['style'],0,3);
iformats.val                 :=a.i['formats'];
ishownav                     :=a.b['shownav'];
ishowbars                    :=a.b['showbars'];
ishowpiano                   :=a.b['showpiano'];
ishowinfo                    :=a.b['showinfo'];
ishowsettings                :=a.b['showsettings'];
ishowvis                     :=a.b['showvis'];
ijumpstatus                  :=frcrange32(a.i['jumpstatus'],0,2);
ijumpanimate                 :=a.b['jumpanimate'];
ijumpanimatemode             :=frcrange32(a.i['jumpanimatemode'],0,2);
irenderRate                  :=a.i['render.rate'];//01feb2026
xnav_mask;
xname:=a.s['name'];
case (xname<>'') of
true:inav.value              :=io__readportablefilename(io__asfolderNIL(a.s['folder']))+xname;//focus the previously playing track - 20feb2022
false:inav.folder            :=io__readportablefilename(io__asfolderNIL(a.s['folder']));
end;
//.mutelist
itracks.settings             :=a.s['tracks.mutelist'];
ichannels.settings           :=a.s['channels.levels'];
inotes.settings              :=a.s['notes.mutelist'];

//.playlist
iplaylist.partmask           :=xmasklist;
iplaylist.xopen2(low__platprgext('m3u'),a.i['playlist.index'],false,false,e);
xmustsaveplaylist;//don't save now we've loaded it - 25mar2022
//.other
inotes.olayout               :=frcrange32(a.i['notelayout'],0,3);
inotes.olabels               :=a.b['notelabels'];
ilargejump                   :=a.b['largejump'];
ilargejumptitle              :=a.b['largejumptitle'];
iautoplay                    :=a.b['autoplay'];//do after
iautotrim                    :=a.b['autotrim'];//11jan2025
showplaylist                 :=a.b['show.list'];

//trcks
itracks.oflat                :=a.b['tracks.flat'];

//channels
ichannels.oflat              :=a.b['channels.flat'];
ichannels.hold               :=a.i['channels.hold'];
ichannels.zerobase           :=a.b['channels.zerobase'];

//notes
inotes.oflat                 :=a.b['notes.flat'];
inotes.ooutline              :=a.b['notes.outline'];
inotes.hold                  :=a.i['notes.hold'];
inotes.zerobase              :=a.b['notes.zerobase'];


ipiano.keystyle              :=a.i['piano.keystyle'];
ipiano.keycount              :=a.i['piano.keycount'];
ipiano.labelmode             :=a.i['piano.labelmode'];

//sync
prgsettings.data             :=a.data;
xupdatebuttons;

except;end;

//free
freeobj(@a);

//mark as loaded
iloaded:=true;

end;

procedure tapp.xsavesettings;
begin
xsavesettings2(true);
end;

procedure tapp.xsavesettings2(xforce:boolean);
var
   a:tvars8;
   p:longint;
   e:string;
begin
try
//check
if not iloaded then exit;
//defaults
a:=nil;
a:=vnew2(951);
//get
a.b['show.list']             :=showplaylist;//20mar2022
a.i['intro']                 :=frcrange32(iintro,0,4);
a.i['ff']                    :=frcrange32(iff,0,4);//19apr2022
a.i['midvol']                :=frcrange32(mmsys_mid_basevol,0,200);
a.b['largejump']             :=ilargejump;
a.b['largejumptitle']        :=ilargejumptitle;
a.b['autoplay']              :=iautoplay;
a.b['autotrim']              :=iautotrim;
a.i['notelayout']            :=inotes.olayout;
a.b['notelabels']            :=inotes.olabels;
a.b['lshow']                 :=lshow;
a.b['lshowsep']              :=lshowsep;
a.b['alwayson']              :=ialwayson;
a.b['animateicon']           :=ianimateicon;
a.b['widespeedrange']        :=iwidespeedrange;
a.i['xboxcontroller']        :=ixboxcontroller;
a.b['xboxfeedback']          :=ixboxfeedback;
a.b['list.showlinks']        :=ishowlistlinks;
a.i['transpose']             :=itranspose.val;
a.i['speed']                 :=ispeed.val;
a.i['mode']                  :=imode.val;
a.i['style']                 :=istyle.val;
a.i['formats']               :=iformats.val;
a.s['folder']                :=io__makeportablefilename(inav.folder);
a.s['name']                  :=io__extractfilename(inav.value);
a.b['shownav']               :=ishownav;
a.b['showpiano']             :=ishowpiano;
a.b['showinfo']              :=ishowinfo;
a.b['showbars']              :=ishowbars;
a.b['showsettings']          :=ishowsettings;
a.b['showvis']               :=ishowvis;

a.b['jumpanimate']           :=ijumpanimate;
a.i['jumpanimatemode']       :=ijumpanimateMode;
a.i['jumpstatus']            :=ijumpstatus;

a.i['render.rate']           :=frcrange32(irenderrate,0,xrendercount-1);

//tracks
a.b['tracks.flat']           :=itracks.oflat;
a.s['tracks.mutelist']       :=itracks.settings;

//channels
a.b['channels.zerobase']     :=ichannels.zerobase;
a.b['channels.flat']         :=ichannels.oflat;
a.i['channels.hold']         :=ichannels.hold;
a.s['channels.levels']       :=ichannels.settings;

//notes
a.b['notes.zerobase']        :=inotes.zerobase;
a.b['notes.flat']            :=inotes.oflat;
a.b['notes.outline']         :=inotes.ooutline;
a.i['notes.hold']            :=inotes.hold;
a.s['notes.mutelist']        :=inotes.settings;

a.i['piano.keystyle']        :=ipiano.keystyle;
a.i['piano.keycount']        :=ipiano.keycount;
a.i['piano.labelmode']       :=ipiano.labelmode;

a.i['playlist.index']        :=ilist.itemindex;
if xmustsaveplaylist or xforce then iplaylist.xsave2(low__platprgext('m3u'),false,e);//25mar2022
inav.xto(inav,a,'nav');

//set
prgsettings.data             :=a.data;
siSaveprgsettings;
except;end;

//free
freeobj(@a);

end;

function tapp.xmustsaveplaylist:boolean;
begin
result:=low__setstr(iplaylistREF,intstr32(iplaylist.id));
end;

procedure tapp.xautosavesettings;
var
   str1:string;
begin
try

//check
if not iloaded then exit;

//get
str1:=
 bolstr(inotes.zerobase)+bolstr(ichannels.zerobase)+bolstr(itracks.oflat)+bolstr(ichannels.oflat)+bolstr(inotes.oflat)+bolstr(inotes.ooutline)+'|'+itracks.settings+'|'+inotes.settings+'|'+ichannels.settings+'|'+intstr32(mmsys_mid_basevol)+'|'+intstr32(iplaylist.id)+'|'+intstr32(iintro)+'|'+intstr32(iff)+'|'+intstr32(irenderRate)+'|'+intstr32(ixboxcontroller)+'|'+bolstr(ixboxfeedback)+bolstr(ishowlistlinks)+bolstr(showplaylist)+bolstr(lshow)+bolstr(iwidespeedrange)+bolstr(ianimateicon)+bolstr(ialwayson)+bolstr(lshowsep)+bolstr(ishowbars)+bolstr(ishownav)+bolstr(ishowpiano)+bolstr(ishowinfo)+bolstr(ishowvis)+bolstr(ilargejumptitle)+bolstr(ilargejump)+bolstr(iautoplay)+bolstr(iautotrim)+'|'+intstr32(ipiano.labelmode)+'|'+intstr32(inotes.olayout)+'|'+bolstr(ijumpanimate)+'|'+intstr32(ijumpanimateMode)+'|'+intstr32(ijumpstatus)+'|'+intstr32(ipiano.keycount)+'|'+intstr32(ichannels.hold)+'|'+
 intstr32(inotes.hold)+'|'+intstr32(ispeed.val)+'|'+intstr32(vimididevice)+'|'+intstr32(istyle.val)+'|'+
 intstr32(mid_itemsid)+'|'+intstr32(imode.val)+'|'+intstr32(inav.sortstyle)+'|'+intstr32(iformats.val)+'|'+inav.folder;

//save
if low__setstr(isettingsref,str1) then xsavesettings2(false);

except;end;
end;

function tapp.canprev:boolean;
begin
if showplaylist then result:=(ilist.itemindex>=1) else result:=(inav.itemindex>=1);
end;

function tapp.cannext:boolean;
begin
if showplaylist then result:=(ilist.itemindex<(ilist.count-1)) else result:=(inav.itemindex<(inav.totalcount-1));
end;

procedure tapp.__onclick(sender:tobject);
begin
xcmd(sender,0,'');
end;

procedure tapp.xcmd0(xcode2:string);
begin
xcmd(nil,0,xcode2);
end;

procedure tapp.xcmd(sender:tobject;xcode:longint;xcode2:string);
label
   skipend;
var
   a:tstr8;
   xresult,zok:boolean;
   v,e:string;
   v32:longint;

   function mv(const x:string):boolean;
   begin
   result:=strm(xcode2,x,v,v32);
   end;

   function m(const x:string):boolean;
   begin
   result:=strmatch(x,xcode2);
   end;

begin//use for testing purposes only - 15mar2020
//defaults
xresult :=true;
e       :=gecTaskfailed;
v       :='';
v32     :=0;

try
a:=nil;
//init
zok:=zzok(sender,7455);
if zok and (sender is tbasictoolbar) then
   begin
   //ours next
   xcode:=(sender as tbasictoolbar).ocode;
   xcode2:=strlow((sender as tbasictoolbar).ocode2);
   //nav toolbar handler 1st
   if (xcode2<>'nav.refresh') then
      begin
      if inav.xoff_toolbarevent(sender as tbasictoolbar) then goto skipend;
      end;
   end
else if zok and ((sender is tbasicnav) or (sender=ilist)) then
   begin
   if gui.mousedbclick and vidoubleclicks and (not iplaying) and (inav.valuestyle=nltFile) then imustplay:=true;//07sep2025
   goto skipend;
   end
else if zok and (sender=ijump) then
   begin
   imustpertpos:=ijump.hoverpert;
   goto skipend;
   end;

//get
if m('max') then
   begin
   if (gui.state='+') then gui.state:='n' else gui.state:='+';
   end

else if m('refresh') or m('nav.refresh') then//override "inav" refresh without our own
   begin
   inav.reload;
   ilastfilename:='';
   end

else if m('home') then
   begin
   inav.folder:='';
   ilastfilename:='';
   end

else if m('lshow')            then lshow:=not lshow
else if m('lshowsep')         then lshowsep:=not lshowsep
else if m('alwayson')         then ialwayson:=not ialwayson//23mar2022
else if m('animateicon')      then ianimateicon:=not ianimateicon//30apr2022
else if m('widespeedrange')   then iwidespeedrange:=not iwidespeedrange//20aug2025
else if m('xbox.f')           then ixboxfeedback:=not ixboxfeedback
else if mv('xbox.')           then ixboxcontroller:=frcrange32(v32,0,2)
else if mv('render.rate.')    then irenderRate:=frcrange32(v32,0,xrenderCount-1)//01feb2026
else if mv('intro:')          then iintro:=frcrange32(v32,0,4)
else if mv('ff:')             then iff:=frcrange32(v32,0,4)
else if m('list.showlinks')   then ishowlistlinks:=not ishowlistlinks
else if m('list.edit')        then ilist.showmenu2('playlist')
else if m('list.undo')        then xresult:=iplaylist.undo(e)
else if m('list.new')         then xresult:=iplaylist.new(e)
else if m('list.cut')         then xresult:=iplaylist.cut(e)//20mar2022
else if m('list.copy')        then xresult:=iplaylist.copy(e)
else if m('list.copyall')     then xresult:=iplaylist.copyall(e)
else if m('list.paste')       then xresult:=iplaylist.paste(e)
else if m('list.replace')     then xresult:=iplaylist.replace(e)
else if m('list.open')        then xresult:=iplaylist.open(e)
else if m('list.saveas')      then xresult:=iplaylist.save(e)
else if m('list.addfile')     then xresult:=iplaylist.addfile(inav.value,e)
else if m('show.list')        then showplaylist:=true
else if m('show.folder')      then showplaylist:=false
else if m('nav.toggle')       then ishownav:=not ishownav
else if m('bars.toggle')      then ishowbars:=not ishowbars
else if m('piano.toggle')     then ishowpiano:=not ishowpiano
else if m('info.toggle')      then ishowinfo:=not ishowinfo
else if m('settings.toggle')  then ishowsettings:=not ishowsettings//15aug2025
else if m('vis.toggle')       then ishowvis:=not ishowvis

else if m('vol.up')           then ivol.val:=ivol.val+5
else if m('vol.100')          then ivol.val:=100
else if m('vol.dn')           then ivol.val:=ivol.val-5

else if m('speed.up')         then ispeed.val:=ispeed.val+2
else if m('speed.100')        then ispeed.val:=100
else if m('speed.dn')         then ispeed.val:=ispeed.val-2

else if m('menu') then
   begin
   if showplaylist then ilist.showmenu else inav.showmenu;
   end

else if m('tracks.menu') or m('ch.menu') or m('notes.menu') or m('piano.menu') or m('jump.menu') then ilist.showmenu2(xcode2)

else if m('prev') then
   begin
   if showplaylist then
      begin
      ilist.notidle;
      ilist.itemindex:=frcmin32(ilist.itemindex-1,0);
      end
   else
      begin
      inav.notidle;
      inav.itemindex:=frcmin32(inav.itemindex-1,0);
      end;
   end

else if m('next') then
   begin
   if showplaylist then
      begin
      ilist.notidle;
      ilist.itemindex:=frcmax32(ilist.itemindex+1,frcmin32(ilist.count-1,0));
      end
   else
      begin
      inav.notidle;
      inav.itemindex:=inav.itemindex+1;
      end;
   end

else if m('rewind')           then mid_setpos(mid_pos-xffms)//10mar2021
else if m('fastforward')      then mid_setpos(mid_pos+xffms)//10mar2021
else if m('stop')             then imuststop:=true

else if m('play') then
   begin

   case iplaying of
   true:imuststop:=true;
   else imustplay:=true;
   end;//case

   end

else if m('largejumptitle')   then ilargejumptitle:=not ilargejumptitle
else if m('largejump')        then ilargejump:=not ilargejump
else if mv('layout.')         then inotes.olayout:=frcrange32(v32,0,3)
else if m('labels.on')        then inotes.olabels:=true
else if m('labels.off')       then inotes.olabels:=false

else if mv('piano.labelmode.') then ipiano.labelmode:=v32
else if mv('piano.keycount.')  then ipiano.keycount:=v32
else if mv('piano.keystyle.')  then ipiano.keystyle:=v32

else if m('autoplay')         then iautoplay:=not iautoplay//16apr2021
else if m('autotrim')         then iautotrim:=not iautotrim//11jan2025
else if m('saveas')           then xsaveas

else if m('folder') then
   begin
   if (inav.folder<>'')       then runLOW(inav.folder,'');
   end
else if m('tracks.muteall')   then itracks.muteall(true)
else if m('tracks.unmuteall') then itracks.muteall(false)
else if m('tracks.flat')      then itracks.oflat:=not itracks.oflat

else if m('ch.morevols')      then ichannels.morevols(10)
else if m('ch.lessvols')      then ichannels.morevols(-10)
else if m('ch.resetvols')     then ichannels.resetvols
else if m('ch.muteall')       then ichannels.muteall(true)
else if m('ch.unmuteall')     then ichannels.muteall(false)
else if m('ch.flat')          then ichannels.oflat:=not ichannels.oflat
else if mv('ch.hold.')        then ichannels.hold:=v32

else if m('notes.zerobase')   then inotes.zerobase:=not inotes.zerobase
else if m('notes.muteall')    then inotes.muteall(true)
else if m('notes.unmuteall')  then inotes.muteall(false)
else if m('notes.asnotes')    then inotes.olabels:=true
else if m('notes.asnumbers')  then inotes.olabels:=false
else if m('notes.flat')       then inotes.oflat:=not inotes.oflat
else if m('notes.outline')    then inotes.ooutline:=not inotes.ooutline
else if mv('notes.hold.')     then inotes.hold:=v32

else if m('ch.showlabels')    then ichannels.showlabels:=not ichannels.showlabels
else if m('ch.up')            then ichannels.up:=not ichannels.up
else if mv('ch.align.')       then ichannels.align:=v32
else if m('ch.zerobase')      then ichannels.zerobase:=not ichannels.zerobase

else if m('jumpanimate.toggle') then ijumpanimate:=not ijumpanimate
else if mv('jumpanimatemode.')  then ijumpanimatemode:=frcrange32(v32,0,2)
else if mv('jumpstatus.')       then ijumpstatus:=frcrange32(v32,0,2)

else
   begin
   if system_debug then showtext('Unknown Command>'+xcode2+'<<');
   end;

skipend:
except;end;
try
str__free(@a);
xupdatebuttons;
if not xresult then gui.poperror('',e);
except;end;
end;

procedure tapp.__ontimer(sender:tobject);//._ontimer
label
   skipend;
var
   xmuted,xbass,bol1:boolean;
   dcount,dtotal,dcount3,dtotal3,xchannel,xnote,vcount,vtotal:longint;
   vave,vave3,vaved,vaveBass:double;
   xtime,vtime,v64:comp;
   xvol:byte;
   xinfo:tmidinote;

   function xave(xtotal,xcount:longint):double;
   begin

   result:=frcrangeD64( ( xtotal/frcmin32(xcount,1) )*(1/127), 0, 1);

   end;

begin
try

//timer100
if (slowms64>=itimer100) and iloaded then
   begin

   //play management
   case showplaylist of
   false:if mm_playmanagement('mid',imode.val,xintroms,imuststop,imustplay,iplaying,bol1,imustpertpos,imustpos,ilastpos,ilastfilename,inav,nil,'',ijump) and bol1 then xfillinfo;
   true:if mm_playmanagement('mid',imode.val,xintroms,imuststop,imustplay,iplaying,bol1,imustpertpos,imustpos,ilastpos,ilastfilename,nil,ilist,'',ijump) and bol1 then xfillinfo;
   end;

   //speed
   if (not gui.mousedown) and (mid_speed<>ispeed.val) then mid_setspeed(ispeed.val);

   //style
   if (not gui.mousedown) and synth_showstyle and (mid_style<>istyle.val) then mid_setstyle(istyle.val);

   //lyric
   if low__setstr(ilyricref,bolstr(lshow)+bolstr(lshowsep)+bolstr(mid_lyriccount>=1)+bolstr(iplaying)+'|'+intstr32(mid_pos)+'|'+intstr32(mid_len)+'|'+ilastfilename) then
      begin
      case lshow and (mid_lyriccount>=1) of
      true:ijumptitle.caption:=ijumpcap+'  -  Lyrics:  '+mid_lyric(mid_pos,lshowsep);
      false:ijumptitle.caption:=ijumpcap;
      end;
      end;

   //animated icon
   if ianimateicon and mid_playing then rootwin.xhead.aniPlay;//30apr2022

   //xbox
   xbox;

   //reset
   itimer100:=slowms64+100;
   end;


//infotimer
if (slowms64>=iinfotimer) then
   begin

   //info
   if low__setstr(iinforef,intstr32(mid_datarate)+'|'+intstr32(vimididevice)+'|'+bolstr(xbox__info(-1).connected)+bolstr(mid_deviceactive)+bolstr(mid_keepopen)+bolstr(mid_loop)+bolstr(mid_playing)+'|'+k64(mid_midbytes)+'|'+intstr32(mid_transpose)+'|'+intstr32(mid_speed)+'|'+intstr32(mid_tracks)+'|'+intstr32(mid_format)+'|'+k64(iinfoid)+'|'+k64(mid_pos)+'|'+intstr32(iintro)+'|'+k64(mid_len)+'|'+k64(xintroms)+'|'+ilasterror+'|'+ilastfilename) then iinfo.paintnow;

   //vol
   ivollevel:=ivol.val;//cache volume level

   //reset
   iinfotimer:=slowms64+250;

   end;

//timer350
if (slowms64>=itimer350) then
   begin

   //page
   xupdatebuttons;

   //nav
   inav.xoff_toolbarsync(rootwin.xhead);

   //reset
   itimer350:=slowms64+350;

   end;

//timer500
if (slowms64>=itimer500) then
   begin

   //links
   bol1:=clip__canpastetext;
   ilistcap.benabled2['list.paste']:=bol1;
   ilistcap.benabled2['list.replace']:=bol1;
   mid_setkeepopen(ialwayson);

   //savesettings
   xautosavesettings;

   //update list mask
   xnav_mask;
   iplaylist.partmask:=xmasklist;

   //reset
   itimer500:=slowms64+500;

   end;

//animate "playback bar" and side "volume bars"
if mid_playing then
   begin

   //init
   v64    :=ms64;

   vtime  :=0;
   vcount :=0;
   vtotal :=0;

   //.drums
   dcount  :=0;
   dtotal  :=0;

   dcount3 :=0;
   dtotal3 :=0;

   //get
   //.channels
   for xchannel:=0 to 15 do
   begin

   xbass   :=mid_voiceisBass( mmsys_mid_voiceindex[ xchannel ] );

   //.notes
   for xnote:=0 to 127 do if mid_trackinginfo(xchannel,xnote,xinfo) and (xinfo.volOUT>=1) and (xinfo.timeOUt>=v64) then
      begin

      //normal notes
      inc(vcount);
      inc(vtotal,xinfo.volOUT);

      //bass.average notes
      if xbass then
         begin

         inc(dcount3);
         inc(dtotal3,xinfo.volOUT);

         end;

      //drum notes
      if (xchannel=9) then
         begin

         inc(dcount,1);
         inc(dtotal,xinfo.volOUT);

         end;

      end;//xnote

   end;//xchannel


   //set
   vave     :=xave(vtotal,vcount);
   vave3    :=xave(dtotal3,dcount3);
   vaved    :=xave(dtotal,dcount);


   if low__setcmp(ilasttimeref,vtime) then//new notes bring new times -> detect new notes and pulse the bars up/down by 25% - 03sep2025
      begin

      if (vave>=1)  then vave:=(vave*0.75)   else vave:=frcrangeD64(1.25*vave,0,1);
      if (vave3>=1) then vave3:=(vave3*0.75) else vave3:=frcrangeD64(1.25*vave3,0,1);
      if (vaved>=1) then vaved:=(vaved*0.95) else vaved:=frcrangeD64(1.05*vaved,0,1);

      end;

   vaveBass        :=frcrangeD64( vaved + ( vave3*0.3 ) ,0,1);
   ibeatval        :=frcrangeD64( (( vave     + (ibeatval     *5) ) / 6), 0, 1);//choke values 0..1 to avoid accidental numerical runaway overflow
   ibeatvalBass    :=frcrangeD64( (( vaveBass + (ibeatvalBass *2) ) / 3), 0, 1);//faster drift down for drums

   //.immediate up stroke
   if (vaveBass>ibeatvalBass) then ibeatvalBass:=vaveBass;


   //fast timer
   app__turbo;

   end
else
   begin

   ibeatval        :=0;
   ibeatvalBass    :=0;

   end;


//render.rate - 01feb2026
if (slowms64>=ifasttimer) then
   begin

   //jump bar animation
   if ijumpanimate then
      begin

      ijump.flashval  :=ibeatval;
      ijump.flashval9 :=ibeatvalBass;

      case ijumpanimateMode of
      0:ijump.power    :=0.20;
      1:ijump.power    :=0.45;
      else ijump.power :=1.00;
      end;//case

      end
   else
      begin

      ijump.flashval  :=0;
      ijump.flashval9 :=0;

      end;


   //beat bars / volume bars
   if ishowbars then
      begin

      if (ilastbeatval<>ibeatval) or (ilastbeatvalBass<>ibeatvalBass)  then
         begin
         ilastbeatval      :=ibeatval;
         ilastbeatvalBass  :=ibeatvalBass;

         ibarleft.paintnow;
         ibarright.paintnow;
         end;

      end;


   //reset
   ifasttimer:=slowms64+frcmin32(xdelayMS,1);

   end;

//debug support
if system_debug then
   begin
   if system_debugFAST then rootwin.paintallnow;
   end;
if system_debug and system_debugRESIZE then
   begin
   if (system_debugwidth<=0) then system_debugwidth:=gui.width;
   if (system_debugheight<=0) then system_debugheight:=gui.height;
   //change the width and height to stress
   //was: if (random(10)=0) then gui.setbounds(gui.left,gui.top,system_debugwidth+random(32)-16,system_debugheight+random(128)-64);
   gui.setbounds(gui.left,gui.top,system_debugwidth+random(32)-16,system_debugheight+random(128)-64);
   end;


skipend:

//can close audio system and app safely -> tell system it's safe to shutdown now - 10aug2025
if app__closeinited and mm_safetohalt then
   begin

   app__closepaused:=false;

   end;

except;end;
end;

procedure tapp.xbox;
var
   int1,ci:longint;
   val1:double;

   procedure xsetstate2(xindex:longint;l,r:double);
   begin
   if ixboxfeedback then xbox__setstate2(xindex,l,r);
   end;

   procedure xlogicmap(var v1,v2:boolean);
   begin
   //increments logic using to booleans
   //00 -> 10
   //10 -> 11
   //11 -> 01
   //01 -> 00
   if (not v1) and (not v2) then
      begin
      v1:=true;
      v2:=false;
      end
   else if v1 and (not v2) then
      begin
      v1:=true;
      v2:=true;
      end
   else if v1 and v2 then
      begin
      v1:=false;
      v2:=true;
      end
   else if (not v1) and v2 then
      begin
      v1:=false;
      v2:=false;
      end
   else
      begin
      v1:=true;
      v2:=false;
      end;
   end;
begin
//xbox
for ci:=0 to xbox__lastindex(false) do
begin

//.turn off motors even if we've stopped using the xbox controller
if xbox__inited and xbox__info(ci).connected and ((xbox__info(ci).lm<>0) or (xbox__info(ci).rm<>0)) then xbox__setstate2(ci,0,0);

//.read controller
if ( (ixboxcontroller>=2) or ((ixboxcontroller=1) and gui.active) ) and xbox__state(ci) then
   begin
   xbox__deadzone(0.3);

   if xbox__bclick(ci) then xcmd0('play');

   //.midi device
   if xbox__lclick(ci) then imiddevice.val:=imiddevice.val-1;
   if xbox__rclick(ci) then imiddevice.val:=imiddevice.val+1;

   //.next and prev midi
   if xbox__uclick(ci) or (xbox__info(ci).u and (low__clickidle>=500)) then xcmd0('prev');
   if xbox__dclick(ci) or (xbox__info(ci).d and (low__clickidle>=500)) then xcmd0('next');

   //.playback position
   if (xbox__info(ci).rx<>0) then
      begin
      int1:=round(xbox__info(ci).rx*3000);
      if (int1<>0) then
         begin
         ijump.moveby(int1);
         val1:=ijump.pos/frcmin32(ijump.len,1);
         if (val1<=0.5) then xsetstate2(ci,val1,0) else xsetstate2(ci,0,val1);
         end;
      end;

   //.volume
   if (xbox__info(ci).lx<>0) then
      begin
      int1:=round(xbox__info(ci).lx*5);
      if (int1<>0) then ivol.val:=ivol.val+int1;

      if (ivol.val<=ivol.min) or (ivol.val>=ivol.max) then xsetstate2(ci,1,0);
      end;

   //.speed
   if (xbox__info(ci).lt>0) or (xbox__info(ci).rt>0) then
      begin
      if (xbox__info(ci).lt>0) then int1:=-1 else int1:=1;
      if (int1<>0) then ispeed.val:=ispeed.val+int1;

      if (ispeed.val<=ispeed.min) or (ispeed.val>=ispeed.max) then xsetstate2(ci,1,0);
      end;

   if xbox__yclick(ci) then ivol.val:=100;
   if xbox__xclick(ci) then ispeed.val:=100;

   if xbox__lbclick(ci) then showplaylist:=not showplaylist;
   if xbox__rbclick(ci) then
      begin
      if (gui.state='f') then gui.state:=ilaststate
      else
         begin
         ilaststate:=gui.state;
         gui.state:='f';
         end;
      end;

   if xbox__aclick(ci) then
      begin
      if showplaylist then
         begin
         //nil
         end
      else inav.click__list;
      end;

   if xbox__backclick(ci) then ijump.jumpto(ci);

   if xbox__startclick(ci) then
      begin
      if (imode.val<imode.max) then imode.val:=imode.val+1 else imode.val:=0;
      end;

   if xbox__lsclick(ci) then xlogicmap(ishownav,ishowpiano);
   if xbox__rsclick(ci) then xlogicmap(ishowinfo,ishowvis);
   end;
end;//ci

end;

function tapp.__oninfo(sender:tobject;xindex:longint;var xtab:string;var xtep,xtepcolor:longint;var xcaption,xcaplabel,xhelp,xcode2:string;var xcode,xshortcut,xindent:longint;var xflash,xenabled,xtitle,xsep,xbold:boolean):boolean;
var
   int1,p,xfileindex,xfilecount,xintro,xfilesize,xpos,xlen,xspeed,spos,slen,strim:longint;
   xerrmsg,str1:string;
   bol1,xhavefile:boolean;

   function xfilter(x,xdef:string):string;
   begin
   if xhavefile then result:=x else result:=xdef;
   end;

   function s(xcount:longint):string;
   begin
   result:=insstr('s',xcount<>1);
   end;

begin
result:=true;

try
//init
xtep           :=tepFNew20;
xtepcolor      :=clnone;
xcaption       :='';
xcaplabel      :='';
xhelp          :='';
xcode2         :='';
xcode          :=0;
xshortcut      :=aknone;
xindent        :=0;//xindex*5;
xflash         :=false;//25mar2021
xenabled       :=true;
xtitle         :=false;//(xindex=3);
xsep           :=false;
xhavefile      :=iisfile;
xlen           :=1;//safe default
xpos           :=0;
xspeed         :=100;
slen           :=1;//safe default
spos           :=0;
strim          :=0;
xintro         :=xintroms;
xfilesize      :=mid_midbytes;

if xhavefile then
   begin

   xlen      :=frcmin32(mid_len,1);
   xpos      :=mid_pos;
   xspeed    :=frcmin32(mid_speed,1);

   //speed adjusted values
   slen      := frcmin32(trunc( xlen*(100/xspeed) ),1);
   spos      := trunc( (xpos/xlen)*slen );
   strim     := trunc( (mid_lenfull-mid_len)*(100/xspeed) );
   end;

case showplaylist of
true:begin
   xfileindex:=ilist.itemindex;
   xfilecount:=ilist.count;
   end;
else
   begin
   xfileindex:=ifileindex;
   xfilecount:=ifilecount;
   end;
end;//case

//.info
case xindex of
//technical
0:begin
   xtep:=tepnone;
   xcaption:='Technical';
   xtitle:=true;
   end;

1:begin

   int1:=mid_handlecount;

   case mid_deviceactive of
   true:str1:='Online' +insstr('  ( '+k64(int1)+' device'+insstr('s',int1<>1)+' in use ) ',int1>=1);
   else str1:='Offline'+insstr(' - failed to open midi device', mid_playing and (mid_outdevicecount>=1) );
   end;//case

   xcaption:='Device Status'+#9+str1;

   end;

2:begin

   int1:=mid_outdevicecount;

   case (int1>=1) of
   true:str1:=k64(int1)+' midi playback device'+s(int1)+' present';
   else str1:='ERROR: No midi playback devices present - no sound';
   end;//case

   xcaption:='Device Count'+#9+str1;

   end;

3:begin

   xerrmsg  :=insstr(' ( '+mid_timermsg+' )',mid_timercode<>0);
   xcaption :='Resolution'+#9+curdec(mid_msrate,2,false)+' ms / '+curdec(mid_mspert100,1,false)+'%'+xerrmsg;//15aug2025, 05mar2022

   end;

4:xcaption:='Name'+#9+xfilter(io__extractfilename(ilastfilename),'-');
5:xcaption:='Folder'+#9+xfilter(io__extractfilepath(ilastfilename),'-');
6:xcaption:='Size'+#9+xfilter(low__b(xfilesize,true)+'  ( '+low__mb(xfilesize,true)+' )','-');
7:xcaption:='File'+#9+xfilter(k64(1+xfileindex)+' / '+k64(xfilecount),'-');

8:begin
   int1:=mid_format;
   case int1 of
   0:str1:='Single Track';
   1:str1:='Multi-Track';
   else str1:='Not Supported';
   end;
   xcaption:='Format'+#9+xfilter(intstr32(int1)+' / '+str1,'-');
   end;

9:xcaption:='Tracks'+#9+xfilter(k64(mid_tracks),'-');
10:xcaption:='Messages'+#9+xfilter(k64(mid_msgssent)+' / '+k64(mid_msgs),'-');
11:xcaption:='Msg Rate'+#9+k64(mid_msgrate)+' msgs/sec';
12:xcaption:='Data Rate'+#9+k64(mid_datarate)+' bytes/sec';//19aug2025

//playback
13:begin
   xtep:=tepnone;
   xcaption:='Playback';
   xtitle:=true;
   end;
14:xcaption:='Elapsed'+#9+low__uptime(spos,(slen>=3600000),(slen>=60000),true,true,true,#32);
15:xcaption:='Remaining'+#9+low__uptime(slen-spos,(slen>=3600000),(slen>=60000),true,true,true,#32);
16:xcaption:='Total'+#9+low__uptime(slen,(slen>=3600000),(slen>=60000),true,true,true,#32)+insstr(' ( '+curdec( (100/xspeed)*100 ,1,true)+'% )',slen<>xlen);
17:xcaption:='Trim'+#9+low__aorbstr('Off', low__uptime(strim,false,false,false,true,true,#32)+' of silence', mid_trimtolastnote );
18:xcaption:='Intro Mode'+#9+low__aorbstr('Off','First '+k64(xintro div 1000)+' seconds',xintro>0);
19:xcaption:='Speed'+#9+k64(mid_speed)+'%';
20:xcaption:='State'+#9+low__aorbstr('Stopped','Playing',mid_playing);
21:begin
   bol1:=false;
   if xbox__init then
      begin
      int1:=0;
      str1:='';

      for p:=0 to xbox__lastindex(false) do if xbox__info(p).connected then
         begin
         inc(int1);
         str1:=str1+insstr(' + ',str1<>'')+intstr32(p);
         bol1:=true;
         end;//p

      if (str1<>'') then str1:=' with controller'+insstr('s',int1>=2)+#32+str1;
      end
   else str1:='';

   xcaption:='Xbox Controller'+#9+low__aorbstr('Off',low__aorbstr('Offline','Online'+str1,bol1),ixboxcontroller>=1);
   end;
else
   begin
   xtep:=tepnone;
   end;
end;//case
except;end;
end;


//## toutput ###################################################################
constructor toutput.create(xparent:tobject);
var
   p:longint;
begin                 

//self
inherited create(xparent);

//controls
oautoheight   :=true;
ilastindex    :=min32;
itimersync    :=slowms64;
izerobase     :=true;
imidlistRef   :='';
xcols.style   :=bcLefttoright;//04feb2025

with xcolsh.makecol(0,100,false) do
begin

isel:=tbasicsel.create(client);
with isel do
begin
caption     :='Playback Device';
help        :='Midi Device|Select a midi device to edit its playback settings';
for p:=0 to high(tmidilist) do xadd(k64(1+p),intstr32(p),'Device #'+k64(1+p));

end;


ims:=tsimpleint.create(client);
with ims do
begin

caption     :='Time Shift';
ohelplabel  :='Time Shift|Shift playback timing to compensate for any audio lag on midi device';
ohelpbar    :=ohelplabel;
ounit       :=' ms';

setparams(-500,500,0,0);

end;


ivol:=tsimpleint.create(client);
with ivol do
begin

caption     :='Device Volume';
ohelplabel  :='Device Volume|Adjust volume level for midi device';
ohelpbar    :=ohelplabel;
ounit       :=' %';
setparams(0,200,100,100);

end;


ichs:=tbasicset.create(client);
with ichs do
begin

caption     :='Output Channels';
help        :='Output Channels|Select channels for playback on midi device';
itemsperline:=8;

for p:=0 to 15 do xset(p,intstr32(p),intstr32(p),'',false);

end;

end;//xhigh


end;

destructor toutput.destroy;
begin
try

//self
inherited destroy;

except;end;
end;

procedure toutput.setzerobase(x:boolean);
var
   p:longint;
begin

if low__setbol(izerobase,x) then
   begin

   for p:=0 to 15 do ichs.caps[p]:=intstr32(p+insint(1,not izerobase));

   end;

end;

procedure toutput.xsave(const xindex:longint);
var
   x:tmidiitem;
   vid,p:longint;
begin

//check
if (xindex<0) or (xindex>high(tmidilist)) then exit;

//init
low__cls(@x,sizeof(x));

//get
x.vol      :=ivol.val;
x.ms       :=ims.val;
for p:=0 to high(x.ch) do x.ch[p]:=ichs.vals[p];

vid        :=mid_itemsid;
mid_setitem(xindex,x);

//.save only when item changes
if (vid<>mid_itemsid) then mid_saveitem(xindex);

end;

procedure toutput.xload(const xindex:longint);
var
   x:tmidiitem;
   p:longint;
begin

//check
if (xindex<0) or (xindex>high(tmidilist)) then exit;

//get
x          :=mid_item(xindex);
ivol.val   :=x.vol;
ims.val    :=x.ms;
for p:=0 to high(x.ch) do ichs.vals[p]:=x.ch[p];

end;

procedure toutput._ontimer(sender:tobject);
var
   p,dindex,dcount:longint;
begin
try

if (slowms64>=itimersync) then
   begin

   //lock midi device list -> prevent from changing whilst we load/save items
   mid_devicelist_lockfromchanging(true);

   //change
   dcount        :=mid_devicecount;
   dindex        :=isel.val;

   //save current item settings OR reload ALL items due to midi device list change - 02nov2025
   case mid_devicelistHasChanged(imidlistRef,true) of
   true:begin

      for p:=0 to pred(dcount) do mid_loaditem(p);

      end;
   else xsave(ilastindex);//set current item
   end;

   //sync
   case (dindex<dcount) of
   true:isel.caption  :='Playback Device ( '+k64(frcmax32(isel.val+1,dcount))+' / '+k64(dcount)+' ): '+mid_devicename(isel.val,'#'+k64(1+isel.val));
   else isel.caption  :='Playback Device: No device on slot';
   end;//case

   //load
   xload(dindex);
   ilastindex:=dindex;

   //unlock
   mid_devicelist_lockfromchanging(false);

   //reset
   itimersync:=add64(slowms64,300);

   end;

except;end;
end;


//## tchannels #################################################################
constructor tchannels.create(xparent:tobject);
begin
create2(xparent,true);
end;

constructor tchannels.create2(xparent:tobject;xstart:boolean);
var
   p:longint;
begin
//self
if classnameis('tchannels') then track__inc(satOther,1);
inherited create2(xparent,false);
//vars
oroundstyle        :=corNone;
oautoheight        :=true;
oflat              :=false;
odelayMS           :=50;//01feb2026
hint               :='Midi Channel | Click to mute/unmute midi channel | Drag up or down to adjust channel volume';
ipainttimer        :=slowms64;
iflashtimer        :=slowms64;
iflashtimer2       :=slowms64;
ihoverfocus        :=0;
iflashon           :=false;
iflashon2          :=false;
idownindex         :=-1;
ihoverindex        :=-1;
ilasthoverindex    :=-2;
idataref           :=0;
iclsref            :='';
itemp              :=str__new8;
itemp.floatsize    :=500;//keeps internal buffer static
iup                :=true;
izerobase          :=true;
ialign             :=2;
ishowlabels        :=true;
idowny             :=0;
ivolstarty         :=0;
ivolheight         :=0;
ivolbarheight      :=0;

findhold(-1,ihold,iholdms);//default hold


//.zero memory
low__cls(@iarea,sizeof(iarea));
low__cls(@iavevol,sizeof(iavevol));
low__cls(@iholdvol,sizeof(iholdvol));
low__cls(@ihold64,sizeof(ihold64));
low__cls(@ivoice,sizeof(ivoice));
low__cls(@ivoiceref,sizeof(ivoiceref));
low__cls(@ivoicetime,sizeof(ivoicetime));
low__cls(@ilabel,sizeof(ilabel));

for p:=0 to high(iavevol) do
begin

ivoice[p]     :=min32;
iarea[p]      :=nilarea;
ilabel[p]     :=misimg32(1,1);
ilabelref[p]  :='';
ichangeref[p] :='';

end;//p

xclear;

//start
if xstart then start;

end;

destructor tchannels.destroy;
var
   p:longint;
begin
try

//controls
for p:=0 to high(iavevol) do freeobj(@ilabel[p]);
str__free(@itemp);

//self
inherited destroy;
if classnameis('tchannels') then track__inc(satOther,-1);
except;end;
end;

function tchannels.findhold(xindex:longint;var xoutindex,xoutms:longint):boolean;

   procedure s(const dms:longint);
   begin
   result     :=(dms>=0);
   xoutindex  :=xindex;
   xoutms     :=frcmin32(dms,0);
   end;

begin

case xindex of
0    :s(0);
1    :s(500);
2    :s(1000);
3    :s(2000);
4    :s(3000);
5    :s(4000);
6    :s(5000);
7    :s(10000);//10 sec
8    :s(30000);//30 sec
9    :s(60000);//60 sec
else
   begin

   xindex:=4;
   s(3000);
   result:=false;

   end;
end;//case

end;

procedure tchannels.sethold(xindex:longint);
begin
findhold(xindex,ihold,iholdms);
end;

procedure tchannels.setalign(x:longint);
begin
ialign:=frcrange32(x,0,2);
end;

procedure tchannels.xclear;
var
   p:longint;
begin

for p:=0 to high(iavevol) do
begin

iavevol[p]       :=0;
iholdvol[p]      :=0;
ihold64[p]       :=0;
ivoice[p]        :=min32;
ivoiceref[p]     :=-1;
ivoicetime[p]    :=0;

end;//p

end;

procedure tchannels.muteall(xmute:boolean);
var
   p:longint;
begin
mid_enter1;

for p:=0 to high(mmsys_mid_chvol) do
begin

case xmute of
true:if (mmsys_mid_chvol[p]>0) then mmsys_mid_chvol[p]:=-mmsys_mid_chvol[p];
else if (mmsys_mid_chvol[p]<0) then mmsys_mid_chvol[p]:=-mmsys_mid_chvol[p];
end;//case

end;//p

mid_leave1;
end;

function tchannels.xmoretime:boolean;
begin

result      :=(slowms64>ihoverfocus);
ihoverfocus :=add64(slowms64,3000);

end;

procedure tchannels.moreVols(xby:longint);
var
   p:longint;
begin

mid_enter1;

for p:=0 to high(mmsys_mid_chvol) do
begin

case (mmsys_mid_chvol[p]>=0) of
true:mmsys_mid_chvol[p]:=frcrange32(mmsys_mid_chvol[p]+xby,0,200);
else mmsys_mid_chvol[p]:=frcrange32(mmsys_mid_chvol[p]-xby,-200,0);
end;//case

end;//p

xmoretime;

mid_leave1;

end;

procedure tchannels.resetVols;
var
   p:longint;
begin

mid_enter1;

for p:=0 to high(mmsys_mid_chvol) do mmsys_mid_chvol[p]:=100;

xmoretime;

mid_leave1;

end;

function tchannels.xcalc:boolean;
var
   v,vvalue,vcount,vave,xchannel,xnote:longint;
   xinfo:tmidinote;
   v64,xmax64,xhold64:comp;
   xmuted,xplaying:boolean;
begin

//defaults
result    :=false;
xplaying  :=mid_playing;
v64       :=slowms64;

if xplaying     then xmax64  :=add64(v64,iholdms) else xmax64   :=0;
if (iholdms<=0) then xhold64 :=0                  else xhold64  :=add64(v64,iholdms);

try

//get
for xchannel:=0 to 15 do
begin

vvalue :=0;
vcount :=0;
xmuted :=(mmsys_mid_chvol[xchannel]<=0);

//.calculate average volume for channel
for xnote:=0 to 127 do if mid_trackinginfo(xchannel,xnote,xinfo) then
   begin

   case xmuted of
   true:begin

      if (not xinfo.mutedByTrack) and (xinfo.volOUTUNMUTED>=1) and (xinfo.timeOUTUNMUTED>=v64) then
         begin

         inc(vcount);
         inc(vvalue,xinfo.volOUTUNMUTED);

         end;

      end;
   else begin

      if (xinfo.volOUT>=1) and (xinfo.timeOUT>=v64) then
         begin

         inc(vcount);
         inc(vvalue,xinfo.volOUT);

         end;

      end;
   end;//case

   end;//xnote

//average volume for channel
vave     :=frcrange32( round( (vvalue/frcmin32(vcount,1)) ),0,127);

//control rise and fall
if      (vave>iavevol[xchannel]) then vave:=(vave*5 + iavevol[xchannel] ) div 6 //fast rise
else if (vave<iavevol[xchannel]) then vave:=(vave + 4*iavevol[xchannel] ) div 5;//slow fall

vave:=frcrange32(vave,0,127);

ihold64[xchannel]:=frcrange64(ihold64[xchannel],0,xmax64);//enforce maximum hold range

if (vave>iholdvol[xchannel]) or (v64>=ihold64[xchannel]) then
   begin
   iholdvol[xchannel] :=vave;
   ihold64[xchannel]  :=xhold64;
   end;

iavevol[xchannel]     :=vave;

//not playing
if not xplaying then ivoicetime[xchannel]:=0;

//detect change
if low__setstr(ichangeref[xchannel], bolstr(iflashon2)+bolstr(xplaying)+bolstr(ivoicetime[xchannel]>=v64)+bolstr((ivoice[xchannel]<>mmsys_mid_voiceindex[xchannel]))+bolstr(oflat)+bolstr(mmsys_mid_chvol[xchannel]<0)+bolstr( (iholdvol[xchannel]>=1) and iflashon )+'|'+intstr32(iavevol[xchannel])+'|'+intstr32(iholdvol[xchannel]) ) then
   begin

   if (ivoice[xchannel]<>mmsys_mid_voiceindex[xchannel]) then
      begin

      ivoice[xchannel]:=mmsys_mid_voiceindex[xchannel];

      case low__setint(ivoiceref[xchannel],mmsys_mid_dataref) of
      false:if xplaying then ivoicetime[xchannel]:=slowms64+2000;
      end;//case

      end;

   result              :=true;

   end;

end;//xchannel

//hoverindex
if low__setint(ilasthoverindex,ihoverindex) then result:=true;

except;end;
end;

procedure tchannels._ontimer(sender:tobject);
var
   p:longint;
   bol1:boolean;
begin

if not xcanpaint then exit;

//flash timer
if (slowms64>=iflashtimer) then
   begin

   iflashon:=not iflashon;

   iflashtimer:=slowms64+200;

   end;

//flash timer2
if (slowms64>=iflashtimer2) then
   begin

   iflashon2:=not iflashon2;

   iflashtimer2:=slowms64+low__aorb(1000,500,mid_playing);

   end;

//paint timer
if (slowms64>=ipainttimer) then
   begin

   if low__setint(idataref,mmsys_mid_dataref) then xclear;

   if xcalc or (ihoverfocus>=slowms64) then
      begin

      app__turbo;//faster response time
      paintnow;

      end;

   //reset
//   ipainttimer:=slowms64+odelayMS;
   ipainttimer:=slowms64+frcmin32(odelayMS,25);//~40fps

   end;
end;

function tchannels.getsettings:string;//21aug2025
var
   p:longint;

   procedure a(const x:string);
   begin
   result:=result+x+';';
   end;

begin

result:='';
for p:=0 to high(mmsys_mid_chvol) do a(intstr32( mmsys_mid_chvol[p] ));

a(low__aorbchar('0','1',iup));//0..1
a(char(nn0+ialign));//0..2
a(low__aorbchar('0','1',ishowlabels));

end;

procedure tchannels.setsettings(x:string);
var
   lp,xpos,xlen,p:longint;
   str1:string;

   function xpullval(var xval:string):boolean;
   label
      redo;
   begin

   //defaults
   result :=false;
   xval   :='';

   //check
   if (xpos>=xlen) then exit;

   //get
   redo:

   if (x[xpos-1+stroffset]=';') then
      begin

      result :=true;
      xval   :=strcopy1(x,lp,xpos-lp);
      lp     :=xpos+1;

      end;

   //loop
   inc(xpos);
   if (xpos<=xlen) and (not result) then goto redo;

   end;

   function xpullval2(xdef:string):string;
   begin

   xpullval(result);
   if (result='') then result:=xdef;

   end;

begin

//init
xlen  :=low__len32(x);
xpos  :=1;
lp    :=xpos;

//get
mid_enter1;

for p:=0 to high(mmsys_mid_chvol) do if xpullval(str1) then mmsys_mid_chvol[p]:=frcrange32(strint32(str1),-200,200) else break;

mid_leave1;

iup         :=strbol( xpullval2('1') );//up
align       :=strint32( xpullval2('2') );//bottom
ishowlabels :=strbol( xpullval2('1') );//on

end;

function tchannels.xyTOpert200(sy:longint;var xpert200:longint):boolean;
begin

result:=(ivolheight>=1) and (ivolbarheight>=1);
if result then
   begin

   xpert200:=200-frcrange32( trunc( ((sy-ivolstarty)/ivolheight)*200 ) ,0,200);

   end;

end;

function tchannels.xpert200TOy(xpert200:longint):longint;
begin

if (ivolheight>=1) and (ivolbarheight>=1) then
   begin

   xpert200 :=frcrange32( low__posn(xpert200), 0,200);
   result   :=trunc( ivolheight*((200-xpert200)/200) ) + ivolstarty;

   end
else result:=0;

end;

procedure tchannels.xbar(const s:tclientinfo;const da:twinrect;xindex,xvol,xholdvol,fn,fnH,xfeather:longint;const xround:boolean);
const
   xcolmix=0.70;
var
   xtmp,vx,p,p2,fnH1,xsp,aw,xfontcolor,dcol2,dcol,ch,int1,dalign,dx,dy,xback,tw:longint;
   xhoverfocus,xdownok,xhoverok,xmax:boolean;
   ta:twinrect;
   t:string;
   xcolors:tpoint;

   function v(xvol:longint):longint;
   begin
   result:=round((frcrange32(xvol,0,127)/127)*clientheight);
   end;

   procedure xdraw(xfrom,xto,xmoreheight:longint;const dcolors:tpoint;const xsplice:longint;const xcolorboost:boolean);
   var
      dback,i,sy,dy,dy2:longint;
   begin

   //check
   if (xto<xfrom) then exit;

   //get
   sy:=frcrange32(da.bottom-round( (xfrom/127)*ch),da.top,da.bottom);
   dy:=frcrange32(da.bottom-round( (xto  /127)*ch),da.top,da.bottom);

   case oflat of
   true:ffillArea(area__make(da.left,dy,da.right,frcmax32(sy+xmoreheight,da.bottom)),dcolors.y,xround);
   else
      begin

      dy2:=frcmax32(sy+xmoreheight,da.bottom);

      fshadeArea2(area__make(da.left,dy,da.right,dy2),dcolors.x,dcolors.y,dcolors.y,dcolors.x,xsplice,255,xround);

      //.color boost for small areas
      if xcolorboost then ffillArea(area__make(da.left,dy+((dy2-dy+1) div 2),da.right,dy+((dy2-dy+1) div 2)),dcolors.y,xround);

      end;
   end;//case

   end;
begin

//range
xvol          :=frcrange32(xvol     ,0,127);
xholdvol      :=frcrange32(xholdvol ,0,127);


//init
xback         :=s.hover;
xcolors       :=s.colhover2;
xfontcolor    :=s.font;
ch            :=da.bottom-da.top+1;
xdownok       :=(xindex=idownindex);
xhoverok      :=(xindex=ihoverindex);
xhoverfocus   :=(ihoverfocus>=slowms64);
fnH1          :=low__fontmaxh1(fn);

ivolstarty    :=da.top;
ivolbarheight :=round(fnH*1.3);
ivolheight    :=frcmin32(da.bottom-da.top+1-ivolbarheight,1);


//background
if (mmsys_mid_chvol[xindex]<=0) then
   begin

   xback      :=int__splice24(0.25,int__greyscale(xback),255);
   xfontcolor :=int__splice24(0.25,xfontcolor,255);
   xcolors.x  :=int__splice24(0.35,int__greyscale(xcolors.x),255);
   xcolors.y  :=int__splice24(0.35,int__greyscale(xcolors.y),255);

   end;

ffillArea(da,xback,false);

//volume indicator
if (xvol>=1) then xdraw(0,xvol,0,xcolors,5,false);


//hold volume indicator
if (xholdvol>=1) and (iholdms>=1) then
   begin

   xmax:=(xholdvol>=125);

   case xholdvol of
   101..110     :xcolors.y:=int__splice24( xcolmix, xcolors.x, rgba0__int(255,255,0) );
   111..maxint  :xcolors.y:=low__aorb(int__splice24( xcolmix, xcolors.x, 255), xback, xmax and iflashon );
   end;//case

   xdraw(xholdvol-2,xholdvol,insint(1,not oflat),xcolors,50,not oflat);

   end;

//label
if (mmsys_mid_chvol[xindex]<=0) and iflashon2 then t:='m' else t:=intstr32( xindex + insint(1,not izerobase) );

tw         :=low__fonttextwidth2(fn,t);
ta.left    :=da.left+((da.right-da.left+1-tw) div 2)-2;
ta.right   :=ta.left+tw-1+4;
ta.top     :=da.bottom-fnH;
ta.bottom  :=ta.top+fnH-1;

if (ivoicetime[xindex]>=slowms64) and iflashon then
   begin

   ffillArea(ta,xfontcolor,false);
   int1:=xback;

   end
else
   begin

   case xhoverfocus of
   true:int1:=int__splice24_100(40,xfontcolor,s.hover2);
   else int1:=xfontcolor;
   end;//case

   end;

ldtTAB2(xback,tbnone,da,da.left+((da.right-da.left+1-tw) div 2),da.bottom-fnH,int1,t,fn,xfeather,false,false,false,false,false);


//name of voice/instrument
dy:=da.top+1;

//create voice label
if low__setstr(ilabelref[xindex],bolstr(iup)+'|'+intstr32(xfontcolor)+'|'+intstr32(ialign)+'|'+intstr32(vidataid)+'|'+intstr32(ivoice[xindex])+'|'+intstr32(fn)+'|'+intstr32(fnH)+'|'+intstr32(da.right-da.left+1)+'|'+intstr32(da.bottom-da.top+1)) then
   begin

   //reset image
   missize(ilabel[xindex],da.bottom-da.top+1-fnH-3,da.right-da.left+1);
   mis__cls(ilabel[xindex],0,0,0,0);


   //init
   t           :=strdefb( mid_voicename(ivoice[xindex]), '-');
   itemp.text  :=t;
   ta          :=misarea(ilabel[xindex]);
   tw          :=low__fonttextwidth2(fn,t);;

   //.align
   dalign:=frcrange32(ialign,0,2);

   if iup then
      begin

      case dalign of
      0:dalign:=2;
      2:dalign:=0;
      end;//case

      end;

   case dalign of
   0:dx:=4*vizoom;
   1:dx:=((ta.right-ta.left+1)-tw) div 2;
   2:dx:=ta.right-tw-1;
   else dx:=4*vizoom;
   end;//case

   dy          :=(ilabel[xindex].height-fnH) div 2;

   //text -> do not use feather
   low__draw2b(clnone,true,'',misb(ilabel[xindex]),ilabel[xindex].width,ilabel[xindex].height,ilabel[xindex].rows,nil,nil,0,'t',ta,ta,ta,xfontcolor,xfontcolor,clnone,dx,dy,0,0,0,0,0,sysfont_data[fn],itemp,corRound,xround,false,false,false,false);

   //rotate 90
   mis__rotate82432(ilabel[xindex],low__aorb(90,-90,iup));

   end;


if ishowlabels then
   begin

   ldc32(da,da.left,da.top,misw(ilabel[xindex]),mish(ilabel[xindex]),misarea(ilabel[xindex]),ilabel[xindex],low__aorb(255,100,xhoverfocus),true);

   end;


//volume adjustment indicator
xsp   :=2*vizoom;
aw    :=3*vizoom;
dcol  :=xfontcolor;
int1  :=frcrange32( xpert200TOy( mmsys_mid_chvol[xindex] ), da.top, da.bottom );


xtmp:=frcrange32(low__posn(mmsys_mid_chvol[xindex]),0,200);
case xtmp of
0..120   :dcol2:=int__splice24_100(trunc(20*(xtmp/120)),s.hover2,rgba0__int(0,255,0));
121..160 :dcol2:=int__splice24_100(20,s.hover2,rgba0__int(255,255,0));
161..200 :dcol2:=int__splice24_100(insint(20,iflashon or (xtmp<=190)),s.hover2,255);
end;//case

//.cls background area -> make more visible over label and shade
if xhoverfocus then
   begin

   case oflat of
   true:ffillArea( area__make(da.left,int1,da.right,frcmax32(int1+ivolbarheight,da.bottom) ), dcol2, false );
   else fshadeArea2( area__make(da.left,int1,da.right,frcmax32(int1+ivolbarheight,da.bottom) ), s.hover, dcol2, dcol2, s.hover, 50, 255, false );
   end;//case

   end;

//.left level arrow
vx  :=int1+(ivolbarheight div 2);
if (vizoom>=2) then inc(vx,(fnH-fnH1) div 2);

if xhoverfocus and iflashon and ((idownindex=xindex) or (ihoverindex=xindex)) then
   begin

   for p:=0 to (aw-1) do
   begin

   p2:=aw-1-p;
   ffillArea(area__make(da.left,vx-p2,da.left+p,vx-p2),dcol,false);
   ffillArea(area__make(da.left,vx+p2,da.left+p,vx+p2),dcol,false);

   end;//p

   end;

//.text label
if xhoverfocus then
   begin

   ffillArea(area__make(da.left,int1,da.right,int1),s.hover2,false);
   ffillArea(area__make(da.left,int1+ivolbarheight-1,da.right,int1+ivolbarheight-1),s.hover2,false);

   t          :=intstr32(low__posn(mmsys_mid_chvol[xindex]));
   tw         :=low__fonttextwidth2(fn,t);
   ldt1(xback,da,da.left+frcmin32((da.right-da.left+1-tw) div 2,aw),int1+((ivolbarheight-fnH1) div 2),xfontcolor,t,fn,xfeather,false);

   end;

end;

procedure tchannels._onpaint(sender:tobject);
var
   s:tclientinfo;
   da:twinrect;
   sp,fn2,fnH2,p,iw:longint;
begin
try
//init
infovars(s);

//.smaller font
gui__smallfont2(info^,1.01,fn2,fnH2);


//background
if low__setstr(iclsref,intstr32(s.back)+'|'+intstr32(s.cs.right-s.cs.left+1)+'|'+intstr32(s.cs.bottom-s.cs.top+1)) then ffillArea(s.cs,s.back,false);

//init
iw         :=frcmin32(s.cw div 16,1);
sp         :=frcmin32(frcmax32(5*s.zoom,iw-low__fontavew(s.fn)),0);

//bars
for p:=0 to high(iavevol) do
begin

da.top     :=s.ci.top;
da.bottom  :=s.ci.bottom;
da.left    :=s.ci.left+(p*iw);
da.right   :=frcmax32(da.left+iw-1-sp,s.ci.right);

xbar(s,da,p,iavevol[p],iholdvol[p],fn2,fnH2,s.f,s.r);

//.store area for mouse clicks
iarea[p]   :=da;

end;//p

except;end;
end;

function tchannels.xfindarea(x,y:longint;var xindex:longint):boolean;
var
   p:longint;
begin
//defaults
result:=false;
xindex:=0;

for p:=0 to high(iarea) do if (x>=iarea[p].left) and (x<=iarea[p].right) and (y>=iarea[p].top) and (y<=iarea[p].bottom) then
   begin
   xindex:=p;
   result:=true;
   break;
   end;
end;

function tchannels._onnotify(sender:tobject):boolean;
var
   int1:longint;
   xmustpaint:boolean;
begin

//defaults
result     :=false;
xmustpaint :=false;

try
//hover
if not xfindarea(mousemovexy.x,mousemovexy.y,ihoverindex) then ihoverindex:=-1;
if xmoretime                                              then xmustpaint:=true;

//wheel
if (gui.wheel<>0) and (ihoverindex>=0) and (ihoverindex<=high(mmsys_mid_chvol)) then
   begin

   mid_enter1;

   int1:=frcrange32( low__posn(mmsys_mid_chvol[ihoverindex])-gui.wheel, 0,200);

   case (mmsys_mid_chvol[ihoverindex]>=0) of
   true:mmsys_mid_chvol[ihoverindex]:=int1;
   else mmsys_mid_chvol[ihoverindex]:=-int1;
   end;

   mid_leave1;

   xmustpaint:=true;
   
   end;

//mouse down
if gui.mousedownstroke then
   begin

   if not xfindarea(mousedownxy.x,mousedownxy.y,idownindex)   then idownindex:=-1;
   if (idownindex>=0) and (idownindex<=high(mmsys_mid_chvol)) then idowny:=xpert200toy(mmsys_mid_chvol[idownindex]) else idowny:=0;

   end;

//mouse move
if gui.mousemoved and gui.mousedraggingfine then
   begin

   if (idownindex>=0) and (idownindex<=high(mmsys_mid_chvol)) and xyTOpert200( idowny +(mousemovexy.y-mousedownxy.y), int1 ) then
      begin

      //get
      mid_enter1;
      if (mmsys_mid_chvol[idownindex]<0) then mmsys_mid_chvol[idownindex]:=-int1 else mmsys_mid_chvol[idownindex]:=int1;
      mid_leave1;

      //repaint
      xmustpaint:=true;

      end;

   end;

//mouse up
if gui.mouseupstroke and (idownindex>=0) and (idownindex<=high(mmsys_mid_chvol)) then
   begin

   if (not gui.mousedraggingfine) then
      begin
      mid_enter1;
      if (mousedownxy.y<idowny) or (mousedownxy.y>=(idowny+ivolbarheight)) then mmsys_mid_chvol[idownindex]:=-mmsys_mid_chvol[idownindex];
      mid_leave1;
      end;

   //reset
   if low__setint(idownindex,-1) then xmustpaint:=true;

   end;

//paint
if xmustpaint then paintnow;

except;end;
end;

//## ttracks ###################################################################
constructor ttracks.create(xparent:tobject);
begin
create2(xparent,true);
end;

constructor ttracks.create2(xparent:tobject;xstart:boolean);
var
   p:longint;
begin
//self
if classnameis('ttracks') then track__inc(satOther,1);
inherited create2(xparent,false);
//vars
hint:='Midi Track | Click to mute/unmute midi track | Click and hold for 2 seconds to mute/unmute all midi tracks';

oflat            :=false;
odelayMS         :=50;//01feb2026
ilastheight      :=0;
ilasttrackcount  :=-1;
iitemsperrow     :=16;
ipainttimer      :=slowms64;
iflashtimer2     :=slowms64;
iflashon2        :=false;
idownindex       :=-1;
idowntimed       :=false;
idataref         :=0;
iinforef         :='';
iclsref          :='';

for p:=0 to high(iarea) do iarea[p]:=nilarea;

xclear;

//start
if xstart then start;
end;

destructor ttracks.destroy;
begin
try
inherited destroy;
if classnameis('ttracks') then track__inc(satOther,-1);
except;end;
end;

procedure ttracks.xclear;
begin

low__cls(@iref,sizeof(iref));
low__cls(@iflash,sizeof(iflash));
low__cls(@itime,sizeof(itime));

end;

function ttracks.xcalc:boolean;
var
   xtrack,xcount:longint;
begin
//defaults
result    :=false;
xcount    :=frcmin32(otrackcount,1);

for xtrack:=0 to high(iarea) do
begin

if (xtrack<xcount) then
   begin

   //track has played data
   if low__setcmp(itime[xtrack],mmsys_mid_tracking.tracks[xtrack].time) then
      begin

      iflash[xtrack]       :=not iflash[xtrack];
      result               :=true;

      end;

   //ref changed
   if (iref[xtrack].bytes[0]<>low__aorb(0,1,iflashon2 and mmsys_mid_mutetrack[xtrack])) then
      begin

      iref[xtrack].bytes[0]  :=low__aorb(0,1,iflashon2 and mmsys_mid_mutetrack[xtrack]);
      result                 :=true;

      end;

   end
else iref[xtrack].val:=0;

end;//p

if low__setint(ilasttrackcount,xcount) then result:=true;
if low__setint(ilastheight,getalignheight(0)) then gui.fullalignpaint;
end;

procedure ttracks.muteall(xmute:boolean);
var
   p:longint;
begin
mid_enter1;
for p:=0 to high(mmsys_mid_mutetrack) do mmsys_mid_mutetrack[p]:=xmute;
mid_leave1;
end;

procedure ttracks._ontimer(sender:tobject);
var
   p:longint;
   bol1:boolean;
begin

if not xcanpaint then exit;

//flash timer2
if (slowms64>=iflashtimer2) then
   begin

   iflashon2:=not iflashon2;

   iflashtimer2:=slowms64+low__aorb(1000,500,mid_playing);

   end;

//toggle mute
if (idownindex>=0) and (idownindex<=high(mmsys_mid_mutetrack)) and focused and (not idowntimed) and gui.mousedown and (gui.mousedowntime>=2000) then
   begin
   idowntimed:=true;
   bol1:=not mmsys_mid_mutetrack[idownindex];

   mid_enter1;
   for p:=0 to high(mmsys_mid_mutetrack) do mmsys_mid_mutetrack[p]:=bol1;
   mid_leave1;

   end;

//paint timer
if (slowms64>=ipainttimer) then
   begin
   if low__setint(idataref,mmsys_mid_dataref) then xclear;

   if xcalc then
      begin
      paintnow;
      app__turbo;
      end;

   //reset
   //ipainttimer:=slowms64+odelayMS;
   ipainttimer:=slowms64+frcmin32(odelayMS,17);//~60fps

   end;

end;

function ttracks.xtrackcount:longint;
begin
result:=frcrange32(otrackcount,1,high(iarea)+1);
end;

function ttracks.xrowcount:longint;
begin

result:=xtrackcount div iitemsperrow;

if ((result*iitemsperrow)<xtrackcount) then inc(result);

result:=frcmin32(result,2);//display 2 or more rows for visual padding

end;

function ttracks.xrowheight(xclientheight:longint):longint;//11dec2025
begin

case (xclientheight<=0) of
true:result:=virowheight20orLESS;
else result:=frcmin32( (xclientheight div xrowcount) ,1);
end;//case

end;

function ttracks.getalignheight(xclientwidth:longint):longint;
begin
result:=(xrowcount*xrowheight(0)) + (2*vizoom);
end;

function ttracks.xfindarea(x,y:longint;var xindex:longint):boolean;
var
   p:longint;
begin
//defaults
result:=false;
xindex:=0;

for p:=0 to high(iarea) do if (x>=iarea[p].left) and (x<=iarea[p].right) and (y>=iarea[p].top) and (y<=iarea[p].bottom) then
   begin
   xindex:=p;
   result:=true;
   break;
   end;
end;

function ttracks.getsettings:string;
var
   p:longint;
begin
low__setlen(result,high(mmsys_mid_mutetrack)+1);
for p:=0 to high(mmsys_mid_mutetrack) do result[p+stroffset]:=low__aorbchar('0','1',mmsys_mid_mutetrack[p]);
end;

procedure ttracks.setsettings(x:string);
var
   p:longint;
begin
if (x<>'') then
   begin

   mid_enter1;
   for p:=0 to frcmax32(high(mmsys_mid_mutetrack),low__len32(x)-1) do mmsys_mid_mutetrack[p]:=(x[p+stroffset]='1');//zero-based string access
   mid_leave1;

   end;
end;

function ttracks._onnotify(sender:tobject):boolean;
begin
//defaults
result:=false;

try
//mouse down
if gui.mousedownstroke then
   begin
   idowntimed:=false;
   if not xfindarea(mousedownxy.x,mousedownxy.y,idownindex) then idownindex:=-1;
   end;

//mouse up
if gui.mouseupstroke and (idownindex>=0) and (idownindex<=high(mmsys_mid_mutetrack)) then
   begin
   if idowntimed then
      begin
      //ignore
      end
   else
      begin

      mid_enter1;
      mmsys_mid_mutetrack[idownindex]:=not mmsys_mid_mutetrack[idownindex];
      mid_leave1;

      end;
   end;
except;end;
end;

procedure ttracks._onpaint(sender:tobject);
label
   skipend;
const
   xby=8;
var
   s:tclientinfo;
   v64:comp;
   xhover2:longint;
   da:twinrect;
   t:string;
   dtrackcount,fn2,fnH2,sp,tw,dcount,dperrow,dx,dy,dw,dh,xtrack:longint;
   dcback,dc,dfont2,dmute0,dmute1,dmute2,bkmute,dhover0,dhover1,dhover2:longint;
   dtrackon:boolean;
begin
try

//init
infovars(s);
dtrackcount :=frcrange32(otrackcount,0,1+high(iarea));
v64         :=slowms64;

gui__smallfont(info^,fn2,fnH2);

dmute0      :=int__splice24(0.35,int__greyscale(s.colhover2.x),255);
dmute1      :=int__splice24(0.45,int__greyscale(s.colhover2.y),255);
dmute2      :=int__splice24(0.65,int__greyscale(s.colhover2.y),255);
bkmute      :=int__splice24(0.15,int__greyscale(s.colhover2.x),255);

dhover0     :=int__splice24(0.45,s.colhover2.y,s.colhover2.x);
dhover1     :=int__splice24(0.35,s.colhover2.y,s.colhover2.x);
dhover2     :=s.colhover2.y;

dfont2      :=int__splice24(0.15,s.font,255);

//background
if low__setstr(iclsref,intstr32(dtrackcount)+'|'+intstr32(s.back)+'|'+intstr32(s.hover)+'|'+intstr32(s.colhover)+'|'+intstr32(s.cw)+'|'+intstr32(s.ch)) then
   begin
   ffillArea(s.cs,s.back,false);
   end;

if (dtrackcount<=0) then goto skipend;

//init
sp:=2*s.zoom;
dperrow:=frcmin32(iitemsperrow,1);
dh:=frcmin32( xrowheight(s.ch)-sp ,1);
dw:=frcmin32( (s.cw div dperrow)-sp ,1);

//boxes
dcount:=0;
dx:=sp+(dcount*(dw+sp));
dy:=sp;

for xtrack:=0 to (dtrackcount-1) do
begin
da.top        :=dy;
da.bottom     :=dy+dh-1;
da.left       :=dx;
da.right      :=dx+dw-1;
iarea[xtrack] :=da;
dtrackon      :=(itime[xtrack]>=v64);

if mmsys_mid_mutetrack[xtrack] and iflashon2 then t:='m'
else                                              t:=intstr32(1+xtrack);


//track muted
if mmsys_mid_mutetrack[xtrack] then
   begin

   if dtrackon   then dc:=low__aorb(dmute1,dmute2,iflash[xtrack])
   else               dc:=dmute0;

   dcback               :=bkmute;

   end
//track on
else if dtrackon then
   begin

   if dtrackon  then dc:=low__aorb(dhover1,dhover2,iflash[xtrack])
   else              dc:=dhover0;

   dcback              :=s.colhover2.x;

   end
//dtrackon off
else
   begin

   dc                  :=s.hover2;
   dcback              :=s.back;

   end;

//erase "non-outline"
ffillArea(area__make(da.left,da.bottom-(2*vizoom),da.right,da.bottom),s.back,s.r);

//highlight
case oflat of
true:ffillArea(da,dc,s.r);
else fshadeArea2(da,dcback,dc,dc,dcback,50,255,s.r);
end;//case

tw:=low__fonttextwidth2(fn2,t);

ldt1(s.back,da,da.left+((da.right-da.left+1-tw) div 2),da.top+((da.bottom-da.top+1-fnH2) div 2),low__aorb(s.font,dfont2,mmsys_mid_mutetrack[xtrack]),t,fn2,s.f,s.r);

//inc
inc(dcount);
if (dcount>=dperrow) then
   begin
   dcount:=0;
   dx:=sp;
   inc(dy,dh+sp);
   end
else inc(dx,dw+sp);
end;//p

skipend:
except;end;
end;

//## tnotes ####################################################################
constructor tnotes.create(xparent:tobject);
begin
create2(xparent,true);
end;

constructor tnotes.create2(xparent:tobject;xstart:boolean);
var
   p:longint;
begin
//self
if classnameis('tnotes') then track__inc(satOther,1);
inherited create2(xparent,false);
//vars
hint:='Midi Note | Click to mute/unmute midi note | Click and hold for 2 seconds to mute/unmute all midi notes';

//oroundstyle:=corNone;
ooutline     :=false;
odelayMS     :=50;//01feb2026
izerobase    :=true;
iflashon     :=false;
oflat        :=false;
olayout      :=0;
olabels      :=false;
iholdtimer   :=slowms64;
ipainttimer  :=slowms64;
iflashtimer  :=slowms64;
idownindex   :=-1;
idowntimed   :=false;
idataref     :=0;
iref         :=-1;
iinforef     :='';
iclsref      :='';
findhold(-1,ihold,iholdms);//default hold

for p:=0 to high(iflash) do
begin
iarea[p]   :=nilarea;
ilabels[p] :=xmakelabel(p);
iflash[p]  :=false;
end;//p

xclear;

//start
if xstart then start;
end;

destructor tnotes.destroy;
begin
try
inherited destroy;
if classnameis('tnotes') then track__inc(satOther,-1);
except;end;
end;

function tnotes.findhold(xindex:longint;var xoutindex,xoutms:longint):boolean;

   procedure s(const dms:longint);
   begin
   result     :=(dms>=0);
   xoutindex  :=xindex;
   xoutms     :=frcmin32(dms,0);
   end;

begin

case xindex of
0    :s(0);
1    :s(500);
2    :s(1000);
3    :s(2000);
4    :s(3000);
5    :s(4000);
6    :s(5000);
7    :s(10000);//10 sec
8    :s(30000);//30 sec
9    :s(60000);//60 sec
else
   begin

   xindex:=4;
   s(3000);
   result:=false;

   end;
end;//case

end;

procedure tnotes.sethold(xindex:longint);
begin
findhold(xindex,ihold,iholdms);
end;

function tnotes.xlayout:longint;
begin
result:=frcrange32(olayout,0,3);
end;

function tnotes.xnotesperrow:longint;
begin
case xlayout of
0,1  :result:=12;
2    :result:=8;
3    :result:=16;
else  result:=12;
end;//case
end;

function tnotes.xnoteoffset:longint;
begin
case xlayout of
1:result:=4;
else result:=0;
end;
end;

function tnotes.xmakelabel(x:longint):string;
var
   i,v:longint;
   s:string;
begin
i:=x-((x div 12)*12);
v:=(x div 12)-1;

case i of
0:s:='C';
1:s:='Db';
2:s:='D';
3:s:='Eb';
4:s:='E';
5:s:='F';
6:s:='Gb';
7:s:='G';
8:s:='Ab';
9:s:='A';
10:s:='Bb';
11:s:='B';
end;//case

result:=s+intstr32(v);
end;

procedure tnotes.xclear;
var
   p:longint;
begin
for p:=0 to high(iflash) do
begin
ihold64[p]  :=0;
inotedc[p]  :=clnone;
itime[p]    :=0;
inref[p]    :=-1;
iflash[p]   :=false;
end;
end;

procedure tnotes.muteall(xmute:boolean);
var
   p:longint;
begin

mid_enter1;
for p:=0 to high(mmsys_mid_mutenote) do mmsys_mid_mutenote[p]:=xmute;
mid_leave1;

end;

procedure tnotes._ontimer(sender:tobject);
var
   p:longint;
   bol1:boolean;
begin

if not xcanpaint then exit;

//flash timer
if (slowms64>=iflashtimer) then
   begin

   iflashon:=not iflashon;

   iflashtimer:=slowms64+low__aorb(1000,500,mid_playing);

   end;

//animate notes
if (idownindex>=0) and (idownindex<=high(mmsys_mid_mutenote)) and focused and (not idowntimed) and gui.mousedown and (gui.mousedowntime>=2000) then
   begin
   idowntimed:=true;
   bol1:=not mmsys_mid_mutenote[idownindex];

   mid_enter1;
   for p:=0 to high(mmsys_mid_mutenote) do mmsys_mid_mutenote[p]:=bol1;
   mid_leave1;

   iref:=-1;//force repaint
   end;

//hold timer
if (slowms64>=iholdtimer) then
   begin
   for p:=0 to high(ihold64) do if (ihold64[p]<>0) then
       begin
       iref:=-1;
       break;
       end;

   //iinforef
   if low__setstr(iinforef,bolstr(iflashon)+bolstr(olabels)+'|'+intstr32(xlayout)) then iref:=-1;

   //reset
   iholdtimer:=slowms64+250;
   end;

//paint timer
if (slowms64>=ipainttimer) then
   begin
   if low__setint(idataref,mmsys_mid_dataref) then xclear;

   if low__setint(iref,mid_trackingid) then
      begin
      paintnow;
      app__turbo;
      end;

   //reset
//   ipainttimer:=slowms64+odelayMS;
   ipainttimer:=slowms64+frcmin32(odelayMS,17);//~60fps

   end;

end;

function tnotes.xrowcount:longint;
begin
result:=frcmin32(128 div xnotesperrow,1);
if ((result*xnotesperrow)<128) then inc(result);
end;

function tnotes.xrowheight(xclientheight:longint):longint;
begin
if (xclientheight<=0) then result:=vifontheight+(2*vizoom) else result:=frcmin32( (xclientheight div xrowcount) ,1);
end;

function tnotes.getalignheight(xclientwidth:longint):longint;
begin
result:=(xrowcount*xrowheight(0)) + (2*vizoom);
end;

function tnotes.xfindarea(x,y:longint;var xindex:longint):boolean;
var
   p:longint;
begin
//defaults
result:=false;
xindex:=0;

for p:=0 to high(iarea) do if (x>=iarea[p].left) and (x<=iarea[p].right) and (y>=iarea[p].top) and (y<=iarea[p].bottom) then
   begin
   xindex:=p;
   result:=true;
   break;
   end;
end;

function tnotes.getsettings:string;
var
   p:longint;
begin
low__setlen(result,high(mmsys_mid_mutenote)+1);
for p:=0 to high(mmsys_mid_mutenote) do result[p+stroffset]:=low__aorbchar('0','1',mmsys_mid_mutenote[p]);
end;

procedure tnotes.setsettings(x:string);
var
   p:longint;
begin
if (x<>'') then
   begin

   mid_enter1;
   for p:=0 to frcmax32(high(mmsys_mid_mutenote),low__len32(x)-1) do mmsys_mid_mutenote[p]:=(x[p+stroffset]='1');//zero-based string access
   mid_leave1;

   iref:=-1;//force paint
   end;
end;

function tnotes._onnotify(sender:tobject):boolean;
begin
//defaults
result:=false;

try
//mouse down
if gui.mousedownstroke then
   begin
   idowntimed:=false;
   if not xfindarea(mousedownxy.x,mousedownxy.y,idownindex) then idownindex:=-1;
   end;

//mouse up
if gui.mouseupstroke and (idownindex>=0) and (idownindex<=high(mmsys_mid_mutenote)) then
   begin
   if idowntimed then
      begin
      //ignore
      end
   else
      begin

      mid_enter1;
      mmsys_mid_mutenote[idownindex]:=not mmsys_mid_mutenote[idownindex];
      mid_leave1;

      iref:=-1;//force paint
      end;
   end;
except;end;
end;

procedure tnotes._onpaint(sender:tobject);
const
   xby=8;
var
   s:tclientinfo;
   da:twinrect;
   t:string;
   xtime,v64,xmax64,xhold64:comp;
   dnoteon:boolean;
   bkhover,bkmute,dcback,xnoteAddOne,xchannel,dfont2,dmute0,dmute1,dmute2,dhover0,dhover1,dhover2,i,sp,tw,dcount,dperrow,dx,dy,dw,dh,vout,dc,xnote,p2:longint;
   xinfo:tmidinote;
begin
try
//init
infovars(s);
v64         :=slowms64;
xnoteAddOne :=insint(1,not izerobase);

if mid_playing then xmax64:=add64(v64,iholdms) else xmax64:=0;

if (iholdms<=0) then xhold64:=0 else xhold64:=v64+iholdms;//11jan2025

dmute0      :=int__splice24(0.35,int__greyscale(s.colhover2.x),255);
dmute1      :=int__splice24(0.45,int__greyscale(s.colhover2.y),255);
dmute2      :=int__splice24(0.65,int__greyscale(s.colhover2.y),255);
bkmute      :=int__splice24(0.15,int__greyscale(s.colhover2.x),255);

dhover0     :=int__splice24(0.35,s.colhover2.y,s.colhover2.x);
dhover1     :=int__splice24(0.25,s.colhover2.y,s.colhover2.x);
dhover2     :=s.colhover2.y;
bkhover     :=int__splice24(0.75,s.colhover2.x,s.hover);

dfont2      :=int__splice24(0.15,s.font,255);

//background
if low__setstr(iclsref,intstr32(s.back)+'|'+intstr32(s.cs.right-s.cs.left+1)+'|'+intstr32(s.cs.bottom-s.cs.top+1)) then ffillArea(s.cs,s.back,false);

//init
sp:=2*s.zoom;
dperrow:=frcmin32(xnotesperrow,1);
dh:=frcmin32( xrowheight(s.ch)-sp ,1);
dw:=frcmin32( (s.cw div dperrow)-sp ,1);

//cells
dcount:=xnoteoffset;
dx:=sp+(dcount*(dw+sp));
dy:=sp;

for xnote:=0 to high(iflash) do
begin

da.top        :=dy;
da.bottom     :=dy+dh-1;
da.left       :=dx;
da.right      :=dx+dw-1;
iarea[xnote]  :=da;
xtime         :=0;

for xchannel:=0 to 15 do if mid_trackinginfo(xchannel,xnote,xinfo) and (not xinfo.mutedByTrack) and (not xinfo.mutedByChannel) and (xinfo.volRAW>=1) and (xinfo.timeRAW>xtime) then xtime:=xinfo.timeRAW;

dnoteon       :=(xtime>=v64);


//flash active note
if low__setcmp(itime[xnote],xtime) then iflash[xnote]:=not iflash[xnote];

if dnoteon then ihold64[xnote] :=xhold64;

//note muted
if mmsys_mid_mutenote[xnote] then
   begin

   if dnoteon   then dc:=low__aorb(dmute1,dmute2,iflash[xnote])
   else              dc:=low__aorb(bkmute,dmute0,not oflat);

   dcback              :=bkmute;

   end
//note on
else if dnoteon then
   begin

   if dnoteon   then dc:=low__aorb(dhover1,dhover2,iflash[xnote])
   else              dc:=dhover0;

   dcback              :=s.colhover2.x;

   end
//note off
else
   begin

   dc                  :=s.hover;
   dcback              :=s.back;

   end;

//erase "non-outline"
ffillArea(area__make(da.left,da.bottom-(2*vizoom),da.right,da.bottom),s.back,s.r);

//highlight
case oflat of
true:ffillArea(da,dc,s.r);
else fshadeArea2(da,dcback,dc,dc,dcback,50,255,s.r);
end;//case

ihold64[xnote]:=frcrange64(ihold64[xnote],0,xmax64);//enforce maximum hold range

if (not dnoteon) and (ihold64[xnote]>=v64) then
   begin

   if mmsys_mid_mutenote[xnote] then
      begin

      dc       :=low__aorb(dmute2,dmute1,iflash[xnote]);
      dcback   :=bkmute;
      end

   else
      begin

      dc       :=low__aorb(s.colhover2.y,dhover2,iflash[xnote]);
      dcback   :=bkhover;

      end;
      
   if ooutline then
      begin

      for p2:=0 to 1 do ldsoSHADE(area__grow(da,-p2),dcback,dc,clnone,0,insstr('g-50',not oflat),false,s.r);

      end
   else lds2(area__make(da.left,da.bottom-(2*vizoom),da.right,da.bottom),dcback,dc,clnone,0,insstr('g-50',not oflat),s.r);

   end;

//label
if mmsys_mid_mutenote[xnote] and iflashon then t:='m'
else if olabels                           then t:=ilabels[xnote]
else                                           t:=intstr32( xnote + xnoteAddOne );

tw:=low__fonttextwidth2(s.fn,t);

ldt1(s.back,da,da.left+((da.right-da.left+1-tw) div 2),da.top+((da.bottom-da.top+1-s.fnH) div 2),low__aorb(s.font,dfont2,mmsys_mid_mutenote[xnote]),t,s.fn,s.f,s.r);

//inc
inc(dcount);
if (dcount>=dperrow) then
   begin

   dcount:=0;
   dx:=sp;
   inc(dy,dh+sp);

   end
else inc(dx,dw+sp);

end;//p

except;end;
end;

//## tkeys #####################################################################
constructor tpiano.create(xparent:tobject);
begin
create2(xparent,true);
end;

constructor tpiano.create2(xparent:tobject;xstart:boolean);
var
   p:longint;
begin
//self
if classnameis('tpiano') then track__inc(satOther,1);
inherited create2(xparent,false);
//vars
hint:='Piano | View realtime piano keystrokes';

oroundstyle   :=corNone;
odelayMS      :=50;//01feb2026
ilabelmode    :=1;
ikeycount     :=88;
ipainttimer   :=slowms64;
idataref      :=0;
iref          :=-1;
iclsref       :='';
iwcount       :=0;
ibcount       :=0;

//.white keys
wbottom       :=ggga0__int(180);
wside         :=ggga0__int(220);
wtop          :=ggga0__int(250);

//.black keys
bbottom       :=ggga0__int(150);
bside         :=ggga0__int(200);
btop          :=ggga0__int(0);

low__cls(@ilist,sizeof(ilist));


xclear;
xsynckeycount;

//start
if xstart then start;
end;

destructor tpiano.destroy;
begin
try
inherited destroy;
if classnameis('tpiano') then track__inc(satOther,-1);
except;end;
end;

procedure tpiano.setlabelmode(x:longint);
begin
if low__setint(ilabelmode,frcrange32(x,0,3)) then paintnow;
end;

procedure tpiano.setkeystyle(x:longint);//15sep2025
begin
if low__setint(ikeystyle,frcrange32(x,0,khsMax)) then paintnow;
end;

procedure tpiano.setkeycount(x:longint);
begin

//filter
case x of
37,49,54,61,76,88,128:;
else x:=88;//default 88 keys
end;

//get
if low__setint(ikeycount,x) then
   begin
   xsynckeycount;
   paintnow;
   end;

end;

procedure tpiano.xsynckeycount;
var
   xfrom,xto,p:longint;
   xlabel:tpianolabel;

   procedure wadd(xindex:longint);
   begin

   if (iwcount>high(ilist)) then exit;

   ilist[iwcount].wlist  :=xindex;
   ilist[iwcount].wcap   :=xlabel;
   inc(iwcount);

   end;

   procedure badd(xindex:longint);
   begin

   if (ibcount>high(ilist)) then exit;

   ilist[ibcount].blist  :=xindex;
   ilist[ibcount].blist2 :=iwcount;//white key position
   ilist[iwcount].bcap   :=xlabel;
   inc(ibcount);

   end;
begin

case ikeycount of
88:begin
   xfrom:=21;
   xto  :=xfrom-1+88;
   end;
76:begin
   xfrom :=60-32;
   xto   :=xfrom-1+76;
   end;
61:begin
   xfrom :=60-24;
   xto   :=xfrom-1+61;
   end;
54:begin
   xfrom :=60-24;
   xto   :=xfrom-1+54;
   end;
49:begin
   xfrom :=60-24;
   xto   :=xfrom-1+49;
   end;
37:begin
   xfrom :=60-19;
   xto   :=xfrom-1+37;
   end;
else//default to full midi range of 128 keys
   begin
   xfrom:=0;
   xto  :=127;
   end;
end;//case

//clear
iwcount:=0;
ibcount:=0;

//add
for p:=xfrom to frcmax32(xto,high(ilist)) do if xwhitekey(p,xlabel) then wadd(p) else badd(p);
end;

procedure tpiano.xclear;
var
   p:longint;
begin

for p:=0 to high(ilist) do
begin

ilist[p].flash    :=false;
ilist[p].ltime    :=0;
ilist[p].lnoteon  :=false;

end;//p

end;

procedure tpiano._ontimer(sender:tobject);
begin

if not xcanpaint then exit;

//paint timer
if (slowms64>=ipainttimer) then
   begin
   if low__setint(idataref,mmsys_mid_dataref) then xclear;

   if low__setint(iref,mid_trackingid) then
      begin
      paintnow;
      app__turbo;
      end;

   //reset
//   ipainttimer:=slowms64+odelayMS;
   ipainttimer:=slowms64+frcmin32(odelayMS,17);//~60fps

   end;
   
end;

function tpiano.getalignheight(xclientwidth:longint):longint;//13dec2025
begin

result:=frcmax32( frcmin32(round(xclientwidth*0.09),10), round(gui.height*0.23) );//height scaled to width BUT do not exceed 30% of gui.height

end;

function tpiano.xwhitekey(x:longint;var xlabel:tpianolabel):boolean;
var
   i:longint;
begin
i:=x-((x div 12)*12);

case i of
0,2,4,5,7,9,11:result:=true;//white key
else           result:=false;//black key
end;//case

case i of
0:xlabel:='C';
1:xlabel:='Db';
2:xlabel:='D';
3:xlabel:='Eb';
4:xlabel:='E';
5:xlabel:='F';
6:xlabel:='Gb';
7:xlabel:='G';
8:xlabel:='Ab';
9:xlabel:='A';
10:xlabel:='Bb';
11:xlabel:='B';
end;
end;

procedure tpiano._onpaint(sender:tobject);
var
   s:tclientinfo;
   da:twinrect;
   cwhite,cblack,cwhiteEdge,cblackEdge,xlabelmode,fn2,fnH2,wupshift1,wupshift2,bupshift1,bupshift2,sx,dx,dy,wh,bh,ww,bw,whover1,whover2,bhover1,bhover2,p:longint;
   von,bol1,xflash:boolean;

   function xnoteon(xnote:longint):boolean;
   var
      xchannel:longint;
      xtime:comp;
      xinfo:tmidinote;
   begin

   //defaults
   result:=false;

   //get
   xtime  :=0;
   for xchannel:=0 to 15 do if mid_trackinginfo(xchannel,xnote,xinfo) and (xinfo.volOUT>=1) and (xinfo.timeOUT>xtime) then
      begin

      xtime:=xinfo.timeOUT;

      end;

   result:=(xtime>=slowms64);

   if (ilist[xnote].lnoteon=result) and (ilist[xnote].ltime<>xtime) then ilist[xnote].flash:=not ilist[xnote].flash
   else                                                                  ilist[xnote].flash:=false;

   ilist[xnote].lnoteon  :=result;
   ilist[xnote].ltime    :=xtime;
   xflash                :=ilist[xnote].flash;

   end;

   procedure dk(da:twinrect;ddown,dtoggle,dwhitekey:boolean;dlabel:string);//draw key
   var
      d:twinrect;
      v1,v2,bs,tw,dbottom,dside,dtop,c0,c1,c,p,dshift:longint;

      procedure dl(xcolor:longint);//draw left
      begin

      ldv(d.left,d.top,d.bottom-1-dshift,xcolor,false);

      //inc
      inc(d.left);
      dec(d.bottom);

      end;

      procedure dr(xcolor:longint);//draw right
      begin

      ldv(d.right,d.top,d.bottom-1-dshift,xcolor,false);

      //inc
      dec(d.right);
      dec(d.bottom);

      end;

      procedure db(xcolor:longint);//draw bottom
      begin

      if dwhitekey then ldh(d.left+1,d.right-1,d.bottom-dshift,xcolor,false)
      else              ldh(d.left+0,d.right-0,d.bottom-dshift,xcolor,false);

      //inc
      inc(d.left);
      dec(d.right);
      dec(d.bottom);

      end;

      procedure dt(xcolor:longint);//draw top
      begin

      ldh(d.left+1,d.right-1,d.top,xcolor,false);

      //inc
      inc(d.left);
      dec(d.right);
      inc(d.top);

      end;

   begin
   //init
   bs:=2*s.zoom;

   //color + shift
   if   dwhitekey then
      begin

      c0       :=cwhite;
      c1       :=cblack;
      c        :=low__aorb(wtop,low__aorb(whover1,whover2,dtoggle), ddown and (ikeystyle<>khsOff) );
      dbottom  :=wbottom;
      dside    :=wside;
      dtop     :=wtop;
      dshift   :=low__aorb(0, low__aorb(wupshift2,wupshift1,xflash) ,ddown);

      end
   else
      begin

      c0       :=cblack;
      c1       :=cwhite;
      c        :=low__aorb(btop, low__aorb(bhover1,bhover2,dtoggle), ddown and (ikeystyle<>khsOff) );
      dbottom  :=bbottom;
      dside    :=bside;
      dtop     :=btop;
      dshift   :=low__aorb(0,low__aorb(bupshift2,bupshift1,xflash),ddown);

      end;

   //top of key -> color as normal or in down state
   case ikeystyle of
   khsShadeUP :lds2(area__make(da.left+bs,da.top,da.right-bs,da.bottom-bs-dshift),c0,c,c0,0,'g-15',false);
   khsShadeDN :lds2(area__make(da.left+bs,da.top,da.right-bs,da.bottom-bs-dshift),c0,c,c0,0,'g-65',false);
   khsEdge,khsEdge2:begin

      ffillArea(area__make(da.left+bs,da.top,da.right-bs,da.bottom-bs-dshift),c0,false);

      if ddown then
         begin

         case dwhitekey of
         true:lds2( area__make(da.left+bs,da.bottom-bs-dshift-6, da.right-bs,da.bottom-bs-dshift)  ,c0 ,cwhiteEdge,clnone,0,'g-100',false);
         else lds2( area__make(da.left+bs,da.bottom-bs-dshift-5,  da.right-bs,da.bottom-bs-dshift) ,c0 ,cblackEdge,clnone,0,'g-100',false);
         end;//case

         end;

      end;
   else        ffillArea(area__make(da.left+bs,da.top,da.right-bs,da.bottom-bs-dshift),c,false);
   end;//case

   //label
   if (dlabel<>'') then
      begin
      tw:=low__fonttextwidth2(fn2,dlabel);
      ldt1(dtop,da,da.left+((da.right-da.left+1-tw) div 2),da.top+bh+((wh-bh-fnH2) div 2)-bupshift2,dbottom,dlabel,fn2,s.f,false);
      end;

   //swap edge colors for downstroke
   if ddown then low__swapint(dbottom,dside);

   //left
   d:=da;
   for p:=1 to s.zoom do dl(dbottom);
   for p:=1 to s.zoom do dl(dside);
   //right
   d:=da;
   for p:=1 to s.zoom do dr(dbottom);
   for p:=1 to s.zoom do dr(dside);
   //bottom
   d:=da;
   for p:=1 to s.zoom do db(dbottom);
   for p:=1 to s.zoom do db(dside);
   //top
   d:=da;
   for p:=1 to s.zoom do dt(dside);
   end;
begin
try

//init
infovars(s);
xlabelmode  :=ilabelmode;
cwhite      :=int_255_255_255;
cblack      :=0;

case ikeystyle of
khsEdge:begin

   cwhiteEdge  :=s.colhover;
   cblackEdge  :=s.colhover;

   end;
else begin

   cwhiteEdge  :=int__splice24(0.7,cblack,cwhite);
   cblackEdge  :=int__splice24(0.2,cwhite,cblack);

   end;
end;

//.white keys
case ikeystyle of
khsSubtle:begin
   whover1  :=int__splice24(0.25,int_255_255_255,s.colhover);
   whover2  :=int__splice24(0.20,int_255_255_255,s.colhover);
   end;
khsSubtle2:begin
   whover1  :=ggga0__int(230);
   whover2  :=ggga0__int(220);
   end;
else begin
   whover1  :=int__splice24(0.80,wbottom,s.colhover);
   whover2  :=int__dif24(whover1,20);
   end;
end;//case

wh        :=s.ch;
ww        :=s.cw div frcmin32(iwcount,1);
wupshift2 :=5*s.zoom;//standard shift
wupshift1 :=3*s.zoom;//smaller flash based shift


//.black keys
case ikeystyle of
khsSubtle:begin
   bhover1  :=int__splice24(0.40,0,s.colhover);
   bhover2  :=int__splice24(0.35,0,s.colhover);
   end;
khsSubtle2:begin
   bhover1  :=ggga0__int(50);
   bhover2  :=ggga0__int(40);
   end;
else begin
   bhover1  :=int__splice24(0.80,0,s.colhover);
   bhover2  :=int__dif24(bhover1,20);
   end;
end;//case
bh       :=round(wh*0.65);
bw       :=frcmin32(round(0.65*ww),1);
bupshift2:=3*s.zoom;//standard shift
bupshift1:=1*s.zoom;//smaller flash based shift

//.smaller font
fn2      :=low__font0(s.info.fontname,-frcmin32(round(ww*0.60),5));
fnH2     :=low__fontmaxh(fn2);

//.other
xflash   :=false;
sx       :=(s.cw-(ww* frcmin32(iwcount,1) )) div 2;
dy       :=0;

//background
if low__setstr(iclsref,intstr32(s.back)+'|'+intstr32(s.cs.right-s.cs.left+1)+'|'+intstr32(s.cs.bottom-s.cs.top+1)) then ffillArea(s.cs,s.back,false)
else
   begin
   //quick cls -> wipe out key shift areas (upshift)
   ffillArea(area__make(sx,bh-1-wupshift2,sx+(iwcount*ww)-1,bh-1),s.back,false);//black keys
   ffillArea(area__make(sx,wh-1-wupshift2,sx+(iwcount*ww)-1,wh-1),s.back,false);//white keys
   end;

//white keys
for p:=0 to (iwcount-1) do
begin

dx   :=sx+(p*ww);
von  :=xnoteon(ilist[p].wlist);

//.labelmode
case ilist[p].wlist of
60   :bol1:=(xlabelmode=3) or (xlabelmode=2) or (xlabelmode=1);//middle C
65   :bol1:=(xlabelmode=3) or (xlabelmode=2);//middle C+F
else  bol1:=(xlabelmode=3);//all
end;

da   :=area__make(dx,dy,dx+ww-1,dy+wh-1);
dk(da,von,xflash,true,insstr(ilist[p].wcap,bol1));

end;//p

//black keys
for p:=0 to (ibcount-1) do
begin

dx   :=sx+(ilist[p].blist2*ww)-(ww div 2)+((ww-bw) div 2);
von  :=xnoteon(ilist[p].blist);
da   :=area__make(dx,dy,dx+bw-1,dy+bh-1);

dk(da,von,xflash,false,insstr(ilist[p].bcap,xlabelmode=3));

end;//p

//ldbEXCLUDE(false,area__make(sx,0,sx + (iwcount*ww) -1 ,cs.bottom),false);
except;end;
end;

end.
