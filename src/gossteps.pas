unit gossteps;

interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef WIN64}{$define 64bit}{$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gosswin;
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
//## Library.................. Text Pictures - System, Folder and App images (gossteps.pas)
//## Version.................. 4.00.412 (+25)
//## Items.................... 9
//## Last Updated ............ 15apr2026, 10apr2026, 03apr2026, 01apr2026, 26mar2026, 25mar2026, 23mar2026, 21mar2026, 20mar2026, 18mar2026, 10mar2026, 07mar2026
//## Lines of Code............ 3,600+
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
//## | teplist__*             | family of procs   | 1.00.030  | 23mar2026   | Management procs for ttepinfo structure(s) - 21mar2026, 10mar2026
//## | tep__*                 | family of procs   | 1.00.357  | 15apr2026   | TEP information/draw procs - 03apr2026, 26mar2026, 25mar2026, 23mar2026, 20mar2026, 10mar2026
//## ==========================================================================================================================================================================================================================
//## Image Format Note:
//##
//## The images used below ( color images = tep_*, and monochromatic images = mtep_* ) generally require a specific height (e.g. 20px) with
//## transparency in PNG, TEA, ICO, GIF etc graphic format and stored directly in the source code as binary pascal arrays.  A free gui tool
//## is available at http://www.blaizenterprises.com/pixelsnatcher.html  The tool supports copying and pasting images as pascal arrays in
//## PNG, TEA, ICO and GIF formats, and image adjustment, screen capture, loading, saving, resizing, monochromatic creation,
//## automatic padding, feathering etc
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


const

   //image types ---------------------------------------------------------------

   it_none            =0;
   it_rle6            =1;//supports realtime feather
   it_rle8            =2;//supports realtime feather
   it_rle32           =3;///supports realtime feather
   it_img32           =4;//no feather support
   it_max             =4;


   //list types ----------------------------------------------------------------

   lt_system          =0;
   lt_folder          =1;
   lt_app             =2;


   //list start ranges ---------------------------------------------------------

   ls_system          =0;
   ls_folder          =999;
   ls_app             =1999;
   ls_max             =2100;


   //default format handlers ---------------------------------------------------

   df_mono            =it_rle8;
   df_color           =it_rle32;


   //system teps ---------------------------------------------------------------

   //.static height teps - 20px
   tepNone                 =0;
   tepUnknown20            =1;
   tepNew20                =2;
   tepHome20               =3;
   tepYesBLANK20           =4;
   tepYes20                =5;
   tepOK20                 =6;
   tepOpen20               =7;
   tepSave20               =8;
   tepDisk20               =9;
   tepCut20                =10;
   tepCopy20               =11;
   tepPaste20              =12;
   tepDelete20             =13;
   tepClose20              =14;
   tepEdit20               =15;
   tepUndo20               =16;
   tepRedo20               =17;
   tepOptions20            =18;//14aug2020
   tepNav20                =19;//06oct2020
   tepInvert20             =20;
   tepUpper20              =21;
   tepLower20              =22;
   tepName20               =23;//name case
   tepLess20               =24;
   tepMore20               =25;
   tepBW20                 =26;
   //27..29
   tepHelp20               =30;
   tepUM20                 =31;
   tepMax20                =32;
   tepSettings20           =33;
   tepAbout20              =34;
   tepBE20                 =35;
   tepRefresh20            =36;
   tepFolder20             =37;
   tepColor20              =38;
   tepFont20               =39;
   tepDesktop20            =40;
   tepPrograms20           =41;
   tepMenu20               =42;
   tepPlay20               =43;
   tepColors20             =44;
   tepColormatrix20        =45;
   tepColorPal20           =46;//wide 20h x 40w - single color RLE6
   tepPrev20               =47;
   tepNext20               =48;
   tepUpone20              =49;
   tepFav20                =50;
   tepNewfolder20          =51;
   tepAdd20                =52;
   tepStop20               =53;
   tepVol20                =54;
   tepRewind20             =55;
   tepFastforward20        =56;
   tepSelectAll20          =57;
   tepFavEdit20            =58;
   tepFavAdd20             =59;
   tepColorHistory20       =60;
   tepTick20               =61;
   tepUntick20             =62;
   tepEye20                =63;
   tepHelpdoc20            =64;
   tepVisual20             =65;//03jul2025
   tepUp20                 =66;
   tepCD20                 =67;
   tepRemovable20          =68;
   tepFolderimage20        =69;
   tepStartmenu20          =70;
   tepSchemes20            =71;
   tepSub20                =72;
   tepZoom20               =73;
   tepSizeto20             =74;
   tepTicktwo20            =75;
   tepUnticktwo20          =76;
   tepTickthree20          =77;
   tepUntickthree20        =78;
   tepRec20                =79;
   tepScreen20             =80;
   tepOntop20              =81;
   tepHide20               =82;
   tepWrap20               =83;
   tepWine20               =84;
   tepFrame20              =85;
   tepLeft20               =86;
   tepRight20              =87;
   tepTop20                =88;
   tepBottom20             =89;
   tepBlank20              =90;
   tepClock20              =91;
   tepAlert20              =92;
   tepBell20               =93;
   tepSonnerie20           =94;
   tepNotes20              =95;
   tepFNew20               =96;//uses font color - 23mar2022
   tepBack20               =97;
   tepForw20               =98;
   tepPower20              =99;//14jun2022
   tepAddL20               =100;//14jun2022
   tepSubL20               =101;//14jun2022
   tepPanel20              =102;//05jul2022
   tepClosed20             =103;//black - uses system font color - 21nov2023
   tepUpward20             =104;//black
   tepDownward20           =105;//black
   tepInstagram20          =106;
   tepFacebook20           =107;
   tepMastodon20           =108;
   tepTwitter20            =109;
   tepSourceForge20        =110;//02dec2023
   tepGitHub20             =111;
   tepGo20                 =112;//20jul2024
   tepCapture20            =113;//02aug2024
   tepMute20               =114;//11jan2025
   tepUnmute20             =115;//11jan2025
   tepBulletSquare20       =116;//15mar2025         

   tepRotate20             =117;
   tepRotateLeft20         =118;
   tepMirror20             =119;
   tepFlip20               =120;
   tepSaveAs20             =121;
   tepPrint20              =122;
   tepBackground20         =123;
   tepSquircle20           =124;
   tepCircle20             =125;
   tepSquare20             =126;
   tepSolid20              =127;
   tepTransparent20        =128;
   tepAsis20               =129;
   tepDiamond20            =130;//04jun2025
   tepOutline20            =131;
   tepChecker20            =132;
   tepList20               =133;//05jun2025
   tepInfo20               =134;//03jul2025
   tepColorPalDUAL20       =135;//wide 20h x 40w - two color RLE6
   tepSwap20               =136;//14jul2025
   tepDither20             =137;//19jul2025
   tepRect20               =138;
   tepLine20               =139;
   tepPen20                =140;
   tepDrag20               =141;
   tepPot20                =142;
   tepGPot20               =143;
   tepCls20                =144;
   tepMove20               =145;
   tepEyedropper20         =146;
   tepWraphorz20           =147;
   tepNotepad20            =148;//18sep2025
   tepPaint20              =149;//18sep2025
   tepPause20              =150;//29sep2025
   tepImage20              =151;//09nov2025
   tepCode20               =152;//09nov2025
   tepUnit20               =153;
   tepCompress20           =154;
   tepTest20               =155;//19mar2026
   tepcolorpalSMALL20      =156;//19mar2026

   tepTemp20_noscaling     =157;//used for dynamic tep previewing, e.g. for tbasictea -> use TEP system for auto-scaling, color, data management etc - 21mar2026
   tepTemp20               =158;//uses scaling
   
   //.file format teps
   tepXXX20                =170;
   tepBMP20                =171;
   tepWMA20                =172;
   tepTXT20                =173;
   tepEXE20                =174;
   tepBWD20                =175;
   tepBWP20                =176;
   tepMID20                =177;//20feb2021
   tepBCS20                =178;//10mar2021
   tepR20                  =179;//30dec2021
   tepXML20                =180;//30dec2021
   tepHTM20                =181;//30dec2021
   tepC2P20                =182;//12jan2022
   tepC2V20                =183;//24jan2022
   tepZIP20                =184;
   tep7Z20                 =185;
   tepINI20                =186;
   tepCUR20                =187;//23may2022, 17may2022
   tepRTF20                =188;//22jun2022
   tepSFEF20               =189;//05oct2022
   tepQuoter20             =190;//26dec2022
   tepPAS20                =191;//23jul2024
   tepC320                 =192;//claude 3 code - 20aug2024
   tepREF320               =193;
   tepDPR20                =194;//20mar2025
   tepnupkg20              =195;//31mar2025
   tepDIC20                =196;//17feb2026

   //.duplicates
   tepRun20                =tepEXE20;

   //.variable height teps
   tepmin                  =200;
   tepmax                  =201;
   tepnor                  =202;
   tepclo                  =203;
   tepNormal               =204;
   tepMaximise             =205;
   tepinf                  =206;
   tepUp                   =210;
   tepDown                 =211;
   tepLeft                 =212;
   tepRight                =213;
   tepOn                   =220;
   tepOff                  =221;
   tepHelpHint             =222;
   tepBullet               =223;
   //tepSep                  =224;
   tepHelpBanner           =225;//medium sized banner
   tepFull                 =226;//full screen mode - 28dec2024
   tepFullExit             =227;//exit full screen

   //.large 24x24 teps
   tepIcon24               =500;//actual program icon -> program specific - 11oct2020
   tepIcon24B              =501;//optional cell 2 - 30apr2022
   tepIcon24C              =502;//optional cell 3
   tepIcon24D              =504;//optional cell 4
   tepInfo24               =505;
   tepQuery24              =506;
   tepError24              =507;
   tepColor24              =508;
   tepFolderimage24        =509;
   tepNewfolder24          =510;
   tepIcon20               =511;//actual program icon at 20h - 26sep2022

   systepHeight20          =20;//standard tep height - 19mar2021
   tep_folderImageWH       =20;//folder images are a max of 20x20 - 21mar2026

   teaMaxsize20x20         =2027;//400 colors at 20w x 20h = 2,027 (32bit) 12apr2025, was: 1,612 bytes - 06apr2021

   tepCustomBASE20         =ls_app;//18mar2026

type

   ttepinfo=record

    d:pointer;//data pointer
    l:longint;//data len
    t:longint;//type
    h:longint;//height
    w:longint;//width
    r:longint;//reply

    end;

   psetproc           =^tsetproc;
   tsetproc           =procedure (const xindex:longint);

   pteplist=^tteplist;
   tteplist=record

    n                :array[0..ls_max] of string;//name (use to find image by name)
    f                :array[0..ls_max] of string;//filename (optional)
    ftime            :array[0..ls_max] of comp;//last time used
    w                :array[0..ls_max] of longint;//actual width of image
    h                :array[0..ls_max] of longint;//actual height of image
    rw               :array[0..ls_max] of longint;//root width of image - unscaled version
    rh               :array[0..ls_max] of longint;//root height of image - unscaled version

    it               :array[0..ls_max] of byte;//image type
    lt               :array[0..ls_max] of byte;//list type

    lmono            :array[0..ls_max] of boolean;
    lscale           :array[0..ls_max] of double;//real based scale
    iscale           :array[0..ls_max] of byte;  //integer based scale

    fdata            :array[0..ls_max] of tobject;//optional tstr8/tstr9 -> used in the ls_folder..(lsapp-1) range for folder based images - 18mar2026
    pdata            :array[0..ls_max] of tobject;//optional tstr8/tstr9 -> used for persistent image retention -> overrides all other modes, e.g. internal data structure etc - 21mar2026

    img              :array[0..ls_max] of tobject;//image handler, e.g. tbasicrle6, tbasicrle8 etc

    end;


var
   //.started
   system_started_teps          :boolean  =false;

   tep_scale                    :double   =1.0;
   tep_mono                     :boolean  =true;
   tep_height20                 :longint  =20;
   tep_height24                 :longint  =24;
   tep_core                     :tteplist;



//start-stop procs -------------------------------------------------------------
procedure gossteps__start;
procedure gossteps__stop;


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function app__bol(xname:string):boolean;
function info__imgs(xname:string):string;//information specific to this unit of code


//image procs ------------------------------------------------------------------
function tep__find(const xindex:longint):boolean;
function tep__findByName(const xname:string;var xindex:longint):boolean;
function tep__name(const xindex:longint):string;
function tep__canscale(const xindex:longint):boolean;//21mar2026
procedure tep__clearpersistentdata(const xindex:longint);
procedure tep__setpersistentdata(const xindex:longint;const pdata:pointer;const adata:array of byte);

function tep__info(const xindex:longint;var xwidth,xheight:longint):boolean;//15mar2026
function tep__info2(const xindex:longint;var xwidth,xheight,xtype:longint):boolean;//15aar2026

function tep__type(const xindex:longint):longint;//15apr2026
function tep__width(const xindex:longint):longint;
function tep__height(const xindex:longint):longint;
function tep__bytes(const xindex:longint):longint;//10mar2026

function tep__rootwidth(const xindex:longint):longint;//unscaled version
function tep__rootheight(const xindex:longint):longint;//unscaled version

function tep__cantodata(const xindex:longint):boolean;
function tep__todata(const xindex:longint;const d:pointer;const dformat:string):boolean;//18mar2026
function tep__todata2(const xindex,col1,col2,col3,col4:longint;const d:pointer;const dformat:string):boolean;//18mar2026
procedure tep__draw(const dclip:twinrect;const xindex,dx,dy,dcol,dpower255:longint);
procedure tep__draw2(const dclip:twinrect;const xindex,dx,dy,col1,col2,col3,col4,dpower255:longint);
procedure tep__copytoimage(const d:tobject;const xindex,col1,col2,col3,col4:longint);

procedure tep__20(const xindex:longint;const m20,c20:array of byte;const mtype,ctype:longint);//set tep
procedure tep__20b(const xindex:longint;const m20,c20:pointer;const mtype,ctype:longint);//set tep
procedure tep__24(const xindex:longint;const m24,c24:array of byte;const mtype,ctype:longint);//set tep
procedure tep__24b(const xindex:longint;const m24,c24:pointer;const mtype,ctype:longint);//set tep

function tep__tick(x:boolean):longint;//colored arrow
function tep__tick2(x:boolean):longint;//font colored circle
function tep__tick3(x:boolean):longint;//font colored square
function tep__yes(x:boolean):longint;


//.file-type based TEPs
function tep__filetype20(const xfilenameORext:string):longint;
function tep__filetype202(const xfilenameORext:string;const xdeftep:longint):longint;

//.folder based TEPs
function tep__folderimageDefault20(xfolder:string):longint;//23mar2026
function tep__folderimage20(xfolder:string;xreload:boolean):longint;//19mar2026
function tep__setfolderimage20(xfolder:string;const s:pointer):boolean;
function tep__folderimageFilename(const xfolder:string):string;
function tep__folderimageUndoFilename(const xfolder:string):string;//23mar2026

//.support procs
procedure tep__squareScaleImage(const d:tobject;const xheightLimit:longint);
procedure xtep__scale(const xvariableWidth:boolean;const xheightLimit,sw,sh:longint;var dw,dh:longint);//23mar2026
function xtep__set(const xindex,xheightLimit,xit_type:longint;pdata:pointer;const xdata:array of byte):boolean;
procedure xtep__systemFind(const xindex:longint);
procedure xtep__folderFind(const xindex:longint);
procedure xtep__appFind(const xindex:longint);


//teplist procs ----------------------------------------------------------------

procedure teplist__init(var x:tteplist);
procedure teplist__free(var x:tteplist);


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//start of images --------------------------------------------------------------
//
//Each image can be any supported image format, e.g. TEA, TEP, PNG, ICO etc - 20mar2026
//
const

//system images (?w x ?h) ------------------------------------------------------
//Note: Each image can be of varying width and height

tep_on
:array[0..247] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,23,0,0,0,15,8,6,0,0,0,15,175,84,86,0,0,0,191,73,68,65,84,120,1,164,147,65,18,64,48,12,69,49,198,133,108,220,193,153,172,156,201,29,108,92,200,134,126,51,201,124,157,38,45,237,130,52,105,94,210,79,218,38,172,11,143,143,107,92,246,211,74,57,214,105,104,67,176,179,14,120,126,15,140,60,137,247,30,164,36,182,47,155,30,155,214,89,109,24,10,151,106,175,104,102,3,48,3,227,253,3,7,152,59,200,48,95,64,239,236,47,205,61,32,199,84,22,118,150,218,144,132,111,204,18,129,81,5,7,32,6,194,39,171,74,22,116,205,157,179,141,2,85,112,233,208,122,87,195,99,221,185,208,163,57,198,117,108,236,113,230,132,148,109,21,208,15,138,2,169,196,148,175,116,224,20,158,130,228,124,252,167,176,45,121,191,52,207,221,82,226,55,0,0,0,255,255,3,0,107,9,56,155,37,206,6,97,0,0,0,0,73,69,78,68,174,66,96,130);

tep_off
:array[0..137] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,23,0,0,0,15,8,6,0,0,0,15,175,84,86,0,0,0,81,73,68,65,84,120,1,98,96,24,5,88,66,128,17,36,246,31,136,141,107,79,252,194,34,79,150,208,217,102,11,54,144,193,96,195,141,136,48,248,68,237,86,162,45,178,104,246,102,56,7,180,128,137,104,29,100,40,28,53,28,107,160,13,221,96,161,105,58,199,26,86,163,130,0,0,0,0,255,255,3,0,169,50,17,16,39,39,243,78,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_up
:array[0..130] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,10,0,0,0,6,8,6,0,0,0,250,240,15,198,0,0,0,74,73,68,65,84,120,1,140,206,209,10,0,48,4,5,80,138,253,255,247,142,178,182,186,26,123,153,23,113,79,65,244,89,188,93,68,36,119,247,185,7,17,25,88,50,51,21,8,4,0,92,96,71,55,78,104,102,231,28,194,222,85,53,223,232,217,51,47,0,0,0,255,255,3,0,186,215,25,5,149,175,242,160,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_down
:array[0..117] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,10,0,0,0,6,8,6,0,0,0,250,240,15,198,0,0,0,61,73,68,65,84,120,1,98,96,32,18,48,130,212,253,254,253,251,23,62,245,172,172,172,108,76,32,5,44,44,44,108,184,20,194,228,192,10,113,41,134,41,2,201,195,21,162,43,70,86,4,146,35,26,0,0,0,0,255,255,3,0,71,94,4,116,159,100,44,160,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_left
:array[0..127] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,6,0,0,0,8,8,6,0,0,0,218,198,142,56,0,0,0,71,73,68,65,84,120,1,92,141,209,10,0,32,8,3,43,180,255,255,222,16,172,9,202,210,151,225,157,195,57,222,184,59,34,198,204,142,170,238,149,0,9,152,123,9,134,144,33,58,44,145,117,206,104,136,200,102,248,53,186,172,231,184,98,121,1,0,0,255,255,3,0,152,29,19,16,10,89,111,168,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_right
:array[0..127] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,6,0,0,0,8,8,6,0,0,0,218,198,142,56,0,0,0,71,73,68,65,84,120,1,100,206,193,10,0,32,8,3,208,25,210,255,127,175,122,168,17,134,226,46,45,31,130,130,27,119,55,85,221,236,140,136,96,189,10,68,132,101,231,251,129,159,138,13,42,14,32,50,3,242,136,6,57,108,27,117,72,56,0,0,0,255,255,3,0,81,255,16,16,162,58,93,156,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_clo
:array[0..190] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,10,8,6,0,0,0,128,44,191,250,0,0,0,134,73,68,65,84,120,1,140,79,203,13,128,32,12,5,19,22,242,228,26,172,193,64,172,193,26,158,92,136,139,239,37,45,105,17,163,189,64,223,175,109,12,168,222,251,137,167,164,148,46,246,115,129,223,129,85,240,199,38,100,193,219,132,112,122,193,26,64,106,66,84,214,16,89,39,173,176,97,160,209,10,36,136,201,35,128,152,51,16,48,38,182,78,76,64,111,224,255,87,185,9,38,61,139,251,125,37,43,254,60,122,37,214,253,102,78,111,168,16,60,14,164,73,166,113,69,106,194,13,0,0,255,255,3,0,147,99,68,14,189,240,169,160,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_min
:array[0..85] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,1,8,6,0,0,0,234,235,79,57,0,0,0,29,73,68,65,84,120,1,98,100,0,130,223,191,127,255,2,209,132,0,43,43,43,27,0,0,0,255,255,3,0,167,26,4,2,73,22,62,27,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_nor
:array[0..203] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,10,8,6,0,0,0,128,44,191,250,0,0,0,147,73,68,65,84,120,1,180,144,65,14,64,48,16,69,75,52,174,192,202,53,28,200,138,243,176,114,13,119,112,19,238,208,5,255,145,74,53,193,202,36,127,242,255,116,218,249,211,196,4,225,156,27,36,155,160,4,93,132,73,232,172,181,91,74,37,136,78,60,143,80,75,151,66,47,152,140,244,240,50,71,196,40,180,194,140,240,19,176,81,9,241,235,212,56,91,5,166,156,19,32,138,21,143,39,189,242,162,233,151,128,248,9,183,226,155,248,245,2,203,223,44,21,177,21,249,63,22,101,55,129,159,50,9,233,235,91,125,51,189,59,0,0,0,255,255,3,0,50,95,32,115,234,15,93,12,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_max
:array[0..144] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,10,8,6,0,0,0,128,44,191,250,0,0,0,88,73,68,65,84,120,1,98,100,0,130,223,191,127,75,2,169,135,32,54,30,32,207,202,202,250,156,9,170,0,164,24,36,192,134,13,131,228,128,24,108,32,76,3,3,72,55,84,51,6,133,44,7,215,128,161,10,135,192,176,210,0,141,11,172,94,69,150,99,129,170,0,135,51,80,2,171,6,36,53,12,0,0,0,0,255,255,3,0,113,54,19,164,176,160,118,191,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_full
:array[0..180] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,10,8,6,0,0,0,128,44,191,250,0,0,0,124,73,68,65,84,120,1,140,80,65,18,128,32,8,212,38,250,67,167,254,255,44,79,253,33,47,237,106,52,200,72,19,51,136,192,46,139,230,20,88,173,245,242,45,17,217,22,95,212,156,77,58,242,67,107,140,33,129,77,168,236,8,5,254,146,66,130,5,67,233,228,0,218,148,16,129,73,200,60,248,192,103,223,97,13,59,153,56,218,160,240,53,185,195,13,225,15,216,43,180,223,152,173,161,211,25,87,155,224,94,160,212,74,250,38,215,79,55,0,0,0,255,255,3,0,18,143,43,69,129,112,214,232,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_fullexit
:array[0..192] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,12,8,6,0,0,0,82,128,140,218,0,0,0,136,73,68,65,84,120,1,172,145,75,14,192,32,8,68,107,83,122,135,174,188,255,177,92,245,14,186,233,12,41,198,80,19,89,212,196,15,56,15,20,210,182,24,173,181,42,34,39,101,56,95,216,10,237,125,193,245,107,131,224,200,116,134,192,17,66,182,59,12,66,88,48,179,65,4,15,46,193,81,144,89,165,246,231,32,247,147,44,49,14,158,80,125,188,213,115,180,170,20,189,66,45,181,15,50,179,123,59,198,146,207,132,222,167,224,8,33,179,246,201,11,189,109,25,63,125,242,66,111,63,0,0,0,255,255,3,0,16,166,38,69,213,126,18,195,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_inf
:array[0..100] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,6,8,6,0,0,0,247,238,127,129,0,0,0,44,73,68,65,84,120,1,98,96,160,53,96,4,89,240,251,247,239,95,32,154,133,149,149,13,68,255,193,193,103,5,202,51,129,20,12,46,0,0,0,0,255,255,3,0,35,128,12,4,76,36,2,194,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_helphint
:array[0..170] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,12,8,6,0,0,0,86,117,92,231,0,0,0,114,73,68,65,84,120,1,164,144,73,14,192,32,12,3,41,244,255,63,166,75,80,198,178,90,56,84,229,98,39,94,64,148,242,241,108,248,207,155,28,189,7,140,83,91,27,154,12,185,215,220,205,156,90,137,144,12,185,172,136,96,152,104,247,27,165,67,2,49,250,238,201,117,131,155,103,205,4,21,96,225,102,47,65,127,5,36,228,47,49,131,59,4,156,181,162,5,190,2,60,105,21,92,62,201,91,127,241,11,0,0,255,255,3,0,194,166,25,59,15,96,152,174,0,0,0,0,73,69,78,68,174,66,96,130);


mtep_bullet
:array[0..146] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,8,0,0,0,6,8,6,0,0,0,254,5,223,251,0,0,0,90,73,68,65,84,120,1,92,142,177,13,192,48,8,4,33,133,71,161,128,253,71,129,130,81,210,16,131,244,150,21,10,120,184,147,101,166,93,85,69,17,241,118,70,169,234,98,102,226,62,184,251,64,17,25,158,153,51,205,108,61,147,118,3,236,253,206,71,128,248,159,71,192,179,45,220,121,132,254,16,0,32,110,31,0,0,0,255,255,3,0,23,222,26,47,229,83,239,171,0,0,0,0,73,69,78,68,174,66,96,130);


//standard images (?w x 20h) ---------------------------------------------------
//Note: Each image must be 20h (20 pixels high) and of varying width
tep_unknown20
:array[0..203] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,147,73,68,65,84,120,1,212,146,209,9,128,48,12,68,85,180,51,185,131,51,245,171,51,185,131,51,213,15,237,9,87,210,144,40,248,165,133,16,122,201,75,142,210,174,251,244,233,225,238,40,177,231,152,159,156,78,33,5,0,23,148,5,48,167,165,97,183,184,54,247,80,192,65,42,26,64,205,210,70,66,44,234,201,208,17,82,175,144,20,57,200,203,141,61,221,196,237,90,119,33,9,104,23,38,116,7,96,171,9,209,142,222,64,189,62,4,5,100,175,153,61,230,38,216,147,22,217,204,108,66,44,122,249,213,223,243,134,253,89,63,1,0,0,255,255,3,0,53,165,41,48,228,99,132,251,0,0,0,0,73,69,78,68,174,66,96,130);

tep_new20
:array[0..167] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,111,73,68,65,84,120,1,98,96,24,212,128,17,228,186,255,64,108,92,123,226,23,46,151,158,109,182,96,131,201,129,52,128,53,25,1,53,76,75,49,130,137,163,208,89,115,206,129,249,48,141,32,13,76,40,42,112,112,64,6,34,187,132,40,77,48,219,96,26,89,112,24,14,23,70,118,54,76,51,81,54,193,77,128,50,70,53,81,18,16,68,165,61,88,144,131,146,18,88,3,76,96,24,209,0,0,0,0,255,255,3,0,192,180,27,254,159,189,14,21,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_fnew20
:array[0..166] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,110,73,68,65,84,120,1,236,145,225,10,128,48,8,132,87,104,239,255,188,25,52,47,58,56,6,99,209,175,17,13,68,197,251,84,92,41,83,191,5,219,157,105,71,196,222,219,212,220,55,214,0,92,80,36,160,5,10,224,217,140,117,0,171,10,122,49,0,194,208,60,158,196,134,158,13,134,147,48,133,70,112,8,81,168,254,135,238,107,188,58,132,1,110,127,92,207,171,49,116,154,127,41,174,0,0,0,255,255,3,0,111,103,29,106,142,222,160,128,0,0,0,0,73,69,78,68,174,66,96,130);

tep_home20
:array[0..250] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,194,73,68,65,84,120,1,220,145,75,14,131,48,12,68,221,170,226,64,172,114,32,56,70,87,61,70,123,160,172,122,32,54,52,182,52,83,19,48,159,174,80,89,96,39,158,60,141,109,145,179,125,23,51,52,198,182,114,47,131,86,211,83,26,141,245,89,239,164,80,110,150,4,63,125,212,222,179,85,115,159,6,192,150,228,161,35,15,193,195,247,35,33,165,67,187,40,148,43,43,46,89,130,104,25,238,156,148,233,12,20,65,240,34,130,77,90,219,130,0,166,81,219,228,204,10,133,160,35,16,0,9,3,40,119,223,237,64,180,55,26,236,37,13,215,239,55,178,23,226,117,63,183,198,182,148,86,40,116,228,233,200,189,203,104,91,208,206,214,143,194,209,248,199,160,201,176,253,112,235,25,173,213,106,237,57,206,31,0,0,0,255,255,3,0,255,235,65,190,14,82,122,130,0,0,0,0,73,69,78,68,174,66,96,130);

tep_open20
:array[0..278] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,222,73,68,65,84,120,1,236,146,203,13,194,48,12,134,93,132,216,129,19,59,116,13,214,200,5,118,200,41,59,148,75,214,96,141,174,193,14,92,138,157,198,142,235,68,40,189,34,42,85,126,196,249,252,219,45,192,79,61,3,77,179,116,140,52,76,240,230,178,229,14,39,246,9,112,228,224,155,37,192,230,98,142,19,24,129,221,74,108,19,81,134,16,81,242,240,103,145,123,11,47,145,107,47,83,44,128,124,152,148,76,8,112,222,97,202,227,27,32,134,152,143,107,99,27,152,157,172,0,2,57,114,51,80,219,24,46,53,21,51,135,146,13,205,139,164,172,128,74,181,246,100,39,165,80,143,196,99,177,5,208,187,75,32,220,159,130,148,142,180,147,113,188,234,102,77,127,158,159,41,175,198,41,10,122,1,188,100,5,89,191,202,94,0,73,17,200,158,17,88,1,207,40,127,108,181,48,174,48,182,9,48,53,255,16,224,3,0,0,255,255,3,0,199,186,80,86,175,158,193,34,0,0,0,0,73,69,78,68,174,66,96,130);

tep_save20
:array[0..197] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,141,73,68,65,84,120,1,98,96,24,242,128,17,228,131,255,64,156,154,114,226,23,41,190,153,61,199,130,13,164,25,108,64,10,80,179,145,145,17,41,250,25,206,157,59,199,48,7,104,8,11,186,174,148,20,116,17,84,254,156,57,168,124,12,3,64,210,232,138,96,90,176,25,142,213,0,108,10,97,134,160,211,88,13,24,88,23,224,178,29,221,233,48,62,19,140,65,46,141,17,6,160,248,37,4,144,211,12,209,46,152,54,205,136,1,132,209,1,209,6,160,107,132,241,41,54,128,226,204,4,115,201,16,166,1,0,0,0,255,255,3,0,136,216,31,172,33,226,213,198,0,0,0,0,73,69,78,68,174,66,96,130);

tep_close20
:array[0..191] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,135,73,68,65,84,120,1,228,145,193,13,192,32,12,3,67,31,236,63,47,31,138,105,131,142,0,11,180,17,18,196,246,17,33,204,190,87,73,79,42,125,153,229,106,249,244,196,146,20,107,153,182,46,134,220,160,166,115,212,59,196,9,49,192,222,115,99,146,11,188,121,7,200,239,111,178,170,227,83,12,186,198,11,69,140,73,219,64,19,39,224,13,45,80,156,20,123,113,19,196,0,39,80,159,32,26,14,248,174,32,253,233,115,101,50,168,94,69,96,249,220,29,32,232,164,203,251,117,221,0,0,0,255,255,3,0,123,127,49,9,196,47,125,47,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_closed20
:array[0..188] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,132,73,68,65,84,120,1,228,145,193,14,128,32,12,67,209,136,255,255,189,206,68,41,80,82,112,92,60,234,14,14,218,190,101,106,8,223,171,5,175,100,102,7,250,22,227,142,238,213,89,51,49,101,58,8,97,15,36,0,31,208,58,6,53,0,79,239,28,152,161,25,232,1,200,54,104,6,142,250,3,242,2,92,9,30,43,127,136,139,183,212,117,37,202,10,2,232,214,83,64,131,170,99,80,131,212,32,192,142,160,250,239,255,19,38,161,116,114,81,202,115,166,107,230,151,231,27,0,0,255,255,3,0,163,184,65,99,93,138,233,251,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_upward20
:array[0..195] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,139,73,68,65,84,120,1,236,145,65,14,128,32,12,4,209,136,255,127,175,152,168,107,28,162,181,144,112,208,19,94,106,219,217,9,129,16,250,247,201,13,12,178,110,21,245,154,210,50,197,56,151,16,9,170,18,9,8,151,68,18,140,64,182,34,32,76,111,57,245,174,132,0,2,42,115,43,122,73,0,9,18,160,103,207,92,245,33,1,32,112,7,245,207,28,142,125,150,176,0,4,176,149,61,188,246,231,235,164,235,21,0,108,208,235,145,196,227,249,243,73,90,4,146,182,242,222,65,250,236,143,27,216,1,0,0,255,255,3,0,177,13,58,36,236,13,68,195,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_downward20
:array[0..189] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,133,73,68,65,84,120,1,236,144,65,10,128,32,20,5,43,178,251,159,55,91,228,4,35,70,89,184,104,17,248,55,226,251,243,70,112,24,250,124,242,3,35,214,24,227,58,135,176,180,190,176,165,94,72,189,44,65,208,34,66,64,7,201,84,150,93,144,61,141,156,143,30,18,10,6,2,53,137,123,121,184,44,225,226,66,144,172,28,115,57,119,39,9,161,128,5,65,239,238,205,57,47,18,66,65,139,158,230,48,229,220,74,0,44,188,9,96,171,146,82,164,144,172,207,223,126,96,7,0,0,255,255,3,0,99,188,60,77,87,30,5,232,0,0,0,0,73,69,78,68,174,66,96,130);

tep_hide20
:array[0..209] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,153,73,68,65,84,120,1,204,146,193,14,128,32,12,67,153,81,254,90,14,242,215,120,192,20,51,82,199,136,30,229,178,49,250,180,99,132,240,235,37,112,87,107,117,77,74,58,75,61,182,200,135,34,18,22,46,112,14,160,236,49,32,114,29,185,11,41,96,197,186,31,160,55,0,224,170,52,226,12,48,22,99,135,102,0,250,210,21,243,221,94,179,55,3,84,108,227,208,147,21,120,251,6,97,22,250,107,79,100,107,189,39,128,146,74,155,13,139,188,143,117,8,194,25,200,175,66,178,51,220,47,86,221,139,120,3,31,246,184,23,181,202,214,248,252,199,249,5,0,0,255,255,3,0,45,249,67,253,78,50,172,139,0,0,0,0,73,69,78,68,174,66,96,130);

tep_back20
:array[0..212] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,156,73,68,65,84,120,1,204,146,193,13,128,48,8,69,193,152,14,228,197,153,156,200,153,188,56,144,151,154,223,228,19,196,82,175,154,52,80,224,241,105,68,228,215,159,98,186,90,107,119,200,99,215,107,221,106,241,73,85,149,201,7,188,15,96,89,68,96,125,28,126,23,34,16,139,121,127,65,95,0,192,153,52,108,6,132,17,139,41,101,0,222,197,67,129,6,101,0,139,162,53,165,152,24,221,27,132,127,113,158,163,178,103,206,148,50,16,205,120,136,190,54,34,190,15,128,223,138,238,70,100,138,84,129,181,241,124,240,11,236,66,104,64,208,143,230,27,255,216,191,1,0,0,255,255,3,0,180,76,61,61,202,64,118,231,0,0,0,0,73,69,78,68,174,66,96,130);

tep_forw20
:array[0..213] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,157,73,68,65,84,120,1,204,146,65,14,128,32,12,4,91,99,124,16,23,223,228,135,244,75,122,225,65,94,48,107,220,164,80,33,28,105,98,42,109,7,118,3,34,67,135,66,93,74,41,19,121,29,122,175,91,90,178,226,183,80,85,153,202,6,128,16,68,144,203,30,215,14,98,163,5,86,33,192,53,240,245,116,238,146,73,193,176,141,24,69,232,49,243,132,65,126,22,192,127,121,98,83,158,133,45,216,13,217,13,186,33,235,107,230,14,40,50,32,197,134,5,80,119,47,130,151,75,200,1,127,47,130,195,200,37,192,94,213,83,13,0,232,32,92,98,11,224,105,3,231,7,0,0,255,255,3,0,111,4,59,72,113,136,95,237,0,0,0,0,73,69,78,68,174,66,96,130);

tep_power20
:array[0..136] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,80,73,68,65,84,120,1,98,96,160,34,96,4,155,245,223,129,36,35,127,157,60,240,11,93,3,155,5,3,27,19,186,32,37,252,81,195,72,15,189,193,27,102,44,248,60,131,53,61,153,59,176,225,210,51,120,189,57,120,93,6,142,0,82,3,122,132,71,0,46,239,15,188,56,0,0,0,255,255,3,0,2,221,13,38,19,84,194,198,0,0,0,0,73,69,78,68,174,66,96,130);

tep_refresh20
:array[0..244] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,188,73,68,65,84,120,1,196,147,49,14,194,48,12,69,13,170,56,12,35,99,38,31,166,39,224,32,156,128,195,100,234,216,145,195,48,33,23,158,234,196,9,66,42,136,46,63,255,231,255,216,142,82,145,127,125,59,43,156,115,14,245,111,231,116,71,60,94,166,3,107,80,85,101,128,120,180,160,15,212,28,239,158,5,216,50,218,65,190,19,188,33,204,198,39,184,41,188,204,156,116,189,156,100,37,29,159,114,188,44,186,90,42,247,12,61,189,8,27,169,141,53,31,103,34,43,22,51,19,0,177,49,22,136,94,132,77,188,158,216,122,98,29,240,60,132,125,212,27,91,122,243,133,97,244,237,135,199,163,34,111,43,115,72,15,191,27,110,189,227,208,242,171,149,77,191,100,111,156,223,235,15,0,0,0,255,255,3,0,186,9,76,101,172,97,85,65,0,0,0,0,73,69,78,68,174,66,96,130);

tep_folder20
:array[0..237] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,181,73,68,65,84,120,1,98,96,24,5,52,9,1,70,144,169,255,129,120,122,173,228,47,152,13,153,205,207,217,96,108,66,52,200,0,176,33,211,128,6,164,212,166,0,185,181,64,220,204,48,167,121,14,78,189,232,22,128,12,96,65,168,134,24,0,50,40,5,196,132,26,136,76,207,105,150,71,40,71,98,49,33,216,205,88,53,130,92,134,48,8,161,26,153,133,213,37,8,47,193,188,5,163,81,195,14,108,16,48,252,144,12,65,216,8,10,19,35,35,111,100,203,176,178,207,157,219,10,22,71,242,14,34,80,137,53,0,22,200,72,134,64,98,133,84,3,64,78,129,27,66,138,23,96,46,128,249,17,107,98,131,73,98,163,177,26,128,77,225,168,24,229,33,0,0,0,0,255,255,3,0,252,89,64,187,232,71,233,43,0,0,0,0,73,69,78,68,174,66,96,130);

tep_folderimage20
:array[0..249] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,193,73,68,65,84,120,1,236,82,193,13,195,32,12,116,43,196,22,81,150,67,221,34,170,42,118,200,35,98,185,170,91,68,60,202,81,25,57,134,20,6,136,63,224,59,223,197,118,32,186,66,111,224,6,32,198,168,241,42,223,94,211,46,193,199,243,99,145,27,99,200,72,226,236,14,3,231,223,7,122,163,105,47,70,204,200,47,49,9,174,101,0,28,166,48,74,87,155,59,201,133,139,3,151,67,26,50,166,79,155,228,171,255,161,205,113,156,48,12,62,28,244,16,235,104,154,232,34,228,45,49,215,221,249,114,118,162,171,176,204,21,189,250,153,120,119,67,157,228,241,146,72,6,27,0,27,50,65,225,191,61,117,199,129,65,47,138,137,254,11,61,161,228,203,179,31,121,27,82,200,59,193,179,191,162,222,192,23,0,0,255,255,3,0,95,125,59,204,69,243,105,250,0,0,0,0,73,69,78,68,174,66,96,130);

tep_desktop20
:array[0..595] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,2,27,73,68,65,84,120,1,188,148,189,113,28,49,12,133,33,143,71,61,48,114,15,84,178,61,108,162,237,97,157,168,7,58,16,123,184,196,236,225,28,152,61,156,19,182,193,30,54,145,223,3,5,222,46,117,55,182,19,99,142,183,252,1,62,128,32,200,7,161,188,233,255,63,255,157,127,109,91,204,69,237,202,235,244,216,1,15,34,248,65,110,128,79,63,206,91,42,174,235,178,19,102,175,227,82,171,228,42,50,239,150,75,138,146,127,166,6,7,245,179,89,142,160,234,157,144,227,157,19,3,197,82,21,198,185,21,107,75,42,208,217,209,13,134,175,130,253,183,203,230,72,113,8,131,130,136,194,220,186,24,8,187,193,134,250,109,122,151,224,100,138,232,195,209,136,255,68,189,90,138,70,213,108,170,208,192,164,86,39,25,41,153,146,104,139,89,132,141,99,10,117,153,18,196,114,16,5,31,102,224,221,132,198,9,219,103,42,46,171,200,25,132,21,91,103,42,246,98,187,11,95,215,205,230,15,224,0,35,2,246,66,35,54,70,126,75,152,138,47,75,70,194,90,117,
24,252,0,158,253,176,159,91,164,221,28,161,172,148,176,114,39,30,187,99,74,155,194,1,188,179,233,93,70,186,143,150,149,64,225,238,88,17,47,49,33,90,143,115,16,133,91,201,105,85,56,120,203,112,21,246,133,217,209,215,206,180,76,106,28,115,203,23,15,46,204,173,124,98,244,178,170,125,59,85,5,119,211,241,104,135,34,114,235,25,149,133,218,197,60,47,200,88,10,53,163,92,158,27,77,83,177,254,69,110,153,59,6,148,106,187,125,61,24,116,88,57,163,252,49,199,52,48,59,150,217,173,108,197,244,17,220,83,193,75,130,11,60,58,238,208,230,160,1,112,201,5,133,0,113,242,184,180,195,28,13,53,226,151,231,69,31,15,187,77,166,116,153,43,210,152,17,37,242,138,22,144,50,54,94,18,202,94,223,195,153,123,63,72,174,93,95,183,167,147,222,26,143,186,28,47,9,21,41,204,37,95,188,242,254,84,114,78,129,240,67,95,241,251,245,117,251,0,166,50,133,14,40,6,49,0,231,8,97,116,182,83,206,29,4,212,187,96,83,52,224,33,34,91,188,247,5,181,31,222,9,197,158,19,234,16,50,175,215,104,236,104,218,202,61,210,127,156,255,13,0,0,255,
255,3,0,151,28,215,196,133,101,153,20,0,0,0,0,73,69,78,68,174,66,96,130);

tep_startmenu20
:array[0..208] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,152,73,68,65,84,120,1,212,147,177,14,128,32,12,68,209,24,254,186,12,246,175,93,84,154,92,35,21,21,133,1,89,74,161,247,40,71,112,174,183,49,72,67,107,121,91,20,104,177,213,204,236,39,187,136,60,39,136,123,68,132,18,137,59,68,98,2,58,138,33,136,133,152,39,4,147,8,8,128,18,129,209,107,58,98,86,3,137,12,5,1,248,53,54,3,169,217,112,63,215,209,221,30,234,21,116,229,209,211,171,225,144,102,87,235,24,132,187,194,188,183,81,204,230,153,189,8,131,59,125,200,82,160,190,90,20,40,208,170,43,14,176,168,31,230,27,0,0,0,255,255,3,0,107,66,39,142,168,31,221,37,0,0,0,0,73,69,78,68,174,66,96,130);

tep_programs20
:array[0..474] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,1,162,73,68,65,84,120,1,212,83,187,85,3,49,16,220,227,241,220,131,72,40,128,108,137,168,65,36,244,160,200,180,192,17,216,212,224,232,122,32,177,122,32,97,51,23,64,98,245,64,98,102,86,247,125,118,64,8,251,222,221,237,71,59,154,209,234,68,254,138,53,36,242,118,58,57,159,187,215,155,239,57,177,195,230,184,154,199,151,252,151,166,145,235,161,64,128,216,126,13,97,253,34,247,27,32,103,242,222,6,7,40,165,171,205,197,68,130,74,8,73,242,182,146,41,130,88,144,239,237,176,57,121,97,193,196,1,216,76,3,128,192,47,210,73,108,23,10,189,60,0,123,128,215,200,68,99,244,156,229,60,212,46,124,203,34,71,54,11,38,172,26,136,60,149,118,177,208,3,246,134,154,166,40,90,8,216,236,241,158,52,87,227,193,178,80,32,33,41,24,81,14,196,76,198,198,26,247,16,162,33,72,103,107,95,178,0,97,38,106,144,156,111,209,146,100,151,18,122,59,196,38,154,118,206,193,224,103,120,138,117,17,123,81,253,25,136,67,227,149,122,250,102,
156,18,176,208,28,216,133,9,69,76,170,12,250,144,185,8,18,227,135,55,58,160,178,177,2,121,76,31,57,238,145,225,19,244,170,22,102,250,113,186,138,209,242,78,48,11,214,146,103,101,54,21,78,0,22,225,211,28,132,163,178,12,237,204,97,151,53,116,26,30,238,102,0,40,134,75,216,3,109,141,87,161,54,103,72,165,245,76,68,134,27,200,228,14,235,84,235,66,198,65,49,118,34,194,90,5,186,203,240,208,95,35,8,163,135,253,167,95,229,130,235,206,135,70,57,173,78,122,20,135,203,103,110,103,7,219,109,59,72,152,154,230,139,71,191,144,141,200,243,113,191,202,77,255,191,141,197,127,239,252,0,0,0,255,255,3,0,31,179,145,162,118,34,79,84,0,0,0,0,73,69,78,68,174,66,96,130);

tep_color20
:array[0..241] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,185,73,68,65,84,120,1,204,147,59,14,195,48,8,134,105,85,113,40,79,92,140,41,231,138,196,196,161,50,181,88,198,165,142,219,42,17,67,188,4,243,248,252,155,24,128,171,173,155,9,18,145,157,174,117,45,155,59,153,209,77,80,149,247,166,121,137,8,30,61,163,25,17,48,198,108,95,10,213,3,116,0,222,99,242,63,72,204,117,160,251,58,232,8,196,139,35,172,131,60,120,246,91,155,205,188,245,198,206,64,177,217,179,56,34,96,154,162,52,80,253,253,75,120,39,51,233,140,63,111,254,42,65,72,83,148,11,146,225,149,206,174,247,205,167,162,117,100,114,21,217,105,103,84,185,26,171,255,80,116,4,22,33,6,218,77,191,195,168,77,185,37,197,53,2,98,236,90,246,19,0,0,255,255,3,0,154,153,51,64,47,248,63,198,0,0,0,0,73,69,78,68,174,66,96,130);

tep_colors20
:array[0..213] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,157,73,68,65,84,120,1,98,96,24,113,128,17,228,227,255,255,255,131,61,254,123,195,239,95,228,132,0,107,0,43,27,72,31,35,35,35,3,220,64,176,97,231,182,34,204,51,242,70,176,65,44,100,57,16,31,77,30,100,40,220,192,95,235,127,253,34,164,129,160,60,208,14,182,64,54,54,38,144,101,212,4,84,55,144,5,238,58,180,48,33,232,69,28,97,74,117,23,14,126,3,17,97,136,35,76,224,97,76,72,30,170,112,240,123,25,236,66,112,94,68,79,54,112,191,18,199,128,229,103,120,24,130,4,126,51,120,227,46,28,240,88,8,51,140,56,171,135,157,42,0,0,0,0,255,255,3,0,176,235,39,87,142,132,31,254,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_colors20
:array[0..205] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,149,73,68,65,84,120,1,220,83,209,10,128,32,12,84,139,240,163,13,95,252,104,233,197,188,209,96,10,101,136,15,214,160,214,60,59,111,39,83,234,183,161,83,74,212,92,206,71,79,151,90,235,13,255,25,188,64,98,173,85,252,96,77,6,175,115,150,24,11,88,188,247,68,34,65,231,156,44,85,8,161,168,107,60,131,59,41,42,118,117,22,195,136,86,8,136,49,22,58,224,133,140,55,248,48,69,243,17,145,71,61,158,72,15,241,61,95,107,6,179,82,95,111,45,187,85,131,131,60,186,200,110,135,246,233,32,30,218,214,97,31,198,79,0,0,0,255,255,3,0,175,119,47,244,143,44,15,168,0,0,0,0,73,69,78,68,174,66,96,130);

tep_colormatrix20
:array[0..215] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,159,73,68,65,84,120,1,98,96,24,113,128,17,228,227,255,255,255,131,61,254,187,110,195,47,114,66,128,181,41,128,13,164,143,145,145,145,1,110,32,200,176,115,12,222,228,152,199,96,196,176,149,1,100,40,220,192,95,181,235,201,54,12,230,2,144,161,108,205,129,108,76,48,1,106,209,44,112,131,158,195,89,228,49,36,33,218,224,6,82,106,30,204,21,112,3,25,40,53,17,234,66,170,135,33,213,13,132,123,249,57,165,94,134,6,34,237,92,72,113,164,32,187,16,148,109,82,82,182,194,98,158,100,26,164,23,150,159,225,97,8,54,148,129,178,194,129,100,151,12,15,13,0,0,0,0,255,255,3,0,106,210,36,62,16,51,113,135,0,0,0,0,73,69,78,68,174,66,96,130);

tep_colorpal20//use RLE6
:array[0..170] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,42,0,0,0,20,8,6,0,0,0,251,179,175,134,0,0,0,114,73,68,65,84,120,1,236,150,65,10,0,32,8,4,173,255,255,185,90,65,169,251,30,150,88,137,138,14,50,140,130,69,56,184,6,198,157,110,69,156,165,19,7,174,249,250,2,200,33,133,9,160,36,77,198,220,20,33,171,174,5,59,235,65,253,52,40,187,66,54,106,163,108,3,236,124,238,81,27,101,27,96,231,203,30,197,236,199,76,85,139,154,243,224,122,240,240,57,81,130,133,64,37,158,191,88,54,0,0,0,255,255,3,0,160,212,14,33,54,38,61,124,0,0,0,0,73,69,78,68,174,66,96,130);

tep_colorpalDual20//dual color slightly blurred together - use RLE6
:array[0..799] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,42,0,0,0,20,8,6,0,0,0,251,179,175,134,0,0,2,231,73,68,65,84,120,1,236,149,93,107,19,65,20,134,223,205,38,77,210,106,20,170,212,79,16,252,162,248,241,19,252,1,130,136,104,10,94,215,63,224,15,241,23,136,120,169,196,143,11,47,122,235,189,87,66,11,197,170,32,52,141,54,34,88,27,109,190,118,215,247,61,147,221,108,80,34,182,73,174,58,100,118,102,103,38,115,158,121,207,156,179,192,126,25,173,2,94,122,187,8,224,111,50,37,164,153,136,214,85,227,162,174,0,60,62,50,170,236,166,231,172,207,241,72,11,198,89,180,191,65,144,50,27,16,164,11,248,34,86,233,217,14,137,22,4,121,78,4,216,58,20,32,31,185,163,24,241,36,32,29,77,239,41,40,213,48,67,112,15,81,224,195,251,58,203,54,11,124,59,2,148,159,3,245,57,20,126,250,104,96,26,89,106,72,117,39,88,4,215,165,201,14,129,26,7,128,143,103,17,173,92,6,150,174,35,90,124,12,220,124,5,44,84,128,234,41,224,215,52,207,34,29,157,247,249,143,49,21,65,169,4,210,130,198,228,211,38,93,90,59,9,252,56,8,172,93,0,158,
149,129,47,199,129,109,190,111,112,92,243,161,207,195,228,220,127,248,140,76,122,94,21,246,71,91,76,53,26,19,96,171,0,124,38,72,147,109,139,16,31,206,17,238,14,176,57,71,216,82,15,174,200,181,90,207,106,215,209,41,40,168,144,225,20,191,141,6,84,112,2,227,157,195,14,13,87,165,26,65,222,159,7,42,11,14,76,42,237,16,88,10,10,220,224,104,62,129,211,38,49,150,48,185,4,62,81,157,107,118,15,42,3,170,2,20,64,141,0,91,132,91,187,8,188,188,229,128,190,31,118,170,73,217,72,7,225,122,185,214,224,132,146,6,75,247,53,39,69,189,100,197,255,129,234,112,82,173,203,191,213,143,218,133,183,160,120,199,251,246,226,182,115,179,148,84,48,72,89,69,177,148,51,115,2,249,83,53,14,14,41,125,248,191,131,58,181,251,27,8,78,106,180,167,156,91,87,231,129,71,139,76,37,179,14,156,17,138,234,105,130,199,112,220,54,113,105,127,155,65,5,211,227,255,238,27,168,184,178,76,190,18,202,14,109,46,34,156,140,233,62,41,32,26,51,238,206,61,185,11,172,19,234,211,25,55,39,87,198,42,203,189,86,250,74,244,6,246,220,24,104,151,
182,242,45,122,201,99,242,109,51,58,215,25,12,82,73,119,75,145,90,97,26,217,60,230,114,159,210,136,238,164,212,53,176,52,84,186,191,103,182,129,13,12,180,67,33,114,45,26,169,83,169,149,43,192,195,123,246,101,64,135,145,42,119,214,78,56,232,36,141,140,79,185,1,186,212,139,89,108,115,160,84,45,193,47,63,69,230,254,3,100,94,95,67,230,237,85,120,203,151,224,73,209,109,6,136,242,160,82,76,162,226,248,212,75,241,37,221,196,218,106,113,38,186,209,126,131,102,84,132,199,59,26,50,135,117,249,61,112,53,103,109,192,119,229,54,165,13,37,227,244,39,46,217,113,132,29,237,79,64,99,76,64,181,255,6,10,140,43,151,78,178,68,153,34,86,142,173,250,194,243,123,104,35,100,25,186,85,12,57,116,209,254,228,46,21,248,13,0,0,255,255,3,0,144,228,244,48,85,104,96,36,0,0,0,0,73,69,78,68,174,66,96,130);

tep_colorpalSmall20//use RLE6
:array[0..152] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,96,73,68,65,84,120,1,98,96,24,236,128,17,217,129,255,25,24,128,136,116,0,52,4,110,14,156,1,50,140,145,44,227,64,26,193,38,130,205,2,19,148,24,6,243,15,204,80,38,152,0,181,232,81,3,41,15,201,209,48,28,49,97,8,202,219,160,188,72,46,128,229,99,144,126,20,99,64,133,4,57,134,130,28,68,142,190,129,209,3,0,0,0,255,255,3,0,171,82,14,33,79,232,100,222,0,0,0,0,73,69,78,68,174,66,96,130);

tep_colorhistory20
:array[0..183] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,127,73,68,65,84,120,1,236,83,65,14,128,48,8,43,198,55,153,249,255,195,140,159,66,55,112,46,38,18,56,111,92,6,131,150,208,164,192,112,65,229,98,102,150,195,51,52,9,234,176,163,242,16,17,214,6,45,100,231,33,229,150,228,245,214,72,12,37,93,42,178,39,107,27,130,137,94,39,132,65,172,53,62,9,45,117,124,189,169,161,79,39,107,74,52,44,182,121,236,102,77,91,61,181,222,235,229,250,113,123,178,143,239,146,191,90,201,122,232,64,249,5,0,0,255,255,3,0,101,121,24,222,148,206,100,54,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_colorhistory20
:array[0..159] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,103,73,68,65,84,120,1,98,96,24,182,128,241,255,255,255,96,207,1,105,8,131,68,175,50,2,1,72,11,19,136,0,25,194,193,193,193,0,194,48,64,44,31,230,0,38,152,33,48,3,200,161,65,102,128,93,68,142,102,116,61,163,6,161,135,8,38,127,52,140,48,195,4,93,132,9,148,87,126,252,248,129,46,78,18,31,100,6,213,50,45,73,54,15,45,197,0,0,0,0,255,255,3,0,210,1,33,205,140,4,34,57,0,0,0,0,73,69,78,68,174,66,96,130);

tep_schemes20
:array[0..274] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,218,73,68,65,84,120,1,98,96,24,182,128,17,236,179,255,8,255,121,205,45,6,243,182,37,247,130,229,46,233,29,5,243,245,46,89,131,249,45,173,28,96,126,77,245,15,136,94,144,86,32,139,9,97,4,101,44,20,131,96,174,129,25,9,115,13,140,15,115,13,136,143,204,6,241,81,12,2,9,148,196,149,131,49,204,80,221,233,255,25,64,24,102,104,102,142,4,3,8,131,0,178,97,112,131,64,26,65,134,192,64,199,196,32,176,1,48,254,166,112,103,184,1,32,49,152,97,48,121,184,65,48,1,114,105,176,65,232,174,17,49,190,141,226,154,214,3,46,24,46,0,89,8,114,21,204,123,212,117,17,185,222,65,214,55,140,93,4,201,47,192,220,67,78,204,77,159,242,130,1,156,231,128,166,192,13,2,5,28,44,53,195,2,17,148,40,145,1,40,81,34,3,120,198,133,152,130,44,53,156,216,0,0,0,0,255,255,3,0,215,229,81,102,225,169,124,189,0,0,0,0,73,69,78,68,174,66,96,130);

tep_font20
:array[0..256] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,0,200,73,68,65,84,120,1,236,83,49,18,194,48,12,75,169,87,94,197,29,95,234,194,192,192,194,163,248,89,122,165,130,19,167,56,117,105,135,108,205,226,88,150,37,199,119,73,233,56,173,55,208,193,32,231,92,248,244,195,107,34,48,62,47,31,14,115,68,214,151,106,168,155,89,58,225,210,226,84,194,126,26,230,123,205,109,111,131,231,171,177,174,166,154,216,55,174,229,42,10,158,230,133,176,61,250,169,59,95,19,157,17,145,3,143,12,192,33,95,197,11,225,168,57,194,85,80,239,224,47,238,120,109,194,200,4,56,94,199,243,155,248,159,152,214,33,160,34,20,211,88,77,156,111,99,245,33,84,180,104,158,119,79,190,231,84,194,218,184,229,238,5,97,100,247,244,253,121,44,210,221,11,18,39,143,117,226,81,78,252,136,109,54,240,6,0,0,255,255,3,0,98,55,75,4,44,110,34,105,0,0,0,0,73,69,78,68,174,66,96,130);

tep_cut20
:array[0..212] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,11,0,0,0,20,8,6,0,0,0,91,44,199,104,0,0,0,156,73,68,65,84,120,1,204,82,65,14,195,48,8,35,211,254,85,63,109,253,25,125,89,87,163,26,5,114,153,180,75,57,148,24,59,198,145,106,246,136,26,76,225,238,17,102,115,156,7,60,102,28,204,24,128,189,66,245,227,231,63,49,87,43,66,95,88,156,231,188,20,118,92,196,114,146,187,176,250,34,150,155,186,132,236,139,88,174,234,179,248,61,3,158,247,207,105,240,99,56,54,62,52,30,75,76,46,197,55,201,89,150,68,55,55,34,6,1,9,145,169,110,135,37,115,227,11,204,24,101,122,1,110,81,180,216,8,179,252,145,10,209,111,242,50,46,245,51,234,11,0,0,255,255,3,0,13,149,63,35,131,192,218,84,0,0,0,0,73,69,78,68,174,66,96,130);

tep_github20
:array[0..340] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,28,73,68,65,84,120,1,204,147,221,10,130,64,16,133,215,173,59,223,72,162,110,122,167,34,49,36,81,236,237,138,158,197,203,44,207,224,89,142,154,33,116,211,66,204,56,63,95,51,59,179,206,253,219,137,80,208,235,67,85,105,150,155,185,46,47,230,61,166,103,147,101,145,91,142,166,192,48,1,1,192,100,13,86,29,80,5,78,64,75,32,4,42,12,32,79,7,33,8,104,154,198,177,21,72,213,233,67,213,108,31,140,53,65,227,118,178,211,193,225,199,163,58,109,200,41,251,15,171,72,201,12,90,42,153,27,90,91,154,56,142,187,221,31,102,178,169,121,239,195,6,224,14,150,156,56,142,67,88,219,182,209,207,21,145,102,160,100,183,231,183,43,170,107,208,231,20,141,225,68,13,180,221,36,33,7,61,107,96,112,244,202,156,207,198,143,45,173,187,123,34,93,87,129,99,39,64,125,96,35,183,234,100,216,35,64,16,244,237,178,199,16,251,227,34,7,111,248,214,86,253,244,230,96,58,41,64,248,222,6,79,4,212,103,55,70,4,32,65,147,224,211,163,16,218,109,
143,194,18,209,218,73,108,44,239,135,102,220,19,171,160,13,210,32,106,248,11,253,13,0,0,255,255,3,0,73,6,126,185,72,202,148,252,0,0,0,0,73,69,78,68,174,66,96,130);

tep_sourceforge20
:array[0..428] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,116,73,68,65,84,120,1,204,147,59,78,195,64,16,134,7,199,222,128,169,145,160,160,69,136,11,208,210,68,228,0,156,130,6,113,14,34,33,4,137,104,56,9,13,199,64,2,209,32,36,90,36,108,226,7,94,246,95,123,214,59,196,78,58,196,20,222,221,121,124,243,143,118,77,244,223,108,13,130,244,18,85,233,229,145,13,199,231,15,54,183,43,21,129,160,43,192,190,252,238,68,199,197,43,133,167,247,196,64,142,253,94,123,21,101,211,99,61,76,158,41,63,123,180,53,234,106,159,210,104,151,186,148,245,42,202,102,99,1,225,238,234,235,189,87,217,130,162,220,64,212,231,147,83,194,16,172,80,85,20,33,21,241,142,80,6,136,0,101,55,35,61,76,95,4,4,197,60,94,11,139,12,108,219,193,196,104,243,169,25,199,135,104,77,229,108,132,90,171,196,110,204,7,208,40,42,72,37,111,98,76,171,40,49,87,140,219,113,157,171,111,42,111,199,4,31,155,139,53,14,171,180,92,167,114,99,139,54,205,211,16,215,63,184,62,172,211,130,1,215,47,174,166,9,12,96,
21,206,93,51,11,194,149,226,106,7,213,7,5,147,3,155,136,183,227,27,20,88,107,154,240,25,117,48,167,136,97,97,84,57,152,63,142,191,247,33,252,174,28,8,84,1,187,168,149,1,176,10,34,20,225,0,115,48,85,145,154,236,213,206,230,219,165,132,19,132,34,118,50,140,162,54,188,12,130,186,54,147,41,205,234,96,230,188,10,130,18,241,178,27,134,88,252,191,30,112,17,108,14,157,206,174,196,63,245,253,0,0,0,255,255,3,0,92,219,167,229,122,1,195,40,0,0,0,0,73,69,78,68,174,66,96,130);

tep_instagram20
:array[0..601] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,2,33,73,68,65,84,120,1,204,147,207,75,84,81,20,199,191,231,206,56,52,227,104,246,44,94,171,84,34,164,54,65,68,34,193,56,173,130,24,37,247,182,104,215,166,77,253,1,37,110,26,132,22,69,45,106,161,33,180,204,80,112,101,36,133,181,8,130,22,49,140,249,3,193,72,130,104,42,155,212,25,231,244,238,185,222,55,239,189,65,151,209,129,251,238,249,249,121,231,220,247,46,240,191,9,73,67,156,149,45,223,247,146,163,13,186,175,87,163,46,156,139,109,138,239,84,229,154,169,167,57,196,109,86,16,210,255,166,104,221,64,172,174,70,181,82,108,152,219,118,110,9,76,30,249,12,251,157,100,220,10,122,198,84,180,38,100,111,15,20,81,123,245,5,241,106,5,219,39,119,144,46,228,72,58,210,197,86,52,164,60,212,56,142,141,235,61,53,213,13,234,47,161,58,247,25,241,37,51,166,128,78,204,127,149,60,103,225,168,15,73,62,127,31,172,245,245,63,151,207,72,78,106,186,7,177,244,59,160,98,64,13,51,80,106,3,26,66,29,85,41,166,141,65,232,
101,37,252,130,95,80,40,73,168,1,116,96,45,39,1,94,141,11,128,47,140,131,207,63,245,97,132,130,101,2,244,19,224,31,117,208,161,196,99,28,116,30,212,19,50,55,12,36,151,7,47,23,193,139,139,224,139,227,62,204,38,18,253,6,99,75,76,57,35,202,221,219,253,202,35,54,199,236,237,223,1,103,29,40,39,129,230,230,112,204,179,152,182,60,80,77,252,13,163,217,108,78,79,130,158,220,1,245,58,160,190,195,160,103,55,161,125,65,97,214,231,216,36,174,61,65,240,198,19,216,195,187,160,71,35,6,226,249,130,194,9,239,55,36,211,233,222,32,93,161,97,151,186,100,105,221,74,114,254,182,168,204,155,160,68,155,232,33,16,125,60,11,154,89,49,129,209,118,168,200,66,33,11,62,242,9,180,50,6,238,186,10,213,218,4,106,49,29,201,97,75,229,238,67,195,224,193,252,59,19,8,146,121,135,64,180,91,185,45,96,215,1,94,192,92,90,117,255,52,213,174,127,240,107,5,22,0,104,149,39,2,215,38,219,10,85,238,4,127,59,14,53,59,65,240,142,202,31,77,195,34,181,33,147,174,116,64,47,45,228,122,63,98,247,49,168,183,203,251,214,132,0,255,220,
248,11,0,0,255,255,3,0,219,10,168,168,191,80,132,234,0,0,0,0,73,69,78,68,174,66,96,130);

tep_facebook20
:array[0..244] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,188,73,68,65,84,120,1,204,148,177,14,131,48,12,68,211,138,177,162,21,159,202,192,71,116,232,167,34,90,117,7,206,210,89,38,216,80,42,144,200,130,237,228,94,206,81,72,74,103,27,23,24,234,29,87,247,103,231,149,211,187,121,136,198,74,80,152,129,34,128,21,34,182,192,25,232,87,8,161,132,77,64,75,144,182,190,81,155,170,215,87,99,4,128,1,116,157,84,157,196,66,156,105,45,201,25,149,193,193,98,21,65,185,19,37,140,193,103,116,181,234,200,10,150,226,221,64,69,180,11,91,226,60,243,168,197,227,29,113,231,53,39,116,44,142,120,177,88,220,242,165,118,183,214,20,68,242,63,110,160,81,16,146,45,176,124,173,220,108,239,189,136,254,189,28,0,3,2,65,112,170,49,0,0,0,255,255,3,0,212,110,54,91,135,13,19,8,0,0,0,0,73,69,78,68,174,66,96,130);

tep_mastodon20
:array[0..309] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,21,0,0,0,20,8,6,0,0,0,98,75,118,51,0,0,0,253,73,68,65,84,120,1,196,84,65,10,194,64,12,108,85,16,196,215,8,190,70,4,245,44,62,70,60,235,65,124,141,224,107,68,240,32,234,44,204,50,77,179,221,90,20,247,208,36,147,100,54,105,216,148,197,251,60,241,145,179,156,93,45,36,222,170,122,56,141,75,69,96,4,128,12,159,144,41,17,116,146,131,176,103,157,93,109,45,40,146,42,72,226,245,166,79,181,34,83,56,57,2,41,13,102,34,105,127,28,21,147,233,48,72,146,164,112,230,81,198,74,9,64,130,76,15,108,16,122,184,198,81,31,80,161,100,85,176,87,243,91,128,89,181,98,188,4,114,183,125,132,56,126,220,74,225,188,156,239,140,137,186,98,209,233,40,73,82,39,182,53,244,95,210,182,173,163,157,218,160,188,30,237,32,188,24,197,126,210,126,120,251,139,15,22,136,86,100,117,188,255,175,190,125,46,20,92,20,218,87,192,222,158,179,145,107,243,27,7,101,131,115,23,208,223,56,40,187,104,152,148,147,157,151,116,170,139,218,160,188,255,147,171,202,243,191,0,0,0,255,255,3,0,
110,44,78,78,8,158,167,29,0,0,0,0,73,69,78,68,174,66,96,130);

tep_twitter20
:array[0..244] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,188,73,68,65,84,120,1,188,210,209,10,134,32,12,5,224,146,240,253,159,215,11,139,19,28,57,205,109,94,20,9,225,116,219,199,234,255,183,237,195,181,195,42,165,156,111,205,222,251,94,222,34,218,255,41,118,80,110,173,49,188,247,90,235,227,236,29,208,163,117,99,50,94,98,199,99,113,139,89,8,249,129,225,160,136,198,200,233,242,32,228,31,152,54,32,246,192,8,66,253,132,89,64,207,25,228,98,184,84,64,207,184,207,214,52,25,139,45,200,251,108,31,127,13,175,72,65,198,217,116,225,100,43,220,203,167,24,63,56,167,2,160,177,5,67,140,16,27,20,209,152,121,236,46,102,33,54,40,162,49,243,211,15,16,65,108,176,136,214,79,24,138,87,43,170,113,95,115,133,253,146,191,0,0,0,255,255,3,0,65,68,94,152,53,166,52,67,0,0,0,0,73,69,78,68,174,66,96,130);

tep_capture20
:array[0..239] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,183,73,68,65,84,120,1,204,148,209,13,128,32,12,68,139,113,39,103,112,27,221,192,13,116,27,103,112,170,74,81,140,84,122,193,132,15,252,193,94,225,81,175,141,68,173,63,78,10,100,163,74,183,112,54,197,139,11,231,244,49,17,59,45,198,216,130,73,30,229,76,96,4,255,93,159,79,70,183,150,64,197,6,129,93,94,24,94,149,128,146,61,30,218,39,66,38,152,134,84,220,142,52,214,17,4,10,108,29,85,71,119,102,4,13,64,93,69,188,245,3,243,137,160,121,104,220,243,94,55,31,84,239,114,117,32,236,114,206,195,25,121,120,143,14,17,24,27,237,47,106,8,149,140,13,4,188,59,114,191,87,247,48,0,173,191,71,166,0,83,170,193,48,225,109,39,78,0,0,0,255,255,3,0,215,176,49,170,30,48,230,228,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_mute20
:array[0..218] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,162,73,68,65,84,120,1,220,144,81,14,192,32,8,67,197,236,254,71,214,165,204,46,205,2,26,247,183,249,161,68,232,131,82,202,111,143,193,89,239,61,53,216,90,243,100,173,213,107,163,66,51,43,53,74,240,15,144,25,128,117,120,83,208,14,36,5,237,66,0,58,112,113,15,136,113,50,59,81,131,161,53,7,205,196,78,30,23,26,40,76,227,27,164,130,89,76,24,106,116,242,116,217,51,88,148,219,6,209,142,78,6,240,109,109,44,205,155,233,200,218,157,16,254,9,236,90,246,83,248,20,168,144,49,95,106,67,107,210,137,245,203,55,4,65,181,11,75,65,111,96,203,177,191,89,112,2,0,0,255,255,3,0,174,210,79,75,209,240,74,198,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_unmute20
:array[0..207] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,151,73,68,65,84,120,1,220,145,81,14,192,32,8,67,197,236,254,71,214,165,100,93,26,2,100,159,139,254,56,164,125,82,55,198,81,203,144,102,239,93,134,90,107,121,115,206,233,218,40,52,179,49,227,161,214,0,100,102,130,169,45,33,21,0,70,128,21,148,66,58,192,123,187,196,187,112,168,84,212,89,4,234,180,247,248,204,33,157,17,61,46,198,80,16,122,105,28,154,190,238,255,129,188,111,162,143,27,51,51,86,245,215,28,18,77,149,56,234,88,167,111,130,166,78,198,73,116,215,126,10,129,184,3,197,73,75,72,7,98,12,157,236,160,239,27,0,0,255,255,3,0,209,239,75,65,250,86,49,128,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_bulletsquare20
:array[0..101] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,8,0,0,0,20,8,6,0,0,0,176,27,124,107,0,0,0,45,73,68,65,84,120,1,98,96,24,14,128,17,228,137,191,127,255,254,199,230,25,102,102,102,70,38,108,18,200,98,195,67,1,178,143,134,46,27,0,0,0,255,255,3,0,51,231,4,16,57,58,86,87,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_rotate20
:array[0..393] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,81,73,68,65,84,120,1,204,84,237,109,194,64,12,13,9,217,161,138,88,2,66,183,104,195,20,192,22,252,128,41,104,167,160,237,22,45,205,18,21,234,14,81,2,239,93,108,235,130,78,137,16,127,176,100,252,253,114,103,159,137,162,71,163,81,232,64,85,85,61,193,191,2,191,130,115,201,57,66,126,130,223,210,52,253,23,159,137,14,80,93,215,81,211,52,7,68,51,240,26,92,162,232,204,108,128,51,119,10,222,131,79,113,28,47,146,36,129,218,146,1,121,32,95,40,126,215,132,144,4,232,18,254,23,31,204,128,16,228,73,6,65,20,88,193,240,209,5,125,49,127,224,100,79,178,161,147,48,87,73,114,51,169,109,129,16,100,99,217,147,91,137,53,172,141,198,82,201,233,236,68,55,129,175,205,96,124,136,163,192,41,126,45,216,42,37,4,155,191,117,87,131,146,35,201,77,167,141,219,47,65,230,194,10,104,65,169,113,207,67,129,152,124,23,185,171,5,142,172,160,5,148,31,49,168,119,8,87,231,212,249,80,173,71,157,4,53,228,3,19,181,3,146,15,148,175,
189,31,232,186,16,39,248,6,248,179,231,103,163,57,40,27,191,23,235,85,117,239,248,246,248,186,79,0,118,123,167,227,239,173,246,131,178,74,27,248,114,174,136,198,116,106,106,15,74,44,245,31,147,252,61,163,109,187,70,99,136,112,29,130,240,159,65,233,120,213,51,245,63,128,188,0,0,0,255,255,3,0,194,180,97,246,27,255,231,73,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_rotateleft20
:array[0..356] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,44,73,68,65,84,120,1,212,83,209,13,130,64,12,61,140,236,113,113,16,137,58,8,193,65,52,58,136,134,65,52,193,65,12,123,240,129,239,29,45,41,202,137,241,75,155,20,94,219,215,215,114,57,156,251,53,75,198,22,106,154,198,35,159,139,19,211,106,120,73,79,211,148,120,96,3,33,8,48,62,193,51,120,1,191,161,169,197,219,73,109,9,120,134,87,240,173,214,128,93,47,36,196,11,114,156,88,178,24,51,112,117,219,141,138,205,12,153,155,76,138,144,47,131,56,140,61,193,130,16,38,120,68,217,212,38,93,75,247,20,110,38,189,78,55,226,170,133,37,126,136,217,195,94,55,151,6,6,71,193,253,11,211,50,4,103,73,20,216,162,234,139,29,184,73,253,160,27,121,144,218,39,18,67,138,172,197,85,144,249,96,210,227,25,168,80,40,124,249,88,89,161,26,159,145,140,8,241,12,174,226,196,47,166,159,171,103,84,130,193,203,86,89,166,144,22,54,23,195,250,105,20,26,156,1,54,188,199,154,198,242,65,8,147,107,20,43,52,239,13,201,27,60,9,117,35,
18,183,112,94,176,125,228,188,222,138,37,182,42,2,59,228,114,56,175,132,29,100,169,47,88,15,155,127,55,207,196,27,70,109,240,31,194,7,0,0,0,255,255,3,0,35,55,90,54,30,37,119,97,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_mirror20
:array[0..254] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,0,198,73,68,65,84,120,1,236,146,65,10,194,48,16,69,163,152,115,180,39,17,188,136,228,34,74,177,23,41,189,136,210,147,212,115,100,161,239,75,26,6,119,166,217,8,29,248,204,36,101,94,126,166,113,110,139,52,129,221,218,73,196,24,27,24,141,247,126,178,172,189,93,20,214,2,15,28,112,182,253,31,199,108,42,95,80,107,63,254,80,171,79,234,112,62,146,93,13,199,226,40,218,36,213,78,78,87,69,154,241,29,200,128,219,219,2,171,225,88,51,214,8,50,116,129,255,121,214,179,65,199,181,215,56,88,0,192,43,235,128,78,118,191,164,206,175,34,65,59,32,15,52,163,146,152,105,234,249,145,47,251,42,180,41,85,137,236,88,52,205,151,212,161,192,169,19,185,56,172,99,7,108,132,20,208,179,152,184,53,126,79,224,13,0,0,255,255,3,0,117,67,46,210,146,206,119,29,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_flip20
:array[0..258] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,202,73,68,65,84,120,1,236,147,225,9,2,49,12,133,171,216,57,236,36,226,36,114,14,34,28,231,34,226,34,138,147,244,230,232,31,191,148,180,132,187,83,235,255,11,60,242,146,38,143,16,26,231,254,176,148,210,70,96,91,118,54,224,241,68,28,188,247,131,205,27,126,81,94,223,171,128,54,247,20,4,184,251,32,18,84,160,186,173,48,26,14,184,30,68,240,4,157,10,66,191,91,153,96,164,172,83,72,199,25,236,133,252,178,60,1,227,142,224,85,138,167,113,201,47,249,44,176,244,208,154,91,5,156,91,119,208,184,3,185,21,80,191,182,141,91,151,24,248,153,15,32,94,112,3,89,176,73,128,219,184,107,211,17,31,64,95,110,167,92,35,185,108,81,253,204,209,48,48,186,228,163,10,230,154,169,192,117,214,105,18,34,98,194,76,223,0,0,0,255,255,3,0,218,70,57,171,255,51,138,30,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_save20
:array[0..254] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,198,73,68,65,84,120,1,212,83,193,13,195,48,8,116,163,56,59,100,141,174,209,87,119,232,43,59,228,229,29,178,73,215,232,26,217,161,254,244,206,2,201,38,142,211,254,26,36,66,128,227,0,89,56,119,122,185,112,131,24,227,3,102,134,142,244,27,242,66,110,242,222,211,38,233,196,178,248,142,196,64,159,214,170,224,38,216,5,13,175,226,59,37,24,115,86,77,90,43,152,130,68,9,44,118,215,207,73,8,234,43,200,128,17,223,181,184,198,72,162,107,108,8,144,12,0,82,191,146,159,87,176,172,197,4,24,139,175,65,109,73,144,41,19,198,78,48,35,185,121,194,60,134,170,162,129,37,104,117,174,230,254,135,96,213,119,173,206,105,130,130,93,25,214,99,186,225,127,129,30,29,19,107,40,44,230,81,61,147,119,238,207,7,0,0,255,255,3,0,129,220,50,31,114,164,129,141,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_saveas20
:array[0..343] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,1,31,73,68,65,84,120,1,220,147,187,17,194,48,12,134,129,35,236,64,149,29,82,101,7,170,236,64,149,29,168,178,3,21,59,80,101,141,172,145,29,72,195,255,25,203,231,56,38,105,57,116,167,147,245,250,173,135,189,219,253,10,237,41,100,154,166,139,196,77,92,161,175,208,40,95,95,20,69,27,199,28,188,2,64,39,231,9,29,153,178,183,151,146,103,93,250,68,55,50,144,74,73,189,25,215,164,226,26,252,2,226,98,71,6,98,58,146,146,115,20,236,30,232,106,65,71,59,68,242,161,91,94,145,110,199,206,14,94,158,77,95,128,232,22,130,211,4,139,15,82,113,110,126,24,22,32,33,234,203,65,85,178,193,187,119,183,2,27,102,32,126,88,97,96,9,14,107,29,196,108,198,90,1,172,78,7,123,163,204,28,103,0,100,250,80,10,98,246,153,244,45,196,21,224,103,91,238,209,109,130,172,0,52,204,3,180,77,16,197,228,42,8,0,49,200,168,27,249,63,51,146,141,193,217,16,241,209,194,12,0,163,109,135,222,220,86,148,232,30,26,195,149,45,254,144,89,0,64,92,
59,74,224,103,214,36,26,227,20,81,5,125,243,57,75,177,155,1,142,63,166,55,0,0,0,255,255,3,0,26,79,74,88,131,15,238,4,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_favadd20
:array[0..409] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,1,97,73,68,65,84,120,1,204,147,189,145,194,64,12,133,23,6,211,131,163,235,193,17,61,16,209,195,69,244,64,68,15,23,209,3,145,123,32,162,13,122,192,201,189,79,35,121,214,120,109,19,16,160,153,245,238,74,79,111,245,231,148,62,40,171,37,174,174,235,126,193,84,85,117,89,194,206,146,137,168,17,193,159,147,28,69,120,159,35,220,204,25,101,59,105,69,68,156,15,115,248,245,148,209,163,106,72,207,83,108,92,55,229,146,138,100,238,68,36,231,204,147,51,186,73,177,154,201,121,47,4,139,26,213,142,110,21,209,209,207,182,9,71,253,192,33,15,45,106,8,174,69,17,145,1,194,120,150,225,199,215,128,8,48,228,97,7,139,78,18,13,234,201,48,48,2,16,190,37,34,37,26,34,11,210,212,143,134,82,128,204,58,38,96,113,4,60,205,40,5,15,147,226,152,76,134,20,132,164,194,61,23,217,110,186,67,244,42,119,225,119,40,163,102,6,144,146,153,106,157,212,116,124,116,39,226,156,200,156,29,192,200,88,151,7,100,97,212,254,154,102,116,208,32,
122,180,104,47,145,213,5,176,141,139,244,91,22,140,249,89,87,179,79,254,78,10,157,180,78,114,226,23,162,216,181,116,79,237,70,20,103,238,18,155,130,1,153,0,164,243,208,126,213,206,107,209,41,198,32,175,153,174,3,177,161,237,71,35,76,78,196,255,104,128,76,191,216,205,17,89,56,151,118,61,196,180,19,33,81,143,230,172,228,243,29,186,127,0,0,0,255,255,3,0,85,78,120,187,131,251,33,50,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_favedit20
:array[0..393] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,1,81,73,68,65,84,120,1,196,148,177,109,3,49,12,69,149,32,231,29,82,101,135,91,35,213,237,224,42,59,184,242,14,174,178,131,171,91,35,59,164,242,16,215,228,63,129,95,144,28,89,70,130,0,17,192,35,77,126,254,35,69,158,83,250,195,243,112,143,107,219,182,3,152,105,154,142,247,176,67,50,17,205,34,56,7,201,34,194,143,17,225,211,40,168,24,85,185,34,236,101,132,127,188,21,140,170,102,85,243,142,8,55,135,239,86,74,234,146,69,18,149,64,226,131,125,24,17,230,59,19,224,85,64,132,59,66,46,146,85,21,189,73,151,35,220,73,63,192,61,75,184,63,4,220,42,93,42,3,196,57,42,176,147,188,92,19,17,196,23,177,29,88,124,58,206,77,30,0,129,235,182,50,114,240,160,122,170,52,105,42,171,161,22,246,10,228,137,233,237,205,10,196,61,121,69,122,252,121,109,202,0,68,192,5,243,150,94,210,57,218,163,253,111,226,28,183,153,223,6,33,195,160,202,32,207,126,63,228,255,180,109,13,185,237,134,44,156,158,148,49,69,215,137,197,89,25,
61,50,22,181,185,51,227,127,83,25,83,74,74,100,223,24,72,57,63,170,76,4,140,250,34,205,16,104,55,127,74,174,200,186,176,203,168,95,208,180,169,192,170,132,189,48,108,117,253,41,229,252,58,177,38,180,221,144,225,84,66,239,159,97,233,85,101,18,233,94,78,21,254,111,243,11,0,0,255,255,3,0,251,88,112,31,38,20,255,232,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_capture20
:array[0..292] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,236,73,68,65,84,120,1,220,84,65,14,2,33,12,68,35,190,212,147,15,242,180,63,221,139,29,194,212,1,90,18,111,70,18,2,118,218,105,59,101,45,229,215,215,37,43,240,60,207,135,97,175,4,127,214,90,143,8,187,70,198,110,3,25,2,239,186,97,179,157,37,42,33,97,175,174,68,85,208,70,159,158,220,143,27,111,65,139,168,36,91,173,74,139,97,165,46,65,211,80,200,28,200,152,102,251,28,203,10,169,215,32,180,56,43,207,144,20,18,152,31,112,112,28,174,33,181,97,164,144,249,96,12,99,171,120,1,190,52,214,9,29,253,92,150,170,123,224,247,83,38,167,102,222,217,136,225,220,85,88,122,219,234,31,218,212,97,71,184,232,165,186,42,137,222,57,101,181,181,59,218,229,244,236,228,123,3,54,76,121,14,244,10,163,246,64,106,123,248,244,34,93,53,150,132,75,123,115,230,236,119,39,107,47,2,62,254,111,35,64,22,187,179,111,101,216,5,254,1,246,6,0,0,255,255,3,0,145,130,107,214,44,227,40,173,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_vol20
:array[0..348] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,10,0,0,0,20,8,6,0,0,0,180,238,172,86,0,0,1,36,73,68,65,84,120,1,188,145,207,74,66,65,20,135,111,94,53,204,84,48,66,169,108,229,202,77,224,69,17,33,218,245,6,62,128,130,79,209,91,212,170,77,203,94,161,109,184,18,31,66,136,22,46,42,4,17,9,241,150,223,111,116,70,188,224,74,240,192,119,231,252,249,205,156,57,119,60,239,224,22,134,97,87,77,227,187,58,35,168,82,11,33,33,77,76,159,168,33,10,200,85,214,249,133,214,163,117,224,22,68,55,4,53,24,193,7,212,125,223,127,49,66,138,29,18,101,104,193,35,124,194,55,124,65,128,240,213,182,190,38,97,109,140,243,3,19,248,131,36,184,97,230,248,51,248,133,41,232,94,39,160,142,167,224,134,121,199,239,43,129,229,160,0,69,200,67,6,156,240,30,255,22,178,112,1,151,112,5,231,144,6,39,108,224,215,65,66,221,183,4,58,49,5,102,96,59,140,18,242,143,65,2,181,215,16,202,153,71,177,194,33,137,51,208,6,137,133,4,58,237,31,86,173,249,79,109,104,130,10,111,32,161,121,58,171,177,39,18,175,12,241,19,94,15,36,86,125,
115,34,193,150,33,126,38,49,0,223,22,204,68,54,136,174,60,173,126,219,29,27,31,162,181,253,227,37,0,0,0,255,255,3,0,186,143,50,56,59,68,92,127,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_top20
:array[0..203] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,147,73,68,65,84,120,1,236,148,61,10,192,32,12,133,211,130,61,105,39,15,228,228,77,93,106,130,9,111,16,252,133,14,173,32,70,147,124,202,51,132,104,243,56,148,151,82,186,179,29,116,63,184,122,231,92,228,28,1,46,194,244,110,129,158,101,55,251,50,133,241,42,12,5,162,99,201,254,129,196,63,117,141,204,44,184,71,209,81,67,171,37,12,104,217,165,254,12,106,64,45,204,22,160,230,199,92,3,214,2,103,206,190,12,44,13,98,70,54,194,92,213,144,191,61,160,163,151,12,157,74,74,103,123,63,236,125,200,123,113,15,0,0,0,255,255,3,0,78,201,36,240,245,146,50,3,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_right20
:array[0..201] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,145,73,68,65,84,120,1,98,96,160,34,96,132,153,245,251,247,239,20,32,123,26,140,79,2,157,197,202,202,58,7,164,158,9,68,32,25,4,146,96,67,199,64,37,89,32,117,56,192,52,168,126,136,97,64,69,32,23,193,109,64,215,4,181,25,175,129,32,61,96,151,129,24,48,167,130,216,216,0,33,121,144,30,184,97,216,12,32,85,108,212,48,82,67,108,52,2,72,15,177,33,17,102,176,156,143,203,123,132,228,65,250,96,217,9,84,34,192,139,18,116,3,145,138,40,116,41,24,31,92,162,80,181,112,132,153,76,21,26,0,0,0,255,255,3,0,17,161,39,54,204,72,10,87,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_bottom20
:array[0..211] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,155,73,68,65,84,120,1,228,148,49,14,192,32,8,69,109,19,61,105,39,15,228,212,147,214,165,124,20,195,98,82,176,155,36,42,69,255,211,80,52,132,159,237,16,94,173,245,34,191,200,183,113,204,49,198,27,154,19,157,130,97,34,89,26,201,51,181,210,25,13,136,0,38,100,23,242,63,91,215,48,20,34,62,33,28,15,12,58,152,214,14,96,155,90,239,119,6,202,111,247,100,81,107,117,14,71,45,89,160,170,134,89,198,55,133,130,143,5,50,91,75,229,147,244,9,103,235,76,241,141,129,184,220,171,198,12,206,161,122,49,188,80,215,75,229,221,108,77,247,2,0,0,255,255,3,0,1,97,40,241,136,237,242,232,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_left20
:array[0..199] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,143,73,68,65,84,120,1,98,96,160,34,96,132,153,245,251,247,239,20,32,123,26,140,79,2,157,197,202,202,58,7,164,158,9,68,16,97,16,72,3,27,58,6,106,205,2,226,105,80,253,16,195,64,2,64,140,11,192,109,70,87,0,117,17,216,64,144,28,216,101,232,138,144,249,48,47,32,139,33,179,145,229,9,26,134,172,145,16,123,212,48,66,33,132,41,63,26,102,152,97,66,72,100,8,135,25,172,68,192,229,69,100,121,152,55,65,57,31,23,128,23,49,232,10,144,138,46,176,126,170,22,142,232,150,81,196,7,0,0,0,255,255,3,0,67,203,39,54,54,159,208,29,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_invert20
:array[0..181] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,125,73,68,65,84,120,1,98,96,24,40,192,136,203,226,223,191,127,123,3,229,106,113,200,55,179,178,178,110,101,193,33,9,18,6,105,52,194,33,15,146,219,202,132,67,146,40,225,145,168,25,107,104,67,163,9,57,208,206,33,115,128,236,102,16,31,28,207,56,226,20,172,0,168,6,20,45,224,120,5,105,64,6,48,155,193,10,144,37,144,217,160,4,129,204,135,177,71,98,84,81,228,103,88,104,131,162,5,20,226,216,0,44,202,176,201,13,144,24,0,0,0,255,255,3,0,72,207,20,220,180,217,72,254,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_go20
:array[0..300] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,244,73,68,65,84,120,1,212,83,177,17,194,48,12,52,28,102,135,84,236,64,149,29,168,216,129,42,59,176,6,107,164,98,7,42,214,240,14,184,225,95,103,25,157,173,132,58,190,243,69,122,253,75,178,173,132,176,249,181,179,39,200,57,95,224,63,176,7,139,59,118,2,54,197,24,159,251,38,72,241,21,129,227,218,38,7,155,220,32,29,216,202,20,50,240,111,65,243,33,247,80,136,82,25,246,203,10,65,162,127,54,88,130,232,100,252,160,71,24,16,120,219,0,109,96,35,171,192,28,177,25,239,238,70,19,32,230,47,116,193,14,216,225,228,49,86,19,88,177,215,33,19,46,38,88,16,119,199,92,76,128,228,210,182,173,204,59,105,143,161,175,208,226,114,129,29,232,0,109,7,169,180,238,80,127,80,225,112,26,131,118,32,14,124,222,244,12,66,247,92,36,155,37,163,76,95,39,241,14,155,179,224,62,149,10,75,229,25,188,58,76,245,103,66,144,73,110,76,164,2,231,91,127,34,39,182,85,232,11,0,0,255,255,3,0,225,202,71,128,153,167,204,207,0,0,0,0,73,69,
78,68,174,66,96,130);

mtep_upper20
:array[0..277] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,221,73,68,65,84,120,1,236,145,177,17,194,48,12,69,3,135,217,129,138,25,160,99,6,170,236,192,26,84,89,131,29,82,133,25,168,204,24,12,225,2,254,203,41,57,25,155,130,26,254,221,63,43,146,190,253,165,52,205,239,97,225,71,78,41,157,245,13,61,162,62,14,33,132,167,79,18,47,125,66,13,157,184,86,110,43,34,106,173,190,179,51,59,50,177,171,236,45,190,234,124,136,71,87,155,195,79,226,147,58,6,179,122,65,172,145,178,17,185,161,16,171,105,163,60,28,104,16,176,15,10,235,133,88,77,147,229,59,10,189,142,237,170,245,76,108,214,216,54,139,243,219,173,90,95,113,187,3,214,176,220,235,34,151,30,67,94,167,62,141,81,204,204,86,35,191,235,157,38,202,182,62,219,54,203,20,177,88,67,97,125,92,191,132,44,169,23,177,12,176,216,234,245,168,26,185,155,88,212,148,251,227,155,13,188,0,0,0,255,255,3,0,177,10,61,61,166,70,165,49,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_lower20
:array[0..228] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,20,8,6,0,0,0,185,240,220,17,0,0,0,172,73,68,65,84,120,1,98,96,24,129,128,17,230,231,223,191,127,215,2,217,32,12,3,207,129,140,64,86,86,214,115,48,1,16,205,4,227,0,37,154,129,152,13,134,129,226,22,64,188,30,104,144,55,76,13,136,134,107,64,22,4,177,129,26,65,54,100,1,113,10,136,15,3,56,53,192,20,160,211,44,48,1,160,213,70,64,246,122,32,150,132,137,65,233,173,200,124,176,13,80,119,130,20,131,60,137,236,143,64,100,197,32,54,204,73,32,119,102,1,21,163,132,8,186,98,100,13,32,133,40,158,3,218,10,178,17,132,81,0,114,60,128,36,145,131,176,25,200,7,25,4,18,7,133,152,5,52,228,128,204,81,128,63,4,0,0,0,0,255,255,3,0,245,99,37,99,182,16,51,22,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_name20//name case
:array[0..392] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,23,0,0,0,20,8,6,0,0,0,102,190,166,14,0,0,1,80,73,68,65,84,120,1,236,146,33,82,195,80,20,69,11,65,86,32,187,0,22,144,5,32,144,44,32,2,89,129,172,64,34,144,21,149,21,44,160,18,17,201,12,149,21,89,0,11,96,1,44,160,54,51,61,231,231,135,121,9,3,3,182,211,55,243,242,223,191,255,230,190,251,95,50,153,156,226,168,38,112,22,111,211,182,237,45,251,121,196,168,235,162,40,234,17,246,167,237,64,188,127,131,38,37,245,43,169,232,148,124,162,193,39,235,191,226,226,7,182,55,120,39,55,228,146,156,145,3,113,12,188,128,201,51,122,3,171,110,219,61,207,227,38,212,21,245,22,183,54,48,175,195,89,42,57,187,35,47,115,106,114,70,195,117,228,125,19,207,35,185,130,212,100,162,107,9,174,251,223,98,203,97,25,9,118,28,135,174,253,136,58,54,62,72,175,61,24,13,205,52,16,197,172,229,125,197,224,131,230,23,118,156,42,168,19,67,81,27,174,104,248,44,0,207,49,45,72,57,189,9,177,10,206,13,107,138,177,115,187,239,35,65,22,98,10,248,241,146,56,235,35,233,237,54,172,
41,224,104,98,159,183,105,25,207,220,238,117,36,228,90,241,41,2,54,55,20,113,44,41,192,109,252,70,246,231,9,79,99,201,93,151,32,85,66,187,223,238,30,103,13,103,115,176,117,198,21,125,0,175,193,119,212,189,88,67,173,41,111,36,199,63,201,209,158,226,152,38,112,0,0,0,255,255,3,0,6,173,97,206,35,253,153,172,0,0,0,0,73,69,78,68,174,66,96,130);

tep_list20
:array[0..178] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,122,73,68,65,84,120,1,236,83,91,10,192,32,12,171,178,123,151,94,124,206,52,20,7,234,135,99,63,27,22,124,52,196,208,6,43,242,219,72,232,172,212,149,244,196,33,197,178,99,184,35,2,103,214,239,224,227,1,31,85,17,85,146,204,154,24,68,2,239,37,26,95,170,88,158,17,86,113,175,232,181,214,220,156,213,18,110,124,84,115,68,30,166,62,49,27,26,219,236,112,114,124,110,179,57,204,99,119,56,151,252,67,51,198,231,241,11,0,0,255,255,3,0,242,118,87,24,253,213,137,27,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_list20
:array[0..114] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,58,73,68,65,84,120,1,98,96,24,5,116,11,1,70,144,77,191,127,255,62,1,164,140,200,180,117,43,43,43,107,32,153,122,105,168,109,212,107,120,3,119,52,214,240,6,207,168,36,41,33,0,0,0,0,255,255,3,0,98,68,20,5,206,111,223,50,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_bw20
:array[0..225] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,169,73,68,65,84,120,1,204,210,209,18,128,16,16,5,80,252,248,214,143,167,174,230,46,33,86,79,121,192,44,123,230,102,114,238,111,195,35,80,236,164,218,68,122,101,183,237,123,234,41,91,80,104,160,55,160,108,172,177,6,178,32,4,69,196,249,16,82,16,76,129,7,171,8,251,184,42,196,194,108,69,18,142,120,28,250,142,41,218,117,168,5,94,234,173,37,82,158,135,235,19,205,137,222,16,130,38,104,134,0,155,66,22,100,10,89,145,33,180,130,40,84,255,169,43,8,127,74,125,35,98,95,16,77,132,13,198,10,114,119,228,89,19,161,132,152,140,154,175,180,187,222,189,7,196,150,17,54,58,99,255,63,214,19,0,0,255,255,3,0,94,223,43,172,42,41,146,160,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_less20
:array[0..170] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,114,73,68,65,84,120,1,98,96,24,5,116,14,1,70,144,125,191,127,255,254,5,164,228,89,89,89,159,227,178,31,168,70,18,40,247,16,168,134,141,9,170,72,30,36,0,149,192,208,7,211,0,148,0,169,99,0,219,4,98,32,75,32,219,136,77,28,174,9,155,70,108,26,64,234,80,52,161,107,4,242,31,2,49,134,95,97,126,2,169,7,3,168,211,192,126,4,10,96,104,128,42,27,165,232,27,2,0,0,0,0,255,255,3,0,118,12,46,40,253,77,27,238,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_more20
:array[0..152] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,96,73,68,65,84,120,1,98,96,24,5,116,14,1,70,108,246,253,254,253,91,18,40,254,16,136,229,89,89,89,159,163,171,193,208,132,172,1,151,70,38,100,83,144,53,64,109,144,7,105,132,138,195,149,194,109,194,162,1,172,8,155,56,88,19,54,9,184,177,64,6,186,60,204,121,56,61,13,210,140,236,84,100,195,70,217,116,11,1,0,0,0,0,255,255,3,0,98,252,43,255,213,128,208,207,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_stop20//16jun2025
:array[0..119] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,63,73,68,65,84,120,1,98,96,24,126,128,17,230,165,223,191,127,255,130,177,113,209,172,172,172,108,112,57,98,52,128,20,195,212,49,193,117,146,192,24,213,4,13,172,65,30,16,228,39,35,18,18,195,80,80,10,0,0,0,255,255,3,0,192,31,15,235,132,77,112,52,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_rewind20//03jul2025
:array[0..193] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,137,73,68,65,84,120,1,236,146,65,10,128,48,12,4,171,80,255,255,94,123,41,43,108,72,195,20,188,107,46,169,147,76,170,193,214,254,56,118,43,24,99,220,174,245,222,47,157,137,225,0,53,90,202,98,101,122,62,125,139,115,149,205,179,108,166,188,12,32,153,24,14,160,70,98,89,142,55,160,70,98,85,142,1,84,120,203,158,29,104,65,186,49,75,196,114,221,231,88,34,9,196,44,58,199,0,1,18,136,89,86,94,6,8,236,132,250,137,234,85,224,159,168,66,22,52,116,199,196,191,30,19,0,0,255,255,3,0,102,161,88,22,204,158,234,168,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_fastforward20//03jul2025
:array[0..183] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,127,73,68,65,84,120,1,236,146,75,10,192,32,12,68,109,193,222,255,188,117,35,83,120,16,194,248,129,46,219,108,18,39,147,167,168,165,252,113,112,5,173,181,155,186,214,122,169,118,26,30,242,3,144,145,161,56,152,181,184,6,112,82,196,236,140,210,226,137,240,91,128,154,110,192,105,67,192,46,100,10,216,129,44,1,130,204,98,9,200,47,36,88,212,166,128,104,228,20,89,27,2,178,49,239,12,208,2,52,140,129,236,128,234,189,254,202,108,240,229,220,1,0,0,255,255,3,0,246,116,88,22,183,161,102,28,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_play20
:array[0..156] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,11,0,0,0,20,8,6,0,0,0,91,44,199,104,0,0,0,100,73,68,65,84,120,1,212,145,59,10,64,33,12,4,85,200,187,255,121,77,35,91,44,132,184,81,94,105,154,172,56,19,252,180,246,94,117,30,217,221,39,179,153,125,204,91,143,32,54,243,154,194,96,136,29,147,149,32,97,136,74,40,97,37,28,225,44,92,97,8,172,43,140,139,242,41,143,112,4,49,189,132,51,88,194,10,4,252,255,187,97,61,84,11,0,0,255,255,3,0,65,160,47,235,97,14,146,43,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_pause20
:array[0..102] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,8,0,0,0,20,8,6,0,0,0,176,27,124,107,0,0,0,46,73,68,65,84,120,1,98,96,24,2,128,17,228,198,223,191,127,255,2,209,172,172,172,108,232,124,38,144,0,62,48,170,0,95,232,12,50,57,0,0,0,0,255,255,3,0,31,72,8,20,128,31,125,69,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_notes20
:array[0..205] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,149,73,68,65,84,120,1,236,148,75,14,128,32,12,68,213,136,247,63,175,108,204,96,6,10,218,207,130,133,11,73,180,53,76,95,199,134,176,44,19,214,106,49,114,206,167,181,143,189,148,210,177,121,162,200,190,11,65,39,237,97,3,23,66,161,21,127,200,115,58,83,102,178,75,110,228,112,73,61,243,234,4,128,241,60,80,228,197,226,132,0,136,101,62,22,107,78,171,147,8,64,115,218,205,4,34,194,16,229,247,91,14,13,86,129,64,32,173,178,224,150,180,183,246,171,230,85,208,202,251,89,177,33,155,133,33,0,142,197,178,201,55,242,11,0,0,255,255,3,0,12,44,65,57,77,178,119,60,0,0,0,0,73,69,78,68,174,66,96,130);

tep_visual20
:array[0..180] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,124,73,68,65,84,120,1,98,96,24,242,128,17,228,131,134,255,255,25,60,124,166,255,34,197,55,59,182,100,178,53,48,130,181,51,48,156,240,158,246,139,84,0,210,3,178,144,137,20,91,177,169,101,193,38,8,19,59,23,56,7,204,52,90,159,2,19,194,160,169,239,2,98,108,69,118,6,245,93,128,108,58,50,27,151,203,40,118,193,48,48,0,35,33,33,39,26,92,108,228,192,5,27,0,202,24,12,100,100,38,6,198,44,100,179,134,42,27,0,0,0,255,255,3,0,60,232,78,23,225,244,33,93,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_visual20
:array[0..153] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,97,73,68,65,84,120,1,98,96,24,242,128,17,230,131,223,191,127,255,130,177,137,161,89,89,89,217,224,234,72,213,12,210,8,211,195,4,55,133,76,6,11,62,125,48,91,80,156,139,166,129,250,46,32,198,86,100,71,80,223,5,200,166,35,179,113,185,140,98,23,12,3,3,48,18,18,114,162,193,197,70,14,92,234,100,38,100,19,135,30,27,0,0,0,255,255,3,0,147,133,28,54,42,161,189,194,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_info20
:array[0..144] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,88,73,68,65,84,120,1,98,96,24,242,128,17,230,131,223,191,127,255,130,177,137,161,89,89,89,217,224,234,72,213,12,210,8,211,195,4,55,133,76,6,197,6,176,160,91,12,115,26,186,56,140,143,226,119,160,32,134,1,232,10,96,26,113,209,163,94,192,18,136,67,47,22,168,147,153,112,37,146,161,33,14,0,0,0,255,255,3,0,80,98,28,58,71,106,140,181,0,0,0,0,73,69,78,68,174,66,96,130);

tep_info20
:array[0..166] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,110,73,68,65,84,120,1,98,96,24,242,128,17,228,131,134,255,255,25,60,124,166,255,34,197,55,59,182,100,178,53,48,130,181,51,48,156,240,158,246,139,84,0,210,3,178,144,137,20,91,177,169,165,216,0,22,116,83,207,5,206,65,23,66,225,27,173,79,65,225,99,24,128,174,0,69,53,22,206,168,23,24,24,48,2,113,136,198,2,40,99,48,144,145,153,24,24,179,176,164,140,33,39,4,0,0,0,255,255,3,0,207,129,78,27,56,39,25,16,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_compress20
:array[0..218] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,162,73,68,65,84,120,1,204,146,205,13,128,48,8,133,213,216,57,92,206,53,60,117,13,151,115,142,94,228,145,66,176,63,212,139,137,77,26,168,240,61,10,118,154,126,189,102,185,93,74,105,39,255,144,115,199,198,16,194,185,152,224,8,64,42,231,88,40,26,1,215,85,8,101,105,111,229,38,218,138,177,191,246,36,189,30,117,16,22,238,0,60,4,228,85,208,8,0,164,61,225,144,87,57,69,173,32,9,218,83,174,32,223,197,86,0,2,10,145,111,43,52,147,69,137,175,87,84,113,1,128,60,8,130,46,81,25,88,22,108,13,194,227,30,207,200,254,117,15,122,155,231,105,124,29,187,1,0,0,255,255,3,0,106,205,41,228,56,7,213,167,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_code20//09nov2025
:array[0..264] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,208,73,68,65,84,120,1,212,83,209,14,3,33,8,115,203,220,95,251,228,95,207,151,81,66,73,143,184,249,124,38,4,164,80,170,222,181,118,251,245,192,9,214,90,195,28,108,134,55,119,92,179,247,62,159,81,230,205,72,152,189,79,102,61,57,232,21,4,158,8,37,199,209,210,211,170,130,227,116,168,83,5,36,104,144,175,163,77,205,71,247,26,107,45,143,144,56,27,49,73,227,44,40,65,18,236,138,67,46,94,201,213,112,175,28,73,176,3,89,72,12,68,140,137,37,129,129,195,192,9,111,32,172,46,127,226,154,204,75,52,128,77,238,117,82,196,196,249,225,57,87,42,168,204,187,61,239,34,48,127,53,87,160,211,12,212,231,188,196,168,19,115,140,255,2,110,217,191,237,221,100,228,120,55,101,88,227,17,192,54,162,232,23,7,242,170,232,95,221,157,176,47,0,0,0,255,255,3,0,98,130,76,233,168,233,97,210,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_unit20//09nov2025
:array[0..253] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,197,73,68,65,84,120,1,204,147,91,10,131,64,12,69,181,56,93,80,191,186,255,5,116,65,206,79,189,195,28,137,49,113,40,148,82,65,242,184,201,153,76,196,105,250,183,103,246,3,213,90,87,159,139,226,82,202,221,230,111,54,192,87,209,213,171,58,127,96,8,242,133,190,137,3,109,62,5,217,98,77,103,155,208,236,129,67,16,16,89,0,246,218,228,82,144,111,164,33,179,41,40,187,74,6,90,34,65,16,174,36,221,78,23,213,43,183,131,152,192,54,225,71,154,7,54,16,19,120,145,216,2,241,209,176,13,36,177,159,250,218,132,71,23,79,126,6,81,253,97,217,91,225,179,67,180,151,208,71,247,246,0,242,226,39,241,215,64,237,239,31,45,155,201,248,122,196,88,237,110,7,145,28,217,171,133,143,122,127,171,191,1,0,0,255,255,3,0,115,211,84,205,66,228,31,188,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_image20//09nov2025
:array[0..302] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,246,73,68,65,84,120,1,204,146,209,13,194,48,12,68,3,34,115,176,3,95,236,192,26,93,131,47,214,232,26,221,129,175,46,212,31,238,57,113,148,138,208,32,36,4,39,165,105,156,59,251,146,56,132,95,99,135,129,101,89,6,77,23,141,19,235,55,48,139,51,197,24,199,125,38,35,6,55,5,143,91,3,142,49,83,193,112,200,11,42,35,30,243,186,76,217,157,59,163,50,152,52,174,252,184,131,208,18,67,16,16,227,208,142,8,175,230,150,4,48,63,129,31,97,75,235,182,225,212,255,166,233,38,168,237,182,170,124,247,8,122,129,59,85,229,226,220,170,78,172,121,4,9,121,34,110,157,231,162,209,72,68,227,120,15,16,54,60,37,200,226,65,187,60,151,9,20,131,60,48,123,204,212,250,172,238,160,37,134,152,69,52,25,73,172,129,136,131,226,224,149,56,209,82,18,28,8,230,196,227,238,128,247,93,217,118,66,61,215,78,20,183,158,112,7,118,89,36,81,21,18,245,128,216,53,61,238,191,239,63,0,0,0,255,255,3,0,73,14,79,50,120,148,94,75,0,0,0,0,73,69,78,
68,174,66,96,130);

mtep_test20
:array[0..259] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,3,0,0,0,138,219,252,30,0,0,0,51,80,76,84,69,17,17,17,35,35,35,54,54,54,72,72,72,89,89,89,107,107,107,126,126,126,144,144,144,162,162,162,179,179,179,197,197,197,216,216,216,234,234,234,252,252,252,57,57,57,244,244,244,127,127,127,92,80,26,6,0,0,0,17,116,82,78,83,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,8,175,118,239,0,0,0,111,73,68,65,84,120,1,116,79,91,14,192,32,8,3,246,222,20,184,255,105,135,96,212,204,172,31,38,77,31,84,4,28,65,240,1,114,197,253,164,12,128,36,1,230,148,205,156,35,110,111,73,162,208,186,237,68,170,194,197,44,139,209,131,84,70,122,154,232,85,161,130,74,52,59,133,78,53,32,20,230,122,183,82,178,102,31,102,217,216,124,245,225,88,84,79,55,181,137,243,7,231,170,63,243,11,0,0,255,255,3,0,29,253,6,105,221,136,254,196,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_copy20
:array[0..239] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,183,73,68,65,84,120,1,98,96,160,55,96,68,182,240,247,239,223,70,64,190,55,16,215,34,139,35,177,155,129,236,173,172,172,172,231,152,144,4,65,76,144,38,144,4,27,54,12,146,131,170,97,0,107,132,218,4,20,99,168,5,153,6,98,96,3,80,57,176,107,96,54,226,114,26,54,253,96,49,152,70,73,156,42,112,72,192,52,226,144,198,45,60,170,17,119,216,64,18,0,30,121,156,82,232,161,218,140,148,138,48,52,65,229,64,233,149,1,156,200,129,2,211,128,108,80,82,3,97,162,18,57,11,80,33,8,128,18,111,10,16,159,3,166,71,144,137,96,83,129,52,78,0,207,86,64,91,65,54,129,48,40,107,161,131,231,64,129,102,124,25,0,93,3,245,249,0,0,0,0,255,255,3,0,18,119,39,83,100,148,128,183,0,0,0,0,73,69,78,68,174,66,96,130);

tep_temp20//a blank 20x20
:array[0..89] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,33,73,68,65,84,120,1,98,96,24,5,163,33,48,26,2,163,33,48,26,2,163,33,64,157,16,0,0,0,0,255,255,3,0,6,84,0,1,162,253,104,215,0,0,0,0,73,69,78,68,174,66,96,130);

tep_notepad20//23mar2026
:array[0..536] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,1,224,73,68,65,84,120,1,188,82,61,75,92,81,16,61,47,238,11,54,91,104,39,132,32,187,251,190,215,221,36,162,133,93,10,81,132,96,163,22,10,137,6,147,116,249,40,82,164,16,54,88,91,72,130,22,18,88,178,97,65,196,34,63,32,93,126,129,16,162,46,254,5,155,181,116,239,115,206,188,125,155,188,101,177,75,6,230,206,189,115,103,230,156,59,115,129,255,45,22,1,219,237,54,70,183,234,49,247,151,219,235,22,247,169,237,247,241,156,207,231,161,137,91,103,87,241,201,105,11,113,28,35,116,10,216,57,104,224,205,243,53,252,58,191,80,159,91,28,199,254,215,67,188,88,91,214,243,254,244,152,117,135,21,58,29,131,160,84,128,47,122,45,251,215,27,171,232,24,3,38,56,133,113,221,111,174,46,169,165,159,146,227,194,131,17,52,19,139,53,180,162,93,75,22,166,119,159,248,179,137,18,248,169,222,164,111,160,220,181,109,172,44,46,104,81,6,12,113,153,126,245,190,70,212,201,74,36,26,226,97,57,196,131,114,128,106,20,160,18,121,152,8,61,
4,110,169,203,42,198,73,125,247,99,66,85,222,149,210,84,106,61,170,233,19,254,80,231,19,40,127,189,209,224,75,243,88,157,131,22,219,206,225,201,252,172,2,240,94,169,62,218,124,87,99,165,74,228,99,34,240,80,22,141,2,23,161,239,32,240,28,248,94,9,174,116,60,105,152,193,239,198,231,132,42,71,192,78,126,59,250,62,8,76,125,118,46,135,185,217,199,218,225,30,98,117,227,109,141,137,145,223,69,113,5,201,45,194,19,117,157,34,28,65,43,112,158,50,174,142,48,107,53,247,186,205,225,156,196,145,204,50,153,91,182,73,105,115,18,102,68,212,230,144,106,54,48,91,168,255,19,48,81,255,234,202,143,150,220,165,85,137,156,77,76,155,66,251,236,222,48,158,78,5,150,34,238,85,71,20,145,201,20,218,84,251,207,63,15,62,104,140,38,30,175,223,151,64,61,223,186,88,194,111,230,229,142,196,52,110,141,251,55,151,55,0,0,0,255,255,3,0,43,19,104,114,90,16,171,248,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_notepad20//23mar2026
:array[0..440] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,1,128,73,68,65,84,120,1,188,83,187,142,130,64,20,189,179,139,177,80,67,130,143,134,152,16,21,241,241,7,118,22,52,212,86,116,126,129,177,160,177,26,63,192,194,194,80,210,89,73,193,167,104,226,151,88,89,40,235,185,102,88,221,64,177,197,238,36,135,185,115,230,30,206,189,23,37,250,239,37,96,120,185,92,40,138,162,20,241,124,62,23,136,213,254,147,195,185,86,171,209,39,130,213,106,149,86,171,85,106,183,219,164,235,186,60,157,78,52,30,143,101,165,82,33,211,52,233,177,203,243,249,76,182,109,203,235,245,42,55,155,205,250,3,194,251,253,78,157,78,135,129,216,247,125,230,44,203,34,0,220,108,54,227,29,49,86,38,4,113,187,221,178,75,156,139,0,161,134,7,18,210,52,165,253,126,143,99,238,42,149,74,228,121,30,231,33,129,123,12,130,64,66,252,232,139,70,163,17,99,56,28,18,224,56,14,163,215,235,177,8,6,219,237,246,187,199,188,178,138,74,135,99,86,42,132,113,28,131,203,93,154,166,145,235,186,220,22,18,184,212,229,
114,41,81,194,96,48,200,74,235,247,251,24,63,3,101,98,234,200,129,193,110,183,91,103,142,32,147,36,201,117,3,9,199,233,116,250,238,184,88,44,216,241,213,165,219,237,146,2,220,212,247,132,65,24,134,249,195,41,26,138,26,32,42,120,251,1,168,139,188,253,245,101,191,18,170,151,149,203,101,232,158,142,134,97,8,133,122,189,46,26,141,70,134,102,179,41,128,86,171,197,56,30,143,44,228,169,30,14,135,71,207,252,175,98,178,232,33,132,160,201,100,82,116,253,199,252,23,0,0,0,255,255,3,0,75,30,74,93,153,154,133,185,0,0,0,0,73,69,78,68,174,66,96,130);

tep_paint20//23mar2026
:array[0..758] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,2,190,73,68,65,84,120,1,204,83,91,72,148,65,20,254,102,255,189,186,121,219,77,211,172,135,32,195,20,55,18,186,16,190,4,201,134,69,16,4,66,209,131,129,189,244,34,245,82,118,195,7,31,194,232,138,15,218,131,5,18,93,141,140,46,16,61,70,145,32,68,15,21,161,100,138,146,21,185,251,239,205,127,255,153,105,102,118,231,223,141,232,221,3,195,156,57,51,231,155,239,124,103,6,88,110,70,36,33,211,52,255,203,235,35,53,248,52,117,33,201,128,149,132,163,209,77,81,101,112,149,167,147,74,75,75,225,210,139,226,57,37,206,141,46,121,249,81,51,200,251,146,126,220,50,61,184,27,55,112,237,151,129,174,89,55,78,205,25,124,193,22,168,69,246,15,35,113,59,191,146,9,224,39,35,160,54,195,152,0,96,9,23,162,101,105,208,44,83,49,106,115,248,25,195,224,6,130,85,94,16,201,232,47,32,9,210,151,10,32,65,1,38,64,100,194,147,89,63,168,41,128,214,196,114,32,148,59,128,205,37,192,245,38,183,2,114,74,147,229,92,78,249,97,90,28,129,
15,21,192,68,8,217,12,69,91,165,137,182,218,69,100,151,168,24,76,197,180,63,254,195,198,124,134,171,18,13,89,102,79,79,15,30,103,60,252,109,146,192,22,244,19,83,253,248,29,39,32,213,199,197,237,28,182,197,84,252,105,221,43,116,250,222,163,131,143,99,183,245,14,119,210,17,212,175,112,97,116,224,66,175,91,235,53,22,35,200,106,13,54,206,195,43,74,147,55,75,32,89,166,45,198,205,217,48,14,216,159,145,138,197,113,59,189,9,89,194,48,99,218,10,66,49,218,119,226,52,127,182,72,48,124,182,14,123,94,94,196,131,29,221,138,129,102,34,65,108,81,242,68,50,140,232,218,117,248,98,86,224,82,122,139,58,179,179,198,141,231,67,253,189,74,236,145,153,4,31,252,78,112,227,76,29,44,139,226,200,185,153,156,176,130,205,235,86,175,58,211,242,34,201,101,23,175,190,89,141,233,57,55,250,162,83,138,233,200,174,50,180,213,135,136,42,205,20,9,82,200,195,39,191,130,202,174,228,75,162,84,188,194,188,169,50,69,23,181,201,117,137,139,99,123,141,71,93,164,186,22,16,194,171,78,8,81,213,44,186,165,231,200,152,201,155,
70,99,92,117,76,36,107,147,251,157,13,1,189,204,189,236,72,16,176,196,134,78,246,9,38,35,219,124,24,218,234,207,197,244,94,17,144,159,51,116,69,130,138,141,68,83,140,234,131,132,68,67,46,149,84,37,228,151,0,13,229,6,121,56,105,229,129,242,76,139,128,30,237,15,163,220,231,224,192,105,255,249,70,15,17,195,161,42,157,123,159,82,206,151,144,66,203,151,174,173,185,58,215,4,189,118,128,116,160,120,174,246,2,223,196,183,151,237,103,2,164,67,106,178,80,124,162,224,59,95,164,16,42,120,247,247,86,162,123,115,9,134,219,43,49,121,172,150,12,180,135,72,77,203,33,172,111,61,88,56,180,108,189,63,0,0,0,255,255,3,0,219,81,156,39,226,62,142,102,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_paint20//23mar2026
:array[0..575] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,2,7,73,68,65,84,120,1,204,82,57,142,98,49,16,45,67,179,9,232,1,177,73,16,160,6,2,6,9,13,1,98,73,136,26,145,116,210,34,33,227,74,92,128,148,132,136,11,192,13,136,136,56,1,136,0,177,8,177,123,254,43,169,62,238,25,209,113,91,250,223,118,185,234,213,123,207,38,250,105,67,129,208,110,183,123,202,203,58,211,46,151,139,207,239,247,59,157,78,39,10,135,195,92,39,69,193,96,144,28,178,49,231,131,86,116,62,159,181,219,237,214,145,72,132,2,129,0,121,60,30,254,124,62,31,26,235,245,122,173,205,154,255,24,109,54,27,29,139,197,200,233,116,210,229,114,33,176,193,124,56,28,232,122,189,242,26,204,16,115,56,28,20,141,70,21,24,189,152,168,2,130,24,36,220,110,55,46,192,26,133,0,66,76,0,205,90,155,17,228,188,186,156,76,183,211,233,208,106,181,162,209,104,244,133,129,48,17,64,128,91,126,81,54,155,85,54,208,241,120,212,240,1,201,213,106,149,150,203,37,205,102,51,222,163,0,223,126,191,103,191,208,100,58,157,82,
185,92,102,160,66,161,160,108,105,208,43,244,39,147,9,211,135,36,97,129,179,126,191,79,173,86,139,22,139,5,175,75,165,18,123,7,137,12,132,27,0,27,116,217,110,183,84,169,84,108,31,4,8,222,116,187,93,154,207,231,52,30,143,169,215,235,177,143,126,191,159,173,178,175,31,29,33,7,221,192,68,12,78,167,211,42,151,203,41,137,13,6,3,26,14,135,124,110,217,65,94,175,247,1,132,110,72,172,213,106,212,108,54,109,16,196,100,8,176,185,135,233,104,132,24,75,3,125,36,138,12,176,147,181,37,87,155,123,19,40,153,76,202,246,241,178,1,4,170,210,57,20,10,17,94,53,246,230,153,84,2,252,237,247,31,102,131,24,123,20,143,199,21,94,48,10,48,0,144,74,165,20,140,7,56,138,4,144,19,172,95,177,88,164,95,30,27,231,241,178,69,171,36,98,134,241,166,44,200,149,145,201,100,30,40,86,208,190,53,73,248,119,134,161,96,131,25,76,159,141,111,129,242,249,60,37,18,9,194,252,254,241,169,26,141,134,170,215,235,212,110,183,159,225,253,160,248,95,0,0,0,255,255,3,0,14,241,142,180,79,99,155,237,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_dither20
:array[0..146] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,90,73,68,65,84,120,1,98,96,24,242,128,17,228,131,223,191,127,255,98,100,100,100,251,255,255,63,6,141,207,135,172,172,172,108,76,248,20,16,35,55,106,0,3,3,197,97,192,12,10,233,186,186,186,90,32,5,194,32,128,78,51,128,162,24,36,142,78,55,3,1,197,46,24,53,128,10,209,8,142,183,161,77,0,0,0,0,255,255,3,0,32,18,23,41,13,50,14,183,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_rect20
:array[0..131] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,75,73,68,65,84,120,1,98,96,24,44,128,17,228,144,223,191,127,255,34,215,65,172,172,172,108,44,48,205,95,190,124,97,131,177,137,165,121,120,120,192,150,51,17,171,1,159,186,81,67,48,67,103,52,76,134,125,152,192,51,32,44,51,97,250,120,196,137,0,0,0,0,255,255,3,0,199,60,9,64,90,70,78,52,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_line20
:array[0..182] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,126,73,68,65,84,120,1,172,212,73,14,192,32,12,3,64,82,1,255,127,111,131,68,155,30,170,46,44,73,140,143,150,60,71,135,176,56,36,94,41,5,102,107,173,123,74,41,111,176,116,2,130,17,81,22,11,6,159,24,12,126,49,8,108,97,110,176,135,185,192,17,102,6,103,152,9,212,96,106,80,139,169,64,11,54,5,173,216,16,244,96,93,208,139,53,65,4,251,129,40,246,2,87,96,2,94,7,203,204,247,159,73,233,77,140,209,59,237,239,14,0,0,0,255,255,3,0,67,107,75,35,178,18,254,200,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_pen20
:array[0..155] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,11,0,0,0,20,8,6,0,0,0,91,44,199,104,0,0,0,99,73,68,65,84,120,1,236,143,193,10,192,48,8,67,117,104,255,255,123,167,224,112,16,233,161,131,121,45,237,197,170,201,107,67,180,249,225,204,231,238,21,51,34,110,52,204,60,112,23,17,42,241,44,130,0,53,77,41,190,48,248,83,95,178,153,213,211,95,38,85,29,45,114,95,60,167,94,125,3,251,62,57,105,233,6,1,244,213,12,187,83,31,0,0,0,255,255,3,0,202,192,18,70,187,223,27,2,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_drag20
:array[0..183] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,127,73,68,65,84,120,1,228,82,237,10,192,32,8,204,33,189,255,243,174,160,161,96,28,183,130,13,127,230,31,63,242,188,19,43,229,60,19,91,185,247,62,55,31,99,220,145,136,72,141,152,189,170,150,9,70,16,55,174,134,24,248,226,198,63,185,51,183,214,166,212,29,152,217,211,204,41,217,14,102,73,44,125,247,158,103,54,38,155,206,12,171,26,170,82,76,98,8,215,48,135,255,80,95,96,108,140,24,0,81,114,255,249,206,136,178,117,236,206,39,218,3,0,0,255,255,3,0,171,176,30,76,60,87,28,238,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_pot20
:array[0..227] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,171,73,68,65,84,120,1,228,147,221,10,128,32,12,133,181,164,183,246,170,183,78,193,60,209,129,9,243,47,186,8,26,132,178,206,190,205,77,141,249,170,89,20,22,99,236,214,151,82,58,32,178,214,110,154,216,57,103,22,237,199,83,223,48,140,21,177,66,45,225,48,12,193,61,224,20,172,7,156,134,181,128,197,52,91,253,0,164,102,56,254,107,211,100,17,43,178,121,239,113,135,60,50,228,111,199,30,254,25,219,179,169,61,227,212,70,97,212,95,176,187,162,226,102,83,208,3,74,221,53,128,16,66,245,169,176,31,26,84,130,134,6,32,3,36,80,243,87,143,217,10,212,64,208,171,3,144,32,238,9,224,74,255,15,215,19,0,0,255,255,3,0,54,65,48,152,123,141,218,73,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_gpot20
:array[0..241] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,185,73,68,65,84,120,1,196,82,65,10,195,48,12,235,198,178,255,191,119,41,180,168,32,80,141,60,187,163,176,94,146,216,146,34,197,93,150,155,191,7,244,182,134,232,58,231,7,176,215,24,239,12,14,177,103,214,252,181,222,22,164,51,58,205,46,108,11,66,160,35,122,73,176,35,122,89,176,18,61,77,185,122,31,136,185,143,79,113,219,148,213,200,225,112,134,127,76,1,206,145,171,193,101,234,144,17,28,209,213,20,127,12,5,5,45,130,20,207,78,200,225,108,100,37,127,139,31,47,77,35,171,96,36,177,151,213,211,200,36,98,141,228,120,86,236,41,178,54,184,87,50,226,243,236,158,98,96,22,32,18,68,145,108,85,156,238,21,95,58,84,112,181,135,195,10,243,255,254,14,0,0,255,255,3,0,59,40,63,55,31,143,54,143,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_cls20
:array[0..146] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,90,73,68,65,84,120,1,98,96,24,242,128,17,228,131,223,191,127,255,34,199,39,172,172,172,108,76,48,141,140,140,140,108,164,96,152,62,184,1,48,1,82,233,81,3,24,24,168,27,6,255,255,255,135,167,7,98,216,160,24,163,174,11,72,77,3,112,23,128,82,32,169,154,97,122,6,222,11,164,186,124,16,170,7,0,0,0,255,255,3,0,112,28,20,118,141,192,24,121,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_move20
:array[0..225] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,169,73,68,65,84,120,1,228,146,193,14,195,32,12,67,97,67,251,235,156,250,215,19,18,157,167,6,185,17,142,218,219,164,229,18,72,236,71,160,45,229,87,162,98,144,222,187,156,103,140,241,174,181,190,148,160,181,86,82,8,0,110,86,160,20,194,128,12,4,72,115,65,204,234,228,168,195,254,177,42,222,173,157,32,171,43,172,128,81,55,33,177,177,50,115,141,245,79,52,204,140,191,194,198,98,177,182,163,110,219,39,190,147,220,121,68,134,186,111,94,199,11,44,202,214,172,159,16,24,184,113,21,0,221,9,146,25,179,158,252,217,248,245,29,160,38,149,147,68,67,220,59,24,89,66,208,116,163,103,212,254,32,118,0,0,0,255,255,3,0,246,15,47,93,24,105,46,82,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_eyedropper20
:array[0..244] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,188,73,68,65,84,120,1,172,212,219,14,132,32,12,4,80,216,128,255,255,189,11,9,155,209,12,153,69,45,149,200,131,45,151,30,65,19,66,120,185,69,120,181,214,199,108,107,237,203,162,24,227,134,60,165,20,150,64,197,20,93,2,175,48,162,57,231,237,195,142,39,90,24,235,221,160,7,3,234,2,189,152,27,228,113,172,200,63,237,218,33,23,223,129,58,239,2,113,100,45,82,120,28,159,130,79,48,188,200,4,21,211,28,133,227,206,48,134,150,142,112,126,42,160,249,29,68,225,114,135,10,104,206,34,43,158,64,5,52,183,16,157,251,3,21,208,92,11,102,121,7,21,208,124,6,140,243,251,245,85,74,233,119,27,22,204,62,252,136,176,143,235,171,239,144,131,171,24,235,95,143,63,0,0,0,255,255,3,0,110,24,93,80,136,74,62,83,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_wraphorz20
:array[0..197] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,141,73,68,65,84,120,1,236,144,81,10,192,32,12,67,237,40,187,255,121,135,160,68,8,212,98,169,27,251,212,159,98,155,60,109,74,57,39,75,64,32,168,181,102,186,49,111,173,61,34,114,123,177,170,150,203,55,163,59,32,209,12,253,45,80,6,1,104,90,141,6,251,125,246,32,246,135,186,105,53,24,48,224,144,166,213,157,58,251,200,88,141,16,154,125,245,48,206,209,39,108,43,35,24,35,24,161,219,160,12,246,10,196,215,87,117,128,236,174,43,81,212,179,217,42,69,95,96,89,110,100,159,250,115,2,29,0,0,255,255,3,0,83,113,54,77,214,45,190,43,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_swap20
:array[0..163] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,107,73,68,65,84,120,1,220,81,209,10,0,33,8,211,67,250,255,239,205,7,163,96,113,132,90,175,21,196,192,173,213,26,209,245,139,123,2,85,173,81,18,102,46,17,39,34,244,129,236,194,117,131,203,112,26,100,162,140,123,192,64,144,207,204,194,38,160,241,112,24,100,85,109,140,203,209,39,174,245,254,47,60,50,240,158,142,217,3,6,179,70,100,242,112,211,132,119,228,166,89,3,0,0,255,255,3,0,151,27,16,112,250,28,129,73,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_back20
:array[0..184] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,128,73,68,65,84,120,1,212,144,81,10,128,48,12,67,167,88,239,127,94,251,35,25,164,148,108,78,231,143,40,140,54,218,151,212,149,242,223,199,221,143,169,237,9,176,102,120,205,130,61,6,205,108,167,214,218,64,119,0,12,150,236,210,3,116,61,108,16,73,61,0,134,24,226,97,64,133,174,0,14,105,141,36,253,48,210,21,66,188,238,62,130,94,93,196,150,29,153,136,170,239,179,110,254,137,96,30,210,190,129,48,240,4,84,163,208,51,151,19,208,247,205,9,0,0,255,255,3,0,171,134,64,44,183,117,80,86,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_forward20
:array[0..177] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,121,73,68,65,84,120,1,212,144,65,10,192,32,12,4,109,169,253,255,123,155,75,217,194,64,168,73,176,189,25,144,149,141,99,86,91,91,175,204,236,250,148,26,0,141,224,61,50,229,245,222,207,12,76,161,10,220,212,124,223,168,41,242,41,245,189,119,208,240,38,30,74,84,206,148,241,128,164,128,218,79,67,58,76,77,67,254,93,191,62,226,153,164,188,44,34,160,126,2,94,25,47,2,4,166,80,6,48,109,80,1,131,185,142,113,3,0,0,255,255,3,0,220,85,64,44,209,106,37,107,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_cut20
:array[0..365] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,1,53,73,68,65,84,120,1,196,146,187,17,194,64,12,68,13,131,139,112,68,15,180,65,228,30,28,209,3,17,61,16,185,7,34,247,64,68,15,68,46,194,9,251,132,132,239,252,97,200,208,140,125,146,86,43,237,125,138,226,223,182,73,5,12,195,240,84,92,151,101,249,72,243,225,11,63,202,111,132,215,145,219,134,227,107,167,245,58,201,165,225,89,65,214,124,218,160,85,65,165,73,77,202,194,87,14,114,165,143,33,31,203,26,184,244,147,208,171,8,135,168,114,159,6,167,233,246,178,6,16,84,192,4,62,8,97,108,171,117,44,114,182,238,178,104,12,46,114,111,154,204,161,33,155,143,237,205,108,166,128,138,100,43,189,66,166,207,164,83,135,101,215,248,78,141,127,41,184,43,170,212,112,63,102,115,111,81,1,37,34,115,19,38,223,253,156,233,209,162,2,17,184,1,166,115,35,24,7,186,248,192,62,13,68,162,136,67,11,235,37,221,94,156,176,155,39,81,132,117,194,56,232,194,182,224,100,166,146,52,64,107,250,226,56,76,200,129,31,156,243,110,32,
128,201,118,207,234,204,27,160,48,85,99,205,193,28,231,74,13,95,61,68,21,252,100,241,144,152,218,72,22,36,228,114,3,228,194,86,241,180,1,197,241,124,33,76,27,124,195,193,254,100,47,0,0,0,255,255,3,0,183,73,104,188,59,133,143,147,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_paste20
:array[0..241] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,185,73,68,65,84,120,1,98,96,24,104,192,136,238,128,223,191,127,167,0,197,188,129,88,18,42,247,28,72,111,101,101,101,157,3,229,163,80,96,3,208,52,61,7,42,14,132,169,2,202,25,1,217,211,160,124,12,195,96,6,172,135,105,2,106,0,217,14,114,5,178,11,230,0,229,183,130,12,1,202,195,213,130,248,44,32,2,8,96,138,25,160,10,193,138,33,82,24,36,200,21,112,192,4,103,17,201,0,90,144,133,172,20,230,2,100,49,56,27,234,157,245,112,1,84,70,32,200,181,132,92,0,242,47,27,54,12,52,11,108,48,33,3,80,237,196,194,27,53,128,129,97,240,132,1,74,242,196,18,91,56,133,96,153,9,61,11,131,178,111,51,49,41,17,167,201,116,147,0,0,0,0,255,255,3,0,39,219,51,214,237,119,34,122,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_open20
:array[0..298] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,242,73,68,65,84,120,1,220,147,193,13,194,48,12,69,11,162,236,192,26,172,193,26,156,186,3,167,238,192,137,53,88,163,107,116,7,122,225,63,83,71,105,100,209,244,90,75,145,93,215,254,249,223,73,154,102,183,118,64,217,52,77,87,185,135,214,141,239,204,222,138,251,182,109,135,44,23,134,199,57,11,200,160,134,115,190,148,3,232,57,215,252,117,206,232,3,64,84,41,182,0,221,131,127,11,182,206,40,168,251,165,180,65,151,179,244,88,127,145,139,18,179,147,7,248,121,86,48,96,102,85,70,143,192,135,146,17,18,94,190,235,154,87,109,167,101,178,75,32,78,13,237,181,134,188,11,197,37,208,40,22,99,45,138,234,24,129,93,141,4,36,173,176,89,189,47,197,38,198,134,92,62,108,208,183,176,161,159,158,158,160,4,178,36,63,42,45,49,74,210,212,104,199,88,9,224,101,169,199,129,182,156,148,129,104,166,92,198,212,231,79,4,173,209,163,245,157,35,191,120,34,81,193,78,114,95,0,0,0,255,255,3,0,73,182,56,59,214,234,177,63,0,0,0,
0,73,69,78,68,174,66,96,130);

mtep_refresh20
:array[0..231] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,175,73,68,65,84,120,1,204,81,187,14,196,32,12,227,170,210,15,234,196,255,79,157,238,131,202,114,49,194,200,208,28,43,173,132,200,195,14,174,19,194,170,239,227,61,156,115,62,173,126,73,47,197,24,191,146,151,112,27,11,36,26,248,224,49,204,85,235,29,252,65,6,16,36,69,213,92,149,148,182,71,86,222,52,94,71,222,161,139,38,81,163,229,119,141,93,151,137,43,178,205,16,172,33,177,56,18,233,52,111,226,186,61,139,130,246,162,212,200,105,189,142,140,174,129,111,174,202,33,118,3,166,110,227,119,48,136,195,24,163,142,41,83,50,159,249,119,191,139,156,96,154,74,173,249,184,202,240,112,27,36,199,229,182,30,29,186,46,254,1,0,0,255,255,3,0,179,114,66,157,205,59,134,143,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_prev20
:array[0..175] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,119,73,68,65,84,120,1,98,96,24,254,128,17,155,23,127,255,254,61,13,40,158,194,202,202,202,134,77,30,36,134,161,145,24,77,24,26,137,213,132,162,145,20,77,112,141,64,77,39,128,28,35,32,222,10,196,231,64,18,120,192,115,160,223,231,48,97,81,32,9,20,195,135,193,90,224,129,67,150,83,97,182,146,162,25,110,35,169,154,49,52,130,12,32,198,102,108,129,195,0,12,181,44,160,126,11,152,43,70,105,18,67,0,0,0,0,255,255,3,0,203,210,40,135,158,14,51,84,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_next20
:array[0..189] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,133,73,68,65,84,120,1,98,96,24,254,128,17,159,23,127,255,254,253,11,40,63,135,149,149,53,11,93,29,19,186,0,50,31,168,129,13,200,79,1,26,48,13,89,28,196,198,171,17,164,0,151,102,130,26,113,105,6,251,17,232,148,20,160,2,73,144,34,60,192,8,40,231,13,196,231,128,174,176,96,65,82,72,72,35,146,82,6,6,188,161,138,172,18,61,132,137,210,136,174,9,100,32,65,141,216,52,17,212,136,75,19,72,35,161,232,176,192,150,106,64,26,71,1,158,16,0,0,0,0,255,255,3,0,191,172,42,221,54,227,180,205,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_new20
:array[0..232] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,176,73,68,65,84,120,1,98,96,160,55,96,4,89,248,251,247,111,111,32,53,13,136,37,65,124,36,112,14,200,206,98,101,101,5,209,40,128,9,202,3,105,10,4,42,96,67,198,64,49,35,32,158,6,52,24,68,163,0,152,70,73,108,166,66,85,102,1,105,12,205,48,141,40,166,33,115,160,6,98,104,38,164,241,57,200,153,216,52,179,32,155,142,133,221,12,20,91,15,212,140,28,104,160,240,176,192,107,35,208,166,57,64,44,15,196,240,64,3,106,2,7,20,94,141,88,92,0,23,26,213,8,15,10,76,6,197,129,3,78,33,152,230,162,138,64,19,251,115,144,40,44,229,128,210,34,122,10,65,213,5,225,129,52,129,82,211,0,0,0,0,0,0,255,255,3,0,113,22,50,98,227,222,200,117,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_close20
:array[0..198] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,20,8,6,0,0,0,185,240,220,17,0,0,0,142,73,68,65,84,120,1,228,80,201,17,128,32,12,68,103,104,200,151,109,208,6,5,209,6,109,248,178,33,62,238,58,129,73,16,71,255,228,3,236,145,100,113,110,194,90,152,185,148,114,224,136,222,251,115,244,7,224,55,224,9,252,190,138,32,226,204,66,24,143,96,25,32,53,238,158,192,139,34,66,157,52,194,154,161,55,241,141,98,231,214,128,128,49,16,80,93,249,52,98,2,53,3,239,191,202,76,80,221,131,184,223,87,210,226,207,208,35,113,221,175,231,106,134,4,193,35,32,77,50,141,43,82,51,103,93,0,0,0,255,255,3,0,185,141,68,14,148,192,153,207,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_settings20
:array[0..413] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,101,73,68,65,84,120,1,204,147,177,145,194,64,12,69,205,205,152,30,136,174,7,71,244,64,116,61,16,209,3,145,123,32,162,7,34,122,184,136,54,40,194,201,253,247,71,210,172,237,129,75,209,204,162,221,213,215,223,47,201,116,221,167,217,230,157,160,105,154,142,138,31,2,243,236,251,254,244,10,255,245,42,16,247,23,249,107,172,65,196,73,186,74,155,17,9,56,36,34,246,15,169,184,179,116,207,106,227,51,210,42,45,94,67,1,150,73,144,140,92,52,113,98,73,114,205,120,171,232,44,192,73,129,111,249,135,214,152,32,237,59,237,33,117,12,31,123,122,104,179,162,120,237,172,224,62,3,248,184,79,48,101,90,93,98,20,167,2,134,48,90,145,54,200,37,49,75,75,18,84,182,205,230,108,19,54,39,234,220,42,45,212,236,2,0,24,32,229,185,217,242,63,58,155,72,24,154,126,212,29,37,210,134,174,136,56,200,184,220,121,247,254,103,133,105,167,198,107,7,189,224,62,233,85,206,67,40,161,212,229,153,54,16,55,254,191,102,147,204,194,40,145,
242,202,68,126,211,193,67,104,155,189,146,171,68,122,180,141,53,35,9,54,114,220,163,182,52,154,155,163,6,7,136,239,202,83,225,66,10,126,241,97,79,188,226,126,160,154,173,139,28,51,42,168,155,63,104,17,71,143,40,47,99,148,84,42,139,40,216,249,228,173,32,124,253,183,20,103,239,50,20,91,125,156,85,26,68,75,139,102,230,255,138,100,79,104,137,251,204,243,31,0,0,0,255,255,3,0,60,216,145,230,69,118,196,228,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_font20
:array[0..380] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,68,73,68,65,84,120,1,204,147,189,113,194,64,16,133,133,199,42,130,200,212,64,100,90,48,17,61,56,130,26,136,232,129,136,30,136,160,5,103,212,64,70,17,10,240,251,118,246,142,189,179,206,164,236,204,74,183,111,255,223,73,93,247,106,50,169,7,26,134,225,27,172,239,251,67,237,251,207,126,27,113,82,200,138,141,248,154,80,49,145,166,153,135,34,7,77,117,105,102,86,142,247,202,102,146,147,99,156,215,201,255,108,229,188,154,2,167,74,154,107,138,19,202,217,177,84,107,169,67,115,229,92,136,68,105,154,134,100,206,36,119,190,50,199,75,56,99,103,137,171,89,55,5,238,221,203,132,8,183,71,193,116,139,197,202,4,32,70,182,119,217,202,222,25,250,120,144,180,145,94,165,51,41,242,35,93,104,253,187,89,254,72,19,89,199,250,150,212,128,194,95,82,110,208,18,133,177,50,88,164,161,75,28,193,207,89,90,136,146,111,2,152,42,38,177,34,88,33,197,119,84,120,100,168,59,60,237,85,112,21,125,194,143,178,215,222,200,92,207,
10,209,25,238,198,132,117,51,167,105,181,177,64,48,184,251,84,194,71,84,48,124,154,44,15,210,44,164,32,120,227,231,133,167,66,28,227,247,129,116,147,102,33,121,227,183,227,225,197,43,125,95,237,66,78,38,252,252,185,157,80,10,238,88,15,226,95,80,126,1,0,0,255,255,3,0,145,174,99,13,17,240,39,140,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_wrap20
:array[0..219] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,163,73,68,65,84,120,1,98,96,24,86,128,17,228,155,223,191,127,175,7,82,70,36,250,236,28,43,43,107,32,137,122,70,140,114,114,3,246,57,48,132,230,0,241,92,96,224,254,103,2,5,23,40,148,129,88,158,88,12,212,98,9,196,146,64,156,12,196,12,96,67,64,12,82,0,200,118,160,250,22,32,78,1,233,99,1,17,196,0,96,90,2,217,12,114,53,200,43,40,128,40,151,64,13,152,6,211,9,228,131,194,178,6,136,65,225,194,128,47,96,225,41,18,75,138,6,7,44,208,85,96,67,192,222,1,114,8,37,223,44,160,133,32,151,100,145,237,29,168,70,144,65,163,128,200,16,0,0,0,0,255,255,3,0,40,234,43,227,91,81,133,249,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_print20
:array[0..264] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,208,73,68,65,84,120,1,98,96,24,182,128,17,221,103,191,127,255,78,1,138,213,162,139,163,241,155,89,89,89,231,32,139,49,33,115,160,108,144,33,10,64,133,242,216,48,72,14,136,49,44,2,187,8,232,10,73,168,164,55,144,38,5,108,5,42,6,185,238,57,11,84,23,200,134,115,64,129,44,82,76,65,10,134,44,152,215,188,129,134,160,248,153,24,3,161,122,192,190,128,25,68,140,62,188,106,168,102,16,44,140,224,182,33,249,27,46,134,133,65,187,232,135,123,13,232,18,120,226,4,6,226,127,44,174,0,11,33,203,33,235,129,121,173,25,168,234,1,80,2,151,126,12,113,160,218,135,80,65,144,94,6,176,139,64,209,8,196,224,148,140,161,3,135,0,76,61,72,47,220,32,116,181,200,78,38,86,14,230,53,100,245,196,120,19,236,29,100,77,195,152,13,0,0,0,255,255,3,0,35,38,58,29,27,109,217,224,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_zoom20
:array[0..278] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,222,73,68,65,84,120,1,220,146,193,13,131,48,12,69,105,37,134,224,212,129,122,234,14,61,49,16,39,214,96,38,134,200,133,255,168,141,98,146,32,245,216,126,201,16,199,223,223,118,146,174,251,121,220,242,9,82,74,131,252,183,236,41,99,189,202,22,217,220,247,61,235,2,119,223,81,50,73,147,12,226,75,9,15,254,230,79,22,151,27,177,119,96,149,73,30,107,149,174,226,222,1,109,47,181,100,234,217,62,163,192,11,112,1,218,135,112,5,226,240,2,92,96,104,85,119,182,197,57,216,0,23,88,109,206,16,204,29,139,23,55,225,2,213,246,114,1,173,171,99,186,192,12,161,213,133,237,35,0,47,224,120,72,34,65,216,111,67,255,253,70,178,68,63,188,226,154,15,1,100,45,161,250,18,137,11,197,91,9,2,31,78,251,107,5,130,200,87,2,72,159,69,252,16,219,101,79,17,123,15,163,182,233,228,31,176,1,0,0,255,255,3,0,135,147,84,79,240,221,245,188,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_yes20
:array[0..196] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,140,73,68,65,84,120,1,98,96,24,5,56,67,128,17,167,12,22,137,223,191,127,27,1,133,215,179,178,178,202,179,96,145,199,42,4,213,116,2,40,105,1,82,64,148,141,200,154,128,182,157,35,74,35,54,77,112,141,64,201,135,64,78,32,204,52,144,4,8,224,210,4,146,99,2,17,64,16,8,196,39,160,10,193,2,248,52,129,20,192,253,136,172,16,172,19,104,16,144,182,64,119,5,84,14,161,17,36,128,164,25,196,197,169,9,36,9,183,17,196,1,1,152,115,113,217,4,81,53,74,210,38,4,0,0,0,0,255,255,3,0,189,93,52,109,182,66,117,224,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_yesBLANK20//09jun2025
:array[0..102] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,46,73,68,65,84,120,1,98,100,0,130,255,32,130,12,192,8,212,195,68,134,62,20,45,163,6,140,6,34,40,65,140,166,131,209,48,24,28,233,0,0,0,0,255,255,3,0,121,183,1,40,183,42,90,2,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_newfolder20
:array[0..342] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,30,73,68,65,84,120,1,212,83,187,13,194,64,12,61,16,97,7,170,236,64,197,14,172,145,42,59,164,98,7,170,236,64,149,29,82,101,7,170,236,64,26,222,179,238,157,28,148,232,66,7,150,78,118,252,121,121,246,249,66,248,53,217,145,208,52,77,103,168,10,135,218,75,87,20,197,205,59,214,236,125,12,16,164,69,209,197,31,248,70,252,228,190,86,236,253,98,212,19,192,7,100,3,232,1,251,164,239,15,61,224,155,4,134,131,2,40,232,101,59,61,198,196,206,249,146,233,70,82,39,160,53,70,169,106,193,32,147,8,22,52,163,133,180,239,92,137,81,174,12,127,190,34,135,183,202,121,177,229,1,140,216,114,139,19,54,1,1,164,65,46,207,76,224,191,1,204,214,35,219,90,100,226,65,74,135,214,196,248,166,25,205,150,20,12,216,150,23,139,103,25,161,66,59,84,2,228,72,132,168,181,119,22,223,50,35,49,120,162,13,3,129,126,57,74,22,23,163,180,15,46,65,38,183,55,9,64,196,80,62,139,235,137,176,207,10,103,54,15,124,219,163,69,49,99,75,111,174,
70,155,118,253,6,132,164,172,0,76,123,196,27,228,149,107,143,178,181,127,158,240,6,0,0,255,255,3,0,127,232,94,73,20,236,197,65,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_folderimage20
:array[0..334] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,22,73,68,65,84,120,1,212,83,187,17,130,64,16,69,71,236,129,136,30,136,232,129,200,30,140,236,193,136,30,140,232,193,200,30,140,232,193,136,30,36,241,189,155,123,59,203,8,2,99,162,59,115,222,254,222,99,119,221,75,146,95,147,13,11,234,251,254,136,139,167,160,237,228,150,166,233,193,217,147,234,54,70,72,66,208,222,31,248,58,124,228,62,137,118,1,85,244,36,129,243,155,10,162,7,140,204,28,67,165,133,217,0,219,24,209,48,110,86,7,141,149,158,204,227,20,124,228,12,179,66,188,84,107,9,43,26,57,249,20,9,249,16,171,113,133,185,26,17,3,223,200,106,162,145,225,115,78,201,42,34,144,92,9,210,77,29,237,149,188,119,252,249,36,0,105,199,124,90,230,42,227,159,81,207,86,132,164,198,51,64,15,173,200,23,7,190,184,53,129,91,0,185,10,178,185,30,65,102,43,138,121,122,58,5,90,186,192,39,219,22,85,68,45,18,184,92,111,18,103,228,253,34,9,62,197,181,217,26,232,32,9,153,29,90,201,137,136,128,10,42,171,208,198,219,
252,2,17,19,151,10,8,249,136,195,251,90,138,249,243,188,23,0,0,0,255,255,3,0,23,57,91,0,95,8,46,148,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_undo20
:array[0..384] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,1,72,73,68,65,84,120,1,196,146,49,75,66,81,20,199,95,61,137,104,106,113,137,112,237,3,232,208,40,165,147,184,181,136,160,163,171,226,36,17,34,78,34,148,13,13,173,46,98,208,34,8,46,26,68,110,66,91,131,224,71,16,154,156,122,210,239,60,188,151,155,250,236,110,30,248,115,207,61,247,255,187,231,222,251,158,227,236,43,14,164,177,231,121,125,215,117,83,230,33,168,157,51,175,161,75,244,131,38,168,129,111,202,232,135,130,61,138,174,42,2,214,201,115,168,132,6,232,24,37,80,19,61,96,109,49,58,27,48,224,43,245,19,148,194,180,20,147,10,214,142,200,103,40,203,218,187,134,41,132,209,27,26,177,32,29,183,6,27,220,176,144,199,147,62,52,28,159,228,143,187,192,149,183,199,40,87,208,199,158,147,159,74,193,136,23,54,202,24,115,157,210,221,127,35,255,216,186,106,145,192,93,97,171,176,113,50,100,225,95,183,60,83,40,72,209,186,51,29,229,125,134,232,131,174,119,214,48,96,4,179,124,137,39,192,123,1,37,254,237,12,
24,199,215,65,5,64,121,105,29,59,239,12,88,196,89,70,215,128,95,154,90,37,129,48,160,60,76,12,93,0,46,214,65,153,111,192,64,114,149,17,250,6,138,138,41,40,254,220,25,240,12,227,24,181,1,171,65,144,170,155,191,167,212,186,232,214,6,84,27,236,103,252,5,0,0,255,255,3,0,50,146,99,99,46,214,118,159,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_redo20
:array[0..403] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,1,91,73,68,65,84,120,1,196,146,49,75,66,113,20,197,173,23,206,129,31,33,80,112,182,169,8,52,7,65,104,9,130,134,250,2,45,213,210,208,32,225,224,20,233,232,232,16,17,4,65,226,16,65,180,4,109,109,125,128,8,23,23,39,7,225,149,191,243,236,234,123,189,247,122,163,7,142,247,255,63,247,222,115,175,127,77,165,22,133,37,255,96,215,117,179,220,207,96,1,174,192,55,88,115,28,231,139,56,3,117,61,180,234,178,41,8,199,156,159,224,35,44,194,117,216,131,175,228,234,68,63,42,186,120,147,73,110,113,190,134,107,56,142,149,48,144,211,0,153,140,200,237,74,71,115,57,59,214,220,69,235,112,191,83,50,10,212,95,161,151,160,182,26,168,217,214,46,35,60,192,88,80,123,66,178,5,223,173,72,143,34,164,73,6,214,157,202,222,138,55,156,247,236,254,27,135,138,54,249,153,181,180,82,8,152,238,195,191,200,168,208,154,27,156,219,161,206,4,193,123,48,213,48,89,63,199,38,220,102,204,183,180,36,204,154,85,136,193,41,225,8,22,49,248,
148,246,31,2,205,42,196,96,135,160,175,160,239,250,66,140,69,168,89,149,24,228,9,250,167,93,98,208,148,22,5,123,176,64,142,134,15,132,28,60,192,40,246,33,35,39,251,157,104,190,231,190,10,75,152,254,248,115,137,205,42,198,224,130,112,8,55,48,232,75,19,34,215,158,166,230,159,52,212,184,157,195,219,185,186,200,211,4,0,0,255,255,3,0,191,181,95,200,245,56,203,185,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_exe20
:array[0..308] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,252,73,68,65,84,120,1,212,147,203,17,130,64,16,68,65,76,0,67,144,12,52,5,83,224,100,0,122,33,14,3,240,232,217,147,41,144,130,102,160,41,16,1,165,175,183,88,24,96,129,179,83,213,85,243,233,158,157,93,134,40,250,123,139,237,13,234,186,62,18,95,65,106,243,1,191,34,87,36,73,114,95,13,138,18,31,40,196,115,16,7,136,27,185,9,236,201,18,170,176,100,104,190,226,174,27,162,59,25,255,105,133,144,222,196,91,147,171,16,109,76,28,249,43,164,20,94,182,32,159,92,6,52,209,30,124,192,232,109,124,3,106,97,99,138,29,149,7,200,67,140,217,6,86,28,154,80,13,39,27,76,136,117,141,158,77,54,128,117,3,185,61,25,63,235,169,9,252,87,24,230,245,128,122,184,69,27,78,80,53,163,207,10,27,142,182,177,157,192,5,196,5,40,33,140,62,151,200,198,220,42,43,246,155,120,193,215,46,156,13,105,228,54,39,151,240,218,101,106,215,150,162,154,156,212,104,164,236,18,237,79,212,165,254,222,251,1,0,0,255,255,3,0,103,186,70,227,159,73,
212,102,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_txt20
:array[0..261] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,205,73,68,65,84,120,1,188,81,75,10,2,49,12,109,173,167,114,227,77,60,132,184,115,237,78,143,160,32,222,100,118,238,60,136,39,16,10,190,215,38,67,106,103,160,5,153,64,251,210,124,222,75,102,156,91,218,60,5,99,140,23,0,253,149,160,245,109,236,25,66,184,161,198,173,121,193,60,2,251,236,214,55,136,207,136,190,112,182,240,89,123,37,27,77,49,191,166,239,55,194,3,206,134,233,81,145,15,176,157,136,214,192,126,148,247,78,240,67,44,26,77,145,212,100,64,252,160,1,144,223,233,107,99,26,117,74,81,27,136,66,156,106,181,49,125,221,57,69,219,12,63,213,106,99,143,98,209,216,163,88,143,218,184,99,161,152,88,26,119,252,143,98,207,142,245,168,141,59,214,163,54,238,88,40,122,168,61,228,231,50,65,86,139,191,62,210,75,219,23,0,0,255,255,3,0,120,192,52,29,216,170,136,152,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_selectall20
:array[0..423] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,111,73,68,65,84,120,1,204,148,173,78,3,65,20,133,11,203,123,84,211,135,160,155,2,174,88,8,130,4,176,144,16,48,64,138,164,10,44,182,197,16,126,36,197,32,40,1,13,22,158,3,221,108,210,239,236,206,33,179,205,10,66,42,122,146,179,119,206,253,219,153,185,219,214,106,179,134,57,109,40,203,178,77,204,54,252,73,146,100,29,189,199,250,8,10,29,124,119,248,134,172,235,240,51,228,72,143,224,45,250,218,141,158,113,60,226,184,194,254,25,52,63,32,185,77,221,234,66,168,26,169,9,129,99,116,10,19,152,193,33,254,11,172,118,125,130,105,194,82,12,255,138,226,243,122,144,220,150,5,41,84,162,32,219,202,87,197,195,77,164,126,99,212,174,201,145,55,162,235,64,2,184,73,161,202,186,50,70,237,147,146,243,70,216,70,168,212,113,98,196,58,94,43,199,122,81,194,119,244,37,1,222,160,143,160,68,77,198,152,140,189,134,192,183,19,166,103,57,231,206,127,187,81,187,171,90,31,237,140,117,31,231,228,248,95,152,202,165,18,137,
85,142,159,80,7,246,124,217,202,21,82,232,233,200,46,67,195,119,39,173,88,203,1,89,55,58,15,78,55,113,78,172,227,181,226,214,93,137,188,17,219,239,75,0,143,180,80,101,93,25,163,182,167,228,252,142,56,255,32,124,161,239,248,150,160,222,166,66,143,152,101,245,167,225,218,169,255,104,111,120,227,22,221,155,236,76,127,35,251,232,67,109,3,156,226,123,192,167,143,179,14,63,208,27,65,107,215,247,112,6,49,6,0,0,255,255,3,0,191,55,138,64,247,235,59,150,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_nav20
:array[0..213] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,157,73,68,65,84,120,1,98,96,24,5,132,66,128,17,166,224,239,223,191,50,64,246,35,24,31,72,91,0,241,9,36,62,54,230,26,160,96,29,51,51,243,13,38,144,44,212,144,167,64,1,38,24,6,10,159,128,177,113,209,64,53,147,129,184,25,136,25,192,6,1,233,71,64,197,255,65,2,164,0,160,158,195,64,245,193,32,61,48,131,72,209,143,85,237,168,65,88,131,5,69,112,240,134,145,28,48,81,194,83,57,138,155,241,112,128,122,108,129,210,107,65,74,224,154,129,130,210,64,254,99,144,32,20,16,147,69,64,134,180,0,19,230,69,152,166,81,26,119,8,0,0,0,0,255,255,3,0,144,31,30,102,248,142,84,67,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_eye20
:array[0..389] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,77,73,68,65,84,120,1,236,145,175,75,67,81,20,199,159,62,155,217,56,16,86,230,143,226,100,40,130,204,104,48,104,48,56,52,152,12,22,23,12,26,54,81,103,177,108,97,193,129,221,32,8,130,130,105,11,250,88,28,131,129,8,254,35,194,3,63,223,231,189,151,187,205,188,180,3,159,247,61,231,158,239,206,187,59,47,8,198,49,178,13,76,252,247,166,56,142,51,156,31,195,18,172,26,79,27,237,66,61,12,195,158,57,115,50,52,136,33,103,116,75,240,0,239,160,1,138,101,88,135,125,168,48,236,26,117,209,55,136,33,53,58,155,112,132,177,229,92,94,130,103,131,242,14,34,60,135,182,229,6,97,40,114,120,1,121,12,29,234,52,185,110,182,13,242,61,193,37,189,111,122,25,242,38,52,168,203,104,48,169,7,141,89,228,22,118,53,4,85,60,66,8,139,176,0,63,240,138,55,133,231,147,124,11,74,102,104,242,38,13,210,109,14,48,100,81,213,123,200,41,172,169,246,34,34,215,178,239,117,134,239,13,105,83,151,147,27,81,228,160,10,54,116,131,15,91,120,
170,179,57,175,174,147,207,171,158,210,131,137,5,169,23,95,228,39,94,109,211,21,146,134,45,248,221,51,185,248,219,145,109,120,170,69,78,131,246,54,99,184,49,170,191,51,20,238,171,13,118,204,18,175,56,223,49,189,23,244,156,91,244,6,189,227,122,196,27,248,5,0,0,255,255,3,0,14,183,87,149,165,108,107,231,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_upone20
:array[0..194] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,138,73,68,65,84,120,1,98,96,24,65,224,239,223,191,87,112,121,151,17,155,4,80,195,71,160,56,31,16,127,98,102,102,230,71,87,131,161,9,170,225,24,80,161,7,16,159,0,98,45,116,141,76,200,166,64,53,236,0,42,242,4,137,3,105,75,32,181,3,42,14,87,10,215,132,164,33,28,46,11,209,8,226,163,104,4,107,2,106,0,121,26,100,3,138,6,152,102,168,56,72,35,56,112,88,64,18,64,65,29,152,2,92,52,178,129,112,231,225,82,140,77,124,8,107,186,138,205,63,195,85,12,0,0,0,255,255,3,0,170,54,45,230,74,153,139,171,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_fav20
:array[0..465] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,153,73,68,65,84,120,1,212,146,63,44,4,81,16,198,223,90,173,208,169,36,68,67,212,46,254,37,66,36,36,34,39,167,19,205,117,90,21,33,156,11,238,34,18,34,10,10,205,133,66,34,185,138,147,43,200,181,122,133,130,70,71,35,66,187,137,223,60,111,55,187,107,223,81,50,201,183,51,239,251,190,153,155,125,183,74,253,187,240,60,111,29,172,253,180,184,83,207,192,128,81,244,83,227,153,117,93,183,102,243,55,216,4,195,47,145,247,193,1,144,218,26,214,65,108,51,70,87,138,45,182,65,145,186,15,110,216,54,41,113,16,13,131,52,108,130,221,80,163,108,182,133,54,16,226,130,82,223,17,98,22,102,18,116,129,30,240,6,174,217,100,134,28,4,190,50,7,185,183,102,112,7,238,193,5,190,146,191,209,17,196,43,200,65,58,160,37,62,4,77,193,101,140,38,11,228,193,7,56,4,170,81,30,132,188,198,2,40,201,225,151,241,140,47,13,10,226,215,27,241,43,27,212,114,161,21,214,31,18,161,94,224,25,65,191,4,69,122,101,137,175,65,82,64,236,144,114,
160,138,177,95,184,164,48,218,21,218,170,233,209,54,255,142,244,1,97,143,162,6,82,154,72,126,244,66,223,224,149,127,49,136,200,32,195,118,144,31,2,199,247,66,180,246,56,157,52,168,155,95,147,247,215,193,171,164,65,198,63,163,85,168,229,51,137,132,19,62,209,32,31,98,25,115,43,245,56,245,50,104,50,158,119,114,1,77,238,240,133,122,138,250,214,104,42,62,104,14,33,15,30,65,27,144,198,19,178,162,57,75,90,4,79,160,19,172,160,157,145,117,68,6,9,67,67,149,116,142,233,88,59,98,15,244,121,168,105,244,137,152,244,199,142,159,0,0,0,255,255,3,0,221,118,121,109,152,195,155,35,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_schemes20
:array[0..478] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,166,73,68,65,84,120,1,204,148,49,75,3,65,16,133,79,207,86,45,44,44,189,90,236,83,8,218,27,8,118,10,71,90,197,8,86,138,134,216,138,17,193,66,136,133,133,22,146,94,16,197,86,197,34,149,32,218,199,31,96,17,251,3,191,119,55,187,146,227,148,216,101,224,177,51,111,102,223,206,110,230,18,4,195,102,35,69,13,37,73,82,130,95,6,21,48,105,53,15,172,247,224,46,12,195,79,227,252,210,39,132,192,20,153,109,176,0,142,193,147,219,148,19,111,192,95,147,247,54,234,189,204,57,181,184,162,66,39,34,14,191,3,234,184,43,96,13,225,67,241,206,124,71,36,54,33,231,40,222,112,73,173,240,239,44,77,248,43,199,195,169,115,197,231,240,105,103,105,71,36,34,200,26,216,7,121,107,66,188,136,148,40,168,178,89,111,164,250,29,19,13,220,213,214,33,207,172,0,247,199,212,9,120,51,198,139,194,117,225,110,192,146,114,233,213,80,125,198,143,45,41,254,87,163,54,34,121,0,26,96,26,108,177,47,118,29,205,12,34,194,166,62,99,79,7,98,81,
228,152,101,62,56,169,164,132,221,89,237,78,128,219,252,1,22,199,182,207,47,174,35,189,209,5,34,109,214,71,48,11,198,65,219,174,130,155,153,98,213,229,249,84,136,83,244,152,26,194,75,80,38,174,3,61,236,43,208,59,20,26,98,250,2,52,241,217,99,23,86,65,82,168,217,210,48,182,172,131,244,145,137,187,226,225,246,180,234,80,247,70,138,255,101,136,104,40,171,160,172,141,126,178,21,228,141,98,181,126,194,137,243,5,57,125,34,61,117,163,220,159,66,42,64,76,63,192,23,56,210,149,136,35,252,93,160,145,73,135,17,127,32,33,93,97,21,212,128,254,82,122,64,95,65,139,117,136,237,27,0,0,255,255,3,0,254,4,156,71,100,164,241,118,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_color20
:array[0..344] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,32,73,68,65,84,120,1,204,147,49,14,194,48,12,69,3,101,132,19,112,7,118,196,196,198,130,88,152,216,80,71,38,14,211,145,27,176,117,129,123,112,5,78,192,92,169,255,135,56,117,66,26,1,83,35,65,236,111,251,213,113,27,99,134,182,70,169,134,154,166,57,65,223,166,98,208,234,162,40,170,56,22,128,28,224,24,39,193,223,161,248,137,248,28,246,197,197,3,160,7,57,200,62,1,49,128,172,181,174,128,30,166,65,181,78,214,54,64,31,199,20,24,98,27,230,90,144,235,102,165,139,181,141,228,131,246,197,70,221,13,182,237,106,226,196,5,246,151,36,252,176,151,200,229,204,42,1,253,3,225,236,248,2,236,115,191,2,113,30,44,138,59,165,46,154,128,150,16,202,76,242,89,158,44,133,106,127,208,30,139,144,130,48,230,244,25,204,220,175,3,233,54,5,174,246,28,132,49,35,71,227,55,196,233,219,111,130,129,104,77,35,95,187,119,58,246,104,104,223,222,157,76,87,189,29,73,173,159,17,160,182,171,30,88,31,232,42,173,249,43,66,1,16,125,
235,75,14,218,129,229,162,74,29,119,127,207,232,4,32,10,92,17,240,45,118,255,1,160,147,135,102,181,0,0,0,255,255,3,0,18,56,98,175,169,15,11,243,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_screen20
:array[0..234] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,178,73,68,65,84,120,1,98,96,24,108,128,17,228,160,191,127,255,250,1,169,6,32,54,4,98,82,192,121,160,226,6,102,102,230,77,76,80,93,141,64,186,11,40,192,72,10,6,233,1,98,144,94,6,152,65,6,64,3,86,128,4,72,1,80,61,6,32,61,48,131,72,209,143,85,237,168,65,88,131,5,69,112,240,134,209,5,96,234,142,64,113,43,17,28,168,158,11,32,165,44,80,245,205,64,186,22,40,177,28,202,39,150,2,25,210,13,82,12,14,35,96,10,93,7,196,134,64,12,207,34,32,73,100,62,136,141,69,12,164,103,25,72,156,106,129,13,182,5,100,34,12,0,189,119,21,200,214,130,241,113,208,59,129,46,241,192,33,55,220,132,1,0,0,0,255,255,3,0,246,110,31,228,81,130,38,51,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_home20
:array[0..278] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,222,73,68,65,84,120,1,204,82,1,14,131,48,8,172,235,94,59,223,163,191,109,54,142,112,13,34,142,44,217,146,153,104,41,119,156,87,104,107,255,246,44,239,12,141,49,30,130,111,198,89,123,239,187,228,158,216,75,124,168,189,27,233,180,56,145,213,192,77,114,39,30,19,169,144,23,129,11,144,77,132,238,88,63,215,219,140,44,200,68,0,153,32,221,197,178,118,16,186,18,97,149,23,51,46,161,54,27,86,137,204,10,9,50,174,10,101,128,47,204,226,88,195,163,161,137,58,222,172,40,203,185,99,234,0,56,53,52,17,227,189,156,74,38,102,57,29,128,58,226,136,5,128,171,165,122,193,131,136,241,244,122,208,17,242,28,177,198,248,196,62,16,192,143,163,123,246,136,156,184,106,239,36,89,30,185,18,138,194,151,251,223,8,89,79,244,175,62,70,194,239,125,76,139,217,205,38,86,173,31,221,187,74,236,251,248,11,0,0,255,255,3,0,22,67,101,163,190,145,21,74,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_folder20
:array[0..246] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,190,73,68,65,84,120,1,98,96,24,182,128,17,228,179,191,127,255,186,1,169,54,32,54,6,241,161,224,55,144,94,199,204,204,28,1,19,192,71,51,65,37,65,134,116,0,53,49,34,97,54,160,216,21,160,37,215,240,25,0,147,131,185,232,63,200,0,152,32,50,13,52,232,30,144,175,136,44,134,196,62,11,100,55,0,245,110,129,27,132,36,137,204,124,4,228,76,7,42,236,64,22,132,177,129,150,128,188,93,6,148,55,130,121,141,1,228,34,44,88,30,151,33,32,195,128,114,43,128,148,33,136,13,55,8,196,161,4,140,26,68,56,244,6,111,24,157,5,38,174,16,194,30,64,85,1,213,3,74,221,12,44,80,169,6,32,221,4,148,88,13,229,19,75,157,7,42,172,35,86,241,16,85,7,0,0,0,255,255,3,0,82,35,47,230,68,71,163,199,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_startmenu20
:array[0..351] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,1,39,73,68,65,84,120,1,204,146,203,77,195,80,16,69,77,12,17,235,52,144,22,178,165,136,20,72,69,236,17,91,122,72,3,150,50,103,146,99,174,140,3,155,44,50,210,211,252,238,156,55,207,242,48,220,209,158,96,77,211,244,94,110,95,103,19,231,197,120,28,199,183,210,124,94,243,231,242,28,108,188,184,225,171,52,71,134,177,37,40,161,106,172,93,38,126,64,212,15,20,151,66,7,184,209,120,77,211,47,90,106,214,132,174,254,23,44,123,198,191,54,19,196,55,81,132,199,204,217,202,56,253,252,33,249,216,88,66,136,25,204,143,237,112,234,168,245,179,9,180,53,129,32,52,130,50,22,212,28,97,75,16,117,65,250,212,10,204,39,83,187,159,245,91,235,135,252,46,36,55,231,217,86,222,55,215,15,185,43,205,169,114,183,172,176,77,253,80,154,87,87,183,168,103,232,191,39,168,133,218,75,173,193,0,41,212,51,144,150,245,6,209,116,109,188,16,55,50,87,35,76,208,12,201,6,113,10,140,241,128,114,200,94,214,152,239,11,105,98,14,41,78,144,26,
116,25,147,99,243,230,54,189,137,220,67,205,152,33,77,45,249,12,34,17,246,113,109,56,140,200,88,13,250,155,32,154,143,107,103,0,0,0,255,255,3,0,23,120,19,180,135,184,98,134,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_programs20
:array[0..136] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,80,73,68,65,84,120,1,98,96,24,182,128,17,228,179,191,127,255,230,1,41,95,168,47,55,51,51,51,79,34,85,156,9,170,57,20,72,115,64,49,136,13,3,68,139,179,64,117,240,192,116,162,209,164,138,163,105,31,72,238,104,96,211,49,244,71,3,155,142,129,61,248,172,2,0,0,0,255,255,3,0,228,44,52,12,39,114,223,9,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_desktop20
:array[0..248] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,192,73,68,65,84,120,1,98,96,24,5,132,66,128,17,164,224,239,223,191,218,64,42,26,136,19,65,124,18,192,124,160,218,165,204,204,204,87,153,160,154,64,134,240,2,177,11,80,80,146,24,12,82,11,213,3,210,203,0,51,8,228,146,25,32,147,65,130,196,0,168,218,25,64,181,96,95,192,12,98,32,197,16,152,69,200,122,224,6,193,36,201,165,7,177,65,208,36,64,146,207,144,245,176,32,233,220,3,148,64,226,146,198,132,133,209,103,160,54,162,210,16,80,221,9,96,108,73,130,104,144,30,32,6,3,152,65,107,128,188,12,100,167,66,229,49,40,160,33,129,80,193,26,144,30,32,6,165,110,6,112,22,1,49,128,134,180,1,169,16,32,6,165,112,98,193,124,160,193,85,196,42,30,233,234,0,0,0,0,255,255,3,0,77,122,39,152,137,107,226,43,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_disk20
:array[0..317] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,1,5,73,68,65,84,120,1,236,82,49,10,2,49,16,60,141,165,160,130,165,79,240,5,118,138,96,39,248,12,31,224,71,124,135,149,165,141,157,175,17,108,60,11,37,156,179,186,187,108,226,229,244,192,78,3,97,51,179,187,115,179,201,101,217,207,173,70,60,177,247,126,12,174,31,243,9,124,116,206,237,109,174,101,1,159,175,136,183,18,190,140,162,218,96,5,14,225,110,132,108,47,168,120,15,78,112,121,144,50,21,100,177,182,36,106,198,179,136,218,145,105,204,79,71,141,191,167,125,15,135,112,183,67,5,157,11,142,210,16,99,226,83,92,14,151,139,38,119,118,17,237,238,68,88,114,196,211,29,19,142,107,6,224,50,25,217,19,248,198,18,193,11,196,10,88,158,98,252,25,206,43,35,174,15,103,56,26,155,150,228,244,26,228,14,183,207,124,182,70,156,96,15,25,107,33,227,202,0,67,115,113,72,175,68,205,75,238,120,249,97,153,183,15,39,31,163,168,75,4,115,101,170,15,34,146,172,18,193,13,42,92,178,42,76,164,68,3,167,97,203,31,213,185,129,
59,0,0,0,255,255,3,0,112,20,57,33,64,180,23,104,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_removable20
:array[0..357] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,21,0,0,0,20,8,6,0,0,0,98,75,118,51,0,0,1,45,73,68,65,84,120,1,212,84,49,10,194,64,16,140,198,82,80,193,78,159,224,11,236,20,193,78,240,25,62,192,206,87,216,248,9,43,75,27,59,127,98,39,216,24,11,37,196,153,152,77,246,46,185,144,128,133,46,156,187,59,187,59,55,119,23,244,188,127,177,70,93,161,97,24,14,48,179,114,205,249,190,191,169,69,170,8,119,24,190,184,136,43,147,42,66,143,106,92,132,196,115,164,24,158,0,239,151,13,169,218,21,27,156,84,30,135,45,27,64,254,196,122,21,224,69,16,123,115,102,40,133,202,49,58,122,185,174,114,224,6,181,103,221,146,146,38,132,109,93,172,17,223,53,177,62,62,143,92,245,216,246,126,198,92,172,20,42,143,232,98,28,37,94,134,236,156,184,11,11,160,118,201,134,38,127,96,93,107,117,172,92,234,196,121,231,204,237,158,33,176,216,228,248,161,0,223,240,66,250,0,89,4,249,51,92,197,28,241,90,145,167,143,169,48,94,1,77,106,198,149,200,157,30,62,61,222,22,126,138,53,74,114,163,57,193,156,14,162,22,44,138,82,190,30,
9,228,143,162,240,163,70,93,63,166,108,72,111,152,144,6,6,234,78,132,200,221,129,138,144,238,17,251,165,157,89,209,69,156,83,156,141,252,106,244,6,0,0,255,255,3,0,94,56,70,36,66,203,159,165,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_cd20
:array[0..371] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,1,59,73,68,65,84,120,1,220,147,33,78,4,65,16,69,23,6,185,248,77,192,114,1,36,134,4,131,89,129,68,34,209,236,26,238,0,23,0,131,68,174,69,114,1,78,1,1,133,66,96,38,225,191,162,186,243,167,51,129,149,132,74,106,170,234,207,175,223,213,61,61,147,201,95,177,141,177,65,250,190,223,17,126,61,242,110,209,117,221,75,139,15,68,154,230,43,145,167,214,240,161,124,153,245,64,172,138,152,0,205,51,107,110,211,55,1,136,85,161,45,99,48,62,2,123,134,141,165,219,201,131,127,10,97,147,71,78,65,186,47,135,244,155,191,66,46,125,33,162,26,85,166,104,155,159,132,29,201,137,254,238,70,53,124,250,190,39,33,145,205,229,78,124,84,29,123,207,72,125,144,254,169,120,41,15,243,51,153,22,48,99,61,60,141,189,16,198,170,52,187,117,20,46,194,20,110,49,174,9,80,159,59,65,121,44,236,34,183,2,47,228,239,73,60,83,12,161,140,212,62,201,157,234,184,55,113,79,242,148,25,247,89,190,174,237,138,24,119,197,47,219,189,64,86,62,89,
67,101,37,206,82,191,64,220,19,223,78,57,60,132,142,127,16,122,64,64,14,63,172,78,66,101,219,162,68,236,144,196,140,207,92,191,90,193,7,34,5,108,196,10,92,98,253,103,10,240,207,226,23,0,0,0,255,255,3,0,63,130,86,153,110,36,15,95,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_frame20
:array[0..182] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,126,73,68,65,84,120,1,98,96,24,182,128,17,228,179,191,127,255,106,2,169,105,100,250,50,139,153,153,249,58,11,84,243,52,32,199,145,28,131,128,142,216,15,212,231,8,51,8,108,6,137,46,3,187,4,102,57,138,65,64,65,162,93,6,115,9,204,32,38,24,131,82,122,212,32,194,33,56,248,194,8,61,29,101,65,211,7,97,191,48,48,100,33,43,66,49,8,148,103,128,146,100,101,21,152,65,164,184,4,217,33,32,54,138,203,208,37,135,1,31,0,0,0,255,255,3,0,78,12,30,11,1,60,104,240,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_background20
:array[0..345] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,1,33,73,68,65,84,120,1,204,147,177,14,1,65,16,134,93,206,27,168,189,131,87,16,45,157,40,105,37,10,57,18,13,157,40,69,20,18,45,165,40,245,94,193,59,168,181,104,46,49,187,246,191,140,181,99,55,91,217,194,252,55,243,207,119,123,187,35,41,69,174,60,207,55,118,107,154,166,131,196,78,134,60,19,108,233,242,17,112,92,118,21,2,114,79,201,243,31,64,250,180,57,125,246,196,181,203,168,51,4,136,160,67,104,122,201,90,233,15,32,25,106,148,91,193,68,49,35,227,133,61,123,101,1,100,176,19,235,106,26,29,12,214,64,6,83,253,7,6,132,236,24,225,5,3,120,166,134,29,186,133,216,99,121,17,204,129,91,214,224,147,125,99,248,2,3,216,242,17,132,250,136,229,53,28,192,6,43,196,202,25,77,68,29,255,148,71,32,101,97,124,83,135,95,231,0,188,59,12,60,133,217,204,40,169,180,232,7,80,218,33,46,170,56,124,26,49,64,213,11,113,57,74,235,133,51,172,34,97,226,222,196,2,196,235,214,220,118,81,163,51,188,2,88,49,201,227,47,16,26,17,
45,112,155,128,55,0,213,96,171,229,220,209,187,36,255,2,172,110,89,118,69,86,94,0,0,0,255,255,3,0,8,105,98,52,29,9,221,233,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_squircle20
:array[0..163] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,107,73,68,65,84,120,1,98,96,24,86,128,17,230,155,191,127,255,106,1,217,147,97,124,34,232,92,102,102,230,107,32,117,96,67,96,6,0,5,157,137,208,12,86,2,212,179,23,200,0,27,196,4,213,52,153,20,3,64,122,160,234,193,46,135,25,2,53,139,60,106,212,16,204,112,27,13,19,220,97,146,11,77,198,152,42,112,136,192,146,61,72,154,42,25,16,135,61,67,85,24,0,0,0,255,255,3,0,251,28,29,26,29,91,32,70,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_diamond20
:array[0..223] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,167,73,68,65,84,120,1,220,211,75,14,128,32,12,4,80,148,75,201,253,23,120,41,162,29,67,9,96,63,186,51,146,24,5,134,71,49,26,194,87,218,98,21,82,74,217,104,62,211,149,98,140,187,150,93,181,9,6,104,49,54,202,181,47,198,69,100,2,130,7,221,144,25,224,173,45,104,64,52,192,131,26,226,1,22,116,33,79,1,13,226,74,114,61,51,231,220,59,191,35,4,25,73,84,205,225,174,236,2,53,159,48,212,62,182,55,71,98,128,170,185,62,192,134,64,124,2,205,192,80,9,58,104,22,36,1,88,51,84,130,1,52,9,210,0,228,69,100,134,44,192,68,122,136,158,205,191,24,217,31,181,19,0,0,255,255,3,0,94,245,113,14,183,163,56,157,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_circle20
:array[0..269] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,213,73,68,65,84,120,1,220,147,209,13,194,48,12,68,3,89,136,41,88,168,31,204,208,143,46,212,41,88,40,18,190,196,103,217,81,136,34,196,7,162,31,77,98,223,61,93,91,55,165,95,185,46,163,32,165,148,187,212,31,131,222,158,115,62,251,122,128,116,230,77,12,79,26,164,119,147,253,161,231,0,51,136,3,4,51,33,92,29,204,64,87,54,101,69,252,41,0,90,77,183,169,30,165,84,33,154,130,130,218,152,221,248,152,244,49,73,77,49,51,14,122,150,134,144,229,20,132,49,13,206,6,97,243,147,245,187,16,253,116,203,65,188,158,73,118,113,115,144,86,65,208,195,215,222,137,188,164,58,202,158,62,35,81,71,31,147,192,83,211,80,240,14,162,125,75,1,157,141,61,14,34,240,63,94,152,94,103,134,212,70,30,135,0,65,1,87,7,107,197,118,15,102,223,248,163,253,11,0,0,255,255,3,0,87,155,80,26,165,44,222,100,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_square20
:array[0..125] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,69,73,68,65,84,120,1,98,96,24,86,128,17,228,155,191,127,255,238,37,215,87,204,204,204,206,44,48,205,32,14,140,77,44,13,179,156,137,88,13,248,212,141,26,130,25,58,163,97,50,152,195,4,158,119,96,249,0,211,177,35,78,4,0,0,0,255,255,3,0,178,61,11,212,27,172,116,79,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_solid20
:array[0..111] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,55,73,68,65,84,120,1,98,96,24,86,128,17,228,155,191,127,255,238,37,215,87,204,204,204,206,76,228,106,70,214,55,106,8,114,104,64,216,163,97,50,26,38,152,33,48,236,69,0,0,0,0,255,255,3,0,121,75,4,28,124,113,211,160,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_transparent20
:array[0..160] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,104,73,68,65,84,120,1,98,96,24,86,128,17,217,55,127,255,254,221,139,204,39,134,205,204,204,236,204,68,140,66,66,106,88,64,10,200,113,1,178,193,212,115,9,178,169,32,54,200,159,232,98,200,124,116,151,211,206,37,200,54,193,92,133,44,134,236,42,16,155,42,46,25,53,4,61,88,25,24,192,41,22,83,24,33,130,47,86,96,170,168,18,176,48,195,134,9,13,0,0,0,255,255,3,0,229,99,23,64,12,220,162,13,0,0,0,0,73,69,78,68,174,66,96,130);

mtep__mid20//11aug2025
:array[0..213] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,157,73,68,65,84,120,1,236,82,237,10,128,32,16,211,236,121,237,89,234,125,165,54,227,228,56,206,80,232,95,9,162,110,231,54,63,66,248,155,189,129,104,129,222,186,148,114,122,92,74,41,46,30,49,139,77,137,208,85,119,49,171,199,65,212,93,128,135,49,131,59,12,159,41,186,18,196,100,211,36,207,79,210,96,220,96,235,40,28,122,73,92,87,212,187,73,234,157,208,65,119,170,235,181,36,240,48,214,142,38,169,177,81,175,147,84,12,194,247,19,123,14,130,97,163,8,180,116,26,195,252,157,36,246,5,218,175,100,76,186,140,52,247,179,205,8,140,152,124,177,230,2,0,0,255,255,3,0,247,60,53,61,38,186,1,31,0,0,0,0,73,69,78,68,174,66,96,130);

mtep__asis20
:array[0..331] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,1,19,73,68,65,84,120,1,204,83,193,13,131,48,12,76,75,247,233,16,25,129,45,250,100,144,62,217,130,17,58,68,7,66,234,157,155,179,156,0,2,164,62,106,9,18,206,190,139,237,152,148,126,96,151,168,49,207,243,29,223,207,136,97,63,117,93,55,54,88,245,217,138,188,224,29,64,122,51,170,17,117,49,224,15,184,123,197,222,24,188,101,20,3,97,128,159,217,245,216,51,148,100,154,240,124,253,126,251,123,194,174,42,135,66,120,114,33,233,244,76,92,172,74,4,142,205,218,73,194,147,185,138,172,181,18,41,181,202,119,120,117,145,216,172,195,236,18,104,34,65,32,173,165,187,39,170,76,98,199,247,56,11,191,137,176,97,240,216,205,32,43,14,220,41,107,135,77,67,68,17,31,186,168,136,67,56,144,52,155,19,38,160,114,12,5,48,54,89,137,96,254,240,210,60,81,40,85,34,10,162,88,217,91,144,112,149,90,252,158,233,170,136,72,8,110,7,139,211,204,44,170,91,92,21,209,137,18,227,42,44,100,233,238,170,177,66,75,243,84,138,255,75,16,224,
45,46,108,235,47,182,206,151,104,175,125,193,254,59,224,3,0,0,255,255,3,0,142,70,95,135,139,82,104,152,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_menu20
:array[0..136] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,80,73,68,65,84,120,1,98,96,24,5,35,33,4,24,65,158,252,251,247,111,39,144,42,3,226,46,102,102,230,114,98,197,152,64,10,129,0,164,17,4,96,52,50,27,167,24,76,51,88,39,169,4,76,115,23,84,35,140,6,113,97,108,24,141,75,12,170,117,148,26,174,33,0,0,0,0,255,255,3,0,182,6,21,8,172,144,104,189,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_tick20
:array[0..215] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,159,73,68,65,84,120,1,236,146,91,14,128,32,12,4,81,188,173,30,7,143,75,34,211,180,72,76,73,236,183,54,225,181,184,67,133,166,244,199,194,21,212,90,247,54,20,189,142,35,231,124,62,52,182,68,215,111,250,176,234,12,243,161,205,64,162,53,24,135,176,87,20,218,166,119,24,32,113,42,237,222,74,162,177,86,221,133,116,192,104,244,230,51,200,107,192,44,147,16,224,9,97,29,6,96,26,35,12,24,158,151,75,141,101,48,154,237,197,94,103,224,153,201,96,163,35,188,34,65,227,164,153,25,159,1,164,72,16,90,200,191,233,72,245,89,101,186,165,44,142,143,119,23,0,0,0,255,255,3,0,60,195,69,197,202,122,239,214,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_untick20
:array[0..137] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,6,0,0,0,20,8,6,0,0,0,174,210,76,216,0,0,0,81,73,68,65,84,120,1,98,96,160,61,96,4,89,241,247,239,223,108,32,53,5,106,93,14,51,51,243,84,38,40,7,36,152,3,197,96,5,48,9,6,144,42,16,134,42,100,128,75,192,4,96,244,224,148,96,129,57,15,234,123,24,151,1,38,1,242,53,60,72,224,178,52,102,0,0,0,0,255,255,3,0,161,90,13,38,152,112,123,37,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_help20
:array[0..269] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,20,8,6,0,0,0,185,240,220,17,0,0,0,213,73,68,65,84,120,1,98,96,24,116,128,17,217,69,127,255,254,77,0,242,231,35,139,1,217,61,204,204,204,165,48,49,176,6,160,66,53,160,192,1,32,230,5,226,64,160,130,61,64,154,1,73,252,44,80,204,23,36,198,4,34,160,224,11,144,134,43,6,137,1,21,221,2,82,14,64,108,12,181,29,174,225,35,80,240,57,16,99,0,168,166,179,64,137,96,144,36,138,31,48,84,67,5,128,166,119,3,153,26,32,103,177,224,82,4,19,7,42,22,7,178,157,128,120,31,72,12,217,15,32,62,10,128,42,222,6,20,148,4,226,217,32,73,172,54,32,41,52,2,170,217,2,116,138,49,72,49,8,96,213,0,20,47,1,226,103,200,10,65,138,65,0,175,147,32,74,232,77,98,196,3,52,204,65,126,0,129,115,64,236,5,244,203,75,48,15,72,96,243,195,85,152,228,16,161,1,0,0,0,255,255,3,0,90,148,51,132,67,218,172,118,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_clock20//30nov2025
:array[0..284] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,228,73,68,65,84,120,1,220,147,81,18,194,32,12,68,81,60,166,61,29,94,147,209,108,38,155,217,32,117,252,116,236,15,176,155,188,46,208,182,246,43,207,101,23,100,206,121,55,125,108,188,163,247,254,88,245,2,209,102,43,46,30,26,205,127,6,160,192,174,164,18,128,102,5,72,99,19,111,68,189,183,39,196,86,67,155,9,223,141,81,151,219,117,136,82,119,77,103,26,251,152,228,235,20,4,106,26,66,112,104,184,145,242,80,227,168,166,106,55,49,176,199,245,250,184,111,28,36,231,126,192,86,155,235,76,98,226,33,64,78,169,225,74,253,214,98,27,240,233,181,132,152,185,166,192,27,93,227,72,50,70,213,8,57,44,46,63,36,173,101,244,162,97,17,245,158,198,33,74,125,171,254,32,176,143,73,80,122,154,102,229,104,10,120,229,255,48,51,127,60,123,139,123,104,208,121,0,203,191,83,32,124,163,194,168,237,154,23,239,95,150,47,0,0,0,255,255,3,0,118,196,96,151,198,228,39,155,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_alert20//30nov2025
:array[0..241] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,185,73,68,65,84,120,1,196,81,65,18,132,48,8,115,237,62,83,95,167,223,236,236,66,167,113,2,82,188,56,234,37,8,33,73,219,105,122,251,251,100,1,106,173,63,157,151,82,134,188,121,36,32,203,11,102,92,163,7,28,10,8,97,83,231,238,190,97,193,99,40,16,57,70,61,21,11,5,164,223,220,225,150,165,248,130,4,100,39,169,205,37,234,76,196,118,112,21,163,4,198,29,228,81,10,35,192,238,88,244,232,57,70,64,200,161,59,68,162,20,135,128,87,198,82,132,204,61,4,174,220,33,228,83,156,94,1,68,197,78,230,214,169,110,2,28,137,25,210,55,207,232,102,237,73,113,132,244,242,120,81,107,62,198,61,71,16,209,21,113,189,91,242,191,38,179,7,71,127,0,0,0,255,255,3,0,4,176,66,72,82,15,40,196,0,0,0,0,73,69,78,68,174,66,96,130);

tep_copy20
:array[0..276] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,220,73,68,65,84,120,1,212,146,193,13,194,48,12,69,3,98,26,88,130,142,194,137,13,24,130,13,56,49,10,83,148,117,74,190,165,135,108,203,81,123,132,72,149,99,251,255,23,167,109,107,191,178,118,26,100,233,207,116,159,21,194,122,221,78,214,15,197,148,72,96,162,115,7,60,46,199,208,190,62,223,150,175,129,4,216,7,103,74,4,174,38,76,178,118,240,5,78,103,42,242,12,202,211,13,175,35,184,32,0,57,12,48,32,1,202,73,48,140,162,93,179,205,11,160,0,25,157,202,233,244,201,237,154,253,11,6,8,205,60,1,102,213,253,30,125,128,120,129,12,136,136,170,177,188,54,64,42,177,76,222,0,196,199,0,201,98,160,68,111,244,90,131,232,45,79,253,109,123,145,223,123,131,175,179,255,78,194,231,162,161,200,79,182,105,18,111,172,246,155,39,169,204,107,215,84,223,126,249,202,252,191,181,15,0,0,0,255,255,3,0,148,64,90,250,14,199,138,89,0,0,0,0,73,69,78,68,174,66,96,130);

tep_selectall20
:array[0..198] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,142,73,68,65,84,120,1,98,96,24,212,128,17,228,186,3,7,14,48,52,156,18,253,143,203,165,13,102,175,193,234,64,242,14,14,14,12,96,142,67,215,213,255,51,19,181,176,234,73,159,127,13,44,14,211,8,210,196,132,85,37,154,32,200,64,100,151,176,32,203,195,76,133,137,129,20,131,48,76,28,170,145,17,175,77,48,197,48,205,48,195,240,106,2,41,130,105,132,105,0,209,4,53,129,20,161,107,36,74,19,72,35,50,24,228,154,80,226,9,20,180,196,0,162,210,30,204,32,80,82,2,37,163,225,8,0,0,0,0,255,255,3,0,127,107,42,253,243,238,171,12,0,0,0,0,73,69,78,68,174,66,96,130);

tep_blank20
:array[0..20] of byte=(
84,69,65,49,35,20,0,0,0,20,0,0,0,245,150,0,250,245,150,0,150);

tep_clock20
:array[0..247] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,191,73,68,65,84,120,1,212,83,91,14,3,33,8,196,210,251,223,216,186,140,130,32,154,38,109,250,177,37,217,21,6,25,7,31,68,119,177,210,133,180,131,156,210,118,180,149,49,63,78,23,228,25,227,238,107,113,173,175,45,197,70,156,200,86,37,50,41,23,51,51,213,90,23,66,230,7,145,17,9,131,68,106,7,2,75,229,177,47,100,170,36,233,36,121,230,7,177,110,212,222,134,113,156,218,241,28,52,148,242,19,37,147,164,111,150,45,161,35,84,192,48,198,111,96,179,148,238,214,142,156,249,169,29,200,206,119,4,24,44,222,21,111,108,228,190,250,59,201,27,53,153,57,170,64,206,73,16,41,81,108,45,251,153,0,101,235,219,1,98,22,174,181,65,243,189,76,64,28,61,223,8,253,185,127,1,0,0,255,255,3,0,145,250,61,134,115,149,81,24,0,0,0,0,73,69,78,68,174,66,96,130);

tep_alert20
:array[0..226] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,170,73,68,65,84,120,1,212,82,219,13,128,48,8,4,227,80,110,224,88,214,177,220,192,173,80,80,154,62,64,107,252,48,146,152,214,2,119,87,122,0,95,7,138,0,178,101,4,36,201,4,194,163,174,44,219,79,187,242,236,233,127,239,53,48,251,68,235,145,222,247,158,138,215,10,204,25,100,236,167,196,25,7,168,84,220,206,0,23,0,254,46,162,186,130,197,206,253,60,15,125,149,20,175,2,72,147,45,251,12,192,99,87,32,75,69,6,160,133,79,214,8,112,199,174,160,165,10,215,72,210,64,163,246,185,107,84,96,86,52,60,163,24,41,64,98,219,20,73,61,96,40,17,99,1,226,235,43,68,0,70,252,103,108,0,0,0,255,255,3,0,172,59,64,55,101,137,196,185,0,0,0,0,73,69,78,68,174,66,96,130);

tep_left20
:array[0..157] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,101,73,68,65,84,120,1,98,100,248,223,192,64,77,192,2,51,44,148,81,235,63,140,141,78,175,254,127,141,17,93,12,23,31,108,32,200,48,109,134,80,92,106,24,24,24,87,255,39,214,80,38,220,166,144,39,51,106,32,121,225,134,172,107,52,12,145,67,131,60,246,104,24,146,23,110,200,186,6,127,24,50,194,74,108,106,21,176,112,3,145,195,129,18,54,0,0,0,255,255,3,0,145,152,18,210,33,65,43,52,0,0,0,0,73,69,78,68,174,66,96,130);

tep_right20
:array[0..155] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,99,73,68,65,84,120,1,98,100,248,223,192,64,77,192,66,138,97,161,140,90,255,113,169,95,253,255,26,35,72,142,104,3,65,134,105,51,132,226,50,143,129,129,113,245,127,144,161,76,184,85,144,39,51,106,32,121,225,134,172,107,52,12,145,67,131,60,246,104,24,146,23,110,200,186,6,127,24,50,146,82,98,19,83,192,146,100,32,114,88,225,98,3,0,0,0,255,255,3,0,147,110,18,210,132,41,165,137,0,0,0,0,73,69,78,68,174,66,96,130);

tep_top20
:array[0..151] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,95,73,68,65,84,120,1,98,100,248,223,192,64,77,192,2,51,44,148,81,235,63,140,77,14,189,250,255,53,70,144,62,176,129,32,195,180,25,66,201,49,7,161,135,113,245,127,144,161,76,8,17,234,176,70,13,164,60,28,169,30,134,140,176,132,77,173,116,8,55,144,114,207,66,76,160,186,151,71,13,164,60,106,70,195,144,242,48,4,0,0,0,255,255,3,0,43,217,18,210,138,42,117,172,0,0,0,0,73,69,78,68,174,66,96,130);

tep_bottom20
:array[0..151] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,95,73,68,65,84,120,1,98,100,248,223,192,64,77,192,68,77,195,64,102,141,26,72,121,136,142,134,33,229,97,200,2,51,34,148,81,235,63,140,77,14,189,250,255,53,70,144,62,176,129,32,195,180,25,66,201,49,7,161,135,113,245,127,144,161,163,177,140,8,18,114,89,131,63,12,25,97,37,54,181,210,33,220,64,114,195,12,93,31,0,0,0,255,255,3,0,69,135,18,210,80,191,200,164,0,0,0,0,73,69,78,68,174,66,96,130);

tep_frame20
:array[0..200] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,144,73,68,65,84,120,1,236,148,219,14,128,32,8,134,161,245,40,190,167,245,156,245,46,36,109,56,49,114,131,213,69,91,222,32,7,63,255,225,1,224,161,129,204,33,34,88,17,40,202,92,0,241,4,45,5,21,133,100,98,10,194,220,2,114,235,56,231,147,179,94,151,23,53,18,80,138,36,184,111,53,47,161,139,77,137,84,81,72,81,15,225,93,76,69,178,189,181,64,114,189,13,41,234,33,236,255,32,171,43,58,246,126,143,60,71,127,123,106,94,136,13,106,222,143,238,194,216,171,55,155,191,131,113,233,215,178,7,0,0,0,255,255,3,0,3,201,21,71,139,243,189,13,0,0,0,0,73,69,78,68,174,66,96,130);

tep_wine20
:array[0..395] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,1,83,73,68,65,84,120,1,148,147,205,117,195,32,12,199,69,95,158,119,160,99,112,73,119,112,14,246,14,189,36,59,52,135,120,135,228,194,14,205,33,30,163,140,97,118,240,37,213,95,24,130,191,210,20,63,131,132,248,73,66,128,34,180,251,93,134,243,229,210,107,173,69,142,157,115,142,154,211,169,136,122,26,149,162,13,148,175,227,177,55,198,144,41,203,100,123,69,16,88,64,134,71,205,123,242,248,57,50,85,213,200,20,149,55,8,178,136,23,166,54,128,174,177,228,108,155,166,167,130,192,135,253,190,136,14,226,216,54,77,136,202,142,74,245,222,79,65,232,146,54,4,103,109,216,51,167,233,91,78,85,50,241,164,249,91,107,18,25,70,239,194,254,100,143,12,106,194,47,22,233,151,186,4,219,238,167,0,168,53,23,46,11,150,137,51,62,193,18,3,133,146,136,207,144,135,143,17,108,187,142,163,115,213,13,224,224,32,59,131,7,53,72,35,88,230,74,67,14,14,152,13,224,122,22,74,128,225,122,70,215,159,187,93,207,30,152,71,217,136,80,143,
104,75,99,188,158,105,98,16,236,237,38,139,207,124,109,167,182,92,159,167,157,89,15,75,15,34,179,63,133,177,238,127,5,203,60,67,92,47,23,209,159,145,241,190,241,206,39,62,69,93,172,118,92,248,125,189,246,107,161,235,143,186,72,15,35,2,24,81,101,205,231,189,4,214,219,106,126,108,57,252,170,252,11,0,0,255,255,3,0,80,46,126,52,213,204,149,163,0,0,0,0,73,69,78,68,174,66,96,130);

tep_zoom20
:array[0..340] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,1,28,73,68,65,84,120,1,172,147,61,14,195,32,12,133,73,85,113,160,76,81,39,14,147,169,103,202,97,152,170,76,57,16,83,121,32,39,54,255,74,203,226,128,237,207,230,197,76,202,47,107,45,76,182,140,121,57,126,104,237,71,243,125,237,219,24,163,158,37,39,1,157,219,132,91,235,53,20,26,41,144,129,1,189,128,171,0,227,252,56,222,106,89,156,235,193,39,100,146,20,23,84,2,5,93,197,91,248,238,125,94,89,26,72,241,160,36,64,247,125,68,194,88,20,221,147,100,196,224,246,4,95,135,173,110,41,170,31,19,164,80,202,133,110,231,89,12,1,81,26,118,83,37,73,132,20,141,236,91,174,130,20,183,56,89,82,0,227,239,250,17,242,163,52,242,243,34,3,177,37,25,168,66,214,241,8,124,36,230,4,83,215,168,216,74,36,31,110,136,28,234,48,181,39,24,142,30,156,67,17,223,154,99,241,242,16,140,69,9,233,131,65,151,165,149,118,142,113,43,130,41,153,10,208,158,3,218,190,14,152,128,53,91,131,255,252,64,248,13,80,156,23,106,74,81,235,52,61,
231,192,232,211,90,76,69,154,48,186,79,59,71,222,95,192,0,165,240,47,0,0,0,255,255,3,0,242,182,132,34,182,127,74,115,0,0,0,0,73,69,78,68,174,66,96,130);

tep_sizeto20
:array[0..216] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,160,73,68,65,84,120,1,220,211,65,10,128,32,16,5,80,139,232,64,182,241,114,174,188,156,155,60,80,155,114,132,31,105,42,141,185,136,132,24,197,153,231,100,36,196,215,198,64,13,237,254,89,180,221,90,154,91,141,154,9,9,144,108,68,112,176,243,216,136,197,219,56,1,176,90,98,202,138,202,184,144,223,173,163,44,132,83,56,173,221,32,32,136,79,177,8,74,139,211,117,13,141,32,186,112,92,250,117,14,160,6,71,16,10,106,177,132,157,159,63,45,46,21,80,30,237,161,115,212,101,161,52,9,201,192,115,251,236,87,203,33,116,16,11,42,33,4,117,251,251,9,251,233,56,0,0,0,255,255,3,0,238,247,45,171,215,127,186,27,0,0,0,0,73,69,78,68,174,66,96,130);

tep_upper20
:array[0..216] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,160,73,68,65,84,120,1,98,96,24,121,128,17,228,229,63,127,254,128,125,158,33,123,230,23,182,32,152,241,216,132,13,93,156,133,133,133,129,9,93,144,20,62,138,102,144,13,200,182,192,216,184,92,132,162,153,20,91,65,106,49,52,227,178,5,155,56,134,102,152,237,48,39,195,104,152,56,50,141,83,51,178,34,92,108,188,81,53,237,249,86,12,125,76,127,234,193,209,6,138,42,22,100,89,108,138,145,229,209,217,112,155,255,177,52,130,19,8,204,100,116,133,32,62,178,26,144,205,96,205,191,24,106,49,82,22,178,33,48,77,200,6,178,49,52,179,81,20,96,200,134,141,20,54,0,0,0,255,255,3,0,186,53,51,179,78,52,65,103,0,0,0,0,73,69,78,68,174,66,96,130);

tep_lower20
:array[0..200] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,144,73,68,65,84,120,1,236,80,209,14,128,32,8,188,28,243,175,91,107,253,181,99,174,184,134,161,171,214,7,228,3,114,112,119,10,192,127,184,129,201,162,170,18,200,90,11,147,155,160,75,202,86,22,17,36,239,191,9,72,14,134,226,34,119,114,28,239,209,176,137,156,52,18,188,30,239,38,170,171,112,158,56,84,70,68,151,140,34,23,88,57,45,202,129,45,63,215,3,88,63,26,180,69,140,2,195,118,220,176,160,121,129,43,47,243,195,63,78,93,23,243,134,204,151,226,151,58,198,1,222,122,35,247,199,95,54,176,3,0,0,255,255,3,0,2,226,42,134,150,135,167,30,0,0,0,0,73,69,78,68,174,66,96,130);

tep_name20
:array[0..234] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,21,0,0,0,20,8,6,0,0,0,98,75,118,51,0,0,0,178,73,68,65,84,120,1,236,83,209,10,128,32,12,52,25,253,117,68,191,29,35,226,140,139,149,58,49,234,173,65,53,111,237,118,155,26,194,111,111,79,96,0,161,170,118,241,110,178,172,72,136,58,143,247,68,17,9,114,7,177,94,100,75,73,240,103,141,89,34,112,207,162,23,124,26,203,72,169,146,10,185,238,41,80,108,191,135,128,243,69,14,103,124,81,90,83,85,195,45,33,72,185,190,144,34,0,99,235,252,30,104,254,134,50,62,54,90,108,191,166,204,38,122,254,169,180,69,212,138,219,34,153,210,82,203,61,132,32,79,55,106,10,171,123,216,45,41,138,114,67,172,58,248,152,47,110,212,217,62,192,146,74,15,231,17,194,63,191,125,59,129,29,0,0,255,255,3,0,13,11,67,31,187,178,232,82,0,0,0,0,73,69,78,68,174,66,96,130);

tep_eye20
:array[0..284] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,228,73,68,65,84,120,1,220,146,193,13,194,48,12,69,83,132,50,19,71,238,76,66,39,96,132,78,80,38,225,206,145,153,124,1,127,43,182,236,198,45,234,13,17,169,114,226,126,191,252,56,41,229,87,198,32,70,222,231,224,135,238,19,249,68,189,222,170,95,135,249,240,44,199,144,224,133,0,198,71,72,83,153,104,11,20,32,6,152,47,1,82,24,186,5,58,168,218,3,116,87,68,153,3,10,208,226,152,90,43,61,161,249,69,16,21,22,163,40,3,102,57,129,112,79,204,137,82,87,197,42,72,98,7,81,251,18,147,130,44,213,65,32,218,3,128,94,32,186,251,90,243,190,29,49,60,54,47,198,14,54,252,187,105,205,183,127,220,216,0,193,15,3,153,138,39,237,138,45,229,65,217,237,216,209,80,216,62,203,41,101,241,102,58,39,170,203,98,231,18,142,198,83,77,111,39,3,32,215,57,106,194,93,144,0,242,125,105,176,63,9,31,0,0,0,255,255,3,0,46,162,119,196,13,97,230,90,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_panel20
:array[0..152] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,96,73,68,65,84,120,1,98,96,24,242,128,17,228,131,134,255,12,12,181,255,254,2,73,226,65,51,19,51,99,3,80,55,216,128,191,127,255,254,7,9,16,175,29,98,33,51,51,51,35,19,41,154,176,169,29,53,128,129,129,226,48,128,71,35,182,16,38,36,54,26,141,144,16,2,199,2,169,249,0,164,149,28,61,132,34,101,128,228,1,0,0,0,255,255,3,0,84,105,19,44,60,136,247,233,0,0,0,0,73,69,78,68,174,66,96,130);

tep_prev20
:array[0..238] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,182,73,68,65,84,120,1,212,211,205,13,128,32,12,6,80,48,94,220,195,163,46,227,160,46,163,71,247,224,230,207,135,129,104,41,69,148,139,36,106,128,242,176,13,40,85,176,105,107,109,178,56,141,141,141,232,7,115,198,115,225,199,76,197,141,95,199,0,117,109,50,204,46,17,163,114,32,104,81,44,23,2,86,227,69,27,7,33,85,140,211,88,215,239,149,209,193,159,113,144,91,0,144,123,220,252,13,147,32,183,64,250,122,236,43,132,77,44,86,2,242,24,14,227,188,172,82,6,143,230,124,154,37,64,143,97,235,175,96,112,206,0,198,106,152,42,69,244,162,83,16,16,54,138,22,79,186,232,111,82,190,213,140,238,154,11,6,53,227,64,164,76,199,255,213,223,1,0,0,255,255,3,0,175,137,73,164,145,57,32,130,0,0,0,0,73,69,78,68,174,66,96,130);

tep_next20
:array[0..229] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,173,73,68,65,84,120,1,204,211,65,18,64,48,12,5,208,232,216,184,135,37,151,113,79,46,195,210,61,236,208,132,204,100,66,70,104,23,186,97,210,120,126,171,0,50,142,130,172,205,22,199,161,162,217,182,91,142,94,171,53,206,6,107,78,214,155,58,0,163,178,174,239,93,24,62,228,1,221,152,7,164,125,24,251,99,95,116,108,6,116,125,154,87,184,236,97,148,74,110,196,101,120,7,47,89,131,126,65,189,137,65,89,254,140,33,162,193,36,76,131,201,152,252,24,73,152,132,48,229,103,76,67,136,101,61,103,132,193,195,143,46,207,224,93,34,76,133,177,94,45,211,132,72,123,129,61,65,232,185,146,121,160,51,220,79,47,59,0,0,0,255,255,3,0,220,45,73,197,18,47,183,107,0,0,0,0,73,69,78,68,174,66,96,130);

tep_up20
:array[0..194] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,138,73,68,65,84,120,1,236,210,57,18,128,32,12,5,80,98,235,93,244,254,199,208,187,80,199,40,131,162,100,33,14,99,37,5,20,124,30,75,8,161,99,131,195,66,93,196,117,68,152,98,202,74,81,154,53,177,29,202,235,85,208,194,74,200,4,53,140,131,84,80,194,52,72,4,57,172,5,98,193,39,230,129,42,176,196,222,64,55,48,99,184,92,229,207,1,239,8,115,132,193,187,72,203,211,225,168,157,223,50,69,91,174,92,125,96,146,186,158,236,199,82,49,60,125,215,55,243,108,252,109,118,3,0,0,255,255,3,0,63,178,49,25,191,8,183,207,0,0,0,0,73,69,78,68,174,66,96,130);

tep_upone20
:array[0..339] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,1,27,73,68,65,84,120,1,196,145,189,17,131,48,12,133,149,92,142,29,156,34,67,184,201,16,84,236,64,197,14,84,236,64,197,14,84,12,145,198,99,196,59,164,73,244,12,178,197,143,211,226,59,35,217,214,231,247,140,136,206,26,23,8,127,255,168,223,91,250,188,59,42,182,37,0,175,219,77,189,6,136,181,68,125,134,60,171,12,192,90,27,235,157,115,33,23,23,89,229,45,8,10,23,97,106,23,81,249,213,207,22,81,88,121,124,231,113,164,142,19,207,255,225,134,4,160,173,123,164,97,140,67,35,41,85,108,87,95,160,109,7,56,86,46,137,190,136,186,116,209,182,238,16,150,34,167,28,96,15,14,94,189,11,29,160,134,138,93,171,60,219,244,211,20,166,45,219,149,101,94,145,118,181,82,6,100,202,82,132,67,68,139,160,24,98,91,175,206,146,178,247,11,104,98,1,92,200,144,159,134,167,60,217,50,246,35,156,10,83,159,26,63,195,80,237,13,171,43,112,5,139,130,142,98,121,100,51,222,13,81,81,106,210,155,141,178,203,111,199,0,196,212,14,10,135,252,
137,176,97,88,183,6,239,122,72,85,38,70,216,77,93,86,33,195,158,184,253,3,0,0,255,255,3,0,85,47,102,247,7,226,95,13,0,0,0,0,73,69,78,68,174,66,96,130);

tep_fav20
:array[0..312] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,1,0,73,68,65,84,120,1,204,147,203,13,194,64,12,68,55,8,209,3,109,228,2,109,208,3,157,208,70,122,72,27,228,146,54,232,129,11,100,130,6,6,203,235,181,196,133,149,18,39,254,188,76,188,222,174,44,235,129,91,98,77,227,254,126,56,221,118,173,212,110,73,216,180,146,24,7,180,239,207,5,150,190,200,166,193,17,196,139,253,23,56,211,142,148,98,246,23,191,140,62,103,86,10,156,1,217,28,76,70,185,38,118,90,149,206,243,96,57,95,239,199,101,36,183,244,104,33,125,53,219,206,189,188,230,24,67,15,21,45,37,181,15,169,159,140,181,21,246,228,233,102,105,145,247,76,16,98,60,149,128,190,91,161,69,72,152,198,97,61,97,237,223,254,0,149,241,211,84,64,45,85,42,20,207,33,184,165,54,138,135,96,171,194,123,175,157,66,183,199,30,64,55,41,82,202,90,87,177,85,193,94,162,159,184,244,35,0,217,124,248,92,48,2,84,69,40,124,92,10,103,30,99,180,85,48,18,60,40,11,21,78,159,218,42,56,130,18,16,193,159,0,0,0,255,255,3,0,219,176,
97,235,105,16,14,38,0,0,0,0,73,69,78,68,174,66,96,130);

tep_newfolder20
:array[0..296] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,240,73,68,65,84,120,1,236,82,193,13,195,32,12,164,17,98,135,60,186,68,214,168,242,96,135,40,91,160,170,234,14,121,84,217,129,71,148,53,186,68,183,136,80,212,216,193,196,16,53,229,93,213,15,176,177,239,240,129,133,248,41,59,129,26,231,92,150,168,121,24,38,40,44,234,90,17,64,74,41,178,73,144,64,235,21,107,109,32,202,34,161,219,17,205,72,168,19,165,181,146,20,60,110,103,108,21,226,246,250,194,118,163,219,169,16,118,34,243,103,40,167,51,229,212,152,38,148,245,247,62,248,224,52,85,183,3,138,69,18,88,212,9,158,248,133,19,226,209,200,179,155,79,15,28,228,108,169,196,27,171,173,11,127,59,202,89,36,205,214,194,19,168,34,129,236,195,203,83,80,235,81,146,255,80,148,248,20,16,17,236,139,245,166,20,45,155,149,239,157,16,177,39,160,144,239,249,36,28,149,248,129,36,253,214,164,238,48,12,99,207,135,237,16,225,147,52,144,48,246,127,219,191,192,27,0,0,255,255,3,0,133,41,72,246,47,234,169,104,0,0,0,0,
73,69,78,68,174,66,96,130);

tep_add20
:array[0..184] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,128,73,68,65,84,120,1,98,96,24,254,128,17,236,197,255,152,30,253,85,183,254,23,72,148,173,41,144,13,67,22,168,11,171,70,176,38,35,111,136,250,115,91,49,53,3,117,49,97,152,70,164,0,217,26,225,78,133,249,9,110,33,146,83,225,98,64,6,216,207,48,63,254,170,5,6,4,76,33,178,42,108,108,144,159,155,3,217,232,239,84,22,152,107,144,227,11,221,191,200,114,48,245,100,59,149,186,26,193,78,3,134,30,3,182,84,3,115,235,8,160,1,0,0,0,255,255,3,0,244,166,41,185,93,78,53,38,0,0,0,0,73,69,78,68,174,66,96,130);

tep_addl20
:array[0..156] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,100,73,68,65,84,120,1,98,96,160,34,96,4,155,245,223,1,171,145,191,78,30,248,133,46,193,102,238,192,134,46,6,230,51,30,96,96,194,42,65,166,224,168,97,164,7,28,56,54,127,157,96,192,136,53,82,141,98,179,96,96,27,141,0,82,67,141,129,129,5,164,5,87,22,33,41,59,49,140,102,39,210,131,159,129,186,69,16,57,14,160,143,30,0,0,0,0,255,255,3,0,121,221,14,102,202,73,221,68,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_addl20
:array[0..161] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,105,73,68,65,84,120,1,98,96,160,34,96,4,155,245,223,1,171,145,191,255,236,254,133,46,193,202,226,202,134,46,6,230,51,30,96,96,194,42,65,166,224,168,97,164,7,28,56,54,127,255,254,141,17,107,164,26,197,202,202,202,54,26,1,164,134,26,3,36,7,128,178,8,54,140,205,56,108,234,64,98,32,181,163,17,128,45,196,240,139,81,53,204,240,91,53,144,178,0,0,0,0,255,255,3,0,94,48,14,17,246,17,198,153,0,0,0,0,73,69,78,68,174,66,96,130);

tep_sub20
:array[0..132] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,76,73,68,65,84,120,1,98,96,24,5,195,33,4,24,193,158,248,207,192,240,171,110,253,47,98,60,196,214,20,200,198,0,212,5,214,248,171,22,168,201,200,155,24,125,12,12,231,182,50,176,53,7,178,49,17,167,26,83,21,217,78,197,52,106,84,100,40,134,0,0,0,0,255,255,3,0,233,156,16,6,85,6,62,183,0,0,0,0,73,69,78,68,174,66,96,130);

tep_subl20
:array[0..113] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,57,73,68,65,84,120,1,98,96,24,5,163,33,128,53,4,24,65,162,191,78,48,252,194,42,75,130,32,155,5,3,27,19,9,234,9,42,29,33,134,17,12,135,81,5,163,33,64,133,16,0,0,0,0,255,255,3,0,185,198,3,10,95,176,77,218,0,0,0,0,73,69,78,68,174,66,96,130);

tep_edit20
:array[0..206] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,150,73,68,65,84,120,1,98,96,24,108,128,17,228,160,255,64,108,92,123,226,23,57,142,59,219,108,193,6,50,4,108,144,17,153,134,192,44,62,7,52,140,9,198,161,148,102,129,25,112,162,86,18,198,36,137,182,104,126,14,86,15,55,136,129,1,34,64,146,41,72,138,169,239,53,152,225,22,205,48,22,126,250,68,45,170,60,146,215,32,18,232,10,80,149,227,230,81,205,107,84,51,8,201,107,144,88,179,104,38,46,25,156,168,133,197,50,68,61,146,65,176,48,130,41,192,29,30,216,100,168,230,53,170,25,68,181,220,143,205,187,195,68,12,0,0,0,255,255,3,0,192,92,27,128,233,159,154,141,0,0,0,0,73,69,78,68,174,66,96,130);

tep_favadd20
:array[0..184] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,128,73,68,65,84,120,1,98,96,24,254,128,17,236,197,255,152,30,253,85,183,254,23,72,148,173,41,144,13,67,22,168,11,171,70,176,38,35,111,136,250,115,91,49,53,3,117,49,97,152,70,164,0,217,26,225,78,133,249,9,110,33,146,83,225,98,64,6,216,207,48,63,254,170,5,6,4,76,33,178,42,108,108,144,159,155,3,217,232,239,84,22,152,107,144,227,11,221,191,200,114,48,245,100,59,149,186,26,193,78,3,134,30,3,182,84,3,115,235,8,160,1,0,0,0,255,255,3,0,244,166,41,185,93,78,53,38,0,0,0,0,73,69,78,68,174,66,96,130);

tep_favedit20
:array[0..299] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,23,0,0,0,20,8,6,0,0,0,102,190,166,14,0,0,0,243,73,68,65,84,120,1,188,147,205,13,194,48,12,133,83,4,12,196,26,156,24,136,19,3,113,98,13,6,42,7,240,11,117,176,173,56,122,8,21,75,109,154,198,254,252,155,169,136,60,241,34,228,113,190,206,187,203,105,79,168,150,73,148,54,140,34,116,0,46,135,227,123,37,141,104,56,201,115,106,171,194,81,26,170,230,181,44,46,46,191,137,189,0,152,130,55,176,212,60,149,251,173,88,7,95,53,52,133,234,65,167,217,53,242,25,147,192,200,40,114,181,95,50,0,120,171,255,48,102,67,17,35,74,52,3,185,15,117,90,106,173,96,204,2,40,47,38,114,219,12,189,48,41,35,11,34,100,255,41,139,33,193,209,112,66,2,196,152,186,207,85,47,81,55,242,230,62,139,240,151,178,52,120,246,145,57,13,250,255,47,75,107,166,70,18,203,16,247,170,23,50,202,35,87,69,1,217,49,173,28,156,245,30,117,178,172,57,28,10,61,112,0,140,182,249,180,4,176,155,253,17,81,206,52,211,23,0,0,0,255,255,3,0,33,46,80,114,118,200,54,41,0,0,0,0,73,69,78,68,174,66,96,
130);

tep_undo20
:array[0..180] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,20,8,6,0,0,0,185,240,220,17,0,0,0,124,73,68,65,84,120,1,204,80,73,14,128,32,12,4,163,252,255,189,120,168,14,201,144,177,173,55,77,224,210,118,22,186,148,242,247,171,104,96,22,219,156,181,119,162,135,181,134,188,222,234,157,160,70,136,41,2,174,245,166,66,79,146,131,153,29,131,129,162,183,184,160,97,92,137,11,113,110,173,245,90,224,199,14,30,164,49,195,231,210,158,244,53,63,153,6,0,20,49,82,164,241,97,80,147,138,52,15,6,37,179,124,65,67,54,230,183,216,5,0,0,255,255,3,0,20,253,36,132,174,18,241,246,0,0,0,0,73,69,78,68,174,66,96,130);

tep_redo20
:array[0..181] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,20,8,6,0,0,0,185,240,220,17,0,0,0,125,73,68,65,84,120,1,204,144,65,14,128,32,12,4,193,104,255,255,94,60,160,213,140,89,138,26,15,154,200,165,44,221,97,161,41,125,189,178,7,212,186,199,204,185,20,2,167,106,198,158,154,87,247,136,112,179,154,162,198,183,37,148,212,154,105,70,200,19,6,154,79,235,15,129,99,74,252,65,71,235,103,173,54,235,254,160,163,229,18,175,156,119,128,54,1,48,187,62,5,20,82,243,45,160,144,239,89,151,9,24,98,253,33,16,159,248,190,94,0,0,0,255,255,3,0,87,198,35,127,39,177,157,173,0,0,0,0,73,69,78,68,174,66,96,130);

tep_stop20
:array[0..132] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,76,73,68,65,84,120,1,98,96,24,126,128,17,228,165,255,255,255,51,108,96,244,249,69,200,123,1,255,183,176,49,50,50,50,176,128,20,130,52,24,165,120,19,210,3,51,152,141,137,160,74,44,10,70,53,65,3,101,144,7,4,89,201,8,75,124,15,121,33,0,0,0,0,255,255,3,0,46,65,18,238,193,9,194,7,0,0,0,0,73,69,78,68,174,66,96,130);

tep_play20
:array[0..179] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,11,0,0,0,20,8,6,0,0,0,91,44,199,104,0,0,0,123,73,68,65,84,120,1,98,96,24,122,128,17,228,228,255,255,255,51,72,109,96,252,5,115,254,179,128,255,108,48,54,140,102,100,100,100,96,2,113,64,10,83,140,82,24,96,24,89,35,76,49,136,6,43,70,22,0,177,65,154,176,105,192,170,24,151,6,156,138,177,105,192,171,24,93,3,65,197,32,13,48,64,80,241,156,115,115,24,96,65,137,87,49,178,66,144,233,56,21,163,43,196,169,24,155,66,144,98,146,162,27,164,97,168,1,0,0,0,0,255,255,3,0,67,88,48,143,158,192,143,11,0,0,0,0,73,69,78,68,174,66,96,130);

tep_rec20
:array[0..186] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,12,0,0,0,20,8,6,0,0,0,185,240,220,17,0,0,0,130,73,68,65,84,120,1,228,145,65,10,128,64,8,69,53,98,78,90,155,14,212,166,78,218,198,122,145,131,69,67,52,187,72,24,24,253,126,31,162,200,247,67,89,193,204,78,155,244,170,11,133,201,44,69,65,85,165,141,5,111,28,143,162,231,209,152,9,136,222,24,135,240,31,182,135,9,66,115,21,159,242,157,208,137,20,167,251,0,40,179,72,122,77,168,51,176,16,200,82,248,210,232,117,4,156,78,137,36,254,113,58,125,249,14,36,30,119,7,67,227,14,191,140,21,0,0,255,255,3,0,7,254,44,4,187,22,15,38,0,0,0,0,73,69,78,68,174,66,96,130);

tep_rewind20
:array[0..198] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,142,73,68,65,84,120,1,236,146,49,14,128,48,8,69,193,152,94,174,75,47,228,228,133,186,244,114,46,53,223,8,161,181,93,112,84,22,200,135,255,18,104,137,254,96,156,160,214,250,184,68,206,124,136,152,82,13,168,123,141,153,105,149,33,155,49,24,227,166,146,24,7,90,88,116,234,46,122,179,244,173,89,52,228,6,48,50,151,178,211,204,220,0,60,102,5,120,205,10,64,225,141,235,6,120,38,236,106,3,123,247,154,237,75,173,71,244,66,20,0,162,7,210,0,102,16,232,179,117,94,127,101,192,191,30,39,0,0,0,255,255,3,0,239,207,80,86,123,175,102,25,0,0,0,0,73,69,78,68,174,66,96,130);

tep_fastforward20
:array[0..206] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,150,73,68,65,84,120,1,236,146,187,13,192,32,12,68,237,20,89,142,38,11,165,202,64,208,176,28,13,209,33,93,100,33,126,82,202,132,198,230,236,123,178,12,34,255,81,172,32,231,44,33,104,226,58,142,35,239,200,91,26,123,16,85,85,10,192,123,73,206,157,79,45,198,171,228,181,70,48,27,1,216,120,177,209,26,169,67,179,19,81,111,2,80,132,129,147,176,185,5,233,2,86,33,67,192,10,100,10,224,248,189,56,5,96,15,245,82,161,241,69,134,128,153,25,83,117,1,43,230,46,0,230,250,216,177,109,237,245,87,182,176,175,230,55,0,0,0,255,255,3,0,109,115,81,22,66,238,71,144,0,0,0,0,73,69,78,68,174,66,96,130);

tep_vol20
:array[0..210] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,154,73,68,65,84,120,1,212,146,177,13,192,32,12,4,29,41,98,141,172,193,64,206,24,169,50,70,60,41,77,194,35,189,100,97,138,136,14,55,192,227,123,27,11,145,101,98,107,157,190,34,122,106,249,211,181,61,150,164,82,13,84,213,162,122,5,206,236,150,94,135,102,102,105,15,217,78,168,9,237,212,195,16,3,8,71,70,237,164,109,169,121,131,0,242,178,111,147,48,77,3,232,19,252,158,0,215,0,178,34,18,114,62,234,112,52,12,8,119,1,28,85,129,230,13,135,160,79,152,158,42,156,17,11,84,68,155,254,205,56,51,166,63,57,13,22,88,63,0,0,0,255,255,3,0,30,176,68,98,62,55,3,240,0,0,0,0,73,69,78,68,174,66,96,130);

tep_paste20
:array[0..312] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,0,73,68,65,84,120,1,204,147,189,13,194,48,16,133,13,66,217,129,53,160,201,14,84,236,224,38,236,144,202,59,132,198,59,176,6,13,172,193,14,52,144,119,232,157,30,14,18,142,104,176,148,220,175,191,188,196,151,16,254,109,45,32,232,241,65,213,177,95,223,53,221,165,91,163,177,250,128,56,168,220,136,198,28,78,214,31,195,222,172,222,20,12,200,18,69,66,98,31,3,46,44,64,0,192,229,64,169,115,143,53,143,55,83,52,140,175,225,128,148,29,198,38,218,44,53,248,84,5,200,138,77,106,209,52,119,77,64,84,246,51,72,1,109,218,105,248,230,199,241,203,233,154,40,210,34,252,33,110,202,84,56,228,171,29,64,23,90,175,217,169,121,52,195,193,3,182,253,217,103,237,171,34,176,161,128,139,10,153,51,88,106,155,42,16,55,151,48,196,4,86,129,216,76,16,173,62,160,10,164,27,8,41,173,131,116,106,203,166,106,69,24,117,252,59,211,137,126,205,81,141,34,255,251,75,21,140,245,136,153,83,123,25,79,204,32,154,252,11,255,9,0,0,255,255,
3,0,214,156,86,180,148,44,214,64,0,0,0,0,73,69,78,68,174,66,96,130);

tep_max20
:array[0..199] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,143,73,68,65,84,120,1,98,96,24,146,128,17,228,234,63,127,254,128,29,255,175,113,243,47,98,124,193,84,239,203,198,194,194,194,192,2,83,12,214,104,228,13,227,226,165,161,150,176,49,225,85,69,64,114,224,52,195,253,108,193,32,201,192,112,238,28,134,67,79,24,25,97,136,193,4,192,154,205,26,207,252,74,241,198,174,200,98,235,57,6,92,6,12,156,159,7,206,102,120,104,195,66,16,43,125,110,43,138,48,40,121,50,52,51,48,192,211,54,40,196,81,84,64,57,167,234,77,216,176,137,131,210,246,72,4,0,0,0,0,255,255,3,0,160,48,33,52,62,57,175,99,0,0,0,0,73,69,78,68,174,66,96,130);

tep_ontop20
:array[0..195] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,139,73,68,65,84,120,1,98,96,24,121,128,17,228,229,255,64,252,187,118,253,47,98,188,207,218,28,200,6,82,7,210,8,214,252,11,164,209,200,155,24,189,12,12,231,182,50,128,12,0,105,100,193,167,195,226,220,57,44,210,146,12,103,161,162,56,53,131,52,166,120,27,97,209,204,192,96,204,112,226,23,67,179,5,27,19,86,89,34,5,71,162,102,156,161,125,194,200,136,193,98,43,182,168,98,96,56,11,12,105,130,241,12,50,0,3,0,19,9,12,128,109,6,165,24,82,147,39,204,128,145,70,3,0,0,0,255,255,3,0,51,3,31,74,72,90,90,97,0,0,0,0,73,69,78,68,174,66,96,130);

tep_nav20
:array[0..138] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,82,73,68,65,84,120,1,98,96,24,242,128,17,228,131,134,255,255,25,60,124,166,255,34,197,55,59,182,100,178,53,48,50,50,176,128,52,225,210,108,180,62,5,183,153,64,11,27,24,24,216,152,112,171,32,78,102,212,0,6,134,209,48,24,12,97,64,113,102,34,46,193,15,106,85,0,0,0,0,255,255,3,0,18,196,19,234,120,204,29,89,0,0,0,0,73,69,78,68,174,66,96,130);

tep_less20
:array[0..226] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,170,73,68,65,84,120,1,98,96,24,108,128,17,228,160,255,88,92,245,251,215,250,95,88,132,25,88,217,2,217,208,197,65,134,96,24,132,203,0,100,205,232,134,97,24,68,140,33,216,12,4,25,196,4,147,32,213,16,152,62,24,13,55,8,38,64,10,141,108,57,56,140,126,225,8,88,98,13,101,3,70,0,69,46,66,182,136,5,153,99,209,44,137,204,37,200,62,81,251,28,174,134,54,46,66,182,1,110,21,145,12,170,185,8,108,16,122,74,37,210,17,96,101,48,189,112,23,193,4,200,49,4,164,7,110,16,41,6,96,83,139,98,16,200,85,196,184,12,155,58,20,131,96,54,225,51,12,159,28,76,255,224,160,1,0,0,0,255,255,3,0,116,201,35,93,61,163,98,107,0,0,0,0,73,69,78,68,174,66,96,130);

tep_more20
:array[0..247] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,191,73,68,65,84,120,1,204,146,209,13,131,48,12,68,67,85,178,67,55,233,26,12,212,47,6,98,13,54,233,14,225,131,226,72,23,29,198,193,72,80,137,72,40,142,237,123,62,37,132,112,183,213,136,161,217,112,53,165,33,25,233,208,198,46,234,188,64,54,160,26,128,197,26,182,1,29,129,88,64,1,61,80,168,65,222,253,43,200,231,173,2,242,26,173,58,15,207,119,148,42,23,43,98,184,25,63,95,139,149,115,113,121,128,83,142,152,252,228,3,166,115,14,177,85,99,151,255,113,196,19,180,19,171,134,30,217,47,115,148,65,250,79,229,73,94,12,109,113,132,132,39,228,58,107,86,175,198,77,136,189,187,65,95,113,36,9,153,192,83,208,164,119,171,111,5,130,96,15,182,87,131,254,30,251,15,0,0,255,255,3,0,123,243,46,7,53,56,118,225,0,0,0,0,73,69,78,68,174,66,96,130);

tep_bw20
:array[0..228] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,172,73,68,65,84,120,1,204,211,65,14,128,32,12,4,64,52,145,255,191,23,15,202,98,182,52,69,161,120,81,14,66,74,153,148,6,67,248,219,88,80,208,113,83,213,158,82,186,9,135,45,198,104,227,64,26,232,9,208,135,45,214,64,30,132,32,10,203,55,41,213,1,90,185,49,139,240,28,103,129,24,24,205,186,69,185,18,233,99,233,81,238,171,4,122,144,70,76,94,116,87,212,65,138,233,130,70,8,164,33,228,65,134,144,23,233,66,51,136,64,246,165,206,32,124,148,210,35,98,111,16,169,8,11,140,25,228,58,81,191,229,65,218,191,95,191,216,154,90,87,188,14,35,64,228,106,12,98,182,137,222,61,157,247,253,250,4,0,0,255,255,3,0,83,64,32,246,43,60,202,146,0,0,0,0,73,69,78,68,174,66,96,130);

tep_help20
:array[0..529] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,217,73,68,65,84,120,1,132,84,177,113,195,48,12,132,114,57,239,192,42,59,104,13,166,201,14,116,227,29,228,34,218,65,141,185,67,154,104,135,84,218,33,21,119,80,227,252,3,36,77,157,45,7,119,2,69,19,120,60,30,148,59,161,93,213,223,185,175,46,172,119,63,74,146,57,136,196,203,124,168,103,157,200,107,221,52,47,5,160,15,62,255,154,4,249,102,61,150,113,129,243,107,11,182,1,34,64,63,32,114,114,34,75,201,228,138,125,159,247,206,9,99,92,4,84,231,214,143,107,84,102,47,86,198,124,63,129,1,2,37,37,89,226,130,103,214,181,198,240,140,134,213,145,25,92,56,122,109,191,2,145,13,227,150,211,44,99,154,133,149,202,243,118,249,56,104,107,236,136,249,196,35,16,204,131,25,77,129,180,165,128,147,92,197,71,39,252,45,28,111,98,3,27,102,237,129,176,154,241,51,95,25,233,9,42,250,31,104,128,22,41,52,171,133,119,163,158,82,166,67,20,62,216,102,88,77,221,2,89,33,113,101,88,208,192,47,182,233,61,232,50,51,129,129,33,
148,104,93,117,106,212,66,219,67,34,100,212,130,122,10,22,188,51,106,214,1,64,146,20,114,124,209,169,181,247,168,130,81,43,36,45,170,137,97,176,136,132,138,84,9,213,34,8,3,22,108,231,102,235,25,220,239,113,90,9,78,91,56,165,204,52,94,236,14,17,101,115,33,53,178,113,195,217,173,129,173,13,163,196,152,36,120,7,141,147,140,159,114,251,60,114,252,67,177,27,44,16,153,84,92,130,196,153,250,148,73,180,81,255,48,34,155,148,78,154,49,142,189,196,111,126,168,141,120,13,214,211,214,162,234,209,68,63,121,125,10,164,121,42,50,47,78,153,218,99,180,93,141,40,244,16,38,81,177,9,131,207,125,56,203,131,255,39,3,222,7,2,72,177,144,239,16,5,47,159,76,57,43,235,110,107,73,76,228,18,200,117,198,212,246,108,151,145,10,141,44,142,159,119,136,70,111,147,211,237,198,253,1,0,0,255,255,3,0,109,74,179,203,151,7,135,177,0,0,0,0,73,69,78,68,174,66,96,130);

tep_helpdoc20
:array[0..212] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,156,73,68,65,84,120,1,196,147,65,10,192,32,12,4,211,82,124,87,192,119,121,242,93,66,222,213,83,141,160,4,91,99,164,148,230,162,146,221,201,162,8,240,119,109,28,128,136,32,37,60,87,194,120,79,14,17,161,0,66,128,98,14,121,99,169,24,99,145,229,197,237,213,96,53,179,94,106,27,160,130,86,215,41,160,198,29,129,167,0,54,106,16,19,64,131,28,125,52,109,26,247,228,5,178,215,156,160,31,84,207,183,4,253,4,153,168,239,45,37,120,50,155,1,35,179,9,160,153,77,0,22,105,213,94,65,94,150,102,224,158,212,190,254,206,179,97,223,247,47,0,0,0,255,255,3,0,48,195,44,34,76,22,205,167,0,0,0,0,73,69,78,68,174,66,96,130);

tep_um20
:array[0..306] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,250,73,68,65,84,120,1,204,83,49,14,2,49,12,107,17,186,207,177,192,31,88,224,15,76,252,1,150,251,3,44,124,142,165,224,74,62,185,38,87,36,116,3,29,46,109,226,56,78,122,77,105,193,149,193,85,74,233,82,222,175,249,9,192,246,80,134,57,96,206,57,173,61,232,137,56,111,246,167,10,195,158,132,142,3,160,81,166,137,143,241,92,9,72,84,15,239,143,251,113,70,129,80,25,147,156,228,155,31,241,21,65,176,168,192,202,234,159,219,83,21,227,13,25,157,191,218,105,102,28,168,183,167,74,61,134,162,84,135,153,85,178,219,37,77,55,166,170,8,164,79,47,136,62,88,224,118,199,52,44,218,102,37,227,224,181,37,173,220,219,171,250,105,102,76,240,86,180,128,207,172,33,138,94,0,73,105,157,128,254,200,54,51,115,85,81,66,207,215,144,41,16,45,104,139,140,169,31,170,249,75,33,30,206,12,1,125,208,108,85,103,68,18,226,194,183,201,32,8,123,43,194,125,40,139,8,92,69,132,129,178,255,93,47,0,0,0,255,255,3,0,215,43,139,218,118,24,111,
150,0,0,0,0,73,69,78,68,174,66,96,130);

tep_about20
:array[0..269] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,213,73,68,65,84,120,1,212,147,65,18,194,32,12,69,209,113,60,80,187,233,229,186,234,229,186,177,7,114,163,190,234,115,90,74,28,22,108,100,3,73,200,35,31,66,74,141,199,9,222,35,128,246,227,124,47,133,110,211,112,45,249,129,93,74,1,65,243,216,149,194,169,79,239,131,74,224,3,16,152,160,97,90,138,64,227,128,115,232,78,178,176,8,148,211,1,179,87,40,176,179,155,126,193,72,180,42,247,51,3,195,239,21,225,251,2,49,90,140,85,114,247,185,183,90,169,249,193,74,95,94,175,223,188,194,42,96,116,135,121,165,216,85,192,82,98,228,251,19,32,141,105,79,69,82,34,191,47,108,115,55,151,220,252,235,237,128,200,242,11,178,142,26,29,153,198,149,138,13,236,0,36,224,223,52,17,223,118,120,208,22,70,60,4,154,44,88,219,57,7,233,95,171,211,104,53,63,1,0,0,255,255,3,0,69,28,104,214,23,227,221,207,0,0,0,0,73,69,78,68,174,66,96,130);

tep_settings20
:array[0..306] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,0,250,73,68,65,84,120,1,204,83,49,14,2,49,12,107,17,186,207,177,192,31,88,224,15,76,252,1,150,251,3,44,124,142,165,224,74,62,185,38,87,36,116,3,29,46,109,226,56,78,122,77,105,193,149,193,85,74,233,82,222,175,249,9,192,246,80,134,57,96,206,57,173,61,232,137,56,111,246,167,10,195,158,132,142,3,160,81,166,137,143,241,92,9,72,84,15,239,143,251,113,70,129,80,25,147,156,228,155,31,241,21,65,176,168,192,202,234,159,219,83,21,227,13,25,157,191,218,105,102,28,168,183,167,74,61,134,162,84,135,153,85,178,219,37,77,55,166,170,8,164,79,47,136,62,88,224,118,199,52,44,218,102,37,227,224,181,37,173,220,219,171,250,105,102,76,240,86,180,128,207,172,33,138,94,0,73,105,157,128,254,200,54,51,115,85,81,66,207,215,144,41,16,45,104,139,140,169,31,170,249,75,33,30,206,12,1,125,208,108,85,103,68,18,226,194,183,201,32,8,123,43,194,125,40,139,8,92,69,132,129,178,255,93,47,0,0,0,255,255,3,0,215,43,139,218,118,24,111,
150,0,0,0,0,73,69,78,68,174,66,96,130);

tep_options20
:array[0..490] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,19,0,0,0,20,8,6,0,0,0,111,85,6,116,0,0,1,178,73,68,65,84,120,1,204,84,177,113,195,48,12,132,114,57,237,192,202,59,176,202,14,172,178,67,42,239,64,23,230,14,174,180,131,27,115,135,84,220,33,21,119,112,163,252,67,162,69,202,116,151,34,188,179,32,130,192,227,241,132,44,242,135,107,32,214,60,207,47,33,79,167,225,94,31,158,207,243,88,239,203,251,48,12,242,86,54,197,50,121,15,224,229,42,222,253,148,16,181,189,184,134,25,3,152,148,142,89,162,251,208,164,7,72,76,34,206,74,136,135,197,111,96,140,147,144,162,144,45,153,189,235,73,245,32,144,189,32,242,248,189,88,128,164,104,240,110,181,136,191,128,33,129,205,36,146,99,149,41,45,24,43,156,4,26,173,64,11,176,21,192,0,72,30,224,100,40,89,36,224,87,107,248,164,25,75,41,51,84,87,187,214,46,62,177,96,164,204,46,13,43,110,180,205,70,112,123,151,128,194,30,124,130,69,187,97,189,60,116,228,169,83,186,162,218,36,217,36,221,87,185,227,166,153,199,4,80,2,135,31,108,112,11,80,221,134,94,144,249,148,
140,34,38,89,201,14,128,176,212,46,32,109,107,179,2,42,128,56,239,46,5,178,73,1,21,8,218,113,109,96,9,237,176,165,149,153,218,37,230,233,153,59,64,12,106,230,140,14,213,160,110,185,104,134,51,106,150,209,62,153,21,70,69,134,238,23,64,192,90,59,33,48,46,133,150,64,92,100,198,129,221,175,237,2,112,162,172,152,88,183,90,107,9,66,202,138,40,187,129,165,107,211,140,59,174,2,212,209,208,196,172,159,15,63,33,50,211,81,89,178,244,217,48,83,207,170,81,74,78,110,183,219,88,52,244,211,216,76,188,250,145,112,126,5,86,196,172,206,245,245,43,31,36,24,180,159,183,127,159,94,236,51,179,61,18,246,211,196,65,218,128,58,33,255,220,245,11,0,0,255,255,3,0,49,86,201,128,79,95,4,183,0,0,0,0,73,69,78,68,174,66,96,130);

tep_be20
:array[0..633] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,2,65,73,68,65,84,120,1,156,149,49,110,219,64,16,69,135,73,218,0,114,153,70,228,25,82,185,33,121,128,192,55,144,89,197,77,186,28,64,149,124,128,52,73,149,42,246,69,40,54,169,2,8,190,0,87,141,234,0,57,64,254,155,229,146,162,77,32,177,7,152,221,229,236,236,223,191,127,71,171,204,38,203,52,252,42,127,47,127,55,133,255,107,116,82,214,47,249,78,206,216,222,208,200,0,237,229,207,5,212,18,55,214,65,232,131,252,82,126,122,165,6,131,233,75,65,29,96,104,192,216,50,78,192,236,182,104,121,110,150,215,185,213,242,166,169,109,187,157,156,111,226,185,114,206,204,177,146,20,79,216,198,5,133,149,37,11,1,94,107,237,81,30,251,16,18,84,101,119,119,123,219,237,218,20,112,172,4,156,130,222,55,77,46,192,90,12,75,11,1,48,243,190,239,25,117,214,117,35,170,93,95,87,190,57,68,218,118,138,63,1,230,168,176,196,0,37,249,120,12,30,43,138,220,0,135,109,219,182,46,67,223,87,202,156,107,193,218,164,49,99,79,4,20,0,22,223,
220,252,176,251,251,86,160,149,98,42,155,62,140,108,209,119,179,169,61,30,148,204,220,185,205,24,167,75,128,229,237,109,43,240,32,57,216,8,208,200,116,173,141,203,114,130,64,223,253,190,119,34,83,212,236,245,240,241,89,253,219,213,106,101,85,85,152,58,187,184,200,44,203,204,174,174,10,79,225,4,108,188,178,32,144,149,61,60,4,157,230,32,73,14,118,56,252,30,96,188,251,163,246,203,76,138,243,163,34,9,155,80,17,128,118,29,39,96,97,44,175,245,58,234,26,99,14,56,107,196,201,141,37,99,201,113,195,24,26,194,146,42,160,156,136,87,218,108,186,220,36,153,167,167,230,164,65,62,211,56,205,180,45,218,70,80,24,161,33,70,28,91,83,202,255,176,153,20,41,23,150,56,151,135,193,50,25,224,93,44,237,33,164,196,5,91,4,166,220,38,86,193,199,104,141,33,71,57,48,62,106,131,180,249,99,236,69,224,152,148,152,196,190,105,10,127,39,54,155,194,167,1,77,18,61,6,229,59,27,130,63,213,207,30,162,116,129,16,205,243,194,211,56,69,100,25,127,121,131,82,3,196,216,241,46,95,38,224,111,250,248,56,78,45,12,6,37,116,244,
133,201,121,232,187,62,63,37,96,250,94,62,150,156,198,47,49,74,205,31,250,4,12,8,160,60,210,72,242,220,13,0,156,253,53,253,5,0,0,255,255,3,0,169,110,206,29,157,94,240,146,0,0,0,0,73,69,78,68,174,66,96,130);

{
:array[0..740] of byte=(//orginal aqua icon - 12feb2022
84,69,65,49,35,19,0,0,0,20,0,0,0,255,255,255,22,0,242,253,2,11,231,253,6,55,121,231,1,11,231,253,3,55,121,231,1,255,255,255,5,0,242,253,2,11,231,253,5,22,220,253,3,55,121,231,1,22,220,253,3,255,255,255,4,0,242,253,1,55,121,231,1,255,255,255,4,22,220,253,1,55,121,231,1,33,209,253,2,55,121,231,1,255,255,255,2,22,220,253,2,55,121,231,1,255,255,255,3,55,121,231,1,255,255,255,4,22,220,253,1,55,121,231,1,255,255,255,1,33,209,253,2,55,121,231,1,255,255,255,3,33,209,253,1,22,220,253,1,55,121,231,1,255,255,255,6,33,209,253,2,55,121,231,1,255,255,255,1,44,198,253,2,55,121,231,1,255,255,255,3,44,198,253,2,55,121,231,1,255,255,255,6,33,209,253,1,33,198,253,1,55,121,231,1,255,255,255,1,55,187,253,2,55,121,231,1,255,255,255,2,55,187,253,2,55,121,231,1,255,255,255,5,33,209,253,2,44,198,253,2,55,121,231,1,255,255,255,1,55,187,253,2,55,121,231,1,55,187,253,4,255,255,255,4,33,209,253,2,55,121,231,1,44,198,253,1,44,187,253,1,55,187,253,1,55,121,231,1,255,255,255,1,66,176,253,1,77,165,253,3,55,121,231,1,66,176,253,
3,55,187,253,1,55,121,231,1,255,255,255,1,33,209,253,1,55,121,231,1,255,255,255,2,55,187,253,1,55,176,253,1,55,121,231,1,255,255,255,1,77,165,253,1,77,154,253,3,255,255,255,2,66,165,253,1,66,176,253,2,55,121,231,1,255,255,255,4,55,176,253,1,66,176,253,1,77,165,253,1,55,121,231,1,255,255,255,1,88,154,253,1,88,143,253,1,55,121,231,1,99,143,253,1,255,255,255,2,88,143,253,1,88,154,253,1,77,154,253,1,55,121,231,1,255,255,255,3,55,187,253,1,66,176,253,1,66,165,253,1,77,165,253,1,55,121,231,1,88,143,253,2,55,121,231,1,255,255,255,1,99,132,253,1,99,143,253,3,88,143,253,1,88,154,253,1,55,121,231,1,255,255,255,2,55,187,253,1,66,176,253,1,55,121,231,1,77,165,253,1,88,154,253,1,55,121,231,1,99,143,253,2,55,121,231,1,255,255,255,1,110,132,253,1,55,121,231,2,99,132,253,1,99,143,253,2,55,121,231,1,255,255,255,2,55,121,231,2,255,255,255,1,88,154,253,1,99,143,253,1,99,132,253,1,110,132,253,1,55,121,231,1,255,255,255,2,121,121,253,1,255,255,255,3,110,121,253,1,55,121,231,1,255,255,255,5,88,154,253,1,88,143,253,1,
99,143,253,1,110,132,253,1,110,121,253,2,121,121,253,3,121,110,253,3,121,121,253,1,55,121,231,1,255,255,255,4,77,154,253,1,55,121,231,5,121,121,253,1,121,110,253,1,132,110,253,2,55,121,231,2,255,255,255,6,77,165,253,1,88,154,253,1,255,255,255,5,55,121,231,1,132,110,253,2,55,121,231,1,255,255,255,8,77,154,253,1,88,154,253,1,255,255,255,6,55,121,231,2,255,255,255,9,88,154,253,1,88,143,253,1,255,255,255,17,55,121,231,2,255,255,255,15);
tep_go20:array[0..222] of byte=(
84,69,65,50,35,1,0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,20,0,0,0,255,0,0,66,0,0,0,7,255,0,0,6,0,0,0,1,255,255,0,6,0,0,0,1,255,0,0,5,0,0,0,1,255,255,0,5,0,0,0,1,255,0,0,6,0,0,0,1,255,255,0,4,0,0,0,1,255,0,0,7,0,0,0,1,255,255,0,5,0,0,0,1,255,0,0,6,0,0,0,1,255,255,0,2,0,0,0,1,255,255,0,3,0,0,0,1,255,0,0,5,0,0,0,1,255,255,0,1,0,0,0,1,255,0,0,1,0,0,0,1,255,255,0,3,0,0,0,1,255,0,0,5,0,0,0,1,255,0,0,3,0,0,0,1,255,255,0,3,0,0,0,1,255,0,0,9,0,0,0,1,255,255,0,3,0,0,0,1,255,0,0,9,0,0,0,1,255,255,0,1,0,0,0,1,255,0,0,11,0,0,0,1,255,0,0,55);
}
{
tep_be20:array[0..680] of byte=(//purple icon from 2019-2021
84,69,65,49,35,19,0,0,0,20,0,0,0,255,0,0,2,227,218,245,7,207,192,238,1,227,218,245,1,83,109,207,1,227,218,245,2,207,192,238,1,83,109,207,1,255,0,0,4,227,218,245,6,207,192,238,2,83,109,207,1,207,192,238,6,83,109,207,1,255,0,0,2,227,218,245,1,83,109,207,1,255,0,0,4,207,192,238,1,83,109,207,1,207,192,238,3,83,109,207,1,255,0,0,2,207,192,238,3,255,0,0,2,83,109,207,1,255,0,0,4,207,192,238,2,255,0,0,1,207,192,238,1,197,172,234,1,207,192,238,1,83,109,207,1,255,0,0,3,207,192,238,2,83,109,207,1,255,0,0,6,207,192,238,2,255,0,0,1,197,172,234,3,83,109,207,1,255,0,0,3,197,172,234,2,83,109,207,1,255,0,0,5,197,172,234,3,255,0,0,1,197,172,234,3,83,109,207,1,255,0,0,2,197,172,234,3,255,0,0,4,207,192,238,1,197,172,234,2,207,192,238,1,197,172,234,1,255,0,0,1,197,172,234,1,138,160,246,1,197,172,234,1,83,109,207,1,197,172,234,1,138,160,246,1,197,172,234,1,138,160,246,1,83,109,207,1,255,0,0,2,207,192,238,2,83,109,207,1,207,192,238,1,197,172,234,1,138,160,246,1,197,172,234,1,255,0,0,1,138,160,246,4,83,109,207,2,138,160,
246,2,197,172,234,2,83,109,207,1,207,192,238,1,83,109,207,1,255,0,0,2,197,172,234,1,138,160,246,2,255,0,0,1,138,160,246,4,83,109,207,1,255,0,0,2,138,160,246,3,83,109,207,2,255,0,0,3,138,160,246,3,255,0,0,1,138,160,246,3,83,109,207,1,138,160,246,6,83,109,207,1,255,0,0,3,197,172,234,1,138,160,246,3,255,0,0,1,138,160,246,1,131,129,251,1,138,160,246,1,83,109,207,2,255,0,0,2,131,129,251,1,138,160,246,2,83,109,207,1,255,0,0,2,138,160,246,5,131,129,251,3,83,109,207,1,255,0,0,1,131,129,251,5,138,160,246,1,83,109,207,1,255,0,0,1,138,160,246,1,83,109,207,1,255,0,0,1,138,160,246,2,83,109,207,1,131,129,251,2,83,109,207,1,255,0,0,2,83,109,207,1,255,0,0,3,131,129,251,2,83,109,207,1,255,0,0,1,83,109,207,1,255,0,0,2,138,160,246,1,131,129,251,3,83,109,207,1,255,0,0,3,83,109,207,1,255,0,0,3,131,129,251,1,83,109,207,1,255,0,0,4,138,160,246,1,131,129,251,8,83,109,207,1,131,129,251,4,83,109,207,1,255,0,0,3,138,160,246,1,83,109,207,5,131,129,251,4,83,109,207,3,255,0,0,5,138,160,246,1,83,109,207,1,255,0,0,5,83,109,207,
2,131,129,251,2,255,0,0,8,138,160,246,1,83,109,207,1,255,0,0,17,138,160,246,1,83,109,207,1,255,0,0,17,83,109,207,1,255,0,0,17);
{}//yyy

//tep_go20:array[0..222] of byte=(
//84,69,65,50,35,1,0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,20,0,0,0,255,0,0,66,0,0,0,7,255,0,0,6,0,0,0,1,255,255,0,6,0,0,0,1,255,0,0,5,0,0,0,1,255,255,0,5,0,0,0,1,255,0,0,6,0,0,0,1,255,255,0,4,0,0,0,1,255,0,0,7,0,0,0,1,255,255,0,5,0,0,0,1,255,0,0,6,0,0,0,1,255,255,0,2,0,0,0,1,255,255,0,3,0,0,0,1,255,0,0,5,0,0,0,1,255,255,0,1,0,0,0,1,255,0,0,1,0,0,0,1,255,255,0,3,0,0,0,1,255,0,0,5,0,0,0,1,255,0,0,3,0,0,0,1,255,255,0,3,0,0,0,1,255,0,0,9,0,0,0,1,255,255,0,3,0,0,0,1,255,0,0,9,0,0,0,1,255,255,0,1,0,0,0,1,255,0,0,11,0,0,0,1,255,0,0,55);

tep_go20
:array[0..181] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,20,8,6,0,0,0,86,50,183,47,0,0,0,125,73,68,65,84,120,1,236,144,205,18,128,32,8,132,173,105,120,255,231,245,82,172,181,14,34,216,189,201,11,242,243,193,66,41,223,123,27,86,58,221,94,26,172,46,100,93,57,172,135,63,128,154,32,34,119,245,238,33,157,42,76,250,28,253,9,66,226,13,12,161,149,68,52,157,32,15,68,82,7,40,2,34,169,29,202,0,187,35,26,192,215,218,246,134,51,67,18,11,158,124,55,0,218,36,43,97,5,144,236,242,8,102,19,8,252,214,92,224,2,0,0,255,255,3,0,191,237,31,120,235,108,52,158,0,0,0,0,73,69,78,68,174,66,96,130);

tep_disk20
:array[0..230] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,174,73,68,65,84,120,1,98,96,24,5,132,66,128,17,164,224,207,159,63,96,117,179,102,205,250,69,72,3,178,124,90,90,26,27,136,207,194,194,194,192,2,147,0,25,34,41,41,9,227,18,69,131,244,192,12,99,34,74,7,17,138,192,94,155,54,109,26,201,174,129,153,253,252,249,115,134,172,172,44,54,176,215,64,206,35,53,124,96,6,129,244,2,13,98,128,187,104,235,214,173,48,57,146,104,111,111,111,132,139,80,116,174,55,130,112,3,207,129,233,245,48,62,138,34,6,134,64,168,60,76,24,30,107,48,1,116,26,93,3,186,60,140,143,105,16,154,77,3,227,34,104,162,34,41,85,195,188,4,139,53,24,127,148,166,67,8,0,0,0,0,255,255,3,0,17,133,51,82,143,237,58,122,0,0,0,0,73,69,78,68,174,66,96,130);

tep_cd20
:array[0..331] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,1,19,73,68,65,84,120,1,220,147,219,13,195,32,12,69,105,85,101,135,172,209,53,88,35,63,101,32,242,147,53,88,35,107,100,135,254,180,92,156,107,135,199,0,85,145,18,44,63,14,215,22,56,247,43,235,86,132,124,122,57,113,141,239,214,27,94,97,106,125,46,19,30,173,147,197,222,123,13,29,199,92,236,184,186,2,110,97,119,205,204,6,0,222,47,110,4,64,222,243,185,148,143,7,177,86,33,4,72,0,39,203,233,243,124,48,87,119,192,174,32,133,104,70,101,24,104,4,99,106,25,108,140,104,3,51,144,34,6,109,55,53,156,15,98,251,190,185,16,194,212,12,22,201,53,40,165,45,207,104,201,126,1,141,20,13,218,65,178,20,0,128,37,123,13,47,129,243,55,128,88,88,20,184,83,9,252,0,241,179,60,109,231,218,171,72,150,214,8,178,18,90,166,172,40,193,229,193,144,250,101,173,181,49,180,200,75,167,74,174,73,84,101,67,148,25,181,67,103,77,245,118,112,129,112,145,218,101,48,137,164,148,84,69,247,118,32,143,239,99,4,3,162,2,156,167,117,237,176,
79,194,206,60,221,24,87,199,255,25,95,0,0,0,255,255,3,0,248,210,98,205,94,68,155,230,0,0,0,0,73,69,78,68,174,66,96,130);

tep_removable20
:array[0..264] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,208,73,68,65,84,120,1,204,147,187,17,195,32,16,68,207,30,70,61,208,134,219,32,82,19,4,20,68,64,19,138,104,67,109,208,131,135,192,62,204,218,3,210,240,137,100,37,167,227,216,119,203,143,232,223,190,27,27,138,49,78,251,114,206,61,181,214,11,11,133,16,36,70,8,44,170,231,1,130,241,46,8,144,90,8,0,226,29,63,173,216,131,176,182,9,130,155,86,19,212,138,205,158,17,50,0,78,139,205,102,136,148,18,13,134,34,107,0,107,46,109,136,150,39,165,165,89,107,167,221,160,73,8,129,140,49,75,58,126,182,55,187,63,0,177,246,13,162,175,35,239,61,106,83,81,41,245,115,84,40,183,199,39,93,247,20,55,228,197,36,162,53,215,49,220,189,217,181,0,194,58,30,65,85,167,107,28,229,75,117,120,225,181,253,179,28,167,118,86,187,118,236,5,0,0,255,255,3,0,126,71,70,95,77,198,53,85,0,0,0,0,73,69,78,68,174,66,96,130);

tep_menu20
:array[0..160] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,104,73,68,65,84,120,1,98,252,255,255,63,3,37,128,137,18,205,32,189,44,48,3,24,27,25,72,114,202,255,122,6,70,184,1,32,205,13,245,48,163,136,163,65,122,64,134,80,236,5,70,88,32,146,235,5,184,1,196,57,28,83,21,197,94,160,94,44,252,175,7,199,10,166,27,113,136,48,54,2,67,111,52,22,192,161,67,189,88,24,205,11,56,146,27,17,194,0,0,0,0,255,255,3,0,122,28,57,24,42,2,41,40,0,0,0,0,73,69,78,68,174,66,96,130);

tep_invert20
:array[0..185] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,129,73,68,65,84,120,1,98,96,24,40,192,8,178,248,63,14,219,141,107,79,252,194,38,117,182,217,130,13,164,145,5,155,36,72,12,164,241,68,179,17,86,105,176,161,64,3,152,176,202,18,41,56,18,53,227,12,109,228,48,179,168,61,135,204,101,192,136,42,244,56,61,81,107,193,192,80,203,192,96,209,124,2,172,24,69,55,148,3,182,25,28,167,32,197,36,130,145,24,85,20,249,25,158,37,209,163,10,22,240,160,56,133,177,145,105,176,70,100,1,186,178,1,0,0,0,255,255,3,0,35,64,31,199,229,150,205,222,0,0,0,0,73,69,78,68,174,66,96,130);

tep_tick20
:array[0..197] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,141,73,68,65,84,120,1,98,96,24,5,140,160,32,248,15,196,169,181,39,126,129,216,179,155,45,216,64,52,8,192,196,64,108,100,113,16,31,4,64,154,193,6,164,0,53,167,164,24,129,5,231,204,57,7,86,12,210,12,19,3,73,192,196,193,138,160,4,72,51,19,178,0,62,54,200,48,100,23,193,212,18,109,0,72,3,54,67,72,50,0,155,33,36,27,128,110,8,89,6,128,12,129,1,178,12,64,142,17,146,13,64,214,12,114,5,73,6,160,107,38,201,0,108,154,65,6,80,156,148,65,134,140,116,0,0,0,0,255,255,3,0,222,112,60,22,45,250,176,216,0,0,0,0,73,69,78,68,174,66,96,130);

tep_untick20
:array[0..125] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,6,0,0,0,20,8,6,0,0,0,174,210,76,216,0,0,0,69,73,68,65,84,120,1,98,96,160,61,96,4,89,241,31,136,83,107,79,252,2,177,103,55,91,176,129,4,193,18,41,64,193,148,20,35,144,56,195,156,57,231,24,230,0,37,153,192,60,44,196,112,145,192,25,36,88,252,76,117,33,0,0,0,0,255,255,3,0,200,73,17,22,47,137,161,14,0,0,0,0,73,69,78,68,174,66,96,130);

tep_ticktwo20
:array[0..142] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,10,0,0,0,20,8,6,0,0,0,180,238,172,86,0,0,0,86,73,68,65,84,120,1,98,96,24,137,128,17,228,233,255,80,159,3,57,191,144,3,1,40,206,6,226,131,20,49,193,36,208,21,65,21,192,53,130,77,4,10,194,5,96,26,209,104,54,184,137,104,18,24,92,26,41,132,249,14,195,62,160,0,76,14,110,53,76,0,89,49,54,49,100,249,225,207,6,0,0,0,255,255,3,0,8,19,10,25,13,69,178,15,0,0,0,0,73,69,78,68,174,66,96,130);

tep_unticktwo20
:array[0..139] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,10,0,0,0,20,8,6,0,0,0,180,238,172,86,0,0,0,83,73,68,65,84,120,1,98,96,24,137,128,17,228,233,255,80,159,3,57,191,144,3,1,40,206,6,226,131,20,177,192,36,64,138,96,18,216,196,192,38,2,37,48,20,33,43,6,178,217,152,96,2,132,104,26,41,4,121,2,221,199,32,167,32,123,16,236,25,98,130,135,144,31,134,167,60,0,0,0,255,255,3,0,39,81,17,16,40,12,45,191,0,0,0,0,73,69,78,68,174,66,96,130);

tep_tickthree20
:array[0..95] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,10,0,0,0,20,8,6,0,0,0,180,238,172,86,0,0,0,39,73,68,65,84,120,1,98,96,24,137,128,17,234,233,95,4,60,207,198,68,64,1,92,122,100,42,132,123,127,68,49,0,0,0,0,255,255,3,0,81,60,1,16,143,71,238,21,0,0,0,0,73,69,78,68,174,66,96,130);

tep_untickthree20
:array[0..114] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,10,0,0,0,20,8,6,0,0,0,180,238,172,86,0,0,0,58,73,68,65,84,120,1,98,96,24,137,128,17,234,233,95,4,60,207,198,2,83,240,159,129,129,13,198,70,166,129,38,129,13,97,66,22,196,199,30,10,10,225,190,134,249,14,159,135,70,158,28,0,0,0,255,255,3,0,99,11,4,15,218,26,117,171,0,0,0,0,73,69,78,68,174,66,96,130);

tep_screen20
:array[0..209] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,20,8,6,0,0,0,141,137,29,13,0,0,0,153,73,68,65,84,120,1,204,148,49,14,128,32,12,0,139,49,60,182,127,96,226,15,60,150,5,139,74,32,40,8,173,38,118,32,37,208,227,24,90,128,151,67,237,188,64,171,50,94,196,14,86,3,209,14,32,24,239,156,17,241,16,45,213,91,189,136,40,103,49,98,166,172,57,157,207,74,80,170,102,27,222,193,34,116,218,176,5,98,25,62,193,134,13,71,64,195,134,51,176,174,225,44,168,107,200,133,93,12,37,160,100,248,81,47,199,225,208,138,114,104,196,1,208,11,210,99,119,74,139,155,191,92,223,40,205,234,179,150,233,23,134,245,219,255,219,111,0,0,0,255,255,3,0,75,5,29,112,214,18,235,12,0,0,0,0,73,69,78,68,174,66,96,130);

tep_wrap20
:array[0..200] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,144,73,68,65,84,120,1,98,96,24,86,128,17,228,155,148,148,95,191,200,241,85,75,203,59,54,9,9,9,6,38,114,52,195,244,212,212,8,129,45,103,1,9,76,155,118,14,38,78,52,157,149,101,4,87,75,145,75,96,166,208,198,16,100,103,194,108,34,68,163,184,132,28,3,64,22,192,13,33,215,0,144,33,224,216,65,55,0,157,15,82,136,15,192,93,130,79,17,46,57,80,98,3,201,129,83,236,139,23,47,24,96,9,7,36,8,147,4,177,9,1,148,20,75,138,70,116,131,81,188,67,137,65,232,6,143,116,62,0,0,0,255,255,3,0,202,194,28,51,214,92,13,234,0,0,0,0,73,69,78,68,174,66,96,130);


//file format teps -------------------------------------------------------------
tep_Quoter20
:array[0..254] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,21,0,0,0,20,8,6,0,0,0,98,75,118,51,0,0,0,198,73,68,65,84,120,1,228,148,77,10,195,32,16,133,109,144,30,168,139,92,34,139,94,194,69,143,148,133,151,232,53,122,164,226,34,60,65,121,121,198,177,165,208,77,6,66,252,121,239,155,25,17,157,59,117,92,208,125,74,41,31,194,124,127,188,245,52,94,207,245,170,107,150,206,123,239,38,53,132,16,28,127,71,0,120,88,131,49,235,42,20,139,216,28,69,79,199,224,10,69,155,49,198,134,201,98,108,246,116,108,172,208,158,1,137,244,92,71,224,29,180,7,230,42,202,88,193,156,188,129,22,211,47,255,255,67,185,37,171,114,213,53,149,150,43,163,66,133,90,186,6,10,243,8,168,9,116,190,131,34,59,4,122,133,212,100,85,9,109,133,126,3,132,209,234,38,63,40,183,37,124,92,33,128,86,39,120,80,78,30,27,0,0,0,255,255,3,0,191,133,122,152,99,46,205,92,0,0,0,0,73,69,78,68,174,66,96,130);

tep_sfef20
:array[0..456] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,1,144,73,68,65,84,120,1,148,149,221,109,195,48,12,132,153,162,200,14,202,24,204,24,202,24,238,24,121,202,24,245,24,213,24,213,24,213,14,126,73,121,148,37,232,47,86,43,192,49,37,30,63,158,105,3,57,145,172,39,126,38,235,227,190,108,144,124,62,214,243,68,74,39,17,188,205,68,200,43,212,174,68,114,165,6,179,186,41,56,67,19,233,143,112,184,126,57,138,219,98,55,178,46,33,235,187,179,244,181,186,225,88,14,71,113,8,69,11,105,168,154,186,93,222,13,29,107,1,215,78,141,49,90,20,66,200,197,26,248,222,249,208,241,205,202,227,183,80,33,44,198,234,21,241,5,91,180,90,83,28,33,124,47,247,87,203,17,218,152,74,110,163,214,80,231,90,224,87,226,237,219,249,60,243,252,85,68,168,47,251,16,158,158,229,167,4,203,78,207,112,94,45,246,164,140,253,80,103,204,112,106,122,232,221,46,85,109,187,121,184,85,220,55,167,129,201,139,243,232,184,77,54,218,127,109,119,86,254,42,46,108,54,195,117,7,60,44,198,128,203,50,43,127,
117,241,107,129,178,157,117,240,134,126,124,56,3,154,193,168,2,156,76,13,199,185,101,67,139,181,8,9,96,231,123,13,133,8,133,6,208,252,242,112,128,110,36,93,219,85,206,177,140,179,110,119,154,247,18,84,142,83,226,98,122,231,44,174,177,124,235,22,78,131,24,42,86,55,138,34,71,39,67,91,251,69,149,121,196,112,255,12,84,65,113,126,8,222,5,50,115,68,131,5,40,245,80,40,187,25,183,229,90,56,120,79,116,0,77,140,225,140,83,50,221,69,164,255,30,105,255,202,105,202,79,29,39,97,9,42,227,148,31,221,127,1,0,0,255,255,3,0,144,115,146,167,32,251,0,205,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_choco20
:array[0..385] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,1,73,73,68,65,84,120,1,180,148,203,81,197,48,12,69,3,67,138,120,109,208,6,109,188,21,61,176,162,7,86,244,192,138,54,104,131,34,178,65,199,248,100,252,137,120,12,195,211,140,35,89,159,43,249,218,147,101,185,182,108,219,246,242,159,61,110,4,75,128,63,35,206,250,141,156,214,117,125,54,241,86,163,234,83,232,251,100,61,132,159,69,206,145,116,254,35,224,54,161,109,132,237,222,38,232,67,41,192,149,6,11,73,212,86,183,197,227,137,200,153,228,110,242,244,14,248,253,168,139,8,32,35,29,52,122,39,216,74,153,56,72,127,12,231,120,81,130,146,127,174,11,91,49,126,56,241,200,177,69,104,27,49,145,197,104,109,78,162,232,115,191,100,28,147,64,97,11,132,77,19,26,34,114,253,189,27,190,25,199,78,75,58,54,160,104,167,132,103,108,192,145,105,226,2,12,199,245,101,8,98,50,123,47,198,24,160,216,173,76,192,25,199,30,155,98,64,88,76,231,139,32,174,29,230,44,63,113,12,16,175,1,0,245,52,89,196,118,95,156,250,41,246,69,
50,142,141,83,180,23,234,76,116,71,79,153,56,121,199,73,253,228,222,1,219,159,208,56,177,73,234,9,37,113,144,223,213,148,223,102,112,243,86,3,93,48,1,201,220,165,54,166,126,37,161,251,31,87,74,178,194,139,254,24,144,75,94,4,191,88,240,151,132,47,0,0,0,255,255,3,0,198,137,89,27,38,65,2,110,0,0,0,0,73,69,78,68,174,66,96,130);

tep_choco20
:array[0..481] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,1,169,73,68,65,84,120,1,180,148,193,109,195,48,12,69,213,162,71,251,80,159,172,1,60,128,187,70,215,200,26,217,164,107,100,141,44,224,1,156,147,123,176,7,40,31,35,218,84,34,35,69,145,10,72,40,145,212,231,231,151,172,16,254,105,188,128,59,77,211,81,204,248,222,52,95,207,168,3,168,1,127,202,252,3,112,3,94,150,37,140,227,186,52,119,209,74,238,216,247,61,196,206,36,0,250,198,68,28,167,239,105,138,50,5,28,27,171,170,10,93,215,133,97,24,100,41,142,136,59,172,107,93,108,68,96,112,74,62,53,175,110,97,192,43,184,196,162,128,235,79,10,81,44,182,109,107,133,153,147,235,243,87,56,101,44,108,15,46,97,13,218,196,36,169,235,90,153,27,123,226,151,203,197,210,50,171,192,226,161,21,47,168,246,141,206,38,5,187,0,65,30,100,178,33,243,145,188,219,161,82,160,177,4,50,112,15,42,45,7,126,140,121,158,213,210,5,69,83,145,235,1,104,228,250,231,53,118,238,237,144,96,72,235,200,192,192,82,20,246,88,243,103,155,101,
81,212,216,183,230,219,134,53,140,41,116,43,73,17,88,156,153,12,62,201,138,0,104,7,5,75,100,160,16,69,124,113,219,171,140,211,61,230,218,80,32,211,203,31,30,155,96,106,58,155,12,187,192,108,240,163,148,72,220,218,39,14,168,229,165,2,25,33,61,188,210,61,150,79,84,91,101,51,45,27,168,17,48,208,180,6,52,10,14,93,235,216,187,199,26,244,31,66,202,223,51,254,27,216,128,11,26,223,37,238,33,58,255,89,112,244,17,194,103,140,153,3,70,32,211,138,192,47,198,29,17,123,54,15,178,25,192,226,231,249,0,88,65,69,115,44,79,231,232,223,227,167,60,244,233,233,13,141,128,63,32,243,247,240,15,0,0,0,255,255,3,0,11,47,169,203,110,15,34,7,0,0,0,0,73,69,78,68,174,66,96,130);

tep_bmp20
:array[0..397] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,1,85,73,68,65,84,120,1,212,82,203,105,4,49,12,85,66,72,9,1,181,225,83,74,8,184,141,57,45,164,129,133,57,45,164,132,57,77,27,3,41,97,79,110,67,61,236,41,239,201,223,153,77,32,183,16,179,94,75,214,211,211,147,60,34,127,189,30,40,96,94,174,183,223,10,121,63,189,62,87,236,11,140,167,234,204,83,168,230,221,105,102,126,183,110,38,103,20,251,24,72,26,193,49,171,38,141,247,155,168,187,111,243,245,246,121,201,74,30,43,96,76,24,237,26,231,57,67,36,247,164,42,231,121,241,182,119,10,108,61,137,164,148,115,114,177,98,195,225,47,44,238,107,132,157,162,172,240,118,4,130,94,19,118,64,133,187,165,1,73,23,33,102,149,9,152,60,179,29,65,218,146,108,200,52,75,40,216,73,84,76,84,179,50,159,231,212,233,119,4,26,89,133,64,149,16,58,129,195,233,39,16,245,92,183,26,129,63,20,164,83,218,10,18,80,237,160,202,182,34,180,224,41,89,32,63,108,153,129,209,53,23,202,88,1,116,2,230,26,226,68,80,67,166,200,252,89,65,161,
35,200,129,33,2,84,94,131,116,32,224,230,58,54,209,90,24,131,181,146,103,224,47,161,247,208,62,212,174,140,241,129,192,36,98,136,173,110,109,178,176,240,222,175,64,228,243,45,241,66,64,47,51,55,254,102,20,134,31,142,54,3,190,158,15,179,1,15,18,120,255,205,85,131,255,95,227,11,0,0,255,255,3,0,229,34,110,4,172,6,254,219,0,0,0,0,73,69,78,68,174,66,96,130);

tep_wma20
:array[0..526] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,1,214,73,68,65,84,120,1,204,84,49,82,196,48,12,212,49,204,241,6,55,124,128,206,20,12,111,112,5,111,48,5,121,3,161,32,188,33,20,231,55,220,53,248,13,12,141,59,62,64,227,55,144,6,118,229,216,119,129,130,246,52,227,68,150,165,213,74,114,34,114,44,178,34,145,231,239,111,229,243,245,242,62,253,71,236,236,254,106,125,232,243,176,90,201,233,161,129,122,239,109,51,229,166,137,100,108,98,76,194,68,41,69,185,222,60,53,176,63,32,140,171,193,12,52,166,0,208,158,178,193,30,6,172,183,187,199,169,2,157,240,240,80,42,64,181,17,168,74,239,141,56,155,177,96,49,190,154,151,229,48,83,215,13,237,176,41,46,75,111,71,221,146,73,33,147,37,128,13,140,235,86,206,197,251,231,180,141,55,50,246,72,19,179,100,63,138,201,131,84,200,97,24,196,123,95,202,105,232,69,209,114,8,48,116,0,176,168,23,98,198,157,88,234,200,238,77,95,60,193,38,132,128,6,239,235,171,186,130,240,176,1,184,81,82,2,147,217,151,244,157,44,129,10,
234,254,169,229,40,98,33,161,193,33,210,33,139,53,88,51,187,26,66,223,202,160,218,202,116,114,210,61,251,64,22,146,65,27,253,137,161,19,246,66,37,214,44,169,248,192,168,227,198,187,52,214,88,25,80,59,202,214,206,103,92,38,129,141,226,253,92,138,238,150,143,202,72,65,42,34,141,214,90,241,253,78,189,157,43,217,35,166,213,11,216,2,187,91,226,232,78,65,56,58,210,78,182,23,11,160,26,76,15,150,7,158,34,0,236,2,12,122,79,76,107,60,125,20,228,227,234,124,13,54,19,25,225,243,208,101,144,217,153,32,115,39,244,238,48,210,224,30,241,178,65,253,213,19,160,241,59,216,94,94,78,198,58,156,122,204,6,163,37,2,74,161,116,96,196,51,155,157,4,48,179,217,171,157,143,197,175,64,47,29,167,49,79,171,121,85,101,110,54,25,179,127,183,175,155,53,127,5,199,35,63,0,0,0,255,255,3,0,33,134,198,167,16,153,52,65,0,0,0,0,73,69,78,68,174,66,96,130);

tep_r20
:array[0..198] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,142,73,68,65,84,120,1,204,148,221,10,192,32,8,70,63,199,214,91,183,139,245,214,238,194,205,65,16,246,3,66,176,188,145,34,143,199,160,128,85,130,84,68,68,64,231,205,94,41,185,142,64,68,248,32,136,204,49,122,17,64,74,111,77,10,97,243,151,214,21,123,189,5,196,160,45,234,72,220,214,117,153,244,224,77,147,236,80,118,238,1,244,172,203,36,195,109,158,2,25,142,99,71,40,199,43,109,92,38,22,154,65,67,147,178,115,15,160,32,151,73,238,108,243,20,200,58,111,103,202,87,96,239,232,191,245,3,0,0,255,255,3,0,21,42,38,49,40,142,190,105,0,0,0,0,73,69,78,68,174,66,96,130);

tep_xml20
:array[0..230] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,174,73,68,65,84,120,1,98,96,24,44,128,17,228,144,255,255,255,51,164,50,214,253,34,213,81,179,255,55,177,49,50,50,50,176,128,52,130,12,168,253,181,149,84,51,128,250,24,64,22,179,49,145,172,19,139,6,172,134,108,149,159,198,0,194,200,0,155,24,76,30,171,33,48,73,98,105,218,25,226,253,48,11,236,8,152,151,96,52,76,28,221,133,4,93,2,51,0,93,35,50,31,167,33,232,182,162,243,137,50,4,221,5,232,124,162,12,129,41,194,231,2,152,26,172,222,129,217,10,51,0,70,195,196,97,154,97,52,86,67,96,146,196,210,84,49,4,156,1,209,109,132,57,31,89,28,155,24,76,158,42,69,1,204,176,129,167,1,0,0,0,255,255,3,0,61,202,49,103,160,120,76,109,0,0,0,0,73,69,78,68,174,66,96,130);

tep_htm20
:array[0..191] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,135,73,68,65,84,120,1,204,148,81,10,192,32,8,134,117,12,15,180,251,109,15,219,253,118,160,94,28,6,63,196,176,129,96,172,32,164,95,212,79,139,136,102,89,108,32,170,74,124,112,137,66,233,169,194,204,180,90,96,77,176,111,209,28,40,44,75,56,210,9,168,36,111,189,92,119,149,164,161,243,52,196,165,144,204,147,196,157,9,122,197,28,112,238,217,241,237,216,237,96,247,40,76,31,79,242,85,189,245,165,144,184,183,211,190,84,84,244,52,248,82,72,82,190,2,16,253,111,31,0,0,0,255,255,3,0,130,87,29,164,69,112,250,15,0,0,0,0,73,69,78,68,174,66,96,130);

tep_exe20
:array[0..217] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,161,73,68,65,84,120,1,204,212,49,14,128,32,12,5,208,214,24,78,231,226,33,60,134,215,112,241,16,46,158,206,5,243,77,74,42,2,133,196,68,89,104,135,255,90,22,136,254,114,24,139,120,239,105,224,233,104,93,106,247,171,99,102,234,17,4,176,208,220,106,200,96,215,53,39,19,129,87,144,235,57,55,252,24,111,109,104,220,22,202,184,168,219,164,0,0,180,17,3,168,67,114,207,83,111,202,111,162,55,48,160,52,34,128,220,152,90,128,158,136,14,34,172,251,12,244,68,16,140,143,1,213,33,64,5,146,91,13,170,71,52,164,0,148,109,72,20,150,246,149,175,64,176,239,239,19,0,0,255,255,3,0,21,188,34,210,61,4,58,6,0,0,0,0,73,69,78,68,174,66,96,130);

tep_c2p20
:array[0..200] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,144,73,68,65,84,120,1,204,148,193,14,128,32,8,64,161,53,255,218,14,250,215,94,8,60,41,146,139,141,173,152,181,104,240,124,120,16,224,47,129,34,66,68,112,93,216,188,82,165,80,66,68,232,144,156,161,101,126,121,163,214,10,188,210,225,109,180,234,87,72,226,178,221,99,80,86,136,81,52,253,146,13,84,156,42,159,83,125,212,6,64,26,252,38,243,54,61,11,129,236,199,121,208,215,50,126,19,125,78,76,220,155,24,13,218,66,114,191,137,65,9,129,172,227,188,28,97,20,10,49,9,185,10,70,171,111,191,111,0,0,0,255,255,3,0,44,39,24,80,252,151,184,48,0,0,0,0,73,69,78,68,174,66,96,130);

tep_c2v20
:array[0..208] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,152,73,68,65,84,120,1,204,148,65,10,128,32,16,69,255,68,121,210,174,81,139,186,70,39,181,133,49,193,7,25,21,19,140,18,34,255,76,189,121,182,8,248,203,18,21,9,33,96,149,211,183,74,109,97,114,34,130,27,178,192,251,185,25,1,28,14,216,225,220,208,58,61,247,124,2,81,186,94,185,85,234,37,144,220,203,181,90,2,225,183,177,54,204,236,199,224,4,18,55,159,238,223,131,80,153,71,224,157,117,107,248,158,137,157,84,203,69,19,170,215,142,162,3,138,144,218,244,184,63,198,193,238,105,99,235,54,119,49,233,242,43,176,102,223,229,11,0,0,255,255,3,0,163,54,34,100,122,181,110,147,0,0,0,0,73,69,78,68,174,66,96,130);

tep_zip20
:array[0..218] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,162,73,68,65,84,120,1,98,96,24,44,128,17,228,144,255,255,255,51,48,50,214,253,34,213,81,255,255,55,177,49,50,50,50,176,128,52,130,12,72,73,49,34,213,12,152,197,108,76,36,235,196,162,1,236,18,116,241,57,211,188,209,133,224,252,148,172,173,112,54,140,65,59,151,96,179,13,100,43,46,23,18,237,18,92,6,128,12,39,202,16,152,1,184,92,72,208,16,66,6,16,116,9,49,6,224,53,132,88,3,112,26,66,138,1,32,67,176,38,54,144,4,8,192,12,131,240,32,36,182,192,37,24,176,200,6,224,98,99,117,9,54,219,112,25,0,18,167,74,81,128,207,2,250,202,1,0,0,0,255,255,3,0,240,211,45,29,185,197,119,202,0,0,0,0,73,69,78,68,174,66,96,130);

tep_txt20
:array[0..333] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,1,21,73,68,65,84,120,1,204,83,177,145,3,33,12,212,255,120,220,3,109,16,125,15,68,238,65,14,76,15,68,238,225,62,161,135,115,66,15,142,104,131,30,46,249,215,98,235,142,49,204,5,14,126,94,51,32,161,213,74,66,12,68,127,45,31,40,248,35,235,54,185,197,24,162,148,50,25,49,172,53,36,102,21,103,225,55,226,47,116,185,166,35,72,159,15,72,128,204,20,19,215,163,49,174,6,90,27,36,65,160,156,37,145,115,21,251,158,166,5,198,1,219,153,231,197,73,218,156,78,196,225,78,241,10,61,87,13,156,39,241,249,47,10,162,189,247,112,81,109,149,65,100,201,138,94,71,34,126,69,64,140,49,30,215,86,71,241,123,190,218,106,27,32,217,214,163,181,50,21,17,189,223,10,136,209,17,153,31,3,106,131,70,118,71,108,43,42,1,149,221,115,170,234,235,136,33,4,197,118,117,71,44,165,244,132,102,170,10,118,196,183,91,29,14,103,240,190,195,138,24,134,62,133,182,246,170,59,98,91,49,235,125,115,38,220,29,11,31,0,178,253,142,249,190,148,178,5,180,
21,52,24,250,226,125,253,29,45,254,207,237,95,0,0,0,255,255,3,0,174,15,94,234,212,32,104,99,0,0,0,0,73,69,78,68,174,66,96,130);

tep_pas20
:array[0..305] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,249,73,68,65,84,120,1,204,146,49,22,195,32,12,67,105,95,31,151,99,202,73,51,229,114,44,173,5,21,40,196,238,208,41,30,98,3,230,35,59,78,233,110,246,128,160,183,168,178,141,42,203,48,180,59,153,135,128,188,184,80,95,235,111,86,206,57,225,65,133,61,21,160,241,113,28,109,25,121,28,170,250,16,84,74,73,128,120,94,31,36,204,45,13,137,17,4,251,40,157,231,40,19,246,151,34,66,224,105,33,8,47,121,101,41,4,231,52,183,52,64,32,159,178,247,125,15,161,4,97,4,218,28,177,105,243,215,143,49,49,96,79,215,222,80,217,247,177,220,64,150,102,57,156,157,9,232,215,231,23,192,21,182,109,27,18,58,8,147,13,69,40,33,50,92,88,33,232,17,21,157,154,93,74,163,55,150,23,179,28,245,124,248,4,50,81,220,55,127,141,189,191,200,11,11,72,251,115,141,85,9,161,4,73,179,177,5,21,0,248,158,127,15,153,139,229,49,71,61,137,42,34,223,70,133,135,131,69,53,99,227,22,193,7,0,0,255,255,3,0,77,172,165,166,254,60,151,32,0,0,0,0,73,69,
78,68,174,66,96,130);

tep_dpr20//09nov2025
:array[0..320] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,1,8,73,68,65,84,120,1,204,84,65,18,131,32,12,164,157,142,15,242,27,158,120,16,61,148,7,249,19,31,228,165,221,13,4,3,232,180,245,36,51,76,22,72,54,155,128,58,119,181,113,163,160,119,86,245,12,97,61,35,48,198,56,60,218,192,24,67,187,213,173,87,164,27,6,231,104,65,34,231,162,40,156,84,162,25,42,69,103,148,64,64,81,84,74,11,33,73,212,44,123,150,85,32,22,193,253,169,33,250,222,27,27,174,189,209,189,187,130,214,14,236,230,31,163,35,34,1,231,138,43,81,252,11,95,41,77,21,144,32,13,146,101,148,213,109,103,61,181,16,177,222,205,169,47,201,18,110,126,53,153,16,241,26,169,104,158,103,183,44,169,233,227,56,2,47,226,77,236,189,55,201,18,137,109,120,213,163,105,242,37,205,17,46,14,0,47,124,26,156,220,171,136,240,232,141,95,143,169,64,167,113,20,40,165,145,21,111,12,145,36,215,247,212,226,164,160,37,208,181,124,107,88,228,30,82,5,9,246,45,47,15,127,10,58,84,131,36,230,250,121,166,62,71,182,138,191,248,
226,3,0,0,255,255,3,0,237,71,96,56,222,2,60,3,0,0,0,0,73,69,78,68,174,66,96,130);

tep_ref320
:array[0..225] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,169,73,68,65,84,120,1,204,148,73,10,128,48,12,69,163,136,231,10,120,46,87,158,75,200,185,186,210,143,126,171,113,170,118,161,129,146,164,166,47,131,165,34,153,82,224,188,153,137,246,26,82,88,214,88,205,56,85,157,205,86,66,170,200,24,139,132,88,81,30,0,144,136,144,215,0,66,0,168,34,101,178,234,110,105,113,243,41,180,87,35,114,45,160,68,47,126,15,62,50,148,155,52,47,156,108,192,110,6,44,194,207,226,108,6,167,0,30,0,136,54,225,107,157,221,194,45,0,217,125,59,151,21,48,152,154,193,222,231,254,164,15,254,187,191,7,222,255,207,61,120,252,30,176,119,188,11,241,61,224,238,23,122,0,0,0,255,255,3,0,223,75,13,118,156,150,223,244,0,0,0,0,73,69,78,68,174,66,96,130);

tep_c320
:array[0..222] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,166,73,68,65,84,120,1,220,84,65,10,128,32,16,220,34,124,84,39,161,119,121,242,93,193,158,122,148,167,28,83,33,93,35,233,32,180,144,202,56,51,173,187,176,68,31,99,130,158,153,105,213,187,123,227,117,240,166,18,79,107,125,29,29,25,247,58,60,23,63,196,135,152,195,218,179,56,115,203,118,233,209,102,46,76,148,197,147,85,219,64,217,204,15,7,47,146,66,54,128,184,20,72,152,119,172,107,208,32,86,134,49,157,218,64,202,243,1,251,165,1,170,95,182,16,53,144,48,15,203,109,148,76,202,182,198,194,202,6,184,108,8,162,46,111,227,187,208,61,15,82,238,152,11,121,30,36,112,200,126,2,0,0,255,255,3,0,224,211,86,107,116,136,127,254,0,0,0,0,73,69,78,68,174,66,96,130);

tep_cur20
:array[0..260] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,204,73,68,65,84,120,1,148,82,209,21,131,48,8,196,190,62,118,240,171,107,116,141,78,234,26,174,225,26,252,180,57,90,34,166,68,34,31,230,12,28,119,73,152,232,27,242,38,226,31,78,151,169,84,220,172,170,252,136,225,145,181,18,69,54,186,66,134,42,66,68,86,5,204,79,202,108,31,172,42,75,59,172,67,202,213,170,17,177,66,61,179,237,172,46,158,171,152,249,21,218,14,173,122,182,200,210,85,14,173,142,144,83,34,154,68,202,67,196,136,124,122,57,222,178,97,92,88,9,190,219,6,209,188,67,135,48,16,81,56,226,158,70,177,77,18,118,219,73,10,159,195,70,206,148,122,195,224,20,103,98,126,52,221,99,251,112,81,47,167,99,169,12,255,134,212,161,41,72,170,216,158,65,43,147,207,233,59,162,33,236,255,31,33,233,122,150,254,0,0,0,255,255,3,0,66,63,64,73,108,176,91,7,0,0,0,0,73,69,78,68,174,66,96,130);

tep_xxx20
:array[0..170] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,14,0,0,0,20,8,6,0,0,0,189,5,12,44,0,0,0,114,73,68,65,84,120,1,98,96,24,50,128,17,228,210,255,64,108,92,123,226,23,62,87,159,109,182,96,131,201,131,52,129,53,26,1,53,157,168,53,130,137,163,208,22,205,231,224,124,152,102,144,38,38,184,40,137,12,162,53,130,92,132,236,29,162,53,194,156,12,211,204,66,200,133,232,126,135,25,64,180,141,232,22,140,106,68,15,17,36,62,217,129,67,116,34,135,89,6,74,175,96,77,48,129,193,79,3,0,0,0,255,255,3,0,252,100,28,0,111,38,180,81,0,0,0,0,73,69,78,68,174,66,96,130);

tep_bwd20
:array[0..300] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,0,244,73,68,65,84,120,1,236,146,187,17,194,48,16,68,5,129,102,28,185,23,74,160,3,122,113,234,200,169,107,162,4,122,81,228,25,71,204,122,120,176,150,37,3,185,149,220,103,111,247,116,39,133,112,156,215,6,78,139,237,231,185,180,145,212,77,177,29,155,42,6,199,107,22,78,219,134,69,56,165,20,28,236,47,80,66,232,174,83,28,239,205,60,60,62,57,112,97,100,197,39,63,220,98,60,3,168,19,190,68,68,130,136,5,151,45,229,60,255,22,118,146,124,221,210,115,121,99,199,116,91,199,133,173,132,29,244,209,85,232,171,82,156,55,86,236,83,172,132,69,240,147,147,29,251,230,239,10,67,102,84,30,71,121,38,2,163,22,187,17,174,173,35,31,85,2,76,84,194,54,194,116,196,66,38,254,213,22,133,243,91,123,236,190,214,225,177,55,45,10,123,129,252,210,168,212,212,176,159,132,17,249,199,86,133,25,209,127,2,194,123,24,53,85,97,21,32,224,31,31,226,30,70,205,97,151,13,60,1,0,0,255,255,3,0,104,25,125,251,194,44,94,219,0,0,0,0,73,69,
78,68,174,66,96,130);

tep_bwp20
:array[0..304] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,22,0,0,0,20,8,6,0,0,0,137,124,205,48,0,0,0,248,73,68,65,84,120,1,236,83,187,21,194,48,12,20,20,126,47,85,230,96,3,118,96,29,90,54,96,29,102,97,142,84,121,47,21,62,63,75,156,20,59,129,62,105,100,233,116,167,143,99,145,227,171,27,56,193,46,143,101,105,109,100,190,207,105,120,14,93,76,57,156,3,206,56,142,82,132,167,105,18,6,229,166,20,145,249,146,197,223,89,252,245,141,41,14,76,163,133,95,121,233,154,146,9,35,129,197,81,89,73,17,131,48,139,26,94,227,232,248,204,100,62,151,46,41,224,10,113,247,57,7,13,57,60,199,156,176,3,27,100,170,35,177,48,124,158,194,9,51,17,231,72,142,248,150,191,41,172,68,27,149,46,85,47,211,48,77,174,118,37,220,91,71,28,21,124,157,168,133,173,132,67,97,35,199,248,158,223,20,142,93,179,207,103,172,195,249,84,173,41,76,120,57,182,70,213,156,30,246,147,176,138,252,99,187,194,54,34,255,9,85,121,11,211,226,238,73,107,144,109,111,84,228,244,48,60,233,227,179,13,124,0,0,0,255,255,3,0,22,214,123,231,63,107,214,165,
0,0,0,0,73,69,78,68,174,66,96,130);

tep_rtf20
:array[0..190] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,21,0,0,0,20,8,6,0,0,0,98,75,118,51,0,0,0,134,73,68,65,84,120,1,236,144,65,10,128,48,12,4,163,72,127,237,201,95,247,36,123,24,48,209,170,53,32,8,246,18,146,237,78,182,53,251,207,39,126,96,80,202,58,91,141,105,203,98,165,165,105,46,189,229,27,35,140,254,200,128,118,85,29,84,219,73,136,49,206,98,175,123,204,240,58,40,160,108,157,182,128,167,79,198,71,82,7,101,1,34,125,111,117,207,7,198,230,187,48,249,240,202,227,160,26,32,246,130,229,229,236,160,8,153,122,10,205,164,205,132,250,189,47,253,192,10,0,0,255,255,3,0,100,211,32,31,127,91,54,196,0,0,0,0,73,69,78,68,174,66,96,130);

tep_dic20
:array[0..196] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,140,73,68,65,84,120,1,236,144,193,10,128,48,12,67,171,200,254,218,147,127,189,147,4,121,144,201,168,138,232,105,187,116,105,178,100,109,196,56,191,109,96,82,210,26,181,122,226,22,165,128,225,188,7,231,117,118,192,157,199,224,59,181,49,82,42,201,152,121,47,51,92,50,82,156,27,162,165,39,76,112,243,35,132,89,117,19,233,192,143,140,120,212,27,247,114,180,236,119,140,37,205,43,35,255,97,99,4,161,4,79,19,214,81,79,26,215,29,76,68,119,71,61,19,30,156,185,51,70,55,234,135,27,216,1,0,0,255,255,3,0,115,222,41,88,72,220,65,3,0,0,0,0,73,69,78,68,174,66,96,130);

tep_mid20
:array[0..233] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,20,8,6,0,0,0,107,160,214,73,0,0,0,177,73,68,65,84,120,1,98,96,24,5,232,33,192,8,22,248,143,46,140,201,255,149,186,254,23,166,40,3,3,219,156,64,54,38,108,18,164,138,145,100,8,219,236,64,54,100,12,179,140,5,196,144,76,157,134,213,169,48,69,48,26,151,58,176,33,207,103,103,177,193,20,130,104,144,255,65,54,34,139,49,0,197,208,213,129,196,64,106,112,186,4,155,173,216,196,224,134,96,179,129,88,49,144,33,224,40,150,76,65,13,147,135,12,146,12,242,12,207,65,242,96,0,226,131,0,54,49,80,20,99,77,39,200,97,130,156,62,96,225,132,34,6,51,132,170,46,65,177,1,61,118,192,30,194,66,0,253,130,53,177,193,156,141,69,203,168,16,145,33,0,0,0,0,255,255,3,0,17,244,78,58,124,245,216,77,0,0,0,0,73,69,78,68,174,66,96,130);

tep_notes20
:array[0..251] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,18,0,0,0,20,8,6,0,0,0,128,151,109,74,0,0,0,195,73,68,65,84,120,1,220,146,209,9,195,48,12,68,221,98,178,68,135,42,221,33,100,168,144,29,74,135,234,18,193,31,229,76,79,168,135,80,67,154,175,26,130,34,157,244,44,217,46,229,160,117,2,167,181,22,226,230,235,115,133,48,61,46,67,152,240,14,214,90,75,205,18,168,17,72,31,86,225,155,64,30,192,127,129,15,103,10,191,218,77,29,233,24,216,84,58,42,187,59,82,248,110,144,30,197,31,131,62,110,77,111,66,207,33,243,237,140,8,25,239,75,150,111,26,243,25,232,29,33,8,192,114,27,251,71,81,173,22,123,221,70,3,36,90,120,47,4,112,179,40,207,70,139,68,255,232,50,8,106,59,200,23,32,8,95,99,89,199,168,177,209,180,16,226,183,229,107,210,209,8,210,14,213,103,222,33,246,5,0,0,255,255,3,0,115,81,65,42,157,230,23,57,0,0,0,0,73,69,78,68,174,66,96,130);

tep_bell20
:array[0..245] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,16,0,0,0,20,8,6,0,0,0,132,98,189,119,0,0,0,189,73,68,65,84,120,1,98,96,24,104,192,8,118,192,127,76,103,72,166,78,251,133,44,250,124,118,22,27,50,31,204,6,234,102,194,16,4,10,192,52,63,244,54,98,0,97,16,128,137,129,57,72,4,86,3,64,242,48,141,232,108,36,189,96,38,78,3,208,21,226,226,83,223,0,92,126,5,185,0,155,28,138,11,96,10,144,253,15,115,58,76,12,166,6,38,142,98,0,72,16,166,16,166,0,153,198,38,199,130,172,0,153,45,191,245,28,50,23,167,193,240,132,132,238,52,116,219,208,13,4,39,44,160,110,176,1,146,41,144,84,135,75,19,46,241,231,115,178,216,224,97,128,75,17,200,31,232,182,35,171,133,27,128,79,17,178,6,116,3,169,19,6,12,20,228,70,148,168,26,154,28,0,0,0,0,255,255,3,0,243,199,74,96,178,150,255,206,0,0,0,0,73,69,78,68,174,66,96,130);

tep_sonnerie20
:array[0..301] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,21,0,0,0,20,8,6,0,0,0,98,75,118,51,0,0,0,245,73,68,65,84,120,1,228,147,193,13,194,64,12,4,3,66,244,144,23,61,208,6,109,192,135,130,248,80,7,109,208,3,47,122,224,3,183,14,123,218,108,156,83,254,137,20,217,190,179,199,107,71,233,186,85,63,155,152,254,187,108,7,253,229,246,209,204,247,253,186,215,56,252,66,92,12,5,240,117,58,86,198,225,241,12,127,2,46,196,93,205,74,28,85,166,64,164,34,38,216,75,103,161,174,204,11,91,113,133,170,42,20,184,50,135,64,229,100,244,127,82,236,180,63,15,31,128,32,29,139,103,10,109,1,241,149,170,82,45,86,31,0,143,231,20,178,241,22,14,146,84,157,250,0,106,204,66,90,172,205,87,23,80,7,19,212,130,161,134,48,87,94,161,236,12,155,193,252,140,64,173,163,63,130,114,13,220,161,91,128,85,21,124,188,222,32,253,163,144,68,32,187,195,58,84,239,80,19,13,11,113,164,148,73,184,4,192,71,230,125,102,85,113,170,84,139,124,180,80,163,9,238,15,68,63,93,83,252,3,0,0,255,255,3,0,43,78,122,140,188,215,111,64,0,0,0,0,73,69,78,
68,174,66,96,130);


//large images (24h x variable width) ------------------------------------------
tep_info24
:array[0..424] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,13,0,0,0,24,8,6,0,0,0,33,240,119,84,0,0,1,112,73,68,65,84,120,1,140,84,187,113,195,48,12,165,114,89,193,5,215,96,165,194,27,184,210,14,170,180,67,42,239,160,53,88,121,3,23,170,184,6,11,15,225,188,7,17,136,40,70,39,227,142,132,64,224,9,95,178,115,27,90,150,153,146,199,138,88,129,66,206,19,89,194,234,135,129,159,206,125,175,204,118,162,70,239,39,231,9,45,148,179,11,41,185,24,163,27,8,252,82,5,188,24,64,207,148,243,7,33,184,27,228,133,103,2,42,97,73,56,106,120,192,197,70,61,253,192,40,48,172,79,72,65,149,237,54,159,74,81,132,6,116,2,96,21,255,10,65,225,8,128,234,57,84,143,36,69,111,60,137,234,100,251,8,84,188,220,209,35,248,220,133,119,226,192,212,58,17,119,156,176,121,77,175,30,15,177,101,70,180,17,146,240,250,126,157,175,148,100,246,84,183,229,73,231,142,135,150,83,215,185,166,179,172,26,233,114,169,117,6,122,191,69,159,213,219,190,204,162,45,155,129,74,136,61,206,179,122,224,55,86,186,94,139,117,97,93,45,98,140,151,121,196,217,
140,123,68,0,175,194,218,214,141,161,86,143,198,172,2,171,231,245,62,161,63,148,27,144,132,7,0,167,124,12,97,226,164,3,4,105,189,193,51,46,222,237,249,20,217,54,203,137,127,103,46,58,127,228,184,120,164,248,122,153,189,124,24,136,146,2,106,147,86,50,80,206,199,141,221,195,164,122,200,137,129,240,5,146,34,168,17,10,193,33,146,199,68,207,200,173,228,0,50,125,1,255,247,108,109,65,191,0,0,0,255,255,3,0,115,206,106,139,205,12,58,142,0,0,0,0,73,69,78,68,174,66,96,130);

tep_query24
:array[0..500] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,20,0,0,0,24,8,6,0,0,0,250,75,221,118,0,0,1,188,73,68,65,84,120,1,140,149,203,113,2,49,12,134,77,30,219,3,167,244,192,41,61,236,137,30,56,209,131,103,152,113,15,156,232,129,19,61,228,68,27,244,224,76,38,209,111,249,165,149,181,68,12,248,33,237,183,122,217,108,220,154,248,8,237,142,190,15,101,22,38,189,71,70,27,101,88,54,124,60,208,116,231,188,195,184,148,135,11,238,66,155,193,133,73,232,52,208,199,45,89,92,9,132,17,95,91,130,187,147,242,179,135,74,32,195,190,50,204,6,245,154,5,180,1,125,68,120,87,178,237,189,42,161,1,177,53,194,79,129,147,151,1,70,47,248,201,50,211,216,96,80,135,20,14,242,132,213,49,231,45,155,119,3,242,204,209,101,32,22,158,62,107,130,228,135,9,80,228,109,41,213,145,222,67,105,196,120,164,224,191,146,160,54,112,132,65,43,113,245,165,150,91,40,121,206,64,52,41,101,74,88,241,170,133,231,227,76,176,51,217,212,240,178,61,26,252,94,90,231,173,131,220,8,201,30,48,236,146,114,6,3,246,12,48,45,112,36,76,104,242,36,173,
109,176,204,149,162,25,188,224,183,50,12,25,149,158,241,75,247,4,187,145,174,138,4,214,109,154,156,126,157,251,249,70,152,186,48,200,217,235,251,49,153,159,36,162,15,185,199,1,134,245,24,134,246,49,228,89,149,229,141,194,213,52,97,120,135,13,228,91,100,95,29,1,44,53,182,188,93,170,62,79,236,144,217,96,206,205,84,142,223,242,121,181,182,129,62,158,169,32,135,244,68,112,162,146,138,210,109,200,18,65,193,183,116,131,97,47,164,27,27,247,158,204,41,116,11,25,229,80,223,210,124,220,116,197,23,48,44,71,192,167,94,12,56,117,75,3,249,92,163,53,26,184,220,202,245,49,123,162,129,176,197,217,44,151,5,23,68,252,111,216,184,113,200,108,207,208,15,90,224,188,174,49,132,238,15,0,0,255,255,3,0,201,88,118,58,28,52,170,156,0,0,0,0,73,69,78,68,174,66,96,130);

mtep_options20
:array[0..201] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,15,0,0,0,20,8,6,0,0,0,82,199,103,18,0,0,0,145,73,68,65,84,120,1,204,146,81,10,128,32,16,68,215,200,78,218,87,7,234,171,155,250,147,43,9,15,113,64,16,42,65,120,142,59,46,140,107,246,213,10,189,198,41,165,61,235,103,115,119,196,24,47,106,11,15,96,55,122,241,230,219,57,239,246,49,83,102,99,23,50,26,104,51,139,20,203,206,202,64,93,154,159,208,74,45,153,230,149,7,112,9,40,155,24,146,107,63,89,97,100,32,84,141,7,54,50,16,221,154,146,54,135,128,204,116,168,87,150,95,69,163,226,121,51,135,128,204,142,212,43,79,165,205,199,223,229,27,0,0,255,255,3,0,227,7,59,53,11,217,210,50,0,0,0,0,73,69,78,68,174,66,96,130);

tep_error24
:array[0..445] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,17,0,0,0,24,8,6,0,0,0,28,98,22,50,0,0,1,133,73,68,65,84,120,1,220,147,189,81,4,49,12,133,13,195,79,11,80,6,23,65,13,23,29,53,16,29,53,16,65,11,16,93,15,68,212,112,68,71,13,23,65,13,16,192,251,116,122,30,45,187,16,51,188,25,175,108,73,126,126,178,181,173,253,21,236,33,228,83,227,163,181,83,139,58,106,237,213,243,106,223,91,35,255,76,35,226,206,59,32,73,4,4,183,204,129,146,151,74,88,237,86,131,239,189,86,87,233,217,200,158,51,223,231,115,184,19,179,96,158,184,17,145,147,195,165,245,131,38,246,161,164,231,7,9,50,116,242,147,204,173,6,160,180,89,202,71,25,41,51,2,137,133,75,97,29,229,56,34,11,17,167,65,18,167,138,0,98,84,152,132,156,23,141,142,80,226,149,216,123,157,233,51,225,60,215,196,47,149,199,91,116,32,115,128,148,190,150,211,39,215,248,74,4,203,234,96,62,80,130,35,79,233,151,134,207,208,3,140,8,136,141,72,114,195,155,236,247,39,158,36,254,141,36,185,134,102,84,123,134,71,254,188,147,218,84,149,105,178,9,127,42,39,158,55,119,
215,50,170,191,147,79,145,240,50,6,79,202,136,127,69,150,6,28,17,13,72,148,192,179,246,31,81,115,119,102,189,228,121,150,172,240,14,157,68,1,54,63,106,152,132,141,188,18,184,211,64,17,160,241,214,149,168,147,40,80,85,108,104,42,119,102,218,11,24,18,228,158,120,17,36,98,165,78,84,24,85,190,125,216,234,127,214,190,232,106,43,169,151,197,61,212,228,32,73,53,215,133,136,178,227,159,50,9,82,143,25,106,109,254,210,73,20,162,200,85,18,119,245,223,240,5,0,0,255,255,3,0,234,247,75,120,222,103,50,160,0,0,0,0,73,69,78,68,174,66,96,130);

tep_color24
:array[0..457] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,26,0,0,0,24,8,6,0,0,0,228,130,237,197,0,0,1,145,73,68,65,84,120,1,180,85,193,113,195,32,16,68,153,136,30,242,74,15,105,195,47,247,224,151,122,224,229,30,242,82,15,121,169,141,180,225,30,172,71,114,123,176,4,9,2,242,72,190,25,196,113,44,187,58,64,186,206,52,204,185,59,16,111,1,230,164,191,56,103,49,28,165,93,225,136,221,172,134,252,160,244,236,74,65,198,68,228,34,254,41,52,134,77,16,138,99,113,38,52,17,131,120,209,50,33,231,126,2,112,254,20,7,66,153,21,132,136,25,251,222,12,24,116,43,230,197,208,139,204,200,224,139,43,75,125,69,136,240,179,8,78,169,216,11,103,146,190,42,146,224,106,110,198,177,18,210,237,170,17,108,158,155,103,131,173,143,22,183,46,28,252,98,50,162,86,206,134,173,227,138,129,23,68,51,10,87,24,103,115,180,157,238,250,117,24,195,173,195,119,242,20,33,225,213,111,144,66,31,71,167,146,240,41,55,133,178,91,146,0,247,186,202,77,161,189,100,205,245,175,64,92,253,191,171,9,38,192,217,112,194,12,52,123,27,47,67,19,186,
23,192,173,59,239,37,170,172,87,110,10,125,87,128,123,167,148,155,66,55,97,195,175,254,104,3,39,184,195,25,249,162,245,20,33,107,60,57,51,50,50,70,209,250,183,112,225,173,30,180,81,68,34,223,159,16,88,66,209,122,144,176,8,239,77,175,5,144,147,75,33,31,61,226,6,102,28,75,33,20,13,169,140,210,176,177,49,109,190,213,134,126,148,76,172,180,169,51,177,2,233,178,165,16,66,152,71,179,90,251,145,254,150,75,2,204,32,103,50,64,96,45,34,115,141,63,131,191,32,216,134,247,208,210,44,225,51,126,78,15,94,226,153,253,2,0,0,255,255,3,0,100,175,64,204,89,249,249,117,0,0,0,0,73,69,78,68,174,66,96,130);

tep_folderimage24
:array[0..435] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,26,0,0,0,24,8,6,0,0,0,228,130,237,197,0,0,1,123,73,68,65,84,120,1,220,149,189,85,195,48,20,133,5,7,40,50,1,169,216,33,107,164,98,3,10,87,97,6,211,104,7,87,158,193,29,51,164,99,3,138,84,97,5,210,36,247,10,93,29,201,150,17,182,11,56,232,28,91,239,79,239,179,228,39,201,152,255,214,174,150,76,168,169,215,217,241,171,219,213,249,233,229,61,73,157,13,76,34,70,20,15,217,195,189,201,132,60,238,236,241,53,182,207,2,121,72,87,217,195,54,78,38,185,173,31,40,238,0,107,101,75,64,185,165,64,240,89,193,236,53,19,64,114,51,9,161,128,29,161,88,193,174,229,81,2,232,159,209,179,207,192,199,150,75,169,140,57,97,58,245,97,13,67,131,241,236,205,13,95,62,89,7,113,83,213,21,77,174,181,182,229,87,119,240,191,121,19,59,55,48,210,83,17,144,187,212,226,52,7,130,116,143,103,27,67,232,165,14,24,255,67,246,95,48,38,180,17,128,252,2,73,31,244,125,56,192,105,76,1,160,224,34,72,129,131,30,0,182,220,50,125,121,210,247,108,208,79,1,194,133,170,147,161,212,107,
41,79,198,126,27,218,88,87,222,220,75,44,115,51,25,196,65,190,72,80,197,121,24,32,12,11,123,136,202,236,165,19,172,49,189,226,96,86,99,6,71,208,108,16,179,105,25,41,171,249,170,140,247,157,115,205,90,58,37,157,210,255,14,104,176,25,167,124,114,33,86,51,250,64,156,187,63,150,192,162,177,131,243,48,92,19,254,96,45,159,204,133,47,135,155,101,248,220,191,94,2,136,227,61,140,226,162,214,135,44,74,246,103,7,95,0,0,0,255,255,3,0,141,127,107,102,17,46,114,64,0,0,0,0,73,69,78,68,174,66,96,130);

tep_newfolder24
:array[0..494] of byte=(
137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,26,0,0,0,24,8,6,0,0,0,228,130,237,197,0,0,1,182,73,68,65,84,120,1,212,149,189,113,132,48,16,133,101,143,231,106,48,145,123,32,178,107,184,136,30,136,112,11,38,194,53,92,68,13,38,186,26,156,209,131,35,92,131,147,243,123,203,174,144,206,12,156,184,25,123,188,51,32,173,180,218,143,253,1,156,251,37,185,185,150,243,213,117,244,241,162,126,134,93,81,180,115,62,175,2,41,228,29,142,115,3,97,108,230,96,155,65,17,164,40,132,211,214,153,43,243,3,231,5,96,71,89,212,219,93,168,92,50,7,160,132,93,134,139,81,88,36,231,71,59,216,53,186,248,10,232,41,138,232,80,103,145,78,195,170,25,78,230,69,33,53,116,130,68,218,190,114,101,51,152,234,92,215,77,243,113,246,8,80,239,29,43,36,204,55,205,122,92,79,132,1,66,231,31,63,28,211,106,73,0,6,104,39,32,133,188,193,126,95,214,204,204,40,109,35,13,196,92,19,152,33,255,126,115,21,56,69,214,2,84,25,72,158,54,132,40,203,41,204,84,25,181,224,40,249,216,4,209,38,149,9,66,237,1,160,97,181,25,230,224,18,224,49,
119,210,101,97,125,232,118,18,22,142,173,46,5,188,157,214,19,102,128,80,172,9,8,140,162,152,34,205,80,91,201,90,58,72,33,97,218,124,42,131,148,161,134,44,7,59,244,158,15,149,14,218,179,47,32,234,84,162,25,87,252,93,95,92,166,172,178,212,173,214,200,159,14,39,132,49,50,192,124,27,218,254,184,198,118,237,1,241,223,189,109,32,58,53,152,205,57,66,180,75,27,188,123,210,4,227,170,115,219,65,244,96,105,52,111,11,99,122,141,22,156,45,109,253,13,104,238,43,176,244,148,41,123,22,209,39,14,201,255,227,26,88,112,150,239,80,36,107,95,239,200,248,66,133,45,253,28,254,94,120,206,131,168,204,253,143,184,158,42,231,144,212,243,255,195,254,27,0,0,255,255,3,0,73,42,149,38,124,16,135,35,0,0,0,0,73,69,78,68,174,66,96,130);


//end of images ----------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


implementation

uses gosswin2, gossroot, gossimg, gossio, gossfast {$ifdef gui},gossgui ,gossdat, main{$endif};


const
   tep_none:array[0..0] of byte=(0);


//start-stop procs -------------------------------------------------------------
procedure gossteps__start;
begin
try

//check
if system_started_teps then exit else system_started_teps:=true;

//init
teplist__init( tep_core );

except;end;
end;

procedure gossteps__stop;
begin
try

//check
if not system_started_teps then exit else system_started_teps:=false;

//free
teplist__free( tep_core );

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

function info__imgs(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gossteps.*"
if (strcopy1(xname,1,9)='gossteps.') then strdel1(xname,1,9) else exit;

//get
if      (xname='ver')        then result:='4.00.412'
else if (xname='date')       then result:='15apr2026'
else if (xname='name')       then result:='TEPs'
else
   begin
   //nil
   end;

except;end;
end;


//teplist procs ----------------------------------------------------------------

procedure teplist__init(var x:tteplist);
var
   p:longint;

   function xlistType:byte;
   begin

   case p of
   0..(ls_folder-1)        :result:=lt_system;
   ls_folder..(ls_app-1)   :result:=lt_folder;
   else                     result:=lt_app;
   end;//case

   end;

begin

for p:=0 to ls_max do
begin

x.n[p]                :='';
x.f[p]                :='';
x.w[p]                :=0;
x.h[p]                :=0;
x.rw[p]               :=0;
x.rh[p]               :=0;

x.it[p]                :=it_none;
x.lt[p]                :=xlistType;

x.lmono[p]            :=false;
x.lscale[p]           :=0;
x.iscale[p]           :=0;

x.ftime[p]            :=0;
x.fdata[p]            :=nil;
x.pdata[p]            :=nil;
x.img[p]              :=nil;

end;//p

end;

procedure teplist__free(var x:tteplist);
var
   p:longint;
begin

for p:=0 to ls_max do
begin

if (x.fdata[p]<>nil) then str__free(@x.fdata[p]);
if (x.pdata[p]<>nil) then str__free(@x.pdata[p]);

if (x.img[p]<>nil)   then freeobj(@x.img[p]);

end;//p

end;


//image procs ------------------------------------------------------------------

function tep__tick(x:boolean):longint;
begin

case x of
true:result:=tepTick20;
else result:=tepUntick20;
end;//case

end;

function tep__tick2(x:boolean):longint;
begin

case x of
true:result:=tepTicktwo20;
else result:=tepUnticktwo20;
end;//case

end;

function tep__tick3(x:boolean):longint;
begin

case x of
true:result:=tepTickthree20;
else result:=tepUntickthree20;
end;//case

end;

function tep__yes(x:boolean):longint;
begin

case x of
true:result:=tepYes20;
else result:=tepYesBLANK20;
end;//case

end;

function tep__bytes(const xindex:longint):longint;//10mar2026
begin

case tep__find(xindex) of
true:begin

   case tep_core.it[xindex] of
   it_rle6  :result:=(tep_core.img[xindex] as tbasicrle6).core.len32;
   it_rle8  :result:=(tep_core.img[xindex] as tbasicrle8).core.len32;
   it_rle32 :result:=(tep_core.img[xindex] as tbasicrle32).core.len32;
   it_img32 :result:=tep_core.w[xindex]*tep_core.h[xindex]*4;
   else      result:=0;
   end;//case

   end;
else result:=0;
end;//case

end;

function tep__type(const xindex:longint):longint;//15apr2026
begin

case tep__find(xindex) of
true:result:=tep_core.it[xindex];
else result:=it_none;
end;//case

end;

function tep__width(const xindex:longint):longint;
begin

case tep__find(xindex) of
true:result:=tep_core.w[xindex];
else result:=0;
end;//case

end;

function tep__height(const xindex:longint):longint;
begin

case tep__find(xindex) of
true:result:=tep_core.h[xindex];
else result:=0;
end;//case

end;

function tep__rootwidth(const xindex:longint):longint;//unscaled version
begin

case tep__find(xindex) of
true:result:=tep_core.rw[xindex];
else result:=0;
end;//case

end;

function tep__rootheight(const xindex:longint):longint;//unscaled version
begin

case tep__find(xindex) of
true:result:=tep_core.rh[xindex];
else result:=0;
end;//case

end;

function tep__cantodata(const xindex:longint):boolean;
begin

result:=(tep__height(xindex)>=1);

end;

function tep__todata(const xindex:longint;const d:pointer;const dformat:string):boolean;//18mar2026
var
   e:string;

begin

//get
result      :=str__lock(d) and tep__cantodata(xindex) and mis__todata(tep_core.img[xindex],d,dformat,e);

//clear on error
if not result then str__clear(d);

//free
str__uaf(d);

end;

function tep__todata2(const xindex,col1,col2,col3,col4:longint;const d:pointer;const dformat:string):boolean;//18mar2026
var
   a:tbasicimage;
   e:string;
begin

//defaults
a           :=nil;

result      :=str__lock(d) and tep__cantodata(xindex);

if result then
   begin

   a        :=misimg32(1,1);

   tep__copytoimage(a,xindex,col1,col2,col3,col4);
   mis__todata(a,d,dformat,e);

   end;

//free
if (a<>nil) then freeobj(@a);

end;

function tep__info(const xindex:longint;var xwidth,xheight:longint):boolean;//15mar2026
var
   int1:longint;
begin

result:=tep__info2(xindex,xwidth,xheight,int1);

end;

function tep__info2(const xindex:longint;var xwidth,xheight,xtype:longint):boolean;//15aar2026
begin

case tep__find(xindex) of
true:begin

   xwidth   :=tep_core.w[xindex];
   xheight  :=tep_core.h[xindex];
   xtype    :=tep_core.it[xindex];
   result   :=true;

   end;
else begin

   xwidth   :=0;
   xheight  :=0;
   xtype    :=it_none;
   result   :=false;

   end;
end;//case

end;

procedure tep__copytoimage(const d:tobject;const xindex,col1,col2,col3,col4:longint);
var
   dbits,dw,dh:longint;
begin

//check
if not tep__find(xindex)         then exit;
if not misok82432(d,dbits,dw,dh) then exit;

//copy
case tep_core.it[xindex] of
it_rle6 :(tep_core.img[xindex] as tbasicrle6 ).copytoimage(d,col1,col2,col3,col4);
it_rle8 :(tep_core.img[xindex] as tbasicrle8 ).copytoimage(d,col1);
it_rle32:(tep_core.img[xindex] as tbasicrle32).copytoimage(d);
it_img32:begin

   missize(d,tep__width(xindex),tep__height(xindex));
   mis__copyfast(maxarea,misarea(d),0,0,misw(d),mish(d),tep_core.img[xindex],d);

   end;
end;//case

end;

procedure tep__draw2(const dclip:twinrect;const xindex,dx,dy,col1,col2,col3,col4,dpower255:longint);
begin

if tep__find(xindex) then
   begin

   //init
   fd__set( fd_fillAreaDefaults );
   fd__setarea( fd_clip ,dclip );
   fd__setarea( fd_area ,dclip );
   fd__setval( fd_power ,dpower255 );

   //get
   case tep_core.it[xindex] of

   it_rle6:begin

      //render
      fd__setbuffer( fd_buffer2 ,tep_core.img[xindex] );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__setval( fd_color1 ,col1 );
      fd__setval( fd_color2 ,col2 );
      fd__setval( fd_color3 ,col3 );
      fd__setval( fd_color4 ,col4 );
      fd__render( fd_drawRLE6 );

      end;

   it_rle8:begin

      //render
      fd__setbuffer( fd_buffer2 ,tep_core.img[xindex] );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__setval( fd_color1 ,col1 );
      fd__render( fd_drawRLE8 );

      end;

   it_rle32:begin

      //render
      fd__setbuffer( fd_buffer2 ,tep_core.img[xindex] );
      fd__moveto( fd_area2 ,dx ,dy );
      fd__render( fd_drawRLE32 );

      end;

   it_img32:begin

      //render
      fd__setbuffer( fd_buffer2 ,tep_core.img[xindex] );
      fd__setarea2 ( fd_area  ,dx ,dy ,tep_core.w[xindex] ,tep_core.h[xindex] );
      fd__render   ( fd_drawRGBA );//15mar2026

      end;

   end;//case

   end;

end;

procedure tep__draw(const dclip:twinrect;const xindex,dx,dy,dcol,dpower255:longint);
begin

tep__draw2(dclip,xindex,dx,dy,dcol,dcol,dcol,dcol,dpower255);

end;

function tep__find(const xindex:longint):boolean;
begin

//defaults
result      :=(xindex>=0) and (xindex<=ls_max);

//check
if (not result) or (xindex=tepNone) then exit;


//sync -------------------------------------------------------------------------

{$ifdef gui}
tep_scale             :=viscale;
tep_mono              :=vimodern;
{$endif}


//get --------------------------------------------------------------------------

//sync
case (tep_core.lmono[xindex]=tep_mono) and (tep_core.lscale[xindex]=tep_scale) of
true:exit;
else begin

   tep_core.lmono[xindex]       :=tep_mono;
   tep_core.lscale[xindex]      :=tep_scale;
   tep_core.iscale[xindex]      :=viscale32;//26mar2026: "iscale <= lscale" and "iscale >= 1"

   end;
end;//case

//get
case tep_core.lt[xindex] of
lt_system    :xtep__systemFind  ( xindex );
lt_folder    :xtep__folderFind  ( xindex );
lt_app       :xtep__appFind     ( xindex );
else          result:=false;
end;//case

end;

procedure tep__20(const xindex:longint;const m20,c20:array of byte;const mtype,ctype:longint);//set tep

   function cset:boolean;//set color
   begin

   result:=xtep__set( xindex ,20 ,ctype ,nil ,c20 );

   end;

   function mset:boolean;//set mono
   begin

   result:=xtep__set( xindex ,20 ,mtype  ,nil ,m20 );

   end;

begin

case tep_mono of
true:if not mset then cset;
else if not cset then mset;
end;//case

end;

procedure tep__20b(const xindex:longint;const m20,c20:pointer;const mtype,ctype:longint);//set tep

   function cset:boolean;//set color
   begin

   result:=xtep__set( xindex ,20 ,ctype ,c20 ,[0] );

   end;

   function mset:boolean;//set mono
   begin

   result:=xtep__set( xindex ,20 ,mtype  ,m20 ,[0] );

   end;

begin

case tep_mono of
true:if not mset then cset;
else if not cset then mset;
end;//case

end;

procedure tep__24(const xindex:longint;const m24,c24:array of byte;const mtype,ctype:longint);//set tep

   function cset:boolean;//set color
   begin

   result:=xtep__set( xindex ,24 ,ctype ,nil ,c24 );

   end;

   function mset:boolean;//set mono
   begin

   result:=xtep__set( xindex ,24 ,mtype  ,nil ,m24 );

   end;

begin

case tep_mono of
true:if not mset then cset;
else if not cset then mset;
end;//case

end;

procedure tep__24b(const xindex:longint;const m24,c24:pointer;const mtype,ctype:longint);//set tep

   function cset:boolean;//set color
   begin

   result:=xtep__set( xindex ,24 ,ctype ,c24 ,[0] );

   end;

   function mset:boolean;//set mono
   begin

   result:=xtep__set( xindex ,24 ,mtype  ,m24 ,[0] );

   end;

begin

case tep_mono of
true:if not mset then cset;
else if not cset then mset;
end;//case

end;

procedure xtep__scale(const xvariableWidth:boolean;const xheightLimit,sw,sh:longint;var dw,dh:longint);//23mar2026
begin

case xvariableWidth of
true:begin//app images max out at 20h x variable-width

   low__scaledown(xheightLimit,xheightLimit,sh,sh,dh,dh);
   dw       :=frcmin32( round32( ( dh / frcmin32(sh,1) ) * sw ) ,1 );

   end;
else begin//folder images max out at 20h x 20w

   low__scaledown(xheightLimit,xheightLimit,sw,sh,dw,dh);

   end;
end;//case

end;

function xtep__set(const xindex,xheightLimit,xit_type:longint;pdata:pointer;const xdata:array of byte):boolean;
label
   skipend;

var
   v,e:string;
   s,dtmp,d:tbasicimage;
   xrootw,xrooth,dw,dh,int1,sw,sh:longint;

   function dscale(const v:longint):longint;
   begin

   result:=frcmin32(round32(v*tep_core.lscale[xindex]),1);

   end;

   procedure xfree;
   begin

   if (tep_core.img[xindex]<>nil) then freeobj(@tep_core.img[xindex]);

   end;

   procedure xnoimage;
   begin

   tep_core.w[xindex]           :=0;
   tep_core.h[xindex]           :=0;
   tep_core.rw[xindex]          :=0;
   tep_core.rh[xindex]          :=0;
   tep_core.it[xindex]          :=it_none;

   xfree;

   end;

   procedure suse;
   begin

   case xit_type of

   it_rle6:begin

      if not (tep_core.img[xindex] is tbasicrle6) then
         begin

         xfree;
         tep_core.img[xindex]:=tbasicrle6.create;

         end;

      tbasicrle6(tep_core.img[xindex]).slow__makefromLRGB( s );
      tep_core.it[xindex]       :=xit_type;

      end;

   it_rle8:begin

      if not (tep_core.img[xindex] is tbasicrle8) then
         begin

         xfree;
         tep_core.img[xindex]:=tbasicrle8.create;

         end;

      tbasicrle8(tep_core.img[xindex]).slow__makefromLUM( s );
      tep_core.it[xindex]       :=xit_type;

      end;

   it_rle32:begin

      if not (tep_core.img[xindex] is tbasicrle32) then
         begin

         xfree;
         tep_core.img[xindex]:=tbasicrle32.create;

         end;

      tbasicrle32(tep_core.img[xindex]).rgba__makefrom( s );
      tep_core.it[xindex]       :=xit_type;

      end;

   it_img32:begin

      if not (tep_core.img[xindex] is tbasicimage) then
         begin

         xfree;

         end;

      tep_core.img[xindex]      :=s;
      tep_core.it[xindex]       :=xit_type;
      s                         :=nil;

      end;

   end;//case

   //set
   tep_core.w[xindex]           :=misw(tep_core.img[xindex]);
   tep_core.h[xindex]           :=mish(tep_core.img[xindex]);
   tep_core.rw[xindex]          :=xrootw;
   tep_core.rh[xindex]          :=xrooth;

   if (tep_core.w[xindex]<=0) or (tep_core.h[xindex]<=0) then
      begin

      tep_core.it[xindex]       :=it_none;

      end;

   end;

begin

//defaults
result      :=false;
s           :=nil;
d           :=nil;
dtmp        :=nil;


//no image ---------------------------------------------------------------------

if (pdata=nil) and ( (low(xdata)<>0) or ((high(xdata)+1)<=1) ) then
   begin

   xnoimage;
   exit;

   end;


//persistent data overrides ALL over data methods except NIL -------------------

if (tep_core.pdata[xindex]<>nil) and (str__len(@tep_core.pdata[xindex])>=1) then
   begin

   pdata    :=@tep_core.pdata[xindex];

   end;


try

//load image -------------------------------------------------------------------

//init
s           :=misimg32(1,1);

//get

case (pdata<>nil) of
true:begin

   if not mis__fromdata(s,pdata,e) then
      begin

      xnoimage;
      goto skipend;

      end;

   end
else begin

   if not mis__fromarray(s,xdata,e) then
      begin

      xnoimage;
      goto skipend;

      end;

   end;
end;//case


//enforce max height -> scale down ---------------------------------------------

if (mish(s)>xheightLimit) then
   begin

   //init
   dtmp     :=misimg32(1,1);

   xtep__scale(true,xheightLimit,misw(s),mish(s),dw,dh);

   //s -> dtmp
   missize(dtmp,dw,dh);
   mis__copyfast(maxarea,misarea(s),0,0,misw(dtmp),mish(dtmp),s,dtmp);

   //dtmp -> s
   missize(s,dw,dh);
   mis__copyfast(maxarea,misarea(dtmp),0,0,misw(s),mish(s),dtmp,s);

   end;


//scale image up/down by WHOLE values to avoid image distortion ----------------
xrootw      :=misw(s);
xrooth      :=mish(s);


if tep__canscale(xindex) then
   begin

   //scale up - optional, e.g. 2x for 200%
//   if (tep_core.lscale[xindex]>1.0) and (tep_core.lscale[xindex]=tep_core.iscale[xindex]) then
   if (tep_core.iscale[xindex]>=2) then
      begin

      //s -> d
      d     :=s;
      s     :=misimg32( frcmin32(misw(d)*tep_core.iscale[xindex],1) ,frcmin32(mish(d)*tep_core.iscale[xindex],1) );

      //d -> s
      mis__copyfast(maxarea,misarea(d),0,0,misw(s),mish(s),d,s);

      end

   //scale down - options
   else if (tep_core.lscale[xindex]<1.0) then
      begin
      //disabled for now -> no fast, high-quality method available yet

   {
      //s -> d
      d     :=misimg32( misw(s) ,mish(s) );
      mis__copyfast82432(maxarea,0,0,misw(d),mish(d),misarea(s),d,s);

      //d -> s
      missize(s ,dscale(misw(s)) ,dscale(mish(s)) );
      mis__copyfast82432(maxarea,0,0,misw(s),mish(s),misarea(d),s,d);

   {}
      end;

   end;


//finalise ---------------------------------------------------------------------

//use
suse;

//successful
result      :=true;

skipend:
except;end;


//free -------------------------------------------------------------------------

if (s<>nil)    then freeobj(@s);
if (d<>nil)    then freeobj(@d);
if (dtmp<>nil) then freeobj(@dtmp);

end;

function tep__filetype20(const xfilenameORext:string):longint;
begin

result:=tep__filetype202(xfilenameORext,tepXXX20);

end;

function tep__filetype202(const xfilenameORext:string;const xdeftep:longint):longint;
var
   n:string;

   procedure s(const x:longint);
   begin

   result   :=x;

   end;

   function m(const s:string):boolean;
   begin

   result:=(s=n) or strmatch(s,n);

   end;

begin

//defaults
result                       :=xdeftep;

//get
n                            :=io__readfileext_low(xfilenameORext);

//.images
if       m('bmp') or m('dib') or m('vbmp') or m('wmf') or m('emf') or m('jpg') or m('jpeg') or m('jpgt') or m('jif') or m('lig') or
         m('gif') or m('img32') or m('tj32') or m('res') then s(tepBMP20)

else if  m('ico') or m('yuv') or m('gr8') or m('bw1') or m('b04') or m('b12') or m('ppm') or m('pgm') or m('pbm') or m('xbm') then s(tepBMP20)

else if  m('tea') or m('teb') or m('tem') or m('tep') or m('tec') or m('teh') or m('t24') or m('atep') or m('omi') or m('san') or
         m('can') or m('ean') or m('aan') or m('aas') or m('raw24') then s(tepBMP20)

else if m('png') or m('abr') or m('mp4') or m('webm') or m('tga') or m('pnm') or m('rle32') or m('rle8') or m('rle6') or m('pic8') or
        m('san') then s(tepBMP20)//06mar2026, 25feb2026, 19jul2025, 26jan2025, 02jan2025, 20dec2024, 10nov2024, 30dec2021

else if m('cur') or m('ani') then s(tepCUR20)//24may2022

//.music
else if m('wav') or m('mp1') or m('mp2') or m('mp3') or m('mp4') or m('wma') then s(tepWMA20)
else if m('mid') or m('midi') or m('rmi')                                    then s(tepMID20)//20feb2021

//.playlist
else if m('m3u') then s(tepNotes20)//20mar2022

//.videos

//.documents
else if m('map')             then s(tepTXT20)//19may2025
else if m('pas')             then s(tepPAS20)
else if m('dpr')             then s(tepDPR20)//20mar2025
else if m('c3')              then s(tepC320)//Claude 3 Code - 20aug2024
else if m('ref3')            then s(tepREF320)//Claude 3 Ref - 20aug2024
else if m('c2v')             then s(tepC2V20)
else if m('c2p')             then s(tepC2P20)
else if m('ini')             then s(tepTXT20)//24jan2022
else if m('txt')             then s(tepTXT20)
else if m('bwd')             then s(tepBWD20)
else if m('bwp')             then s(tepBWP20)
else if m('rtf')             then s(tepRTF20)//22jun2022
else if m('dic')             then s(tepDIC20)//17feb2026
else if m('htm')             then s(tepHTM20)//30dec2021
else if m('html')            then s(tepHTM20)//30dec2021
else if m('xml')             then s(tepXML20)//30dec2021
else if m('footnote')        then s(tepTXT20)//21mar2022
else if m('cscript')         then s(tepCUR20)//17may2022
else if m('sfef')            then s(tepSFEF20)//05oct2022
else if m('quoter')          then s(tepquoter20)//26dec2022
else if m('quoter2')         then s(tepquoter20)//10jan2023

//.programs
else if m('exe')             then s(tepEXE20)
else if m('bat')             then s(tepXXX20)

//.schemes
else if m('bcs')             then s(tepBCS20)

//.redirects
else if m('r')               then s(tepR20)//30dec2021

//.archives
else if m('zip')             then s(tepZIP20)
else if m('7z')              then s(tep7Z20)
else if m('nupkg')           then s(tepnupkg20)//31mar2025

//.other
else if m('alarms')          then s(tepClock20)//08mar2022
else if m('reminders')       then s(tepAlert20)//09mar2022

//.filter groups - 10mar2021
else if m(felosslessimgs)    then s(tepBMP20)//09apr2025
else if m(feallimgs)         then s(tepBMP20)
else if m(feallcurs)         then s(tepCUR20)//24may2022
else if m(feallcurs2)        then s(tepCUR20)//24may2022
else if m(fealljpgs)         then s(tepBMP20)//03sep2021
else if m(fealldocs)         then s(tepBWP20)//26sep2022
else if m(febrowserimgs)     then s(tepBMP20);//18mar2025

end;

function tep__folderimageFilename(const xfolder:string):string;
begin

case (xfolder<>'') of
true:result:=xfolder+'.be.tea';
else result:='';
end;//case

end;

function tep__folderimageUndoFilename(const xfolder:string):string;//23mar2026
begin

case (xfolder<>'') of
true:result:=xfolder+'.be.undo.tea';
else result:='';
end;//case

end;

function tep__folderimageDefault20(xfolder:string):longint;//23mar2026
var
   xlen:longint32;
   n:string;
   
begin

//range
xfolder     :=io__asfolderNIL(xfolder);
if (xfolder='') then
   begin

   result   :=tepHome20;
   exit;

   end;

xlen        :=low__len32(xfolder);


//static / known folders -------------------------------------------------------
//.root folder
if (xlen=1) and ((strcopy1(xfolder,1,1)='/') or (strcopy1(xfolder,1,1)='\')) then
   begin

   result   :=tepDisk20;

   end

//.disk drive
else if (xlen=3) then
   begin

   n        :=io__drivetype(xfolder);

   if      (n='cd')                                                     then result:=tepCD20
   else if (n='removable') or (n='floppy') or (n='network') or (n='nn') then result:=tepRemovable20
   else                                                                      result:=tepDisk20;

   end

//.special folder
else if      strmatch(xfolder,sysfast_root) then
   begin

   result   :=tepOpen20;

   end
else if strmatch(xfolder,sysfast_settings)  then
   begin

   result   :=tepSettings20;

   end
else if strmatch(xfolder,sysfast_schemes)   then
   begin

   result   :=tepSchemes20;

   end
else if strmatch(xfolder,sysfast_startmenu) then
   begin

   result   :=tepStartmenu20;

   end
else if strmatch(xfolder,sysfast_desktop)   then
   begin

   result   :=tepDesktop20;

   end
else if strmatch(xfolder,sysfast_programs)  then
   begin

   result   :=tepPrograms20;

   end
else if strmatch(xfolder,sysfast_blaiz)     then
   begin

   result   :=tepBE20;

   end
else begin

   result   :=tepFolder20;

   end;

end;

function tep__folderimage20(xfolder:string;xreload:boolean):longint;//19mar2026
label
   skipend;

var
   dslot,xlen,p:longint;
   ltime:comp;
   n,e:string;
   b:tstr8;

begin


//defaults
result      :=tep__folderimageDefault20( xfolder );
dslot       :=result;
ltime       :=max64;
b           :=nil;

//range
xfolder     :=io__asfolderNIL(xfolder);

if (xfolder='') then exit;

xlen        :=low__len32(xfolder);


//customise folder -------------------------------------------------------------

//too short to be a folder -> ignore
if (xlen<3)                             then exit;


//find custom folder TEP
for p:=ls_folder to (ls_app-1) do if (tep_core.f[p]<>'') and strmatch(tep_core.f[p],xfolder) then
   begin

   //get
   dslot                     :=p;
   tep_core.ftime[dslot]     :=slowms64;//keep recent

   //already loaded from disk -> don't reload
   case xreload of
   true:break;
   else exit;
   end;//case

   end;//p


//load folder image into next free slot -> slot is not committed too until "reload" further down - 20mar2026
if (dslot<ls_folder) then
   begin

   //find
   for p:=ls_folder to (ls_app-1) do
   begin

   if (tep_core.ftime[p]<ltime) then
      begin

      ltime    :=tep_core.ftime[p];
      dslot    :=p;

      if (ltime<=0) then break;//slot is unused when time=0

      end;

   end;//p

   //fallback
   if (dslot<ls_folder) then dslot:=ls_folder;

   //force reload
   xreload                   :=true;

   end;


//reload
if (dslot>=ls_folder) and xreload then
   begin

   //load folder image data here -> last failure point
   b           :=rescache__newStr8;
   if not io__fromfile( tep__folderimageFilename(xfolder) ,@b ,e ) then goto skipend;

   //commit to slot and set data
   tep_core.ftime[dslot]     :=slowms64;
   tep_core.f[dslot]         :=xfolder;
   tep_core.lmono[dslot]     :=false;//defaults to color
   tep_core.lscale[dslot]    :=0;//no scale -> force update of TEP

   if (tep_core.fdata[dslot]=nil) then tep_core.fdata[dslot]:=str__new8;

   str__clear( @tep_core.fdata[dslot] );
   str__add  ( @tep_core.fdata[dslot] ,@b );

   //set color image in TEP slot
   tep__20b( dslot ,nil ,@tep_core.fdata[result] ,df_mono ,df_color );

   end;

//set
result      :=dslot;

skipend:

//free
if (b<>nil) then rescache__delStr8( @b );

end;

function tep__setfolderimage20(xfolder:string;const s:pointer):boolean;
label
   skipend;

var
   a:tbasicimage;
   d:tstr8;
   p,i,l:longint;
   ltime:comp;
   e:string;

   procedure xnoimage;
   var
      p:longint;
   begin

   //remove image file
   io__remfile( tep__folderimageFilename(xfolder) );

   //delete image data
   for p:=ls_folder to (ls_app-1) do if (tep_core.f[p]<>'') and strmatch(tep_core.f[p],xfolder) then
      begin

      if (tep_core.img[p]<>nil)   then freeobj( @tep_core.img[p] );
      if (tep_core.fdata[p]<>nil) then str__clear( @tep_core.fdata[p] );

      tep_core.ftime[p]         :=0;
      tep_core.f[p]             :='';
      tep_core.lmono[p]         :=false;
      tep_core.lscale[p]        :=0;

      break;

      end;//p

   end;

begin

//defaults
result      :=false;
i           :=-1;
l           :=-1;
ltime       :=max64;
a           :=nil;
d           :=nil;

//range
xfolder     :=io__asfolderNIL(xfolder);
if (xfolder='')                             then exit;

try

//check
if (str__len(s)<=2) then
   begin

   xnoimage;
   exit;

   end;

//image data
a           :=misimg32(1,1);

if not mis__fromdata(a,s,e)                 then goto skipend;

tep__squareScaleImage(a,tep_folderImageWH);

//.as data
d           :=str__new8;
if not mis__todata(a,@d,'tea',e)            then goto skipend;


//find existing
for p:=ls_folder to (ls_app-1) do if (tep_core.f[p]<>'') and strmatch(tep_core.f[p],xfolder) then
   begin

   i        :=p;
   break;

   end;//p


//find free slot
if (i<=-1) then
   begin

   for p:=ls_folder to (ls_app-1) do
   begin

   //.new
   if (tep_core.ftime[p]=0) then
      begin

      i        :=p;
      break;

      end

   //.oldest
   else if (tep_core.ftime[p]<ltime) then
      begin

      ltime    :=tep_core.ftime[p];
      l        :=p;

      end;


   end;//p

   //set oldest
   if (i<=-1) then i:=l;

   end;


//fallback -> should never happen
if (i<=-1) then i:=ls_folder;


//get
tep_core.f[i]         :=xfolder;
tep_core.ftime[i]     :=ms64;

if (tep_core.fdata[i]=nil) then tep_core.fdata[i]:=str__new8;
str__clear( @tep_core.fdata[i] );


//set
str__add( @tep_core.fdata[i] ,@d );

tep_core.lmono[i]     :=false;//defaults to color
tep_core.lscale[i]    :=0;//no scale -> force update of TEP

//.store color image in TEP slot
tep__20b( i ,nil , @d ,df_mono ,df_color );

//.store in legacy format ".tea" at 20x20 - 18mar2026
io__tofile( tep__folderimageFilename(xfolder) ,@tep_core.fdata[i] ,e );


//successful
result      :=true;

skipend:
except;end;

//free
freeobj(@a);
str__free(@d);

end;

procedure tep__squareScaleImage(const d:tobject;const xheightLimit:longint);
label
   skipend;

var
   s:tbasicimage;
   dbits,dw,dh:longint;

begin

//defaults
s           :=nil;

//check
if not misok82432(d,dbits,dw,dh) then exit;

try

//init
s           :=misimg32(1,1);

if not miscopy(d,s)              then goto skipend;

//size
xtep__scale(false,xheightLimit,misw(s),mish(s),dw,dh);

if not missize(d,dw,dh)          then goto skipend;

//cls
mis__cls( d ,0,0,0,0 );

//copy pixels
mis__copyfast(maxarea,misarea(s),0,0,dw,dh,s,d);

skipend:
except;end;

//free
freeobj(@s);

end;

function tep__findByName(const xname:string;var xindex:longint):boolean;
var
   p:longint;
begin

//defaults
result      :=false;
xindex      :=tepNone;

//find
for p:=ls_system to (ls_folder-1) do
begin

if strmatch( xname ,tep__name(p) ) then
   begin

   xindex   :=p;
   result   :=true;
   break;

   end;

end;//p

end;

function tep__canscale(const xindex:longint):boolean;//21mar2026
begin

case xindex of
tepTemp20_noscaling :result:=false;
else                 result:=true;
end;//case

end;

procedure tep__clearpersistentdata(const xindex:longint);
begin

tep__setpersistentdata(xindex,nil,[0]);

end;

procedure tep__setpersistentdata(const xindex:longint;const pdata:pointer;const adata:array of byte);
begin

if (xindex>=0) and (xindex<=ls_max) then
   begin

   //get
   if (pdata<>nil) or ( (low(adata)=0) and (high(adata)>=1) ) then
      begin

      //init
      if (tep_core.pdata[xindex]=nil) then tep_core.pdata[xindex]:=str__new8;
      str__clear( @tep_core.pdata[xindex] );

      //get
      case (pdata<>nil) of
      true:str__add ( @tep_core.pdata[xindex] ,pdata );
      else str__aadd( @tep_core.pdata[xindex] ,adata );
      end;//case

      end

   //clear
   else if (tep_core.pdata[xindex]<>nil) then str__clear( @tep_core.pdata[xindex] );

   end;

end;

function tep__name(const xindex:longint):string;

   procedure s(const n:string);
   begin

   result:=n;

   end;

   procedure s20(const n:string);
   begin

   result:=n + insstr('20',n<>'');

   end;

begin

//defaults
result      :='';


//get
case xindex of
tepOn                 :s('on');
tepoff                :s('off');
tepup                 :s('up');
tepdown               :s('down');
tepleft               :s('left');
tepright              :s('right');
tepmin                :s('min');
tepnor                :s('nor');
tepmax                :s('max');
tepclo                :s('clo');
tepinf                :s('inf');
tepfull               :s('full');
tepfullexit           :s('fullexit');
tephelphint           :s('helphint');
tepbullet             :s('bullet');

//.standard "20" size teps
tepfnew20             :s20('fnew');
tepnew20              :s20('new');
tephome20             :s20('home');
tepyesblank20         :s20('yesblank');
tepyes20              :s20('yes');
tepok20               :s20('ok');
tepopen20             :s20('open');
tepsave20             :s20('save');//or SaveAs20
tepdisk20             :s20('disk');
tepclose20            :s20('close');
tepclosed20           :s20('closed');
tepupward20           :s20('upward');
tepdownward20         :s20('downward');
tephide20             :s20('hide');
tepundo20             :s20('undo');
tepredo20             :s20('redo');
tepcut20              :s20('cut');
tepcopy20             :s20('copy');
tepImage20            :s20('image');
tepCode20             :s20('code');
tepUnit20             :s20('unit');
tepCompress20         :s20('compress');
tepnotepad20          :s20('notepad');
tepvisual20           :s20('visual');
tepinfo20             :s20('info');
tepmute20             :s20('mute');
tepunmute20           :s20('unmute');
tepgithub20           :s20('github');
tepsourceforge20      :s20('sourceforge');
tepinstagram20        :s20('instagram');
tepfacebook20         :s20('facebook');
tepMastodon20         :s20('mastodon');
teptwitter20          :s20('twitter');
teppaste20            :s20('paste');
tepselectall20        :s20('selectall');
tepframe20            :s20('frame');
tepBlank20            :s20('blank');
tepClock20            :s20('clock');
tepAlert20            :s20('alert');
tepBell20             :s20('bell');
tepSonnerie20         :s20('sonnerie');
tepLeft20             :s20('left');
tepRight20            :s20('right');
tepTop20              :s20('top');
tepBottom20           :s20('bottom');
tepBack20             :s20('back');
tepForw20             :s20('forw');
tepPower20            :s20('power');
tepwine20             :s20('wine');
tepupper20            :s20('upper');
teplower20            :s20('lower');
tepname20             :s20('name');

tepeye20              :s20('eye');
tepstop20             :s20('stop');
tepplay20             :s20('play');
teppause20            :s20('pause');
teprec20              :s20('rec');
teprewind20           :s20('rewind');
tepfastforward20      :s20('fastforward');
tepvol20              :s20('vol');
tepoptions20          :s20('options');
tepgo20               :s20('go');
tepnav20              :s20('nav');
tepmax20              :s20('max');
tepontop20            :s20('ontop');
tepless20             :s20('less');
tepmore20             :s20('more');
tepbw20               :s20('bw');
tephelp20             :s20('help');
tephelpdoc20          :s20('helpdoc');
tepList20             :s20('list');
tepsettings20         :s20('settings');
tepum20               :s20('um');
tepabout20            :s20('about');
tepcapture20          :s20('capture');
tepbe20               :s20('be');
teprefresh20          :s20('refresh');
tepfolder20           :s20('folder');
tepcolor20            :s20('color');
tepcolors20           :s20('colors');
tepcolormatrix20      :s20('colormatrix');
tepcolorpal20         :s20('colorpal');
tepcolorpalDUAL20     :s20('colorpaldual');
tepcolorpalSMALL20    :s20('colorpalsmall');
tepcolorhistory20     :s20('colorhistory');
tepfont20             :s20('font');
tepdesktop20          :s20('desktop');
tepprograms20         :s20('programs');
tepmenu20             :s20('menu');
tepinvert20           :s20('invert');
tepprev20             :s20('prev');
tepnext20             :s20('next');
tepfav20              :s20('fav');
tepupone20            :s20('upone');
tepnewfolder20        :s20('newfolder');
tepadd20              :s20('add');
tepaddl20             :s20('addl');
tepsub20              :s20('sub');
tepsubl20             :s20('subl');
tepPanel20            :s20('panel');
tepedit20             :s20('edit');
tepfavedit20          :s20('favedit');
tepfavadd20           :s20('favadd');
teptick20             :s20('tick');
tepuntick20           :s20('untick');
tepticktwo20          :s20('ticktwo');
tepunticktwo20        :s20('unticktwo');
tepup20               :s20('up');
tepcd20               :s20('cd');
tepremovable20        :s20('removable');
tepfolderimage20      :s20('folderimage');
tepstartmenu20        :s20('startmenu');
tepschemes20          :s20('schemes');
tepscreen20           :s20('screen');
tepwrap20             :s20('wrap');
tepxxx20              :s20('xxx');
tepbmp20              :s20('bmp');
tepwma20              :s20('wma');
tepc2v20              :s20('c2v');
tepc2p20              :s20('c2p');
tepini20              :s20('ini');
teptxt20              :s20('txt');
tepexe20              :s20('exe');
tepzip20              :s20('zip');
tep7z20               :s20('7z');
tephtm20              :s20('htm');
tepbwd20              :s20('bwd');
tepbwp20              :s20('bwp');
teprtf20              :s20('rtf');
tepdic20              :s20('dic');
tepmid20              :s20('mid');
tepquoter20           :s20('quoter');
tepsfef20             :s20('sfef');
tepbcs20              :s20('bcs');
teppas20              :s20('pas');
tepdpr20              :s20('dpr');
tepc320               :s20('c3');
tepnotes20            :s20('notes');
tepr20                :s20('r');
tepxml20              :s20('xml');
tepunknown20          :s20('unknown');
tepzoom20             :s20('zoom');
tepsizeto20           :s20('sizeto');
tepbulletsquare20     :s20('bulletsquare');
tepTemp20_noscaling   :s20('temp');
tepTemp20             :s20('temp');

//09may2025
tepRotate20           :s20('rotate');
tepRotateLeft20       :s20('rotateleft');
tepmirror20           :s20('mirror');
tepflip20             :s20('flip');
tepsaveas20           :s20('saveas');
tepprint20            :s20('print');
tepbackground20       :s20('background');
tepsquircle20         :s20('squircle');
tepcircle20           :s20('circle');
tepsquare20           :s20('square');
tepsolid20            :s20('solid');
teptransparent20      :s20('transparent');
tepasis20             :s20('asis');

//.large images -> 24x24px
tepicon20             :s20('icon');
tepicon24             :s('icon24');
tepinfo24             :s('info24');
tepquery24            :s('query24');
teperror24            :s('error24');
tepcolor24            :s('color24');
tepfolderimage24      :s('folderimage24');
tepnewfolder24        :s('newfolder24');
end;//case

end;

//system images ----------------------------------------------------------------

procedure xtep__systemFind(const xindex:longint);

   procedure c(const sc:array of byte);//color only - legacy support
   begin

   tep__20( xindex ,[0] ,sc ,df_mono ,df_color );

   end;

   procedure mc(const sm ,sc:array of byte);//mono + color
   begin

   tep__20( xindex ,sm ,sc ,df_mono ,df_color );

   end;

   procedure cm(const sc ,sm:array of byte);//color + mono
   begin

   tep__20( xindex ,sm ,sc ,df_mono ,df_color );

   end;

   procedure m(const sm:array of byte);//mono only
   begin

   tep__20( xindex ,sm ,[0] ,df_mono ,df_color );

   end;

   procedure m6(const sm:array of byte);//mono only
   begin

   tep__20( xindex ,sm ,[0] ,it_rle6 ,df_color );

   end;

   procedure c24(const sc:array of byte);//color only - legacy support
   begin

   tep__24( xindex ,[0] ,sc ,df_mono ,df_color );

   end;

   procedure cm24(const sc ,sm:array of byte);//color + mono
   begin

   tep__24( xindex ,sm ,sc ,df_mono ,df_color );

   end;

begin

//get
case xindex of
tepNone:;
//.system images -> no fixed width or height
tepOn                 :m(tep_on);
tepOff                :m(tep_off);
tepUp                 :m(mtep_up);
tepDown               :m(mtep_down);
tepLeft               :m(mtep_left);
tepRight              :m(mtep_right);
tepMin                :m(mtep_min);
tepNor                :m(mtep_nor);
tepNormal             :m(mtep_nor);
tepMax                :m(mtep_max);
tepClo                :m(mtep_clo);
tepInf                :m(mtep_inf);//29aug2020
tepMaximise           :m(mtep_max);
tepHelphint           :m(mtep_helphint);//15mar2026
tepBullet             :m(mtep_bullet);//15may2021
tepFull               :m(mtep_full);
tepFullExit           :m(mtep_fullexit);//28dec2024

//.standard images -> fixed height of 20px
tepNew20              :cm(tep_new20,mtep_new20);
tepHome20             :cm(tep_home20,mtep_home20);
tepYesBLANK20         :m(mtep_yesBLANK20);//15mar2026
tepYes20              :m(mtep_yes20);
tepOK20               :m(mtep_yes20);
tepOpen20             :cm(tep_open20,mtep_open20);
tepSave20             :cm(tep_save20,mtep_save20);
tepSaveAs20           :cm(tep_save20,mtep_saveas20);//09may2025
tepDisk20             :cm(tep_disk20,mtep_disk20);
tepClose20            :cm(tep_close20,mtep_close20);
tepClosed20           :m(mtep_closed20);
tepupward20           :m(mtep_upward20);
tepdownward20         :m(mtep_downward20);
tepUndo20             :cm(tep_undo20,mtep_undo20);
tepRedo20             :cm(tep_redo20,mtep_redo20);
tepCut20              :cm(tep_cut20,mtep_cut20);
tepCopy20             :cm(tep_copy20,mtep_copy20);
tepPaste20            :cm(tep_paste20,mtep_paste20);
tepSelectAll20        :cm(tep_selectall20,mtep_selectall20);
tepVisual20           :cm(tep_visual20,mtep_visual20);//03jul2025
tepInfo20             :cm(tep_info20,mtep_info20);//03jul2025
tepNotepad20          :cm(tep_notepad20,mtep_notepad20);//23mar2026
tepPaint20            :cm(tep_paint20,mtep_paint20);//23mar2026, 18sep2025

tepMute20             :m(mtep_mute20);
tepUnmute20           :m(mtep_unmute20);
tepCapture20          :cm(tep_capture20,mtep_capture20);//05jun2025, 02aug2024
tepBlank20            :c(tep_blank20);//03mar2022
tepClock20            :cm(tep_clock20,mtep_clock20);//30nov2025, 03mar2022
tepAlert20            :cm(tep_alert20,mtep_alert20);//30nov2025, 09mar2022
tepBell20             :c(tep_bell20);//14mar2022
tepSonnerie20         :c(tep_sonnerie20);//14mar2022
tepLeft20             :cm(tep_left20,mtep_left20);//27feb2022
tepRight20            :cm(tep_right20,mtep_right20);
tepTop20              :cm(tep_top20,mtep_top20);
tepBottom20           :cm(tep_bottom20,mtep_bottom20);
tepFrame20            :cm(tep_frame20,mtep_frame20);
tepWine20             :c(tep_wine20);
tepUpper20            :cm(tep_upper20,mtep_upper20);
tepLower20            :cm(tep_lower20,mtep_lower20);
tepName20             :cm(tep_name20,mtep_name20);//05jun2025
tepEye20              :cm(tep_eye20,mtep_eye20);
tepStop20             :cm(tep_stop20,mtep_stop20);//16jun2025
tepPlay20             :cm(tep_play20,mtep_play20);
tepPause20            :m(mtep_pause20);//29sep2025
tepRec20              :c(tep_rec20);
tepRewind20           :cm(tep_rewind20,mtep_rewind20);
tepFastForward20      :cm(tep_fastforward20,mtep_fastforward20);
tepVol20              :cm(tep_vol20,mtep_vol20);
tepoptions20          :cm(tep_options20,mtep_options20);
tepgo20               :cm(tep_go20,mtep_go20);//05jun2025
tepNav20              :cm(tep_nav20,mtep_nav20);
tepMax20              :c(tep_max20);
tepOntop20            :c(tep_ontop20);
tepLess20             :cm(tep_less20,mtep_less20);
tepMore20             :cm(tep_more20,mtep_more20);
tepBW20               :cm(tep_bw20,mtep_bw20);
tepHelp20             :cm(tep_help20,mtep_help20);
tepHelpdoc20          :cm(tep_helpdoc20,mtep_go20);
tepSettings20         :cm(tep_settings20,mtep_settings20);//09may2025
tepUM20               :c(tep_um20);
tepAbout20            :cm(tep_about20,mtep_txt20);
tepBE20               :c(tep_be20);
tepRefresh20          :cm(tep_refresh20,mtep_refresh20);
tepFolder20           :cm(tep_folder20,mtep_folder20);
tepColor20            :cm(tep_color20,mtep_color20);
tepColors20           :cm(tep_colors20,mtep_colors20);
tepColormatrix20      :c(tep_colormatrix20);
tepColorPal20         :m6(tep_colorpal20);//19mar2026
tepColorPalDUAL20     :m6(tep_colorpalDual20);//19mar2026
tepColorPalSMALL20    :m6(tep_colorpalSmall20);//19mar2026
tepColorHistory20     :cm(tep_colorhistory20,mtep_colorhistory20);//23mar2021
tepFont20             :cm(tep_font20,mtep_font20);
tepDesktop20          :cm(tep_desktop20,mtep_desktop20);
tepPrograms20         :cm(tep_programs20,mtep_programs20);
tepMenu20             :cm(tep_menu20,mtep_menu20);
tepInvert20           :cm(tep_invert20,mtep_invert20);//05jun2025
tepPrev20             :cm(tep_prev20,mtep_prev20);
tepNext20             :cm(tep_next20,mtep_next20);
tepFav20              :cm(tep_fav20,mtep_fav20);
tepUpone20            :cm(tep_upone20,mtep_upone20);
tepNewfolder20        :cm(tep_newfolder20,mtep_newfolder20);
tepAdd20              :c(tep_add20);
tepAddL20             :cm(tep_addl20,mtep_addl20);
tepSub20              :c(tep_sub20);
tepSubL20             :c(tep_subl20);
tepPanel20            :m(mtep_panel20);//05jul2022
tepEdit20             :cm(tep_edit20,mtep_txt20);
tepFavedit20          :cm(tep_favedit20,mtep_favedit20);
tepFavAdd20           :cm(tep_favadd20,mtep_favadd20);
tepTick20             :cm(tep_tick20,mtep_tick20);//05jun2025, 25mar2021
tepUntick20           :cm(tep_untick20,mtep_untick20);
tepUp20               :c(tep_up20);
tepCD20               :cm(tep_cd20,mtep_cd20);
tepRemovable20        :cm(tep_removable20,mtep_removable20);
tepFolderimage20      :cm(tep_folderimage20,mtep_folderimage20);
tepStartmenu20        :cm(tep_startmenu20,mtep_startmenu20);
tepSchemes20          :cm(tep_schemes20,mtep_schemes20);//07apr2021
tepZoom20             :cm(tep_zoom20,mtep_zoom20);
tepSizeto20           :c(tep_sizeto20);
tepTicktwo20          :c(tep_ticktwo20);//07jun2021
tepUnticktwo20        :c(tep_unticktwo20);
tepTickthree20        :c(tep_tickthree20);//07jun2021
tepUntickthree20      :c(tep_untickthree20);
tepScreen20           :cm(tep_screen20,mtep_screen20);
tepWrap20             :cm(tep_wrap20,mtep_wrap20);//18dec2021
tepNotes20            :cm(tep_notes20,mtep_notes20);//20mar2022
tepFNew20             :m(mtep_fnew20);//23mar2022
tepBack20             :cm(tep_back20,mtep_back20);//23mar2022
tepForw20             :cm(tep_forw20,mtep_forward20);
tepPower20            :c(tep_power20);
tepInstagram20        :c(tep_instagram20);//02dec2023
tepFacebook20         :c(tep_facebook20);//02dec2023
tepMastodon20         :c(tep_mastodon20);//11dec2023
tepTwitter20          :c(tep_twitter20);//02dec2023
tepsourceforge20      :c(tep_sourceforge20);//02dec2023
tepGitHub20           :c(tep_GitHub20);//02dec2023
tepbulletsquare20     :m(mtep_bulletsquare20);//15mar2025
tepOutline20          :m(mtep_frame20);
tepChecker20          :m(mtep_selectall20);
tepList20             :cm(tep_list20,mtep_list20);
tepSwap20             :m(mtep_swap20);//14jul2025
tepTemp20_noscaling   :c(tep_temp20);//21mar2026
tepTemp20             :c(tep_temp20);//21mar2026

//.graphic tool images
tepDither20           :m(mtep_dither20);//19jul2025
tepRect20             :m(mtep_rect20);
tepLine20             :m(mtep_line20);
tepPen20              :m(mtep_pen20);
tepDrag20             :m(mtep_drag20);
tepPot20              :m(mtep_pot20);
tepGPot20             :m(mtep_gpot20);
tepCls20              :m(mtep_cls20);
tepMove20             :m(mtep_move20);
tepEyedropper20       :m(mtep_eyedropper20);
tepWraphorz20         :m(mtep_wraphorz20);
tepImage20            :cm(tep_bmp20,mtep_image20);//09nov2025
tepCode20             :cm(tep_dpr20,mtep_code20);//09nov2025
tepUnit20             :cm(tep_pas20,mtep_unit20);//09nov2025
tepCompress20         :cm(tep_zip20,mtep_compress20);//09nov2025

//.file format teps
tepXXX20              :c(tep_xxx20);
tepBMP20              :c(tep_bmp20);//,mtep_bmp20);
tepWMA20              :c(tep_wma20);
tepC2P20              :c(tep_c2p20);
tepC2V20              :c(tep_c2v20);
tepINI20              :cm(tep_txt20,mtep_txt20);//hasn't got it's own specific image yet - 24jan2022
tepTXT20              :cm(tep_txt20,mtep_txt20);
tepCUR20              :c(tep_cur20);//24may2022
tepEXE20              :cm(tep_exe20,mtep_exe20);
tepZIP20              :c(tep_zip20);
tep7Z20               :c(tep_zip20);
tepXML20              :c(tep_xml20);
tepHTM20              :c(tep_htm20);
tepBWD20              :c(tep_bwd20);
tepBWP20              :c(tep_bwp20);
tepRTF20              :c(tep_rtf20);
tepDIC20              :c(tep_dic20);
tepMID20              :cm(tep_mid20,mtep__mid20);//11aug2025
tepBCS20              :c(tep_color20);
tepR20                :c(tep_r20);
tepHide20             :c(tep_hide20);
tepSFEF20             :c(tep_sfef20);
tepQuoter20           :c(tep_Quoter20);
tepPAS20              :c(tep_pas20);//23jul2024
tepDPR20              :c(tep_dpr20);//20mar2025
tepC320               :c(tep_c320);//20aug2024
tepREF320             :c(tep_ref320);//20aug2024
tepnupkg20            :cm(tep_choco20,mtep_choco20);//09nov2025, 31mar2025

tepRotate20           :m(mtep_rotate20);//09may2025
tepRotateLeft20       :m(mtep_rotateleft20);
tepMirror20           :m(mtep_mirror20);
tepFlip20             :m(mtep_flip20);
tepPrint20            :m(mtep_print20);
tepBackground20       :cm(tep_bmp20,mtep_background20);
tepSquircle20         :m(mtep_squircle20);
tepDiamond20          :m(mtep_diamond20);
tepCircle20           :m(mtep_circle20);
tepSquare20           :m(mtep_square20);
tepSolid20            :m(mtep_solid20);
tepTransparent20      :m(mtep_transparent20);
tepAsis20             :m(mtep__asis20);
tepTest20             :m(mtep_test20);


//.large images -> 32x32px
tepIcon20             :c(program_icon20h);
tepIcon24             :c24(program_icon24h);
tepIcon24b            :c24(program_icon24hB);
tepIcon24c            :c24(program_icon24hC);
tepIcon24d            :c24(program_icon24hD);
tepInfo24             :c24(tep_info24);
tepQuery24            :cm24(tep_query24,mtep_help20);
tepError24            :c24(tep_error24);
tepColor24            :cm24(tep_color24,mtep_color20);//26feb2021
tepFolderimage24      :cm24(tep_folderimage24,mtep_folderimage20);//05jun2025, 13apr2021
tepNewfolder24        :cm24(tep_newfolder24,mtep_newfolder20);//05jun2025, 14apr2021

//.fallback image
else                   c(tep_unknown20);
end;//case

end;


//file based images ------------------------------------------------------------
procedure xtep__folderFind(const xindex:longint);
begin

//check
if (xindex<ls_folder) or (xindex>=ls_app) then exit;

//get
tep__20b( xindex ,nil ,@tep_core.fdata[xindex] ,df_mono ,df_color );

end;


//app specific images ----------------------------------------------------------
procedure xtep__appFind(const xindex:longint);
begin

app__customTEP(xindex);

end;


end.
