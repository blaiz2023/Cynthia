unit gossimg;

interface
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot, gossio, gosswin {$ifdef gui},gossdat{$endif}{$ifdef jpeg},gossjpg{$endif};
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
//## Library.................. image/graphics (gossimg.pas)
//## Version.................. 4.00.15574 (+345)
//## Items.................... 25
//## Last Updated ............ 19jun2025, 12jun2025, 09jun2025, 29may2025, 26apr2025, 23mar2025, 22feb2025, 05feb2025, 31jan2025, 02jan2025, 27dec2024, 27nov2024, 15nov2024, 18aug2024, 26jul2024, 17apr2024
//## Lines of Code............ 29,600+
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
//## | Name                   | Hierarchy         | Version    | Date        | Update history / brief description of function
//## |------------------------|-------------------|------------|-------------|--------------------------------------------------------
//## | tbasicimage            | tobject           | 1.00.187   | 07dec2023   | Lightweight + fast system independent image, not resizable, supports 8/24/32 bit pixel depth - 09may2022, 27jul2021, 25jan2021, ??jan2020: created
//## | twinbmp                | tobject           | 1.00.060   | 01may2025   | Replacement for tbitmap - 26apr2025
//## | trawimage              | tobject           | 1.00.070   | 26apr2025   | Independent resizeable image -> persistent pixel rows and supports 8/24/32 bit color depth - 27dec2024, 25jul2024: created
//## | c8__/c24__/c32__/int__ | family of procs   | 1.00.245   | 06may2025   | Graphic color conversion procs - 18feb2025
//## | mis*                   | family of procs   | 1.00.10480 | 06jun2025   | Graphic procs for working with multiple different image objects - 09may2025, 27dec2024, 27nov2024
//## | ref_*                  | family of procs   | 1.00.100   | 20jul2024   | Reference procs for image adjustment
//## | canvas__*              | family of procs   | 1.00.045   | 18feb2025   | Indirect support for tcanvas - 28jun2024
//## | gif__*                 | family of procs   | 1.00.900   | 06aug2024   | Read / write GIF images, static and animated, automatic on-the-fly optimisation (solid, transparent and mixed cell modes)
//## | bmp__*                 | family of procs   | 1.00.472   | 12jun2025   | Read / write BMP images - 32bit with alpha/DIB/clipboard formats - 26may2025, 14may2025, 01may2025, 06aug2024
//## | dib__*                 | family of procs   | 1.00.052   | 28may2025   | Read / write DIB images - 14may2025, 06aug2024
//## | tj32__*                | family of procs   | 1.00.045   | 06aug2024   | Read / write TJ32 images -> 32bit hybrid transparent jpeg -> static and animated
//## | img32__*               | family of procs   | 1.00.040   | 06aug2024   | Read / write IMG32 images -> 32bit raw images -> static and animated
//## | jpg__*                 | family of procs   | 1.00.272   | 05dec2024   | Read / write JPEG images -> automatic quality control - 24nov2024, 06aug2024
//## | png__*                 | family of procs   | 1.00.331   | 29may2025   | Read / write PMG images - 15mar2025, 15nov2024
//## | tea__*                 | family of procs   | 1.00.393   | 17jun2025   | Read / write TEA images - 12dec2024, 18nov2024
//## | ico__*, low__ico*      | family of procs   | 1.00.653   | 19jun2025   | Read / write ICO images - 28may2025, 13may2025, 22nov2024
//## | cur__*                 | family of procs   | 1.00.210   | 28may2025   | Read / write CUR images - 22nov2024
//## | ani__*                 | family of procs   | 1.00.200   | 22nov2024   | Read / write ANI images
//## | ia__*                  | family of procs   | 1.00.131   | 21dec2024   | Read / write image action commands - for passing low level information to graphic subprocs - 24nov2024
//## | tga__*                 | family of procs   | 1.00.205   | 29may2025   | Read / write TGA images in 8bit greyscale and 24bit/32bit color with or without RLE compression and topleft or botleft orientation - 20dec2024
//## | ppm__*                 | family of procs   | 1.00.040   | 02jan2025   | Read / write PPM images
//## | pgm__*                 | family of procs   | 1.00.020   | 02jan2025   | Read / write PGM images
//## | pbm__*                 | family of procs   | 1.00.035   | 02jan2025   | Read / write PBM images
//## | pnm__*                 | family of procs   | 1.00.022   | 02jan2025   | Read / write PNM images
//## | xbm__*                 | family of procs   | 1.00.040   | 02jan2025   | Read / write XBM images
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================

const
   //Color Format
   cfNone         =0;
   cfRGB24        =1;
   cfBGR24        =2;
   cfRGBA32       =3;
   cfBGRA32       =4;
   cfRGB16        =5;//16bit color
   cfRGB15        =6;//15bit color
   cfRGB8         =7;//8bit grey/color



   //image action strings - 27jul2024 ------------------------------------------
   //for use with mis__todata, mis__tofile and other image procs
   //send specific commands and values to procs

//   ia_sep                             =#1;
//   ia_valsep                          =#2;
   ia_sep                             ='|';//
   ia_s                               =ia_sep;//short form
   ia_valsep                          =':';
   ia_v                               =ia_valsep;

   //actions -> all actions are assumed to "set" a value or condition unless otherwise stated
   ia_none                            ='';

   //.debug
   ia_debug                           ='debug';

   //.stream support
   ia_usestr9                         ='use.str9';

   //.info
   ia_info_filename                   ='info.filename';

   //.animation support
   ia_cellcount                       ='cellcount';
   ia_delay                           ='delay';
   ia_loop                            ='loop';
   ia_hotspot                         ='hotspot';//2 vals -> x,y
   ia_bpp                             ='bpp';
   ia_size                            ='size';
   ia_transparentcolor                ='transparentcolor';
   ia_nonAnimatedFormatsSaveImageStrip='nonanimatedformatssaveimagestrip';//14dec2024
   ia_transparent                     ='transparent';

   //.manual quality
   ia_quality100                      ='quality'+ia_v+'0-100';//0..100 - 0=worst, 100=best
   //.auto quality
   ia_bestquality                     ='quality'+ia_v+'best';
   ia_highquality                     ='quality'+ia_v+'high';
   ia_goodquality                     ='quality'+ia_v+'good';
   ia_fairquality                     ='quality'+ia_v+'fair';
   ia_lowquality                      ='quality'+ia_v+'low';

   //.bit depth
   ia_32bitPLUS                       ='32bitplus';//04jun2025
   ia_24bitPLUS                       ='24bitplus';//04jun2025

   //.size limit
   ia_limitsize64                     ='limitsize64'+ia_v+'bytes';//0..n, where 0=disabled, 1..N limits data size

   //.info vars -> these typically store reply info
   ia_info_quality                    ='info.quality';
   ia_info_cellcount                  ='info.cellcount';
   ia_info_bytes_image                ='info.bytes.image';
   ia_info_bytes_mask                 ='info.bytes.mask';


   //TGA action codes ----------------------------------------------------------
   ia_tga_best                        ='tga.best';

   //.bit depth
   ia_tga_32bpp                       ='tga.32bpp';
   ia_tga_24bpp                       ='tga.24bpp';
   ia_tga_8bpp                        ='tga.8bpp';
   ia_tga_autobpp                     ='tga.autobpp';

   //.compression
   ia_tga_RLE                         ='tga.rle';
   ia_tga_noRLE                       ='tga.norle';

   //.orientation
   ia_tga_topleft                     ='tga.topleft';
   ia_tga_botleft                     ='tga.botleft';


   //PPM action codes ----------------------------------------------------------
   ia_ppm_binary                      ='ppm.binary';
   ia_ppm_ascii                       ='ppm.ascii';


   //PGM action codes ----------------------------------------------------------
   ia_pgm_binary                      ='pgm.binary';
   ia_pgm_ascii                       ='pgm.ascii';


   //PGM action codes ----------------------------------------------------------
   ia_pbm_binary                      ='pbm.binary';
   ia_pbm_ascii                       ='pbm.ascii';


   //PNM action codes ----------------------------------------------------------
   ia_pnm_binary                      ='pnm.binary';
   ia_pnm_ascii                       ='pnm.ascii';


type
   tbasicimage  =class;
   twinbmp      =class;
   trawimage    =class;
   tgifsupport  =class;

   //.bitmap animation helper record
   panimationinformation=^tanimationinformation;
   tanimationinformation=record
    format:string;//uppercase EXT (e.g. JPG, BMP, SAN etc)
    subformat:string;//same style as format, used for dual format streams "ATEP: 1)animation header + 2)image"
    info:string;//UNICODE WARNING --- optional custom information data block packed at end of image data - 22APR2012
    filename:string;
    map16:string;//UNICODE WARNING --- 26MAY2009 - used in "CAN or Compact Animation" to map all original cells to compacted imagestrip
    transparent:boolean;
    syscolors:boolean;//13apr2021
    flip:boolean;
    mirror:boolean;
    delay:longint;
    itemindex:longint;
    count:longint;//0..X (0=1cell, 1=2cells, etc)
    bpp:byte;
    binary:boolean;
    //cursor - 20JAN2012
    hotspotX:longint;//-1=not set=default
    hotspotY:longint;//-1=not set=default
    hotspotMANUAL:boolean;//use this hotspot instead of automatic hotspot - 03jan2019
    //32bit capable formats
    owrite32bpp:boolean;//default=false, for write modes within "ccs.todata()" where 32bit is used as the default save BPP - 22JAN2012
    //final
    readB64:boolean;//true=image was b64 encoded
    readB128:boolean;//true=image was b128 encoded
    writeB64:boolean;//true=encode image using b64
    writeB128:boolean;//true=encode image using b128 - 09feb2015
    //internal
    iosplit:longint;//position in IO stream that animation sep. (#0 or "#" occurs)
    cellwidth:longint;
    cellheight:longint;
    use32:boolean;
    end;


{tgifsupport}
   tgifsupport=class(tobject)
   public
    ds  :pobject;//pointer to data stream => tstr8 or tstr9
    s32 :trawimage;//smart buffer
    d32 :trawimage;//difference buffer
    p8  :trawimage;//palette buffer
    sw  :longint;//screen width (for us, same as cellwidth)
    sh  :longint;//screen height
    cc  :longint;
    //.flags modification "reach-back" support - 06aug2024
    flags__lastpos:longint;
    flags__lastval:longint;
    //.palette
    ppal  :array [0..255] of tcolor24;
    pcount:longint;
    //create
    constructor create; virtual;
    destructor destroy; override;
    //workers
    function size(dw,dh:longint):boolean;
    procedure pcls;
    function pmake(a32:tobject;atrans:boolean):boolean;//make palette
   end;

{tbasicimage}
   tbasicimage=class(tobject)
   private
    idata,irows:tstr8;
    ibits,iwidth,iheight:longint;
    iprows8 :pcolorrows8;
    iprows16:pcolorrows16;
    iprows24:pcolorrows24;
    iprows32:pcolorrows32;
    istable:boolean;
    procedure setareadata(sa:twinrect;sdata:tstr8);
    function getareadata(sa:twinrect):tstr8;
    function getareadata2(sa:twinrect):tstr8;
   public
    //animation support
    ai:tanimationinformation;
    dtransparent:boolean;
    omovie:boolean;//default=false, true=fromdata will create the "movie" if not already created
    oaddress:string;//used for "AAS" to load from a specific folder - 30NOV2010
    ocleanmask32bpp:boolean;//default=false, true=reads only the upper levels of the 8bit mask of a 32bit icon/cursor to eliminate poor mask quality - ccs.fromicon32() etc - 26JAN2012
    rhavemovie:boolean;//default=false, true=object has a movie as it's animation
    //create
    constructor create; virtual;
    destructor destroy; override;
    function copyfrom(s:tbasicimage):boolean;//09may2022, 09feb2022
    //information
    property stable:boolean read istable;
    property bits:longint read ibits;
    property width:longint read iwidth;
    property height:longint read iheight;
    property prows8 :pcolorrows8  read iprows8;
    property prows16:pcolorrows16 read iprows16;
    property prows24:pcolorrows24 read iprows24;
    property prows32:pcolorrows32 read iprows32;
    property rows:tstr8 read irows;
    //workers
    function sizeto(dw,dh:longint):boolean;
    function setparams(dbits,dw,dh:longint):boolean;
    function findscanline(slayer,sy:longint):pointer;
    //io
    function todata:tstr8;//19feb2022
    function fromdata(s:tstr8):boolean;//19feb2022
    //core
    property data:tstr8 read idata;
    //.raw data handlers
    function setraw(dbits,dw,dh:longint;ddata:tstr8):boolean;
    function getarea(ddata:tstr8;da:twinrect):boolean;//07dec2023
    function getarea_fast(ddata:tstr8;da:twinrect):boolean;//07dec2023 - uses a statically sized buffer (sizes it to correct length if required) so repeat usage is faster
    function setarea(ddata:tstr8;da:twinrect):boolean;//07dec2023
    property areadata[sa:twinrect]:tstr8 read getareadata write setareadata;
    property areadata_fast[sa:twinrect]:tstr8 read getareadata2 write setareadata;
   end;

{trawimage}
   trawimage=class(tobject)
   private
    icore:tdynamicstr8;
    irows:tstr8;
    ifallback:tstr8;
    ibits,iwidth,iheight:longint;
    irows8 :pcolorrows8;
    irows15:pcolorrows16;
    irows16:pcolorrows16;
    irows24:pcolorrows24;
    irows32:pcolorrows32;
    procedure setbits(x:longint);
    procedure setwidth(x:longint);
    procedure setheight(x:longint);
    function getscanline(sy:longint):pointer;
    procedure xsync;
   public
    //animation support
    ai:tanimationinformation;
    dtransparent:boolean;
    omovie:boolean;//default=false, true=fromdata will create the "movie" if not already created
    oaddress:string;//used for "AAS" to load from a specific folder - 30NOV2010
    ocleanmask32bpp:boolean;//default=false, true=reads only the upper levels of the 8bit mask of a 32bit icon/cursor to eliminate poor mask quality - ccs.fromicon32() etc - 26JAN2012
    rhavemovie:boolean;//default=false, true=object has a movie as it's animation
    //create
    constructor create; virtual;
    destructor destroy; override;
    //information
    property core:tdynamicstr8 read icore;
    function setparams(dbits,dw,dh:longint):boolean;
    function setparams2(dbits,dw,dh:longint;dforce:boolean):boolean;//27dec2024
    property bits:longint   read ibits   write setbits;
    property width:longint  read iwidth  write setwidth;
    property height:longint read iheight write setheight;
    property rows   :tstr8  read irows;//12dec2024
    property prows8 :pcolorrows8  read irows8;
    property prows15:pcolorrows16 read irows15;
    property prows16:pcolorrows16 read irows16;
    property prows24:pcolorrows24 read irows24;
    property prows32:pcolorrows32 read irows32;
    property scanline[sy:longint]:pointer read getscanline;
    function rowinfo(sy:longint):string;
   end;

{twinbmp}
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//bbbbbbbbbbbbbbbbbbbbbbb
   twinbmp=class(tobject)
   private
    iinfo    :TBitmapInfoHeader;
    ihbitmap :HBITMAP;
    icore    :pointer;
    idc      :hdc;

    irows:tstr8;
    ibits,iwidth,iheight,irowsize:longint;

    irows8 :pcolorrows8;
    irows15:pcolorrows16;
    irows16:pcolorrows16;
    irows24:pcolorrows24;
    irows32:pcolorrows32;
    procedure setwidth(x:longint);
    procedure setheight(x:longint);
    procedure setbits(x:longint);
    procedure xfreeimage;
   public
    //animation support
    ai:tanimationinformation;
    //create
    constructor create; virtual;
    destructor destroy; override;
    //information
    property dc:hdc read idc;
    property handle:hbitmap read ihbitmap;
    property bits:longint read ibits write setbits;
    property width:longint read iwidth write setwidth;
    property height:longint read iheight write setheight;
    property rowsize:longint read irowsize;
    function bytes:comp;
    //setparams
    function setparams(dbits,dw,dh:longint):boolean;
    function setparams2(dbits,dw,dh:longint;dforce:boolean):boolean;
    //scanline
    property rows   :tstr8        read irows;
    property prows8 :pcolorrows8  read irows8;
    property prows15:pcolorrows16 read irows15;
    property prows16:pcolorrows16 read irows16;
    property prows24:pcolorrows24 read irows24;
    property prows32:pcolorrows32 read irows32;
    function getscanline(sy:longint):pointer;
    //workers
    function copyarea(sa:twinrect;s:hdc):boolean;
    function copyarea2(da,sa:twinrect;s:hdc):boolean;
   end;


//GIF - thashtable
const
   HashKeyBits		= 13;			//Max number of bits per Hash Key
   HashSize		= 8009;			//Size of hash table, must be prime, must be > than HashMaxCode, must be < than HashMaxKey
   HashKeyMax		= (1 SHL HashKeyBits)-1;//Max hash key value, 13 bits = 8191
   HashKeyMask		= HashKeyMax;		//was $1FFF
   GIFCodeBits		= 12;			//Max number of bits per GIF token code
   GIFCodeMax		= (1 SHL GIFCodeBits)-1;//Max GIF token code
   GIFCodeMask		= GIFCodeMax;		//was $0FFF
   HashEmpty		= $000FFFFF;		//20 bits
   GIFTableMaxMaxCode	= (1 SHL GIFCodeBits);
   GIFTableMaxFill	= GIFTableMaxMaxCode-1;	//Clear table when it fills to

type
//GIF - thashtable
    tgifscreen=packed record//7
     w:word;
     h:word;
     pf:byte;//packed flags
     bgi:byte;//background color index that points to a color in "global color palette"
     ar:byte;//aspectratio => actual ratio = (AspectRatio + 15) / 64
     end;
    tgifimgdes=packed record
     sep:byte;
     dx:word;
     dy:word;
     w:word;
     h:word;
     pf:byte;//bit fields
     end;

   // A Hash Key is 20 bits wide.
    // - The lower 8 bits are the postfix character (the new pixel).
    // - The upper 12 bits are the prefix code (the GIF token).
    // A KeyInt must be able to represent the integer values -1..(2^20)-1
    //KeyInt = longInt;	// 32 bits
    //CodeInt = SmallInt;	// 16 bits
    thasharray=array[0..hashsize-1] of longint;
    phasharray=^thasharray;
    thashtable=class(tobjectex)//hash table for GIF compressor
    private
     hashtable:phasharray;
    public
     constructor create; virtual;
     destructor destroy; override;
     procedure clear;
     procedure insert(key:longint;code:smallint);
     function lookup(key:longint):smallint;
    end;

var
   //.started
   system_started      :boolean=false;

   //.ref arrays
   ref65025_div_255      :array[0..65025] of byte;//06apr2017

   //.filter arrays
   fb255                 :array[-1024..1024] of byte;
   fbwrap255             :array[-1024..1024] of byte;

   //.temp buffer support
   systmpstyle           :array[0..99] of byte;//0=free, 1=available, 2=locked
   systmpid              :array[0..99] of string;
   systmptime            :array[0..99] of comp;
   systmpbmp             :array[0..99] of tbasicimage;//23may2020
   systmppos             :longint;
   //.temp int buffer support
   sysintstyle           :array[0..99] of byte;//0=free, 1=available, 2=locked
   sysintid              :array[0..99] of string;
   sysinttime            :array[0..99] of comp;
   sysintobj             :array[0..99] of tdynamicinteger;
   sysintpos             :longint;
   //.temp byte buffer support
   sysbytestyle          :array[0..99] of byte;//0=free, 1=available, 2=locked
   sysbyteid             :array[0..99] of string;
   sysbytetime           :array[0..99] of comp;
   sysbyteobj            :array[0..99] of tdynamicbyte;
   sysbytepos            :longint;
   //.mis support
   system_default_ai     :tanimationinformation;//29may2019
   system_screenlogpixels:longint=96;
   
   //.random sparkle shader list -> stores a list of random shades 0..100 - 27feb2022
   system_sparklelist   :array[0..9999] of byte;
   system_sparklepos    :longint=0;
   system_sparkleref    :longint=-1;
   system_sparklecount  :longint=0;//tracks number of times low__sparkfill fills the list - 27feb2022

//start-stop procs -------------------------------------------------------------
procedure gossimg__start;
procedure gossimg__stop;

//.format checkers
function gossimg__havebmp:boolean;//18aug2024
function gossimg__haveico:boolean;
function gossimg__havegif:boolean;
function gossimg__havejpg:boolean;
function gossimg__havetga:boolean;//20feb2025

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function app__bol(xname:string):boolean;
function info__img(xname:string):string;//information specific to this unit of code

//general procs ----------------------------------------------------------------
function zzimg(x:tobject):boolean;//12feb2202
function asimg(x:tobject):tbasicimage;//12feb2202

//temp procs -------------------------------------------------------------------
//note: rapid reuse of temporary objects for caching tasks, like for intensive graphics scaling work etc
function low__createimg24(var x:tbasicimage;xid:string;var xwascached:boolean):boolean;
procedure low__freeimg(var x:tbasicimage);
procedure low__checkimg;
function low__createint(var x:tdynamicinteger;xid:string;var xwascached:boolean):boolean;
procedure low__freeint(var x:tdynamicinteger);
procedure low__checkint;
function low__createbyte(var x:tdynamicbyte;xid:string;var xwascached:boolean):boolean;
procedure low__freebyte(var x:tdynamicbyte);
procedure low__checkbyte;

//graphics procs ---------------------------------------------------------------
procedure low__scaledown(maxw,maxh,sw,sh:longint;var dw,dh:longint);//20feb2025: tweaked, 29jul2016
procedure low__scale(maxw,maxh,sw,sh:integer;var dw,dh:integer);//20feb2025: tweaked
procedure low__scalecrop(maxw,maxh,sw,sh:integer;var dw,dh:integer);//20feb2025: fixed

function low__cornerMaxwidth:longint;//used by some patch systems to work around corner restrictions such as "statusbar.cellpert.round/square" - 07ul2021
function low__cornersolid(xdynamicCorners:boolean;var a:twinrect;amin,ay,xmin,xmax,xroundstyle:longint;xround:boolean;var lx,rx:longint):boolean;//29mar2021
function misv(s:tobject):boolean;//image is valid
function misb(s:tobject):longint;//get image bits
procedure missetb(s:tobject;sbits:longint);
function missetb2(s:tobject;sbits:longint):boolean;//12feb2022
function misw(s:tobject):longint;//get image width
function mish(s:tobject):longint;//get image height
function miscw(s:tobject):longint;//cell width
function misch(s:tobject):longint;//cell height
function miscc(s:tobject):longint;//cell count
function mis__nextcell(s:tobject;var sitemindex:longint;var stimer:comp):boolean;
function misf(s:tobject):longint;//color format
//.animation information
function misonecell(s:tobject):boolean;//26apr2022
function miscells(s:tobject;var sbits,sw,sh,scellcount,scellw,scellh,sdelay:longint;var shasai:boolean;var stransparent:boolean):boolean;//16dec2024, 27jul2021
function miscell(s:tobject;sindex:longint;var scellarea:twinrect):boolean;
function miscell2(s:tobject;sindex:longint):twinrect;
function miscellarea(s:tobject;sindex:longint):twinrect;
function mishasai(s:tobject):boolean;
function misaiclear2(s:tobject):boolean;
function misaiclear(var x:tanimationinformation):boolean;
function misai(s:tobject):panimationinformation;
function low__aicopy(var s,d:tanimationinformation):boolean;
function misaicopy(s,d:tobject):boolean;
function misimg(dbits,dw,dh:longint):tbasicimage;
function misimg8(dw,dh:longint):tbasicimage;//26jan2021
function misimg24(dw,dh:longint):tbasicimage;
function misimg32(dw,dh:longint):tbasicimage;

function misraw(dbits,dw,dh:longint):trawimage;
function misraw8(dw,dh:longint):trawimage;
function misraw24(dw,dh:longint):trawimage;
function misraw32(dw,dh:longint):trawimage;

function miswin(dbits,dw,dh:longint):twinbmp;
function miswin8(dw,dh:longint):twinbmp;
function miswin24(dw,dh:longint):twinbmp;
function miswin32(dw,dh:longint):twinbmp;

//.size image
function misatleast(s:tobject;dw,dh:longint):boolean;//26jul2021
function missize(s:tobject;dw,dh:longint):boolean;
function missize2(s:tobject;dw,dh:longint;xoverridelock:boolean):boolean;
//.area
function misrect(x,y,x2,y2:longint):twinrect;
function misarea(s:tobject):twinrect;//get image area (0,0,w-1,h-1)
//.check image and get basic imformation
function miscopy(s,d:tobject):boolean;//27dec2024, 12feb2022
function misokex(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
function misok(s:tobject;var sbits,sw,sh:longint):boolean;
function misokk(s:tobject):boolean;
function misokai(s:tobject;var sbits,sw,sh:longint):boolean;
function misokaii(s:tobject):boolean;
function misok8(s:tobject;var sw,sh:longint):boolean;
function misokai8(s:tobject;var sw,sh:longint):boolean;
function misok24(s:tobject;var sw,sh:longint):boolean;
function misok32(s:tobject;var sw,sh:longint):boolean;
function misokk24(s:tobject):boolean;
function misokai24(s:tobject;var sw,sh:longint):boolean;
function misok824(s:tobject;var sbits,sw,sh:longint):boolean;
function misok82432(s:tobject;var sbits,sw,sh:longint):boolean;
function misok2432(s:tobject;var sbits,sw,sh:longint):boolean;//01may2025
function misokk824(s:tobject):boolean;
function misokk82432(s:tobject):boolean;
function misokai824(s:tobject;var sbits,sw,sh:longint):boolean;

//.get image information
function misinfo(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
function misinfo2432(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
function misinfo82432(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
function misinfo8162432(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
function misinfo824(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
//.get image scan rows (all rows = for full height of image)
function misrows8(s:tobject;var xout:pcolorrows8):boolean;
function misrows16(s:tobject;var xout:pcolorrows16):boolean;
function misrows24(s:tobject;var xout:pcolorrows24):boolean;
function misrows32(s:tobject;var xout:pcolorrows32):boolean;
function misrows82432(s:tobject;var xout8:pcolorrows8;var xout24:pcolorrows24;var xout32:pcolorrows32):boolean;//26jan2021
//.get image scan row (just one row)
function misscan(s:tobject;sy:longint):pointer;//21jun2024
function misscan82432(s:tobject;sy:longint;var sr8:pcolorrow8;var sr24:pcolorrow24;var sr32:pcolorrow32):boolean;//26jan2021
function misscan8(s:tobject;sy:longint;var sr8:pcolorrow8):boolean;//26jan2021
function misscan16(s:tobject;sy:longint;var sr16:pcolorrow16):boolean;//03aug2024
function misscan24(s:tobject;sy:longint;var sr24:pcolorrow24):boolean;//26jan2021
function misscan32(s:tobject;sy:longint;var sr32:pcolorrow32):boolean;//26jan2021
function misscan96(s:tobject;sy:longint;var sr96:pcolorrow96):boolean;//03aug2024
function misscan2432(s:tobject;sy:longint;var sr24:pcolorrow24;var sr32:pcolorrow32):boolean;//26jan2021
function misscan824(s:tobject;sy:longint;var sr8:pcolorrow8;var sr24:pcolorrow24):boolean;//26jan2021
function misscan832(s:tobject;sy:longint;var sr8:pcolorrow8;var sr32:pcolorrow32):boolean;//14feb2022
//.get and set image pixel
function mispixel8VAL(s:tobject;sy,sx:longint):byte;
function mispixel8(s:tobject;sy,sx:longint):tcolor8;
function mispixel24VAL(s:tobject;sy,sx:longint):longint;
function mispixel24(s:tobject;sy,sx:longint):tcolor24;
function mispixel32VAL(s:tobject;sy,sx:longint):longint;
function mispixel32(s:tobject;sy,sx:longint):tcolor32;
function missetpixel32VAL(s:tobject;sy,sx,xval:longint):boolean;
function missetpixel32(s:tobject;sy,sx:longint;xval:tcolor32):boolean;
//.count image colors
function mis__countcolors257(s:tobject):longint;//limited color counter -> counts up to 257 colors - 14may2025
function misfindunusedcolor(i:tobject):longint;//23mar2025
function miscountcolors(i:tobject):longint;//full color count - uses dynamic memory (2mb) - 15OCT2009
function miscountcolors2(da_clip:twinrect;i,xsel:tobject):longint;//full color count - uses dynamic memory (2mb) - 19sep2018, 15OCT2009
function miscountcolors3(da_clip:twinrect;i,xsel:tobject;var xcolorcount,xmaskcount:longint):boolean;//full color count - uses dynamic memory (2mb) - 19sep2018, 15OCT2009
function miscountcolors4(da_clip:twinrect;i,xsel:tobject;var xcolorcount,xmaskcount:longint;var xunusedcolor:longint;xfindunusedcolor:boolean):boolean;//full color count - uses dynamic memory (2mb) - 23mar2025: findunusedcolor option added, 19sep2018, 15OCT2009
//.copy an area of pixels from one image to another - full 32bit RGBA support - 15feb2022
function miscopyarea32(ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject):boolean;//can copy ALL 32bits of color
function miscopyarea321(da,sa:twinrect;d,s:tobject):boolean;//can copy ALL 32bits of color
function miscopyarea322(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xscroll,yscroll:longint):boolean;//can copy ALL 32bits of color
function miscopyarea323(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xscroll,yscroll:longint;xmix32:boolean):boolean;//18nov2024: xmix32 mixes alpha colors into a lesser bit depth image e.g. drawing a 32 bit image onto a 24 bit one, can copy ALL 32bits of color

function mis__colormatrixpixel24(x,y,w,h:longint):tcolor24;
function mis__colormatrixpixel32(x,y,w,h:longint;a:byte):tcolor32;//matches "ldm()" exactly for color reproduction - 18feb2025: tweaked, 02feb2025
function mis__copyfast82432(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject):boolean;//09jan2025 - barebones pixel copier
function mis__copyfast2432MASK(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xmask,xbackmask:tmask8;xmaskval,xpower255:longint):boolean;//30jan2025, 18nov2024: xmix32 mixes alpha colors into a lesser bit depth image e.g. drawing a 32 bit image onto a 24 bit one, can copy ALL 32bits of color
//.used for an "average" scaling down of an image -> retains ratio and relative position of pixels in final image
function mis__copyAVE82432(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;dsmoothresampling:boolean):boolean;//06jun2025, 09may2025 - barebones "average" pixel copier/resampler

//.transparent color support
function mistranscol(s:tobject;stranscolORstyle:longint;senable:boolean):longint;
function misfindtranscol82432(s:tobject;stranscol:longint):longint;
function misfindtranscol82432ex(s:tobject;stranscol:longint;var tr,tg,tb:longint):boolean;//25jan2025: clBotLeft
function mislimitcolors82432(x:tobject;xtranscolor,colorlimit:longint;fast:boolean;var a:array of tcolor24;var acount:longint;var e:string):boolean;//01aug2021, 15SEP2007
function mislimitcolors82432ex(x:tobject;sx,xcellw,xtranscolor,colorlimit:longint;fast,xreducetofit:boolean;var a:array of tcolor24;var acount:longint;var e:string):boolean;//25dec2022, 01aug2021, 15SEP2007

//.other
function degtorad2(deg:extended):extended;//20OCT2009
function miscurveAirbrush2(var x:array of longint;xcount,valmin,valmax:longint;xflip,yflip:boolean):boolean;//20jan2021, 29jul2016

function miscls(s:tobject;xcolor:longint):boolean;
function misclsarea(s:tobject;sarea:twinrect;xcolor:longint):boolean;
function misclsarea2(s:tobject;sarea:twinrect;xcolor,xcolor2:longint):boolean;
function misclsarea3(s:tobject;sarea:twinrect;xcolor,xcolor2,xalpha,xalpha2:longint):boolean;
function misscreenresin248K:longint;//returns 2(K), 4(K) or 8(K) - 14mar2021

//.special
function mis__drawdigits(s:tobject;dcliparea:twinrect;dx,dy,dfontsize,dcolor:longint;x:string;xbold,xdraw:boolean;var dwidth,dheight:longint):boolean;
function mis__drawdigits2(s:tobject;dcliparea:twinrect;dx,dy,dfontsize,dcolor:longint;dheightscale:extended;x:string;xbold,xdraw:boolean;var dwidth,dheight:longint):boolean;

//.io - 25jul2024
function mis__format(xdata:pobject;var xformat:string;var xbase64:boolean):boolean;//26jul2024: created to handle tstr8 and tstr9
function mis__clear(s:tobject):boolean;
function mis__copy(s,d:tobject):boolean;
function mis__browsersupports(dformat:string):boolean;//22feb2025
function mis__fixemptymask(s:tobject):boolean;//22feb2025
procedure mis__nocells(s:tobject);
procedure mis__calccells(s:tobject);
procedure mis__calccells2(s:tobject;var xdelay,xcount,xcellwidth,xcellheight:longint);
function mis__nowhite_noblack(s:tobject):boolean;//23mar2025
function mis__canarea(s:tobject;sa:twinrect;var sarea:twinrect):boolean;

function mis__hasai(s:tobject):boolean;
function mis__ai(s:tobject):panimationinformation;
function mis__onecell(s:tobject):boolean;//06aug2024, 26apr2022

function mis__resizable(s:tobject):boolean;
function mis__retaindataonresize(s:tobject):boolean;//26jul2024: same as "mis__resizable()"

function mis__rowsize4(ximagewidth,xbitsPERpixel:longint):longint;//rounds to nearest 4 bytes - 27may2025
function mis__cls(s:tobject;r,g,b,a:byte):boolean;//04aug2024
function mis__cls2(s:tobject;sa:twinrect;r,g,b,a:byte):boolean;//04aug2024
function mis__cls3(s:tobject;sa:twinrect;scolor32:tcolor32):boolean;//29jan2025
function mis__cls8(s:tobject;a:byte):boolean;//04aug2024
function mis__cls82(s:tobject;sa:twinrect;a:byte):boolean;//04aug2024

function mis__mirror82432(x:tobject):boolean;//left-right - 08may2025
function mis__flip82432(x:tobject):boolean;//up-down - 08may2025
function mis__rotate82432(x:tobject;xangle:longint):boolean;//-90, 90, -180, 180, -270, or 270 deg - 09may2025

function mis__findBPP(s:tobject):longint;//scans image to determine the actual BPP required

function mis__tofile(s:tobject;dfilename,dformat:string;var e:string):boolean;//09jul2021
function mis__tofile2(s:tobject;dfilename,dformat,daction:string;var e:string):boolean;//09jul2021
function mis__tofile3(s:tobject;dfilename,dformat:string;var daction,e:string):boolean;//26dec2024, 09jul2021

function mis__fromfile(s:tobject;sfilename:string;var e:string):boolean;//09jul2021
function mis__fromfile2(s:tobject;sfilename:string;sbuffer:boolean;var e:string):boolean;//09jul2021

function mis__todata(s:tobject;sdata:pobject;dformat:string;var e:string):boolean;//25jul2024
function mis__todata2(s:tobject;sdata:pobject;dformat,daction:string;var e:string):boolean;//25jul2024
function mis__todata3(s:tobject;sdata:pobject;dformat:string;var daction,e:string):boolean;//19feb2025, 14dec2024: ia_nonAnimatedFormatsSaveImageStrip, 25jul2024

function mis__fromadata(s:tobject;const xdata:array of byte;var e:string):boolean;//05feb2025
function mis__fromdata(s:tobject;sdata:pobject;var e:string):boolean;//25jul2024
function mis__fromdata2(s:tobject;sdata:pobject;sbuffer:boolean;var e:string):boolean;//06jun2025, 25jul2024
function mis__fromarray(s:tobject;const xdata:array of byte;var e:string):boolean;//01may2025, 02jun2020

function miscopyareaxx(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xpower255,xtrans,xtc:longint;xoptions:currency):boolean;//05sep2017, 25jul2017
function miscopyareaxx1(ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject):boolean;//01jun2019
function miscopyareaxx1A(ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xusealpha:boolean):boolean;//support 32bit alpha channel - 27jan2021
function miscopyareaxx1B(ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xpower255:longint;xusealpha:boolean):boolean;//support 32bit alpha channel - 27jan2021
function miscopyareaxx2(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint):boolean;//27sep2017, 26sep2017, 25sep2017, 25jul2017
function miscopyareaxx3(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,sm:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint):boolean;//27sep2017, 26sep2017, 25sep2017, 25jul2017
function miscopyareaxx3b(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint):boolean;//27sep2017, 26sep2017, 25sep2017, 25jul2017
function miscopyareaxx4(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,sm:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8):boolean;//22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
function miscopyareaxx5(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8):boolean;//15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
function miscopyareaxx6(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8):boolean;//32bit support - 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
function miscopyareaxx7(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8):boolean;//32bit alpha channel support - 26jan2021, 30aug2020, 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
function miscopyareaxx8(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8;xusealpha:boolean):boolean;//32bit alpha channel support - 29jan2021, 27jan2021, 30aug2020, 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
function misoptions(xinvert,xgrey,xsepia,xnoise:boolean):currency;
function miscopyareaxx9(xcolorise1,xcolorise2:longint;da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8;xusealpha:boolean):boolean;//xinvert put last for better results - 05jun2021, colorise - 27mar2021, "round()" instead of "trunc()" - 16mar2021, dsysinfo support - 10mar2021, 32bit alpha channel support - 29jan2021, 27jan2021, 30aug2020, 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
function miscopyareaxx91(xcolorise1,xcolorise2:longint;da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask,dbackmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8;xusealpha:boolean):boolean;//04dec2024
function miscopyareaxx10(xcolorise1,xcolorise2:longint;da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask,dbackmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc,xwriteShadesofcolor:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8;xusealpha:boolean):boolean;//xinvert put last for better results - 05jun2021, "round()" instead of "trunc()" - 16mar2021, dsysinfo support - 10mar2021, 32bit alpha channel support - 29jan2021, 27jan2021, 30aug2020, 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
function misformat(xdata:tstr8;var xformat:string;var xbase64:boolean):boolean;


//extended graphics procs ------------------------------------------------------
function miscellsFPS10(s:tobject;var sbits,sw,sh,scellcount,scellw,scellh,sfps10:longint;var shasai:boolean;var stransparent:boolean):boolean;//27jul2021
function mismove82432(s:tobject;xmove,ymove:longint):boolean;//19jun2021
function mismove82432b(s:tobject;sa:twinrect;xmove,ymove:longint):boolean;//18nov2023, 19jun2021
function mismove82432c(s:tobject;sa:twinrect;xmove,ymove:longint;xdestructive:boolean):boolean;//18nov2023, 19jun2021
function mismatch82432(s,d:tobject;xtol,xfailrate:longint):boolean;//10jul2021
function mismatcharea82432(s,d:tobject;sa,da:twinrect;xtol,xfailrate:longint):boolean;//10jul2021
function misclean(s:tobject;scol,stol:longint):boolean;//19sep2022
function miscopyarea(d,s:hdc;a:twinrect):boolean;
function miscopyarea2(d,s:hdc;da,sa:twinrect):boolean;
function miscopypixels(var drows,srows:pcolorrows8;xbits,xw,xh:longint):boolean;
function miscursorpos:tpoint;
function misempty(s:tobject):boolean;
function misbytes(s:tobject):comp;
function misbytes32(s:tobject):longint;
function misblur82432(s:tobject):boolean;//03sep2021
function misblur82432b(s:tobject;xwraprange:boolean;xpower255,xtranscol:longint):boolean;//11sep2021, 03sep2021
function misblur82432c(s:tobject;scliparea:twinrect;xwraprange:boolean;xpower255,xtranscol:longint):boolean;//17may2022 - cell-based clipping, 27apr2022, 11sep2021, 03sep2021
function misblur82432d(s:tobject;scliparea:twinrect;xwraprange:boolean;xpower255,xtranscol,xstage:longint):boolean;//30dec2022 - stage support (-1 to 2), 17may2022 - cell-based clipping, 27apr2022, 11sep2021, 03sep2021
function misIconArt82432(s,s2:tobject;xzoom,xbackcolor,xtranscolor:longint;xpadding:boolean):boolean;//17sep2022 - fixed integer overflow error, 27apr2022
function miscrop82432(s:tobject):boolean;
function miscrop82432b(s:tobject;t32:tcolor32;var l,t,r,b:longint;xcalonly,xusealpha,xretainT32:boolean):boolean;//21jun20221
//.frame "universal" drawer
function misframe82432(s:tobject;da_cliparea,xouterarea:twinrect;xautoouterarea:boolean;var slist:array of longint;scount:longint;var e:string):boolean;//28jan2021
function misframe82432ex(s:tobject;da_cliparea,xouterarea:twinrect;xautoouterarea:boolean;var slist:array of longint;scount:longint;var e:string):boolean;//28jan2021
procedure low__framecols(xback,xframe,xframe2:longint;var xminsize,xcol1,xcol2:longint);//24feb2022
function low__frameset(var xpos:longint;xdata:tstr8;var sremsize:longint;sframesize,scolor,scolor2:longint;var dminsize,dsize,dcolor,dcolor2:longint):boolean;
//.sparkle procs
procedure sparkle__fill(xrichlevel:longint);
function sparkle__start:longint;
procedure sparkle__stop(xpos:longint);
function sparkle__uniquestart:longint;


//icon procs -------------------------------------------------------------------
type
  {icons AND cursors}
   pcursororicon=^tcursororicon;
   tcursororicon=packed record
     Reserved:word;
     wtype:word;//0,1 or 2
     count:word;
   end;
   piconrec=^ticonrec;
   ticonrec=packed record
     width:byte;
     height:byte;
     colors:word;
     reserved1:word;
     reserved2:word;
     dibsize:longint;
     diboffset:longint;
   end;
   panirec=^tanirec;
   tanirec=packed record
     cbSizeOf:dword;// Num bytes in AniHeader (36 bytes)
     cFrames:dword;// Number of unique Icons in this cursor
     cSteps:dword;// Number of Blits before the animation cycles
     cx:dword;// reserved, must be zero.
     cy:dword;// reserved, must be zero.
     cBitCount:dword;// reserved, must be zero.
     cPlanes:dword;// reserved, must be zero.
     JifRate:dword;//Note: 1xJiffy=1/60s=16.666ms - Default Jiffies (1/60th of a second) if rate chunk not present.
     flags:dword;// Animation Flag (see AF_ constants) - #define AF_ICON =3D 0x0001L // Windows format icon/cursor animation
   end;

function low__findbpp82432(i:tobject;iarea:twinrect;imask32:boolean):longint;//limited color count 07feb2022, 19jan2021, 21-SEP-2004
function low__palfind24(var a:array of tcolor24;acount:longint;var z:tcolor24):byte;
function low__icosizes(x:longint):longint;//18JAN2012, 25APR2011
//.1-32bit using transparent color - old/original tech
function low__toico(s:tobject;dcursor:boolean;dsize,dBPP,dtranscol,dfeather:longint;dtransframe:boolean;dhotX,dhotY:longint;xdata:tstr8;var e:string):boolean;//handles 1-32 bpp icons - 03jan2019, 14mar2015, 16JAN2012
function low__toani(s:tobject;slist:tfindlistimage;dsize,dBPP,dtranscolor,dfeather:longint;dtransframe:boolean;ddelay,dhotX,dhotY:longint;xdata:tstr8;var e:string):boolean;//07aug2021 (disabled repeat checker as it breaks the ANI file!), 24JAN2012
//.1-32bit using mask - new/updated tech - 15feb2022
function low__fromico32(d:tobject;sdata:tstr8;dsize:longint;xuse32:boolean;var e:string):boolean;//handles 1-32 bpp icons - 26JAN2012
function low__fromico322(d:tobject;sdata:pobject;dsize:longint;xuse32:boolean;var e:string):boolean;//supports tstr8/9, handles 1-32 bpp icons - 26JAN2012

function low__fromani32(d:tobject;sdata:tstr8;dsize:longint;xuse32:boolean;var e:string):boolean;//04dec2024: fixed stack overflow, handles 1-32 bpp animated icons - 23may2022, 26JAN2012
function low__fromani322(d:tobject;sdata:pobject;dsize:longint;xuse32:boolean;var e:string):boolean;//handles 1-32 bpp animated icons - 23may2022, 26JAN2012

function low__toico32(s:tobject;dcursor,dpng:boolean;dsize,dBPP,dhotX,dhotY:longint;var xouthotX,xouthotY,xoutBPP:longint;xdata:tstr8;var e:string):boolean;//handles 1-32 bpp icons - 13may2025: 32bit transparency updated for Win98, 03jan2019, 14mar2015, 16JAN2012
function low__toani32(s:tobject;slist:tfindlistimage;dformat:string;dpng:boolean;dsize:longint;ddelay,dhotX,dhotY:longint;xonehotspot:boolean;xdata:tstr8;var e:string):boolean;//15feb2022
function low__toani32b(s:tobject;slist:tfindlistimage;dformat:string;dpng:boolean;dsize,dForceBPP:longint;ddelay,dhotX,dhotY:longint;xonehotspot:boolean;var xoutbpp:longint;xdata:tstr8;var e:string):boolean;//15feb2022


//ref procs --------------------------------------------------------------------
function ref_blankX(x:tstr8;xlabel:string;xsize:longint):boolean;
function ref_blank1000(x:tstr8;xlabel:string):boolean;
function ref_valid(x:tstr8):boolean;
function ref_id(x:tstr8):longint;
procedure ref_setid(x:tstr8;y:longint);
procedure ref_incid(x:tstr8);
function ref_count(x:tstr8):longint;
procedure ref_setcount(x:tstr8;xcount:longint);
function ref_use(x:tstr8):boolean;
procedure ref_setuse(x:tstr8;y:boolean);
function ref_style(x:tstr8):byte;
procedure ref_setstyle(x:tstr8;y:byte);
function ref_stylelabel(x:tstr8):string;
function ref_stylelabel2(x:longint):string;
function ref_stylelabel3(x:longint;var xcount:longint):string;
function ref_stylecount:longint;//slow
function ref_proc(xstyle:longint;xval,xmin,xmax,xref:extended;xpos,xcount:longint):extended;
function ref_label(x:tstr8):string;
procedure ref_setlabel(x:tstr8;y:string);
procedure ref_paste(xref,xnew:tstr8;xfit:boolean);
procedure ref_paste2(xref,xnew:tstr8;xfit,xretainlabel:boolean);
procedure ref_smooth(x:tstr8;xmore:boolean);
procedure ref_texture(x:tstr8;xmore:boolean);
procedure ref_mirror(x:tstr8);
procedure ref_flip(x:tstr8);
procedure ref_shiftx(x:tstr8;xby:longint);
procedure ref_shifty(x:tstr8;xby:extended);
procedure ref_zoom(x:tstr8;xby:extended);
function ref_val(x:tstr8;xindex:longint):extended;//raw only, no style
function ref_valex(x:tstr8;xindex:longint;xloop:boolean):extended;//raw only, no style
function ref_val2(x:tstr8;xindex,xval,xmin,xmax:longint):longint;//raw only, no style
function ref_val2ex(x:tstr8;xindex,xval,xmin,xmax:longint;xloop:boolean):longint;//raw only, no style
function ref_val32(x:tstr8;xindex,xval,xmin,xmax:longint):longint;
function ref_val0255(x:tstr8;xval:longint):longint;
function ref_val255255(x:tstr8;xval:longint):longint;
function ref_valrange32(x:tstr8;xval,xmin,xmax,zpos:longint;var zmin,zmax,zoff,zcount:longint):longint;
function ref_val80(x:tstr8;xindex:longint;xval,xmin,xmax:extended):extended;
function ref_valrange80(x:tstr8;xval,xmin,xmax:extended;zpos:longint;var zmin,zmax,zoff,zcount:longint):extended;
procedure ref_setval(x:tstr8;xindex:longint;y:extended);
procedure ref_setall(x:tstr8;y:extended);


//pixel modifier procs ---------------------------------------------------------
procedure fbNoise3(var r,g,b:byte);//faster - 29jul2017
procedure fbInvert(var r,g,b:byte);
procedure fbGreyscale(var r,g,b:byte);
procedure fbSepia(var r,g,b:byte);


//png procs --------------------------------------------------------------------
function png__todata(s:tobject;d:pobject;var e:string):boolean;
function png__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function png__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//29may2025, 06may2025, OK=27jan2021, 20jan2021
function png__todata4(s:tobject;d:pobject;dbits:longint;var daction,e:string):boolean;//29may2025, 06may2025, OK=27jan2021, 20jan2021

function png__fromdata(s:tobject;d:pobject;var e:string):boolean;

function png32__todata(s:tobject;d:pobject):boolean;
function png24__todata(s:tobject;d:pobject):boolean;//no transparency support
function png8__todata(s:tobject;d:pobject):boolean;


//tea procs (text picture) -----------------------------------------------------
//draw-on-the-fly (direct from data buffer) GUI image
function tea__info(var adata:tlistptr;xsyszoom:boolean;var aw,ah,aSOD,aversion,aval1,aval2:longint;var atransparent,asyscolors:boolean):boolean;
function tea__info1(xtep:longint;xsyszoom:boolean;var aw,ah,aSOD,aversion,aval1,aval2:longint;var atransparent,asyscolors:boolean):boolean;//17jun2025, 25may2025
function tea__info2(adata:tstr8;xsyszoom:boolean;var aw,ah,aSOD,aversion,aval1,aval2:longint;var atransparent,asyscolors:boolean):boolean;
function tea__info3(adata:pobject;xsyszoom:boolean;var aw,ah,aSOD,aversion,aval1,aval2:longint;var atransparent,asyscolors:boolean):boolean;//18nov2024

function tea__draw(xcolorise,xsyszoom:boolean;dx,dy,dc,dc2:longint;xarea,xarea2:twinrect;d:tobject;xtea:tlistptr;xfocus,xgrey,xround:boolean;xroundstyle:longint):boolean;//curved corner support - 07may2020, 09apr2020, 29mar2020
function tea__draw2(xcolorise,xsyszoom:boolean;dx,dy,dc,dc2:longint;xarea,xarea2:twinrect;dbits,dw,dh:longint;drows24:pcolorrows24;drows32:pcolorrows32;xmask,xbackmask:tmask8;xmaskval:longint;xtea:tlistptr;xfocus,xgrey,xround:boolean;xroundstyle:longint):boolean;//04may2025: soft support, 04dec2024: background mask support, 02aug204: div 256 faster, curved corner support - 13may2020, 07may2020, 09apr2020, 29mar2020

function tea__TLpixel(xtea:tlistptr):longint;//top-left pixel of TEA image - 01aug2020
function tea__TLpixel2(xtea:tlistptr;var xw,xh,xcolor:longint):boolean;//top-left pixel of TEA image - 01aug2020
function tea__copy(xtea:tlistptr;d:tbasicimage;var xw,xh:longint):boolean;//01may2025, 12dec2024, 18nov2024, 23may2020
function tea__torawdata24(xtea:tlistptr;xdata:tstr8;var xw,xh:longint):boolean;
function tea__torawdata242(xtea:tlistptr;xdata:pobject;var xw,xh:longint):boolean;

function tea__fromdata(d:tobject;sdata:pobject;var xw,xh:longint):boolean;
function tea__fromdata32(d:tobject;sdata:pobject;var xw,xh:longint):boolean;
function tea__todata(x:tobject;xout:pobject;var e:string):boolean;
function tea__todata2(x:tobject;xtransparent,xsyscolors:boolean;xval1,xval2:longint;xout:pobject;var e:string):boolean;//07apr2021
function tea__todata32(x:tobject;xtransparent,xsyscolors:boolean;xval1,xval2:longint;xout:pobject;var e:string):boolean;//18nov2024


//ia procs ---------------------------------------------------------------------
//image action procs -> send and receive optional info from image procs
//.add to end
function ia__add(xactions,xnewaction:string):string;
function ia__addlist(xactions:string;xlistofnewactions:array of string):string;
function ia__sadd(xactions,xnewaction:string;xvals:array of string):string;//name+vals.string
function ia__iadd(xactions,xnewaction:string;xvals:array of longint):string;//name+vals.longint
function ia__iadd64(xactions,xnewaction:string;xvals:array of comp):string;//name+vals.longint

//.simplified list of per-image-format "action" options -> mainly for dialog window etc
procedure ia__useroptions(xinit,xget:boolean;ximgext:string;var xlistindex,xlistcount:longint;var xlabel,xhelp,xaction:string);
procedure ia__useroptions_suppress(xall:boolean;xformatmask:string);//use to disable (hide) certain format options in the save as dialog window - 21dec2024
procedure ia__useroptions_suppress_clear;

//.add at beginning
function ia__preadd(xactions,xnewaction:string):string;
function ia__spreadd(xactions,xnewaction:string;xvals:array of string):string;//name+vals(string)
function ia__ipreadd(xactions,xnewaction:string;xvals:array of longint):string;//name+vals(longint)
function ia__ipreadd64(xactions,xnewaction:string;xvals:array of comp):string;//name+vals(comp)

//find
function ia__ok(xactions,xfindname:string):boolean;//same as found
function ia__found(xactions,xfindname:string):boolean;

function ia__sfindval(xactions,xfindname:string;xvalindex:longint;xdefval:string;var xout:string):boolean;
function ia__ifindval(xactions,xfindname:string;xvalindex,xdefval:longint;var xout:longint):boolean;
function ia__ifindval64(xactions,xfindname:string;xvalindex:longint;xdefval:comp;var xout:comp):boolean;

function ia__sfindvalb(xactions,xfindname:string;xvalindex:longint;xdefval:string):string;
function ia__ifindvalb(xactions,xfindname:string;xvalindex,xdefval:longint):longint;
function ia__ifindval64b(xactions,xfindname:string;xvalindex:longint;xdefval:comp):comp;

function ia__sfind(xactions,xfindname:string;var xvals:array of string):boolean;
function ia__ifind(xactions,xfindname:string;var xvals:array of longint):boolean;
function ia__ifind64(xactions,xfindname:string;var xvals:array of comp):boolean;

function ia__find(xactions,xfindname:string;var xvals:array of string):boolean;


//img32 procs ------------------------------------------------------------------
//uncompressed image 32bit
function img32__fromdata(s:tobject;d:pobject;var e:string):boolean;
function img32__fromdata2(s:tobject;d:pobject;var scellwidth,scellheight,scellcount,sdelayms:longint;var e:string):boolean;
function img32__todata(s:tobject;d:pobject;var e:string):boolean;
function img32__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function img32__todata3(s:tobject;d:pobject;var daction,e:string):boolean;


//tj32 procs -------------------------------------------------------------------
//transparent jpeg 32bit
function tj32__fromdata(s:tobject;d:pobject;var e:string):boolean;
function tj32__fromdata2(s:tobject;d:pobject;var scellwidth,scellheight,scellcount,sdelayms:longint;var e:string):boolean;
function tj32__todata(s:tobject;d:pobject;var e:string):boolean;
function tj32__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function tj32__todata3(s:tobject;d:pobject;var daction,e:string):boolean;


//bmp procs --------------------------------------------------------------------
function bmp__todata(s:tobject;d:pobject;var e:string):boolean;
function bmp__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function bmp__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//14may2025
function bmp__pushdata(s,d:pobject):boolean;//pack data inside a bitmap image - 01may2025

function bmp__fromdata(d:tobject;s:pobject;var e:string):boolean;
function bmp__fromdata2(d:tobject;s:pobject;var xbits:longint;var e:string):boolean;

function bmpXX__todata(s:tobject;d:pobject;dbits:longint):boolean;//14may2025
function bmp32__todata(s:tobject;d:pobject):boolean;//15may2025
function bmp32__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//15may2025
function bmp32__todata3(s:tobject;d:pobject;dfullheader:boolean;dinfosize,dbits:longint):boolean;//11jun2025: dinfosize, 09jun2025, 28may2025, 15may2025
function bmp24__todata(s:tobject;d:pobject):boolean;//14may2025
function bmp24__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
function bmp16__todata(s:tobject;d:pobject):boolean;//14may2025
function bmp16__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
function bmp8__todata(s:tobject;d:pobject):boolean;//14may2025
function bmp8__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
function bmp4__todata(s:tobject;d:pobject):boolean;//14may2025
function bmp4__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
function bmp1__todata(s:tobject;d:pobject):boolean;//14may2025
function bmp1__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
function bmp1__todata3(s:tobject;d:pobject;dheaderlevel:longint):boolean;//27may2025, 14may2025

function bmp32__fromdata(d:tobject;s:pobject):boolean;//11jun2025: supports DIB +12b patch, 15may2025
function bmp32__fromdata2(d:tobject;s:pobject;sallow_dib_patch_12:boolean):boolean;//12jun2025: dib_patch_12 control, 11jun2025: supports DIB +12b patch, 15may2025
function bmp24__fromdata(d:tobject;s:pobject):boolean;//15may2025
function bmp16__fromdata(d:tobject;s:pobject):boolean;//15may2025
function bmp8__fromdata(d:tobject;s:pobject):boolean;//09jun2025: supports bi_rgb + bi_rle8 + bi_rle4, 15may2025
function bmp4__fromdata(d:tobject;s:pobject):boolean;//15may2025
function bmp1__fromdata(d:tobject;s:pobject):boolean;//15may2025


//dib procs --------------------------------------------------------------------
function dib__fromdata(s:tobject;d:pobject;var e:string):boolean;
function dib__fromdata2(s:tobject;d:pobject;var xoutbpp:longint;var e:string):boolean;

function dib__todata(s:tobject;d:pobject;var e:string):boolean;
function dib__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function dib__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//14may2025

function dibXX__todata(s:tobject;d:pobject;dbits:longint):boolean;//14may2025
function dib32__todata(s:tobject;d:pobject):boolean;//14may2025 - supports tstr8, tstr9
function dib24__todata(s:tobject;d:pobject):boolean;//14may2025 - supports tstr8, tstr9
function dib16__todata(s:tobject;d:pobject):boolean;//14may2025
function dib8__todata(s:tobject;d:pobject):boolean;//14may2025
function dib4__todata(s:tobject;d:pobject):boolean;//14may2025
function dib1__todata(s:tobject;d:pobject):boolean;//14may2025

function dib32__fromdata(d:tobject;s:pobject):boolean;//15may2025
function dib24__fromdata(d:tobject;s:pobject):boolean;//15may2025
function dib16__fromdata(d:tobject;s:pobject):boolean;//15may2025
function dib8__fromdata(d:tobject;s:pobject):boolean;//28may2025
function dib4__fromdata(d:tobject;s:pobject):boolean;//28may2025
function dib1__fromdata(d:tobject;s:pobject):boolean;//28may2025


//jpeg procs -------------------------------------------------------------------
function jpg__can:boolean;
function jpg__todata(s:tobject;d:pobject;var e:string):boolean;
function jpg__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function jpg__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//05dec2024, 24nov2024

function jpg__fromdata(s:tobject;d:pobject;var e:string):boolean;

//tga procs --------------------------------------------------------------------
function tga__todata(s:tobject;d:pobject;var e:string):boolean;
function tga__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function tga__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//20dec2024
function tga__fromdata(s:tobject;d:pobject;var e:string):boolean;

function tga32__todata(s:tobject;d:pobject):boolean;//29may2025
function tga24__todata(s:tobject;d:pobject):boolean;//29may2025
function tga8__todata(s:tobject;d:pobject):boolean;//29may2025


//ppm procs --------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxx//11111111111111111111
function ppm__todata(s:tobject;d:pobject;var e:string):boolean;
function ppm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function ppm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
function ppm__fromdata(s:tobject;d:pobject;var e:string):boolean;


//pgm procs --------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxx//222222222222222222222222222
function pgm__todata(s:tobject;d:pobject;var e:string):boolean;
function pgm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function pgm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
function pgm__fromdata(s:tobject;d:pobject;var e:string):boolean;


//pbm procs --------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxx//222222222222222222222222222
function pbm__todata(s:tobject;d:pobject;var e:string):boolean;
function pbm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function pbm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
function pbm__fromdata(s:tobject;d:pobject;var e:string):boolean;


//pnm procs --------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxx//333333333333333333333
function pnm__todata(s:tobject;d:pobject;var e:string):boolean;
function pnm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function pnm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
function pnm__fromdata(s:tobject;d:pobject;var e:string):boolean;


//xbm procs --------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxx//222222222222222222222222222
function xbm__todata(s:tobject;d:pobject;var e:string):boolean;
function xbm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function xbm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
function xbm__fromdata(s:tobject;d:pobject;var e:string):boolean;


//ico procs --------------------------------------------------------------------
function ico__todata(s:tobject;d:pobject;var e:string):boolean;//27may2025
function ico__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;//27may2025
function ico__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//19jun2025, 27may2025

function ico__fromdata(d:tobject;s:pobject;var e:string):boolean;

function icoXX__todata(s:tobject;d:pobject;dbits:longint):boolean;//27may2025
function ico32__todata(s:tobject;d:pobject):boolean;//16may2025
function ico32__todata2(s:tobject;d:pobject;dbits:longint):boolean;//27may2025
function ico32__todata3(s:tobject;d:pobject;dpng,dcursor:boolean;dhotX,dhotY,dbits:longint):boolean;//27may2025
function ico24__todata(s:tobject;d:pobject):boolean;//27may2025
function ico16__todata(s:tobject;d:pobject):boolean;//27may2025
function ico8__todata(s:tobject;d:pobject):boolean;//27may2025
function ico4__todata(s:tobject;d:pobject):boolean;//27may2025

function ico32__fromdata(s:tobject;d:pobject):boolean;//27may2025
function ico32__fromdata2(s:tobject;d:pobject;var dhotX,dhotY:longint):boolean;//08jun2025, 27may2025

//.support procs
function ico32__findhotspot(s:tobject;sw,sh:longint;var hx,hy:longint):boolean;
function bmp32__toicondata(s:tobject;d:pobject;dbits:longint):boolean;//27may2025
function bmp8__toicondata(s:tobject;d:pobject;var xcolorsused:longint):boolean;//27may2025
function bmp4__toicondata(s:tobject;d:pobject;var xcolorsused:longint):boolean;//27may2025
function bmp1__toicondata(s:tobject;d:pobject):boolean;//27may2025


//cur procs --------------------------------------------------------------------
function cur__todata(s:tobject;d:pobject;var e:string):boolean;
function cur__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function cur__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//27may2025

function cur__fromdata(d:tobject;s:pobject;var e:string):boolean;

function curXX__todata(s:tobject;d:pobject;dbits:longint):boolean;//27may2025
function curXX__todata2(s:tobject;d:pobject;dhotX,dhotY,dbits:longint):boolean;//27may2025
function cur32__todata(s:tobject;d:pobject):boolean;
function cur32__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
function cur24__todata(s:tobject;d:pobject):boolean;
function cur24__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
function cur16__todata(s:tobject;d:pobject):boolean;
function cur16__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
function cur8__todata(s:tobject;d:pobject):boolean;
function cur8__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
function cur4__todata(s:tobject;d:pobject):boolean;
function cur4__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;


//ani procs --------------------------------------------------------------------
function ani__todata(s:tobject;d:pobject;var e:string):boolean;
function ani__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
function ani__todata3(s:tobject;d:pobject;daction:string;dhotX,dhotY:longint;xonehotspot:boolean;var e:string):boolean;
function ani__todata4(s:tobject;slist:tfindlistimage;d:pobject;dformat,daction:string;dforceBPP,dsize:longint;dhotX,dhotY:longint;xonehotspot:boolean;var xoutbpp:longint;var xouttransparent:boolean;var e:string):boolean;
function ani__todata5(s:tobject;slist:tfindlistimage;d:pobject;dformat,daction:string;dforceBPP,dsize:longint;ddelay,dhotX,dhotY:longint;xonehotspot:boolean;var xoutbpp:longint;var xouttransparent:boolean;var e:string):boolean;


//gif procs --------------------------------------------------------------------
function gif__fromdata(ss:tobject;ds:pobject;var e:string):boolean;//06aug2024, 28jul2021, 20JAN2012, 22SEP2009
function gif__todata(s:tobject;ds:pobject;var e:string):boolean;//11SEP2007
function gif__todata2(s:tobject;ds:pobject;daction:string;var e:string):boolean;

//.gif support
function gif__start(gs:tobject;ds:pobject;dw,dh:longint;dloop:boolean):boolean;
function gif__addcell82432(gs:tobject;ds:pobject;c:tobject;cms:longint):boolean;//06aug2024: auto. optimises GIF data stream on-the-fly
function gif__stop(ds:pobject):boolean;

procedure gif__decompress(x:pobject);//26jul2024, 28jul2021, 11SEP2007
procedure gif__decompressex(var xlenpos1:longint;x,imgdata:pobject;_width,_height:longint;interlaced:boolean);//11SEP2007
function gif__compress(x:pobject;var e:string):boolean;//12SEP2007
function gif__compressex(x,imgdata:pobject;e:string):boolean;//12SEP2007


//mask procs -------------------------------------------------------------------
//alpha support for 32bit images (R,G,B,A*)
function mask__empty(s:tobject):boolean;
function mask__allTransparent(s:tobject):boolean;//indicates no pixel in mask is 255
function mask__hasTransparency32(s:tobject):boolean;//one or more alpha values are below 255 - 27may2025
function mask__hasTransparency322(s:tobject;var xsimple0255:boolean):boolean;//one or more alpha values are below 255 - 27may2025
function mask__range(s:tobject;var xmin,xmax:longint):boolean;//15feb2022
function mask__range2(s:tobject;var v0,v255,vother:boolean;var xmin,xmax:longint):boolean;//15feb2022
function mask__maxave(s:tobject):longint;//0..255
function mask__setval(s:tobject;xval:longint):boolean;//replaces "missetAlphaval32()"
function mask__setopacity(s:tobject;xopacity255:longint):boolean;//06jun2021
function mask__multiple(s:tobject;xby:currency):boolean;//18sep2022
function mask__copy(s,d:tobject):boolean;//15feb2022 - was "missetAlpha32(()"
function mask__copy2(s,d:tobject;stranscol:longint):boolean;
function mask__copy3(s,d:tobject;stranscol,sremove:longint):boolean;
function mask__copymin(s,d:tobject):boolean;//15feb2022
function mask__forcesimple0255(s:tobject):boolean;//21nov2024
function mask__makesimple0255(s:tobject;tc:longint):boolean;//21nov2024
function mask__feather(s,d:tobject;sfeather,stranscol:longint;var xouttranscol:longint):boolean;//20jan2021
function mask__feather2(s,d:tobject;sfeather,stranscol:longint;stransframe:boolean;var xouttranscol:longint):boolean;//15feb2022, 18jun2021, 08jun2021, 20jan2021 - was "misalpha82432b()"

function mask__maketrans32(s:tobject;scolor:longint):boolean;//directly edit image's alpha mask
function mask__maketrans322(s:tobject;scolor:longint;var achangecount:longint):boolean;//directly edit image's alpha mask
function mask__maketrans323(s:tobject;scolor:longint;smaskval:byte;var achangecount:longint):boolean;//06aug2024: directly edit image's alpha mask

function mask__fromdata(s:tobject;d:pobject):boolean;
function mask__fromdata2(s:tobject;d:pobject;donshortfall:longint;dforcetoimage:boolean):boolean;

function mask__todata(s:tobject;d:pobject):boolean;
function mask__todata2(s:tobject;d:pobject;stranscol:longint):boolean;


//color procs ------------------------------------------------------------------
//.conversion
function int24__rgba0(x24__or__syscolor:longint):longint;
function int__c8(x:longint):tcolor8;
function int__c24(x:longint):tcolor24;
function int__c32(x:longint):tcolor32;
function inta__c32(x:longint;a:byte):tcolor32;
function inta__int(x:longint;a:byte):longint;
function c8__int(x:tcolor8):longint;
function c24__int(x:tcolor24):longint;
function c24a0__int(x:tcolor24):longint;
function c32__int(x:tcolor32):longint;
function c8a__int(x:tcolor8;a:byte):longint;
function c24a__int(x:tcolor24;a:byte):longint;
function rgba0__int(r,g,b:byte):longint;
function rgba__int(r,g,b,a:byte):longint;
function ggga0__int(r:byte):longint;
function ggga__int(r,a:byte):longint;
function rgb__c24(r,g,b:byte):tcolor24;
function rgba0__c32(r,g,b:byte):tcolor32;
function rgba255__c32(r,g,b:byte):tcolor32;
function rgba__c32(r,g,b,a:byte):tcolor32;
function c24a0__c32(x:tcolor24):tcolor32;
function c24a255__c32(x:tcolor24):tcolor32;
function c24a__c32(x:tcolor24;a:byte):tcolor32;
function c32__c24(x:tcolor32):tcolor24;
function c32__c8(x:tcolor32):tcolor8;
function c24__c8(x:tcolor24):tcolor8;
function ca__c8(x:tcolor32):tcolor8;
procedure c32__irgb(var x:tcolor32);//invert RGB
procedure c32__irgba(var x:tcolor32);//invert RGBA
procedure c32__ia(var x:tcolor32);//invert A
procedure c24__irgb(var x:tcolor24);//invert RGB
procedure c8__i(var x:tcolor8);//invert

//.match
function c24__match(s,d:tcolor24):boolean;
function c32__match(s,d:tcolor32):boolean;
function c32_c24__match(s:tcolor32;d:tcolor24):boolean;

//.greyscale
function c24__lum(x:tcolor24):byte;
function c32__lum(x:tcolor32):byte;
procedure c24__greyscale(var x:tcolor24);
function c24__greyscale2(var x:tcolor24):byte;
function c24__greyscale2b(x:tcolor24):byte;
function int__greyscale(x:longint):longint;
function inta__greyscale(x:longint;a:byte):longint;
function int__greyscale_ave(x:longint):longint;
function int__greyscale_c8(x:longint):tcolor8;//03feb2025, 18nov2023

//.invert
function int__invert(x:longint;var xout:longint):boolean;
function int__invertb(x:longint):longint;
function int__invert2(x:longint;xgreycorrection:boolean;var xout:longint):boolean;
function int__invert2b(x:longint;xgreycorrection:boolean):longint;

//.brightness
function int__brightness(x:longint;var xout:longint):boolean;
function int__brightnessb(x:longint):longint;
function int__brightness_ave(x:longint;var xout:longint):boolean;
function int__brightness_aveb(x:longint):longint;
function int__setbrightness357(xcolor,xbrightness357:longint):longint;//18feb2025, 05feb2025

//.splicer
function c24__splice(xpert01:extended;s,d:tcolor24):tcolor24;//17may2022
function c32__splice(xpert01:extended;s,d:tcolor32):tcolor32;//06dec2023
function int__splice24(xpert01:extended;s,d:longint):longint;//13nov2022
function int__splice32(xpert01:extended;s,d:longint):longint;//13nov2022
function int__splice24_100(xpert100,s,d:longint):longint;
function int__splice32_100(xpert100,s,d:longint):longint;

//.color by name
function inta0__findcolor(xname:string):longint;
function inta__findcolor(xname:string;a:byte):longint;

//.color dodgers
function c24__nonwhite24(x:tcolor24):tcolor24;//make sure color is never white - 18feb2025: fixed
function c24a__nonwhite32(x:tcolor24;a:byte):tcolor32;//make sure color is never white - 18feb2025: fixed
function c24__nonblack24(x:tcolor24):tcolor24;//make sure color is never white - 18feb2025: fixed
function c24a__nonblack32(x:tcolor24;a:byte):tcolor32;//make sure color is never white - 18feb2025: fixed

//.color adjusters
function c24__focus24(x:tcolor24):tcolor24;
function c32__focus32(x:tcolor32):tcolor32;

//.hex6 output conversion -> output is: "rrggbb" or "#rrggbb"
function int__hex6(c:longint;xhash:boolean):string;
function c24__hex6(c24:tcolor24;xhash:boolean):string;//ultra-fast int->hex color converter - 15aug2019
function c32__hex6(c32:tcolor32;xhash:boolean):string;//ultra-fast int->hex color converter - 15aug2019

//.hex8 output conversion -> output is: "rrggbbaa" or "#rrggbbaa"
function inta__hex8(c:longint;a:byte;xhash:boolean):string;
function int__hex8(c:longint;xhash:boolean):string;
function c24a__hex8(c24:tcolor24;a:byte;xhash:boolean):string;//ultra-fast int->hex color converter - 22jul2021
function c32__hex8(c32:tcolor32;xhash:boolean):string;//ultra-fast int->hex color converter - 22jul2021

//.hex8 intput conversion -> input is: "simple color name" or "rgb" or "rgba" or "#rgb" or "#rgba" or "#rrggbb" or "#rrggbbaa"
function hex8__int(sx:string;xdefa:byte;xdef:longint):longint;//18feb2025: tweaked, 14feb2025: fixed, 03feb2025, 17nov2023, 27feb2021
function hex8__c24(sx:string;xdef:tcolor24):tcolor24;//18feb2025: fixed
function hex8__c32(sx:string;xdefa:byte;xdef:tcolor32):tcolor32;//18feb2025: fixed

//.color visibility and checkers  "low__dc()"
function c24__dif(xcolor24:tcolor24;xchangeby0255:longint):tcolor24;//differential color
procedure int__soft24(xcolor24:longint;var xoutHint,xoutSoft,xoutSoftRow,xoutSoftHover,xout0,xout1,xout2:longint);
function int__dif24(xcolor24,xchangeby0255:longint):longint;//differential color
function int__dif242(xcolor24,xchangeby0255:longint;xautoflip:boolean):longint;//differential color

function int__vis24(xforeground24,xbackground24,xseparation:longint):boolean;//color is visible
function c24__vis24(xforeground24,xbackground24:tcolor24;xseparation:longint):boolean;//color is visible

function int__makevis24(xforeground24,xbackground24,xseparation:longint):longint;//make color visible (foreground visible on background)
function c24__makevis24(xforeground24,xbackground24:tcolor24;xseparation:longint):tcolor24;//make color visible (foreground visible on background)

//.pixel processors
function ppBlend32(var s,snew:tcolor32):boolean;//color / pixel processor - 30nov2023
function ppBlendColor32(var s,snew:tcolor32):boolean;//color blending / pixel processor - 01dec2023
procedure ppMerge24(var d:tcolor24;snew:tcolor32);//25may2025
procedure ppMerge24FAST(var d:tcolor24;snew:tcolor32);//25may2025


//logic procs ------------------------------------------------------------------
function low__aorbimg(a,b:tbasicimage;xuseb:boolean):tbasicimage;//30nov2023


//canvas procs -----------------------------------------------------------------
function wincanvas__setfont(x:hdc;xfontname:string;xsharp,xbold:boolean;xsize,xcolor,xbackcolor:longint;var xoutfont,xoutbrush:hdc):boolean;
function wincanvas__textwidth(x:hdc;const xval:string):longint;
function wincanvas__textheight(x:hdc;const xval:string):longint;
function wincanvas__textextent(x:hdc;const xval:string):tpoint;
function wincanvas__textout(x:hdc;xtransparent:boolean;dx,dy:longint;const xval:string):boolean;
function wincanvas__textrect(x:hdc;xtransparent:boolean;xarea:twinrect;dx,dy:longint;const xval:string):boolean;


implementation

uses main {$ifdef gui},gossgui{$endif};


//start-stop procs -------------------------------------------------------------
procedure gossimg__start;
var
   v,p:longint;
   d:hdc;
begin
try
//check
if system_started then exit else system_started:=true;


//ref arrays -------------------------------------------------------------------
//.ref65025_div_255 - 06apr2017
for p:=0 to high(ref65025_div_255) do ref65025_div_255[p]:=p div 255;


//filter arrays ----------------------------------------------------------------
//.fb255
for p:=low(fb255) to high(fb255) do
begin
v:=p;
if (v<0) then v:=0 else if (v>255) then v:=255;
fb255[p]:=byte(v);
end;//p

//.fbwrap255
for p:=low(fbwrap255) to high(fbwrap255) do
begin
v:=p;
 repeat
 if (v>255) then dec(v,255)
 else if (v<0) then inc(v,255)
 until (v>=0) and (v<=255);
fbwrap255[p]:=byte(v);
end;//p


//temp support -----------------------------------------------------------------
//.temp buffer support
systmppos:=0;
for p:=0 to high(systmpstyle) do
begin
systmpstyle[p]:=0;//free
systmpid[p]:='';
systmptime[p]:=0;
systmpbmp[p]:=nil;
end;//p

//.temp int buffer support
sysintpos:=0;
for p:=0 to high(sysintstyle) do
begin
sysintstyle[p]:=0;//free
sysintid[p]:='';
sysinttime[p]:=0;
sysintobj[p]:=nil;
end;//p

//.temp byte buffer support
sysbytepos:=0;
for p:=0 to high(sysbytestyle) do
begin
sysbytestyle[p]:=0;//free
sysbyteid[p]:='';
sysbytetime[p]:=0;
sysbyteobj[p]:=nil;
end;//p

d:=0;
try
d:=win____GetDC(0);
if (d<>0) then
   begin
   system_screenlogpixels:=win____GetDeviceCaps(d,LOGPIXELSY);
   if (system_screenlogpixels<=0) then system_screenlogpixels:=96;
   end;
finally
win____ReleaseDC(0,d);
end;

except;end;
end;

procedure gossimg__stop;
var
   p:longint;
begin
try
//check
if not system_started then exit else system_started:=false;


//temp support -----------------------------------------------------------------
//.temp buffer support
for p:=0 to high(systmpstyle) do
begin
systmpstyle[p]:=2;//locked
freeobj(@systmpbmp[p]);
end;//p
//.temp int support
for p:=0 to high(sysintstyle) do
begin
sysintstyle[p]:=2;//locked
freeobj(@sysintobj[p]);
end;//p
//.temp byte support
for p:=0 to high(sysbytestyle) do
begin
sysbytestyle[p]:=2;//locked
freeobj(@sysbyteobj[p]);
end;//p

except;end;
end;

function gossimg__havebmp:boolean;//14may2025, 18aug2024
begin
result:=true;
end;

function gossimg__haveico:boolean;
begin
result:=true;
end;

function gossimg__havegif:boolean;
begin
result:=true;
end;

function gossimg__havejpg:boolean;
begin
{$ifdef jpeg}result:=true;{$else}result:=false;{$endif}
end;

function gossimg__havetga:boolean;//20feb2025
begin
result:=true;
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

function info__img(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gossimg.*"
if (strcopy1(xname,1,8)='gossimg.') then strdel1(xname,1,8) else exit;

//get
if      (xname='ver')        then result:='4.00.15574'
else if (xname='date')       then result:='19jun2025'
else if (xname='name')       then result:='Graphics'
else
   begin
   //nil
   end;

except;end;
end;


//general procs ----------------------------------------------------------------
function zzimg(x:tobject):boolean;//12feb2202
begin
result:=(x<>nil) and (x is tbasicimage);
end;

function asimg(x:tobject):tbasicimage;//12feb2202
begin
if (x<>nil) and (x is tbasicimage) then result:=x as tbasicimage else result:=nil;
end;


//## tgifsupport ###############################################################
constructor tgifsupport.create;
begin
if classnameis('tgifsupport') then track__inc(satGifsupport,1);
zzadd(self);
inherited create;
//vars
ds :=nil;
s32:=misraw32(1,1);
p8 :=misraw8(1,1);
d32:=misraw32(1,1);
sw :=1;
sh :=1;
cc :=1;
flags__lastpos:=0;//not set -> should be 1+ something
flags__lastval:=0;
pcls;
end;

destructor tgifsupport.destroy;
begin
try
//vars
//ds -> is a pointer to a host owned data stream -> up to host to destroy the data stream and not us
freeobj(@s32);
freeobj(@p8);
freeobj(@d32);
//destroy
inherited destroy;
if classnameis('tgifsupport') then track__inc(satGifsupport,-1);
except;end;
end;

function tgifsupport.size(dw,dh:longint):boolean;
begin
result:=missize(s32,dw,dh) and missize(p8,dw,dh) and missize(d32,dw,dh);
end;

procedure tgifsupport.pcls;//clear palette
begin
pcount:=0;
fillchar(ppal,sizeof(ppal),0);
end;

function tgifsupport.pmake(a32:tobject;atrans:boolean):boolean;//make palette
label//m8 = image (8bit) mapped to palette color indexs (0..255) for all pixels in "s".  This allows
     //m8 to be used to gain direct access to the color palette entry for each pixel without the need
     //to look it up or search for it.
   redo,skipend;
const
   dvLimit=240;
var
   pdiv,plimit,aw,ah,mw,mh,ax,ay:longint;
   amin:byte;
   pr8 :pcolorrow8;
   ar32:pcolorrow32;
   c24 :tcolor24;
   c32 :tcolor32;

   function padd:boolean;
   var
      p:longint;
   begin
   result:=false;

   //search to see if color already exists
   for p:=1 to (pcount-1) do if (c24.r=ppal[p].r) and (c24.g=ppal[p].g) and (c24.b=ppal[p].b) then
      begin
      pr8[ax]:=p;
      result:=true;
      break;
      end;

   //add
   if (not result) and (pcount<plimit) then
      begin
      ppal[pcount]:=c24;
      pr8[ax]:=pcount;
      inc(pcount);
      result:=true;
      end;
   end;
begin
//defaults
result:=false;

//first palette entry reserved for transparency -> color (0,0,0) WHEN atrans=TRUE
plimit:=frcmax32(high(ppal)+1,256);

//check
if not misok32(a32,aw,ah)  then exit;
if not  misok8(p8,mw,mh)   then exit;
if (mw<aw) or (mh<ah)      then exit;
if (plimit<=0)             then exit;

try
//build palette (entries 1..255)
pdiv:=1;

redo:
pcls;//clear the palette

if atrans then
   begin
   pcount:=1;
   amin:=255;
   end
else
   begin
   pcount:=0;
   amin:=0;
   end;

for ay:=0 to (ah-1) do
begin
if not misscan32(a32,ay,ar32) then goto skipend;
if not misscan8(p8,ay,pr8)  then goto skipend;

for ax:=0 to (aw-1) do
begin
c32:=ar32[ax];
if (c32.a>=amin) then
   begin
   //shrink color bandwidth
   c24.r:=(c32.r div pdiv)*pdiv;
   c24.g:=(c32.g div pdiv)*pdiv;
   c24.b:=(c32.b div pdiv)*pdiv;

   //pallete is full -> we need to shrink the color bandwidth and start over
   if not padd then
      begin
      //used up all bandwidth shrinkage and palette still can't be built -> quit -> task failed
      if (pdiv>=dvlimit) then goto skipend;

      //try again by shrinking color bandwidth using "pdiv" -> increment by powers of two for fast division
      pdiv:=frcmax32(pdiv+low__aorb(1,10,pdiv>30),dvlimit);//smoother and faster - 25dec2022
      goto redo;
      end;
   end
else pr8[ax]:=0;//pal. slot #0 reserved for transparent color
end;//sx
end;//sy

//successful
result:=true;
skipend:
except;end;
end;

//## tbasicimage ###############################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxx//ggggggggggggggggggggggggggggg
constructor tbasicimage.create;//01NOV2011
begin
if classnameis('tbasicimage') then track__inc(satBasicimage,1);
zzadd(self);
inherited create;
//options
misaiclear(ai);
dtransparent:=true;
omovie:=false;
oaddress:='';
ocleanmask32bpp:=false;
rhavemovie:=false;
//vars
istable:=false;
idata:=str__new8;
irows:=str__new8;
ibits:=0;
iwidth:=0;
iheight:=0;
iprows8 :=nil;
iprows16:=nil;
iprows24:=nil;
iprows32:=nil;
//defaults
setparams(8,1,1);
//enable
istable:=true;
end;

destructor tbasicimage.destroy;//28NOV2010
begin
try
//disable
istable:=false;
//controls
iprows8 :=nil;
iprows16:=nil;
iprows24:=nil;
iprows32:=nil;
freeobj(@irows);
freeobj(@idata);
//destroy
inherited destroy;
if classnameis('tbasicimage') then track__inc(satBasicimage,-1);
except;end;
end;

function tbasicimage.copyfrom(s:tbasicimage):boolean;//09may2022, 09feb2022
label
   skipend;
begin
//defaults
result:=false;

try
//check
if (s=self) then
   begin
   result:=true;
   exit;
   end;
if (s=nil) then exit;
//get
//was: if not low__aicopy(ai,s.ai) then goto skipend;
if not low__aicopy(s.ai,ai) then goto skipend;//09may2022
dtransparent:=s.dtransparent;
omovie:=s.omovie;
oaddress:=s.oaddress;
ocleanmask32bpp:=s.ocleanmask32bpp;
rhavemovie:=s.rhavemovie;
setraw(misb(s),misw(s),mish(s),s.data);
//successful
result:=true;
skipend:
except;end;
end;

function tbasicimage.todata:tstr8;//19feb2022
label
   skipend;
var
   xresult:boolean;
   v8:tvars8;
   tmp:tstr8;//pointer only
begin
result:=nil;
xresult:=false;

try
//defaults
result:=str__new8;
v8:=nil;
//info
v8:=vnew;
if (ai.format<>'')        then v8.s['f']:=ai.format;
if (ai.subformat<>'')     then v8.s['s']:=ai.subformat;
if (ai.info<>'')          then v8.s['i']:=ai.info;
if (ai.map16<>'')         then v8.s['m']:=ai.map16;
if ai.transparent         then v8.b['t']:=ai.transparent;
if ai.syscolors           then v8.b['sc']:=ai.syscolors;
if ai.flip                then v8.b['fp']:=ai.flip;
if ai.mirror              then v8.b['mr']:=ai.mirror;
if (ai.delay<>0)          then v8.i['d']:=ai.delay;
if (ai.itemindex<>0)      then v8.i['i']:=ai.itemindex;
if (ai.count<>0)          then v8.i['c']:=ai.count;
if (ai.bpp<>0)            then v8.i['bp']:=ai.bpp;
if ai.binary              then v8.b['bin']:=ai.binary;
if (ai.hotspotX<>0)       then v8.i['hx']:=ai.hotspotX;
if (ai.hotspotY<>0)       then v8.i['hy']:=ai.hotspotY;
if ai.hotspotMANUAL       then v8.b['hm']:=ai.hotspotMANUAL;
if ai.owrite32bpp         then v8.b['w32']:=ai.owrite32bpp;
if ai.readB64             then v8.b['r64']:=ai.readB64;
if ai.readB128            then v8.b['r128']:=ai.readB128;
if ai.writeB64            then v8.b['w64']:=ai.writeB64;
if ai.writeB128           then v8.b['w128']:=ai.writeB128;
if (ai.iosplit<>0)        then v8.i['ios']:=ai.iosplit;
if (ai.cellwidth<>0)      then v8.i['cw']:=ai.cellwidth;
if (ai.cellheight<>0)     then v8.i['ch']:=ai.cellheight;
if ai.use32               then v8.b['u32']:=ai.use32;//22may2022
if dtransparent           then v8.b['dt']:=dtransparent;
if omovie                 then v8.b['mv']:=omovie;
if (oaddress<>'')         then v8.s['ad']:=oaddress;
if ocleanmask32bpp        then v8.b['c32']:=ocleanmask32bpp;
if rhavemovie             then v8.b['hmv']:=rhavemovie;
//.info
tmp:=v8.data;
result.addint4(0);
result.addint4(tmp.len);
result.add(tmp);
//.pixels
result.addint4(1);
result.addint4(12+idata.len);
result.addint4(bits);
result.addint4(width);
result.addint4(height);
result.add(idata);
//.finished
result.addint4(max32);
//successful
xresult:=true;
skipend:
except;end;
try
result.oautofree:=true;
if (not xresult) and (result<>nil) then result.clear;
freeobj(@v8);
except;end;
end;

function tbasicimage.fromdata(s:tstr8):boolean;//19feb2022
label
   redo,skipend;
var
   v8:tvars8;
   abits,xid,xpos,xlen:longint;
   xdata:tstr8;

   function xpull:boolean;
   label
      skipend;
   var
      b,w,h,slen:longint;
   begin
   //defaults
   result:=false;

   try
   //clear
   xdata.clear;
   //id
   if ((xpos+3)>=xlen) then goto skipend;
   xid:=s.int4[xpos];
   inc(xpos,4);
   //eof
   if (xid=max32) then
      begin
      result:=true;
      goto skipend;
      end;
   //slen
   if ((xpos+3)>=xlen) then goto skipend;
   slen:=s.int4[xpos];
   inc(xpos,4);
   //check
   if ((xpos+slen-1)>=xlen) then goto skipend;
   //data
   if not xdata.add3(s,xpos,slen) then goto skipend;
   inc(xpos,slen);
   //set
   case xid of
   0:v8.data:=xdata;
   1:begin
      b:=xdata.int4[0];//0..3
      w:=xdata.int4[4];//4..7
      h:=xdata.int4[8];//8..11
      if (b<0) or (w<=0) or (h<=0) then goto skipend;
      if not xdata.del3(0,12) then goto skipend;
      if not setraw(b,w,h,xdata) then goto skipend;
      end;
   else goto skipend;//error
   end;
   //successfsul
   result:=true;
   skipend:
   except;end;
   end;
begin
//defaults
result:=false;
abits:=bits;

try
v8:=nil;
xdata:=nil;
//check
if not str__lock(@s) then exit;
//init
xlen:=s.len;
xpos:=0;
v8:=vnew;
xdata:=str__new8;
//get
redo:
if not xpull then goto skipend;
if (xid<>max32) then goto redo;

//info
ai.format            :=v8.s['f'];
ai.subformat         :=v8.s['s'];
ai.info              :=v8.s['i'];
ai.map16             :=v8.s['m'];
ai.transparent       :=v8.b['t'];
ai.syscolors         :=v8.b['sc'];
ai.flip              :=v8.b['fp'];
ai.mirror            :=v8.b['mr'];
ai.delay             :=v8.i['d'];
ai.itemindex         :=v8.i['i'];
ai.count             :=v8.i['c'];
ai.bpp               :=v8.i['bp'];
ai.binary            :=v8.b['bin'];
ai.hotspotX          :=v8.i['hx'];
ai.hotspotY          :=v8.i['hy'];
ai.hotspotMANUAL     :=v8.b['hm'];
ai.owrite32bpp       :=v8.b['w32'];
ai.use32             :=v8.b['u32'];//22may2022
ai.readB64           :=v8.b['r64'];
ai.readB128          :=v8.b['r128'];
ai.writeB64          :=v8.b['w64'];
ai.writeB128         :=v8.b['w128'];
ai.iosplit           :=v8.i['ios'];
ai.cellwidth         :=v8.i['cw'];
ai.cellheight        :=v8.i['ch'];
dtransparent         :=v8.b['dt'];
omovie               :=v8.b['mv'];
oaddress             :=v8.s['ad'];
ocleanmask32bpp      :=v8.b['c32'];
rhavemovie           :=v8.b['hmv'];

//successful
result:=true;
skipend:
except;end;
try
freeobj(@v8);
str__free(@xdata);
str__uaf(@s);
//error
if not result then setparams(abits,1,1);
except;end;
end;

function tbasicimage.sizeto(dw,dh:longint):boolean;
begin
result:=setparams(ibits,dw,dh);
end;

function tbasicimage.setparams(dbits,dw,dh:longint):boolean;
var
   dy,dlen:longint;
begin
//defaults
result:=false;

try
//range
if (dbits<>8) and (dbits<>16) and (dbits<>24) and (dbits<>32) then dbits:=24;
if (dw<1) then dw:=1;
if (dh<1) then dh:=1;
//check
if (dbits=ibits) and (dw=iwidth) and (dh=iheight) then
   begin
   result:=true;
   exit;
   end;
//get
dlen:=(dbits div 8)*dw*dh;
if idata.setlen(dlen) then
   begin
   //init
   ibits:=dbits;
   iwidth:=dw;
   iheight:=dh;
   irows.setlen(dh*sizeof(pointer));
   iprows8 :=irows.prows8;
   iprows16:=irows.prows16;
   iprows24:=irows.prows24;
   iprows32:=irows.prows32;
   //get
   for dy:=0 to (dh-1) do
   begin
   case dbits of
   8 :iprows8[dy] :=ptr__shift(idata.core,dy*dw*1);
   16:iprows16[dy]:=ptr__shift(idata.core,dy*dw*2);
   24:iprows24[dy]:=ptr__shift(idata.core,dy*dw*3);
   32:iprows32[dy]:=ptr__shift(idata.core,dy*dw*4);
   end;
   end;//dy
   //successful
   result:=true;
   end;
except;end;
end;

function tbasicimage.setraw(dbits,dw,dh:longint;ddata:tstr8):boolean;
var
   p,xlen:longint;
   v:byte;
begin
//defaults
result:=false;

try
//size
setparams(dbits,dw,dh);
//lock
if not str__lock(@ddata) then exit;
//get
if (ddata<>nil) and (idata<>nil) then
   begin
   xlen:=frcmax32(idata.len,ddata.len);
   if (xlen>=1) then
      begin
      //was: for p:=0 to (xlen-1) do idata.pbytes[p]:=ddata.pbytes[p];
      //faster - 22apr2022
      for p:=0 to (xlen-1) do
      begin
      v:=ddata.pbytes[p];
      idata.pbytes[p]:=v;
      end;//p
      end;
   end;
result:=true;//19feb2022
except;end;
try;str__uaf(@ddata);except;end;
end;

function tbasicimage.getareadata(sa:twinrect):tstr8;
begin
result:=nil;

try
result:=str__newaf8;
str__lock(@result);
getarea(result,sa);
str__unlock(@result);
except;end;
end;

procedure tbasicimage.setareadata(sa:twinrect;sdata:tstr8);
begin
setarea(sdata,sa);
end;

function tbasicimage.getarea(ddata:tstr8;da:twinrect):boolean;//07dec2023
label
   skipend;
var
   a:tbasicimage;
begin
//defaults
result:=false;

try
a:=nil;
//lock
if not str__lock(@ddata) then exit;
ddata.clear;
//check
if not validarea(da) then goto skipend;
//get
a:=misimg(bits,da.right-da.left+1,da.bottom-da.top+1);//image of same bit depth as ourselves
result:=miscopyarea32(0,0,misw(a),mish(a),da,a,self) and ddata.addb(a.data);//copy area to this image and then return it's raw datastream - 07dec2023
skipend:
except;end;
try
str__uaf(@ddata);
freeobj(@a);
except;end;
end;

function tbasicimage.getareadata2(sa:twinrect):tstr8;
begin
result:=nil;

try
result:=str__newaf8;
str__lock(@result);
getarea_fast(result,sa);
str__unlock(@result);
except;end;
end;

function tbasicimage.getarea_fast(ddata:tstr8;da:twinrect):boolean;//07dec2023
label
   skipend;
var
   sstart,srowsize,drowsize,sw,sh,dy,dw,dh:longint;
begin
//defaults
result:=false;

try
//lock
if not str__lock(@ddata) then exit;
//ddata.clear;
//check
if not validarea(da) then goto skipend;
//range
sw:=width;
sh:=height;
da.left:=frcrange32(da.left,0,sw-1);
da.right:=frcrange32(da.right,da.left,sw-1);
da.top:=frcrange32(da.top,0,sh-1);
da.bottom:=frcrange32(da.bottom,da.top,sh-1);
dw:=da.right-da.left+1;
dh:=da.bottom-da.top+1;
sstart:=(bits div 8)*da.left;
srowsize:=(bits div 8)*sw;
drowsize:=(bits div 8)*dw;
//.size - presize for maximum speed
//ddata.minlen(dh*drowsize);
//ddata.count:=0;

if (ddata.len<>(dh*drowsize)) then ddata.setlen(dh*drowsize);
ddata.setcount(0);



//get
for dy:=da.top to da.bottom do
begin
if not ddata.add3(idata,(dy*srowsize)+sstart,drowsize) then goto skipend;
end;

//successful
result:=true;
skipend:
except;end;
try
if not result then ddata.clear;
str__uaf(@ddata);
except;end;
end;

function tbasicimage.setarea(ddata:tstr8;da:twinrect):boolean;//07dec2023
label
   skipend;
var
   a:tbasicimage;
begin
//defaults
result:=false;

try
a:=nil;
//lock
if not str__lock(@ddata) then exit;
//check
if (da.left>=width) or (da.right<0) or (da.top>=height) or (da.bottom<0) or (da.right<da.left) or (da.bottom<da.top) then
   begin
   result:=true;
   goto skipend;
   end;
//init
a:=misimg8(1,1);
//get
result:=a.setraw(bits,da.right-da.left+1,da.bottom-da.top+1,ddata) and miscopyarea32(da.left,da.top,da.right-da.left+1,da.bottom-da.top+1,misarea(a),self,a);
skipend:
except;end;
try
str__uaf(@ddata);
freeobj(@a);
except;end;
end;

function tbasicimage.findscanline(slayer,sy:longint):pointer;
begin
//defaults
result:=nil;
//check
if (iwidth<1) or (iheight<1) then exit;
//range
if (sy<0) then sy:=0 else if (sy>=iheight) then sy:=iheight-1;
//get
result:=ptr__shift(idata,sy*iwidth*(ibits div 8));
end;

//trawimage --------------------------------------------------------------------
constructor trawimage.create;
begin
if classnameis('trawimage') then track__inc(satrawimage,1);
inherited create;
//options
misaiclear(ai);
dtransparent:=true;
omovie:=false;
oaddress:='';
ocleanmask32bpp:=false;
rhavemovie:=false;
//vars
icore:=tdynamicstr8.create;
irows:=str__new8;
ifallback:=str__new8;
ibits  :=32;
iwidth :=0;//20mar2025
iheight:=0;
//defaults
setparams2(32,1,1,true);
zzadd(self);
end;

destructor trawimage.destroy;
begin
try
//vars
str__free(@ifallback);
str__free(@irows);
freeobj(@icore);
//self
inherited destroy;
if classnameis('trawimage') then track__inc(satrawimage,-1);
except;end;
end;

function trawimage.rowinfo(sy:longint):string;
begin
result:='none';
//for p:=0 to 99 do icore.items[p]:=str__new8;//xxxxxxxxxx
//if (sy>=0) and (sy<icore.count) and (icore.value[sy]<>nil) then result:=k64(icore.count)+'<<'+k64(str__len(cache__ptr(icore.value[sy])))+'<< len: '+k64(icore.value[sy].len)+', datalen: '+k64(icore.value[sy].datalen)+', ptr: '+k64(cardinal(icore.value[sy]));
if (sy>=0) and (sy<icore.count) and (icore.value[sy]<>nil) then result:='sy: '+k64(sy)+'>>'+k64(longint(icore))+'<<..'+k64(icore.count)+'<< len: '+k64(icore.value[sy].len)+', datalen: '+k64(icore.value[sy].datalen)+', ptr: '+k64(cardinal(icore.value[sy]));
end;

procedure trawimage.setbits(x:longint);
begin
setparams(x,iwidth,iheight);
end;

procedure trawimage.setwidth(x:longint);
begin
setparams(ibits,x,iheight);
end;

procedure trawimage.setheight(x:longint);
begin
setparams(ibits,iwidth,x);
end;

function trawimage.setparams(dbits,dw,dh:longint):boolean;
begin
result:=setparams2(dbits,dw,dh,false);
end;

function trawimage.setparams2(dbits,dw,dh:longint;dforce:boolean):boolean;//27dec2024
var
   drowlen:longint;

   procedure xcheckrows;
   var
      i:longint;
   begin
   for i:=0 to (dh-1) do if (icore.value[i].len<>drowlen) then icore.value[i].setlen(drowlen);
   end;
begin
//defaults
result:=false;

try
//range
if (dbits<>8) and (dbits<>16) and (dbits<>24) and (dbits<>32) then dbits:=32;
dw      :=frcmin32(dw,1);
dh      :=frcmin32(dh,1);
drowlen :=mis__rowsize4(dw,dbits);//27may2025

//get
if (dbits<>ibits) or (dw<>iwidth) or (dh<>iheight) or dforce then
   begin
   //ifallback
   ifallback.setlen(drowlen);

   //dh
   if (dh<>iheight) then icore.forcesize(dh);//25jul2024

   //check
   xcheckrows;

   //set
   iheight:=dh;
   iwidth :=dw;
   ibits  :=dbits;

   //sync
   xsync;

   //successful
   result:=true;
   end
else result:=true;
except;end;
end;

function trawimage.getscanline(sy:longint):pointer;
begin
if (sy<0) then sy:=0 else if (sy>=iheight) then sy:=iheight-1;
result:=pointer(icore.value[sy].core);
end;

procedure trawimage.xsync;
var
   dy:longint;
begin
try
//init
irows.setlen(iheight*sizeof(tpointer));
irows8 :=irows.core;
irows15:=irows.core;
irows16:=irows.core;
irows24:=irows.core;
irows32:=irows.core;

//get
for dy:=0 to (iheight-1) do irows32[dy]:=scanline[dy];
except;end;
end;


//## twinbmp ###################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//bbbbbbbbbbbbbbbbbbbbbbb
constructor twinbmp.create;
begin
if classnameis('twinbmp') then track__inc(satBitmap,1);
inherited create;

//vars
low__cls(@iinfo,sizeof(iinfo));
ihbitmap  :=0;
idc       :=0;
icore     :=nil;

ibits     :=32;
iwidth    :=1;
iheight   :=1;
irowsize  :=0;
irows     :=str__new8;

misaiclear(ai);

//defaults
zzadd(self);
setparams2(iwidth,iheight,ibits,true);
end;

destructor twinbmp.destroy;
begin
try
//image
xfreeimage;

//vars
str__free(@irows);

//self
inherited destroy;
if classnameis('twinbmp') then track__inc(satBitmap,-1);
except;end;
end;

procedure twinbmp.setwidth(x:longint);
begin
setparams(ibits,x,iheight);
end;

procedure twinbmp.setheight(x:longint);
begin
setparams(ibits,iwidth,x);
end;

procedure twinbmp.setbits(x:longint);
begin
setparams(x,iwidth,iheight);
end;

function twinbmp.bytes:comp;
begin
result:=mult64(iheight,irowsize);
end;

function twinbmp.setparams(dbits,dw,dh:longint):boolean;
begin
result:=setparams2(dbits,dw,dh,false);
end;

function twinbmp.setparams2(dbits,dw,dh:longint;dforce:boolean):boolean;
var//Note: GUI only goes as far as 24bit, so alpha value for 32bit pixels are not used/persistent
   dy:longint;
begin
//defaults
result:=false;

try
//range
dw:=frcmin32(dw,1);
dh:=frcmin32(dh,1);
if (dbits<>8) and (dbits<>16) and (dbits<>24) and (dbits<>32) then dbits:=32;

//get
if (dw<>iwidth) or (dh<>iheight) or (dbits<>ibits) or dforce then
   begin
   //init
   win____GdiFlush;

   result  :=true;
   iwidth  :=dw;
   iheight :=dh;
   ibits   :=dbits;
   irowsize:=mis__rowsize4(dw,dbits);//27may2025

   with iinfo do
   begin
   biSize          :=sizeof(iinfo);
   biWidth         :=iwidth;
   biHeight        :=-iheight;//top-down bitmap
   biPlanes        :=1;
   biBitCount      :=ibits;
   biCompression   :=0;//BI_RGB=0, BI_BITFIELDS=3
   biSizeImage     :=0;//zero OK for uncompressed images
   biXPelsPerMeter :=0;
   biYPelsPerMeter :=0;
   biClrUsed       :=0;//full table for the current bit depth
   biClrImportant  :=0;//all colors in table assumed important
   end;

   //free
   xfreeimage;

   //create
   idc     :=win____CreateCompatibleDC(0);
   ihbitmap:=win____CreateDIBSection(idc,iinfo,DIB_RGB_COLORS,icore,0,0);
   win____SelectObject(idc,ihbitmap);

   //cache scanlines
   irows.setlen(iheight*sizeof(tpointer));
   irows8 :=irows.core;
   irows15:=irows.core;
   irows16:=irows.core;
   irows24:=irows.core;
   irows32:=irows.core;
   for dy:=0 to (iheight-1) do irows32[dy]:=ptr__shift(icore,dy*irowsize);
   end;
except;end;
end;

procedure twinbmp.xfreeimage;
begin
try
win____GdiFlush;

if (idc<>0)  then
   begin
   win____deletedc(idc);
   idc:=0;
   end;

if (ihbitmap<>0) then
   begin
   win____deleteobject(ihbitmap);
   ihbitmap:=0;
   end;
except;end;
end;

function twinbmp.getscanline(sy:longint):pointer;
begin
if (sy<0) then sy:=0 else if (sy>=iheight) then sy:=iheight-1;
result:=irows32[sy];
end;

function twinbmp.copyarea(sa:twinrect;s:hdc):boolean;
begin
result:=copyarea2(sa,sa,s);
end;

function twinbmp.copyarea2(da,sa:twinrect;s:hdc):boolean;
begin
result:=(s<>0) and (dc<>0) and win____StretchBlt(dc,da.left,da.top,da.right-da.left+1,da.bottom-da.top+1,  s,sa.left,sa.top,sa.right-sa.left+1,sa.bottom-sa.top+1,srcCopy);
end;


//temp procs -------------------------------------------------------------------
function low__createimg24(var x:tbasicimage;xid:string;var xwascached:boolean):boolean;
var
   i,p:longint;
   _ms64:comp;

   function _init(x:longint):tbasicimage;
   begin
   result:=nil;

   try
   systmpstyle[x]:=2;//0=free, 1=available, 2=locked
   systmptime[x]:=add64(ms64,30000);//30s
   systmpid[x]:=xid;
   if zznil(systmpbmp[x],2122) then systmpbmp[x]:=misimg(24,1,1);
   result:=systmpbmp[x];
   except;end;
   end;
begin
//defaults
result:=false;

try
x:=nil;
xwascached:=false;
//find existing
for p:=0 to high(systmpstyle) do if (systmpstyle[p]=1) and (xid=systmpid[p]) then
   begin
   x:=_init(p);
   xwascached:=true;//signal to calling proc the int.list was cacched intact -> allows for optimisation at the calling proc's end - 06sep2017
   break;
   end;
//find new
if zznil(x,2123) then for p:=0 to high(systmpstyle) do if (systmpstyle[p]=0) then
   begin
   x:=_init(p);
   break;
   end;
//find oldest
if zznil(x,2124) then
   begin
   i:=-1;
   _ms64:=0;
   //find
   for p:=0 to high(systmpstyle) do if (systmpstyle[p]=1) and ((systmptime[p]<_ms64) or (_ms64=0)) then
      begin
      i:=p;
      _ms64:=systmptime[p];
      end;//p
   //get
   if (i>=0) then x:=_init(i);
   end;
//successful
result:=(x<>nil);
except;end;
end;

procedure low__freeimg(var x:tbasicimage);
var
   p:longint;
begin
try
if zzok(x,7003) then for p:=0 to high(systmpstyle) do if (x=systmpbmp[p]) then
   begin
   if (systmpstyle[p]=2) then//locked
      begin
      systmptime[p]:=add64(ms64,30000);//30s - hold onto this before trying to free it via "checktmp"
      systmpstyle[p]:=1;//unlock -> make this buffer available again
      x:=nil;
      end;
   break;
   end;//p
except;end;
end;

procedure low__checkimg;
begin
try
//init
inc(systmppos);
if (systmppos<0) or (systmppos>high(systmpstyle)) then systmppos:=0;
//shrink buffer
if (systmpstyle[systmppos]=1) and (ms64>=systmptime[systmppos]) and zzok(systmpbmp[systmppos],7005) and ((systmpbmp[systmppos].width>1) or (systmpbmp[systmppos].height>1)) then
   begin
   systmpstyle[systmppos]:=2;//lock
   try
   systmpid[systmppos]:='';//clear id - 06sep2017
   if (systmpbmp[systmppos].width>1) or (systmpbmp[systmppos].height>1) then systmpbmp[systmppos].sizeto(1,1);//23may2020
   except;end;
   systmpstyle[systmppos]:=1;//unlock
   end;
except;end;
end;

function low__createint(var x:tdynamicinteger;xid:string;var xwascached:boolean):boolean;
var
   _ms64:comp;
   i,p:longint;

   function _init(x:longint):tdynamicinteger;
   begin
   result:=nil;

   try
   sysintstyle[x]:=2;//0=free, 1=available, 2=locked
   sysinttime[x]:=add64(ms64,30000);//30s
   sysintid[x]:=xid;//set the id (duplicate id's are allowed)
   if zznil(sysintobj[x],2125) then sysintobj[x]:=tdynamicinteger.create;
   result:=sysintobj[x];
   except;end;
   end;
begin
//defaults
result:=false;

try
xwascached:=false;
x:=nil;
//find existing
for p:=0 to high(sysintstyle) do if (sysintstyle[p]=1) and (xid=sysintid[p]) then
   begin
   x:=_init(p);
   xwascached:=true;//signal to calling proc the int.list was cacched intact -> allows for optimisation at the calling proc's end - 06sep2017
   break;
   end;
//find new
if zznil(x,2126) then for p:=0 to high(sysintstyle) do if (sysintstyle[p]=0) then
   begin
   x:=_init(p);
   break;
   end;
//find oldest
if zznil(x,2127) then
   begin
   i:=-1;
   _ms64:=0;
   //find
   for p:=0 to high(sysintstyle) do if (sysintstyle[p]=1) and ((sysinttime[p]<_ms64) or (_ms64=0)) then
      begin
      i:=p;
      _ms64:=sysinttime[p];
      end;//p
   //get
   if (i>=0) then x:=_init(i);
   end;
//successful
result:=(x<>nil);
except;end;
end;

procedure low__freeint(var x:tdynamicinteger);
var
   p:longint;
begin
try
if (x<>nil) then for p:=0 to high(sysintstyle) do if (x=sysintobj[p]) then
   begin
   if (sysintstyle[p]=2) then//locked
      begin
      sysinttime[p]:=add64(ms64,30000);//30s - hold onto this before trying to free it via "checktmp"
      sysintstyle[p]:=1;//unlock -> make this buffer available again
      x:=nil;
      end;
   break;
   end;//p
except;end;
end;

procedure low__checkint;
begin
try
//init
inc(sysintpos);
if (sysintpos<0) or (sysintpos>high(sysintstyle)) then sysintpos:=0;
//shrink buffer
if (sysintstyle[sysintpos]=1) and (ms64>=sysinttime[sysintpos]) and zzok(sysintobj[sysintpos],7006) and (sysintobj[sysintpos].size>1) then
   begin
   sysintstyle[sysintpos]:=2;//lock
   sysintid[sysintpos]:='';//clear id - 06sep2017
   sysintobj[sysintpos].clear;
   sysintstyle[sysintpos]:=1;//unlock
   end;
except;end;
end;

function low__createbyte(var x:tdynamicbyte;xid:string;var xwascached:boolean):boolean;
var
   _ms64:comp;
   i,p:longint;

   function _init(x:longint):tdynamicbyte;
   begin
   result:=nil;
   try
   sysbytestyle[x]:=2;//0=free, 1=available, 2=locked
   sysbytetime[x]:=add64(ms64,30000);//30s
   sysbyteid[x]:=xid;//set the id (duplicate id's are allowed)
   if zznil(sysbyteobj[x],2128) then sysbyteobj[x]:=tdynamicbyte.create;
   result:=sysbyteobj[x];
   except;end;
   end;
begin
//defaults
result:=false;

try
xwascached:=false;
x:=nil;
//find existing
for p:=0 to high(sysbytestyle) do if (sysbytestyle[p]=1) and (xid=sysbyteid[p]) then
   begin
   x:=_init(p);
   xwascached:=true;//signal to calling proc the int.list was cacched intact -> allows for optimisation at the calling proc's end - 06sep2017
   break;
   end;
//find new
if zznil(x,2129) then for p:=0 to high(sysbytestyle) do if (sysbytestyle[p]=0) then
   begin
   x:=_init(p);
   break;
   end;
//find oldest
if zznil(x,2130) then
   begin
   i:=-1;
   _ms64:=0;
   //find
   for p:=0 to high(sysbytestyle) do if (sysbytestyle[p]=1) and ((sysbytetime[p]<_ms64) or (_ms64=0)) then
      begin
      i:=p;
      _ms64:=sysbytetime[p];
      end;//p
   //get
   if (i>=0) then x:=_init(i);
   end;
//successful
result:=(x<>nil);
except;end;
end;

procedure low__freebyte(var x:tdynamicbyte);
var
   p:longint;
begin
try
if (x<>nil) then for p:=0 to high(sysbytestyle) do if (x=sysbyteobj[p]) then
   begin
   if (sysbytestyle[p]=2) then//locked
      begin
      sysbytetime[p]:=add64(ms64,30000);//30s - hold onto this before trying to free it via "checktmp"
      sysbytestyle[p]:=1;//unlock -> make this buffer available again
      x:=nil;
      end;
   break;
   end;//p
except;end;
end;

procedure low__checkbyte;
begin
try
//init
inc(sysbytepos);
if (sysbytepos<0) or (sysbytepos>high(sysbytestyle)) then sysbytepos:=0;
//shrink buffer
if (sysbytestyle[sysbytepos]=1) and (ms64>=sysbytetime[sysbytepos]) and zzok(sysbyteobj[sysbytepos],7007) and (sysbyteobj[sysbytepos].size>1) then
   begin
   sysbytestyle[sysbytepos]:=2;//lock
   sysbyteid[sysbytepos]:='';//clear id - 06sep2017
   sysbyteobj[sysbytepos].clear;
   sysbytestyle[sysbytepos]:=1;//unlock
   end;
except;end;
end;

//png procs --------------------------------------------------------------------
function png__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=png__todata2(s,d,'',e);
end;

function png__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=png__todata3(s,d,daction,e);
end;

function png__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//29may2025, 06may2025, OK=27jan2021, 20jan2021
label
   skipend;
var
   vmin,vmax,dbits:longint;
   v0,v255,vother:boolean;
begin
//defaults
result:=false;
e     :=gecTaskfailed;

try
//get
case misb(s) of
24  :dbits:=24;
8   :dbits:=8;
else dbits:=32;
end;

//.determine if 32bit image uses any alpha values
if (dbits=32) then
   begin
   mask__range2(s,v0,v255,vother,vmin,vmax);

   //fully solid -> no transparency -> safe to switch to 24 bit mode
   if (vmin>=255) and (vmax>=255) then dbits:=24;
   end;

//.count colors -> if 256 or less then switch to 8 bit mode
if (dbits<=24) then
   begin
   case mis__countcolors257(s) of
   0..256:dbits:=8;
   end;//case
   end;

//.min bit depth
if      ia__found(daction,ia_32bitPLUS)   then dbits:=32
else if ia__found(daction,ia_24bitPLUS)   then dbits:=24;

//set
result:=png__todata4(s,d,dbits,daction,e);

skipend:
except;end;
end;

function png32__todata(s:tobject;d:pobject):boolean;
var
   daction,e:string;
begin
daction:='';
result:=png__todata4(s,d,32,daction,e);
end;

function png24__todata(s:tobject;d:pobject):boolean;
var
   daction,e:string;
begin
daction:='';
result:=png__todata4(s,d,24,daction,e);
end;

function png8__todata(s:tobject;d:pobject):boolean;
var
   daction,e:string;
begin
daction:='';
result:=png__todata4(s,d,8,daction,e);
end;

function png__todata4(s:tobject;d:pobject;dbits:longint;var daction,e:string):boolean;//29may2025, 06may2025, OK=27jan2021, 20jan2021
label
   skipend;
var
   plist:array[0..255] of tcolor32;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8:pcolorrow8;
   c32:tcolor32;
   c24:tcolor24;
   fsize,fmode,pdiv,plimit,pcount,drowsize,int1,int2,int3,int4,dpos,p,di,sbits,sw,sh,sx,sy:longint;
   lastf2,f1,f2,f3,f4,drow,str1:tstr8;
   fbpp,flen0,flen1,flen2,flen3,flen4:longint;

   function i32(xval:longint):longint;//26jan2021, 11jan2021, 11jun2017
   var
      a,b:tint4;
   begin
   //defaults
   a.val:=xval;
   //get
   b.bytes[3]:=a.bytes[0];
   b.bytes[2]:=a.bytes[1];
   b.bytes[1]:=a.bytes[2];
   b.bytes[0]:=a.bytes[3];
   //set
   result:=b.val;
   end;

   function daddchunk2(const n:array of byte;v:tstr8;vcompress:boolean):boolean;
   begin
   //defaults
   result:=false;

   //check
   if (v=nil) or (sizeof(n)<>4) then exit;

   //compress -> for "IDAT" chunks only -> must use standard linux "deflate" algorithm - 11jan2021
   if vcompress and (v.len>=1) and (not low__compress(@v)) then exit;

   //get
   str__addint4(d, i32(v.len) );
   str__aadd(d,n);

   if (v.len>=1) then str__add(d,@v);

   //.insert name at begining of val and then do crc32 on it - 26jan2021
   v.ains(n,0);
   str__addint4(d, i32(low__crc32b(v)) );

   //successful
   result:=true;
   end;

   function daddchunk(const n:array of byte;v:tstr8):boolean;
   begin
   result:=daddchunk2(n,v,false);
   end;

   procedure r32(const sx:longint);
   begin
   //get
   case sbits of
   8:begin
      c32.r:=sr8[sx];
      c32.g:=c32.r;
      c32.b:=c32.r;
      c32.a:=255;
      end;
   24:begin
      c24:=sr24[sx];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      c32.a:=255;
      end;
   32:begin
      c32:=sr32[sx];

      case dbits of
      24:c32.a:=255;
      8 :if (c32.a=0) then
         begin
         c32.r:=0;
         c32.g:=0;
         c32.b:=0;
         end;
      end;//case

      end;
   end;//case

   //set -> adjust color
   if (pdiv>=2) then
      begin
      c32.r:=(c32.r div pdiv)*pdiv;
      c32.g:=(c32.g div pdiv)*pdiv;
      c32.b:=(c32.b div pdiv)*pdiv;

      //.retain full transparent pixels
      if (c32.a>=1) then
         begin
         c32.a:=(c32.a div pdiv)*pdiv;
         if (c32.a<=0) then c32.a:=1;
         end;
      end;
   end;

   function pfind(var xindex:byte):boolean;
   var
      p:longint;
   begin
   //defaults
   result:=false;
   xindex:=0;

   //find
   for p:=0 to (pcount-1) do if (c32.r=plist[p].r) and (c32.g=plist[p].g) and (c32.b=plist[p].b) and (c32.a=plist[p].a) then
      begin
      result:=true;
      xindex:=p;
      break;
      end;//p
   end;

   function pmake:boolean;
   label
      skipend;
   var
      sx,sy:longint;
      i:byte;
   begin
   //defaults
   result:=false;

   //reset
   pcount:=0;

   //count colors
   for sy:=0 to (sh-1) do
   begin
   if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

   for sx:=0 to (sw-1) do
   begin
   r32(sx);

   //.color already in palette list of colors
   if pfind(i) then
      begin
      //
      end

   //.at capacity -> can't continue
   else if (pcount>=plimit) then
      begin
      //.shift to new color adjuster to reduce overall color count
      pdiv:=frcrange32( pdiv + low__aorb(1,30,pdiv>30) ,1,240);
      goto skipend;
      end

   //.add color to palette list
   else
      begin
      plist[pcount].r:=c32.r;
      plist[pcount].g:=c32.g;
      plist[pcount].b:=c32.b;
      plist[pcount].a:=c32.a;
      inc(pcount);
      end;

   end;//sx
   end;//sy

   //successful
   result:=true;
   skipend:
   end;

   function ddeflatesize(x:tstr8;xfrom0:longint):longint;//a value estimate of WHAT it might be if we were to actually compressing "x" to return it's size - 29may2025: teaked for better estimation, 16jan2021
   var//Typical way for PNG standard to determine best filter type to use - 16jan2021
      //Note: Tested against actual per filter compression, simple method below
      //      produces PNG images for about 107% larger than per filter compression
      //      checking but with only 21% time taken or 4.76x faster.
      lv,p:longint;
   begin
   result:=0;

   if (x<>nil) and (xfrom0>=0) and (x.len>=1) then
      begin
      lv:=0;

      for p:=xfrom0 to frcmax32(xfrom0+drowsize-1,x.len-1) do if (lv<>x.pbytes[p]) then
         begin
         inc(result,x.pbytes[p]);
         lv:=x.pbytes[p];
         end;//p

      end;
   end;

   function xpaeth(a,b,c:byte):longint;
   var
      p,pa,pb,pc:longint;
   begin
   //a = left, b=above, c=upper left
   p:=a+b-c;//initial estimate
   pa:=abs(p-a);
   pb:=abs(p-b);
   pc:=abs(p-c);

   if (pa<=pb) and (pa<=pc) then result:=a
   else if (pb<=pc)         then result:=b
   else                          result:=c;
   end;

   procedure w32;
   begin
   drow.pbytes[di+0]:=c32.r;
   drow.pbytes[di+1]:=c32.g;
   drow.pbytes[di+2]:=c32.b;
   drow.pbytes[di+3]:=c32.a;
   inc(di,4);
   end;

   procedure w24;
   begin
   drow.pbytes[di+0]:=c32.r;
   drow.pbytes[di+1]:=c32.g;
   drow.pbytes[di+2]:=c32.b;
   inc(di,3);
   end;

   procedure w8;
   var
      v:byte;
   begin
   pfind(v);
   drow.pbytes[di+0]:=v;
   inc(di,1);
   end;

   procedure fsmallest(xsize,xmode:longint);
   begin
   if (xsize<fsize) then
      begin
      fsize:=xsize;
      fmode:=xmode;
      end;
   end;

   procedure fset(f:tstr8;xmode:byte);
   var
      p:longint;
   begin
   if (xmode>=1) and (f<>nil) then
      begin
      drow.pbytes[dpos-1]:=xmode;
      for p:=1 to drowsize do drow.pbytes[dpos+p-1]:=f.pbytes[p-1];
      end;
   end;
begin
//defaults
result   :=false;
e        :=gecTaskfailed;
pcount   :=0;
drow     :=nil;
lastf2   :=nil;
f1       :=nil;
f2       :=nil;
f3       :=nil;
f4       :=nil;
str1     :=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//range
case dbits of
32,24,8:;
else    dbits:=32;
end;

//clear
str__clear(d);

//init
fbpp     :=dbits div 8;//bytes per pixel -> filter support
drowsize :=sw * fbpp;//unlike bitmap, PNG does not round rowsize to nearest 4bytes - 29may2025
lastf2   :=str__new8;
f1       :=str__new8;
f2       :=str__new8;
f3       :=str__new8;
f4       :=str__new8;
drow     :=str__new8;
str1     :=str__new8;

//image action -> less data - 06may2025
if      ia__found(daction,ia_bestquality) then pdiv:=1//off
else if ia__found(daction,ia_highquality) then pdiv:=2
else if ia__found(daction,ia_goodquality) then pdiv:=3
else if ia__found(daction,ia_fairquality) then pdiv:=4
else if ia__found(daction,ia_lowquality)  then pdiv:=5
else                                           pdiv:=1;//off

//make palette
if (dbits<=8) then
   begin
   plimit:=256;
   while not pmake do;
   end;

//header
str__aadd(d,[137,80,78,71,13,10,26,10]);

//IHDR                         //name   width.4     height.4   bitdepth.1  colortype.1 (6=R8,G8,B8,A8)  compressionMethod.1(#0 only = deflate/inflate)  filtermethod.1(#0 only) interlacemethod.1(#0=LR -> TB scanline order)
str1.clear;
str1.addint4( i32(sw) );
str1.addint4( i32(sh) );
str1.addbyt1(8);

//.color type
case dbits of
8 :str1.addbyt1(3);//8 => palette based (includes only RGB entries of any number between 1 and 256 entirely dependant on the size of DATA in "PLTE" chunk, need to use "tRNS" which like palette stores JUST the alpha values for each palette entry)
24:str1.addbyt1(2);//    0=greyscale, 1=palette used, 2=color used, 4=alpha used -> add these together to produce final value - 11jan2021
32:str1.addbyt1(6);
end;

str1.addbyt1(0);
str1.addbyt1(0);
str1.addbyt1(0);
daddchunk([uuI,uuH,uuD,uuR],str1);
str1.clear;

//scanlines
drow.setlen( sh * (1+drowsize) );//room for "filter style(1b)" + actual row data

//.filter support
f1.setlen(drowsize);
f2.setlen(drowsize);
f3.setlen(drowsize);
f4.setlen(drowsize);
lastf2.setlen(drowsize);
for p:=0 to (drowsize-1) do lastf2.pbytes[p]:=0;

di:=0;
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

drow.pbytes[di+0]:=0;//filter subtype=none (#0)
inc(di);
dpos:=di;

//.32
if (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   r32(sx);
   w32;
   end;//sx
   end
//.24
else if (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   r32(sx);
   w24;
   end;//sx
   end
//.8
else if (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   r32(sx);
   w8;
   end;//sx
   end;

//sample all filters and use the one that compresses the best
//.f0
flen0:=ddeflatesize(drow,dpos);

//.f1 -> sub -> write difference in pixels in horizontal lines
for p:=1 to drowsize do
begin
int1:=drow.pbytes[dpos+p-1];
if ((p-fbpp)>=1) then int2:=drow.pbytes[dpos+p-fbpp-1] else int2:=0;
int1:=int1-int2;
if (int1<0) then inc(int1,256);
f1.pbytes[p-1]:=int1;
end;//p
flen1:=ddeflatesize(f1,0);

//.f2 - up -> write difference in pixels in vertical lines
for p:=1 to drowsize do
begin
int2:=lastf2.pbytes[p-1];
int1:=drow.pbytes[dpos+p-1];
int1:=int1-int2;
if (int1<0) then inc(int1,256);
f2.pbytes[p-1]:=int1;
end;//p
flen2:=ddeflatesize(f2,0);

//.f3 - average
for p:=1 to drowsize do
begin
int3:=lastf2.pbytes[p-1];
if ((p-fbpp)>=1) then int2:=drow.pbytes[dpos+p-fbpp-1] else int2:=0;
int1:=drow.pbytes[dpos+p-1];
int1:=int1-trunc((int2+int3)/2);
if (int1<0) then inc(int1,256);
f3.pbytes[p-1]:=int1;
end;//p
flen3:=ddeflatesize(f3,0);

//.f4 - paeth
for p:=1 to drowsize do
begin
if ((p-fbpp)>=1) then int4:=lastf2.pbytes[p-fbpp-1] else int4:=0;
int3:=lastf2.pbytes[p-1];
if ((p-fbpp)>=1) then int2:=drow.pbytes[dpos+p-fbpp-1] else int2:=0;
int1:=drow.pbytes[dpos+p-1];
int1:=int1-xpaeth(int2,int3,int4);
if (int1<0) then inc(int1,256);
f4.pbytes[p-1]:=int1;
end;//p
flen4:=ddeflatesize(f4,0);

//.sync lastf2 -> do here BEFORE xrow is modified below - 14jan2021
for p:=1 to drowsize do lastf2.pbytes[p-1]:=drow.pbytes[dpos+p-1];

//.write filter back into row
fsize:=flen0;
fmode:=0;

fsmallest(flen1,1);
fsmallest(flen2,2);
fsmallest(flen3,3);
fsmallest(flen4,4);

//.write
case fmode of
1:fset(f1,1);
2:fset(f2,2);
3:fset(f3,3);
4:fset(f4,4);
end;//case

end;//sy

//.PLTE - rgb color palette -> must preceed "IDAT"
if (dbits<=8) then
   begin
   str1.setlen(pcount*3);

   for p:=0 to (pcount-1) do
   begin
   str1.pbytes[(p*3)+0]:=plist[p].r;
   str1.pbytes[(p*3)+1]:=plist[p].g;
   str1.pbytes[(p*3)+2]:=plist[p].b;
   end;//p

   daddchunk([uuP,uuL,uuT,uuE],str1);
   str1.clear;
   end;

//.tRNS - color palette of alpha values -> must follow "PLTE" and preceed "IDAT"
if (dbits<=8) and (sbits>=32) then
   begin
   str1.setlen(pcount);

   for p:=0 to (pcount-1) do str1.pbytes[p]:=plist[p].a;

   daddchunk([llt,uuR,uuN,uuS],str1);
   str1.clear;
   end;

//.IDAT
daddchunk2([uuI,uuD,uuA,uuT],drow,true);

//IEND
str1.clear;
daddchunk([uuI,uuE,uuN,uuD],str1);//27jan2021

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__free(@lastf2);
str__free(@f1);
str__free(@f2);
str__free(@f3);
str__free(@f4);
str__free(@drow);
str__free(@str1);
str__uaf(d);
end;

function png__fromdata(s:tobject;d:pobject;var e:string):boolean;
label
   skipend;
var
   d64:tobject;//decoded base64 version of "d" -> automatic and optionally used to keep "d" unchanged
   sr8:pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc24:tcolor24;
   sc32:tcolor32;
   drowsize,xpos,xbitdepth,spos,int1,int2,int3,int4,p,xcoltype,sbits,xbits,sw,sh,xw,xh,sx,sy:longint;
   xdata,xval,n,v,lastfd,fd,str1,str2,str3:tstr8;
   fbpp,flen:longint;
   xnam:array[0..3] of byte;
   xcollist:array[0..255] of tcolor32;
   xtransparent,dok:boolean;

   function fi32(xval:longint):longint;//26jan2021, 11jan2021, 11jun2017
   var
      a,b:tint4;
   begin
   //get
   a.val:=xval;
   b.bytes[0]:=a.bytes[3];
   b.bytes[1]:=a.bytes[2];
   b.bytes[2]:=a.bytes[1];
   b.bytes[3]:=a.bytes[0];
   //set
   result:=b.val;
   end;

   function xpullchunk(var xname:array of byte;xdata:pobject):boolean;
   label//Chunk structure: "i32(length(xdata))+xname+xdata+i32(misc.crc32b(xname+xdata))"
      skipend;
   var
      xlen:longint;
   begin
   //defaults
   result:=false;

   //check
   if (xdata=nil) or (sizeof(xname)<>4) then exit;

   //init
   str__clear(xdata);
   xname[0]:=0;
   xname[1]:=0;
   xname[2]:=0;
   xname[3]:=0;

   //chunk length
   if dok then xlen:=fi32(str__int4(d,spos-1)) else xlen:=fi32(str__int4(@d64,spos-1));
   inc(spos,4);
   if (xlen<0) then goto skipend;

   //chunk name
   if dok then
      begin
      xname[0]:=str__bytes0(d,spos-1+0);
      xname[1]:=str__bytes0(d,spos-1+1);
      xname[2]:=str__bytes0(d,spos-1+2);
      xname[3]:=str__bytes0(d,spos-1+3);
      end
   else
      begin
      xname[0]:=str__bytes0(@d64,spos-1+0);
      xname[1]:=str__bytes0(@d64,spos-1+1);
      xname[2]:=str__bytes0(@d64,spos-1+2);
      xname[3]:=str__bytes0(@d64,spos-1+3);
      end;
   inc(spos,4);

   //chunk data
   if (xlen>=1) then
      begin
      if dok then str__add3(xdata,d,spos-1,xlen) else str__add3(xdata,@d64,spos-1,xlen);
      end;

   if (str__len(xdata)<>xlen) then goto skipend;
   inc(spos,xlen+4);//step over trailing crc32(4b)

   //successful
   result:=true;
   skipend:
   end;

   function xpaeth(a,b,c:byte):longint;
   var
      p,pa,pb,pc:longint;
   begin
   //a = left, b=above, c=upper left
   p:=a+b-c;//initial estimate
   pa:=abs(p-a);
   pb:=abs(p-b);
   pc:=abs(p-c);
   if (pa<=pb) and (pa<=pc) then result:=a
   else if (pb<=pc)         then result:=b
   else                          result:=c;
   end;
begin
//defaults
result :=false;
e      :=gecTaskfailed;
xbits  :=0;
dok    :=true;
d64    :=nil;
n      :=nil;
v      :=nil;
xdata  :=nil;
xval   :=nil;
lastfd :=nil;
fd     :=nil;
str1   :=nil;
str2   :=nil;
str3   :=nil;
xtransparent:=false;

//check
if not str__lock(d) then exit;

try
//init
if not misok82432(s,sbits,sw,sh) then
   begin
   if (sw<1) then sw:=1;
   if (sh<1) then sh:=1;
   missize2(s,sw,sh,true);
   if not misok82432(s,sbits,sw,sh) then goto skipend;
   end;

spos  :=1;
n     :=str__new8;
v     :=str__new8;
xdata :=str__new8;
xval  :=str__new8;
lastfd:=str__new8;
fd    :=str__new8;
str1  :=str__new8;
str2  :=str__new8;
str3  :=str__new8;

//.palette
for p:=0 to high(xcollist) do
begin
xcollist[p].r:=0;
xcollist[p].g:=0;
xcollist[p].b:=0;
xcollist[p].a:=255;//fully solid
end;//p

//header
if not str__asame3(d,0,[137,80,78,71,13,10,26,10],true) then
   begin

   //init
   dok:=false;
   if (d64=nil) then d64:=str__newsametype(d);//same type

   //switch to base64 encoded text mode
   //.strip "b64:" header
   if str__asame3(d,0,[98,54,52,58],true) then
      begin
      str__add3(@d64,d,4,str__len(d));
      if not str__fromb64(@d64,@d64) then goto skipend;
      end
   //.raw base64 data (no header)
   else
      begin
      if not str__fromb64(d,@d64) then goto skipend;
      end;

   //check again
   if not str__asame3(@d64,0,[137,80,78,71,13,10,26,10],true) then
      begin
      e:=gecUnknownformat;
      goto skipend;
      end;

   end;
spos:=9;

//IHDR                         //name   width.4     height.4   bitdepth.1  colortype.1 (6=R8,G8,B8,A8)  compressionMethod.1(#0 only = deflate/inflate)  filtermethod.1(#0 only) interlacemethod.1(#0=LR -> TB scanline order)
if (not xpullchunk(xnam,@xval)) or (not low__comparearray(xnam,[uuI,uuH,uuD,uuR])) or (str__len(@xval)<13) then
   begin
   e:=gecDatacorrupt;
   goto skipend;
   end;

xw:=fi32(str__int4(@xval,1-1));//1..4
xh:=fi32(str__int4(@xval,5-1));//5..8

if (xw<=0) or (xh<=0) then
   begin
   e:=gecDatacorrupt;
   goto skipend;
   end
else
   begin
   //size "s" to match datastream image
   if not missize2(s,xw,xh,true) then goto skipend;
   sw:=misw(s);
   sh:=mish(s);
   if (sw<>xw) or (sh<>xh) then goto skipend;
   end;

xbitdepth:=str__bytes0(@xval,9-1);
if (xbitdepth<>8) then//we support bit depth of 8bits only
   begin
   e:=gecUnsupportedFormat;
   goto skipend;
   end;

xcoltype:=str__bytes0(@xval,10-1);
if (str__bytes0(@xval,11-1)<>0) or (str__bytes0(@xval,12-1)<>0) or (str__bytes0(@xval,13-1)<>0) then
   begin
   e:=gecUnsupportedFormat;
   goto skipend;
   end;

//read remaining chunks
while true do
begin
if not xpullchunk(xnam,@xval) then
   begin
   e:=gecDataCorrupt;
   goto skipend;
   end;

//.iend
if low__comparearray(xnam,[uuI,uuE,uuN,uuD]) then break
//.idat
else if low__comparearray(xnam,[uuI,uuD,uuA,uuT]) then str__add(@xdata,@xval)
//.plte
else if low__comparearray(xnam,[uuP,uuL,uuT,uuE]) then
   begin
   int1:=frcrange32(str__len(@xval) div 3,0,1+high(xcollist));
   if (int1>=1) then
      begin
      int2:=1;
      for p:=0 to (int1-1) do
      begin
      xcollist[p].r:=str__bytes0(@xval,int2+0-1);
      xcollist[p].g:=str__bytes0(@xval,int2+1-1);
      xcollist[p].b:=str__bytes0(@xval,int2+2-1);
      inc(int2,3);
      end;//p
      end;//int1
   end
//.trns
else if low__comparearray(xnam,[uuT,uuR,uuN,uuS]) then
   begin
   int1:=frcrange32(str__len(@xval),0,1+high(xcollist));
   if (int1>=1) then
      begin
      for p:=0 to (int1-1) do xcollist[p].a:=str__bytes0(@xval,p);
      end;//int1
   end;
end;//while


//.finalise
str__clear(@xval);

//.decompress "xdata"
if ( (str__len(@xdata)>=1) and (not low__decompress(@xdata)) ) or (str__len(@xdata)<=0) then
   begin
   e:=gecDataCorrupt;
   goto skipend;
   end;

//check datalen matches expected datalen ---------------------------------------
//   Color   Allowed     Interpretation
//   Type    Bit Depths
//   0       1,2,4,8,16  Each pixel is a grayscale sample.
//   2       8,16        Each pixel is an R,G,B triple.
//   3       1,2,4,8     Each pixel is a palette index;
//                       a PLTE chunk must appear.
//   4       8,16        Each pixel is a grayscale sample,
//                       followed by an alpha sample.
//   6       8,16        Each pixel is an R,G,B triple,
//                       followed by an alpha sample.
case xcoltype of
0:xbits:=8;
2:xbits:=24;
3:xbits:=8;
4:xbits:=16;
6:xbits:=32;
end;

drowsize:=mis__rowsize4(xw,xbits);//29may2025
if ( (xh * (1+drowsize) ) > str__len(@xdata) ) then
   begin
   e:=gecDataCorrupt;
   goto skipend;
   end;

//scanlines
//.filter support
fbpp:=xbits div 8;//bytes per pixel
flen:=(xw*fbpp);//size of row excluding leading filter byte
fd.setlen(flen);
lastfd.setlen(flen);for p:=1 to flen do lastfd.pbytes[p-1]:=0;

for sy:=0 to (xh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
xpos:=1+(sy*(1+flen));

//.unscramble filter row "filtertype.1 + scanline"
case xdata.pbytes[xpos-1] of
0:;//none -> nothing to do
1:begin//.f1 -> sub -> write difference in pixels in horizontal lines
   for p:=1 to flen do
   begin
   int1:=xdata.pbytes[xpos+p-1];
   if ((p-fbpp)>=1) then int2:=xdata.pbytes[xpos+p-fbpp-1] else int2:=0;
   int1:=int1+int2;
   if (int1>255) then dec(int1,256);
   xdata.pbytes[xpos+p-1]:=int1;
   end;//p
   end;
2:begin//.f2 - up -> write difference in pixels in vertical lines
   for p:=1 to flen do
   begin
   int2:=lastfd.pbytes[p-1];
   int1:=xdata.pbytes[xpos+p-1];
   int1:=int1+int2;
   if (int1>255) then dec(int1,256);
   xdata.pbytes[xpos+p-1]:=int1;
   end;//p
   end;
3:begin//.f3 - average
   for p:=1 to flen do
   begin
   int3:=lastfd.pbytes[p-1];
   if ((p-fbpp)>=1) then int2:=xdata.pbytes[xpos+p-fbpp-1] else int2:=0;
   int1:=xdata.pbytes[xpos+p-1];
   int1:=int1+trunc((int2+int3)/2);
   if (int1>255) then dec(int1,256);
   xdata.pbytes[xpos+p-1]:=int1;
   end;//p
   end;
4:begin
   //.f4 - paeth
   for p:=1 to flen do
   begin
   if ((p-fbpp)>=1) then int4:=lastfd.pbytes[p-fbpp-1] else int4:=0;
   int3:=lastfd.pbytes[p-1];
   if ((p-fbpp)>=1) then int2:=xdata.pbytes[xpos+p-fbpp-1] else int2:=0;
   int1:=xdata.pbytes[xpos+p-1];
   int1:=int1+xpaeth(int2,int3,int4);
   if (int1>255) then dec(int1,256);
   xdata.pbytes[xpos+p-1]:=int1;
   end;//p
   end;
else
   begin
   e:=gecDatacorrupt;
   goto skipend;
   end;
end;//case

//.32 => 32
if (xbits=32) and (sbits=32) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc32.r:=xdata.pbytes[xpos+1-1];
   sc32.g:=xdata.pbytes[xpos+2-1];
   sc32.b:=xdata.pbytes[xpos+3-1];
   sc32.a:=xdata.pbytes[xpos+4-1];
   if (sc32.a=0) then xtransparent:=true;//17jan2021
   sr32[sx]:=sc32;
   inc(xpos,4);
   end;//sx
   end
//.32 => 24
else if (xbits=32) and (sbits=24) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc24.r:=xdata.pbytes[xpos+1-1];
   sc24.g:=xdata.pbytes[xpos+2-1];
   sc24.b:=xdata.pbytes[xpos+3-1];
   if (xdata.pbytes[xpos+4-1]=0) then xtransparent:=true;//17jan2021
   sr24[sx]:=sc24;
   inc(xpos,4);
   end;//sx
   end
//.32 => 8
else if (xbits=32) and (sbits=8) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc24.r:=xdata.pbytes[xpos+1-1];
   sc24.g:=xdata.pbytes[xpos+2-1];
   sc24.b:=xdata.pbytes[xpos+3-1];
   if (sc24.g>sc24.r) then sc24.r:=sc24.g;
   if (sc24.b>sc24.r) then sc24.r:=sc24.b;
   if (xdata.pbytes[xpos+4-1]=0) then xtransparent:=true;//17jan2021
   sr8[sx]:=sc24.r;
   inc(xpos,4);
   end;//sx
   end
//.24 => 32
else if (xbits=24) and (sbits=32) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc32.r:=xdata.pbytes[xpos+1-1];
   sc32.g:=xdata.pbytes[xpos+2-1];
   sc32.b:=xdata.pbytes[xpos+3-1];
   sc32.a:=255;//fully solid
   sr32[sx]:=sc32;
   inc(xpos,3);
   end;//sx
   end
//.24 => 24
else if (xbits=24) and (sbits=24) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc24.r:=xdata.pbytes[xpos+1-1];
   sc24.g:=xdata.pbytes[xpos+2-1];
   sc24.b:=xdata.pbytes[xpos+3-1];
   sr24[sx]:=sc24;
   inc(xpos,3);
   end;//sx
   end
//.24 => 8
else if (xbits=32) and (sbits=8) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc24.r:=xdata.pbytes[xpos+1-1];
   sc24.g:=xdata.pbytes[xpos+2-1];
   sc24.b:=xdata.pbytes[xpos+3-1];
   if (sc24.g>sc24.r) then sc24.r:=sc24.g;
   if (sc24.b>sc24.r) then sc24.r:=sc24.b;
   sr8[sx]:=sc24.r;
   inc(xpos,3);
   end;//sx
   end
//.8 => 32
else if (xbits=8) and (sbits=32) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc32:=xcollist[xdata.pbytes[xpos+1-1]];
   if (sc32.a=0) then xtransparent:=true;//17jan2021
   sr32[sx]:=sc32;
   inc(xpos,1);
   end;//sx
   end
//.8 => 24
else if (xbits=8) and (sbits=24) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc32:=xcollist[xdata.pbytes[xpos+1-1]];
   sc24.r:=sc32.r;
   sc24.g:=sc32.g;
   sc24.b:=sc32.b;
   if (sc32.a=0) then xtransparent:=true;//17jan2021
   sr24[sx]:=sc24;
   inc(xpos,1);
   end;//sx
   end
//.8 => 8
else if (xbits=8) and (sbits=8) then
   begin
   for sx:=0 to (xw-1) do
   begin
   sc32:=xcollist[xdata.pbytes[xpos+1-1]];
   if (sc32.g>sc32.r) then sc32.r:=sc32.g;
   if (sc32.b>sc32.r) then sc32.r:=sc32.b;
   if (sc32.a=0) then xtransparent:=true;//17jan2021
   sr8[sx]:=sc32.r;
   inc(xpos,1);
   end;//sx
   end
else break;


//.sync lastf2 -> do here BEFORE xrow is modified below - 14jan2021
xpos:=1+(sy*(1+flen));

for p:=1 to flen do lastfd.pbytes[p-1]:=xdata.pbytes[xpos+p-1];

end;//sy

//animation information
if mishasai(s) then
   begin
   misai(s).format:='PNG';
   misai(s).subformat:='';
   misai(s).transparent:=xtransparent;//information purposes only

   misai(s).count:=1;
   misai(s).cellwidth:=misw(s);
   misai(s).cellheight:=mish(s);
   misai(s).delay:=0;

   case xcoltype of
   0:misai(s).bpp:=8;
   2:misai(s).bpp:=24;
   3:misai(s).bpp:=8;
   4:misai(s).bpp:=16;
   6:misai(s).bpp:=32;
   end;//case
   end;

//successful
result:=true;
skipend:
except;end;
//free
str__free(@n);
str__free(@v);
str__free(@xdata);
str__free(@xval);
str__free(@lastfd);
str__free(@fd);
str__free(@str1);
str__free(@str2);
str__free(@str3);
str__free(@d64);
str__uaf(d);//27jan2021
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//11111111111111111111111111111111
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx




//tea procs (text picture) -----------------------------------------------------
function tea__todata(x:tobject;xout:pobject;var e:string):boolean;
begin
result:=tea__todata2(x,false,false,0,0,xout,e);//ver 1
end;

function tea__todata2(x:tobject;xtransparent,xsyscolors:boolean;xval1,xval2:longint;xout:pobject;var e:string):boolean;//07apr2021
begin
result:=tea__todata32(x,xtransparent,xsyscolors,xval1,xval2,xout,e);//ver 2
end;

function tea__todata32(x:tobject;xtransparent,xsyscolors:boolean;xval1,xval2:longint;xout:pobject;var e:string):boolean;//18nov2024
label
   skipend;
var
   l4:tint4;
   l5:tcolor40;
   xver,xw,xh,xbits,sx,sy:longint;
   prows8:pcolorrows8;
   prows24:pcolorrows24;
   prows32:pcolorrows32;
   sr8:pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc8:tcolor8;//07apr2021
   sc24:tcolor24;
   sc32:tcolor32;

   procedure xadd24;
   begin
   if (l4.r<>sc24.r) or (l4.g<>sc24.g) or (l4.b<>sc24.b) then
      begin
      if (l4.a>=1) then str__addint4(xout,l4.val);
      l4.r:=sc24.r;
      l4.g:=sc24.g;
      l4.b:=sc24.b;
      l4.a:=1;//one
      end
   else
      begin
      inc(l4.a);
      if (l4.a>=250) then
         begin
         str__addint4(xout,l4.val);
         l4.a:=0;//reset
         end;
      end;
   end;

   procedure xadd32;
   begin
   if (l5.b<>sc32.r) or (l5.g<>sc32.g) or (l5.r<>sc32.b) or (l5.c<>sc32.a) then
      begin
      if (l5.a>=1) then str__addrec(xout,@l5,sizeof(l5));
      l5.b:=sc32.r;//switch bytes to store as RGBAC order as native order is BGRAC
      l5.g:=sc32.g;
      l5.r:=sc32.b;
      l5.c:=sc32.a;
      l5.a:=1;
      end
   else
      begin
      inc(l5.a);
      if (l5.a>=250) then
         begin
         str__addrec(xout,@l5,sizeof(l5));
         l5.a:=0;//reset
         end;
      end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(xout) then goto skipend;
if zznil(x,2202) then goto skipend;

//init
//.rawimage
if (x is trawimage) then
   begin
   prows8 :=(x as tbasicimage).prows8;
   prows24:=(x as tbasicimage).prows24;
   prows32:=(x as tbasicimage).prows32;
   end
//.image
else if (x is tbasicimage) then
   begin
   prows8 :=(x as tbasicimage).prows8;
   prows24:=(x as tbasicimage).prows24;
   prows32:=(x as tbasicimage).prows32;
   end
//.winbmp
else if (x is twinbmp) then
   begin
   prows8 :=(x as twinbmp).prows8;
   prows24:=(x as twinbmp).prows24;
   prows32:=(x as twinbmp).prows32;
   end
else goto skipend;

//info
xbits:=misb(x);
xw:=misw(x);
xh:=mish(x);
if (xbits<>8) and (xbits<>24) and (xbits<>32) then goto skipend;
str__clear(xout);
l4.val:=0;
l5.r:=0;
l5.g:=0;
l5.b:=0;
l5.a:=0;
l5.c:=0;

//head
if (xbits>=32) and mask__hasTransparency32(x) then//ver 3 -> 32bit color - 18nov2024
   begin
   xver:=3;
   str__aadd(xout,[uuT,uuE,uuA,nn3,ssHash]);//TEA3#
   str__addbyt1(xout,low__insint(1,xtransparent));//0=solid, 1=transparent
   str__addbyt1(xout,low__insint(1,xsyscolors));//0=no, 1=yes
   str__addbyt1(xout,0);//reserved
   str__addbyt1(xout,0);//reserved
   str__addbyt1(xout,0);//reserved
   str__addbyt1(xout,0);//reserved
   str__addint4(xout,xval1);
   str__addint4(xout,xval2);
   end
else if xtransparent or xsyscolors then//ver 2 -> 24bit color
   begin
   xver:=2;
   str__aadd(xout,[uuT,uuE,uuA,nn2,ssHash]);//TEA2#
   str__addbyt1(xout,low__insint(1,xtransparent));//0=solid, 1=transparent
   str__addbyt1(xout,low__insint(1,xsyscolors));//0=no, 1=yes
   str__addbyt1(xout,0);//reserved
   str__addbyt1(xout,0);//reserved
   str__addbyt1(xout,0);//reserved
   str__addbyt1(xout,0);//reserved
   str__addint4(xout,xval1);
   str__addint4(xout,xval2);
   end
else
   begin
   xver:=1;
   str__aadd(xout,[uuT,uuE,uuA,nn1,ssHash]);//TEA1# - ver 1 -> 24bit color
   end;

str__addint4(xout,xw);
str__addint4(xout,xh);//13 bytes

//pixels
e:=gecOutofmemory;
for sy:=0 to (xh-1) do
begin
if (xbits=8) then
   begin
   sr8:=prows8[sy];
   for sx:=0 to (xw-1) do
   begin
   sc8:=sr8[sx];
   sc24.r:=sc8;
   sc24.g:=sc8;
   sc24.b:=sc8;
   xadd24;
   end;//sx
   end
else if (xbits=24) then
   begin
   sr24:=prows24[sy];
   for sx:=0 to (xw-1) do
   begin
   sc24:=sr24[sx];
   xadd24;
   end;//sx
   end
else if (xbits=32) and (xver=3) then
   begin
   sr32:=prows32[sy];
   for sx:=0 to (xw-1) do
   begin
   sc32:=sr32[sx];
   xadd32;
   end;//sx
   end
else if (xbits=32) then
   begin
   sr32:=prows32[sy];
   for sx:=0 to (xw-1) do
   begin
   sc32:=sr32[sx];
   sc24.r:=sc32.r;
   sc24.g:=sc32.g;
   sc24.b:=sc32.b;
   xadd24;
   end;//sx
   end;
end;//xy

//.finalise
case xver of
1..2:if (l4.a>=1) then str__addint4(xout,l4.val);//4 byte record
3   :if (l5.a>=1) then str__addrec(xout,@l5,sizeof(l5));//5 byte record
end;

//successful
result:=true;
skipend:
except;end;
try
if (not result) and str__ok(xout) then str__clear(xout);
str__uaf(xout);
except;end;
end;

function tea__info(var adata:tlistptr;xsyszoom:boolean;var aw,ah,aSOD,aversion,aval1,aval2:longint;var atransparent,asyscolors:boolean):boolean;
label//Note: aSOD = start of data
   skipend;
var
   v:tint4;
   int1,xpos:longint;
begin
//defaults
result:=false;

try
aw:=0;
ah:=0;
aSOD:=13;
aversion:=1;
aval1:=0;
aval2:=0;
atransparent:=true;
asyscolors:=true;
//check
if (adata.count<13) or (adata.bytes=nil) then goto skipend;
//get
//.header
int1:=adata.bytes[3];
if (adata.bytes[0]=uuT) and (adata.bytes[1]=uuE) and (adata.bytes[2]=uuA) and ( (int1=nn2) or (int1=nn3) ) and (adata.bytes[4]=ssHash) then
   begin
   //init
   aSOD:=27;//zero based (27=28 bytes)
   xpos:=5;

   //version 2 = 24 bit color and version 3 = 32 bit color - 18nov2024
   if      (int1=nn2) then aversion:=2
   else if (int1=nn3) then aversion:=3
   else                    goto skipend;

   if (adata.count<(aSOD+1)) then goto skipend;//1 based
   //transparent
   atransparent:=(adata.bytes[xpos]<>0);
   inc(xpos,1);
   //syscolors -> black=font color, black+1=border color
   asyscolors:=(adata.bytes[xpos]<>0);
   inc(xpos,1);
   //reserved 1-4
   inc(xpos,4);
   //val1
   v.bytes[0]:=adata.bytes[xpos+0];
   v.bytes[1]:=adata.bytes[xpos+1];
   v.bytes[2]:=adata.bytes[xpos+2];
   v.bytes[3]:=adata.bytes[xpos+3];
   inc(xpos,4);
   aval1:=v.val;
   //val2
   v.bytes[0]:=adata.bytes[xpos+0];
   v.bytes[1]:=adata.bytes[xpos+1];
   v.bytes[2]:=adata.bytes[xpos+2];
   v.bytes[3]:=adata.bytes[xpos+3];
   inc(xpos,4);
   aval2:=v.val;
   end
else if (adata.bytes[0]=uuT) and (adata.bytes[1]=uuE) and (adata.bytes[2]=uuA) and (adata.bytes[3]=nn1) and (adata.bytes[4]=ssHash) then xpos:=5//TEA1#
else goto skipend;
//.w
v.bytes[0]:=adata.bytes[xpos+0];
v.bytes[1]:=adata.bytes[xpos+1];
v.bytes[2]:=adata.bytes[xpos+2];
v.bytes[3]:=adata.bytes[xpos+3];
aw:=v.val;
if (aw<=0) then goto skipend;
inc(xpos,4);
//.h
v.bytes[0]:=adata.bytes[xpos+0];
v.bytes[1]:=adata.bytes[xpos+1];
v.bytes[2]:=adata.bytes[xpos+2];
v.bytes[3]:=adata.bytes[xpos+3];
ah:=v.val;
if (ah<=0) then goto skipend;
//.multiplier

{$ifdef gui}
if xsyszoom then gui__zoom(aw,ah);
{$endif}

//successful
result:=true;
skipend:
except;end;
end;

function tea__info1(xtep:longint;xsyszoom:boolean;var aw,ah,aSOD,aversion,aval1,aval2:longint;var atransparent,asyscolors:boolean):boolean;//17jun2025, 25may2025
var
   xdata:tlistptr;
begin
{$ifdef gui}
tepfind(xtep,xdata);
result:=tea__info(xdata,xsyszoom,aw,ah,aSOD,aversion,aval1,aval2,atransparent,asyscolors);
{$else}
result      :=false;
aw          :=0;
ah          :=0;
aSOD        :=13;
aversion    :=1;
aval1       :=0;
aval2       :=0;
atransparent:=true;
asyscolors  :=true;
{$endif}
end;

function tea__info2(adata:tstr8;xsyszoom:boolean;var aw,ah,aSOD,aversion,aval1,aval2:longint;var atransparent,asyscolors:boolean):boolean;
begin
result:=tea__info3(@adata,xsyszoom,aw,ah,aSOD,aversion,aval1,aval2,atransparent,asyscolors);
end;

function tea__info3(adata:pobject;xsyszoom:boolean;var aw,ah,aSOD,aversion,aval1,aval2:longint;var atransparent,asyscolors:boolean):boolean;//18nov2024
label
   skipend;
var
   v:tint4;
   int1,xpos:longint;
begin
//defaults
result:=false;

try
aw:=0;
ah:=0;
aSOD:=13;
aversion:=1;
aval1:=0;
aval2:=0;
atransparent:=true;
asyscolors:=true;
//check
if (not str__lock(adata)) or (str__len(adata)<13) then goto skipend;
//get
//.header
int1:=str__bytes0(adata,3);
if (str__bytes0(adata,0)=uuT) and (str__bytes0(adata,1)=uuE) and (str__bytes0(adata,2)=uuA) and ( (int1=nn2) or (int1=nn3) ) and (str__bytes0(adata,4)=ssHash) then
   begin
   //init
   aSOD:=27;//zero based (27=28 bytes)
   xpos:=5;

   //version 2 = 24 bit color and version 3 = 32 bit color - 18nov2024
   if      (int1=nn2) then aversion:=2
   else if (int1=nn3) then aversion:=3
   else                    goto skipend;

   if (str__len(adata)<(aSOD+1)) then goto skipend;//1 based
   //transparent
   atransparent:=(str__bytes0(adata,xpos)<>0);
   inc(xpos,1);
   //syscolors -> black=font color, black+1=border color
   asyscolors:=(str__bytes0(adata,xpos)<>0);
   inc(xpos,1);
   //reserved 1-4
   inc(xpos,4);
   //val1
   v.bytes[0]:=str__bytes0(adata,xpos+0);
   v.bytes[1]:=str__bytes0(adata,xpos+1);
   v.bytes[2]:=str__bytes0(adata,xpos+2);
   v.bytes[3]:=str__bytes0(adata,xpos+3);
   inc(xpos,4);
   aval1:=v.val;
   //val2
   v.bytes[0]:=str__bytes0(adata,xpos+0);
   v.bytes[1]:=str__bytes0(adata,xpos+1);
   v.bytes[2]:=str__bytes0(adata,xpos+2);
   v.bytes[3]:=str__bytes0(adata,xpos+3);
   inc(xpos,4);
   aval2:=v.val;
   end
else if (str__bytes0(adata,0)=uuT) and (str__bytes0(adata,1)=uuE) and (str__bytes0(adata,2)=uuA) and (str__bytes0(adata,3)=nn1) and (str__bytes0(adata,4)=ssHash) then xpos:=5//TEA1#
else goto skipend;
//.w
v.bytes[0]:=str__bytes0(adata,xpos+0);
v.bytes[1]:=str__bytes0(adata,xpos+1);
v.bytes[2]:=str__bytes0(adata,xpos+2);
v.bytes[3]:=str__bytes0(adata,xpos+3);
aw:=v.val;
if (aw<=0) then goto skipend;
inc(xpos,4);
//.h
v.bytes[0]:=str__bytes0(adata,xpos+0);
v.bytes[1]:=str__bytes0(adata,xpos+1);
v.bytes[2]:=str__bytes0(adata,xpos+2);
v.bytes[3]:=str__bytes0(adata,xpos+3);
ah:=v.val;
if (ah<=0) then goto skipend;
//.multiplier

{$ifdef gui}
if xsyszoom then gui__zoom(aw,ah);
{$endif}

//successful
result:=true;
skipend:
except;end;
try;str__autofree(adata);except;end;
end;

function tea__draw(xcolorise,xsyszoom:boolean;dx,dy,dc,dc2:longint;xarea,xarea2:twinrect;d:tobject;xtea:tlistptr;xfocus,xgrey,xround:boolean;xroundstyle:longint):boolean;//curved corner support - 07may2020, 09apr2020, 29mar2020
var
   prows24:pcolorrows24;
   prows32:pcolorrows32;
begin
//defaults
result:=false;
try
if zznil(d,2206) then exit;
//init
if (d is tbasicimage) then//07mar2022
   begin
   prows24:=(d as tbasicimage).prows24;
   prows32:=(d as tbasicimage).prows32;
   end
else if (d is trawimage) then//25jul2024
   begin
   prows24:=(d as trawimage).prows24;
   prows32:=(d as trawimage).prows32;
   end
else if (d is twinbmp) then
   begin
   prows24:=(d as twinbmp).prows24;
   prows32:=(d as twinbmp).prows32;
   end
else exit;
//get
result:=tea__draw2(xcolorise,xsyszoom,dx,dy,dc,dc2,xarea,xarea2,misb(d),misw(d),mish(d),prows24,prows32,nil,nil,-1,xtea,xfocus,xgrey,xround,xroundstyle);
except;end;
end;

function tea__draw2(xcolorise,xsyszoom:boolean;dx,dy,dc,dc2:longint;xarea,xarea2:twinrect;dbits,dw,dh:longint;drows24:pcolorrows24;drows32:pcolorrows32;xmask,xbackmask:tmask8;xmaskval:longint;xtea:tlistptr;xfocus,xgrey,xround:boolean;xroundstyle:longint):boolean;//04dec2024: background mask support, 02aug204: div 256 faster, curved corner support - 13may2020, 07may2020, 09apr2020, 29mar2020
label//Note: now supports curved corners on clip area "xarea" - 09apr2020
     //Note: xsys=optional system color information, if present (xsys<>nil) then image colors are replaced with shades of the system colors - 10mar2021
     //02aug2024: div 256 for faster performance
   skipdone,skipend,zoomdraw,zoomredo5,redo5;
var
   a:twinrect;
   b5:tcolor40;//18nov2024
   vsize,xzoom,zx,zy,v,mbits,lx,rx,lx2,rx2,lx3,rx3,lx4,rx4,amin,p,yi,xi,xx,xw,xh,dd,xSOD,xversion,xval1,xval2:longint;
   bmr8,bmr82,bmr83,bmr84,mr8,mr82,mr83,mr84:pcolorrow8;//for mask support
   dr24,dr242,dr243,dr244:pcolorrow24;
   dr32,dr322,dr323,dr324:pcolorrow32;
   tmp24,ddc24,tc,xc,xc2:tcolor24;
   tmp32,ddc32:tcolor32;
   xcoloriseOK,finv,dreplaceblackOK,dreplaceblackOK2,xonce,xtransparent,xsyscolors:boolean;

   procedure x_sys;
   begin
   v:=(ddc24.r+ddc24.g+ddc24.b) div 3;
   if (v<100) then v:=100 else if (v>230) then v:=230;
   if finv then v:=255-v;//26mar2021
   ddc24.r:=((xc.r*v) + (xc2.r*(255-v))) div 256;//256 is faster thna 255
   ddc24.g:=((xc.g*v) + (xc2.g*(255-v))) div 256;
   ddc24.b:=((xc.b*v) + (xc2.b*(255-v))) div 256;
   end;

{
   procedure x_focus;
   const
      xval=40;//was: 30 - 29mar2020
   var
      int1:longint;
   begin
   //.r
   int1:=ddc24.r+xval;
   if (int1>255) then int1:=255;
   ddc24.r:=byte(int1);
   //.g
   int1:=ddc24.g+xval;
   if (int1>255) then int1:=255;
   ddc24.g:=byte(int1);
   //.b
   int1:=ddc24.b+xval;
   if (int1>255) then int1:=255;
   ddc24.b:=byte(int1);
   end;
}

   procedure xscan;
   begin
   case dbits of
   24:dr24:=drows24[yi];
   32:dr32:=drows32[yi];
   end;//case
   if (xmaskval>=0) then mr8:=xmask.prows8[yi];
   if (xbackmask<>nil) then bmr8:=xbackmask.prows8[yi];
   end;

   procedure xscan2;
   begin
   case dbits of
   24:begin
      if ((zy+0)>=xarea.top) and ((zy+0)<=xarea.bottom) then dr24:=drows24[zy];
      if ((zy+1)>=xarea.top) and ((zy+1)<=xarea.bottom) then dr242:=drows24[zy+1];
      if ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then dr243:=drows24[zy+2];
      if ((zy+3)>=xarea.top) and ((zy+3)<=xarea.bottom) then dr244:=drows24[zy+3];
      end;
   32:begin
      if ((zy+0)>=xarea.top) and ((zy+0)<=xarea.bottom) then dr32:=drows32[zy];
      if ((zy+1)>=xarea.top) and ((zy+1)<=xarea.bottom) then dr322:=drows32[zy+1];
      if ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then dr323:=drows32[zy+2];
      if ((zy+3)>=xarea.top) and ((zy+3)<=xarea.bottom) then dr324:=drows32[zy+3];
      end;
   end;//case
   if (xmaskval>=0) then
      begin
      if ((zy+0)>=xarea.top) and ((zy+0)<=xarea.bottom) then mr8:=xmask.prows8[zy+0];
      if (xzoom>=2) and ((zy+1)>=xarea.top) and ((zy+1)<=xarea.bottom) then mr82:=xmask.prows8[zy+1];
      if (xzoom>=3) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then mr83:=xmask.prows8[zy+2];
      if (xzoom>=4) and ((zy+3)>=xarea.top) and ((zy+3)<=xarea.bottom) then mr84:=xmask.prows8[zy+3];
      end;

   if (xbackmask<>nil) then
      begin
      if ((zy+0)>=xarea.top) and ((zy+0)<=xarea.bottom) then bmr8:=xbackmask.prows8[zy];
      if (xzoom>=2) and ((zy+1)>=xarea.top) and ((zy+1)<=xarea.bottom) then bmr82:=xbackmask.prows8[zy+1];
      if (xzoom>=3) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then bmr83:=xbackmask.prows8[zy+2];
      if (xzoom>=4) and ((zy+3)>=xarea.top) and ((zy+3)<=xarea.bottom) then bmr84:=xbackmask.prows8[zy+3];
      end;
   end;

   procedure dc24normal(dr24:pcolorrow24;xbmr8:pcolorrow8;x:longint);
   begin
   if (xbmr8<>nil) then backmask__exclude(xbmr8[x]);
   dr24[x]:=ddc24;
   end;

   procedure dc32normal(dr32:pcolorrow32;xbmr8:pcolorrow8;x:longint);
   begin
   if (xbmr8<>nil) then backmask__exclude(xbmr8[x]);
   dr32[x]:=ddc32;
   end;

   procedure mix24;
   begin
   tmp24:=dr24[xi];
   tmp24.r:=( (ddc24.r*b5.c) + (tmp24.r*(255-b5.c)) ) div 256;//div 256 is FASTER thatn 255
   tmp24.g:=( (ddc24.g*b5.c) + (tmp24.g*(255-b5.c)) ) div 256;
   tmp24.b:=( (ddc24.b*b5.c) + (tmp24.b*(255-b5.c)) ) div 256;
   if (bmr8<>nil) then backmask__exclude(bmr8[xi]);
   dr24[xi]:=tmp24;
   end;

   procedure mix32;
   begin
   tmp32:=dr32[xi];
   tmp32.r:=( (ddc24.r*b5.c) + (tmp32.r*(255-b5.c)) ) div 256;//div 256 is FASTER thatn 255
   tmp32.g:=( (ddc24.g*b5.c) + (tmp32.g*(255-b5.c)) ) div 256;
   tmp32.b:=( (ddc24.b*b5.c) + (tmp32.b*(255-b5.c)) ) div 256;
   tmp32.a:=255;
   if (bmr8<>nil) then backmask__exclude(bmr8[xi]);
   dr32[xi]:=tmp32;
   end;

   procedure zoommix24(var dr24:pcolorrow24;var xbmr8:pcolorrow8;x:longint);
   begin
   tmp24:=dr24[x];
   tmp24.r:=( (ddc24.r*b5.c) + (tmp24.r*(255-b5.c)) ) div 256;//div 256 is FASTER thatn 255
   tmp24.g:=( (ddc24.g*b5.c) + (tmp24.g*(255-b5.c)) ) div 256;
   tmp24.b:=( (ddc24.b*b5.c) + (tmp24.b*(255-b5.c)) ) div 256;
   if (xbmr8<>nil) then backmask__exclude(xbmr8[x]);
   dr24[x]:=tmp24;
   end;

   procedure zoommix32(var dr32:pcolorrow32;var xbmr8:pcolorrow8;x:longint);
   begin
   tmp32:=dr32[x];
   tmp32.r:=( (ddc24.r*b5.c) + (tmp32.r*(255-b5.c)) ) div 256;//div 256 is FASTER thatn 255
   tmp32.g:=( (ddc24.g*b5.c) + (tmp32.g*(255-b5.c)) ) div 256;
   tmp32.b:=( (ddc24.b*b5.c) + (tmp32.b*(255-b5.c)) ) div 256;
   tmp32.a:=255;
   if (xbmr8<>nil) then backmask__exclude(xbmr8[x]);
   dr32[x]:=tmp32;
   end;
begin
//defaults
result:=false;

try
//check image "d"
if (dw<1) or (dh<1) then exit;
case dbits of
24:if (drows24=nil) then exit;
32:if (drows32=nil) then exit;
else exit;
end;

//.zoom - optional
if xsyszoom then xzoom:=vizoom else xzoom:=1;

//check area
if (xarea.bottom<xarea.top) or (xarea.right<xarea.left) or (xarea.right<0) or (xarea.left>=dw) or (xarea.bottom<0) or (xarea.top>=dh) then exit;
if (xarea2.bottom<xarea2.top) or (xarea2.right<xarea2.left) or (xarea2.right<xarea.left) or (xarea2.left>xarea.right) or (xarea2.bottom<xarea.top) or (xarea2.top>xarea.bottom) then exit;

//check tea
if not tea__info(xtea,false,xw,xh,xSOD,xversion,xval1,xval2,xtransparent,xsyscolors) then exit;

case xversion of
3:begin//v3
   vsize       :=5;
   xtransparent:=false;//uses alpha channel instead of top-left pixel color
   end;
else vsize:=4;
end;//case

//check mask
if (xmaskval>=0) then
   begin
   if zznil(xmask,2207) or ((xmask.width<dw) or (xmask.height<dh)) then xmaskval:=-1;//off
   end;

//check back mask
if (xbackmask<>nil) and ((xbackmask.width<dw) or (xbackmask.height<dh)) then xbackmask:=nil;

//init
//.dreplaceblackOK
dreplaceblackOK  :=xsyscolors and (dc<>clnone);//(0,0,0) => dc.color
dreplaceblackOK2 :=xsyscolors and (dc2<>clnone);//(0,0,1) => dc2.color - 02mar2021
//.xc -> dual purpose: replace "0,0,0 => xc" and "0,0,1 => xc2" OR colorise by converting color pixels into shades of "xc ... xc2" - 27mar2021
xc:=int__c24(dc);
xc2:=int__c24(dc2);
xcoloriseOK:=xcolorise and (dc<>clnone) and (dc2<>clnone);
finv:=(int__brightness_aveb(c24a0__int(xc))<int__brightness_aveb(c24a0__int(xc2)));
//.amin
a:=xarea2;//used for calculating curved cornersretain original copy of "xarea" for calculations and reference
amin:=smallest32(low__sum32([a.bottom,-a.top,1]),low__sum32([a.right,-a.left,1]));
//.x
if (xarea.left<xarea2.left) then xarea.left:=xarea2.left;
xarea.left:=frcrange32(xarea.left,0,dw-1);
if (xarea.right>xarea2.right) then xarea.right:=xarea2.right;
xarea.right:=frcrange32(xarea.right,0,dw-1);
if (xarea.right<xarea.left) then exit;
//.y
if (xarea.top<xarea2.top) then xarea.top:=xarea2.top;
xarea.top:=frcrange32(xarea.top,0,dh-1);
if (xarea.bottom>xarea2.bottom) then xarea.bottom:=xarea2.bottom;
xarea.bottom:=frcrange32(xarea.bottom,0,dh-1);
if (xarea.bottom<xarea.top) then exit;
//.mbits
mbits:=dbits;
if (xmaskval>=0) then mbits:=mbits*10;
//get
bmr8 :=nil;
bmr82:=nil;
bmr83:=nil;
bmr84:=nil;
xonce:=true;
dd:=xSOD;//start of data
xx:=0;
xi:=dx;
yi:=dy;
zx:=dx;
zy:=dy;
//.switch
if (xzoom>=2) then goto zoomdraw;


//-- normal draw ---------------------------------------------------------------
//.scan
if (yi>=xarea.top) and (yi<=xarea.bottom) then xscan;
//.corner
low__cornersolid(true,a,amin,yi,xarea.left,xarea.right,xroundstyle,xround,lx,rx);

//version 1, 2 and 3:
redo5:
if ((dd+vsize-1)<xtea.count) then
   begin
   b5.r:=xtea.bytes[dd+0];
   b5.g:=xtea.bytes[dd+1];
   b5.b:=xtea.bytes[dd+2];
   b5.a:=xtea.bytes[dd+3];//not alpha BUT repeat count
   if (xversion=3) then b5.c:=xtea.bytes[dd+4] else b5.c:=255;//alpha value

   //.transparent color - top-left (first) pixel - version 1 and 2
   if xonce then
      begin
      tc.r:=b5.r;
      tc.g:=b5.g;
      tc.b:=b5.b;
      xonce:=false;
      end;

   if      xtransparent and (b5.r=tc.r) and (b5.g=tc.g) and (b5.b=tc.b) then b5.c:=0
   else if xgrey                                                        then b5.c:=b5.c div 3;


   //.draw pixels
   if (b5.a>=1) then for p:=1 to b5.a do
      begin
      //.don't draw transparent pixels
      if (yi>=xarea.top) and (yi<=xarea.bottom) and (xi>=lx) and (xi<=rx) and (b5.c>=1) then
         begin
         //get
         //.black -> user specified color "dc"
         if dreplaceblackOK and (b5.r=0) and (b5.g=0) and (b5.b=0) then ddc24:=xc
         else if dreplaceblackOK2 and (b5.r=0) and (b5.g=0) and (b5.b=1) then ddc24:=xc2//02mar2021
         //.all other colors applied "as is"
         else
            begin
            ddc24.r:=b5.r;
            ddc24.g:=b5.g;
            ddc24.b:=b5.b;
            if xcoloriseOK then x_sys;
            end;

         //set
//was:         if xfocus then x_focus;

         case mbits of
         24:mix24;
         240:if (mr8[xi]=xmaskval) then mix24;
         32:mix32;
         320:if (mr8[xi]=xmaskval) then mix32;
         end;//case
         end;//if

      inc(xx);
      xi:=xx+dx;
      if (xx>=xw) then
         begin
         inc(yi);
         if (yi>=xarea.top) and (yi<=xarea.bottom) then xscan;
         //.corner
         low__cornersolid(true,a,amin,yi,xarea.left,xarea.right,xroundstyle,xround,lx,rx);
         xx:=0;
         xi:=dx;
         end;
      end;//b5.a
   //.loop
   inc(dd,vsize);
   if ((dd+vsize-1)<xtea.count) and (yi<=xarea.bottom) then goto redo5;
   end;

goto skipdone;


//-- zoom draw -----------------------------------------------------------------
zoomdraw:
//.scan
xscan2;
//.corner
low__cornersolid(true,a,amin,yi,xarea.left,xarea.right,xroundstyle,xround,lx,rx);
if (xzoom>=2) then low__cornersolid(true,a,amin,zy+1,xarea.left,xarea.right,xroundstyle,xround,lx2,rx2);
if (xzoom>=3) then low__cornersolid(true,a,amin,zy+2,xarea.left,xarea.right,xroundstyle,xround,lx3,rx3);
if (xzoom>=4) then low__cornersolid(true,a,amin,zy+3,xarea.left,xarea.right,xroundstyle,xround,lx4,rx4);

//.version 1,2 and 3:
zoomredo5:
if ((dd+vsize-1)<xtea.count) then
   begin
   b5.r:=xtea.bytes[dd+0];
   b5.g:=xtea.bytes[dd+1];
   b5.b:=xtea.bytes[dd+2];
   b5.a:=xtea.bytes[dd+3];//not alpha BUT repeat count
   if (xversion=3) then b5.c:=xtea.bytes[dd+4] else b5.c:=255;//alpha value

   //.transparent color - top-left (first) pixel
   if xonce then
      begin
      tc.r:=b5.r;
      tc.g:=b5.g;
      tc.b:=b5.b;
      xonce:=false;
      end;

   if      xtransparent and (b5.r=tc.r) and (b5.g=tc.g) and (b5.b=tc.b) then b5.c:=0
   else if xgrey                                                        then b5.c:=b5.c div 3;

   //.draw pixels
   if (b5.a>=1) then for p:=1 to b5.a do
      begin
      //.don't draw transparent pixels (tc -> top-left pixel defined) - 03mar2018
      if (zy>=xarea.top) and (zy<=xarea.bottom) and (b5.c>=1) then
         begin
         //get
         //.black -> user specified color "dc"
         if dreplaceblackOK and (b5.r=0) and (b5.g=0) and (b5.b=0) then ddc24:=xc
         else if dreplaceblackOK2 and (b5.r=0) and (b5.g=0) and (b5.b=1) then ddc24:=xc2//02mar2021
         //.all other colors applied "as is"
         else
            begin
            ddc24.r:=b5.r;
            ddc24.g:=b5.g;
            ddc24.b:=b5.b;
            if xcoloriseOK then x_sys;
            end;
         //set

         //was: if xfocus then x_focus;

         case mbits of
         24:begin
            //y+0
            if (zx>=lx) and (zx<=rx)                        then zoommix24(dr24,bmr8,zx+0);
            if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) then zoommix24(dr24,bmr8,zx+1);
            if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) then zoommix24(dr24,bmr8,zx+2);
            if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) then zoommix24(dr24,bmr8,zx+3);
            //y+1
            if (xzoom>=2) and ((zy+1)>=xarea.top) and ((zy+1)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx)                        then zoommix24(dr242,bmr82,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) then zoommix24(dr242,bmr82,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) then zoommix24(dr242,bmr82,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) then zoommix24(dr242,bmr82,zx+3);
               end;
            //y+2
            if (xzoom>=3) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx)                        then zoommix24(dr243,bmr83,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) then zoommix24(dr243,bmr83,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) then zoommix24(dr243,bmr83,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) then zoommix24(dr243,bmr83,zx+3);
               end;
            //y+32
            if (xzoom>=4) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx)                        then zoommix24(dr244,bmr84,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) then zoommix24(dr244,bmr84,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) then zoommix24(dr244,bmr84,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) then zoommix24(dr244,bmr84,zx+3);
               end;
            end;//24
         240:begin
            //y+0
            if (zx>=lx) and (zx<=rx) and (mr8[zx]=xmaskval)                        then zoommix24(dr24,bmr8,zx+0);
            if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) and (mr8[zx]=xmaskval) then zoommix24(dr24,bmr8,zx+1);
            if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) and (mr8[zx]=xmaskval) then zoommix24(dr24,bmr8,zx+2);
            if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) and (mr8[zx]=xmaskval) then zoommix24(dr24,bmr8,zx+3);
            //y+1
            if (xzoom>=2) and ((zy+1)>=xarea.top) and ((zy+1)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx) and (mr8[zx]=xmaskval)                         then zoommix24(dr242,bmr82,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) and (mr82[zx]=xmaskval) then zoommix24(dr242,bmr82,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) and (mr82[zx]=xmaskval) then zoommix24(dr242,bmr82,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) and (mr82[zx]=xmaskval) then zoommix24(dr242,bmr82,zx+3);
               end;
            //y+2
            if (xzoom>=3) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx) and (mr8[zx]=xmaskval)                         then zoommix24(dr243,bmr83,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) and (mr83[zx]=xmaskval) then zoommix24(dr243,bmr83,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) and (mr83[zx]=xmaskval) then zoommix24(dr243,bmr83,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) and (mr83[zx]=xmaskval) then zoommix24(dr243,bmr83,zx+3);
               end;
            //y+32
            if (xzoom>=4) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx) and (mr8[zx]=xmaskval)                         then zoommix24(dr244,bmr84,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) and (mr84[zx]=xmaskval) then zoommix24(dr244,bmr84,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) and (mr84[zx]=xmaskval) then zoommix24(dr244,bmr84,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) and (mr84[zx]=xmaskval) then zoommix24(dr244,bmr84,zx+3);
               end;
            end;//240
         32:begin
            //y+0
            if (zx>=lx) and (zx<=rx)                        then zoommix32(dr32,bmr8,zx+0);
            if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) then zoommix32(dr32,bmr8,zx+1);
            if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) then zoommix32(dr32,bmr8,zx+2);
            if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) then zoommix32(dr32,bmr8,zx+3);
            //y+1
            if (xzoom>=2) and ((zy+1)>=xarea.top) and ((zy+1)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx)                        then zoommix32(dr322,bmr82,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) then zoommix32(dr322,bmr82,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) then zoommix32(dr322,bmr82,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) then zoommix32(dr322,bmr82,zx+3);
               end;
            //y+2
            if (xzoom>=3) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx)                        then zoommix32(dr323,bmr83,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) then zoommix32(dr323,bmr83,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) then zoommix32(dr323,bmr83,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) then zoommix32(dr323,bmr83,zx+3);
               end;
            //y+32
            if (xzoom>=4) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx)                        then zoommix32(dr324,bmr84,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) then zoommix32(dr324,bmr84,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) then zoommix32(dr324,bmr84,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) then zoommix32(dr324,bmr84,zx+3);
               end;
            end;//32
         320:begin
            //y+0
            if (zx>=lx) and (zx<=rx) and (mr8[zx]=xmaskval)                        then zoommix32(dr32,bmr8,zx+0);
            if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) and (mr8[zx]=xmaskval) then zoommix32(dr32,bmr8,zx+1);
            if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) and (mr8[zx]=xmaskval) then zoommix32(dr32,bmr8,zx+2);
            if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) and (mr8[zx]=xmaskval) then zoommix32(dr32,bmr8,zx+3);
            //y+1
            if (xzoom>=2) and ((zy+1)>=xarea.top) and ((zy+1)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx) and (mr8[zx]=xmaskval)                         then zoommix32(dr322,bmr82,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) and (mr82[zx]=xmaskval) then zoommix32(dr322,bmr82,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) and (mr82[zx]=xmaskval) then zoommix32(dr322,bmr82,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) and (mr82[zx]=xmaskval) then zoommix32(dr322,bmr82,zx+3);
               end;
            //y+2
            if (xzoom>=3) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx) and (mr8[zx]=xmaskval)                         then zoommix32(dr323,bmr83,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) and (mr83[zx]=xmaskval) then zoommix32(dr323,bmr83,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) and (mr83[zx]=xmaskval) then zoommix32(dr323,bmr83,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) and (mr83[zx]=xmaskval) then zoommix32(dr323,bmr83,zx+3);
               end;
            //y+32
            if (xzoom>=4) and ((zy+2)>=xarea.top) and ((zy+2)<=xarea.bottom) then
               begin
               if (zx>=lx) and (zx<=rx) and (mr8[zx]=xmaskval)                         then zoommix32(dr324,bmr84,zx+0);
               if (xzoom>=2) and ((zx+1)>=lx) and ((zx+1)<=rx) and (mr84[zx]=xmaskval) then zoommix32(dr324,bmr84,zx+1);
               if (xzoom>=3) and ((zx+2)>=lx) and ((zx+2)<=rx) and (mr84[zx]=xmaskval) then zoommix32(dr324,bmr84,zx+2);
               if (xzoom>=4) and ((zx+3)>=lx) and ((zx+3)<=rx) and (mr84[zx]=xmaskval) then zoommix32(dr324,bmr84,zx+3);
               end;
            end;//320
         end;//case
         end;//if

      inc(xx);
      //xi:=xx+dx;
      zx:=(xx*xzoom)+dx;//12mar2021
      if (xx>=xw) then
         begin
         inc(yi);
         zy:=((yi-dy)*xzoom)+dy;
         xscan2;
         //.corner
         low__cornersolid(true,a,amin,zy,xarea.left,xarea.right,xroundstyle,xround,lx,rx);
         if (xzoom>=2) then low__cornersolid(true,a,amin,zy+1,xarea.left,xarea.right,xroundstyle,xround,lx2,rx2);
         if (xzoom>=3) then low__cornersolid(true,a,amin,zy+2,xarea.left,xarea.right,xroundstyle,xround,lx3,rx3);
         if (xzoom>=4) then low__cornersolid(true,a,amin,zy+3,xarea.left,xarea.right,xroundstyle,xround,lx4,rx4);
         xx:=0;
         //xi:=dx;
         zx:=dx;
         end;
      end;//b5.a
   //.loop
   inc(dd,vsize);
   if ((dd+vsize-1)<xtea.count) and (yi<=xarea.bottom) then goto zoomredo5;
   end;

goto skipdone;


//successful
skipdone:
result:=true;
skipend:
except;end;
end;

function tea__torawdata24(xtea:tlistptr;xdata:tstr8;var xw,xh:longint):boolean;
begin
result:=tea__torawdata242(xtea,@xdata,xw,xh);
end;

function tea__torawdata242(xtea:tlistptr;xdata:pobject;var xw,xh:longint):boolean;
label
   skipend,redo;
var
   a:tint4;
   xdatalen,p,di,dd,xSOD,xversion,xval1,xval2:longint;
   xtransparent,xsyscolors:boolean;
begin
//defaults
result:=false;
try
xw:=0;
xh:=0;
//check
if (not str__lock(xdata)) or (not tea__info(xtea,false,xw,xh,xSOD,xversion,xval1,xval2,xtransparent,xsyscolors)) then goto skipend;

//init
str__clear(xdata);
str__setlen(xdata,xw*xh*3);//RGB
xdatalen:=str__len(xdata);

//get
dd:=xSOD;//start of data
di:=0;

redo:
if ((dd+3)<xtea.count) then
   begin
   a.bytes[0]:=xtea.bytes[dd+0];
   a.bytes[1]:=xtea.bytes[dd+1];
   a.bytes[2]:=xtea.bytes[dd+2];
   a.bytes[3]:=xtea.bytes[dd+3];
   //.get pixels
   if (a.a>=1) then
      begin
      for p:=1 to a.a do
      begin
      if ((di+2)<xdatalen) then
         begin
         str__setbytes0(xdata,di+0,a.r);
         str__setbytes0(xdata,di+1,a.g);
         str__setbytes0(xdata,di+2,a.b);
         end
      else break;
      end;//p
      end;//a.a
   //.loop
   inc(dd,4);
   if ((dd+3)<xtea.count) then goto redo;
   end;
//successful
result:=true;
skipend:
except;end;
try;str__uaf(xdata);except;end;
end;

function tea__TLpixel(xtea:tlistptr):longint;//top-left pixel of TEA image - 01aug2020
var
   int1,int2:longint;
begin
tea__TLpixel2(xtea,int1,int2,result);
end;

function tea__TLpixel2(xtea:tlistptr;var xw,xh,xcolor:longint):boolean;//top-left pixel of TEA image - 01aug2020
var
   a:tint4;
   dd,xSOD,xversion,xval1,xval2:longint;
   xtransparent,xsyscolors:boolean;
begin
//defaults
result:=false;

try
xw:=0;
xh:=0;
xcolor:=clnone;
//check
if (not tea__info(xtea,false,xw,xh,xSOD,xversion,xval1,xval2,xtransparent,xsyscolors)) then exit;
//get
dd:=xSOD;//start of data
if ((dd+3)<xtea.count) then
   begin
   a.bytes[0]:=xtea.bytes[dd+0];
   a.bytes[1]:=xtea.bytes[dd+1];
   a.bytes[2]:=xtea.bytes[dd+2];
   a.bytes[3]:=xtea.bytes[dd+3];
   //.get pixels
   if (a.a>=1) then xcolor:=rgba0__int(a.r,a.g,a.b);
   end;
//successful
result:=true;
except;end;
end;

function tea__copy(xtea:tlistptr;d:tbasicimage;var xw,xh:longint):boolean;//01may2025, 12dec2024, 18nov2024, 23may2020
label//Supports "d" in 8/24/32 bits
   redo4,redo5;
var
   a4:tint4;
   a5:tcolor40;
   tr,tg,tb,p,dd,dbits,dx,dy,dw,dh,xSOD,xversion,xval1,xval2:longint;
   xonce,xtransparent,xsyscolors,dhasai:boolean;
   dr8 :pcolorrow8;
   dr24:pcolorrow24;
   dr32:pcolorrow32;
   dc24:tcolor24;
   dc32:tcolor32;

   procedure dscan;
   begin
   case dbits of
   8: dr8 :=d.prows8[dy];
   24:dr24:=d.prows24[dy];
   32:dr32:=d.prows32[dy];
   end;
   end;
begin
//defaults
result:=false;

try
xw:=0;
xh:=0;
//check
if (not tea__info(xtea,false,xw,xh,xSOD,xversion,xval1,xval2,xtransparent,xsyscolors)) or (not misinfo82432(d,dbits,dw,dh,dhasai)) then exit;
//init
d.sizeto(xw,xh);
dw:=d.width;
dh:=d.height;
//get
dd:=xSOD;//start of data
dx:=0;
dy:=0;
tr:=-1;
tg:=-1;
tb:=-1;
xonce:=true;

dscan;

if (xversion=1) or (xversion=2) then
   begin
redo4:
if ((dd+3)<xtea.count) then
   begin
   a4.bytes[0]:=xtea.bytes[dd+0];
   a4.bytes[1]:=xtea.bytes[dd+1];
   a4.bytes[2]:=xtea.bytes[dd+2];
   a4.bytes[3]:=xtea.bytes[dd+3];
   //.get pixels
   if (a4.a>=1) then
      begin
      for p:=1 to a4.a do
      begin
      case dbits of
      8:begin
         if (a4.g>a4.r) then a4.r:=a4.g;
         if (a4.b>a4.r) then a4.r:=a4.b;
         dr8[dx]:=a4.r;
         end;
      24:begin
         dc24.r:=a4.r;
         dc24.g:=a4.g;
         dc24.b:=a4.b;
         dr24[dx]:=dc24;
         end;
      32:begin
         if xonce then
            begin
            xonce:=false;
            tr:=a4.r;
            tg:=a4.g;
            tb:=a4.b;
            end;
         dc32.r:=a4.r;
         dc32.g:=a4.g;
         dc32.b:=a4.b;
         if (tr=a4.r) and (tg=a4.g) and (tb=a4.b) then dc32.a:=0 else dc32.a:=255;//embed transparency into alpha channel - 01may2025
         dr32[dx]:=dc32;
         end;
      end;//case
      //.inc
      inc(dx);
      if (dx>=xw) then
         begin
         dx:=0;
         inc(dy);
         if (dy>=xh) then break;
         dscan;
         end;
      end;//p
      end;//a4.a
   //.loop
   inc(dd,4);
   if ((dd+3)<xtea.count) then goto redo4;
   end;
   end

else if (xversion=3) then
   begin
redo5:
if ((dd+4)<xtea.count) then
   begin
   a5.r:=xtea.bytes[dd+0];
   a5.g:=xtea.bytes[dd+1];
   a5.b:=xtea.bytes[dd+2];
   a5.a:=xtea.bytes[dd+3];//not alpha BUT repeat count
   a5.c:=xtea.bytes[dd+4];//alpha value
   //.get pixels
   if (a5.a>=1) then
      begin
      for p:=1 to a5.a do
      begin
      case dbits of
      8:begin
         if (a5.g>a5.r) then a5.r:=a5.g;
         if (a5.b>a5.r) then a5.r:=a5.b;
         dr8[dx]:=a5.r;
         end;
      24:begin
         dc24.r:=a5.r;
         dc24.g:=a5.g;
         dc24.b:=a5.b;
         dr24[dx]:=dc24;
         end;
      32:begin
         dc32.r:=a5.r;
         dc32.g:=a5.g;
         dc32.b:=a5.b;
         dc32.a:=a5.c;
         dr32[dx]:=dc32;
         end;
      end;//case
      //.inc
      inc(dx);
      if (dx>=xw) then
         begin
         dx:=0;
         inc(dy);
         if (dy>=xh) then break;
         dscan;
         end;
      end;//p
      end;//a5.a
   //.loop
   inc(dd,5);
   if ((dd+4)<xtea.count) then goto redo5;
   end;
   end;

//xtransparent
d.ai.transparent:=xtransparent;//07apr2021
d.ai.syscolors:=xsyscolors;//13apr2021
d.ai.bpp:=low__aorb(24,32,xversion=3);//12dec2024
//successful
result:=true;
except;end;
end;

function tea__fromdata(d:tobject;sdata:pobject;var xw,xh:longint):boolean;
begin
result:=tea__fromdata32(d,sdata,xw,xh);
end;

function tea__fromdata32(d:tobject;sdata:pobject;var xw,xh:longint):boolean;
label//Supports "d" in 8/24/32 bits
   skipend,redo4,redo5;
var
   a4:tint4;
   a5:tcolor40;
   slen,p,dd,dbits,dx,dy,xSOD,xversion,xval1,xval2:longint;
   dr8 :pcolorrow8;
   dr24:pcolorrow24;
   dr32:pcolorrow32;
   dc24:tcolor24;
   dc32:tcolor32;
   xtransparent,xsyscolors:boolean;
begin
//defaults
result:=false;
xw:=0;
xh:=0;
try
//check
if not str__lock(sdata) then goto skipend;
if not tea__info3(sdata,false,xw,xh,xSOD,xversion,xval1,xval2,xtransparent,xsyscolors) then goto skipend;
//size
if not missize(d,xw,xh) then goto skipend;
if not misok82432(d,dbits,xw,xh) then goto skipend;
//get
slen:=str__len(sdata);
dd:=xSOD;//start of data
dx:=0;
dy:=0;
if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;

//.recsize = 4 bytes
if (xversion=1) or (xversion=2) then
   begin
redo4:
if ((dd+3)<slen) then
   begin
   a4.bytes[0]:=str__bytes0(sdata,dd+0);
   a4.bytes[1]:=str__bytes0(sdata,dd+1);
   a4.bytes[2]:=str__bytes0(sdata,dd+2);
   a4.bytes[3]:=str__bytes0(sdata,dd+3);
   //.get pixels
   if (a4.a>=1) then
      begin
      for p:=1 to a4.a do
      begin
      case dbits of
      8:begin
         if (a4.g>a4.r) then a4.r:=a4.g;
         if (a4.b>a4.r) then a4.r:=a4.b;
         dr8[dx]:=a4.r;
         end;
      24:begin
         dc24.r:=a4.r;
         dc24.g:=a4.g;
         dc24.b:=a4.b;
         dr24[dx]:=dc24;
         end;
      32:begin
         dc32.r:=a4.r;
         dc32.g:=a4.g;
         dc32.b:=a4.b;
         dc32.a:=255;
         dr32[dx]:=dc32;
         end;
      end;//case
      //.inc
      inc(dx);
      if (dx>=xw) then
         begin
         dx:=0;
         inc(dy);
         if (dy>=xh) then break;
         if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;
         end;
      end;//p
      end;//a4.a
   //.loop
   inc(dd,4);
   if ((dd+3)<slen) then goto redo4;
   end;
   end

else if (xversion=3) then
   begin
//.recsize = 5 bytes
redo5:
if ((dd+4)<slen) then
   begin
   a5.r:=str__bytes0(sdata,dd+0);
   a5.g:=str__bytes0(sdata,dd+1);
   a5.b:=str__bytes0(sdata,dd+2);
   a5.a:=str__bytes0(sdata,dd+3);//not alpha BUT repeat count
   a5.c:=str__bytes0(sdata,dd+4);//alpha value

   //.get pixels
   if (a5.a>=1) then
      begin
      for p:=1 to a5.a do
      begin
      case dbits of
      8:begin
         if (a5.g>a5.r) then a5.r:=a5.g;
         if (a5.b>a5.r) then a5.r:=a5.b;
         dr8[dx]:=a5.r;
         end;
      24:begin
         dc24.r:=a5.r;
         dc24.g:=a5.g;
         dc24.b:=a5.b;
         dr24[dx]:=dc24;
         end;
      32:begin
         dc32.r:=a5.r;
         dc32.g:=a5.g;
         dc32.b:=a5.b;
         dc32.a:=a5.c;//18nov2024
         dr32[dx]:=dc32;
         end;
      end;//case
      //.inc
      inc(dx);
      if (dx>=xw) then
         begin
         dx:=0;
         inc(dy);
         if (dy>=xh) then break;
         if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;
         end;
      end;//p
      end;//a5.a
   //.loop
   inc(dd,5);
   if ((dd+4)<slen) then goto redo5;
   end;
   end;

//xtransparent
misai(d).transparent:=xtransparent;//07apr2021
misai(d).syscolors:=xsyscolors;//13apr2021
//successful
result:=true;
skipend:
except;end;
try;str__uaf(sdata);except;end;
end;

//ia procs ---------------------------------------------------------------------

procedure ia__useroptions_suppress(xall:boolean;xformatmask:string);//use to disable (hide) certain format options in the save as dialog window - 21dec2024
begin
system_ia_useroptions_suppress_all:=xall;
system_ia_useroptions_suppress_masklist:=xformatmask;
end;

procedure ia__useroptions_suppress_clear;
begin
system_ia_useroptions_suppress_all:=false;
system_ia_useroptions_suppress_masklist:='';
end;

procedure ia__useroptions(xinit,xget:boolean;ximgext:string;var xlistindex,xlistcount:longint;var xlabel,xhelp,xaction:string);

   function m(xext:string):boolean;//image ext match
   begin
   result:=strmatch(xext,ximgext);
   end;

   procedure dcount(dcount:longint);
   begin
   xlistcount:=frcmin32(dcount,0);
   xlistindex:=frcrange32(xlistindex,0,frcmin32(xlistcount-1,0));
   end;

   procedure i(dlabel:string;dactlist:array of string);//info
   begin
   xlabel:=dlabel;
   xhelp:='';
   xaction:=ia__addlist('',dactlist);
   end;

   procedure i2(dlabel:string;dactlist:array of string;dhelp:string);//info - 28dec2024
   begin
   xlabel:=dlabel;
   xhelp:=dhelp;
   xaction:=ia__addlist('',dactlist);
   end;

   function f:string;//filename
   begin
   result:=app__settingsfile(ximgext+'.ia');
   end;

   function getindex:longint;
   var
      e:string;
   begin
   result:=strint32(io__fromfilestrb(f,e));
   end;

   procedure setindex(x:longint);
   var
      e:string;
   begin
   io__tofilestr(f, intstr32( frcrange32(x,0,frcmin32(xlistcount-1,0)) ),e);
   end;
begin
try
//suppression check - all
if system_ia_useroptions_suppress_all then
   begin
   dcount(0);
   i('-',['']);
   exit;
   end;
//suppression check - by complex masklist (ximgext requires a leading "." dot to match in the mask)
if (system_ia_useroptions_suppress_masklist<>'') and low__matchmasklist('.'+ximgext,system_ia_useroptions_suppress_masklist) then
   begin
   dcount(0);
   i('-',['']);
   exit;
   end;

//init
if xinit then xlistindex:=getindex;//get listindex from disk for this image format

//get
if m('tga') then
   begin
   dcount(8);
   case xlistindex of
   0:i2('Default'                     ,['']                       ,'Default');
   1:i2('Best'                        ,[ia_tga_best]              ,'Best quality');
   2:i2('32bit Color RLE'             ,[ia_tga_32bpp,ia_tga_RLE]  ,'Compressed 32bit color image');
   3:i2('32bit Color'                 ,[ia_tga_32bpp,ia_tga_noRLE],'Uncompressed 32bit color image');
   4:i2('24bit Color RLE'             ,[ia_tga_24bpp,ia_tga_RLE]   ,'Compressed 24bit color image');
   5:i2('24bit Color'                 ,[ia_tga_24bpp,ia_tga_noRLE] ,'Uncompressed 24bit color image');
   6:i2('8bit Grey RLE'               ,[ia_tga_8bpp,ia_tga_RLE]    ,'Compressed 8bit greyscale image');
   7:i2('8bit Grey'                   ,[ia_tga_8bpp,ia_tga_noRLE]  ,'Uncompressed 8bit greyscale image');
   end;//case
   end
else if m('jpg') or m('jif') or m('jpeg') then
   begin
   dcount(6);
   case xlistindex of
   0:i2('Default'                     ,['']                        ,'Default');
   1:i2('Best'                        ,[ia_bestquality]            ,'Best image quality');
   2:i2('High'                        ,[ia_highquality]            ,'High image quality');
   3:i2('Good'                        ,[ia_goodquality]            ,'Good image quality');
   4:i2('Fair'                        ,[ia_fairquality]            ,'Fair image quality');
   5:i2('Low'                         ,[ia_lowquality]             ,'Low image quality');
   end;//case
   end
else if m('ppm') then
   begin
   dcount(3);
   case xlistindex of
   0:i2('Default'                     ,['']                       ,'Default');
   1:i2('Binary'                      ,[ia_ppm_binary]            ,'Binary image | Smaller file size than ascii');
   2:i2('Ascii'                       ,[ia_ppm_ascii]             ,'Ascii image | Larger file size than binary but can be edited in a text editor');
   end;//case
   end
else if m('pgm') then
   begin
   dcount(3);
   case xlistindex of
   0:i2('Default'                     ,['']                       ,'Default');
   1:i2('Binary'                      ,[ia_pgm_binary]            ,'Binary image | Smaller file size than ascii');
   2:i2('Ascii'                       ,[ia_pgm_ascii]             ,'Ascii image | Larger file size than binary but can be edited in a text editor');
   end;//case
   end
else if m('pbm') then
   begin
   dcount(3);
   case xlistindex of
   0:i2('Default'                     ,['']                       ,'Default');
   1:i2('Binary'                      ,[ia_pbm_binary]            ,'Binary image | Smaller file size than ascii');
   2:i2('Ascii'                       ,[ia_pbm_ascii]             ,'Ascii image | Larger file size than binary but can be edited in a text editor');
   end;//case
   end
else if m('pnm') then
   begin
   dcount(3);
   case xlistindex of
   0:i2('Default'                     ,['']                       ,'Default');
   1:i2('Binary'                      ,[ia_pnm_binary]            ,'Binary image | Smaller file size than ascii');
   2:i2('Ascii'                       ,[ia_pnm_ascii]             ,'Ascii image | Larger file size than binary but can be edited in a text editor');
   end;//case
   end
else
   begin
   dcount(0);
   i('-',['']);
   end;

//set -> store listindex to disk for next time
if (not xget) then setindex(xlistindex);
except;end;
end;

function ia__add(xactions,xnewaction:string):string;
begin
result:=xactions+insstr(ia_sep,xactions<>'')+xnewaction;
end;

function ia__addlist(xactions:string;xlistofnewactions:array of string):string;
var
   p:longint;
   v:string;
begin
//init
result:=xactions;

//get
for p:=0 to high(xlistofnewactions) do
begin
v:=xlistofnewactions[p];
if (v<>'') then result:=ia__add(result,v);
end;
end;

function ia__preadd(xactions,xnewaction:string):string;
begin
result:=xnewaction+insstr(ia_sep,xactions<>'')+xactions;
end;

function ia__sadd(xactions,xnewaction:string;xvals:array of string):string;//name+vals(string)
var
   p:longint;
   v:string;
begin
result:=xactions;
if (xnewaction<>'') then
   begin
   result:=result+insstr(ia_sep,result<>'')+xnewaction;

   for p:=0 to high(xvals) do
   begin
   //filter
   v:=xvals[p];
   low__remchar(v,ia_sep);
   low__remchar(v,ia_valsep);
   //set
   result:=result+ia_valsep+v;
   end;

   end;
end;

function ia__spreadd(xactions,xnewaction:string;xvals:array of string):string;//name+vals(string)
var
   p:longint;
   xdata,v:string;
begin
result:=xactions;
if (xnewaction<>'') then
   begin
   xdata:=xnewaction;

   for p:=0 to high(xvals) do
   begin
   //filter
   v:=xvals[p];
   low__remchar(v,ia_sep);
   low__remchar(v,ia_valsep);
   //set
   xdata:=xdata+ia_valsep+v;
   end;

   result:=xdata+insstr(ia_sep,result<>'')+result;
   end;
end;

function ia__iadd(xactions,xnewaction:string;xvals:array of longint):string;//name+vals(longint)
var
   p:longint;
begin
result:=xactions;
if (xnewaction<>'') then
   begin
   result:=result+insstr(ia_sep,result<>'')+xnewaction;
   for p:=0 to high(xvals) do result:=result+ia_valsep+intstr32(xvals[p]);
   end;
end;

function ia__iadd64(xactions,xnewaction:string;xvals:array of comp):string;//name+vals(comp)
var
   p:longint;
begin
result:=xactions;
if (xnewaction<>'') then
   begin
   result:=result+insstr(ia_sep,result<>'')+xnewaction;
   for p:=0 to high(xvals) do result:=result+ia_valsep+intstr64(xvals[p]);
   end;
end;

function ia__ipreadd(xactions,xnewaction:string;xvals:array of longint):string;//name+vals(longint)
var
   p:longint;
   xdata:string;
begin
result:=xactions;
if (xnewaction<>'') then
   begin
   xdata:=xnewaction;

   for p:=0 to high(xvals) do xdata:=xdata+ia_valsep+intstr32(xvals[p]);

   result:=xdata+insstr(ia_sep,result<>'')+result;
   end;
end;

function ia__ipreadd64(xactions,xnewaction:string;xvals:array of comp):string;//name+vals(comp)
var
   p:longint;
   xdata:string;
begin
result:=xactions;
if (xnewaction<>'') then
   begin
   xdata:=xnewaction;

   for p:=0 to high(xvals) do xdata:=xdata+ia_valsep+intstr64(xvals[p]);

   result:=xdata+insstr(ia_sep,result<>'')+result;
   end;
end;

function ia__found(xactions,xfindname:string):boolean;
begin
result:=ia__ok(xactions,xfindname);
end;

function ia__ok(xactions,xfindname:string):boolean;
var
   v:array[0..9] of string;
begin
result:=ia__find(xactions,xfindname,v);
end;

function ia__sfindval(xactions,xfindname:string;xvalindex:longint;xdefval:string;var xout:string):boolean;
var
   svals:array[0..9] of string;
begin
result:=ia__sfind(xactions,xfindname,svals);

case result and (xvalindex>=0) and (xvalindex<=high(svals)) of
true:xout:=strdefb(svals[xvalindex],xdefval);
else xout:=xdefval;
end;
end;

function ia__ifindval(xactions,xfindname:string;xvalindex,xdefval:longint;var xout:longint):boolean;
var
   svals:array[0..9] of string;
begin
result:=ia__sfind(xactions,xfindname,svals);

case result and (xvalindex>=0) and (xvalindex<=high(svals)) of
true:xout:=strint(strdefb(svals[xvalindex],intstr32(xdefval)));
else xout:=xdefval;
end;
end;

function ia__ifindval64(xactions,xfindname:string;xvalindex:longint;xdefval:comp;var xout:comp):boolean;
var
   svals:array[0..9] of string;
begin
result:=ia__sfind(xactions,xfindname,svals);

case result and (xvalindex>=0) and (xvalindex<=high(svals)) of
true:xout:=strint64(strdefb(svals[xvalindex],intstr64(xdefval)));
else xout:=xdefval;
end;
end;

function ia__bfindval(xactions,xfindname:string;xvalindex:longint;xdefval:boolean;var xout:boolean):boolean;//04aug2024
var
   svals:array[0..9] of string;
begin
result:=ia__sfind(xactions,xfindname,svals);

case result and (xvalindex>=0) and (xvalindex<=high(svals)) of
true:xout:=strbol(strdefb(svals[xvalindex],bnc(xdefval)));
else xout:=xdefval;
end;
end;

function ia__ifindvalb(xactions,xfindname:string;xvalindex,xdefval:longint):longint;
begin
ia__ifindval(xactions,xfindname,xvalindex,xdefval,result);
end;

function ia__ifindval64b(xactions,xfindname:string;xvalindex:longint;xdefval:comp):comp;
begin
ia__ifindval64(xactions,xfindname,xvalindex,xdefval,result);
end;

function ia__sfindvalb(xactions,xfindname:string;xvalindex:longint;xdefval:string):string;
begin
ia__sfindval(xactions,xfindname,xvalindex,xdefval,result);
end;

function ia__sfind(xactions,xfindname:string;var xvals:array of string):boolean;
begin
result:=ia__find(xactions,xfindname,xvals);
end;

function ia__ifind(xactions,xfindname:string;var xvals:array of longint):boolean;
var
   p:longint;
   svals:array[0..9] of string;
begin
//init
for p:=0 to high(xvals) do xvals[p]:=0;

//get
result:=ia__find(xactions,xfindname,svals);
if result then
   begin
   for p:=0 to smallest32(high(svals),high(xvals)) do xvals[p]:=strint(svals[p]);
   end;
end;

function ia__ifind64(xactions,xfindname:string;var xvals:array of comp):boolean;
var
   p:longint;
   svals:array[0..9] of string;
begin
//init
for p:=0 to high(xvals) do xvals[p]:=0;

//get
result:=ia__find(xactions,xfindname,svals);
if result then
   begin
   for p:=0 to smallest32(high(svals),high(xvals)) do xvals[p]:=strint64(svals[p]);
   end;
end;

function ia__find(xactions,xfindname:string;var xvals:array of string):boolean;
var
   fn,fv,n,v,z:string;
   xlen,zlen,lp,p,zp:longint;
   c:char;

   procedure xreadvals(x:string);
   var
      vc,xlen,lp,p:longint;
      v:string;
      c:char;
   begin
   //init
   vc:=0;
   xlen:=low__len(x);

   //check
   if (xlen<=0) then exit;

   //get
   lp:=1;
   for p:=1 to xlen do
   begin
   c:=x[p-1+stroffset];
   if (c=ia_valsep) or (p=xlen) then
      begin
      if (vc>high(xvals)) then break;
      v:=strcopy1(x,lp,p-lp+low__insint(1,(p=xlen)));
      xvals[vc]:=v;
      //inc
      inc(vc);
      lp:=p+1;
      end;
   end;//p
   end;
begin
//defaults
result:=false;

//init
for p:=0 to high(xvals) do xvals[p]:='';

//special
if (xfindname='') then
   begin
   result:=true;
   exit;
   end;

//check
xlen:=low__len(xactions);
if (xlen<=0) then exit;

//split name -> some actions have values as part of their name in order to share multiple different value types, such as quality:100: or quality:5 or quality:best
fn:=xfindname;
fv:='';
for p:=1 to low__len(fn) do if (fn[p-1+stroffset]=ia_valsep) then
   begin
   fn:=strcopy1(fn,1,p-1);
   fv:=strcopy1(xfindname,p+1,low__len(xfindname));
   break;
   end;

//find -> work from last to first -> most recent value is at end
lp:=xlen;
for p:=xlen downto 1 do
begin
c:=xactions[p-1+stroffset];

if (c=ia_sep) or (p=1)then
   begin
   //extract last action -> first action
   if (c=ia_sep) then z:=strcopy1(xactions,p+1,lp-p) else z:=strcopy1(xactions,p,lp-p+1);
   zlen:=low__len(z);

   //examine extracted action
   if (zlen>=1) then
      begin
      //split action into name and values (yes a name can have values too)
      n:=z;
      v:='';

      for zp:=1 to zlen do
      begin
      c:=z[zp-1+stroffset];
      if (c=ia_valsep) or (zp=zlen) then
         begin
         n:=strcopy1(z,1,zp-low__insint(1,(zp<>zlen)));
         v:=strcopy1(z,low__len(n)+2,zlen);
         break;
         end;
      end;//p2

      //match base name -> we now stop after this point, only difference is whether it's TRUE (name vals match if any) or FALSE (no match)
      if strmatch(n,fn) then
         begin
         result:=strmatch(fv,strcopy1(v,1,low__len(fv)));
         if result then
            begin
            //read values from the end of the xfindname (e.g. past it's base name and it's name's vals)
            xreadvals( strcopy1(v,low__len(fv)+low__insint(2,fv<>''),low__len(v)) );
            end;

         //stop
         break;
         end;
      end;

   //lp
   lp:=frcmin32(p-1,0);
   end;

end;//p
end;


//img32 procs ------------------------------------------------------------------
function img32__fromdata(s:tobject;d:pobject;var e:string):boolean;
var
   scellwidth,scellheight,scellcount,sdelayms:longint;
begin
result:=img32__fromdata2(s,d,scellwidth,scellheight,scellcount,sdelayms,e);
end;

function img32__fromdata2(s:tobject;d:pobject;var scellwidth,scellheight,scellcount,sdelayms:longint;var e:string):boolean;
label
   skipend;
var
   xstartpos,sx,dx,dy,i,sbits,sw,sh,cw,ch,cc,cms:longint;
   ci:tbasicimage;
   cb:tstr8;
   sr32,dr32:pcolorrow32;
   sr24     :pcolorrow24;
   sr8      :pcolorrow8;
   c24:tcolor24;
   c32:tcolor32;
begin
//defaults
result:=false;
e:=gecTaskfailed;
ci:=nil;
cb:=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;
if (str__len(d)<22) then
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;

//read header (22 b)
if not str__asame3(d,0,[lli,llm,llg,nn3,nn2,sscolon],false) then//6 b
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;

//info
cw:=str__int4(d,6);
ch:=str__int4(d,6+4);
cc:=str__int4(d,6+4+4);
cms:=str__int4(d,6+4+4+4);
xstartpos:=22;

//check
if (cw<1) or (ch<1) or (cc<1) then
   begin
   e:=gecDatacorrupt;
   goto skipend;
   end;
if (cms<0) then cms:=0;

if (mult64(mult64(cc,cw),mult64(ch,4))>str__len(d)) then
   begin
   e:=gecDatacorrupt;
   goto skipend;
   end;

//size
if not missize(s,cc*cw,ch) then
   begin
   e:=gecOutofmemory;
   goto skipend;
   end;
sw:=misw(s);
sh:=mish(s);
misaiclear2(s);

//cells
ci:=misimg32(cw,ch);
cb:=str__new8;//cell buffer

//.cell
for i:=0 to (cc-1) do
begin
str__clear(@cb);
str__add3(@cb,d,xstartpos+(i*cw*ch*4),cw*ch*4);
ci.setraw(32,cw,ch,cb);

//.dy
for dy:=0 to (ch-1) do
begin
if not misscan82432(s,dy,sr8,sr24,sr32) then goto skipend;
if not misscan32(ci,dy,dr32) then goto skipend;

//.dx
sx:=i*cw;
for dx:=0 to (cw-1) do
begin
if (sx>=0) and (sx<sw) then
   begin
   c32:=dr32[dx];//from cell

   case sbits of
   32:sr32[sx]:=c32;
   24:begin
      c24.r:=c32.r;
      c24.g:=c32.g;
      c24.b:=c32.b;
      sr24[sx]:=c24;
      end;
   8:begin
      if (c32.g>c32.r) then c32.r:=c32.g;
      if (c32.b>c32.r) then c32.r:=c32.b;
      sr8[sx]:=c32.r;
      end;
   end;//case
   end;
inc(sx);
end;//dx
end;//dy
end;//i

//ai information
misai(s).count:=cc;
misai(s).cellwidth:=cw;
misai(s).cellheight:=ch;
misai(s).delay:=cms;
misai(s).transparent:=false;//alpha channel is used instead (if supplied image was 32bit)
misai(s).bpp:=32;

//successful
result:=true;
skipend:
except;end;
try
str__uaf(d);
str__free(@cb);
freeobj(@ci);
except;end;
end;

function img32__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=img32__todata2(s,d,'',e);
end;

function img32__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=img32__todata3(s,d,daction,e);
end;

function img32__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
label
   skipend;
var
   int1,sx,dx,dy,i,sbits,sw,sh,cw,ch,cc,cms:longint;
   ci:tbasicimage;
   sr32,dr32:pcolorrow32;
   sr24     :pcolorrow24;
   sr8      :pcolorrow8;
   c8:tcolor8;
   c24:tcolor24;
   c32:tcolor32;
   xbytes_image,xbytes_mask:longint;
begin
//defaults
result:=false;
e:=gecTaskfailed;
ci:=nil;
xbytes_image:=0;
xbytes_mask:=0;
cc:=0;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
str__clear(d);

//info
if ia__ifindval(daction,ia_cellcount,0,1,int1) then cc:=frcmin32(int1,0)  else cc:=misai(s).count;
if ia__ifindval(daction,ia_delay,0,500,int1)   then cms:=frcmin32(int1,0) else cms:=misai(s).delay;//paint delay

if (cms<=0) then cms:=0;//static
if (cc<=0)  then cc:=1;
cw:=frcmin32(sw div cc,1);
ch:=sh;

//header (22 b)
str__aadd(d,[lli,llm,llg,nn3,nn2,sscolon]);// "img32:"
str__addint4(d,cw);//cell width
str__addint4(d,ch);//cell height
str__addint4(d,cc);//cell count
str__addint4(d,cms);//cell delay

//cells
ci:=misimg32(cw,ch);

//.cell
for i:=0 to (cc-1) do
begin

//.dy
for dy:=0 to (ch-1) do
begin
if not misscan82432(s,dy,sr8,sr24,sr32) then goto skipend;
if not misscan32(ci,dy,dr32) then goto skipend;

//.dx
sx:=i*cw;
for dx:=0 to (cw-1) do
begin
if (sx>=0) and (sx<sw) then
   begin
   case sbits of
   32:c32:=sr32[sx];
   24:begin
      c24:=sr24[sx];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      c32.a:=255;
      end;
   8:begin
      c8:=sr8[sx];
      c32.r:=c8;
      c32.g:=c8;
      c32.b:=c8;
      c32.a:=255;
      end;
   end;//case
   end
else
   begin//black and transparent
   c32.r:=0;
   c32.g:=0;
   c32.b:=0;
   c32.a:=0;
   end;

dr32[dx]:=c32;
inc(sx);
end;//dx

end;//dy

inc(xbytes_image,cw*ch*3);
inc(xbytes_mask,cw*ch);

str__add(d,cache__ptr(ci.data));
end;//i

//successful
result:=true;
skipend:
except;end;
try
//send back data
daction:=ia__iadd(daction,ia_info_quality,[100]);
daction:=ia__iadd(daction,ia_info_cellcount,[low__aorb(0,cc,result)]);
daction:=ia__iadd(daction,ia_info_bytes_image,[xbytes_image]);
daction:=ia__iadd(daction,ia_info_bytes_mask,[xbytes_mask]);
//free
if (not result) then str__clear(d);
str__uaf(d);
freeobj(@ci);
except;end;
end;


//transparent jpeg procs -------------------------------------------------------
function tj32__fromdata(s:tobject;d:pobject;var e:string):boolean;
var
   scellwidth,scellheight,scellcount,sdelayms:longint;
begin
result:=tj32__fromdata2(s,d,scellwidth,scellheight,scellcount,sdelayms,e);
end;

function tj32__fromdata2(s:tobject;d:pobject;var scellwidth,scellheight,scellcount,sdelayms:longint;var e:string):boolean;
label
   skipend;
var
   dlen,xstartpos,sx,dx,dy,i,sbits,sw,sh,cw,ch,cc,cms:longint;
   ci:trawimage;
   cd:tstr8;
   sr32,dr32:pcolorrow32;
   sr24     :pcolorrow24;
   sr8      :pcolorrow8;
   c24:tcolor24;
   c32:tcolor32;

   function xpullchunk:boolean;
   var
      xlen:longint;
   begin
   //defaults
   result:=false;

   //init
   str__clear(@cd);

   xlen:=str__int4(d,xstartpos);
   inc(xstartpos,4);

   //get
   if (add64(xstartpos,xlen)<=dlen) and str__add3(@cd,d,xstartpos,xlen) then
      begin
      inc(xstartpos,xlen);
      result:=true;
      end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;
ci:=nil;
cd:=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

{$ifdef jpeg}

dlen:=str__len(d);
if (dlen<22) then
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;

//read header (22 b)
if not str__asame3(d,0,[llt,llj,nn3,nn2,sscolon,sscolon],false) then//6 b
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;

//info
cw       :=str__int4(d,6);
ch       :=str__int4(d,6+4);
cc       :=str__int4(d,6+4+4);
cms      :=str__int4(d,6+4+4+4);
xstartpos:=22;

//check
if (cw<1) or (ch<1) or (cc<1) then
   begin
   e:=gecDatacorrupt;
   goto skipend;
   end;
if (cms<0) then cms:=0;

//size
if not missize(s,cc*cw,ch) then
   begin
   e:=gecOutofmemory;
   goto skipend;
   end;
sw:=misw(s);
sh:=mish(s);
misaiclear2(s);

//cells
ci:=misraw32(cw,ch);
cd:=str__new8;

//.cell
for i:=0 to (cc-1) do
begin

//.jpeg -> cell
if not xpullchunk                   then goto skipend;
if not mis__fromdata(ci,@cd,e)      then goto skipend;
if (misw(ci)<>cw) or (mish(ci)<>ch) then goto skipend;
if (misb(ci)<>32)                   then goto skipend;

//.mask -> cell.mask
if not xpullchunk                   then goto skipend;
if not low__decompress(@cd)         then goto skipend;
if not mask__fromdata(ci,@cd)       then goto skipend;

//.cell -> image

//.dy
for dy:=0 to (ch-1) do
begin
if not misscan82432(s,dy,sr8,sr24,sr32) then goto skipend;
if not misscan32(ci,dy,dr32) then goto skipend;

//.dx
sx:=i*cw;
for dx:=0 to (cw-1) do
begin
if (sx>=0) and (sx<sw) then
   begin
   c32:=dr32[dx];//from cell

   case sbits of
   32:sr32[sx]:=c32;
   24:begin
      c24.r:=c32.r;
      c24.g:=c32.g;
      c24.b:=c32.b;
      sr24[sx]:=c24;
      end;
   8:begin
      if (c32.g>c32.r) then c32.r:=c32.g;
      if (c32.b>c32.r) then c32.r:=c32.b;
      sr8[sx]:=c32.r;
      end;
   end;//case
   end;
inc(sx);
end;//dx
end;//dy
end;//i

//ai information
misai(s).count       :=cc;
misai(s).cellwidth   :=cw;
misai(s).cellheight  :=ch;
misai(s).delay       :=cms;
misai(s).transparent :=false;//alpha channel is used instead (if supplied image was 32bit)
misai(s).bpp         :=32;

//successful
result:=true;

{$endif}
skipend:
except;end;
try
str__uaf(d);
str__free(@cd);
freeobj(@ci);
except;end;
end;

function tj32__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=tj32__todata2(s,d,'',e);
end;

function tj32__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=tj32__todata2(s,d,daction,e);
end;

function tj32__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
label//s=source image - tbasicimage, trawimage or tbitmap etc and d=data stream to store to e.g. tstr8 or str9
   skipend;
var
   int1,sx,dx,dy,i,sbits,sw,sh,cw,ch,cc,cms:longint;
   ci:tbasicimage;
   cd:tstr8;
   sr32,dr32:pcolorrow32;
   sr24     :pcolorrow24;
   sr8      :pcolorrow8;
   c8:tcolor8;
   c24:tcolor24;
   c32:tcolor32;
   xwasaction:string;
   xqualityused,xbytes_image,xbytes_mask:longint;

   procedure xcrunch(x:pobject;daction:string);
   var
      xfast:tstr8;
      p:longint;
      dv,v:byte;
   begin
   //init
   if str__is8(x) then xfast:=(x^ as tstr8) else xfast:=nil;

   if strmatch(daction,ia_bestquality)      then exit
   else if strmatch(daction,ia_highquality) then dv:=2
   else if strmatch(daction,ia_goodquality) then dv:=8
   else if strmatch(daction,ia_fairquality) then dv:=16
   else if strmatch(daction,ia_lowquality)  then dv:=64
   else                                          dv:=8;

   //get
   //if strmatch(daction,ia_fairquality) then
   if (str__len(x)>=1) then
      begin
      for p:=0 to (str__len(x)-1) do
      begin
      if (xfast<>nil) then v:=xfast.pbytes[p] else v:=str__bytes0(x,p);
      if (v>=1) then
         begin
         v:=(v div dv)*dv;
         if (v<1) then v:=1;
         if (xfast<>nil) then xfast.pbytes[p]:=v else str__setbytes0(x,p,v);
         end;
      end;//p
      end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;
ci:=nil;
cd:=nil;
cc:=0;
xqualityused:=0;
xbytes_image:=0;
xbytes_mask:=0;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//.ensure support is turned on -> else ignore request
{$ifdef jpeg}{$else}goto skipend;{$endif}

//init
str__clear(d);
xwasaction:=daction;

//info
if ia__ifindval(daction,ia_cellcount,0,1,int1) then cc:=frcmin32(int1,0)  else cc:=misai(s).count;
if ia__ifindval(daction,ia_delay,0,500,int1)   then cms:=frcmin32(int1,0) else cms:=misai(s).delay;//paint delay

if (cms<=0) then cms:=0;//static
if (cc<=0)  then cc:=1;
cw:=frcmin32(sw div cc,1);
ch:=sh;

//header (22 b)
str__aadd(d,[llt,llj,nn3,nn2,sscolon,sscolon]);// "tj32::"
str__addint4(d,cw);//cell width
str__addint4(d,ch);//cell height
str__addint4(d,cc);//cell count
str__addint4(d,cms);//cell delay

//cells
ci:=misimg32(cw,ch);
cd:=str__new8;

//.cell
for i:=0 to (cc-1) do
begin

//.dy
for dy:=0 to (ch-1) do
begin
if not misscan82432(s,dy,sr8,sr24,sr32) then goto skipend;
if not misscan32(ci,dy,dr32) then goto skipend;

//.dx
sx:=i*cw;
for dx:=0 to (cw-1) do
begin
if (sx>=0) and (sx<sw) then
   begin
   case sbits of
   32:c32:=sr32[sx];
   24:begin
      c24:=sr24[sx];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      c32.a:=255;
      end;
   8:begin
      c8:=sr8[sx];
      c32.r:=c8;
      c32.g:=c8;
      c32.b:=c8;
      c32.a:=255;
      end;
   end;//case
   end
else
   begin//black and transparent
   c32.r:=0;
   c32.g:=0;
   c32.b:=0;
   c32.a:=0;
   end;

dr32[dx]:=c32;
inc(sx);
end;//dx

end;//dy

//image -> jpeg
daction:=xwasaction;//keep daction list short -> prevent multiple cells from appending lots of data
if not mis__todata3(ci,@cd,'jpg',daction,e) then goto skipend;

//info for caller
if (i=0) then xqualityused:=ia__ifindvalb(daction,ia_info_quality,0,0);

//add jpeg.len
inc(xbytes_image,str__len(@cd));
str__addint4(d,str__len(@cd));
//add jpeg.data
str__add(d,@cd);

//image -> image.mask(8 bit)
if not mask__todata(ci,@cd) then goto skipend;
xcrunch(@cd,daction);
if not low__compress(@cd) then goto skipend;

//mask.len
inc(xbytes_mask,str__len(@cd));
str__addint4(d,str__len(@cd));
//mask.data
str__add(d,@cd);
end;//i

//successful
result:=true;
skipend:
except;end;
try
//send back data
daction:=ia__iadd(daction,ia_info_quality,[xqualityused]);
daction:=ia__iadd(daction,ia_info_cellcount,[low__aorb(0,cc,result)]);
daction:=ia__iadd(daction,ia_info_bytes_image,[xbytes_image]);
daction:=ia__iadd(daction,ia_info_bytes_mask,[xbytes_mask]);

//free
if (not result) then str__clear(d);
str__uaf(d);
freeobj(@ci);
str__free(@cd);
except;end;
end;


//bmp procs --------------------------------------------------------------------
function bmp__fromdata(d:tobject;s:pobject;var e:string):boolean;
var
   xbpp:longint;
begin
result:=bmp__fromdata2(d,s,xbpp,e);
end;

function bmp__fromdata2(d:tobject;s:pobject;var xbits:longint;var e:string):boolean;//15mar2025
label
   skipend;
var
   sheadstyle,scompression,slen,spos,int1,int2,sbits,dbits:longint;

   function r1:byte;
   begin
   if (spos<slen) then result:=str__byt1(s,spos) else result:=0;
   inc(spos);
   end;

   function r2:word;
   begin
   twrd2(result).bytes[0]:=r1;
   twrd2(result).bytes[1]:=r1;
   end;

   function r4:longint;
   begin
   tint4(result).bytes[0]:=r1;
   tint4(result).bytes[1]:=r1;
   tint4(result).bytes[2]:=r1;
   tint4(result).bytes[3]:=r1;
   end;
begin
//defaults
result:=false;
e     :=gecTaskfailed;
xbits :=32;//default

try
//check
if not str__lock(s)                  then goto skipend;
if not misok82432(d,dbits,int1,int2) then goto skipend;

//init
slen      :=str__len(s);
spos      :=0;
if (slen<12) then goto skipend;

//bmp header
if (r1=uuB) and (r1=uuM) then spos:=14//jump to main header
else                          spos:=0;

//.0S/2 and Win3.1 header (12b)
sheadstyle:=r4;

case sheadstyle of
hsOS2:;
hsW95:;
hsV04_nocolorspace:;
hsV04:;
hsV05:;
else goto skipend;//unsupported header size (type)
end;


//.read header fields
if (sheadstyle=hsOS2) then
   begin
   //.width2
   if (r2<=0) then goto skipend;

   //.height2
   if (r2<=0) then goto skipend;

   //.planes2
   if (r2<>1) then goto skipend;

   //.bits2
   sbits:=r2;
   case sbits of
   1,4,8,16,24,32:;
   else goto skipend;
   end;

   end
else
   begin
   //common fields to all 3 remaining headers

   //.width4
   if (r4<=0) then goto skipend;

   //.height4 - 08jun2025
   if (low__posn(r4)<=0) then goto skipend;

   //.planes2
   if (r2<>1) then goto skipend;

   //.bits2
   sbits:=r2;
   case sbits of
   1,4,8,16,24,32:;
   else goto skipend;
   end;

   //.compression4
   scompression:=r4;
   case scompression of
   bi_rgb       :;//ok for all bit depths
   bi_bitfields :if ((sbits<>16) and (sbits<>32)) or (sheadstyle<hsW95) then goto skipend;
   bi_rle4      :if (sbits<>4) then goto skipend;
   bi_rle8      :if (sbits<>8) then goto skipend;
   bi_jpeg      :if (sbits<16) then goto skipend;
   bi_png       :if (sbits<16) then goto skipend;
   else                             goto skipend;
   end;//case

   end;


//get
xbits:=sbits;

case sbits of
16,24,32:result:=bmp32__fromdata(d,s);
1,4,8   :result:=bmp8__fromdata(d,s);
end;

//.ai information
if result then
   begin
   misai(d).count       :=1;
   misai(d).cellwidth   :=misw(d);
   misai(d).cellheight  :=misw(d);
   misai(d).delay       :=0;
   misai(d).transparent :=false;//alpha channel is used instead (if supplied image was 32bit)
   misai(d).bpp         :=xbits;
   end;

skipend:
except;end;
//clear on error
if not result then
   begin
   missize(d,1,1);
   misaiclear2(d);
   end;
//free
str__uaf(s);
end;

function bmp__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=bmp__todata2(s,d,'',e);
end;

function bmp__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=bmp__todata3(s,d,daction,e);
end;

function bmp__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//14may2025
label
   skipend;
var
   vmin,vmax,dbits:longint;
   v0,v255,vother:boolean;
begin
//defaults
result:=false;
e     :=gecTaskfailed;

try
//get
case misb(s) of
24  :dbits:=24;
8   :dbits:=8;
else dbits:=32;
end;

//.determine if 32bit image uses any alpha values
if (dbits=32) then
   begin
   mask__range2(s,v0,v255,vother,vmin,vmax);

   //fully solid -> no transparency -> safe to switch to 24 bit mode
   if (vmin>=255) and (vmax>=255) then dbits:=24;
   end;

//.count colors -> if 256 or less then switch to 8 bit or 4 bit modes
if (dbits<=24) then
   begin
   case mis__countcolors257(s) of
   0..16  :dbits:=4;
   17..256:dbits:=8;
   end;//case
   end;

//.min bit depth
if      ia__found(daction,ia_32bitPLUS)   then dbits:=32
else if ia__found(daction,ia_24bitPLUS)   then dbits:=24;

//set
result:=bmpXX__todata(s,d,dbits);

skipend:
except;end;
end;

function bmp__pushdata(s,d:pobject):boolean;//pack data inside a bitmap image - 01may2025
label
   skipend;
var
   p,slen,dheadsize,dbytes,drowsize,dbits,dw,dh:longint;
   s8,d8:tstr8;//pointers only
begin
//defaults
result:=false;

try
//check
if not str__lock2(s,d) then goto skipend;

//init
s8:=str__as8(s);
d8:=str__as8(d);

slen      :=str__len(s);
dbits     :=32;
dw        :=500+random(5000);
drowsize  :=dw*4;
dh        :=slen div drowsize;
if ((dh*drowsize)<slen)     then inc(dh);
if ((dh*drowsize)<(slen+4)) then inc(dh);//allow extra row for trailing 4 bytes (length)

dheadsize :=54;
dbytes    :=dheadsize + (dh * drowsize);

if not str__setlen(d,dbytes) then goto skipend;

//header (14 + 40)
str__setbytes0(d,0,uuB);
str__setbytes0(d,1,uuM);
str__setint4(d,2,dbytes);//size
str__setwrd2(d,6,0);
str__setwrd2(d,8,0);
str__setint4(d,10,dheadsize);

//.bitmapinfoheader (40)
str__setint4(d,14,40);
str__setint4(d,18,dw);
str__setint4(d,22,dh);
str__setwrd2(d,26,1);
str__setwrd2(d,28,dbits);
str__setint4(d,30,0);//compression=none=BI_RGB=0
str__setint4(d,34,dh *drowsize);//sizeimage
str__setint4(d,38,0);
str__setint4(d,42,0);
str__setint4(d,46,0);//number of colors in palette
str__setint4(d,50,0);//number of important colors used in palette

//get
if (s8<>nil) and (d8<>nil) then
   begin
   for p:=0 to (slen-1) do d8.pbytes[dheadsize+p]:=s8.pbytes[p];
   end
else
   begin
   for p:=0 to (slen-1) do str__setpbytes0(d, dheadsize+p, str__pbytes0(s,p) );
   end;

//last 4 bytes is size
str__setint4(d,dbytes-4,slen);

//successful
result:=true;
skipend:
except;end;
try
//free
if (not result) then str__clear(d);
str__uaf(s);
str__uaf(d);
except;end;
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//111111111111111111111111111111111111

function bmpXX__todata(s:tobject;d:pobject;dbits:longint):boolean;//14may2025
begin
case dbits of
32  :result:=bmp32__todata2(s,d,true);
24  :result:=bmp24__todata2(s,d,true);
16  :result:=bmp16__todata2(s,d,true);
8   :result:=bmp8__todata2(s,d,true);
4   :result:=bmp4__todata2(s,d,true);
1   :result:=bmp1__todata2(s,d,true);
else result:=bmp32__todata2(s,d,true);
end;//case
end;

function bmp32__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp32__todata2(s,d,true);
end;

function bmp32__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//15may2025
begin
result:=bmp32__todata3(s,d,dfullheader,0,32);
end;

function bmp32__todata3(s:tobject;d:pobject;dfullheader:boolean;dinfosize,dbits:longint):boolean;//11jun2025: dinfosize, 09jun2025, 28may2025, 15may2025
label//Special Note: if (dbits=24) then V1 (hsW95) header should be used for Clipboard compatibility - 09jun2025
   skipend;
var
   p,dcompression,ymax,dheadsize,dpos,dbytes,drowsize,sbits,sx,sy,sw,sh:longint;
   d8  :tstr8;//pointer only
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   procedure w1(const x:byte);
   begin
   if (dpos<dbytes) then
      begin
      if (d8<>nil) then d8.pbytes[dpos]:=x else str__setbyt1(d,dpos,x);
      end;
   inc(dpos,1);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;

   procedure w16;//0..255 div 8 -> 0..31 (555 => 5 bit each for RGB)
   begin
   w2( (c32.b div 8) + ((c32.g div 8)*32) + ((c32.r div 8)*1024) );//15 bit
   end;
begin
//defaults
result:=false;
d8    :=nil;

try
//check
if not str__lock(d)                            then goto skipend;
if not misok82432(s,sbits,sw,sh)               then goto skipend;
if (dbits<>32) and (dbits<>24) and (dbits<>16) then goto skipend;

//dinfosize - filter
case dinfosize of
hsOS2:;
hsW95:;
hsV04_nocolorspace:;
hsV04:;
hsV05:;//OK
0:if (sbits=32) and (dbits=32) and mask__hastransparency32(s) then dinfosize:=hsV05 else dinfosize:=hsW95;
else dinfosize:=hsW95;
end;

//dcompression - decide
case dinfosize of
hsV04_nocolorspace,hsV04,hsV05:dcompression:=BI_BITFIELDS;
else                           dcompression:=BI_RGB;
end;//case

//range
if (dinfosize=hsOS2) then//only handles 16bit width/height values
   begin
   sw:=frcmax32(sw,max16);
   sh:=frcmax32(sh,max16);
   end;

//init
drowsize  :=mis__rowsize4(sw,dbits);//nearest 4 bytes
dheadsize :=low__aorb(dinfosize, dinfosize+14, dfullheader);
dbytes    :=dheadsize + (sh * drowsize);
ymax      :=sh-1;
dpos      :=0;

//size
if not str__setlen(d,dbytes) then goto skipend;
d8:=str__as8(d);

//zero the header section
for p:=0 to (dheadsize-1) do  str__setbytes0(d,p,0);

//bmp header (14)
if dfullheader then
   begin
   w1(uuB);
   w1(uuM);
   w4(dbytes);//size
   w2(0);
   w2(0);
   w4(dheadsize);
   end;


//bitmapinfoheader

//.hsOS2
if (dinfosize=hsOS2) then
   begin
   //.size4
   w4(dinfosize);

   //.width2
   w2(sw);

   //.height2
   w2(sh);

   //.planes2
   w2(1);

   //.bits2
   w2(dbits);
   end

//.hsW95..hsV05
else
   begin
   //.size4
   w4(dinfosize);

   //.width4
   w4(sw);

   //.height4
   w4(sh);

   //.planes2
   w2(1);

   //.bits2
   w2(dbits);

   //.blank4
   w4(dcompression);

   //.imagesize
   w4(sh *drowsize);

   //.bV4XPelsPerMeter
   w4(0);

   //.bV4YPelsPerMeter
   w4(0);

   //.bV4ClrUsed
   w4(0);

   //.bV4ClrImportant
   w4(0);

   //.v4 header extension -> permits saving of 32bit image with alpha channel - 09jun2025
   if (dinfosize>=hsV04_nocolorspace) then
      begin
      w4( rgba__int(0,0,255,0) );//red mask
      w4( rgba__int(0,255,0,0) );//green mask
      w4( rgba__int(255,0,0,0) );//blue mask
      w4( rgba__int(0,0,0,255) );//alpha mask

      //csType - bV4CSType/bV5CSType
      w1(uuB);
      w1(uuG);
      w1(uuR);
      w1(llS);

      //jump back from end of header to "intent" is -16
      if (dinfosize=hsV05) then
         begin
         dpos:=dheadsize-16;
         w4(4);//same as Gimp
         end;
      end;
   end;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

dpos:=dheadsize + (sy*drowsize);

//.32 -> 32
if (sbits=32) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   w1(c32.b);
   w1(c32.g);
   w1(c32.r);
   w1(c32.a);
   end;//sx
   end
//.32 -> 24
else if (sbits=32) and (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   w1(c32.b);
   w1(c32.g);
   w1(c32.r);
   end;//sx
   end
//.32 -> 16
else if (sbits=32) and (dbits=16) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   w16;
   end;//sx
   end
//.24 -> 32
else if (sbits=24) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   w1(c24.b);
   w1(c24.g);
   w1(c24.r);
   w1(255);
   end;//sx
   end
//.24 -> 24
else if (sbits=24) and (dbits=24) then//28may2025: fixed
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   w1(c24.b);
   w1(c24.g);
   w1(c24.r);
   end;//sx
   end
//.24 -> 16
else if (sbits=24) and (dbits=16) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   c32.r:=c24.r;
   c32.g:=c24.g;
   c32.b:=c24.b;
   w16;
   end;//sx
   end
//.8 -> 32
else if (sbits=8) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24.r:=sr8[sx];
   w1(c24.r);
   w1(c24.r);
   w1(c24.r);
   w1(255);
   end;//sx
   end
//.8 -> 24
else if (sbits=8) and (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24.r:=sr8[sx];
   w1(c24.r);
   w1(c24.r);
   w1(c24.r);
   end;//sx
   end
//.8 -> 16
else if (sbits=8) and (dbits=16) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24.r:=sr8[sx];
   c32.r:=c24.r;
   c32.g:=c24.r;
   c32.b:=c24.r;
   w16;
   end;//sx
   end;

end;//sy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__uaf(d);
end;

function bmp24__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp24__todata2(s,d,true);
end;

function bmp24__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
begin
result:=bmp32__todata3(s,d,dfullheader,0,24);
end;

function bmp16__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp16__todata2(s,d,true);
end;

function bmp16__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
begin
result:=bmp32__todata3(s,d,dfullheader,0,16);
end;

function bmp8__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp8__todata2(s,d,true);
end;

function bmp8__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
label
   skipend;
const
   dbits=8;
   psize=256;
var
   plist:array[0..(psize-1)] of tcolor32;
   pcount,pdiv,ymax,dheadsize,dpos,dbytes,drowsize,sbits,sx,sy,sw,sh:longint;
   i   :byte;
   d8  :tstr8;//pointer only
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   procedure r32(const sx:longint);
   begin
   //get
   case sbits of
   8:begin
      c32.r:=sr8[sx];
      c32.g:=c32.r;
      c32.b:=c32.r;
      end;
   24:begin
      c24:=sr24[sx];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      end;
   32:c32:=sr32[sx];
   end;//case

   //set -> adjust color
   c32.r:=(c32.r div pdiv)*pdiv;
   c32.g:=(c32.g div pdiv)*pdiv;
   c32.b:=(c32.b div pdiv)*pdiv;
   end;

   function pfind(var xindex:byte):boolean;
   var
      p:longint;
   begin
   //defaults
   result:=false;
   xindex:=0;

   //find
   for p:=0 to (pcount-1) do if (c32.r=plist[p].r) and (c32.g=plist[p].g) and (c32.b=plist[p].b) then
      begin
      result:=true;
      xindex:=p;
      break;
      end;//p
   end;

   function pmake:boolean;
   label
      skipend;
   var
      sx,sy:longint;
      i:byte;
   begin
   //defaults
   result:=false;

   //reset
   pcount:=0;

   //count colors
   for sy:=0 to (sh-1) do
   begin
   if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

   for sx:=0 to (sw-1) do
   begin
   r32(sx);

   //.color already in pallete list of colors
   if pfind(i) then
      begin
      //
      end

   //.at capacity -> can't continue
   else if (pcount>=psize) then
      begin
      //.shift to new color adjuster to reduce overall color count
      pdiv:=frcrange32( pdiv + low__aorb(1,30,pdiv>30) ,1,240);
      goto skipend;
      end

   //.add color to palette list
   else
      begin
      plist[pcount].r:=c32.r;
      plist[pcount].g:=c32.g;
      plist[pcount].b:=c32.b;
      plist[pcount].a:=0;
      inc(pcount);
      end;

   end;//sx
   end;//sy

   //successful
   result:=true;
   skipend:
   end;

   procedure w1(const x:byte);
   begin
   if (d8<>nil) then d8.pbytes[dpos]:=x else str__setbyt1(d,dpos,x);
   inc(dpos,1);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;
begin
//defaults
result:=false;
d8    :=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
drowsize  :=mis__rowsize4(sw,8);//nearest 4 bytes
dheadsize :=low__aorb(40, 40+14, dfullheader);
ymax      :=sh-1;
pcount    :=0;
pdiv      :=1;
dpos      :=0;

//make palette
while not pmake do;

//bytes -> relies on pallete count
dbytes:=dheadsize + (pcount*4) + (sh * drowsize);

//size
if not str__setlen(d,dbytes) then goto skipend;
d8:=str__as8(d);

//bmp header (14)
if dfullheader then
   begin
   w1(uuB);
   w1(uuM);
   w4(dbytes);//size
   w2(0);
   w2(0);
   w4( dheadsize + (pcount*4) );
   end;

//bitmapinfoheader (40)
//.size4
w4(40);

//.width4
w4(sw);

//.height4
w4(sh);

//.planes2
w2(1);

//.bits2
w2(dbits);

//.blank4
w4(0);//compression=none=BI_RGB=0

//.imagesize
w4(sh *drowsize);

//.biXPelsPerMeter4
w4(0);

//.biYPelsPerMeter4
w4(0);

//.biClrUsed4
if (pcount>=psize) then w4(0) else w4(pcount);

//.biClrImportant4
w4(0);//all colors are important

//palette
for i:=0 to (pcount-1) do
begin
w1( plist[i].b );
w1( plist[i].g );
w1( plist[i].r );
w1( plist[i].a );
end;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

dpos:=dheadsize + (pcount*4) + (sy*drowsize);

for sx:=0 to (sw-1) do
begin
r32(sx);//read color
pfind(i);//color -> palette index
w1(i);//write palette index
end;//sx

end;//sy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__uaf(d);
end;

function bmp4__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp4__todata2(s,d,true);
end;

function bmp4__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
label
   skipend;
const
   dbits=4;
   psize=16;
var
   plist:array[0..(psize-1)] of tcolor32;
   pcount,pdiv,ymax,dheadsize,dpos,dbytes,drowsize,sbits,sx,sy,sw,sh:longint;
   i,ix,ival:byte;
   d8  :tstr8;//pointer only
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   procedure r32(const sx:longint);
   begin
   //get
   case sbits of
   8:begin
      c32.r:=sr8[sx];
      c32.g:=c32.r;
      c32.b:=c32.r;
      end;
   24:begin
      c24:=sr24[sx];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      end;
   32:c32:=sr32[sx];
   end;//case

   //set -> adjust color
   c32.r:=(c32.r div pdiv)*pdiv;
   c32.g:=(c32.g div pdiv)*pdiv;
   c32.b:=(c32.b div pdiv)*pdiv;
   end;

   function pfind(var xindex:byte):boolean;
   var
      p:longint;
   begin
   //defaults
   result:=false;
   xindex:=0;

   //find
   for p:=0 to (pcount-1) do if (c32.r=plist[p].r) and (c32.g=plist[p].g) and (c32.b=plist[p].b) then
      begin
      result:=true;
      xindex:=p;
      break;
      end;//p
   end;

   function pmake:boolean;
   label
      skipend;
   var
      sx,sy:longint;
      i:byte;
   begin
   //defaults
   result:=false;

   //reset
   pcount:=0;

   //count colors
   for sy:=0 to (sh-1) do
   begin
   if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

   for sx:=0 to (sw-1) do
   begin
   r32(sx);

   //.color already in pallete list of colors
   if pfind(i) then
      begin
      //
      end

   //.at capacity -> can't continue
   else if (pcount>=psize) then
      begin
      //.shift to new color adjuster to reduce overall color count
      pdiv:=frcrange32( pdiv + low__aorb(1,30,pdiv>30) ,1,240);
      goto skipend;
      end

   //.add color to palette list
   else
      begin
      plist[pcount].r:=c32.r;
      plist[pcount].g:=c32.g;
      plist[pcount].b:=c32.b;
      plist[pcount].a:=0;
      inc(pcount);
      end;

   end;//sx
   end;//sy

   //successful
   result:=true;
   skipend:
   end;

   procedure w1(const x:byte);
   begin
   if (d8<>nil) then d8.pbytes[dpos]:=x else str__setbyt1(d,dpos,x);
   inc(dpos,1);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;
begin
//defaults
result:=false;
d8    :=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
drowsize  :=mis__rowsize4(sw,4);//nearest 4 bytes
dheadsize :=low__aorb(40, 40+14, dfullheader);
ymax      :=sh-1;
pcount    :=0;
pdiv      :=1;
dpos      :=0;

//make palette
while not pmake do;

//bytes -> relies on pallete count
dbytes:=dheadsize + (pcount*4) + (sh * drowsize);

//size
if not str__setlen(d,dbytes) then goto skipend;
d8:=str__as8(d);

//bmp header (14)
if dfullheader then
   begin
   w1(uuB);
   w1(uuM);
   w4(dbytes);//size
   w2(0);
   w2(0);
   w4( dheadsize + (pcount*4) );
   end;

//bitmapinfoheader (40)
//.size4
w4(40);

//.width4
w4(sw);

//.height4
w4(sh);

//.planes2
w2(1);

//.bits2
w2(dbits);

//.blank4
w4(0);//compression=none=BI_RGB=0

//.imagesize
w4(sh *drowsize);

//.biXPelsPerMeter4
w4(0);

//.biYPelsPerMeter4
w4(0);

//.biClrUsed4
if (pcount>=psize) then w4(0) else w4(pcount);

//.biClrImportant4
w4(0);//all colors are important

//palette
for i:=0 to (pcount-1) do
begin
w1( plist[i].b );
w1( plist[i].g );
w1( plist[i].r );
w1( plist[i].a );
end;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

dpos:=dheadsize + (pcount*4) + (sy*drowsize);
ix  :=0;
ival:=0;

for sx:=0 to (sw-1) do
begin
r32(sx);//read color
pfind(i);//color -> palette index

//inc
inc(ix);

//add to pixel bucket
case ix of
1:ival:=(i*16);
2:ival:=ival+i;
end;

//save pixel
if (ix>=2) then
   begin
   w1(ival);
   ival:=0;
   ix  :=0;
   end;
end;//sx

//save last un-saved pixel
if (ix>=1) then w1(ival);
end;//sy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__uaf(d);
end;

function bmp1__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp1__todata2(s,d,true);
end;

function bmp1__todata2(s:tobject;d:pobject;dfullheader:boolean):boolean;//14may2025
begin
result:=bmp1__todata3(s,d, low__aorb(1,2,dfullheader) );
end;

function bmp1__todata3(s:tobject;d:pobject;dheaderlevel:longint):boolean;//27may2025, 14may2025
label
   skipend;
const
   dbits =1;
   pcount=2;
var
   ymax,dheadsize,dpos,dbytes,drowsize,sbits,sx,sy,sw,sh:longint;
   ix,ival,vbit:byte;
   d8  :tstr8;//pointer only
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   procedure r32;
   begin
   //get
   case sbits of
   8:begin
      c32.r:=sr8[sx];
      c32.g:=c32.r;
      c32.b:=c32.r;
      end;
   24:begin
      c24:=sr24[sx];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      end;
   32:c32:=sr32[sx];
   end;//case

   //set -> reduce color to a single bit (0 or 1)
   //.color24 -> lum8
   if (c32.g>c32.r) then c32.r:=c32.g;
   if (c32.b>c32.r) then c32.r:=c32.b;

   //.lum8 -> bit1
   if (c32.r>=128) then vbit:=1 else vbit:=0;
   end;

   procedure w1(const x:byte);
   begin
   if (d8<>nil) then d8.pbytes[dpos]:=x else str__setbyt1(d,dpos,x);
   inc(dpos,1);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;
begin
//defaults
result:=false;
d8    :=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
drowsize  :=mis__rowsize4(sw,1);//nearest 4 bytes

case dheaderlevel of
0   :dheadsize:=0;
1   :dheadsize:=40;
else dheadsize:=40+14;
end;

ymax      :=sh-1;
dpos      :=0;

//bytes -> relies on palette count
dbytes:=dheadsize + (pcount*4) + (sh * drowsize);

//size
if not str__setlen(d,dbytes) then goto skipend;
d8:=str__as8(d);

//bmp header (14)
if (dheaderlevel>=2) then
   begin
   w1(uuB);
   w1(uuM);
   w4(dbytes);//size
   w2(0);
   w2(0);
   w4( dheadsize + (pcount*4) );
   end;

//bitmapinfoheader (40)
if (dheaderlevel>=1) then
   begin
   //.size4
   w4(40);

   //.width4
   w4(sw);

   //.height4
   w4(sh);

   //.planes2
   w2(1);

   //.bits2
   w2(dbits);

   //.blank4
   w4(0);//compression=none=BI_RGB=0

   //.imagesize
   w4(sh *drowsize);

   //.biXPelsPerMeter4
   w4(0);

   //.biYPelsPerMeter4
   w4(0);

   //.biClrUsed4
   w4(0);

   //.biClrImportant4
   w4(0);//all colors are important
   end;

//palette
//.black
w1(0);
w1(0);
w1(0);
w1(0);
//.white
w1(255);
w1(255);
w1(255);
w1(0);

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

dpos:=dheadsize + (pcount*4) + (sy*drowsize);
ix  :=0;
ival:=0;

for sx:=0 to (sw-1) do
begin
r32;//read color

//inc
inc(ix);

//add to pixel bucket
case ix of
1:ival:=(vbit*128);
2:ival:=ival+(vbit*64);
3:ival:=ival+(vbit*32);
4:ival:=ival+(vbit*16);
5:ival:=ival+(vbit*8);
6:ival:=ival+(vbit*4);
7:ival:=ival+(vbit*2);
8:ival:=ival+vbit;
end;

//save pixel
if (ix>=8) then
   begin
   w1(ival);
   ival:=0;
   ix  :=0;
   end;
end;//sx

//save last un-saved pixel
if (ix>=1) then w1(ival);
end;//sy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__uaf(d);
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
{
bitmap headers:
1. BITMAPCOREHEADER = OS/2 and Win3.1 = 12b  (and BITMAPCOREINFO = bmpCOREheader + list of RGB triple)
2. BITMAPINFOHEADER = BITMAPCOREHEADER+ = Win95
3. BITMAPV4HEADER   = BITMAPINFOHEADER+
4. BITMAPV5HEADER   = most advanced header

1. bmpCOREheader (12b)
 DWORD bcSize;
 WORD  bcWidth;
 WORD  bcHeight;
 WORD  bcPlanes;
 WORD  bcBitCount;

2. bmpINFOheader (40b)
 DWORD biSize;
 LONG  biWidth;
 LONG  biHeight;
 WORD  biPlanes;
 WORD  biBitCount;
 DWORD biCompression;
 DWORD biSizeImage;
 LONG  biXPelsPerMeter;
 LONG  biYPelsPerMeter;
 DWORD biClrUsed;
 DWORD biClrImportant;

3. bmpV4header (108b)
 DWORD        bV4Size;
 LONG         bV4Width;
 LONG         bV4Height;
 WORD         bV4Planes;
 WORD         bV4BitCount;
 DWORD        bV4V4Compression;
 DWORD        bV4SizeImage;
 LONG         bV4XPelsPerMeter;
 LONG         bV4YPelsPerMeter;
 DWORD        bV4ClrUsed;
 DWORD        bV4ClrImportant;//0..39
 DWORD        bV4RedMask;
 DWORD        bV4GreenMask;
 DWORD        bV4BlueMask;
 DWORD        bV4AlphaMask;
 DWORD        bV4CSType;
 CIEXYZTRIPLE bV4Endpoints;//36b
 DWORD        bV4GammaRed;
 DWORD        bV4GammaGreen;
 DWORD        bV4GammaBlue;

4. bmpV5header (124b)
 DWORD        bV5Size;
 LONG         bV5Width;
 LONG         bV5Height;
 WORD         bV5Planes;
 WORD         bV5BitCount;
 DWORD        bV5Compression;
 DWORD        bV5SizeImage;
 LONG         bV5XPelsPerMeter;
 LONG         bV5YPelsPerMeter;
 DWORD        bV5ClrUsed;
 DWORD        bV5ClrImportant;//0..39
 DWORD        bV5RedMask;
 DWORD        bV5GreenMask;
 DWORD        bV5BlueMask;
 DWORD        bV5AlphaMask;
 DWORD        bV5CSType;
 CIEXYZTRIPLE bV5Endpoints;//60+36b
 DWORD        bV5GammaRed;
 DWORD        bV5GammaGreen;
 DWORD        bV5GammaBlue;
 DWORD        bV5Intent;//108..111
 DWORD        bV5ProfileData;//112..115
 DWORD        bV5ProfileSize;//116..119
 DWORD        bV5Reserved;//120..123
{}

function bmp32__fromdata(d:tobject;s:pobject):boolean;//11jun2025: supports DIB +12b patch, 15may2025
begin
result:=bmp32__fromdata2(d,s,true);
end;

function bmp32__fromdata2(d:tobject;s:pobject;sallow_dib_patch_12:boolean):boolean;//12jun2025: dib_patch_12 control, 11jun2025: supports DIB +12b patch, 15may2025
label
   skipend;
var
   e:string;
   sintent,sstartofdata,slen,sheadstyle,sinfosize,simagesize,scompression,spos,srowsize,dbits,dw,dh,dx,dy,int1,int2,sbits:longint;
   vb32,rmask,gmask,bmask,amask,sr,sg,sb,sa,mr,mg,mb,ma:longint;//mask support (scompression=bi_bitfields)
   sdib_patchmode_12,sdib,dflip:boolean;
   s8  :tstr8;//pointer only
   dr32:pcolorrow32;
   dr24:pcolorrow24;
   dr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;
   b   :tobject;

   function xscalemultipler(xbitsused:longint):longint;
   begin
   case xbitsused of
   8:result:=1;
   7:result:=2;
   6:result:=4;
   5:result:=8;
   4:result:=17;
   3:result:=36;
   2:result:=85;
   1:result:=255;
   else result:=1;
   end;//case
   end;

   function r1:byte;
   begin
   case (spos<slen) of
   true:if (s8<>nil) then result:=s8.pbytes[spos] else result:=str__byt1(s,spos);
   else result:=0;
   end;//case
   //inc
   inc(spos);
   end;

   function r2:word;
   begin
   twrd2(result).bytes[0]:=r1;
   twrd2(result).bytes[1]:=r1;
   end;

   function r3:longint;
   begin
   tint4(result).bytes[0]:=r1;
   tint4(result).bytes[1]:=r1;
   tint4(result).bytes[2]:=r1;
   tint4(result).bytes[3]:=0;
   end;

   function r4:longint;
   begin
   tint4(result).bytes[0]:=r1;
   tint4(result).bytes[1]:=r1;
   tint4(result).bytes[2]:=r1;
   tint4(result).bytes[3]:=r1;
   end;

   function bb(const rgbaVALUE,rgbaMASK,rgbaSHIFTRIGHT,rgbaMULTIPLIER:longint):byte;//bit-mask processor - 08jun2025
   var
      v:longint;
   begin
   //get
   v:=rgbaVALUE and rgbaMASK;//use AND to extract component value from pixel value (e.g. RGBA -> Red only with red-mask)
   v:=v shr rgbaSHIFTRIGHT;//shift value to right to bring to zero it (0..N)

   //scale to 8bit
   if (rgbaMULTIPLIER<>1) then v:=v*rgbaMULTIPLIER;

   //range check
   if (v<0) then v:=0 else if (v>255) then v:=255;

   //set
   result:=byte(v);
   end;

   procedure rb;
   begin
   c32.r:=bb(vb32,rmask,sr,mr);
   c32.g:=bb(vb32,gmask,sg,mg);
   c32.b:=bb(vb32,bmask,sb,mb);
   if (amask=0) then c32.a:=255 else c32.a:=bb(vb32,amask,sa,ma);
   end;

   procedure r16;//555 = 15bit
   var//0..255 div 8 -> 0..31 (5 bit)
      v:word;

      procedure p(var dcol:byte;xfactor:longint);
      var
         z:word;
      begin
      z:=v div xfactor;
      dec(v,z*xfactor);
      z:=z*8;
      if (z>255) then z:=255;
      dcol:=z;
      end;
   begin
   if (scompression=bi_bitfields) then
      begin
      vb32:=r2;
      rb;
      end
   else
      begin
      v:=r2;
      p(c32.r,1024);
      p(c32.g,32);
      p(c32.b,1);
      c32.a:=255;
      end;
   end;

   procedure r24;
   begin
   if (scompression=bi_bitfields) then
      begin
      vb32:=r3;
      rb;
      end
   else
      begin
      c32.b:=r1;
      c32.g:=r1;
      c32.r:=r1;
      c32.a:=255;
      end;
   end;

   procedure r32;
   begin
   if (scompression=bi_bitfields) then
      begin
      vb32:=r4;
      rb;
      end
   else
      begin
      c32.b:=r1;
      c32.g:=r1;
      c32.r:=r1;
      c32.a:=r1;
      end;
   end;
begin
//defaults
result           :=false;
s8               :=nil;
b                :=nil;
sinfosize        :=0;
simagesize       :=0;
scompression     :=bi_rgb;
dflip            :=false;
sintent          :=0;
rmask            :=0;
gmask            :=0;
bmask            :=0;
amask            :=0;
sdib_patchmode_12:=false;//supports the DIB +12b "patch mode" by checking expected and actual total data sizes for a 12byte discrepancy - 12jun2025

try
//check
if not str__lock(s)                  then goto skipend;
if not misok82432(d,dbits,int1,int2) then goto skipend;

//init
s8        :=str__as8(s);
slen      :=str__len(s);
spos      :=0;
if (slen<12) then goto skipend;

//bmp header
if (r1=uuB) and (r1=uuM) then
   begin
   sdib        :=false;
   spos        :=10;
   sstartofdata:=frcmin32(r4,0);
   sinfosize   :=14;
   spos        :=14;//jump to main header
   end
else
   begin
   sdib        :=true;
   spos        :=0;
   sstartofdata:=0;
   end;

//info header
//.size4
sheadstyle:=r4;
inc(sinfosize,sheadstyle);

//.check header type
case sheadstyle of
hsOS2:;
hsW95:;
hsV04_nocolorspace:;
hsV04:;
hsV05:;
else goto skipend;//unsupported header size (type)
end;//case

//.header too small
if (sheadstyle<hsOS2) then goto skipend

//.0S/2 and Win3.1 header (12b)
else if (sheadstyle=hsOS2) then
   begin
   //.width2
   dw:=r2;
   if (dw<=0) then goto skipend;

   //.height2
   dh:=r2;
   if (dh<=0) then goto skipend;

   //.planes2
   if (r2<>1) then goto skipend;

   //.bits2
   sbits:=r2;

   case sbits of
   0       :sbits:=32;//assumes a JPEG or PNG image is present
   16,24,32:;//ok
   else     goto skipend;//unsupported
   end;//case

   end
//.hsW95, hsV04_nocolorspace, hsV04 and hsV05
else if (sheadstyle>=hsW95) then
   begin
   //common fields to all 3 remaining headers

   //.width4
   dw:=r4;
   if (dw<=0) then goto skipend;

   //.height4 - 08jun2025
   int1  :=r4;
   dflip :=(int1<0);
   dh    :=low__posn(int1);

   if (dh<=0) then goto skipend;

   //.planes2
   if (r2<>1) then goto skipend;

   //.bits2
   sbits:=r2;

   case sbits of
   0       :sbits:=32;//assumes a JPEG or PNG image is present
   16,24,32:;//ok
   else     goto skipend;//unsupported
   end;//case

   //.compression4
   scompression:=r4;
   case scompression of
   bi_rgb       :;//ok for all bit depths
   bi_bitfields :if ((sbits<>16) and (sbits<>32)) or (sheadstyle<hsW95) then goto skipend;
   bi_jpeg      :if (sbits<16) then goto skipend;
   bi_png       :if (sbits<16) then goto skipend;
   else                             goto skipend;
   end;//case

   //.image size - required when compression type is JPEG or PNG
   simagesize:=r4;

   //.bitfields support
   if (scompression=bi_bitfields) then
      begin

      //.sdib_patchmode_12 -> there is no clear indication when this is to be used only the total bytes is +12 more than expected - 12jun2025
      if sdib and sallow_dib_patch_12 and ( (sinfosize+simagesize+12)=str__len(s) ) then
         begin
         sdib_patchmode_12:=true;
         inc(sinfosize,12);
         end;

      //.hsW95 (when BMP has no mask bits -> can be 555 or 565, assume 565)
      if (sheadstyle=hsW95) then
         begin

         //.DIB only - invalid for BMP
         if sdib_patchmode_12 then
            begin
            spos:=sinfosize-12;
            rmask:=r4;
            gmask:=r4;
            bmask:=r4;
            amask:=0;
            end;

         end

      //.hsV04 and V05
      else
         begin
         //read mask values
         r4;//bV5XPelsPerMeter;
         r4;//bV5YPelsPerMeter;
         r4;//bV5ClrUsed;
         r4;//bV5ClrImportant;//0..39

         //.rgba bit-masks
         rmask:=r4;
         gmask:=r4;
         bmask:=r4;
         amask:=r4;

         end;

      //.fallback to default "565" with no alpha
      if (rmask=0) and (gmask=0) and (bmask=0) and (amask=0) then
         begin
         rmask:=63488;
         gmask:=2016;
         bmask:=31;
         amask:=0;
         end;

      //mask support values
      //.shift right count
      sr:=bit__findfirst32(rmask);
      sg:=bit__findfirst32(gmask);
      sb:=bit__findfirst32(bmask);
      sa:=bit__findfirst32(amask);

      //.mulitpler to scale value back to a range of 0..255 (8 bit)
      mr:=xscalemultipler(bit__findcount32(rmask));
      mg:=xscalemultipler(bit__findcount32(gmask));
      mb:=xscalemultipler(bit__findcount32(bmask));
      ma:=xscalemultipler(bit__findcount32(amask));

      //jump back from end of header to beginning of "intent" is -16
      if (sheadstyle=hsV05) then
         begin
         spos:=sinfosize-16;
         sintent:=r4;
         end;
      end;

   end
else goto skipend;

//init
srowsize  :=mis__rowsize4(dw,sbits);

//size
if not missize(d,dw,dh) then goto skipend;

//start of data
sstartofdata:=largest32(sstartofdata,sinfosize);

//decide
case scompression of
bi_jpeg:begin
   result:=str__add3(@b,s,sstartofdata,simagesize) and jpg__fromdata(d,@b,e);
   goto skipend;
   end;
bi_png:begin
   b:=str__newsametype(s);
   result:=str__add3(@b,s,sstartofdata,simagesize) and png__fromdata(d,@b,e);
   goto skipend;
   end;
end;

//get
for dy:=0 to (dh-1) do
begin

case dflip of
true:if not misscan82432(d,dy,dr8,dr24,dr32)      then goto skipend;
else if not misscan82432(d,dh-1-dy,dr8,dr24,dr32) then goto skipend;
end;//case

spos:=sstartofdata + (dy*srowsize);

//.32 -> 32
if (sbits=32) and (dbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r32;
   dr32[dx]:=c32;
   end;//dx
   end
//.32 -> 24
else if (sbits=32) and (dbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r32;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   dr24[dx]:=c24;
   end;//dx
   end
//.32 -> 8
else if (sbits=32) and (dbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r32;
   dr8[dx]:=c32__lum(c32);
   end;//dx
   end
//.24 -> 32
else if (sbits=24) and (dbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r24;
   dr32[dx]:=c32;
   end;//dx
   end
//.24 -> 24
else if (sbits=24) and (dbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r24;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   dr24[dx]:=c24;
   end;//dx
   end
//.24 -> 8
else if (sbits=24) and (dbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r24;
   dr8[dx]:=c32__lum(c32);
   end;//dx
   end
//.16 -> 32
else if (sbits=16) and (dbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r16;
   dr32[dx]:=c32;
   end;//dx
   end
//.16 -> 24
else if (sbits=16) and (dbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r16;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   dr24[dx]:=c24;
   end;//dx
   end
//.16 -> 8
else if (sbits=16) and (dbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r16;
   dr8[dx]:=c32__lum(c32);
   end;//dx
   end;

end;//dy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then missize(d,1,1);
//free
str__free(@b);
str__uaf(s);
end;

function bmp24__fromdata(d:tobject;s:pobject):boolean;//15may2025
begin
result:=bmp32__fromdata(d,s);
end;

function bmp16__fromdata(d:tobject;s:pobject):boolean;//15may2025
begin
result:=bmp32__fromdata(d,s);
end;

function bmp8__fromdata(d:tobject;s:pobject):boolean;//09jun2025: supports bi_rgb + bi_rle8 + bi_rle4, 15may2025
label
   skipend;
var
   plist:array[0..255] of tcolor32;
   sstartofdata,pcolsize,simagesize,sheadstyle,sinfosize,scompression,pval,px,p,plimit,pcount,slen,spos,srowsize,dbits,dw,dh,dx,dy,int1,int2,sbits:longint;
   dflip:boolean;
   s8  :tstr8;//pointer only
   dr32:pcolorrow32;
   dr24:pcolorrow24;
   dr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   function r1:byte;
   begin
   case (spos<slen) of
   true:if (s8<>nil) then result:=s8.pbytes[spos] else result:=str__byt1(s,spos);
   else result:=0;
   end;//case
   //inc
   inc(spos);
   end;

   function r2:word;
   begin
   twrd2(result).bytes[0]:=r1;
   twrd2(result).bytes[1]:=r1;
   end;

   function r4:longint;
   begin
   tint4(result).bytes[0]:=r1;
   tint4(result).bytes[1]:=r1;
   tint4(result).bytes[2]:=r1;
   tint4(result).bytes[3]:=r1;
   end;

   function xread_rle48:boolean;
   label
      skipend;
   var
      acount,vcount,sp,p,ylast,dx,dy,v,v1,v2:longint;
      bol1,srle8:boolean;

      function xreadpixel4(const x:byte;var xfirst:boolean):byte;
      begin
      result:=x div 16;
      if not xfirst then result:=x - (result*16);
      //inc
      xfirst:=not xfirst;
      end;

      procedure xpush(i:byte);
      begin
      //check

      //.dx
      if (dx>=dw) then
         begin
         dx:=0;
         inc(dy);
         end;

      //.dy
      if (dy>=dh) then exit;

      //range
      if (i>=plimit) then i:=plimit-1;
      c32:=plist[i];

      //init
      if (ylast<>dy) then
         begin
         ylast:=dy;

         case dflip of
         true:misscan82432(d,dy,dr8,dr24,dr32);
         else misscan82432(d,dh-1-dy,dr8,dr24,dr32);
         end;//case

         end;

      //set
      case dbits of
      32:dr32[dx]:=c32;
      24:begin
         c24.r:=c32.r;
         c24.g:=c32.g;
         c24.b:=c32.b;
         dr24[dx]:=c24;
         end;
      8 :dr8[dx]:=c32__lum(c32);
      end;//case

      //inc
      inc(dx);
      end;
   begin
   //init
   result:=false;
   dx    :=0;
   dy    :=0;
   ylast :=-1;
   spos  :=sstartofdata;
   srle8 :=(scompression=bi_rle8);

   //get
   for sp:=0 to (simagesize-1) do
   begin
   v1:=r1;
   v2:=r1;

   case v1 of
   0:begin

      case v2 of
      0:begin//end of line
         inc(dy);
         dx:=0;
         end;
      1:begin
         result:=true;
         goto skipend;//end of bitmap
         end;
      2:begin//shift RIGHT and UP (2 bytes)
         //.x
         inc(dx,r1);//right
         if (dx>=dw) then dx:=dw-1;
         //.y
         inc(dy,r1);//up
         if (dy>=dh) then dy:=dh-1;
         end;
      3..255:begin//absolute (padded to word boundary, so last item may be ZERO but unused)

         //.8bit
         if srle8 then
            begin
            for p:=1 to v2 do xpush(r1);
            if not low__even(v2) then r1;//read zero pad byte
            end
         //.4bit
         else
            begin
            acount:=0;
            vcount:=0;
            bol1  :=true;

            for p:=1 to v2 do//number of pixels -> 2 pixels per byte -> still a 2-byte (word) boundary
            begin
            //.read byte
            if (acount<=0) then
               begin
               v     :=r1;
               acount:=2;//read two pixels from one byte
               inc(vcount);
               end;
            dec(acount);

            //.read pixel
            xpush( xreadpixel4(v,bol1) );
            end;//p

            if not low__even(vcount) then r1;//read zero pad byte
            end;

         end;//begin

      end;//case v2
      end;//begin

   1..255:begin//repeat

      //.8bit
      if srle8 then
         begin
         for p:=1 to v1 do xpush(v2);
         end
      //.4bit
      else
         begin
         bol1:=true;
         for p:=1 to v1 do xpush( xreadpixel4(v2,bol1) );
         end;

      end;//begin

   end;//case

   //check
   if (dy>=dh) then break;

   end;//sp

   //successful
   result:=true;
   skipend:
   end;

   procedure p8;
   var
      i:byte;
   begin
   i:=r1;
   if (i>=plimit) then i:=plimit-1;
   c32:=plist[i];
   end;

   procedure p4;
   var
      i:byte;
   begin
   //inc
   inc(px);
   if (px>=3) then px:=1;
   if (px=1)  then pval:=r1;

   //get
   case px of
   1:begin
      i:=pval div 16;
      dec(pval,i*16);
      end;
   2:i:=pval;
   else i:=0;
   end;//case

   //enforce upper limit
   if (i>=plimit) then i:=plimit-1;

   //set
   c32:=plist[i];
   end;

   procedure p1;
   var
      i:byte;

      procedure v(xdiv:byte);
      begin
      i:=pval div xdiv;
      dec(pval,i*xdiv);
      end;
   begin
   //inc
   inc(px);
   if (px>=9) then px:=1;
   if (px=1)  then pval:=r1;

   //get
   case px of
   1:v(128);
   2:v(64);
   3:v(32);
   4:v(16);
   5:v(8);
   6:v(4);
   7:v(2);
   8:i:=pval;
   end;//case

   //enforce upper limit
   if (i>=plimit) then i:=plimit-1;

   //set
   c32:=plist[i];
   end;
begin
//defaults
result       :=false;
s8           :=nil;
simagesize   :=0;
sinfosize    :=0;
scompression:=bi_rgb;
dflip       :=false;

try
//check
if not str__lock(s)                  then goto skipend;
if not misok82432(d,dbits,int1,int2) then goto skipend;

//init
s8        :=str__as8(s);
slen      :=str__len(s);
spos      :=0;
if (slen<12) then goto skipend;

//bmp header
if (r1=uuB) and (r1=uuM) then
   begin
   spos        :=10;
   sstartofdata:=frcmin32(r4,0);

   sinfosize   :=14;
   spos        :=14;//jump to main header
   end
else
   begin
   sstartofdata:=0;
   spos        :=0;
   end;

//info header
//.size4
sheadstyle:=r4;
inc(sinfosize,sheadstyle);

//.check header type
case sheadstyle of
hsOS2:;
hsW95:;
hsV04:;
hsV05:;
else goto skipend;//unsupported header size (type)
end;//case

//.0S/2 and Win3.1 header (12b)
if (sheadstyle=hsOS2) then
   begin
   //.width2
   dw:=r2;
   if (dw<=0) then goto skipend;

   //.height2
   dh:=r2;
   if (dh<=0) then goto skipend;

   //.planes2
   if (r2<>1) then goto skipend;

   //.bits2
   sbits:=r2;

   case sbits of
   1,4,8:;//OK
   else  goto skipend;
   end;

   //.pcount
   case sbits of
   1:plimit:=2;
   4:plimit:=16;
   8:plimit:=256;
   end;//case

   pcount    :=plimit;
   pcolsize  :=3;//bgr = 3 bytes

   end
else
   begin
   //common fields to all 3 remaining headers

   //.width4
   dw:=r4;
   if (dw<=0) then goto skipend;

   //.height4 - 08jun2025
   int1  :=r4;
   dflip :=(int1<0);
   dh    :=low__posn(int1);

   if (dh<=0) then goto skipend;

   //.planes2
   if (r2<>1) then goto skipend;

   //.bits2
   sbits:=r2;

   case sbits of
   1,4,8:;//OK
   else  goto skipend;
   end;

   //.compression4
   scompression:=r4;
   case scompression of
   bi_rgb       :;//ok for all bit depths
   bi_rle4      :if (sbits<>4) then goto skipend;
   bi_rle8      :if (sbits<>8) then goto skipend;
   else                             goto skipend;
   end;//case

   //.image size - required when compression type is JPEG or PNG or packed data such as rle4/8
   simagesize:=r4;

   //.biXPelsPerMeter4
   r4;

   //.biYPelsPerMeter4
   r4;

   //.biClrUsed4 -> 0=full size e.g. 256
   case sbits of
   8   :plimit:=256;
   4   :plimit:=16;
   1   :plimit:=2;
   else plimit:=256;
   end;//case

   pcount:=frcrange32(r4,0,plimit);
   if (pcount<=0) then pcount:=plimit;

   pcolsize:=4;//rgb = 4 bytes
   end;

//.jump to start of palette
spos:=sinfosize;

//.palette
low__cls(@plist,sizeof(plist));

for p:=0 to (pcount-1) do
begin
plist[p].b:=r1;
plist[p].g:=r1;
plist[p].r:=r1;
if (pcolsize=4) then plist[p].a:=r1;//just read it, don't use it
plist[p].a:=255;//force as solid
end;//p

//init
srowsize  :=mis__rowsize4(dw,sbits);

//size
if not missize(d,dw,dh) then goto skipend;

//cls
mis__cls(d,0,0,0,0);//black and transparent (if 32bit canvas)

//start of data
sstartofdata:=largest32(sstartofdata, sinfosize + (pcount*pcolsize) );

//RLE-8 and RLE-4
case scompression of
bi_rle4,bi_rle8:begin
   result:=xread_rle48;
   goto skipend;
   end;
end;

//get
for dy:=0 to (dh-1) do
begin

case dflip of
true:if not misscan82432(d,dy,dr8,dr24,dr32)      then goto skipend;
else if not misscan82432(d,dh-1-dy,dr8,dr24,dr32) then goto skipend;
end;//case

spos:=sstartofdata + (dy*srowsize);
px  :=0;

//.8 -> 32
if (sbits=8) and (dbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p8;
   dr32[dx]:=c32;
   end;//dx
   end
//.8 -> 24
else if (sbits=8) and (dbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p8;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   dr24[dx]:=c24;
   end;//dx
   end
//.8 -> 8
else if (sbits=8) and (dbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p8;
   dr8[dx]:=c32__lum(c32);
   end;//dx
   end
//.4 -> 32
else if (sbits=4) and (dbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p4;
   dr32[dx]:=c32;
   end;//dx
   end
//.4 -> 24
else if (sbits=4) and (dbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p4;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   dr24[dx]:=c24;
   end;//dx
   end
//.4 -> 8
else if (sbits=4) and (dbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p4;
   dr8[dx]:=c32__lum(c32);
   end;//dx
   end
//.1 -> 32
else if (sbits=1) and (dbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p1;
   dr32[dx]:=c32;
   end;//dx
   end
//.1 -> 24
else if (sbits=1) and (dbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p1;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   dr24[dx]:=c24;
   end;//dx
   end
//.1 -> 8
else if (sbits=1) and (dbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   p1;
   dr8[dx]:=c32__lum(c32);
   end;//dx
   end;

end;//dy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then missize(d,1,1);
//free
str__uaf(s);
end;

function bmp4__fromdata(d:tobject;s:pobject):boolean;//15may2025
begin
result:=bmp8__fromdata(d,s);
end;

function bmp1__fromdata(d:tobject;s:pobject):boolean;//15may2025
begin
result:=bmp8__fromdata(d,s);
end;


//dib procs --------------------------------------------------------------------
function dib__fromdata(s:tobject;d:pobject;var e:string):boolean;
var
   xbpp:longint;
begin
result:=dib__fromdata2(s,d,xbpp,e);
end;

function dib__fromdata2(s:tobject;d:pobject;var xoutbpp:longint;var e:string):boolean;
begin
result:=bmp__fromdata2(s,d,xoutbpp,e);
end;

function dib__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=dib__todata2(s,d,'',e);
end;

function dib__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=dib__todata3(s,d,daction,e);
end;

function dib__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//14may2025
label
   skipend;
var
   vmin,vmax,dbits:longint;
   v0,v255,vother:boolean;
begin
//defaults
result:=false;
e     :=gecTaskfailed;

try
//get
case misb(s) of
24  :dbits:=24;
8   :dbits:=8;
else dbits:=32;
end;

//.determine if 32bit image uses any alpha values
if (dbits=32) then
   begin
   mask__range2(s,v0,v255,vother,vmin,vmax);

   //fully solid -> no transparency -> safe to switch to 24 bit mode
   if (vmin>=255) and (vmax>=255) then dbits:=24;
   end;

//.count colors -> if 256 or less then switch to 8 bit or 4 bit modes
if (dbits<=24) then
   begin
   case mis__countcolors257(s) of
   0..16  :dbits:=4;
   17..256:dbits:=8;
   end;//case
   end;

//set
result:=dibXX__todata(s,d,dbits);

skipend:
except;end;
end;

function dibXX__todata(s:tobject;d:pobject;dbits:longint):boolean;//14may2025
begin
case dbits of
32  :result:=bmp32__todata2(s,d,false);
24  :result:=bmp24__todata2(s,d,false);
16  :result:=bmp16__todata2(s,d,false);
8   :result:=bmp8__todata2(s,d,false);
4   :result:=bmp4__todata2(s,d,false);
1   :result:=bmp1__todata2(s,d,false);
else result:=bmp32__todata2(s,d,false);
end;//case
end;

function dib32__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp32__todata2(s,d,false);
end;

function dib24__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp24__todata2(s,d,false);
end;

function dib16__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp16__todata2(s,d,false);
end;

function dib8__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp8__todata2(s,d,false);
end;

function dib4__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp4__todata2(s,d,false);
end;

function dib1__todata(s:tobject;d:pobject):boolean;//14may2025
begin
result:=bmp1__todata2(s,d,false);
end;

function dib32__fromdata(d:tobject;s:pobject):boolean;//15may2025
begin
result:=bmp32__fromdata(d,s);
end;

function dib24__fromdata(d:tobject;s:pobject):boolean;//15may2025
begin
result:=bmp24__fromdata(d,s);
end;

function dib16__fromdata(d:tobject;s:pobject):boolean;//15may2025
begin
result:=bmp16__fromdata(d,s);
end;

function dib8__fromdata(d:tobject;s:pobject):boolean;//28may2025
begin
result:=bmp8__fromdata(d,s);
end;

function dib4__fromdata(d:tobject;s:pobject):boolean;//28may2025
begin
result:=bmp4__fromdata(d,s);
end;

function dib1__fromdata(d:tobject;s:pobject):boolean;//28may2025
begin
result:=bmp1__fromdata(d,s);
end;


//jpg procs --------------------------------------------------------------------
function jpg__can:boolean;
begin
{$ifdef jpeg}result:=true;{$else}result:=false;{$endif}
end;

function jpg__fromdata(s:tobject;d:pobject;var e:string):boolean;
label
   skipend;
var
   sbits,sw,sh:longint;
begin
//defaults
result :=false;
e      :=gecTaskfailed;

try
{$ifdef jpeg}

//check
if not str__lock(d)               then goto skipend;
if not misok82432(s,sbits,sw,sh)  then goto skipend;

//get
if not jpg____fromdata(d,s) then goto skipend;//04may2025

//ai information
misai(s).count       :=1;
misai(s).cellwidth   :=misw(s);
misai(s).cellheight  :=mish(s);
misai(s).delay       :=0;
misai(s).transparent :=false;
misai(s).bpp         :=24;

//successful
result:=true;

{$endif}
skipend:
except;end;
//free
str__uaf(d);
end;

function jpg__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=jpg__todata2(s,d,ia_goodquality,e);
end;

function jpg__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=jpg__todata3(s,d,daction,e);
end;

function jpg__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//05dec2024, 24nov2024
label
   doauto,skipend;
var
   v,xqualityused,xforcequality,xscanquality,xsame,xtotal,xpert,sbits,sw,sh:longint;
   xsizelimitBytes:comp;
   vlastdata:tstr8;
   sref:tbasicimage;

   function xsamecount(s,d:tobject;var xsame,xtotal,xpert:longint):boolean;
   label
      skipend;
   const
      v=1;//a level of 2 or more allows artifacts to creep in to pictures with smooth areas - 01aug2024
   var
      sx,sy,sbits,sw,sh,dbits,dw,dh:longint;
      sr32,dr32:pcolorrow32;
      sr24,dr24:pcolorrow24;
      sr8,dr8:pcolorrow8;
      s32,d32:tcolor32;
      s24,d24:tcolor24;
      s8,d8:tcolor8;
   begin
   //defaults
   result:=false;
   xsame:=0;
   xtotal:=0;

   //init
   if not misok82432(s,sbits,sw,sh)          then exit;
   if not misok82432(d,dbits,dw,dh)          then exit;
   if (sbits<>dbits) or (sw<>dw) or (sh<>dh) then exit;
   xtotal:=sw*sh;

   //get
   for sy:=0 to (sh-1) do
   begin
   if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
   if not misscan82432(d,sy,dr8,dr24,dr32) then goto skipend;

   for sx:=0 to (sw-1) do
   begin
   //.32
   if (sbits=32) then
      begin
      s32:=sr32[sx];
      d32:=dr32[sx];
      if (s32.r>=(d32.r-v)) and (s32.r<=(d32.r+v)) and
         (s32.g>=(d32.g-v)) and (s32.g<=(d32.g+v)) and
         (s32.b>=(d32.b-v)) and (s32.b<=(d32.b+v)) then inc(xsame);
      end
   //.24
   else if (sbits=24) then
      begin
      s24:=sr24[sx];
      d24:=dr24[sx];
      if (s24.r>=(d24.r-v)) and (s24.r<=(d24.r+v)) and
         (s24.g>=(d24.g-v)) and (s24.g<=(d24.g+v)) and
         (s24.b>=(d24.b-v)) and (s24.b<=(d24.b+v)) then inc(xsame);
      end
   //.8
   else if (sbits=8) then
      begin
      s8:=sr8[sx];
      d8:=dr8[sx];
      if (s8>=(d8-v)) and (s8<=(d8+v)) then inc(xsame);
      end

   end;//sx

   end;//sy

   //set
   xpert:=frcrange32(round((xsame/frcmin32(xtotal,1))*100),0,100);

   //successful
   result:=true;
   skipend:
   end;

   function xcompress(xpert:longint):boolean;
   begin
   result:=jpg____todata(d,s,xpert);
   if not result then str__clear(d);
   end;
begin
//defaults
result       :=false;
e            :=gecTaskfailed;
sref         :=nil;
vlastdata    :=nil;
xscanquality :=65;
xforcequality:=0;//off
xqualityused :=0;

//check jpeg support is active
if not jpg__can then
   begin
   str__af(d);
   e:=gecFeaturedisabled;
   exit;
   end;

try
{$ifdef jpeg}

//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//action
if ia__ifindval(daction,ia_quality100,0,50,v) then
   begin
   xforcequality:=frcrange32(v,1,100);
   xscanquality:=0;
   end
else if ia__found(daction,ia_bestquality) then xscanquality:=95
else if ia__found(daction,ia_highquality) then xscanquality:=80
else if ia__found(daction,ia_goodquality) then xscanquality:=65
else if ia__found(daction,ia_fairquality) then xscanquality:=30
else if ia__found(daction,ia_lowquality)  then xscanquality:=10;

//.size limit - optional (0=off=disabled)
xsizelimitBytes:=ia__ifindval64b(daction,ia_limitsize64,0,0);

//init
str__clear(d);

//decide
if (xscanquality>=1) then goto doauto;

//manual quality ---------------------------------------------------------------
v:=xforcequality;

while true do
begin
if xcompress(v) then
   begin
   if (v<=1) or (xsizelimitBytes=0) or (str__len(d)<=xsizelimitBytes) then
      begin
      result:=true;
      goto skipend;
      end;
   end;

if (v<=1) then break else v:=frcmin32(v-5,1);
end;//while

goto skipend;


//automatic quality ------------------------------------------------------------
doauto:
v:=100;
vlastdata:=str__new8;
//.reference image for quality reference
sref:=misimg(sbits,sw,sh);

while true do
begin
if xcompress(v) then
   begin
   //assume successful (value is stored in "d" by default)
   result:=(str__len(d)>=1);

   if (v<=1) or (xsizelimitBytes=0) or (str__len(d)<=xsizelimitBytes) then
      begin
      str__clear(@vlastdata);
      str__add(@vlastdata,d);
      end;

   if (v<=1) or (xsizelimitBytes=0) or (str__len(d)<=xsizelimitBytes) then
      begin
      //scan to see if new jpeg "d" via "i" is too different from source image "s"
      if not mis__fromdata(sref,d,e)               then goto skipend;
      if not xsamecount(s,sref,xsame,xtotal,xpert) then goto skipend;

      //quality has dropped from the last attempt so use previous value as final value
      if (v<=1) or (xpert<xscanquality) then
         begin
         if (str__len(@vlastdata)>=1) then
            begin
            str__clear(d);
            str__add(d,@vlastdata);
            end;

         result:=(str__len(d)>=1);
         goto skipend;
         end;
      end;

   //.nothing more to do - stop
   if (v<=1) then break;
   end;

if (v<=1) then break else v:=frcmin32(v-5,1);
end;//while

goto skipend;

{$endif}

skipend:
except;end;
try
//reply info
daction:=ia__iadd(daction,ia_info_quality,[low__aorb(0,xqualityused,result)]);
daction:=ia__iadd(daction,ia_info_bytes_image,[str__len(d)]);

//free
if (not result) then str__clear(d);
str__uaf(d);
str__free(@vlastdata);
freeobj(@sref);
except;end;
end;


//tga procs --------------------------------------------------------------------
function tga__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=tga__todata2(s,d,'',e);
end;

function tga__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=tga__todata3(s,d,daction,e);
end;

function tga__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//20dec2024
label
   skipend;
const
   ssColorImage   =2;
   ssGreyImage    =3;
   ssColorImageRLE=10;
   ssGreyImageRLE =11;
var
   sxmax,dbits,sbits,sw,sh,sx,ssy,sy:longint;
   s32:tcolor32;
   s24:tcolor24;
   s8:tcolor8;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   xtopleft,xrle:boolean;
   rlist:array[0..128] of tcolor32;
   rcount:longint;
   rrepeat:boolean;

   procedure rwrite(dcount:longint);
   var
      p:longint;
   begin
   //check
   if (dcount<=0) then exit;

   //get
   str__addbyt1(d,dcount-1+insint(128,rrepeat));

   for p:=0 to (dcount-1) do
   begin

   case dbits of
   8 :str__aadd(d, [rlist[p].r] );
   24:str__aadd(d, [rlist[p].b,rlist[p].g,rlist[p].r] );
   32:str__aadd(d, [rlist[p].b,rlist[p].g,rlist[p].r,rlist[p].a] );
   end;//case

   if rrepeat then break;
   end;//p
   end;

   procedure rx;//rle8-24-32
   begin
   if (sx=0) then
      begin
      rlist[0]:=s32;
      rcount:=1;
      rrepeat:=true;
      end
   else if (rlist[rcount-1].r=s32.r) and (rlist[rcount-1].g=s32.g) and (rlist[rcount-1].b=s32.b) and (rlist[rcount-1].a=s32.a) then
      begin
      if (not rrepeat) and (rcount>=2) then
         begin
         rwrite(rcount-1);//don't write last entry as it goes towards our repeat count now
         rlist[0]:=s32;
         rlist[1]:=s32;
         rcount:=2;
         rrepeat:=true;
         end
      else
         begin
         rrepeat:=true;
         rlist[rcount]:=s32;
         inc(rcount);

         if (rcount>=129) then
            begin
            rwrite(rcount-1);
            rcount:=1;
            end;
         end;
      end
   else
      begin
      if rrepeat and (rcount>=2) then
         begin
         rwrite(rcount);

         rrepeat:=false;
         rlist[0]:=s32;
         rcount:=1;
         end
      else
         begin
         rrepeat:=false;
         rlist[rcount]:=s32;
         inc(rcount);

         if (rcount>=129) then
            begin
            rwrite(rcount-1);
            rlist[0]:=s32;
            rcount:=1;
            end;
         end;
      end;

   //.finish
   if (sx=sxmax) and (rcount>=1) then rwrite(rcount);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//range
sw:=frcrange32(sw,1,max16);
sh:=frcrange32(sh,1,max16);

//bit depth
if (daction='') or ia__found(daction,ia_tga_autobpp) or ia__found(daction,ia_tga_best) then dbits:=mis__findBPP(s)
else if ia__found(daction,ia_tga_32bpp)                                                then dbits:=32
else if ia__found(daction,ia_tga_24bpp)                                                then dbits:=24
else if ia__found(daction,ia_tga_8bpp)                                                 then dbits:=8
else                                                                                        dbits:=low__aorb(24,32,sbits=32);

//compression (rle)
xrle:=((daction='') or ia__found(daction,ia_tga_RLE) or ia__found(daction,ia_tga_best)) and (not ia__found(daction,ia_tga_noRLE));

//orientation
if      ia__found(daction,ia_tga_topleft) then xtopleft:=true
else if ia__found(daction,ia_tga_botleft) then xtopleft:=false
else                                           xtopleft:=false;

//init
str__clear(d);

//header - 18b
str__addbyt1(d,0);
str__addbyt1(d,0);

//.rle compression
if xrle then str__addbyt1(d, low__aorb(ssColorImageRLE,ssGreyImageRLE,dbits=8) )//RLE compressed RGB image or greyscale image
else         str__addbyt1(d, low__aorb(ssColorImage,ssGreyImage,dbits=8) );//uncompressed RGB image or greyscale image

str__addbyt1(d,0);
str__addbyt1(d,0);
str__addbyt1(d,0);
str__addbyt1(d,0);
str__addbyt1(d,0);

str__addbyt1(d,0);//x origin
str__addbyt1(d,0);

str__addwrd2(d,low__aorb(0,sh,xtopleft));//y origin -> in sync with "bit5: 1=top-left" below

str__addwrd2(d,sw);//width
str__addwrd2(d,sh);//height

str__addbyt1(d,dbits);//bpp
str__addbyt1(d,low__aorb(0,32,xtopleft));//bit5: 1=top-left(32), 0=bot-left(0)

//pixels
sxmax:=sw-1;

for ssy:=0 to (sh-1) do
begin
if xtopleft then sy:=ssy else sy:=sh-1-ssy;
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.32 -> 32
if (sbits=32) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];

   if xrle then
      begin
      rx;
      end
   else str__aadd(d,[s32.b,s32.g,s32.r,s32.a]);

   end;
   end
//.32 -> 24
else if (sbits=32) and (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];

   if xrle then
      begin
      s32.a:=255;
      rx;
      end
   else str__aadd(d,[s32.b,s32.g,s32.r]);

   end;
   end
//.32 -> 8
else if (sbits=32) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];
   if (s32.g>s32.r) then s32.r:=s32.g;
   if (s32.b>s32.r) then s32.r:=s32.b;

   if xrle then
      begin
      s32.b:=s32.r;
      s32.g:=s32.r;
      s32.a:=255;
      rx;
      end
   else str__aadd(d,[s32.r]);

   end;
   end
//.24 -> 32
else if (sbits=24) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];

   if xrle then
      begin
      s32.b:=s24.b;
      s32.g:=s24.g;
      s32.r:=s24.r;
      s32.a:=255;
      rx;
      end
   else str__aadd(d,[s24.b,s24.g,s24.r,255]);

   end;
   end
//.24 -> 24
else if (sbits=24) and (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];

   if xrle then
      begin
      s32.b:=s24.b;
      s32.g:=s24.g;
      s32.r:=s24.r;
      s32.a:=255;
      rx;
      end
   else str__aadd(d,[s24.b,s24.g,s24.r]);

   end;
   end
//.24 -> 8
else if (sbits=24) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];
   if (s24.g>s24.r) then s24.r:=s24.g;
   if (s24.b>s24.r) then s24.r:=s24.b;

   if xrle then
      begin
      s32.b:=s24.r;
      s32.g:=s24.r;
      s32.r:=s24.r;
      s32.a:=255;
      rx;
      end
   else str__aadd(d,[s24.r]);

   end;
   end
//.8 -> 32
else if (sbits=8) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s8:=sr8[sx];

   if xrle then
      begin
      s32.b:=s8;
      s32.g:=s8;
      s32.r:=s8;
      s32.a:=255;
      rx;
      end
   else str__aadd(d,[s8,s8,s8,255]);

   end;
   end
//.8 -> 24
else if (sbits=8) and (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s8:=sr8[sx];

   if xrle then
      begin
      s32.b:=s8;
      s32.g:=s8;
      s32.r:=s8;
      s32.a:=255;
      end
   else str__aadd(d,[s8,s8,s8]);

   end;
   end
//.8 -> 8
else if (sbits=8) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s8:=sr8[sx];

   if xrle then
      begin
      s32.b:=s8;
      s32.g:=s8;
      s32.r:=s8;
      s32.a:=255;
      rx;
      end
   else str__aadd(d,[s8]);

   end;
   end;
end;//sy

//successful
result:=true;

skipend:
except;end;
try
str__uaf(d);
except;end;
end;

function tga__fromdata(s:tobject;d:pobject;var e:string):boolean;
label
   skipend;
const
   ssColorImage   =2;
   ssGreyImage    =3;
   ssColorImageRLE=10;
   ssGreyImageRLE =11;
var
   stype,dpos,dbits,sbits,sw,sh,sx,sy,ssy:longint;
   s32:tcolor32;
   s24:tcolor24;
   s8:tcolor8;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   xrle,dtopleft:boolean;
   xcolmapBytes,idlen,v,vc:longint;
   b:tbyt1;

   procedure d32;
   begin
   s32:=str__c32(d,dpos);
   inc(dpos,4);

   s24.r:=s32.r;
   s24.g:=s32.g;
   s24.b:=s32.b;

   s8:=s32.r;
   if (s32.g>s8) then s8:=s32.g;
   if (s32.b>s8) then s8:=s32.b;
   end;

   procedure d24;
   begin
   s24:=str__c24(d,dpos);
   inc(dpos,3);

   s32.r:=s24.r;
   s32.g:=s24.g;
   s32.b:=s24.b;
   s32.a:=255;

   s8:=s32.r;
   if (s32.g>s8) then s8:=s32.g;
   if (s32.b>s8) then s8:=s32.b;
   end;

   procedure d8;
   begin
   s8:=str__c8(d,dpos);
   inc(dpos,1);

   s32.r:=s8;
   s32.g:=s8;
   s32.b:=s8;
   s32.a:=255;

   s24.r:=s8;
   s24.g:=s8;
   s24.b:=s8;
   end;

   function dv:boolean;
   begin
   v:=str__bytes0(d,dpos);
   inc(dpos);

   if (v>=128) then
      begin
      result:=true;
      vc:=(v-127);
      end
   else
      begin
      result:=false;
      vc:=-(v+1);
      end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//header - 18b
if (str__len(d)<18) then
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;

//.ident field
idlen:=str__bytes0(d,0);

//.d[1]: 0=no map included, 1=color map included -> not used for an "unmapped image"
//.color map size in bytes -> need to calc so we can skip over it
xcolmapBytes:=frcrange32(str__bytes0(d,1),0,1) * str__wrd2(d,5) * (str__bytes0(d,7) div 8);

//.type -> 2 = uncompressed RGB image, 3=uncompressed greyscale image
stype:=str__bytes0(d,2);
xrle:=(stype=ssGreyImageRLE) or (stype=ssColorImageRLE);

//.width + height
sw:=str__wrd2(d,12);
sh:=str__wrd2(d,14);
if (sw<1) or (sh<1) then
   begin
   e:=gecUnsupportedFormat;
   goto skipend;
   end;

//.bpp - 8, 24 or 32
dbits:=str__bytes0(d,16);

if ( ((stype=ssGreyImage) or (stype=ssGreyImageRLE)) and (dbits=8) )  or  ( ((stype=ssColorImage) or (stype=ssColorImageRLE)) and ((dbits=24) or (dbits=32)) ) then
   begin
   //ok
   end
else
   begin
   e:=gecUnsupportedFormat;
   goto skipend;
   end;

//.up or down
b.val:=str__bytes0(d,17);
dtopleft:=(5 in b.bits);//bit 5

//size s
if not missize(s,sw,sh) then goto skipend;

//pixels
dpos:=18+idlen+xcolmapBytes;

for ssy:=0 to (sh-1) do
begin
if dtopleft then sy:=ssy else sy:=sh-1-ssy;
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
if xrle then vc:=0 else vc:=-sw;

//.32 -> 32
if (dbits=32) and (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d32;

   if (vc<0) then
      begin
      d32;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr32[sx]:=s32;
   end;
   end
//.32 -> 24
else if (dbits=32) and (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d32;

   if (vc<0) then
      begin
      d32;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr24[sx]:=s24;
   end;
   end
//.32 -> 8
else if (dbits=32) and (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d32;

   if (vc<0) then
      begin
      d32;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr8[sx]:=s8;
   end;
   end
//.24 -> 32
else if (dbits=24) and (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d24;

   if (vc<0) then
      begin
      d24;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr32[sx]:=s32;
   end;
   end
//.24 -> 24
else if (dbits=24) and (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d24;

   if (vc<0) then
      begin
      d24;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr24[sx]:=s24;
   end;
   end
//.24 -> 8
else if (dbits=24) and (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d24;

   if (vc<0) then
      begin
      d24;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr8[sx]:=s8;
   end;
   end
//.8 -> 32
else if (dbits=8) and (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d8;

   if (vc<0) then
      begin
      d8;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr32[sx]:=s32;
   end;
   end
//.8 -> 24
else if (dbits=8) and (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d8;

   if (vc<0) then
      begin
      d8;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr24[sx]:=s24;
   end;
   end
//.8 -> 8
else if (dbits=8) and (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if xrle and (vc=0) and dv then d8;

   if (vc<0) then
      begin
      d8;
      inc(vc);
      end
   else if (vc>=1) then dec(vc);

   sr8[sx]:=s8;
   end;
   end;
end;//sy

//ai information
misai(s).count:=1;
misai(s).cellwidth:=misw(s);
misai(s).cellheight:=mish(s);
misai(s).delay:=0;
misai(s).transparent:=false;//alpha channel is used instead (if supplied image was 32bit)
misai(s).bpp:=dbits;

//successful
result:=true;

skipend:
except;end;
try;str__uaf(d);except;end;
end;

function tga32__todata(s:tobject;d:pobject):boolean;//29may2025
var
   e:string;
begin
result:=tga__todata2(s,d,ia_tga_32bpp,e);
end;

function tga24__todata(s:tobject;d:pobject):boolean;//29may2025
var
   e:string;
begin
result:=tga__todata2(s,d,ia_tga_24bpp,e);
end;

function tga8__todata(s:tobject;d:pobject):boolean;//29may2025
var
   e:string;
begin
result:=tga__todata2(s,d,ia_tga_8bpp,e);
end;


//ppm procs --------------------------------------------------------------------
function ppm__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=ppm__todata2(s,d,'',e);
end;

function ppm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=ppm__todata3(s,d,daction,e);
end;

function ppm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
label
   skipend;
var
   p,xcount,xmax,sbits,sw,sh,sx,sy:longint;
   s32:tcolor32;
   s24:tcolor24;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   dbinary:boolean;
   ilist:array[0..255] of string;

   procedure a;//ascii
   begin
   inc(xcount);
   str__sadd(d,ilist[s32.r]+ilist[s32.g]+ilist[s32.b]);
   if (xcount>=165) or (sx=xmax) then
      begin
      str__sadd(d,#10);//line length limited to 990 chars
      xcount:=0;
      end;
   end;

   procedure b;//binary
   begin
   str__aadd(d,[s32.r,s32.g,s32.b]);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//range
sw:=frcrange32(sw,1,max16);
sh:=frcrange32(sh,1,max16);

//style
if      ia__found(daction,ia_ppm_binary) then dbinary:=true
else if ia__found(daction,ia_ppm_ascii)  then dbinary:=false
else                                          dbinary:=true;

//init
str__clear(d);
if not dbinary then
   begin
   //.create list of ascii values in range 0..255 => faster
   for p:=0 to 255 do ilist[p]:=intstr32(p)+#32;
   end;

//header
str__sadd(d,low__aorbstr('P3','P6',dbinary)+#10);//P3=Ascii, P6=Binary
str__sadd(d,intstr32(sw)+#32+intstr32(sh)+#10);//width height
str__sadd(d,'255'+#10);//max color (255 for 8bit pixel element depths "rgb")

//pixels
xmax:=sw-1;
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
xcount:=0;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];
   if dbinary then b else a;
   end;
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];
   s32.r:=s24.r;
   s32.g:=s24.g;
   s32.b:=s24.b;
   if dbinary then b else a;
   end;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32.r:=sr8[sx];
   s32.g:=s32.r;
   s32.b:=s32.r;
   if dbinary then b else a;
   end;
   end;
end;//sy

//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;

function ppm__fromdata(s:tobject;d:pobject;var e:string):boolean;
label
   dobinary,doascii,skipdone,skipend;
var
   xlen,xdepth:longint;
   v:byte;
   dval,pcount,xpos,xcount,lp,p,p2,dbits,dw,dh,dx,dy:longint;
   str1:string;
   xbinary:boolean;
   s32:tcolor32;
   s24:tcolor24;
   s8:tcolor8;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;

   function ps(y:longint):boolean;
   begin
   result:=misscan82432(s,y,sr8,sr24,sr32);
   end;

   procedure pp(dval:byte);//push pixel
   begin
   //rgb
   case pcount of
   0:s24.r:=dval;
   1:s24.g:=dval;
   2:s24.b:=dval;
   end;
   inc(pcount);
   if (pcount<=2) then exit else pcount:=0;

   //check
   if (dy>=dh) then exit;

   //get
   //.32
   if (dbits=32) then
      begin
      s32.r:=s24.r;
      s32.g:=s24.g;
      s32.b:=s24.b;
      s32.a:=255;
      sr32[dx]:=s32;
      end
   //.24
   else if (dbits=24) then sr24[dx]:=s24
   //.8
   else if (dbits=8) then
      begin
      s8:=s24.r;
      if (s24.g>s8) then s8:=s24.g;
      if (s24.b>s8) then s8:=s24.b;
      sr8[dx]:=s8;
      end;

   //inc
   inc(dx);
   if (dx>=dw) then
      begin
      dx:=0;
      inc(dy);
      if (dy<dh) then ps(dy);
      end;
   end;

   procedure pb;//push binary pixel
   begin
   pp(str__bytes0(d,xpos));
   end;

   procedure pa;//push ascii pixel
   var
      v:byte;
   begin
   v:=str__bytes0(d,xpos);
   if (v>=48) and (v<=57) then
      begin
      if (dval>=1) then dval:=dval*10;
      if (dval<0) then dval:=v-48 else inc(dval,v-48);
      end
   else
      begin
      if (dval>=0) and (dval<=255) then pp(dval);
      dval:=-1;
      end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,dbits,dw,dh) then goto skipend;

//read header
e:=gecUnknownformat;
xlen:=str__len(d);
if (xlen<=2) then goto skipend;

dw:=0;
dh:=0;
dx:=0;
dy:=0;
xdepth:=0;
xbinary:=false;

lp:=0;
xcount:=0;

for p:=0 to (xlen-1) do
begin
v:=str__bytes0(d,p);

if (v=10) or (v=13) then
   begin
   str1:=str__str0(d,lp,p-lp);
   if (str1<>'') then
      begin
      if (strcopy1(str1,1,1)='#') then
         begin
         //jump over comments
         end
      else
         begin
         case xcount of
         0:begin
            if (not strmatch(str1,'p3')) and (not strmatch(str1,'p6')) then goto skipend;
            xbinary:=strmatch(str1,'p6');
            end;
         1:begin
            if (str1='') then goto skipend;
            for p2:=1 to low__len(str1) do if (str1[p2-1+stroffset]=#32) then
               begin
               dw:=strint(strcopy1(str1,1,p2-1));
               dh:=strint(strcopy1(str1,p2+1,low__len(str1)));
               break;
               end;
            end;
         2:begin
            xdepth:=strint(str1);
            if (xdepth<>255) then goto skipend;
            xpos:=p+1;
            break;
            end;
         end;//case

         inc(xcount);
         end;
      end;

   //reset
   lp:=p+1;
   end;
end;//p

//check
if (dw<1) or (dh<1) or (xdepth<=0) then goto skipend;

//size
e:=gecTaskfailed;
if not missize(s,dw,dh) then goto skipend;
if not miscls(s,clwhite) then goto skipend;

//ai information
misai(s).count:=1;
misai(s).cellwidth:=misw(s);
misai(s).cellheight:=mish(s);
misai(s).delay:=0;
misai(s).transparent:=false;//alpha channel is used instead (if supplied image was 32bit)
misai(s).bpp:=24;

//decide
dval:=-1;
pcount:=0;
ps(0);
if xbinary then goto dobinary else goto doascii;


//binary -----------------------------------------------------------------------
dobinary:
pb;
inc(xpos);
if (xpos<xlen) then goto dobinary;
goto skipdone;



//ascii ------------------------------------------------------------------------
doascii:
pa;
inc(xpos);
if (xpos<xlen) then goto doascii;
//.finalise
if (dx<(dw-1)) and (dy=(dh-1)) then pp(dval);

skipdone:
//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;


//pgm procs --------------------------------------------------------------------
function pgm__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=pgm__todata2(s,d,'',e);
end;

function pgm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=pgm__todata3(s,d,daction,e);
end;

function pgm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
label
   skipend;
var
   p,xcount,xmax,sbits,sw,sh,sx,sy:longint;
   s32:tcolor32;
   s24:tcolor24;
   s8:tcolor8;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   dbinary:boolean;
   ilist:array[0..255] of string;

   procedure a;//ascii
   begin
   inc(xcount);
   str__sadd(d,ilist[s8]);
   if (xcount>=990) or (sx=xmax) then
      begin
      str__sadd(d,#10);//line length limited to 990 chars
      xcount:=0;
      end;
   end;

   procedure b;//binary
   begin
   str__aadd(d,[s8]);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//range
sw:=frcrange32(sw,1,max16);
sh:=frcrange32(sh,1,max16);

//style
if      ia__found(daction,ia_pgm_binary) then dbinary:=true
else if ia__found(daction,ia_pgm_ascii)  then dbinary:=false
else                                          dbinary:=true;

//init
str__clear(d);
if not dbinary then
   begin
   //.create list of ascii values in range 0..255 => faster
   for p:=0 to 255 do ilist[p]:=intstr32(p)+#32;
   end;

//header
str__sadd(d,low__aorbstr('P2','P5',dbinary)+#10);//P2=Ascii, P5=Binary
str__sadd(d,intstr32(sw)+#32+intstr32(sh)+#10);//width height
str__sadd(d,'255'+#10);//max color (255 for 8bit pixel element depths "rgb")

//pixels
xmax:=sw-1;
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
xcount:=0;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];

   s8:=s32.r;
   if (s32.g>s8) then s8:=s32.g;
   if (s32.b>s8) then s8:=s32.b;

   if dbinary then b else a;
   end;
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];

   s8:=s24.r;
   if (s24.g>s8) then s8:=s24.g;
   if (s24.b>s8) then s8:=s24.b;

   if dbinary then b else a;
   end;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s8:=sr8[sx];
   if dbinary then b else a;
   end;
   end;
end;//sy

//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;

function pgm__fromdata(s:tobject;d:pobject;var e:string):boolean;
label
   dobinary,doascii,skipdone,skipend;
var
   xlen,xdepth:longint;
   v:byte;
   dval,xpos,xcount,lp,p,p2,dbits,dw,dh,dx,dy:longint;
   str1:string;
   xbinary:boolean;
   s32:tcolor32;
   s24:tcolor24;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;

   function ps(y:longint):boolean;
   begin
   result:=misscan82432(s,y,sr8,sr24,sr32);
   end;

   procedure pp(dval:byte);//push pixel
   begin
   //check
   if (dy>=dh) then exit;

   //get
   //.32
   if (dbits=32) then
      begin
      s32.r:=dval;
      s32.g:=dval;
      s32.b:=dval;
      s32.a:=255;
      sr32[dx]:=s32;
      end
   //.24
   else if (dbits=24) then
      begin
      s24.r:=dval;
      s24.g:=dval;
      s24.b:=dval;
      sr24[dx]:=s24;
      end
   //.8
   else if (dbits=8) then
      begin
      sr8[dx]:=dval;
      end;

   //inc
   inc(dx);
   if (dx>=dw) then
      begin
      dx:=0;
      inc(dy);
      if (dy<dh) then ps(dy);
      end;
   end;

   procedure pb;//push binary pixel
   begin
   pp(str__bytes0(d,xpos));
   end;

   procedure pa;//push ascii pixel
   var
      v:byte;
   begin
   v:=str__bytes0(d,xpos);
   if (v>=48) and (v<=57) then
      begin
      if (dval>=1) then dval:=dval*10;
      if (dval<0) then dval:=v-48 else inc(dval,v-48);
      end
   else
      begin
      if (dval>=0) and (dval<=255) then pp(dval);
      dval:=-1;
      end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,dbits,dw,dh) then goto skipend;

//read header
e:=gecUnknownformat;
xlen:=str__len(d);
if (xlen<=2) then goto skipend;

dw:=0;
dh:=0;
dx:=0;
dy:=0;
xdepth:=0;
xbinary:=false;

lp:=0;
xcount:=0;

for p:=0 to (xlen-1) do
begin
v:=str__bytes0(d,p);

if (v=10) or (v=13) then
   begin
   str1:=str__str0(d,lp,p-lp);
   if (str1<>'') then
      begin
      if (strcopy1(str1,1,1)='#') then
         begin
         //jump over comments
         end
      else
         begin
         case xcount of
         0:begin
            if (not strmatch(str1,'p2')) and (not strmatch(str1,'p5')) then goto skipend;
            xbinary:=strmatch(str1,'p5');
            end;
         1:begin
            if (str1='') then goto skipend;
            for p2:=1 to low__len(str1) do if (str1[p2-1+stroffset]=#32) then
               begin
               dw:=strint(strcopy1(str1,1,p2-1));
               dh:=strint(strcopy1(str1,p2+1,low__len(str1)));
               break;
               end;
            end;
         2:begin
            xdepth:=strint(str1);
            if (xdepth<>255) then goto skipend;
            xpos:=p+1;
            break;
            end;
         end;//case

         inc(xcount);
         end;
      end;

   //reset
   lp:=p+1;
   end;
end;//p


//check
if (dw<1) or (dh<1) or (xdepth<=0) then goto skipend;

//size
e:=gecTaskfailed;
if not missize(s,dw,dh) then goto skipend;
if not miscls(s,clwhite) then goto skipend;

//ai information
misai(s).count:=1;
misai(s).cellwidth:=misw(s);
misai(s).cellheight:=mish(s);
misai(s).delay:=0;
misai(s).transparent:=false;//alpha channel is used instead (if supplied image was 32bit)
misai(s).bpp:=8;

//decide
dval:=-1;
ps(0);
if xbinary then goto dobinary else goto doascii;


//binary -----------------------------------------------------------------------
dobinary:
pb;
inc(xpos);
if (xpos<xlen) then goto dobinary;
goto skipdone;



//ascii ------------------------------------------------------------------------
doascii:
pa;
inc(xpos);
if (xpos<xlen) then goto doascii;
//.finalise
if (dx<(dw-1)) and (dy=(dh-1)) then pp(dval);

skipdone:
//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;


//pbm procs --------------------------------------------------------------------
function pbm__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=pbm__todata2(s,d,'',e);
end;

function pbm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=pbm__todata3(s,d,daction,e);
end;

function pbm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
label
   skipend;
var
   dbitcount,p,xcount,xmax,sbits,sw,sh,sx,sy:longint;
   dval:byte;
   s32:tcolor32;
   s24:tcolor24;
   s8:tcolor8;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   dbinary:boolean;
   ilist:array[0..255] of string;
   ibitlist:array[0..7] of byte;

   procedure a;//ascii
   begin
   inc(xcount);
   str__sadd(d,ilist[s8]);
   if (xcount>=990) or (sx=xmax) then
      begin
      str__sadd(d,#10);//line length limited to 990 chars
      xcount:=0;
      end;
   end;

   procedure b;//binary
   begin
   if (s8>=1) then inc(dval,ibitlist[dbitcount]);

   if (dbitcount>=7) or (sx=xmax) then
      begin
      str__aadd(d,[dval]);
      dval:=0;
      dbitcount:=0;
      end
   else inc(dbitcount);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//range
sw:=frcrange32(sw,1,max16);
sh:=frcrange32(sh,1,max16);

//style
if      ia__found(daction,ia_pbm_binary) then dbinary:=true
else if ia__found(daction,ia_pbm_ascii)  then dbinary:=false
else                                          dbinary:=true;

//init
str__clear(d);
if not dbinary then
   begin
   //.create list of ascii values in range 0..255 => faster
   for p:=0 to 255 do ilist[p]:=intstr32(p);//no trailing space required as these are bits (0 or 1) single digits
   end;

//.bit list
ibitlist[7]:=1;
ibitlist[6]:=2;
ibitlist[5]:=4;
ibitlist[4]:=8;
ibitlist[3]:=16;
ibitlist[2]:=32;
ibitlist[1]:=64;
ibitlist[0]:=128;

//header
str__sadd(d,low__aorbstr('P1','P4',dbinary)+#10);//P1=Ascii, P4=Binary
str__sadd(d,intstr32(sw)+#32+intstr32(sh)+#10);//width height

//pixels
xmax:=sw-1;
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
xcount:=0;
dbitcount:=0;//bit counter
dval:=0;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];

   s8:=s32.r;
   if (s32.g>s8) then s8:=s32.g;
   if (s32.b>s8) then s8:=s32.b;
   if (s8>=128) then s8:=0 else s8:=1;

   if dbinary then b else a;
   end;
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];

   s8:=s24.r;
   if (s24.g>s8) then s8:=s24.g;
   if (s24.b>s8) then s8:=s24.b;
   if (s8>=128) then s8:=0 else s8:=1;

   if dbinary then b else a;
   end;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s8:=sr8[sx];
   if (s8>=128) then s8:=0 else s8:=1;
   if dbinary then b else a;
   end;
   end;
end;//sy

//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;

function pbm__fromdata(s:tobject;d:pobject;var e:string):boolean;
label
   dobinary,doascii,skipdone,skipend;
var
   xlen:longint;
   v:byte;
   xpos,xcount,lp,p,p2,dbits,dw,dh,dx,dy:longint;
   str1:string;
   xbinary:boolean;
   s32:tcolor32;
   s24:tcolor24;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;

   function ps(y:longint):boolean;
   begin
   result:=misscan82432(s,y,sr8,sr24,sr32);
   end;

   procedure pp(dval:boolean);//push pixel
   begin
   //check
   if (dy>=dh) then exit;

   //range
   if dval then s24.r:=0 else s24.r:=255;

   //get
   //.32
   if (dbits=32) then
      begin
      s32.r:=s24.r;
      s32.g:=s24.r;
      s32.b:=s24.r;
      s32.a:=255;
      sr32[dx]:=s32;
      end
   //.24
   else if (dbits=24) then
      begin
      s24.g:=s24.r;
      s24.b:=s24.r;
      sr24[dx]:=s24;
      end
   //.8
   else if (dbits=8) then
      begin
      sr8[dx]:=s24.r;
      end;

   //inc
   inc(dx);
   if (dx>=dw) then
      begin
      dx:=0;
      inc(dy);
      if (dy<dh) then ps(dy);
      end;
   end;

   procedure pb;//push binary pixel
   var
      v:byte;
      oy:longint;
   begin
   v:=str__bytes0(d,xpos);
   oy:=dy;

   pp(v>=128);
   if (v>=128) then dec(v,128);
   if (dy<>oy) then exit;

   pp(v>=64);
   if (v>=64) then dec(v,64);
   if (dy<>oy) then exit;

   pp(v>=32);
   if (v>=32) then dec(v,32);
   if (dy<>oy) then exit;

   pp(v>=16);
   if (v>=16) then dec(v,16);
   if (dy<>oy) then exit;

   pp(v>=8);
   if (v>=8) then dec(v,8);
   if (dy<>oy) then exit;

   pp(v>=4);
   if (v>=4) then dec(v,4);
   if (dy<>oy) then exit;

   pp(v>=2);
   if (v>=2) then dec(v,2);
   if (dy<>oy) then exit;

   pp(v>=1);
   end;

   procedure pa;//push ascii pixel
   var
      v:byte;
   begin
   v:=str__bytes0(d,xpos);
   if (v>=48) and (v<=49) then pp(v=49);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,dbits,dw,dh) then goto skipend;

//read header
e:=gecUnknownformat;
xlen:=str__len(d);
if (xlen<=2) then goto skipend;

dw:=0;
dh:=0;
dx:=0;
dy:=0;
xbinary:=false;

lp:=0;
xcount:=0;

for p:=0 to (xlen-1) do
begin
v:=str__bytes0(d,p);

if (v=10) or (v=13) then
   begin
   str1:=str__str0(d,lp,p-lp);
   if (str1<>'') then
      begin
      if (strcopy1(str1,1,1)='#') then
         begin
         //jump over comments
         end
      else
         begin
         case xcount of
         0:begin
            if (not strmatch(str1,'p1')) and (not strmatch(str1,'p4')) then goto skipend;
            xbinary:=strmatch(str1,'p4');
            end;
         1:begin
            if (str1='') then goto skipend;
            for p2:=1 to low__len(str1) do if (str1[p2-1+stroffset]=#32) then
               begin
               dw:=strint(strcopy1(str1,1,p2-1));
               dh:=strint(strcopy1(str1,p2+1,low__len(str1)));
               break;
               end;
            xpos:=p+1;
            break;
            end;
         end;//case

         inc(xcount);
         end;
      end;

   //reset
   lp:=p+1;
   end;
end;//p


//check
if (dw<1) or (dh<1) then goto skipend;

//size
e:=gecTaskfailed;
if not missize(s,dw,dh) then goto skipend;
if not miscls(s,clwhite) then goto skipend;

//ai information
misai(s).count:=1;
misai(s).cellwidth:=misw(s);
misai(s).cellheight:=mish(s);
misai(s).delay:=0;
misai(s).transparent:=false;//alpha channel is used instead (if supplied image was 32bit)
misai(s).bpp:=1;

//decide
ps(0);
if xbinary then goto dobinary else goto doascii;


//binary -----------------------------------------------------------------------
dobinary:
pb;
inc(xpos);
if (xpos<xlen) then goto dobinary;
goto skipdone;



//ascii ------------------------------------------------------------------------
doascii:
pa;
inc(xpos);
if (xpos<xlen) then goto doascii;

skipdone:
//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;


//pnm procs --------------------------------------------------------------------
function pnm__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=pnm__todata2(s,d,'',e);
end;

function pnm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=pnm__todata3(s,d,daction,e);
end;

function pnm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
label
   skipend;
var
   p,sbits,sw,sh,sx,sy:longint;
   s32:tcolor32;
   s24:tcolor24;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   dbinary:boolean;
   ilist:array[0..255] of string;

   procedure a;//ascii
   begin
   str__sadd(d,ilist[s32.r]+ilist[s32.g]+ilist[s32.b]);
   end;

   procedure b;//binary
   begin
   str__aadd(d,[s32.r,s32.g,s32.b]);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//range
sw:=frcrange32(sw,1,max16);
sh:=frcrange32(sh,1,max16);

//style
if      ia__found(daction,ia_pnm_binary) then dbinary:=true
else if ia__found(daction,ia_pnm_ascii)  then dbinary:=false
else                                          dbinary:=true;

//init
str__clear(d);
if not dbinary then
   begin
   //.create list of ascii values in range 0..255 => faster
   for p:=0 to 255 do ilist[p]:=intstr32(p)+#10;
   end;

//header
str__sadd(d,low__aorbstr('P3','P6',dbinary)+#10);//P3=Ascii, P6=Binary
str__sadd(d,intstr32(sw)+#32+intstr32(sh)+#10);//width height
str__sadd(d,'255'+#10);//max color (255 for 8bit pixel element depths "rgb")

//pixels
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];
   if dbinary then b else a;
   end;
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];
   s32.r:=s24.r;
   s32.g:=s24.g;
   s32.b:=s24.b;
   if dbinary then b else a;
   end;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32.r:=sr8[sx];
   s32.g:=s32.r;
   s32.b:=s32.r;
   if dbinary then b else a;
   end;
   end;
end;//sy

//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;

function pnm__fromdata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=ppm__fromdata(s,d,e);
end;


//xbm procs --------------------------------------------------------------------
function xbm__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=xbm__todata2(s,d,'',e);
end;

function xbm__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=xbm__todata3(s,d,daction,e);
end;

function xbm__todata3(s:tobject;d:pobject;var daction,e:string):boolean;
label
   skipend;
const
   xnewlinetrigger=12;
var
   n:string;
   xcount,dbitcount,xmax,ymax,sbits,sw,sh,sx,sy:longint;
   dval:byte;
   s32:tcolor32;
   s24:tcolor24;
   s8:tcolor8;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   ibitlist:array[0..7] of byte;

   function xsafename(x:string):string;
   var
      p:longint;
   begin
   result:=x;

   if (result<>'') then
      begin

      for p:=1 to low__len(result) do
      begin
      case byte(result[p-1+stroffset]) of
      48..57,65..90,97..122,95:;//0..9, A..Z, a..z
      else result[p-1+stroffset]:='_';//95
      end;//case
      end;//p

      end;
   end;

   procedure a;//ascii
   begin
   if (s8>=1) then inc(dval,ibitlist[dbitcount]);

   if (dbitcount>=7) or (sx=xmax) then
      begin
      if (xcount=0) then str__sadd(d,#32+#32+#32);//3 space indent

      inc(xcount);

      if      (sx=xmax) and (sy=ymax)  then str__sadd(d,'0x'+low__hex_lowercase(dval)+' };'+#10)
      else if (xcount<xnewlinetrigger) then str__sadd(d,'0x'+low__hex_lowercase(dval)+', ')
      else                                  str__sadd(d,'0x'+low__hex_lowercase(dval)+',');

      dval:=0;
      dbitcount:=0;

      if (xcount>=xnewlinetrigger) then
         begin
         if not ((sx=xmax) and (sy=ymax)) then str__aadd(d,[10]);
         xcount:=0;
         end;

      end
   else inc(dbitcount);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//range
sw:=frcrange32(sw,1,max16);
sh:=frcrange32(sh,1,max16);

//style
if ia__sfindval(daction,ia_info_filename,0,'image',n) then n:=io__remlastext(io__extractfilename(n));
n:=xsafename(strdefb(n,'image'));

//init
str__clear(d);

//.bit list
ibitlist[0]:=1;
ibitlist[1]:=2;
ibitlist[2]:=4;
ibitlist[3]:=8;
ibitlist[4]:=16;
ibitlist[5]:=32;
ibitlist[6]:=64;
ibitlist[7]:=128;

//header
str__sadd(d,
 '#define '+n+'_width '+intstr32(sw)+#10+
 '#define '+n+'_height '+intstr32(sh)+#10+
 'static unsigned char '+n+'_bits[] = {'+#10);

//pixels
ymax:=sh-1;
xmax:=sw-1;
xcount:=0;

for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
dbitcount:=0;//bit counter
dval:=0;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];

   s8:=s32.r;
   if (s32.g>s8) then s8:=s32.g;
   if (s32.b>s8) then s8:=s32.b;
   if (s8>=128) then s8:=0 else s8:=1;

   a;
   end;
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];

   s8:=s24.r;
   if (s24.g>s8) then s8:=s24.g;
   if (s24.b>s8) then s8:=s24.b;
   if (s8>=128) then s8:=0 else s8:=1;

   a;
   end;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s8:=sr8[sx];
   if (s8>=128) then s8:=0 else s8:=1;
   a;
   end;
   end;
end;//sy

//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;

function xbm__fromdata(s:tobject;d:pobject;var e:string):boolean;
label
   dobinary,doascii,skipdone,skipend;
var
   xlen:longint;
   v:byte;
   xpos,xcount,lp,p,p2,dbits,dw,dh,dx,dy:longint;
   str1:string;
   xbinary:boolean;
   s32:tcolor32;
   s24:tcolor24;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;

   function ps(y:longint):boolean;
   begin
   result:=misscan82432(s,y,sr8,sr24,sr32);
   end;

   procedure pp(dval:boolean);//push pixel
   begin
   //check
   if (dy>=dh) then exit;

   //range
   if dval then s24.r:=0 else s24.r:=255;

   //get
   //.32
   if (dbits=32) then
      begin
      s32.r:=s24.r;
      s32.g:=s24.r;
      s32.b:=s24.r;
      s32.a:=255;
      sr32[dx]:=s32;
      end
   //.24
   else if (dbits=24) then
      begin
      s24.g:=s24.r;
      s24.b:=s24.r;
      sr24[dx]:=s24;
      end
   //.8
   else if (dbits=8) then
      begin
      sr8[dx]:=s24.r;
      end;

   //inc
   inc(dx);
   if (dx>=dw) then
      begin
      dx:=0;
      inc(dy);
      if (dy<dh) then ps(dy);
      end;
   end;

   procedure pb;//push binary pixel
   var
      v:byte;
      oy:longint;
   begin
   v:=str__bytes0(d,xpos);
   oy:=dy;

   pp(v>=128);
   if (v>=128) then dec(v,128);
   if (dy<>oy) then exit;

   pp(v>=64);
   if (v>=64) then dec(v,64);
   if (dy<>oy) then exit;

   pp(v>=32);
   if (v>=32) then dec(v,32);
   if (dy<>oy) then exit;

   pp(v>=16);
   if (v>=16) then dec(v,16);
   if (dy<>oy) then exit;

   pp(v>=8);
   if (v>=8) then dec(v,8);
   if (dy<>oy) then exit;

   pp(v>=4);
   if (v>=4) then dec(v,4);
   if (dy<>oy) then exit;

   pp(v>=2);
   if (v>=2) then dec(v,2);
   if (dy<>oy) then exit;

   pp(v>=1);
   end;

   procedure pa;//push ascii pixel
   var
      v:byte;
   begin
   v:=str__bytes0(d,xpos);
   if (v>=48) and (v<=49) then pp(v=49);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if not str__lock(d) then goto skipend;
if not misok82432(s,dbits,dw,dh) then goto skipend;

//read header
e:=gecUnknownformat;
xlen:=str__len(d);
if (xlen<=2) then goto skipend;

dw:=0;
dh:=0;
dx:=0;
dy:=0;
xbinary:=false;

lp:=0;
xcount:=0;

for p:=0 to (xlen-1) do
begin
v:=str__bytes0(d,p);

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

if (v=10) or (v=13) then
   begin
   str1:=str__str0(d,lp,p-lp);
   if (str1<>'') then
      begin
      if (strcopy1(str1,1,1)='#') then
         begin
         //jump over comments
         end
      else
         begin
         case xcount of
         0:begin
            if (not strmatch(str1,'p1')) and (not strmatch(str1,'p4')) then goto skipend;
            xbinary:=strmatch(str1,'p4');
            end;
         1:begin
            if (str1='') then goto skipend;
            for p2:=1 to low__len(str1) do if (str1[p2-1+stroffset]=#32) then
               begin
               dw:=strint(strcopy1(str1,1,p2-1));
               dh:=strint(strcopy1(str1,p2+1,low__len(str1)));
               break;
               end;
            xpos:=p+1;
            break;
            end;
         end;//case

         inc(xcount);
         end;
      end;

   //reset
   lp:=p+1;
   end;
end;//p


//check
if (dw<1) or (dh<1) then goto skipend;

//size
e:=gecTaskfailed;
if not missize(s,dw,dh) then goto skipend;
if not miscls(s,clwhite) then goto skipend;

//ai information
misai(s).count:=1;
misai(s).cellwidth:=misw(s);
misai(s).cellheight:=mish(s);
misai(s).delay:=0;
misai(s).transparent:=false;//alpha channel is used instead (if supplied image was 32bit)
misai(s).bpp:=1;

//decide
ps(0);
if xbinary then goto dobinary else goto doascii;


//binary -----------------------------------------------------------------------
dobinary:
pb;
inc(xpos);
if (xpos<xlen) then goto dobinary;
goto skipdone;



//ascii ------------------------------------------------------------------------
doascii:
pa;
inc(xpos);
if (xpos<xlen) then goto doascii;

skipdone:
//successful
result:=true;
skipend:
except;end;
try;str__uaf(d);except;end;
end;


//ico procs --------------------------------------------------------------------
function ico__todata(s:tobject;d:pobject;var e:string):boolean;//27may2025
begin
result:=ico__todata2(s,d,'',e);
end;

function ico__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;//27may2025
begin
result:=ico__todata3(s,d,daction,e);
end;

function ico__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//19jun2025, 27may2025
label
   skipend;
var
   dbits:longint;
   xtransparent,xsimple0255:boolean;
begin
//defaults
result       :=false;
e            :=gecTaskfailed;

try
//get
case misb(s) of
24  :dbits:=24;
8   :dbits:=8;
else dbits:=32;
end;

//decide
xtransparent:=mask__hasTransparency322(s,xsimple0255);

if (not xtransparent) or xsimple0255 then
   begin
   case mis__countcolors257(s) of
   0..15  :dbits:=4;//1 color for transparency or not
   17..255:dbits:=8;//1 color for transparency or not
   else    dbits:=24;
   end;//case
   end;

//.min bit depth
if      ia__found(daction,ia_32bitPLUS)   then dbits:=32
else if ia__found(daction,ia_24bitPLUS)   then dbits:=24;

//set
result:=icoXX__todata(s,d,dbits);

//.information feedback
if result then
   begin
   daction:=ia__iadd(daction,ia_bpp,dbits);
   daction:=ia__iadd(daction,ia_transparent,[low__aorb(0,1,xtransparent)]);
   end;

skipend:
except;end;
end;

function icoXX__todata(s:tobject;d:pobject;dbits:longint):boolean;//27may2025
begin
case dbits of
32,24,16,8,4:result:=ico32__todata2(s,d,dbits);
else         result:=ico32__todata2(s,d,32);
end;//case
end;

function ico32__todata(s:tobject;d:pobject):boolean;//27may2025
begin
result:=ico32__todata2(s,d,32);
end;

function ico24__todata(s:tobject;d:pobject):boolean;//27may2025
begin
result:=ico32__todata2(s,d,24);
end;

function ico16__todata(s:tobject;d:pobject):boolean;//27may2025
begin
result:=ico32__todata2(s,d,16);
end;

function ico8__todata(s:tobject;d:pobject):boolean;//27may2025
begin
result:=ico32__todata2(s,d,8);
end;

function ico4__todata(s:tobject;d:pobject):boolean;//27may2025
begin
result:=ico32__todata2(s,d,4);
end;

function ico32__todata2(s:tobject;d:pobject;dbits:longint):boolean;//27may2025
begin
result:=ico32__todata3(s,d,false,false,0,0,dbits);
end;

function ico32__todata3(s:tobject;d:pobject;dpng,dcursor:boolean;dhotX,dhotY,dbits:longint):boolean;//28may2025
label
   skipend;
var
   etmp:string;
   d8:tstr8;//pointer only
   dimg,dmask:tstr8;
   dcolorsused,sbits,sw,sh:longint;

   procedure w1(const x:byte);
   begin
   if (d8<>nil) then d8.addbyt1(x) else str__addbyt1(d,x);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;
begin
//defaults
result :=false;
dimg   :=nil;
dmask  :=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;
if (dbits<>32) and (dbits<>24) and (dbits<>16) and (dbits<>8) and (dbits<>4) then goto skipend;

//range
dhotX :=frcrange32(dhotX,-1,sw-1);
dhotY :=frcrange32(dhotY,-1,sh-1);

//init
d8           :=str__as8(d);
str__clear(d);
dimg         :=str__new8;
dmask        :=str__new8;
dcolorsused  :=0;

//automatic hotspot
if dcursor and ((dhotX<0) or (dhotY<0)) then ico32__findhotspot(s,sw,sh,dhotX,dhotY);

//get
//.image data (no header)
case dbits of
32,24,16:if not bmp32__toicondata(s,@dimg,dbits)      then goto skipend;
8       :if not bmp8__toicondata(s,@dimg,dcolorsused) then goto skipend;
4       :if not bmp4__toicondata(s,@dimg,dcolorsused) then goto skipend;
else                                                       goto skipend;
end;

//.1bit mask (no header, no palette)
if not bmp1__toicondata(s,@dmask) then goto skipend;

//.colors used -> ok to zero value out if full range (colors) used in palette
case dbits of
8:if (dcolorsused>=256) then dcolorsused:=0;
4:if (dcolorsused>=16)  then dcolorsused:=0;
end;

//set
//.type header (6)
w2(0);
w2( low__aorb(1,2,dcursor) );//0=stockicon, 1=icon (default for icons), 2=cursor
w2(1);//count

//.icon header (16)
if (sw<=255) then w1(sw) else w1(0);
if (sh<=255) then w1(sh) else w1(0);
w2(0);//colors

case dcursor of
true:begin
   w2( frcrange32(dhotX,0,max16) );//reserved1
   w2( frcrange32(dhotY,0,max16) );//reserved2
   end;
else begin
   w2(1);//color planes
   w2(dbits);//bits
   end;
end;//case


//png - store png --------------------------------------------------------------
if dpng or (sw>=257) or (sh>=257) then
   begin
   result:=png__todata(s,@dimg,etmp);
   if not result then goto skipend;

   //.finish ico header
   w4(dimg.len);
   w4(22);//6 + 16 = 22

   //.store png
   str__add(d,@dimg);
   goto skipend;
   end;


//ico - store icon + mask ------------------------------------------------------
//.finish ico header
w4(40 + dimg.len + dmask.len);
w4(22);//6 + 16 = 22

//.image header (40)
w4(40);//biSize
w4(sw);//biWidth
w4(sh * 2);//biHeight (x2 = image + trailing 1bit mask)
w2(1);//biPlanes
w2(dbits);//biBitCount
w4(0);//compression=0
w4(dimg.len + dmask.len);
w4(0);
w4(0);
w4(dcolorsused);//# of colors used
w4(dcolorsused);//# of important colors

//.image data
str__add(d,@dimg);
str__add(d,@dmask);

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__free(@dimg);
str__free(@dmask);
str__uaf(d);
end;

function ico__fromdata(d:tobject;s:pobject;var e:string):boolean;
begin
e:=gecTaskfailed;
result:=ico32__fromdata(d,s);
end;

function ico32__fromdata(s:tobject;d:pobject):boolean;//27may2025
var
   hx,hy:longint;
begin
result:=ico32__fromdata2(s,d,hx,hy);
end;

function ico32__fromdata2(s:tobject;d:pobject;var dhotX,dhotY:longint):boolean;//08jun2025, 27may2025
label
   skipend;
var
   str1,etmp:string;
   plist:array[0..255] of tcolor32;
   d8:tstr8;//pointer only
   b:tstr8;
   ymax,px,pval,p,dstartofdata,drowsize1,drowsize,ddatalen,dcount,dlen,dpos,pcount,dbits,sbits,sw,sh,dw,dh,dx,dy:longint;
   dcursor:boolean;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32:tcolor32;
   c24:tcolor24;

   function r1:byte;
   begin
   case (dpos<dlen) of
   true:if (d8<>nil) then result:=d8.pbytes[dpos] else result:=str__byt1(d,dpos);
   else result:=0;
   end;//case
   //inc
   inc(dpos);
   end;

   function r2:word;
   begin
   twrd2(result).bytes[0]:=r1;
   twrd2(result).bytes[1]:=r1;
   end;

   function r4:longint;
   begin
   tint4(result).bytes[0]:=r1;
   tint4(result).bytes[1]:=r1;
   tint4(result).bytes[2]:=r1;
   tint4(result).bytes[3]:=r1;
   end;

   function r1_bol:boolean;
   var
      i:byte;

      procedure v(xdiv:byte);
      begin
      i:=pval div xdiv;
      dec(pval,i*xdiv);
      end;
   begin
   //inc
   inc(px);
   if (px>=9) then px:=1;
   if (px=1)  then pval:=r1;

   //get
   case px of
   1:v(128);
   2:v(64);
   3:v(32);
   4:v(16);
   5:v(8);
   6:v(4);
   7:v(2);
   8:i:=pval;
   end;//case

   result:=(i<>0);//transparent pixel in 1bit mask
   end;

   procedure r4_32;
   var
      i:byte;
   begin
   //inc
   inc(px);
   if (px>=3) then px:=1;
   if (px=1)  then pval:=r1;

   //get
   case px of
   1:begin
      i:=pval div 16;
      dec(pval,i*16);
      end;
   2:i:=pval;
   else i:=0;
   end;//case

   //enforce upper limit
   if (i>=pcount) then i:=pcount-1;

   //set
   c32:=plist[i];
   end;

   procedure r8_32;
   var
      i:byte;
   begin
   //enforce upper limit
   i:=r1;
   if (i>=pcount) then i:=pcount-1;

   c32:=plist[i];
   end;

   procedure r16;//555 = 15bit
   var//0..255 div 8 -> 0..31 (5 bit)
      v:word;

      procedure p(var dcol:byte;xfactor:longint);
      var
         z:word;
      begin
      z:=v div xfactor;
      dec(v,z*xfactor);
      z:=z*8;
      if (z>255) then z:=255;
      dcol:=z;
      end;
   begin
   v:=r2;
   p(c24.r,1024);
   p(c24.g,32);
   p(c24.b,1);
   end;

   procedure r24;
   begin
   c24.b:=r1;
   c24.g:=r1;
   c24.r:=r1;
   end;

   procedure r32;
   begin
   c32.b:=r1;
   c32.g:=r1;
   c32.r:=r1;
   c32.a:=r1;
   end;
begin
//defaults
result :=false;
dhotX  :=0;
dhotY  :=0;
dbits  :=32;
b      :=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
d8           :=str__as8(d);
dlen         :=str__len(d);
dpos         :=0;

//get
//.type header (6)
r2;
dcursor :=(r2=2);//0=stockicon, 1=icon (default for icons), 2=cursor
dcount  :=r2;

//.icon header (16)
r1;//width
r1;//height
r2;//colors

case dcursor of
true:begin
   dhotX:=r2;
   dhotY:=r2;
   end;
else begin
   r2;//reserved1
   r2;//reserved2
   end;
end;//case

ddatalen:=r4;//40 + dimg.len + dmask.len;

//.jump to beginning of 1st image
dpos:=r4;
if (dpos<22) then goto skipend;


//image is a "png" -------------------------------------------------------------
str1:=io__anyformat2b(d,dpos);
if strmatch(str1,'PNG') then
   begin
   b:=str__new8;
   str__add3(@b,d,dpos,ddatalen);
   result:=png__fromdata(s,@b,etmp);
   str__free(@b);//reduce memory
   goto skipend;
   end
else if strmatch(str1,'JPG') then//08jun2025
   begin
   b:=str__new8;
   str__add3(@b,d,dpos,ddatalen);
   result:=jpg__fromdata(s,@b,etmp);
   str__free(@b);//reduce memory
   goto skipend;
   end;


//image is an "ico" ------------------------------------------------------------
//.image header (40)
if (r4<>40) then goto skipend;//biSize
dw    :=r4;//biWidth
dh    :=r4 div 2;//biHeight (x2 = image + trailing 1bit mask)
if (dw<=0) or (dh<=0) then goto skipend;

dhotX :=frcrange32(dhotX,0,dw-1);
dhotY :=frcrange32(dhotY,0,dh-1);
if (1<>r2) then goto skipend;//biPlanes

//.bit depth
dbits :=r2;
if (dbits<>32) and (dbits<>24) and (dbits<>16) and (dbits<>8) and (dbits<>4) then goto skipend;

//.compression=0
if (r4<>0)  then goto skipend;

//.data length
ddatalen:=r4;//dimg.len + dmask.len;
r4;
r4;

//.number of colors used (8 & 4 bit)
pcount:=frcrange32(r4,0,256);

case dbits of
8:if (pcount<=0) then pcount:=256 else pcount:=frcrange32(pcount,0,256);
4:if (pcount<=0) then pcount:=16  else pcount:=frcrange32(pcount,0,16);
else pcount:=0;
end;//case

r4;//# of important colors

//calc -> headsize  = 6 + 16 + 40;
drowsize    :=mis__rowsize4(dw,dbits);
drowsize1   :=mis__rowsize4(dw,1);//1bit mask rowsize
ymax        :=dh-1;
dstartofdata:=dpos;


//size and clear
if not missize(s,dw,dh) then goto skipend;
mis__cls(s,255,255,255,255);


//read palette
for p:=0 to (pcount-1) do
begin
plist[p].b:=r1;
plist[p].g:=r1;
plist[p].r:=r1;
plist[p].a:=r1;
plist[p].a:=255;//force as solid
end;//p


//ico - read color image data --------------------------------------------------
for dy:=0 to (dh-1) do
begin
if not misscan82432(s,ymax-dy,sr8,sr24,sr32) then goto skipend;

dpos:=dstartofdata + (pcount*4) + (dy * drowsize);
px  :=0;

if (dbits=32) and (sbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r32;
   sr32[dx]:=c32;
   end;//dx
   end
else if (dbits=32) and (sbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r32;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   sr24[dx]:=c24;
   end;//dx
   end
else if (dbits=32) and (sbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r32;
   sr8[dx]:=c32__lum(c32);
   end;//dx
   end
else if (dbits=24) and (sbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r24;
   c32.r:=c24.r;
   c32.g:=c24.g;
   c32.b:=c24.b;
   c32.a:=255;
   sr32[dx]:=c32;
   end;//dx
   end
else if (dbits=24) and (sbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r24;
   sr24[dx]:=c24;
   end;//dx
   end
else if (dbits=24) and (sbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r24;
   sr8[dx]:=c24__lum(c24);
   end;//dx
   end
else if (dbits=16) and (sbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r16;
   c32.r:=c24.r;
   c32.g:=c24.g;
   c32.b:=c24.b;
   c32.a:=255;
   sr32[dx]:=c32;
   end;//dx
   end
else if (dbits=16) and (sbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r16;
   sr24[dx]:=c24;
   end;//dx
   end
else if (dbits=16) and (sbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r16;
   sr8[dx]:=c24__lum(c24);
   end;//dx
   end
else if (dbits=8) and (sbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r8_32;
   sr32[dx]:=c32;
   end;//dx
   end
else if (dbits=8) and (sbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r8_32;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   sr24[dx]:=c24;
   end;//dx
   end
else if (dbits=24) and (sbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r8_32;
   sr8[dx]:=c32__lum(c32);
   end;//dx
   end
else if (dbits=4) and (sbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r4_32;
   sr32[dx]:=c32;
   end;//dx
   end
else if (dbits=4) and (sbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r4_32;
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   sr24[dx]:=c24;
   end;//dx
   end
else if (dbits=4) and (sbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   r4_32;
   sr8[dx]:=c32__lum(c32);
   end;//dx
   end;
end;//dy

//.color image already has alpha data -> no need to read mask
if (dbits=32) then
   begin
   result:=true;
   goto skipend;
   end;

//.destination "s" image does not support transparency -> no point reading mask
if (sbits<>32) then
   begin
   result:=true;
   goto skipend;
   end;


//ico - read 1bit mask image data ----------------------------------------------
for dy:=0 to (dh-1) do
begin
if not misscan32(s,ymax-dy,sr32) then goto skipend;

dpos:=dstartofdata + (pcount*4) + (drowsize*dh) + (dy * drowsize1);
px  :=0;

for dx:=0 to (dw-1) do if r1_bol then sr32[dx].a:=0;

end;//dy


//successful
result:=true;
skipend:

//.ai information
if result then
   begin
   misai(s).count       :=1;
   misai(s).cellwidth   :=misw(s);
   misai(s).cellheight  :=misw(s);
   misai(s).delay       :=0;
   misai(s).transparent :=false;//alpha channel is used instead (if supplied image was 32bit)
   misai(s).bpp         :=dbits;
   misai(s).hotspotx    :=dhotx;
   misai(s).hotspoty    :=dhoty;
   end;
except;end;
//free
str__free(@b);
str__uaf(d);
end;

function ico32__findhotspot(s:tobject;sw,sh:longint;var hx,hy:longint):boolean;
label
   skipend;
var
   sbits,sx,sy,ssw,ssh:longint;
   sr32:pcolorrow32;
begin
//defaults
result:=true;
hx    :=0;
hy    :=0;

try
//check
if not misok82432(s,sbits,ssw,ssh) then exit;

//range
sw:=frcrange32(sw,0,ssw);
sh:=frcrange32(sh,0,ssh);
if (sw<=0) or (sh<=0) then goto skipend;

//no transparency -> default of 0,0
if (sbits<>32) then goto skipend;

//get
for sy:=0 to (sh-1) do
begin

if not misscan32(s,sy,sr32) then goto skipend;

for sx:=0 to (sw-1) do if (sr32[sx].a>=1) then
   begin
   hx:=sx;
   hy:=sy;
   goto skipend;
   end;

end;//sy

skipend:
except;end;
end;

function bmp32__toicondata(s:tobject;d:pobject;dbits:longint):boolean;//27may2025
label
   skipend;
var
   ymax,dpos,dbytes,drowsize,sbits,sx,sy,sw,sh:longint;
   d8  :tstr8;//pointer only
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   procedure w1(const x:byte);
   begin
   if (d8<>nil) then d8.pbytes[dpos]:=x else str__setbyt1(d,dpos,x);
   inc(dpos,1);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;

   procedure w16;//0..255 div 8 -> 0..31 (5 bit)
   begin
   w2( (c32.b div 8) + ((c32.g div 8)*32) + ((c32.r div 8)*1024) );//15 bit
   end;
begin
//defaults
result:=false;
d8    :=nil;

try
//check
if not str__lock(d)                            then goto skipend;
if not misok82432(s,sbits,sw,sh)               then goto skipend;
if (dbits<>32) and (dbits<>24) and (dbits<>16) then goto skipend;

//init
drowsize  :=mis__rowsize4(sw,dbits);//nearest 4 bytes
dbytes    :=(sh * drowsize);
ymax      :=sh-1;
dpos      :=0;

//size
if not str__setlen(d,dbytes) then goto skipend;
d8:=str__as8(d);

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

dpos:=(sy*drowsize);

//.32 -> 32
if (sbits=32) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   if (c32.a<=0) then
      begin
      c32.r:=0;
      c32.g:=0;
      c32.b:=0;
      end;
   w1(c32.b);
   w1(c32.g);
   w1(c32.r);
   w1(c32.a);
   end;//sx
   end
//.32 -> 24
else if (sbits=32) and (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   if (c32.a<=0) then
      begin
      c32.r:=0;
      c32.g:=0;
      c32.b:=0;
      end;
   w1(c32.b);
   w1(c32.g);
   w1(c32.r);
   end;//sx
   end
//.32 -> 16
else if (sbits=32) and (dbits=16) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   if (c32.a<=0) then
      begin
      c32.r:=0;
      c32.g:=0;
      c32.b:=0;
      end;
   w16;
   end;//sx
   end
//.24 -> 32
else if (sbits=24) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   w1(c24.b);
   w1(c24.g);
   w1(c24.r);
   w1(255);
   end;//sx
   end
//.24 -> 24
else if (sbits=24) and (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   w1(c32.b);
   w1(c32.g);
   w1(c32.r);
   end;//sx
   end
//.24 -> 16
else if (sbits=24) and (dbits=16) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   c32.r:=c24.r;
   c32.g:=c24.g;
   c32.b:=c24.b;
   w16;
   end;//sx
   end
//.8 -> 32
else if (sbits=8) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24.r:=sr8[sx];
   w1(c24.r);
   w1(c24.r);
   w1(c24.r);
   w1(255);
   end;//sx
   end
//.8 -> 24
else if (sbits=8) and (dbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24.r:=sr8[sx];
   w1(c32.r);
   w1(c32.r);
   w1(c32.r);
   end;//sx
   end
//.8 -> 16
else if (sbits=8) and (dbits=16) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24.r:=sr8[sx];
   c32.r:=c24.r;
   c32.g:=c24.r;
   c32.b:=c24.r;
   w16;
   end;//sx
   end;

end;//sy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__uaf(d);
end;

function bmp8__toicondata(s:tobject;d:pobject;var xcolorsused:longint):boolean;//27may2025
label
   skipend;
const
   dbits=8;
   psize=256;
var
   plist:array[0..(psize-1)] of tcolor32;
   pcount,pdiv,ymax,dpos,dbytes,drowsize,sbits,sx,sy,sw,sh:longint;
   i   :byte;
   d8  :tstr8;//pointer only
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   procedure r32(const sx:longint);
   begin
   //get
   case sbits of
   8:begin
      c32.r:=sr8[sx];
      c32.g:=c32.r;
      c32.b:=c32.r;
      c32.a:=255;//not transparent
      end;
   24:begin
      c24:=sr24[sx];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      c32.a:=255;//not transparent
      end;
   32:c32:=sr32[sx];
   end;//case

   //set -> adjust color
   if (c32.a<=0) then//transparent color uses black -> 1st palette entry
      begin
      c32.r:=0;
      c32.g:=0;
      c32.b:=0;
      end
   else
      begin
      c32.r:=(c32.r div pdiv)*pdiv;
      c32.g:=(c32.g div pdiv)*pdiv;
      c32.b:=(c32.b div pdiv)*pdiv;
      end;
   end;

   function pfind(var xindex:byte):boolean;
   var
      p:longint;
   begin
   //defaults
   result:=false;
   xindex:=0;

   //find
   for p:=0 to (pcount-1) do if (c32.r=plist[p].r) and (c32.g=plist[p].g) and (c32.b=plist[p].b) then
      begin
      result:=true;
      xindex:=p;
      break;
      end;//p
   end;

   function pmake:boolean;
   label
      skipend;
   var
      sx,sy:longint;
      i:byte;
   begin
   //defaults
   result:=false;

   //reset -> first color is always black -> reserved for transparency
   plist[0].r:=0;
   plist[0].g:=0;
   plist[0].b:=0;
   plist[0].a:=0;
   pcount:=1;

   //count colors
   for sy:=0 to (sh-1) do
   begin
   if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

   for sx:=0 to (sw-1) do
   begin
   r32(sx);

   //.color already in pallete list of colors
   if pfind(i) then
      begin
      //
      end

   //.at capacity -> can't continue
   else if (pcount>=psize) then
      begin
      //.shift to new color adjuster to reduce overall color count
      pdiv:=frcrange32( pdiv + low__aorb(1,30,pdiv>30) ,1,240);
      goto skipend;
      end

   //.add color to palette list
   else
      begin
      plist[pcount].r:=c32.r;
      plist[pcount].g:=c32.g;
      plist[pcount].b:=c32.b;
      plist[pcount].a:=0;
      inc(pcount);
      end;

   end;//sx
   end;//sy

   //successful
   result:=true;
   skipend:
   end;

   procedure w1(const x:byte);
   begin
   if (d8<>nil) then d8.pbytes[dpos]:=x else str__setbyt1(d,dpos,x);
   inc(dpos,1);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;
begin
//defaults
result     :=false;
d8         :=nil;
xcolorsused:=0;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
drowsize  :=mis__rowsize4(sw,8);//nearest 4 bytes
ymax      :=sh-1;
pcount    :=0;
pdiv      :=1;
dpos      :=0;

//make palette
while not pmake do;
xcolorsused:=pcount;

//bytes -> relies on pallete count
dbytes:=(pcount*4) + (sh * drowsize);

//size
if not str__setlen(d,dbytes) then goto skipend;
d8:=str__as8(d);

//palette
for i:=0 to (pcount-1) do
begin
w1( plist[i].b );
w1( plist[i].g );
w1( plist[i].r );
w1( plist[i].a );
end;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

dpos:=(pcount*4) + (sy*drowsize);

for sx:=0 to (sw-1) do
begin
r32(sx);//read color
pfind(i);//color -> palette index
w1(i);//write palette index
end;//sx

end;//sy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__uaf(d);
end;

function bmp4__toicondata(s:tobject;d:pobject;var xcolorsused:longint):boolean;//27may2025
label
   skipend;
const
   dbits=4;
   psize=16;
var
   plist:array[0..(psize-1)] of tcolor32;
   pcount,pdiv,ymax,dpos,dbytes,drowsize,sbits,sx,sy,sw,sh:longint;
   i,ix,ival:byte;
   d8  :tstr8;//pointer only
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   procedure r32(const sx:longint);
   begin
   //get
   case sbits of
   8:begin
      c32.r:=sr8[sx];
      c32.g:=c32.r;
      c32.b:=c32.r;
      c32.a:=255;//not transparent
      end;
   24:begin
      c24:=sr24[sx];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      c32.a:=255;//not transparent
      end;
   32:c32:=sr32[sx];
   end;//case

   //set -> adjust color
   if (c32.a<=0) then//transparent color uses black -> 1st palette entry
      begin
      c32.r:=0;
      c32.g:=0;
      c32.b:=0;
      end
   else
      begin
      c32.r:=(c32.r div pdiv)*pdiv;
      c32.g:=(c32.g div pdiv)*pdiv;
      c32.b:=(c32.b div pdiv)*pdiv;
      end;
   end;

   function pfind(var xindex:byte):boolean;
   var
      p:longint;
   begin
   //defaults
   result:=false;
   xindex:=0;

   //find
   for p:=0 to (pcount-1) do if (c32.r=plist[p].r) and (c32.g=plist[p].g) and (c32.b=plist[p].b) then
      begin
      result:=true;
      xindex:=p;
      break;
      end;//p
   end;

   function pmake:boolean;
   label
      skipend;
   var
      sx,sy:longint;
      i:byte;
   begin
   //defaults
   result:=false;

   //reset -> first color is always black -> reserved for transparency
   plist[0].r:=0;
   plist[0].g:=0;
   plist[0].b:=0;
   plist[0].a:=0;
   pcount:=1;

   //count colors
   for sy:=0 to (sh-1) do
   begin
   if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

   for sx:=0 to (sw-1) do
   begin
   r32(sx);

   //.color already in pallete list of colors
   if pfind(i) then
      begin
      //
      end

   //.at capacity -> can't continue
   else if (pcount>=psize) then
      begin
      //.shift to new color adjuster to reduce overall color count
      pdiv:=frcrange32( pdiv + low__aorb(1,30,pdiv>30) ,1,240);
      goto skipend;
      end

   //.add color to palette list
   else
      begin
      plist[pcount].r:=c32.r;
      plist[pcount].g:=c32.g;
      plist[pcount].b:=c32.b;
      plist[pcount].a:=0;
      inc(pcount);
      end;

   end;//sx
   end;//sy

   //successful
   result:=true;
   skipend:
   end;

   procedure w1(const x:byte);
   begin
   if (d8<>nil) then d8.pbytes[dpos]:=x else str__setbyt1(d,dpos,x);
   inc(dpos,1);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;
begin
//defaults
result     :=false;
d8         :=nil;
xcolorsused:=0;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
drowsize  :=mis__rowsize4(sw,4);//nearest 4 bytes
ymax      :=sh-1;
pcount    :=0;
pdiv      :=1;
dpos      :=0;

//make palette
while not pmake do;
xcolorsused:=pcount;

//bytes -> relies on pallete count
dbytes:=(pcount*4) + (sh * drowsize);

//size
if not str__setlen(d,dbytes) then goto skipend;
d8:=str__as8(d);

//palette
for i:=0 to (pcount-1) do
begin
w1( plist[i].b );
w1( plist[i].g );
w1( plist[i].r );
w1( plist[i].a );
end;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

dpos:=(pcount*4) + (sy*drowsize);
ix  :=0;
ival:=0;

for sx:=0 to (sw-1) do
begin
r32(sx);//read color
pfind(i);//color -> palette index

//inc
inc(ix);

//add to pixel bucket
case ix of
1:ival:=(i*16);
2:ival:=ival+i;
end;

//save pixel
if (ix>=2) then
   begin
   w1(ival);
   ival:=0;
   ix  :=0;
   end;
end;//sx

//save last un-saved pixel
if (ix>=1) then w1(ival);
end;//sy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__uaf(d);
end;

function bmp1__toicondata(s:tobject;d:pobject):boolean;//27may2025
label
   skipend;
const
   dbits =1;
var
   ymax,dpos,dbytes,drowsize,sbits,sx,sy,sw,sh:longint;
   ix,ival,vbit:byte;
   d8  :tstr8;//pointer only
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;

   procedure r32;
   begin

   case sbits of
   8:if (sr8[sx]<=0)     then vbit:=1 else vbit:=0;
   32:if (sr32[sx].a<=0) then vbit:=1 else vbit:=0;
   else                       vbit:=0;
   end;//case

   end;

   procedure w1(const x:byte);
   begin
   if (d8<>nil) then d8.pbytes[dpos]:=x else str__setbyt1(d,dpos,x);
   inc(dpos,1);
   end;

   procedure w2(const x:word);
   begin
   w1(twrd2(x).bytes[0]);
   w1(twrd2(x).bytes[1]);
   end;

   procedure w4(const x:longint);
   begin
   w1(tint4(x).bytes[0]);
   w1(tint4(x).bytes[1]);
   w1(tint4(x).bytes[2]);
   w1(tint4(x).bytes[3]);
   end;
begin
//defaults
result:=false;
d8    :=nil;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
drowsize  :=mis__rowsize4(sw,1);//nearest 4 bytes
ymax      :=sh-1;
dpos      :=0;

//bytes -> relies on palette count
dbytes:=(sh * drowsize);

//size
if not str__setlen(d,dbytes) then goto skipend;
d8:=str__as8(d);

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,ymax-sy,sr8,sr24,sr32) then goto skipend;

dpos:=(sy*drowsize);
ix  :=0;
ival:=0;

for sx:=0 to (sw-1) do
begin
r32;//read color

//inc
inc(ix);

//add to pixel bucket
case ix of
1:ival:=(vbit*128);
2:ival:=ival+(vbit*64);
3:ival:=ival+(vbit*32);
4:ival:=ival+(vbit*16);
5:ival:=ival+(vbit*8);
6:ival:=ival+(vbit*4);
7:ival:=ival+(vbit*2);
8:ival:=ival+vbit;
end;

//save pixel
if (ix>=8) then
   begin
   w1(ival);
   ival:=0;
   ix  :=0;
   end;
end;//sx

//save last un-saved pixel
if (ix>=1) then w1(ival);
end;//sy

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(d);
//free
str__uaf(d);
end;


//cur procs --------------------------------------------------------------------
function cur__todata(s:tobject;d:pobject;var e:string):boolean;//27may2025
begin
result:=cur__todata2(s,d,'',e);
end;

function cur__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;//27may2025
begin
result:=cur__todata3(s,d,daction,e);
end;

function cur__todata3(s:tobject;d:pobject;var daction,e:string):boolean;//27may2025
label
   skipend;
var
   dbits:longint;
   xsimple0255:boolean;
begin
//defaults
result       :=false;
e            :=gecTaskfailed;

try
//get
case misb(s) of
24  :dbits:=24;
8   :dbits:=8;
else dbits:=32;
end;

//decide
if (not mask__hasTransparency322(s,xsimple0255)) or xsimple0255 then
   begin
   case mis__countcolors257(s) of
   0..15  :dbits:=4;//1 color for transparency or not
   17..255:dbits:=8;//1 color for transparency or not
   else    dbits:=24;
   end;//case
   end;

//set
result:=curXX__todata(s,d,dbits);

skipend:
except;end;
end;

function cur__fromdata(d:tobject;s:pobject;var e:string):boolean;
begin
e:=gecTaskfailed;
result:=ico32__fromdata(d,s);
end;

function curXX__todata(s:tobject;d:pobject;dbits:longint):boolean;//27may2025
begin
result:=curXX__todata2(s,d,dbits,-1,-1);
end;

function curXX__todata2(s:tobject;d:pobject;dhotX,dhotY,dbits:longint):boolean;//27may2025
begin
case dbits of
32,24,16,8,4:result:=ico32__todata3(s,d,false,true,dhotX,dhotY,dbits);
else         result:=ico32__todata3(s,d,false,true,dhotX,dhotY,32);
end;//case
end;

function cur32__todata(s:tobject;d:pobject):boolean;
begin
result:=cur32__todata2(s,d,-1,-1);
end;

function cur32__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
begin
result:=ico32__todata3(s,d,false,true,dhotX,dhotY,32);
end;

function cur24__todata(s:tobject;d:pobject):boolean;
begin
result:=cur24__todata2(s,d,-1,-1);
end;

function cur24__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
begin
result:=ico32__todata3(s,d,false,true,dhotX,dhotY,24);
end;

function cur16__todata(s:tobject;d:pobject):boolean;
begin
result:=cur16__todata2(s,d,-1,-1);
end;

function cur16__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
begin
result:=ico32__todata3(s,d,false,true,dhotX,dhotY,16);
end;

function cur8__todata(s:tobject;d:pobject):boolean;
begin
result:=cur8__todata2(s,d,-1,-1);
end;

function cur8__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
begin
result:=ico32__todata3(s,d,false,true,dhotX,dhotY,8);
end;

function cur4__todata(s:tobject;d:pobject):boolean;
begin
result:=cur4__todata2(s,d,-1,-1);
end;

function cur4__todata2(s:tobject;d:pobject;dhotX,dhotY:longint):boolean;
begin
result:=ico32__todata3(s,d,false,true,dhotX,dhotY,4);
end;


//ani procs --------------------------------------------------------------------
function ani__todata(s:tobject;d:pobject;var e:string):boolean;
begin
result:=ani__todata2(s,d,'',e);
end;

function ani__todata2(s:tobject;d:pobject;daction:string;var e:string):boolean;
begin
result:=ani__todata3(s,d,daction,0,0,true,e);
end;

function ani__todata3(s:tobject;d:pobject;daction:string;dhotX,dhotY:longint;xonehotspot:boolean;var e:string):boolean;
var
   xoutbpp:longint;
   xouttransparent:boolean;
begin
result:=ani__todata4(s,nil,d,'ani',daction,32,0,0,0,true,xoutbpp,xouttransparent,e);
end;

function ani__todata4(s:tobject;slist:tfindlistimage;d:pobject;dformat,daction:string;dforceBPP,dsize:longint;dhotX,dhotY:longint;xonehotspot:boolean;var xoutbpp:longint;var xouttransparent:boolean;var e:string):boolean;
begin
result:=ani__todata5(s,slist,d,dformat,daction,dforceBPP,dsize,0,dhotX,dhotY,xonehotspot,xoutbpp,xouttransparent,e);
end;

function ani__todata5(s:tobject;slist:tfindlistimage;d:pobject;dformat,daction:string;dforceBPP,dsize:longint;ddelay,dhotX,dhotY:longint;xonehotspot:boolean;var xoutbpp:longint;var xouttransparent:boolean;var e:string):boolean;
label
   //Note: Known anirec.flags: 1=win7/ours, 3=ms old/our
   //uses alpha channel to write transparency - 15feb2022
   //Force to dBPP when >=1, 0=automatic bpp
   skipend;
var
   b:tstr8;
   dfast:tstr8;//pointer only
   int1,int2,dw,dh,p:integer;
   anirec:tanirec;
   xicon,xiconlist:tstr8;
   dpng,dcursor,xonce:boolean;
   xfoundhotX,xfoundhotY,dbpp,scellcount:longint;
   dcell:tbasicimage;//temp image for each icon to be read onto - 14feb2022
   //.mask support
   v0,v255,vother:boolean;
   xmin,xmax:longint;

   function xpullcell(x:longint;xdraw:boolean):boolean;
   label
      skipend;
   var
      xcell:tobject;//pointer only
      xtranscol,xbits,xcellw,xcellh,xw,xh,int1,int2,int3,xdelay:longint;
      xhasai,xtransparent:boolean;
   begin
   //defaults
   result:=false;
   xcell:=s;

   try
   //get
   if assigned(slist) then
      begin
      int1:=1;
      slist(nil,dformat,x,int1,xtranscol,xcell);
      scellcount:=frcmin32(int1,1);
      if not miscells(xcell,xbits,xw,xh,int1,int2,int3,xdelay,xhasai,xtransparent) then goto skipend;
      xcellw:=xw;
      xcellh:=xh;
      //.draw
      if xdraw and zzok2(dcell) and (not miscopyarea32(0,0,dw,dh,area__make(0,0,xcellw-1,xcellh-1),dcell,xcell)) then goto skipend;
      end
   else
      begin
      if not miscells(s,xbits,xw,xh,scellcount,xcellw,xcellh,xdelay,xhasai,xtransparent) then goto skipend;
      //.draw
      if xdraw and zzok2(dcell) and (not miscopyarea32(0,0,dw,dh,area__make(x*xcellw,0,((x+1)*xcellw)-1,xcellh-1),dcell,s)) then goto skipend;
      end;
   //.val defaults
   if xonce then
      begin
      xonce:=false;
      if (ddelay<=0) then ddelay:=xdelay;
      if (dsize<=0) then dsize:=(xcellw+xcellh) div 2;//vals set by call to "xpullcell(0)" above
      end;
   //successful
   result:=true;
   skipend:
   except;end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;
xoutbpp:=1;
xouttransparent:=false;
xonce:=true;
xicon:=nil;
xiconlist:=nil;
dcell:=nil;
b:=nil;

try
//check
if not str__lock(d) then goto skipend;
if str__is8(d) then dfast:=d^ as tstr8 else dfast:=nil;
if not xpullcell(0,false) then goto skipend;

//range
dforceBPP:=frcrange32(dforceBPP,0,32);

//init
str__clear(d);
fillchar(anirec,sizeof(anirec),0);

dpng:=false;//off for now -> need more info to implement - 22nov2024

ddelay:=frcmin32(ddelay,1);
dsize:=low__icosizes(dsize);//16..256
dw:=dsize;
dh:=dsize;
dcell:=misimg32(dw,dh);
dbpp:=1;
xicon:=str__new8;
xiconlist:=str__new8;
dformat:=io__extractfileext3(dformat,dformat);//accepts filename and extension only - 12apr2021
dcursor:=(dformat='cur') or (dformat='ico');


//-- GET -----------------------------------------------------------------------
//.dbpp - scan each cell and return the highest BPP rating to cover ALL cells - 22JAN2012
dbpp:=1;
for p:=0 to (scellcount-1) do
begin
if (dforceBPP>=1) then
   begin
   dbpp:=dforceBPP;
   break;
   end;

if not xpullcell(p,true) then goto skipend;

int1:=low__findbpp82432(dcell,area__make(0,0,dw-1,dh-1),false);
if (int1>dbpp) then dbpp:=int1;

if mask__range2(dcell,v0,v255,vother,xmin,xmax) then
   begin
   if vother then dbpp:=32;
   if v0 or vother then xouttransparent:=true;
   end;

if (dbpp>=32) then break;

if (p=0) and dcursor then break;//only need first reported cell for a static cursor/icon
end;//p


//.dpng
if (misb(s)<>32) then dpng:=false;//23may2022
if dpng then dbpp:=32;//23may2022


//decide
//.cur + ico
if (dformat='cur') or (dformat='ico') then
   begin
   if not xpullcell(0,true) then goto skipend;

   b:=str__new8;
   result:=low__toico32(dcell,(dformat='cur'),dpng,dsize,dBPP,dhotX,dhotY,xfoundhotX,xfoundhotY,int2,b,e);
   str__add(d,@b);

   if (int2>xoutbpp) then xoutbpp:=int2;
   goto skipend;
   end
//.ani
else if (dformat='ani') then
   begin
   //drop below to finish
   end
//.unsupported format
else goto skipend;

//.anirec - do last
anirec.cbsizeof:=sizeof(anirec);
anirec.cframes:=scellcount;//number of unique images
anirec.csteps:=scellcount;//number of cells in anmiation
anirec.cbitcount:=dbpp;
anirec.jifrate:=frcmin32(round(ddelay/16.666),1);
anirec.flags:=1;//win7/some of ours

//.cells -> icons
for p:=0 to (scellcount-1) do
begin
//.get cell
if not xpullcell(p,true) then goto skipend;
//.make icon
if not low__toico32(dcell,true,dpng,dsize,dBPP,dhotX,dhotY,xfoundhotX,xfoundhotY,int2,xicon,e) then goto skipend;
if (int2>xoutbpp) then xoutbpp:=int2;
//.hotspot -> reuse 1st hotspot (cell 1) for all remaining cells - 15feb2022
if xonehotspot and ((dhotX<0) or (dhotY<0)) then
   begin
   dhotX:=xfoundhotX;
   dhotY:=xfoundhotY;
   end;
//.add icon -> 'icon'+from32bit(length(imgs.items[p]^))+imgs.items[p]^
xiconlist.addstr('icon');
xiconlist.addint4(xicon.len);
xiconlist.add(xicon);
xicon.clear;
end;//p


//-- RIFF ----------------------------------------------------------------------
//.riff -> 'RIFF'+from32bit(length(data)+4)+data;
str__sadd(d,'RIFF');
str__addint4(d,0);//set last
//._anih - 'ACONanih'+from32bit(sizeof(anirec))+fromstruc(@anirec,sizeof(anirec));
str__sadd(d,'ACONanih');
str__addint4(d,sizeof(anirec));
str__addrec(d,@anirec,sizeof(anirec));
//._list
str__sadd(d,'LIST');
str__addint4(d,4+xiconlist.len);
str__sadd(d,'fram');
str__add(d,@xiconlist);
//.reduce mem
xiconlist.clear;
//.set overal size
str__setint4(d,4,frcmin32(str__len(d)-4,0));

//successful
result:=true;
skipend:
except;end;
//clear on error
if (not result) then str__clear(d);
//free
str__free(@xicon);
str__free(@xiconlist);
freeobj(@dcell);
str__uaf(d);
str__free(@b);
end;


//gif support procs ------------------------------------------------------------
procedure gif__decompress(x:pobject);//26jul2024, 28jul2021, 11SEP2007
var
   p:longint;
   z:tobject;
begin
try
//init
z:=nil;
p:=1;
if str__lock(x) then str__clear(x) else exit;
//get
z:=str__newsametype(x);
gif__decompressex(p,x,@z,0,0,false);
//set
str__add(x,@z);
except;end;
try
str__uaf(x);
str__free(@z);
except;end;
end;

procedure gif__decompressex(var xlenpos1:longint;x,imgdata:pobject;_width,_height:longint;interlaced:boolean);//11SEP2007
label
   skipend;
const
  GIFCodeBits=12;// Max number of bits per GIF token code
  GIFCodeMax=(1 SHL GIFCodeBits)-1;//Max GIF token code,12 bits=4095
  StackSize=(2 SHL GIFCodeBits);//Size of decompression stack
  TableSize=(1 SHL GIFCodeBits);//Size of decompression table
var
   tmprow,xlen:longint;
   table0:array[0..TableSize-1] of longint;
   table1:array[0..TableSize-1] of longint;
   firstcode,oldcode:longint;
   buf:array[0..257] of BYTE;
   v,xpos,ypos,pass:longint;
   stack:array[0..StackSize-1] of longint;
   Source:^longint;
   BitsPerCode:longint;//number of CodeTableBits/code
   InitialBitsPerCode:BYTE;
   MaxCode,MaxCodeSize,ClearCode,EOFCode,step,i,StartBit,LastBit,LastByte:longint;
   get_done,return_clear,ZeroBlock:boolean;

function read(a:pointer;len:longint):longint;
var
   b:pdlByte;
   i:longint;
begin
//defaults
result:=0;

try
//init
b:=a;
//process
for i:=1 to len do if (xlenpos1<=xlen) then
   begin
   b[result]:=str__bytes1(x,xlenpos1);
   inc(result);
   inc(xlenpos1);
   end
else break;
except;end;
end;

function nextCode(BitsPerCode: longint): longint;
const
   masks:array[0..15] of longint=($0000,$0001,$0003,$0007,$000f,$001f,$003f,$007f,$00ff,$01ff,$03ff,$07ff,$0fff,$1fff,$3fff,$7fff);
var
   StartIndex,EndIndex,ret,EndBit:longint;
   count:BYTE;
begin
//defaults
result:=-1;

try
//check
if return_clear then
   begin
   return_clear:=false;
   result:=ClearCode;
   exit;
   end;
//get
EndBit:=StartBit+BitsPerCode;
if (EndBit>=LastBit) then
   begin
   if get_done then
      begin
      if (StartBit>=LastBit) then result:=-1;
      exit;
      end;
   buf[0]:=buf[LastByte-2];
   buf[1]:=buf[LastByte-1];
   //.count
   if (xlenpos1>xlen) then
      begin
      result:=-1;
      exit;
      end
   else
      begin
      count:=str__bytes1(x,xlenpos1);
      inc(xlenpos1);
      end;
   //.check
   if (count=0) then
      begin
      ZeroBlock:=True;
      get_done:=TRUE;
      end
   else
      begin
      //handle premature end of file
      if ((1+xlen-xlenpos1)<count) then
         begin
         //Not enough data left - Just read as much as we can get
         Count:=xlen-xlenpos1+1;
         end;
      if (Count<>0) and (read(@buf[2],count)<>count) then exit;//out of data
      end;
   LastByte:=2+count;
   StartBit:=(StartBit-LastBit)+16;
   LastBit:=LastByte*8;
   EndBit:=StartBit+BitsPerCode;
   end;
//set
EndIndex:=EndBit div 8;
StartIndex:=StartBit div 8;
//check
if (startindex>high(buf)) then exit;//out of range
if (StartIndex=EndIndex) then ret:=buf[StartIndex]
else if ((StartIndex+1)=EndIndex) then ret:=buf[StartIndex] or (buf[StartIndex+1] shl 8)
else ret:=buf[StartIndex] or (buf[StartIndex+1] shl 8) or (buf[StartIndex+2] shl 16);
ret:=(ret shr (StartBit and $0007)) and masks[BitsPerCode];
inc(StartBit,BitsPerCode);
result:=ret;
except;end;
end;

function NextLZW:longint;
var
   code,incode,i:longint;
begin
//defaults
result:=-1;

try
//scan
code:=nextCode(BitsPerCode);
while (code>=0) do
begin
if (code=ClearCode) then
   begin
   //check
   if (clearcode>tablesize) then exit;//out of range
   for i:=0 to (ClearCode-1) do
   begin
   table0[i]:=0;
   table1[i]:=i;
   end;//loop

   for i:=ClearCode to (TableSize-1) do
   begin
   table0[i]:=0;
   table1[i]:=0;
   end;
   BitsPerCode:=InitialBitsPerCode+1;
   MaxCodeSize:=2*ClearCode;
   MaxCode:=ClearCode+2;
   Source:=@stack;

   repeat
   firstcode:=nextCode(BitsPerCode);
   oldcode:=firstcode;
   until (firstcode<>ClearCode);
   Result := firstcode;
   exit;
   end;//if
//.eof
if (code=EOFCode) then
   begin
   Result:=-2;
   if ZeroBlock then exit;
   //eat blank data (all 0's)
   //--ignore
   exit;
   end;//if

incode:=code;
if (code>=MaxCode) then
   begin
   Source^:=firstcode;
   Inc(Source);
   code:=oldcode;
   end;//if
//check
if (Code>TableSize) then exit;//out of range

 while (code>=ClearCode) do
 begin
 Source^:=table1[code];
 Inc(Source);
 //check
 if (code=table0[code]) then exit;//error
 code:=table0[code];
 //check
 if (Code>TableSize) then exit;
 end;//loop

firstcode:=table1[code];
Source^:=firstcode;
Inc(Source);
code:=MaxCode;
if (code<=GIFCodeMax) then
   begin
   table0[code]:=oldcode;
   table1[code]:=firstcode;
   Inc(MaxCode);
   if ((MaxCode>=MaxCodeSize) and (MaxCodeSize<=GIFCodeMax)) then
      begin
      MaxCodeSize:=MaxCodeSize*2;
      Inc(BitsPerCode);
      end;
   end;//if
oldcode:=incode;
if (longInt(Source)>longInt(@stack)) then
   begin
   Dec(Source);
   Result:=Source^;
   exit;
   end
end;//loop
Result:=code;
except;end;
end;

function readLZW:longint;
begin
result:=0;

try
if (longInt(Source)>longInt(@stack)) then
   begin
   Dec(Source);
   Result:=Source^;
   end
else Result:=NextLZW;
except;end;
end;

//START
begin
try
//check
if not low__true2(str__lock(x),str__lock(imgdata)) then goto skipend;

//init
xlen:=str__len(x);
str__clear(imgdata);
if (xlenpos1<1) or (xlenpos1>xlen) then goto skipend;
//get
if (xlenpos1>xlen) then goto skipend;
InitialBitsPerCode:=str__bytes1(x,xlenpos1);
inc(xlenpos1);
str__setlen(imgdata,_width*_height);//was: setlength(imgdata,_width*_height);
//Initialize the Compression routines
BitsPerCode:=InitialBitsPerCode+1;
ClearCode:=1 shl InitialBitsPerCode;
EOFCode:=ClearCode+1;
MaxCodeSize:=2*ClearCode;
MaxCode:=ClearCode+2;
StartBit:=0;
LastBit:=0;
LastByte:=2;
ZeroBlock:=false;
get_done:=false;
return_clear:=true;
Source:=@stack;
try
if interlaced then
   begin
   ypos:=0;
   pass:=0;
   step:=8;
   for i:=0 to (_Height-1) do
   begin
   tmprow:=_width*ypos;
    for xpos:=0 to (_width-1) do
    begin
    v:=readLZW;
    if (v<0) then exit;
    str__setbytes1(imgdata,1+tmprow+xpos,byte(v));
    end;
   //inc
   Inc(ypos,step);
   if (ypos>=_height) then
      begin
      repeat
      if (pass>0) then step:=step div 2;
      Inc(pass);
      ypos := step DIV 2;
      until (ypos < _height);
      end;//if
   end;//loop
   end
else
   begin
   if (_width>=1) and (_height>=1) then
      begin
      for ypos:=0 to ((_height*_width)-1) do
      begin
      v:=readLZW;
      if (v<0) then exit;
      str__setbytes1(imgdata,1+ypos,byte(v));
      end;//ypos
      end
   else
      begin//decompress raw data string (width and height are not used
      tmprow:=1;
      while true do
      begin
      v:=readLZW;
      if (v<0) then exit;//done
      str__setbytes1(imgdata,tmprow,byte(v));
      inc(tmprow);
      end;//loop
      end;//if
   end;//if
except;end;
//too much data
if (readLZW>=0) then
   begin
   //ignore
   end;//if
skipend:
except;end;
try
str__uaf(x);
str__uaf(imgdata);
except;end;
end;

function gif__compress(x:pobject;var e:string):boolean;//12SEP2007
var
   z:tobject;
begin
//defaults
result:=false;

try
z:=nil;
if not str__lock(x) then exit;
z:=str__newsametype(x);
//get
if gif__compressex(x,@z,e) then
   begin
   str__clear(x);
   str__add(x,@z);
   result:=true;
   end;
except;end;
try
str__free(@z);
str__uaf(x);
except;end;
end;

function gif__compressex(x,imgdata:pobject;e:string):boolean;//12SEP2007
label
   skipend;
const
   EndBlockByte=$00;			// End of block marker
var
   h:thashtable;
   buf:tobject;
   NewCode,Prefix,FreeEntry:smallint;
   NewKey:longint;
   Color:byte;
   ClearFlag:boolean;
   MaxCode,EOFCode,BaseCode,ClearCode:smallint;
   maxcolor,xlen,xpos,BitsPerCode,OutputBits,OutputBucket:longint;
   BitsPerPixel,InitialBitsPerCode:byte;

function MaxCodesFromBits(bits:longint):smallint;
begin
result:=(smallint(1) shl bits)-1;
end;

procedure writechar(x:byte);//15SEP2007
begin//"x=nil" => flush
//get
str__addbyt1(@buf,x);
//set
if (str__len(@buf)>=255) then
   begin
   //was:pushb(imglen,imgdata,char(length(buf))+buf);
   str__addbyt1(imgdata,byte(str__len(@buf)));
   str__add(imgdata,@buf);
   str__clear(@buf);
   end;
end;

procedure writecharfinish;
begin//"x=nil" => flush
if (str__len(@buf)>=1) then
   begin
   //was:pushb(imglen,imgdata,char(length(buf))+buf);
   str__addbyt1(imgdata,str__len(@buf));
   str__add(imgdata,@buf);
   str__clear(@buf);
   end;
end;

procedure output(value:longint);
const
  BitBucketMask: array[0..16] of longInt =
    ($0000,
     $0001, $0003, $0007, $000F,
     $001F, $003F, $007F, $00FF,
     $01FF, $03FF, $07FF, $0FFF,
     $1FFF, $3FFF, $7FFF, $FFFF);
begin
try
//get
if (OutputBits > 0) then OutputBucket := (OutputBucket AND BitBucketMask[OutputBits]) OR (longInt(Value) SHL OutputBits)
else OutputBucket := Value;
inc(OutputBits, BitsPerCode);
//set
while (OutputBits >= 8) do
begin
writechar(OutputBucket and $FF);//was: writechar(char(OutputBucket and $FF));
OutputBucket:=OutputBucket shr 8;
dec(OutputBits,8);
end;
//check
if (Value = EOFCode) then
   begin
   // At EOF, write the rest of the buffer.
   while (OutputBits > 0) do
   begin
   writechar(OutputBucket and $FF);//was: writechar(char(OutputBucket and $FF));
   OutputBucket := OutputBucket shr 8;
   dec(OutputBits, 8);
   end;
   end;
// If the next entry is going to be too big for the code size,
// then increase it, if possible.
if (FreeEntry > MaxCode) or (ClearFlag) then
   begin
   if (ClearFlag) then
      begin
      BitsPerCode := InitialBitsPerCode;
      MaxCode := MaxCodesFromBits(BitsPerCode);
      ClearFlag := False;
      end
   else
      begin
      inc(BitsPerCode);
      if (BitsPerCode=GIFCodeBits) then MaxCode:=GIFTableMaxMaxCode
      else MaxCode:=MaxCodesFromBits(BitsPerCode);
      end;
   end;
except;end;
end;

begin
//defaults
result:=false;
e:=gecUnexpectedError;
h:=nil;
buf:=nil;

try
//check
if not low__true2(str__lock(x),str__lock(imgdata)) then goto skipend;

//init
str__clear(imgdata);
xlen:=str__len(x);
xpos:=1;
if (xlen<=2) then goto skipend;
h:=thashtable.create;
buf:=str__new8;
maxcolor:=256;
BitsPerPixel:=8;//bits per pixel - fixed at 8, don't go below 2
InitialBitsPerCode:=BitsPerPixel+1;
BitsPerCode:=InitialBitsPerCode;
MaxCode:=MaxCodesFromBits(BitsPerCode);
ClearCode:=(1 SHL (InitialBitsPerCode-1));
EOFCode:=ClearCode+1;
BaseCode:=EOFCode+1;
//.clear bit bucket
OutputBucket:=0;
OutputBits:=0;
str__addbyt1(imgdata,BitsPerPixel);//was: pushb(imglen,imgdata,char(BitsPerPixel));

//clear - hash table and sync decoder
clearflag:=true;
output(clearcode);
h.clear;
freeentry:=clearcode+2;
//get
prefix:=smallint(str__bytes1(x,xpos));//was: x[xpos]);
if (Prefix>=MaxColor) then
   begin
   e:=gecIndexOutOfRange;
   goto skipend;
   end;
while true do
begin
//.inc
inc(xpos);
if (xpos>xlen) then break;
//.get
color:=str__bytes1(x,xpos);//was: x[xpos];
if (color>=maxcolor) then
   begin
   e:=gecIndexOutOfRange;
   goto skipend;
   end;
//append postfix to prefix and lookup in table...
NewKey := (longint(Prefix) SHL 8) OR Color;
NewCode := h.lookup(NewKey);
if (NewCode >= 0) then
   begin
   // ...if found, get next pixel
   prefix:=newcode;
   //skip to next item
   continue;
   end;
// ...if not found, output and start over
output(prefix);
prefix:=smallint(color);
if (FreeEntry < GIFTableMaxFill) then
   begin
   h.insert(NewKey, FreeEntry);
   inc(FreeEntry);
   end
else
   begin
   //clear
   clearflag:=true;
   output(clearcode);
   h.clear;
   freeentry:=clearcode+2;
   end;
end;//loop
output(prefix);
skipend:
//finalise - 15SEP2007
output(EOFCode);
writecharfinish;
str__addbyt1(imgdata,EndBlockByte);//was: //writechar('');pushb(imglen,imgdata,char(EndBlockByte));pushb(imglen,imgdata,'');
//successful
result:=true;
except;end;
try
freeobj(@h);
str__free(@buf);
str__uaf(x);
str__uaf(imgdata);
except;end;
end;

function hashkey(key:longint):smallint;
begin
result:=smallint(((Key SHR (GIFCodeBits-8)) XOR Key) MOD HashSize);
end;

function nexthashkey(hkey:smallint):smallint;
var
  disp:smallint;
begin
//defaults
result:=0;

try
//secondary hash (after G. Knott)
disp:=HashSize-HKey;
if (HKey=0) then disp:=1;
//disp := 13;		// disp should be prime relative to HashSize, but
			// it doesn't seem to matter here...
dec(HKey,disp);
if (HKey<0) then inc(HKey,HashSize);
Result:=HKey;
except;end;
end;

constructor thashtable.create;
begin//longInt($FFFFFFFF) = -1, 'TGIFImage implementation assumes $FFFFFFFF = -1');
if classnameis('thashtable') then track__inc(satHashtable,1);
inherited create;
getmem(hashtable,sizeof(thasharray));
clear;
end;

destructor thashtable.destroy;
begin
try
freemem(hashtable);
inherited destroy;
if classnameis('thashtable') then track__inc(satHashtable,-1);
except;end;
end;

procedure thashtable.clear;
begin
fillchar(hashtable^,sizeof(thasharray),$FF);
end;

procedure thashtable.insert(key:longint;code:smallint);
var
   hkey:smallint;
begin
try
//Create hash key from prefix string
hkey:=hashkey(key);
//Scan for empty slot
//while (HashTable[HKey] SHR GIFCodeBits <> HashEmpty) do { Unoptimized }
while (hashtable[hkey] and (hashempty shl gifcodebits)<>(hashempty shl gifcodebits)) do hkey:=nexthashkey(hkey);
//Fill slot with key/value pair
hashtable[hkey]:=(key shl gifcodebits) or (code and gifcodemask);
except;end;
end;

function thashtable.lookup(key:longInt):smallint;
var
// Search for key in hash table.
// Returns value if found or -1 if not
  hkey:smallint;
  htkey:longInt;
begin
result:=-1;

try
// Create hash key from prefix string
HKey := HashKey(Key);
// Scan table for key
// HTKey := HashTable[HKey] SHR GIFCodeBits; { Unoptimized }
Key := Key SHL GIFCodeBits; { Optimized }
HTKey := HashTable[HKey] AND (HashEmpty SHL GIFCodeBits); { Optimized }
// while (HTKey <> HashEmpty) do { Unoptimized }
while (HTKey <> HashEmpty SHL GIFCodeBits) do { Optimized }
begin
if (Key = HTKey) then
   begin
   // Extract and return value
   Result := HashTable[HKey] AND GIFCodeMask;
   exit;
   end;
// Try next slot
HKey := NextHashKey(HKey);
// HTKey := HashTable[HKey] SHR GIFCodeBits; { Unoptimized }
HTKey := HashTable[HKey] AND (HashEmpty SHL GIFCodeBits); { Optimized }
end;
// Found empty slot - key doesn't exist
Result := -1;
except;end;
end;

function gif__fromdata(ss:tobject;ds:pobject;var e:string):boolean;//06aug2024, 28jul2021, 20JAN2012, 22SEP2009
label
   skipone,skipend;
   //ss      = image that will accept the animation cells as a horizontal image strip (best to use a 32bit image for transparency etc)
   //ds      = data stream (tstr8/tstr9) to read the GIF from
   //daction = optional actions / override values see below
const
   //main flags
   pfGlobalColorTable	= $80;		{ set if global color table follows L.S.D. }
   pfColorResolution	= $70;		{ Color resolution - 3 bits }
   pfSort		= $08;		{ set if global color table is sorted - 1 bit }
   pfColorTableSize	= $07;		{ size of global color table - 3 bits }
   //local - image des
   idLocalColorTable	= $80;    { set if a local color table follows }
   idInterlaced		= $40;    { set if image is interlaced }
   idSort		= $20;    { set if color table is sorted }
   idReserved		= $0C;    { reserved - must be set to $00 }
   idColorTableSize	= $07;    { size of color table as above }
type
   pgifpal=^tgifpal;
   tgifpal=record
    c:array[0..255] of tcolor24;
    count:integer;
    init:boolean;
    end;
var
   simage,imgdata,tmp:tobject;
   dcellcount,dcellwidth,dcellheight,ddelay,dbpp:longint;
   dtransparent:boolean;

   sw,sh,sbits,imglimit,imgcount,nx,ny,offx,len,dy,dx,trans,delay,loops,i,p,tmp2,dslen,pos1:longint;
   xstr8ok,alltrans,ok,wait,v87a,v89a:boolean;
   lastdispose,dispose,bgcolor,ci,v2,v:byte;

   s:tgifscreen;
   lp,gp:tgifpal;//global color palette
   pal:pgifpal;//pointer to current palette for image to use
   id:tgifimgdes;

   sr8:pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   c8:tcolor8;
   c24:tcolor24;
   c32:tcolor32;
   lastwinrect:twinrect;

   procedure palinit(var x:tgifpal);
   var
      p:longint;
      r,g,b:byte;
   begin
   //check
   if x.init then exit else x.init:=true;

   //swap
   for p:=0 to high(x.c) do
   begin
   //get
   r:=x.c[p].r;
   g:=x.c[p].g;
   b:=x.c[p].b;
   //set - swap r/b elements
   x.c[p].r:=b;
   x.c[p].g:=g;
   x.c[p].b:=r;
   end;//p
   end;

begin
//defaults
result:=false;
e:=gecTaskfailed;

try
dcellcount:=1;
dcellwidth:=1;
dcellheight:=1;
dtransparent:=false;
ddelay:=100;
dbpp:=8;
tmp:=nil;
imgdata:=nil;
simage:=ss;

//check
if not str__lock(ds) then goto skipend;

if not misok82432(simage,sbits,sw,sh)         then goto skipend;
if (sbits<>8) and (sbits<>24) and (sbits<>32) then goto skipend;

//supplied image can't resize and retain it's pixels so we need one that can - 26jul2024
if not mis__resizable(simage) then simage:=misraw(sbits,sw,sh);

//init
dslen:=str__len(ds);
if (dslen<6) then exit;
imgcount:=0;
imglimit:=0;
alltrans:=false;
offx:=0;
pos1:=1;
loops:=0;
delay:=0;
pal:=@gp;
dispose:=0;
lastdispose:=0;

//.control items
bgcolor:=0;
trans:=-1;//not in use
wait:=false;


//check header signature (GIF)
if not str__asame3(ds,pos1-1,[uuG,uuI,uuF],false) then//GIF
   begin
   e:=gecUnknownFormat;
   goto skipend;
   end;
inc(pos1,3);
e:=gecDataCorrupt;

//version
v87a:=str__asame3(ds,pos1-1,[nn8,nn7,llA],false);
v89a:=str__asame3(ds,pos1-1,[nn8,nn9,llA],false);
inc(pos1,3);
if (not v87a) and (not v89a) then goto skipend;

//screen info
if ((pos1+sizeof(s)-1)>dslen) then goto skipend;
if not str__writeto1(ds,@s,sizeof(s),pos1,sizeof(s)) then goto skipend;
inc(pos1,sizeof(s));

//.range
s.w:=frcmin32(s.w,1);
s.h:=frcmin32(s.h,1);
imglimit:=max32;//yyyyyyyyyyyyy [disabled for huge images on 22SEP2009] 21000 div s.w;//safe number of frames (tbitmap.width=22000+ crashes)

//.global color palette - always empty, since we may have to use it even when we shouldn't be
fillchar(gp,sizeof(gp),0);
if ((s.pf and pfGlobalColorTable)=pfGlobalColorTable) then
   begin
   //get
   gp.count:=2 shl (s.pf and pfColorTableSize);
   if (gp.count<2) or (gp.count>256) then
      begin
      e:=gecIndexOutOfRange;
      goto skipend;
      end;

   //set
   tmp2:=gp.count*sizeof(tcolor24);
   if ((pos1+tmp2-1)>dslen) then goto skipend;
   str__writeto1(ds,@gp.c,tmp2,pos1,tmp2);
   inc(pos1,tmp2);
   end;


//images
palinit(gp);

if (pos1>dslen) then goto skipend;
tmp    :=str__newsametype(ds);//create buffers same type as supplied by host
imgdata:=str__newsametype(ds);
xstr8ok:=str__is8(ds);

repeat
if xstr8ok then v:=(ds^ as tstr8).pbytes[pos1-1] else v:=str__bytes1(ds,pos1);

//scan
if (v=59) then break//terminator
else if (v<>0) then
   begin
   //init
   inc(pos1);

   case xstr8ok of
   true:if (pos1<=dslen) then v2:=(ds^ as tstr8).pbytes[pos1-1] else v2:=0;
   else if (pos1<=dslen) then v2:=str__bytes1(ds,pos1) else v2:=0;
   end;

   //blocks
   if (v=33) then
      begin

      //get - multi-length sub-parts (ie. text blocks etc)
      inc(pos1);
      str__clear(@tmp);
      while true do
      begin
      if (pos1<=dslen) then
         begin
         if xstr8ok then tmp2:=(ds^ as tstr8).pbytes[pos1-1] else tmp2:=str__bytes1(ds,pos1);
         str__add31(@tmp,ds,pos1+1,tmp2);
         if (tmp2=0) then break else inc(pos1,1+tmp2);
         end
      else break;
      end;//loop

      if (str__len(@tmp)=0) then goto skipone;

      //set
      case v2 of
      249:begin//control - for image handling

         if (str__len(@tmp)<4) then goto skipone;
         if xstr8ok then tmp2:=(tmp as tstr8).pbytes[0] else tmp2:=str__bytes1(@tmp,1);

         //.defaults
         bgcolor:=0;
         trans:=-1;//not in use
         wait:=false;
         dispose:=0;

         //.dispose mode
         dispose:=byte(frcrange32((tmp2 shl 27) shr 29,0,7));

         //.wait
         if (((tmp2 shl 30) shr 31)>=1) then wait:=true;

         //.bgcolor
         if xstr8ok then bgcolor:=(tmp as tstr8).pbytes[4-1] else bgcolor:=str__bytes1(@tmp,4);

         //.transparent
         if (((tmp2 shl 31) shr 31)>=1) then
            begin
            trans:=bgcolor;
            dtransparent:=true;
            end;

         //.delay
         inc(delay,frcmin32(str__sml2(@tmp,2-1),0));
         end;

      255:begin//loop
         loops:=str__sml2(@tmp,str__len(@tmp)-1-1);
         end;

      254:begin//comment
         //ignore
         end;

      1:begin//plain text - displayed on image
         //ignore
         end;

      end;//case
      end

   else if (v=44) then//image
      begin
      //get
      dec(pos1);
      str__writeto1(ds,@id,sizeof(id),pos1,sizeof(id));//was: tostrucb(@id,sizeof(id),copy(y,pos,sizeof(id)));
      inc(pos1,sizeof(id));

      //range
      id.dx:=frcrange32(id.dx,0,s.w);
      id.dy:=frcrange32(id.dy,0,s.h);
      id.w :=frcrange32(id.w,1,s.w);
      id.h :=frcrange32(id.h,1,s.h);

      //local palette
      fillchar(lp,sizeof(lp),0);
      if ((id.pf and idLocalColorTable)=idLocalColorTable) then
         begin
         //get
         lp.count:=2 shl (id.pf and idColorTableSize);
         if (lp.count<2) or (lp.count>256) then
            begin
            e:=gecIndexOutOfRange;
            goto skipend;
            end;

         //set
         tmp2:=lp.count*sizeof(tcolor24);
         if ((pos1+tmp2-1)>dslen) then goto skipend;
         str__writeto1(ds,@lp.c,tmp2,pos1,tmp2);
         inc(pos1,tmp2);

         //init
         palinit(lp);
         end;
      //.switch between global and local palettes
      if (lp.count=0) then pal:=@gp else pal:=@lp;

      //decompress image data
      gif__decompressex(pos1,ds,@imgdata,id.w,id.h,((id.pf and idInterlaced)<>0));

      //size
      inc(imgcount);

      //size host image strip 5 cells ahead to make room for new decoded cell
      if ((imgcount*s.w)>misw(simage)) or (mish(simage)<>s.h) then
         begin
         if not missize(simage, frcmax32(((misw(simage) div frcmin32(s.w,1)) + 5 ),imglimit)*s.w , low__aorb(mish(simage),s.h,mish(simage)<>s.h) ) then goto skipend;
         end;

      //cls
      if (imgcount<=1) then
         begin
         mis__cls2(simage,area__make(0,0,s.w-1,s.h-1),0,0,0,0);
         end
      else
         begin

         for dy:=0 to (s.h-1) do
         begin
         if not misscan82432(simage,dy,sr8,sr24,sr32) then goto skipend;

         //.32
         if (sbits=32) then
            begin
            for dx:=0 to (s.w-1) do
            begin
            case lastdispose of
            0,1:begin//graphic left in place
               c32:=sr32[offx-s.w+dx];
               sr32[offx+dx]:=c32;
               end;
            2:begin//restore background color - area used by image
               if (dy>=lastwinrect.top) and (dy<=lastwinrect.bottom) and (dx>=lastwinrect.left) and (dx<=lastwinrect.right) then
                  begin
                  c32.r:=0;
                  c32.g:=0;
                  c32.b:=0;
                  c32.a:=0;
                  sr32[offx+dx]:=c32;
                  end
               else
                  begin
                  c32:=sr32[offx-s.w+dx];
                  sr32[offx+dx]:=c32;
                  end;
               end;
            3:begin//restore to previous image - area used by image
               c32:=sr32[offx-s.w+dx];
               sr32[offx+dx]:=c32;
               end;
            end;//case
            end;//dx
            end//32

         //.24
         else if (sbits=24) then
            begin
            for dx:=0 to (s.w-1) do
            begin
            case lastdispose of
            0,1:begin//graphic left in place
               c24:=sr24[offx-s.w+dx];
               sr24[offx+dx]:=c24;
               end;
            2:begin//restore background color - area used by image
               if (dy>=lastwinrect.top) and (dy<=lastwinrect.bottom) and (dx>=lastwinrect.left) and (dx<=lastwinrect.right) then
                  begin
                  c24.r:=0;
                  c24.g:=0;
                  c24.b:=0;
                  sr24[offx+dx]:=c24;
                  end
               else
                  begin
                  c24:=sr24[offx-s.w+dx];
                  sr24[offx+dx]:=c24;
                  end;
               end;
            3:begin//restore to previous image - area used by image
               c24:=sr24[offx-s.w+dx];
               sr24[offx+dx]:=c24;
               end;
            end;//case
            end;//dx
            end//24

         //.8
         else if (sbits=8) then
            begin
            for dx:=0 to (s.w-1) do
            begin
            case lastdispose of
            0,1:begin//graphic left in place
               c8:=sr8[offx-s.w+dx];
               sr8[offx+dx]:=c8;
               end;
            2:begin//restore background color - area used by image
               if (dy>=lastwinrect.top) and (dy<=lastwinrect.bottom) and (dx>=lastwinrect.left) and (dx<=lastwinrect.right) then sr8[offx+dx]:=0
               else
                  begin
                  c8:=sr8[offx-s.w+dx];
                  sr8[offx+dx]:=c8;
                  end;
               end;
            3:begin//restore to previous image - area used by image
               c8:=sr8[offx-s.w+dx];
               sr8[offx+dx]:=c8;
               end;
            end;//case
            end;//dx
            end;//8

         end;//dy
         end;//if


      //draw
      p:=1;
      len:=str__len(@imgdata);

      for dy:=0 to (id.h-1) do
      begin
      ny:=dy+id.dy;

      if (ny>=0) and (ny<s.h) then
         begin
         if not misscan82432(simage,ny,sr8,sr24,sr32) then goto skipend;

         nx:=id.dx;

         //.32
         if (sbits=32) then
            begin
            for dx:=0 to (id.w-1) do
            begin

            if (nx>=0) and (nx<s.w) then
               begin
               if xstr8ok then ci:=(imgdata as tstr8).pbytes[p-1] else ci:=str__bytes1(@imgdata,p);
               if (ci<>trans) then
                  begin
                  c24:=pal.c[ci];
                  c32.r:=c24.r;
                  c32.g:=c24.g;
                  c32.b:=c24.b;
                  c32.a:=255;
                  sr32[offx+nx]:=c32;
                  end
               end;

            //inc
            inc(nx);
            inc(p);
            if (p>len) then break;
            end;//dx
            end//32

         //.24
         else if (sbits=24) then
            begin
            for dx:=0 to (id.w-1) do
            begin

            if (nx>=0) and (nx<s.w) then
               begin
               if xstr8ok then ci:=(imgdata as tstr8).pbytes[p-1] else ci:=str__bytes1(@imgdata,p);
               if (ci<>trans) then sr24[offx+nx]:=pal.c[ci];
               end;

            //inc
            inc(nx);
            inc(p);
            if (p>len) then break;
            end;//dx
            end//24

         //.8
         else if (sbits=8) then
            begin
            for dx:=0 to (id.w-1) do
            begin

            if (nx>=0) and (nx<s.w) then
               begin
               if xstr8ok then ci:=(imgdata as tstr8).pbytes[p-1] else ci:=str__bytes1(@imgdata,p);
               if (ci<>trans) then
                  begin
                  c8:=pal.c[ci].r;
                  if (pal.c[ci].g>c8) then c8:=pal.c[ci].g;
                  if (pal.c[ci].b>c8) then c8:=pal.c[ci].b;
                  sr8[offx+nx]:=c8;
                  end;
               end;

            //inc
            inc(nx);
            inc(p);
            if (p>len) then break;
            end;//dx
            end;//8
         end;//ny

      if (p>len) then break;
      end;//loop

      //inc
      inc(offx,s.w);
      dec(pos1);

      //last
      lastdispose:=dispose;
      lastwinrect:=area__make(id.dx,id.dy,frcmax32(id.dx+id.w-1,s.w-1),frcmax32(id.dy+id.h-1,s.h-1));

      //frame limit
      if (imgcount>=imglimit) then break;//safe number of frames
      end

   else if (v=59) then break//terminator

   else break;//unknown
   end;//if

skipone:
//inc
inc(pos1);
until (pos1>dslen);

//trim to final image strip width
if (imgcount<>0) and (simage<>nil) then missize(simage, imgcount*s.w, mish(simage) );

//animation information --------------------------------------------------------
//range - max. number of frames-per-second=50 (20ms)...[delay=0=>20ms or 50fps]
if (imgcount>=1) then
   begin
   delay:=frcmin32((delay div frcmin32(imgcount,1))*10,0);//ave. units => ave. ms

   //default is 100ms
   if (delay<=0) then delay:=100;
   end;

//set
dcellcount:=frcmin32(imgcount,1);
dcellwidth:=frcmin32(s.w,1);
dcellheight:=frcmin32(s.h,1);
ddelay:=frcmin32(delay,1);
case gp.count of
2      :dbpp:=2;
3..16  :dbpp:=4;
17..256:dbpp:=8;
end;//case

//.update animation information
misai(simage).delay        :=ddelay;
misai(simage).count        :=dcellcount;
misai(simage).cellwidth    :=dcellwidth;
misai(simage).cellheight   :=dcellheight;
misai(simage).transparent  :=dtransparent;
misai(simage).bpp          :=dbpp;

//.unbuffer
if (ss<>simage) and (not mis__copy(simage,ss)) then goto skipend;

//successful
result:=true;
skipend:
except;end;
try
if (simage<>nil) and (ss<>simage) then freeobj(@simage);
str__free(@tmp);
str__free(@imgdata);
str__uaf(ds);
except;end;
end;

function gif__todata(s:tobject;ds:pobject;var e:string):boolean;//11SEP2007
begin
result:=gif__todata2(s,ds,'',e);
end;

function gif__todata2(s:tobject;ds:pobject;daction:string;var e:string):boolean;
label
   skipend;
   //s       = image strip (one or more cells in a horizontal line) that forms the animation (best to use a 32bit image for transparency etc)
   //ds      = data stream (tstr8/tstr9) to write the GIF to
   //daction = optional actions / override values see below
var
   gs,c32:tobject;
   int1,p,sbits,sw,sh,cms,cc,cw,ch,cmaketrans:longint;
   bol1,cloop:boolean;
begin
result:=false;
gs:=nil;
c32:=nil;

try
//check
if not str__lock(ds)             then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
mis__calccells2(s,cms,cc,cw,ch);//safe animation information -> recalculates cellwidth/cellheight to match "s" current dimensions
gs:=tgifsupport.create;
c32:=misraw32(cw,ch);
cloop:=true;
cmaketrans:=clnone;

//actions
if ia__ifindval(daction,ia_delay,0,500,int1)                      then cms:=frcmin32(int1,0);//override cell delay with new delay
if ia__bfindval(daction,ia_loop,0,true,bol1)                      then cloop:=bol1;//override animation loop
if ia__ifindval(daction,ia_transparentcolor,0,clnone,int1)        then cmaketrans:=int1;


//start GIF data stream
if not gif__start(gs,ds,cw,ch,cloop) then goto skipend;

//add cells to GIF data stream "ds"
for p:=1 to cc do
begin
//.clear cell buffer -> in cases where image strip "s" falls short of last cell, that area will be transparent
mis__cls(c32,0,0,0,0);

//.copy pixels over to cell -> "s.cells[p-1] --> c32"
if not miscopyarea32(0,0,cw,ch,area__make( cw*(p-1), 0, cw*(p-1) + (cw-1), (ch-1) ), c32 , s) then goto skipend;

//.find a color and make that color transparent -> all previous transparency is removed
if (cmaketrans<>clnone) then
   begin
   mis__cls8(c32,255);//remove previous transparency
   mask__maketrans32(c32,cmaketrans);//create new transparency mask from color
   end;

//.add cell "c32" to GIF data stream
if not gif__addcell82432(gs,ds,c32,cms) then goto skipend;
end;//p

//finalise GIF data stream
if not gif__stop(ds) then goto skipend;

//successful
result:=true;
skipend:
except;end;
try
str__uaf(ds);
freeobj(@gs);
freeobj(@c32);
except;end;
end;

function gif__start(gs:tobject;ds:pobject;dw,dh:longint;dloop:boolean):boolean;
label
   //gs = tgifsupport,
   //ds = pointer to data stream (tstr8/tstr9)
   //dw = screen width (cell width)
   //dh = screen height (cell height)
   //dloop = true = play animation forever, false=play animation once
   skipend;
const
   //main flags
   pfGlobalColorTable	= $80;		{ set if global color table follows L.S.D. }
   pfColorResolution	= $70;		{ Color resolution - 3 bits }
   pfSort		= $08;		{ set if global color table is sorted - 1 bit }
   pfColorTableSize	= $07;		{ size of global color table - 3 bits }
   //local - image des
   idLocalColorTable	= $80;    { set if a local color table follows }
   idInterlaced		= $40;    { set if image is interlaced }
   idSort		= $20;    { set if color table is sorted }
   idReserved		= $0C;    { reserved - must be set to $00 }
   idColorTableSize	= $07;    { size of color table as above }
var
   s:tgifscreen;
begin
result:=false;

try
//check
if not str__lock(ds)       then goto skipend;
if zznil(gs,123)           then goto skipend;
if not (gs is tgifsupport) then goto skipend;

//init
str__clear(ds);
(gs as tgifsupport).sw:=frcrange32(dw,1,maxword);
(gs as tgifsupport).sh:=frcrange32(dh,1,maxword);
(gs as tgifsupport).cc:=0;//cell count -> increments with each new cell added -> full count only known when all cells have been added
(gs as tgifsupport).flags__lastpos:=0;
(gs as tgifsupport).flags__lastval:=0;

//get --------------------------------------------------------------------------
//header
str__aadd(ds,[uuG,uuI,uuF,nn8,nn9,lla]);//was: pushb(ylen,y,'GIF89a');
//screen info - no global palette - 31dec2022
fillchar(s,sizeof(s),0);
s.w:=(gs as tgifsupport).sw;
s.h:=(gs as tgifsupport).sh;

//was: pushb(ylen,y,fromstruc(@s,sizeof(s)));
str__addwrd2(ds,s.w);
str__addwrd2(ds,s.h);
str__addbyt1(ds,s.pf);
str__addbyt1(ds,s.bgi);
str__addbyt1(ds,s.ar);

//loop       //unknown code block [78..3..1]                       //0=loop forever
if dloop then
   begin
   str__aadd(ds,[33,255,11,78,69,84,83,67,65,80,69,50,46,48,3,1]);
   str__addsmi2(ds,0);
   str__addbyt1(ds,0);
   end;

//size support images
if not (gs as tgifsupport).size((gs as tgifsupport).sw,(gs as tgifsupport).sh) then goto skipend;

//successful
result:=true;
skipend:
except;end;
try;str__uaf(ds);except;end;
end;

function gif__addcell82432(gs:tobject;ds:pobject;c:tobject;cms:longint):boolean;//06aug2024: auto. optimises GIF data stream on-the-fly
label//06aug2024: Automatically optimises the GIF data stream on-the-fly.  Supports both solid and transparent cells, switching modes
     //           seamlessly using the reach-back method for "flag" mode.
     //gs  = tgifsupport object for cache support
     //ds  = desintation data stream (tstr8/tstr9) to write GFI data to
     //c   = cell image to add to GIF -> supports 8/24 and 32 bit cells with 32bit supporting transparency with "alpha<255"
     //cms = delay in milliseconds to wait before painting next cell in animation sequence
   skipend;
var
   gss:tgifsupport;
   ddata:tobject;
   dd32:tobject;//pointer to internal image
   mmin,mmax,xaddcount,xsubcount,sx,sy,sw,sh,p,cc,cbits,cw,ch,lw,lh:longint;
   dflags:byte;
   bol1,dtrans,dmode4,dmode8:boolean;
   ddes:tgifimgdes;
   cr8 :pcolorrow8;
   cr24:pcolorrow24;
   cr32:pcolorrow32;
   pr8 :pcolorrow8;
   sr32:pcolorrow32;
   dr32:pcolorrow32;
   c24 :tcolor24;
   c32 :tcolor32;
   s32 :tcolor32;
   n32 :tcolor32;
   e:string;
begin
//defaults
result:=false;
ddata:=nil;

try
//check
//.data stream
if not str__lock(ds)             then goto skipend;
if (str__len(ds)<12)             then goto skipend;

//.gif support object
if zznil(gs,122)                 then goto skipend;
if (gs is tgifsupport)           then gss:=(gs as tgifsupport) else goto skipend;

//.screen info
sw:=gss.sw;
sh:=gss.sh;
if (sw<1) or (sh<1)              then goto skipend;

//.inbound cell
if not misok82432(c,cbits,cw,ch) then goto skipend;

//.smart buffer
if not misok32(gss.s32,lw,lh)    then goto skipend;
if (lw<sw) or (lh<sh)            then goto skipend;

//.difference buffer
if not misok32(gss.d32,lw,lh)    then goto skipend;
if (lw<sw) or (lh<sh)            then goto skipend;

//.palette buffer
if not misok8(gss.p8,lw,lh)      then goto skipend;
if (lw<sw) or (lh<sh)            then goto skipend;


//init
dd32:=gss.d32;
gss.cc:=frcmin32(gss.cc+1,1);//first cell is cc=1
cc:=gss.cc;
cms:=frcrange32(cms div 10,0,32767);//divide inbound millisecond delay by 10 for GIF delay number -> side note: does a "cms=0" produce a multi-image 1st frame for preview systems => answer is NO - 05jan2023

n32.r:=0;
n32.g:=0;
n32.b:=0;
n32.a:=0;

//clear the smart write buffer "s32" at start (cc=1) -> default to black(r=0,g=0,b=0) and fully transparent(a=0)
if (cc<=1) then mis__cls(gss.s32,0,0,0,0);

//clear the difference buffer "d32"
mis__cls(gss.d32,0,0,0,0);


//merge inbound cell "c" with smart write buffer "gs.l32" and only the different is written to "gs.d32" for compression and inclusion in GIF data stream
xaddcount:=0;
xsubcount:=0;

for sy:=0 to (sh-1) do
begin
if not misscan82432(c,sy,cr8,cr24,cr32) then goto skipend;//inbound cell buffer
if not misscan32(gss.s32,sy,sr32)       then goto skipend;//smart buffer
if not misscan32(gss.d32,sy,dr32)       then goto skipend;//difference buffer

for sx:=0 to (sw-1) do
begin

//get
//.c8/24/32
case cbits of
32:begin
   c32:=cr32[sx];
   //.alpha level as 0 or 255 -> no middle levels
   if (c32.a<255) then c32.a:=0;
   end;
24:begin
   c24:=cr24[sx];
   c32.r:=c24.r;
   c32.g:=c24.g;
   c32.b:=c24.b;
   c32.a:=255;
   end;
8:begin
   c32.r:=cr8[sx];
   c32.g:=c32.r;
   c32.b:=c32.r;
   c32.a:=255;
   end;
end;//case
//.s32
s32:=sr32[sx];


//decide
//.subtracting transparent pixel -> requires a full repaint from s32
if (c32.a<s32.a) then
   begin
   inc(xsubcount);
   bol1:=true;
   end
//.adding a colored pixel -> requires only a partial repaint from d32
else if (c32.a>s32.a) or (c32.r<>s32.r) or (c32.g<>s32.g) or (c32.b<>s32.b) then
   begin
   inc(xaddcount);
   bol1:=true;
   end
//.neither -> no change -> store a blank image
else bol1:=false;


//set
if bol1 then
   begin
   sr32[sx]:=c32;
   dr32[sx]:=c32;
   end;

end;//sx
end;//sy


//analyse outbound cell and calculate render flags - 06aug2024
//.all modes and indicators off by default
dtrans :=false;
dmode4 :=false;//overwrite screen pixels -> leave screen intact -> add only mode
dmode8 :=false;//clear background to transparent -> subtract and repaint mode

case (xsubcount>=1) of
true:begin
   //.use the smart buffer to render what we have SO FAR for the screen
   dd32:=gss.s32;
   dmode4:=true;
   //need to reach back to previous frame and set it's mode to 8 or 9, as this flag requires a whole frame to pass by BEFORE it wipes the background clear - 06aug2024
   if (gss.flags__lastpos>=1) then
      begin
      case gss.flags__lastval of
      4:str__setbytes0(ds,gss.flags__lastpos,8);//flag was: add + solid
      5:str__setbytes0(ds,gss.flags__lastpos,9);//flag was: add + transparent
      end;
      end;
   end;
else begin
   //.use the difference buffer to render only the CHANGES on the screen
   dd32:=gss.d32;
   dmode4:=true;
   end;
end;//case


//is cell transparent -> scan it's mask for any values not 255
mask__range(dd32,mmin,mmax);
dtrans:=(mmin<255);//at least one pixel's alpha dipped below 255 so it's considered transparent


//gif render flags
dflags:=0;
if dtrans  then inc(dflags);//cell is transparent
if dmode4  then inc(dflags,4);//cell's pixels are to be drawn over the top of the current screen's pixels (add)
if dmode8  then inc(dflags,8);//cell's pixels are to be drawn to the screen ONCE the screen has been WIPED clean (sub/cleared)


//graphic control block
str__aadd(ds,[33,249,4]);
str__addbyt1(ds,dflags);
gss.flags__lastpos:=str__len(ds)-1;//store this frame's flags value and position in case a future frame needs to "reach-back" to change it
gss.flags__lastval:=dflags;
str__addsmi2(ds,cms);
str__aadd(ds,[0,0]);//transparent color index = 0 AND block terminator 0


//image information - Note: pf=0 (no local color table, not interlaced, not sorted)
fillchar(ddes,sizeof(ddes),0);
ddes.sep:=44;
ddes.w:=sw;
ddes.h:=sh;
ddes.dx:=0;
ddes.dy:=0;
str__addbyt1(ds,ddes.sep);//2C = OK
str__addwrd2(ds,ddes.dx);
str__addwrd2(ds,ddes.dy);
str__addwrd2(ds,ddes.w);
str__addwrd2(ds,ddes.h);


//build palette -> also maps palette index values into the pixels of "p8", providing a rapid lookup matrix for encoding the image further down below
if not gss.pmake(dd32,dtrans) then goto skipend;


//standardise palette count
case gss.pcount of
0..2 :gss.pcount:=2;
3..16:gss.pcount:=16;
else  gss.pcount:=256;
end;


//store palette flag
case gss.pcount of
2   :str__addbyt1(ds,176);
16  :str__addbyt1(ds,179);
else str__addbyt1(ds,183);//183=256PAL,NOT-SORTED [247=SORTED]
end;


//store local palette colors - 22sep2021
for p:=0 to (gss.pcount-1) do
begin
str__addbyt1(ds,gss.ppal[p].r);
str__addbyt1(ds,gss.ppal[p].g);
str__addbyt1(ds,gss.ppal[p].b);
end;//p


//image data
ddata:=str__newsametype(ds);//create a temporary data stream to write compressed image data to -> uses same data stream type as supplied by host
str__setlen(@ddata,sw*sh);//size the stream to fit the uncompressed image

p:=1;
for sy:=0 to (sh-1) do
begin
//.use "p8" as a rapid lookup matrix for palette colors
if not misscan8(gss.p8,sy,pr8) then goto skipend;

//.access tstr8 directly for faster performance
if str__is8(@ddata) then
   begin
   for sx:=0 to (sw-1) do
   begin
   (ddata as tstr8).pbytes[p-1]:=pr8[sx];//r-b elements are reversed in pal items
   inc(p);
   end;
   end
//.indirect access for larger capacity at the expense of performance
else
   begin
   for sx:=0 to (sw-1) do
   begin
   str__setbytes0(@ddata,p-1,pr8[sx]);//r-b elements are reversed in pal items
   inc(p);
   end;
   end;
end;//sy

//compress image data
if not gif__compress(@ddata,e) then goto skipend;

//append image data
str__add(ds,@ddata);

//successful
result:=true;
skipend:
except;end;
try
str__free(@ddata);
str__uaf(ds);
except;end;
end;

function gif__stop(ds:pobject):boolean;
begin
result:=false;

//check
if not str__lock(ds) then exit;

//write the terminator code "59" - 31dec2022: fixed
try
if (str__len(ds)>=12) then
   begin
   str__aadd(ds,[59]);
   result:=true;
   end;
except;end;
//free
str__uaf(ds);
end;


//mask support -----------------------------------------------------------------
function mask__empty(s:tobject):boolean;
var
   xmin,xmax:longint;
begin
result:=true;
if mask__range(s,xmin,xmax) then result:=(xmax<=0);
end;

function mask__allTransparent(s:tobject):boolean;//indicates no pixel in mask is 255
var
   v0,v255,vother:boolean;
   xmin,xmax:longint;
begin
result:=mask__range2(s,v0,v255,vother,xmin,xmax) and (not v255);
end;

function mask__hasTransparency32(s:tobject):boolean;//one or more alpha values are below 255 - 27may2025
var
   bol1:boolean;
begin
result:=mask__hasTransparency322(s,bol1);
end;

function mask__hasTransparency322(s:tobject;var xsimple0255:boolean):boolean;//one or more alpha values are below 255 - 27may2025
var
   sx,sy,sw,sh,sbits:longint;
   sr32:pcolorrow32;
begin
//defaults
result      :=false;
xsimple0255 :=true;

try
//check
if (not misok82432(s,sbits,sw,sh)) or (sbits<>32) then exit;

//get
for sy:=0 to (sh-1) do
begin
if not misscan32(s,sy,sr32) then break;

for sx:=0 to (sw-1) do
begin

case sr32[sx].a of
0:result:=true;
1..254:begin
   result     :=true;
   xsimple0255:=false;
   break;
   end;
end;//case

end;//sx

//stop
if result and (not xsimple0255) then break;
end;//sy

except;end;
end;

function mask__range(s:tobject;var xmin,xmax:longint):boolean;//15feb2022
var
   v0,v255,vother:boolean;
begin
result:=mask__range2(s,v0,v255,vother,xmin,xmax);
end;

function mask__range2(s:tobject;var v0,v255,vother:boolean;var xmin,xmax:longint):boolean;//15feb2022
label
   skipend;
var
   sx,sy,sw,sh,sbits:longint;
   sr32:pcolorrow32;
   sr8:pcolorrow8;
   v:byte;
begin
//defaults
result:=false;

try
v0     :=false;
v255   :=false;
vother :=false;
xmin   :=255;
xmax   :=0;

//check
if not misok82432(s,sbits,sw,sh) then exit;

//get
//.24
if (sbits=24) then
   begin
   xmin  :=255;
   xmax  :=255;
   v255  :=true;
   result:=true;
   goto skipend;
   end;

//get
//.sy
for sy:=0 to (sh-1) do
begin
if not misscan832(s,sy,sr8,sr32) then goto skipend;
//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   v:=sr32[sx].a;
   if (v>xmax) then xmax:=v;
   if (v<xmin) then xmin:=v;
   case v of
   0   :v0:=true;
   255 :v255:=true;
   else vother:=true;
   end;//case
   end;//sx
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   v:=sr8[sx];
   if (v>xmax) then xmax:=v;
   if (v<xmin) then xmin:=v;
   case v of
   0   :v0:=true;
   255 :v255:=true;
   else vother:=true;
   end;//case
   end;//sx
   end;
//check
if (xmin<=0) and (xmax>=255) and v0 and v255 and vother then break;
end;//sy
//successful
result:=true;
skipend:
except;end;
end;

function mask__maxave(s:tobject):longint;//0..255
label
   skipend;
var
   dtotal,dcount:comp;
   sx,sy,sw,sh,sbits:longint;
   sr32:pcolorrow32;
   sr8:pcolorrow8;
begin
//defaults
result:=0;

try
dtotal:=0;
dcount:=0;
//check
if not misok82432(s,sbits,sw,sh) then exit;
//get
//.24
if (sbits=24) then
   begin
   result:=255;
   goto skipend;
   end;
//get
//.sy
for sy:=0 to (sh-1) do
begin
if not misscan832(s,sy,sr8,sr32) then goto skipend;
//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do dtotal:=dtotal+sr32[sx].a;
   dcount:=dcount+sw;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do dtotal:=dtotal+sr8[sx];
   dcount:=dcount+sw;
   end;
end;//sy
skipend:
//.finalise
if (dcount>=1) then result:=frcrange32(restrict32(div64(dtotal,dcount)),0,255);
except;end;
end;

function mask__setval(s:tobject;xval:longint):boolean;
label
   skipend;
var
   sx,sy,sw,sh,sbits:longint;
   sr32:pcolorrow32;
   sr8:pcolorrow8;
   v:byte;
begin
//defaults
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;
//.24
if (sbits=24) then//ignore
   begin
   result:=true;
   goto skipend;
   end;
//range
v:=frcrange32(xval,0,255);
//get
//.sy
for sy:=0 to (sh-1) do
begin
if not misscan832(s,sy,sr8,sr32) then goto skipend;
//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do sr32[sx].a:=v;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do sr8[sx]:=v;
   end;
end;//dy
//successful
result:=true;
skipend:
except;end;
end;

function mask__maketrans32(s:tobject;scolor:longint):boolean;//directly edit image's alpha mask
var
   achangecount:longint;
begin
result:=mask__maketrans322(s,scolor,achangecount);
end;

function mask__maketrans322(s:tobject;scolor:longint;var achangecount:longint):boolean;//directly edit image's alpha mask
begin
result:=mask__maketrans323(s,scolor,0,achangecount);
end;

function mask__maketrans323(s:tobject;scolor:longint;smaskval:byte;var achangecount:longint):boolean;//06aug2024: directly edit image's alpha mask
label
   skipend;
var
   r,g,b,sx,sy,sw,sh:longint;
   s32,c32:tcolor32;
   sr32:pcolorrow32;
begin
result:=false;
achangecount:=0;

try
//check
if not misok32(s,sw,sh) then exit;

//init
misfindtranscol82432ex(s,scolor,r,g,b);
s32.r:=byte(r);
s32.g:=byte(g);
s32.b:=byte(b);

//get
for sy:=0 to (sh-1) do
begin
if not misscan32(s,sy,sr32) then goto skipend;

for sx:=0 to (sw-1) do
begin
c32:=sr32[sx];
if (c32.a<>smaskval) and (c32.r=s32.r) and (c32.g=s32.g) and (c32.b=s32.b) then
   begin
   sr32[sx].a:=smaskval;
   inc(achangecount);
   end;
end;//sx

end;//sy

//successful
result:=(achangecount>=1);
skipend:
except;end;
end;

function mask__copy(s,d:tobject):boolean;//15feb2022
begin
result:=mask__copy3(s,d,clnone,-1);
end;

function mask__copy2(s,d:tobject;stranscol:longint):boolean;
begin
result:=mask__copy3(s,d,stranscol,-1);
end;

function mask__copy3(s,d:tobject;stranscol,sremove:longint):boolean;
label//extracts 8bit alpha from a32 and copies it to a8
     //note: strancols adds transparency to existing mask as it copies it over
     //note: sremove=0..255 = removes original mask as its copied over
   skipend;
var
   tr,tg,tb,sx,sy,sw,sh,sbits,dbits,dw,dh:longint;
   sr8,dr8:pcolorrow8;
   sr24,dr24:pcolorrow24;
   sr32,dr32:pcolorrow32;
   sc32:tcolor32;
   sc24:tcolor24;
   sc8:tcolor8;
begin
//defaults
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;
if not misok82432(d,dbits,dw,dh) then exit;
if (sw>dw) or (sh>dh) then exit;
//init
tr:=-1;
tg:=-1;
tb:=-1;
stranscol:=mistranscol(s,stranscol,stranscol<>clnone);
if (stranscol<>clnone) then
   begin
   sc24:=int__c24(stranscol);
   tr:=sc24.r;
   tg:=sc24.g;
   tb:=sc24.b;
   end;
//.sremove
if (sremove=clnone) then sremove:=-1;//off
sremove:=frcrange32(sremove,-1,255);//-1=off
//get
//.dy
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
if not misscan82432(d,sy,dr8,dr24,dr32) then goto skipend;
//.32 + 32
if (sbits=32) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc32:=sr32[sx];
   if (tr=sc32.r) and (tg=sc32.g) and (tb=sc32.b) then dr32[sx].a:=0
   else if (sremove>=0)                           then dr32[sx].a:=byte(sremove)
   else                                                dr32[sx].a:=sc32.a;
   end;//sx
   end
//.32 + 24
else if (sbits=32) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.32 + 8
else if (sbits=32) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc32:=sr32[sx];
   if (tr=sc32.r) and (tg=sc32.g) and (tb=sc32.b) then dr8[sx]:=0
   else if (sremove>=0)                           then dr8[sx]:=byte(sremove)
   else                                                dr8[sx]:=sc32.a;
   end;//sx
   end
//.24 + 32
else if (sbits=24) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc24:=sr24[sx];
   if (tr=sc24.r) and (tg=sc24.g) and (tb=sc24.b) then dr32[sx].a:=0
   else                                                dr32[sx].a:=255;
   end;//sx
   end
//.24 + 24
else if (sbits=24) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.24 + 8
else if (sbits=24) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc24:=sr24[sx];
   if (tr=sc24.r) and (tg=sc24.g) and (tb=sc24.b) then dr8[sx]:=0
   else                                                dr8[sx]:=255;
   end;//sx
   end
//.8 + 32
else if (sbits=8) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc8:=sr8[sx];
   sc32:=dr32[sx];
   if (tr=sc32.r) and (tg=sc32.g) and (tb=sc32.b) then dr32[sx].a:=0
   else if (sremove>=0) then                           dr32[sx].a:=byte(sremove)
   else                                                dr32[sx].a:=sc8;
   end;//sx
   end
//.8 + 24
else if (sbits=8) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.8 + 8
else if (sbits=8) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc8:=sr8[sx];
   if (sremove>=0) then dr8[sx]:=byte(sremove)
   else                 dr8[sx]:=sc8;
   end;//sx
   end;
end;//dy
//successful
result:=true;
skipend:
except;end;
end;

function mask__copymin(s,d:tobject):boolean;//15feb2022
label
   skipend;
var
   sx,sy,sw,sh,sbits,dbits,dw,dh:longint;
   sr8,dr8:pcolorrow8;
   sr24,dr24:pcolorrow24;
   sr32,dr32:pcolorrow32;
   sv,dv:tcolor8;
begin
//defaults
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;
if not misok82432(d,dbits,dw,dh) then exit;
if (sw>dw) or (sh>dh) then exit;
if (s=d) then
   begin
   result:=true;
   exit;
   end;
//get
//.dy
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
if not misscan82432(d,sy,dr8,dr24,dr32) then goto skipend;
//.32 + 32
if (sbits=32) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sv:=sr32[sx].a;
   dv:=dr32[sx].a;
   if (dv<sv) then sv:=dv;
   dr32[sx].a:=sv;
   end;//sx
   end
//.32 + 24
else if (sbits=32) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.32 + 8
else if (sbits=32) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sv:=sr32[sx].a;
   dv:=dr8[sx];
   if (dv<sv) then sv:=dv;
   dr8[sx]:=sv;
   end;//sx
   end
//.24 + 32
else if (sbits=24) and (dbits=32) then
   begin
   result:=true;
   goto skipend;
   end
//.24 + 24
else if (sbits=24) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.24 + 8
else if (sbits=24) and (dbits=8) then
   begin
   result:=true;
   goto skipend;
   end
//.8 + 32
else if (sbits=8) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sv:=sr8[sx];
   dv:=dr32[sx].a;
   if (dv<sv) then sv:=dv;
   dr32[sx].a:=sv;
   end;//sx
   end
//.8 + 24
else if (sbits=8) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.8 + 8
else if (sbits=8) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sv:=sr8[sx];
   dv:=dr8[sx];
   if (dv<sv) then sv:=dv;
   dr8[sx]:=sv;
   end;//sx
   end;
end;//dy
//successful
result:=true;
skipend:
except;end;
end;

function mask__setopacity(s:tobject;xopacity255:longint):boolean;//06jun2021
label
   skipend;
var
   sx,sy,sw,sh,sbits:longint;
   sr32:pcolorrow32;
   sr8:pcolorrow8;
   sv,v8:byte;
begin
//defaults
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;
//range
v8:=frcrange32(xopacity255,0,255);
//.nothing to do -> ignore
if (v8=255) then
   begin
   result:=true;
   exit;
   end;
//get
//.sy
for sy:=0 to (sh-1) do
begin
if not misscan832(s,sy,sr8,sr32) then goto skipend;
//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sv:=sr32[sx].a;
   if (sv>=1) then
      begin
      sv:=(sv*v8) div 255;
      if (sv<=0) then sv:=1;
      sr32[sx].a:=sv;
      end;
   end;//sx
   end
//.24
else if (sbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sv:=sr8[sx];
   if (sv>=1) then
      begin
      sv:=(sv*v8) div 255;
      if (sv<=0) then sv:=1;
      sr8[sx]:=sv;
      end;
   end;//sx
   end;
end;//sy
//successful
result:=true;
skipend:
except;end;
end;

function mask__multiple(s:tobject;xby:currency):boolean;//18sep2022
label
   skipend;
var
   sv,sx,sy,sw,sh,sbits:longint;
   sr32:pcolorrow32;
   sr8:pcolorrow8;
begin
//defaults
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;
//.nothing to do -> ignore
if (xby=1) or (xby<0) then exit;
//get
//.sy
for sy:=0 to (sh-1) do
begin
if not misscan832(s,sy,sr8,sr32) then goto skipend;
//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sv:=sr32[sx].a;
   if (sv>=1) then
      begin
      sv:=round(sv*xby);
      if (sv<=0) then sv:=1 else if (sv>255) then sv:=255;
      sr32[sx].a:=byte(sv);
      end;
   end;//sx
   end
//.24
else if (sbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sv:=sr8[sx];
   if (sv>=1) then
      begin
      sv:=round(sv*xby);
      if (sv<=0) then sv:=1 else if (sv>255) then sv:=255;
      sr8[sx]:=byte(sv);
      end;
   end;//sx
   end;
end;//sy
//successful
result:=true;
skipend:
except;end;
end;

function mask__forcesimple0255(s:tobject):boolean;//21nov2024
label//Converts a mask with shades into 0=transparent and 255=opaque so that the mask only contents the values 0 or 255
   skipend;
var
   sx,sy,sw,sh,sbits:longint;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8:pcolorrow8;
begin
//defaults
result:=false;

//check
if not misok82432(s,sbits,sw,sh) then exit;

try
//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   case sr32[sx].a of
   1..254:sr32[sx].a:=255;
   end;
   end;//sx
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   case sr8[sx] of
   1..254:sr8[sx]:=255;
   end;
   end;//sx
   end
else break;
end;//dy

//successful
result:=true;
skipend:
except;end;
end;

function mask__makesimple0255(s:tobject;tc:longint):boolean;//21nov2024
label//Creates a mask using the transparent color "tc" into 0=transparent or 255=opaque, 1..254 are not used
   skipend;
var
   tr,tg,tb,t8,sx,sy,sw,sh,sbits:longint;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8:pcolorrow8;
   sc32:tcolor32;
begin
//defaults
result:=false;

//check
if not misok82432(s,sbits,sw,sh) then exit;

try
//init
if (tc=clnone) then//set mask to all zeros "0"
   begin
   tr:=-1;
   tg:=-1;
   tb:=-1;
   t8:=-1;
   end
else
   begin//make the pixels that match tc transparent and all others opaque
   misfindtranscol82432ex(s,tc,tr,tg,tb);
   t8:=tr;
   if (tg>t8) then t8:=tg;
   if (tb>t8) then t8:=tb;
   end;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc32:=sr32[sx];
   if (sc32.r=tr) and (sc32.g=tg) and (sc32.b=tb) then sr32[sx].a:=0 else sr32[sx].a:=255;//09jan2025: blue effort - fixed
   end;//sx
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if (sr8[sx]=t8) then sr8[sx]:=0 else sr8[sx]:=255;
   end;//sx
   end
else break;
end;//dy

//successful
result:=true;
skipend:
except;end;
end;

function mask__feather(s,d:tobject;sfeather,stranscol:longint;var xouttranscol:longint):boolean;//20jan2021
begin
result:=mask__feather2(s,d,sfeather,stranscol,false,xouttranscol);
end;

function mask__feather2(s,d:tobject;sfeather,stranscol:longint;stransframe:boolean;var xouttranscol:longint):boolean;//15feb2022, 18jun2021, 08jun2021, 20jan2021
label//sfeather:  -1=asis, 0=none(sharp), 1=feather(1px/blur), 2=feather(2px/blur), 3=feather(1px), 4=feather(2px)
     //stranscol: clnone=solid (no see thru parts), clTopLeft=pixel(0,0), else=user specified color
   doasis,dosolid,dofeather,doblur,skipdone,skipend;
const
   xfeather1=110;//more inline with a sine curve - 20jan2021
   xfeather2=30;
var
   xlist:array[0..255] of longint;//used to cache a feather curve that drifts off towards zero for more effective edge softening - 20jan2021
   srows8,drows8:pcolorrows8;
   srows24,drows24:pcolorrows24;
   srows32,drows32:pcolorrows32;
   sr8,dr8:pcolorrow8;
   sr24:pcolorrow24;
   sr32,dr32:pcolorrow32;
   ac8,sc8:tcolor8;
   ac24,sc24:tcolor24;
   ac32,sc32:tcolor32;
   xlen,ylen,xylen,xshortlen,dval,fx,fy,xfeather,i,dv,dc,sbits,sw,sh,dbits,dw,dh,sxx,sx,sy:longint;
   fval:byte;
   tr,tg,tb:longint;
   xinitrows8OK,tok,xblur,xalternate:boolean;

   procedure xinitrows832;
   begin
   if xinitrows8OK then exit;
   misrows82432(d,drows8,drows24,drows32);
   xinitrows8OK:=true;
   end;

   procedure drect832(dx,dy,dx2,dy2,dval:longint);
   var
      sx,sy:longint;
   begin
   //range
   if (dval<=0) then dval:=1 else if (dval>=255) then dval:=254;//never 0 or 255
   //check
   if (dx2<dx) or (dy2<dy) or (dx<0) or (dx>=sw) or (dy<0) or (dy>=sh) or (dx2<0) or (dx2>=sw) or (dy2<0) or (dy2>=sh) then exit;
   //.32
   if (dbits=32) then
      begin
      for sx:=dx to dx2 do drows32[dy][sx].a:=byte(dval);//top
      for sx:=dx to dx2 do drows32[dy2][sx].a:=byte(dval);//bottom
      for sy:=dy to dy2 do drows32[sy][dx].a:=byte(dval);//left
      for sy:=dy to dy2 do drows32[sy][dx2].a:=byte(dval);//right
      end
   //.8
   else if (dbits=8) then
      begin
      for sx:=dx to dx2 do drows8[dy][sx]:=byte(dval);//top
      for sx:=dx to dx2 do drows8[dy2][sx]:=byte(dval);//bottom
      for sy:=dy to dy2 do drows8[sy][dx]:=byte(dval);//left
      for sy:=dy to dy2 do drows8[sy][dx2]:=byte(dval);//right
      end;
   end;
begin
//defaults
result:=false;

try
xinitrows8OK:=false;
xouttranscol:=clnone;
//init
if not misok82432(s,sbits,sw,sh) then exit;
if not misok82432(d,dbits,dw,dh) then
   begin
   //special case: allow "s32" to write to own mask e.g. "s32.mask" - 15feb2022
   if (d=nil) and (sbits=32) then
      begin
      d:=s;
      dbits:=sbits;
      dw:=sw;
      dh:=sh;
      end
   else exit;
   end;
if (sw>dw) or (sh>dh) then exit;

//feather
xfeather:=frcrange32(sfeather,-1,100);//-1=asis
xblur:=(xfeather>=1);

//.force sharp feather when transparent color is specified - 17jan2021
if (xfeather<0) and (stranscol<>clnone) then xfeather:=0;

//.feather curve -> used for feathers 3px+
if (xfeather>=1) and (not miscurveAirbrush2(xlist,high(xlist)+1,0,255,false,false)) then goto skipend;

//transcol
tr:=-1;
tg:=-1;
tb:=-1;
tok:=false;//no transparency -> solid
if (xfeather>=0) and (stranscol<>clnone) then
   begin
   //.ok
   tok:=true;
   if not misfindtranscol82432ex(s,stranscol,tr,tg,tb) then goto skipend;
   xouttranscol:=rgba0__int(tr,tg,tb);
   end;

//decide
if (xfeather=-1)  then goto doasis
else if not tok   then goto dosolid
else                   goto dofeather;

//asis -------------------------------------------------------------------------
doasis:
//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
if not misscan832(d,sy,dr8,dr32) then goto skipend;

//.32 + 32 + (s=d)
if (sbits=32) and (dbits=32) and (s=d) then
   begin
   result:=true;
   goto skipend;
   end
//.32 + 32
else if (sbits=32) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc8:=sr32[sx].a;
   dr32[sx].a:=sc8;
   end;//sx
   end
//.32 + 24
else if (sbits=32) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.32 + 8
else if (sbits=32) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc8:=sr32[sx].a;
   dr8[sx]:=sc8;
   end;//sx
   end
//.24 + 32
else if (sbits=24) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do dr32[sx].a:=255;
   end
//.24 + 24
else if (sbits=24) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.24 + 8
else if (sbits=24) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do dr8[sx]:=255;
   end
//.8 + 32
else if (sbits=8) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc8:=sr8[sx];
   dr32[sx].a:=sc8;
   end;//sx
   end
//.8 + 24
else if (sbits=8) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.8 + 8
else if (sbits=8) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc8:=sr8[sx];
   dr8[sx]:=sc8;
   end;//sx
   end;
end;//sy
goto skipdone;


//solid ------------------------------------------------------------------------
dosolid:
//cls
for sy:=0 to (sh-1) do
begin
if not misscan832(d,sy,dr8,dr32) then goto skipend;
//.32
if (dbits=32) then
   begin
   for sx:=0 to (sw-1) do dr32[sx].a:=255;
   end
//.24
else if (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.8
else if (dbits=8) then
   begin
   for sx:=0 to (sw-1) do dr8[sx]:=255;
   end;
end;//sy
//get
xinitrows832;
case xfeather of
1..2:begin
   for sx:=0 to (xfeather-1) do
   begin
   if (xfeather=1) then dval:=xfeather1
   else if (sx=0) then dval:=xfeather2 else dval:=xfeather1;

   drect832(sx,sx,sw-1-sx,sh-1-sx,dval);
   end;//sx
   end;
3..max32:begin
   for sx:=0 to (xfeather-1) do drect832(sx,sx,sw-1-sx,sh-1-sx,xlist[round((sx/xfeather)*255)]);
   end;
end;//case
//.blur
goto doblur;


//feather ----------------------------------------------------------------------
dofeather:

//init
if (xfeather>=1) and (not misrows82432(s,srows8,srows24,srows32)) then goto skipend;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
if not misscan832(d,sy,dr8,dr32) then goto skipend;

case xfeather of
//sharp
0:begin
   //.32 + 32
   if (sbits=32) and (dbits=32) then
      begin
      for sx:=0 to (sw-1) do
      begin
      sc32:=sr32[sx];
      if (tr=sc32.r) and (tg=sc32.g) and (tb=sc32.b) then dr32[sx].a:=0 else dr32[sx].a:=255;
      end;//sx
      end
   //.32 + 24
   else if (sbits=32) and (dbits=24) then
      begin
      goto skipend;
      result:=true;
      end
   //.32 + 8
   else if (sbits=32) and (dbits=8) then
      begin
      for sx:=0 to (sw-1) do
      begin
      sc32:=sr32[sx];
      if (tr=sc32.r) and (tg=sc32.g) and (tb=sc32.b) then dr8[sx]:=0 else dr8[sx]:=255;
      end;//sx
      end
   //.24 + 32
   else if (sbits=24) and (dbits=32) then
      begin
      for sx:=0 to (sw-1) do
      begin
      sc24:=sr24[sx];
      if (tr=sc24.r) and (tg=sc24.g) and (tb=sc24.b) then dr32[sx].a:=0 else dr32[sx].a:=255;
      end;//sx
      end
   //.24 + 24
   else if (sbits=24) and (dbits=24) then
      begin
      result:=true;
      goto skipend;
      end
   //.24 + 8
   else if (sbits=24) and (dbits=8) then
      begin
      for sx:=0 to (sw-1) do
      begin
      sc24:=sr24[sx];
      if (tr=sc24.r) and (tg=sc24.g) and (tb=sc24.b) then dr8[sx]:=0 else dr8[sx]:=255;
      end;//sx
      end
   //.8 + 32
   else if (sbits=8) and (dbits=32) then
      begin
      for sx:=0 to (sw-1) do
      begin
      sc8:=sr8[sx];
      if (tr=sc8) then dr32[sx].a:=0 else dr32[sx].a:=255;
      end;//sx
      end
   //.8 + 24
   else if (sbits=8) and (dbits=24) then
      begin
      result:=true;
      goto skipend;
      end
    //.8 + 8
   else if (sbits=8) and (dbits=8) then
      begin
      for sx:=0 to (sw-1) do
      begin
      sc8:=sr8[sx];
      if (tr=sc8) then dr8[sx]:=0 else dr8[sx]:=255;
      end;//sx
      end;
   end;//begin
//slow feather -----------------------------------------------------------------
3..max32:begin
   //.32 + 32/24/8
   if (sbits=32) then
      begin
      for sx:=0 to (sw-1) do
      begin
      //init
      sc32:=sr32[sx];
      dval:=0;
      //get
      if (tr<>sc32.r) or (tg<>sc32.g) or (tb<>sc32.b) then
         begin
         //init
         dval:=255;
         xshortlen:=xfeather+1;
         //.fy
         for fy:=(sy-xfeather) to (sy+xfeather) do
         begin
         if (fy>=0) and (fy<sh) then
            begin
            //.y len
            ylen:=fy-sy;
            if (ylen<0) then ylen:=-ylen;
            //.fx
            for fx:=(sx-xfeather) to (sx+xfeather) do
            begin
            if (fx>=0) and (fx<sw) and ((fx<>sx) or (fy<>sy)) then
               begin
               //get
               ac32:=srows32[fy][fx];
               if ((tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b)) or (stransframe and ( (fx<=0) or (fx>=(sw-1)) or (fy<=0) or (fy>=(sh-1)) ) ) then
                  begin
                  //get
                  //.x len
                  xlen:=fx-sx;
                  if (xlen<0) then xlen:=-xlen;
                  //.yx len
                  xylen:=trunc(sqrt((xlen*xlen)+(ylen*ylen)));
                  if (xylen<xshortlen) then xshortlen:=xylen;
                  if (xshortlen<1) then xshortlen:=1;
                  if (xshortlen<=1) then break;
                  end;//tr -> ac32
               end;
            end;//fx
            end;
         //check
         if (xshortlen<=1) then break;
         end;//fy
         //set
         if (xshortlen<(xfeather+1)) then
            begin
            dval:=round((xshortlen/(xfeather+1))*255);
            //.curve the feather
            if (dval<0) then dval:=0 else if (dval>255) then dval:=255;
            dval:=xlist[dval];
            //.limit the feather to visible shades (not 0=off, not 255=solid)
            if (dval<=0) then dval:=1 else if (dval>=255) then dval:=254;//never 0 or 255
            end;
         end;//tr -> sc32
      //set
      case dbits of
      32:dr32[sx].a:=dval;
      24:begin
         result:=true;
         goto skipend;
         end;
      8:dr8[sx]:=dval;
      end;//case
      end;//sx
      end//32
   //.24 + 32/24/8
   else if (sbits=24) then
      begin
      for sx:=0 to (sw-1) do
      begin
      //init
      sc24:=sr24[sx];
      dval:=0;
      //get
      if (tr<>sc24.r) or (tg<>sc24.g) or (tb<>sc24.b) then
         begin
         //init
         dval:=255;
         xshortlen:=xfeather+1;
         //.fy
         for fy:=(sy-xfeather) to (sy+xfeather) do
         begin
         if (fy>=0) and (fy<sh) then
            begin
            //.y len
            ylen:=fy-sy;
            if (ylen<0) then ylen:=-ylen;
            //.fx
            for fx:=(sx-xfeather) to (sx+xfeather) do
            begin
            if (fx>=0) and (fx<sw) and ((fx<>sx) or (fy<>sy)) then
               begin
               //get
               ac24:=srows24[fy][fx];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then
                  begin
                  //get
                  //.x len
                  xlen:=fx-sx;
                  if (xlen<0) then xlen:=-xlen;
                  //.yx len
                  xylen:=trunc(sqrt((xlen*xlen)+(ylen*ylen)));
                  if (xylen<xshortlen) then xshortlen:=xylen;
                  if (xshortlen<1) then xshortlen:=1;
                  if (xshortlen<=1) then break;
                  end;//tr -> ac24
               end;
            end;//fx
            end;
         //check
         if (xshortlen<=1) then break;
         end;//fy
         //set
         if (xshortlen<(xfeather+1)) then
            begin
            dval:=round((xshortlen/(xfeather+1))*255);
            //.curve the feather
            if (dval<0) then dval:=0 else if (dval>255) then dval:=255;
            dval:=xlist[dval];
            //.limit the feather to visible shades (not 0=off, not 255=solid)
            if (dval<=0) then dval:=1 else if (dval>=255) then dval:=254;//never 0 or 255
            end;
         end;//tr -> sc24
      //set
      case dbits of
      32:dr32[sx].a:=dval;
      24:begin
         result:=true;
         goto skipend;
         end;
      8:dr8[sx]:=dval;
      end;//case
      end;//sx
      end//24
   //.8 + 32/24/8
   else if (sbits=8) then
      begin
      for sx:=0 to (sw-1) do
      begin
      //init
      sc8:=sr8[sx];
      dval:=0;
      //get
      if (tr<>sc8) then
         begin
         //init
         dval:=255;
         xshortlen:=xfeather+1;
         //.fy
         for fy:=(sy-xfeather) to (sy+xfeather) do
         begin
         if (fy>=0) and (fy<sh) then
            begin
            //.y len
            ylen:=fy-sy;
            if (ylen<0) then ylen:=-ylen;
            //.fx
            for fx:=(sx-xfeather) to (sx+xfeather) do
            begin
            if (fx>=0) and (fx<sw) and ((fx<>sx) or (fy<>sy)) then
               begin
               //get
               ac8:=srows8[fy][fx];
               if (tr=ac8) then
                  begin
                  //get
                  //.x len
                  xlen:=fx-sx;
                  if (xlen<0) then xlen:=-xlen;
                  //.yx len
                  xylen:=trunc(sqrt((xlen*xlen)+(ylen*ylen)));
                  if (xylen<xshortlen) then xshortlen:=xylen;
                  if (xshortlen<1) then xshortlen:=1;
                  if (xshortlen<=1) then break;
                  end;//tr -> ac24
               end;
            end;//fx
            end;
         //check
         if (xshortlen<=1) then break;
         end;//fy
         //set
         if (xshortlen<(xfeather+1)) then
            begin
            dval:=round((xshortlen/(xfeather+1))*255);
            //.curve the feather
            if (dval<0) then dval:=0 else if (dval>255) then dval:=255;
            dval:=xlist[dval];
            //.limit the feather to visible shades (not 0=off, not 255=solid)
            if (dval<=0) then dval:=1 else if (dval>=255) then dval:=254;//never 0 or 255
            end;
         end;//tr -> sc24
      //set
      case dbits of
      32:dr32[sx].a:=dval;
      24:begin
         result:=true;
         goto skipend;
         end;
      8:dr8[sx]:=dval;
      end;//case
      end;//sx
      end;//8
   end;
//------------------------------------------------------------------------------
//fast feather 1 & 2 -> eat into image edge -> feather works in on solid parts of image -> never extends -> original color image remains unaltered - 12jan2021
1..2:begin
   //.8 + 32/24/8
   if (sbits=8) then
      begin
      for sx:=0 to (sw-1) do
      begin
      //init
      sc8:=sr8[sx];
      dval:=0;
      //get
      if (tr<>sc8) then
         begin
         //init
         dval:=255;
         if (xfeather=1) then fval:=xfeather1 else fval:=xfeather2;
         //stransframe
         if stransframe then
            begin
            //feather 1
            if ((sx-1)<=0) or ((sx+1)>=(sw-1)) then dval:=fval
            else if ((sy-1)<=0) or ((sy+1)>=(sh-1)) then dval:=fval;
            //feather 2
            if (dval=255) and (xfeather=2) then
               begin
               if ((sx-2)<=0) or ((sx+2)>=(sw-1)) then dval:=xfeather1
               else if ((sy-2)<=0) or ((sy+2)>=(sh-1)) then dval:=xfeather1;
               end;
            end;
         //x-1
         if (dval=255) and (sx>=1) then
            begin
            ac8:=srows8[sy][sx-1];
            if (tr=ac8) then dval:=fval;
            end;
         //x+1
         if (dval=255) and (sx<(sw-1)) then
            begin
            ac8:=srows8[sy][sx+1];
            if (tr=ac8) then dval:=fval;
            end;
         //y-1
         if (dval=255) and (sy>=1) then
            begin
            ac8:=srows8[sy-1][sx];
            if (tr=ac8) then dval:=fval;
            end;
         //y+1
         if (dval=255) and (sy<(sh-1)) then
            begin
            ac8:=srows8[sy+1][sx];
            if (tr=ac8) then dval:=fval;
            end;

         //.feather 2
         if (xfeather=2) and (dval=255) then
            begin
            //x-2
            if (dval=255) and (sx>=2) then
               begin
               ac8:=srows8[sy][sx-2];
               if (tr=ac8) then dval:=xfeather1;
               end;
            //x+2
            if (dval=255) and (sx<(sw-2)) then
               begin
               ac8:=srows8[sy][sx+2];
               if (tr=ac8) then dval:=xfeather1;
               end;
            //x-1,y-1
            if (dval=255) and (sx>=1) and (sy>=1) then
               begin
               ac8:=srows8[sy-1][sx-1];
               if (tr=ac8) then dval:=xfeather1;
               end;
            //x+1,y-1
            if (dval=255) and (sx<(sw-1)) and (sy>=1) then
               begin
               ac8:=srows8[sy-1][sx+1];
               if (tr=ac8) then dval:=xfeather1;
               end;
            //y-2
            if (dval=255) and (sy>=2) then
               begin
               ac8:=srows8[sy-2][sx];
               if (tr=ac8) then dval:=xfeather1;
               end;
            //x-1,y+1
            if (dval=255) and (sx>=1) and (sy<(sh-1)) then
               begin
               ac8:=srows8[sy+1][sx-1];
               if (tr=ac8) then dval:=xfeather1;
               end;
            //x+1,y+1
            if (dval=255) and (sx<(sw-1)) and (sy<(sh-1)) then
               begin
               ac8:=srows8[sy+1][sx+1];
               if (tr=ac8) then dval:=xfeather1;
               end;
            //y+2
            if (dval=255) and (sy<(sh-2)) then
               begin
               ac8:=srows8[sy+2][sx];
               if (tr=ac8) then dval:=xfeather1;
               end;
            end;//feather2
         end;//tr
      //set
      case dbits of
      32:dr32[sx].a:=dval;
      24:begin
         result:=true;
         goto skipend;
         end;
      8:dr8[sx]:=dval;
      end;//case
      end;//sx
      end//s8
   //.24 + 32/24/8
   else if (sbits=24) then
      begin
      for sx:=0 to (sw-1) do
      begin
      //init
      sc24:=sr24[sx];
      dval:=0;
      //get
      if (tr<>sc24.r) or (tg<>sc24.g) or (tb<>sc24.b) then
         begin
         //init
         dval:=255;
         if (xfeather=1) then fval:=xfeather1 else fval:=xfeather2;
         //stransframe
         if stransframe then
            begin
            //feather 1
            if ((sx-1)<=0) or ((sx+1)>=(sw-1)) then dval:=fval
            else if ((sy-1)<=0) or ((sy+1)>=(sh-1)) then dval:=fval;
            //feather 2
            if (dval=255) and (xfeather=2) then
               begin
               if ((sx-2)<=0) or ((sx+2)>=(sw-1)) then dval:=xfeather1
               else if ((sy-2)<=0) or ((sy+2)>=(sh-1)) then dval:=xfeather1;
               end;
            end;
         //x-1
         if (dval=255) and (sx>=1) then
            begin
            ac24:=srows24[sy][sx-1];
            if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=fval;
            end;
         //x+1
         if (dval=255) and (sx<(sw-1)) then
            begin
            ac24:=srows24[sy][sx+1];
            if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=fval;
            end;
         //y-1
         if (dval=255) and (sy>=1) then
            begin
            ac24:=srows24[sy-1][sx];
            if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=fval;
            end;
         //y+1
         if (dval=255) and (sy<(sh-1)) then
            begin
            ac24:=srows24[sy+1][sx];
            if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=fval;
            end;

         //.feather 2
         if (xfeather=2) and (dval=255) then
            begin
            //x-2
            if (dval=255) and (sx>=2) then
               begin
               ac24:=srows24[sy][sx-2];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=xfeather1;
               end;
            //x+2
            if (dval=255) and (sx<(sw-2)) then
               begin
               ac24:=srows24[sy][sx+2];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=xfeather1;
               end;
            //x-1,y-1
            if (dval=255) and (sx>=1) and (sy>=1) then
               begin
               ac24:=srows24[sy-1][sx-1];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=xfeather1;
               end;
            //x+1,y-1
            if (dval=255) and (sx<(sw-1)) and (sy>=1) then
               begin
               ac24:=srows24[sy-1][sx+1];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=xfeather1;
               end;
            //y-2
            if (dval=255) and (sy>=2) then
               begin
               ac24:=srows24[sy-2][sx];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=xfeather1;
               end;
            //x-1,y+1
            if (dval=255) and (sx>=1) and (sy<(sh-1)) then
               begin
               ac24:=srows24[sy+1][sx-1];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=xfeather1;
               end;
            //x+1,y+1
            if (dval=255) and (sx<(sw-1)) and (sy<(sh-1)) then
               begin
               ac24:=srows24[sy+1][sx+1];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=xfeather1;
               end;
            //y+2
            if (dval=255) and (sy<(sh-2)) then
               begin
               ac24:=srows24[sy+2][sx];
               if (tr=ac24.r) and (tg=ac24.g) and (tb=ac24.b) then dval:=xfeather1;
               end;
            end;//feather2
         end;//tr
      //set
      case dbits of
      32:dr32[sx].a:=dval;
      24:begin
         result:=true;
         goto skipend;
         end;
      8:dr8[sx]:=dval;
      end;//case
      end;//sx
      end//s24
   //.32 + 32/24/8
   else if (sbits=32) then
      begin
      for sx:=0 to (sw-1) do
      begin
      //init
      sc32:=sr32[sx];
      dval:=0;
      //get
      if (tr<>sc32.r) or (tg<>sc32.g) or (tb<>sc32.b) then
         begin
         //init
         dval:=255;
         if (xfeather=1) then fval:=xfeather1 else fval:=xfeather2;
         //stransframe
         if stransframe then
            begin
            //feather 1
            if ((sx-1)<=0) or ((sx+1)>=(sw-1)) then dval:=fval
            else if ((sy-1)<=0) or ((sy+1)>=(sh-1)) then dval:=fval;
            //feather 2
            if (dval=255) and (xfeather=2) then
               begin
               if ((sx-2)<=0) or ((sx+2)>=(sw-1)) then dval:=xfeather1
               else if ((sy-2)<=0) or ((sy+2)>=(sh-1)) then dval:=xfeather1;
               end;
            end;
         //x-1
         if (dval=255) and (sx>=1) then
            begin
            ac32:=srows32[sy][sx-1];
            if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=fval;
            end;
         //x+1
         if (dval=255) and (sx<(sw-1)) then
            begin
            ac32:=srows32[sy][sx+1];
            if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=fval;
            end;
         //y-1
         if (dval=255) and (sy>=1) then
            begin
            ac32:=srows32[sy-1][sx];
            if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=fval;
            end;
         //y+1
         if (dval=255) and (sy<(sh-1)) then
            begin
            ac32:=srows32[sy+1][sx];
            if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=fval;
            end;

         //.feather 2
         if (xfeather=2) and (dval=255) then
            begin
            //x-2
            if (dval=255) and (sx>=2) then
               begin
               ac32:=srows32[sy][sx-2];
               if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=xfeather1;
               end;
            //x+2
            if (dval=255) and (sx<(sw-2)) then
               begin
               ac32:=srows32[sy][sx+2];
               if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=xfeather1;
               end;
            //x-1,y-1
            if (dval=255) and (sx>=1) and (sy>=1) then
               begin
               ac32:=srows32[sy-1][sx-1];
               if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=xfeather1;
               end;
            //x+1,y-1
            if (dval=255) and (sx<(sw-1)) and (sy>=1) then
               begin
               ac32:=srows32[sy-1][sx+1];
               if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=xfeather1;
               end;
            //y-2
            if (dval=255) and (sy>=2) then
               begin
               ac32:=srows32[sy-2][sx];
               if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=xfeather1;
               end;
            //x-1,y+1
            if (dval=255) and (sx>=1) and (sy<(sh-1)) then
               begin
               ac32:=srows32[sy+1][sx-1];
               if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=xfeather1;
               end;
            //x+1,y+1
            if (dval=255) and (sx<(sw-1)) and (sy<(sh-1)) then
               begin
               ac32:=srows32[sy+1][sx+1];
               if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=xfeather1;
               end;
            //y+2
            if (dval=255) and (sy<(sh-2)) then
               begin
               ac32:=srows32[sy+2][sx];
               if (tr=ac32.r) and (tg=ac32.g) and (tb=ac32.b) then dval:=xfeather1;
               end;
            end;//feather2
         end;//tr
      //set
      case dbits of
      32:dr32[sx].a:=dval;
      24:begin
         result:=true;
         goto skipend;
         end;
      8:dr8[sx]:=dval;
      end;//case
      end;//sx
      end;//s32
   end;//begin
end;//case
end;//sy

//.blur
goto doblur;


//blur -------------------------------------------------------------------------
doblur:
//check
if (xfeather<=0) or (not xblur) then goto skipdone;//xfeather=0=sharp(no feather, hence nothing to blur)

//init
xinitrows832;

//get -> blur x2 for both "feather 1" and "feather 2" for best most consistent results - 12jan2021
xalternate:=true;
for i:=0 to frcmin32((xfeather div 5),1) do
begin
xalternate:=not xalternate;
for sy:=0 to (sh-1) do
begin
//.32
if (dbits=32) then
   begin
   for sxx:=0 to (sw-1) do
   begin
   if xalternate then sx:=sw-1-sxx else sx:=sxx;
   dv:=drows32[sy][sx].a;
   if (dv>=1) then//only adjust existing feather -> do not grow it outside of the scope of the image - 11jan2021
      begin
      dc:=1;
      //3x3
      //x-1
      if (sx>=1) then
         begin
         inc(dv,drows32[sy][sx-1].a);
         inc(dc);
         end;
      //x+1
      if (sx<(sw-1)) then
         begin
         inc(dv,drows32[sy][sx+1].a);
         inc(dc);
         end;
      //y-1
      if (sy>=1) then
         begin
         inc(dv,drows32[sy-1][sx].a);
         inc(dc);
         end;
      //y+1
      if (sy<(sh-1)) then
         begin
         inc(dv,drows32[sy+1][sx].a);
         inc(dc);
         end;
      //enlarge to a 5x5 - 20jan2021
      if (xfeather>=3) then
         begin
         //x-2
         if (sx>=2) then
            begin
            inc(dv,drows32[sy][sx-2].a);
            inc(dc);
            end;
         //x+2
         if (sx<(sw-2)) then
            begin
            inc(dv,drows32[sy][sx+2].a);
            inc(dc);
            end;
         //x-1,y-1
         if (sx>=1) and (sy>=1) then
            begin
            inc(dv,drows32[sy-1][sx-1].a);
            inc(dc);
            end;
         //x+1,y-1
         if (sx<(sw-1)) and (sy>=1) then
            begin
            inc(dv,drows32[sy-1][sx+1].a);
            inc(dc);
            end;
         //y-2
         if (sy>=2) then
            begin
            inc(dv,drows32[sy-2][sx].a);
            inc(dc);
            end;
         //x-1,y+1
         if (sx>=1) and (sy<(sh-1)) then
            begin
            inc(dv,drows32[sy+1][sx-1].a);
            inc(dc);
            end;
         //x+1,y+1
         if (sx<(sw-1)) and (sy<(sh-1)) then
            begin
            inc(dv,drows32[sy+1][sx+1].a);
            inc(dc);
            end;
         //y+2
         if (sy<(sh-2)) then
            begin
            inc(dv,drows32[sy+2][sx].a);
            inc(dc);
            end;
         end;//xfeather

      //set
      if (dc>=2) then
         begin
   //was: dv:=dv div dc;//Warning: This had been used but found to round down summed values e.g. 255*5 div 5 -> 254 and 253 etc where as using "round(x/y)" rounds up to 255 - 19jan2021
         dv:=round(dv/dc);
         drows32[sy][sx].a:=byte(dv);
         end;
      end;
   end;//sx
   end
//.24
else if (dbits=24) then goto skipdone
//.8
else if (dbits=8) then
   begin
   for sxx:=0 to (sw-1) do
   begin
   if xalternate then sx:=sw-1-sxx else sx:=sxx;
   dv:=drows8[sy][sx];
   if (dv>=1) then//only adjust existing feather -> do not grow it outside of the scope of the image - 11jan2021
      begin
      dc:=1;
      //3x3
      //x-1
      if (sx>=1) then
         begin
         inc(dv,drows8[sy][sx-1]);
         inc(dc);
         end;
      //x+1
      if (sx<(sw-1)) then
         begin
         inc(dv,drows8[sy][sx+1]);
         inc(dc);
         end;
      //y-1
      if (sy>=1) then
         begin
         inc(dv,drows8[sy-1][sx]);
         inc(dc);
         end;
      //y+1
      if (sy<(sh-1)) then
         begin
         inc(dv,drows8[sy+1][sx]);
         inc(dc);
         end;
      //enlarge to a 5x5 - 20jan2021
      if (xfeather>=3) then
         begin
         //x-2
         if (sx>=2) then
            begin
            inc(dv,drows8[sy][sx-2]);
            inc(dc);
            end;
         //x+2
         if (sx<(sw-2)) then
            begin
            inc(dv,drows8[sy][sx+2]);
            inc(dc);
            end;
         //x-1,y-1
         if (sx>=1) and (sy>=1) then
            begin
            inc(dv,drows8[sy-1][sx-1]);
            inc(dc);
            end;
         //x+1,y-1
         if (sx<(sw-1)) and (sy>=1) then
            begin
            inc(dv,drows8[sy-1][sx+1]);
            inc(dc);
            end;
         //y-2
         if (sy>=2) then
            begin
            inc(dv,drows8[sy-2][sx]);
            inc(dc);
            end;
         //x-1,y+1
         if (sx>=1) and (sy<(sh-1)) then
            begin
            inc(dv,drows8[sy+1][sx-1]);
            inc(dc);
            end;
         //x+1,y+1
         if (sx<(sw-1)) and (sy<(sh-1)) then
            begin
            inc(dv,drows8[sy+1][sx+1]);
            inc(dc);
            end;
         //y+2
         if (sy<(sh-2)) then
            begin
            inc(dv,drows8[sy+2][sx]);
            inc(dc);
            end;
         end;//xfeather

      //set
      if (dc>=2) then
         begin
   //was: dv:=dv div dc;//Warning: This had been used but found to round down summed values e.g. 255*5 div 5 -> 254 and 253 etc where as using "round(x/y)" rounds up to 255 - 19jan2021
         dv:=round(dv/dc);
         drows8[sy][sx]:=byte(dv);
         end;
      end;
   end;//sx
   end;
end;//sy
end;//i

//successful
skipdone:
result:=true;
skipend:
except;end;
end;

function mask__todata(s:tobject;d:pobject):boolean;
begin
result:=mask__todata2(s,d,clnone);
end;

function mask__todata2(s:tobject;d:pobject;stranscol:longint):boolean;
label//s=image handler e.g. tbasicimage, trawimage or tbitamp and d=string handler e.g. tstr8 or tstr9
     //extracts 8bit alpha from s and copies it to d (string handler)
     //note: if (strancols<>clnone) then adds transparency to mask as it copies it over
   skipend;
var
   dpos,tr,tg,tb,sx,sy,sw,sh,sbits:longint;
   sr8:pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc32:tcolor32;
   sc24:tcolor24;
   da:byte;
   dfast:tstr8;//optional pointer
begin
//defaults
result:=false;
da:=0;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
if not str__setlen(d,sw*sh)      then goto skipend;
if str__is8(d)                   then dfast:=(d^ as tstr8) else dfast:=nil;
tr:=-1;
tg:=-1;
tb:=-1;
stranscol:=mistranscol(s,stranscol,stranscol<>clnone);
if (stranscol<>clnone) then
   begin
   sc24:=int__c24(stranscol);
   tr:=sc24.r;
   tg:=sc24.g;
   tb:=sc24.b;
   end;

//get
//.dy
dpos:=0;
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc32:=sr32[sx];
   if (tr=sc32.r) and (tg=sc32.g) and (tb=sc32.b) then da:=0
   else                                                da:=sc32.a;

   if (dfast<>nil) then dfast.pbytes[dpos]:=da else str__setbytes0(d,dpos,da);
   inc(dpos);
   end;//sx
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc24:=sr24[sx];
   if (tr=sc24.r) and (tg=sc24.g) and (tb=sc24.b) then da:=0
   else                                                da:=255;

   if (dfast<>nil) then dfast.pbytes[dpos]:=da else str__setbytes0(d,dpos,da);
   inc(dpos);
   end;//sx
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   if (dfast<>nil) then dfast.pbytes[dpos]:=da else str__setbytes0(d,dpos,255);
   inc(dpos);
   end;//sx
   end;
end;//dy
//successful
result:=true;
skipend:
except;end;
try
str__uaf(d);
except;end;
end;

function mask__fromdata(s:tobject;d:pobject):boolean;
begin
result:=mask__fromdata2(s,d,0,false);
end;

function mask__fromdata2(s:tobject;d:pobject;donshortfall:longint;dforcetoimage:boolean):boolean;
label//s=image handler e.g. tbasicimage, trawimage or tbitamp and d=string handler e.g. tstr8 or tstr9
     //reads 8bit mask (continous stream of 8bit bytes from left to right and top to bottom order)
     //donshortfall: 0..255=use this as mask value if "d" is short on data, or "<0"=stops and task fails
   skipend;
var
   dlen,dpos,sx,sy,sw,sh,sbits:longint;
   sr8:pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   c24:tcolor24;
   dshortfall255:byte;
   dfast:tstr8;//optional pointer
begin
//defaults
result:=false;

try
//check
if not str__lock(d)              then goto skipend;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//init
dlen            :=str__len(d);
dshortfall255   :=frcrange32(donshortfall,0,255);

if (dlen<=0) and (donshortfall<0)then goto skipend;
if str__is8(d)                   then dfast:=(d^ as tstr8) else dfast:=nil;

//.can only apply a mask to a 32bit image
if (sbits<>32) and (not dforcetoimage) then
   begin
   result:=true;
   goto skipend;
   end;

//get
//.dy
dpos:=0;
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin

   case (dpos<dlen) of
   true:if (dfast<>nil) then sr32[sx].a:=dfast.pbytes[dpos] else sr32[sx].a:=str__bytes0(d,dpos);
   else sr32[sx].a:=donshortfall;
   end;

   inc(dpos);
   end;//sx
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin

   case (dpos<dlen) of
   true:if (dfast<>nil) then c24.r:=dfast.pbytes[dpos] else c24.r:=str__bytes0(d,dpos);
   else c24.r:=donshortfall;
   end;

   c24.g:=c24.r;
   c24.b:=c24.r;
   sr24[sx]:=c24;

   inc(dpos);
   end;//sx
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin

   case (dpos<dlen) of
   true:if (dfast<>nil) then sr8[sx]:=dfast.pbytes[dpos] else sr8[sx]:=str__bytes0(d,dpos);
   else sr8[sx]:=donshortfall;
   end;

   inc(dpos);
   end;//sx
   end;
end;//dy
//successful
result:=true;
skipend:
except;end;
//free
str__uaf(d);
end;


//graphics procs ---------------------------------------------------------------
function low__cornerMaxwidth:longint;//used by some patch systems to work around corner restrictions such as "statusbar.cellpert.round/square" - 07ul2021
begin
result:=3;
end;

function low__cornersolid(xdynamicCorners:boolean;var a:twinrect;amin,ay,xmin,xmax,xroundstyle:longint;xround:boolean;var lx,rx:longint):boolean;//29mar2021
var
   ax,ax2:longint;
begin
//defaults
result:=true;

try
ax :=a.left;
ax2:=a.right;
lx :=xmin;
rx :=xmax;

//square corner ----------------------------------------------------------------
if (not xround) or ((amin<3) and xdynamicCorners) or (xmax<xmin) then exit;//check

//rounded corner ---------------------------------------------------------------
//17mar2021
if (xroundstyle=corSlight) or (xroundstyle=corSlight2) or (xroundstyle=corToSquare) then amin:=3//slight corner
else if not xdynamicCorners then amin:=11;//29mar2021

case amin of
3..10:begin
   if (ay=a.top) or (ay=a.bottom) then
      begin
      lx:=ax +1;
      rx:=ax2-1;
      end;
   end;//begin
11..max32:begin//multi-pixel curved corner
   if (ay=a.top) or (ay=a.bottom) then
      begin
      lx:=ax +3;
      rx:=ax2-3;
      end
   else if (ay=(a.top+1)) or (ay=(a.bottom-1)) then
      begin
      lx:=ax +2;
      rx:=ax2-2;
      end
   else if (ay=(a.top+2)) or (ay=(a.bottom-2)) or (ay=(a.top+3)) or (ay=(a.bottom-3)) or (ay=(a.top+4)) or (ay=(a.bottom-4)) then
      begin
      lx:=ax +1;
      rx:=ax2-1;
      end;
   end;//begin
end;//case
//detect usuability
result:=(lx<=rx);
//enforce range -> must do this else fatal error can occur when a window is dragged offscreen - 29mar2021
lx:=frcrange32(lx,xmin,xmax);
rx:=frcrange32(rx,xmin,xmax);
except;end;
end;

function misscreenresin248K:longint;//returns 2(K), 4(K) or 8(K)
var
   sw,sh:longint;
begin
//defaults
result:=2;

try
//init
sw:=monitors__screenwidth_auto;
sh:=monitors__screenheight_auto;
//get
if      (sw>=7680) and (sh>=4320) then result:=8
else if (sw>=3840) and (sh>=2160) then result:=4;
except;end;
end;

function misformat(xdata:tstr8;var xformat:string;var xbase64:boolean):boolean;
begin
result:=mis__format(@xdata,xformat,xbase64);
end;


//standardised 32bit graphic procs ---------------------------------------------
//26jul2024: created
function mis__format(xdata:pobject;var xformat:string;var xbase64:boolean):boolean;//26jul2024: created to handle tstr8 and tstr9
label
   skipend,redo;
var
   a:tobject;
   str1:string;
   xmustfree,xonce:boolean;

   function sm(ext:string):boolean;
   begin
   result:=strmatch(str1,ext);
   end;
begin
//defaults
result:=false;
xmustfree:=false;
xformat:='';
xbase64:=false;
a:=nil;

try
//lock
if not str__lock(xdata) then goto skipend;

//length check
a:=xdata^;//a pointer at this stage
if (str__len(@a)<=0) then goto skipend;

//init
xonce:=true;
redo:
//get
if io__anyformat(@a,str1) then
   begin
   if (str1='B64') then
      begin
      if xonce then
         begin
         xonce:=false;
         xbase64:=true;
         //.duplicate "a" using same string handler
         xmustfree:=true;
         a:=str__newsametype(xdata);
         str__fromb642(xdata,@a,1);
         goto redo;
         end;
      end
   else
      begin
      //get
      xformat:=str1;

      //detect known format ----------------------------------------------------
      if not result then result:=sm('png') or sm('tea') or sm('img32') or sm('tga') or sm('ppm') or sm('pgm') or sm('pbm') or sm('pnm') or sm('bmp') or sm('dib');

      {$ifdef jpeg}
      if not result then result:=sm('jpg') or sm('tj32');
      {$endif}

      if not result then result:=sm('gif');

      if not result then result:=sm('ico') or sm('cur') or sm('ani');
      end;
   end;

skipend:
except;end;
try
if xmustfree and str__ok(@a) then str__free(@a);
str__uaf(xdata);
except;end;
end;

function mis__clear(s:tobject):boolean;
begin
result:=misv(s) and missize(s,1,1);
if result then misaiclear(misai(s)^);
end;

function mis__copy(s,d:tobject):boolean;

   function xaicopy(s,d:tobject):boolean;
   begin
   result:=misv(s) and misv(d);
   if result and (not misaicopy(s,d)) then misaiclear(misai(d)^);
   end;
begin
result:=missize(d,misw(s),mish(s)) and miscopyarea322(maxarea,0,0,misw(s),mish(s),area__make(0,0,misw(s)-1,mish(s)-1),d,s,0,0) and xaicopy(s,d);
end;

function mis__tofile(s:tobject;dfilename,dformat:string;var e:string):boolean;//09jul2021
begin
result:=mis__tofile2(s,dfilename,dformat,'',e);
end;

function mis__tofile2(s:tobject;dfilename,dformat,daction:string;var e:string):boolean;//09jul2021
begin
result:=mis__tofile3(s,dfilename,dformat,daction,e);
end;

function mis__tofile3(s:tobject;dfilename,dformat:string;var daction,e:string):boolean;//26dec2024, 09jul2021
const
   dsizeThreshold=10000000;//40Mb at 32bit
var
   d:tobject;
begin
//defaults
result:=false;

try
daction:=ia__spreadd(daction,ia_info_filename,[dfilename]);
if ia__found(daction,ia_usestr9) or (mult64(misw(s),mish(s))>dsizeThreshold) then d:=str__new9 else d:=str__new8;
result:=mis__todata3(s,@d,dformat,daction,e) and io__tofile(dfilename,@d,e);
except;end;
try;str__free(@d);except;end;
end;

function mis__fromfile(s:tobject;sfilename:string;var e:string):boolean;//09jul2021
begin
result:=mis__fromfile2(s,sfilename,false,e);
end;

function mis__fromfile2(s:tobject;sfilename:string;sbuffer:boolean;var e:string):boolean;//09jul2021
var
   a:tobject;
begin
//defaults
result:=false;
e:=gecTaskfailed;
a:=nil;
//get
try
a:=str__new9;
result:=io__fromfile64(sfilename,@a,e) and mis__fromdata2(s,@a,sbuffer,e);
except;end;
try
str__free(@a);
except;end;
end;

function mis__todata(s:tobject;sdata:pobject;dformat:string;var e:string):boolean;//25jul2024
begin
result:=mis__todata2(s,sdata,dformat,'',e);
end;

function mis__todata2(s:tobject;sdata:pobject;dformat,daction:string;var e:string):boolean;//25jul2024
begin
result:=mis__todata3(s,sdata,dformat,daction,e);
end;

function mis__todata3(s:tobject;sdata:pobject;dformat:string;var daction,e:string):boolean;//19feb2025, 14dec2024: ia_nonAnimatedFormatsSaveImageStrip, 25jul2024
label
   skipend;
var
   sa:twinrect;
   d:tbasicimage;

   function m(x:string):boolean;
   begin
   result:=strmatch(dformat,x);
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;
d:=nil;


try
//init
dformat:=io__extractfileext2(dformat,dformat,true);//accepts filename and extension only - 22nov2024

//animated image -> image strip OR single cell
if (misai(s).count>=2) and (not ia__found(daction,ia_nonAnimatedFormatsSaveImageStrip)) then
   begin
   if (not m(feimg32)) and (not m(fetj32)) and (not m(feani)) and (not m(fegif)) then
      begin
      d:=misimg32(1,1);
      if not miscell(s,0,sa) then goto skipend;
      if not missize(d,sa.right-sa.left+1,sa.bottom-sa.top+1) then goto skipend;
      if not miscopyarea32(0,0,misw(d),mish(d),sa,d,s) then goto skipend;
      if not misaicopy(s,d) then goto skipend;
      misai(d).count:=1;
      s:=d;
      end;
   end;


//get
if      m(feimg32)      then result:=img32__todata3(s,sdata,daction,e)
else if m(fetj32)       then result:=tj32__todata3(s,sdata,daction,e)
else if m(fejpg)        then result:=jpg__todata3(s,sdata,daction,e)
else if m(fejif)        then result:=jpg__todata3(s,sdata,daction,e)
else if m(fejpeg)       then result:=jpg__todata3(s,sdata,daction,e)
else if m(feani)        then result:=ani__todata2(s,sdata,'',e)
else if m(fecur)        then result:=cur__todata2(s,sdata,daction,e)
else if m(feico)        then result:=ico__todata3(s,sdata,daction,e)//27may2025, 19feb2025
else if m(febmp)        then result:=bmp__todata3(s,sdata,daction,e)
else if m(fedib)        then result:=bmp__todata3(s,sdata,daction,e)//14may2025: file based DIBs are BMPs, only memory DIBs are true DIBs
else if m(fegif)        then result:=gif__todata2(s,sdata,daction,e)//06aug2024
else if m(fetga)        then result:=tga__todata3(s,sdata,daction,e)//20dec2024
else if m(fetea)        then result:=tea__todata2(s,misai(s).transparent,false,0,0,sdata,e)//01may2025
else if m(fepng)        then result:=png__todata3(s,sdata,daction,e)//06may2025, 19nov2024
else if m(feppm)        then result:=ppm__todata3(s,sdata,daction,e)//02jan2025
else if m(fepgm)        then result:=pgm__todata3(s,sdata,daction,e)//02jan2025
else if m(fepbm)        then result:=pbm__todata3(s,sdata,daction,e)//02jan2025
else if m(fepnm)        then result:=pnm__todata3(s,sdata,daction,e)//02jan2025
else if m(fexbm)        then result:=xbm__todata3(s,sdata,daction,e)//02jan2025

else                         result:=false;//str__is8(sdata) and mistodata(s,sdata^ as tstr8,dformat,e);

skipend:
except;end;
//free
freeobj(@d);
end;

function mis__browsersupports(dformat:string):boolean;
begin
result:=strmatch('png',dformat) or strmatch('jpg',dformat) or strmatch('gif',dformat) or strmatch('bmp',dformat) or strmatch('ico',dformat);
end;

function mis__fixemptymask(s:tobject):boolean;//22feb2025
begin
result:=true;//pass-thru
if (misb(s)=32) and mask__empty(s) then mask__setval(s,255);
end;

procedure mis__nocells(s:tobject);
begin
misai(s).cellwidth  :=misw(s);
misai(s).cellheight :=mish(s);
misai(s).delay      :=0;//16nov2024
misai(s).count      :=1;
end;

procedure mis__calccells(s:tobject);
begin
misai(s).delay      :=frcmin32(misai(s).delay,0);//ms
misai(s).count      :=frcmin32(misai(s).count,1);
misai(s).cellwidth  :=frcmin32(misw(s) div misai(s).count,1);
misai(s).cellheight :=mish(s);
end;

procedure mis__calccells2(s:tobject;var xdelay,xcount,xcellwidth,xcellheight:longint);
begin
xdelay      :=frcmin32(misai(s).delay,0);//ms
xcount      :=frcmin32(misai(s).count,1);
xcellwidth  :=frcmin32(misw(s) div xcount,1);
xcellheight :=mish(s);
end;

function mis__fromadata(s:tobject;const xdata:array of byte;var e:string):boolean;//05feb2025
var
   b:tstr8;
begin
result:=false;
b:=nil;
e:=gecTaskfailed;

try
b:=str__new8;
b.aadd(xdata);
result:=mis__fromdata(s,@b,e);
except;end;
str__free(@b);
end;

function mis__fromdata(s:tobject;sdata:pobject;var e:string):boolean;//25jul2024
begin
result:=mis__fromdata2(s,sdata,false,e);
end;

function mis__fromdata2(s:tobject;sdata:pobject;sbuffer:boolean;var e:string):boolean;//06jun2025, 25jul2024
label
   skipend;
var
   d,ddataobj:tobject;
   ddata:pobject;
   dbuffered:boolean;
   sbits,sw,sh:longint;
   sformat:string;
   sbase64:boolean;
   int1,int2:longint;

   function startbuffer:boolean;
   begin
   //get
   if sbuffer then
      begin
      dbuffered:=true;
      d:=misraw(sbits,sw,sh);
      result:=mis__copy(s,d);
      end
   else result:=true;

   //static image by default
   mis__nocells(d);
   end;

   function stopbuffer:boolean;
   begin
   //get
   if dbuffered then
      begin
      result:=mis__copy(d,s);
      dbuffered:=false;
      freeobj(@d);
      end
   else result:=true;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;
d:=s;
ddataobj:=nil;
ddata:=@ddataobj;
dbuffered:=false;

try
//check
if not str__lock(sdata)          then goto skipend else ddata:=sdata;
if not misok82432(s,sbits,sw,sh) then goto skipend;

//detect data format #1
if not mis__format(sdata,sformat,sbase64) then
   begin
   //detect data format #2 -> unzip data and run 2nd format detection - 26jul2024
   case strmatch(sformat,'zip') of
   true:begin
      ddataobj:=str__newsametype(sdata);//same type
      ddata:=@ddataobj;
      if (not str__add(ddata,sdata)) or (not low__decompress(ddata)) then
         begin
         e:=gecDatacorrupt;
         goto skipend;
         end;
      //failed again -> quit
      if not mis__format(ddata,sformat,sbase64) then
         begin
         e:=gecUnknownformat;
         goto skipend;
         end;
      end;
   else begin
      e:=gecUnknownformat;
      goto skipend;
      end;
   end;//case
   end;

//double buffer to protect "s" from corruption -> we overwrite "s" only when we have good data
if sbuffer then
   begin
   d:=misraw(sbits,sw,sh);
   if not miscopy(s,d) then goto skipend;
   end;

//get
if (sformat='PNG') then
   begin
   if not startbuffer then goto skipend;
   if not png__fromdata(d,ddata,e) then goto skipend;
   if not stopbuffer then goto skipend;
   end
else if (sformat='ICO') then
   begin
   if not startbuffer then goto skipend;
   if (not ico__fromdata(d,ddata,e)) and (not low__fromico322(d,ddata,0,true,e)) then goto skipend;
   if not stopbuffer then goto skipend;
   end
else if (sformat='CUR') then
   begin
   if not startbuffer then goto skipend;
   if (not cur__fromdata(d,ddata,e)) and (not low__fromico322(d,ddata,0,true,e)) then goto skipend;
   if not stopbuffer then goto skipend;
   end
else if (sformat='ANI') then
   begin
   //update this to sub-proc handling -> ico__fromdata()
   if not startbuffer then goto skipend;
   if not low__fromani322(d,ddata,0,true,e) then goto skipend;
   if not stopbuffer then goto skipend;
   end
else if (sformat='TEA') then
   begin
   if not startbuffer then goto skipend;
   if not tea__fromdata32(d,ddata,int1,int2) then goto skipend;
   if not stopbuffer then goto skipend;
   end
else if (sformat='IMG32') then
   begin
   if not startbuffer then goto skipend;
   if not img32__fromdata(d,ddata,e) then goto skipend;
   if not stopbuffer then goto skipend;
   end
else if (sformat='BMP') then//does not require a buffer - 25jul2024
   begin
   if not bmp__fromdata(d,ddata,e) then goto skipend;
   end
else if (sformat='DIB') then//does not require a buffer - 25jul2024
   begin
   if not dib__fromdata(d,ddata,e) then goto skipend;
   end
else if (sformat='TJ32') then
   begin
   if not startbuffer then goto skipend;
   if not tj32__fromdata(d,ddata,e) then goto skipend;
   if not stopbuffer then goto skipend;
   end
else if (sformat='JPG') then//requires both BMP and JPEG support
   begin
   if not jpg__fromdata(d,ddata,e) then goto skipend;
   end
else if (sformat='GIF') then
   begin
   if not startbuffer then goto skipend;
   if not gif__fromdata(d,ddata,e) then goto skipend;//06aug2024
   if not stopbuffer then goto skipend;
   end
else if (sformat='TGA') then
   begin
   if not tga__fromdata(d,ddata,e) then goto skipend;
   end
else if (sformat='PPM') then
   begin
   if not ppm__fromdata(d,ddata,e) then goto skipend;
   end
else if (sformat='PGM') then
   begin
   if not pgm__fromdata(d,ddata,e) then goto skipend;
   end
else if (sformat='PBM') then
   begin
   if not pbm__fromdata(d,ddata,e) then goto skipend;
   end
else if (sformat='PNM') then
   begin
   if not pnm__fromdata(d,ddata,e) then goto skipend;
   end
else
   begin
   goto skipend;
   end;

//successful
result:=true;
skipend:
except;end;
try
//cellwidth and cellheight -> default to 0x0 when no "ai" present, such with jpeg/bitmap - 26jul2024
if mishasai(s) and ((misai(s).cellwidth=0) or (misai(s).cellheight=0)) then
   begin
   mis__nocells(s);
   end;

//free double buffers
if (ddata<>nil) and (ddata<>sdata) then str__free(ddata);
if (d<>nil)     and (d<>s)         then freeobj(@d);

//last
str__uaf(sdata);
except;end;
end;

function mis__fromarray(s:tobject;const xdata:array of byte;var e:string):boolean;//01may2025, 02jun2020
var
   b:tstr8;
begin
result:=false;
b     :=nil;
e     :=gecTaskfailed;

try
b:=str__new8;
b.aadd(xdata);
result:=mis__fromdata(s,@b,e);
except;end;
//free
str__free(@b);
end;

function miscls(s:tobject;xcolor:longint):boolean;
begin
result:=misclsarea2(s,maxarea,xcolor,xcolor);
end;

function misclsarea(s:tobject;sarea:twinrect;xcolor:longint):boolean;
begin
result:=misclsarea3(s,sarea,xcolor,xcolor,clnone,clnone);
end;

function misclsarea2(s:tobject;sarea:twinrect;xcolor,xcolor2:longint):boolean;
begin
result:=misclsarea3(s,sarea,xcolor,xcolor2,clnone,clnone);
end;

function misclsarea3(s:tobject;sarea:twinrect;xcolor,xcolor2,xalpha,xalpha2:longint):boolean;
label
   skipdone,skipend;
var
  sr8 :pcolorrow8;
  sr16:pcolorrow16;
  sr24:pcolorrow24;
  sr32:pcolorrow32;
  sc8 :tcolor8;
  sc16:tcolor16;
  sc24,sc,sc2:tcolor24;
  sc32:tcolor32;
  dx,dy,sbits,sw,sh:longint;
  xpert:extended;
  xcolorok,xalphaok,shasai:boolean;
  da:twinrect;
  xa:byte;
begin
//defaults
result:=false;
sc8:=0;
sc16:=0;
xa:=0;

try
//check
if not misinfo8162432(s,sbits,sw,sh,shasai) then exit;

//range
if (sarea.right<sarea.left) or (sarea.bottom<sarea.top) or (sarea.bottom<0) or (sarea.top>=sh) or (sarea.right<0) or (sarea.left>=sw) then
   begin
   result:=true;
   exit;
   end;
da.left:=frcrange32(sarea.left,0,sw-1);
da.right:=frcrange32(sarea.right,0,sw-1);
da.top:=frcrange32(sarea.top,0,sh-1);
da.bottom:=frcrange32(sarea.bottom,0,sh-1);

//init
//.color
if (xcolor <>clnone) and (xcolor2=clnone) then xcolor2:=xcolor;
if (xcolor2<>clnone) and (xcolor =clnone) then xcolor:=xcolor2;
xcolorok:=(xcolor<>clnone) and (xcolor2<>clnone);
if xcolorok then
   begin
   sc:=int__c24(xcolor);
   sc2:=int__c24(xcolor2);
   end;
//.alpha
if (xalpha <>clnone) and (xalpha2=clnone) then xalpha2:=xalpha;
if (xalpha2<>clnone) and (xalpha =clnone) then xalpha:=xalpha2;
xalphaok:=(xalpha<>clnone) and (xalpha2<>clnone);
if xalphaok then
   begin
   xalpha:=frcrange32(xalpha,0,255);
   xalpha2:=frcrange32(xalpha2,0,255);
   end;
//check
if (not xcolorok) and (not xalphaok) then goto skipdone;
//get
for dy:=da.top to da.bottom do
begin
//.color gradient - optional
if xcolorok and ((xcolor<>xcolor2) or (dy=da.top)) then
   begin
   //.make color
   if (xcolor=xcolor2) then
      begin
      sc24.r:=sc.r;
      sc24.g:=sc.g;
      sc24.b:=sc.b;
      end
   else
      begin
      xpert:=(dy-da.top+1)/(da.bottom-da.top+1);
      sc24.r:=round( (sc.r*(1-xpert))+(sc2.r*xpert) );
      sc24.g:=round( (sc.g*(1-xpert))+(sc2.g*xpert) );
      sc24.b:=round( (sc.b*(1-xpert))+(sc2.b*xpert) );
      end;
   //.more bits
   case sbits of
   8:begin
      sc8:=sc24.r;
      if (sc24.g>sc8) then sc8:=sc24.g;
      if (sc24.b>sc8) then sc8:=sc24.b;
      end;
   16:sc16:=(sc24.r div 8) + (sc24.g div 8)*32 + (sc24.b div 8)*1024;
   32:begin
      sc32.r:=sc24.r;
      sc32.g:=sc24.g;
      sc32.b:=sc24.b;
      sc32.a:=255;//fully solid
      end;
   end;//case
   end;

//.alpha gradient - optional
//was: if xalphaok and (xalpha<>xalpha2) or (dy=da.top) then
if xalphaok and ((xalpha<>xalpha2) or (dy=da.top)) then//fixed error - 22apr2021
   begin
   //.make alpha
   if (xalpha=xalpha2) then
      begin
      xa:=xalpha;
      end
   else
      begin
      xpert:=(dy-da.top+1)/(da.bottom-da.top+1);
      xa:=byte(frcrange32(round( (xalpha*(1-xpert))+(xalpha2*xpert) ),0,255));
      end;
   end;
//.scan
if not misscan2432(s,dy,sr24,sr32) then goto skipend;

//.pixels
case sbits of
8 :begin
   if not xcolorok then goto skipdone;
   sr8:=pointer(sr24);
   for dx:=da.left to da.right do sr8[dx]:=sc8;
   end;
16:begin
   if not xcolorok then goto skipdone;
   sr16:=pointer(sr24);
   for dx:=da.left to da.right do sr16[dx]:=sc16;
   end;
24:begin
   if not xcolorok then goto skipdone;
   for dx:=da.left to da.right do sr24[dx]:=sc24;
   end;
32:begin
   //.c + a
   if xcolorok and xalphaok then
      begin
      sc32.a:=xa;
      for dx:=da.left to da.right do sr32[dx]:=sc32;
      end
   //.c only
   else if xcolorok then
      begin
      for dx:=da.left to da.right do sr32[dx]:=sc32;
      end
   //.a only
   else if xalphaok then
      begin
      for dx:=da.left to da.right do sr32[dx].a:=xa;
      end;
   end;
end;//case
end;//dy
//successful
skipdone:
result:=true;
skipend:
except;end;
end;

function mis__nowhite_noblack(s:tobject):boolean;//23mar2025
label
   skipend;
var
   sr8 :pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   c8 :tcolor8;
   c24,c24_1,c24_254:tcolor24;
   c32,c32_1,c32_254:tcolor32;
   sx,sy,sbits,sw,sh:longint;
   shasai:boolean;
begin
//defaults
result:=false;

//check
if not misinfo82432(s,sbits,sw,sh,shasai) then exit;

try
//init
c24_1.r:=1;
c24_1.g:=1;
c24_1.b:=1;

c24_254.r:=254;
c24_254.g:=254;
c24_254.b:=254;

c32_1.r:=1;
c32_1.g:=1;
c32_1.b:=1;
c32_1.a:=0;

c32_254.r:=254;
c32_254.g:=254;
c32_254.b:=254;
c32_254.a:=0;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

case sbits of
8 :begin
   for sx:=0 to (sw-1) do
   begin
   c8:=sr8[sx];
   if      (c8=0)   then sr8[sx]:=1
   else if (c8=255) then sr8[sx]:=254;
   end;//sx
   end;
24:begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   if      (c24.r=0)   and (c24.g=0)   and (c24.b=0)   then sr24[sx]:=c24_1
   else if (c24.r=255) and (c24.g=255) and (c24.b=255) then sr24[sx]:=c24_254;
   end;//sx
   end;
32:begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   if (c32.r=0) and (c32.g=0) and (c32.b=0) then
      begin
      c32_1.a   :=c32.a;
      sr32[sx]  :=c32_1;
      end
   else if (c32.r=255) and (c32.g=255) and (c32.b=255) then
      begin
      c32_254.a :=c32.a;
      sr32[sx]  :=c32_254;
      end;
   end;//sx
   end;
end;//case
end;//dy

//successful
result:=true;
skipend:
except;end;
end;

function mis__canarea(s:tobject;sa:twinrect;var sarea:twinrect):boolean;
var
   sw,sh:longint;
begin
result:=false;

sarea:=sa;
sw:=misw(s);
sh:=mish(s);

if (sa.right<sa.left) or (sa.bottom<sa.top) or (sa.bottom<0) or (sa.top>=sh) or (sa.right<0) or (sa.left>=sw) then
   begin
   //can't work with area
   end
else
   begin
   //range area to image limits
   sarea.left   :=frcrange32(sa.left  ,0,sw-1);
   sarea.right  :=frcrange32(sa.right ,0,sw-1);
   sarea.top    :=frcrange32(sa.top   ,0,sh-1);
   sarea.bottom :=frcrange32(sa.bottom,0,sh-1);
   result:=true;
   end;
end;

function mis__hasai(s:tobject):boolean;
begin
result:=false;

if zznil(s,2077)           then exit
else if (s is tbasicimage) then result:=true
else if (s is trawimage)   then result:=true
else if (s is twinbmp)     then result:=true;
end;

function mis__ai(s:tobject):panimationinformation;
begin
result:=@system_default_ai;//always return a pointer to a valid structure

if zznil(s,2078)           then misaiclear(system_default_ai)
else if (s is tbasicimage) then result:=@(s as tbasicimage).ai
else if (s is trawimage)   then result:=@(s as trawimage).ai
else if (s is twinbmp)     then result:=@(s as twinbmp).ai
else                            misaiclear(system_default_ai);
end;

function mis__onecell(s:tobject):boolean;//06aug2024, 26apr2022
label
   skipend;
var
   a:tbasicimage;
   xdelay,xcount,xcellwidth,xcellheight:longint;
begin
//defaults
result:=false;
a:=nil;

//check
if not mis__hasai(s) then
   begin
   result:=true;
   exit;
   end;

try
//info -> get most up-to-data animation information
mis__calccells2(s,xdelay,xcount,xcellwidth,xcellheight);

mis__ai(s).delay      :=xdelay;
mis__ai(s).count      :=xcount;
mis__ai(s).cellwidth  :=xcellwidth;
mis__ai(s).cellheight :=xcellheight;

if (xcount<=1) then
   begin
   result:=true;
   goto skipend;
   end;

//get
case mis__resizable(s) of
true:if not missize(s,xcellwidth,xcellheight) then goto skipend;
else begin//image can't be resized without data loss so we need to buffer off a copy and then write it back

   //create "a" using same bit depth as "s" -> 8/24/32
   a:=misimg(misb(s),xcellwidth,xcellheight);

   //copy s.cell(0) to "a"
   if not miscopyarea32(0,0,xcellwidth,xcellheight,area__make(0,0,xcellwidth-1,xcellheight-1),a,s) then goto skipend;

   //resize "s" to one cell dimensions
   if not missize(s,xcellwidth,xcellheight) then goto skipend;

   //copy "a" back to "s"
   if not miscopyarea32(0,0,xcellwidth,xcellheight,area__make(0,0,xcellwidth-1,xcellheight-1),s,a) then goto skipend;
   end;
end;

//update cell count to 1
mis__ai(s).count:=1;

//successful
result:=true;
skipend:
except;end;
//free
freeobj(@a);
end;

function mis__resizable(s:tobject):boolean;
begin
result:=(s<>nil) and (s is trawimage);
end;

function mis__retaindataonresize(s:tobject):boolean;//26jul2024: same as "mis__resizable()"
begin
result:=mis__resizable(s);
end;

function mis__rowsize4(ximagewidth,xbitsPERpixel:longint):longint;//rounds to nearest 4 bytes - 27may2025
begin
//calc
result:=(ximagewidth*xbitsPERpixel) div 8;
if ((result*8)<>(ximagewidth*xbitsPERpixel)) then inc(result);

//nearest 4 bytes
result:=int__round4(result);
end;

function mis__cls(s:tobject;r,g,b,a:byte):boolean;//04aug2024
begin
result:=mis__cls2(s,misarea(s),r,g,b,a);
end;

function mis__cls3(s:tobject;sa:twinrect;scolor32:tcolor32):boolean;//29jan2025
begin
result:=mis__cls2(s,sa,scolor32.r,scolor32.g,scolor32.b,scolor32.a);
end;

function mis__cls2(s:tobject;sa:twinrect;r,g,b,a:byte):boolean;//04aug2024
label
   skipdone,skipend;
var
  sr8 :pcolorrow8;
  sr24:pcolorrow24;
  sr32:pcolorrow32;
  c8  :tcolor8;
  c24 :tcolor24;
  c32 :tcolor32;
  sx,sy,sbits,sw,sh:longint;
begin
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;

if not mis__canarea(s,sa,sa) then
   begin
   result:=true;
   exit;
   end;

//init
c8:=r;
if (g>c8) then c8:=g;
if (b>c8) then c8:=b;

c24.r:=r;
c24.g:=g;
c24.b:=b;

c32.r:=r;
c32.g:=g;
c32.b:=b;
c32.a:=a;

//get
for sy:=sa.top to sa.bottom do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

case sbits of
8 :for sx:=sa.left to sa.right do sr8[sx] :=c8;
24:for sx:=sa.left to sa.right do sr24[sx]:=c24;
32:for sx:=sa.left to sa.right do sr32[sx]:=c32;
end;

end;//sy

//successful
result:=true;
skipend:
except;end;
end;

function mis__cls8(s:tobject;a:byte):boolean;//04aug2024
begin
result:=mis__cls82(s,misarea(s),a);
end;

function mis__cls82(s:tobject;sa:twinrect;a:byte):boolean;//04aug2024
label
   skipdone,skipend;
var
  sr8 :pcolorrow8;
  sr24:pcolorrow24;
  sr32:pcolorrow32;
  sx,sy,sbits,sw,sh:longint;
begin
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;

if (sbits<>8) and (sbits<>32) then
   begin
   result:=true;
   exit;
   end;

if not mis__canarea(s,sa,sa) then
   begin
   result:=true;
   exit;
   end;

//get
for sy:=sa.top to sa.bottom do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

case sbits of
8 :for sx:=sa.left to sa.right do sr8[sx]   :=a;
32:for sx:=sa.left to sa.right do sr32[sx].a:=a;
end;

end;//sy

//successful
result:=true;
skipend:
except;end;
end;

function mis__mirror82432(x:tobject):boolean;//left-right - 08may2025
label
   skipend;
var
   s:tbasicimage;
   xmax,dx,dy,xbits,xw,xh:longint;
   sr8,xr8:pcolorrow8;
   sr24,xr24:pcolorrow24;
   sr32,xr32:pcolorrow32;
   c32:tcolor32;
   c24:tcolor24;
   c8 :tcolor8;
begin
//defaults
result:=false;
s     :=nil;

//check
if not misok82432(x,xbits,xw,xh) then exit;

try
//init
s   :=misimg(xbits,xw,1);
xmax:=xw-1;

if not misscan82432(s,0,sr8,sr24,sr32) then goto skipend;

//get
for dy:=0 to (xh-1) do
begin
if not misscan82432(x,dy,xr8,xr24,xr32) then goto skipend;

if (xbits=32) then
   begin
   for dx:=0 to (xw-1) do
   begin
   c32:=xr32[dx];
   sr32[xmax-dx]:=c32;
   end;

   for dx:=0 to (xw-1) do
   begin
   c32:=sr32[dx];
   xr32[dx]:=c32;
   end;
   end
else if (xbits=24) then
   begin
   for dx:=0 to (xw-1) do
   begin
   c24:=xr24[dx];
   sr24[xmax-dx]:=c24;
   end;

   for dx:=0 to (xw-1) do
   begin
   c24:=sr24[dx];
   xr24[dx]:=c24;
   end;
   end
else if (xbits=8) then
   begin
   for dx:=0 to (xw-1) do
   begin
   c8:=xr8[dx];
   sr8[xmax-dx]:=c8;
   end;

   for dx:=0 to (xw-1) do
   begin
   c8:=sr8[dx];
   xr8[dx]:=c8;
   end;
   end;

end;//dy

//successful
result:=true;
skipend:
except;end;
//free
freeobj(@s);
end;

function mis__flip82432(x:tobject):boolean;//up-down - 08may2025
label
   skipend;
var
   s:tbasicimage;
   ymax,dx,dy,xbits,xw,xh:longint;
   xrs8,srs8:pcolorrows8;
   xrs24,srs24:pcolorrows24;
   xrs32,srs32:pcolorrows32;
   c32:tcolor32;
   c24:tcolor24;
   c8 :tcolor8;
begin
//defaults
result:=false;
s     :=nil;

//check
if not misok82432(x,xbits,xw,xh) then exit;

try
//init
s   :=misimg(xbits,1,xh);
ymax:=xh-1;

if not misrows82432(s,srs8,srs24,srs32) then goto skipend;
if not misrows82432(x,xrs8,xrs24,xrs32) then goto skipend;

//get
for dx:=0 to (xw-1) do
begin

if (xbits=32) then
   begin
   for dy:=0 to (xh-1) do
   begin
   c32:=xrs32[dy][dx];
   srs32[ymax-dy][0]:=c32;
   end;

   for dy:=0 to (xh-1) do
   begin
   c32:=srs32[dy][0];
   xrs32[dy][dx]:=c32;
   end;
   end
else if (xbits=24) then
   begin
   for dy:=0 to (xh-1) do
   begin
   c24:=xrs24[dy][dx];
   srs24[ymax-dy][0]:=c24;
   end;

   for dy:=0 to (xh-1) do
   begin
   c24:=srs24[dy][0];
   xrs24[dy][dx]:=c24;
   end;
   end
else if (xbits=8) then
   begin
   for dy:=0 to (xh-1) do
   begin
   c8:=xrs8[dy][dx];
   srs8[ymax-dy][0]:=c8;
   end;

   for dy:=0 to (xh-1) do
   begin
   c8:=srs8[dy][0];
   xrs8[dy][dx]:=c8;
   end;
   end;

end;//dy

//successful
result:=true;
skipend:
except;end;
//free
freeobj(@s);
end;

function mis__rotate82432(x:tobject;xangle:longint):boolean;//-90, 90, -180, 180, -270, or 270 deg - 09may2025
label
   skipend;
var
   s:tbasicimage;
   sx,sy,ddx,ddy,dw,dh,dx,dy,xbits,xw,xh:longint;
   xr90,xflip,yflip:boolean;
   xrs8,srs8:pcolorrows8;
   xrs24,srs24:pcolorrows24;
   xrs32,srs32:pcolorrows32;
   c32:tcolor32;
   c24:tcolor24;
   c8 :tcolor8;

   procedure dflip;
   begin
   if xr90 then
      begin
      sx:=dy;
      sy:=dx;
      end
   else
      begin
      sx:=dx;
      sy:=dy;
      end;
   if xflip then ddx:=(dw-1)-dx else ddx:=dx;
   if yflip then ddy:=(dh-1)-dy else ddy:=dy;
   end;
begin
//defaults
result:=false;
s     :=nil;
xflip :=false;
yflip :=false;
xr90  :=false;

//check
if not misok82432(x,xbits,xw,xh) then exit;


try
//init
dw:=xw;
dh:=xh;

//filter
case xangle of
-90..-1   :xangle:=270;
-180..-91 :xangle:=180;
-270..-181:xangle:=90;
end;

//decide
case xangle of
0..90:begin
   xflip:=true;
   xr90 :=true;
   end;
91..180:begin
   xflip:=true;
   yflip:=true;
   end;
181..270:begin
   yflip:=true;
   xr90 :=true;
   end;
else
   begin
   result:=true;
   exit;
   end;
end;//case

//init
s   :=misimg(xbits,xw,xh);

//.copy x => s
if not mis__copyfast82432(maxarea,0,0,xw,xh,misarea(x),s,x) then goto skipend;

//.size
if xr90                 then low__swapint(dw,dh);
if not missize(x,dw,dh) then goto skipend;

//.rows
if not misrows82432(s,srs8,srs24,srs32) then goto skipend;
if not misrows82432(x,xrs8,xrs24,xrs32) then goto skipend;

//get
for dy:=0 to (dh-1) do
begin

if (xbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   dflip;
   c32:=srs32[sy][sx];
   xrs32[ddy][ddx]:=c32;
   end;//dx
   end
else if (xbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   dflip;
   c24:=srs24[sy][sx];
   xrs24[ddy][ddx]:=c24;
   end;//dx
   end
else if (xbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   dflip;
   c8:=srs8[sy][sx];
   xrs8[ddy][ddx]:=c8;
   end;//dx
   end;

end;//dy

//successful
result:=true;
skipend:
except;end;
//free
freeobj(@s);
end;

function mis__findBPP(s:tobject):longint;//scans image to determine the actual BPP required
label
   skipend;
var//32 bpp => color image with one or more alpha values at 254 or less
   //24 bpp => color image with no alpha, or color image with all alpha values at 255
   // 8 bpp => color image with all colors as shades of grey and no alpha
   // 8 bpp => color image with all colors as shades of grey and all alpha values at 255
   // proc does not consider color indexed/palette images
   sbits,sw,sh,sx,sy:longint;
   s32:tcolor32;
   s24:tcolor24;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   xneeds_mask,xneeds_color:boolean;
begin
//defaults
result:=32;
xneeds_mask :=false;
xneeds_color:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then goto skipend;

//8bit -> can only have shades of grey -> safe to quit at this point
if (sbits=8) then
   begin
   result:=8;
   goto skipend;
   end;

//get
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s32:=sr32[sx];
   if (s32.a<255)                      then xneeds_mask:=true;
   if (s32.r<>s32.g) or (s32.g<>s32.b) then xneeds_color:=true;
   end;

   if xneeds_mask then break;
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   s24:=sr24[sx];
   if (s24.r<>s24.g) or (s24.g<>s24.b) then xneeds_color:=true;
   end;

   if xneeds_color then break;
   end;

end;//sy

//set
if      xneeds_mask  then result:=32
else if xneeds_color then result:=24
else                      result:=8;

skipend:
except;end;
end;

function degtorad2(deg:extended):extended;//20OCT2009
const
   PieRadian=3.1415926535897932384626433832795;
   v=((2*PieRadian)/360);
begin
result:=0;try;result:=v*deg;except;end;
end;

function miscurveAirbrush2(var x:array of longint;xcount,valmin,valmax:longint;xflip,yflip:boolean):boolean;//20jan2021, 29jul2016
var
   dp,dv,valmag,p,v,maxp:longint;
   tmp,deg:extended;
begin
//defaults
result:=false;

try
//range
xcount:=frcrange32(xcount,0,high(x)+1);
if (xcount<2) then exit;
if (valmin>valmax) then low__swapint(valmin,valmax);
//init
valmag:=valmax-valmin;
maxp:=frcmin32(xcount-1,0);
//set
for p:=0 to maxp do
begin
deg:=90*(p/(1+maxp));//29jul2016
tmp:=round(maxp*sin(degtorad2(deg)));
deg:=90*(tmp/(1+maxp));
v:=round(
 valmag*
 math__power32(cos(degtorad2(deg)),2)//4 or 5 increases the steepness, 1..3 decreases steepness, 3=middle ground and is 98% same as Adobe's airbrush curve
 );
v:=frcrange32(v,0,valmag);
//.support X and Y flipping - 20jan2021
if xflip then dp:=p else dp:=maxp-p;
if yflip then dv:=valmax-v else dv:=valmin+v;
x[dp]:=frcrange32(dv,valmin,valmax);
end;//p
//successful
result:=true;
except;end;
end;

function mistranscol(s:tobject;stranscolORstyle:longint;senable:boolean):longint;
begin
result:=clnone;
if senable then result:=misfindtranscol82432(s,stranscolORstyle);
end;

function misfindtranscol82432(s:tobject;stranscol:longint):longint;
var
   tr,tg,tb:longint;
begin
misfindtranscol82432ex(s,stranscol,tr,tg,tb);
result:=rgba0__int(tr,tg,tb);
end;

function misfindtranscol82432ex(s:tobject;stranscol:longint;var tr,tg,tb:longint):boolean;//25jan2025: clBotLeft
label
   skipend;
var
   sr8 :pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc24:tcolor24;
   sbits,sw,sh:longint;
begin
//defaults
result:=false;

try
tr:=255;
tg:=255;
tb:=255;
//get
//.top-left
if (stranscol=cltopleft) or (stranscol=clbotleft) then
   begin
   if not misok82432(s,sbits,sw,sh) then goto skipend;
   if not misscan82432(s,low__aorb(0,sh-1,stranscol=clbotleft),sr8,sr24,sr32) then goto skipend;
   if (sbits=8) then
      begin
      tr:=sr8[0];
      tg:=tr;
      tb:=tr;
      end
   else if (sbits=24) then
      begin
      tr:=sr24[0].r;
      tg:=sr24[0].g;
      tb:=sr24[0].b;
      end
   else if (sbits=32) then
      begin
      tr:=sr32[0].r;
      tg:=sr32[0].g;
      tb:=sr32[0].b;
      end;
   end
else if (stranscol=clwhite) then
   begin
   tr:=255;
   tg:=255;
   tb:=255;
   end
else if (stranscol=clblack) then
   begin
   tr:=0;
   tg:=0;
   tb:=0;
   end
else if (stranscol=clred) then
   begin
   tr:=255;
   tg:=0;
   tb:=0;
   end
else if (stranscol=cllime) then
   begin
   tr:=0;
   tg:=255;
   tb:=0;
   end
else if (stranscol=clblue) then
   begin
   tr:=0;
   tg:=0;
   tb:=255;
   end
//.user specified color
else
   begin
   sc24:=int__c24(stranscol);
   tr:=sc24.r;
   tg:=sc24.g;
   tb:=sc24.b;
   end;
//successful
result:=true;
skipend:
except;end;
end;

function mislimitcolors82432(x:tobject;xtranscolor,colorlimit:longint;fast:boolean;var a:array of tcolor24;var acount:longint;var e:string):boolean;//01aug2021, 15SEP2007
begin
result:=mislimitcolors82432ex(x,0,max32,xtranscolor,colorlimit,fast,true,a,acount,e);
end;

function mislimitcolors82432ex(x:tobject;sx,xcellw,xtranscolor,colorlimit:longint;fast,xreducetofit:boolean;var a:array of tcolor24;var acount:longint;var e:string):boolean;//25dec2022, 01aug2021, 15SEP2007
label//colorlimit=2..1024
   redo,skipdone,skipend;
const
   dvLIMIT=240;
var
   dx1,dx2,xbits,xw,xh,i,alimit,p,dy,dx:longint;
   dv:byte;
   sr8:pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc8:tcolor8;
   nontc,tc,zc:tcolor24;
   sc32:tcolor32;

   procedure dvcolor;//divide the color
   begin
   //get - work only on non-transparent pixels
   if (zc.r<>tc.r) or (zc.g<>tc.g) or (zc.b<>tc.b) then
      begin
      //set
      zc.r:=byte((zc.r div dv)*dv);
      zc.g:=byte((zc.g div dv)*dv);
      zc.b:=byte((zc.b div dv)*dv);
      //filter - color collision - if color is same as transparent color use "non-transparent" color instead - 18JAN2012
      if (zc.r=tc.r) and (zc.g=tc.g) and (zc.b=tc.b) then zc:=nontc;
      end;
   end;
begin
//defaults
result:=false;
e:=gecUnexpectedError;
acount:=0;

try
//check
if not misok82432(x,xbits,xw,xh) then exit;
if (low(a)<>0) and (high(a)<1) then exit;
e:=gecOutOfMemory;
//INIT
xcellw:=frcrange32(xcellw,1,xw);
sx:=frcrange32(sx,0,xw-1);
dx1:=frcrange32(sx,0,xw-1);
dx2:=frcrange32(sx+xcellw-1,0,xw-1);
fillchar(a,sizeof(a),0);
dv:=1;//divide color element by facter, increases in color limit is reached, to reduce colors gradually
//.maintain transparency information whether it's used or not
if (xtranscolor=clTopLeft) then tc:=mispixel24(x,sx,0)
else if (xtranscolor<>clnone) then tc:=int__c24(xtranscolor)
else tc:=mispixel24(x,sx,0);//was: tc:=intrgb(pixels[x,0,0]);//get transparent color

//..not white NOR black
nontc.r:=byte(frcrange32(tc.r,1,254));
nontc.g:=byte(frcrange32(tc.g,1,254));
nontc.b:=byte(frcrange32(tc.b,1,254));
if (tc.r=nontc.r) and (tc.g=nontc.g) and (tc.b=nontc.b) then nontc.r:=nontc.r+1;//can go upto 255 - 18JAN2012
//.limit
alimit:=frcrange32(colorlimit,2,high(a)+1);
//.default palette color
a[0]:=tc;
//GET
redo:
acount:=1;
//y
for dy:=0 to (xh-1) do
begin
if not misscan82432(x,dy,sr8,sr24,sr32) then goto skipend;
//x
//.8
if (xbits=8) then
   begin
   for dx:=dx1 to dx2 do
   begin
   //get
   sc8:=sr8[dx];
   zc.r:=sc8;
   zc.g:=sc8;
   zc.b:=sc8;
   //filter - only non-transparent colors
   if (dv>=2) then dvcolor;
   //scan - look in palette to see if we already have this color
   i:=-1;
   for p:=0 to (acount-1) do if (a[p].r=zc.r) and (a[p].g=zc.g) and (a[p].b=zc.b) then
      begin
      i:=p;
      break;
      end;
   //.counting colors only -> palette is full so we can stop - 22sep2021
   if (not xreducetofit) and ((acount>=alimit) or (i=-1)) then goto skipdone;
   //add color
   if (i=-1) then
      begin
      //.add to palette
      if (acount<alimit) then
         begin
         a[acount]:=zc;
         inc(acount);
         end
      //.palette full - retry at a higher DV rate
      else if (dv<dvLIMIT) then
         begin
         dv:=frcmax32(dv+low__aorb(1,10,dv>30),dvLIMIT);//smoother and faster - 25dec2022
         goto redo;
         end
      //.palette full and DV is maxed out - change color into first noh-transparent "a[1]" color and be done with it - 18JAN2012
      else sr8[dx]:=a[1].r;
      end;
   end;//dx
   end//8
//.24
else if (xbits=24) then
   begin
   for dx:=dx1 to dx2 do
   begin
   //get
   zc:=sr24[dx];
   //filter - only non-transparent colors
   if (dv>=2) then dvcolor;
   //scan - look in palette to see if we already have this color
   i:=-1;
   for p:=0 to (acount-1) do if (a[p].r=zc.r) and (a[p].g=zc.g) and (a[p].b=zc.b) then
      begin
      i:=p;
      break;
      end;
   //.counting colors only -> palette is full so we can stop - 22sep2021
   if (not xreducetofit) and ((acount>=alimit) or (i=-1)) then goto skipdone;
   //add color
   if (i=-1) then
      begin
      //.add to palette
      if (acount<alimit) then
         begin
         a[acount]:=zc;
         inc(acount);
         end
      //.palette full - retry at a higher DV rate
      else if (dv<dvLIMIT) then
         begin
         dv:=frcmax32(dv+low__aorb(1,10,dv>30),dvLIMIT);//smoother and faster - 25dec2022
         goto redo;
         end
      //.palette full and DV is maxed out - change color into first non-transparent "a[1]" color and be done with it - 18JAN2012
      else sr24[dx]:=a[1];
      end;
   end;//dx
   end//24
//.32
else if (xbits=32) then
   begin
   for dx:=dx1 to dx2 do
   begin
   //get
   sc32:=sr32[dx];
   zc.r:=sc32.r;
   zc.g:=sc32.g;
   zc.b:=sc32.b;
   //filter - only non-transparent colors
   if (dv>=2) then dvcolor;
   //scan - look in palette to see if we already have this color
   i:=-1;
   for p:=0 to (acount-1) do if (a[p].r=zc.r) and (a[p].g=zc.g) and (a[p].b=zc.b) then
      begin
      i:=p;
      break;
      end;
   //.counting colors only -> palette is full so we can stop - 22sep2021
   if (not xreducetofit) and ((acount>=alimit) or (i=-1)) then goto skipdone;
   //add color
   if (i=-1) then
      begin
      //.add to palette
      if (acount<alimit) then
         begin
         a[acount]:=zc;
         inc(acount);
         end
      //.palette full - retry at a higher DV rate
      else if (dv<dvLIMIT) then
         begin
         //was: dv:=frcmax32(dv+10,dvLIMIT);
         dv:=frcmax32(dv+low__aorb(1,10,dv>30),dvLIMIT);//smoother and faster - 25dec2022
         goto redo;
         end
      //.palette full and DV is maxed out - change color into first non-transparent "a[1]" color and be done with it - 18JAN2012
      else
         begin
         sc32.r:=a[1].r;
         sc32.g:=a[1].g;
         sc32.b:=a[1].b;//Note: sc32.a retained from above
         sr32[dx]:=sc32;
         end;
      end;
   end;//dx
   end;//32
end;//dy

//adjust image colors (dv>=2)
if xreducetofit and (dv>=2) then
   begin
   for dy:=0 to (xh-1) do
   begin
   if not misscan82432(x,dy,sr8,sr24,sr32) then goto skipend;
   //.8
   if (xbits=8) then
      begin
      for dx:=dx1 to dx2 do
      begin
      sc8:=sr8[dx];
      zc.r:=sc8;
      zc.g:=sc8;
      zc.b:=sc8;
      dvcolor;
      sr8[dx]:=zc.r;
      end;//dx
      end//24
   //.24
   else if (xbits=24) then
      begin
      for dx:=dx1 to dx2 do
      begin
      zc:=sr24[dx];
      dvcolor;
      sr24[dx]:=zc;
      end;//dx
      end//24
   //.32
   else if (xbits=32) then
      begin
      for dx:=dx1 to dx2 do
      begin
      sc32:=sr32[dx];
      zc.r:=sc32.r;
      zc.g:=sc32.g;
      zc.b:=sc32.b;
      dvcolor;
      sc32.r:=zc.r;
      sc32.g:=zc.g;
      sc32.b:=zc.b;//Note: sc32.a retained from above
      sr32[dx]:=sc32;
      end;//dx
      end;//32
   end;//dy
   end;

//successful
skipdone:
result:=true;
skipend:
except;end;
end;

function misrect(x,y,x2,y2:longint):twinrect;
begin
result.left:=x;
result.top:=y;
result.right:=x2;
result.bottom:=y2;
end;

function misarea(s:tobject):twinrect;
begin
result:=nilrect;
if zzok(s,7008) then result:=area__make(0,0,misw(s)-1,mish(s)-1);
end;

function miscopyarea32(ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject):boolean;//can copy ALL 32bits of color
begin
result:=miscopyarea322(maxarea,ddx,ddy,ddw,ddh,sa,d,s,0,0);
end;

function miscopyarea321(da,sa:twinrect;d,s:tobject):boolean;//can copy ALL 32bits of color
begin
result:=miscopyarea32(da.left,da.top,da.right-da.left+1,da.bottom-da.top+1,sa,d,s);
end;

function miscopyarea322(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xscroll,yscroll:longint):boolean;//can copy ALL 32bits of color
begin
result:=miscopyarea323(da_clip,ddx,ddy,ddw,ddh,sa,d,s,xscroll,yscroll,false);
end;

function miscopyarea323(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xscroll,yscroll:longint;xmix32:boolean):boolean;//18nov2024: xmix32 mixes alpha colors into a lesser bit depth image e.g. drawing a 32 bit image onto a 24 bit one, can copy ALL 32bits of color
label
   skipend;
var//Note: Speed optimised using x-pixel limiter "d1,d2", y-pixel limiter "d3,d4"
   //      and object caching "1x createtmp" and "2x createint" with a typical speed
   //      increase in PicWork of 45x, or a screen paint time originally of 3,485ms now 78ms
   //      with layer 2 image at 80,000px wide @ 1,000% zoom as of 06sep2017.
   //Note: s and d are required - 25jul2017
   //Note: da,sa are zero-based areas, e.g: da.left/right=0..[width-1],
   //Critical Note: must use "trunc" instead of "round" for correct rounding behaviour - 24SEP2011
   //Note: xmix32: blends or mixes 32 bit color pixels from "s" into "d" WHEN d is not 32 bit capable
   dr32,sr32:pcolorrow32;//25apr2020
   dr24,sr24:pcolorrow24;
   dr8,sr8:pcolorrow8;
   sc32:tcolor32;
   tmp24,sc24:tcolor24;
   sc8:tcolor8;
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support
   p,daW,daH,saW,saH:longint;
   d1,d2,d3,d4:longint;//x-pixel(d) and y-pixel(d) speed optimisers -> represent ACTUAL d.area needed to be processed - 05sep2017
   //.image values
   sw,sh,sbits:longint;
   shasai:boolean;
   dw,dh,dbits:longint;
   dhasai:boolean;
   //.other
   dx,dy,sx,sy:longint;
   dx1,dx2,dy1,dy2:longint;
   bol1,xmirror,xflip:boolean;
   da:twinrect;

   function cint32(x:currency):longint;
   begin//Note: Clip a 64bit integer to a 32bit integer range
   if (x>max32) then x:=max32
   else if (x<min32) then x:=min32;
   result:=trunc(x);
   end;

   procedure mix32_24;
   begin
   if (sc32.a<=0) then sc24:=dr24[dx]
   else
      begin
      tmp24:=dr24[dx];
      sc24.r:=( (sc32.r*sc32.a) + (tmp24.r*(255-sc32.a)) ) div 256;//div 256 is FASTER thatn 255
      sc24.g:=( (sc32.g*sc32.a) + (tmp24.g*(255-sc32.a)) ) div 256;
      sc24.b:=( (sc32.b*sc32.a) + (tmp24.b*(255-sc32.a)) ) div 256;
      end;
   end;

   procedure mix32_8;
   begin
   //check
   if (sc32.a<=0) then exit;

   //mix
   sc32.r:=( (sc32.r*sc32.a) + (dr8[dx]*(255-sc32.a)) ) div 256;//div 256 is FASTER thatn 255
   end;
begin
//defaults
result:=false;
_mx   :=nil;
_my   :=nil;

try
//check
if (sa.right<sa.left) or (sa.bottom<sa.top) then goto skipend;
if not misinfo82432(s,sbits,sw,sh,shasai)   then goto skipend;
if not misinfo82432(d,dbits,dw,dh,dhasai)   then goto skipend;

//.mirror + flip
xmirror:=(ddw<0);if xmirror then ddw:=-ddw;
xflip  :=(ddh<0);if xflip   then ddh:=-ddh;
da.left:=cint32(ddx);
da.right:=cint32(ddx)+cint32(ddw-1);
da.top:=cint32(ddy);
da.bottom:=cint32(ddy)+cint32(ddh-1);

//.da_clip - limit to dimensions of "d" - 05sep2017
da_clip.left:=frcrange32(da_clip.left,0,dw-1);
da_clip.right:=frcrange32(da_clip.right,da_clip.left,dw-1);
da_clip.top:=frcrange32(da_clip.top,0,dH-1);
da_clip.bottom:=frcrange32(da_clip.bottom,0,dH-1);

//.optimise actual x-pixels scanned -> d1 + d2 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d1:=largest32(largest32(da.left,da_clip.left),0);//range: 0..max32
d2:=smallest32(smallest32(da.right,da_clip.right),dw-1);//range: min32..dw-1
if (d2<d1) then goto skipend;

//.optimise actual y-pixels scanned -> d3 + d4 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d3:=largest32(largest32(da.top,da_clip.top),0);//range: 0..max32
d4:=smallest32(smallest32(da.bottom,da_clip.bottom),dH-1);//range: min32..dh-1
if (d4<d3) then goto skipend;

//.other
daW:=low__posn(da.right-da.left)+1;
daH:=low__posn(da.bottom-da.top)+1;
saW:=low__posn(sa.right-sa.left)+1;
saH:=low__posn(sa.bottom-sa.top)+1;
dx1:=frcrange32(da.left,0,dw-1);
dx2:=frcrange32(da.right,0,dw-1);
dy1:=frcrange32(da.top,0,dh-1);
dy2:=frcrange32(da.bottom,0,dh-1);
//.check area -> do nothing
if (daw=0) or (dah=0) or (saw=0) or (sah=0) then goto skipend;
if (sa.right<sa.left) or (sa.bottom<sa.top) or (da.right<da.left) or (da.bottom<da.top) then goto skipend;
if (dx2<dx1) or (dy2<dy1) then goto skipend;

//.x-scroll
if (xscroll<>0) then
   begin
   xscroll:=-xscroll;//logic inversion -> match user expectation -> neg.vals=left, pos.vals=right
   bol1:=(xscroll<0);
   xscroll:=low__posn(xscroll);
   xscroll:=xscroll-((xscroll div saW)*saW);
   xscroll:=frcrange32(xscroll,0,saW-1);
   if bol1 then xscroll:=-xscroll;
   end;

//.y-scroll
if (yscroll<>0) then
   begin
   yscroll:=-yscroll;//logic inversion -> match user expectation -> neg.vals=up, pos.vals=down
   bol1:=(yscroll<0);
   yscroll:=low__posn(yscroll);
   yscroll:=yscroll-((yscroll div saH)*saH);
   yscroll:=frcrange32(yscroll,0,saH-1);
   if bol1 then yscroll:=-yscroll;
   end;

//.mx (mapped dx) - highly optimised - 06sep2017
if not low__createint(_mx,'copyareaxx_mx.'+intstr32(daW)+'.0.'+intstr32(sa.left)+'.'+intstr32(sa.right)+'.'+intstr32(saW),bol1) then goto skipend;
if not bol1 then
   begin
   //init
   _mx.setparams(daW,daW,0);
   mx:=_mx.core;
   //get
   for p:=0 to (daW-1) do
   begin
   mx[p]:=frcrange32(sa.left+trunc(p*(saW/daW)),sa.left,sa.right);//06apr2017
   end;//p
   end;
mx:=_mx.core;

//.my (mapped dy) - highly optimised - 06sep2017
if not low__createint(_my,'copyareaxx_my.'+intstr32(daH)+'.0.'+intstr32(sa.top)+'.'+intstr32(sa.bottom)+'.'+intstr32(saH),bol1) then goto skipend;
if not bol1 then
   begin
   //init
   _my.setparams(daH,daH,0);
   my:=_my.core;
   //get
   for p:=0 to (daH-1) do
   begin
   my[p]:=frcrange32(sa.top+trunc(p*(saH/daH)),sa.top,sa.bottom);//24SEP2011
   end;//p
   end;
my:=_my.core;

//-- Draw Color Pixels ---------------------------------------------------------
//dy
//...was: for dy:=da.top to da.bottom do if (dy>=0) and (dy<dH) and (dy>=da_clip.top) and (dy<=da_clip.bottom) then
for dy:=d3 to d4 do
   begin
   //.ar
   if xflip then sy:=my[(da.bottom-da.top)-(dy-da.top)] else sy:=my[dy-da.top];//zero base
   //.y-scroll
   if (yscroll<>0) then
      begin
      sy:=sy+yscroll;
      if (sy<sa.top) then sy:=sa.bottom-(-sy-sa.top) else if (sy>sa.bottom) then sy:=sa.top+(sy-sa.bottom);
      end;
   //.sy
   if (sy>=0) and (sy<sH) then
      begin
      if not misscan82432(d,dy,dr8,dr24,dr32)                     then goto skipend;//25apr2020, 28may2019
      if not misscan82432(s,sy,sr8,sr24,sr32)                     then goto skipend;//25apr2020,
      //dx - Note: xeven only updated at this stage for speed during "sselshowbits<>0" - 08jul2019
      //...was: for dx:=da.left to da.right do if (dx>=0) and (dx<dw) and (dx>=da_clip.left) and (dx<=da_clip.right) then
      for dx:=d1 to d2 do
         begin
         if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
         //.x-scroll
         if (xscroll<>0) then
            begin
            sx:=sx+xscroll;
            if (sx<sa.left) then
               begin
               //.math quirk for "animation cell area" referencing - 25sep2017
               if (sx<=0) then sx:=sa.right-(-sx-sa.left) else sx:=sa.right-(sa.left-sx);
               end
            else if (sx>sa.right) then sx:=sa.left+(sx-sa.right);
            end;
         //.sx
         if (sx>=0) and (sx<sW) then
            begin
            //.32 + 32
            if (sbits=32) and (dbits=32) then
               begin
               sc32:=sr32[sx];
               dr32[dx]:=sc32;
               end
            //.32 + 24
            else if (sbits=32) and (dbits=24) then
               begin
               sc32:=sr32[sx];

               if xmix32 then mix32_24
               else
                  begin
                  sc24.r:=sc32.r;
                  sc24.g:=sc32.g;
                  sc24.b:=sc32.b;
                  end;

               dr24[dx]:=sc24;
               end
            //.32 + 8
            else if (sbits=32) and (dbits=8) then
               begin
               sc32:=sr32[sx];
               if (sc32.g>sc32.r) then sc32.r:=sc32.g;
               if (sc32.b>sc32.r) then sc32.r:=sc32.b;

               if xmix32 then mix32_8;

               dr8[dx]:=sc32.r;
               end
            //.24 + 32
            else if (sbits=24) and (dbits=32) then
               begin
               sc24:=sr24[sx];
               sc32.r:=sc24.r;
               sc32.g:=sc24.g;
               sc32.b:=sc24.b;
               sc32.a:=255;
               dr32[dx]:=sc32;
               end
            //.24 + 24
            else if (sbits=24) and (dbits=24) then
               begin
               sc24:=sr24[sx];
               dr24[dx]:=sc24;
               end
            //.24 + 8
            else if (sbits=24) and (dbits=8) then
               begin
               sc24:=sr24[sx];
               if (sc24.g>sc24.r) then sc24.r:=sc24.g;
               if (sc24.b>sc24.r) then sc24.r:=sc24.b;
               dr8[dx]:=sc24.r;
               end
            //.8 + 32
            else if (sbits=8) and (dbits=32) then
               begin
               sc32.r:=sr8[sx];
               sc32.g:=sc32.r;
               sc32.b:=sc32.r;
               sc32.a:=255;
               dr32[dx]:=sc32;
               end
            //.8 + 24
            else if (sbits=8) and (dbits=24) then
               begin
               sc24.r:=sr8[sx];
               sc24.g:=sc24.r;
               sc24.b:=sc24.r;
               dr24[dx]:=sc24;
               end
            //.8 + 8
            else if (sbits=8) and (dbits=8) then
               begin
               sc8:=sr8[sx];
               dr8[dx]:=sc8;
               end;
            end;//sx
         end;//dx
      end;//sy
   end;//dy

//successful
result:=true;
skipend:
except;end;
//.free
low__freeint(_mx);
low__freeint(_my);
end;

function mis__colormatrixpixel24(x,y,w,h:longint):tcolor24;
var
   c32:tcolor32;
begin
c32:=mis__colormatrixpixel32(x,y,w,h,0);
result.r:=c32.r;
result.g:=c32.g;
result.b:=c32.b;
end;

function mis__colormatrixpixel32(x,y,w,h:longint;a:byte):tcolor32;//matches "ldm()" exactly for color reproduction - 18feb2025: tweaked, 02feb2025
var
   dypert,dxpert,av,ar,ag,ab:single;
   h2:longint;
begin
//defaults
result.a:=a;

//check
if (w<=0) or (h<=0) then
   begin
   result.r:=255;
   result.g:=255;
   result.b:=255;
   exit;
   end;

//range
if (x<0) then x:=0 else if (x>=w) then x:=w-1;
if (y<0) then y:=0 else if (y>=h) then y:=h-1;

//init
h2:=h div 2;
if (h2<=0) then h2:=1;

//get - color calculation
if      (y<h2)      then dypert:=-((h2-y)/h2)
else                     dypert:= ((y-h2)/h2);

if      (dypert<-1) then dypert:=-1
else if (dypert>1)  then dypert:= 1;

dxpert:=((x+1)/w);

if (dxpert<=0.16) then
   begin//red -> yellow
   av:=255*((dxpert-0)/0.16);//0..255
   ar:=255;
   ag:=av;
   ab:=0;
   end
else if (dxpert<=0.33) then
   begin//yellow -> green
   av:=255*((dxpert-0.16)/0.17);//0..255
   ar:=255-av;
   ag:=255;
   ab:=0;
   end
else if (dxpert<=0.50) then
   begin//yellow -> green
   av:=255*((dxpert-0.33)/0.17);//0..255
   ar:=0;
   ag:=255;
   ab:=av;
   end
else if (dxpert<=0.67) then
   begin//yellow -> green
   av:=255*((dxpert-0.50)/0.17);//0..255
   ar:=0;
   ag:=255-av;
   ab:=255;
   end
else if (dxpert<=0.84) then
   begin//yellow -> green
   av:=255*((dxpert-0.67)/0.17);//0..255
   ar:=av;
   ag:=0;
   ab:=255;
   end
else if (dxpert<=1) then
   begin//yellow -> green
   av:=255*((dxpert-0.84)/0.16);//0..255
   ar:=255;
   ag:=0;
   ab:=255-av;
   end
else
   begin
   av:=0;
   ar:=0;
   ag:=0;
   ab:=0;
   end;

//vertical shade
if (dypert<=0) then
   begin
   ar:=((1+dypert)*ar)+(-dypert*255);
   ag:=((1+dypert)*ag)+(-dypert*255);
   ab:=((1+dypert)*ab)+(-dypert*255);
   end
else
   begin
   ar:=(1-dypert)*ar;
   ag:=(1-dypert)*ag;
   ab:=(1-dypert)*ab;
   end;

//set
result.r:=byte(round(ar));
result.g:=byte(round(ag));
result.b:=byte(round(ab));
end;

function mis__copyfast2432MASK(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xmask,xbackmask:tmask8;xmaskval,xpower255:longint):boolean;//30jan2025, 18nov2024: xmix32 mixes alpha colors into a lesser bit depth image e.g. drawing a 32 bit image onto a 24 bit one, can copy ALL 32bits of color
label
   skipend;
var//Performance Boost:
   //~172% faster than "miscopyareaxx10()" achieving ~34 fps (29ms/frame) at 1920x1080 with "32->24 bit" on an i5-6500T CPU @ 2.50GHz - 12dec2024
   //Speed optimised using x-pixel limiter "d1,d2", y-pixel limiter "d3,d4" and object caching "2x createint" for x/y mapping
   //s and d are required and sa is a zero-based area, e.g: da.left/right=0..[width-1]
   //Trunc used instead of round for correct rounding behaviour
   dr32,sr32:pcolorrow32;//25apr2020
   dr24,sr24:pcolorrow24;
   mr1,mr2:pcolorrow8;
   s32,d32:tcolor32;
   s24,d24:tcolor24;
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support
   p,daW,daH,saW,saH:longint;
   d1,d2,d3,d4:longint;//x-pixel(d) and y-pixel(d) speed optimisers -> represent ACTUAL d.area needed to be processed - 05sep2017
   //.image values
   sw,sh,sbits:longint;
   shasai:boolean;
   dw,dh,dbits:longint;
   dhasai:boolean;
   //.other
   dx,dy,sx,sy:longint;
   p255,dx1,dx2,dy1,dy2:longint;
   bol1,xmirror,xflip:boolean;
   mok1,mok2:boolean;
   da:twinrect;

   function cint32(x:currency):longint;
   begin//Note: Clip a 64bit integer to a 32bit integer range
   if (x>max32) then x:=max32
   else if (x<min32) then x:=min32;
   result:=trunc(x);
   end;
begin
//defaults
result:=false;
_mx   :=nil;
_my   :=nil;

try
//check
if (sa.right<sa.left) or (sa.bottom<sa.top) then goto skipend;
if not misinfo2432(s,sbits,sw,sh,shasai)    then goto skipend;
if not misinfo2432(d,dbits,dw,dh,dhasai)    then goto skipend;

mok1:=(xmaskval>=0) and (xmask<>nil) and (xmask.width>=dw) and (xmask.height>=dh);
mok2:=(xbackmask<>nil) and (xbackmask.width>=dw) and (xbackmask.height>=dh);
mr1:=nil;
mr2:=nil;
if not mok1 then xmaskval:=-1;//off

//.mirror + flip
xmirror:=(ddw<0);
if xmirror then ddw:=-ddw;

xflip  :=(ddh<0);
if xflip   then ddh:=-ddh;

da.left:=cint32(ddx);
da.right:=cint32(ddx)+cint32(ddw-1);
da.top:=cint32(ddy);
da.bottom:=cint32(ddy)+cint32(ddh-1);

//.da_clip - limit to dimensions of "d" - 05sep2017
da_clip.left:=frcrange32(da_clip.left,0,dw-1);
da_clip.right:=frcrange32(da_clip.right,da_clip.left,dw-1);
da_clip.top:=frcrange32(da_clip.top,0,dH-1);
da_clip.bottom:=frcrange32(da_clip.bottom,0,dH-1);

//.optimise actual x-pixels scanned -> d1 + d2 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d1:=largest32(largest32(da.left,da_clip.left),0);//range: 0..max32
d2:=smallest32(smallest32(da.right,da_clip.right),dw-1);//range: min32..dw-1
if (d2<d1) then goto skipend;

//.optimise actual y-pixels scanned -> d3 + d4 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d3:=largest32(largest32(da.top,da_clip.top),0);//range: 0..max32
d4:=smallest32(smallest32(da.bottom,da_clip.bottom),dH-1);//range: min32..dh-1
if (d4<d3) then goto skipend;

//.other
daW:=low__posn(da.right-da.left)+1;
daH:=low__posn(da.bottom-da.top)+1;
saW:=low__posn(sa.right-sa.left)+1;
saH:=low__posn(sa.bottom-sa.top)+1;
dx1:=frcrange32(da.left,0,dw-1);
dx2:=frcrange32(da.right,0,dw-1);
dy1:=frcrange32(da.top,0,dh-1);
dy2:=frcrange32(da.bottom,0,dh-1);

//.check power level -> 0 -> do nothing
xpower255:=frcrange32(xpower255,0,255);
if (xpower255<=0) then goto skipend;

//.check area -> do nothing
if (daw=0) or (dah=0) or (saw=0) or (sah=0) then goto skipend;
if (sa.right<sa.left) or (sa.bottom<sa.top) or (da.right<da.left) or (da.bottom<da.top) then goto skipend;
if (dx2<dx1) or (dy2<dy1) then goto skipend;

//.mx (mapped dx) - highly optimised - 06sep2017
if not low__createint(_mx,'copyareaxx_mx.'+intstr32(daW)+'.0.'+intstr32(sa.left)+'.'+intstr32(sa.right)+'.'+intstr32(saW),bol1) then goto skipend;
if not bol1 then
   begin
   //init
   _mx.setparams(daW,daW,0);
   mx:=_mx.core;
   //get
   for p:=0 to (daW-1) do mx[p]:=frcrange32(sa.left+trunc(p*(saW/daW)),sa.left,sa.right);//06apr2017
   end;
mx:=_mx.core;

//.my (mapped dy) - highly optimised - 06sep2017
if not low__createint(_my,'copyareaxx_my.'+intstr32(daH)+'.0.'+intstr32(sa.top)+'.'+intstr32(sa.bottom)+'.'+intstr32(saH),bol1) then goto skipend;
if not bol1 then
   begin
   //init
   _my.setparams(daH,daH,0);
   my:=_my.core;
   //get
   for p:=0 to (daH-1) do my[p]:=frcrange32(sa.top+trunc(p*(saH/daH)),sa.top,sa.bottom);//24SEP2011
   end;
my:=_my.core;


//draw color pixels ------------------------------------------------------------
//dy
for dy:=d3 to d4 do
   begin
   //.ar
   if xflip then sy:=my[(da.bottom-da.top)-(dy-da.top)] else sy:=my[dy-da.top];//zero base

   //.sy
   if (sy>=0) and (sy<sH) then
      begin

      if not misscan2432(d,dy,dr24,dr32) then goto skipend;
      if not misscan2432(s,sy,sr24,sr32) then goto skipend;
      if mok1 then mr1:=xmask.prows8[dy];
      if mok2 then mr2:=xbackmask.prows8[dy];

      //dx


      //.32 -> 32
      if (sbits=32) and (dbits=32) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) and ((xmaskval=-1) or (mr1[dx]=xmaskval)) then
               begin
               //init
               s32:=sr32[sx];
               p255:=(s32.a*xpower255) shr 8;

               //get
               if (p255>=1) then
                  begin

                  //update background mask
                  if (mr2<>nil) then
                     begin
                     case mr2[dx] of
                     1  :mr2[dx]:=0;//hide
                     200:mr2[dx]:=100;//hide
                     201:mr2[dx]:=101;//hide
                     end;
                     end;

                  //set
                  if (p255=255) then dr32[dx]:=s32
                  else
                     begin
                     d32:=dr32[dx];

                     d32.r:=((d32.r*(255-p255)) + (s32.r*p255)) shr 8;
                     d32.g:=((d32.g*(255-p255)) + (s32.g*p255)) shr 8;
                     d32.b:=((d32.b*(255-p255)) + (s32.b*p255)) shr 8;

                     dr32[dx]:=d32;
                     end;

                  end;//p255
               end;//sx
            end;//dx
         end


      //.24 -> 32
      else if (sbits=24) and (dbits=32) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) and ((xmaskval=-1) or (mr1[dx]=xmaskval)) then
               begin
               //init
               p255:=xpower255;

               //get
               if (p255>=1) then
                  begin

                  //update background mask
                  if (mr2<>nil) then
                     begin
                     case mr2[dx] of
                     1  :mr2[dx]:=0;//hide
                     200:mr2[dx]:=100;//hide
                     201:mr2[dx]:=101;//hide
                     end;
                     end;

                  //set
                  s24  :=sr24[sx];

                  if (p255=255) then
                     begin
                     s32.r:=s24.r;
                     s32.g:=s24.g;
                     s32.b:=s24.g;
                     s32.a:=255;
                     dr32[dx]:=s32;
                     end
                  else
                     begin
                     d32:=dr32[dx];

                     d32.r:=((d32.r*(255-p255)) + (s24.r*p255)) shr 8;
                     d32.g:=((d32.g*(255-p255)) + (s24.g*p255)) shr 8;
                     d32.b:=((d32.b*(255-p255)) + (s24.b*p255)) shr 8;

                     dr32[dx]:=d32;
                     end;

                  end;//p255
               end;//sx
            end;//dx
         end


      //.32 -> 24
      else if (sbits=32) and (dbits=24) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) and ((xmaskval=-1) or (mr1[dx]=xmaskval)) then
               begin
               //init
               s32:=sr32[sx];
               p255:=(s32.a*xpower255) shr 8;

               //get
               if (p255>=1) then
                  begin

                  //update background mask
                  if (mr2<>nil) then
                     begin
                     case mr2[dx] of
                     1  :mr2[dx]:=0;//hide
                     200:mr2[dx]:=100;//hide
                     201:mr2[dx]:=101;//hide
                     end;
                     end;

                  //set
                  if (p255=255) then
                     begin
                     s24.r:=s32.r;
                     s24.g:=s32.g;
                     s24.b:=s32.b;
                     dr24[dx]:=s24;
                     end
                  else
                     begin
                     d24:=dr24[dx];

                     d24.r:=((d24.r*(255-p255)) + (s32.r*p255)) shr 8;
                     d24.g:=((d24.g*(255-p255)) + (s32.g*p255)) shr 8;
                     d24.b:=((d24.b*(255-p255)) + (s32.b*p255)) shr 8;

                     dr24[dx]:=d24;
                     end;

                  end;//p255
               end;//sx
            end;//dx
         end


      //.24 -> 24
      else if (sbits=24) and (dbits=24) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) and ((xmaskval=-1) or (mr1[dx]=xmaskval)) then
               begin
               //init
               p255:=xpower255;

               //get
               if (p255>=1) then
                  begin

                  //update background mask
                  if (mr2<>nil) then
                     begin
                     case mr2[dx] of
                     1  :mr2[dx]:=0;//hide
                     200:mr2[dx]:=100;//hide
                     201:mr2[dx]:=101;//hide
                     end;
                     end;

                  //set
                  s24:=sr24[sx];

                  if (p255=255) then dr24[dx]:=s24
                  else
                     begin
                     d24:=dr24[dx];

                     d24.r:=((d24.r*(255-p255)) + (s24.r*p255)) shr 8;
                     d24.g:=((d24.g*(255-p255)) + (s24.g*p255)) shr 8;
                     d24.b:=((d24.b*(255-p255)) + (s24.b*p255)) shr 8;

                     dr24[dx]:=d24;
                     end;

                  end;//p255
               end;//sx
            end;//dx


         end;//bits decider
      end;//sy
   end;//dy

//successful
result:=true;
skipend:
except;end;
low__freeint(_mx);
low__freeint(_my);
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//1111111111111111111111111
function mis__copyfast82432(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject):boolean;//09jan2025 - barebones pixel copier
label
   skipend;
var//Performance Boost:
   //~172% faster than "miscopyareaxx10()" achieving ~34 fps (29ms/frame) at 1920x1080 with "32->24 bit" on an i5-6500T CPU @ 2.50GHz - 12dec2024
   //Speed optimised using x-pixel limiter "d1,d2", y-pixel limiter "d3,d4" and object caching "2x createint" for x/y mapping
   //s and d are required and sa is a zero-based area, e.g: da.left/right=0..[width-1]
   //Trunc used instead of round for correct rounding behaviour
   dr32,sr32:pcolorrow32;//25apr2020
   dr24,sr24:pcolorrow24;
   dr8 ,sr8 :pcolorrow8;
   v:tint4;
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support
   p,daW,daH,saW,saH:longint;
   d1,d2,d3,d4:longint;//x-pixel(d) and y-pixel(d) speed optimisers -> represent ACTUAL d.area needed to be processed - 05sep2017
   //.image values
   sw,sh,sbits:longint;
   shasai:boolean;
   dw,dh,dbits:longint;
   dhasai:boolean;
   //.other
   dx,dy,sx,sy:longint;
   p255,dx1,dx2,dy1,dy2:longint;
   bol1,xmirror,xflip:boolean;
   da:twinrect;

   function cint32(x:currency):longint;
   begin//Note: Clip a 64bit integer to a 32bit integer range
   if (x>max32) then x:=max32
   else if (x<min32) then x:=min32;
   result:=trunc(x);
   end;
begin
//defaults
result:=false;
_mx   :=nil;
_my   :=nil;

try
//check
if (sa.right<sa.left) or (sa.bottom<sa.top) then goto skipend;
if not misinfo82432(s,sbits,sw,sh,shasai)   then goto skipend;
if not misinfo82432(d,dbits,dw,dh,dhasai)   then goto skipend;

//.mirror + flip
xmirror:=(ddw<0);
if xmirror then ddw:=-ddw;

xflip  :=(ddh<0);
if xflip   then ddh:=-ddh;

da.left:=cint32(ddx);
da.right:=cint32(ddx)+cint32(ddw-1);
da.top:=cint32(ddy);
da.bottom:=cint32(ddy)+cint32(ddh-1);

//.da_clip - limit to dimensions of "d" - 05sep2017
da_clip.left:=frcrange32(da_clip.left,0,dw-1);
da_clip.right:=frcrange32(da_clip.right,da_clip.left,dw-1);
da_clip.top:=frcrange32(da_clip.top,0,dH-1);
da_clip.bottom:=frcrange32(da_clip.bottom,0,dH-1);

//.optimise actual x-pixels scanned -> d1 + d2 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d1:=largest32(largest32(da.left,da_clip.left),0);//range: 0..max32
d2:=smallest32(smallest32(da.right,da_clip.right),dw-1);//range: min32..dw-1
if (d2<d1) then goto skipend;

//.optimise actual y-pixels scanned -> d3 + d4 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d3:=largest32(largest32(da.top,da_clip.top),0);//range: 0..max32
d4:=smallest32(smallest32(da.bottom,da_clip.bottom),dH-1);//range: min32..dh-1
if (d4<d3) then goto skipend;

//.other
daW:=low__posn(da.right-da.left)+1;
daH:=low__posn(da.bottom-da.top)+1;
saW:=low__posn(sa.right-sa.left)+1;
saH:=low__posn(sa.bottom-sa.top)+1;
dx1:=frcrange32(da.left,0,dw-1);
dx2:=frcrange32(da.right,0,dw-1);
dy1:=frcrange32(da.top,0,dh-1);
dy2:=frcrange32(da.bottom,0,dh-1);

//.check area -> do nothing
if (daw=0) or (dah=0) or (saw=0) or (sah=0) then goto skipend;
if (sa.right<sa.left) or (sa.bottom<sa.top) or (da.right<da.left) or (da.bottom<da.top) then goto skipend;
if (dx2<dx1) or (dy2<dy1) then goto skipend;

//.mx (mapped dx) - highly optimised - 06sep2017
if not low__createint(_mx,'copyareaxx_mx.'+intstr32(daW)+'.0.'+intstr32(sa.left)+'.'+intstr32(sa.right)+'.'+intstr32(saW),bol1) then goto skipend;
if not bol1 then
   begin
   //init
   _mx.setparams(daW,daW,0);
   mx:=_mx.core;
   //get
   for p:=0 to (daW-1) do mx[p]:=frcrange32(sa.left+trunc(p*(saW/daW)),sa.left,sa.right);//06apr2017
   end;
mx:=_mx.core;

//.my (mapped dy) - highly optimised - 06sep2017
if not low__createint(_my,'copyareaxx_my.'+intstr32(daH)+'.0.'+intstr32(sa.top)+'.'+intstr32(sa.bottom)+'.'+intstr32(saH),bol1) then goto skipend;
if not bol1 then
   begin
   //init
   _my.setparams(daH,daH,0);
   my:=_my.core;
   //get
   for p:=0 to (daH-1) do my[p]:=frcrange32(sa.top+trunc(p*(saH/daH)),sa.top,sa.bottom);//24SEP2011
   end;
my:=_my.core;


//draw color pixels ------------------------------------------------------------
v.ca:=255;

//dy
for dy:=d3 to d4 do
   begin
   //.ar
   if xflip then sy:=my[(da.bottom-da.top)-(dy-da.top)] else sy:=my[dy-da.top];//zero base

   //.sy
   if (sy>=0) and (sy<sH) then
      begin
      if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;
      if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;


      //dx

      //.32 -> 32
      if (sbits=32) and (dbits=32) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgra32:=sr32[sx];
               dr32[dx]:=v.bgra32;
               end;
            end;//dx
         end

      //.32 -> 24
      else if (sbits=32) and (dbits=24) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgra32:=sr32[sx];
               dr24[dx]:=v.bgr24;
               end;
            end;//dx
         end

      //.32 -> 8
      else if (sbits=32) and (dbits=8) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgra32:=sr32[sx];
               if (v.bgra32.g>v.bgra32.r) then v.bgra32.r:=v.bgra32.g;
               if (v.bgra32.b>v.bgra32.r) then v.bgra32.r:=v.bgra32.b;
               dr8[dx]:=v.bgra32.r;
               end;
            end;//dx
         end

      //.24 -> 32
      else if (sbits=24) and (dbits=32) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgr24 :=sr24[sx];
               dr32[dx]:=v.bgra32;
               end;
            end;//dx
         end

      //.24 -> 24
      else if (sbits=24) and (dbits=24) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgr24:=sr24[sx];
               dr24[dx]:=v.bgr24;
               end;
            end;//dx
         end

      //.24 -> 8
      else if (sbits=24) and (dbits=8) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgr24:=sr24[sx];
               if (v.bgr24.g>v.bgr24.r) then v.bgr24.r:=v.bgr24.g;
               if (v.bgr24.b>v.bgr24.r) then v.bgr24.r:=v.bgr24.b;
               dr8[dx]:=v.bgr24.r;
               end;
            end;//dx
         end

      //.8 -> 32
      else if (sbits=8) and (dbits=32) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgra32.r:=sr8[sx];
               v.bgra32.g:=v.bgra32.r;
               v.bgra32.b:=v.bgra32.r;
               dr32[dx]:=v.bgra32;
               end;
            end;//dx
         end

      //.8 -> 24
      else if (sbits=8) and (dbits=24) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgr24.r:=sr8[sx];
               v.bgr24.g:=v.bgr24.r;
               v.bgr24.b:=v.bgr24.r;
               dr24[dx]:=v.bgr24;
               end;
            end;//dx
         end

      //.8 -> 8
      else if (sbits=8) and (dbits=8) then
         begin
         for dx:=d1 to d2 do
            begin
            if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
            if (sx>=0) and (sx<sW) then
               begin
               v.bgr24.r:=sr8[sx];
               dr8[dx]:=v.bgr24.r;
               end;
            end;//dx
         end;

      end;
   end;//dy

//successful
result:=true;
skipend:
except;end;
low__freeint(_mx);
low__freeint(_my);
end;

function mis__copyAVE82432(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;dsmoothresampling:boolean):boolean;//06jun2025, 09may2025 - barebones "average" pixel copier/resampler
label
   skipend;
var
   dr32,sr32,sr322:pcolorrow32;//25apr2020
   dr24,sr24,sr242:pcolorrow24;
   dr8 ,sr8 ,sr82 :pcolorrow8;
   d32,c32:tcolor32;
   c24:tcolor24;
   c8 :tcolor8;
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support
   p,daW,daH,saW,saH:longint;
   d1,d2,d3,d4:longint;//x-pixel(d) and y-pixel(d) speed optimisers -> represent ACTUAL d.area needed to be processed - 05sep2017
   //.image values
   sw,sh,sbits:longint;
   shasai:boolean;
   dw,dh,dbits:longint;
   dhasai:boolean;
   //.other
   dx,dy,sx,sx2,sy,sy2,xoffset,yoffset:longint;
   ex1,ex2,ey1,ey2:longint;
   p255,dx1,dx2,dy1,dy2:longint;
   y2OK,bol1,xmirror,xflip:boolean;
   da:twinrect;

   function cint32(x:currency):longint;
   begin//Note: Clip a 64bit integer to a 32bit integer range
   if (x>max32) then x:=max32
   else if (x<min32) then x:=min32;
   result:=trunc(x);
   end;

   procedure ppAdd32;
   var
      v1,v2,da,daBIG:longint;
   begin
   //check
   if (c32.a=255) then
      begin
      d32:=c32;
      exit;
      end;

   //get
   v2:=d32.a*(255-c32.a);
   da:=c32.a + (v2 div 255);//must div by 255 exactly, otherwise subtle color loss creeps in damaging the image

   if (c32.a>=1) then
      begin
      v1   :=c32.a*255;
      daBIG:=v1 + v2;

      d32.r:=( (c32.r*v1) + (d32.r*v2) ) div daBIG;
      d32.g:=( (c32.g*v1) + (d32.g*v2) ) div daBIG;
      d32.b:=( (c32.b*v1) + (d32.b*v2) ) div daBIG;
      end;

   d32.a:=da;
   end;

   procedure xadd(const x:longint;y2,xfirst:boolean);
   begin
   //get
   case sbits of
   32:begin
      if y2 then c32:=sr322[x] else c32:=sr32[x];
      end;
   24:begin
      if y2 then c24:=sr242[x] else c24:=sr24[x];
      c32.r:=c24.r;
      c32.g:=c24.g;
      c32.b:=c24.b;
      c32.a:=255;
      end;
   8: begin
      if y2 then c8:=sr82[x] else c8:=sr8[x];
      c32.r:=c8;
      c32.g:=c8;
      c32.b:=c8;
      c32.a:=255;
      end;
   end;//case

   //set
   if xfirst then d32:=c32 else ppAdd32;
   end;
begin
//defaults
result:=false;
_mx   :=nil;
_my   :=nil;

try
//check
if (sa.right<sa.left) or (sa.bottom<sa.top) then goto skipend;
if not misinfo82432(s,sbits,sw,sh,shasai)   then goto skipend;
if not misinfo82432(d,dbits,dw,dh,dhasai)   then goto skipend;

//.mirror + flip
xmirror:=(ddw<0);
if xmirror then ddw:=-ddw;

xflip  :=(ddh<0);
if xflip   then ddh:=-ddh;

da.left:=cint32(ddx);
da.right:=cint32(ddx)+cint32(ddw-1);
da.top:=cint32(ddy);
da.bottom:=cint32(ddy)+cint32(ddh-1);

//.da_clip - limit to dimensions of "d" - 05sep2017
da_clip.left:=frcrange32(da_clip.left,0,dw-1);
da_clip.right:=frcrange32(da_clip.right,da_clip.left,dw-1);
da_clip.top:=frcrange32(da_clip.top,0,dH-1);
da_clip.bottom:=frcrange32(da_clip.bottom,0,dH-1);

//.optimise actual x-pixels scanned -> d1 + d2 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d1:=largest32(largest32(da.left,da_clip.left),0);//range: 0..max32
d2:=smallest32(smallest32(da.right,da_clip.right),dw-1);//range: min32..dw-1
if (d2<d1) then goto skipend;

//.optimise actual y-pixels scanned -> d3 + d4 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d3:=largest32(largest32(da.top,da_clip.top),0);//range: 0..max32
d4:=smallest32(smallest32(da.bottom,da_clip.bottom),dH-1);//range: min32..dh-1
if (d4<d3) then goto skipend;

//.other
daW:=low__posn(da.right-da.left)+1;
daH:=low__posn(da.bottom-da.top)+1;
saW:=low__posn(sa.right-sa.left)+1;
saH:=low__posn(sa.bottom-sa.top)+1;
dx1:=frcrange32(da.left,0,dw-1);
dx2:=frcrange32(da.right,0,dw-1);
dy1:=frcrange32(da.top,0,dh-1);
dy2:=frcrange32(da.bottom,0,dh-1);

//.check area -> do nothing
if (daw=0) or (dah=0) or (saw=0) or (sah=0) then goto skipend;
if (sa.right<sa.left) or (sa.bottom<sa.top) or (da.right<da.left) or (da.bottom<da.top) then goto skipend;
if (dx2<dx1) or (dy2<dy1) then goto skipend;

//.mx (mapped dx) - highly optimised - 06sep2017
if not low__createint(_mx,'copyareaxx_mx.'+intstr32(daW)+'.0.'+intstr32(sa.left)+'.'+intstr32(sa.right)+'.'+intstr32(saW),bol1) then goto skipend;
if not bol1 then
   begin
   //init
   _mx.setparams(daW,daW,0);
   mx:=_mx.core;
   //get
   for p:=0 to (daW-1) do mx[p]:=frcrange32(sa.left+trunc(p*(saW/daW)),sa.left,sa.right);//06apr2017
   end;
mx:=_mx.core;

//.my (mapped dy) - highly optimised - 06sep2017
if not low__createint(_my,'copyareaxx_my.'+intstr32(daH)+'.0.'+intstr32(sa.top)+'.'+intstr32(sa.bottom)+'.'+intstr32(saH),bol1) then goto skipend;
if not bol1 then
   begin
   //init
   _my.setparams(daH,daH,0);
   my:=_my.core;
   //get
   for p:=0 to (daH-1) do my[p]:=frcrange32(sa.top+trunc(p*(saH/daH)),sa.top,sa.bottom);//24SEP2011
   end;
my:=_my.core;


//.offsets -> calc the rounding errors and store in x/yoffset vars
xoffset:=trunc( (daW-1)*(saW/daW) );
xoffset:=(saW-1)-xoffset;

yoffset:=trunc( (daH-1)*(saH/daH) );
yoffset:=(saH-1)-yoffset;

ex1:=0   +xoffset;
ex2:=sW-1-xoffset;
ey1:=0   +yoffset;
ey2:=sH-1-yoffset;

//draw color pixels ------------------------------------------------------------
//dy
for dy:=d3 to d4 do
   begin

   //sy & sy2
   if xflip then sy :=my[(da.bottom-da.top)-(dy-da.top)] else sy :=my[dy-da.top];//zero base
   sy2:=sy+yoffset;

   //get
   if (sy>=0) and (sy<sH) then
      begin
      //.d
      if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;

      //.sy
      if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
      y2OK:=(sy2>=0) and (sy2<sH) and ( dsmoothresampling or (sy2<=ey1) or (sy2>=ey2) ) and misscan82432(s,sy2,sr82,sr242,sr322);

      for dx:=d1 to d2 do
      begin

      //sx & sx2
      if xmirror then sx :=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
      sx2:=sx+xoffset;

      if (sx>=0) and (sx<sW) then
         begin
         //get
         //.sy -> sx and sy2 -> sx
         xadd(sx,false,true);
         if y2OK then xadd(sx,true,false);

         //.sy -> sx2 and sy2 -> sx2
         if (sx2>=0) and (sx2<sW) and ( dsmoothresampling or (sx2<=ex1) or (sx2>=ex2) ) then
            begin
            xadd(sx2,false,false);
            if y2OK then xadd(sx2,true,false);
            end;

         //set
         case dbits of
         8:begin
            if (d32.g>d32.r) then d32.r:=d32.g;
            if (d32.b>d32.r) then d32.r:=d32.b;
            dr8[dx]:=d32.r;
            end;
         24:begin
            c24.r:=d32.r;
            c24.g:=d32.g;
            c24.b:=d32.b;
            dr24[dx]:=c24;
            end;
         32:dr32[dx]:=d32;
         end;//case
         end;//sx

      end;//dx
      end;//sy

   end;//dy

//successful
result:=true;
skipend:
except;end;
low__freeint(_mx);
low__freeint(_my);
end;

function miscopy(s,d:tobject):boolean;//27dec2024, 12feb2022
label
   skipend;
var
   //s
   sbits,sw,sh,scellcount,scellw,scellh,sdelay:longint;
   shasai:boolean;
   stransparent:boolean;
   //d
   dbits,dw,dh,dcellcount,dcellw,dcellh,ddelay:longint;
   dhasai:boolean;
   dtransparent:boolean;
begin
//defaults
result:=false;

//invalid
if zznil2(s) or zznil2(d) then goto skipend
//fast
else if zzimg(s) and zzimg(d) then result:=asimg(d).copyfrom(asimg(s))//09may2022
//moderate
else
   begin
   //.info
   if not miscells(s,sbits,sw,sh,scellcount,scellw,scellh,sdelay,shasai,stransparent) then goto skipend;
   if not miscells(d,dbits,dw,dh,dcellcount,dcellw,dcellh,ddelay,dhasai,dtransparent) then goto skipend;
   //.size
   if ((sw<>dw) or (sh<>dh)) and (not missize(d,sw,sh)) then goto skipend;//27dec2024: fixed
   //.bits
   if (sbits<>dbits) and (not missetb2(d,sbits)) then goto skipend;
   //.pixels -> full 32bit RGBA support - 15feb2022
   if not miscopyarea32(0,0,sw,sh,misarea(s),d,s) then goto skipend;
   //.ai
   if shasai and dhasai and (not misaicopy(s,d)) then goto skipend;
   end;

//successful
result:=true;
skipend:
end;

function misokex(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
begin
//defaults
result:=false;
sbits:=0;
sw:=0;
sh:=0;
shasai:=false;

//check
if system_nographics then exit;//special debug mode - 10jun2019

//get
if zznil(s,2079) then exit
else if (s is tbasicimage) then
   begin
   sw     :=(s as tbasicimage).width;
   sh     :=(s as tbasicimage).height;
   sbits  :=(s as tbasicimage).bits;
   shasai :=true;
   end
else if (s is trawimage) then
   begin
   sw     :=(s as trawimage).width;
   sh     :=(s as trawimage).height;
   sbits  :=(s as trawimage).bits;
   shasai :=true;
   end
else if (s is twinbmp) then
   begin
   sw     :=(s as twinbmp).width;
   sh     :=(s as twinbmp).height;
   sbits  :=(s as twinbmp).bits;
   shasai :=true;
   end;

//set
result:=(sw>=1) and (sh>=1) and (sbits>=1);
end;

function misok(s:tobject;var sbits,sw,sh:longint):boolean;
var
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai);
end;

function misokk(s:tobject):boolean;
var
   shasai:boolean;
   sbits,sw,sh:longint;
begin
result:=misokex(s,sbits,sw,sh,shasai);
end;

function misokai(s:tobject;var sbits,sw,sh:longint):boolean;
var
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and shasai;
end;

function misokaii(s:tobject):boolean;
var
   shasai:boolean;
   sbits,sw,sh:longint;
begin
result:=misokex(s,sbits,sw,sh,shasai) and shasai;
end;

function misok8(s:tobject;var sw,sh:longint):boolean;
var
   sbits:longint;
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and (sbits=8);
end;

function misokai8(s:tobject;var sw,sh:longint):boolean;
var
   sbits:longint;
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and (sbits=8) and shasai;
end;

function misok24(s:tobject;var sw,sh:longint):boolean;
var
   sbits:longint;
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and (sbits=24);
end;

function misok32(s:tobject;var sw,sh:longint):boolean;
var
   sbits:longint;
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and (sbits=32);
end;

function misokk24(s:tobject):boolean;
var
   sbits,sw,sh:longint;
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and (sbits=24);
end;

function misokai24(s:tobject;var sw,sh:longint):boolean;
var
   sbits:longint;
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and (sbits=24) and shasai;
end;

function misok824(s:tobject;var sbits,sw,sh:longint):boolean;
var
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24));
end;

function misok82432(s:tobject;var sbits,sw,sh:longint):boolean;
var
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24) or (sbits=32));
end;

function misok2432(s:tobject;var sbits,sw,sh:longint):boolean;//01may2025
var
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and ((sbits=24) or (sbits=32));
end;

function misokk824(s:tobject):boolean;
var
   shasai:boolean;
   sbits,sw,sh:longint;
begin
result:=misokex(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24));
end;

function misokk82432(s:tobject):boolean;
var
   shasai:boolean;
   sbits,sw,sh:longint;
begin
result:=misokex(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24) or (sbits=32));
end;

function misokai824(s:tobject;var sbits,sw,sh:longint):boolean;
var
   shasai:boolean;
begin
result:=misokex(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24)) and shasai;
end;

function misinfo(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
begin
if zznil(s,2085) then
   begin
   sbits  :=0;
   sw     :=0;
   sh     :=0;
   shasai :=false;
   result :=false;
   end
else
   begin
   sbits  :=misb(s);
   sw     :=misw(s);
   sh     :=mish(s);
   shasai :=mishasai(s);
   result :=(sw>=1) and (sh>=1) and (sbits>=1);
   end;
end;

function misinfo2432(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
begin
result:=misinfo(s,sbits,sw,sh,shasai) and ((sbits=24) or (sbits=32));
end;

function misinfo82432(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
begin
result:=misinfo(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24) or (sbits=32));
end;

function misinfo8162432(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
begin
result:=misinfo(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=16) or (sbits=24) or (sbits=32));
end;

function misinfo824(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
begin
result:=misinfo(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24));
end;

function misrows8(s:tobject;var xout:pcolorrows8):boolean;
begin
//defaults
result:=false;
xout:=nil;

//get
if zznil(s,2086) then exit
else if (s is twinbmp)     then xout:=(s as twinbmp).prows8
else if (s is trawimage)   then xout:=(s as trawimage).prows8
else if (s is tbasicimage) then xout:=(s as tbasicimage).prows8;

//set
result:=(xout<>nil);
end;

function misrows16(s:tobject;var xout:pcolorrows16):boolean;
begin
//defaults
result:=false;
xout:=nil;

//get
if zznil(s,2087) then exit
else if (s is twinbmp)     then xout:=(s as twinbmp).prows16
else if (s is trawimage)   then xout:=(s as trawimage).prows16
else if (s is tbasicimage) then xout:=(s as tbasicimage).prows16;

//set
result:=(xout<>nil);
end;

function misrows24(s:tobject;var xout:pcolorrows24):boolean;
begin
//defaults
result:=false;
xout:=nil;

//get
if zznil(s,2088) then exit
else if (s is twinbmp)     then xout:=(s as twinbmp).prows24
else if (s is trawimage)   then xout:=(s as trawimage).prows24
else if (s is tbasicimage) then xout:=(s as tbasicimage).prows24;

//set
result:=(xout<>nil);
end;

function misrows32(s:tobject;var xout:pcolorrows32):boolean;
begin
//defaults
result:=false;
xout:=nil;

//get
if zznil(s,2089) then exit
else if (s is twinbmp)     then xout:=(s as twinbmp).prows32
else if (s is trawimage)   then xout:=(s as trawimage).prows32
else if (s is tbasicimage) then xout:=(s as tbasicimage).prows32;

//set
result:=(xout<>nil);
end;

function misrows82432(s:tobject;var xout8:pcolorrows8;var xout24:pcolorrows24;var xout32:pcolorrows32):boolean;//26jan2021
begin
//defaults
result:=false;
xout8:=nil;
xout24:=nil;
xout32:=nil;

//get
if zznil(s,2090) then exit
else if (s is twinbmp) then
   begin
   xout8 :=(s as twinbmp).prows8;
   xout24:=(s as twinbmp).prows24;
   xout32:=(s as twinbmp).prows32;
   end
else if (s is trawimage) then
   begin
   xout8 :=(s as trawimage).prows8;
   xout24:=(s as trawimage).prows24;
   xout32:=(s as trawimage).prows32;
   end
else if (s is tbasicimage) then
   begin
   xout8 :=(s as tbasicimage).prows8;
   xout24:=(s as tbasicimage).prows24;
   xout32:=(s as tbasicimage).prows32;
   end;

//set
result:=(xout8<>nil) and (xout24<>nil) and (xout32<>nil);
end;

function mispixel8VAL(s:tobject;sy,sx:longint):byte;
begin
result:=mispixel8(s,sy,sx);
end;

function mispixel8(s:tobject;sy,sx:longint):tcolor8;
var
   sr8 :pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc24:tcolor24;
   sc32:tcolor32;
   sbits,sw,sh:longint;
begin
//defaults
result:=0;

//get
if misok82432(s,sbits,sw,sh) and (sx>=0) and (sx<sw) and (sy>=0) and (sy<sh) and misscan82432(s,sy,sr8,sr24,sr32) then
   begin
   //.8
   if      (sbits=8)  then result:=sr8[sx]
   //.24
   else if (sbits=24) then
      begin
      sc24:=sr24[sx];
      result:=sc24.r;
      if (sc24.g>result) then result:=sc24.g;
      if (sc24.b>result) then result:=sc24.b;
      end
   //.32
   else if (sbits=32) then
      begin
      sc32:=sr32[sx];
      result:=sc32.r;
      if (sc32.g>result) then result:=sc32.g;
      if (sc32.b>result) then result:=sc32.b;
      end;
   end;
end;

function mispixel24VAL(s:tobject;sy,sx:longint):longint;
begin
result:=c24a0__int(mispixel24(s,sy,sx));
end;

function mispixel24(s:tobject;sy,sx:longint):tcolor24;
var
   sr8 :pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc32:tcolor32;
   sbits,sw,sh:longint;
begin
//defaults
result.r:=0;
result.g:=0;
result.b:=0;

//get
if misok82432(s,sbits,sw,sh) and (sx>=0) and (sx<sw) and (sy>=0) and (sy<sh) and misscan82432(s,sy,sr8,sr24,sr32) then
   begin
   //.8
   if      (sbits=8)  then
      begin
      result.r:=sr8[sx];
      result.g:=result.r;
      result.b:=result.r;
      end
   //.24
   else if (sbits=24) then result:=sr24[sx]
   //.32
   else if (sbits=32) then
      begin
      sc32:=sr32[sx];
      result.r:=sc32.r;
      result.g:=sc32.g;
      result.b:=sc32.b;
      end;
   end;
end;

function mispixel32VAL(s:tobject;sy,sx:longint):longint;
begin
result:=c32__int(mispixel32(s,sy,sx));
end;

function mispixel32(s:tobject;sy,sx:longint):tcolor32;
var
   sr8 :pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc24:tcolor24;
   sbits,sw,sh:longint;
begin
//defaults
result.r:=0;
result.g:=0;
result.b:=0;
result.a:=0;

//get
if misok82432(s,sbits,sw,sh) and (sx>=0) and (sx<sw) and (sy>=0) and (sy<sh) and misscan82432(s,sy,sr8,sr24,sr32) then
   begin
   //.8
   if      (sbits=8)  then
      begin
      result.r:=sr8[sx];
      result.g:=result.r;
      result.b:=result.r;
      result.a:=255;
      end
   //.24
   else if (sbits=24) then
      begin
      sc24:=sr24[sx];
      result.r:=sc24.r;
      result.g:=sc24.g;
      result.b:=sc24.b;
      result.a:=255;
      end
   //.32
   else if (sbits=32) then result:=sr32[sx];
   end;
end;

function missetpixel32VAL(s:tobject;sy,sx,xval:longint):boolean;
begin
result:=missetpixel32(s,sy,sx,int__c32(xval));
end;

function missetpixel32(s:tobject;sy,sx:longint;xval:tcolor32):boolean;
var
   sr8 :pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc24:tcolor24;
   sbits,sw,sh:longint;
begin
//defaults
result:=false;

//get
if misok82432(s,sbits,sw,sh) and (sx>=0) and (sx<sw) and (sy>=0) and (sy<sh) and misscan82432(s,sy,sr8,sr24,sr32) then
   begin
   //.8
   if      (sbits=8)  then
      begin
      sc24.r:=xval.r;
      sc24.g:=xval.g;
      sc24.b:=xval.b;
      sr8[sx]:=c24__greyscale2(sc24);
      end
   //.24
   else if (sbits=24) then
      begin
      sc24.r:=xval.r;
      sc24.g:=xval.g;
      sc24.b:=xval.b;
      sr24[sx]:=sc24;
      end
   //.32
   else if (sbits=32) then sr32[sx]:=xval;

   //successful
   result:=true;
   end;

end;

function misscan(s:tobject;sy:longint):pointer;//21jun2024
var
   sw,sh:longint;
begin
//defaults
result:=nil;

//check
if zznil(s,2093) then exit;

//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;

//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage)                       then result:=(s as tbasicimage).prows24[sy]
else if (s is twinbmp)                      then result:=(s as twinbmp).prows24[sy]
else if (s is trawimage)                    then result:=(s as trawimage).prows24[sy];
end;

function misscan82432(s:tobject;sy:longint;var sr8:pcolorrow8;var sr24:pcolorrow24;var sr32:pcolorrow32):boolean;//26jan2021
var
   sw,sh:longint;
begin
//defaults
result:=false;
sr8:=nil;
sr24:=nil;
sr32:=nil;

//check
if zznil(s,2091) then exit;

//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;

//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage) then
   begin
   sr8 :=(s as tbasicimage).prows8[sy];
   sr24:=(s as tbasicimage).prows24[sy];
   sr32:=(s as tbasicimage).prows32[sy];
   end
else if (s is twinbmp) then
   begin
   sr8 :=(s as twinbmp).prows8[sy];
   sr24:=(s as twinbmp).prows24[sy];
   sr32:=(s as twinbmp).prows32[sy];
   end
else if (s is trawimage) then
   begin
   sr8 :=(s as trawimage).prows8[sy];
   sr24:=(s as trawimage).prows24[sy];
   sr32:=(s as trawimage).prows32[sy];
   end
else exit;

//successful
result:=(sr8<>nil) and (sr24<>nil) and (sr32<>nil);
end;

function misscan8(s:tobject;sy:longint;var sr8:pcolorrow8):boolean;//26jan2021
var
   sw,sh:longint;
begin
//defaults
result:=false;
sr8:=nil;

//check
if zznil(s,2092) then exit;

//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;

//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage) then
   begin
   sr8 :=(s as tbasicimage).prows8[sy];
   end
else if (s is twinbmp) then
   begin
   sr8 :=(s as twinbmp).prows8[sy];
   end
else if (s is trawimage) then
   begin
   sr8 :=(s as trawimage).prows8[sy];
   end
else exit;

//successful
result:=(sr8<>nil);
end;

function misscan16(s:tobject;sy:longint;var sr16:pcolorrow16):boolean;//03aug2024
var
   sw,sh:longint;
begin
//defaults
result:=false;
sr16:=nil;

//check
if zznil(s,2092) then exit;

//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;

//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage) then
   begin
   sr16:=(s as tbasicimage).prows16[sy];
   end
else if (s is twinbmp) then
   begin
   sr16:=(s as twinbmp).prows16[sy];
   end
else if (s is trawimage) then
   begin
   sr16:=(s as trawimage).prows16[sy];
   end
else exit;

//successful
result:=(sr16<>nil);
end;

function misscan24(s:tobject;sy:longint;var sr24:pcolorrow24):boolean;//26jan2021
var
   sw,sh:longint;
begin
//defaults
result:=false;
sr24:=nil;

//check
if zznil(s,2093) then exit;

//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;

//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage) then
   begin
   sr24:=(s as tbasicimage).prows24[sy];
   end
else if (s is twinbmp) then
   begin
   sr24:=(s as twinbmp).prows24[sy];
   end
else if (s is trawimage) then
   begin
   sr24:=(s as trawimage).prows24[sy];
   end
else exit;

//successful
result:=(sr24<>nil);
end;

function misscan32(s:tobject;sy:longint;var sr32:pcolorrow32):boolean;//26jan2021
var
   sw,sh:longint;
begin
//defaults
result:=false;
sr32:=nil;

//check
if zznil(s,2099) then exit;

//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;

//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage) then
   begin
   sr32:=(s as tbasicimage).prows32[sy];
   end
else if (s is twinbmp) then
   begin
   sr32:=(s as twinbmp).prows32[sy];
   end
else if (s is trawimage) then
   begin
   sr32:=(s as trawimage).prows32[sy];
   end
else exit;

//successful
result:=(sr32<>nil);
end;

function misscan96(s:tobject;sy:longint;var sr96:pcolorrow96):boolean;//03aug2024
var
   sw,sh:longint;
begin
//defaults
result:=false;
try
sr96:=nil;
//check
if zznil(s,2093) then exit;
//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;
//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage)    then ptr__copy((s as tbasicimage).prows24[sy],sr96)
else if (s is twinbmp)   then ptr__copy((s as twinbmp).prows24[sy],sr96)
else if (s is trawimage) then ptr__copy((s as trawimage).prows24[sy],sr96)
else                          exit;

//successful
result:=(sr96<>nil);
except;end;
end;

function misscan2432(s:tobject;sy:longint;var sr24:pcolorrow24;var sr32:pcolorrow32):boolean;//26jan2021
var
   sw,sh:longint;
begin
//defaults
result:=false;
sr24:=nil;
sr32:=nil;

try
//check
if zznil(s,2100) then exit;

//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;

//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage) then
   begin
   sr24:=(s as tbasicimage).prows24[sy];
   sr32:=(s as tbasicimage).prows32[sy];
   end
else if (s is twinbmp) then
   begin
   sr24:=(s as twinbmp).prows24[sy];
   sr32:=(s as twinbmp).prows32[sy];
   end
else if (s is trawimage) then
   begin
   sr24:=(s as trawimage).prows24[sy];
   sr32:=(s as trawimage).prows32[sy];
   end
else exit;

//successful
result:=(sr24<>nil) and (sr32<>nil);
except;end;
end;

function misscan824(s:tobject;sy:longint;var sr8:pcolorrow8;var sr24:pcolorrow24):boolean;//26jan2021
var
   sw,sh:longint;
begin
//defaults
result:=false;

try
sr8:=nil;
sr24:=nil;
//check
if zznil(s,2101) then exit;
//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;
//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage) then
   begin
   sr8 :=(s as tbasicimage).prows8[sy];
   sr24:=(s as tbasicimage).prows24[sy];
   end
else if (s is twinbmp) then
   begin
   sr8 :=(s as twinbmp).prows8[sy];
   sr24:=(s as twinbmp).prows24[sy];
   end
else if (s is trawimage) then
   begin
   sr8 :=(s as trawimage).prows8[sy];
   sr24:=(s as trawimage).prows24[sy];
   end
else exit;
//successful
result:=(sr8<>nil) and (sr24<>nil);
except;end;
end;

function misscan832(s:tobject;sy:longint;var sr8:pcolorrow8;var sr32:pcolorrow32):boolean;//14feb2022
var
   sw,sh:longint;
begin
//defaults
result:=false;

try
sr8:=nil;
sr32:=nil;
//check
if zznil(s,2101) then exit;
//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;
//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;

//get
if (s is tbasicimage) then
   begin
   sr8 :=(s as tbasicimage).prows8[sy];
   sr32:=(s as tbasicimage).prows32[sy];
   end
else if (s is twinbmp) then
   begin
   sr8 :=(s as twinbmp).prows8[sy];
   sr32:=(s as twinbmp).prows32[sy];
   end
else if (s is trawimage) then
   begin
   sr8 :=(s as trawimage).prows8[sy];
   sr32:=(s as trawimage).prows32[sy];
   end
else exit;
//successful
result:=(sr8<>nil) and (sr32<>nil);
except;end;
end;

function misimg(dbits,dw,dh:longint):tbasicimage;
begin
result:=tbasicimage.create;
if (result<>nil) then result.setparams(dbits,frcmin32(dw,1),frcmin32(dh,1));
end;

function misimg8(dw,dh:longint):tbasicimage;//26jan2021
begin
result:=misimg(8,dw,dh);
end;

function misimg24(dw,dh:longint):tbasicimage;
begin
result:=misimg(24,dw,dh);
end;

function misimg32(dw,dh:longint):tbasicimage;
begin
result:=misimg(32,dw,dh);
end;

function misraw(dbits,dw,dh:longint):trawimage;
begin
result:=trawimage.create;
if (result<>nil) then result.setparams(dbits,frcmin32(dw,1),frcmin32(dh,1));
end;

function misraw8(dw,dh:longint):trawimage;//26jan2021
begin
result:=misraw(8,dw,dh);
end;

function misraw24(dw,dh:longint):trawimage;
begin
result:=misraw(24,dw,dh);
end;

function misraw32(dw,dh:longint):trawimage;
begin
result:=misraw(32,dw,dh);
end;

function miswin(dbits,dw,dh:longint):twinbmp;
begin
result:=twinbmp.create;
if (result<>nil) then result.setparams(dbits,frcmin32(dw,1),frcmin32(dh,1));
end;

function miswin8(dw,dh:longint):twinbmp;
begin
result:=miswin(8,dw,dh);
end;

function miswin24(dw,dh:longint):twinbmp;
begin
result:=miswin(24,dw,dh);
end;

function miswin32(dw,dh:longint):twinbmp;
begin
result:=miswin(32,dw,dh);
end;

function misatleast(s:tobject;dw,dh:longint):boolean;//26jul2021
label
   skipend;
begin
//defaults
result:=false;

try
//check
if zznil(s,101) then exit;
//get
if (dw<=0) or (dh<=0) then
   begin
   result:=true;
   exit;
   end;
if (misw(s)<dw) or (mish(s)<dh) then
   begin
   if not missize(s,dw+100,dh+100) then goto skipend;
   end;
//successful
result:=true;
skipend:
except;end;
end;

function missize(s:tobject;dw,dh:longint):boolean;
begin
result:=missize2(s,dw,dh,false);
end;

function missize2(s:tobject;dw,dh:longint;xoverridelock:boolean):boolean;
label
   skipend;
begin
//defaults
result:=false;

try
//check
if zznil(s,2102) then exit;
//range
dw:=frcmin32(dw,1);
dh:=frcmin32(dh,1);
//.image
if      (s is tbasicimage) then result:=(s as tbasicimage).sizeto(dw,dh)
//.sysimage
else if (s is twinbmp)     then result:=(s as twinbmp).setparams((s as twinbmp).bits,dw,dh)
//.rawimage
else if (s is trawimage)   then result:=(s as trawimage).setparams((s as trawimage).bits,dw,dh);

skipend:
except;end;
end;

function mis__countcolors257(s:tobject):longint;//limited color counter -> counts up to 257 colors - 14may2025
label
   skipend;
const
   psize=257;
var
   plist:array[0..(psize-1)] of tcolor32;
   sbits,sx,sy,sw,sh:longint;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   c32 :tcolor32;
   c24 :tcolor24;

   function pfind(var pcount:longint):boolean;
   var
      p:longint;
   begin
   //defaults
   result:=false;

   //find
   for p:=0 to (pcount-1) do if (c32.r=plist[p].r) and (c32.g=plist[p].g) and (c32.b=plist[p].b) then
      begin
      result:=true;
      exit;
      end;//p

   //add
   if (pcount<psize) then
      begin
      plist[pcount]:=c32;
      inc(pcount);
      result:=true;
      end;
   end;
begin
//defaults
result:=0;

try
//check
if not misok82432(s,sbits,sw,sh) then goto skipend;

//get -> count colors
//.sy
for sy:=0 to (sh-1) do
begin

if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//8
if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32.r:=sr8[sx];
   c32.g:=c32.r;
   c32.b:=c32.r;
   if not pfind(result) then goto skipend;
   end;//sx
   end
//24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   c32.r:=c24.r;
   c32.g:=c24.g;
   c32.b:=c24.b;
   if not pfind(result) then goto skipend;
   end;//sx
   end
//32
else if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   if not pfind(result) then goto skipend;
   end;//sx
   end;

end;//sy

skipend:
except;end;
end;

function misfindunusedcolor(i:tobject):longint;//23mar2025
var
   xcolorcount,xmaskcount:longint;
begin
miscountcolors4(maxarea,i,nil,xcolorcount,xmaskcount,result,true);
end;

function miscountcolors(i:tobject):longint;//full color count - uses dynamic memory (2mb) - 15OCT2009
begin
result:=miscountcolors2(maxarea,i,nil);
end;

function miscountcolors2(da_clip:twinrect;i,xsel:tobject):longint;//full color count - uses dynamic memory (2mb) - 19sep2018, 15OCT2009
var
   int1:longint;
begin
miscountcolors3(da_clip,i,xsel,result,int1);
end;

function miscountcolors3(da_clip:twinrect;i,xsel:tobject;var xcolorcount,xmaskcount:longint):boolean;//full color count - uses dynamic memory (2mb) - 19sep2018, 15OCT2009
var
   xcolornotused:longint;
begin
result:=miscountcolors4(da_clip,i,xsel,xcolorcount,xmaskcount,xcolornotused,false);
end;

function miscountcolors4(da_clip:twinrect;i,xsel:tobject;var xcolorcount,xmaskcount:longint;var xunusedcolor:longint;xfindunusedcolor:boolean):boolean;//full color count - uses dynamic memory (2mb) - 23mar2025: findunusedcolor option added, 19sep2018, 15OCT2009
label
   skipend;
const
   maxp=2097152;
type
   pcs=^tcs;
   tcs=array[0..maxp] of set of 0..7;
var//~580ms for a 1152x864 [24bit] with 362,724 colors
   //Dynamic memory used now instead of limited stack - 15OCT2009
   xcolorindex,xselw,xselh,iw,ih,ibits,xselbits,p,ci,ip,rx,ry:longint;
   a32:pcolorrow32;
   a24,xselr24:pcolorrow24;
   a8,xselr8:pcolorrow8;
   b:tdynamicbyte;
   z32:tcolor32;
   z24:tcolor24;
   ics:pcs;
   c2:set of 0..7;
   a:array[0..255] of boolean;
   xselok:boolean;

   procedure xsetunusedcolor(xoffset:longint);
   begin
   xfindunusedcolor:=false;
   xunusedcolor    :=xcolorindex+xoffset;
   end;
begin
//defaults
result      :=false;
xcolorcount :=0;
xmaskcount  :=0;
b           :=nil;
xunusedcolor:=0;

//check
if not misok82432(i,ibits,iw,ih) then exit;

try
//init
b:=tdynamicbyte.create;
b.setparams(maxp+1,maxp+1,0);
ics:=b.core;
fillchar(a,sizeof(a),#0);
//.x range
da_clip.left:=frcrange32(da_clip.left,0,iw-1);
da_clip.right:=frcrange32(da_clip.right,0,iw-1);
low__orderint(da_clip.left,da_clip.right);
//.y range
da_clip.top:=frcrange32(da_clip.top,0,ih-1);
da_clip.bottom:=frcrange32(da_clip.bottom,0,ih-1);
low__orderint(da_clip.top,da_clip.bottom);
//.xselok
xselok:=misok824(xsel,xselbits,xselw,xselh) and (xselw>=iw) and (xselh>=ih);

//get
//.ry
for ry:=da_clip.top to da_clip.bottom do
begin
if not misscan82432(i,ry,a8,a24,a32) then goto skipend;
if xselok and (not misscan824(xsel,ry,xselr8,xselr24)) then goto skipend;
//.32
if (ibits=32) then
   begin
   for rx:=da_clip.left to da_clip.right do if (xselbits=0) or ((xselbits=8) and (xselr8[rx]>=1)) or ((xselbits=24) and (xselr24[rx].r>=1)) then
   begin
   //colorcount
   //.get
   z32:=a32[rx];
   p:=z32.r+(z32.g*256)+(z32.b*65536);//0..16,777,215 -> 0..2,097,152
   ip:=p div 8;
   ci:=p-ip*8;
   //.set
   if not (ci in ics[ip]) then include(ics[ip],ci);
   //maskcount
   a[z32.a]:=true;
   end;//rx
   end
//.24
else if (ibits=24) then
   begin
   for rx:=da_clip.left to da_clip.right do if (xselbits=0) or ((xselbits=8) and (xselr8[rx]>=1)) or ((xselbits=24) and (xselr24[rx].r>=1)) then
   begin
   //.get
   z24:=a24[rx];
   p:=z24.r+z24.g*256+z24.b*65536;//0..16,777,215 -> 0..2,097,152
   ip:=p div 8;
   ci:=p-ip*8;
   //.set
   if not (ci in ics[ip]) then include(ics[ip],ci);
   end;//rx
   end
//.8
else if (ibits=8) then
   begin
   for rx:=da_clip.left to da_clip.right do if (xselbits=0) or ((xselbits=8) and (xselr8[rx]>=1)) or ((xselbits=24) and (xselr24[rx].r>=1)) then
   begin
   //colorcount
   //.get
   z24.r:=a8[rx];
   p:=z24.r+z24.r*256+z24.r*65536;//0..16,777,215 -> 0..2,097,152
   ip:=p div 8;
   ci:=p-ip*8;
   //.set
   if not (ci in ics[ip]) then include(ics[ip],ci);
   //maskcount
   a[z32.a]:=true;
   end;//rx
   end;
end;//ry

//.colorcount
if xfindunusedcolor then
   begin
   //init
   xcolorindex:=0;

   //get
   for rx:=0 to maxp do
   begin
   c2:=ics[rx];
   if (byte(c2)>=1) then//25ms faster than "(c2<>[])"
      begin
      if (0 in c2) then xcolorcount:=xcolorcount+1 else if xfindunusedcolor then xsetunusedcolor(0);
      if (1 in c2) then xcolorcount:=xcolorcount+1 else if xfindunusedcolor then xsetunusedcolor(1);
      if (2 in c2) then xcolorcount:=xcolorcount+1 else if xfindunusedcolor then xsetunusedcolor(2);
      if (3 in c2) then xcolorcount:=xcolorcount+1 else if xfindunusedcolor then xsetunusedcolor(3);
      if (4 in c2) then xcolorcount:=xcolorcount+1 else if xfindunusedcolor then xsetunusedcolor(4);
      if (5 in c2) then xcolorcount:=xcolorcount+1 else if xfindunusedcolor then xsetunusedcolor(5);
      if (6 in c2) then xcolorcount:=xcolorcount+1 else if xfindunusedcolor then xsetunusedcolor(6);
      if (7 in c2) then xcolorcount:=xcolorcount+1 else if xfindunusedcolor then xsetunusedcolor(7);
      end;
   inc(xcolorindex,8);
   end;//rx

   end
else
   begin

   for rx:=0 to maxp do
   begin
   c2:=ics[rx];
   if (byte(c2)>=1) then//25ms faster than "(c2<>[])"
      begin
      if (0 in c2) then xcolorcount:=xcolorcount+1;//faster than a loop
      if (1 in c2) then xcolorcount:=xcolorcount+1;
      if (2 in c2) then xcolorcount:=xcolorcount+1;
      if (3 in c2) then xcolorcount:=xcolorcount+1;
      if (4 in c2) then xcolorcount:=xcolorcount+1;
      if (5 in c2) then xcolorcount:=xcolorcount+1;
      if (6 in c2) then xcolorcount:=xcolorcount+1;
      if (7 in c2) then xcolorcount:=xcolorcount+1;
      end;
   end;//rx

   end;

//.maskcount
for p:=0 to high(a) do if a[p] then xmaskcount:=xmaskcount+1;

//successful
result:=true;
skipend:
except;end;
//free
freeobj(@b);
end;

function misv(s:tobject):boolean;//valid
begin
result:=(s<>nil) and ( (s is tbasicimage) or (s is trawimage) or (s is twinbmp) );
end;

function misb(s:tobject):longint;//bits 0..N
begin
//defaults
result:=0;

try
//get
if zznil(s,2072) then exit
//.image
else if (s is tbasicimage) then result:=(s as tbasicimage).bits
//.winbmp
else if (s is twinbmp)     then result:=(s as twinbmp).bits
//.rawimage
else if (s is trawimage)   then result:=(s as trawimage).bits;
except;end;
end;

procedure missetb(s:tobject;sbits:longint);
begin
try
sbits:=frcmin32(sbits,1);
if not misv(s) then exit
else if (s is tbasicimage)    then (s as tbasicimage).setparams(sbits,misw(s),mish(s))
else if (s is twinbmp)        then (s as twinbmp).setparams(sbits,misw(s),mish(s))
else if (s is trawimage)      then (s as trawimage).setparams(sbits,misw(s),mish(s));
except;end;
end;

function missetb2(s:tobject;sbits:longint):boolean;//12feb2022
begin
missetb(s,sbits);
result:=(misb(s)<>sbits);
end;

function misw(s:tobject):longint;
begin
if      (s=nil)            then result:=0
else if (s is tbasicimage) then result:=(s as tbasicimage).width
else if (s is twinbmp)     then result:=(s as twinbmp).width
else if (s is trawimage)   then result:=(s as trawimage).width
else                            result:=0;
end;

function mish(s:tobject):longint;
begin
if      (s=nil)            then result:=0
else if (s is tbasicimage) then result:=(s as tbasicimage).height
else if (s is twinbmp)     then result:=(s as twinbmp).height
else if (s is trawimage)   then result:=(s as trawimage).height
else                            result:=0;
end;

function miscw(s:tobject):longint;//cell width
var
   sbits,sw,sh,scellcount,scellh,sdelay:longint;
   shasai,stransparent:boolean;
begin
miscells(s,sbits,sw,sh,scellcount,result,scellh,sdelay,shasai,stransparent);
end;

function misch(s:tobject):longint;//cell height
var
   sbits,sw,sh,scellcount,scellw,sdelay:longint;
   shasai,stransparent:boolean;
begin
miscells(s,sbits,sw,sh,scellcount,scellw,result,sdelay,shasai,stransparent);
end;

function miscc(s:tobject):longint;//cell count
var
   sbits,sw,sh,scellw,scellh,sdelay:longint;
   shasai,stransparent:boolean;
begin
miscells(s,sbits,sw,sh,result,scellw,scellh,sdelay,shasai,stransparent);
end;

function mis__nextcell(s:tobject;var sitemindex:longint;var stimer:comp):boolean;
var
   dpos,ddelay,sbits,sw,sh,scellcount,scellw,scellh,sdelay:longint;
   stimerevent,shasai,stransparent:boolean;
begin
result:=false;
dpos:=0;
ddelay:=500;
stimerevent:=(ms64>=stimer);

if miscells(s,sbits,sw,sh,scellcount,scellw,scellh,sdelay,shasai,stransparent) and (scellcount>=2) and (sdelay>=1) then
   begin
   dpos:=misai(s).itemindex;
   ddelay:=frcrange32(sdelay,1,60000);

   //Note: "stimer>=0" check allows for host to reset the timer whilst maintaining their cellindex for smoother animation to animation transistion without cell hoping - 26jul2024
   if stimerevent and (stimer>=0) then
      begin
      inc(dpos);
      if (dpos>=scellcount) then dpos:=0;
      misai(s).itemindex:=dpos;
      end;
   end;

if (sitemindex<>dpos) then
   begin
   sitemindex:=dpos;
   result:=true;
   end;

//reset timer
if stimerevent then stimer:=add64(ms64,ddelay);
end;

function misf(s:tobject):longint;//color format
begin
//defaults
result:=cfNone;

try
//get
if zznil(s,2074) then exit
//.basicimage
else if (s is tbasicimage) then
   begin
   case (s as tbasicimage).bits of
   8: result:=cfRGB8;
   15:result:=cfRGB15;
   16:result:=cfRGB16;
   24:result:=cfRGB24;
   32:result:=cfRGBA32;
   end;
   end
//.sysimage
else if (s is twinbmp) then
   begin
   case (s as twinbmp).bits of
   8: result:=cfRGB8;
   15:result:=cfRGB15;
   16:result:=cfRGB16;
   24:result:=cfRGB24;
   32:result:=cfRGBA32;
   end;
   end
//.rawimage
else if (s is trawimage) then
   begin
   case (s as trawimage).bits of
   8: result:=cfRGB8;
   15:result:=cfRGB15;
   16:result:=cfRGB16;
   24:result:=cfRGB24;
   32:result:=cfRGBA32;
   end;
   end
else
   begin
   //nil
   end;
except;end;
end;

function mishasai(s:tobject):boolean;
begin
result:=mis__hasai(s);
end;

function misonecell(s:tobject):boolean;
begin
result:=mis__onecell(s);
end;

function miscells(s:tobject;var sbits,sw,sh,scellcount,scellw,scellh,sdelay:longint;var shasai:boolean;var stransparent:boolean):boolean;//16dec2024, 27jul2021
var
   xbits,xw,xh:longint;
   xhasai:boolean;
begin
//defaults
result:=false;
try
sbits:=0;
sw:=1;
sh:=1;
scellcount:=1;
scellw:=1;
scellh:=1;
sdelay:=500;//500 ms
shasai:=false;
stransparent:=false;
//check
if not misokex(s,xbits,xw,xh,xhasai) then exit;
//get
sbits:=xbits;
sw:=frcmin32(xw,1);
sh:=frcmin32(xh,1);
if xhasai then
   begin
   scellcount:=frcmin32(misai(s).count,1);
   stransparent:=misai(s).transparent;
   sdelay:=frcmin32(misai(s).delay,0);//16dec2024: allow to zero out
   end;
shasai:=xhasai;
scellw:=frcmin32(trunc(sw/scellcount),1);
scellh:=sh;
//successful
result:=true;
except;end;
end;

function miscell(s:tobject;sindex:longint;var scellarea:twinrect):boolean;
var
   sms,sbits,sw,sh,scellcount,scellw,scellh:longint;
   shasai:boolean;
   stransparent:boolean;
begin
//defaults
result:=false;

try
scellarea:=nilarea;
//get
if miscells(s,sbits,sw,sh,scellcount,scellw,scellh,sms,shasai,stransparent) then
   begin
   //range
   sindex:=frcrange32(sindex,0,scellcount-1);
   //get
   scellarea.left:=sindex*scellw;
   scellarea.right:=scellarea.left+scellw-1;
   scellarea.top:=0;
   scellarea.bottom:=scellh-1;
   result:=true;
   end;
except;end;
end;

function miscell2(s:tobject;sindex:longint):twinrect;
begin
miscell(s,sindex,result);
end;

function miscellarea(s:tobject;sindex:longint):twinrect;
begin
miscell(s,sindex,result);
end;

function misaiclear2(s:tobject):boolean;
begin
result:=(s<>nil) and misaiclear(misai(s)^);
end;

function misaiclear(var x:tanimationinformation):boolean;
begin
//defaults
result:=false;

try
//get
with x do
begin
binary:=true;
format:='';
subformat:='';
info:='';//22APR2012
filename:='';
map16:='';//Warning: won't work under D10 - 21aug2020
transparent:=false;
syscolors:=false;
flip:=false;
mirror:=false;
delay:=0;
itemindex:=0;
count:=1;
bpp:=24;
//cursor - 20JAN2012
hotspotX:=0;
hotspotY:=0;
hotspotMANUAL:=false;//use system generated AUTOMATIC hotspot - 03jan2019
//special
owrite32bpp:=false;//22JAN2012
//final
readb64:=false;
readb128:=false;
writeb64:=false;
writeb128:=false;
//internal
iosplit:=0;//none
cellwidth:=0;
cellheight:=0;
use32:=false;
end;
//successful
result:=true;
except;end;
end;

function misai(s:tobject):panimationinformation;
begin
result:=mis__ai(s);
end;

function low__aicopy(var s,d:tanimationinformation):boolean;
begin
//defaults
result           :=false;

try
//get
d.format         :=s.format;
d.subformat      :=s.subformat;
d.filename       :=s.filename;
d.map16          :=s.map16;
d.transparent    :=s.transparent;
d.syscolors      :=s.syscolors;//13apr2021
d.flip           :=s.flip;
d.mirror         :=s.mirror;
d.delay          :=s.delay;
d.itemindex      :=s.itemindex;
d.count          :=s.count;
d.bpp            :=s.bpp;
d.owrite32bpp    :=s.owrite32bpp;
d.binary         :=s.binary;
d.readB64        :=s.readB64;
d.readB128       :=s.readB128;
d.readB128       :=s.readB128;
d.writeB64       :=s.writeB64;
d.writeB128      :=s.writeB128;
d.iosplit        :=s.iosplit;
d.cellwidth      :=s.cellwidth;
d.cellheight     :=s.cellheight;
d.use32          :=s.use32;//22may2022
//.special - 10jul2019
d.hotspotMANUAL  :=s.hotspotMANUAL;
d.hotspotX       :=s.hotspotX;
d.hotspotY       :=s.hotspotY;
//successful
result           :=true;
except;end;
end;

function misaicopy(s,d:tobject):boolean;
begin
if mishasai(d) then
   begin
   if mishasai(s) then result:=low__aicopy(misai(s)^,misai(d)^) else result:=misaiclear(misai(d)^);
   end
else result:=false;
end;

function mis__drawdigits(s:tobject;dcliparea:twinrect;dx,dy,dfontsize,dcolor:longint;x:string;xbold,xdraw:boolean;var dwidth,dheight:longint):boolean;
begin
result:=mis__drawdigits2(s,dcliparea,dx,dy,dfontsize,dcolor,2,x,xbold,xdraw,dwidth,dheight);
end;

function mis__drawdigits2(s:tobject;dcliparea:twinrect;dx,dy,dfontsize,dcolor:longint;dheightscale:extended;x:string;xbold,xdraw:boolean;var dwidth,dheight:longint):boolean;
label
   skipdone,skipend;
//Draws a series of square numerical digits without the need of tcanvas, tbitmap, tfont or the need for a font
// =====
// | | |
// =====
// | | |
// =====
var
   odx,v1,v2,v3,v4,v5,v6,h1,h2,h3,h4,ddiff,dthick0,dthick,p,x1,x2,y1,y2,dw,dh,dgap,xlen,sbits,sw,sh:longint;
   sai:boolean;
   prows32:pcolorrows32;
   prows24:pcolorrows24;
   prows8 :pcolorrows8;
   c32:tcolor32;
   c24:tcolor24;
    c8:tcolor8;

   procedure xdrawarea(dx1,dx2,dy1,dy2:longint);
   var
      px,py:longint;
   begin
   //scale
   dx1:=dx+dx1;
   dx2:=dx+dx2;
   dy1:=dy+dy1;
   dy2:=dy+dy2;
   //get
   if xdraw then
      begin
      for py:=dy1 to dy2 do
      begin
      if (py>=y1) and (py<=y2) and (py>=dy) then
         begin
         case sbits of
         32:for px:=dx1 to dx2 do if (px>=x1) and (px<=x2) and (px>=odx) then prows32[py][px]:=c32;
         24:for px:=dx1 to dx2 do if (px>=x1) and (px<=x2) and (px>=odx) then prows24[py][px]:=c24;
          8:for px:=dx1 to dx2 do if (px>=x1) and (px<=x2) and (px>=odx) then prows8 [py][px]:=c8;
          end;//case
          end;
      end;//py
      end;
   //.inc size
   dwidth:=largest32(dwidth,dx2-odx+1);
   dheight:=largest32(dheight,dy2-dy+1);
   end;

   procedure xdrawdigit(xdigit:longint;xincludegap:boolean);
   label
      skipdone;
   var
      int1:longint;

      procedure b(x:longint);
      begin
      case x of
      0:xdrawarea(h1,h4,v1,v2);//top horizontal
      1:xdrawarea(h1,h2,v1,v4);//left-top vertical
      2:xdrawarea(h3,h4,v1,v4);//right-top vertical
      3:xdrawarea(h1,h4,v3,v4);//middle horizontal
      4:xdrawarea(h1,h2,v3,v6);//left-bottom vertical
      5:xdrawarea(h3,h4,v3,v6);//right-bottom vertical
      6:xdrawarea(h1,h4,v5,v6);//bottom horizontal
      end;//case
      end;
   begin
   //decide
   case xdigit of
   //.space
   32:inc(dwidth,dw);
   //.plus
   43:begin
      xdrawarea(dthick0*2,dthick0*3-1+ddiff,dthick0,dh-1-dthick0);//v
      xdrawarea(0,dthick0*5-1+ddiff,v3,v4);//h
      end;
   //.comma
   44:begin
      int1:=dthick0;
      xdrawarea(int1+h1+dthick,int1+h1+(2*dthick)-1,v5-(2*dthick0),v6);
      xdrawarea(int1+h1,int1+h2,v5,v6);
      end;
   //.minus
   45:xdrawarea(h1,h4,v3,v4);
   //.dot
   46:xdrawarea(h1,h1+(2*dthick)-1,v6-(dthick*2)+1,v6);
   //.0-9 = 48..57
   48:begin; b(0);b(1);b(2);b(4);b(5);b(6); end;
   49:begin; b(1);b(4); end;
   50:begin; b(0);b(2);b(3);b(4);b(6); end;
   51:begin; b(0);b(2);b(3);b(5);b(6); end;
   52:begin; b(1);b(2);b(3);b(5); end;
   53:begin; b(0);b(1);b(3);b(5);b(6); end;
   54:begin; b(0);b(1);b(3);b(4);b(5);b(6); end;
   55:begin; b(0);b(2);b(5); end;
   56:begin; b(0);b(1);b(2);b(3);b(4);b(5);b(6); end;
   57:begin; b(0);b(1);b(2);b(3);b(5);b(6); end;
   //.A-Z
   65:begin; b(0);b(1);b(4);b(2);b(5);b(3); end;

   else goto skipdone;
   end;

   //done
   skipdone:
   //dx
   dx:=odx+dwidth+low__insint(dgap,xincludegap);
   end;
begin
//defaults
result:=false;

try
dwidth:=0;
dheight:=0;
odx:=dx;
sbits:=8;
sw:=0;
sh:=0;

//heightscale in %
if (dheightscale<=0)        then dheightscale:=4
else if (dheightscale<1)    then dheightscale:=1
else if (dheightscale>10)   then dheightscale:=10;

//check
if xdraw then
   begin
   if not misinfo82432(s,sbits,sw,sh,sai) then exit;
   if (not validarea(dcliparea)) or (dcliparea.right<0) or (dcliparea.left>=sw) or (dcliparea.bottom<0) or (dcliparea.top>=sh) then goto skipdone;
   end;

//convert font height (negative px values) into font size (font width)
if (dfontsize<0) then dfontsize:=round(-dfontsize/dheightscale);

//range
dfontsize:=frcrange32(dfontsize,3,5000);

//init
xlen:=low__len(x);
if (xlen<=0) then goto skipdone;
dthick0:=frcmax32(frcmin32(dfontsize div 5,1),dfontsize div 3);
dthick:=frcmax32(frcmin32(dfontsize div low__aorb(5,2,xbold),1),dfontsize div 3);
ddiff:=dthick-dthick0;
dgap:=dthick*4;//easy to view the numbers at low font size
dw:=dfontsize;
dh:=frcmin32(round(dw*dheightscale),1);

//cliparea tied to safe image area
if xdraw then
   begin
   x1:=frcrange32(dcliparea.left,0,sw-1);
   x2:=frcrange32(dcliparea.right,x1,sw-1);
   y1:=frcrange32(dcliparea.top,0,sh-1);
   y2:=frcrange32(dcliparea.bottom,y1,sh-1);
   //check
   if (dx>x2) or (dy>y2) then goto skipdone;
   end;

//colors + rows
if xdraw then
   begin
   c32:=int__c32(dcolor);
   c24:=int__c24(dcolor);
   c8:=c24__greyscale2(c24);
   //rows8-32
   if not misrows82432(s,prows8,prows24,prows32) then goto skipend;
   end;

//inner dimensions
v1:=0;
v2:=v1+dthick-1;

v3:=(dh div 2) - (dthick div 2);
v4:=v3+dthick-1;

v5:=dh-1-(dthick-1);
v6:=dh-1;

h1:=0;
h2:=dthick-1;
h3:=dw-1-(dthick-1);
h4:=dw-1;

//get
for p:=1 to xlen do xdrawdigit(byte(x[p-1+stroffset]),p<xlen);

//successful
skipdone:
result:=true;
skipend:
except;end;
end;

function miscopyareaxx(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xpower255,xtrans,xtc:longint;xoptions:currency):boolean;//05sep2017, 25jul2017
begin
result:=miscopyareaxx2(da_clip,ddx,ddy,ddw,ddh,sa,d,s,xpower255,xtrans,xtc,xoptions,0,0);
end;

function miscopyareaxx1(ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject):boolean;//01jun2019
begin
result:=miscopyareaxx5(maxarea,ddx,ddy,ddw,ddh,sa,d,s,nil,nil,nil,nil,255,0,clnone,0,0,0,nil,nil,nil,nil,nil,nil,nil);
end;

function miscopyareaxx1A(ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xusealpha:boolean):boolean;//support 32bit alpha channel - 27jan2021
begin
result:=miscopyareaxx8(maxarea,ddx,ddy,ddw,ddh,sa,d,s,nil,nil,nil,nil,nil,nil,0,0,false,255,0,clnone,0,0,0,nil,nil,nil,nil,nil,nil,nil,xusealpha);
end;

function miscopyareaxx1B(ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xpower255:longint;xusealpha:boolean):boolean;//support 32bit alpha channel - 27jan2021
begin
result:=miscopyareaxx8(maxarea,ddx,ddy,ddw,ddh,sa,d,s,nil,nil,nil,nil,nil,nil,0,0,false,xpower255,0,clnone,0,0,0,nil,nil,nil,nil,nil,nil,nil,xusealpha);
end;

function miscopyareaxx2(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint):boolean;//27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx3(da_clip,ddx,ddy,ddw,ddh,sa,d,s,nil,nil,xpower255,xtrans,xtc,xoptions,xscroll,yscroll);
end;

function miscopyareaxx3(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,sm:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint):boolean;//27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx5(da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,nil,sm,nil,xpower255,xtrans,xtc,xoptions,xscroll,yscroll,nil,nil,nil,nil,nil,nil,nil);
end;

function miscopyareaxx3b(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint):boolean;//27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx5(da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,dm2,sm,nil,xpower255,xtrans,xtc,xoptions,xscroll,yscroll,nil,nil,nil,nil,nil,nil,nil);
end;

function miscopyareaxx4(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,sm:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8):boolean;//22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx5(da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,nil,sm,nil,xpower255,xtrans,xtc,xoptions,xscroll,yscroll,refOP,refRGB,refR,refG,refB,refX,refY);
end;

function miscopyareaxx5(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2:tobject;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8):boolean;//15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx6(da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,dm2,sm,sm2,nil,0,false,xpower255,xtrans,xtc,xoptions,xscroll,yscroll,refOP,refRGB,refR,refG,refB,refX,refY);
end;

function miscopyareaxx6(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8):boolean;//32bit support - 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx8(da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,dm2,sm,sm2,sselshow,nil,-1,xselshowSTRIDE,xselshowEVENINIT,xpower255,xtrans,xtc,xoptions,xscroll,yscroll,refOP,refRGB,refR,refG,refB,refX,refY,false);
end;

function miscopyareaxx7(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8):boolean;//32bit alpha channel support - 26jan2021, 30aug2020, 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx8(da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,dm2,sm,sm2,sselshow,dmask,dmaskval,xselshowSTRIDE,xselshowEVENINIT,xpower255,xtrans,xtc,xoptions,xscroll,yscroll,refOP,refRGB,refR,refG,refB,refX,refY,false);
end;

function miscopyareaxx8(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8;xusealpha:boolean):boolean;//32bit alpha channel support - 29jan2021, 27jan2021, 30aug2020, 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx9(clnone,clnone,da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,dm2,sm,sm2,sselshow,dmask,dmaskval,xselshowSTRIDE,xselshowEVENINIT,xpower255,xtrans,xtc,xoptions,xscroll,yscroll,refOP,refRGB,refR,refG,refB,refX,refY,xusealpha);
end;

function misoptions(xinvert,xgrey,xsepia,xnoise:boolean):currency;
var
   v8:tcur8;
begin
v8.val:=0;
if xinvert then include(v8.bits,0);
if xgrey   then include(v8.bits,1);
if xsepia  then include(v8.bits,2);
if xnoise  then include(v8.bits,3);
result:=v8.val;
end;

function miscopyareaxx9(xcolorise1,xcolorise2:longint;da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8;xusealpha:boolean):boolean;//xinvert put last for better results - 05jun2021, "round()" instead of "trunc()" - 16mar2021, dsysinfo support - 10mar2021, 32bit alpha channel support - 29jan2021, 27jan2021, 30aug2020, 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
begin
result:=miscopyareaxx10(xcolorise1,xcolorise2,da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,dm2,sm,sm2,sselshow,dmask,nil,dmaskval,xselshowSTRIDE,xselshowEVENINIT,xpower255,xtrans,xtc,clnone,xoptions,xscroll,yscroll,refOP,refRGB,refR,refG,refB,refX,refY,xusealpha);
end;

function miscopyareaxx91(xcolorise1,xcolorise2:longint;da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask,dbackmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8;xusealpha:boolean):boolean;//04dec2024
begin
result:=miscopyareaxx10(xcolorise1,xcolorise2,da_clip,ddx,ddy,ddw,ddh,sa,d,s,dm,dm2,sm,sm2,sselshow,dmask,dbackmask,dmaskval,xselshowSTRIDE,xselshowEVENINIT,xpower255,xtrans,xtc,clnone,xoptions,xscroll,yscroll,refOP,refRGB,refR,refG,refB,refX,refY,xusealpha);
end;

function miscopyareaxx10(xcolorise1,xcolorise2:longint;da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s,dm,dm2,sm,sm2,sselshow:tobject;dmask,dbackmask:tmask8;dmaskval:longint;xselshowSTRIDE:longint;xselshowEVENINIT:boolean;xpower255,xtrans,xtc,xwriteShadesofcolor:longint;xoptions:currency;xscroll,yscroll:longint;refOP,refRGB,refR,refG,refB,refX,refY:tstr8;xusealpha:boolean):boolean;//xinvert put last for better results - 05jun2021, "round()" instead of "trunc()" - 16mar2021, dsysinfo support - 10mar2021, 32bit alpha channel support - 29jan2021, 27jan2021, 30aug2020, 25apr2020, 15may2019, 22aug2018, 27sep2017, 26sep2017, 25sep2017, 25jul2017
label
   skipend,skiptrans;
const
   alpha_backmask_choke=100;
var//Note: Speed optimised using x-pixel limiter "d1,d2", y-pixel limiter "d3,d4"
   //      and object caching "1x createtmp" and "2x createint" with a typical speed
   //      increase in PicWork of 45x, or a screen paint time originally of 3,485ms now 78ms
   //      with layer 2 image at 80,000px wide @ 1,000% zoom as of 06sep2017.
   //Note: s and d are required - 25jul2017
   //Note: da,sa are zero-based areas, e.g: da.left/right=0..[width-1],
   //Note: xpower255 range = 0..255 - 29may2019
   //Critical Note: must use "trunc" instead of "round" for correct rounding behaviour - 24SEP2011
   //Note: Range errors fixed on 26sep2017 -> now stable and reliable
   //Note: m =optional dest mask -> 24bit mask, but we use the red channel (0=transparent, 1=low..255=full) - 12nov2017
   //Note: m2 =optional 2nd dest mask -> 24bit mask, but we use the red channel (0=transparent, 1=low..255=full) - 14apr2019
   //Note: sm=optional source mask -> 24bit mask, but we use the red channel (0=transparent, 1=low..255=full) - 11jan2018
   //Note: Not in use yet --> sm2=optional 2nd source mask -> 24bit mask, but we use the red channel (0=transparent, 1=low..255=full) - 14apr2019
   //Note: Now supports 8,24 and 32 bits for "s" and "d" - 25apr2020
   a:tbasicimage;
   dr32,sr32,dr132,dr232,dr332,dr432:pcolorrow32;//25apr2020
   dr24,sr24,dmr24,dmr24b,smr24,sselshowr24,sselshowr24a,sselshowr24b,ar,ar1,ar2,dr1,dr2,dr3,dr4:pcolorrow24;
   bmr8,mr8,dr8,sr8,dmr8,dmr8b,smr8,sselshowr8,sselshowr8a,sselshowr8b,dr18,dr28,dr38,dr48:pcolorrow8;
   aok1,aok2,dok1,dok2,dok3,dok4:boolean;
   xcwhite24,xcblack24,dc24,sc24:tcolor24;
   xcwhite32,xcblack32,dc32,sc32:tcolor32;
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support
   xselstride,p,vr,vg,vb,vc,daW,daH,saW,saH:longint;
   v1,v2,v3,v4:longint;
   int1,d1,d2,d3,d4:longint;//x-pixel(d) and y-pixel(d) speed optimisers -> represent ACTUAL d.area needed to be processed - 05sep2017
   //.image values
   sw,sh,sbits:longint;
   smw,smh,smbits:longint;
   smw2,smh2,smbits2:longint;
   sselshoww,sselshowh,sselshowbits:longint;
   shasai,smhasai,smhasai2,sselshowhasai:boolean;
   dw,dh,dbits:longint;
   dmw,dmh,dmbits:longint;
   dmw2,dmh2,dmbits2:longint;
   dhasai,dmhasai,dmhasai2:boolean;
   //.other
   xalpha255,xpower2,dx,dy,sx,sy,sya,syb,sxa,sxb:longint;
   dx1,dx2,dy1,dy2:longint;
   xtranscol:tcolor24;
   bs:array[0..2] of boolean;
   xtranscolok,bol1,xfilters,xmirror,xflip,xinvert,xgrey,xsepia,xnoise:boolean;
   c8:tcur8;
   da:twinrect;
   str1:string;
   //ref pattern support - 24aug2018
   zmin,zmax,zoff,zcount:longint;
   reflistR,reflistG,reflistB,reflistRGB:pcolorrow8;
   reflistOP:pdllongint;
   refcoreR,refcoreG,refcoreB,refcoreRGB:tdynamicbyte;
   refcoreOP:tdynamicinteger;
   refuse:boolean;
   //colorise support - 27mar2021
   dcolorise1,dcolorise2:tcolor24;
   dcoloriseOK,dcoloriseInv:boolean;
   dcolorisev:longint;
   //write shades of color support - 15mar2022
   socOK:boolean;
   soc24:tcolor24;
   socLevel:longint;

   function cint32(x:currency):longint;
   begin//Note: Clip a 64bit integer to a 32bit integer range
   if (x>max32) then x:=max32
   else if (x<min32) then x:=min32;
   result:=trunc(x);
   end;

   procedure xinc32(xr32:pcolorrow32;xoff:longint);
   begin
   xoff:=dx+xoff;
   if (xoff>=0) and (xoff<dw) then
      begin
      inc(vr,xr32[xoff].r);
      inc(vg,xr32[xoff].g);
      inc(vb,xr32[xoff].b);
      inc(vc);
      end;
   end;

   procedure xinc24(xr:pcolorrow24;xoff:longint);
   begin
   xoff:=dx+xoff;
   if (xoff>=0) and (xoff<dw) then
      begin
      inc(vr,xr[xoff].r);
      inc(vg,xr[xoff].g);
      inc(vb,xr[xoff].b);
      inc(vc);
      end;
   end;

   procedure xinc8(xr:pcolorrow8;xoff:longint);
   begin
   xoff:=dx+xoff;
   if (xoff>=0) and (xoff<dw) then
      begin
      inc(vr,xr[xoff]);
      inc(vg,xr[xoff]);
      inc(vb,xr[xoff]);
      inc(vc);
      end;
   end;

   procedure d_sys24;//10mar2021
   begin
   dcolorisev:=(sc24.r+sc24.g+sc24.b) div 3;
   if (dcolorisev<100) then dcolorisev:=100 else if (dcolorisev>230) then dcolorisev:=230;
   if dcoloriseInv then dcolorisev:=255-dcolorisev;//26mar2021
   sc24.r:=((dcolorise1.r*dcolorisev) + (dcolorise2.r*(255-dcolorisev))) div 255;
   sc24.g:=((dcolorise1.g*dcolorisev) + (dcolorise2.g*(255-dcolorisev))) div 255;
   sc24.b:=((dcolorise1.b*dcolorisev) + (dcolorise2.b*(255-dcolorisev))) div 255;
   end;
begin
//defaults
result:=false;//11SEP2011

try
mr8:=nil;
bmr8:=nil;//background mask row - 04dec2024
ar1:=nil;
ar2:=nil;
_mx:=nil;
_my:=nil;
a:=nil;
reflistR:=nil;
reflistG:=nil;
reflistB:=nil;
reflistRGB:=nil;
reflistOP:=nil;
refcoreR:=nil;
refcoreG:=nil;
refcoreB:=nil;
refcoreRGB:=nil;
refcoreOP:=nil;
refuse:=false;
//.xwriteShadesofcolor
socOK:=(xwriteShadesofcolor<>clnone);
socLevel:=255;//on by default - required for non-soc modes - 15mar2022
if socOK then soc24:=int__c24(xwriteShadesofcolor);

//.refs -> lock - 30aug2020
if (refOP<>nil)  then str__lock(@refOP);
if (refRGB<>nil) then str__lock(@refRGB);
if (refR<>nil)   then str__lock(@refR);
if (refG<>nil)   then str__lock(@refG);
if (refB<>nil)   then str__lock(@refB);
if (refX<>nil)   then str__lock(@refX);
if (refY<>nil)   then str__lock(@refY);

//check
if (sa.right<sa.left) or (sa.bottom<sa.top) then goto skipend;
if not misinfo82432(s,sbits,sw,sh,shasai) then goto skipend;
if not misinfo82432(d,dbits,dw,dh,dhasai) then goto skipend;
if zznil(dmask,2107) or (dmask.width<dw) or (dmask.height<dh) or (dmaskval<-1) then dmaskval:=-1;//off - 23may2020
//.background mask support
if (dbackmask<>nil) and ((dbackmask.width<dw) or (dbackmask.height<dh)) then dbackmask:=nil;//turn off

//-- init --
//.colors
xcwhite24.r:=255;  xcwhite24.g:=255;  xcwhite24.b:=255;
xcblack24.r:=0;    xcblack24.g:=0;    xcblack24.b:=0;
xcwhite32.r:=255;  xcwhite32.g:=255;  xcwhite32.b:=255;  xcwhite32.a:=255;
xcblack32.r:=0;    xcblack32.g:=0;    xcblack32.b:=0;    xcblack32.a:=255;

//.colorise -> convert color pixels into shades between "xcolorise1 .. xcolorise2" - 27mar2021
dcoloriseOK:=(xcolorise1<>clnone) and (xcolorise2<>clnone);
if dcoloriseOK then
   begin
   dcolorise1:=int__c24(xcolorise1);
   dcolorise2:=int__c24(xcolorise2);
   dcoloriseInv:=(int__brightness_aveb(c24a0__int(dcolorise1))<int__brightness_aveb(c24a0__int(dcolorise2)));
   end;

//allow only 8bit and 24bit mask handling:
//.dm & dm2
if (not misinfo824(dm,dmbits,dmw,dmh,dmhasai))      or (dmw<dw)  or (dmh<dh)  then dmbits:=0;//0=off
if (not misinfo824(dm2,dmbits2,dmw2,dmh2,dmhasai2)) or (dmw2<dw) or (dmh2<dh) then dmbits2:=0;//0=off
//.sm & sm2
if (not misinfo824(sm,smbits,smw,smh,smhasai))      or (smw<sw)  or (smh<sh)  then smbits:=0;//0=off
if (not misinfo824(sm2,smbits2,smw2,smh2,smhasai2)) or (smw2<sw) or (smh2<sh) then smbits2:=0;//0=off
//.sselshow
if (not misinfo824(sselshow,sselshowbits,sselshoww,sselshowh,sselshowhasai)) or (sselshoww<sw) or (sselshowh<sh) then sselshowbits:=0;//0=off
if (xselshowstride<1) then xselshowstride:=4;//use default value of 4 pixels when not specified - 08jul2019
xselstride:=2*xselshowstride;//2x for realtime calculations to work - 08jul2019
//.xpower
xpower255:=frcrange32(xpower255,0,255);
xpower2:=xpower255;
xalpha255:=255;
//.ref pattern support - 24aug2018
if ref_use(refR) and (ref_count(refR)>=1) then
   begin
   if zznil(refcoreR,2110) then refcoreR:=tdynamicbyte.create;
   for int1:=255 downto 0 do refcoreR.value[int1]:=byte(ref_val0255(refR,int1));
   reflistR:=refcoreR.core;
   end;
if ref_use(refG) and (ref_count(refG)>=1) then
   begin
   if zznil(refcoreG,2111) then refcoreG:=tdynamicbyte.create;
   for int1:=255 downto 0 do refcoreG.value[int1]:=byte(ref_val0255(refG,int1));
   reflistG:=refcoreG.core;
   end;
if ref_use(refB) and (ref_count(refB)>=1) then
   begin
   if zznil(refcoreB,2112) then refcoreB:=tdynamicbyte.create;
   for int1:=255 downto 0 do refcoreB.value[int1]:=byte(ref_val0255(refB,int1));
   reflistB:=refcoreB.core;
   end;
if ref_use(refRGB) and (ref_count(refRGB)>=1) then
   begin
   if zznil(refcoreRGB,2113) then refcoreRGB:=tdynamicbyte.create;
   for int1:=255 downto 0 do refcoreRGB.value[int1]:=byte(ref_val0255(refRGB,int1));
   reflistRGB:=refcoreRGB.core;
   end;
if ref_use(refOP) and (ref_count(refOP)>=1) then
   begin
   if zznil(refcoreOP,2114) then refcoreOP:=tdynamicinteger.create;
   for int1:=255 downto 0 do refcoreOP.value[int1]:=round( (ref_val32(refOP,int1,int1,-255,255)/255)*xpower255 );
   reflistOP:=refcoreOP.core;
   end;
refuse:=(reflistR<>nil) or (reflistG<>nil) or (reflistB<>nil) or (reflistRGB<>nil) or (reflistOP<>nil);

//.xmirror
xmirror:=(ddw<0);if xmirror then ddw:=-ddw;
xflip  :=(ddh<0);if xflip   then ddh:=-ddh;
da.left:=cint32(ddx);
da.right:=cint32(ddx)+cint32(ddw-1);
da.top:=cint32(ddy);
da.bottom:=cint32(ddy)+cint32(ddh-1);

//.da_clip - limit to dimensions of "d" - 05sep2017
da_clip.left:=frcrange32(da_clip.left,0,dw-1);
da_clip.right:=frcrange32(da_clip.right,da_clip.left,dw-1);
da_clip.top:=frcrange32(da_clip.top,0,dH-1);
da_clip.bottom:=frcrange32(da_clip.bottom,0,dH-1);

//.optimise actual x-pixels scanned -> d1 + d2 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d1:=largest32(largest32(da.left,da_clip.left),0);//range: 0..max32
d2:=smallest32(smallest32(da.right,da_clip.right),dw-1);//range: min32..dw-1
if (d2<d1) then goto skipend;

//.optimise actual y-pixels scanned -> d3 + d4 -> 05sep2017
//.warning: Do not alter boundary handling below or failure will result - 27sep2017
d3:=largest32(largest32(da.top,da_clip.top),0);//range: 0..max32
d4:=smallest32(smallest32(da.bottom,da_clip.bottom),dH-1);//range: min32..dh-1
if (d4<d3) then goto skipend;

//.create temp buffer -> needs no lock/unlock - 23may2020
if not low__createimg24(a,'copyareaxx_a24',bol1) then goto skipend;
if (misb(a)<>24) then goto skipend;
//.adjust image dimensions
if (a.width>(dw+2000)) or (a.height>(dh+2000)) then//too big -> make small first
   begin
   a.sizeto(1,1);
   end;
if (a.width<dw)  then a.sizeto(dw,a.height);
if (a.height<dh) then a.sizeto(a.width,dh);
aok1:=false;
aok2:=false;
dok1:=false;
dok2:=false;
dok3:=false;
dok4:=false;
//.xoptions
c8.val:=xoptions;
xinvert :=(0 in c8.bits);
xgrey   :=(1 in c8.bits);
xsepia  :=(2 in c8.bits);
xnoise  :=(3 in c8.bits);
xfilters:=xinvert or xgrey or xsepia or xnoise;
//.xtrans
xtrans:=frcrange32(xtrans,0,3);//0=none, 1=1bit, 2=8bit, 3=8bit enhanced -> dual purpose -> sharp, blur, blur2 AND transparent color
xtranscolok:=(xtc<>clnone);
if xtranscolok then xtranscol:=int__c24(xtc);
//.other
daW:=low__posn(da.right-da.left)+1;
daH:=low__posn(da.bottom-da.top)+1;
saW:=low__posn(sa.right-sa.left)+1;
saH:=low__posn(sa.bottom-sa.top)+1;
dx1:=frcrange32(da.left,0,dw-1);
dx2:=frcrange32(da.right,0,dw-1);
dy1:=frcrange32(da.top,0,dh-1);
dy2:=frcrange32(da.bottom,0,dh-1);
//.check area -> do nothing
if (daw=0) or (dah=0) or (saw=0) or (sah=0) then goto skipend;
if (sa.right<sa.left) or (sa.bottom<sa.top) or (da.right<da.left) or (da.bottom<da.top) then goto skipend;
if (dx2<dx1) or (dy2<dy1) then goto skipend;

//.x-scroll
if (xscroll<>0) then
   begin
   xscroll:=-xscroll;//logic inversion -> match user expectation -> neg.vals=left, pos.vals=right
   bol1:=(xscroll<0);
   xscroll:=low__posn(xscroll);
   xscroll:=xscroll-((xscroll div saW)*saW);
   xscroll:=frcrange32(xscroll,0,saW-1);
   if bol1 then xscroll:=-xscroll;
   end;

//.y-scroll
if (yscroll<>0) then
   begin
   yscroll:=-yscroll;//logic inversion -> match user expectation -> neg.vals=up, pos.vals=down
   bol1:=(yscroll<0);
   yscroll:=low__posn(yscroll);
   yscroll:=yscroll-((yscroll div saH)*saH);
   yscroll:=frcrange32(yscroll,0,saH-1);
   if bol1 then yscroll:=-yscroll;
   end;

//.mx (mapped dx) - highly optimised - 06sep2017
if ref_use(refX) then int1:=ref_count(refX) else int1:=0;
if (int1>=1) then str1:='.ref'+intstr32(ref_id(refX))+'_'+intstr32(int1)+'_'+intstr32(low__crc32b(refX)) else str1:='';
if not low__createint(_mx,'copyareaxx_mx.'+intstr32(daW)+'.0.'+intstr32(sa.left)+'.'+intstr32(sa.right)+'.'+intstr32(saW)+str1,bol1) then goto skipend;
if not bol1 then
   begin
   //init
   zcount:=0;
   zmin:=0;
   zmax:=daW-1;
   _mx.setparams(daW,daW,0);
   mx:=_mx.core;
   //get
   for p:=0 to (daW-1) do
   begin
   mx[p]:=frcrange32(sa.left+trunc(p*(saW/daW)),sa.left,sa.right);//06apr2017
   if (int1>=1) then mx[p]:=ref_valrange32(refX,mx[p],sa.left,sa.right,p,zmin,zmax,zoff,zcount);
   end;//p
   end;
mx:=_mx.core;

//.my (mapped dy) - highly optimised - 06sep2017
if ref_use(refY) then int1:=ref_count(refY) else int1:=0;
if (int1>=1) then str1:='.ref'+intstr32(ref_id(refY))+'_'+intstr32(int1)+'_'+intstr32(low__crc32b(refY)) else str1:='';
if not low__createint(_my,'copyareaxx_my.'+intstr32(daH)+'.0.'+intstr32(sa.top)+'.'+intstr32(sa.bottom)+'.'+intstr32(saH)+str1,bol1) then goto skipend;
if not bol1 then
   begin
   //init
   zcount:=0;
   zmin:=0;
   zmax:=daH-1;
   _my.setparams(daH,daH,0);
   my:=_my.core;
   //get
   for p:=0 to (daH-1) do
   begin
   my[p]:=frcrange32(sa.top+trunc(p*(saH/daH)),sa.top,sa.bottom);//24SEP2011
   if (int1>=1) then my[p]:=ref_valrange32(refY,my[p],sa.top,sa.bottom,p,zmin,zmax,zoff,zcount);
   end;//p
   end;
my:=_my.core;

//-- Draw Color Pixels ---------------------------------------------------------
//dy
//...was: for dy:=da.top to da.bottom do if (dy>=0) and (dy<dH) and (dy>=da_clip.top) and (dy<=da_clip.bottom) then
for dy:=d3 to d4 do
   begin
   //.ar
   ar:=a.prows24[dy];
   if xflip then sy:=my[(da.bottom-da.top)-(dy-da.top)] else sy:=my[dy-da.top];//zero base
   if (sselshowbits<>0) then
      begin
      case xflip of
      true:begin
         //.sya
         v1:=dy-1;
         if (v1<d3) then v1:=d3;
         sya:=my[(da.bottom-da.top)-(v1-da.top)];
         //.syb
         v1:=dy+1;
         if (v1>d4) then v1:=d4;
         syb:=my[(da.bottom-da.top)-(v1-da.top)];
         end;
      else begin
         //.sya
         v1:=dy-1;
         if (v1<d3) then v1:=d3;
         sya:=my[v1-da.top];//zero base
         //.syb
         v1:=dy+1;
         if (v1>d4) then v1:=d4;
         syb:=my[v1-da.top];//zero base
         end;
      end;//case
      end;//if
   //.y-scroll
   if (yscroll<>0) then
      begin
      sy:=sy+yscroll;
      if (sy<sa.top) then sy:=sa.bottom-(-sy-sa.top)
      else if (sy>sa.bottom) then sy:=sa.top+(sy-sa.bottom);
      end;
   //.sy
   if (sy>=0) and (sy<sH) then
      begin
      if (dmaskval>=0) then mr8:=dmask.prows8[dy];
      if (dbackmask<>nil) then bmr8:=dbackmask.prows8[dy];
      if not misscan82432(d,dy,dr8,dr24,dr32)                     then goto skipend;//25apr2020, 28may2019
      if not misscan82432(s,sy,sr8,sr24,sr32)                     then goto skipend;//25apr2020,
      if (dmbits<>0)  and (not misscan824(dm,dy,dmr8,dmr24))      then goto skipend;
      if (dmbits2<>0) and (not misscan824(dm2,dy,dmr8b,dmr24b))   then goto skipend;
      if (smbits<>0)  and (not misscan824(sm,sy,smr8,smr24))      then goto skipend;
      if (sselshowbits<>0) then
         begin
         if not misscan824(sselshow,sya,sselshowr8a,sselshowr24a) then goto skipend;
         if not misscan824(sselshow,sy,sselshowr8,sselshowr24)    then goto skipend;
         if not misscan824(sselshow,syb,sselshowr8b,sselshowr24b) then goto skipend;
         end;
      //dx - Note: xeven only updated at this stage for speed during "sselshowbits<>0" - 08jul2019
      //...was: for dx:=da.left to da.right do if (dx>=0) and (dx<dw) and (dx>=da_clip.left) and (dx<=da_clip.right) then
      for dx:=d1 to d2 do
         begin
         if xmirror then sx:=mx[(da.right-da.left)-(dx-da.left)] else sx:=mx[dx-da.left];//zero base
         if (sselshowbits<>0) then
            begin
            case xmirror of
            true:begin
               //.sxa
               v1:=dx-1;
               if (v1<d1) then v1:=d1;
               sxa:=mx[(da.right-da.left)-(v1-da.left)];
               //.sxb
               v1:=dx+1;
               if (v1>d2) then v1:=d2;
               sxb:=mx[(da.right-da.left)-(v1-da.left)];
               end;
            else begin
               //.sxa
               v1:=dx-1;
               if (v1<d1) then v1:=d1;
               sxa:=mx[v1-da.left];//zero base
               //.sxb
               v1:=dx+1;
               if (v1>d2) then v1:=d2;
               sxb:=mx[v1-da.left];//zero base
               end;
            end;//case
            end;//if
         //.x-scroll
         if (xscroll<>0) then
            begin
            sx:=sx+xscroll;
            if (sx<sa.left) then
               begin
               //.math quirk for "animation cell area" referencing - 25sep2017
               if (sx<=0) then sx:=sa.right-(-sx-sa.left) else sx:=sa.right-(sa.left-sx);
               end
            else if (sx>sa.right) then sx:=sa.left+(sx-sa.right);
            end;
         //.sx
         if (sx>=0) and (sx<sW) then
            begin
            //init
            if      (sbits=32) then//25apr2020
               begin
               sc32:=sr32[sx];
               if socOK then
                  begin
                  //greyscale value
                  socLevel:=sc32.r;
                  if (sc32.g>socLevel) then socLevel:=sc32.g;
                  if (sc32.b>socLevel) then socLevel:=sc32.b;
                  sc24:=soc24;
                  //get
//                  sc24.r:=(soc24.r*socLevel) div 255;
//                  sc24.g:=(soc24.g*socLevel) div 255;
//                  sc24.b:=(soc24.b*socLevel) div 255;
                  end
               else
                  begin
                  sc24.r:=sc32.r;
                  sc24.g:=sc32.g;
                  sc24.b:=sc32.b;
                  end;
               xalpha255:=sc32.a;//new - 27jan2021
               end
            else if (sbits=24) then
               begin
               sc24:=sr24[sx];
               if socOK then
                  begin
                  //greyscale value
                  socLevel:=sc24.r;
                  if (sc24.g>socLevel) then socLevel:=sc24.g;
                  if (sc24.b>socLevel) then socLevel:=sc24.b;
                  sc24:=soc24;
                  //get
//                  sc24.r:=(soc24.r*socLevel) div 255;
//                  sc24.g:=(soc24.g*socLevel) div 255;
//                  sc24.b:=(soc24.b*socLevel) div 255;
                  end;
               end
            else if (sbits=8) then
               begin
               //8bit -> 24bit
               if socOK then
                  begin
                  //greyscale value
                  socLevel:=sr8[sx];
                  sc24:=soc24;
                  //get

//                  sc24.r:=(soc24.r*socLevel) div 255;
//                  sc24.g:=(soc24.g*socLevel) div 255;
//                  sc24.b:=(soc24.b*socLevel) div 255;
                  end
               else
                  begin
                  sc24.r:=sr8[sx];
                  sc24.g:=sc24.r;
                  sc24.b:=sc24.r;
                  end;
               end;
            //draw pixel -> using "dpower" - 15may2019, 14apr2019, 25jul2017
//..was:    if ((xtrans=0) or (not xtranscolok) or ( (sc.r<>xtranscol.r) or (sc.g<>xtranscol.g) or (sc.b<>xtranscol.b) )) and ((not mok) or (mr[dx].r>=1)) and ((not mok2) or (mr2[dx].r>=1)) and ((not smok) or (smr[sx].r>=1)) then
            if ((xalpha255>=1) or (not xusealpha)) and
               ( (xtrans=0) or (not xtranscolok) or ( (sc24.r<>xtranscol.r) or (sc24.g<>xtranscol.g) or (sc24.b<>xtranscol.b) ) ) and
               ( (dmbits=0) or ((dmbits=8) and (dmr8[dx]>=1)) or ((dmbits=24) and (dmr24[dx].r>=1)) ) and
               ( (dmbits2=0) or ((dmbits2=8) and (dmr8b[dx]>=1)) or ((dmbits2=24) and (dmr24b[dx].r>=1)) ) and
               ( (smbits=0) or ((smbits=8) and (smr8[sx]>=1)) or ((smbits=24) and (smr24[sx].r>=1)) ) and
               (socLevel>=1) then
               begin
               //.xpower2 init
               xpower2:=xpower255;
               if (socLevel<255) and (xpower2>=1) then
                  begin
                  xpower2:=(xpower255*socLevel) div 255;
                  if (xpower2<1) then xpower2:=1;
                  end;

               //.ref pattern support - 24aug2018
               if refuse then
                  begin
                  if (reflistOP<>nil) then
                     begin
                     int1:=sc24.r;
                     if (sc24.g>int1) then int1:=sc24.g;
                     if (sc24.b>int1) then int1:=sc24.b;
                     xpower2:=reflistOP[int1];//-255..+255
                     if (xpower2<0) then xpower2:=0 else if (xpower2>255) then xpower2:=255;
                     end;
                  if (reflistRGB<>nil) then
                     begin
                     sc24.r:=reflistRGB[sc24.r];
                     sc24.g:=reflistRGB[sc24.g];
                     sc24.b:=reflistRGB[sc24.b];
                     end;
                  if (reflistR<>nil) then sc24.r:=reflistR[sc24.r];
                  if (reflistG<>nil) then sc24.g:=reflistG[sc24.g];
                  if (reflistB<>nil) then sc24.b:=reflistB[sc24.b];
                  end;
               //.filters
               if xfilters then
                  begin
                  if xnoise   then    fbNoise3(sc24.r,sc24.g,sc24.b);
//was:            if xinvert  then    fbInvert(sc24.r,sc24.g,sc24.b);
                  if xgrey    then fbGreyscale(sc24.r,sc24.g,sc24.b);
                  if xsepia   then     fbSepia(sc24.r,sc24.g,sc24.b);
                  if xinvert  then    fbInvert(sc24.r,sc24.g,sc24.b);//put last for more predictable USER EXPECTATIONS - 05jun2021
                  end;
               //.xpower2 modification
               case dmbits of
               8:if (dmr8[dx]=0) then xpower2:=0 else xpower2:=(xpower2*dmr8[dx]) div 255;
               24:if (dmr24[dx].r=0) then xpower2:=0 else xpower2:=(xpower2*dmr24[dx].r) div 255;
               end;

               //.xpower2 modification - 2nd mask - 14apr2019
               case dmbits2 of
               8:if (dmr8b[dx]=0) then xpower2:=0 else xpower2:=(xpower2*dmr8b[dx]) div 255;
               24:if (dmr24b[dx].r=0) then xpower2:=0 else xpower2:=(xpower2*dmr24b[dx].r) div 255;
               end;
               //.sm modification of xpower2 - 11jan2018
               case smbits of
               8:if (smr8[sx]=0) then xpower2:=0 else xpower2:=(xpower2*smr8[sx]) div 255;
               24:if (smr24[sx].r=0) then xpower2:=0 else xpower2:=(xpower2*smr24[sx].r) div 255;
               end;

               //.32bit alpha channel handling - 26jan2021
               if xusealpha and (xpower2>=1) and (xalpha255<255) then
                  begin
                  xpower2:=trunc(xpower2*(xalpha255/255));
                  if (xpower2<1) then xpower2:=1;
                  end;

               //.xpower2 finalise
               case dbits of
               32:begin
                  if dcoloriseOK then d_sys24;
                  sc32.r:=sc24.r;
                  sc32.g:=sc24.g;
                  sc32.b:=sc24.b;
                  sc32.a:=xalpha255;
                  if (xpower2<255) then//fixed on 25jan2021 (had been accidently using "dr24[dx] for 32bit instead of dr32[dx]"
                     begin
                     sc32.r:=ref65025_div_255[((dr32[dx].r*(255-xpower2))+(sc32.r*xpower2))];//18ms
                     sc32.g:=ref65025_div_255[((dr32[dx].g*(255-xpower2))+(sc32.g*xpower2))];//18ms
                     sc32.b:=ref65025_div_255[((dr32[dx].b*(255-xpower2))+(sc32.b*xpower2))];//18ms
                     if not xusealpha then sc32.a:=ref65025_div_255[((dr32[dx].a*(255-xpower2))+(sc32.a*xpower2))];//18ms
                     end;
                  if xusealpha then sc32.a:=dr32[dx].a;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     dr32[dx]:=sc32;//25apr2020
                     if (bmr8<>nil) and (xpower2>=1) and (xalpha255>=alpha_backmask_choke) then backmask__exclude(bmr8[dx]);//background mask
                     end;
                  end;
               24:begin
                  if dcoloriseOK then d_sys24;
                  if (xpower2<255) then
                     begin
                     sc24.r:=ref65025_div_255[((dr24[dx].r*(255-xpower2))+(sc24.r*xpower2))];//18ms
                     sc24.g:=ref65025_div_255[((dr24[dx].g*(255-xpower2))+(sc24.g*xpower2))];//18ms
                     sc24.b:=ref65025_div_255[((dr24[dx].b*(255-xpower2))+(sc24.b*xpower2))];//18ms
                     end;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     dr24[dx]:=sc24;
                     if (bmr8<>nil) and (xpower2>=1) and (xalpha255>=alpha_backmask_choke) then backmask__exclude(bmr8[dx]);//background mask
                     end;
                  end;
               8:begin
                  if dcoloriseOK then d_sys24;
                  if (xpower2<255) then
                     begin
                     //24bit -> 8bit
                     sc24.r:=ref65025_div_255[((dr8[dx]*(255-xpower2))+(sc24.r*xpower2))];//18ms
                     sc24.g:=ref65025_div_255[((dr8[dx]*(255-xpower2))+(sc24.g*xpower2))];//18ms
                     sc24.b:=ref65025_div_255[((dr8[dx]*(255-xpower2))+(sc24.b*xpower2))];//18ms
                     if (sc24.g>sc24.r) then sc24.r:=sc24.g;
                     if (sc24.b>sc24.r) then sc24.r:=sc24.b;
                     end;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     dr8[dx]:=sc24.r;
                     if (bmr8<>nil) and (xpower2>=1) and (xalpha255>=alpha_backmask_choke) then backmask__exclude(bmr8[dx]);//background mask
                     end;
                  end;
               end;//case
               //set
               ar[dx].r:=1;//1=color, 0=transparent
               end
            else ar[dx].r:=0;//1=color, 0=transparent

            //-- SelShow ---------------------------------------------------------------------
            //Note: Draw in realtime a stride-based (variable length black/white line)
            //      highlight line -> realtime, no ref. required - 09jul2019
            //.sel24 + d32
            if (sselshowbits=24) and (dbits=32) then
               begin
               v1:=sselshowr24a[sx].r;//sy-1
               v2:=sselshowr24[sxa].r;//sx-1
               v3:=sselshowr24[sxb].r;//sx+1
               v4:=sselshowr24b[sx].r;//sy+1
               if (sselshowr24[sx].r<=254) and ( (v2=255) or (v3=255) or ((v1=255) and (sselshowr24a<>sselshowr24)) or ((v4=255) and (sselshowr24b<>sselshowr24)) ) then
                  begin
                  //.realtime highlight stride calculations - 08jul2019
                  bol1:=(dx-((dx div xselstride)*xselstride))>=(xselstride div 2);
                  if   ((dy-((dy div xselstride)*xselstride))>=(xselstride div 2)) then bol1:=not bol1;
                  if xselshowEVENINIT then bol1:=not bol1;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     if bol1 then dr32[dx]:=xcwhite32 else dr32[dx]:=xcblack32;
                     end;
                  end;
               end
            //.sel8 + d32
            else if (sselshowbits=8) and (dbits=32) then
               begin
               v1:=sselshowr8a[sx];//sy-1
               v2:=sselshowr8[sxa];//sx-1
               v3:=sselshowr8[sxb];//sx+1
               v4:=sselshowr8b[sx];//sy+1
               if (sselshowr8[sx]<=254) and ( (v2=255) or (v3=255) or ((v1=255) and (sselshowr8a<>sselshowr8)) or ((v4=255) and (sselshowr8b<>sselshowr8)) ) then
                  begin
                  //.realtime highlight stride calculations - 08jul2019
                  bol1:=(dx-((dx div xselstride)*xselstride))>=(xselstride div 2);
                  if   ((dy-((dy div xselstride)*xselstride))>=(xselstride div 2)) then bol1:=not bol1;
                  if xselshowEVENINIT then bol1:=not bol1;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     if bol1 then dr32[dx]:=xcwhite32 else dr32[dx]:=xcblack32;
                     end;
                  end;
               end
            //.sel24 + d24
            else if (sselshowbits=24) and (dbits=24) then
               begin
               v1:=sselshowr24a[sx].r;//sy-1
               v2:=sselshowr24[sxa].r;//sx-1
               v3:=sselshowr24[sxb].r;//sx+1
               v4:=sselshowr24b[sx].r;//sy+1
               if (sselshowr24[sx].r<=254) and ( (v2=255) or (v3=255) or ((v1=255) and (sselshowr24a<>sselshowr24)) or ((v4=255) and (sselshowr24b<>sselshowr24)) ) then
                  begin
                  //.realtime highlight stride calculations - 08jul2019
                  bol1:=(dx-((dx div xselstride)*xselstride))>=(xselstride div 2);
                  if   ((dy-((dy div xselstride)*xselstride))>=(xselstride div 2)) then bol1:=not bol1;
                  if xselshowEVENINIT then bol1:=not bol1;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     if bol1 then dr24[dx]:=xcwhite24 else dr24[dx]:=xcblack24;
                     end;
                  end;
               end
            //.sel8 + d24
            else if (sselshowbits=8) and (dbits=24) then
               begin
               v1:=sselshowr8a[sx];//sy-1
               v2:=sselshowr8[sxa];//sx-1
               v3:=sselshowr8[sxb];//sx+1
               v4:=sselshowr8b[sx];//sy+1
               if (sselshowr8[sx]<=254) and ( (v2=255) or (v3=255) or ((v1=255) and (sselshowr8a<>sselshowr8)) or ((v4=255) and (sselshowr8b<>sselshowr8)) ) then
                  begin
                  //.realtime highlight stride calculations - 08jul2019
                  bol1:=(dx-((dx div xselstride)*xselstride))>=(xselstride div 2);
                  if   ((dy-((dy div xselstride)*xselstride))>=(xselstride div 2)) then bol1:=not bol1;
                  if xselshowEVENINIT then bol1:=not bol1;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     if bol1 then dr24[dx]:=xcwhite24 else dr24[dx]:=xcblack24;
                     end;
                  end;
               end
            //.sel8 + d8
            else if (sselshowbits=8) and (dbits=8) then
               begin
               v1:=sselshowr8a[sx];//sy-1
               v2:=sselshowr8[sxa];//sx-1
               v3:=sselshowr8[sxb];//sx+1
               v4:=sselshowr8b[sx];//sy+1
               if (sselshowr8[sx]<=254) and ( (v2=255) or (v3=255) or ((v1=255) and (sselshowr8a<>sselshowr8)) or ((v4=255) and (sselshowr8b<>sselshowr8)) ) then
                  begin
                  //.realtime highlight stride calculations - 08jul2019
                  bol1:=(dx-((dx div xselstride)*xselstride))>=(xselstride div 2);
                  if   ((dy-((dy div xselstride)*xselstride))>=(xselstride div 2)) then bol1:=not bol1;
                  if xselshowEVENINIT then bol1:=not bol1;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     if bol1 then dr8[dx]:=255 else dr8[dx]:=0;
                     end;
                  end;
               end
            //.sel24 + d8
            else if (sselshowbits=24) and (dbits=8) then
               begin
               v1:=sselshowr24a[sx].r;//sy-1
               v2:=sselshowr24[sxa].r;//sx-1
               v3:=sselshowr24[sxb].r;//sx+1
               v4:=sselshowr24b[sx].r;//sy+1
               if (sselshowr24[sx].r<=254) and ( (v2=255) or (v3=255) or ((v1=255) and (sselshowr24a<>sselshowr24)) or ((v4=255) and (sselshowr24b<>sselshowr24)) ) then
                  begin
                  //.realtime highlight stride calculations - 08jul2019
                  bol1:=(dx-((dx div xselstride)*xselstride))>=(xselstride div 2);
                  if   ((dy-((dy div xselstride)*xselstride))>=(xselstride div 2)) then bol1:=not bol1;
                  if xselshowEVENINIT then bol1:=not bol1;
                  if (dmaskval=-1) or (mr8[dx]=dmaskval) then
                     begin
                     if bol1 then dr8[dx]:=255 else dr8[dx]:=0;
                     end;
                  end;
               end;
            end
         else ar[dx].r:=0;//1=color, 0=transparent - sx
         end;//dx
      end//dy
   else for dx:=d1 to d2 do ar[dx].r:=0;
   end;//dy
//.xtrans check
if (xtrans<=1) and zznil(dm,2115) and zznil(dm2,2116) then goto skiptrans;
if (smbits<>0) then goto skiptrans;

//-- Draw Transparent Edge Soft Pixels (blur) ----------------------------------
//dy
//...was: for dy:=da.top to da.bottom do if (dy>=0) and (dy<dH) and (dy>=da_clip.top) and (dy<=da_clip.bottom) then
for dy:=d3 to d4 do
   begin
   //ar
   if (dmaskval>=0) then mr8:=dmask.prows8[dy];
   ar:=a.prows24[dy];
   //.aok1
   int1:=dy-1;
   aok1:=(int1>=d3) and (int1<=d4);
   if aok1 then ar1:=a.prows24[int1];
   //.aok2
   int1:=dy+1;
   aok2:=(int1>=d3) and (int1<=d4);
   if aok2 then ar2:=a.prows24[int1];
   //dr
   if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;//25apr2020, 28may2019
   //.dok1
   int1:=dy-1;
   dok1:=(int1>=d3) and (int1<=d4);
   if dok1 and (not misscan82432(d,int1,dr18,dr1,dr132)) then goto skipend;
   //.dok2
   int1:=dy+1;
   dok2:=(int1>=d3) and (int1<=d4);
   if dok2 and (not misscan82432(d,int1,dr28,dr2,dr232)) then goto skipend;
   //.dok3
   int1:=dy-2;
   dok3:=(int1>=d3) and (int1<=d4);
   if dok3 and (not misscan82432(d,int1,dr38,dr3,dr332)) then goto skipend;
   //.dok4
   int1:=dy+2;
   dok4:=(int1>=d3) and (int1<=d4);
   if dok4 and (not misscan82432(d,int1,dr48,dr4,dr432)) then goto skipend;
   //dx
   //...was: for dx:=da.left to da.right do if (dx>=0) and (dx<dw) and (dx>=da_clip.left) and (dx<=da_clip.right) then
   for dx:=d1 to d2 do if (dmaskval=-1) or (mr8[dx]=dmaskval) then//23may2020
      begin
      //init
      bs[0]:=false;
      bs[1]:=false;
      //get
      if (xtrans=2) then
         begin//new range: d1..d2
         //.y+0
         if (ar[dx].r=0) then bs[0]:=true;
         if ((dx-1)>=d1) and (ar[dx-1].r=1) then bs[1]:=true;
         if ((dx+1)<=d2) and (ar[dx+1].r=1) then bs[1]:=true;
         //.y-1
         if aok1 and (ar1[dx].r=1) then bs[1]:=true;
         //.y+1
         if aok2 and (ar2[dx].r=1) then bs[1]:=true;
         end
      else if (xtrans>=3) then
         begin//new range: d1..d2
         //.y+0
         bs[ar[dx].r]:=true;
         if ((dx-1)>=d1) then bs[ar[dx-1].r]:=true;
         if ((dx+1)<=d2) then bs[ar[dx+1].r]:=true;
         //.y-1
         if aok1 then
            begin
            bs[ar1[dx].r]:=true;
            if ((dx-1)>=d1) then bs[ar1[dx-1].r]:=true;
            if ((dx+1)<=d2) then bs[ar1[dx+1].r]:=true;
            end;
         //.y+1
         if aok2 then
            begin
            bs[ar2[dx].r]:=true;
            if ((dx-1)>=d1) then bs[ar2[dx-1].r]:=true;
            if ((dx+1)<=d2) then bs[ar2[dx+1].r]:=true;
            end;
         end;
      //set
      if bs[0] and bs[1] then
         begin
         case dbits of
         32:begin
            //Special Note: Always use a 5x5 blur matrix, even when "xtrans=2" (single blur boundary) for smoothest visual results - 27jul2017
            //--#--
            //-###-
            //#####
            //-###-
            //--#--
            //.y+0
            vr:=dr32[dx].r;
            vg:=dr32[dx].g;
            vb:=dr32[dx].b;
            vc:=1;
            xinc32(dr32,-1);
            xinc32(dr32,+1);
            xinc32(dr32,-2);
            xinc32(dr32,+2);
            //.y-1 / y+1
            if dok1 then
               begin
               xinc32(dr132,0);
               xinc32(dr132,-1);
               xinc32(dr132,+1);
               end;
            if dok2 then
               begin
               xinc32(dr232,0);
               xinc32(dr232,-1);
               xinc32(dr232,+1);
               end;
            //y-2 / y+2
            if dok3 then xinc32(dr332,0);
            if dok4 then xinc32(dr432,0);
            //set
            dc32.r:=byte(vr div vc);
            dc32.g:=byte(vg div vc);
            dc32.b:=byte(vb div vc);
            dc32.a:=255;
            //.xpower - 28aug2018
            xpower2:=xpower255;
            if (xpower2<255) then//does not use "m" at this point
               begin
               dc32.r:=ref65025_div_255[((dr32[dx].r*(255-xpower2))+(dc32.r*xpower2))];//18ms
               dc32.g:=ref65025_div_255[((dr32[dx].g*(255-xpower2))+(dc32.g*xpower2))];//18ms
               dc32.b:=ref65025_div_255[((dr32[dx].b*(255-xpower2))+(dc32.b*xpower2))];//18ms
               end;
            //.color
            dr32[dx]:=dc32;
            end;
         24:begin
            //Special Note: Always use a 5x5 blur matrix, even when "xtrans=2" (single blur boundary) for smoothest visual results - 27jul2017
            //--#--
            //-###-
            //#####
            //-###-
            //--#--
            //.y+0
            vr:=dr24[dx].r;
            vg:=dr24[dx].g;
            vb:=dr24[dx].b;
            vc:=1;
            xinc24(dr24,-1);
            xinc24(dr24,+1);
            xinc24(dr24,-2);
            xinc24(dr24,+2);
            //.y-1 / y+1
            if dok1 then
               begin
               xinc24(dr1,0);
               xinc24(dr1,-1);
               xinc24(dr1,+1);
               end;
            if dok2 then
               begin
               xinc24(dr2,0);
               xinc24(dr2,-1);
               xinc24(dr2,+1);
               end;
            //y-2 / y+2
            if dok3 then xinc24(dr3,0);
            if dok4 then xinc24(dr4,0);
            //set
            dc24.r:=byte(vr div vc);
            dc24.g:=byte(vg div vc);
            dc24.b:=byte(vb div vc);
            //.xpower - 28aug2018
            xpower2:=xpower255;
            if (xpower2<255) then//does not use "m" at this point
               begin
               dc24.r:=ref65025_div_255[((dr24[dx].r*(255-xpower2))+(dc24.r*xpower2))];//18ms
               dc24.g:=ref65025_div_255[((dr24[dx].g*(255-xpower2))+(dc24.g*xpower2))];//18ms
               dc24.b:=ref65025_div_255[((dr24[dx].b*(255-xpower2))+(dc24.b*xpower2))];//18ms
               end;
            //.color
            dr24[dx]:=dc24;
            end;
         8:begin
            //Special Note: Always use a 5x5 blur matrix, even when "xtrans=2" (single blur boundary) for smoothest visual results - 27jul2017
            //--#--
            //-###-
            //#####
            //-###-
            //--#--
            //.y+0
            vr:=dr8[dx];
            vg:=vr;
            vb:=vr;
            vc:=1;
            xinc8(dr8,-1);
            xinc8(dr8,+1);
            xinc8(dr8,-2);
            xinc8(dr8,+2);
            //.y-1 / y+1
            if dok1 then
               begin
               xinc8(dr18,0);
               xinc8(dr18,-1);
               xinc8(dr18,+1);
               end;
            if dok2 then
               begin
               xinc8(dr28,0);
               xinc8(dr28,-1);
               xinc8(dr28,+1);
               end;
            //y-2 / y+2
            if dok3 then xinc8(dr38,0);
            if dok4 then xinc8(dr48,0);
            //set
            dc24.r:=byte(vr div vc);
            dc24.g:=byte(vg div vc);
            dc24.b:=byte(vb div vc);
            //.xpower - 28aug2018
            xpower2:=xpower255;
            if (xpower2<255) then//does not use "m" at this point
               begin
               dc24.r:=ref65025_div_255[((dr8[dx]*(255-xpower2))+(dc24.r*xpower2))];//18ms
               dc24.g:=ref65025_div_255[((dr8[dx]*(255-xpower2))+(dc24.g*xpower2))];//18ms
               dc24.b:=ref65025_div_255[((dr8[dx]*(255-xpower2))+(dc24.b*xpower2))];//18ms
               end;
            //.color
            if (dc24.g>dc24.r) then dc24.r:=dc24.g;
            if (dc24.b>dc24.r) then dc24.r:=dc24.b;
            dr8[dx]:=dc24.r;
            end;
         end;//case
         end;
      end;//dx
   end;//dy

skiptrans:
//successful
result:=true;
skipend:
except;end;
try
//.free
low__freeint(_mx);
low__freeint(_my);
low__freeimg(a);
//.ref pattern
if (refcoreR<>nil) or (refcoreG<>nil) or (refcoreB<>nil) or (refcoreRGB<>nil) or (refcoreOP<>nil) then
   begin
   freeobj(@refcoreR);
   freeobj(@refcoreG);
   freeobj(@refcoreB);
   freeobj(@refcoreRGB);
   freeobj(@refcoreOP);
   end;
//.refs -> auto free - 30aug2020
if (refOP<>nil)  then str__uaf(@refOP);
if (refRGB<>nil) then str__uaf(@refRGB);
if (refR<>nil)   then str__uaf(@refR);
if (refG<>nil)   then str__uaf(@refG);
if (refB<>nil)   then str__uaf(@refB);
if (refX<>nil)   then str__uaf(@refX);
if (refY<>nil)   then str__uaf(@refY);
except;end;
end;


//extended graphics procs ------------------------------------------------------
function miscellsFPS10(s:tobject;var sbits,sw,sh,scellcount,scellw,scellh,sfps10:longint;var shasai:boolean;var stransparent:boolean):boolean;//27jul2021
var
   xms:longint;
begin
result:=miscells(s,sbits,sw,sh,scellcount,scellw,scellh,xms,shasai,stransparent);
if (xms<>0) then sfps10:=frcmin32(trunc(10000/xms),1) else sfps10:=0;//x10=>100=10.0 fps
end;

function mismove82432(s:tobject;xmove,ymove:longint):boolean;//19jun2021
begin
result:=mismove82432b(s,misarea(s),xmove,ymove);
end;

function mismove82432b(s:tobject;sa:twinrect;xmove,ymove:longint):boolean;//18nov2023, 19jun2021
begin
result:=mismove82432c(s,sa,xmove,ymove,false);
end;

function mismove82432c(s:tobject;sa:twinrect;xmove,ymove:longint;xdestructive:boolean):boolean;//18nov2023, 19jun2021
label
   skipend;
var
   a:tbasicimage;
   dr8,sr8:pcolorrow8;
   dr24,sr24:pcolorrow24;
   dr32,sr32:pcolorrow32;
   sc8:tcolor8;
   sc24:tcolor24;
   sc32:tcolor32;
   int1,int2,_xmove,_ymove,dw,dh,sbits,sw,sh,dx,dy,sx,sy:longint;
begin
//defaults
result:=false;

try
a:=nil;
//check
if not misok82432(s,sbits,dw,dh) then exit;
if (sa.left>sa.right) or (sa.top>sa.bottom) then exit;
//range
sa.left:=frcrange32(sa.left,0,dw-1);
sa.right:=frcrange32(sa.right,0,dw-1);
sa.top:=frcrange32(sa.top,0,dh-1);
sa.bottom:=frcrange32(sa.bottom,0,dh-1);
sw:=sa.right-sa.left+1;
sh:=sa.bottom-sa.top+1;
//init
xmove:=frcrange32(-xmove,-sw,sw);
ymove:=frcrange32(-ymove,-sh,sh);
_xmove:=xmove;
_ymove:=ymove;
if (xmove<0) then xmove:=sw+xmove else if (xmove>=sw) then xmove:=xmove-sw;//fixed - 18nov2023
if (ymove<0) then ymove:=sh+ymove else if (ymove>=sh) then ymove:=ymove-sh;
//check
if ((xmove<=0) or (xmove>=sw)) and ((ymove<=0) or (ymove>=sh)) then
   begin
   result:=true;
   exit;
   end;
//take a copy
a:=misimg(sbits,sw,sh);
//was: if not miscopyareaxx1(0,0,sw,sh,misarea(s),a,s) then goto skipend;
if not miscopyarea32(0,0,sw,sh,sa,a,s) then goto skipend;
//get
sy:=ymove;
for dy:=sa.top to sa.bottom do
begin
sx:=xmove;
if not misscan82432(a,sy,sr8,sr24,sr32) then goto skipend;
if not misscan82432(s,dy,dr8,dr24,dr32) then goto skipend;
//.32
if (sbits=32) then
   begin
   for dx:=sa.left to sa.right do
   begin
   sc32:=sr32[sx];
   dr32[dx]:=sc32;
   //inc
   inc(sx);
   if (sx>=sw) then sx:=0;
   end;//dx
   end
//.24
else if (sbits=24) then
   begin
   for dx:=sa.left to sa.right do
   begin
   sc24:=sr24[sx];
   dr24[dx]:=sc24;
   //inc
   inc(sx);
   if (sx>=sw) then sx:=0;
   end;//dx
   end
else if (sbits=8) then
   begin
   for dx:=sa.left to sa.right do
   begin
   sc8:=sr8[sx];
   dr8[dx]:=sc8;
   //inc
   inc(sx);
   if (sx>=sw) then sx:=0;
   end;//dx
   end;
//inc
inc(sy);
if (sy>=sh) then sy:=0;
end;//p

//.xdestructive
if xdestructive and (sbits=32) then
   begin
   int1:=0;
   int2:=0;
   //.h
   if (_xmove>=1) then misclsarea3(s,area__make(sw-1-_xmove,0,sw-1,sh-1),int1,int1,int2,int2)
   else if (_xmove<=-1) then misclsarea3(s,area__make(0,0,-_xmove,sh-1),int1,int1,int2,int2);
   //.v
   if (_ymove<-1) then misclsarea3(s,area__make(0,0,sw-1,1-_ymove),int1,int1,int2,int2)
   else if (_ymove>=1) then misclsarea3(s,area__make(0,sh-1-_ymove,sw-1,sh-1),int1,int1,int2,int2);
   end;

//successful
result:=true;
skipend:
except;end;
try;freeobj(@a);except;end;
end;

function mismatch82432(s,d:tobject;xtol,xfailrate:longint):boolean;//10jul2021
begin
result:=mismatcharea82432(s,d,misarea(s),misarea(d),xtol,xfailrate);
end;

function mismatcharea82432(s,d:tobject;sa,da:twinrect;xtol,xfailrate:longint):boolean;//10jul2021
label
   skipend;
var
   sr32,dr32:pcolorrow32;
   sr24,dr24:pcolorrow24;
   sr8,dr8:pcolorrow8;
   sc32,dc32:tcolor32;
   sc24,dc24:tcolor24;
   sc8,dc8:tcolor8;
   xfailcount,dx,dy,sbits,sw,sh,dbits,dw,dh:longint;
begin
//defaults
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;
if not misok82432(d,dbits,dw,dh) then exit;

//compare - fast
if (sbits<>dbits) then goto skipend;
//.xfailrate
xtol:=frcrange32(xtol,0,50);
xfailrate:=frcmin32(xfailrate,0);
//.range - sa
sa.left   :=frcrange32(sa.left  ,0,sw-1);
sa.right  :=frcrange32(sa.right ,0,sw-1);
sa.top    :=frcrange32(sa.top   ,0,sh-1);
sa.bottom :=frcrange32(sa.bottom,0,sh-1);
if (sa.right<sa.left) or (sa.bottom<sa.top) then goto skipend;
//.range - da
da.left   :=frcrange32(da.left  ,0,dw-1);
da.right  :=frcrange32(da.right ,0,dw-1);
da.top    :=frcrange32(da.top   ,0,dh-1);
da.bottom :=frcrange32(da.bottom,0,dh-1);
if (da.right<da.left) or (da.bottom<da.top) then goto skipend;
//.check
if ((sa.right-sa.left)<>(da.right-da.left)) then exit;
if ((sa.bottom-sa.top)<>(da.bottom-da.top)) then exit;

//compare - slow
for dy:=da.top to da.bottom do
begin
if not misscan82432(s,sa.top+(dy-da.top),sr8,sr24,sr32) then goto skipend;
if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;
xfailcount:=0;
//.32
if (sbits=32) then
   begin
   for dx:=da.left to da.right do
   begin
   sc32:=sr32[sa.left+(dx-da.left)];
   dc32:=dr32[dx];
   if (sc32.r<>dc32.r) or (sc32.g<>dc32.g) or (sc32.b<>dc32.b) or (sc32.a<>dc32.a) then
      begin
      inc(xfailcount);
      if (xfailcount>=xfailrate) then goto skipend;
      end;
   end;//dx
   end
//.24
else if (sbits=24) then
   begin
   for dx:=da.left to da.right do
   begin
   sc24:=sr24[sa.left+(dx-da.left)];
   dc24:=dr24[dx];
//   if (sc24.r<>dc24.r) or (sc24.g<>dc24.g) or (sc24.b<>dc24.b) then
   if (sc24.r<(dc24.r-xtol)) or (sc24.r>(dc24.r+xtol)) or
      (sc24.g<(dc24.g-xtol)) or (sc24.g>(dc24.g+xtol)) or
      (sc24.b<(dc24.b-xtol)) or (sc24.b>(dc24.b+xtol)) then
      begin
      inc(xfailcount);
      if (xfailcount>=xfailrate) then goto skipend;
      end;
   end;//dx
   end
//.8
else if (sbits=8) then
   begin
   for dx:=da.left to da.right do
   begin
   sc8:=sr8[sa.left+(dx-da.left)];
   dc8:=dr8[dx];
   if (sc8<>dc8) then
      begin
      inc(xfailcount);
      if (xfailcount>=xfailrate) then goto skipend;
      end;
   end;//dx
   end;
end;//dy

//successful
result:=true;
skipend:
except;end;
end;

function misclean(s:tobject;scol,stol:longint):boolean;//19sep2022
label
   skipend;
var
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8:pcolorrow8;
   c32:tcolor32;
   s24,c24:tcolor24;
   c8:tcolor8;
   slum,sx,sy,sbits,sw,sh:longint;
   r1,r2,g1,g2,b1,b2,slum1,slum2:longint;
begin
//defaults
result:=false;

try
//check
if (scol=clnone) then
   begin
   result:=true;
   exit;
   end;
if not misok82432(s,sbits,sw,sh) then exit;
//range
s24:=int__c24(misfindtranscol82432(s,scol));
stol:=frcrange32(stol,0,255);
r1:=s24.r-stol;
r2:=s24.r+stol;
g1:=s24.g-stol;
g2:=s24.g+stol;
b1:=s24.b-stol;
b2:=s24.b+stol;
slum:=c24__greyscale2b(s24);
slum1:=slum-stol;
slum2:=slum+stol;

//get
for sy:=0 to (sh-1) do
begin
//.scan
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   if (c32.r>=r1) and (c32.r<=r2) and (c32.g>=g1) and (c32.g<=g2) and (c32.b>=b1) and (c32.b<=b2) then
      begin
      c32.r:=s24.r;
      c32.g:=s24.g;
      c32.b:=s24.b;
      sr32[sx]:=c32;
      end;
   end;//sx
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   if (c24.r>=r1) and (c24.r<=r2) and (c24.g>=g1) and (c24.g<=g2) and (c24.b>=b1) and (c24.b<=b2) then sr24[sx]:=s24;
   end;//sx
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c8:=sr8[sx];
   if (c8>=slum1) and (c8<=slum2) then sr8[sx]:=slum;
   end;//sx
   end;
end;//sy

//successful
result:=true;
skipend:
except;end;
end;

function miscopyarea(d,s:hdc;a:twinrect):boolean;
begin
result:=miscopyarea2(d,s,a,a);
end;

function miscopyarea2(d,s:hdc;da,sa:twinrect):boolean;
begin
//defaults
result:=false;
//check
if (d=0) or (s=0) then exit;
if (da.right<da.left) or (da.bottom<da.top) or (sa.right<sa.left) or (sa.bottom<sa.top) then
   begin
   result:=true;
   exit;
   end;
//get
win____StretchBlt(d,da.left,da.top,da.right-da.left+1,da.bottom-da.top+1,d,da.left,sa.top,sa.right-sa.left+1,sa.bottom-sa.top+1,3);//3=ColorOnColor
result:=true;
end;

function miscopypixels(var drows,srows:pcolorrows8;xbits,xw,xh:longint):boolean;
var//Assumed: common to both is xbits, xw and xh
   //Note: Ultra-rapid pixel copier -> upto 2x-4x faster - 18may2020
   sr8,dr8:pcolorrow8;
   sr96,dr96:pcolorrow96;
   srs8,drs8:pcolorrows8;
   srs96,drs96:pcolorrows96;
   c96:tcolor96;
   dx,dy,vrowsize,v1,v2,vpos:longint;
   b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10:boolean;
begin
//defaults
result:=false;

try
//check
if (srows=nil) or (drows=nil) or (xw<1) or (xh<1) then exit;
if (xbits<>8) and (xbits<>24) and (xbits<>32) then exit;
//init
//.8
srs8:=ptr__shift(srows,0);
drs8:=ptr__shift(drows,0);
//.96
srs96:=ptr__shift(srows,0);
drs96:=ptr__shift(drows,0);
//.v1 + v2
vrowsize:=(xbits div 8)*xw;
v1:=(vrowsize div sizeof(tcolor96));
v2:=vrowsize-(v1*sizeof(tcolor96));
vpos:=vrowsize-v2;
b0:=(v2>=1);
b1:=(v2>=2);
b2:=(v2>=3);
b3:=(v2>=4);
b4:=(v2>=5);
b5:=(v2>=6);
b6:=(v2>=7);
b7:=(v2>=8);
b8:=(v2>=9);
b9:=(v2>=10);
b10:=(v2>=11);
//get
for dy:=0 to (xh-1) do
begin
//.continue
sr8:=srs8[dy];
dr8:=drs8[dy];
sr96:=srs96[dy];
dr96:=drs96[dy];
//.v1 - large blocks
if (v1>=1) then
   begin
   for dx:=0 to (v1-1) do
   begin
   c96:=sr96[dx];
   dr96[dx]:=c96;
   end;//dx
   end;
//.v2 - small blocks
if b0 then dr8[vpos+0]:=tcolor8(sr8[vpos+0]);
if b1 then dr8[vpos+1]:=tcolor8(sr8[vpos+1]);
if b2 then dr8[vpos+2]:=tcolor8(sr8[vpos+2]);
if b3 then dr8[vpos+3]:=tcolor8(sr8[vpos+3]);
if b4 then dr8[vpos+4]:=tcolor8(sr8[vpos+4]);
if b5 then dr8[vpos+5]:=tcolor8(sr8[vpos+5]);
if b6 then dr8[vpos+6]:=tcolor8(sr8[vpos+6]);
if b7 then dr8[vpos+7]:=tcolor8(sr8[vpos+7]);
if b8 then dr8[vpos+8]:=tcolor8(sr8[vpos+8]);
if b9 then dr8[vpos+9]:=tcolor8(sr8[vpos+9]);
if b10 then dr8[vpos+10]:=tcolor8(sr8[vpos+10]);
end;//dy
//successful
result:=true;
except;end;
end;

function miscursorpos:tpoint;
begin
win____getcursorpos(result);
end;

function misempty(s:tobject):boolean;
var
   sw,sh:longint;
begin
result:=false;
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) or ((sw<=1) and (sh<=1)) or (misb(s)<=0) then result:=true;
end;

function misbytes(s:tobject):comp;
begin
result:=mult64(mult64(misw(s),mish(s)),misb(s) div 8);
end;

function misbytes32(s:tobject):longint;
begin
result:=restrict32(misbytes(s));
end;

function misblur82432(s:tobject):boolean;//03sep2021
begin
result:=misblur82432b(s,false,255,clnone);
end;

function misblur82432b(s:tobject;xwraprange:boolean;xpower255,xtranscol:longint):boolean;//11sep2021, 03sep2021
begin
result:=misblur82432c(s,maxarea,xwraprange,xpower255,xtranscol);
end;

function misblur82432c(s:tobject;scliparea:twinrect;xwraprange:boolean;xpower255,xtranscol:longint):boolean;//17may2022 - cell-based clipping, 27apr2022, 11sep2021, 03sep2021
begin
result:=misblur82432d(s,scliparea,xwraprange,xpower255,xtranscol,-1);
end;

function misblur82432d(s:tobject;scliparea:twinrect;xwraprange:boolean;xpower255,xtranscol,xstage:longint):boolean;//30dec2022 - stage support (-1 to 2), 17may2022 - cell-based clipping, 27apr2022, 11sep2021, 03sep2021
label
   skipend;
var
   tr,tg,tb,trsafe,tgsafe,tbsafe:longint;//transparency support - 11sep2021
   r,g,b,a,c,sx,sy,sbits,sw,sh:longint;
   srows8:pcolorrows8;
   srows24:pcolorrows24;
   srows32:pcolorrows32;
   c8,sc8:tcolor8;
   c24,sc24:tcolor24;
   c32,sc32:tcolor32;

   procedure xadd32(sx,sy:longint);
   begin
   //wrap range
   if xwraprange then
      begin
      if (sx<scliparea.left) then inc(sx,(scliparea.right-scliparea.left+1)) else if (sx>scliparea.right) then dec(sx,(scliparea.right-scliparea.left+1));
      if (sy<scliparea.top) then inc(sy,(scliparea.bottom-scliparea.top+1)) else if (sy>scliparea.bottom) then dec(sy,(scliparea.bottom-scliparea.top+1));
      end;
   //check
   if (sx<scliparea.left) or (sx>scliparea.right) or (sy<scliparea.top) or (sy>scliparea.bottom) then exit;//17may2022
   //get
   sc32:=srows32[sy][sx];
   if (sc32.a<=0) then exit;
   if (tr=sc32.r) and (tg=sc32.g) and (tb=sc32.b) then exit;//transparency check
   inc(r,sc32.r);
   inc(g,sc32.g);
   inc(b,sc32.b);
   inc(a,sc32.a);
   inc(c);
   end;

   procedure xadd24(sx,sy:longint);
   begin
   //wrap range
   if xwraprange then
      begin
      if (sx<scliparea.left) then inc(sx,(scliparea.right-scliparea.left+1)) else if (sx>scliparea.right) then dec(sx,(scliparea.right-scliparea.left+1));
      if (sy<scliparea.top) then inc(sy,(scliparea.bottom-scliparea.top+1)) else if (sy>scliparea.bottom) then dec(sy,(scliparea.bottom-scliparea.top+1));
      end;
   //check
   if (sx<scliparea.left) or (sx>scliparea.right) or (sy<scliparea.top) or (sy>scliparea.bottom) then exit;//17may2022
   //get
   sc24:=srows24[sy][sx];
   if (tr=sc24.r) and (tg=sc24.g) and (tb=sc24.b) then exit;//transparency check
   inc(r,sc24.r);
   inc(g,sc24.g);
   inc(b,sc24.b);
   inc(c);
   end;

   procedure xadd8(sx,sy:longint);
   begin
   //wrap range
   if xwraprange then
      begin
      if (sx<scliparea.left) then inc(sx,(scliparea.right-scliparea.left+1)) else if (sx>scliparea.right) then dec(sx,(scliparea.right-scliparea.left+1));
      if (sy<scliparea.top) then inc(sy,(scliparea.bottom-scliparea.top+1)) else if (sy>scliparea.bottom) then dec(sy,(scliparea.bottom-scliparea.top+1));
      end;
   //check
   if (sx<scliparea.left) or (sx>scliparea.right) or (sy<scliparea.top) or (sy>scliparea.bottom) then exit;//17may2022
   //get
   sc8:=srows8[sy][sx];
   if (tr=sc8) then exit;//transparency check
   inc(r,sc8);
   inc(c);
   end;

   procedure sblur32;
   begin
   //init
   r:=0;
   g:=0;
   b:=0;
   a:=0;
   c:=0;
   //get
   xadd32(sx,sy);
   if (c=0) then exit;

   //stage output: -1=rough1+rough2 (system default), 0=rough1, 1=rough1+fine1, 2=rough1+fine1+rough2
   //rough1
   xadd32(sx-1,sy);
   xadd32(sx+1,sy);
   xadd32(sx,sy-1);
   xadd32(sx,sy+1);

   if (xstage=-1) or (xstage=2) then//add rough2
      begin
      xadd32(sx-2,sy);
      xadd32(sx+2,sy);
      xadd32(sx,sy-2);
      xadd32(sx,sy+2);
      end;
   if (xstage>=1) then//add fine1
      begin
      xadd32(sx-1,sy-1);
      xadd32(sx+1,sy-1);
      xadd32(sx-1,sy+1);
      xadd32(sx+1,sy+1);
      end;

   //set
   sc32.r:=trunc(r div c);
   sc32.g:=trunc(g div c);
   sc32.b:=trunc(b div c);
   sc32.a:=trunc(a div c);
   end;

   procedure sblur24;
   begin
   //init
   r:=0;
   g:=0;
   b:=0;
   a:=0;
   c:=0;
   //get
   xadd24(sx,sy);
   if (c=0) then exit;

   //stage output: -1=rough1+rough2 (system default), 0=rough1, 1=rough1+fine1, 2=rough1+fine1+rough2
   //rough1
   xadd24(sx-1,sy);
   xadd24(sx+1,sy);
   xadd24(sx,sy-1);
   xadd24(sx,sy+1);

   if (xstage=-1) or (xstage=2) then//add rough2
      begin
      xadd24(sx-2,sy);
      xadd24(sx+2,sy);
      xadd24(sx,sy-2);
      xadd24(sx,sy+2);
      end;
   if (xstage>=1) then//add fine1
      begin
      xadd24(sx-1,sy-1);
      xadd24(sx+1,sy-1);
      xadd24(sx-1,sy+1);
      xadd24(sx+1,sy+1);
      end;

   //set
   sc24.r:=trunc(r div c);
   sc24.g:=trunc(g div c);
   sc24.b:=trunc(b div c);
   end;

   procedure sblur8;
   begin
   //init
   r:=0;
   g:=0;
   b:=0;
   a:=0;
   c:=0;
   //get
   xadd8(sx,sy);
   if (c=0) then exit;

   //stage output: -1=rough1+rough2 (system default), 0=rough1, 1=rough1+fine1, 2=rough1+fine1+rough2
   //rough1
   xadd8(sx-1,sy);
   xadd8(sx+1,sy);
   xadd8(sx,sy-1);
   xadd8(sx,sy+1);

   if (xstage=-1) or (xstage=2) then//add rough2
      begin
      xadd8(sx-2,sy);
      xadd8(sx+2,sy);
      xadd8(sx,sy-2);
      xadd8(sx,sy+2);
      end;
   if (xstage>=1) then//add fine1
      begin
      xadd8(sx-1,sy-1);
      xadd8(sx+1,sy-1);
      xadd8(sx-1,sy+1);
      xadd8(sx+1,sy+1);
      end;

   //set
   sc8:=trunc(r div c);
   end;
begin
//defaults
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;
//init
if not misrows82432(s,srows8,srows24,srows32) then goto skipend;
//.scliparea - 27apr2022
scliparea.left:=frcrange32(scliparea.left,0,sw-1);
scliparea.right:=frcrange32(scliparea.right,scliparea.left,sw-1);
scliparea.top:=frcrange32(scliparea.top,0,sh-1);
scliparea.bottom:=frcrange32(scliparea.bottom,scliparea.top,sh-1);
//.transparency - leave transparent pixels FULLY intact - 11sep2021
tr:=-1;
tg:=-1;
tb:=-1;
trsafe:=0;
tgsafe:=0;
tbsafe:=0;
if (xtranscol=clTopLeft) then xtranscol:=mispixel24VAL(s,0,0);
if (xtranscol<>clnone) then
   begin
   sc24:=int__c24(xtranscol);
   tr:=sc24.r;
   tg:=sc24.g;
   tb:=sc24.b;
   //.safe alternative
   if (tr>=1) then trsafe:=tr-1 else trsafe:=1;
   tgsafe:=tg;
   tbsafe:=tb;
   end;

//range
xpower255:=frcrange32(xpower255,0,255);//11sep2021
//get
//.32
if (sbits=32) then
   begin
   for sy:=scliparea.top to scliparea.bottom do
   begin
   for sx:=scliparea.left to scliparea.right do
   begin
   sblur32;
   if (c>=1) then
      begin
      if (xpower255<255) then
         begin
         c32:=srows32[sy][sx];
         sc32.r:=ref65025_div_255[((c32.r*(255-xpower255))+(sc32.r*xpower255))];//18ms
         sc32.g:=ref65025_div_255[((c32.g*(255-xpower255))+(sc32.g*xpower255))];//18ms
         sc32.b:=ref65025_div_255[((c32.b*(255-xpower255))+(sc32.b*xpower255))];//18ms
         sc32.a:=ref65025_div_255[((c32.a*(255-xpower255))+(sc32.a*xpower255))];//18ms
         end;
      //.don't use transparent color - 11sep2021
      if (tr>=0) then
         begin
         if (tr=sc32.r) and (tg=sc32.g) and (tb=sc32.b) then
            begin
            sc32.r:=trsafe;
            sc32.g:=tgsafe;
            sc32.b:=tbsafe;
            end;
         end;
      srows32[sy][sx]:=sc32;
      end;
   end;//dx
   end;//dy
   end
//.24
else if (sbits=24) then
   begin
   for sy:=scliparea.top to scliparea.bottom do
   begin
   for sx:=scliparea.left to scliparea.right do
   begin
   sblur24;
   if (c>=1) then
      begin
      if (xpower255<255) then
         begin
         c24:=srows24[sy][sx];
         sc24.r:=ref65025_div_255[((c24.r*(255-xpower255))+(sc24.r*xpower255))];//18ms
         sc24.g:=ref65025_div_255[((c24.g*(255-xpower255))+(sc24.g*xpower255))];//18ms
         sc24.b:=ref65025_div_255[((c24.b*(255-xpower255))+(sc24.b*xpower255))];//18ms
         end;
      //.don't use transparent color - 11sep2021
      if (tr>=0) then
         begin
         if (tr=sc24.r) and (tg=sc24.g) and (tb=sc24.b) then
            begin
            sc24.r:=trsafe;
            sc24.g:=tgsafe;
            sc24.b:=tbsafe;
            end;
         end;
      srows24[sy][sx]:=sc24;
      end;
   end;//dx
   end;//dy
   end
//.8
else if (sbits=8) then
   begin
   for sy:=scliparea.top to scliparea.bottom do
   begin
   for sx:=scliparea.left to scliparea.right do
   begin
   sblur8;
   if (c>=1) then
      begin
      if (xpower255<255) then
         begin
         c8:=srows8[sy][sx];
         sc8:=ref65025_div_255[((c8*(255-xpower255))+(sc8*xpower255))];//18ms
         end;
      //.don't use transparent color - 11sep2021
      if (tr>=0) then
         begin
         if (tr=sc8) then sc8:=trsafe;
         end;
      srows8[sy][sx]:=sc8;
      end;
   end;//dx
   end;//dy
   end;

//successful
result:=true;
skipend:
except;end;
end;

function misIconArt82432(s,s2:tobject;xzoom,xbackcolor,xtranscolor:longint;xpadding:boolean):boolean;//27apr2022
label
   skipend;
const
   szoom=4;
var
   d:tbasicimage;
   sr8,dr8:pcolorrows8;
   sr24,dr24:pcolorrows24;
   sr32,dr32:pcolorrows32;
   tr,tg,tb,dx,dy,sx,sy,sw,sh,sbits,dw,dh:longint;
   sc8:tcolor8;
   tcSAFE24,sc24:tcolor24;
   sc32:tcolor32;
   xuse32:boolean;

   procedure dinit;
   begin
   dx:=sx*szoom;
   dy:=sy*szoom;
   end;

   function dcol8(xshift:longint):tcolor8;
   var
      v:longint;
   begin
   //check
   if (sc8=tr) then
      begin
      result:=sc8;
      exit;
      end;
   //r
   v:=(sc8*(255+xshift) div 255);
   if (v<0) then v:=0 else if (v>255) then v:=255;
   result:=v;
   //tc safe
   if (tr=result) then result:=tcSAFE24.r;
   end;

   function dcol24(xshift:longint):tcolor24;
   var
      v:longint;
   begin
   //check
   if (sc24.r=tr) and (sc24.g=tg) and (sc24.b=tb) then
      begin
      result:=sc24;
      exit;
      end;
   //r
   v:=(sc24.r*(255+xshift) div 255);
   if (v<0) then v:=0 else if (v>255) then v:=255;
   result.r:=v;
   //g
   v:=sc24.g*(255+xshift) div 255;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   result.g:=v;
   //b
   v:=sc24.b*(255+xshift) div 255;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   result.b:=v;
   //tc safe
   if (tr=result.r) and (tg=result.g) and (tb=result.b) then result:=tcSAFE24;
   end;

   function dcol32(xshift:longint):tcolor32;
   var
      v:longint;
   begin
   //check
   if (sc32.a=0) then
      begin
      result:=sc32;
      exit;
      end
   else if (sc32.r=tr) and (sc32.g=tg) and (sc32.b=tb) then
      begin
      result:=sc32;
      result.a:=0;//fully transparent
      exit;
      end;
   //r
   v:=(sc32.r*(255+xshift) div 255);
   if (v<0) then v:=0 else if (v>255) then v:=255;
   result.r:=v;
   //g
   v:=sc32.g*(255+xshift) div 255;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   result.g:=v;
   //b
   v:=sc32.b*(255+xshift) div 255;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   result.b:=v;
   //a
   result.a:=sc32.a;
   //tc safe
   if (tr=result.r) and (tg=result.g) and (tb=result.b) then
      begin
      result.r:=tcSAFE24.r;
      result.g:=tcSAFE24.g;
      result.b:=tcSAFE24.b;
      end;
   end;

   procedure d8(xshift,yshift,cshift:longint);
   begin
   dr8[dy+yshift][dx+xshift]:=dcol8(cshift);
   end;

   procedure d24(xshift,yshift,cshift:longint);
   begin
   dr24[dy+yshift][dx+xshift]:=dcol24(cshift);
   end;

   procedure d32(xshift,yshift,cshift:longint);
   begin
   dr32[dy+yshift][dx+xshift]:=dcol32(cshift);
   end;

   procedure dadd8;
   begin
   //init
   dinit;

   //center 2x2
   d8(1,1,50);
   d8(2,1,40);
   d8(1,2,30);
   d8(2,2,60);

   //top 2x1
   d8(1,0,22);
   d8(2,0,17);

   //bottom 2x1
   d8(1,3,-17);
   d8(2,3,-22);

   //left 1x2
   d8(0,1,-19);
   d8(0,2,-10);

   //right 1x2
   d8(3,1,17);
   d8(3,2,22);

   //top-left
   d8(0,0,11);
   //top-right
   d8(3,0,11);
   //bottom-left
   d8(0,3,-11);
   //bottom-right
   d8(3,3,-11);
   end;

   procedure dadd24;
   begin
   //init
   dinit;

   //center 2x2
   d24(1,1,50);
   d24(2,1,40);
   d24(1,2,30);
   d24(2,2,60);

   //top 2x1
   d24(1,0,22);
   d24(2,0,17);

   //bottom 2x1
   d24(1,3,-17);
   d24(2,3,-22);

   //left 1x2
   d24(0,1,-19);
   d24(0,2,-10);

   //right 1x2
   d24(3,1,17);
   d24(3,2,22);

   //top-left
   d24(0,0,11);
   //top-right
   d24(3,0,11);
   //bottom-left
   d24(0,3,-11);
   //bottom-right
   d24(3,3,-11);
   end;

   procedure dadd32;
   begin
   //init
   dinit;

   //center 2x2
   d32(1,1,50);
   d32(2,1,40);
   d32(1,2,30);
   d32(2,2,60);

   //top 2x1
   d32(1,0,22);
   d32(2,0,17);

   //bottom 2x1
   d32(1,3,-17);
   d32(2,3,-22);

   //left 1x2
   d32(0,1,-19);
   d32(0,2,-10);

   //right 1x2
   d32(3,1,17);
   d32(3,2,22);

   //top-left
   d32(0,0,11);
   //top-right
   d32(3,0,11);
   //bottom-left
   d32(0,3,-11);
   //bottom-right
   d32(3,3,-11);
   end;
begin
//defaults
result:=false;

try
d:=nil;
//check
if not misok82432(s,sbits,sw,sh) then goto skipend;
if not misrows82432(s,sr8,sr24,sr32) then goto skipend;
//range
xzoom:=frcrange32(xzoom,1,10);
//init
dw:=sw*szoom;
dh:=sh*szoom;
d:=misimg(sbits,dw,dh);
if not misrows82432(d,dr8,dr24,dr32) then goto skipend;
//.use32 - 11jun2022, 19nov2024: added "mask__hastransparency"
xuse32:=(sbits=32) and (misai(s).use32 or mask__hastransparency32(s)) and (misb(s2)=32);
if xuse32 then
   begin
   xtranscolor:=clnone;
   xbackcolor:=clnone;
   end;
//.transparent color
tr:=-1;
tg:=-1;
tb:=-1;
xtranscolor:=mistranscol(s,xtranscolor,xtranscolor<>clnone);
if (xtranscolor<>clnone) then
   begin
   sc24:=int__c24(xtranscolor);
   tr:=sc24.r;
   tg:=sc24.g;
   tb:=sc24.b;
   tcSAFE24:=sc24;
   //fixed out of bounds / integer overflow error - 17sep202
   if (tcSAFE24.r>=3) then//avoid using BLACK
      begin
      dec(tcSAFE24.r);
      if (tcSAFE24.g>=1) then dec(tcSAFE24.g);
      if (tcSAFE24.b>=1) then dec(tcSAFE24.b);
      end
   else
      begin
      inc(tcSAFE24.r);
      if (tcSAFE24.g<255) then inc(tcSAFE24.g);
      if (tcSAFE24.b<255) then inc(tcSAFE24.b);
      end;
   end;
//.cls
if xuse32                    then mask__setval(d,0)//mask=0=transparent - 11jun2022
else if (tr>=0)              then miscls(d,xtranscolor)
else if (xbackcolor<>clnone) then miscls(d,xbackcolor)
else                              miscls(d,mispixel24VAL(s,0,0));
//get
for sy:=0 to (sh-1) do
begin
if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc8:=sr8[sy][sx];
   dadd8;
   end;//sx
   end
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc24:=sr24[sy][sx];
   dadd24;
   end;//sx
   end
else if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   sc32:=sr32[sy][sx];
   dadd32;
   end;//sx
   end;
end;//sy

//set
if not missize(s2,(dw*xzoom)+low__insint(2,xpadding),(dh*xzoom)+low__insint(2,xpadding)) then goto skipend;
if xpadding then
   begin
   if xuse32                    then mask__setval(s2,0)//mask=0=transparent - 11jun2022
   else if (tr>=0)              then miscls(s2,xtranscolor)
   else if (xbackcolor<>clnone) then miscls(s2,xbackcolor)
   else                              miscls(s2,mispixel24VAL(s,0,0));
   end;

case xpadding of
true:if not miscopyarea32(1,1,misw(s2)-2,mish(s2)-2,misarea(d),s2,d) then goto skipend;
else if not miscopyarea32(0,0,misw(s2),mish(s2),misarea(d),s2,d) then goto skipend;
end;//case

//successful
result:=true;
skipend:
except;end;
try;freeobj(@d);except;end;
end;

function miscrop82432(s:tobject):boolean;
var
   l,t,r,b:longint;
begin
result:=miscrop82432b(s,mispixel32(s,0,0),l,t,r,b,false,false,true);
end;

function miscrop82432b(s:tobject;t32:tcolor32;var l,t,r,b:longint;xcalonly,xusealpha,xretainT32:boolean):boolean;//21jun20221
label
   skipend;
var
   a:tbasicimage;
   c32:tcolor32;
   c24:tcolor24;
   c8:tcolor8;
   sx,sy,sy2,sbits,sw,sh:longint;
   sr32,sr32b:pcolorrow32;
   sr24,sr24b:pcolorrow24;
   sr8,sr8b:pcolorrow8;
   t8:byte;
   tok,bok:boolean;
begin
//defaults
result:=false;

try
a:=nil;
l:=0;
t:=0;
r:=0;
b:=0;
//check
if not misok82432(s,sbits,sw,sh) then goto skipend;
if (sw<=1) and (sh<=1) then
   begin
   result:=true;
   goto skipend;
   end;
//init
l:=sw-1;
r:=0;
t:=0;
b:=sh-1;
t8:=c24__greyscale2b(c32__c24(t32));
//.left/right
tok:=true;
bok:=true;
for sy:=0 to (sh-1) do
begin
sy2:=(sh-1)-sy;
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
if not misscan82432(s,sy2,sr8b,sr24b,sr32b) then goto skipend;
//.32
if (sbits=32) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c32:=sr32[sx];
   //l
   if (sx<l) and ((c32.r<>t32.r) or (c32.g<>t32.g) or (c32.b<>t32.b) or ((not xusealpha) or (c32.a>=1))) then l:=sx;
   //r
   if (sx>r) and ((c32.r<>t32.r) or (c32.g<>t32.g) or (c32.b<>t32.b) or ((not xusealpha) or (c32.a>=1))) then r:=sx;
   //t
   if tok and (sy>t) and ((c32.r<>t32.r) or (c32.g<>t32.g) or (c32.b<>t32.b) or ((not xusealpha) or (c32.a>=1))) then
      begin
      t:=sy;
      tok:=false;
      end;
   //b
   c32:=sr32b[sx];
   if bok and (sy2<b) and ((c32.r<>t32.r) or (c32.g<>t32.g) or (c32.b<>t32.b) or ((not xusealpha) or (c32.a>=1))) then
      begin
      b:=sy2;
      bok:=false;
      end;
   end;//sx
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c24:=sr24[sx];
   //l
   if (sx<l) and ((c24.r<>t32.r) or (c24.g<>t32.g) or (c24.b<>t32.b)) then l:=sx;
   //r
   if (sx>r) and ((c24.r<>t32.r) or (c24.g<>t32.g) or (c24.b<>t32.b)) then r:=sx;
   //t
   if tok and (sy>t) and ((c24.r<>t32.r) or (c24.g<>t32.g) or (c24.b<>t32.b)) then
      begin
      t:=sy;
      tok:=false;
      end;
   //b
   c24:=sr24b[sx];
   if bok and (sy2<b) and ((c24.r<>t32.r) or (c24.g<>t32.g) or (c24.b<>t32.b)) then
      begin
      b:=sy2;
      bok:=false;
      end;
   end;//sx
   end
//.8
else if (sbits=8) then
   begin
   for sx:=0 to (sw-1) do
   begin
   c8:=sr8[sx];
   //l
   if (sx<l) and (c8<>t8) then l:=sx;
   //r
   if (sx>r) and (c8<>t8) then r:=sx;
   //t
   if tok and (sy>t) and (8<>t8) then
      begin
      t:=sy;
      tok:=false;
      end;
   //b
   c8:=sr8b[sx];
   if bok and (sy2<b) and (8<>t8) then
      begin
      b:=sy2;
      bok:=false;
      end;
   end;//sx
   end;
//check -> stop early - 21jun2022
if (not tok) and (not bok) and (l>=(sw-1)) and (r<=0) or (r<=l) or (b<=t) then break;
end;//sy
//range
l:=frcrange32(l,0,sw-1);
r:=frcrange32(r,l,sw-1);
t:=frcrange32(t,0,sh-1);
b:=frcrange32(b,t,sh-1);
//check
if xcalonly or ((l=0) and (t=0) and (r=(sw-1)) and (b=(sh-1))) then
   begin
   result:=true;
   goto skipend;
   end;
//redraw
a:=misimg(sbits,r-l+1,b-t+1);
if not miscopyarea32(0,0,misw(a),mish(a),area__make(l,t,r,b),a,s) then goto skipend;
//set
if not missize(s,misw(a),mish(a)) then goto skipend;
if not miscls(s,rgba0__int(t32.r,t32.g,t32.b)) then goto skipend;
if not miscopyarea32(0,0,misw(a),mish(a),misarea(a),s,a) then goto skipend;
//top-left pixel
if xretainT32 then
   begin
   c32.r:=t32.r;
   c32.g:=t32.g;
   c32.b:=t32.b;
   c32.a:=t32.a;
   missetpixel32(s,0,0,c32);
   end;
//successful
result:=true;
skipend:
except;end;
try;freeobj(@a);except;end;
end;

function misframe82432(s:tobject;da_cliparea,xouterarea:twinrect;xautoouterarea:boolean;var slist:array of longint;scount:longint;var e:string):boolean;//28jan2021
begin
result:=misframe82432ex(s,da_cliparea,xouterarea,xautoouterarea,slist,scount,e);
end;

function misframe82432ex(s:tobject;da_cliparea,xouterarea:twinrect;xautoouterarea:boolean;var slist:array of longint;scount:longint;var e:string):boolean;//28jan2021
label//slist is a series of numbers that create a series of "framesets" that draw the frame
   skipdone,skipend;
const
   xblocks_per_frameset=5;//5x longint
var
   //framesets
   xfcount:longint;//frameset (c)ount => number of framesets in use
   xfs:array[0..199] of longint;//(s)ource color of frameset
   xfd:array[0..199] of longint;//(d)estination color of frameset
   xft:array[0..199] of longint;//(t)exture level in frameset (0=off, 1=subtle, 20=maximum) inline with Gossamer's own frame handling
   xfo:array[0..199] of longint;//(o)pacity level in frameset (0=not visible, 127=semi-see-thru, 255=fully solid) - used by Framer Plus
   xfw:array[0..199] of longint;//(w)idth of frameset in pixels
   //vars
   xi,dpert,fs,fd,fi,fw,xrich,xrich2,sbits,sw,sh,p,xsize:longint;
   sr8 :pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc8 ,dc8 :tcolor8;
   sc24,dc24:tcolor24;
   sc32,dc32:tcolor32;
   srows8:pcolorrows8;
   srows24:pcolorrows24;
   srows32:pcolorrows32;
   fa:twinrect;

   procedure xrich8;
   var
      v,b1:longint;
   begin
   b1:=random(xrich);
   //.v
   v:=sc8+b1-xrich2;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   dc8:=byte(v);
   end;

   procedure xrich24;
   var
      v,b1:longint;
   begin
   //.sparkle
   b1:=random(xrich);
   //.r
   v:=sc24.r+b1-xrich2;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   dc24.r:=byte(v);
   //.g
   v:=sc24.g+b1-xrich2;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   dc24.g:=byte(v);
   //.b
   v:=sc24.b+b1-xrich2;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   dc24.b:=byte(v);
   end;

   procedure xrich32;
   var
      v,b1:longint;
   begin
   //.sparkle
   b1:=random(xrich);
   //.r
   v:=sc32.r+b1-xrich2;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   dc32.r:=byte(v);
   //.g
   v:=sc32.g+b1-xrich2;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   dc32.g:=byte(v);
   //.b
   v:=sc32.b+b1-xrich2;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   dc32.b:=byte(v);
   end;

   function fok(xindex:longint):boolean;//frameset is OK
   begin
   result:=(xindex>=0) and (xindex<=high(xfs)) and (xindex<xfcount) and (xfw[xindex]>=1);
   end;

   procedure xdrawframe(xleft,xtop,xright,xbottom:longint);//draws a single line frame
   var
      sx,sy:longint;
   begin
   //top
   if (xtop>=da_cliparea.top) and (xtop<=da_cliparea.bottom) and (xright>=da_cliparea.left) and (xleft<=da_cliparea.right) then
      begin
      case sbits of
      //.8
      8:begin
         sr8:=srows8[xtop];
         if (xrich>=1) then
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            xrich8;
            sr8[sx]:=dc8;
            end;//sx
            end
         else
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            sr8[sx]:=dc8;
            end;//sx
            end;//if
         end;//8
      //.24
      24:begin
         sr24:=srows24[xtop];
         if (xrich>=1) then
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            xrich24;
            sr24[sx]:=dc24;
            end;//sx
            end
         else
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            sr24[sx]:=dc24;
            end;//sx
            end;//if
         end;//24
      //.32
      32:begin
         sr32:=srows32[xtop];
         if (xrich>=1) then
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            xrich32;
            sc32.a:=255;
            sr32[sx]:=dc32;
            end;//sx
            end
         else
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            sc32.a:=255;
            sr32[sx]:=dc32;
            end;//sx
            end;//if
         end;//32
      end;//case
      end;//top
   //bottom
   if (xbottom>=da_cliparea.top) and (xbottom<=da_cliparea.bottom) and (xright>=da_cliparea.left) and (xleft<=da_cliparea.right) then
      begin
      case sbits of
      //.8
      8:begin
         sr8:=srows8[xbottom];
         if (xrich>=1) then
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            xrich8;
            sr8[sx]:=dc8;
            end;//sx
            end
         else
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            sr8[sx]:=dc8;
            end;//sx
            end;//if
         end;//8
      //.24
      24:begin
         sr24:=srows24[xbottom];
         if (xrich>=1) then
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            xrich24;
            sr24[sx]:=dc24;
            end;//sx
            end
         else
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            sr24[sx]:=dc24;
            end;//sx
            end;//if
         end;//24
      //.32
      32:begin
         sr32:=srows32[xbottom];
         if (xrich>=1) then
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            xrich32;
            sc32.a:=255;
            sr32[sx]:=dc32;
            end;//sx
            end
         else
            begin
            for sx:=xleft to xright do if (sx>=da_cliparea.left) and (sx<=da_cliparea.right) then
            begin
            sc32.a:=255;
            sr32[sx]:=dc32;
            end;//sx
            end;//if
         end;//32
      end;//case
      end;//xbottom
   //left
   if (xbottom>=da_cliparea.top) and (xtop<=da_cliparea.bottom) and (xleft>=da_cliparea.left) and (xleft<=da_cliparea.right) then
      begin
      case sbits of
      //.8
      8:begin
         if (xrich>=1) then
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            xrich8;
            srows8[sy][xleft]:=dc8;
            end;//sx
            end
         else
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            srows8[sy][xleft]:=dc8;
            end;//sx
            end;//if
         end;//24
      //.24
      24:begin
         if (xrich>=1) then
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            xrich24;
            srows24[sy][xleft]:=dc24;
            end;//sx
            end
         else
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            srows24[sy][xleft]:=dc24;
            end;//sx
            end;//if
         end;//24
      //.32
      32:begin
         if (xrich>=1) then
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            xrich32;
            srows32[sy][xleft]:=dc32;
            end;//sx
            end
         else
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            srows32[sy][xleft]:=dc32;
            end;//sx
            end;//if
         end;//32
      end;//case
      end;//left
   //right
   if (xbottom>=da_cliparea.top) and (xtop<=da_cliparea.bottom) and (xright>=da_cliparea.left) and (xright<=da_cliparea.right) then
      begin
      case sbits of
      //.8
      8:begin
         if (xrich>=1) then
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            xrich8;
            srows8[sy][xright]:=dc8;
            end;//sx
            end
         else
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            srows8[sy][xright]:=dc8;
            end;//sx
            end;//if
         end;//8
      //.24
      24:begin
         if (xrich>=1) then
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            xrich24;
            srows24[sy][xright]:=dc24;
            end;//sx
            end
         else
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            srows24[sy][xright]:=dc24;
            end;//sx
            end;//if
         end;//24
      //.32
      32:begin
         if (xrich>=1) then
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            xrich32;
            srows32[sy][xright]:=dc32;
            end;//sx
            end
         else
            begin
            for sy:=xtop to xbottom do if (sy>=da_cliparea.top) and (sy<=da_cliparea.bottom) then
            begin
            srows32[sy][xright]:=dc32;
            end;//sx
            end;//if
         end;//32
      end;//case
      end;//right
   end;
begin
//defaults
result:=false;

try
xsize:=0;

{

fps_ver: v1
opacity: 255
logoopacity: 255
logocol1: 16711935
logocol2: 16776960
richness: 20
logocolors: 1
softenjoins: 0
shade: 148
shadeangle: 0
instagram: 0
resample: 0
logorelx: 23
logorely: 24
logorelm: 0
{}//xxxxxxxxxxxxxxxxxxxxxxxx

//check
if not misok82432(s,sbits,sw,sh) then exit;
if not misrows82432(s,srows8,srows24,srows32) then exit;

//init
//.da_cliparea
if (da_cliparea.left<0) then da_cliparea.left:=0;
if (da_cliparea.right>=sw) then da_cliparea.right:=sw-1;
if (da_cliparea.top<0) then da_cliparea.top:=0;
if (da_cliparea.bottom>=sh) then da_cliparea.bottom:=sh-1;
if (da_cliparea.right<da_cliparea.left) or (da_cliparea.bottom<da_cliparea.top) then goto skipdone;

//.xouterarea -> important: allow "xouterarea" to go out of range -> allows for slipping the frame off the edge of an image etc for tweaking etc - 27jan2021
if xautoouterarea then xouterarea:=misrect(0,0,sw-1,sh-1);
if (xouterarea.right<xouterarea.left) or (xouterarea.bottom<xouterarea.top) then goto skipdone;

//.extract framesets from "slist"
scount:=frcrange32(  ((frcrange32(scount,0,high(slist)+1) div xblocks_per_frameset)*xblocks_per_frameset)  ,0,high(xfs)+1);
if (scount<=0) then goto skipdone;
xi:=0;
xfcount:=scount;
for p:=1 to scount do
begin
xfs[p-1]:=slist[xi+0];//source color
xfd[p-1]:=slist[xi+1];//destination color
xft[p-1]:=frcrange32(slist[xi+2],0,20);//texture (0..20)
xfo[p-1]:=frcrange32(slist[xi+3],0,255);//opacity (0..255)
xfw[p-1]:=frcrange32(slist[xi+4],0,1000);//size of frameset in pixels
inc(xsize,xfw[p-1]);//overall size of frame
inc(xi,xblocks_per_frameset);
end;//p

//framesets
fa:=xouterarea;
for p:=0 to (xfcount-1) do
begin
fs:=xfs[p];
fd:=xfd[p];
fw:=frcrange32(xfw[p],0,1000);
xrich:=2*frcrange32(xft[p],0,20);
xrich2:=frcmin32(xrich div 2,1);
if (fw>=1) then
   begin
   for fi:=0 to (fw-1) do
   begin
   //calc. color
   dpert:=frcrange32(round((fi/frcmin32(fw,1))*100),0,100);
   //.sc24
   sc24:=int__c24(int__splice24_100(dpert,fs,fd));
   //.sc32
   sc32.r:=sc24.r;
   sc32.g:=sc24.g;
   sc32.b:=sc24.b;
   sc32.a:=255;
   //.sc8
   sc8:=sc24.r;
   if (sc24.g>sc8) then sc8:=sc24.g;
   if (sc24.b>sc8) then sc8:=sc24.b;
   //.d8/24/32
   dc8 :=sc8;
   dc24:=sc24;
   dc32:=sc32;
   //draw a single pixel frame
   xdrawframe(fa.left,fa.top,fa.right,fa.bottom);
   //shrink the drawing area ready for the next single frame to be drawn
   inc(fa.left);
   dec(fa.right);
   inc(fa.top);
   dec(fa.bottom);
   //check
   if (fa.right<fa.left) or (fa.bottom<fa.top) then goto skipdone;
   end;//fi
   end;
end;//p
//successful
skipdone:
result:=true;
skipend:
except;end;
end;

procedure low__framecols(xback,xframe,xframe2:longint;var xminsize,xcol1,xcol2:longint);//24feb2022
var//note: runs the frame code to discover the innermost and outermost colors for system corner color patching "winLdr"
   xpos:longint;
   sremsize:longint;sframesize,dminsize,dsize,dcolor,dcolor2:longint;
   xonce:boolean;
begin
try
//init
xminsize:=0;
xcol1:=xback;//was: xframe2; - note: background is a more reliable default WHEN no frame present or framesize is ZERO - 26feb2022
xcol2:=xback;//was: xframe;
xonce:=true;
//get

{$ifdef gui}
if (viframecode<>nil) and (viframecode.len>=1) then
   begin
   sframesize:=vibordersize;
   sremsize:=sframesize;
   xpos:=0;
   while true do
   begin
   if not low__frameset(xpos,viframecode,sremsize,sframesize,xframe,xframe2,dminsize,dsize,dcolor,dcolor2) then break;
   if (dminsize>=1) then xminsize:=dminsize;//26feb2022
   if xonce and (dsize>=1) then
      begin
      xonce:=false;
      xcol1:=dcolor;//inner-most color of frame
      end;
   if (dsize>=1) then xcol2:=dcolor2;//fixed - super-fine control - 27feb2022
   end;//loop
   end;
{$endif}

except;end;
end;

function low__frameset(var xpos:longint;xdata:tstr8;var sremsize:longint;sframesize,scolor,scolor2:longint;var dminsize,dsize,dcolor,dcolor2:longint):boolean;
label//Accepts format: "v1,v2,v2<rcode>v1,v2,v3" or "v1,v2,v2<#10>v1,v2,v3" or "v1,v2,v2<#13>v1,v2,v3" or "v1,v2,v2|v1,v2,v3"
   loop,redo,skipend;
var
   lp,v,xcount,xlen:longint;
   n,v1,v2,v3:string;

   procedure xclear;
   begin
   dsize:=0;
   dcolor:=scolor;
   dcolor2:=scolor2;
   xcount:=0;
   v1:='';
   v2:='';
   v3:='';
   end;

   procedure xadd;
   label
      skipone;
   var
      n:string;
   begin
   //check
   if (xpos<=lp) then exit;
   //v
   n:=xdata.str[lp,xpos-lp];
   //special adjusters
   if (n='x') then
      begin
      low__swapint(scolor,scolor2);
      goto skipone;
      end;
   //set
   case xcount of
   0:v1:=n;
   1:v2:=n;
   2:v3:=n;
   end;//allow over run PAST 2 and ignore those entries - 23feb2022
   //inc
   inc(xcount);
   skipone:
   lp:=xpos+1;
   end;

   procedure xmakecol(x:string;var xoutcolor:longint);
   var//frameset format: "<from color(1c)><to color(1c)><bal %(0..3c)>"
      c1,c2,b:longint;

      function xfindcol(x:string;xdefcol:longint):longint;
      begin//supports both command Letters and command Numbers - 26feb2022 -> 0=black, 1=in color 1, 2=in color 2, 9=white, 3..8=not used
      //defaults
      result:=xdefcol;
      //get
      if (x='') then exit
      else if (x='s') or (x='1') then result:=scolor
      else if (x='d') or (x='2') then result:=scolor2
      else if (x='i') or (x='3') then int__invert(scolor,result)
      else if (x='j') or (x='4') then int__invert(scolor2,result)
      else if (x='r') or (x='5') then result:=255
      else if (x='g') or (x='8') then result:=int_128_128_128
      else if (x='b') or (x='0') then result:=0
      else if (x='w') or (x='9') then result:=int_255_255_255
      else                            result:=0;
      end;
   begin
   try
   //defaults
   xoutcolor:=0;
   //init
   c1:=xfindcol(strcopy1(x+'s',1,1),0);
   c2:=xfindcol(strcopy1(x+'d',2,1),c1);
   b :=frcrange32(strint(strcopy1(x,3,low__len(x))),0,100);
   //get
   xoutcolor:=int__splice24_100(b,c1,c2)//use 2nd color
   except;end;
   end;
begin//Important Note: Allow frame to process even when there is NO FRAMESIZE to work with or NO REMAINING SIZE so that "minsize" can always be obtained - 27feb2022
//defaults
result:=false;

try
dminsize:=0;//here only
xclear;
//check
if not str__lock(@xdata) then exit;
//init
sremsize:=frcrange32(sremsize,0,sframesize);
xlen:=xdata.len;
xpos:=frcmin32(xpos,0);
if (xpos>=xlen) then goto skipend;
if (scolor=clnone)  then scolor:=int_255_255_255;
if (scolor2=clnone) then scolor2:=int_128_128_128;
//get
lp:=xpos;
redo:
v:=xdata.byt1[xpos];
if ((v=10) or (v=13) or (v=124)) and (lp=xpos) then
   begin
   inc(lp);
   end
else if (v=10) or (v=13) or (v=124) or (v=44) then xadd
else if (xpos=(xlen-1))       then
   begin
   inc(xpos);//account for a non-terminating character
   xadd;
   end;
//.loop
inc(xpos);
if (xpos<xlen) and ((v<>10) and (v<>13) and (v<>124)) then goto redo;

//.catch and multiples of "10" and "13" with no data between them -> go back and try again
if (xcount<=0) then
   begin
   if (xpos<xlen) then goto redo;
   goto skipend;
   end;

//set
//1st
n:=strcopy1(v1,1,1);
if (n='m') then//special value: specifies recommended minimum size of frame - 26feb2022
   begin
   dminsize:=frcmin32(strint(strcopy1(v1,2,low__len(v1))),0);
   goto loop;
   end
else if (n='') or (n='100')    then dsize:=sframesize//uses ALL remaining frame size
else                           dsize:=(frcrange32(strint(v1),0,100)*sframesize) div 100;
//.restrict
dsize:=frcrange32(dsize,0,sremsize);
//2nd
xmakecol(v2,dcolor);
//3rd
xmakecol(v3,dcolor2);
//.check
loop:
if (dsize<=0) and (xpos<xlen) then
   begin
   xclear;
   goto redo;
   end;
//dec
if (dsize>=1) then sremsize:=frcmin32(sremsize-dsize,0);
//successful
result:=true;
skipend:
except;end;
try;str__uaf(@xdata);except;end;
end;

procedure sparkle__fill(xrichlevel:longint);
var
   p:longint;
begin
xrichlevel:=2*frcrange32(xrichlevel,0,20);
if low__setint(system_sparkleref,xrichlevel) then
   begin
   for p:=0 to high(system_sparklelist) do system_sparklelist[p]:=random(xrichlevel);
   low__iroll(system_sparklecount,1);
   end;
end;

function sparkle__start:longint;
begin
result:=system_sparklepos;
end;

procedure sparkle__stop(xpos:longint);
begin
if (xpos<0) then xpos:=0 else if (xpos>high(system_sparklelist)) then xpos:=0;
system_sparklepos:=xpos;
end;

function sparkle__uniquestart:longint;
begin
result:=random(high(system_sparklelist));
end;


//icon procs -------------------------------------------------------------------
//note: image formats: ico/cur/ani
function low__icosizes(x:longint):longint;//18JAN2012, 25APR2011
const
   step=8;
   min=16;
   max=256;//Note: Icon writing routines must clip "256" to "255" for 256x256 icons - 18JAN2012
begin
//defaults
result:=32;

try
//range
x:=frcrange32(x,min,max);
//step
x:=frcrange32((x div nozero__int32(1100144,step))*step,min,max);
//set
result:=x;
except;end;
end;

function low__findbpp82432(i:tobject;iarea:twinrect;imask32:boolean):longint;//limited color count 07feb2022, 19jan2021, 21-SEP-2004
label
   skipone,skipok;
var
   sr8:pcolorrow8;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   x:array[word] of tcolor32;
   xlimit,ibits,iw,ih,p,count,rx,ry:integer;
   lc32,c32:tcolor32;
   lc24,c24:tcolor24;
   lc8,c8:tcolor8;
   lcok,ok:boolean;
begin
//defaults
result:=1;
lc8:=0;

try
//check
if not misok82432(i,ibits,iw,ih) then exit;
//init
xlimit:=258;
count:=0;
lcok:=false;
iarea.left:=frcrange32(iarea.left,0,iw-1);
iarea.right:=frcrange32(iarea.right,iarea.left,iw-1);
iarea.top:=frcrange32(iarea.top,0,ih-1);
iarea.bottom:=frcrange32(iarea.bottom,iarea.top,ih-1);

//get
for ry:=iarea.top to iarea.bottom do
begin
if not misscan82432(i,ry,sr8,sr24,sr32) then break;
if (count>xlimit) then break;
//.32
if (ibits=32) then
   begin
   for rx:=iarea.left to iarea.right do
   begin
   c32:=sr32[rx];
   if (not lcok) or (lc32.r<>c32.r) or (lc32.g<>c32.g) or (lc32.b<>c32.b) or (imask32 and (lc32.a<>c32.a)) then
      begin
      //init
      ok:=true;
      //find existing
      if (count>=1) then
         begin
         for p:=0 to (count-1) do if (x[p].r=c32.r) and (x[p].g=c32.g) and (x[p].b=c32.b) and ((not imask32) or (x[p].a=c32.a)) then
            begin
            ok:=false;
            break;
            end;//p
         end;
      //add
      if ok then
         begin
         x[count].r:=c32.r;
         x[count].g:=c32.g;
         x[count].b:=c32.b;
         x[count].a:=c32.a;
         inc(count);
         if (count>xlimit) then goto skipok;
         end;//ok
      end;
   lc32:=c32;
   lcok:=true;
   end;//rx
   end//32
//.24
else if (ibits=24) then
   begin
   for rx:=iarea.left to iarea.right do
   begin
   c24:=sr24[rx];
   if (not lcok) or (lc24.r<>c24.r) or (lc24.g<>c24.g) or (lc24.b<>c24.b) then
      begin
      //init
      ok:=true;
      //find existing
      if (count>=1) then
         begin
         for p:=0 to (count-1) do if (x[p].r=c24.r) and (x[p].g=c24.g) and (x[p].b=c24.b) then
            begin
            ok:=false;
            break;
            end;//p
         end;
      //add
      if ok then
         begin
         x[count].r:=c24.r;
         x[count].g:=c24.g;
         x[count].b:=c24.b;
         inc(count);
         if (count>xlimit) then goto skipok;
         end;//ok
      end;
   lc24:=c24;
   lcok:=true;
   end;//rx
   end//24
//.8
else if (ibits=8) then
   begin
   for rx:=iarea.left to iarea.right do
   begin
   c8:=sr8[rx];
   if (not lcok) or (lc8<>c8) then
      begin
      //init
      ok:=true;
      //find existing
      if (count>=1) then
         begin
         for p:=0 to (count-1) do if (x[p].r=c8) then
            begin
            ok:=false;
            break;
            end;//p
         end;
      //add
      if ok then
         begin
         x[count].r:=c8;
         inc(count);
         if (count>xlimit) then goto skipok;
         end;//ok
      end;
   lc8:=c8;
   lcok:=true;
   end;//rx
   end;//8
end;//ry

skipok:
//return result
case count of
min32..2:result:=1;
3..16:result:=4;
17..256:result:=8;
257..max32:result:=24;
end;
except;end;
end;

function low__palfind24(var a:array of tcolor24;acount:longint;var z:tcolor24):byte;
var//assumes "a is 0..X"
   p:longint;
begin
//defaults
result:=0;

try
//range
if (acount<=0) then exit else if (acount>256) then acount:=256;
//scan - Note: r/b are swapped
for p:=0 to (acount-1) do if (a[p].r=z.r) and (a[p].g=z.g) and (a[p].b=z.b) then
   begin
   result:=p;
   break;
   end;
except;end;
end;

function low__toico(s:tobject;dcursor:boolean;dsize,dBPP,dtranscol,dfeather:longint;dtransframe:boolean;dhotX,dhotY:longint;xdata:tstr8;var e:string):boolean;//handles 1-32 bpp icons - 03jan2019, 14mar2015, 16JAN2012
label//Note: dBPP=1,4,8,24 and 32, 0=automatic 1-24 but not 32 - 16JAN2012
     //Note: Does not alter "d", but instead takes a copy of it and works on that - 16JAN2012
     //Note: Output icon format is made up of three headers: [TCursorOrIcon=6b]+[TIconRec=16b]+ An array 0..X of "[TBitmapInfoHeader=40b]+[Palette 2/16/256 x BGR0]+[Image bits in 4byte blocks]+[MonoMask bits in 4byte blocks]" - 18JAN2012
     //Note: dformat: <nil> or "ico"=default=icon, "cur"=cursor
     //Note: dnewsize=0=automatic size=default
   skipend;
const
   feather=50;//%
var
   pal:array[0..1023] of tcolor24;
   s24:tbasicimage;
   s8:tbasicimage;//8bit mask - 08apr2015
   sr8:pcolorrow8;
   sr24:pcolorrow24;
   p,palcount,mrowfix,rowfix,mrowlen,rowlen,sx,sy,maxx,mi,int1:longint;
   c,zc,c2,rgbBlack:tcolor24;
   vals1,vals2,valspos1,valspos2,zv8,zv1,v8:byte;
   z,z2:string;
   i4:tint4;
   bol1,ok:boolean;
   //.s
   sbits,sw,sh,tr,tg,tb:longint;
   shasai:boolean;
   //.header records
   typhdr:tcursororicon;
   icohdr:ticonrec;
   imghdr:tbitmapinfoheader;
   //.cores
   xpal,ximg,xmask:tstr8;

   procedure pushpixel4(data:tstr8;var vals,valspos:byte;_val16:byte;reset:boolean);
   const
      bits4:array[0..1] of longint=(16,1);
   begin
   try
   //get
   if (valspos>=0) and (valspos<=1) then
      begin
      //range
      if (_val16>15) then _val16:=15;
      //add
      if (_val16>=1) then vals:=vals+bits4[valspos]*_val16;
      //inc
      inc(valspos);
      end;
   //set
   if (valspos>=2) or (reset and (valspos>=1)) then
      begin
      data.addbyt1(vals);//pushb(datalen,data,char(vals));
      //reset
      vals:=0;
      valspos:=0;
      end;
   except;end;
   end;

   procedure pushpixel1(data:tstr8;var vals,valspos:byte;_val1:byte;reset:boolean);
   const
      bits1:array[0..7] of longint=(128,64,32,16,8,4,2,1);
   begin
   try
   //get
   if (valspos>=0) and (valspos<=7) then
      begin
      //range
      if (_val1>1) then _val1:=1;
      //add
      if (_val1>=1) then vals:=vals+bits1[valspos]*_val1;
      //inc
      inc(valspos);
      end;
   //set
   if (valspos>=8) or (reset and (valspos>=1)) then
      begin
      data.addbyt1(vals);//pushb(datalen,data,char(vals));
      //reset
      vals:=0;
      valspos:=0;
      end;
   except;end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;
mrowlen:=0;
rowlen:=0;

try
s8:=nil;
s24:=nil;
xpal:=nil;
ximg:=nil;
xmask:=nil;
//check
if not low__true2(str__lock(@xdata),misinfo82432(s,sbits,sw,sh,shasai)) then goto skipend;
xdata.clear;
//size
if (dsize<=0) then dsize:=(sw+sh) div 2;
dsize:=low__icosizes(dsize);//16..256
maxx:=dsize-1;
//copy "d" => "a"
s8:=misimg8(dsize,dsize);//07apr2015
s24:=misimg24(dsize,dsize);
if not miscopyareaxx1(0,0,dsize,dsize,area__make(0,0,sw-1,sh-1),s24,s) then goto skipend;
//init
xpal:=str__new8;
ximg:=str__new8;
xmask:=str__new8;
fillchar(pal,sizeof(pal),0);
palcount:=0;
//.transparent color as 24bit color
if (dtranscol<>clnone) then
   begin
   misfindtranscol82432ex(s,dtranscol,tr,tg,tb);
   dtranscol:=rgba0__int(tr,tg,tb);
   end
else
   begin
   tr:=-1;
   tg:=-1;
   tb:=-1;
   end;
//.force sharp feather when a transparent color is specified - 17jan2021
if (dtranscol<>clnone) and (dfeather<0) then dfeather:=0;
if (dfeather<>0) or dtransframe then dBPP:=32;
//.hotspot
dhotX:=frcrange32(dhotX,-1,dsize-1);
dhotY:=frcrange32(dhotY,-1,dsize-1);
if (dhotX<0) or (dhotY<0) then
   begin
   //init
   bol1:=true;
   dhotX:=0;
   dhotY:=0;
   //get
   //.y
   for sy:=0 to (dsize-1) do
   begin
   if not misscan24(s24,sy,sr24) then goto skipend;
   //.x
   for sx:=0 to (dsize-1) do
   begin
   c:=sr24[sx];
   if (c.r<>tr) or (c.g<>tg) or (c.b<>tb) then
      begin
      dhotX:=sx;
      dhotY:=sy;
      bol1:=false;
      break;
      end;
   end;//sx
   if not bol1 then break;
   end;//sy
   end;

rgbBlack.r:=0;rgbBlack.g:=0;rgbBlack.b:=0;
rowfix:=0;
mrowfix:=0;

//-- GET --
//.automatic bpp
if (dBPP<=0) then dBPP:=low__findbpp82432(s,misarea(s),false);//07feb2022

//.reduce colors to fit dBPP
case dBPP of
1:begin
   if not mislimitcolors82432(s24,dtranscol,2,true,pal,palcount,e) then goto skipend;//1bit = 2 colors
   palcount:=2;//force to static limit - 17JAN2012
   rowlen:=dsize div 8;
   mrowlen:=dsize div 8;
   end;
4:begin
   if not mislimitcolors82432(s24,dtranscol,16,true,pal,palcount,e) then goto skipend;//4bit = 16 colors
   palcount:=16;//force to static limit - 17JAN2012
   rowlen:=dsize div 2;
   mrowlen:=dsize div 8;
   end;
8:begin
   if not mislimitcolors82432(s24,dtranscol,256,true,pal,palcount,e) then goto skipend;//8bit = 256 colors
   palcount:=256;//force to static limit - 17JAN2012
   rowlen:=dsize;
   mrowlen:=dsize div 8;
   end;
24:begin
   rowlen:=dsize*3;
   mrowlen:=dsize div 8;
   end;
32:begin//Important Note: 32bpp icons still store a 1bit mask - confirmed - 18JAN2012
   rowlen:=dsize*4;
   mrowlen:=dsize div 8;
   end;
end;//case

//.rowfix
rowfix:=(rowlen-((rowlen div 4)*4));//0..3
if (rowfix>=1) then rowfix:=4-rowfix;
//.mrowfix
mrowfix:=(mrowlen-((mrowlen div 4)*4));//0..3
if (mrowfix>=1) then mrowfix:=4-mrowfix;

//.make mask "s8" - 07feb2022
e:=gecTaskfailed;
if not mask__feather2(s24,s8,dfeather,dtranscol,dtransframe,int1) then goto skipend;

//-- SET --
//.build images
for sy:=(dsize-1) downto 0 do
begin
if not misscan24(s24,sy,sr24) then goto skipend;
if not misscan8(s8,sy,sr8) then goto skipend;
//.init
mi:=0;
vals1:=0;
vals2:=0;
valspos1:=0;
valspos2:=0;
//.x
for sx:=0 to maxx do
begin
zc:=sr24[sx];
zv1:=sr8[sx];//1bit mask for all icons including 32bpp - 18JAN2012
zv8:=sr8[sx];//8bit mask for 32bpp icons
//-- zv1 filter --
if (zv1=0) then zv1:=1 else zv1:=0;
//-- zv8 filter --
if (zv8<=0) then zv8:=1;//Special Note: 8bit mask for 32bit icons: 0=mask error, 1=fully transparent, 10=less transparent, 127=even less transparent, 255=fully solid - not transparent - 18JAN2012
//.decide
case dBPP of
32:begin//"BGRT" - 16JAN2012
   ximg.aadd([zc.b,zc.g,zc.r,zv8]);//pushb(dIMAGELEN,dIMAGE,char(zc.b)+char(zc.g)+char(zc.r)+char(zv8));
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);//required - 18JAN2012
   end;
24:begin//"BGR" + 1bit MASK - 17JAN2012
   if (zv1=1) then zc:=pal[0];//rgbBlack;//transparent pixels are BLACK
   ximg.aadd([zc.b,zc.g,zc.r]);//pushb(dIMAGELEN,dIMAGE,char(zc.b)+char(zc.g)+char(zc.r));
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);
   end;
8:begin//"PalIndex" + 1bit MASK - 17JAN2012
   if (zv1=1) then v8:=0 else v8:=low__palfind24(pal,palcount,zc);//transparent pixels are BLACK
   ximg.addbyt1(v8);//pushb(dIMAGELEN,dIMAGE,char(v8));
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);
   end;
4:begin//"PalIndex" + 1bit MASK - 17JAN2012
   if (zv1=1) then v8:=0 else v8:=low__palfind24(pal,palcount,zc);//transparent pixels are BLACK
   pushpixel4(ximg,vals2,valspos2,v8,sx=maxx);
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);
   end;
1:begin//"PalIndex" + 1bit MASK - 17JAN2012
   if (zv1=1) then v8:=0 else v8:=low__palfind24(pal,palcount,zc);//transparent pixels are BLACK
   pushpixel1(ximg,vals2,valspos2,v8,sx=maxx);
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);
   end;
end;//case
end;//sx
//.rowfix -> pushb(ximg,copy(#0#0#0#0,1,rowfix));
if (rowfix>=3) then ximg.addbyt1(0);
if (rowfix>=2) then ximg.addbyt1(0);
if (rowfix>=1) then ximg.addbyt1(0);
//.mrowfix -> pushb(dMASKLEN,dMASK,copy(#0#0#0#0,1,mrowfix));
if (mrowfix>=3) then xmask.addbyt1(0);
if (mrowfix>=2) then xmask.addbyt1(0);
if (mrowfix>=1) then xmask.addbyt1(0);
end;//sy

//.1st pal entry is BLACK for transparent icons - 07feb2022
if (dtranscol<>clnone) then
   begin
   pal[0].r:=0;
   pal[0].g:=0;
   pal[0].b:=0;
   end;
//.build palette - "BGR0"
if (palcount>=1) then for p:=0 to (palcount-1) do xpal.aadd([pal[p].b,pal[p].g,pal[p].r,0]);//pushb(dPALLEN,dPAL,char(pal[p].b)+char(pal[p].g)+char(pal[p].r)+#0);

//-- Build Icon ----------------------------------------------------------------
//.init
fillchar(typhdr,sizeof(typhdr),0);
fillchar(icohdr,sizeof(icohdr),0);
fillchar(imghdr,sizeof(imghdr),0);
//.image header - 40b
imghdr.bisize:=sizeof(imghdr);
imghdr.biwidth:=dsize;
imghdr.biheight:=2*dsize;
imghdr.biplanes:=1;
imghdr.bibitcount:=dBPP;
imghdr.bicompression:=0;
imghdr.bisizeimage:=xpal.len+ximg.len+xmask.len;
//.icon header - 16b
icohdr.width:=byte(frcrange32(dsize,0,255));
icohdr.height:=byte(frcrange32(dsize,0,255));
case dBPP of
1:int1:=2;
4:int1:=16;
8:int1:=256;//17JAN2012
else int1:=0;
end;
icohdr.colors:=word(int1);
icohdr.dibsize:=sizeof(imghdr)+imghdr.bisizeimage;//length of "dibHEADER+dibDATA"
icohdr.diboffset:=22;//zero-based position of start of "image header" below
icohdr.reserved1:=word(frcrange32(dhotx,0,maxword));//24JAN2012
icohdr.reserved2:=word(frcrange32(dhoty,0,maxword));//24JAN2012
//.file header - 6b
typhdr.wtype:=low__aorb(1,2,dcursor);//0=stockicon, 1=icon (default for icons), 2=cursor
typhdr.count:=1;//number of icons
//set -> icondata:=fromstruc(@typhdr,sizeof(typhdr))+fromstruc(@icohdr,sizeof(icohdr))+fromstruc(@imghdr,sizeof(imghdr))+dPAL+dIMAGE+dMASK;
xdata.addrec(@typhdr,sizeof(typhdr));
xdata.addrec(@icohdr,sizeof(icohdr));
xdata.addrec(@imghdr,sizeof(imghdr));
xdata.add(xpal);
xdata.add(ximg);
xdata.add(xmask);
//successful
result:=true;
skipend:
except;end;
try
if (not result) and (xdata<>nil) then xdata.clear;
freeobj(@s8);
freeobj(@s24);
str__free(@xpal);
str__free(@ximg);
str__free(@xmask);
str__uaf(@xdata);
except;end;
end;

function low__toani(s:tobject;slist:tfindlistimage;dsize,dBPP,dtranscolor,dfeather:longint;dtransframe:boolean;ddelay,dhotX,dhotY:longint;xdata:tstr8;var e:string):boolean;//07aug2021 (disabled repeat checker as it breaks the ANI file!), 24JAN2012
label
   //Note: Known anirec.flags: 1=win7/ours, 3=ms old/our
   //dfeather:  -1=asis, 0=none(sharp), 1=feather(1px/blur), 2=feather(2px/blur), 3=feather(1px), 4=feather(2px)
   //dtranscol: clnone=solid (no see thru parts), clTopLeft=pixel(0,0), else=user specified color
   skipend;
var
   dtranscol,int1,dw,dh,p:integer;
   anirec:tanirec;
   xicon,xiconlist:tstr8;
   xonce:boolean;
   scellcount:longint;
   dcell:tbasicimage;//temp image for each icon to be read onto - 14feb2022

   function xpullcell(x:longint;xdraw:boolean):boolean;
   label
      skipend;
   var
      xcell:tobject;//pointer only
      xbits,xcellw,xcellh,xw,xh,int1,int2,int3,xdelay:longint;
      xhasai,xtransparent:boolean;
   begin
   //defaults
   result:=false;
   xcell:=s;

   try
   //get
   if assigned(slist) then
      begin
      int1:=1;
      slist(nil,'ani',x,int1,dtranscol,xcell);
      scellcount:=frcmin32(int1,1);
      if not miscells(xcell,xbits,xw,xh,int1,int2,int3,xdelay,xhasai,xtransparent) then goto skipend;
      xcellw:=xw;
      xcellh:=xh;
      //.draw
      if xdraw and zzok2(dcell) and (not miscopyarea32(0,0,dw,dh,area__make(0,0,xcellw-1,xcellh-1),dcell,xcell)) then goto skipend;
      //.translate transparent color if required - 14feb2022
      dtranscol:=mistranscol(dcell,dtranscol,dtranscol<>clnone);
      end
   else
      begin
      if not miscells(s,xbits,xw,xh,scellcount,xcellw,xcellh,xdelay,xhasai,xtransparent) then goto skipend;
      //.draw
      if xdraw and zzok2(dcell) and (not miscopyarea32(0,0,dw,dh,area__make(x*xcellw,0,((x+1)*xcellw)-1,xcellh-1),dcell,s)) then goto skipend;
      //.transcol - per cell
      dtranscol:=mistranscol(dcell,dtranscolor,dtranscolor<>clnone);
      end;
   //.val defaults
   if xonce then
      begin
      xonce:=false;
      if (ddelay<=0) then ddelay:=xdelay;
      if (dsize<=0) then dsize:=(xcellw+xcellh) div 2;//vals set by call to "xpullcell(0)" above
      end;
   //successful
   result:=true;
   skipend:
   except;end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
xonce:=true;
xicon:=nil;
xiconlist:=nil;
dcell:=nil;
//check
if not str__lock(@xdata) then exit;
if not xpullcell(0,false) then goto skipend;
//init
xdata.clear;
fillchar(anirec,sizeof(anirec),0);
ddelay:=frcmin32(ddelay,1);
dsize:=low__icosizes(dsize);//16..256
dw:=dsize;
dh:=dsize;
dcell:=misimg32(dw,dh);
xicon:=str__new8;
xiconlist:=str__new8;
//.force sharp feather when a transparent color is specified - 17jan2021
if (dtranscol<>clnone) and (dfeather<0) then dfeather:=0;
if (dfeather<>0) or dtransframe then dBPP:=32;

//-- GET -----------------------------------------------------------------------
//.dBPP - scan each cell and return the highest BPP rating to cover ALL cells - 22JAN2012
case dBPP of
1,4,8,24,32:;
else
   begin
   //max "bpp" for all cells
   dBPP:=1;
   for p:=0 to (scellcount-1) do
   begin
   if not xpullcell(p,true) then goto skipend;
   int1:=low__findbpp82432(dcell,area__make(0,0,dw-1,dh-1),false);
   if (int1>dBPP) then dBPP:=int1;
   if (dBPP>=24) then break;
   end;//p
   end;
end;//case

//.anirec - do last
anirec.cbsizeof:=sizeof(anirec);
anirec.cframes:=scellcount;//number of unique images
anirec.csteps:=scellcount;//number of cells in anmiation
anirec.cbitcount:=dBPP;
anirec.jifrate:=frcmin32(round(ddelay/16.666),1);
anirec.flags:=1;//win7/some of ours

//.cells -> icons
for p:=0 to (scellcount-1) do
begin
//.get cell
if not xpullcell(p,true) then goto skipend;
//.make icon
if not low__toico(dcell,true,dsize,dBPP,dtranscol,dfeather,dtransframe,dhotX,dhotY,xicon,e) then goto skipend;
//.add icon -> 'icon'+from32bit(length(imgs.items[p]^))+imgs.items[p]^
xiconlist.addstr('icon');
xiconlist.addint4(xicon.len);
xiconlist.add(xicon);
xicon.clear;
end;//p

//-- RIFF ----------------------------------------------------------------------
//.riff -> 'RIFF'+from32bit(length(data)+4)+data;
xdata.addstr('RIFF');
xdata.addint4(0);//set last
//._anih - 'ACONanih'+from32bit(sizeof(anirec))+fromstruc(@anirec,sizeof(anirec));
xdata.addstr('ACONanih');
xdata.addint4(sizeof(anirec));
xdata.addrec(@anirec,sizeof(anirec));
//._list
xdata.addstr('LIST');
xdata.addint4(4+xiconlist.len);
xdata.addstr('fram');
xdata.add(xiconlist);
//.reduce mem
xiconlist.clear;
//.set overal size
xdata.int4[4]:=frcmin32(xdata.len-4,0);
//successful
result:=true;
skipend:
except;end;
try
if (not result) and (xdata<>nil) then xdata.clear;
str__free(@xicon);
str__free(@xiconlist);
freeobj(@dcell);
str__uaf(@xdata);
except;end;
end;

function low__fromico32(d:tobject;sdata:tstr8;dsize:longint;xuse32:boolean;var e:string):boolean;//handles 1-32 bpp icons - 26JAN2012
begin
result:=low__fromico322(d,@sdata,dsize,xuse32,e);
end;

function low__fromico322(d:tobject;sdata:pobject;dsize:longint;xuse32:boolean;var e:string):boolean;//supports tstr8/9, handles 1-32 bpp icons - 26JAN2012
label//Note: dsize=0=extract biggest icon we can from datastream, else=attempt to extract an icon that matches the dimsensions of dsize - 20JAN2012
   skiprec,dofinalise,skipdone,skipend;
var
   dtmp32,dm8:tbasicimage;//mask - 07apr2015
   dtmp:tstr8;
   z:string;
   lastWH,lastS,lastS2,bestindex,bestindex2,int1,mrowlen,mrowfix,rowlen,rowfix,tc,len,bmpLEN,maskLEN,p,pos,palcount,mbpp,bpp,dx,dy,dw,dh,dbits:longint;
   pal:array[0..255] of tcolor24;
   dr32:pcolorrow32;
   dr24:pcolorrow24;
   dr8,r8:pcolorrow8;
   whitec:tcolor24;
   c32:tcolor32;
   bol1,transparentOK:boolean;
   typhdr:tcursororicon;
   icohdrs:array[0..999] of ticonrec;//16,000 bytes - 20JAN2012
   imghdrs:array[0..999] of tbitmapinfoheader;//40,000 bytes - 20JAN2012
   imghdrsPNG:array[0..999] of boolean;//23may2022
   i2:twrd2;
   v8:byte;

   function iconOK:boolean;
   begin
   //defaults
   result:=false;

   //dw AND dh
   if (dw<>low__icosizes(dw)) or (dh<>low__icosizes(dh)) then exit;
   //bpp - 16JAN2012
   case bpp of
   1,4,8,24,32:;
   else exit;
   end;
   //mbpp
   case mbpp of
   0,1:;
   else exit;
   end;
   //other
   if (bmpLEN=0) then exit;
   //successful - icon is of an known format - 14JAN2012
   result:=true;
   end;

   function readpixels(asmask:boolean):boolean;
   label
      skipend;
   const
      bits4:array[0..1] of integer=(16,1);
      bits1:array[0..7] of integer=(128,64,32,16,8,4,2,1);
   var
      mode,p,v:integer;
      z:tcolor24;

      function pushpixel32(col:tcolor24;mcol:longint):boolean;
      var
         c32:tcolor32;
         c8:longint;
      begin
      //get
      if (dx>=0) and (dx<dw) then
         begin
         //filter
         if (not xuse32) and (col.r=255) and (col.g=255) and (col.b=255) then col.r:=254;//don't use WHITE, reserved for transparent color - 14JAN2012
         if (mcol>=0) and (mcol<=255) then r8[dx]:=byte(mcol);//for 32bpp
         //get
         case dbits of
         32:begin
            c32.r:=col.r;
            c32.g:=col.g;
            c32.b:=col.b;
            c32.a:=255;//correct alpha value will be set later
            dr32[dx]:=c32;
            end;
         24:dr24[dx]:=col;
         8:begin
            c8:=col.r;
            if (col.g>c8) then c8:=col.g;
            if (col.b>c8) then c8:=col.b;
            dr8[dx]:=c8;
            end;
         end;//case
         //inc
         inc(dx);
         //successful
         result:=true;
         end
      else result:=false;
      end;

      function pushpixel8(col8:integer):boolean;
      begin
      if (dx>=0) and (dx<dw) then
         begin
         //range
         if (col8<0) then col8:=0
         else if (col8>255) then col8:=255;
         //set
         r8[dx]:=byte(col8);
         //inc
         inc(dx);
         //successful
         result:=true;
         end
      else result:=false;
      end;

      function takefrom(var v:longint;vdiv:longint):longint;
      begin
      //range
      v:=frcmin32(v,0);
      vdiv:=frcmin32(vdiv,1);
      //set
      result:=v div vdiv;
      v:=v-result*vdiv;
      end;
   begin
   //defaults
   result:=false;

   try
   //check
   if (dx>=dw) then exit;
   if (not asmask) and ((pos>len) or (pos<1)) then exit;
   //get
   if asmask then mode:=-mbpp else mode:=bpp;
   case mode of
   -1:begin//write to mask "dm8.r8" -> was 255=solid, 0=transparent
      if (pos>=1) and (pos<=len) then
         begin
         v:=255-str__bytes1(sdata,pos);//now invert transparent values to line up with standard 32bit alpha mask values - 23may2022, was: v:=sdata.bytes1[pos]//byte(icondata[pos]);
         inc(pos,1);
         end
      else v:=255;//not transparent by default
      for p:=0 to high(bits1) do if not pushpixel8(takefrom(v,bits1[p])*255) then goto skipend;
      end;
   1:begin
      v:=str__bytes1(sdata,pos);//byte(icondata[pos]);
      for p:=0 to high(bits1) do if not pushpixel32(pal[takefrom(v,bits1[p])],-1) then goto skipend;
      inc(pos,1);
      end;
   4:begin
      v:=str__bytes1(sdata,pos);//byte(icondata[pos]);
      for p:=0 to high(bits4) do if not pushpixel32(pal[takefrom(v,bits4[p])],-1) then goto skipend;
      inc(pos,1);
      end;
   8:begin
//was:      if not pushpixel32(pal[byte(icondata[pos])],-1) then goto skipend;
      if not pushpixel32(pal[ str__bytes1(sdata,pos) ],-1) then goto skipend;
      inc(pos,1);
      end;
   24:begin//pixel color order "BGR" - 14JAN2012
      if ((pos+2)>len) then goto skipend;
      z.b:=str__bytes1(sdata,pos+0);
      z.g:=str__bytes1(sdata,pos+1);
      z.r:=str__bytes1(sdata,pos+2);
      if not pushpixel32(z,-1) then goto skipend;
      inc(pos,3);
      end;
   32:begin//pixel color order "BGRT" - 16JAN2012
      if ((pos+3)>len) then goto skipend;
      z.b:=str__bytes1(sdata,pos+0);
      z.g:=str__bytes1(sdata,pos+1);
      z.r:=str__bytes1(sdata,pos+2);
      //was: if not pushpixel32(z,byte(icondata[pos+3])) then goto skipend;
      if not pushpixel32(z, str__bytes1(sdata,pos+3) ) then goto skipend;
      inc(pos,4);
      end;
   end;//case
   //successful
   result:=true;
   //round up to nearest 4th byte
   skipend:
   if (dx>=dw) then inc(pos,low__aorb(rowfix,mrowfix,asmask));
   except;end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;
mrowlen:=0;

try
dm8:=nil;
dtmp32:=nil;
dtmp:=nil;
//check
if not misok82432(d,dbits,dw,dh) then exit;
if (dbits<>32) then xuse32:=false;
//init
tc:=clNone;
dw:=0;
dh:=0;
bpp:=0;
mbpp:=0;
bmpLEN:=0;
maskLEN:=0;
rowfix:=0;
mrowfix:=0;
fillchar(pal,sizeof(pal),0);
palcount:=0;
len:=0;//set below
bestindex:=-1;
bestindex2:=-1;
//.dsize
if (dsize<=0) then dsize:=0 else dsize:=low__icosizes(dsize);//20JAN2012
//.whitec
whitec.r:=255;
whitec.g:=255;
whitec.b:=255;
transparentOK:=false;

//-- Type Header (main file header) --------------------------------------------
//init
fillchar(typhdr,sizeof(typhdr),0);
fillchar(icohdrs,sizeof(icohdrs),0);
fillchar(imghdrs,sizeof(imghdrs),0);
fillchar(imghdrsPNG,sizeof(imghdrsPNG),0);//23may2022
//main file header - typhdr - 20JAN2012
e:=gecUnknownFormat;
pos:=1;
//was: if not pullstruc(pos,icondata,@typhdr,sizeof(typhdr)) then goto fromwinINSTEAD;//use Windows
if not str__writeto1b(sdata,@typhdr,sizeof(typhdr),pos,sizeof(typhdr)) then goto skipend;//use Windows

//.wtype
case typhdr.wtype of
0,1,2:;//0=stockicon, 1=icon (default for icons), 2=cursor
else goto skipend;//failed
end;
//.count
if (typhdr.count<=0) or ((typhdr.count-1)>high(icohdrs)) then goto skipend;//failed

//-- Icon Header(s) ------------------------------------------------------------
//init
lastWH:=0;
lastS:=0;
lastS2:=0;
bestindex:=-1;
bestindex2:=-1;
//icon headers
//was: for p:=0 to (typhdr.count-1) do if not pullstruc(pos,icondata,@icohdrs[p],sizeof(icohdrs[p])) then goto fromwinINSTEAD;
for p:=0 to (typhdr.count-1) do if not str__writeto1b(sdata,@icohdrs[p],sizeof(icohdrs[p]),pos,sizeof(icohdrs[p])) then goto skipend;

//image headers
for p:=0 to (typhdr.count-1) do
begin
pos:=icohdrs[p].diboffset+1;
//.png detector - 23may2022
if str__asame2(sdata,pos-1,[137,uuP,uuN,uuG]) then
   begin
   //init
   if (dtmp=nil) then dtmp:=str__new8;
   if (dtmp32=nil) then dtmp32:=misimg32(1,1);
   //get
   str__clear(@dtmp);
   str__add31(@dtmp,sdata,pos,icohdrs[p].dibsize);
   png__fromdata(dtmp32,@dtmp,e);
   imghdrs[p].biwidth:=misw(dtmp32);
   imghdrs[p].biheight:=mish(dtmp32)*2;//required
   imghdrs[p].biBitCount:=misai(dtmp32).bpp;
   imghdrs[p].bisize:=icohdrs[p].dibsize;
   imghdrsPNG[p]:=true;
   goto skiprec;
   end;

//was: if not pullstruc(pos,icondata,@imghdrs[p],sizeof(imghdrs[p])) then goto fromwinINSTEAD;
if not str__writeto1b(sdata,@imghdrs[p],sizeof(imghdrs[p]),pos,sizeof(imghdrs[p])) then goto skipend;

skiprec:
//.corrections
imghdrs[p].biwidth:=imghdrs[p].biwidth;
imghdrs[p].biheight:=imghdrs[p].biheight div 2;
//.find best
if (imghdrs[p].biwidth=imghdrs[p].biheight) and
   (imghdrs[p].biwidth=low__icosizes(imghdrs[p].biwidth)) then
   begin
   if (imghdrs[p].biwidth>=lastWH) and (icohdrs[p].dibsize>=lastS) then
      begin
      bestindex:=p;
      lastWH:=imghdrs[p].biwidth;
      lastS:=icohdrs[p].dibsize;
      end;
   if (dsize>=1) and (dsize=imghdrs[p].biwidth) and (icohdrs[p].dibsize>=lastS2) then
      begin
      bestindex2:=p;
      lastS2:=icohdrs[p].dibsize;
      end;
   end;//if
end;//p

//decide
//.best match
if (bestindex2>=0) then bestindex:=bestindex2;
if (bestindex<0) then goto skipend;
//set
dw:=imghdrs[bestindex].biwidth;
dh:=imghdrs[bestindex].biheight;
bpp:=imghdrs[bestindex].biBitCount;
pos:=frcrange32(icohdrs[bestindex].diboffset+imghdrs[bestindex].bisize+1,1,str__len(sdata));//20JAN2012
len:=pos+icohdrs[bestindex].dibsize-1;//last pos for this icon data chunk - don't read past this point - 20JAN2012
//hotspot - for information purposes only - 21JAN2012
misai(d).hotspotX:=icohdrs[bestindex].reserved1;
misai(d).hotspotY:=icohdrs[bestindex].reserved2;

//.bpp
case bpp of
1:begin
   palcount:=2;
   bmpLEN:=(dw*dh) div 8;
   rowlen:=dw div 8;
   mbpp:=1;
   end;
4:begin
   palcount:=16;
   bmpLEN:=(dw*dh) div 2;
   rowlen:=dw div 2;
   mbpp:=1;
   end;
8:begin
   palcount:=256;
   bmpLEN:=dw*dh;
   rowlen:=dw;
   mbpp:=1;
   end;
24:begin
   palcount:=0;
   bmpLEN:=dw*dh*3;
   rowlen:=dw*3;
   mbpp:=1;
   end;
32:begin//20JAN2012
   palcount:=0;
   bmpLEN:=dw*dh*4;
   rowlen:=dw*4;
   mbpp:=0;//present BUT not used
   end;
else
   begin
   palcount:=0;
   bmpLEN:=0;
   rowlen:=4;
   mbpp:=1;
   end;
end;//case
//.mbpp
if (mbpp=1) then
   begin//1bit mask
   maskLEN:=(dw*dh) div 8;
   mrowlen:=dw div 8;
   end;
//.row
rowfix:=(rowlen-((rowlen div 4)*4));//0..3
if (rowfix>=1) then rowfix:=4-rowfix;
//.mrow
mrowfix:=(mrowlen-((mrowlen div 4)*4));//0..3
if (mrowfix>=1) then mrowfix:=4-mrowfix;
//.check
if not iconOK then goto skipend;

//.images
missize(d,dw,dh);
dm8:=misimg8(dw,dh);

//-- Read Icon Elements -------------------------------------------------------
//init
e:=gecOutofmemory;

//.png
if imghdrsPNG[bestindex] and (dtmp32<>nil) then
   begin
   missize(dtmp32,1,1);
   str__clear(@dtmp);
   str__add31(@dtmp,sdata,icohdrs[bestindex].diboffset+1,icohdrs[bestindex].dibsize);
   if not png__fromdata(dtmp32,@dtmp,e) then goto skipend;
   if not miscopyarea32(0,0,dw,dh,misarea(dtmp32),d,dtmp32) then goto skipend;
   if not mask__copy(dtmp32,dm8) then goto skipend;
   goto dofinalise;
   end;

//palette - stored in "B,G,R,0" order - 14JAN2012
if (palcount>=1) then for p:=0 to (palcount-1) do
   begin
   //get
   if ((p+3)>str__len(sdata)) then
      begin
      e:=gecDataCorrupt;
      goto skipend;
      end;
   //set
   pal[p].b:=str__bytes1(sdata,pos+0);
   pal[p].g:=str__bytes1(sdata,pos+1);
   pal[p].r:=str__bytes1(sdata,pos+2);
   //n/a: pal[p].a:=sdata.bytes1[pos+3];
   //inc
   inc(pos,4);
   end;

//image
for dy:=(dh-1) downto 0 do
begin
if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;
if not misscan8(dm8,dy,r8) then goto skipend;
dx:=0;
while true do if not readpixels(false) then break;
if (dx<dw) then
   begin
   e:=gecDataCorrupt;
   goto skipend;
   end;
end;

//mask
if (mbpp=1) then
   begin
   for dy:=(dh-1) downto 0 do
   begin
   if not misscan8(dm8,dy,r8) then goto skipend;
   dx:=0;
   while true do
   begin
   readpixels(true);//read in pixels, regardless of whether there is a mask present or not
   if (dx>=dw) then break;
   end;
   end;
   end;

//implement transparent mode
dofinalise:
//.dy
for dy:=0 to (dh-1) do
begin
if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;
if not misscan8(dm8,dy,r8) then goto skipend;
//.32 + xuse32
if (dbits=32) and xuse32 then
   begin
   for dx:=0 to (dw-1) do
   begin
   v8:=r8[dx];
   if (v8<=1) then v8:=0;//icons use 1 for transparency so convert it to 0
   dr32[dx].a:=v8;
   if (v8<255) then transparentOK:=true;
   end;//dx
   end
//.32
else if (dbits=32) then
   begin
   for dx:=0 to (dw-1) do if (r8[dx]<=1) then
      begin
      c32.r:=whitec.r;
      c32.g:=whitec.g;
      c32.b:=whitec.b;
      c32.a:=255;
      dr32[dx]:=c32;
      transparentOK:=true;
      end;
   end
//.24
else if (dbits=24) then
   begin
   for dx:=0 to (dw-1) do if (r8[dx]<=1) then
      begin
      dr24[dx]:=whitec;
      transparentOK:=true;
      end;
   end//24
//.8
else if (dbits=8) then
   begin
   for dx:=0 to (dw-1) do if (r8[dx]<=1) then
      begin
      dr8[dx]:=whitec.r;
      transparentOK:=true;
      end;
   end;
end;//loop - y

skipdone:
if transparentOK and (not xuse32) then
   begin
   c32.r:=whitec.r;
   c32.g:=whitec.g;
   c32.b:=whitec.b;
   c32.a:=255;
   missetpixel32(d,0,0,c32);
   end;
//animation information
//.clear
bol1:=misai(d).use32;
misaiclear2(d);
//.set - 22JAN2012
misai(d).use32:=bol1;
misai(d).transparent:=transparentOK;
misai(d).cellwidth:=dw;
misai(d).cellheight:=dh;
misai(d).delay:=0;
misai(d).count:=1;
misai(d).format:=low__aorbstr('ICO','CUR',(typhdr.wtype=2));//0=stockicon, 1=icon (default for icons), 2=cursor - fixed 23may2022
misai(d).subformat:='';
//.information
misai(d).bpp:=bpp;
misai(d).owrite32bpp:=(bpp=32);//maintain 32bit icons - 23JAN2012
//.cursor hotspots - 20JAN2012
misai(d).hotspotX:=icohdrs[bestindex].reserved1;
misai(d).hotspotY:=icohdrs[bestindex].reserved2;
//successful
result:=true;
skipend:
except;end;
try
freeobj(@dm8);
freeobj(@dtmp32);
str__free(@dtmp);
except;end;
end;
//xxxxxxxxxxxxxxxx needs converting into new format xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
function low__fromani32(d:tobject;sdata:tstr8;dsize:longint;xuse32:boolean;var e:string):boolean;//04dec2024: fixed stack overflow, handles 1-32 bpp animated icons - 23may2022, 26JAN2012
begin
result:=low__fromani322(d,@sdata,dsize,xuse32,e);
end;

function low__fromani322(d:tobject;sdata:pobject;dsize:longint;xuse32:boolean;var e:string):boolean;//handles 1-32 bpp animated icons - 23may2022, 26JAN2012
label
   //Note: Known anirec.flags: 1=win7/ours, 3=ms old/our
   skipend;
type
   tlabelANDsize=packed record
      cap:array[0..3] of char;
      size:dword;
      end;
   tlabelonly=packed record
      cap:array[0..3] of char;
      end;
var
   a,imgs:tbasicimage;//temp image for each icon to be read onto
   str1:string;
   int1,imgscount,dcount,ddelay,dbits,dw,dh,i,p,len,pos:integer;
   csrec:tlabelANDsize;
   crec:tlabelonly;
   anirec:tanirec;
   irate,iseq,iseq2:tstr8;
   iseqptr:tstr8;//pointer only
   z:tstr8;
   firsticon:boolean;

   function pullstrucex(var pos:integer;len:longint;data:pobject;a:pointer;asize:longint):boolean;//23may2022
   begin
   //defaults
   result:=false;
   //range
   if not str__ok(data) then exit;
   if (len<=0) then len:=str__len(data);
   if (asize<1) then exit;
   if (pos<1) then pos:=1;
   if (pos>len) then exit;
   //get
   result:=str__writeto1b(data,a,asize,pos,asize);
   end;

   function pullrec(a:pointer;asize:longint):boolean;//22JAN2012
   begin
   result:=pullstrucex(pos,len,sdata,a,asize);
   end;
begin
//defaults
result:=false;
e:=gecOutofmemory;

try
a:=nil;
imgs:=nil;
irate:=nil;
iseq:=nil;
iseq2:=nil;
iseqptr:=nil;
z:=nil;
//check
if not misok82432(d,dbits,dw,dh) then exit;
if (dbits<>32) then xuse32:=false;
//init
fillchar(csrec,sizeof(csrec),0);
fillchar(crec,sizeof(crec),0);
fillchar(anirec,sizeof(anirec),0);
irate:=str__new8;
iseq:=str__new8;
iseq2:=str__new8;
z:=str__new8;
dw:=32;//cell width
dh:=32;//cell height
ddelay:=500;//in milliseconds
dcount:=1;//number of cells in total
firsticon:=false;
//was: if (d is tbitmapenhanced) then aiClear((d as tbitmapenhanced).ai);
misaiclear2(d);

a:=misimg32(1,1);
imgs:=misimg32(1,1);
imgscount:=0;

//-- GET -----------------------------------------------------------------------
//RIFF - main data header [RIFF+<overall size including RIFF>] - 22JAN2012
e:=gecUnknownFormat;
pos:=1;
//was: if (not pullstruc(pos,sdata,@csrec,sizeof(csrec))) or (string(csrec.cap)<>'RIFF') then goto skipend;
if (not str__writeto1b(sdata,@csrec,sizeof(csrec),pos,sizeof(csrec))) or (string(csrec.cap)<>'RIFF') then goto skipend;
len:=csrec.size;//enforce length from now on
//read chunks
while true do
begin
if (pos<1) or (pos>len) then break
else if (str__bytes1(sdata,pos)<=32) then inc(pos)//bad data, a plain text name is expected, skip over - 22JAN2012
else if pullrec(@csrec,sizeof(csrec)) then
   begin
   str1:=strlow(string(csrec.cap));
   if (str1='acon') or (str1='info') or (str1='fram') then dec(pos,4)//has no size field so go back 4 bytes to correct - 22JAN2012
   else if (str1='list') then
      begin
      //nil
      end
   else if (str1='icon') then
      begin
      //get
//was:  z:=copy(data,pos,csrec.size);
//      if (d is tbitmapenhanced) then a.ocleanmask32bpp:=(d as tbitmapenhanced).ocleanmask32bpp;//26JAN2012
//      if not fromicon32(a,0,z,e) then goto skipend;
      str__clear(@z);
      str__add31(@z,sdata,pos,csrec.size);
      //was: if mishasai(d) then a.ocleanmask32bpp:=misai(d).ocleanmask32bpp;//26JAN2012
      if not low__fromico32(a,z,0,xuse32,e) then goto skipend;

      //first
      if not firsticon then
         begin
         firsticon:=true;
         dw:=a.width;
         dh:=a.height;
         ddelay:=frcmin32(round(anirec.jifrate*16.666),20);//no faster than 50fps
         dcount:=frcmin32(anirec.csteps,1);
         //animation information
         misai(d).cellwidth:=dw;
         misai(d).cellheight:=dh;
         misai(d).delay:=ddelay;
         misai(d).count:=dcount;
         misai(d).transparent:=a.ai.transparent;
         misai(d).bpp:=a.ai.bpp;
         misai(d).owrite32bpp:=(a.ai.bpp=32);//maintain 32bit animated cursors - 23JAN2012
         misai(d).hotspotx:=a.ai.hotspotx;
         misai(d).hotspoty:=a.ai.hotspoty;
         //size image strip
         //was: d.width:=dcount*dw;d.height:=dh;
         missize(d,dcount*dw,dh);
         //draw icon onto "imgs" for reference later
         missize(imgs,dcount*dw,dh);
         end;
      //.fit image to "imgs" strip cell dimensions
      miscopyarea32(imgscount*dw,0,dw,dh,area__make(0,0,a.width-1,a.height-1),imgs,a);
      //seq2
      iseq2.int4i[iseq2.count div 4]:=imgscount;//used instead of "seq" when "seq" is omitted from data - 22JAN2012
      //inc
      inc(pos,csrec.size);
      inc(imgscount);
      end
   else if (str1='seq ') then
      begin
//was:      iseq.text:=copy(data,pos,csrec.size);
      str__clear(@iseq);
      str__add31(@iseq,sdata,pos,csrec.size);
      inc(pos,csrec.size);
      end
   else if (str1='rate') then
      begin
//was:      irate.text:=copy(data,pos,csrec.size);
      str__clear(@irate);
      str__add31(@irate,sdata,pos,csrec.size);
      inc(pos,csrec.size);
      end
   else if (str1='anih') then
      begin
      if not pullrec(@anirec,sizeof(anirec)) then goto skipend;
      //range
      if (anirec.csteps<=0) then//this tells us how many CELLS are used to represent the animation - 22JAN2012
         begin
         e:=gecDataCorrupt;
         goto skipend;
         end;
      end
   else
      begin//unknow chunks - skip over - 22JAN2012
      inc(pos,csrec.size);
      end;
   end
else break;
end;

//-- Build Animation -----------------------------------------------------------
//check
if not firsticon then goto skipend;
//decide - Note: "seq" is not always providied so in these cases use our "seq2"
//.seqptr
iseqptr:=iseq;
if (iseq.count=0) then iseqptr:=iseq2;
//.rate - only if providied else use the rate that came as part of "anirec" - 22JAN2012
if (irate.count>=1) then
   begin
   //get
   int1:=0;
   for p:=0 to (irate.count-1) do inc(int1,irate.int4i[p]);
   int1:=int1 div nozero__int32(1100145,irate.count);
   //set
   ddelay:=frcmin32(round(int1*16.666),20);//no faster than 50fps
   misai(d).delay:=ddelay;
   end;
//draw - using "seqptr" to refer to cells stored in "imgs", note: d should already be sized correctly - 22JAN2012
for p:=0 to ((iseqptr.count div 4)-1) do
begin
i:=iseqptr.int4i[p];//cell index
miscopyarea32(p*dw,0,dw,dh,area__make(i*dw,0,i*dw+(dw-1),dh-1),d,imgs);
end;//p
//successful
result:=true;
skipend:
except;end;
try
freeobj(@a);
freeobj(@imgs);
str__free(@irate);
str__free(@iseq);
str__free(@iseq2);
str__free(@z);
except;end;
end;

function low__toico32(s:tobject;dcursor,dpng:boolean;dsize,dBPP,dhotX,dhotY:longint;var xouthotX,xouthotY,xoutBPP:longint;xdata:tstr8;var e:string):boolean;//handles 1-32 bpp icons - 13may2025: 32bit transparency updated for Win98, 03jan2019, 14mar2015, 16JAN2012
label//Note: dBPP=1,4,8,24 and 32, 0=automatic 1-24 but not 32 - 16JAN2012
     //Note: Does not alter "d", but instead takes a copy of it and works on that - 16JAN2012
     //Note: Output icon format is made up of three headers: [TCursorOrIcon=6b]+[TIconRec=16b]+ An array 0..X of "[TBitmapInfoHeader=40b]+[Palette 2/16/256 x BGR0]+[Image bits in 4byte blocks]+[MonoMask bits in 4byte blocks]" - 18JAN2012
     //Note: dformat: <nil> or "ico"=default=icon, "cur"=cursor
     //Note: dnewsize=0=automatic size=default
   skipend;
const
   feather=50;//%
var
   pal:array[0..1023] of tcolor24;
   s32:tbasicimage;
   sr32:pcolorrow32;
   sc32:tcolor32;
   sc24:tcolor24;
   p,palcount,mrowfix,rowfix,mrowlen,rowlen,sx,sy,maxx,mi,int1:longint;
   vals1,vals2,valspos1,valspos2,zv8,zv1,v8:byte;
   z,z2:string;
   i4:tint4;
   bol1,ok:boolean;
   //.s
   stranscol,sbits,sw,sh,tr,tg,tb:longint;
   stransparent,shasai:boolean;
   //.header records
   typhdr:tcursororicon;
   icohdr:ticonrec;
   imghdr:tbitmapinfoheader;
   //.cores
   xpal,ximg,xmask:tstr8;

   procedure pushpixel4(data:tstr8;var vals,valspos:byte;_val16:byte;reset:boolean);
   const
      bits4:array[0..1] of longint=(16,1);
   begin
   try
   //get
   if (valspos>=0) and (valspos<=1) then
      begin
      //range
      if (_val16>15) then _val16:=15;
      //add
      if (_val16>=1) then vals:=vals+bits4[valspos]*_val16;
      //inc
      inc(valspos);
      end;
   //set
   if (valspos>=2) or (reset and (valspos>=1)) then
      begin
      data.addbyt1(vals);//pushb(datalen,data,char(vals));
      //reset
      vals:=0;
      valspos:=0;
      end;
   except;end;
   end;

   procedure pushpixel1(data:tstr8;var vals,valspos:byte;_val1:byte;reset:boolean);
   const
      bits1:array[0..7] of longint=(128,64,32,16,8,4,2,1);
   begin
   try
   //get
   if (valspos>=0) and (valspos<=7) then
      begin
      //range
      if (_val1>1) then _val1:=1;
      //add
      if (_val1>=1) then vals:=vals+bits1[valspos]*_val1;
      //inc
      inc(valspos);
      end;
   //set
   if (valspos>=8) or (reset and (valspos>=1)) then
      begin
      data.addbyt1(vals);//pushb(datalen,data,char(vals));
      //reset
      vals:=0;
      valspos:=0;
      end;
   except;end;
   end;
begin
//defaults
result    :=false;
e         :=gecTaskfailed;
s32       :=nil;
xpal      :=nil;
ximg      :=nil;
xmask     :=nil;
xouthotX  :=0;
xouthotY  :=0;
xoutBPP   :=1;

try
//check
if not low__true2(str__lock(@xdata),misinfo82432(s,sbits,sw,sh,shasai)) then goto skipend;
if (sbits<>32) then dpng:=false;//23may2022
if dpng then dbpp:=32;//23may2022
xdata.clear;

//size
if (dsize<=0) then dsize:=(sw+sh) div 2;
dsize:=low__icosizes(dsize);//16..256
maxx:=dsize-1;

//copy "d" => "a"
s32:=misimg32(dsize,dsize);
if not miscopyarea32(0,0,dsize,dsize,area__make(0,0,sw-1,sh-1),s32,s) then goto skipend;//includes 8bit mask - 15feb2022

stransparent :=mask__hasTransparency32(s32);//13may2025
stranscol    :=low__aorb(clnone,0,stransparent);//15feb2022

//init
xpal         :=str__new8;
ximg         :=str__new8;
xmask        :=str__new8;
fillchar(pal,sizeof(pal),0);
palcount     :=0;

//.hotspot
dhotX:=frcrange32(dhotX,-1,dsize-1);
dhotY:=frcrange32(dhotY,-1,dsize-1);
if (dhotX<0) or (dhotY<0) then
   begin
   //init
   bol1:=true;
   dhotX:=0;
   dhotY:=0;
   int1:=0;
   //get
   //.y
   for sy:=0 to (dsize-1) do
   begin
   if not misscan32(s32,sy,sr32) then goto skipend;
   //.x
   for sx:=0 to (dsize-1) do
   begin
   sc32:=sr32[sx];
   if (sc32.a>int1) then
      begin
      int1:=sc32.a;
      dhotX:=sx;
      dhotY:=sy;
      if (int1>=2) then
         begin
         bol1:=false;
         break;
         end;
      end;//a
   end;//sx
   if not bol1 then break;
   end;//sy
   end;

xouthotX:=dhotX;
xouthotY:=dhotY;
rowfix:=0;
mrowfix:=0;

//-- GET --
//.automatic bpp
if (dBPP<=0) then dBPP:=low__findbpp82432(s,misarea(s),false);//07feb2022
xoutBPP:=dBPP;//24may2022

//.reduce colors to fit dBPP
case dBPP of
1:begin
   if not mislimitcolors82432(s32,stranscol,2,true,pal,palcount,e) then goto skipend;//1bit = 2 colors
   palcount:=2;//force to static limit - 17JAN2012
   rowlen:=dsize div 8;
   mrowlen:=dsize div 8;
   end;
4:begin
   if not mislimitcolors82432(s32,stranscol,16,true,pal,palcount,e) then goto skipend;//4bit = 16 colors
   palcount:=16;//force to static limit - 17JAN2012
   rowlen:=dsize div 2;
   mrowlen:=dsize div 8;
   end;
8:begin
   if not mislimitcolors82432(s32,stranscol,256,true,pal,palcount,e) then goto skipend;//8bit = 256 colors
   palcount:=256;//force to static limit - 17JAN2012
   rowlen:=dsize;
   mrowlen:=dsize div 8;
   end;
24:begin
   rowlen:=dsize*3;
   mrowlen:=dsize div 8;
   end;
32:begin//Important Note: 32bpp icons still store a 1bit mask - confirmed - 18JAN2012
   rowlen:=dsize*4;
   mrowlen:=dsize div 8;
   end;
else goto skipend;
end;//case

//.rowfix
rowfix:=(rowlen-((rowlen div 4)*4));//0..3
if (rowfix>=1) then rowfix:=4-rowfix;

//.mrowfix
mrowfix:=(mrowlen-((mrowlen div 4)*4));//0..3
if (mrowfix>=1) then mrowfix:=4-mrowfix;

//-- SET --
//.build images
for sy:=(dsize-1) downto 0 do
begin
if not misscan32(s32,sy,sr32) then goto skipend;

//.init
mi:=0;
vals1:=0;
vals2:=0;
valspos1:=0;
valspos2:=0;

//.x
for sx:=0 to maxx do
begin
sc32:=sr32[sx];
sc24.r:=sc32.r;
sc24.g:=sc32.g;
sc24.b:=sc32.b;
case sc32.a of
0:begin
   zv1:=1;
   zv8:=1;//Special Note: 8bit mask for 32bit icons: 0=mask error, 1=fully transparent, 10=less transparent, 127=even less transparent, 255=fully solid - not transparent - 18JAN2012
   end;
else
   begin
   zv1:=0;     //1bit mask for all icons including 32bpp - 18JAN2012
   zv8:=sc32.a;//8bit mask for 32bpp icons
   end;
end;//case

//.decide
case dBPP of
32:begin//"BGRT" - 13may2025, 16JAN2012

   //Transparency fix for Windows 98 - ** 13may2025 **: 32bpp not supported, it uses the 1bit mask instead, and for transparency to
   //work as expected, a FULLY transparent pixel must be black(0,0,0) with alpha of 1 (not 0) and 1bit mask of 1 (transparent):
   if (zv8<=1) then
      begin
      zv1:=1;//fully transparent
      sc24.b:=0;//write color black
      sc24.g:=0;
      sc24.r:=0;
      end;

   ximg.aadd([sc24.b,sc24.g,sc24.r,zv8]);//pushb(dIMAGELEN,dIMAGE,char(zc.b)+char(zc.g)+char(zc.r)+char(zv8));
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);//required - 18JAN2012
   end;
24:begin//"BGR" + 1bit MASK - 17JAN2012
   if (zv1=1) then sc24:=pal[0];//rgbBlack;//transparent pixels are BLACK
   ximg.aadd([sc24.b,sc24.g,sc24.r]);//pushb(dIMAGELEN,dIMAGE,char(zc.b)+char(zc.g)+char(zc.r));
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);
   end;
8:begin//"PalIndex" + 1bit MASK - 17JAN2012
   if (zv1=1) then v8:=0 else v8:=low__palfind24(pal,palcount,sc24);//transparent pixels are BLACK
   ximg.addbyt1(v8);//pushb(dIMAGELEN,dIMAGE,char(v8));
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);
   end;
4:begin//"PalIndex" + 1bit MASK - 17JAN2012
   if (zv1=1) then v8:=0 else v8:=low__palfind24(pal,palcount,sc24);//transparent pixels are BLACK
   pushpixel4(ximg,vals2,valspos2,v8,sx=maxx);
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);
   end;
1:begin//"PalIndex" + 1bit MASK - 17JAN2012
   if (zv1=1) then v8:=0 else v8:=low__palfind24(pal,palcount,sc24);//transparent pixels are BLACK
   pushpixel1(ximg,vals2,valspos2,v8,sx=maxx);
   pushpixel1(xmask,vals1,valspos1,zv1,sx=maxx);
   end;
end;//case
end;//sx

//.rowfix -> pushb(ximg,copy(#0#0#0#0,1,rowfix));
if (rowfix>=3) then ximg.addbyt1(0);
if (rowfix>=2) then ximg.addbyt1(0);
if (rowfix>=1) then ximg.addbyt1(0);

//.mrowfix -> pushb(dMASKLEN,dMASK,copy(#0#0#0#0,1,mrowfix));
if (mrowfix>=3) then xmask.addbyt1(0);
if (mrowfix>=2) then xmask.addbyt1(0);
if (mrowfix>=1) then xmask.addbyt1(0);
end;//sy

//.1st pal entry is BLACK for transparent icons - 07feb2022
if stransparent then
   begin
   pal[0].r:=0;
   pal[0].g:=0;
   pal[0].b:=0;
   end;
//.build palette - "BGR0"
if (palcount>=1) then for p:=0 to (palcount-1) do xpal.aadd([pal[p].b,pal[p].g,pal[p].r,0]);//pushb(dPALLEN,dPAL,char(pal[p].b)+char(pal[p].g)+char(pal[p].r)+#0);

//-- Build Icon ----------------------------------------------------------------
//.png - 23may2022
if dpng then
   begin
   ximg.clear;
   if not png__todata(s32,@ximg,e) then goto skipend;
   end;

//.init
fillchar(typhdr,sizeof(typhdr),0);
fillchar(icohdr,sizeof(icohdr),0);
fillchar(imghdr,sizeof(imghdr),0);

//.image header - 40b
imghdr.bisize:=sizeof(imghdr);
imghdr.biwidth:=dsize;
imghdr.biheight:=2*dsize;
imghdr.biplanes:=1;
imghdr.bibitcount:=dBPP;
imghdr.bicompression:=0;
imghdr.bisizeimage:=xpal.len+ximg.len+xmask.len;
//.icon header - 16b
//was: icohdr.width:=byte(frcrange32(dsize,0,255));
//was: icohdr.height:=byte(frcrange32(dsize,0,255));
//..sourced from https://en.wikipedia.org/wiki/ICO_(file_format) - 24may2022 @ 3:05am
if (dsize>=256) then
   begin
   icohdr.width:=0;
   icohdr.height:=0;
   end
else
   begin
   icohdr.width:=byte(frcrange32(dsize,0,255));
   icohdr.height:=byte(frcrange32(dsize,0,255));
   end;

case dBPP of
1:int1:=2;
4:int1:=16;
8:int1:=256;//17JAN2012
else int1:=0;
end;
icohdr.colors:=word(int1);
icohdr.diboffset:=22;//zero-based position of start of "image header" below
if dcursor then//23may2022
   begin
   icohdr.reserved1:=word(frcrange32(dhotx,0,maxword));//24JAN2012
   icohdr.reserved2:=word(frcrange32(dhoty,0,maxword));//24JAN2012
   end
else
   begin
   icohdr.reserved1:=0;
   icohdr.reserved2:=dbpp;
   end;
//.file header - 6b
typhdr.wtype:=low__aorb(1,2,dcursor);//0=stockicon, 1=icon (default for icons), 2=cursor
typhdr.count:=1;//number of icons
//.size
case dpng of
true:icohdr.dibsize:=ximg.len;
else icohdr.dibsize:=sizeof(imghdr)+imghdr.bisizeimage;//length of "dibHEADER+dibDATA"
end;//case

//set -> icondata:=fromstruc(@typhdr,sizeof(typhdr))+fromstruc(@icohdr,sizeof(icohdr))+fromstruc(@imghdr,sizeof(imghdr))+dPAL+dIMAGE+dMASK;
xdata.addrec(@typhdr,sizeof(typhdr));
xdata.addrec(@icohdr,sizeof(icohdr));
if dpng then
   begin
   xdata.add(ximg);
   end
else
   begin
   xdata.addrec(@imghdr,sizeof(imghdr));
   xdata.add(xpal);
   xdata.add(ximg);
   xdata.add(xmask);
   end;
//successful
result:=true;
skipend:
except;end;
//free
if not result then str__clear(@xdata);
freeobj(@s32);
str__free(@xpal);
str__free(@ximg);
str__free(@xmask);
str__uaf(@xdata);
end;

function low__toani32(s:tobject;slist:tfindlistimage;dformat:string;dpng:boolean;dsize:longint;ddelay,dhotX,dhotY:longint;xonehotspot:boolean;xdata:tstr8;var e:string):boolean;//15feb2022
var
   xoutbpp:longint;
begin
result:=low__toani32b(s,slist,dformat,dpng,dsize,0,ddelay,dhotX,dhotY,xonehotspot,xoutbpp,xdata,e);
end;

function low__toani32b(s:tobject;slist:tfindlistimage;dformat:string;dpng:boolean;dsize,dforceBPP:longint;ddelay,dhotX,dhotY:longint;xonehotspot:boolean;var xoutbpp:longint;xdata:tstr8;var e:string):boolean;//15feb2022
label
   //Note: Known anirec.flags: 1=win7/ours, 3=ms old/our
   //uses alpha channel to write transparency - 15feb2022
   //Note: for the time being "dpng" is DISABLED as we cannot find information pertaining to support for PNG enabled icons for ANI cursors - 24may2022
   //Force to dBPP when >=1, 0=automatic bpp
   skipend;
var
   int1,int2,dw,dh,p:integer;
   anirec:tanirec;
   xicon,xiconlist:tstr8;
   dcursor,dtransparent,xonce:boolean;
   xfoundhotX,xfoundhotY,dbpp,scellcount:longint;
   dcell:tbasicimage;//temp image for each icon to be read onto - 14feb2022
   //.mask support
   v0,v255,vother:boolean;
   xmin,xmax:longint;

   function xpullcell(x:longint;xdraw:boolean):boolean;
   label
      skipend;
   var
      xcell:tobject;//pointer only
      xtranscol,xbits,xcellw,xcellh,xw,xh,int1,int2,int3,xdelay:longint;
      xhasai,xtransparent:boolean;
   begin
   //defaults
   result:=false;
   xcell:=s;

   try
   //get
   if assigned(slist) then
      begin
      int1:=1;
      slist(nil,dformat,x,int1,xtranscol,xcell);
      scellcount:=frcmin32(int1,1);
      if not miscells(xcell,xbits,xw,xh,int1,int2,int3,xdelay,xhasai,xtransparent) then goto skipend;
      xcellw:=xw;
      xcellh:=xh;
      //.draw
      if xdraw and zzok2(dcell) and (not miscopyarea32(0,0,dw,dh,area__make(0,0,xcellw-1,xcellh-1),dcell,xcell)) then goto skipend;
      end
   else
      begin
      if not miscells(s,xbits,xw,xh,scellcount,xcellw,xcellh,xdelay,xhasai,xtransparent) then goto skipend;
      //.draw
      if xdraw and zzok2(dcell) and (not miscopyarea32(0,0,dw,dh,area__make(x*xcellw,0,((x+1)*xcellw)-1,xcellh-1),dcell,s)) then goto skipend;
      end;
   //.val defaults
   if xonce then
      begin
      xonce:=false;
      if (ddelay<=0) then ddelay:=xdelay;
      if (dsize<=0) then dsize:=(xcellw+xcellh) div 2;//vals set by call to "xpullcell(0)" above
      end;
   //successful
   result:=true;
   skipend:
   except;end;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
xonce:=true;
xicon:=nil;
xiconlist:=nil;
dcell:=nil;
xoutbpp:=1;
//check
if not str__lock(@xdata) then exit;
if not xpullcell(0,false) then goto skipend;
//disabled options - 24may2022 - awaiting for more information before proceeding further with format construction/completion, though a version is able to run - 24may2022
dpng:=false;
//range
dforceBPP:=frcrange32(dforceBPP,0,32);
//init
xdata.clear;
fillchar(anirec,sizeof(anirec),0);
ddelay:=frcmin32(ddelay,1);
dsize:=low__icosizes(dsize);//16..256
dw:=dsize;
dh:=dsize;
dcell:=misimg32(dw,dh);
dbpp:=1;
dtransparent:=false;
xicon:=str__new8;
xiconlist:=str__new8;
dformat:=io__extractfileext3(dformat,dformat);//accepts filename and extension only - 12apr2021
dcursor:=(dformat='cur') or (dformat='ico');

//-- GET -----------------------------------------------------------------------
//.dbpp - scan each cell and return the highest BPP rating to cover ALL cells - 22JAN2012
dbpp:=1;
for p:=0 to (scellcount-1) do
begin
if (dforceBPP>=1) then
   begin
   dbpp:=dforceBPP;
   break;
   end;
if not xpullcell(p,true) then goto skipend;
int1:=low__findbpp82432(dcell,area__make(0,0,dw-1,dh-1),false);
if (int1>dbpp) then dbpp:=int1;
if mask__range2(dcell,v0,v255,vother,xmin,xmax) then
   begin
   if vother then dbpp:=32;
   if not v255 then dtransparent:=true;
   end;
if (dbpp>=32) then break;
if (p=0) and dcursor then break;//only need first reported cell for a static cursor/icon
end;//p

//.dpng
if (misb(s)<>32) then dpng:=false;//23may2022
if dpng then dbpp:=32;//23may2022

//decide
//.cur + ico
if (dformat='cur') or (dformat='ico') then
   begin
   if not xpullcell(0,true) then goto skipend;
   result:=low__toico32(dcell,(dformat='cur'),dpng,dsize,dBPP,dhotX,dhotY,xfoundhotX,xfoundhotY,int2,xdata,e);
   if (int2>xoutbpp) then xoutbpp:=int2;
   goto skipend;
   end
//.ani
else if (dformat='ani') then
   begin
   //drop below to finish
   end
//.unsupported format
else goto skipend;

//.anirec - do last
anirec.cbsizeof:=sizeof(anirec);
anirec.cframes:=scellcount;//number of unique images
anirec.csteps:=scellcount;//number of cells in anmiation
anirec.cbitcount:=dbpp;
anirec.jifrate:=frcmin32(round(ddelay/16.666),1);
anirec.flags:=1;//win7/some of ours

//.cells -> icons
for p:=0 to (scellcount-1) do
begin
//.get cell
if not xpullcell(p,true) then goto skipend;
//.make icon
if not low__toico32(dcell,true,dpng,dsize,dBPP,dhotX,dhotY,xfoundhotX,xfoundhotY,int2,xicon,e) then goto skipend;
if (int2>xoutbpp) then xoutbpp:=int2;
//.hotspot -> reuse 1st hotspot (cell 1) for all remaining cells - 15feb2022
if xonehotspot and ((dhotX<0) or (dhotY<0)) then
   begin
   dhotX:=xfoundhotX;
   dhotY:=xfoundhotY;
   end;
//.add icon -> 'icon'+from32bit(length(imgs.items[p]^))+imgs.items[p]^
xiconlist.addstr('icon');
xiconlist.addint4(xicon.len);
xiconlist.add(xicon);
xicon.clear;
end;//p

//-- RIFF ----------------------------------------------------------------------
//.riff -> 'RIFF'+from32bit(length(data)+4)+data;
xdata.addstr('RIFF');
xdata.addint4(0);//set last
//._anih - 'ACONanih'+from32bit(sizeof(anirec))+fromstruc(@anirec,sizeof(anirec));
xdata.addstr('ACONanih');
xdata.addint4(sizeof(anirec));
xdata.addrec(@anirec,sizeof(anirec));
//._list
xdata.addstr('LIST');
xdata.addint4(4+xiconlist.len);
xdata.addstr('fram');
xdata.add(xiconlist);
//.reduce mem
xiconlist.clear;
//.set overal size
xdata.int4[4]:=frcmin32(xdata.len-4,0);

//successful
result:=true;
skipend:
except;end;
try
if (not result) and (xdata<>nil) then xdata.clear;
str__free(@xicon);
str__free(@xiconlist);
freeobj(@dcell);
str__uaf(@xdata);
except;end;
end;


//pixel modifier procs ---------------------------------------------------------
procedure fbNoise3(var r,g,b:byte);//faster - 29jul2017
var
   tmp:byte;
begin
tmp:=random(31);
r:=fb255[r+(tmp-15)];
g:=fb255[g+(tmp-15)];
b:=fb255[b+(tmp-15)];
end;

procedure fbInvert(var r,g,b:byte);
begin
r:=255-r;
g:=255-g;
b:=255-b;
end;

procedure fbGreyscale(var r,g,b:byte);
var
   v:byte;
begin
//get
v:=r;
if (g>v) then v:=g;
if (b>v) then v:=b;
//set
r:=v;
g:=v;
b:=v;
end;

procedure fbSepia(var r,g,b:byte);
var//Sepia base color is "128,91,36"
   v1,v2,v3:longint;
begin
//get
v1:=128;
v2:=r;
if (g>v2) then v2:=g;
if (b>v2) then v2:=b;
v3:=v1-v2;
//set
r:=fb255[128-v3];
g:=fb255[91-v3];
b:=fb255[36-v3];
end;


//ref procs (used with trefedit) -----------------------------------------------
function ref_blankX(x:tstr8;xlabel:string;xsize:longint):boolean;
var
   xlen,p:longint;
   v:text10;
begin  //hdr   id       use style          label
//defaults
result:=false;
//check
if zznil(x,2117) then exit;
//get
//was: result:='REF1'+#0#0#0#0+#0+#0+copy(xlabel+#0#0#0#0#0#0#0#0#0#0#0#0#0#0,1,14);
x.clear;
x.addbyt1(82);//R
x.addbyt1(69);//E
x.addbyt1(70);//F
x.addbyt1(49);//1
for p:=1 to 6 do x.addbyt1(0);
//.label
xlen:=low__len(xlabel);
for p:=1 to 14 do if (p<=xlen) then x.addbyt1(ord(xlabel[p-1+stroffset])) else x.addbyt1(0);
//.X blank blocks
if (xsize>=1) then
   begin
   v.val:=0;
   for p:=1 to xsize do
   begin
   x.addbyt1(v.bytes[0]);
   x.addbyt1(v.bytes[1]);
   x.addbyt1(v.bytes[2]);
   x.addbyt1(v.bytes[3]);
   x.addbyt1(v.bytes[4]);
   x.addbyt1(v.bytes[5]);
   x.addbyt1(v.bytes[6]);
   x.addbyt1(v.bytes[7]);
   x.addbyt1(v.bytes[8]);
   x.addbyt1(v.bytes[9]);
   end;//p
   end;
//size
x.setlen(x.count);
str__af(@x);//22aug2020
end;

function ref_blank1000(x:tstr8;xlabel:string):boolean;
begin;
result:=zzok(x,7000) and ref_blankX(x,xlabel,1000);
end;

function ref_valid(x:tstr8):boolean;
begin                                           //R                    E                    F                    1
result:=zzok(x,7001) and (x.len>=24) and (x.bytes1[1]=82) and (x.bytes1[2]=69) and (x.bytes1[3]=70) and (x.bytes1[4]=49);
str__af(@x);
//was: (copy(x,1,4)='REF1');
end;

function ref_id(x:tstr8):longint;
var
   a:tint4;
begin
result:=0;
if str__lock(@x) and ref_valid(x) then//27apr2021
   begin
   a.bytes[0]:=x.bytes1[5];
   a.bytes[1]:=x.bytes1[6];
   a.bytes[2]:=x.bytes1[7];
   a.bytes[3]:=x.bytes1[8];
   result:=a.val;
   end;
str__uaf(@x);//27apr2021
end;

procedure ref_setid(x:tstr8;y:longint);
var
   a:tint4;
begin
if str__lock(@x) and ref_valid(x) then
   begin
   a.val:=y;
   x.bytes1[5]:=a.bytes[0];
   x.bytes1[6]:=a.bytes[1];
   x.bytes1[7]:=a.bytes[2];
   x.bytes1[8]:=a.bytes[3];
   end;
str__uaf(@x);
end;

procedure ref_incid(x:tstr8);
var
   a:tint4;
begin
if str__lock(@x) and ref_valid(x) then//27apr2021
   begin
   a.bytes[0]:=x.bytes1[5];
   a.bytes[1]:=x.bytes1[6];
   a.bytes[2]:=x.bytes1[7];
   a.bytes[3]:=x.bytes1[8];
   low__iroll(a.val,1);
   x.bytes1[5]:=a.bytes[0];
   x.bytes1[6]:=a.bytes[1];
   x.bytes1[7]:=a.bytes[2];
   x.bytes1[8]:=a.bytes[3];
   end;
str__uaf(@x);
end;

function ref_count(x:tstr8):longint;
begin
str__lock(@x);
if ref_valid(x) then result:=(x.len-24) div 10 else result:=0;
str__uaf(@x);
end;

procedure ref_setcount(x:tstr8;xcount:longint);
var//Ultra fast -> no header checking etc
   p,ocount:longint;
begin
try
//check
if zznil(x,2118) then exit;
//init
str__lock(@x);
ocount:=ref_count(x);
xcount:=frcmin32(xcount,0);
x.setlen(24+(xcount*10));
if (ocount>=1) and (xcount>ocount) then for p:=ocount to (xcount-1) do ref_setval(x,p,0);
//inc
ref_incid(x);
except;end;
try;str__uaf(@x);except;end;
end;

function ref_use(x:tstr8):boolean;
begin
str__lock(@x);
result:=ref_valid(x) and (x.bytes1[9]<>0);
str__uaf(@x);
end;

procedure ref_setuse(x:tstr8;y:boolean);
begin
if str__lock(@x) and ref_valid(x) then
   begin
   if y then x.bytes1[9]:=1 else x.bytes1[9]:=0;
   //inc
   ref_incid(x);
   end;
str__uaf(@x);
end;

function ref_style(x:tstr8):byte;
begin
if str__lock(@x) and ref_valid(x) then result:=x.bytes1[10] else result:=0;
str__uaf(@x);
end;

procedure ref_setstyle(x:tstr8;y:byte);
begin
if str__lock(@x) and ref_valid(x) then
   begin
   x.bytes1[10]:=y;
   //inc
   ref_incid(x);
   end;
str__uaf(@x);
end;

function ref_stylelabel(x:tstr8):string;
begin
if str__lock(@x) and ref_valid(x) then result:=ref_stylelabel2(x.bytes1[10]) else result:='?';
str__uaf(@x);
end;

function ref_stylelabel2(x:longint):string;
var
   xcount:longint;
begin
result:=ref_stylelabel3(x,xcount);
end;

function ref_stylelabel3(x:longint;var xcount:longint):string;
begin
//defaults
result:='?';
xcount:=7;//return style limit => count (0..count-1) - 01sep2018
//get
case x of
0:result:=ntranslate('addition');
1:result:=ntranslate('multiply');
2:result:=ntranslate('invert');
3:result:=ntranslate('double');
4:result:=ntranslate('triple');
5:result:=ntranslate('r-double');
6:result:=ntranslate('r-triple');
end;
end;

function ref_stylecount:longint;//slow
begin
ref_stylelabel3(-1,result);
end;

function ref_proc(xstyle:longint;xval,xmin,xmax,xref:extended;xpos,xcount:longint):extended;
begin//Error protection adds an extra 150ms per 10million calls - 27aug2018
//defaults
result:=0;

try
//range
if (xcount<1) then xcount:=1;
if (xpos<0) then xpos:=0 else if (xpos>=xcount) then xpos:=xcount-1;
//get
case xstyle of
0:result:=xval+((xmax-xmin+1)*xref);//add
1:result:=xmin+(xval-xmin)*((1+xref)/1);//multiply
2:result:=xmax-((xval-xmin)*((1+xref)/1));//invert
3:result:=xval+(2*(xval-xmin)*xref);
4:result:=xval+(3*(xval-xmin)*xref);
5:result:=xmax-(2*(xval-xmin)*xref);
6:result:=xmax-(3*(xval-xmin)*xref);

{
//OLD's
//yyyyyyyyyyyyyyyyyyyy1:result:=xval*((1+xref)/1);//multiply
//yyyyyyyyyyyyyyyyyyyy 2:result:=xmax-((xval*((1+xref)/1))-xmin);//invert
   4:begin//balanced #1
      if (xval>=128) then result:=xval+round(128*a.val) else result:=xval-round(128*a.val);
      end;
   5:begin//balanced #2
      if (xval>=128) then result:=xval-round(128*a.val) else result:=xval+round(128*a.val);
      end;
   end;//case
{}//yyyyyyyyyyyyyyyyyyyy
end;//case
except;end;
end;

function ref_label(x:tstr8):string;
var
   p:longint;
begin
//defaults
result:='';
//check
if not str__lock(@x) then exit;
//get
if ref_valid(x) then
   begin
   for p:=11 to 24 do if (x.bytes1[p]<>0) then result:=result+char(x.bytes1[p]);
   //was:
   //result:=copy(x,11,14);
   //for p:=1 to low__len(result) do if (result[p-1+stroffset]=#0) then
   //   begin
   //   result:=strcopy1(result,1,p-1);
   //   break;
   //   end;
   end;
if (result='') then result:='?';
str__uaf(@x);
end;

procedure ref_setlabel(x:tstr8;y:string);
var
   i,ylen,p:longint;
begin
if str__lock(@x) and ref_valid(x) then
   begin
   ylen:=low__len(y);
   //was: y:=strcopy1(y+#0#0#0#0#0#0#0#0#0#0#0#0#0#0,1,14);
   for p:=11 to 24 do
   begin
   i:=p-10;//1-based
   if (i<=ylen) then x.bytes1[p]:=ord(y[i-1+stroffset]) else x.bytes1[p]:=0;
   end;
   //inc
   ref_incid(x);
   end;
str__uaf(@x);
end;

procedure ref_paste(xref,xnew:tstr8;xfit:boolean);
begin
ref_paste2(xref,xnew,xfit,true);
end;

procedure ref_paste2(xref,xnew:tstr8;xfit,xretainlabel:boolean);
label
   skipend;
var
   xn:string;
   i,p,nc,xc,xid:longint;
begin
try
//check
str__lock(@xref);
str__lock(@xnew);
if zznil(xref,2120) or zznil(xnew,2121) then goto skipend;
//init
xn:=ref_label(xref);
xid:=ref_id(xref);
xc:=ref_count(xref);
nc:=ref_count(xnew);

//check
if (nc<=0) then goto skipend;//nothing to paste

//get
if (xc<=0) then
   begin
   xref.replace:=xnew;//replace
   ref_setid(xref,xid);//carry over old iud
   end
else if xfit then//pastefit
   begin
   for p:=1 to xc do//value for value accurate - 29aug2018
   begin
   i:=frcrange32(round((p/xc)*nc)-1,0,nc-1);
   ref_setval(xref,p-1,ref_val(xnew,i));
   end;//p
   end
else//paste
   begin
   //sync size
   ref_setcount(xref,nc);
   //sync values
   for p:=0 to (nc-1) do ref_setval(xref,p,ref_val(xnew,p));
   end;

//re-enstate label and new values -> note: id is automatically inc'ed by the procs
if xretainlabel then ref_setlabel(xref,xn) else ref_setlabel(xref,ref_label(xnew));//label
ref_setuse(xref,ref_use(xnew));//new use
ref_setstyle(xref,ref_style(xnew));//new style
skipend:
except;end;
try
str__uaf(@xref);
str__uaf(@xnew);
except;end;
end;

procedure ref_smooth(x:tstr8;xmore:boolean);
label
   skipend;
var
   maxi,maxp,i,p:longint;
   v,v2:extended;
begin
try
//check
if not str__lock(@x) then exit;
//init
maxp:=ref_count(x)-1;
//check
if (maxp<1) then goto skipend;
if xmore then maxi:=10 else maxi:=1;
//get
for i:=1 to maxi do for p:=0 to maxp do
begin
v:=0;
v2:=0;
//-4
v:=v+ref_valex(x,p-4,true);
v2:=v2+1;
//-3
v:=v+ref_valex(x,p-3,true);
v2:=v2+1;
//-2
v:=v+ref_valex(x,p-2,true);
v2:=v2+1;
//-1
v:=v+ref_valex(x,p-1,true);
v2:=v2+1;
//0
v:=v+ref_valex(x,p,true);
v2:=v2+1;
//+1
v:=v+ref_valex(x,p+1,true);
v2:=v2+1;
//+2
v:=v+ref_valex(x,p+2,true);
v2:=v2+1;
//+3
v:=v+ref_valex(x,p+3,true);
v2:=v2+1;
//+4
v:=v+ref_valex(x,p+4,true);
v2:=v2+1;
//set
if (v2>=2) then ref_setval(x,p,v/v2);
end;//p
//inc
ref_incid(x);
skipend:
except;end;
try;str__uaf(@x);except;end;
end;

procedure ref_texture(x:tstr8;xmore:boolean);
label
   skipend;
var
   maxp,p:longint;
   v2,v:extended;
begin
try
//check
if not str__lock(@x) then exit;
//init
maxp:=ref_count(x)-1;
//check
if (maxp<1) then goto skipend;
//get
for p:=0 to maxp do
begin
v:=ref_val(x,p);
if xmore then v2:=random(10000)/10000 else v2:=random(1000)/10000;
if (v>0) then v:=v+v2 else if (v<0) then v:=v-v2;
ref_setval(x,p,v);
end;//p
//inc
ref_incid(x);
skipend:
except;end;
try;str__uaf(@x);except;end;
end;

procedure ref_mirror(x:tstr8);
label
   skipend;
var
   y:tstr8;
   c,p:longint;
begin
try
//defaults
y:=nil;
//check
if not str__lock(@x) then exit;
//init
c:=ref_count(x);
if (c<=0) then goto skipend;
//get
y:=bnewfrom(x);//take a copy
for p:=0 to (c-1) do ref_setval(x,p,ref_val(y,(c-1)-p));
//inc
ref_incid(x);
skipend:
except;end;
try;str__free(@y);except;end;
try;str__uaf(@x);except;end;
end;

procedure ref_flip(x:tstr8);
var
   p:longint;
begin
try
if str__lock(@x) and (ref_count(x)>=1) then
   begin
   for p:=0 to (ref_count(x)-1) do ref_setval(x,p,-ref_val(x,p));
   //inc
   ref_incid(x);
   end;
except;end;
try;str__uaf(@x);except;end;
end;

procedure ref_shiftx(x:tstr8;xby:longint);
label
   skipend;
var//xby=-N=slide left, +N=slide right
   y:tstr8;
   c,p,p2:longint;
   xneg:boolean;
begin
try
//defaults
y:=nil;
//check
if not str__lock(@x) then exit;
//check
c:=ref_count(x);
if (c<=0) then goto skipend;
//range
xneg:=(xby<0);
if xneg then xby:=-xby;
xby:=xby-((xby div c)*c);
if xneg then xby:=-xby;
if (xby=0) then exit;
//init
y:=bnewfrom(x);//take a copy
p2:=xby;
if (p2<0) then inc(p2,c);
if (p2>=c) then p2:=0;
//get
for p:=0 to (c-1) do
begin
ref_setval(x,p,ref_val(y,p2));
inc(p2);
if (p2>=c) then p2:=0;
end;//p
//inc
ref_incid(x);
skipend:
except;end;
try;str__free(@y);except;end;
try;str__uaf(@x);except;end;
end;

procedure ref_shifty(x:tstr8;xby:extended);
var
   p:longint;
begin
try
if str__lock(@x) and (xby<>0) and (ref_count(x)>=1) then
   begin
   for p:=0 to (ref_count(x)-1) do ref_setval(x,p,ref_val(x,p)+xby);
   //inc
   ref_incid(x);
   end;
except;end;
try;str__uaf(@x);except;end;
end;

procedure ref_zoom(x:tstr8;xby:extended);
var
   p:longint;
begin
try
if str__lock(@x) and (xby<>0) and (ref_count(x)>=1) then
   begin
   for p:=0 to (ref_count(x)-1) do ref_setval(x,p,ref_val(x,p)*xby);
   //inc
   ref_incid(x);
   end;
except;end;
try;str__uaf(@x);except;end;
end;

function ref_val(x:tstr8;xindex:longint):extended;//raw only, no style
begin
result:=ref_valex(x,xindex,false);
end;

function ref_valex(x:tstr8;xindex:longint;xloop:boolean):extended;//raw only, no style
var//Ultra fast -> no header checking etc
   a:text10;
   c:longint;
begin
//defaults
result:=0;
//check
if not str__lock(@x) then exit;
//loop
if xloop then
   begin
   c:=frcmin32(ref_count(x),1);
   if (xindex<0) then xindex:=frcrange32(c+xindex,0,c-1)
   else if (xindex>=c) then xindex:=frcrange32(xindex-c,0,c-1);
   end;
//get
xindex:=25+(xindex*10);
if (xindex>=25) and ((xindex+9)<=x.len) then
   begin
   a.bytes[0]:=x.bytes1[xindex+0];
   a.bytes[1]:=x.bytes1[xindex+1];
   a.bytes[2]:=x.bytes1[xindex+2];
   a.bytes[3]:=x.bytes1[xindex+3];
   a.bytes[4]:=x.bytes1[xindex+4];
   a.bytes[5]:=x.bytes1[xindex+5];
   a.bytes[6]:=x.bytes1[xindex+6];
   a.bytes[7]:=x.bytes1[xindex+7];
   a.bytes[8]:=x.bytes1[xindex+8];
   a.bytes[9]:=x.bytes1[xindex+9];
   result:=a.val;
   end;
str__uaf(@x);
end;

function ref_val2(x:tstr8;xindex,xval,xmin,xmax:longint):longint;//raw only, no style
begin
result:=ref_val2ex(x,xindex,xval,xmin,xmax,false);
end;

function ref_val2ex(x:tstr8;xindex,xval,xmin,xmax:longint;xloop:boolean):longint;//raw only, no style
var//Ultra fast -> no header checking etc
   a:text10;
   c:longint;
begin
//defaults
result:=0;
//check
if not str__lock(@x) then exit;
//loop
if xloop then
   begin
   c:=frcmin32(ref_count(x),1);
   if (xindex<0) then xindex:=frcrange32(c+xindex,0,c-1)
   else if (xindex>=c) then xindex:=frcrange32(xindex-c,0,c-1);
   end;
//get
xindex:=25+(xindex*10);
if (xindex>=25) and ((xindex+9)<=x.len) then
   begin
   a.bytes[0]:=x.bytes1[xindex+0];
   a.bytes[1]:=x.bytes1[xindex+1];
   a.bytes[2]:=x.bytes1[xindex+2];
   a.bytes[3]:=x.bytes1[xindex+3];
   a.bytes[4]:=x.bytes1[xindex+4];
   a.bytes[5]:=x.bytes1[xindex+5];
   a.bytes[6]:=x.bytes1[xindex+6];
   a.bytes[7]:=x.bytes1[xindex+7];
   a.bytes[8]:=x.bytes1[xindex+8];
   a.bytes[9]:=x.bytes1[xindex+9];
   result:=round(xval*a.val);
   end;
//range
if (result<xmin) then result:=xmin
else if (result>xmax) then result:=xmax;
//free
str__uaf(@x);
end;

function ref_val32(x:tstr8;xindex,xval,xmin,xmax:longint):longint;
var//Ultra fast -> no header checking etc
   a:text10;
begin
//defaults
result:=0;
//check
if not str__lock(@x) then exit;
//get
xindex:=25+(xindex*10);
if (xindex>=25) and ((xindex+9)<=x.len) then
   begin
   a.bytes[0]:=x.bytes1[xindex+0];
   a.bytes[1]:=x.bytes1[xindex+1];
   a.bytes[2]:=x.bytes1[xindex+2];
   a.bytes[3]:=x.bytes1[xindex+3];
   a.bytes[4]:=x.bytes1[xindex+4];
   a.bytes[5]:=x.bytes1[xindex+5];
   a.bytes[6]:=x.bytes1[xindex+6];
   a.bytes[7]:=x.bytes1[xindex+7];
   a.bytes[8]:=x.bytes1[xindex+8];
   a.bytes[9]:=x.bytes1[xindex+9];
   result:=round(ref_proc(x.bytes1[10],xval,xmin,xmax,a.val,(xindex-25) div 10,(x.len-24) div 10));
   end
else result:=round(ref_proc(0,xval,xmin,xmax,0,0,0));
//range
if (result<xmin) then result:=xmin
else if (result>xmax) then result:=xmax;
//free
str__uaf(@x);
end;

function ref_val0255(x:tstr8;xval:longint):longint;
var//Ultra fast -> no header checking etc
   a:text10;
   xindex:longint;
begin
//defaults
result:=0;
//check
if not str__lock(@x) then exit;
//get                 //count  * percentage * blocksize
xindex:=25+(round((xval/255)*(((x.len-24) div 10)-1))*10);
if (xindex>=25) and ((xindex+9)<=x.len) then
   begin
   a.bytes[0]:=x.bytes1[xindex+0];
   a.bytes[1]:=x.bytes1[xindex+1];
   a.bytes[2]:=x.bytes1[xindex+2];
   a.bytes[3]:=x.bytes1[xindex+3];
   a.bytes[4]:=x.bytes1[xindex+4];
   a.bytes[5]:=x.bytes1[xindex+5];
   a.bytes[6]:=x.bytes1[xindex+6];
   a.bytes[7]:=x.bytes1[xindex+7];
   a.bytes[8]:=x.bytes1[xindex+8];
   a.bytes[9]:=x.bytes1[xindex+9];
   result:=round(ref_proc(x.bytes1[10],xval,0,255,a.val,(xindex-25) div 10,(x.len-24) div 10));
   end
else result:=round(ref_proc(0,xval,0,255,0,0,0));
//range
if (result<0) then result:=0
else if (result>255) then result:=255;
//free
str__uaf(@x);
end;

function ref_val255255(x:tstr8;xval:longint):longint;
var//Ultra fast -> no header checking etc
   a:text10;
   xindex:longint;
begin
//defaults
result:=0;
//check
if not str__lock(@x) then exit;
//get                 //count  * percentage * blocksize
xindex:=25+(round((xval/255)*(((x.len-24) div 10)-1))*10);
if (xindex>=25) and ((xindex+9)<=x.len) then
   begin
   a.bytes[0]:=x.bytes1[xindex+0];
   a.bytes[1]:=x.bytes1[xindex+1];
   a.bytes[2]:=x.bytes1[xindex+2];
   a.bytes[3]:=x.bytes1[xindex+3];
   a.bytes[4]:=x.bytes1[xindex+4];
   a.bytes[5]:=x.bytes1[xindex+5];
   a.bytes[6]:=x.bytes1[xindex+6];
   a.bytes[7]:=x.bytes1[xindex+7];
   a.bytes[8]:=x.bytes1[xindex+8];
   a.bytes[9]:=x.bytes1[xindex+9];
   result:=round(ref_proc(x.bytes1[10],xval,-255,255,a.val,(xindex-25) div 10,(x.len-24) div 10));
   end
else result:=round(ref_proc(0,xval,-255,255,0,0,0));
//range
if (result<-255) then result:=-255
else if (result>255) then result:=255;
//free
str__uaf(@x);
end;

function ref_valrange32(x:tstr8;xval,xmin,xmax,zpos:longint;var zmin,zmax,zoff,zcount:longint):longint;
var//Ultra fast -> no header checking etc
   a:text10;
   int1:longint;
begin
//defaults
result:=0;
//check
if not str__lock(@x) then exit;
//init
if (zcount=0) then
   begin
   //.vars
   zcount:=ref_count(x);
   zoff:=0;
   //.small -> large
   if (zmax<zmin) then
      begin
      int1:=zmax;
      zmax:=zmin;
      zmin:=int1;
      end;
   //.convert range to "0..max"
   if (zmin<0) or (zmin>0) then
      begin
      zoff:=-zmin;
      zmax:=zmax+zoff;
      zmin:=0;
      end;
   //.zmax MUST be 1 or higher
   if (zmax<1) then zmax:=1;
   end;
//.zpos
inc(zpos,zoff);
if (zpos<zmin) then zpos:=zmin
else if (zpos>zmax) then zpos:=zmax;
//get
zpos:=25+(round((zpos/zmax)*(zcount-1))*10);
if (zpos>=25) and ((zpos+9)<=x.len) then
   begin
   a.bytes[0]:=x.bytes1[zpos+0];
   a.bytes[1]:=x.bytes1[zpos+1];
   a.bytes[2]:=x.bytes1[zpos+2];
   a.bytes[3]:=x.bytes1[zpos+3];
   a.bytes[4]:=x.bytes1[zpos+4];
   a.bytes[5]:=x.bytes1[zpos+5];
   a.bytes[6]:=x.bytes1[zpos+6];
   a.bytes[7]:=x.bytes1[zpos+7];
   a.bytes[8]:=x.bytes1[zpos+8];
   a.bytes[9]:=x.bytes1[zpos+9];
   result:=round(ref_proc(x.bytes1[10],xval,xmin,xmax,a.val,(zpos-25) div 10,(x.len-24) div 10));
   end
else result:=round(ref_proc(0,xval,xmin,xmax,0,0,0));
//range
if (result<xmin) then result:=xmin
else if (result>xmax) then result:=xmax;
//free
str__uaf(@x);
end;

function ref_val80(x:tstr8;xindex:longint;xval,xmin,xmax:extended):extended;
var//Ultra fast -> no header checking etc
   a:text10;
begin
//defaults
result:=0;
//check
if not str__lock(@x) then exit;
//get
xindex:=25+(xindex*10);
if (xindex>=25) and ((xindex+9)<=x.len) then
   begin
   a.bytes[0]:=x.bytes1[xindex+0];
   a.bytes[1]:=x.bytes1[xindex+1];
   a.bytes[2]:=x.bytes1[xindex+2];
   a.bytes[3]:=x.bytes1[xindex+3];
   a.bytes[4]:=x.bytes1[xindex+4];
   a.bytes[5]:=x.bytes1[xindex+5];
   a.bytes[6]:=x.bytes1[xindex+6];
   a.bytes[7]:=x.bytes1[xindex+7];
   a.bytes[8]:=x.bytes1[xindex+8];
   a.bytes[9]:=x.bytes1[xindex+9];
   result:=xval*a.val;
   end
else result:=0;
//range
if (result<xmin) then result:=xmin
else if (result>xmax) then result:=xmax;
//free
str__uaf(@x);
end;

function ref_valrange80(x:tstr8;xval,xmin,xmax:extended;zpos:longint;var zmin,zmax,zoff,zcount:longint):extended;
var//Ultra fast -> no header checking etc
   a:text10;
   int1:longint;
begin
//defaults
result:=0;
//check
if not str__lock(@x) then exit;
//init
if (zcount=0) then
   begin
   //.vars
   zcount:=ref_count(x);
   zoff:=0;
   //.small -> large
   if (zmax<zmin) then
      begin
      int1:=zmax;
      zmax:=zmin;
      zmin:=int1;
      end;
   //.convert range to "0..max"
   if (zmin<0) or (zmin>0) then
      begin
      zoff:=-zmin;
      zmax:=zmax+zoff;
      zmin:=0;
      end;
   //.zmax MUST be 1 or higher
   if (zmax<1) then zmax:=1;
   end;
//.zpos
inc(zpos,zoff);
if (zpos<zmin) then zpos:=zmin
else if (zpos>zmax) then zpos:=zmax;
//get
zpos:=25+(round((zpos/zmax)*(zcount-1))*10);
if (zpos>=25) and ((zpos+9)<=x.len) then
   begin
   a.bytes[0]:=x.bytes1[zpos+0];
   a.bytes[1]:=x.bytes1[zpos+1];
   a.bytes[2]:=x.bytes1[zpos+2];
   a.bytes[3]:=x.bytes1[zpos+3];
   a.bytes[4]:=x.bytes1[zpos+4];
   a.bytes[5]:=x.bytes1[zpos+5];
   a.bytes[6]:=x.bytes1[zpos+6];
   a.bytes[7]:=x.bytes1[zpos+7];
   a.bytes[8]:=x.bytes1[zpos+8];
   a.bytes[9]:=x.bytes1[zpos+9];
   result:=ref_proc(x.bytes1[10],xval,xmin,xmax,a.val,(zpos-25) div 10,(x.len-24) div 10);
   end
else result:=ref_proc(0,xval,xmin,xmax,0,0,0);
//range
if (result<xmin) then result:=xmin
else if (result>xmax) then result:=xmax;
//free
str__uaf(@x);
end;

procedure ref_setval(x:tstr8;xindex:longint;y:extended);
var//Ultra fast -> no header checking etc
   a:text10;
begin
xindex:=25+(xindex*10);
if str__lock(@x) and (xindex>=25) and ((xindex+9)<=x.len) then
   begin
   a.val:=y;
   x.bytes1[xindex+0]:=a.bytes[0];
   x.bytes1[xindex+1]:=a.bytes[1];
   x.bytes1[xindex+2]:=a.bytes[2];
   x.bytes1[xindex+3]:=a.bytes[3];
   x.bytes1[xindex+4]:=a.bytes[4];
   x.bytes1[xindex+5]:=a.bytes[5];
   x.bytes1[xindex+6]:=a.bytes[6];
   x.bytes1[xindex+7]:=a.bytes[7];
   x.bytes1[xindex+8]:=a.bytes[8];
   x.bytes1[xindex+9]:=a.bytes[9];
   end;
//free
str__uaf(@x);
end;

procedure ref_setall(x:tstr8;y:extended);
var
   c,p:longint;
begin
try
str__lock(@x);
c:=ref_count(x);
if (c>=1) then for p:=0 to (c-1) do
   begin
   ref_setval(x,p,y);
   //inc
   ref_incid(x);
   end;
//free
str__uaf(@x);
except;end;
end;


//color procs ------------------------------------------------------------------
function int__c8(x:longint):tcolor8;
var
   a:tint4;
begin
a.val:=x;
result:=a.r;
if (a.g>result) then result:=a.g;
if (a.b>result) then result:=a.b;
end;

function int__c24(x:longint):tcolor24;
var
   c:tint4;
begin
c.val:=x;
result.r:=c.r;
result.g:=c.g;
result.b:=c.b;
end;

function int__c32(x:longint):tcolor32;
var
   c:tint4;
begin
c.val:=x;
result.r:=c.r;
result.g:=c.g;
result.b:=c.b;
result.a:=c.a;
end;

function c24__match(s,d:tcolor24):boolean;
begin
result:=(s.r=d.r) and (s.g=d.g) and (s.b=d.b);
end;

function c32__match(s,d:tcolor32):boolean;
begin
result:=(s.r=d.r) and (s.g=d.g) and (s.b=d.b) and (s.a=d.a);
end;

function c32_c24__match(s:tcolor32;d:tcolor24):boolean;
begin
result:=(s.r=d.r) and (s.g=d.g) and (s.b=d.b);
end;

function inta__int(x:longint;a:byte):longint;
var
   c:tint4;
begin
c.val:=x;
c.a:=a;
result:=c.val;
end;

function inta__c32(x:longint;a:byte):tcolor32;
var
   c:tint4;
begin
c.val:=x;
result.r:=c.r;
result.g:=c.g;
result.b:=c.b;
result.a:=a;
end;

function c8__int(x:tcolor8):longint;
var
   a:tint4;
begin
a.r:=x;
a.g:=x;
a.b:=x;
a.a:=0;//*
result:=a.val;
end;

//.greyscale procs -------------------------------------------------------------
procedure c24__greyscale(var x:tcolor24);
begin
if (x.g>x.r) then x.r:=x.g;
if (x.b>x.r) then x.r:=x.b;
x.g:=x.r;
x.b:=x.r;
end;

function c24__greyscale2(var x:tcolor24):byte;
begin
result:=x.r;
if (x.g>result) then result:=x.g;
if (x.b>result) then result:=x.b;
end;

function c24__greyscale2b(x:tcolor24):byte;
begin
result:=x.r;
if (x.g>result) then result:=x.g;
if (x.b>result) then result:=x.b;
end;

function c24__lum(x:tcolor24):byte;
begin
result:=x.r;
if (x.g>result) then result:=x.g;
if (x.b>result) then result:=x.b;
end;

function c32__lum(x:tcolor32):byte;
begin
result:=x.r;
if (x.g>result) then result:=x.g;
if (x.b>result) then result:=x.b;
end;

function int__greyscale(x:longint):longint;
var
   c:tint4;
begin
c.val:=x;
if (c.g>c.r) then c.r:=c.g;
if (c.b>c.r) then c.r:=c.b;
c.g:=c.r;
c.b:=c.r;
result:=c.val;
end;

function inta__greyscale(x:longint;a:byte):longint;
var
   c:tint4;
begin
c.val:=x;
if (c.g>c.r) then c.r:=c.g;
if (c.b>c.r) then c.r:=c.b;
c.g:=c.r;
c.b:=c.r;
c.a:=a;
result:=c.val;
end;

function int__greyscale_ave(x:longint):longint;
var
   c:tint4;
begin
c.val:=x;
result:=(c.r+c.g+c.b) div 3;
end;

function int__greyscale_c8(x:longint):tcolor8;//03feb2025, 18nov2023
var
   c:tint4;
begin
c.val:=x;
if (c.g>c.r) then c.r:=c.g;
if (c.b>c.r) then c.r:=c.b;
result:=c.r;
end;

//.invert procs ----------------------------------------------------------------
function int__invert(x:longint;var xout:longint):boolean;
begin
result:=int__invert2(x,false,xout);
end;

function int__invertb(x:longint):longint;
begin
int__invert2(x,false,result);
end;

function int__invert2(x:longint;xgreycorrection:boolean;var xout:longint):boolean;
var
   c:tint4;
   b:longint;
begin
result:=true;//pass-thru
if xgreycorrection and int__brightness(x,b) and (b>=100) and (b<=156) then xout:=int_255_255_255
else
   begin//invert
   c.val:=x;
   c.r:=255-c.r;
   c.g:=255-c.g;
   c.b:=255-c.b;
   xout:=c.val;
   end;
end;

function int__invert2b(x:longint;xgreycorrection:boolean):longint;
begin
int__invert2(x,xgreycorrection,result);
end;

function c24__int(x:tcolor24):longint;
var
   a:tint4;
begin
a.r:=x.r;
a.g:=x.g;
a.b:=x.b;
a.a:=0;//*
result:=a.val;
end;

function c24a0__int(x:tcolor24):longint;
var
   a:tint4;
begin
a.r:=x.r;
a.g:=x.g;
a.b:=x.b;
a.a:=0;
result:=a.val;
end;

function c32__int(x:tcolor32):longint;
var
   c:tint4;
begin
c.r:=x.r;
c.g:=x.g;
c.b:=x.b;
c.a:=x.a;
result:=c.val;
end;

function c8a__int(x:tcolor8;a:byte):longint;
var
   v:tint4;
begin
v.r:=x;
v.g:=x;
v.b:=x;
v.a:=a;
result:=v.val;
end;

function c24a__int(x:tcolor24;a:byte):longint;
var
   v:tint4;
begin
v.r:=x.r;
v.g:=x.g;
v.b:=x.b;
v.a:=a;
result:=v.val;
end;

function int24__rgba0(x24__or__syscolor:longint):longint;
begin
if (x24__or__syscolor<0) then result:=win____GetSysColor(x24__or__syscolor and $000000FF) else result:=x24__or__syscolor;
end;

function rgb0__int(r,g,b:byte):longint;
var
   x:tint4;
begin
x.r:=r;
x.g:=g;
x.b:=b;
x.a:=0;
result:=x.val;
end;

function rgba0__int(r,g,b:byte):longint;
var
   x:tint4;
begin
x.r:=r;
x.g:=g;
x.b:=b;
x.a:=0;
result:=x.val;
end;

function rgba__int(r,g,b,a:byte):longint;
var
   x:tint4;
begin
x.r:=r;
x.g:=g;
x.b:=b;
x.a:=a;
result:=x.val;
end;

function ggga0__int(r:byte):longint;
var
   x:tint4;
begin
x.r:=r;
x.g:=r;
x.b:=r;
x.a:=0;
result:=x.val;
end;

function ggga__int(r,a:byte):longint;
var
   x:tint4;
begin
x.r:=r;
x.g:=r;
x.b:=r;
x.a:=a;
result:=x.val;
end;

function rgb__c24(r,g,b:byte):tcolor24;
begin
result.r:=r;
result.g:=g;
result.b:=b;
end;

function rgba0__c32(r,g,b:byte):tcolor32;
begin
result.r:=r;
result.g:=g;
result.b:=b;
result.a:=0;
end;

function rgba255__c32(r,g,b:byte):tcolor32;
begin
result.r:=r;
result.g:=g;
result.b:=b;
result.a:=255;
end;

function rgba__c32(r,g,b,a:byte):tcolor32;
begin
result.r:=r;
result.g:=g;
result.b:=b;
result.a:=a;
end;

function c24a0__c32(x:tcolor24):tcolor32;
begin
result.r:=x.r;
result.g:=x.g;
result.b:=x.b;
result.a:=0;
end;

function c24a255__c32(x:tcolor24):tcolor32;
begin
result.r:=x.r;
result.g:=x.g;
result.b:=x.b;
result.a:=255;
end;

function c24a__c32(x:tcolor24;a:byte):tcolor32;
begin
result.r:=x.r;
result.g:=x.g;
result.b:=x.b;
result.a:=a;
end;

function c32__c24(x:tcolor32):tcolor24;
begin
result.r:=x.r;
result.g:=x.g;
result.b:=x.b;
end;

function c32__c8(x:tcolor32):tcolor8;
begin
result:=x.r;
if (x.g>result) then result:=x.g;
if (x.b>result) then result:=x.b;
end;

function c24__c8(x:tcolor24):tcolor8;
begin
result:=x.r;
if (x.g>result) then result:=x.g;
if (x.b>result) then result:=x.b;
end;

function ca__c8(x:tcolor32):tcolor8;
begin
result:=x.a;
end;

procedure c32__irgb(var x:tcolor32);//invert RGB
begin
x.r:=255-x.r;
x.g:=255-x.g;
x.b:=255-x.b;
end;

procedure c32__irgba(var x:tcolor32);//invert RGBA
begin
x.r:=255-x.r;
x.g:=255-x.g;
x.b:=255-x.b;
x.a:=255-x.a;
end;

procedure c32__ia(var x:tcolor32);//invert A
begin
x.a:=255-x.a;
end;

procedure c24__irgb(var x:tcolor24);//invert RGB
begin
x.r:=255-x.r;
x.g:=255-x.g;
x.b:=255-x.b;
end;

procedure c8__i(var x:tcolor8);//invert
begin
x:=255-x;
end;

function int__brightness(x:longint;var xout:longint):boolean;
var
   c:tint4;
begin
result:=true;//pass-thru
c.val:=x;
xout:=c.r;
if (c.g>xout) then xout:=c.g;
if (c.b>xout) then xout:=c.b;
end;

function int__brightnessb(x:longint):longint;
var
   c:tint4;
begin
c.val:=x;
result:=c.r;
if (c.g>result) then result:=c.g;
if (c.b>result) then result:=c.b;
end;

function int__brightness_ave(x:longint;var xout:longint):boolean;
var
   c:tint4;
begin
result:=true;//pass-thru
c.val:=x;
xout:=(c.r+c.g+c.b) div 3;
end;

function int__brightness_aveb(x:longint):longint;
var
   c:tint4;
begin
c.val:=x;
result:=(c.r+c.g+c.b) div 3;
end;

function int__setbrightness357(xcolor,xbrightness357:longint):longint;//18feb2025, 05feb2025
var
   c32:tint4;
   v:longint;
begin
if (xbrightness357<>255) then
   begin
   //init
   xbrightness357:=frcrange32(xbrightness357,0,357);
   c32.val:=xcolor;

   //r
   v:=(c32.r*xbrightness357) div 256;//div 256 is FASTER than 255
   if (v>255) then v:=255;
   c32.r:=v;

   //g
   v:=(c32.g*xbrightness357) div 256;
   if (v>255) then v:=255;
   c32.g:=v;

   //b
   v:=(c32.b*xbrightness357) div 256;
   if (v>255) then v:=255;
   c32.b:=v;

   //a - leave as is

   //set
   result:=c32.val;
   end
else result:=xcolor;
end;

//.splice procs ----------------------------------------------------------------
function c24__splice(xpert01:extended;s,d:tcolor24):tcolor24;//17may2022
var//xpert01 range is 0..1 (0=0% and 0.5=50% and 1=100%)
   p2:extended;
   v:longint;
begin
//init
if (xpert01<0) then xpert01:=0 else if (xpert01>1) then xpert01:=1;
p2:=1-xpert01;
//r
v:=round((d.r*xpert01)+(s.r*p2));
if (v<0) then v:=0 else if (v>255) then v:=255;
result.r:=v;
//g
v:=round((d.g*xpert01)+(s.g*p2));
if (v<0) then v:=0 else if (v>255) then v:=255;
result.g:=v;
//b
v:=round((d.b*xpert01)+(s.b*p2));
if (v<0) then v:=0 else if (v>255) then v:=255;
result.b:=v;
end;

function c32__splice(xpert01:extended;s,d:tcolor32):tcolor32;//06dec2023
var//xpert01 range is 0..1 (0=0% and 0.5=50% and 1=100%)
   p2:extended;
   v:longint;
begin
//init
if (xpert01<0) then xpert01:=0 else if (xpert01>1) then xpert01:=1;
p2:=1-xpert01;
//r
v:=round((d.r*xpert01)+(s.r*p2));
if (v<0) then v:=0 else if (v>255) then v:=255;
result.r:=v;
//g
v:=round((d.g*xpert01)+(s.g*p2));
if (v<0) then v:=0 else if (v>255) then v:=255;
result.g:=v;
//b
v:=round((d.b*xpert01)+(s.b*p2));
if (v<0) then v:=0 else if (v>255) then v:=255;
result.b:=v;
//a
v:=round((d.a*xpert01)+(s.a*p2));
if (v<0) then v:=0 else if (v>255) then v:=255;
result.a:=v;
end;

function int__splice24(xpert01:extended;s,d:longint):longint;//13nov2022
begin//xpert range is 0..1 (0=0% and 0.5=50% and 1=100%)
result:=c24a0__int(c24__splice(xpert01,int__c24(s),int__c24(d)));
end;

function int__splice32(xpert01:extended;s,d:longint):longint;//13nov2022
begin//xpert range is 0..1 (0=0% and 0.5=50% and 1=100%)
result:=c32__int(c32__splice(xpert01,int__c32(s),int__c32(d)));
end;

function int__splice24_100(xpert100,s,d:longint):longint;
begin
result:=int__splice24(xpert100/100,s,d);
end;

function int__splice32_100(xpert100,s,d:longint):longint;
begin
result:=int__splice32(xpert100/100,s,d);
end;

//.color by name procs ---------------------------------------------------------
function inta0__findcolor(xname:string):longint;
begin
result:=inta__findcolor(xname,0);
end;

function inta__findcolor(xname:string;a:byte):longint;
const
   xlc=220;
begin
xname:=strlow(xname);

if      (xname='yellow') then result:=rgba__int(255,255,190,a)
else if (xname='green')  then result:=rgba__int(xlc,255,xlc,a)
else if (xname='blue')   then result:=rgba__int(xlc,255,255,a)//was: low__rgb(230,255,255)
else if (xname='red')    then result:=rgba__int(255,xlc,xlc,a)
else if (xname='pink')   then result:=rgba__int(255,226,235,a)
else if (xname='orange') then result:=rgba__int(255,231,190,a)
else if (xname='grey')   then result:=rgba__int(230,230,230,a)
else if (xname='purple') then result:=rgba__int(245,230,250,a)
else if (xname='white')  then result:=rgba__int(255,255,250,a)//slight yellowish tint
else                          result:=rgba__int(230,230,230,a);
end;

//.color dodger procs ----------------------------------------------------------
function c24__nonwhite24(x:tcolor24):tcolor24;//make sure color is never white - 18feb2025: fixed
begin
if (x.r=255) and (x.g=255) and (x.b=255) then
   begin
   result.r:=254;
   result.g:=254;
   result.b:=254;
   end
else result:=x;
end;

function c24a__nonwhite32(x:tcolor24;a:byte):tcolor32;//make sure color is never white - 18feb2025: fixed
begin
if (x.r=255) and (x.g=255) and (x.b=255) then
   begin
   result.r:=254;
   result.g:=254;
   result.b:=254;
   result.a:=a;
   end
else
   begin
   result.r:=x.r;
   result.g:=x.g;
   result.b:=x.b;
   result.a:=a;
   end;
end;

function c24__nonblack24(x:tcolor24):tcolor24;//make sure color is never white - 18feb2025: fixed
begin
if (x.r=0) and (x.g=0) and (x.b=0) then
   begin
   result.r:=1;
   result.g:=1;
   result.b:=1;
   end
else result:=x;
end;

function c24a__nonblack32(x:tcolor24;a:byte):tcolor32;//make sure color is never white - 18feb2025: fixed
begin
if (x.r=0) and (x.g=0) and (x.b=0) then
   begin
   result.r:=1;
   result.g:=1;
   result.b:=1;
   result.a:=a;
   end
else
   begin
   result.r:=x.r;
   result.g:=x.g;
   result.b:=x.b;
   result.a:=a;
   end;
end;

//.color adjuster procs ---------------------------------------------------------
function c24__focus24(x:tcolor24):tcolor24;
const
   fv=30;
var
   v:longint;
begin
//r
v:=x.r+fv;
if (v<100) then v:=100;
if (v>255) then v:=255;
result.r:=v;

//g
v:=x.g+fv;
if (v<100) then v:=100;
if (v>255) then v:=255;
result.g:=v;

//b
v:=x.b+fv;
if (v<100) then v:=100;
if (v>255) then v:=255;
result.b:=v;
end;

function c32__focus32(x:tcolor32):tcolor32;
var
   a:tcolor24;
begin
a.r:=x.r;
a.g:=x.g;
a.b:=x.b;

a:=c24__focus24(a);

result.r:=a.r;
result.g:=a.g;
result.b:=a.b;
result.a:=x.a;
end;

//.hex color procs -------------------------------------------------------------
function int__hex6(c:longint;xhash:boolean):string;
begin
result:=c24__hex6(int__c24(c),xhash);
end;

function inta__hex8(c:longint;a:byte;xhash:boolean):string;
begin
result:=c24a__hex8(int__c24(c),a,xhash);
end;

function int__hex8(c:longint;xhash:boolean):string;
begin
result:=c32__hex8(int__c32(c),xhash);
end;

function c24__hex6(c24:tcolor24;xhash:boolean):string;//ultra-fast int->hex color converter - 15aug2019
var
   v,v2:longint;
   c2,c3,c4,c5,c6,c7:char;
begin
//r=2,3
v :=c24.r div 16;
v2:=c24.r-(v*16);
if (v <=9) then c2:=char(48+v ) else c2:=char(55+v );
if (v2<=9) then c3:=char(48+v2) else c3:=char(55+v2);

//g=4,5
v :=c24.g div 16;
v2:=c24.g-(v*16);
if (v <=9) then c4:=char(48+v ) else c4:=char(55+v );
if (v2<=9) then c5:=char(48+v2) else c5:=char(55+v2);

//b=6,7
v :=c24.b div 16;
v2:=c24.b-(v*16);
if (v <=9) then c6:=char(48+v ) else c6:=char(55+v );
if (v2<=9) then c7:=char(48+v2) else c7:=char(55+v2);

//get
if xhash then result:='#'+c2+c3+c4+c5+c6+c7 else result:=c2+c3+c4+c5+c6+c7;
end;

function c32__hex6(c32:tcolor32;xhash:boolean):string;//ultra-fast int->hex color converter - 15aug2019
begin
result:=c24__hex6(c32__c24(c32),xhash);
end;

function c24a__hex8(c24:tcolor24;a:byte;xhash:boolean):string;//ultra-fast int->hex color converter - 22jul2021
var
   c32:tcolor32;
begin
c32.r:=c24.r;
c32.g:=c24.g;
c32.b:=c24.b;
c32.a:=a;
result:=c32__hex8(c32,xhash);
end;

function c32__hex8(c32:tcolor32;xhash:boolean):string;//ultra-fast int->hex color converter - 22jul2021
var
   v,v2:longint;
   c2,c3,c4,c5,c6,c7,c8,c9:char;
begin
//r=2,3
v :=c32.r div 16;
v2:=c32.r-(v*16);
if (v <=9) then c2:=char(48+v ) else c2:=char(55+v );
if (v2<=9) then c3:=char(48+v2) else c3:=char(55+v2);

//g=4,5
v :=c32.g div 16;
v2:=c32.g-(v*16);
if (v <=9) then c4:=char(48+v ) else c4:=char(55+v );
if (v2<=9) then c5:=char(48+v2) else c5:=char(55+v2);

//b=6,7
v :=c32.b div 16;
v2:=c32.b-(v*16);
if (v <=9) then c6:=char(48+v ) else c6:=char(55+v );
if (v2<=9) then c7:=char(48+v2) else c7:=char(55+v2);

//a=8,9
v :=c32.a div 16;
v2:=c32.a-(v*16);
if (v <=9) then c8:=char(48+v ) else c8:=char(55+v );
if (v2<=9) then c9:=char(48+v2) else c9:=char(55+v2);

//get
if xhash then result:='#'+c2+c3+c4+c5+c6+c7+c8+c9 else result:=c2+c3+c4+c5+c6+c7+c8+c9;
end;

function hex8__int(sx:string;xdefa:byte;xdef:longint):longint;//18feb2025: tweaked, 14feb2025: fixed, 03feb2025, 17nov2023, 27feb2021
label
   skipend;
var
   xlen:longint;
   x:string;
   xhavehash:boolean;
   
   function xval(x:byte):longint;
   begin
   case x of
   48..57: result:=x-48;
   65..70: result:=x-55;
   97..102:result:=x-87;
   else    result:=0;
   end;//case
   end;
begin
//check
if (sx='') then
   begin
   result:=xdef;
   exit;
   end;

//init
x         :=strlow(sx);
xlen      :=low__len(x);
xhavehash :=(strcopy1(x,1,1)='#');

//get
if      (x='red')        then result:=rgba__int(255,0,0,xdefa)
else if (x='green')      then result:=rgba__int(0,255,0,xdefa)
else if (x='blue')       then result:=rgba__int(0,0,255,xdefa)
else if (x='black')      then result:=rgba__int(0,0,0,xdefa)
else if (x='white')      then result:=rgba__int(255,255,255,xdefa)
else if (x='yellow')     then result:=rgba__int(255,255,0,xdefa)
else if (x='orange')     then result:=rgba__int(255,128,0,xdefa)
else if (x='none')       then result:=clnone
else if xhavehash and (xlen>=5) and (xlen<7) then//e.g. "#ae93"
   begin
   result:=rgba__int(
    xval(strbyte1(x,2)*17),
    xval(strbyte1(x,3)*17),
    xval(strbyte1(x,4)*17),
    xval(strbyte1(x,5)*17)
   );
   end
else if xhavehash and (xlen>=4) and (xlen<7) then//e.g. "#ae9" - alpha missing
   begin
   result:=rgba__int(
    xval(strbyte1(x,2)*17),
    xval(strbyte1(x,3)*17),
    xval(strbyte1(x,4)*17),
    xdefa
   );
   end
else if xhavehash and (xlen>=9) then//e.g. "#aaee9933"
   begin
   result:=rgba__int(
    (xval(strbyte1(x,2))*16)+xval(strbyte1(x,3)),
    (xval(strbyte1(x,4))*16)+xval(strbyte1(x,5)),
    (xval(strbyte1(x,6))*16)+xval(strbyte1(x,7)),
    (xval(strbyte1(x,8))*16)+xval(strbyte1(x,9))
   );
   end
else if xhavehash and (xlen>=7) then//e.g. "#aaee99" - alpha missing
   begin
   result:=rgba__int(
    (xval(strbyte1(x,2))*16)+xval(strbyte1(x,3)),
    (xval(strbyte1(x,4))*16)+xval(strbyte1(x,5)),
    (xval(strbyte1(x,6))*16)+xval(strbyte1(x,7)),
    xdefa
   );
   end
else if (xlen>=8) then//e.g. "aaee9933"
   begin
   result:=rgba__int(
    (xval(strbyte1(x,1))*16)+xval(strbyte1(x,2)),
    (xval(strbyte1(x,3))*16)+xval(strbyte1(x,4)),
    (xval(strbyte1(x,5))*16)+xval(strbyte1(x,6)),
    (xval(strbyte1(x,7))*16)+xval(strbyte1(x,8))
   );
   end
else if (xlen>=6) then//e.g. "aaee99" - missing alpha
   begin
   result:=rgba__int(
    (xval(strbyte1(x,1))*16)+xval(strbyte1(x,2)),
    (xval(strbyte1(x,3))*16)+xval(strbyte1(x,4)),
    (xval(strbyte1(x,5))*16)+xval(strbyte1(x,6)),
    xdefa
   );
   end
else if (xlen>=4) then//e.g. "ae93"
   begin
   result:=rgba__int(
    xval(strbyte1(x,1)*17),
    xval(strbyte1(x,2)*17),
    xval(strbyte1(x,3)*17),
    xval(strbyte1(x,4)*17)
   );
   end
else if (xlen>=3) then//e.g. "ae9" - alpha missing
   begin
   result:=rgba__int(
    xval(strbyte1(x,1)*17),
    xval(strbyte1(x,2)*17),
    xval(strbyte1(x,3)*17),
    xdefa
   );
   end
else result:=xdef;
end;

function hex8__c24(sx:string;xdef:tcolor24):tcolor24;//18feb2025: fixed
var
   c:tint4;
begin
c.val:=hex8__int(sx,0,c24__int(xdef));

if (c.val=clnone) then result:=xdef
else
   begin
   result.r:=c.r;
   result.g:=c.g;
   result.b:=c.b;
   end;
end;

function hex8__c32(sx:string;xdefa:byte;xdef:tcolor32):tcolor32;//18feb2025: fixed
var
   c:tint4;
begin
c.val:=hex8__int(sx,xdefa,c32__int(xdef));

if (c.val=clnone) then result:=xdef
else
   begin
   result.r:=c.r;
   result.g:=c.g;
   result.b:=c.b;
   result.a:=c.a;
   end;
end;

//.color visibility and checkers -----------------------------------------------
function c24__dif(xcolor24:tcolor24;xchangeby0255:longint):tcolor24;//differential color
begin
result:=int__c24( int__dif24(c24__int(xcolor24) ,xchangeby0255) );
end;

procedure int__soft24(xcolor24:longint;var xoutHint,xoutSoft,xoutSoftRow,xoutSoftHover,xout0,xout1,xout2:longint);
var
   v:longint;
begin
v:=xcolor24;

case c24__lum(int__c24(v)) of
0..30:begin//adjust for very dark background
   //.pair
   xout1:=int__dif242(v,0,false);
   xout2:=int__dif242(v,55,false);
   //.single
   xout0:=xout2;
   //.hint
   xoutHint      :=int__dif242(v,20,false);
   xoutSoft      :=int__dif242(v,35,false);
   xoutSoftRow   :=int__dif242(v,10,false);
   xoutSoftHover :=int__dif242(v,60,false);
   end;
235..255:begin//adjust for very light background
   //.pair
   xout1:=int__dif242(v,-20,false);
   xout2:=int__dif242(v,10,false);
   //.single
   xout0:=xout1;
   //.hint
   xoutHint    :=int__dif242(v,-10,false);
   xoutSoft    :=int__dif242(v,-10,false);
   xoutSoftRow :=int__dif242(v,-5,false);
   xoutSoftHover :=int__dif242(v,-20,false);
   end;
else
   begin//normal operation
   //.pair
   xout1:=int__dif242(v,-15,false);
   xout2:=int__dif242(v,15,false);
   //.single
   xout0:=int__dif242(v,25,false);
   //.hint
   xoutHint    :=int__dif242(v,10,false);
   xoutSoft    :=int__dif242(v,15,false);
   xoutSoftRow :=int__dif242(v,5,false);
   xoutSoftHover :=int__dif242(v,25,false);
   end;
end;//case

end;

function int__dif24(xcolor24,xchangeby0255:longint):longint;//differential color
begin
result:=int__dif242(xcolor24,xchangeby0255,true);
end;

function int__dif242(xcolor24,xchangeby0255:longint;xautoflip:boolean):longint;//differential color
label
   redo;
var
   once:boolean;
   ox,a:tint4;
   by,z:longint;
begin
//xchangeby0255 check
if (xchangeby0255=0) then
   begin
   result:=xcolor24;
   exit;
   end
else
   begin
   once:=true;
   ox.val:=xcolor24;
   end;

//.by
by:=xchangeby0255;
if (by<0) then by:=-by;
by:=by div 2;

//a.val
a.val:=ox.val;

//get
redo:

//.r
z:=(a.r+xchangeby0255);
if (z<0) then z:=0 else if (z>255) then z:=255;
a.r:=z;

//.g
z:=(a.g+xchangeby0255);
if (z<0) then z:=0 else if (z>255) then z:=255;
a.g:=z;

//.b
z:=(a.b+xchangeby0255);
if (z<0) then z:=0 else if (z>255) then z:=255;
a.b:=z;

//check
if xautoflip and once and ( low__nrw(int__brightnessb(a.val),int__brightnessb(ox.val),by) or
              (low__nrw(a.r,ox.r,by) and low__nrw(a.g,ox.g,by) and low__nrw(a.b,ox.b,by)) ) then
   begin
   a.val:=ox.val;
   xchangeby0255:=-xchangeby0255;
   once:=false;
   goto redo;
   end;

//return result
result:=a.val;
end;

function int__vis24(xforeground24,xbackground24,xseparation:longint):boolean;//color is visible
   function v(x,y:byte;by:longint):boolean;
   begin
   //enforce safe range
   if (by<0) then by:=30;
   //get
   result:=(low__posn(x-y)>=by);
   end;
begin
result:=
 v(tint4(xforeground24).r,tint4(xbackground24).r,xseparation) or
 v(tint4(xforeground24).g,tint4(xbackground24).g,xseparation) or
 v(tint4(xforeground24).b,tint4(xbackground24).b,xseparation);
end;

function c24__vis24(xforeground24,xbackground24:tcolor24;xseparation:longint):boolean;//color is visible
   function v(x,y:byte;by:longint):boolean;
   begin
   //enforce safe range
   if (by<0) then by:=30;
   //get
   result:=(low__posn(x-y)>=by);
   end;
begin
result:=
 v(xforeground24.r,xbackground24.r,xseparation) or
 v(xforeground24.g,xbackground24.g,xseparation) or
 v(xforeground24.b,xbackground24.b,xseparation);
end;

function int__makevis24(xforeground24,xbackground24,xseparation:longint):longint;//make color visible (foreground visible on background)
begin
if int__vis24(xforeground24,xbackground24,xseparation) then result:=xforeground24 else result:=int__invert2b(xforeground24,true);
end;

function c24__makevis24(xforeground24,xbackground24:tcolor24;xseparation:longint):tcolor24;//make color visible (foreground visible on background)
begin
if c24__vis24(xforeground24,xbackground24,xseparation) then result:=xforeground24 else result:=int__c24(int__invert2b(c24__int(xforeground24),true));
end;

//.pixel processor procs -------------------------------------------------------
function ppBlend32(var s,snew:tcolor32):boolean;//color / pixel processor - 30nov2023
var//250ms -> 235ms -> 218ms -> 204ms per 10,000,000 calls
   v1,v2,da,daBIG:longint;
begin
//defaults
result:=false;

//decide
if      (snew.a=0)   then exit
else if (snew.a=255) then
   begin
   result:=true;
   s:=snew;
   exit;
   end;

//get
v1:=snew.a*255;
v2:=s.a*(255-snew.a);

da    :=snew.a + (v2 div 255);//must div by 255 exactly, otherwise subtle color loss creeps in damaging the image
daBIG :=v1 + v2;

s.r:=( (snew.r*v1) + (s.r*v2) ) div daBIG;
s.g:=( (snew.g*v1) + (s.g*v2) ) div daBIG;
s.b:=( (snew.b*v1) + (s.b*v2) ) div daBIG;
s.a:=da;

//successful
result:=true;
end;
{
//----------------------------------------------------------------------START---
//reference for ppBlend32 - original floating point algorithms
var//250ms -> 235ms -> 218ms -> 204ms per 10,000,000 calls
   sr,sg,sb,sa,nr,ng,nb,na,dr,dg,db,da:extended;
begin
//defaults
result:=false;
//decide
if (snew.a=0) then exit
else if (snew.a=255) then
   begin
   result:=true;
   s:=snew;
   exit;
   end;
//init
//.n
nr:=snew.r / 255;
ng:=snew.g / 255;
nb:=snew.b / 255;
na:=snew.a / 255;
//.s
sr:=s.r / 255;
sg:=s.g / 255;
sb:=s.b / 255;
sa:=s.a / 255;

da:=na + (sa*(1-na));
dr:=( (nr*na) + (sr*sa*(1-na)) ) / da;
dg:=( (ng*na) + (sg*sa*(1-na)) ) / da;
db:=( (nb*na) + (sb*sa*(1-na)) ) / da;

s.r:=round(dr*255);
s.g:=round(dg*255);
s.b:=round(db*255);
s.a:=round(da*255);
//------------------------------------------------------------------------END---
{}

function ppBlendColor32(var s,snew:tcolor32):boolean;//color blending / pixel processor - 01dec2023
begin
//defaults
result:=false;

//check
if (s.a=0) or (snew.a=0) then exit;

//get
s.r:=( (snew.r*snew.a) + (s.r*(255-snew.a)) ) div 255;
s.g:=( (snew.g*snew.a) + (s.g*(255-snew.a)) ) div 255;
s.b:=( (snew.b*snew.a) + (s.b*(255-snew.a)) ) div 255;

//successful
result:=true;
end;

procedure ppMerge24(var d:tcolor24;snew:tcolor32);//25may2025
begin
d.r:=( (snew.r*snew.a) + (d.r*(255-snew.a)) ) div 255;
d.g:=( (snew.g*snew.a) + (d.g*(255-snew.a)) ) div 255;
d.b:=( (snew.b*snew.a) + (d.b*(255-snew.a)) ) div 255;
end;

procedure ppMerge24FAST(var d:tcolor24;snew:tcolor32);//25may2025
begin
d.r:=( (snew.r*snew.a) + (d.r*(255-snew.a)) ) div 256;
d.g:=( (snew.g*snew.a) + (d.g*(255-snew.a)) ) div 256;
d.b:=( (snew.b*snew.a) + (d.b*(255-snew.a)) ) div 256;
end;


//logic procs ------------------------------------------------------------------
function low__aorbimg(a,b:tbasicimage;xuseb:boolean):tbasicimage;//30nov2023
begin
if xuseb then result:=b else result:=a;
end;


//canvas procs -----------------------------------------------------------------
function wincanvas__setfont(x:hdc;xfontname:string;xsharp,xbold:boolean;xsize,xcolor,xbackcolor:longint;var xoutfont,xoutbrush:hdc):boolean;
var
   h:hdc;
   b:tlogbrush;
   f:tlogfont;
   p:longint;
begin
result:=(x<>0);

if result then
   begin
   //filter
   xcolor    :=int24__rgba0(xcolor);
   xbackcolor:=int24__rgba0(xbackcolor);

   //brush
   b.lbstyle:=0;//solid
   b.lbcolor:=xbackcolor;
   b.lbhatch:=0;
   xoutbrush:=win____CreateBrushIndirect(b);

   //font
   low__cls(@f,sizeof(f));
   if (xsize>=0) then f.lfHeight:=-win____MulDiv(xsize,system_screenlogpixels,72) else f.lfHeight:=-xsize;
   f.lfWidth         :=0;//font mapper chooses
   f.lfEscapement    :=0;//straight fonts
   f.lfOrientation   :=0;//no rotation
   f.lfWeight        :=low__aorb(0,700,xbold);//400=normal, 700=bold
   f.lfItalic        :=0;
   f.lfUnderline     :=0;
   f.lfStrikeOut     :=0;
   f.lfCharSet       :=1;//DEFAULT_CHARSET=1, ANSI_CHARSET=0

   for p:=1 to frcmax32(low__len(xfontname),1+high(f.lfFaceName)) do f.lfFaceName[p-1]:=char(xfontname[p-1+stroffset]);
//   StrPCopy(f.lfFaceName,xfontname);

   f.lfQuality       :=low__aorb(4,NONANTIALIASED_QUALITY,xsharp);
   f.lfOutPrecision  :=0;//OUT_DEFAULT_PRECIS=0
   f.lfClipPrecision :=0;//CLIP_DEFAULT_PRECIS=0
   f.lfPitchAndFamily:=0;//DEFAULT_PITCH=0

   xoutfont:=win____CreateFontIndirect(f);

   //.delete previous references
   h:=win____selectobject(x,xoutbrush);
   if (h<>xoutbrush) then win____deleteobject(xoutbrush);

   h:=win____selectobject(x,xoutfont);
   if (h<>xoutfont) then win____deleteobject(h);

   //colors
   win____SetBkMode(x,2);//transparent=1, OPAQUE=2
   win____SetBkColor(x,xbackcolor);
   win____SetTextColor(x,xcolor);
   end;
end;


function wincanvas__textwidth(x:hdc;const xval:string):longint;
begin
result:=wincanvas__textextent(x,xval).x;
end;

function wincanvas__textheight(x:hdc;const xval:string):longint;
begin
result:=wincanvas__textextent(x,xval).y;
end;

function wincanvas__textout(x:hdc;xtransparent:boolean;dx,dy:longint;const xval:string):boolean;
begin
result:=(x<>0);
if result then win____TextOut(x,dx,dy,pchar(xval),low__len(xval));
end;

function wincanvas__textextent(x:hdc;const xval:string):tpoint;
begin
//defaults
result.x:=0;
result.y:=0;
//get
if (x<>0) then win____GetTextExtentPoint(x,pchar(xval),low__len(xval),result);
end;

function wincanvas__textrect(x:hdc;xtransparent:boolean;xarea:twinrect;dx,dy:longint;const xval:string):boolean;
var
   xoptions:longint;
begin
result:=(x<>0);
xoptions:=ETO_CLIPPED;
if not xtransparent then inc(xoptions,ETO_OPAQUE);
if result then win____ExtTextOut(x,dx,dy,xoptions,@xarea,pchar(xval),low__len(xval),nil);
end;


//canvas procs - end -----------------------------------------------------------
procedure low__scaledown(maxw,maxh,sw,sh:longint;var dw,dh:longint);//20feb2025: tweaked, 29jul2016
begin
try
//range
sw:=frcmin32(sw,1);
sh:=frcmin32(sh,1);
dw:=sw;
dh:=sh;

//get
if (sw>maxw) then
   begin
   sh:=frcmin32(round(sh*(maxw/sw)),1);//29jul2016
   sw:=maxw;
   end;

if (sh>maxh) then
   begin
   sw:=frcmin32(round(sw*(maxh/sh)),1);//29jul2016
   sh:=maxh;
   end;

//set
dw:=frcmin32(sw,1);
dh:=frcmin32(sh,1);
except;end;
end;

procedure low__scale(maxw,maxh,sw,sh:integer;var dw,dh:integer);//20feb2025: tweaked
var
   r1,r2:extended;
begin
try
//range
sw:=frcmin32(sw,1);
sh:=frcmin32(sh,1);
dw:=sw;
dh:=sh;

//get
r1:=maxw/sw;
if (r1<=0) then r1:=1;
r2:=maxh/sh;
if (r2<=0) then r2:=1;
if (r2<r1) then r1:=r2;

//set
dw:=frcmin32(round(sw*r1),1);
dh:=frcmin32(round(sh*r1),1);
except;end;
end;

procedure low__scalecrop(maxw,maxh,sw,sh:integer;var dw,dh:integer);//20feb2025: fixed
var
   wratio,hratio:double;
begin
try
sw   :=frcmin32(sw,1);
sh   :=frcmin32(sh,1);
maxw :=frcmin32(maxw,1);
maxh :=frcmin32(maxh,1);

wratio:=maxw/sw;
hratio:=maxh/sh;

if (hratio>wratio) then wratio:=hratio;

dw:=frcmin32(round(wratio*sw),1);
dh:=frcmin32(round(wratio*sh),1);
except;end;
end;

end.

