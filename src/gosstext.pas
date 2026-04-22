unit gosstext;

//??????????????????????????????????????????????????????????????????????????????
//??????????????????????????????????????????????????????????????????????????????
//??????????????????????????????????????????????????????????????????????????????

//** To Do List ****************************************************************
//1. xread__htm
//2. copy/paste as html
//3. pdf (write/read = basic)

//6. tstr8 outsourced to res__newstr for rapid reuse????
//7. option to edit htm/html as TXT (not stylised - will be required for Claude) ***!!!!!!!!!!!
//8. Option for persistent undo/redo storage (might be trickey if file moves/changes etc)

//[done/png] 9. image inside RTF for copy -> MS uses metafile8 for older apps, e.g. WordPad will create a new document with metafile8 images

//[done] 10. cancopy = RTF
//[done] 11. canpaste = RTF

//[done] 12. cancopy = HTM (basic)
//13. canpaste = HTM (basic)

//14. remove 4byte hdr for unicode/utf8 documents: htm/html/txt

//15. metaFile support for xread__rtf -> for backward compatibility for WordPad documents etc
//15. Windows Meta File (picture) for RTF (older format support)

//16. high quality Italic mode that is OBVIOUS at a glance - for easier reading [ ITALIC ]

//18. fix font bugs....etc -> different fonts sometimes screw up font.height and one font is below the rest of the line for no reason
//19. improve highlight function -> currently is wiping out background color!
//20. default font color -> not black, but system color (clnone=system color??????)
//21. test textBox in multi-font and multi-size modes
//22. underline and spell-underline must be CONSISTENT thickness for all font variations on the same line etc
//23. upgrade RTF/HTML support to include multi-font, multi-size, multi-textColor and multi-backColor fonts....
//24. upgrade tbwpBar.WrapStyle to work with doceditor (currently it fights against it) - 28feb2026
//25. scale image up/down in line with system "viscale" -> instead of zoom, need a fast__drawStretch proc for this with layer/power support
//26. 127-255 character support for RTF
//27. better switch support for when onefontname/onefontsize are engaged and disengaged -> currently, fonts don't always switch back properly - 01mar2026
//28. Default font color = system color even for custom font/color/style text box
//29. *** Scale images *** (not system TEPs) to active system scale (e.g. OS scale + User scale) -> need to use fast__drawArea() proc => similar to old copyareaFast()...

//??????????????????????????????????????????????????????????????????????????????
//??????????????????????????????????????????????????????????????????????????????
//??????????????????????????????????????????????????????????????????????????????


interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef WIN64}{$define 64bit}{$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses {$ifdef laz}classes, {$endif} sysutils, gosswin2, gosswin, gossroot, gossio, gossimg, gossfast;
{$ifdef d3laz} const stroffset=1; {$else} const stroffset=0; {$endif}  {0 or 1 based string index handling}
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
//## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//## CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//##
//## ==========================================================================================================================================================================================================================
//## Library.................. TextCore - non-GUI and GUI text engine for text boxes - (gosstext.pas)
//## Version.................. 4.00.7544 (+40)
//## Items.................... 2
//## Last Updated ............ 22apr2026, 26mar2026, 25mar2026, 03mar2026, 01mar2026, 28feb2026, 19feb2026, 17feb2026, 15feb2026, 13feb2026
//## Lines of Code............ 12,900+
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
//## | tspell                 | tobjectex         | 1.00.160  | 17feb2026   | System dictionary of 296,000+ full length, non-encoded / non-shortened words - 11feb2022
//## | ttextcore              | tobject           | 2.00.7344 | 22apr2026   | Multi-line, multi-format, text engine for text box controls - now using FastDraw procs for ~200%+ render speed improvement - 26mar2026, 25mar2026, 03mar2026, 28feb2026, 17feb2026, 17feb2026: read/write basic RTF, 15feb2026, 13feb2026
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================

const

   textcore_listlimit     =1000;
   textcore_listmax       =textcore_listlimit-1;
   textcore_minfontsize   =4;
   textcore_maxfontsize   =300;

   //selection modifier commands
   smFontname             =0;
   smFontsize             =1;
   smBold                 =2;
   smItalic               =3;
   smUnderline            =4;
   smStrikeout            =5;
   smColor                =6;
   smBgcolor              =7;
   smBrcolor              =8;
   smColor_Bgcolor        =9;
   smColor_Bgcolor_Style  =10;
   smUppercase            =11;
   smLowercase            =12;
   smMax                  =12;

   //full-stream modifier commands
   ftmArial               =0;
   ftmCourier             =1;
   ftmLarger              =2;
   ftmSmaller             =3;
   ftmApplyMask           =4;
   ftmMax                 =4;

   //setdata mode
   sioIOset               =0;
   sioIOins               =1;
   sioIOins_NoUndo        =2;
   sioMax                 =2;

   //word wrap styles
   wwsNone                =0;
   wwsWindow              =1;
   wwsPage                =2;
   wwsPage2               =3;
   wwsMax                 =3;

   //multi-undo styles
   musNone                =0;
   musDelL                =1;
   musDelR                =2;
   musIns                 =3;
   musSel                 =4;
   musSelKeep             =5;
   musRangeKeep           =6;//datastream size remains same, byte from1..xlen is replaced
   musRecovered           =7;
   musInsImg              =8;
   musMax                 =8;

   //.musRecovered - actions
   muaRep                 =0;
   muaAdd                 =1;
   muaSub                 =2;
   muaMax                 =2;

   //move codes
   mcScootLeft            =0;
   mcScootRight           =1;
   mcLeft                 =2;
   mcRight                =3;
   mcUp                   =4;
   mcDown                 =5;
   mcPageUp               =6;
   mcPageDown             =7;
   mcLineStart            =8;
   mcLineEnd              =9;
   mcHome                 =10;
   mcEnd                  =11;
   mcMax                  =11;

   //align styles
   wcaLeft                =0;
   wcaCenter              =1;
   wcaRight               =2;
   wcaMax                 =2;

   //char style codes
   wc_n                   =0;//no style
   wc_t                   =1;//text
   wc_i                   =2;//image
   wc_max                 =2;

   //format levels
   fmlTXT                 =0;//basic - text only
   fmlBWD                 =1;//enhanced text (bwd) - text + styles
   fmlBWP                 =2;//advanced text (bwp) - text + styles + fonts + images
   fmlMax                 =2;

type
   tspell                 =class;
   tgetvaluefromhost32    =function(const n:string):longint32 of object;

{tspell}
   tspell=class(tobjectex)
   private

    iwordlist:tdynamicstring;
    iwordrefs:tdynamicinteger;
    icount,iid:longint;
    ifilename:string;
    idataonly,icansave,imodified:boolean;

    procedure xclearwords;
    function xsettext(const xtext:string):boolean;
    procedure settext(x:string);
    function gettext:string;
    function findempty(var xindex:longint):boolean;

   public

    //create
    constructor create(const xdataonly:boolean;xstoragefilename:string);
    destructor destroy; override;

    //information
    property id                          :longint            read iid;
    property filename                    :string             read ifilename;
    property modified                    :boolean            read imodified;
    property cansave                     :boolean            read icansave;
    property count                       :longint            read icount;
    property dataonly                    :boolean            read idataonly;

    //spelling
    function findword(const x:string):boolean;
    function findword2(const x:string;var xindex:longint):boolean;
    function addword(const x:string):boolean;
    function delword(const x:string):boolean;
    function clear:boolean;

    //io
    function load:boolean;
    function save:boolean;
    function mustsave:boolean;

    //data
    property text                        :string             read gettext        write settext;

    //support
    function setClean(const xtext:string;const xsort:boolean):boolean;//17feb2026

   end;


{ttextcore}
   //.fast access font info
   tfastfont=record

    w1       :longint;
    w2       :longint;
    wlist    :array[0..255] of longint;
    h        :longint;
    h1       :longint;

    end;

   tfastchar=record

    c                :byte;
    cs               :byte;
    wid              :word;//primary array index (txtname/imgdata etc)
    txtid            :word;//secondary array index (fslot/fref)
    width            :longint;
    height           :longint;
    height1          :longint;

    end;

   ptextinfo=^ttextinfo;
   ttextinfo=record

    name              :string;//font name
    size              :longint;//font size
    bold              :boolean;//font style
    italic            :boolean;
    underline         :boolean;
    strikeout         :boolean;
    color             :longint;//text color
    bgcolor           :longint;//background color
    brcolor           :longint;//border color
    align             :byte;//0=left, 1=centre, 2=right
    id                :word;//pointer to "fslot"

    end;

   pimageinfo=^timageinfo;
   timageinfo=record

    orgdata           :tstr8;//original image data stream (JPG, TEH, TEM, BMP etc)
    img32             :tbasicimage;//raw 32bit image data (no header, in-order, continous stream of BGRA pixels) - 25may2025
    trans             :boolean;//transparent (top-left) - 27aug2021
    w                 :longint;
    h                 :longint;
    syscols           :boolean;//25may2025
    systep            :longint;//-1=not used - not saved/stored/live usage only - 25mar2026

    end;

   tmultiundoinfo=record

    enabled           :boolean;
    n                 :array[-1..199] of string;//list of undo files
    nUsed             :array[-1..199] of boolean;//default=false=undo file has not been used -> no need to clean or remove, true=undo file has been used at least once and must be deleted when closing/flushing - 20dec2024
    limit             :longint;//2..200

    //.support
    list              :tstr8;
    d1                :tstr8;
    d2                :tstr8;
    d3                :tstr8;
    style             :longint;
    from1             :longint;//required
    act               :longint;//vital - 03jul2022
    len               :longint;//required

    end;

   ttextio=class(tobject)
   public

    //data streams for TextCore
    data              :tstr8;
    data2             :tstr8;
    data3             :tstr8;

    //temp streams
    tmp1          :tstr8;
    tmp2          :tstr8;
    tmp3          :tstr8;

    //temp vars
    vars       :tfastvars;

    //io data stream
    iostream          :tstr8;//pointer only

    //vars
    full              :boolean;//true=reading data for ENTIRE document, false=only to replace current selection
    wfrom             :longint;//for write
    wto               :longint;//for write
    wsize             :longint;

    //create
    constructor create; virtual;
    destructor destroy; override;

    end;

   ttextcore=class(tobject)
   private

    idataonly         :boolean;//defaults=false=fonts load for GUI, true=fonts don't load and thus no GUI support (but faster for pure data conversion)
    ihostsizing       :boolean;//default=false=host is NOT resizing so it's ok to perform WRAP request, true=host IS resizing so hold off performing WRAP calculations - 22apr2022
    icaneditHTML      :boolean;
    icaneditMD        :boolean;

    //.xtimer vars (for use within "xtimer()" proc
    itmp1             :tstr8;


    //.onefontname/size - 05feb2022
    ionefontname      :string;//default="<nil>", if set to a font name then ALL font names are overridden inclduing any pasted, io'ed, current etc even in dataonly mode -> now supports multiple dynamic fontnames of "$fontname=viFontname/$fontname2=viFontname2/default/default 2/<any valid fontname>" - 05feb2022
    ionefontsize      :longint;//default=-1=off, 0=viFontsize, 1=viFontsize2 OR 2..N=set ALL font sizes to this value
    ionefontREF       :string;//internal use only
    ilastvisyncid     :longint;//13feb2022
    imaxformatlevel   :longint;//0=plaintext, 1=enhanced text, 2=advanced text (default) - 12jun2022

    //font list -> linear graphic font
    fslot             :array[0..textcore_listmax] of tresslot;//resource slot # to tresfont object
    fref              :array[0..textcore_listmax] of string;//simple lookup name for style|size|fontname -> used to autocreate fslot when required - 28feb2026

    //text list
    tlist             :array[0..textcore_listmax] of ttextinfo;//text list
    ilist             :array[0..textcore_listmax] of timageinfo;//image list

    //data streams
    idata             :tstr8;//single byte text stream
    idata2            :tstr8;//1st byte of 16bit dataid stream -> this id points to the text list/image list above
    idata3            :tstr8;//2nd byte of 16bit dataid stream -> 2x single byte streams making mapping/undoing/redoing easier as all values identically match the first "data" text stream

    //multi undo handler - 25jun2022
    iundoinfo         :tmultiundoinfo;

    //support streams -> list every line's x,y,w,h information (in 32bit blocks) and line information - 21aug2019 - individual characters can then be calculated from the start of the line onwards without the overhead of 1:1 character mapping, inline with WordPad's memory overhead
    ilinex            :pdlLONGINT;
    iliney            :pdlLONGINT;
    ilineh            :pdlLONGINT;
    ilineh1           :pdlLONGINT;
    ilinep            :pdlLONGINT;//item pos at start of this line

    //.hard and fast limit of each core, exceeding these limits will cause memory corruption/system failure - 22aug2019
    ilinesize         :longint;
    ilistsize         :longint;

    //.stream cores -> these provide the actual memory in RAM for the array pointers "linex/liney/.../linep" above -> reading/writing to a pointer array is fast and straight forward
    icorelinex        :tstr8;
    icoreliney        :tstr8;
    icorelineh        :tstr8;
    icorelineh1       :tstr8;
    icorelinep        :tstr8;

    //current "font/style" support -> this represent the text cursor's current formatting
    icurrentinfo      :ttextinfo;

    //paint + management
    isyncref          :string;
    icursorpos        :longint;//text cursor position within the "data" stream and thus the "data2" and "data3" streams
    icursorpos2       :longint;//highlight to this position
    ipapersize        :longint;//0=psA4, 1=psA3 etc -> used when wrapstyle=wwsPage - visual handling/painting only at this stage - no print support
    ipaperwidth       :longint;//read only - width of paper for screen purposes
    ipaperheight      :longint;//read only - height of paper for screen purposes
    idpi              :longint;//default=95, widescreen=120
    iwidestline       :longint;//retains the widest line in pixels even when said lines have been removed -> inline with Notepad - 12mar2021
    ipagewidth        :longint;//0=wrap to area
    ipageheight       :longint;//max32=continuous
    ipagecolor        :longint;//color of page background -> default=clnone=>white=rgb(255,255,255)
    ipagecolor2       :longint;//override pagecolor
    ipagefontcolor2   :longint;//override text color (all fonts)
    ipageoverride2    :boolean;//default=false=don't use "pagecolor2" or "pagefontcolor2"
    ipageselcolor     :longint;//selection color -> uses built-in light blue by default
    ipagefontselcolor :longint;
    iviewwidth        :longint;//control view width
    iviewheight       :longint;//control view height
    iviewcolor        :longint;//color of unused area -> default=rgb(152,152,152)
    ivpos             :longint;//control vertical scrollbar position
    ivposPART         :longint;//fine adjustment of vpos -> part line in pixels - 21jun2022
    ivhostsync        :boolean;//true=host must read "vpos/vmax" and sync with host scrollbar
    ivcheck           :longint;//internal use only
    ihpos             :longint;//control horizontal scrollbar position
    ihhostsync        :boolean;//true=host must read "hpos/hmax" and sync with host scrollbar
    ipagecount        :longint;//number of pages (always 1 or more) -> works when "wrapstyle=wwsPage"
    itotalheight      :longint;//height of all lines of text within the confines of pagewidth & pageheight
    ilinecount        :longint;
    iline             :longint;
    icol              :longint;
    iwrapcount        :longint;//indicates HOW FAR the wrap system has progressed (considered complete when wrapcount>=low__len32(x.data))
    idataid           :longint;//track changes to document content AND visual parameters such as width and height -> resets between documents and calls to "clear"
    idataid2          :longint;//this dataid is NEVER reset and is persistent between documents, calls to "clear" etc, but is RESET only on a call to "init" - 14jun2022
    idataid3          :longint;//this dataid is NEVER reset and is persistent between documents, calls to "clear" etc, but is RESET only on a call to "init" AND relates ONLY to content change and NOT control resize/wordwrap status - 25dec2022
    imustpaint        :boolean;
    ipaintlock        :boolean;
    imodified         :boolean;
    itimer100         :comp;//used to internally throttle the "timer" event to a steady 100ms internval cycle MAX
    itimerslow        :comp;
    itimerfont500     :comp;//02feb2022
    iidleref          :comp;
    ik_idleref        :comp;//keyboard idle - 26sep2022
    itimerbusy        :boolean;
    iwrapstack        :tstr8;//stack of wordwrap ranges to process (from(4b)+to(4b)=64bit blocks)
    ikstack           :tstr8;//stack of keyboard inputs
    imstack           :tstr8;//stack of mouse inputs
    ibriefstatus      :string;
    ishortcuts        :boolean;//enable built-in keyboard shortcuts
    istyleshortcuts   :boolean;//enable more keyboard shortcuts for keyboard based text styling such as "bold" and "italic"
    iflashcursor      :boolean;//internally managed
    idrawcursor       :boolean;//internally managed
    icursoronscrn     :boolean;//*
    ilinecursorx      :longint;//internal use only -> used to remember cursor's original X coordinate when scrolling up/down using keyboard keys - 31aug2019
    ihavefocus        :boolean;//set by host
    ishowcursor       :boolean;//set by host
    ireadonly         :boolean;//set by host
    ishift            :boolean;//set internally -> true=shift key is down
    iwasdown          :boolean;//mouse support - internal
    iwasright         :boolean;//mouse support - internal
    ifeather          :longint;//0=sharp edges to text, 1=light feather, 2=heavy feather
    isysfeather       :boolean;//default=true=uses system feather (fills ".feather" with "vifeather" value) - 26aug2020
    ilastscale        :double;

    //was: activecursor  :tcursor;
    //.dic support
    idicref1          :longint;//used by "odic=true"
    idicref2          :longint;//used by "odic=true"
    idicid            :longint;//used by "odic=true"
    idicshow          :boolean;//used by "odic=true"
    idicfrom          :longint;//used by "odic=true"
    idicto            :longint;//used by "odic=true"
    idic_addword      :string;//used by "odic=true" - contains the currently misspelt word - use to add to supplementary dictionary - 11feb2023

    //consts
    ic_smallwrap      :longint;//set once by "init" - progressive wordwrap range
    ic_bigwrap        :longint;//set once by "init"
    ic_pagewrap       :longint;//use to wrap an entire screen of characters -> best guess -> not actual requirement, but a large number to cover even 8k displays
    ic_idlepause      :longint;//time to take before cursor can flash again, default=500ms

    //special - delayed events/vars
    icursorstyle             :char;//"t" = text cursor, "l" = link cursor
    icursor_keyboard_moveto  :longint;
    itimer_chklinecursorx    :boolean;
    isysfontDefault          :string;
    isysfontDefault2         :string;

    //other
    ilandscape        :boolean;//default=false
    iwrapstyle        :longint;//0=wwsNone=no wrap, 1=wwsWindow=to window(viewwidth/height), 2=wwsPage=to page (pagewidth/pageheight), 3=wwsPage+Manuscript Left Margin
    iwrapreadonly     :boolean;//default=false=wrapstyle adjust with "ioset()", true=wrap ONLY changes when specifically called via "low__wordcore(x,'wrap','<new wrapstyle value>') - 12mar2021
    ilastfindalignpos :longint;//default=-1=not set

    //reference
    ibwd_color        :longint;//support for "enhanced text" color support which uses three colors: font color, font color 2 (typically was red)  and highlight color (text background)
    ibwd_color2       :longint;
    ibwd_bk           :longint;

    //special options
    idefCopyformat    :string;//'txt';
    idefFontname      :string;//"arial" - 05sep2020
    idefFontsize      :longint;//"12"
    idefFontcolor     :longint;//"0" = black

    //special actions - 19apr2021
    iviewurl          :boolean;//default=true=click on a url "http://" or "https://" or "ftp://" or "ftps://" or "mailto:" with no active selection and the link is executed via the default system handler (browser / email client) - 19apr2021
    ilinespacing      :longint;//1=normal, 2=double - 04feb2023
    idic              :boolean;//default=false, true=indicate misspelt words and offer dictionary support
    ibackup           :boolean;//default=false, true=write whole document backup copies to disk whenever document changes significantly - 05feb2023
    ibackupname       :string;//default=nil, optional trailing name (extension is always automatically assigned) - 25feb2023
    ifindhandler      :longint;//default=assigned at init

    //events
    fonvaluefromhost  :tgetvaluefromhost32;

    //support -----------------------------------------------------------------
    procedure dic_spell;
    function dic_extractwordfromdoc(xcursorpos:longint;xsplitdash:boolean;var xfrom,xto:longint):string;

    function xkeyboard__fromak(xcode:longint;var xctrl,xalt,xshift,xkeyx:boolean;var xkey:longint;var xhavekey:boolean):boolean;
    function strbyte1x(const x:string;xpos:longint64):byte;//1based always -> backward compatible with D3 - 02may2020
    function bstr(const x:tstr8):string;
    function blen32(x:tstr8):longint;
    function bsetlen(const x:tstr8;const xlen:longint64):boolean;
    function xscale__px1(const xval:double;const xmin:longint):longint;//rounds down - 10dec2025
    function xvifeather:longint;
    function xvisyncid:longint;
    function xviscale:double;
    function xvifontsize:longint;
    function xvifontsize2:longint;
    function xfoundfontname(const xname:string;var xoutname:string):boolean;
    procedure xline__atleast(xnewsize:longint);
    procedure xcurrent__default;//05jul2022
    function xscootable(const x:byte):boolean;
    function xsafeline(var xindex:longint):boolean;
    function xsafelineb(const xindex:longint):longint;
    function xposTOx(xpos:longint;var dx,dx2:longint):boolean;
    function xcursor_offscreenX:longint;
    procedure xlinecursorx(xpos:longint);
    procedure xcursor_bringintoview;
    function xmmTOpixels(const xval:longint):longint;//support viscale - 23jan2026
    function xgreyFeather:boolean;
    function xfindUrl(const xpos1:longint;var xurlpos,xurlpos2:longint):boolean;//03mar2026
    function xvaluefromhost(const n:string;const defVal:longint):longint32;
    function xsyncSysTeps:boolean;

    //.current info
    function getcname:string;
    procedure setcname(x:string);
    function getcsize:longint;
    procedure setcsize(x:longint);
    function getccolor:longint;
    procedure setccolor(x:longint);
    function getcbgcolor:longint;
    procedure setcbgcolor(x:longint);
    function getcbold:boolean;
    procedure setcbold(x:boolean);
    function getcitalic:boolean;
    procedure setcitalic(x:boolean);
    function getcunderline:boolean;
    procedure setcunderline(x:boolean);
    function getcstrikeout:boolean;
    procedure setcstrikeout(x:boolean);
    function getcalign:longint;
    procedure setcalign(x:longint);

    //.pos and line lookups
    function xlen32:longint;
    function xlinebefore(const xpos1:longint):longint;//pos>line-1>pos
    function xpos__toline(const xpos1:longint):longint;//pos>line => expects input of xpos=1..x.data.len
    function xline__topos(const xline0:longint):longint;//xline0 expects input of 0..(x.linecount-1)
    function y__toline(const y:longint):longint;
    function xline__itemcount(const xline0:longint):longint;//line>itemcount => find number of items in line => expects input of lineindex=0..(x.linecount-1)
    function getvmax:longint;
    function getvpos:longint;
    procedure setvpos(x:longint);
    function getvmax_px:longint;
    function getvpos_px:longint;
    procedure setvpos_px(x:longint);
    procedure fFILL(const findex:longint;const xwine_remake:boolean);
    procedure xmincheck2(const d1,d2,d3:tstr8);
    procedure xmincheck;
    procedure xwrap_hvsync_changed;
    procedure xincdata3;//25dec2022
    procedure xwrapnow(xmin,xmax,xlinecount:longint);
    function xwrapfinish(vpos:longint;xpx:boolean):longint;//pass-thru proc
    procedure xwrapall;
    procedure xwrapto(const xpos:longint);
    procedure xwrapadd(const xpos,xpos2:longint);
    function xpagewidth:longint;
    function xpageheight:longint;
    procedure setcursorpos(x:longint);
    procedure setcursorpos2(x:longint);
    procedure setwrapstyle(x:longint);
    procedure setpapersize(x:longint);
    procedure xmust__vhostsync;//tells host it must re-sync vertical scrollbar
    function xy__topos(dx,dy:longint):longint;//find position in data stream from x,y coordinates (relative to current vpos/hpos)
    function gethpos:longint;
    procedure sethpos(x:longint);
    function gethpos2:longint;//only return hpos value if showing the horizontal scrollbar
    function gethmax:longint;
    function xpos__rc(const xpos:longint):longint;//pos>rc => find end of line #10
    function xmakefont2(const xoverride:boolean;xname:string;xsize,xcolor,xbgcolor,xbrcolor:longint;xbold,xitalic,xunderline,xstrikeout:boolean;xalign:byte):longint;
    function xmakefont:longint;
    function xappend(xout:tstr8;const n:string;xval:tstr8):boolean;//fixed - 28jan2021
    function xappendstr(xout:tstr8;const n,v:string):boolean;
    function xappendint4(xout:tstr8;n:string;v:longint):boolean;
    function xpull(var xoutpos:longint;xout:tstr8;var n:string;v:tstr8):boolean;
    function xpullstr(var xoutpos:longint;xout:tstr8;var n,v:string):boolean;
    procedure xnoidle;
    procedure knoidle;
    procedure xsetcursorpos2(xpos:longint;xshift:boolean);
    procedure xsetcursorpos(const xpos:longint);
    function xstackpull(xstack,xval:tstr8):boolean;
    function xwrappull(var xpos,xpos2:longint):boolean;
    function xsafeListItem(const xindex:longint):longint;//13feb2026
    function xfindstyle(const x:byte):byte;//21aug2020
    procedure xdelsel2(const xmoveto:boolean);
    procedure xdelsel;
    function xmakeimage2(const ximgdata:tstr8;const xsysTEP:longint):longint;
    procedure setlinespacing(x:longint);
    procedure setpagecolor(x:longint);
    procedure setpagecolor2(x:longint);
    procedure setpagefontcolor2(x:longint);
    procedure setpageoverride2(x:boolean);
    procedure setpageselcolor(x:longint);
    procedure setpagefontselcolor(x:longint);
    function xautoPageColor:longint;

    procedure setviewcolor(x:longint);
    procedure setviewwidth(x:longint);
    procedure setviewheight(x:longint);

    procedure xcopy(const xall:boolean);
    function xcanpaste:boolean;
    function xpaste(xreplace:boolean):boolean;//22apr2026, 01may2025

    procedure xfontonevals(var xfontname:string;var xfontsize:longint);//04feb2023
    procedure xfilterText(x:tstr8);
    procedure xapplyzoom;
    function xcursorword_loose:string;//boundaries are "<=32", was: "spaces, tabs and return codes only" - 19jun2022
    procedure xmouseup_specialactions;
    procedure xwine_remakefonts;

    function xcanclear(const xstyle:string):boolean;
    procedure xclear(xstyle:string);

    procedure xnil3(var v1,v2,v3:tstr8);
    procedure xmake3(var v1,v2,v3:tstr8);
    procedure xfree3(var v1,v2,v3:tstr8);

    procedure xdelr;
    procedure xdell;
    procedure xmove(const xmoveCode:longint);

    procedure xins(x:tstr8);
    procedure xins2(x:tstr8;const xoverrideReadonly2:boolean);
    procedure xinsimg(const x:tstr8);
    procedure xinsimg2(const x:tstr8;const xsysTEP:longint;const xnoUndo,xforce:boolean);

    procedure xioins__noundo(x:tstr8);
    procedure xioset(x:tstr8);

    //.document readers
    procedure xsetdata(x:tstr8;xformat:string;const xmode:longint);

    procedure xread__bwd(const v:ttextio);
    procedure xread__bwp(const v:ttextio);
    procedure xread__txt(const v:ttextio);//14feb2026
    procedure xread__htm(const v:ttextio);
    procedure xread__md(const v:ttextio);
    procedure xread__pdf(const v:ttextio);
    procedure xread__rtf(const v:ttextio);//basic RTF
    procedure xread__dic(const v:ttextio);//17feb2026

    //.document writers
    function xmakeIOhandler(xfrom,xto:longint;xout:tstr8):ttextio;
    function xgetdata(xout:tstr8;dformat:string;xfrom,xto:longint32):boolean;

    procedure xwrite__txt(const v:ttextio);//28feb2026, 14feb2026
    procedure xwrite__bwd(const v:ttextio);
    procedure xwrite__bwp(const v:ttextio);
    procedure xwrite__htm(const v:ttextio);//14feb2026
    procedure xwrite__htm__basic(const v:ttextio);//16feb2026
    procedure xwrite__md(const v:ttextio);
    procedure xwrite__pdf(const v:ttextio);
    procedure xwrite__rtf(const v:ttextio);//basic RTF
    procedure xwrite__dic(const v:ttextio);//17feb2026

    //.document modifiers
    procedure xmodify__dic(const x:pobject);

    //.undo
    procedure mclear(const xcleanfiles:boolean);//mclear
    function mdok:boolean;
    function mmax:longint;
    function mredoflush:boolean;//true=flushed redo, false=nothing changed
    function mstore12(xuseslot:longint;xstoreRecovered:boolean):boolean;//27sep2022 fixed "no undo in use issue", multi-undo write
    function me(x:tstr8):tstr8;//pass-thru - encode
    function md(x:tstr8):tstr8;//pass-thru - decode
    function mstore1:boolean;//multi-undo write
    function mread1(xslot:longint;xundo:boolean):boolean;//27sep2022 fixed "no undo in use issue"

    function mcopy(sslot,dslot:longint):boolean;
    function mcanundo:boolean;
    function mundo:boolean;

    function mcanredo:boolean;
    function mredo:boolean;
    function getundouse:boolean;
    procedure setundouse(x:boolean);

    //.misc
    function xfindformatlevel:longint;//19jun2022
    procedure setmaxformatlevel(x:longint);
    function xfind(const xtext:string;xcmd:string):boolean;
    procedure xbackup(const xcap:string);
    function xdocsep(i,xdepthcount:longint):boolean;//slow, mainly for dic support - 05feb2023
    function xdocsep2(i,xdepthcount:longint;const xsplitdash:boolean):boolean;//slow, mainly for dic support - 05feb2023
    procedure sethavefocus(x:boolean);
    function xpaintline1:longint;
    function xpaintline2:longint;
    procedure xchanged;

   public
//11111111111111111111111111111111//??????????????????????
    //create
    constructor createDataonly; virtual;
    constructor create(const xdataonly:boolean); virtual;
    destructor destroy; override;

    //information
    property viewurl            :boolean   read iviewurl                 write iviewurl;
    property pageoverride2      :boolean   read ipageoverride2           write setpageoverride2;
    property syscols            :boolean   read ipageoverride2           write setpageoverride2;
    property linespacing        :longint   read ilinespacing             write setlinespacing;
    property data               :tstr8     read idata;
    property data2              :tstr8     read idata2;
    property data3              :tstr8     read idata3;
    property formatlevel        :longint   read xfindformatlevel;//can exceed maxformatlevel
    property maxformatlevel     :longint   read imaxformatlevel          write setmaxformatlevel;
    property readonly           :boolean   read ireadonly                write ireadonly;
    property wrapreadonly       :boolean   read iwrapreadonly            write iwrapreadonly;
    property showcursor         :boolean   read ishowcursor              write ishowcursor;
    property shortcuts          :boolean   read ishortcuts               write ishortcuts;
    property styleshortcuts     :boolean   read istyleshortcuts          write istyleshortcuts;
    property hostsizing         :boolean   read ihostsizing              write ihostsizing;
    property mustpaint          :boolean   read imustpaint               write imustpaint;
    property havefocus          :boolean   read ihavefocus               write sethavefocus;
    function hshow              :boolean;
    property len32              :longint   read xlen32;

    //.optional edit these documents as TXT (source code, set to FALSE)
    property caneditHTML        :boolean   read icaneditHTML             write icaneditHTML;
    property caneditMD          :boolean   read icaneditMD               write icaneditMD;

    //onefontname/size support
    property onefontname        :string    read ionefontname             write ionefontname;
    property onefontsize        :longint   read ionefontsize             write ionefontsize;

    //data ids
    property dataid             :longint   read idataid;
    property dataid2            :longint   read idataid2;
    property dataid3            :longint   read idataid3;

    //options
    property candic             :boolean   read idic                     write idic;
    property dic_addword        :string    read idic_addword             write idic_addword;
    property canbackup          :boolean   read ibackup                  write ibackup;
    property backupname         :string    read ibackupname              write ibackupname;

    //spell
    function canspell:boolean;
    procedure spell;

    //cursor
    property cursorpos          :longint   read icursorpos               write setcursorpos;
    property cursorpos2         :longint   read icursorpos2              write setcursorpos2;

    //.line position
    property vmax               :longint   read getvmax;
    property vpos               :longint   read getvpos                  write setvpos;
    property vpos_px            :longint   read getvpos_px               write setvpos_px;
    property vmax_px            :longint   read getvmax_px;

    property hmax               :longint   read gethmax;
    property hpos               :longint   read gethpos                  write sethpos;
    property hpos2              :longint   read gethpos2;

    property totalheight        :longint   read itotalheight;

    //.selection
    function sel1:longint;
    function sel2:longint;
    function selstart:longint;
    function selcount:longint;
    procedure nosel;

    //.page
    property wrapstyle          :longint   read iwrapstyle               write setwrapstyle;
    property pagewidth          :longint   read ipagewidth;
    property pageheight         :longint   read ipageheight;
    property pagecolor          :longint   read ipagecolor               write setpagecolor;
    property pageSELcolor       :longint   read ipageSELcolor            write setpageSELcolor;
    property pagefontSELcolor   :longint   read ipagefontSELcolor        write setpagefontSELcolor;
    property pagecolor2         :longint   read ipagecolor2              write setpagecolor2;
    property pagefontcolor2     :longint   read ipagefontcolor2          write setpagefontcolor2;

    //.view (viewing area)
    property viewwidth          :longint   read iviewwidth               write setviewwidth;
    property viewheight         :longint   read iviewheight              write setviewheight;
    property viewcolor          :longint   read iviewcolor               write setviewcolor;

    //.paper
    property papersize          :longint   read ipapersize               write setpapersize;
    property paperwidth         :longint   read ipaperwidth;
    property paperheight        :longint   read ipaperheight;

    //.host sync info
    property vhostsync          :boolean   read ivhostsync               write ivhostsync;
    property hhostsync          :boolean   read ihhostsync               write ihhostsync;

    //current info
    procedure cdefault;
    property cname              :string    read getcname                 write setcname;
    property csize              :longint   read getcsize                 write setcsize;
    property ccolor             :longint   read getccolor                write setccolor;
    property cbgcolor           :longint   read getcbgcolor              write setcbgcolor;
    property cbold              :boolean   read getcbold                 write setcbold;
    property citalic            :boolean   read getcitalic               write setcitalic;
    property cunderline         :boolean   read getcunderline            write setcunderline;
    property cstrikeout         :boolean   read getcstrikeout            write setcstrikeout;
    property calign             :longint   read getcalign                write setcalign;


    //.change current selection
    function  ccanmake:boolean;
    procedure cmakename(const xforce:boolean;xfontname:string);
    procedure cmakesize(const xforce:boolean;xfontsize:longint);
    procedure cmakecolor(const xforce:boolean;xcolor:longint);
    procedure cmakebold(const xforce,xval:boolean);
    procedure cmakeitalic(const xforce,xval:boolean);
    procedure cmakeunderline(const xforce,xval:boolean);
    procedure cmakestrikeout(const xforce,xval:boolean);
    procedure cmakenormal(const xforce:boolean);
    procedure cmakehighlight(const xforce:boolean);

    procedure cmakeuppercase(const xforce:boolean);
    procedure cmakelowercase(const xforce:boolean);
    function ccanmakealign:boolean;
    procedure cmakealignment(const xforce:boolean);//cycles through alignment modes
    procedure cmakealign(const xforce:boolean;xval:longint);
    procedure cmakeleft(const xforce:boolean);
    procedure cmakecenter(const xforce:boolean);
    procedure cmakeright(const xforce:boolean);

    procedure cread;
    procedure cwritealign;
    procedure cwritesel__hasUndo(const xselModifierCode:longint);
    procedure cwritesel(const xselModifierCode:longint);
    procedure cwriteall(const xfullStreamModifierCode:longint;xmask:tstr8);//09mar2025, 28aug2021, 05jun2020

    procedure makesmaller;
    procedure makelarger;

    //act
    function canact(x:string):boolean;
    function act(x:string):boolean;

    //clear
    function canclearall        :boolean;
    procedure clearall;

    function canclear           :boolean;
    procedure clear;

    function canclear2          :boolean;
    procedure clear2;

    //select
    function canselectall:boolean;
    procedure selectall;

    //copy
    function cancopy:boolean;
    procedure copy;
    function cancopyall:boolean;
    procedure copyall;

    //delete
    function candeleteall:boolean;
    procedure deleteall;

    //cut
    function cancut:boolean;
    procedure cut;

    //paste
    function canpaste:boolean;
    function paste:boolean;
    function canpastereplace:boolean;
    function pastereplace:boolean;

    //undo
    function canundo            :boolean;
    function undo               :boolean;
    function canredo            :boolean;
    function redo               :boolean;
    property undoUse            :boolean   read getundouse               write setundouse;
    procedure undoClear;

    //find
    property findhandler        :longint   read ifindhandler;

    //io
    procedure iosettxt(x:tstr8);
    procedure iosetrtf(x:tstr8);
    procedure iosetdic(x:tstr8);
    procedure iosetbwd(x:tstr8);
    procedure iosetbwp(x:tstr8);
    procedure iosethtm(x:tstr8);
    procedure iosetdata(x:tstr8);
    procedure iosetdata2(x:tstr8;const xformat:string);

    function iogettxt(x:tstr8):boolean;
    function iogetbwd(x:tstr8):boolean;
    function iogetbwp(x:tstr8):boolean;
    function iogethtm(x:tstr8):boolean;
    function iogetdata(x:tstr8;const xformat:string):boolean;
    function iogetdata2(x:tstr8;const xformat:string;const xfrom,xto:longint):boolean;

    //doc formats supported
    function supportsFormat(const xformat:string):boolean;
    function docExtb(const xindex:longint):string;//16feb2026
    function docExt(const xindex:longint;var xext:string;var xcanwrite:boolean):boolean;//16feb2026
    function docExt2(const xindex:longint;var xext:string;var xcanwrite:boolean;var xmaxformatlevel:longint):boolean;//16feb2026
    function docExtSupported(const xext:string):boolean;
    function docExtSupported2(const xext:string;var xcanwrite:boolean;var xmaxformatlevel:longint):boolean;

    //input and movement
    procedure xtimer;
    procedure keyboard(const xctrl,xalt,xshift,xkeyX:boolean;const xkey:byte);
    procedure keyboard2(const akcode:longint);
    procedure mouse(const xmousex,xmousey:longint;const xmousedown,xmouseright:boolean);
    procedure vwheel(xval:longint);
    procedure vkeypress(const xchar:longint;const xctrl,xalt,xkeyx:boolean);
    function canshortcut(const xkeycode:longint):boolean;//15feb2026
    procedure shortcut(const xkeycode:longint);//15feb2026
    function canpaint:boolean;
    function paintlock(const xlock:boolean):boolean;
    function docchar(i:longint):byte;//slow, mainly for dic support - 05feb2023
    function docsep(const i:longint):boolean;//slow, mainly for dic support - 26feb2023, 05feb2023
    function docsep2(const i:longint;const xsplitdash:boolean):boolean;//slow, mainly for dic support - 26feb2023, 05feb2023

    //page and sel colors
    property defFontname        :string    read idefFontname             write idefFontname;
    property defFontsize        :longint   read idefFontsize             write idefFontsize;
    property defFontcolor       :longint   read idefFontcolor            write idefFontcolor;
    procedure syncdef(const xfontname:string;const xfontsize,xfontcolor,xpagecolor,xpageselcolor,xpagefontselcolor,xviewcolor:longint);

    //render - requires GUI support
    function canrender:boolean;
    function render(xcliparea:twinrect;const xpaintarea:twinrect;const xpower255,xrowcolor,xbackColor:longint32):boolean;//28feb2026

    //support
    procedure transform(const xwebimages,xretainKeyTagsForClaude:boolean;const xhelpTopicList:tdynamicstring);
    procedure transform2(const xwebimages,xretainKeyTagsForClaude:boolean;const xappTitle,xappVersion,xappWebLink:string;const xhelpTopicList:tdynamicstring);

    function wrapbusy:boolean;
    procedure wrapall;
    function wrapdone:boolean;
    function pos__toline(const xpos1:longint):longint;//pos>line => expects input of xpos=1..x.data.len
    function line__topos(const xline0:longint):longint;
    procedure xinstext(const x:string);
    procedure xinstext2(const x:string;const xoverrideReadonly:boolean);
    procedure xioins(x:tstr8);
    procedure xfastcharinit(var xinfo:tfastfont);
    function xfastchar(var xinfo:tfastfont;const xpos,xlinespacing:longint;var xout:tfastchar):boolean;
    function xslowchar(xpos,xlinespacing:longint;var xout:tfastchar):boolean;
    function xfastfindalign(const xpos1:longint):longint;//22apr2022, 28dec2021
    procedure markModified;
    function fontslot(const xindex:longint):longint32;
    function lineHeight(const xpos1:longint32):longint32;

    //.mark content as changed
    procedure contentChangedAll;//26mar2026
    procedure contentChangedFrom(const xselStart:longint);//26mar2026
    procedure contentChangedFromLen(const xselStart,xContentLen:longint);//26mar2026

    //events
    property onvaluefromhost:tgetvaluefromhost32 read fonvaluefromhost write fonvaluefromhost;

   end;


var
   system_started_text    :boolean=false;


   //system dictionary support -------------------------------------------------
   sysdic_main           :tspell=nil;
   sysdic_sup1           :tspell=nil;
   sysdic_sup2           :tspell=nil;
   sysdic_main_use       :boolean=true;
   sysdic_sup1_use       :boolean=true;
   sysdic_sup2_use       :boolean=true;
   sysdic_idref          :longint=0;
   sysdic_id             :longint=-1;


//start-stop procs -------------------------------------------------------------

procedure gosstext__start;
procedure gosstext__stop;


//info procs -------------------------------------------------------------------

function app__info(xname:string):string;
function info__text(xname:string):string;//information specific to this unit of code - 01feb2026


//support procs ----------------------------------------------------------------

function font__safesize(const xsize:longint):longint;
function html__char(const xindex:longint;xlastWasSpace:boolean):string;

function textcore__docExtSupported(const xext:string):boolean;
function textcore__docExtSupported2(const xext:string;var xcanwrite:boolean;var xmaxformatlevel:longint):boolean;

function textcore__docExt(const xindex:longint;var xext:string;var xcanwrite:boolean):boolean;//16feb2026
function textcore__docExt2(const xindex:longint;var xext:string;var xcanwrite:boolean;var xmaxformatlevel:longint):boolean;//16feb2026
function textcore__docExtb(const xindex:longint):string;//16feb2026

function textcore__2to1(s1,s2,d:tstr8;dformat,dsep:string):boolean;//17dec2024: document combiner -> combine 2 documents into 1
function textcore__3to1(s1,s2,s3,d:tstr8;dformat,dsep,dsep2:string):boolean;//17dec2024: document combiner -> combine 3 documents into 1


//system dictionary support - 04feb2023 ----------------------------------------
procedure dic__shut;
procedure dic__init;
procedure dic__newid;
function dic__id:longint;
function dic__inuse:boolean;
procedure dic__reload(xdicindex:longint);
procedure dic__edit(xdicindex:longint);
function dic__wordcount(xdicindex:longint):longint;
function dic__misspelt(x:string):boolean;
function dic__findword(x:string):boolean;
function dic__findword2(x:string;var xdicindex,xindex:longint):boolean;
function dic__addword(x:string;xdicindex:longint):boolean;


implementation

uses gossteps {$ifdef gui} ,gossgui{$endif};


//start-stop procs -------------------------------------------------------------
procedure gosstext__start;
begin
try

//check
if system_started_text then exit else system_started_text:=true;


//init

except;end;
end;

procedure gosstext__stop;
begin
try

//check
if not system_started_text then exit else system_started_text:=false;

//close dictionaries
dic__shut;//17feb2026, 04feb2023

except;end;
end;


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__text(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gosstext.*"
if (strcopy1(xname,1,9)='gosstext.') then strdel1(xname,1,9) else exit;

//get
if      (xname='ver')        then result:='4.00.7544'
else if (xname='date')       then result:='22apr2026'
else if (xname='name')       then result:='Text'
else
   begin
   //nil
   end;

except;end;
end;


//support procs ----------------------------------------------------------------

function font__safesize(const xsize:longint):longint;
begin

if      (xsize<textcore_minfontsize)    then result:=textcore_minfontsize
else if (xsize>textcore_maxfontsize)    then result:=textcore_maxfontsize
else                                         result:=xsize;

end;

function html__char(const xindex:longint;xlastWasSpace:boolean):string;

 procedure s(const x:string);
 begin
 result:=x;
 end;

begin

//check
if (xindex<0) or (xindex>255) then
   begin

   result:='';
   exit;

   end;

//get
case xindex of
9:s('&#9;');//**
32:if xlastWasSpace then s('&nbsp;') else s(#32);
34:s('&quot;');
38:s('&amp;');
39:s('&#39;');//**
60:s('&lt;');
62:s('&gt;');
128:s('&euro;');
129:s('&#129;');
130:s('&sbquo;');
131:s('&fnof;');
132:s('&bdquo;');
133:s('&hellip;');
134:s('&dagger;');
135:s('&Dagger;');
136:s('&circ;');
137:s('&permil;');
138:s('&Scaron;');
139:s('&lsaquo;');
140:s('&OElig;');
141:s('&#141;');
143:s('&#143;');
144:s('&#144;');
145:s('&lsquo;');
146:s('&rsquo;');
147:s('&ldquo;');
148:s('&rdquo;');
149:s('&bull;');
150:s('&ndash;');
151:s('&mdash;');
152:s('&tilde;');
153:s('&trade;');
154:s('&scaron;');
155:s('&rsaquo;');
156:s('&oelig;');
157:s('&#157;');
159:s('&Yuml;');
160:s('&nbsp;');
161:s('&iexcl;');
162:s('&cent;');
163:s('&pound;');
164:s('&curren;');
165:s('&yen;');
166:s('&brvbar;');
167:s('&sect;');
168:s('&uml;');
169:s('&copy;');
170:s('&ordf;');
171:s('&laquo;');
172:s('&not;');
173:s('&shy;');
174:s('&reg;');
175:s('&macr;');
176:s('&deg;');
177:s('&plusmn;');
178:s('&sup2;');
179:s('&sup3;');
180:s('&acute;');
181:s('&micro;');
182:s('&para;');
183:s('&middot;');
184:s('&cedil;');
185:s('&sup1;');
186:s('&ordm;');
187:s('&raquo;');
188:s('&frac14;');
189:s('&frac12;');
190:s('&frac34;');
191:s('&iquest;');
192:s('&Agrave;');
193:s('&Aacute;');
194:s('&Acirc;');
195:s('&Atilde;');
196:s('&Auml;');
197:s('&Aring;');
198:s('&AElig;');
199:s('&Ccedil;');
200:s('&Egrave;');
201:s('&Eacute;');
202:s('&Ecirc;');
203:s('&Euml;');
204:s('&Igrave;');
205:s('&Iacute;');
206:s('&Icirc;');
207:s('&Iuml;');
208:s('&ETH;');
209:s('&Ntilde;');
210:s('&Ograve;');
211:s('&Oacute;');
212:s('&Ocirc;');
213:s('&Otilde;');
214:s('&Ouml;');
215:s('&times;');
216:s('&Oslash;');
217:s('&Ugrave;');
218:s('&Uacute;');
219:s('&Ucirc;');
220:s('&Uuml;');
221:s('&Yacute;');
222:s('&THORN;');
223:s('&szlig;');
224:s('&agrave;');
225:s('&aacute;');
226:s('&acirc;');
227:s('&atilde;');
228:s('&auml;');
229:s('&aring;');
230:s('&aelig;');
231:s('&ccedil;');
232:s('&egrave;');
233:s('&eacute;');
234:s('&ecirc;');
235:s('&euml;');
236:s('&igrave;');
237:s('&iacute;');
238:s('&icirc;');
239:s('&iuml;');
240:s('&eth;');
241:s('&ntilde;');
242:s('&ograve;');
243:s('&oacute;');
244:s('&ocirc;');
245:s('&otilde;');
246:s('&ouml;');
247:s('&divide;');
248:s('&oslash;');
249:s('&ugrave;');
250:s('&uacute;');
251:s('&ucirc;');
252:s('&uuml;');
253:s('&yacute;');
254:s('&thorn;');
255:s('&yuml;');
else s( char(xindex) );
end;//case

end;

function textcore__2to1(s1,s2,d:tstr8;dformat,dsep:string):boolean;//17dec2024: document combiner -> combine 2 documents into 1
begin
result:=textcore__3to1(s1,s2,nil,d,dformat,dsep,'');
end;

function textcore__3to1(s1,s2,s3,d:tstr8;dformat,dsep,dsep2:string):boolean;//17dec2024: document combiner -> combine 3 documents into 1
label//dformat: txt, bwd or bwp | if nil then "bwp" assumed
     //dsep: optional separation text between s1 and s2 document content
   skipend;
var
   a:tstr8;
   b:ttextcore;
   int1:longint;
begin

//defaults
result      :=false;
a           :=nil;
b           :=nil;

try

//check
int1        :=0;

if str__lock(@s1) then inc(int1);
if str__lock(@s2) then inc(int1);
if str__lock(@s3) then inc(int1);

if not str__lock(@d)           then goto skipend;
if (int1<=0)                   then goto skipend;
if (s1=d) or (s2=d) or (s3=d)  then goto skipend;

//init
b           :=ttextcore.createDataonly;
d.clear;
a           :=str__new8;

//decide
dformat     :=strlow(dformat);
if not b.supportsFormat(dformat) then dformat:='bwp';

//s1
if (str__len32(@s1)>=2) then
   begin
   a.clear;
   a.add(s1);
   if (io__anyformatb(@a)='ZIP') then low__decompress(@a);//zip support

   b.cursorpos:=b.len32;
   b.xioins__noundo(a);

   end;

//s2
if (str__len32(@s2)>=2) then
   begin

   //s1+s2 separator "dsep"
   if (b.len32>=2) and (dsep<>'') then b.xioins__noundo( bcopystrall(dsep) );

   //add
   a.clear;
   a.add(s2);

   if (io__anyformatb(@a)='ZIP') then low__decompress(@a);//zip support - 08jan2022

   b.cursorpos:=b.len32;
   b.xioins__noundo( a );

   end;

//s3
if (str__len32(@s3)>=2) then
   begin

   //s2+s3 separator "dsep2"
   if (b.len32>=2) and (dsep2<>'') then b.xioins__noundo( bcopystrall(dsep2) );

   //add
   a.clear;
   a.add(s3);

   if (io__anyformatb(@a)='ZIP') then low__decompress(@a);//zip support - 08jan2022

   b.cursorpos:=b.len32;
   b.xioins__noundo( a );

   end;

//.output combined help in requested format ------------------------------------
a.clear;
b.iogetdata(d,dformat);

//successful
result:=true;
skipend:
except;end;

//free
str__free(@a);
str__free(@b);
str__uaf2(@s1,@s2);
str__uaf2(@s3,@d);

end;

function textcore__docExtSupported(const xext:string):boolean;
var
   bol1:boolean;
   int1:longint;
begin
result:=textcore__docExtSupported2(xext,bol1,int1);
end;

function textcore__docExtSupported2(const xext:string;var xcanwrite:boolean;var xmaxformatlevel:longint):boolean;
var
   int1,p:longint;
   str1:string;
   bol1:boolean;
begin

//defaults
result                :=false;
xcanwrite             :=false;
xmaxformatlevel       :=fmlTXT;

//scan
for p:=0 to max32 do
begin

case textcore__docExt2(p,str1,bol1,int1) of
true:begin

   if strmatch(str1,xext) then
      begin

      result          :=true;
      xcanwrite       :=bol1;
      xmaxformatlevel :=int1;
      break;

      end;

   end;
else break;
end;//case

end;//p

end;

function textcore__docExt(const xindex:longint;var xext:string;var xcanwrite:boolean):boolean;//16feb2026
var
   int1:longint;
begin
result:=textcore__docExt2(xindex,xext,xcanwrite,int1);
end;

function textcore__docExt2(const xindex:longint;var xext:string;var xcanwrite:boolean;var xmaxformatlevel:longint):boolean;//16feb2026
var
   xpos:longint;

   function xcan:boolean;
   begin

   result:=(xpos=xindex);
   inc(xpos);

   end;

   procedure a(const v:string;const vwrite:boolean;const vformatlevel:longint);
   begin

   result             :=true;
   xext               :=strlow(v);
   xcanwrite          :=vwrite;
   xmaxformatlevel    :=vformatlevel;

   end;

begin

//defaults
result          :=false;
xext            :='';
xcanwrite       :=false;
xpos            :=0;
xmaxformatlevel :=fmlTXT;

//search
if xcan then a(febwd  ,true, fmlBWD );
if xcan then a(febwp  ,true, fmlBWP );;
if xcan then a(fedic  ,true, fmlTXT );//17feb2026
if xcan then a(fehtm  ,true, fmlBWP );
if xcan then a(fehtml ,true, fmlBWP );
if xcan then a(fertf  ,true, fmlBWP );
if xcan then a(fetxt  ,true, fmlTXT );

end;

function textcore__docExtb(const xindex:longint):string;//16feb2026
var
   bol1:boolean;
begin
textcore__docExt(xindex,result,bol1);
end;

procedure dic__shut;
begin
try
//save
if (sysdic_main<>nil) and sysdic_main.mustsave then sysdic_main.save;
if (sysdic_sup1<>nil) and sysdic_sup1.mustsave then sysdic_sup1.save;
if (sysdic_sup2<>nil) and sysdic_sup2.mustsave then sysdic_sup2.save;
//free
freeobj(@sysdic_main);
freeobj(@sysdic_sup1);
freeobj(@sysdic_sup2);
except;end;
end;

procedure dic__init;
begin
try

if (sysdic_main=nil) then
   begin
   sysdic_main:=tspell.create(false,io__settingsfolder+'main.dic');
   dic__newid;
   end;

if (sysdic_sup1=nil) then
   begin
   sysdic_sup1:=tspell.create(false,io__settingsfolder+'sup1.dic');
   dic__newid;
   end;

if (sysdic_sup2=nil) then
   begin
   sysdic_sup2:=tspell.create(false,io__settingsfolder+'sup2.dic');
   dic__newid;
   end;

except;end;
end;

procedure dic__newid;
begin
low__iroll(sysdic_id,1);
end;

function dic__id:longint;
var
   int1:longint;
begin
//get
result:=sysdic_id;

try
//check for changes in dic usage
int1:=0;
if sysdic_main_use then inc(int1,2);
if sysdic_sup1_use then inc(int1,4);
if sysdic_sup2_use then inc(int1,8);
if low__setint(sysdic_idref,int1) then
   begin
   dic__newid;
   result:=sysdic_id;
   end;
except;end;
end;

function dic__inuse:boolean;
begin
result:=(sysdic_main<>nil) or (sysdic_sup1<>nil) or (sysdic_sup2<>nil);
end;

procedure dic__reload(xdicindex:longint);
begin

if ((xdicindex<0) or (xdicindex=0)) and (sysdic_main<>nil) then sysdic_main.load;
if ((xdicindex<0) or (xdicindex=1)) and (sysdic_sup1<>nil) then sysdic_sup1.load;
if ((xdicindex<0) or (xdicindex=2)) and (sysdic_sup2<>nil) then sysdic_sup2.load;

dic__newid;

end;

procedure dic__edit(xdicindex:longint);
var
   a:tspell;
   xdata:string;
begin
try

//defaults
a:=nil;

//init
dic__init;

//decide
case xdicindex of
0:a:=sysdic_main;
1:a:=sysdic_sup1;
2:a:=sysdic_sup2;
end;//case

//get
if (a<>nil) then
   begin

   if a.mustsave then a.save;

   xdata:=a.text;

   {$ifdef gui}
   if pop_txt2(xdata,0,false,'Dictionary Words','Add and/or delete words are required.  One word per line.') then
      begin

      a.text:=xdata;
      a.save;
      dic__newid;

      end;
   {$endif}

   end;

except;end;
end;

function dic__wordcount(xdicindex:longint):longint;
begin

//defaults
result:=0;
dic__init;

//get
if ((xdicindex<0) or (xdicindex=0)) and (sysdic_main<>nil) then inc(result,sysdic_main.count);
if ((xdicindex<0) or (xdicindex=1)) and (sysdic_sup1<>nil) then inc(result,sysdic_sup1.count);
if ((xdicindex<0) or (xdicindex=2)) and (sysdic_sup2<>nil) then inc(result,sysdic_sup2.count);

end;

function dic__misspelt(x:string):boolean;

   function xcanfind:boolean;
   var
      p,int1,int2,xlen:longint;
      str1,str2:string;
      bol1:boolean;
   begin
   //defaults
   result:=true;
   //init
   xlen:=low__len32(x);
   //get
   if (x='')                          then result:=false
   else if strmatch(x,'https') or strmatch(x,'http') or strmatch(x,'ftps') or strmatch(x,'ftp') or strmatch(x,'mailto') then result:=false
   else if (intstr32(strint32(x))=x)    then result:=false;

   //1st, 2nd, 3rd and (n)th
   if result and (xlen>=3) then
      begin
      str2:=strlow(strcopy1(x,low__len32(x)-1,2));
      if (str2='st') or (str2='nd') or (str2='rd') or (str2='th') then
         begin
         str1:=strcopy1(x,1,low__len32(x)-2);
         int1:=strint32(str1);
         if (int1<>0) and (intstr32(int1)=str1) then
            begin
            int2:=int1-((int1 div 10)*10);
            if (int1>=4) and (int1<=20) then result:=not (str2='th')
            else
               begin
               case int2 of
               -1,1:result:=not (str2='st');
               -2,2:result:=not (str2='nd');
               -3,3:result:=not (str2='rd');
               else result:=not (str2='th');
               end;//case
               end;//if
            end;
         end;
      end;

   //a pure number  (0-9) - 11feb2023
   if result and (xlen>=1) then
      begin
      //get
      bol1:=true;
      for p:=1 to low__len32(x) do
      begin
      case strbyte1(x,p) of
      nn0..nn9:;
      else
         begin
         bol1:=false;
         break;
         end;
      end;//case
      end;//p
      //set
      if bol1 then result:=false;
      end;
   end;
begin

if xcanfind then result:=not dic__findword(x) else result:=false;

end;

function dic__findword(x:string):boolean;
var
   int1,int2:longint;
begin

result:=dic__findword2(x,int1,int2);

end;

function dic__findword2(x:string;var xdicindex,xindex:longint):boolean;
begin

//defaults
result:=false;

try

xdicindex:=0;
xindex:=0;
dic__init;

//filter
if strmatch(strcopy1(x,low__len32(x)-1,2),'''s') then x:=strcopy1(x,1,low__len32(x)-2);//strip trailing "'s" from words - 05feb2023

//get
if (not result) and sysdic_main_use and (sysdic_main<>nil) and sysdic_main.findword2(x,xindex) then
   begin

   result:=true;
   xdicindex:=0;

   end;
if (not result) and sysdic_sup1_use and (sysdic_sup1<>nil) and sysdic_sup1.findword2(x,xindex) then
   begin

   result:=true;
   xdicindex:=1;

   end;
if (not result) and sysdic_sup2_use and (sysdic_sup2<>nil) and sysdic_sup2.findword2(x,xindex) then
   begin

   result:=true;
   xdicindex:=2;

   end;

except;end;
end;

function dic__addword(x:string;xdicindex:longint):boolean;
begin

//defaults
result:=false;

try

dic__init;

//get
case frcrange32(xdicindex,0,2) of
0:if (sysdic_main<>nil) then result:=sysdic_main.addword(x);
1:if (sysdic_sup1<>nil) then result:=sysdic_sup1.addword(x);
2:if (sysdic_sup2<>nil) then result:=sysdic_sup2.addword(x);
end;//case

//set
if result then dic__newid;

except;end;
end;


//## tspell ####################################################################
constructor tspell.create(const xdataonly:boolean;xstoragefilename:string);
begin

//self
if classnameis('tspell') then track__inc(satSpell,1);
inherited create;

//range
if (xstoragefilename='') then xstoragefilename:=io__settingsfolder+'main.dic';

//vars
idataonly   :=xdataonly;//true=disables load/save functions, false=acts as an integrated dictionary using "main.dic" by default - 17feb2026
iid         :=0;
ifilename   :=xstoragefilename;
imodified   :=false;
icansave    :=false;

//controls
iwordlist   :=tdynamicstring.create;
iwordrefs   :=tdynamicinteger.create;

//defaults
load;

end;

destructor tspell.destroy;
begin
try

//controls
freeobj(@iwordlist);
freeobj(@iwordrefs);

//self
inherited destroy;
if classnameis('tspell') then track__inc(satSpell,-1);

except;end;
end;

function tspell.clear:boolean;
begin

result      :=true;
low__iroll(iid,1);
imodified   :=true;
xclearwords;

end;

procedure tspell.xclearwords;
var//Note: Don't shrink list for maximum stability
   p:longint;
begin
try

for p:=0 to (count-1) do
begin

iwordlist.items[p]^   :='';
iwordrefs.items[p]    :=0;

end;//p

icount:=0;

except;end;
end;

function tspell.xsettext(const xtext:string):boolean;
label
   skipdone,skipend;
var
   a:tdynamicstring;
   p,dcount,acount:longint;
begin

//defaults
result      :=false;
a           :=nil;
dcount      :=0;

try

//clear
xclearwords;

//init
a           :=tdynamicstring.create;
a.text      :=xtext;
acount      :=a.count;

iwordlist.atleast(acount);
iwordrefs.atleast(acount);

//check
if (acount<=0) then goto skipdone;

//get
for p:=0 to (acount-1) do
begin

if (a.items[p]^<>'') then
   begin

   iwordlist.items[dcount]^     :=a.items[p]^;
   iwordrefs.items[dcount]      :=low__ref32u(a.items[p]^);
   inc(dcount);

   end;

end;//p

//successful
skipdone:

result      :=true;

skipend:
except;end;

//finalise
icount      :=dcount;

//free
freeobj(@a);

end;

procedure tspell.settext(x:string);
begin

xsettext(x);
imodified:=true;
low__iroll(iid,1);

end;

function tspell.gettext:string;
var
   a:tstr8;
   p,acount:longint;
begin

//defaults
result      :='';
a           :=nil;

try

//init
acount      :=icount;

//get
a           :=str__new8;

for p:=0 to (acount-1) do if (iwordrefs.items[p]<>0) then a.sadd(iwordlist.items[p]^+rcode);

//set
result      :=a.text;

except;end;

//free
str__free(@a);

end;

function tspell.setClean(const xtext:string;const xsort:boolean):boolean;//17feb2026
label
   skipdone,skipend;
var
   a,b:tdynamicstring;
   f:array[0..26] of tdynamicnamelist;
   p:longint;
   v:string;

   function xnewword:boolean;
   var
      c:byte;
   begin

   c:=byte( v[stroffset] );

   case c of
   uuA..uuZ   :result:=f[c-uuA].addonce(v);
   llA..llZ   :result:=f[c-llA].addonce(v);
   else        result:=f[26].addonce(v);
   end;//case

   end;


begin

//defaults
result      :=false;
a           :=nil;
b           :=nil;
low__cls(@f,0);

try

//clear
xclearwords;

//init
a           :=tdynamicstring.create;
b           :=tdynamicstring.create;
a.text      :=xtext;

//check
if (a.count<=0) then goto skipdone;

//.f
for p:=0 to high(f) do f[p]:=tdynamicnamelist.create;

//get
for p:=0 to (a.count-1) do
begin

if (a.items[p]^<>'') then
   begin

   v:=stripwhitespace_lt(a.items[p]^);

   if (v<>'') and xnewword then b.value[b.count]:=v;

   end;

end;

//reduce ram
a.clear;

//sort
if xsort then b.sort(true);

//add words
iwordlist.atleast(b.count);
iwordrefs.atleast(b.count);

for p:=0 to (b.count-1) do
begin

v:=b.svalue[p];

if (v<>'') then
   begin

   iwordlist.items[icount]^     :=v;
   iwordrefs.items[icount]      :=low__ref32u(v);
   inc(icount);

   end;

end;//p

//successful
skipdone:

result      :=true;

skipend:

except;end;

//free
freeobj(@a);
freeobj(@b);
for p:=0 to high(f) do freeobj(@f[p]);

end;

function tspell.load:boolean;
label
   skipend;
var
   xdata:tstr8;
   e:string;
begin

//defaults
result      :=false;
xdata       :=nil;

//check
if idataonly then exit;

try

//check
if not io__fileexists(ifilename) then
   begin

   icansave :=true;
   result   :=true;
   exit;

   end;

//load
xdata       :=str__new8;

if not io__fromfile(ifilename,@xdata,e) then goto skipend;

//get
icansave    :=true;

xsettext(xdata.text);

imodified   :=false;

low__iroll(iid,1);

//successful
result      :=true;

skipend:
except;end;

//free
str__free(@xdata);

end;

function tspell.save:boolean;
label
   skipend;
var
   xdata:tstr8;
   e:string;
begin

//defaults
result      :=false;
xdata       :=nil;

//check
if idataonly    then exit;
if not icansave then exit;

try

//get
xdata       :=str__new8;
xdata.text:=text;

//save
if not io__tofile(ifilename,@xdata,e) then goto skipend;
imodified   :=false;

//successful
result      :=true;

skipend:
except;end;

//free
str__free(@xdata);

end;

function tspell.mustsave:boolean;
begin
result:=icansave and imodified and (not idataonly);
end;

function tspell.findword(const x:string):boolean;
var
   int1:longint;
begin
result:=findword2(x,int1);
end;

function tspell.findword2(const x:string;var xindex:longint):boolean;
var
   xref,xcount,p:longint;
begin

//defaults
result      :=false;
xindex      :=0;

//check
if (icount<=0) or (x='') then exit;

//get
xref        :=low__ref32u(x);
xcount      :=icount;

for p:=0 to (xcount-1) do
begin

if (iwordrefs.items[p]=xref) and strmatch(x,iwordlist.items[p]^) then
   begin

   xindex   :=p;
   result   :=true;
   break;

   end;

end;//p

end;

function tspell.findempty(var xindex:longint):boolean;
var
   xcount,p:longint;
begin

//defaults
result      :=false;
xindex      :=0;
xcount      :=iwordlist.count;

//check
if (xcount<=0) then exit;

//get
for p:=0 to (xcount-1) do
begin

if (iwordrefs.items[p]=0) then
   begin

   xindex   :=p;
   result   :=true;
   break;

   end;

end;//p

end;

function tspell.addword(const x:string):boolean;
var
   i:longint;
begin

//defaults
result      :=false;

//check
if (x='') then exit;

//is it an existing word, if so -> ignore
if findword(x) then
   begin

   result   :=true;
   exit;

   end;

//use first empty slot
if findempty(i) then
   begin

   iwordlist.items[i]^    :=x;
   iwordrefs.items[i]     :=low__ref32u(x);
   result                 :=true;

   exit;

   end;

//add new slot
i                         :=iwordlist.count+500;

iwordlist.atleast(i);
iwordrefs.atleast(i);

i                         :=icount;

iwordlist.items[i]^       :=x;
iwordrefs.items[i]        :=low__ref32u(x);
inc(icount);

low__iroll(iid,1);

imodified                 :=true;
result                    :=true;

end;

function tspell.delword(const x:string):boolean;
label
   redo;
var
   i:longint;
   bol1:boolean;
begin

//defaults
result      :=true;
bol1        :=false;

//get
redo:

if findword2(x,i) then//remove all duplicate instances of word "x"
   begin

   iwordlist.items[i]^    :='';
   iwordrefs.items[i]     :=0;
   bol1                   :=true;

   goto redo;

   end;

//set
if bol1 then
   begin

   low__iroll(iid,1);
   imodified              :=true;

   end;

end;


//## ttextio ###################################################################
constructor ttextio.create;
begin

//self
inherited create;

//controls
data        :=rescache__newStr8;
data2       :=rescache__newStr8;
data3       :=rescache__newStr8;

tmp1        :=rescache__newStr8;
tmp2        :=rescache__newStr8;
tmp3        :=rescache__newStr8;

vars        :=tfastvars.create;

iostream    :=nil;
full        :=false;

end;

destructor ttextio.destroy;
begin
try

//controls
rescache__delStr8(@data);
rescache__delStr8(@data2);
rescache__delStr8(@data3);

rescache__delStr8(@tmp1);
rescache__delStr8(@tmp2);
rescache__delStr8(@tmp3);

freeobj(@vars);

iostream:=nil;

//self
inherited destroy;

except;end;
end;


//## ttextcore #################################################################

constructor ttextcore.createDataonly;
begin
create(true);
end;

constructor ttextcore.create(const xdataonly:boolean);
var
   p:longint;
begin

//self
inherited create;

//vars

ihostsizing               :=false;//22apr2022
imaxformatlevel           :=fmlBWP;//supports 0=TXT, 1=BWD and 2=BWP - 12jun2022
ilastvisyncid             :=xvisyncid;//13feb2022
ionefontname              :='';//off - 05feb2022
ionefontsize              :=-1;//off  - 05feb2022
isysfontDefault           :=font__realname(font_name1);//do this FIRST  before anything critical - 02feb2022
isysfontDefault2          :=font__realname(font_name2);//do this FIRST  before anything critical - 02feb2022
icaneditHTML              :=true;
icaneditMD                :=true;

//xtimer() vars
itmp1                     :=str__new8;

//special delayed events/vars
icursor_keyboard_moveto   :=0;
itimer_chklinecursorx     :=false;

//constant values
ic_bigwrap                :=300*1000;//300K item blocks
ic_smallwrap              :=10000;//10K item blocks
ic_pagewrap               :=100000;//for entire page (best guess), may not be adequate for large screens - 17mar2025: was 10K now 100K, 26aug2019
ic_idlepause              :=500;//500ms

//other
ilastfindalignpos         :=-1;
ilandscape                :=false;
iwrapstyle                :=wwsWindow;//wrap to window - 12mar2021 (was wwsPage)
iwrapreadonly             :=false;//12mar2021

//.paper support - 12mar2021
ipapersize                :=psA4;
ipaperwidth               :=210;
ipaperheight              :=297;
idpi                      :=95;//default=95, widescreen=120
iwidestline               :=0;//used only in "wrapstyle=wwsNone" mode - 12mar2021

//multi-undo support - 25jun2022 -----------------------------------------------
with iundoinfo do
begin

enabled                   :=false;
limit                     :=200;//03jul2022
style                     :=musNone;//02jul2022
list                      :=nil;
d1                        :=nil;
d2                        :=nil;
d3                        :=nil;

for p:=low(n) to high(n) do
begin

n[p]                      :='';//stores only the NAME part and path is assumed to be local temp folder - 26jun2022
nUsed[p]                  :=false;

end;//p

end;//with

mclear(false);


//system
idataonly                 :=xdataonly;//07dec2019
itimer100                 :=slowms64;
itimerslow                :=itimer100;
itimerfont500             :=itimer100;
iidleref                  :=add64(slowms64,ic_idlepause);
ik_idleref                :=iidleref;
itimerbusy                :=false;
iwrapstack                :=str__new8;
ikstack                   :=str__new8;
imstack                   :=str__new8;
ibriefstatus              :='';
ishortcuts                :=true;
istyleshortcuts           :=true;
iflashcursor              :=false;
idrawcursor               :=true;
ishowcursor               :=true;
icursoronscrn             :=false;
ilinecursorx              :=0;
ihavefocus                :=true;
ireadonly                 :=false;
ishift                    :=false;
iwasdown                  :=false;
iwasright                 :=false;
ifeather                  :=0;//off
isysfeather               :=true;//26aug2020
ilastscale                :=xviscale;

//.buffer support -> used for screen painting
ivpos                     :=0;
ivposPART                 :=0;//21jun2022
ivhostsync                :=false;
ivcheck                   :=0;
ihpos                     :=0;
ihhostsync                :=false;

//get
for p:=0 to textcore_listmax do
begin

//font list
fslot[p]                  :=res_nil;
fref[p]                   :='';

//text list
with tlist[p] do
begin

name                      :='';
size                      :=0;
bold                      :=false;
italic                    :=false;
underline                 :=false;
strikeout                 :=false;
color                     :=0;
bgcolor                   :=clnone;//off
brcolor                   :=clnone;//off
align                     :=wcaLeft;
id                        :=0;//set to default

end;//list

//image list
with ilist[p] do
begin

orgdata                   :=nil;//creates "tstr8" when required
img32                     :=nil;//** as above
w                         :=1;
h                         :=1;
syscols                   :=false;//25may2025
sysTEP                    :=-1;//not in use - 25mar2026


end;//list

end;//p

//data streams
idata                     :=str__new8;
idata2                    :=str__new8;
idata3                    :=str__new8;

idata.addbyt1(10);
idata2.addbyt1(0);
idata3.addbyt1(0);

//support streams
ilinesize                 :=0;
ilistsize                 :=0;
icorelinex                :=str__new8;
icoreliney                :=str__new8;
icorelineh                :=str__new8;
icorelineh1               :=str__new8;
icorelinep                :=str__new8;

//.size -> ready for use
xline__atleast(1000);

//special options - 06oct2020
idefCopyformat            :='multi';//was: 'txt';
idefFontname              :=font__name1;
idefFontsize              :=xscale__px1(12,7);//05sep2025
idefFontcolor             :=0;

//current default
xcurrent__default;//05jul2022

//paint
isyncref                  :='';
icursorpos                :=1;
icursorpos2               :=1;
ipagewidth                :=800;
ipageheight               :=max32;//continuous
ipagecolor                :=int_255_255_255;
ipagecolor2               :=rgba0__int(240,240,240);
ipagefontcolor2           :=rgba0__int(0,0,0);
ipageoverride2            :=false;//enacts "pagecolor2" and "pagefontcolor2"
ipageselcolor             :=rgba0__int(136,195,255);//text.background highlight
ipagefontselcolor         :=rgba0__int(0,0,160);//text.font highlight
iviewwidth                :=800;
iviewheight               :=600;
iviewcolor                :=rgba0__int(152,152,152);
ipagecount                :=1;
itotalheight              :=0;
ilinecount                :=0;
iline                     :=0;
icol                      :=0;
iwrapcount                :=0;
idataid                   :=0;
idataid2                  :=0;//only time this dataid is ever reset by the control - this is a PERSISTEN dataid handler - 14jun2022
idataid3                  :=0;
imodified                 :=false;
imustpaint                :=true;
ipaintlock                :=false;
icursorstyle              :='t';//text cursor

//.reference
ibwd_color                :=clnone;
ibwd_color2               :=clnone;
ibwd_bk                   :=clnone;

//.special actions - 19apr2021
iviewurl                  :=true;
ilinespacing              :=1;//04feb2023

//.dic support
idic                      :=false;//04feb2023
idicref1                  :=-2;
idicref2                  :=-2;
idicid                    :=-2;
idicshow                  :=false;
idicfrom                  :=0;
idicto                    :=0;

//.backup support
ibackup                   :=false;//05feb2023
ibackupname               :='';//25feb2023

//.find support
{$ifdef gui}
ifindhandler              :=low__newid1;//18feb2023
{$else}
ifindhandler              :=0;
{$endif}

//.events
fonvaluefromhost          :=nil;


//finish -----------------------------------------------------------------------

end;

destructor ttextcore.destroy;
var
   p:longint;
begin
try

//disconnect
fonvaluefromhost          :=nil;

//controls

//.core data streams
str__free(@idata);
str__free(@idata2);
str__free(@idata3);

//.support items
for p:=0 to textcore_listmax do
begin

if (fslot[p]<>res_nil) then res__del(fslot[p]);

fref[p]               :='';
tlist[p].name         :='';

if (ilist[p].orgdata<>nil) then str__free(@ilist[p].orgdata);
if (ilist[p].img32<>nil)   then freeobj(@ilist[p].img32);

end;//p

//.support refs
str__free(@icorelinex);
str__free(@icoreliney);
str__free(@icorelineh);
str__free(@icorelineh1);
str__free(@icorelinep);

//..stacks - 11jan202
str__free(@iwrapstack);
str__free(@ikstack);
str__free(@imstack);

//.misc
str__free(@itmp1);

//.undo
mclear(true);

with iundoinfo do
begin

str__free(@list);
str__free(@d1);
str__free(@d2);
str__free(@d3);

end;

//self
inherited destroy;

except;end;
end;

function ttextcore.fontslot(const xindex:longint):longint32;
begin

case (xindex>=0) and (xindex<=textcore_listmax) of
true:result:=fslot[xindex];
else result:=res_nil;
end;//case

end;

function ttextcore.xgreyFeather:boolean;
begin

result:=true;

end;

function ttextcore.canspell:boolean;
begin
result:=idic;
end;

procedure ttextcore.spell;
begin
if canspell then dic_spell;
end;

function ttextcore.xscale__px1(const xval:double;const xmin:longint):longint;//rounds down - 10dec2025
begin

{$ifdef gui}
result:=scale__px1(xval,xmin);
{$else}
result:=frcmin32(trunc(xval),xmin);
{$endif}

end;

function ttextcore.xvifontsize:longint;
begin

{$ifdef gui}
result:=viFontsize;
{$else}
result:=8;
{$endif}

end;

function ttextcore.xvifontsize2:longint;
begin

{$ifdef gui}
result:=viFontsize2;
{$else}
result:=8;
{$endif}

end;

function ttextcore.xvifeather:longint;
begin

{$ifdef gui}
result:=vifeather;
{$else}
result:=0;
{$endif}

end;

function ttextcore.xvisyncid:longint;
begin

{$ifdef gui}
result:=visyncid;
{$else}
result:=0;
{$endif}

end;

function ttextcore.xviscale:double;
begin

{$ifdef gui}
result:=viscale;
{$else}
result:=1.0;
{$endif}

end;

function ttextcore.xfoundfontname(const xname:string;var xoutname:string):boolean;
begin

xoutname    :=font__realname( xname );
result      :=not strmatch( xname ,xoutname );

end;

function ttextcore.xkeyboard__fromak(xcode:longint;var xctrl,xalt,xshift,xkeyx:boolean;var xkey:longint;var xhavekey:boolean):boolean;
label
   redo;
var
   xonce:boolean;

   procedure kx(xval:longint);
   begin

   xkey     :=xval;
   xkeyx    :=true;
   xhavekey :=true;

   end;
   
begin

//defaults
result:=false;
xonce   :=true;
xctrl   :=false;
xalt    :=false;
xshift  :=false;
xkeyx   :=false;
xkey    :=63;//?
xhavekey:=false;

//check
if (xcode=aknone) then exit;

//get
redo:

case xcode of
0..255:begin
   xkey:=xcode;
   xhavekey:=true;
   end;
akshift        :xshift:=true;
akshiftup      :xshift:=false;
akreturn       :kx(13);
akreturn_press :kx(13);//31mar2021
aktab          :kx(9);
akback         :kx(vkback);
akdelete       :kx(vkdelete);
akleft         :kx(vkleft);
akright        :kx(vkright);
akup           :kx(vkup);
akdown         :kx(vkdown);
akprev         :kx(vkprior);
aknext         :kx(vknext);
akhome         :kx(vkhome);
akend          :kx(vkend);
akaltA..akaltZ :begin

   xkeyx:=true;
   xkey:=65+(xcode-akaltA);
   xhavekey:=true;
   xalt:=true;

   end;
akctrlA..akctrlZ :begin

   xkeyx:=true;
   xkey:=65+(xcode-akctrlA);
   xhavekey:=true;
   xctrl:=true;

   end;
akf1..akf12:begin

   kx(vkf1+(xcode-akf1));

   end;
akctrlNone..akctrlLast:if xonce then
   begin

   xonce:=false;
   xctrl:=true;
   xcode:=xcode-akctrlnone+aknone;//convert from "akctrlleft -> akleft" - 31mar2021

   goto redo;

   end;
akaltNone..akaltLast:if xonce then
   begin

   xonce:=false;
   xalt:=true;
   xcode:=xcode-akaltnone+aknone;//convert from "akaltleft -> akleft" - 31mar2021

   goto redo;

   end;
end;//case

end;

function ttextcore.strbyte1x(const x:string;xpos:longint64):byte;//1based always -> backward compatible with D3 - 02may2020
var
   xlen:longint64;
begin

//init
if (xpos<1) then xpos:=1;

xlen  :=low__len32(x);

//get
case (xlen>=1) and (xpos<=xlen) of
true:result:=byte(x[ int64__3264(xpos-1+stroffset) ]);
else result:=0;
end;//case

end;

function ttextcore.bstr(const x:tstr8):string;
begin
try

if (x<>nil) and (not x.empty) then result:=x.text else result:='';

except;end;
end;

function ttextcore.blen32(x:tstr8):longint;
begin

case (x<>nil) of
true:result:=x.len32;
else result:=0;
end;//case

end;

function ttextcore.bsetlen(const x:tstr8;const xlen:longint64):boolean;
begin

if (x<>nil) then x.setlen(frcmin64(xlen,0));

end;

procedure ttextcore.xline__atleast(xnewsize:longint);
var
   p,olen,nlen:longint;
begin

//range
xnewsize    :=frcmin32(xnewsize,1);
nlen        :=xnewsize*4;

//size
olen:=blen32(icoreliney);

if (nlen<>olen) then
   begin

   if (nlen<olen) then ilinesize:=xnewsize;//shrink -> update right now

   bsetlen(icorelinex ,nlen);
   bsetlen(icoreliney ,nlen);
   bsetlen(icorelineh ,nlen);
   bsetlen(icorelineh1,nlen);
   bsetlen(icorelinep ,nlen);

   if (nlen>=olen) then ilinesize:=xnewsize;//enlarge -> update now -> streams at size

   ilinex  :=icorelinex.core;
   iliney  :=icoreliney.core;
   ilineh  :=icorelineh.core;
   ilineh1 :=icorelineh1.core;
   ilinep  :=icorelinep.core;

   //cls new data
   if (nlen>olen) then
      begin

      for p:=(olen+1) to nlen do icorelinex .byt1[p-1]:=0;
      for p:=(olen+1) to nlen do icoreliney .byt1[p-1]:=0;
      for p:=(olen+1) to nlen do icorelineh .byt1[p-1]:=0;
      for p:=(olen+1) to nlen do icorelineh1.byt1[p-1]:=0;
      for p:=(olen+1) to nlen do icorelinep .byt1[p-1]:=0;

      end;

   end;

end;

procedure ttextcore.cdefault;
begin
xcurrent__default;
end;

function ttextcore.getcsize:longint;
begin
result:=icurrentinfo.size;
end;

procedure ttextcore.setcsize(x:longint);
begin
icurrentinfo.size:=font__safesize(x);
end;

function ttextcore.getcname:string;
begin
result:=icurrentinfo.name;
end;

procedure ttextcore.setcname(x:string);
begin
icurrentinfo.name:=x;
end;

function ttextcore.getccolor:longint;
begin
result:=icurrentinfo.color;
end;

procedure ttextcore.setccolor(x:longint);
begin
if (x=clnone) then x:=0;
icurrentinfo.color:=x;
end;

function ttextcore.getcbgcolor:longint;
begin
result:=icurrentinfo.bgcolor;
end;

procedure ttextcore.setcbgcolor(x:longint);
begin
icurrentinfo.bgcolor:=x;
end;

function ttextcore.getcbold:boolean;
begin
result:=icurrentinfo.bold;
end;

procedure ttextcore.setcbold(x:boolean);
begin
icurrentinfo.bold:=x;
end;

function ttextcore.getcitalic:boolean;
begin
result:=icurrentinfo.italic;
end;

procedure ttextcore.setcitalic(x:boolean);
begin
icurrentinfo.italic:=x;
end;

function ttextcore.getcunderline:boolean;
begin
result:=icurrentinfo.underline;
end;

procedure ttextcore.setcunderline(x:boolean);
begin
icurrentinfo.underline:=x;
end;

function ttextcore.getcstrikeout:boolean;
begin
result:=icurrentinfo.strikeout;
end;

procedure ttextcore.setcstrikeout(x:boolean);
begin
icurrentinfo.strikeout:=x;
end;

function ttextcore.getcalign:longint;
begin
result:=icurrentinfo.align;
end;

procedure ttextcore.setcalign(x:longint);
begin
icurrentinfo.align:=frcrange32(x,0,wcaMax);
end;

procedure ttextcore.xcurrent__default;//05jul2022
begin

with icurrentinfo do
begin

name                  :=strdefb(idefFontname,font__name1);
size                  :=frcrange32(idefFontsize,4,300);
bold                  :=false;
italic                :=false;
underline             :=false;
strikeout             :=false;
color                 :=idefFontcolor;
bgcolor               :=clnone;
brcolor               :=clnone;
align                 :=wcaLeft;

end;

end;

function ttextcore.canact(x:string):boolean;
begin

//init
x   :=strlow(x);

//get
if      (x='canundo')           then result:=canundo
else if (x='canredo')           then result:=canredo
else if (x='cancut')            then result:=cancut
else if (x='cancopy')           then result:=cancopy
else if (x='cancopyall')        then result:=cancopyall
else if (x='canpaste')          then result:=canpaste
else if (x='canpastereplace')   then result:=canpastereplace
else if (x='candeleteall')      then result:=candeleteall
else if (x='canclearall')       then result:=canclearall
else if (x='canselectall')      then result:=canselectall
else                                 result:=false;

end;

function ttextcore.act(x:string):boolean;
begin

//init
result  :=true;
x       :=strlow(x);

//get
if      (x='undo')              then result:=undo
else if (x='redo')              then result:=redo
else if (x='cut')               then cut
else if (x='copy')              then copy
else if (x='copyall')           then copyall
else if (x='paste')             then paste
else if (x='pastereplace')      then pastereplace
else if (x='deleteall')         then deleteall
else if (x='clearall')          then clearall
else if (x='selectall')         then selectall
else                                 result:=false;

end;

function ttextcore.getundouse:boolean;
begin
result:=iundoinfo.enabled;
end;

procedure ttextcore.setundouse(x:boolean);
var
   p:longint;
begin

//check
if not low__setbol(iundoinfo.enabled,x) then exit;

//get
case iundoinfo.enabled of
true:begin//undo on

   for p:=low(iundoinfo.n) to high(iundoinfo.n) do if (iundoinfo.n[p]='') then iundoinfo.n[p]:=io__tempfile__newnameid('','TMP');//name PART only

   if (iundoinfo.list=nil) then
      begin

      iundoinfo.list :=str__new8;
      mundo__init(iundoinfo.list,iundoinfo.limit);

      end;

   if (iundoinfo.d1=nil) then iundoinfo.d1:=str__new8;
   if (iundoinfo.d2=nil) then iundoinfo.d2:=str__new8;
   if (iundoinfo.d3=nil) then iundoinfo.d3:=str__new8;

   end;
else begin//undo off

   mclear(true);

   end;
end;//case

end;

procedure ttextcore.undoClear;
begin
mclear(true);
end;

function ttextcore.canundo:boolean;
begin
result:=mcanundo;
end;

function ttextcore.undo:boolean;
begin
result:=mundo;
end;

function ttextcore.canredo:boolean;
begin
result:=mcanredo;
end;

function ttextcore.redo:boolean;
begin
result:=mredo;
end;

procedure ttextcore.mclear(const xcleanfiles:boolean);
var
   p:longint;
begin

with iundoinfo do
begin

for p:=low(n) to high(n) do
begin

if nUsed[p] and (n[p]<>'') and xcleanfiles then io__remfile(io__tempfolder+n[p]);
nUsed[p]    :=false;//20dec2024

end;//p

if (list<>nil) then mundo__clear(list);

str__clear(@d1);
str__clear(@d2);
str__clear(@d3);

style       :=musNone;//27jun2022
from1       :=1;
act         :=muaRep;
len         :=0;

end;//with

end;

function ttextcore.mdok:boolean;
begin
result:=(iundoinfo.d1<>nil) and (iundoinfo.d2<>nil) and (iundoinfo.d3<>nil);
end;

function ttextcore.mmax:longint;
begin
result:=frcrange32(iundoinfo.limit-1,0,high(iundoinfo.n));
end;

function ttextcore.mredoflush:boolean;//true=flushed redo, false=nothing changed
begin
result:=iundoinfo.enabled and mundo__redoflush(iundoinfo.list);
end;

function ttextcore.me(x:tstr8):tstr8;//pass-thru - encode
begin
result:=x;

try
low__compress(@x);
low__lestr(x);
result:=x;
except;end;
end;

function ttextcore.md(x:tstr8):tstr8;//pass-thru - decode
begin
result:=x;

try
low__ldstr(x);
low__decompress(@x);
result:=x;
except;end;
end;

function ttextcore.mstore12(xuseslot:longint;xstoreRecovered:boolean):boolean;//27sep2022 fixed "no undo in use issue", multi-undo write
label
   skipend;
var
   v:tvars8;
   a,b:tstr8;
   h:tint4;
   e:string;
   l32,xact,xstyle,xslot,xfrom1,xlen:longint;
   xmustdel:boolean;
begin

//defaults
result      :=false;
a           :=nil;
b           :=nil;
v           :=nil;
xslot       :=-1;
xmustdel    :=true;

//check - 27sep2022
if not iundoinfo.enabled then
   begin

   result:=true;
   exit;

   end;

//range
l32         :=xlen32;
xstyle      :=frcrange32(iundoinfo.style,musNone,musMax);
xfrom1      :=frcrange32(iundoinfo.from1   ,1,l32);//32
xlen        :=frcrange32(iundoinfo.len     ,0,l32);//32
xact        :=muaRep;

try

//check
if (xstyle=musRecovered) and (not xstoreRecovered) then
   begin

   xmustdel  :=false;
   result    :=true;
   goto skipend;

   end;

case xstyle of
musDelL,musDelR:begin

   xlen:=0;//from side stream
   xact:=muaAdd;

   end;
musIns,musInsimg:begin

   xact:=muaSub;

   end;
musRangekeep:begin

   xact:=muaRep;

   end;
musRecovered:begin

   xlen:=blen32(iundoinfo.d1);//32
   xact:=frcrange32(iundoinfo.act,0,muaMax);

   end;
musSel,musSelKeep:begin

   xfrom1   :=selstart;//from data stream
   xlen     :=selcount;

   if (xstyle=musSelKeep) then xact:=muaRep else xact:=muaAdd;

   //check for empty selection requests and IGNORE them - 03jul2022
   if (xlen<=0) then
      begin

      result:=true;
      goto skipend;

      end;

   end;
else
   begin//nothing to do here for these modes

   result:=true;
   goto skipend;

   end;
end;//case

//init
//.slot
if (xuseslot>=-1) then xslot:=xuseslot
else                   xslot:=mundo__newslot(iundoinfo.list);

//.tmps
a           :=str__new8;
b           :=str__new8;
v           :=vnew;
xact        :=frcrange32(xact,0,muaMax);//action

//header ID - 28jun2022
h.bytes[0]  :=uuU;
h.bytes[1]  :=uuN;
h.bytes[2]  :=uuD;
h.bytes[3]  :=nn1;
a.datpush(h.val,nil);

//info
v.i['x']    :=xfrom1;
v.i['a']    :=xact;
v.i['1']    :=icursorpos;
v.i['2']    :=icursorpos2;
v.i['v']    :=vpos_px;//low__wordcore2(x,'vpos.px',nil);
v.i['h']    :=hpos;//low__wordcore2(x,'hpos',nil);
a.datpush(0,v.data);
freeobj(@v);

//data
case xstyle of
musDelL,musDelR:begin

   a.datpush(1,me(iundoinfo.d1));
   a.datpush(2,me(iundoinfo.d2));
   a.datpush(3,me(iundoinfo.d3));

   end;
musIns,musSel,musSelKeep,musRangekeep,musInsimg:begin

   b.clear;
   b.add31(idata ,xfrom1,xlen);
   a.datpush(1,me(b));

   b.clear;
   b.add31(idata2,xfrom1,xlen);
   a.datpush(2,me(b));

   b.clear;
   b.add31(idata3,xfrom1,xlen);
   a.datpush(3,me(b));

   end;
musRecovered:begin

   if mdok then
      begin
      a.datpush(1,me(iundoinfo.d1));
      a.datpush(2,me(iundoinfo.d2));
      a.datpush(3,me(iundoinfo.d3));
      end;

   end;
end;//case

//save
iundoinfo.nUsed[xslot]:=true;
if not io__tofile(io__tempfolder+iundoinfo.n[xslot],@a,e) then goto skipend;

//successful
result:=true;
skipend:

except;end;
try

//clear
if (xstyle<>musNone) then//and (xstyle<>musRangekeep) then
   begin

   //temp streams
   str__clear(@iundoinfo.d1);
   str__clear(@iundoinfo.d2);
   str__clear(@iundoinfo.d3);

   //vars
   iundoinfo.from1 :=1;
   iundoinfo.len   :=0;
   iundoinfo.style :=musNone;
   iundoinfo.act   :=muaRep;

   //delete selection
   if xmustdel and (xstyle=musSel) and (selcount>=1) then xdelsel2(false);//yyyyyyyyyyyyyy xdelsel2(true);//don't set "*_moveto" when inserting one or more characters - 02sep2019

   end;

//free
freeobj(@a);
freeobj(@b);
freeobj(@v);
except;end;
end;

function ttextcore.mstore1:boolean;//multi-undo write
begin
result:=mstore12(min32,false);
end;

function ttextcore.mread1(xslot:longint;xundo:boolean):boolean;//27sep2022 fixed "no undo in use issue"
label
   skipend;
var
   v:tvars8;
   a,b:tstr8;
   h:tint4;
   bcount,xact,xfrom1,xcursor,xcursor2,xposV,xposH,bn,xpos:longint;
   e:string;
begin

//defaults
result      :=false;
a           :=nil;
b           :=nil;
v           :=nil;

//check - 27sep2022
if not iundoinfo.enabled then
   begin

   result:=true;
   exit;

   end;

//range
xslot       :=frcrange32(xslot,low(iundoinfo.n),mmax);

//init
a           :=str__new8;
b           :=str__new8;
v           :=vnew;
xact        :=muaRep;
xfrom1      :=0;
xcursor     :=1;
xcursor2    :=1;
xposV       :=0;
xposH       :=0;
bcount      :=0;

try

//clear
str__clear(@iundoinfo.d1);//03jul2022
str__clear(@iundoinfo.d2);
str__clear(@iundoinfo.d3);

//load
if not io__fromfile(io__tempfolder+iundoinfo.n[xslot],@a,e) then goto skipend;

//get
xpos        :=0;

//.header ID
h.bytes[0]  :=uuU;
h.bytes[1]  :=uuN;
h.bytes[2]  :=uuD;
h.bytes[3]  :=nn1;

if (not a.datpull32(xpos,bn,b)) or (bn<>h.val) then goto skipend;

//.data values
while true do
begin

if not a.datpull32(xpos,bn,b) then break;

//.info
if (bn=0) then
   begin

   //get
   v.data   :=b;
   xfrom1   :=frcmin32(v.i['x'],1);
   xact     :=frcrange32(v.i['a'],0,muaMax);
   xcursor  :=frcmin32(v.i['1'],1);
   xcursor2 :=frcmin32(v.i['2'],1);
   xposV    :=v.i['v'];
   xposH    :=v.i['h'];

   //clear
   v.clear;

   //action inversion
   if not xundo then
      begin

      if      (xact=muaAdd) then xact:=muaSub
      else if (xact=muaSub) then xact:=muaAdd;

      end;

   end

//data
else if (bn=1) and (xfrom1>=1) then
   begin

   //init
   md(b);
   bcount:=blen32(b);//32

   //get
   if (xfrom1>=1) and (bcount>=1) and ((xact=muaRep) or (xact=muaSub)) then
      begin

      if (xact=muaRep) and mdok then
         begin
         str__clear(@iundoinfo.d1);
         iundoinfo.d1.add3(idata, xfrom1-1,bcount);

         str__clear(@iundoinfo.d2);
         iundoinfo.d2.add3(idata2,xfrom1-1,bcount);

         str__clear(@iundoinfo.d3);
         iundoinfo.d3.add3(idata3,xfrom1-1,bcount);

         end;

      idata .del3(xfrom1-1,bcount);
      idata2.del3(xfrom1-1,bcount);
      idata3.del3(xfrom1-1,bcount);

      end;

   if (xact<>muaSub) then idata.ins(b,xfrom1-1);
   if (iundoinfo.d1<>nil) and (xact<>muaRep) then iundoinfo.d1.replace:=b;//hold the undo value in the MD1-3 handlers - doubles up on the data but makes management easier and more reliable - 03jul2022

   end

else if (bn=2) and (xfrom1>=1) then
   begin

   md(b);

   if (xact<>muaSub) then idata2.ins(b,xfrom1-1);
   if (iundoinfo.d2<>nil) and (xact<>muaRep) then iundoinfo.d2.replace:=b;

   end

else if (bn=3) and (xfrom1>=1) then
   begin

   md(b);

   if (xact<>muaSub) then idata3.ins(b,xfrom1-1);
   if (iundoinfo.d3<>nil) and (xact<>muaRep) then iundoinfo.d3.replace:=b;

   end;

end;//loop

//finalise
case xact of
muaRep,muaAdd:xcursor:=xfrom1+bcount;
muaSub       :xcursor:=xfrom1;
end;//case
xcursor2:=xcursor;

//successful
result:=true;
skipend:

except;end;
try

//finalise
xmincheck;
icursorpos  :=frcrange32(xcursor   ,1,blen32(idata));//32
icursorpos2 :=frcrange32(xcursor2  ,1,blen32(idata));//32
vpos_px     :=xposV;
hpos        :=xposH;

if (xfrom1>=1) then xwrapadd(xlinebefore(xfrom1),xfrom1+bcount+ic_pagewrap);

iundoinfo.from1 :=xfrom1;
iundoinfo.len   :=0;
iundoinfo.act   :=xact;
iundoinfo.style :=musRecovered;
itimer_chklinecursorx:=true;

xincdata3;
xchanged;

//rewrite modified "replace" version back to same slot - 03jul2022
if (xact=muaRep) then mstore12(xslot,true);

//free
freeobj(@a);
freeobj(@b);
freeobj(@v);

except;end;
end;

procedure ttextcore.markModified;
begin

xincdata3;
xchanged;

end;

function ttextcore.xlen32:longint;
begin
result:=idata.len32;
end;

function ttextcore.sel1:longint;
begin

result:=icursorpos;
if (icursorpos2<result) then result:=icursorpos2;

end;

function ttextcore.sel2:longint;
begin

result:=icursorpos2;
if (icursorpos>result) then result:=icursorpos;

end;

function ttextcore.selstart:longint;
begin
result:=frcrange32(sel1,1,xlen32);
end;

function ttextcore.selcount:longint;
begin
result:=frcrange32(sel2-sel1,0,xlen32);
end;

procedure ttextcore.nosel;
begin

if (selcount>=1) then setcursorpos2(icursorpos);

end;

function ttextcore.xlinebefore(const xpos1:longint):longint;//pos>line-1>pos
begin
result  :=frcrange32(  xline__topos( frcmin32( xpos__toline(xpos1) -1 ,0 )  ) ,1 ,xlen32 );
end;

function ttextcore.pos__toline(const xpos1:longint):longint;//pos>line => expects input of xpos=1..x.data.len
begin
result:=xpos__toline(xpos1);
end;

function ttextcore.xpos__toline(const xpos1:longint):longint;//pos>line => expects input of xpos=1..x.data.len
var
   p,int1:longint;
begin

result  :=0;//closest match
int1    :=frcrange32(xpos1,1,xlen32);
int1    :=frcmin32( frcmax32(int1,iwrapcount) ,1 );

//find line by text.xpos
if (iwrapcount>=1) and (ilinecount>=1) then
   begin

   for p:=0 to frcmax32(ilinecount-1,ilinesize-1) do
   begin

   if (ilinep[p]=int1) then
      begin

      result:=p;
      break;

      end
   else if (ilinep[p]>int1) then break
   else result:=p;

   end;//p

   end;

end;

function ttextcore.line__topos(const xline0:longint):longint;
begin
result:=xline__topos(xline0);
end;

function ttextcore.xline__topos(const xline0:longint):longint;//xline0 expects input of 0..(x.linecount-1)
begin

result:=0;//not found

if (xline0>=0) then
   begin

   if (xline0<ilinecount) and (xline0<ilinesize)       then result:=ilinep[xline0]
   else if (iwrapcount>=xlen32)                        then result:=xlen32
   else if (ilinecount>=1) and (ilinecount<=ilinesize) then result:=ilinep[ilinecount-1];//return the furtherest line pos we can - 31aug2019

   end;

end;

function ttextcore.y__toline(const y:longint):longint;//y>line => expects input of y=0..(x.totalheight-1)
var
   p:longint;
begin

result:=-1;//not found

//find line by y.coordinate
if (ilinecount>=1) then for p:=0 to frcmax32(ilinecount-1,ilinesize-1) do if ((iliney[p]+ilineh[p])>=y) then
   begin
   result:=p;
   break;
   end;

end;

function ttextcore.xline__itemcount(const xline0:longint):longint;//line>itemcount => find number of items in line => expects input of lineindex=0..(x.linecount-1)
begin

if (xline0>=0) and (xline0<ilinecount) and (xline0<ilinesize) then
   begin

   case ((xline0+1)<ilinecount) and ((xline0+1)<ilinesize) of
   true:result:=frcmin32( ilinep[xline0+1] - ilinep[xline0] ,0);
   else result:=frcmin32( xlen32 - ilinep[xline0] + 1       ,0);
   end;//case

   end
else result:=0;

end;

procedure ttextcore.fFILL(const findex:longint;const xwine_remake:boolean);
var
   xonefontsize,xlen,xsize,p:longint;
   xbol1,xbol2,xbold,xitalic:boolean;
   str1,xfontname:string;
begin
try//only if font is NIL or EMPTY
   //only if WINE and font is NOT-NIL and NOT-EMPTY

if (findex>=0) and (findex<=textcore_listmax) then
   begin

   xonefontsize       :=ionefontsize;
   xbol1              :=(fslot[findex]=res_nil);
   xbol2              :=xwine_remake and (fslot[findex]<>res_nil);

   if xbol1 or xbol2 then
      begin

      //init
      if (fslot[findex]=res_nil) then fslot[findex]:=res__newfont;

      xfontname       :=font__name1;
      xsize           :=xscale__px1(12,7);
      xbold           :=false;
      xitalic         :=false;

      //split
      str1            :=fref[findex];
      xlen            :=low__len32(str1);//32

      if (xlen>=6) then
         begin

         xbold       :=(strcopy1(str1,1,1)<>'0');
         xitalic     :=(strcopy1(str1,2,1)<>'0');//28feb2026
         //xunderline  :=(strcopy1(str1,3,1)<>'0');
         //xstrikeout  :=(strcopy1(str1,4,1)<>'0');
         //.size
         for p:=6 to xlen do if (strcopy1(str1,p,1)='|') then
            begin

            xfontname :=strcopy1(str1,p+1,xlen);
            xsize     :=frcmin32(strint32(strcopy1(str1,6,p-6)),1);
            break;

            end;//p

         end;

      //.onefontsize
      case xonefontsize of
      0        :xsize:=font__safesize(xviFontsize);
      1        :xsize:=font__safesize(xviFontsize2);
      2..max32 :xsize:=font__safesize(xonefontsize);
      end;

      //get
      if xbol1 or (xbol2 and xfoundfontname(xfontname,xfontname)) or (xonefontsize=0) or (xonefontsize=1) then
         begin

         xfontname    :=strdefb(ionefontname,xfontname);//onefontname overrides ALL fontnames - 05feb2022
         res__font( fslot[findex] ).setparams( xfontname ,xsize ,xgreyFeather ,xbold ,xitalic )

         end;
      end;
   end;

except;end;
end;

procedure ttextcore.xmincheck2(const d1,d2,d3:tstr8);
var
   i:longint;
begin

//check
if (d1=nil) or (d2=nil) or (d3=nil) then exit;

//get
if (d1.len<=0) or (d1.byt1[d1.len32-1]<>10) then
   begin

   i        :=d1.len32;
   d1.addbyt1(10);//was: x.data:=x.data+#10;

   case (i>=1) of//carry on font/style index from last character
   true:begin

      d2.addbyt1(idata2.byt1[i-1]);
      d3.addbyt1(idata3.byt1[i-1]);

      end;
   else
      begin//completely empty -> font/style from default "index=0"

      d2.addbyt1(0);
      d3.addbyt1(0);

      end;
   end;//case

   //check
   if (d1=idata) and (not idataonly) then
      begin

      iwrapstack.addint4(i);
      iwrapstack.addint4(i);//same as "xwrapadd('start',i,i);"
      xchanged;

      end;

   end;

end;

procedure ttextcore.xmincheck;
begin
xmincheck2(idata,idata2,idata3);
end;

function ttextcore.gethpos:longint;
begin
result:=frcrange32(ihpos ,0 ,frcmin32(ipagewidth-iviewwidth,0) );
end;

procedure ttextcore.sethpos(x:longint);
begin

if low__setint(ihpos, frcrange32( x ,0, frcmin32(ipagewidth-iviewwidth,0) ) ) then imustpaint:=true;

end;

function ttextcore.gethpos2:longint;//only return hpos value if showing the horizontal scrollbar
var
   int1:longint;
begin

int1:=frcmin32(ipagewidth-iviewwidth,0);

case (int1>=1) of
true:result:=frcrange32(ihpos,0,int1);
else result:=0;
end;//case

end;

function ttextcore.gethmax:longint;
begin
result:=frcmin32(ipagewidth-iviewwidth,0);
end;

function ttextcore.hshow:boolean;
begin

case iwrapstyle of
wwsNone   :result:=true;
wwsWindow :result:=false;
wwsPage   :result:=(ipagewidth>iviewwidth);
wwsPage2  :result:=(ipagewidth>iviewwidth);
else       result:=false;
end;//case

end;

procedure ttextcore.xwrap_hvsync_changed;
begin

xwrapadd(0,icursorpos+ic_pagewrap);
ihhostsync:=true;
ivhostsync:=true;
xchanged;

end;

procedure ttextcore.setcursorpos(x:longint);
begin

xsetcursorpos(x);
xchanged;

end;

procedure ttextcore.setcursorpos2(x:longint);
var
   int1:longint;
begin

icursorpos2  :=frcrange32(x,1,xlen32);
int1         :=icursorpos2+ic_pagewrap;

if (int1>iwrapcount) then xwrapadd(iwrapcount,int1);
xchanged;

end;

procedure ttextcore.setwrapstyle(x:longint);
begin

if low__setint(iwrapstyle ,frcrange32(x,0,wwsMax) ) then
   begin

   xpagewidth;
   xpageheight;
   xwrap_hvsync_changed;

   end;

end;

procedure ttextcore.setpapersize(x:longint);
var
   w,h:longint;

   procedure s(const dw,dh:longint);
   begin
   w:=dw;
   h:=dh;
   end;

begin

if low__setint( ipapersize ,frcrange32( x ,0 ,psMax ) ) then
   begin

   case ipapersize of
   psA3       :s(297,420);
   psA4       :s(210,297);
   psA5       :s(148,210);
   psLetter   :s(215,279);
   psLegal    :s(215,355);
   else        s(210,297);//fallback to A4
   end;//case

   //set
   if (w<>ipaperwidth) or (h<>ipaperheight) then
      begin

      ipaperwidth     :=w;
      ipaperheight    :=h;

      if (iwrapstyle=wwsPage) or (iwrapstyle=wwsPage2) then
         begin

         xpagewidth;
         xpageheight;
         xwrap_hvsync_changed;

         end;

      end;

   end;

end;

procedure ttextcore.xchanged;
begin

imodified:=true;
rollid32(idataid);
rollid32(idataid2);//14jun2022
imustpaint:=true;

end;

procedure ttextcore.xincdata3;//25dec2022
begin
rollid32(idataid3);
end;

function ttextcore.lineHeight(const xpos1:longint32):longint32;
begin

result:=ilineh[ xsafelineb(xpos__toline(xpos1)) ];

end;

function ttextcore.xfastfindalign(const xpos1:longint):longint;//22apr2022, 28dec2021
var//Note: Speed => 922ms => 719ms (128% faster)
   wrd2:twrd2;
   l32,xid,p:longint;
begin

//defaults
result   :=0;//0=left, 1=centre, 2=right
l32      :=idata.len32;

//check
if (l32>=1) then
   begin

   for p:=frcrange32(xpos1,1,l32) to l32 do if (idata.byt1[p-1]=10) then
      begin

      //get
      ilastfindalignpos   :=p;//22apr2022
      wrd2.bytes[0]       :=idata2.byt1[p-1];
      wrd2.bytes[1]       :=idata3.byt1[p-1];
      xid                 :=wrd2.val;

      if (xid>textcore_listmax) then xid:=textcore_listmax;

      //set
      result              :=tlist[xid].align;
      break;

      end;//p

   end;

end;

procedure ttextcore.xfastcharinit(var xinfo:tfastfont);
begin
xinfo.w1:=-1;
xinfo.w2:=-1;
end;

function ttextcore.xfastchar(var xinfo:tfastfont;const xpos,xlinespacing:longint;var xout:tfastchar):boolean;
var
   f:tresfont;
   wrd2:twrd2;
   p:longint;

   function xstyle(const x:byte):byte;
   begin

   case x of
   9,10,32..255:result:=wc_t;//text
   0           :result:=wc_i;//image
   else         result:=wc_n;//nil -> unknown
   end;//case

   end;

   function xsafe(const xindex:longint):longint;
   begin

   if (xindex<0)                       then result:=0
   else if (xindex>textcore_listmax)   then result:=textcore_listmax
   else                                     result:=xindex;

   end;

begin

if (xpos>=1) and (xpos<=idata.len) then
   begin

   //successful
   result             :=true;

   //init
   xout.c             :=idata.byt1[xpos-1];//fixed 23aug2020
   xout.cs            :=xstyle(xout.c);
   wrd2.bytes[0]      :=idata2.byt1[xpos-1];
   wrd2.bytes[1]      :=idata3.byt1[xpos-1];
   xout.wid           :=xsafe(wrd2.val);

   //get
   //.text character
   if (xout.cs=wc_t) then
      begin

      //.text font id
      xout.txtid:=xsafe( tlist[xout.wid].id );

      //.cache critical font info
      if (xinfo.w1<>xout.wid) or (xinfo.w2<>xout.txtid) then//fixed "null" image lineheight carry-on error -> now resamples lineheight for wordcore's wrapnow proc - 12jun2022
         begin
         xinfo.w1     :=xout.wid;
         xinfo.w2     :=xout.txtid;

         //.fFILL - faster - 22apr2022
         if (not idataonly) and (fslot[xout.txtid]=res_nil) then fFILL(xout.txtid,false);

         //.font object
         f                :=res__font( fslot[xout.txtid] );

         //.height
         xinfo.h          :=f.height;
         xinfo.h1         :=f.height1;

         //.width
         xinfo.wlist[9]   :=5*f.wlist[32];
         xinfo.wlist[10]  :=0;//return code -> no width

         for p:=32 to 255 do xinfo.wlist[p]:=f.wlist[p];

         end;

      xout.width      :=xinfo.wlist[xout.c];
      xout.height     :=xinfo.h *xlinespacing;
      xout.height1    :=xinfo.h1*xlinespacing;

      end

   //.image
   else if (xout.cs=wc_i) then
      begin

      //.width & height
      xout.width      :=ilist[xout.wid].w;
      if (xout.width<1) then xout.width:=1;

      xout.height     :=ilist[xout.wid].h;
      if (xout.height<1) then xout.height:=1;

      xout.height1    :=xout.height;

{
      //.line spacing
      if (iolinespacing>=2) then
         begin
         //xout.height:=xout.height*x.olinespacing;
         //xout.height1:=xout.height1*x.olinespacing;
         end;
}
      end

   //.nil
   else
      begin

      //.width & height
      xout.width      :=0;
      xout.height     :=0;
      xout.height1    :=0;

      end;

   end

else result:=false;//failed

end;

function ttextcore.xslowchar(xpos,xlinespacing:longint;var xout:tfastchar):boolean;
var
   wrd2:twrd2;
   f:tresfont;

   function xstyle(const x:byte):byte;
   begin

   case x of
   9,10,32..255:result:=wc_t;//text
   0           :result:=wc_i;//image
   else        result:=wc_n;//nil -> unknown
   end;//case

   end;

   function xsafe(const xindex:longint):longint;
   begin

   if (xindex<0)                       then result:=0
   else if (xindex>textcore_listmax)   then result:=textcore_listmax
   else                                     result:=xindex;

   end;

begin

if (xpos>=1) and (xpos<=idata.len) then
   begin

   //successful
   result             :=true;

   //init
   xout.c             :=idata.byt1[xpos-1];//fixed 23aug2020
   xout.cs            :=xstyle(xout.c);
   wrd2.bytes[0]      :=idata2.byt1[xpos-1];
   wrd2.bytes[1]      :=idata3.byt1[xpos-1];
   xout.wid           :=xsafe(wrd2.val);

   //get

   //.text character
   if (xout.cs=wc_t) then
      begin

      //.text font id
      xout.txtid    :=xsafe(tlist[xout.wid].id);

      //.fFILL - faster - 22apr2022
      if (not idataonly) and (fslot[xout.txtid]=res_nil) then fFILL(xout.txtid,false);

      //.font
      f               :=res__font( fslot[xout.txtid] );

      //.height
      xout.height     :=f.height;
      xout.height1    :=f.height1;

      //.line spacing
      if (xlinespacing>=2) then
         begin

         xout.height  :=xout.height  * xlinespacing;
         xout.height1 :=xout.height1 * xlinespacing;

         end;

      //.width
      if      (xout.c=9)  then xout.width:=5*f.wlist[32]
      else if (xout.c=10) then xout.width:=0//return code -> no width
      else                     xout.width:=f.wlist[xout.c];

      end

   //.image
   else if (xout.cs=wc_i) then
      begin

      //.width & height
      xout.width    :=ilist[xout.wid].w;
      if (xout.width<1) then xout.width:=1;

      xout.height   :=ilist[xout.wid].h;
      if (xout.height<1) then xout.height:=1;

      xout.height1  :=xout.height;

{
      //.line spacing
      if (x.olinespacing>=2) then
         begin

         //xout.height:=xout.height*x.olinespacing;
         //xout.height1:=xout.height1*x.olinespacing;

         end;
}

      end

   //.nil
   else
      begin

      //.width & height
      xout.width    :=0;
      xout.height   :=0;
      xout.height1  :=0;

      end;

   end

else result:=false;//failed

end;

function ttextcore.xpagewidth:longint;
begin

case iwrapstyle of
wwsNone   :result:=frcmin32(iwidestline+3,iviewwidth);//Note: +3px is a patch -> required to display last part of trailing char on line AND the 2px cursor - 27mar2021
wwsWindow :result:=iviewwidth;
wwsPage   :result:=xmmTOpixels(ipaperwidth);//converts "paperwidth" which is in millimetres into pixels (e.g. for the screenat default dpi of 95) - 12mar2021
wwsPage2  :result:=xmmTOpixels(ipaperwidth);//converts "paperwidth" which is in millimetres into pixels (e.g. for the screenat default dpi of 95) - 12mar2021
else       result:=iviewwidth;
end;//case

ipagewidth:=frcmin32(result,0);

end;

function ttextcore.xpageheight:longint;
begin

case iwrapstyle of
wwsNone   :result:=frcmin32(iviewheight,1);//Note: +3px is a patch -> required to display last part of trailing char on line AND the 2px cursor - 27mar2021
wwsWindow :result:=frcmin32(iviewheight,1);
wwsPage   :result:=xmmTOpixels(ipaperheight);//converts "paperwidth" which is in millimetres into pixels (e.g. for the screenat default dpi of 95) - 12mar2021
wwsPage2  :result:=xmmTOpixels(ipaperheight);//converts "paperwidth" which is in millimetres into pixels (e.g. for the screenat default dpi of 95) - 12mar2021
else       result:=frcmin32(iviewheight,1);
end;//case

ipageheight:=frcmin32(result,0);

end;

procedure ttextcore.wrapall;
begin
xwrapall;
end;

procedure ttextcore.xwrapall;
begin
xwrapadd(0,xlen32);
end;

procedure ttextcore.xwrapto(const xpos:longint);
begin
if (xpos>iwrapcount) then xwrapadd(iwrapcount,xpos)//auto wrap
end;

procedure ttextcore.xwrapadd(const xpos,xpos2:longint);
begin
iwrapstack.addint4(frcmin32(xpos,0));
iwrapstack.addint4(frcmin32(xpos2,0));
end;

function ttextcore.wrapbusy:boolean;
begin
result:=(iwrapstack.len>=1);
end;

function ttextcore.wrapdone:boolean;
begin
result:=(iwrapcount>=xlen32);
end;

procedure ttextcore.xwrapnow(xmin,xmax,xlinecount:longint);
//xxxxxxxxxxxxxxxxxxxxxxxxxxxx Needs to break the wrap on a SPACE or TAB if following word/characters exceed page width - 02aug2019
label
   redo;
const
   xlineblock=5000;//22apr2022
var
   finfo:tfastfont;
   a:tfastchar;
   xleftmargin,xwidestline,xwrapstyle,xlastalign,xdif,lp,int1,sh2,p,dx,pw,ph,lc,lh1,lh2,lx,ly,xlen:longint;
   lac:byte;
   bol1,xwrapNone:boolean;//14mar2021

   function xmustbreak(var xdif:longint):boolean;
   var
      a:tfastchar;
      ddx,i:longint;
   begin

   //defaults
   result   :=false;
   xdif     :=0;

   //get
   ddx      :=dx;

   for i:=p to xmax do
   begin
   //was:
   //low__wordcore__charinfo(x,i,1,a);
   //low__wordcore__charinfoFAST(x,i,1,a);
   xfastchar(finfo,i,1,a);

   if (a.c=10) or (a.c=9) or (a.c=32) then break
   else if ((ddx+a.width)>=pw) then//and (a.c<>10) then
      begin

      result:=true;
      break;

      end;

   inc(ddx,a.width);

   end;//p

   xdif:=ddx-dx;

   end;

   function xalign_lx(xfrompos:longint):longint;
   var
      xalign:longint;
   begin

   //defaults
   result   :=0;

   //get
   if (xfrompos>=ilastfindalignpos) then
      begin

      //was: xalign:=low__wordcore_str2(x,'findalign',intstr32(xfrompos));
      xalign        :=xfastfindalign(xfrompos);//100% -> 50% time (2x faster) - 22apr2022
      xlastalign    :=xalign;

      end
   else xalign:=xlastalign;

   //set -> Important Note: can't use align.CENTER or align.RIGHT with "wrap=wwsNone" as there is no permanent right handside boundary to work with - 14mar2021
   if not xwrapNone then
      begin

      if      (xalign=wcaCenter) then result:=((pw-lx-a.width) div 2)
      else if (xalign=wcaRight)  then result:=pw-lx-a.width;

      end;

   //filter
   result:=frcmin32( result + xleftmargin ,0 );

   end;
begin

//defaults
xmincheck;  //32
xlen        :=xlen32;

//check
if (xlen<1) then exit;

//range
xmin        :=frcrange32(xmin,1,xlen);
xmax        :=frcrange32(xmax,xmin,xlen);
xwrapstyle  :=iwrapstyle;
xwidestline :=iwidestline;
xleftmargin :=0;

//init
xfastcharInit(finfo);

case xwrapstyle of
wwsNone     :pw:=max32-1000;//allow some math space
wwsWindow   :pw:=frcmin32(iviewwidth-3,0);//noticed the letter "r" on a Reminder paste prompt was beneath scrollbar border by 1-2px - 09mar2022
wwsPage     :pw:=frcmin32(xmmtopixels(ipaperwidth)-3,0);//09mar2022, 17mar2021
wwsPage2    :begin

   int1         :=xmmtopixels(ipaperwidth);
   xleftmargin  :=round32(int1*0.2);
   pw           :=frcmin32(int1-xleftmargin-3,0);//09mar2022, 17mar2021

   end;
else       pw:=frcmin32(iviewwidth-3,0);
end;//case

xwrapNone             :=(xwrapstyle=wwsNone);//if "true" then disable align.modes, e.g. CENTER and RIGHT become offline - 14mar2021
pw                    :=frcmin32(pw,1);
ph                    :=frcmin32(ipageheight,1);
ilastfindalignpos     :=-1;//used to speed up "xalign_lx()" for very long lines of text - 11oct2020
xlastalign            :=0;
dx                    :=0;
lc                    :=0;
lh1                   :=0;
lh2                   :=0;
lx                    :=0;
ly                    :=0;

//start at the nearest "completed" line - 25aug2019
if (xmin>=2) then
   begin

   //init
   int1     :=xmin;
   xmin     :=1;

   //find -> Important Note: NEVER include the very last line -> it always ends with a #10 -> this can cause return codes to be detected when none are present - 23aug2019
   if (ilinecount>=2) and (ilinesize>=1) then for p:=0 to frcmax32(ilinecount-2,ilinesize-1) do
      begin

      if (ilinep[p]<=int1) then
         begin

         //treat as beginning of new line -> set all vars accordingly - 23aug2019
         lc           :=p;
         xmin         :=ilinep[p];//1st item on the line
         ly           :=iliney[p];//required
         lx           :=0;//not required yet -> alignment not finalised yet -> done last
         dx           :=0;

         end
      else break;

      end;//p

   end;

//get
if (lc>=ilinesize) then xline__atleast(lc+xlineblock);

lp          :=xmin;
lac         :=0;//was: #0
p           :=xmin;

redo:

//init
xfastchar(finfo,p,ilinespacing,a);


sh2         :=a.height-a.height1;
if (sh2<0) then sh2:=0;

//.store line   [never break on #10] [line must have 1+ chars]
xdif        :=0;
bol1        :=((dx+a.width)>=pw) and (p>lp) and (a.c<>10) and (a.c<>32);//deny auto-wrap on #10 and #32

if (not bol1) and (p>lp) and ((lac=9) or (lac=32)) and xmustbreak(xdif) then bol1:=true;//break line on a tab(9) or space(32) if remaining text exceeds pagewidth

if bol1 then
   begin

   //init
   lx                 :=frcmin32(dx-a.width,0);//xxxxxxxxxxxxxxxxxxxfrcmin32(dx-xdif,0);
   ilinex[lc]         :=xalign_lx(p);//need to workout alignment inorder to set "lx"
   iliney[lc]         :=ly;//top of line
   ilineh[lc]         :=lh1+lh2;//overheight of line
   ilineh1[lc]        :=lh1;//distance from top of line to the base line of line
   ilinep[lc]         :=lp;//first item in line

   //inc
   lp                 :=p;
//yyyyy//was:      if bol1 then lp:=p else lp:=p+1;
   inc(lc);
   if (lc>=ilinesize) then xline__atleast(lc+xlineblock);

   //reset
   inc(ly,lh1+lh2);
   lx                 :=0;
   lh1                :=0;
   lh2                :=0;
   dx                 :=0;
   xdif               :=0;

   end;

//.item
inc(dx,a.width);
if (xwrapstyle=wwsNone) and (dx>xwidestline) then xwidestline:=dx;//12mar2021

//.lh1 + lh2
if (a.height1>lh1) then lh1:=a.height1;
if (sh2>lh2)       then lh2:=sh2;

//.store line   [never break on #10] [line must have 1+ chars]
if (not bol1) and ((a.c=10) or (p=xmax)) then
   begin

   //init
   lx                 :=frcmin32(dx-xdif,0);
   ilinex[lc]         :=xalign_lx(p);//need to workout alignment inorder to set "lx"
   iliney[lc]         :=ly;//top of line
   ilineh[lc]         :=lh1+lh2;//overheight of line
   ilineh1[lc]        :=lh1;//distance from top of line to the base line of line
   ilinep[lc]         :=lp;//first item in line

   //inc
   lp                 :=p+1;
   inc(lc);

   if (lc>=ilinesize) then xline__atleast(lc+xlineblock);

   //reset
   inc(ly,lh1+lh2);
   lx                 :=0;
   lh1                :=0;
   lh2                :=0;
   dx                 :=0;
   xdif               :=0;

   end;

//.store progress
lac                   :=a.c;
iwrapcount            :=p;
ilinecount            :=lc;
itotalheight          :=ly;

//inc
inc(p);
if (p<=xlen) and ( (p<=xmax) or ((xlinecount>=1) and (ilinecount<xlinecount)) ) then goto redo;

//30aug2019
ivhostsync            :=true;

if (xwrapstyle=wwsNone) and (xwidestline>iwidestline) then
   begin

   iwidestline        :=xwidestline;
   xpagewidth;
   xpageheight;
   ihhostsync         :=true;

   end;

end;

function ttextcore.xwrapfinish(vpos:longint;xpx:boolean):longint;//pass-thru proc
begin

result:=vpos;
if (not wrapdone) and (vpos>=low__aorb(ilinecount,itotalheight,xpx)) then xwrapnow(0,xlen32,0);//by lines

end;

function ttextcore.getvmax:longint;
begin
result:=frcmin32(ilinecount-1,0);
end;

function ttextcore.getvpos:longint;
begin
result:=frcrange32( ivpos ,0 ,frcmin32(ilinecount-1,0) );
end;

procedure ttextcore.setvpos(x:longint);
var
   v:longint;
begin

v:=frcrange32( xwrapfinish(x,false) ,0 ,frcmin32(ilinecount-1,0) );

if (v<>ivpos) then
   begin

   ivpos              :=v;
   ivposPART          :=0;
   imustpaint         :=true;
   ivhostsync         :=true;//sync vertical scrollbar when cursor is NOT showing (e.g. readonly mode) - 27aug2021

   end;

end;

function ttextcore.getvmax_px:longint;
begin
result:=frcmin32(itotalheight-1,0);
end;

function ttextcore.getvpos_px:longint;
begin

result:=ivposPART;
if (ilinecount>=1) then inc(result,iliney[ frcrange32(ivpos,0,frcmin32(ilinecount-1,0)) ]);

end;

procedure ttextcore.setvpos_px(x:longint);
var
   int2,int3,int4:longint;
begin

int2:=frcrange32( xwrapfinish(x,true) ,0 ,frcmin32(itotalheight-1,0) );//fixed - 07feb2023
int3:=frcmin32( y__toline(x) ,0 );

if (int3>=0) then int4:=iliney[int3] else int4:=0;
if (ivpos<>int3) or ((int4+ivposPART)<>int2) then
   begin

   ivpos      :=int3;
   ivposPART  :=int2-int4;
   imustpaint :=true;
   ivhostsync :=true;//sync vertical scrollbar when cursor is NOT showing (e.g. readonly mode) - 27aug2021

   end;

end;

procedure ttextcore.xmust__vhostsync;//tells host it must re-sync vertical scrollbar
begin
ivhostsync:=true;
end;

function ttextcore.xy__topos(dx,dy:longint):longint;//find position in data stream from x,y coordinates (relative to current vpos/hpos)
var
   p,p2,int1,int2,int3,int4:longint;
   winfo:tfastfont;
   xchar:tfastchar;
begin

//defaults
result      :=0;//not found

//init
if (ivposPART<>0) then inc(dy,ivposPART);//21jun2022

//find y.coordinate
if (ilinecount>=1) then
   begin

   int1     :=vpos;

   if (int1>=0) and (int1<ilinecount) and (int1<ilinesize) then
      begin

      inc(dy,iliney[int1]);//make dy relative

      //find best line
      int4:=int1;
      for p:=frcmin32(int1-100,0) to frcmax32(ilinecount-1,ilinesize-1) do if (dy>=iliney[p]) then int4:=p else break;

      //get
      if (int4>=0) then
         begin

         //init
         xfastcharInit(winfo);

         //make dx relative
         p            :=int4;
         if (ipagewidth<iviewwidth) then dec(dx,(iviewwidth-ipagewidth) div 2) else inc(dx,hpos2);

         int2         :=ilinex[p];
         int3         :=ilinep[p];

         for p2:=ilinep[p] to (ilinep[p]+xline__itemcount(p)-1) do
            begin

            if not xfastchar(winfo,p2,1,xchar) then break;//17mar2025: 200% faster
            if (dx>=(int2-2))                  then int3:=p2 else break;
            inc(int2,xchar.width);

            end;//p2

         //return result
         result:=int3;

         end;//int4

      end;//int1

   end;//ilinecount

end;

function ttextcore.xpos__rc(const xpos:longint):longint;//pos>rc => find end of line #10
var
   ff:tfastfont;
   fc:tfastchar;
   p,l32:longint;
begin

//init
result    :=1;
l32       :=xlen32;

//get
if (l32>=1) and (xpos>=1) then
   begin

   //init
   xfastcharInit(ff);

   //find
   for p:=frcrange32(xpos,1,l32) to l32 do if xfastchar(ff,p,1,fc) and (fc.cs=wc_t) and (fc.c=10) then
      begin

      result:=p;
      break;

      end;//p
   end;

end;

function ttextcore.xscootable(const x:byte):boolean;
begin
result:=(x=ssspace) or (x=ssdot) or (x=sscomma) or (x=sscolon) or (x=sssemicolon) or (x=ssexclaim) or (x=ssquestion) or (x=ss10) or (x=ss9) or (x=ssdoublequote) or (x=sssinglequote);
end;

function ttextcore.xsafeline(var xindex:longint):boolean;
var
   xmax:longint;
begin

//init
xmax:=frcmax32(ilinecount-1,ilinesize-1);
if (xmax<0) then xmax:=0;

//get
result:=(xindex>=0) and (xindex<=xmax);
if (xindex<0) then xindex:=0 else if (xindex>xmax) then xindex:=xmax;

end;

function ttextcore.xsafelineb(const xindex:longint):longint;
begin

result:=xindex;
xsafeline(result);

end;

function ttextcore.xposTOx(xpos:longint;var dx,dx2:longint):boolean;
var
   finfo:tfastfont;
   l32,xmin,p,xline:longint;
   xchar:tfastchar;
begin

//defaults
result      :=false;
dx          :=0;
dx2         :=0;
l32         :=xlen32;

//range
xpos        :=frcrange32(xpos,1,l32);

//init
xline       :=xpos__toline(xpos);

//get
if xsafeline(xline) then
   begin

   result   :=true;
   xfastcharInit(finfo);

   dx       :=ilinex[xline];
   xmin     :=ilinep[xline];

   for p:=xmin to l32 do
   begin

   //was: if not low__wordcore__charinfo(x,p,1,xchar) then break;
   if not xfastchar(finfo,p,1,xchar) then break;//17mar2025: 200% faster

   dx2      :=dx+xchar.width;//right side of cursor character

   if (p>=xpos) then break;
   inc(dx,xchar.width);

   end;//p

   end;

end;

function ttextcore.xcursor_offscreenX:longint;
var//Note: returns<0 if cursor is off left of screen, returns>0 if off to right and returns 0 when cursor is on screen - 31mar2021
   int1,int2:longint;
begin

//defaults
result:=0;

//init
if xposTOx(icursorpos,int1,int2) then
   begin

   dec(int1,ihpos);
   dec(int2,ihpos);

   //get
   if (int1<0)           then result:=int1;
   if (int2>=iviewwidth) then result:=int2-iviewwidth+1;

   end;
   
end;

procedure ttextcore.xcursor_bringintoview;
var
   int1:longint;
begin

int1:=xcursor_offscreenX;

if (int1<>0) then
   begin

   ihhostsync :=true;
   ihpos      :=ihpos+int1+((iviewwidth div 3)*(int1 div low__posn(int1)));
   imustpaint :=true;

   end;
end;

procedure ttextcore.xlinecursorx(xpos:longint);
var
   int1,int2:longint;
begin

if xposTOx(xpos,int1,int2) then ilinecursorx:=int1;
xcursor_bringintoview;

end;

function ttextcore.xmmTOpixels(const xval:longint):longint;//support viscale - 28feb2026
begin

result:=round32( xval * (idpi/25.4) * xviscale );

end;

function ttextcore.xmakefont2(const xoverride:boolean;xname:string;xsize,xcolor,xbgcolor,xbrcolor:longint;xbold,xitalic,xunderline,xstrikeout:boolean;xalign:byte):longint;
label
   skipend;
var
   xref:string;
   xnew,i,p:longint;

begin

//defaults
result                :=0;
xnew                  :=-1;

//init
if not xoverride then
   begin

   xname              :=strdefb(icurrentinfo.name,font__name1);
   xsize              :=font__safesize(icurrentinfo.size);
   xbold              :=icurrentinfo.bold;
   xitalic            :=icurrentinfo.italic;
   xunderline         :=icurrentinfo.underline;
   xstrikeout         :=icurrentinfo.strikeout;
   xcolor             :=icurrentinfo.color;
   xbgcolor           :=icurrentinfo.bgcolor;

   //filter
   xbrcolor           :=icurrentinfo.brcolor;
   xalign             :=icurrentinfo.align;

   end;

//range
xname                 :=strdefb(xname,font__name1);//$fontname
xname                 :=strdefb(ionefontname,xname);//onefontname overrides ALL fontnames - 05feb2022
xsize                 :=font__safesize(xsize);

case ionefontsize of
0        :xsize:=xvifontsize;
1        :xsize:=xvifontsize2;
2..max32 :xsize:=font__safesize(ionefontsize);
end;//case

//.color check
//02jun2020
if (xcolor=clnone) then xcolor:=int_255_255_255;//was: xcolor=0, but when "color=0 and bk=clnone" then we ended up with black on black

//find existing "textinfo" - 13feb2026
for p:=0 to textcore_listmax do if
   (tlist[p].name<>'')              and (xcolor=tlist[p].color)     and
   (xbgcolor=tlist[p].bgcolor)      and (xbrcolor=tlist[p].brcolor) and (xsize=tlist[p].size)           and
   (xbold=tlist[p].bold)            and (xitalic=tlist[p].italic)   and (xunderline=tlist[p].underline) and
   (xstrikeout=tlist[p].strikeout)  and (xalign=tlist[p].align)     and strmatch(xname,tlist[p].name)   then
   begin

   result:=p;
   goto skipend;

   end;//p

//find free
if (xnew<0) then for p:=0 to textcore_listmax do if (tlist[p].name='') then
   begin

   xnew:=p;
   break;

   end;//p

//emergency limit -> we need to find items that are nolonger being pointed to and reuse them before just parking it here at the uppermost limit - 21aug2019
if (xnew<0) then xnew:=textcore_listmax;

//get
result                    :=xnew;
tlist[result].name        :=xname;
tlist[result].size        :=xsize;
tlist[result].bold        :=xbold;
tlist[result].italic      :=xitalic;
tlist[result].underline   :=xunderline;
tlist[result].strikeout   :=xstrikeout;
tlist[result].color       :=xcolor;
tlist[result].bgcolor     :=xbgcolor;
tlist[result].brcolor     :=xbrcolor;
tlist[result].align       :=xalign;//21sep2019
tlist[result].id          :=0;//point to default for safety
xref                      :=bolstr(xbold)+bolstr(xitalic)+bolstr(xunderline)+bolstr(xstrikeout)+'|'+intstr32(xsize)+'|'+xname;//14mar2021

//.find existing font
i                         :=-1;

if (i<0) then for p:=0 to textcore_listmax do if (fref[p]<>'') and strmatch(xref,fref[p]) then
   begin

   i                      :=p;
   break;

   end;//p

//.create new font
if (i<0) then for p:=0 to textcore_listmax do if (fref[p]='') then
   begin

   //get
   if not idataonly then
      begin

      if (fslot[p]=res_nil) then fslot[p]:=res__newfont;

      res__font( fslot[p] ).setparams( xname ,xsize ,xgreyFeather ,xbold, xitalic );

      end
   else if (fslot[p]<>res_nil) then res__font( fslot[p] ).clear;//don't destroy ONCE object has been created for stability - 28feb2026, 19dec2021, 21aug2020

   fref[p]            :=xref;
   i                  :=p;
   break;

   end;//p

//set id
if (i>=0) then tlist[result].id:=i;

//changed
xincdata3;
xchanged;

skipend:

end;

function ttextcore.xmakefont:longint;
begin
result:=xmakefont2(false,idefFontname,idefFontsize,idefFontcolor,clnone,clnone,false,false,false,false,0);
end;

function ttextcore.xappend(xout:tstr8;const n:string;xval:tstr8):boolean;//fixed - 28jan2021
label
   skipend;
begin//n='' -> finalise output buffer "xout"

//defaults
result      :=false;

//init
str__lock(@xout);
str__lock(@xval);

//check
if (xout=nil) then goto skipend;

//get
if (n='') or (xval=nil) then
   begin
   //nil - nothing to do
   end
else
   begin

   //filter -> n is fixed at 4 characters
   if not xout.sadd(strcopy1(n+'    ',1,4)) then goto skipend;
   if not xout.addint4(xval.len32) then goto skipend;

   //get
   if (xval.len>=1) and (not xout.add(xval)) then goto skipend;

   end;

//successful
result      :=true;
skipend:

//free
str__uaf(@xout);
str__uaf(@xval);

end;

function ttextcore.xappendstr(xout:tstr8;const n,v:string):boolean;
begin
result:=xappend(xout,n,str__newaf8b(v));
end;

function ttextcore.xappendint4(xout:tstr8;n:string;v:longint):boolean;
var
   a:tstr8;
begin

result      :=false;
a           :=str__newaf8;
a.addint4(v);
result      :=xappend(xout,n,a);

end;

function ttextcore.xpull(var xoutpos:longint;xout:tstr8;var n:string;v:tstr8):boolean;
var
   xpos,int1:longint;
begin//n='' -> finalise output buffer "xout"

//defaults
result      :=false;
n           :='';

//check
if (v<>nil)   then v.clear else exit;
if (xout=nil) then exit;

//init
xpos        :=xoutpos;

//range
if      (xpos<1)            then xpos:=1
else if ((xpos+7)>xout.len) then exit;

//get
n           :=bgetstr1(xout,xpos,4);
int1        :=xout.int4[xpos+4-1];//was: int1:=frcmin32(to32bit(copy(xout,xpos+4,4)),0);

//inc -> still incs even on error
xoutpos     :=xpos+8+int1;

//set
if (int1>=1) then v.add3(xout,xpos+8-1,int1);//was: v:=copy(xout,xpos+8,int1);

//successful
result:=true;

end;

function ttextcore.xpullstr(var xoutpos:longint;xout:tstr8;var n,v:string):boolean;
var
   a:tstr8;
begin

//defaults
result      :=false;
n           :='';
v           :='';
a           :=nil;
a           :=str__new8;

//get
result      :=xpull(xoutpos,xout,n,a);
if result then v:=a.text;

//free
str__free(@a);

end;

procedure ttextcore.xnoidle;
begin
iidleref:=slowms64+ic_idlepause;
end;

procedure ttextcore.knoidle;
begin
ik_idleref:=slowms64+ic_idlepause;
end;

procedure ttextcore.cread;
var
   xpos:longint;
   xchar:tfastchar;
begin

//check
xpos        :=frcmin32(icursorpos-1,0);
if not xslowchar(xpos,1,xchar) then exit;

//get
icurrentinfo.name         :=tlist[xchar.wid].name;
icurrentinfo.size         :=tlist[xchar.wid].size;
icurrentinfo.bold         :=tlist[xchar.wid].bold;
icurrentinfo.italic       :=tlist[xchar.wid].italic;
icurrentinfo.underline    :=tlist[xchar.wid].underline;
icurrentinfo.strikeout    :=tlist[xchar.wid].strikeout;
icurrentinfo.color        :=tlist[xchar.wid].color;
icurrentinfo.bgcolor      :=tlist[xchar.wid].bgcolor;
icurrentinfo.brcolor      :=tlist[xchar.wid].brcolor;
icurrentinfo.align        :=tlist[xchar.wid].align;

end;

procedure ttextcore.cwritesel__hasUndo(const xselModifierCode:longint);
begin

mstore1;
iundoinfo.style:=musSelKeep;
mstore1;
cwritesel(xselModifierCode);//28jun2022

end;

procedure ttextcore.cwritesel(const xselModifierCode:longint);
var
   ff:tfastfont;
   fc:tfastchar;
   int1,p,xlastwid,xselstart,xselcount:longint;
   wrd2:twrd2;
   xmustchange,xtxt,ximg:boolean;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

begin

//init
xmustchange           :=false;
xselstart             :=selstart;
xselcount             :=selcount;

//check
if (xselcount<=0) or (xselmodifiercode<0) or (xselmodifiercode>smMax) then exit;

//init
xfastcharInit(ff);

//get
xlastwid              :=-1;//not set
wrd2.val              :=maxword;//not set

//04jun2020
for p:=xselstart to (xselstart+xselcount-1) do
begin

if not xfastchar(ff,p,1,fc) then break;//17mar2025: 200% faster

xtxt                  :=(fc.cs=wc_t);
ximg                  :=(fc.cs=wc_i);

if (xtxt or ximg) then
   begin

   //data changers - 19dec2021
   if xtxt then
      begin

      if (xselmodifiercode=smUppercase)  then//13feb2026, 19dec2021
         begin

         int1:=idata.byt1[p-1];

         if (int1>=97) and (int1<=122) then
            begin

            idata.byt1[p-1]:=int1-32;
            xmustchange:=true;

            end;

         end
      else if (xselmodifiercode=smLowercase)  then//13feb2026, 19dec2021
         begin

         int1:=idata.byt1[p-1];

         if (int1>=65) and (int1<=90) then
            begin

            idata.byt1[p-1]:=int1+32;
            xmustchange:=true;

            end;

         end;
      end;

   //get
   if (fc.wid<>xlastwid) then
      begin

      //store current "wid"
      xlastwid:=fc.wid;
      wrd2.val:=fc.wid;

      //merge new font+style
      if xtxt then
         begin

         case xselmodifiercode of
         smFontname             :wrd2.val:=xmakefont2(true,icurrentinfo.name,tv.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
         smFontsize             :wrd2.val:=xmakefont2(true,tv.name,icurrentinfo.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
         smBold                 :wrd2.val:=xmakefont2(true,tv.name,tv.size,tv.color,tv.bgcolor,tv.brcolor,icurrentinfo.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
         smItalic               :wrd2.val:=xmakefont2(true,tv.name,tv.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,icurrentinfo.italic,tv.underline,tv.strikeout,tv.align);
         smUnderline            :wrd2.val:=xmakefont2(true,tv.name,tv.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,icurrentinfo.underline,tv.strikeout,tv.align);
         smStrikeout            :wrd2.val:=xmakefont2(true,tv.name,tv.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,icurrentinfo.strikeout,tv.align);
         smColor                :wrd2.val:=xmakefont2(true,tv.name,tv.size,icurrentinfo.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
         smBgcolor              :wrd2.val:=xmakefont2(true,tv.name,tv.size,tv.color,icurrentinfo.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
         smBrcolor              :wrd2.val:=xmakefont2(true,tv.name,tv.size,tv.color,tv.bgcolor,icurrentinfo.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
         smColor_Bgcolor        :wrd2.val:=xmakefont2(true,tv.name,tv.size,icurrentinfo.color,icurrentinfo.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
         smColor_Bgcolor_Style  :wrd2.val:=xmakefont2(true,tv.name,tv.size,icurrentinfo.color,icurrentinfo.bgcolor,icurrentinfo.brcolor,icurrentinfo.bold,icurrentinfo.italic,icurrentinfo.underline,icurrentinfo.strikeout,tv.align);
         smUppercase            :;//nil
         smLowercase            :;//nil
         else                   break;//unknown style -> quit
         end;//case

         end;//txt

      end;//wid check

   //set
   if xtxt and (fc.wid<>wrd2.val) then
      begin

      idata2.byt1[p-1]    :=wrd2.bytes[0];
      idata3.byt1[p-1]    :=wrd2.bytes[1];
      xmustchange         :=true;

      end;

   end;

end;//p

if xmustchange then contentChangedFrom( xselStart );

end;

procedure ttextcore.contentChangedAll;//26mar2026
begin

xwrapall;
itimer_chklinecursorx:=true;
xincdata3;
xchanged;

end;


procedure ttextcore.contentChangedFrom(const xselStart:longint);//26mar2026
begin

contentChangedFromLen( xselStart ,0 );

end;

procedure ttextcore.contentChangedFromLen(const xselStart,xContentLen:longint);//26mar2026
begin

xwrapadd( xlinebefore(xselStart) ,xselStart + xContentLen + ic_bigwrap );//need to wrap ATLEAST current page, else flicker may occur due to multiple paint attempts - 07dec2019
itimer_chklinecursorx:=true;
xincdata3;
xchanged;

end;

procedure ttextcore.makesmaller;
begin
cwriteall(ftmSmaller,nil);
end;

procedure ttextcore.makelarger;
begin
cwriteall(ftmLarger,nil);
end;

procedure ttextcore.cwriteall(const xfullStreamModifierCode:longint;xmask:tstr8);//09mar2025, 28aug2021, 05jun2020
var
   ff:tfastfont;
   fc:tfastchar;
   xmaskv,p,xlastwid:longint;
   wrd2:twrd2;
   xapplybymask,xmustchange,xtxt,ximg:boolean;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

   function cv:ptextinfo;
   begin
   result:=@icurrentinfo;
   end;

begin

//check
if (xfullStreamModifierCode=ftmApplyMask) and (xmask=nil) then exit;

//init
xmustchange           :=false;
xlastwid              :=-1;//not set
wrd2.val              :=maxword;//not set
xapplybymask          :=(xmask<>nil);
xmaskv                :=0;
xfastcharInit(ff);

//get
for p:=1 to xlen32 do
begin

if not xfastchar(ff,p,1,fc) then break;//17mar2025: 200% faster

xtxt                  :=(fc.cs=wc_t);
ximg                  :=(fc.cs=wc_i);

//.text only
if xtxt then//08jun2020
   begin

   //read mask value -> if value has changed from last then FORCE an update - 15mar2025
   if xapplybymask and low__setint(xmaskv,xmask.bytes1[p]) then xlastwid:=maxword;

   //get
   if (fc.wid<>xlastwid) then
      begin

      //store current "wid"
      xlastwid        :=fc.wid;
      wrd2.val        :=fc.wid;
      //merge new font+style

      //.basic translators
      case xfullStreamModifierCode of

      ftmArial              :wrd2.val:=xmakefont2(true,'arial'       ,tv.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
      ftmCourier            :wrd2.val:=xmakefont2(true,'courier new' ,tv.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
      ftmSmaller            :wrd2.val:=xmakefont2(true,tv.name       ,frcmin32(tv.size-1,6),tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);
      ftmLarger             :wrd2.val:=xmakefont2(true,tv.name       ,frcmax32(tv.size+1,48),tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);

      ftmApplyMask:begin//by mask - 15mar2025 - requires constant updating

         case xmaskv of
         llh,llb,lli,llu,lls,lll,llc,llr:begin

             wrd2.val:=xmakefont2(true,tv.name,tv.size,
               low__aorb(tv.color,cv.bgcolor,xmaskv=llh),//text color
               low__aorb(tv.bgcolor,cv.color,xmaskv=llh),//background color
               tv.brcolor,
               low__aorbbol(tv.bold,true,xmaskv=llb),
               low__aorbbol(tv.italic,true,xmaskv=lli),
               low__aorbbol(tv.underline,true,xmaskv=llu),
               low__aorbbol(tv.strikeout,true,xmaskv=lls),
               low__aorb(tv.align,0+insint(1,xmaskv=llc)+insint(2,xmaskv=llr),(xmaskv=lll) or (xmaskv=llc) or (xmaskv=llr))
               );

            end;

         end;//case

         end;//begin

      else break;//unknown style -> quit

      end;//case

      end;//wid

   //set - fast write -> writes the cache value without having to read/check each time
   if (fc.wid<>wrd2.val) then
      begin

      idata2.byt1[p-1]    :=wrd2.bytes[0];
      idata3.byt1[p-1]    :=wrd2.bytes[1];
      xmustchange         :=true;

      end;

   end;

end;//p

//finish
if xmustchange then contentChangedAll;

//free
str__uaf(@xmask);

end;

procedure ttextcore.xsetcursorpos2(xpos:longint;xshift:boolean);
var
   int1:longint;
begin

xpos:=frcrange32(xpos,1,xlen32);

if (icursorpos<>xpos) or (icursorpos2<>xpos) then
   begin

   icursorpos         :=xpos;
   if not xshift then icursorpos2:=xpos;

   itimer_chklinecursorx:=true;//update cursor x pos -> used for key up an down on same column between lines - 31mar2021

   int1:=xpos+ic_pagewrap;

   if (int1>iwrapcount) then
      begin

      iwrapstack.addint4(iwrapcount);
      iwrapstack.addint4(int1);//same as "xwrapadd('auto',*,xpos+page);"

      end;

   inc(ivcheck);//make system check to see if the contents needs to scroll up or down based on the text cursor - 25jul2021
   imustpaint:=true;

   end;

//current read
cread;

end;

procedure ttextcore.xsetcursorpos(const xpos:longint);
begin
xsetcursorpos2(xpos,false);
end;

function ttextcore.xstackpull(xstack,xval:tstr8):boolean;
var//supports variable size entry lengths
   xlen:longint;
begin

//defaults
result      :=false;

//check
if (xstack=nil) or (xval=nil) then exit;

//init
xval.clear;

//get
if (blen32(xstack)>=4) then
   begin

   xlen     :=frcmin32(xstack.int4[0],0);//0..3

   if (xlen>=1) and (xval<>nil) then xval.add3(xstack,4,xlen);
   bdel1(xstack,1,4+xlen);

   result   :=true;

   end;

end;

function ttextcore.xwrappull(var xpos,xpos2:longint):boolean;
begin

//defaults
result      :=false;
xpos        :=-1;
xpos2       :=-1;

//get
if (blen32(iwrapstack)>=8) then
   begin

   xpos     :=iwrapstack.int4[0];//0..3
   xpos2    :=iwrapstack.int4[4];//4..7

   bdel1(iwrapstack,1,8);

   result   :=true;

   end;

end;

function ttextcore.xsafeListItem(const xindex:longint):longint;//13feb2026
begin

if      (xindex<0)                then result:=0
else if (xindex>textcore_listmax) then result:=textcore_listmax
else                                   result:=xindex;

end;

function ttextcore.xfindstyle(const x:byte):byte;//21aug2020
begin

case x of
9,10,32..255 :result:=wc_t;//text
0            :result:=wc_i;//image
else          result:=wc_n;//nil -> unknown
end;//case

end;

procedure ttextcore.xdelsel2(const xmoveto:boolean);
var
   int1,int2:longint;
begin

//init
int1        :=selstart;
int2        :=selcount;

//check
if (int2<1) then exit;

//get
bdel1(idata ,int1,int2);
bdel1(idata2,int1,int2);
bdel1(idata3,int1,int2);

xmincheck;
xsetcursorpos(int1);

if xmoveto then icursor_keyboard_moveto:=int1;

contentChangedFrom( int1 );//26mar2026

end;

procedure ttextcore.xdelsel;
begin
xdelsel2(true);
end;

function ttextcore.xmakeimage2(const ximgdata:tstr8;const xsysTEP:longint):longint;
label
   skipend;
var
   e:string;
   dw,dh,xnew,p:longint;
begin

//defaults
result      :=0;
xnew        :=-1;

//check
if not str__lock(@ximgdata) then exit;

//find existing
for p:=0 to textcore_listmax do if (ilist[p].orgdata<>nil) and (ilist[p].orgdata.len>=1) and (ilist[p].sysTEP=xsysTEP) and ilist[p].orgdata.same(ximgdata) then
   begin

   result   :=p;
   goto skipend;

   end;//p

//find free
if (xnew<0) then for p:=0 to textcore_listmax do if (ilist[p].orgdata=nil) or (ilist[p].orgdata.len<=0) then
   begin

   xnew     :=p;
   break;

   end;//p

//emergency limit -> we need to find items that are nolonger being pointed to and reuse them before just parking it here at the uppermost limit - 21aug2019
if (xnew<0) then xnew:=textcore_listmax;

//get
result      :=xnew;

if (ilist[result].orgdata=nil) then ilist[result].orgdata:=str__new8;

//check
if (imaxformatlevel>=fmlBWP) then ilist[result].orgdata.replace:=ximgdata else ilist[result].orgdata.replace:=nil;//#1 - store

ilist[result].trans   :=false;
ilist[result].w       :=1;
ilist[result].h       :=1;
ilist[result].sysTEP  :=xsysTEP;//used to display system TEP instead of actual image -> permitts realtime system color change/update -> live usage only = not saved/stored - 25mar2026

//.convert to "img32.tbasicimage" - 14feb2026
dw                    :=1;
dh                    :=1;
if (ilist[result].img32=nil) then ilist[result].img32:=misimg32(1,1);

//.get
case (imaxformatlevel>=fmlBWP) and mis__fromdata(ilist[result].img32,@ilist[result].orgdata,e) of
true:begin

   dw                   :=misw(ilist[result].img32);
   dh                   :=mish(ilist[result].img32);
   ilist[result].trans  :=ilist[result].img32.ai.transparent;//27dec2021

   end;
else begin;

   dw:=1;
   dh:=1;
   missize(ilist[result].img32,1,1);//once created DON'T destroy, but instead shrink for maximum stability - 21aug2020

   end;
end;//case

//sync width & height
ilist[result].w       :=frcmin32(dw,1);
ilist[result].h       :=frcmin32(dh,1);

//changed
xincdata3;
xchanged;

skipend:

//free
str__uaf(@ximgdata);//28jan2021

end;

function ttextcore.canclearall:boolean;
begin
result:=xcanclear('clearall');
end;

function ttextcore.canclear:boolean;
begin
result:=xcanclear('clear');
end;

function ttextcore.canclear2:boolean;
begin
result:=xcanclear('clear2');
end;

procedure ttextcore.clear;
begin
xclear('clear');
end;

procedure ttextcore.clear2;
begin
xclear('clear2');
end;

procedure ttextcore.clearall;
begin
xclear('clearall');
end;

function ttextcore.xcanclear(const xstyle:string):boolean;
begin
result:=(xstyle='clearall') or (xstyle='clear') or (xstyle='clear2');
end;

procedure ttextcore.xclear(xstyle:string);
var
   p:longint;
begin

//init
xstyle                :=strlow(xstyle);

//check
if not xcanclear(xstyle) then exit;//Note: clear2 does NOT wipe undo

//.doing this first PREVENTS memory consumption from climbing - 27sep2022
mstore1;//previous
icursorpos            :=1;
icursorpos2           :=blen32(idata);//32
iundoinfo.style       :=musSel;

mstore1;
cdefault;

//.clear everything - 27sep2022
iwidestline           :=0;//12mar2021
idata .replacebyt1    :=10;
idata2.replacebyt1    :=0;
idata3.replacebyt1    :=0;//14feb2026

for p:=0 to textcore_listmax do
begin

if (fslot[p]<>res_nil) then res__font( fslot[p] ).clear;//once created don't destroy, shrink only -> max. stability - 21aug2020

fref[p]               :='';
tlist[p].name         :='';

if (ilist[p].orgdata<>nil) then ilist[p].orgdata.clear;
if (ilist[p].img32<>nil)   then ilist[p].img32.sizeto(1,1);

ilist[p].sysTEP       :=-1;//not in use

end;//p

//.current defaults - 05jul2022
cdefault;

//finalise
icursorpos            :=1;
icursorpos2           :=1;
itotalheight          :=0;//07feb2023
ilinecount            :=0;
iline                 :=0;
icol                  :=0;
idataid               :=0;
imodified             :=false;
iwrapcount            :=0;
iwrapstack.clear;
imustpaint            :=true;

//.reference
ibwd_color            :=clnone;
ibwd_color2           :=clnone;
ibwd_bk               :=clnone;

//.undo clear
if (xstyle='clearall') or (xstyle='clear') then mclear(true);

end;

procedure ttextcore.xnil3(var v1,v2,v3:tstr8);
begin

v1:=nil;
v2:=nil;
v3:=nil;

end;

procedure ttextcore.xmake3(var v1,v2,v3:tstr8);
begin

v1:=str__new8;
v2:=str__new8;
v3:=str__new8;

end;

procedure ttextcore.xfree3(var v1,v2,v3:tstr8);
begin

str__free(@v1);
str__free(@v2);
str__free(@v3);

end;

procedure ttextcore.xinstext(const x:string);
begin
xinstext2(x,false);
end;

procedure ttextcore.xinstext2(const x:string;const xoverrideReadonly:boolean);
var
   a:tstr8;
begin

//defaults
a           :=nil;

//get
try
a           :=rescache__newStr8;
a.text      :=x;

xins2(a,xoverrideReadonly);

except;end;

//free
rescache__delStr8(@a);

end;

procedure ttextcore.xins(x:tstr8);
begin
xins2(x,false);
end;

procedure ttextcore.xfilterText(x:tstr8);
begin
text__filterText(x);
end;

procedure ttextcore.xins2(x:tstr8;const xoverrideReadonly2:boolean);
var
   c:byte;
   p,xselstart,int2:longint;
   xstr1,xstr2,xstr3:tstr8;
   wrd2:twrd2;
begin

//check
if ireadonly and (not xoverrideReadonly2) then exit;

//init
xnoidle;
knoidle;
xselstart             :=selstart;
xnil3(xstr1,xstr2,xstr3);

//flush redo list - 02may2023
mredoflush;

//filter text -> remove any characters in the system range
xfilterText(x);

//check
if (iundoinfo.style<>musIns) or (xselstart<>(iundoinfo.from1+iundoinfo.len)) then
   begin

   mstore1;

   iundoinfo.style    :=musIns;
   iundoinfo.from1    :=xselstart;
   iundoinfo.len      :=0;

   end;

//get
if (selcount>=1) then
   begin

   iundoinfo.style    :=musSel;
   mstore1;

   end;

//insert text
if (blen32(x)>=1) then
   begin

   if (iundoinfo.style<>musIns) then
      begin

      iundoinfo.style :=musIns;
      iundoinfo.from1 :=xselstart;
      iundoinfo.len   :=0;

      end;

   try

   //make3
   xmake3(xstr1,xstr2,xstr3);
   xstr1.replace      :=x;
   xstr2.replace      :=x;
   xstr3.replace      :=x;

   //get
   wrd2.val           :=xmakefont;//once only

   for p:=1 to blen32(xstr1) do
   begin             //32

   c                  :=xstr1.byt1[p-1];//was: str1[p];

   if (xfindstyle(c)<>wc_t) then c:=63;//'?';

   xstr1.byt1[p-1]    :=c;
   xstr2.byt1[p-1]    :=wrd2.bytes[0];
   xstr3.byt1[p-1]    :=wrd2.bytes[1];

   end;//p

   //get
   xmincheck;

   inc(iundoinfo.len,blen32(xstr1));
   int2               :=icursorpos;

   idata .ins(xstr1,int2-1);  //was: insert(str1,x.data ,int2);
   idata2.ins(xstr2,int2-1);  //was: insert(str2,x.data2,int2);
   idata3.ins(xstr3,int2-1);  //was: insert(str3,x.data3,int2);

   xsetcursorpos(int2+blen32(xstr1));

   contentChangedFromLen( int2 ,blen32(xstr1) );//26mar2026

   except;end;

   //free
   xfree3(xstr1,xstr2,xstr3);

   end;

end;

procedure ttextcore.xinsimg(const x:tstr8);
begin
xinsimg2(x,-1,false,false);
end;

procedure ttextcore.xinsimg2(const x:tstr8;const xsysTEP:longint;const xnoUndo,xforce:boolean);
var
   xstr1,xstr2,xstr3:tstr8;
   wrd2:twrd2;
   int2:longint;
begin

//check
if ireadonly or (imaxformatlevel<fmlBWP) then
   begin

   if (not xforce) then exit;

   end;

//init
xnoidle;
knoidle;
xnil3(xstr1,xstr2,xstr3);

//undo + insert image
if (blen32(x)>=1) then
   begin

   try

   //init
   xmake3(xstr1,xstr2,xstr3);
   xstr1.replacebyt1  :=0;

   wrd2.val           :=xmakeimage2(x ,xsysTEP );

   xstr2.replacebyt1  :=wrd2.bytes[0];
   xstr3.replacebyt1  :=wrd2.bytes[1];

   //get
   xmincheck;
   int2               :=selstart;

   //m-undo
   if (not xnoUndo) then
      begin

      //flush redo list - 02may2023
      mredoflush;

      mstore1;//previous

      if (selcount>=1) then
         begin

         iundoinfo.style:=musSel;
         mstore1;

         end;

      iundoinfo.style :=musInsImg;
      iundoinfo.from1 :=int2;
      iundoinfo.len   :=1;//1 byte for the image in the datastream below - 02jul2022

      end;

   idata .ins(xstr1,int2-1);
   idata2.ins(xstr2,int2-1);
   idata3.ins(xstr3,int2-1);

   xsetcursorpos(int2+blen32(xstr1));//32

   contentChangedFromLen( int2 ,blen32(xstr1) );//26mar2026

   except;end;

   //free
   xfree3(xstr1,xstr2,xstr3);//14feb2026

   end;

end;

procedure ttextcore.iosettxt(x:tstr8);
begin
iosetdata(x);
end;

procedure ttextcore.iosetrtf(x:tstr8);
begin
iosetdata(x);
end;

procedure ttextcore.iosetdic(x:tstr8);
begin
iosetdata2(x,'dic');
end;

procedure ttextcore.iosetbwd(x:tstr8);
begin
iosetdata(x);
end;

procedure ttextcore.iosetbwp(x:tstr8);
begin
iosetdata(x);
end;

procedure ttextcore.iosethtm(x:tstr8);
begin
iosetdata(x);
end;

procedure ttextcore.iosetdata(x:tstr8);
begin
xsetdata(x,'',sioIOset);
end;

procedure ttextcore.iosetdata2(x:tstr8;const xformat:string);
begin
xsetdata(x,xformat,sioIOset);
end;

function ttextcore.iogettxt(x:tstr8):boolean;
begin
result:=iogetdata(x,'txt');
end;

function ttextcore.iogetbwd(x:tstr8):boolean;
begin
result:=iogetdata(x,'bwd');
end;

function ttextcore.iogetbwp(x:tstr8):boolean;
begin
result:=iogetdata(x,'bwp');
end;

function ttextcore.iogethtm(x:tstr8):boolean;
begin
result:=iogetdata(x,'htm');
end;

function ttextcore.iogetdata(x:tstr8;const xformat:string):boolean;
begin
xgetdata(x,xformat,1,xlen32);
end;

function ttextcore.iogetdata2(x:tstr8;const xformat:string;const xfrom,xto:longint):boolean;
begin
xgetdata(x,xformat,xfrom,xto);
end;

procedure ttextcore.xioset(x:tstr8);
begin
xsetdata(x,'',sioIOset);
end;

procedure ttextcore.xioins(x:tstr8);
begin
xsetdata(x,'',sioIOins);
end;

procedure ttextcore.xioins__noundo(x:tstr8);
begin
xsetdata(x,'',sioIOins_noundo);
end;

procedure ttextcore.xsetdata(x:tstr8;xformat:string;const xmode:longint);
label
   skipend;
var
   v:ttextio;
   int1,int2,int3:longint;
begin//Note: ioset=replace current content with new one, ioins=insert at cursorpos (deletes current selection)

//defaults
v           :=nil;

//check
if not str__lock(@x)           then goto skipend;
if (xmode<0) or (xmode>sioMax) then goto skipend;

try

//init
v           :=ttextio.create;
v.iostream  :=x;
v.full      :=(xmode=sioIOset);

if (xformat='') then xformat:=strlow(io__anyformatb(@x));

xmincheck;

//clear
if (xmode=sioIOset) then clear2;

//get
if      (xformat='txt')   then xread__txt(v)
else if (xformat='bwd')   then xread__bwd(v)
else if (xformat='bwp')   then xread__bwp(v)
else if (xformat='dic')   then xread__dic(v)
else if (xformat='rtf')   then xread__rtf(v)
else if (xformat='pdf')   then xread__pdf(v)
else if (xformat='htm')   then
   begin

   case icaneditHTML of
   true:xread__htm(v);
   else xread__txt(v);
   end;//case

   end
else if (xformat='md')    then
   begin

   case icaneditMD of
   true:xread__md(v);
   else xread__txt(v);
   end;//case

   end

else xread__txt(v);


//set -> insert the 3 streams and update ---------------------------------
if (blen32(v.data)>=1) then
   begin

   if(xmode=sioIOins) or (xmode=sioIOins_noundo) then
      begin

      //m-undo
      if (xmode=sioIOins) then
         begin

         //flush redo list - 02may2023
         mredoflush;

         mstore1;//previous
         iundoinfo.style:=musSel;
         mstore1;

         end;

      //delete existing selection
      if (selcount>=1) then xdelsel2( blen32(x)<=0 );//don't set "*_moveto" when inserting one or more characters - 02sep2019

      end;

   //init
   xmincheck;
   int1     :=xlen32;
   int2     :=icursorpos;

   //m-undo - 03jul2022
   if (xmode=sioIOins) then
      begin

      if (iundoinfo.style<>musIns) then
         begin

         mstore1;
         iundoinfo.style  :=musIns;
         iundoinfo.from1  :=int2;
         iundoinfo.len    :=blen32(v.data);

         end;

      end;

   //insert data streams
   idata .ins(v.data  ,int2-1);
   idata2.ins(v.data2 ,int2-1);
   idata3.ins(v.data3 ,int2-1);

   xmincheck;

   //.trim trailing second #10 -> prevents continuous appending of a single #10 each time "ioset" is called - 29feb2020
   if (xmode=sioIOset) and (xlen32>=2) and idata.asame3(xlen32-2,[10,10],false) then
      begin       //32

      int3         :=xlen32;
      bdel1(idata  ,int3,1);
      bdel1(idata2 ,int3,1);
      bdel1(idata3 ,int3,1);

      end;

   //.sync
   if (xmode<>sioIOset) then xsetcursorpos(int2+blen32(v.data));

   contentChangedFromLen( int2 ,blen32(v.data) );//26mar2026

   end;

except;end;

skipend:

//free
freeobj(@v);
str__uaf(@x);

end;

procedure ttextcore.xread__bwd(const v:ttextio);
label
   skipend;

var
   i,int1,v1,v2,p,dlen,tlen,slen,xcolor,xcolor2,xbgcolor,xfontsize,xpos:longint;
   xfontname,dn,dv:string;
   xbold,xitalic,xunderline,xstrikeout,xswap,xusecolor2:boolean;
   xlist:pdllongint;
   wrd2:twrd2;

   function xpull1:boolean;
   begin

   result:=xpullstr(xpos,v.iostream,dn,dv);

   if not result then
      begin

      dn:='';
      dv:='';

      end;

   end;

   function xpull2(var dv:tstr8):boolean;
   begin

   result:=xpull(xpos,v.iostream,dn,dv);

   if not result then
      begin

      dn:='';
      dv.clear;

      end;

   end;

begin

//defaults
xpos        :=1;
dlen        :=0;
slen        :=0;

//header
if (not xpull1) or (not strmatch(dn,'BWD1')) then goto skipend;

//info
if (not xpull2(v.tmp1)) or (not strmatch(dn,'info')) then goto skipend;
v.vars.data:=v.tmp1;
v.tmp1.clear;

//init
xfontname   :=strdefb(v.vars.s['fontname'],font__name1);
xfontsize   :=font__safesize(strint32(strdefb(v.vars.s['fontsize'],'12')));

xcolor      :=strint32(strdefb(v.vars.s['fontcolor'] ,'0'));//black
xcolor2     :=strint32(strdefb(v.vars.s['fontcolor2'],'255'));//red
xbgcolor    :=strint32(strdefb(v.vars.s['bgcolor'],intstr32(int_255_255_255)));//white

if v.full then ipagecolor:=xbgcolor;

//.store reference info
ibwd_color  :=xcolor;
ibwd_color2 :=xcolor2;
ibwd_bk     :=xbgcolor;

//.font
if (not xpull1) or (not strmatch(dn,'font')) then goto skipend;

//.text
if (not xpull2(v.data)) or (not strmatch(dn,'text')) then goto skipend;

//.style
if (not xpull2(v.tmp1)) or (not strmatch(dn,'styl')) then goto skipend;

//filter out reserved chars
if (blen32(v.data)>=1) then
   begin

   tlen     :=blen32(v.data);//text len
   slen     :=blen32(v.tmp1);//style len

   for p:=1 to tlen do
   begin

   v1       :=v.data.pbytes[p-1];

   if (v1=9) or (v1=10) or (v1>=32) then
      begin

      inc(dlen);
      if (dlen<tlen) then v.data.pbytes[dlen-1]:=v.data.pbytes[p-1];
      if (dlen<slen) then v.tmp1.pbytes[dlen-1]:=v.tmp1.pbytes[p-1];

      end;

   end;//p

   //trim
   if (dlen<tlen) then v.data.setlen(dlen);//text
   if (dlen<slen) then v.tmp1.setlen(dlen);//style

   end;

//init
if (dlen>=1) then
   begin

   v.tmp2.setlen((textcore_listmax+1)*sizeof(longint));

   xlist    :=v.tmp2.pints4;//was: xlist:=pointer(longint(str6));

   for p:=0 to textcore_listmax do xlist[p]:=-1;//not set - track all font-style combinations -> allows us to quickly check if we need to create a new font

   v.data2.setlen(dlen);
   v.data3.setlen(dlen);

   //convert style stream
   for p:=1 to dlen do
   begin

   //.read the BWD1 style
   if (p<=slen) then i:=v.tmp1.pbytes[p-1] else i:=0;
   if (i<0)     then i:=0                  else if (i>textcore_listmax) then i:=textcore_listmax;//range - 22aug2020

   //.format filter
   if (imaxformatlevel<=0) then i:=0;

   //.make font
   if (xlist[i]=-1) then
      begin

      //read style
      int1            :=i;
      xbold           :=false;
      xitalic         :=false;
      xunderline      :=false;
      xstrikeout      :=false;
      xswap           :=false;
      xusecolor2      :=false;

      //get
      if (int1>=128) then dec(int1,128);

      if (int1>=64)  then dec(int1,64);

      if (int1>=32)  then
         begin

         xusecolor2   :=true;
         dec(int1,32);

         end;

      if (int1>=16) then
         begin

         xswap        :=true;
         dec(int1,16);

         end;

      if (int1>=8) then
         begin

         xstrikeout   :=true;
         dec(int1,8);

         end;

      if (int1>=4) then
         begin

         xunderline   :=true;
         dec(int1,4);

         end;

      if (int1>=2) then
         begin

         xitalic      :=true;
         dec(int1,2);

         end;

      if (int1>=1) then
         begin

         xbold        :=true;
         dec(int1,1);

         end;

      //create font
      if xusecolor2 and xswap then
         begin
         v1:=xbgcolor;
         v2:=xcolor2;
         end
      else if xswap then
         begin
         v1:=xbgcolor;
         v2:=xcolor;
         end
      else if xusecolor2 then
         begin
         v1:=xcolor2;
         v2:=clnone;
         end
      else
         begin
         v1:=xcolor;
         v2:=clnone;
         end;

      xlist[i]:=xmakefont2(true,xfontname,xfontsize,v1,v2,clnone,xbold,xitalic,xunderline,xstrikeout,0);

      end;//i

   //.apply font
   wrd2.val               :=xlist[i];//id that points to text-font
   v.data2.pbytes[p-1]    :=wrd2.bytes[0];
   v.data3.pbytes[p-1]    :=wrd2.bytes[1];

   end;//p

   end;//if

skipend:

end;

procedure ttextcore.xread__bwp(const v:ttextio);
label
   skipend;

var
   xalign,xfontsize,xcolor,xbgcolor,xbrcolor,xid,v32,int1,int3,p,dlen,xpos:longint;
   xfontname,vn1,dn,dv:string;
   xlist,xlisti:pdllongint;
   wrd2:twrd2;
   ximgdata:tstr8;
   xsyscols,xbold,xitalic,xunderline,xstrikeout:boolean;
   xint4:tint4;

   function xpull1:boolean;
   begin

   result:=xpullstr(xpos,v.iostream,dn,dv);

   if not result then
      begin

      dn:='';
      dv:='';

      end;

   end;

   function xpull2(var dv:tstr8):boolean;
   begin

   result:=xpull(xpos,v.iostream,dn,dv);

   if not result then
      begin

      dn:='';
      dv.clear;

      end;

   end;

begin

//defaults
xpos        :=1;
dlen        :=0;
ximgdata    :=nil;

try


//header
if (not xpull1) or (not strmatch(dn,'BWP1')) then goto skipend;

v.tmp2.setlen((textcore_listmax+1)*sizeof(longint32));
xlist       :=v.tmp2.pints4;

for p:=0 to textcore_listmax do xlist[p]:=p;//1-to-1 mapping to start with -> used to merge inbound items with current items (when ioins etc) -> e.g. image99 "i99" might map to "i303", therefore all inbound x.wid[]'s "part1&2" must be changed from i99 to i303 to reflect the changes - 05sep2019


//init
ximgdata    :=rescache__newStr8;


//info -> include only the settings we can comfortably provide - BW will fill in the res as needed - 04sep2019
if (not xpull2(v.tmp2)) or (not strmatch(dn,'info')) then goto skipend;

if v.full then
   begin

   v.vars.data        :=v.tmp2;
   ilandscape         :=v.vars.b['landscape'];

   if not iwrapreadonly then iwrapstyle:=frcrange32(strint32(strdefb(v.vars.s['wrapstyle'],intstr32(wwsWindow))),0,wwsMax);

   ipagecolor         :=strint32(strdefb(v.vars.s['bgcolor'],intstr32(int_255_255_255)));//white

   xpagewidth;
   xpageheight;
   xwrap_hvsync_changed;

   end;


//data -------------------------------------------------------------------------
if (not xpull2(v.tmp2)) or (not strmatch(dn,'data')) then goto skipend;

int1:=blen32(v.tmp2) div 3;

if (int1>=1) then
   begin

   //init
   v.data. setlen(int1);
   v.data2.setlen(int1);
   v.data3.setlen(int1);

   //get
   for p:=1 to int1 do
   begin

   int3:=(p*3)-2;

   v.data .pbytes[p-1]:=v.tmp2.pbytes[int3+0-1];//text

   //.wid's "part1&2" may need to be remapped further down
   v.data2.pbytes[p-1]:=v.tmp2.pbytes[int3+1-1];//id.part1
   v.data3.pbytes[p-1]:=v.tmp2.pbytes[int3+2-1];//id.part2

   end;//p

   end;//if


//list -------------------------------------------------------------------------
//special note: any stored LGF fonts will be first in the list (legacy - nolonger used) - 28feb2026

//init
if (not xpull1) or (not strmatch(dn,'list')) then goto skipend;

v.tmp3.setlen((textcore_listmax+1)*sizeof(longint32));
v.tmp2.setlen((textcore_listmax+1)*sizeof(longint32));

xlist       :=v.tmp3.pints4;
xlisti      :=v.tmp2.pints4;

for p:=0 to textcore_listmax do
begin

xlist [p]   :=p;//use to "remap" incoming resources to target slots in resource cache
xlisti[p]   :=p;

//was: if zzok(xlist2[p],7062) then str__free(@xlist2[p]);//use to temp-store any included LGF fonts

end;

//get
vn1        :='';
v32        :=0;

while true do
begin

if not xpull2(v.tmp1) then break;//don't raise error -> attempt to continue

//.begin
if      (dn='lise') then break//list end
else if (dn='begi') then
   begin

   vn1:=bgetstr1(v.tmp1,1,1);//"t"(text) or "i"(image) or "f"(LGF font - optional)
   v32:=xsafeListItem(strint32(bgetstr1(v.tmp1,2,v.tmp1.len32)));//32

   //.text defaults
   xid                :=0;
   xbrcolor           :=clnone;
   xbgcolor           :=clnone;
   xcolor             :=0;
   xfontsize          :=xscale__px1(12,7);
   xfontname          :=font__name1;
   xbold              :=false;
   xitalic            :=false;
   xunderline         :=false;
   xstrikeout         :=false;
   xalign             :=wcaLeft;//left

   //.image defaults
   ximgdata.clear;
   xsyscols           :=false;//25may2025

   end

//.font values
else if (dn='_fds') then
   begin

{
   if (imaxformatlevel>=fmlBWP) then
      begin
      if zznil(xlist2[int4],2242) then xlist2[int4]:=str__new8;
      xlist2[int4].replace:=xstr4;//these are done first before any text, so they can be temp-stored in "xlist2" for access with text values
      end;
{}//?????????
   end
   
//.text values
else if (dn='_tid') then xid:=xsafeListItem(v.tmp1.int4[0])
else if (dn='_brc') then
   begin

   if (imaxformatlevel>=fmlBWP) then xbrcolor:=v.tmp1.int4[0];

   end
else if (dn='_bkc') then
   begin

   if (imaxformatlevel>=fmlBWP) then xbgcolor:=v.tmp1.int4[0];

   end
else if (dn='_fcl') then
   begin

   if (imaxformatlevel>=fmlBWP) then xcolor:=v.tmp1.int4[0];

   end
else if (dn='_fsz') then
   begin

   if (imaxformatlevel>=fmlBWP) then xfontsize:=font__safesize(v.tmp1.int4[0]);

   end
else if (dn='_fsy') then
   begin

   case (imaxformatlevel>=fmlBWD) of
   true:xint4.val:=v.tmp1.int4[0];
   else xint4.val:=0;
   end;//case

   xbold      :=(xint4.bytes[0]<>0);
   xitalic    :=(xint4.bytes[1]<>0);
   xunderline :=(xint4.bytes[2]<>0);
   xstrikeout :=(xint4.bytes[3]<>0);

   end
else if (dn='_fs2') then
   begin

   case (imaxformatlevel>=fmlBWD) of
   true:xalign:=frcrange32( tint4(v.tmp1.int4[0]).bytes[0] ,0,wcaMax);
   else xalign:=wcaLeft;
   end;//case

   end
else if (dn='_fnm') then
   begin

   if (imaxformatlevel>=fmlBWD) then xfontname:=strdefb(bstr(v.tmp1),font__name1) else xfontname:=font__name1;//12jun2022

   end

//.image values
else if (dn='_imd') then ximgdata.replace:=v.tmp1

//.image uses system colors
else if (dn='_scl') then xsyscols:=strbol(v.tmp1.text)//14feb2026

//.finalise
else if (dn='end!') then
   begin

   //.sourced from "begi"
   if (vn1='t') then
      begin

      //was:xlist[v32]:=xmakefont2(true,xlist2[xid],xfontname,xfontsize,xcolor,xbk,xborder,xbold,xitalic,xunderline,xstrikeout,xalign);
      xlist[v32]:=xmakefont2(true,xfontname,xfontsize,xcolor,xbgcolor,xbrcolor,xbold,xitalic,xunderline,xstrikeout,xalign);

      end
   else if (vn1='i') then
      begin

      xlisti[v32]:=xmakeimage2(ximgdata,-1);//25may2025
      ximgdata.clear;//reduce ram

      end;

   end;

end;//loop

//Remap All Inbound Resource IDS to their new values ---------------------
//Special Note: Both (t)ext and (i)mages can use the same id range (0..999)
//              but they don't overlap with their values, as each text/image
//              has it's own dedicated stack of values.
if (blen32(v.data)>=1) then for p:=1 to blen32(v.data) do
   begin                                  

   v32                :=xfindstyle(v.data.pbytes[p-1]);
   wrd2.bytes[0]      :=v.data2.pbytes[p-1];
   wrd2.bytes[1]      :=v.data3.pbytes[p-1];
   wrd2.val           :=xsafeListItem(wrd2.val);

   if (v32=wc_t) then
      begin

      //.id has been remapped -> write new id
      if (wrd2.val<>xlist[wrd2.val]) then
         begin

         wrd2.val              :=xlist[wrd2.val];
         v.data2.pbytes[p-1]   :=wrd2.bytes[0];
         v.data3.pbytes[p-1]   :=wrd2.bytes[1];

         end;

      end

   else if (v32=wc_i) then
      begin

      //.id has been remapped -> write new id
      if (wrd2.val<>xlisti[wrd2.val]) then
         begin

         wrd2.val              :=xlisti[wrd2.val];
         v.data2.pbytes[p-1]   :=wrd2.bytes[0];
         v.data3.pbytes[p-1]   :=wrd2.bytes[1];

         end;

      end;

   end;

skipend:
except;end;

//free
rescache__delStr8(@ximgdata);

end;

procedure ttextcore.xread__txt(const v:ttextio);//14feb2026
var
   p,l32:longint;
   wrd2:twrd2;
begin

//init
v.data.add(v.iostream);

//filter
xfiltertext(v.data);

//get
l32:=blen32(v.data);

if (l32>=1) then
   begin

   //init
   wrd2.val :=xmakefont;
   v.data2.setlen(l32);
   v.data3.setlen(l32);

   //get
   for p:=1 to l32 do
   begin

   v.data2.pbytes[p-1]:=wrd2.bytes[0];
   v.data3.pbytes[p-1]:=wrd2.bytes[1];

   end;//p

   end;

end;

procedure ttextcore.xread__dic(const v:ttextio);//17feb2026
begin

//clean and sort dictionary
xmodify__dic(@v.iostream);

//load
xread__txt(v);

end;

procedure ttextcore.xread__htm(const v:ttextio);
var
   s:tstr8;//pointer only
   bs,bf,xval32,xfindLP,p,p2,xhead,xstyle,xbody:longint;//0=not done, 1=aligning, 2=reading, 3=done
   z:byte;
   bol1,xbold,xitalic,xunderline,xstrikeout,xinsideBrackets:boolean;
   sname,xline,xval:string;

   function m(const p:longint;const n:string):boolean;
   begin
   result:=strmatch(n, s.str1[p,low__len32(n)] );
   end;

   function xhasval(const n:string):boolean;
   var
      n32,p,p2:longint;
   begin

   //defaults
   result   :=false;
   xval     :='';
   xval32   :=0;

   //check
   if (n='') then exit else n32:=low__len32(n);

   //find
   for p:=1 to low__len32(xline) do if (xline[p-1+stroffset]=n[stroffset]) and strmatch( strcopy1(xline,p,n32) ,n ) then
      begin

      for p2:=(p+n32) to low__len32(xline) do if (xline[p2-1+stroffset]=';') or (xline[p2-1+stroffset]='}') then
         begin

         xval    :=strcopy1(xline,p+n32,p2-p-n32) + #32;//force trailing space for easier searching
         xval32  :=strint32(xval);
         result  :=true;
         break;

         end;//p2

      result:=true;
      break;

      end;//p

   end;

   function mval(const n:string):boolean;
   begin
   result:=strmatch(n,xval);
   end;

   function mfindval(const n:string):boolean;
   var
      p,n32:longint;
   begin

   result   :=false;
   n32      :=low__len32(n);

   for p:=1 to low__len32(xval) do if strmatch( n, strcopy1(xval,p,n32) ) then
      begin

      result:=true;
      break;

      end;//p

   end;

begin

//init

//.utf8 -> 7bit text (0..127)
utf8__to7bitText(@v.iostream,@v.tmp1,false,false);

s                     :=v.tmp1;
xhead                 :=0;
xstyle                :=0;
xbody                 :=0;
xinsideBrackets       :=false;
xfindLP               :=1;
xline                 :='';
xval                  :='';
xval32                :=0;
bs                    :=1;
bf                    :=0;

//get

for p:=1 to s.len32 do
begin

z:=s.pbytes[p-1];

case z of
sslessthan:begin

   bs              :=p;
   xinsideBrackets :=true;

   end;
ssmorethan:begin

   bf              :=p;
   xinsideBrackets :=false;

   end;

end;//case


//.head ------------------------------------------------------------------------
case xhead of
0:if (z=sslessthan) and m(p,'<head>')  then xhead:=2;
2:if (z=sslessthan) and m(p,'</head>') then xhead:=3;
end;//case


//.style -----------------------------------------------------------------------
if (xhead=2) then
   begin

   case xstyle of
   0:if (z=sslessthan) and m(p,'<style') then xstyle:=1;

   1:if (z=ssmorethan) then
      begin

      xstyle    :=2;
      xfindLP   :=p+1;

      end;

   2:if (z=sslessthan) and m(p,'</style>') then xstyle:=3;
   end;//case

   //.read styles
   if (xstyle=2) and (not xinsideBrackets) then
      begin

      if (p>=xfindLP) then
         begin

         if (z=ssRCurlyBracket) then
            begin

            xline         :=strlow(s.str1[xfindLP,p-xfindLP+1]);
            sname         :='';

            for p2:=1 to low__len32(xline) do if (xline[p2-1+stroffset]='{') then sname:=stripwhitespace_lt(strcopy1(xline,1,p2-1));

            xbold         :=xhasval('font-weight:') and ( mfindval('bold ') or mfindval('bolder ') or (xval32>100) );
            xitalic       :=xhasval('font-style:')  and ( mfindval('italic ') );

            bol1          :=xhasval('text-decoration:');
            xunderline    :=bol1 and mfindval('underline ');
            xstrikeout    :=bol1 and mfindval('line-through ');

            //font name
            //font size
            xfindLP       :=p+1;

            end;

         end;

      end;

   end;


//.body ------------------------------------------------------------------------
case xbody of
0:if (z=sslessthan) and m(p,'<body')   then xbody:=1;

1:if (z=ssmorethan) then
      begin

      xbody     :=2;
      xfindLP   :=p+1;

      //turn off other tags
      xstyle    :=3;
      xhead     :=3;

      //reset bracket scanner
      bf        :=0;

      end;

2:if (z=sslessthan) and m(p,'</body>') then xbody:=3;
end;//case

if (xbody=2) then
   begin


   if (bf>=1) then
      begin

      xline:=s.str1[bs+1,bf-bs-1];

      //reset
      bf:=0;

      end;


   end;

end;//p

end;

procedure ttextcore.xread__md(const v:ttextio);
begin

end;

procedure ttextcore.xread__pdf(const v:ttextio);
begin

end;

procedure ttextcore.xread__rtf(const v:ttextio);
const
   n_nil              =0;
   n_char             =1;
   n_b                =2;
   n_b0               =3;
   n_i                =4;
   n_i0               =5;
   n_u                =6;
   n_u0               =7;
   n_s                =8;
   n_s0               =9;
   n_9                =10;
   n_10               =11;
   n_pic              =12;
   n_pard             =13;
   n_left             =14;
   n_center           =15;
   n_right            =16;
   n_h                =17;//highlight
   n_h0               =18;
   n_url              =19;
   
var
   a:tbasicimage;
   n,v32,xbracketDepth,xpos,l32,xsize,xcolor,xalign,xlastid,p:longint;
   xpardStart,xpardON,xbold,xitalic,xunderline,xstrikeout,xhighlight:boolean;
   xname,xref,e:string;
   wrd2:twrd2;

   function dmakefont:longint;
   begin

   if low__setstr( xref ,bolstr(xbold)+bolstr(xitalic)+bolstr(xunderline)+bolstr(xstrikeout)+bolstr(xhighlight)+'|'+intstr32(xalign)+'|'+intstr32(xcolor)+'|'+intstr32(xsize)+'|'+xname) then
      begin

      case xhighlight of
      true:xlastid   :=xmakefont2(true,xname,xsize,clnone,xcolor,clnone,xbold,xitalic,xunderline,xstrikeout,xalign);
      else xlastid   :=xmakefont2(true,xname,xsize,xcolor,clnone,clnone,xbold,xitalic,xunderline,xstrikeout,xalign);
      end;//case

      end;

   result       :=xlastid;

   end;

   procedure a1(const c:byte);
   var
      wrd2:twrd2;
   begin

   wrd2.val           :=dmakefont;

   v.data .addbyt1(c);
   v.data2.addbyt1( wrd2.bytes[0] );
   v.data3.addbyt1( wrd2.bytes[1] );

   end;

   function v0(const xindex:longint):byte;
   begin

   if (xindex>=0) and (xindex<l32) then result:=v.iostream.pbytes[xindex] else result:=0;

   end;

   function xpull:boolean;
   var
      nv,xfieldType:string;
      xdone:boolean;
      p:longint;
      c:byte;

      procedure xreadPicData;
      var
         bd,xfrom,xto,i:longint;
         xstart:boolean;
      begin

      //init
      xfrom    :=p;
      xto      :=p;
      bd       :=0;//bracket depth
      xstart   :=true;

      //find start/finish
      for i:=p to l32 do
      begin

      case v0(i) of
      ssLCurlyBracket:inc(bd);
      ssRCurlyBracket:begin

         dec(bd);

         if (not xstart) and (bd=-1) then
            begin

            xto    :=i-1;
            xpos   :=i;//allow main loop to detect end-of-pict - 19feb2026
            break;

            end;

         end;
      ssSpace:begin

         if (bd=0) and xstart then
            begin

            xfrom  :=i+1;
            xto    :=i+1;
            xpos   :=i+1;
            xstart :=false;

            end;

         end;
      end;//case

      end;//i

      //image
      v.tmp1.clear;
      v.tmp2.clear;
      v.tmp2.add2(v.iostream,xfrom,xto);

      low__fromhex(v.tmp2,v.tmp1);

      //reduce ram
      v.tmp2.clear;

      end;

      procedure xdecodeField;
      label
         redo;
      var
         bd,vmax,dlen,p:longint;

         procedure a1(const c:byte);
         begin

         v.tmp1.pbytes[dlen]:=c;
         inc(dlen,1);

         end;

      begin

      //defaults
      dlen  :=0;
      vmax  :=v.tmp1.len32-1;
      p     :=0;
      bd    :=0;

      //get
      redo:

      case v.tmp1.pbytes[p] of
      ssLCurlyBracket,ssRCurlyBracket:;//nil
      ssBackSlash:begin// "\{" => "{" etc

         if      (v.tmp1.str[p,2]='\{')   then
            begin

            a1(ssLCurlyBracket);
            inc(p,1);

            end
         else if (v.tmp1.str[p,2]='\}')   then
            begin

            a1(ssRCurlyBracket);
            inc(p,1);

            end
         else if (v.tmp1.str[p,4]='\\\\') then
            begin

            a1(ssBackSlash);
            inc(p,3);

            end;

         end;//begin

      else  a1(v.tmp1.pbytes[p]);

      end;//case

      //loop
      inc(p);
      if (p<=vmax) then goto redo;

      //finalise size
      if (dlen<v.tmp1.len32) then v.tmp1.setlen(dlen);

      end;

      procedure xreadfield;
      var
         xfrom,bd,i,i2:longint;
         xreadStop:boolean;
      begin

      //defaults
      xfieldType      :='';
      bd              :=0;
      xfrom           :=frcmin32(xpos-2,0);
      xreadStop       :=false;

      //init
      v.tmp1.clear;

      //find start/finish
      for i:=xfrom to l32 do
      begin

      case v0(i) of
      ssRCurlyBracket:begin

         if (v0(i-1)<>ssBackSlash) then dec(bd);

         if (bd=0) then
            begin

            xpos:=i;//allow main loop to detect the trailing double "}" - 19feb2026
            break;

            end;

         end;
      ssLCurlyBracket:begin

         if (v0(i-1)<>ssBackSlash) then inc(bd);

         if (not xreadStop) and strmatch(v.iostream.str1[i+1,11],'{hyperlink ') then
            begin

            xfieldType   :='url';
            xreadStop    :=true;

            for i2:=(i+11) to l32 do if (v0(i2)=ssRCurlyBracket) and (v0(i2+1)=ssRCurlyBracket) then
               begin

               v.tmp1.text:=v.iostream.str1[i+12,i2-i-12];
               xdecodeField;

               break;//i2

               end;
            end;

         end;//begin

      end;//case

      end;//i

      end;

   begin

   //init
   result   :=(xpos>=0) and (xpos<l32);
   xdone    :=false;
   n        :=n_nil;
   v32      :=0;

   //check
   if not result then exit;

   //get
   c        :=v0(xpos);

   case c of

   ssLCurlyBracket:begin

      if (v0(xpos-1)<>ssBackSlash) then inc(xBracketDepth);
      inc(xpos);

      end;
   ssRCurlyBracket:begin

      if (v0(xpos-1)<>ssBackSlash) then dec(xBracketDepth);
      inc(xpos);

      end;
   ssBackSlash:begin


      //encoded character ---------------------------------------------------

      if (xbracketDepth=1) and xpardStart then
         begin

         case v0(xpos+1) of

         ssLCurlyBracket:begin// "\{" => "{"

            n         :=n_char;
            v32       :=ssLCurlyBracket;
            xpardON   :=true;
            xdone     :=true;
            inc(xpos,2);

            end;

         ssRCurlyBracket:begin// "\}" => "}"

            n         :=n_char;
            v32       :=ssRCurlyBracket;
            xpardON   :=true;
            xdone     :=true;
            inc(xpos,2);

            end;

         ssBackSlash:begin// "\\" => "\"

            n         :=n_char;
            v32       :=ssBackSlash;
            xpardON   :=true;
            xdone     :=true;
            inc(xpos,2);

            end;

         end;//case

         end;//if


      //command -------------------------------------------------------------
      if not xdone then
         begin

         for p:=(xpos+1) to l32 do
         begin

         case v0(p) of

         ssLCurlyBracket,ssRCurlyBracket,ssBackSlash,ssSpace,10,13:begin

            xdone  :=true;
            nv     :=strlow( v.iostream.str[xpos+1,p-xpos-1] );//0-based

            if      (nv='b')           then n:=n_b
            else if (nv='b0')          then n:=n_b0
            else if (nv='i')           then n:=n_i
            else if (nv='i0')          then n:=n_i0
            else if (nv='ul')          then n:=n_u
            else if (nv='ulnone')      then n:=n_u0
            else if (nv='strike')      then n:=n_s
            else if (nv='strike0')     then n:=n_s0
            else if (nv='par')         then n:=n_10
            else if (nv='tab')         then n:=n_9
            else if (nv='ql')          then n:=n_left
            else if (nv='qc')          then n:=n_center
            else if (nv='qr')          then n:=n_right
            else if (nv='pict')        then
               begin

               n                             :=n_pic;
               xreadPicData;
               break;

               end
            else if (nv='field')       then
               begin

               xreadfield;

               if (xfieldType='url')   then n:=n_url
               else                          v.tmp1.clear;

               break;

               end

            else if (nv='pard')        then
               begin

               n             :=n_pard;
               xpardStart    :=true;

               end
            else if (strcopy1(nv,1,9)='highlight') then
               begin

               v32:=strint32(strcopy1(nv,10,low__len32(nv)));

               case (v32>=1) of
               true:n:=n_h;
               else n:=n_h0;
               end;//case

               end;


            case xpardStart and (v0(p)=ssSpace) of
            true:begin

               xpos    :=p+1;
               xpardON :=true;

               end;
            else xpos:=p;
            end;//case

            break;

            end;//begin

         end;//case

         end;//p

         end;//if


      //else inc
      if not xdone then inc(xpos);

      end;//begin

   //text char
   else begin

      case c of
      9,32..255:if xpardON then
         begin

         n      :=n_char;
         v32    :=c;

         end;
      end;//case

      //inc
      inc(xpos);

      end;//begin

   end;//case

   end;

begin

//defaults
a                     :=nil;

try

//init
l32                   :=blen32(v.iostream);
xpos                  :=0;
xbracketDepth         :=0;
xpardStart            :=false;
xpardON               :=false;
n                     :=n_nil;
v32                   :=0;
xname                 :=idefFontname;
xsize                 :=idefFontsize;
xcolor                :=idefFontcolor;
xbold                 :=false;
xitalic               :=false;
xunderline            :=false;
xstrikeout            :=false;
xhighlight            :=false;
xalign                :=wcaLeft;
xlastid               :=-1;

v.data.floatsize      :=5000;
v.data2.floatsize     :=5000;
v.data3.floatsize     :=5000;

//get
while xpull do
begin

case n of
n_char     :a1( v32 );
n_b        :xbold               :=true;
n_b0       :xbold               :=false;
n_i        :xitalic             :=true;
n_i0       :xitalic             :=false;
n_u        :xunderline          :=true;
n_u0       :xunderline          :=false;
n_s        :xstrikeout          :=true;
n_s0       :xstrikeout          :=false;
n_9        :a1( 9  );
n_10       :a1( 10 );
n_left     :xalign              :=wcaLeft;
n_center   :xalign              :=wcaCenter;
n_right    :xalign              :=wcaRight;
n_h        :xhighlight          :=true;
n_h0       :xhighlight          :=false;
n_pard     :begin

   xalign                       :=wcaLeft;

   end;
n_pic      :begin

   //add image
   if (a=nil) then a:=misimg32(1,1);

   if mis__fromdata(a,@v.tmp1,e) then
      begin

      wrd2.val :=xmakeimage2(v.tmp1,-1);

      v.data .addbyt1( 0 );
      v.data2.addbyt1( wrd2.bytes[0] );
      v.data3.addbyt1( wrd2.bytes[1] );

      end;

   //clear
   v.tmp1.clear;
   missize(a,1,1);

   end;
n_url      :begin

   for p:=1 to v.tmp1.len32 do a1( v.tmp1.pbytes[p-1] );

   end;

end;//case

end;//loop

except;end;

//free
freeobj(@a);

end;

function ttextcore.xmakeIOhandler(xfrom,xto:longint;xout:tstr8):ttextio;
begin

//xfrom...xto
xfrom            :=frcrange32(xfrom ,1     ,xlen32 );
xto              :=frcrange32(xto   ,xfrom ,xlen32 );

//init
result           :=ttextio.create;
result.iostream  :=xout;
result.wfrom     :=xfrom;
result.wto       :=xto;
result.wsize     :=xto-xfrom+1;

end;

function ttextcore.xgetdata(xout:tstr8;dformat:string;xfrom,xto:longint32):boolean;
label
   skipend;
var
   v:ttextio;
begin

//defaults
result      :=false;
v           :=nil;

//check
case str__lock(@xout) of
true:xout.clear;//clear out-bound stream
else goto skipend;
end;

try


//init
v           :=xmakeIOhandler(xfrom,xto,xout);


//range
dformat:=strlow(dformat);
if not supportsFormat(dformat) then dformat:='txt';


//get data
if      (dformat='txt' ) then xwrite__txt(v)
else if (dformat='bwd' ) then xwrite__bwd(v)
else if (dformat='bwp' ) then xwrite__bwp(v)
else if (dformat='dic')  then xwrite__dic(v)
else if (dformat='rtf' ) then xwrite__rtf(v)

else if (dformat='htm') or (dformat='html')  then
   begin

   case icaneditHTML of
   true:xwrite__htm(v);
   else xwrite__txt(v);
   end;//case

   end

else if (dformat='md') then
   begin

   case icaneditMD of
   true:xwrite__md(v);
   else xwrite__txt(v);
   end;//case

   end

else xwrite__txt(v);

//set
result:=(blen32(xout)>=1);

except;end;

skipend:

//free
freeobj(@v);
str__uaf(@xout);

end;

procedure ttextcore.xwrite__txt(const v:ttextio);//28feb2026, 14feb2026
var
   dlen,p:longint;
   fc:tfastchar;
begin

//init
dlen        :=0;
v.iostream.setlen(v.wsize);//pre-size for max speed

//get
for p:=v.wfrom to v.wto do if xslowchar(p,1,fc) and (fc.cs=wc_t) then
   begin

   inc(dlen);
   v.iostream.pbytes[dlen-1]:=fc.c;

   end;//p

//.if no text then return a single return code to prevent calling proc from assuming an error
if (dlen<=0) then
   begin

   inc(dlen);
   v.iostream.pbytes[dlen-1]:=10;

   end;


//.finalise
if (dlen<v.iostream.len32) then v.iostream.setlen(dlen);

end;

procedure ttextcore.xwrite__dic(const v:ttextio);//17feb2026
begin

//get
xwrite__txt(v);

//clean and sort dictionary
xmodify__dic(@v.iostream);

end;

procedure ttextcore.xmodify__dic(const x:pobject);
var
   a:tspell;
begin

//defaults
a           :=nil;

//check
if not str__lock(x) then exit;

try

a           :=tspell.create(true,'');
a.setclean( str__text(x) ,true );

str__settext(x,a.text);

except;end;

//free
freeobj(@a);
str__uaf(x);

end;


procedure ttextcore.xfontonevals(var xfontname:string;var xfontsize:longint);//04feb2023
begin

//fontsize ---------------------------------------------------------------------
case ionefontsize of
0        :xfontsize:=xviFontsize;
1        :xfontsize:=xviFontsize2;
2..max32 :xfontsize:=ionefontsize;
end;//case

xfontsize   :=font__safesize(xfontsize);

//fontname ---------------------------------------------------------------------
if (ionefontname<>'') then xfontname:=ionefontname;//14feb2026
if (xfontname='')     then xfontname:=font__name1;//'$fontname';

xfontname   :=font__realname(xfontname);

end;

procedure ttextcore.xwrite__bwd(const v:ttextio);
label
   skipend;

var
   int1,xfontsize,xcolor,xcolor2,p,dlen:longint;
   xonce,xonce2:boolean;
   xfontname:string;
   fc:tfastchar;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

begin

//init
dlen        :=0;
xonce       :=true;
xonce2      :=true;

v.tmp1.setlen(v.wsize);//pre-size for max speed
v.tmp2.setlen(v.wsize);//pre-size for max speed

xfontname   :='courier new';
xfontsize   :=xscale__px1(12,7);
xcolor      :=0;//black
xcolor2     :=255;//red

//.color info
for p:=v.wfrom to v.wto do if xslowchar(p,1,fc) and (fc.cs=wc_t) then
   begin

   //font information - once only
   if xonce then
      begin

      xonce           :=false;
      xfontname       :=tv.name;
      xfontsize       :=tv.size;
      xcolor          :=tv.color;

      //.force one font information for saving/copying - 04feb2023
      xfontonevals(xfontname,xfontsize);

      end;

   //.search for 2nd color -> if one is used
   if xonce2 and (xcolor<>tv.color) then
      begin

      xonce2    :=false;
      xcolor2   :=tv.color;
      break;//done

      end;

   if xonce2 and (xcolor<>tv.bgcolor) and (tv.bgcolor<>clnone) and (tv.bgcolor<>ipagecolor) then
      begin

      xonce2    :=false;
      xcolor2   :=tv.bgcolor;
      break;//done

      end;

   end;//p

//get
for p:=v.wfrom to v.wto do if xslowchar(p,1,fc) and (fc.cs=wc_t) then
   begin

   inc(dlen);

   //text stream
   v.tmp1.pbytes[dlen-1]  :=fc.c;

   //style stream
   int1                   :=0;

   if tv.bold                                           then inc(int1);//bold
   if tv.italic                                         then inc(int1,2);//italic
   if tv.underline                                      then inc(int1,4);//underline
   if tv.strikeout                                      then inc(int1,8);//strikeout
   if (tv.bgcolor<>clnone) and (tv.bgcolor<>ipagecolor) then inc(int1,16);//swap (highlight background)
   if (tv.color<>xcolor)                                then inc(int1,32);//color2 (use color2, e.g. red)

   v.tmp2.pbytes[dlen-1]:=byte(int1);

   end;//p

//.finalise
if (dlen<v.tmp1.len32) then
   begin

   v.tmp1.setlen(dlen);
   v.tmp2.setlen(dlen);

   end;

//set
int1:=0;

//.header
if not xappendstr(v.iostream,'BWD1','') then goto skipend;

//.info -> include only the settings we can comfortably provide - BW will fill in the rest as needed - 04sep2019
v.vars.b['landscape']     :=false;
v.vars.b['systemscheme']  :=false;
v.vars.i['wrapstyle']     :=low__aorb(wwsWindow,wwsPage,ipagewidth<>iviewwidth);//1=wrap to window, 2=wrap to page
v.vars.s['fontname']      :=xfontname;
v.vars.i['fontsize']      :=xfontsize;
v.vars.i['fontcolor']     :=xcolor;
v.vars.i['fontcolor2']    :=xcolor2;
v.vars.i['fontstyle']     :=0;
v.vars.i['bgcolor']       :=ipagecolor;
if (ilinespacing>=2) then v.vars.i['linespacing']:=ilinespacing;//04feb2023

if not xappend(v.iostream,'info',v.vars.data) then goto skipend;

//.font - reserved for future use
if not xappendstr(v.iostream,'font','') then goto skipend;

//.text
if not xappend(v.iostream,'text',v.tmp1) then goto skipend;
v.tmp1.clear;//reduce ram

//.styl
if not xappend(v.iostream,'styl',v.tmp2) then goto skipend;
v.tmp2.clear;//reduce ram

skipend:

end;

procedure ttextcore.xwrite__bwp(const v:ttextio);
label
   skipend;

var
   dlen,p:longint;
   fc:tfastchar;
   xint4,xint4b:tint4;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

   function iv:pimageinfo;
   begin
   result:=@ilist[fc.wid];
   end;

begin

//header
if not xappendstr(v.iostream,'BWP1','') then goto skipend;

//info -> include only the settings we can comfortably provide - BW will fill in the reset as needed - 04sep2019
v.vars.b['landscape']        :=ilandscape;
v.vars.b['systemscheme']     :=false;
v.vars.i['wrapstyle']        :=iwrapstyle;
v.vars.i['bgcolor']          :=ipagecolor;
if not xappend(v.iostream,'info',v.vars.data) then goto skipend;

//data
dlen                         :=0;

v.tmp1.setlen(3*v.wsize);//pre-size for max speed

for p:=v.wfrom to v.wto do if xslowchar(p,1,fc) then
   begin

   inc(dlen,3);

   v.tmp1.pbytes[dlen-3]   :=idata .pbytes[p-1];
   v.tmp1.pbytes[dlen-2]   :=idata2.pbytes[p-1];
   v.tmp1.pbytes[dlen-1]   :=idata3.pbytes[p-1];

   end;//p

if     (dlen<v.tmp1.len)                 then v.tmp1.setlen(dlen);//finalise
if not xappend(v.iostream,'data',v.tmp1) then goto skipend;

v.tmp1.clear;//reduce ram

//list -------------------------------------------------------------------------
if not xappendstr(v.iostream,'list','')  then goto skipend;

//init
v.tmp2.setlen(textcore_listmax+1);
v.tmp3.setlen(textcore_listmax+1);

for p:=0 to textcore_listmax do v.tmp2.pbytes[p]:=0;//track used "lgf" items - optional
for p:=0 to textcore_listmax do v.tmp3.pbytes[p]:=0;//track used "lgf" items - optional

//text & images
for p:=v.wfrom to v.wto do if xslowchar(p,1,fc) then
   begin

   //.t0..t999
   if (fc.cs=wc_t) and (v.tmp2.pbytes[fc.wid]=0) then
      begin

      //mark as done
      v.tmp2.pbytes[fc.wid]                     :=1;

      //init
      xint4.val                                 :=0;
      if tv.bold            then xint4.bytes[0] :=1;
      if tv.italic          then xint4.bytes[1] :=1;
      if tv.underline       then xint4.bytes[2] :=1;
      if tv.strikeout       then xint4.bytes[3] :=1;

      //.xint4b
      xint4b.val                                :=0;
      xint4b.bytes[0]                           :=frcrange32(tv.align,0,wcaMax);

      //get
      if not xappendstr (v.iostream,'begi' ,'t'+intstr32(fc.wid)) then goto skipend;//begin
      if not xappendint4(v.iostream,'_tid' ,tv.id)                then goto skipend;//lgf index -> txtid
      if not xappendint4(v.iostream,'_brc' ,tv.brcolor)           then goto skipend;//border color
      if not xappendint4(v.iostream,'_bkc' ,tv.bgcolor)           then goto skipend;//font background color
      if not xappendint4(v.iostream,'_fcl' ,tv.color)             then goto skipend;//font color
      if not xappendint4(v.iostream,'_fsz' ,tv.size)              then goto skipend;//font size
      if not xappendint4(v.iostream,'_fsy' ,xint4.val)            then goto skipend;//font style
      if not xappendint4(v.iostream,'_fs2' ,xint4b.val)           then goto skipend;//font style2 (align)
      if not xappendstr (v.iostream,'_fnm' ,tv.name)              then goto skipend;//font name
      if not xappendstr (v.iostream,'end!' ,'')                   then goto skipend;//end

      end

   //.i0..i999
   else if (fc.cs=wc_i) and (v.tmp3.pbytes[fc.wid]=0) then
      begin

      //mark as done
      v.tmp3.pbytes[fc.wid]                     :=1;

      //get
      if not xappendstr(v.iostream ,'begi','i'+intstr32(fc.wid)) then goto skipend;//begin
      if not    xappend(v.iostream ,'_imd',iv.orgdata)           then goto skipend;//imdata datastream
      if not xappendstr(v.iostream ,'_scl',bolstr(iv.syscols))   then goto skipend;//syscols boolean - 25may2025
      if not xappendstr(v.iostream ,'end!','')                   then goto skipend;//end

      end;//if

   end;//p

if not xappendstr(v.iostream,'lise','') then goto skipend;//list end

skipend:

end;

procedure ttextcore.xwrite__htm(const v:ttextio);//14feb2026
var//Output: one text color (browser default) and one background-color (browser default)

//xxxxxxxxx Note: form "HTML Format" clipboard -> html can be written with

//a) <span class="ff">
//b) <b>....</b>
//c) <span style="........&quot;(font name)&quot;
//d) or any combination/all of the above at once....
//e) Note: class="ff" may point to a class that is not accessiable (such as with FireFox) but Chrome/Edge provide "style='''" fallback and Browser Edit box (e.g. Gmail's compose edit box) usings basic "<b>....</b>" and "<br>" for return codes
//also note: blank lines in Edge are written as "<p/>"

   a:tbasicimage;
   xstartline:boolean;
   xlastc,xlastid,p:longint;
   ff:tfastfont;
   fc:tfastchar;
   xlineheight,e:string;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

   function iv:pimageinfo;
   begin
   result:=@ilist[fc.wid];
   end;

   function xmuststyle(const xid:longint):boolean;
   begin

   result:=(xid>=0) and (xid<=textcore_listmax) and (v.tmp1.pbytes[xid]=0);
   if result then v.tmp1.pbytes[xid]:=1;//mark as done

   end;

   procedure sa(const x:string);
   begin
   v.iostream.sadd(x);
   end;

   procedure la(const x:string);
   begin
   v.iostream.sadd(x+rcode);
   end;

   function xsafeval(const x:string):string;
   begin

   result:=x;
   low__remchar(result,'{');
   low__remchar(result,'}');
   low__remchar(result,';');
   low__remchar(result,#9);
   low__remchar(result,#10);
   low__remchar(result,#13);
   low__remchar(result,'"');

   end;

   function xalign:string;
   begin

   case xfastfindalign(1+p) of
   1    :result:='center';
   2    :result:='right';
   else  result:='left';
   end;//case

   end;

   function xtextdecoration:string;
   begin

   if      tv.underline and tv.strikeout then result:='underline line-through'
   else if tv.underline                  then result:='underline'
   else if tv.strikeout                  then result:='line-through'
   else                                       result:='none';

   end;

   function xtextindent:string;
   var
      v:tfastchar;
   begin

   case xslowchar(1+p,1,v) and (v.cs=wc_t) and (v.c=9) of
   true:result:='2em';
   else result:='0';
   end;//case

   end;

begin

//defaults
a           :=nil;

try

//init
a           :=misimg32(1,1);
xlineheight :='100%';//was: intstr32(ilinespacing*100)+'%';
v.tmp1.setlen(textcore_listmax+1);
v.tmp1.fill(0,v.tmp1.len32-1,0);

xfastcharinit(ff);
xlastc      :=-1;
xstartline  :=false;

//header
la('<!DOCTYPE html>');
la('<html lang="en" dir="ltr">');
la('<head>');
la('<meta charset="UTF-8">');
la('');
la('<style type="text/css">');

la('p {line-height:'+xlineheight+';margin-top:0;margin-bottom:0;padding-top:0;padding-bottom:0;}');
la('span {line-height:'+xlineheight+'}');


//write styles
for p:=v.wfrom to v.wto do if xfastchar(ff,p,1,fc) and (fc.cs=wc_t) and xmuststyle(fc.wid) then
   begin

   la('.f'+intstr32(fc.wid)+' {'+
   'font-size:'+intstr32(tv.size)+'pt;'+
   'font-family:"'+xsafeval(font__realname(tv.name))+'";'+
   insstr('background-color:#00def92e;',tv.bgcolor<>clnone)+
   'font-weight:'+low__aorbstr('normal','bolder',tv.bold)+';'+
   'font-style:'+low__aorbstr('normal','italic',tv.italic)+';'+
   'text-decoration:'+xtextdecoration+';'+
   '}')

   end;

la('</style>');
la('</head>');

//document body
la('<body>');

xlastid:=-1;

for p:=v.wfrom to v.wto do
begin

if xfastchar(ff,p,1,fc) then
   begin

   //text

   if (fc.cs=wc_t) then
      begin


      //start of new line
      if (p=v.wfrom) or (fc.c=10) then
         begin

         //reset style
         if (xlastid>=0) then
            begin

            sa('</span>');
            xlastid:=-1;

            end;

         //stop previous line
         if xstartline then la('</p>');

         //start new line
         xstartline:=true;
         sa('<p style="text-indent:'+xtextindent+';text-align:'+xalign+';min-height:'+intstr32(tv.size)+'pt;">');

         end;


      if (xlastid<>fc.wid) then
         begin

         //stop
         if (xlastid>=0) then sa('</span>');

         //start
         xlastid:=fc.wid;
         sa('<span class="f'+intstr32(fc.wid)+'">');

         end;

      //text character
      if (fc.c<>10) then sa( html__char(fc.c,xlastc=32) );
      xlastc:=fc.c;

      end

   //image
   else if (fc.cs=wc_i) then
      begin

      xlastc:=0;
      if (iv.orgdata.len32>=1) and mis__fromdata(a,@iv.orgdata,e) and png__todata(a,@v.tmp2,e) and low__tob64(v.tmp2,v.tmp3,0,e) then
         begin

         sa('<img width='+intstr32(misw(a))+' height='+intstr32(mish(a))+' src="data:image/png;base64,'+v.tmp3.text+'">');

         end;

      end

   //unknown
   else
      begin

      xlastc:=-1;

      end;

   end;

end;//p

//stop style
if (xlastid>=0) then sa('</span>');

//stop line
if xstartline then la('</p>');

//finish document
la('</body>');
la('</html>');

except;end;

//free
freeobj(@a);

end;

procedure ttextcore.xwrite__htm__basic(const v:ttextio);//16feb2026
var//Generates HTML for Clipboard -> works with Gmail's compose box in Browser
   a:tbasicimage;
   xlastc,p:longint;
   ff:tfastfont;
   fc:tfastchar;
   e:string;
   xbold,xitalic,xunderline,xstrikeout:boolean;
   xoldalignment,xalignment,xval_starthtml,xval_endhtml,xval_startfrag,xval_endfrag:longint;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

   function iv:pimageinfo;
   begin
   result:=@ilist[fc.wid];
   end;

   procedure sa(const x:string);
   begin
   v.data.sadd(x);
   end;

   procedure la(const x:string);
   begin
   v.data.sadd(x+rcode);
   end;

   procedure xStyleChange(const xAllow:boolean);
   begin

   //bold
   if low__setbol( xbold ,tv.bold and xAllow ) then
      begin

      case xbold of
      true:sa('<b>');//on
      else sa('</b>');//off
      end;//case

      end;

   //italic
   if low__setbol( xitalic ,tv.italic and xAllow) then
      begin

      case xitalic of
      true:sa('<i>');//on
      else sa('</i> ');//off
      end;//case

      end;

   //underline
   if low__setbol( xunderline ,tv.underline and xAllow) then
      begin

      case xunderline of
      true:sa('<u>');//on
      else sa('</u>');//off
      end;//case

      end;

   //strikeout
   if low__setbol( xstrikeout ,tv.strikeout and xAllow) then
      begin

      //?????????????????????

      end;

   end;

   procedure xAlignChange(const xAllow:boolean);
   var
      xold:longint;
   begin

   if not xAllow then
      begin

      //turn off styles
      xStyleChange(false);

      //stop previous alignment
      if (xold<>wcaLeft) then sa('</div>');

      exit;

      end;

   //get
   xold:=xalignment;

   if (fc.c=10) and low__setint(xalignment,xfastfindalign(p+1)) then
      begin

      //turn off styles
      xStyleChange(false);

      //stop previous alignment
      if (xold<>wcaLeft) then sa('</div>');

      case xalignment of
      wcaCenter :sa('<div style="text-align: center;">');
      wcaRight  :sa('<div style="text-align: right;">');
      end;//case

      end;

   end;

   function xver:string;
   begin
   result:='Version:0.9'+rcode;
   end;

   function xstartHtml(const xval:longint):string;
   begin
   result:='StartHTML:' +low__digpad11(xval,8)+rcode;
   end;

   function xendHtml(const xval:longint):string;
   begin
   result:='EndHTML:' +low__digpad11(xval,8)+rcode;
   end;

   function xstartFragment(const xval:longint):string;
   begin
   result:='StartFragment:' +low__digpad11(xval,8)+rcode;
   end;

   function xendFragment(const xval:longint):string;
   begin
   result:='EndFragment:' +low__digpad11(xval,8)+rcode;
   end;

   function xsourceurl:string;
   begin
   result:='SourceURL:https://localhost'+rcode;
   end;

   function xhtml__start:string;
   begin
   result:='<html><body>';
   end;

   function xhtml__end:string;
   begin
   result:='</body></html>';
   end;

   function xfrag__start:string;
   begin
   result:='<!--StartFragment-->';
   end;

   function xfrag__end:string;
   begin
   result:='<!--EndFragment-->';
   end;

begin

//defaults
a                     :=nil;

try

//init
v.tmp1.setlen(textcore_listmax+1);
v.tmp1.fill(0,v.tmp1.len32-1,0);

xfastcharinit(ff);
xfastchar(ff,v.wfrom,1,fc);
xalignment            :=wcaLeft;
xoldalignment         :=wcaLeft;
xlastc                :=-1;
xbold                 :=false;
xitalic               :=false;
xunderline            :=false;
xstrikeout            :=false;

//get
for p:=v.wfrom to v.wto do
begin

if xfastchar(ff,p,1,fc) then
   begin

   //alignment change
   xAlignChange(true);

   //style change
   xStyleChange(true);

   //text
   if (fc.cs=wc_t) then
      begin

      //text character
      case fc.c of
       9:sa('&nbsp; &nbsp; &nbsp;');//5c
      10:begin

         case (xalignment<>wcaLeft) or (xoldalignment<>wcaLeft) of
         true:sa(rcode);
         else sa('<br>'+rcode);
         end;//case

         end;
      13:;
      else sa( html__char(fc.c,xlastc=32) );
      end;//case

      xlastc:=fc.c;

      end

   //image
   else if (fc.cs=wc_i) then
      begin

      xlastc:=0;

      if (a=nil) then a:=misimg32(1,1);

      if (iv.orgdata.len32>=1) and mis__fromdata(a,@iv.orgdata,e) and png__todata(a,@v.tmp2,e) and low__tob64(v.tmp2,v.tmp3,0,e) then
         begin

         sa('<img width='+intstr32(misw(a))+' height='+intstr32(mish(a))+' src="data:image/png;base64,'+v.tmp3.text+'">');

         end;

      end

   //unknown
   else
      begin

      xlastc:=-1;

      end;

   end;

xoldalignment:=xalignment;

end;//p

//stop style
xStyleChange(false);

//stop alignment
xAlignChange(false);


//package
xval_starthtml  :=low__len32( xver + xstartHtml(0) + xendHtml(0) + xstartFragment(0) + xendFragment(0) + xsourceurl );
xval_endhtml    :=xval_starthtml + low__len32( xhtml__start + xfrag__start + xfrag__end + xhtml__end ) + v.data.len32;

xval_startfrag  :=xval_starthtml + low__len32( xhtml__start + xfrag__start );
xval_endfrag    :=xval_endhtml - low__len32( xhtml__end );



{
str1:=
'Version:0.9'                                      +#10+//12b
'StartHTML:'    +low__digpad11(xstartOfHtml,8)     +#10+//19b
'EndHTML:'      +low__digpad11(184+v.data.len32,8) +#10+//17b
'StartFragment:'+low__digpad11(,8)                 +#10+//23b
'EndFragment:'  +low__digpad11(,8)                 +#10+//21b
'SourceURL:https://localhost'                      +#10+//28b

'<html><body>'+//12b
'<!--StartFragment-->'+//20b
v.data.text+
'<!--EndFragment-->'+//18b
'</body></html>';//14b
{}

v.iostream.sadd(
xver +
xstartHtml( xval_starthtml ) +
xendHtml( xval_endhtml ) +
xstartFragment( xval_startfrag ) +
xendFragment( xval_endfrag ) +
xsourceurl +
xhtml__start +
xfrag__start
);

v.iostream.add( v.data );

v.iostream.sadd(
xfrag__end +
xhtml__end
);


except;end;

//free
freeobj(@a);

end;

procedure ttextcore.xwrite__md(const v:ttextio);//14feb2026
begin

end;

procedure ttextcore.xwrite__pdf(const v:ttextio);
begin
//xxxxxxxxxxxxxxxxxxxxxxx//????????????????
end;

procedure ttextcore.xwrite__rtf(const v:ttextio);//basic RTF
var
   a:tbasicimage;
   b:tstr8;
   xalign,fmapCount,xlastc,xlastid,p:longint;
   ff:tfastfont;
   fc:tfastchar;
   fmap:array[0..textcore_listmax] of longint;//map used font to rtf font (f0..n)
   xfirstChar,xbold,xitalic,xunderline,xstrikeout,xhighlight:boolean;
   xformat,e:string;

   function tv2(const xindex:longint):ptextinfo;
   begin

   case (xindex>=0) and (xindex<=textcore_listmax) of
   true:result:=@tlist[xindex];
   else result:=@tlist[0];
   end;//case

   end;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

   function iv:pimageinfo;
   begin
   result:=@ilist[fc.wid];
   end;

   function xmuststyle(const xid:longint):boolean;
   begin

   result:=(xid>=0) and (xid<=textcore_listmax) and (v.tmp1.pbytes[xid]=0);
   if result then v.tmp1.pbytes[xid]:=1;//mark as done

   end;

   procedure a1(const x1:byte);
   begin

   v.iostream.addbyt1(x1);

   end;

   procedure a2(const x1,x2:byte);
   begin

   v.iostream.addbyt1(x1);
   v.iostream.addbyt1(x2);

   end;

   procedure sa(const x:string);
   begin
   v.iostream.sadd(x);
   end;

   procedure la(const x:string);
   begin
   v.iostream.sadd(x+rcode);
   end;

   function xsafeval(const x:string):string;
   var
      v,p:longint;
   begin

   //defaults
   result   :='';
   b.clear;

   try

   //scan
   for p:=1 to low__len32(x) do
   begin

   v:=ord( x[p-1+stroffset] );

   case v of
   ssbackslash      :b.sadd('\\');
   ssLCurlyBracket  :b.sadd('\{');
   ssRCurlyBracket  :b.sadd('\}');
   else              b.addbyt1(v);
   end;//case

   end;//p

   //get
   result:=b.text;

   except;end;

   //clear
   b.clear;

   end;

   procedure xStyleChange(const xAllow:boolean);
   begin

   //bold
   if low__setbol( xbold ,tv.bold and xAllow ) then
      begin

      case xbold of
      true:sa('\b ');//on
      else sa('\b0 ');//off
      end;//case

      end;

   //italic
   if low__setbol( xitalic ,tv.italic and xAllow) then
      begin

      case xitalic of
      true:sa('\i ');//on
      else sa('\i0 ');//off
      end;//case

      end;

   //underline
   if low__setbol( xunderline ,tv.underline and xAllow) then
      begin

      case xunderline of
      true:sa('\ul ');//on
      else sa('\ulnone ');//off
      end;//case

      end;

   //strikeout
   if low__setbol( xstrikeout ,tv.strikeout and xAllow) then
      begin

      case xstrikeout of
      true:sa('\strike ');//on
      else sa('\strike0 ');//off
      end;//case

      end;

   //highlight
   if low__setbol( xhighlight ,(tv.bgcolor<>clnone) and xAllow) then
      begin

      case xhighlight of
      true:sa('\highlight1 ');//on -> refers to 1st color table entry
      else sa('\highlight0 ');//off
      end;//case

      end;

   end;

   function xalignStr:string;
   begin

   case xalign of
   wcaCenter :result:='\qc';
   wcaRight  :result:='\qr';
   else       result:='';
   end;//case

   end;

   function xfontsize:string;
   begin
   result:=intstr32( tv.size*2 );
   end;

   function xpicWH(const xpx:longint):string;
   begin
   result:=intstr32(round32( (xpx / 96) * 2540));
   end;

   function xpicWHgoal(const xpx:longint):string;
   begin
   result:=intstr32(round32( (xpx / 96) * 1440));
   end;

begin

//defaults
a           :=nil;
b           :=nil;

try

//init
b           :=str__new8;
b.floatsize :=5000;
xbold       :=false;
xitalic     :=false;
xunderline  :=false;
xstrikeout  :=false;
xhighlight  :=false;
xalign      :=xfastfindalign(v.wfrom);
xfirstChar  :=true;
fmapCount   :=0;
low__cls(@fmap,0);

v.tmp1.setlen(textcore_listmax+1);
v.tmp1.fill(0,v.tmp1.len32-1,0);

xfastcharinit(ff);
xfastchar(ff,v.wfrom,1,fc);

xlastc      :=-1;
xlastid     :=-1;


//map used fonts to fmap -------------------------------------------------------
for p:=v.wfrom to v.wto do if xfastchar(ff,p,1,fc) and (fc.cs=wc_t) and xmuststyle(fc.wid) then
   begin

   fmap[ fmapCount ]:=fc.wid;
   inc( fmapCount );

   end;


//header + used fonts ----------------------------------------------------------

sa('{\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang2057{\fonttbl{\f0\fnil\fcharset0 '+xsafeval( font__realname(tv2( fmap[0] ).name) )+';}');//root font

//for p:=1 to (fmapCount-1) do sa('{\f'+intstr32(p)+'\fnil\fcharset0 '+xsafeval( font__realname(tv2( fmap[p] ).name) )+';}');//additional fonts - not required, as this writer generates basic RTF

sa('{\colortbl ;\red168\green168\blue168;}');//for highlight or font usage -> a light grey highlight background - 19feb2026

sa('}'+rcode);

//.comment
la('{\*\generator TextCore 2.00.6621}\viewkind4\uc1');

//.first par
sa('\pard\sl240\slmult1\f0\fs'+xfontsize+'\lang9'+xalignStr);//240=single line spacing, 480=double line spacing


//text -------------------------------------------------------------------------

for p:=v.wfrom to v.wto do
begin

if xfirstChar then
   begin

   case fc.c of
   ssbackslash,ssLCurlyBracket, ssRCurlyBracket:;//special char can be encoded as first char of pard
   else a1(32);//insert a space if first char is NOT a specially encoded char
   end;

   xfirstchar:=false;

   end;

if xfastchar(ff,p,1,fc) then
   begin

   //style change
   xStyleChange(true);

   //text
   if (fc.cs=wc_t) then
      begin

      case fc.c of
      ssbackslash      :a2(ssbackslash,fc.c);
      ssLCurlyBracket  :a2(ssbackslash,fc.c);
      ssRCurlyBracket  :a2(ssbackslash,fc.c);

      9:sa('\tab ');//19feb2026
      10:begin

         sa('\par'+rcode);

         if low__setint(xalign,xfastfindalign(p+1)) and (p<v.wto) then
            begin

            sa('\pard\sl240\slmult1\fs'+xfontsize+xalignStr+#32);

            end;

         end;

      13               :;
      else              a1(fc.c);
      end;//case

      end

   else if (fc.cs=wc_i) then
      begin

      if (iv.orgdata.len32>=1) then
         begin


         //sa('{\pict\pngblip\picw2037\pich1905\picwgoal1155\pichgoal1080 ...hex.data...} *** for a 77w x 72h image
         xformat:=strlow(io__anyformatb(@iv.orgdata));


         //.use existing image data stream if "png" or "jpg"
         if (xformat='jpg') or (xformat='png') then
            begin

            low__tohex(iv.orgdata,v.tmp3,800);

            sa('{\pict\' + low__aorbstr('png','jpeg',xformat='jpg') + 'blip' +

            '\picw'+xpicWH(iv.w)+
            '\pich'+xpicWH(iv.h)+
            '\picwgoal'+xpicWHgoal(iv.w)+
            '\pichgoal'+xpicWHgoal(iv.h)+
            #32+ v.tmp3.text +

            '}');

            //reduce ram
            v.tmp3.clear;

            end

         //.convert image data stream to "png"
         else
            begin

            //init
            if (a=nil) then a:=misimg32(1,1);

            //make png
            mis__fromdata(a,@iv.orgdata,e);
            png__todata(a,@v.tmp2,e);

            low__tohex(v.tmp2,v.tmp3,800);
            v.tmp2.clear;//reduce ram

            //get
            sa('{\pict\pngblip'+

            '\picw'+xpicWH(misw(a))+
            '\pich'+xpicWH(mish(a))+
            '\picwgoal'+xpicWHgoal(misw(a))+
            '\pichgoal'+xpicWHgoal(mish(a))+
            #32+ v.tmp3.text +

            '}');

            //reduce ram
            v.tmp3.clear;

            end;

         end;

      end;

   end;

end;//p


//finish document --------------------------------------------------------------
la('}');

except;end;

//free
freeobj(@a);
str__free(@b);

end;

procedure ttextcore.vwheel(xval:longint);
var
   int2,int3:longint;
begin

//get
int3:=0;

if (xval>=1) then
   begin

   for int2:=ivpos to (ivpos+xval-1) do
   begin

   if (int2>=0) and (int2<ilinecount) and (int2<ilinesize)  then dec(int3,ilineh[int2]) else break;

   end;//int2

   end
else if (xval<=-1) then
   begin

   for int2:=ivpos downto (ivpos+xval+1) do
   begin

   if (int2>=0) and (int2<ilinecount) and (int2<ilinesize)  then inc(int3,ilineh[int2]) else break;

   end;//int2

   end;

//set
if (int3<>0) then
   begin

   int2    :=frcmin32(frcmax32(100,iviewheight div 3),10);
   vpos_px :=vpos_px + frcrange32(int3,-int2,int2);

   end;

end;

function ttextcore.canselectall:boolean;
begin
result:=true;
end;

procedure ttextcore.selectall;
begin

if canselectall then
   begin

   cursorpos  :=1;
   cursorpos2 :=xlen32;

   end;

end;

function ttextcore.cancopy:boolean;
begin

{$ifdef gui}
result:=(selcount>=1);
{$else}
result:=false;
{$endif}

end;

procedure ttextcore.copy;
begin
if cancopy then xcopy(false);
end;

function ttextcore.cancopyall:boolean;
begin
result:=true;
end;

procedure ttextcore.copyall;
begin
if cancopyall then xcopy(true);
end;

procedure ttextcore.xcopy(const xall:boolean);
label
   skipend;
var
   a,b:tstr8;
   v:ttextio;
   xfrom,xto:longint;
   xopened:boolean;
begin

{$ifdef gui}

//defaults
xopened :=false;
a       :=nil;
b       :=nil;

//range
if xall then
   begin

   xfrom :=1;
   xto   :=xlen32;

   end
else
   begin

   //check
   if (selcount<=0) then exit;

   //get
   xfrom :=selstart;
   xto   :=xfrom + selcount - 1;

   end;

try

//init
a  :=str__new8;
b  :=str__new8;
v  :=nil;

//open
if clip__openedAndclear(xopened) then
   begin


   //bwp -----------------------------------------------------------------------
   a.makeglobal;
   if not xgetdata(a,'bwp',xfrom,xto) then goto skipend;
   //.copy
   if (0=win____setclipboarddata(cf_bwp,a.handle)) then goto skipend;
   a.ejectcore;


   //txt -----------------------------------------------------------------------
   //txt -> Important: CF_TEXT expects a null terminated string - 26sep2022
   a.makeglobal;
   if not xgetdata(a,'txt',xfrom,xto) then goto skipend;
   a.aadd([0]);//null terminated string

   //.copy
   if (0=win____setclipboarddata(cf_text,a.handle)) then goto skipend;
   a.ejectcore;


   //rtf -----------------------------------------------------------------------
   a.makeglobal;
   if not xgetdata(a,'rtf',xfrom,xto) then goto skipend;
   a.aadd([0]);//null terminated string

   //.take a copy for below repeat procs
   b.add(a);

   //.copy
   if (0=win____setclipboarddata(cf_rtf,a.handle)) then goto skipend;
   a.ejectcore;


   //cf_rtf__RTFasText ---------------------------------------------------------
   a.makeglobal;
   a.clear;
   a.add(b);//use copy from cf_rtf

   //.copy
   if (0=win____setclipboarddata(cf_rtf__RTFasText,a.handle)) then goto skipend;
   a.ejectcore;


   //cf_html -------------------------------------------------------------------
   a.makeglobal;
   v:=xmakeIOhandler(xfrom,xto,a);
   xwrite__htm__basic(v);
   a.aadd([0]);//null terminated string

   //.copy
   if (0=win____setclipboarddata(cf_html,a.handle)) then goto skipend;
   a.ejectcore;

   end;

skipend:
except;end;

//free
str__free(@a);
str__free(@b);
freeobj(@v);

//close clipboard
if xopened then win____CloseClipboard;

{$endif}

end;

function ttextcore.candeleteall:boolean;
begin
result:=(not ireadonly) and (idata.len>=2);
end;

procedure ttextcore.deleteall;
begin

if candeleteall then
   begin

   xbackup('deleteall');

   //flush redo list - 02may2023
   mredoflush;

   mstore1;//previous
   icursorpos:=1;
   icursorpos2:=xlen32;
   iundoinfo.style:=musSel;
   mstore1;
   cdefault;

   end;

end;

function ttextcore.cancut:boolean;
begin
result:=(not ireadonly) and (selcount>=1);
end;

procedure ttextcore.cut;
begin

if cancut then
   begin

   xnoidle;
   knoidle;

   copy;
   xbackup('cut');

   //flush redo list - 02may2023
   mredoflush;

   mstore1;//previous
   iundoinfo.style:=musSel;
   mstore1;

   end;

end;

function ttextcore.canpaste:boolean;
begin
result:=(not ireadonly) and xcanpaste;
end;

function ttextcore.paste:boolean;
begin

result:=canpaste;

if result then
   begin

   xbackup('paste');
   result:=xpaste(false);

   end;

end;

function ttextcore.canpastereplace:boolean;
begin
result:=(not ireadonly) and xcanpaste;
end;

function ttextcore.pastereplace:boolean;
begin

result:=canpaste;

if result then
   begin

   xbackup('pastereplace');
   result:=xpaste(true);

   end;

end;

function ttextcore.xcanpaste:boolean;
begin

{$ifdef gui}
result:=
 clip__hasformat(cf_bwp)            or
 clip__hasformat(cf_rtf)            or
 clip__hasformat(cf_rtf__RTFasText) or
 clip__hasformat(cf_bwd)            or
 clip__hasformat(cf_text)           or
 clip__hasformat(cf_html)           or//????????????????
 clip__canpasteimage(true);
{$else}
result:=false;
{$endif}

end;

function ttextcore.xpaste(xreplace:boolean):boolean;//22apr2026, 01may2025
label
   skipend;
var
   a:trawimage;
   xformat,e:string;
   adata,adata2:tstr8;
   c1,c2,v1,v2:longint;
   xbase64:boolean;

   procedure creplace;
   begin
   if xreplace then clear2;
   end;

begin

{$ifdef gui}

//defaults
result      :=false;
c1          :=icursorpos;
c2          :=icursorpos2;
a           :=nil;
adata       :=nil;
adata2      :=nil;

try


//bwp --------------------------------------------------------------------------

if clip__hasformat(cf_bwp) then
   begin

   adata    :=str__new8;

   if clip__pasteformat(cf_bwp,@adata) then
      begin

      //ins
      creplace;

      case misformat(adata,xformat,xbase64) of
      true:xinsimg(adata);//text is an image
      else xioins(adata);//text is text
      end;//case

      //successful
      result:=true;
      goto skipend;

      end;

   end;


//rtf --------------------------------------------------------------------------

if clip__hasformat(cf_rtf) then
   begin
   adata    :=str__new8;

   if clip__pasteformat(cf_rtf,@adata) then
      begin

      //ins
      creplace;
      xioins(adata);//text is text

      //successful
      result:=true;
      goto skipend;

      end;

   end;


//cf_rtf__RTFasText ------------------------------------------------------------

if clip__hasformat(cf_rtf__RTFasText) then
   begin

   adata    :=str__new8;

   if clip__pasteformat(cf_rtf__RTFasText,@adata) then
      begin

      //ins
      creplace;
      xioins(adata);//text is text

      //successful
      result:=true;
      goto skipend;

      end;

   end;


//bwd --------------------------------------------------------------------------

if clip__hasformat(cf_bwd) then
   begin

   adata    :=str__new8;

   if clip__pasteformat(cf_bwd,@adata) then
      begin

      //ins
      creplace;

      case misformat(adata,xformat,xbase64) of
      true:xinsimg(adata);//text is an image
      else xioins(adata);//text is text
      end;//case

      //successful
      result:=true;
      goto skipend;

      end;

   end;


//image ------------------------------------------------------------------------

//Note: this is a dual handler: accepts binary images AND plain text, so must allow fallback when plain text is NOT an image - 22apr2026
if clip__canpasteimage(true) then
   begin

   //init
   a        :=misraw32(1,1);

   if clip__pasteimage(a,true) then //upon failure assume clipboard content is text and fallback to next paste handler below - 22apr2026, 18mar2026, 21dec2021, was fixed via "xinfo" - 18jun2021
      begin

      //init
      adata    :=str__new8;
      adata2   :=str__new8;

      //jif
      mis__todata(a,@adata,'jif',e);//bmp -> jif

      //.improve image quality for small image sizes - 16feb2026
      if (adata.len32<30000) then mis__todata2(a,@adata,'jif',ia_highquality,e);//bmp -> jif
      if (adata.len32<30000) then mis__todata2(a,@adata,'jif',ia_bestquality,e);//bmp -> jif

      v1       :=adata.len32;
      if (v1<=0) then v1:=max32;

      //png
      mis__todata(a,@adata2,'png',e);
      v2       :=adata2.len32;
      if (v2<=0) then v2:=max32;

      //ins
      creplace;

      case (v1<v2) of
      true:xinsimg(adata);//jif
      else xinsimg(adata2);//png
      end;//case

      //successful
      result:=true;
      goto skipend;

      end;

   end;


//text -------------------------------------------------------------------------

//Note: Do "text" last as some enhanced image formats can be presented
//      in Clipboard as plain text, e.g. base64 or Pascal array

if clip__hasformat(cf_text) then
   begin

   adata    :=str__new8;

   if clip__pastetext2(@adata) then
      begin

      //ins
      creplace;

      case misformat(adata,xformat,xbase64) of
      true:xinsimg(adata);//text is an image
      else xioins(adata);//text is text
      end;//case

      //successful
      result:=true;
      goto skipend;

      end;

   end;

skipend:
except;end;

//restore cursor
if not result then
   begin

   icursorpos:=c1;
   icursorpos2:=c2;

   end;

//free
freeobj(@a);
str__free(@adata);
str__free(@adata2);

{$else}
result:=false;
{$endif}

end;

procedure ttextcore.xapplyzoom;
var
   ff:tfastfont;
   fc:tfastchar;
   xlastwid,p:longint;
   wrd2:twrd2;
   xtxt,ximg,xmustchange:boolean;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

begin

//init
xmustchange :=false;
xlastwid    :=-1;//not set
wrd2.val    :=maxword;//not set
xfastcharInit(ff);

//get
for p:=1 to xlen32 do
begin

//was: if not low__wordcore__charinfo(x,p,1,xchar) then break;
if not xfastchar(ff,p,1,fc) then break;//17mar2025: 200% faster

xtxt        :=(fc.cs=wc_t);
ximg        :=(fc.cs=wc_i);

//.text only
if xtxt then//14mar2021
   begin

   //get
   if (fc.wid<>xlastwid) then
      begin

      //store current "wid"
      xlastwid        :=fc.wid;
      wrd2.val        :=xmakefont2(true,tv.name,tv.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,tv.align);

      end;

   //set
   if (fc.wid<>wrd2.val) then
      begin

      idata2.byt1[p-1]:=wrd2.bytes[0];
      idata3.byt1[p-1]:=wrd2.bytes[1];
      xmustchange     :=true;

      end;

   end;

end;//p

if xmustchange then contentChangedAll;//26mar2026

end;

function ttextcore.xcursorword_loose:string;//boundaries are "<=32", was: "spaces, tabs and return codes only" - 19jun2022
var
   p,s,slen:longint;
   fc:tfastchar;
begin

//defaults
result      :='';
s           :=0;
slen        :=0;

//find start point
for p:=icursorpos downto 1 do
begin

if not xslowchar(p,1,fc)                 then break
//was:   else if (xchar.cs<>wc_t) or ((xchar.c=ss10) or (xchar.c=ss9) or (xchar.c=ssSpace)) then break
else if (fc.cs<>wc_t) or (fc.c<=ssSpace) then break
else                                          s:=p;

end;//p

//find length
if (s>=1) then
   begin                   //32

   for p:=s to xlen32 do
   begin

   if not xslowchar(p,1,fc)                 then break
   //was: else if (xchar.cs<>wc_t) or ((xchar.c=ss10) or (xchar.c=ss9) or (xchar.c=ssSpace)) then break
   else if (fc.cs<>wc_t) or (fc.c<=ssSpace) then break
   else                                          slen:=p-s+1;

   end;//p

   end;

//get
if (s>=1) and (slen>=1) then result:=idata.str1[s,slen];

end;

procedure ttextcore.xmouseup_specialactions;
var
   v:string;
begin

if iviewurl and (selcount<=0) then
   begin

   v:=xcursorword_loose;
   if low__urlok(v,true) then runlow(v,'');

   end;

end;

procedure ttextcore.xwine_remakefonts;
var
   p:longint;
begin

for p:=0 to textcore_listmax do
begin

if (fref[p]<>'') and (fslot[p]<>res_nil) then fFILL(p,true);

end;//p

end;

procedure ttextcore.cwritealign;
var
   ff:tfastfont;
   fc:tfastchar;
   l32,p,xselstart,xselcount,xminp,xmaxp:longint;
   wrd2:twrd2;
   xmustchange:boolean;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

begin

//init
xmustchange :=false;
xselstart   :=selstart;
xselcount   :=selcount;
l32         :=xlen32;

if (xselcount>=1) then
   begin

   xminp    :=xselstart;
   xmaxp    :=xpos__rc(xselstart+xselcount-1);

   end
else
   begin

   xminp    :=frcmin32(icursorpos,1);
   xmaxp    :=xpos__rc(xminp);

   end;

xfastcharInit(ff);

//range
xminp       :=frcrange32(xminp,1,l32);//32
xmaxp       :=frcrange32(xmaxp,1,l32);//32

//check
if (xmaxp<xminp) then exit;

//flush redo list - 02may2023
mredoflush;

//m-undo - 28jun2022
mstore1;//previous

iundoinfo.style       :=musRangekeep;
iundoinfo.from1       :=xminp;
iundoinfo.len         :=xmaxp-xminp+1;

mstore1;

//get
for p:=xminp to xmaxp do
begin

//was: if not low__wordcore__charinfo(x,p,1,xchar) then break;
if not xfastchar(ff,p,1,fc) then break;//17mar2025: 200% faster

if (fc.cs=wc_t) and (fc.c=10) then
   begin

   wrd2.val:=xmakefont2(true,tv.name,tv.size,tv.color,tv.bgcolor,tv.brcolor,tv.bold,tv.italic,tv.underline,tv.strikeout,icurrentinfo.align);

   if (fc.wid<>wrd2.val) then
      begin

      idata2.byt1[p-1]:=wrd2.bytes[0];
      idata3.byt1[p-1]:=wrd2.bytes[1];
      xmustchange     :=true;

      end;

   end;

end;//p

if xmustchange then contentChangedFromLen( xminp ,xmaxp );//26mar2026

end;

function ttextcore.mcopy(sslot,dslot:longint):boolean;
var
   v,e:string;
begin

//defaults
result      :=false;

//range
sslot       :=frcrange32(sslot,low(iundoinfo.n),mmax);
dslot       :=frcrange32(dslot,low(iundoinfo.n),mmax);

//check
if (sslot=dslot) then
   begin

   result:=true;
   exit;

   end;

//get
v                     :=io__tempfolder;
iundoinfo.nUsed[dslot]:=true;
result                :=io__copyfile(v+iundoinfo.n[sslot],v+iundoinfo.n[dslot],e);

end;

function ttextcore.mcanundo:boolean;
begin
result:=iundoinfo.enabled and ( mundo__canundo(iundoinfo.list) or ((iundoinfo.style>musNone) and (iundoinfo.style<>musRecovered)) );
end;

function ttextcore.mundo:boolean;
var
   xfrom1,xlen,sslot,wstyle:longint;
   dmustslot:boolean;

   procedure dsave;
   begin

   mcopy(-1,mundo__newslot(iundoinfo.list));
   dmustslot:=false;

   end;

begin

//defaults
result      :=false;
wstyle      :=iundoinfo.style;
sslot       :=-1;
xfrom1      :=1;
xlen        :=0;

//check
if not mcanundo then exit;

//current -> temp
dmustslot:=(wstyle>musNone);

if dmustslot then
   begin

   if (wstyle=musNone) then
      begin

      //nil

      end
   else if (wstyle=musRecovered) then
      begin

      dmustslot:=false;

      str__clear(@iundoinfo.d1);
      str__clear(@iundoinfo.d2);
      str__clear(@iundoinfo.d3);

      iundoinfo.from1 :=1;
      iundoinfo.len   :=0;
      iundoinfo.act   :=muaRep;
      iundoinfo.style :=musNone;

      end
   else
      begin

      //was:   if (wstyle=musDelL) or (wstyle=musDelR) or (wstyle=musSel) or (wstyle=musSelKeep) or (wstyle=musRangeKeep) or (wstyle=musIns) or (wstyle=musInsimg) then mstore12(-1,true);
      mstore12(-1,true);
      dsave;

      end;

   end;

//load
if mundo__undo(iundoinfo.list,sslot) then mread1(sslot,true);

//temp -> slot
if dmustslot then dsave;//not ever used

//reposition the cursor - 28jun2022
icursor_keyboard_moveto   :=frcrange32(icursorpos,1,xlen32);//32
itimer_chklinecursorx     :=true;

//successful
result:=true;

end;

function ttextcore.mcanredo:boolean;
begin
result:=iundoinfo.enabled and mundo__canredo(iundoinfo.list);
end;

function ttextcore.mredo:boolean;
var
   sslot:longint;
begin

//defaults
result      :=false;
sslot       :=-1;

//check
if not mcanredo then exit;

//load
if mundo__redo(iundoinfo.list,sslot) then mread1(sslot,false);

//reposition the cursor - 28jun2022
icursor_keyboard_moveto   :=frcrange32(icursorpos,1,xlen32);//32
itimer_chklinecursorx     :=true;

//successful
result:=true;

end;

procedure ttextcore.setmaxformatlevel(x:longint);
begin
imaxformatlevel:=frcrange32(x,0,fmlMax);
end;

function ttextcore.xfindformatlevel:longint;//19jun2022
var//Returns the maximum format used: 0=txt (plaintext), 1=bwd, 2=bwp
   v,xlastw,p:longint;
   w:twrd2;

   function tv:ptextinfo;
   begin
   result:=@tlist[xlastw];
   end;

begin

//defaults
result      :=fmlTXT;

//check
if (xlen32<=1) then exit;

//get
xlastw      :=-1;

for p:=0 to (xlen32-1) do//32
begin

v           :=idata.pbytes[p];

case v of
9,10,32..255:begin

   if (result<=fmlTXT) then
      begin
      w.bytes[0]      :=idata2.pbytes[p];
      w.bytes[1]      :=idata3.pbytes[p];

      if (w.val<>xlastw) or (v=10) then
         begin

         //Note: aign=works ONLY with c=10 and no other characters - 19jun2022
         xlastw:=w.val;

         if tv.bold or tv.italic or tv.underline or tv.strikeout or (tv.bgcolor<>clnone) or (tv.brcolor<>clnone) or ((v=10) and (tv.align<>0)) then
            begin

            result:=fmlBWD;//enhanced text - bwd
            if (result>=imaxformatlevel) then break;

            end;

         end;

      end;

   end;//begin

0:begin//image -> not plain text

   xlastw   :=-1;
   result   :=fmlBWP;
   break;

   end;
end;//case

end;//p

end;

function ttextcore.xfind(const xtext:string;xcmd:string):boolean;
label
   redo,skipend;
var
   xpos,xlen,xtextlen:longint;
   v,v1,v2:byte;
begin

//defaults
result      :=false;

//check
if (xtext='') then exit;

//init
xcmd        :=strlow(xcmd);
xlen        :=xlen32;
xtextlen    :=low__len32(xtext);
xpos        :=frcmin32(cursorpos-1,0);//zero-based
v1          :=strbyte1(xtext,1);
v2          :=v1;

if      (v1>=uua) and (v1<=uuz) then v2:=v1+vvUppertolower
else if (v1>=lla) and (v1<=llz) then v2:=v1-vvUppertolower;

//check
if (xlen<xtextlen) or (xpos>=xlen) then goto skipend;

//find
redo:

if (xpos<xlen) then
   begin

   v        :=idata.bytes[xpos];

   if ((v=v1) or (v=v2)) and strmatch(idata.str[xpos,xtextlen],xtext) then
      begin

      result          :=true;
      cursorpos       :=1+xpos+xtextlen;
      cursorpos2      :=1+xpos;

      goto skipend;

      end;

   end;

//loop
inc(xpos);
if (xpos<xlen) then goto redo;

skipend:

{$ifdef gui}
if not result then sysfind_cmd:='find.finished';
{$endif}

end;

procedure ttextcore.xbackup(const xcap:string);
var
   e,dname,dext:string;
   xdata:tstr8;
begin
try

//defaults
xdata       :=nil;

//check
if not ibackup then exit;

//init
case xfindformatlevel of//0=txt (plaintext), 1=bwd, 2=bwp
fmlTXT :dext:='txt';
fmlBWD :dext:='bwd';
fmlBWP :dext:='bwp';
else    dext:='bwp';
end;//case

//get
xdata:=str__new8;

if xgetdata( xdata ,strdefb(dext,'txt') ,1 ,xlen32 ) then
   begin

   //init
   if (ibackupname<>'') then dname:=io__remlastext(io__safename(io__extractfilename(ibackupname))) else dname:='';

   //get
   io__tofile(io__backupfilename(dname+'.'+dext),@xdata,e);//25feb2023
   low__iroll(systrack_backupcount,1);//12feb2023

   end;

except;end;

//free
str__free(@xdata);

end;

function ttextcore.ccanmake:boolean;
begin
result:=not ireadonly;
end;

procedure ttextcore.cmakename(const xforce:boolean;xfontname:string);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   icurrentinfo.name:=strdefb(xfontname,font__name1);
   cwritesel__hasUndo( smFontname );

   end;

end;

procedure ttextcore.cmakesize(const xforce:boolean;xfontsize:longint);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   icurrentinfo.size:=font__safesize(xfontsize);
   cwritesel__hasUndo( smFontsize );

   end;

end;

procedure ttextcore.cmakecolor(const xforce:boolean;xcolor:longint);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   if (xcolor=clnone) then xcolor:=0;
   icurrentinfo.color:=xcolor;
   cwritesel__hasUndo( smColor );

   end;

end;

procedure ttextcore.cmakebold(const xforce,xval:boolean);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   icurrentinfo.bold:=xval;
   cwritesel__hasUndo( smBold );

   end;

end;

procedure ttextcore.cmakeitalic(const xforce,xval:boolean);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   icurrentinfo.italic:=xval;
   cwritesel__hasUndo( smitalic );

   end;

end;

procedure ttextcore.cmakeunderline(const xforce,xval:boolean);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   icurrentinfo.underline:=xval;
   cwritesel__hasUndo( smunderline );

   end;

end;

procedure ttextcore.cmakestrikeout(const xforce,xval:boolean);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   icurrentinfo.strikeout:=xval;
   cwritesel__hasUndo( smstrikeout );

   end;

end;

procedure ttextcore.cmakenormal(const xforce:boolean);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   with icurrentinfo do
   begin

   bold       :=false;
   italic     :=false;
   underline  :=false;
   strikeout  :=false;
   color      :=0;
   bgcolor    :=clnone;
   brcolor    :=clnone;

   end;

   cwritesel__hasUndo( smColor_Bgcolor_Style );

   end;

end;

procedure ttextcore.cmakehighlight(const xforce:boolean);
begin

if (ccanmake or xforce) and (imaxformatlevel>=1) then
   begin

   low__swapint(icurrentinfo.color,icurrentinfo.bgcolor);
   if (ionefontname<>'') and (icurrentinfo.color<>clnone) and (icurrentinfo.bgcolor<>clnone) then icurrentinfo.bgcolor:=clnone;

   cwritesel__hasUndo( smColor_Bgcolor );

   end;

end;

procedure ttextcore.cmakeuppercase(const xforce:boolean);
begin

if (ccanmake or xforce) then
   begin

   cwritesel__hasUndo( smUppercase );

   end;

end;

procedure ttextcore.cmakelowercase(const xforce:boolean);
begin

if (ccanmake or xforce) then
   begin

   cwritesel__hasUndo( smLowercase );

   end;

end;

function ttextcore.ccanmakealign:boolean;
begin
result:=ccanmake and (imaxformatlevel>=2);
end;

procedure ttextcore.cmakealignment(const xforce:boolean);//cycles through alignment modes
var
   int1:longint;
begin

int1               :=icurrentinfo.align+1;//0=left, 1=centre, 2=right
if (int1>wcaMax) then int1:=wcaLeft;

cmakealign(false,int1);

end;

procedure ttextcore.cmakealign(const xforce:boolean;xval:longint);
begin

if (ccanmakealign or xforce) and (imaxformatlevel>=2) then
   begin

   icurrentinfo.align  :=frcrange32(xval,0,wcaMax);
   cwritealign;

   end;

end;

procedure ttextcore.cmakeleft(const xforce:boolean);
begin
cmakealign(xforce,wcaLeft);
end;

procedure ttextcore.cmakecenter(const xforce:boolean);
begin
cmakealign(xforce,wcaCenter);
end;

procedure ttextcore.cmakeright(const xforce:boolean);
begin
cmakealign(xforce,wcaRight);
end;

procedure ttextcore.setlinespacing(x:longint);
begin

if low__setint(ilinespacing,frcrange32(x,1,4)) then
   begin

   xwrap_hvsync_changed;

   end;

end;

procedure ttextcore.syncdef(const xfontname:string;const xfontsize,xfontcolor,xpagecolor,xpageselcolor,xpagefontselcolor,xviewcolor:longint);
begin

idefFontname      :=xfontname;
idefFontsize      :=xfontsize;
idefFontcolor     :=xfontcolor;
pageselcolor     :=xpageselcolor;
pagefontselcolor :=xpagefontselcolor;
viewcolor         :=xviewcolor;
pagecolor         :=xpagecolor;

end;

function ttextcore.canshortcut(const xkeycode:longint):boolean;//15feb2026
begin

//defaults
result:=false;

//editing based shortcuts
if ishortcuts then
   begin

   case xkeycode of
   akctrlP,akctrlT,akctrlC,akctrlU,akctrlR :result:=true;
   akf3,akf4                               :result:=true;//18feb2023
   akf7                                    :result:=idic;//05feb2023
   end;//case

   end;

//styling based shortcuts
if istyleshortcuts and (not result) then
   begin

   case xkeycode of
   akctrlN,akctrlB,akctrlI,akctrlD,akctrlK,akctrlH,akctrlZ :result:=true;
   end;//case

   end;

end;

procedure ttextcore.shortcut(const xkeycode:longint);//15feb2026

    function bs(const x:string):boolean;
    begin

    result:=true;
    if (x<>'') then ibriefstatus:=x;

    end;

begin

//check
if (not canshortcut(xkeycode)) and bs('Unable') then exit;

//get --------------------------------------------------------------------------
case xkeycode of

//edit shortcuts
akctrlP:if ishortcuts and canpaste and bs('Paste') then paste;
akctrlT:if ishortcuts and cancut   and bs('Cut')   then cut;
akctrlC:if ishortcuts and cancopy  and bs('Copy')  then copy;
akctrlU:if ishortcuts and canundo  and bs('Undo')  then undo;
akctrlR:if ishortcuts and canredo  and bs('Redo')  then redo;

//style shortcuts
akctrlN:if istyleshortcuts and ccanmake  and bs('Normal')      then cmakenormal(false);
akctrlB:if istyleshortcuts and ccanmake  and bs('Bold')        then cmakebold(false,not cbold);
akctrlI:if istyleshortcuts and ccanmake  and bs('Italic')      then cmakeitalic(false,not citalic);
akctrlD:if istyleshortcuts and ccanmake  and bs('Underline')   then cmakeunderline(false,not cunderline);
akctrlK:if istyleshortcuts and ccanmake  and bs('Strikeout')   then cmakestrikeout(false,not cstrikeout);
akctrlH:if istyleshortcuts and ccanmake  and bs('Highlight')   then cmakehighlight(false);
akctrlZ:if istyleshortcuts and ccanmake  and bs('Alignment')   then cmakealignment(false);

end;//case

end;

procedure ttextcore.keyboard(const xctrl,xalt,xshift,xkeyX:boolean;const xkey:byte);
begin

ikstack.addint4(5);//len=5b
ikstack.addbol1(xctrl);
ikstack.addbol1(xalt);
ikstack.addbol1(xshift);
ikstack.addbol1(xkeyX);
ikstack.addbyt1(xkey);

end;

procedure ttextcore.keyboard2(const akcode:longint);
begin

ikstack.addint4(5);//len=5b
ikstack.addbyt1(2);//using "akcode" system
ikstack.addint4(akcode);

end;

procedure ttextcore.mouse(const xmousex,xmousey:longint;const xmousedown,xmouseright:boolean);
begin

imstack.addint4(10);//len=10b
imstack.addint4(xmousex);
imstack.addint4(xmousey);
imstack.addbol1(xmousedown);
imstack.addbol1(xmouseright);

end;

function ttextcore.canpaint:boolean;
begin

result:=(iwrapstack.len<=0);

end;

function ttextcore.xdocsep(i,xdepthcount:longint):boolean;//slow, mainly for dic support - 05feb2023
begin

case docchar(i) of
0..38,40..47,58..64,91..96,123..191,247 :result:=true;
ssSingleQuote                           :result:=(xdepthcount>=3) or (xdocsep(i-1,xdepthcount+1) or xdocsep(i+1,xdepthcount+1));
else                                     result:=false;
end;//case

end;

function ttextcore.docsep(const i:longint):boolean;//slow, mainly for dic support - 26feb2023, 05feb2023
begin
result:=xdocsep(i,0);
end;

function ttextcore.xdocsep2(i,xdepthcount:longint;const xsplitdash:boolean):boolean;//slow, mainly for dic support - 05feb2023
begin

case docchar(i) of
0..38,40..44,46..47,58..64,91..96,123..191,247 :result:=true;
ssDash                                         :result:=xsplitdash;
ssSingleQuote                                  :result:=(xdepthcount>=3) or (xdocsep2(i-1,xdepthcount+1,xsplitdash) or xdocsep2(i+1,xdepthcount+1,xsplitdash));
else                                            result:=false;
end;//case

end;

function ttextcore.docsep2(const i:longint;const xsplitdash:boolean):boolean;//slow, mainly for dic support - 26feb2023, 05feb2023
begin
result:=xdocsep2(i,0,xsplitdash);
end;

function ttextcore.docchar(i:longint):byte;//slow, mainly for dic support - 05feb2023
var
   fc:tfastchar;
begin
if xslowchar(i,1,fc) then result:=fc.c else result:=0;
end;

function ttextcore.paintlock(const xlock:boolean):boolean;
begin

if xlock then
   begin

   result:=not ipaintlock;
   if result then ipaintlock:=true;

   end
else begin

   result:=ipaintlock;
   if result then ipaintlock:=false;

   end;

end;

procedure ttextcore.sethavefocus(x:boolean);
begin

if low__setbol(ihavefocus,x) then imustpaint:=true;

end;

function ttextcore.xautoPageColor:longint;
begin
result:=low__aorb(ipagecolor,ipagecolor2,ipageoverride2);//auto detect current pagecolor
end;

procedure ttextcore.setpagecolor(x:longint);
begin
if low__setint(ipagecolor,x) then xchanged;
end;

procedure ttextcore.setpagecolor2(x:longint);
begin
if low__setint(ipagecolor2,x) then xchanged;
end;

procedure ttextcore.setpagefontcolor2(x:longint);
begin
if low__setint(ipagefontcolor2,x) then xchanged;
end;

procedure ttextcore.setpageoverride2(x:boolean);
begin
if low__setbol(ipageoverride2,x) then xchanged;
end;

procedure ttextcore.setpageselcolor(x:longint);
begin
if low__setint(ipageselcolor,x) then xchanged;
end;

procedure ttextcore.setpagefontselcolor(x:longint);
begin
if low__setint(ipagefontselcolor,x) then xchanged;
end;

procedure ttextcore.setviewcolor(x:longint);
begin
if low__setint(iviewcolor,x) then xchanged;
end;

procedure ttextcore.setviewwidth(x:longint);
begin

if low__setint(iviewwidth,frcmin32(x,1)) then
   begin

   xpagewidth;
   xpageheight;
   xwrap_hvsync_changed;

   end;

end;

procedure ttextcore.setviewheight(x:longint);
begin

if low__setint(iviewheight,frcmin32(x,1)) then
   begin

   ivhostsync:=true;
   imustpaint:=true;

   end;

end;

procedure ttextcore.dic_spell;
label
   redo,skipend;
var
   p,int1,int2,xlen,xmin:longint;
   xsplitdash,xinside,dinside:boolean;
   xaddword,v:string;

   function vhasdash:boolean;
   var
      p:longint;
   begin
   result:=false;

   if (v<>'') then
      begin

      for p:=1 to low__len32(v) do if (strbyte1x(v,p)=ssDash) then
         begin

         result:=true;
         break;

         end;//p

      end;

   end;

begin

//init
xsplitdash  :=false;
xaddword    :='';

redo:
xlen        :=xlen32;
xmin        :=frcrange32(icursorpos-1,1,xlen);

//.nudge forward if cursor is standing on a word separator - 05feb2023
if docsep2(xmin,xsplitdash) then inc(xmin);

//get
xinside:=not docsep2(xmin,xsplitdash);

for p:=(xmin+1) to xlen do
begin

dinside:=not docsep2(p,xsplitdash);

if (xinside<>dinside) then
   begin

   xinside:=dinside;

   if xinside then
      begin

      {$ifdef gui}

      v:=dic_extractwordfromdoc(p+1,xsplitdash,int1,int2);

      if dic__misspelt(v) then
         begin

         //.repeat spell check but break words on the dash this time - 05feb2023
         if (not xsplitdash) and vhasdash then
            begin

            xsplitdash:=true;
            goto redo;

            end;

         //.highlight the word
         cursorpos  :=p;
         cursorpos2 :=int2+1;

         //.addword option
         xaddword:=v;
         goto skipend;

         end;

      {$endif}
      
      end;

   end;

end;//p

//successful

{$ifdef gui}
pop_info('Speller','Spell check complete');
{$endif}

skipend:

//finalise
idic_addword:=xaddword;

end;

function ttextcore.dic_extractwordfromdoc(xcursorpos:longint;xsplitdash:boolean;var xfrom,xto:longint):string;
var
   p:longint;
begin

//defaults
result      :='';

//init
xcursorpos  :=frcrange32(xcursorpos-1,1,xlen32);
xfrom       :=-1;
xto         :=0;

//.nudge forward if cursor is standing on a word separator - 05feb2023
if docsep2(xcursorpos,xsplitdash) then inc(xcursorpos);

//left
for p:=xcursorpos downto frcmin32(xcursorpos-500,1) do if docsep2(p,xsplitdash) then break else xfrom:=p;

//right
for p:=xcursorpos to frcmax32(xlen32,xcursorpos+500) do if docsep2(p,xsplitdash) then break else xto:=p;

//get
result:=idata.str1[xfrom,xto-xfrom+1];

end;

function ttextcore.xfindUrl(const xpos1:longint;var xurlpos,xurlpos2:longint):boolean;//03mar2026
var
   ff:tfastfont;
   fc:tfastchar;
   p:longint;
begin

//defaults
result      :=false;
xurlpos     :=0;
xurlpos2    :=0;

//check
if (xpos1<=0)                               then exit;
if not low__urlok(idata.str1[xpos1,8],true) then exit;

//init
xfastcharinit(ff);

//before
if (xpos1>=2) and xfastchar(ff,xpos1-1,1,fc) and (fc.c>ssSpace) then exit;

//start
xurlpos      :=xpos1;

//after
for p:=xpos1 to (xpos1+1999) do//03mar2026
begin

if (not xfastchar(ff,p,1,fc)) or (fc.c<=ssSpace) then
   begin

   xurlpos2  :=frcmin32(p-1,0);
   break;

   end;

xurlpos2     :=p;

end;//p

//result
result:=(xurlpos>=1) and (xurlpos2>=1);

end;

function ttextcore.canrender:boolean;
begin

result:=true;

end;

function ttextcore.render(xcliparea:twinrect;const xpaintarea:twinrect;const xpower255,xrowcolor,xbackColor:longint32):boolean;//28feb2026
label
   skipchar,redo,skipdone,skipend;
var
   ar24:pcolorrows24;
   ar32:pcolorrows32;
   ff:tfastfont;
   fc,xcur:tfastchar;
   v1,v2,flastid,xtextColor,xselcol1,xselcol2,aw,ah,xwrapstyle,xlinespacing,xhpos,xvpos,ax,ay,xselstart,xselcount,sel1,sel2,int1,intPART1,lx,ly,lh,lh1,xpos,xcount,lpos,lp,lc,xlen,p,dx,dy,sx,sy,sw,sh:longint;
   hdelta,xdecoration,xfeather,xurlpos,xurlpos2,xpagecolor,xpagefontselcolor,xpageselcolorX,xpageselcolor,xpagefontcolor2,xpagecolor2:longint;
   xoutOfSync,dspell,xpageoverride2,bol1,bol2,bol3,xrowok,xcursoronscrn:boolean;
   acliparea:twinrect;

   function tv:ptextinfo;
   begin
   result:=@tlist[fc.wid];
   end;

   function iv:pimageinfo;
   begin
   result:=@ilist[fc.wid];
   end;

   procedure xdrawrow;//28feb2026
   var
      a:twinrect;
   begin

   //check
   if (xrowcolor=clnone) then exit;

   //x-range
   a.left   :=acliparea.left;
   a.right  :=acliparea.right;

   if (a.right<a.left) then exit;

   //y-range
   a.top    :=ly;
   a.bottom :=ly+lh-1;

   if (a.top>acliparea.bottom) or (a.bottom<acliparea.top) then exit;

   a.top    :=frcrange32(a.top      ,acliparea.top,acliparea.bottom);
   a.bottom :=frcrange32(a.bottom   ,acliparea.top,acliparea.bottom);

   //render
   fast__fillArea( acliparea, a, xrowcolor );

   //mark out-of-sync
   xoutOfSync:=true;

   end;

   procedure xdrawhighlight(const xcolor:longint32);
   var
      a:twinrect;
   begin

   //check
   if (xcolor=clnone) then exit;

   //y-range
   a.top    :=ly;
   a.bottom :=ly+lh-1;

   if (a.top>acliparea.bottom) or (a.bottom<acliparea.top) then exit;

   a.top    :=frcrange32(a.top      ,acliparea.top,acliparea.bottom);
   a.bottom :=frcrange32(a.bottom   ,acliparea.top,acliparea.bottom);

   //x-range
   a.left   :=sx;
   a.right  :=sx+fc.width-1;

   if (a.left>acliparea.right) or (a.right<acliparea.left) then exit;

   a.left   :=frcrange32(a.left     ,acliparea.left,acliparea.right);
   a.right  :=frcrange32(a.right    ,acliparea.left,acliparea.right);

   //render
   fast__fillArea( acliparea, a, xcolor );

   //mark out-of-sync
   xoutOfSync:=true;

   end;

   procedure xdrawsel(const xmerge:boolean;const xcolor:longint32);
   var
      a:twinrect;
   begin

   //check
   if (xcolor=clnone) then exit;

   //y-range
   a.top    :=ly;
   a.bottom :=ly+lh-1;

   if (a.top>acliparea.bottom) or (a.bottom<acliparea.top) then exit;

   a.top    :=frcrange32(a.top      ,acliparea.top,acliparea.bottom);
   a.bottom :=frcrange32(a.bottom   ,acliparea.top,acliparea.bottom);

   //x-range
   a.left   :=sx;
   a.right  :=sx+fc.width-1;

   if (a.left>acliparea.right) or (a.right<acliparea.left) then exit;

   a.left   :=frcrange32(a.left     ,acliparea.left,acliparea.right);
   a.right  :=frcrange32(a.right    ,acliparea.left,acliparea.right);

   //render
   case xmerge of
   true:begin

      fast__fillArea3( acliparea, a, xcolor, xpower255 div 2, 0, 0, false );
      fd__setval( fd_power ,xpower255 );

      end;
   else fast__fillArea3( acliparea, a, xcolor, xpower255, 0, 0, false );
   end;//case

   //mark out-of-sync
   xoutOfSync:=true;

   end;

begin

//defaults
result                :=false;
xcursoronscrn         :=false;
xurlpos               :=0;//off
xurlpos2              :=0;
ar24                  :=nil;
ar32                  :=nil;

//check
if (xpower255<=0) or (xpower255>255) then exit;

aw                    :=fd_focus.b.w;
ah                    :=fd_focus.b.h;

//check
if (xcliparea.right<xcliparea.left)   or (xcliparea.bottom<xcliparea.top)   then exit;
if (xpaintarea.right<xpaintarea.left) or (xpaintarea.bottom<xpaintarea.top) then exit;

//cliparea + adjust coordinates to match host system - 23aug2020
acliparea.left        :=frcrange32( largest32  (xcliparea.left    ,xpaintarea.left    ),0,aw-1);
acliparea.right       :=frcrange32( smallest32 (xcliparea.right   ,xpaintarea.right   ),0,aw-1);
acliparea.top         :=frcrange32( largest32  (xcliparea.top     ,xpaintarea.top     ),0,ah-1);
acliparea.bottom      :=frcrange32( smallest32 (xcliparea.bottom  ,xpaintarea.bottom  ),0,ah-1);
ax                    := - (xcliparea.left-acliparea.left);
ay                    := - (xcliparea.top -acliparea.top);

//init
xfastcharinit(ff);

//.rowback colors -> for drawing alternative row background colors
xrowok                :=true;//toggles alternating color drawing
xwrapstyle            :=iwrapstyle;
xlinespacing          :=frcmin32(ilinespacing,1);
xselcol1              :=ipageselcolor;
xselcol2              :=int__dif24(ipageselcolor,-35);
xpagefontselcolor     :=ipagefontselcolor;
xpageselcolor         :=ipageselcolor;
xpageselcolorX        :=int__dif24(xpageselcolor,10);
xpagefontcolor2       :=ipagefontcolor2;
xpagecolor            :=ipagecolor;
xpagecolor2           :=ipagecolor2;
xpageoverride2        :=ipageoverride2;
xselstart             :=selstart;
xselcount             :=selcount;
xfeather              :=ifeather;
flastid               :=-1;

case (xselcount>=1) of
true:begin

   sel1               :=xselstart;
   sel2               :=sel1+xselcount-1;

   end;
else begin

   sel1               :=-1;
   sel2               :=-1;

   end;
end;//case

//init render ------------------------------------------------------------------
fd__set( fd_fillAreaDefaults );
fd__setval( fd_textColor, 0 );//color1
fd__setval( fd_power, xpower255 );
fd__setarea( fd_clip ,acliparea );
fd__setarea( fd_area ,acliparea );
xoutOfSync            :=false;



//len
xlen                  :=xlen32;
if (xlen<1) then goto skipdone;

//find start line (top of client area)
xhpos                 :=hpos;//11mar2021
xvpos                 :=vpos;

if (xvpos>=0) and (xvpos<ilinecount) and (xvpos<ilinesize) then
   begin

   int1               :=iliney[xvpos];
   intPART1           :=ivposPART;

   end
else
   begin

   int1               :=0;
   intPART1           :=0;

   end;

//was: lpos:=low__wordcore_str2(x,'y>line',intstr32(int1));
lpos                  :=y__toline( int1 + low__insint(intPART1,intPART1<0) );
if (int1<>0) then inc(ay,int1);
inc(ay,intPART1);//21jun2022
if (lpos<0) or (lpos>=ilinecount) or (lpos>=ilinesize) then goto skipdone;

xrowok                :=low__iseven(lpos);//sync color alternation to row - 03mar2026


//-- Paint By Lines ------------------------------------------------------------
//Note: Painting by lines requires 14x less RAM to map characters with
//      little to no extra lag time - Aug2019
//------------------------------------------------------------------------------

//xpaintarea.left+xhpos;

redo:

//get
xpos                  :=line__topos(lpos);//convert line number (0..N) into a text position "xpos", e.g. character at location -> "x.data[xpos]"
if (xpos<=0) or (xpos>xlen) then goto skipdone;

xcount                :=xline__itemcount(lpos);//return number of characters in the line
if (xcount<=0) then goto skipdone;

//.line info
lx                    :=ilinex[lpos]+acliparea.left-ax-xhpos;//need to fill this in later..xxxxxxxxxxxxxxxxxxxxxxxxx
ly                    :=iliney[lpos]+acliparea.top-ay;
lh                    :=ilineh[lpos];
lh1                   :=ilineh1[lpos];


//.draw alternating row background color
if (xrowcolor<>clnone) then
   begin

   if xrowok then xdrawrow;
   xrowok             :=not xrowok;

   end;

//draw each line using their series of in-order "chars"
sx                    :=lx;
hdelta                :=-lx;//used to align-dashed underline(s)

for p:=xpos to (xpos+xcount-1) do//1-based
begin

//.check
if (p<0) or (p>xlen) then goto skipdone;

//.wrap more
if (p>iwrapcount) then
   begin

   //can't paint -> wrap is not upto date
   xwrapto(p+ic_pagewrap);

   //trigger a repaint
   imustpaint         :=true;
   goto skipdone;

   end;

//.get char
if not xfastchar(ff,p,1,fc) then goto skipdone;//FASTER - 19jun2022 - 1-based

//.sy
sy                    :=ly+lh1-fc.height1;


//.scan for url - 03mar2026
if iviewurl and (fc.cs=wc_t) and (fc.c<>10) and (p>xurlpos2) then
   begin

   //init
   bol3         :=false;

   //.http and https
   if ((fc.c=uuH) or (fc.c=llH)) then
      begin

      int1      :=idata.bytes[p];//0-based
      bol3      :=(int1=uuT) or (int1=llT);

      end
   //.ftp and ftps
   else if ((fc.c=uuF) or (fc.c=llF)) then
      begin

      int1      :=idata.bytes[p];
      bol3      :=(int1=uuT) or (int1=llT);

      end
   //.mailto
   else if ((fc.c=uuM) or (fc.c=llM)) then
      begin

      int1      :=idata.bytes[p];
      bol3      :=(int1=uuA) or (int1=llA);

      end;

   //get
   if bol3 then
      begin

      if xfindUrl(p,v1,v2) then
         begin

         xurlpos   :=v1;
         xurlpos2  :=v2;

         end;

      end;

   end;


//.char not visible -> skip over char
if ((sx+fc.width)<acliparea.left) then goto skipchar;


//.draw char
if (fc.cs=wc_t) then
   begin

   if (fc.c<>10) then
      begin

      //draw highlight
      bol2            :=(tv.bgcolor<>clnone);
      if bol2 then xdrawhighlight(low__aorb(tv.bgcolor,xpageselcolor,xpageoverride2));

      //draw sel
      bol1            :=false;

      if (p>=sel1) and (p<=sel2) then
         begin

         if bol2 then xdrawsel(false,xselcol2) else xdrawsel(false,xselcol1);

         bol1         :=true;

         end;

      //draw character
      if (fc.c<>9) then
         begin

         //.lgfFILL
         //was: if (not idataonly) and (blen32(ilgfdata[fc.txtid])<=0) then xlgfFILL(fc.txtid,false);

         //.text color
         if      bol1           then xtextColor     :=xpagefontselcolor
         else if xpageoverride2 then
            begin

            case (tv.bgcolor<>clnone) of
            true:xtextColor:=xpagefontselcolor;
            else xtextColor:=xpagefontcolor2;
            end;//case

            end
         else xtextColor                            :=tlist[fc.wid].color;//text color

         //.draw character
         dspell                                     :=idic and idicshow and (p>=idicfrom) and (p<=idicto);


         //render re-sync ------------------------------------------------------
         if xoutOfSync then
            begin

            xoutOfSync          :=false;

            fd__set( fd_fillAreaDefaults );
            fd__setval( fd_power, xpower255 );
            fd__setarea( fd_clip ,acliparea );

            end;


         //render character ----------------------------------------------------

         if (fc.txtid<>flastid) then
            begin

            flastid   :=fc.txtid;
            fd__setval( fd_font ,fslot[ flastid ] );

            end;

         fd__setval( fd_textColor, xtextColor );//color1

         xdecoration            :=cdNone;

         if tv.underline                   then inc( xdecoration ,cdUnderline );
         if tv.strikeout                   then inc( xdecoration ,cdStrikeout );
         if dspell                         then inc( xdecoration ,cdSpell     );
         if (p>=xurlpos) and (p<=xurlpos2) then inc( xdecoration ,cdUrl       );//03mar2026

         fd__setval( fd_charDecoration ,xdecoration );

         fd__drawChar( fc.c ,sx ,sy ,ly ,lh ,hdelta ,xbackColor );//supply custom topOfLine(ly) and lineHeight(ff.h=without linespacing) for consistent formatting of different fonts/sizes on same line - 28feb2026

         end;

      end;

   end
else if (fc.cs=wc_i) then
  begin

  //draw image//???????????????????????? no zoom support //???????????????????
  if (iv.img32<>nil) then
     begin

     case (iv.sysTEP>=0) of
     true:tep__draw2( acliparea ,iv.sysTEP ,sx ,ly+lh1-fc.height ,xvaluefromhost('mfont',0),xvaluefromhost('mline',rgba0__int(120,120,120)),clWhite,clBlack,xpower255 );
     else begin

        fd__setbuffer( fd_buffer2 ,iv.img32 );
        fd__setarea2( fd_area ,sx ,ly+lh1-fc.height ,fc.width ,fc.height );
        fd__setval( fd_power ,xpower255 );
        fd__render( fd_drawRGBA );//25mar2026

        end;
     end;//case
     
     end;

  //draw sel (ontop of image)
  if (p>=sel1) and (p<=sel2) then xdrawsel(true,xselcol1);

  end;

skipchar:

//.draw cursor -> mask support as of 04feb2023, 26aug2020
if (p=icursorpos) then
   begin

   xcursoronscrn      :=true;

   if idrawcursor and ihavefocus and xfastchar(ff,frcmin32(p-1,1),1,xcur) then
      begin

      xoutOfSync          :=true;

      fd__set( fd_fillAreaDefaults );
      fd__setval( fd_power, xpower255 );
      fd__setarea2( fd_area ,sx ,ly+lh1-xcur.height1 ,frcmin32(round32(2*xviscale),1) ,xcur.height );
      fd__render( fd_invertCorrectedArea );

      end;

   end;//cursor

//.inc
inc(sx,fc.width);
if (sx>acliparea.right) then break;//19jun2022

end;//p

//.next line
inc(lpos);
if (ly<ah) and (lpos<ilinecount) and (lpos<ilinesize) then goto redo;

//.sync
icursoronscrn         :=xcursoronscrn;

//successful
skipdone:
result                :=true;
skipend:

end;

function ttextcore.xvaluefromhost(const n:string;const defVal:longint):longint32;
begin


//black and white override -----------------------------------------------------
if (not syscols) and (n='mfont') or (n='mline') then
    begin

    result:=defVal;
    exit;

    end;

    
//get value from host ----------------------------------------------------------
case assigned(fonvaluefromhost) of
true:result           :=fonvaluefromhost(n);
else result           :=defVal;
end;//case

end;

function ttextcore.xsyncSysTeps:boolean;
var
   p:longint;
begin

//defaults
result      :=false;

//get
for p:=0 to textcore_listmax do if (ilist[p].sysTEP>=0) then
   begin

   ilist[p].w         :=tep__width ( ilist[p].sysTEP );
   ilist[p].h         :=tep__height( ilist[p].sysTEP );
   result             :=true;

   end;//p

end;

procedure ttextcore.xtimer;
label
   skipkeyboard;
var
   int1,int2,int3,int4,c,dx,dy:longint;
   xctrl,xalt,xshift,xkeyx,bol1,bol2,bol3,xmustpaint:boolean;
   xcursor_keyboard_moveto:longint;
   xchklinecursorx:boolean;
begin

//lock
if itimerbusy then exit else itimerbusy:=true;


try

//init
xmustpaint            :=false;


//wine sync --------------------------------------------------------------------
if low__setint(ilastvisyncid,xvisyncid) or (slowms64>=itimerfont500) then
   begin                                                                                                                                                                                   //13feb2022

   //system TEPs adjust to system scale -> re-wrap if scale changes AND we have 1 or more system teps - 25mar2026
   if (not idataonly) and (ilastscale<>xviscale) then
      begin

      ilastscale      :=xviscale;

      if xsyncSysTeps then
         begin

         xwrapall;
         xmustpaint   :=true;

         end;

      end;

   //rebuild fonts for wine
   if (not idataonly) and low__or3(low__setstr(isysfontDefault,font__realname(font__name1)),low__setstr(isysfontDefault2,font__realname(font__name2)),low__setstr(ionefontREF,intstr32(ionefontsize)+'|'+insstr(intstr32(xvifontsize),ionefontsize=0)+'|'+insstr(intstr32(xvifontsize2),ionefontsize=1)+'|'+font__realname(ionefontname)))  then
      begin

      xwine_remakefonts;
      xpagewidth;
      xpageheight;
      xwrap_hvsync_changed;

      end;

   //reset
   itimerfont500:=slowms64+500;

   end;


//mstack -----------------------------------------------------------------------
while xstackpull(imstack,itmp1) do
begin

if (blen32(itmp1)>=10) then
   begin

   //init
   xnoidle;
   dx           :=itmp1.int4[0];//0..3
   dy           :=itmp1.int4[4];//4..7
   bol1         :=(itmp1.bol1[8]);//8 - down
   bol2         :=(itmp1.bol1[9]);//9 - right click
   bol3         :=false;//was barfocused

   //.sync cursor
   icursorstyle :='t';//text cursor

   //get

   //.text box
   if bol1 and (not bol2) then
      begin

      xsetcursorpos2(xy__topos(dx,dy),iwasdown);

      end;//if

   //left.mouse.button.upstroke -> special actkions
   if (not bol2) and (not bol1) and iwasdown and (not iwasright) then xmouseup_specialactions;

   //set
   iwasdown     :=bol1;
   iwasright    :=bol2;

   end;//if

   end;//while


//kstack -----------------------------------------------------------------------
while xstackpull(ikstack,itmp1) do
begin

if (blen32(itmp1)>=5) then
   begin

   //init
   xnoidle;
   knoidle;

   case itmp1.byt1[0] of
   2:begin//ak_code keyboard system

      if (akshift=itmp1.int4[1]) then
         begin

         ishift       :=true;
         goto skipkeyboard;

         end
      else if (akshiftup=itmp1.int4[1]) then
         begin

         ishift       :=false;
         goto skipkeyboard;

         end
      else
         begin

         xkeyboard__fromak(itmp1.int4[1],xctrl,xalt,xshift,xkeyx,int1,bol1);
         xshift       :=ishift;//retain value
         c            :=int1;
         if not bol1 then goto skipkeyboard;

         end;
      end;
   0..1:begin//traditional MS keyboard input

      xctrl           :=itmp1.bol1[0];//0
      xalt            :=itmp1.bol1[1];//1
      xshift          :=itmp1.bol1[2];//2
      xkeyx           :=itmp1.bol1[3];//3
      c               :=itmp1.byt1[4];//4

      end;
   else
      begin//unspported keyboard input format - 24aug2020

      xctrl           :=false;
      xalt            :=false;
      xshift          :=false;
      xkeyx           :=false;
      c               :=63;//?

      end;
   end;//case

   //clear
   itmp1.clear;

   //.retain these key states - 31aug2019
   ishift             :=xshift;

   //get
   //.shortcut           //((c>='A') and (c<='Z'))
   if xctrl and xkeyx and ((c>=65) and (c<=90)) then shortcut(akctrlA+c-65)

   //.special key / standard character
   else vkeypress(c,xctrl,xalt,xkeyx);

   end;//if

skipkeyboard:

end;//while


//.find support ----------------------------------------------------------------

{$ifdef gui}
if (sysfind_handler=ifindhandler) and (sysfind_cmd='find') then
   begin

   sysfind_cmd        :='';
   xfind(sysfind_text,'find');

   end;
{$endif}


//.cursor alignment checkers ---------------------------------------------------
xcursor_keyboard_moveto   :=icursor_keyboard_moveto;
icursor_keyboard_moveto   :=0;//take value and set to zero (off)

xchklinecursorx           :=itimer_chklinecursorx;
itimer_chklinecursorx     :=false;


//wrap list --------------------------------------------------------------------

//init
bol1        :=false;
int1        :=max32;
int2        :=min32;

//.special "timer_setcursorpos" -> need to wrap to this point inorder to paint the screen AND set the cursor for real - 30aug2019
if (xcursor_keyboard_moveto>=1) then
   begin

   xsetcursorpos2(xcursor_keyboard_moveto,ishift);//auto adds wrap request if required

   end;

//get
if not ihostsizing then
   begin

   while xwrappull(int3,int4) do
   begin

   if (int3>=0) and (int4>=0) then
      begin

      //extend range
      if (int3<int1) then int1:=int3;
      if (int4>int2) then int2:=int4;

      bol1  :=true;

      end;

   end;//while

   end;

//set
if bol1 then
   begin

   //reposition realtime wrap
   case (int1=int2) of
   true:iwrapcount:=frcrange32(int1,0,xlen32)
   else xwrapnow(int1,int2,ivpos+1);//.rewrap selected area
   end;//case

   //update
   xmustpaint   :=true;

   end;


//realtime wrap -------------------------------------------------------------
if (slowms64>=itimer100) then
   begin

   int1     :=iwrapcount;

   if (idata.len>=1) and (int1<xlen32) and (not ihostsizing) then
      begin

      //init
      if      (low__keyidle<=2000) then int2:=1000
      else if (low__keyidle<=5000) then int2:=ic_smallwrap
      else                              int2:=ic_bigwrap;

      //get
      xwrapnow(int1,int1+int2,ivpos+1);

      if (int1<>iwrapcount) then xmustpaint:=true;

      end;

   //system feather
   if isysfeather then ifeather:=xvifeather;//26aug2020

   //sync
   if low__setstr(isyncref,
      intstr32(iviewwidth)  +'|'+
      intstr32(iviewheight) +'|'+
      intstr32(ipagewidth)  +'|'+
      intstr32(ipageheight) +'|'+
      intstr32(ifeather)+'|'+//02jun2020, 21sep2019
      '') then xmustpaint:=true;

   //reset
   itimer100:=add64(slowms64,100);
   
   end;

   
//vhostsync -----------------------------------------------------------------
if (ivpos>=ilinecount) then
   begin

   //Note: Required when not using "vpos.px" -> e.g. "basicbwp.vsmooth:=false"
   //was: low__wordcore_str(x,'vpos',intstr32(x.linecount-1));
   vpos_px:=xsafelineb(vpos);//must use "vpos.px" for accurate reposition - 06feb2023

   end;

if (xcursor_keyboard_moveto>=1) or (ivcheck>=1) then
   begin

   //was: x.vcheck:=frcmin32(x.vcheck-1,0);// -> this was taking TOO long when selecting text up and down rapidly THEN attempting to scroll with scrollbar caused the scrollbar to PAUSE for seconds without movement - 25jul2021
   ivcheck  :=0;
   int1     :=pos__toline(icursorpos);

   if xsafeline(int1) then
      begin

      bol1  :=true;
      bol2  :=true;

      //.check 1 -> scroll up to cursor
      int3  :=xpaintline1;
      bol2  :=xsafeline(int3);
      
      if bol1 and bol2 and (iliney[int1]<(iliney[int3]+ivposPART)) then
         begin

         bol1         :=false;
         ivpos        :=int1;
         if (ilineh[int1]>iviewheight) then ivposPART:=ilineh[int1]-iviewheight else ivposPART:=0;
         ivhostsync   :=true;

         end;

      //.check 2 -> scroll down to cursor
      int3  :=xpaintline2;
      xsafeline(int3);

      if bol1 and ((iliney[int1])>iliney[int3]) then
         begin

         //init
         bol1         :=false;
         //get
//            if (int3>0) then for p:=int3 downto 0 do if ((x.liney[int3]+x.lineh[int3]+x.vposPART-x.liney[p])<=x.viewheight) then int1:=p else break;
         //set
         ivpos        :=int1;
         ivposPART    :=ilineh[int1]-iviewheight;//not perfect - but it is working OK - 21jun2022
         ivhostsync   :=true;

         end;

      //.check 3 -> fallback check (when 1 above fails) -> scroll to x.cursorpos
      if bol1 and (not bol2) then
         begin

         ivpos        :=int1;
         ivposPART    :=0;
         ivhostsync   :=true;

        end;

      end;

   end;

//linecursorx update --------------------------------------------------------
if xchklinecursorx then xlinecursorx(icursorpos);

//flash cursor
if (slowms64>=itimerslow) then
   begin

   iflashcursor       :=not iflashcursor;

   //reset
   itimerslow         :=add64(slowms64,500);

   end;

//.draw cursor -> detect change and trigger paint -> 29aug2019
bol1:=ishowcursor and ihavefocus and (iflashcursor or (ik_idleref>=slowms64));

if (bol1<>idrawcursor) then
   begin

   idrawcursor        :=bol1;
   if icursoronscrn then xmustpaint:=true;
   end;


//.dic support - 11feb2023, 04feb2023 ------------------------------------------

{$ifdef gui}
if idic and ((idicref1<>idataid3) or (idicref2<>icursorpos) or (idicid<>dic__id)) then
   begin

   bol2               :=(idicid<>dic__id);
   idicref1           :=idataid3;
   idicref2           :=icursorpos;
   idicid             :=dic__id;//detect changes in dic and resample
   bol1               :=dic__misspelt(dic_extractwordfromdoc(icursorpos,false,idicfrom,idicto));

   if bol1 then bol1:=dic__misspelt(dic_extractwordfromdoc(icursorpos,true,idicfrom,idicto));

   if low__setbol(idicshow,bol1) or bol2 then xmustpaint:=true;

   end;
{$endif}


//mustpaint
if xmustpaint then imustpaint:=true;

except;end;

//unlock
itimerbusy:=false;

end;

procedure ttextcore.vkeypress(const xchar:longint;const xctrl,xalt,xkeyx:boolean);
var
   xcan:boolean;
begin

//range check - ansi char range only - 15feb2026
if (xchar<0) or (xchar>255) then exit;

//init
xcan        :=not ireadonly;


//special key ------------------------------------------------------------------
if xkeyx then
   begin

   case xchar of
   vkreturn           :if xcan then xinstext(#10);
   vktab              :if xcan then xinstext(#9);
   vkdelete           :if xcan then xdelr;
   vkback             :if xcan then xdell;
   vkleft:begin

      if not ishowcursor then vpos:=vpos-1//25jul2021
      else if xctrl      then xmove(mcScootLeft)
      else if xalt       then xmove(mcLineStart)
      else                    xmove(mcLeft);

      end;
   vkright:begin

      if not ishowcursor then vpos:=ivpos+1//25jul2021
      else if xctrl      then xmove(mcScootRight)
      else if xalt       then xmove(mcLineEnd)
      else                    xmove(mcRight);

      end;
   vkup:begin

      if not ishowcursor then vpos:=ivpos-1//25jul2021
      else                    xmove(mcUp);

      end;
   vkdown:begin

      if not ishowcursor then vpos:=ivpos+1//25jul2021
      else                    xmove(mcDown);

      end;

   vkprior            :xmove(mcPageup);
   vknext             :xmove(mcPagedown);
   vkhome             :xmove(mcHome);
   vkend              :xmove(mcEnd);

   {$ifdef gui}
   vkF4               :if ishortcuts then sysfind_cmd:='find.pop';
   vkF3               :if ishortcuts then sysfind_cmd:=low__aorbstr('find','find.pop',(sysfind_text=''));
   {$endif}
   
   vkF7               :if ishortcuts and idic then dic_spell;
   end;//case

   end

//standard character -----------------------------------------------------------
else if xcan then xinstext( char(xchar) );

end;//if

function ttextcore.xpaintline1:longint;
begin

case (ivpos>=0) and (ivpos<ilinecount) and (ivpos<ilinesize) of
true:result:=ivpos;
else result:=0;
end;//case

end;

function ttextcore.xpaintline2:longint;
var
   p,int1:longint;
begin

//defaults
result      :=0;
int1        :=ivpos;

if (int1>=0) and (int1<ilinecount) and (int1<ilinesize) then
   begin

   for p:=int1 to frcmax32(ilinecount-1,ilinesize-1) do
   begin

   if ((iliney[p]+ilineh[p]-iliney[int1]-ivposPART)<=iviewheight) then result:=p else break;

   end;//p

   end;

end;

procedure ttextcore.xdelr;
var
   int1,xselstart,xselcount:longint;
begin

//check
if ireadonly then exit;

//init
xnoidle;
knoidle;
xselstart   :=selstart;
xselcount   :=selcount;

if (xselcount>=2) then xbackup('delr');

//flush redo list - 02may2023
mredoflush;

//check
if (iundoinfo.style<>musDelR) or (xselstart<>iundoinfo.from1) then mstore1;

//get
if (xselcount>=1) then
   begin

   iundoinfo.style:=musSel;
   mstore1;

   end
else
   begin

   int1     :=xselstart;//02jul2022

   if iundoinfo.enabled and mdok and (int1>=1) and (int1<xlen32) then
      begin

      if (iundoinfo.style<>musDelR) then
         begin

         iundoinfo.style  :=musDelR;
         iundoinfo.from1  :=int1;
         iundoinfo.len    :=0;//not used

         end;

      iundoinfo.d1.aadd([idata .pbytes[int1-1]]);
      iundoinfo.d2.aadd([idata2.pbytes[int1-1]]);
      iundoinfo.d3.aadd([idata3.pbytes[int1-1]]);

      end;

   bdel1(idata ,int1,1);
   bdel1(idata2,int1,1);
   bdel1(idata3,int1,1);

   xmincheck;

   xsetcursorpos(int1);//x.cursorpos);

   xwrapadd(xlinebefore(int1),int1+ic_pagewrap);//04jun2020

   icursor_keyboard_moveto   :=int1;//new
   itimer_chklinecursorx     :=true;

   xchanged;
   xincdata3;

   end;

end;

procedure ttextcore.xdell;
var
   int1,xselstart,xselcount:longint;
begin

//check
if ireadonly then exit;

//init
xnoidle;
knoidle;
xselstart   :=selstart;
xselcount   :=selcount;

if (xselcount>=2) then xbackup('dell');

//flush redo list - 02may2023
mredoflush;

//check
if (iundoinfo.style<>musDelL) or (xselstart<>iundoinfo.from1) then mstore1;

//get
if (xselcount>=1) then
   begin

   iundoinfo.style    :=musSel;
   mstore1;

   end
else if (icursorpos>=2) then
   begin

   int1               :=xselstart-1;//x.cursorpos-1;

   if iundoinfo.enabled and mdok and (int1>=1) and (int1<xlen32) then
      begin

      if (iundoinfo.style<>musDelL) then
         begin

         iundoinfo.style  :=musDelL;
         iundoinfo.from1  :=int1;//xselstart;
         iundoinfo.len    :=0;//not used

         end;

      iundoinfo.d1.ains([idata .pbytes[int1-1]],0);
      iundoinfo.d2.ains([idata2.pbytes[int1-1]],0);
      iundoinfo.d3.ains([idata3.pbytes[int1-1]],0);

      end;

   bdel1(idata ,int1,1);
   bdel1(idata2,int1,1);
   bdel1(idata3,int1,1);

   xmincheck;

   xsetcursorpos(int1);

   xwrapadd(xlinebefore(int1),int1+ic_pagewrap);//04jun2020

   icursor_keyboard_moveto   :=int1;
   itimer_chklinecursorx     :=true;

   xchanged;
   xincdata3;

   iundoinfo.from1           :=xselstart;

   end;

end;

procedure ttextcore.xmove(const xmoveCode:longint);
var
   p,dx,int1,int2,int3,xline:longint;
   bol1:boolean;
   fc:tfastchar;
begin

case xmoveCode of
mcLeft:begin

   icursor_keyboard_moveto   :=frcrange32(icursorpos-1,1,xlen32);
   itimer_chklinecursorx     :=true;

   end;

mcLineStart:begin

   int1                      :=pos__toline(icursorpos);
   int1                      :=line__topos(int1);

   //.already at start of line -> so go to end of previous line
   if (int1=icursorpos) then int1:=int1-1;

   icursor_keyboard_moveto   :=frcrange32(int1,1,xlen32);
   itimer_chklinecursorx     :=true;

   end;

mcScootLeft:begin

   if xslowchar(icursorpos-1,1,fc) and (fc.cs=wc_t) and ((fc.c=ss10) or ((icursorpos-1)<=0)) then
      begin

      icursor_keyboard_moveto:=frcrange32(icursorpos-1,1,xlen32);
      itimer_chklinecursorx  :=true;

      end

   else if (icursorpos>=3) then
      begin

      for int1:=(icursorpos-2) downto 1 do
      begin

      if not xslowchar(int1,1,fc) then break

      else if (fc.cs=wc_i) or ((fc.cs=wc_t) and xscootable(fc.c)) then
         begin

         icursor_keyboard_moveto    :=frcrange32(int1+1,1,xlen32);
         itimer_chklinecursorx      :=true;
         break;

         end

      else if (int1<=1) then//18jun2022
         begin

         icursor_keyboard_moveto     :=frcrange32(int1,1,xlen32);
         itimer_chklinecursorx       :=true;
         break;

         end;

      end;//int1

      end;

   end;//begin

mcRight:begin

   icursor_keyboard_moveto   :=frcrange32(icursorpos+1,1,xlen32);
   itimer_chklinecursorx     :=true;

   end;

mcLineEnd:begin

   int1                      :=pos__toline(icursorpos);
   int1                      :=frcmin32(line__topos(int1+1),0);

   if (int1<xlen32) then dec(int1,1);

   //.already at end of line -> so go to start of next line
   if (int1=icursorpos) then int1:=int1+1;

   icursor_keyboard_moveto   :=frcrange32(int1,1,xlen32);
   itimer_chklinecursorx     :=true;

   end;

mcScootRight:begin

   if xslowchar(icursorpos,1,fc) and (fc.cs=wc_t) and (fc.c=ss10) then
      begin

      icursor_keyboard_moveto   :=frcrange32(icursorpos+1,1,xlen32);
      itimer_chklinecursorx     :=true;

      end

   else if (icursorpos<=(xlen32-2)) then
      begin

      for int1:=(icursorpos+1) to xlen32 do
      begin

      if not xslowchar(int1,1,fc) then break

      else if (fc.cs=wc_i) or ((fc.cs=wc_t) and xscootable(fc.c)) then
         begin

         icursor_keyboard_moveto:=frcrange32(int1,1,xlen32);
         itimer_chklinecursorx  :=true;
         break;

         end;

      end;//int1

      end;

   end;//begin

mcUp:begin

   xline                        :=pos__toline(icursorpos)-1;

   if (xline<0) then
      begin

      icursor_keyboard_moveto   :=1;
      itimer_chklinecursorx     :=true;

      end

   else if xsafeline(xline) then
      begin

      int1                      :=ilinep[xline];
      int2                      :=int1;
      int3                      :=line__topos(xline+1)-1;

      if (int3>=int2) then
         begin

         dx                     :=ilinex[xline];

         for p:=int2 to int3 do
         begin

         if not xslowchar(p,1,fc) then break;

         if (dx<=ilinecursorx)    then int1:=p;

         inc(dx,fc.width);

         end;//p

         end;//if

      icursor_keyboard_moveto   :=frcrange32(int1,1,xlen32);

      end;

   end;//begin

mcDown:begin

   xline                        :=pos__toline(icursorpos)+1;

   if xsafeline(xline) then
      begin

      int1                      :=ilinep[xline];
      int2                      :=int1;
      int3                      :=line__topos(xline+1)-1;

      if (int3>=int2) then
         begin

         dx                     :=ilinex[xline];

         for p:=int2 to int3 do
         begin

         if not xslowchar(p,1,fc) then break;

         if (dx<=ilinecursorx)    then int1:=p;

         inc(dx,fc.width);

         end;//p

         end;//if

      icursor_keyboard_moveto   :=frcrange32(int1,1,xlen32);

      end;

   end;//begin


mcPageUp:begin

   //scan up X lines
   xline                        :=pos__toline(icursorpos);
   int3                         :=xline;

   if xsafeline(xline) then
      begin

      bol1                      :=false;
      int1                      :=xline;
      int2                      :=xline;

      while true do
      begin

      dec(int2);

      if not xsafeline(int2) then break;

      if ((iliney[int1]-iliney[int2])>iviewheight) and bol1 then break;

      xline                     :=int2;
      bol1                      :=true;

      end;//while

      end;

   //get
   if (xline<0) then
      begin

      icursor_keyboard_moveto   :=1;
      itimer_chklinecursorx     :=true;

      end

   else if xsafeline(xline) then
      begin

      int1                      :=ilinep[xline];
      int2                      :=int1;
      int3                      :=line__topos(xline+1)-1;

      if (int3>=int2) then
         begin

         dx                     :=ilinex[xline];

         for p:=int2 to int3 do
         begin

         if not xslowchar(p,1,fc) then break;

         if (dx<=ilinecursorx)    then int1:=p;

         inc(dx,fc.width);

         end;//p

         end;//if

      icursor_keyboard_moveto   :=frcrange32(int1,1,xlen32);

      end;

   end;//begin

mcPageDown:begin

   //scan up X lines
   xline                       :=pos__toline(icursorpos);
   int3                        :=xline;

   if xsafeline(xline) then
      begin

      bol1                     :=false;
      int1                     :=xline;
      int2                     :=xline;

      while true do
      begin

      inc(int2);

      if not xsafeline(int2) then break;

      if ((iliney[int2]-iliney[int1])>iviewheight) and bol1 then break;//force atleast ONE line increment -> covers images that span MANY lines/pages in one go - 21jun2022

      xline                     :=int2;
      bol1                      :=true;

      end;//while

      end;

   //get
   if xsafeline(xline) then
      begin

      int1                      :=ilinep[xline];
      int2                      :=int1;
      int3                      :=line__topos(xline+1)-1;

      if (int3>=int2) then
         begin

         dx                     :=ilinex[xline];

         for p:=int2 to int3 do
         begin

         if not xslowchar(p,1,fc) then break;

         if (dx<=ilinecursorx)    then int1:=p;

         inc(dx,fc.width);

         end;//p

         end;//if

      icursor_keyboard_moveto   :=frcrange32(int1,1,xlen32);

      end;

   end;//begin

mcHome:icursor_keyboard_moveto  :=1;
mcEnd:icursor_keyboard_moveto   :=xlen32;
end;//case

end;

procedure ttextcore.transform(const xwebimages,xretainKeyTagsForClaude:boolean;const xhelpTopicList:tdynamicstring);
begin

transform2(xwebimages,xretainKeyTagsForClaude,'','','',xhelpTopicList);

end;

procedure ttextcore.transform2(const xwebimages,xretainKeyTagsForClaude:boolean;const xappTitle,xappVersion,xappWebLink:string;const xhelpTopicList:tdynamicstring);
label
   redo,skipone,skipend;

var
   ff:tfastfont;
   fc:tfastchar;
   ximgname:array[0..999] of string;
   ximgid  :array[0..999] of word;
   n:string;
   int1,nlen,dlen,xskipstart,xstart,xpos,xlen,i,p:longint;
   bol1:boolean;

   function xnospaces(const x:string):string;//25mar2026
   var
      xlen,dlen,p:longint;
      v:byte;
   begin

   //defaults
   result   :=x;
   xlen     :=low__len32(result);
   dlen     :=0;

   //get
   for p:=1 to xlen do
   begin

   v        :=byte( result[ p - 1 + stroffset ] );

   case byte( result[ p - 1 + stroffset ] ) of
   9 ,32 ,160:;//remove char
   else begin

      inc(dlen);

      if (dlen<>p) then result[dlen-1+stroffset]:=result[p-1+stroffset];

      end;
   end;//case

   end;//p

   //finalise
   if (dlen<>xlen) then result:=strcopy1(result,1,dlen);

   end;

   function xcharok(const xpos:longint):boolean;
   begin

   result:=xfastchar(ff,xpos,1,fc) and (fc.cs=wc_t);

   end;

   procedure ddelskipped;
   var
      nlen:longint;
   begin

   //remove previous
   if (xstart>=1) and (xskipstart>=1) then
      begin

      nlen            :=xstart-xskipstart;

      if (nlen>=1) then
         begin

         //delete
         idata .del3(xskipstart-1,nlen);
         idata2.del3(xskipstart-1,nlen);
         idata3.del3(xskipstart-1,nlen);

         //get
         xlen         :=idata.len32;//32

         //inc
         dec(xstart,nlen);

         end;

      end;

   //reset
   xskipstart         :=0;

   end;

   function dtxt(const xnewval:string):boolean;
   var
      v1,v2:byte;
      a:tstr8;
      p:longint;
   begin

   //defaults
   result   :=false;
   a        :=nil;

   //init
   dlen     :=low__len32(xnewval);//32
   v1       :=idata2.bytes[xstart-1];
   v2       :=idata3.bytes[xstart-1];

   //remove previous
   idata .del3(xstart-1,nlen);
   idata2.del3(xstart-1,nlen);
   idata3.del3(xstart-1,nlen);

   //add new content
   if (dlen>=1) then
      begin

      //init
      a     :=rescache__newStr8;
      a.setlen(dlen);

      //.str
      idata.sins(xnewval,xstart-1);

      //.id-0
      for p:=1 to dlen do a.pbytes[p-1]:=v1;
      idata2.ins(a,xstart-1);

      //.id-1
      for p:=1 to dlen do a.pbytes[p-1]:=v2;
      idata3.ins(a,xstart-1);

      end;

   //successful
   result   :=true;

   //free
   if (a<>nil) then rescache__delStr8(@a);

   end;

   function dtep2(const xtep:longint;dext:string):boolean;
   label
      skipend;
   var
      b:tstr8;
      v:twrd2;
      xid,p:longint;
      xadded:boolean;
   begin

   //init
   result   :=false;
   dlen     :=0;
   xid      :=-1;//off
   b        :=nil;
   xadded   :=false;
   dext     :=strlow(dext);

   {$ifdef jpeg}
   {$else}
   if ((dext='jif') or (dext='jpg')) then dext:='png';//jpeg is disabled -> switch to png - 15may2021
   {$endif}

   //unsupported target format -> fallback to png - 25mar2026
   if (dext<>'tea') and (dext<>'jif') and (dext<>'jpg') and (dext<>'png') and (dext<>'bmp') then dext:='png';

   //force JPEG or PNG only - 25jul2021
   if xwebimages then
      begin

      {$ifdef jpeg}
      {$else}
      if ((dext='jif') or (dext='jpg')) then dext:='png';
      {$endif}

      //fallback
      if (dext<>'jif') and (dext<>'jpg') and (dext<>'png')  then dext:='png';

      end;

   //remove previous
   idata .del3(xstart-1,nlen);
   idata2.del3(xstart-1,nlen);
   idata3.del3(xstart-1,nlen);

   //find existing
   for p:=0 to high(ximgname) do if (n=ximgname[p]) then
      begin

      xid   :=ximgid[p];
      break;

      end;

   //new
   if (xid<0) then
      begin

      //init
      b     :=rescache__newStr8;

      //get -> default dynamic RLE6/RLE8 images to greyscale (black) and optional colors (RLE6 as shades of white)
      if not tep__todata2(xtep,clBlack,clBlack,clWhite,clBlack,@b,dext) then goto skipend;

      //set
      icursorpos      :=xstart;
      icursorpos2     :=xstart;

      xinsimg2(b,xtep,true,true);

      xadded          :=true;

      if (xstart<=idata.len) then
         begin

         v.bytes[0]   :=idata2.bytes[xstart-1];
         v.bytes[1]   :=idata3.bytes[xstart-1];
         xid          :=v.val;

         end;

      //add
      if (xid>=0) then
         begin

         for p:=0 to high(ximgname) do if (ximgname[p]='') then
            begin

            ximgname[p]      :=n;
            ximgid[p]        :=xid;

            break;

            end;//p

         end;

      end;

   //add new content
   if (xid>=0) and (not xadded) then
      begin

      //init
      v.val :=xid;

      //get
      idata .ains([0],xstart-1);//0 is style of wc_i or "image"
      idata2.ains(v.bytes[0],xstart-1);
      idata3.ains(v.bytes[1],xstart-1);

      //dlen
      dlen  :=1;

      end;

   //successful
   result   :=true;
   skipend:

   //free
   if (b<>nil) then rescache__delStr8(@b);

   end;

   function dtep(const xtep:longint):boolean;
   begin

   result   :=dtep2(xtep,'');

   end;

   function xkeeptag(const xtagname:string):boolean;//pass-thru
   begin

   result   :=true;

   dtxt('['+xtagname+']');//32

   inc(xstart,2+low__len32(xtagname));//skip over tag - 07jan2022

   end;

   procedure dval(const xval,xfallbackNameForValue:string);
   begin

   case xretainKeyTagsForClaude of
   true:xkeeptag(n);
   else dtxt(strdefb( xval ,app__info(xfallbackNameForValue) ));
   end;//case

   end;

begin

//defaults
bol1                  :=false;
xskipstart            :=0;//off
xlen                  :=idata.len32;//32
xpos                  :=1;
xstart                :=0;//off

//check
if (xlen<=0) then goto skipend;

//init
xfastcharinit( ff );

for p:=0 to high(ximgname) do
begin

ximgname[p] :='';
ximgid[p]   :=0;

end;//p

//get
redo:

if xcharok(xpos) then
   begin

   if      (fc.c=ssLSquarebracket) then xstart:=xpos
   else if (fc.c=ssRSquarebracket) and (xstart>=1) then
      begin

      //init
      dlen            :=0;
      nlen            :=xpos-xstart+1;//includes brackets
      n               :=strlow( idata.str1[xstart+1,xpos-xstart-1] );//exclude brackets

      //get
      if (n='t') then//mark as a help topic
         begin

         //delete to just before this tag
         if (xskipstart>=1) then ddelskipped;

         //special - retain topic codes "[t]" for higher up processing by Claude - 13nov2022
         if (n='t') and xretainKeyTagsForClaude then
            begin

            xstart    :=xpos+3;
            goto skipone;

            end;

         //init
         dtxt('');
         xlen         :=idata.len32;

         //next line
         int1         :=xstart;

         for i:=xstart to xlen do
         begin

         int1         :=i;
         if xcharok(i) and (fc.c=ss10) then break;

         end;//p

         //change
         if (xskipstart<=0) then
            begin

            icursorpos       :=xstart;
            icursorpos2      :=int1;

            if (xhelpTopicList<>nil) then
               begin

               xhelpTopicList.value[xhelpTopicList.count]:=intstr32(xstart)+'|'+idata.str1[xstart,int1-xstart];//start of topic + topic text - 03apr2021

               end;
               
            //use "bold" for headers
            cbold            :=true;
            cwritesel( smBold );

            end;

         end
      else if (xskipstart>=1) then goto skipone
      else if (n='programname')                        then dval( xapptitle       ,'name' )
      else if (n='programversion') or (n='version')    then dval( xappversion     ,'ver' )
      else if (n='programurl') or (n='nprogram')       then dval( ''              ,'url.software' )
      else if (n='programzip') or (n='nprogramzip')    then dval( ''              ,'url.software.zip' )
      else if (n='vprogramurl') or (n='vprogram')      then dval( ''              ,'url.software' )
      else if (n='vprogramzip')                        then dval( ''              ,'url.software.zip' )
      else if (n='softwareurl')                        then dtxt(app__info('url.software'))
      else if (n='instagramurl')                       then dtxt(app__info('url.instagram'))
      else if (n='facebookurl')                        then dtxt(app__info('url.facebook'))
      else if (n='mastodonurl')                        then dtxt(app__info('url.mastodon'))
      else if (n='twitterurl')                         then dtxt(app__info('url.twitter'))
      else if (n='beurl')                              then dtxt(app__info('url.portal'))
      else if (n='bename')                             then dtxt(app__info('author.name'))//19jul2024
      else if (n='l') or (n='c') or (n='r')    then//align: left, center or right
         begin

         if (xskipstart>=1) then dtxt('')
         else
            begin

            dtxt('');

            icursorpos       :=xstart;
            icursorpos2      :=xstart+dlen;

            if      (n='l') then calign:=wcaLeft
            else if (n='c') then calign:=wcaCenter
            else if (n='r') then calign:=wcaRight;

            cwritealign;

            end;

         end

      //.images
      else if (n='*')         then
         begin

         dtep(tepBullet);//07jan2022

         end

      else if (strcopy1(n,1,4)='tep:') then
         begin

         if (xskipstart>=1) then dtxt('')
         else
            begin

            if      xretainKeyTagsForClaude                           then xkeeptag(n)
            else if tep__findbyname(strcopy1(n,5,low__len32(n)),int1) then dtep(int1)
            else
               begin

               dtxt('');

               if system_debug then
                  begin

                  showerror('Text image not found "'+n+'".');
                  goto skipend;

                  end;

               end;

            end;

         end

      //.error - not found
      else
         begin

         //write "nil" value for unknown tags - 25mar2026
         dtxt('');

         //show error
         if system_debug then
            begin

            showerror('Unknown transform tag "'+n+'".');
            goto skipend;

            end;

         end;

skipone:

      //sync
      xpos            :=frcmin32(xstart-1,0);
      xstart          :=0;//off
      xlen            :=idata.len32;

      end;

   end;

//loop
inc(xpos);
if (xpos>=1) and (xpos<=xlen) then goto redo;

//.finalise
ddelskipped;

skipend:

//finalise
icursorpos  :=1;
icursorpos2 :=1;
xmincheck;
contentChangedAll;//26mar2026

end;

function ttextcore.supportsFormat(const xformat:string):boolean;
begin
result:=textcore__docExtSupported(xformat);
end;

function ttextcore.docExtSupported(const xext:string):boolean;
var
   bol1:boolean;
   int1:longint;
begin
result:=textcore__docExtSupported2(xext,bol1,int1);
end;

function ttextcore.docExtSupported2(const xext:string;var xcanwrite:boolean;var xmaxformatlevel:longint):boolean;
begin
result:=textcore__docExtSupported2(xext,xcanwrite,xmaxformatlevel);
end;

function ttextcore.docExt(const xindex:longint;var xext:string;var xcanwrite:boolean):boolean;//16feb2026
begin
result:=textcore__docExt(xindex,xext,xcanwrite);
end;

function ttextcore.docExt2(const xindex:longint;var xext:string;var xcanwrite:boolean;var xmaxformatlevel:longint):boolean;//16feb2026
begin
result:=textcore__docExt2(xindex,xext,xcanwrite,xmaxformatlevel);
end;

function ttextcore.docExtb(const xindex:longint):string;//16feb2026
begin
result:=textcore__docExtb(xindex);
end;

end.
