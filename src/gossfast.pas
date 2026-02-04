unit gossfast;

interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef WIN64}{$define 64bit}{$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gosswin2, gossroot, gossimg, gossio {$ifdef snd},gosssnd{$endif} ,gosswin {$ifdef gui},gossdat{$endif};
{$align on}{$iochecks on}{$O+}{$W-}{$U+}{$V+}{$B-}{$X+}{$T-}{$P+}{$H+}{$J-} { set critical compiler conditionals for proper compilation - 10aug2025 }
//## ==========================================================================================================================================================================================================================
//##
//## MIT License
//##
//## Copyright 2026 Blaiz Enterprises ( http://www.blaizenterprises.com )
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
//## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OfF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//## CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//##
//## ==========================================================================================================================================================================================================================
//## Library.................. FastDraw (gossfast.pas)
//## Version.................. 4.00.3605 (+57)
//## Items.................... 7
//## Last Updated ............ 01feb2026, 07jan2026, 05jan2025, 01jan2026, 29dec2025, 26dec2025, 25dec2025, 24dec2025, 22dec2025, 19dec2025
//## Lines of Code............ 11,100+
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
//## Important Image Format Note:
//##
//## To modify or replace any of the embedded "tep_*" images below, e.g. "tep_copy20", any new images must be in the TEA image
//## format and packed in a binary pascal array.  A free gui tool is available at http://www.blaizenterprises.com/blaiztools.html
//## which provides one button actions for pasting and converting images into the TEA format as well as packing them into pascal arrays.
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | ling__*                | family of procs   | 1.00.302  | 24dec2025   | Little image proc -> supports images up to 16x16 @ 32bit - 22dec2025
//## | res__*                 | family of procs   | 1.00.170  | 22dec2025   | Manage system resources -> fonts, fontchars, teps etc - 19dec2025
//## | rescache__*            | family of procs   | 1.00.070  | 22dec2025   | Cache commonly used/reused objects for high-speed use
//## | fd__*                  | family of procs   | 1.00.2402 | 01feb2026   | FastDraw high-speed graphic procs for 24/32 bit image operations - 07jan2026, 05jan2026, 01jan2026, 29dec2025, 26dec2025, 25dec2025, 24dec2025, 22dec2025
//## | tresfont               | tobject           | 1.00.202  | 22dec2025   | Dynamic font manager -> create font characters as compressed RLE8's on-the-fly when needed - 19dec2025
//## | tresfontchar           | tobject           | 1.00.302  | 22dec2025   | RLE8 compressed font character with dual feather and dual color support - 19dec2025
//## | tfontmapper            | tobject           | 1.00.100  | 19dec2025   | Map a font character to a RLE8 image stream
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


const

   //fastdraw codes ------------------------------------------------------------
   fd_nil                    =0;

   //.get bol
   fd_getflip                =100;
   fd_getmirror              =101;

   //.set bol
   fd_setflip                =150;
   fd_setmirror              =151;

   //.get val -> fd__getval()
   fd_getdrawProc            =200;
   fd_getpower               =201;
   fd_getsplice              =202;

   fd_getAreaMode            =203;
   fd_getClipMode            =204;
   fd_getAreaMode2           =205;
   fd_getClipMode2           =206;

   fd_getcolor1              =220;
   fd_getcolor2              =221;
   fd_getcolor3              =222;
   fd_getcolor4              =223;

   //.set val -> fd__setval()
   fd_setpower               =301;
   fd_setsplice              =302;

   fd_setcolor1              =320;
   fd_setcolor2              =321;
   fd_setcolor3              =322;
   fd_setcolor4              =323;

   fd_setlayer               =330;

   //.get area
   fd_getarea                =400;
   fd_getclip                =401;
   fd_getbufferarea          =402;
   fd_getarea2               =403;
   fd_getclip2               =404;
   fd_getbufferarea2         =405;

   //.set area -> fd__setarea() and fd__setarea2()
   fd_setarea                =500;//set target buffer draw area
   fd_setclip                =501;//set target buffer clip region
   fd_setarea2               =502;//set source buffer draw area
   fd_setclip2               =503;//set source buffer clip region
   fd_setarea12              =504;//set both target and source buffer draw area
   fd_setclip12              =505;//set both target and source buffer clip region

   //.set -> fd__set()
   fd_errors                 =600;//turn error reporting on
   fd_noerrors               =601;//turn it off

   fd_optimise               =602;//turn optimisations on
   fd_nooptimise             =603;//turn it off

   fd_flip                   =604;
   fd_noflip                 =605;

   fd_mirror                 =606;
   fd_nomirror               =607;

   fd_roundNone              =610;//disable round support
   fd_roundCorner            =611;//turn on round support with standard corners
   fd_roundCornerTight       =612;//turn on round support with tight corners

   fd_roundmodeAll           =614;
   fd_roundmodeTopOnly       =615;
   fd_roundmodeBotOnly       =616;
   fd_roundmodeNone          =617;

   fd_storeClip              =620;
   fd_restoreClip            =621;
   fd_storeClip2             =622;
   fd_restoreClip2           =623;
   fd_storeArea              =624;
   fd_restoreArea            =625;
   fd_storeArea2             =626;
   fd_restoreArea2           =627;
   fd_swapArea12             =628;

   fd_trimAreaToFitBuffer    =629;
   fd_trimAreaToFitBuffer2   =630;

   fd_fillAreaDefaults       =650;

   //.buffer
   fd_setbuffer              =800;//set target buffer and info
   fd_setbuffer2             =801;//set source buffer and info
   fd_setbuffer12            =802;//set both buffers as same
   fd_setbufferFromBuffer2   =803;//copy buffer2 info to buffer info
   fd_setbuffer2FromBuffer   =804;//copy buffer info to buffer2 info

   //.render
   fd_roundStartFromArea     =900;//capture round corners from area
   fd_roundStartFromAreaDebug=901;//capture round corners from area with a color for visible debug
   fd_roundStartFromClip     =902;//capture round corners from clip
   fd_roundStopAndRender     =903;//draw captured round corners
   fd_roundStopAndRenderDebug=904;//draw captured round corners with a color for visible debug

   fd_fillArea               =910;//draw rectangule
   fd_fillSmallArea          =911;//optimised for areas 30x30 or less
   fd_sketchArea             =912;//draw edge portions of rectangle (fast rect draw for base controls)
   fd_shadeArea              =913;
   fd_drawPixels             =950;//draw image pixels "b2 -> b"


   //information values
   fd_area_outside_clip      =1000;
   fd_area_inside_clip       =1001;
   fd_area_overlaps_clip     =1002;

   //error codes
   fd_propertyMismatch       =1100;
   fd_selectUsedInvalidSlot  =1101;


   //range values
   fdr_pixelcount32_limit    =100000000;//100 mil

   {$ifdef d3}
   fdr_pixelcount64_limit    =1000000000000000.0;//1,000 trillion
   {$else}
   fdr_pixelcount64_limit    =1000000000000000;//1,000 trillion
   {$endif}

   //little image limits - 23dec2025
   ling_width             =11;
   ling_height            =11;

   //init code
   init_notset            =0;
   init_ok                =1234;
   init_err               =9;

   //resource types
   rest_none              =0;
   rest_font              =1;
   rest_fontchar          =2;
   rest_fastdraw          =3;
   rest_str8              =4;
   rest_tep               =5;
   rest_maxtype           =5;

   //slot range
   res_limit              =10000;//10,000 slots
   res_max                =res_limit-1;
   res_nil                =0;//first slot is reserved for "nil" status

   //font
   fontchar_maxindex      =255;//0..255

   //fastdraw
   area_outside           =0;
   area_inside            =1;
   area_overlaps          =2;


type

   tresslot               =longint32;//24dec2025
   tresfont               =class;
   tresfontchar           =class;
   tfontmapper            =class;


   //common records ------------------------------------------------------------

   //.ttimesample
   ptimesample=^ttimesample;
   ttimesample=packed record

    ref64        :longint64;
    timeTotal    :longint64;
    timeCount    :longint64;
    timeAve      :double;

    //.host tag options
    tag1         :longint32;
    tag2         :longint32;

    end;

   ttimesamplecore=array[0..49] of ttimesample;

   //.ling - little image
   plingrow=^tlingrow;
   tlingrow=array[0..(ling_width-1)] of tcolor32;

   pling=^tling;
   tling=packed record

    w           :longint32;
    h           :longint32;
    pixels      :array[0..(ling_height-1)] of tlingrow;//???????array[0..(ling_width-1)] of tcolor32;
    ref32       :tcolor32;

    end;


   //fastdraw ------------------------------------------------------------------

   tfastdrawrendermps=packed record

     time1000     :longint64;
     lastmps64    :longint64;
     rendermps    :double;

     end;

   pfastdrawbuffer=^tfastdrawbuffer;
   tfastdrawbuffer=packed record

     ok           :boolean;//true=buffer is OK to use, false=not setup -> can't use buffer -> error
     bits         :longint32;
     rows         :pcolorrows32;//supports 24 and 32 bit image matrixes
     w            :longint32;
     h            :longint32;

     //.clip area always within buffer bounds of (0,0,w-1,h-1) and the default value after setting a buffer
     cx1          :longint32;
     cx2          :longint32;
     cy1          :longint32;
     cy2          :longint32;

     //.area - can be outside bounds of clip/image
     ax1          :longint32;
     ax2          :longint32;
     ay1          :longint32;
     ay2          :longint32;
     aw           :longint32;
     ah           :longint32;
     amode        :longint32;//holds state of outside, inside or overlaps

     //.store area -> optional store/restore values
     scok         :boolean;
     scx1         :longint32;
     scx2         :longint32;
     scy1         :longint32;
     scy2         :longint32;

     saok         :boolean;
     sax1         :longint32;
     sax2         :longint32;
     say1         :longint32;
     say2         :longint32;
     saw          :longint32;
     sah          :longint32;
     samode       :longint32;//holds state of outside, inside or overlaps

     end;

   pfastdrawround=^tfastdrawround;
   tfastdrawround=packed record

    rok         :boolean;

    rx1         :longint32;
    rx2         :longint32;
    ry1         :longint32;
    ry2         :longint32;
    rmode       :longint32;//e.g. amode=inside buffer or overlap etc

    rtl         :tling;
    rtr         :tling;
    rbr         :tling;
    rbl         :tling;

    end;

   pfastdraw=^tfastdraw;
   tfastdraw=packed record

    //buffers
    b           :tfastdrawbuffer;//buffer 1
    b2          :tfastdrawbuffer;//buffer 2
    t           :tfastdrawbuffer;//temp buffer 1
    t2          :tfastdrawbuffer;//temp buffer 2

    //gui layer support
    lr8         :pcolorrows8;//nil=off
    lv8         :longint32;

    //colors
    color1      :tcolor32;
    color2      :tcolor32;
    color3      :tcolor32;
    color4      :tcolor32;

    //round support
    rindex      :longint32;//default=-1
    rmode       :longint32;//roundMode=rmAll=0 (all corners)
    rimage      :pling;//always points to a valid image handle (image maybe empty, e.g. w=0, h=0)
    rlist       :array[0..39] of tfastdrawround;

    //misc
    flip        :boolean;
    mirror      :boolean;
    power255    :longint32;
    splice100   :longint32;

    //tracking
    drawProc    :longint32;//track which draw proc was used for the requested draw action

    end;

   tfastdrawobj=class(tobject)
   public
    core:tfastdraw;
   end;


   //cache support -------------------------------------------------------------
   //speed note: using type conversion, e.g. "v:=(a as tbitmap).width" doubles access time compared to "v:=a.width"

   trescache_str8=record

    use:array[0..9999] of boolean;
    obj:array[0..9999] of tstr8;

    end;

   trescache_font=record

    use:array[0..99] of boolean;
    obj:array[0..99] of tresfont;

    end;

   trescache_fontchar=record

    use:array[0..999] of boolean;
    obj:array[0..999] of tresfontchar;

    end;

   trescache_fastdraw=record//31dec2025

    use:array[0..99] of boolean;
    obj:array[0..99] of tfastdrawobj;

    end;


   presdrawfastinfo=^tresdrawfastinfo;
   tresdrawfastinfo=packed record

    //.init code
    initcode     :longint32;//must be set to "init_ok" to prove the record has been properly setup for execution
    proccode     :longint32;//id of proc used to draw rle8 onto target buffer

    //.image buffer
    bits         :longint32;//supports 24 and 32
    imgarea      :twinrect;//image safe area -> always within the "0,0 .. w-1,h-1" of image -> assumed safe at the paint proc level
    rs24         :pcolorrows24;
    rs32         :pcolorrows32;

    //.rle8 character data stream
    core         :tstr8;//rle8 core -> pointer only

    //.paint info
    layer        :byte;//window layer -> for use within the GUI system
    round        :boolean;//round corners are applied at the "imagearea" level
    clip         :twinrect;//area of rs24/rs32 or less -> assumed to be safe range
    x            :longint32;
    y            :longint32;
    colorA       :longint32;//main color for shades 1..253 and 255 - tepColor
    colorB       :longint32;//secondary color for shade 254 - tepColor2
    feather255A  :longint32;//our feather       - 0=sharp, 127=medium feather, 255=full feather
    feather255B  :longint32;//greyscale feather - 0=sharp, 127=medium feather, 255=full feather

    //.options
    flip         :boolean;
    mirror       :boolean;
    power255     :longint32;
    zoom         :longint32;

    //.pre-calculated values -> set internally via "rle8__drawfast__init()" proc -> calc once, use many times
    clen         :longint32;//core len32
    cpos         :longint32;//core data start position
    cw           :longint32;//core width
    ch           :longint32;

    color24A     :tcolor24;//color 1 - 24bit
    color24B     :tcolor24;//color 2 - 24bit

    color32A     :tcolor32;//color 1 - 32bit
    color32B     :tcolor32;//color 2 - 32bit

    end;

{tresfontinfo}
    presfontinfo=^tresfontinfo;
    tresfontinfo=record

     name      :string;
     size      :longint32;
     grey      :boolean;
     bold      :boolean;

     height   :longint32;
     height1  :longint32;

     wmin     :longint32;
     wmax     :longint32;
     wave     :longint32;

     wlist    :array[0..fontchar_maxindex] of longint32;//width for each character in font
     cslot    :array[0..fontchar_maxindex] of longint32;//system slot for each character, 0=nil=not set

     end;


{trescore}
   tresinfo=packed record

    restype :byte;//restype=0=res_none => slot not in use
    id      :longint32;//increments each time slot is deleted or created -> persists for life of slot system
    data    :tobject;

    end;

   trescore=packed record

    //core
    count       :longint32;
    list        :array[0..9999] of tresinfo;

    //support
    newcount    :longint32;
    delcount    :longint32;
    newlast     :longint32;
    timerlast   :longint32;
    timer100    :longint64;
    timer500    :longint64;

    //fontmappers -> dynamically created when required - 01jan2026
    fontmappers :array[0..9] of tfontmapper;

    //fallback handlers -> dynamically created when required - 01jan2026
    fstr8         :tstr8;
    ffont         :tresfont;
    ffontchar     :tresfontchar;
    ffastdraw     :tfastdrawobj;

    end;


{tfontmapper}
   tfontmapper=class(tobject)
   private

    itime       :longint64;
    icore       :twinbmp;
    ifontname   :string;//internal only
    ifontsize   :longint32;//internal only
    iname       :string;
    isize       :longint32;
    igrey       :boolean;
    ibold       :boolean;
    iscanwidth  :longint32;
    iscanheight :longint32;

    procedure xmoretime;

   public

    //create
    constructor create; virtual;
    destructor destroy; override;

    //information
    property name    :string       read iname;
    property size    :longint32    read isize;
    property grey    :boolean      read igrey;
    property bold    :boolean      read ibold;
    property time    :longint64    read itime;

    //clear
    function canclear:boolean;
    function clear:boolean;

    //workers
    procedure setparams(const xname:string;const xsize:longint;const xgrey,xbold:boolean;var xfontinfo:tresfontinfo);
    function makechar(const xcharindex:longint;const xoutdata:tstr8;var xfontinfo:tresfontinfo):boolean;

    //support
    procedure slowtimer;

   end;


{tresfont}
//11111111111111111111111
    tresfont=class(tobject)
    private

     icore       :tresfontinfo;
     ipcore      :presfontinfo;
     ifontname   :string;
     ifontsize   :longint;

     function getname:string;
     function getsize:longint;
     function getgrey:boolean;
     function getbold:boolean;
     function getheight:longint;
     function getheight1:longint;
     function getwmin:longint;
     function getwmax:longint;
     function getwave:longint;
     function getwlist(xindex:longint):longint;
     procedure xscanFont;
     procedure xneedBasics;
     procedure xneedChar(const xindex:longint32);

    public

     //create
     constructor create; virtual;
     destructor destroy; override;

     //information
     function charcount:longint32;//number of characters currently loaded for font
     function rescount:longint32;//number of system slots used for font
     function bytes:longint64;//size of font in memory

     property core                       :presfontinfo      read ipcore;

     property fontname                   :string            read ifontname;
     property fontsize                   :longint32         read ifontsize;
     property name                       :string            read getname;
     property size                       :longint32         read getsize;
     property grey                       :boolean           read getgrey;
     property bold                       :boolean           read getbold;
     property height                     :longint32         read getheight;
     property height1                    :longint32         read getheight1;

     property wmin                       :longint32         read getwmin;
     property wmax                       :longint32         read getwmax;
     property wave                       :longint32         read getwave;
     property wlist[xindex:longint32]    :longint32         read getwlist;

     //clear
     procedure clear;

     //workers
     procedure setparams(const xname:string;const xsize:longint32;const xgrey,xbold:boolean);

     procedure needchars(const x:string);
     procedure needcharRange(const xcharindex_from,xcharindex_to:longint32);
     function textwidth(const xtab,x:string):longint32;
     function textwidth2(const xtab:string;const x:tstr8):longint32;

     //support
     procedure slowtimer;
     procedure syncName;//detects change in system font names "$fontname" and "$fontname2"

    end;


{tresfontchar}
    tresfontchar=class(tobject)
    private

     itimeout    :byte;
     ifont       :tresfont;//pointer to host "resfont" object
     icharindex  :longint32;
     icore       :tstr8;

     function getwidth:longint;
     function getheight:longint;
     procedure xmoretime;

    public

     //create
     constructor create; virtual;
     destructor destroy; override;

     //information
     property core                      :tstr8         read icore;
     function bytes                     :longint64;

     property font                      :tresfont      read ifont;//pointer only
     property charindex                 :longint32     read icharindex;

     property width                     :longint32     read getwidth;
     property height                    :longint32     read getheight;

     property timeout                   :byte          read itimeout;//counts down to 0

     //workers
     procedure setparams(const xfont:tresfont;const xcharindex:longint);

     //make char
     function make:boolean;

     //clear
     function canclear:boolean;
     procedure clear;

     //support
     procedure slowtimer;

    end;


var
   system_started_res        :boolean=false;
   system_rescore            :trescore;

   rescache_font             :trescache_font;
   rescache_fontchar         :trescache_fontchar;
   rescache_str8             :trescache_str8;
   rescache_fastdraw         :trescache_fastdraw;

   //.ling - system little images
   resling_nil               :tling;
   resling_corner            :tling;
   resling_corner200         :tling;//01feb2026
   resling_cornerTight       :tling;
   resling_cls               :tling;
   resling_cls2              :tling;

   //.time sample support
   ressample_core            :ttimesamplecore;

   //.fastdraw support
   fd_focus                  :pfastdraw;//assumed to always point to a valid record, e.g. never nil - 31dec2025
   fd_optimise_ok            :boolean=true;
   fd_errors_ok              :boolean=false;
   fd_errors_count           :longint32=0;
   fd_track_ok               :boolean=true;
   fd_pixelcount32           :longint32=0;
   fd_pixelcount64           :longint64=0;
   fd_drawProc32             :longint32=0;
   fd_rendermps              :tfastdrawrendermps;

   rescol_white32            :tcolor32;
   rescol_black32            :tcolor32;


//start-stop procs -------------------------------------------------------------

procedure gossres__start;
procedure gossres__stop;


//info procs -------------------------------------------------------------------

function app__info(xname:string):string;
function info__fast(xname:string):string;//information specific to this unit of code - 01feb2026


//misc procs -------------------------------------------------------------------
function rateTable__row(xtimeTakenMS:longint64;const xtotalPixels,xsizeW,xsizeH,xframebufferW,xframebufferH,xframebufferBits:longint;const xflip,xmirror:boolean;xoptions:string):string;


//rescache procs ---------------------------------------------------------------

function rescache__newFont:tresfont;
function rescache__delFont(x:pobject):boolean;

function rescache__newFontChar:tresfontchar;
function rescache__delFontChar(x:pobject):boolean;

function rescache__newStr8:tstr8;
function rescache__delStr8(x:pobject):boolean;

function rescache__newFastdraw:tfastdrawobj;
function rescache__delFastdraw(x:pobject):boolean;


//resource procs ---------------------------------------------------------------

procedure res__slowtimer;
function res__limit:longint;//max number of usable slots
function res__count:longint;//number of slots in use
function res__nil:tresslot;
function res__newcount:longint32;
function res__delcount:longint32;

//.new
function res__new(const xtype:longint):tresslot;//0=failure=nil
function res__newstr8:tresslot;

function res__newfont:tresslot;
function res__newfont2(const xname:string;const xsize:longint;const xgrey,xbold:boolean):tresslot;

function res__newfontchar:longint32;
function res__newfontchar2(const xfont:tresfont;const xcharindex:longint32):tresslot;

function res__newFastdraw:tresslot;//22dec2025

//.del
function res__del(const xslot:longint):tresslot;

//.find
function res__findfontmapper(const xfindBYfont:tresfont):tfontmapper;

//.checkers
function res__type(const xslot:tresslot):longint;
function res__ok(const xslot:tresslot):boolean;
function res__IDok(const xslot:tresslot;const xid:longint):boolean;
function res__typeok(const xslot:tresslot;const xid,xtype:longint):boolean;
function res__dataok(const xslot:tresslot;const xtype:longint):boolean;//22dec2025

//.typed replies
function res__str8(const xslot:tresslot):tstr8;

function res__font(const xslot:tresslot):tresfont;
function res__fontchar(const xslot:tresslot):tresfontchar;
procedure res__needchars(const xslot:tresslot;const x:string);
procedure res__needcharRange(const xslot:tresslot;const xcharindex_from,xcharindex_to:longint);
function res__textwidth(const xslot:tresslot;const xtab,x:string):longint;
function res__textwidth2(const xslot:tresslot;const xtab:string;const x:tstr8):longint;
function res__fastdraw(const xslot:tresslot):tfastdrawobj;



//font support procs -----------------------------------------------------------

procedure font__clearinfo(var x:tresfontinfo);
function font__tab(const xtab:string;xcolindex,xfontheight,xwidthlimit:longint;var xcolalign,xcolcount,xcolwidth,xtotalwidth,x1,x2:longint):boolean;//23feb2021
function fontchar__maxindex:longint;


//rle8 procs -------------------------------------------------------------------

//procedure rle8__drawfast0(const ximage:tobject;const dclip:twinrect;const dx,dy,dcolor,dcolor2,dfeather255,dfeather2552:longint);
//procedure rle8__drawfast(const x:tresdrawfastinfo);

function rle8__drawfast__init(var x:tresdrawfastinfo):boolean;
procedure rle8__drawfast(var x:tresdrawfastinfo);
procedure rle8__drawfast24(var x:tresdrawfastinfo);
procedure rle8__drawfast32(var x:tresdrawfastinfo);


//ling procs (little image) ----------------------------------------------------

procedure ling__size(var s:tling;const dw,dh:longint);
procedure ling__cls(var s:tling);//fast - 23dec2025
procedure ling__cls2(var s:tling;const r,g,b,a:byte);//24dec2025
procedure ling__clsSlow(var s:tling;const r,g,b,a:byte);//24dec2025

function ling__flip_mirror(var s:tling;const xflip,xmirror:boolean):boolean;
function ling__makeFromPattern(var s:tling;const r,g,b:byte;const spattern:string):boolean;//23dec2025

procedure ling__draw(var x:tfastdraw;const s:tling);//auto calls proc ling__draw101..103
procedure ling__draw101__flip_mirror(var x:tfastdraw;const s:tling);
procedure ling__draw102__flip_mirror_cliprange(var x:tfastdraw;const s:tling);
procedure ling__draw103__flip_mirror_cliprange_layer(var x:tfastdraw;const s:tling);


//time sample procs ------------------------------------------------------------

procedure resSample__resetAll;

function ressample__slotok(const xslot:longint32):boolean;
procedure ressample__reset(const xslot:longint32);

function ressample__tag1(const xslot:longint32):longint32;
function ressample__tag2(const xslot:longint32):longint32;
procedure ressample__settag1(const xslot,xval:longint32);
procedure ressample__settag2(const xslot,xval:longint32);

procedure ressample__start(const xslot:longint32);
procedure ressample__stop(const xslot:longint32);
procedure ressample__show(const xslot:longint32;const xlabel:string);


//fastdraw procs ---------------------------------------------------------------

//fffffffffffffffffffffffffffffffffffff//??????????????????????
function fd__renderMPS:double;
procedure fd__showerror(const xerrcode,xcode:longint);//for debug purposes

procedure fd__selectRoot;
procedure fd__select(const x:tresslot);//set focus slot
procedure fd__selStore(var x:pfastdraw);
procedure fd__selRestore(var x:pfastdraw);
procedure fd__defaults;//set slot to default state (e.g. flush)

function fd__new:tresslot;
procedure fd__del(var x:tresslot);

procedure fd__setBuffer(const xcode:longint32;const xval:tobject);
procedure fd__setLayerMask(const xval:tobject);

//example usage #1: "fd__render( fd_fillarea )" colors in area on buffer
//example usage #2: "fd__render( fd_drawpixels )" renders pixels from buffer2 onto buffer via area
procedure fd__render(const xcode:longint32);

procedure fd__set(const xcode:longint32);//01feb2026

function fd__getbol(const xcode:longint32):boolean;
procedure fd__setbol(const xcode:longint32;const xval:boolean);

function fd__getval(const xcode:longint):longint32;
procedure fd__setval(const xcode,xval:longint32);

procedure fd__getrgba(const xcode:longint;var r,g,b,a:byte);
procedure fd__setrgba(const xcode:longint32;const r,g,b,a:byte);

function fd__getarea(const xcode:longint):twinrect;
procedure fd__getarea2(const xcode:longint;var x,y,w,h:longint32);

procedure fd__setarea(const xcode:longint;const x:twinrect);
procedure fd__setarea2(const xcode:longint;const x,y,w,h:longint32);


//.support procs -> internal use only, do not call directly --------------------
procedure xfd__roundStart(const xcode:longint32);
procedure xfd__roundEnd(const xdebug:boolean);

procedure xfd__fillArea;//01jan2026, 25dec2025
procedure xfd__fillarea300_layer_2432;//01jan2026, 29dec2025, 26dec2025, 24dec2025
procedure xfd__fillarea400_layer_power255_24;//01jan2026
procedure xfd__fillarea500_layer_power255_32;//01jan2026

procedure xfd__sketchArea;//06jan2026 - fills in area edge portions when round mode is one -> allows a base control to only fill a little of its surface area, allowing for the child control(s) to do the rest and save on render time - 05jan2026
procedure xfd__sketchArea350_layer_2432;//05jan2026

procedure xfd__shadeArea;//07jan2026
procedure xfd__shadeArea1300_layer_2432;//07jan2026
procedure xfd__shadeArea1400_layer_power255_24;//07jan2026
procedure xfd__shadeArea1500_layer_power255_32;//07jan2026

procedure xfd__fillSmallArea;//07jan2026
procedure xfd__fillSmallArea1600_layer_2432;//07jan2026
procedure xfd__fillSmallArea1700_layer_power255_2432;//07jan2026

procedure xfd__drawPixels;
procedure xfd__drawPixels500;
procedure xfd__drawPixels600;
procedure xfd__drawPixels700_power255;//06jan2026, 29dec2025
procedure xfd__drawPixels800_flip_mirror_cliprange;
procedure xfd__drawPixels900_power255_flip_mirror_cliprange;

procedure xfd__lingCapture_template_flip_mirror_nochecks(var x:tfastdraw;var xb:tfastdrawbuffer;const xdestImage:pling);
procedure xfd__ling_makedebug(var x:tling);

procedure xfd__inc32(const xval:longint32);
procedure xfd__inc64;

procedure xfd__sync_amode(var x:tfastdrawbuffer);
procedure xfd__trimAreaToFitBuffer(var x:tfastdrawbuffer);

function xfd__canrow96(const x:tfastdrawbuffer;const xmin,xmax:longint32;var lx1,lx2,rx1,rx2,xfrom96,xto96:longint32):boolean;//01jan2026
function xfd__canrow962(const xbits,xmin,xmax:longint32;var lx1,lx2,rx1,rx2,xfrom96,xto96:longint32):boolean;//01jan2026

procedure xfd__defaults(var x:tfastdraw);


implementation

uses main{$ifdef gui}, gossgui{$endif};


//start-stop procs -------------------------------------------------------------
procedure gossres__start;
var
   p:longint;
begin
try

//check
if system_started_res then exit else system_started_res:=true;


//init
low__cls(@system_rescore,sizeof(system_rescore));

low__cls(@resling_cls  ,sizeof(resling_cls));//23dec2025
low__cls(@resling_cls2 ,sizeof(resling_cls2));//23ec2025


//.colors
rescol_white32.r    :=255;
rescol_white32.g    :=255;
rescol_white32.b    :=255;
rescol_white32.a    :=255;

rescol_black32.r    :=0;
rescol_black32.g    :=0;
rescol_black32.b    :=0;
rescol_black32.a    :=255;


//resSample --------------------------------------------------------------------

low__cls(@ressample_core,sizeof(ressample_core));


//rescaches --------------------------------------------------------------------

low__cls( @rescache_str8          ,sizeof(rescache_str8)        );
low__cls( @rescache_font          ,sizeof(rescache_font)        );
low__cls( @rescache_fontchar      ,sizeof(rescache_fontchar)    );
low__cls( @rescache_fastdraw      ,sizeof(rescache_fastdraw)    );


//fastdraw ---------------------------------------------------------------------

fd__selectRoot;//default to system slot => "system_rescore.ffastdraw"
fd__defaults;//apply default values
low__cls(@fd_rendermps,sizeof(fd_rendermps));


//system masks -----------------------------------------------------------------

//.nil
resling_nil.w:=0;
resling_nil.h:=0;

//.standard corner - top-left
ling__makeFromPattern(resling_corner,255,0,0,
'+++/'  +
'++/'   +
'+/'    +
'+/'    +
'+/'    +
'');

//.tight corner - top-left
ling__makeFromPattern(resling_cornerTight,255,0,0,
'+/'  +
'');


//.standard corner - top-left
ling__makeFromPattern(resling_corner200,255,0,0,
'++++++/'  +
'+++++/'  +
'++++/'   +
'+++/'   +
'++/'    +
'++/'    +
'++/'    +
'+/'    +
'+/'    +
'+/'    +
'');

except;end;
end;

procedure gossres__stop;
var
   p:longint;

   procedure afree(const x:tobject);
   begin
   if (x<>nil) then freeobj(@x);
   end;

begin
try

//check
if not system_started_res then exit else system_started_res:=false;


//.free slot objects
system_rescore.count:=0;
for p:=0 to pred(res_limit) do if (system_rescore.list[p].data<>nil) then freeobj(@system_rescore.list[p].data);


//.free font mappers
for p:=0 to high(system_rescore.fontmappers) do if (system_rescore.fontmappers[p]<>nil) then freeobj(@system_rescore.fontmappers[p]);


//.free fallback objects
freeobj(@system_rescore.fstr8);
freeobj(@system_rescore.ffont);
freeobj(@system_rescore.ffontchar);
freeobj(@system_rescore.ffastdraw);


//.free caches
for p:=0 to high(rescache_font.obj)          do afree(rescache_font.obj[p]);
for p:=0 to high(rescache_fontchar.obj)      do afree(rescache_fontchar.obj[p]);
for p:=0 to high(rescache_str8.obj)          do afree(rescache_str8.obj[p]);
for p:=0 to high(rescache_fastdraw.obj)      do afree(rescache_fastdraw.obj[p]);

except;end;
end;


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__fast(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gossfast.*"
if (strcopy1(xname,1,9)='gossfast.') then strdel1(xname,1,9) else exit;

//get
if      (xname='ver')        then result:='4.00.3605'
else if (xname='date')       then result:='01feb2026'
else if (xname='name')       then result:='FastDraw'
else
   begin
   //nil
   end;

except;end;
end;


function rateTable__row(xtimeTakenMS:longint64;const xtotalPixels,xsizeW,xsizeH,xframebufferW,xframebufferH,xframebufferBits:longint;const xflip,xmirror:boolean;xoptions:string):string;
const
   xspace='                         ';//25c
var
   xmps,xfps:double;

   function xpad(const xval:string;const xlen:longint):string;
   begin

   result:=#32+xval;
   result:=result+strcopy1(xspace,1,xlen-low__len32(result));

   end;
   //--------------------+--------------+---------------+-----------------------+
   // Rate               | Size         | Options       | Frame Buffer          |
   //--------------------+--------------+---------------+-----------------------+
   // 220 mps / 106 fps  | 5 x 5        | Normal        | 1920 x 1080 @ 24 bit  |
begin

//init
if (xtimeTakenMS<1) then xtimeTakenMS:=1;

xmps  :=xtotalPixels * (1000/xtimeTakenMS) * (1/1000) * (1/1000);
xfps  :=xmps/2.07;

xoptions:=strdefb(insstr('Flip ',xflip)+insstr('Mirror ',xMirror)+xoptions,'Normal ');


//get
result:=
'   //'+
   xpad( curdec(xmps,1,true)+' mps / '+curdec(xfps,1,true)+' fps',24)+'|'+
   xpad( k64(xsizeW)+' x '+k64(xsizeH),14)+'|'+
   xpad( xoptions,15)+'|'+
   xpad( k64(xframeBufferW)+' x '+k64(xframeBufferH)+' @ '+k64(xframebufferBits)+' bit',24)+'|';

end;


//res procs --------------------------------------------------------------------

procedure res__slowtimer;
var
   p:longint32;
begin


//timer100
if (slowms64>=system_rescore.timer100) then
   begin

   //slot slowtimers -> 100 slots/100ms -> 1000 slots/sec
   if (system_rescore.count>=1) then
      begin

      for p:=0 to 99 do
      begin

      //check slot
      if (system_rescore.list[ system_rescore.timerlast ].restype<>rest_none) and (system_rescore.list[ system_rescore.timerlast ].data<>nil) then
         begin

         case system_rescore.list[ system_rescore.timerlast ].restype of
         rest_font       :(system_rescore.list[ system_rescore.timerlast ].data as tresfont).slowtimer;
         rest_fontchar   :(system_rescore.list[ system_rescore.timerlast ].data as tresfontchar).slowtimer;
         end;//case

         end;

      //inc
      inc(system_rescore.timerlast);
      if (system_rescore.timerlast>res_max) then system_rescore.timerlast:=0;

      end;//p

      end;

   //reset
   system_rescore.timer100:=add64(slowms64,100);

   end;


//timer500
if (slowms64>=system_rescore.timer500) then
   begin

   //font mappers
   for p:=0 to high(system_rescore.fontmappers) do if (system_rescore.fontmappers[p]<>nil) then system_rescore.fontmappers[p].slowtimer;

   //reset
   system_rescore.timer500:=add64(slowms64,500);

   end;

end;

function res__limit:longint;
begin
result:=res_limit;
end;

function res__count:longint;
begin
result:=system_rescore.count;
end;

function res__nil:tresslot;
begin
result:=res_nil;
end;

function res__newcount:longint32;
begin
result:=system_rescore.newcount;
end;

function res__delcount:longint32;
begin
result:=system_rescore.delcount;
end;

function res__new(const xtype:longint):tresslot;//0=failure=nil
var
   i,p:longint32;
begin

//find first available slot
if (xtype>rest_none) and (xtype<=rest_maxtype) then
   begin

   i:=system_rescore.newlast;

   for p:=0 to pred(res_max) do
   begin

   if (i=0) then inc(i);

   if ( system_rescore.list[i].restype=rest_none ) then
      begin

      rollid32(system_rescore.list[i].id);//id persists for life of system

      result                          :=i;
      system_rescore.newlast          :=i;//speeds up slot finding in real world conditions - 19dec2025

      system_rescore.list[i].restype  :=xtype;
      system_rescore.list[i].data     :=nil;

      inc(system_rescore.count);

      //inc newcount
      roll32(system_rescore.newcount);

      //done
      exit;

      end;

   //inc
   inc(i);
   if (i>res_max) then i:=res_nil+1;

   end;//p

   end;

//else return nil
result:=res_nil;

end;

function res__newstr8:tresslot;
begin

result:=res__new(rest_str8);

if (result<>res_nil) then
   begin

    system_rescore.list[ result ].data:=rescache__newStr8;

   end;

end;

function res__newfont:tresslot;
begin

result:=res__new(rest_font);

if (result<>res_nil) then
   begin

    system_rescore.list[ result ].data:=rescache__newfont;

   end;

end;

function res__newfont2(const xname:string;const xsize:longint;const xgrey,xbold:boolean):tresslot;
begin

result:=res__newfont;

if (result<>res_nil) then
   begin

   (system_rescore.list[ result ].data as tresfont).setparams( xname ,xsize ,xgrey ,xbold );

   end;

end;

function res__newfontchar:tresslot;
begin

result:=res__new(rest_fontchar);

end;

function res__newfontchar2(const xfont:tresfont;const xcharindex:longint32):tresslot;
begin

result:=res__newfontchar;

if (result<>res_nil) then
   begin

    system_rescore.list[ result ].data:=rescache__newfontchar;
   (system_rescore.list[ result ].data as tresfontchar).setparams( xfont ,xcharindex );

   end;

end;

function res__newFastdraw:tresslot;//22dec2025
begin

result:=res__new(rest_fastdraw);

if (result<>res_nil) then
   begin

   system_rescore.list[ result ].data:=rescache__newFastdraw;

   end;

end;

function res__del(const xslot:tresslot):tresslot;
var
   p:longint;
begin

//inc delcount
roll32(system_rescore.delcount);

//defaults
result:=res_nil;

//delete slot
if (xslot>res_nil) and (xslot<res_limit) and ( system_rescore.list[xslot].restype<>rest_none ) then
   begin

   rollid32(system_rescore.list[xslot].id);//id persists for life of system

   //   if (system_rescore.list[xslot].data<>nil) then freeobj(@system_rescore.list[xslot].data);
   if (system_rescore.list[xslot].data<>nil) then
      begin

      case system_rescore.list[xslot].restype of
      rest_font          :rescache__delFont          (@system_rescore.list[xslot].data);
      rest_fontchar      :rescache__delFontChar      (@system_rescore.list[xslot].data);
      rest_str8          :rescache__delStr8          (@system_rescore.list[xslot].data);
      rest_fastdraw      :rescache__delFastdraw      (@system_rescore.list[xslot].data);
      else freeobj(@system_rescore.list[xslot].data);
      end;//case

      end;

   system_rescore.newlast              :=xslot;
   system_rescore.count                :=frcmin32(system_rescore.count-1,0);
   system_rescore.list[xslot].restype  :=rest_none;

   end;

end;

function res__findfontmapper(const xfindBYfont:tresfont):tfontmapper;
var
   p:longint32;
begin

//defaults
result:=nil;

//check
if (xfindBYfont=nil) then
   begin

   if (system_rescore.fontmappers[0]=nil) then system_rescore.fontmappers[0]:=tfontmapper.create;//01jan2026
   result:=system_rescore.fontmappers[0];
   exit;

   end;

//find exact match
for p:=0 to high(system_rescore.fontmappers) do
begin

if       (system_rescore.fontmappers[p]<>nil)                        and
         (system_rescore.fontmappers[p].size=xfindBYfont.fontsize)   and
         (system_rescore.fontmappers[p].grey=xfindBYfont.core^.grey) and
         (system_rescore.fontmappers[p].bold=xfindBYfont.core^.bold) and
 strmatch(system_rescore.fontmappers[p].name,xfindBYfont.fontname)   then
    begin

    result:=system_rescore.fontmappers[p];
    exit;

    end;

end;//p

//find first free slot OR oldest slot
for p:=0 to high(system_rescore.fontmappers) do
begin

if (system_rescore.fontmappers[p]=nil) then
   begin

   system_rescore.fontmappers[p]:=tfontmapper.create;
   result:=system_rescore.fontmappers[p];
   exit;

   end

else if (result=nil) or (system_rescore.fontmappers[p].time<result.time) then
   begin

   result:=system_rescore.fontmappers[p];

   end;

end;//p

end;

function res__type(const xslot:tresslot):longint;
begin

case (xslot>res_nil) and (xslot<res_limit) of
true:result:=system_rescore.list[xslot].restype;
else result:=rest_none;
end;//case

end;

function res__ok(const xslot:tresslot):boolean;
begin

result:=(xslot>res_nil) and (xslot<res_limit) and ( system_rescore.list[xslot].restype <> rest_none );

end;

function res__IDok(const xslot:tresslot;const xid:longint):boolean;
begin

result:=(xslot>res_nil) and (xslot<res_limit) and (system_rescore.list[xslot].id=xid) and ( system_rescore.list[xslot].restype <> rest_none );

end;

function res__TYPEok(const xslot:tresslot;const xid,xtype:longint):boolean;
begin

result:=(xslot>res_nil) and (xslot<res_limit) and (xtype=system_rescore.list[xslot].restype) and ((xid=0) or (xid=system_rescore.list[xslot].id));

end;

function res__dataok(const xslot:tresslot;const xtype:longint):boolean;//22dec2025
begin

result:=(xslot>res_nil) and (xslot<res_limit) and (xtype=system_rescore.list[xslot].restype) and (system_rescore.list[xslot].data<>nil);

end;

function res__str8(const xslot:tresslot):tstr8;
begin

case res__dataok(xslot,rest_str8) of
true:result:=(system_rescore.list[xslot].data as tstr8);
else begin

   if (system_rescore.fstr8=nil) then system_rescore.fstr8:=str__new8;
   result:=system_rescore.fstr8;//fallback

   end;
end;//case

end;


function res__font(const xslot:tresslot):tresfont;
begin

case res__dataok(xslot,rest_font) of
true:result:=(system_rescore.list[xslot].data as tresfont);
else begin

   if (system_rescore.ffont=nil) then system_rescore.ffont:=tresfont.create;
   result:=system_rescore.ffont;//fallback

   end;
end;//case

end;

function res__fontchar(const xslot:tresslot):tresfontchar;
begin

case res__dataok(xslot,rest_fontchar) of
true:result:=(system_rescore.list[xslot].data as tresfontchar);
else begin

   if (system_rescore.ffontchar=nil) then system_rescore.ffontchar:=tresfontchar.create;
   result:=system_rescore.ffontchar;//fallback

   end;
end;//case

end;

procedure res__needchars(const xslot:tresslot;const x:string);
begin
res__font(xslot).needchars(x);
end;

procedure res__needcharRange(const xslot:tresslot;const xcharindex_from,xcharindex_to:longint);
begin
res__font(xslot).needcharRange(xcharindex_from,xcharindex_to);
end;

function res__textwidth(const xslot:tresslot;const xtab,x:string):longint;
begin
result:=res__font(xslot).textwidth(xtab,x);
end;

function res__textwidth2(const xslot:tresslot;const xtab:string;const x:tstr8):longint;
begin
result:=res__font(xslot).textwidth2(xtab,x);
end;

function res__fastdraw(const xslot:tresslot):tfastdrawobj;
begin

case res__dataok(xslot,rest_fastdraw) of
true:result:=(system_rescore.list[xslot].data as tfastdrawobj);
else begin

   if (system_rescore.ffastdraw=nil) then system_rescore.ffastdraw:=tfastdrawobj.create;
   result:=system_rescore.ffastdraw;//fallback

   end;
end;//case

end;


//slotfont procs ---------------------------------------------------------------

procedure font__clearinfo(var x:tresfontinfo);
begin

with x do
begin

name      :='';
size      :=0;
grey      :=false;
bold      :=false;

height    :=0;
height1   :=0;

wmin      :=0;
wmax      :=0;
wave      :=0;

end;

low__cls(@x.wlist,sizeof(x.wlist));
low__cls(@x.cslot,sizeof(x.cslot));

end;

function font__tab(const xtab:string;xcolindex,xfontheight,xwidthlimit:longint;var xcolalign,xcolcount,xcolwidth,xtotalwidth,x1,x2:longint):boolean;//23feb2021
var
   xratio:extended;
   xsep,lwidth,xcount:longint;
   w:array[0..9] of longint;
   a:array[0..9] of longint;

   procedure dtab;
   var
      p:longint;
   begin

   //init
   x1          :=0;
   x2          :=0;
   xcolcount   :=xcount;

   //get
   for p:=0 to pred(xcount) do
   begin

   if (p<=xcolindex) then
      begin

      x1:=xtotalwidth+xsep;
      x2:=frcmin32(xtotalwidth + w[p] - 1 - xsep, x1);

      end;

   inc(xtotalwidth, w[p]);

   end;//p

   //set
   xcolwidth :=frcmin32(x2-x1+1,0);
   result    :=(xcolindex>=0) and (xcolindex<xcolcount);

   if result then xcolalign:=a[xcolindex];

   end;

   procedure xcustom;//expects simple tab format: "r80;l90;c100;"
   var
      lp,xlen,p:longint;
   begin

   //init
   xsep      :=trunc(5*xratio);
   xlen      :=low__len32(xtab);
   xcount    :=0;        //32
   lwidth    :=0;

   //get
   lp:=1;
   for p:=1 to xlen do if (xtab[p-1+stroffset]=';') then
      begin

      //.alignment
      case byte(xtab[lp-1+stroffset]) of
      llL,uuL:a[xcount]:=taL;
      llC,uuC:a[xcount]:=taC;
      llR,uuR:a[xcount]:=taR;
      else    a[xcount]:=taL;
      end;

      //.width
      w[xcount]:=trunc(xratio * frcmin32(strint32( strcopy1(xtab,lp+1,p-lp-1) ),1) );

      //.xwidthlimit - optional
      if (xwidthlimit>=1) then w[xcount]:=frcmax32( w[xcount], frcmin32( xwidthlimit - lwidth,0 ) );

      //.inc
      lp:=p+1;
      inc(lwidth, w[xcount]);
      inc(xcount);
      if (xcount>high(a)) then break;

      end;//p

   //calc
   dtab;

   end;
begin

//defaults
result:=false;

//range
if (xcolindex<0)   then xcolindex   :=0;
if (xfontheight<8) then xfontheight :=8;

//init
xcolalign   :=taL;//left
xcolcount   :=0;
xcolwidth   :=0;
xtotalwidth :=0;
x1          :=0;
x2          :=0;
xratio      :=(xfontheight/tbFontheight);//height is locked to "14px" above

if (xratio<1) then xratio:=1;

//get
if (xtab<>'') then xcustom;

end;

function fontchar__maxindex:longint;
begin
result:=fontchar_maxindex;
end;


//## tfontmapper ###############################################################

constructor tfontmapper.create;
begin

//self
inherited create;

//vars
icore       :=nil;//create on-the-fly
ifontname   :='';
ifontsize   :=0;
iname       :='';
isize       :=0;
igrey       :=false;
ibold       :=false;
iscanwidth  :=0;
iscanheight :=0;

//moretime
xmoretime;

end;

destructor tfontmapper.destroy;
begin
try

//vars
if (icore<>nil) then freeobj(@icore);

//self
inherited destroy;

except;end;
end;

procedure tfontmapper.xmoretime;
begin
itime:=add64(slowms64,30000);
end;

procedure tfontmapper.slowtimer;
begin

if (itime<>0) and (slowms64>=itime) then
   begin

   if canclear then clear;

   end;

end;

function tfontmapper.canclear:boolean;
begin
result:=(icore<>nil) and ((icore.width>1) or (icore.height>1));
end;

function tfontmapper.clear:boolean;
begin

result :=true;//pass-thru
itime  :=0;

if canclear then missize(icore,1,1);

end;

procedure tfontmapper.setparams(const xname:string;const xsize:longint;const xgrey,xbold:boolean;var xfontinfo:tresfontinfo);
var
   dgrey,xok:boolean;
   dmaxh,dmaxh1,dmaxw,p:longint32;
   dwh:tpoint;
begin

//sync -------------------------------------------------------------------------

xok    :=false;
iname  :=xname;
isize  :=xsize;

if not strmatch( ifontname ,strdefb(xname,'arial') ) then
   begin

   ifontname  :=strdefb(xname,'arial');
   xok        :=true;

   end;

case (xsize>=0) of//allow a negative range which specifies fontsize via height in pixels - 11apr2020
true:if low__setint(ifontsize,frcmin32(xsize,2)) then xok:=true;
else if low__setint(ifontsize,xsize)             then xok:=true;
end;

if low__setbol(igrey,xgrey)                      then xok:=true;
if low__setbol(ibold,xbold)                      then xok:=true;
if (icore=nil)                                   then xok:=true;

//check -> nothing to do
if not xok then exit;


//init -------------------------------------------------------------------------

xmoretime;

if (icore=nil) then icore:=miswin32(1,1);


//get -> basic font info -------------------------------------------------------

//init
dgrey      :=igrey and (isize>6);//disable greyscale at low resolutions to avoid extensive blurring - 20dec2025

//init
dmaxw      :=1;
dmaxh      :=1;
dmaxh1     :=1;//use A-D (no drop parts like "Q" has)

//get
//showbasic(bolstr(dgrey));//????????
//icore.setfont(ifontname,not dgrey,ibold,ifontsize,0,int_255_255_255);//27aug2025
icore.setfont(ifontname,false,ibold,ifontsize,0,int_255_255_255);//27aug2025

for p:=0 to fontchar_maxindex do
begin

dwh:=wincanvas__textextent( icore.dc ,char(p) );

if (dwh.x<1)     then dwh.x:=1      else if (dwh.x>max16) then dwh.x:=max16;
if (dwh.y<1)     then dwh.y:=1      else if (dwh.y>max16) then dwh.y:=max16;
if (dwh.x>dmaxw) then dmaxw:=dwh.x;
if (dwh.y>dmaxh) then dmaxh:=dwh.y;

if (dwh.x>=1) then xfontinfo.wlist[p]:=dwh.x else xfontinfo.wlist[p]:=1;

end;//p

//.finalise
iscanwidth       :=frcmin32(dmaxw,1);
iscanheight      :=frcmin32(dmaxh,1);
xfontinfo.height :=iscanheight;

end;

function tfontmapper.makechar(const xcharindex:longint;const xoutdata:tstr8;var xfontinfo:tresfontinfo):boolean;
label
   skipend;
var
   dleft,sx,sy,xleft,xright,aw,ah,xpad:longint32;
   dlen,dval:byte;
   xcanheight1,xheight1:boolean;
//   dlist5:array[0..1275] of longint;//for fast "div 5" math

   function sval(const sy,sx:longint):byte;//3x3 blur matrix
   var//Note: Encodes a dual feather -> our feather=[1..8], greyscale feather=[9..253], color2=254, color1=255
      v:longint;
   begin

   //get
   result:=255-icore.prows32[sy][sx].r;//invert -> for shades of black 0..255 -> where 255=full color strength and 0=no color

   //no blur for 254/255 = full color A and color B
   if (result>=254) then exit

   //no color -> apply blur here to generate some color as an optional feather and store bottom 8 shades (1..8)
   else if (result=0) then
      begin

      //center pixel
      v:=0;

      //x-1 -> left
      if (sx>=1)     then inc(v,255-icore.prows32[sy][sx-1].r);

      //x+1 -> right
      if (sx<(aw-1)) then inc(v,255-icore.prows32[sy][sx+1].r);

      //y-1 -> above
      if (sy>=1)     then inc(v,255-icore.prows32[sy-1][sx].r);

      //y+1 -> below
      if (sy<(ah-1)) then inc(v,255-icore.prows32[sy+1][sx].r);

      //blur -> reduce shade value from 0..255 -> 0..8 -> this bandwidth is reserved for out custom feather
      result:=v div 128;//was: dlist5[v] div 32;

      end
   //shift greyscale feather range 1..8 -> 9 to avoid corrupting our feather bandwidth
   else if (result<9) then result:=9;

   end;

begin

//defaults
result:=false;

//check
if (xcharindex<0) or (xcharindex>fontchar_maxindex) or (icore=nil) then exit;

//clear
case (xoutdata<>nil) of
true:xoutdata.clear;
else exit;
end;

//init
//for sx:=0 to high(dlist5) do dlist5[sx]:=sx div 5;

xpad     :=frcrange32( round32( iscanwidth * 0.1 ) ,2 ,20 );//widen capture area to allow for left/right boundary overlap detection - 20apr2020
aw       :=frcrange32( iscanwidth + (2*xpad) ,1 ,max16 );
ah       :=frcrange32( iscanheight ,1 ,max16 );

//check
if (xfontinfo.wlist[xcharindex]>aw) then exit;//something went wrong

//.size
if (aw<>icore.width) or (ah<>icore.height) then missize(icore,aw,ah);

//.cls entire area of "icore" + draw char indented by "xpad" from left to allow boundary overlap scanning - 20apr2020
wincanvas__textrect( icore.dc ,false ,misrect(0,0,aw,ah),xpad ,0 ,char(xcharindex) );


//detect left char boundary ----------------------------------------------------

xleft   :=aw-1;
dleft   :=xleft;

for sy:=0 to pred(ah) do
begin

//.non-white background -> text pixels
for sx:=dleft downto 0 do if (icore.prows32[sy][sx].r<255) and (sx<xleft) then xleft:=sx;

if (xleft<=0)    then break;
if (xleft<dleft) then dleft:=xleft;

end;//sy

//.safe range
xleft:=frcmax32(xleft,xpad);


//capture char pixels ----------------------------------------------------------

dval        :=0;
dlen        :=0;
xleft       :=frcmax32( xleft ,aw - xfontinfo.wlist[xcharindex] );//shift left boundary so as to scan the expected char width
xright      :=xleft + xfontinfo.wlist[xcharindex] - 1;
xcanheight1 :=(xcharindex>=uuA) and (xcharindex<=uuD);//.height1 -> only for chars "A,B,C and D"

xoutdata.clear;

//header
xoutdata.aadd( [uuR,uuL,uuE,nn8] );//RLE8
xoutdata.addint4(xright-xleft+1);
xoutdata.addint4(ah);

//get
for sy:=0 to pred(ah) do
begin

//.height1 detection init
xheight1    :=xcanheight1 and (sy>=xfontinfo.height1);

for sx:=xleft to xright do
begin

if (sval(sy,sx)=dval) then
   begin

   inc(dlen);

   if (dlen>=255) then
      begin

      //add
      xoutdata.aadd( [dlen ,dval] );

      //reset
      dlen:=0;

      end;

   end
else begin

   //add
   if (dlen>=1) then xoutdata.aadd( [dlen ,dval] );

   //reset
   dlen:=1;
   dval:=sval(sy,sx);

   end;

//.height1 detection
if xheight1 and (icore.prows32[sy][sx].r<255) then xheight1:=false;

end;//sx

//.height1 -> only for chars "A,B,C and D"
if xcanheight1 and (not xheight1) and (sy>=xfontinfo.height1) then xfontinfo.height1:=sy+1;

end;//sy

//.finalise
if (dlen>=1)       then xoutdata.aadd( [dlen ,dval] );

{//???????????????????????????????
if (xcharindex=uuW) then
   begin

   junk1:=misimg24(1,1);

   missize(junk1,4*xfontinfo.wlist[uuW],500);
   miscls(junk1,clWhite);

junktime:=ms64;//???????????????

for sx:=1 to 5000 do
begin

   //1 -> no feather
   with junkinfo do
   begin
   core       :=xoutdata;
   clip       :=misarea(junk1);
   rs24       :=junk1.prows24;
   x          :=0;
   y          :=0;
   color      :=0;
   color2     :=color;
   feather255 :=0;
   feather2552:=0;
   end;
   rle8__drawfast__cliprange24(junkinfo);

   //2 -> our feather
   with junkinfo do
   begin
   x          :=xfontinfo.wlist[uuW];
   y          :=0;
   feather255 :=96;
   feather2552:=255;
   end;
   rle8__drawfast__cliprange24(junkinfo);

   //3 -> grey feather
   with junkinfo do
   begin
   x          :=2*xfontinfo.wlist[uuW];
   y          :=0;
   feather255 :=0;
   feather2552:=255;
   end;
   rle8__drawfast__cliprange24(junkinfo);

   //4 -> both feathers full
   with junkinfo do
   begin
   x          :=3*xfontinfo.wlist[uuW];
   y          :=0;
   feather255 :=255;
   feather2552:=255;
   end;
   rle8__drawfast__cliprange24(junkinfo);

end;//sx - simulate page of text

   junktime:=ms64-junktime;//???????????????

   showbasic('4x chars = '+k64(junktime)+' ms');//????????

   if not mis__tofile(junk1,'c:\temp\new____font-test-'+char(xcharindex)+'__size'+k64(xfontinfo.size)+'.bmp','bmp',etmp) then showbasic('err>'+etmp);//???????????
//   if not mis__tofile(junk1,'c:\temp\new____font-test-'+char(xcharindex)+'__size'+k64(xfontinfo.size)+'.png','png',etmp) then showbasic('err>'+etmp);//???????????

   freeobj(@junk1);

   end;
{}

//successful
result:=true;
skipend:

end;


//## tresfont ###################################################################

//11111111111111111111111
constructor tresfont.create;
begin

//self
inherited create;

//vars
ipcore      :=@icore;
ifontname   :='';
ifontsize   :=2;

font__clearinfo(icore);

end;

destructor tresfont.destroy;
var
   p:longint;
begin
try

//vars
for p:=0 to high(icore.cslot) do if (icore.cslot[p]<>res_nil) then res__del( icore.cslot[p] );

//self
inherited destroy;

except;end;
end;

procedure tresfont.clear;
begin

setparams('arial',2,false,false);

end;

procedure tresfont.slowtimer;
begin

end;

function tresfont.charcount:longint32;//number of characters currently loaded for font
begin

result:=rescount;

end;

function tresfont.rescount:longint32;//number of system slots used for font
var
   p:longint;
begin

result:=0;
for p:=0 to high(icore.cslot) do if (icore.cslot[p]<>res_nil) then inc(result);

end;

function tresfont.bytes:longint64;//size of font in memory
var
   p:longint;
begin

result:=0;
for p:=0 to high(icore.cslot) do if (icore.cslot[p]<>res_nil) then result:=result + res__fontchar( icore.cslot[p] ).bytes;

end;

function tresfont.getname:string;
begin
result:=icore.name;
end;

function tresfont.getsize:longint;
begin
result:=icore.size;
end;

function tresfont.getgrey:boolean;
begin
result:=icore.grey;
end;

function tresfont.getbold:boolean;
begin
result:=icore.bold;
end;

function tresfont.getheight:longint;
begin

xneedBasics;
result:=icore.height;

end;

function tresfont.getheight1:longint;
begin

xneedBasics;
result:=icore.height1;

end;

function tresfont.getwmin:longint;
begin

xneedBasics;
result:=icore.wmin;

end;

function tresfont.getwmax:longint;
begin

xneedBasics;
result:=icore.wmax;

end;

function tresfont.getwave:longint;
begin

xneedBasics;
result:=icore.wave;

end;

function tresfont.getwlist(xindex:longint):longint;
begin

if (xindex>=0) and (xindex<=high(icore.wlist)) then
   begin

   if (icore.wlist[xindex]=0) then xneedChar(xindex);
   result:=icore.wlist[xindex];

   end
else result:=0;

end;

procedure tresfont.syncName;//detects change in system font names "$fontname" and "$fontname2"
begin

if strmatch(icore.name,'$fontname') or strmatch(icore.name,'$fontname2') then setparams( icore.name ,icore.size ,icore.grey ,icore.bold );

end;

procedure tresfont.setparams(const xname:string;const xsize:longint32;const xgrey,xbold:boolean);
var
   p:longint;
   xok:boolean;
   xfontmapper:tfontmapper;//pointer only
begin

//get
xok:=false;

//.fontname -> actual name used to render char image
if strmatch(xname,'$fontname')  then
   begin

   if low__setstr( ifontname ,strlow(strdefb( vifontname  ,'arial' )) )       then xok:=true;

   end
else if strmatch(xname,'$fontname2') then
   begin

   if low__setstr( ifontname ,strlow(strdefb( vifontname2 ,'courier new' )) ) then xok:=true;

   end
else if low__setstr( ifontname ,strlow(strdefb( xname ,'arial' )) )           then xok:=true;

//.fontsize -> actual size used to render char image
case (xsize>=0) of//allow a negative range which specifies fontsize via height in pixels - 11apr2020
true:if low__setint( ifontsize ,frcmin32(2,xsize) )  then xok:=true;
else if low__setint( ifontsize ,xsize )              then xok:=true;
end;

//.options
if low__setbol(icore.grey, xgrey )              then xok:=true;
if low__setbol(icore.bold, xbold )              then xok:=true;

//.reference only
icore.name:=strdefb(xname,'arial');

case (xsize>=0) of
true:icore.size:=frcmin32(2,xsize);
else icore.size:=xsize;
end;//case

//set
if xok then
   begin

   //delete current slots
   for p:=0 to high(icore.cslot) do
   begin

   if (icore.cslot[p]<>res_nil) then icore.cslot[p]:=res__del( icore.cslot[p] );

   icore.wlist[p]:=0;

   end;//p

   //clear
   with icore do
   begin

   height    :=0;
   height1   :=0;

   wmin      :=0;
   wmax      :=0;
   wave      :=0;

   end;

   end;

end;

procedure tresfont.xscanFont;
begin

//find fontmapper
res__findfontmapper(self).setparams(ifontname,ifontsize,icore.grey,icore.bold,icore);

//.required to calculate height and height1
xneedChar( uuA );
xneedChar( uuB );
xneedChar( uuC );
xneedChar( uuD );

end;

procedure tresfont.xneedBasics;
begin

if (icore.height<=0) then xscanFont;

end;

procedure tresfont.xneedChar(const xindex:longint32);
begin

if (xindex>=0) and (xindex<=high(icore.cslot)) and (icore.cslot[xindex]=res_nil) then
   begin

   xneedBasics;

   icore.cslot[xindex]:=res__newfontchar2( self ,xindex );
   res__fontchar( icore.cslot[xindex] ).make;

   end;

end;

procedure tresfont.needchars(const x:string);
var
   p:longint;
begin

if (x<>'') then
   begin

   xneedBasics;

   for p:=1 to low__len32(x) do xneedChar( byte( x[p-1+stroffset] ) );

   end;

end;

procedure tresfont.needcharRange(const xcharindex_from,xcharindex_to:longint32);
var
   p:longint;
begin

xneedBasics;

for p:=frcrange32(xcharindex_from,0,fontchar_maxindex) to frcrange32(xcharindex_to,0,fontchar_maxindex) do xneedChar(p);

end;

function tresfont.textwidth(const xtab,x:string):longint32;
var
   p,xcolalign,xcolcount,xcolwidth,x1,x2:longint;
   v:byte;
begin

//defaults
result:=0;

//need info
if (icore.height<=0) then xscanFont;

//get
if (xtab<>'') then
   begin

   font__tab(xtab,0,icore.height,0,xcolalign,xcolcount,xcolwidth,result,x1,x2);

   end
else if (x<>'') then
   begin

   for p:=1 to low__len32(x) do
   begin

   v:=byte( x[p-1+stroffset] );

   inc( result, icore.wlist[v] );

   end;//p

   end;

end;

function tresfont.textwidth2(const xtab:string;const x:tstr8):longint32;
var
   p,xcolalign,xcolcount,xcolwidth,x1,x2:longint;
   v:byte;
begin

//defaults
result:=0;

//need info
if (icore.height<=0) then xscanFont;

//get
if (xtab<>'') then
   begin

   str__lock(@x);

   font__tab(xtab,0,icore.height,0,xcolalign,xcolcount,xcolwidth,result,x1,x2);

   end
else if str__lock(@x) and (x.len>=1) then
   begin

   for p:=1 to x.len32 do
   begin

   v:=x.pbytes[ p -1 ];

   inc( result, icore.wlist[v] );

   end;//p

   end;

//free
str__uaf(@x);

end;


//## tresfontchar ##############################################################

constructor tresfontchar.create;
begin

//self
inherited create;

//vars
icharindex   :=uuA;
ifont        :=nil;
icore        :=rescache__newStr8;//faster for smaller fonts

end;

destructor tresfontchar.destroy;
begin
try

//vars
rescache__delStr8(@icore);

//self
inherited destroy;

except;end;
end;

procedure tresfontchar.setparams(const xfont:tresfont;const xcharindex:longint);//22dec2025
begin

if (xfont<>ifont) or (icharindex<>xcharindex) then
   begin

   ifont        :=xfont;
   icharindex   :=frcrange32(xcharindex,0,fontchar_maxindex);

   clear;

   end;
   
xmoretime;

end;

procedure tresfontchar.xmoretime;
begin
itimeout:=255;
end;

function tresfontchar.canclear:boolean;
begin
result:=(itimeout>=1) or (icore.len32>=1);
end;

procedure tresfontchar.clear;
begin

itimeout:=0;
icore.setlen(0);

end;

procedure tresfontchar.slowtimer;
begin

if (itimeout<=1) then
   begin

   if canclear then clear;

   end
else dec(itimeout);

end;

function tresfontchar.bytes:longint64;
begin

result:=icore.datalen;

end;

function tresfontchar.getwidth:longint;
begin

if (ifont.core^.wlist[icharindex]<=0) then make;
xmoretime;
result:=ifont.core^.wlist[icharindex];

end;

function tresfontchar.getheight:longint;
begin

if (ifont.core^.height<=0) then make;
xmoretime;
result:=ifont.core^.height;

end;

function tresfontchar.make:boolean;
begin

//defaults
result :=false;

//check
if (icore.len32>=1) then
   begin

   result:=true;
   exit;

   end
else if (ifont=nil)                    then exit//have not font for reference -> can't build char
else if (icharindex<0)                 then exit
else if (icharindex>fontchar_maxindex) then exit;

//get
result :=res__findfontmapper( ifont ).makechar( icharindex, icore, ifont.core^ );

end;


//rescache procs ---------------------------------------------------------------

function rescache__newFont:tresfont;
var
   p:longint;
begin

//defaults
result :=nil;

//get
for p:=0 to high(rescache_font.obj) do if not rescache_font.use[p] then
   begin

   //track
   track__inc(satOther,1);

   //mark in use
   rescache_font.use[p]:=true;

   //init
   if (rescache_font.obj[p]=nil) then
      begin

      rescache_font.obj[p]:=tresfont.create;

      end;

   //get
   result:=rescache_font.obj[p];

   //stop
   exit;

   end;//p

//fallback
if (result=nil) then
   begin

   result:=tresfont.create;

   end;

end;

function rescache__delFont(x:pobject):boolean;
var
   p:longint;
begin

//pass-thru
result:=true;

//get
for p:=0 to high(rescache_font.obj) do if (x^=rescache_font.obj[p]) then
   begin

   //reset
   rescache_font.obj[p].clear;

   //clear caller's pointer
   x^:=nil;

   //mark not in use
   rescache_font.use[p]:=false;

   //track
   track__inc(satOther,-1);

   //stop
   exit;

   end;

//fallback
freeobj(x);

end;

function rescache__newFontChar:tresfontchar;
var
   p:longint;
begin

//defaults
result :=nil;

//get
for p:=0 to high(rescache_fontchar.obj) do if not rescache_fontchar.use[p] then
   begin

   //track
   track__inc(satOther,1);

   //mark in use
   rescache_fontchar.use[p]:=true;

   //init
   if (rescache_fontchar.obj[p]=nil) then
      begin

      rescache_fontchar.obj[p]:=tresfontchar.create;

      end;

   //get
   result:=rescache_fontchar.obj[p];

   //stop
   exit;

   end;//p

//fallback
if (result=nil) then
   begin

   result:=tresfontchar.create;

   end;

end;

function rescache__delFontChar(x:pobject):boolean;
var
   p:longint;
begin

//pass-thru
result:=true;

//get
for p:=0 to high(rescache_fontchar.obj) do if (x^=rescache_fontchar.obj[p]) then
   begin

   //reset
   rescache_fontchar.obj[p].clear;

   //clear caller's pointer
   x^:=nil;

   //mark not in use
   rescache_fontchar.use[p]:=false;

   //track
   track__inc(satOther,-1);

   //stop
   exit;

   end;

//fallback
freeobj(x);

end;

function rescache__newStr8:tstr8;
var
   p:longint;
begin

//defaults
result :=nil;

//get
for p:=0 to high(rescache_str8.obj) do if not rescache_str8.use[p] then
   begin

   //track
   track__inc(satSmall8,1);

   //mark in use
   rescache_str8.use[p]:=true;

   //init
   if (rescache_str8.obj[p]=nil) then
      begin

      rescache_str8.obj[p]            :=str__new8;
      rescache_str8.obj[p].floatsize  :=512;

      //keep locked so no procs close it by mistake
      str__lock(@rescache_str8.obj[p]);

      end;

   //get
   result :=rescache_str8.obj[p];

   //stop
   exit;

   end;//p

//fallback
if (result=nil) then
   begin

   result            :=str__new8;
   result.floatsize  :=512;

   end;

end;

function rescache__delStr8(x:pobject):boolean;
var
   p:longint;
begin

//pass-thru
result:=true;

//check
if not str__ok(x) then exit;

//get
for p:=0 to high(rescache_str8.obj) do if (x^=rescache_str8.obj[p]) then
   begin

   //reset
   rescache_str8.obj[p].floatsize:=512;
   rescache_str8.obj[p].setlen(0);

   //clear caller's pointer
   x^:=nil;

   //mark not in use
   rescache_str8.use[p]:=false;

   //track
   track__inc(satSmall8,-1);

   //stop
   exit;

   end;

//fallback
if str__ok(x) then freeobj(x);

end;

function rescache__newFastdraw:tfastdrawobj;
var
   p:longint;
begin

//defaults
result :=nil;

//get
for p:=0 to high(rescache_fastdraw.obj) do if not rescache_fastdraw.use[p] then
   begin

   //track
   track__inc(satOther,1);

   //mark in use
   rescache_fastdraw.use[p]:=true;

   //init
   if (rescache_fastdraw.obj[p]=nil) then
      begin

      rescache_fastdraw.obj[p]:=tfastdrawobj.create;

      end;

   //get
   result :=rescache_fastdraw.obj[p];

   //stop
   exit;

   end;//p

//fallback
if (result=nil) then
   begin

   result:=tfastdrawobj.create;

   end;

end;

function rescache__delFastdraw(x:pobject):boolean;
var
   p:longint;
begin

//pass-thru
result:=true;

//delect if currently the selected item in the fastdraw system
if (fd_focus=@(x^ as tfastdrawobj).core) then fd__selectRoot;

//get
for p:=0 to high(rescache_fastdraw.obj) do if (x^=rescache_fastdraw.obj[p]) then
   begin

   //clear caller's pointer
   x^:=nil;

   //mark not in use
   rescache_fastdraw.use[p]:=false;

   //track
   track__inc(satOther,-1);

   //stop
   exit;

   end;

//fallback
freeobj(x);

end;


//rle8 procs -------------------------------------------------------------------

//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????
//??????????????????????????????????????????????????????

function rle8__drawfast__init(var x:tresdrawfastinfo):boolean;
begin

//defaults ---------------------------------------------------------------------

result     :=false;
x.proccode :=0;//0=no proc used to draw -> tracks which proc ends up drawing the rle8 to the target buffer


//check record has been inited -------------------------------------------------

if (x.initcode<>init_ok) then exit;


//image area check -------------------------------------------------------------

if (x.imgarea.left<0) or (x.imgarea.top<0) or (x.imgarea.right<x.imgarea.left) or (x.imgarea.bottom<x.imgarea.top) then exit;


//clip area check --------------------------------------------------------------

//.clip area lays outside safe bounds of image "imgarea" -> nothing to do -> exit
if (x.clip.right<x.imgarea.left) or (x.clip.left>x.imgarea.right) or (x.clip.bottom<x.imgarea.top) or (x.clip.top>x.imgarea.bottom) then exit;

//.x - restrict clip left/right range
if ( x.clip.left   < x.imgarea.left   ) then x.clip.left   :=x.imgarea.left;
if ( x.clip.right  > x.imgarea.right  ) then x.clip.right  :=x.imgarea.right;

//.y - restrict clip top/bottom range
if ( x.clip.top    < x.imgarea.top    ) then x.clip.top    :=x.imgarea.top;
if ( x.clip.bottom > x.imgarea.bottom ) then x.clip.bottom :=x.imgarea.bottom;


//bits -------------------------------------------------------------------------

//no valid image rows24 or rows32 -> exit
case x.bits of
24:if (x.rs24=nil) then exit;
32:if (x.rs32=nil) then exit;
else                    exit;
end;


//rle8 char core ---------------------------------------------------------------

//.init
case (x.core<>nil) of
true:begin

   x.clen:=x.core.len32;
   if (x.clen<12) then exit;//require at least "4b header" and "4b+4b = width+height" = first 12b

   end;
else exit;
end;//case

//.basic core info
x.cw             :=x.core.int4[4];
if (x.cw<1) then exit;

x.ch             :=x.core.int4[8];
if (x.ch<1) then exit;

x.cpos           :=12;//first byte of compressed data


//ensure render coordinate range lay within partial or full clip area ----------

if ((x.x+x.cw-1)<x.clip.left) or (x.x>x.clip.right) or ((x.y+x.ch-1)<x.clip.top) or (x.y>x.clip.bottom) then exit;


//enforce ranges ---------------------------------------------------------------

x.feather255A    :=frcrange32(x.feather255A ,0,255);
x.feather255B    :=frcrange32(x.feather255B ,0,255);
x.power255       :=frcrange32(x.power255    ,0,255);


//set colors -------------------------------------------------------------------

x.color24A       :=int__c24(x.colorA);//color 1 for shades 1..253 and 255
x.color24B       :=int__c24(x.colorB);//color 2 for shade 254

x.color32A.r     :=x.color24A.r;
x.color32A.g     :=x.color24A.g;
x.color32A.b     :=x.color24A.b;
x.color32A.a     :=255;

x.color32B.r     :=x.color24B.r;
x.color32B.g     :=x.color24B.g;
x.color32B.b     :=x.color24B.b;
x.color32B.a     :=255;


//successful -------------------------------------------------------------------
result:=true;

end;

procedure rle8__drawfast(var x:tresdrawfastinfo);
begin

//ensure "x" is valid and there is something to draw ---------------------------
if not rle8__drawfast__init(x) then exit;
//????????????????????xxxxxxxxx take init out of this proc!!! impolement layer, flip, mirror, power etc

//decide which proc to draw with -----------------------------------------------

//.1 - nothing to draw
if (x.power255<=0) then exit;

//.2 - no flip, no mirror, power255=255
if (not x.flip) and (not x.mirror) and (x.power255=255) and (not x.round) and (x.layer=0) then
   begin

   case x.bits of
   24:rle8__drawfast24(x);
   32:rle8__drawfast32(x);
   end;//case

   exit;

   end;

//.3 - flip or mirror or power255<255
{//?????????
case x.bits of
24:result:=rle8__drawfast__cliprange24(x);
32:result:=rle8__drawfast__cliprange32(x);
end;//case
{}

end;

procedure rle8__drawfast24(var x:tresdrawfastinfo);
label//Important: this proc does no range checking
   yredo,xredo,yskip,xskip;
var
   cclip:twinrect;
   crs24:pcolorrows24;
   cpos,clen,featherA,featherB,slen,cainv,ca,x1,x2,y1,y2,xstop,ystop,xreset,yreset,ax,ay:longint;
   yok:boolean;
   colA,colB:tcolor24;
   v24:pcolor24;
begin

//check
if (x.initcode<>init_ok) or (x.rs24=nil) then exit;

//init
x1               :=x.x;
x2               :=x1 + x.cw - 1;
y1               :=x.y;
y2               :=y1 + x.ch - 1;
cpos             :=x.cpos;
clen             :=x.clen;
cclip            :=x.clip;
crs24            :=x.rs24;
colA             :=x.color24A;//for shades 1..253 and 255
colB             :=x.color24B;//for shade 254
featherA         :=x.feather255A;
featherB         :=x.feather255B;

ca               :=0;
cainv            :=255;
slen             :=0;

//.y
yreset           :=y1;
ystop            :=y2;

//.x
xreset           :=x1;
xstop            :=x2;


//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//init
ay               :=yreset;

//y
yredo:
yok              :=(ay>=cclip.top) and (ay<=cclip.bottom);

//x
ax               :=xreset;

//loop
xredo:

dec(slen);

if (slen<=0) then
   begin

   if ((cpos+1)<clen) then
      begin

      slen  :=x.core.pbytes[ cpos + 0 ];
      ca    :=x.core.pbytes[ cpos + 1 ];

      //255=full color, 254=full color2, 253..1=partial color

      //our feather
      if (ca<=8) then
         begin

         ca:=(ca * 32 * featherA) div 256;

         end
      //grey feather
      else if (ca<254) then
         begin

         ca:=(ca * featherB) div 256;

         end;

      cainv :=255-ca;

      inc(cpos,2);

      end
   else
      begin

      slen  :=255;
      ca    :=0;
      cainv :=255;

      end;

   end;

if (ca=0) or (ax<cclip.left) or (ax>cclip.right) or (not yok) then goto xskip;

//render pixel
if      (ca=255) then crs24[ay][ax]:=colA//color 1
else if (ca=254) then crs24[ay][ax]:=colB//color 2
else
   begin

   //color 1
   v24   :=@crs24[ay][ax];
   v24.r :=( (cainv*v24.r) + (ca*colA.r) ) div 256;
   v24.g :=( (cainv*v24.g) + (ca*colA.g) ) div 256;
   v24.b :=( (cainv*v24.b) + (ca*colA.b) ) div 256;

   end;

//inc x
xskip:
if (ax<>xstop) then
   begin

   inc(ax,1);
   goto xredo;

   end;

//inc y
yskip:
if (ay<>ystop) then
   begin

   inc(ay,1);
   goto yredo;

   end;

end;

procedure rle8__drawfast32(var x:tresdrawfastinfo);
label//Important: this proc does no range checking
   yredo,xredo,yskip,xskip;
var
   cclip:twinrect;
   crs32:pcolorrows32;
   cpos,clen,featherA,featherB,slen,cainv,ca,x1,x2,y1,y2,xstop,ystop,xreset,yreset,ax,ay:longint;
   yok:boolean;
   colA,colB:tcolor32;
   v32:pcolor32;
begin

//check
if (x.initcode<>init_ok) or (x.rs32=nil) then exit;

//init
x1               :=x.x;
x2               :=x1 + x.cw - 1;
y1               :=x.y;
y2               :=y1 + x.ch - 1;
cpos             :=x.cpos;
clen             :=x.clen;
cclip            :=x.clip;
crs32            :=x.rs32;
colA             :=x.color32A;//for shades 1..253 and 255
colB             :=x.color32B;//for shade 254
featherA         :=x.feather255A;
featherB         :=x.feather255B;

ca               :=0;
cainv            :=255;
slen             :=0;

//.y
yreset           :=y1;
ystop            :=y2;

//.x
xreset           :=x1;
xstop            :=x2;


//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//init
ay               :=yreset;

//y
yredo:
yok              :=(ay>=cclip.top) and (ay<=cclip.bottom);

//x
ax               :=xreset;

//loop
xredo:

dec(slen);

if (slen<=0) then
   begin

   if ((cpos+1)<clen) then
      begin

      slen  :=x.core.pbytes[ cpos + 0 ];
      ca    :=x.core.pbytes[ cpos + 1 ];

      //255=full color, 254=full color2, 253..1=partial color

      //our feather
      if (ca<=8) then
         begin

         ca:=(ca * 32 * featherA) div 256;

         end
      //grey feather
      else if (ca<254) then
         begin

         ca:=(ca * featherB) div 256;

         end;

      cainv :=255-ca;

      inc(cpos,2);

      end
   else
      begin

      slen  :=255;
      ca    :=0;
      cainv :=255;

      end;

   end;

if (ca=0) or (ax<cclip.left) or (ax>cclip.right) or (not yok) then goto xskip;

//render pixel
if      (ca=255) then crs32[ay][ax]:=colA//color 1
else if (ca=254) then crs32[ay][ax]:=colB//color 2
else
   begin

   //color 1
   v32   :=@crs32[ay][ax];
   v32.r :=( (cainv*v32.r) + (ca*colA.r) ) div 256;
   v32.g :=( (cainv*v32.g) + (ca*colA.g) ) div 256;
   v32.b :=( (cainv*v32.b) + (ca*colA.b) ) div 256;
   v32.a :=colA.a;

   end;

//inc x
xskip:
if (ax<>xstop) then
   begin

   inc(ax,1);
   goto xredo;

   end;

//inc y
yskip:
if (ay<>ystop) then
   begin

   inc(ay,1);
   goto yredo;

   end;

end;


//ling procs -------------------------------------------------------------------

procedure ling__size(var s:tling;const dw,dh:longint);
begin

//w
if      (dw<1)           then s.w:=1
else if (dw>ling_width)  then s.w:=ling_width
else                          s.w:=dw;

//h
if      (dh<1)           then s.h:=1
else if (dh>ling_height) then s.h:=ling_height
else                          s.h:=dh;

end;

procedure ling__cls(var s:tling);
begin

s.pixels:=resling_cls.pixels;

end;

procedure ling__cls2(var s:tling;const r,g,b,a:byte);
begin

//sync
if (r<>resling_cls2.ref32.r) or (g<>resling_cls2.ref32.g) or (b<>resling_cls2.ref32.b) or (a<>resling_cls2.ref32.a) then
   begin

   resling_cls2.ref32.r:=r;
   resling_cls2.ref32.g:=g;
   resling_cls2.ref32.b:=b;
   resling_cls2.ref32.a:=a;

   ling__clsSlow(resling_cls2,r,g,b,a);

   end;

//get
s.pixels:=resling_cls2.pixels;

end;

procedure ling__clsSlow(var s:tling;const r,g,b,a:byte);//peak rate: 30.0 million calls / second on Intel Core i5 2.5 GHz - 23dec2025
var
   sx,sy:longint32;
begin

//fill top-left pixel
s.pixels[0][0].r:=r;
s.pixels[0][0].g:=g;
s.pixels[0][0].b:=b;
s.pixels[0][0].a:=a;

//fill top row
for sx:=1 to pred(ling_width) do s.pixels[0][sx]:=s.pixels[0][0];

//fill other rows
for sy:=1 to pred(ling_height) do s.pixels[sy]:=s.pixels[0];

end;

function ling__flip_mirror(var s:tling;const xflip,xmirror:boolean):boolean;
label
   xredo,yredo;
var
   t:tling;
   sx,sy,xreset,xstop,ystop,xshift,yshift,dx,dy:longint32;
begin

//defaults
result :=true;

//check
if ( (not xflip) or (s.h<2) ) and ( (not xmirror) or (s.w<2) ) then exit;

//init
t      :=s;//take a copy
dx     :=0;
dy     :=0;

//.y
if xflip then
   begin

   sy       :=t.h - 1;
   yshift   :=-1;
   ystop    :=0;

   end
else
   begin

   sy       :=0;
   yshift   :=1;
   ystop    :=t.h - 1;

   end;

//.x
if xmirror then
   begin

   xreset   :=t.w - 1;
   xshift   :=-1;
   xstop    :=0;

   end
else
   begin

   xreset   :=0;
   xshift   :=1;
   xstop    :=t.w - 1;

   end;

//get
yredo:

sx     :=xreset;
dx     :=0;

xredo:

//store pixel
s.pixels[dy][dx]:=t.pixels[sy][sx];

//inc x
if (sx<>xstop) then
   begin

   inc(sx,xshift);
   inc(dx,1);
   goto xredo;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,yshift);
   inc(dy,1);
   goto yredo;

   end;

end;

function ling__makeFromPattern(var s:tling;const r,g,b:byte;const spattern:string):boolean;//23dec2025
var
   p,dx,dy,dw,dh:longint32;
   c32:tcolor32;
begin

//defaults
result    :=false;

s.w       :=ling_width;
s.h       :=ling_height;

dx        :=0;
dy        :=0;
dw        :=0;
dh        :=0;

c32.r     :=r;
c32.g     :=g;
c32.b     :=b;
c32.a     :=255;

//cls
ling__cls(s);

//get
if (spattern<>'') then
   begin

   for p:=1 to low__len32(spattern) do
   begin

   //"+" => on pixel
   //" " => off pixel
   //"/" or #10 => new row/line

   case byte( spattern[p-1+stroffset] ) of
   ssPlus:begin

      if (dx<s.w) then s.pixels[dy][dx]:=c32;

      inc(dx);

      if (dx>dw)       then dw:=dx+0;
      if ((dy+1)>dh)   then dh:=dy+1;

      end;
   ssSpace:inc(dx);
   ssSlash,ss10:begin

      inc(dy);

      if (dy>=s.h) then break;

      dx:=0;

      end;
   end;//case

   end;//p

   end;

//set
s.w       :=frcmax32( dw ,ling_width );
s.h       :=frcmax32( dh ,ling_height );

//successful
result    :=true;

end;


procedure ling__draw(var x:tfastdraw;const s:tling);
begin

//check
if x.b.ok and (s.w>=1) then
   begin

   //decide
   if      (x.lv8>=0)                         then ling__draw103__flip_mirror_cliprange_layer(x,s)
   else if (x.b.amode=fd_area_inside_clip)    then ling__draw101__flip_mirror(x,s)//fastest
   else                                            ling__draw102__flip_mirror_cliprange(x,s);

   end;

end;

procedure ling__draw101__flip_mirror(var x:tfastdraw;const s:tling);//23dec2025
   //--------------------------------------------------------------------------------+
   // Peak draw speed for Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz                   |
   //--------------------------------------------------------------------------------+
   // Rate                   | Image Size   | Options       | Frame Buffer           |
   //------------------------+--------------+---------------+------------------------+
   // 243.5 mps / 117.6 fps  | 5 x 5        | Normal        | 1,920 x 1,080 @ 24 bit |
   // 313.3 mps / 151.3 fps  | 16 x 16      | Normal        | 1,920 x 1,080 @ 24 bit |
   // 330.9 mps / 159.8 fps  | 16 x 16      | Flip Mirror   | 1,920 x 1,080 @ 24 bit |
   // 218.0 mps / 105.3 fps  | 5 x 5        | Normal        | 1,920 x 1,080 @ 32 bit |
   // 273.7 mps / 132.2 fps  | 16 x 16      | Normal        | 1,920 x 1,080 @ 32 bit |
   // 279.1 mps / 134.8 fps  | 16 x 16      | Flip Mirror   | 1,920 x 1,080 @ 32 bit |
   //--------------------------------------------------------------------------------+
   // mps = millions of pixels per second, fps = frames per second

label
   yredo24,xredo24,yredo32,xredo32;
var
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   xstop,ystop,xreset,xshift,yshift,sx,sy,dx,dy:longint32;
begin

//defaults
fd_drawproc32:=101;

//init
dy          :=x.b.ay1;

//.y
if x.flip then
   begin

   sy       :=s.h - 1;
   yshift   :=-1;
   ystop    :=0;

   end
else
   begin

   sy       :=0;
   yshift   :=1;
   ystop    :=s.h - 1;

   end;

//.x
if x.mirror then
   begin

   xreset   :=s.w - 1;
   xshift   :=-1;
   xstop    :=0;

   end
else
   begin

   xreset   :=0;
   xshift   :=1;
   xstop    :=s.w - 1;

   end;

//.bits
case x.b.bits of
24:begin

   sr24:=pcolorrows24(x.b.rows);
   goto yredo24;

   end;
32:begin

   sr32:=pcolorrows32(x.b.rows);
   goto yredo32;

   end;
else  exit;
end;//case


//render24 ---------------------------------------------------------------------
yredo24:

sx  :=xreset;
dx  :=x.b.ax1;

xredo24:

//render pixel
if (s.pixels[sy][sx].a>0) then
   begin

   sr24[dy][dx]:=tint4( s.pixels[sy][sx] ).bgr24;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,xshift);
   inc(dx,1);
   goto xredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,yshift);
   inc(dy,1);
   goto yredo24;

   end;

//done
exit;


//render32 ---------------------------------------------------------------------
yredo32:

sx  :=xreset;
dx  :=x.b.ax1;

xredo32:

//render pixel
if (s.pixels[sy][sx].a>0) then
   begin

   sr32[dy][dx]:=s.pixels[sy][sx];
   if (s.pixels[sy][sx].a<>255) then sr32[dy][dx].a:=255;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,xshift);
   inc(dx,1);
   goto xredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,yshift);
   inc(dy,1);
   goto yredo32;

   end;

end;

procedure ling__draw102__flip_mirror_cliprange(var x:tfastdraw;const s:tling);
   //--------------------------------------------------------------------------------+
   // Peak draw speed for Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz                   |
   //--------------------------------------------------------------------------------+
   // Rate                   | Image Size   | Options       | Frame Buffer           |
   //------------------------+--------------+---------------+------------------------+
   // 259.2 mps / 125.2 fps  | 5 x 5        | Normal        | 1,920 x 1,080 @ 24 bit |
   // 329.5 mps / 159.2 fps  | 16 x 16      | Normal        | 1,920 x 1,080 @ 24 bit |
   // 327.2 mps / 158.1 fps  | 16 x 16      | Flip Mirror   | 1,920 x 1,080 @ 24 bit |
   // 205.6 mps / 99.3 fps   | 5 x 5        | Normal        | 1,920 x 1,080 @ 32 bit |
   // 254.5 mps / 122.9 fps  | 16 x 16      | Normal        | 1,920 x 1,080 @ 32 bit |
   // 255.4 mps / 123.4 fps  | 16 x 16      | Flip Mirror   | 1,920 x 1,080 @ 32 bit |
   //--------------------------------------------------------------------------------+
   // mps = millions of pixels per second, fps = frames per second

label
   yredo24,xredo24,yredo32,xredo32;
var
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   xstop,ystop,xreset,xshift,yshift,sx,sy,dx,dy:longint32;
   yok:boolean;
begin

//defaults
fd_drawproc32:=102;

//init
dy          :=x.b.ay1;

//.y
if x.flip then
   begin

   sy       :=s.h - 1;
   yshift   :=-1;
   ystop    :=0;

   end
else
   begin

   sy       :=0;
   yshift   :=1;
   ystop    :=s.h - 1;

   end;

//.x
if x.mirror then
   begin

   xreset   :=s.w - 1;
   xshift   :=-1;
   xstop    :=0;

   end
else
   begin

   xreset   :=0;
   xshift   :=1;
   xstop    :=s.w - 1;

   end;

//.bits
case x.b.bits of
24:begin

   sr24:=pcolorrows24(x.b.rows);
   goto yredo24;

   end;
32:begin

   sr32:=pcolorrows32(x.b.rows);
   goto yredo32;

   end;
else  exit;
end;//case


//render24 ---------------------------------------------------------------------
yredo24:

sx  :=xreset;
dx  :=x.b.ax1;
yok :=(dy>=x.b.cy1) and (dy<=x.b.cy2);

xredo24:

//render pixel
if yok and (s.pixels[sy][sx].a>0) and (dx>=x.b.cx1) and (dx<=x.b.cx2) then
   begin

   sr24[dy][dx]:=tint4( s.pixels[sy][sx] ).bgr24;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,xshift);
   inc(dx,1);
   goto xredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,yshift);
   inc(dy,1);
   goto yredo24;

   end;

//done
exit;


//render32 ---------------------------------------------------------------------
yredo32:

sx  :=xreset;
dx  :=x.b.ax1;
yok :=(dy>=x.b.cy1) and (dy<=x.b.cy2);

xredo32:

//render pixel
if yok and (s.pixels[sy][sx].a>0) and (dx>=x.b.cx1) and (dx<=x.b.cx2) then
   begin

   sr32[dy][dx]:=s.pixels[sy][sx];
   if (s.pixels[sy][sx].a<>255) then sr32[dy][dx].a:=255;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,xshift);
   inc(dx,1);
   goto xredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,yshift);
   inc(dy,1);
   goto yredo32;

   end;

end;

procedure ling__draw103__flip_mirror_cliprange_layer(var x:tfastdraw;const s:tling);
   //--------------------------------------------------------------------------------+
   // Peak draw speed for Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz                   |
   //--------------------------------------------------------------------------------+
   // Rate                   | Image Size   | Options       | Frame Buffer           |
   //------------------------+--------------+---------------+------------------------+
   // 162.1 mps / 78.3 fps   | 5 x 5        | Normal        | 1,920 x 1,080 @ 24 bit |
   // 226.3 mps / 109.3 fps  | 16 x 16      | Normal        | 1,920 x 1,080 @ 24 bit |
   // 223.6 mps / 108.0 fps  | 16 x 16      | Flip Mirror   | 1,920 x 1,080 @ 24 bit |
   // 139.8 mps / 67.5 fps   | 5 x 5        | Normal        | 1,920 x 1,080 @ 32 bit |
   // 179.2 mps / 86.6 fps   | 16 x 16      | Normal        | 1,920 x 1,080 @ 32 bit |
   // 177.7 mps / 85.8 fps   | 16 x 16      | Flip Mirror   | 1,920 x 1,080 @ 32 bit |
   //--------------------------------------------------------------------------------+
   // mps = millions of pixels per second, fps = frames per second

label
   yredo24,xredo24,yredo32,xredo32;
var
    mr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   lv8,xstop,ystop,xreset,xshift,yshift,sx,sy,dx,dy:longint32;
   yok:boolean;
begin

//defaults
fd_drawproc32:=103;

//init
dy          :=x.b.ay1;
mr8         :=pcolorrows8( x.lr8 );
lv8         :=x.lv8;

//.y
if x.flip then
   begin

   sy       :=s.h - 1;
   yshift   :=-1;
   ystop    :=0;

   end
else
   begin

   sy       :=0;
   yshift   :=1;
   ystop    :=s.h - 1;

   end;

//.x
if x.mirror then
   begin

   xreset   :=s.w - 1;
   xshift   :=-1;
   xstop    :=0;

   end
else
   begin

   xreset   :=0;
   xshift   :=1;
   xstop    :=s.w - 1;

   end;

//.bits
case x.b.bits of
24:begin

   sr24:=pcolorrows24(x.b.rows);
   goto yredo24;

   end;
32:begin

   sr32:=pcolorrows32(x.b.rows);
   goto yredo32;

   end;
else  exit;
end;//case


//render24 ---------------------------------------------------------------------
yredo24:

sx  :=xreset;
dx  :=x.b.ax1;
yok :=(dy>=x.b.cy1) and (dy<=x.b.cy2);

xredo24:

//render pixel
if yok and (s.pixels[sy][sx].a>0) and (dx>=x.b.cx1) and (dx<=x.b.cx2) and (mr8[dy][dx]=lv8) then
   begin

   sr24[dy][dx]:=tint4( s.pixels[sy][sx] ).bgr24;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,xshift);
   inc(dx,1);
   goto xredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,yshift);
   inc(dy,1);
   goto yredo24;

   end;

//done
exit;


//render32 ---------------------------------------------------------------------
yredo32:

sx  :=xreset;
dx  :=x.b.ax1;
yok :=(dy>=x.b.cy1) and (dy<=x.b.cy2);

xredo32:

//render pixel
if yok and (s.pixels[sy][sx].a>0) and (dx>=x.b.cx1) and (dx<=x.b.cx2) and (mr8[dy][dx]=lv8) then
   begin

   sr32[dy][dx]:=s.pixels[sy][sx];
   if (s.pixels[sy][sx].a<>255) then sr32[dy][dx].a:=255;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,xshift);
   inc(dx,1);
   goto xredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,yshift);
   inc(dy,1);
   goto yredo32;

   end;

end;


//time sampler procs -----------------------------------------------------------

procedure resSample__resetAll;
var
   p:longint;
begin

for p:=0 to high(ressample_core) do ressample__reset( p );

end;

function ressample__slotok(const xslot:longint32):boolean;
begin

result:=(xslot>=0) and (xslot<=high(ressample_core));

end;

procedure ressample__reset(const xslot:longint32);
begin

if ressample__slotok( xslot ) then
   begin

   with ressample_core[xslot] do
   begin

   timeTotal    :=0;
   timeCount    :=0;
   timeAve      :=0;

   end;

   end;

end;

procedure ressample__start(const xslot:longint32);
begin

if ressample__slotok( xslot ) then ressample_core[ xslot ].ref64 :=ns64;//nano timer

end;

procedure ressample__stop(const xslot:longint32);
begin

if ressample__slotok( xslot ) and (ressample_core[ xslot ].ref64>0) then
   begin

   with ressample_core[ xslot ] do
   begin

   ref64:=sub64(ns64,ref64);//nano timer

   inc64( timeTotal, ref64);
   inc64( timeCount, 1 );

   timeAve :=(timeTotal/timeCount) * (1/1000);

   ref64:=0;//mark as stoppped

   end;//with

   end;

end;

function ressample__tag1(const xslot:longint32):longint32;
begin

if ressample__slotok( xslot ) then result:=ressample_core[ xslot ].tag1 else result:=0;

end;

function ressample__tag2(const xslot:longint32):longint32;
begin

if ressample__slotok( xslot ) then result:=ressample_core[ xslot ].tag2 else result:=0;

end;

procedure ressample__settag1(const xslot,xval:longint32);
begin

if ressample__slotok( xslot ) then ressample_core[ xslot ].tag1:=xval;

end;

procedure ressample__settag2(const xslot,xval:longint32);
begin

if ressample__slotok( xslot ) then ressample_core[ xslot ].tag2:=xval;

end;

procedure ressample__show(const xslot:longint32;const xlabel:string);
begin

exit;//????????????????????????????

if ressample__slotok( xslot ) then
   begin

   //stop
   ressample__stop( xslot );

   //show
   with ressample_core[ xslot ] do
   begin

   dbstatus(xslot,xlabel+insstr('>',xlabel<>'')+ curdec(timeAve,2,true)+' ms'+insstr(' << '+k64(tag1)+'__'+k64(tag2),(tag1<>0) or (tag2<>0)) );

   end;

   end;

end;


//fastdraw procs ---------------------------------------------------------------

function fd__renderMPS:double;
var
   v64:longint64;
begin

v64:=fastms64;

if (v64>=fd_rendermps.time1000) then
   begin


   try
   xfd__inc64;//flush
   fd_rendermps.rendermps :=( (fd_rendermps.rendermps*2) + (sub64( fd_pixelcount64, fd_rendermps.lastmps64 ) * (1/1000000) * (1000/frcmin64(sub64(v64,sub64(fd_rendermps.time1000,1000)),1))) ) / 3;
   except;
   fd_rendermps.rendermps :=1;
   end;

   fd_rendermps.lastmps64 :=fd_pixelcount64;
   fd_rendermps.time1000  :=add64( v64 ,1000 );

   end;

result:=fd_rendermps.rendermps;

end;

procedure xfd__inc32(const xval:longint32);
begin

case (fd_pixelcount32<fdr_pixelcount32_limit) of
true:fd_pixelcount32 :=fd_pixelcount32+xval;
else fd_pixelcount32 :=xval;
end;//case

end;

procedure xfd__inc64;
begin

case (fd_pixelcount64<fdr_pixelcount64_limit) of
true:fd_pixelcount64 :=fd_pixelcount64 + fd_pixelcount32;
else fd_pixelcount64 :=fd_pixelcount32;
end;//case

fd_pixelcount32:=0;

end;

procedure xfd__sync_amode(var x:tfastdrawbuffer);
begin

//check
if not x.ok then exit;

//get
with x do
begin

if (aw<1) or (ah<1) or (ax2<ax1) or (ay2<ay1) then
   begin

   amode:=fd_area_outside_clip;

   end
else if (ax1>=cx1) and (ax2<=cx2) and (ay1>=cy1) and (ay2<=cy2) then
   begin

   amode:=fd_area_inside_clip;

   end

else if (ax2>=cx1) and (ax1<=cx2) and (ay2>=cy1) and (ay1<=cy2) then
   begin

   amode:=fd_area_overlaps_clip;

   end

else
   begin

   amode:=fd_area_outside_clip;

   end;

end;//with

end;

procedure xfd__trimAreaToFitBuffer(var x:tfastdrawbuffer);
begin

//quick check
if not x.ok then exit;

//enforce range
with x do
begin

//x
if (ax1<cx1)      then ax1:=cx1;
if (ax2>cx2)      then ax2:=cx2;
aw                        :=ax2-ax1+1;

//y
if (ay1<cy1)      then ay1:=cy1;
if (ay2>cy2)      then ay2:=cy2;
ah                        :=ay2-ay1+1;
amode                     :=fd_area_inside_clip;

end;//with

end;

procedure fd__showerror(const xerrcode,xcode:longint);//for debug purposes

 procedure s(const m:string);
 begin

 showerror('FastDraw Error: '+m+insstr(' for code ('+k64(xcode)+')',xcode>=0));

 end;

begin

//inc error counter
if (fd_errors_count<max32) then inc(fd_errors_count);

//check
if not fd_errors_ok then exit;

//get
case xerrcode of
fd_propertyMismatch        :s('Property mismatch');
fd_selectUsedInvalidSlot   :s('Select used an invalid slot');
else                        s('Undefined error');
end;//case

end;

procedure fd__selectRoot;
begin

fd_focus:=@res__fastdraw(res_nil).core;

end;

procedure fd__select(const x:tresslot);//set focus slot
begin

fd_focus:=@res__fastdraw(x).core;

//detect when a slot other than "res_nil" is requested but the system falls back to "res_nil" - 05jan2026
if (x<>res_nil) and (fd_focus=@system_rescore.ffastdraw.core) then fd__showerror(fd_selectUsedInvalidSlot,-1);

end;

procedure fd__selStore(var x:pfastdraw);
begin

x:=fd_focus;

end;

procedure fd__selRestore(var x:pfastdraw);
begin

if (x=nil) then fd__selectRoot else fd_focus:=x;

end;

procedure fd__defaults;//clears slot
begin

xfd__defaults(fd_focus^);

end;

procedure xfd__defaults(var x:tfastdraw);
begin

with x do
begin

//.buffers
b        .ok     :=false;
b        .scok   :=false;
b        .saok   :=false;

b2       .ok     :=false;
b2       .scok   :=false;
b2       .saok   :=false;

t        .ok     :=false;
t2       .ok     :=false;

//.gui layer support
lr8              :=nil;//off
lv8              :=-1;//off

//.colors
color1           :=rescol_white32;
color2           :=rescol_white32;
color3           :=rescol_white32;
color4           :=rescol_white32;

//round support
rindex           :=-1;
rimage           :=@resling_nil;
rmode            :=rmAll;

//misc
mirror           :=false;
flip             :=false;
power255         :=255;
splice100        :=100;

//tracking
drawProc         :=0;

end;

end;

function fd__new:tresslot;
begin

result:=res__newfastdraw;

//apply defaults to newly created slot
xfd__defaults( res__fastdraw(result).core );

end;

procedure fd__del(var x:tresslot);
begin

//note: can't delete root slot -> res_nil -> fallback object outside scope of rescache
if (x<>res_nil) then x:=res__del(x);

end;

procedure fd__render(const xcode:longint32);
begin

case xcode of

fd_roundStartFromArea         :xfd__roundStart(xcode);
fd_roundStartFromAreaDebug    :xfd__roundStart(xcode);
fd_roundStartFromClip         :xfd__roundStart(xcode);
fd_roundStopAndRender         :xfd__roundEnd(false);
fd_roundStopAndRenderDebug    :xfd__roundEnd(true);

fd_fillArea                   :xfd__fillArea;
fd_sketchArea                 :xfd__sketchArea;
fd_shadeArea                  :xfd__shadeArea;
fd_fillSmallArea              :xfd__fillSmallArea;

fd_drawPixels                 :xfd__drawPixels;

else                           fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__set(const xcode:longint32);//01feb2026

   procedure xswap32(var s,d:longint32);
   var
      t:longint32;
   begin

   t:=s;
   s:=d;
   d:=t;

   end;
begin

case xcode of

fd_fillAreaDefaults:begin

   fd_focus.flip      :=false;
   fd_focus.mirror    :=false;
   fd_focus.power255  :=255;
   fd_focus.splice100 :=100;

   end;

fd_errors            :fd_errors_ok:=true;
fd_noerrors          :fd_errors_ok:=false;

fd_optimise          :fd_optimise_ok:=true;
fd_nooptimise        :fd_optimise_ok:=false;

fd_flip              :fd_focus.flip:=true;
fd_noflip            :fd_focus.flip:=false;

fd_mirror            :fd_focus.mirror:=true;
fd_nomirror          :fd_focus.mirror:=false;

fd_roundNone         :fd_focus.rimage:=@resling_nil;

fd_roundCorner       :begin

                      case (viscale>=2) of
                      true:fd_focus.rimage:=@resling_corner200;//larger corner image for larger active scaling - 01feb2026
                      else fd_focus.rimage:=@resling_corner;
                      end;//case

                      end;

fd_roundCornerTight  :fd_focus.rimage:=@resling_cornerTight;

fd_roundmodeAll      :fd_focus.rmode:=rmAll;
fd_roundmodeTopOnly  :fd_focus.rmode:=rmTopOnly;
fd_roundmodeBotOnly  :fd_focus.rmode:=rmBotOnly;

fd_swapArea12:begin

   xswap32( fd_focus.b.ax1     ,fd_focus.b2.ax1 );
   xswap32( fd_focus.b.ax2     ,fd_focus.b2.ax2 );
   xswap32( fd_focus.b.ay1     ,fd_focus.b2.ay1 );
   xswap32( fd_focus.b.ay2     ,fd_focus.b2.ay2 );
   xswap32( fd_focus.b.aw      ,fd_focus.b2.aw  );
   xswap32( fd_focus.b.ah      ,fd_focus.b2.ah  );
   xswap32( fd_focus.b.amode   ,fd_focus.b2.amode );

   if ( fd_focus.b.w<>fd_focus.b2.w ) or ( fd_focus.b.h<>fd_focus.b2.h ) then
      begin

      xfd__sync_amode( fd_focus.b  );
      xfd__sync_amode( fd_focus.b2 );

      end;

   end;

fd_storeClip:begin

   with fd_focus.b do
   begin

   if ok then
      begin

      scx1     :=cx1;
      scx2     :=cx2;
      scy1     :=cy1;
      scy2     :=cy2;
      scok     :=true;

      end;

   end;

   end;

fd_storeClip2:begin

   with fd_focus.b2 do
   begin

   if ok then
      begin

      scx1     :=cx1;
      scx2     :=cx2;
      scy1     :=cy1;
      scy2     :=cy2;
      scok     :=true;

      end;

   end;

   end;

fd_restoreClip:begin

   with fd_focus.b do
   begin

   if scok then
      begin

      cx1      :=scx1;
      cx2      :=scx2;
      cy1      :=scy1;
      cy2      :=scy2;

      end;

   end;

   end;

fd_restoreClip2:begin

   with fd_focus.b2 do
   begin

   if scok then
      begin

      cx1      :=scx1;
      cx2      :=scx2;
      cy1      :=scy1;
      cy2      :=scy2;

      end;

   end;

   end;

fd_storeArea:begin

   with fd_focus.b do
   begin

   if ok then
      begin

      sax1     :=ax1;
      sax2     :=ax2;
      say1     :=ay1;
      say2     :=ay2;
      saw      :=aw;
      sah      :=ah;
      samode   :=amode;
      saok     :=true;

      end;

   end;

   end;

fd_storeArea2:begin

   with fd_focus.b2 do
   begin

   if ok then
      begin

      sax1     :=ax1;
      sax2     :=ax2;
      say1     :=ay1;
      say2     :=ay2;
      saw      :=aw;
      sah      :=ah;
      samode   :=amode;
      saok     :=true;

      end;

   end;

   end;

fd_restoreArea:begin

   with fd_focus.b do
   begin

   if saok then
      begin

      ax1      :=sax1;
      ax2      :=sax2;
      ay1      :=say1;
      ay2      :=say2;
      aw       :=saw;
      ah       :=sah;
      amode    :=samode;

      end;

   end;

   end;

fd_restoreArea2:begin

   with fd_focus.b2 do
   begin

   if saok then
      begin

      ax1      :=sax1;
      ax2      :=sax2;
      ay1      :=say1;
      ay2      :=say2;
      aw       :=saw;
      ah       :=sah;
      amode    :=samode;

      end;

   end;

   end;

fd_trimAreaToFitBuffer  :xfd__trimAreaToFitBuffer( fd_focus.b  );
fd_trimAreaToFitBuffer2 :xfd__trimAreaToFitBuffer( fd_focus.b2 );

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

function fd__getbol(const xcode:longint32):boolean;
begin

case xcode of

fd_getflip     :result:=fd_focus.flip;

fd_getmirror   :result:=fd_focus.mirror;

else
   begin

   result:=false;
   fd__showerror(fd_propertyMismatch,xcode);

   end;
end;//case

end;

procedure fd__setbol(const xcode:longint32;const xval:boolean);
begin

case xcode of

fd_setflip     :fd_focus.flip:=xval;

fd_setmirror   :fd_focus.mirror:=xval;

else
   begin

   fd__showerror(fd_propertyMismatch,xcode);

   end;
end;//case

end;

function fd__getval(const xcode:longint):longint32;
begin

case xcode of

fd_getdrawProc   :result:=fd_drawproc32;
fd_getpower      :result:=fd_focus.power255;
fd_getsplice     :result:=fd_focus.splice100;//07jan2026

fd_getAreaMode:begin

   case fd_focus.b.ok of
   true:result:=fd_focus.b.amode;
   else result:=fd_area_outside_clip;
   end;//case

   end;

fd_getClipMode:begin

   case fd_focus.b.ok of
   true:result:=fd_area_inside_clip;
   else result:=fd_area_outside_clip;
   end;//case

   end;

fd_getAreaMode2:begin

   case fd_focus.b2.ok of
   true:result:=fd_focus.b2.amode;
   else result:=fd_area_outside_clip;
   end;//case

   end;

fd_getClipMode2:begin

   case fd_focus.b2.ok of
   true:result:=fd_area_inside_clip;
   else result:=fd_area_outside_clip;
   end;//case

   end;

fd_getcolor1:result:=c32__int(fd_focus.color1);

fd_getcolor2:result:=c32__int(fd_focus.color2);

fd_getcolor3:result:=c32__int(fd_focus.color3);

fd_getcolor4:result:=c32__int(fd_focus.color4);

else
   begin

   result:=0;
   fd__showerror(fd_propertyMismatch,xcode);

   end;

end;//case

end;

procedure fd__setval(const xcode,xval:longint32);
begin

case xcode of

fd_setlayer:begin

   if (fd_focus.lr8=nil) then fd_focus.lv8:=-1
   else if (xval<-1)     then fd_focus.lv8:=-1
   else if (xval>255)    then fd_focus.lv8:=255
   else                       fd_focus.lv8:=xval;

   end;

fd_setpower:begin

   if      (xval<0)   then fd_focus.power255:=0
   else if (xval>255) then fd_focus.power255:=255
   else                    fd_focus.power255:=xval;

   end;

fd_setsplice:begin

   if      (xval<0)   then fd_focus.splice100:=0
   else if (xval>100) then fd_focus.splice100:=100
   else                    fd_focus.splice100:=xval;

   end;

fd_setcolor1      :fd_focus.color1           :=int__c32(xval);

fd_setcolor2      :fd_focus.color2           :=int__c32(xval);

fd_setcolor3      :fd_focus.color3           :=int__c32(xval);

fd_setcolor4      :fd_focus.color4           :=int__c32(xval);

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__getrgba(const xcode:longint;var r,g,b,a:byte);
begin

case xcode of

fd_getcolor1:begin

   r  :=fd_focus.color1.r;
   g  :=fd_focus.color1.g;
   b  :=fd_focus.color1.b;
   a  :=fd_focus.color1.a;

   end;

fd_getcolor2:begin

   r  :=fd_focus.color2.r;
   g  :=fd_focus.color2.g;
   b  :=fd_focus.color2.b;
   a  :=fd_focus.color2.a;

   end;

fd_getcolor3:begin

   r  :=fd_focus.color3.r;
   g  :=fd_focus.color3.g;
   b  :=fd_focus.color3.b;
   a  :=fd_focus.color3.a;

   end;

fd_getcolor4:begin

   r  :=fd_focus.color4.r;
   g  :=fd_focus.color4.g;
   b  :=fd_focus.color4.b;
   a  :=fd_focus.color4.a;

   end;

else
   begin

   r  :=255;
   g  :=255;
   b  :=255;
   a  :=255;

   fd__showerror(fd_propertyMismatch,xcode);

   end;

end;//case

end;

procedure fd__setrgba(const xcode:longint32;const r,g,b,a:byte);
begin

case xcode of

fd_setcolor1:begin

   fd_focus.color1.r  :=r;
   fd_focus.color1.g  :=g;
   fd_focus.color1.b  :=b;
   fd_focus.color1.a  :=a;

   end;

fd_setcolor2:begin

   fd_focus.color2.r  :=r;
   fd_focus.color2.g  :=g;
   fd_focus.color2.b  :=b;
   fd_focus.color2.a  :=a;

   end;

fd_setcolor3:begin

   fd_focus.color3.r  :=r;
   fd_focus.color3.g  :=g;
   fd_focus.color3.b  :=b;
   fd_focus.color3.a  :=a;

   end;

fd_setcolor4:begin

   fd_focus.color4.r  :=r;
   fd_focus.color4.g  :=g;
   fd_focus.color4.b  :=b;
   fd_focus.color4.a  :=a;

   end;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

function fd__getarea(const xcode:longint):twinrect;
begin

case xcode of

fd_getarea:begin

   if fd_focus.b.ok then
      begin

      result.left     :=fd_focus.b.ax1;
      result.right    :=fd_focus.b.ax2;
      result.top      :=fd_focus.b.ay1;
      result.bottom   :=fd_focus.b.ay2;

      end
   else
      begin

      result.left     :=0;
      result.right    :=-1;
      result.top      :=0;
      result.bottom   :=-1;

      end;

   end;

fd_getclip:begin

   if fd_focus.b.ok then
      begin

      result.left     :=fd_focus.b.cx1;
      result.right    :=fd_focus.b.cx2;
      result.top      :=fd_focus.b.cy1;
      result.bottom   :=fd_focus.b.cy2;

      end
   else
      begin

      result.left     :=0;
      result.right    :=-1;
      result.top      :=0;
      result.bottom   :=-1;

      end;

   end;

fd_getbufferarea:begin

   if fd_focus.b.ok then
      begin

      result.left     :=0;
      result.right    :=fd_focus.b.w-1;
      result.top      :=0;
      result.bottom   :=fd_focus.b.h-1;

      end
   else
      begin

      result.left     :=0;
      result.right    :=-1;
      result.top      :=0;
      result.bottom   :=-1;

      end;

   end;

fd_getarea2:begin

   if fd_focus.b2.ok then
      begin

      result.left     :=fd_focus.b2.ax1;
      result.right    :=fd_focus.b2.ax2;
      result.top      :=fd_focus.b2.ay1;
      result.bottom   :=fd_focus.b2.ay2;

      end
   else
      begin

      result.left     :=0;
      result.right    :=-1;
      result.top      :=0;
      result.bottom   :=-1;

      end;

   end;

fd_getclip2:begin

   if fd_focus.b2.ok then
      begin

      result.left     :=fd_focus.b2.cx1;
      result.right    :=fd_focus.b2.cx2;
      result.top      :=fd_focus.b2.cy1;
      result.bottom   :=fd_focus.b2.cy2;

      end
   else
      begin

      result.left     :=0;
      result.right    :=-1;
      result.top      :=0;
      result.bottom   :=-1;

      end;

   end;

fd_getbufferarea2:begin

   if fd_focus.b2.ok then
      begin

      result.left     :=0;
      result.right    :=fd_focus.b2.w-1;
      result.top      :=0;
      result.bottom   :=fd_focus.b2.h-1;

      end
   else
      begin

      result.left     :=0;
      result.right    :=-1;
      result.top      :=0;
      result.bottom   :=-1;

      end;

   end;

else
   begin

   result.left     :=0;
   result.right    :=-1;
   result.top      :=0;
   result.bottom   :=-1;

   fd__showerror(fd_propertyMismatch,xcode);

   end;

end;//case

end;

procedure fd__getarea2(const xcode:longint;var x,y,w,h:longint32);
begin

case xcode of

fd_getarea:begin

   if fd_focus.b.ok then
      begin

      x     :=fd_focus.b.ax1;
      w     :=fd_focus.b.aw;
      y     :=fd_focus.b.ay1;
      h     :=fd_focus.b.ah;

      end
   else
      begin

      x     :=0;
      w     :=0;
      y     :=0;
      h     :=0;

      end;

   end;

fd_getclip:begin

   if fd_focus.b.ok then
      begin

      x     :=fd_focus.b.cx1;
      w     :=fd_focus.b.cx2-fd_focus.b.cx1+1;
      y     :=fd_focus.b.cy1;
      h     :=fd_focus.b.cy2-fd_focus.b.cy1+1;

      end
   else
      begin

      x     :=0;
      w     :=0;
      y     :=0;
      h     :=0;

      end;

   end;

fd_getbufferarea:begin

   if fd_focus.b.ok then
      begin

      x     :=0;
      w     :=fd_focus.b.w;
      y     :=0;
      h     :=fd_focus.b.h;

      end
   else
      begin

      x     :=0;
      w     :=0;
      y     :=0;
      h     :=0;

      end;

   end;

fd_getarea2:begin

   if fd_focus.b2.ok then
      begin

      x     :=fd_focus.b2.ax1;
      w     :=fd_focus.b2.aw;
      y     :=fd_focus.b2.ay1;
      h     :=fd_focus.b2.ah;

      end
   else
      begin

      x     :=0;
      w     :=0;
      y     :=0;
      h     :=0;

      end;

   end;

fd_getclip2:begin

   if fd_focus.b2.ok then
      begin

      x     :=fd_focus.b2.cx1;
      w     :=fd_focus.b2.cx2-fd_focus.b2.cx1+1;
      y     :=fd_focus.b2.cy1;
      h     :=fd_focus.b2.cy2-fd_focus.b2.cy1+1;

      end
   else
      begin

      x     :=0;
      w     :=0;
      y     :=0;
      h     :=0;

      end;

   end;

fd_getbufferarea2:begin

   if fd_focus.b2.ok then
      begin

      x     :=0;
      w     :=fd_focus.b2.w;
      y     :=0;
      h     :=fd_focus.b2.h;

      end
   else
      begin

      x     :=0;
      w     :=0;
      y     :=0;
      h     :=0;

      end;

   end;

else
   begin

   x        :=0;
   w        :=0;
   y        :=0;
   h        :=0;

   fd__showerror(fd_propertyMismatch,xcode);

   end;

end;//case

end;

procedure fd__setarea(const xcode:longint;const x:twinrect);
begin

case xcode of

fd_setarea:if fd_focus.b.ok then
   begin

   fd_focus.b.ax1   :=x.left;
   fd_focus.b.ax2   :=x.right;
   fd_focus.b.ay1   :=x.top;
   fd_focus.b.ay2   :=x.bottom;
   fd_focus.b.aw    :=x.right-x.left+1;
   fd_focus.b.ah    :=x.bottom-x.top+1;

   xfd__sync_amode( fd_focus.b );

   end;

fd_setclip:if fd_focus.b.ok then
   begin

   //x1
   if      (x.left<0)                  then fd_focus.b.cx1:=0
   else if (x.left>=fd_focus.b.w)      then fd_focus.b.cx1:=fd_focus.b.w-1
   else                                     fd_focus.b.cx1:=x.left;

   //x2
   if      (x.right<fd_focus.b.cx1)    then fd_focus.b.cx2:=fd_focus.b.cx1
   else if (x.right>=fd_focus.b.w)     then fd_focus.b.cx2:=fd_focus.b.w-1
   else                                     fd_focus.b.cx2:=x.right;

   //y1
   if      (x.top<0)                   then fd_focus.b.cy1:=0
   else if (x.top>=fd_focus.b.h)       then fd_focus.b.cy1:=fd_focus.b.h-1
   else                                     fd_focus.b.cy1:=x.top;

   //y2
   if      (x.bottom<fd_focus.b.cy1)   then fd_focus.b.cy2:=fd_focus.b.cy1
   else if (x.bottom>=fd_focus.b.h)    then fd_focus.b.cy2:=fd_focus.b.h-1
   else                                     fd_focus.b.cy2:=x.bottom;

   end;

fd_setarea2:if fd_focus.b2.ok then
   begin

   fd_focus.b2.ax1  :=x.left;
   fd_focus.b2.ax2  :=x.right;
   fd_focus.b2.ay1  :=x.top;
   fd_focus.b2.ay2  :=x.bottom;
   fd_focus.b2.aw   :=x.right-x.left+1;
   fd_focus.b2.ah   :=x.bottom-x.top+1;

   xfd__sync_amode( fd_focus.b2 );

   end;

fd_setclip2:if fd_focus.b2.ok then
   begin

   //x1
   if      (x.left<0)                  then fd_focus.b2.cx1:=0
   else if (x.left>=fd_focus.b2.w)     then fd_focus.b2.cx1:=fd_focus.b2.w-1
   else                                     fd_focus.b2.cx1:=x.left;

   //x2
   if      (x.right<fd_focus.b2.cx1)   then fd_focus.b2.cx2:=fd_focus.b2.cx1
   else if (x.right>=fd_focus.b2.w)    then fd_focus.b2.cx2:=fd_focus.b2.w-1
   else                                     fd_focus.b2.cx2:=x.right;

   //y1
   if      (x.top<0)                   then fd_focus.b2.cy1:=0
   else if (x.top>=fd_focus.b2.h)      then fd_focus.b2.cy1:=fd_focus.b2.h-1
   else                                     fd_focus.b2.cy1:=x.top;

   //y2
   if      (x.bottom<fd_focus.b2.cy1)  then fd_focus.b2.cy2:=fd_focus.b2.cy1
   else if (x.bottom>=fd_focus.b2.h)   then fd_focus.b2.cy2:=fd_focus.b2.h-1
   else                                     fd_focus.b2.cy2:=x.bottom;

   end;

fd_setarea12:begin//set both areas at once

   fd__setarea( fd_setarea  ,x );
   fd__setarea( fd_setarea2 ,x );

   end;

fd_setclip12:begin//set both clips at once

   fd__setarea( fd_setclip  ,x );
   fd__setarea( fd_setclip2 ,x );

   end;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__setarea2(const xcode,x,y,w,h:longint32);
begin

case xcode of

fd_setarea:if fd_focus.b.ok then
   begin

   fd_focus.b.ax1   :=x;
   fd_focus.b.ax2   :=x+w-1;
   fd_focus.b.ay1   :=y;
   fd_focus.b.ay2   :=y+h-1;
   fd_focus.b.aw    :=w;
   fd_focus.b.ah    :=h;

   xfd__sync_amode( fd_focus.b );

   end;

fd_setclip:if fd_focus.b.ok then
   begin

   //x1
   if      (x<0)                       then fd_focus.b.cx1:=0
   else if (x>=fd_focus.b.w)           then fd_focus.b.cx1:=fd_focus.b.w-1
   else                                     fd_focus.b.cx1:=x;

   //x2
   if      ((x+w-1)<fd_focus.b.cx1)    then fd_focus.b.cx2:=fd_focus.b.cx1
   else if ((x+w-1)>=fd_focus.b.w)     then fd_focus.b.cx2:=fd_focus.b.w-1
   else                                     fd_focus.b.cx2:=(x+w-1);

   //y1
   if      (y<0)                       then fd_focus.b.cy1:=0
   else if (y>=fd_focus.b.h)           then fd_focus.b.cy1:=fd_focus.b.h-1
   else                                     fd_focus.b.cy1:=y;

   //y2
   if      ((y+h-1)<fd_focus.b.cy1)    then fd_focus.b.cy2:=fd_focus.b.cy1
   else if ((y+h-1)>=fd_focus.b.h)     then fd_focus.b.cy2:=fd_focus.b.h-1
   else                                     fd_focus.b.cy2:=(y+h-1);

   end;

fd_setarea2:if fd_focus.b2.ok then
   begin

   fd_focus.b2.ax1  :=x;
   fd_focus.b2.ax2  :=x+w-1;
   fd_focus.b2.ay1  :=y;
   fd_focus.b2.ay2  :=y+h-1;
   fd_focus.b2.aw   :=w;
   fd_focus.b2.ah   :=h;

   xfd__sync_amode( fd_focus.b2 );

   end;

fd_setclip2:if fd_focus.b2.ok then
   begin

   //x1
   if      (x<0)                       then fd_focus.b2.cx1:=0
   else if (x>=fd_focus.b2.w)          then fd_focus.b2.cx1:=fd_focus.b2.w-1
   else                                     fd_focus.b2.cx1:=x;

   //x2
   if      ((x+w-1)<fd_focus.b2.cx1)   then fd_focus.b2.cx2:=fd_focus.b2.cx1
   else if ((x+w-1)>=fd_focus.b2.w)    then fd_focus.b2.cx2:=fd_focus.b2.w-1
   else                                     fd_focus.b2.cx2:=(x+w-1);

   //y1
   if      (y<0)                       then fd_focus.b2.cy1:=0
   else if (y>=fd_focus.b2.h)          then fd_focus.b2.cy1:=fd_focus.b2.h-1
   else                                     fd_focus.b2.cy1:=y;

   //y2
   if      ((y+h-1)<fd_focus.b2.cy1)   then fd_focus.b2.cy2:=fd_focus.b2.cy1
   else if ((y+h-1)>=fd_focus.b2.h)    then fd_focus.b2.cy2:=fd_focus.b2.h-1
   else                                     fd_focus.b2.cy2:=(y+h-1);

   end;

fd_setarea12:begin//set both areas at once

   fd__setarea2( fd_setarea  ,x ,y ,w ,h );
   fd__setarea2( fd_setarea2 ,x ,y ,w ,h );

   end;

fd_setclip12:begin//set both clips at once

   fd__setarea2( fd_setclip  ,x ,y ,w ,h );
   fd__setarea2( fd_setclip2 ,x ,y ,w ,h );

   end;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

//???????????????????????????????????//ffffffffffffffffffffffff
procedure fd__setbuffer(const xcode:longint32;const xval:tobject);
var
   f:pfastdrawbuffer;
begin

//get
case xcode of

fd_setbuffer  :f:=@fd_focus.b;

fd_setbuffer2 :f:=@fd_focus.b2;

fd_setbuffer12:begin

   fd__setbuffer( fd_setbuffer  ,xval );
   fd_focus.b2:=fd_focus.b;
   exit;

   end;

fd_setbufferFromBuffer2:begin

   fd_focus.b:=fd_focus.b2;
   exit;

   end;

fd_setbuffer2FromBuffer:begin

   fd_focus.b2:=fd_focus.b;
   exit;

   end;

else
   begin

   fd__showerror(fd_propertyMismatch,xcode);
   exit;

   end;

end;//case


//host is a GUI
if (xval is tbasicsystem) then
   begin

   with (xval as tbasicsystem) do
   begin

   f.w        :=frcmax32( width  ,buffer.width  );
   f.h        :=frcmax32( height ,buffer.height );
   f.rows     :=buffer.prows32;
   f.bits     :=buffer.bits;

   end;

   end

//host is an image
else if misok2432( xval ,f.bits ,f.w ,f.h ) then
   begin

   misrows32( xval ,f.rows );

   end

//host is not valid
else begin

   with fd_focus.b do
   begin

   w    :=0;
   h    :=0;
   bits :=0;
   rows :=nil;

   end;

   end;

//sync
f.ok        :=(f.w>=1) and (f.h>=1) and ((f.bits=24) or (f.bits=32)) and (f.rows<>nil);

if f.ok then
   begin

   with f^ do
   begin

   //.clip area
   cx1       :=0;
   cx2       :=(w-1);
   cy1       :=0;
   cy2       :=(h-1);

   //.area
   ax1       :=0;
   ax2       :=cx2;
   ay1       :=0;
   ay2       :=cy2;
   aw        :=w;
   ah        :=h;

   end;

   //.sync amode
   xfd__sync_amode( f^ );

   end;

end;

procedure fd__setLayerMask(const xval:tobject);
var
   f:pfastdrawbuffer;
   xwasok:boolean;
   sbits,sw,sh:longint32;
begin

//host is a GUI
if (xval is tbasicsystem) then
   begin

   with (xval as tbasicsystem) do
   begin

   case (mask.width>=fd_focus.b.w) and (mask.height>=fd_focus.b.h) of
   true:fd_focus.lr8:=mask.prows8;
   else fd_focus.lr8:=nil;
   end;//case

   end;

   end

//host is an image
else if misok82432( xval ,sbits ,sw ,sh ) then
   begin

   case (sbits=8) and (sw>=fd_focus.b.w) and (sh>=fd_focus.b.h) of
   true:misrows8( xval ,fd_focus.lr8 );
   else fd_focus.lr8:=nil;
   end;//case

   end

//host is not valid
else begin

   fd_focus.lr8:=nil;

   end;

//defaults
fd_focus.lv8:=-1;

end;

procedure xfd__roundStart(const xcode:longint32);
var
   dx,dy:longint32;
   dTop,dBot,dflip,dmirror:boolean;
begin

//up to next slot
inc(fd_focus.rindex);

//slot index not within valid range -> rindex can go above and below allowed range - 05jan2026
if (fd_focus.rindex>high(fd_focus.rlist)) then
   begin

   showbasic('rindex overload');//???????????

   end;//???????????????
   

if (fd_focus.rindex<0) or (fd_focus.rindex>high(fd_focus.rlist)) then exit;

//get
with fd_focus.rlist[ fd_focus.rindex ] do
begin

rok:=fd_focus.b.ok and (fd_focus.rimage^.w>=1);
if not rok then exit;

case xcode of

fd_roundStartFromArea,fd_roundStartFromAreaDebug:begin

   if (fd_focus.b.amode<>fd_area_outside_clip) then
      begin

      rx1    :=fd_focus.b.ax1;
      rx2    :=fd_focus.b.ax2-fd_focus.rimage^.w+1;
      ry1    :=fd_focus.b.ay1;
      ry2    :=fd_focus.b.ay2-fd_focus.rimage^.h+1;
      rmode  :=fd_focus.b.amode;

      end
   else
      begin

      rok:=false;
      exit;

      end;

   end;

fd_roundStartFromClip:begin

   rx1    :=fd_focus.b.cx1;
   rx2    :=fd_focus.b.cx2-fd_focus.rimage^.w+1;
   ry1    :=fd_focus.b.cy1;
   ry2    :=fd_focus.b.cy2-fd_focus.rimage^.h+1;
   rmode  :=fd_focus.b.amode;

   end;

else
   begin

   rok:=false;
   exit;

   end;
end;//case

//store
dx                     :=fd_focus.b.ax1;
dy                     :=fd_focus.b.ay1;
dflip                  :=fd_focus.flip;
dmirror                :=fd_focus.mirror;
dtop                   :=(fd_focus.rmode=rmAll) or (fd_focus.rmode=rmTopOnly);
dbot                   :=(fd_focus.rmode=rmAll) or (fd_focus.rmode=rmBotOnly);

fd_focus.b.ax1         :=rx1;
fd_focus.b.ay1         :=ry1;
fd_focus.flip          :=false;
fd_focus.mirror        :=false;

//top-left
case dtop of
true:xfd__lingCapture_template_flip_mirror_nochecks( fd_focus^ ,fd_focus.b ,@rtl );
else rtl.w:=0;
end;//case

//top-right
fd_focus.b.ax1         :=rx2;
fd_focus.mirror        :=true;

case dtop of
true:xfd__lingCapture_template_flip_mirror_nochecks( fd_focus^ ,fd_focus.b ,@rtr );
else rtr.w:=0;
end;//case

//bottom-right
fd_focus.b.ay1         :=ry2;
fd_focus.flip          :=true;

case dbot of
true:xfd__lingCapture_template_flip_mirror_nochecks( fd_focus^ ,fd_focus.b ,@rbr );
else rbr.w:=0;
end;//case

//bottom-left
fd_focus.b.ax1         :=rx1;
fd_focus.mirror        :=false;

case dbot of
true:xfd__lingCapture_template_flip_mirror_nochecks( fd_focus^ ,fd_focus.b ,@rbl );
else rbl.w:=0;
end;//case

//restore
fd_focus.b.ax1         :=dx;
fd_focus.b.ay1         :=dy;
fd_focus.flip          :=dflip;
fd_focus.mirror        :=dmirror;

//debug
if (xcode=fd_roundStartFromAreaDebug) then
   begin

   xfd__ling_makedebug(rtl);
   xfd__ling_makedebug(rtr);
   xfd__ling_makedebug(rbr);
   xfd__ling_makedebug(rbl);

   end;

end;//with

end;

procedure xfd__roundEnd(const xdebug:boolean);
var
   ddrawproc,dx,dy,dmode:longint32;
   dflip,dmirror:boolean;

begin

//invalid buffer, outside round range, or round slot not in round mode -> dec rindex and do nothing
if (not fd_focus.b.ok) or (fd_focus.rindex<0) or (fd_focus.rindex>high(fd_focus.rlist)) or (not fd_focus.rlist[ fd_focus.rindex ].rok) then
   begin

   dec(fd_focus.rindex);
   exit;

   end;

//get
with fd_focus.rlist[ fd_focus.rindex ] do
begin

//store
dx                     :=fd_focus.b.ax1;
dy                     :=fd_focus.b.ay1;
dmode                  :=fd_focus.b.amode;
dflip                  :=fd_focus.flip;
dmirror                :=fd_focus.mirror;
ddrawProc              :=fd_drawproc32;

fd_focus.b.ax1         :=rx1;
fd_focus.b.ay1         :=ry1;
fd_focus.b.amode       :=rmode;//13jan2026
fd_focus.flip          :=false;
fd_focus.mirror        :=false;

//xdebug
if xdebug then
   begin

   xfd__ling_makedebug(rtl);
   xfd__ling_makedebug(rtr);
   xfd__ling_makedebug(rbr);
   xfd__ling_makedebug(rbl);

   end;

//top-left
if (rtl.w>=1) then ling__draw( fd_focus^ ,rtl );

//top-right
fd_focus.b.ax1         :=rx2;
if (rtr.w>=1) then ling__draw( fd_focus^ ,rtr );

//bottom-right
fd_focus.b.ay1         :=ry2;
if (rbr.w>=1) then ling__draw( fd_focus^ ,rbr );

//bottom-left
fd_focus.b.ax1         :=rx1;
if (rbl.w>=1) then ling__draw( fd_focus^ ,rbl );

//restore
fd_focus.b.ax1         :=dx;
fd_focus.b.ay1         :=dy;
fd_focus.b.amode       :=dmode;
fd_focus.flip          :=dflip;
fd_focus.mirror        :=dmirror;
fd_drawproc32          :=ddrawproc;

end;//with

//dec to previous slot -> can be above and below range
dec(fd_focus.rindex);

end;

procedure xfd__fillArea;//01jan2026, 25dec2025

   procedure xdraw;
   begin

   if      (fd_focus.power255=255) then xfd__fillArea300_layer_2432
   else if (fd_focus.power255>0)   then
      begin

      case fd_focus.b.bits of
      32:xfd__fillArea500_layer_power255_32;
      24:xfd__fillArea400_layer_power255_24;
      end;//case

      end;

   end;

begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.b.amode=fd_area_outside_clip) then exit;

//draw area
if (fd_focus.b.amode=fd_area_overlaps_clip) then
   begin

   //store
   fd__set(fd_storeArea);

   //trim area
   fd__set(fd_trimAreaToFitBuffer);

   //draw
   xdraw;

   //restore
   fd__set(fd_restoreArea);

   end
else xdraw;

end;

procedure xfd__fillArea300_layer_2432;//01jan2026, 29dec2025, 26dec2025, 24dec2025
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo24,xredo24,yredo32,xredo32,lyredo24,lxredo24,lyredo32,lxredo32,
   yredo96_N,xredo96_N,
   yredo96_32L,xredo96_32L,
   yredo96_24L,xredo96_24L;
var
    lr8:pcolorrows8;
   lr24:pcolorrows24;
   lr32:pcolorrows32;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   sr96:pcolorrows96;
   xstop,ystop,xreset,sx,sy:longint32;
   c24:tcolor24;
   c32:tcolor32;
   c96:tcolor96;
   lv8,lx1,lx2,rx1,rx2,xreset96,xstop96:longint32;
   dstop96,lindex,dindex:iauto;

   function xcan96:boolean;//supports 24 and 32bit in layer and non-layer modes
   begin

   result:=xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96);

   if result then
      begin

      sr96   :=pcolorrows96(fd_focus.b.rows);

      end;

   end;

begin

//defaults
fd_drawProc32:=300;

//quick check
if not fd_focus.b.ok then exit;

//init
xreset      :=fd_focus.b.ax1;
xstop       :=fd_focus.b.ax2;
sy          :=fd_focus.b.ay1;
ystop       :=fd_focus.b.ay2;
lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );

case fd_focus.b.bits of
24:begin

   lr32   :=pcolorrows32(lr8);
   sr24   :=pcolorrows24(fd_focus.b.rows);
   c24.r  :=fd_focus.color1.r;
   c24.g  :=fd_focus.color1.g;
   c24.b  :=fd_focus.color1.b;

   case xcan96 of
   true:begin

      c96.v0  :=c24.b;
      c96.v1  :=c24.g;
      c96.v2  :=c24.r;

      c96.v3  :=c24.b;
      c96.v4  :=c24.g;
      c96.v5  :=c24.r;

      c96.v6  :=c24.b;
      c96.v7  :=c24.g;
      c96.v8  :=c24.r;

      c96.v9  :=c24.b;
      c96.v10 :=c24.g;
      c96.v11 :=c24.r;

      case (fd_focus.lv8>=0) of
      true:begin

         fd_drawProc32:=397;
         goto yredo96_24L;

         end;
      else
         begin

         fd_drawProc32:=396;
         goto yredo96_N;

         end;
      end;//case

      end;
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         fd_drawProc32:=325;
         goto lyredo24;

         end;
      else
         begin

         fd_drawProc32:=324;
         goto yredo24;

         end;
      end;//case

      end;

   end;//case

   end;

32:begin

   lr24   :=pcolorrows24(lr8);
   sr32   :=pcolorrows32(fd_focus.b.rows);
   c32    :=fd_focus.color1;
   c32.a  :=255;

   case xcan96 of
   true:begin

      c96.v0  :=c32.b;
      c96.v1  :=c32.g;
      c96.v2  :=c32.r;
      c96.v3  :=c32.a;

      c96.v4  :=c32.b;
      c96.v5  :=c32.g;
      c96.v6  :=c32.r;
      c96.v7  :=c32.a;

      c96.v8  :=c32.b;
      c96.v9  :=c32.g;
      c96.v10 :=c32.r;
      c96.v11 :=c32.a;

      case (fd_focus.lv8>=0) of
      true:begin

         fd_drawProc32:=398;
         goto yredo96_32L;

         end;
      else begin

         fd_drawProc32:=396;
         goto yredo96_N;

         end;
      end;//case

      end
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         fd_drawProc32:=333;
         goto lyredo32;

         end;
      else begin

         fd_drawProc32:=332;
         goto yredo32;

         end;
      end;//case

      end;
   end;//case

   end;
else  exit;
end;//case


//render96_N (32bit=1500mps, 24bit=2000mps) ------------------------------------
yredo96_N:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset96;

xredo96_N:

//render pixel
sr96[sy][sx]:=c96;

//inc x
if (sx<>xstop96) then
   begin

   inc(sx,1);
   goto xredo96_N;

   end;

//row "begin" and "end" gaps
case fd_focus.b.bits of
32:begin

   for sx:=lx1 to lx2 do sr32[sy][sx]:=c32;
   for sx:=rx1 to rx2 do sr32[sy][sx]:=c32;

   end;
24:begin

   for sx:=lx1 to lx2 do sr24[sy][sx]:=c24;
   for sx:=rx1 to rx2 do sr24[sy][sx]:=c24;

   end;
end;//case

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_N;

   end;

//done
xfd__inc64;
exit;


//render96_32L (630mps) --------------------------------------------------------
yredo96_32L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr24[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_32L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0:=c32.b;//b
   pcolor96(dindex).v1:=c32.g;//g
   pcolor96(dindex).v2:=c32.r;//r
   //pcolor96(dindex).v3:=c32.a;//a

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   pcolor96(dindex).v4:=c32.b;//b
   pcolor96(dindex).v5:=c32.g;//g
   pcolor96(dindex).v6:=c32.r;//r
   //pcolor96(dindex).v7:=c32.a;//a

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   pcolor96(dindex).v8:=c32.b;//b
   pcolor96(dindex).v9:=c32.g;//g
   pcolor96(dindex).v10:=c32.r;//r
   //pcolor96(dindex).v11:=c32.a;//a

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   inc(lindex,sizeof(tcolor24));
   goto xredo96_32L;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;
for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_32L;

   end;

//done
xfd__inc64;
exit;


//render96_24L (620mps) --------------------------------------------------------
yredo96_24L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr32[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_24L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0:=c24.b;//b
   pcolor96(dindex).v1:=c24.g;//g
   pcolor96(dindex).v2:=c24.r;//r

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   pcolor96(dindex).v3:=c24.b;//b
   pcolor96(dindex).v4:=c24.g;//g
   pcolor96(dindex).v5:=c24.r;//r

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   pcolor96(dindex).v6:=c24.b;//b
   pcolor96(dindex).v7:=c24.g;//g
   pcolor96(dindex).v8:=c24.r;//r

   end;

if (pcolor32(lindex).a=lv8) then
   begin

   pcolor96(dindex).v9 :=c24.b;//b
   pcolor96(dindex).v10:=c24.g;//g
   pcolor96(dindex).v11:=c24.r;//r

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   inc(lindex,sizeof(tcolor32));
   goto xredo96_24L;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;
for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_24L;

   end;

//done
xfd__inc64;
exit;


//render32 (930mps) -----------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

xredo32:

//render pixel
sr32[sy][sx]:=c32;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   goto xredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo32;

   end;

//done
xfd__inc64;
exit;


//layer.render32 (550mps)-------------------------------------------------------
lyredo32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

lxredo32:

//render pixel
if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   goto lxredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto lyredo32;

   end;

//done
xfd__inc64;
exit;


//layer.render24 (520mps)-------------------------------------------------------
lyredo24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

lxredo24:

//render pixel
if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   goto lxredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto lyredo24;

   end;

//done
xfd__inc64;
exit;


//render24 (830mps) ------------------------------------------------------------
yredo24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

xredo24:

//render pixel
sr24[sy][sx]:=c24;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   goto xredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo24;

   end;

//done
xfd__inc64;

end;

procedure xfd__fillArea400_layer_power255_24;//01jan2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo24,xredo24,lyredo24,lxredo24,yredo96_24,xredo96_24,yredo96_24L,xredo96_24L;
var
    lr8:pcolorrows8;
   lr32:pcolorrows32;
   sr24:pcolorrows24;
   sr96:pcolorrows96;
   xstop,ystop,xreset,sx,sy:longint32;
   c24:tcolor24;
   s24:pcolor24;
   lv8,ca,cainv,lx1,lx2,rx1,rx2,xreset96,xstop96:longint32;
   dstop96,lindex,dindex:iauto;

   function xcan96:boolean;
   begin

   result:=xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96);

   if result then
      begin

      sr96   :=pcolorrows96(fd_focus.b.rows);

      end;

   end;

begin

//defaults
fd_drawProc32:=400;

//quick check
if not fd_focus.b.ok then exit;

//init
xreset      :=fd_focus.b.ax1;
xstop       :=fd_focus.b.ax2;
sy          :=fd_focus.b.ay1;
ystop       :=fd_focus.b.ay2;
lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );
ca          :=fd_focus.power255;
cainv       :=255-ca;
lr32        :=pcolorrows32( fd_focus.lr8 );
sr24        :=pcolorrows24( fd_focus.b.rows );

//.pre-compute
c24.r       :=(ca*fd_focus.color1.r) shr 8;
c24.g       :=(ca*fd_focus.color1.g) shr 8;
c24.b       :=(ca*fd_focus.color1.b) shr 8;

case xcan96 of

true:begin

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=498;
      goto yredo96_24L;

      end;
   else begin

      fd_drawProc32:=497;
      goto yredo96_24;

      end;
   end;//case

   end;

else begin

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=425;
      goto lyredo24;

      end;
   else begin

      fd_drawProc32:=424;
      goto yredo24;

      end;
   end;//case

   end;

end;//case


//render96_24.layer (440mps) ---------------------------------------------------
yredo96_24L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr32[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_24L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0 :=((cainv*pcolor96(dindex).v0 ) shr 8) + c24.b ;//b "shr 8" is 104% faster than "div 256"
   pcolor96(dindex).v1 :=((cainv*pcolor96(dindex).v1 ) shr 8) + c24.g ;//g
   pcolor96(dindex).v2 :=((cainv*pcolor96(dindex).v2 ) shr 8) + c24.r ;//r

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   pcolor96(dindex).v3 :=((cainv*pcolor96(dindex).v3 ) shr 8) + c24.b ;//b
   pcolor96(dindex).v4 :=((cainv*pcolor96(dindex).v4 ) shr 8) + c24.g ;//g
   pcolor96(dindex).v5 :=((cainv*pcolor96(dindex).v5 ) shr 8) + c24.r ;//r

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   pcolor96(dindex).v6 :=((cainv*pcolor96(dindex).v6 ) shr 8) + c24.b ;//b
   pcolor96(dindex).v7 :=((cainv*pcolor96(dindex).v7 ) shr 8) + c24.g ;//g
   pcolor96(dindex).v8 :=((cainv*pcolor96(dindex).v8 ) shr 8) + c24.r;//r

   end;

if (pcolor32(lindex).a=lv8) then
   begin

   pcolor96(dindex).v9 :=((cainv*pcolor96(dindex).v9 ) shr 8) + c24.b ;//b
   pcolor96(dindex).v10:=((cainv*pcolor96(dindex).v10) shr 8) + c24.g ;//g
   pcolor96(dindex).v11:=((cainv*pcolor96(dindex).v11) shr 8) + c24.r;//r

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   inc(lindex,sizeof(tcolor32));
   goto xredo96_24L;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do if (lr8[sy][sx]=lv8) then
begin

s24:=@sr24[sy][sx];
s24.r:=((cainv*s24.r) shr 8) + c24.r;
s24.g:=((cainv*s24.g) shr 8) + c24.g;
s24.b:=((cainv*s24.b) shr 8) + c24.b;

end;//sx

for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then
begin

s24:=@sr24[sy][sx];
s24.r:=((cainv*s24.r) shr 8) + c24.r;
s24.g:=((cainv*s24.g) shr 8) + c24.g;
s24.b:=((cainv*s24.b) shr 8) + c24.b;

end;//sx

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_24L;

   end;

//done
xfd__inc64;
exit;


//render96_24 (510mps) ---------------------------------------------------------
yredo96_24:

xfd__inc32(fd_focus.b.aw);
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_24:

//render pixel
pcolor96(dindex).v0 :=((cainv*pcolor96(dindex).v0 ) shr 8) + c24.b ;//b "shr 8" is 104% faster than "div 256"
pcolor96(dindex).v1 :=((cainv*pcolor96(dindex).v1 ) shr 8) + c24.g ;//g
pcolor96(dindex).v2 :=((cainv*pcolor96(dindex).v2 ) shr 8) + c24.r ;//r
pcolor96(dindex).v3 :=((cainv*pcolor96(dindex).v3 ) shr 8) + c24.b ;//b
pcolor96(dindex).v4 :=((cainv*pcolor96(dindex).v4 ) shr 8) + c24.g ;//g
pcolor96(dindex).v5 :=((cainv*pcolor96(dindex).v5 ) shr 8) + c24.r ;//r
pcolor96(dindex).v6 :=((cainv*pcolor96(dindex).v6 ) shr 8) + c24.b ;//b
pcolor96(dindex).v7 :=((cainv*pcolor96(dindex).v7 ) shr 8) + c24.g ;//g
pcolor96(dindex).v8 :=((cainv*pcolor96(dindex).v8 ) shr 8) + c24.r ;//r
pcolor96(dindex).v9 :=((cainv*pcolor96(dindex).v9 ) shr 8) + c24.b ;//b
pcolor96(dindex).v10:=((cainv*pcolor96(dindex).v10) shr 8) + c24.g;//g
pcolor96(dindex).v11:=((cainv*pcolor96(dindex).v11) shr 8) + c24.r;//r

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   goto xredo96_24;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do
begin

s24:=@sr24[sy][sx];
s24.r:=((cainv*s24.r) shr 8) + c24.r;
s24.g:=((cainv*s24.g) shr 8) + c24.g;
s24.b:=((cainv*s24.b) shr 8) + c24.b;

end;//sx

for sx:=rx1 to rx2 do
begin

s24:=@sr24[sy][sx];
s24.r:=((cainv*s24.r) shr 8) + c24.r;
s24.g:=((cainv*s24.g) shr 8) + c24.g;
s24.b:=((cainv*s24.b) shr 8) + c24.b;

end;//sx

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_24;

   end;

//done
xfd__inc64;
exit;


//render24 (450mps) ------------------------------------------------------------
yredo24:

xfd__inc32(fd_focus.b.aw);
dindex  :=iauto( @sr24[sy][xreset] );
dstop96 :=iauto( @sr24[sy][xstop] );

xredo24:

//render pixel
pcolor24(dindex).r :=((cainv*pcolor24(dindex).r) shr 8) + c24.r;
pcolor24(dindex).g :=((cainv*pcolor24(dindex).g) shr 8) + c24.g;
pcolor24(dindex).b :=((cainv*pcolor24(dindex).b) shr 8) + c24.b;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor24));
   goto xredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo24;

   end;

//done
xfd__inc64;
exit;


//layer.render24 (410mps)-------------------------------------------------------
lyredo24:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr8 [sy][xreset] );
dindex  :=iauto( @sr24[sy][xreset] );
dstop96 :=iauto( @sr24[sy][xstop] );

lxredo24:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor24(dindex).r :=((cainv*pcolor24(dindex).r) shr 8) + c24.r;
   pcolor24(dindex).g :=((cainv*pcolor24(dindex).g) shr 8) + c24.g;
   pcolor24(dindex).b :=((cainv*pcolor24(dindex).b) shr 8) + c24.b;

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor24));
   inc(lindex,sizeof(tcolor8));
   goto lxredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto lyredo24;

   end;

//done
xfd__inc64;

end;

procedure xfd__fillArea500_layer_power255_32;//01jan2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo32,xredo32,lyredo32,lxredo32,yredo96_32,xredo96_32,yredo96_32L,xredo96_32L;
var
    lr8:pcolorrows8;
   lr24:pcolorrows24;
   sr32:pcolorrows32;
   sr96:pcolorrows96;
   xstop,ystop,xreset,sx,sy:longint32;
   c32:tcolor32;
   s32:pcolor32;
   lv8,ca,cainv,lx1,lx2,rx1,rx2,xreset96,xstop96:longint32;
   dstop96,lindex,dindex:iauto;

   function xcan96:boolean;
   begin

   result:=xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96);

   if result then
      begin

      sr96   :=pcolorrows96(fd_focus.b.rows);

      end;

   end;

begin

//defaults
fd_drawProc32:=500;

//quick check
if not fd_focus.b.ok then exit;

//init
xreset      :=fd_focus.b.ax1;
xstop       :=fd_focus.b.ax2;
sy          :=fd_focus.b.ay1;
ystop       :=fd_focus.b.ay2;
lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );
ca          :=fd_focus.power255;
cainv       :=255-ca;
lr24        :=pcolorrows24( fd_focus.lr8 );
sr32        :=pcolorrows32( fd_focus.b.rows );

//.pre-compute
c32.r       :=(ca*fd_focus.color1.r) shr 8;
c32.g       :=(ca*fd_focus.color1.g) shr 8;
c32.b       :=(ca*fd_focus.color1.b) shr 8;
c32.a       :=(ca*255              ) shr 8;

case xcan96 of
true:begin

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=597;
      goto yredo96_32L;

      end;
   else begin

      fd_drawProc32:=596;
      goto yredo96_32;

      end;
   end;//case

   end
else begin

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=533;
      goto lyredo32;

      end;
   else
      begin

      fd_drawProc32:=532;
      goto yredo32;

      end;
   end;//case

   end;
end;//case


//render96_32 (500mps) ---------------------------------------------------------
yredo96_32:

xfd__inc32(fd_focus.b.aw);
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_32:

//render pixel
pcolor96(dindex).v0 :=((cainv*pcolor96(dindex).v0 ) shr 8) + c32.b ;//b "shr 8" is 104% faster than "div 256"
pcolor96(dindex).v1 :=((cainv*pcolor96(dindex).v1 ) shr 8) + c32.g ;//g
pcolor96(dindex).v2 :=((cainv*pcolor96(dindex).v2 ) shr 8) + c32.r ;//r
//pcolor96(dindex).v3 :=((cainv*pcolor96(dindex).v3 ) shr 8) + c32.a ;//a

pcolor96(dindex).v4 :=((cainv*pcolor96(dindex).v4 ) shr 8) + c32.b ;//b
pcolor96(dindex).v5 :=((cainv*pcolor96(dindex).v5 ) shr 8) + c32.g ;//g
pcolor96(dindex).v6 :=((cainv*pcolor96(dindex).v6 ) shr 8) + c32.r ;//r
//pcolor96(dindex).v7 :=((cainv*pcolor96(dindex).v7 ) shr 8) + c32.a ;//a

pcolor96(dindex).v8 :=((cainv*pcolor96(dindex).v8 ) shr 8) + c32.b ;//b
pcolor96(dindex).v9 :=((cainv*pcolor96(dindex).v9 ) shr 8) + c32.g ;//g
pcolor96(dindex).v10:=((cainv*pcolor96(dindex).v10) shr 8) + c32.r;//r
//pcolor96(dindex).v11:=((cainv*pcolor96(dindex).v11) shr 8) + c32.a;//a

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   goto xredo96_32;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do
begin

s32:=@sr32[sy][sx];
s32.r:=((cainv*s32.r) shr 8) + c32.r;
s32.g:=((cainv*s32.g) shr 8) + c32.g;
s32.b:=((cainv*s32.b) shr 8) + c32.b;
//s32.a:=((cainv*s32.a) shr 8) + c32.a;

end;//sx

for sx:=rx1 to rx2 do
begin

s32:=@sr32[sy][sx];
s32.r:=((cainv*s32.r) shr 8) + c32.r;
s32.g:=((cainv*s32.g) shr 8) + c32.g;
s32.b:=((cainv*s32.b) shr 8) + c32.b;
//s32.a:=((cainv*s32.a) shr 8) + c32.a;

end;//sx

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_32;

   end;

//done
xfd__inc64;
exit;


//render32 (440mps) ------------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
dindex  :=iauto( @sr32[sy][xreset] );
dstop96 :=iauto( @sr32[sy][xstop] );

xredo32:

//render pixel
pcolor32(dindex).b :=((cainv*pcolor32(dindex).b) shr 8) + c32.b;
pcolor32(dindex).g :=((cainv*pcolor32(dindex).g) shr 8) + c32.g;
pcolor32(dindex).r :=((cainv*pcolor32(dindex).r) shr 8) + c32.r;
//pcolor32(dindex).a :=((cainv*pcolor32(dindex).a ) shr 8) + c32.a;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor32));
   goto xredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo32;

   end;

//done
xfd__inc64;
exit;


//render96_32.layer (440mps) ---------------------------------------------------
yredo96_32L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr24[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_32L:

//render pixel
if (pcolor24(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0 :=((cainv*pcolor96(dindex).v0 ) shr 8) + c32.b ;//b "shr 8" is 104% faster than "div 256"
   pcolor96(dindex).v1 :=((cainv*pcolor96(dindex).v1 ) shr 8) + c32.g ;//g
   pcolor96(dindex).v2 :=((cainv*pcolor96(dindex).v2 ) shr 8) + c32.r ;//r
   //pcolor96(dindex).v3 :=((cainv*pcolor96(dindex).v3 ) shr 8) + c32.a ;//a

   end;

if (pcolor24(lindex).g=lv8) then
   begin

   pcolor96(dindex).v4 :=((cainv*pcolor96(dindex).v4 ) shr 8) + c32.b ;//b
   pcolor96(dindex).v5 :=((cainv*pcolor96(dindex).v5 ) shr 8) + c32.g ;//g
   pcolor96(dindex).v6 :=((cainv*pcolor96(dindex).v6 ) shr 8) + c32.r ;//r
   //pcolor96(dindex).v7 :=((cainv*pcolor96(dindex).v7 ) shr 8) + c32.a ;//a

   end;

if (pcolor24(lindex).r=lv8) then
   begin

   pcolor96(dindex).v8 :=((cainv*pcolor96(dindex).v8 ) shr 8) + c32.b ;//b
   pcolor96(dindex).v9 :=((cainv*pcolor96(dindex).v9 ) shr 8) + c32.g ;//g
   pcolor96(dindex).v10:=((cainv*pcolor96(dindex).v10) shr 8) + c32.r;//r
   //pcolor96(dindex).v11:=((cainv*pcolor96(dindex).v11) shr 8) + c32.a;//a

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   inc(lindex,sizeof(tcolor24));
   goto xredo96_32L;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do if (lr8[sy][sx]=lv8) then
begin

s32:=@sr32[sy][sx];
s32.r:=((cainv*s32.r) shr 8) + c32.r;
s32.g:=((cainv*s32.g) shr 8) + c32.g;
s32.b:=((cainv*s32.b) shr 8) + c32.b;
//s32.a:=((cainv*s32.a) shr 8) + c32.a;

end;//sx

for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then
begin

s32:=@sr32[sy][sx];
s32.r:=((cainv*s32.r) shr 8) + c32.r;
s32.g:=((cainv*s32.g) shr 8) + c32.g;
s32.b:=((cainv*s32.b) shr 8) + c32.b;
//s32.a:=((cainv*s32.a) shr 8) + c32.a;

end;//sx

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_32L;

   end;

//done
xfd__inc64;
exit;


//layer.render32 (400mps)-------------------------------------------------------
lyredo32:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr8 [sy][xreset] );
dindex  :=iauto( @sr32[sy][xreset] );
dstop96 :=iauto( @sr32[sy][xstop] );

lxredo32:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor32(dindex).b :=((cainv*pcolor32(dindex).b) shr 8) + c32.b;
   pcolor32(dindex).g :=((cainv*pcolor32(dindex).g) shr 8) + c32.g;
   pcolor32(dindex).r :=((cainv*pcolor32(dindex).r) shr 8) + c32.r;
   //pcolor32(dindex).a :=((cainv*pcolor32(dindex).a ) shr 8) + c32.a;

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor32));
   inc(lindex,sizeof(tcolor8));
   goto lxredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto lyredo32;

   end;

//done
xfd__inc64;

end;

procedure xfd__sketchArea;//06jan2026 - fills in area edge portions when round mode is one -> allows a base control to only fill a little of its surface area, allowing for the child control(s) to do the rest and save on render time - 05jan2026
begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.rimage.w<1) then exit;

//draw area
if (fd_focus.b.amode=fd_area_overlaps_clip) then
   begin

   //store
   fd__set(fd_storeArea);

   //trim area
   fd__set(fd_trimAreaToFitBuffer);

   //draw
   xfd__sketchArea350_layer_2432;

   //restore
   fd__set(fd_restoreArea);

   end
else xfd__sketchArea350_layer_2432;

end;

procedure xfd__sketchArea350_layer_2432;//05jan2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
     //mps values represent "virtual speed gains" over the equivalent "fillArea" request and thus do not represent true mps values
   y32,l32,y24,l24;
var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   lv8,sw,sh,sx,sy,sx1,sx2,sx3,sx4,sy1,sy2,sy3,sy4:longint32;
   c24:tcolor24;
   c32:tcolor32;
begin

//defaults
fd_drawProc32:=350;

//quick check
if not fd_focus.b.ok then exit;

//init
sw          :=fd_focus.b.aw;
sh          :=fd_focus.b.ah;

//.y ranges
if (sh<=ling_height) then
   begin

   sy1      :=fd_focus.b.ay1;
   sy2      :=fd_focus.b.ay2;

   sy3      :=sy1;
   sy4      :=sy1-1;

   end
else
   begin

   sy1      :=fd_focus.b.ay1;
   sy2      :=sy1 + ling_height - 1;

   sy4      :=fd_focus.b.ay2;
   sy3      :=sy4 - ling_height + 1;

   end;

//.x ranges
if (sw<=ling_width) then
   begin

   sx1      :=fd_focus.b.ax1;
   sx2      :=fd_focus.b.ax2;

   sx3      :=sx1;
   sx4      :=sx1-1;

   end
else
   begin

   sx1      :=fd_focus.b.ax1;
   sx2      :=sx1 + ling_width - 1;

   sx4      :=fd_focus.b.ax2;
   sx3      :=sx4 - ling_width + 1;

   end;

//.layer
lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );

//.bits
case fd_focus.b.bits of
24:begin

   xfd__inc32( sw * sh );
   sr24   :=pcolorrows24(fd_focus.b.rows);
   c24.r  :=fd_focus.color1.r;
   c24.g  :=fd_focus.color1.g;
   c24.b  :=fd_focus.color1.b;

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=352;
      goto l24;

      end;
   else
      begin

      fd_drawProc32:=351;
      goto y24;

      end;
   end;//case

   end;

32:begin

   xfd__inc32( sw * sh );
   sr32   :=pcolorrows32(fd_focus.b.rows);
   c32    :=fd_focus.color1;
   c32.a  :=255;

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=354;
      goto l32;

      end;
   else begin

      fd_drawProc32:=353;
      goto y32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 (59,000mps) ---------------------------------------------------------
y32:

//.top
for sy:=sy1 to sy2 do for sx:=sx1 to (sx1+sw-1) do sr32[sy][sx]:=c32;

//.bottom (optional)
if (sy4>=sy3) then for sy:=sy3 to sy4 do for sx:=sx1 to (sx1+sw-1) do sr32[sy][sx]:=c32;

//.sides
if (sy3>sy2) then
   begin

   //.left (optional)
   for sy:=(sy2+1) to (sy3-1) do for sx:=sx1 to sx2 do sr32[sy][sx]:=c32;

   //.right (optional)
   if (sx4>=sx3) then for sy:=(sy2+1) to (sy3-1) do for sx:=sx3 to sx4 do sr32[sy][sx]:=c32;

   end;

//done
xfd__inc64;
exit;


//layer.render32 (23,000mps)-------------------------------------------------------
l32:

//.top
for sy:=sy1 to sy2 do for sx:=sx1 to (sx1+sw-1) do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

//.bottom (optional)
if (sy4>=sy3) then for sy:=sy3 to sy4 do for sx:=sx1 to (sx1+sw-1) do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

//.sides
if (sy3>sy2) then
   begin

   //.left (optional)
   for sy:=(sy2+1) to (sy3-1) do for sx:=sx1 to sx2 do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

   //.right (optional)
   if (sx4>=sx3) then for sy:=(sy2+1) to (sy3-1) do for sx:=sx3 to sx4 do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

   end;

//done
xfd__inc64;
exit;


//layer.render24 (21,000mps)----------------------------------------------------
l24:

//.top
for sy:=sy1 to sy2 do for sx:=sx1 to (sx1+sw-1) do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

//.bottom (optional)
if (sy4>=sy3) then for sy:=sy3 to sy4 do for sx:=sx1 to (sx1+sw-1) do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

//.sides
if (sy3>sy2) then
   begin

   //.left (optional)
   for sy:=(sy2+1) to (sy3-1) do for sx:=sx1 to sx2 do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

   //.right (optional)
   if (sx4>=sx3) then for sy:=(sy2+1) to (sy3-1) do for sx:=sx3 to sx4 do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

   end;

//done
xfd__inc64;
exit;


//render24 (43,000mps) ------------------------------------------------------------
y24:

//.top
for sy:=sy1 to sy2 do for sx:=sx1 to (sx1+sw-1) do sr24[sy][sx]:=c24;

//.bottom (optional)
if (sy4>=sy3) then for sy:=sy3 to sy4 do for sx:=sx1 to (sx1+sw-1) do sr24[sy][sx]:=c24;

//.sides
if (sy3>sy2) then
   begin

   //.left (optional)
   for sy:=(sy2+1) to (sy3-1) do for sx:=sx1 to sx2 do sr24[sy][sx]:=c24;

   //.right (optional)
   if (sx4>=sx3) then for sy:=(sy2+1) to (sy3-1) do for sx:=sx3 to sx4 do sr24[sy][sx]:=c24;

   end;

//done
xfd__inc64;

end;

//?????????????????????????????????????
//?????????????????????????????????????
//?????????????????????????????????????
//?????????????????????????????????????
//?????????????????????????????????????
//?????????????????????????????????????

//?????????????????????????????????????//22222222222222222222222222222
procedure xfd__shadeArea;//07jan2026

   procedure xdraw;
   begin

   if      (fd_focus.power255=255) then xfd__shadeArea1300_layer_2432
   else if (fd_focus.power255>0)   then
      begin


      case fd_focus.b.bits of
      32:xfd__shadeArea1500_layer_power255_32;
      24:xfd__shadeArea1400_layer_power255_24;
      end;//case

      end;

   end;

begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.b.amode=fd_area_outside_clip) then exit;

//draw area
if (fd_focus.b.amode=fd_area_overlaps_clip) then
   begin

   //store
   fd__set(fd_storeArea);

   //trim area
   fd__set(fd_trimAreaToFitBuffer);

   //draw
   xdraw;

   //restore
   fd__set(fd_restoreArea);

   end
else xdraw;

end;

procedure xfd__shadeArea1300_layer_2432;//07jan2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo24,xredo24,yredo32,xredo32,lyredo24,lxredo24,lyredo32,lxredo32,
   yredo96_N,xredo96_N,
   yredo96_32L,xredo96_32L,
   yredo96_24L,xredo96_24L;
var
    lr8:pcolorrows8;
   lr24:pcolorrows24;
   lr32:pcolorrows32;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   sr96:pcolorrows96;
   yswitch,ystart,ysize,ysize1,ysize2,xstop,ystop,xreset,sx,sy:longint32;
   yratio01:extended;
   c24:tcolor24;
   c1,c2,c3,c4,c32:tcolor32;
   c96:tcolor96;
   lv8,lx1,lx2,rx1,rx2,xreset96,xstop96:longint32;
   dstop96,lindex,dindex:iauto;

   function xcan96:boolean;//supports 24 and 32bit in layer and non-layer modes
   begin

   result:=xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96);

   if result then
      begin

      sr96   :=pcolorrows96(fd_focus.b.rows);

      end;

   end;

   procedure scol;
   begin

   case (sy<=yswitch) of
   true:c32  :=c32__splice( (sy-ystart )/ysize1 ,c1 ,c2 );
   else c32  :=c32__splice( (sy-yswitch)/ysize2 ,c3 ,c4 );
   end;//case

   c32.a  :=255;

   c24.r  :=c32.r;
   c24.g  :=c32.g;
   c24.b  :=c32.b;

   end;

   procedure scol96;
   begin

   case (sy<=yswitch) of
   true:c32  :=c32__splice( (sy-ystart )/ysize1 ,c1 ,c2 );
   else c32  :=c32__splice( (sy-yswitch)/ysize2 ,c3 ,c4 );
   end;//case

   c32.a  :=255;

   c24.r  :=c32.r;
   c24.g  :=c32.g;
   c24.b  :=c32.b;

   case fd_focus.b.bits of

   24:begin

      c96.v0  :=c24.b;
      c96.v1  :=c24.g;
      c96.v2  :=c24.r;

      c96.v3  :=c24.b;
      c96.v4  :=c24.g;
      c96.v5  :=c24.r;

      c96.v6  :=c24.b;
      c96.v7  :=c24.g;
      c96.v8  :=c24.r;

      c96.v9  :=c24.b;
      c96.v10 :=c24.g;
      c96.v11 :=c24.r;

      end;

   32:begin

      c96.v0  :=c32.b;
      c96.v1  :=c32.g;
      c96.v2  :=c32.r;
      c96.v3  :=c32.a;

      c96.v4  :=c32.b;
      c96.v5  :=c32.g;
      c96.v6  :=c32.r;
      c96.v7  :=c32.a;

      c96.v8  :=c32.b;
      c96.v9  :=c32.g;
      c96.v10 :=c32.r;
      c96.v11 :=c32.a;

      end;

   end;//case

   end;

begin

//defaults
fd_drawProc32:=1300;

//quick check
if not fd_focus.b.ok then exit;

//init
xreset      :=fd_focus.b.ax1;
xstop       :=fd_focus.b.ax2;
sy          :=fd_focus.b.ay1;
ystop       :=fd_focus.b.ay2;
ystart      :=fd_focus.b.ay1;

yratio01    :=fd_focus.splice100/100;
ysize       :=frcmin32(fd_focus.b.ay2-fd_focus.b.ay1+1,1);

if (yratio01<0)  then yratio01:=0 else if (yratio01>1) then yratio01:=1;
if fd_focus.flip then yratio01:=1-yratio01;

ysize1      :=trunc(ysize*yratio01);
ysize2      :=ysize-ysize1;
yswitch     :=ystart + ysize1 - 1;

if (ysize1<1) then ysize1:=1;
if (ysize2<1) then ysize2:=1;

lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );

if fd_focus.flip then
   begin

   c1          :=fd_focus.color4;
   c2          :=fd_focus.color3;
   c3          :=fd_focus.color2;
   c4          :=fd_focus.color1;

   end
else
   begin

   c1          :=fd_focus.color1;
   c2          :=fd_focus.color2;
   c3          :=fd_focus.color3;
   c4          :=fd_focus.color4;

   end;

case fd_focus.b.bits of
24:begin

   lr32   :=pcolorrows32(lr8);
   sr24   :=pcolorrows24(fd_focus.b.rows);

   case xcan96 of
   true:begin

      case (fd_focus.lv8>=0) of
      true:begin

         fd_drawProc32:=1397;
         goto yredo96_24L;

         end;
      else
         begin

         fd_drawProc32:=1396;
         goto yredo96_N;

         end;
      end;//case

      end;
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         fd_drawProc32:=1325;
         goto lyredo24;

         end;
      else
         begin

         fd_drawProc32:=1324;
         goto yredo24;

         end;
      end;//case

      end;

   end;//case

   end;

32:begin

   lr24   :=pcolorrows24(lr8);
   sr32   :=pcolorrows32(fd_focus.b.rows);

   case xcan96 of
   true:begin

      case (fd_focus.lv8>=0) of
      true:begin

         fd_drawProc32:=1398;
         goto yredo96_32L;

         end;
      else begin

         fd_drawProc32:=1396;
         goto yredo96_N;

         end;
      end;//case

      end
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         fd_drawProc32:=1333;
         goto lyredo32;

         end;
      else begin

         fd_drawProc32:=1332;
         goto yredo32;

         end;
      end;//case

      end;
   end;//case

   end;
else  exit;
end;//case


//render96_N (32bit=1350mps, 24bit=1720mps) ------------------------------------
yredo96_N:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset96;
scol96;

xredo96_N:

//render pixel
sr96[sy][sx]:=c96;

//inc x
if (sx<>xstop96) then
   begin

   inc(sx,1);
   goto xredo96_N;

   end;

//row "begin" and "end" gaps
case fd_focus.b.bits of
32:begin

   for sx:=lx1 to lx2 do sr32[sy][sx]:=c32;
   for sx:=rx1 to rx2 do sr32[sy][sx]:=c32;

   end;
24:begin

   for sx:=lx1 to lx2 do sr24[sy][sx]:=c24;
   for sx:=rx1 to rx2 do sr24[sy][sx]:=c24;

   end;
end;//case

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_N;

   end;

//done
xfd__inc64;
exit;


//render96_32L (720mps) --------------------------------------------------------
yredo96_32L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr24[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );
scol96;

xredo96_32L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0:=c32.b;//b
   pcolor96(dindex).v1:=c32.g;//g
   pcolor96(dindex).v2:=c32.r;//r
   //pcolor96(dindex).v3:=c32.a;//a

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   pcolor96(dindex).v4:=c32.b;//b
   pcolor96(dindex).v5:=c32.g;//g
   pcolor96(dindex).v6:=c32.r;//r
   //pcolor96(dindex).v7:=c32.a;//a

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   pcolor96(dindex).v8:=c32.b;//b
   pcolor96(dindex).v9:=c32.g;//g
   pcolor96(dindex).v10:=c32.r;//r
   //pcolor96(dindex).v11:=c32.a;//a

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   inc(lindex,sizeof(tcolor24));
   goto xredo96_32L;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;
for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_32L;

   end;

//done
xfd__inc64;
exit;


//render96_24L (700mps) --------------------------------------------------------
yredo96_24L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr32[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );
scol96;

xredo96_24L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0:=c24.b;//b
   pcolor96(dindex).v1:=c24.g;//g
   pcolor96(dindex).v2:=c24.r;//r

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   pcolor96(dindex).v3:=c24.b;//b
   pcolor96(dindex).v4:=c24.g;//g
   pcolor96(dindex).v5:=c24.r;//r

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   pcolor96(dindex).v6:=c24.b;//b
   pcolor96(dindex).v7:=c24.g;//g
   pcolor96(dindex).v8:=c24.r;//r

   end;

if (pcolor32(lindex).a=lv8) then
   begin

   pcolor96(dindex).v9 :=c24.b;//b
   pcolor96(dindex).v10:=c24.g;//g
   pcolor96(dindex).v11:=c24.r;//r

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   inc(lindex,sizeof(tcolor32));
   goto xredo96_24L;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;
for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_24L;

   end;

//done
xfd__inc64;
exit;


//render32 (800mps) -----------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;
scol;

xredo32:

//render pixel
sr32[sy][sx]:=c32;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   goto xredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo32;

   end;

//done
xfd__inc64;
exit;


//layer.render32 (490mps)-------------------------------------------------------
lyredo32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;
scol;

lxredo32:

//render pixel
if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   goto lxredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto lyredo32;

   end;

//done
xfd__inc64;
exit;


//layer.render24 (410mps)-------------------------------------------------------
lyredo24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;
scol;

lxredo24:

//render pixel
if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   goto lxredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto lyredo24;

   end;

//done
xfd__inc64;
exit;


//render24 (620mps) ------------------------------------------------------------
yredo24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;
scol;

xredo24:

//render pixel
sr24[sy][sx]:=c24;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   goto xredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo24;

   end;

//done
xfd__inc64;

end;

procedure xfd__shadeArea1400_layer_power255_24;//07jan2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo24,xredo24,lyredo24,lxredo24,yredo96_24,xredo96_24,yredo96_24L,xredo96_24L;
var
    lr8:pcolorrows8;
   lr32:pcolorrows32;
   sr24:pcolorrows24;
   sr96:pcolorrows96;
   yswitch,ystart,ysize,ysize1,ysize2,xstop,ystop,xreset,sx,sy:longint32;
   yratio01:extended;
   c1,c2,c3,c4,c24:tcolor24;
   s24:pcolor24;
   lv8,ca,cainv,lx1,lx2,rx1,rx2,xreset96,xstop96:longint32;
   dstop96,lindex,dindex:iauto;

   function xcan96:boolean;
   begin

   result:=xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96);

   if result then
      begin

      sr96   :=pcolorrows96(fd_focus.b.rows);

      end;

   end;

   procedure scol;
   begin

   case (sy<=yswitch) of
   true:c24  :=c24__splice( (sy-ystart )/ysize1 ,c1 ,c2 );
   else c24  :=c24__splice( (sy-yswitch)/ysize2 ,c3 ,c4 );
   end;//case

   end;

begin

//defaults
fd_drawProc32:=1400;

//quick check
if not fd_focus.b.ok then exit;

//init
xreset      :=fd_focus.b.ax1;
xstop       :=fd_focus.b.ax2;
sy          :=fd_focus.b.ay1;
ystop       :=fd_focus.b.ay2;
ystart      :=fd_focus.b.ay1;

yratio01    :=fd_focus.splice100/100;
ysize       :=frcmin32(fd_focus.b.ay2-fd_focus.b.ay1+1,1);

if (yratio01<0)  then yratio01:=0 else if (yratio01>1) then yratio01:=1;
if fd_focus.flip then yratio01:=1-yratio01;

ysize1      :=trunc(ysize*yratio01);
ysize2      :=ysize-ysize1;
yswitch     :=ystart + ysize1 - 1;

if (ysize1<1) then ysize1:=1;
if (ysize2<1) then ysize2:=1;

lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );
ca          :=fd_focus.power255;
cainv       :=255-ca;
lr32        :=pcolorrows32( fd_focus.lr8 );
sr24        :=pcolorrows24( fd_focus.b.rows );

if fd_focus.flip then
   begin

   c1.r        :=fd_focus.color4.r;
   c1.g        :=fd_focus.color4.g;
   c1.b        :=fd_focus.color4.b;

   c2.r        :=fd_focus.color3.r;
   c2.g        :=fd_focus.color3.g;
   c2.b        :=fd_focus.color3.b;

   c3.r        :=fd_focus.color2.r;
   c3.g        :=fd_focus.color2.g;
   c3.b        :=fd_focus.color2.b;

   c4.r        :=fd_focus.color1.r;
   c4.g        :=fd_focus.color1.g;
   c4.b        :=fd_focus.color1.b;

   end
else
   begin

   c1.r        :=fd_focus.color1.r;
   c1.g        :=fd_focus.color1.g;
   c1.b        :=fd_focus.color1.b;

   c2.r        :=fd_focus.color2.r;
   c2.g        :=fd_focus.color2.g;
   c2.b        :=fd_focus.color2.b;

   c3.r        :=fd_focus.color3.r;
   c3.g        :=fd_focus.color3.g;
   c3.b        :=fd_focus.color3.b;

   c4.r        :=fd_focus.color4.r;
   c4.g        :=fd_focus.color4.g;
   c4.b        :=fd_focus.color4.b;

   end;

//.pre-compute
c1.r           :=(ca*c1.r) shr 8;
c1.g           :=(ca*c1.g) shr 8;
c1.b           :=(ca*c1.b) shr 8;

c2.r           :=(ca*c2.r) shr 8;
c2.g           :=(ca*c2.g) shr 8;
c2.b           :=(ca*c2.b) shr 8;

c3.r           :=(ca*c3.r) shr 8;
c3.g           :=(ca*c3.g) shr 8;
c3.b           :=(ca*c3.b) shr 8;

c4.r           :=(ca*c4.r) shr 8;
c4.g           :=(ca*c4.g) shr 8;
c4.b           :=(ca*c4.b) shr 8;

case xcan96 of

true:begin

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=1498;
      goto yredo96_24L;

      end;
   else begin

      fd_drawProc32:=1497;
      goto yredo96_24;

      end;
   end;//case

   end;

else begin

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=1425;
      goto lyredo24;

      end;
   else begin

      fd_drawProc32:=1424;
      goto yredo24;

      end;
   end;//case

   end;

end;//case


//render96_24.layer (430mps) ---------------------------------------------------
yredo96_24L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr32[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );
scol;

xredo96_24L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0 :=((cainv*pcolor96(dindex).v0 ) shr 8) + c24.b ;//b "shr 8" is 104% faster than "div 256"
   pcolor96(dindex).v1 :=((cainv*pcolor96(dindex).v1 ) shr 8) + c24.g ;//g
   pcolor96(dindex).v2 :=((cainv*pcolor96(dindex).v2 ) shr 8) + c24.r ;//r

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   pcolor96(dindex).v3 :=((cainv*pcolor96(dindex).v3 ) shr 8) + c24.b ;//b
   pcolor96(dindex).v4 :=((cainv*pcolor96(dindex).v4 ) shr 8) + c24.g ;//g
   pcolor96(dindex).v5 :=((cainv*pcolor96(dindex).v5 ) shr 8) + c24.r ;//r

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   pcolor96(dindex).v6 :=((cainv*pcolor96(dindex).v6 ) shr 8) + c24.b ;//b
   pcolor96(dindex).v7 :=((cainv*pcolor96(dindex).v7 ) shr 8) + c24.g ;//g
   pcolor96(dindex).v8 :=((cainv*pcolor96(dindex).v8 ) shr 8) + c24.r;//r

   end;

if (pcolor32(lindex).a=lv8) then
   begin

   pcolor96(dindex).v9 :=((cainv*pcolor96(dindex).v9 ) shr 8) + c24.b ;//b
   pcolor96(dindex).v10:=((cainv*pcolor96(dindex).v10) shr 8) + c24.g ;//g
   pcolor96(dindex).v11:=((cainv*pcolor96(dindex).v11) shr 8) + c24.r;//r

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   inc(lindex,sizeof(tcolor32));
   goto xredo96_24L;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do if (lr8[sy][sx]=lv8) then
begin

s24:=@sr24[sy][sx];
s24.r:=((cainv*s24.r) shr 8) + c24.r;
s24.g:=((cainv*s24.g) shr 8) + c24.g;
s24.b:=((cainv*s24.b) shr 8) + c24.b;

end;//sx

for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then
begin

s24:=@sr24[sy][sx];
s24.r:=((cainv*s24.r) shr 8) + c24.r;
s24.g:=((cainv*s24.g) shr 8) + c24.g;
s24.b:=((cainv*s24.b) shr 8) + c24.b;

end;//sx

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_24L;

   end;

//done
xfd__inc64;
exit;


//render96_24 (500mps) ---------------------------------------------------------
yredo96_24:

xfd__inc32(fd_focus.b.aw);
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );
scol;

xredo96_24:

//render pixel
pcolor96(dindex).v0 :=((cainv*pcolor96(dindex).v0 ) shr 8) + c24.b ;//b "shr 8" is 104% faster than "div 256"
pcolor96(dindex).v1 :=((cainv*pcolor96(dindex).v1 ) shr 8) + c24.g ;//g
pcolor96(dindex).v2 :=((cainv*pcolor96(dindex).v2 ) shr 8) + c24.r ;//r
pcolor96(dindex).v3 :=((cainv*pcolor96(dindex).v3 ) shr 8) + c24.b ;//b
pcolor96(dindex).v4 :=((cainv*pcolor96(dindex).v4 ) shr 8) + c24.g ;//g
pcolor96(dindex).v5 :=((cainv*pcolor96(dindex).v5 ) shr 8) + c24.r ;//r
pcolor96(dindex).v6 :=((cainv*pcolor96(dindex).v6 ) shr 8) + c24.b ;//b
pcolor96(dindex).v7 :=((cainv*pcolor96(dindex).v7 ) shr 8) + c24.g ;//g
pcolor96(dindex).v8 :=((cainv*pcolor96(dindex).v8 ) shr 8) + c24.r ;//r
pcolor96(dindex).v9 :=((cainv*pcolor96(dindex).v9 ) shr 8) + c24.b ;//b
pcolor96(dindex).v10:=((cainv*pcolor96(dindex).v10) shr 8) + c24.g;//g
pcolor96(dindex).v11:=((cainv*pcolor96(dindex).v11) shr 8) + c24.r;//r

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   goto xredo96_24;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do
begin

s24:=@sr24[sy][sx];
s24.r:=((cainv*s24.r) shr 8) + c24.r;
s24.g:=((cainv*s24.g) shr 8) + c24.g;
s24.b:=((cainv*s24.b) shr 8) + c24.b;

end;//sx

for sx:=rx1 to rx2 do
begin

s24:=@sr24[sy][sx];
s24.r:=((cainv*s24.r) shr 8) + c24.r;
s24.g:=((cainv*s24.g) shr 8) + c24.g;
s24.b:=((cainv*s24.b) shr 8) + c24.b;

end;//sx

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_24;

   end;

//done
xfd__inc64;
exit;


//render24 (430mps) ------------------------------------------------------------
yredo24:

xfd__inc32(fd_focus.b.aw);
dindex  :=iauto( @sr24[sy][xreset] );
dstop96 :=iauto( @sr24[sy][xstop] );
scol;

xredo24:

//render pixel
pcolor24(dindex).r :=((cainv*pcolor24(dindex).r) shr 8) + c24.r;
pcolor24(dindex).g :=((cainv*pcolor24(dindex).g) shr 8) + c24.g;
pcolor24(dindex).b :=((cainv*pcolor24(dindex).b) shr 8) + c24.b;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor24));
   goto xredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo24;

   end;

//done
xfd__inc64;
exit;


//layer.render24 (370mps)-------------------------------------------------------
lyredo24:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr8 [sy][xreset] );
dindex  :=iauto( @sr24[sy][xreset] );
dstop96 :=iauto( @sr24[sy][xstop] );
scol;

lxredo24:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor24(dindex).r :=((cainv*pcolor24(dindex).r) shr 8) + c24.r;
   pcolor24(dindex).g :=((cainv*pcolor24(dindex).g) shr 8) + c24.g;
   pcolor24(dindex).b :=((cainv*pcolor24(dindex).b) shr 8) + c24.b;

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor24));
   inc(lindex,sizeof(tcolor8));
   goto lxredo24;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto lyredo24;

   end;

//done
xfd__inc64;

end;

procedure xfd__shadeArea1500_layer_power255_32;//07jan2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo32,xredo32,lyredo32,lxredo32,yredo96_32,xredo96_32,yredo96_32L,xredo96_32L;
var
    lr8:pcolorrows8;
   lr24:pcolorrows24;
   sr32:pcolorrows32;
   sr96:pcolorrows96;
   yswitch,ystart,ysize,ysize1,ysize2,xstop,ystop,xreset,sx,sy:longint32;
   yratio01:extended;
   c1,c2,c3,c4,c32:tcolor32;
   s32:pcolor32;
   lv8,ca,cainv,lx1,lx2,rx1,rx2,xreset96,xstop96:longint32;
   dstop96,lindex,dindex:iauto;

   function xcan96:boolean;
   begin

   result:=xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96);

   if result then
      begin

      sr96   :=pcolorrows96(fd_focus.b.rows);

      end;

   end;

   procedure scol;
   begin

   case (sy<=yswitch) of
   true:c32  :=c32__splice( (sy-ystart )/ysize1 ,c1 ,c2 );
   else c32  :=c32__splice( (sy-yswitch)/ysize2 ,c3 ,c4 );
   end;//case

   end;

begin

//defaults
fd_drawProc32:=1500;

//quick check
if not fd_focus.b.ok then exit;

//init
xreset      :=fd_focus.b.ax1;
xstop       :=fd_focus.b.ax2;
sy          :=fd_focus.b.ay1;
ystop       :=fd_focus.b.ay2;
ystart      :=fd_focus.b.ay1;

yratio01    :=fd_focus.splice100/100;
ysize       :=frcmin32(fd_focus.b.ay2-fd_focus.b.ay1+1,1);

if (yratio01<0)  then yratio01:=0 else if (yratio01>1) then yratio01:=1;
if fd_focus.flip then yratio01:=1-yratio01;

ysize1      :=trunc(ysize*yratio01);
ysize2      :=ysize-ysize1;
yswitch     :=ystart + ysize1 - 1;

if (ysize1<1) then ysize1:=1;
if (ysize2<1) then ysize2:=1;

lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );
ca          :=fd_focus.power255;
cainv       :=255-ca;
lr24        :=pcolorrows24( fd_focus.lr8 );
sr32        :=pcolorrows32( fd_focus.b.rows );

if fd_focus.flip then
   begin

   c1          :=fd_focus.color4;
   c2          :=fd_focus.color3;
   c3          :=fd_focus.color2;
   c4          :=fd_focus.color1;

   end
else
   begin

   c1          :=fd_focus.color1;
   c2          :=fd_focus.color2;
   c3          :=fd_focus.color3;
   c4          :=fd_focus.color4;

   end;

//.pre-compute
c1.r           :=(ca*c1.r) shr 8;
c1.g           :=(ca*c1.g) shr 8;
c1.b           :=(ca*c1.b) shr 8;

c2.r           :=(ca*c2.r) shr 8;
c2.g           :=(ca*c2.g) shr 8;
c2.b           :=(ca*c2.b) shr 8;

c3.r           :=(ca*c3.r) shr 8;
c3.g           :=(ca*c3.g) shr 8;
c3.b           :=(ca*c3.b) shr 8;

c4.r           :=(ca*c4.r) shr 8;
c4.g           :=(ca*c4.g) shr 8;
c4.b           :=(ca*c4.b) shr 8;

case xcan96 of
true:begin

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=1597;
      goto yredo96_32L;

      end;
   else begin

      fd_drawProc32:=1596;
      goto yredo96_32;

      end;
   end;//case

   end
else begin

   case (fd_focus.lv8>=0) of
   true:begin

      fd_drawProc32:=1533;
      goto lyredo32;

      end;
   else
      begin

      fd_drawProc32:=1532;
      goto yredo32;

      end;
   end;//case

   end;
end;//case


//render96_32 (480mps) ---------------------------------------------------------
yredo96_32:

xfd__inc32(fd_focus.b.aw);
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );
scol;

xredo96_32:

//render pixel
pcolor96(dindex).v0 :=((cainv*pcolor96(dindex).v0) shr 8) + c32.b;
pcolor96(dindex).v1 :=((cainv*pcolor96(dindex).v1) shr 8) + c32.g;
pcolor96(dindex).v2 :=((cainv*pcolor96(dindex).v2) shr 8) + c32.r;

pcolor96(dindex).v4 :=((cainv*pcolor96(dindex).v4) shr 8) + c32.b;
pcolor96(dindex).v5 :=((cainv*pcolor96(dindex).v5) shr 8) + c32.g;
pcolor96(dindex).v6 :=((cainv*pcolor96(dindex).v6) shr 8) + c32.r;

pcolor96(dindex).v8 :=((cainv*pcolor96(dindex).v8) shr 8) + c32.b;
pcolor96(dindex).v9 :=((cainv*pcolor96(dindex).v9) shr 8) + c32.g;
pcolor96(dindex).v10:=((cainv*pcolor96(dindex).v10) shr 8) + c32.r;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   goto xredo96_32;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do
begin

s32:=@sr32[sy][sx];
s32.r:=((cainv*s32.r) shr 8) + c32.r;
s32.g:=((cainv*s32.g) shr 8) + c32.g;
s32.b:=((cainv*s32.b) shr 8) + c32.b;

end;//sx

for sx:=rx1 to rx2 do
begin

s32:=@sr32[sy][sx];
s32.r:=((cainv*s32.r) shr 8) + c32.r;
s32.g:=((cainv*s32.g) shr 8) + c32.g;
s32.b:=((cainv*s32.b) shr 8) + c32.b;

end;//sx

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_32;

   end;

//done
xfd__inc64;
exit;


//render32 (420mps) ------------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
dindex  :=iauto( @sr32[sy][xreset] );
dstop96 :=iauto( @sr32[sy][xstop] );
scol;

xredo32:

//render pixel
pcolor32(dindex).b :=((cainv*pcolor32(dindex).b) shr 8) + c32.b;
pcolor32(dindex).g :=((cainv*pcolor32(dindex).g) shr 8) + c32.g;
pcolor32(dindex).r :=((cainv*pcolor32(dindex).r) shr 8) + c32.r;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor32));
   goto xredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo32;

   end;

//done
xfd__inc64;
exit;


//render96_32.layer (400mps) ---------------------------------------------------
yredo96_32L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr24[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );
scol;

xredo96_32L:

//render pixel
if (pcolor24(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0 :=((cainv*pcolor96(dindex).v0) shr 8) + c32.b;
   pcolor96(dindex).v1 :=((cainv*pcolor96(dindex).v1) shr 8) + c32.g;
   pcolor96(dindex).v2 :=((cainv*pcolor96(dindex).v2) shr 8) + c32.r;

   end;

if (pcolor24(lindex).g=lv8) then
   begin

   pcolor96(dindex).v4 :=((cainv*pcolor96(dindex).v4) shr 8) + c32.b;
   pcolor96(dindex).v5 :=((cainv*pcolor96(dindex).v5) shr 8) + c32.g;
   pcolor96(dindex).v6 :=((cainv*pcolor96(dindex).v6) shr 8) + c32.r;

   end;

if (pcolor24(lindex).r=lv8) then
   begin

   pcolor96(dindex).v8 :=((cainv*pcolor96(dindex).v8) shr 8) + c32.b;
   pcolor96(dindex).v9 :=((cainv*pcolor96(dindex).v9) shr 8) + c32.g;
   pcolor96(dindex).v10:=((cainv*pcolor96(dindex).v10) shr 8) + c32.r;

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor96));
   inc(lindex,sizeof(tcolor24));
   goto xredo96_32L;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do if (lr8[sy][sx]=lv8) then
begin

s32:=@sr32[sy][sx];
s32.r:=((cainv*s32.r) shr 8) + c32.r;
s32.g:=((cainv*s32.g) shr 8) + c32.g;
s32.b:=((cainv*s32.b) shr 8) + c32.b;

end;//sx

for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then
begin

s32:=@sr32[sy][sx];
s32.r:=((cainv*s32.r) shr 8) + c32.r;
s32.g:=((cainv*s32.g) shr 8) + c32.g;
s32.b:=((cainv*s32.b) shr 8) + c32.b;

end;//sx

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_32L;

   end;

//done
xfd__inc64;
exit;


//layer.render32 (340mps) ------------------------------------------------------
lyredo32:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr8 [sy][xreset] );
dindex  :=iauto( @sr32[sy][xreset] );
dstop96 :=iauto( @sr32[sy][xstop] );
scol;

lxredo32:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor32(dindex).b :=((cainv*pcolor32(dindex).b) shr 8) + c32.b;
   pcolor32(dindex).g :=((cainv*pcolor32(dindex).g) shr 8) + c32.g;
   pcolor32(dindex).r :=((cainv*pcolor32(dindex).r) shr 8) + c32.r;

   end;

//inc x
if (dindex<>dstop96) then
   begin

   inc(dindex,sizeof(tcolor32));
   inc(lindex,sizeof(tcolor8));
   goto lxredo32;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto lyredo32;

   end;

//done
xfd__inc64;

end;

//?????????????????????????????????????

procedure xfd__fillSmallArea;//07jan2026
begin

if fd_focus.b.ok and (fd_focus.b.amode<>fd_area_outside_clip) then
   begin

   case (fd_focus.power255=255) of
   true:xfd__fillSmallArea1600_layer_2432;
   else xfd__fillSmallArea1700_layer_power255_2432;
   end;//case

   end;

end;

procedure xfd__fillSmallArea1600_layer_2432;//07jan2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo24,xredo24,yredo32,xredo32,lyredo24,lxredo24,lyredo32,lxredo32;
var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   sx,sy,sx1,sx2,sy1,sy2:longint32;
   c24:tcolor24;
   c32:tcolor32;
   lv8:longint32;
begin

//defaults
fd_drawProc32:=1600;

//init
if (fd_focus.b.ax1<fd_focus.b.cx1) then sx1:=fd_focus.b.cx1
else                                    sx1:=fd_focus.b.ax1;

if (fd_focus.b.ax2>fd_focus.b.cx2) then sx2:=fd_focus.b.cx2
else                                    sx2:=fd_focus.b.ax2;

if (fd_focus.b.ay1<fd_focus.b.cy1) then sy1:=fd_focus.b.cy1
else                                    sy1:=fd_focus.b.ay1;

if (fd_focus.b.ay2>fd_focus.b.cy2) then sy2:=fd_focus.b.cy2
else                                    sy2:=fd_focus.b.ay2;

case fd_focus.b.bits of
24:begin

   sr24   :=pcolorrows24(fd_focus.b.rows);
   c24.r  :=fd_focus.color1.r;
   c24.g  :=fd_focus.color1.g;
   c24.b  :=fd_focus.color1.b;

   case (fd_focus.lv8>=0) of
   true:begin

      lv8          :=fd_focus.lv8;
      lr8          :=pcolorrows8( fd_focus.lr8 );
      fd_drawProc32:=1625;
      goto lyredo24;

      end;
   else begin

      fd_drawProc32:=1624;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32   :=pcolorrows32(fd_focus.b.rows);
   c32    :=fd_focus.color1;
   c32.a  :=255;

   case (fd_focus.lv8>=0) of
   true:begin

      lv8          :=fd_focus.lv8;
      lr8          :=pcolorrows8( fd_focus.lr8 );
      fd_drawProc32:=1633;
      goto lyredo32;

      end;
   else begin

      fd_drawProc32:=1632;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 (380mps at 5w x 5h) -------------------------------------------------
yredo32:

//render pixel
for sy:=sy1 to sy2 do for sx:=sx1 to sx2 do sr32[sy][sx]:=c32;

//done
xfd__inc32( (sy2-sy1+1) * (sx2-sx1+1) );
xfd__inc64;
exit;


//layer.render32 (180mps at 5w x 5h) -------------------------------------------
lyredo32:

//render pixel
for sy:=sy1 to sy2 do for sx:=sx1 to sx2 do if (lr8[sy][sx]=lv8) then sr32[sy][sx]:=c32;

//done
xfd__inc32( (sy2-sy1+1) * (sx2-sx1+1) );
xfd__inc64;
exit;


//layer.render24 (190mps at 5w x 5h) -------------------------------------------
lyredo24:

//render pixel
for sy:=sy1 to sy2 do for sx:=sx1 to sx2 do if (lr8[sy][sx]=lv8) then sr24[sy][sx]:=c24;

//done
xfd__inc32( (sy2-sy1+1) * (sx2-sx1+1) );
xfd__inc64;
exit;


//render24 (310mps at 5w x 5h) -------------------------------------------------
yredo24:

//render pixel
for sy:=sy1 to sy2 do for sx:=sx1 to sx2 do sr24[sy][sx]:=c24;

//done
xfd__inc32( (sy2-sy1+1) * (sx2-sx1+1) );
xfd__inc64;

end;

procedure xfd__fillSmallArea1700_layer_power255_2432;//07jan2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo24,xredo24,yredo32,xredo32,lyredo24,lxredo24,lyredo32,lxredo32;
var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   ca,cainv,sx,sy,sx1,sx2,sy1,sy2:longint32;
   c24:tcolor24;
   c32:tcolor32;
   s24:pcolor24;
   s32:pcolor32;
   lv8:longint32;
begin

//defaults
fd_drawProc32:=1600;

//init
if (fd_focus.b.ax1<fd_focus.b.cx1) then sx1:=fd_focus.b.cx1
else                                    sx1:=fd_focus.b.ax1;

if (fd_focus.b.ax2>fd_focus.b.cx2) then sx2:=fd_focus.b.cx2
else                                    sx2:=fd_focus.b.ax2;

if (fd_focus.b.ay1<fd_focus.b.cy1) then sy1:=fd_focus.b.cy1
else                                    sy1:=fd_focus.b.ay1;

if (fd_focus.b.ay2>fd_focus.b.cy2) then sy2:=fd_focus.b.cy2
else                                    sy2:=fd_focus.b.ay2;

ca          :=fd_focus.power255;
cainv       :=255-ca;

case fd_focus.b.bits of
24:begin

   sr24   :=pcolorrows24(fd_focus.b.rows);

   //.pre-compute
   c24.r  :=(ca*fd_focus.color1.r) shr 8;
   c24.g  :=(ca*fd_focus.color1.g) shr 8;
   c24.b  :=(ca*fd_focus.color1.b) shr 8;

   case (fd_focus.lv8>=0) of
   true:begin

      lv8          :=fd_focus.lv8;
      lr8          :=pcolorrows8( fd_focus.lr8 );
      fd_drawProc32:=1625;
      goto lyredo24;

      end;
   else begin

      fd_drawProc32:=1624;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32   :=pcolorrows32(fd_focus.b.rows);

   //.pre-compute
   c32.r  :=(ca*fd_focus.color1.r) shr 8;
   c32.g  :=(ca*fd_focus.color1.g) shr 8;
   c32.b  :=(ca*fd_focus.color1.b) shr 8;
   c32.a  :=255;

   case (fd_focus.lv8>=0) of
   true:begin

      lv8          :=fd_focus.lv8;
      lr8          :=pcolorrows8( fd_focus.lr8 );
      fd_drawProc32:=1633;
      goto lyredo32;

      end;
   else begin

      fd_drawProc32:=1632;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 (210mps at 5w x 5h) -------------------------------------------------
yredo32:

//render pixel
for sy:=sy1 to sy2 do for sx:=sx1 to sx2 do
   begin

   sr32[sy][sx].r:=((cainv*sr32[sy][sx].r) shr 8) + c32.r;
   sr32[sy][sx].g:=((cainv*sr32[sy][sx].g) shr 8) + c32.g;
   sr32[sy][sx].b:=((cainv*sr32[sy][sx].b) shr 8) + c32.b;

   end;

//done
xfd__inc32( (sy2-sy1+1) * (sx2-sx1+1) );
xfd__inc64;
exit;


//layer.render32 (170mps at 5w x 5h) -------------------------------------------
lyredo32:

//render pixel
for sy:=sy1 to sy2 do for sx:=sx1 to sx2 do if (lr8[sy][sx]=lv8) then
   begin

   sr32[sy][sx].r:=((cainv*sr32[sy][sx].r) shr 8) + c32.r;
   sr32[sy][sx].g:=((cainv*sr32[sy][sx].g) shr 8) + c32.g;
   sr32[sy][sx].b:=((cainv*sr32[sy][sx].b) shr 8) + c32.b;

   end;

//done
xfd__inc32( (sy2-sy1+1) * (sx2-sx1+1) );
xfd__inc64;
exit;


//layer.render24 (55mps at 5w x 5h) --------------------------------------------
lyredo24:

//render pixel
for sy:=sy1 to sy2 do for sx:=sx1 to sx2 do if (lr8[sy][sx]=lv8) then
   begin

   sr24[sy][sx].r:=((cainv*sr24[sy][sx].r) shr 8) + c24.r;
   sr24[sy][sx].g:=((cainv*sr24[sy][sx].g) shr 8) + c24.g;
   sr24[sy][sx].b:=((cainv*sr24[sy][sx].b) shr 8) + c24.b;

   end;

//done
xfd__inc32( (sy2-sy1+1) * (sx2-sx1+1) );
xfd__inc64;
exit;


//render24 (75mps at 5w x 5h) --------------------------------------------------
yredo24:

//render pixel
for sy:=sy1 to sy2 do for sx:=sx1 to sx2 do
   begin

   sr24[sy][sx].r:=((cainv*sr24[sy][sx].r) shr 8) + c24.r;
   sr24[sy][sx].g:=((cainv*sr24[sy][sx].g) shr 8) + c24.g;
   sr24[sy][sx].b:=((cainv*sr24[sy][sx].b) shr 8) + c24.b;

   end;
   
//done
xfd__inc32( (sy2-sy1+1) * (sx2-sx1+1) );
xfd__inc64;

end;

//?????????????????????????????????????
//?????????????????????????????????????
//?????????????????????????????????????
//?????????????????????????????????????
//?????????????????????????????????????

procedure xfd__drawPixels;
begin

//check
if (not fd_focus.b.ok) or (not fd_focus.b2.ok) or (fd_focus.power255<1) then exit;


if (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b2.amode=fd_area_outside_clip) then
   begin

   //nothing to do

   end

else if (fd_focus.b.amode=fd_area_inside_clip) and (fd_focus.b2.amode=fd_area_inside_clip) and
        (fd_focus.b.aw=fd_focus.b.aw) and (fd_focus.b.ah=fd_focus.b.ah) then
   begin

   if (fd_focus.power255<>255) then
      begin

      case fd_focus.flip or fd_focus.mirror of
      true:xfd__drawPixels900_power255_flip_mirror_cliprange;
      else xfd__drawPixels700_power255;
      end;//case

      end

   else if fd_focus.flip or fd_focus.mirror then
      begin

      xfd__drawPixels800_flip_mirror_cliprange;

      end

   else if (fd_focus.b.bits=fd_focus.b2.bits) and
           (fd_focus.b.ax1=fd_focus.b2.ax1) and
           (fd_focus.b.ay1=fd_focus.b2.ay1) and
           (fd_focus.b.aw =fd_focus.b2.aw ) and
           (fd_focus.b.ah =fd_focus.b2.ah ) then
           begin

           xfd__drawPixels500;//same bit depth and same area

           end
   else xfd__drawPixels600;

   end

else
   begin

   case (fd_focus.power255<>255) of
   true:xfd__drawPixels900_power255_flip_mirror_cliprange;
   else xfd__drawPixels800_flip_mirror_cliprange;
   end;//case

   end;

end;

procedure xfd__drawPixels500;//????????????????????????????
label//copies pixels from "b2" (source buffer) => "b" (target buffer)
     //mps ratings below are for an Intel Core i5 2.5 GHz
   yredo24,xredo24,yredo32,xredo32,
   yredo96_N,xredo96_N;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   sr96:pcolorrows96;
   dr96:pcolorrows96;
   xstop,ystop,xreset,xreset2,dx,dy:longint32;
   lx1,lx2,rx1,rx2,xreset96,xstop96:longint;

   function xcan96:boolean;
   begin

   result:=(fd_focus.b.bits=fd_focus.b2.bits) and xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96);

   if result then
      begin

      dr96   :=pcolorrows96(fd_focus.b .rows);
      sr96   :=pcolorrows96(fd_focus.b2.rows);

      end;

   end;

begin

//defaults
fd_drawProc32:=500;

//init
xreset      :=fd_focus.b.ax1;
xstop       :=fd_focus.b.ax2;
dy          :=fd_focus.b.ay1;
ystop       :=fd_focus.b.ay2;

//.bits
case fd_focus.b.bits of
24:begin

   dr24   :=pcolorrows24(fd_focus.b. rows);
   sr24   :=pcolorrows24(fd_focus.b2.rows);

   case xcan96 of
   true:begin

      fd_drawProc32:=597;
      goto yredo96_N;

      end;
   else
      begin

      fd_drawProc32:=524;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b .rows);
   sr32   :=pcolorrows32(fd_focus.b2.rows);

   case xcan96 of
   true:begin

      fd_drawProc32:=598;
      goto yredo96_N;

      end;
   else
      begin

      fd_drawProc32:=532;
      goto yredo32;

      end;
   end;//case

   end;
else exit;
end;//case


//render96_N (32bit=1100mps, 24bit=1400mps) ------------------------------------
yredo96_N:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset96;

xredo96_N:

//render pixel
dr96[dy][dx]:=sr96[dy][dx];

//inc x
if (dx<>xstop96) then
   begin

   inc(dx,1);
   goto xredo96_N;

   end;

//row "begin" and "end" gaps
case fd_focus.b.bits of
32:begin

   for dx:=lx1 to lx2 do dr32[dy][dx]:=sr32[dy][dx];
   for dx:=rx1 to rx2 do dr32[dy][dx]:=sr32[dy][dx];

   end;
24:begin

   for dx:=lx1 to lx2 do dr24[dy][dx]:=sr24[dy][dx];
   for dx:=rx1 to rx2 do dr24[dy][dx]:=sr24[dy][dx];

   end;
end;//case

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   goto yredo96_N;

   end;

//done
xfd__inc64;
exit;


//render24 (580mps) ------------------------------------------------------------
yredo24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;

xredo24:

//render pixel
dr24[dy][dx]:=sr24[dy][dx];

//inc x
if (dx<>xstop) then
   begin

   inc(dx,1);
   goto xredo24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   goto yredo24;

   end;

//done
xfd__inc64;
exit;


//render32 (730mps) ------------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;

xredo32:

//render pixel
dr32[dy][dx]:=sr32[dy][dx];

//inc x
if (dx<>xstop) then
   begin

   inc(dx,1);
   goto xredo32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   goto yredo32;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawPixels600;
label//copies pixels from fastdraw_focus.info2.drawinfo (source buffer) => fastdraw_focus.info.drawinfo (target buffer)
     //mps ratings below are for an Intel Core i5 2.5 GHz
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24,
   yredo96_N,xredo96_N;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   sr96:pcolorrows96;
   dr96:pcolorrows96;
   xstop,ystop,xreset,xreset2,sx,sy,dx,dy:longint32;
   lx1,lx2,rx1,rx2,xreset96,xstop96:longint32;

   function xcan96:boolean;
   begin

   result:=(xreset=xreset2) and (fd_focus.b.bits=fd_focus.b2.bits) and xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96) and (xstop96>=xreset96);

   if result then
      begin

      dr96   :=pcolorrows96(fd_focus.b .rows);
      sr96   :=pcolorrows96(fd_focus.b2.rows);

      end;

   end;

begin

//defaults
fd_drawProc32:=600;

//init
xreset      :=fd_focus.b .ax1;
xreset2     :=fd_focus.b2.ax1;//source
xstop       :=fd_focus.b .ax2;
dy          :=fd_focus.b .ay1;
sy          :=fd_focus.b2.ay1;//source
ystop       :=fd_focus.b .ay2;

//.source buffer
case fd_focus.b2.bits of
24:sr24   :=pcolorrows24(fd_focus.b2.rows);
32:sr32   :=pcolorrows32(fd_focus.b2.rows);
else       exit;
end;//case

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24   :=pcolorrows24(fd_focus.b.rows);

   if xcan96 then
      begin

      fd_drawProc32:=698;
      goto yredo96_N;

      end
   else
      begin

      case fd_focus.b2.bits of
      24:begin

         fd_drawProc32:=624;
         goto yredo24_24;

         end;
      32:begin

         fd_drawProc32:=625;
         goto yredo24_32;

         end;
      end;//case

      end;

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   if xcan96 then
      begin

      fd_drawProc32:=698;
      goto yredo96_N;

      end
   else
      begin

      case fd_focus.b2.bits of
      24:begin

         fd_drawProc32:=633;
         goto yredo32_24;

         end;
      32:begin

         fd_drawProc32:=632;
         goto yredo32_32;

         end;
      end;//case

      end;

   end;
else exit;
end;//case


//render96_N (32bit=1000mps, 24bit=1300mps) ------------------------------------
yredo96_N:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset96;

xredo96_N:

//render pixel
dr96[dy][dx]:=sr96[sy][dx];

//inc x
if (dx<>xstop96) then
   begin

   inc(dx,1);
   goto xredo96_N;

   end;

//row "begin" and "end" gaps
case fd_focus.b.bits of
32:begin

   for dx:=lx1 to lx2 do dr32[dy][dx]:=sr32[sy][dx];
   for dx:=rx1 to rx2 do dr32[dy][dx]:=sr32[sy][dx];

   end;
24:begin

   for dx:=lx1 to lx2 do dr24[dy][dx]:=sr24[sy][dx];
   for dx:=rx1 to rx2 do dr24[dy][dx]:=sr24[sy][dx];

   end;
end;//case

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo96_N;

   end;

//done
xfd__inc64;
exit;


//render24_24 (520mps) ---------------------------------------------------------
yredo24_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;

xredo24_24:

//render pixel: RGB -> RGB
dr24[dy][dx]:=sr24[sy][sx];

//inc x
if (dx<>xstop) then
   begin

   inc(dx,1);
   inc(sx,1);
   goto xredo24_24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo24_24;

   end;

//done
xfd__inc64;
exit;


//render24_32 (520mps) ---------------------------------------------------------
yredo24_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;

xredo24_32:

//render pixel: RGBA -> RGB
dr24[dy][dx]:=tint4( sr32[sy][sx] ).bgr24;

//inc x
if (dx<>xstop) then
   begin

   inc(dx,1);
   inc(sx,1);
   goto xredo24_32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo24_32;

   end;

//done
xfd__inc64;
exit;


//render32_32 (430mps) ---------------------------------------------------------
yredo32_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;

xredo32_32:

//render pixel: RGBA -> RGBA
dr32[dy][dx]:=sr32[sy][sx];

//inc x
if (dx<>xstop) then
   begin

   inc(dx,1);
   inc(sx,1);
   goto xredo32_32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo32_32;

   end;

//done
xfd__inc64;
exit;


//render32_24 (320mps) ---------------------------------------------------------
yredo32_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;

xredo32_24:

//render pixel: RGB -> RGBA
tint4( dr32[dy][dx] ).bgr24:=sr24[sy][sx];
dr32[dy][dx].a:=255;

//inc x
if (dx<>xstop) then
   begin

   inc(dx,1);
   inc(sx,1);
   goto xredo32_24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo32_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawPixels700_power255;//06jan2026, 29dec2025
label//copies pixels from fastdraw_focus.info2.drawinfo (source buffer) => fastdraw_focus.info.drawinfo (target buffer)
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24,
   yredo96_N,xredo96_N;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   sr96:pcolorrows96;
   dr96:pcolorrows96;
   ca,cainv,xstop,ystop,xreset,xreset2,sx,sy,dx,dy:longint32;
   d24,s24:pcolor24;
   d32,s32:pcolor32;
   lx1,lx2,rx1,rx2,xreset96,xstop96:longint32;
   dstop96,dindex,sindex:iauto;

   function xcan96:boolean;
   begin

   result:=(xreset=xreset2) and (fd_focus.b.bits=fd_focus.b2.bits) and xfd__canrow96(fd_focus.b,xreset,xstop,lx1,lx2,rx1,rx2,xreset96,xstop96) and (xstop96>=xreset96);

   if result then
      begin

      dr96   :=pcolorrows96(fd_focus.b .rows);
      sr96   :=pcolorrows96(fd_focus.b2.rows);

      end;

   end;

begin

//defaults
fd_drawProc32:=700;

//init
xreset      :=fd_focus.b .ax1;
xreset2     :=fd_focus.b2.ax1;//source
xstop       :=fd_focus.b .ax2;
dy          :=fd_focus.b .ay1;
sy          :=fd_focus.b2.ay1;//source
ystop       :=fd_focus.b .ay2;
ca          :=fd_focus.power255;
cainv       :=255-ca;

//check
if (ca=0) or (ca=255) then exit;

//.source buffer
case fd_focus.b2.bits of
24:sr24   :=pcolorrows24(fd_focus.b2.rows);
32:sr32   :=pcolorrows32(fd_focus.b2.rows);
else       exit;
end;//case

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24   :=pcolorrows24(fd_focus.b.rows);

   case xcan96 of
   true:begin

      fd_drawProc32:=797;
      goto yredo96_N;

      end;
   else begin

      case fd_focus.b2.bits of
      24:begin

         fd_drawProc32:=724;
         goto yredo24_24;

         end;
      32:begin

         fd_drawProc32:=725;
         goto yredo24_32;

         end;
      end;//case

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case xcan96 of
   true:begin

      fd_drawProc32:=798;
      goto yredo96_N;

      end;
   else begin

      case fd_focus.b2.bits of
      24:begin

         fd_drawProc32:=732;
         goto yredo32_24;

         end;
      32:begin

         fd_drawProc32:=733;
         goto yredo32_32;

         end;
      end;//case

      end;
   end;//case

   end;
else exit;
end;//case


//render96_N (32bit=250mps, 24bit=340mps) --------------------------------------
yredo96_N:

xfd__inc32(fd_focus.b.aw);
dindex :=iauto( @dr96[dy][xreset96] );
sindex :=iauto( @sr96[sy][xreset96] );
dstop96:=iauto( @dr96[dy][xstop96] );

xredo96_N:

pcolor96(dindex).v0 :=( (cainv*pcolor96(dindex).v0 )  + (ca*pcolor96(sindex).v0 ) ) shr 8;//faster than "div 256"
pcolor96(dindex).v1 :=( (cainv*pcolor96(dindex).v1 )  + (ca*pcolor96(sindex).v1 ) ) shr 8;
pcolor96(dindex).v2 :=( (cainv*pcolor96(dindex).v2 )  + (ca*pcolor96(sindex).v2 ) ) shr 8;
pcolor96(dindex).v3 :=( (cainv*pcolor96(dindex).v3 )  + (ca*pcolor96(sindex).v3 ) ) shr 8;
pcolor96(dindex).v4 :=( (cainv*pcolor96(dindex).v4 )  + (ca*pcolor96(sindex).v4 ) ) shr 8;
pcolor96(dindex).v5 :=( (cainv*pcolor96(dindex).v5 )  + (ca*pcolor96(sindex).v5 ) ) shr 8;
pcolor96(dindex).v6 :=( (cainv*pcolor96(dindex).v6 )  + (ca*pcolor96(sindex).v6 ) ) shr 8;
pcolor96(dindex).v7 :=( (cainv*pcolor96(dindex).v7 )  + (ca*pcolor96(sindex).v7 ) ) shr 8;
pcolor96(dindex).v8 :=( (cainv*pcolor96(dindex).v8 )  + (ca*pcolor96(sindex).v8 ) ) shr 8;
pcolor96(dindex).v9 :=( (cainv*pcolor96(dindex).v9 )  + (ca*pcolor96(sindex).v9 ) ) shr 8;
pcolor96(dindex).v10:=( (cainv*pcolor96(dindex).v10)  + (ca*pcolor96(sindex).v10) ) shr 8;
pcolor96(dindex).v11:=( (cainv*pcolor96(dindex).v11)  + (ca*pcolor96(sindex).v11) ) shr 8;

//inc x
if (dindex<>dstop96) then
   begin

   inc( dindex ,sizeof(tcolor96) );
   inc( sindex ,sizeof(tcolor96) );
   goto xredo96_N;

   end;

//row "begin" and "end" gaps
case fd_focus.b.bits of
32:begin

   for dx:=lx1 to lx2 do
   begin

   d32   :=@dr32[dy][dx];
   s32   :=@sr32[sy][dx];
   d32.r :=( (cainv*d32.r) + (ca*s32.r) ) shr 8;
   d32.g :=( (cainv*d32.g) + (ca*s32.g) ) shr 8;
   d32.b :=( (cainv*d32.b) + (ca*s32.b) ) shr 8;
   d32.a :=( (cainv*d32.a) + (ca*s32.a) ) shr 8;

   end;//dx

   for dx:=rx1 to rx2 do
   begin

   d32   :=@dr32[dy][dx];
   s32   :=@sr32[sy][dx];
   d32.r :=( (cainv*d32.r) + (ca*s32.r) ) shr 8;
   d32.g :=( (cainv*d32.g) + (ca*s32.g) ) shr 8;
   d32.b :=( (cainv*d32.b) + (ca*s32.b) ) shr 8;
   d32.a :=( (cainv*d32.a) + (ca*s32.a) ) shr 8;

   end;//dx

   end;

24:begin

   for dx:=lx1 to lx2 do
   begin

   d24   :=@dr24[dy][dx];
   s24   :=@sr24[sy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
   d24.g :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
   d24.b :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

   end;//dx

   for dx:=rx1 to rx2 do
   begin

   d24   :=@dr24[dy][dx];
   s24   :=@sr24[sy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
   d24.g :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
   d24.b :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

   end;//dx

   end;
end;//case

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo96_N;

   end;

//done
xfd__inc64;
exit;


//render32_32 (230mps) ---------------------------------------------------------
yredo32_32:

xfd__inc32(fd_focus.b.aw);
dindex :=iauto( @dr32[dy][xreset]  );
sindex :=iauto( @sr32[sy][xreset2] );
dstop96:=iauto( @dr32[dy][xstop]   );

xredo32_32:

//render pixel
pcolor32(dindex).r:=( (cainv*pcolor32(dindex).r) + (ca*pcolor32(sindex).r) ) shr 8;
pcolor32(dindex).g:=( (cainv*pcolor32(dindex).g) + (ca*pcolor32(sindex).g) ) shr 8;
pcolor32(dindex).b:=( (cainv*pcolor32(dindex).b) + (ca*pcolor32(sindex).b) ) shr 8;
pcolor32(dindex).a:=( (cainv*pcolor32(dindex).a) + (ca*pcolor32(sindex).a) ) shr 8;

//inc x
if (dindex<>dstop96) then
   begin

   inc( dindex ,sizeof(tcolor32) );
   inc( sindex ,sizeof(tcolor32) );
   goto xredo32_32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo32_32;

   end;

//done
xfd__inc64;
exit;


//render32_24 (260mps) ---------------------------------------------------------
yredo32_24:

xfd__inc32(fd_focus.b.aw);
dindex :=iauto( @dr32[dy][xreset]  );
sindex :=iauto( @sr24[sy][xreset2] );
dstop96:=iauto( @dr32[dy][xstop]   );

xredo32_24:

//render pixel
pcolor32(dindex).r:=( (cainv*pcolor32(dindex).r) + (ca*pcolor24(sindex).r) ) shr 8;
pcolor32(dindex).g:=( (cainv*pcolor32(dindex).g) + (ca*pcolor24(sindex).g) ) shr 8;
pcolor32(dindex).b:=( (cainv*pcolor32(dindex).b) + (ca*pcolor24(sindex).b) ) shr 8;
pcolor32(dindex).a:=( (cainv*pcolor32(dindex).a) + (ca*255               ) ) shr 8;

//inc x
if (dindex<>dstop96) then
   begin

   inc( dindex ,sizeof(tcolor32) );
   inc( sindex ,sizeof(tcolor24) );
   goto xredo32_24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo32_24;

   end;

//done
xfd__inc64;
exit;


//render24_24 (290mps) ---------------------------------------------------------
yredo24_24:

xfd__inc32(fd_focus.b.aw);
dindex :=iauto( @dr24[dy][xreset]  );
sindex :=iauto( @sr24[sy][xreset2] );
dstop96:=iauto( @dr24[dy][xstop]   );

xredo24_24:

//render pixel
pcolor24(dindex).r:=( (cainv*pcolor24(dindex).r) + (ca*pcolor24(sindex).r) ) shr 8;
pcolor24(dindex).g:=( (cainv*pcolor24(dindex).g) + (ca*pcolor24(sindex).g) ) shr 8;
pcolor24(dindex).b:=( (cainv*pcolor24(dindex).b) + (ca*pcolor24(sindex).b) ) shr 8;

//inc x
if (dindex<>dstop96) then
   begin

   inc( dindex ,sizeof(tcolor24) );
   inc( sindex ,sizeof(tcolor24) );
   goto xredo24_24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo24_24;

   end;

//done
xfd__inc64;
exit;


//render24_32 (340mps) ---------------------------------------------------------
yredo24_32:

xfd__inc32(fd_focus.b.aw);
dindex :=iauto( @dr24[dy][xreset]  );
sindex :=iauto( @sr32[sy][xreset2] );
dstop96:=iauto( @dr24[dy][xstop]   );

xredo24_32:

//render pixel
pcolor24(dindex).r:=( (cainv*pcolor24(dindex).r) + (ca*pcolor32(sindex).r) ) shr 8;
pcolor24(dindex).g:=( (cainv*pcolor24(dindex).g) + (ca*pcolor32(sindex).g) ) shr 8;
pcolor24(dindex).b:=( (cainv*pcolor24(dindex).b) + (ca*pcolor32(sindex).b) ) shr 8;

//inc x
if (dindex<>dstop96) then
   begin

   inc( dindex ,sizeof(tcolor24) );
   inc( sindex ,sizeof(tcolor32) );
   goto xredo24_32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo24_32;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawPixels800_flip_mirror_cliprange;
label
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   xshift,yshift,xstop,ystop,xreset,xreset2,sx,sy,dx,dy:longint32;
   dx1,dx2,dy1,dy2:longint;
   sx1,sx2,sy1,sy2:longint;
   yok:boolean;
begin

//defaults
fd_drawProc32:=800;

//init
dx1         :=fd_focus.b.cx1;//target
dx2         :=fd_focus.b.cx2;
dy1         :=fd_focus.b.cy1;
dy2         :=fd_focus.b.cy2;

sx1         :=fd_focus.b2.cx1;//source
sx2         :=fd_focus.b2.cx2;
sy1         :=fd_focus.b2.cy1;
sy2         :=fd_focus.b2.cy2;

xreset2     :=fd_focus.b2.ax1;//source
sy          :=fd_focus.b2.ay1;//source

//.y
if fd_focus.flip then
   begin

   dy       :=fd_focus.b.ay2;
   yshift   :=-1;
   ystop    :=fd_focus.b.ay1;

   end
else
   begin

   dy       :=fd_focus.b.ay1;
   yshift   :=1;
   ystop    :=fd_focus.b.ay2;

   end;

//.x
if fd_focus.mirror then
   begin

   xreset   :=fd_focus.b.ax2;
   xshift   :=-1;
   xstop    :=fd_focus.b.ax1;

   end
else
   begin

   xreset   :=fd_focus.b.ax1;
   xshift   :=1;
   xstop    :=fd_focus.b.ax2;

   end;


//.source buffer
case fd_focus.b2.bits of
24:sr24   :=pcolorrows24(fd_focus.b2.rows);
32:sr32   :=pcolorrows32(fd_focus.b2.rows);
else       exit;
end;//case

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24   :=pcolorrows24(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      fd_drawProc32:=824;
      goto yredo24_24;

      end;
   32:begin

      fd_drawProc32:=825;
      goto yredo24_32;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      fd_drawProc32:=832;
      goto yredo32_24;

      end;
   32:begin

      fd_drawProc32:=833;
      goto yredo32_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render24_24 ------------------------------------------------------------------

yredo24_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;
yok :=(dy>=dy1) and (dy<=dy2) and (sy>=sy1) and (sy<=sy2);

xredo24_24:

//render pixel: RGB -> RGB
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then dr24[dy][dx]:=sr24[sy][sx];

//inc x
if (dx<>xstop) then
   begin

   inc(dx,xshift);
   inc(sx,1);
   goto xredo24_24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,yshift);
   inc(sy,1);
   goto yredo24_24;

   end;

//done
xfd__inc64;
exit;


//render24_32 ------------------------------------------------------------------
yredo24_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;
yok :=(dy>=dy1) and (dy<=dy2) and (sy>=sy1) and (sy<=sy2);

xredo24_32:

//render pixel: RGBA -> RGB
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then dr24[dy][dx]:=tint4( sr32[sy][sx] ).bgr24;

//inc x
if (dx<>xstop) then
   begin

   inc(dx,xshift);
   inc(sx,1);
   goto xredo24_32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,yshift);
   inc(sy,1);
   goto yredo24_32;

   end;

//done
xfd__inc64;
exit;


//render32_32 ------------------------------------------------------------------
yredo32_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;
yok :=(dy>=dy1) and (dy<=dy2) and (sy>=sy1) and (sy<=sy2);

xredo32_32:

//render pixel: RGBA -> RGBA
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then dr32[dy][dx]:=sr32[sy][sx];

//inc x
if (dx<>xstop) then
   begin

   inc(dx,xshift);
   inc(sx,1);
   goto xredo32_32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,yshift);
   inc(sy,1);
   goto yredo32_32;

   end;

//done
xfd__inc64;
exit;


//render32_24 ------------------------------------------------------------------
yredo32_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;
yok :=(dy>=dy1) and (dy<=dy2) and (sy>=sy1) and (sy<=sy2);

xredo32_24:

//render pixel: RGB -> RGBA
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then
   begin

   tint4( dr32[dy][dx] ).bgr24:=sr24[sy][sx];
   dr32[dy][dx].a:=255;

   end;
   
//inc x
if (dx<>xstop) then
   begin

   inc(dx,xshift);
   inc(sx,1);
   goto xredo32_24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,yshift);
   inc(sy,1);
   goto yredo32_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawPixels900_power255_flip_mirror_cliprange;
label
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   xshift,yshift,xstop,ystop,xreset,xreset2,sx,sy,dx,dy:longint32;
   dx1,dx2,dy1,dy2:longint;
   sx1,sx2,sy1,sy2:longint;
   ca,cainv:longint;
   yok:boolean;
   d24,s24:pcolor24;
   d32,s32:pcolor32;
begin

//defaults
fd_drawProc32:=900;

//init
dx1         :=fd_focus.b.cx1;//target
dx2         :=fd_focus.b.cx2;
dy1         :=fd_focus.b.cy1;
dy2         :=fd_focus.b.cy2;

sx1         :=fd_focus.b2.cx1;//source
sx2         :=fd_focus.b2.cx2;
sy1         :=fd_focus.b2.cy1;
sy2         :=fd_focus.b2.cy2;

xreset2     :=fd_focus.b2.ax1;//source
sy          :=fd_focus.b2.ay1;//source
ca          :=fd_focus.power255;
cainv       :=255-ca;

//check
if (ca=0) or (ca=255) then exit;

//.y
if fd_focus.flip then
   begin

   dy       :=fd_focus.b.ay2;
   yshift   :=-1;
   ystop    :=fd_focus.b.ay1;

   end
else
   begin

   dy       :=fd_focus.b.ay1;
   yshift   :=1;
   ystop    :=fd_focus.b.ay2;

   end;

//.x
if fd_focus.mirror then
   begin

   xreset   :=fd_focus.b.ax2;
   xshift   :=-1;
   xstop    :=fd_focus.b.ax1;

   end
else
   begin

   xreset   :=fd_focus.b.ax1;
   xshift   :=1;
   xstop    :=fd_focus.b.ax2;

   end;


//.source buffer
case fd_focus.b2.bits of
24:sr24   :=pcolorrows24(fd_focus.b2.rows);
32:sr32   :=pcolorrows32(fd_focus.b2.rows);
else       exit;
end;//case

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24   :=pcolorrows24(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      fd_drawProc32:=924;
      goto yredo24_24;

      end;
   32:begin

      fd_drawProc32:=925;
      goto yredo24_32;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      fd_drawProc32:=932;
      goto yredo32_24;

      end;
   32:begin

      fd_drawProc32:=933;
      goto yredo32_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render24_24 ------------------------------------------------------------------
yredo24_24:

//???????????????????????????//optimise with pindex with xshift*sizeof(...) //????????????????????
xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;
yok :=(dy>=dy1) and (dy<=dy2) and (sy>=sy1) and (sy<=sy2);

xredo24_24:

//render pixel: RGB -> RGB
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then
   begin

   s24   :=@sr24[sy][sx];
   d24   :=@dr24[dy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s24.r) ) div 256;
   d24.g :=( (cainv*d24.g) + (ca*s24.g) ) div 256;
   d24.b :=( (cainv*d24.b) + (ca*s24.b) ) div 256;

   end;

//inc x
if (dx<>xstop) then
   begin

   inc(dx,xshift);
   inc(sx,1);
   goto xredo24_24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,yshift);
   inc(sy,1);
   goto yredo24_24;

   end;

//done
xfd__inc64;
exit;


//render24_32 ------------------------------------------------------------------
yredo24_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;
yok :=(dy>=dy1) and (dy<=dy2) and (sy>=sy1) and (sy<=sy2);

xredo24_32:

//render pixel: RGBA -> RGB
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then
   begin

   s32   :=@sr32[sy][sx];
   d24   :=@dr24[dy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s32.r) ) div 256;
   d24.g :=( (cainv*d24.g) + (ca*s32.g) ) div 256;
   d24.b :=( (cainv*d24.b) + (ca*s32.b) ) div 256;

   end;

//inc x
if (dx<>xstop) then
   begin

   inc(dx,xshift);
   inc(sx,1);
   goto xredo24_32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,yshift);
   inc(sy,1);
   goto yredo24_32;

   end;

//done
xfd__inc64;
exit;


//render32_32 ------------------------------------------------------------------
yredo32_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;
yok :=(dy>=dy1) and (dy<=dy2) and (sy>=sy1) and (sy<=sy2);

xredo32_32:

//render pixel: RGBA -> RGBA
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then
   begin

   s32   :=@sr32[sy][sx];
   d32   :=@dr32[dy][dx];
   d32.r :=( (cainv*d32.r) + (ca*s32.r) ) div 256;
   d32.g :=( (cainv*d32.g) + (ca*s32.g) ) div 256;
   d32.b :=( (cainv*d32.b) + (ca*s32.b) ) div 256;
   d32.a :=( (cainv*d32.a) + (ca*s32.a) ) div 256;

   end;

//inc x
if (dx<>xstop) then
   begin

   inc(dx,xshift);
   inc(sx,1);
   goto xredo32_32;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,yshift);
   inc(sy,1);
   goto yredo32_32;

   end;

//done
xfd__inc64;
exit;


//render32_24 ------------------------------------------------------------------
yredo32_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;
yok :=(dy>=dy1) and (dy<=dy2) and (sy>=sy1) and (sy<=sy2);

xredo32_24:

//render pixel: RGB -> RGBA
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then
   begin

   s24   :=@sr24[sy][sx];
   d32   :=@dr32[dy][dx];
   d32.r :=( (cainv*d32.r) + (ca*s24.r) ) div 256;
   d32.g :=( (cainv*d32.g) + (ca*s24.g) ) div 256;
   d32.b :=( (cainv*d32.b) + (ca*s24.b) ) div 256;
   d32.a :=( (cainv*d32.a) + (ca*255  ) ) div 256;

   end;
   
//inc x
if (dx<>xstop) then
   begin

   inc(dx,xshift);
   inc(sx,1);
   goto xredo32_24;

   end;

//inc y
if (dy<>ystop) then
   begin

   inc(dy,yshift);
   inc(sy,1);
   goto yredo32_24;

   end;

//done
xfd__inc64;

end;

//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????
//??????????????????????????????????????????????

procedure xfd__lingCapture_template_flip_mirror_nochecks(var x:tfastdraw;var xb:tfastdrawbuffer;const xdestImage:pling);
label
   yredo24,xredo24,yredo32,xredo32;
var
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   xstop,ystop,xreset,xshift,yshift,tx,ty,sx,sy,dx,dy:longint32;
   yok:boolean;
   v24:pcolor24;
begin

//init
sy            :=xb.ay1;
dy            :=0;
xdestImage.w  :=x.rimage^.w;
xdestImage.h  :=x.rimage^.h;

//.fast cls -> all pixels set to (0,0,0,0)
ling__cls(xdestImage^);

//.y
if x.flip then
   begin

   ty       :=xdestImage.h - 1;
   yshift   :=-1;
   ystop    :=0;

   end
else
   begin

   ty       :=0;
   yshift   :=1;
   ystop    :=xdestImage.h - 1;

   end;

//.x
if x.mirror then
   begin

   xreset   :=xdestImage.w - 1;
   xshift   :=-1;
   xstop    :=0;

   end
else
   begin

   xreset   :=0;
   xshift   :=1;
   xstop    :=xdestImage.w - 1;

   end;

//.bits
case xb.bits of
24:begin

   sr24:=pcolorrows24(xb.rows);
   goto yredo24;

   end;
32:begin

   sr32:=pcolorrows32(xb.rows);
   goto yredo32;

   end;
else  exit;
end;//case


//render24 ---------------------------------------------------------------------
yredo24:

sx  :=xb.ax1;
dx  :=0;
tx  :=xreset;
yok :=(sy>=xb.cy1) and (sy<=xb.cy2);

xredo24:

//render pixel
if yok and (sx>=xb.cx1) and (sx<=xb.cx2) and (x.rimage.pixels[ty][tx].a>0) then
   begin

   v24                         :=@sr24[sy][sx];
   xdestImage.pixels[dy][dx].r :=v24.r;
   xdestImage.pixels[dy][dx].g :=v24.g;
   xdestImage.pixels[dy][dx].b :=v24.b;
   xdestImage.pixels[dy][dx].a :=255;

   end;

//inc x
if (tx<>xstop) then
   begin

   inc(sx,1);
   inc(dx,1);
   inc(tx,xshift);
   goto xredo24;

   end;

//inc y
if (ty<>ystop) then
   begin

   inc(sy,1);
   inc(dy,1);
   inc(ty,yshift);
   goto yredo24;

   end;

//done
exit;


//render32 ---------------------------------------------------------------------
yredo32:

sx  :=xb.ax1;
dx  :=0;
tx  :=xreset;
yok :=(sy>=xb.cy1) and (sy<=xb.cy2);

xredo32:

//render pixel
if yok and (sx>=xb.cx1) and (sx<=xb.cx2) and (x.rimage.pixels[ty][tx].a>0) then
   begin

   xdestImage.pixels[dy][dx]   :=sr32[sy][sx];
   xdestImage.pixels[dy][dx].a :=255;

   end;

//inc x
if (tx<>xstop) then
   begin

   inc(sx,1);
   inc(dx,1);
   inc(tx,xshift);
   goto xredo32;

   end;

//inc y
if (ty<>ystop) then
   begin

   inc(sy,1);
   inc(dy,1);
   inc(ty,yshift);
   goto yredo32;

   end;

//done

end;

function xfd__canrow96(const x:tfastdrawbuffer;const xmin,xmax:longint32;var lx1,lx2,rx1,rx2,xfrom96,xto96:longint32):boolean;//01jan2026
var
   cx1,cx2:longint32;
begin
                                    //image is too narrow (30px or less) to gain much speed out of optimisations, so disable
if (not fd_optimise_ok) or (x.aw<=30) then
   begin

   lx1        :=xmin;
   lx2        :=xmax;
   rx1        :=0;
   rx2        :=-1;
   xfrom96    :=0;
   xto96      :=-1;

   end
else if (x.bits=32) then//3 x tcolor32 (32 bit pixels) per tcolor96 block
   begin

   cx1    :=((xmin+2) div 3)*3;
   cx2    :=cx1 + (((xmax-cx1+1) div 3)*3) - 1;

   lx1    :=xmin;
   lx2    :=cx1-1;
   if (lx2>xmax) then lx2:=xmax;

   rx1    :=cx2+1;
   rx2    :=xmax;
   if (rx1<xmin) then rx1:=xmin;


   if (cx2>=cx1) then
      begin

      xfrom96 :=cx1 div 3;
      xto96   :=cx2 div 3;

      end
   else
      begin

      xfrom96 :=0;
      xto96   :=-1;

      end;

   end

else if (x.bits=24) then//4 x tcolor24 (24 bit pixels) per tcolor96 block
   begin

   cx1    :=((xmin+3) div 4)*4;
   cx2    :=cx1 + (((xmax-cx1+1) div 4)*4) - 1;

   lx1    :=xmin;
   lx2    :=cx1-1;
   if (lx2>xmax) then lx2:=xmax;

   rx1    :=cx2+1;
   rx2    :=xmax;
   if (rx1<xmin) then rx1:=xmin;


   if (cx2>=cx1) then
      begin

      xfrom96 :=cx1 div 4;
      xto96   :=cx2 div 4;

      end
   else
      begin

      xfrom96 :=0;
      xto96   :=-1;

      end;

   end
else
   begin

   lx1        :=xmin;
   lx2        :=xmax;
   rx1        :=0;
   rx2        :=-1;
   xfrom96    :=0;
   xto96      :=-1;

   end;

//set
result:=(xto96>xfrom96);

end;

function xfd__canrow962(const xbits,xmin,xmax:longint32;var lx1,lx2,rx1,rx2,xfrom96,xto96:longint32):boolean;//01jan2026
var
   cx1,cx2:longint32;
begin
                                    //image is too narrow (30px or less) to gain much speed out of optimisations, so disable
if (not fd_optimise_ok) or ((xmax-xmin+1)<=30) then
   begin

   lx1        :=xmin;
   lx2        :=xmax;
   rx1        :=0;
   rx2        :=-1;
   xfrom96    :=0;
   xto96      :=-1;

   end
else if (xbits=32) then//3 x tcolor32 (32 bit pixels) per tcolor96 block
   begin

   cx1    :=((xmin+2) div 3)*3;
   cx2    :=cx1 + (((xmax-cx1+1) div 3)*3) - 1;

   lx1    :=xmin;
   lx2    :=cx1-1;
   if (lx2>xmax) then lx2:=xmax;

   rx1    :=cx2+1;
   rx2    :=xmax;
   if (rx1<xmin) then rx1:=xmin;


   if (cx2>=cx1) then
      begin

      xfrom96 :=cx1 div 3;
      xto96   :=cx2 div 3;

      end
   else
      begin

      xfrom96 :=0;
      xto96   :=-1;

      end;

   end

else if (xbits=24) then//4 x tcolor24 (24 bit pixels) per tcolor96 block
   begin

   cx1    :=((xmin+3) div 4)*4;
   cx2    :=cx1 + (((xmax-cx1+1) div 4)*4) - 1;

   lx1    :=xmin;
   lx2    :=cx1-1;
   if (lx2>xmax) then lx2:=xmax;

   rx1    :=cx2+1;
   rx2    :=xmax;
   if (rx1<xmin) then rx1:=xmin;


   if (cx2>=cx1) then
      begin

      xfrom96 :=cx1 div 4;
      xto96   :=cx2 div 4;

      end
   else
      begin

      xfrom96 :=0;
      xto96   :=-1;

      end;

   end
else
   begin

   lx1        :=xmin;
   lx2        :=xmax;
   rx1        :=0;
   rx2        :=-1;
   xfrom96    :=0;
   xto96      :=-1;

   end;

//set
result:=(xto96>xfrom96);

end;

procedure xfd__ling_makedebug(var x:tling);
var
   dx,dy:longint;
begin

//check
if (x.w<1) then exit;

//get
for dy:=0 to (x.h-1) do for dx:=0 to (x.w-1) do if (x.pixels[dy][dx].a>0) then
   begin

   x.pixels[dy][dx].r:=255;
   x.pixels[dy][dx].g:=0;
   x.pixels[dy][dx].b:=0;

   end;

end;

end.
