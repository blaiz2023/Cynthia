unit main;

interface
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define bmp} {$define ico} {$define gif} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define bmp} {$define ico} {$define gif} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot, {$ifdef gui}gossgui,{$endif} {$ifdef snd}gosssnd,{$endif} gosswin, gossio, gossimg, gossnet;
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
//## Library.................. app code (main.pas)
//## Version.................. 1.00.4830
//## Items.................... 5
//## Last Updated ............ 03jul2025, 08mar2025, 18feb2025, 08feb2025, 25jan2025, 12jan2025, 22nov2024, 05apr2021, 22mar2021, 20feb2021
//## Lines of Code............ 3,600
//##
//## main.pas ................ app code
//## gossroot.pas ............ console/gui app startup and control
//## gossio.pas .............. file io
//## gossimg.pas ............. image/graphics
//## gossnet.pas ............. network
//## gosswin.pas ............. 32bit windows api's
//## gosssnd.pas ............. sound/audio/midi/chimes
//## gossgui.pas ............. gui management/controls
//## gossdat.pas ............. static data/icons/splash/help settings/help document(gui only)
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | tapp                   | tbasicapp         | 1.00.4405 | 03jul2025   | Play "*.mid/mid/rmi" files swiftly and with ease and reliability - 18feb2025, 14feb2025, 05apr2021, 22mar2021, 20feb2021
//## | ttracks                | tbasiccontrol     | 1.00.042  | 03jul2025   | Indicate midi track activity.  Supports mute/unmute per track.  Supports upto 512 tracks. - 14feb2025
//## | tchannels              | tbasiccontrol     | 1.00.082  | 03jul2025   | Indicate average volume and peak average volume per channel.  Supports mute/unmute for all 16 channels. - 14feb2025
//## | tnotes                 | tbasiccontrol     | 1.00.122  | 03jul2025   | Indicate note activity.  Supports mute/unmute for all 128 notes. - 14feb2025
//## | tpiano                 | tbasiccontrol     | 1.00.174  | 03jul2025   | Animate piano key depress for each note played. - 14feb2025
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

type
{tchannels}
   tchannels=class(tbasiccontrol)
   private
    ipainttimer:comp;
    iblockcount,iblockoveralsize,iblocksize,iblockgap,idownindex,idataref:longint;
    idowntimed:boolean;
    iclsref:string;
    iarea      :array[0..15] of twinrect;
    iavevol    :array[0..15] of longint;
    iholdvol   :array[0..15] of longint;
    irefvol    :array[0..15] of tint4;
    ihold64    :array[0..15] of comp;
    imuted     :array[0..15] of boolean;
    imuteoff64 :array[0..15] of comp;
    function xfindarea(x,y:longint;var xindex:longint):boolean;
    function getsettings:string;
    procedure setsettings(x:string);
    procedure xclear;
    procedure xbar(da:twinrect;xindex,xvol,xholdvol,xcolor,xfontcolor,fn,fnH,xfeather:longint;xround:boolean);
    function xcalc:boolean;
   public
    oholdms:longint;
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

{ttracks}
   ttracks=class(tbasiccontrol)
   private
    ipainttimer:comp;
    ilastheight,ilasttrackcount,iitemsperrow,idownindex,idataref:longint;
    iclsref,iinforef:string;
    idowntimed:boolean;
    iarea    :array[0..high(mmsys_mid_mutetrack)] of twinrect;
    iflash   :array[0..high(mmsys_mid_mutetrack)] of boolean;
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
    ipainttimer,iholdtimer:comp;
    idownindex,idataref,iref:longint;
    iclsref,iinforef:string;
    idowntimed:boolean;
    iref2    :array[0..127] of boolean;
    inoteref :array[0..127] of longint;
    ihold64  :array[0..127] of comp;
    inotedc  :array[0..127] of longint;
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
   public
    olayout:longint;
    olabels:boolean;
    oholdms:longint;
    oholdoutline:boolean;
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

{tpiano}
   tpiano=class(tbasiccontrol)
   private
    ipainttimer:comp;
    ilabelmode,ikeycount,iwcount,ibcount,idataref,iref:longint;
    iclsref:string;
    iwlist     :array[0..127] of byte;
    iwcap      :array[0..127] of string;
    iblist     :array[0..127] of byte;
    iblist2    :array[0..127] of byte;//white key reference
    ibcap      :array[0..127] of string;
    inotecount :array[0..127] of longint;
    inoteflash :array[0..127] of boolean;
    wbottom,wside,wtop:longint;
    bbottom,bside,btop:longint;
    procedure xclear;
    function xwhitekey(x:longint;var xlabel:string):boolean;
    procedure setkeycount(x:longint);
    procedure xsynckeycount;
    procedure setlabelmode(x:longint);
   public
    //create
    constructor create(xparent:tobject); virtual;
    constructor create2(xparent:tobject;xstart:boolean); virtual;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    function getalignheight(xclientwidth:longint):longint; override;
    procedure _onpaint(sender:tobject); override;
    //information
    property keycount:longint read ikeycount write setkeycount;
    property labelmode:longint read ilabelmode write setlabelmode;
   end;

{tapp}
   tapp=class(tbasicapp)
   private
    ilaststate:char;
    imiddevice:tbasicsel;
    itranspose:tsimpleint;
    ivol:tsimpleint;
    iplaylist:tplaylist;
    ispeed:tsimpleint;
    imode,istyle:tbasicsel;
    iformats:tbasicset;
    ijump:tbasicjump;
    ijumptitle,itrackbar,ipianobar,ichbar,inotesbar,ilistcap,inavcap:tbasictoolbar;
    inav:tbasicnav;
    ilist,iinfo:tbasicmenu;
    ilistroot:tbasicscroll;
    ixboxfeedback,ishowpiano,ishownav,ishowinfo,ishowvis,ishowlistlinks,ianimateicon,ialwayson,ionacceptonce,lshow,lshowsep,ilargejumptitle,ilargejump,iautoplay,iautotrim,imuststop,imustplay,iplaying,ibuildingcontrol,iloaded:boolean;
    ixboxcontroller:longint;
    iflashref,itimer100,itimer350,itimer500,itimerslow,iinfotimer:comp;
    iplaylistREF,ijumpcap,ilyricref,iinforef,ilasterror,ilastsavefilename,ilastfilename,inavref,isettingsref:string;
    ilastpos,imustpos:longint;
    imustpertpos:double;
    //.status support
    iff,iintro,iinfoid,iselstart,iselcount,idownindex,inavindex,ifolderindex,ifileindex,inavcount,ifoldercount,ifilecount:longint;
    iisnav,iisfolder,iisfile:boolean;
    //.midi status
    itracks:ttracks;
    ichannels:tchannels;
    ipiano:tpiano;
    inotes:tnotes;
    iholdmode:longint;
    iholdoutline:boolean;
    ijumpstatus:longint;
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
    procedure xapplymidiopts(xholdmode:longint;xholdoutline:boolean;x:tobject);
    procedure xbox;
    //.saveas
    function xlistfilename:string;
    function xcansaveas:boolean;
    procedure xsaveas;
   public
    //create
    constructor create; virtual;
    destructor destroy; override;
    //information
    property showplaylist:boolean read getshowplaylist write setshowplaylist;
//    property shownav:boolean read getshownav write setshownav;
   end;


//custom toolbar images (in tea format) - 08feb2025
const
tep_settings20:array[0..400] of byte=(
84,69,65,49,35,19,0,0,0,20,0,0,0,128,255,255,47,0,0,0,2,128,255,255,12,0,0,0,2,128,255,255,2,0,0,0,1,128,255,255,2,0,0,0,1,128,255,255,2,0,0,0,2,128,255,255,6,0,0,0,1,128,255,255,2,0,0,0,2,128,255,255,4,0,0,0,2,128,255,255,2,0,0,0,1,128,255,255,5,0,0,0,1,128,255,255,12,0,0,0,1,128,255,255,6,0,0,0,1,128,255,255,10,0,0,0,1,128,255,255,7,0,0,0,1,128,255,255,10,0,0,0,1,128,255,255,5,0,0,0,2,128,255,255,4,0,0,0,3,128,255,255,5,0,0,0,1,128,255,255,3,0,0,0,1,128,255,255,5,0,0,0,1,128,255,255,3,0,0,0,1,128,255,255,5,0,0,0,1,128,255,255,2,0,0,0,1,128,255,255,5,0,0,0,1,128,255,255,3,0,0,0,1,128,255,255,5,0,0,0,1,128,255,255,3,0,0,0,2,128,255,255,3,0,0,0,1,128,255,255,3,0,0,0,1,128,255,255,4,0,0,0,1,128,255,255,6,0,0,0,1,128,255,255,3,0,0,0,3,128,255,255,4,0,0,0,1,128,255,255,7,0,0,0,1,128,255,255,10,0,0,0,1,128,255,255,6,0,0,0,1,128,255,255,11,0,0,0,1,128,255,255,6,0,0,0,1,128,255,255,2,0,0,0,2,128,255,255,4,0,0,0,2,128,255,255,2,0,0,0,1,128,255,255,6,0,0,0,2,128,255,255,2,0,0,0,1,128,255,255,2,0,0,0,1,128,
255,255,2,0,0,0,2,128,255,255,11,0,0,0,1,128,255,255,2,0,0,0,1,128,255,255,16,0,0,0,2,128,255,255,27);

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024
procedure info__app_checkparameters;


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
else if (xname='width')               then result:='1500'
else if (xname='height')              then result:='1000'
else if (xname='ver')                 then result:='1.00.4830'
else if (xname='date')                then result:='03jul2025'
else if (xname='name')                then result:='Cynthia'
else if (xname='web.name')            then result:='cynthia'//used for website name
else if (xname='des')                 then result:='Play midi files'
else if (xname='infoline')            then result:=info__app('name')+#32+info__app('des')+' v'+app__info('ver')+' (c) 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='size')                then result:=low__b(io__filesize64(io__exename),true)
else if (xname='diskname')            then result:=io__extractfilename(io__exename)
else if (xname='service.name')        then result:=info__app('name')
else if (xname='service.displayname') then result:=info__app('service.name')
else if (xname='service.description') then result:=info__app('des')
else if (xname='new.instance')        then result:='1'//1=allow new instance, else=only one instance of app permitted
else if (xname='screensizelimit%')    then result:='98'//95% of screen area
else if (xname='realtimehelp')        then result:='0'//1=show realtime help, 0=don't
else if (xname='hint')                then result:='1'//1=show hints, 0=don't


//.links and values
else if (xname='linkname')            then result:=info__app('name')+' by Blaiz Enterprises.lnk'
else if (xname='linkname.vintage')    then result:=info__app('name')+' (Vintage) by Blaiz Enterprises.lnk'
//.author
else if (xname='author.shortname')    then result:='Blaiz'
else if (xname='author.name')         then result:='Blaiz Enterprises'
else if (xname='portal.name')         then result:='Blaiz Enterprises - Portal'
else if (xname='portal.tep')          then result:=intstr32(tepBE20)
//.software
else if (xname='software.tep') then
   begin
   if      (sizeof(program_icon20h)>=2) then result:=intstr32(tepIcon20)
   else if (sizeof(program_icon24h)>=2) then result:=intstr32(tepIcon24)
   else                                      result:=intstr32(tepNext20);
   end
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

//.program values -> defaults and fallback values
else if (xname='focused.opacity')     then result:='255'//range: 50..255
else if (xname='unfocused.opacity')   then result:='255'//range: 30..255
else if (xname='opacity.speed')       then result:='9'//range: 1..10 (1=slowest, 10=fastest)

else if (xname='head.center')         then result:='0'//1=center window title, 0=left align window title
else if (xname='head.align')          then result:='1'//0=left, 1=center, 2=right -> head based toolbar alignment
else if (xname='high.above')          then result:='0'//highlight above, 0=off, 1=on

else if (xname='modern')              then result:='1'//range: 0=legacy, 1=modern
else if (xname='scroll.size')         then result:='20'//scrollbar size: 5..72

else if (xname='bordersize')          then result:='7'//0..72 - frame size
else if (xname='sparkle')             then result:='7'//0..20 - default sparkle level -> set 1st time app is run, range: 0-20 where 0=off, 10=medium and 20=heavy)
else if (xname='brightness')          then result:='100'//60..130 - default brightness

else if (xname='ecomode')             then result:='0'//1=economy mode on, 0=economy mode off
else if (xname='emboss')              then result:='0'//0=off, 1=on
else if (xname='color.name')          then result:='black 8'//white 5'//default color scheme name
else if (xname='back.name')           then result:=''//default background name
else if (xname='frame.name')          then result:='narrow'//default frame name
else if (xname='frame.max')           then result:='1'//0=no frame when maximised, 1=frame when maximised
//.font
else if (xname='font.name')           then result:='Arial'//default GUI font name
else if (xname='font.size')           then result:='10'//default GUI font size
//.font2
else if (xname='font2.use')           then result:='1'//0=don't use, 1=use this font for text boxes (special cases)
else if (xname='font2.name')          then result:='Courier New'
else if (xname='font2.size')          then result:='12'
//.help
else if (xname='help.maxwidth')       then result:='500'//pixels - right column when help shown

//.paid/store support
else if (xname='paid')                then result:='0'//desktop paid status ->  programpaid -> 0=free, 1..N=paid - also works inconjunction with "system_storeapp" and it's cost value to determine PAID status is used within help etc
else if (xname='paid.store')          then result:='1'//store paid status
//.anti-tamper programcode checker - updated dual version (program EXE must be secured using "Blaiz Tools") - 11oct2022
else if (xname='check.mode')          then result:='-91234356'//disable check
//else if (xname='check.mode')          then result:='234897'//enable check
else
   begin
   //nil
   end;

except;end;
end;

procedure info__app_checkparameters;
var
   xonce:boolean;

   procedure c(n:string);
   begin
   //show first error only
   if xonce and (app__info(n)='') then
      begin
      xonce:=false;
      showerror('App parameter "'+n+'" missing in "info__app()" procedure.');
      end;
   end;
begin
try
//init
xonce:=true;

//check these app parameters are set in "info__app()" proc
c('width');
c('height');
c('ver');
c('date');
c('name');
c('screensizelimit%');
c('focused.opacity');
c('unfocused.opacity');
c('opacity.speed');
c('head.large');
c('head.center');
c('head.sleek');
c('head.align');
c('scroll.size');
c('scroll.minimal');
c('slider.minimal');
c('bordersize');
c('sparkle');
c('brightness');
c('back.strength');
c('back.speed');
c('back.fadestep');
c('back.scrollstep');
c('back.vscrollstep');
c('back.wobble');
c('back.vwobble');
c('back.fadewobble');
c('back.colorise');
c('ecomode');
c('glow');
c('emboss');
c('sleek');
c('shade.focus');
c('shade.round');
c('color.name');
c('frame.name');
c('frame.max');
c('font.name');
c('font.size');
c('font2.use');
c('font2.name');
c('font2.size');
c('help.maxwidth');
c('check.mode');
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
   z,e:string;
   xsubmenu20,p:longint;

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
   ilistcap.add(xcaption,xtep,0,xcmd,xhelp);
   end;
begin
if system_debug then dbstatus(38,'Debug 010 - 21may2021_528am');//yyyy


//check source code for know problems ------------------------------------------
//io__sourecode_checkall(['']);


//required graphic support checkers --------------------------------------------
//needers - 26sep2021
need_jpeg;
//need_gif;
//need_ico;
need_mm;//required

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


//self
inherited create(strint32(app__info('width')),strint32(app__info('height')),true);
ibuildingcontrol:=true;


//init
xsubmenu20:=tepDown;//tep__addone20c(1,tep_settings20);
ilaststate:='n';
itimer100:=ms64;
itimer350:=ms64;
itimer500:=ms64;
itimerslow:=ms64;
iflashref:=ms64;
iinfotimer:=ms64;

//vars
ilastsavefilename:='';
ishowlistlinks:=false;
ialwayson:=false;
ianimateicon:=false;
ixboxcontroller:=0;
ixboxfeedback:=false;
ionacceptonce:=false;
iloaded:=false;
ilasterror:='';
inavref:='';
ilargejump:=false;
ilargejumptitle:=false;
iautoplay:=false;
ijumpstatus:=0;//off
iholdmode:=3;
iholdoutline:=false;
iautotrim:=false;
ishownav:=false;
ishowpiano:=false;
ishowinfo:=false;
ishowvis:=false;
iintro:=0;
iff:=0;
ilyricref:='';
iplaylistREF:='';
lshow:=true;
lshowsep:=true;
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
//xhead.addsep;
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
add('',xsubmenu20,0,'piano.menu','Show options');
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
add('Visual',tepVisual20,0,'vis.toggle','Visualisation Panel | Toggle visualisation panel');
add('Info',tepInfo20,0,'info.toggle','Information Panel | Toggle information panel');
add('',xsubmenu20,0,'jump.menu','Show options');
end;

ijump:=xhigh2.njump('','Click and/or drag to adjust playback position',0,0);
end;
end;


//------------------------------------------------------------------------------
//navigation column - left -----------------------------------------------------
//------------------------------------------------------------------------------
rootwin.xcols.style:=bcLefttoright;//04feb2025
rootwin.xcols.remcount[0]:=100;
with rootwin.xcols.cols2[0,1,false] do
begin
ilistroot:=client as tbasicscroll;

//.play from folder
inavcap:=ntoolbar('Navigate files and folders on disk');
with inavcap do
begin
maketitle3('Play Folder',false,false);
opagename:='folder';
normal:=false;
add('Refresh',tepRefresh20,0,'refresh','Refresh list');
add('Fav',tepFav20,0,'nav.fav','Show favourites list');
add('Back',tepBack20,0,'nav.prev','Previous folder');
add('Forward',tepForw20,0,'nav.next','Next folder');
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
xadd('Once','once','Play selected midi once');
xadd('Repeat One','repeat1','Play selected midi repeatedly');
xadd('Repeat All','repeat1','Play all midis repeatedly');
xadd('All Once','once','Play all midis once');
xadd('Random','repeat1','Play midis randomly');
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
rootwin.xcols.remcount[2]:=100;
with rootwin.xcols.cols2[2,1,false] do
begin
ntitlebar(false,'Midi Information','Midi information');

iinfo:=nlistx('','Midi technnical and playback information',19,19,__oninfo);
iinfo.otab:=tbL100_L500;
iinfo.oscaleh:=0.70;

//settings
xhigh2.ntitle(false,'Settings','Settings').osepv:=5;

//.formats

with xhigh2.ncols do
begin
makeautoheight;


iformats:=makecol(0,30,false).nset('File Types','File Types | Select midi file types to list in the Navigation panel (left) | Selecting no file type lists all midi file types',7,7);
with iformats do
begin
osepv:=vsep;
itemsperline:=3;
xset(0,'.mid', 'mid','Include ".mid" file type in list',true);
xset(1,'.midi','midi','Include ".midi" file type in list',true);
xset(2,'.rmi', 'rmi','Include ".rmi" file type in list',true);
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
ispeed:=xhigh2.mint2('Speed','Adjust playback speed | Range 10% to 1,000% | 100% is normal playback speed',10,1000,100,100,'');
ispeed.osepv:=2*vsep;
//.volume
ivol:=xhigh2.mmidivol('','');
ivol.osepv:=vsep;
end;


//------------------------------------------------------------------------------
//visualisation column - middle ------------------------------------------------
//------------------------------------------------------------------------------

rootwin.xcols.remcount[1]:=100;
with rootwin.xcols.cols2[1,1,false] do
begin

//.tracks
itrackbar:=ntitlebar(false,'Tracks','Realtime midi data track usage');
with itrackbar do
begin
halign:=2;
add('',tepUnmute20,0,'tracks.unmuteall','Unmute all tracks');
add('',tepMute20,0,'tracks.muteall','Mute all tracks');
end;
itracks:=ttracks.create(client);


//.channels
ichbar:=ntitlebar(false,'Channels','Realtime midi data channel usage');
with ichbar do
begin
osepv:=vsep;
halign:=2;

add('',xsubmenu20,0,'ch.menu','Show options');
add('',tepUnmute20,0,'ch.unmuteall','Unmute all channels');
add('',tepMute20,0,'ch.muteall','Mute all channels');
end;
ichannels:=tchannels.create(client);


//.notes
inotesbar:=ntitlebar(false,'Notes','Realtime midi note usage');
with inotesbar do
begin
osepv:=vsep;
halign:=2;
add('',xsubmenu20,0,'notes.menu','Show options');
add('',tepUnmute20,0,'notes.unmuteall','Unmute all notes');
add('',tepMute20,0,'notes.muteall','Mute all notes');
end;

inotes:=tnotes.create(client);
inotes.oautoheight:=true;

end;



//events
rootwin.onaccept:=xonaccept;
rootwin.xhead.onclick:=__onclick;
itrackbar.onclick:=__onclick;
ichbar.onclick:=__onclick;
inotesbar.onclick:=__onclick;
ipianobar.onclick:=__onclick;
ijumptitle.onclick:=__onclick;

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

//defaults
xfillinfo;

//animated icon support - 30apr2022
rootwin.xhead.aniAdd(tepIcon24,500);
rootwin.xhead.aniAdd(tepIcon24B,500);
//rootwin.xhead.aniAdd(tepError32,500);


//start timer event
ibuildingcontrol:=false;
xloadsettings;

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

procedure tapp.xapplymidiopts(xholdmode:longint;xholdoutline:boolean;x:tobject);
var
   int1:longint;
begin
//hold mode -> hold ms
case xholdmode of
0:int1:=0;//off
1:int1:=500;
2:int1:=1000;
3:int1:=2000;
4:int1:=3000;
5:int1:=5000;
else int1:=5000;
end;

if      (x=ichannels)  then ichannels.oholdms:=int1
else if (x=inotes)     then inotes.oholdms:=int1;


if (x=inotes)          then inotes.oholdoutline:=xholdoutline;
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

with ijumptitle do
begin
bmarked2['nav.toggle']:=xshownav;
bmarked2['piano.toggle']:=ishowpiano;
bmarked2['info.toggle']:=ishowinfo;
bmarked2['vis.toggle']:=ishowvis;

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
rootwin.xcols.vis[0]:=xshownav;
rootwin.xcols.vis[1]:=ishowvis;
rootwin.xcols.vis[2]:=ishowinfo;

if (ipianobar.visible<>ishowpiano) or (ipiano.visible<>ishowpiano) then
   begin
   ipianobar.visible   :=ishowpiano;
   ipiano.visible      :=ishowpiano;
   xmustalign          :=true;
   end;

//.visual panels
itracks.otrackcount:=mid_tracks;
xapplymidiOPTS(iholdmode,false,ichannels);
xapplymidiOPTS(iholdmode,iholdoutline,inotes);

//.jump
ijump.status:=ijumpstatus;
ijump.olarge:=ilargejump;
ijumptitle.olarge:=ilargejumptitle;

//.xmustalign
if xmustalign then gui.fullalignpaint;
except;end;
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

   procedure xholdmode(xoutline:boolean);
   begin
   low__menutitle(xmenudata,tepnone,'Hold Time','Hold modes');
   low__menuitem3(xmenudata,tep__tick(iholdmode=0),'Off','','holdmode.0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iholdmode=1),'0.5s','','holdmode.1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iholdmode=2),'1s','','holdmode.2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iholdmode=3),'2s','','holdmode.3',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iholdmode=4),'3s (default)','','holdmode.4',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(iholdmode=5),'5s','','holdmode.5',100,aknone,false,true);
   if xoutline then low__menuitem3(xmenudata,tep__yes(iholdoutline),'Outline','','holdoutline',100,aknone,false,true);
   end;
begin
try
//check
if zznil(xmenudata,5000) then exit;
//get

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
   //.save as
   low__menuitem3(xmenudata,tepSave20,'Save Midi As...','Save selected midi to file','saveas',100,aknone,false,xcansaveas);

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
   low__menutitle(xmenudata,tepnone,'Mute','Mute options');
   low__menuitem3(xmenudata,tepUnmute20,'Unmute All Tracks','Unmute all tracks','tracks.unmuteall',100,aknone,false,true);
   low__menuitem3(xmenudata,tepMute20,'Mute All Tracks','Mute all tracks','tracks.muteall',100,aknone,false,true);
   goto skipend;
   end
else if (xstyle='ch.menu') then
   begin
   xholdmode(false);
   goto skipend;
   end
else if (xstyle='notes.menu') then
   begin
   xholdmode(true);

   low__menutitle(xmenudata,tepnone,'Notes Per Row','Set the number of notes per row');
   low__menuitem3(xmenudata,tep__tick(2=inotes.olayout),'8 Notes','8 notes per row','layout.2',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(0=inotes.olayout),'12 Notes','12 notes per row','layout.0',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(1=inotes.olayout),'12 Notes + Indent 4','12 notes per row + indent by 4','layout.1',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(3=inotes.olayout),'16 Notes','16 notes per row','layout.3',100,aknone,false,true);

   low__menutitle(xmenudata,tepnone,'Note Labels','Set note label style');
   low__menuitem3(xmenudata,tep__tick(inotes.olabels),'As Notes','As notes','labels.on',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__tick(not inotes.olabels),'As Numbers','As numbers','labels.off',100,aknone,false,true);

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
   goto skipend;
   end
else if (xstyle='jump.menu') then
   begin
   low__menutitle(xmenudata,tepnone,'Playback Progress Bar','Playback progress bar options');
   low__menuitem3(xmenudata,tep__yes(ilargejumptitle),'Large Title','Ticked: Show large title/lyrics','largejumptitle',100,aknone,false,true);
   low__menuitem3(xmenudata,tep__yes(ilargejump),'Large Bar','Ticked: Show large playback progress bar','largejump',100,aknone,false,true);

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
end;
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
begin
try
//defaults
a:=nil;
//check
if zznil(prgsettings,5001) then exit;
//init
a:=vnew2(950);
//filter
a.b['show.list']:=prgsettings.bdef('show.list',false);//20mar2022
a.i['intro']:=prgsettings.idef('intro',0);
a.i['ff']:=prgsettings.idef('ff',0);//19apr2022
a.i['midvol']:=prgsettings.idef('midvol',100);
a.i['notelayout']:=prgsettings.idef('notelayout',1);//layout.1
a.b['notelabels']:=prgsettings.bdef('notelabels',true);
a.b['autoplay']:=prgsettings.bdef('autoplay',true);
a.b['autotrim']:=prgsettings.bdef('autotrim',false);
a.b['largejump']:=prgsettings.bdef('largejump',true);
a.b['largejumptitle']:=prgsettings.bdef('largejumptitle',false);
a.b['lshow']:=prgsettings.bdef('lshow',true);
a.b['alwayson']:=prgsettings.bdef('alwayson',false);
a.b['animateicon']:=prgsettings.bdef('animateicon',true);//30apr2022
a.i['xboxcontroller']:=prgsettings.idef('xboxcontroller',0);//25jan2025
a.b['xboxfeedback']:=prgsettings.bdef('xboxfeedback',false);//25jan2025
a.b['list.showlinks']:=prgsettings.bdef('list.showlinks',false);//27mar2022
a.b['lshowsep']:=prgsettings.bdef('lshowsep',false);
a.i['transpose']:=prgsettings.idef('transpose',0);
a.i['speed']:=prgsettings.idef('speed',100);
a.i['mode']:=prgsettings.idef('mode',2);
a.i['style']:=prgsettings.idef('style',0);
a.i['deviceindex']:=prgsettings.idef('deviceindex',0);
a.i['formats']:=prgsettings.idef('formats',7);
a.s['folder']:=prgsettings.sdef('folder','!:\');//sample drive
a.s['name']:=io__extractfilename(prgsettings.sdef('name',''));
a.s['playlist.filename']:=prgsettings.sdef('playlist.filename','');
a.i['playlist.index']:=prgsettings.idef('playlist.index',0);
a.s['mutelist0']:=prgsettings.sdef('mutelist0','');
a.s['mutelist']:=prgsettings.sdef('mutelist','');
a.s['mutelist2']:=prgsettings.sdef('mutelist2','');
a.i['pagesright.index']:=prgsettings.idef('pagesright.index',0);
a.b['shownav']:=prgsettings.bdef('shownav',true);
a.b['showpiano']:=prgsettings.bdef('showpiano',false);
a.b['showinfo']:=prgsettings.bdef('showinfo',true);
a.b['showvis']:=prgsettings.bdef('showvis',false);
a.i['jumpstatus'] :=prgsettings.idef('jumpstatus',1);
a.i['holdmode'] :=prgsettings.idef('holdmode',4);
a.b['holdoutline']:=prgsettings.bdef('holdoutline',true);
a.i['piano.keycount']:=prgsettings.idef('piano.keycount',88);
a.i['piano.labelmode']:=prgsettings.idef('piano.labelmode',1);
inav.xfromprg2('nav',a);//prg -> nav -> a
//get
lshow:=a.b['lshow'];
lshowsep:=a.b['lshowsep'];
ialwayson:=a.b['alwayson'];//23mar2022
ianimateicon:=a.b['animateicon'];//30apr2022
ixboxcontroller:=frcrange32(a.i['xboxcontroller'],0,2);
ixboxfeedback:=a.b['xboxfeedback'];
ishowlistlinks:=a.b['list.showlinks'];
iintro:=frcrange32(a.i['intro'],0,4);
iff:=frcrange32(a.i['ff'],0,4);//19apr2022
mmsys_mid_basevol:=frcrange32(a.i['midvol'],0,200);
itranspose.val:=frcrange32(a.i['transpose'],-127,127);
ispeed.val:=frcrange32(a.i['speed'],10,1000);
imode.val:=frcrange32(a.i['mode'],0,mmMax);
istyle.val:=frcrange32(a.i['style'],0,3);
iformats.val:=a.i['formats'];
ishownav:=a.b['shownav'];
ishowpiano:=a.b['showpiano'];
ishowinfo:=a.b['showinfo'];
ishowvis:=a.b['showvis'];
ijumpstatus :=frcrange32(a.i['jumpstatus'],0,2);
iholdmode :=frcrange32(a.i['holdmode'],0,5);
iholdoutline:=a.b['holdoutline'];
xnav_mask;
xname:=a.s['name'];
case (xname<>'') of
true:inav.value:=io__readportablefilename(io__asfolderNIL(a.s['folder']))+xname;//focus the previously playing track - 20feb2022
false:inav.folder:=io__readportablefilename(io__asfolderNIL(a.s['folder']));
end;
//.mutelist
itracks.settings:=a.s['mutelist0'];
ichannels.settings:=a.s['mutelist'];
inotes.settings:=a.s['mutelist2'];
//.playlist
iplaylist.partmask:=xmasklist;
iplaylist.xopen2(low__platprgext('m3u'),a.i['playlist.index'],false,false,e);
xmustsaveplaylist;//don't save now we've loaded it - 25mar2022
//.other
inotes.olayout:=frcrange32(a.i['notelayout'],0,3);
inotes.olabels:=a.b['notelabels'];
ilargejump:=a.b['largejump'];
ilargejumptitle:=a.b['largejumptitle'];
iautoplay:=a.b['autoplay'];//do after
iautotrim:=a.b['autotrim'];//11jan2025
showplaylist:=a.b['show.list'];
ipiano.keycount:=a.i['piano.keycount'];
ipiano.labelmode:=a.i['piano.labelmode'];
//sync
prgsettings.data:=a.data;
xupdatebuttons;
except;end;
try
freeobj(@a);
iloaded:=true;
except;end;
end;

procedure tapp.xsavesettings;
begin
xsavesettings2(true);
end;

procedure tapp.xsavesettings2(xforce:boolean);
var
   a:tvars8;
   e:string;
begin
try
//check
if not iloaded then exit;
//defaults
a:=nil;
a:=vnew2(951);
//get
a.b['show.list']:=showplaylist;//20mar2022
a.i['intro']:=frcrange32(iintro,0,4);
a.i['ff']:=frcrange32(iff,0,4);//19apr2022
a.i['midvol']:=frcrange32(mmsys_mid_basevol,0,200);
a.b['largejump']:=ilargejump;
a.b['largejumptitle']:=ilargejumptitle;
a.b['autoplay']:=iautoplay;
a.b['autotrim']:=iautotrim;
a.i['notelayout']:=inotes.olayout;
a.b['notelabels']:=inotes.olabels;
a.b['lshow']:=lshow;
a.b['lshowsep']:=lshowsep;
a.b['alwayson']:=ialwayson;
a.b['animateicon']:=ianimateicon;
a.i['xboxcontroller']:=ixboxcontroller;
a.b['xboxfeedback']:=ixboxfeedback;
a.b['list.showlinks']:=ishowlistlinks;
a.i['transpose']:=itranspose.val;
a.i['speed']:=ispeed.val;
a.i['mode']:=imode.val;
a.i['style']:=istyle.val;
a.i['formats']:=iformats.val;
a.s['folder']:=io__makeportablefilename(inav.folder);
a.s['name']:=io__extractfilename(inav.value);
a.s['mutelist0']:=itracks.settings;
a.s['mutelist']:=ichannels.settings;
a.s['mutelist2']:=inotes.settings;
a.b['shownav']:=ishownav;
a.b['showpiano']:=ishowpiano;
a.b['showinfo']:=ishowinfo;
a.b['showvis']:=ishowvis;

a.i['jumpstatus'] :=ijumpstatus;
a.i['holdmode'] :=iholdmode;
a.b['holdoutline']:=iholdoutline;
a.i['piano.keycount']:=ipiano.keycount;
a.i['piano.labelmode']:=ipiano.labelmode;

//a.s['playlist.filename']:=io__makeportablefilename(iplaylistfilenameOPEN);
a.i['playlist.index']:=ilist.itemindex;
if xmustsaveplaylist or xforce then iplaylist.xsave2(low__platprgext('m3u'),false,e);//25mar2022
inav.xto(inav,a,'nav');
//set
prgsettings.data:=a.data;
siSaveprgsettings;
except;end;
try;freeobj(@a);except;end;
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
str1:=itracks.settings+'|'+inotes.settings+'|'+ichannels.settings+'|'+intstr32(mmsys_mid_basevol)+'|'+intstr32(iplaylist.id)+'|'+intstr32(iintro)+'|'+intstr32(iff)+'|'+intstr32(ixboxcontroller)+'|'+bolstr(iholdoutline)+bnc(ixboxfeedback)+bnc(ishowlistlinks)+bnc(showplaylist)+bnc(lshow)+bnc(ianimateicon)+bnc(ialwayson)+bnc(lshowsep)+bnc(ishownav)+bnc(ishowpiano)+bnc(ishowinfo)+bnc(ishowvis)+bnc(ilargejumptitle)+bnc(ilargejump)+bnc(iautoplay)+bnc(iautotrim)+'|'+intstr32(ipiano.labelmode)+'|'+intstr32(inotes.olayout)+'|'+intstr32(ijumpstatus)+'|'+intstr32(ipiano.keycount)+'|'+intstr32(iholdmode)+'|'+intstr32(ispeed.val)+'|'+intstr32(vimididevice)+'|'+intstr32(istyle.val)+'|'+intstr32(imode.val)+'|'+intstr32(inav.sortstyle)+'|'+intstr32(iformats.val)+'|'+inav.folder;
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
   e:string;
begin//use for testing purposes only - 15mar2020
//defaults
xresult:=true;
e:=gecTaskfailed;

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
   if gui.mousedbclick and vidoubleclicks and (not iplaying) then imustplay:=true;
   goto skipend;
   end
else if zok and (sender=ijump) then
   begin
   imustpertpos:=ijump.hoverpert;
   goto skipend;
   end;

//get
if (xcode2='max') then
   begin
   if (gui.state='+') then gui.state:='n' else gui.state:='+';
   end
else if (xcode2='refresh') or (xcode2='nav.refresh') then//override "inav" refresh without our own
   begin
   inav.reload;
   ilastfilename:='';
   end
else if (xcode2='home') then
   begin
   inav.folder:='';
   ilastfilename:='';
   end
else if (xcode2='lshow') then lshow:=not lshow
else if (xcode2='lshowsep') then lshowsep:=not lshowsep
else if (xcode2='alwayson') then ialwayson:=not ialwayson//23mar2022
else if (xcode2='animateicon') then ianimateicon:=not ianimateicon//30apr2022
else if (xcode2='xbox.0') then ixboxcontroller:=0
else if (xcode2='xbox.1') then ixboxcontroller:=1
else if (xcode2='xbox.2') then ixboxcontroller:=2
else if (xcode2='xbox.f') then ixboxfeedback:=not ixboxfeedback
else if strmatch(strcopy1(xcode2,1,6),'intro:') then
   begin
   iintro:=frcrange32(strint(strcopy1(xcode2,7,length(xcode2))),0,4);
   end
else if strmatch(strcopy1(xcode2,1,3),'ff:') then
   begin
   iff:=frcrange32(strint(strcopy1(xcode2,4,length(xcode2))),0,4);
   end
else if (xcode2='list.showlinks') then ishowlistlinks:=not ishowlistlinks
else if (xcode2='list.edit') then ilist.showmenu2('playlist')
else if (xcode2='list.undo') then xresult:=iplaylist.undo(e)
else if (xcode2='list.new') then xresult:=iplaylist.new(e)
else if (xcode2='list.cut') then xresult:=iplaylist.cut(e)//20mar2022
else if (xcode2='list.copy') then xresult:=iplaylist.copy(e)
else if (xcode2='list.copyall') then xresult:=iplaylist.copyall(e)
else if (xcode2='list.paste') then xresult:=iplaylist.paste(e)
else if (xcode2='list.replace') then xresult:=iplaylist.replace(e)
else if (xcode2='list.open') then xresult:=iplaylist.open(e)
else if (xcode2='list.saveas') then xresult:=iplaylist.save(e)
else if (xcode2='show.list') then showplaylist:=true
else if (xcode2='show.folder') then showplaylist:=false
else if (xcode2='nav.toggle') then ishownav:=not ishownav
else if (xcode2='piano.toggle') then ishowpiano:=not ishowpiano
else if (xcode2='info.toggle') then ishowinfo:=not ishowinfo
else if (xcode2='vis.toggle') then ishowvis:=not ishowvis

else if (xcode2='menu') then
   begin
   if showplaylist then ilist.showmenu else inav.showmenu;
   end
else if (xcode2='tracks.menu') or (xcode2='ch.menu') or (xcode2='notes.menu') or (xcode2='piano.menu') or (xcode2='jump.menu') then ilist.showmenu2(xcode2)
else if (xcode2='prev') then
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
else if (xcode2='next') then
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
else if (xcode2='rewind') then mid_setpos(mid_pos-xffms)//10mar2021
else if (xcode2='fastforward') then mid_setpos(mid_pos+xffms)//10mar2021
else if (xcode2='stop') then imuststop:=true
else if (xcode2='play') then
   begin
   case iplaying of
   true:imuststop:=true;
   false:imustplay:=true;
   end;//case
   end
else if (xcode2='largejumptitle') then ilargejumptitle:=not ilargejumptitle
else if (xcode2='largejump') then ilargejump:=not ilargejump
else if (xcode2='layout.0') then inotes.olayout:=0
else if (xcode2='layout.1') then inotes.olayout:=1
else if (xcode2='layout.2') then inotes.olayout:=2
else if (xcode2='layout.3') then inotes.olayout:=3
else if (xcode2='labels.on') then inotes.olabels:=true
else if (xcode2='labels.off') then inotes.olabels:=false
else if (strcopy1(xcode2,1,16)='piano.labelmode.') then ipiano.labelmode:=strint32(strcopy1(xcode2,17,low__len(xcode2)))
else if (strcopy1(xcode2,1,15)='piano.keycount.') then ipiano.keycount:=strint32(strcopy1(xcode2,16,low__len(xcode2)))
else if (xcode2='autoplay') then iautoplay:=not iautoplay//16apr2021
else if (xcode2='autotrim') then iautotrim:=not iautotrim//11jan2025
else if (xcode2='saveas') then xsaveas
else if (xcode2='folder') then
   begin
   if (inav.folder<>'') then runLOW(inav.folder,'');
   end
else if (xcode2='tracks.muteall') then itracks.muteall(true)
else if (xcode2='tracks.unmuteall') then itracks.muteall(false)
else if (xcode2='ch.muteall') then ichannels.muteall(true)
else if (xcode2='ch.unmuteall') then ichannels.muteall(false)
else if (xcode2='notes.muteall') then inotes.muteall(true)
else if (xcode2='notes.unmuteall') then inotes.muteall(false)
else if (strcopy1(xcode2,1,9) ='holdmode.')  then iholdmode:=frcrange32(strint32(strcopy1(xcode2,10,low__len(xcode2))),0,5)
else if (xcode2='holdoutline') then iholdoutline:=not iholdoutline
else if (strcopy1(xcode2,1,11)='jumpstatus.')  then ijumpstatus:=frcrange32(strint32(strcopy1(xcode2,12,low__len(xcode2))),0,2)
else
   begin
   if system_debug then showbasic('Unknown Command>'+xcode2+'<<');
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
   bol1:boolean;
begin
try
//timer100
if (ms64>=itimer100) and iloaded then
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
   if low__setstr(ilyricref,bnc(lshow)+bnc(lshowsep)+bnc(mid_lyriccount>=1)+bnc(iplaying)+'|'+intstr32(mid_pos)+'|'+intstr32(mid_len)+'|'+ilastfilename) then
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
   itimer100:=ms64+100;
   end;

//infotimer
if (ms64>=iinfotimer) then
   begin
   //info
   if low__setstr(iinforef,intstr32(vimididevice)+'|'+bnc(xbox__info(-1).connected)+bnc(mid_deviceactive)+bnc(mid_keepopen)+bnc(mid_loop)+bnc(mid_playing)+'|'+k64(mid_midbytes)+'|'+intstr32(mid_transpose)+'|'+intstr32(mid_speed)+'|'+intstr32(mid_tracks)+'|'+intstr32(mid_format)+'|'+k64(iinfoid)+'|'+k64(mid_pos)+'|'+intstr32(iintro)+'|'+k64(mid_len)+'|'+k64(xintroms)+'|'+ilasterror+'|'+ilastfilename) then iinfo.paintnow;

   //reset
   iinfotimer:=ms64+100;
   end;

//timer350
if (ms64>=itimer350) then
   begin
   //page
   xupdatebuttons;
   //nav
   inav.xoff_toolbarsync(rootwin.xhead);
   //reset
   itimer350:=ms64+350;
   end;

//timer500
if (ms64>=itimer500) then
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
   itimer500:=ms64+500;
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
for ci:=0 to xbox__lastindex do
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
   p,xfileindex,xfilecount,xintro,xfilesize,xpos,xlen,int1:longint;
   xlagstr,str1:string;
   bol1,xhavefile:boolean;

   function xfilter(x,xdef:string):string;
   begin
   if xhavefile then result:=x else result:=xdef;
   end;
begin
result:=true;

try
xtep:=tepFNew20;
xtepcolor:=clnone;
xcaption:='';
xcaplabel:='';
xhelp:='';
xcode2:='';
xcode:=0;
xshortcut:=aknone;
xindent:=0;//xindex*5;
xflash:=false;//25mar2021
xenabled:=true;
xtitle:=false;//(xindex=3);
xsep:=false;
xhavefile:=iisfile;
xlen:=0;
xpos:=0;
xintro:=xintroms;
xfilesize:=mid_midbytes;
if xhavefile then
   begin
   xlen:=mid_len;
   xpos:=mid_pos;
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
//.lagstr - 50ms max - 24feb2022
int1:=mid_lag;
xlagstr:=insstr('+',int1>50)+intstr32(frcrange32(int1,0,50));

//.info
case xindex of
//technical
0:begin
   xtep:=tepnone;
   xcaption:='Technical';
   xtitle:=true;
   end;
1:xcaption:='Name'+#9+xfilter(io__extractfilename(ilastfilename),'-');
2:xcaption:='Folder'+#9+xfilter(io__extractfilepath(ilastfilename),'-');
3:xcaption:='Size'+#9+xfilter(low__b(xfilesize,true)+'  ( '+low__mb(xfilesize,true)+' )','-');
4:xcaption:='File'+#9+xfilter(k64(1+xfileindex)+' / '+k64(xfilecount),'-');
5:begin
   int1:=mid_format;
   case int1 of
   0:str1:='Single Track';
   1:str1:='Multi-Track';
   else str1:='Not Supported';
   end;
   xcaption:='Format'+#9+xfilter(intstr32(int1)+' / '+str1,'-');
   end;
6:xcaption:='Tracks'+#9+xfilter(k64(mid_tracks),'-');
7:xcaption:='Messages'+#9+xfilter(k64(mid_msgssent)+' / '+k64(mid_msgs),'-');
8:xcaption:='Resolution'+#9+xlagstr+' ms'+insstr('  ( Timing Boost )',not mid_usingtimer);//05mar2022
9:xcaption:='Device'+#9+low__aorbstr('Offline','Online',mid_deviceactive);//15apr2021
//playback
10:begin
   xtep:=tepnone;
   xcaption:='Playback';
   xtitle:=true;
   end;
11:xcaption:='Elapsed'+#9+low__uptime(xpos,(xlen>=3600000),(xlen>=60000),true,true,true,#32);
12:xcaption:='Remaining'+#9+low__uptime(xlen-xpos,(xlen>=3600000),(xlen>=60000),true,true,true,#32);
13:xcaption:='Total'+#9+low__uptime(xlen,(xlen>=3600000),(xlen>=60000),true,true,true,#32);
14:begin
   int1:=frcmin32(mid_lenfull-mid_len,0);
   xcaption:='Trim'+#9+low__aorbstr('Off',low__uptime(int1,false,false,false,true,true,#32)+' of silence',mid_trimtolastnote or (mid_lenfull<>mid_len));
   end;
15:xcaption:='Intro Mode'+#9+low__aorbstr('Off','First '+k64(xintro div 1000)+' seconds',xintro>0);
16:xcaption:='Speed'+#9+k64(mid_speed)+'%';
17:xcaption:='State'+#9+low__aorbstr('Stopped','Playing',mid_playing);
18:begin
   bol1:=false;
   if xbox__init then
      begin
      int1:=0;
      str1:='';

      for p:=0 to xbox__lastindex do if xbox__info(p).connected then
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
oroundstyle:=corNone;
iblocksize:=3;
iblockgap :=0;
iblockoveralsize:=iblocksize+iblockgap;
iblockcount:=1;
hint:='Midi Channel | Click to mute/unmute midi channel | Click and hold for 2 seconds to mute/unmute all midi channels';
oholdms:=1000;
ipainttimer:=ms64;
idownindex:=-1;
idowntimed:=false;
idataref:=0;
iclsref:='';

for p:=0 to high(iavevol) do iarea[p]:=nilarea;

xclear;

//start
if xstart then start;
end;

destructor tchannels.destroy;
begin
try
inherited destroy;
if classnameis('tchannels') then track__inc(satOther,-1);
except;end;
end;

procedure tchannels.xclear;
var
   p:longint;
begin
for p:=0 to high(iavevol) do
begin
irefvol[p].val:=0;
iavevol[p]:=0;
iholdvol[p]:=0;
ihold64[p]:=0;
imuted[p]:=false;
imuteoff64[p]:=0;
end;//p
end;

procedure tchannels.muteall(xmute:boolean);
var
   p:longint;
begin
for p:=0 to high(mmsys_mid_mutech) do mmsys_mid_mutech[p]:=xmute;
end;

function tchannels.xcalc:boolean;
var
   vave,vtotal,vtotalOUT,vcount,p2,p:longint;
   x64,xhold64:comp;
begin
//defaults
result:=false;
x64:=ms64;
if (oholdms<=0) then xhold64:=0 else xhold64:=add64(x64,oholdms);

try
//get
for p:=0 to high(iavevol) do
begin
vcount:=0;
vtotal:=0;
vtotalOUT:=0;

for p2:=0 to 127 do if (mmsys_mid_notevol[p][p2]>=1) then
   begin
   inc(vtotal    ,mmsys_mid_notevol[p][p2]);
   inc(vtotalOUT ,mmsys_mid_notevolOUT[p][p2]);
   inc(vcount    ,1);
   end;

vave     :=frcrange32( round( (frcrange32( round(vtotal/frcmin32(vcount,1)) ,0, 127)/127) * iblockcount),0,iblockcount-1);

if (vave>iavevol[p]) and (iavevol[p]>120) then
   begin
   //nil
   end
else if (vave>iavevol[p]) then vave:=(vave*3 + iavevol[p] ) div 4//fast rise
else if (vave<iavevol[p]) then vave:=(vave + iavevol[p] ) div 2;//slightly slower fall

vave:=frcrange32(vave,0,iblockcount-1);

if (vcount>=1) then
   begin
   if (vtotalOUT>=1) then imuteoff64[p]:=x64+1000;
   imuted[p]:=mmsys_mid_mutech[p] or (x64>=imuteoff64[p]);
   end;

if (vave>iholdvol[p]) or (x64>=ihold64[p]) then
   begin
   iholdvol[p]:=vave;
   ihold64[p]:=xhold64;
   end;

iavevol[p]:=vave;

//detect change
if (irefvol[p].bytes[0]<>iavevol[p]) or (irefvol[p].bytes[1]<>iholdvol[p]) or (irefvol[p].bytes[2]<>low__aorb(0,1,imuted[p])) or (irefvol[p].bytes[3]<>low__aorb(0,1,mmsys_mid_mutech[p])) then
   begin
   irefvol[p].bytes[0]:=iavevol[p];
   irefvol[p].bytes[1]:=iholdvol[p];
   irefvol[p].bytes[2]:=low__aorb(0,1,imuted[p]);
   irefvol[p].bytes[3]:=low__aorb(0,1,mmsys_mid_mutech[p]);
   result:=true;
   end;
end;//p

except;end;
end;

procedure tchannels._ontimer(sender:tobject);
var
   p:longint;
   bol1:boolean;
begin
if not xcanpaint then exit;

//toggle mute
if (idownindex>=0) and (idownindex<=high(mmsys_mid_mutech)) and focused and (not idowntimed) and gui.mousedown and (gui.mousedowntime>=2000) then
   begin
   idowntimed:=true;
   bol1:=not mmsys_mid_mutech[idownindex];
   for p:=0 to high(mmsys_mid_mutech) do mmsys_mid_mutech[p]:=bol1;
   end;

//paint timer
if (ms64>=ipainttimer) then
   begin
   if low__setint(idataref,mmsys_mid_dataref) then xclear;

   if xcalc then
      begin
      app__turbo;//faster response time
      paintnow;
      end;

   //reset
   ipainttimer:=ms64+25;//~40fps
   end;
end;

function tchannels.getalignheight(xclientwidth:longint):longint;
begin
result:=(110 div iblockoveralsize)*iblockoveralsize*vizoom;
iblockcount:=frcmin32((result div iblockoveralsize),1);
end;

function tchannels.getsettings:string;
var
   p:longint;
begin
low__setlen(result,high(mmsys_mid_mutech)+1);
for p:=0 to high(mmsys_mid_mutech) do result[p+stroffset]:=low__aorbchar('0','1',mmsys_mid_mutech[p]);
end;

procedure tchannels.setsettings(x:string);
var
   p:longint;
begin
if (x<>'') then
   begin
   for p:=0 to frcmax32(high(mmsys_mid_mutech),low__len(x)-1) do mmsys_mid_mutech[p]:=(x[p+stroffset]='1');//zero-based string access
   end;
end;

procedure tchannels.xbar(da:twinrect;xindex,xvol,xholdvol,xcolor,xfontcolor,fn,fnH,xfeather:longint;xround:boolean);
var
   xback,tw:longint;
   t:string;

   function v(xvol:longint):longint;
   begin
   result:=round((frcrange32(xvol,0,127)/127)*clientheight);
   result:=(result div iblockoveralsize)*iblockoveralsize;//whole units - 13feb2025: fixed
   end;

   procedure xdraw(xfrom,xto:longint);
   var
      i,sy,dy:longint;
   begin
   //check
   if (xto<xfrom) then exit;

   //get
   if (iblockgap<=0) then
      begin
      sy:=da.bottom-(xfrom*iblockoveralsize);
      dy:=da.bottom-(xto*iblockoveralsize)-iblockoveralsize+1;//-iblockgap-1;
      lds(area__make(da.left,dy,da.right,sy),xcolor,xround);
      end
   else
      begin
      for i:=xfrom to xto do
      begin
      dy:=da.bottom-((i+1)*iblockoveralsize);
      lds(area__make(da.left,dy,da.right,dy+iblockoveralsize-iblockgap-1),xcolor,xround);
      end;//i
      end;
   end;
begin
//range
xvol    :=frcrange32(xvol,0,iblockcount-1);
xholdvol:=frcrange32(xholdvol,0,iblockcount-1);

//init
xback :=info.mhover;

//background
lds(da,xback,xround);

//volume indicator
if (xvol>=1) then xdraw(0,xvol);

//hold volume indicator
if (xholdvol>=1) then xdraw(xholdvol,xholdvol);

//label
if mmsys_mid_mutech[xindex] then t:='m' else t:=intstr32(xindex);
tw:=low__fonttextwidth2(fn,t);

ldtTAB2(xback,tbnone,da,da.left+((da.right-da.left+1-tw) div 2),da.bottom-fnH,xfontcolor,t,fn,xfeather,false,false,false,false,false);

//paint over background
if vimaintainhighlight then ldbEXCLUDE(false,da,xround);
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
fn2    :=low__font0(s.info.fontname,-frcmin32(round(s.fnH*0.8),5));
fnH2   :=low__fontmaxh(fn2);

//background
if low__setstr(iclsref,intstr32(s.back)+'|'+intstr32(s.cs.right-s.cs.left+1)+'|'+intstr32(s.cs.bottom-s.cs.top+1)) then lds(s.cs,s.back,s.r);

//init
iw:=frcmin32(s.cw div 16,1);
sp:=frcmin32(frcmax32(5*s.zoom,iw-low__fontavew(s.fn)),0);

//bars
for p:=0 to high(iavevol) do
begin

da.top:=s.ci.top;
da.bottom:=s.ci.bottom;
da.left:=s.ci.left+(p*iw);
da.right:=frcmax32(da.left+iw-1-sp,s.ci.right);

xbar(da,p,iavevol[p],iholdvol[p],low__aorb(s.colhover,s.hover,imuted[p]),s.font,fn2,fnH2,s.f,s.r);

//.store area for mouse clicks
iarea[p]:=da;
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
if gui.mouseupstroke and (idownindex>=0) and (idownindex<=high(mmsys_mid_mutech)) then
   begin
   if idowntimed then
      begin
      //ignore
      end
   else
      begin
      mmsys_mid_mutech[idownindex]:=not mmsys_mid_mutech[idownindex];
      end;
   end;
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

ilastheight:=0;
ilasttrackcount:=-1;
iitemsperrow:=16;
ipainttimer:=ms64;
idownindex:=-1;
idowntimed:=false;
idataref:=0;
iinforef:='';
iclsref:='';

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
var
   p:longint;
begin
for p:=0 to high(iarea) do
begin
iref[p].val:=0;
iflash[p]:=false;
end;//p
end;

function ttracks.xcalc:boolean;
var
   p,xcount:longint;
begin
//defaults
result:=false;
xcount:=frcmin32(otrackcount,1);

for p:=0 to high(iarea) do
begin
if (p<xcount) then
   begin
   if (iref[p].bytes[0]<>low__aorb(0,1,mmsys_mid_mutetrack[p])) or mmsys_mid_mutetrack_hasvol[p] then
      begin
      iref[p].bytes[0]:=low__aorb(0,1,mmsys_mid_mutetrack[p]);

      if mmsys_mid_mutetrack_hasvol[p] then
         begin
         iflash[p]:=not iflash[p];
         mmsys_mid_mutetrack_hasvol[p]:=false;
         end;

      result:=true;
      end;
   end
else iref[p].val:=0;
end;//p

if low__setint(ilasttrackcount,xcount) then result:=true;
if low__setint(ilastheight,getalignheight(0)) then gui.fullalignpaint;
end;

procedure ttracks.muteall(xmute:boolean);
var
   p:longint;
begin
for p:=0 to high(mmsys_mid_mutetrack) do mmsys_mid_mutetrack[p]:=xmute;
end;

procedure ttracks._ontimer(sender:tobject);
var
   p:longint;
   bol1:boolean;
begin
if not xcanpaint then exit;

//toggle mute
if (idownindex>=0) and (idownindex<=high(mmsys_mid_mutetrack)) and focused and (not idowntimed) and gui.mousedown and (gui.mousedowntime>=2000) then
   begin
   idowntimed:=true;
   bol1:=not mmsys_mid_mutetrack[idownindex];
   for p:=0 to high(mmsys_mid_mutetrack) do mmsys_mid_mutetrack[p]:=bol1;
   end;

//paint timer
if (ms64>=ipainttimer) then
   begin
   if low__setint(idataref,mmsys_mid_dataref) then xclear;

   if xcalc then
      begin
      paintnow;
      app__turbo;
      end;

   //reset
   ipainttimer:=ms64+10;//~100fps
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

function ttracks.xrowheight(xclientheight:longint):longint;
begin
if (xclientheight<=0) then result:=(frcmin32(vifontheight,20)+(2*vizoom))*low__aorb(1,2,vitouch) else result:=frcmin32( (xclientheight div xrowcount) ,1);
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
   for p:=0 to frcmax32(high(mmsys_mid_mutetrack),low__len(x)-1) do mmsys_mid_mutetrack[p]:=(x[p+stroffset]='1');//zero-based string access
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
      mmsys_mid_mutetrack[idownindex]:=not mmsys_mid_mutetrack[idownindex];
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
   xhover2:longint;
   da:twinrect;
   t:string;
   dback0,dback2,dtrackcount,fn2,fnH2,sp,tw,dcount,dperrow,dx,dy,dw,dh,p:longint;
begin
try
//init
infovars(s);
dtrackcount :=frcrange32(otrackcount,0,1+high(iarea));
xhover2     :=int__dif24(s.colhover,20);
dback0      :=s.hover;
dback2      :=int__dif24(dback0,30);

//.smaller font
fn2         :=low__font0(s.info.fontname,-frcmin32(round(s.fnH*0.8),5));
fnH2        :=low__fontmaxh(fn2);

//background
if low__setstr(iclsref,intstr32(dtrackcount)+'|'+intstr32(s.back)+'|'+intstr32(s.cw)+'|'+intstr32(s.ch)) then lds(s.cs,s.back,s.r);

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

for p:=0 to (dtrackcount-1) do
begin
da.top     :=dy;
da.bottom  :=dy+dh-1;
da.left    :=dx;
da.right   :=dx+dw-1;
iarea[p]   :=da;

if mmsys_mid_mutetrack[p] then t:='m'
else                           t:=intstr32(1+p);

tw:=low__fonttextwidth2(fn2,t);

lds(da,low__aorb(low__aorb(s.hover,xhover2,iflash[p]),low__aorb(dback0,dback2,iflash[p]),mmsys_mid_mutetrack[p]),s.r);

if vimaintainhighlight then ldbEXCLUDE(false,da,s.r);

ldt1(s.back,da,da.left+((da.right-da.left+1-tw) div 2),da.top+((da.bottom-da.top+1-fnH2) div 2),s.font,t,fn2,s.f,s.r);

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
oholdoutline:=false;
olayout:=0;
olabels:=false;
oholdms:=1000;
iholdtimer:=ms64;
ipainttimer:=ms64;
idownindex:=-1;
idowntimed:=false;
idataref:=0;
iref:=-1;
iinforef:='';
iclsref:='';

for p:=0 to high(inoteref) do
begin
iarea[p]   :=nilarea;
ilabels[p] :=xmakelabel(p);
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
for p:=0 to high(inoteref) do
begin
inoteref[p] :=0;
ihold64[p]  :=0;
inotedc[p]  :=clnone;
iref2[p]    :=false;
end;
end;

procedure tnotes.muteall(xmute:boolean);
var
   p:longint;
begin
for p:=0 to high(mmsys_mid_mutenote) do mmsys_mid_mutenote[p]:=xmute;
end;

procedure tnotes._ontimer(sender:tobject);
var
   p:longint;
   bol1:boolean;
begin
if not xcanpaint then exit;

//animate notes
if (idownindex>=0) and (idownindex<=high(mmsys_mid_mutenote)) and focused and (not idowntimed) and gui.mousedown and (gui.mousedowntime>=2000) then
   begin
   idowntimed:=true;
   bol1:=not mmsys_mid_mutenote[idownindex];
   for p:=0 to high(mmsys_mid_mutenote) do mmsys_mid_mutenote[p]:=bol1;
   iref:=-1;//force repaint
   end;

//hold timer
if (ms64>=iholdtimer) then
   begin
   for p:=0 to high(ihold64) do if (ihold64[p]<>0) then
       begin
       iref:=-1;
       break;
       end;

   //iinforef
   if low__setstr(iinforef,bolstr(olabels)+'|'+intstr32(xlayout)) then iref:=-1;

   //reset
   iholdtimer:=ms64+250;
   end;

//paint timer
if (ms64>=ipainttimer) then
   begin
   if low__setint(idataref,mmsys_mid_dataref) then xclear;

   if low__setint(iref,mmsys_mid_notesref) then
      begin
      paintnow;
      app__turbo;
      end;

   //reset
   ipainttimer:=ms64+10;//~100fps
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
   for p:=0 to frcmax32(high(mmsys_mid_mutenote),low__len(x)-1) do mmsys_mid_mutenote[p]:=(x[p+stroffset]='1');//zero-based string access
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
      mmsys_mid_mutenote[idownindex]:=not mmsys_mid_mutenote[idownindex];
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
   x64,xhold64:comp;
   dback0,dback1,dback2,dhover2,i,sp,tw,dcount,dperrow,dx,dy,dw,dh,vout,v,dc,p,p2:longint;
begin
try
//init
infovars(s);
x64:=ms64;
if (oholdms<=0) then xhold64:=0 else xhold64:=x64+oholdms;//11jan2025
dhover2:=int__dif24(s.colhover,20);
dback0:=s.hover;
dback1:=int__dif24(dback0,20);
dback2:=int__dif24(dback0,30);

//background
if low__setstr(iclsref,intstr32(s.back)+'|'+intstr32(s.cs.right-s.cs.left+1)+'|'+intstr32(s.cs.bottom-s.cs.top+1)) then lds(s.cs,s.back,s.r);

//init
sp:=2*s.zoom;
dperrow:=frcmin32(xnotesperrow,1);
dh:=frcmin32( xrowheight(s.ch)-sp ,1);
dw:=frcmin32( (s.cw div dperrow)-sp ,1);

//cells
dcount:=xnoteoffset;
dx:=sp+(dcount*(dw+sp));
dy:=sp;

for p:=0 to high(inoteref) do
begin
v       :=0;
vout    :=0;

for p2:=0 to 15 do
begin
if (mmsys_mid_notevol[p2][p]>=v)       then v:=mmsys_mid_notevol[p2][p];
if (mmsys_mid_notevolOUT[p2][p]>=vout) then vout:=mmsys_mid_notevolOUT[p2][p];
end;


da.top:=dy;
da.bottom:=dy+dh-1;
da.left:=dx;
da.right:=dx+dw-1;
iarea[p]:=da;


if (v>=1) then
   begin
   if low__setint(inoteref[p],mmsys_mid_noteref[p]) then iref2[p]:=not iref2[p];

   case mmsys_mid_mutenote[p] or (vout<=0) of
   true:dc:=low__aorb(dback2,dback1,iref2[p]);
   else dc:=low__aorb(s.colhover,dhover2,iref2[p]);
   end;//case

   inotedc[p]:=dc;
   ihold64[p]:=xhold64;

   lds(da,dc,s.r);
   end
else
   begin
   lds(da,dback0,s.r);

   if (ihold64[p]>=x64) then
      begin
      dc:=inotedc[p];

      if oholdoutline then
         begin
         ldo(da,dc,s.r);
         ldo(area__grow(da,-1),dc,s.r);
         end
      else lds(area__make(da.left,da.bottom-(2*vizoom),da.right,da.bottom),dc,s.r);

      end
   else
      begin
      ihold64[p]:=0;
      end;
   end;


if mmsys_mid_mutenote[p] then t:='m'
else if olabels          then t:=ilabels[p]
else                          t:=intstr32(p);

tw:=low__fonttextwidth2(s.fn,t);

if (v>=1) and vimaintainhighlight then ldbEXCLUDE(false,da,s.r);

ldt1(s.back,da,da.left+((da.right-da.left+1-tw) div 2),da.top+((da.bottom-da.top+1-s.fnH) div 2),s.font,t,s.fn,s.f,s.r);

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

oroundstyle:=corNone;
ilabelmode:=1;
ikeycount:=88;
ipainttimer:=ms64;
idataref:=0;
iref:=-1;
iclsref:='';
iwcount:=0;
ibcount:=0;

//.white keys
wbottom  :=ggga0__int(180);
wside    :=ggga0__int(220);
wtop     :=ggga0__int(250);

//.black keys
bbottom  :=ggga0__int(150);
bside    :=ggga0__int(200);
btop     :=ggga0__int(0);

for p:=0 to high(inoteflash) do
begin
inoteflash[p]:=false;
inotecount[p]:=0;
end;//p

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
   xlabel:string;

   procedure wadd(xindex:longint);
   begin
   if (iwcount>high(iwlist)) then exit;
   iwlist[iwcount]:=xindex;
   iwcap[iwcount]:=xlabel;
   inc(iwcount);
   end;

   procedure badd(xindex:longint);
   begin
   if (ibcount>high(iblist)) then exit;
   iblist[ibcount]:=xindex;
   iblist2[ibcount]:=iwcount;//white key position
   ibcap[iwcount]:=xlabel;
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
for p:=xfrom to frcmax32(xto,high(iwlist)) do if xwhitekey(p,xlabel) then wadd(p) else badd(p);
end;

procedure tpiano.xclear;
var
   p:longint;
begin
for p:=0 to high(inotecount) do
begin
inotecount[p]:=0;
inoteflash[p]:=false;
end;//p
end;

procedure tpiano._ontimer(sender:tobject);
begin
if not xcanpaint then exit;

//paint timer
if (ms64>=ipainttimer) then
   begin
   if low__setint(idataref,mmsys_mid_dataref) then xclear;

   if low__setint(iref,mmsys_mid_notesref) then
      begin
      paintnow;
      app__turbo;
      end;

   //reset
   ipainttimer:=ms64+10;//~100fps
   end;
end;

function tpiano.getalignheight(xclientwidth:longint):longint;
begin
result:=frcmax32( frcmin32(round(xclientwidth*0.09),10), round(gui.height*0.3) );//height scaled to width BUT do not exceed 30% of gui.height
end;

function tpiano.xwhitekey(x:longint;var xlabel:string):boolean;
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
   xlabelmode,fn2,fnH2,wupshift1,wupshift2,bupshift1,bupshift2,sx,dx,dy,wh,bh,ww,bw,whover1,whover2,bhover1,bhover2,p,v:longint;
   bol1,xflash:boolean;

   function nc(xindex:longint):longint;//note count
   var
      vold:longint;
   begin
   xindex:=frcrange32(xindex,0,high(inotecount));
   vold:=inotecount[xindex];

   if low__setint(inotecount[xindex],mmsys_mid_notecount[xindex]) then
      begin
      //key was down -> flash the key
      if (vold>=1) and (inotecount[xindex]>=1) then inoteflash[xindex]:=not inoteflash[xindex]
      else                                          inoteflash[xindex]:=false;
      end;

   xflash:=inoteflash[xindex];
   result:=inotecount[xindex];
   end;

   procedure dk(da:twinrect;ddown,dtoggle,dwhitekey:boolean;dlabel:string);//draw key
   var
      d:twinrect;
      bs,tw,dbottom,dside,dtop,c,p,dshift:longint;

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
      c        :=low__aorb(wtop,low__aorb(whover1,whover2,dtoggle),ddown);
      dbottom  :=wbottom;
      dside    :=wside;
      dtop     :=wtop;
      dshift   :=low__aorb(0, low__aorb(wupshift2,wupshift1,xflash) ,ddown);
      end
   else
      begin
      c        :=low__aorb(btop, low__aorb(bhover1,bhover2,dtoggle) ,ddown);
      dbottom  :=bbottom;
      dside    :=bside;
      dtop     :=btop;
      dshift   :=low__aorb(0,low__aorb(bupshift2,bupshift1,xflash),ddown);
      end;

   //top of key -> color as normal or in down state
   lds(area__make(da.left+bs,da.top,da.right-bs,da.bottom-bs-dshift),c,false);

   ldbEXCLUDE(false,area__make(da.left,da.top,da.right,da.bottom-dshift),false);

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
xlabelmode:=ilabelmode;

//.white keys
whover1  :=int__splice24(0.80,wbottom,s.colhover);
whover2  :=int__dif24(whover1,20);
wh       :=s.ch;
ww       :=s.cw div frcmin32(iwcount,1);
wupshift2:=5*s.zoom;//standard shift
wupshift1:=3*s.zoom;//smaller flash based shift

//.black keys
bhover1  :=int__splice24(0.80,0,s.colhover);
bhover2  :=int__dif24(bhover1,20);
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
if low__setstr(iclsref,intstr32(s.back)+'|'+intstr32(s.cs.right-s.cs.left+1)+'|'+intstr32(s.cs.bottom-s.cs.top+1)) then lds(s.cs,s.back,s.r)
else
   begin
   //quick cls -> wipe out key shift areas (upshift)
   lds(area__make(sx,bh-1-wupshift2,sx+(iwcount*ww)-1,bh-1),s.back,false);//black keys
   lds(area__make(sx,wh-1-wupshift2,sx+(iwcount*ww)-1,wh-1),s.back,false);//white keys
   end;

//white keys
for p:=0 to (iwcount-1) do
begin
dx:=sx+(p*ww);
v:=nc(iwlist[p]);

//.labelmode
case iwlist[p] of
60   :bol1:=(xlabelmode=3) or (xlabelmode=2) or (xlabelmode=1);//middle C
65   :bol1:=(xlabelmode=3) or (xlabelmode=2);//middle C+F
else  bol1:=(xlabelmode=3);//all
end;

da:=area__make(dx,dy,dx+ww-1,dy+wh-1);
dk(da,v>=1,xflash,true,insstr(iwcap[p],bol1));
end;//p

//black keys
for p:=0 to (ibcount-1) do
begin
dx:=sx+(iblist2[p]*ww)-(ww div 2)+((ww-bw) div 2);
v:=nc(iblist[p]);
da:=area__make(dx,dy,dx+bw-1,dy+bh-1);
dk(da,v>=1,xflash,false,insstr(ibcap[p],xlabelmode=3));
end;//p


//ldbEXCLUDE(false,area__make(sx,0,sx + (iwcount*ww) -1 ,cs.bottom),false);
except;end;
end;

end.
