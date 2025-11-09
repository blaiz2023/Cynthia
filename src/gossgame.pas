unit gossgame;

interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gosswin2, gossroot, gossio, gosswin, gossimg, gossgui {$ifdef snd},gosssnd{$endif} {$ifdef gamecore},gamefiles{$endif};
{$align on}{$iochecks on}{$O+}{$W-}{$U+}{$V+}{$B-}{$X+}{$T-}{$P+}{$H+}{$J-} { set critical compiler conditionals for proper compilation - 10aug2025 }
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
//## Library.................. GameCore game support (gossgame.pas)
//## Version.................. 4.00.11024 (+66)
//## Items.................... 9
//## Last Updated ............ 02oct2025, 16sep2025, 08aug2025, 29jul2025, 14jul2025, 06jul2025, 11feb2025, 04feb2025, 01feb2025
//## Lines of Code............ 15,100+
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
//## gossgame.pas ............ game support (optional)
//## gamefiles.pas ........... internal files for game (optional)
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | game__*                | family of procs   | 1.00.3150 | 08aug2025   | Game control procs - 29jul2025, 16jul2025, 06jul2025
//## | pic8__*                | family of procs   | 1.00.1680 | 24jul2025   | Pic8 rapid-render game sprite - supports images from 1x1 to 128x128. Dual 32bit color palettes, indivdual color flash/flicker modes. Animate pixels and create movement perception without animation or the need for multiple cells. Simple, compact and fast. Render speed: ~60fps++ at 1920x1080 using 20x20 tiles on an Intel Core i5 2.5 GHz. - 11feb2025
//## | tpic8                  | tobjectex         | 1.00.002  | 04jul2025   | Dynamically created version of tpiccore8
//## | tsnd                   | tstr8             | 1.00.002  | 04jul2025   | Data stream for sound (wave)
//## | tpal8                  | tbasiccontrol     | 1.00.2040 | 14jul2025   | Dual 32bit color palette and combined color toolbar for Tex editor - 04jul2025, 11feb2025
//## | tpre8                  | tbasiccontrol     | 1.00.032  | 04jul2025   | Preview panel for displaying realtime view of pic8 sprites - 04feb2025
//## | ttex                   | tbasiccontrol     | 1.00.1250 | 20jul2025   | Realtime sprite editor panel - 14jul2025, 04jul2025, 11feb2025
//## | ttexedit               | tbasiccontrol     | 1.00.462  | 20jul2025   | Realtime sprite editor - 14jul2025, 04jul2025, 11feb2025
//## | tsndgen                | tobjectex         | 1.00.2040 | 24jul2025   | Sound generator - multi-channel, tri-tone, stereo sound generator - 10jul2025
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


const
   fps__slotsperfps  =8;
   fps__limit        =30;
   fps__listlimit    =fps__slotsperfps*fps__limit;//0..240

   //pic8
   pic8_zoomlimit    =10000;//10K

   //pal8
   csColor           =0;
   csGap             =1;

   //tex tool codes
   ttcZoom            =0;
   ttcHand            =1;
   ttcEye             =2;
   ttcSel             =3;
   ttcErase           =4;
   ttcPen             =5;
   ttcDrag            =6;
   ttcLine            =7;
   ttcRect            =8;
   ttcPot             =9;
   ttcGPot            =10;
   ttcMove            =11;
   ttcCls             =12;
   ttcMax             =12;

   //tex tool support codes
   tscMoveXY          =0;
   tscMoveXonly       =1;
   tscMoveYonly       =2;

   tscSeloff          =0;
   tscSeledit         =1;
   tscSelblock        =2;

   tscMoveboth        =0;//for ttcMove tool
   tscMovecol         =1;
   tscMovesel         =2;

   //game menu actions
   gmaNone            =0;
   gmaBack            =1;
   gmaSelect          =2;
   gmaLess            =3;
   gmaMore            =4;
   gmaFinished        =5;
   //internal
   gmaLeft            =6;
   gmaRight           =7;
   gmaUp              =8;
   gmaDown            =9;
   gmaMouseHover      =10;
   gmaMouseSelect     =11;
   gmaPrevpage        =12;//menu
   gmaNextpage        =13;
   gmaMax             =13;

type
   ttex           =class;
   tpal8          =class;
   tpre8          =class;


//game support -----------------------------------------------------------------
   tgamemenuitem=packed record
      caption :string;
      value   :string;
      cmd     :string;
      calign  :byte;//0=left, 1=center, 2=right
      valign  :byte;
      //interna;
      area    :twinrect;//area on screen for mouse to click
      end;

   tgamemenu=packed record
      nohistory:boolean;//true=causes menu to always display with first item highlight, such as a confirm prompt etc
      title    :string;
      menuname :string;
      selector :longint;//sprite slot -> optional -> used to preference selected menu item with a sprite - 21jul2025
      items    :array[0..29] of tgamemenuitem;
      count    :longint;
      end;

   tgamemenucolors=packed record
      back     :longint;
      title    :longint;
      text     :longint;
      highlight:longint;
      end;

   tgamemenuevent      =procedure(var xmenu:tgamemenu;var xmenucolors:tgamemenucolors;const xmenuname:string) of object;
   tgamemenuclickevent =procedure(xmenuname,xcmd:string;xaction:longint;xmouseaction:boolean;var handled:boolean) of object;

   tgametimerfps=record
      fps       :longint;
      delay     :longint;
      rundelay  :longint;
      mindelay  :longint;
      runrate   :double;
      time      :comp;
      time1000  :comp;
      fpscount  :longint;
      end;

   tgamemenuinfo=packed record
      //host specific
      menu           :tgamemenu;
      colors         :tgamemenucolors;
      event          :tgamemenuevent;
      clickevent     :tgamemenuclickevent;
      once           :boolean;
      prevarea       :twinrect;
      nextarea       :twinrect;
      //history -> keep track of 30 menus
      hmenuname      :array[0..29] of string;
      hindex         :array[0..29] of longint;
      //active menu info
      activename     :string;
      cmd            :string;
      action         :longint;
      ftitle         :longint;//font for menu title
      ftitleH        :longint;
      fitem          :longint;//font for menu items
      fitemH         :longint;
      fspace         :longint;

      fstitle        :longint;//smaller font set
      fstitleH       :longint;
      fsitem         :longint;
      fsitemH        :longint;
      fsspace        :longint;
      end;

   tgamefont=packed record
      ok:boolean;//true=font is ok to use, false=don't use this font
      name:string;
      size:longint;
      bold:boolean;
      lgf:tstr8;
      height:longint;
      end;

   tgamefonts=packed record
      fonts:array[0..29] of tgamefont;
      count:longint;
      end;

   tgameflash=packed record
      level255 :longint;//100..255
      modeup   :boolean;
      timeref  :comp;
      end;

{game__ support}
   tgameinfo=class(tobjectex)//dynamically created version of "tpiccore8"
   private
    igui:tbasicsystem;
    fonpaint:tnotifyevent;
    fondefaultLayout_keyboard,fondefaultLayout_mouse:tnotifyevent;
    procedure xmouse_scaleChangeCheck;
   public
    //create
    constructor create(xgui:tbasicsystem); //override;
    destructor destroy; override;
    property gui:tbasicsystem read igui;

    //events
    property onpaint                  :tnotifyevent read fonpaint                  write fonpaint;//call host paint proc
    property ondefaultLayout_keyboard :tnotifyevent read fondefaultLayout_keyboard write fondefaultLayout_keyboard;//call host for game-specific keyboard layout
    property ondefaultLayout_mouse    :tnotifyevent read fondefaultLayout_mouse    write fondefaultLayout_mouse;
    //support procs
    procedure _ontimer(sender:tobject);
    procedure _onpaint(sender:tobject);
    function _onnotify(sender:tobject):boolean;
    function _onshortcut(sender:tobject):boolean;
    procedure _onkey(sender:tobject;xrawkey:longint;xdown:boolean);
    procedure _onmouse(sender:tobject;xmode,xbuttonstyle,dx,dy,dw,dh:longint);
   end;

{timg8}
   plistpixel128=^tlistpixel128;
   tlistpixel128=packed array[0..16383] of byte;

   plistcolor32=^tlistcolor32;
   tlistcolor32=packed array[0..127] of tcolor32;//slot #0 is reserved for transparent color, regardless of color value

   plistcolor24=^tlistcolor24;
   tlistcolor24=packed array[0..127] of tcolor24;

   plistcolor8=^tlistcolor8;
   tlistcolor8=packed array[0..127] of tcolor8;

   plistval8=^tlistval8;
   tlistval8=packed array[0..high(tlistcolor32)] of byte;

   plistflashstate=^tlistflashstate;
   tlistflashstate=packed array[0..fps__listlimit] of boolean;//each slot = 1/4 fps, 0=static, 1=0.25fps, 120=30fps

   pprogresslist=^tprogresslist;
   tprogresslist=packed array[0..11] of double;//less rounding errors than "single" - 13jul2025

   ppiccore8=^tpiccore8;//use "pic8__renderinit()" to init colors for drawing and "pic8__draw24()" to draw image on screen buffer
   tpiccore8=packed record
      //dimensions
      w      :longint;//1..128
      h      :longint;//1..128

      //progress -> not a saved option, but realtime display option -> progress[0]=0..1 => down shift colors 11-20 to 1-10 -> allows for "a progression effect" without needing an animation - 11feb2025
      progress:tprogresslist;//0..1

      //pixels
      plist  :tlistpixel128;
      pcount :longint;//always equal to w*h

      //color lists
      //.main color set (static and flash)
      elist24     :tlistcolor24;//static
      elist8      :tlistcolor8;
      olist24     :tlistcolor24;//flash
      olist8      :tlistcolor8;

      //.secondary color set (alt 1 and alt 2)
      elist24b    :tlistcolor24;//alt 1 - static
      elist8b     :tlistcolor8;
      olist24b    :tlistcolor24;//alt 2 - flash
      olist8b     :tlistcolor8;

      flist  :tlistval8;//flash list -> switch between "elist" and "olist" at flash rates of 0..30fps (where 0=static=even=elist)
      flist2 :tlistval8;//flash list -> switch between "elist" and "olist" at flash rates of 0..30fps (where 0=static=even=elist)
      //render lists - list of colors and alpha values finalised for rendering at maximum throughput - 15jul2025, 01feb2025
      rlist24 :tlistcolor24;//list of render ready 24 bit colors "r,g,b"
      rlist8  :tlistcolor8;//list of render read 8 bit alpha values "a"
      tlist8  :tlistcolor8;
      tlist8REF:longint;

      //optional special effects
      lsmooth     :tlistval8;//0=off, 1..255=yes => smooth flash
      lsmooth2    :tlistval8;//0=off, 1..255=yes => smooth flash
      lflick      :tlistval8;//0=off, 1..100 => flicker power
      lflick2     :tlistval8;//0=off, 1..100 => flicker power
      lflickrate  :tlistval8;//flicker rate (fps)
      lflickrate2 :tlistval8;//flicker rate (fps)

      //editing and GUI sync support
      dataid   :longint;//increments when a color changes
      modified :boolean;
      findex   :longint;//currently focused foreground color index
      bindex   :longint;//background
      uselist2ForThisColorIndex:longint;//-1=off
      end;

   pdrawfastinfo=^tdrawfastinfo;
   tdrawfastinfo=packed record
      core      :ppiccore8;
      clip      :twinrect;
      rs24      :pcolorrows24;
      x         :longint;
      y         :longint;
      xzoom     :longint;//1..1,000
      yzoom     :longint;//1..1,000
      power255  :longint;//0..255
      mirror    :boolean;
      flip      :boolean;
      end;

{tpic8}
   tpic8=class(tobjectex)//dynamically created version of "tpiccore8"
   public
    //vals
    core:tpiccore8;
    //create
    constructor create;
    destructor destroy; override;
   end;

{tsnd}
   tsnd=class(tstr8);


{tpal8}
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//pppppppppppppppppp
   tpalcell=record
      mode         :longint;//0=progress indicator/gap cell, 1=color index cell
      cap          :string;
      cap2         :string;
      colindex     :longint;
      setindex     :longint;
      setshow      :boolean;
      settrigger   :double;
      area         :twinrect;
      wmultipler   :longint;
      xunit1       :longint;
      xunit2       :longint;
      progressslot :longint;
      canedit      :boolean;
      end;

   tpalcells=record
      cells  :packed array[0..255] of tpalcell;
      count  :longint;
      ccount :longint;//number of cells that represent color indexes
      width  :longint;//total width
      end;

   tpal8=class(tbasicscroll)
   private
    icolorindex03REF,iscrollidleref,ifasttimer,itimer250:comp;
    ihost:tobject;
    icore:ppiccore8;
    ilist:tpalcells;
    icolorindex03,iscrollnotidle_scrollx,iscrollprevx,idownscrollx,iscrolltime,iscrollto,ilastscrollx,iscrollx,ilastmousex,ishiftscrollx,iscrollspeed,ionefps,ispacecount,ilastcellindex,icellindex,icellhoverindex:longint;
    ifindfb,iupdateprevwhenidle,iflashon,iprogresschangedref:boolean;
    icolorsetsheader,iref:string;
    ireflist24:tlistcolor24;
    ireflist8 :tlistcolor8;
    iscreen:tbasiccontrol;
    iflash,iflicker,iflickerpert,iprogresscontrol:tsimpleint;
    itoolbar:tbasictoolbar;
    ilastcommitref:tobject;
    function getecolor(x:longint):tcolor32;
    function getocolor(x:longint):tcolor32;
    function getecolor2(x:longint):tcolor32;
    function getocolor2(x:longint):tcolor32;
    procedure setecolor(x:longint;c:tcolor32);
    procedure setocolor(x:longint;c:tcolor32);
    procedure setecolor2(x:longint;c:tcolor32);
    procedure setocolor2(x:longint;c:tcolor32);
    procedure findarea(sx,sy:longint);
    function xundoprimed:boolean;
    procedure xprimeundo;
    procedure xchanged;
    procedure xcmd(n:string);
    procedure xmoretime_colorindex03;
    procedure xscreen__preundoredo(sender:tobject);
    procedure xscreen__oncommitval(sender:tobject);
    procedure xscreen__onpaint(sender:tobject);
    function xscreen__onnotify(sender:tobject):boolean;
    function xscreen__onnotify2(sender:tobject;xother:boolean;noverride:string):boolean;
    function xprogresschanged:boolean;
    procedure xscreen__onreadwriteval(sender:tobject;var xval:longint;xwrite:boolean);
    procedure xscreen__onclick2(sender:tobject);
    function xscreen__onclick(sender:tobject):boolean;
    procedure xscreen__oncaption(sender:tobject;var xval:string);
    function findex(var fi:longint;var fok:boolean):boolean;
    function fcellindex:longint;
    function fcellindex2(var xcellindex:longint):boolean;
    function fsetindex:longint;
    function fcanedit:boolean;
    function xcanedit(xcolindex:longint):boolean;
    function xfindcell(xcolorindex:longint;var xcellindex:longint):boolean;
    procedure xsync;
    function xaddcell(const xcap,xcap2:string;xmode,xcolindex,xsetindex:longint;xsettrigger:double;xcanedit:boolean):boolean;
    procedure xaddcells;
    function xscrollidle:boolean;
    procedure xscrollnotidle;
    function xsafescrollx(x:longint):longint;
    procedure xscrolltime(x:longint);
    procedure xscrollto(x:longint);
    procedure xscrolltime0(x:longint);//doesn't update "iscrollprev"
    procedure xscrollto0(x:longint);//doesn't update "iscrollprev"
    procedure xscrollprev;
    procedure xscrolloff;
   public
    //create
    constructor create(xparent:tobject;xhost:tobject;xcore:ppiccore8); virtual;
    constructor create2(xparent:tobject;xhost:tobject;xcore:ppiccore8;xstart:boolean); virtual;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    function _onshortcut(sender:tobject):boolean; override;
    function getalignheight(xclientwidth:longint):longint; override;
    procedure showmenuFill(xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string); override;
    function showmenuClick(sender:tobject;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean; override;
    procedure disconnect;
    procedure setfocus; override;
    //information
    function cellheight:longint;
    function cellwidth:longint;
    property elist[x:longint]:tcolor32 read getecolor write setecolor;
    property olist[x:longint]:tcolor32 read getocolor write setocolor;
    property elist2[x:longint]:tcolor32 read getecolor2 write setecolor2;
    property olist2[x:longint]:tcolor32 read getocolor2 write setocolor2;
    function fcolor32(xindex03:longint):tcolor32;//13jul2025
    function fcolor24(xindex03:longint):tcolor24;//13jul2025
    function xeditlist2:boolean;
    function xuselist2forthiscolorindex:longint;
    function fcolindex:longint;
    function bcolindex:longint;
    //workers
    procedure scrolltocolor(xcolindex:longint);
    procedure copycolor;
    procedure pastecolor(xshiftright:boolean);
    procedure copycolorset(xsetindex:longint);
    procedure pastecolorset(xsetindex:longint);
    procedure copycolorpalette;
    procedure pastecolorpalette;
   end;

{tpre8}
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//eeeeeeeeeeeeeeeeeeeee
   tpre8=class(tbasiccontrol)//previewer
   private
    ifasttimer:comp;
    ihost:tobject;
    icore:ppiccore8;
    ibuffer:trawimage;
   public
    //create
    constructor create(xparent:tobject;xhost:tobject;xcore:ppiccore8); virtual;
    constructor create2(xparent:tobject;xhost:tobject;xcore:ppiccore8;xstart:boolean); virtual;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    procedure _onpaint(sender:tobject); override;
    procedure disconnect;
   end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
{ttexedit}
   ttexedit=class(tbasicscroll)//sprite editor
   private
    itoolpal,inavcap,itoolset:tbasictoolbar;
    irightcolumn:tbasicscroll;
    inav:tbasicnav;//left side navigation panel
    itex:ttex;//image editor
    ipal:tpal8;//bottom color palette
    ipre:tpre8;//right side preview panel
    iid,inew_width,inew_height:longint;
    itimer100,itimer350,itimer500:comp;
    isubframes,idisconnected,ipreviewshow,inavshow,iloaded,ibuildingcontrol:boolean;
    imustselectfile,isettingsref:string;
    fonfetcheditor:tgetobjectevent;
    procedure __onclick(sender:tobject);
    procedure xcmd(n:string);
    procedure xshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
    function xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
    procedure xupdatebuttons;
    procedure xupdatecurpos;
    function xnavfile:string;
    function xfileinuse(const xfilename:string):boolean;
   public
    //create
    constructor create(xparent:tobject); override;
    constructor create2(xparent:tobject;xscroll,xstart:boolean); override;//xscroll is ignored
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    procedure disconnect;

    //information
    function filename:string;
    property pal:tpal8 read ipal;
    
    //settings
    procedure loadsettings(a:tvars8);
    procedure savesettings(a:tvars8);

    //save
    function cansave:boolean;
    procedure save;

    //events
    property onfetcheditor:tgetobjectevent read fonfetcheditor write fonfetcheditor;//fetches other editor instances for "file in use" checking
   end;


{ttex}
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//111111111111111111111
   ttextool=packed record
      inuse         :boolean;
      name          :packed array[0..19] of char;
      tep           :longint;
      candraw       :boolean;
      canwrap       :boolean;
      wrap          :boolean;
      candither     :boolean;
      dither        :boolean;
      canzoomin     :boolean;
      zoomin        :boolean;
      canfast       :boolean;
      fast          :boolean;
      canmovexy     :boolean;
      movexy        :longint;//0=xy, 1=x only, 2=y only
      canuseonce    :boolean;//for eye-dropper -> switch back to previous tool
      useonce       :boolean;
      penclass      :boolean;
      canselmode    :boolean;
      selmode       :longint;
      canmovestyle  :boolean;
      movestyle     :longint;//0=color+selection, 1=color only, 2=selection only - 20jul2025
      end;
   ttextoollist=packed array[0..29] of ttextool;
   ttextools=packed record
      tools         :ttextoollist;
      count         :longint;//number of tools
      tool          :longint;//tool in use
      lasttool      :longint;//last tool in use
      end;

   ttex=class(tbasiccontrol)//sprite editor panel
   private
    itoollist :ttextools;
    itoolcap  :array[0..high(ttextoollist)] of string;
    itoolcmd  :array[0..high(ttextoollist)] of string;
    itoolhelp :array[0..high(ttextoollist)] of string;
    isetbar   :tbasictoolbar;
    iselcol32 :tcolor32;
    
    ilist:tdynamicpoint;
    ipal:tobject;//optional pointer to external pal8 control
    icore     :tpiccore8;
    iover     :tpiccore8;
    ioversel  :tpiccore8;
    itemp     :tpiccore8;
    isel      :tpiccore8;//actual sel data
    iselfinal :tpiccore8;//sel output layer for screen
    iparea:array[0..high(tlistcolor32)] of twinrect;
    ihold:array[0..high(tprogresslist)] of boolean;
    ibuffer24:trawimage;
    iundotemp_data:string;
    iundotemp_dataid:longint;
    iundoinfo:tstr8;
    iundolist:array[0..99] of string;
    itimer500,iflashontimer,itimerfast,ipainttimer:comp;
    izoomlimit,iframesize,iscrollx,iscrolly,izoom,ixboxcontroller,ibytes,ilastokindex,isizelimit,idragindex,ihoverindex:longint;
    icanvasxy:tpoint;
    idisconnected,iflashon,ixboxfeedback,icantool:boolean;
    ipreview:tbasicimage;
    izoominref,iflashref,ifilename,iname,iref:string;
    idownscrollx,idownscrolly,itoollastx,itoollasty:longint;
    izoominxy,itooldownxy:tpoint;
    itoolval:longint;
    fonpreUndoredo:tnotifyevent;
    function getdata__forundo:string;
    procedure setdata__forundo(x:string);
    function getdata:string;
    procedure setdata(x:string);
    function getdata64:string;
    function getval(x:longint):longint;
    procedure setval(x,xval:longint);
    procedure setval2(var xcore:tpiccore8;x,xval:longint);
    function getval2(var xcore:tpiccore8;x:longint):longint;
    function getdataid:longint;
    function getpixel(x,y:longint):longint;
    procedure setpixel(x,y,xval:longint);
    function getpixel2(var xcore:tpiccore8;x,y:longint):longint;
    procedure setpixel2(var xcore:tpiccore8;x,y,xval:longint);
    function getecolor(x,y:longint):tcolor32;
    function getocolor(x,y:longint):tcolor32;
    function getecolorint(x,y:longint):longint;
    function find__cell(sx,sy:longint;xsaferange:boolean):longint;
    function find__cellwrap(sx,sy:longint):longint;//19jul2025
    function find__pal(sx,sy:longint):longint;
    procedure xzoomin(vzoomin:longint);
    procedure xzoomto(vzoom:longint);
    function gettool:longint;
    procedure settool(x:longint);
    function getlasttool:longint;
    procedure dotool(xindex:longint;xdownstroke,xupstroke,xleft,xinrange:boolean);//12jul2025
    function setdata2(x:string):boolean;
    function xheadlen:longint;
    function xcollabel(xindex:longint):char;
    procedure showmenuFill(xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string); override;
    function showmenuClick(sender:tobject;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean; override;
    procedure xfindline(s,d:tpoint;dlist:tdynamicpoint);
    function getpcore:ppiccore8;
    function getmodified:boolean;
    function getfindex:longint;
    function getbindex:longint;
    procedure setfindex(x:longint);
    procedure setbindex(x:longint);
    procedure setxboxcontroller(x:longint);
    procedure xbox;
    procedure sethold(xindex:longint;xval:boolean);
    function gethold(xindex:longint):boolean;
    procedure setpal(x:tobject);
    procedure xsyncbytes;
    function xcanhand:boolean;
    procedure xclearsubcore(var x:tpiccore8);
    //.multi-undo support
    procedure xundo__init;
    procedure xundo__pushnew0;
    procedure xundo__pushnew(const x:string);
    procedure xundo__clear;
    function xundo__filter(x:longint):longint;
    procedure xundo__savetofile(x:string);
    procedure xundo__loadfromfile(x:string);
    //..shorthand verions
    function xundoprimed:boolean;
    procedure xprimeundo;
    procedure xchanged;//19jul2025
    //.overlay support
    procedure xover__clear;
    procedure xover__renderinfofromcore;
    procedure xoversel__clear;
    procedure xoversel__renderinfofromcore;
    procedure xtemp__clear;
    //.selection support
    procedure xsel__clear;
    procedure xsel__check;
    //.zoom support
    procedure setzoom(x:longint);
    function getscrollx:longint;
    function getscrolly:longint;
    procedure setscrollx(x:longint);
    procedure setscrolly(x:longint);
    function xzoomscale:longint;
    procedure xcreatetools;
    //.tool support
    function gettoolcap(xindex:longint):string;
    function gettoolcmd(xindex:longint):string;
    function gettoolhelp(xindex:longint):string;
    function gettoolitem(xindex:longint):ttextool;
    function getdither:boolean;
    procedure setdither(x:boolean);
    function getwrap:boolean;
    procedure setwrap(x:boolean);
    function getfast:boolean;
    procedure setfast(x:boolean);
    function getzoomin:boolean;
    procedure setzoomin(x:boolean);
    function getuseonce:boolean;
    procedure setuseonce(x:boolean);
    function getmovexy:longint;
    procedure setmovexy(x:longint);
    function getmovestyle:longint;
    procedure setmovestyle(x:longint);
    function getselmode:longint;
    procedure setselmode(x:longint);
    function gettoolsettings:string;
    procedure settoolsettings(x:string);
    procedure __onclick(sender:tobject);
    procedure setsetbar(x:tbasictoolbar);
    procedure xsetbarfill;
    procedure xsetbarsync;
    procedure xnewcoresyncvars;
   public
    ofolder:string;//used by NEW to store a newly named sprite -> up to host to keep this up to date
    ohostreload:boolean;//true=tells host it should update it's nav panel as a new sprite has been saved by this editor
    onewwidth:longint;
    onewheight:longint;
    omustpaint1:boolean;
    oscrollcolor:boolean;
    ofileinuse:boolean;
    obadfile:boolean;
    //create
    constructor create(xparent:tobject); virtual;
    constructor create2(xparent:tobject;xstart:boolean); virtual;
    destructor destroy; override;
    procedure disconnect;
    procedure _ontimer(sender:tobject); override;
    procedure _onpaint(sender:tobject); override;
    function _onnotify(sender:tobject):boolean; override;
    //information
    property modified:boolean read getmodified;
    property len:longint read icore.pcount;
    property bytes:longint read ibytes;
    property width:longint read icore.w;
    property height:longint read icore.h;
    property sizelimit:longint read isizelimit;
    property hoverindex:longint read ihoverindex;
    property data:string read getdata write setdata;
    property data64:string read getdata64 write setdata;//base64
    property dataid:longint read getdataid;//increments each time a data/pixel changes
    property data__forundo:string read getdata__forundo write setdata__forundo;//19jul2025
    property val[x:longint]:longint read getval write setval;
    property val2[var xcore:tpiccore8;x:longint]:longint read getval2 write setval2;
    procedure incval(x,xby:longint);
    property pixel[x,y:longint]:longint read getpixel write setpixel;
    property pixel2[var xcore:tpiccore8;x,y:longint]:longint read getpixel2 write setpixel2;
    property ecolor[x,y:longint]:tcolor32 read getecolor;
    property ocolor[x,y:longint]:tcolor32 read getocolor;
    property ecolorint[x,y:longint]:longint read getecolorint;

    //tool support
    function toolcount:longint;
    property tool:longint read gettool write settool;
    property lasttool:longint read getlasttool;
    function toollabel:string;
    function activetoollabel:string;
    property toolitem[xindex:longint]:ttextool read gettoolitem;
    property toolcap [xindex:longint]:string   read gettoolcap;
    property toolcmd [xindex:longint]:string   read gettoolcmd;
    property toolhelp[xindex:longint]:string   read gettoolhelp;
    property toolsettings:string               read gettoolsettings write settoolsettings;
    property setbar:tbasictoolbar              read isetbar         write setsetbar;
    //.support
    //.draw
    function candraw:boolean;
    //.dither
    function candither:boolean;
    property dither:boolean read getdither write setdither;
    //.wrap
    function canwrap:boolean;
    property wrap:boolean read getwrap write setwrap;
    //.fast
    function canfast:boolean;
    property fast:boolean read getfast write setfast;
    //.zoomin
    function canzoomin:boolean;
    property zoomin:boolean read getzoomin write setzoomin;
    //.move
    function canmovexy:boolean;
    property movexy:longint read getmovexy write setmovexy;
    function canmovex:boolean;
    function canmovey:boolean;
    //.useonce
    function canuseonce:boolean;
    property useonce:boolean read getuseonce write setuseonce;
    //.selmode
    function canselmode:boolean;
    property selmode:longint read getselmode write setselmode;
    //.movestyle
    function canmovestyle:boolean;
    property movestyle:longint read getmovestyle write setmovestyle;
    function canmovecol:boolean;
    function canmovesel:boolean;

    //.low level support
    function penclass:boolean;

    //other
    function locked:boolean;
    property filename:string read ifilename;
    property name:string read iname;
    property f:longint read getfindex write setfindex;
    property findex:longint read getfindex write setfindex;
    property b:longint read getbindex write setbindex;
    property bindex:longint read getbindex write setbindex;
    property pcore:ppiccore8 read getpcore;
    property hold[xindex:longint]:boolean read gethold write sethold;
    property pal:tobject read ipal write setpal;
    function havepal:tpal8;
    //active values
    function activeselmode:longint;
    function activezoom:longint;
    function activescrollx:longint;
    function activescrolly:longint;
    property zoom:longint read izoom write setzoom;
    property scrollx:longint read getscrollx write setscrollx;
    property scrolly:longint read getscrolly write setscrolly;
    //xbox
    property xboxcontroller:longint read ixboxcontroller write setxboxcontroller;
    property xboxfeedback:boolean read ixboxfeedback write ixboxfeedback;
    //workers
    procedure setparams(xwidth,xheight:longint);
    procedure setparams2(xwidth,xheight:longint;xclear,xforce,xpaint:boolean);
    procedure menu__edit;
    function cannew:boolean;
    procedure newprompt;
    function cancopy:boolean;
    procedure copy;
    procedure icopy;
    procedure pcopy;
    function canpaste:boolean;
    procedure paste;
    procedure pastefit;
    function icanpaste:boolean;
    procedure ipaste;
    function canredo:boolean;
    function canundo:boolean;
    procedure redo;
    procedure undo;
    function undo__primed:boolean;//11jul2025
    procedure undo__primenew;//start undo
    procedure undo__pushnew;//lodge undo data if changes detected
    procedure undo__cleartempdata;
    procedure swapfb;
    function canadjust:boolean;
    procedure adjust(x:string);
    procedure adjust2(x:string;v1,v2,v3,v4:longint);
    procedure new(xfilename:string;xwidth,xheight:longint);
    function cansave:boolean;
    procedure save;
    procedure save2(xforce:boolean);
    procedure loadfromfile(x:string);//14jul2025
    procedure clear;
    procedure selclear;
    procedure selall;
    procedure selinv;

    //events
    property onpreUndoredo:tnotifyevent read fonpreUndoredo write fonpreUndoredo;//notify a control that the "undo" or "redo" action is about to be used -> allows a control to push any uncommited content to the undo system before use - 11jul2025

    //status
    function status__xy:string;

    //support procs
    function xdither(scol,sx,sy:longint;xswap:boolean):longint;
    function xdither2(scol,sf,sb,sx,sy:longint;xswap:boolean):longint;
    function xditherdetect(sx,sy:longint;xswap:boolean):boolean;
    function toimage(s:tobject):boolean;
    function fromimage(s:tobject):boolean;
    function fromimage2(s:tobject;xfillundo:boolean):boolean;
    function xywrap(x,y:longint):tpoint;
    function xcmd(n:string):boolean;
   end;


{tsndgen}
   tsoundtone=record
      dhiss       :longint;//0=tone, 1..N=hiss
      dstep       :longint;//tone frequency in data steps -> not used for hiss
      dstepcount  :longint;
      dholdcount  :longint;//linked to "lhold"
      dvolL       :longint;//size of wave signal
      dvolR       :longint;//size of wave signal
      dup         :boolean;//wave signal direction -> up/down state

      //time support -> change frequency of tone or hiss level over time
      thiss       :array[0..9] of longint;//0=tone, 1..N=hiss
      tstep       :array[0..9] of longint;//data steps
      thold       :array[0..9] of longint;//time in data steps to hold frequency/hisslevel before moving on to next list item
      tmute       :array[0..9] of boolean;//used for negative "time" values
      tvolL       :array[0..9] of longint;
      tvolR       :array[0..9] of longint;
      tcount      :longint;//number of list items, 0=inactive
      tindex      :longint;//current list item in use
      tnext       :longint;//next list item in use
      end;

   tsoundinfo=record
      mode        :longint;
      runtime     :longint;//in data steps
      fadecount   :longint;//0=tone/hiss nolonger in use, 1..N=in use or being faded out - 10jul2025
      tonelist    :array[0..3] of tsoundtone;

      //support
      basefeq     :longint;
      basevol     :double;
      basebal     :double;
      end;

   psndbuffer=^tsndbuffer;
   tsndbuffer=packed array[0..(4400-1)] of byte;//each buffer -> 25ms @ 44.1Khz 16bit stero (half that for mono) -> ~5 buffers for jitter free operation -> sound delay of 125ms or 8 fps

   tsndgen=class(tobjectex)
   private

    //.misc
    ims64,itimer500:comp;
    imute,itimerbusy,istereo:boolean;
    imastervolume100,ilimit,imaxvol,ionehz,iminhz,imaxhz,istepsPERms,iminstep,imaxstep,ifadeoutlimit,iminhiss,imaxhiss,ilistcount,itonecount,itimecount,ibuflimit:longint;

    //.wave out
    ihnd:hwaveout;
    isty:twaveformatex;
    ihdr       :array [0..4] of twavehdr;
    ibuf       :array [0..4] of tsndbuffer;
    ibuflen    :array [0..4] of longint;
    idoneonce,iopenbusy,iclosing:boolean;
    iopenref:comp;
    ibufferindex,ipushcount:longint;

    //.sound generator support
    ilist  :array[0..23] of tsoundinfo;//dedicated channels
    iused  :array[0..23] of boolean;//tracks peak usage
    //.var support
    ivarinfo:tsoundinfo;

    procedure xclear;

    //.wave out support
    function xopen:boolean;
    procedure xmustopen;
    procedure xclose;
    procedure xpush;//play buffer
    //.other
    function xsafehz(x:longint):longint;
    function xsafevol(x:longint):longint;
    function xsafevol1(x:double):double;
    function xsafeval1(x:double):double;
    function xsafebal1(x:double):double;
    procedure xsafebalLR(xbal:double;var lvol,rvol:double);
    function xmakestep(xfeq:longint):longint;
    function xmakehold(xms:longint):longint;
    function xmakevol(xvol1:double):longint;
    function xmakehiss(xhisslevel:double):longint;
    function xmakeruntime(xms:longint):longint;
    procedure xstep0(xslot:longint);//first tone only
    procedure xstep(xslot:longint);
    procedure xfade(xslot:longint;var lv,rv:longint);
    function xnextindex(xslot,xtoneindex:longint):longint;
    function xsafeslot(xslot:longint):longint;
    procedure xsndpull16(xslot:longint;var lv,rv:longint);
    procedure xfillbuf(xindex:longint);
    function getonline:boolean;
    procedure setmastervolume100(x:longint);
   public
    //information
    property bufferlevel:longint read ipushcount;

    //create
    constructor create(xstereo:boolean);
    destructor destroy; override;
    procedure xtimer(sender:tobject);
    function onmessage(m,w,l:longint):longint;

    //information
    property online:boolean read getonline;
    property stereo:boolean read istereo;//when mono all balance values default to "0"
    property limit:longint read ilimit;//max number of channels supported
    property volume100:longint read imastervolume100 write setmastervolume100;
    function peakchannelcount(xreset:boolean):longint;//24jul2025
    //mute
    property mute:boolean read imute write imute;//all output//?????????????need a fader for this of 50ms............

    //.fade out slot (simple or complex)
    procedure fadeout(xslot:longint);

    //.simple tone
    procedure tone(xslot,xfeq:longint;xvol:double);
    procedure tone2(xslot,xfeq:longint;xvol,xbal:double);
    procedure tone3(xslot,xruntime,xfeq:longint;xvol,xbal:double);

    //.simple hiss
    procedure hiss(xslot:longint;xhisslevel,xvol:double);
    procedure hiss2(xslot:longint;xhisslevel,xvol,xbal:double);
    procedure hiss3(xslot,xruntime:longint;xhisslevel,xvol,xbal:double);

    //.complex tone/hiss -> variable via timeline
    function varinit(xruntime,xbasefeq:longint;xbasevol:double):boolean;
    function varinit2(xruntime,xbasefeq:longint;xbasevol,xbasebal:double):boolean;
    function vartone1(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
    function vartone2(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
    function vartone3(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
    function varhiss4(xms:longint;xhisslevel,xvol,xbal:double;xmute:boolean):boolean;

    function vartone(xms,xfeq:longint):boolean;//uses "vartone1"
    function vartoneb(xms,xfeq:longint):boolean;//uses "vartone2"
    function vartonec(xms,xfeq:longint):boolean;//uses "vartone3"

    function vartonehiss(xms,xfeq:longint;xhisslevel,xvol,xmix:double):boolean;

    function varsave(xslot:longint):boolean;
    function varsave2(xslot:longint;xreset:boolean):boolean;

    //.support
    function vartonelist(xtoneindex,xms,xfeq:longint;xhisslevel,xvol,xbal:double;xmute:boolean):boolean;

   end;


const
   fps__1fps                        =1*fps__slotsperfps;
   fps__5fps                        =5*fps__slotsperfps;
var
   //started
   system_started                  :boolean=false;//04jul2025
   game_subframes                  :boolean=false;
   game_filecount                  :longint=0;//number of game files detected from "gamefiles.pas"
   game_errorcount                 :longint=0;//tracks "file not found" errors etc
   texedit_idcount                 :longint=0;

   //list of slots -> each slot may contain a tpic8("pic8" sprite), tbasicimage(bitmap image), or tsound(sound file)
   game_slotcount                   :longint=0;
   game_slotlast                    :longint=-1;
   game_slotlist                    :packed array[0..9999] of tobject;

   //multi-level flash support for pic8 sprites
   game_flashlist                  :tlistflashstate;
   game_flashref                   :packed array[0..high(tlistflashstate)] of comp;
   game_flashdelay                 :packed array[0..high(tlistflashstate)] of longint;//in milliseconds
   game_flashpert                  :packed array[0..high(tlistflashstate)] of double;//was single;//for subframes in smooth transition mode -> requires a high frame rate
   game_flash64                    :comp;

   //game support vars
   game_init                         :boolean=false;
   game_info                         :tgameinfo=nil;
   game_buffer                       :twinbmp=nil;
   game_buffer2                      :twinbmp=nil;
   game_bufferarea                   :twinrect;
   game_bufferwidth                  :longint=1;
   game_bufferheight                 :longint=1;
   game_bufferwidth_limit            :longint=1920;
   game_bufferheight_limit           :longint=1080;
   game_buffer_canshrink             :boolean=true;
   game_screenarea                   :twinrect;//actual area on screen that is painted with buffer - 28jul2025
   game_hosttimerproc                :tnotifyevent=nil;
   game_showtechnical                :longint=0;//24jul2025
   game_bufferrows                   :pcolorrows24=nil;
   game_bufferrows2                  :pcolorrows24=nil;
   game_buftext                      :tstr8=nil;//for font drawing - 20jul2025
   game_fontlist                     :tgamefonts;
   game_drawing                      :boolean=false;
   game_drawinfo                     :tdrawfastinfo;
   game_fpscount                     :longint=0;
   game_fps                          :double=0;
   game_mps                          :double=0;
   game_rendertime                   :double=0;
   game_rendertimeref                :comp=0;
   game_pixelcount                   :double=0;
   game_spritedrawcount              :longint=0;
   game_spritespersec                :double=0;
   game_soundchannelsinuse           :longint=0;
   game_soundmbsec                   :double=0;
   game_drawproc_id                  :longint=0;
   game_flashlevel                   :tgameflash;
   game_activetimer                  :comp=0;//activer version of ms64 -> only runs while game is plaing, and increments out of alignment with ms64 -> values are not interchangeable
   game_playing                      :boolean=false;
   game_inprogress                   :boolean=false;
   game_sndgen                       :tsndgen=nil;//optional
   game_volume100                    :longint=100;
   game_fullscreen                   :boolean=true;
   game_timer500                     :comp=0;
   game_timer1000                    :comp=0;
   game_timerbusy                    :boolean=false;
   game_timerslow                    :comp=0;
   game_endpaintref                  :string='';
   game_fontdefault                  :longint=0;
   game_fontsize12                   :longint=0;
   game_fontsize32                   :longint=0;
   game_screensizeerror_timeref      :comp=0;
   game_menu                         :tgamemenuinfo;
   game_deadzone100                  :longint=10;//10%
   game_capturekeyindex              :longint=0;
   game_timerfps                     :array[0..3] of tgametimerfps;
   game_framerate                    :longint=60;
   game_ver                          :string='';
   game_cliparea                     :twinrect;
   game_idlethreshold                :longint=60;//60 seconds -> one minute (when menu is visible)
   game_displayindex                 :longint=-1;//"auto" -> use whatever monitor the window is currently on

   //input label/fetch input support
   //.label sort order
   game_inputlabel_orderlist         :array[0..xkey_max] of longint;
   game_inputlabel_ordercount        :longint=0;
   //.fetch input remap list for each controller input
   game_fetchinput_mapper            :array[0..xssMax] of array [0..xkey_max] of longint;

   //.cursor support
   game_cursor                       :longint=-1;//slot # for pic8 sprite
   game_cursorpower255               :longint=180;
   game_cursoractive                 :comp=0;//no, not active
   game_cursorinfo                   :twinrect;//left=x,top=y,right=screen.width,bottom=screen.height (x=0..width-1, y=0..height-1)
   game_cursorhoverindex             :longint=-1;//none
   game_cursormoveref                :string='';

   //.packet counting for xbox controllers + keyboard etc
   game_packetcount                  :comp=0;
   game_packetlastcount              :comp=0;
   game_packetspersec                :double=0;

   //pic8 support references
   pic8_progressColorsPerSlot        :longint=10;
   pic8_progress_colorindexTOslot    :packed array[0..255] of longint;//map colorindex to progresslist slot, -1=no slot, not use for color index, such as 1st color which is transparent -> it does not use progress
   pic8_progress_colorindexTOtrigger :packed array[0..255] of double;//list of progress thresholds that triggers a "progress on" state for that color index


   //game speed test vars
   game_speedtest_mps                :double;
   game_speedtest_count              :longint=0;
   game_speedtest_ref                :string='';

   //flicker support
   game_flickerpert                  :packed array[0..high(tlistflashstate)] of double;//was single


//start-stop procs -------------------------------------------------------------
procedure gossgame__start;
procedure gossgame__stop;
function gossgame__info(xname:string):string;

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__game(xname:string):string;//information specific to this unit of code - 09apr2024


//game procs -------------------------------------------------------------------

//game init -> start stop core and support vars etc
procedure game__init(xgui:tbasicsystem;xlimit_bufferwidth,xlimit_bufferheight:longint;xbuffercanshrink,xuseSoundGenerator,xSoundGeneratorInStereo:boolean;xpaintproc,xtimerproc,xinitproc,xdefaultlayout_keyboard,xdefaultlayout_mouse:tnotifyevent;xmenuproc:tgamemenuevent;xmenuclickproc:tgamemenuclickevent);
procedure game__halt;
function game__safetohalt:boolean;//21jul2025
function game__idlethreshold:longint;

//.variable buffer (e.g. fit to window)
function game__variablebuffer:boolean;
procedure game__setvariablebuffer(xcanshrink:boolean);

//.frame rate
function game__framerate:longint;
procedure game__setframerate(x:longint);

//.show technical information
function game__showtechnical:longint;
function game__showtechnical__label:string;
procedure game__setshowtechnical(x:longint);

//.key procs
procedure game__paintnow(sender:tobject);

//game control
function game__playing:boolean;
function game__inprogress:boolean;
procedure game__setinprogress(x:boolean);
procedure game__play;
procedure game__stop;

//menu support
procedure game__showmenu(xmenuname:string);
procedure game__hidemenu;
function game__menushowing:boolean;
function game__menutitle(var x:tgamemenu;const xtitle,xmenuname:string;const xselector:longint):boolean;
function game__menuadd(var x:tgamemenu;const xcaption,xvalue,xcmd:string):boolean;
function game__menuadd2(var x:tgamemenu;const xcaption,xvalue,xcmd:string;calign,valign:byte):boolean;
procedure game__menuaction(xaction:longint);//set action
//.built-in menus and their actions
procedure game__menu__internalmenu(var x:tgamemenu;var xcolors:tgamemenucolors;const xmenuname:string);
procedure game__menu__internalmenuclick(xmenuname,xcmd:string;xaction:longint;xmouseaction:boolean;var handled:boolean);

//paint
function game__beginpaint(xsizetoclient:tobject;w,h:longint):boolean;
function game__endpaint(xdrawtoclient:tobject;xunusedcolor:longint):boolean;
function game__flashlevel255:longint;

//fps based timers (time detection)
function game__timerfps(xindex,xfps:longint):boolean;

//fullscreen
procedure game__setfullscreen(x:boolean);
function game__fullscreen:boolean;

//display index (which monitor to display on)
procedure game__setdisplayindex(x:longint);
function game__displayindex:longint;
function game__displaylabel:string;

//master volume
procedure game__setvolume100(x:longint);
function game__volume100:longint;

//input labels -> vitial -> range 0..xkey_max -> each label that's set with a short label indicates input will be used by the game,
//                and should be set once within the "gameinit" proc
function game__inputlabel(xindex:longint):string;
function game__setinputlabel(xindex:longint;const xlabel:string):longint;
function game__inputlabel__sortindex(xindex:longint;var dindex:longint):boolean;
function game__fetchinput(xindex,xlabelindex:longint;xasclick:boolean):double;//29jul2025
function game__fetchinput2(xindex,xlabelindex:longint;xasclick:boolean;var xval:double):double;
function game__fetchinput__mapsto(xindex,xlabelindex:longint;var dlabelindex:longint):boolean;//29jul2025
function game__fetchinput__remap(xindex,slabelindex,dlabelindex:longint):boolean;
procedure game__fetchinput__remap__defaults(xindex:longint);
//.mappings
function game__keymappings:string;
procedure game__setkeymappings(const x:string);
function game__xboxmappings:string;
function game__mousemappings:string;
procedure game__setxboxmappings(const x:string);
procedure game__setmousemappings(const x:string);


//xbox controller support
procedure game__xboxDefaults;
procedure game__setxboxdeadzone100(x:longint);
function game__xboxdeadzone100:longint;


//keyboard support
procedure game__keyboardDefaults;
procedure game__onkey(xrawkey:longint;xdown:boolean);
procedure game__lockkeyboard;
procedure game__unlockkeyboard;


//mouse support
procedure game__mouseDefaults;


//cursor support
function game__cursoractive:boolean;
function game__cursoractive2(var x2000msorless:longint):boolean;
procedure game__cursor__makeinactive;
procedure game__setcursorpower255(x:longint);
function game__cursorpower255:longint;

//invert axis support
procedure game__invert(var nativex,nativey,keyboardx,keyboardy,mousex,mousey:boolean);//24jul2025
procedure game__setinvert(nativex,nativey,keyboardx,keyboardy,mousex,mousey:boolean);//24jul2025
function game__invertList:string;
procedure game__setinvertList(x:string);


//misc
function game__roundtozero(x:double):double;

//sound generator
function game__sndgen__online:boolean;
function game__sndgen__stereo:boolean;
function game__sndgen__slotfirst:longint;
function game__sndgen__slotlimit:longint;
procedure game__sndgen__fadeout(xslot:longint);
procedure game__sndgen__tone(xslot,xfeq:longint;xvol:double);
procedure game__sndgen__tone2(xslot,xfeq:longint;xvol,xbal:double);
procedure game__sndgen__tone3(xslot,xruntime,xfeq:longint;xvol,xbal:double);
procedure game__sndgen__hiss(xslot:longint;xhisslevel,xvol:double);
procedure game__sndgen__hiss2(xslot:longint;xhisslevel,xvol,xbal:double);
procedure game__sndgen__hiss3(xslot,xruntime:longint;xhisslevel,xvol,xbal:double);
function game__sndgen__varinit(xruntime,xbasefeq:longint;xbasevol:double):boolean;
function game__sndgen__varinit2(xruntime,xbasefeq:longint;xbasevol,xbasebal:double):boolean;
function game__sndgen__vartone1(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
function game__sndgen__vartone2(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
function game__sndgen__vartone3(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
function game__sndgen__varhiss4(xms:longint;xhisslevel,xvol,xbal:double;xmute:boolean):boolean;
function game__sndgen__vartone(xms,xfeq:longint):boolean;//uses "vartone1"
function game__sndgen__vartoneb(xms,xfeq:longint):boolean;//uses "vartone2"
function game__sndgen__vartonec(xms,xfeq:longint):boolean;//uses "vartone3"
function game__sndgen__vartonehiss(xms,xfeq:longint;xhisslevel,xvol,xmix:double):boolean;
function game__sndgen__varsave(xslot:longint):boolean;
function game__sndgen__varsave2(xslot:longint;xreset:boolean):boolean;

//information
function game__activetimer:comp;
function game__fps:double;
function game__rendertime:double;//ms
function game__bufferwidth:longint;//1..N
function game__bufferheight:longint;//1..N
procedure game__bufferwh(var w,h:longint);

//tests
function game__speedtest(xslot,xwidth,xheight:longint):boolean;
function game__speedtest2(xslot,xlevel03,xwidth,xheight:longint;xalpha,xlesszoom:boolean):boolean;

//draw sprite/image
function game__draw0(xslot:longint;var x:tdrawfastinfo):boolean;
function game__draw1(xslot,dx,dy:longint):boolean;
function game__draw2(xslot,dx,dy,xpower255:longint;xmirror,xflip:boolean):boolean;
function game__draw3(xslot,dx,dy,xzoom,xpower255:longint;xmirror,xflip:boolean):boolean;//16jul2025, 06jul2025
function game__draw4(xslot,dx,dy,xzoom,yzoom,xpower255:longint;xmirror,xflip:boolean):boolean;//16jul2025, 06jul2025

//clear screen
procedure game__cls(r,g,b:byte);
procedure game__cls2(rgb:longint);//20jul2025

//draw area
procedure game__drawarea(da:twinrect;r,g,b,a:byte);
procedure game__drawarea2(da:twinrect;rgb,a:longint);

//draw shaded area
procedure game__drawshade(da:twinrect;r,g,b,r2,g2,b2,a:byte);
procedure game__drawshade2(da:twinrect;rgb1,rgb2,a:longint);

//fonts -> set once, use always
function game__addfont(xname:string;xsize:longint;xbold:boolean):longint;//08aug2025
function game__fontheight(findex:longint):longint;
function game__textwidth(findex:longint;const xline:string):longint;
function game__textwidth2(findex:longint;const xline,xtab:string):longint;

//draw text
procedure game__drawtext(findex:longint;const xline:string;dx,dy,dcol:longint);
procedure game__drawtext2(findex:longint;const xline,xtab:string;dx,dy,dcol:longint);

//internal support procs -> do not use, these are used for optimisation
function xgame__menudraw:boolean;
procedure xgame__drawarea_solid(da:twinrect;r,g,b:byte);
procedure xgame__drawarea__alpha(da:twinrect;r,g,b,a:byte);
procedure xgame__scaletobuffer2(xscale:double);
procedure xgame__shrinktobuffer2__012pert;//12%
procedure xgame__shrinktobuffer2__025pert;//25%
procedure xgame__shrinktobuffer2__050pert;//50%
procedure xgame__timer(sender:tobject);

//file support -> load sprites, images, sounds and other files directly from "gamefiles.pas" -> mostly used internally, but can be used by host - 21jul2025
function game__fromfile(const xfilename:string;xdata:pobject):boolean;

//error support
function game__errorcount:longint;


//.slot support -> each slot may contain tpic8(sprite), tbasicimage(bitmap image), tsound(wave data)
function game__slotcount:longint;
function game__slotlast:longint;
function game__slotok(xslot:longint):boolean;
function game__slotstyle(xslot:longint):string;
function game__slotisimage(xslot:longint):boolean;
function game__slotdel(xslot:longint):boolean;
function game__slotdelall:boolean;
procedure game__slotcount_sync;

//.sprite
function game__spritenew(xfilename:string):longint;//from internal file
function game__spritenew2(const x:tpiccore8):longint;//from an external piccore8
function game__spriteok(xslot:longint):boolean;
function game__sprite(xslot:longint):tpic8;
function game__spriteinfo(xslot:longint;var w,h:longint):boolean;
function game__spritesetprogress(xslot:longint;v:array of double):boolean;//set progress levels (0..N) for sprite
function game__spriteRenderinit(xslot:longint):boolean;
function game__spriteRenderinitAll:boolean;

//.image
function game__imgnew(xfilename:string):longint;
function game__imgok(xslot:longint):boolean;
function game__img(xslot:longint):tbasicimage;
function game__imginfo(xslot:longint;var w,h:longint):boolean;
function game__imgwidth(xslot:longint):longint;
function game__imgheight(xslot:longint):longint;

//.sound
function game__sndnew(xfilename:string):longint;
function game__sndok(xslot:longint):boolean;
function game__snd(xslot:longint):tsnd;

//.misc
procedure game__flashcycle(xforce:boolean);
function game__subframes:boolean;
procedure game__setsubframes(xenable:boolean);


//calc procs -------------------------------------------------------------------
procedure calc__drawlist(xinclusive:boolean;x,y,lastx,lasty:longint;xlist:tdynamicpoint);//return a sin/cos list of points to be able to draw a line etc - 03jan2019, 19aug2018
procedure calc__drawlist2(xinclusive:boolean;x,y,lastx,lasty:longint;xlist:tdynamicpoint;xmin,xmax,ymin,ymax:longint);//return a sin/cos list of points to be able to draw a line etc - 03jan2019, 19aug2018


//pic8 procs -------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//888888888888888888888888888888
procedure pic8__init(var x:tpiccore8;dw,dh:longint);
procedure pic8__changed(var x:tpiccore8);
procedure pic8__modified(var x:tpiccore8);
function pic8__mustpaint(var x:tpiccore8;var xref:string):boolean;
function pic8__getcolor(var x:tpiccore8;xcolindex,xindex03:longint):longint;//32 bit
procedure pic8__setcolor(var x:tpiccore8;xcolindex,xindex03:longint;c32:longint);//32 bit
function pic8__getcolor32(var x:tpiccore8;xcolindex,xindex03:longint):tcolor32;
procedure pic8__setcolor32(var x:tpiccore8;xcolindex,xindex03:longint;c32:tcolor32);
procedure pic8__editlist2(var x:tpiccore8;var flist,lsmooth,lflick,lflickrate:plistval8;xeditlist2:boolean);
procedure pic8__editlist3(var x:tpiccore8;var flist,lsmooth,lflick,lflickrate:plistval8;var elist24,olist24:plistcolor24;var elist8,olist8:plistcolor8;xeditlist2:boolean);
function pic8__rlist32(var x:tpiccore8;xindex:longint):tcolor32;//15jul205
function pic8__canedit_colindex(xcolindex:longint):boolean;
function pic8__fromfile(var x:tpiccore8;const xfilename:string):boolean;//19jul2025
function pic8__tofile(var x:tpiccore8;const xfilename:string):boolean;
function pic8__todata(var x:tpiccore8):string;//13jul2025
function pic8__todata1(var x:tpiccore8;var xdata:string):boolean;//19jul2025
function pic8__todata2(var x:tpiccore8;x64:boolean):string;//13jul2025
function pic8__fromdata(var x:tpiccore8;const xdata:string):boolean;
function pic8__fromdataOLD(var x:tpiccore8;const xdata:string):boolean;//19jul2025
function pic8__findcol24(var x:tpiccore8;xval:tcolor24):byte;
function pic8__findcol32(var x:tpiccore8;xval:tcolor32):byte;
function pic8__addcol24A(var x:tpiccore8;var xcount:longint;c24:tcolor24;ca8:tcolor8):byte;
function pic8__addcol24(var x:tpiccore8;var xcount:longint;c24:tcolor24):byte;
function pic8__addcol32(var x:tpiccore8;var xcount:longint;c32:tcolor32):byte;
function pic8__toimage(var x:tpiccore8;d:tobject):boolean;
function pic8__fromimage(var x:tpiccore8;s:tobject):boolean;
function pic8__fromimage2(var x:tpiccore8;s:tobject;xAutoScaleToFit:boolean):boolean;
function pic8__findindex(var x:tpiccore8;sx,sy:longint):longint;
function pic8__findxy(var x:tpiccore8;pindex:longint):tpoint;
function pic8__size(var x:tpiccore8;nw,nh:longint):boolean;
function pic8__safeflicker(x:longint):longint;
function pic8__safesmooth(x:longint):longint;
function pic8__safecolindex(xindex:longint):longint;
function pic8__safewh(x:longint):longint;
function pic8__setflash(var x:tpiccore8;xindex,xfps:longint):boolean;
function pic8__safebx(var x:tpiccore8;xval:longint):longint;
function pic8__safeby(var x:tpiccore8;xval:longint):longint;
procedure pic8__fill(var x:tpiccore8;xval:longint);
procedure pic8__clear(var x:tpiccore8);
procedure pic8__clear2(var x:tpiccore8;dw,dh:longint);
procedure pic8__clear3(var x:tpiccore8;dw,dh:longint;xmakecolors:boolean);
function pic8__safeflashrate(x:longint):byte;
procedure pic8__makecolors(var x:tpiccore8;n:string);
function pic8__pval(var x:tpiccore8;xindex:longint):longint;
function pic8__setpval(var x:tpiccore8;xindex,xval:longint):boolean;
function pic8__incpval(var x:tpiccore8;xindex,xby:longint):boolean;
function pic8__pixel(var x:tpiccore8;sx,sy:longint):longint;
function pic8__setpixel(var x:tpiccore8;sx,sy,xval:longint):boolean;

//.init color list "x.rlist24" and "x.rlist8" for rendering -> used by "pic8__drawfast()" and "xpic8__drawfast*()" procs
procedure pic8__renderinit(var x:tpiccore8);

//.drawfast procs
procedure pic8__drawfast(var x:tdrawfastinfo);//this proc calls "xpic8__drawfast0..xpic8__drawfast21" - 17jul2025
procedure xpic8__drawfast0__power255_flip(var x:tdrawfastinfo;var xcore:tpiccore8);//17jul2025
procedure xpic8__drawfast1__power255_flip_mirror(var x:tdrawfastinfo;var xcore:tpiccore8);//17jul2025
procedure xpic8__drawfast11__power255_flip_mirror_cliprange(var x:tdrawfastinfo;var xcore:tpiccore8);//17jul2025
procedure xpic8__drawfast21__power255_flip_mirror_zoom_cliprange(var x:tdrawfastinfo;var xcore:tpiccore8);//17jul2025

//other support procs
procedure mis__cls24(dclip:twinrect;dbufw,dbufh:longint;drs24:pcolorrows24;xcolor:longint);//18jul2025
procedure mis__checkboard24(dclip:twinrect;dbufw,dbufh:longint;drs24:pcolorrows24;xzoom:longint;r,g,b,r2,g2,b2:byte;xcolswap:boolean);//17jul2025



implementation


//start-stop procs -------------------------------------------------------------
procedure gossgame__start;
var
   xslot,p:longint;
   xtrigger:double;
   xcompressed:boolean;
   {$ifdef gamecore}
   xname:string;
   x:pointer;
   xlen:longint;
   {$endif}
begin
try

//check
if system_started then exit else system_started:=true;


//init flash
for p:=0 to high(game_flashlist) do
begin
game_flashlist[p]      :=false;
game_flashref [p]      :=0;
if (p=0) then game_flashdelay[p]:=0 else game_flashdelay[p]:=round(4000/p);
game_flashpert[p]      :=0;
game_flickerpert[p]    :=0;
end;//p

game_flash64:=ms64+33;//set at 30fps which covers ALL flash rates, but subframes require higher frame rate


//init progress map -> maps each color index to a progress slot, or -1 if progress is not used for color, such as 1st color (transparent color) - 13jul2025
pic8_progressColorsPerSlot:=frcrange32(pic8_progressColorsPerSlot,1,1+high(tlistcolor32));

for p:=0 to high(pic8_progress_colorindexTOslot) do
begin

case (p<=0) of
true:xslot:=-1;
else
   begin
   //10 colors per color set (progress slot)
   xslot:=(p-1) div pic8_progressColorsPerSlot;
   if (xslot<0) or (xslot>pic8_progressColorsPerSlot) or (xslot>high(tprogresslist)) then xslot:=-1;
   end;
end;//case

if (xslot>=0) then
   begin
   xtrigger:=(1/pic8_progressColorsPerSlot);//set precision
   xtrigger:=xtrigger * (p-(xslot*pic8_progressColorsPerSlot));
   end
else xtrigger:=1;

pic8_progress_colorindexTOslot[p]    :=xslot;
pic8_progress_colorindexTOtrigger[p] :=xtrigger;

end;//p


//flashlevel
game_flashlevel.level255   :=255;
game_flashlevel.modeup     :=false;
game_flashlevel.timeref    :=0;


//other game vars
game_activetimer           :=0;
game_playing               :=false;


//game_slotlist - set to nil
for p:=0 to high(game_slotlist) do game_slotlist[p]:=nil;


//game files -> count number of files in "gamefiles.pas" -> if none, report error
{$ifdef gamecore}
for p:=0 to max32 do if storage__findfile(p,x,xlen,xcompressed,xname) then inc(game_filecount) else break;

if (game_filecount<=0) then showerror('Game requires files in "gamefiles.pas" - none detected');
{$endif}


//start
game_buffer         :=miswin24(1,1);
game_buffer2        :=miswin24(1,1);
game_bufferarea     :=misarea(game_buffer);
game_bufferrows     :=game_buffer.prows24;
game_bufferrows2    :=game_buffer2.prows24;
game_screenarea     :=area__make(0,0,1,1);
game_buftext        :=str__new8;
game_drawing        :=false;
game_subframes      :=true;//sub-frame processing

low__cls(@game_drawinfo,sizeof(game_drawinfo));

game_drawinfo.clip  :=game_bufferarea;
game_drawinfo.rs24  :=game_bufferrows;


//.fonts
game_fontlist.count :=0;
game_fontdefault    :=game__addfont('',12,false);
game_fontsize12     :=game_fontdefault;
game_fontsize32     :=game__addfont('',32,false);

//.menu
game_menu.menu.selector   :=-1;
game_menu.menu.count      :=0;
game_menu.event           :=nil;
game_menu.activename      :='';
game_menu.cmd             :='';
game_menu.action          :=gmaNone;

game_menu.ftitle          :=game__addfont('',-72,true);
game_menu.ftitleH         :=game__fontheight(game_menu.ftitle);
game_menu.fitem           :=game__addfont('',-42,false);
game_menu.fitemH          :=game__fontheight(game_menu.fitem);
game_menu.fspace          :=round( 0.25 * game_menu.fitemH );

game_menu.fstitle         :=game__addfont('',-48,true);
game_menu.fstitleH        :=game__fontheight(game_menu.fstitle);
game_menu.fsitem          :=game__addfont('',-22,false);
game_menu.fsitemH         :=game__fontheight(game_menu.fsitem);
game_menu.fsspace         :=round( 0.25 * game_menu.fsitemH );


for p:=0 to high(game_menu.hmenuname) do
begin
game_menu.hmenuname[p]  :='';
game_menu.hindex[p]     :=0;
end;//p


//fetch input -> remap lists
for p:=0 to xssMax do game__fetchinput__remap__defaults(p);


//fps timers
low__cls(@game_timerfps,sizeof(game_timerfps));

//ver
game_ver:=info__game('gossgame.ver');

//.start xbox controller
xbox__init;

xbox__setdeadzone(game_deadzone100/100);

except;end;
end;

procedure gossgame__stop;
var
   p:longint;
begin
try
//check
if not system_started then exit else system_started:=false;


//disconnect
system_timer5       :=nil;//remove connection to "game_info._ontimer()" proc
game_hosttimerproc  :=nil;//host timer event

win____ClipCursor(nil);//free cursor restriction - 26jul2025
system_clipcursor_active:=false;

//game_imglist - clear any created images
for p:=0 to high(game_slotlist) do if (game_slotlist[p]<>nil) then freeobj( @game_slotlist[p] );
game_slotcount:=0;
game_slotlast:=-1;


//stop
game_menu.event:=nil;
freeobj(@game_buffer);
freeobj(@game_buffer2);
str__free(@game_buftext);

//.free font data
for p:=0 to (game_fontlist.count-1) do str__free(@game_fontlist.fonts[p].lgf);

//.sound generator
freeobj(@game_sndgen);

//.game info
freeobj(@game_info);
except;end;
end;

function gossgame__info(xname:string):string;
begin
result:=info__game(xname);
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

function info__game(xname:string):string;//information specific to this unit of code - 09apr2024
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gossgame.*"
if (strcopy1(xname,1,9)='gossgame.') then strdel1(xname,1,9) else exit;

//get
if      (xname='ver')        then result:='4.00.11024'
else if (xname='date')       then result:='02oct2025'
else if (xname='name')       then result:='GameCore'
else
   begin
   //nil
   end;

except;end;
end;


//game procs -------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//gggggggggggggggggg

procedure game__init(xgui:tbasicsystem;xlimit_bufferwidth,xlimit_bufferheight:longint;xbuffercanshrink,xuseSoundGenerator,xSoundGeneratorInStereo:boolean;xpaintproc,xtimerproc,xinitproc,xdefaultlayout_keyboard,xdefaultlayout_mouse:tnotifyevent;xmenuproc:tgamemenuevent;xmenuclickproc:tgamemenuclickevent);

   procedure se(x:string);//show error
   begin
   showerror('GameCore Error:'+rcode+rcode+x);
   end;

begin

//check
if game_init then exit else game_init:=true;

//start game core
gossgame__start;

//init
game_bufferwidth_limit   :=frcmin32(xlimit_bufferwidth,1);
game_bufferheight_limit  :=frcmin32(xlimit_bufferheight,1);
game_buffer_canshrink    :=xbuffercanshrink;

if xuseSoundGenerator then game_sndgen:=tsndgen.create(xSoundGeneratorInStereo);

//connect to and start gossamer game mode - 24jul2025
game_info     :=tgameinfo.create(xgui);//connect all Gossamer game events to our gameinfo object
game_info.gui.gamemode  :=true;
game_info.gui.hidecursor;//time based, needs regular setting


//game cursor
game_cursor            :=game__spritenew('cursor');
game_cursorinfo.left   :=0;
game_cursorinfo.right  :=1;
game_cursorinfo.top    :=0;
game_cursorinfo.bottom :=1;


//host procs
game_hosttimerproc:=xtimerproc;
if assigned(xinitproc) then xinitproc(nil) else showerror('game__init host proc not set');

//menu proc
game_menu.event       :=xmenuproc;
game_menu.clickevent  :=xmenuclickproc;
game_menu.prevarea    :=nilarea;
game_menu.nextarea    :=nilarea;


//check for errors
if (game__errorcount>=1)                 then se(k64(game__errorcount)+' load error'+insstr('s',game__errorcount<>1)+' encountered');

if (game_cursor<0)                       then se('Failed to load game cursor "cursor.pic8" sprite in game__init()');
if not assigned(xtimerproc)              then se('No timer event specified in game__init()');
if not assigned(xpaintproc)              then se('No paint event specified in game__init()');
if not assigned(xdefaultlayout_keyboard) then se('No keyboard defaults event specified in game__init()');
if not assigned(xdefaultlayout_mouse)    then se('No mouse defaults event specified in game__init()');
if not assigned(game_menu.event)         then se('No menu event specified in game__init()');
if not assigned(game_menu.clickevent)    then se('No menu click event specified in game__init()');

//host paint proc
game_info.onpaint                        :=xpaintproc;
game_info.ondefaultLayout_keyboard       :=xdefaultlayout_keyboard;
game_info.ondefaultLayout_mouse          :=xdefaultlayout_mouse;


//set default keyboard layout
game__keyboardDefaults;

//square corners
syssettings.b['round']:=false;
viSyncandsave;

//start timer
system_timer5:=game_info._ontimer;

end;

procedure game__halt;
begin

//stop game core
gossgame__stop;

end;

function game__variablebuffer:boolean;
begin
result:=game_buffer_canshrink;
end;

procedure game__setvariablebuffer(xcanshrink:boolean);
begin
game_buffer_canshrink:=xcanshrink;
end;

function game__framerate:longint;
begin
result:=game_framerate;
end;

procedure game__setframerate(x:longint);
begin
game_framerate:=frcrange32(x,30,80);
end;

function game__showtechnical:longint;
begin
result:=game_showtechnical;
end;

function game__showtechnical__label:string;
begin

case game_showtechnical of
1:result:='Brief';
2:result:='Full';
else result:='Off';
end;//case

end;

procedure game__setshowtechnical(x:longint);
begin
game_showtechnical:=frcrange32(x,0,2);
end;

function game__inprogress:boolean;
begin
result:=game_inprogress;
end;

procedure game__setinprogress(x:boolean);
begin
game_inprogress:=x;
end;

function game__playing:boolean;
begin
result:=game_playing;
end;

procedure game__play;
begin

if not game_playing then
   begin
   game_playing:=true;
   end;

end;

procedure game__stop;
begin

if game_playing then
   begin
   game_playing:=false;
   end;

end;

function game__flashlevel255:longint;
begin
result:=game_flashlevel.level255;
end;

function game__beginpaint(xsizetoclient:tobject;w,h:longint):boolean;
begin

//defaults
result             :=false;
game_rendertimeref :=ms64;


//check
if game_drawing then exit else game_drawing:=true;


//inc frame count
inc(game_fpscount);


//buffer size
if (xsizetoclient<>nil) and (xsizetoclient is tbasiccontrol) then
   begin

   if (xsizetoclient as tbasiccontrol).gui.gamemode then
      begin
      w:=frcmin32( (xsizetoclient as tbasiccontrol).gui.width,  1);
      h:=frcmin32( (xsizetoclient as tbasiccontrol).gui.height, 1);
      end
   else
      begin
      w:=frcmin32( (xsizetoclient as tbasiccontrol).clientwidth,  1);
      h:=frcmin32( (xsizetoclient as tbasiccontrol).clientheight, 1);
      end;

   end;

//.can shrink
if game_buffer_canshrink then
   begin
   w:=frcrange32(w,1,game_bufferwidth_limit);
   h:=frcrange32(h,1,game_bufferheight_limit);
   end
else
   begin
   w:=frcmin32(game_bufferwidth_limit,1);
   h:=frcmin32(game_bufferheight_limit,1);
   end;

//.size buffer
if (w<>game_buffer.width) or (h<>game_buffer.height) then
   begin

   //.buffer
   missize(game_buffer,w,h);

   game_bufferarea     :=misarea(game_buffer);
   game_bufferwidth    :=game_bufferarea.right-game_bufferarea.left+1;
   game_bufferheight   :=game_bufferarea.bottom-game_bufferarea.top+1;
   game_bufferrows     :=game_buffer.prows24;

   //.shared, reusable drawfast record
   game_drawinfo.clip  :=game_bufferarea;
   game_drawinfo.rs24  :=game_bufferrows;

   end;


//ready all slots with sprites for rendering
game__spriteRenderinitAll;


//successful
result:=true;
end;

function game__endpaint(xdrawtoclient:tobject;xunusedcolor:longint):boolean;
var
   dx,dy,dw,dh,cw,ch:longint;
   dmultiplier:double;

   function xrefchanged(xgamemode:boolean;cw,ch:longint):boolean;
   begin
   //gui.oeraseingbackground = detects when a minimised window is restored to view - 24jul2025
   result:=low__setstr(game_endpaintref, intstr32( (xdrawtoclient as tbasiccontrol).gui.oeraseingbackground ) + '|'+bolstr(xgamemode)+'|'+intstr32(game_bufferwidth)+'|'+intstr32(game_bufferheight)+'|'+intstr32(cw)+'|'+intstr32(ch)+'|'+intstr32(xunusedcolor));
   end;

   procedure ldsOUTSIDE(dx,dy,dw,dh,dcol:longint);//21jul2025
   var
      a:twinbmp;
      cw,ch:longint;
   begin
   //defaults
   a:=nil;

   try
   //check
   if (xdrawtoclient=nil) or (not (xdrawtoclient is tbasiccontrol)) then exit;

   //init
   dw:=frcmin32(dw,0);
   dh:=frcmin32(dh,0);
   cw:=(xdrawtoclient as tbasiccontrol).gui.width;
   ch:=(xdrawtoclient as tbasiccontrol).gui.height;
   a :=miswin24(100,100);

   //set color
   miscls(a,dcol);

   //left
   if (dx>=1)      then (xdrawtoclient as tbasiccontrol).gui.xcopyfrom(a.dc,misarea(a),area__make(0,0,dx-1,ch-1));

   //right
   if ((dx+dw)<cw) then (xdrawtoclient as tbasiccontrol).gui.xcopyfrom(a.dc,misarea(a),area__make(dx+dw,0,cw-1,ch-1));

   //top
   if (dy>=1)      then (xdrawtoclient as tbasiccontrol).gui.xcopyfrom(a.dc,misarea(a),area__make(dx,0,dx+dw-1,dy-1));//28jul2025: was "dx>=1"

   //bottom
   if ((dy+dh)<ch) then (xdrawtoclient as tbasiccontrol).gui.xcopyfrom(a.dc,misarea(a),area__make(dx,dy+dh,dx+dw-1,ch-1));

   except;end;
   //free
   freeobj(@a);
   end;

   procedure xerror_screensize;
   var
      tc,lh,tw,dx,dy:longint;
      t,t2:string;
   begin

   //check
   if (game_screensizeerror_timeref=-1)         then exit//show now disabled
   else if (game_screensizeerror_timeref=0)     then game_screensizeerror_timeref:=ms64+5000
   else if (ms64>=game_screensizeerror_timeref) then
      begin
      game_screensizeerror_timeref:=-1;//show once -> now turn off the message
      exit;
      end;

   //init
   tc:=rgba0__int(180,180,180);
   t :='Best viewed at:';
   t2:=k64(game_bufferwidth_limit)+'w x '+k64(game_bufferheight_limit)+'h';
   tw:=largest32(game__textwidth(game_fontsize32,t),game__textwidth(game_fontsize32,t2));
   lh:=game__fontheight(game_fontsize32);
   dx:=20 + 120;//(game_bufferwidth-tw) div 2;
   dy:=20 + 64;//(game_bufferheight-(2*lh)) div 2;

   //background
   game__drawarea( area__grow2( area__make(dx,dy,dx+tw-1,dy+(2*lh)), 120, 64) ,70,70,70,235);

   //text
   game__drawtext(game_fontsize32,t,dx,dy,tc);
   inc(dy, game__fontheight(game_fontsize32) );
   game__drawtext(game_fontsize32,t2,dx,dy,tc);

   end;

   function xsafemultiplier(cw,ch:longint):double;
   begin

   //get
   result:=frcminD64( smallestD64(cw/game_bufferwidth,ch/game_bufferheight), 0.1);

   //filter
   if      (result<0.25) then result:=0.125// 1/8
   else if (result<0.5)  then result:=0.25 // 1/4
   else if (result<1)    then result:=0.5  // 1/2
   else if (result<2)    then result:=1
   else if (result>=4)   then result:=4
   else if (result>=3)   then result:=3
   else if (result>=2)   then result:=2
   else                       result:=1;

   end;

   procedure xsetsize(w,h:longint);
   begin

   dw               :=frcmin32(w,1);
   dh               :=frcmin32(h,1);
   dx               :=frcmin32( (cw-dw) div 2, 0);
   dy               :=frcmin32( (ch-dh) div 2, 0);
   game_screenarea  :=area__make(dx,dy,dx+dw-1,dy+dh-1);

   end;

   procedure xdrawinfo;
   var
      x2000msorless,p,ax,ay:longint;
      str1:string;

      procedure tadd(const x:string);
      begin
      game__drawtext(game_menu.fsitem,x,ax,ay,rgba0__int(100,0,0));
      dec(ay,game_menu.fsitemH + game_menu.fsspace);
      end;
      
   begin

   //show technical information
   case game_showtechnical of
   1:begin

      game__drawtext(game_menu.fsitem, floattostrex(game__fps,0)+' fps | render: '+curdec(game__rendertime,1,false)+' ms' ,5,game_bufferheight-game_menu.fsitemH-5,rgba0__int(100,0,0));

      end;
   2:begin

      //init
      ax:=5;
      ay:=game_bufferheight-game_menu.fsitemH-5;

      //get
      tadd( 'Frame Rate: '+curdec(game_fps,1,true) +' fps');
      tadd( 'Pixel Rate: '+curdec(game_mps,1,true) +' mps');
      tadd( 'Render Time: '+curdec(game__rendertime,1,false)+' ms');
      tadd( 'Render Ratio: 1:'+floattostrex(dmultiplier,1));
      tadd( 'Sprites/sec: '+curdec(game_spritespersec,1,true));
      tadd( 'Sound: '+low__aorbstr('Offline',k64(game_soundchannelsinuse)+' ch, '+curdec(game_soundmbsec,1,false)+' mb/sec, '+low__aorbstr('mono','stereo',game__sndgen__stereo),game__sndgen__online));
      tadd( 'Buffer: '+k64(game_bufferwidth) + 'w x ' + k64(game_bufferheight)+'h' );
      tadd( 'Screen: '+k64(round(dmultiplier*game_bufferwidth)) + 'w x ' + k64(round(dmultiplier*game_bufferheight))+'h' );
      tadd( 'Input Packets/sec: '+curdec(game_packetspersec,1,true));
      tadd( 'Last Keyboard Key: '+xbox__keyboardkeylabel(xbox__lastrawkey)+' / '+k64(xbox__lastrawkey));
      tadd( 'GameCore: v'+game_ver);

      str1:='';
      for p:=xssNativeMin to xssNativeMax do if xbox__state(p) then str1:=str1+'C'+intstr32(p)+#32;
      tadd( 'Active Xbox Controllers: '+strdefb(str1,'None'));

      tadd( 'File Count: '+k64(game_filecount));

      end;
   end;//case


   //draw cursor
   if game__menushowing and game__cursoractive2(x2000msorless) then
      begin

      if (game_info<>nil) then game_info.xmouse_scaleChangeCheck;
      game__draw2(game_cursor,game_cursorinfo.left,game_cursorinfo.top,round( (x2000msorless/2000)*game_cursorpower255 ),false,false);

      end;

   //darken screen after idle threshold reached AND a menu is showing
   if game__menushowing and (xbox__idletime>=game_idlethreshold) then
      begin

      game__drawarea( area__make(0,0,game_bufferwidth-1,game_bufferheight-1) ,0,0,0, frcrange32( 15*( frcrange32(xbox__idletime,0,9999)-game_idlethreshold) ,0,200) );

      end;

   end;

begin

//defaults
result:=false;

//check
if not game_drawing then exit;


try
//menu system
if (game_menu.activename<>'') and (not xgame__menudraw) then game__hidemenu;


//draw buffer to screen
if (xdrawtoclient<>nil) and (xdrawtoclient is tbasiccontrol) then
   begin

   //---------------------------------------------------------------------------
   //game mode -> use entire GUI area
   if game_info.gui.gamemode then
      begin

      //init
      cw          :=game_info.gui.width;
      ch          :=game_info.gui.height;

      dmultiplier :=xsafemultiplier(cw,ch);

      xsetsize( round(dmultiplier*game_bufferwidth), round(dmultiplier*game_bufferheight) );

      //screen size error
      if (not game_buffer_canshrink) and ((cw<game_bufferwidth_limit) or (ch<game_bufferheight_limit)) then xerror_screensize;

      //info
      xdrawinfo;

      //paint screen
      //.normal
      if (dmultiplier=1) then game_info.gui.xcopyfrom(game_buffer.dc,game_bufferarea,game_screenarea)

      //.scale down -> scale down main "game_buffer" to secondary "game_buffer2"
      else
         begin

         xgame__scaletobuffer2(dmultiplier);
         xsetsize( game_buffer2.width, game_buffer2.height );

         game_info.gui.xcopyfrom(game_buffer2.dc,area__make(0,0,dw-1,dh-1),game_screenarea);

         end;

      //cls unused area on screen
      if xrefchanged(true,cw,ch) then ldsOUTSIDE(dx,dy,dw,dh,xunusedcolor);

      //ok
      result:=true;

      end

   //---------------------------------------------------------------------------
   //window mode -> use window clientarea
   else
      begin

      //init
      cw:=(xdrawtoclient as tbasiccontrol).clientwidth;
      ch:=(xdrawtoclient as tbasiccontrol).clientheight;

      dmultiplier :=xsafemultiplier(cw,ch);

      xsetsize( round(dmultiplier*game_bufferwidth), round(dmultiplier*game_bufferheight) );

      //screen size error
      if (not game_buffer_canshrink) and ((cw<game_bufferwidth_limit) or (ch<game_bufferheight_limit)) then xerror_screensize;

      //info
      xdrawinfo;

      //paint window clientarea
      //.normal
      if (dmultiplier=1) then (xdrawtoclient as tbasiccontrol).ldc(maxarea,dx,dy,dw,dh,game_bufferarea,game_buffer,255,0,clnone,0)

      //.scale down -> scale down main "game_buffer" to secondary "game_buffer2"
      else
         begin

         xgame__scaletobuffer2(dmultiplier);
         xsetsize( game_buffer2.width, game_buffer2.height );

         (xdrawtoclient as tbasiccontrol).ldc(maxarea,dx,dy,dw,dh,area__make(0,0,dw-1,dh-1),game_buffer2,255,0,clnone,0);

         end;

      //cls unused area within window clientarea
      game_endpaintref:='';
      //.requires constant repaint since buffer is inside a gui control in window mode
      (xdrawtoclient as tbasiccontrol).ldsOUTSIDE(dx,dy,dw,dh,xunusedcolor);

      //ok
      result:=true;

      end;

   //---------------------------------------------------------------------------

   end
else result:=true;


//finalise
game_rendertime:=( (game_rendertime*4) + frcrange32(sub32(ms64,game_rendertimeref),0,1000) ) / 5;

except;end;

//finished
game_drawing:=false;
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//11111111111111111111111111//???????
function xgame__menudraw:boolean;//26jul2025, 24jul2025
label
   redo,skipend;
const
   xlimit=10;
   bkGapX=100;
   bkGapY=32;
var
   ttw,ttx,tty,ftitle,ftitleH,fitem,fitemH,vspace,xredolimit,hindex,mindex,xfrom,int1,saction,daction,lw,mw,rw,vw,vh,dx,dy,p:longint;
   ddoactiononce,dclickhandled:boolean;
   str1:string;
   ta,da:twinrect;
begin
//defaults
result:=false;

//check
if (game_menu.activename='') then exit;


//defaults
xredolimit    :=10;

if (game_bufferheight>=1000) then
   begin

   ftitle   :=game_menu.ftitle;
   ftitleH  :=game_menu.ftitleH;
   fitem    :=game_menu.fitem;
   fitemH   :=game_menu.fitemH;
   vspace   :=game_menu.fspace;

   end
else
   begin

   ftitle   :=game_menu.fstitle;
   ftitleH  :=game_menu.fstitleH;
   fitem    :=game_menu.fsitem;
   fitemH   :=game_menu.fsitemH;
   vspace   :=game_menu.fsspace;

   end;


redo:
result:=false;


//check
if (game_menu.activename='') then exit;

//stop game play
if game_playing then game__stop;

//init
game_menu.menu.selector    :=-1;
game_menu.menu.count       :=0;

game_menu.colors.back      :=rgba0__int(30,30,30);
game_menu.colors.title     :=rgba0__int(150,150,150);
game_menu.colors.text      :=game_menu.colors.title;
game_menu.colors.highlight :=rgba0__int(100,100,100);

saction                    :=game_menu.action;

//reset
game_menu.action           :=gmaNone;

//subset of actions for host menu proc
if      (saction=gmaLeft)         then daction:=gmaLess
else if (saction=gmaRight)        then daction:=gmaMore
else if (saction=gmaSelect)       then daction:=gmaSelect
else if (saction=gmaMouseSelect)  then daction:=gmaSelect
else if (saction=gmaBack)         then daction:=gmaBack
else                                   daction:=gmaNone;


//call host for menu click event
if (daction<>gmaNone) then
   begin

   //init
   dclickhandled:=false;

   //call host menuclick proc
   if assigned(game_menu.clickevent) then game_menu.clickevent(game_menu.activename,game_menu.cmd,daction,(saction=gmaMouseSelect),dclickhandled);

   //fallback to built-in menuclick proc
   if not dclickhandled then game__menu__internalmenuclick( game_menu.activename,game_menu.cmd,daction,(saction=gmaMouseSelect),dclickhandled);

   end;


//get menu to display on screen ------------------------------------------------
str1:=game_menu.activename;
game_menu.menu.nohistory:=false;//optional, when true, disables history support - 26jul2025

//.unlock keyboard if locked from a key-capture task
if not strmatch(game_menu.activename,'capturekeynow') then xbox__unlockkeyboard;

//.host specific menus
if assigned(game_menu.event) then game_menu.event( game_menu.menu, game_menu.colors, game_menu.activename );

//.fallback to built-in menus  -> will use colors set from call to host menu handler
if (game_menu.menu.count<=0) then game__menu__internalmenu( game_menu.menu, game_menu.colors, game_menu.activename );

//.detect change in menu name and restart from beginging
if not strmatch(str1,game_menu.activename) then
   begin
   game_menu.once:=true;
   dec(xredolimit);
   if (xredolimit>=0) then goto redo;
   end;


//check
if (game_menu.menu.count<=0) then goto skipend;


//find menu name in history
mindex:=-1;

//.find existing menu in history list
for p:=0 to high(game_menu.hmenuname) do if strmatch(game_menu.activename,game_menu.hmenuname[p]) then
   begin
   mindex:=p;
   hindex:=frcrange32(game_menu.hindex[p],0,game_menu.menu.count-1);
   break;
   end;

//.store menu name in history
if (mindex<0) then for p:=0 to high(game_menu.hmenuname) do if (game_menu.hmenuname[p]='') then
   begin
   game_menu.hmenuname[p] :=game_menu.activename;
   game_menu.hindex[p]    :=0;
   mindex:=p;
   hindex:=0;
   break;
   end;

//.default to slot 0
if (mindex<0) then
   begin
   game_menu.hmenuname[0]:=game_menu.activename;
   mindex:=0;
   hindex:=0;
   end;

//adjust menu selection
case saction of
gmaUp:          hindex:=frcrange32(hindex-1,0,game_menu.menu.count-1);
gmaDown:        hindex:=frcrange32(hindex+1,0,game_menu.menu.count-1);
gmaMousehover:  if game__cursoractive and (game_cursorhoverindex>=0) then hindex:=frcrange32(game_cursorhoverindex,0,game_menu.menu.count-1);
gmaPrevpage:begin

   if (hindex>=1) then hindex:=frcrange32(hindex-xlimit,0,game_menu.menu.count-1)
   else
      begin

      dec(xredolimit);
      if (xredolimit>=0) then
         begin
         game_menu.action:=gmaBack;
         goto redo;
         end;

      end;

   end;//begin

gmaNextpage:    hindex:=frcrange32(hindex+xlimit,0,game_menu.menu.count-1);
end;//case


//store current menu selection in history, if using history
if game_menu.once then
   begin

   game_menu.once:=false;
   if game_menu.menu.nohistory then hindex:=0;

   end;

game_menu.hindex[mindex]:=hindex;


//calc
vh   :=ftitleH + fitemH + ( frcmax32(game_menu.menu.count,xlimit) * ( (2*vspace) + fitemH ) );
ttw  :=game__textwidth(ftitle,game_menu.menu.title);
vw   :=ttw;
lw   :=0;
mw   :=game__textwidth(fitem,'##');//middle space
rw   :=0;

for p:=0 to (game_menu.menu.count-1) do
begin

lw   :=largest32( lw, game__textwidth(fitem,game_menu.menu.items[p].caption) );
rw   :=largest32( rw, game__textwidth(fitem,game_menu.menu.items[p].value)   );

game_menu.menu.items[p].area:=nilarea;

end;//p

//.rw filter
rw         :=((rw div (3*mw))*(3*mw)) + (3*mw);
vw         :=largest32(vw + (2*game__textwidth(fitem,'<<')) , lw + mw + rw );

//.da
da.left    :=frcmin32( (game_bufferwidth-vw) div 2, 0);
da.right   :=da.left + vw;
da.top     :=frcmin32( (game_bufferheight-vh) div 2, 0);
da.bottom  :=da.top + vh;


//background
game__drawarea2( area__grow2(da,bkGapX,bkGapY), game_menu.colors.back, 220);


//menu title
dy         :=da.top;
ttx        :=da.left + (vw - ttw) div 2;
tty        :=da.top;
game__drawtext(ftitle,game_menu.menu.title, ttx, tty, game_menu.colors.title);
inc(dy,ftitleH);
inc(dy,fitemH);//space


//from
xfrom:=hindex;
game_menu.cmd:=game_menu.menu.items[hindex].cmd;

//menu items
xfrom:=(xfrom div xlimit)*xlimit;


//show "prev" and "next" page indicator when mouse is in use
if game__cursoractive then
   begin

   //.previous page OR back
   if (not strmatch(game_menu.activename,'main')) or (game_menu.menu.count>xlimit) then
      begin
      str1               :='<<';
      ta                 :=area__makewh( ttx-game__textwidth(fitem,str1)-(4*vspace), tty + ((ftitleH-fitemH) div 2), game__textwidth(fitem,str1),fitemH);
      game_menu.prevarea :=area__grow2(ta,2*vspace, vspace);

      if (game_cursorhoverindex=-100) then game__drawarea2(game_menu.prevarea,game_menu.colors.highlight,130);

      game__drawtext(fitem,str1,ta.left,ta.top,game_menu.colors.text);
      end
   else game_menu.prevarea:=nilarea;


   //.next page
   if (game_menu.menu.count>xlimit) then
      begin
      str1               :='>>';
      ta                 :=area__makewh( ttx+ttw+(4*vspace), tty+((ftitleH-fitemH) div 2), game__textwidth(fitem,str1),fitemH);
      game_menu.nextarea :=area__grow2(ta,2*vspace, vspace);

      if (game_cursorhoverindex=-101) then game__drawarea2(game_menu.nextarea,game_menu.colors.highlight,130);

      game__drawtext(fitem,str1,ta.left,ta.top,game_menu.colors.text);
      end
   else game_menu.nextarea:=nilarea;

   end
else
   begin

   game_menu.prevarea:=nilarea;
   game_menu.nextarea:=nilarea;

   end;


for p:=xfrom to (xfrom+xlimit-1) do
begin

if (p>=game_menu.menu.count) then break;

inc(dy,vspace);


//.highlight item and/or cursor hover index
if (p=hindex) then
   begin
   game__drawarea2( area__grow2( area__make(da.left,dy,da.right,dy + fitemH - 1), 2*vspace, vspace) , game_menu.colors.highlight, 130);
   end;


//.mouse area
game_menu.menu.items[p].area:=area__grow2( area__make(da.left,dy,da.right,dy + fitemH - 1), 2*vspace, vspace);


//.caption
case game_menu.menu.items[p].calign of
0:dx:=da.left;
1:dx:=da.left + ((lw - game__textwidth(fitem,game_menu.menu.items[p].caption) ) div 2);
2:dx:=da.left + lw - game__textwidth(fitem,game_menu.menu.items[p].caption);
else dx:=da.left;
end;//case

game__drawtext(fitem,game_menu.menu.items[p].caption, dx, dy, game_menu.colors.text);

//.optional value
if (game_menu.menu.items[p].value<>'') then
   begin

   case game_menu.menu.items[p].valign of
   0:dx:=da.right - rw;
   1:dx:=da.right - ((rw - game__textwidth(fitem,game_menu.menu.items[p].value) ) div 2);
   2:dx:=da.right - game__textwidth(fitem,game_menu.menu.items[p].value);
   end;//case

   game__drawtext(fitem,game_menu.menu.items[p].value, dx, dy, game_menu.colors.text);
   end;

//.inc
inc(dy,fitemH + vspace );

end;//p


//successful
result:=true;
skipend:

end;

function game__timerfps(xindex,xfps:longint):boolean;//14jul2025
begin

//range
if (xindex<0) then xindex:=0 else if (xindex>high(game_timerfps)) then xindex:=high(game_timerfps);


//change fps
if (xfps<>game_timerfps[xindex].fps) then
   begin

   //range
   xfps:=frcrange32(xfps,1,80);

   //get
   if (xfps<>game_timerfps[xindex].fps) or (game_timerfps[xindex].delay<5) then
      begin
      game_timerfps[xindex].fps       :=xfps;
      game_timerfps[xindex].delay     :=trunc(1000/xfps);
      game_timerfps[xindex].rundelay  :=game_timerfps[xindex].delay;
      game_timerfps[xindex].mindelay  :=low__aorb(10,5,xfps>=70);
      game_timerfps[xindex].time      :=0;
      game_timerfps[xindex].time1000  :=ms64+1000;
      game_timerfps[xindex].fpscount  :=0;
      end;

   end;


//detect timer
if (ms64>=game_timerfps[xindex].time) then
   begin

   //reset
   inc(game_timerfps[xindex].fpscount);
   game_timerfps[xindex].time:=add64(ms64,game_timerfps[xindex].rundelay);

   //yes
   result:=true;

   end
else result:=false;//no


//adjust timer delay to allow for load differences/render delays//timing inconsistences
if (ms64>=game_timerfps[xindex].time1000) then
   begin

   if (game_timerfps[xindex].time1000<>0) then
      begin
      game_timerfps[xindex].runrate:=frcrangeD64( (2*game_timerfps[xindex].fpscount)/frcmin32(game_timerfps[xindex].fps,1) ,0.1, 2);

      //only adjust for reasonable frame rates (20 fps or higher)
      if (game_timerfps[xindex].fps>=20) then
         begin

         if      (game_timerfps[xindex].runrate<=0.5) then game_timerfps[xindex].rundelay:=frcrange32(game_timerfps[xindex].rundelay-3,game_timerfps[xindex].mindelay,game_timerfps[xindex].delay)
         else if (game_timerfps[xindex].runrate<1)    then game_timerfps[xindex].rundelay:=frcrange32(game_timerfps[xindex].rundelay-1,game_timerfps[xindex].mindelay,game_timerfps[xindex].delay)
         else if (game_timerfps[xindex].runrate>=1.7) then game_timerfps[xindex].rundelay:=frcrange32(game_timerfps[xindex].rundelay+3,game_timerfps[xindex].mindelay,game_timerfps[xindex].delay)
         else if (game_timerfps[xindex].runrate>1)    then game_timerfps[xindex].rundelay:=frcrange32(game_timerfps[xindex].rundelay+1,game_timerfps[xindex].mindelay,game_timerfps[xindex].delay);

         end;
         
      end;

   //reset
   game_timerfps[xindex].fpscount  :=0;
   game_timerfps[xindex].time1000  :=ms64+500;

   end;

end;

procedure game__menuaction(xaction:longint);
begin
if game__menushowing then game_menu.action:=frcrange32(xaction,0,gmaMax);
end;

function game__menushowing:boolean;
begin
result:=(game_menu.activename<>'');
end;

procedure game__showmenu(xmenuname:string);
begin

if (xmenuname<>'') and ( not strmatch(xmenuname,game_menu.activename) ) then
   begin

   //stop game play
   if not game__menushowing then game__stop;

   //reset core menu vars
   game_menu.activename      :=xmenuname;
   game_menu.cmd             :='';
   game_menu.action          :=gmaNone;
   game_menu.once            :=true;
   end;

end;

procedure game__hidemenu;
var
   xhandled:boolean;
begin

if (game_menu.activename<>'') then
   begin

   //reset core menu vars
   game_menu.activename      :='';
   game_menu.cmd             :='';
   game_menu.action          :=gmaNone;
   game_menu.once            :=false;

   //finished with menu -> tell host -> chance to save settings
   xhandled:=false;

   if assigned(game_menu.clickevent) then game_menu.clickevent('','',gmaFinished,false,xhandled);

   //.fallback to internal menuclick proc
   if not xhandled                   then game__menu__internalmenuclick('','',gmaFinished,false,xhandled);

   //cancel clicks and wait for none to be present (or short delay)
   xbox__resetClicksAndWait;
   game__cursor__makeinactive;//disable mouse until it's moved in the game
   


   //re-start game play
   game__play;

   end;

end;

function game__menutitle(var x:tgamemenu;const xtitle,xmenuname:string;const xselector:longint):boolean;
begin

if (xtitle<>'') and (xmenuname<>'') and ( (xselector=-1) or game__slotisimage(xselector) ) then
   begin

   x.title     :=xtitle;
   x.menuname  :=xmenuname;
   x.selector  :=xselector;
   result      :=true;

   end
else result:=false;

end;

function game__menuadd(var x:tgamemenu;const xcaption,xvalue,xcmd:string):boolean;
begin
result:=game__menuadd2(x,xcaption,xvalue,xcmd,0,2);//calign=left(0) and valign=right(2)
end;

function game__menuadd2(var x:tgamemenu;const xcaption,xvalue,xcmd:string;calign,valign:byte):boolean;
begin

if (x.count<=high(x.items)) and (xcaption<>'') and (xcmd<>'') then
   begin

   //get
   x.items[ x.count ].caption  :=xcaption;
   x.items[ x.count ].value    :=xvalue;
   x.items[ x.count ].cmd      :=xcmd;
   x.items[ x.count ].calign   :=frcrange32(calign,0,2);//caption alignment
   x.items[ x.count ].valign   :=frcrange32(valign,0,2);//value alignment

   //inc
   inc(x.count);

   //successful
   result:=true;

   end
else result:=false;

end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//??????????????????//777777777777777777777777777777
procedure game__menu__internalmenu(var x:tgamemenu;var xcolors:tgamemenucolors;const xmenuname:string);
var
   int1,v,iv,i,p:longint;
   str1,n:string;
   xnativex,xnativey,xkeyboardx,xkeyboardy,xmousex,xmousey:boolean;

   procedure xred;//red menu colors
   begin
   xcolors.back       :=rgba0__int(50,0,0);
   xcolors.title      :=rgba0__int(190,0,0);
   xcolors.text       :=rgba0__int(190,0,0);
   xcolors.highlight  :=rgba0__int(120,0,0);
   end;

begin

//coloring is determined by host menu proc
//

//unlock keyboard if locked from a key-capture task
if (xmenuname<>'capturekeynow') then xbox__unlockkeyboard;


//return a menu
if (xmenuname='main') then
   begin

   if game__inprogress then
      begin

      game__menutitle(x,'Game Menu','main',-1);
      game__menuadd(x,'Quit Game','','showmenu:game.end.confirm');
      game__menuadd(x,'Settings','','showmenu:settings');

      end

   else
      begin

      game__menutitle(x,'Main Menu','main',-1);
      game__menuadd(x,'New Game','','game.new');
      game__menuadd(x,'Settings','','showmenu:settings');
      game__menuadd(x,'About','','showmenu:about');
      game__menuadd(x,'Exit App','','showmenu:halt.confirm');

      end;

   end
else if (xmenuname='settings') then
   begin

   game__menutitle(x,'Game Settings','settings',-1);
   game__menuadd(x,'Volume',intstr32(game__volume100)+'%','volume');
//   game__menuadd(x,'Full Screen',low__yes(game__fullscreen),'fullscreen');
//   game__menuadd(x,'Fit to Window',low__yes(game__variablebuffer),'fittowindow');
//   game__menuadd(x,'Technical Information',game__showtechnical__label,'showtechnical');
   game__menuadd(x,'Video','','showmenu:video');
   game__menuadd(x,'Xbox Controller','','showmenu:xbox');
   game__menuadd(x,'Keyboard','','showmenu:keyboard');
   game__menuadd(x,'Mouse','','showmenu:mouse');

   end
else if (xmenuname='video') then
   begin

   game__menutitle(x,'Video Settings','video',-1);
   game__menuadd(x,'Restore Defaults','','showmenu:video.default.confirm');
   game__menuadd(x,'Display',game__displaylabel,'displayindex');
   game__menuadd(x,'Full Screen',low__yes(game__fullscreen),'fullscreen');
   game__menuadd(x,'Fit to Window',low__yes(game__variablebuffer),'fittowindow');
   game__menuadd(x,'Frame Rate',k64(game__framerate),'framerate');
   game__menuadd(x,'Technical Information',game__showtechnical__label,'showtechnical');

   end
else if (xmenuname='xbox') then
   begin

   game__invert(xnativex,xnativey,xkeyboardx,xkeyboardy,xmousex,xmousey);

   game__menutitle(x,'Xbox Controller','xbox',-1);
   game__menuadd(x,'Restore Defaults','','showmenu:xbox.default.confirm');
   game__menuadd(x,'Dead Zone',intstr32(game__xboxdeadzone100)+'%','deadzone');
   game__menuadd(x,'Invert Y-axis',low__yes(xnativey),'invert.y');
   game__menuadd(x,'Invert X-axis',low__yes(xnativex),'invert.x');

   game__menuadd(x,'Swap Triggers',low__yes(system_xbox_nativecontroller_swaptriggers),'swap.triggers');
   game__menuadd(x,'Swap Bumpers',low__yes(system_xbox_nativecontroller_swapbumpers),'swap.bumpers');
   game__menuadd(x,'Swap Joysticks',low__yes(system_xbox_nativecontroller_swapjoysticks),'swap.joysticks');

   for p:=0 to xkey_max do
   begin

   if game__inputlabel__sortindex(p,i) then
      begin

      game__fetchinput__mapsto(0,i,iv);

      //show only those inputs that have "input labels" assigned to them - 26jul2025
      n:=game__inputlabel(i);
      if (n<>'') then game__menuadd2(x,n,xbox__controllerlabel(iv),'remap.xbox.input.'+intstr32(p),0,0);

      end
   else break;

   end;//p

   end
else if (xmenuname='keyboard') then
   begin

   game__invert(xnativex,xnativey,xkeyboardx,xkeyboardy,xmousex,xmousey);

   game__menutitle(x,'Keyboard Settings','keyboard',-1);
   game__menuadd(x,'Restore Defaults','','showmenu:keyboard.default.confirm');
   game__menuadd(x,'Invert Y-axis',low__yes(xkeyboardy),'invert.keyboard.y');
   game__menuadd(x,'Invert X-axis',low__yes(xkeyboardx),'invert.keyboard.x');

   for p:=0 to xkey_max do
   begin

   if game__inputlabel__sortindex(p,i) and xbox__keymap2( xbox__keyfilter(i),n,v) then
      begin

      //show only those keys that have "input labels" assigned to them - 26jul2025
      n:=game__inputlabel(i);
      if (n<>'') then game__menuadd2(x,n,low__digpad11(v,3)+' / '+xbox__keyboardkeylabel(v),'capturekey.'+intstr32(i),0,0);

      end
   else break;

   end;//p

   end
else if (xmenuname='mouse') then
   begin

   game__invert(xnativex,xnativey,xkeyboardx,xkeyboardy,xmousex,xmousey);

   game__menutitle(x,'Mouse Settings','mouse',-1);
   game__menuadd(x,'Restore Defaults','','showmenu:mouse.default.confirm');
//   game__menuadd(x,'Key Speed',intstr32(game__keyspeed100)+'%','keyspeed');
   game__menuadd(x,'Invert Y-axis',low__yes(xmousey),'invert.mouse.y');
   game__menuadd(x,'Invert X-axis',low__yes(xmousex),'invert.mouse.x');
   game__menuadd(x,'Swap Buttons',low__yes(system_xbox_mouse_swapbuttons),'swap.mouse.buttons');

   for p:=0 to xkey_max do
   begin

   if game__inputlabel__sortindex(p,i) then
      begin

      game__fetchinput__mapsto(xssMouse,i,iv);

      //show only those inputs that have "input labels" assigned to them - 26jul2025
      n:=game__inputlabel(i);
      if (n<>'') then game__menuadd2(x,n,xbox__mouselabel(iv),'remap.mouse.input.'+intstr32(p),0,0);

      end
   else break;

   end;//p

   end
else if (xmenuname='capturekeynow') then
   begin

   //reset when "esc" or "enter" key
   if (xbox__lastrawkey=vkescape) or (xbox__lastrawkey=vkreturn) then
      begin
      xbox__lastrawkeycount(true);
      end;

   //edit keymap
   game__menutitle(x,'Press a key 5x to set'+insstr(' ('+k64(xbox__lastrawkeycount(false))+' x)',xbox__lastrawkeycount(false)<=5),'capturekeynow',-1);

   if xbox__keymap2( xbox__keyfilter(game_capturekeyindex) ,str1,int1) and (xbox__lastrawkeycount(false)>=5) then
      begin
      xbox__setkeymap( xbox__keyfilter(game_capturekeyindex) ,xbox__lastrawkey);
      game__showmenu('keyboard');
      end;

   game__menuadd(x,game__inputlabel(game_capturekeyindex) ,xbox__keyboardkeylabel(int1)+ ' / '+ intstr32( xbox__keymap( xbox__keyfilter(game_capturekeyindex) ) ),'showmenu:keyboard');

   end

else if (xmenuname='game.end.confirm') then
   begin

   x.nohistory:=true;
   xred;
   game__menutitle(x,'Quit Game?','game.end.confirm',-1);
   game__menuadd(x,'No','','showmenu:main');
   game__menuadd(x,'Yes','','game.end');

   end
else if (xmenuname='halt.confirm') then
   begin

   x.nohistory:=true;
   xred;
   game__menutitle(x,'Exit App?','halt.confirm',-1);
   game__menuadd(x,'No','','showmenu:main');
   game__menuadd(x,'Yes','','halt');

   end
else if (xmenuname='video.default.confirm') then
   begin

   x.nohistory:=true;
   xred;
   game__menutitle(x,'Restore Video Settings?','video.default.confirm',-1);
   game__menuadd(x,'No','','showmenu:video');
   game__menuadd(x,'Yes','','video.defaults');

   end
else if (xmenuname='xbox.default.confirm') then
   begin

   x.nohistory:=true;
   xred;
   game__menutitle(x,'Restore Xbox Settings?','xbox.default.confirm',-1);
   game__menuadd(x,'No','','showmenu:xbox');
   game__menuadd(x,'Yes','','xbox.defaults');

   end
else if (xmenuname='keyboard.default.confirm') then
   begin

   x.nohistory:=true;
   xred;
   game__menutitle(x,'Restore Keyboard Settings?','keyboard.default.confirm',-1);
   game__menuadd(x,'No','','showmenu:keyboard');
   game__menuadd(x,'Yes','','keyboard.defaults');

   end
else if (xmenuname='mouse.default.confirm') then
   begin

   x.nohistory:=true;
   xred;
   game__menutitle(x,'Restore Mouse Settings?','mouse.default.confirm',-1);
   game__menuadd(x,'No','','showmenu:mouse');
   game__menuadd(x,'Yes','','mouse.defaults');

   end
else if (xmenuname='about') then
   begin

   game__menutitle(x,'About','about',-1);
   game__menuadd2(x,'Title',app__info('name'),'-',0,0);
   game__menuadd2(x,'Version',app__info('ver'),'-',0,0);
   game__menuadd2(x,'License',app__info('license'),'-',0,0);
   game__menuadd2(x,'Codebase','Gossamer v'+app__info('gossamer.ver'),'-',0,0);
   game__menuadd2(x,'Gamebase','GameCore v'+app__info('gossgame.ver'),'-',0,0);
   game__menuadd2(x,'Copyright',app__info('copyright'),'-',0,0);

   end
else if (xmenuname<>'') then
   begin

   game__menutitle(x,'Error','error',-1);
   game__menuadd(x,'Menu not found: "'+xmenuname+'"','','-');

   end;

end;

procedure game__menu__internalmenuclick(xmenuname,xcmd:string;xaction:longint;xmouseaction:boolean;var handled:boolean);
var
   str1,v,n:string;
   int1,int2:longint;
   xnativex,xnativey,xkeyboardx,xkeyboardy,xmousex,xmousey:boolean;

   procedure xgetinvert;
   begin
   game__invert(xnativex,xnativey,xkeyboardx,xkeyboardy,xmousex,xmousey);
   end;

   procedure xsetinvert;
   begin
   game__setinvert(xnativex,xnativey,xkeyboardx,xkeyboardy,xmousex,xmousey);
   end;

   function m(const xname:string):boolean;//full match
   begin
   result:=strmatch(n,xname);
   end;

   function pm(const xname:string):boolean;//partial match
   begin
   result:=strmatch(strcopy1(n,1,low__len(xname)),xname);
   if result then v:=strcopy1(n,low__len(xname)+1,low__len(n));
   end;

   function ival(xvalue,xby,xmin,xmax:longint):longint;
   begin

   //adjust value
   case xaction of
   gmaSelect: if xmouseaction then dec(xvalue,xby);//if (xvalue=xmin) then xvalue:=xmax else if (xvalue=xmax) then xvalue:=xmin;
   gmaLess:   dec(xvalue,xby);
   gmaMore:   inc(xvalue,xby);
   end;//case

   //get
   result:=frcrange32(xvalue,xmin,xmax);

   end;

   function bval(xvalue:boolean):boolean;
   begin

   //adjust value
   case xaction of
   gmaSelect,gmaLess,gmaMore:xvalue:=not xvalue;
   end;//case

   //get
   result:=xvalue;

   end;

   function bselect:boolean;
   begin
   result:=(xaction=gmaSelect);
   end;

begin

//defaults
handled:=true;

//init
n    :=strlow(xcmd);
v    :='';


//process the command
if (xaction=gmaFinished) then
   begin

   end
else if (xaction=gmaBack) then
   begin

   if (xmenuname='main') then
      begin
      if game__inprogress then game__hidemenu;
      end
   else if (xmenuname='settings')                  then game__showmenu('main')

   else if (xmenuname='video')                     then game__showmenu('settings')
   else if (xmenuname='video.default.confirm')     then game__showmenu('video')

   else if (xmenuname='xbox')                      then game__showmenu('settings')
   else if (xmenuname='xbox.default.confirm')      then game__showmenu('xbox')

   else if (xmenuname='keyboard')                  then game__showmenu('settings')
   else if (xmenuname='keyboard.default.confirm')  then game__showmenu('keyboard')

   else if (xmenuname='mouse')                     then game__showmenu('settings')
   else if (xmenuname='mouse.default.confirm')     then game__showmenu('mouse')

   else if (xmenuname='capturekeynow')  then game__showmenu('keyboard')
   else if (xmenuname='about')          then game__showmenu('main')
   else if (xmenuname='error')          then game__showmenu('main')
   else if (xmenuname<>'')              then game__showmenu('main')//covers menu's lile "halt.confirm" where there might be a slight delay between accepting and closing the app -> this prevents the menu from unexpectedly closing altogether during that possible time delay - 24jul2025
   else                                      game__hidemenu;

   end
else if (xaction=gmaSelect) or (xaction=gmaLess) or (xaction=gmaMore) then
   begin

   if      pm('showmenu:') and bselect   then game__showmenu(v)
   else if pm('hidemenu')  and bselect   then game__hidemenu
   else if m('halt')       and bselect   then app__startclose
   else if m('displayindex')             then game__setdisplayindex( ival(game__displayindex,1,-1,max32) )
   else if m('fullscreen')               then game__setfullscreen( bval(game__fullscreen) )
   else if m('fittowindow')              then game__setvariablebuffer( bval(game__variablebuffer) )
   else if m('framerate')                then game__setframerate( ival(game__framerate,1,30,80) )
   else if m('showtechnical')            then game__setshowtechnical( ival(game__showtechnical,1,0,2) )
   else if m('volume')                   then game__setvolume100( ival( game__volume100,1,0,100 ) )
   else if pm('remap.xbox.input.') then
      begin

      if game__inputlabel__sortindex(strint(v),int1) then
         begin

         game__fetchinput__mapsto(xssNative0, int1,int2);
         game__fetchinput__remap(xssNative0, int1, ival(int2,1,-1,xkey_canmap) );

         end;

      end
   else if pm('remap.mouse.input.') then
      begin

      if game__inputlabel__sortindex(strint(v),int1) then
         begin

         game__fetchinput__mapsto(xssMouse, int1,int2);
         game__fetchinput__remap(xssMouse, int1, ival(int2,1,-1,xkey_canmap) );

         end;

      end
   else if m('invert.y') then
      begin
      xgetinvert;
      xnativey:=bval( xnativey );
      xsetinvert;
      end
   else if m('invert.x') then
      begin
      xgetinvert;
      xnativex:=bval( xnativex );
      xsetinvert;
      end
   else if m('invert.keyboard.y') then
      begin
      xgetinvert;
      xkeyboardy:=bval( xkeyboardy );
      xsetinvert;
      end
   else if m('invert.keyboard.x') then
      begin
      xgetinvert;
      xkeyboardx:=bval( xkeyboardx );
      xsetinvert;
      end
   else if m('invert.mouse.y') then
      begin
      xgetinvert;
      xmousey:=bval( xmousey );
      xsetinvert;
      end
   else if m('invert.mouse.x') then
      begin
      xgetinvert;
      xmousex:=bval( xmousex );
      xsetinvert;
      end
   else if m('swap.mouse.buttons') then
      begin
      system_xbox_mouse_swapbuttons:=not system_xbox_mouse_swapbuttons;
      end
   else if m('swap.triggers') then
      begin
      system_xbox_nativecontroller_swaptriggers:=not system_xbox_nativecontroller_swaptriggers;
      end
   else if m('swap.bumpers') then
      begin
      system_xbox_nativecontroller_swapbumpers:=not system_xbox_nativecontroller_swapbumpers;
      end
   else if m('swap.joysticks') then
      begin
      system_xbox_nativecontroller_swapjoysticks:=not system_xbox_nativecontroller_swapjoysticks;
      end
   else if m('deadzone')       then game__setxboxdeadzone100( ival( game__xboxdeadzone100,1,0,100 ) )
   else if m('video.defaults') then
      begin

      game__setdisplayindex(-1);//auto
      game__setframerate(60);
      game__setvariablebuffer(true);
      game__setfullscreen(true);
      game__setshowtechnical(0);
      game__showmenu('video');

      end
   else if m('xbox.defaults') then
      begin

      game__xboxDefaults;
      game__showmenu('xbox');

      end
   else if m('keyboard.defaults') then
      begin

      game__keyboardDefaults;
      game__showmenu('keyboard');

      end
   else if m('mouse.defaults') then
      begin

      game__mouseDefaults;
      game__showmenu('mouse');

      end
   else if pm('capturekey.') and bselect then
      begin

      game_capturekeyindex:=strint(v);
      xbox__lastrawkeycount(true);

      if xbox__keymap2( xbox__keyfilter(game_capturekeyindex) ,str1,int1) then
         begin
         game__lockkeyboard;
         game__showmenu('capturekeynow');
         end
      else game__showmenu('keyboard');

      end
   else handled:=false;

   end;

end;

procedure game__setxboxdeadzone100(x:longint);
begin
game_deadzone100:=frcrange32(x,0,50);
xbox__setdeadzone(game_deadzone100/100);
end;

function game__xboxdeadzone100:longint;
begin
result:=game_deadzone100;
end;

procedure game__xboxDefaults;
var
   p:longint;
begin

game__setxboxdeadzone100(10);//10%

system_xbox_nativecontroller_inverty       :=false;
system_xbox_nativecontroller_invertx       :=false;
system_xbox_nativecontroller_swapjoysticks :=false;
system_xbox_nativecontroller_swaptriggers  :=false;
system_xbox_nativecontroller_swapbumpers   :=false;

for p:=xssNative0 to xssNative3 do game__fetchinput__remap__defaults(p);

end;

procedure game__keyboardDefaults;
begin

//built-in defaults
system_xbox_keyboard_inverty :=false;
system_xbox_keyboard_invertx :=false;
xbox__keymap__defaults;

//host defaults -> allows for game specific keyboard layout
if (game_info<>nil) and assigned(game_info.ondefaultLayout_keyboard) then game_info.ondefaultLayout_keyboard(game_info);

end;

procedure game__mouseDefaults;
begin

//built-in defaults
system_xbox_mouse_inverty     :=false;
system_xbox_mouse_invertx     :=false;
system_xbox_mouse_swapbuttons :=false;

game__fetchinput__remap__defaults(xssMouse);

//host defaults -> allows for game specific mouse layout
if (game_info<>nil) and assigned(game_info.ondefaultLayout_mouse) then game_info.ondefaultLayout_mouse(game_info);

end;

function game__inputlabel(xindex:longint):string;
begin
result:=xbox__inputlabel(xindex);
end;

function game__setinputlabel(xindex:longint;const xlabel:string):longint;
begin

result:=xindex;
xbox__setinputlabel(xindex,xlabel);

//.sort list
if (game_inputlabel_ordercount<=high(game_inputlabel_orderlist)) then
   begin
   game_inputlabel_orderlist[game_inputlabel_ordercount]:=xindex;
   inc(game_inputlabel_ordercount);
   end;

end;

function game__inputlabel__sortindex(xindex:longint;var dindex:longint):boolean;
begin

result:=(xindex>=0) and (xindex<=xkey_max) and (xindex<game_inputlabel_ordercount);
if result then dindex:=game_inputlabel_orderlist[xindex] else dindex:=0;

end;

function game__fetchinput2(xindex,xlabelindex:longint;xasclick:boolean;var xval:double):double;
begin
result :=game__fetchinput(xindex,xlabelindex,xasclick);
xval   :=result;
end;

function game__fetchinput(xindex,xlabelindex:longint;xasclick:boolean):double;//29jul2025

   procedure s(xby,xval:double;xclick:boolean);
   begin

   if xasclick then
      begin
      if    xclick  then result:=xby else result:=0;
      end
   else if (xby<0)  then result:=frcrangeD64(xval,xby,0)
   else if (xby>=0) then result:=frcrangeD64(xval,0,xby);

   end;

   procedure s2(xval,xclick:boolean);
   begin
   if xasclick then result:=insint(1,xclick) else result:=insint(1,xval);
   end;

   procedure s3(xby:longint;xval,xclick:boolean);
   begin
   if xasclick then result:=insint(xby,xclick) else result:=insint(xby,xval);
   end;

   function xneg(alabelindex:longint):boolean;
   begin

   case alabelindex of
   xkey_lx_left    :result:=true;
   xkey_rx_left    :result:=true;
   xkey_ly_down    :result:=true;
   xkey_ry_down    :result:=true;
   xkey_left       :result:=true;
   xkey_down       :result:=true;
   else             result:=false;
   end;//case

   end;

begin

//defaults
result:=0;

//check
if (xindex<0) or (xindex>xssMax) or (xlabelindex<0) or (xlabelindex>xkey_max) then exit;

//get
case game_fetchinput_mapper[xindex][xlabelindex] of

xkey_lt              :s ( 1,system_xbox_statelist[xindex].lt   ,xbox__ltclick(xindex) );//triggers
xkey_rt              :s ( 1,system_xbox_statelist[xindex].rt   ,xbox__rtclick(xindex) );

xkey_lsbutton        :s2( system_xbox_statelist[xindex].lb     ,xbox__lbclick(xindex) );//thumb sticks
xkey_rsbutton        :s2( system_xbox_statelist[xindex].rb     ,xbox__rbclick(xindex) );

xkey_lbumper         :s2( system_xbox_statelist[xindex].ls     ,xbox__lsclick(xindex) );//bumpers (shoulders)
xkey_rbumper         :s2( system_xbox_statelist[xindex].rs     ,xbox__rsclick(xindex) );

xkey_rx_left         :s ( -1,system_xbox_statelist[xindex].rx  ,xbox__rthumbstick_lclick(xindex) );//joysticks
xkey_rx_right        :s ( +1,system_xbox_statelist[xindex].rx  ,xbox__rthumbstick_rclick(xindex) );
xkey_ry_up           :s ( +1,system_xbox_statelist[xindex].ry  ,xbox__rthumbstick_uclick(xindex) );
xkey_ry_down         :s ( -1,system_xbox_statelist[xindex].ry  ,xbox__rthumbstick_dclick(xindex) );

xkey_lx_left         :s ( -1,system_xbox_statelist[xindex].lx  ,xbox__lthumbstick_lclick(xindex) );
xkey_lx_right        :s ( +1,system_xbox_statelist[xindex].lx  ,xbox__lthumbstick_rclick(xindex) );
xkey_ly_up           :s ( +1,system_xbox_statelist[xindex].ly  ,xbox__lthumbstick_uclick(xindex) );
xkey_ly_down         :s ( -1,system_xbox_statelist[xindex].ly  ,xbox__lthumbstick_dclick(xindex) );

xkey_left            :s3( -1,system_xbox_statelist[xindex].l   ,xbox__lclick(xindex) );
xkey_right           :s3( +1,system_xbox_statelist[xindex].r   ,xbox__rclick(xindex) );
xkey_up              :s3( +1,system_xbox_statelist[xindex].u   ,xbox__uclick(xindex) );
xkey_down            :s3( -1,system_xbox_statelist[xindex].d   ,xbox__dclick(xindex) );

xkey_a_button        :s2( system_xbox_statelist[xindex].a      ,xbox__aclick(xindex) );
xkey_b_button        :s2( system_xbox_statelist[xindex].b      ,xbox__bclick(xindex) );
xkey_x_button        :s2( system_xbox_statelist[xindex].x      ,xbox__xclick(xindex) );
xkey_y_button        :s2( system_xbox_statelist[xindex].y      ,xbox__yclick(xindex) );

xkey_menu            :s2( system_xbox_statelist[xindex].start  ,xbox__startclick(xindex) );
else
   begin
   //value not used
   end;
end;//case

//finalise sign
if (result<>0) and (xlabelindex <> game_fetchinput_mapper[xindex][xlabelindex]) then
   begin

   //detect sign change and change output sign
   if ( xneg(xlabelindex) <> xneg(game_fetchinput_mapper[xindex][xlabelindex]) ) then result:=-result;

   end;

end;

function game__fetchinput__remap(xindex,slabelindex,dlabelindex:longint):boolean;
var//Note: dlabelindex=-1 means the value is not used/assigned
   p:longint;
begin

//check
if (xindex=xssKeyboard) then
   begin
   result:=false;
   exit;
   end;

//get
result:=(xindex>=0) and (xindex<=xssMax) and (slabelindex>=0) and (slabelindex<=xkey_max) and (dlabelindex>=-1) and (dlabelindex<=xkey_max);

if result then
   begin

   if      (xindex=xssMouse)                    then game_fetchinput_mapper[xindex][slabelindex]:=dlabelindex
   else if (xindex>=0) and (xindex<=xssNative3) then
      begin

      //set all native controllers to the same mapping
      for p:=xssNative0 to xssNative3 do game_fetchinput_mapper[p][slabelindex]:=dlabelindex

      end;

   end;

end;

function game__fetchinput__mapsto(xindex,xlabelindex:longint;var dlabelindex:longint):boolean;//29jul2025
begin

case (xindex>=0) and (xindex<=xssMax) and (xlabelindex>=0) and (xlabelindex<=xkey_max) of
true:begin

   result      :=true;
   dlabelindex :=game_fetchinput_mapper[xindex][xlabelindex];

   end;
else
   begin

   result      :=false;
   dlabelindex :=-1;//not used

   end;
end;//case

end;

procedure game__fetchinput__remap__defaults(xindex:longint);
var
   p:longint;
begin

if (xindex>=0) and (xindex<=xssMax) then
   begin

   for p:=0 to xkey_max do game_fetchinput_mapper[xindex][p]:=p;

   end;

end;

function game__xboxmappings:string;
var
   p:longint;
begin

result:='';
for p:=0 to frcmax32(xkey_canmap,high(game_fetchinput_mapper[0])) do result:=result+intstr32(game_fetchinput_mapper[xssNative0][p])+',';

end;

function game__mousemappings:string;
var
   p:longint;
begin

result:='';
for p:=0 to frcmax32(xkey_canmap,high(game_fetchinput_mapper[0])) do result:=result+intstr32(game_fetchinput_mapper[xssMouse][p])+',';

end;

procedure game__setxboxmappings(const x:string);
var
   dcount,lp,p:longint;
   v:string;
begin

//init
dcount :=0;
lp     :=1;

//get
for p:=1 to low__len(x) do if (x[p-1+stroffset]=',') then
   begin

   v   :=strcopy1(x,lp,p-lp);
   lp  :=p+1;

   //.xkey_menu -> exclude items above the "xkey_canmap" range - 22jul2025
   if (dcount<=xkey_canmap) then game_fetchinput_mapper[xssNative0][dcount]:=frcrange32( strint32(v) ,-1,xkey_canmap);

   inc(dcount);
   if (dcount>high(game_fetchinput_mapper[xssNative0])) then break;

   end;//p

end;

procedure game__setmousemappings(const x:string);
var
   dcount,lp,p:longint;
   v:string;
begin

//init
dcount :=0;
lp     :=1;

//get
for p:=1 to low__len(x) do if (x[p-1+stroffset]=',') then
   begin

   v   :=strcopy1(x,lp,p-lp);
   lp  :=p+1;

   //.xkey_menu -> exclude items above the "xkey_canmap" range - 22jul2025
   if (dcount<=xkey_canmap) then game_fetchinput_mapper[xssMouse][dcount]:=frcrange32( strint32(v) ,-1,xkey_canmap);

   inc(dcount);
   if (dcount>high(game_fetchinput_mapper[xssMouse])) then break;

   end;//p

end;


procedure xgame__scaletobuffer2(xscale:double);
begin

//scale down
if      (xscale<0.25) then xgame__shrinktobuffer2__012pert
else if (xscale<0.5)  then xgame__shrinktobuffer2__025pert
else if (xscale<1)    then xgame__shrinktobuffer2__050pert
else                       xgame__shrinktobuffer2__050pert;

end;

procedure xgame__shrinktobuffer2__012pert;//12%
label
   yredo,xredo;
var
   slastx,slasty,xstop,ystop,ax,ay,sx,sy:longint;
begin

//size
if ((game_buffer.width div 8)<>game_buffer2.width) or ((game_buffer.height div 8)<>game_buffer2.height) then
   begin
   missize(game_buffer2, game_buffer.width div 8, game_buffer.height div 8 );
   game_bufferrows2:=game_buffer2.prows24;
   end;

//init
xstop            :=game_buffer2.width-1;
ystop            :=game_buffer2.height-1;
slastx           :=game_buffer.width-1;
slasty           :=game_buffer.height-1;

//y
ay     :=0;
sy     :=0;
yredo:

//x
ax     :=0;
sx     :=0;
xredo:

game_bufferrows2[ay][ax]:=game_bufferrows[sy][sx];

//inc x
if (ax<>xstop) then
   begin

   //next x pixel
   inc(ax);
   inc(sx,8);
   if (sx>slastx) then sx:=slastx;
   goto xredo;

   end;

//inc y
if (ay<>ystop) then
   begin

   //next y row
   inc(ay);
   inc(sy,8);
   if (sy>slasty) then sy:=slasty;
   goto yredo;

   end;

end;

procedure xgame__shrinktobuffer2__025pert;//25%
label
   yredo,xredo;
var
   slastx,slasty,xstop,ystop,ax,ay,sx,sy:longint;
begin

//size
if ((game_buffer.width div 4)<>game_buffer2.width) or ((game_buffer.height div 4)<>game_buffer2.height) then
   begin
   missize(game_buffer2, game_buffer.width div 4, game_buffer.height div 4 );
   game_bufferrows2:=game_buffer2.prows24;
   end;

//init
xstop            :=game_buffer2.width-1;
ystop            :=game_buffer2.height-1;
slastx           :=game_buffer.width-1;
slasty           :=game_buffer.height-1;

//y
ay     :=0;
sy     :=0;
yredo:

//x
ax     :=0;
sx     :=0;
xredo:

game_bufferrows2[ay][ax]:=game_bufferrows[sy][sx];

//inc x
if (ax<>xstop) then
   begin

   //next x pixel
   inc(ax);
   inc(sx,4);
   if (sx>slastx) then sx:=slastx;
   goto xredo;

   end;

//inc y
if (ay<>ystop) then
   begin

   //next y row
   inc(ay);
   inc(sy,4);
   if (sy>slasty) then sy:=slasty;
   goto yredo;

   end;

end;

procedure xgame__shrinktobuffer2__050pert;//50%
label
   yredo,xredo;
var
   slastx,slasty,xstop,ystop,ax,ay,sx,sy:longint;
begin

//size
if ((game_buffer.width div 2)<>game_buffer2.width) or ((game_buffer.height div 2)<>game_buffer2.height) then
   begin
   missize(game_buffer2, game_buffer.width div 2, game_buffer.height div 2 );
   game_bufferrows2:=game_buffer2.prows24;
   end;

//init
xstop            :=game_buffer2.width-1;
ystop            :=game_buffer2.height-1;
slastx           :=game_buffer.width-1;
slasty           :=game_buffer.height-1;

//y
ay     :=0;
sy     :=0;
yredo:

//x
ax     :=0;
sx     :=0;
xredo:

game_bufferrows2[ay][ax]:=game_bufferrows[sy][sx];

//inc x
if (ax<>xstop) then
   begin

   //next x pixel
   inc(ax);
   inc(sx,2);
   if (sx>slastx) then sx:=slastx;
   goto xredo;

   end;

//inc y
if (ay<>ystop) then
   begin

   //next y row
   inc(ay);
   inc(sy,2);
   if (sy>slasty) then sy:=slasty;
   goto yredo;

   end;

end;

function game__activetimer:comp;
begin
result:=game_activetimer;
end;

function game__fps:double;
begin
result:=game_fps;
end;

function game__rendertime:double;
begin
result:=game_rendertime;
end;

function game__bufferwidth:longint;
begin
result:=game_bufferwidth;
end;

function game__bufferheight:longint;
begin
result:=game_bufferheight;
end;

procedure game__bufferwh(var w,h:longint);
begin
w:=game_bufferwidth;
h:=game_bufferheight;
end;

procedure game__setvolume100(x:longint);
begin
game_volume100:=frcrange32(x,0,100);
end;

function game__volume100:longint;
begin
result:=game_volume100;
end;

function game__roundtozero(x:double):double;
begin
if (x>=-0.001) and (x<=0.001) then result:=0 else result:=x;
end;

procedure game__onkey(xrawkey:longint;xdown:boolean);
begin
xbox__keyrawinput(xrawkey,xdown);
end;

function game__keymappings:string;
begin
result:=xbox__keymappings;
end;

procedure game__setkeymappings(const x:string);
begin
xbox__setkeymappings(x);
end;

procedure game__invert(var nativex,nativey,keyboardx,keyboardy,mousex,mousey:boolean);//24jul2025
begin
xbox__invertaxis(nativex,nativey,keyboardx,keyboardy,mousex,mousey);
end;

procedure game__setinvert(nativex,nativey,keyboardx,keyboardy,mousex,mousey:boolean);//24jul2025
begin
xbox__setinvertaxis(nativex,nativey,keyboardx,keyboardy,mousex,mousey);
end;

function game__invertList:string;
begin
result:=xbox__invertaxislist;
end;

procedure game__setinvertList(x:string);
begin
xbox__setinvertaxislist(x);
end;

procedure game__lockkeyboard;
begin
xbox__lockkeyboard;
end;

procedure game__unlockkeyboard;
begin
xbox__unlockkeyboard;
end;

procedure game__setfullscreen(x:boolean);
begin
game_fullscreen:=x;
end;

function game__fullscreen:boolean;
begin
result:=game_fullscreen;
end;

procedure game__setdisplayindex(x:longint);
begin
game_displayindex:=frcrange32(x,-1,frcmin32(monitors__count-1,0));
end;

function game__displayindex:longint;
begin
result:=frcrange32(game_displayindex,-1,frcmin32(monitors__count-1,0));
end;

function game__displaylabel:string;
begin

if (game_displayindex<=-1) then result:='Auto'
else                            result:=k64(game_displayindex);

end;

function game__sndgen__online:boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.online;
end;

function game__sndgen__stereo:boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.stereo;
end;

function game__sndgen__slotfirst:longint;//first slot
begin
result:=1;
end;

function game__sndgen__slotlimit:longint;
begin
if (game_sndgen<>nil) then result:=game_sndgen.limit else result:=0;
end;

procedure game__sndgen__fadeout(xslot:longint);
begin
if (game_sndgen<>nil) and (xslot>=1) then game_sndgen.fadeout(xslot);
end;

procedure game__sndgen__tone(xslot,xfeq:longint;xvol:double);
begin
if (game_sndgen<>nil) and (xslot>=1) then game_sndgen.tone(xslot,xfeq,xvol);
end;

procedure game__sndgen__tone2(xslot,xfeq:longint;xvol,xbal:double);
begin
if (game_sndgen<>nil) and (xslot>=1) then game_sndgen.tone2(xslot,xfeq,xvol,xbal);
end;

procedure game__sndgen__tone3(xslot,xruntime,xfeq:longint;xvol,xbal:double);
begin
if (game_sndgen<>nil) and (xslot>=1) then game_sndgen.tone3(xslot,xruntime,xfeq,xvol,xbal);
end;

procedure game__sndgen__hiss(xslot:longint;xhisslevel,xvol:double);
begin
if (game_sndgen<>nil) and (xslot>=1) then game_sndgen.hiss(xslot,xhisslevel,xvol);
end;

procedure game__sndgen__hiss2(xslot:longint;xhisslevel,xvol,xbal:double);
begin
if (game_sndgen<>nil) and (xslot>=1) then game_sndgen.hiss2(xslot,xhisslevel,xvol,xbal);
end;

procedure game__sndgen__hiss3(xslot,xruntime:longint;xhisslevel,xvol,xbal:double);
begin
if (game_sndgen<>nil) and (xslot>=1) then game_sndgen.hiss3(xslot,xruntime,xhisslevel,xvol,xbal);
end;

function game__sndgen__varinit(xruntime,xbasefeq:longint;xbasevol:double):boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.varinit(xruntime,xbasefeq,xbasevol);
end;

function game__sndgen__varinit2(xruntime,xbasefeq:longint;xbasevol,xbasebal:double):boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.varinit2(xruntime,xbasefeq,xbasevol,xbasebal);
end;

function game__sndgen__vartone1(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.vartone1(xms,xfeq,xvol,xbal,xmute);
end;

function game__sndgen__vartone2(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.vartone2(xms,xfeq,xvol,xbal,xmute);
end;

function game__sndgen__vartone3(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.vartone3(xms,xfeq,xvol,xbal,xmute);
end;

function game__sndgen__varhiss4(xms:longint;xhisslevel,xvol,xbal:double;xmute:boolean):boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.varhiss4(xms,xhisslevel,xvol,xbal,xmute);
end;

function game__sndgen__vartone(xms,xfeq:longint):boolean;//uses "vartone1"
begin
result:=(game_sndgen<>nil) and game_sndgen.vartone(xms,xfeq);
end;

function game__sndgen__vartoneb(xms,xfeq:longint):boolean;//uses "vartone2"
begin
result:=(game_sndgen<>nil) and game_sndgen.vartoneb(xms,xfeq);
end;

function game__sndgen__vartonec(xms,xfeq:longint):boolean;//uses "vartone3"
begin
result:=(game_sndgen<>nil) and game_sndgen.vartonec(xms,xfeq);
end;

function game__sndgen__vartonehiss(xms,xfeq:longint;xhisslevel,xvol,xmix:double):boolean;
begin
result:=(game_sndgen<>nil) and game_sndgen.vartonehiss(xms,xfeq,xhisslevel,xvol,xmix);
end;

function game__sndgen__varsave(xslot:longint):boolean;
begin
result:=(game_sndgen<>nil) and (xslot>=1) and game_sndgen.varsave(xslot);
end;

function game__sndgen__varsave2(xslot:longint;xreset:boolean):boolean;
begin
result:=(game_sndgen<>nil) and (xslot>=1) and game_sndgen.varsave2(xslot,xreset);
end;

procedure game__paintnow(sender:tobject);
begin

case (game_info<>nil) and (game_info.gui<>nil) and game_info.gui.gamemode of
true:game_info.gui.paintnow;
else if (sender<>nil) and (sender is tbasiccontrol) then (sender as tbasiccontrol).paintnow;
end;//case

end;

procedure xgame__timer(sender:tobject);//fired internally by "game_info" object - 24jul2025
var
   x64:comp;
   p:longint;
   d:comp;
   dmenushowing:boolean;
   da:twinrect;
begin
//check
if not game_init then exit;

//lock
if game_timerbusy then exit else game_timerbusy:=true;

try
//init
x64:=ms64;


//fire host timer first -> allows for input to be checked in correct order BEFORE we internally check it
if assigned(game_hosttimerproc) then game_hosttimerproc(sender);

//menu showing + enable normal menu navigation by "temporarily" disabling keyboard inverts
dmenushowing                        :=game__menushowing;
system_xbox_suspend_all_inversions  :=dmenushowing;


//xbox controller
if dmenushowing then for p:=0 to xbox__lastindex(true) do if xbox__state(p) then
   begin

   //menu button
   if xbox__startclick(p) and xbox__native(p) and game__inprogress then game__hidemenu;

   if xbox__lanyclick(p)                  then game__menuaction(gmaLeft);
   if xbox__ranyclick(p)                  then game__menuaction(gmaRight);
   if xbox__uanyclick(p)                  then game__menuaction(gmaUp);
   if xbox__danyclick(p)                  then game__menuaction(gmaDown);

   if xbox__lanyautoclick(p)              then game__menuaction(gmaLeft);
   if xbox__ranyautoclick(p)              then game__menuaction(gmaRight);
   if xbox__uanyautoclick(p)              then game__menuaction(gmaUp);
   if xbox__danyautoclick(p)              then game__menuaction(gmaDown);

   if xbox__bclick(p) and xbox__native(p) then game__menuaction(gmaBack);
   if xbox__aclick(p) and xbox__native(p) then game__menuaction(gmaSelect);

   //.extended keyboard support via slot #4
   if xbox__escClick(p)                   then game__menuaction(gmaBack);
   if xbox__enterClick(p)                 then game__menuaction(gmaSelect);
   end;//p


//cycle flashers
game__flashcycle(false);


//activetimer + flashlevel
if (x64>=game_flashlevel.timeref) then
   begin

   case game_flashlevel.modeup of
   true:inc(game_flashlevel.level255,10);
   else dec(game_flashlevel.level255,10);
   end;//case

   if (game_flashlevel.level255<100) then
      begin
      game_flashlevel.level255  :=100;
      game_flashlevel.modeup    :=true;
      end
   else if (game_flashlevel.level255>255) then
      begin
      game_flashlevel.level255  :=255;
      game_flashlevel.modeup    :=false;
      end;

   //.activetimer
   if game_playing then game_activetimer:=add64(game_activetimer,50);

   //.20fps
   game_flashlevel.timeref:=x64+50;
   end;


//sound generator
if (game_sndgen<>nil) then game_sndgen.xtimer(nil);


//timer 500ms
if (x64>=game_timer500) then
   begin

   //cursor
   if (game_info<>nil) then
      begin
      case game_info.gui.gamemode of
      true:game_info.gui.hidecursor;
      else game_info.gui.showcursor;
      end;//case
      end;

   //sound generator -> stop playing all host sounds -> channel 0 is reserved for game system and can continue to play
   if (game_sndgen<>nil) then
      begin

      //mute host sounds
      if (not game_playing) then for p:=1 to (game_sndgen.limit-1) do game_sndgen.fadeout(p);

      //volume
      if (game_sndgen.volume100<>game_volume100) then game_sndgen.volume100:=game_volume100;

      //full screen
      if (app__gui<>nil) then
         begin

         //fullscreen
         case game_fullscreen of
         true:if (app__gui.state<>'f') then app__gui.state:='f';
         else if (app__gui.state='f')  then app__gui.state:='n';
         end;//case

         //make window "ontop" when in full screen mode - 25jul2025
         if (syssettings<>nil) and (game_fullscreen<>syssettings.b['ontop']) then
            begin
            syssettings.b['ontop']:=game_fullscreen;
            viSyncandsave;
            end;

         end;

      end;

   //turbo
   if game_playing then app__turbo;

   //sync clip cursor
   if (game_info<>nil) then
      begin

      //on
      system_clipcursor_active:=game_playing and game_info.gui.active;


      if system_clipcursor_active then
         begin

         //get
         game_cliparea.left   :=game_info.gui.left;
         game_cliparea.right  :=game_cliparea.left+game_info.gui.width-1;
         game_cliparea.top    :=game_info.gui.top;
         game_cliparea.bottom :=game_cliparea.top+game_info.gui.height-1;

         if not win____GetClipCursor(da) then da:=area__nil;

         //set
         if not area__equal(da,game_cliparea) then win____ClipCursor(@game_cliparea);

         end
      //off
      else win____ClipCursor(nil);

      end;


   //sync display index -> required for "full screen" and "display index" changes etc - 28jul2025
   if (game_info<>nil) and (game_displayindex>=0) and (game_info.gui.monitorindex<>game_displayindex) then
      begin
      game_info.gui.form__center(game_displayindex);
      end;

   //reset
   game_timer500:=add64(x64,500);

   end;


//timer 1000ms
if (x64>=game_timer1000) then
   begin

   //get
   game_fps                 :=( (game_fps*4) + game_fpscount  ) / 5;
   game_mps                 :=( (game_mps*4) + game_pixelcount) / 5;
   game_spritespersec       :=( (game_spritespersec*4) + game_spritedrawcount ) / 5;


   case game__sndgen__online of
   true:begin
      game_soundchannelsinuse :=game_sndgen.peakchannelcount(true);
      game_soundmbsec         :=( (game_soundmbsec*4) + (game_soundchannelsinuse*88200*low__aorb(1,2,game_sndgen.stereo)/1000000) ) / 5;
      end;
   else
      begin
      game_soundchannelsinuse :=0;
      game_soundmbsec         :=0;
      end;
   end;//case

   //.packets per second
   d:=0;
   for p:=0 to xbox__lastindex(true) do if xbox__state(p) then
      begin
      d:=add64(d,system_xbox_statelist[p].packetcount);
      end;

   if (game_packetcount<=0) then
      begin
      game_packetcount     :=d;
      game_packetlastcount :=d;
      end
   else
      begin
      game_packetlastcount    :=game_packetcount;
      game_packetcount        :=d;
      end;

   game_packetspersec      :=( (game_packetspersec*4) + frcmin32(restrict32( sub64(game_packetcount,game_packetlastcount) ),0) ) / 5;


   //reset
   game_fpscount            :=0;
   game_pixelcount          :=0;
   game_spritedrawcount     :=0;
   game_timer1000           :=add64(x64,1000);

   end;

except;end;
//unlock
game_timerbusy:=false;
end;

function game__idlethreshold:longint;
begin
result:=game_idlethreshold;
end;

function game__safetohalt:boolean;//21jul2025
begin
result:=(game_sndgen=nil) or (game_sndgen.bufferlevel<=0);
end;

function game__speedtest(xslot,xwidth,xheight:longint):boolean;
begin
result:=(app__gui<>nil) and game__speedtest2(xslot,app__gui.mousemovexy.y div frcmin32(app__gui.height div 4,1),xwidth,xheight,app__gui.mousemovexy.x>=frcmin32(app__gui.width div 2,1),app__gui.mousemovexy.y>=(app__gui.height-32));
end;

function game__speedtest2(xslot,xlevel03,xwidth,xheight:longint;xalpha,xlesszoom:boolean):boolean;
label
   redo;
var
   sparamfirst:boolean;
   xproccount,sindex:longint;
   xref:comp;
   xmps,xfps,xave_mps,xave_fps:double;
   str1:string;

   function sparam(xlabel,xval:string;xuse:boolean):string;
   begin

   if xuse then
      begin

      //sep
      if sparamfirst then result:='' else result:=', ';
      sparamfirst:=false;

      //value
      if (xval<>'') then result:=result+xlabel+'('+xval+')'
      else               result:=result+xlabel;

      end
   else result:='';

   end;

   procedure sadd(x:string);
   begin
   dbstatus(sindex,x);//ok - part of code
   inc(sindex);
   end;

   function xcalcfps(amps:double):double;
   begin
   result:=game_buffer.width*game_buffer.height;
   result:=result/1000000;
   if (result<0.1) then result:=0.1;
   result:=amps/result;
   end;
begin
//defaults
result:=(xslot>=0) and (xslot<=high(game_slotlist)) and (game_slotlist[xslot]<>nil) and (game_slotlist[xslot] is tpic8);

//check
if (not result) or game_drawing then exit;

//range
if (xwidth<=0)  then xwidth  :=1920;
if (xheight<=0) then xheight :=1080;

//start
game__beginpaint(nil,xwidth,xheight);

//init
sparamfirst             :=true;
sindex                  :=38;
xproccount              :=0;
game_pixelcount         :=0;
game_drawinfo.core      :=nil;
game_drawinfo.x         :=0;
game_drawinfo.y         :=0;
game_drawinfo.xzoom     :=1;
game_drawinfo.yzoom     :=1;
game_drawinfo.power255  :=low__aorb(255,30,xalpha);
game_drawinfo.mirror    :=false;
game_drawinfo.flip      :=false;

//set vals to trigger specific drawfast proc usage
case xlevel03 of
1:game_drawinfo.mirror:=true;// xpic8__drawfast1__power255_flip_mirror
2:game_drawinfo.x:=-1;//        xpic8__drawfast11__power255_flip_mirror_cliprange(
3:begin//                       xpic8__drawfast21__power255_flip_mirror_zoom_cliprange
   game_drawinfo.x:=-1;
   game_drawinfo.xzoom:=low__aorb(4,2,xlesszoom);
   game_drawinfo.yzoom:=low__aorb(4,2,xlesszoom);
   end;
end;//else                      xpic8__drawfast0__power255_flip

//get
xref:=ms64;

redo:

inc(xproccount);
game__draw0(xslot,game_drawinfo);

if (sub64(ms64,xref)<500) then
   begin

   if (game_drawinfo.x>=0) then
      begin
      game_drawinfo.x:=frcrange32(random(game_buffer.width-1),0,game_buffer.width-game_drawinfo.core.w);
      game_drawinfo.y:=frcrange32(random(game_buffer.height-1),0,game_buffer.height-game_drawinfo.core.h);
      end
   else
      begin
      game_drawinfo.y:=frcrange32(random(game_buffer.height-1),0,game_buffer.height-game_drawinfo.core.h);
      end;

   goto redo;
   end;

xref:=frcmin64( sub64(ms64,xref) , 1);

//finish
game__endpaint(nil,0);

//calculate
xmps  :=game_pixelcount*(1000/frcmin64(xref,1));
xfps  :=xcalcfps(xmps);

//.ave
if low__setstr(game_speedtest_ref, intstr32(xlevel03)+'|'+intstr32(game_drawinfo.core.dataid)+'|'+intstr32(game_drawinfo.core.w)+'|'+intstr32(game_drawinfo.core.h)+'|'+intstr32(game_buffer.width)+'|'+intstr32(game_buffer.height)+'|'+intstr32(game_drawinfo.xzoom)+'|'+intstr32(game_drawinfo.yzoom)+'|'+intstr32(game_drawinfo.power255)+'|'+bolstr(game_drawinfo.mirror)+bolstr(game_drawinfo.flip)+'|'+intstr32(game_drawproc_id)) or (game_speedtest_count>=max16) then
   begin
   game_speedtest_mps   :=xmps;
   game_speedtest_count :=1;
   end
else
   begin
   game_speedtest_mps   :=game_speedtest_mps+xmps;
   inc(game_speedtest_count);
   end;

xave_mps  :=game_speedtest_mps/frcmin32(game_speedtest_count,1);
xave_fps  :=xcalcfps(xave_mps);


//show results on screen
sadd('-- Speed Test --');

str1:=
 sparam('x.zoom',k64(game_drawinfo.xzoom)+'x',game_drawinfo.xzoom>=2)+
 sparam('y.zoom',k64(game_drawinfo.yzoom)+'x',game_drawinfo.yzoom>=2)+
 sparam('power255',k64(game_drawinfo.power255),game_drawinfo.power255<255)+
 sparam('mirror','',game_drawinfo.mirror)+
 sparam('flip','',game_drawinfo.flip)+
 sparam('cliprange','',game_drawproc_id>=11)+
 '';
if (str1='') then str1:='Normal(fastest)';

sadd('Level: '+k64(xlevel03));
sadd('Mode: '+str1);
sadd('Draw Time: '+k64(xref)+' ms');
if (game_drawinfo.core<>nil) then sadd('Draw Size: '+k64(game_drawinfo.core.w)+'w x '+k64(game_drawinfo.core.h)+'h');
sadd('Proc ID: '+k64(game_drawproc_id));
sadd('Proc Count: '+k64(xproccount));
sadd('mps: '+floattostrex(xmps,2));
sadd('fps: '+floattostrex(xfps,2));
sadd('ave.mps: '+floattostrex(xave_mps,2));
sadd('ave.fps: '+floattostrex(xave_fps,2));
end;

function game__draw0(xslot:longint;var x:tdrawfastinfo):boolean;
var
   sbits,sw,sh:longint;
begin

if game_drawing and (xslot>=0) and (xslot<=high(game_slotlist)) and (game_slotlist[xslot]<>nil) then
   begin

   //draw "tpic8" image
   if (game_slotlist[xslot] is tpic8) then
      begin

      //init
      game_drawinfo.core      :=@(game_slotlist[xslot] as tpic8).core;
      game_drawinfo.x         :=x.x;
      game_drawinfo.y         :=x.y;
      game_drawinfo.xzoom     :=x.xzoom;
      game_drawinfo.yzoom     :=x.yzoom;
      game_drawinfo.power255  :=x.power255;
      game_drawinfo.mirror    :=x.mirror;
      game_drawinfo.flip      :=x.flip;

      //get
      pic8__drawfast(game_drawinfo);
      result:=true;

      end

   //draw mis based image
   else if misok82432(game_slotlist[xslot],sbits,sw,sh) then
      begin

      //init
      if (x.xzoom<1) then x.xzoom:=1 else if (x.xzoom>pic8_zoomlimit) then x.xzoom:=pic8_zoomlimit;
      if (x.yzoom<1) then x.yzoom:=1 else if (x.yzoom>pic8_zoomlimit) then x.yzoom:=pic8_zoomlimit;

      sw        :=sw*x.xzoom;
      sh        :=sh*x.yzoom;

      game_pixelcount:=game_pixelcount + ((sw*sh)/1000000);//millions of pixels

      if x.mirror then sw:=-sw;
      if x.flip   then sh:=-sh;

      //get
      result:=miscopyareaxx1B(x.x,x.y,sw,sh, area__make(0,0,sw-1,sh-1), game_buffer,game_slotlist[xslot],x.power255,true);

      end

   //unsupported type
   else result:=false;

   end
else result:=false;

end;

function game__draw1(xslot,dx,dy:longint):boolean;
var
   sbits,sw,sh:longint;
begin

if game_drawing and (xslot>=0) and (xslot<=high(game_slotlist)) and (game_slotlist[xslot]<>nil) then
   begin

   //draw "tpic8" image
   if (game_slotlist[xslot] is tpic8) then
      begin

      //init
      game_drawinfo.core      :=@(game_slotlist[xslot] as tpic8).core;
      game_drawinfo.x         :=dx;
      game_drawinfo.y         :=dy;
      game_drawinfo.xzoom     :=1;
      game_drawinfo.yzoom     :=1;
      game_drawinfo.power255  :=255;
      game_drawinfo.mirror    :=false;
      game_drawinfo.flip      :=false;

      //get
      pic8__drawfast(game_drawinfo);
      result:=true;

      end

   //draw mis based image
   else if misok82432(game_slotlist[xslot],sbits,sw,sh) then
      begin

      game_pixelcount:=game_pixelcount + ((sw*sh)/1000000);//millions of pixels

      result:=miscopyareaxx1B(dx,dy,sw,sh, area__make(0,0,sw-1,sh-1), game_buffer,game_slotlist[xslot],255,true);

      end

   //unsupported type
   else result:=false;

   end

else result:=false;

end;

function game__draw2(xslot,dx,dy,xpower255:longint;xmirror,xflip:boolean):boolean;
var
   sbits,sw,sh:longint;
begin

if game_drawing and (xslot>=0) and (xslot<=high(game_slotlist)) and (game_slotlist[xslot]<>nil) then
   begin

   //draw "tpic8" image
   if (game_slotlist[xslot] is tpic8) then
      begin

      //init
      game_drawinfo.core      :=@(game_slotlist[xslot] as tpic8).core;
      game_drawinfo.x         :=dx;
      game_drawinfo.y         :=dy;
      game_drawinfo.xzoom     :=1;
      game_drawinfo.yzoom     :=1;
      game_drawinfo.power255  :=xpower255;
      game_drawinfo.mirror    :=xmirror;
      game_drawinfo.flip      :=xflip;

      //get
      pic8__drawfast(game_drawinfo);
      result:=true;

      end

   //draw mis based image
   else if misok82432(game_slotlist[xslot],sbits,sw,sh) then
      begin

      game_pixelcount:=game_pixelcount + ((sw*sh)/1000000);//millions of pixels

      //init
      if xmirror then sw:=-sw;
      if xflip   then sh:=-sh;

      //get
      result:=miscopyareaxx1B(dx,dy,sw,sh, area__make(0,0,sw-1,sh-1), game_buffer,game_slotlist[xslot],xpower255,true);

      end

   //unsupported type
   else result:=false;

   end

else result:=false;

end;

function game__draw3(xslot,dx,dy,xzoom,xpower255:longint;xmirror,xflip:boolean):boolean;//16jul2025, 06jul2025
var
   sbits,sw,sh:longint;
begin

if game_drawing and (xslot>=0) and (xslot<=high(game_slotlist)) and (game_slotlist[xslot]<>nil) then
   begin

   //draw "tpic8" image
   if (game_slotlist[xslot] is tpic8) then
      begin

      //init
      game_drawinfo.core      :=@(game_slotlist[xslot] as tpic8).core;
      game_drawinfo.x         :=dx;
      game_drawinfo.y         :=dy;
      game_drawinfo.xzoom     :=xzoom;
      game_drawinfo.yzoom     :=xzoom;
      game_drawinfo.power255  :=xpower255;
      game_drawinfo.mirror    :=xmirror;
      game_drawinfo.flip      :=xflip;

      //get
      pic8__drawfast(game_drawinfo);
      result:=true;

      end

   //draw mis based image
   else if misok82432(game_slotlist[xslot],sbits,sw,sh) then
      begin

      //init
      if (xzoom<1) then xzoom:=1 else if (xzoom>pic8_zoomlimit) then xzoom:=pic8_zoomlimit;

      sw        :=sw*xzoom;
      sh        :=sh*xzoom;

      game_pixelcount:=game_pixelcount + ((sw*sh)/1000000);//millions of pixels

      if xmirror then sw:=-sw;
      if xflip   then sh:=-sh;

      //get
      result:=miscopyareaxx1B(dx,dy,sw,sh, area__make(0,0,sw-1,sh-1), game_buffer,game_slotlist[xslot],xpower255,true);

      end

   //unsupported type
   else result:=false;

   end

else result:=false;

end;

function game__draw4(xslot,dx,dy,xzoom,yzoom,xpower255:longint;xmirror,xflip:boolean):boolean;//16jul2025, 06jul2025
var
   sbits,sw,sh:longint;
begin

if game_drawing and (xslot>=0) and (xslot<=high(game_slotlist)) and (game_slotlist[xslot]<>nil) then
   begin

   //draw "tpic8" image
   if (game_slotlist[xslot] is tpic8) then
      begin

      //init
      game_drawinfo.core      :=@(game_slotlist[xslot] as tpic8).core;
      game_drawinfo.x         :=dx;
      game_drawinfo.y         :=dy;
      game_drawinfo.xzoom     :=xzoom;
      game_drawinfo.yzoom     :=yzoom;
      game_drawinfo.power255  :=xpower255;
      game_drawinfo.mirror    :=xmirror;
      game_drawinfo.flip      :=xflip;

      //get
      pic8__drawfast(game_drawinfo);
      result:=true;

      end

   //draw mis based image
   else if misok82432(game_slotlist[xslot],sbits,sw,sh) then
      begin

      //init
      if (xzoom<1) then xzoom:=1 else if (xzoom>pic8_zoomlimit) then xzoom:=pic8_zoomlimit;
      if (yzoom<1) then yzoom:=1 else if (yzoom>pic8_zoomlimit) then yzoom:=pic8_zoomlimit;

      sw        :=sw*xzoom;
      sh        :=sh*yzoom;

      game_pixelcount:=game_pixelcount + ((sw*sh)/1000000);//millions of pixels

      if xmirror then sw:=-sw;
      if xflip   then sh:=-sh;

      //get
      result:=miscopyareaxx1B(dx,dy,sw,sh, area__make(0,0,sw-1,sh-1), game_buffer,game_slotlist[xslot],xpower255,true);

      end

   //unsupported type
   else result:=false;

   end

else result:=false;

end;

procedure game__cls2(rgb:longint);//20jul2025
begin
if game_drawing then game__cls( tint4(rgb).r, tint4(rgb).g, tint4(rgb).b );
end;

procedure game__cls(r,g,b:byte);
label
   xredo,yredo;
var
   ax,ay,xstop,ystop:longint;
   drs24:pcolorrows24;
   d24:tcolor24;
begin
//check
if not game_drawing then exit;

//inc
game_pixelcount:=game_pixelcount + ((game_bufferwidth*game_bufferheight)/1000000);//millions of pixels

//init
d24.r     :=r;
d24.g     :=g;
d24.b     :=b;
drs24     :=game_bufferrows;
xstop     :=game_bufferwidth-1;
ystop     :=game_bufferheight-1;

//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//y
ay:=0;
yredo:

//x
ax:=0;
xredo:

drs24[ay][ax]:=d24;

//inc x
if (ax<>xstop) then
   begin
   inc(ax);
   goto xredo;
   end;

//inc y
if (ay<>ystop) then
   begin
   inc(ay);
   goto yredo;
   end;

end;

procedure game__drawarea(da:twinrect;r,g,b,a:byte);
begin

//check
if (not game_drawing) or (a<=0) then exit;

//get
if (a=255) then xgame__drawarea_solid(da,r,g,b)
else            xgame__drawarea__alpha(da,r,g,b,a);

end;

procedure game__drawarea2(da:twinrect;rgb,a:longint);
begin
//check
if (not game_drawing) or (a<=0) then exit;

//get
if (a=255) then xgame__drawarea_solid(da,tint4(rgb).r,tint4(rgb).g,tint4(rgb).b)
else
   begin

   //range
   if (a>255) then a:=255;

   //get
   xgame__drawarea__alpha(da,tint4(rgb).r,tint4(rgb).g,tint4(rgb).b,a);

   end;

end;

procedure xgame__drawarea_solid(da:twinrect;r,g,b:byte);//support proc
label
   xredo,yredo;
var
   ax,ay,cw,ch:longint;
   drs24:pcolorrows24;
   d24:tcolor24;
begin

//init
d24.r     :=r;
d24.g     :=g;
d24.b     :=b;
drs24     :=game_bufferrows;
cw        :=game_buffer.width;
ch        :=game_buffer.height;

//range
if (da.right<0) or (da.bottom<0) or (da.left>=cw) or (da.top>=ch)       then exit;//24jul2025
if (da.left<0)           then da.left:=0        else if (da.left>=cw)   then da.left:=cw-1;
if (da.right<da.left)    then da.right:=da.left else if (da.right>=cw)  then da.right:=cw-1;
if (da.top<0)            then da.top:=0         else if (da.top>=ch)    then da.top:=ch-1;
if (da.bottom<da.top)    then da.bottom:=da.top else if (da.bottom>=ch) then da.bottom:=ch-1;

//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//y
ay:=da.top;
yredo:

//x
ax:=da.left;
xredo:

drs24[ay][ax]:=d24;

//inc x
if (ax<>da.right) then
   begin
   inc(ax);
   goto xredo;
   end;

//inc y
if (ay<>da.bottom) then
   begin
   inc(ay);
   goto yredo;
   end;

end;

procedure xgame__drawarea__alpha(da:twinrect;r,g,b,a:byte);//support proc
label
   xredo,yredo;
var
   ca,cainv,car,cag,cab,ax,ay,cw,ch:longint;
   drs24:pcolorrows24;
   d24:tcolor24;
   v24:pcolor24;
begin

//init
ca        :=a;//alpha
cainv     :=255-ca;
d24.r     :=r;
d24.g     :=g;
d24.b     :=b;
drs24     :=game_bufferrows;
cw        :=game_buffer.width;
ch        :=game_buffer.height;
car       :=ca*d24.r;
cag       :=ca*d24.g;
cab       :=ca*d24.b;

//range
if (da.right<0) or (da.bottom<0) or (da.left>=cw) or (da.top>=ch)       then exit;//24jul2025
if (da.left<0)           then da.left:=0        else if (da.left>=cw)   then da.left:=cw-1;
if (da.right<da.left)    then da.right:=da.left else if (da.right>=cw)  then da.right:=cw-1;
if (da.top<0)            then da.top:=0         else if (da.top>=ch)    then da.top:=ch-1;
if (da.bottom<da.top)    then da.bottom:=da.top else if (da.bottom>=ch) then da.bottom:=ch-1;

//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//y
ay:=da.top;
yredo:

//x
ax:=da.left;
xredo:

if (ca=255) then drs24[ay][ax]:=d24
else
   begin

   //
   v24:=@drs24[ay][ax];
   v24.r:=( (cainv*v24.r) + car ) div 256;
   v24.g:=( (cainv*v24.g) + cag ) div 256;
   v24.b:=( (cainv*v24.b) + cab ) div 256;

   //242 mil/sec
// v24:=@drs24[ay][ax];
// v24.r:=( (cainv*v24.r) + (ca*d24.r) ) div 256;
// v24.g:=( (cainv*v24.g) + (ca*d24.g) ) div 256;
// v24.b:=( (cainv*v24.b) + (ca*d24.b) ) div 256;

   //165 mil/sec
// drs24[ay][ax].r:=( (cainv*drs24[ay][ax].r) + (ca*d24.r) ) div 256;
// drs24[ay][ax].g:=( (cainv*drs24[ay][ax].g) + (ca*d24.g) ) div 256;
// drs24[ay][ax].b:=( (cainv*drs24[ay][ax].b) + (ca*d24.b) ) div 256;

   end;

//inc x
if (ax<>da.right) then
   begin
   inc(ax);
   goto xredo;
   end;

//inc y
if (ay<>da.bottom) then
   begin
   inc(ay);
   goto yredo;
   end;

end;


procedure game__drawshade2(da:twinrect;rgb1,rgb2,a:longint);
begin

//check
if (not game_drawing) or (a<=0) then exit;

//range
if (a>255) then a:=255;

//get
game__drawshade(da,tint4(rgb1).r,tint4(rgb1).g,tint4(rgb1).b,tint4(rgb2).r,tint4(rgb2).g,tint4(rgb2).b,a);

end;

procedure game__drawshade(da:twinrect;r,g,b,r2,g2,b2,a:byte);
label
   xredo,yredo;
var
   car,cag,cab,ax,ay,slimit,s,sinv,ca,cainv,cw,ch:longint;
   drs24:pcolorrows24;
   d24:tcolor24;
   v24:pcolor24;
begin
//check
if (not game_drawing) or (a<=0) then exit;

//init
ca        :=a;//alpha
cainv     :=255-ca;
drs24     :=game_bufferrows;
cw        :=game_buffer.width;
ch        :=game_buffer.height;

//range
if (da.left<0)           then da.left:=0        else if (da.left>=cw)   then da.left:=cw-1;
if (da.right<da.left)    then da.right:=da.left else if (da.right>=cw)  then da.right:=cw-1;
if (da.top<0)            then da.top:=0         else if (da.top>=ch)    then da.top:=ch-1;
if (da.bottom<da.top)    then da.bottom:=da.top else if (da.bottom>=ch) then da.bottom:=ch-1;

//limit
slimit    :=da.bottom-da.top+1;

//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//y
ay   :=da.top;
yredo:

s    :=slimit - (ay-da.top);
sinv :=slimit - s;

d24.r:=( (sinv*r2) + (s*r) ) div slimit;
d24.g:=( (sinv*g2) + (s*g) ) div slimit;
d24.b:=( (sinv*b2) + (s*b) ) div slimit;

car:=ca*d24.r;
cag:=ca*d24.g;
cab:=ca*d24.b;


//x
ax:=da.left;
xredo:

//draw pixel
if (ca=255) then drs24[ay][ax]:=d24
else
   begin

   //
   v24:=@drs24[ay][ax];
   v24.r:=( (cainv*v24.r) + car ) div 256;
   v24.g:=( (cainv*v24.g) + cag ) div 256;
   v24.b:=( (cainv*v24.b) + cab ) div 256;

   //210 mil/sec
// v24:=@drs24[ay][ax];
// v24.r:=( (cainv*v24.r) + (ca*d24.r) ) div 256;
// v24.g:=( (cainv*v24.g) + (ca*d24.g) ) div 256;
// v24.b:=( (cainv*v24.b) + (ca*d24.b) ) div 256;

   //135 mil/sec
// drs24[ay][ax].r:=( (cainv*drs24[ay][ax].r) + (ca*d24.r) ) div 256;
// drs24[ay][ax].g:=( (cainv*drs24[ay][ax].g) + (ca*d24.g) ) div 256;
// drs24[ay][ax].b:=( (cainv*drs24[ay][ax].b) + (ca*d24.b) ) div 256;

   end;

//inc x
if (ax<>da.right) then
   begin
   inc(ax);
   goto xredo;
   end;

//inc y
if (ay<>da.bottom) then
   begin
   inc(ay);
   goto yredo;
   end;

end;

function game__addfont(xname:string;xsize:longint;xbold:boolean):longint;//08aug2025
var//Note: feathering of text is disabled - feature absorbs too much render time or about 4ms+ for a small amount of text - 24jul2025
   p:longint;
   e:string;
begin
//defaults
result :=0;

//range
xname  :=strdefb(xname,'Arial');
xsize  :=frcrange32(xsize,-300,150);
if (xsize=0) then xsize:=10;


//find existing
for p:=0 to (game_fontlist.count-1) do if (game_fontlist.fonts[p].size=xsize) and (game_fontlist.fonts[p].bold=xbold) and strmatch(game_fontlist.fonts[p].name,xname) then
   begin

   //get
   result :=p;

   //stop
   exit;

   end;

//create new
if (game_fontlist.count<=high(game_fontlist.fonts)) then
   begin

   //get
   game_fontlist.fonts[ game_fontlist.count ].name:=xname;
   game_fontlist.fonts[ game_fontlist.count ].size:=xsize;
   game_fontlist.fonts[ game_fontlist.count ].bold:=xbold;
   game_fontlist.fonts[ game_fontlist.count ].lgf:=str__new8;

   //.create font data
   game_fontlist.fonts[ game_fontlist.count ].ok:=low__toLGF(xname,xsize,false,xbold,game_fontlist.fonts[ game_fontlist.count ].lgf,e);

   //ok
   if game_fontlist.fonts[ game_fontlist.count ].ok then
      begin
      game_fontlist.fonts[ game_fontlist.count ].height:=low__fromLGF_height( game_fontlist.fonts[ game_fontlist.count ].lgf );
      end
   else
      begin
      game_fontlist.fonts[ game_fontlist.count ].height:=0;
      str__clear( @game_fontlist.fonts[ game_fontlist.count ].lgf );
      end;

   //set
   result:=game_fontlist.count;

   //inc
   inc(game_fontlist.count);

   end;

end;

function game__fontheight(findex:longint):longint;
begin

if (findex>=0) and (findex<game_fontlist.count) and game_fontlist.fonts[ findex ].ok then result:=game_fontlist.fonts[ findex ].height
else                                                                                      result:=0;

end;

function game__textwidth(findex:longint;const xline:string):longint;
begin

if (findex>=0) and (findex<game_fontlist.count) and game_fontlist.fonts[ findex ].ok then result:=low__fromLGF_textwidthTAB2('', game_fontlist.fonts[ findex ].lgf ,xline)
else                                                                                      result:=0;

end;

function game__textwidth2(findex:longint;const xline,xtab:string):longint;
begin

if (findex>=0) and (findex<game_fontlist.count) and game_fontlist.fonts[ findex ].ok then result:=low__fromLGF_textwidthTAB2(xtab, game_fontlist.fonts[ findex ].lgf ,xline)
else                                                                                      result:=0;

end;

procedure game__drawtext(findex:longint;const xline:string;dx,dy,dcol:longint);
begin

if game_drawing and (xline<>'') and (findex>=0) and (findex<game_fontlist.count) and game_fontlist.fonts[ findex ].ok then
   begin

   //init
   game_buftext.text:=xline;//reusable buffer

   //rednder text to image buffer
   low__fromLGF_drawtext2432TAB(0,'', game_fontlist.fonts[ findex ].lgf, game_buftext, dx,dy, game_bufferwidth, game_bufferheight, dcol, game_bufferarea, game_bufferarea, game_bufferrows, nil, nil, nil, 0, nil, 0, game_fontlist.fonts[ findex ].bold, false, false, false, false, false, false, 0);

   end;

end;

procedure game__drawtext2(findex:longint;const xline,xtab:string;dx,dy,dcol:longint);
begin

if game_drawing and (xline<>'') and (findex>=0) and (findex<game_fontlist.count) and game_fontlist.fonts[ findex ].ok then
   begin

   //init
   game_buftext.text:=xline;//reusable buffer

   //rednder text to image buffer
   low__fromLGF_drawtext2432TAB(0,xtab, game_fontlist.fonts[ findex ].lgf, game_buftext, dx,dy, game_bufferwidth, game_bufferheight, dcol, game_bufferarea, game_bufferarea, game_bufferrows, nil, nil, nil, 0, nil, 0, game_fontlist.fonts[ findex ].bold, false, false, false, false, false, false, 0);

   end;

end;

function game__errorcount:longint;
begin
result:=game_errorcount;
end;

function game__fromfile(const xfilename:string;xdata:pobject):boolean;
label
   skipend;
var
   x:pointer;
   p,xlen:longint;
   xcompressed:boolean;
   xname:string;
begin
//defaults
result:=false;

try
//check
if not str__lock(xdata) then exit;

//get
for p:=0 to max32 do
begin

{$ifdef gamecore}
if not storage__findfile(p,x,xlen,xcompressed,xname) then break;
{$else}
break;
{$endif}


//.file found -> load data
if strmatch(xfilename,xname) then
   begin
   //.clear
   str__clear(xdata);

   //.fill with data
   if not str__addrec(xdata,x,xlen) then goto skipend;

   //.decompress
   if xcompressed and (not low__decompress(xdata)) then goto skipend;

   //successful
   result:=true;

   //stop
   break;
   end;

end;//p

skipend:
except;end;
//clear on error
if not result then str__clear(xdata);
//free
str__uaf(xdata);
end;

function game__slotcount:longint;
begin
result:=game_slotcount;
end;

function game__slotlast:longint;
begin
result:=game_slotlast;
end;

function game__slotok(xslot:longint):boolean;
begin
result:=(xslot>=0) and (xslot<=high(game_slotlist)) and (game_slotlist[xslot]<>nil);
end;

function game__slotstyle(xslot:longint):string;
begin

if game__slotok(xslot) then
   begin
   if      (game_slotlist[xslot] is tpic8)       then result:='tex'
   else if (game_slotlist[xslot] is tbasicimage) then result:='img'
   else if (game_slotlist[xslot] is tsnd)        then result:='snd'
   else                                               result:='';
   end
else result:='';

end;

function game__slotisimage(xslot:longint):boolean;
begin
result:=game__slotok(xslot) and ( (game_slotlist[xslot] is tpic8) or (game_slotlist[xslot] is tbasicimage) );
end;

//.sprite
function game__spriteok(xslot:longint):boolean;
begin
result:=game__slotok(xslot) and (game_slotlist[xslot] is tpic8);
end;

function game__sprite(xslot:longint):tpic8;
begin
if game__slotok(xslot) and (game_slotlist[xslot] is tpic8) then result:=(game_slotlist[xslot] as tpic8) else result:=nil;
end;

function game__spriteinfo(xslot:longint;var w,h:longint):boolean;
var
   a:tpic8;
begin
a:=game__sprite(xslot);
result:=(a<>nil);

if result then
   begin
   w:=a.core.w;
   h:=a.core.h;
   end
else
   begin
   w:=0;
   h:=0;
   end;
end;

function game__spritesetprogress(xslot:longint;v:array of double):boolean;//set progress levels (0..5) for sprite
var
   a:tpic8;
   p:longint;
begin

//get
a:=game__sprite(xslot);
result:=(a<>nil);

//set
if result then for p:=0 to frcmax32( high(a.core.progress) , high(v) ) do a.core.progress[p]:=frcrangeD64(v[p],0,1);//0..1

end;

function game__spriteRenderinit(xslot:longint):boolean;
var
   a:tpic8;
begin
a:=game__sprite(xslot);
result:=(a<>nil);
if result then pic8__renderinit( a.core );
end;

function game__spriteRenderinitAll:boolean;
var
   p:longint;
begin
result:=false;

for p:=0 to game_slotlast do if (game_slotlist[p]<>nil) and (game_slotlist[p] is tpic8) then
   begin
   pic8__renderinit( (game_slotlist[p] as tpic8).core );
   result:=true;
   end;

end;

function game__spritenew(xfilename:string):longint;
var
   p:longint;
   a:tpic8;
   d:tstr8;
begin
//failed
result:=-1;
a     :=nil;
d     :=nil;

try

//force file extension ".pic8"
if not strmatch(io__lastext(xfilename),'pic8') then xfilename:=xfilename+'.pic8';

//find next free slot
for p:=0 to high(game_slotlist) do if (game_slotlist[p]=nil) then
   begin

   //load data from file
   d:=str__new8;

   if game__fromfile(xfilename,@d) then
      begin

      //create image handler
      a:=tpic8.create;

      //load image data from stream "d"
      if pic8__fromdata(a.core,d.text) then
         begin

         //image is loaded -> assign to system slot and return slot index
         game_slotlist[p]:=a;
         result:=p;

         //sync
         game__slotcount_sync;
         end
      else inc(game_errorcount);

      end
   else inc(game_errorcount);

   //stop
   break;
   end;

except;end;
//free on error
if (result<=-1) then freeobj(@a);
//free
str__free(@d);
end;

function game__spritenew2(const x:tpiccore8):longint;//from an external piccore8
var
   p:longint;
   a:tpic8;
begin
//failed
result:=-1;
a     :=nil;

try

//find next free slot
for p:=0 to high(game_slotlist) do if (game_slotlist[p]=nil) then
   begin

   //create image handler
   a:=tpic8.create;

   //copy over core
   a.core:=x;

   //image is loaded -> assign to system slot and return slot index
   game_slotlist[p]:=a;
   result:=p;

   //sync
   game__slotcount_sync;

   //stop
   break;
   end;

except;end;
//free on error
if (result<=-1) then freeobj(@a);
end;

//.image
function game__imgok(xslot:longint):boolean;
begin
result:=game__slotok(xslot) and (game_slotlist[xslot] is tbasicimage);
end;

function game__img(xslot:longint):tbasicimage;
begin
if game__slotok(xslot) and (game_slotlist[xslot] is tbasicimage) then result:=(game_slotlist[xslot] as tbasicimage) else result:=nil;
end;

function game__imginfo(xslot:longint;var w,h:longint):boolean;
var
   a:tbasicimage;
begin
a:=game__img(xslot);
result:=(a<>nil);

if result then
   begin
   w:=misw(a);
   h:=mish(a);
   end
else
   begin
   w:=0;
   h:=0;
   end;
end;

function game__imgwidth(xslot:longint):longint;
begin
result:=misw(game__img(xslot));
end;

function game__imgheight(xslot:longint):longint;
begin
result:=mish(game__img(xslot));
end;

function game__imgnew(xfilename:string):longint;
var
   p:longint;
   a:tbasicimage;
   d:tstr8;
   bol1:boolean;
   e:string;
begin
//failed
result:=-1;
a     :=nil;
d     :=nil;

try

//find next free slot
for p:=0 to high(game_slotlist) do if (game_slotlist[p]=nil) then
   begin

   //load data from file
   d:=str__new8;

   //.load using provided extension, or default to predefined extension list
   bol1:=game__fromfile(xfilename,@d);
   if not bol1 then bol1:=game__fromfile(xfilename+'.png',@d);
   if not bol1 then bol1:=game__fromfile(xfilename+'.jpg',@d);
   if not bol1 then bol1:=game__fromfile(xfilename+'.bmp',@d);
   if not bol1 then bol1:=game__fromfile(xfilename+'.img32',@d);

   //.load image
   if bol1 then
      begin
      //init
      a:=misimg32(1,1);

      //load image from stream
      if mis__fromdata(a,@d,e) then
         begin

         //image is loaded -> assign to system slot and return slot index
         game_slotlist[p]:=a;
         result:=p;

         //sync
         game__slotcount_sync;
         end
      else inc(game_errorcount);

      end
   else inc(game_errorcount);

   //stop
   break;
   end;

except;end;
//free on error
if (result<=-1) then freeobj(@a);
//free
str__free(@d);
end;

//.sound
function game__sndok(xslot:longint):boolean;
begin
result:=game__slotok(xslot) and (game_slotlist[xslot] is tsnd);
end;

function game__snd(xslot:longint):tsnd;
begin
if game__slotok(xslot) and (game_slotlist[xslot] is tsnd) then result:=(game_slotlist[xslot] as tsnd) else result:=nil;
end;

function game__sndnew(xfilename:string):longint;
var
   p:longint;
   a:tsnd;
   d:tstr8;
   bol1:boolean;
   dext:string;
begin
//failed
result:=-1;
a     :=nil;
d     :=nil;

try

//find next free slot
for p:=0 to high(game_slotlist) do if (game_slotlist[p]=nil) then
   begin

   //load data from file
   d:=str__new8;

   //.load using provided extension, or default to predefined extension list
   dext:=strlow(io__lastext(xfilename));

   case (dext='wav') or (dext='snd') of
   true:bol1:=game__fromfile(xfilename,@d);
   else bol1:=false;
   end;//case

   if not bol1 then bol1:=game__fromfile(xfilename+'.wav',@d);
   if not bol1 then bol1:=game__fromfile(xfilename+'.snd',@d);

   //.load sound
   if bol1 then
      begin
      //init
      a:=tsnd.create(0);
      a.add(d);

      //sound is loaded -> assign to system slot and return slot index
      game_slotlist[p]:=a;
      result:=p;

      //sync
      game__slotcount_sync;
      end
   else inc(game_errorcount);

   //stop
   break;
   end;

except;end;
//free on error
if (result<=-1) then freeobj(@a);
//free
str__free(@d);
end;

function game__slotdel(xslot:longint):boolean;
begin
result:=true;

if game__slotok(xslot) then
   begin
   freeobj( @game_slotlist[xslot] );
   game__slotcount_sync;
   end;
end;

function game__slotdelall:boolean;
var
   p:longint;
begin
result:=true;
for p:=0 to high(game_slotlist) do if (game_slotlist[p]<>nil) then freeobj( @game_slotlist[p] );
game__slotcount_sync;
end;

procedure game__slotcount_sync;
var
   p,xlast,xcount:longint;
begin
//defaults
xcount:=0;
xlast :=-1;

//get
for p:=0 to high(game_slotlist) do if (game_slotlist[p]<>nil) then
   begin
   inc(xcount);
   xlast:=p;
   end;

//set
game_slotcount:=xcount;
game_slotlast :=xlast;
end;

procedure game__flashcycle(xforce:boolean);
var
   v,p:longint;
   x64:comp;
   vpert:double;//was single;
begin
x64:=ms64;

//check
if not system_started then exit;

//get
if xforce or (x64>=game_flash64) then
   begin

   for p:=1 to high(game_flashlist) do if (x64>=game_flashref[p]) then
      begin
      //toggle flash mode
      game_flashlist[p]:=not game_flashlist[p];
      //0 or 1 by default -> when smooth transition is enabled, this value slides between 0 and 1 in a see-saw fashion of 0..1..0..1..0 etc
      if game_flashlist[p] then game_flashpert[p]:=1 else game_flashpert[p]:=0;
      //flicker
      game_flickerpert[p]:=(random(201)-100)/10000;
      //reset
      game_flashref[p]:=x64+game_flashdelay[p];
      end;

   //flicker slot0 is full speed -> NOT fps constrainted
   game_flickerpert[0]:=(random(201)-100)/10000;

   //master.reset
   game_flash64:=x64+33;
   end;

//smooth transition flash pert values -> calc between flashes for subframe rendering
if game_subframes then
   begin

   for p:=1 to high(game_flashlist) do
      begin

      //time from last flash state
      v:=restrict32( sub64(game_flashref[p],x64) );
      if (v<0) then v:=0 else if (v>game_flashdelay[p]) then v:=game_flashdelay[p];

      //convert time into a percentage in range 0..1
      vpert:=v/game_flashdelay[p];
      if (vpert<0) then vpert:=0 else if (vpert>1) then vpert:=1;

      //flash is ON -> we are moving toward OFF -> 1..0, otherwise we are moving toward ON -> 0..1
      if game_flashlist[p] then game_flashpert[p]:=1-vpert else game_flashpert[p]:=vpert;

      end;

   end;

end;

function game__subframes:boolean;
begin
result:=game_subframes;
end;

procedure game__setsubframes(xenable:boolean);
begin
game_subframes:=xenable;//requires a higher frame rate for subframes to be painted on screen
end;


//calc procs -------------------------------------------------------------------
procedure calc__drawlist(xinclusive:boolean;x,y,lastx,lasty:longint;xlist:tdynamicpoint);//return a sin/cos list of points to be able to draw a line etc - 03jan2019, 19aug2018
begin
calc__drawlist2(xinclusive,x,y,lastx,lasty,xlist,min32,max32,min32,max32);
end;

procedure calc__drawlist2(xinclusive:boolean;x,y,lastx,lasty:longint;xlist:tdynamicpoint;xmin,xmax,ymin,ymax:longint);//return a sin/cos list of points to be able to draw a line etc - 03jan2019, 19aug2018
var
   opp,adj,angle:real;
   px,py,xp,yp,c,maxc:longint;
begin
try
//check
if (xlist=nil) then exit;
//range
xmin:=smallest32(xmin,xmax);
xmax:=largest32(xmin,xmax);
ymin:=smallest32(ymin,ymax);
ymax:=largest32(ymin,ymax);
//init
xlist.clear;
xlist.incsize:=1000;
adj:=y-lasty;
opp:=x-lastx;
xp:=1;
yp:=1;
if (opp<0) then
   begin
   opp:=-opp;
   xp:=-xp;
   end;
c:=0;
//get
//.case 1: "adj=0" ----------------------------------------------------
if (adj=0) then
   begin
   //set
   maxc:=round(opp);
   repeat
   px:=frcrange32(lastx+xp*c,xmin,xmax);
   py:=frcrange32(lasty,ymin,ymax);
   xlist.value[xlist.count]:=low__point(px,py);
   inc(c);
   until (c>=maxc);//stable - 13sep2018
   end
else
//.case 2: all other situations ------------------------------------------------
   begin
   if (adj<0) then
      begin
      adj:=-adj;
      yp:=-yp;
      end;
   angle:=arctan(opp/adj);
   maxc:=round(sqrt(opp*opp+adj*adj));
   repeat
   //set - fixed, was "truc()" but we actually need to round up the value using "round()" for px and py - 03jan2019
   px:=frcrange32(round(lastx+(xp*sin(angle)*c)),xmin,xmax);
   py:=frcrange32(round(lasty+(yp*cos(angle)*c)),ymin,ymax);
   xlist.value[xlist.count]:=low__point(px,py);
   //inc
   inc(c);//fixed - 10SEP2011
   until (c>=maxc);//stable - 13sep2018
   end;

//xinclusive - ensures last point(x,y) is included at end of list - 13sep2018
if xinclusive and ((xlist.count=0) or (xlist.value[xlist.count-1].x<>x) or (xlist.value[xlist.count-1].y<>y)) then xlist.value[xlist.count]:=low__point(x,y);
except;end;
end;

//pic8 procs -------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//888888888888888888888888888888//._onpaint
procedure pic8__renderinit(var x:tpiccore8);
label
   iredo;
var
   i,v,f:longint;
   s:double;
   dprogresson:boolean;
   elist24,olist24 :plistcolor24;
   elist8,olist8   :plistcolor8;
   flist,lsmooth,lflick,lflickrate:plistval8;
begin

//init
x.tlist8REF:=-1;//17jul2025


//make render color list
i:=1;
iredo:


//dprogresson
if (i=x.uselist2ForThisColorIndex) then dprogresson:=true
else                                    dprogresson:=(pic8_progress_colorindexTOslot[i]>=0) and ( x.progress[ pic8_progress_colorindexTOslot[i] ] >= pic8_progress_colorindexTOtrigger[ i ] );


//progress based color and effects
if dprogresson then
   begin

   flist       :=@x.flist2;
   lsmooth     :=@x.lsmooth2;
   lflick      :=@x.lflick2;
   lflickrate  :=@x.lflickrate2;

   elist24     :=@x.elist24b;
   olist24     :=@x.olist24b;
   elist8      :=@x.elist8b;
   olist8      :=@x.olist8b;

   end
else
   begin

   flist       :=@x.flist;
   lsmooth     :=@x.lsmooth;
   lflick      :=@x.lflick;
   lflickrate  :=@x.lflickrate;

   elist24     :=@x.elist24;
   olist24     :=@x.olist24;
   elist8      :=@x.elist8;
   olist8      :=@x.olist8;

   end;


//flash rate -> faster than "f:=pic8__safeflashrate(flist[ i ]);"
f:=flist[ i ];
if (f<0) then f:=0 else if (f>high(game_flashlist)) then f:=high(game_flashlist);


//get
if game_subframes and ( (f>0) or (lflick[i]>0) ) then
   begin
   //smooth
   if      (lsmooth[i]>0)    then s:=game_flashpert[f]
   else if game_flashlist[f] then s:=1
   else                           s:=0;

   //flicker
   if (lflick[i]>0) then
      begin
      s:=s+( lflick[i] * game_flickerpert[ lflickrate[i] ] );
      if (s<0) then s:=0 else if (s>1) then s:=1;
      end;

   //get

   //.r
   v:=round( (s*olist24[i].r) + ((1-s)*elist24[i].r) );
   if (v<0) then v:=0 else if (v>255) then v:=255;
   x.rlist24[i].r:=v;//15jul2025

   //.g
   v:=round( (s*olist24[i].g) + ((1-s)*elist24[i].g) );
   if (v<0) then v:=0 else if (v>255) then v:=255;
   x.rlist24[i].g:=v;//15jul2025

   //.b
   v:=round( (s*olist24[i].b) + ((1-s)*elist24[i].b) );
   if (v<0) then v:=0 else if (v>255) then v:=255;
   x.rlist24[i].b:=v;//15jul2025

   //.a
   v:=round( (s*olist8[i]) + ((1-s)*elist8[i]) );
   if (v<0) then v:=0 else if (v>255) then v:=255;
   x.rlist8[i]:=v;//15jul2025

   end
else
   begin

   //flash on
   if (f>0) and game_flashlist[f] then
      begin
      x.rlist24[i] :=olist24[i];
      x.rlist8[i]  :=olist8 [i];
      end
   //flash off
   else
      begin
      x.rlist24[i] :=elist24[i];
      x.rlist8[i]  :=elist8 [i];
      end;

   end;

//inc
inc(i);
if (i<>high(tlistcolor24)) then goto iredo;//faster than a "for..to" loop

//force slot #0 to full transparency -> color not used - 14jul2025
x.rlist24[0].r:=255;
x.rlist24[0].g:=255;
x.rlist24[0].b:=255;
x.rlist8 [0]  :=0;

end;

function pic8__mustpaint(var x:tpiccore8;var xref:string):boolean;
var
   p:longint;
   fuse:tlistflashstate;
   flist:tlistflashstate;
   nref:string;
begin
//init
for p:=low(flist) to high(flist) do
begin
fuse[p]  :=false;
flist[p] :=false;
end;//p

//scan all USED colors for flash rates
for p:=0 to (x.pcount-1) do fuse[ x.flist[ x.plist[p] ] ]:=true;

//scan flash rates
nref:='';
for p:=0 to high(fuse) do nref:=nref+bolstr(fuse[p] and game_flashlist[p]);

for p:=0 to high(tprogresslist) do nref:=nref+floattostrex2(x.progress[p])+'|';

if game_subframes then nref:=nref+'|'+k64(div64(ms64,30));//bump upto 30fps for debugging

//get
result:=low__setstr(xref,nref);
end;

function pic8__canedit_colindex(xcolindex:longint):boolean;
begin
result:=(xcolindex>=1);
end;

function pic8__todata(var x:tpiccore8):string;//13jul2025
begin
result:=pic8__todata2(x,false);
end;

function pic8__todata1(var x:tpiccore8;var xdata:string):boolean;//19jul2025
begin
xdata  :=pic8__todata2(x,false);
result :=(xdata<>'');
end;

function pic8__todata2(var x:tpiccore8;x64:boolean):string;//13jul2025
var
   a:tstr8;
   p:longint;
begin
//defaults
a:=nil;

try
//init
a:=str__new8;

//header
a.sadd('pic8');//19jul2025
a.addint4(2);//format structure identifier
a.addint4(x.w);//width
a.addint4(x.h);//height
a.addint4(x.findex);
a.addint4(x.bindex);
a.addint4(1+high(tlistcolor32));//list count -> color count -> mark as full list used
a.addint4(x.pcount);//data count -> should always be (w*h)

//lists -> 4b x 6 = 24 bytes per record
for p:=0 to high(tlistcolor32) do
begin
a.addRGBA4(x.elist24[p].r  ,x.elist24[p].g  ,x.elist24[p].b     ,x.elist8[p]);//ecolor
a.addRGBA4(x.olist24[p].r  ,x.olist24[p].g  ,x.olist24[p].b     ,x.olist8[p]);//ocolor
a.addRGBA4(x.elist24b[p].r ,x.elist24b[p].g ,x.elist24b[p].b    ,x.elist8b[p]);//ecolor2
a.addRGBA4(x.olist24b[p].r ,x.olist24b[p].g ,x.olist24b[p].b    ,x.olist8b[p]);//ocolor2
a.addRGBA4(x.lsmooth[p]  ,x.lflick[p]   ,x.lflickrate[p]  ,x.flist[p]);
a.addRGBA4(x.lsmooth2[p] ,x.lflick2[p]  ,x.lflickrate2[p] ,x.flist2[p]);
end;//p

//pixel list -> actual image data
for p:=0 to ( ( x.w*x.h) - 1 ) do a.addbyt1(x.plist[p]);

//base64
if x64 then str__tob64(@a,@a,990);

//set
result:=a.text;

except;end;
//free
str__free(@a);
end;

function pic8__fromfile(var x:tpiccore8;const xfilename:string):boolean;//19jul2025
var
   v,e:string;
begin
//defaults
result:=false;

//get
try;result:=io__fromfilestr(xfilename,v,e) and pic8__fromdata(x,v);except;end;
end;

function pic8__tofile(var x:tpiccore8;const xfilename:string):boolean;
var
   v,e:string;
begin
//defaults
result:=false;

//get
try;result:=pic8__todata1(x,v) and io__tofilestr(xfilename,v,e);except;end;
end;

function pic8__fromdata(var x:tpiccore8;const xdata:string):boolean;
label
   skipend;
var
   a:tstr8;
   v4,p,xlistcount,xdatacount,xpos:longint;
   c32:tcolor32;
   xcanedit:boolean;

   procedure xclear;
   begin
   pic8__clear2(x,32,32);
   end;

   function p4:boolean;
   begin
   result :=true;//pass-thru
   v4     :=a.int4[xpos];
   inc(xpos,4);
   end;

   function i4:longint;
   begin
   result:=a.int4[xpos];
   inc(xpos,4);
   end;

   function i1:byte;
   begin
   result:=a.byt1[xpos];
   inc(xpos,1);
   end;
begin
//defaults
result:=false;
a:=nil;

try
//clear
xclear;

//check
if (xdata='') then goto skipend;

//init
a:=str__new8;
a.text:=xdata;

//get --------------------------------------------------------------------------

//header - 19jul2025
if not strmatch('pic8',a.str1[1,4]) then
   begin
   str__fromb64(@a,@a);
   if not strmatch('pic8',a.str1[1,4]) then goto skipend;
   end;

//.next header element
xpos:=4;

//format structure identifier
if (i4<>2) then goto skipend;

//width + height
x.w       :=pic8__safewh(i4);
x.h       :=pic8__safewh(i4);
x.pcount  :=x.w * x.h;

//foreground color index
x.findex:=frcrange32(i4,0,high(tlistcolor32));

//background color index
x.bindex:=frcrange32(i4,0,high(tlistcolor32));

//counts
xlistcount:=i4;
xdatacount:=i4;
if (xlistcount<0) or (xlistcount>(1+high(tlistcolor32))) then goto skipend;
if (xdatacount<0) or (xdatacount>x.pcount)               then goto skipend;

//lists -> 4b x 5 = 20 bytes per record -> skip first color -> system transparent color = leave as system set values - 14jul2025
for p:=0 to (xlistcount-1) do
begin

xcanedit:=pic8__canedit_colindex(p);

//.elist24
if p4 and xcanedit then
   begin
   c32:=int__c32(v4);
   x.elist24[p].r:=c32.r;
   x.elist24[p].g:=c32.g;
   x.elist24[p].b:=c32.b;
   x.elist8 [p]  :=c32.a;
   end;

//.olist24
if p4 and xcanedit then
   begin
   c32:=int__c32(v4);
   x.olist24[p].r:=c32.r;
   x.olist24[p].g:=c32.g;
   x.olist24[p].b:=c32.b;
   x.olist8 [p]  :=c32.a;
   end;

//.elist24b
if p4 and xcanedit then
   begin
   c32:=int__c32(v4);
   x.elist24b[p].r:=c32.r;
   x.elist24b[p].g:=c32.g;
   x.elist24b[p].b:=c32.b;
   x.elist8b [p]  :=c32.a;
   end;

//.ilist24b
if p4 and xcanedit then
   begin
   c32:=int__c32(v4);
   x.olist24b[p].r:=c32.r;
   x.olist24b[p].g:=c32.g;
   x.olist24b[p].b:=c32.b;
   x.olist8b [p]  :=c32.a;
   end;

if p4 and xcanedit then
   begin
   c32              :=int__c32(v4);
   x.lsmooth[p]     :=pic8__safesmooth(c32.r);
   x.lflick[p]      :=pic8__safeflicker(c32.g);
   x.lflickrate[p]  :=pic8__safeflashrate(c32.b);
   x.flist[p]       :=pic8__safeflashrate(c32.a);
   end;

if p4 and xcanedit then
   begin
   c32              :=int__c32(v4);
   x.lsmooth2[p]     :=pic8__safesmooth(c32.r);
   x.lflick2[p]      :=pic8__safeflicker(c32.g);
   x.lflickrate2[p]  :=pic8__safeflashrate(c32.b);
   x.flist2[p]       :=pic8__safeflashrate(c32.a);
   end;

end;//p

//data
for p:=0 to (xdatacount-1) do x.plist[p]:=i1;

//force 1st color slot(0) to be white and fully transparent
x.elist24[0].r:=255;
x.elist24[0].g:=255;
x.elist24[0].b:=255;
x.elist8 [0]  :=0;

x.elist24b[0]:=x.elist24[0];
x.olist24 [0]:=x.elist24[0];
x.olist24b[0]:=x.elist24[0];

x.elist8b[0]:=x.elist8[0];
x.olist8 [0]:=x.elist8[0];
x.olist8b[0]:=x.elist8[0];

//successful
result:=true;
skipend:

except;end;
//clear on error
if not result then
   begin

   xclear;

   //try old version
   result:=pic8__fromdataOLD(x,xdata);
   if not result then xclear;

   end;

//free
str__free(@a);
end;

function pic8__fromdataOLD(var x:tpiccore8;const xdata:string):boolean;//19jul2025
label
   skipend;
var
   a:tstr8;
   sp,scount20,p,xcolcount,xpos:longint;
   x4:tint4;
   xspecialeffects,xok:boolean;

   function i4:longint;
   begin
   result:=a.int4[xpos];
   inc(xpos,4);
   end;

   function b1:boolean;
   begin
   result:=a.bol1[xpos];
   inc(xpos,1);
   end;

   function i1:byte;
   begin
   result:=a.byt1[xpos];
   inc(xpos,1);
   end;
begin
//defaults
result:=false;
a:=nil;

//clear
pic8__clear2(x,20,20);

try
//check
if (xdata='') then goto skipend;

//init
a:=str__new8;
a.text:=xdata;

if not strmatch('tex1',a.str1[1,4]) then
   begin
   str__fromb64(@a,@a);
   if not strmatch('tex1',a.str1[1,4]) then goto skipend;
   end;

//get
xpos      :=4;
x.w       :=pic8__safewh(i4);
x.h       :=pic8__safewh(i4);
x.pcount  :=x.w * x.h;

i4;//bx1,bx2,by1,by2
i4;
i4;
i4;

xcolcount :=frcmin32(i4,0);

//.style
b1;
b1;
b1;
xspecialeffects :=b1;//extra data streams at end of image stream -> datasize = "xcolcount x 4"
b1;//reserved
b1;
b1;
b1;
b1;
b1;
//.more styles
i4;
i4;
x.findex  :=frcrange32(i4,0,high(tlistcolor32));
x.bindex  :=frcrange32(i4,0,high(tlistcolor32));
i4;//reserved
i4;
i4;
i4;
i4;
i4;

//.color list
if (xcolcount>=1) then
   begin
   for p:=0 to (xcolcount-1) do
   begin
   xok:=(p<=high(tlistcolor32));//only set values within range BUT read all values

   //.static color
   x4.val:=i4;
   if xok then
      begin
      x.elist24[p].r:=x4.r;
      x.elist24[p].g:=x4.g;
      x.elist24[p].b:=x4.b;
      x.elist8 [p]  :=x4.a;

      x.elist24b[p].r:=x4.r;
      x.elist24b[p].g:=x4.g;
      x.elist24b[p].b:=x4.b;
      x.elist8b [p]  :=x4.a;
      end;

   //.flash color
   x4.val:=i4;
   if xok then
      begin
      x.olist24[p].r:=x4.r;
      x.olist24[p].g:=x4.g;
      x.olist24[p].b:=x4.b;
      x.olist8 [p]  :=x4.a;

      x.olist24b[p].r:=x4.r;
      x.olist24b[p].g:=x4.g;
      x.olist24b[p].b:=x4.b;
      x.olist8b [p]  :=x4.a;
      end;

   //.flash rate
   if xok then
      begin
      x.flist[p]   :=pic8__safeflashrate(i1);
      x.flist2[p]  :=x.flist[p];
      end;
   end;//p
   end;

//.pixel list
for p:=0 to (x.pcount-1) do x.plist[p]:=i1;

//.special effects
if xspecialeffects then
   begin

   for p:=0 to (xcolcount-1) do
   begin

   xok:=(p<=high(tlistcolor32));//only set values within range BUT read all values

   //.static color
   x4.val:=i4;
   if xok then
      begin

      x.lsmooth[p]      :=pic8__safesmooth(x4.r);
      x.lflick[p]       :=pic8__safeflicker(x4.g);
      x.lflickrate[p]   :=pic8__safeflashrate(x4.b);

      x.lsmooth2[p]     :=x.lsmooth[p];
      x.lflick2[p]      :=x.lflick[p];
      x.lflickrate2[p]  :=x.lflickrate[p];

      end;
   end;//p

   end;

//convert from single color set streams of 10+10 to dual stream color sets of 10
scount20:=1;

for p:=1 to high(tlistcolor32) do
begin

//get
if (scount20>=1) and (scount20<=10) then
   begin

   //init
   sp:=p + 10;

   if (sp<=high(tlistcolor32)) then
      begin

      x.elist24b[p]     :=x.elist24[sp];
      x.elist8b [p]     :=x.elist8 [sp];
      x.olist24b[p]     :=x.olist24[sp];
      x.olist8b [p]     :=x.olist8 [sp];

      x.flist2[p]       :=x.flist[sp];
      x.lsmooth2[p]     :=x.lsmooth[sp];
      x.lflick2[p]      :=x.lflick[sp];
      x.lflickrate2[p]  :=x.lflickrate[sp];

      end;

   end;

//inc 20
inc(scount20);
if (scount20>20) then scount20:=1;

end;//p

//successful
result:=true;
skipend:
except;end;
//free
str__free(@a);
end;

function pic8__findcol24(var x:tpiccore8;xval:tcolor24):byte;
var
   p:longint;
   xfound:boolean;

   function c(s,t:longint):boolean;
   begin
   result:=(s>=(t-5)) and (s<=(t+5))
   end;
begin
xfound:=false;

//try an exact match
for p:=0 to high(tlistcolor32) do if (xval.r=x.elist24[p].r) and (xval.g=x.elist24[p].g) and (xval.b=x.elist24[p].b) then
   begin
   result:=p;
   xfound:=true;
   break;
   end;

//try an approximate match
if not xfound then for p:=0 to high(tlistcolor32) do if c(xval.r,x.elist24[p].r) and c(xval.g,x.elist24[p].g) and c(xval.b,x.elist24[p].b) then
   begin
   result:=p;
   xfound:=true;
   break;
   end;

//if all else fails default to 1st color
if not xfound then result:=0;
end;

function pic8__findcol32(var x:tpiccore8;xval:tcolor32):byte;
var
   p:longint;
   xfound:boolean;

   function c(s,t:longint):boolean;
   begin
   result:=(s>=(t-5)) and (s<=(t+5))
   end;
begin
xfound:=false;

//try an exact match
for p:=0 to high(tlistcolor32) do if (xval.r=x.elist24[p].r) and (xval.g=x.elist24[p].g) and (xval.b=x.elist24[p].b) and (xval.a=x.elist8[p]) then
   begin
   result:=p;
   xfound:=true;
   break;
   end;

//try an approximate match
if not xfound then for p:=0 to high(tlistcolor32) do if c(xval.r,x.elist24[p].r) and c(xval.g,x.elist24[p].g) and c(xval.b,x.elist24[p].b) and c(xval.a,x.elist8[p]) then
   begin
   result:=p;
   xfound:=true;
   break;
   end;

//if all else fails default to 1st color
if not xfound then result:=0;
end;

function pic8__addcol24(var x:tpiccore8;var xcount:longint;c24:tcolor24):byte;
begin
result:=pic8__addcol24A(x,xcount,c24,255);
end;

function pic8__addcol32(var x:tpiccore8;var xcount:longint;c32:tcolor32):byte;
var
   c24:tcolor24;
begin
//init
c24.r:=c32.r;
c24.g:=c32.g;
c24.b:=c32.b;

//get
result:=pic8__addcol24A(x,xcount,c24,c32.a);
end;

function pic8__addcol24A(var x:tpiccore8;var xcount:longint;c24:tcolor24;ca8:tcolor8):byte;
var
   p:longint;
   xhave:boolean;

   function c(s,t:longint):boolean;
   begin
   result:=(s>=(t-5)) and (s<=(t+5))
   end;

   procedure xadd(xindex:longint);
   begin
   x.elist24[xindex]:=c24;
   x.elist8 [xindex]:=ca8;
   x.olist24[xindex]:=c24;
   x.olist8 [xindex]:=ca8;
   x.flist[xindex]:=4*5;
   end;
begin
//defaults
xhave:=false;

//find
if (xcount>=1) then
   begin
   //find exact match
   for p:=0 to high(tlistcolor32) do if (c24.r=x.elist24[p].r) and (c24.g=x.elist24[p].g) and (c24.b=x.elist24[p].b) and (ca8=x.elist8[p]) then
      begin
      result:=p;
      xhave:=true;
      break;
      end;//p

   //find approximate match
   if not xhave then for p:=0 to high(tlistcolor32) do if c(c24.r,x.elist24[p].r) and c(c24.g,x.elist24[p].g) and c(c24.b,x.elist24[p].b) and c(ca8,x.elist8[p]) then
      begin
      result:=p;
      xhave:=true;
      break;
      end;//p
   end;

//add
if (not xhave) and (xcount<=high(tlistcolor32)) then
   begin
   result:=xcount;
   xhave:=true;
   xadd(xcount);
   inc(xcount);
   end;

//fallback
if not xhave then result:=0;
end;

function pic8__toimage(var x:tpiccore8;d:tobject):boolean;
label
   skipend;
var
   i,dbits,dx,dy,dw,dh:longint;
   dr32:pcolorrow32;
   dr24:pcolorrow24;
   dr8 :pcolorrow8;
begin
//defaults
result:=false;

//check
if not misok82432(d,dbits,dw,dh) then exit;

try
//init
if not missize(d,x.w,x.h) then goto skipend;

//get
for dy:=0 to (x.h-1) do
begin
if not misscan82432(d,dy,dr8,dr24,dr32) then goto skipend;

//.8
if (dbits=8) then
   begin
   for dx:=0 to (x.w-1) do dr8[dx]:=pic8__pixel(x,dx,dy);//raw pixel index value -> for low level image work -> retains exact pixel information
   end
//.24
else if (dbits=24) then
   begin
   for dx:=0 to (x.w-1) do dr24[dx]:=x.elist24[ pic8__pixel(x,dx,dy) ];
   end
//.32
else if (dbits=32) then
   begin
   for dx:=0 to (x.w-1) do
   begin
   i       :=pic8__pixel(x,dx,dy);
   dr32[dx]:=c24a__c32(x.elist24[ i ], x.elist8[ i ]);
   end;//dx
   end;
end;//sy

//successful
result:=true;
skipend:
except;end;
end;

function pic8__fromimage2(var x:tpiccore8;s:tobject;xAutoScaleToFit:boolean):boolean;
label
   skipend;
var
   a:tbasicimage;
   xsize,sbits,sw,sh,dw,dh:longint;
begin

//defaults
result :=false;
a      :=nil;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;

//init
xsize:=pic8__safewh(max32);


//get
if ((sw<xsize) and (sh<xsize)) or (not xAutoScaleToFit) then
   begin

   a:=misimg32(1,1);
   if not mis__copy(s,a)              then goto skipend;
   if not mis__reducecolors256(a,127) then goto skipend;

   result:=pic8__fromimage(x,a);

   end
else
   begin

   a:=misimg32(1,1);

   low__scaledown(xsize,xsize,sw,sh,dw,dh);
   missize(a,dw,dh);
   mis__cls(a,0,0,0,0);

   result:=mis__copyfast82432(misarea(a),0,0,dw,dh,misarea(s),a,s) and mis__reducecolors256(a,127) and pic8__fromimage(x,a);

   end;

skipend:
except;end;

//free
freeobj(@a);

end;

function pic8__fromimage(var x:tpiccore8;s:tobject):boolean;
label
   skipend;
var
   decount,sbits,sx,sy,sw,sh:longint;
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
begin
//defaults
result:=false;
decount:=1;//always skip over the 1st color -> it's reserved as transparent

//check
if not misok82432(s,sbits,sw,sh) then exit;

try

//range
sw:=pic8__safewh(sw);
sh:=pic8__safewh(sh);

//clear
pic8__clear3(x,sw,sh,sbits<>8);//note: 8bit image retains current color lists, only pixels change

//get
for sy:=0 to (x.h-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;

//.8
if (sbits=8) then
   begin
   for sx:=0 to (x.w-1) do pic8__setpixel(x,sx,sy,sr8[sx]);
   end
//.24
else if (sbits=24) then
   begin
   for sx:=0 to (x.w-1) do pic8__setpixel(x,sx,sy, pic8__addcol24(x,decount,sr24[sx]) );
   end
//.32
else if (sbits=32) then
   begin
   for sx:=0 to (x.w-1) do pic8__setpixel(x,sx,sy, pic8__addcol32(x,decount,sr32[sx]) );
   end;
end;//sy

//successful
result:=true;
skipend:
except;end;
end;

function pic8__findindex(var x:tpiccore8;sx,sy:longint):longint;
begin
if (sy<0) then sy:=0 else if (sy>=x.h) then sy:=x.h-1;
if (sx<0) then sx:=0 else if (sx>=x.w) then sx:=x.w-1;
result:=(sy*x.w)+sx;
end;

function pic8__findxy(var x:tpiccore8;pindex:longint):tpoint;
begin

if (x.pcount<=0) or (pindex<0) or (pindex>=x.pcount) then
   begin
   result.x:=0;
   result.y:=0;
   end
else
   begin
   result.y:=pindex div x.w;
   result.x:=pindex-(result.y*x.w);
   end;

end;

function pic8__size(var x:tpiccore8;nw,nh:longint):boolean;
begin

//range
nw:=pic8__safewh(nw);
nh:=pic8__safewh(nh);

//get
if (nw<>x.w) or (nh<>x.h) then
   begin
   x.w      :=nw;
   x.h      :=nh;
   result   :=true;
   end
else result:=false;

//sync
x.pcount:=x.w * x.h;

end;

function pic8__safecolindex(xindex:longint):longint;
begin
if (xindex<0) then xindex:=0 else if (xindex>high(tlistcolor32)) then xindex:=high(tlistcolor32);
result:=xindex;
end;

function pic8__safesmooth(x:longint):longint;
begin
result:=frcrange32(x,0,1);
end;

function pic8__safeflicker(x:longint):longint;
begin
result:=frcrange32(x,0,100);
end;

function pic8__safebx(var x:tpiccore8;xval:longint):longint;
begin
result:=frcrange32(xval,0,x.w-1);
end;

function pic8__safeby(var x:tpiccore8;xval:longint):longint;
begin
result:=frcrange32(xval,0,x.h-1);
end;

function pic8__safewh(x:longint):longint;
begin
result:=frcrange32(x,1,128);
end;

procedure pic8__fill(var x:tpiccore8;xval:longint);
var
   p:longint;
begin
xval:=frcrange32(xval,0,high(tlistcolor32));
for p:=0 to (x.pcount-1) do x.plist[p]:=xval;
end;

procedure pic8__init(var x:tpiccore8;dw,dh:longint);
begin
pic8__clear3(x,dw,dh,true);
x.dataid   :=0;
x.modified :=false;
x.findex   :=1;
x.bindex   :=0;
x.tlist8REF:=-1;//17jul2025
x.uselist2ForThisColorIndex:=-1;//not using during game mode, only for editing etc - 13jul2025
end;

function pic8__rlist32(var x:tpiccore8;xindex:longint):tcolor32;//15jul205
begin
//range
if (xindex<0) then xindex:=0 else if (xindex>high(tlistcolor32)) then xindex:=high(tlistcolor32);

//get
result.r:=x.rlist24[ xindex ].r;
result.g:=x.rlist24[ xindex ].g;
result.b:=x.rlist24[ xindex ].b;
result.a:=x.rlist8 [ xindex ];
end;

function pic8__getcolor(var x:tpiccore8;xcolindex,xindex03:longint):longint;//32 bit
begin
result:=c32__int(pic8__getcolor32(x,xcolindex,xindex03));
end;

procedure pic8__setcolor(var x:tpiccore8;xcolindex,xindex03:longint;c32:longint);//32 bit
begin
pic8__setcolor32(x,xcolindex,xindex03,int__c32(c32));
end;

function pic8__getcolor32(var x:tpiccore8;xcolindex,xindex03:longint):tcolor32;
begin
//range
if (xcolindex<0) then xcolindex:=0 else if (xcolindex>high(tlistcolor32)) then xcolindex:=high(tlistcolor32);
if (xindex03<0)  then xindex03:=0  else if (xindex03>3)                   then xindex03:=3;

case xindex03 of
1:   result:=c24a__c32( x.olist24[ xcolindex ]  ,x.olist8[ xcolindex ] );
2:   result:=c24a__c32( x.elist24b[ xcolindex ] ,x.elist8b[ xcolindex ] );
3:   result:=c24a__c32( x.olist24b[ xcolindex ] ,x.olist8b[ xcolindex ] );
else result:=c24a__c32( x.elist24[ xcolindex ]  ,x.elist8[ xcolindex ] );
end;//case

end;

procedure pic8__setcolor32(var x:tpiccore8;xcolindex,xindex03:longint;c32:tcolor32);
var
   c24:tcolor24;
begin
//range
if (xcolindex<0) then xcolindex:=0 else if (xcolindex>high(tlistcolor32)) then xcolindex:=high(tlistcolor32);
if (xindex03<0)  then xindex03:=0  else if (xindex03>3)                   then xindex03:=3;

//init
c24.r:=c32.r;
c24.g:=c32.g;
c24.b:=c32.b;

//get
case xindex03 of
1:begin
   x.olist24[ xcolindex ]:=c24;
   x.olist8[ xcolindex ] :=c32.a;
   end;
2:begin
   x.elist24b[ xcolindex ]:=c24;
   x.elist8b[ xcolindex ] :=c32.a;
   end;
3:begin
   x.olist24b[ xcolindex ]:=c24;
   x.olist8b[ xcolindex ] :=c32.a;
   end;
else begin
   x.elist24[ xcolindex ]:=c24;
   x.elist8[ xcolindex ] :=c32.a;
   end;
end;//case

end;

procedure pic8__editlist2(var x:tpiccore8;var flist,lsmooth,lflick,lflickrate:plistval8;xeditlist2:boolean);
begin

case xeditlist2 of
true:begin
   flist       :=@x.flist2;
   lsmooth     :=@x.lsmooth2;
   lflick      :=@x.lflick2;
   lflickrate  :=@x.lflickrate2;
   end;
else begin
   flist       :=@x.flist;
   lsmooth     :=@x.lsmooth;
   lflick      :=@x.lflick;
   lflickrate  :=@x.lflickrate;
   end;
end;//case

end;

procedure pic8__editlist3(var x:tpiccore8;var flist,lsmooth,lflick,lflickrate:plistval8;var elist24,olist24:plistcolor24;var elist8,olist8:plistcolor8;xeditlist2:boolean);
begin

case xeditlist2 of
true:begin
   flist       :=@x.flist2;
   lsmooth     :=@x.lsmooth2;
   lflick      :=@x.lflick2;
   lflickrate  :=@x.lflickrate2;
   elist24     :=@x.elist24b;
   olist24     :=@x.olist24b;
   elist8      :=@x.elist8b;
   olist8      :=@x.olist8b;
   end;
else begin
   flist       :=@x.flist;
   lsmooth     :=@x.lsmooth;
   lflick      :=@x.lflick;
   lflickrate  :=@x.lflickrate;
   elist24     :=@x.elist24;
   olist24     :=@x.olist24;
   elist8      :=@x.elist8;
   olist8      :=@x.olist8;
   end;
end;//case

end;

procedure pic8__changed(var x:tpiccore8);
begin
low__irollone(x.dataid);
x.modified:=true;
end;

procedure pic8__modified(var x:tpiccore8);
begin
x.modified:=true;
end;

procedure pic8__clear(var x:tpiccore8);
begin
pic8__clear3(x,x.w,x.h,true);
end;

procedure pic8__clear2(var x:tpiccore8;dw,dh:longint);
begin
pic8__clear3(x,dw,dh,true);
end;

procedure pic8__clear3(var x:tpiccore8;dw,dh:longint;xmakecolors:boolean);
var
   p:longint;
begin
//dimensions
pic8__size(x,dw,dh);

//progress
for p:=0 to high(x.progress) do x.progress[p]:=0;

//pixels
for p:=0 to (x.pcount-1) do x.plist[p]:=0;//transparent color

//colors
if xmakecolors then pic8__makecolors(x,'');//default color set

//special effects
if xmakecolors then
   begin

   for p:=0 to high(tlistval8) do
   begin
   //note: x.flist[p] is handled via "pic8__makecolors()" proc
   x.lflick[p]      :=0;
   x.lflick2[p]     :=0;
   x.lflickrate[p]  :=0;
   x.lflickrate2[p] :=0;
   x.lsmooth[p]     :=0;
   x.lsmooth2[p]    :=0;
   end;//p

   end;

end;

function pic8__safeflashrate(x:longint):byte;
begin
result:=frcrange32(x,0,high(game_flashlist));
end;

procedure pic8__makecolors(var x:tpiccore8;n:string);
label
   doDefault,skipend;
var
   p,dcount:longint;

   procedure d32(e_r,e_g,e_b,e_a, o_r,o_g,o_b,o_a:byte;xflashrate:longint);
   begin

   if (dcount<=high(tlistcolor32)) then
      begin
      //static 1
      x.elist24[dcount].r  :=e_r;//16jul2025
      x.elist24[dcount].g  :=e_g;
      x.elist24[dcount].b  :=e_b;
      x.elist8 [dcount]    :=e_a;

      //flash 1
      x.olist24[dcount].r  :=o_r;//16jul2025
      x.olist24[dcount].g  :=o_g;
      x.olist24[dcount].b  :=o_b;
      x.olist8 [dcount]    :=o_a;

      //alt1 - static 2
      x.elist24b[dcount]   :=x.elist24[dcount];
      x.elist8b [dcount]   :=x.elist8[dcount];

      //alt2 - flash 2
      x.olist24b[dcount]   :=x.olist24[dcount];
      x.olist8b[dcount]    :=x.olist8[dcount];

      //flash rate
      x.flist[dcount]    :=pic8__safeflashrate(xflashrate);
      x.flist2[dcount]   :=x.flist[dcount];

      //inc
      inc(dcount);
      end;

   end;

   procedure sa(r,g,b:byte);//static
   begin
   d32(r,g,b,255, r,g,b,255, 0);
   end;

   procedure sa1(r,g,b,a:byte);//static
   begin
   d32(r,g,b,a, r,g,b,255, a);
   end;

   procedure se(r,g,b:byte);//flash even
   begin
   d32(r,g,b,255, r div 2,g div 2,b div 2,255, 5);
   end;

   procedure so(r,g,b:byte);//flash odd
   begin
   d32(r div 2,g div 2,b div 2,255, r,g,b,255, 5);
   end;
begin
//init
dcount :=0;
n      :=strlow(n);

//decide
if (n='xxxxx') then
   begin

   goto doDefault;
   end
else goto doDefault;


//default colors ---------------------------------------------------------------
doDefault:

//transparent - static -> regardless of r,g,b values this color is always considered FULLY transparent
sa1(255,255,255,0);

//blue
sa(0,0,64);
sa(0,0,128);
sa(0,0,192);
sa(0,0,255);

//green
sa(0,64,0);
sa(0,128,0);
sa(0,192,0);
sa(0,255,0);

//aqua
sa(0,64,64);
sa(0,128,128);
sa(0,192,192);
sa(0,255,255);

//yellow
sa(64,64,0);
sa(128,128,0);
sa(192,192,0);
sa(255,255,0);

//brown
sa(64,32,0);
sa(128,64,0);
sa(192,96,0);
sa(255,128,0);

//pink
sa(64,0,64);
sa(128,0,128);
sa(192,0,192);
sa(255,0,255);

//orange-red
sa(100,0,0);
sa(175,37,0);
sa(255,88,0);
sa(255,0,0);

//grey
sa(0,0,0);
sa(64,64,64);
sa(128,128,128);
sa(192,192,192);
sa(255,255,255);

//flash even colors
se(0,0,255);
se(0,255,0);
se(0,255,255);
se(255,255,0);
se(255,255,255);
se(255,128,0);
se(255,0,255);
se(255,0,0);

//flash odd colors
so(0,0,255);
so(0,255,0);
so(0,255,255);
so(255,255,0);
so(255,255,255);
so(255,128,0);
so(255,0,255);
so(255,0,0);


skipend:

//remainder of colors set to black
for p:=dcount to 255 do sa(0,0,0);

end;

function pic8__setflash(var x:tpiccore8;xindex,xfps:longint):boolean;
begin
if (xindex>=0) and (xindex<=high(tlistcolor32)) then
   begin
   xfps:=pic8__safeflashrate(xfps);
   if (x.flist[xindex]<>xfps) then
      begin
      x.flist[xindex]:=xfps;
      pic8__changed(x);
      result:=true;
      end
   else result:=false;
   end
else result:=false;
end;

function pic8__pval(var x:tpiccore8;xindex:longint):longint;
begin
if (xindex>=0) and (xindex<x.pcount) then result:=x.plist[xindex] else result:=0;
end;

function pic8__setpval(var x:tpiccore8;xindex,xval:longint):boolean;
begin
//range
if (xval<0) then xval:=0 else if (xval>high(tlistcolor32)) then xval:=high(tlistcolor32);

//set
result:=(xindex>=0) and (xindex<x.pcount) and (x.plist[xindex]<>xval);
if result then
   begin
   x.plist[xindex]:=xval;
   pic8__changed(x);
   end;
end;

function pic8__incpval(var x:tpiccore8;xindex,xby:longint):boolean;
begin
result:=pic8__setpval(x,xindex, frcrange32(pic8__pval(x,xindex)+xby,0,high(tlistcolor32)) );
end;

function pic8__pixel(var x:tpiccore8;sx,sy:longint):longint;
begin
if (sy<0) then sy:=0 else if (sy>=x.h) then sy:=x.h-1;
if (sx<0) then sx:=0 else if (sx>=x.w) then sx:=x.w-1;
result:=pic8__pval(x,(sy*x.w)+sx);
end;

function pic8__setpixel(var x:tpiccore8;sx,sy,xval:longint):boolean;
begin
if (sy<0) then sy:=0 else if (sy>=x.h) then sy:=x.h-1;
if (sx<0) then sx:=0 else if (sx>=x.w) then sx:=x.w-1;
result:=pic8__setpval(x,(sy*x.w)+sx,xval);
end;

procedure pic8__drawfast(var x:tdrawfastinfo);
begin
//defaults
game_drawproc_id :=-1;

//check
if (x.clip.left<0) or (x.clip.right<x.clip.left) or (x.clip.top<0) or (x.clip.bottom<x.clip.top) or (x.rs24=nil) or (x.core=nil) then exit;

//range
if (x.power255<=0)  then exit          else if (x.power255>255)  then x.power255:=255;
if (x.xzoom<1)      then x.xzoom:=1    else if (x.xzoom>pic8_zoomlimit)  then x.xzoom:=pic8_zoomlimit;
if (x.yzoom<1)      then x.yzoom:=1    else if (x.yzoom>pic8_zoomlimit)  then x.yzoom:=pic8_zoomlimit;

//image within clip area
if (x.x>=x.clip.left) and ((x.x+(x.xzoom*x.core.w)-1)<=x.clip.right) and (x.y>=x.clip.top) and ((x.y+(x.yzoom*x.core.h)-1)<=x.clip.bottom) then
   begin

   //no clip range check
   if      (x.xzoom=1) and (x.yzoom=1) and (not x.mirror) then xpic8__drawfast0__power255_flip(x,x.core^)
   else if (x.xzoom=1) and (x.yzoom=1)                    then xpic8__drawfast1__power255_flip_mirror(x,x.core^)
   else                                                        xpic8__drawfast21__power255_flip_mirror_zoom_cliprange(x,x.core^);

   end
else
   begin

   //clip range check
   if (x.xzoom=1) and (x.yzoom=1) then xpic8__drawfast11__power255_flip_mirror_cliprange(x,x.core^)
   else                                xpic8__drawfast21__power255_flip_mirror_zoom_cliprange(x,x.core^);

   end;

//inc
game_pixelcount:=game_pixelcount + ((x.core.w*x.core.h*x.xzoom*x.yzoom)/1000000);//millions of pixels

inc(game_spritedrawcount);

end;

procedure xpic8__drawfast0__power255_flip(var x:tdrawfastinfo;var xcore:tpiccore8);//17jul2025
label//Note: no clip range checking -> info set by calling proc
   //--------------------------------------------------------------------------------+
   // Peak draw speed for Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz                   |
   //---------------+--------------------+-------------------+-----------------------+
   // image size    | normal             | alpha blending    | frame buffer          |
   //---------------+--------------------+-------------------+-----------------------+
   //  32 x 32      | 320 mps / 154 fps  | 130 mps / 62 fps  | 1920 x 1080 @ 24 bit  |
   //  64 x 64      | 325 mps / 156 fps  | 150 mps / 72 fps  | 1920 x 1080 @ 24 bit  |
   // 128 x 128     | 340 mps / 164 fps  | 162 mps / 78 fps  | 1920 x 1080 @ 24 bit  |
   //---------------+--------------------+-------------------+-----------------------+
   // mps = millions of pixels per second, fps = frames per second
   yredo,xredo,xskip;
var
   crs24:pcolorrows24;
   cainv,ca,p,x1,x2,y1,y2,xstop,ystop,pindex,xreset,yreset,yindex,ax,ay,yshift:longint;
   v24:pcolor24;
begin
//no checks -> all critical checks have been performed by calling proc

//init
game_drawproc_id :=0;
x1               :=x.x;
x2               :=x1 + xcore.w - 1;
y1               :=x.y;
y2               :=y1 + xcore.h - 1;
crs24            :=x.rs24;

//.y
if x.flip then
   begin
   yshift :=-1;
   yreset :=y2;
   ystop  :=y1;
   ay     :=y2;
   yindex :=(xcore.h-1) * xcore.w;
   end
else
   begin
   yshift :=1;
   yreset :=y1;
   ystop  :=y2;
   ay     :=y1;
   yindex :=0;
   end;

//.x
xreset :=x1;
xstop  :=x2;

//.rlist
if (xcore.tlist8REF<>x.power255) then
   begin

   //reset
   xcore.tlist8REF:=x.power255;

   //get
   case (x.power255>=255) of
   true:for p:=0 to high(xcore.rlist8) do xcore.tlist8[p]:=xcore.rlist8[p];
   else for p:=0 to high(xcore.rlist8) do xcore.tlist8[p]:=( xcore.rlist8[p] * x.power255 ) div 256;//slight rounding error but faster than "div 255"
   end;//case

   end;//if

//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//init
ay     :=yreset;
yindex :=0;

//y
yredo:

//x
ax     :=xreset;
pindex :=yindex;

//loop
xredo:

ca    :=xcore.tlist8[ xcore.plist[ pindex ] ];

if (ca=0) then goto xskip;//18jul2025

if (ca=255) then crs24[ay][ax]:=xcore.rlist24[ xcore.plist[ pindex ] ]
else
   begin

   cainv :=255-ca;
   v24   :=@crs24[ay][ax];
   v24.r :=( (cainv*v24.r) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].r) ) div 256;
   v24.g :=( (cainv*v24.g) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].g) ) div 256;
   v24.b :=( (cainv*v24.b) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].b) ) div 256;

   end;

//inc x
xskip:
if (ax<>xstop) then
   begin

   //next color pixel index
   inc(pindex);

   //next x pixel
   inc(ax);
   goto xredo;

   end;

//inc y
if (ay<>ystop) then
   begin

   //next color row -> color pixel index
   inc(yindex,xcore.w);

   //next y row
   inc(ay,yshift);
   goto yredo;

   end;

end;

procedure xpic8__drawfast1__power255_flip_mirror(var x:tdrawfastinfo;var xcore:tpiccore8);//17jul2025
label//Note: no clip range checking -> info set by calling proc
   //--------------------------------------------------------------------------------+
   // Peak draw speed for Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz                   |
   //---------------+--------------------+-------------------+-----------------------+
   // image size    | normal             | alpha             | frame buffer          |
   //---------------+--------------------+-------------------+-----------------------+
   //  32 x 32      | 315 mps / 152 fps  | 130 mps / 62 fps  | 1920 x 1080 @ 24 bit  |
   //  64 x 64      | 325 mps / 156 fps  | 147 mps / 71 fps  | 1920 x 1080 @ 24 bit  |
   // 128 x 128     | 342 mps / 165 fps  | 159 mps / 76 fps  | 1920 x 1080 @ 24 bit  |
   //---------------+--------------------+-------------------+-----------------------+
   // mps = millions of pixels per second, fps = frames per second
   yredo,xredo,xskip;
var
   crs24:pcolorrows24;
   cainv,ca,p,x1,x2,y1,y2,xstop,ystop,pindex,xreset,yreset,yindex,ax,ay,xshift,yshift:longint;
   v24:pcolor24;
begin
//no checks -> all critical checks have been performed by calling proc

//init
game_drawproc_id :=1;
x1               :=x.x;
x2               :=x1 + xcore.w - 1;
y1               :=x.y;
y2               :=y1 + xcore.h - 1;
crs24            :=x.rs24;

//.y
if x.flip then
   begin
   yshift :=-1;
   yreset :=y2;
   ystop  :=y1;
   ay     :=y2;
   yindex :=(xcore.h-1) * xcore.w;
   end
else
   begin
   yshift :=1;
   yreset :=y1;
   ystop  :=y2;
   ay     :=y1;
   yindex :=0;
   end;

//.x
if x.mirror then
   begin
   xshift :=-1;
   xreset :=x2;
   xstop  :=x1;
   end
else
   begin
   xshift :=1;
   xreset :=x1;
   xstop  :=x2;
   end;

//.rlist
if (xcore.tlist8REF<>x.power255) then
   begin

   //reset
   xcore.tlist8REF:=x.power255;

   //get
   case (x.power255>=255) of
   true:for p:=0 to high(xcore.rlist8) do xcore.tlist8[p]:=xcore.rlist8[p];
   else for p:=0 to high(xcore.rlist8) do xcore.tlist8[p]:=( xcore.rlist8[p] * x.power255 ) div 256;//slight rounding error but faster than "div 255"
   end;//case

   end;//if

//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//init
ay     :=yreset;
yindex :=0;

//y
yredo:

//x
ax     :=xreset;
pindex :=yindex;

//loop
xredo:

ca    :=xcore.tlist8[ xcore.plist[ pindex ] ];

if (ca=0) then goto xskip;//18jul2025

if (ca=255) then crs24[ay][ax]:=xcore.rlist24[ xcore.plist[ pindex ] ]
else
   begin

   cainv :=255-ca;
   v24   :=@crs24[ay][ax];
   v24.r :=( (cainv*v24.r) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].r) ) div 256;
   v24.g :=( (cainv*v24.g) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].g) ) div 256;
   v24.b :=( (cainv*v24.b) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].b) ) div 256;

   end;

//inc x
xskip:
if (ax<>xstop) then
   begin

   //next color pixel index
   inc(pindex);

   //next x pixel
   inc(ax,xshift);
   goto xredo;

   end;

//inc y
if (ay<>ystop) then
   begin

   //next color row -> color pixel index
   inc(yindex,xcore.w);

   //next y row
   inc(ay,yshift);
   goto yredo;

   end;

end;

procedure xpic8__drawfast11__power255_flip_mirror_cliprange(var x:tdrawfastinfo;var xcore:tpiccore8);//17jul2025
label
   //--------------------------------------------------------------------------------+
   // Peak draw speed for Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz                   |
   //---------------+--------------------+-------------------+-----------------------+
   // image size    | normal             | alpha             | frame buffer          |
   //---------------+--------------------+-------------------+-----------------------+
   //  32 x 32      | 259 mps / 125 fps  | 130 mps / 62 fps  | 1920 x 1080 @ 24 bit  |
   //  64 x 64      | 257 mps / 124 fps  | 136 mps / 65 fps  | 1920 x 1080 @ 24 bit  |
   // 128 x 128     | 263 mps / 127 fps  | 137 mps / 66 fps  | 1920 x 1080 @ 24 bit  |
   //---------------+--------------------+-------------------+-----------------------+
   // mps = millions of pixels per second, fps = frames per second
   // Note: draw times decrease as more of the image falls outside the clip area
   yredo,xredo,yskip,xskip;
var
   cclip:twinrect;
   crs24:pcolorrows24;
   cainv,ca,p,x1,x2,y1,y2,xstop,ystop,pindex,xreset,yreset,yindex,ax,ay,xshift,yshift:longint;
   v24:pcolor24;
begin
//defaults
game_drawproc_id :=11;

//clip check
if ((x.y+xcore.h-1)<x.clip.top) or (x.y>x.clip.bottom) or ((x.x+xcore.w-1)<x.clip.left) or (x.x>x.clip.right) then exit;

//init
x1               :=x.x;
x2               :=x1 + xcore.w - 1;
y1               :=x.y;
y2               :=y1 + xcore.h - 1;
cclip            :=x.clip;
crs24            :=x.rs24;

//.y
if x.flip then
   begin
   yshift :=-1;
   yreset :=y2;
   ystop  :=y1;
   ay     :=y2;
   yindex :=(xcore.h-1) * xcore.w;
   end
else
   begin
   yshift :=1;
   yreset :=y1;
   ystop  :=y2;
   ay     :=y1;
   yindex :=0;
   end;

//.x
if x.mirror then
   begin
   xshift :=-1;
   xreset :=x2;
   xstop  :=x1;
   end
else
   begin
   xshift :=1;
   xreset :=x1;
   xstop  :=x2;
   end;

//.rlist
if (xcore.tlist8REF<>x.power255) then
   begin

   //reset
   xcore.tlist8REF:=x.power255;

   //get
   case (x.power255>=255) of
   true:for p:=0 to high(xcore.rlist8) do xcore.tlist8[p]:=xcore.rlist8[p];
   else for p:=0 to high(xcore.rlist8) do xcore.tlist8[p]:=( xcore.rlist8[p] * x.power255 ) div 256;//slight rounding error but faster than "div 255"
   end;//case

   end;//if

//------------------------------------------------------------------------------
//draw pixels ------------------------------------------------------------------

//init
ay     :=yreset;
yindex :=0;

//y
yredo:
if (ay<cclip.top) or (ay>cclip.bottom) then goto yskip;

//x
ax     :=xreset;
pindex :=yindex;

//loop
xredo:
if (ax<cclip.left) or (ax>cclip.right) then goto xskip;

ca    :=xcore.tlist8[ xcore.plist[ pindex ] ];

if (ca=0) then goto xskip;//18jul2025

if (ca=255) then crs24[ay][ax]:=xcore.rlist24[ xcore.plist[ pindex ] ]
else
   begin

   cainv :=255-ca;
   v24   :=@crs24[ay][ax];
   v24.r :=( (cainv*v24.r) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].r) ) div 256;
   v24.g :=( (cainv*v24.g) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].g) ) div 256;
   v24.b :=( (cainv*v24.b) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].b) ) div 256;

   end;

//inc x
xskip:
if (ax<>xstop) then
   begin

   //next color pixel index
   inc(pindex);

   //next x pixel
   inc(ax,xshift);
   goto xredo;

   end;

//inc y
yskip:
if (ay<>ystop) then
   begin

   //next color row -> color pixel index
   inc(yindex,xcore.w);

   //next y row
   inc(ay,yshift);
   goto yredo;

   end;

end;

procedure xpic8__drawfast21__power255_flip_mirror_zoom_cliprange(var x:tdrawfastinfo;var xcore:tpiccore8);//17jul2025
label
   //---------------------------------------------------------------------------------------+
   // Peak draw speed for Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz                          |
   //------+---------------+--------------------+-------------------+-----------------------+
   // zoom | image size    | zoom only          | alpha + zoom      | frame buffer          |
   //------+---------------+--------------------+-------------------+-----------------------+
   //  2x  |  32 x 32      | 259 mps / 124 fps  | 160 mps /  77 fps | 1920 x 1080 @ 24 bit  |
   //  2x  |  64 x 64      | 279 mps / 134 fps  | 166 mps /  80 fps | 1920 x 1080 @ 24 bit  |
   //  2x  | 128 x 128     | 295 mps / 142 fps  | 177 mps /  85 fps | 1920 x 1080 @ 24 bit  |
   //------+---------------+--------------------+-------------------+-----------------------+
   //  4x  |  32 x 32      | 290 mps / 140 fps  | 171 mps /  82 fps | 1920 x 1080 @ 24 bit  |
   //  4x  |  64 x 64      | 312 mps / 150 fps  | 185 mps /  89 fps | 1920 x 1080 @ 24 bit  |
   //  4x  | 128 x 128     | 359 mps / 173 fps  | 205 mps /  99 fps | 1920 x 1080 @ 24 bit  |
   //------+---------------+--------------------+-------------------+-----------------------+
   // mps = millions of pixels per second, fps = frames per second
   yredo,xredo,xskip,yskip;
var
   cclip:twinrect;
   crs24:pcolorrows24;
   cainv,ca,p,x1,x2,y1,y2,xstop,ystop,pindex,xreset,yreset,yindex,ax,ay,xshift,yshift,xcount,ycount,xsize,ysize:longint;
   v24:pcolor24;
begin
//defaults
game_drawproc_id :=21;

//clip check
if ((x.y+(x.yzoom*xcore.h)-1)<x.clip.top) or (x.y>x.clip.bottom) or ((x.x+(x.xzoom*xcore.w)-1)<x.clip.left) or (x.x>x.clip.right) then exit;

//init
xsize            :=x.xzoom;
ysize            :=x.yzoom;
x1               :=x.x;
x2               :=x1 + (xcore.w*xsize) - 1;
y1               :=x.y;
y2               :=y1 + (xcore.h*ysize) - 1;
crs24            :=x.rs24;
cclip            :=x.clip;

//.y
if x.flip then
   begin
   yshift :=-1;
   yreset :=y2;
   ystop  :=y1;
   ay     :=y2;
   yindex :=(xcore.h-1) * xcore.w;
   end
else
   begin
   yshift :=1;
   yreset :=y1;
   ystop  :=y2;
   ay     :=y1;
   yindex :=0;
   end;

//.x
if x.mirror then
   begin
   xshift :=-1;
   xreset :=x2;
   xstop  :=x1;
   end
else
   begin
   xshift :=1;
   xreset :=x1;
   xstop  :=x2;
   end;

//.rlist
if (xcore.tlist8REF<>x.power255) then
   begin

   //reset
   xcore.tlist8REF:=x.power255;

   //get
   case (x.power255>=255) of
   true:for p:=0 to high(xcore.rlist8) do xcore.tlist8[p]:=xcore.rlist8[p];
   else for p:=0 to high(xcore.rlist8) do xcore.tlist8[p]:=( xcore.rlist8[p] * x.power255 ) div 256;//slight rounding error but faster than "div 255"
   end;//case

   end;//if

//------------------------------------------------------------------------------
//draw pixels - zoom -----------------------------------------------------------

//init
ay     :=yreset;
ycount :=0;
yindex :=0;

//y
yredo:
if (ay<cclip.top) or (ay>cclip.bottom) then goto yskip;

//x
ax     :=xreset;
xcount :=0;
pindex :=yindex;
ca     :=xcore.tlist8[ xcore.plist[ pindex ] ];

//loop
xredo:
if (ax<cclip.left) or (ax>cclip.right) then goto xskip;

if (ca=0) then goto xskip;//18jul2025

if (ca=255) then crs24[ay][ax]:=xcore.rlist24[ xcore.plist[ pindex ] ]
else
   begin

   cainv :=255-ca;
   v24   :=@crs24[ay][ax];
   v24.r :=( (cainv*v24.r) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].r) ) div 256;
   v24.g :=( (cainv*v24.g) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].g) ) div 256;
   v24.b :=( (cainv*v24.b) + (ca*xcore.rlist24[ xcore.plist[ pindex ] ].b) ) div 256;

   end;

//inc x
xskip:
if (ax<>xstop) then
   begin

   //inc zoom step
   inc(xcount);
   if (xcount>=xsize) then
      begin

      //reset
      xcount :=0;

      //next color
      inc(pindex);
      ca     :=xcore.tlist8[ xcore.plist[ pindex ] ];

      end;

   //next x pixel
   inc(ax,xshift);
   goto xredo;

   end;

//inc y
yskip:
if (ay<>ystop) then
   begin

   //inc zoom step
   inc(ycount);
   if (ycount>=ysize) then
      begin
      ycount:=0;
      inc(yindex,xcore.w);
      end;

   //next y row
   inc(ay,yshift);
   goto yredo;

   end;

end;


//## tgameinfo #################################################################
constructor tgameinfo.create(xgui:tbasicsystem);
begin

//self
track__inc(satOther,1);
inherited create;

//vars
fonpaint                     :=nil;
fondefaultLayout_keyboard    :=nil;
fondefaultLayout_mouse       :=nil;

//check
case (xgui<>nil) of
true:igui:=xgui;
else showerror('Invalid gui for "tgameinfo.create()"');
end;//case

//setup gamemode and connect key procs
gui.gamemode__cansize    :=true;
gui.gamemode__canmove    :=true;
gui.gamemode__onpaint    :=_onpaint;
gui.gamemode__onnotify   :=_onnotify;
gui.gamemode__onkey      :=_onkey;
gui.gamemode__onmouse    :=_onmouse;
gui.gamemode__onshortcut :=_onshortcut;

end;

destructor tgameinfo.destroy;
begin
try
//disconnect
gui.gamemode__onpaint    :=nil;
gui.gamemode__onnotify   :=nil;
gui.gamemode__onkey      :=nil;
gui.gamemode__onmouse    :=nil;
gui.gamemode__onshortcut :=nil;

//self
inherited destroy;
track__inc(satOther,-1);
except;end;
end;

procedure tgameinfo._ontimer(sender:tobject);
begin

xgame__timer(sender);
xmouse_scaleChangeCheck;

end;

procedure tgameinfo._onpaint(sender:tobject);
begin
if assigned(fonpaint) then fonpaint(sender);
end;

function tgameinfo._onnotify(sender:tobject):boolean;
begin
result:=true;//handled
end;

procedure tgameinfo._onkey(sender:tobject;xrawkey:longint;xdown:boolean);
begin
xbox__keyrawinput(xrawkey,xdown);
end;

procedure tgameinfo.xmouse_scaleChangeCheck;
begin

if (game_cursorinfo.right<>game_bufferwidth) or (game_cursorinfo.bottom<>game_bufferheight) then
   begin

   game_cursorinfo.left   :=frcrange32( round( (game_cursorinfo.left/game_cursorinfo.right) * game_bufferwidth) ,0,game_bufferwidth-1);
   game_cursorinfo.top    :=frcrange32( round( (game_cursorinfo.top/game_cursorinfo.bottom) * game_bufferheight) ,0,game_bufferheight-1);
   game_cursorinfo.right  :=game_bufferwidth;
   game_cursorinfo.bottom :=game_bufferheight;

   end;

end;

procedure tgameinfo._onmouse(sender:tobject;xmode,xbuttonstyle,dx,dy,dw,dh:longint);
var
   ox,oy,v,p:longint;
   rx,ry:double;

   function xcanprev:boolean;
   begin
   result:=area__within(game_menu.prevarea,game_cursorinfo.left,game_cursorinfo.top);
   end;

   function xcannext:boolean;
   begin
   result:=area__within(game_menu.nextarea,game_cursorinfo.left,game_cursorinfo.top);
   end;

begin

//original
ox                :=dx;
oy                :=dy;

//range
dx                :=frcrange32(dx-game_screenarea.left,0,game_screenarea.right-game_screenarea.left);
dy                :=frcrange32(dy-game_screenarea.top ,0,game_screenarea.bottom-game_screenarea.top);

//scale mouse coordinates to game_buffer
rx                :=frcranged64( dx/frcmin32(game_screenarea.right-game_screenarea.left+1,1) ,0,1);
dx                :=frcrange32( round( rx * game_bufferwidth ) ,0,game_bufferwidth-1);

ry                :=frcranged64( dy/frcmin32(game_screenarea.bottom-game_screenarea.top+1,1) ,0,1);
dy                :=frcrange32( round( ry * game_bufferheight ) ,0,game_bufferheight-1);


//get
game_cursorinfo.left   :=dx;
game_cursorinfo.top    :=dy;
game_cursorinfo.right  :=game_bufferwidth;
game_cursorinfo.bottom :=game_bufferheight;
game_cursoractive      :=ms64+5000;

xbox__mouserawinput(sender,xmode,xbuttonstyle,dx,dy,game_bufferwidth,game_bufferheight);

//mouse hover and click
if game__menushowing and (game_menu.menu.count>=1) then
   begin

   //hover index
   if low__setstr(game_cursormoveref,intstr32(ox div 5)+'|'+intstr32(oy div 5)) then
      begin

      v:=-1;

      for p:=0 to (game_menu.menu.count-1) do if area__within(game_menu.menu.items[p].area,game_cursorinfo.left,game_cursorinfo.top) then
         begin

         v:=p;
         break;

         end;//p

      //.prev or next page highlight codes
      if (v<=-1) then
         begin

         if      xcanprev then v:=-100
         else if xcannext then v:=-101;

         end;

      //get
      if low__setint(game_cursorhoverindex,v) then game__menuaction(gmaMousehover);

      end;

   //click => mouse up
   if (xmode=2) then
      begin

      if (xbuttonstyle=abLeft) then
         begin

         case (game_cursorhoverindex>=0) of
         true:game__menuaction(gmaMouseSelect);
         else
            begin

            //prev page
            if      xcanprev then game__menuaction(gmaPrevpage)

            //next page
            else if xcannext then game__menuaction(gmaNextpage)

            //back
            else                  game__menuaction(gmaBack);

            end;

         end;//case

         end
      else if (xbuttonstyle=abRight) then
         begin

         case (game_cursorhoverindex>=0) of
         true:game__menuaction(gmaRight);
         end;//case

         end;

      end;

   end;

end;

function tgameinfo._onshortcut(sender:tobject):boolean;
begin
result:=true;//handled
end;

function game__cursoractive:boolean;
begin
result:=(game_cursoractive>=ms64);
end;

function game__cursoractive2(var x2000msorless:longint):boolean;
begin

result:=(game_cursoractive>=ms64);

case result of
true:x2000msorless:=frcrange32( sub32(game_cursoractive,ms64) ,0,2000);
else x2000msorless:=0;
end;//case

end;

procedure game__cursor__makeinactive;
begin
game_cursoractive:=sub64(ms64,1);
end;

procedure game__setcursorpower255(x:longint);
begin
game_cursorpower255:=frcrange32(x,20,255);
end;

function game__cursorpower255:longint;
begin
result:=game_cursorpower255;
end;


//## tpic8 #####################################################################
constructor tpic8.create;
begin
track__inc(satOther,1);
inherited create;

end;

destructor tpic8.destroy;
begin
try

//self
inherited destroy;
track__inc(satOther,-1);
except;end;
end;


//## tpal8 #####################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxx//ppppppppppppppppppppp
constructor tpal8.create(xparent:tobject;xhost:tobject;xcore:ppiccore8);
begin
create2(xparent,xhost,xcore,true);
end;

constructor tpal8.create2(xparent:tobject;xhost:tobject;xcore:ppiccore8;xstart:boolean);

   function t(x:array of byte):longint;
   begin
   result:=tep__addone20c(1,x)
   end;

   procedure mevents(m:tsimpleint);
   begin

   if (m<>nil) then
      begin
      m.onfindlabel    :=xscreen__oncaption;
      m.onclicklabel   :=xscreen__onclick;
      m.onreadwriteval :=xscreen__onreadwriteval;
      m.oncommitvalue  :=xscreen__oncommitval;
      end;

   end;
begin
//self
track__inc(satOther,1);
inherited create2(xparent,false,false);

//do not scroll the client area
noscroll;

//vars
oautoheight           :=true;
ocanshowmenu          :=true;
bordersize            :=0;
ifasttimer            :=0;
itimer250             :=0;
iscrollidleref        :=ms64;//required
iprogresschangedref   :=false;
ilastcommitref        :=nil;
ionefps               :=8;//8 steps per fps
ispacecount           :=high(tprogresslist)+2;//allow gaps between sets of colors
ilist.count           :=0;
iscrollspeed          :=0;
ishiftscrollx         :=0;
ilastscrollx          :=0;
iscrollx              :=0;
iscrollto             :=min32;//0ff
iscrollprevx          :=min32;//pff
iscrolltime           :=0;
idownscrollx          :=0;
iupdateprevwhenidle   :=false;
iscrollnotidle_scrollx:=min32;//off
ifindfb               :=true;
icolorindex03         :=0;//range 0..3 -> each color index has 4 colors
icolorsetsheader      :='colorsets:';//14jul2025
icolorindex03REF      :=0;

low__cls(@ireflist24,sizeof(ireflist24));
low__cls(@ireflist8,sizeof(ireflist8));

if (xhost<>nil) and (xhost is ttex) then ihost:=xhost else ihost:=nil;

icore          :=xcore;
if (icore=nil) then showerror('Piccore8 not set in tpal8.create()');

icellhoverindex:=-1;
icellindex     :=-1;
ilastcellindex :=-1;

iref           :='';

//screen
iscreen:=client.ncontrol;
iscreen.oautoheight:=true;
iscreen.visible:=true;

//controls
with xhigh do
begin

//column 0
xcols.makeautoheight;

with xcols.makecol(0,10,false) do
begin
iprogresscontrol:=mint('','Progression Input|Progression range is 0 to 100%.  As progression shifts toward 100%, Static and Flash colors switch to Alt 1 and Alt 2 colors.  Use an Xbox controller '+'to adjust progression in realtime, or, input an manual progression value by shifting the slider.',0,10,0,0);
end;

with xcols.makecol(1,14,false) do
begin
iflicker:=mint('','Flicker Rate|Set flicker flash rate for the Foreground color.  Set a high value for a fast and frequent flicker, or, a lower one for a more intermittent, less obvious flicker.  Set to zero for a realtime, ultra-fast flicker.',0,30*8,0,0);
end;

with xcols.makecol(2,11,false) do
begin
iflickerpert:=mint('','Flicker Strength|Rapidly switch between Static and Flash or Alt 1 and Alt 2 colors for a flicker effect of the Foreground color.  Set a high % value for greater Flash / Alt 2 color influence, or, lower it for a more subtle flicker.',0,100,0,0);
end;

with xcols.makecol(3,16,false) do
begin
iflash:=mintb('','Flash Style|Toggle between normal and smooth flash styles','Flash Rate|Set flash rate of Foreground color between 0 (off) and 30 fps | Color alternates between Static and Flash or Alt 1 and Alt 2 colors',0,30*8,0,0);
end;

itoolbar:=xcols.makecol(4,76,false).xhigh.xtoolbar;
with itoolbar do
begin
normal:=true;
halign:=0;
add('Static',tepColorPal20n,0,'edit.color1','Foreground Color|Select to show Static + Flash colors|Select again to edit Static color|1st color "T" is transparent and can''t be edited');
add('Flash',tepColorPal20n,0,'edit.color2','Foreground Color|Select to show Static + Flash colors|Select again to edit Flash color|1st color "T" is transparent and can''t be edited');

add('Alt 1',tepColorPal20n,0,'edit.color3','Foreground Color|Select to show Alt 1 + Alt 2 colors|Select again to edit Alt 1 color|1st color "T" is transparent and can''t be edited');
add('Alt 2',tepColorPal20n,0,'edit.color4','Foreground Color|Select to show Alt 1 + Alt 2 colors|Select again to edit Alt 2 color|1st color "T" is transparent and can''t be edited');

add('Menu',tepMenu20,0,'color.menu','Color|Show color menu');
add('Swap',tepSwap20,0,'color.swapfb','Color|Swap Foreground and Background colors');

add('Copy',tepcopy20,0,'color.copy','Foreground Color|Copy Foreground color to Clipboard');
add('Paste',teppaste20,0,'color.paste','Foreground Color|Paste Foreground color from Clipboard');
add('Paste+1',teppaste20,0,'color.paste+1','Foreground Color|Paste Foreground color from Clipboard and move to next color');

add('Find',tepZoom20,0,'scroll.findfb','Position|Find Foreground or Background color - alternates between searches.  Keyboard shortcut: Ctrl + F or Ctrl +B');
//add('No Effects',tepClose20,0,'color.noeffects','Color|Turn off effects for color');

add('Previous',tepRefresh20,0,'scroll.prev','Position|Scroll to previous color palette location');
add('Home',tepPrev20,0,'scroll.home','Position|Scroll to beginning of color palette');
add('End',tepNext20,0,'scroll.end','Position|Scroll to end of color palette');

end;//case


end;//high


//add cells
xaddcells;


//events
iscreen.onpaint   :=xscreen__onpaint;
iscreen.onnotify  :=xscreen__onnotify;

//.flashrate
mevents(iflash);
mevents(iflicker);
mevents(iflickerpert);

mevents(iprogresscontrol);
iprogresscontrol.onreadwriteval:=nil;

itoolbar.onclick:=xscreen__onclick2;

//.host
if (ihost<>nil) then (ihost as ttex).onpreUndoredo:=xscreen__preundoredo;


//start
if xstart then start;
end;

destructor tpal8.destroy;
begin
try

inherited destroy;
track__inc(satOther,-1);
except;end;
end;

procedure tpal8.showmenuFill(xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
var
   m:tstr8;//pointer only
   fi:longint;
   dsetindex:longint;
   dcanedit,xok,xcanpastetext,bol1,fok:boolean;
begin
try
//check
if (icore=nil) or (ihost=nil) then exit;
if zznil(xmenudata,2325)      then exit else m:=xmenudata;
xmenuname  :='pal.menu';

//init
xok        :=not (ihost as ttex).locked;
findex(fi,fok);
dcanedit   :=fcanedit;
dsetindex  :=fsetindex;
//get
if (xstyle='color.menu') then
   begin
   //init
   xcanpastetext:=clip__canpastetext;

   //get
   low__menutitle(m,tepnone,'Color Options','Select an option');
   low__menuitem(m,tepSwap20,'Swap Static and Flash colors','Color Swap|Swap Static and Flash colors','color.swapfs',100,xok and fok and dcanedit);
   low__menuitem(m,tepSwap20,'Swap Alt 1 and Alt 2 colors','Color Swap|Swap Alt 1 and Alt 2 colors','color.swap12',100,xok and fok and dcanedit);
   low__menuitem(m,tepSwap20,'Swap Flash/Static and Alt 1/Alt 2 color pairs','Color Swap|Swap Flash and Static with Alt 1 and Alt 2 colors','color.swapfs12',100,xok and fok and dcanedit);

   bol1:=xok and fok and dcanedit;
   low__menuitem(m,tepCopy20,'Copy color','Foreground Color|Copy Foreground color to Clipboard','color.copy',100,bol1);
   low__menuitem(m,tepPaste20,'Paste color','Foreground Color|Paste Foreground color from Clipboard','color.paste',100,bol1 and xcanpastetext);
   low__menuitem(m,tepPaste20,'Paste+1 color','Foreground Color|Paste Foreground color from Clipboard and move to next color','color.paste+1',100,bol1 and xcanpastetext);

   bol1:=xok and fok and (dsetindex>=0);
   low__menuitem(m,tepCopy20,'Copy color set'+insstr(' "P'+k64(dsetindex)+'"',dsetindex>=0),'Color Set|Copy color set to Clipboard','color.copyset',100,bol1);
   low__menuitem(m,tepPaste20,'Paste color set'+insstr(' as "P'+k64(dsetindex)+'"',dsetindex>=0),'Color Set|Paste color set from Clipboard','color.pasteset',100,bol1 and xcanpastetext);

   low__menuitem(m,tepCopy20,'Copy color palette','Color Palette|Copy color palette to Clipboard','color.copypalette',100,xok);
   low__menuitem(m,tepPaste20,'Paste color palette','Color Palette|Paste color palette from Clipboard','color.pastepalette',100,xok and xcanpastetext);
   end;
except;end;
end;

function tpal8.showmenuClick(sender:tobject;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
begin
result:=true;
xcmd(xcode2);
end;

function tpal8._onshortcut(sender:tobject):boolean;
begin
//defaults
result:=false;//not handled

//get
if enabled then
   begin

   case gui.key of
   akCTRLF:begin//ctrl+f
      xcmd('scroll.findf');
      result:=true;//handled
      end;
   akCTRLB:begin//ctrl+b
      xcmd('scroll.findb');
      result:=true;//handled
      end;
   end;//case

   end;

end;

procedure tpal8.xaddcells;
var
   xsetcount,xcolorcount:longint;

   function xaddset:boolean;
   var
      p:longint;
   begin
   //defaults
   result:=false;

   //gap cell
   if not xaddcell('P'+intstr32(xsetcount),'P'+intstr32(xsetcount),csGap,0,xsetcount,0,false) then exit;

   //color cells (10 per set)
   for p:=0 to (pic8_progressColorsPerSlot-1) do
   begin
   if not xaddcell(intstr32(p),intstr32(p),csColor,xcolorcount,xsetcount, (1/pic8_progressColorsPerSlot)*(p+1), pic8__canedit_colindex(xcolorcount) ) then exit;
   inc(xcolorcount);
   end;//p

   //inc setcount
   inc(xsetcount);

   //successful
   result:=true;
   end;
begin

//init
ilist.count  :=0;
ilist.ccount :=0;
ilist.width  :=0;
xsetcount    :=0;
xcolorcount  :=0;

//get
//.first color = transparent color (always)
xaddcell('T','T',csColor,xcolorcount,-1,0, pic8__canedit_colindex(xcolorcount) );//can't edit 1st color -> remains system set
inc(xcolorcount);

//.sets of colors (10 colors per set)
while xaddset do;

end;

function tpal8.xaddcell(const xcap,xcap2:string;xmode,xcolindex,xsetindex:longint;xsettrigger:double;xcanedit:boolean):boolean;
begin
if (ilist.count<=high(ilist.cells)) and ((xmode<>csColor) or (ilist.ccount<=high(tlistcolor32))) then
   begin

   ilist.cells[ ilist.count ].canedit     :=xcanedit;//14jul2025
   ilist.cells[ ilist.count ].mode        :=xmode;
   ilist.cells[ ilist.count ].cap         :=xcap;
   ilist.cells[ ilist.count ].cap2        :=xcap2;
   ilist.cells[ ilist.count ].colindex    :=xcolindex;
   ilist.cells[ ilist.count ].setindex    :=xsetindex;
   ilist.cells[ ilist.count ].setshow     :=(xsettrigger>0);
   ilist.cells[ ilist.count ].settrigger  :=xsettrigger;
   ilist.cells[ ilist.count ].area        :=nilarea;
   ilist.cells[ ilist.count ].wmultipler  :=low__aorb(1,2,xmode=csGap);
   ilist.cells[ ilist.count ].xunit1      :=ilist.width;
   ilist.cells[ ilist.count ].xunit2      :=ilist.width + ilist.cells[ ilist.count ].wmultipler;
   ilist.cells[ ilist.count ].progressslot:=pic8_progress_colorindexTOslot[ ilist.ccount ];//color count

   //width
   inc(ilist.width, ilist.cells[ ilist.count ].wmultipler );

   //inc
   inc(ilist.count);
   if (xmode=csColor) then inc(ilist.ccount);//must limit number of color indexes to "0..high(tlistcolor32)" - 13jul2025

   //successful
   result:=true;
   end
else result:=false;

end;

procedure tpal8.disconnect;
begin
ihost:=nil;
icore:=nil;
end;

function tpal8.findex(var fi:longint;var fok:boolean):boolean;
begin
result:=(icore<>nil) and (icore.findex>=0) and (icore.findex<=high(tlistcolor32));
fok   :=result;

case result of
true:fi:=icore.findex;
else fi:=0;
end;//case

end;

function tpal8.fcolindex:longint;
begin
if (icore<>nil) then result:=icore.findex else result:=1;
end;

function tpal8.bcolindex:longint;
begin
if (icore<>nil) then result:=icore.bindex else result:=0;
end;

function tpal8.fcellindex:longint;
var
   int1:longint;
begin
if (icore<>nil) and (icore.findex>=0) and (icore.findex<=high(tlistcolor32)) and xfindcell(icore.findex,int1) then result:=int1 else result:=-1;
end;

function tpal8.fcellindex2(var xcellindex:longint):boolean;
begin
xcellindex :=fcellindex;
result     :=(xcellindex>=0);
end;

function tpal8.fsetindex:longint;
var
   int1:longint;
begin
if fcellindex2(int1) then result:=ilist.cells[int1].setindex else result:=-1;
end;

function tpal8.fcanedit:boolean;
var
   int1:longint;
begin
if fcellindex2(int1) then result:=ilist.cells[int1].canedit else result:=false;
end;

function tpal8.xcanedit(xcolindex:longint):boolean;
var
   p:longint;
begin
//defaults
result:=false;

//get
for p:=0 to (ilist.count-1) do if (xcolindex=ilist.cells[p].colindex) then
   begin
   result:=ilist.cells[p].canedit;
   break;
   end;//p
end;

function tpal8.xfindcell(xcolorindex:longint;var xcellindex:longint):boolean;
var
   p:longint;
begin
//defaults
result     :=false;
xcellindex :=0;

//get
for p:=0 to (ilist.count-1) do if (ilist.cells[p].mode=csColor) and (ilist.cells[p].colindex=xcolorindex) then
   begin
   result:=true;
   xcellindex:=p;
   break;
   end;//p
end;

function tpal8.fcolor32(xindex03:longint):tcolor32;//13jul2025
var
   fi:longint;
   fok:boolean;
begin

//init
findex(fi,fok);

//get
if fok then result:=pic8__getcolor32(icore^,fi,xindex03)
else
   begin

   result.r:=0;
   result.g:=0;
   result.b:=0;
   result.a:=0;

   end;

end;

function tpal8.fcolor24(xindex03:longint):tcolor24;//13jul2025
var
   c32:tcolor32;
begin

c32:=fcolor32(xindex03);
result.r:=c32.r;
result.g:=c32.g;
result.b:=c32.b;

end;

procedure tpal8.xscreen__preundoredo(sender:tobject);
begin

//host is about to use it's Undo or Redo actions, so commit now to undo any pending data - 11jul2025
if xundoprimed then xchanged;

end;

procedure tpal8.xscreen__oncommitval(sender:tobject);
begin

if (ilastcommitref<>nil) and xundoprimed then xchanged;

end;

procedure tpal8.xscreen__onreadwriteval(sender:tobject;var xval:longint;xwrite:boolean);
var
   fi:longint;
   fok:boolean;
   flist,lsmooth,lflickrate,lflick:plistval8;
begin
//init
findex(fi,fok);

if fok then pic8__editlist2(icore^,flist,lsmooth,lflick,lflickrate,xeditlist2);


//prime undo once
if xwrite then
   begin

   //commit any previous undo
   if (ilastcommitref<>sender) and xundoprimed then xchanged;//resets "ilastcommitref"

   //prime undo with current data snapshot
   ilastcommitref:=sender;
   if (not xundoprimed) then xprimeundo;

   end;


//get
//.flash fps
if (sender=iflash) and fok then
   begin

   case xwrite of
   true:flist[fi]:=xval;
   else xval:=flist[fi];
   end;//case

   end

//.flicker fps
else if (sender=iflicker) and fok then
   begin

   case xwrite of
   true:lflickrate[fi]:=xval;
   else xval:=lflickrate[fi];
   end;//case

   end

//.flicker %
else if (sender=iflickerpert) and fok then
   begin

   case xwrite of
   true:lflick[fi]:=xval;
   else xval:=lflick[fi];
   end;//case

   end

end;

procedure tpal8.xscreen__onclick2(sender:tobject);
begin
xscreen__onclick(sender);
end;

function tpal8.xscreen__onclick(sender:tobject):boolean;
var
   fok:boolean;
   fi:longint;
   flist,lsmooth,lflickrate,lflick:plistval8;
begin
//defaults
result:=true;

//init
findex(fi,fok);

if fok then pic8__editlist2(icore^,flist,lsmooth,lflick,lflickrate,xeditlist2);

//get
if (sender=iflash) and fok then
   begin

   xprimeundo;
   if (lsmooth[fi]=0) then lsmooth[fi]:=1 else lsmooth[fi]:=0;
   xchanged;

   end
else if (sender=itoolbar) then xcmd(itoolbar.ocode2)
//else if (sender=iflicker) then xcmd('flicker.....')
else
   begin
   //nil
   end;

end;

procedure tpal8.xscreen__oncaption(sender:tobject;var xval:string);
var
   fi,p:longint;
   fok:boolean;
   d:double;
   flist,lsmooth,lflickrate,lflick:plistval8;
begin
//init
findex(fi,fok);

if fok then pic8__editlist2(icore^,flist,lsmooth,lflick,lflickrate,xeditlist2);


//get

//.flash fps
if fok and (sender=iflash) then
   begin

   xval:=low__aorbstr('Normal','Smooth',lsmooth[fi]>0) + ' Flash '+curdec(iflash.val/ionefps,2,true) + ' fps';

   end

//.flicker %
else if fok and (sender=iflickerpert) then
   begin

   case (iflickerpert.val>0) of
   true:xval:='Flicker ' + intstr32(iflickerpert.val)+' %';
   else xval:='Flicker Off';
   end;//case

   end

//.flicker fps
else if fok and (sender=iflicker) then
   begin

   if (iflicker.val>0)      then xval:='Flicker '+curdec(iflicker.val/ionefps,2,true) + ' fps'
   else                          xval:='Flicker Realtime';

   if (iflickerpert.val<=0) then xval:=xval+' (Off)';

   end

//.progress %
else if fok and (sender=iprogresscontrol) then
   begin

   case (iprogresscontrol.val>0) of
   true:xval:='Manual '+intstr32(iprogresscontrol.val*pic8_progressColorsPerSlot) + '%';
   else begin
      d:=0;
      for p:=0 to high(icore.progress) do if (icore.progress[p]>d) then d:=icore.progress[p];

      xval:='Xbox '+intstr32( round(d*100) ) + '%';
      end;
   end;//case

   end;


end;

function tpal8.cellheight:longint;
begin
result:=42*vizoom;
end;

function tpal8.cellwidth:longint;
begin
result:=42*vizoom;
end;

function tpal8.getalignheight(xclientwidth:longint):longint;//14jul2025
begin
//cell height
result:=cellheight;

//allow for controls
if xhavehigh  then inc(result,xhigh.getalignheight(xclientwidth));
if xhavehigh2 then inc(result,xhigh2.getalignheight(xclientwidth));
end;

function tpal8.xprogresschanged:boolean;
var
   p:longint;
   bol1:boolean;
begin
//defaults
result:=false;

//check
if (icore<>nil) then
   begin

   //init
   bol1:=false;

   //get
   for p:=0 to high(icore.progress) do if (icore.progress[p]>0) then
      begin
      bol1:=true;
      break;
      end;

   if low__setbol(iprogresschangedref,bol1) then
      begin
      result:=true;
      exit;
      end;

   //compare further
   if bol1 then for p:=0 to high(ireflist24) do if (ireflist24[p].r<>icore.rlist24[p].r) or (ireflist24[p].g<>icore.rlist24[p].g) or (ireflist24[p].b<>icore.rlist24[p].b) or (ireflist8[p]<>icore.rlist8[p]) then
      begin
      ireflist24:=icore.rlist24;
      ireflist8 :=icore.rlist8;

      result:=true;
      break;
      end;//p
   end;

end;

function tpal8.xsafescrollx(x:longint):longint;
begin
result:=frcrange32(x, -frcmin32( cellwidth * (ilist.width-2), 0) , frcmin32( iscreen.clientwidth - (2*cellwidth) , 0) );
end;

function tpal8.xscrollidle:boolean;
begin
result:=(sub64(ms64,iscrollidleref)>=1000);
end;

procedure tpal8.xscrollnotidle;
begin
iscrollidleref:=ms64;
if (iscrollnotidle_scrollx=min32) then iscrollnotidle_scrollx:=iscrollx;
end;

procedure tpal8._ontimer(sender:tobject);
var
   xmustpaint:boolean;
   str1:string;
   d:double;
   int1,p:longint;
begin
try

//ifasttimer
if (ms64>=ifasttimer) then
   begin
   //init
   xmustpaint:=false;

   //get
   if (icore<>nil) then
      begin
      str1:='';
      for p:=0 to high(tprogresslist) do str1:=str1+floattostrex2(icore.progress[p])+'|';

      if low__setstr(iref,str1+bolstr(iflashon)+'|'+intstr32(icore.uselist2ForThisColorIndex)+'|'+intstr32(icellindex)+'|'+intstr32(icore.findex)+'|'+intstr32(icore.bindex)+'|'+intstr32(clientwidth)+'|'+intstr32(clientheight)+'|'+intstr32(icore.dataid)) then xmustpaint:=true;
      if xprogresschanged then xmustpaint:=true;//11jul2025

      end;


   //automatic scroll
   if (iscrolltime<>0) then
      begin

      xscrollnotidle;

      //scroll
      d:=frcranged64(iscrolltime/200, -10, 10);

      iscrollx:=xsafescrollx(iscrollx + round(cellwidth * d)  );

      //drain down time
      iscrolltime:=(0 + (iscrolltime*5)) div 6;

      end

   //scroll to
   else if (iscrollto<>min32) then
      begin

      xscrollnotidle;

      case low__nrw(iscrollx,iscrollto,20) of
      true:begin

         int1:=iscrollto-iscrollx;

         if      (int1>=4)  then inc(iscrollx,4)
         else if (int1>=2)  then inc(iscrollx,2)
         else if (int1>=1)  then inc(iscrollx,1)
         else if (int1<=-4) then dec(iscrollx,4)
         else if (int1<=-2) then dec(iscrollx,2)
         else if (int1<=-1) then dec(iscrollx,1);

         end;
      else iscrollx:=xsafescrollx( ((iscrollx*5) + iscrollto) div 6 );
      end;//case

      if (iscrollx=iscrollto) then iscrollto:=min32;

      end;

      //auto-store scrollx to scrollprevx when scrolling idle for manual scroll events - 13jul2024
      if iupdateprevwhenidle and xscrollidle then
         begin

         iupdateprevwhenidle :=false;

         if (iscrollnotidle_scrollx<>min32) then
            begin
            iscrollprevx            :=iscrollnotidle_scrollx;
            iscrollnotidle_scrollx  :=min32;//off
            end;

         end;

   //fast
   app__turbo;

   //paint
   iscreen.paintnow;

   //reset
   ifasttimer:=ms64+30;//30fps
   end;

//itimer250
if (ms64>=itimer250) then
   begin

   iflashon:=not iflashon;

   //other
   xsync;

   //reset
   itimer250:=ms64+250;
   end;

except;end;
end;

procedure tpal8.xsync;
var
   d:double;
   fi,p:longint;
   dcanedit,fok,xok:boolean;
begin
try
//check
if (icore=nil) or (ihost=nil) then exit;

//init
xok       :=not (ihost as ttex).locked;
findex(fi,fok);
dcanedit  :=fcanedit;


//index03 -> default back to "0/1" after a short delay of inactivity on index "2/3" - 14jul2025
if (icolorindex03>=2) and (ms64>=icolorindex03REF) then icolorindex03:=0;


//controls
iflash.enabled                              :=xok;
iflicker.enabled                            :=xok;
iflickerpert.enabled                        :=xok;
iprogresscontrol.enabled                    :=xok;

itoolbar.benabled2['color.copy']            :=xok and fok and dcanedit;
itoolbar.benabled2['color.paste']           :=xok and fok and dcanedit;
itoolbar.benabled2['color.paste+1']         :=xok and fok and dcanedit;

itoolbar.benabled2['edit.color1']           :=xok and fok;
itoolbar.benabled2['edit.color2']           :=xok and fok;
itoolbar.benabled2['edit.color3']           :=xok and fok;
itoolbar.benabled2['edit.color4']           :=xok and fok;

itoolbar.bmarked2['edit.color1']            :=(icolorindex03=0);
itoolbar.bmarked2['edit.color2']            :=(icolorindex03=1);
itoolbar.bmarked2['edit.color3']            :=(icolorindex03=2);
itoolbar.bmarked2['edit.color4']            :=(icolorindex03=3);

itoolbar.bcolor2['edit.color1']             :=c24__int(fcolor24(0));
itoolbar.bcolor2['edit.color2']             :=c24__int(fcolor24(1));
itoolbar.bcolor2['edit.color3']             :=c24__int(fcolor24(2));
itoolbar.bcolor2['edit.color4']             :=c24__int(fcolor24(3));

itoolbar.benabled2['color.menu']            :=xok;
itoolbar.benabled2['color.swapfb']          :=xok and (icore.findex<>icore.bindex);
itoolbar.benabled2['color.noeffects']       :=xok;
itoolbar.benabled2['scroll.home']           :=xok;
itoolbar.benabled2['scroll.end']            :=xok;
itoolbar.benabled2['scroll.prev']           :=xok and (iscrollprevx<>min32) and (iscrolltime=0) and (iscrollto=min32) and (not iupdateprevwhenidle);
itoolbar.benabled2['scroll.findfb']         :=xok;

itoolbar.bcap2['scroll.findfb']             :='Find '+low__aorbstr('B','F',ifindfb);


//sync progress
d:=1/pic8_progressColorsPerSlot;
d:=d*iprogresscontrol.val;

for p:=0 to high(icore.progress) do
begin

case (d>0) of
true:icore.progress[p]:=d;
else if (ihost as ttex).hold[p] then icore.progress[p]:=0;//momentarily reset to zero in case no Xbox controller is connected
end;

//.hold manual progress -> blocks Xbox controller from setting value
(ihost as ttex).hold[p]:=(d>0);

end;//p

//other
icore.uselist2ForThisColorIndex:=low__aorb(-1,icore.findex,xeditlist2);

except;end;
end;

procedure tpal8.xscreen__onpaint(sender:tobject);//pal8._onpaint
var
   ss:tbasiccontrol;
   s:tclientinfo;
   t:string;
   lx,dscrollx,dcellwidth,p,i,tc,int1,tw:longint;
   dprogressval:double;
   fok,bok,bol1,dprogresson:boolean;
   da:twinrect;
   r32,e32,o32,a32:tcolor32;
begin
try
//check
if (icore=nil) or (ihost=nil) then exit;

//render
pic8__renderinit( icore^ );


//init
iscreen.infovars(s);
ss           :=iscreen;
tc           :=clnone;
dcellwidth   :=cellwidth;
da.left      :=s.cs.left-1;
da.right     :=s.cs.left-1;
da.top       :=s.cs.top;
da.bottom    :=s.cs.bottom;
dscrollx     :=xsafescrollx(iscrollx);
dprogresson  :=false;
//.manual progress
dprogressval :=0;
for i:=0 to high(icore.progress) do if (icore.progress[i]>dprogressval) then dprogressval:=icore.progress[i];


//cls
ss.lds( s.cs , s.back, false);


//pallete cells
for i:=0 to (ilist.count-1) do
begin

//init
da.left             :=s.cs.left + (ilist.cells[i].xunit1*dcellwidth) + dscrollx;
da.right            :=s.cs.left + (ilist.cells[i].xunit2*dcellwidth) + dscrollx -1;
da.top              :=s.cs.top;
da.bottom           :=s.cs.bottom;
ilist.cells[i].area :=da;
fok                 :=(ilist.cells[i].mode=csColor) and (icore.findex=ilist.cells[i].colindex);
bok                 :=(ilist.cells[i].mode=csColor) and (icore.bindex=ilist.cells[i].colindex);

//.xbox progress -> overrides manual progress
if (iprogresscontrol.val<=0) then
   begin

   case (ilist.cells[i].progressslot>=0) of
   true:dprogressval:=icore.progress[ ilist.cells[i].progressslot ];
   else dprogressval:=0;
   end;//case

   end;

//get -> cell is visible -> draw it
if (da.right>=s.cs.left) and (da.left<=s.cs.right) then
   begin


   //cell is a color
   if (ilist.cells[i].mode=csColor) then
      begin

      //draw cell color --------------------------------------------------------

      //.progresson
      dprogresson :=ilist.cells[i].setshow and (dprogressval>=ilist.cells[i].settrigger);
      r32         :=pic8__rlist32(icore^, ilist.cells[i].colindex);
      tc          :=int__invert2b( c32__int(r32) ,true);

      case (ilist.cells[i].colindex=icore.uselist2ForThisColorIndex) or dprogresson of
      true:begin
         e32:=c24a__c32( icore.elist24b[ ilist.cells[i].colindex ] , icore.elist8b[ ilist.cells[i].colindex ] );
         o32:=c24a__c32( icore.olist24b[ ilist.cells[i].colindex ] , icore.olist8b[ ilist.cells[i].colindex ] );
         end;
      else begin
         e32:=c24a__c32( icore.elist24[ ilist.cells[i].colindex ] , icore.elist8[ ilist.cells[i].colindex ] );
         o32:=c24a__c32( icore.olist24[ ilist.cells[i].colindex ] , icore.olist8[ ilist.cells[i].colindex ] );
         end;
      end;//case

      //.static color (main)
      ss.lds( da ,c32__int(r32) ,false);

      //.show both static colors
      int1:=2*s.zoom;

      ss.lds( area__make(da.left+int1,da.bottom-(10*s.zoom), da.left + ((da.right-da.left+1) div 2) ,da.bottom) , c32__int(e32) ,false);
      ss.lds( area__make( da.left + ((da.right-da.left+1) div 2) ,da.bottom-(10*s.zoom),da.right-int1,da.bottom) , c32__int(o32) ,false);

      //.label
      if dprogresson then t:=ilist.cells[i].cap2 else t:=ilist.cells[i].cap;

      tw:=low__fonttextwidth2(s.fs,t);
      ss.ldt2(clnone,da, da.left + ((da.right-da.left+1-tw) div 2), da.top + round( 1.20 * (((da.bottom-da.top+1-s.fsH)) div 2) ),tc, t, s.fs,s.f,false,false,false,false,false);

      //.background spacing gap color
      ss.ldo(da,s.back,false);
      ss.ldo( area__grow(da,-1) ,s.back,false);

      //.progress indicator
      if dprogresson then
         begin
         ss.lds( area__make(da.left, da.bottom - (5*s.zoom) ,da.right,da.bottom - (4*s.zoom)-1) ,s.back ,false);
         ss.lds( area__make(da.left, da.bottom - (4*s.zoom) ,da.right,da.bottom) ,s.colhover ,false);
         end;

      //.foreground and background indicators
      if (tc<>clnone) and (fok or bok) then
         begin

         //.border
         for int1:=0 downto -1 do
         begin
         ss.ldo( area__grow(da, int1) , low__aorb(clblack,clwhite,low__iseven(int1)) , false);
         end;//p


         //.text
         int1:=3 * s.zoom;

         if      fok and bok then t:='F+B'
         else if fok         then t:='F'
         else if bok         then t:='B'
         else                     t:='';

         if (t<>'') then ss.ldt1(clnone,da, da.left + ((da.right-da.left+1)-low__fonttextwidth2(s.fn,t)) div 2 ,da.top+int1-3+s.zoom  ,tc,t,s.fn,s.f,false);//white

         end;

      end

   //cell is a set indicator/gap cell
   else if (ilist.cells[i].mode=csGap) then
      begin

      //draw cell gap ----------------------------------------------------------

      //.background
      ss.lds(da, low__aorb(s.hover,s.colhover,dprogressval>0),false);

      //.label
      tw :=low__fonttextwidth2(s.fn, ilist.cells[i].cap );
      ss.ldt2(clnone,da, da.left + ((da.right-da.left+1-tw) div 2), da.top + round( 1.25 * (((da.bottom-da.top+1-s.fnH)) div 2) ), low__aorb(s.font,s.colfont,dprogressval>0) , ilist.cells[i].cap ,s.fn,s.f,false,false,false,false,false);

      end;

   end;//if

end;//i


//restore corner colors
xparentcorners;

except;end;
end;

procedure tpal8.findarea(sx,sy:longint);
var
   ci,p:longint;
begin
//defaults
ci:=-1;

//find cell index
for p:=0 to (ilist.count-1) do if (sx>=ilist.cells[p].area.left) and (sx<=ilist.cells[p].area.right) and (sy>=ilist.cells[p].area.top) and (sy<=ilist.cells[p].area.bottom) then
   begin
   ci:=p;
   break;
   end;

//set
icellhoverindex:=ci;
end;

function tpal8.xundoprimed:boolean;
begin
if (ihost<>nil) then result:=(ihost as ttex).undo__primed else result:=false;
end;

procedure tpal8.xprimeundo;
begin

if (ihost<>nil) then
   begin

   //store previous undo if any
   if xundoprimed then xchanged;

   //prime undo with current data snapshot ready to commit with a call to "xchanged"
   (ihost as ttex).undo__primenew;
   end;

end;

procedure tpal8.xchanged;//11jul2025
begin

if (icore<>nil) then pic8__changed(icore^);//increments "dataid" which allows undo to commit
if (ihost<>nil) then (ihost as ttex).undo__pushnew;

ilastcommitref:=nil;

end;

function tpal8.xeditlist2:boolean;
begin
result:=(icolorindex03>=2);
end;

function tpal8.xuselist2forthiscolorindex:longint;
begin
result:=low__aorb(-1,icore.findex,xeditlist2);
end;

procedure tpal8.xmoretime_colorindex03;
begin
icolorindex03REF:=ms64+5000;//inactivity time delay before reverting back to index "0" - 14jul2025
end;

procedure tpal8.xcmd(n:string);

   procedure xeditcolor(xcolindex,xindex03:longint);
   var
      v:longint;
   begin

   if (icore<>nil) and (xindex03>=0) and (xindex03<=3) then
      begin
      xmoretime_colorindex03;

      if (not low__setint(icolorindex03,xindex03)) and xcanedit(xcolindex) then
         begin

         v:=pic8__getcolor(icore^, xcolindex, xindex03);

         if gui.popcolor2(v,true) then
            begin
            xprimeundo;
            pic8__setcolor(icore^, xcolindex, xindex03, v);
            xchanged;

            scrolltocolor(xcolindex);
            end;

         end;

      end;

   end;

   procedure xswapfs(xcolindex:longint);//flash and static
   begin

   if (icore<>nil) and (xcolindex>=0) and (xcolindex<=high(tlistcolor32)) and xcanedit(xcolindex) then
      begin
      xprimeundo;

      c24__swap( icore.elist24[ xcolindex ], icore.olist24[ xcolindex ] );
      c8__swap ( icore.elist8 [ xcolindex ], icore.olist8 [ xcolindex ] );

      xchanged;
      end;

   end;

   procedure xswap12(xcolindex:longint);//alt 1 and alt 2
   begin

   if (icore<>nil) and (xcolindex>=0) and (xcolindex<=high(tlistcolor32)) and xcanedit(xcolindex) then
      begin
      xprimeundo;

      c24__swap( icore.elist24b[ xcolindex ], icore.olist24b[ xcolindex ] );
      c8__swap ( icore.elist8b [ xcolindex ], icore.olist8b [ xcolindex ] );

      xchanged;
      end;

   end;

   procedure xswapfs12(xcolindex:longint);//flash/static and alt 1/alt 2
   begin

   if (icore<>nil) and (xcolindex>=0) and (xcolindex<=high(tlistcolor32)) and xcanedit(xcolindex) then
      begin
      xprimeundo;

      c24__swap( icore.elist24[ xcolindex ], icore.elist24b[ xcolindex ] );
      c8__swap ( icore.elist8 [ xcolindex ], icore.elist8b [ xcolindex ] );

      c24__swap( icore.olist24[ xcolindex ], icore.olist24b[ xcolindex ] );
      c8__swap ( icore.olist8 [ xcolindex ], icore.olist8b [ xcolindex ] );

      xchanged;
      end;

   end;

   procedure xnoeffects(xcolindex:longint);
   begin

   if (icore<>nil) and (xcolindex>=0) and (xcolindex<=high(tlistcolor32)) and xcanedit(xcolindex) then
      begin
      xprimeundo;

      icore.flist[xcolindex]      :=0;
      icore.lflickrate[xcolindex] :=0;
      icore.lflick[xcolindex]     :=0;
      icore.lsmooth[xcolindex]    :=0;

      xchanged;
      end;

   end;

   procedure xswapfb;//swap foreground and background color indexes
   begin

   if (icore<>nil) then
      begin
      xprimeundo;

      low__swapint( icore.findex, icore.bindex );

      xchanged;
      end;

   end;

   procedure xfindfb(xmode:string);//find Foreground or Background color (alternates search)
   var
      p,i:longint;
   begin

   //check
   if (icore=nil) then exit;

   //mode
   if      strmatch(xmode,'f') then ifindfb:=true
   else if strmatch(xmode,'b') then ifindfb:=false;

   //find
   case ifindfb of
   true:i:=icore.findex;
   else i:=icore.bindex;
   end;

   //scroll
   for p:=0 to (ilist.count-1) do if (i=ilist.cells[p].colindex) then
       begin

       //calculate scroll position
       xscrollto( (iscreen.clientwidth div 2) - (ilist.cells[p].xunit1*cellwidth) );

       //toggle
       ifindfb:=not ifindfb;

       //stop
       break;
       end;

   end;

begin
try
//check
if (icore=nil) or (ihost=nil) then exit;

//init
n:=strlow(n);

//get
if      (n='edit.color1')               then xeditcolor(icore.findex,0)
else if (n='edit.color2')               then xeditcolor(icore.findex,1)
else if (n='edit.color3')               then xeditcolor(icore.findex,2)
else if (n='edit.color4')               then xeditcolor(icore.findex,3)
else if (n='color.menu')                then showmenu2(n)
else if (n='color.swapfs')              then xswapfs(icore.findex)
else if (n='color.swap12')              then xswap12(icore.findex)
else if (n='color.swapfs12')            then xswapfs12(icore.findex)
else if (n='color.swapfb')              then xswapfb
else if (n='color.noeffects')           then xnoeffects(icore.findex)
else if (n='color.copy')                then copycolor
else if (n='color.copyset')             then copycolorset( -1 )
else if (n='color.pasteset')            then pastecolorset( -1 )
else if (n='color.copypalette')         then copycolorpalette
else if (n='color.pastepalette')        then pastecolorpalette
else if (n='color.paste')               then pastecolor(false)
else if (n='color.paste+1')             then pastecolor(true)
else if (n='scroll.home')               then xscrollto(0)
else if (n='scroll.end')                then xscrollto((-ilist.width*cellwidth) + iscreen.clientwidth - cellwidth)
else if (n='scroll.prev')               then xscrollprev
else if (n='scroll.left')               then xscrollto( iscrollx+(iscreen.clientwidth div 5) )
else if (n='scroll.right')              then xscrollto( iscrollx-(iscreen.clientwidth div 5) )
else if (n='scroll.findfb')             then xfindfb('')
else if (n='scroll.findf')              then xfindfb('f')
else if (n='scroll.findb')              then xfindfb('b')
else
   begin
   //nil
   end;

//refocus pallete
gui.focuscontrol:=iscreen;

//sync
xsync;
except;end;
end;

procedure tpal8.setfocus;
begin
gui.focuscontrol:=iscreen;
end;

procedure tpal8.xscrolltime(x:longint);
begin

if (iscrolltime=0) then
   begin
   iupdateprevwhenidle :=false;
   iscrollprevx        :=iscrollx;
   end;
   
xscrolltime0(x);

end;

procedure tpal8.xscrolltime0(x:longint);
begin

iscrollto:=min32;//turn off

case (iscrolltime=0) of
true:iscrolltime:=x;
else inc(iscrolltime,x);
end;//case

end;

procedure tpal8.xscrollto(x:longint);
begin

iupdateprevwhenidle :=false;
iscrollprevx        :=iscrollx;
xscrollto0(x);

end;

procedure tpal8.xscrollto0(x:longint);
begin

iscrolltime  :=0;//turn off
iscrollto    :=xsafescrollx(x);

end;

procedure tpal8.xscrollprev;
begin
if (iscrollprevx<>min32) then xscrollto(iscrollprevx);
end;

procedure tpal8.xscrolloff;
begin
iscrolltime  :=0;//turn off
iscrollto    :=min32;//off
end;

procedure tpal8.scrolltocolor(xcolindex:longint);
var
   p:longint;
begin

for p:=0 to (ilist.count-1) do if (ilist.cells[p].mode=csColor) and (xcolindex=ilist.cells[p].colindex) then
   begin

   //scroll to
   xscrollto(  -(ilist.cells[p].xunit1*cellwidth) + (iscreen.clientwidth div 2) );

   //stop
   break;

   end;//p

end;

function tpal8.xscreen__onnotify(sender:tobject):boolean;
begin
result:=xscreen__onnotify2(sender,false,'');
end;

function tpal8.xscreen__onnotify2(sender:tobject;xother:boolean;noverride:string):boolean;
var
   ss:tbasiccontrol;
   xok,xmustpaint:boolean;
begin
//defaults
result        :=true;
xmustpaint    :=false;
ss            :=iscreen;
xok           :=(icore<>nil) and (ihost<>nil) and (not (ihost as ttex).locked);


try
//find
findarea(ss.mousemovexy.x,ss.mousemovexy.y);


//keyboard support
if (gui.key<>aknone) and xok then
   begin

   case gui.key of
   akhome         :xcmd('scroll.home');
   akend          :xcmd('scroll.end');
   akleft,akup    :xcmd('scroll.left');
   akright,akdown :xcmd('scroll.right');
   end;//case

   end;

//mouse wheel support
if xok and (gui.wheel<>0) then
   begin

   xscrollnotidle;
   xscrolltime0( round( low__aorb(1,2,iscrolltime>0)*120 * gui.wheel)  );
   iupdateprevwhenidle:=true;

   end;

//mouse button and movement support
//.down
if gui.mousedownstroke and xok then
   begin

   xscrollnotidle;

   if low__setint(icellindex,icellhoverindex) then xmustpaint:=true;

   ilastmousex   :=iscreen.mousedownxy.x;
   idownscrollx  :=iscrollx;
   ilastscrollx  :=iscrollx;
   end;

//.move
if gui.mousedown and xok and gui.mousedraggingfine then
   begin

   xscrollnotidle;
   xscrolloff;

   ilastscrollx         :=iscrollx;
   iscrollx             :=xsafescrollx( idownscrollx + (iscreen.mousemovexy.x-ilastmousex) );
   iupdateprevwhenidle  :=true;

   end;

//.up
if gui.mouseupstroke and xok then
   begin

   //give scroll movement some speed -> detection if +/-10 with "vizoom" -> smoother and more consistent - 12jul2025
   if gui.mousedragging then
      begin
//      if xscrollidle then iscrollprevx:=idownscrollx;

      if (not low__nrw(iscrollx,ilastscrollx,10)) then xscrolltime0( (iscrollx-ilastscrollx)*10*vizoom );
      end;

   //color
   if (not gui.mousedragging) and (icellindex>=0) and (icellindex<ilist.count) and (ilist.cells[icellindex].mode=csColor) then
      begin

      case gui.mouseleft of
      true:if low__setint(icore.findex, ilist.cells[icellindex].colindex ) then pic8__modified(icore^);
      else if low__setint(icore.bindex, ilist.cells[icellindex].colindex ) then pic8__modified(icore^);
      end;//case

      //edit color
//      if (icellindex=ilastcellindex) and gui.mouseleft then xcmd('edit.color1');

      //paint
      xmustpaint:=true;

      //reset
      ilastcellindex:=icellindex;
      end;

   end;

//paint
if xmustpaint then ss.paintnow;
except;end;
end;

procedure tpal8.copycolorpalette;
var
   p,ci:longint;
   str1:string;
begin
//check
if (icore=nil) then exit;

//init
str1:=icolorsetsheader;

//get
for p:=0 to (ilist.count-1) do if (ilist.cells[p].mode=csColor) and ilist.cells[p].canedit then
   begin

   //init
   ci:=ilist.cells[p].colindex;

   //get
   str1:=str1+

   //1st
   intstr32( pic8__getcolor(icore^,ci,0) )+','+//elist
   intstr32( pic8__getcolor(icore^,ci,1) )+','+//olist
   intstr32(icore.flist[ci])+','+
   intstr32(icore.lsmooth[ci])+','+
   intstr32(icore.lflick[ci])+','+
   intstr32(icore.lflickrate[ci])+','+

   //2nd
   intstr32( pic8__getcolor(icore^,ci,2) )+','+//elist
   intstr32( pic8__getcolor(icore^,ci,3) )+','+//olist
   intstr32(icore.flist2[ci])+','+
   intstr32(icore.lsmooth2[ci])+','+
   intstr32(icore.lflick2[ci])+','+
   intstr32(icore.lflickrate2[ci])+',';

   end;

//set
clip__copytext(str1);
end;

procedure tpal8.pastecolorpalette;
var
   int1,dcolcount,ci,xpos,xcount,lp,p:longint;
   str1,n:string;

   function xnextindex:longint;
   begin

   //defaults
   result:=-1;

   //get
   while true do
   begin

   inc(xpos);

   case (xpos<ilist.count) of
   true:begin

      if (ilist.cells[ xpos ].mode=csColor) and ilist.cells[ xpos ].canedit then
         begin
         result:=ilist.cells[ xpos ].colindex;
         break;
         end;

      end;
   else break;
   end;//case

   end;//loop

   end;
begin
//check
if (icore=nil) then exit;

//init
xpos:=-1;

//get
if clip__canpastetext then
   begin
   n:=clip__pastetextb;

   if strmatch(icolorsetsheader,strcopy1(n,1,low__len(icolorsetsheader))) then
      begin

      //init
      xprimeundo;

      n         :=strcopy1(n,low__len(icolorsetsheader)+1,low__len(n))+',';
      xcount    :=-1;
      lp        :=1;
      ci        :=xnextindex;//next color index
      dcolcount :=0;

      //get
      if (ci>=0) then
         begin

         for p:=1 to low__len(n) do if (n[p-1+stroffset]=',') then
         begin
         str1:=strcopy1(n,lp,p-lp);

         //inc
         inc(xcount);//0..11

         //decide
         case xcount of
         //1st
         0:pic8__setcolor(icore^,ci,0,strint32(str1));//elist
         1:pic8__setcolor(icore^,ci,1,strint32(str1));//olist
         2:icore.flist[ci]        :=pic8__safeflashrate(strint32(str1));
         3:icore.lsmooth[ci]      :=pic8__safesmooth(strint32(str1));
         4:icore.lflick[ci]       :=pic8__safeflicker(strint32(str1));
         5:icore.lflickrate[ci]   :=pic8__safeflashrate(strint32(str1));
         //2nd
         6:pic8__setcolor(icore^,ci,2,strint32(str1));//elist2
         7:pic8__setcolor(icore^,ci,3,strint32(str1));//olist2
         8:icore.flist2[ci]       :=pic8__safeflashrate(strint32(str1));
         9:icore.lsmooth2[ci]     :=pic8__safesmooth(strint32(str1));
         10:icore.lflick2[ci]     :=pic8__safeflicker(strint32(str1));
         11:begin
            icore.lflickrate2[ci] :=pic8__safeflashrate(strint32(str1));

            inc(dcolcount);

            //next color index
            ci:=xnextindex;
            if (ci<0) then break;

            //reset
            xcount:=-1;
            end;
         end;//case

         //check
         if (ci<0) then break;

         //lp
         lp:=p+1;
         end;//p

         end;

      //store undo
      xchanged;


      //check correct number of colors were used
      int1:=0;
      for p:=0 to (ilist.count-1) do if (ilist.cells[p].mode=csColor) and ilist.cells[p].canedit then inc(int1);

      if (dcolcount<int1) then gui.poperror('','Some colors were missing from the color palette');

      end;
   end;
end;

procedure tpal8.copycolorset(xsetindex:longint);
var
   fok:boolean;
   p,fi,ci:longint;
   str1:string;
begin
//check
if not findex(fi,fok) then exit;
if    (xsetindex<0)   then xsetindex:=fsetindex;
if    (xsetindex<0)   then exit;

//init
str1:=icolorsetsheader;

//get
for p:=0 to (ilist.count-1) do if (ilist.cells[p].setindex=xsetindex) and (ilist.cells[p].mode=csColor) then
   begin

   //init
   ci:=ilist.cells[p].colindex;

   //get
   str1:=str1+

   //1st
   intstr32(  pic8__getcolor(icore^, ci, 0) )+','+//elist
   intstr32(  pic8__getcolor(icore^, ci, 1) )+','+//olist
   intstr32(icore.flist[ci])+','+
   intstr32(icore.lsmooth[ci])+','+
   intstr32(icore.lflick[ci])+','+
   intstr32(icore.lflickrate[ci])+','+

   //2nd
   intstr32(  pic8__getcolor(icore^, ci, 2) )+','+//elist2
   intstr32(  pic8__getcolor(icore^, ci, 3) )+','+//olist2
   intstr32(icore.flist2[ci])+','+
   intstr32(icore.lsmooth2[ci])+','+
   intstr32(icore.lflick2[ci])+','+
   intstr32(icore.lflickrate2[ci])+',';

   end;

//set
clip__copytext(str1);
end;

procedure tpal8.pastecolorset(xsetindex:longint);
var
   fok:boolean;
   dcolcount,ci,xpos,xcount,lp,p,fi:longint;
   str1,n:string;

   function xnextindex:longint;
   begin

   //defaults
   result:=-1;

   //get
   while true do
   begin

   inc(xpos);

   case (xpos<ilist.count) of
   true:begin

      if (ilist.cells[ xpos ].setindex=xsetindex) and (ilist.cells[ xpos ].mode=csColor) then
         begin
         result:=ilist.cells[ xpos ].colindex;
         break;
         end;

      end;
   else break;
   end;//case

   end;//loop

   end;
begin
//check
if not findex(fi,fok) then exit;
if    (xsetindex<0)   then xsetindex:=fsetindex;
if    (xsetindex<0)   then exit;

//init
xpos:=-1;

//get
if clip__canpastetext then
   begin
   n:=clip__pastetextb;

   if strmatch(icolorsetsheader,strcopy1(n,1,low__len(icolorsetsheader))) then
      begin

      //init
      xprimeundo;

      n          :=strcopy1(n,low__len(icolorsetsheader)+1,low__len(n))+',';
      xcount     :=-1;
      lp         :=1;
      ci         :=xnextindex;//next color index
      dcolcount  :=0;
      //get
      if (ci>=0) then
         begin

         for p:=1 to low__len(n) do if (n[p-1+stroffset]=',') then
         begin
         str1:=strcopy1(n,lp,p-lp);

         //inc
         inc(xcount);//0..11

         //decide
         case xcount of
         //1st
         0:pic8__setcolor(icore^, ci, 0, strint32(str1));//elist
         1:pic8__setcolor(icore^, ci, 1, strint32(str1));//olist
         2:icore.flist[ci]        :=pic8__safeflashrate(strint32(str1));
         3:icore.lsmooth[ci]      :=pic8__safesmooth(strint32(str1));
         4:icore.lflick[ci]       :=pic8__safeflicker(strint32(str1));
         5:icore.lflickrate[ci]   :=pic8__safeflashrate(strint32(str1));
         //2nd
         6:pic8__setcolor(icore^, ci, 2, strint32(str1));//elist2
         7:pic8__setcolor(icore^, ci, 3, strint32(str1));//olist2
         8:icore.flist2[ci]       :=pic8__safeflashrate(strint32(str1));
         9:icore.lsmooth2[ci]     :=pic8__safesmooth(strint32(str1));
         10:icore.lflick2[ci]     :=pic8__safeflicker(strint32(str1));
         11:begin
            icore.lflickrate2[ci] :=pic8__safeflashrate(strint32(str1));
            inc(dcolcount);

            //next color index
            ci:=xnextindex;
            if (ci<0) then break;

            //reset
            xcount:=-1;
            end;
         end;//case

         //check
         if (ci<0) then break;

         //lp
         lp:=p+1;
         end;//p

         end;

      //store undo
      xchanged;

      //check correct number of colors were used
      if (dcolcount<pic8_progressColorsPerSlot) then gui.poperror('','Some colors were missing from the color set');
      
      end;
   end;
end;

procedure tpal8.copycolor;
var
   fok:boolean;
   fi:longint;
begin
//check
if not findex(fi,fok) then exit;

//get
clip__copytext(
icolorsetsheader+

//1st
intstr32(pic8__getcolor(icore^, fi, 0))+','+//elist
intstr32(pic8__getcolor(icore^, fi, 1))+','+//olist
intstr32(icore.flist[fi])+','+
intstr32(icore.lsmooth[fi])+','+
intstr32(icore.lflick[fi])+','+
intstr32(icore.lflickrate[fi])+','+

//2nd
intstr32(pic8__getcolor(icore^, fi, 2))+','+//elist2
intstr32(pic8__getcolor(icore^, fi, 3))+','+//olist2
intstr32(icore.flist2[fi])+','+
intstr32(icore.lsmooth2[fi])+','+
intstr32(icore.lflick2[fi])+','+
intstr32(icore.lflickrate2[fi])
);
end;

procedure tpal8.pastecolor(xshiftright:boolean);
var
   str1,n:string;
   int1,lp,p,fi:longint;
begin
if clip__canpastetext then
   begin
   fi:=icore.findex;

   n:=clip__pastetextb;
   if strmatch(icolorsetsheader,strcopy1(n,1,low__len(icolorsetsheader))) then
      begin

      xprimeundo;
      n:=strcopy1(n,low__len(icolorsetsheader)+1,low__len(n))+',';
      int1:=0;
      lp:=1;

      for p:=1 to low__len(n) do if (n[p-1+stroffset]=',') then
         begin
         str1:=strcopy1(n,lp,p-lp);

         case int1 of
         //1st
         0:pic8__setcolor(icore^, fi, 0, strint32(str1));//elist
         1:pic8__setcolor(icore^, fi, 1, strint32(str1));//olist
         2:icore.flist[fi]:=pic8__safeflashrate(strint32(str1));
         3:icore.lsmooth[fi]:=pic8__safesmooth(strint32(str1));
         4:icore.lflick[fi]:=pic8__safeflicker(strint32(str1));
         5:icore.lflickrate[fi]:=pic8__safeflashrate(strint32(str1));
         //2nd
         6:pic8__setcolor(icore^, fi, 2, strint32(str1));//elist2
         7:pic8__setcolor(icore^, fi, 3, strint32(str1));//olist2
         8:icore.flist2[fi]:=pic8__safeflashrate(strint32(str1));
         9:icore.lsmooth2[fi]:=pic8__safesmooth(strint32(str1));
         10:icore.lflick2[fi]:=pic8__safeflicker(strint32(str1));
         11:begin
            icore.lflickrate2[fi]:=pic8__safeflashrate(strint32(str1));
            break;
            end;
         end;//case

         //inc
         lp:=p+1;
         inc(int1);
         end;//p

      if xshiftright and (ihost<>nil) then (ihost as ttex).findex:=frcrange32(fi+1,0,high(tlistcolor32));//13jul2025

      xchanged;
      end;
   end;
end;

function tpal8.getecolor(x:longint):tcolor32;
begin
if (icore<>nil) and (x>=0) and (x<=high(tlistcolor32)) then result:=pic8__getcolor32(icore^,x,0)//elist

else
   begin
   result.r:=0;
   result.g:=0;
   result.b:=0;
   result.a:=255;
   end;
end;

function tpal8.getocolor(x:longint):tcolor32;
begin
if (icore<>nil) and (x>=0) and (x<=high(tlistcolor32)) then result:=pic8__getcolor32(icore^,x,1)//olist
else
   begin
   result.r:=0;
   result.g:=0;
   result.b:=0;
   result.a:=255;
   end;
end;

function tpal8.getecolor2(x:longint):tcolor32;
begin
if (icore<>nil) and (x>=0) and (x<=high(tlistcolor32)) then result:=pic8__getcolor32(icore^,x,2)//elist2
else
   begin
   result.r:=0;
   result.g:=0;
   result.b:=0;
   result.a:=255;
   end;
end;

function tpal8.getocolor2(x:longint):tcolor32;
begin
if (icore<>nil) and (x>=0) and (x<=high(tlistcolor32)) then result:=pic8__getcolor32(icore^,x,3)//olist2
else
   begin
   result.r:=0;
   result.g:=0;
   result.b:=0;
   result.a:=255;
   end;
end;

procedure tpal8.setecolor(x:longint;c:tcolor32);
begin
if (icore<>nil) and (x>=0) and (x<=high(tlistcolor32)) then
   begin
   pic8__setcolor32(icore^,x,0,c);//elist
   low__irollone(icore.dataid);
   end;
end;

procedure tpal8.setocolor(x:longint;c:tcolor32);
begin
if (icore<>nil) and (x>=0) and (x<=high(tlistcolor32)) then
   begin
   pic8__setcolor32(icore^,x,1,c);//olist
   low__irollone(icore.dataid);
   end;
end;

procedure tpal8.setecolor2(x:longint;c:tcolor32);
begin
if (icore<>nil) and (x>=0) and (x<=high(tlistcolor32)) then
   begin
   pic8__setcolor32(icore^,x,2,c);//elist2
   low__irollone(icore.dataid);
   end;
end;

procedure tpal8.setocolor2(x:longint;c:tcolor32);
begin
if (icore<>nil) and (x>=0) and (x<=high(tlistcolor32)) then
   begin
   pic8__setcolor32(icore^,x,3,c);//olist2
   low__irollone(icore.dataid);
   end;
end;


//## tpre8 #####################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxx//eeeeeeeeeeeeeeeeeeeeeeeeee
constructor tpre8.create(xparent:tobject;xhost:tobject;xcore:ppiccore8);
begin
create2(xparent,xhost,xcore,true);
end;

constructor tpre8.create2(xparent:tobject;xhost:tobject;xcore:ppiccore8;xstart:boolean);
begin
//self
track__inc(satOther,1);
inherited create2(xparent,false);

//vars
ifasttimer     :=0;

if (xhost<>nil) and (xhost is ttex) then ihost:=xhost else ihost:=nil;

icore          :=xcore;
if (icore=nil) then showerror('Piccore8 not set in tpre8.create()');

ibuffer        :=misraw24(1,1);

//start
if xstart then start;
end;

destructor tpre8.destroy;
begin
try
//controls
freeobj(@ibuffer);

//self
inherited destroy;
track__inc(satOther,-1);
except;end;
end;

procedure tpre8.disconnect;
begin
ihost:=nil;
icore:=nil;
end;

procedure tpre8._ontimer(sender:tobject);
begin

//ifasttimer
if (ms64>=ifasttimer) then
   begin
   if ((ihost<>nil) and (ihost as ttex).omustpaint1) then
      begin
      (ihost as ttex).omustpaint1:=false;
      paintnow;
      end;

   //reset
   ifasttimer:=ms64+low__aorb(100,30,game_subframes);
   end;

end;

procedure tpre8._onpaint(sender:tobject);
label
   skipend;
var
   s:tclientinfo;
   a:tdrawfastinfo;
   dh,xpad,ypad,ypad2,dx,dy:longint;

   procedure vsep;
   begin
   inc(dy,ypad2);
   end;

   procedure dpreview(dzoom:longint);
   begin
   //preview 1:dzoom
   ldt1(s.back,s.cs,dx,dy,s.font,'Preview 1:'+intstr32(dzoom),s.fn,s.f,false);
   inc(dy,s.fnH+ypad);

   ldc(s.cs,dx,dy,misw(ibuffer)*dzoom,mish(ibuffer)*dzoom,misarea(ibuffer),ibuffer,255,0,clnone,0);
   inc(dy,mish(ibuffer)*dzoom);
   vsep;
   end;

   procedure hstrip(xcap:string;dzoom:longint);
   var
      p:longint;
   begin
   if (xcap<>'') then
      begin
      ldt1(s.back,s.cs,dx,dy,s.font,xcap,s.fn,s.f,false);
      inc(dy,s.fnH+ypad);
      end;

   for p:=1 to 10 do
   begin
   ldc(s.cs,dx,dy,misw(ibuffer)*dzoom,mish(ibuffer)*dzoom,misarea(ibuffer),ibuffer,255,0,clnone,0);
   inc(dx,misw(ibuffer)*dzoom);
   if (dx>=s.ci.right) then break;
   end;

   inc(dy,mish(ibuffer)*dzoom);
   dx:=xpad;
   end;
begin
try
//init
infovars(s);
xpad :=2*s.zoom;
ypad :=2*s.zoom;
ypad2:=10*s.zoom;

//lds(cs,random(max16),false);

//cls
lds(s.cs,s.back,false);

//check
if (icore=nil) then goto skipend;

//init
dy:=xpad;
dx:=xpad;
dh:=icore.h;

//size
if (misw(ibuffer)<>icore.w) or (mish(ibuffer)<>icore.h) then missize(ibuffer,icore.w,icore.h);//?????????

//draw
a.core      :=@icore^;
a.clip      :=misarea(ibuffer);
a.rs24      :=ibuffer.prows24;
a.x         :=0;
a.y         :=0;
a.xzoom     :=1;
a.yzoom     :=1;
a.power255  :=255;
a.mirror    :=false;
a.flip      :=false;

pic8__drawfast(a);

//misclsarea(ibuffer, misarea(ibuffer), rgba0__int(0,100+random(156),0) );//lime


//speed test - debug only
{
xslot:=game__spritenew2(icore^);//add to slot
game__speedtest(xslot,0,0);
game__slotdel(xslot);//clear slot
mis__copyfast82432(maxarea,0,0,misw(ibuffer),mish(ibuffer),misarea(ibuffer),ibuffer,game_buffer);
}

//previews
dpreview(1);//100%
if (dh<=64) then dpreview(2);//200%
if (dh<=32) then dpreview(4);//400%

//horizontal strip
hstrip('Horizontal Strip 1:1',1);
vsep;

hstrip('Tiled 1:1',1);
hstrip('',1);
hstrip('',1);
hstrip('',1);
vsep;

hstrip('Tiled 1:2',2);
hstrip('',2);
hstrip('',2);
vsep;

skipend:
except;end;
end;


//## ttexedit ##################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//22222222222222222222222
constructor ttexedit.create(xparent:tobject);
begin
create2(xparent,false,true);
end;

constructor ttexedit.create2(xparent:tobject;xscroll,xstart:boolean);

   function t(x:array of byte):longint;
   begin
   result:=tep__addone20c(1,x)
   end;

   procedure maketoolpalette(xvertical:boolean;x:tbasictoolbar);
   var
      p:longint;
      
      procedure n;
      begin
      if xvertical then x.newline;
      end;
   begin
   if (x=nil) or (itex=nil) then exit;

   with x do
   begin
   halign:=1;//center

   add('Redo',tepredo20,0,'tex.redo','Redo last change');
   n;
   add('Undo',tepundo20,0,'tex.undo','Undo last change');
   n;

   for p:=0 to (itex.toolcount-1) do
   begin
   add( itex.toolcap[p], itex.toolitem[p].tep, 0, itex.toolcmd[p], itex.toolhelp[p] );
   n;
   end;//p

   end;//with

   end;

begin
//self
track__inc(satOther,1);
inherited create2(xparent,false,false);

//do not scroll the client area
noscroll;


//vars
iid             :=low__irollone(texedit_idcount);
bordersize      :=0;
oautoheight     :=true;
idisconnected   :=false;
isubframes      :=true;


//debug only
if system_debug then dbstatus(38,'Debug 010 - 21may2021_528am');//yyyy


//init
itimer100:=ms64;
itimer350:=ms64;
itimer500:=ms64;

//vars
iloaded:=false;
isettingsref:='';
inavshow:=true;
ipreviewshow:=true;
imustselectfile:='';

//controls
xhead.visible:=false;
xhead.add('Nav',tepnav20,0,'nav','Navigation Panel | Toggle navigation panel (left side)');
xhead.add('Preview',tepscreen20,0,'preview','Preview Panel | Toggle preview panel (right side)');
xhead.add('Sub Frames',tepplay20,0,'subframes','Toggle subframes for special effects - requires more CPU power');
xhead.add('New',tepnew20,0,'tex.new.prompt','New image...');
xhead.add('Save',tepsave20,0,'tex.save','Save changes');
xhead.add('Redo',tepredo20,0,'tex.redo','Redo last change');
xhead.add('Undo',tepundo20,0,'tex.undo','Undo last change');
xhead.add('Edit',tepedit20,0,'tex.edit','Show edit menu');
xhead.add('Copy',tepcopy20,0,'tex.copy','Copy sprite to Clipboard as plain text');
//xhead.add('Pcopy',tepCopy20,0,'pcopy','Copy sprite to Clipboard as a compressed pascal array');
xhead.add('Paste',teppaste20,0,'tex.paste','Paste plain text sprite from Clipboard');
xhead.add('Fit',teppaste20,0,'tex.paste.fit','Paste to fit plain text sprite from Clipboard');

//left column ------------------------------------------------------------------
with xcols.makecol(0,25,false) do
begin
//.play from folder
inavcap:=ntoolbar('Navigate files and folders on disk');
with inavcap do
begin
maketitle3('',false,false);
normal:=false;
add('Refresh',tepRefresh20,0,'refresh','Refresh list');
add('Fav',tepFav20,0,'nav.fav','Show favourites list');
add('Back',tepBack20,0,'nav.prev','Previous folder');
add('Forward',tepForw20,0,'nav.next','Next folder');
end;

inav:=nnav.makenavlist;
inav.hisname:='tex';
inav.omasklist:='*.pic8';//19jul2025
inav.oautoheight:=true;
inav.sortstyle:=nlName;//nlSize;
inav.style:=bnNavlist;
inav.ofindname:=true;//21feb2022
end;

xhead.xaddoptions;
xhead.xaddhelp;


//middle column ----------------------------------------------------------------
with xcols.makecol(1,60,false) do
begin
itex:=ttex.create(client);
end;//right

with xcols.makecol(2,10,true) do
begin
itoolset:=ntoolbar('');
normal:=false;

with itoolset do
begin
maketitle3('Tool',false,false);
oscaleh     :=0.95;
oscalevpad  :=0.75;
halign      :=0;
normal      :=false;
end;

itex.setbar:=itoolset;

end;

//right column -----------------------------------------------------------------
with xcols.makecol(3,20,false) do
begin
ipre:=tpre8.create(client,itex,itex.pcore);
ipre.oautoheight:=true;
end;


xgrad4;

with xhigh2 do
begin
itoolpal:=xtoolbar;
itoolpal.osquareframe:=true;

maketoolpalette(false,itoolpal);
ipal:=tpal8.create(client,itex,itex.pcore);

end;

with xstatus2 do
begin
bordersize:=0;

cellwidth[0]:=100;
cellwidth[1]:=100;
cellwidth[2]:=100;
cellwidth[3]:=50;
cellwidth[4]:=70;
cellwidth[5]:=300;//file
cellalign[5]:=1;
cellwidth[6]:=100;
end;

//connect
itex.pal:=ipal;

//start timer event
ibuildingcontrol:=false;

//events
itoolpal.onclick:=__onclick;
inavcap.onclick:=__onclick;

//start
if xstart then start;
end;

destructor ttexedit.destroy;
begin
try
//disconnect
disconnect;

//save any unsaved changes to image
itex.save;

//self
inherited destroy;
track__inc(satOther,-1);
except;end;
end;

function ttexedit.cansave:boolean;
begin
result:=(not idisconnected) and itex.cansave;
end;

procedure ttexedit.save;
begin
if cansave then itex.save;
end;

procedure ttexedit.disconnect;
begin

idisconnected   :=true;
onfetcheditor   :=nil;
ipre.disconnect;
ipal.disconnect;
itex.disconnect;
if gui.rootwin.xhavehead then gui.rootwin.xhead.onclick:=nil;//disconnect

end;

function ttexedit.xfileinuse(const xfilename:string):boolean;
var
   p:longint;
   v:tobject;
begin
//defaults
result:=false;

//get
if (xfilename<>'') and (not idisconnected) and assigned(fonfetcheditor) then
   begin

   for p:=0 to max32 do
   begin
   fonfetcheditor(self,p,v);

   if      (v=nil)                       then break
   else if (v<>self) and (v is ttexedit) then
      begin

      if strmatch( (v as ttexedit).filename, xfilename ) then
         begin
         result:=true;
         break;
         end;

      end;
   end;//p

   end;

end;

function ttexedit.filename:string;
begin
if (itex<>nil) then result:=itex.filename else result:='';
end;

function ttexedit.xnavfile:string;
begin
if (inav.valuestyle=nltFile) then result:=inav.value
else                              result:='';
end;

procedure ttexedit.xupdatebuttons;
var
   xok:boolean;

   procedure syncmainbar(x:tbasictoolbar);
   var
      bol1:boolean;
   begin
   //check
   if (x=nil) then exit;

   //get
   with x do
   begin
   bmarked2['subframes']        :=isubframes;
   bflash2['subframes']         :=isubframes;
   benabled2['tex.save']            :=itex.cansave;

   benabled2['tex.copy']            :=itex.cancopy;

   bol1                         :=itex.canpaste;
   benabled2['tex.paste']           :=bol1;
   benabled2['tex.paste.fit']       :=bol1;

   benabled2['tex.new.prompt']      :=itex.cannew;
   bmarked2['nav']              :=inavshow;
   bflash2['nav']               :=inavshow;
   bmarked2['preview']          :=ipreviewshow;
   bflash2['preview']           :=ipreviewshow;
   benabled2['tex.undo']            :=itex.canundo;
   benabled2['tex.redo']            :=itex.canredo;
   end;
   end;

   procedure synctoolpal(x:tbasictoolbar);
   var
      v:string;
      p:longint;
   begin
   //check
   if (x=nil) then exit;

   //get
   with x do
   begin

   v:=itex.toolcmd[ itex.tool ];
   for p:=0 to (itex.toolcount-1) do
   begin
   bmarked2 [ itex.toolcmd[p] ]:=(v=itex.toolcmd[p]);
   benabled2[ itex.toolcmd[p] ]:=xok;
   end;//p

{
   bol1:=xok and itex.canwrap;
   benabled2['wrap'] :=bol1;//????????????????????????????//removeme
   bmarked2['wrap']  :=bol1 and itex.owrap;
   bflash2['wrap']   :=bol1 and itex.owrap;

   bol1:=xok and itex.candither;//????????????????????????????//removeme
   benabled2['dither'] :=bol1;
   bmarked2['dither']  :=bol1 and itex.odither;
   bflash2['dither']   :=bol1 and itex.odither;
{}//xxxxxxxxxxxxxxx

   benabled2['tex.undo']:=itex.canundo;
   benabled2['tex.redo']:=itex.canredo;
   end;
   end;
begin
try
//get
xhead.omodified:=itex.modified and (not itex.locked);
xok:=not itex.locked;

//nav
if iloaded and (not inav.folderpending) and ( itex.ohostreload or (imustselectfile<>'') ) then
   begin
   //reload
   inav.reload;

   //select
   case (imustselectfile<>'') of
   true:inav.value:=inav.foldervalue+io__extractfilename(imustselectfile);
   else inav.value:=inav.foldervalue+io__extractfilename(itex.name);
   end;//case

   //reset
   imustselectfile:='';
   itex.ohostreload:=false;
   end;

itex.ofolder:=inav.folder;

xcols.vis[0]:=inavshow;
xcols.vis[3]:=ipreviewshow;

xcols.remcount[2]:=5+insint(3,inavshow)+insint(2,ipreviewshow);


//toolbars
if (not idisconnected) and gui.rootwin.xhavehead and visible then syncmainbar(gui.rootwin.xhead);

synctoolpal(itoolpal);

with inavcap do
begin
benabled2['nav.prev']:=inav.canprev;
benabled2['nav.next']:=inav.cannext;
end;

//status
xupdatecurpos;
xstatus2.celltext[1]:=k64(itex.width)+'w x '+k64(itex.height)+'h';
xstatus2.celltext[2]:=k64(itex.bytes)+' bytes';
xstatus2.celltext[3]:=insstr('Dither',itex.dither);
xstatus2.celltext[4]:=insstr( low__aorbstr('No Wrap','Wrap',itex.wrap), itex.canwrap);

xstatus2.celltext[5]:=strdefb(itex.name,'< No file selected >');
xstatus2.cellflash[5]:=(itex.name='');

//color palette
ipal.xsync;
except;end;
end;

procedure ttexedit.xupdatecurpos;
var
   v:string;
begin
if (itex.hoverindex>=0) then
   begin
   v:=itex.status__xy;
   end
else v:='';

if (xstatus2.celltext[0]<>v) then
   begin
   xstatus2.celltext[0]:=v;
   xstatus2.paintnow;
   end;
end;

procedure ttexedit.xshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
label
   skipend;

begin
try
//check
if zznil(xmenudata,5000) then exit;
//get

//main options
if (xstyle='') then
   begin
{
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
{}
   end;

skipend:
except;end;
end;

function ttexedit.xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
begin
//handled
result:=true;
//get
//if strmatch(strcopy1(xcode2,1,5),'list.') or (strcopy1(xcode2,1,5)='xbox.') or (xcode2='animateicon') or (xcode2='alwayson') or (xcode2='lshow') or (xcode2='lshowsep') or (xcode2='stop') or (xcode2='play') or (xcode2='saveas') or (xcode2='largejumptitle') or (xcode2='largejump') or (strcopy1(xcode2,1,11)='jumpstatus.') or (xcode2='autotrim') or (strcopy1(xcode2,1,11)='paintspeed.') or (strcopy1(xcode2,1,12)='paintspeed2.') or (strcopy1(xcode2,1,9)='holdmode.') or (strcopy1(xcode2,1,10)='holdmode2.') or (strcopy1(xcode2,1,7)='labels.') or (strcopy1(xcode2,1,7)='layout.') or (xcode2='autoplay') or (xcode2='refresh') or strmatch(strcopy1(xcode2,1,6),'intro:') or strmatch(strcopy1(xcode2,1,3),'ff:') or strmatch(strcopy1(xcode2,1,9),'volboost:') then xcmd(nil,0,xcode2)
//else result:=false;
end;

procedure ttexedit.loadsettings(a:tvars8);
var
   n:string;
begin
//check
if (a=nil) then exit;

try
//init
n:='tex'+k64(iid)+'.';

//get
isubframes            :=a.bdef(n+'subframes',true);
inavshow              :=a.bdef(n+'navshow',true);
ipreviewshow          :=a.bdef(n+'previewshow',true);
inew_width            :=pic8__safewh(a.idef(n+'new.w',32));
inew_height           :=pic8__safewh(a.idef(n+'new.w',32));
itex.tool             :=a.idef(n+'tool',0);
itex.f                :=a.idef(n+'f',1);
itex.b                :=a.idef(n+'b',0);
itex.toolsettings     :=a.sdef(n+'toolsettings','');
itex.xboxcontroller   :=a.idef(n+'xboxcontroller',1);
itex.xboxfeedback     :=a.bdef(n+'xboxfeedback',false);
//.nav
imustselectfile       :=a.sdef(n+'name','');
inav.xfromprg2(n+'nav',a);//prg -> nav -> a
inav.folder           :=io__readportablefilename(io__asfolderNIL( a.sdef(n+'folder','') ));

//read
itex.oscrollcolor:=true;//don't auto scroll to color till now -> all settings have been loaded

//sync
xupdatebuttons;
iloaded:=true;
except;end;
end;

procedure ttexedit.savesettings(a:tvars8);
var
   n:string;
begin
//check
if (a=nil)     then exit;
if not iloaded then exit;

try
//init
n:='tex'+k64(iid)+'.';

//get
a.b[n+'subframes']       :=isubframes;
a.b[n+'navshow']         :=inavshow;
a.b[n+'previewshow']     :=ipreviewshow;
a.i[n+'new.w']           :=inew_width;
a.i[n+'new.w']           :=inew_height;
a.i[n+'tool']            :=itex.tool;
a.i[n+'f']               :=itex.f;
a.i[n+'b']               :=itex.b;
a.s[n+'toolsettings']    :=itex.toolsettings;
a.i[n+'xboxcontroller']  :=itex.xboxcontroller;
a.b[n+'xboxfeedback']    :=itex.xboxfeedback;
//.nav
a.s[n+'name']            :=io__extractfilename(xnavfile);//active filename
a.s[n+'folder']          :=io__makeportablefilename(inav.foldervalue);
inav.xto(inav,a,n+'nav');

except;end;
end;

procedure ttexedit.__onclick(sender:tobject);
begin

if (sender<>nil) and (sender is tbasictoolbar) then
   begin

   //nav toolbar handler 1st
   if (not strmatch( (sender as tbasictoolbar).ocode2, 'nav.refresh' )) and inav.xoff_toolbarevent(sender as tbasictoolbar) then exit;

   //command
   xcmd( (sender as tbasictoolbar).ocode2 );

   end;

end;

procedure ttexedit.xcmd(n:string);
label
   redo,skipend;
var
   a:tstr8;
   xresult:boolean;
   v,e:string;

   function m(const xname:string):boolean;//full match
   begin
   result:=strmatch(n,xname);
   end;

   function pm(const xname:string):boolean;//partial match
   begin
   result:=strmatch(strcopy1(n,1,low__len(xname)),xname);
   if result then v:=strcopy1(n,low__len(xname)+1,low__len(n));
   end;
begin//use for testing purposes only - 15mar2020
//defaults
xresult   :=true;
e         :=gecTaskfailed;
a         :=nil;

try
//init
n      :=strlow(n);
v      :='';

//get
if m('refresh') or m('nav.refresh') then//override "inav" refresh without our own
   begin
   inav.reload;
   end
else if m('nav')           then inavshow:=not inavshow
else if m('preview')       then ipreviewshow:=not ipreviewshow
else if pm('tool.')        then itex.xcmd(n)
else if pm('tex.')         then itex.xcmd(v)
else if m('color.copy')    then ipal.copycolor
else if m('color.paste')   then ipal.pastecolor(false)
else if m('color.paste+1') then ipal.pastecolor(true)
else if m('subframes')     then isubframes:=not isubframes
else
   begin
   if system_debug then showbasic('Unknown Command>'+n+'<<');
   end;
skipend:

except;end;
try
//free
str__free(@a);

//sync
xupdatebuttons;

//error
if not xresult then gui.poperror('',e);
except;end;
end;

procedure ttexedit._ontimer(sender:tobject);
label
   skipend;
var
   v:string;
begin
try

//timer100
if (ms64>=itimer100) then
   begin

   if iloaded and visible then
      begin
      v:=xnavfile;

      case xfileinuse(v) of
      true:begin
         itex.ofileinuse:=true;
         itex.loadfromfile('');
         end;
      else begin
         itex.ofileinuse:=false;
         if not strmatch(v,itex.filename) then itex.loadfromfile(v);
         end;
      end;//case

      //subframes
      if (isubframes<>game__subframes) then game__setsubframes(isubframes);
      end;


   //update cursor position information
   xupdatecurpos;


   //sync with main toolbar
   if (not idisconnected) and (gui.rootwin.page=opagename) and gui.rootwin.xhavehead and (gui.rootwin.xhead.tag<>iid) then
      begin
      gui.rootwin.xhead.onclick:=__onclick;
      gui.rootwin.xhead.tag:=iid;
      gui.rootwin.xhead.copyitemsfrom3( xhead, gui.rootwin.xhead.otag2, tsiUser);
      //sync toolbar button states immediately
      xupdatebuttons;
      end;


   //reset
   itimer100:=ms64+100;
   end;


//timer350
if (ms64>=itimer350) then
   begin
   //page
   xupdatebuttons;

   //reset
   itimer350:=ms64+350;
   end;

//timer500
if (ms64>=itimer500) then
   begin
   //savesettings
   //xxxxxxxxxxxxxxxxxx//??????????????????xautosavesettings;

   //reset
   itimer500:=ms64+500;
   end;

skipend:
except;end;
end;


//## ttex ######################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//1111111111111111111111111111111
constructor ttex.create(xparent:tobject);
begin
create2(xparent,true);
end;

constructor ttex.create2(xparent:tobject;xstart:boolean);
var
   p:longint;
begin
//self
track__inc(satOther,1);
inherited create2(xparent,false);

//vars
idisconnected :=false;
isetbar       :=nil;
itimer500     :=ms64;

iselcol32.r   :=255;//modified via flash timer
iselcol32.g   :=0;
iselcol32.b   :=0;
iselcol32.a   :=100;

iflashon      :=false;
iflashontimer :=0;

izoomlimit    :=400;
izoom         :=0;//fit window
izoominref    :='';
izoominxy     :=low__point(0,0);

iframesize    :=1;

idownscrollx  :=0;
idownscrolly  :=0;

iscrollx      :=0;
iscrolly      :=0;

ibytes        :=0;
isizelimit    :=pic8__safewh(max32);
onewwidth     :=32;//13jul2025
onewheight    :=32;
oscrollcolor  :=false;
ohostreload   :=true;
iflashref     :='';
ofileinuse    :=false;
obadfile      :=false;
ofolder       :='';
omustpaint1   :=false;
ilist         :=tdynamicpoint.create;
ibuffer24     :=misraw24(1,1);
icantool      :=false;
itooldownxy   :=low__point(0,0);
itoollastx    :=0;
itoollasty    :=0;
itoolval      :=0;
ifilename     :='';
iname         :='';
ipreview      :=nil;
pic8__init(icore,onewwidth,onewheight);
pic8__init(iover,onewwidth,onewheight);
pic8__init(ioversel,onewwidth,onewheight);
pic8__init(itemp,onewwidth,onewheight);
pic8__init(isel ,onewwidth,onewheight);
pic8__init(iselfinal,onewwidth,onewheight);
iref          :='';
ipainttimer   :=ms64;
itimerfast    :=ms64;
icanvasxy     :=low__point(0,0);
idragindex    :=0;
ihoverindex   :=-1;
ilastokindex  :=0;
ocanshowmenu  :=true;

//.create tools
xcreatetools;

//.xbox support
ixboxcontroller:=0;
ixboxfeedback  :=false;

//palette cell areas
for p:=0 to high(iparea) do iparea[p]:=nilarea;

//hold slots
for p:=0 to high(ihold) do ihold[p]:=false;

//undo support
iundotemp_dataid:=0;
iundotemp_data:='';
iundoinfo:=str__new8;
for p:=0 to high(iundolist) do iundolist[p]:='';
xundo__init;

//defaults
setparams2(onewwidth,onewheight,true,true,true);
oautoheight  :=true;

//start
if xstart then start;
end;

destructor ttex.destroy;
begin
try
//disconnect
disconnect;

//save image
save;

//controls
freeobj(@ipreview);
str__free(@iundoinfo);
freeobj(@ilist);

//self
inherited destroy;
track__inc(satOther,-1);
except;end;
end;

procedure ttex.setsetbar(x:tbasictoolbar);
begin
if (x<>nil) and (not idisconnected) and (x<>isetbar) then
   begin
   isetbar:=x;
   isetbar.tag:=-1;
   xsetbarfill;
   end;
end;

procedure ttex.xcreatetools;

   procedure vset(xname:string;xindex,xtep:longint;const xhelp:string);
   var
      p,i:longint;

      function xcandraw:boolean;
      begin

      case xindex of
      ttcSel,ttcErase,ttcPen,ttcDrag,ttcPot,ttcGPot,ttcCls,ttcRect,ttcLine :result:=true;
      else                                                  result:=false;
      end;//case

      end;

      function xcandither:boolean;
      begin

      case xindex of
      ttcSel,ttcErase,ttcPen,ttcDrag,ttcPot,ttcGPot,ttcCls,ttcRect,ttcLine: result:=true;
      else                                                  result:=false;
      end;//case

      end;

      function xcanwrap:boolean;
      begin

      case xindex of
      ttcMove: result:=true;
      else     result:=false;
      end;//case

      end;

      function xcanfast:boolean;
      begin

      case xindex of
      ttcHand,ttcZoom: result:=true;
      else             result:=false;
      end;//case

      end;

      function xcanzoomin:boolean;
      begin

      case xindex of
      ttcZoom: result:=true;
      else     result:=false;
      end;//case

      end;

      function xcanmovexy:boolean;
      begin

      case xindex of
      ttcMove,ttcHand,ttcErase,ttcPen,ttcDrag: result:=true;
      else                                     result:=false;
      end;//case

      end;

      function xcanmovestyle:boolean;
      begin

      case xindex of
      ttcMove: result:=true;
      else     result:=false;
      end;//case

      end;

      function xpenclass:boolean;
      begin

      case xindex of
      ttcSel,ttcErase,ttcPen,ttcDrag: result:=true;
      else                            result:=false;
      end;//case

      end;

      function xuseonce:boolean;
      begin

      case xindex of
      ttcEye: result:=true;
      else    result:=false;
      end;//case

      end;

      function xcanselmode:boolean;
      begin

      case xindex of
      ttcSel: result:=true;
      else    result:=false;
      end;//case

      end;
   begin

   //check
   if (xindex<0) or (xindex>high(itoollist.tools)) then exit;

   //get
   i:=xindex;

   //.name
   for p:=1 to frcmax32(low__len(xname),sizeof(itoollist.tools[i].name)) do itoollist.tools[i].name[p-1]:=xname[p-1+stroffset];
   //.info
   itoolcap[i]                      :=xname;//cap
   itoolcmd[i]                      :='tool.'+intstr32(i);
   itoolhelp[i]                     :='Tool - '+xname+'|'+xhelp;
   itoollist.tools[i].inuse         :=true;
   itoollist.tools[i].tep           :=xtep;
   itoollist.tools[i].candraw       :=xcandraw;
   itoollist.tools[i].candither     :=xcandither;
   itoollist.tools[i].canwrap       :=xcanwrap;
   itoollist.tools[i].canzoomin     :=xcanzoomin;
   itoollist.tools[i].canfast       :=xcanfast;
   itoollist.tools[i].canmovexy     :=xcanmovexy;
   itoollist.tools[i].penclass      :=xpenclass;
   itoollist.tools[i].canuseonce    :=xuseonce;
   itoollist.tools[i].canselmode    :=xcanselmode;
   itoollist.tools[i].canmovestyle  :=xcanmovestyle;

   //set
   itoollist.count:=largest32(xindex+1,itoollist.count);

   //tool in use
   if (xindex=ttcPen) then
      begin
      itoollist.tool      :=xindex;
      itoollist.lasttool  :=xindex;
      end;

   end;
begin

//clear
low__cls(@itoollist,sizeof(itoollist));

//get
vset('Zoom',ttcZoom,tepNew20,'Zoom canvas in (make larger) or zoom out (make smaller)');
vset('Hand',ttcHand,tepNew20,'Reposition a large canvas');
vset('Erase',ttcErase,tepPen20,'Erase color from canvas');
vset('Sel',ttcSel,tepNew20,'Selection control');
vset('Pen',ttcPen,tepPen20,'Draw color on canvas.  Left click to draw foreground color, right click for background color.');
vset('Drag',ttcDrag,tepDrag20,'Draw using color beneath cursor');
vset('Line',ttcLine,tepLine20,'Draw a line');
vset('Rect',ttcRect,tepRect20,'Draw a rectangle');
vset('Pot',ttcPot,tepPot20,'Fill an area with color');
vset('GPot',ttcGPot,tepGPot20,'Fill all areas with color');
vset('Eye',ttcEye,tepEyedropper20,'Get color from canvas');
vset('Move',ttcMove,tepMove20,'Move canvas pixels');
vset('Cls',ttcCls,tepCls20,'Clear the canvas');

end;

function ttex.xcanhand:boolean;
begin
result:=(not locked) and (izoom>=1) and ( ((activezoom*icore.w)>clientwidth) or ((activezoom*icore.h)>clientheight) );
end;
//xxxxxxxxxxxxxxxxxxxxxxxx//tttttttttttttttttttttttttt//??
procedure ttex.xsetbarfill;
var
   x:tbasictoolbar;

   procedure xadd(xcap:string;xtep:longint;xcmd,xhelp:string);
   begin
   x.newline;
   x.add(xcap,xtep,0,xcmd,xhelp);
   end;
begin
//check
if idisconnected or (isetbar=nil) or (isetbar.tag=tool) then exit;

//init
x         :=isetbar;
x.tag     :=tool;
x.clear;
x.onclick :=__onclick;

//caption
x.caption :=activetoollabel;

//fill
if candither            then xadd('Dither',tepnew20,'dither','');
if canwrap              then xadd('Wrap',tepnew20,'wrap','');
if canfast              then xadd('Fast',tepnew20,'fast','');
if canzoomin            then xadd('Zoom In',tepnew20,'zoomin','');
if canmovexy then
   begin
   xadd('Move XY',tepnew20,'movexy.0','');
   xadd('Move X', tepnew20,'movexy.1','');
   xadd('Move Y', tepnew20,'movexy.2','');
   end;
if canmovestyle then
   begin
   xadd('Move Col+Sel',tepnew20,'movestyle.0','');
   xadd('Move Col', tepnew20,'movestyle.1','');
   xadd('Move Sel', tepnew20,'movestyle.2','');
   end;
if canuseonce           then xadd('Use Once',tepnew20,'useonce','');

//dynamic
case tool of
ttcZoom:begin
   xadd('Fit',tepZoom20,'zoomto.0','');
   xadd('1x',tepZoom20,'zoomto.1','');
   xadd('2x',tepZoom20,'zoomto.2','');
   xadd('4x',tepZoom20,'zoomto.4','');
   xadd('8x',tepZoom20,'zoomto.8','');
   xadd('12x',tepZoom20,'zoomto.12','');
   xadd('16x',tepZoom20,'zoomto.16','');
   xadd('20x',tepZoom20,'zoomto.20','');
   xadd('36x',tepZoom20,'zoomto.36','');
   xadd('50x',tepZoom20,'zoomto.50','');
   xadd('100x',tepZoom20,'zoomto.100','');
   xadd('200x',tepZoom20,'zoomto.200','');
   xadd('300x',tepZoom20,'zoomto.300','');
   xadd('400x',tepZoom20,'zoomto.400','');
   end;
ttcHand:begin
   xadd('Center',tepNew20,'handto.center','');
   xadd('Left',tepNew20,'handto.left','');
   xadd('Right',tepNew20,'handto.right','');
   xadd('Top',tepNew20,'handto.top','');
   xadd('Bottom',tepNew20,'handto.bottom','');
   end;
ttcSel:begin
   xadd('Clear',tepNew20,'sel.clear','');
   xadd('Select All',tepSelectAll20,'sel.all','');
   xadd('Invert',tepInvert20,'sel.invert','');
   xadd('Off',tepNew20,'selmode.'+intstr32(tscSeloff),'');
   xadd('Edit',tepNew20,'selmode.'+intstr32(tscSeledit),'');
   xadd('Block',tepNew20,'selmode.'+intstr32(tscSelblock),'');
   end;
end;//case

//sync
xsetbarsync;

//full realign/paint
gui.fullalignpaint;

end;

procedure ttex.xsetbarsync;
var
   x:tbasictoolbar;
   xok:boolean;
   int1:longint;
   bol1:boolean;
begin

//check
if idisconnected or (isetbar=nil) then exit;

//init
x         :=isetbar;
xok       :=not locked;

//caption
x.caption:=activetoollabel;

//get
x.benabled2['dither']   :=xok;
x.benabled2['wrap']     :=xok;
x.benabled2['fast']     :=xok;

x.bmarked2['dither']    :=dither;
x.bmarked2['wrap']      :=wrap;
x.bmarked2['fast']      :=fast;

x.benabled2['movexy.0']   :=xok;
x.benabled2['movexy.1']   :=xok;
x.benabled2['movexy.2']   :=xok;

x.bmarked2['movexy.0']    :=(movexy=tscMoveXY);
x.bmarked2['movexy.1']    :=(movexy=tscMoveXonly);
x.bmarked2['movexy.2']    :=(movexy=tscMoveYonly);

x.benabled2['movestyle.0']   :=xok;
x.benabled2['movestyle.1']   :=xok;
x.benabled2['movestyle.2']   :=xok;

x.bmarked2['movestyle.0']    :=(movestyle=tscMoveBoth);
x.bmarked2['movestyle.1']    :=(movestyle=tscMoveCol);
x.bmarked2['movestyle.2']    :=(movestyle=tscMoveSel);

x.benabled2['useonce']    :=xok;
x.bmarked2['useonce']     :=useonce;

//.tool specific
case tool of

ttcZoom:begin

   x.benabled2['zoomin']       :=xok;
   x.benabled2['zoomto.0']     :=xok;;
   x.benabled2['zoomto.1']     :=xok;
   x.benabled2['zoomto.2']     :=xok;
   x.benabled2['zoomto.4']     :=xok;
   x.benabled2['zoomto.8']     :=xok;
   x.benabled2['zoomto.12']    :=xok;
   x.benabled2['zoomto.16']    :=xok;
   x.benabled2['zoomto.20']    :=xok;
   x.benabled2['zoomto.36']    :=xok;
   x.benabled2['zoomto.50']    :=xok;
   x.benabled2['zoomto.100']   :=xok;
   x.benabled2['zoomto.200']   :=xok;
   x.benabled2['zoomto.300']   :=xok;
   x.benabled2['zoomto.400']   :=xok;

   x.bmarked2['zoomin']        :=zoomin;
   x.bmarked2['zoomto.0']      :=(izoom<=0);
   x.bmarked2['zoomto.1']      :=(izoom=1);
   x.bmarked2['zoomto.2']      :=(izoom=2);
   x.bmarked2['zoomto.4']      :=(izoom=4);
   x.bmarked2['zoomto.8']      :=(izoom=8);
   x.bmarked2['zoomto.12']     :=(izoom=12);
   x.bmarked2['zoomto.16']     :=(izoom=16);
   x.bmarked2['zoomto.20']     :=(izoom=20);
   x.bmarked2['zoomto.36']     :=(izoom=36);
   x.bmarked2['zoomto.50']     :=(izoom=50);
   x.bmarked2['zoomto.100']    :=(izoom=100);
   x.bmarked2['zoomto.200']    :=(izoom=200);
   x.bmarked2['zoomto.300']    :=(izoom=300);
   x.bmarked2['zoomto.400']    :=(izoom=400);

   end;

ttcHand:begin

   bol1                         :=xcanhand;
   int1                         :=movexy;
   x.benabled2['handto.center'] :=bol1 and (int1=tscMoveXY);
   x.benabled2['handto.left']   :=bol1 and (int1<>tscMoveYonly);
   x.benabled2['handto.right']  :=bol1 and (int1<>tscMoveYonly);
   x.benabled2['handto.top']    :=bol1 and (int1<>tscMoveXonly);
   x.benabled2['handto.bottom'] :=bol1 and (int1<>tscMoveXonly);

   end;

ttcSel:begin

   x.benabled2['sel.clear']                            :=xok;
   x.benabled2['sel.all']                              :=xok;
   x.benabled2['sel.invert']                           :=xok;
   x.benabled2['selmode.'+intstr32(tscSeloff)]         :=xok;
   x.benabled2['selmode.'+intstr32(tscSeledit)]        :=xok;
   x.benabled2['selmode.'+intstr32(tscSelblock)]       :=xok;


   int1                                                :=selmode;
   x.bmarked2['selmode.'+intstr32(tscSeloff)]          :=(int1=tscSeloff);
   x.bmarked2['selmode.'+intstr32(tscSeledit)]         :=(int1=tscSeledit);
   x.bmarked2['selmode.'+intstr32(tscSelblock)]        :=(int1=tscSelblock);

   end;
end;//case

end;

procedure ttex.__onclick(sender:tobject);
begin

if (sender<>nil) and (not idisconnected) and (sender is tbasictoolbar) then
   begin

   //command
   xcmd((sender as tbasictoolbar).ocode2);
   if (sender=isetbar) then xsetbarsync;

   //refocus canvas
   setfocus;

   end;

end;

function ttex.xcmd(n:string):boolean;
label
   skipend;
var
   a:tstr8;
   v,e:string;

   function m(const xname:string):boolean;//full match
   begin
   result:=strmatch(n,xname);
   end;

   function pm(const xname:string):boolean;//partial match
   begin
   result:=strmatch(strcopy1(n,1,low__len(xname)),xname);
   if result then v:=strcopy1(n,low__len(xname)+1,low__len(n));
   end;
begin//use for testing purposes only - 15mar2020
//defaults
result  :=false;
e       :=gecTaskfailed;
a       :=nil;

try
//init
n       :=strlow(n);
v       :='';

//get
//.set tool
if pm('tool.')                then tool:=strint32(v)

//.tool support options
else if m('dither')           then dither:=not dither
else if m('wrap')             then wrap:=not wrap
else if m('fast')             then fast:=not fast
else if m('zoomin')           then zoomin:=not zoomin
else if pm('zoomto.')         then xzoomto(strint(v))
else if pm('movexy.')         then movexy:=strint(v)
else if pm('movestyle.')      then movestyle:=strint(v)
else if m('useonce')          then useonce:=not useonce
//.hand
else if m('handto.left')      then scrollx:=0
else if m('handto.right')     then scrollx:=(clientwidth div activezoom)-icore.w
else if m('handto.top')       then scrolly:=0
else if m('handto.bottom')    then scrolly:=(clientheight div activezoom)-icore.h
else if m('handto.center')    then
   begin
   scrollx:=((clientwidth  div activezoom)-icore.w) div 2;
   scrolly:=((clientheight div activezoom)-icore.h) div 2;
   end
//.sel
else if m('sel.clear')        then selclear
else if m('sel.all')          then selall
else if m('sel.invert')       then selinv
else if pm('selmode.')        then selmode:=strint(v)
//.other
else if m('new.prompt')       then newprompt
else if m('redo')             then redo
else if m('undo')             then undo
else if m('edit')             then menu__edit
else if m('copy')             then copy
else if m('pcopy')            then pcopy
else if m('paste')            then paste
else if m('paste.fit')        then pastefit
else if m('save')             then save
else
   begin

   end;



//successful
result:=true;
skipend:
except;end;
//free
freeobj(@a);
end;

procedure ttex.setzoom(x:longint);
begin
izoom:=frcrange32(x,0,100);

//sync
xsetbarsync;
end;

function ttex.activezoom:longint;
begin
if (izoom<=0) then result:=frcrange32(smallest32( clientwidth div frcmin32(icore.w,1), clientheight div frcmin32(icore.h,1) ),1,izoomlimit)
else               result:=izoom;
end;

function ttex.activeselmode:longint;
begin
if      (tool=ttcSel)                      then result:=low__aorb(tscSeloff,tscSeledit, itoollist.tools[tool].selmode<>tscSeloff)
else if itoollist.tools[ttcSel].canselmode then result:=frcrange32(itoollist.tools[ttcSel].selmode,0,2)
else                                            result:=tscSeloff;
end;

function ttex.activescrollx:longint;
begin
if ((activezoom*icore.w)<=clientwidth) then
   begin
   result:=((clientwidth div activezoom)-frcmin32(icore.w,1)) div 2;
   end
else result:=scrollx;
end;

function ttex.activescrolly:longint;
begin
if ((activezoom*icore.h)<=clientheight) then
   begin
   result:=((clientheight div activezoom)-frcmin32(icore.h,1)) div 2;
   end
else result:=scrolly;
end;

function ttex.getscrollx:longint;
begin
result:=frcrange32(iscrollx,-icore.w+2,(clientwidth div frcmin32(izoom,1))-2);
end;

function ttex.getscrolly:longint;
begin
result:=frcrange32(iscrolly,-icore.h+2,(clientheight div frcmin32(izoom,1))-2);
end;

procedure ttex.setscrollx(x:longint);
begin
iscrollx:=frcrange32(x,-icore.w+2,(clientwidth div frcmin32(izoom,1))-2);
end;

procedure ttex.setscrolly(x:longint);
begin
iscrolly:=frcrange32(x,-icore.h+2,(clientheight div frcmin32(izoom,1))-2);
end;

procedure ttex.xsyncbytes;
begin
ibytes:=low__len(pic8__todata(icore));
end;

procedure ttex.disconnect;
begin
idisconnected  :=true;
isetbar        :=nil;
ipal           :=nil;
end;

procedure ttex.setpal(x:tobject);
begin
if      (x=nil)      then ipal:=nil
else if (x is tpal8) then ipal:=x;
end;

procedure ttex.sethold(xindex:longint;xval:boolean);
begin
if (xindex>=0) and (xindex<=high(tprogresslist)) then ihold[xindex]:=xval;
end;

function ttex.gethold(xindex:longint):boolean;
begin
if (xindex>=0) and (xindex<=high(tprogresslist)) then result:=ihold[xindex] else result:=false;
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//??????????????????????????//1111111111111111111111111111111
procedure ttex.xbox;
var
   ci:longint;
   v:double;

   procedure xsetstate2(xindex:longint;l,r:double);
   begin
   if ixboxfeedback then xbox__setstate2(xindex,l,r);
   end;

   procedure sv(xindex:longint;v:double);
   begin
   if (not ihold[xindex]) and (xindex>=0) and (xindex<=high(tprogresslist)) then icore.progress[xindex]:=v;
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

   //.left stick x -> progress[0] and progress[1]
   v:=xbox__info(ci).lx;
   if (v>0) then
      begin
      sv(0,0);
      sv(1,v);
      end
   else if (v<0) then
      begin
      sv(0,-v);
      sv(1,0);
      end
   else
      begin
      sv(0,0);
      sv(1,0);
      end;

   //.right stick x -> progress[2] and progress[3]
   v:=xbox__info(ci).rx;
   if (v>0) then
      begin
      sv(2,0);
      sv(3,v);
      end
   else if (v<0) then
      begin
      sv(2,-v);
      sv(3,0);
      end
   else
      begin
      sv(2,0);
      sv(3,0);
      end;

   //.left trigger -> progress[4]
   v:=xbox__info(ci).lt;
   sv(4,v);

   //.right trigger -> progress[5]
   v:=xbox__info(ci).rt;
   sv(5,v);
   end;
end;//ci

end;

function ttex.getfindex:longint;
begin
result:=icore.findex;
end;

function ttex.getbindex:longint;
begin
result:=icore.bindex;
end;

function ttex.havepal:tpal8;
begin
if (ipal<>nil) and (ipal is tpal8) then result:=(ipal as tpal8) else result:=nil;
end;

procedure ttex.setfindex(x:longint);
begin
icore.findex:=frcrange32(x,0,high(tlistcolor32));

if (havepal<>nil) and oscrollcolor then havepal.scrolltocolor(icore.findex);
end;

procedure ttex.setbindex(x:longint);
begin
icore.bindex:=frcrange32(x,0,high(tlistcolor32));

if (havepal<>nil) and oscrollcolor then havepal.scrolltocolor(icore.bindex);
end;

function ttex.getpcore:ppiccore8;
begin
result:=@icore;
end;

function ttex.getmodified:boolean;
begin
result:=icore.modified;
end;

function ttex.status__xy:string;
var
   a:tpoint;
begin
a:=pic8__findxy(icore,ihoverindex);
result:=k64(a.x)+'x , '+k64(a.y)+'y';
end;

procedure ttex.showmenuFill(xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
var
   m:tstr8;//pointer only
   bol1:boolean;
begin
try
//check
if zznil(xmenudata,2325) then exit else m:=xmenudata;
xmenuname:='tex.menu';

//init

//get
if (xstyle='edit') then
   begin
   //edit
   low__menutitle(m,tepnone,'Edit','Edit options');
   //.undo
   low__menuitem(m,tepRedo20,'Redo','Redo last change','redo',100,canredo);
   low__menuitem(m,tepUndo20,'Undo','Undo last change','undo',100,canundo);
   //.new
   low__menuitem(m,tepNew20,'New...','Create a new sprite','new',100,cannew);
   low__menuitem(m,tepNew20,'New Window','Run another app instance','new.app',100,cannew);
   //.copy
   bol1:=cancopy;
   low__menuitem(m,tepCopy20,'Copy','Copy sprite to Clipboard as plain text','copy',100,bol1);
   low__menuitem(m,tepCopy20,'Copy as Pascal Array','Copy sprite to Clipboard as a compressed pascal array','copy.array',100,bol1);
   low__menuitem(m,tepCopy20,'Copy as Image','Copy sprite to Clipboard as a bitmap image','copy.image',100,bol1);
   //.paste
   bol1:=canpaste;
   low__menuitem(m,tepPaste20,'Paste','Paste plain text sprite from Clipboard','paste',100,bol1);
   low__menuitem(m,tepPaste20,'Paste to Fit','Paste plain text sprite from Clipboard and fit to existing canvas','paste.fit',100,bol1);
   bol1:=icanpaste;
   low__menuitem(m,tepPaste20,'Paste from Image','Paste bitmap image from Clipboard','paste.image',100,bol1);
   //.delete
   bol1:=not locked;
   low__menuitem(m,tepClose20,'Delete All','Clear canvas','clear',100,bol1);

   //adjustments
   low__menutitle(m,tepnone,'Adjust','Adjustment options');
   bol1:=canadjust;
   low__menuitem(m,tepBMP20,'Mirror','Adjustment | Mirror sprite (flip horizontally)','mirror',100,bol1);
   low__menuitem(m,tepBMP20,'Flip','Adjustment | Flip sprite (flip vertically)','flip',100,bol1);
   low__menuitem(m,tepBMP20,'Rotate -90','Adjustment | Rotate left 90 degrees','rotate-90',100,bol1);
   low__menuitem(m,tepBMP20,'Rotate +90','Adjustment | Rotate right 90 degrees','rotate+90',100,bol1);
   low__menuitem(m,tepBMP20,'Rotate 180','Adjustment | Rotate 180 degrees','rotate+180',100,bol1);
   low__menuitem(m,tepBMP20,'Resize...','Adjustment | Resize canvas','resize',100,bol1);
   low__menuitem(m,tepBMP20,'Resize To Fit...','Adjustment | Resize canvas and fit sprite','resize.fit',100,bol1);

   //.xbox controller
   low__menutitle(m,tepnone,'Xbox Controller','Xbox controller options');
   low__menuitem3(m,tep__tick(ixboxcontroller=0),'Off','Xbox Controller | Do not use an Xbox Controller','xbox.0',100,aknone,false,true);
   low__menuitem3(m,tep__tick(ixboxcontroller=1),'Active Only','Xbox Controller | Control Cynthia with an Xbox Controller whilst in the foreground (active)','xbox.1',100,aknone,false,true);
   low__menuitem3(m,tep__tick(ixboxcontroller=2),'Active and Inactive','Xbox Controller | Control Cynthia with an Xbox Controller whilst in the foreground (active) or in the background (inactive)','xbox.2',100,aknone,false,true);
   low__menuitem3(m,tep__yes(ixboxfeedback),'Feedback','Xbox Controller | Send vibration feedback to the Xbox controller','xbox.f',100,aknone,false,true);
   end;
except;end;
end;

procedure ttex.setxboxcontroller(x:longint);
begin
ixboxcontroller:=frcrange32(x,0,2);
end;

procedure ttex.newprompt;
label
   newredo;
var
   b:array[0..2] of string;
   df:string;
   dw,dh:longint;
begin
//check
if not cannew then exit;

//get
b[0]:='';
//was: b[1]:=intstr32(onewwidth);
//was: b[2]:=intstr32(onewheight);
b[1]:=intstr32(icore.w);//use current image's width/height for initial new width/height - 13jul2025
b[2]:=intstr32(icore.h);

newredo:
if gui.popmanyedit2(3,b,tepIcon24,'New Sprite',['Name','Width','Height'],['Name | Type a name for your sprite','Width in pixels in range 1 to '+k64(isizelimit),'Height in pixels in range 1 to '+k64(isizelimit)],'','',0) then
   begin
   dw:=strint32(b[1]);
   dh:=strint32(b[2]);

   b[0]:=io__safename(b[0]);
   if (b[0]='') then
      begin
      gui.popinfo('Name','You must type a name for your sprite.');
      goto newredo;
      end;

   df:=ofolder+b[0]+'.pic8';
   if io__fileexists(df) then
      begin
      gui.popinfo('Name','A sprite with that name already exists.  Use another name.');
      goto newredo;
      end;

   if (dw<1) then dw:=20 else dw:=frcrange32(dw,1,isizelimit);
   if (dh<1) then dh:=20 else dh:=frcrange32(dh,1,isizelimit);

   onewwidth:=dw;
   onewheight:=dh;

   new(df,dw,dh);
   end;
end;

function ttex.showmenuClick(sender:tobject;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
var
   b:array[0..2] of string;
   dw,dh:longint;
begin
//handled
result:=true;

try
//get
if      (xcode2='new')         then newprompt
else if (xcode2='new.app')     then runlow(io__exename,'')
else if (xcode2='redo')        then redo
else if (xcode2='undo')        then undo
else if (xcode2='copy')        then copy
else if (xcode2='copy.array')  then pcopy
else if (xcode2='copy.image')  then icopy
else if (xcode2='paste')       then paste
else if (xcode2='paste.fit')   then pastefit
else if (xcode2='paste.image') then ipaste
else if (xcode2='clear')       then
   begin
   xundo__pushnew0;
   setparams2(width,height,true,true,true);
   pic8__changed(icore);
   end
//.xbox support
else if (xcode2='xbox.0')      then xboxcontroller:=0
else if (xcode2='xbox.1')      then xboxcontroller:=1
else if (xcode2='xbox.2')      then xboxcontroller:=2
else if (xcode2='xbox.f')      then xboxfeedback:=not xboxfeedback

else if (xcode2='mirror')      then adjust(xcode2)
else if (xcode2='flip')        then adjust(xcode2)
else if (xcode2='rotate-90')   then adjust(xcode2)
else if (xcode2='rotate+90')   then adjust(xcode2)
else if (xcode2='rotate+180')  then adjust(xcode2)

else if (xcode2='resize') then
   begin
   b[0]:=intstr32(onewwidth);
   b[1]:=intstr32(onewheight);
   if gui.popmanyedit2(2,b,tepIcon24,'Resize',['New Width','New Height'],['New width in pixels in range 1 to '+k64(isizelimit),'New height in pixels in range 1 to '+k64(isizelimit)],'','',0) then
      begin
      dw:=strint32(b[0]);
      dh:=strint32(b[1]);

      if (dw<1) then dw:=20 else dw:=frcrange32(dw,1,isizelimit);
      if (dh<1) then dh:=20 else dh:=frcrange32(dh,1,isizelimit);

      adjust2('resize',dw,dh,0,0);
      end;
   end
else if (xcode2='resize.fit') then
   begin
   b[0]:=intstr32(onewwidth);
   b[1]:=intstr32(onewheight);
   if gui.popmanyedit2(2,b,tepIcon24,'Resize To Fit',['New Width','New Height'],['New width in pixels in range 1 to '+k64(isizelimit),'New height in pixels in range 1 to '+k64(isizelimit)],'','',0) then
      begin
      dw:=strint32(b[0]);
      dh:=strint32(b[1]);

      if (dw<1) then dw:=20 else dw:=frcrange32(dw,1,isizelimit);
      if (dh<1) then dh:=20 else dh:=frcrange32(dh,1,isizelimit);

      adjust2('resize.fit',dw,dh,0,0);
      end;
   end

//not handled
else result:=false;
except;end;
end;

function ttex.undo__primed:boolean;//11jul2025
begin
result:=(iundotemp_data<>'');
end;

procedure ttex.undo__primenew;
begin
if locked then exit;
iundotemp_data   :=data__forundo;
iundotemp_dataid :=icore.dataid;
end;

procedure ttex.undo__pushnew;
begin
if (iundotemp_dataid<>icore.dataid) and (iundotemp_data<>'') then xundo__pushnew(iundotemp_data);
undo__cleartempdata;
end;

procedure ttex.undo__cleartempdata;
begin
iundotemp_data:='';
end;

function ttex.xundoprimed:boolean;
begin
result:=undo__primed;
end;

procedure ttex.xprimeundo;
begin

//store previous undo if any
if xundoprimed then xchanged;

//prime undo with current data snapshot ready to commit with a call to "xchanged"
undo__primenew;

end;

procedure ttex.xchanged;//19jul2025
begin

pic8__changed(icore);//increments "dataid" which allows undo to commit
undo__pushnew;

end;

procedure ttex.loadfromfile(x:string);//14jul2025
var
   v,e:string;
begin
try

//save previous image
save;

//get
if (x<>'') then
   begin

   //get
   io__fromfilestr(x,v,e);

   case setdata2(v) of
   true:obadfile:=false;
   else
      begin
      clear;//full clear
      obadfile:=true;
      end;
   end;//case

   ifilename  :=x;
   iname      :=io__extractfilename(x);

   //set
   xundo__loadfromfile(x+'.undo');
   pic8__fromfile(isel,x+'.sel');//19jul2025
   xsel__check;

   icore.modified:=false;
   end
else
   begin

   ifilename:='';
   obadfile:=false;
   clear;//full clear
   xundo__clear;
   icore.modified:=false;

   end;


//sync
xnewcoresyncvars;

except;end;
end;

procedure ttex.xnewcoresyncvars;
begin

//sync
itoollastx:=icore.w div 2;
itoollasty:=icore.h div 2;

end;

function ttex.locked:boolean;
begin
result:=ofileinuse or (ifilename='');
end;

function ttex.gettoolsettings:string;
var
   a:tvars8;
   n:string;
   p:longint;
begin
//defaults
result   :='';
a        :=nil;

try
//init
a:=tvars8.create;

//get
for p:=0 to (itoollist.count-1) do
begin
n:=itoolcap[p]+'.';

if itoollist.tools[p].candither    then a.b[n+'dither']   :=itoollist.tools[p].dither;
if itoollist.tools[p].canwrap      then a.b[n+'wrap']     :=itoollist.tools[p].wrap;
if itoollist.tools[p].canfast      then a.b[n+'fast']     :=itoollist.tools[p].fast;
if itoollist.tools[p].canzoomin    then a.b[n+'zoomin']   :=itoollist.tools[p].zoomin;
if itoollist.tools[p].canmovexy    then a.i[n+'movexy']   :=itoollist.tools[p].movexy;
if itoollist.tools[p].canuseonce   then a.b[n+'useonce']  :=itoollist.tools[p].useonce;
if itoollist.tools[p].canselmode   then a.i[n+'selmode']  :=itoollist.tools[p].selmode;
if itoollist.tools[p].canmovestyle then a.i[n+'movestyle']:=itoollist.tools[p].movestyle;

end;//p

//set
result:=low__tob64bstr(a.text,0);//single line
except;end;
//free
freeobj(@a);
end;

procedure ttex.settoolsettings(x:string);
var
   a:tvars8;
   n:string;
   p:longint;
begin
//defaults
a        :=nil;

try
//init
a:=tvars8.create;
x:=low__fromb64str(x);
a.text:=x;

//get
for p:=0 to (itoollist.count-1) do
begin
n:=itoolcap[p]+'.';

if itoollist.tools[p].candither    then itoollist.tools[p].dither     :=a.bdef(n+'dither',false);
if itoollist.tools[p].canwrap      then itoollist.tools[p].wrap       :=a.bdef(n+'wrap',true);
if itoollist.tools[p].canfast      then itoollist.tools[p].fast       :=a.bdef(n+'fast',false);
if itoollist.tools[p].canzoomin    then itoollist.tools[p].zoomin     :=a.bdef(n+'zoomin',true);
if itoollist.tools[p].canmovexy    then itoollist.tools[p].movexy     :=a.idef2(n+'movexy',0,0,2);
if itoollist.tools[p].canuseonce   then itoollist.tools[p].useonce    :=a.bdef(n+'useonce',true);
if itoollist.tools[p].canselmode   then itoollist.tools[p].selmode    :=a.idef2(n+'selmode',0,0,2);
if itoollist.tools[p].canmovestyle then itoollist.tools[p].movestyle  :=a.idef2(n+'movestyle',0,0,2);

end;//p

except;end;
//free
freeobj(@a);
end;

function ttex.candraw:boolean;
begin
result:=itoollist.tools[ tool ].candraw;
end;

function ttex.candither:boolean;
begin
result:=itoollist.tools[tool].candither;
end;

function ttex.getdither:boolean;
begin
result:=itoollist.tools[tool].candither and itoollist.tools[tool].dither;
end;

procedure ttex.setdither(x:boolean);
begin
if itoollist.tools[tool].candither then itoollist.tools[tool].dither:=x;
end;

function ttex.canwrap:boolean;
begin
result:=itoollist.tools[tool].canwrap;
end;

function ttex.getwrap:boolean;
begin
result:=itoollist.tools[tool].canwrap and itoollist.tools[tool].wrap;
end;

procedure ttex.setwrap(x:boolean);
begin
if itoollist.tools[tool].canwrap then itoollist.tools[tool].wrap:=x;
end;

function ttex.canfast:boolean;
begin
result:=itoollist.tools[tool].canfast;
end;

function ttex.getfast:boolean;
begin
result:=itoollist.tools[tool].canfast and itoollist.tools[tool].fast;
end;

procedure ttex.setfast(x:boolean);
begin
if itoollist.tools[tool].canfast then itoollist.tools[tool].fast:=x;
end;

function ttex.canzoomin:boolean;
begin
result:=itoollist.tools[tool].canzoomin;
end;

function ttex.getzoomin:boolean;
begin
result:=itoollist.tools[tool].canzoomin and itoollist.tools[tool].zoomin;
end;

procedure ttex.setzoomin(x:boolean);
begin
if itoollist.tools[tool].canzoomin then itoollist.tools[tool].zoomin:=x;
end;

function ttex.canuseonce:boolean;
begin
result:=itoollist.tools[tool].canuseonce;
end;

function ttex.getuseonce:boolean;
begin
result:=itoollist.tools[tool].canuseonce and itoollist.tools[tool].useonce;
end;

procedure ttex.setuseonce(x:boolean);
begin
if itoollist.tools[tool].canuseonce then itoollist.tools[tool].useonce:=x;
end;

function ttex.canmovexy:boolean;
begin
result:=itoollist.tools[tool].canmovexy;
end;

function ttex.getmovexy:longint;
begin
if itoollist.tools[tool].canmovexy then result:=frcrange32(itoollist.tools[tool].movexy,0,2) else result:=tscMoveXY;
end;

procedure ttex.setmovexy(x:longint);
begin
if itoollist.tools[tool].canmovexy then itoollist.tools[tool].movexy:=frcrange32(x,0,2);
end;

function ttex.canmovey:boolean;
begin
result:=(movexy<>tscMovexonly);
end;

function ttex.canmovex:boolean;
begin
result:=(movexy<>tscMoveyonly);
end;

function ttex.canmovestyle:boolean;
begin
result:=itoollist.tools[tool].canmovestyle;
end;

function ttex.getmovestyle:longint;
begin
if itoollist.tools[tool].canmovestyle then result:=frcrange32(itoollist.tools[tool].movestyle,0,2) else result:=tscMoveboth;
end;

procedure ttex.setmovestyle(x:longint);
begin
if itoollist.tools[tool].canmovestyle then itoollist.tools[tool].movestyle:=frcrange32(x,0,2);
end;

function ttex.canmovecol:boolean;
begin
result:=(movestyle<>tscMovesel);
end;

function ttex.canmovesel:boolean;
begin
result:=(movestyle<>tscMovecol);
end;

function ttex.canselmode:boolean;
begin
result:=itoollist.tools[tool].canselmode;
end;

function ttex.getselmode:longint;
begin
if itoollist.tools[tool].canselmode then result:=frcrange32(itoollist.tools[tool].selmode,0,2) else result:=0;
end;

procedure ttex.setselmode(x:longint);
begin
if itoollist.tools[tool].canselmode then itoollist.tools[tool].selmode:=frcrange32(x,0,2);
end;

procedure ttex.selclear;
begin
xprimeundo;
xsel__clear;
xchanged;
end;

procedure ttex.selall;
var
   p:longint;
   a:tpoint;
begin
xprimeundo;
xsel__check;

for p:=0 to (isel.pcount-1) do
begin
a:=pic8__findxy(isel,p);
if xditherdetect(a.x,a.y,false) then isel.plist[p]:=1 else isel.plist[p]:=0;
end;//p

xchanged;
end;

procedure ttex.selinv;
var
   p:longint;
begin
xprimeundo;
xsel__check;
for p:=0 to (isel.pcount-1) do if (isel.plist[p]<>0) then isel.plist[p]:=0 else isel.plist[p]:=1;
xchanged;
end;

function ttex.penclass:boolean;
begin
result:=itoollist.tools[tool].penclass;
end;

function ttex.toolcount:longint;
begin
result:=itoollist.count;
end;

function ttex.gettool:longint;
begin
result:=itoollist.tool;
end;

function ttex.getlasttool:longint;
begin
result:=itoollist.lasttool;
end;

procedure ttex.settool(x:longint);
begin

if low__setint(itoollist.tool,frcrange32(x,0,itoollist.count-1)) then
   begin

   //reset support vars
   izoominref:='';

   end;

//.eye dropper etc
if not canuseonce then itoollist.lasttool:=itoollist.tool;

//tool settings bar
xsetbarfill;

end;

function ttex.gettoolcap(xindex:longint):string;
begin
if (xindex>=0) and (xindex<itoollist.count) then result:=itoolcap[ xindex ] else result:='';
end;

function ttex.gettoolcmd(xindex:longint):string;
begin
if (xindex>=0) and (xindex<itoollist.count) then result:=itoolcmd[ xindex ] else result:='';
end;

function ttex.gettoolhelp(xindex:longint):string;
begin
if (xindex>=0) and (xindex<itoollist.count) then result:=itoolhelp[ xindex ] else result:='';
end;

function ttex.gettoolitem(xindex:longint):ttextool;
begin
if (xindex>=0) and (xindex<itoollist.count) then result:=itoollist.tools[xindex] else result:=itoollist.tools[0];
end;

function ttex.toollabel:string;
begin
result:=itoolcap[ tool ];
end;

function ttex.activetoollabel:string;
begin
//defaults
result:=toollabel;

//adjust
case tool of
ttcZoom: result:=result+#32+low__aorbstr('Fit',k64(izoom)+'x',izoom>=1);
end;//case

end;

function ttex.canadjust:boolean;
begin
result:=not locked;
end;

procedure ttex.adjust(x:string);
begin
adjust2(x,0,0,0,0);
end;

procedure ttex.adjust2(x:string;v1,v2,v3,v4:longint);
var
   s,d:tbasicimage;
   dx,dy,sw,sh,dw,dh:longint;
begin
//defaults
s:=nil;
d:=nil;
s:=misimg8(1,1);
d:=misimg8(1,1);

//check
if not canadjust then exit;

try
//init
x:=strlow(x);

//get
if (x='flip') then
   begin
   toimage(s);
   mis__flip82432(s);
   fromimage(s);
   end
else if (x='mirror') then
   begin
   toimage(s);
   mis__mirror82432(s);
   fromimage(s);
   end
else if (x='rotate+90') then
   begin
   toimage(s);
   mis__rotate82432(s,90);
   fromimage(s);
   end
else if (x='rotate-90') then
   begin
   toimage(s);
   mis__rotate82432(s,-90);
   fromimage(s);
   end
else if (x='rotate-180') or (x='rotate+180') then
   begin
   toimage(s);
   mis__rotate82432(s,180);
   fromimage(s);
   end
else if (x='resize') then
   begin
   //range
   dw:=frcrange32(v1,1,isizelimit);
   dh:=frcrange32(v2,1,isizelimit);

   //init
   xundo__pushnew0;
   toimage(s);
   sw:=misw(s);
   sh:=mish(s);

   //get
   setparams2(dw,dh,true,true,false);

   //set
   for dy:=0 to (dh-1) do
   begin
   if (dy>=sh) then break;
   for dx:=0 to frcmax32(dw-1,sw-1) do pixel[dx,dy]:=s.prows8[dy][dx];
   end;//dy

   pic8__changed(icore);
   end
else if (x='resize.fit') then
   begin
   //range
   dw:=frcrange32(v1,1,isizelimit);
   dh:=frcrange32(v2,1,isizelimit);

   //get
   toimage(s);
   missize(d,dw,dh);
   mis__copyfast82432(maxarea,0,0,dw,dh,misarea(s),d,s);
   fromimage(d);
   end;

except;end;
freeobj(@s);
freeobj(@d);
end;

procedure ttex.menu__edit;
begin
showmenu2('edit');
end;

procedure ttex.copy;
begin
clip__copytext(data64);
end;

procedure ttex.icopy;
var
   a:tbasicimage;
begin
try
a:=nil;
a:=misimg32(1,1);
toimage(a);
clip__copyimage(a);
except;end;
freeobj(@a);
end;

procedure ttex.pcopy;
var
   a:tstr8;

   function xzip:boolean;
   begin
   result:=low__compress(@a);
   end;

   function xarray:boolean;
   label
      skipend;
   var
      s,dline:tstr8;
      slen,p:longint;
   begin
   //defaults
   result:=false;
   s:=nil;
   dline:=nil;
   try
   //check
   if (str__len(@a)<=0) then goto skipend;
   //init
   s:=str__new8;
   dline:=str__new8;
   str__add(@s,@a);
   str__clear(@a);
   slen:=str__len(@s);
   //start
   str__sadd(@a,':array[0..'+intstr32(slen-1)+'] of byte=('+rcode);
   //content
   for p:=1 to slen do
   begin
   str__sadd(@dline,intstr32(byte(s.bytes1[p]))+insstr(',',p<slen));
   if (str__len(@dline)>=990) then//was 1015 for Win95 Delphi 3 but lowered to 990 for Win11 Notepad - 19jul2024
      begin
      str__add(@a,@dline);
      str__sadd(@a,rcode);
      str__clear(@dline);
      end;
   end;//p
   //.finalise
   str__add(@a,@dline);
   str__sadd(@a,');'+rcode);
   //successful
   result:=true;
   skipend:
   except;end;
   try
   str__free(@s);
   str__free(@dline);
   except;end;
   end;
begin
//defaults
a:=nil;

try

//init
a:=str__new8;

//get
a.text:=pic8__todata(icore);
xzip;
xarray;

//copy
clip__copytext(a.text);

except;end;
//free
str__free(@a);
end;

function ttex.cancopy:boolean;
begin
result:=(not locked);
end;

function ttex.canpaste:boolean;
begin
result:=(not locked) and clip__canpastetext;
end;

procedure ttex.paste;
begin
xundo__pushnew0;
data:=clip__pastetextb;
pic8__changed(icore);
xnewcoresyncvars;
end;


procedure ttex.pastefit;
var
   s,d:tbasicimage;
begin
try
s:=nil;
d:=nil;
if canpaste then
   begin
   xundo__pushnew0;
   s:=misimg8(1,1);
   d:=misimg8(width,height);

   data:=clip__pastetextb;
   toimage(s);

   mis__copyfast82432(maxarea,0,0,misw(d),mish(d),misarea(s),d,s);
   fromimage2(d,false);
   end;
except;end;
freeobj(@s);
freeobj(@d);
end;

function ttex.icanpaste:boolean;
begin
result:=(not locked) and clip__canpasteimage;
end;

procedure ttex.ipaste;
var
   a:tbasicimage;
begin
a:=nil;
try
if icanpaste then
   begin
   a:=misimg32(1,1);
   if clip__pasteimage(a) then
      begin
      fromimage(a);
      xnewcoresyncvars;
      end;
   end;
except;end;
freeobj(@a);
end;

procedure ttex.xundo__init;
begin
mundo__init(iundoinfo,high(iundolist)+1);
end;

procedure ttex.xundo__savetofile(x:string);
var
   a:tvars8;
   b:tstr8;//pointer only
   p:longint;
   e:string;
begin
try
//defaults
a:=nil;
//init
a:=tvars8.create;
a.d['i']:=iundoinfo;
for p:=0 to high(iundolist) do a.s[intstr32(p)]:=iundolist[p];
//save
b:=a.binary['pic8.undo'];
if (b<>nil) then io__tofile(x,@b,e);
except;end;
//free
freeobj(@a);
end;

procedure ttex.xundo__loadfromfile(x:string);
var
   a:tvars8;
   b:tstr8;
   p:longint;
   e:string;
begin
try
//defaults
a:=nil;
b:=nil;

//clear
xundo__clear;

//init
a:=tvars8.create;
b:=str__new8;

//load
if io__fromfile(x,@b,e) then
   begin
   a.binary['pic8.undo']:=b;

   if a.dget('i',iundoinfo) then
      begin
      for p:=0 to high(iundolist) do iundolist[p]:=a.s[intstr32(p)];
      end
   else
      begin
      //reset undo system to avoid possible corruption from failed io.load - 27jan2025
      xundo__init;
      end;
   end;
except;end;
//free
freeobj(@a);
str__free(@b);
end;

function ttex.canredo:boolean;
begin
result:=(not locked) and mundo__canredo(iundoinfo);
end;

procedure ttex.redo;
var
   p:longint;
   v:string;
begin
if not canredo then exit;

try

//event
if assigned(fonpreUndoredo) then fonpreUndoredo(self);

//action
if mundo__redo(iundoinfo,p) then
   begin
   p:=xundo__filter(p);
   v:=data__forundo;
   data__forundo:=iundolist[p];
   iundolist[p]:=v;
   pic8__changed(icore);
   end;

except;end;
end;

function ttex.canundo:boolean;
begin
result:=(not locked) and mundo__canundo(iundoinfo);
end;

procedure ttex.undo;
var
   p:longint;
   v:string;
begin
if not canundo then exit;

try

//event
if assigned(fonpreUndoredo) then fonpreUndoredo(self);

//action
if mundo__undo(iundoinfo,p) then
   begin
   p:=xundo__filter(p);
   v:=data__forundo;
   data__forundo:=iundolist[p];
   iundolist[p]:=v;
   pic8__changed(icore);
   end;

except;end;
end;

procedure ttex.xundo__clear;
begin
mundo__clear(iundoinfo);
end;

function ttex.xundo__filter(x:longint):longint;
begin
result:=frcrange32(x,0,high(iundolist));
end;

procedure ttex.xundo__pushnew0;
begin
xundo__pushnew(data__forundo);
end;

procedure ttex.xundo__pushnew(const x:string);
var
   p:longint;
begin
p:=mundo__newslot(iundoinfo);
p:=xundo__filter(p);
iundolist[p]:=x;
end;

procedure ttex.swapfb;
begin
low__swapint(icore.findex,icore.bindex);
end;

function ttex.cannew:boolean;
begin
result:=(ofolder<>'');
end;

procedure ttex.new(xfilename:string;xwidth,xheight:longint);
begin
//check
if (xfilename='') then exit;

//save previous
save;

//new
pic8__clear2(icore,xwidth,xheight);//13jul2025
icore.bindex:=0;//1st color
icore.findex:=1;
setparams2(xwidth,xheight,true,true,true);
ifilename:=xfilename;
iname:=io__extractfilename(xfilename);
icore.modified:=false;
xundo__clear;
save2(true);
ohostreload:=true;//signal to host it should reload it's nav panel as this editor created a new sprite
if (havepal<>nil) then havepal.scrolltocolor(icore.findex);

xnewcoresyncvars;
end;

function ttex.cansave:boolean;
begin
result:=(not locked) and icore.modified;
end;

procedure ttex.save;
begin
save2(false);
end;

procedure ttex.save2(xforce:boolean);
var
   e:string;
begin

//check
if (not cansave) and (not xforce) then exit;

try

//save
if (ifilename<>'') then
   begin

   if io__tofilestr(ifilename,data,e) then icore.modified:=false;
   xundo__savetofile(ifilename+'.undo');
   pic8__tofile(isel,ifilename+'.sel');

   end;

except;end;
end;

procedure ttex.clear;
begin

//core
pic8__clear(icore);
ihoverindex:=0;

//over
xover__clear;
xoversel__clear;
xtemp__clear;
xsel__clear;

//bytes
xsyncbytes;

//paint
iref:='';

end;

procedure ttex.setparams(xwidth,xheight:longint);
begin
setparams2(xwidth,xheight,true,false,true);
end;

procedure ttex.setparams2(xwidth,xheight:longint;xclear,xforce,xpaint:boolean);
var
   a:tpoint;
   p:longint;
begin

if pic8__size(icore,xwidth,xheight) or xforce then
   begin
   //init
   ihoverindex:=0;

   //over
   xover__clear;
   xoversel__clear;
   xtemp__clear;
   xsel__clear;

   //clear - supports dither
   if xclear then
      begin

      for p:=0 to (icore.pcount-1) do
      begin
      a:=pic8__findxy(icore,p);
      icore.plist[p]:=xdither(b,a.x,a.y,false);
      end;//p

      end;

   //bytes
   xsyncbytes;

   //paint
   if xpaint then iref:='';
   end;

end;

function ttex.getdata:string;
begin
result:=pic8__todata(icore);
end;

function ttex.getdata64:string;
begin
result:=pic8__todata2(icore,true);
end;

procedure ttex.setdata(x:string);
begin
setdata2(x);
end;

function ttex.setdata2(x:string):boolean;
label
   skipend;
var
   b:tpiccore8;
begin
//defaults
result:=false;

try
//get
pic8__init(b,1,1);
if not pic8__fromdata(b,x)     then goto skipend;//test first
if not pic8__fromdata(icore,x) then goto skipend;

//size and clear
setparams2(icore.w,icore.h,false,true,true);

//paint
iref:='';
low__irollone(icore.dataid);

//scroll to Foreground color
if (havepal<>nil) then havepal.scrolltocolor(icore.findex);//13jul2025

//successful
result:=true;

skipend:
except;end;
end;

function ttex.getdata__forundo:string;

   procedure vadd(const xdata:string);
   begin
   result:=result+str__from32(low__len(xdata))+xdata;
   end;
   
begin
result:='undo:';
vadd(getdata);
vadd(pic8__todata(isel));
end;

procedure ttex.setdata__forundo(x:string);
var
   xpos:longint;

   function vpull:string;
   var
      xlen:longint;
   begin

   //defaults
   result:='';

   //get
   xlen:=str__to32( strcopy1(x,xpos,4) );
   inc(xpos,4);

   if (xlen>=1) then
      begin
      result:=strcopy1(x,xpos,xlen);
      inc(xpos,xlen);
      end;

   end;
begin

//new undo format
if strmatch(strcopy1(x,1,5),'undo:') then
   begin

   xpos:=6;
   data:=vpull;
   if not pic8__fromdata(isel,vpull)         then xsel__clear;
   xsel__check;

   end

//older undo format
else
   begin

   data:=x;
   xsel__clear;

   end;

end;

function ttex.toimage(s:tobject):boolean;
begin
result:=pic8__toimage(icore,s);
end;

function ttex.fromimage(s:tobject):boolean;
begin
result:=fromimage2(s,true);
end;

function ttex.fromimage2(s:tobject;xfillundo:boolean):boolean;
begin
//defaults
result:=false;

try
//update undo
if xfillundo then xundo__pushnew0;

//get
pic8__fromimage(icore,s);

//modified
pic8__changed(icore);

//bytes
xsyncbytes;

//successful
result:=true;
except;end;
end;

function ttex.xheadlen:longint;
begin
result:=20;
end;

function ttex.getdataid:longint;
begin
result:=icore.dataid;
end;

function ttex.getval(x:longint):longint;
begin
result:=pic8__pval(icore,x);
end;

procedure ttex.setval(x,xval:longint);
begin
pic8__setpval(icore,x,xval);
end;

procedure ttex.setval2(var xcore:tpiccore8;x,xval:longint);
begin
if pic8__setpval(xcore,x,xval) then pic8__changed(icore);//for undo tracking -> undo based on icore.dataid changes
end;

function ttex.getval2(var xcore:tpiccore8;x:longint):longint;
begin
result:=pic8__pval(xcore,x);
end;

procedure ttex.incval(x,xby:longint);
begin
pic8__incpval(icore,x,xby);
end;

function ttex.getpixel(x,y:longint):longint;
begin
result:=pic8__pixel(icore,x,y);
end;

procedure ttex.setpixel(x,y,xval:longint);
begin
pic8__setpixel(icore,x,y,xval);
end;

function ttex.getpixel2(var xcore:tpiccore8;x,y:longint):longint;
begin
result:=pic8__pixel(xcore,x,y);
end;

procedure ttex.setpixel2(var xcore:tpiccore8;x,y,xval:longint);
begin
if pic8__setpixel(xcore,x,y,xval) then pic8__changed(icore);//for undo tracking -> undo based on icore.dataid changes
end;

function ttex.getecolor(x,y:longint):tcolor32;
begin
result:=pic8__getcolor32(icore, pic8__pixel(icore,x,y), 0);//elist
end;

function ttex.getocolor(x,y:longint):tcolor32;
begin
result:=pic8__getcolor32(icore, pic8__pixel(icore,x,y), 1);//olist
end;

function ttex.getecolorint(x,y:longint):longint;
begin
result:=pic8__getcolor(icore, pic8__pixel(icore,x,y), 0);//elist
end;

function ttex.find__cell(sx,sy:longint;xsaferange:boolean):longint;
begin

//remove zoom
sx:=sx div activezoom;
sy:=sy div activezoom;

//adjust for scroll position
inc(sx,-activescrollx);
inc(sy,-activescrolly);

//range
if xsaferange then
   begin
   sx:=frcrange32(sx,0,frcmin32(icore.w-1,0));
   sy:=frcrange32(sy,0,frcmin32(icore.h-1,0));
   end;

//get
if (sx>=0) and (sx<icore.w) and (sy>=0) and (sy<icore.h) then result:=(sy*icore.w)+sx
else                                                          result:=-1;

end;

function ttex.find__cellwrap(sx,sy:longint):longint;//19jul2025

   function xwrap(sx,sw:longint):longint;
   begin

   //range
   sw:=frcmin32(sw,1);

   //get
   if      (sx>=sw) then sx:=sx - ((sx div sw)*sw)
   else if (sx<0)   then
      begin
      sx:=low__posn(sx);
      sx:=sw - (sx - (((sx-1) div sw)*sw) );
      end;

   //set
   result:=sx;
   end;

begin

//remove zoom
sx:=sx div activezoom;
sy:=sy div activezoom;

//adjust for scroll position
inc(sx,-activescrollx);
inc(sy,-activescrolly);

//wrap
sx:=xwrap(sx,icore.w);
sy:=xwrap(sy,icore.h);

//get
if (sx>=0) and (sx<icore.w) and (sy>=0) and (sy<icore.h) then result:=(sy*icore.w)+sx
else                                                          result:=-1;

end;

function ttex.find__pal(sx,sy:longint):longint;
var
   p:longint;
begin
for p:=0 to high(iparea) do if (sx>=iparea[p].left) and (sx<=iparea[p].right) and (sy>=iparea[p].top) and (sy<=iparea[p].bottom) then
   begin
   result:=p;
   break;
   end
else result:=-1;
end;

procedure ttex._ontimer(sender:tobject);
var
   xmustpaint:boolean;
begin
//defaults
xmustpaint:=false;

//check
if not xcanpaint then exit;

//cycle flashers
game__flashcycle(false);

//itimerfast
if (ms64>=itimerfast) then
   begin
   if low__setstr(iref,intstr32(activescrollx)+'|'+intstr32(activescrolly)+'|'+intstr32(activezoom)+'|'+bolstr(obadfile)+bolstr(ofileinuse)+bolstr(icore.modified)+bolstr(fast)+bolstr(zoomin)+bolstr(wrap)+bolstr(dither)+'|'+intstr32(f)+'|'+intstr32(b)+'|'+intstr32(ihoverindex)+'|'+intstr32(icore.dataid)+'|'+intstr32(icore.w)+'|'+intstr32(icore.h)) then
      begin
      xmustpaint:=true;
      app__turbo;
      end;

   if pic8__mustpaint(icore,iflashref) then
      begin
      xmustpaint:=true;
      omustpaint1:=true;//external signal to helper object
      end;

   //reset
   itimerfast:=ms64+low__aorb(100,30,game_subframes);//10 or 30fps
   end;

//500
if (ms64>=itimer500) then
   begin
   //sync
   xsetbarsync;

   //reset
   itimer500:=ms64+500;
   end;

//flashon timer - not related to game
if (ms64>=iflashontimer) then
   begin
   iflashon     :=not iflashon;
   iselcol32.r  :=low__aorb(100,150,iflashon);


   //reset
   iflashontimer:=ms64+300;
   end;

//xbox
xbox;

//paint
if xmustpaint then paintnow;
end;

function ttex.xzoomscale:longint;
begin
if not itoollist.tools[ttcZoom].fast then result:=1
else if (izoom<=10)                  then result:=1
else if (izoom<=50)                  then result:=4
else if (izoom<=200)                 then result:=10
else                                      result:=30;
end;

function ttex._onnotify(sender:tobject):boolean;
var
   v:longint;
begin
//defaults
result:=false;

try
//mouse wheel support
if (gui.wheel<>0) then xzoomin( round(gui.wheel*xzoomscale) );

//mouse down
if gui.mousedownstroke then
   begin

   //cell
   ihoverindex      :=find__cell(mousedownxy.x,mousedownxy.y,false);
   icantool         :=(ihoverindex>=0);

   //palette
   v:=find__pal(mousedownxy.x,mousedownxy.y);
   if (v>=0) then
      begin
      if      gui.mouseleft  then f:=v
      else if gui.mouseright then b:=v;
      end;
   end;

//mouse move
if gui.mousemoved then
   begin
   ihoverindex:=find__cell( low__aorb(mousedownxy.x,mousemovexy.x,movexy<>tscMoveYonly), low__aorb(mousedownxy.y,mousemovexy.y,movexy<>tscMoveXonly) ,icantool);
   end;

//draw
if gui.mousedownstroke or gui.mouseupstroke or (gui.mousedown and gui.mousemoved) then
   begin
   //store temp copy of data incase it's changed
   if gui.mousedownstroke then
      begin
      if (ihoverindex>=0) and (not locked) then undo__primenew;
      iundotemp_dataid :=icore.dataid;
      end;

   //apply tool
   dotool(ihoverindex,gui.mousedownstroke,gui.mouseupstroke,gui.mouseleft,icantool);
   end;

if gui.mouseupstroke then
   begin
   //push data to undo slot
   undo__pushnew;
   end;


//key press
if (gui.key<>aknone) then
   begin
   case gui.key of
   uuA,llA:f:=frcrange32(f+1,0,high(tlistcolor32));
   uuZ,llZ:f:=frcrange32(f-1,0,high(tlistcolor32));

   uuS,llS:b:=frcrange32(b+1,0,high(tlistcolor32));
   uuX,llX:b:=frcrange32(b-1,0,high(tlistcolor32));
   end;

   end;
except;end;
end;

function ttex.xdither(scol,sx,sy:longint;xswap:boolean):longint;
begin
result:=xdither2(scol,f,b,sx,sy,xswap);
end;

function ttex.xdither2(scol,sf,sb,sx,sy:longint;xswap:boolean):longint;
var
   bol1:boolean;
begin
if dither then
   begin
   bol1:=(sy=((sy div 2)*2));
   if (sx=((sx div 2)*2)) then bol1:=not bol1;
   if xswap then bol1:=not bol1;
   if bol1 then result:=sf else result:=sb;
   end
else result:=scol;

//range
result:=pic8__safecolindex(result);
end;

function ttex.xditherdetect(sx,sy:longint;xswap:boolean):boolean;
var
   bol1:boolean;
begin
if dither then
   begin
   bol1:=(sy=((sy div 2)*2));
   if (sx=((sx div 2)*2)) then bol1:=not bol1;
   if xswap then bol1:=not bol1;
   result:=bol1;
   end
else result:=true;
end;

procedure ttex.xclearsubcore(var x:tpiccore8);
begin
pic8__size(x,icore.w,icore.h);
low__cls(@x.plist,sizeof(x.plist));
end;

procedure ttex.xtemp__clear;
begin
xclearsubcore(itemp);
end;

procedure ttex.xover__clear;
begin
xclearsubcore(iover);
end;

procedure ttex.xoversel__clear;
begin
xclearsubcore(ioversel);
end;

procedure ttex.xsel__clear;
begin
xclearsubcore(isel);
end;

procedure ttex.xsel__check;
begin
if (isel.w<>icore.w) or (isel.h<>icore.h) then xsel__clear;
end;

procedure ttex.xover__renderinfofromcore;
begin

iover.rlist24   :=icore.rlist24;
iover.rlist8    :=icore.rlist8;
iover.tlist8    :=icore.tlist8;
iover.tlist8REF :=icore.tlist8REF;

end;

procedure ttex.xoversel__renderinfofromcore;
var
   v,p:longint;
begin

//init
ioversel.rlist24[0].r  :=255;
ioversel.rlist24[0].g  :=255;
ioversel.rlist24[0].b  :=255;
ioversel.rlist8 [0]    :=0;

ioversel.rlist24[1].r  :=iselcol32.r;
ioversel.rlist24[1].g  :=iselcol32.g;
ioversel.rlist24[1].b  :=iselcol32.b;
ioversel.rlist8 [1]    :=iselcol32.a;

ioversel.tlist8REF     :=-1;

//check
if (ioversel.w<>itemp.w) or (ioversel.h<>itemp.h) then exit;
if (isel.w<>ioversel.w)  or (isel.h<>ioversel.h)  then exit;

//get

if (tool=ttcMove) and (movestyle<>tscMovecol) and gui.mousedown and focused then
   begin

   for p:=0 to (itemp.pcount-1) do ioversel.plist[p]:=itemp.plist[p];

   end
else
   begin

   for p:=0 to (isel.pcount-1) do
   begin

   if (isel.plist[p]=1)  then v:=1 else v:=0;
   if (itemp.plist[p]=1) then v:=1;

   ioversel.plist[p]:=v;

   end;//p

   end;

end;

procedure ttex.xzoomin(vzoomin:longint);
begin
xzoomto(izoom+vzoomin);
end;

procedure ttex.xzoomto(vzoom:longint);
begin

if low__setint(izoom,frcrange32(vzoom,0,izoomlimit)) then
   begin

   //reset zoom coordinate
   if low__setstr(izoominref,intstr32(mousedownxy.x div 10)+'|'+intstr32(mousedownxy.y div 10)) then izoominxy:=low__point(itoollastx,itoollasty);

   //calculate new coordinate offset
   scrollx:=((clientwidth div 2) div activezoom)  - izoominxy.x;
   scrolly:=((clientheight div 2) div activezoom) - izoominxy.y;

   //sync
   xsetbarsync;

   //paint
   paintnow;

   end;

end;

procedure ttex.dotool(xindex:longint;xdownstroke,xupstroke,xleft,xinrange:boolean);//19jul2025
label
   redo;
var
   a:tpoint;
   da:twinrect;
   acore:ppiccore8;
   df,db,xtool,xselmode,si,di,vx,vy,int1,xlistindex,sx,sy,dx,dy,t,xdataid,p,maindc,mainpc,dc,pc:longint;
   bol1,bol2:boolean;

   function xcandrawthroughsel(xindex:longint):boolean;
   begin

   if      (xindex<0) or (xindex>high(tlistpixel128)) then result:=false//pixel index out-of-range
   else if (xtool=ttcSel)                             then result:=true
   else                                                    result:=(xselmode<>tscSelblock) or (isel.plist[xindex]=0);

   end;

   procedure _pot(dc,pc,x,y:longint);
   begin
   //check
   if (x<0) or (x>=itemp.w) or (y<0) or (y>=itemp.h) or (dc<0) or (dc>high(tlistcolor32)) then exit;

   //check 2
   //if (dc=pixel2[icore,x,y]) and (pc=pixel2[itemp,x,y]) then exit;

   //get
   if (dc=pixel2[icore,x,y]) and (pc<>pixel2[itemp,x,y]) then
      begin
      pixel2[itemp,x,y] :=xdither2(pc,df,db,x,y,xleft);//use as a reference
      if xcandrawthroughsel( pic8__findindex(acore^,x,y) ) then pixel2[acore^,x,y]:=xdither2(pc,df,db,x,y,xleft);//actual canvas being changed
      _pot(dc,pc,x-1,y);
      _pot(dc,pc,x+1,y);
      _pot(dc,pc,x,y-1);
      _pot(dc,pc,x,y+1);
      end;
   end;

   procedure xpot(dc,pc,x,y:longint);
   begin
   //init
   itemp.plist  :=icore.plist;
   itemp.pcount :=icore.pcount;
   itemp.w      :=icore.w;
   itemp.h      :=icore.h;

   //get
   _pot(dc,pc,x,y);
   end;

   function xfinda(xdown:boolean):tpoint;
   var
      v:tpoint;
   begin

   v:=pic8__findxy(acore^,xindex);

   if xdown then result:=v
   else
      begin
      result.x:=low__aorb(itooldownxy.x,v.x,movexy<>tscMoveYonly);
      result.y:=low__aorb(itooldownxy.y,v.y,movexy<>tscMoveXonly);
      end;

   end;
begin
try
//check
if locked      then exit;
if (xindex>=0) then ilastokindex:=xindex;
if (xindex<0)  then xindex:=ilastokindex;
if (xindex<0)  then
   begin
   xindex:=0;
   xinrange:=false;
   end;

//init
xtool    :=tool;
xselmode :=activeselmode;
maindc   :=val2[icore,xindex];//main canvas color
mainpc   :=low__aorb(bindex,findex,xleft);

if (xtool=ttcSel) or (xselmode=tscSeledit) then
   begin
   acore     :=@isel;
   df        :=1;
   db        :=0;
   pc        :=low__aorb(0,1,xleft);
   xsel__check;
   xselmode  :=tscSeledit;
   end
else
   begin
   acore     :=@icore;
   df        :=f;
   db        :=b;
   pc        :=mainpc;
   end;

dc          :=val2[acore^,xindex];//current canvas (main or selection)
xdataid     :=icore.dataid;
xlistindex  :=0;

//.down
if xdownstroke then
   begin
   a            :=xfinda(true);
   itooldownxy  :=a;
   itoollastx   :=a.x;
   itoollasty   :=a.y;
   itoolval     :=pc;
   ilist.clear;//track movement and bridge any gaps with trig
   idownscrollx :=activescrollx;
   idownscrolly :=activescrolly;

   //turn off overlay pixels
   xover__clear;
   xoversel__clear;
   xtemp__clear;
   end
//.move
else if (not xdownstroke) and (not xupstroke) then
   begin
   a            :=xfinda(false);
   calc__drawlist(true,a.x,a.y,itoollastx,itoollasty,ilist);
   itoollastx:=a.x;
   itoollasty:=a.y;
   end;

//get
redo:
a:=xfinda(false);
if gui.ctrlok and (xtool<>ttcRect) then t:=ttcEye else t:=xtool;

case t of
ttcZoom:if xupstroke then xzoomin(sign32(zoomin)*xzoomscale);
ttcHand:begin

   if xcanhand then
      begin
      //get
      if itoollist.tools[ t ].fast then
         begin
         if (izoom<=10) then int1:=2 else int1:=4;
         end
      else int1:=activezoom;

      scrollx:=idownscrollx+(( low__aorb(mousedownxy.x,mousemovexy.x,movexy<>tscMoveYonly) - mousedownxy.x) div int1);
      scrolly:=idownscrolly+(( low__aorb(mousedownxy.y,mousemovexy.y,movexy<>tscMoveXonly) - mousedownxy.y) div int1);

      //paint
      paintnow;
      end;

   end;

ttcPen:if xinrange and xcandrawthroughsel(xindex) then val2[acore^,xindex]:=xdither2(pc,df,db,a.x,a.y,xleft);//pen
ttcErase:if xinrange and xcandrawthroughsel(xindex) and xditherdetect(a.x,a.y,xleft) then val2[acore^,xindex]:=0;

ttcSel:if xinrange and xcandrawthroughsel(xindex) then val2[acore^,xindex]:=xdither2(pc,df,db,a.x,a.y,xleft);

ttcDrag:begin//drag

   if xdownstroke then idragindex:=dc;
   if xditherdetect(a.x,a.y,xleft) then val2[acore^,xindex]:=idragindex;

   end;
ttcPot:if xinrange then xpot(maindc,pc,a.x,a.y);//pot fill
ttcGPot:begin//global pot fill

   if xinrange then
      begin

      for p:=0 to (acore.pcount-1) do if (maindc=val2[icore,p]) and xcandrawthroughsel(p) then//uses "sc" which points to main canvas "icore" regardless of selection mode - 19jul2025
         begin
         a:=pic8__findxy(acore^,p);
         val2[acore^,p]:=xdither2(pc,df,db,a.x,a.y,xleft);
         end;//p

      end;

   end;
ttcCls:begin//cls

   if xinrange then
      begin

      for p:=0 to (acore.pcount-1) do
      begin
      a:=pic8__findxy(acore^,p);
      if xcandrawthroughsel(p) then val2[acore^,p]:=xdither2(pc,df,db,a.x,a.y,xleft);
      end;//p

      end;

   end;
ttcEye:begin

   if xinrange and xupstroke then//12jul2025
      begin
      if xleft then findex:=dc else bindex:=dc;//eye dropper
      end;

   end;
ttcRect:begin//rect

   if xinrange then
      begin

      a:=pic8__findxy(acore^,xindex);

      da.left   :=smallest32(itooldownxy.x,a.x);
      da.right  :=largest32(itooldownxy.x,a.x);
      da.top    :=smallest32(itooldownxy.y,a.y);
      da.bottom :=largest32(itooldownxy.y,a.y);

      //clear overlay
      case (@icore<>acore) of
      true:xtemp__clear;
      else xover__clear;
      end;

      //make overlay or apply
      for dy:=da.top to da.bottom do
      begin
      if xupstroke then
         begin
         for dx:=da.left to da.right do if xcandrawthroughsel( pic8__findindex(acore^,dx,dy) ) then pixel2[acore^,dx,dy]:=xdither2(itoolval,df,db,dx,dy,xleft);
         end
      else
         begin

         case (@icore<>acore) of
         true: for dx:=da.left to da.right do itemp.plist[ pic8__findindex(itemp,dx,dy) ]:=xdither2(itoolval,df,db,dx,dy,xleft);
         else  for dx:=da.left to da.right do if xcandrawthroughsel( pic8__findindex(iover,dx,dy) ) then iover.plist[ pic8__findindex(iover,dx,dy) ]:=xdither2(itoolval,df,db,dx,dy,xleft);
         end;//case

         end;
      end;//dy

      //paint
      paintnow;

      end;

   end;
ttcLine:begin//line

   if xinrange then
      begin

      //clear overlay
      case (@icore<>acore) of
      true:xtemp__clear;
      else xover__clear;
      end;//case

      //get points for the line
      xfindline(itooldownxy,a,ilist);

      //make overlay or apply
      if (ilist.count>=1) then
         begin
         for p:=0 to (ilist.count-1) do
         begin
         a:=ilist.value[p];
         xindex:=pic8__findindex(acore^,a.x,a.y);

         if (xindex>=0) and xcandrawthroughsel(xindex) then
            begin

            if xupstroke then val2[acore^,xindex]:=xdither2(pc,df,db,a.x,a.y,xleft)
            else
               begin

               case (@icore<>acore) of
               true:pic8__setpval(itemp,xindex,xdither2(pc,df,db,a.x,a.y,xleft));
               else pic8__setpval(iover,xindex,xdither2(pc,df,db,a.x,a.y,xleft));
               end;//case

               end;

            end;
         end;//p
         end;

      //paint
      paintnow;

      end;

   end;
ttcMove:begin//move

   //init
   bol1:=(movestyle<>tscMovesel);//move col
   bol2:=(movestyle<>tscMovecol);//move sel

   //calc shift size for x and y directions
   vx:=a.x-itooldownxy.x;
   vy:=a.y-itooldownxy.y;

   //get
   for sy:=0 to (acore.h-1) do
   begin

   for sx:=0 to (acore.w-1) do
   begin
   si:=pic8__findindex(acore^,sx,sy);

   if wrap or ( ((sx+vx)>=0) and ((sx+vx)<acore.w) and ((sy+vy)>=0) and ((sy+vy)<acore.h) ) then
      begin
      a:=xywrap(sx+vx,sy+vy);
      di:=pic8__findindex(acore^,a.x,a.y);

      if bol1 then iover.plist[di]    :=icore.plist[si];
      if bol2 then itemp.plist[di]    :=isel.plist[si];
      end
   else
      begin
      a:=xywrap(sx+vx,sy+vy);
      di:=pic8__findindex(acore^,a.x,a.y);
      if bol1 then iover.plist[di]    :=0;//transparent color -> color index 0 is always transparent - 20jul2025
      if bol2 then itemp.plist[di]    :=0;//same
      end;
   end;//dx

   end;//dy

   //write to core
   if xupstroke then
      begin

      for p:=0 to (acore.pcount-1) do
      begin
      if bol1 then val2[icore,p] :=iover.plist[p];
      if bol2 then val2[isel,p]  :=itemp.plist[p];
      end;//p

      end;

   //paint
   paintnow;

   end;
end;//case

//.trig to fill gaps when using: pen and drag tools etc
if xinrange and (not xdownstroke) and (not xupstroke) and candraw and penclass and (ilist.count>=2) then
   begin

   if (xlistindex<ilist.count) then
      begin
      a:=ilist.value[xlistindex];
      int1:=pic8__findindex(acore^,a.x,a.y);
      if (int1>=0) then xindex:=int1;
      inc(xlistindex);

      goto redo;
      end
   else inc(xlistindex);

   end;

//set
if (xdataid<>icore.dataid) then icore.modified:=true;

if xupstroke then
   begin
   //turn off overlay pixels
   xover__clear;
   xoversel__clear;
   
   //eye dropper -> revert to previous tool on release
   if canuseonce and useonce then tool:=lasttool;
   end;

//clear list
ilist.clear;
except;end;
end;

procedure ttex.xfindline(s,d:tpoint;dlist:tdynamicpoint);
begin
if (dlist=nil) then exit
else
   begin
   dlist.clear;
   calc__drawlist(true,s.x,s.y,d.x,d.y,dlist);
   end;
end;

function ttex.xywrap(x,y:longint):tpoint;
var
   v:longint;
begin
//x
if (x<0) then
   begin
   v:=-1;
   x:=-x;
   end
else v:=1;

x:=x-((x div icore.w)*icore.w);
if (v<0) then x:=icore.w-x;

//y
if (y<0) then
   begin
   v:=-1;
   y:=-y;
   end
else v:=1;

y:=y-((y div icore.h)*icore.h);
if (v<0) then y:=icore.h-y;

//set
result.x:=x;
result.y:=y;
end;

function ttex.xcollabel(xindex:longint):char;
begin
if (xindex=0) then result:='T'
else if (xindex>=1) and (xindex<=high(tlistcolor32)) then
   begin
   if      (icore.flist[xindex]=0) then result:='S'
   else if (icore.flist[xindex]>0) then result:='F'
   else                                 result:='-';
   end
else result:='?';
end;

procedure ttex._onpaint(sender:tobject);
var
   s:tclientinfo;
   a:tdrawfastinfo;
   da,ea:twinrect;
   cw,ch,vscrollx,vscrolly,vzoom,tw,i,int1,int2,dfont,fnH2,fn2,ccs,sx,sy,sw,sh,dw,dh:longint;
   bol1,bol2:boolean;
   sr24:pcolorrow24;
   c32:tcolor32;
   cnone24:tcolor24;
   t:string;

   procedure dcol;
   var
      bol1:boolean;
   begin

   //draw overlay
   case tool of
   ttcMove:bol1:=true;
   ttcRect:bol1:=(activeselmode<>tscSeledit) and gui.mousedown;
   ttcLine:bol1:=(activeselmode<>tscSeledit) and gui.mousedown;
   else    bol1:=(activeselmode<>tscSeledit);
   end;//case

   if bol1 then
      begin
      xover__renderinfofromcore;
      a.core:=@iover;
      pic8__drawfast(a);
      end;

   end;

   procedure dsel;
   begin

   //draw overlay
   if (activeselmode<>tscSeloff) then
      begin
      xoversel__renderinfofromcore;
      a.core:=@ioversel;
      pic8__drawfast(a);
      end;

   end;
begin
try

//init
infovars(s);
vzoom    :=activezoom;
vscrollx :=activescrollx;
vscrolly :=activescrolly;
cw       :=frcmin32(s.cw,1);
ch       :=frcmin32(s.ch,1);

//render init
pic8__renderinit(icore);

//buffer
if (cw<>ibuffer24.width) or (ch<>ibuffer24.height) then
   begin
   missize(ibuffer24,cw,ch);

   end;

//boundary
da.left     :=(vscrollx*vzoom);
da.right    :=da.left+(icore.w*vzoom)-1;
da.top      :=(vscrolly*vzoom);
da.bottom   :=(vscrolly+icore.h)*vzoom-1;

//transparency checkerboard
bol1:=iflashon;
if     low__even(vscrollx) then bol1:=not bol1;
if not low__even(vscrolly) then bol1:=not bol1;
mis__checkboard24(da,cw,ch,ibuffer24.prows24,vzoom,255,255,255,220,220,220,bol1);

//cls - unused areas
int1:=s.back;//random(255);
//.left
mis__cls24( area__make(0,0,da.left-1,ch-1) ,cw,ch,ibuffer24.prows24,int1);
//.right
mis__cls24( area__make(da.right+1,0,cw-1,ch-1) ,cw,ch,ibuffer24.prows24,int1);
//.top
mis__cls24( area__make(da.left,0,da.right,da.top-1) ,cw,ch,ibuffer24.prows24,int1);
//.bottom
mis__cls24( area__make(da.left,da.bottom+1,da.right,ch-1) ,cw,ch,ibuffer24.prows24,int1);


//draw
a.clip      :=misarea(ibuffer24);
a.rs24      :=ibuffer24.prows24;
a.x         :=vscrollx*vzoom;//negative value scrolls image left
a.y         :=vscrolly*vzoom;//negative value scrolls image up
a.xzoom     :=vzoom;
a.yzoom     :=vzoom;
a.power255  :=255;
a.mirror    :=false;
a.flip      :=false;


//draw main canvas
if (tool<>ttcMove) or ((tool=ttcMove) and (movestyle=tscMovesel) or (not gui.mousedown) or (not focused) ) then
   begin
   a.core:=@icore;
   pic8__drawfast(a);
   end;
   
//draw overlays
dcol;
dsel;

//paint
ldc(maxarea,0,0,ibuffer24.width,ibuffer24.height,misarea(ibuffer24),ibuffer24,255,0,clnone,0);

//error message
if ofileinuse or obadfile then
   begin

   //init
   if obadfile then t :='Unknown Format'
   else             t :='File in use';

   tw          :=low__fonttextwidth2(s.fn,t);

   ea.left     :=(cw-tw) div 2;
   ea.right    :=ea.left + tw;
   ea.top      :=(ch-s.fnH) div 2;
   ea.bottom   :=ea.top + s.fnH;

   //background
   lds( area__grow2(ea,30,12), clred, s.r);

   //text
   ldt(ea,ea.left,ea.top,clwhite,t,s.fn,s.f,s.r);

   end;

{}//xxxxxxxxxxxxxxxx//???????????????????
//background
//ldbEXCLUDE(true,la,false);
except;end;
end;


//## tsndgen ###################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//000000000000000000000000000
constructor tsndgen.create(xstereo:boolean);
begin
track__inc(satOther,1);
inherited create;


//vars
ilimit          :=high(ilist)+1;
istereo         :=xstereo;
itimerbusy      :=false;
itimer500       :=0;
ims64           :=ms64;
imute           :=false;
imastervolume100:=100;

//limits
imaxvol         :=32767;//sound is produced using +/- value of this for 16bit wave
ionehz          :=4;//2b = up and 2b = down => 1 hz (or 22.050 khz for 44100 @ 16bit)
iminhz          :=50;
imaxhz          :=20000;//20Khz
iminstep        :=xmakestep(iminhz);
imaxstep        :=xmakestep(imaxhz);
istepsPERms     :=40;//40 steps per 1ms
ifadeoutlimit   :=50*istepsPERms;//fadeout over 50ms -> gentle sound fade - 10jul2025
iminhiss        :=1;
imaxhiss        :=istepsPERms;//max 1ms for hiss

ilistcount      :=high(ilist)+1;//number of tone channels
itonecount      :=high(ilist[0].tonelist)+1;//number of tones per channel
itimecount      :=high(ilist[0].tonelist[0].tstep)+1;//number of time events per tone

low__cls(@iused,sizeof(iused));

//wave info
ihnd            :=0;
iopenref        :=0;
iopenbusy       :=false;
iclosing        :=false;
idoneonce       :=false;
ipushcount      :=0;
ibufferindex    :=-1;
low__cls(@ibuflen,sizeof(ibuflen));


//wave format
with isty do
begin
wFormatTag      :=1;//"WAVE_FORMAT_PCM=1"
nSamplesPerSec  :=44100;//44.1Khz
wBitsPerSample  :=16;
nChannels       :=low__aorb(1,2,istereo);//mono or stereo - 10jul2025
nBlockAlign     :=(nChannels*wBitsPerSample) div 8;
nAvgBytesPerSec :=nSamplesPerSec*nBlockAlign;
cbSize          :=sizeof(isty);
end;

ibuflimit       :=1+high(tsndbuffer);
if (isty.nChannels<=1) then ibuflimit:=ibuflimit div 2;

case isty.nChannels of
1:ibuflimit:=(ibuflimit div 2)*2;//blocks of 2b (2b for L)
2:ibuflimit:=(ibuflimit div 4)*4;//blocks of 4b (2b for L and 2b for R)
end;//case


//connect system message link
systemmessage__mm_wom_done:=onmessage;


//defaults
xclear;

end;

destructor tsndgen.destroy;
begin
try

//close wave out device
xclose;

//disconnect system message link
systemmessage__mm_wom_done:=nil;

//self
inherited destroy;
track__inc(satOther,-1);

except;end;
end;

procedure tsndgen.setmastervolume100(x:longint);
begin
imastervolume100:=frcrange32(x,0,100);
end;

function tsndgen.onmessage(m,w,l:longint):longint;
begin
result:=0;

case m of
MM_WOM_DONE:begin

   dec(ipushcount);

   //don't push anymore data if app is closing - 07jul2025
   if not app__closeinited then
      begin
      //if (ipushcount<=2) then xpush;
      //if (ipushcount<=1) then xpush;
      xpush;
      end;

   end;//begin
end;//case

end;

procedure tsndgen.xpush;//play buffer
var
   xindex:longint;
begin
try
//check
if app__closeinited then exit;
if not xopen then exit;

//bufferindex
if (ibufferindex<0) then ibufferindex:=0
else
   begin
   inc(ibufferindex);
   if (ibufferindex>high(ibuf)) then ibufferindex:=0;
   end;

xindex:=ibufferindex;


//fill buffer
xfillbuf( xindex );
ihdr[xindex].dwBufferLength:=ibuflen[xindex];//actual length of buffer used


//push buffer to waveout device
if (0=win____waveOutWrite(ihnd,@ihdr[xindex],sizeof(ihdr[xindex]))) then
   begin
   idoneonce     :=true;
   //.keep track of number of pushes -> used for safe close on app shutdown - 07jul2025
   inc(ipushcount);
   end;

except;end;
end;

function tsndgen.xsafehz(x:longint):longint;
begin
result:=frcrange32(x,iminhz,imaxhz);
end;

function tsndgen.xsafevol(x:longint):longint;
begin
result:=frcrange32(x,0,imaxvol);
end;

function tsndgen.xsafevol1(x:double):double;
begin
result:=frcranged64(x,0,1);
end;

function tsndgen.xsafebal1(x:double):double;
begin
result:=frcranged64(x,-1,1);
end;

procedure tsndgen.xsafebalLR(xbal:double;var lvol,rvol:double);
begin
//range
xbal:=xsafebal1(xbal);

//get
if (xbal<0) then
   begin
   lvol:=1;     //L=100..100%
   rvol:=1+xbal;//R=100..0%
   end
//.right balance
else if (xbal>0) then
   begin
   rvol:=1;     //R=100..100%
   lvol:=1-xbal;//L=100..0%
   end
else
   begin
   lvol:=1;
   rvol:=1;
   end;
end;

function tsndgen.xsafeval1(x:double):double;
begin
result:=frcranged64(x,0,1);
end;

function tsndgen.xsafeslot(xslot:longint):longint;
begin
result:=frcrange32(xslot,0,high(ilist));
end;

function tsndgen.xmakestep(xfeq:longint):longint;
begin
result:=round(imaxhz/xsafehz(xfeq)) * ionehz;
end;

function tsndgen.xmakehold(xms:longint):longint;
begin
result:=frcrange32( low__posn(xms),1,60000) * istepsPERms;//1..60,000
end;

function tsndgen.xmakevol(xvol1:double):longint;
begin
result:=round( xsafevol1(xvol1) * imaxvol );
end;

function tsndgen.xmakehiss(xhisslevel:double):longint;
begin
result:=frcrange32(1+round( xsafeval1(xhisslevel)*imaxhiss ),iminhiss,imaxhiss);
end;

function tsndgen.xmakeruntime(xms:longint):longint;
begin

case (xms<=0) of
true:result:=-1;//continuous
else result:=frcrange32(xms,1,600000)*istepsPERms;//ms as data steps=1..60,000, where 0=stopped
end;//case

end;

//xxxxxxxxxxxxxxxxxxxxxxxxx//0000000000000000000
procedure tsndgen.fadeout(xslot:longint);
begin
ilist[ xsafeslot(xslot) ].runtime:=0;//set tone to OFF -> triggers auto-fadeout
end;

procedure tsndgen.tone(xslot,xfeq:longint;xvol:double);
begin
tone3(xslot,0,xfeq,xvol,0);
end;

procedure tsndgen.tone2(xslot,xfeq:longint;xvol,xbal:double);
begin
tone3(xslot,0,xfeq,xvol,xbal);
end;

procedure tsndgen.tone3(xslot,xruntime,xfeq:longint;xvol,xbal:double);
var
   dl,dr:double;
begin
//range
xslot                              :=xsafeslot(xslot);

//get
ilist[xslot].mode                   :=3;//simple tone or hiss

//.volume and balance
xsafebalLR(xbal, dl, dr);
ilist[xslot].tonelist[0].dvolL      :=xmakevol( xvol * dl );
ilist[xslot].tonelist[0].dvolR      :=xmakevol( xvol * dr );

ilist[xslot].tonelist[0].dstep      :=xmakestep(xfeq);
ilist[xslot].tonelist[0].tcount     :=0;//no list items
ilist[xslot].runtime                :=xmakeruntime(xruntime);
ilist[xslot].fadecount              :=ifadeoutlimit;
end;

procedure tsndgen.hiss(xslot:longint;xhisslevel,xvol:double);
begin
hiss3(xslot,0,xhisslevel,xvol,0);
end;

procedure tsndgen.hiss2(xslot:longint;xhisslevel,xvol,xbal:double);
begin
hiss3(xslot,0,xhisslevel,xvol,xbal);
end;

procedure tsndgen.hiss3(xslot,xruntime:longint;xhisslevel,xvol,xbal:double);
var
   dl,dr:double;
begin
//range
xslot  :=xsafeslot(xslot);

//get
ilist[xslot].mode                   :=3;//simple tone or hiss

//.volume and balance
xsafebalLR(xbal, dl, dr);
ilist[xslot].tonelist[0].dvolL      :=xmakevol( xvol * dl );
ilist[xslot].tonelist[0].dvolR      :=xmakevol( xvol * dr );

ilist[xslot].tonelist[0].dhiss      :=xmakehiss(xhisslevel);
ilist[xslot].tonelist[0].tcount     :=0;//no list items
ilist[xslot].runtime                :=xmakeruntime(xruntime);
ilist[xslot].fadecount              :=ifadeoutlimit;
end;

function tsndgen.varinit(xruntime,xbasefeq:longint;xbasevol:double):boolean;
begin
result:=varinit2(xruntime,xbasefeq,xbasevol,0);
end;

function tsndgen.varinit2(xruntime,xbasefeq:longint;xbasevol,xbasebal:double):boolean;
begin
//defaults
result:=true;

//clear
low__cls(@ivarinfo,sizeof(ivarinfo));

//range
if not istereo then xbasebal:=0;

//init
ivarinfo.basefeq        :=xsafehz(xbasefeq);
ivarinfo.basevol        :=xsafevol1(xbasevol);//0..1
ivarinfo.basebal        :=xsafebal1(xbasebal);//-1..1
ivarinfo.runtime        :=xmakeruntime(xruntime);
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//0000000000000000000000000000

function tsndgen.vartonelist(xtoneindex,xms,xfeq:longint;xhisslevel,xvol,xbal:double;xmute:boolean):boolean;
var//Note: can use frequency or hisslevel, but not both -> hisslevel takes precedence
   i:longint;
   dl,dr:double;
begin
//range
xtoneindex:=frcrange32(xtoneindex,0,itonecount-1);

//check
result:=(ivarinfo.tonelist[xtoneindex].tcount<=itimecount);
if not result then exit;

//range
if not istereo then xbal:=0;

//init
i    :=ivarinfo.tonelist[xtoneindex].tcount;//???????????? must be range limited//?????????
xbal :=frcranged64(xbal,-1,1);

//tone frequency
ivarinfo.tonelist[xtoneindex].tstep[i] :=xmakestep( ivarinfo.basefeq + xfeq );

//hold delay -> convert "ms" to "data steps"
ivarinfo.tonelist[xtoneindex].thold[i] :=xmakehold(xms);//1..60,000
ivarinfo.tonelist[xtoneindex].tmute[i] :=xmute;

//volume + balanace
xsafebalLR( ivarinfo.basebal + xsafebal1(xbal), dl, dr );

ivarinfo.tonelist[xtoneindex].tvolL[i] :=xmakevol( ivarinfo.basevol * xvol * dl );
ivarinfo.tonelist[xtoneindex].tvolR[i] :=xmakevol( ivarinfo.basevol * xvol * dr );

//hiss level -> optional -> 0=off, +0..1=on and replaces frequency tone
case (xhisslevel>0) of
true:ivarinfo.tonelist[xtoneindex].thiss[i]:=xmakehiss( xhisslevel );
else ivarinfo.tonelist[xtoneindex].thiss[i]:=0;//off - no hiss
end;//case

//inc time list
inc(ivarinfo.tonelist[xtoneindex].tcount);



{
showbasic(
'i   : '+k64(i)+rcode+
'tstep: '+k64(ivarinfo.tonelist[xtoneindex].tstep[i])+rcode+
'thold: '+k64(ivarinfo.tonelist[xtoneindex].thold[i])+rcode+
'tmute: '+bolstr(ivarinfo.tonelist[xtoneindex].tmute[i])+rcode+
'thisslevel: '+k64(ivarinfo.tonelist[xtoneindex].thisslevel[i])+rcode+
'tcount: '+k64(ivarinfo.tonelist[xtoneindex].tcount)+rcode+
'');//xxxxxxxxx
{}//xxxxxxxxxxxx

//sucessful
result:=true;
end;

function tsndgen.vartone(xms,xfeq:longint):boolean;
begin
result:=vartonelist(0,xms,xfeq,0,1,0,false);
end;

function tsndgen.vartoneb(xms,xfeq:longint):boolean;
begin
result:=vartonelist(1,xms,xfeq,0,1,0,false);
end;

function tsndgen.vartonec(xms,xfeq:longint):boolean;
begin
result:=vartonelist(2,xms,xfeq,0,1,0,false);
end;

function tsndgen.vartonehiss(xms,xfeq:longint;xhisslevel,xvol,xmix:double):boolean;
begin
result :=true;
xmix   :=xsafeval1(xmix);//0..1
vartone1(xms,xfeq,       1-xmix, 0,false);
varhiss4(xms,xhisslevel, xmix  , 0,false);
end;

function tsndgen.vartone1(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
begin
result:=vartonelist(0,xms,xfeq,0,xvol,xbal,xmute);
end;

function tsndgen.vartone2(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
begin
result:=vartonelist(1,xms,xfeq,0,xvol,xbal,xmute);
end;

function tsndgen.vartone3(xms,xfeq:longint;xvol,xbal:double;xmute:boolean):boolean;
begin
result:=vartonelist(2,xms,xfeq,0,xvol,xbal,xmute);
end;

function tsndgen.varhiss4(xms:longint;xhisslevel,xvol,xbal:double;xmute:boolean):boolean;
begin
result:=vartonelist(3,xms,0,xhisslevel,xvol,xbal,xmute);
end;

function tsndgen.varsave(xslot:longint):boolean;
begin
result:=varsave2(xslot,false);
end;

function tsndgen.varsave2(xslot:longint;xreset:boolean):boolean;
var
   p,i:longint;
begin
//check
result:=false;

for p:=0 to (itonecount-1) do if (ivarinfo.tonelist[p].tcount>=1) then
   begin
   result:=true;
   break;
   end;

if not result then exit;


//range
xslot                  :=xsafeslot(xslot);


//get
for p:=0 to (itonecount-1) do
begin

for i:=0 to (itimecount-1) do
begin
ilist[xslot].tonelist[p].thiss[i]       :=ivarinfo.tonelist[p].thiss[i];
ilist[xslot].tonelist[p].tstep[i]       :=ivarinfo.tonelist[p].tstep[i];
ilist[xslot].tonelist[p].thold[i]       :=ivarinfo.tonelist[p].thold[i];
ilist[xslot].tonelist[p].tmute[i]       :=ivarinfo.tonelist[p].tmute[i];
ilist[xslot].tonelist[p].tvolL[i]       :=ivarinfo.tonelist[p].tvolL[i];
ilist[xslot].tonelist[p].tvolR[i]       :=ivarinfo.tonelist[p].tvolR[i];

if (ilist[xslot].tonelist[p].tcount<>ivarinfo.tonelist[p].tcount) then
   begin
   ilist[xslot].tonelist[p].tcount:=ivarinfo.tonelist[p].tcount;
   xreset:=true;
   end;

end;//i

//.detect out-of-range state and trigger a reset
//if (not xreset) and ( (ilist[xslot].tonelist[p].tcount<>) or (ilist[xslot].tonelist[p].tnext>=ilist[xslot].tonelist[p].tcount) ) then xreset:=true;
end;//p


//critical vars
if low__setint(ilist[xslot].mode,4) then xreset:=true;
ilist[xslot].fadecount                  :=ifadeoutlimit;
ilist[xslot].runtime                    :=ivarinfo.runtime;


//reset
if xreset then
   begin

   for p:=0 to (itonecount-1) do
   begin

   ilist[xslot].tonelist[p].dholdcount :=0;
   ilist[xslot].tonelist[p].tindex     :=0;
   ilist[xslot].tonelist[p].tnext      :=xnextindex(xslot,p);

   end;//p

   end;

end;

procedure tsndgen.xstep0(xslot:longint);//first tone only
begin

if (xslot>=0) and (xslot<=high(ilist)) then
   begin

   case (ilist[xslot].tonelist[0].dhiss>=1) of
   //.hiss
   true:if ( random(ilist[xslot].tonelist[0].dhiss) = 0 ) then ilist[xslot].tonelist[0].dup:=not ilist[xslot].tonelist[0].dup;
   //.tone
   else
      begin

      inc(ilist[xslot].tonelist[0].dstepcount);

      if (ilist[xslot].tonelist[0].dstepcount>ilist[xslot].tonelist[0].dstep) then
         begin
         ilist[xslot].tonelist[0].dstepcount:=0;
         ilist[xslot].tonelist[0].dup:=not ilist[xslot].tonelist[0].dup;
         end;

      end;//begin
   end;//case

   end;

end;

procedure tsndgen.xstep(xslot:longint);
var
   p:longint;
begin

if (xslot>=0) and (xslot<=high(ilist)) then
   begin

   for p:=0 to (itonecount-1) do if (ilist[xslot].tonelist[p].tcount>=1) then
   begin

   case (ilist[xslot].tonelist[p].dhiss>=1) of
   //.hiss
   true:if ( random(ilist[xslot].tonelist[p].dhiss) = 0 ) then ilist[xslot].tonelist[p].dup:=not ilist[xslot].tonelist[p].dup;
   //.tone
   else
      begin

      inc(ilist[xslot].tonelist[p].dstepcount);

      if (ilist[xslot].tonelist[p].dstepcount>ilist[xslot].tonelist[p].dstep) then
         begin
         ilist[xslot].tonelist[p].dstepcount:=0;
         ilist[xslot].tonelist[p].dup:=not ilist[xslot].tonelist[p].dup;
         end;

      end;//begin
   end;//case

   end;//p

   end;//if

end;

function tsndgen.xnextindex(xslot,xtoneindex:longint):longint;
begin

if (xslot>=0) and (xslot<ilistcount) and (xtoneindex>=0) and (xtoneindex<itonecount) then
   begin

   if (ilist[xslot].tonelist[xtoneindex].tcount>=1) then
      begin

      result:=ilist[xslot].tonelist[xtoneindex].tindex+1;
      if (result>=(ilist[xslot].tonelist[xtoneindex].tcount)) then result:=0;

      end
   else result:=0;

   end
else result:=0;

end;

procedure tsndgen.xfade(xslot:longint;var lv,rv:longint);
begin

if (xslot>=0) and (xslot<=high(ilist)) then
   begin

   //no volume left -> fully faded out
   if (ilist[xslot].fadecount<=0) then
      begin
      lv:=0;
      rv:=0;
      end

   //some volume left -> fading out
   else if (ilist[xslot].fadecount<=ifadeoutlimit) then
      begin

      lv:=( lv * ilist[xslot].fadecount ) div ifadeoutlimit;
      rv:=( rv * ilist[xslot].fadecount ) div ifadeoutlimit;

      //decrease fadeout value -> reduces tone volume to zero
      dec(ilist[xslot].fadecount,1);

      end;

   end;

end;

procedure tsndgen.xsndpull16(xslot:longint;var lv,rv:longint);
var
   vcount,p,i,ni,vhold,vholdcount:longint;
   vrunning:boolean;
begin
//defaults
lv:=0;
rv:=0;


//check
if (xslot<0) or (xslot>high(ilist)) then exit;

//.no volume on this slot -> nothing to do
if (ilist[xslot].fadecount<=0)      then exit;

//.this slot is running -> should have some volume
vrunning:=(ilist[xslot].runtime<>0);
if vrunning and (ilist[xslot].runtime>0) then dec(ilist[xslot].runtime);


//get
case ilist[xslot].mode of

//.simple tone or hiss (no timeline)
3:begin

   if (ilist[xslot].fadecount>=1) then
      begin

      //step
      xstep0(xslot);//1st tone only

      //volume
      if ilist[xslot].tonelist[0].dup then
         begin
         lv:= +ilist[xslot].tonelist[0].dvolL;
         rv:= +ilist[xslot].tonelist[0].dvolR;
         end
      else
         begin
         lv:= -ilist[xslot].tonelist[0].dvolL;
         rv:= -ilist[xslot].tonelist[0].dvolR;
         end;

      //fade out
      if not vrunning then xfade(xslot,lv,rv);

      end;

   end;

//.complex tone or hiss (variable via timeline)
4:begin

   //get
   if (ilist[xslot].fadecount>=1) then
      begin

      //init
      for p:=0 to (itonecount-1) do if (ilist[xslot].tonelist[p].tcount>=1) then
         begin

         //inc
         inc(ilist[xslot].tonelist[p].dholdcount);

         if (ilist[xslot].tonelist[p].dholdcount>=ilist[xslot].tonelist[p].thold[ ilist[xslot].tonelist[p].tindex ]) then
            begin
            ilist[xslot].tonelist[p].dholdcount :=0;
            ilist[xslot].tonelist[p].tindex     :=xnextindex(xslot,p);
            ilist[xslot].tonelist[p].tnext      :=xnextindex(xslot,p);
            end;

         //time base values
         i          :=ilist[xslot].tonelist[p].tindex;
         ni         :=ilist[xslot].tonelist[p].tnext;
         vhold      :=ilist[xslot].tonelist[p].thold[ i ];
         vholdcount :=ilist[xslot].tonelist[p].dholdcount;

         //.shift-merge output values
         ilist[xslot].tonelist[p].dstep       :=( (ilist[xslot].tonelist[p].tstep[ i ]*(vhold-vholdcount)) + (vholdcount*ilist[xslot].tonelist[p].tstep[ ni ]) ) div vhold;
         ilist[xslot].tonelist[p].dvolL       :=( (ilist[xslot].tonelist[p].tvolL[ i ]*(vhold-vholdcount)) + (vholdcount*ilist[xslot].tonelist[p].tvolL[ ni ]) ) div vhold;
         ilist[xslot].tonelist[p].dvolR       :=( (ilist[xslot].tonelist[p].tvolR[ i ]*(vhold-vholdcount)) + (vholdcount*ilist[xslot].tonelist[p].tvolR[ ni ]) ) div vhold;
         ilist[xslot].tonelist[p].dhiss       :=( (ilist[xslot].tonelist[p].thiss[ i ]*(vhold-vholdcount)) + (vholdcount*ilist[xslot].tonelist[p].thiss[ ni ]) ) div vhold;

         end;//p

      end;//if

   //xstep
   xstep(xslot);

   //tone volume
   vcount:=0;

   if (ilist[xslot].fadecount>=1) then for p:=0 to (itonecount-1) do if (ilist[xslot].tonelist[p].tcount>=1) then
      begin

      //inc volume counter
      inc(vcount);

      //not muted
      if not ilist[xslot].tonelist[p].tmute[ ilist[xslot].tonelist[p].tindex ] then
         begin

         if ilist[xslot].tonelist[p].dup then
            begin
            inc(lv, +ilist[xslot].tonelist[p].dvolL );
            inc(rv, +ilist[xslot].tonelist[p].dvolR );
            end
         else
            begin
            inc(lv, -ilist[xslot].tonelist[p].dvolL );
            inc(rv, -ilist[xslot].tonelist[p].dvolR );
            end;

         end;

      end;

   //.finalise multi-tone volumes
   if (vcount>=2) then
      begin
      if (lv>=1) then lv:=lv div vcount;
      if (rv>=1) then rv:=rv div vcount;
      end;

   //fade out
   if not vrunning then xfade(xslot,lv,rv);

   end;//begin

end;//case

end;

procedure tsndgen.xfillbuf(xindex:longint);
label
   redo;
var
   b:psndbuffer;//ptr only
   lt,rt,p,i:longint;
   lv,rv:tint4;
begin

//init
b               :=@ibuf[xindex];
ibuflen[xindex] :=0;
i               :=0;


//fill buffer with data
redo:

//get
if imute or (imastervolume100=0) then
   begin

   //no volume
   lv.val:=0;
   rv.val:=0;

   end

else
   begin

   //init
   lv.val:=0;
   rv.val:=0;

   //get
   for p:=0 to high(ilist) do
   begin

   xsndpull16(p,lt,rt);

   inc(lv.val,lt);
   inc(rv.val,rt);

   //track channel usage
   if (not iused[p]) and ((lt<>0) or (rt<>0)) then iused[p]:=true;
   end;//p


   //master volume
   if (imastervolume100<100) then
      begin
      lv.val:=round(lv.val*(imastervolume100/100));
      rv.val:=round(rv.val*(imastervolume100/100));
      end;

   //finalise volumes
   if (lv.val<-imaxvol) then lv.val:=-imaxvol else if (lv.val>imaxvol) then lv.val:=imaxvol;
   if (rv.val<-imaxvol) then rv.val:=-imaxvol else if (rv.val>imaxvol) then rv.val:=imaxvol;
   end;


//set
case isty.nchannels of
//.mono
1:begin

   if ((i+1)<ibuflimit) then
      begin
      b[i+0]:=lv.bytes[0];
      b[i+1]:=lv.bytes[1];

      inc(i,2);
      ibuflen[xindex]:=i;

      goto redo;
      end;

   end;

//.stero
2:begin

   if ((i+3)<ibuflimit) then
      begin
      b[i+0]:=lv.bytes[0];
      b[i+1]:=lv.bytes[1];
      b[i+2]:=rv.bytes[0];
      b[i+3]:=rv.bytes[1];

      inc(i,4);
      ibuflen[xindex]:=i;

      goto redo;
      end;

   end;

end;//case

end;

function tsndgen.peakchannelcount(xreset:boolean):longint;//24jul2025
var
   p:longint;
begin

//defaults
result:=0;

//get
for p:=0 to high(ilist) do
begin

if iused[p] then inc(result);
if xreset   then iused[p]:=false;

end;//p

end;

procedure tsndgen.xclear;
var
   p:longint;
begin

for p:=0 to high(ilist) do low__cls(@ilist[p],sizeof(ilist[p]));
low__cls(@ivarinfo,sizeof(ivarinfo));

end;

function tsndgen.xopen:boolean;
begin
result:=(not iclosing) and (ihnd<>0) and (not iopenbusy) and (iopenref>=(ms64+1000));
end;

procedure tsndgen.xmustopen;
var
   p:longint;
begin
try
//check
if app__closeinited then exit;
if iclosing then exit;

//lock
if iopenbusy then exit else iopenbusy:=true;

//get
if (ihnd=0) and (not iclosing) and (0=waveOutOpen(@ihnd,0,@isty,app__wproc.window,0,WAVE_ALLOWSYNC or CALLBACK_WINDOW)) then
   begin

   for p:=0 to high(ihdr) do
   begin
   //cls
   low__cls(@ihdr[p],sizeof(ihdr[p]));
   low__cls(@ibuf[p],sizeof(ibuf[p]));

   //get
   ihdr[p].lpData         :=@ibuf[p];
   ihdr[p].dwBufferLength :=sizeof(ibuf[p]);//keep buffer short and responsive

   //set
   if (ihnd<>0) and (not iclosing) then win____waveOutPrepareHeader(ihnd,@ihdr[p],sizeof(ihdr[p]));
   end;//p

   end;

//reset
if (ihnd<>0) then iopenref:=ms64+10000;//10sec

except;end;
//unlock
iopenbusy:=false;
end;

function tsndgen.getonline:boolean;
begin
result:=(ihnd<>0);
end;

procedure tsndgen.xclose;
var
   p:longint;
begin
try
//signal connection is to be closed
iclosing:=true;

//close
if (ihnd<>0) then
   begin

   //wait for waveout to finish playing current buffer
   for p:=1 to 50 do
   begin

//   if xbuffersdrained then
   if (ipushcount>=1) then
      begin
      app__processallmessages;//allow system and MS to breath -> wndproc will tell us when waveout has finished playing current buffer - 07jul2025
      win____sleep(200);
      end
   else break;

   end;//p

   //close waveout buffers
   for p:=0 to high(ihdr) do win____waveOutUnprepareHeader(ihnd,@ihdr[p],sizeof(ihdr[p]));

   //close waveout device
   waveOutClose(ihnd);
   ihnd:=0;

   end;

except;end;
end;

procedure tsndgen.xtimer(sender:tobject);
var
   p:longint;
begin
try
//check
if itimerbusy then exit else itimerbusy:=true;

//fast reference
ims64:=ms64;

//timer500
if (ms64>=itimer500) then
   begin

   //open wave device
   xmustopen;

   //reset
   itimer500:=ms64+500;

   end;

//push wave data -> start of data push -> onmessage handles subsequent pushes
if not idoneonce then
   begin
   //commit multiple buffers -> prevent skipping between buffer changes
   for p:=0 to high(ibuf) do xpush;
   end;

except;end;
//unlock
itimerbusy:=false;
end;


//other procs ------------------------------------------------------------------
procedure mis__cls24(dclip:twinrect;dbufw,dbufh:longint;drs24:pcolorrows24;xcolor:longint);//18jul2025
label
   yredo,xredo,xskip,yskip;
var
   cclip:twinrect;
   crs24:pcolorrows24;
   ax,ay:longint;
   a24:tcolor24;
begin
//check
if (dbufw<1) or (dbufh<1) or (dclip.right<0) or (dclip.bottom<0) or (dclip.left>=dbufw) or (dclip.top>=dbufh) or (drs24=nil) then exit;

//range
if (dclip.left<0)        then dclip.left:=0;
if (dclip.right>=dbufw)  then dclip.right:=dbufw-1;
if (dclip.top<0)         then dclip.top:=0;
if (dclip.bottom>=dbufh) then dclip.bottom:=dbufh-1;

//check
if (dclip.right<dclip.left) or (dclip.bottom<dclip.top) then exit;

//init
cclip            :=dclip;
crs24            :=drs24;
a24              :=int__c24(xcolor);

//y
ay     :=cclip.top;
yredo:

//x
ax     :=cclip.left;
xredo:

crs24[ay][ax]:=a24;

//inc x
xskip:
if (ax<>cclip.right) then
   begin
   inc(ax);
   goto xredo;
   end;

//inc y
yskip:
if (ay<>cclip.bottom) then
   begin
   inc(ay);
   goto yredo;
   end;

end;

procedure mis__checkboard24(dclip:twinrect;dbufw,dbufh:longint;drs24:pcolorrows24;xzoom:longint;r,g,b,r2,g2,b2:byte;xcolswap:boolean);//17jul2025
label
   yredo,xredo,xskip,yskip;
var
   cclip:twinrect;
   crs24:pcolorrows24;
   ax,ay,xcount,ycount,xsize:longint;
   ybol,xcol2:boolean;
   a24,c1,c2:tcolor24;
begin
//check
if (dbufw<1) or (dbufh<1) or (dclip.right<0) or (dclip.bottom<0) or (dclip.left>=dbufw) or (dclip.top>=dbufh) or (drs24=nil) then exit;

//range
if (dclip.left<0)        then dclip.left:=0;
if (dclip.right>=dbufw)  then dclip.right:=dbufw-1;
if (dclip.top<0)         then dclip.top:=0;
if (dclip.bottom>=dbufh) then dclip.bottom:=dbufh-1;
if (xzoom<1)             then xzoom:=1 else if (xzoom>pic8_zoomlimit) then xzoom:=pic8_zoomlimit;

//check
if (dclip.right<dclip.left) or (dclip.bottom<dclip.top) then exit;

//init
cclip            :=dclip;
crs24            :=drs24;
xsize            :=xzoom;
c1.r             :=r;
c1.g             :=g;
c1.b             :=b;
c2.r             :=r2;
c2.g             :=g2;
c2.b             :=b2;
ybol             :=xcolswap;
xcol2            :=false;

//y
ay     :=cclip.top;
ycount :=0;
yredo:

//x
ax     :=cclip.left;
xcount :=0;
xcol2  :=ybol;
if xcol2 then a24:=c2 else a24:=c1;
xredo:

crs24[ay][ax]:=a24;

//inc x
xskip:
if (ax<>cclip.right) then
   begin

   //inc zoom step
   inc(xcount);
   if (xcount>=xsize) then
      begin
      xcount :=0;
      xcol2  :=not xcol2;
      if xcol2 then a24:=c2 else a24:=c1;
      end;

   //next x pixel
   inc(ax);
   goto xredo;

   end;

//inc y
yskip:
if (ay<>cclip.bottom) then
   begin

   //inc zoom step
   inc(ycount);
   if (ycount>=xsize) then
      begin
      ycount :=0;
      ybol   :=not ybol;
      end;

   //next y row
   inc(ay);
   goto yredo;

   end;

end;

end.
