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
uses gossroot, gossimg, gosswin;
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
//## Library.................. FastDraw - rapid render graphic procs (gossfast.pas)
//## Version.................. 4.00.5775 (+128)
//## Items.................... 9
//## Last Updated ............ 10apr2026, 07apr2026, 04apr2026, 01apr2026, 29mar2026, 27mar2026, 21mar2026, 19mar2026, 15mar2026, 10mar2026, 06mar2026, 03mar2026, 01mar2026, 28feb2026, 27feb2026, 23feb2026, 20feb2026, 01feb2026, 07jan2026, 05jan2025, 01jan2026, 29dec2025, 26dec2025, 25dec2025, 24dec2025, 22dec2025, 19dec2025
//## Lines of Code............ 35,700+
//## Origin .................. Human generated and maintained
//##
//## main.pas ................ App specific code
//## gossdat.pas ............. App specific icons and help documents
//## gossfast.pas ............ FastDraw - rapid render graphic procs
//## gossgame.pas ............ GameCore - 2D game engine with integrated menu handler, xbox controller + mouse + keyboard support and window integration
//## gamefiles.pas ........... Built-in file(s) for GameCore (optional)
//## gossgui.pas ............. GUI management and controls
//## gossimg.pas ............. Multi-format graphic procs for 8, 24 and 32 bit images with IO support
//## gossio.pas .............. File IO and low level file/folder/disk/data format procs
//## gossjpg.pas ............. JPEG IO (read/write jpeg image data via third party libraries)
//## gossnet.pas ............. Networking - ip filtering, socket management etc
//## gossroot.pas ............ App startup and control (GUI, console and service)
//## gosssnd.pas ............. Sound, audio, midi and midi based chimes
//## gossteps.pas ............ System, Folder and App images
//## gosstext.pas ............ TextCore - non-GUI and GUI text engine for text boxes
//## gosswin.pas ............. Win32 api calls for 32 and 64 bit (static / api references disabled by default)
//## gosswin2.pas ............ Win32 api calls for 32 and 64 bit (dynamic - load as required with fallback failure handling and default value(s) support)
//## gosszip.pas ............. ZIP IO (read/write zip data via third party libraries)
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | ling__*                | family of procs   | 1.00.306  | 29mar2026   | Little image proc -> supports images up to 12x12 @ 32bit - 29mar2026, 24dec2025, 22dec2025
//## | font__*                | family of procs   | 1.00.021  | 10mar2026   | Font support procs - 03mar2026
//## | res__*                 | family of procs   | 1.00.170  | 22dec2025   | Manage system resources -> fonts, fontchars, teps etc - 19dec2025
//## | rescache__*            | family of procs   | 1.00.080  | 03apr2026   | Cache commonly used/reused objects for high-speed use - 27feb2026, 22dec2025
//## | fd__*/fast__*          | family of procs   | 1.00.3675 | 09apr2026   | FastDraw high-speed graphic procs for 32 and 24 bit image operations - 04apr2026, 01apr2026, 29mar2026, 21mar2026, 19mar2026, 15mar2026, 06mar2026, 03mar2026, 28feb2026, 23feb2026, 20feb2026, 01feb2026, 07jan2026, 05jan2026, 01jan2026, 29dec2025, 26dec2025, 25dec2025, 24dec2025, 22dec2025
//## | tresfont               | tobject           | 1.00.812  | 09apr2026   | Dynamic font handler -> create font characters as compressed RLE8's on-the-fly when needed - 27feb2026, 01mar2026, 22dec2025, 19dec2025
//## | tbasicrle6             | tobject           | 1.00.355  | 09apr2026   | 4-shade(51 ), 4-feather(10), 6bit, system image + realtime system feather for use as font character and 4-color-shade image - 19mar2026, 06mar2026, 05mar2026
//## | tbasicrle8             | tobject           | 1.00.160  | 09apr2026   | 1-shade( 245 = 11..255 ), 1-feather( 10 = 1..10 ), 8bit, system image + realtime system feather for use as font character and 1-color-shade image - 07apr2026, 19mar2026, 06mar2026, 05mar2026, 25feb2026
//## | tbasicrle32            | tobject           | 1.00.066  | 09apr2026   | Plain RGBA 32bit color image with realtime feather (no special/system channels other than system feather)- 21mar2026, 06mar2026, 05mar2026
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


const

   //RLE6 values ---------------------------------------------------------------

   //note: RLE6 image can store 10 feather and 51 color shades across 4 separate channels (one channel in use at a time)
   rle6_channelCount            =4;
   rle6_tshadesPerChannel       =62;
   rle6_fshadesPerChannel       =10;//1..10
   rle6_ishadesPerChannel       =51;//1..51
   rle6_colorDivider            =5;//255 div 5 = 0..51

   rle6_featherFullShade        =765;// 3*255 = rle6_fshadesPerChannel = 10
   rle6_featherPartShade        =765 div rle6_fshadesPerChannel;//102
   rle6_minishadeval            =5;
   rle6_featherPower            =15;//system feather power calibration

   rle6_channel_root0           =1;//1
   rle6_channel_root1           =rle6_channel_root0 + rle6_tshadesPerChannel;//63..N
   rle6_channel_root2           =rle6_channel_root1 + rle6_tshadesPerChannel;//125..N
   rle6_channel_root3           =rle6_channel_root2 + rle6_tshadesPerChannel;//187..N

   rle6_channel_istart0         =rle6_channel_root0 + rle6_fshadesPerChannel + 1;//12..N
   rle6_channel_istart1         =rle6_channel_root1 + rle6_fshadesPerChannel + 1;//74..N
   rle6_channel_istart2         =rle6_channel_root2 + rle6_fshadesPerChannel + 1;//136..N
   rle6_channel_istart3         =rle6_channel_root3 + rle6_fshadesPerChannel + 1;//198..N

   rle6_channel0                =0;
   rle6_channel1                =1;
   rle6_channel2                =2;
   rle6_channel3                =3;


   //RLE8 values ---------------------------------------------------------------

   rle8_featherCount            =10;//1..10
   rle8_featherPeak             =1020;
   rle8_featherDivider          =102;
   rle8_featherPower            =15;//system feather power calibration


   //RLE32 values --------------------------------------------------------------

   rle32_featherPower           =15;//system feather power calibration


   //FastDraw codes ------------------------------------------------------------

   fd_nil                       =0;

   //.bol or val -> fd__bol(), fd__setbol(), fd__val(), fd__setval() and fd__set()
   fd_flip                      =1;
   fd_noflip                    =2;
   fd_nomirror                  =3;
   fd_mirror                    =4;
   fd_optimise                  =5;//turn optimisations on
   fd_nooptimise                =6;//turn optimisations off
   fd_power                     =7;
   fd_splice                    =8;
   fd_feather                   =9;

   fd_errors                    =10;//turn error reporting on
   fd_noerrors                  =11;//turn it off


   //.val -> fd__val() and fd__setval()
   fd_drawProc                  =20;
   fd_AreaMode                  =21;
   fd_ClipMode                  =22;
   fd_AreaMode2                 =23;
   fd_ClipMode2                 =24;

   fd_color1                    =25;
   fd_color2                    =26;
   fd_color3                    =27;
   fd_color4                    =28;

   fd_textColor                 =fd_color1;//text color
   fd_backColor                 =fd_color2;//text background color
   fd_highColor                 =fd_color3;//highlight color

   fd_layer                     =29;

   fd_font                      =30;
   fd_charDecoration            =31;

   fd_pixelcount                =32;//64bit

   //.area -> fd__area(), fd__setarea(), fd__area2(), fd__setarea2() and "fd__moveto()/fd__movetoX()/fd__movetoY()"*
   fd_area                      =40;//*
   fd_clip                      =41;
   fd_bufferarea                =42;
   fd_area2                     =43;//*
   fd_clip2                     =44;
   fd_bufferarea2               =45;
   fd_area12                    =46;//* set both target and source buffer draw area
   fd_clip12                    =47;//set both target and source buffer clip region

   //.fd__setCorner() and fd__set()
   fd_roundNone                 =60;//disable round support
   fd_roundCorner               =61;//turn on round support with standard corners
   fd_roundCornerTight          =62;//turn on round support with tight corners

   fd_roundmodeAll              =63;//all corners are round
   fd_roundmodeTopOnly          =64;//top corners are round and bottom corners are square
   fd_roundmodeBotOnly          =65;//top corners are square and bottom corners are round
   fd_roundmodeNone             =66;//all corners are square (round mode off)

   //.set -> fd__set()
   fd_storeClip                 =67;
   fd_restoreClip               =68;
   fd_storeClip2                =69;
   fd_restoreClip2              =70;
   fd_storeArea                 =71;
   fd_restoreArea               =72;
   fd_storeArea2                =73;
   fd_restoreArea2              =74;
   fd_swapArea12                =75;

   fd_trimAreaToFitBuffer       =76;
   fd_trimAreaToFitBuffer2      =77;

   fd_fillAreaDefaults          =78;

   fd_val1                      =79;
   fd_val2                      =80;
   fd_val3                      =81;

   fd_sparkle_val1              =fd_val1;

   //.buffer -> fd__setbufer()
   fd_buffer                    =90;//set target buffer and info
   fd_buffer2                   =91;//set source buffer and info
   fd_buffer12                  =92;//set both buffers as same
   fd_bufferFromBuffer2         =93;//copy buffer2 info to buffer info
   fd_buffer2FromBuffer         =94;//copy buffer info to buffer2 info

   //.render -> fd__render()
   fd_roundStartFromArea        =100;//capture round corners from area
   fd_roundStartFromAreaDebug   =101;//capture round corners from area with a color for visible debug
   fd_roundStartFromClip        =102;//capture round corners from clip
   fd_roundStopAndRender        =103;//draw captured round corners
   fd_roundStopAndRenderDebug   =104;//draw captured round corners with a color for visible debug

   fd_fillArea                  =105;//draw rectangle
   fd_fillSmallArea             =106;//optimised for areas 30x30 or less
   fd_sketchArea                =107;//draw edge portions of rectangle (fast rect draw for base controls)
   fd_shadeArea                 =108;
   fd_drawRGB                   =109;//draw image pixels "b2 -> b"
   fd_drawRGBA                  =110;//15mar2026

   fd_invertArea                =111;//draw color-inverted rectangle
   fd_invertCorrectedArea       =112;//draw color-corrected-inverted rectangle (inverse on grey renders visible pixels instead of invisible pixels as with traditional invert)
   fd_dashedArea                =113;
   fd_drawRLE6                  =114;//06mar2026
   fd_drawRLE8                  =115;//05mar2026
   fd_drawRLE32                 =116;//05mar2026

   fd_outlineArea               =117;//26mar2026
   fd_frameArea                 =118;//28mar2026
   fd_frameSimpleArea           =119;//29mar2026

   fd_colorMatrix               =120;//29mar2026
   fd_shadeOutlineArea          =121;//29mar2026

   //information values
   fd_area_outside_clip         =1000;
   fd_area_inside_clip          =1001;
   fd_area_overlaps_clip        =1002;

   //error codes
   fd_propertyMismatch          =1100;
   fd_selectUsedInvalidSlot     =1101;

   //internal type codes
   t_nil                        =0;
   t_img                        =1;
   t_rle6                       =2;
   t_rle8                       =3;
   t_rle32                      =4;

   //sparkle
   fd_sparkleLimit              =20;//0=off, 10=mild, 20=full strength
   fd_sparkleListSize           =40000;//40,000 slots
   fd_sparkleStopPos            =fd_sparkleListSize-1;//point at which "pos" must be randomly reset

   //frame
   fd_frameLimit                =72 * 16;//16 allows for zoom on larger screens, base resolution is 2K


   //---------------------------------------------------------------------------


   //range values
   fdr_pixelcount32_limit    =100000000;//100 mil

   {$ifdef d3}
   fdr_pixelcount64_limit    =1000000000000000.0;//1,000 trillion
   {$else}
   fdr_pixelcount64_limit    =1000000000000000;//1,000 trillion
   {$endif}

   //little image limits - 23dec2025
   ling_width             =12;
   ling_height            =12;

   //init code
   init_notset            =0;
   init_ok                =1234;
   init_err               =9;

   //resource types
   rest_none              =0;
   rest_font              =1;
   rest_fastdraw          =2;
   rest_str8              =3;
   rest_tep               =4;
   rest_maxtype           =4;

   //slot range
   res_limit              =10000;//10,000 slots
   res_max                =res_limit-1;
   res_nil                =0;//first slot is reserved for "nil" status

   //font
   fontchar_maxindex      =255;//0..255
   font_name1             ='$fontname';
   font_name2             ='$fontname2';


   //.char decoration styles
   cdNone                 =0;
   cdUnderline            =1;
   cdStrikeout            =2;
   cdHighlight            =4;
   cdSpell                =8;
   cdBackground           =16;
   cdUrl                  =32;

   //round modes (corner modes) - 27feb2026
   rmNil                  =-1;
   rmAll                  =0;
   rmTopOnly              =1;//only top corners (top-left and top-right)
   rmBotOnly              =2;//only bottom corners (bottom-left and bottom-right)
   rmNone                 =3;
   rmMax                  =3;

   //fastdraw
   area_outside           =0;
   area_inside            =1;
   area_overlaps          =2;


type

   tresslot               =longint32;//24dec2025
   tresfont               =class;
   tbasicrle6             =class;
   tbasicrle8             =class;
   tbasicrle32            =class;


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
    pixels      :array[0..(ling_height-1)] of tlingrow;
    ref32       :tcolor32;

    //optional -> pointers to support images that relate to this image itself - 28mar2026
    trace       :pling;//for outline tracing of inner and outer corners for frames/outline

    end;


   //fastdraw ------------------------------------------------------------------

   tfastsparkle=packed record//fast random sparkle list

     once         :array[0..(fd_sparkleListSize-1)] of byte;
     val          :array[0..(fd_sparkleListSize-1)] of byte;
     pos          :word;
     level        :longint32;
     id           :longint32;//increments each time sparkle list is updated via "visparkle"

     end;

   tfastframe=packed record

     //fame info
     size         :longint32;
     sparkle20    :longint32;
     color        :array[0..(fd_frameLimit-1)] of tcolor32;

     //ref info
     lname        :longint32;
     ldata        :longint32;
     lcolor1      :longint32;
     lcolor2      :longint32;

     end;

   tfastdrawrendermps=packed record

     time1000     :longint64;
     lastmps64    :longint64;
     rendermps    :double;

     end;

   tfastdrawrenderfps=packed record

     time1000     :longint64;
     lastfps32    :longint32;
     renderfps    :double;

     end;

   pfastdrawbuffer=^tfastdrawbuffer;
   tfastdrawbuffer=packed record

     ok           :boolean;//true=buffer is OK to use, false=not setup -> can't use buffer -> error
     bits         :longint32;
     rows         :pcolorrows32;//supports 24 and 32 bit image matrixes
     t            :byte;//type = t_img, t_rle6, t_rle8 and t_rle32
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
    b                 :tfastdrawbuffer;//buffer 1
    b2                :tfastdrawbuffer;//buffer 2
    t                 :tfastdrawbuffer;//temp buffer 1
    t2                :tfastdrawbuffer;//temp buffer 2

    //gui layer support
    lr8                :pcolorrows8;//nil=off
    lv8                :longint32;

    //colors
    color1             :tcolor32;
    color2             :tcolor32;
    color3             :tcolor32;
    color4             :tcolor32;

    //values - general purpose
    val1               :longint32;
    val2               :longint32;
    val3               :longint32;

    //round support
    rindex             :longint32;//default=-1
    rmode              :longint32;//roundMode=rmAll=0 (all corners)
    rimage             :pling;//always points to a valid image handle (image maybe empty, e.g. w=0, h=0)
    rlist              :array[0..39] of tfastdrawround;

    //misc
    flip               :boolean;
    mirror             :boolean;
    power255           :longint32;
    splice100          :longint32;
    font               :tresslot;
    charDecoration     :longint32;//cdNone..cdMax
    frame              :tfastframe;
    write_a            :boolean;//write alpha channel values for procs that support it, such as "fd_drawrle8"
    feather4           :longint32;//09apr2026

    //tracking
    drawProc           :longint32;//track which draw proc was used for the requested draw action

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

   trescache_img8=record

    use:array[0..999] of boolean;
    obj:array[0..999] of tbasicimage;

    end;

   trescache_fastdraw=record//31dec2025

    use:array[0..99] of boolean;
    obj:array[0..99] of tfastdrawobj;

    end;

   trescache_mapped=record//02apr2026

    id :array[0..199] of longint32;
    dw :array[0..199] of longint32;
    sw :array[0..199] of longint32;
    sx1:array[0..199] of longint32;
    sx2:array[0..199] of longint32;
    use:array[0..199] of boolean;
    obj:array[0..199] of tdynamicinteger;

    end;

{tresfontinfo}
    presfontinfo=^tresfontinfo;
    tresfontinfo=record

     name      :string;
     size      :longint32;
     grey      :boolean;
     bold      :boolean;
     italic    :boolean;

     height   :longint32;
     height1  :longint32;

     wmin     :longint32;
     wmax     :longint32;
     wave     :longint32;

     wlist    :array[0..fontchar_maxindex] of longint32;//width of each character
     rlist    :array[0..fontchar_maxindex] of longint32;//width of each character WIHTOUT any adjustments, such as italic scaling - 26feb2027
     clist    :array[0..fontchar_maxindex] of tbasicrle8;//rle8 for each character
     mlist    :array[0..fontchar_maxindex] of boolean;//true=font char has been scanned and made into a RLE8, false=font char not scanned yet

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

    //fallback handlers -> dynamically created when required - 01jan2026
    fstr8         :tstr8;
    ffont         :tresfont;
    ffastdraw     :tfastdrawobj;

    end;


{tresfont}
//11111111111111111111111
    tresfont=class(tobject)
    private

     iname            :string;//real name
     isize            :longint32;//real size
     irotate          :longint32;
     igrey            :boolean;
     ibold            :boolean;
     iitalic          :boolean;
     iheight          :longint32;
     iheight1         :longint32;
     iwmin            :longint32;
     iwmax            :longint32;
     iwave            :longint32;
     icharCount       :longint32;//number of char slots in use
     ibytes           :longint64;
     ifallback        :tbasicrle8;

     procedure xitalicWidth(var xwidth:longint;const xheight:longint);
     procedure xsyncScanImg;
     procedure xscanChar(const xindex:longint);

    public

     //fast access -> read only -> do not write to these slots
     wlist                               :array[0..fontchar_maxindex] of longint32;
     rlist                               :array[0..fontchar_maxindex] of longint32;
     clist                               :array[0..fontchar_maxindex] of tbasicrle8;
     mlist                               :array[0..fontchar_maxindex] of boolean;

     //create
     constructor create; virtual;
     destructor destroy; override;

     //information
     property name                       :string            read iname;
     property size                       :longint32         read isize;
     property rotate                     :longint32         read irotate;//not implemented
     property grey                       :boolean           read igrey;
     property bold                       :boolean           read ibold;
     property italic                     :boolean           read iitalic;

     property height                     :longint32         read iheight;
     property height1                    :longint32         read iheight1;
     property wmin                       :longint32         read iwmin;
     property wmax                       :longint32         read iwmax;
     property wave                       :longint32         read iwave;

     property charCount                  :longint32         read icharCount;
     property bytes                      :longint64         read ibytes;

     function setparams(const xname:string;const xsize:longint32;const xgrey,xbold,xitalic:boolean):boolean;
     function setparams2(const xname:string;const xsize,xrotate:longint32;const xgrey,xbold,xitalic:boolean):boolean;//09apr2026, 29mar2026

     //clear
     procedure clear;

     //workers
     function needChar(const xindex:longint32):tbasicrle8;
     procedure needChars(const x:string);
     procedure needcharRange(const xcharindex_from,xcharindex_to:longint32);

     function textwidth(const xtab,x:string):longint32;
     function textwidth2(const xtab:string;const x:tstr8):longint32;

     //support
     procedure slowtimer;

    end;


{tbasicrle6}
   tbasicrle6=class(tobject)
   private

    ibits,iwidth,iheight,iheight1,iheadLen:longint;
    icore:tstr8;

    procedure xfast__makefromR32(const s:tobject;sarea:twinrect;const dChannel03:longint;const xinvert,xscanForHeight1:boolean);
    procedure xfast__makefromR24(const s:tobject;sarea:twinrect;const dChannel03:longint;const xinvert,xscanForHeight1:boolean);
    procedure xfast__makefromR8 (const s:tobject;sarea:twinrect;const dChannel03:longint;const xinvert,xscanForHeight1:boolean);

    procedure xslow__detectInfo(const r,g,b:byte;var droot,dv:byte);//06mar2026
    procedure xslow__makefrom32(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
    procedure xslow__makefrom8(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
    procedure xslow__makefrom24(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);

   public

    //create
    constructor create; virtual;
    destructor destroy; override;

    //information
    property bits     :longint                      read ibits;
    property headLen  :longint                      read iheadLen;
    property width    :longint                      read iwidth;
    property height   :longint                      read iheight;
    property height1  :longint                      read iheight1;
    property core     :tstr8                        read icore;

    //clear
    procedure clear;

    //io
    function fromdata(s:pobject):boolean;
    function fromarray(const s:array of byte):boolean;

    function cancopytoimage:boolean;
    function copytoimage(d:tobject;const dcol1,dcol2,dcol3,dcol4:longint):boolean;
    function copytoimage2(d:tobject;const dcol1,dcol2,dcol3,dcol4,dfeather4:longint):boolean;

    // create single channel (ch0) image from red-values only
    procedure fast__makefromR(const s:tobject);
    procedure fast__makefromR2(const s:tobject;sarea:twinrect;const dChannel03:longint;const xinvert,xscanForHeight1:boolean);

    // create 4 channel (ch0..ch3) image from luminosity=ch0, red=ch1, green=ch2
    // and blue=ch3 values, with highest value determining which channel is used
    // for each pixel
    procedure slow__makefromLRGB(const s:tobject);
    procedure slow__makefromLRGB2(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);

   end;


{tbasicrle8}
   tbasicrle8=class(tobject)
   private

    ibits,iwidth,iheight,iheight1,iheadLen:longint;
    icore:tstr8;

    procedure xfast__makefromR32(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
    procedure xfast__makefromR24(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
    procedure xfast__makefromR8 (const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);

    procedure xslow__makefromLUM32(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
    procedure xslow__makefromLUM24(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
    procedure xslow__makefromLUM8(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);

   public

    //create
    constructor create; virtual;
    destructor destroy; override;

    //information
    property bits     :longint                      read ibits;
    property headLen  :longint                      read iheadLen;
    property width    :longint                      read iwidth;
    property height   :longint                      read iheight;
    property height1  :longint                      read iheight1;
    property core     :tstr8                        read icore;

    //clear
    procedure clear;

    //io
    function fromdata(s:pobject):boolean;
    function fromarray(const s:array of byte):boolean;

    function cancopytoimage:boolean;
    function copytoimage(d:tobject;const dcol:longint):boolean;
    function copytoimage2(d:tobject;const dcol,dfeather4:longint):boolean;//07apr2026

    // create single channel image with system feather from "s" using only red values
    procedure fast__makefromR(const s:tobject);
    procedure fast__makefromR2(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);

    // create single channel image with system feather from "s" using luminosity values
    procedure slow__makefromLUM(const s:tobject);
    procedure slow__makefromLUM2(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);

   end;


{tbasicrle32}
   tbasicrle32=class(tobject)
   private

    ibits,iwidth,iheight,iheight1,iheadLen:longint;
    icore:tstr8;

    procedure xrgba__makefrom32(const s:tobject;sarea:twinrect;const xscanForHeight1:boolean);//20mar2026
    procedure xrgba__makefrom24(const s:tobject;sarea:twinrect;const xscanForHeight1:boolean);//20mar2026
    procedure xrgba__makefrom8 (const s:tobject;sarea:twinrect;const xscanForHeight1:boolean);//20mar2026

   public

    //create
    constructor create; virtual;
    destructor destroy; override;

    //information
    property bits     :longint                      read ibits;
    property headLen  :longint                      read iheadLen;
    property width    :longint                      read iwidth;
    property height   :longint                      read iheight;
    property height1  :longint                      read iheight1;
    property core     :tstr8                        read icore;

    //io
    function fromdata(s:pobject):boolean;
    function fromarray(const s:array of byte):boolean;

    function cancopytoimage:boolean;
    function copytoimage(d:tobject):boolean;
    function copytoimage2(d:tobject;const dfeather4:longint):boolean;

    //clear
    procedure clear;

    // create image
    procedure rgba__makefrom(const s:tobject);
    procedure rgba__makefrom2(const s:tobject;sarea:twinrect;const xscanForHeight1:boolean);

   end;


var
   system_started_fast       :boolean=false;
   system_rescore            :trescore;
   system_fontnameDef0       :string='';//other font names -> root default font name
   system_fontnameDef1       :string='';//viFontname
   system_fontnameDef2       :string='';//viFontname2
   system_fontScanImage      :twinbmp=nil;
   system_fontScanImageREF   :longint64=0;//resize timeout

   rescache_font             :trescache_font;
   rescache_str8             :trescache_str8;
   rescache_img8             :trescache_img8;
   rescache_fastdraw         :trescache_fastdraw;
   rescache_mapped           :trescache_mapped;

   //.ling - system little images
   resling_nil               :tling;

   resling_corner            :tling;
   resling_corner_trace      :tling;

   resling_corner200         :tling;
   resling_corner200_trace   :tling;

   resling_cornerTight       :tling;

   resling_cls               :tling;
   resling_cls2              :tling;

   //.time sample support
   ressample_core            :ttimesamplecore;

   //.fastdraw support
   fd_focus                  :pfastdraw;//assumed to always point to a valid record, e.g. never nil - 31dec2025
   fd_sparkle                :tfastsparkle;//shared sparkle list - 26mar2026
   
   sysfd_optimise_ok         :boolean=true;
   sysfd_errors_ok           :boolean=false;
   sysfd_errors_count        :longint32=0;
   sysfd_track_ok            :boolean=true;
   sysfd_pixelcount32        :longint32=0;
   sysfd_pixelcount64        :longint64=0;
   sysfd_drawProc32          :longint32=0;
   sysfd_rendermps           :tfastdrawrendermps;
   sysfd_renderfps           :tfastdrawrenderfps;
   sysfd_framecount32        :longint32=0;

   rescol_white32            :tcolor32;
   rescol_black32            :tcolor32;

   //.system font slots -> used and maintained by GUI system (gossgui.pas)
   resfont_ft            :tresslot=0;//title -> currently same as bold below "resfont_fb"
   resfont_ft2           :tresslot=0;//title2 -> larger and bold
   resfont_fn            :tresslot=0;//normal
   resfont_fb            :tresslot=0;//bold
   resfont_fs            :tresslot=0;//small and normal
   resfont_fsb           :tresslot=0;//small and bold
   resfont_fs2           :tresslot=0;//smaller and normal

//start-stop procs -------------------------------------------------------------

procedure gossfast__start;
procedure gossfast__stop;


//info procs -------------------------------------------------------------------

function app__info(xname:string):string;
function info__fast(xname:string):string;//information specific to this unit of code - 01feb2026


//support procs ----------------------------------------------------------------
function find__viScale:double;//27feb2026
function find__viFeather:longint;//27feb2026
function rateTable__row(xtimeTakenMS:longint64;const xtotalPixels,xsizeW,xsizeH,xframebufferW,xframebufferH,xframebufferBits:longint;const xflip,xmirror:boolean;xoptions:string):string;


//rescache procs ---------------------------------------------------------------

function rescache__newFont:tresfont;
function rescache__delFont(x:pobject):boolean;

function rescache__newStr8:tstr8;
function rescache__delStr8(x:pobject):boolean;

function rescache__newImg8:tbasicimage;//19feb2026
function rescache__delImg8(x:pobject):boolean;//19feb2026

function rescache__newFastdraw:tfastdrawobj;
function rescache__delFastdraw(x:pobject):boolean;

function rescache__newMapped(const xid,dW,sx1,sx2,sW:longint32):tdynamicinteger;//02apr2026
function rescache__delMapped(x:pobject):boolean;


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
function res__newfont2(const xname:string;const xsize:longint;const xgrey,xbold,xitalic:boolean):tresslot;

function res__newFastdraw:tresslot;//07par2026
function res__newFD:tresslot;//07par2026

//.del
function res__del(const xslot:longint):tresslot;

//.checkers
function res__type(const xslot:tresslot):longint;
function res__ok(const xslot:tresslot):boolean;
function res__IDok(const xslot:tresslot;const xid:longint):boolean;
function res__typeok(const xslot:tresslot;const xid,xtype:longint):boolean;
function res__dataok(const xslot:tresslot;const xtype:longint):boolean;//22dec2025

//.typed replies
function res__str8(const xslot:tresslot):tstr8;

function res__font(const xslot:tresslot):tresfont;
procedure res__needchars(const xslot:tresslot;const x:string);
procedure res__needcharRange(const xslot:tresslot;const xcharindex_from,xcharindex_to:longint);
function res__textwidth(const xslot:tresslot;const xtab,x:string):longint;
function res__textwidth2(const xslot:tresslot;const xtab:string;const x:tstr8):longint;
function res__fastdraw(const xslot:tresslot):tfastdrawobj;



//font support procs -----------------------------------------------------------

function font__lineThickness(const xfontheight:longint):longint;
function font__lineThickness2(const xfontheight:longint;const xscale:double):longint;//03mar2026
function font__lineEmbossShift(const xfontheight:longint):longint;//03mar2026

function font__name1:string;
function font__name2:string;
function font__realname0(const xname,xviFontname,xviFontname2:string):string;//28feb2026
function font__realname(const xname:string):string;//28feb2026

function font__defaultname0:string;
function font__defaultname1:string;
function font__defaultname2:string;
function font__defaultname(const xindex:longint):string;

function font__realsize(const xsize:longint):longint;
procedure font__clearinfo(var x:tresfontinfo);
procedure font__copyinfo(const s:tresfontinfo;const xfull:boolean;var d:tresfontinfo);
function font__tab(const xtab:string;xcolindex,xfontheight,xwidthlimit:longint;var xcolalign,xcolcount,xcolwidth,xtotalwidth,x1,x2:longint):boolean;//23feb2021
function fontchar__maxindex:longint;

function font__textwidth(const xtab,xtext:string;const xfont:tresslot):longint;//10mar2026

function resfont__textwidth(const xfont:tresslot;const xtext:string):longint;//20feb2026
function resfont__textwidthTAB(const xtab:string;const xfont:tresslot;const xtext:string):longint;//20feb2026

function resfont__wave(const xfont:tresslot):longint;
function resfont__wmin(const xfont:tresslot):longint;
function resfont__wmax(const xfont:tresslot):longint;

function resfont__height(const xfont:tresslot):longint;
function resfont__height1(const xfont:tresslot):longint;


//ling procs (little image) ----------------------------------------------------

procedure ling__size(var s:tling;const dw,dh:longint);
procedure ling__cls(var s:tling);//fast - 23dec2025
procedure ling__cls2(var s:tling;const r,g,b,a:byte);//24dec2025
procedure ling__clsSlow(var s:tling;const r,g,b,a:byte);//24dec2025

function ling__flip_mirror(var s:tling;const xflip,xmirror:boolean):boolean;
function ling__makeFromPattern(var s:tling;const r,g,b:byte;const spattern:string):boolean;//23dec2025
function ling__makeCornerEraser(var s,d:tling):boolean;//28mar2026

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


//fastdraw - high level procs --------------------------------------------------

procedure fast__sketchArea(const dclip,darea:twinrect;const dcol,dcornerCode:longint);

procedure fast__colorMatrix(const dclip,darea:twinrect;const dcornerCode,dcornerMode:longint;const dround:boolean);//29mar2026

procedure fast__frameSimpleArea(const dclip,darea:twinrect;const dsize,dcol,dpower255,dcornerCode,dcornerMode:longint;const dsparkle,dround:boolean);//28mar2026
procedure fast__frameArea(const dclip,darea:twinrect;const dframeCode:tstr8;const dsize,dcol1,dcol2,dpower255,dcornerCode,dcornerMode:longint;const dsparkle,dround:boolean);//28mar2026

procedure fast__outlineArea(const dclip,darea:twinrect;const dcol,dpower255:longint);//26mar2026
procedure fast__outlineArea2(const dclip,darea:twinrect;const dcol,dpower255,dcornerCode,dcornerMode:longint;const dsparkle,dround:boolean);//26mar2026

procedure fast__shadeOutlineArea(const dclip,darea:twinrect;const dcol1,dcol2,dcol3,dcol4,dsplice100,dpower255,dcornerCode,dcornerMode:longint;const dsparkle,dround:boolean);//29mar2026

procedure fast__fillArea(const dclip,darea:twinrect;const dcol:longint);
procedure fast__fillArea2(const dclip,darea:twinrect;const dcol,dcornerCode,dcornerMode:longint;const dround:boolean);
procedure fast__fillArea3(const dclip,darea:twinrect;const dcol,dpower255,dcornerCode,dcornerMode:longint;const dround:boolean);

procedure fast__shadeArea(const dclip,darea:twinrect;const dcol1,dcol2:longint);
procedure fast__shadeArea2(const dclip,darea:twinrect;const dcol1,dcol2,dcornerCode,dcornerMode:longint;const dround:boolean);
procedure fast__shadeArea3(const dclip,darea:twinrect;const dcol1,dcol2,dcol3,dcol4,dsplice100,dpower255,dcornerCode,dcornerMode:longint;const dround:boolean);

procedure fast__invertArea(const dclip,darea:twinrect);//03mar2026
procedure fast__invertArea2(const dclip,darea:twinrect;const dcornerCode,dcornerMode:longint;const dround:boolean);//03mar2026

procedure fast__invertCorrectedArea(const dclip,darea:twinrect);//03mar2026
procedure fast__invertCorrectedArea2(const dclip,darea:twinrect;const dcornerCode,dcornerMode:longint;const dround:boolean);//03mar2026

function fast__calcPower255(dpower255:longint32;const denabled:boolean):longint32;//04apr2026

function fast__textwidth(const dtab,dtext:string;const dfont:tresslot):longint;//26feb2026
procedure fast__drawText(const dbackRef:longint;const dclip,darea:twinrect;const dx,dy,dcol:longint;const dtab,dtext:string;const dfont,ddecoration,dfeather4:longint32);//09apr2026, 29mar2026, 25feb2026
procedure fast__drawText2(const dbackRef:longint;const dclip,darea:twinrect;const dx,dy,dcol,dpower255:longint;const dtab,dtext:string;const dfont,ddecoration,dcornerCode,dcornerMode,dfeather4:longint32;const dround:boolean);//15mar2025, 25feb2026

procedure fast__drawtep(const dclip:twinrect;const xindex,dx,dy,dcol,dpower255:longint);
procedure fast__drawtep2(const dclip:twinrect;const xindex,dx,dy,col1,col2,col3,col4,dpower255:longint);

procedure fast__draw(const dclip:twinrect;const d:tobject;const dx,dy,dcol,dpower255:longint;const dmirror,dflip:boolean);
procedure fast__draw2(const dclip:twinrect;const d:tobject;const dx,dy,col1,col2,col3,col4,dpower255,dfeather4:longint;const dmirror,dflip:boolean);//09apr2026, 23mar2026
procedure fast__draw3(const dclip:twinrect;const d:tobject;const sa:twinrect;const dx,dy,dw,dh,col1,col2,col3,col4,dpower255,dfeather4:longint;const dmirror,dflip:boolean);//09apr2026, 03apr2026


//fastdraw - low level procs ---------------------------------------------------

function fd__renderFPS:double;
procedure fd__renderFPS_incFrameCount;

function fd__renderMPS:double;
procedure fd__showerror(const xerrcode,xcode:longint);//for debug purposes

procedure fd__selectRoot;
procedure fd__select(const x:tresslot);//set focus slot
procedure fd__selStore(var x:pfastdraw);
procedure fd__selRestore(var x:pfastdraw);
procedure fd__defaults;//set slot to default state (e.g. flush)
procedure fd__defaults2(var x:tfastdraw);

function fd__new:tresslot;//07apr2026
procedure fd__del(var x:tresslot);

function fd__bol(const xcode:longint32):boolean;
procedure fd__setbol(const xcode:longint32;const xval:boolean);

function fd__val(const xcode:longint):longint32;
procedure fd__setval(const xcode,xval:longint32);

function fd__val64(const xcode:longint):longint64;//05mar2026
procedure fd__setval64(const xcode:longint;const xval:longint64);

procedure fd__setCorner(const xcode:longint32);//handles corner values only -> can't accidentally trigger a command via a bad/wrong corner value - 27feb2026
procedure fd__set(const xcode:longint32);//01feb2026

procedure fd__rgba(const xcode:longint;var r,g,b,a:byte);
procedure fd__setrgba(const xcode:longint32;const r,g,b,a:byte);

function fd__area(const xcode:longint):twinrect;
procedure fd__area2(const xcode:longint;var x,y,w,h:longint32);

procedure fd__setarea(const xcode:longint;const x:twinrect);
procedure fd__setarea2(const xcode:longint;const x,y,w,h:longint32);

procedure fd__moveto(const xcode,x,y:longint32);//move area defined by "fd_area" and "fd_area2" - 06mar2026
procedure fd__movetoX(const xcode,x:longint32);
procedure fd__movetoY(const xcode,y:longint32);

procedure fd__setbuffer(const xcode:longint32;const xval:tobject);//05mar2026
procedure fd__setLayerMask(const xval:tobject);

procedure fd__setframe(const xframeName:string;const xframeData:tstr8;xsize,xcolor1,xcolor2:longint32);//28mar2026

//example usage #1: "fd__render( fd_fillarea )" colors in area on buffer
//example usage #2: "fd__render( fd_drawpixels )" renders pixels from buffer2 onto buffer via area
procedure fd__render(const xcode:longint32);
procedure fd__drawChar(const xcharIndex,dx,dy,dlineTop,dlineHeight,hpos:longint;dbackColor:longint);//07apr2026, 03mar2026, 28feb2026, 19feb2026
procedure fd__drawText(const x:string;dx,dy:longint);
procedure fd__drawTextTab(const xtab,x:string;dx,dy:longint);

//.support procs -> internal use only, do not call directly --------------------
procedure xfd__roundStart(const xcode:longint32);
procedure xfd__roundEnd(const xdebug:boolean);

procedure xfd__fillArea;//09apr2026, 01jan2026, 25dec2025
procedure xfd__fillarea300_layer_2432;//01jan2026, 29dec2025, 26dec2025, 24dec2025
procedure xfd__fillarea400_layer_power255_24;//01jan2026
procedure xfd__fillarea500_layer_power255_32;//01jan2026

procedure xfd__outlineArea;//26mar2026
procedure xfd__outlineArea7000_cliprange_layer;//26mar2026
procedure xfd__outlineArea7100_power255_cliprange_layer;//26mar2026
procedure xfd__outlineArea7200_power255_cliprange_layer_sparkle;//27mar2026

procedure xfd__shadeOutlineArea;//29mar2026
procedure xfd__shadeOutlineArea7500_cliprange_layer;
procedure xfd__shadeOutlineArea7600_power255_cliprange_layer;
procedure xfd__shadeOutlineArea7700_power255_cliprange_layer_sparkle;

procedure xfd__frameArea;//28mar2026
procedure xfd__frameArea8000_power255_cliprange_layer_sparkle;//28mar2026

procedure xfd__frameSimpleArea;//28mar2026
procedure xfd__frameSimpleArea8100_power255_cliprange_layer_sparkle;//28mar2026

procedure xfd__colorMatrix;//29mar2026
procedure xfd__colorMatrix11000_cliprange_layer;//29mar2026

procedure xfd__sketchArea;//06jan2026 - fills in area edge portions when round mode is one -> allows a base control to only fill a little of its surface area, allowing for the child control(s) to do the rest and save on render time - 05jan2026
procedure xfd__sketchArea350_layer_2432;//05jan2026

procedure xfd__shadeArea;//09apr2026, 07jan2026
procedure xfd__shadeArea1300_layer_2432;//07jan2026
procedure xfd__shadeArea1400_layer_power255_24;//07jan2026
procedure xfd__shadeArea1500_layer_power255_32;//07jan2026

procedure xfd__fillSmallArea;//07jan2026
procedure xfd__fillSmallArea1600_layer_2432;//07jan2026
procedure xfd__fillSmallArea1700_layer_power255_2432;//07jan2026

procedure xfd__drawRGB;//20feb2026
procedure xfd__drawRGB500;
procedure xfd__drawRGB600;
procedure xfd__drawRGB700_power255;//06jan2026, 29dec2025
procedure xfd__drawRGB800_flip_mirror_cliprange;
procedure xfd__drawRGB900_power255_flip_mirror_cliprange;
procedure xfd__drawRGB1000_power255_flip_mirror_cliprange_layer;//20feb2026
procedure xfd__drawRGB14000_flip_mirror_cliprange_layer_stretch;//03apr2026
procedure xfd__drawRGB14100_power255_flip_mirror_cliprange_layer_stretch;//03apr2026

procedure xfd__drawRGBA;//15mar2026
procedure xfd__drawRGBA9500;//15mar2026
procedure xfd__drawRGBA9600;//15mar2026
procedure xfd__drawRGBA9700_power255;//19mar2026, 15mar2026
procedure xfd__drawRGBA9800_flip_mirror_cliprange;//15mar2026
procedure xfd__drawRGBA9900_power255_flip_mirror_cliprange;//19mar2026, 15mar2026
procedure xfd__drawRGBA10000_power255_flip_mirror_cliprange_layer;//19mar2026, 15mar2026
procedure xfd__drawRGBA15000_flip_mirror_cliprange_layer_stretch;//04apr2026
procedure xfd__drawRGBA15100_power255_flip_mirror_cliprange_layer_stretch;//04apr2026

procedure xfd__drawRLE6;//05mar2026
function xfd__drawRLE6_featherPower(const dfeather4:longint32):longint32;//09apr2026
procedure xfd__drawRLE6_6000_layer;//06mar2026
procedure xfd__drawRLE6_6100_layer_power;//06mar2026
procedure xfd__drawRLE6_6200_cliprange_layer_power;//06mar2026

procedure xfd__drawRLE8;//05mar2026
function xfd__drawRLE8_featherPower(const dfeather4:longint32):longint32;//09apr2026
procedure xfd__drawRLE8_2000_layer;//23feb2026
procedure xfd__drawRLE8_2100_layer_power;//23feb2026
procedure xfd__drawRLE8_2200_cliprange_layer_power;//23feb2026

//.write an alpha channel for 32bit buffers
procedure xfd__drawRLE8_2000_layer_a;//07apr2026
procedure xfd__drawRLE8_2100_layer_power_a;//07apr2026
procedure xfd__drawRLE8_2200_cliprange_layer_power_a;//07apr2026

procedure xfd__drawRLE32;//20mar2026
function xfd__drawRLE32_featherPower(const dfeather4:longint32):longint32;//09apr2026
procedure xfd__drawRLE32_5000_layer;//20mar2026
procedure xfd__drawRLE32_5100_layer_power;//20mar2026
procedure xfd__drawRLE32_5200_cliprange_layer_power;//21mar2026

procedure xfd__invertArea;//28feb2026
procedure xfd__invertArea3000_layer_2432;//28feb2026

procedure xfd__invertCorrectedArea;//01mar2026
procedure xfd__invertCorrectedArea4000_layer_2432;//01mar2026

procedure xfd__dashedArea;//03mar2026
procedure xfd__dashedArea4200_layer_2432;//03mar2026

procedure xfd__lingCapture_template_flip_mirror_nochecks(var x:tfastdraw;var xb:tfastdrawbuffer;const xdestImage:pling);
procedure xfd__ling_makedebug(var x:tling);

procedure xfd__inc32(const xval:longint32);
procedure xfd__inc64;

procedure xfd__sync_amode(var x:tfastdrawbuffer);
procedure xfd__trimAreaToFitBuffer(var x:tfastdrawbuffer);

function xfd__canrow96(const x:tfastdrawbuffer;const xmin,xmax:longint32;var lx1,lx2,rx1,rx2,xfrom96,xto96:longint32):boolean;//01jan2026
function xfd__canrow962(const xbits,xmin,xmax:longint32;var lx1,lx2,rx1,rx2,xfrom96,xto96:longint32):boolean;//01jan2026


//sparkle procs ----------------------------------------------------------------
procedure fd__sparkleInit;
procedure fd__sparkleNewLevel(const xnewlevel:longint);
procedure fd__sparkleReset;
function fd__sparkleUniqueStart:longint32;
procedure fd__sparkleSetPos(const xnewpos:longint);


implementation

uses main, gossteps {$ifdef gui}, gossgui{$endif};


//start-stop procs -------------------------------------------------------------
procedure gossfast__start;
var
   p:longint;
begin
try

//check
if system_started_fast then exit else system_started_fast:=true;

//init
low__cls(@system_rescore,sizeof(system_rescore));

low__cls(@resling_cls  ,sizeof(resling_cls));//23dec2025
low__cls(@resling_cls2 ,sizeof(resling_cls2));//23ec2025


//.default font name 0 - root font name
system_fontnameDef0   :='arial';

//.default font name 1
system_fontnameDef1   :=app__info('font.name');//app definable default
if (system_fontnameDef1='') then system_fontnameDef1:='arial';

//.default font name 2
if app__bol('font2.use')  then system_fontnameDef2:=app__info('font2.name');
if (system_fontnameDef2='') then system_fontnameDef2:='courier new';

//.colors
rescol_white32.r      :=255;
rescol_white32.g      :=255;
rescol_white32.b      :=255;
rescol_white32.a      :=255;

rescol_black32.r      :=0;
rescol_black32.g      :=0;
rescol_black32.b      :=0;
rescol_black32.a      :=255;


//resSample --------------------------------------------------------------------

low__cls(@ressample_core,sizeof(ressample_core));


//rescaches --------------------------------------------------------------------

low__cls( @rescache_str8          ,sizeof(rescache_str8)        );
low__cls( @rescache_img8          ,sizeof(rescache_img8)        );//19feb2026
low__cls( @rescache_font          ,sizeof(rescache_font)        );
low__cls( @rescache_fastdraw      ,sizeof(rescache_fastdraw)    );
low__cls( @rescache_mapped        ,sizeof(rescache_mapped)      );//02apr2026

//fastdraw ---------------------------------------------------------------------

fd__sparkleInit;

fd__selectRoot;//default to system slot => "system_rescore.ffastdraw"
fd__defaults;//apply default values

low__cls(@sysfd_rendermps,sizeof(sysfd_rendermps));
low__cls(@sysfd_renderfps,sizeof(sysfd_renderfps));


//------------------------------------------------------------------------------
//system masks -----------------------------------------------------------------
//------------------------------------------------------------------------------

//.nil
resling_nil.w         :=0;
resling_nil.h         :=0;
resling_nil.trace     :=@resling_nil;//valid value required by "outlinearea" even when not round - 26mar2026


//round corner at 100% ---------------------------------------------------------

//.corner outline
ling__makeFromPattern(resling_corner_trace,255,0,0,
'   +/'  +
'  ++/'  +
' ++ /'  +
' +  /'  +
' +  /'  +
'++  /'  +
'');

resling_corner.trace         :=@resling_corner_trace;

//.corner eraser
ling__makeCornerEraser( resling_corner.trace^ ,resling_corner );//auto-generates left-side pixels of above mask upto the first "+" and excluding the "+" and all pixels after it on that row


//round corner at 200% ---------------------------------------------------------

//.corner outline
ling__makeFromPattern(resling_corner200_trace,255,0,0,
'      +/'  +
'      +/'  +
'    +++/'  +
'    +  /'  +
'  +++  /'  +
'  +    /'  +
'  +    /'  +
'  +    /'  +
'  +    /'  +
'  +    /'  +
'+++    /'  +
'');

resling_corner200.trace      :=@resling_corner200_trace;

//.corner eraser
ling__makeCornerEraser( resling_corner200.trace^ ,resling_corner200 );


//tight corner -----------------------------------------------------------------

ling__makeFromPattern(resling_cornerTight,255,0,0,
'+/'  +
'');

resling_cornerTight.trace    :=@resling_cornerTight;


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


//system font slots - maintained by GUI system via viSync ----------------------

resfont_ft            :=res__newfont2('arial',14  ,true  ,true   ,false);
resfont_ft2           :=res__newfont2('arial',16  ,true  ,true   ,false);
resfont_fn            :=res__newfont2('arial',12  ,true  ,false  ,false);
resfont_fb            :=res__newfont2('arial',12  ,true  ,true   ,false);
resfont_fs            :=res__newfont2('arial', 8  ,true  ,false  ,false);
resfont_fsb           :=res__newfont2('arial', 8  ,true  ,true   ,false);
resfont_fs2           :=res__newfont2('arial', 7  ,true  ,false  ,false);

except;end;
end;

procedure gossfast__stop;
var
   p:longint;

   procedure afree(const x:tobject);
   begin

   if (x<>nil) then freeobj(@x);

   end;

begin
try

//check
if not system_started_fast then exit else system_started_fast:=false;


//free system fonts ------------------------------------------------------------

res__del(resfont_ft);
res__del(resfont_ft2);
res__del(resfont_fn);
res__del(resfont_fb);
res__del(resfont_fs);
res__del(resfont_fsb);
res__del(resfont_fs2);


//free uncleared resource slots ------------------------------------------------

system_rescore.count:=0;
for p:=0 to pred(res_limit) do if (system_rescore.list[p].restype<>rest_none) then res__del(p);


//free fallback objects --------------------------------------------------------

freeobj(@system_rescore.fstr8);
freeobj(@system_rescore.ffont);
freeobj(@system_rescore.ffastdraw);


//free caches ------------------------------------------------------------------

for p:=0 to high(rescache_font.obj)          do afree(rescache_font.obj[p]);
for p:=0 to high(rescache_fastdraw.obj)      do afree(rescache_fastdraw.obj[p]);
for p:=0 to high(rescache_str8.obj)          do afree(rescache_str8.obj[p]);
for p:=0 to high(rescache_img8.obj)          do afree(rescache_img8.obj[p]);//19feb2026
for p:=0 to high(rescache_mapped.obj)        do afree(rescache_mapped.obj[p]);//02apr2026


//free support objects ---------------------------------------------------------

freeobj(@system_fontScanImage);


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
if      (xname='ver')        then result:='4.00.5775'
else if (xname='date')       then result:='10apr2026'
else if (xname='name')       then result:='FastDraw'
else
   begin
   //nil
   end;

except;end;
end;


//support procs ----------------------------------------------------------------
function find__viScale:double;//27feb2026
begin

{$ifdef gui}
result:=viscale;
{$else}
result:=1.0;
{$endif}

end;

function find__viFeather:longint;//27feb2026
begin

{$ifdef gui}
result:=vifeather;
{$else}
result:=0;
{$endif}

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

   //????????????????????????
   
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

function res__newfont2(const xname:string;const xsize:longint;const xgrey,xbold,xitalic:boolean):tresslot;
begin

result:=res__newfont;

if (result<>res_nil) then
   begin

   (system_rescore.list[ result ].data as tresfont).setparams( xname ,xsize ,xgrey ,xbold ,xitalic );

   end;

end;

function res__newFastdraw:tresslot;//07par2026
begin

result:=res__newFD;

end;

function res__newFD:tresslot;//07par2026
begin

result:=res__new(rest_fastdraw);

if (result<>res_nil) then
   begin

   system_rescore.list[ result ].data:=rescache__newFastdraw;

   fd__defaults2( res__fastdraw(result).core );//07apr2026

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

function resfont__wave(const xfont:tresslot):longint;
begin

result:=res__font(xfont).wave

end;

function resfont__wmin(const xfont:tresslot):longint;
begin

result:=res__font(xfont).wmin;

end;

function resfont__wmax(const xfont:tresslot):longint;
begin

result:=res__font(xfont).wmax;

end;

function resfont__height(const xfont:tresslot):longint;
begin

result:=res__font(xfont).height;

end;

function resfont__height1(const xfont:tresslot):longint;
begin

result:=res__font(xfont).height1;

end;

function resfont__textwidth(const xfont:tresslot;const xtext:string):longint;//20feb2026
begin

result:=resfont__textwidthTAB('',xfont,xtext);

end;

function resfont__textwidthTAB(const xtab:string;const xfont:tresslot;const xtext:string):longint;//20feb2026
begin

result:=res__font(xfont).textwidth(xtab,xtext);

end;

function font__lineThickness(const xfontheight:longint):longint;//03mar2026
begin

result:=frcmin32( xfontheight div 9 ,1 );

end;

function font__lineThickness2(const xfontheight:longint;const xscale:double):longint;//03mar2026
begin

result:=frcmin32( round32( (xscale*xfontheight) / 9 ) ,1 );

end;

function font__lineEmbossShift(const xfontheight:longint):longint;//03mar2026
begin

result:=frcmin32( xfontheight div 12 ,1 );

end;

function font__name1:string;
begin

result:=font_name1;//$fontname

end;

function font__name2:string;
begin

result:=font_name2;//$fontname2

end;


//-- font support --------------------------------------------------------------

function font__realname0(const xname,xviFontname,xviFontname2:string):string;//28feb2026
begin

if strmatch(xname,font_name1)  then
   begin

   result:=xvifontname;
   if (result='') then result:=system_fontnameDef1;

   end
else if strmatch(xname,font_name2) then
   begin

   result:=xvifontname2;
   if (result='') then result:=system_fontnameDef2;

   end
else begin

   result:=xname;
   if (result='') then result:=system_fontnameDef0;

   end;

end;

function font__realname(const xname:string):string;//28feb2026
begin

{$ifdef gui}

if strmatch(xname,font_name1)  then
   begin

   result:=vifontname;
   if (result='') then result:=system_fontnameDef1;

   end
else if strmatch(xname,font_name2) then
   begin

   result:=vifontname2;
   if (result='') then result:=system_fontnameDef2;

   end
else begin

   result:=xname;
   if (result='') then result:=system_fontnameDef0;

   end;

{$else}

result:=xname;
if (result='') then result:=system_fontnameDef0;

{$endif}

end;

function font__defaultname0:string;
begin
result:=font__defaultname(0);
end;

function font__defaultname1:string;
begin
result:=font__defaultname(1);
end;

function font__defaultname2:string;
begin
result:=font__defaultname(2);
end;

function font__defaultname(const xindex:longint):string;
begin

case xindex of
1    :result:=system_fontnameDef1;
2    :result:=system_fontnameDef2;
else  result:=system_fontnameDef0;
end;//case

end;

function font__realsize(const xsize:longint):longint;
begin

case (xsize>=0) of//allow a negative range which specifies fontsize via height in pixels - 11apr2020
true:result:=frcmin32(xsize,2);
else result:=xsize;
end;//case

end;

procedure font__clearinfo(var x:tresfontinfo);
begin

with x do
begin

name      :='';
size      :=0;
grey      :=false;
bold      :=false;
italic    :=false;

height    :=0;
height1   :=0;

wmin      :=0;
wmax      :=0;
wave      :=0;

end;

low__cls( @x.wlist ,sizeof(x.wlist) );
low__cls( @x.rlist ,sizeof(x.rlist) );
low__cls( @x.clist ,sizeof(x.clist) );

end;

procedure font__copyinfo(const s:tresfontinfo;const xfull:boolean;var d:tresfontinfo);
var
   p:longint;
begin

d.name      :=s.name;
d.size      :=s.size;
d.grey      :=s.grey;
d.bold      :=s.bold;
d.italic    :=s.italic;

d.height    :=s.height;
d.height1   :=s.height1;//27feb2026

d.wmin      :=s.wmin;
d.wmax      :=s.wmax;
d.wave      :=s.wave;

for p:=0 to fontchar_maxindex do
begin

d.wlist[p] :=s.wlist[p];
d.rlist[p] :=s.rlist[p];

if xfull then d.clist[p] :=s.clist[p];

end;//p

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

function font__textwidth(const xtab,xtext:string;const xfont:tresslot):longint;//10mar2026
begin

result:=res__font(xfont).textwidth(xtab,xtext);

end;


//## tresfont ###################################################################

constructor tresfont.create;
begin

//self
if classnameis('tresfont') then track__inc(satSysFont,1);
inherited create;

//vars
ifallback   :=nil;

low__cls( @clist ,sizeof(clist) );

//defaults
clear;

end;

destructor tresfont.destroy;
var
   p:longint;
begin
try

//controls
for p:=0 to fontchar_maxindex do if (clist[p]<>nil) then freeobj( @clist[p] );

freeobj(@ifallback);

//self
inherited destroy;
if classnameis('tresfont') then track__inc(satSysFont,-1);

except;end;
end;

procedure tresfont.xitalicWidth(var xwidth:longint;const xheight:longint);
begin

xwidth:=round32( xwidth + (xheight*0.2) );

end;

procedure tresfont.clear;
var
   p:longint;
begin

iname       :='';
isize       :=2;
igrey       :=false;
ibold       :=false;
iitalic     :=false;
iheight     :=1;
iheight1    :=1;
iwmin       :=1;
iwmax       :=1;
iwave       :=1;
icharCount  :=0;//number of char slots in use
ibytes      :=0;

low__cls( @wlist ,sizeof(wlist) );
low__cls( @rlist ,sizeof(rlist) );
low__cls( @mlist ,sizeof(mlist) );

for p:=0 to fontchar_maxindex do if (clist[p]<>nil) then clist[p].clear;

if (ifallback<>nil) then ifallback.clear;

end;

procedure tresfont.slowtimer;
begin

end;

function tresfont.setparams(const xname:string;const xsize:longint32;const xgrey,xbold,xitalic:boolean):boolean;
begin

result:=setparams2(xname,xsize,0,xgrey,xbold,xitalic);

end;

function tresfont.setparams2(const xname:string;const xsize,xrotate:longint32;const xgrey,xbold,xitalic:boolean):boolean;//09apr2026, 29mar2026
var
   p:longint;
   xmustinit:boolean;
   drotate,dminw,dmaxw,dmaxh,dmaxh1,dcount,dtotal:longint;
   dwh:tpoint;
begin

//defaults
result      :=false;

//filter -----------------------------------------------------------------------
case xrotate of
0..89   :drotate:=0;
90..179 :drotate:=90;
180..269:drotate:=180;
270..359:drotate:=270;
360     :drotate:=0;
else     drotate:=0;
end;//case


//init -------------------------------------------------------------------------
xmustinit   :=false;

if low__setstr( iname    ,strlow(font__realname(xname)) )  then xmustinit:=true;//convert into a real name
if low__setint( isize    ,font__realsize(xsize) )          then xmustinit:=true;//convert into a real size
if low__setint( irotate  ,drotate )                        then xmustinit:=true;
if low__setbol( igrey    ,xgrey   )                        then xmustinit:=true;
if low__setbol( ibold    ,xbold   )                        then xmustinit:=true;
if low__setbol( iitalic  ,xitalic )                        then xmustinit:=true;

//check
if not xmustinit then exit;


//reset ------------------------------------------------------------------------
iheight     :=1;//always non-zero -> indicates the font has been inited (but the character has not yet been scanned into a RLE8) - 01mar2026
iheight1    :=1;
iwmin       :=1;
iwmax       :=1;
iwave       :=1;
icharCount  :=0;//number of char slots in use
ibytes      :=0;

low__cls( @wlist ,sizeof(wlist) );
low__cls( @rlist ,sizeof(rlist) );
low__cls( @mlist ,sizeof(mlist) );

for p:=0 to fontchar_maxindex do
begin

if (clist[p]<>nil) then clist[p].clear;

end;//p

if (ifallback<>nil) then ifallback.clear;


//read char dimensions ---------------------------------------------------------

//init
dminw       :=max32;
dmaxw       :=1;
dmaxh       :=1;
dmaxh1      :=1;//use A-D (no drop parts like "Q" has)
dcount      :=0;
dtotal      :=0;

xsyncScanImg;

//get
for p:=0 to fontchar_maxindex do
begin

dwh                   :=wincanvas__textextent( system_fontScanImage.dc ,char(p) );

if (dwh.x<1)     then dwh.x:=1      else if (dwh.x>max16) then dwh.x:=max16;
if (dwh.y<1)     then dwh.y:=1      else if (dwh.y>max16) then dwh.y:=max16;

//.under Lazarus the character range 128-255 returns a width of 1px (an error) - discount these (if < 2px) for an accurate average - 03aug2024
if (dwh.x>=2) then
   begin

   inc(dcount,1);
   inc(dtotal,dwh.x);

   end;

//.no italic scaling
if (dwh.x>=1)    then rlist[p]:=dwh.x else rlist[p]:=1;

//.italic scaling
if xitalic       then xitalicWidth(dwh.x,dwh.y);
if (dwh.x>=1)    then wlist[p]:=dwh.x else wlist[p]:=1;

//.min-max
if (dwh.x<dminw) then dminw:=dwh.x;//20feb2025
if (dwh.x>dmaxw) then dmaxw:=dwh.x;
if (dwh.y>dmaxh) then dmaxh:=dwh.y;

end;//p

//.finalise
iheight               :=frcmin32(dmaxh,1);//scan height
iwmin                 :=frcmin32(dminw,1);//never zero or less
iwmax                 :=frcmin32(dmaxw,1);//scan width
iwave                 :=frcmin32( frcrange32( dtotal div frcmin32(dcount,1) ,iwmin ,iwmax ) ,1 );


//scan A-D for height1 ---------------------------------------------------------

for p:=uuA to uuD do
begin

xscanChar( p );

if (clist[p].height1>iheight1) then iheight1:=clist[p].height1;

end;//p

//changed
result      :=true;

end;

procedure tresfont.xsyncScanImg;
var
   dgrey:boolean;
begin

if (system_fontScanImage=nil) then system_fontScanImage:=miswin24(1,1);

dgrey       :=igrey and ((isize>6) or (isize<0));//disable greyscale at low resolutions to avoid extensive blurring

system_fontScanImage.setfont(iname,not dgrey,ibold,isize,0,int_255_255_255);

end;

procedure tresfont.xscanChar(const xindex:longint);
var
   dw,dh,cw,aw,ah,xpad:longint32;

   //make italic wider and more obvious for faster/easier viewing - 26feb2026
   procedure xmakeItalic;
   var
      xbits,dy,dx,slimit,ymax,sv,ww:longint;
      sr24:pcolorrow24;
      sr32:pcolorrow32;
   begin

   //init
   ww       :=rlist[xindex];//without italic scaling
   ymax     :=pred(ah);
   slimit   :=round(2+cw-ww);
   xbits    :=system_fontScanImage.bits;

   //check
   if (slimit<=0) or (ymax<=0) then exit;//nothing to do

   //shift pixels to the right for italic effect
   for dy:=0 to ymax do
   begin

   sv       :=round32( slimit * ((ymax-dy)/ymax) );//shift right

   if (sv>=1) then
      begin

      //24
      if (xbits=24) then
         begin

         if not misscan24(system_fontScanImage,dy,sr24) then exit;

         for dx:=(xpad+cw-1) downto (xpad+sv) do if ((dx-sv)>=0) then sr24[dx].r   :=sr24[dx-sv].r;

         for dx:=(xpad+sv-1) downto xpad      do if (dx>=0)      then sr24[dx].r   :=255;

         end

      //32
      else if (xbits=32) then
         begin

         if not misscan32(system_fontScanImage,dy,sr32) then exit;

         for dx:=(xpad+cw-1) downto (xpad+sv) do if ((dx-sv)>=0) then sr32[dx].r   :=sr32[dx-sv].r;

         for dx:=(xpad+sv-1) downto xpad      do if (dx>=0)      then sr32[dx].r   :=255;

         end;

      end;

   end;//dy

   end;

begin

//check
if (xindex<0) or (xindex>fontchar_maxindex) or mlist[xindex] then exit;


//init -------------------------------------------------------------------------

mlist[xindex]         :=true;//mark as scanned
xpad                  :=frcrange32( round32( iwmax * 0.1 ) ,2 ,20 );//widen capture area to allow for left/right boundary overlap detection - 20apr2020
aw                    :=frcrange32( iwmax + (2*xpad) ,1 ,maxrow );
ah                    :=frcrange32( iheight ,1 ,maxrow );

//img
xsyncScanImg;

case (slowms64>=system_fontScanImageREF) of
true:begin

   dw                 :=aw;
   dh                 :=ah;

   end
else begin

   dw                 :=frcmin32( aw ,system_fontScanImage.width  );
   dh                 :=frcmin32( ah ,system_fontScanImage.height );

   end;
end;//case

//.retain min-dimensions for at-least 10 seconds during activity -> shrink back down once activity recommences AFTER 10s
system_fontScanImageREF      :=add64( slowms64 ,10000 );

//.reduce number of times the scanImage has to be resized - 01mar2026
if (dw<>system_fontScanImage.width) or (dh<>system_fontScanImage.height) then
   begin

   missize(system_fontScanImage,dw+100,dh+100);

   end;

//cls entire area of "img" + draw char indented by "xpad" from left to allow boundary overlap scanning - 20apr2020
wincanvas__textrect( system_fontScanImage.dc ,false ,misrect(0,0,aw,ah) ,xpad ,0 ,char(xindex) );


//scan -------------------------------------------------------------------------

//init
cw          :=frcmax32(wlist[xindex],iwmax);//with italic scaling

if (clist[xindex]=nil) then clist[xindex]:=tbasicrle8.create;

//skew-to-the-right for italic
if iitalic then xmakeItalic;

//scan
clist[xindex].fast__makefromR2( system_fontScanImage ,area__make(xpad,0,xpad+cw-1,pred(ah)) ,true ,(xindex>=uuA) and (xindex<=uuD) );

//bytes
inc64( ibytes ,clist[xindex].core.len );

end;

function tresfont.needChar(const xindex:longint32):tbasicrle8;//01mar2026
begin

if (xindex>=0) and (xindex<=fontchar_maxindex) then
   begin

   if not mlist[xindex] then xscanChar(xindex);
   result:=clist[xindex];

   end
else
   begin

   if (ifallback=nil) then ifallback:=tbasicrle8.create;
   result:=ifallback;

   end;

end;

procedure tresfont.needChars(const x:string);
var
   p:longint;
begin

if (x<>'') then
   begin

   for p:=1 to low__len32(x) do needChar( byte( x[p-1+stroffset] ) );

   end;

end;

procedure tresfont.needCharRange(const xcharindex_from,xcharindex_to:longint32);
var
   p:longint;
begin

for p:=frcrange32(xcharindex_from,0,fontchar_maxindex) to frcrange32(xcharindex_to,0,fontchar_maxindex) do needChar( p );

end;

function tresfont.textwidth(const xtab,x:string):longint32;
var
   p,xcolalign,xcolcount,xcolwidth,x1,x2:longint;
   v:byte;
begin

//defaults
result:=0;

//get
if (xtab<>'') then
   begin

   font__tab(xtab,0,iheight,0,xcolalign,xcolcount,xcolwidth,result,x1,x2);

   end
else if (x<>'') then
   begin

   for p:=1 to low__len32(x) do
   begin

   v:=byte( x[p-1+stroffset] );

   inc( result, wlist[v] );

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

//get
if (xtab<>'') then
   begin

   str__lock(@x);

   font__tab(xtab,0,iheight,0,xcolalign,xcolcount,xcolwidth,result,x1,x2);

   end
else if str__lock(@x) and (x.len>=1) then
   begin

   for p:=1 to x.len32 do
   begin

   v:=x.pbytes[ p -1 ];

   inc( result, wlist[v] );

   end;//p

   end;

//free
str__uaf(@x);

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

function rescache__newImg8:tbasicimage;//19feb2026
var
   p:longint;
begin

//defaults
result :=nil;

//get
for p:=0 to high(rescache_Img8.obj) do if not rescache_img8.use[p] then
   begin

   //mark in use
   rescache_img8.use[p]:=true;

   //init
   if (rescache_img8.obj[p]=nil) then
      begin

      rescache_img8.obj[p]            :=misimg8(1,1);

      end;

   //get
   result :=rescache_img8.obj[p];

   //stop
   exit;

   end;//p

//fallback
if (result=nil) then
   begin

   result            :=misimg8(1,1);

   end;

end;

function rescache__delImg8(x:pobject):boolean;//19feb2026
var
   p:longint;
begin

//pass-thru
result:=true;

//get
for p:=0 to high(rescache_img8.obj) do if (x^=rescache_img8.obj[p]) then
   begin

   //reset
   rescache_img8.obj[p].setparams(8,1,1);

   //clear caller's pointer
   x^:=nil;

   //mark not in use
   rescache_img8.use[p]:=false;

   //stop
   exit;

   end;

//fallback
freeobj(x);

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

function rescache__newMapped(const xid,dW,sx1,sx2,sW:longint32):tdynamicinteger;//02apr2026
var
   p:longint32;
   vlist:pdllongint;//32
   xratio:double;

begin

//defaults
result                :=nil;


//find existing ----------------------------------------------------------------
for p:=0 to high(rescache_mapped.use) do
begin

if (rescache_mapped.obj[p]<>nil) and (xid=rescache_mapped.id[p] ) and (dw=rescache_mapped.dw[p]  ) and
   (sw=rescache_mapped.sw[p]   ) and (sx1=rescache_mapped.sx1[p]) and (sx2=rescache_mapped.sx2[p]) then
   begin

   result                    :=rescache_mapped.obj[p];
   rescache_mapped.use[p]    :=true;//mark as "in use"

   exit;

   end;

end;//p


//new --------------------------------------------------------------------------
for p:=0 to high(rescache_mapped.use) do
begin

if not rescache_mapped.use[p] then
   begin

   //auto-create
   if (rescache_mapped.obj[p]=nil) then rescache_mapped.obj[p]:=tdynamicinteger.create;

   //get
   rescache_mapped.use[p]    :=true;
   rescache_mapped.id[p]     :=xid;
   rescache_mapped.dw[p]     :=dw;
   rescache_mapped.sw[p]     :=sw;
   rescache_mapped.sx1[p]    :=sx1;
   rescache_mapped.sx2[p]    :=sx2;
   result                    :=rescache_mapped.obj[p];

   break;

   end;

end;//p


//fallback ---------------------------------------------------------------------

if (result=nil) then result:=tdynamicinteger.create;


//fill list with scaled values -------------------------------------------------

//init
result.setparams( dW ,dW ,0 );

//get
vlist       :=result.core;
xratio      :=( sW / frcmin32(dW-1,1) );

for p:=0 to pred(dW) do
begin

vlist[p]    :=sx1 + trunc32( p*xratio );

if (vlist[p]<sx1) then vlist[p]:=sx1;
if (vlist[p]>sx2) then vlist[p]:=sx2;

end;//p

end;

function rescache__delMapped(x:pobject):boolean;
var
   p:longint;
begin

//pass-thru
result:=true;

//check
if (x^=nil) then exit;

//get
for p:=0 to high(rescache_mapped.obj) do if (x^=rescache_mapped.obj[p]) then
   begin

   //reset -> do not reset, as int32 is used for image zooming and is expected to be persistently cached

   //clear caller's pointer
   x^:=nil;

   //mark not in use
   rescache_mapped.use[p]:=false;

   //stop
   exit;

   end;

//fallback
freeobj(x);

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

s.pixels    :=resling_cls.pixels;

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
s.pixels    :=resling_cls2.pixels;

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

   ssPlus:begin//solid pixel

      if (dx<s.w) then s.pixels[dy][dx]:=c32;

      inc(dx);

      if (dx>dw)       then dw:=dx+0;
      if ((dy+1)>dh)   then dh:=dy+1;

      end;

   ssSpace:begin//transparent pixel

      inc(dx);

      if (dx>dw)       then dw:=dx+0;
      if ((dy+1)>dh)   then dh:=dy+1;

      end;

   ssSlash,ss10:begin//new row

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

function ling__makeCornerEraser(var s,d:tling):boolean;//28mar2026
var
   dx,dy,dw,dh:longint32;
begin

//defaults
result    :=true;
d.w       :=s.w;
d.h       :=s.h;

//cls
ling__cls(d);

//check
if (d.w<1) or (d.h<1) then exit;

//get
for dy:=0 to pred(s.h) do
begin

//.scan horizontal row of pixels from left-to-right, marking each with "a=255" until "s.a>=1"
for dx:=0 to pred(s.w) do
begin

case (s.pixels[dy][dx].a<=0) of
true:d.pixels[dy][dx].a:=255;
else break;
end;//case

end;//dx

end;//dy

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
sysfd_drawproc32:=101;

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
sysfd_drawproc32:=102;

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
sysfd_drawproc32:=103;

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

   {$ifdef gui}
   dbstatus(xslot,xlabel+insstr('>',xlabel<>'')+ curdec(timeAve,2,true)+' ms'+insstr(' << '+k64(tag1)+'__'+k64(tag2),(tag1<>0) or (tag2<>0)) );
   {$endif}

   end;

   end;

end;


//fastdraw - high level procs --------------------------------------------------

procedure fast__sketchArea(const dclip,darea:twinrect;const dcol,dcornerCode:longint);
begin

fd__set( fd_fillAreaDefaults );
fd__setval( fd_color1, dcol );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__set( dcornerCode );//requires corner image for measurements - 13jan2026
fd__render( fd_sketchArea );

end;

procedure fast__invertCorrectedArea(const dclip,darea:twinrect);//03mar2026
begin

fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__render( fd_invertCorrectedArea );

end;

procedure fast__invertCorrectedArea2(const dclip,darea:twinrect;const dcornerCode,dcornerMode:longint;const dround:boolean);//03mar2026
begin

fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );

if dround then
   begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );
   fd__render( fd_roundStartFromArea );

   end;

fd__render( fd_invertCorrectedArea );

if dround then fd__render( fd_roundStopAndRender );

end;

procedure fast__invertArea(const dclip,darea:twinrect);//03mar2026
begin

fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__render( fd_invertArea );

end;

procedure fast__invertArea2(const dclip,darea:twinrect;const dcornerCode,dcornerMode:longint;const dround:boolean);//03mar2026
begin

fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );

if dround then
   begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );
   fd__render( fd_roundStartFromArea );

   end;

fd__render( fd_invertArea );

if dround then fd__render( fd_roundStopAndRender );

end;

procedure fast__colorMatrix(const dclip,darea:twinrect;const dcornerCode,dcornerMode:longint;const dround:boolean);//29mar2026
begin

//info
fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );

case dround of
true:begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );

   end;
else begin

   fd__setCorner( fd_roundNone );
   fd__setCorner( fd_roundmodeAll );

   end;
end;//case

//render
fd__render( fd_colorMatrix );

end;

procedure fast__frameSimpleArea(const dclip,darea:twinrect;const dsize,dcol,dpower255,dcornerCode,dcornerMode:longint;const dsparkle,dround:boolean);//28mar2026
begin

//frame info
fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__setval( fd_color1, dcol );
fd__setval( fd_power, dpower255 );
fd__setbol( fd_sparkle_val1, dsparkle and (fd_sparkle.level>=1) );//sparkle
fd__setval( fd_val2, dsize );//frame size

case dround of
true:begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );

   end;
else begin

   fd__setCorner( fd_roundNone );
   fd__setCorner( fd_roundmodeAll );

   end;
end;//case

//render
fd__render( fd_frameSimpleArea );

end;

procedure fast__frameArea(const dclip,darea:twinrect;const dframeCode:tstr8;const dsize,dcol1,dcol2,dpower255,dcornerCode,dcornerMode:longint;const dsparkle,dround:boolean);//28mar2026
begin

//frame data
fd__setframe('',dframeCode,dsize,dcol1,dcol2);

//frame info
fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__setval( fd_power, dpower255 );
fd__setbol( fd_sparkle_val1, dsparkle and (fd_sparkle.level>=1) );//sparkle

case dround of
true:begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );

   end;
else begin

   fd__setCorner( fd_roundNone );
   fd__setCorner( fd_roundmodeAll );

   end;
end;//case

//render
fd__render( fd_frameArea );

end;

procedure fast__outlineArea(const dclip,darea:twinrect;const dcol,dpower255:longint);//26mar2026
begin

fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__setval( fd_color1, dcol );
fd__setval( fd_power, dpower255 );
fd__setval( fd_sparkle_val1, 0 );//sparkle => off

fd__setCorner( fd_roundNone );
fd__setCorner( fd_roundmodeAll );

fd__render( fd_outlineArea );

end;

procedure fast__outlineArea2(const dclip,darea:twinrect;const dcol,dpower255,dcornerCode,dcornerMode:longint;const dsparkle,dround:boolean);//26mar2026
begin

fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__setval( fd_color1, dcol );
fd__setval( fd_power, dpower255 );
fd__setbol( fd_sparkle_val1, dsparkle and (fd_sparkle.level>=1) );//sparkle

case dround of
true:begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );

   end;
else begin

   fd__setCorner( fd_roundNone );
   fd__setCorner( fd_roundmodeAll );

   end;
end;//case

fd__render( fd_outlineArea );

end;

procedure fast__fillArea(const dclip,darea:twinrect;const dcol:longint);
begin

fd__set( fd_fillAreaDefaults );
fd__setval( fd_color1, dcol );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__render( fd_fillArea );

end;

procedure fast__fillArea2(const dclip,darea:twinrect;const dcol,dcornerCode,dcornerMode:longint;const dround:boolean);
begin

fd__set( fd_fillAreaDefaults );
fd__setval( fd_color1, dcol );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );

if dround then
   begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );
   fd__render( fd_roundStartFromArea );

   end;

fd__render( fd_fillArea );

if dround then fd__render( fd_roundStopAndRender );

end;

procedure fast__fillArea3(const dclip,darea:twinrect;const dcol,dpower255,dcornerCode,dcornerMode:longint;const dround:boolean);
begin

fd__set( fd_fillAreaDefaults );
fd__setval( fd_power, dpower255 );
fd__setval( fd_color1, dcol );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );

if dround then
   begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );
   fd__render( fd_roundStartFromArea );

   end;

fd__render( fd_fillArea );

if dround then fd__render( fd_roundStopAndRender );

end;

procedure fast__shadeArea(const dclip,darea:twinrect;const dcol1,dcol2:longint);
begin

fd__set( fd_fillAreaDefaults );
fd__setval( fd_color1, dcol1 );
fd__setval( fd_color2, dcol2 );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__render( fd_shadeArea );

end;

procedure fast__shadeArea2(const dclip,darea:twinrect;const dcol1,dcol2,dcornerCode,dcornerMode:longint;const dround:boolean);
begin

fd__set( fd_fillAreaDefaults );
fd__setval( fd_color1, dcol1 );
fd__setval( fd_color2, dcol2 );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );

if dround then
   begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );
   fd__render( fd_roundStartFromArea );

   end;

fd__render( fd_shadeArea );

if dround then fd__render( fd_roundStopAndRender );

end;

procedure fast__shadeArea3(const dclip,darea:twinrect;const dcol1,dcol2,dcol3,dcol4,dsplice100,dpower255,dcornerCode,dcornerMode:longint;const dround:boolean);
begin

fd__set( fd_fillAreaDefaults );
fd__setval( fd_color1, dcol1 );
fd__setval( fd_color2, dcol2 );
fd__setval( fd_color3, dcol3 );
fd__setval( fd_color4, dcol4 );
fd__setval( fd_splice, dsplice100 );
fd__setval( fd_power, dpower255 );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );

if dround then
   begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );
   fd__render( fd_roundStartFromArea );

   end;

fd__render( fd_shadeArea );

if dround then fd__render( fd_roundStopAndRender );

end;

procedure fast__shadeOutlineArea(const dclip,darea:twinrect;const dcol1,dcol2,dcol3,dcol4,dsplice100,dpower255,dcornerCode,dcornerMode:longint;const dsparkle,dround:boolean);//29mar2026
begin

fd__set( fd_fillAreaDefaults );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__setval( fd_color1, dcol1 );
fd__setval( fd_color2, dcol2 );
fd__setval( fd_color3, dcol3 );
fd__setval( fd_color4, dcol4 );
fd__setval( fd_splice, dsplice100 );
fd__setval( fd_power, dpower255 );
fd__setbol( fd_sparkle_val1, dsparkle and (fd_sparkle.level>=1) );//sparkle

case dround of
true:begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );

   end;
else begin

   fd__setCorner( fd_roundNone );
   fd__setCorner( fd_roundmodeAll );

   end;
end;//case

fd__render( fd_shadeOutlineArea );

end;

function fast__calcPower255(dpower255:longint32;const denabled:boolean):longint32;//04apr2026
begin

//range
if      (dpower255<0)   then dpower255:=0
else if (dpower255>255) then dpower255:=255;

//get
case denabled of
true:result:=( dpower255 * power_enabled  ) div 255;//"div 255" for accuracy -> no rounding down to 254 as with "div 256" or "shr 8"
else result:=( dpower255 * power_disabled ) div 255;
end;//case

end;

function fast__textwidth(const dtab,dtext:string;const dfont:tresslot):longint;//26feb2026
begin

result:=res__font(dfont).textwidth(dtab,dtext);

end;

procedure fast__drawText(const dbackRef:longint;const dclip,darea:twinrect;const dx,dy,dcol:longint;const dtab,dtext:string;const dfont,ddecoration,dfeather4:longint32);//09apr2026, 29mar2026, 25feb2026
var
   c,v:longint;
begin

//check
if not area__valid( darea ) then exit;

//init
fd__set( fd_fillAreaDefaults );
fd__setval( fd_power, 255 );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__setval( fd_font  ,dfont );
fd__setval( fd_charDecoration ,ddecoration );
fd__setval( fd_feather  ,dfeather4 );

//emboss text layer (bottom layer)
if (dbackRef<>clnone) then
   begin

   fd__setval( fd_textColor, int__splice24(0.05,int__dif242(dbackRef,-15,false),dcol) );//fd_color1
   v        :=font__lineEmbossShift( res__font( fd_focus.font ).height );

   case (dtab<>'') of
   true:fd__drawTextTab( dtab, dtext, dx-v ,dy-v );
   else fd__drawText( dtext, dx-v ,dy-v );
   end;//case

   end;

//normal text (top layer)
fd__setval( fd_textColor, dcol );//color1

case (dtab<>'') of
true:fd__drawTextTab( dtab, dtext, dx ,dy );
else fd__drawText( dtext, dx ,dy );
end;//case

end;

procedure fast__drawText2(const dbackRef:longint;const dclip,darea:twinrect;const dx,dy,dcol,dpower255:longint;const dtab,dtext:string;const dfont,ddecoration,dcornerCode,dcornerMode,dfeather4:longint32;const dround:boolean);//15mar2025, 25feb2026
var
   c,v:longint;
begin

//check
if not area__valid( darea ) then exit;
if (dpower255<=0)           then exit;

//init
fd__set( fd_fillAreaDefaults );
fd__setval( fd_power, dpower255 );
fd__setarea( fd_clip ,dclip );
fd__setarea( fd_area ,darea );
fd__setval( fd_feather  ,dfeather4 );

if dround then
   begin

   fd__setCorner( dcornerCode );
   fd__setCorner( dcornerMode );
   fd__render( fd_roundStartFromArea );

   end;

fd__setval( fd_font ,dfont );
fd__setval( fd_charDecoration ,ddecoration );

//emboss text layer (bottom layer)
if (dbackRef<>clnone) then
   begin

   fd__setval( fd_textColor, int__splice24(0.05,int__dif242(dbackRef,-15,false),dcol) );//fd_color1
   v        :=1;

   case (dtab<>'') of
   true:fd__drawTextTab( dtab, dtext, dx-v ,dy-v );
   else fd__drawText( dtext, dx-v ,dy-v );
   end;//case

   end;


//normal text (top layer)
fd__setval( fd_textColor, dcol );//color1

case (dtab<>'') of
true:fd__drawTextTab( dtab ,dtext, dx ,dy );
else fd__drawText( dtext, dx ,dy );
end;//case

if dround then fd__render( fd_roundStopAndRender );

end;

procedure fast__drawtep(const dclip:twinrect;const xindex,dx,dy,dcol,dpower255:longint);
begin

tep__draw(dclip,xindex,dx,dy,dcol,dpower255);

end;

procedure fast__drawtep2(const dclip:twinrect;const xindex,dx,dy,col1,col2,col3,col4,dpower255:longint);
begin

tep__draw2(dclip,xindex,dx,dy,col1,col2,col3,col4,dpower255);

end;

procedure fast__draw(const dclip:twinrect;const d:tobject;const dx,dy,dcol,dpower255:longint;const dmirror,dflip:boolean);
begin

fast__draw2(dclip,d,dx,dy,dcol,dcol,dcol,dcol,dpower255,find__vifeather,dmirror,dflip);

end;

procedure fast__draw2(const dclip:twinrect;const d:tobject;const dx,dy,col1,col2,col3,col4,dpower255,dfeather4:longint;const dmirror,dflip:boolean);//09apr2026, 23mar2026
begin

if (d<>nil) then
   begin

   //init
   fd__set( fd_fillAreaDefaults );
   fd__setarea( fd_clip ,dclip );
   fd__setarea( fd_area ,dclip );
   fd__setval( fd_power ,dpower255 );
   fd__setbol( fd_mirror,dmirror );//04apr2026
   fd__setbol( fd_flip  ,dflip );//04apr2026
   fd__setval( fd_feather ,dfeather4 );//09apr2026

   //get
   if (d is tbasicrle6) then
      begin

      //render
      fd__setbuffer( fd_buffer2 ,d );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__setval( fd_color1 ,col1 );
      fd__setval( fd_color2 ,col2 );
      fd__setval( fd_color3 ,col3 );
      fd__setval( fd_color4 ,col4 );
      fd__render( fd_drawRLE6 );

      end

   else if (d is tbasicrle8) then
      begin

      //render
      fd__setbuffer( fd_buffer2 ,d );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__setval( fd_color1 ,col1 );
      fd__render( fd_drawRLE8 );

      end

   else if (d is tbasicrle32) then
      begin

      //render
      fd__setbuffer( fd_buffer2 ,d );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__render( fd_drawRLE32 );

      end

   else begin

      //render
      fd__setbuffer( fd_buffer2 ,d );
      fd__setarea2 ( fd_area  ,dx ,dy ,misw(d) ,mish(d) );
      fd__render   ( fd_drawRGBA );//15mar2026

      end;

   end;

end;

procedure fast__draw3(const dclip:twinrect;const d:tobject;const sa:twinrect;const dx,dy,dw,dh,col1,col2,col3,col4,dpower255,dfeather4:longint;const dmirror,dflip:boolean);//09apr2026, 03apr2026
begin

if (d<>nil) then
   begin

   //init
   fd__set( fd_fillAreaDefaults );
   fd__setarea( fd_clip ,dclip );
   fd__setarea( fd_area ,dclip );
   fd__setval( fd_power ,dpower255 );
   fd__setbol( fd_mirror,dmirror );//04apr2026
   fd__setbol( fd_flip  ,dflip );//04apr2026
   fd__setval( fd_feather ,dfeather4 );//09apr2026

   //get
   if (d is tbasicrle6) then
      begin

      //render
      fd__setbuffer( fd_buffer2 ,d );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__setval( fd_color1 ,col1 );
      fd__setval( fd_color2 ,col2 );
      fd__setval( fd_color3 ,col3 );
      fd__setval( fd_color4 ,col4 );
      fd__render( fd_drawRLE6 );

      end

   else if (d is tbasicrle8) then
      begin

      //render
      fd__setbuffer( fd_buffer2 ,d );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__setval( fd_color1 ,col1 );
      fd__render( fd_drawRLE8 );

      end

   else if (d is tbasicrle32) then
      begin

      //render
      fd__setbuffer( fd_buffer2 ,d );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__render( fd_drawRLE32 );

      end

   else begin

      //render
      fd__setbuffer( fd_buffer2 ,d );
      fd__setarea2 ( fd_area  ,dx ,dy ,dw ,dh );//target area
      fd__setarea  ( fd_area2 ,sa );//source area
      fd__render   ( fd_drawRGBA );//04apr2026 - supports "stretch", 15mar2026

      end;

   end;

end;


//fastdraw - low level procs ---------------------------------------------------

function fd__renderFPS:double;
var
   v64:longint64;
begin

v64:=fastms64;

if (v64>=sysfd_renderfps.time1000) then
   begin


   try
   sysfd_renderfps.renderfps :=( (sysfd_renderfps.renderfps*2) + ( sysfd_framecount32 * (1000/frcmin64(sub64(v64,sub64(sysfd_renderfps.time1000,1000)),1))) ) / 3;
   except;
   sysfd_renderfps.renderfps :=1;
   end;

   sysfd_renderfps.lastfps32 :=sysfd_framecount32;
   sysfd_framecount32        :=0;
   sysfd_renderfps.time1000  :=add64( v64 ,1000 );

   end;

result:=sysfd_renderfps.renderfps;

end;

procedure fd__renderFPS_incFrameCount;
begin

case (sysfd_framecount32<max32) of
true:inc(sysfd_framecount32);
else sysfd_framecount32:=1;
end;//case

end;

function fd__renderMPS:double;
var
   v64:longint64;
begin

v64:=fastms64;

if (v64>=sysfd_rendermps.time1000) then
   begin


   try
   xfd__inc64;//flush
   sysfd_rendermps.rendermps :=( (sysfd_rendermps.rendermps*2) + (sub64( sysfd_pixelcount64, sysfd_rendermps.lastmps64 ) * (1/1000000) * (1000/frcmin64(sub64(v64,sub64(sysfd_rendermps.time1000,1000)),1))) ) / 3;
   except;
   sysfd_rendermps.rendermps :=1;
   end;

   sysfd_rendermps.lastmps64 :=sysfd_pixelcount64;
   sysfd_rendermps.time1000  :=add64( v64 ,1000 );

   end;

result:=sysfd_rendermps.rendermps;

end;

procedure xfd__inc32(const xval:longint32);
begin

case (sysfd_pixelcount32<fdr_pixelcount32_limit) of
true:sysfd_pixelcount32 :=sysfd_pixelcount32+xval;
else sysfd_pixelcount32 :=xval;
end;//case

end;

procedure xfd__inc64;
begin

case (sysfd_pixelcount64<fdr_pixelcount64_limit) of
true:sysfd_pixelcount64 :=sysfd_pixelcount64 + sysfd_pixelcount32;
else sysfd_pixelcount64 :=sysfd_pixelcount32;
end;//case

sysfd_pixelcount32:=0;

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
if (sysfd_errors_count<max32) then inc(sysfd_errors_count);

//check
if not sysfd_errors_ok then exit;

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

fd__defaults2(fd_focus^);

end;

procedure fd__defaults2(var x:tfastdraw);
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

//.values
val1             :=0;
val2             :=0;
val3             :=0;

//round support
rindex           :=-1;
rimage           :=@resling_nil;
rmode            :=rmAll;

//misc
mirror           :=false;
flip             :=false;
power255         :=255;
splice100        :=100;
font             :=res_nil;
charDecoration   :=cdNone;
frame.size       :=0;
write_a          :=false;//07apr2026

//tracking
drawProc         :=0;

end;

end;

procedure fd__sparkleSetPos(const xnewpos:longint);
begin

fd_sparkle.pos        :=frcrange32(xnewpos,0,pred(fd_sparkleListSize));

end;

function fd__new:tresslot;//07apr2026
begin

result:=res__newfastdraw;//auto-applies defaults to new slot

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

fd_drawRGB                    :xfd__drawRGB;
fd_drawRGBA                   :xfd__drawRGBA;

fd_drawRLE6                   :xfd__drawRLE6; //for clipping use only "fd_clip" as "fd_area" is ignored for RLE drawing and use "fd_area2" to move image around target buffer e.g. fd__setarea2(target.dx,target.dy,source.rle.width,source.rle.height)
fd_drawRLE8                   :xfd__drawRLE8; //as above
fd_drawRLE32                  :xfd__drawRLE32;//as above

fd_invertArea                 :xfd__invertArea;
fd_invertCorrectedArea        :xfd__invertCorrectedArea;
fd_dashedArea                 :xfd__dashedArea;

fd_outlineArea                :xfd__outlineArea;//26mar2026

fd_frameArea                  :xfd__frameArea;//28mar2026
fd_frameSimpleArea            :xfd__frameSimpleArea;//28mar2026

fd_colorMatrix                :xfd__colorMatrix;//29mar2026
fd_shadeOutlineArea           :xfd__shadeOutlineArea;//29mar2026

else                           fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__setCorner(const xcode:longint32);
begin

case xcode of

fd_roundNone         :fd_focus.rimage:=@resling_nil;

fd_roundCorner       :begin

                      case (find__viScale>=2) of
                      true:fd_focus.rimage:=@resling_corner200;//larger corner image for larger active scaling - 01feb2026
                      else fd_focus.rimage:=@resling_corner;
                      end;//case

                      end;

fd_roundCornerTight  :fd_focus.rimage:=@resling_cornerTight;

fd_roundmodeAll      :fd_focus.rmode:=rmAll;
fd_roundmodeTopOnly  :fd_focus.rmode:=rmTopOnly;
fd_roundmodeBotOnly  :fd_focus.rmode:=rmBotOnly;

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

fd_flip         :fd_focus.flip         :=true;
fd_noflip       :fd_focus.flip         :=false;
fd_mirror       :fd_focus.mirror       :=true;
fd_nomirror     :fd_focus.mirror       :=false;
fd_optimise     :sysfd_optimise_ok     :=true;
fd_nooptimise   :sysfd_optimise_ok     :=false;
fd_power        :fd_focus.power255     :=255;
fd_splice       :fd_focus.splice100    :=100;
fd_feather      :fd_focus.feather4     :=find__viFeather;//09apr2026
fd_errors       :sysfd_errors_ok       :=true;
fd_noerrors     :sysfd_errors_ok       :=false;

fd_fillAreaDefaults:begin

   fd_focus.flip      :=false;
   fd_focus.mirror    :=false;
   fd_focus.power255  :=255;
   fd_focus.splice100 :=100;

   end;

fd_roundNone         :fd_focus.rimage:=@resling_nil;

fd_roundCorner       :begin

                      case (find__viScale>=2) of
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

procedure fd__drawText(const x:string;dx,dy:longint);
var
   p:longint;
   f:tresfont;
   v:byte;
begin

//init
f           :=res__font( fd_focus.font );

//get

for p:=1 to low__len32(x) do
begin

v           :=byte(x[p-1+stroffset]);

fd__drawChar( v ,dx ,dy ,0 ,0 ,0 ,0 );

inc( dx, f.wlist[ v ] );

end;//p

end;

procedure fd__drawTextTab(const xtab,x:string;dx,dy:longint);
var
   vw,sv,di,pmax,tx,i,xcolalign,xcolcount,xcolwidth,xtotalwidth,x1,x2,dlimitwidth,xlen,tw,lp,p,lcolindex,fheight:longint;
   xclip,xarea,xcolarea:twinrect;
   f:tresfont;
   v:byte;
   bol1:boolean;
begin


//no tabs ----------------------------------------------------------------------
if (xtab='') then
   begin

   fd__drawText(x,dx,dy);
   exit;

   end;


//tabs -------------------------------------------------------------------------

f           :=res__font( fd_focus.font );
bol1        :=true;
tw          :=0;
lp          :=0;
lcolindex   :=0;
fheight     :=f.height;
xlen        :=low__len32(x);
dlimitwidth :=fd_focus.b.aw;
tx          :=dx;
xclip       :=area__make( fd_focus.b.cx1,fd_focus.b.cy1,fd_focus.b.cx2,fd_focus.b.cy2 );
xarea       :=area__make( fd_focus.b.ax1,fd_focus.b.ay1,fd_focus.b.ax2,fd_focus.b.ay2 );

fd__setarea( fd_clip ,area__clip( xclip, xarea ) );


for p:=0 to (xlen-1) do
begin

v                     :=byte( x[p+stroffset] );

if (v<>ss9) then inc(tw,f.wlist[v]);

if (v=ss9) or (p>=(xlen-1)) then
   begin

   if not font__tab(xtab,lcolindex,fheight,dlimitwidth,xcolalign,xcolcount,xcolwidth,xtotalwidth,x1,x2) then bol1:=false;

   if bol1 then
      begin

      //.xcolarea
      xcolarea.left   :=frcrange32(dx+x1,fd_focus.b.ax1,fd_focus.b.ax2);
      xcolarea.right  :=frcrange32(dx+x2,fd_focus.b.ax1,fd_focus.b.ax2);
      xcolarea.top    :=fd_focus.b.ay1;
      xcolarea.bottom :=fd_focus.b.ay2;

      fd__setarea( fd_area ,xcolarea );

      //.xcolalign
      case xcolalign of
      taC :tx         :=dx+x1+((xcolwidth-tw) div 2);//center
      taR :tx         :=dx+x2;//right
      else tx         :=dx+x1;//left
      end;//case

      //get
      pmax            :=(p-low__insint(1,v=ss9));

      for i:=lp to pmax do//last char adjust if "v=ss9" then don't include this last char - 23feb2021
      begin

      if (xcolalign=taR) then di:=pmax-(i-lp) else di:=i;

      sv              :=byte( x[di+stroffset] );
      vw              :=f.wlist[sv];

      if (xcolalign=taR) then dec(tx,vw);

      fd__drawChar( sv ,tx ,dy ,0 ,0 ,0 ,0 );

      if (xcolalign=taL) or (xcolalign=taC) then inc(tx,vw);

      end;//i

      end

   else break;

   //reset
   if (v=ss9) then inc(lcolindex);

   lp                 :=p+1;
   tw                 :=0;

   end;

end;//p

end;

procedure fd__drawChar(const xcharIndex,dx,dy,dlineTop,dlineHeight,hpos:longint;dbackColor:longint);//07apr2026, 03mar2026, 28feb2026, 19feb2026
var//Note: uses fd_textColor(fd_color1) for text color,
   //           fd_backColor(fd_color2) background char color
   //       and fd_highColor(fd_color3) for highlight color
   f:tresfont;
   c:tbasicrle8;
   c1,c2:tcolor32;
   v1,v2,v,yu,uthick,sx,sy,sw,sh:longint32;
   dmustrestore:boolean;
begin

if fd_focus.b.ok and (xcharIndex>=0) and (xcharIndex<=fontchar_maxindex) and (fd_focus.power255>=1) then
   begin

   //init
   f        :=res__font( fd_focus.font );
   c        :=f.needChar(xcharIndex);

   //check
   if (c.width<=0) then exit;

   //set char area
   with fd_focus.t do
   begin

   w        :=c.width;
   h        :=c.height;

   cx1      :=0;
   cx2      :=w-1;
   cy1      :=0;
   cy2      :=h-1;

   ax1      :=dx;
   ax2      :=dx+w-1;
   ay1      :=dy;
   ay2      :=dy+h-1;

   rows     :=pcolorrows32(c);
   bits     :=8;
   ok       :=true;

   end;


   //char decoration -----------------------------------------------------------
   if (fd_focus.charDecoration<>cdNone) then
      begin

      dmustrestore    :=false;
      sx              :=fd_focus.b.ax1;
      sy              :=fd_focus.b.ay1;
      sw              :=fd_focus.b.aw;
      sh              :=fd_focus.b.ah;
      uthick          :=font__lineThickness( f.height );//underline

      case (dlineHeight>=1) of
      true:yu         :=dlineTop       + dlineHeight - uthick;
      else yu         :=fd_focus.t.ay1 + f.height    - uthick;
      end;//case


      //background color -------------------------------------------------------

      //highlight - 1st priority
      if bit__true32(fd_focus.charDecoration,2) then//cdHighlight
         begin

         //store color
         dmustrestore        :=true;
         c1                  :=fd_focus.color1;//fd_textColor
         dbackColor          :=fd__val( fd_highColor );

         //render
         fd__setarea2( fd_area ,fd_focus.t.ax1 ,fd_focus.t.ay1 ,fd_focus.t.w ,f.height );
         fd__setval( fd_textColor ,dbackColor );
         fd__render( fd_fillarea );

         //restore color
         fd_focus.color1     :=c1;

         end

      //background color - 2nd priority
      else if bit__true32(fd_focus.charDecoration,4) then//cdBackground
         begin

         //store color
         dmustrestore :=true;
         c1                  :=fd_focus.color1;//fd_textColor
         dbackColor          :=fd__val( fd_backColor );

         //render
         fd__setarea2( fd_area ,fd_focus.t.ax1 ,fd_focus.t.ay1 ,fd_focus.t.w ,f.height );
         fd__setval( fd_textColor ,dbackColor );
         fd__render( fd_fillarea );

         //restore color
         fd_focus.color1     :=c1;

         end;


      //underline style --------------------------------------------------------

      //spell - 1st priority
      if bit__true32(fd_focus.charDecoration,3) then//cdSpell
         begin

         //store color
         dmustrestore        :=true;
         c1                  :=fd_focus.color1;
         v1                  :=fd_focus.val1;
         v2                  :=fd_focus.val2;

         //render as dashed line (area)
         fd__setarea( fd_area ,area__make( fd_focus.t.ax1 ,yu ,fd_focus.t.ax2 ,yu+uthick-1) );

         case (dbackColor<>clNone) of
         true:fd__setval( fd_color1 ,int__makevis24(255,dbackColor,100) );//adapt RED to background color
         else fd__setval( fd_color1 ,255 );//use non-adaptive RED
         end;//case
         
         fd__setval( fd_val1   ,2*uthick  );
         fd__setval( fd_val2   ,hpos    );

         fd__render( fd_dashedArea );

         //restore color
         fd_focus.color1     :=c1;
         fd_focus.val1       :=v1;
         fd_focus.val2       :=v2;

         end

      //url - 2nd priority
      else if bit__true32(fd_focus.charDecoration,5) then//cdUrl
         begin

         //store color
         dmustrestore        :=true;
         v1                  :=fd_focus.val1;
         v2                  :=fd_focus.val2;

         //render as dashed line (area)
         fd__setarea2( fd_area ,fd_focus.t.ax1 ,yu ,fd_focus.t.w ,uthick );

         fd__setval( fd_val1   ,uthick  );
         fd__setval( fd_val2   ,hpos    );

         fd__render( fd_dashedArea );

         //restore color
         fd_focus.val1       :=v1;
         fd_focus.val2       :=v2;

         end

      //underline - 3rd priority
      else if bit__true32(fd_focus.charDecoration,0) then//cdUnderline
         begin

         dmustrestore :=true;

         fd__setarea2( fd_area ,fd_focus.t.ax1 ,yu ,fd_focus.t.w ,uthick );
         fd__render( fd_fillarea );

         end;

      //other ------------------------------------------------------------------

      //strikeout
      if bit__true32(fd_focus.charDecoration,1) then//cdStrikeout
         begin

         dmustrestore :=true;

         fd__setarea2( fd_area ,fd_focus.t.ax1 ,fd_focus.t.ay1 + (f.height div 2)-uthick+1 ,fd_focus.t.w ,uthick );
         fd__render( fd_fillarea );

         end;

      //restore area
      if dmustrestore then
         begin

         fd__setarea2( fd_area ,sx ,sy ,sw ,sh );

         end;
      end;


   //render char ---------------------------------------------------------------

   with fd_focus^ do
   begin

   if (t.ax1>=b.cx1) and (t.ax2<=b.cx2) and (t.ay1>=b.cy1) and (t.ay2<=b.cy2) then
      begin

      if fd_focus.write_a then//07apr2026
         begin

         case fd_focus.power255 of
         255    :xfd__drawRLE8_2000_layer_a;
         1..254 :xfd__drawRLE8_2100_layer_power_a;
         end;//case

         end

      else
         begin

         case fd_focus.power255 of
         255    :xfd__drawRLE8_2000_layer;
         1..254 :xfd__drawRLE8_2100_layer_power;
         end;//case

         end;

      end
   else if (t.ax2>=b.cx1) and (t.ax1<=b.cx2) and (t.ay2>=b.cy1) and (t.ay1<=b.cy2) and (t.ax2>=t.ax1) and (t.ay2>=t.ay1) then
      begin

      if fd_focus.write_a then xfd__drawRLE8_2200_cliprange_layer_power_a//07apr2026
      else                     xfd__drawRLE8_2200_cliprange_layer_power;

      end;

   end;//with

   end;

end;

procedure xfd__drawRLE6;//05mar2026
begin

//check
if (not fd_focus.b.ok) or (not fd_focus.b2.ok) or (fd_focus.power255<1) or (fd_focus.b.t<>t_img) or (fd_focus.b2.t<>t_rle6) then exit;

//RLE6 uses "fd_focus.t" information as source/second buffer info -> bare basics only
with fd_focus^ do
begin

if (b2.ax1>=b.cx1) and (b2.ax2<=b.cx2) and (b2.ay1>=b.cy1) and (b2.ay2<=b.cy2) then
   begin

   //init
   t.w         :=b2.w;
   t.h         :=b2.h;
   t.ay1       :=b2.ay1;
   t.ay2       :=b2.ay2;
   t.ax1       :=b2.ax1;
   t.ax2       :=b2.ax2;
   t.rows      :=b2.rows;

   //get
   case power255 of
   255    :xfd__drawRLE6_6000_layer;
   1..254 :xfd__drawRLE6_6100_layer_power;
   end;//case

   end
else if (b2.ax2>=b.cx1) and (b2.ax1<=b.cx2) and (b2.ay2>=b.cy1) and (b2.ay1<=b.cy2) and (b2.ax2>=b2.ax1) and (b2.ay2>=b2.ay1) then
   begin

   //init
   t.w         :=b2.w;
   t.h         :=b2.h;
   t.ay1       :=b2.ay1;
   t.ay2       :=b2.ay2;
   t.ax1       :=b2.ax1;
   t.ax2       :=b2.ax2;
   t.rows      :=b2.rows;

   //get
   xfd__drawRLE6_6200_cliprange_layer_power;

   end;

end;//with

end;

function xfd__drawRLE6_featherPower(const dfeather4:longint32):longint32;//09apr2026
begin

if      (dfeather4<=0) then result:=0
else if (dfeather4>=4) then result:=rle6_featherPower
else                        result:=round32( ( dfeather4 / 4 ) * rle6_featherPower );

end;

procedure xfd__drawRLE6_6000_layer;//06mar2026
label//mps ratings below are for an Intel Core i5 2.5 GHz using "Courier New" at 10pt and 400pt
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   cr,cg,cb,cainv,ca,caFeatherPower:byte;
   vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;

   procedure pa;
   begin

   case ca of

   //transparent
   0:;

   //channel 3
   rle6_channel_root3..255:begin

      case (ca>=rle6_channel_istart3) of
      true:ca         :=( ca-rle6_channel_istart3 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root3   + 1 ) * caFeatherPower;//1..10
      end;//case

      cr              :=(fd_focus.color4.r*ca) shr 8;
      cg              :=(fd_focus.color4.g*ca) shr 8;
      cb              :=(fd_focus.color4.b*ca) shr 8;

      end;

   //channel 2
   rle6_channel_root2..(rle6_channel_root3-1):begin

      case (ca>=rle6_channel_istart2) of
      true:ca         :=( ca-rle6_channel_istart2 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root2   + 1 ) * caFeatherPower;//1..10
      end;//case

      cr              :=(fd_focus.color3.r*ca) shr 8;
      cg              :=(fd_focus.color3.g*ca) shr 8;
      cb              :=(fd_focus.color3.b*ca) shr 8;

      end;

   //channel 1
   rle6_channel_root1..(rle6_channel_root2-1):begin

      case (ca>=rle6_channel_istart1) of
      true:ca         :=( ca-rle6_channel_istart1 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root1   + 1 ) * caFeatherPower;//1..10
      end;//case

      cr              :=(fd_focus.color2.r*ca) shr 8;
      cg              :=(fd_focus.color2.g*ca) shr 8;
      cb              :=(fd_focus.color2.b*ca) shr 8;

      end;

   //channel 0
   rle6_channel_root0..(rle6_channel_root1-1):begin

      case (ca>=rle6_channel_istart0) of
      true:ca         :=( ca-rle6_channel_istart0 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root0   + 1 ) * caFeatherPower;//1..10
      end;//case

      cr              :=(fd_focus.color1.r*ca) shr 8;
      cg              :=(fd_focus.color1.g*ca) shr 8;
      cb              :=(fd_focus.color1.b*ca) shr 8;

      end;

   end;//case

   //cainv
   cainv    :=255-ca;

   end;

begin

//defaults
sysfd_drawProc32      :=6000;

//init
ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;

caFeatherPower        :=xfd__drawRLE6_featherPower( fd_focus.feather4 );
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE6(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE6(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE6(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=6025;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=6024;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=6033;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=6032;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 (200-400mps) ------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 (200-400mps) ------------------------------------------------------

yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE6_6100_layer_power;//06mar2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   cr,cg,cb,cainv,ca,caFeatherPower:byte;
   xpower,vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;

   procedure pa;
   begin

   case ca of

   //transparent
   0:;

   //channel 3
   rle6_channel_root3..255:begin

      case (ca>=rle6_channel_istart3) of
      true:ca         :=( ca-rle6_channel_istart3 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root3   + 1 ) * caFeatherPower;//1..10
      end;//case

      ca              :=(ca*xpower) shr 8;
      cr              :=(fd_focus.color4.r*ca) shr 8;
      cg              :=(fd_focus.color4.g*ca) shr 8;
      cb              :=(fd_focus.color4.b*ca) shr 8;

      end;

   //channel 2
   rle6_channel_root2..(rle6_channel_root3-1):begin

      case (ca>=rle6_channel_istart2) of
      true:ca         :=( ca-rle6_channel_istart2 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root2   + 1 ) * caFeatherPower;//1..10
      end;//case

      ca              :=(ca*xpower) shr 8;
      cr              :=(fd_focus.color3.r*ca) shr 8;
      cg              :=(fd_focus.color3.g*ca) shr 8;
      cb              :=(fd_focus.color3.b*ca) shr 8;

      end;


   //channel 1
   rle6_channel_root1..(rle6_channel_root2-1):begin

      case (ca>=rle6_channel_istart1) of
      true:ca         :=( ca-rle6_channel_istart1 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root1   + 1 ) * caFeatherPower;//1..10
      end;//case

      ca              :=(ca*xpower) shr 8;
      cr              :=(fd_focus.color2.r*ca) shr 8;
      cg              :=(fd_focus.color2.g*ca) shr 8;
      cb              :=(fd_focus.color2.b*ca) shr 8;

      end;


   //channel 0
   rle6_channel_root0..(rle6_channel_root1-1):begin

      case (ca>=rle6_channel_istart0) of
      true:ca         :=( ca-rle6_channel_istart0 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root0   + 1 ) * caFeatherPower;//1..10
      end;//case

      ca              :=(ca*xpower) shr 8;
      cr              :=(fd_focus.color1.r*ca) shr 8;
      cg              :=(fd_focus.color1.g*ca) shr 8;
      cb              :=(fd_focus.color1.b*ca) shr 8;

      end;

   end;//case

   //cainv
   cainv    :=255-ca;

   end;

begin

//defaults
sysfd_drawProc32      :=6100;

//init
ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;

caFeatherPower        :=xfd__drawRLE6_featherPower( fd_focus.feather4 );
xpower                :=fd_focus.power255;
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE6(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE6(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE6(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=6125;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=6124;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=6133;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=6132;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;
   
   end;

if (ca>=1) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 -------------------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE6_6200_cliprange_layer_power;//06mar2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   cr,cg,cb,cainv,ca,caFeatherPower:byte;
   xpower,vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;
   dx1,dx2,dy1,dy2:longint;
   yok:boolean;

   procedure pa;
   begin

   case ca of

   //transparent
   0:;

   //channel 3
   rle6_channel_root3..255:begin

      case (ca>=rle6_channel_istart3) of
      true:ca         :=( ca-rle6_channel_istart3 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root3   + 1 ) * caFeatherPower;//1..10
      end;//case

      ca              :=(ca*xpower) shr 8;
      cr              :=(fd_focus.color4.r*ca) shr 8;
      cg              :=(fd_focus.color4.g*ca) shr 8;
      cb              :=(fd_focus.color4.b*ca) shr 8;

      end;


   //channel 2
   rle6_channel_root2..(rle6_channel_root3-1):begin

      case (ca>=rle6_channel_istart2) of
      true:ca         :=( ca-rle6_channel_istart2 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root2   + 1 ) * caFeatherPower;//1..10
      end;//case

      ca              :=(ca*xpower) shr 8;
      cr              :=(fd_focus.color3.r*ca) shr 8;
      cg              :=(fd_focus.color3.g*ca) shr 8;
      cb              :=(fd_focus.color3.b*ca) shr 8;

      end;

   //channel 1
   rle6_channel_root1..(rle6_channel_root2-1):begin

      case (ca>=rle6_channel_istart1) of
      true:ca         :=( ca-rle6_channel_istart1 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root1   + 1 ) * caFeatherPower;//1..10
      end;//case

      ca              :=(ca*xpower) shr 8;
      cr              :=(fd_focus.color2.r*ca) shr 8;
      cg              :=(fd_focus.color2.g*ca) shr 8;
      cb              :=(fd_focus.color2.b*ca) shr 8;

      end;

   //channel 0
   rle6_channel_root0..(rle6_channel_root1-1):begin

      case (ca>=rle6_channel_istart0) of
      true:ca         :=( ca-rle6_channel_istart0 + 1 ) * rle6_colorDivider;
      else ca         :=( ca-rle6_channel_root0   + 1 ) * caFeatherPower;//1..10
      end;//case

      ca              :=(ca*xpower) shr 8;
      cr              :=(fd_focus.color1.r*ca) shr 8;
      cg              :=(fd_focus.color1.g*ca) shr 8;
      cb              :=(fd_focus.color1.b*ca) shr 8;

      end;

   end;//case

   //cainv
   cainv    :=255-ca;

   end;

begin

//defaults
sysfd_drawProc32      :=6200;

//init
dx1                   :=fd_focus.b.cx1;//target
dx2                   :=fd_focus.b.cx2;
dy1                   :=fd_focus.b.cy1;
dy2                   :=fd_focus.b.cy2;

ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;

caFeatherPower        :=xfd__drawRLE6_featherPower( fd_focus.feather4 );
xpower                :=fd_focus.power255;
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE6(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE6(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE6(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=6225;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=6224;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=6233;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=6232;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 -------------------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   pa;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE8;//05mar2026
begin

//check
if (not fd_focus.b.ok) or (not fd_focus.b2.ok) or (fd_focus.power255<1) or (fd_focus.b.t<>t_img) or (fd_focus.b2.t<>t_rle8) then exit;

//RLE8 uses "fd_focus.t" information as source/second buffer info -> bare basics only
with fd_focus^ do
begin

if (b2.ax1>=b.cx1) and (b2.ax2<=b.cx2) and (b2.ay1>=b.cy1) and (b2.ay2<=b.cy2) then
   begin

   //init
   t.w         :=b2.w;
   t.h         :=b2.h;
   t.ay1       :=b2.ay1;
   t.ay2       :=b2.ay2;
   t.ax1       :=b2.ax1;
   t.ax2       :=b2.ax2;
   t.rows      :=b2.rows;

   //get
   if fd_focus.write_a then
      begin

      case power255 of
      255    :xfd__drawRLE8_2000_layer_a;
      1..254 :xfd__drawRLE8_2100_layer_power_a;
      end;//case

      end

   else

      begin

      case power255 of
      255    :xfd__drawRLE8_2000_layer;
      1..254 :xfd__drawRLE8_2100_layer_power;
      end;//case

      end;


   end
else if (b2.ax2>=b.cx1) and (b2.ax1<=b.cx2) and (b2.ay2>=b.cy1) and (b2.ay1<=b.cy2) and (b2.ax2>=b2.ax1) and (b2.ay2>=b2.ay1) then
   begin

   //init
   t.w         :=b2.w;
   t.h         :=b2.h;
   t.ay1       :=b2.ay1;
   t.ay2       :=b2.ay2;
   t.ax1       :=b2.ax1;
   t.ax2       :=b2.ax2;
   t.rows      :=b2.rows;

   //get
   if fd_focus.write_a then xfd__drawRLE8_2200_cliprange_layer_power_a
   else                     xfd__drawRLE8_2200_cliprange_layer_power;


   end;

end;//with

end;

function xfd__drawRLE8_featherPower(const dfeather4:longint32):longint32;//09apr2026
begin

if      (dfeather4<=0) then result:=0
else if (dfeather4>=4) then result:=rle8_featherPower
else                        result:=round32( ( dfeather4 / 4 ) * rle8_featherPower );

end;

procedure xfd__drawRLE8_2000_layer;//23feb2026
label//mps ratings below are for an Intel Core i5 2.5 GHz using "Courier New" at 10pt and 400pt
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   cr,cg,cb,cainv,ca,caFeatherPower:byte;
   vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;

begin

//defaults
sysfd_drawProc32      :=2000;

//init
ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;

caFeatherPower        :=xfd__drawRLE8_featherPower( fd_focus.feather4 );
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE8(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE8(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE8(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2025;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=2024;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2033;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=2032;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 (200-400mps) ------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 (200-400mps) ------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE8_2100_layer_power;//23feb2026
label//mps ratings below are for an Intel Core i5 2.5 GHz using "Courier New" at 10pt and 400pt
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   cr,cg,cb,cainv,ca,caFeatherPower:byte;
   xpower,vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;

begin

//defaults
sysfd_drawProc32      :=2100;

//init
ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;

caFeatherPower        :=xfd__drawRLE8_featherPower( fd_focus.feather4 );
xpower                :=fd_focus.power255;
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE8(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE8(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE8(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2125;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=2124;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2133;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=2132;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 (200-400mps) ------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 (200-400mps) ------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE8_2200_cliprange_layer_power;//23feb2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   cr,cg,cb,cainv,ca,caFeatherPower:byte;
   xpower,vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;
   dx1,dx2,dy1,dy2:longint;
   yok:boolean;

begin

//defaults
sysfd_drawProc32      :=2200;

//init
dx1                   :=fd_focus.b.cx1;//target
dx2                   :=fd_focus.b.cx2;
dy1                   :=fd_focus.b.cy1;
dy2                   :=fd_focus.b.cy2;

ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;

caFeatherPower        :=xfd__drawRLE8_featherPower( fd_focus.feather4 );
xpower                :=fd_focus.power255;
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE8(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE8(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE8(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2225;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=2224;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2233;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=2232;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 -------------------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE8_2000_layer_a;//07apr2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   c32   :tcolor32;
   vlist :pdlbyte;
   cr,cg,cb,cainv,ca,caFeatherPower:byte;
   vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;

begin

//defaults
sysfd_drawProc32      :=2000;

//init
ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;

caFeatherPower        :=xfd__drawRLE8_featherPower( fd_focus.feather4 );
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE8(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE8(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE8(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2025;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=2024;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2033;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=2032;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   c32.r    :=fd_focus.color1.r;
   c32.g    :=fd_focus.color1.g;
   c32.b    :=fd_focus.color1.b;
   c32.a    :=ca;

   end;

if (ca>=1) then
   begin

   dr32[dy][dx]:=c32;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   c32.r    :=fd_focus.color1.r;
   c32.g    :=fd_focus.color1.g;
   c32.b    :=fd_focus.color1.b;
   c32.a    :=ca;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   dr32[dy][dx]:=c32;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 -------------------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE8_2100_layer_power_a;//07apr2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   cr,cg,cb,caa,cainv,ca,caFeatherPower:byte;
   xpower,vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;

begin

//defaults
sysfd_drawProc32      :=2100;

//init
ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;
caa                   :=0;

caFeatherPower        :=xfd__drawRLE8_featherPower( fd_focus.feather4 );
xpower                :=fd_focus.power255;
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE8(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE8(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE8(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2125;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=2124;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2133;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=2132;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;
   caa      :=(255              *ca) shr 8;

   end;

if (ca>=1) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;
   s32.a    :=((cainv*s32.a) shr 8) + caa;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;
   caa      :=(255              *ca) shr 8;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;
   s32.a    :=((cainv*s32.a) shr 8) + caa;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 (200-400mps) ------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE8_2200_cliprange_layer_power_a;//07apr2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   cr,cg,cb,caa,cainv,ca,caFeatherPower:byte;
   xpower,vlen,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;
   dx1,dx2,dy1,dy2:longint;
   yok:boolean;

begin

//defaults
sysfd_drawProc32      :=2200;

//init
dx1                   :=fd_focus.b.cx1;//target
dx2                   :=fd_focus.b.cx2;
dy1                   :=fd_focus.b.cy1;
dy2                   :=fd_focus.b.cy2;

ca                    :=0;
cainv                 :=255-ca;
cr                    :=0;
cg                    :=0;
cb                    :=0;
caa                   :=0;

caFeatherPower        :=xfd__drawRLE8_featherPower( fd_focus.feather4 );
xpower                :=fd_focus.power255;
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE8(fd_focus.t.rows).core.core;
vlen                  :=tbasicRLE8(fd_focus.t.rows).core.len32-1;
vcount                :=1;
vpos                  :=tbasicRLE8(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2225;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=2224;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=2233;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=2232;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;
   caa      :=(255              *ca) shr 8;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;
   s32.a    :=((cainv*s32.a) shr 8) + caa;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;
   caa      :=(255              *ca) shr 8;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((cainv*s32.r) shr 8) + cr;
   s32.g    :=((cainv*s32.g) shr 8) + cg;
   s32.b    :=((cainv*s32.b) shr 8) + cb;
   s32.a    :=((cainv*s32.a) shr 8) + caa;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 -------------------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vlen) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   ca       :=vlist[vpos];
   vcount   :=vlist[vpos+1]+1;

   inc(vpos,2);

   //.system feather
   case ca of
   1..rle8_featherCount:ca :=ca* caFeatherPower;
   end;//case

   ca       :=(ca*xpower) shr 8;
   cainv    :=255-ca;

   cr       :=(fd_focus.color1.r*ca) shr 8;
   cg       :=(fd_focus.color1.g*ca) shr 8;
   cb       :=(fd_focus.color1.b*ca) shr 8;

   end;

if (ca>=1) and yok and (dx>=dx1) and (dx<=dx2) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((cainv*s24.r) shr 8) + cr;
   s24.g    :=((cainv*s24.g) shr 8) + cg;
   s24.b    :=((cainv*s24.b) shr 8) + cb;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE32;//20mar2026
begin

//check
if (not fd_focus.b.ok) or (not fd_focus.b2.ok) or (fd_focus.power255<1) or (fd_focus.b.t<>t_img) or (fd_focus.b2.t<>t_rle32) then exit;

//RLE32 uses "fd_focus.t" information as source/second buffer info -> bare basics only
with fd_focus^ do
begin

if (b2.ax1>=b.cx1) and (b2.ax2<=b.cx2) and (b2.ay1>=b.cy1) and (b2.ay2<=b.cy2) then
   begin

   //init
   t.w         :=b2.w;
   t.h         :=b2.h;
   t.ay1       :=b2.ay1;
   t.ay2       :=b2.ay2;
   t.ax1       :=b2.ax1;
   t.ax2       :=b2.ax2;
   t.rows      :=b2.rows;

   //get
   case power255 of
   255    :xfd__drawRLE32_5000_layer;
   1..254 :xfd__drawRLE32_5100_layer_power;
   end;//case

   end
else if (b2.ax2>=b.cx1) and (b2.ax1<=b.cx2) and (b2.ay2>=b.cy1) and (b2.ay1<=b.cy2) and (b2.ax2>=b2.ax1) and (b2.ay2>=b2.ay1) then
   begin

   //init
   t.w         :=b2.w;
   t.h         :=b2.h;
   t.ay1       :=b2.ay1;
   t.ay2       :=b2.ay2;
   t.ax1       :=b2.ax1;
   t.ax2       :=b2.ax2;
   t.rows      :=b2.rows;

   //get
   xfd__drawRLE32_5200_cliprange_layer_power;

   end;

end;//with

end;

function xfd__drawRLE32_featherPower(const dfeather4:longint32):longint32;//09apr2026
begin

if      (dfeather4<=0) then result:=0
else if (dfeather4>=4) then result:=rle32_featherPower
else                        result:=round32( ( dfeather4 / 4 ) * rle32_featherPower );

end;

procedure xfd__drawRLE32_5000_layer;//20mar2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   ainv,r,g,b,a,caFeatherPower:longint;//byte;
   vstop,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;

begin


//defaults
sysfd_drawProc32      :=5000;

//init

caFeatherPower        :=xfd__drawRLE32_featherPower( fd_focus.feather4 );
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE32(fd_focus.t.rows).core.core;
vstop                 :=tbasicRLE32(fd_focus.t.rows).core.len32-4;
vcount                :=1;
vpos                  :=tbasicRLE32(fd_focus.t.rows).headLen;


//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=5025;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=5024;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=5033;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=5032;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((ainv*s32.r) shr 8) + r;
   s32.g    :=((ainv*s32.g) shr 8) + g;
   s32.b    :=((ainv*s32.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((ainv*s32.r) shr 8) + r;
   s32.g    :=((ainv*s32.g) shr 8) + g;
   s32.b    :=((ainv*s32.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 -------------------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((ainv*s24.r) shr 8) + r;
   s24.g    :=((ainv*s24.g) shr 8) + g;
   s24.b    :=((ainv*s24.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((ainv*s24.r) shr 8) + r;
   s24.g    :=((ainv*s24.g) shr 8) + g;
   s24.b    :=((ainv*s24.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE32_5100_layer_power;//20mar2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   xpower,ainv,r,g,b,a,caFeatherPower:longint;
   vstop,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;

begin


//defaults
sysfd_drawProc32      :=5100;

//init

caFeatherPower        :=xfd__drawRLE32_featherPower( fd_focus.feather4 );
xpower                :=fd_focus.power255;
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE32(fd_focus.t.rows).core.core;
vstop                 :=tbasicRLE32(fd_focus.t.rows).core.len32-4;
vcount                :=1;
vpos                  :=tbasicRLE32(fd_focus.t.rows).headLen;


//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=5125;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=5124;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=5133;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=5132;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   a        :=( a * xpower ) shr 8;
   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((ainv*s32.r) shr 8) + r;
   s32.g    :=((ainv*s32.g) shr 8) + g;
   s32.b    :=((ainv*s32.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   a        :=( a * xpower ) shr 8;
   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((ainv*s32.r) shr 8) + r;
   s32.g    :=((ainv*s32.g) shr 8) + g;
   s32.b    :=((ainv*s32.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 -------------------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   a        :=( a * xpower ) shr 8;
   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((ainv*s24.r) shr 8) + r;
   s24.g    :=((ainv*s24.g) shr 8) + g;
   s24.b    :=((ainv*s24.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   a        :=( a * xpower ) shr 8;
   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((ainv*s24.r) shr 8) + r;
   s24.g    :=((ainv*s24.g) shr 8) + g;
   s24.b    :=((ainv*s24.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

procedure xfd__drawRLE32_5200_cliprange_layer_power;//21mar2026
label
   xredo8_24,yredo8_24,xredo8_32,yredo8_32,
   lxredo8_24,lyredo8_24,lxredo8_32,lyredo8_32;

var
   lr8   :pcolorrows8;
   dr24  :pcolorrows24;
   dr32  :pcolorrows32;
   s8    :pcolor8;
   s24   :pcolor24;
   s32   :pcolor32;
   vlist :pdlbyte;
   xpower,ainv,r,g,b,a,caFeatherPower:longint;
   vstop,vpos,vcount,lv8,dstopX,dstopY,dresetX,dx,dy:longint32;
   dx1,dx2,dy1,dy2:longint;
   yok:boolean;

begin

//defaults
sysfd_drawProc32      :=5200;

//init
dx1                   :=fd_focus.b.cx1;//target
dx2                   :=fd_focus.b.cx2;
dy1                   :=fd_focus.b.cy1;
dy2                   :=fd_focus.b.cy2;

caFeatherPower        :=xfd__drawRLE32_featherPower( fd_focus.feather4 );
xpower                :=fd_focus.power255;
lv8                   :=fd_focus.lv8;

//.y
dy                    :=fd_focus.t.ay1;//dy
dstopY                :=fd_focus.t.ay2;//dy2

//.x
dresetX               :=fd_focus.t.ax1;//dx
dstopX                :=fd_focus.t.ax2;//dx2

//.source buffer
vlist                 :=tbasicRLE32(fd_focus.t.rows).core.core;
vstop                 :=tbasicRLE32(fd_focus.t.rows).core.len32-4;
vcount                :=1;
vpos                  :=tbasicRLE32(fd_focus.t.rows).headLen;

//.target buffer
case fd_focus.b.bits of
24:begin

   dr24               :=pcolorrows24(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=5225;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_24;

      end;
   else begin

      sysfd_drawProc32   :=5224;
      goto yredo8_24;

      end;
   end;//case

   end;

32:begin

   dr32               :=pcolorrows32(fd_focus.b.rows);

   case (lv8>=0) of
   true:begin

      sysfd_drawProc32   :=5233;
      lr8                :=pcolorrows8( fd_focus.lr8 );
      goto lyredo8_32;

      end;
   else begin

      sysfd_drawProc32   :=5232;
      goto yredo8_32;

      end;
   end;//case

   end;
else exit;
end;//case


//render8_32 -------------------------------------------------------------------
yredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

xredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   a        :=( a * xpower ) shr 8;
   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) and yok and (dx>=dx1) and (dx<=dx2) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((ainv*s32.r) shr 8) + r;
   s32.g    :=((ainv*s32.g) shr 8) + g;
   s32.b    :=((ainv*s32.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_32;

   end;

//done
xfd__inc64;
exit;


//lrender8_32 ------------------------------------------------------------------
lyredo8_32:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

lxredo8_32:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   a        :=( a * xpower ) shr 8;
   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) and yok and (dx>=dx1) and (dx<=dx2) and (lr8[dy][dx]=lv8) then
   begin

   s32      :=@dr32[dy][dx];

   s32.r    :=((ainv*s32.r) shr 8) + r;
   s32.g    :=((ainv*s32.g) shr 8) + g;
   s32.b    :=((ainv*s32.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_32;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_32;

   end;

//done
xfd__inc64;
exit;


//render8_24 -------------------------------------------------------------------
yredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

xredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   a        :=( a * xpower ) shr 8;
   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) and yok and (dx>=dx1) and (dx<=dx2) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((ainv*s24.r) shr 8) + r;
   s24.g    :=((ainv*s24.g) shr 8) + g;
   s24.b    :=((ainv*s24.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo8_24;

   end;

//done
xfd__inc64;
exit;


//lrender8_24 ------------------------------------------------------------------
lyredo8_24:

xfd__inc32(fd_focus.t.w);
dx  :=dresetX;
yok :=(dy>=dy1) and (dy<=dy2);

lxredo8_24:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then
      begin

      xfd__inc64;
      exit;

      end;

   //get
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a :=a* caFeatherPower;
   end;//case

   a        :=( a * xpower ) shr 8;
   ainv     :=255-a;

   //adjust
   b        :=( vlist[vpos+0] * a ) shr 8;
   g        :=( vlist[vpos+1] * a ) shr 8;
   r        :=( vlist[vpos+2] * a ) shr 8;

   //inc
   inc(vpos,5);

   end;

if (a>=1) and yok and (dx>=dx1) and (dx<=dx2) and (lr8[dy][dx]=lv8) then
   begin

   s24      :=@dr24[dy][dx];

   s24.r    :=((ainv*s24.r) shr 8) + r;
   s24.g    :=((ainv*s24.g) shr 8) + g;
   s24.b    :=((ainv*s24.b) shr 8) + b;

   end;

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto lxredo8_24;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto lyredo8_24;

   end;

//done
xfd__inc64;

end;

function fd__bol(const xcode:longint32):boolean;
begin

case xcode of

fd_flip         :result:=fd_focus.flip;
fd_noflip       :result:=not fd_focus.flip;
fd_mirror       :result:=fd_focus.mirror;
fd_nomirror     :result:=not fd_focus.mirror;
fd_optimise     :result:=sysfd_optimise_ok;
fd_nooptimise   :result:=not sysfd_optimise_ok;
fd_power        :result:=(fd_focus.power255 >=1 );
fd_splice       :result:=(fd_focus.splice100>=1 );
fd_feather      :result:=(fd_focus.feather4 >=1 );
fd_errors       :result:=sysfd_errors_ok;
fd_noerrors     :result:=not sysfd_errors_ok;
fd_val1         :result:=boolean(fd_focus.val1);
fd_val2         :result:=boolean(fd_focus.val2);
fd_val3         :result:=boolean(fd_focus.val3);

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

fd_flip         :fd_focus.flip         :=xval;
fd_noflip       :fd_focus.flip         :=false;
fd_mirror       :fd_focus.mirror       :=xval;
fd_nomirror     :fd_focus.mirror       :=false;
fd_optimise     :sysfd_optimise_ok     :=xval;
fd_nooptimise   :sysfd_optimise_ok     :=false;
fd_power        :if xval then fd_focus.power255  :=255  else fd_focus.power255  :=0;
fd_splice       :if xval then fd_focus.splice100 :=100  else fd_focus.splice100 :=0;
fd_feather      :if xval then fd_focus.feather4  :=4    else fd_focus.feather4  :=0;
fd_errors       :sysfd_errors_ok       :=xval;
fd_noerrors     :sysfd_errors_ok       :=false;
fd_val1         :fd_focus.val1         :=longint32(xval);
fd_val2         :fd_focus.val2         :=longint32(xval);
fd_val3         :fd_focus.val3         :=longint32(xval);

else
   begin

   fd__showerror(fd_propertyMismatch,xcode);

   end;
end;//case

end;

function fd__val(const xcode:longint):longint32;
begin

case xcode of

fd_pixelcount   :result:=restrict32(sysfd_pixelcount64);
fd_flip         :result:=longint32(fd_focus.flip);
fd_noflip       :result:=longint32(not fd_focus.flip);
fd_mirror       :result:=longint32(fd_focus.mirror);
fd_nomirror     :result:=longint32(not fd_focus.mirror);
fd_optimise     :result:=longint32(sysfd_optimise_ok);
fd_nooptimise   :result:=longint32(not sysfd_optimise_ok);
fd_power        :result:=fd_focus.power255;
fd_splice       :result:=fd_focus.splice100;//07jan2026
fd_feather      :result:=fd_focus.feather4;//09apr2026
fd_errors       :result:=longint32(sysfd_errors_ok);
fd_noerrors     :result:=longint32(not sysfd_errors_ok);

fd_drawProc   :result:=sysfd_drawproc32;

fd_AreaMode:begin

   case fd_focus.b.ok of
   true:result:=fd_focus.b.amode;
   else result:=fd_area_outside_clip;
   end;//case

   end;

fd_ClipMode:begin

   case fd_focus.b.ok of
   true:result:=fd_area_inside_clip;
   else result:=fd_area_outside_clip;
   end;//case

   end;

fd_AreaMode2:begin

   case fd_focus.b2.ok of
   true:result:=fd_focus.b2.amode;
   else result:=fd_area_outside_clip;
   end;//case

   end;

fd_ClipMode2:begin

   case fd_focus.b2.ok of
   true:result:=fd_area_inside_clip;
   else result:=fd_area_outside_clip;
   end;//case

   end;

fd_color1:result:=c32__int(fd_focus.color1);

fd_color2:result:=c32__int(fd_focus.color2);

fd_color3:result:=c32__int(fd_focus.color3);

fd_color4:result:=c32__int(fd_focus.color4);

fd_val1  :result:=fd_focus.val1;//03mar2026
fd_val2  :result:=fd_focus.val2;
fd_val3  :result:=fd_focus.val3;

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

fd_flip         :fd_focus.flip         :=(xval>=1);
fd_noflip       :fd_focus.flip         :=false;
fd_mirror       :fd_focus.mirror       :=(xval>=1);
fd_nomirror     :fd_focus.mirror       :=false;
fd_optimise     :sysfd_optimise_ok     :=(xval>=1);
fd_nooptimise   :sysfd_optimise_ok     :=false;

fd_power:begin

   if      (xval<0)   then fd_focus.power255:=0
   else if (xval>255) then fd_focus.power255:=255
   else                    fd_focus.power255:=xval;

   end;

fd_splice:begin

   if      (xval<0)   then fd_focus.splice100:=0
   else if (xval>100) then fd_focus.splice100:=100
   else                    fd_focus.splice100:=xval;

   end;

fd_feather:begin//09apr2026

   if      (xval<0)   then fd_focus.feather4:=0
   else if (xval>4)   then fd_focus.feather4:=4
   else                    fd_focus.feather4:=xval;

   end;

fd_errors       :sysfd_errors_ok       :=(xval>=1);
fd_noerrors     :sysfd_errors_ok       :=false;

fd_font            :fd_focus.font             :=xval;//25feb2026
fd_charDecoration  :fd_focus.charDecoration   :=xval;//25feb2026

fd_layer:begin

   if (fd_focus.lr8=nil) then fd_focus.lv8:=-1
   else if (xval<-1)     then fd_focus.lv8:=-1
   else if (xval>255)    then fd_focus.lv8:=255
   else                       fd_focus.lv8:=xval;

   end;

fd_color1      :fd_focus.color1           :=int__c32(xval);

fd_color2      :fd_focus.color2           :=int__c32(xval);

fd_color3      :fd_focus.color3           :=int__c32(xval);

fd_color4      :fd_focus.color4           :=int__c32(xval);

fd_val1        :fd_focus.val1             :=xval;//03mar2026
fd_val2        :fd_focus.val2             :=xval;
fd_val3        :fd_focus.val3             :=xval;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

function fd__val64(const xcode:longint):longint64;
begin

case xcode of

fd_pixelcount   :result:=sysfd_pixelcount64;

else             result:=fd__val(xcode);

end;//case

end;

procedure fd__setval64(const xcode:longint;const xval:longint64);
begin

case xcode of

fd_pixelcount:begin

   sysfd_pixelcount64:=xval;
   sysfd_pixelcount32:=0;

   end;

else fd__setval(xcode ,restrict32(xval) );

end;//case

end;

procedure fd__rgba(const xcode:longint;var r,g,b,a:byte);
var
   c32:tcolor32;
begin

case xcode of

fd_color1:begin

   r  :=fd_focus.color1.r;
   g  :=fd_focus.color1.g;
   b  :=fd_focus.color1.b;
   a  :=fd_focus.color1.a;

   end;

fd_color2:begin

   r  :=fd_focus.color2.r;
   g  :=fd_focus.color2.g;
   b  :=fd_focus.color2.b;
   a  :=fd_focus.color2.a;

   end;

fd_color3:begin

   r  :=fd_focus.color3.r;
   g  :=fd_focus.color3.g;
   b  :=fd_focus.color3.b;
   a  :=fd_focus.color3.a;

   end;

fd_color4:begin

   r  :=fd_focus.color4.r;
   g  :=fd_focus.color4.g;
   b  :=fd_focus.color4.b;
   a  :=fd_focus.color4.a;

   end;

fd_val1:int__rgba(fd_focus.val1,r,g,b,a);
fd_val2:int__rgba(fd_focus.val2,r,g,b,a);
fd_val3:int__rgba(fd_focus.val3,r,g,b,a);

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

fd_color1:begin

   fd_focus.color1.r  :=r;
   fd_focus.color1.g  :=g;
   fd_focus.color1.b  :=b;
   fd_focus.color1.a  :=a;

   end;

fd_color2:begin

   fd_focus.color2.r  :=r;
   fd_focus.color2.g  :=g;
   fd_focus.color2.b  :=b;
   fd_focus.color2.a  :=a;

   end;

fd_color3:begin

   fd_focus.color3.r  :=r;
   fd_focus.color3.g  :=g;
   fd_focus.color3.b  :=b;
   fd_focus.color3.a  :=a;

   end;

fd_color4:begin

   fd_focus.color4.r  :=r;
   fd_focus.color4.g  :=g;
   fd_focus.color4.b  :=b;
   fd_focus.color4.a  :=a;

   end;

fd_val1:fd_focus.val1:=rgba__int(r,g,b,a);
fd_val2:fd_focus.val2:=rgba__int(r,g,b,a);
fd_val3:fd_focus.val3:=rgba__int(r,g,b,a);

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

function fd__area(const xcode:longint):twinrect;
begin

case xcode of

fd_area:begin

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

fd_clip:begin

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

fd_bufferarea:begin

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

fd_area2:begin

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

fd_clip2:begin

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

fd_bufferarea2:begin

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

procedure fd__area2(const xcode:longint;var x,y,w,h:longint32);
begin

case xcode of

fd_area:begin

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

fd_clip:begin

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

fd_bufferarea:begin

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

fd_area2:begin

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

fd_clip2:begin

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

fd_bufferarea2:begin

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

fd_area:if fd_focus.b.ok then
   begin

   fd_focus.b.ax1   :=x.left;
   fd_focus.b.ax2   :=x.right;
   fd_focus.b.ay1   :=x.top;
   fd_focus.b.ay2   :=x.bottom;
   fd_focus.b.aw    :=x.right-x.left+1;
   fd_focus.b.ah    :=x.bottom-x.top+1;

   xfd__sync_amode( fd_focus.b );

   end;

fd_clip:if fd_focus.b.ok then
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

fd_area2:if fd_focus.b2.ok then
   begin

   fd_focus.b2.ax1  :=x.left;
   fd_focus.b2.ax2  :=x.right;
   fd_focus.b2.ay1  :=x.top;
   fd_focus.b2.ay2  :=x.bottom;
   fd_focus.b2.aw   :=x.right-x.left+1;
   fd_focus.b2.ah   :=x.bottom-x.top+1;

   xfd__sync_amode( fd_focus.b2 );

   end;

fd_clip2:if fd_focus.b2.ok then
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

fd_area12:begin//set both areas at once

   fd__setarea( fd_area  ,x );
   fd__setarea( fd_area2 ,x );

   end;

fd_clip12:begin//set both clips at once

   fd__setarea( fd_clip  ,x );
   fd__setarea( fd_clip2 ,x );

   end;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__setarea2(const xcode,x,y,w,h:longint32);
begin

case xcode of

fd_area:if fd_focus.b.ok then
   begin

   fd_focus.b.ax1   :=x;
   fd_focus.b.ax2   :=x+w-1;
   fd_focus.b.ay1   :=y;
   fd_focus.b.ay2   :=y+h-1;
   fd_focus.b.aw    :=w;
   fd_focus.b.ah    :=h;

   xfd__sync_amode( fd_focus.b );

   end;

fd_clip:if fd_focus.b.ok then
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

fd_area2:if fd_focus.b2.ok then
   begin

   fd_focus.b2.ax1  :=x;
   fd_focus.b2.ax2  :=x+w-1;
   fd_focus.b2.ay1  :=y;
   fd_focus.b2.ay2  :=y+h-1;
   fd_focus.b2.aw   :=w;
   fd_focus.b2.ah   :=h;

   xfd__sync_amode( fd_focus.b2 );

   end;

fd_clip2:if fd_focus.b2.ok then
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

fd_area12:begin//set both areas at once

   fd__setarea2( fd_area  ,x ,y ,w ,h );
   fd__setarea2( fd_area2 ,x ,y ,w ,h );

   end;

fd_clip12:begin//set both clips at once

   fd__setarea2( fd_clip  ,x ,y ,w ,h );
   fd__setarea2( fd_clip2 ,x ,y ,w ,h );

   end;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__moveto(const xcode,x,y:longint32);//move area defined by "fd_area" and "fd_area2" - 06mar2026
begin

case xcode of

fd_area:if fd_focus.b.ok then
   begin

   fd_focus.b.ax1     :=x;
   fd_focus.b.ax2     :=x+fd_focus.b.aw-1;
   fd_focus.b.ay1     :=y;
   fd_focus.b.ay2     :=y+fd_focus.b.ah-1;

   xfd__sync_amode( fd_focus.b );

   end;

fd_area2:if fd_focus.b2.ok then
   begin

   fd_focus.b2.ax1    :=x;
   fd_focus.b2.ax2    :=x+fd_focus.b2.aw-1;
   fd_focus.b2.ay1    :=y;
   fd_focus.b2.ay2    :=y+fd_focus.b2.ah-1;

   xfd__sync_amode( fd_focus.b2 );

   end;

fd_area12:begin//set both areas at once

   fd__moveto( fd_area  ,x ,y );
   fd__moveto( fd_area2 ,x ,y );

   end;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__movetoX(const xcode,x:longint32);
begin

case xcode of

fd_area:if fd_focus.b.ok then
   begin

   fd_focus.b.ax1     :=x;
   fd_focus.b.ax2     :=x+fd_focus.b.aw-1;

   xfd__sync_amode( fd_focus.b );

   end;

fd_area2:if fd_focus.b2.ok then
   begin

   fd_focus.b2.ax1    :=x;
   fd_focus.b2.ax2    :=x+fd_focus.b2.aw-1;

   xfd__sync_amode( fd_focus.b2 );

   end;

fd_area12:begin//set both areas at once

   fd__movetoX( fd_area  ,x );
   fd__movetoX( fd_area2 ,x );

   end;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__movetoY(const xcode,y:longint32);
begin

case xcode of

fd_area:if fd_focus.b.ok then
   begin

   fd_focus.b.ay1     :=y;
   fd_focus.b.ay2     :=y+fd_focus.b.ah-1;

   xfd__sync_amode( fd_focus.b );

   end;

fd_area2:if fd_focus.b2.ok then
   begin

   fd_focus.b2.ay1    :=y;
   fd_focus.b2.ay2    :=y+fd_focus.b2.ah-1;

   xfd__sync_amode( fd_focus.b2 );

   end;

fd_area12:begin//set both areas at once

   fd__movetoY( fd_area  ,y );
   fd__movetoY( fd_area2 ,y );

   end;

else fd__showerror(fd_propertyMismatch,xcode);

end;//case

end;

procedure fd__setbuffer(const xcode:longint32;const xval:tobject);//06mar2026
var
   f:pfastdrawbuffer;
begin

//get
case xcode of

fd_buffer  :f:=@fd_focus.b;

fd_buffer2 :f:=@fd_focus.b2;

fd_buffer12:begin

   fd__setbuffer( fd_buffer  ,xval );
   fd_focus.b2:=fd_focus.b;
   exit;

   end;

fd_bufferFromBuffer2:begin

   fd_focus.b:=fd_focus.b2;
   exit;

   end;

fd_buffer2FromBuffer:begin

   fd_focus.b2:=fd_focus.b;
   exit;

   end;

else
   begin

   fd__showerror(fd_propertyMismatch,xcode);
   exit;

   end;

end;//case


//host is an image
if misok2432( xval ,f.bits ,f.w ,f.h ) then
   begin

   misrows32( xval ,f.rows );
   f.t        :=t_img;

   end

//host is a tbasicRLE6 - 05mar2026
else if (xval is tbasicRLE6) then
   begin

   with (xval as tbasicRLE6) do
   begin

   f.w        :=width;
   f.h        :=height;
   f.rows     :=pcolorrows32( xval );
   f.bits     :=8;
   f.t        :=t_rle6;

   end;

   end

//host is a tbasicRLE8 - 05mar2026
else if (xval is tbasicRLE8) then
   begin

   with (xval as tbasicRLE8) do
   begin

   f.w        :=width;
   f.h        :=height;
   f.rows     :=pcolorrows32( xval );
   f.bits     :=8;
   f.t        :=t_rle8;

   end;

   end

//host is a tbasicRLE32 - 05mar2026
else if (xval is tbasicRLE32) then
   begin

   with (xval as tbasicRLE32) do
   begin

   f.w        :=width;
   f.h        :=height;
   f.rows     :=pcolorrows32( xval );
   f.bits     :=32;
   f.t        :=t_rle32;

   end;

   end

//host is a GUI

{$ifdef gui}
else if (xval is tbasicsystem) then
   begin

   with (xval as tbasicsystem) do
   begin

   f.w        :=frcmax32( width  ,buffer.width  );
   f.h        :=frcmax32( height ,buffer.height );
   f.rows     :=buffer.prows32;
   f.bits     :=buffer.bits;
   f.t        :=t_img;

   end;

   end
{$endif}

//host is not valid
else begin

   with fd_focus.b do
   begin

   w          :=0;
   h          :=0;
   bits       :=0;
   rows       :=nil;
   f.t        :=t_nil;

   end;

   end;

//sync
f.ok        :=(f.w>=1) and (f.h>=1) and (f.bits>=1) and (f.rows<>nil);//06mar2026

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

//host is an image
if misok82432( xval ,sbits ,sw ,sh ) then
   begin

   case (sbits=8) and (sw>=fd_focus.b.w) and (sh>=fd_focus.b.h) of
   true:misrows8( xval ,fd_focus.lr8 );
   else fd_focus.lr8:=nil;
   end;//case

   end

//host is a GUI

{$ifdef gui}
else if (xval is tbasicsystem) then
   begin

   with (xval as tbasicsystem) do
   begin

   case (mask.width>=fd_focus.b.w) and (mask.height>=fd_focus.b.h) of
   true:fd_focus.lr8:=mask.prows8;
   else fd_focus.lr8:=nil;
   end;//case

   end;

   end
{$endif}

//host is not valid
else begin

   fd_focus.lr8:=nil;

   end;

//defaults
fd_focus.lv8:=-1;

end;

procedure fd__setframe(const xframeName:string;const xframeData:tstr8;xsize,xcolor1,xcolor2:longint32);//28mar2026
label
   skipend;

var
   p,xslot,xpos,dminsize,dsize,dcolor1,dcolor2,sframesize,sremsize,rname,rdata:longint32;

begin

//init
case (xsize<=0) or (str__len32(@xframeData)<=0) of
true:begin

   xsize              :=0;
   rname              :=0;
   rdata              :=0;

   end;
else begin

   xsize              :=frcrange32( xsize ,0 ,fd_frameLimit );
   rname              :=low__ref32u(xframeName);
   rdata              :=low__crc32nonzero( xframeData );

   end;
end;//case

//colors
if (xcolor1=clnone)  then xcolor1:=int_255_255_255;
if (xcolor2=clnone)  then xcolor2:=int_128_128_128;


//check
if (fd_focus.frame.size=xsize)      and (fd_focus.frame.lname=rname)     and (fd_focus.frame.ldata=rdata) and
   (fd_focus.frame.lcolor1=xcolor1) and (fd_focus.frame.lcolor2=xcolor2) then exit;

//get
fd_focus.frame.size   :=xsize;
fd_focus.frame.lname  :=rname;
fd_focus.frame.ldata  :=rdata;
fd_focus.frame.lcolor1:=xcolor1;
fd_focus.frame.lcolor2:=xcolor2;


//data -------------------------------------------------------------------------

//init
xslot                 :=0;
xpos                  :=0;
sframesize            :=xsize;
sremsize              :=xsize;

//get - framesets
while true do
begin

if low__frameset(xpos,xframeData,sremsize,sframesize,xcolor1,xcolor2,dminsize,dsize,dcolor1,dcolor2) then
   begin

   for p:=0 to (dsize-1) do
   begin

   if (xslot>=fd_frameLimit) then goto skipend;

   fd_focus.frame.color[xslot]:=int__c32( int__splice24_100( round32(((p+1)*100)/frcmin32(dsize,1)) ,dcolor1 ,dcolor2 ) );

   inc(xslot);

   end;//p

   end
   
else break;

end;//while

skipend:

//finalise
for p:=xslot to pred(xsize) do fd_focus.frame.color[p]:=int__c32( int__splice24_100( round32(((p+1)*100)/frcmin32(xsize,1)) ,xcolor1 ,xcolor2 ) );

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

   //nil

   end;

//check
if (fd_focus.rindex<0) or (fd_focus.rindex>high(fd_focus.rlist)) or (fd_focus.b.t<>t_img) then exit;

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
if (not fd_focus.b.ok) or (fd_focus.rindex<0) or (fd_focus.rindex>high(fd_focus.rlist)) or (not fd_focus.rlist[ fd_focus.rindex ].rok) or (fd_focus.b.t<>t_img) then
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
ddrawProc              :=sysfd_drawproc32;

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
sysfd_drawproc32       :=ddrawproc;

end;//with

//dec to previous slot -> can be above and below range
dec(fd_focus.rindex);

end;

procedure xfd__invertArea;//28feb2026

   procedure xdraw;
   begin

   xfd__invertArea3000_layer_2432;

   end;

begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;

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

procedure xfd__invertArea3000_layer_2432;//28feb2026
label
   yredo24,xredo24,yredo32,xredo32,lyredo24,lxredo24,lyredo32,lxredo32,
   yredo96_32,xredo96_32,
   yredo96_24,xredo96_24,
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
   s24:pcolor24;
   s32:pcolor32;
   s96:pcolor96;
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
sysfd_drawProc32:=3000;

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

   case xcan96 of
   true:begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=3097;
         goto yredo96_24L;

         end;
      else
         begin

         sysfd_drawProc32:=3096;
         goto yredo96_24;

         end;
      end;//case

      end;
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=3025;
         goto lyredo24;

         end;
      else
         begin

         sysfd_drawProc32:=3024;
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

         sysfd_drawProc32:=3098;
         goto yredo96_32L;

         end;
      else begin

         sysfd_drawProc32:=3099;
         goto yredo96_32;

         end;
      end;//case

      end
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=3033;
         goto lyredo32;

         end;
      else begin

         sysfd_drawProc32:=3032;
         goto yredo32;

         end;
      end;//case

      end;
   end;//case

   end;
else  exit;
end;//case


//render96_32 ------------------------------------------------------------------
yredo96_32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset96;

xredo96_32:

//render pixel
s96         :=@sr96[sy][sx];
s96.v0      :=255-s96.v0;//b
s96.v1      :=255-s96.v1;//g
s96.v2      :=255-s96.v2;//r

s96.v4      :=255-s96.v4;//b
s96.v5      :=255-s96.v5;//g
s96.v6      :=255-s96.v6;//r

s96.v8      :=255-s96.v8;//b
s96.v9      :=255-s96.v9;//g
s96.v10     :=255-s96.v10;//r

//inc x
if (sx<>xstop96) then
   begin

   inc(sx,1);
   goto xredo96_32;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do
begin

s32      :=@sr32[sy][sx];
s32.r    :=255-s32.r;
s32.g    :=255-s32.g;
s32.b    :=255-s32.b;

end;//sx

for sx:=rx1 to rx2 do
begin

s32      :=@sr32[sy][sx];
s32.r    :=255-s32.r;
s32.g    :=255-s32.g;
s32.b    :=255-s32.b;

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


//render96_24 ------------------------------------------------------------------
yredo96_24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset96;

xredo96_24:

//render pixel
s96         :=@sr96[sy][sx];
s96.v0      :=255-s96.v0;//b
s96.v1      :=255-s96.v1;//g
s96.v2      :=255-s96.v2;//r

s96.v3      :=255-s96.v3;//b
s96.v4      :=255-s96.v4;//g
s96.v5      :=255-s96.v5;//r

s96.v6      :=255-s96.v6;//b
s96.v7      :=255-s96.v7;//g
s96.v8      :=255-s96.v8;//r

s96.v9      :=255-s96.v9;//b
s96.v10     :=255-s96.v10;//g
s96.v11     :=255-s96.v11;//r

//inc x
if (sx<>xstop96) then
   begin

   inc(sx,1);
   goto xredo96_24;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do
begin

s24      :=@sr24[sy][sx];
s24.r    :=255-s24.r;
s24.g    :=255-s24.g;
s24.b    :=255-s24.b;

end;//sx

for sx:=rx1 to rx2 do
begin

s24      :=@sr24[sy][sx];
s24.r    :=255-s24.r;
s24.g    :=255-s24.g;
s24.b    :=255-s24.b;

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


//render96_32L -----------------------------------------------------------------
yredo96_32L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr24[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_32L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0:=255-pcolor96(dindex).v0;//b
   pcolor96(dindex).v1:=255-pcolor96(dindex).v1;//g
   pcolor96(dindex).v2:=255-pcolor96(dindex).v2;//r
   //a

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   pcolor96(dindex).v4:=255-pcolor96(dindex).v4;//b
   pcolor96(dindex).v5:=255-pcolor96(dindex).v5;//g
   pcolor96(dindex).v6:=255-pcolor96(dindex).v6;//r
   //a

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   pcolor96(dindex).v8 :=255-pcolor96(dindex).v8;//b
   pcolor96(dindex).v9 :=255-pcolor96(dindex).v9;//g
   pcolor96(dindex).v10:=255-pcolor96(dindex).v10;//r
   //a

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

   s32      :=@sr32[sy][sx];
   s32.r    :=255-s32.r;
   s32.g    :=255-s32.g;
   s32.b    :=255-s32.b;

   end;

for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then
   begin

   s32      :=@sr32[sy][sx];
   s32.r    :=255-s32.r;
   s32.g    :=255-s32.g;
   s32.b    :=255-s32.b;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_32L;

   end;

//done
xfd__inc64;
exit;


//render96_24L -----------------------------------------------------------------
yredo96_24L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr32[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_24L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   pcolor96(dindex).v0:=255-pcolor96(dindex).v0;//b
   pcolor96(dindex).v1:=255-pcolor96(dindex).v1;//g
   pcolor96(dindex).v2:=255-pcolor96(dindex).v2;//r

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   pcolor96(dindex).v3:=255-pcolor96(dindex).v3;//b
   pcolor96(dindex).v4:=255-pcolor96(dindex).v4;//g
   pcolor96(dindex).v5:=255-pcolor96(dindex).v5;//r

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   pcolor96(dindex).v6:=255-pcolor96(dindex).v6;//b
   pcolor96(dindex).v7:=255-pcolor96(dindex).v7;//g
   pcolor96(dindex).v8:=255-pcolor96(dindex).v8;//r

   end;

if (pcolor32(lindex).a=lv8) then
   begin

   pcolor96(dindex).v9 :=255-pcolor96(dindex).v9 ;//b
   pcolor96(dindex).v10:=255-pcolor96(dindex).v10;//g
   pcolor96(dindex).v11:=255-pcolor96(dindex).v11;//r

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

   s24      :=@sr24[sy][sx];
   s24.r    :=255-s24.r;
   s24.g    :=255-s24.g;
   s24.b    :=255-s24.b;

   end;

for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then
   begin

   s24      :=@sr24[sy][sx];
   s24.r    :=255-s24.r;
   s24.g    :=255-s24.g;
   s24.b    :=255-s24.b;

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_24L;

   end;

//done
xfd__inc64;
exit;


//render32 ---------------------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

xredo32:

//render pixel
s32      :=@sr32[sy][sx];
s32.r    :=255-s32.r;
s32.g    :=255-s32.g;
s32.b    :=255-s32.b;

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


//layer.render32 ---------------------------------------------------------------
lyredo32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

lxredo32:

//render pixel
if (lr8[sy][sx]=lv8) then
   begin

   s32      :=@sr32[sy][sx];
   s32.r    :=255-s32.r;
   s32.g    :=255-s32.g;
   s32.b    :=255-s32.b;

   end;

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


//layer.render24 ---------------------------------------------------------------
lyredo24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

lxredo24:

//render pixel
if (lr8[sy][sx]=lv8) then
   begin

   s24      :=@sr24[sy][sx];
   s24.r    :=255-s24.r;
   s24.g    :=255-s24.g;
   s24.b    :=255-s24.b;

   end;

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


//render24 ---------------------------------------------------------------------
yredo24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

xredo24:

//render pixel
s24      :=@sr24[sy][sx];
s24.r    :=255-s24.r;
s24.g    :=255-s24.g;
s24.b    :=255-s24.b;

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

procedure xfd__invertCorrectedArea;//01mar2026

   procedure xdraw;
   begin

   xfd__invertCorrectedArea4000_layer_2432;

   end;

begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;

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

procedure xfd__invertCorrectedArea4000_layer_2432;//01mar2026
label
   yredo24,xredo24,yredo32,xredo32,lyredo24,lxredo24,lyredo32,lxredo32,
   yredo96_32,xredo96_32,
   yredo96_24,xredo96_24,
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
   s24:pcolor24;
   s32:pcolor32;
   s96:pcolor96;
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

   procedure bgrInvertCorrect(var b,g,r:byte);//primarily used for drawing a cursor on a grey background -> invert of grey is grey -> which makes the cursor hard to see, this proc compensates to make the cursor visible on grey - 01mar2026
   var
      v:byte;
   begin

   //grey correction
   v        :=r;
   if (g>v) then v:=g;
   if (b>v) then v:=b;

   if (v>=90) and (v<=140) then
      begin

      r     :=255;
      g     :=255;
      b     :=255;

      end

   //invert color
   else
      begin

      r     :=255-r;
      g     :=255-g;
      b     :=255-b;

      end;

   end;


begin

//defaults
sysfd_drawProc32:=4000;

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

   case xcan96 of
   true:begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=4097;
         goto yredo96_24L;

         end;
      else
         begin

         sysfd_drawProc32:=4096;
         goto yredo96_24;

         end;
      end;//case

      end;
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=4025;
         goto lyredo24;

         end;
      else
         begin

         sysfd_drawProc32:=4024;
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

         sysfd_drawProc32:=4098;
         goto yredo96_32L;

         end;
      else begin

         sysfd_drawProc32:=4099;
         goto yredo96_32;

         end;
      end;//case

      end
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=4033;
         goto lyredo32;

         end;
      else begin

         sysfd_drawProc32:=4032;
         goto yredo32;

         end;
      end;//case

      end;
   end;//case

   end;
else  exit;
end;//case


//render96_32 ------------------------------------------------------------------
yredo96_32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset96;

xredo96_32:

//render pixel
s96         :=@sr96[sy][sx];

bgrInvertCorrect(s96.v0,s96.v1,s96.v2);
bgrInvertCorrect(s96.v4,s96.v5,s96.v6);
bgrInvertCorrect(s96.v8,s96.v9,s96.v10);

//inc x
if (sx<>xstop96) then
   begin

   inc(sx,1);
   goto xredo96_32;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do
begin

s32      :=@sr32[sy][sx];
bgrInvertCorrect(s32.b,s32.g,s32.r);

end;//sx

for sx:=rx1 to rx2 do
begin

s32      :=@sr32[sy][sx];
bgrInvertCorrect(s32.b,s32.g,s32.r);

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


//render96_24 ------------------------------------------------------------------
yredo96_24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset96;

xredo96_24:

//render pixel
s96         :=@sr96[sy][sx];

bgrInvertCorrect(s96.v0,s96.v1,s96.v2);
bgrInvertCorrect(s96.v3,s96.v4,s96.v5);
bgrInvertCorrect(s96.v6,s96.v7,s96.v8);
bgrInvertCorrect(s96.v9,s96.v10,s96.v11);

//inc x
if (sx<>xstop96) then
   begin

   inc(sx,1);
   goto xredo96_24;

   end;

//row "begin" and "end" gaps
for sx:=lx1 to lx2 do
begin

s24      :=@sr24[sy][sx];
bgrInvertCorrect(s24.b,s24.g,s24.r);

end;//sx

for sx:=rx1 to rx2 do
begin

s24      :=@sr24[sy][sx];
bgrInvertCorrect(s24.b,s24.g,s24.r);

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


//render96_32L -----------------------------------------------------------------
yredo96_32L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr24[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_32L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   bgrInvertCorrect(pcolor96(dindex).v0,pcolor96(dindex).v1,pcolor96(dindex).v2);
   //a

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   bgrInvertCorrect(pcolor96(dindex).v4,pcolor96(dindex).v5,pcolor96(dindex).v6);
   //a

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   bgrInvertCorrect(pcolor96(dindex).v8,pcolor96(dindex).v9,pcolor96(dindex).v10);
   //a

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

   s32      :=@sr32[sy][sx];
   bgrInvertCorrect(s32.b,s32.g,s32.r);

   end;

for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then
   begin

   s32      :=@sr32[sy][sx];
   bgrInvertCorrect(s32.b,s32.g,s32.r);

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_32L;

   end;

//done
xfd__inc64;
exit;


//render96_24L -----------------------------------------------------------------
yredo96_24L:

xfd__inc32(fd_focus.b.aw);
lindex  :=iauto( @lr32[sy][xreset96] );
dindex  :=iauto( @sr96[sy][xreset96] );
dstop96 :=iauto( @sr96[sy][xstop96] );

xredo96_24L:

//render pixel
if (pcolor32(lindex).b=lv8) then
   begin

   bgrInvertCorrect(pcolor96(dindex).v0,pcolor96(dindex).v1,pcolor96(dindex).v2);

   end;

if (pcolor32(lindex).g=lv8) then
   begin

   bgrInvertCorrect(pcolor96(dindex).v3,pcolor96(dindex).v4,pcolor96(dindex).v5);

   end;

if (pcolor32(lindex).r=lv8) then
   begin

   bgrInvertCorrect(pcolor96(dindex).v6,pcolor96(dindex).v7,pcolor96(dindex).v8);

   end;

if (pcolor32(lindex).a=lv8) then
   begin

   bgrInvertCorrect(pcolor96(dindex).v9,pcolor96(dindex).v10,pcolor96(dindex).v11);

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

   s24      :=@sr24[sy][sx];
   bgrInvertCorrect(s24.b,s24.g,s24.r);

   end;

for sx:=rx1 to rx2 do if (lr8[sy][sx]=lv8) then
   begin

   s24      :=@sr24[sy][sx];
   bgrInvertCorrect(s24.b,s24.g,s24.r);

   end;

//inc y
if (sy<>ystop) then
   begin

   inc(sy,1);
   goto yredo96_24L;

   end;

//done
xfd__inc64;
exit;


//render32 ---------------------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

xredo32:

//render pixel
s32      :=@sr32[sy][sx];
bgrInvertCorrect(s32.b,s32.g,s32.r);

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


//layer.render32 ---------------------------------------------------------------
lyredo32:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

lxredo32:

//render pixel
if (lr8[sy][sx]=lv8) then
   begin

   s32      :=@sr32[sy][sx];
   bgrInvertCorrect(s32.b,s32.g,s32.r);

   end;

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


//layer.render24 ---------------------------------------------------------------
lyredo24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

lxredo24:

//render pixel
if (lr8[sy][sx]=lv8) then
   begin

   s24      :=@sr24[sy][sx];
   bgrInvertCorrect(s24.b,s24.g,s24.r);

   end;

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


//render24 ---------------------------------------------------------------------
yredo24:

xfd__inc32(fd_focus.b.aw);
sx  :=xreset;

xredo24:

//render pixel
s24      :=@sr24[sy][sx];
bgrInvertCorrect(s24.b,s24.g,s24.r);

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

procedure xfd__dashedArea;//03mar2026

   procedure xdraw;
   begin

   xfd__dashedArea4200_layer_2432;

   end;

begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;

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

procedure xfd__dashedArea4200_layer_2432;//03mar2026
label
   yredo24,xredo24,yredo32,xredo32,lyredo24,lxredo24,lyredo32,lxredo32;

var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   dreset,dlen,dpos,lv8,xstop,ystop,xreset,sx,sy:longint32;
   r1,g1,b1:byte;
   dreseton,don:boolean;
   s24:pcolor24;
   s32:pcolor32;

begin

//defaults
sysfd_drawProc32:=4200;

//quick check
if not fd_focus.b.ok then exit;

//init
xreset      :=fd_focus.b.ax1;
xstop       :=fd_focus.b.ax2;
sy          :=fd_focus.b.ay1;
ystop       :=fd_focus.b.ay2;
lv8         :=fd_focus.lv8;
r1          :=fd_focus.color1.r;
g1          :=fd_focus.color1.g;
b1          :=fd_focus.color1.b;
dlen        :=fd_focus.val1;//dash length

if (dlen<=0) then exit;//nothing to do -> ignore

dreset      :=(xreset+fd_focus.val2)-(((xreset+fd_focus.val2) div dlen)*dlen);//val2 is for "horizontal scroll" which shifts the on/off dash boundaries - 03mar2026
dreseton    :=low__iseven((xreset+fd_focus.val2) div dlen);

case fd_focus.b.bits of
24:begin

   sr24     :=pcolorrows24(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=4225;
      goto lyredo24;

      end;
   else
      begin

      sysfd_drawProc32:=4224;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32     :=pcolorrows32(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=4233;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=4232;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 ---------------------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
sx          :=xreset;
dpos        :=dreset;
don         :=dreseton;

xredo32:

//render pixel
if don then
   begin

   s32      :=@sr32[sy][sx];
   s32.r    :=r1;
   s32.g    :=g1;
   s32.b    :=b1;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   inc(dpos,1);

   if (dpos>=dlen) then
      begin

      dpos  :=0;
      don   :=not don;

      end;

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


//layer.render32 ---------------------------------------------------------------
lyredo32:

xfd__inc32(fd_focus.b.aw);
sx          :=xreset;
dpos        :=dreset;
don         :=dreseton;

lxredo32:

//render pixel
if don and (lr8[sy][sx]=lv8) then
   begin

   s32      :=@sr32[sy][sx];
   s32.r    :=r1;
   s32.g    :=g1;
   s32.b    :=b1;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   inc(dpos,1);

   if (dpos>=dlen) then
      begin

      dpos  :=0;
      don   :=not don;

      end;

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


//layer.render24 ---------------------------------------------------------------
lyredo24:

xfd__inc32(fd_focus.b.aw);
sx          :=xreset;
dpos        :=dreset;
don         :=dreseton;

lxredo24:

//render pixel
if don and (lr8[sy][sx]=lv8) then
   begin

   s24      :=@sr24[sy][sx];
   s24.r    :=r1;
   s24.g    :=g1;
   s24.b    :=b1;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   inc(dpos,1);

   if (dpos>=dlen) then
      begin

      dpos  :=0;
      don   :=not don;

      end;

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


//render24 ---------------------------------------------------------------------
yredo24:

xfd__inc32(fd_focus.b.aw);
sx          :=xreset;
dpos        :=dreset;
don         :=dreseton;

xredo24:

//render pixel
if don then
   begin

   s24      :=@sr24[sy][sx];
   s24.r    :=r1;
   s24.g    :=g1;
   s24.b    :=b1;

   end;

//inc x
if (sx<>xstop) then
   begin

   inc(sx,1);
   inc(dpos,1);

   if (dpos>=dlen) then
      begin

      dpos  :=0;
      don   :=not don;

      end;

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

procedure xfd__fillArea;//09apr2026, 01jan2026, 25dec2025

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
if (not fd_focus.b.ok) or (fd_focus.power255<1) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;

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
sysfd_drawProc32:=300;

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

         sysfd_drawProc32:=397;
         goto yredo96_24L;

         end;
      else
         begin

         sysfd_drawProc32:=396;
         goto yredo96_N;

         end;
      end;//case

      end;
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=325;
         goto lyredo24;

         end;
      else
         begin

         sysfd_drawProc32:=324;
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

         sysfd_drawProc32:=398;
         goto yredo96_32L;

         end;
      else begin

         sysfd_drawProc32:=396;
         goto yredo96_N;

         end;
      end;//case

      end
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=333;
         goto lyredo32;

         end;
      else begin

         sysfd_drawProc32:=332;
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
sysfd_drawProc32:=400;

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

      sysfd_drawProc32:=498;
      goto yredo96_24L;

      end;
   else begin

      sysfd_drawProc32:=497;
      goto yredo96_24;

      end;
   end;//case

   end;

else begin

   case (fd_focus.lv8>=0) of
   true:begin

      sysfd_drawProc32:=425;
      goto lyredo24;

      end;
   else begin

      sysfd_drawProc32:=424;
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
sysfd_drawProc32:=500;

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

      sysfd_drawProc32:=597;
      goto yredo96_32L;

      end;
   else begin

      sysfd_drawProc32:=596;
      goto yredo96_32;

      end;
   end;//case

   end
else begin

   case (fd_focus.lv8>=0) of
   true:begin

      sysfd_drawProc32:=533;
      goto lyredo32;

      end;
   else
      begin

      sysfd_drawProc32:=532;
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

procedure xfd__colorMatrix;//29mar2026
begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;

//color matrix
xfd__colorMatrix11000_cliprange_layer;

end;

procedure xfd__colorMatrix11000_cliprange_layer;//29mar2026
label//mps ratings below are for an Intel Core i5 2.5 GHz
   yredo32,lyredo32,yredo24,lyredo24;
var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   s24:pcolor24;
   s32:pcolor32;
   cx1,cx2,cy1,cy2,aw,ah,ah2,ax1,ax2,ay1,ay2,dx,dy,lv8,lx1,lx2,rx1,rx2:longint32;
   dypert,dxpert,av,ar,ag,ab:single;

begin

//defaults
sysfd_drawProc32:=11000;

//quick check
if not fd_focus.b.ok then exit;

//init
cx1         :=fd_focus.b.cx1;
cx2         :=fd_focus.b.cx2;
cy1         :=fd_focus.b.cy1;
cy2         :=fd_focus.b.cy2;

ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;
lv8         :=fd_focus.lv8;

aw          :=fd_focus.b.aw;
ah          :=fd_focus.b.ah;
ah2         :=ah div 2;

if (ah2<=0) then ah2:=1;

//check
if (aw<1) or (ah<1) then exit;


case fd_focus.b.bits of
24:begin

   sr24     :=pcolorrows24(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=11025;
      goto lyredo24;

      end;
   else
      begin

      sysfd_drawProc32:=11024;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32     :=pcolorrows32(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=11033;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=11032;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 ---------------------------------------------------------------------
yredo32:

xfd__inc32( fd_focus.b.aw * fd_focus.b.ah );

for dy:=ay1 to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //init
   case ( (dy-ay1) < ah2 ) of
   true:dypert :=-( ah2 - (dy-ay1)  ) / ah2;
   else dypert := ( (dy-ay1) - ah2  ) / ah2;
   end;//case

   if      (dypert < -1 ) then dypert:=-1
   else if (dypert > 1  ) then dypert:= 1;

   //dx

   for dx:=ax1 to ax2 do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      dxpert       :=(dx-ax1+1) / aw;

      if (dxpert<=0.16) then
         begin//red -> yellow

         av        :=255*((dxpert-0)/0.16);//0..255
         ar        :=255;
         ag        :=av;
         ab        :=0;

         end

      else if (dxpert<=0.33) then
         begin//yellow -> green

         av        :=255*((dxpert-0.16)/0.17);//0..255
         ar        :=255-av;
         ag        :=255;
         ab        :=0;

         end

      else if (dxpert<=0.50) then
         begin//yellow -> green

         av        :=255*((dxpert-0.33)/0.17);//0..255
         ar        :=0;
         ag        :=255;
         ab        :=av;

         end

      else if (dxpert<=0.67) then
         begin//yellow -> green

         av        :=255*((dxpert-0.50)/0.17);//0..255
         ar        :=0;
         ag        :=255-av;
         ab        :=255;

         end

      else if (dxpert<=0.84) then
         begin//yellow -> green

         av        :=255*((dxpert-0.67)/0.17);//0..255
         ar        :=av;
         ag        :=0;
         ab        :=255;

         end

      else//01jun2025
         begin//yellow -> green

         av        :=255*((dxpert-0.84)/0.16);//0..255
         ar        :=255;
         ag        :=0;
         ab        :=255-av;

         end;

      //.shade
      if (dypert<=0) then
         begin

         ar        :=((1+dypert)*ar)+(-dypert*255);
         ag        :=((1+dypert)*ag)+(-dypert*255);
         ab        :=((1+dypert)*ab)+(-dypert*255);

         end
      else if (dypert>=0) then
         begin

         ar        :=(1-dypert)*ar;
         ag        :=(1-dypert)*ag;
         ab        :=(1-dypert)*ab;

         end;

      s32          :=@sr32[dy][dx];
      s32.r        :=byte( round32(ar) );
      s32.g        :=byte( round32(ag) );
      s32.b        :=byte( round32(ab) );

      end;

   end;//dx

   end;

end;//dy

//done
xfd__inc64;
exit;


//layer.render32 ---------------------------------------------------------------
lyredo32:

xfd__inc32( fd_focus.b.aw * fd_focus.b.ah );

for dy:=ay1 to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //init
   case ( (dy-ay1) < ah2 ) of
   true:dypert :=-( ah2 - (dy-ay1)  ) / ah2;
   else dypert := ( (dy-ay1) - ah2  ) / ah2;
   end;//case

   if      (dypert < -1 ) then dypert:=-1
   else if (dypert > 1  ) then dypert:= 1;

   //dx

   for dx:=ax1 to ax2 do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[dy][dx]=lv8) then
      begin

      dxpert       :=(dx-ax1+1) / aw;

      if (dxpert<=0.16) then
         begin//red -> yellow

         av        :=255*((dxpert-0)/0.16);//0..255
         ar        :=255;
         ag        :=av;
         ab        :=0;

         end

      else if (dxpert<=0.33) then
         begin//yellow -> green

         av        :=255*((dxpert-0.16)/0.17);//0..255
         ar        :=255-av;
         ag        :=255;
         ab        :=0;

         end

      else if (dxpert<=0.50) then
         begin//yellow -> green

         av        :=255*((dxpert-0.33)/0.17);//0..255
         ar        :=0;
         ag        :=255;
         ab        :=av;

         end

      else if (dxpert<=0.67) then
         begin//yellow -> green

         av        :=255*((dxpert-0.50)/0.17);//0..255
         ar        :=0;
         ag        :=255-av;
         ab        :=255;

         end

      else if (dxpert<=0.84) then
         begin//yellow -> green

         av        :=255*((dxpert-0.67)/0.17);//0..255
         ar        :=av;
         ag        :=0;
         ab        :=255;

         end

      else//01jun2025
         begin//yellow -> green

         av        :=255*((dxpert-0.84)/0.16);//0..255
         ar        :=255;
         ag        :=0;
         ab        :=255-av;

         end;

      //.shade
      if (dypert<=0) then
         begin

         ar        :=((1+dypert)*ar)+(-dypert*255);
         ag        :=((1+dypert)*ag)+(-dypert*255);
         ab        :=((1+dypert)*ab)+(-dypert*255);

         end
      else if (dypert>=0) then
         begin

         ar        :=(1-dypert)*ar;
         ag        :=(1-dypert)*ag;
         ab        :=(1-dypert)*ab;

         end;

      s32          :=@sr32[dy][dx];
      s32.r        :=byte( round32(ar) );
      s32.g        :=byte( round32(ag) );
      s32.b        :=byte( round32(ab) );

      end;

   end;//dx

   end;

end;//dy

//done
xfd__inc64;
exit;


//render24 ---------------------------------------------------------------------
yredo24:

xfd__inc32( fd_focus.b.aw * fd_focus.b.ah );

for dy:=ay1 to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //init
   case ( (dy-ay1) < ah2 ) of
   true:dypert :=-( ah2 - (dy-ay1)  ) / ah2;
   else dypert := ( (dy-ay1) - ah2  ) / ah2;
   end;//case

   if      (dypert < -1 ) then dypert:=-1
   else if (dypert > 1  ) then dypert:= 1;

   //dx

   for dx:=ax1 to ax2 do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      dxpert       :=(dx-ax1+1) / aw;

      if (dxpert<=0.16) then
         begin//red -> yellow

         av        :=255*((dxpert-0)/0.16);//0..255
         ar        :=255;
         ag        :=av;
         ab        :=0;

         end

      else if (dxpert<=0.33) then
         begin//yellow -> green

         av        :=255*((dxpert-0.16)/0.17);//0..255
         ar        :=255-av;
         ag        :=255;
         ab        :=0;

         end

      else if (dxpert<=0.50) then
         begin//yellow -> green

         av        :=255*((dxpert-0.33)/0.17);//0..255
         ar        :=0;
         ag        :=255;
         ab        :=av;

         end

      else if (dxpert<=0.67) then
         begin//yellow -> green

         av        :=255*((dxpert-0.50)/0.17);//0..255
         ar        :=0;
         ag        :=255-av;
         ab        :=255;

         end

      else if (dxpert<=0.84) then
         begin//yellow -> green

         av        :=255*((dxpert-0.67)/0.17);//0..255
         ar        :=av;
         ag        :=0;
         ab        :=255;

         end

      else//01jun2025
         begin//yellow -> green

         av        :=255*((dxpert-0.84)/0.16);//0..255
         ar        :=255;
         ag        :=0;
         ab        :=255-av;

         end;

      //.shade
      if (dypert<=0) then
         begin

         ar        :=((1+dypert)*ar)+(-dypert*255);
         ag        :=((1+dypert)*ag)+(-dypert*255);
         ab        :=((1+dypert)*ab)+(-dypert*255);

         end
      else if (dypert>=0) then
         begin

         ar        :=(1-dypert)*ar;
         ag        :=(1-dypert)*ag;
         ab        :=(1-dypert)*ab;

         end;

      s24          :=@sr24[dy][dx];
      s24.r        :=byte( round32(ar) );
      s24.g        :=byte( round32(ag) );
      s24.b        :=byte( round32(ab) );

      end;

   end;//dx

   end;

end;//dy

//done
xfd__inc64;
exit;


//layer.render24 ---------------------------------------------------------------
lyredo24:

xfd__inc32( fd_focus.b.aw * fd_focus.b.ah );

for dy:=ay1 to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //init
   case ( (dy-ay1) < ah2 ) of
   true:dypert :=-( ah2 - (dy-ay1)  ) / ah2;
   else dypert := ( (dy-ay1) - ah2  ) / ah2;
   end;//case

   if      (dypert < -1 ) then dypert:=-1
   else if (dypert > 1  ) then dypert:= 1;

   //dx

   for dx:=ax1 to ax2 do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[dy][dx]=lv8) then
      begin

      dxpert       :=(dx-ax1+1) / aw;

      if (dxpert<=0.16) then
         begin//red -> yellow

         av        :=255*((dxpert-0)/0.16);//0..255
         ar        :=255;
         ag        :=av;
         ab        :=0;

         end

      else if (dxpert<=0.33) then
         begin//yellow -> green

         av        :=255*((dxpert-0.16)/0.17);//0..255
         ar        :=255-av;
         ag        :=255;
         ab        :=0;

         end

      else if (dxpert<=0.50) then
         begin//yellow -> green

         av        :=255*((dxpert-0.33)/0.17);//0..255
         ar        :=0;
         ag        :=255;
         ab        :=av;

         end

      else if (dxpert<=0.67) then
         begin//yellow -> green

         av        :=255*((dxpert-0.50)/0.17);//0..255
         ar        :=0;
         ag        :=255-av;
         ab        :=255;

         end

      else if (dxpert<=0.84) then
         begin//yellow -> green

         av        :=255*((dxpert-0.67)/0.17);//0..255
         ar        :=av;
         ag        :=0;
         ab        :=255;

         end

      else//01jun2025
         begin//yellow -> green

         av        :=255*((dxpert-0.84)/0.16);//0..255
         ar        :=255;
         ag        :=0;
         ab        :=255-av;

         end;

      //.shade
      if (dypert<=0) then
         begin

         ar        :=((1+dypert)*ar)+(-dypert*255);
         ag        :=((1+dypert)*ag)+(-dypert*255);
         ab        :=((1+dypert)*ab)+(-dypert*255);

         end
      else if (dypert>=0) then
         begin

         ar        :=(1-dypert)*ar;
         ag        :=(1-dypert)*ag;
         ab        :=(1-dypert)*ab;

         end;

      s24          :=@sr24[dy][dx];
      s24.r        :=byte( round32(ar) );
      s24.g        :=byte( round32(ag) );
      s24.b        :=byte( round32(ab) );

      end;

   end;//dx

   end;

end;//dy

//done
xfd__inc64;

end;

procedure xfd__frameArea;//28mar2026
begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.power255<1) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;
if (fd_focus.rimage.trace=nil) or (fd_focus.frame.size<=0)                                                          then exit;

//frame area
xfd__frameArea8000_power255_cliprange_layer_sparkle;

end;

procedure xfd__frameArea8000_power255_cliprange_layer_sparkle;//28mar2026
var
   fmax,ax1,ax2,ay1,ay2,p:longint;
   da:twinrect;
begin

//defaults
sysfd_drawProc32:=8000;

//init
ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;
fmax        :=pred(fd_focus.frame.size);

//get
for p:=0 to fmax do
begin

da.left     :=ax1 + p;
da.right    :=ax2 - p;

da.top      :=ay1 + p;
da.bottom   :=ay2 - p;

case (da.right>=da.left) and (da.bottom>=da.top) of
true:begin

   //fd_val1 = sparkle or not - assumed to be set already
   fd__setarea( fd_area ,da );
   fd__setrgba( fd_color1 ,fd_focus.frame.color[p].r ,fd_focus.frame.color[p].g ,fd_focus.frame.color[p].b ,fd_focus.frame.color[p].a );
   fd__render ( fd_outlineArea );

   end;
else break;
end;//case

end;//p

end;

procedure xfd__frameSimpleArea;//28mar2026
begin

//defaults
sysfd_drawProc32:=8100;

//quick check
if (not fd_focus.b.ok) or (fd_focus.power255<1) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;
if (fd_focus.rimage.trace=nil) or (fd_focus.val2<=0)                                                                 then exit;//val2=simpleFrameSize

//frame area
xfd__frameSimpleArea8100_power255_cliprange_layer_sparkle;

end;

procedure xfd__frameSimpleArea8100_power255_cliprange_layer_sparkle;//28mar2026
var
   fmax,ax1,ax2,ay1,ay2,p:longint;
   da:twinrect;
begin

//defaults
sysfd_drawProc32:=8100;

//init
ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;
fmax        :=pred(fd_focus.val2);

//get
for p:=0 to fmax do
begin

da.left     :=ax1 + p;
da.right    :=ax2 - p;

da.top      :=ay1 + p;
da.bottom   :=ay2 - p;

case (da.right>=da.left) and (da.bottom>=da.top) of
true:begin

   //fd_val1 = sparkle or not - assumed to be set already
   fd__setarea( fd_area ,da );
   fd__render ( fd_outlineArea );

   end;
else break;
end;//case

end;//p

end;

procedure xfd__outlineArea;//26mar2026
begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.power255<1) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;
if (fd_focus.rimage.trace=nil)                                                                                      then exit;

//outline area - "sparkle.on/off = fd_sparkle_val1 = fd_focus.val1" - 28mar2026
if      (fd_focus.val1>=1)        then xfd__outlineArea7200_power255_cliprange_layer_sparkle//27mar2026
else if (fd_focus.power255<255)   then xfd__outlineArea7100_power255_cliprange_layer
else                                   xfd__outlineArea7000_cliprange_layer;

end;

procedure xfd__outlineArea7000_cliprange_layer;//26mar2026
label
   yredo24,yredo32,lyredo24,lyredo32;

var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   iimage:pling;
   lw,lh,lv8,cx1,cx2,cy1,cy2,ax1,ax2,ay1,ay2,dx,dy,xhalf,yhalf:longint32;
   r1,g1,b1:byte;
   s24:pcolor24;
   s32:pcolor32;

begin

//defaults
sysfd_drawProc32:=7000;

//quick check
if not fd_focus.b.ok then exit;

//init
cx1         :=fd_focus.b.cx1;//clip range
cx2         :=fd_focus.b.cx2;
cy1         :=fd_focus.b.cy1;
cy2         :=fd_focus.b.cy2;

ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;

lv8         :=fd_focus.lv8;
r1          :=fd_focus.color1.r;
g1          :=fd_focus.color1.g;
b1          :=fd_focus.color1.b;

iimage      :=fd_focus.rimage.trace;
lw          :=iimage.w;
lh          :=iimage.h;

xhalf       :=fd_focus.b.ax1+(fd_focus.b.aw div 2)-1;
yhalf       :=fd_focus.b.ay1+(fd_focus.b.ah div 2)-1;

case fd_focus.b.bits of
24:begin

   sr24     :=pcolorrows24(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7025;
      goto lyredo24;

      end;
   else
      begin

      sysfd_drawProc32:=7024;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32     :=pcolorrows32(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7033;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=7032;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 ---------------------------------------------------------------------
yredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s32   :=@sr32[dy][ax1];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s32   :=@sr32[dy][ax2];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw) to (ax2-lw) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay1][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw) to (ax2-lw) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay2][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render32 ---------------------------------------------------------------
lyredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s32   :=@sr32[dy][ax1];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s32   :=@sr32[dy][ax2];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw) to (ax2-lw) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s32   :=@sr32[ay1][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw) to (ax2-lw) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s32   :=@sr32[ay2][dx];
      s32.r :=r1;
      s32.g :=g1;
      s32.b :=b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render24 ---------------------------------------------------------------
lyredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s24   :=@sr24[dy][ax1];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s24   :=@sr24[dy][ax2];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw) to (ax2-lw) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s24   :=@sr24[ay1][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw) to (ax2-lw) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s24   :=@sr24[ay2][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//render24 ---------------------------------------------------------------------
yredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s24   :=@sr24[dy][ax1];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s24   :=@sr24[dy][ax2];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw) to (ax2-lw) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay1][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw) to (ax2-lw) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay2][dx];
      s24.r :=r1;
      s24.g :=g1;
      s24.b :=b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;

end;

procedure xfd__outlineArea7100_power255_cliprange_layer;//26mar2026
label
   yredo24,yredo32,lyredo24,lyredo32;

var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   iimage:pling;
   hoffset,cainv,xpower,lw,lh,lv8,cx1,cx2,cy1,cy2,ax1,ax2,ay1,ay2,dx,dy,xhalf,yhalf:longint32;
   r1,g1,b1:byte;
   s24:pcolor24;
   s32:pcolor32;

begin

//defaults
sysfd_drawProc32:=7100;

//quick check
if not fd_focus.b.ok then exit;

//init
cx1         :=fd_focus.b.cx1;//clip range
cx2         :=fd_focus.b.cx2;
cy1         :=fd_focus.b.cy1;
cy2         :=fd_focus.b.cy2;

ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;

lv8         :=fd_focus.lv8;
xpower      :=fd_focus.power255;
cainv       :=255-xpower;

//.pre-compute
r1          :=(fd_focus.color1.r*xpower) shr 8;
g1          :=(fd_focus.color1.g*xpower) shr 8;
b1          :=(fd_focus.color1.b*xpower) shr 8;

iimage      :=fd_focus.rimage.trace;
lw          :=iimage.w;
lh          :=iimage.h;

case (lw<=0) of//exclude corner pixel(s) when square (prevents doubling up)
true:hoffset:=1;
else hoffset:=0;
end;//case

xhalf       :=fd_focus.b.ax1+(fd_focus.b.aw div 2)-1;
yhalf       :=fd_focus.b.ay1+(fd_focus.b.ah div 2)-1;

case fd_focus.b.bits of
24:begin

   sr24     :=pcolorrows24(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7125;
      goto lyredo24;

      end;
   else
      begin

      sysfd_drawProc32:=7124;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32     :=pcolorrows32(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7133;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=7132;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 ---------------------------------------------------------------------
yredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s32   :=@sr32[dy][ax1];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s32   :=@sr32[dy][ax2];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay1][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay2][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render32 ---------------------------------------------------------------
lyredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s32   :=@sr32[dy][ax1];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s32   :=@sr32[dy][ax2];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s32   :=@sr32[ay1][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s32   :=@sr32[ay2][dx];
      s32.r :=( (s32.r*cainv) shr 8 ) + r1;
      s32.g :=( (s32.g*cainv) shr 8 ) + g1;
      s32.b :=( (s32.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render24 ---------------------------------------------------------------
lyredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s24   :=@sr24[dy][ax1];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s24   :=@sr24[dy][ax2];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s24   :=@sr24[ay1][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s24   :=@sr24[ay2][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//render24 ---------------------------------------------------------------------
yredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s24   :=@sr24[dy][ax1];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s24   :=@sr24[dy][ax2];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay1][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay2][dx];
      s24.r :=( (s24.r*cainv) shr 8 ) + r1;
      s24.g :=( (s24.g*cainv) shr 8 ) + g1;
      s24.b :=( (s24.b*cainv) shr 8 ) + b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;

end;

procedure xfd__outlineArea7200_power255_cliprange_layer_sparkle;//27mar2026
label
   yredo24,yredo32,lyredo24,lyredo32;

var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   iimage:pling;
   v,hoffset,cainv,xpower,lw,lh,lv8,cx1,cx2,cy1,cy2,ax1,ax2,ay1,ay2,dx,dy,xhalf,yhalf:longint32;
   r1,g1,b1:byte;
   s24:pcolor24;
   s32:pcolor32;

begin

//defaults
sysfd_drawProc32:=7200;

//quick check
if not fd_focus.b.ok then exit;

//init
cx1         :=fd_focus.b.cx1;//clip range
cx2         :=fd_focus.b.cx2;
cy1         :=fd_focus.b.cy1;
cy2         :=fd_focus.b.cy2;

ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;

lv8         :=fd_focus.lv8;
xpower      :=fd_focus.power255;
cainv       :=255-xpower;

//.pre-compute
r1          :=fd_focus.color1.r;
g1          :=fd_focus.color1.g;
b1          :=fd_focus.color1.b;

iimage      :=fd_focus.rimage.trace;
lw          :=iimage.w;
lh          :=iimage.h;

case (lw<=0) of//exclude corner pixel(s) when square (prevents doubling up)
true:hoffset:=1;
else hoffset:=0;
end;//case

xhalf       :=fd_focus.b.ax1+(fd_focus.b.aw div 2)-1;
yhalf       :=fd_focus.b.ay1+(fd_focus.b.ah div 2)-1;

case fd_focus.b.bits of
24:begin

   sr24     :=pcolorrows24(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7225;
      goto lyredo24;

      end;
   else
      begin

      sysfd_drawProc32:=7224;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32     :=pcolorrows32(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7233;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=7232;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 ---------------------------------------------------------------------
yredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s32   :=@sr32[dy][ax1];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s32   :=@sr32[dy][ax2];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay1][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay2][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render32 ---------------------------------------------------------------
lyredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s32   :=@sr32[dy][ax1];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s32   :=@sr32[dy][ax2];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s32   :=@sr32[ay1][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s32   :=@sr32[ay2][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render24 ---------------------------------------------------------------
lyredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s24   :=@sr24[dy][ax1];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s24   :=@sr24[dy][ax2];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s24   :=@sr24[ay1][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s24   :=@sr24[ay2][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//render24 ---------------------------------------------------------------------
yredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s24   :=@sr24[dy][ax1];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s24   :=@sr24[dy][ax2];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay1][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay2][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//done
xfd__inc64;

end;

procedure xfd__shadeOutlineArea;//29mar2026
begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.power255<1) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;
if (fd_focus.rimage.trace=nil)                                                                                      then exit;

//shade outline area
if      (fd_focus.val1>=1)        then xfd__shadeOutlineArea7700_power255_cliprange_layer_sparkle
else if (fd_focus.power255<255)   then xfd__shadeOutlineArea7600_power255_cliprange_layer
else                                   xfd__shadeOutlineArea7500_cliprange_layer;

end;

procedure xfd__shadeOutlineArea7500_cliprange_layer;
label
   yredo24,yredo32,lyredo24,lyredo32;

var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   iimage:pling;
   ysize,ysize1,ysize2,yswitch,v,hoffset,lw,lh,lv8,cx1,cx2,cy1,cy2,ax1,ax2,ay1,ay2,dx,dy,xhalf,yhalf:longint32;
   c1,c2,c3,c4,c32:tcolor32;
   c24:tcolor24;
   yratio01:extended;

   procedure scol;
   begin

   case (dy<=yswitch) of
   true:c32  :=c32__splice( (dy-ay1 )/ysize1 ,c1 ,c2 );
   else c32  :=c32__splice( (dy-yswitch)/ysize2 ,c3 ,c4 );
   end;//case

   c24.r  :=c32.r;
   c24.g  :=c32.g;
   c24.b  :=c32.b;

   end;

begin

//defaults
sysfd_drawProc32:=7500;

//quick check
if not fd_focus.b.ok then exit;

//init
cx1         :=fd_focus.b.cx1;//clip range
cx2         :=fd_focus.b.cx2;
cy1         :=fd_focus.b.cy1;
cy2         :=fd_focus.b.cy2;

ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;

lv8         :=fd_focus.lv8;

yratio01    :=fd_focus.splice100/100;
ysize       :=frcmin32(ay2-ay1+1,1);

if (yratio01<0)  then yratio01:=0 else if (yratio01>1) then yratio01:=1;
if fd_focus.flip then yratio01:=1-yratio01;

ysize1      :=trunc32(ysize*yratio01);
ysize2      :=ysize-ysize1;
yswitch     :=ay1 + ysize1 - 1;

if (ysize1<1) then ysize1:=1;
if (ysize2<1) then ysize2:=1;

iimage      :=fd_focus.rimage.trace;
lw          :=iimage.w;
lh          :=iimage.h;

case (lw<=0) of//exclude corner pixel(s) when square (prevents doubling up)
true:hoffset:=1;
else hoffset:=0;
end;//case

xhalf       :=fd_focus.b.ax1+(fd_focus.b.aw div 2)-1;
yhalf       :=fd_focus.b.ay1+(fd_focus.b.ah div 2)-1;

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

   sr24     :=pcolorrows24(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7525;
      goto lyredo24;

      end;
   else
      begin

      sysfd_drawProc32:=7524;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32     :=pcolorrows32(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7533;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=7532;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 ---------------------------------------------------------------------
yredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then sr32[dy][dx]:=c32;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then sr32[dy][dx]:=c32;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then sr32[dy][dx]:=c32;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then sr32[dy][dx]:=c32;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) then sr32[dy][ax1]:=c32;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then sr32[dy][ax2]:=c32;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then sr32[ay1][dx]:=c32;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then sr32[ay2][dx]:=c32;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render32 ---------------------------------------------------------------
lyredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then sr32[dy][dx]:=c32;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then sr32[dy][dx]:=c32;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then sr32[dy][dx]:=c32;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then sr32[dy][dx]:=c32;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then sr32[dy][ax1]:=c32;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then sr32[dy][ax2]:=c32;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then sr32[ay1][dx]:=c32;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then sr32[ay2][dx]:=c32;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render24 ---------------------------------------------------------------
lyredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then sr24[dy][dx]:=c24;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then sr24[dy][dx]:=c24;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then sr24[dy][dx]:=c24;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then sr24[dy][dx]:=c24;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then sr24[dy][ax1]:=c24;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then sr24[dy][ax2]:=c24;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then sr24[ay1][dx]:=c24;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then sr24[ay2][dx]:=c24;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//render24 ---------------------------------------------------------------------
yredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then sr24[dy][dx]:=c24;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then sr24[dy][dx]:=c24;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then sr24[dy][dx]:=c24;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then sr24[dy][dx]:=c24;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) then sr24[dy][ax1]:=c24;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then sr24[dy][ax2]:=c24;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then sr24[ay1][dx]:=c24;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then sr24[ay2][dx]:=c24;

   end;//dx

   end;

//done
xfd__inc64;

end;

procedure xfd__shadeOutlineArea7600_power255_cliprange_layer;
label
   yredo24,yredo32,lyredo24,lyredo32;

var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   iimage:pling;
   ysize,ysize1,ysize2,yswitch,v,hoffset,cainv,xpower,lw,lh,lv8,cx1,cx2,cy1,cy2,ax1,ax2,ay1,ay2,dx,dy,xhalf,yhalf:longint32;
   r1,g1,b1:byte;
   s24:pcolor24;
   s32:pcolor32;
   c1,c2,c3,c4,c32:tcolor32;
   yratio01:extended;

   procedure scol;
   begin

   case (dy<=yswitch) of
   true:c32  :=c32__splice( (dy-ay1 )/ysize1 ,c1 ,c2 );
   else c32  :=c32__splice( (dy-yswitch)/ysize2 ,c3 ,c4 );
   end;//case

   r1     :=(c32.r*xpower) shr 8;
   g1     :=(c32.g*xpower) shr 8;
   b1     :=(c32.b*xpower) shr 8;

   end;

begin

//defaults
sysfd_drawProc32:=7600;

//quick check
if not fd_focus.b.ok then exit;

//init
cx1         :=fd_focus.b.cx1;//clip range
cx2         :=fd_focus.b.cx2;
cy1         :=fd_focus.b.cy1;
cy2         :=fd_focus.b.cy2;

ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;

lv8         :=fd_focus.lv8;
xpower      :=fd_focus.power255;
cainv       :=255-xpower;

yratio01    :=fd_focus.splice100/100;
ysize       :=frcmin32(ay2-ay1+1,1);

if (yratio01<0)  then yratio01:=0 else if (yratio01>1) then yratio01:=1;
if fd_focus.flip then yratio01:=1-yratio01;

ysize1      :=trunc32(ysize*yratio01);
ysize2      :=ysize-ysize1;
yswitch     :=ay1 + ysize1 - 1;

if (ysize1<1) then ysize1:=1;
if (ysize2<1) then ysize2:=1;

iimage      :=fd_focus.rimage.trace;
lw          :=iimage.w;
lh          :=iimage.h;

case (lw<=0) of//exclude corner pixel(s) when square (prevents doubling up)
true:hoffset:=1;
else hoffset:=0;
end;//case

xhalf       :=fd_focus.b.ax1+(fd_focus.b.aw div 2)-1;
yhalf       :=fd_focus.b.ay1+(fd_focus.b.ah div 2)-1;

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

   sr24     :=pcolorrows24(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7625;
      goto lyredo24;

      end;
   else
      begin

      sysfd_drawProc32:=7624;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32     :=pcolorrows32(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7633;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=7632;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 ---------------------------------------------------------------------
yredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s32   :=@sr32[dy][ax1];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s32   :=@sr32[dy][ax2];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay1][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay2][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render32 ---------------------------------------------------------------
lyredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s32   :=@sr32[dy][ax1];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s32   :=@sr32[dy][ax2];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s32   :=@sr32[ay1][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s32   :=@sr32[ay2][dx];
      s32.r :=( (s32.r*cainv) shr 8) + r1;
      s32.g :=( (s32.g*cainv) shr 8) + g1;
      s32.b :=( (s32.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render24 ---------------------------------------------------------------
lyredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s24   :=@sr24[dy][ax1];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s24   :=@sr24[dy][ax2];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s24   :=@sr24[ay1][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s24   :=@sr24[ay2][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//render24 ---------------------------------------------------------------------
yredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s24   :=@sr24[dy][ax1];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s24   :=@sr24[dy][ax2];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay1][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay2][dx];
      s24.r :=( (s24.r*cainv) shr 8) + r1;
      s24.g :=( (s24.g*cainv) shr 8) + g1;
      s24.b :=( (s24.b*cainv) shr 8) + b1;

      end;

   end;//dx

   end;

//done
xfd__inc64;

end;

procedure xfd__shadeOutlineArea7700_power255_cliprange_layer_sparkle;
label
   yredo24,yredo32,lyredo24,lyredo32;

var
    lr8:pcolorrows8;
   sr24:pcolorrows24;
   sr32:pcolorrows32;
   iimage:pling;
   ysize,ysize1,ysize2,yswitch,v,hoffset,cainv,xpower,lw,lh,lv8,cx1,cx2,cy1,cy2,ax1,ax2,ay1,ay2,dx,dy,xhalf,yhalf:longint32;
   r1,g1,b1:byte;
   s24:pcolor24;
   s32:pcolor32;
   c1,c2,c3,c4,c32:tcolor32;
   yratio01:extended;

   procedure scol;
   begin

   case (dy<=yswitch) of
   true:c32  :=c32__splice( (dy-ay1 )/ysize1 ,c1 ,c2 );
   else c32  :=c32__splice( (dy-yswitch)/ysize2 ,c3 ,c4 );
   end;//case

   r1     :=c32.r;
   g1     :=c32.g;
   b1     :=c32.b;

   end;

begin

//defaults
sysfd_drawProc32:=7700;

//quick check
if not fd_focus.b.ok then exit;

//init
cx1         :=fd_focus.b.cx1;//clip range
cx2         :=fd_focus.b.cx2;
cy1         :=fd_focus.b.cy1;
cy2         :=fd_focus.b.cy2;

ax1         :=fd_focus.b.ax1;
ax2         :=fd_focus.b.ax2;
ay1         :=fd_focus.b.ay1;
ay2         :=fd_focus.b.ay2;

lv8         :=fd_focus.lv8;
xpower      :=fd_focus.power255;
cainv       :=255-xpower;

yratio01    :=fd_focus.splice100/100;
ysize       :=frcmin32(ay2-ay1+1,1);

if (yratio01<0)  then yratio01:=0 else if (yratio01>1) then yratio01:=1;
if fd_focus.flip then yratio01:=1-yratio01;

ysize1      :=trunc32(ysize*yratio01);
ysize2      :=ysize-ysize1;
yswitch     :=ay1 + ysize1 - 1;

if (ysize1<1) then ysize1:=1;
if (ysize2<1) then ysize2:=1;

iimage      :=fd_focus.rimage.trace;
lw          :=iimage.w;
lh          :=iimage.h;

case (lw<=0) of//exclude corner pixel(s) when square (prevents doubling up)
true:hoffset:=1;
else hoffset:=0;
end;//case

xhalf       :=fd_focus.b.ax1+(fd_focus.b.aw div 2)-1;
yhalf       :=fd_focus.b.ay1+(fd_focus.b.ah div 2)-1;

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

   sr24     :=pcolorrows24(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7725;
      goto lyredo24;

      end;
   else
      begin

      sysfd_drawProc32:=7724;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   sr32     :=pcolorrows32(fd_focus.b.rows);

   case (fd_focus.lv8>=0) of
   true:begin

      lr8   :=pcolorrows8( fd_focus.lr8 );
      sysfd_drawProc32:=7733;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=7732;
      goto yredo32;

      end;
   end;//case

   end;
else  exit;
end;//case


//render32 ---------------------------------------------------------------------
yredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s32   :=@sr32[dy][ax1];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s32   :=@sr32[dy][ax2];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay1][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s32   :=@sr32[ay2][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render32 ---------------------------------------------------------------
lyredo32:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s32   :=@sr32[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s32   :=@sr32[dy][ax1];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s32   :=@sr32[dy][ax2];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s32   :=@sr32[ay1][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s32   :=@sr32[ay2][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.r :=( (s32.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.g :=( (s32.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s32.b :=( (s32.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//layer.render24 ---------------------------------------------------------------
lyredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) and (lr8[dy][dx]=lv8) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) and (lr8[dy][ax1]=lv8) then
      begin

      s24   :=@sr24[dy][ax1];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) and (lr8[dy][ax2]=lv8) then
      begin

      s24   :=@sr24[dy][ax2];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay1][dx]=lv8) then
      begin

      s24   :=@sr24[ay1][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) and (lr8[ay2][dx]=lv8) then
      begin

      s24   :=@sr24[ay2][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//done
xfd__inc64;
exit;


//render24 ---------------------------------------------------------------------
yredo24:
xfd__inc32(2*fd_focus.b.ah);//left and right
xfd__inc32(2*fd_focus.b.aw);//top and bottom

//top.left and top.right corner - 26mar2026
for dy:=ay1 to (ay1+lh-1) do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy<=yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[dy-ay1][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[dy-ay1][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//bottom.left and bottom.right corner - 26mar2026
for dy:=(ay2-lh+1) to ay2 do
begin

if (dy>=cy1) and (dy<=cy2) and (dy>=ay1) and (dy<=ay2) and (dy>yhalf) then
   begin

   //color
   scol;

   //left
   for dx:=ax1 to (ax1+lw-1) do
   begin

   if (iimage.pixels[ay2-dy][dx-ax1].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx<=xhalf) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   //right
   for dx:=(ax2-lw+1) to ax2 do
   begin

   if (iimage.pixels[ay2-dy][ax2-dx].a>=1) and (dx>=cx1) and (dx<=cx2) and (dx>=ax1) and (dx<=ax2) and (dx>xhalf) then
      begin

      s24   :=@sr24[dy][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

end;//y

//left and right
for dy:=(ay1+lh) to (ay2-lh) do
begin

if (dy>=cy1) and (dy<=cy2) then
   begin

   //color
   scol;

   //left
   if (ax1>=cx1) and (ax1<=cx2) then
      begin

      s24   :=@sr24[dy][ax1];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   //right
   if (ax1<>ax2) and (ax2>=cx1) and (ax2<=cx2) then
      begin

      s24   :=@sr24[dy][ax2];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;

end;//y

//top
if (ay1>=cy1) and (ay1<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay1][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//bottom
if (ay1<>ay2) and (ay2>=cy1) and (ay2<=cy2) then
   begin

   //color
   scol;

   //get
   for dx:=(ax1+lw+hoffset) to (ax2-lw-hoffset) do
   begin

   if (dx>=cx1) and (dx<=cx2) then
      begin

      s24   :=@sr24[ay2][dx];

      //.r
      v     :=r1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.r :=( (s24.r*cainv) + (v*xpower) ) shr 8;

      //.g
      v     :=g1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.g :=( (s24.g*cainv) + (v*xpower) ) shr 8;

      //.b
      v     :=b1 + fd_sparkle.val[fd_sparkle.pos] - fd_sparkle.level;
      if (v>255) then v:=255 else if (v<0) then v:=0;
      s24.b :=( (s24.b*cainv) + (v*xpower) ) shr 8;

      //.inc sparkle
      if (fd_sparkle.pos=fd_sparkleStopPos) then fd__sparkleReset else inc(fd_sparkle.pos);

      end;

   end;//dx

   end;

//done
xfd__inc64;

end;

procedure xfd__sketchArea;//06jan2026 - fills in area edge portions when round mode is one -> allows a base control to only fill a little of its surface area, allowing for the child control(s) to do the rest and save on render time - 05jan2026
begin

//quick check
if (not fd_focus.b.ok) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.rimage.w<1) or (fd_focus.b.t<>t_img) then exit;

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
sysfd_drawProc32:=350;

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

      sysfd_drawProc32:=352;
      goto l24;

      end;
   else
      begin

      sysfd_drawProc32:=351;
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

      sysfd_drawProc32:=354;
      goto l32;

      end;
   else begin

      sysfd_drawProc32:=353;
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
if (not fd_focus.b.ok) or (fd_focus.power255<1) or (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b.t<>t_img) then exit;

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
sysfd_drawProc32:=1300;

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

         sysfd_drawProc32:=1397;
         goto yredo96_24L;

         end;
      else
         begin

         sysfd_drawProc32:=1396;
         goto yredo96_N;

         end;
      end;//case

      end;
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=1325;
         goto lyredo24;

         end;
      else
         begin

         sysfd_drawProc32:=1324;
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

         sysfd_drawProc32:=1398;
         goto yredo96_32L;

         end;
      else begin

         sysfd_drawProc32:=1396;
         goto yredo96_N;

         end;
      end;//case

      end
   else begin

      case (fd_focus.lv8>=0) of
      true:begin

         sysfd_drawProc32:=1333;
         goto lyredo32;

         end;
      else begin

         sysfd_drawProc32:=1332;
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
sysfd_drawProc32:=1400;

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

      sysfd_drawProc32:=1498;
      goto yredo96_24L;

      end;
   else begin

      sysfd_drawProc32:=1497;
      goto yredo96_24;

      end;
   end;//case

   end;

else begin

   case (fd_focus.lv8>=0) of
   true:begin

      sysfd_drawProc32:=1425;
      goto lyredo24;

      end;
   else begin

      sysfd_drawProc32:=1424;
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
sysfd_drawProc32:=1500;

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

      sysfd_drawProc32:=1597;
      goto yredo96_32L;

      end;
   else begin

      sysfd_drawProc32:=1596;
      goto yredo96_32;

      end;
   end;//case

   end
else begin

   case (fd_focus.lv8>=0) of
   true:begin

      sysfd_drawProc32:=1533;
      goto lyredo32;

      end;
   else
      begin

      sysfd_drawProc32:=1532;
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

procedure xfd__fillSmallArea;//07jan2026
begin

if fd_focus.b.ok and (fd_focus.power255>=1) and (fd_focus.b.amode<>fd_area_outside_clip) and (fd_focus.b.t=t_img) then
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
sysfd_drawProc32:=1600;

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
      sysfd_drawProc32:=1625;
      goto lyredo24;

      end;
   else begin

      sysfd_drawProc32:=1624;
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
      sysfd_drawProc32:=1633;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=1632;
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
sysfd_drawProc32:=1600;

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
      sysfd_drawProc32:=1625;
      goto lyredo24;

      end;
   else begin

      sysfd_drawProc32:=1624;
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
      sysfd_drawProc32:=1633;
      goto lyredo32;

      end;
   else begin

      sysfd_drawProc32:=1632;
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

procedure xfd__drawRGB;//20feb2026
begin//supports pixel copying from "s.t_img" to "d.t_img" types

//check
if (not fd_focus.b.ok) or (not fd_focus.b2.ok) or (fd_focus.power255<1) or (fd_focus.b.t<>t_img) or (fd_focus.b2.t<>t_img) then exit;


if (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b2.amode=fd_area_outside_clip) then
   begin

   //nothing to do

   end

else if (fd_focus.b.aw<>fd_focus.b2.aw) or (fd_focus.b.ah<>fd_focus.b2.ah) then//03apr2026
   begin

   if (fd_focus.power255<>255) then
      begin

      xfd__drawRGB14100_power255_flip_mirror_cliprange_layer_stretch;

      end
   else begin

      xfd__drawRGB14000_flip_mirror_cliprange_layer_stretch;

      end;

   end

else if (fd_focus.lv8>=0) then//20feb2026
   begin

   xfd__drawRGB1000_power255_flip_mirror_cliprange_layer;

   end

else if (fd_focus.b.amode=fd_area_inside_clip) and (fd_focus.b2.amode=fd_area_inside_clip) and
        (fd_focus.b.aw=fd_focus.b.aw) and (fd_focus.b.ah=fd_focus.b.ah) then
   begin

   if (fd_focus.power255<>255) then
      begin

      case fd_focus.flip or fd_focus.mirror of
      true:xfd__drawRGB900_power255_flip_mirror_cliprange;
      else xfd__drawRGB700_power255;
      end;//case

      end

   else if fd_focus.flip or fd_focus.mirror then
      begin

      xfd__drawRGB800_flip_mirror_cliprange;

      end

   else if (fd_focus.b.bits=fd_focus.b2.bits) and
           (fd_focus.b.ax1=fd_focus.b2.ax1) and
           (fd_focus.b.ay1=fd_focus.b2.ay1) and
           (fd_focus.b.aw =fd_focus.b2.aw ) and
           (fd_focus.b.ah =fd_focus.b2.ah ) then
           begin

           xfd__drawRGB500;//same bit depth and same area

           end

   else xfd__drawRGB600;

   end

else begin

   case (fd_focus.power255<>255) of
   true:xfd__drawRGB900_power255_flip_mirror_cliprange;
   else xfd__drawRGB800_flip_mirror_cliprange;
   end;//case

   end;

end;

procedure xfd__drawRGB500;
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
sysfd_drawProc32:=500;

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

      sysfd_drawProc32:=597;
      goto yredo96_N;

      end;
   else
      begin

      sysfd_drawProc32:=524;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b .rows);
   sr32   :=pcolorrows32(fd_focus.b2.rows);

   case xcan96 of
   true:begin

      sysfd_drawProc32:=598;
      goto yredo96_N;

      end;
   else
      begin

      sysfd_drawProc32:=532;
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

procedure xfd__drawRGB600;
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
sysfd_drawProc32:=600;

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

      sysfd_drawProc32:=698;
      goto yredo96_N;

      end
   else
      begin

      case fd_focus.b2.bits of
      24:begin

         sysfd_drawProc32:=624;
         goto yredo24_24;

         end;
      32:begin

         sysfd_drawProc32:=625;
         goto yredo24_32;

         end;
      end;//case

      end;

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   if xcan96 then
      begin

      sysfd_drawProc32:=698;
      goto yredo96_N;

      end
   else
      begin

      case fd_focus.b2.bits of
      24:begin

         sysfd_drawProc32:=633;
         goto yredo32_24;

         end;
      32:begin

         sysfd_drawProc32:=632;
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

procedure xfd__drawRGB700_power255;//06jan2026, 29dec2025
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
sysfd_drawProc32:=700;

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
if (ca=0) then exit;//28feb2026

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

      sysfd_drawProc32:=797;
      goto yredo96_N;

      end;
   else begin

      case fd_focus.b2.bits of
      24:begin

         sysfd_drawProc32:=724;
         goto yredo24_24;

         end;
      32:begin

         sysfd_drawProc32:=725;
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

      sysfd_drawProc32:=798;
      goto yredo96_N;

      end;
   else begin

      case fd_focus.b2.bits of
      24:begin

         sysfd_drawProc32:=732;
         goto yredo32_24;

         end;
      32:begin

         sysfd_drawProc32:=733;
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

procedure xfd__drawRGB800_flip_mirror_cliprange;
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
sysfd_drawProc32:=800;

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

      sysfd_drawProc32:=824;
      goto yredo24_24;

      end;
   32:begin

      sysfd_drawProc32:=825;
      goto yredo24_32;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      sysfd_drawProc32:=832;
      goto yredo32_24;

      end;
   32:begin

      sysfd_drawProc32:=833;
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

procedure xfd__drawRGB900_power255_flip_mirror_cliprange;
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
sysfd_drawProc32:=900;

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
if (ca=0) then exit;//28feb2026

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

      sysfd_drawProc32:=924;
      goto yredo24_24;

      end;
   32:begin

      sysfd_drawProc32:=925;
      goto yredo24_32;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      sysfd_drawProc32:=932;
      goto yredo32_24;

      end;
   32:begin

      sysfd_drawProc32:=933;
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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then
   begin

   s24   :=@sr24[sy][sx];
   d24   :=@dr24[dy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
   d24.g :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
   d24.b :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

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
   d24.r :=( (cainv*d24.r) + (ca*s32.r) ) shr 8;
   d24.g :=( (cainv*d24.g) + (ca*s32.g) ) shr 8;
   d24.b :=( (cainv*d24.b) + (ca*s32.b) ) shr 8;

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
   d32.r :=( (cainv*d32.r) + (ca*s32.r) ) shr 8;
   d32.g :=( (cainv*d32.g) + (ca*s32.g) ) shr 8;
   d32.b :=( (cainv*d32.b) + (ca*s32.b) ) shr 8;
   d32.a :=( (cainv*d32.a) + (ca*s32.a) ) shr 8;

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
   d32.r :=( (cainv*d32.r) + (ca*s24.r) ) shr 8;
   d32.g :=( (cainv*d32.g) + (ca*s24.g) ) shr 8;
   d32.b :=( (cainv*d32.b) + (ca*s24.b) ) shr 8;
   d32.a :=( (cainv*d32.a) + (ca*255  ) ) shr 8;

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

procedure xfd__drawRGB1000_power255_flip_mirror_cliprange_layer;//20feb2026
label
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24;
var
   lr8 :pcolorrows8;//20feb2026
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
   lv8:longint;

begin

//defaults
sysfd_drawProc32:=1000;

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
if (ca=0)  then exit;

lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );

if (lv8<0) then exit;

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

      sysfd_drawProc32:=924;
      goto yredo24_24;

      end;
   32:begin

      sysfd_drawProc32:=925;
      goto yredo24_32;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      sysfd_drawProc32:=932;
      goto yredo32_24;

      end;
   32:begin

      sysfd_drawProc32:=933;
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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (lr8[dy][dx]=lv8) then
   begin

   s24   :=@sr24[sy][sx];
   d24   :=@dr24[dy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;//"shr 8" is 104% faster than "div 256"
   d24.g :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
   d24.b :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (lr8[dy][dx]=lv8) then
   begin

   s32   :=@sr32[sy][sx];
   d24   :=@dr24[dy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s32.r) ) shr 8;
   d24.g :=( (cainv*d24.g) + (ca*s32.g) ) shr 8;
   d24.b :=( (cainv*d24.b) + (ca*s32.b) ) shr 8;

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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (lr8[dy][dx]=lv8) then
   begin

   s32   :=@sr32[sy][sx];
   d32   :=@dr32[dy][dx];
   d32.r :=( (cainv*d32.r) + (ca*s32.r) ) shr 8;
   d32.g :=( (cainv*d32.g) + (ca*s32.g) ) shr 8;
   d32.b :=( (cainv*d32.b) + (ca*s32.b) ) shr 8;
   d32.a :=( (cainv*d32.a) + (ca*s32.a) ) shr 8;

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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (lr8[dy][dx]=lv8) then
   begin

   s24   :=@sr24[sy][sx];
   d32   :=@dr32[dy][dx];
   d32.r :=( (cainv*d32.r) + (ca*s24.r) ) shr 8;
   d32.g :=( (cainv*d32.g) + (ca*s24.g) ) shr 8;
   d32.b :=( (cainv*d32.b) + (ca*s24.b) ) shr 8;
   d32.a :=( (cainv*d32.a) + (ca*255  ) ) shr 8;

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

procedure xfd__drawRGB14000_flip_mirror_cliprange_layer_stretch;//03apr2026
label
   render ,lrender ,skipend;

var
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support

   lr8 :pcolorrows8;//20feb2026
   srs24,drs24:pcolorrows24;
   srs32,drs32:pcolorrows32;
   sr24,dr24:pcolorrow24;
   sr32,dr32:pcolorrow32;

   dx1,dx2,dy1,dy2,lv8,sd,ddw,ddh,sx,sy,sw,sh,dx,dy:longint32;

   d24,s24:pcolor24;
   d32,s32:pcolor32;
   c32:tcolor32;
   c24:tcolor24;

   dclip,da,sa:twinrect;

   xmirror,xflip:boolean;

begin


//defaults ---------------------------------------------------------------------

sysfd_drawProc32      :=14000;
_mx                   :=nil;
_my                   :=nil;

//init -------------------------------------------------------------------------

//target area
dclip.left            :=fd_focus.b.cx1;//target clip
dclip.right           :=fd_focus.b.cx2;
dclip.top             :=fd_focus.b.cy1;
dclip.bottom          :=fd_focus.b.cy2;

da.left               :=fd_focus.b.ax1;//target area
da.right              :=fd_focus.b.ax2;
da.top                :=fd_focus.b.ay1;
da.bottom             :=fd_focus.b.ay2;

ddw                   :=da.right  - da.left + 1;
ddh                   :=da.bottom - da.top  + 1;

//.optimise actual x-pixels scanned -> dx1..dx2
dx1                   :=largest32 ( largest32 (da.left  ,dclip.left ) ,0    );
dx2                   :=smallest32( smallest32(da.right ,dclip.right) ,fd_focus.b.w-1 );

if (dx2<dx1) then exit;

//.optimise actual y-pixels scanned -> dy1...dy2
dy1                   :=largest32 ( largest32 (da.top    ,dclip.top   ) ,0    );
dy2                   :=smallest32( smallest32(da.bottom ,dclip.bottom) ,fd_focus.b.h-1 );

if (dy2<dy1) then exit;

//source area
sa.left               :=frcrange32( fd_focus.b2.ax1 ,fd_focus.b2.cx1 ,fd_focus.b2.cx2 );//source area
sa.right              :=frcrange32( fd_focus.b2.ax2 ,sa.left         ,fd_focus.b2.cx2 );
sa.top                :=frcrange32( fd_focus.b2.ay1 ,fd_focus.b2.cy1 ,fd_focus.b2.cy2 );
sa.bottom             :=frcrange32( fd_focus.b2.ay2 ,sa.top          ,fd_focus.b2.cy2 );

sw                    :=fd_focus.b2.w;
sh                    :=fd_focus.b2.h;

//layer
lv8                   :=fd_focus.lv8;

//source buffer
case fd_focus.b2.bits of
24:srs24              :=pcolorrows24(fd_focus.b2.rows);
32:srs32              :=pcolorrows32(fd_focus.b2.rows);
else                   exit;
end;//case

//target buffer
case fd_focus.b.bits of
24:drs24              :=pcolorrows24(fd_focus.b.rows);
32:drs32              :=pcolorrows32(fd_focus.b.rows);
else                   exit;
end;//case

//source and target bit pair code
sd                    :=mis__sdPair( fd_focus.b2.bits ,fd_focus.b.bits );

//mirror + flip
xmirror               :=fd_focus.mirror;
xflip                 :=fd_focus.flip;


//map X and Y scales -----------------------------------------------------------

//.mx
_mx                   :=rescache__newMapped( 1 ,ddw ,sa.left ,sa.right ,(sa.right-sa.left+1) );
mx                    :=_mx.core;

//.my
_my                   :=rescache__newMapped( 1 ,ddh ,sa.top ,sa.bottom ,(sa.bottom-sa.top+1) );
my                    :=_my.core;


//decide - normal or layer render ----------------------------------------------

if (lv8>=0) then
   begin

   lr8                :=pcolorrows8( fd_focus.lr8 );

   goto lrender;

   end;


//render pixels ----------------------------------------------------------------
render:
sysfd_drawProc32      :=14001;

//dy
for dy:=dy1 to dy2 do
begin

//target row
if      (fd_focus.b.bits=32)  then dr32:=@drs32[dy]^
else if (fd_focus.b.bits=24)  then dr24:=@drs24[dy]^;

//sy
if xflip then sy:=my[ pred(ddh) - dy + da.top ] else sy:=my[ dy - da.top ];//zero base

//range
if (sy>=0) and (sy<sh) then
   begin

   //track
   xfd__inc32( dx2 - dx1 + 1 );

   //source row
   if      (fd_focus.b2.bits=32) then sr32:=@srs32[sy]^
   else if (fd_focus.b2.bits=24) then sr24:=@srs24[sy]^;

   //dx - note: a simple "if chain" is 1.5x faster than using a "case" statement - 03apr2026

   //32 -> 32 ------------------------------------------------------------------
   if (sd=sd32_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            dr32[dx]  :=sr32[sx];

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            dr32[dx]  :=sr32[sx];

            end;

         end;//dx

         end;//if

      end

   //32 -> 24 ---------------------------------------------------------------
   else if (sd=sd32_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            dr24[dx]  :=tint4( sr32[sx] ).bgr24;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            dr24[dx]  :=tint4( sr32[sx] ).bgr24;

            end;

         end;//dx

         end;//if

      end

   //24 -> 32 ---------------------------------------------------------------
   else if (sd=sd24_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            tint4( dr32[dx] ).bgr24    :=sr24[sx];
            dr32[dx].a                 :=255;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            tint4( dr32[dx] ).bgr24    :=sr24[sx];
            dr32[dx].a                 :=255;

            end;

         end;//dx

         end;//if

      end

   //24 -> 24 ---------------------------------------------------------------
   else if (sd=sd24_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            dr24[dx]  :=sr24[sx];

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            dr24[dx]  :=sr24[sx];

            end;

         end;//dx

         end;//if

      end;

   end;//sy

end;//dy

//done
goto skipend;


//lrender ----------------------------------------------------------------------
lrender:
sysfd_drawProc32      :=14002;

//dy
for dy:=dy1 to dy2 do
begin

//target row
if      (fd_focus.b.bits=32)  then dr32:=@drs32[dy]^
else if (fd_focus.b.bits=24)  then dr24:=@drs24[dy]^;

//sy
if xflip then sy:=my[ pred(ddh) - dy + da.top ] else sy:=my[ dy - da.top ];//zero base

//range
if (sy>=0) and (sy<sh) then
   begin

   //track
   xfd__inc32( dx2 - dx1 + 1 );

   //source row
   if      (fd_focus.b2.bits=32) then sr32:=@srs32[sy]^
   else if (fd_focus.b2.bits=24) then sr24:=@srs24[sy]^;

   //dx - note: a simple "if chain" is 1.5x faster than using a "case" statement - 03apr2026

   //32 -> 32 ------------------------------------------------------------------
   if (sd=sd32_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            dr32[dx]  :=sr32[sx];

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            dr32[dx]  :=sr32[sx];

            end;

         end;//dx

         end;//if

      end

   //32 -> 24 ---------------------------------------------------------------
   else if (sd=sd32_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            dr24[dx]  :=tint4( sr32[sx] ).bgr24;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            dr24[dx]  :=tint4( sr32[sx] ).bgr24;

            end;

         end;//dx

         end;//if

      end

   //24 -> 32 ---------------------------------------------------------------
   else if (sd=sd24_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            tint4( dr32[dx] ).bgr24    :=sr24[sx];
            dr32[dx].a                 :=255;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            tint4( dr32[dx] ).bgr24    :=sr24[sx];
            dr32[dx].a                 :=255;

            end;

         end;//dx

         end;//if

      end

   //24 -> 24 ---------------------------------------------------------------
   else if (sd=sd24_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            dr24[dx]  :=sr24[sx];

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            dr24[dx]  :=sr24[sx];

            end;

         end;//dx

         end;//if

      end;

   end;//sy

end;//dy

//done
goto skipend;


//finish -----------------------------------------------------------------------

skipend:

//track
xfd__inc64;

//free
if (_mx<>nil) then rescache__delMapped( @_mx );
if (_my<>nil) then rescache__delMapped( @_my );

end;

procedure xfd__drawRGB14100_power255_flip_mirror_cliprange_layer_stretch;//03apr2026
label
   render ,lrender ,skipend;

var
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support

   lr8 :pcolorrows8;//20feb2026
   srs24,drs24:pcolorrows24;
   srs32,drs32:pcolorrows32;
   sr24,dr24:pcolorrow24;
   sr32,dr32:pcolorrow32;

   dx1,dx2,dy1,dy2,lv8,ca,cainv,sd,ddw,ddh,sx,sy,sw,sh,dx,dy:longint32;

   d24,s24:pcolor24;
   d32,s32:pcolor32;
   c32:tcolor32;
   c24:tcolor24;

   dclip,da,sa:twinrect;

   xmirror,xflip:boolean;

begin


//defaults ---------------------------------------------------------------------

sysfd_drawProc32      :=14100;
_mx                   :=nil;
_my                   :=nil;

//init -------------------------------------------------------------------------

//target area
dclip.left            :=fd_focus.b.cx1;//target clip
dclip.right           :=fd_focus.b.cx2;
dclip.top             :=fd_focus.b.cy1;
dclip.bottom          :=fd_focus.b.cy2;

da.left               :=fd_focus.b.ax1;//target area
da.right              :=fd_focus.b.ax2;
da.top                :=fd_focus.b.ay1;
da.bottom             :=fd_focus.b.ay2;

ddw                   :=da.right  - da.left + 1;
ddh                   :=da.bottom - da.top  + 1;

//.optimise actual x-pixels scanned -> dx1..dx2
dx1                   :=largest32 ( largest32 (da.left  ,dclip.left ) ,0    );
dx2                   :=smallest32( smallest32(da.right ,dclip.right) ,fd_focus.b.w-1 );

if (dx2<dx1) then exit;

//.optimise actual y-pixels scanned -> dy1...dy2
dy1                   :=largest32 ( largest32 (da.top    ,dclip.top   ) ,0    );
dy2                   :=smallest32( smallest32(da.bottom ,dclip.bottom) ,fd_focus.b.h-1 );

if (dy2<dy1) then exit;

//source area
sa.left               :=frcrange32( fd_focus.b2.ax1 ,fd_focus.b2.cx1 ,fd_focus.b2.cx2 );//source area
sa.right              :=frcrange32( fd_focus.b2.ax2 ,sa.left         ,fd_focus.b2.cx2 );
sa.top                :=frcrange32( fd_focus.b2.ay1 ,fd_focus.b2.cy1 ,fd_focus.b2.cy2 );
sa.bottom             :=frcrange32( fd_focus.b2.ay2 ,sa.top          ,fd_focus.b2.cy2 );

sw                    :=fd_focus.b2.w;
sh                    :=fd_focus.b2.h;

//layer
lv8                   :=fd_focus.lv8;

//source buffer
case fd_focus.b2.bits of
24:srs24              :=pcolorrows24(fd_focus.b2.rows);
32:srs32              :=pcolorrows32(fd_focus.b2.rows);
else                   exit;
end;//case

//target buffer
case fd_focus.b.bits of
24:drs24              :=pcolorrows24(fd_focus.b.rows);
32:drs32              :=pcolorrows32(fd_focus.b.rows);
else                   exit;
end;//case

//source and target bit pair code
sd                    :=mis__sdPair( fd_focus.b2.bits ,fd_focus.b.bits );

//power
ca                    :=fd_focus.power255;
cainv                 :=255 - ca;

//mirror + flip
xmirror               :=fd_focus.mirror;
xflip                 :=fd_focus.flip;


//map X and Y scales -----------------------------------------------------------

//.mx
_mx                   :=rescache__newMapped( 1 ,ddw ,sa.left ,sa.right ,(sa.right-sa.left+1) );
mx                    :=_mx.core;

//.my
_my                   :=rescache__newMapped( 1 ,ddh ,sa.top ,sa.bottom ,(sa.bottom-sa.top+1) );
my                    :=_my.core;


//decide - normal or layer render ----------------------------------------------
if (lv8>=0) then
   begin

   lr8                :=pcolorrows8( fd_focus.lr8 );

   goto lrender;

   end;


//render pixels ----------------------------------------------------------------
render:
sysfd_drawProc32      :=14101;

//dy
for dy:=dy1 to dy2 do
begin

//target row
if      (fd_focus.b.bits=32)  then dr32:=@drs32[dy]^
else if (fd_focus.b.bits=24)  then dr24:=@drs24[dy]^;

//sy
if xflip then sy:=my[ pred(ddh) - dy + da.top ] else sy:=my[ dy - da.top ];//zero base

//range
if (sy>=0) and (sy<sh) then
   begin

   //track
   xfd__inc32( dx2 - dx1 + 1 );

   //source row
   if      (fd_focus.b2.bits=32) then sr32:=@srs32[sy]^
   else if (fd_focus.b2.bits=24) then sr24:=@srs24[sy]^;

   //dx - note: a simple "if chain" is 1.5x faster than using a "case" statement - 03apr2026

   //32 -> 32 ------------------------------------------------------------------
   if (sd=sd32_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (d32.r*cainv) + (s32.r*ca) ) shr 8;
            d32.g     :=( (d32.g*cainv) + (s32.g*ca) ) shr 8;
            d32.b     :=( (d32.b*cainv) + (s32.b*ca) ) shr 8;
            d32.a     :=( (d32.a*cainv) + (s32.a*ca) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (d32.r*cainv) + (s32.r*ca) ) shr 8;
            d32.g     :=( (d32.g*cainv) + (s32.g*ca) ) shr 8;
            d32.b     :=( (d32.b*cainv) + (s32.b*ca) ) shr 8;
            d32.a     :=( (d32.a*cainv) + (s32.a*ca) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //32 -> 24 ---------------------------------------------------------------
   else if (sd=sd32_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (d24.r*cainv) + (s32.r*ca) ) shr 8;
            d24.g     :=( (d24.g*cainv) + (s32.g*ca) ) shr 8;
            d24.b     :=( (d24.b*cainv) + (s32.b*ca) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (d24.r*cainv) + (s32.r*ca) ) shr 8;
            d24.g     :=( (d24.g*cainv) + (s32.g*ca) ) shr 8;
            d24.b     :=( (d24.b*cainv) + (s32.b*ca) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 32 ---------------------------------------------------------------
   else if (sd=sd24_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s24       :=@sr24[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (d32.r*cainv) + (s24.r*ca) ) shr 8;
            d32.g     :=( (d32.g*cainv) + (s24.g*ca) ) shr 8;
            d32.b     :=( (d32.b*cainv) + (s24.b*ca) ) shr 8;
            d32.a     :=( (d32.a*cainv) + (255  *ca) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s24       :=@sr24[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (d32.r*cainv) + (s24.r*ca) ) shr 8;
            d32.g     :=( (d32.g*cainv) + (s24.g*ca) ) shr 8;
            d32.b     :=( (d32.b*cainv) + (s24.b*ca) ) shr 8;
            d32.a     :=( (d32.a*cainv) + (255  *ca) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 24 ---------------------------------------------------------------
   else if (sd=sd24_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s24       :=@sr24[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (d24.r*cainv) + (s24.r*ca) ) shr 8;
            d24.g     :=( (d24.g*cainv) + (s24.g*ca) ) shr 8;
            d24.b     :=( (d24.b*cainv) + (s24.b*ca) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s24       :=@sr24[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (d24.r*cainv) + (s24.r*ca) ) shr 8;
            d24.g     :=( (d24.g*cainv) + (s24.g*ca) ) shr 8;
            d24.b     :=( (d24.b*cainv) + (s24.b*ca) ) shr 8;

            end;

         end;//dx

         end;//if

      end;

   end;//sy

end;//dy

//done
goto skipend;


//lrender ----------------------------------------------------------------------
lrender:
sysfd_drawProc32      :=14102;

//dy
for dy:=dy1 to dy2 do
begin

//target row
if      (fd_focus.b.bits=32)  then dr32:=@drs32[dy]^
else if (fd_focus.b.bits=24)  then dr24:=@drs24[dy]^;

//sy
if xflip then sy:=my[ pred(ddh) - dy + da.top ] else sy:=my[ dy - da.top ];//zero base

//range
if (sy>=0) and (sy<sh) then
   begin

   //track
   xfd__inc32( dx2 - dx1 + 1 );

   //source row
   if      (fd_focus.b2.bits=32) then sr32:=@srs32[sy]^
   else if (fd_focus.b2.bits=24) then sr24:=@srs24[sy]^;

   //dx - note: a simple "if chain" is 1.5x faster than using a "case" statement - 03apr2026

   //32 -> 32 ------------------------------------------------------------------
   if (sd=sd32_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (d32.r*cainv) + (s32.r*ca) ) shr 8;
            d32.g     :=( (d32.g*cainv) + (s32.g*ca) ) shr 8;
            d32.b     :=( (d32.b*cainv) + (s32.b*ca) ) shr 8;
            d32.a     :=( (d32.a*cainv) + (s32.a*ca) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (d32.r*cainv) + (s32.r*ca) ) shr 8;
            d32.g     :=( (d32.g*cainv) + (s32.g*ca) ) shr 8;
            d32.b     :=( (d32.b*cainv) + (s32.b*ca) ) shr 8;
            d32.a     :=( (d32.a*cainv) + (s32.a*ca) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //32 -> 24 ---------------------------------------------------------------
   else if (sd=sd32_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (d24.r*cainv) + (s32.r*ca) ) shr 8;
            d24.g     :=( (d24.g*cainv) + (s32.g*ca) ) shr 8;
            d24.b     :=( (d24.b*cainv) + (s32.b*ca) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (d24.r*cainv) + (s32.r*ca) ) shr 8;
            d24.g     :=( (d24.g*cainv) + (s32.g*ca) ) shr 8;
            d24.b     :=( (d24.b*cainv) + (s32.b*ca) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 32 ---------------------------------------------------------------
   else if (sd=sd24_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s24       :=@sr24[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (d32.r*cainv) + (s24.r*ca) ) shr 8;
            d32.g     :=( (d32.g*cainv) + (s24.g*ca) ) shr 8;
            d32.b     :=( (d32.b*cainv) + (s24.b*ca) ) shr 8;
            d32.a     :=( (d32.a*cainv) + (255  *ca) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s24       :=@sr24[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (d32.r*cainv) + (s24.r*ca) ) shr 8;
            d32.g     :=( (d32.g*cainv) + (s24.g*ca) ) shr 8;
            d32.b     :=( (d32.b*cainv) + (s24.b*ca) ) shr 8;
            d32.a     :=( (d32.a*cainv) + (255  *ca) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 24 ---------------------------------------------------------------
   else if (sd=sd24_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s24       :=@sr24[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (d24.r*cainv) + (s24.r*ca) ) shr 8;
            d24.g     :=( (d24.g*cainv) + (s24.g*ca) ) shr 8;
            d24.b     :=( (d24.b*cainv) + (s24.b*ca) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s24       :=@sr24[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (d24.r*cainv) + (s24.r*ca) ) shr 8;
            d24.g     :=( (d24.g*cainv) + (s24.g*ca) ) shr 8;
            d24.b     :=( (d24.b*cainv) + (s24.b*ca) ) shr 8;

            end;

         end;//dx

         end;//if

      end;

   end;//sy

end;//dy

//done
goto skipend;


//finish -----------------------------------------------------------------------

skipend:

//track
xfd__inc64;

//free
if (_mx<>nil) then rescache__delMapped( @_mx );
if (_my<>nil) then rescache__delMapped( @_my );

end;

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
if (not sysfd_optimise_ok) or (x.aw<=30) then
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
if (not sysfd_optimise_ok) or ((xmax-xmin+1)<=30) then
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

procedure xfd__drawRGBA;//15mar2026
begin//supports pixel copying from "s.t_img" to "d.t_img" types

//check
if (not fd_focus.b.ok) or (not fd_focus.b2.ok) or (fd_focus.power255<1) or (fd_focus.b.t<>t_img) or (fd_focus.b2.t<>t_img) then exit;


if (fd_focus.b.amode=fd_area_outside_clip) or (fd_focus.b2.amode=fd_area_outside_clip) then
   begin

   //nothing to do

   end

else if (fd_focus.b.aw<>fd_focus.b2.aw) or (fd_focus.b.ah<>fd_focus.b2.ah) then//04apr2026
   begin

   if (fd_focus.power255<>255) then
      begin

      xfd__drawRGBA15100_power255_flip_mirror_cliprange_layer_stretch;

      end
   else begin

      xfd__drawRGBA15000_flip_mirror_cliprange_layer_stretch;

      end;

   end

else if (fd_focus.lv8>=0) then
   begin

   xfd__drawRGBA10000_power255_flip_mirror_cliprange_layer;

   end

else if (fd_focus.b.amode=fd_area_inside_clip) and (fd_focus.b2.amode=fd_area_inside_clip) and
        (fd_focus.b.aw=fd_focus.b.aw) and (fd_focus.b.ah=fd_focus.b.ah) then
   begin

   if (fd_focus.power255<>255) then
      begin

      case fd_focus.flip or fd_focus.mirror of
      true:xfd__drawRGBA9900_power255_flip_mirror_cliprange;
      else xfd__drawRGBA9700_power255;
      end;//case

      end

   else if fd_focus.flip or fd_focus.mirror then
      begin

      xfd__drawRGBA9800_flip_mirror_cliprange;

      end

   else if (fd_focus.b.bits=fd_focus.b2.bits) and
           (fd_focus.b.ax1=fd_focus.b2.ax1) and
           (fd_focus.b.ay1=fd_focus.b2.ay1) and
           (fd_focus.b.aw =fd_focus.b2.aw ) and
           (fd_focus.b.ah =fd_focus.b2.ah ) then
           begin

           xfd__drawRGBA9500;//same bit depth and same area

           end
   else xfd__drawRGBA9600;

   end

else
   begin

   case (fd_focus.power255<>255) of
   true:xfd__drawRGBA9900_power255_flip_mirror_cliprange;
   else xfd__drawRGBA9800_flip_mirror_cliprange;
   end;//case

   end;

end;

procedure xfd__drawRGBA9500;//15mar2026
label//copies pixels from "b2" (source buffer) => "b" (target buffer)
   yredo24,xredo24,yredo32,xredo32,
   yredo96_32,xredo96_32,yredo96_24,xredo96_24;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   sr96:pcolorrows96;
   dr96:pcolorrows96;
   s32,d32:pcolor32;
   s96,d96:pcolor96;
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
sysfd_drawProc32:=9500;

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

      sysfd_drawProc32:=9597;
      goto yredo96_24;

      end;
   else
      begin

      sysfd_drawProc32:=9524;
      goto yredo24;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b .rows);
   sr32   :=pcolorrows32(fd_focus.b2.rows);

   case xcan96 of
   true:begin

      sysfd_drawProc32:=9598;
      goto yredo96_32;

      end;
   else
      begin

      sysfd_drawProc32:=9532;
      goto yredo32;

      end;
   end;//case

   end;
else exit;
end;//case


//render96_32 ------------------------------------------------------------------
yredo96_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset96;

xredo96_32:

//render pixel - bgra=v0123, bgra=4567, bgra=891011
s96         :=@sr96[dy][dx];
d96         :=@dr96[dy][dx];

d96.v0      :=( ((255-s96.v3)*d96.v0 )  + (s96.v3*s96.v0 ) ) shr 8;
d96.v1      :=( ((255-s96.v3)*d96.v1 )  + (s96.v3*s96.v1 ) ) shr 8;
d96.v2      :=( ((255-s96.v3)*d96.v2 )  + (s96.v3*s96.v2 ) ) shr 8;

d96.v4      :=( ((255-s96.v7)*d96.v4 )  + (s96.v7*s96.v4 ) ) shr 8;
d96.v5      :=( ((255-s96.v7)*d96.v5 )  + (s96.v7*s96.v5 ) ) shr 8;
d96.v6      :=( ((255-s96.v7)*d96.v6 )  + (s96.v7*s96.v6 ) ) shr 8;

d96.v8      :=( ((255-s96.v11)*d96.v8 )  + (s96.v11*s96.v8 ) ) shr 8;
d96.v9      :=( ((255-s96.v11)*d96.v9 )  + (s96.v11*s96.v9 ) ) shr 8;
d96.v10     :=( ((255-s96.v11)*d96.v10)  + (s96.v11*s96.v10) ) shr 8;
   
//inc x
if (dx<>xstop96) then
   begin

   inc(dx,1);
   goto xredo96_32;

   end;

//row "begin" and "end" gaps
for dx:=lx1 to lx2 do
begin

s32         :=@sr32[dy][dx];
d32         :=@dr32[dy][dx];
d32.r       :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
d32.g       :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
d32.b       :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

end;//dx

for dx:=rx1 to rx2 do
begin

s32         :=@sr32[dy][dx];
d32         :=@dr32[dy][dx];
d32.r       :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
d32.g       :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
d32.b       :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

end;//dx

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   goto yredo96_32;

   end;

//done
xfd__inc64;
exit;


//render96_24 ------------------------------------------------------------------
yredo96_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset96;

xredo96_24:

//render pixel
dr96[dy][dx]:=sr96[dy][dx];

//inc x
if (dx<>xstop96) then
   begin

   inc(dx,1);
   goto xredo96_24;

   end;

//row "begin" and "end" gaps
for dx:=lx1 to lx2 do dr24[dy][dx]:=sr24[dy][dx];
for dx:=rx1 to rx2 do dr24[dy][dx]:=sr24[dy][dx];

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   goto yredo96_24;

   end;

//done
xfd__inc64;
exit;


//render24 ---------------------------------------------------------------------
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


//render32 ---------------------------------------------------------------------
yredo32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;

xredo32:

//render pixel
s32         :=@sr32[dy][dx];
d32         :=@dr32[dy][dx];
d32.r       :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
d32.g       :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
d32.b       :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

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

procedure xfd__drawRGBA9600;//15mar2026
label//copies pixels from fastdraw_focus.info2.drawinfo (source buffer) => fastdraw_focus.info.drawinfo (target buffer)
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24,
   yredo96_32,xredo96_32,yredo96_24,xredo96_24;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   sr96:pcolorrows96;
   dr96:pcolorrows96;
   s24,d24:pcolor24;
   s32,d32:pcolor32;
   s96,d96:pcolor96;
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
sysfd_drawProc32:=9600;

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

      sysfd_drawProc32:=9698;
      goto yredo96_24;

      end
   else
      begin

      case fd_focus.b2.bits of
      24:begin

         sysfd_drawProc32:=9624;
         goto yredo24_24;

         end;
      32:begin

         sysfd_drawProc32:=9625;
         goto yredo24_32;

         end;
      end;//case

      end;

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   if xcan96 then
      begin

      sysfd_drawProc32:=9698;
      goto yredo96_32;

      end
   else
      begin

      case fd_focus.b2.bits of
      24:begin

         sysfd_drawProc32:=9633;
         goto yredo32_24;

         end;
      32:begin

         sysfd_drawProc32:=9632;
         goto yredo32_32;

         end;
      end;//case

      end;

   end;
else exit;
end;//case


//render96_32 ------------------------------------------------------------------
yredo96_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset96;

//render pixel - bgra=v0123, bgra=4567, bgra=891011
xredo96_32:

s96         :=@sr96[sy][dx];
d96         :=@dr96[dy][dx];

d96.v0      :=( ((255-s96.v3)*d96.v0 )  + (s96.v3*s96.v0 ) ) shr 8;
d96.v1      :=( ((255-s96.v3)*d96.v1 )  + (s96.v3*s96.v1 ) ) shr 8;
d96.v2      :=( ((255-s96.v3)*d96.v2 )  + (s96.v3*s96.v2 ) ) shr 8;

d96.v4      :=( ((255-s96.v7)*d96.v4 )  + (s96.v7*s96.v4 ) ) shr 8;
d96.v5      :=( ((255-s96.v7)*d96.v5 )  + (s96.v7*s96.v5 ) ) shr 8;
d96.v6      :=( ((255-s96.v7)*d96.v6 )  + (s96.v7*s96.v6 ) ) shr 8;

d96.v8      :=( ((255-s96.v11)*d96.v8 )  + (s96.v11*s96.v8 ) ) shr 8;
d96.v9      :=( ((255-s96.v11)*d96.v9 )  + (s96.v11*s96.v9 ) ) shr 8;
d96.v10     :=( ((255-s96.v11)*d96.v10)  + (s96.v11*s96.v10) ) shr 8;

//inc x
if (dx<>xstop96) then
   begin

   inc(dx,1);
   goto xredo96_32;

   end;

//row "begin" and "end" gaps
for dx:=lx1 to lx2 do
begin

s32   :=@sr32[sy][dx];
d32   :=@dr32[dy][dx];
d32.r :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
d32.g :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
d32.b :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

end;//dx

for dx:=rx1 to rx2 do
begin

s32   :=@sr32[sy][dx];
d32   :=@dr32[dy][dx];
d32.r :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
d32.g :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
d32.b :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

end;//dx

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo96_32;

   end;

//done
xfd__inc64;
exit;


//render96_32 ------------------------------------------------------------------
yredo96_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset96;

//render pixel - bgr=v012, bgr=345, bgr=678 ,bgr=91011
xredo96_24:

dr96[dy][dx]:=sr96[sy][dx];


//inc x
if (dx<>xstop96) then
   begin

   inc(dx,1);
   goto xredo96_24;

   end;

//row "begin" and "end" gaps
for dx:=lx1 to lx2 do dr24[dy][dx]:=sr24[sy][dx];
for dx:=rx1 to rx2 do dr24[dy][dx]:=sr24[sy][dx];

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo96_24;

   end;

//done
xfd__inc64;
exit;


//render24_24 -------------------------------------------------------------------
yredo24_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;

xredo24_24:

//render pixel: RGB -> RGB
dr24[dy][dx]:=sr24[sy][dx];

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


//render24_32 -------------------------------------------------------------------
yredo24_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;

xredo24_32:

//render pixel: RGBA -> RGB
s32   :=@sr32[sy][sx];
d24   :=@dr24[dy][dx];
d24.r :=( ((255-s32.a)*d24.r) + (s32.a*s32.r) ) shr 8;
d24.g :=( ((255-s32.a)*d24.g) + (s32.a*s32.g) ) shr 8;
d24.b :=( ((255-s32.a)*d24.b) + (s32.a*s32.b) ) shr 8;

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


//render32_32 -------------------------------------------------------------------
yredo32_32:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;

xredo32_32:

//render pixel: RGBA -> RGBA
s32         :=@sr32[sy][sx];
d32         :=@dr32[dy][dx];
d32.r       :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
d32.g       :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
d32.b       :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

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


//render32_24 -------------------------------------------------------------------
yredo32_24:

xfd__inc32(fd_focus.b.aw);
dx  :=xreset;
sx  :=xreset2;

xredo32_24:

//render pixel: RGB -> RGBA
tint4( dr32[dy][dx] ).bgr24:=sr24[sy][sx];

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

procedure xfd__drawRGBA9700_power255;//19mar2026, 15mar2026
label//copies pixels from fastdraw_focus.info2.drawinfo (source buffer) => fastdraw_focus.info.drawinfo (target buffer)
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24,
   yredo96_32,xredo96_32,yredo96_24,xredo96_24;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   sr96:pcolorrows96;
   dr96:pcolorrows96;
   da,ca,cainv,xstop,ystop,xreset,xreset2,sx,sy,dx,dy:longint32;
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
sysfd_drawProc32:=9700;

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
if (ca=0) then exit;//28feb2026

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

      sysfd_drawProc32:=9797;
      goto yredo96_24;

      end;
   else begin

      case fd_focus.b2.bits of
      24:begin

         sysfd_drawProc32:=9724;
         goto yredo24_24;

         end;
      32:begin

         sysfd_drawProc32:=9725;
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

      sysfd_drawProc32:=9798;
      goto yredo96_32;

      end;
   else begin

      case fd_focus.b2.bits of
      24:begin

         sysfd_drawProc32:=9732;
         goto yredo32_24;

         end;
      32:begin

         sysfd_drawProc32:=9733;
         goto yredo32_32;

         end;
      end;//case

      end;
   end;//case

   end;
else exit;
end;//case


//render96_24 ------------------------------------------------------------------
yredo96_24:

xfd__inc32(fd_focus.b.aw);
dindex :=iauto( @dr96[dy][xreset96] );
sindex :=iauto( @sr96[sy][xreset96] );
dstop96:=iauto( @dr96[dy][xstop96] );

xredo96_24://bgr=v012, bgr=345, bgr=678, bgr=91011
pcolor96(dindex).v0 :=( (cainv*pcolor96(dindex).v0 )  + (ca*pcolor96(sindex).v0 ) ) shr 8;
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
   goto xredo96_24;

   end;

//row "begin" and "end" gaps
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

d24   :=@dr24[dy][dx];//04apr2026 - fixed
s24   :=@sr24[sy][dx];
d24.r :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
d24.g :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
d24.b :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

end;//dx

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo96_24;

   end;

//done
xfd__inc64;
exit;


//render96_32 ------------------------------------------------------------------
yredo96_32:

xfd__inc32(fd_focus.b.aw);
dindex :=iauto( @dr96[dy][xreset96] );
sindex :=iauto( @sr96[sy][xreset96] );
dstop96:=iauto( @dr96[dy][xstop96] );

xredo96_32://bgra=v0123, bgra=4567, bgra=891011

if (pcolor96(sindex).v3>=1) then
   begin

   da                  :=( pcolor96(sindex).v3 * ca ) shr 8;

   pcolor96(dindex).v0 :=( ((255-da)*pcolor96(dindex).v0 )  + (da*pcolor96(sindex).v0 ) ) shr 8;
   pcolor96(dindex).v1 :=( ((255-da)*pcolor96(dindex).v1 )  + (da*pcolor96(sindex).v1 ) ) shr 8;
   pcolor96(dindex).v2 :=( ((255-da)*pcolor96(dindex).v2 )  + (da*pcolor96(sindex).v2 ) ) shr 8;

   end;

if (pcolor96(sindex).v7>=1) then
   begin

   da                  :=( pcolor96(sindex).v7 * ca ) shr 8;

   pcolor96(dindex).v4 :=( ((255-da)*pcolor96(dindex).v4 )  + (da*pcolor96(sindex).v4 ) ) shr 8;
   pcolor96(dindex).v5 :=( ((255-da)*pcolor96(dindex).v5 )  + (da*pcolor96(sindex).v5 ) ) shr 8;
   pcolor96(dindex).v6 :=( ((255-da)*pcolor96(dindex).v6 )  + (da*pcolor96(sindex).v6 ) ) shr 8;

   end;

if (pcolor96(sindex).v11>=1) then
   begin

   da                  :=( pcolor96(sindex).v11 * ca ) shr 8;

   pcolor96(dindex).v8 :=( ((255-da)*pcolor96(dindex).v8 )  + (da*pcolor96(sindex).v8 ) ) shr 8;
   pcolor96(dindex).v9 :=( ((255-da)*pcolor96(dindex).v9 )  + (da*pcolor96(sindex).v9 ) ) shr 8;
   pcolor96(dindex).v10:=( ((255-da)*pcolor96(dindex).v10)  + (da*pcolor96(sindex).v10) ) shr 8;

   end;
   
//inc x
if (dindex<>dstop96) then
   begin

   inc( dindex ,sizeof(tcolor96) );
   inc( sindex ,sizeof(tcolor96) );
   goto xredo96_32;

   end;

//row "begin" and "end" gaps
for dx:=lx1 to lx2 do
begin

s32   :=@sr32[sy][dx];

if (s32.a>=1) then
   begin

   d32   :=@dr32[dy][dx];

   da    :=(s32.a*ca) shr 8;

   d32.r :=( ((255-da)*d32.r) + (da*s32.r) ) shr 8;
   d32.g :=( ((255-da)*d32.g) + (da*s32.g) ) shr 8;
   d32.b :=( ((255-da)*d32.b) + (da*s32.b) ) shr 8;

   end;

end;//dx

for dx:=rx1 to rx2 do
begin

s32   :=@sr32[sy][dx];

if (s32.a>=1) then
   begin

   d32   :=@dr32[dy][dx];

   da    :=(s32.a*ca) shr 8;

   d32.r :=( ((255-da)*d32.r) + (da*s32.r) ) shr 8;
   d32.g :=( ((255-da)*d32.g) + (da*s32.g) ) shr 8;
   d32.b :=( ((255-da)*d32.b) + (da*s32.b) ) shr 8;


   end;

end;//dx

//inc y
if (dy<>ystop) then
   begin

   inc(dy,1);
   inc(sy,1);
   goto yredo96_32;

   end;

//done
xfd__inc64;
exit;


//render32_32 ------------------------------------------------------------------
yredo32_32:

xfd__inc32(fd_focus.b.aw);
dindex :=iauto( @dr32[dy][xreset]  );
sindex :=iauto( @sr32[sy][xreset2] );
dstop96:=iauto( @dr32[dy][xstop]   );

xredo32_32:

//render pixel
if (pcolor32(sindex).a>=1) then
   begin

   da                :=( pcolor32(sindex).a * ca ) shr 8;

   pcolor32(dindex).r:=( ((255-da)*pcolor32(dindex).r) + (da*pcolor32(sindex).r) ) shr 8;
   pcolor32(dindex).g:=( ((255-da)*pcolor32(dindex).g) + (da*pcolor32(sindex).g) ) shr 8;
   pcolor32(dindex).b:=( ((255-da)*pcolor32(dindex).b) + (da*pcolor32(sindex).b) ) shr 8;

   end;

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


//render32_24 ------------------------------------------------------------------
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


//render24_24 ------------------------------------------------------------------
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
if (pcolor32(sindex).a>=1) then
   begin

   da                :=( pcolor32(sindex).a * ca ) shr 8;

   pcolor24(dindex).r:=( ((255-da)*pcolor24(dindex).r) + (da*pcolor32(sindex).r) ) shr 8;
   pcolor24(dindex).g:=( ((255-da)*pcolor24(dindex).g) + (da*pcolor32(sindex).g) ) shr 8;
   pcolor24(dindex).b:=( ((255-da)*pcolor24(dindex).b) + (da*pcolor32(sindex).b) ) shr 8;

   end;
   
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

procedure xfd__drawRGBA9800_flip_mirror_cliprange;//15mar2026
label
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24;
var
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   s24,d24:pcolor24;
   s32,d32:pcolor32;
   xshift,yshift,xstop,ystop,xreset,xreset2,sx,sy,dx,dy:longint32;
   dx1,dx2,dy1,dy2:longint;
   sx1,sx2,sy1,sy2:longint;
   yok:boolean;
begin

//defaults
sysfd_drawProc32:=9800;

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

      sysfd_drawProc32:=9824;
      goto yredo24_24;

      end;
   32:begin

      sysfd_drawProc32:=9825;
      goto yredo24_32;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      sysfd_drawProc32:=9832;
      goto yredo32_24;

      end;
   32:begin

      sysfd_drawProc32:=9833;
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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then
   begin

   dr24[dy][dx]:=sr24[sy][sx];

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
   d24.r :=( ((255-s32.a)*d24.r) + (s32.a*s32.r) ) shr 8;
   d24.g :=( ((255-s32.a)*d24.g) + (s32.a*s32.g) ) shr 8;
   d24.b :=( ((255-s32.a)*d24.b) + (s32.a*s32.b) ) shr 8;

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
   d32.r :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
   d32.g :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
   d32.b :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

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

   tint4( dr32[dy][dx] ).bgr24:=sr24[sy][sx];

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

procedure xfd__drawRGBA9900_power255_flip_mirror_cliprange;//19mar2026, 15mar2026
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
   da,ca,cainv:longint;
   yok:boolean;
   d24,s24:pcolor24;
   d32,s32:pcolor32;
begin

//defaults
sysfd_drawProc32:=900;

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
if (ca=0) then exit;

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

      sysfd_drawProc32:=924;
      goto yredo24_24;

      end;
   32:begin

      sysfd_drawProc32:=925;
      goto yredo24_32;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      sysfd_drawProc32:=932;
      goto yredo32_24;

      end;
   32:begin

      sysfd_drawProc32:=933;
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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) then
   begin

   s24   :=@sr24[sy][sx];
   d24   :=@dr24[dy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
   d24.g :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
   d24.b :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (sr32[sy][sx].a>=1) then
   begin

   s32   :=@sr32[sy][sx];
   d24   :=@dr24[dy][dx];

   da    :=(s32.a*ca) shr 8;

   d24.r :=( ((255-da)*d24.r) + (da*s32.r) ) shr 8;
   d24.g :=( ((255-da)*d24.g) + (da*s32.g) ) shr 8;
   d24.b :=( ((255-da)*d24.b) + (da*s32.b) ) shr 8;

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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (sr32[sy][sx].a>=1) then
   begin

   s32   :=@sr32[sy][sx];
   d32   :=@dr32[dy][dx];

   da    :=(s32.a*ca) shr 8;

   d32.r :=( ((255-da)*d32.r) + (da*s32.r) ) shr 8;
   d32.g :=( ((255-da)*d32.g) + (da*s32.g) ) shr 8;
   d32.b :=( ((255-da)*d32.b) + (da*s32.b) ) shr 8;

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
   d32.r :=( (cainv*d32.r) + (ca*s24.r) ) shr 8;
   d32.g :=( (cainv*d32.g) + (ca*s24.g) ) shr 8;
   d32.b :=( (cainv*d32.b) + (ca*s24.b) ) shr 8;

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

procedure xfd__drawRGBA10000_power255_flip_mirror_cliprange_layer;//19mar2026, 15mar2026
label
   yredo24_24,xredo24_24,yredo32_32,xredo32_32,
   yredo24_32,xredo24_32,yredo32_24,xredo32_24;
var
   lr8 :pcolorrows8;//20feb2026
   sr24:pcolorrows24;
   dr24:pcolorrows24;
   sr32:pcolorrows32;
   dr32:pcolorrows32;
   xshift,yshift,xstop,ystop,xreset,xreset2,sx,sy,dx,dy:longint32;
   dx1,dx2,dy1,dy2:longint;
   sx1,sx2,sy1,sy2:longint;
   da,ca,cainv:longint;
   yok:boolean;
   d24,s24:pcolor24;
   d32,s32:pcolor32;
   lv8:longint;

begin

//defaults
sysfd_drawProc32:=1000;

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
if (ca=0)  then exit;

lv8         :=fd_focus.lv8;
lr8         :=pcolorrows8( fd_focus.lr8 );

if (lv8<0) then exit;

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

      sysfd_drawProc32:=924;
      goto yredo24_24;

      end;
   32:begin

      sysfd_drawProc32:=925;
      goto yredo24_32;

      end;
   end;//case

   end;

32:begin

   dr32   :=pcolorrows32(fd_focus.b.rows);

   case fd_focus.b2.bits of
   24:begin

      sysfd_drawProc32:=932;
      goto yredo32_24;

      end;
   32:begin

      sysfd_drawProc32:=933;
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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (lr8[dy][dx]=lv8) then
   begin

   s24   :=@sr24[sy][sx];
   d24   :=@dr24[dy][dx];
   d24.r :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;//"shr 8" is 104% faster than "div 256"
   d24.g :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
   d24.b :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (lr8[dy][dx]=lv8) and (sr32[sy][sx].a>=1) then
   begin

   s32   :=@sr32[sy][sx];
   d24   :=@dr24[dy][dx];

   da    :=(s32.a*ca) shr 8;

   d24.r :=( ((255-da)*d24.r) + (da*s32.r) ) shr 8;
   d24.g :=( ((255-da)*d24.g) + (da*s32.g) ) shr 8;
   d24.b :=( ((255-da)*d24.b) + (da*s32.b) ) shr 8;

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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (lr8[dy][dx]=lv8) and (sr32[sy][sx].a>=1) then
   begin

   s32   :=@sr32[sy][sx];
   d32   :=@dr32[dy][dx];

   da    :=(s32.a*ca) shr 8;

   d32.r :=( ((255-da)*d32.r) + (da*s32.r) ) shr 8;
   d32.g :=( ((255-da)*d32.g) + (da*s32.g) ) shr 8;
   d32.b :=( ((255-da)*d32.b) + (da*s32.b) ) shr 8;

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
if yok and (dx>=dx1) and (dx<=dx2) and (sx>=sx1) and (sx<=sx2) and (lr8[dy][dx]=lv8) then
   begin

   s24   :=@sr24[sy][sx];
   d32   :=@dr32[dy][dx];
   d32.r :=( (cainv*d32.r) + (ca*s24.r) ) shr 8;
   d32.g :=( (cainv*d32.g) + (ca*s24.g) ) shr 8;
   d32.b :=( (cainv*d32.b) + (ca*s24.b) ) shr 8;

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

procedure xfd__drawRGBA15000_flip_mirror_cliprange_layer_stretch;//04apr2026
label
   render ,lrender ,skipend;

var
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support

   lr8 :pcolorrows8;//20feb2026
   srs24,drs24:pcolorrows24;
   srs32,drs32:pcolorrows32;
   sr24,dr24:pcolorrow24;
   sr32,dr32:pcolorrow32;

   dx1,dx2,dy1,dy2,lv8,sd,ddw,ddh,sx,sy,sw,sh,dx,dy:longint32;

   d24,s24:pcolor24;
   d32,s32:pcolor32;
   c32:tcolor32;
   c24:tcolor24;

   dclip,da,sa:twinrect;

   xmirror,xflip:boolean;

begin


//defaults ---------------------------------------------------------------------

sysfd_drawProc32      :=15000;
_mx                   :=nil;
_my                   :=nil;

//init -------------------------------------------------------------------------

//target area
dclip.left            :=fd_focus.b.cx1;//target clip
dclip.right           :=fd_focus.b.cx2;
dclip.top             :=fd_focus.b.cy1;
dclip.bottom          :=fd_focus.b.cy2;

da.left               :=fd_focus.b.ax1;//target area
da.right              :=fd_focus.b.ax2;
da.top                :=fd_focus.b.ay1;
da.bottom             :=fd_focus.b.ay2;

ddw                   :=da.right  - da.left + 1;
ddh                   :=da.bottom - da.top  + 1;

//.optimise actual x-pixels scanned -> dx1..dx2
dx1                   :=largest32 ( largest32 (da.left  ,dclip.left ) ,0    );
dx2                   :=smallest32( smallest32(da.right ,dclip.right) ,fd_focus.b.w-1 );

if (dx2<dx1) then exit;

//.optimise actual y-pixels scanned -> dy1...dy2
dy1                   :=largest32 ( largest32 (da.top    ,dclip.top   ) ,0    );
dy2                   :=smallest32( smallest32(da.bottom ,dclip.bottom) ,fd_focus.b.h-1 );

if (dy2<dy1) then exit;

//source area
sa.left               :=frcrange32( fd_focus.b2.ax1 ,fd_focus.b2.cx1 ,fd_focus.b2.cx2 );//source area
sa.right              :=frcrange32( fd_focus.b2.ax2 ,sa.left         ,fd_focus.b2.cx2 );
sa.top                :=frcrange32( fd_focus.b2.ay1 ,fd_focus.b2.cy1 ,fd_focus.b2.cy2 );
sa.bottom             :=frcrange32( fd_focus.b2.ay2 ,sa.top          ,fd_focus.b2.cy2 );

sw                    :=fd_focus.b2.w;
sh                    :=fd_focus.b2.h;

//layer
lv8                   :=fd_focus.lv8;

//source buffer
case fd_focus.b2.bits of
24:srs24              :=pcolorrows24(fd_focus.b2.rows);
32:srs32              :=pcolorrows32(fd_focus.b2.rows);
else                   exit;
end;//case

//target buffer
case fd_focus.b.bits of
24:drs24              :=pcolorrows24(fd_focus.b.rows);
32:drs32              :=pcolorrows32(fd_focus.b.rows);
else                   exit;
end;//case

//source and target bit pair code
sd                    :=mis__sdPair( fd_focus.b2.bits ,fd_focus.b.bits );

//mirror + flip
xmirror               :=fd_focus.mirror;
xflip                 :=fd_focus.flip;


//map X and Y scales -----------------------------------------------------------

//.mx
_mx                   :=rescache__newMapped( 1 ,ddw ,sa.left ,sa.right ,(sa.right-sa.left+1) );
mx                    :=_mx.core;

//.my
_my                   :=rescache__newMapped( 1 ,ddh ,sa.top ,sa.bottom ,(sa.bottom-sa.top+1) );
my                    :=_my.core;


//decide - normal or layer render ----------------------------------------------

if (lv8>=0) then
   begin

   lr8                :=pcolorrows8( fd_focus.lr8 );

   goto lrender;

   end;


//render pixels ----------------------------------------------------------------
render:
sysfd_drawProc32      :=15001;

//dy
for dy:=dy1 to dy2 do
begin

//target row
if      (fd_focus.b.bits=32)  then dr32:=@drs32[dy]^
else if (fd_focus.b.bits=24)  then dr24:=@drs24[dy]^;

//sy
if xflip then sy:=my[ pred(ddh) - dy + da.top ] else sy:=my[ dy - da.top ];//zero base

//range
if (sy>=0) and (sy<sh) then
   begin

   //track
   xfd__inc32( dx2 - dx1 + 1 );

   //source row
   if      (fd_focus.b2.bits=32) then sr32:=@srs32[sy]^
   else if (fd_focus.b2.bits=24) then sr24:=@srs24[sy]^;

   //dx - note: a simple "if chain" is 1.5x faster than using a "case" statement - 03apr2026

   //32 -> 32 ------------------------------------------------------------------
   if (sd=sd32_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            d32.r     :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
            d32.g     :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
            d32.b     :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            d32.r     :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
            d32.g     :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
            d32.b     :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //32 -> 24 ---------------------------------------------------------------
   else if (sd=sd32_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            d24.r     :=( ((255-s32.a)*d24.r) + (s32.a*s32.r) ) shr 8;
            d24.g     :=( ((255-s32.a)*d24.g) + (s32.a*s32.g) ) shr 8;
            d24.b     :=( ((255-s32.a)*d24.b) + (s32.a*s32.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            d24.r     :=( ((255-s32.a)*d24.r) + (s32.a*s32.r) ) shr 8;
            d24.g     :=( ((255-s32.a)*d24.g) + (s32.a*s32.g) ) shr 8;
            d24.b     :=( ((255-s32.a)*d24.b) + (s32.a*s32.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 32 ---------------------------------------------------------------
   else if (sd=sd24_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            tint4( dr32[dx] ).bgr24    :=sr24[sx];

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            tint4( dr32[dx] ).bgr24    :=sr24[sx];

            end;

         end;//dx

         end;//if

      end

   //24 -> 24 ---------------------------------------------------------------
   else if (sd=sd24_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            dr24[dx]  :=sr24[sx];

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            dr24[dx]  :=sr24[sx];

            end;

         end;//dx

         end;//if

      end;

   end;//sy

end;//dy

//done
goto skipend;


//lrender ----------------------------------------------------------------------
lrender:
sysfd_drawProc32      :=15002;

//dy
for dy:=dy1 to dy2 do
begin

//target row
if      (fd_focus.b.bits=32)  then dr32:=@drs32[dy]^
else if (fd_focus.b.bits=24)  then dr24:=@drs24[dy]^;

//sy
if xflip then sy:=my[ pred(ddh) - dy + da.top ] else sy:=my[ dy - da.top ];//zero base

//range
if (sy>=0) and (sy<sh) then
   begin

   //track
   xfd__inc32( dx2 - dx1 + 1 );

   //source row
   if      (fd_focus.b2.bits=32) then sr32:=@srs32[sy]^
   else if (fd_focus.b2.bits=24) then sr24:=@srs24[sy]^;

   //dx - note: a simple "if chain" is 1.5x faster than using a "case" statement - 03apr2026

   //32 -> 32 ------------------------------------------------------------------
   if (sd=sd32_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            d32.r     :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
            d32.g     :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
            d32.b     :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            d32.r     :=( ((255-s32.a)*d32.r) + (s32.a*s32.r) ) shr 8;
            d32.g     :=( ((255-s32.a)*d32.g) + (s32.a*s32.g) ) shr 8;
            d32.b     :=( ((255-s32.a)*d32.b) + (s32.a*s32.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //32 -> 24 ---------------------------------------------------------------
   else if (sd=sd32_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            d24.r     :=( ((255-s32.a)*d24.r) + (s32.a*s32.r) ) shr 8;
            d24.g     :=( ((255-s32.a)*d24.g) + (s32.a*s32.g) ) shr 8;
            d24.b     :=( ((255-s32.a)*d24.b) + (s32.a*s32.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            d24.r     :=( ((255-s32.a)*d24.r) + (s32.a*s32.r) ) shr 8;
            d24.g     :=( ((255-s32.a)*d24.g) + (s32.a*s32.g) ) shr 8;
            d24.b     :=( ((255-s32.a)*d24.b) + (s32.a*s32.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 32 ---------------------------------------------------------------
   else if (sd=sd24_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            tint4( dr32[dx] ).bgr24    :=sr24[sx];

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            tint4( dr32[dx] ).bgr24    :=sr24[sx];

            end;

         end;//dx

         end;//if

      end

   //24 -> 24 ---------------------------------------------------------------
   else if (sd=sd24_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            dr24[dx]  :=sr24[sx];

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            dr24[dx]  :=sr24[sx];

            end;

         end;//dx

         end;//if

      end;

   end;//sy

end;//dy

//done
goto skipend;


//finish -----------------------------------------------------------------------

skipend:

//track
xfd__inc64;

//free
if (_mx<>nil) then rescache__delMapped( @_mx );
if (_my<>nil) then rescache__delMapped( @_my );

end;

procedure xfd__drawRGBA15100_power255_flip_mirror_cliprange_layer_stretch;//04apr2026
label
   render ,lrender ,skipend;

var
   mx,my:pdllongint;
   _mx,_my:tdynamicinteger;//mapper support

   lr8 :pcolorrows8;//20feb2026
   srs24,drs24:pcolorrows24;
   srs32,drs32:pcolorrows32;
   sr24,dr24:pcolorrow24;
   sr32,dr32:pcolorrow32;

   dx1,dx2,dy1,dy2,lv8,va,ca,cainv,sd,ddw,ddh,sx,sy,sw,sh,dx,dy:longint32;

   d24,s24:pcolor24;
   d32,s32:pcolor32;
   c32:tcolor32;
   c24:tcolor24;

   dclip,da,sa:twinrect;

   xmirror,xflip:boolean;

begin


//defaults ---------------------------------------------------------------------

sysfd_drawProc32      :=15100;
_mx                   :=nil;
_my                   :=nil;

//init -------------------------------------------------------------------------

//target area
dclip.left            :=fd_focus.b.cx1;//target clip
dclip.right           :=fd_focus.b.cx2;
dclip.top             :=fd_focus.b.cy1;
dclip.bottom          :=fd_focus.b.cy2;

da.left               :=fd_focus.b.ax1;//target area
da.right              :=fd_focus.b.ax2;
da.top                :=fd_focus.b.ay1;
da.bottom             :=fd_focus.b.ay2;

ddw                   :=da.right  - da.left + 1;
ddh                   :=da.bottom - da.top  + 1;

//.optimise actual x-pixels scanned -> dx1..dx2
dx1                   :=largest32 ( largest32 (da.left  ,dclip.left ) ,0    );
dx2                   :=smallest32( smallest32(da.right ,dclip.right) ,fd_focus.b.w-1 );

if (dx2<dx1) then exit;

//.optimise actual y-pixels scanned -> dy1...dy2
dy1                   :=largest32 ( largest32 (da.top    ,dclip.top   ) ,0    );
dy2                   :=smallest32( smallest32(da.bottom ,dclip.bottom) ,fd_focus.b.h-1 );

if (dy2<dy1) then exit;

//source area
sa.left               :=frcrange32( fd_focus.b2.ax1 ,fd_focus.b2.cx1 ,fd_focus.b2.cx2 );//source area
sa.right              :=frcrange32( fd_focus.b2.ax2 ,sa.left         ,fd_focus.b2.cx2 );
sa.top                :=frcrange32( fd_focus.b2.ay1 ,fd_focus.b2.cy1 ,fd_focus.b2.cy2 );
sa.bottom             :=frcrange32( fd_focus.b2.ay2 ,sa.top          ,fd_focus.b2.cy2 );

sw                    :=fd_focus.b2.w;
sh                    :=fd_focus.b2.h;

//layer
lv8                   :=fd_focus.lv8;

//source buffer
case fd_focus.b2.bits of
24:srs24              :=pcolorrows24(fd_focus.b2.rows);
32:srs32              :=pcolorrows32(fd_focus.b2.rows);
else                   exit;
end;//case

//target buffer
case fd_focus.b.bits of
24:drs24              :=pcolorrows24(fd_focus.b.rows);
32:drs32              :=pcolorrows32(fd_focus.b.rows);
else                   exit;
end;//case

//source and target bit pair code
sd                    :=mis__sdPair( fd_focus.b2.bits ,fd_focus.b.bits );

//power
ca                    :=fd_focus.power255;
cainv                 :=255 - ca;

//mirror + flip
xmirror               :=fd_focus.mirror;
xflip                 :=fd_focus.flip;


//map X and Y scales -----------------------------------------------------------

//.mx
_mx                   :=rescache__newMapped( 1 ,ddw ,sa.left ,sa.right ,(sa.right-sa.left+1) );
mx                    :=_mx.core;

//.my
_my                   :=rescache__newMapped( 1 ,ddh ,sa.top ,sa.bottom ,(sa.bottom-sa.top+1) );
my                    :=_my.core;


//decide - normal or layer render ----------------------------------------------
if (lv8>=0) then
   begin

   lr8                :=pcolorrows8( fd_focus.lr8 );

   goto lrender;

   end;


//render pixels ----------------------------------------------------------------
render:

//dy
for dy:=dy1 to dy2 do
begin

//target row
if      (fd_focus.b.bits=32)  then dr32:=@drs32[dy]^
else if (fd_focus.b.bits=24)  then dr24:=@drs24[dy]^;

//sy
if xflip then sy:=my[ pred(ddh) - dy + da.top ] else sy:=my[ dy - da.top ];//zero base

//range
if (sy>=0) and (sy<sh) then
   begin

   //track
   xfd__inc32( dx2 - dx1 + 1 );

   //source row
   if      (fd_focus.b2.bits=32) then sr32:=@srs32[sy]^
   else if (fd_focus.b2.bits=24) then sr24:=@srs24[sy]^;

   //dx - note: a simple "if chain" is 1.5x faster than using a "case" statement - 03apr2026

   //32 -> 32 ------------------------------------------------------------------
   if (sd=sd32_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            va        :=( ca * s32.a ) shr 8;

            d32.r     :=( ((255-va)*d32.r) + (va*s32.r) ) shr 8;
            d32.g     :=( ((255-va)*d32.g) + (va*s32.g) ) shr 8;
            d32.b     :=( ((255-va)*d32.b) + (va*s32.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            va        :=( ca * s32.a ) shr 8;

            d32.r     :=( ((255-va)*d32.r) + (va*s32.r) ) shr 8;
            d32.g     :=( ((255-va)*d32.g) + (va*s32.g) ) shr 8;
            d32.b     :=( ((255-va)*d32.b) + (va*s32.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //32 -> 24 ---------------------------------------------------------------
   else if (sd=sd32_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            va        :=( ca * s32.a ) shr 8;

            d24.r     :=( ((255-va)*d24.r) + (va*s32.r) ) shr 8;
            d24.g     :=( ((255-va)*d24.g) + (va*s32.g) ) shr 8;
            d24.b     :=( ((255-va)*d24.b) + (va*s32.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            va        :=( ca * s32.a ) shr 8;

            d24.r     :=( ((255-va)*d24.r) + (va*s32.r) ) shr 8;
            d24.g     :=( ((255-va)*d24.g) + (va*s32.g) ) shr 8;
            d24.b     :=( ((255-va)*d24.b) + (va*s32.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 32 ---------------------------------------------------------------
   else if (sd=sd24_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s24       :=@sr24[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (cainv*d32.r) + (ca*s24.r) ) shr 8;
            d32.g     :=( (cainv*d32.g) + (ca*s24.g) ) shr 8;
            d32.b     :=( (cainv*d32.b) + (ca*s24.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s24       :=@sr24[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (cainv*d32.r) + (ca*s24.r) ) shr 8;
            d32.g     :=( (cainv*d32.g) + (ca*s24.g) ) shr 8;
            d32.b     :=( (cainv*d32.b) + (ca*s24.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 24 ---------------------------------------------------------------
   else if (sd=sd24_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s24       :=@sr24[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
            d24.g     :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
            d24.b     :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) then
            begin

            s24       :=@sr24[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
            d24.g     :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
            d24.b     :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end;

   end;//sy

end;//dy

//done
goto skipend;


//lrender ----------------------------------------------------------------------
lrender:

//dy
for dy:=dy1 to dy2 do
begin

//target row
if      (fd_focus.b.bits=32)  then dr32:=@drs32[dy]^
else if (fd_focus.b.bits=24)  then dr24:=@drs24[dy]^;

//sy
if xflip then sy:=my[ pred(ddh) - dy + da.top ] else sy:=my[ dy - da.top ];//zero base

//range
if (sy>=0) and (sy<sh) then
   begin

   //track
   xfd__inc32( dx2 - dx1 + 1 );

   //source row
   if      (fd_focus.b2.bits=32) then sr32:=@srs32[sy]^
   else if (fd_focus.b2.bits=24) then sr24:=@srs24[sy]^;

   //dx - note: a simple "if chain" is 1.5x faster than using a "case" statement - 03apr2026

   //32 -> 32 ------------------------------------------------------------------
   if (sd=sd32_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            va        :=( ca * s32.a ) shr 8;

            d32.r     :=( ((255-va)*d32.r) + (va*s32.r) ) shr 8;
            d32.g     :=( ((255-va)*d32.g) + (va*s32.g) ) shr 8;
            d32.b     :=( ((255-va)*d32.b) + (va*s32.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d32       :=@dr32[dx];

            va        :=( ca * s32.a ) shr 8;

            d32.r     :=( ((255-va)*d32.r) + (va*s32.r) ) shr 8;
            d32.g     :=( ((255-va)*d32.g) + (va*s32.g) ) shr 8;
            d32.b     :=( ((255-va)*d32.b) + (va*s32.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //32 -> 24 ---------------------------------------------------------------
   else if (sd=sd32_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            va        :=( ca * s32.a ) shr 8;

            d24.r     :=( ((255-va)*d24.r) + (va*s32.r) ) shr 8;
            d24.g     :=( ((255-va)*d24.g) + (va*s32.g) ) shr 8;
            d24.b     :=( ((255-va)*d24.b) + (va*s32.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) and (sr32[sx].a>=1) then
            begin

            s32       :=@sr32[sx];
            d24       :=@dr24[dx];

            va        :=( ca * s32.a ) shr 8;

            d24.r     :=( ((255-va)*d24.r) + (va*s32.r) ) shr 8;
            d24.g     :=( ((255-va)*d24.g) + (va*s32.g) ) shr 8;
            d24.b     :=( ((255-va)*d24.b) + (va*s32.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 32 ---------------------------------------------------------------
   else if (sd=sd24_32) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s24       :=@sr24[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (cainv*d32.r) + (ca*s24.r) ) shr 8;
            d32.g     :=( (cainv*d32.g) + (ca*s24.g) ) shr 8;
            d32.b     :=( (cainv*d32.b) + (ca*s24.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s24       :=@sr24[sx];
            d32       :=@dr32[dx];

            d32.r     :=( (cainv*d32.r) + (ca*s24.r) ) shr 8;
            d32.g     :=( (cainv*d32.g) + (ca*s24.g) ) shr 8;
            d32.b     :=( (cainv*d32.b) + (ca*s24.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end

   //24 -> 24 ---------------------------------------------------------------
   else if (sd=sd24_24) then
      begin

      if xmirror then
         begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ pred(ddw) - dx + da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s24       :=@sr24[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
            d24.g     :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
            d24.b     :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

            end;

         end;//dx

         end

      else begin

         for dx:=dx1 to dx2 do
         begin

         sx        :=mx[ dx-da.left ];

         if (sx>=0) and (sx<sw) and (lr8[dy][dx]=lv8) then
            begin

            s24       :=@sr24[sx];
            d24       :=@dr24[dx];

            d24.r     :=( (cainv*d24.r) + (ca*s24.r) ) shr 8;
            d24.g     :=( (cainv*d24.g) + (ca*s24.g) ) shr 8;
            d24.b     :=( (cainv*d24.b) + (ca*s24.b) ) shr 8;

            end;

         end;//dx

         end;//if

      end;

   end;//sy

end;//dy

//done
goto skipend;


//finish -----------------------------------------------------------------------

skipend:

//track
xfd__inc64;

//free
if (_mx<>nil) then rescache__delMapped( @_mx );
if (_my<>nil) then rescache__delMapped( @_my );

end;


//fd__sparkle procs ------------------------------------------------------------

procedure fd__sparkleInit;
var
   p,v:longint;
begin

low__cls(@fd_sparkle,sizeof(fd_sparkle));

v           :=(2*fd_sparkleLimit) + 1;

for p:=0 to pred(fd_sparkleListSize) do fd_sparkle.once[p]:=random( v );

end;

procedure fd__sparkleNewLevel(const xnewlevel:longint);
var
   v,p:longint32;
begin

if low__setint( fd_sparkle.level ,frcrange32( xnewlevel ,0 ,fd_sparkleLimit ) ) then
   begin

   roll32( fd_sparkle.id );

   case (fd_sparkle.level<=0) of
   true:for p:=0 to pred(fd_sparkleListSize) do fd_sparkle.val[p]:=0;
   else for p:=0 to pred(fd_sparkleListSize) do fd_sparkle.val[p]:=(fd_sparkle.once[p]*fd_sparkle.level) div fd_sparkleLimit;
   end;//case

   end;

end;

procedure fd__sparkleReset;
begin

fd_sparkle.pos        :=0;//28mar2026

end;

function fd__sparkleUniqueStart:longint32;
begin

result                :=random(fd_sparkleListSize);

end;


//## tbasicrle6 ################################################################
constructor tbasicrle6.create;
begin

//self
if classnameis('tbasicrle6') then track__inc(satRLE6,1);
inherited create;

//controls
ibits                 :=8;
iwidth                :=0;
iheight               :=0;
iheight1              :=0;
icore                 :=rescache__newStr8;
icore.floatsize       :=100;

//defaults
clear;

end;

destructor tbasicrle6.destroy;
begin
try

//controls
rescache__delStr8(@icore);

//destroy
inherited destroy;
if classnameis('tbasicrle6') then track__inc(satRLE6,-1);

except;end;
end;

procedure tbasicrle6.clear;
begin

iheadLen              :=20;
iwidth                :=0;
iheight               :=0;
iheight1              :=0;

icore.setlen( 0 );
icore.aadd( [uuR,uuL,uuE,nn6] );
icore.addint4( iheadLen );//header length => start of data (header=0..19, data=20+)
icore.addint4( iwidth  );
icore.addint4( iheight );
icore.addint4( iheight1 );

end;

function tbasicrle6.cancopytoimage:boolean;
begin

result:=(iwidth>=1) and (iheight>=1);

end;

function tbasicrle6.copytoimage(d:tobject;const dcol1,dcol2,dcol3,dcol4:longint):boolean;
begin

result:=copytoimage2(d,dcol1,dcol2,dcol3,dcol4,0);

end;

function tbasicrle6.copytoimage2(d:tobject;const dcol1,dcol2,dcol3,dcol4,dfeather4:longint):boolean;
label
   yredo,xredo;

var
   dfeather,ca,cr,cg,cb,vcount,vstop,vpos,vlum,dstopY,dresetX,dstopX,dbits,dw,dh,dx,dy,vw,vh:longint;
   vlist:pdlbyte;
   s24 :pcolor24;
   s32 :pcolor32;
   dr8 :pcolorrows8;
   dr24:pcolorrows24;
   dr32:pcolorrows32;
   c1  :tcolor32;
   c2  :tcolor32;
   c3  :tcolor32;
   c4  :tcolor32;

   procedure pa;
   begin

   case ca of

   //transparent
   0:;

   //channel 3
   rle6_channel_root3..255:begin

      case (ca>=rle6_channel_istart3) of
      true:ca         :=( ca-rle6_channel_istart3 + 1 ) * rle6_colorDivider;
      else ca         :=ca * dfeather;//realtime feather
      end;//case

      cr              :=c4.r;
      cg              :=c4.g;
      cb              :=c4.b;

      end;

   //channel 2
   rle6_channel_root2..(rle6_channel_root3-1):begin

      case (ca>=rle6_channel_istart2) of
      true:ca         :=( ca-rle6_channel_istart2 + 1 ) * rle6_colorDivider;
      else ca         :=ca * dfeather;//realtime feather
      end;//case

      cr              :=c3.r;
      cg              :=c3.g;
      cb              :=c3.b;

      end;

   //channel 1
   rle6_channel_root1..(rle6_channel_root2-1):begin

      case (ca>=rle6_channel_istart1) of
      true:ca         :=( ca-rle6_channel_istart1 + 1 ) * rle6_colorDivider;
      else ca         :=ca * dfeather;//realtime feather
      end;//case

      cr              :=c2.r;
      cg              :=c2.g;
      cb              :=c2.b;

      end;

   //channel 0
   rle6_channel_root0..(rle6_channel_root1-1):begin

      case (ca>=rle6_channel_istart0) of
      true:ca         :=( ca-rle6_channel_istart0 + 1 ) * rle6_colorDivider;
      else ca         :=ca * dfeather;//realtime feather
      end;//case

      cr              :=c1.r;
      cg              :=c1.g;
      cb              :=c1.b;

      end;

   end;//case

   end;

begin

//defaults
result      :=false;
dw          :=width;
dh          :=height;
dy          :=0;
dstopY      :=pred(dh);
dresetX     :=0;
dstopX      :=pred(dw);
c1          :=int__c32(dcol1);
c2          :=int__c32(dcol2);
c3          :=int__c32(dcol3);
c4          :=int__c32(dcol4);
dfeather    :=xfd__drawRLE6_featherPower( dfeather4 );

//.source buffer
vlist       :=icore.core;
vstop       :=icore.len32-1;
vcount      :=1;
vpos        :=iheadLen;

//check
if not cancopytoimage            then exit;
if not misok82432(d,dbits,vw,vh) then exit;

//size
if not missize(d,dw,dh)          then exit;

//cls
if not mis__cls(d ,0,0,0,0 )     then exit;

//scan
case dbits of
32:if not misrows32(d,dr32)      then exit;
24:if not misrows24(d,dr24)      then exit;
 8:if not misrows8 (d,dr8 )      then exit;
end;//case

//8/24/32 bit ------------------------------------------------------------------
yredo:

dx  :=dresetX;

xredo:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then exit;

   //get
   ca       :=vlist[vpos+0];
   vcount   :=vlist[vpos+1]+1;

   //calc
   pa;

   //inc
   inc(vpos,2);

   end;

//set
case dbits of

32:begin

   s32      :=@dr32[dy][dx];

   s32.r    :=cr;
   s32.g    :=cg;
   s32.b    :=cb;
   s32.a    :=ca;

   end;

24:begin

   s24      :=@dr24[dy][dx];

   s24.r    :=(cr*ca) shr 8;
   s24.g    :=(cg*ca) shr 8;
   s24.b    :=(cb*ca) shr 8;

   end;

8 :dr8[dy][dx]:=ca;

end;//case

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo;

   end;

//successful
result      :=true;

end;

function tbasicrle6.fromdata(s:pobject):boolean;
label
   skipend;

const
   xheadLen =20;

begin

//defaults
result      :=false;

//check
if not str__lock(s) then exit;

try

//init
if (str__len(s)      < xheadLen ) then goto skipend;
if (str__str0(s,0,4)<> 'RLE6'   ) then goto skipend;
if (str__int4(s,4)  <> xheadLen ) then goto skipend;
if (str__int4(s,8)   < 0        ) then goto skipend;//negative width
if (str__int4(s,12)  < 0        ) then goto skipend;//negative height

//get
icore.clear;

//.copy "s" to "icore"
if not str__add(@icore ,s) then
   begin

   //Important: object always expects a valid core header -> hence the "clear" proc which forces a valid core header
   clear;

   goto skipend;

   end;

//set
iwidth      :=str__int4(s,8);
iheight     :=str__int4(s,12);
iheight1    :=str__int4(s,16);

//successful
result      :=true;
skipend:

except;end;

//free
str__uaf(s);

end;

function tbasicrle6.fromarray(const s:array of byte):boolean;
label
   skipend;

const
   xheadLen =20;

begin

//defaults
result      :=false;

//check
if (low(s)<>0)                    then exit;

try

//init
if ((high(s)+1)       < xheadLen )  then goto skipend;
if (s[0]<>uuR) or (s[1]<>uuL) or (s[2]<>uuE) or (s[3]<>nn6) then exit;

if (int32__make( s[ 4],s[ 5],s[ 6],s[ 7]) <> xheadLen ) then goto skipend;
if (int32__make( s[ 8],s[ 9],s[10],s[11])  < 0        ) then goto skipend;//negative width
if (int32__make( s[12],s[13],s[14],s[15])  < 0        ) then goto skipend;//negative height

//get
icore.clear;

//.copy "s" to "icore"
if not str__aadd(@icore ,s) then
   begin

   //Important: object always expects a valid core header -> hence the "clear" proc which forces a valid core header
   clear;

   goto skipend;

   end;

//successful
result      :=true;
skipend:

except;end;
end;

//Note: create single channel (ch0) image from red-values only
procedure tbasicrle6.fast__makefromR(const s:tobject);
begin

fast__makefromR2(s,misarea(s),rle6_channel0,false,false);

end;

procedure tbasicrle6.fast__makefromR2(const s:tobject;sarea:twinrect;const dChannel03:longint;const xinvert,xscanForHeight1:boolean);
begin

case misb(s) of
32:xfast__makefromR32(s,sarea,dChannel03,xinvert,xscanForHeight1);
24:xfast__makefromR24(s,sarea,dChannel03,xinvert,xscanForHeight1);
 8:xfast__makefromR8 (s,sarea,dChannel03,xinvert,xscanForHeight1);
end;//case

end;

procedure tbasicrle6.xfast__makefromR32(const s:tobject;sarea:twinrect;const dChannel03:longint;const xinvert,xscanForHeight1:boolean);
var
   sr32:pcolorrows32;
   dbase,lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sFAST32(const sy,sx:longint):byte;//3x3 blur matrix
   var
      v:longint;
   begin

   //get
   result:=sr32[sy][sx].r;

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      v:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(v,sr32[sy][sx-1].r);

      //x+1 -> right
      if (sx<sarea.right)    then inc(v,sr32[sy][sx+1].r);

      //y-1 -> above
      if (sy>sarea.top)      then inc(v,sr32[sy-1][sx].r);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(v,sr32[sy+1][sx].r);

      //encode feather - "0" or "1..10"
      if      (v<rle6_featherPartShade    )     then result:=0//transparent
      else if (v>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
      else                                           result:=dbase + (v div rle6_featherPartShade);//1..10

      end
   else
      begin

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (result>=255)                     then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (result<rle6_minishadeval)        then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (result div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   function sFAST32INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      v:longint;
   begin

   //get
   result:=255-sr32[sy][sx].r;

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      v:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(v,255-sr32[sy][sx-1].r);

      //x+1 -> right
      if (sx<sarea.right)    then inc(v,255-sr32[sy][sx+1].r);

      //y-1 -> above
      if (sy>sarea.top)      then inc(v,255-sr32[sy-1][sx].r);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(v,255-sr32[sy+1][sx].r);

      //encode feather - "0" or "1..10"
      if      (v<rle6_featherPartShade    )     then result:=0//transparent
      else if (v>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
      else                                           result:=dbase + (v div rle6_featherPartShade);//1..10

      end
   else
      begin

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (result>=255)                     then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (result<rle6_minishadeval)        then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (result div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//channel
case dChannel03 of
rle6_channel0:dbase   :=rle6_channel_root0;
rle6_channel1:dbase   :=rle6_channel_root1;
rle6_channel2:dbase   :=rle6_channel_root2;
rle6_channel3:dbase   :=rle6_channel_root3;
else          exit;
end;//case

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows32(s,sr32)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST32INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST32(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;

procedure tbasicrle6.xfast__makefromR24(const s:tobject;sarea:twinrect;const dChannel03:longint;const xinvert,xscanForHeight1:boolean);
var
   sr24:pcolorrows24;
   dbase,lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sFAST24(const sy,sx:longint):byte;//3x3 blur matrix
   var
      v:longint;
   begin

   //get
   result:=sr24[sy][sx].r;

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      v:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(v,sr24[sy][sx-1].r);

      //x+1 -> right
      if (sx<sarea.right)    then inc(v,sr24[sy][sx+1].r);

      //y-1 -> above
      if (sy>sarea.top)      then inc(v,sr24[sy-1][sx].r);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(v,sr24[sy+1][sx].r);

      //encode feather - "0" or "1..10"
      if      (v<rle6_featherPartShade    )     then result:=0//transparent
      else if (v>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
      else                                           result:=dbase + (v div rle6_featherPartShade);//1..10

      end
   else
      begin

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (result>=255)                     then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (result<rle6_minishadeval)        then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (result div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   function sFAST24INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      v:longint;
   begin

   //get
   result:=255-sr24[sy][sx].r;

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      v:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(v,255-sr24[sy][sx-1].r);

      //x+1 -> right
      if (sx<sarea.right)    then inc(v,255-sr24[sy][sx+1].r);

      //y-1 -> above
      if (sy>sarea.top)      then inc(v,255-sr24[sy-1][sx].r);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(v,255-sr24[sy+1][sx].r);

      //encode feather - "0" or "1..10"
      if      (v<rle6_featherPartShade    )     then result:=0//transparent
      else if (v>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
      else                                           result:=dbase + (v div rle6_featherPartShade);//1..10

      end
   else
      begin

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (result>=255)                     then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (result<rle6_minishadeval)        then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (result div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//channel
case dChannel03 of
rle6_channel0:dbase   :=rle6_channel_root0;
rle6_channel1:dbase   :=rle6_channel_root1;
rle6_channel2:dbase   :=rle6_channel_root2;
rle6_channel3:dbase   :=rle6_channel_root3;
else          exit;
end;//case

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows24(s,sr24)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST24INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST24(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;

procedure tbasicrle6.xfast__makefromR8(const s:tobject;sarea:twinrect;const dChannel03:longint;const xinvert,xscanForHeight1:boolean);
var
   sr8:pcolorrows8;
   dbase,lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sFAST8(const sy,sx:longint):byte;//3x3 blur matrix
   var
      v:longint;
   begin

   //get
   result:=sr8[sy][sx];

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      v:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(v,sr8[sy][sx-1]);

      //x+1 -> right
      if (sx<sarea.right)    then inc(v,sr8[sy][sx+1]);

      //y-1 -> above
      if (sy>sarea.top)      then inc(v,sr8[sy-1][sx]);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(v,sr8[sy+1][sx]);

      //encode feather - "0" or "1..10"
      if      (v<rle6_featherPartShade    )     then result:=0//transparent
      else if (v>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
      else                                           result:=dbase + (v div rle6_featherPartShade);//1..10

      end
   else
      begin

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (result>=255)                     then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (result<rle6_minishadeval)        then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (result div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   function sFAST8INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      v:longint;
   begin

   //get
   result:=255-sr8[sy][sx];

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      v:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(v,255-sr8[sy][sx-1]);

      //x+1 -> right
      if (sx<sarea.right)    then inc(v,255-sr8[sy][sx+1]);

      //y-1 -> above
      if (sy>sarea.top)      then inc(v,255-sr8[sy-1][sx]);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(v,255-sr8[sy+1][sx]);

      //encode feather - "0" or "1..10"
      if      (v<rle6_featherPartShade    )     then result:=0//transparent
      else if (v>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
      else                                           result:=dbase + (v div rle6_featherPartShade);//1..10

      end
   else
      begin

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (result>=255)                     then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (result<rle6_minishadeval)        then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (result div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//channel
case dChannel03 of
rle6_channel0:dbase   :=rle6_channel_root0;
rle6_channel1:dbase   :=rle6_channel_root1;
rle6_channel2:dbase   :=rle6_channel_root2;
rle6_channel3:dbase   :=rle6_channel_root3;
else          exit;
end;//case

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows8(s,sr8)               then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST8INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST8(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;


procedure tbasicrle6.slow__makefromLRGB(const s:tobject);
begin

slow__makefromLRGB2(s,misarea(s),false,false);

end;

//Note: create 4 channel (ch0..ch3) image from luminosity=ch0, red=ch1, green=ch2
//      and blue=ch3 values, with highest value determining which channel is used
//      for each pixel
procedure tbasicrle6.slow__makefromLRGB2(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
begin

case misb(s) of
32:xslow__makefrom32(s,sarea,xinvert,xscanForHeight1);
24:xslow__makefrom24(s,sarea,xinvert,xscanForHeight1);
 8:xslow__makefrom8 (s,sarea,xinvert,xscanForHeight1);
end;//case

end;

procedure tbasicrle6.xslow__detectInfo(const r,g,b:byte;var droot,dv:byte);//06mar2026
begin

//luminosity = channel 0
if (r>=(g-2)) and (r<=(g+2)) and (b>=(g-2)) and (b<=(g+2)) then
   begin

   droot        :=rle6_channel_root0;
   dv           :=r;

   if (g>dv) then dv:=g;
   if (b>dv) then dv:=b;

   end

//shades of red = channel 1
else if (r>g) and (r>b) then
   begin

   droot        :=rle6_channel_root1;
   dv           :=r;

   end

//shades of green = channel 2
else if (g>r) and (g>b) then
   begin

   droot        :=rle6_channel_root2;
   dv           :=g;

   end

//shades of blue = channel 3
else if (b>r) and (b>g) then
   begin

   droot        :=rle6_channel_root3;
   dv           :=b;

   end

//luminosity = channel 0
else
   begin

   droot        :=rle6_channel_root0;
   dv           :=r;

   if (g>dv) then dv:=g;
   if (b>dv) then dv:=b;

   end;

end;

procedure tbasicrle6.xslow__makefrom32(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr32:pcolorrows32;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sSLOW32(const sy,sx:longint):byte;//3x3 blur matrix
   var
      va,r,g,b:longint;
      dbase,dv:byte;
   begin

   //get
   va       :=sr32[sy][sx].a;
   r        :=(sr32[sy][sx].r*va) shr 8;
   g        :=(sr32[sy][sx].g*va) shr 8;
   b        :=(sr32[sy][sx].b*va) shr 8;

   //no color -> make feather
   if (r=0) and (g=0) and (b=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         va:=sr32[sy][sx-1].a;

         if (va>=1) then
            begin

            inc(r,(sr32[sy][sx-1].r*va) shr 8);
            inc(g,(sr32[sy][sx-1].g*va) shr 8);
            inc(b,(sr32[sy][sx-1].b*va) shr 8);

            end;

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         va:=sr32[sy][sx+1].a;

         if (va>=1) then
            begin

            inc(r,(sr32[sy][sx+1].r*va) shr 8);
            inc(g,(sr32[sy][sx+1].g*va) shr 8);
            inc(b,(sr32[sy][sx+1].b*va) shr 8);

            end;

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         va:=sr32[sy-1][sx].a;

         if (va>=1) then
            begin

            inc(r,(sr32[sy-1][sx].r*va) shr 8);
            inc(g,(sr32[sy-1][sx].g*va) shr 8);
            inc(b,(sr32[sy-1][sx].b*va) shr 8);

            end;

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         va:=sr32[sy+1][sx].a;

         if (va>=1) then
            begin

            inc(r,(sr32[sy+1][sx].r*va) shr 8);
            inc(g,(sr32[sy+1][sx].g*va) shr 8);
            inc(b,(sr32[sy+1][sx].b*va) shr 8);

            end;

         end;

      //detect
      case (r=0) and (g=0) and (b=0) of
      true:result:=0;//transparent
      else begin

         //get
         xslow__detectInfo(r,g,b,dbase,dv);

         //encode feather - "0" or "1..10"
         if      (dv<rle6_featherPartShade    )     then result:=0//transparent
         else if (dv>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
         else                                            result:=dbase + (dv div rle6_featherPartShade);//1..10

         end;
      end;//case

      end
   else
      begin

      //get
      xslow__detectInfo(r,g,b,dbase,dv);

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (dv>=255)                         then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (dv<rle6_minishadeval)            then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (dv div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   function sSLOW32INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      va,r,g,b:longint;
      dbase,dv:byte;
   begin

   //get
   va       :=sr32[sy][sx].a;
   r        :=((255-sr32[sy][sx].r)*va) shr 8;
   g        :=((255-sr32[sy][sx].g)*va) shr 8;
   b        :=((255-sr32[sy][sx].b)*va) shr 8;

   //no color -> make feather
   if (r=0) and (g=0) and (b=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         va:=sr32[sy][sx-1].a;

         if (va>=1) then
            begin

            inc(r,((255-sr32[sy][sx-1].r)*va) shr 8);
            inc(g,((255-sr32[sy][sx-1].g)*va) shr 8);
            inc(b,((255-sr32[sy][sx-1].b)*va) shr 8);

            end;

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         va:=sr32[sy][sx+1].a;

         if (va>=1) then
            begin

            inc(r,((255-sr32[sy][sx+1].r)*va) shr 8);
            inc(g,((255-sr32[sy][sx+1].g)*va) shr 8);
            inc(b,((255-sr32[sy][sx+1].b)*va) shr 8);

            end;

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         va:=sr32[sy-1][sx].a;

         if (va>=1) then
            begin

            inc(r,((255-sr32[sy-1][sx].r)*va) shr 8);
            inc(g,((255-sr32[sy-1][sx].g)*va) shr 8);
            inc(b,((255-sr32[sy-1][sx].b)*va) shr 8);

            end;

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         va:=sr32[sy+1][sx].a;

         if (va>=1) then
            begin

            inc(r,((255-sr32[sy+1][sx].r)*va) shr 8);
            inc(g,((255-sr32[sy+1][sx].g)*va) shr 8);
            inc(b,((255-sr32[sy+1][sx].b)*va) shr 8);

            end;

         end;

      //detect
      case (r=0) and (g=0) and (b=0) of
      true:result:=0;//transparent
      else begin

         //get
         xslow__detectInfo(r,g,b,dbase,dv);

         //encode feather - "0" or "1..10"
         if      (dv<rle6_featherPartShade    )     then result:=0//transparent
         else if (dv>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
         else                                            result:=dbase + (dv div rle6_featherPartShade);//1..10

         end;
      end;//case

      end
   else
      begin

      //get
      xslow__detectInfo(r,g,b,dbase,dv);

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (dv>=255)                         then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (dv<rle6_minishadeval)            then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (dv div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows32(s,sr32)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW32INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW32(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;

procedure tbasicrle6.xslow__makefrom24(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr24:pcolorrows24;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sSLOW24(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r,g,b:longint;
      dbase,dv:byte;
   begin

   //get
   r        :=sr24[sy][sx].r;
   g        :=sr24[sy][sx].g;
   b        :=sr24[sy][sx].b;

   //no color -> make feather
   if (r=0) and (g=0) and (b=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         inc(r,sr24[sy][sx-1].r);
         inc(g,sr24[sy][sx-1].g);
         inc(b,sr24[sy][sx-1].b);

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         inc(r,sr24[sy][sx+1].r);
         inc(g,sr24[sy][sx+1].g);
         inc(b,sr24[sy][sx+1].b);

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         inc(r,sr24[sy-1][sx].r);
         inc(g,sr24[sy-1][sx].g);
         inc(b,sr24[sy-1][sx].b);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         inc(r,sr24[sy+1][sx].r);
         inc(g,sr24[sy+1][sx].g);
         inc(b,sr24[sy+1][sx].b);

         end;

      //detect
      case (r=0) and (g=0) and (b=0) of
      true:result:=0;//transparent
      else begin

         //get
         xslow__detectInfo(r,g,b,dbase,dv);

         //encode feather - "0" or "1..10"
         if      (dv<rle6_featherPartShade    )     then result:=0//transparent
         else if (dv>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
         else                                            result:=dbase + (dv div rle6_featherPartShade);//1..10

         end;
      end;//case

      end
   else
      begin

      //get
      xslow__detectInfo(r,g,b,dbase,dv);

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (dv>=255)                         then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (dv<rle6_minishadeval)            then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (dv div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   function sSLOW24INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r,g,b:longint;
      dbase,dv:byte;
   begin

   //get
   r        :=255-sr24[sy][sx].r;
   g        :=255-sr24[sy][sx].g;
   b        :=255-sr24[sy][sx].b;

   //no color -> make feather
   if (r=0) and (g=0) and (b=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         inc(r,255-sr24[sy][sx-1].r);
         inc(g,255-sr24[sy][sx-1].g);
         inc(b,255-sr24[sy][sx-1].b);

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         inc(r,255-sr24[sy][sx+1].r);
         inc(g,255-sr24[sy][sx+1].g);
         inc(b,255-sr24[sy][sx+1].b);

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         inc(r,255-sr24[sy-1][sx].r);
         inc(g,255-sr24[sy-1][sx].g);
         inc(b,255-sr24[sy-1][sx].b);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         inc(r,255-sr24[sy+1][sx].r);
         inc(g,255-sr24[sy+1][sx].g);
         inc(b,255-sr24[sy+1][sx].b);

         end;

      //detect
      case (r=0) and (g=0) and (b=0) of
      true:result:=0;//transparent
      else begin

         //get
         xslow__detectInfo(r,g,b,dbase,dv);

         //encode feather - "0" or "1..10"
         if      (dv<rle6_featherPartShade    )     then result:=0//transparent
         else if (dv>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
         else                                            result:=dbase + (dv div rle6_featherPartShade);//1..10

         end;
      end;//case

      end
   else
      begin

      //get
      xslow__detectInfo(r,g,b,dbase,dv);

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (dv>=255)                         then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (dv<rle6_minishadeval)            then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (dv div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows24(s,sr24)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW24INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW24(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;

procedure tbasicrle6.xslow__makefrom8(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr8:pcolorrows8;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sSLOW8(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
      dbase,dv:byte;
   begin

   //get
   r        :=sr8[sy][sx];

   //no color -> make feather
   if (r=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         inc(r,sr8[sy][sx-1]);

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         inc(r,sr8[sy][sx+1]);

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         inc(r,sr8[sy-1][sx]);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         inc(r,sr8[sy+1][sx]);

         end;

      //detect
      case (r=0) of
      true:result:=0;//transparent
      else begin

         //get
         xslow__detectInfo(r,r,r,dbase,dv);

         //encode feather
         if      (dv<rle6_featherPartShade    )     then result:=0//transparent
         else if (dv>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
         else                                            result:=dbase + (dv div rle6_featherPartShade);//1..10

         end;
      end;//case

      end
   else
      begin

      //get
      xslow__detectInfo(r,r,r,dbase,dv);

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (dv>=255)                         then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (dv<rle6_minishadeval)            then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (dv div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   function sSLOW8INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
      dbase,dv:byte;
   begin

   //get
   r        :=255-sr8[sy][sx];

   //no color -> make feather
   if (r=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         inc(r,255-sr8[sy][sx-1]);

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         inc(r,255-sr8[sy][sx+1]);

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         inc(r,255-sr8[sy-1][sx]);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         inc(r,255-sr8[sy+1][sx]);

         end;

      //detect
      case (r=0) of
      true:result:=0;//transparent
      else begin

         //get
         xslow__detectInfo(r,r,r,dbase,dv);

         //encode feather - "0" or "1..10"
         if      (dv<rle6_featherPartShade    )     then result:=0//transparent
         else if (dv>=rle6_featherFullShade   )     then result:=dbase + rle6_fshadesPerChannel//10
         else                                            result:=dbase + (dv div rle6_featherPartShade);//1..10

         end;
      end;//case

      end
   else
      begin

      //get
      xslow__detectInfo(r,r,r,dbase,dv);

      //height1 detection
      if xheight1                               then xheight1:=false;

      //encode shade
      if      (dv>=255)                         then result:=dbase + rle6_fshadesPerChannel + rle6_ishadesPerChannel
      else if (dv<rle6_minishadeval)            then result:=dbase + rle6_fshadesPerChannel + 1
      else                                           result:=dbase + rle6_fshadesPerChannel + (dv div rle6_colorDivider);//dbase + 10 + 51 = dbase + 61 - 05mar2026

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows8(s,sr8)               then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW8INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW8(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;


//## tbasicrle8 ################################################################
constructor tbasicrle8.create;
begin

//self
if classnameis('tbasicrle8') then track__inc(satRLE8,1);
inherited create;

//controls
ibits                 :=8;
iwidth                :=0;
iheight               :=0;
iheight1              :=0;
icore                 :=rescache__newStr8;
icore.floatsize       :=100;

//defaults
clear;

end;

destructor tbasicrle8.destroy;
begin
try

//controls
rescache__delStr8(@icore);

//destroy
inherited destroy;
if classnameis('tbasicrle8') then track__inc(satRLE8,-1);

except;end;
end;

procedure tbasicrle8.clear;
begin

iheadLen              :=20;
iwidth                :=0;
iheight               :=0;
iheight1              :=0;

icore.setlen( 0 );
icore.aadd( [uuR,uuL,uuE,nn8] );
icore.addint4( iheadLen );//header length => start of data (header=0..19, data=20+)
icore.addint4( iwidth  );
icore.addint4( iheight );
icore.addint4( iheight1 );

end;

function tbasicrle8.cancopytoimage:boolean;
begin

result:=(iwidth>=1) and (iheight>=1);

end;

function tbasicrle8.copytoimage(d:tobject;const dcol:longint):boolean;
begin

result:=copytoimage2(d,dcol,0);

end;

function tbasicrle8.copytoimage2(d:tobject;const dcol,dfeather4:longint):boolean;//07apr2026
label
   yredo,xredo;

var
   dfeather,vcount,vstop,vpos,vlum,dstopY,dresetX,dstopX,a,dbits,dw,dh,dx,dy,vw,vh:longint;
   vlist:pdlbyte;
   s24 :pcolor24;
   s32 :pcolor32;
   dr8 :pcolorrows8;
   dr24:pcolorrows24;
   dr32:pcolorrows32;
   c32 :tcolor32;
begin

//defaults
result      :=false;
dw          :=width;
dh          :=height;
dy          :=0;
dstopY      :=pred(dh);
dresetX     :=0;
dstopX      :=pred(dw);
c32         :=int__c32(dcol);
dfeather    :=xfd__drawRLE8_featherPower( dfeather4 );

//.source buffer
vlist       :=icore.core;
vstop       :=icore.len32-1;
vcount      :=1;
vpos        :=iheadLen;

//check
if not cancopytoimage            then exit;
if not misok82432(d,dbits,vw,vh) then exit;

//size
if not missize(d,dw,dh)          then exit;

//cls
if not mis__cls(d ,0,0,0,0 )     then exit;

//scan
case dbits of
32:if not misrows32(d,dr32)      then exit;
24:if not misrows24(d,dr24)      then exit;
 8:if not misrows8 (d,dr8 )      then exit;
end;//case

//8/24/32 bit ------------------------------------------------------------------
yredo:

dx  :=dresetX;

xredo:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then exit;

   //get
   a        :=vlist[vpos+0];
   vcount   :=vlist[vpos+1]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a:=a * dfeather;//system feather
   end;//case

   //inc
   inc(vpos,2);

   end;

//set
case dbits of

32:begin

   s32      :=@dr32[dy][dx];

   s32.r    :=c32.r;
   s32.g    :=c32.g;
   s32.b    :=c32.b;
   s32.a    :=a;

   end;

24:begin

   s24      :=@dr24[dy][dx];

   s24.r    :=(c32.r*a) shr 8;
   s24.g    :=(c32.g*a) shr 8;
   s24.b    :=(c32.b*a) shr 8;

   end;

8 :dr8[dy][dx]:=a;

end;//case

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo;

   end;

//successful
result      :=true;

end;

function tbasicrle8.fromdata(s:pobject):boolean;
label
   skipend;

const
   xheadLen =20;

begin

//defaults
result      :=false;

//check
if not str__lock(s) then exit;

try

//init
if (str__len(s)      < xheadLen ) then goto skipend;
if (str__str0(s,0,4)<> 'RLE8'   ) then goto skipend;
if (str__int4(s,4)  <> xheadLen ) then goto skipend;
if (str__int4(s,8)   < 0        ) then goto skipend;//negative width
if (str__int4(s,12)  < 0        ) then goto skipend;//negative height

//get
icore.clear;

//.copy "s" to "icore"
if not str__add(@icore ,s) then
   begin

   //Important: object always expects a valid core header -> hence the "clear" proc which forces a valid core header
   clear;

   goto skipend;

   end;

//set
iwidth      :=str__int4(s,8);
iheight     :=str__int4(s,12);
iheight1    :=str__int4(s,16);

//successful
result      :=true;
skipend:

except;end;

//free
str__uaf(s);

end;

function tbasicrle8.fromarray(const s:array of byte):boolean;
label
   skipend;

const
   xheadLen =20;

begin

//defaults
result      :=false;

//check
if (low(s)<>0)                    then exit;

try

//init
if ((high(s)+1)       < xheadLen )  then goto skipend;
if (s[0]<>uuR) or (s[1]<>uuL) or (s[2]<>uuE) or (s[3]<>nn8) then exit;

if (int32__make( s[ 4],s[ 5],s[ 6],s[ 7]) <> xheadLen ) then goto skipend;
if (int32__make( s[ 8],s[ 9],s[10],s[11])  < 0        ) then goto skipend;//negative width
if (int32__make( s[12],s[13],s[14],s[15])  < 0        ) then goto skipend;//negative height

//get
icore.clear;

//.copy "s" to "icore"
if not str__aadd(@icore ,s) then
   begin

   //Important: object always expects a valid core header -> hence the "clear" proc which forces a valid core header
   clear;

   goto skipend;

   end;

//successful
result      :=true;
skipend:

except;end;
end;

procedure tbasicrle8.fast__makefromR(const s:tobject);
begin

fast__makefromR2(s,misarea(s),false,false);

end;

procedure tbasicrle8.fast__makefromR2(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
begin

case misb(s) of
32:xfast__makefromR32(s,sarea,xinvert,xscanForHeight1);
24:xfast__makefromR24(s,sarea,xinvert,xscanForHeight1);
 8:xfast__makefromR8 (s,sarea,xinvert,xscanForHeight1);
end;//case

end;

procedure tbasicrle8.xfast__makefromR32(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr32:pcolorrows32;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sFAST32(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
   begin

   //get
   result:=sr32[sy][sx].r;

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      r:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(r,sr32[sy][sx-1].r);

      //x+1 -> right
      if (sx<sarea.right)    then inc(r,sr32[sy][sx+1].r);

      //y-1 -> above
      if (sy>sarea.top)      then inc(r,sr32[sy-1][sx].r);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(r,sr32[sy+1][sx].r);

      //encode feather
      if (r=0) then
         begin

         //still transparent

         end
      else if (r>=rle8_featherPeak)           then result:=rle8_featherCount
      else                                         result:=r div rle8_featherDivider;

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if      (result<=rle8_featherCount)     then result:=rle8_featherCount+1;

      end;

   end;

   function sFAST32INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
   begin

   //get
   result:=255-sr32[sy][sx].r;

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      r:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(r,255-sr32[sy][sx-1].r);

      //x+1 -> right
      if (sx<sarea.right)    then inc(r,255-sr32[sy][sx+1].r);

      //y-1 -> above
      if (sy>sarea.top)      then inc(r,255-sr32[sy-1][sx].r);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(r,255-sr32[sy+1][sx].r);

      //encode feather
      if (r=0) then
         begin

         //still transparent

         end
      else if (r>=rle8_featherPeak)           then result:=rle8_featherCount
      else                                         result:=r div rle8_featherDivider;

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if      (result<=rle8_featherCount)     then result:=rle8_featherCount+1;

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows32(s,sr32)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST32INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST32(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;

procedure tbasicrle8.xfast__makefromR24(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr24:pcolorrows24;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sFAST24(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
   begin

   //get
   result:=sr24[sy][sx].r;

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      r:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(r,sr24[sy][sx-1].r);

      //x+1 -> right
      if (sx<sarea.right)    then inc(r,sr24[sy][sx+1].r);

      //y-1 -> above
      if (sy>sarea.top)      then inc(r,sr24[sy-1][sx].r);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(r,sr24[sy+1][sx].r);

      //encode feather
      if (r=0) then
         begin

         //still transparent

         end
      else if (r>=rle8_featherPeak)           then result:=rle8_featherCount
      else                                         result:=r div rle8_featherDivider;

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if      (result<=rle8_featherCount)     then result:=rle8_featherCount+1;

      end;

   end;

   function sFAST24INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
   begin

   //get
   result:=255-sr24[sy][sx].r;

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      r:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(r,255-sr24[sy][sx-1].r);

      //x+1 -> right
      if (sx<sarea.right)    then inc(r,255-sr24[sy][sx+1].r);

      //y-1 -> above
      if (sy>sarea.top)      then inc(r,255-sr24[sy-1][sx].r);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(r,255-sr24[sy+1][sx].r);

      //encode feather
      if (r=0) then
         begin

         //still transparent

         end
      else if (r>=rle8_featherPeak)           then result:=rle8_featherCount
      else                                         result:=r div rle8_featherDivider;

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if      (result<=rle8_featherCount)     then result:=rle8_featherCount+1;

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows24(s,sr24)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST24INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST24(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;

procedure tbasicrle8.xfast__makefromR8(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr8:pcolorrows8;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sFAST8(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
   begin

   //get
   result:=sr8[sy][sx];

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      r:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(r,sr8[sy][sx-1]);

      //x+1 -> right
      if (sx<sarea.right)    then inc(r,sr8[sy][sx+1]);

      //y-1 -> above
      if (sy>sarea.top)      then inc(r,sr8[sy-1][sx]);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(r,sr8[sy+1][sx]);

      //encode feather
      if (r=0) then
         begin

         //still transparent

         end
      else if (r>=rle8_featherPeak)           then result:=rle8_featherCount
      else                                         result:=r div rle8_featherDivider;

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if      (result<=rle8_featherCount)     then result:=rle8_featherCount+1;

      end;

   end;

   function sFAST8INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
   begin

   //get
   result:=255-sr8[sy][sx];

   //no color -> make feather
   if (result=0) then
      begin

      //center pixel
      r:=0;

      //x-1 -> left
      if (sx>sarea.left)     then inc(r,255-sr8[sy][sx-1]);

      //x+1 -> right
      if (sx<sarea.right)    then inc(r,255-sr8[sy][sx+1]);

      //y-1 -> above
      if (sy>sarea.top)      then inc(r,255-sr8[sy-1][sx]);

      //y+1 -> below
      if (sy<sarea.bottom)   then inc(r,255-sr8[sy+1][sx]);

      //encode feather
      if (r=0) then
         begin

         //still transparent

         end
      else if (r>=rle8_featherPeak)           then result:=rle8_featherCount
      else                                         result:=r div rle8_featherDivider;

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if      (result<=rle8_featherCount)     then result:=rle8_featherCount+1;

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows8(s,sr8)               then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST8INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sFAST8(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;


procedure tbasicrle8.slow__makefromLUM(const s:tobject);
begin

slow__makefromLUM2(s,misarea(s),false,false);

end;

procedure tbasicrle8.slow__makefromLUM2(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
begin

case misb(s) of
32:xslow__makefromLUM32(s,sarea,xinvert,xscanForHeight1);
24:xslow__makefromLUM24(s,sarea,xinvert,xscanForHeight1);
 8:xslow__makefromLUM8 (s,sarea,xinvert,xscanForHeight1);
end;//case

end;

procedure tbasicrle8.xslow__makefromLUM32(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr32:pcolorrows32;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sSLOW32(const sy,sx:longint):byte;//3x3 blur matrix
   var
      va,r,g,b:longint;
   begin

   //get
   va       :=sr32[sy][sx].a;
   r        :=(sr32[sy][sx].r*va) shr 8;
   g        :=(sr32[sy][sx].g*va) shr 8;
   b        :=(sr32[sy][sx].b*va) shr 8;

   //no color -> make feather
   if (r=0) and (g=0) and (b=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         va:=sr32[sy][sx-1].a;

         if (va>=1) then
            begin

            inc(r,(sr32[sy][sx-1].r*va) shr 8);
            inc(g,(sr32[sy][sx-1].g*va) shr 8);
            inc(b,(sr32[sy][sx-1].b*va) shr 8);

            end;

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         va:=sr32[sy][sx+1].a;

         if (va>=1) then
            begin

            inc(r,(sr32[sy][sx+1].r*va) shr 8);
            inc(g,(sr32[sy][sx+1].g*va) shr 8);
            inc(b,(sr32[sy][sx+1].b*va) shr 8);

            end;

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         va:=sr32[sy-1][sx].a;

         if (va>=1) then
            begin

            inc(r,(sr32[sy-1][sx].r*va) shr 8);
            inc(g,(sr32[sy-1][sx].g*va) shr 8);
            inc(b,(sr32[sy-1][sx].b*va) shr 8);

            end;

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         va:=sr32[sy+1][sx].a;

         if (va>=1) then
            begin

            inc(r,(sr32[sy+1][sx].r*va) shr 8);
            inc(g,(sr32[sy+1][sx].g*va) shr 8);
            inc(b,(sr32[sy+1][sx].b*va) shr 8);

            end;

         end;

      //detect
      case (r=0) and (g=0) and (b=0) of
      true:result:=0;//transparent
      else begin

         //encode feather
         if (g>r) then r:=g;
         if (b>r) then r:=b;

         if (r>=rle8_featherPeak)             then result:=rle8_featherCount
         else                                      result:=r div rle8_featherDivider;

         end;
      end;//case

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if (g>r) then r:=g;
      if (b>r) then r:=b;

      case (r<=rle8_featherCount) of
      true:result:=rle8_featherCount+1;
      else result:=r;
      end;//case

      end;

   end;

   function sSLOW32INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      va,r,g,b:longint;
   begin

   //get
   va       :=sr32[sy][sx].a;
   r        :=((255-sr32[sy][sx].r)*va) shr 8;
   g        :=((255-sr32[sy][sx].g)*va) shr 8;
   b        :=((255-sr32[sy][sx].b)*va) shr 8;

   //no color -> make feather
   if (r=0) and (g=0) and (b=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         va:=sr32[sy][sx-1].a;

         if (va>=1) then
            begin

            inc(r,((255-sr32[sy][sx-1].r)*va) shr 8);
            inc(g,((255-sr32[sy][sx-1].g)*va) shr 8);
            inc(b,((255-sr32[sy][sx-1].b)*va) shr 8);

            end;

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         va:=sr32[sy][sx+1].a;

         if (va>=1) then
            begin

            inc(r,((255-sr32[sy][sx+1].r)*va) shr 8);
            inc(g,((255-sr32[sy][sx+1].g)*va) shr 8);
            inc(b,((255-sr32[sy][sx+1].b)*va) shr 8);

            end;

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         va:=sr32[sy-1][sx].a;

         if (va>=1) then
            begin

            inc(r,((255-sr32[sy-1][sx].r)*va) shr 8);
            inc(g,((255-sr32[sy-1][sx].g)*va) shr 8);
            inc(b,((255-sr32[sy-1][sx].b)*va) shr 8);

            end;

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         va:=sr32[sy+1][sx].a;

         if (va>=1) then
            begin

            inc(r,((255-sr32[sy+1][sx].r)*va) shr 8);
            inc(g,((255-sr32[sy+1][sx].g)*va) shr 8);
            inc(b,((255-sr32[sy+1][sx].b)*va) shr 8);

            end;

         end;

      //detect
      case (r=0) and (g=0) and (b=0) of
      true:result:=0;//transparent
      else begin

         //encode feather
         if (g>r) then r:=g;
         if (b>r) then r:=b;

         if (r>=rle8_featherPeak)             then result:=rle8_featherCount
         else                                      result:=r div rle8_featherDivider;

         end;
      end;//case

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if (g>r) then r:=g;
      if (b>r) then r:=b;

      case (r<=rle8_featherCount) of
      true:result:=rle8_featherCount+1;
      else result:=r;
      end;//case

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows32(s,sr32)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW32INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW32(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;

procedure tbasicrle8.xslow__makefromLUM24(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr24:pcolorrows24;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sSLOW24(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r,g,b:longint;
   begin

   //get
   r        :=sr24[sy][sx].r;
   g        :=sr24[sy][sx].g;
   b        :=sr24[sy][sx].b;

   //no color -> make feather
   if (r=0) and (g=0) and (b=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         inc(r,sr24[sy][sx-1].r);
         inc(g,sr24[sy][sx-1].g);
         inc(b,sr24[sy][sx-1].b);

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         inc(r,sr24[sy][sx+1].r);
         inc(g,sr24[sy][sx+1].g);
         inc(b,sr24[sy][sx+1].b);

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         inc(r,sr24[sy-1][sx].r);
         inc(g,sr24[sy-1][sx].g);
         inc(b,sr24[sy-1][sx].b);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         inc(r,sr24[sy+1][sx].r);
         inc(g,sr24[sy+1][sx].g);
         inc(b,sr24[sy+1][sx].b);

         end;

      //detect
      case (r=0) and (g=0) and (b=0) of
      true:result:=0;//transparent
      else begin

         //encode feather
         if (g>r) then r:=g;
         if (b>r) then r:=b;

         if (r>=rle8_featherPeak)             then result:=rle8_featherCount
         else                                      result:=r div rle8_featherDivider;

         end;
      end;//case

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if (g>r) then r:=g;
      if (b>r) then r:=b;

      case (r<=rle8_featherCount) of
      true:result:=rle8_featherCount+1;
      else result:=r;
      end;//case

      end;

   end;

   function sSLOW24INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r,g,b:longint;
   begin

   //get
   r        :=255-sr24[sy][sx].r;
   g        :=255-sr24[sy][sx].g;
   b        :=255-sr24[sy][sx].b;

   //no color -> make feather
   if (r=0) and (g=0) and (b=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         inc(r,255-sr24[sy][sx-1].r);
         inc(g,255-sr24[sy][sx-1].g);
         inc(b,255-sr24[sy][sx-1].b);

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         inc(r,255-sr24[sy][sx+1].r);
         inc(g,255-sr24[sy][sx+1].g);
         inc(b,255-sr24[sy][sx+1].b);

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         inc(r,255-sr24[sy-1][sx].r);
         inc(g,255-sr24[sy-1][sx].g);
         inc(b,255-sr24[sy-1][sx].b);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         inc(r,255-sr24[sy+1][sx].r);
         inc(g,255-sr24[sy+1][sx].g);
         inc(b,255-sr24[sy+1][sx].b);

         end;

      //detect
      case (r=0) and (g=0) and (b=0) of
      true:result:=0;//transparent
      else begin

         //encode feather
         if (g>r) then r:=g;
         if (b>r) then r:=b;

         if (r>=rle8_featherPeak)             then result:=rle8_featherCount
         else                                      result:=r div rle8_featherDivider;

         end;
      end;//case

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if (g>r) then r:=g;
      if (b>r) then r:=b;

      case (r<=rle8_featherCount) of
      true:result:=rle8_featherCount+1;
      else result:=r;
      end;//case

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows24(s,sr24)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW24INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW24(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;

procedure tbasicrle8.xslow__makefromLUM8(const s:tobject;sarea:twinrect;const xinvert,xscanForHeight1:boolean);
var
   sr8:pcolorrows8;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   v,lv:byte;
   xheight1:boolean;

   function sSLOW8(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
   begin

   //get
   r        :=sr8[sy][sx];

   //no color -> make feather
   if (r=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         inc(r,sr8[sy][sx-1]);

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         inc(r,sr8[sy][sx+1]);

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         inc(r,sr8[sy-1][sx]);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         inc(r,sr8[sy+1][sx]);

         end;

      //detect
      case (r=0) of
      true:result:=0;//transparent
      else begin

         //encode feather
         if (r>=rle8_featherPeak)             then result:=rle8_featherCount
         else                                      result:=r div rle8_featherDivider;

         end;
      end;//case

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      case (r<=rle8_featherCount) of
      true:result:=rle8_featherCount+1;
      else result:=r;
      end;//case

      end;

   end;

   function sSLOW8INV(const sy,sx:longint):byte;//3x3 blur matrix
   var
      r:longint;
   begin

   //get
   r        :=255-sr8[sy][sx];

   //no color -> make feather
   if (r=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) then
         begin

         inc(r,255-sr8[sy][sx-1]);

         end;

      //x+1 -> right
      if (sx<sarea.right) then
         begin

         inc(r,255-sr8[sy][sx+1]);

         end;

      //y-1 -> above
      if (sy>sarea.top) then
         begin

         inc(r,255-sr8[sy-1][sx]);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) then
         begin

         inc(r,255-sr8[sy+1][sx]);

         end;

      //detect
      case (r=0) of
      true:result:=0;//transparent
      else begin

         //encode feather
         if (r>=rle8_featherPeak)             then result:=rle8_featherCount
         else                                      result:=r div rle8_featherDivider;

         end;
      end;//case

      end
   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      case (r<=rle8_featherCount) of
      true:result:=rle8_featherCount+1;
      else result:=r;
      end;//case

      end;

   end;

   procedure p8Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lv);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p8;
   begin

   if (lv<>v) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         end;

      lv              :=v;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lv);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows8(s,sr8)               then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lv                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=1000;
else icore.floatsize  :=100;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

case xinvert of
true:begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW8INV(dy,dx);
   p8;

   end;//dx

   end;

else begin

   for dx:=sarea.left to sarea.right do
   begin

   v                  :=sSLOW8(dy,dx);
   p8;

   end;//dx

   end;
end;//case

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p8Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  8 ]       :=iwidth;
icore.int4[ 12 ]       :=iheight;
icore.int4[ 16 ]       :=iheight1;

end;


//## tbasicrle32 ###############################################################
constructor tbasicrle32.create;
begin

//self
if classnameis('tbasicrle32') then track__inc(satRLE32,1);
inherited create;

//controls
ibits                 :=8;
iwidth                :=0;
iheight               :=0;
iheight1              :=0;
icore                 :=rescache__newStr8;
icore.floatsize       :=200;

//defaults
clear;

end;

destructor tbasicrle32.destroy;
begin
try

//controls
rescache__delStr8(@icore);

//destroy
inherited destroy;
if classnameis('tbasicrle32') then track__inc(satRLE32,-1);

except;end;
end;

function tbasicrle32.fromdata(s:pobject):boolean;
label
   skipend;

const
   xheadLen =21;

begin

//defaults
result      :=false;

//check
if not str__lock(s)               then exit;

try

//init
if (str__len(s)      < xheadLen ) then goto skipend;
if (str__str0(s,0,5)<> 'RLE32'  ) then goto skipend;
if (str__int4(s,5)  <> xheadLen ) then goto skipend;
if (str__int4(s,9)   < 0        ) then goto skipend;//negative width
if (str__int4(s,13)  < 0        ) then goto skipend;//negative height

//get
icore.clear;

//.copy "s" to "icore"
if not str__add(@icore ,s) then
   begin

   //Important: object always expects a valid core header -> hence the "clear" proc which forces a valid core header
   clear;

   goto skipend;

   end;

//successful
result      :=true;
skipend:

except;end;

//free
str__uaf(s);

end;

function tbasicrle32.fromarray(const s:array of byte):boolean;
label
   skipend;

const
   xheadLen =21;

begin

//defaults
result      :=false;

//check
if (low(s)<>0)                      then exit;

try

//init
if ((high(s)+1)       < xheadLen )  then goto skipend;
if (s[0]<>uuR) or (s[1]<>uuL) or (s[2]<>uuE) or (s[3]<>nn3) or (s[4]<>nn2) then exit;

if (int32__make( s[ 5],s[ 6],s[ 7],s[ 8]) <> xheadLen ) then goto skipend;
if (int32__make( s[ 9],s[10],s[11],s[12])  < 0        ) then goto skipend;//negative width
if (int32__make( s[13],s[14],s[15],s[16])  < 0        ) then goto skipend;//negative height

//get
icore.clear;

//.copy "s" to "icore"
if not str__aadd(@icore ,s) then
   begin

   //Important: object always expects a valid core header -> hence the "clear" proc which forces a valid core header
   clear;

   goto skipend;

   end;

//successful
result      :=true;
skipend:

except;end;
end;

function tbasicrle32.cancopytoimage:boolean;
begin

result:=(iwidth>=1) and (iheight>=1);

end;

function tbasicrle32.copytoimage(d:tobject):boolean;
begin

result:=copytoimage2(d,0);

end;

function tbasicrle32.copytoimage2(d:tobject;const dfeather4:longint):boolean;
label
   yredo,xredo;

var
   dfeather,vcount,vstop,vpos,vlum,dstopY,dresetX,dstopX,r,g,b,a,dbits,dw,dh,dx,dy,vw,vh:longint;
   vlist:pdlbyte;
   s24 :pcolor24;
   s32 :pcolor32;
   dr8 :pcolorrows8;
   dr24:pcolorrows24;
   dr32:pcolorrows32;

begin

//defaults
result      :=false;
dw          :=width;
dh          :=height;
dy          :=0;
dstopY      :=pred(dh);
dresetX     :=0;
dstopX      :=pred(dw);
dfeather    :=xfd__drawRLE32_featherPower( dfeather4 );

//.source buffer
vlist       :=icore.core;
vstop       :=icore.len32-4;
vcount      :=1;
vpos        :=iheadLen;

//check
if not cancopytoimage            then exit;
if not misok82432(d,dbits,vw,vh) then exit;

//size
if not missize(d,dw,dh)          then exit;

//cls
if not mis__cls(d ,0 ,0 ,0 ,0 )  then exit;

//scan
case dbits of
32:if not misrows32(d,dr32)      then exit;
24:if not misrows24(d,dr24)      then exit;
 8:if not misrows8 (d,dr8 )      then exit;
end;//case

//8/24/32 bit ------------------------------------------------------------------
yredo:

dx  :=dresetX;

xredo:

//render pixel
dec(vcount);

if (vcount=0) then
   begin

   //check
   if (vpos>=vstop) then exit;

   //get
   b        :=vlist[vpos+0];
   g        :=vlist[vpos+1];
   r        :=vlist[vpos+2];
   a        :=vlist[vpos+3];
   vcount   :=vlist[vpos+4]+1;

   //realtime feather
   case a of
   1..rle8_featherCount: a:=a * dfeather;//system feather
   end;//case

   case dbits of
   8:begin

      vlum  :=r;
      if (g>vlum) then vlum:=g;
      if (b>vlum) then vlum:=b;

      end;
   end;//case

   //inc
   inc(vpos,5);

   end;

//set
case dbits of

32:begin

   s32      :=@dr32[dy][dx];

   s32.r    :=r;
   s32.g    :=g;
   s32.b    :=b;
   s32.a    :=a;

   end;

24:begin

   s24      :=@dr24[dy][dx];

   s24.r    :=r;
   s24.g    :=g;
   s24.b    :=b;

   end;

8 :dr8[dy][dx]:=vlum;

end;//case

//inc x
if (dx<>dstopX) then
   begin

   inc(dx,1);
   goto xredo;

   end;

//inc y
if (dy<>dstopY) then
   begin

   inc(dy,1);
   goto yredo;

   end;

//successful
result      :=true;

end;

procedure tbasicrle32.clear;
begin

iheadLen              :=21;
iwidth                :=0;
iheight               :=0;
iheight1              :=0;

icore.setlen( 0 );
icore.aadd( [uuR,uuL,uuE,nn3,nn2] );
icore.addint4( iheadLen );//header length => start of data (header=0..20, data=21+)
icore.addint4( iwidth  );
icore.addint4( iheight );
icore.addint4( iheight1 );

end;

procedure tbasicrle32.rgba__makefrom(const s:tobject);
begin

rgba__makefrom2(s,misarea(s),false);

end;

procedure tbasicrle32.rgba__makefrom2(const s:tobject;sarea:twinrect;const xscanForHeight1:boolean);
begin

case misb(s) of
32:xrgba__makefrom32(s,sarea,xscanForHeight1);
24:xrgba__makefrom24(s,sarea,xscanForHeight1);
 8:xrgba__makefrom8 (s,sarea,xscanForHeight1);
end;//case

end;

procedure tbasicrle32.xrgba__makefrom32(const s:tobject;sarea:twinrect;const xscanForHeight1:boolean);//20mar2026
var
   sr32:pcolorrows32;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   lr,lg,lb,la:byte;
   dr,dg,db,da:longint;
   xheight1:boolean;

   function sSLOW32(const sy,sx:longint):byte;//3x3 blur matrix
   var
      va:longint;
   begin

   //get
   dr       :=sr32[sy][sx].r;
   dg       :=sr32[sy][sx].g;
   db       :=sr32[sy][sx].b;
   da       :=sr32[sy][sx].a;

   //transparent -> make feather
   if (da=0) then
      begin

      //init
      dr              :=0;
      dg              :=0;
      db              :=0;
      da              :=0;

      //x-1 -> left
      if (sx>sarea.left) and (sr32[sy][sx-1].a>=1) then
         begin

         va :=sr32[sy][sx-1].a;

         inc(dr,sr32[sy][sx-1].r*va);
         inc(dg,sr32[sy][sx-1].g*va);
         inc(db,sr32[sy][sx-1].b*va);
         inc(da,va);

         end;

      //x+1 -> right
      if (sx<sarea.right) and (sr32[sy][sx+1].a>=1) then
         begin

         va :=sr32[sy][sx+1].a;

         inc(dr,sr32[sy][sx+1].r*va);
         inc(dg,sr32[sy][sx+1].g*va);
         inc(db,sr32[sy][sx+1].b*va);
         inc(da,va);

         end;

      //y-1 -> above
      if (sy>sarea.top) and (sr32[sy-1][sx].a>=1) then
         begin

         va :=sr32[sy-1][sx].a;

         inc(dr,sr32[sy-1][sx].r*va);
         inc(dg,sr32[sy-1][sx].g*va);
         inc(db,sr32[sy-1][sx].b*va);
         inc(da,va);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) and (sr32[sy+1][sx].a>=1) then
         begin

         va :=sr32[sy+1][sx].a;

         inc(dr,sr32[sy+1][sx].r*va);
         inc(dg,sr32[sy+1][sx].g*va);
         inc(db,sr32[sy+1][sx].b*va);
         inc(da,va);

         end;

      //detect
      if (da>=1) then
         begin

         dr           :=(dr div da);
         dg           :=(dg div da);
         db           :=(db div da);

         //encode feather
         if (da>=rle8_featherPeak) then da:=rle8_featherCount
         else                           da:=da div rle8_featherDivider;

         end;

      end

   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if (da<=rle8_featherCount) then da:=rle8_featherCount+1;

      end;

   end;

   procedure p32Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lb);
      icore.addbyt1(lg);
      icore.addbyt1(lr);
      icore.addbyt1(la);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p32;
   begin

   if (lr<>dr) or (lg<>dg) or (lb<>db) or (la<>da) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lb);
         icore.addbyt1(lg);
         icore.addbyt1(lr);
         icore.addbyt1(la);
         icore.addbyt1(lcount-1);

         end;

      lr              :=dr;
      lg              :=dg;
      lb              :=db;
      la              :=da;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lb);
         icore.addbyt1(lg);
         icore.addbyt1(lr);
         icore.addbyt1(la);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows32(s,sr32)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lr                    :=0;
lg                    :=0;
lb                    :=0;
la                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=2000;
else icore.floatsize  :=200;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

for dx:=sarea.left to sarea.right do
begin

sSLOW32(dy,dx);
p32;

end;//dx

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p32Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  9 ]       :=iwidth;
icore.int4[ 13 ]       :=iheight;
icore.int4[ 17 ]       :=iheight1;

end;

procedure tbasicrle32.xrgba__makefrom24(const s:tobject;sarea:twinrect;const xscanForHeight1:boolean);//20mar2026
var//No transparency support for 24 bit images
   sr24:pcolorrows24;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   lr,lg,lb:byte;
   dr,dg,db:longint;
   xheight1:boolean;

   procedure p32Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(lb);
      icore.addbyt1(lg);
      icore.addbyt1(lr);
      icore.addbyt1(255);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p32;
   begin

   if (lr<>dr) or (lg<>dg) or (lb<>db) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(lb);
         icore.addbyt1(lg);
         icore.addbyt1(lr);
         icore.addbyt1(255);
         icore.addbyt1(lcount-1);

         end;

      lr              :=dr;
      lg              :=dg;
      lb              :=db;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(lb);
         icore.addbyt1(lg);
         icore.addbyt1(lr);
         icore.addbyt1(255);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows24(s,sr24)             then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
lr                    :=0;
lg                    :=0;
lb                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=2000;
else icore.floatsize  :=200;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

for dx:=sarea.left to sarea.right do
begin

dr          :=sr24[dy][dx].r;
dg          :=sr24[dy][dx].g;
db          :=sr24[dy][dx].b;

p32;

end;//dx

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p32Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  9 ]       :=iwidth;
icore.int4[ 13 ]       :=iheight;
icore.int4[ 17 ]       :=iheight1;

end;

procedure tbasicrle32.xrgba__makefrom8(const s:tobject;sarea:twinrect;const xscanForHeight1:boolean);//20mar2026
var//8 bit image assumed to be greyscale with 0=transparent, 255=solid and 1..254=semi-transparent/grey
   sr8:pcolorrows8;
   lcount,sbits,sw,sh,dx,dy,dy1:longint;
   la:byte;
   da:longint;
   xheight1:boolean;

   function sSLOW8(const sy,sx:longint):byte;//3x3 blur matrix
   var
      va:longint;
   begin

   //get
   da       :=sr8[sy][sx];

   //transparent -> make feather
   if (da=0) then
      begin

      //x-1 -> left
      if (sx>sarea.left) and (sr8[sy][sx-1]>=1) then
         begin

         inc(da,sr8[sy][sx-1]);

         end;

      //x+1 -> right
      if (sx<sarea.right) and (sr8[sy][sx+1]>=1) then
         begin

         inc(da,sr8[sy][sx+1]);

         end;

      //y-1 -> above
      if (sy>sarea.top) and (sr8[sy-1][sx]>=1) then
         begin

         inc(da,sr8[sy-1][sx]);

         end;

      //y+1 -> below
      if (sy<sarea.bottom) and (sr8[sy+1][sx]>=1) then
         begin

         inc(da,sr8[sy+1][sx]);

         end;

      //detect
      if (da>=1) then
         begin

         //encode feather
         if (da>=rle8_featherPeak) then da:=rle8_featherCount
         else                           da:=da div rle8_featherDivider;

         end;

      end

   else
      begin

      //height1 detection
      if xheight1                             then xheight1:=false;

      //skip over system feather bandwidth
      if (da<=rle8_featherCount) then da:=rle8_featherCount+1;

      end;

   end;

   procedure p32Finish;
   begin

   if (lcount>=1) then
      begin

      icore.addbyt1(la);
      icore.addbyt1(la);
      icore.addbyt1(la);
      icore.addbyt1(la);
      icore.addbyt1(lcount-1);

      end;

   end;

   procedure p32;
   begin

   if (la<>da) then
      begin

      if (lcount>=1) then
         begin

         icore.addbyt1(la);
         icore.addbyt1(la);
         icore.addbyt1(la);
         icore.addbyt1(la);
         icore.addbyt1(lcount-1);

         end;

      la              :=da;
      lcount          :=1;

      end
   else
      begin

      inc(lcount);

      if (lcount>=256) then
         begin

         icore.addbyt1(la);
         icore.addbyt1(la);
         icore.addbyt1(la);
         icore.addbyt1(la);
         icore.addbyt1(lcount-1);

         lcount:=0;

         end;

      end;

   end;

begin

//defaults
clear;

//check
if not misok82432(s,sbits,sw,sh)     then exit;
if not misrows8(s,sr8)               then exit;

//range
sarea.left            :=frcrange32( sarea.left    ,0          ,sw-1 );
sarea.right           :=frcrange32( sarea.right   ,sarea.left ,sw-1 );
sarea.top             :=frcrange32( sarea.top     ,0          ,sh-1 );
sarea.bottom          :=frcrange32( sarea.bottom  ,sarea.top  ,sh-1 );

//init
lcount                :=0;
la                    :=0;
dy1                   :=0;

case (sh>=40) or (sw>=40) of
true:icore.floatsize  :=2000;
else icore.floatsize  :=200;
end;//case

//get
for dy:=sarea.top to sarea.bottom do
begin

xheight1              :=xscanForHeight1 and (dy>=dy1);

for dx:=sarea.left to sarea.right do
begin

sSLOW8(dy,dx);
p32;

end;//dx

//dy1
if xscanForHeight1 and (not xheight1) and (dy>=dy1) then dy1:=dy;

end;//dy

//finalise
p32Finish;

iwidth                 :=sarea.right-sarea.left + 1;
iheight                :=sarea.bottom-sarea.top + 1;
iheight1               :=dy1 - sarea.top + 1;
icore.int4[  9 ]       :=iwidth;
icore.int4[ 13 ]       :=iheight;
icore.int4[ 17 ]       :=iheight1;

end;

end.
