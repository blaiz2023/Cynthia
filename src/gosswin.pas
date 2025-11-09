unit gosswin;

interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
{Requires the "$align on" conditional to force "aligned record fields" state for Win32 procs -> e.g. without this state Win32 api calls can fail/act erratically, e.g. "win____waveoutgetdevcaps()" can sometimes work, sometimes fail, or sometimes return bad/incorrect/inconsistent data }
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
//## Library.................. 32bit Windows api's (gosswin.pas)
//## Version.................. 4.00.1979 (+52)
//## Items.................... 6
//## Last Updated ............ 08oct2025, 05oct2025, 26sep2025, 05sep2025, 31aug2025, 20aug2025, 11aug2025, 09aug2025, 29jul2025, 26jul2025, 04may2025, 17feb2024
//## Lines of Code............ 7,500+
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
//## | xbox__*                | Xbox Controller   | 1.00.741  | 10aug2025   | Xbox Controller support with ease-of-access support, complete with persistent button clicks and variable inputs/outputs scaled to floats between 0..1 and -1..1 - 29jul2025, 25jan2025
//## | win__*                 | Win32 support     | 1.00.856  | 02oct2025   | Dynamic load and management procs for Win32 api calls - 26sep2025, 05sep2025, 31aug2025
//## | win____*/win2____      | Win32 general     | 1.00.367  | 05oct2025   | Win32 general api procs for Windows specific features and functionality.  The leading "win____" denotes a Window's API call - 11aug2025, 26jul2025, 29apr2025, 01dec2024, 26nov2024, 04mar2024
//## | net____*               | Win32 network     | 1.00.110  | 04mar2024   | Win32 network api procs for low level network IO.  The leading "net____" denotes a Window's network API call
//## | reg__*                 | family of procs   | 1.00.032  | 24jun2024   | Registry access procs (requires admin terminal for write/delete) - 03mar2024
//## | service__*             | family of procs   | 1.00.170  | 04mar2024   | Service support, permits seamless switching from console app to app as a service
//## | console support        | misc. procs       | 1.00.050  |   jan2024   | Console support procs
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================

resourcestring
   SBadPropValue = '''%s'' is not a valid property value';
   SCannotActivate = 'OLE control activation failed';
   SNoWindowHandle = 'Could not obtain OLE control window handle';
   SOleError = 'OLE error %.8x';
   SVarNotObject = 'Variant does not reference an OLE object';
   SVarNotAutoObject = 'Variant does not reference an automation object';
   SNoMethod = 'Method ''%s'' not supported by OLE object';
   SLinkProperties = 'Link Properties';
   SInvalidLinkSource = 'Cannot link to an invalid source.';
   SCannotBreakLink = 'Break link operation is not supported.';
   SLinkedObject = 'Linked %s';
   SEmptyContainer = 'Operation not allowed on an empty OLE container';
   SInvalidVerb = 'Invalid object verb';
   SPropDlgCaption = '%s Properties';
   SInvalidStreamFormat = 'Invalid stream format';
   SInvalidLicense = 'License information for %s is invalid';
   SNotLicensed = 'License information for %s not found. You cannot use this control in design mode';

   
const

   //wincore procs support -----------------------------------------------------

   //dll names
   dnone                                                     =0;
   duser32                                                   =1;
   dshell32                                                  =2;
   dShcore                                                   =3;
   dxinput1_4                                                =4;
   dadvapi32                                                 =5;
   dkernel32                                                 =6;
   dmpr                                                      =7;
   dversion                                                  =8;
   dcomctl32                                                 =9;
   dgdi32                                                    =10;
   dopengl32                                                 =11;
   dwintrust                                                 =12;
   dole32                                                    =13;
   doleaut32                                                 =14;
   dolepro32                                                 =15;
   dwinmm                                                    =16;
   dwsock32                                                  =17;
   dwinspool                                                 =18;
   dcomdlg32                                                 =19;
   dmax                                                      =19;
   dllcount                                                  =dmax;

   //errors
   waOK                                                      =0;
   waBadDLLName                                              =1;
   waBadProcName                                             =2;
   waDLLLoadFail                                             =3;
   waProcNotFound                                            =4;
   waMax                                                     =4;

   //---------------------------------------------------------------------------


  MINCHAR = $80;
  MAXCHAR = 127;
  MINSHORT = $8000;
  MAXSHORT = 32767;
  MINLONG = $80000000;
  MAXLONG = $7FFFFFFF;
  MAXBYTE = 255;
  MAXWORD = 65535;
  MAXDWORD = $FFFFFFFF;

  //xinput - xbox controller support -------------------------------------------
  xbox_thumbstick_threshold_value =0.7;//22jul2025
  xbox_autoclick_initialdelay     =550;//ms
  xbox_autoclick_repeatdelay      =100;//ms - 10fps


  //slot ranges
  xssNative0                    =0;
  xssNative1                    =1;
  xssNative2                    =2;
  xssNative3                    =3;
  xssNativeMin                  =0;
  xssNativeMax                  =3;
  xssKeyboard                   =4;
  xssMouse                      =5;
  xssMax                        =5;//no mouse yet


  //keyboard mapping key codes  (0..xkey_max) - 24jul2025

  xkey_lt                       =0;//left trigger pressed
  xkey_rt                       =1;//right trigger pressed

  xkey_lbumper                  =2;
  xkey_rbumper                  =3;
  xkey_lsbutton                 =4;
  xkey_rsbutton                 =5;

  xkey_a_button                 =6;//"a" button press
  xkey_b_button                 =7;//"b" button press
  xkey_x_button                 =8;//"x" button press
  xkey_y_button                 =9;//"y" button press

  xkey_left                     =10;//game pad
  xkey_right                    =11;
  xkey_up                       =12;
  xkey_down                     =13;

  xkey_rx_left                  =14;//right joystick moves left
  xkey_rx_right                 =15;//right joystick moves right
  xkey_ry_up                    =16;//right joystick moves up
  xkey_ry_down                  =17;//right joystick moves down

  xkey_lx_left                  =18;//left joystick moves left
  xkey_lx_right                 =19;//left joystick moves right
  xkey_ly_up                    =20;//left joystick moves up
  xkey_ly_down                  =21;//left joystick moves down

  xkey_menu                     =22;//menu pressed
  xkey_max                      =22;
  xkey_canmap                   =xkey_menu-1;//exclude "menu" from map list

  XINPUT_GAMEPAD_DPAD_UP 	=1;//0x0001
  XINPUT_GAMEPAD_DPAD_DOWN 	=2;//0x0002
  XINPUT_GAMEPAD_DPAD_LEFT 	=4;//0x0004
  XINPUT_GAMEPAD_DPAD_RIGHT 	=8;//0x0008
  XINPUT_GAMEPAD_START 	        =16;//0x0010
  XINPUT_GAMEPAD_BACK 	        =32;//0x0020
  XINPUT_GAMEPAD_LEFT_THUMB 	=64;//0x0040
  XINPUT_GAMEPAD_RIGHT_THUMB 	=128;//0x0080
  XINPUT_GAMEPAD_LEFT_SHOULDER 	=256;//0x0100
  XINPUT_GAMEPAD_RIGHT_SHOULDER =512;//0x0200
  XINPUT_GAMEPAD_A 	        =4096;//0x1000
  XINPUT_GAMEPAD_B 	        =8192;//0x2000
  XINPUT_GAMEPAD_X 	        =16384;//0x4000
  XINPUT_GAMEPAD_Y              =32768;//0x8000

  //shellexecuteex flags -------------------------------------------------------
{ Note CLASSKEY overrides CLASSNAME }
  SEE_MASK_CLASSNAME      = $00000001;
  SEE_MASK_CLASSKEY       = $00000003;
{ Note INVOKEIDLIST overrides IDLIST }
  SEE_MASK_IDLIST         = $00000004;
  SEE_MASK_INVOKEIDLIST   = $0000000c;
  SEE_MASK_ICON           = $00000010;
  SEE_MASK_HOTKEY         = $00000020;
  SEE_MASK_NOCLOSEPROCESS = $00000040;
  SEE_MASK_CONNECTNETDRV  = $00000080;
  SEE_MASK_FLAG_DDEWAIT   = $00000100;
  SEE_MASK_DOENVSUBST     = $00000200;
  SEE_MASK_FLAG_NO_UI     = $00000400;
  SEE_MASK_UNICODE        = $00010000; // !!! changed from previous SDK (was $00004000)
  SEE_MASK_NO_CONSOLE     = $00008000;
  SEE_MASK_ASYNCOK        = $00100000;
  SEE_MASK_NOASYNC        = $00000001;

  { RedrawWindow() flags }
  RDW_INVALIDATE = 1;
  RDW_INTERNALPAINT = 2;
  RDW_ERASE = 4;
  RDW_VALIDATE = 8;
  RDW_NOINTERNALPAINT = $10;
  RDW_NOERASE = $20;
  RDW_NOCHILDREN = $40;
  RDW_ALLCHILDREN = $80;
  RDW_UPDATENOW = $100;
  RDW_ERASENOW = $200;
  RDW_FRAME = $400;
  RDW_NOFRAME = $800;

   //DIB color table identifiers
   DIB_RGB_COLORS = 0;//color table in RGBs
   DIB_PAL_COLORS = 1;//color table in palette indices

type


   //---------------------------------------------------------------------------
   //Win32 dynamic load support ------------------------------------------------

   pwincore=^twincore;
   twincore=packed record

     //proc information
     u             :array[0..999] of boolean;   //true=slot in use
     p             :array[0..999] of pointer;   //pointer to dll.proc -> nil=proc failed to load
     c             :array[0..999] of comp;      //number of calls to this proc
     e             :array[0..999] of longint;   //error code
     d             :array[0..999] of longint;   //dll name as an index
     r             :array[0..999] of longint;   //default return value -> used when proc fails to load
     r2            :array[0..999] of word;      //default return value WORD version -> used when proc fails to load

     //dll information
     du            :array[0..dmax] of boolean;  //true=DLL in use -> has already attempted to load
     dh            :array[0..dmax] of longint;  //module handle (0=failed to load)
     de            :array[0..dmax] of longint;  //error code
     dcalls        :array[0..dmax] of comp;     //number of calls to this DLL

     //load counters
     dcount        :longint;
     dOK           :longint;
     dFAIL         :longint;

     pcount        :longint;
     pOK           :longint;
     pFAIL         :longint;

     //usage counters
     pcalls        :comp;                       //number of calls to ALL procs
     ecount        :longint;                    //number of return errors from an api call

     //trace
     tracelist     :array[0..199] of longint;   //track proc usage by storing slot number in a list
     tracedepth    :longint;

     end;

   pwinscannerinfo=^twinscannerinfo;
   twinscannerinfo=record

     lhistory      :tobject;//(tdynamicnamelist) -> tracks repeat entries
     lprocvars     :tobject;//(tstr8) list of procs as constants
     lproctype     :tobject;//(tstr8) list of procs as record types
     lprocline     :tobject;//(tstr8) list of procs as a procedure or function definition line
     lprocbody     :tobject;//(tstr8) list of procs as a procedure or function text
     lprocinfo     :tobject;//(tstr8) list of procs in a management function(s)
     dunit         :tobject;//(tstr8) final unit code

     proccount     :longint;
     defaultcount  :longint;
     longestname   :longint;

     end;

   //---------------------------------------------------------------------------
   //---------------------------------------------------------------------------


   //.base value type - specify here before anything else
   HDROP         = longint;
   DWORD         = longint;
   UINT          = longint;
   PUINT         = ^UINT;
   ULONG         = longint;
   PULONG        = ^ULONG;
   PLongint      = ^longint;
   PInteger      = ^longint;
   PSmallInt     = ^smallint;
   PDouble       = ^double;
   PWChar        = PWideChar;
   WCHAR         = WideChar;
   LPSTR         = PAnsiChar;
   LPCSTR        = PAnsiChar;
   BOOL          = LongBool;
   PBOOL         = ^BOOL;
   SHORT         = smallint;
   HWND          = longint;
   HHOOK         = longint;
   THandle       = longint;
   PHandle       = ^THandle;
   phresult      = ^hresult;
   hresult       = longint;

   SC_HANDLE     = THandle;
   SERVICE_STATUS_HANDLE = DWORD;
   ATOM          = Word;
   TAtom         = Word;
   PByte         = ^Byte;
   //.registry
   HKEY          = longint;
   PHKEY         = ^HKEY;
   ACCESS_MASK   = DWORD;
   PACCESS_MASK  = ^ACCESS_MASK;
   REGSAM        = ACCESS_MASK;

   PWORD         = ^Word;
   PDWORD        = ^DWORD;
   LPDWORD       = PDWORD;

   HGLOBAL       = THandle;
   HLOCAL        = THandle;
   HMONITOR      = longint;
   FARPROC       = Pointer;
   TFarProc      = Pointer;
   TFNThreadStartRoutine = TFarProc;
   THandlerFunction = TFarProc;
   PROC_22       = Pointer;

   WPARAM        = longint;
   LPARAM        = longint;
   LRESULT       = longint;

   MakeIntResource = PAnsiChar;

   //.media support
   MMRESULT = UINT;              { error return code, 0 means no error }

   HGDIOBJ = Integer;
   HACCEL = Integer;
   HBITMAP = Integer;
   HBRUSH = Integer;
   HCOLORSPACE = Integer;
   HDC = Integer;
   HGLRC = Integer;
   HDESK = Integer;
   HENHMETAFILE = Integer;
   HFONT = Integer;
   HICON = Integer;
   HMENU = Integer;
   HMETAFILE = Integer;
   HINST = Integer;
   HMODULE = HINST;              { HMODULEs can be used in place of HINSTs }
   HPALETTE = Integer;
   HPEN = Integer;
   HRGN = Integer;
   HRSRC = Integer;
   HSTR = Integer;
   HTASK = Integer;
   HWINSTA = Integer;
   HKL = Integer;


   HFILE = Integer;
   HCURSOR = HICON;              { HICONs & HCURSORs are polymorphic }

   COLORREF = DWORD;
   TColorRef = Longint;
   TFNHandlerRoutine = TFarProc;

   u_char        = char;
   u_short       = word;
   u_int         = integer;
   u_long        = longint;
   tsocket       = u_int;


//message support
  pbasic_handle   =^tbasic_handle;
  tbasic_handle   =longint;
  tbasic_message  =cardinal;
  tbasic_wparam   =longint;
  tbasic_lparam   =longint;
  tbasic_lresult  =longint;
  pbasic_pointer  =^tbasic_pointer;
  tbasic_pointer  =longint;

  pwinmessage=^twinmessage;
  twinmessage=record//09jan2025
    m:tbasic_message;
    w:tbasic_wparam;
    l:tbasic_lparam;
    r:tbasic_lresult;
    end;

   PByteArray    = ^TByteArray;
   TByteArray    = array[0..32767] of Byte;

   PWordArray    = ^TWordArray;
   TWordArray    = array[0..16383] of Word;

   TProcedure    = procedure;
   TFileName     = string;

   PPoint        = ^TPoint;
   TPoint        = record
                   x: Longint;
                   y: Longint;
                   end;

   PCoord        = ^TCoord;
   TCoord        = packed record
                   X: SHORT;
                   Y: SHORT;
                   end;

   PSmallRect    = ^TSmallRect;
   TSmallRect    = packed record
                   Left: SHORT;
                   Top: SHORT;
                   Right: SHORT;
                   Bottom: SHORT;
                   end;

   pwinsize = ^twinsize;
   twinsize = record
    cx: Longint;
    cy: Longint;
   end;

   pwinrect=^twinrect;
   twinrect=record
    case longint of
    0:(left,top,right,bottom:longint);
    1:(topleft,bottomright:tpoint);
    end;

   PTextMetric=^TTextMetric;
   TTextMetric = record
     tmHeight: Longint;
     tmAscent: Longint;
     tmDescent: Longint;
     tmInternalLeading: Longint;
     tmExternalLeading: Longint;
     tmAveCharWidth: Longint;
     tmMaxCharWidth: Longint;
     tmWeight: Longint;
     tmOverhang: Longint;
     tmDigitizedAspectX: Longint;
     tmDigitizedAspectY: Longint;
     tmFirstChar: AnsiChar;
     tmLastChar: AnsiChar;
     tmDefaultChar: AnsiChar;
     tmBreakChar: AnsiChar;
     tmItalic: Byte;
     tmUnderlined: Byte;
     tmStruckOut: Byte;
     tmPitchAndFamily: Byte;
     tmCharSet: Byte;
   end;

   PLogBrush = ^TLogBrush;
   TLogBrush = packed record
    lbStyle: UINT;
    lbColor: longint;
    lbHatch: longint;
   end;

   PBitmapCoreHeader = ^TBitmapCoreHeader;
   TBitmapCoreHeader = packed record
    bcSize: DWORD;
    bcWidth: Word;
    bcHeight: Word;
    bcPlanes: Word;
    bcBitCount: Word;
   end;

   pbitmapheader = ^tbitmapheader;//cf_bitmap clipboard info
   tbitmapheader = packed record
    bmType: Longint;
    bmWidth: Longint;
    bmHeight: Longint;
    bmWidthBytes: Longint;
    bmPlanes: Word;
    bmBitsPixel: Word;
    bmBits: Pointer;
   end;

   PBitmapInfoHeader = ^TBitmapInfoHeader;
   TBitmapInfoHeader = packed record
    biSize         :dword;
    biWidth        :longint;
    biHeight       :longint;
    biPlanes       :word;
    biBitCount     :word;
    biCompression  :dword;
    biSizeImage    :dword;
    biXPelsPerMeter:longint;
    biYPelsPerMeter:longint;
    biClrUsed      :dword;
    biClrImportant :dword;
   end;

   PDIBSection = ^TDIBSection;
   TDIBSection = packed record
    dsBm: tbitmapheader;
    dsBmih: TBitmapInfoHeader;
    dsBitfields: array[0..2] of DWORD;
    dshSection: THandle;
    dsOffset: DWORD;
   end;

   //Xinput - Xbox controller input --------------------------------------------
   pxinputGamepad=^txinputGamepad;
   txinputGamepad=packed record
      wbuttons:word;
      bleftTrigger:byte;//0..255
      bRightTrigger:byte;//0..255
      sThumbLX:smallint;//-32768..32767 => negative values = down or left and positive values = up or right
      sThumbLY:smallint;
      sThumbRX:smallint;
      sThumbRY:smallint;
      end;

   pxinputstate=^txinputstate;
   txinputstate= packed record
      dwPacketNumber:dword;
      dGamepad:txinputGamepad;
      end;

   pxinputvibration=^txinputvibration;
   txinputvibration=packed record
       lmotorspeed:word;
       rmotorspeed:word;
      end;

   txinputkey=packed record
      rawkey     :longint;//key to trigger action
      down       :boolean;
      downonce   :boolean;
      end;

   txinputkeylist=array[0..xkey_max] of txinputkey;

   txinputfromkeyboard=packed record
      //maintain xbox controller-like input data
      xinput:txinputstate;

      //map keys to actions
      keylist     :txinputkeylist;
      //.special keyboard keys
      enter       :boolean;
      esc         :boolean;
      del         :boolean;
      end;

   thumbstickinfo=record//22jul2025
      lpeak:double;
      rpeak:double;
      upeak:double;
      dpeak:double;

      lclick:boolean;
      rclick:boolean;
      uclick:boolean;
      dclick:boolean;
      end;

   pxboxcontrollerinfo=^txboxcontrollerinfo;
   txboxcontrollerinfo=record
      index:longint;
      connected:boolean;
      newdata:boolean;
      packetcount:dword;

      //triggers
      lt:double;//0..1
      rt:double;//0..1

      //thumb sticks
      lx:double;//-1..1
      ly:double;//-1..1
      rx:double;//-1..1
      ry:double;//-1..1

      //buttons
      start:boolean;
      back:boolean;
      lb:boolean;
      rb:boolean;
      ls:boolean;
      rs:boolean;
      a:boolean;
      b:boolean;
      x:boolean;
      y:boolean;
      //.dpad
      u:boolean;
      d:boolean;
      l:boolean;
      r:boolean;

      //button clicks
      startclick:boolean;
      backclick:boolean;
      ltclick:boolean;//trigger as a click
      rtclick:boolean;//trigger as a click
      lbclick:boolean;
      rbclick:boolean;
      lsclick:boolean;
      rsclick:boolean;
      aclick:boolean;
      bclick:boolean;
      xclick:boolean;
      yclick:boolean;
      //.extended keyboard support via slot #4
      entClick:boolean;
      escClick:boolean;
      delClick:boolean;

      //.dpad
      uclick:boolean;
      dclick:boolean;
      lclick:boolean;
      rclick:boolean;

      //.thumbsticks (l and r) as l/r/u/d clicks - 22jul2025
      lxyinfo:thumbstickinfo;
      rxyinfo:thumbstickinfo;

      //vibration
      lm:double;//0..1
      rm:double;//0..1

      //auto click support
      autoclick64:array[0..3] of comp;
      end;

   pOSVersionInfo=^TOSVersionInfo;
   TOSVersionInfo = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar; { Maintenance string for PSS usage }
   end;

//mmmmmmmmmmmmmmmmmmmmmmmmmmmmm

   pdisplaydevicea=^tdisplaydevicea;
   tdisplaydevicea = record//26nov2024
     cbsize      :dword;//store size of this record in this field before passing record to api proc
     devicename  :array[0..31] of char;
     devicestring:array[0..127] of char;
     stateflags  :dword;
     deviceid    :array[0..127] of char;
     devicekey   :array[0..127] of char;
     end;


  PListEntry = ^TListEntry;
  TListEntry = record
    Flink: PListEntry;
    Blink: PListEntry;
  end;

  PRTLCriticalSection = ^TRTLCriticalSection;
  PRTLCriticalSectionDebug = ^TRTLCriticalSectionDebug;
  TRTLCriticalSectionDebug = record
    Type_18: Word;
    CreatorBackTraceIndex: Word;
    CriticalSection: PRTLCriticalSection;
    ProcessLocksList: TListEntry;
    EntryCount: DWORD;
    ContentionCount: DWORD;
    Spare: array[0..1] of DWORD;
  end;


  TRTLCriticalSection = record
    DebugInfo: PRTLCriticalSectionDebug;
    LockCount: Longint;
    RecursionCount: Longint;
    OwningThread: THandle;
    LockSemaphore: THandle;
    Reserved: DWORD;
  end;

   pmonitorinfo=^tmonitorinfo;
   tmonitorinfo = record//26nov2024
      cbsize:dword;
      rcMonitor:twinrect;
      rcWork:twinrect;
      dwFlags:dword;
      end;

   pmonitorinfoex=^tmonitorinfoex;
   tmonitorinfoex = record//26nov2024
      cbsize:dword;
      rcMonitor:twinrect;
      rcWork:twinrect;
      dwFlags:dword;
      szDeviceName:array[0..31] of char;
      end;

   PMonitorenumproc=^TMonitorenumproc;
   TMonitorenumproc=function (unnamedParam1:HMONITOR;unnamedParam2:HDC;unnamedParam3:pwinrect;unnamedParam4:LPARAM):lresult; stdcall;

  PDeviceModeA = ^TDeviceModeA;
  TDeviceModeA = packed record
    dmDeviceName: array[0..31] of AnsiChar;
    dmSpecVersion: Word;
    dmDriverVersion: Word;
    dmSize: Word;
    dmDriverExtra: Word;
    dmFields: DWORD;
    dmOrientation: SHORT;
    dmPaperSize: SHORT;
    dmPaperLength: SHORT;
    dmPaperWidth: SHORT;
    dmScale: SHORT;
    dmCopies: SHORT;
    dmDefaultSource: SHORT;
    dmPrintQuality: SHORT;
    dmColor: SHORT;
    dmDuplex: SHORT;
    dmYResolution: SHORT;
    dmTTOption: SHORT;
    dmCollate: SHORT;
    dmFormName: array[0..31] of AnsiChar;
    dmLogPixels: Word;
    dmBitsPerPel: DWORD;
    dmPelsWidth: DWORD;
    dmPelsHeight: DWORD;
    dmDisplayFlags: DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod: DWORD;
    dmICMIntent: DWORD;
    dmMediaType: DWORD;
    dmDitherType: DWORD;
    dmICCManufacturer: DWORD;
    dmICCModel: DWORD;
    dmPanningWidth: DWORD;
    dmPanningHeight: DWORD;
  end;

  PShellExecuteInfo = ^TShellExecuteInfo;
  TShellExecuteInfo = record
    cbSize: DWORD;
    fMask: ULONG;
    Wnd: HWND;
    lpVerb: PAnsiChar;
    lpFile: PAnsiChar;
    lpParameters: PAnsiChar;
    lpDirectory: PAnsiChar;
    nShow: Integer;
    hInstApp: HINST;
    { Optional fields }
    lpIDList: Pointer;
    lpClass: PAnsiChar;
    hkeyClass: HKEY;
    dwHotKey: DWORD;
    hIcon: THandle;
    hProcess: THandle;
  end;

  PChooseColor =^TChooseColor;
  TChooseColor = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HWND;
    rgbResult: COLORREF;
    lpCustColors: ^COLORREF;
    Flags: DWORD;
    lCustData: LPARAM;
    lpfnHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpTemplateName: PAnsiChar;
  end;

  POpenFilename = ^TOpenFilename;
  TOpenFilename = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PAnsiChar;
    lpstrCustomFilter: PAnsiChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PAnsiChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PAnsiChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PAnsiChar;
    lpstrTitle: PAnsiChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PAnsiChar;
    lCustData: LPARAM;
    lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpTemplateName: PAnsiChar;
  end;

const
   win_ext1  ='d'+'ll';
   win_ext2  ='dr'+'v';
   user32      ='use'+'r32'+'.'+win_ext1;
   shell32     ='sh'+'el'+'l32'+'.'+win_ext1;
   Shcore      ='S'+'hco'+'re'+'.'+win_ext1;
   xinput1_4   ='xin'+'put'+'1_4'+'.'+win_ext1;
   advapi32    ='adv'+'ap'+'i32'+'.'+win_ext1;
   kernel32    ='ke'+'rne'+'l32'+'.'+win_ext1;
   mpr         ='mp'+'r'+'.'+win_ext1;
   version     ='v'+'er'+'si'+'on'+'.'+win_ext1;
   comctl32    ='co'+'mct'+'l32'+'.'+win_ext1;
   comdlg32    ='co'+'mdl'+'g32'+'.'+win_ext1;//04oct2025
   gdi32       ='gd'+'i32'+'.'+win_ext1;
   opengl32    ='open'+'gl32'+'.'+win_ext1;
   wintrust    ='wi'+'ntr'+'ust'+'.'+win_ext1;
   ole32       ='ol'+'e32'+'.'+win_ext1;
   oleaut32    ='olea'+'ut32'+'.'+win_ext1;
   olepro32    ='olep'+'ro32'+'.'+win_ext1;
   winmm       ='win'+'mm'+'.'+win_ext1;
   mmsyst      =winmm;
   winsocket   ='wso'+'ck32'+'.'+win_ext1;
   winspl      ='win'+'s'+'pool'+'.'+win_ext2;//.drv


   NULLREGION = 1;

   SYNCHRONIZE              = $00100000;
   STANDARD_RIGHTS_REQUIRED = $000F0000;

   SM_CXSCREEN_primarymonitor       =0;
   SM_CYSCREEN_primarymonitor       =1;
   SM_CXFULLSCREEN_primarymonitor   =16;
   SM_CYFULLSCREEN_primarymonitor   =17;
   SM_CXVIRTUALSCREEN               =78;//total width in px of desktop spanning multiple monitors
   SM_CYVIRTUALSCREEN               =79;//total height in px of desktop spanning multiple monitors
   SM_CMONITORS                     =80;//number of monitors on a desktop

   DISPLAY_DEVICE_ACTIVE            = 1;//DISPLAY_DEVICE_ACTIVE specifies whether a monitor is presented as being "on" by the respective GDI view. Windows Vista: EnumDisplayDevices will only enumerate monitors that can be presented as being "on."
   DISPLAY_DEVICE_PRIMARY_DEVICE    = 4;//The primary desktop is on the device.
   DISPLAY_DEVICE_DISCONNECT        = $2000000;

   //win____getdevicecaps
   DRIVERVERSION = 0;     { Device driver version                     }
   TECHNOLOGY    = 2;     { Device classification                     }
   HORZSIZE      = 4;     { Horizontal size in millimeters            }
   VERTSIZE      = 6;     { Vertical size in millimeters              }
   HORZRES       = 8;     { Horizontal width in pixels                }
   VERTRES       = 10;    { Vertical height in pixels                 }
   BITSPIXEL     = 12;    { Number of bits per pixel                  }
   PLANES        = 14;    { Number of planes                          }
   NUMBRUSHES    = $10;   { Number of brushes the device has          }
   NUMPENS       = 18;    { Number of pens the device has             }
   NUMMARKERS    = 20;    { Number of markers the device has          }
   NUMFONTS      = 22;    { Number of fonts the device has            }
   NUMCOLORS     = 24;    { Number of colors the device supports      }
   PDEVICESIZE   = 26;    { Size required for device descriptor       }
   CURVECAPS     = 28;    { Curve capabilities                        }
   LINECAPS      = 30;    { Line capabilities                         }
   POLYGONALCAPS = $20;   { Polygonal capabilities                    }
   TEXTCAPS      = 34;    { Text capabilities                         }
   CLIPCAPS      = 36;    { Clipping capabilities                     }
   RASTERCAPS    = 38;    { Bitblt capabilities                       }
   ASPECTX       = 40;    { Length of the X leg                       }
   ASPECTY       = 42;    { Length of the Y leg                       }
   ASPECTXY      = 44;    { Length of the hypotenuse                  }

   LOGPIXELSX    = 88;    { Logical pixelsinch in X                  }
   LOGPIXELSY    = 90;    { Logical pixelsinch in Y                  }

   SIZEPALETTE   = 104;   { Number of entries in physical palette     }
   NUMRESERVED   = 106;   { Number of reserved entries in palette     }
   COLORRES      = 108;   { Actual color resolution                   }

   //access rights
   _DELETE                  = $00010000;
   READ_CONTROL             = $00020000;
   WRITE_DAC                = $00040000;
   WRITE_OWNER              = $00080000;
   STANDARD_RIGHTS_READ     = READ_CONTROL;
   STANDARD_RIGHTS_WRITE    = READ_CONTROL;
   STANDARD_RIGHTS_EXECUTE  = READ_CONTROL;
   STANDARD_RIGHTS_ALL      = $001F0000;
   SPECIFIC_RIGHTS_ALL      = $0000FFFF;
   ACCESS_SYSTEM_SECURITY   = $01000000;
   MAXIMUM_ALLOWED          = $02000000;
   GENERIC_READ             = -2147483647-1;//was $80000000; - avoids constant range error in Lazarus
   GENERIC_WRITE            = 1073741824;//was $40000000;
//   GENERIC_READ             = $80000000;
//   GENERIC_WRITE            = $40000000;
   GENERIC_EXECUTE          = $20000000;
   GENERIC_ALL              = $10000000;

   //getstockobject values
   WHITE_BRUSH = 0;
   LTGRAY_BRUSH = 1;
   GRAY_BRUSH = 2;
   DKGRAY_BRUSH = 3;
   BLACK_BRUSH = 4;
   NULL_BRUSH = 5;
   HOLLOW_BRUSH = NULL_BRUSH;
   WHITE_PEN = 6;
   BLACK_PEN = 7;
   NULL_PEN = 8;
   OEM_FIXED_FONT = 10;
   ANSI_FIXED_FONT = 11;
   ANSI_VAR_FONT = 12;
   SYSTEM_FONT = 13;
   DEVICE_DEFAULT_FONT = 14;
   DEFAULT_PALETTE = 15;
   SYSTEM_FIXED_FONT = $10;
   DEFAULT_GUI_FONT = 17;
   STOCK_LAST = 17;

  //Global Memory Flags
   GMEM_FIXED = 0;
   GMEM_MOVEABLE = 2;
   GMEM_NOCOMPACT = $10;
   GMEM_NODISCARD = $20;
   GMEM_ZEROINIT = $40;
   GMEM_MODIFY = $80;
   GMEM_DISCARDABLE = $100;
   GMEM_NOT_BANKED = $1000;
   GMEM_SHARE = $2000;
   GMEM_DDESHARE = $2000;
   GMEM_NOTIFY = $4000;
   GMEM_LOWER = GMEM_NOT_BANKED;
   GMEM_VALID_FLAGS = 32626;
   GMEM_INVALID_HANDLE = $8000;
   GHND = GMEM_MOVEABLE or GMEM_ZEROINIT;
   GPTR = GMEM_FIXED or GMEM_ZEROINIT;

   ETO_OPAQUE = 2;
   ETO_CLIPPED = 4;
   ETO_GLYPH_INDEX = $10;
   ETO_RTLREADING = $80;
   ETO_IGNORELANGUAGE = $1000;

   { SetWindowPos Flags }
   SWP_NOSIZE = 1;
   SWP_NOMOVE = 2;
   SWP_NOZORDER = 4;
   SWP_NOREDRAW = 8;
   SWP_NOACTIVATE = $10;
   SWP_FRAMECHANGED = $20;    { The frame changed: send WM_NCCALCSIZE }
   SWP_SHOWWINDOW = $40;
   SWP_HIDEWINDOW = $80;
   SWP_NOCOPYBITS = $100;
   SWP_NOOWNERZORDER = $200;  { Don't do owner Z ordering }
   SWP_NOSENDCHANGING = $400;  { Don't send WM_WINDOWPOSCHANGING }
   SWP_DRAWFRAME = SWP_FRAMECHANGED;
   SWP_NOREPOSITION = SWP_NOOWNERZORDER;
   SWP_DEFERERASE = $2000;
   SWP_ASYNCWINDOWPOS = $4000;

   HWND_TOP = 0;
   HWND_BOTTOM = 1;
   HWND_TOPMOST = -1;
   HWND_NOTOPMOST = -2;

   { Predefined Clipboard Formats }
   CF_TEXT          =1;
   CF_BITMAP        =2;
   CF_METAFILEPICT  =3;
   CF_SYLK          =4;
   CF_DIF           =5;
   CF_TIFF          =6;
   CF_OEMTEXT       =7;
   CF_DIB           =8;
   CF_DIBV5         =17;//08jun2025
   CF_PALETTE       =9;
   CF_PENDATA       =10;
   CF_RIFF          =11;
   CF_WAVE          =12;
   CF_UNICODETEXT   =13;
   CF_ENHMETAFILE   =14;
   CF_HDROP         =15;
   CF_LOCALE        =$10;
   CF_MAX           =17;

   CF_OWNERDISPLAY = 128;
   CF_DSPTEXT = 129;
   CF_DSPBITMAP = 130;
   CF_DSPMETAFILEPICT = 131;
   CF_DSPENHMETAFILE = 142;

   { "Private" formats don't get GlobalFree()'d }
   CF_PRIVATEFIRST = $200;
   CF_PRIVATELAST = 767;

   { "GDIOBJ" formats do get DeleteObject()'d }
   CF_GDIOBJFIRST = 768;
   CF_GDIOBJLAST = 1023;

   //registry
   HKEY_CLASSES_ROOT     =-2147483647-1;// $80000000;
   HKEY_CURRENT_USER     =-2147483647;// $80000001;
   HKEY_LOCAL_MACHINE    =-2147483646;// $80000002;
   HKEY_USERS            =-2147483645;// $80000003;
   HKEY_PERFORMANCE_DATA =-2147483644;// $80000004;
   HKEY_CURRENT_CONFIG   =-2147483643;// $80000005;
   HKEY_DYN_DATA         =-2147483642;// $80000006;
   ERROR_SUCCESS         = 0;
   NO_ERROR              = 0;
   REG_OPTION_NON_VOLATILE = ($00000000);//key is preserved when system is rebooted
   REG_CREATED_NEW_KEY     = ($00000001);//new registry key created
   REG_OPENED_EXISTING_KEY = ($00000002);//existing key opened
   //.registry value types
   REG_NONE                       = 0;
   REG_SZ                         = 1;
   REG_EXPAND_SZ                  = 2;
   REG_BINARY                     = 3;
   REG_DWORD                      = 4;
   REG_DWORD_LITTLE_ENDIAN        = 4;
   REG_DWORD_BIG_ENDIAN           = 5;
   REG_LINK                       = 6;
   REG_MULTI_SZ                   = 7;
   REG_RESOURCE_LIST              = 8;
   REG_FULL_RESOURCE_DESCRIPTOR   = 9;
   REG_RESOURCE_REQUIREMENTS_LIST = 10;

   KEY_QUERY_VALUE    = $0001;
   KEY_SET_VALUE      = $0002;
   KEY_CREATE_SUB_KEY = $0004;
   KEY_ENUMERATE_SUB_KEYS = $0008;
   KEY_NOTIFY         = $0010;
   KEY_CREATE_LINK    = $0020;

   KEY_READ           = (STANDARD_RIGHTS_READ or
                        KEY_QUERY_VALUE or
                        KEY_ENUMERATE_SUB_KEYS or
                        KEY_NOTIFY) and not
                        SYNCHRONIZE;

   KEY_WRITE          = (STANDARD_RIGHTS_WRITE or
                        KEY_SET_VALUE or
                        KEY_CREATE_SUB_KEY) and not
                        SYNCHRONIZE;

   KEY_EXECUTE        =  KEY_READ and not SYNCHRONIZE;

   KEY_ALL_ACCESS     = (STANDARD_RIGHTS_ALL or
                        KEY_QUERY_VALUE or
                        KEY_SET_VALUE or
                        KEY_CREATE_SUB_KEY or
                        KEY_ENUMERATE_SUB_KEYS or
                        KEY_NOTIFY or
                        KEY_CREATE_LINK) and not
                        SYNCHRONIZE;

   //service manager
   SC_MANAGER_CONNECT             = $0001;
   SC_MANAGER_CREATE_SERVICE      = $0002;
   SC_MANAGER_ENUMERATE_SERVICE   = $0004;
   SC_MANAGER_LOCK                = $0008;
   SC_MANAGER_QUERY_LOCK_STATUS   = $0010;
   SC_MANAGER_MODIFY_BOOT_CONFIG  = $0020;

   SC_MANAGER_ALL_ACCESS          = (STANDARD_RIGHTS_REQUIRED or
                                    SC_MANAGER_CONNECT or
                                    SC_MANAGER_CREATE_SERVICE or
                                    SC_MANAGER_ENUMERATE_SERVICE or
                                    SC_MANAGER_LOCK or
                                    SC_MANAGER_QUERY_LOCK_STATUS or
                                    SC_MANAGER_MODIFY_BOOT_CONFIG);

   //priority codes
   NORMAL_PRIORITY_CLASS           = $00000020;
   IDLE_PRIORITY_CLASS             = $00000040;
   HIGH_PRIORITY_CLASS             = $00000080;
   REALTIME_PRIORITY_CLASS         = $00000100;

   //service support
   //.control codes
   SERVICE_CONTROL_STOP           = $00000001;
   SERVICE_CONTROL_PAUSE          = $00000002;
   SERVICE_CONTROL_CONTINUE       = $00000003;
   SERVICE_CONTROL_INTERROGATE    = $00000004;
   SERVICE_CONTROL_SHUTDOWN       = $00000005;
   //.status codes
   SERVICE_STOPPED                = $00000001;
   SERVICE_START_PENDING          = $00000002;
   SERVICE_STOP_PENDING           = $00000003;
   SERVICE_RUNNING                = $00000004;
   SERVICE_CONTINUE_PENDING       = $00000005;
   SERVICE_PAUSE_PENDING          = $00000006;
   SERVICE_PAUSED                 = $00000007;
   //.accept mask (Bit Mask)
   SERVICE_ACCEPT_STOP            = $00000001;
   SERVICE_ACCEPT_PAUSE_CONTINUE  = $00000002;
   SERVICE_ACCEPT_SHUTDOWN        = $00000004;

  { WM_NCHITTEST and MOUSEHOOKSTRUCT Mouse Position Codes }
   HTERROR = -2;
   HTTRANSPARENT = -1;
   HTNOWHERE = 0;
   HTCLIENT = 1;
   HTCAPTION = 2;
   HTSYSMENU = 3;
   HTGROWBOX = 4;
   HTSIZE = HTGROWBOX;
   HTMENU = 5;
   HTHSCROLL = 6;
   HTVSCROLL = 7;
   HTMINBUTTON = 8;
   HTMAXBUTTON = 9;
   HTLEFT = 10;
   HTRIGHT = 11;
   HTTOP = 12;
   HTTOPLEFT = 13;
   HTTOPRIGHT = 14;
   HTBOTTOM = 15;
   HTBOTTOMLEFT = $10;
   HTBOTTOMRIGHT = 17;
   HTBORDER = 18;
   HTREDUCE = HTMINBUTTON;
   HTZOOM = HTMAXBUTTON;
   HTSIZEFIRST = HTLEFT;
   HTSIZELAST = HTBOTTOMRIGHT;
   HTOBJECT = 19;
   HTCLOSE = 20;
   HTHELP = 21;

   //StretchBlt render modes
   SRCCOPY     = $00CC0020;     { dest = source                    }
   SRCPAINT    = $00EE0086;     { dest = source OR dest            }
   SRCAND      = $008800C6;     { dest = source AND dest           }
   SRCINVERT   = $00660046;     { dest = source XOR dest           }
   SRCERASE    = $00440328;     { dest = source AND (NOT dest )    }
   NOTSRCCOPY  = $00330008;     { dest = (NOT source)              }
   NOTSRCERASE = $001100A6;     { dest = (NOT src) AND (NOT dest)  }
   MERGECOPY   = $00C000CA;     { dest = (source AND pattern)      }
   MERGEPAINT  = $00BB0226;     { dest = (NOT source) OR dest      }
   PATCOPY     = $00F00021;     { dest = pattern                   }
   PATPAINT    = $00FB0A09;     { dest = DPSnoo                    }
   PATINVERT   = $005A0049;     { dest = pattern XOR dest          }
   DSTINVERT   = $00550009;     { dest = (NOT dest)                }
   BLACKNESS   = $00000042;     { dest = BLACK                     }
   WHITENESS   = $00FF0062;     { dest = WHITE                     }

   //system menu command values "WM_SYSCOMMAND"
   SC_SIZE          = 61440;
   SC_MOVE          = 61456;
   SC_MINIMIZE      = 61472;
   SC_MAXIMIZE      = 61488;
   SC_NEXTWINDOW    = 61504;
   SC_PREVWINDOW    = 61520;
   SC_CLOSE         = 61536;
   SC_VSCROLL       = 61552;
   SC_HSCROLL       = 61568;
   SC_MOUSEMENU     = 61584;
   SC_KEYMENU       = 61696;
   SC_ARRANGE       = 61712;
   SC_RESTORE       = 61728;
   SC_TASKLIST      = 61744;
   SC_SCREENSAVE    = 61760;
   SC_HOTKEY        = 61776;
   SC_DEFAULT       = 61792;
   SC_MONITORPOWER  = 61808;
   SC_CONTEXTHELP   = 61824;
   SC_SEPARATOR     = 61455;

   //printer
   PRINTER_ENUM_DEFAULT     = $00000001;
   PRINTER_ENUM_LOCAL       = $00000002;
   PRINTER_ENUM_CONNECTIONS = $00000004;
   PRINTER_ENUM_FAVORITE    = $00000004;
   PRINTER_ENUM_NAME        = $00000008;
   PRINTER_ENUM_REMOTE      = $00000010;
   PRINTER_ENUM_SHARED      = $00000020;
   PRINTER_ENUM_NETWORK     = $00000040;

   PRINTER_ENUM_EXPAND      = $00004000;
   PRINTER_ENUM_CONTAINER   = $00008000;

   PRINTER_ENUM_ICONMASK    = $00ff0000;
   PRINTER_ENUM_ICON1       = $00010000;
   PRINTER_ENUM_ICON2       = $00020000;
   PRINTER_ENUM_ICON3       = $00040000;
   PRINTER_ENUM_ICON4       = $00080000;
   PRINTER_ENUM_ICON5       = $00100000;
   PRINTER_ENUM_ICON6       = $00200000;
   PRINTER_ENUM_ICON7       = $00400000;
   PRINTER_ENUM_ICON8       = $00800000;

   //system messages
   WM_USER              =$0400;//anything below this is reserved
   WM_MULTIMEDIA_TIMER  =WM_USER + 127;
   WM_PAINT             = $000F;
   WM_DESTROY           = $0002;
   WM_CLOSE             = $0010;
   WM_QUERYENDSESSION   = $0011;
   WM_QUIT              = $0012;
   WM_ENDSESSION        = $0016;
   WM_DISPLAYCHANGE     = $007E;
   WM_DPICHANGED        = 736;//0x02E0
   GWL_EXSTYLE          =-20;
   WM_NCHITTEST         = $0084;
   WM_SYSCOMMAND        = $0112;
   WM_WININICHANGE      = $001A;
   WM_SETTINGCHANGE     = $001A;
   WM_ENTERSIZEMOVE     = $0231;
   WM_EXITSIZEMOVE      = $0232;
   WM_ICONERASEBKGND    = $0027;
   WM_ERASEBKGND       = $0014;
   WM_DROPFILES        = $0233;
   WM_SIZE             = $0005;
   WM_SIZING           = 532;
   WM_SETCURSOR        = $0020;
   WM_ACTIVATE         = $0006;
   WM_ACTIVATEAPP      = $001C;
   WM_NCCALCSIZE       = $0083;
   WM_NCACTIVATE       = $0086;
   WM_NCPAINT          = $0085;
   WM_WINDOWPOSCHANGED = $0047;

   WM_KEYFIRST         = $0100;
   WM_KEYDOWN          = $0100;
   WM_KEYUP            = $0101;
   WM_CHAR             = $0102;
   WM_DEADCHAR         = $0103;
   WM_SYSKEYDOWN       = $0104;
   WM_SYSKEYUP         = $0105;
   WM_SYSCHAR          = $0106;
   WM_SYSDEADCHAR      = $0107;
   WM_KEYLAST          = $0108;

   WM_MOUSEFIRST       = $0200;
   WM_MOUSEMOVE        = $0200;
   WM_LBUTTONDOWN      = $0201;
   WM_LBUTTONUP        = $0202;
   WM_LBUTTONDBLCLK    = $0203;
   WM_RBUTTONDOWN      = $0204;
   WM_RBUTTONUP        = $0205;
   WM_RBUTTONDBLCLK    = $0206;
   WM_MBUTTONDOWN      = $0207;
   WM_MBUTTONUP        = $0208;
   WM_MBUTTONDBLCLK    = $0209;
   WM_MOUSEWHEEL       = $020A;
   WM_MOUSELAST        = $020A;

   WM_GETICON          = $007F;
   WM_SETICON          = $0080;

  //window styles
   WS_OVERLAPPED = 0;
   WS_POPUP = $80000000;
   WS_CHILD = $40000000;
   WS_MINIMIZE = $20000000;
   WS_VISIBLE = $10000000;
   WS_DISABLED = $8000000;
   WS_CLIPSIBLINGS = $4000000;
   WS_CLIPCHILDREN = $2000000;
   WS_MAXIMIZE = $1000000;
   WS_CAPTION = $C00000;      { WS_BORDER or WS_DLGFRAME  }
   WS_BORDER = $800000;
   WS_DLGFRAME = $400000;
   WS_VSCROLL = $200000;
   WS_HSCROLL = $100000;
   WS_SYSMENU = $80000;
   WS_THICKFRAME = $40000;
   WS_GROUP = $20000;
   WS_TABSTOP = $10000;

   WS_MINIMIZEBOX = $20000;
   WS_MAXIMIZEBOX = $10000;

   WS_TILED = WS_OVERLAPPED;
   WS_ICONIC = WS_MINIMIZE;
   WS_SIZEBOX = WS_THICKFRAME;

   WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_THICKFRAME or WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
   WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW;
   WS_POPUPWINDOW = (WS_POPUP or WS_BORDER or WS_SYSMENU);
   WS_CHILDWINDOW = WS_CHILD;

   //extended window styles
   WS_EX_DLGMODALFRAME = 1;
   WS_EX_NOPARENTNOTIFY = 4;
   WS_EX_TOPMOST = 8;
   WS_EX_ACCEPTFILES = $10;
   WS_EX_TRANSPARENT = $20;
   WS_EX_MDICHILD = $40;
   WS_EX_TOOLWINDOW = $80;
   WS_EX_WINDOWEDGE = $100;
   WS_EX_CLIENTEDGE = $200;
   WS_EX_CONTEXTHELP = $400;
   WS_EX_LAYERED     = $00080000;//27nov2024

   WS_EX_RIGHT = $1000;
   WS_EX_LEFT = 0;
   WS_EX_RTLREADING = $2000;
   WS_EX_LTRREADING = 0;
   WS_EX_LEFTSCROLLBAR = $4000;
   WS_EX_RIGHTSCROLLBAR = 0;

   WS_EX_CONTROLPARENT = $10000;
   WS_EX_STATICEDGE = $20000;
   WS_EX_APPWINDOW = $40000;
   WS_EX_OVERLAPPEDWINDOW = (WS_EX_WINDOWEDGE or WS_EX_CLIENTEDGE);
   WS_EX_PALETTEWINDOW = (WS_EX_WINDOWEDGE or WS_EX_TOOLWINDOW or WS_EX_TOPMOST);

   { ShowWindow() Commands }
   SW_HIDE = 0;
   SW_SHOWNORMAL = 1;
   SW_NORMAL = 1;
   SW_SHOWMINIMIZED = 2;
   SW_SHOWMAXIMIZED = 3;
   SW_MAXIMIZE = 3;
   SW_SHOWNOACTIVATE = 4;
   SW_SHOW = 5;
   SW_MINIMIZE = 6;
   SW_SHOWMINNOACTIVE = 7;
   SW_SHOWNA = 8;
   SW_RESTORE = 9;
   SW_SHOWDEFAULT = 10;
   SW_MAX = 10;

   //class styles
   CS_VREDRAW = 1;
   CS_HREDRAW = 2;
   CS_KEYCVTWINDOW = 4;
   CS_DBLCLKS = 8;
   CS_OWNDC = $20;
   CS_CLASSDC = $40;
   CS_PARENTDC = $80;
   CS_NOKEYCVT = $100;
   CS_NOCLOSE = $200;
   CS_SAVEBITS = $800;
   CS_BYTEALIGNCLIENT = $1000;
   CS_BYTEALIGNWINDOW = $2000;
   CS_GLOBALCLASS = $4000;
   CS_IME = $10000;

   //file open modes
   fmOpenRead       = $0000;
   fmOpenWrite      = $0001;
   fmOpenReadWrite  = $0002;
   fmShareCompat    = $0000;
   fmShareExclusive = $0010;
   fmShareDenyWrite = $0020;
   fmShareDenyRead  = $0030;
   fmShareDenyNone  = $0040;

   //file attribute constants
   faReadOnly  = $00000001;
   faHidden    = $00000002;
   faSysFile   = $00000004;
   faVolumeID  = $00000008;
   faDirectory = $00000010;
   faArchive   = $00000020;
   faAnyFile   = $0000003F;

   //sockets
   winsocketVersion       = $0101;//windows 95 compatiable
   WSADESCRIPTION_LEN     = 256;
   WSASYS_STATUS_LEN      = 128;
   INVALID_SOCKET         = tsocket(not(0));//This is used instead of -1, since the TSocket type is unsigned
   SOCKET_ERROR	          = -1;
   SOL_SOCKET             = $ffff;          {options for socket level }
   WSABASEERR             = 10000;
   WSAEWOULDBLOCK         = (WSABASEERR+35);

   //option for opening sockets for synchronous access
   SO_OPENTYPE            = $7008;
   SO_SYNCHRONOUS_ALERT   = $10;
   SO_SYNCHRONOUS_NONALERT= $20;
   SO_ACCEPTCONN          = $0002;          { socket has had listen() }
   SO_KEEPALIVE           = $0008;          { keep connections alive }
   SO_LINGER              = $0080;          { linger on close if data present }
   SO_DONTLINGER          = $ff7f;

   INADDR_ANY             = $00000000;
   INADDR_LOOPBACK        = $7F000001;
   INADDR_BROADCAST       = $FFFFFFFF;
   INADDR_NONE            = $FFFFFFFF;

   //Address families
   AF_UNSPEC       = 0;               { unspecified }
   AF_UNIX         = 1;               { local to host (pipes, portals) }
   AF_INET         = 2;               { internetwork: UDP, TCP, etc. }

   //Protocol families - same as address families for now. }
   PF_UNSPEC       = AF_UNSPEC;
   PF_UNIX         = AF_UNIX;
   PF_INET         = AF_INET;

   //Types
   SOCK_STREAM     = 1;               { stream socket }
   SOCK_DGRAM      = 2;               { datagram socket }
   SOCK_RAW        = 3;               { raw-protocol interface }
   SOCK_RDM        = 4;               { reliably-delivered message }
   SOCK_SEQPACKET  = 5;               { sequenced packet stream }

   //Protocols
   IPPROTO_IP     =   0;             { dummy for IP }
   IPPROTO_ICMP   =   1;             { control message protocol }
   IPPROTO_IGMP   =   2;             { group management protocol }
   IPPROTO_GGP    =   3;             { gateway^2 (deprecated) }
   IPPROTO_TCP    =   6;             { tcp }
   IPPROTO_PUP    =  12;             { pup }
   IPPROTO_UDP    =  17;             { user datagram protocol }
   IPPROTO_IDP    =  22;             { xns idp }
   IPPROTO_ND     =  77;             { UNOFFICIAL net disk proto }
   IPPROTO_RAW    =  255;            { raw IP packet }
   IPPROTO_MAX    =  256;

   //Define flags to be used with the WSAAsyncSelect
   FD_READ         = $01;
   FD_WRITE        = $02;
   FD_OOB          = $04;
   FD_ACCEPT       = $08;
   FD_CONNECT      = $10;{=16}
   FD_CLOSE        = $20;{=32}

   IOCPARM_MASK = $7f;
   IOC_VOID     = $20000000;
   IOC_OUT      = $40000000;
   IOC_IN       = $80000000;
   IOC_INOUT    = (IOC_IN or IOC_OUT);

   FIONREAD     = IOC_OUT or { get # bytes to read }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 127;
   FIONBIO      = IOC_IN or { set/clear non-blocking i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 126;
   FIOASYNC     = IOC_IN or { set/clear async i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 125;

   //values to access various Windows paths (folders)
   REGSTR_PATH_EXPLORER        = 'Software\Microsoft\Windows\CurrentVersion\Explorer';
   REGSTR_PATH_SPECIAL_FOLDERS   = REGSTR_PATH_EXPLORER + '\Shell Folders';
   CSIDL_DESKTOP                       = $0000;
   CSIDL_PROGRAMS                      = $0002;
   CSIDL_CONTROLS                      = $0003;
   CSIDL_PRINTERS                      = $0004;
   CSIDL_PERSONAL                      = $0005;
   CSIDL_FAVORITES                     = $0006;
   CSIDL_STARTUP                       = $0007;
   CSIDL_RECENT                        = $0008;
   CSIDL_SENDTO                        = $0009;
   CSIDL_BITBUCKET                     = $000a;
   CSIDL_STARTMENU                     = $000b;
   CSIDL_DESKTOPDIRECTORY              = $0010;
   CSIDL_DRIVES                        = $0011;
   CSIDL_NETWORK                       = $0012;
   CSIDL_NETHOOD                       = $0013;
   CSIDL_FONTS                         = $0014;
   CSIDL_TEMPLATES                     = $0015;
   CSIDL_COMMON_STARTMENU              = $0016;
   CSIDL_COMMON_PROGRAMS               = $0017;
   CSIDL_COMMON_STARTUP                = $0018;
   CSIDL_COMMON_DESKTOPDIRECTORY       = $0019;
   CSIDL_APPDATA                       = $001a;
   CSIDL_PRINTHOOD                     = $001b;

   CLSCTX_INPROC_SERVER     = 1;
   CLSCTX_INPROC_HANDLER    = 2;
   CLSCTX_LOCAL_SERVER      = 4;
   CLSCTX_INPROC_SERVER16   = 8;
   CLSCTX_REMOTE_SERVER     = $10;
   CLSCTX_INPROC_HANDLER16  = $20;
   CLSCTX_INPROC_SERVERX86  = $40;
   CLSCTX_INPROC_HANDLERX86 = $80;

  // String constants for Interface IDs
   SID_INewShortcutHookA  = '{000214E1-0000-0000-C000-000000000046}';
   SID_IShellBrowser      = '{000214E2-0000-0000-C000-000000000046}';
   SID_IShellView         = '{000214E3-0000-0000-C000-000000000046}';
   SID_IContextMenu       = '{000214E4-0000-0000-C000-000000000046}';
   SID_IShellIcon         = '{000214E5-0000-0000-C000-000000000046}';
   SID_IShellFolder       = '{000214E6-0000-0000-C000-000000000046}';
   SID_IShellExtInit      = '{000214E8-0000-0000-C000-000000000046}';
   SID_IShellPropSheetExt = '{000214E9-0000-0000-C000-000000000046}';
   SID_IPersistFolder     = '{000214EA-0000-0000-C000-000000000046}';
   SID_IExtractIconA      = '{000214EB-0000-0000-C000-000000000046}';
   SID_IShellLinkA        = '{000214EE-0000-0000-C000-000000000046}';
   SID_IShellCopyHookA    = '{000214EF-0000-0000-C000-000000000046}';
   SID_IFileViewerA       = '{000214F0-0000-0000-C000-000000000046}';
   SID_ICommDlgBrowser    = '{000214F1-0000-0000-C000-000000000046}';
   SID_IEnumIDList        = '{000214F2-0000-0000-C000-000000000046}';
   SID_IFileViewerSite    = '{000214F3-0000-0000-C000-000000000046}';
   SID_IContextMenu2      = '{000214F4-0000-0000-C000-000000000046}';
   SID_IShellExecuteHookA = '{000214F5-0000-0000-C000-000000000046}';
   SID_IPropSheetPage     = '{000214F6-0000-0000-C000-000000000046}';
   SID_INewShortcutHookW  = '{000214F7-0000-0000-C000-000000000046}';
   SID_IFileViewerW       = '{000214F8-0000-0000-C000-000000000046}';
   SID_IShellLinkW        = '{000214F9-0000-0000-C000-000000000046}';
   SID_IExtractIconW      = '{000214FA-0000-0000-C000-000000000046}';
   SID_IShellExecuteHookW = '{000214FB-0000-0000-C000-000000000046}';
   SID_IShellCopyHookW    = '{000214FC-0000-0000-C000-000000000046}';
   SID_IShellView2        = '{88E39E80-3578-11CF-AE69-08002B2E1262}';

    // Class IDs        xx=00-9F
   CLSID_ShellDesktop: TGUID = (
        D1:$00021400; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
   CLSID_ShellLink: TGUID = (
        D1:$00021401; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));


   { Logical Font }
   LF_FACESIZE = 32;

   DEFAULT_QUALITY = 0;
   DRAFT_QUALITY = 1;
   PROOF_QUALITY = 2;
   NONANTIALIASED_QUALITY = 3;
   ANTIALIASED_QUALITY = 4;



   STD_INPUT_HANDLE = DWORD(-10);
   STD_OUTPUT_HANDLE = DWORD(-11);
   STD_ERROR_HANDLE = DWORD(-12);

   SEM_FAILCRITICALERRORS = 1;
   SEM_NOGPFAULTERRORBOX = 2;
   SEM_NOALIGNMENTFAULTEXCEPT = 4;
   SEM_NOOPENFILEERRORBOX = $8000;

   { PeekMessage() Options }
   PM_NOREMOVE = 0;
   PM_REMOVE = 1;
   PM_NOYIELD = 2;

   { Success codes }
   S_OK    = $00000000;
   S_FALSE = $00000001;

   NOERROR = 0;

   //file support
   MAX_PATH = 260;
   INVALID_HANDLE_VALUE = -1;
   INVALID_FILE_SIZE = DWORD($FFFFFFFF);

   OFN_READONLY = $00000001;
   OFN_OVERWRITEPROMPT = $00000002;
   OFN_HIDEREADONLY = $00000004;
   OFN_NOCHANGEDIR = $00000008;
   OFN_SHOWHELP = $00000010;
   OFN_ENABLEHOOK = $00000020;
   OFN_ENABLETEMPLATE = $00000040;
   OFN_ENABLETEMPLATEHANDLE = $00000080;
   OFN_NOVALIDATE = $00000100;
   OFN_ALLOWMULTISELECT = $00000200;
   OFN_EXTENSIONDIFFERENT = $00000400;
   OFN_PATHMUSTEXIST = $00000800;
   OFN_FILEMUSTEXIST = $00001000;
   OFN_CREATEPROMPT = $00002000;
   OFN_SHAREAWARE = $00004000;
   OFN_NOREADONLYRETURN = $00008000;
   OFN_NOTESTFILECREATE = $00010000;
   OFN_NONETWORKBUTTON = $00020000;
   OFN_NOLONGNAMES = $00040000;
   OFN_EXPLORER = $00080000;
   OFN_NODEREFERENCELINKS = $00100000;
   OFN_LONGNAMES = $00200000;

   CC_RGBINIT = $00000001;
   CC_FULLOPEN = $00000002;
   CC_PREVENTFULLOPEN = $00000004;
   CC_SHOWHELP = $00000008;
   CC_ENABLEHOOK = $00000010;
   CC_ENABLETEMPLATE = $00000020;
   CC_ENABLETEMPLATEHANDLE = $00000040;
   CC_SOLIDCOLOR = $00000080;
   CC_ANYCOLOR = $00000100;

   FILE_BEGIN = 0;
   FILE_CURRENT = 1;
   FILE_END = 2;

   FILE_SHARE_READ                     = $00000001;
   FILE_SHARE_WRITE                    = $00000002;
   FILE_SHARE_DELETE                   = $00000004;
   FILE_ATTRIBUTE_READONLY             = $00000001;
   FILE_ATTRIBUTE_HIDDEN               = $00000002;
   FILE_ATTRIBUTE_SYSTEM               = $00000004;
   FILE_ATTRIBUTE_DIRECTORY            = $00000010;
   FILE_ATTRIBUTE_ARCHIVE              = $00000020;
   FILE_ATTRIBUTE_NORMAL               = $00000080;
   FILE_ATTRIBUTE_TEMPORARY            = $00000100;
   FILE_ATTRIBUTE_COMPRESSED           = $00000800;
   FILE_ATTRIBUTE_OFFLINE              = $00001000;
   FILE_NOTIFY_CHANGE_FILE_NAME        = $00000001;
   FILE_NOTIFY_CHANGE_DIR_NAME         = $00000002;
   FILE_NOTIFY_CHANGE_ATTRIBUTES       = $00000004;
   FILE_NOTIFY_CHANGE_SIZE             = $00000008;
   FILE_NOTIFY_CHANGE_LAST_WRITE       = $00000010;
   FILE_NOTIFY_CHANGE_LAST_ACCESS      = $00000020;
   FILE_NOTIFY_CHANGE_CREATION         = $00000040;
   FILE_NOTIFY_CHANGE_SECURITY         = $00000100;
   FILE_ACTION_ADDED                   = $00000001;
   FILE_ACTION_REMOVED                 = $00000002;
   FILE_ACTION_MODIFIED                = $00000003;
   FILE_ACTION_RENAMED_OLD_NAME        = $00000004;
   FILE_ACTION_RENAMED_NEW_NAME        = $00000005;
   MAILSLOT_NO_MESSAGE                 = -1;
   MAILSLOT_WAIT_FOREVER               = -1;
   FILE_CASE_SENSITIVE_SEARCH          = $00000001;
   FILE_CASE_PRESERVED_NAMES           = $00000002;
   FILE_UNICODE_ON_DISK                = $00000004;
   FILE_PERSISTENT_ACLS                = $00000008;
   FILE_FILE_COMPRESSION               = $00000010;
   FILE_VOLUME_IS_COMPRESSED           = $00008000;

  { File creation flags must start at the high end since they }
  { are combined with the attributes}

   FILE_FLAG_WRITE_THROUGH = $80000000;
   FILE_FLAG_OVERLAPPED = $40000000;
   FILE_FLAG_NO_BUFFERING = $20000000;
   FILE_FLAG_RANDOM_ACCESS = $10000000;
   FILE_FLAG_SEQUENTIAL_SCAN = $8000000;
   FILE_FLAG_DELETE_ON_CLOSE = $4000000;
   FILE_FLAG_BACKUP_SEMANTICS = $2000000;
   FILE_FLAG_POSIX_SEMANTICS = $1000000;

   CREATE_NEW = 1;
   CREATE_ALWAYS = 2;
   OPEN_EXISTING = 3;
   OPEN_ALWAYS = 4;
   TRUNCATE_EXISTING = 5;


//sound procs support ----------------------------------------------------------
{$ifdef snd}

   MHDR_DONE           = $00000001;       { done bit }
   MHDR_PREPARED       = $00000002;       { set if header prepared }
   MHDR_INQUEUE        = $00000004;       { reserved for driver }
   MHDR_ISSTRM         = $00000008;       { Buffer is stream buffer }
   MM_MOM_OPEN         = $3C7;//actual buffer
   MM_MOM_CLOSE        = $3C8;//actual buffer
   MM_MOM_DONE         = $3C9;//actual buffer
   CALLBACK_FUNCTION   = $00030000;    { dwCallback is a FARPROC }
   CALLBACK_WINDOW     = $00010000;    { dwCallback is a HWND }
   WAVERR_BASE         = 32;
   MIDIERR_BASE        = 64;
   MIDI_MAPPER         = UINT(-1);//20JAN2011
   WAVE_MAPPER         = UINT(-1);
   CALLBACK_NULL       = $00000000;//no callback
   MAXPNAMELEN         = 32;    { max product name length (including nil) }
   MMSYSERR_NOERROR    = 0;                  { no error }
   WAVECAPS_VOLUME     = $0004;   { supports volume control }
   WAVECAPS_LRVOLUME   = $0008;   { separate left-right volume control }
   MIDICAPS_VOLUME     = $0001;  { supports volume control }
   MIDICAPS_LRVOLUME   = $0002;  { separate left-right volume control }

{ flags for dwFlags field of WAVEHDR }
   //.wave
   WHDR_DONE       = $00000001;  { done bit }
   WHDR_PREPARED   = $00000002;  { set if this header has been prepared }
   WHDR_BEGINLOOP  = $00000004;  { loop start block }
   WHDR_ENDLOOP    = $00000008;  { loop end block }
   WHDR_INQUEUE    = $00000010;  { reserved for driver }
   MM_WOM_OPEN         = $3BB;
   MM_WOM_CLOSE        = $3BC;
   MM_WIM_OPEN         = $3BE;
   MM_WIM_CLOSE        = $3BF;
   MM_WIM_DATA         = $3C0;
   WAVE_FORMAT_QUERY   = $0001;
   WAVE_ALLOWSYNC      = $0002;
   WAVE_MAPPED         = $0004;

   //.midi
   MIDIERR_UNPREPARED    = MIDIERR_BASE + 0;   { header not prepared }
   MIDIERR_STILLPLAYING  = MIDIERR_BASE + 1;   { still something playing }
   MIDIERR_NOMAP         = MIDIERR_BASE + 2;   { no current map }
   MIDIERR_NOTREADY      = MIDIERR_BASE + 3;   { hardware is still busy }
   MIDIERR_NODEVICE      = MIDIERR_BASE + 4;   { port no longer connected }
   MIDIERR_INVALIDSETUP  = MIDIERR_BASE + 5;   { invalid setup }
   MIDIERR_BADOPENMODE   = MIDIERR_BASE + 6;   { operation unsupported w/ open mode }
   MIDIERR_DONT_CONTINUE = MIDIERR_BASE + 7;   { thru device 'eating' a message }
   MIDIERR_LASTERROR     = MIDIERR_BASE + 5;   { last error in range }

  //  GM_Reset: array[1..6] of byte = ($F0, $7E, $7F, $09, $01, $F7); // = GM_On
//  GS_Reset: array[1..11] of byte = ($F0, $41, $10, $42, $12, $40, $00, $7F, $00, $41, $F7);
//  XG_Reset: array[1..9] of byte = ($F0, $43, $10, $4C, $00, $00, $7E, $00, $F7);
//  GM2_On: array[1..6] of byte = ($F0, $7E, $7F, $09, $03, $F7);  // = GM2_Reset
//  GM2_Off: array[1..6] of byte = ($F0, $7E, $7F, $09, $02, $F7); // switch to GS
//  GS_Off: array[1..11] of byte = ($F0, $41, $10, $42, $12, $40, $00, $7F, $7F, $42, $F7); // = Exit GS Mode
//  SysExMasterVolume: array[1..8] of byte = ($F0, $7F, $7F, $04, $01, $0, $0, $F7);

{multi-media}
  //general
  MM_MCINOTIFY        = $3B9;
  //flags for wParam of MM_MCINOTIFY message
  MCI_NOTIFY_SUCCESSFUL           =$0001;
  MCI_NOTIFY_SUPERSEDED           =$0002;
  MCI_NOTIFY_ABORTED              =$0004;
  MCI_NOTIFY_FAILURE              =$0008;
  //common flags for dwFlags parameter of MCI command messages
  MCI_NOTIFY                      =$00000001;
  MCI_WAIT                        =$00000002;
  MCI_FROM                        =$00000004;
  MCI_TO                          =$00000008;
  MCI_TRACK                       =$00000010;
  //flags for dwFlags parameter of MCI_OPEN command message
  MCI_OPEN_SHAREABLE              =$00000100;
  MCI_OPEN_ELEMENT                =$00000200;
  MCI_OPEN_ALIAS                  =$00000400;
  MCI_OPEN_ELEMENT_ID             =$00000800;
  MCI_OPEN_TYPE_ID                =$00001000;
  MCI_OPEN_TYPE                   =$00002000;
  //other
  MCI_SET_DOOR_OPEN               = $00000100;
  MCI_SET_DOOR_CLOSED             = $00000200;
  MCI_SET_TIME_FORMAT             = $00000400;
  MCI_SET_AUDIO                   = $00000800;
  MCI_SET_VIDEO                   = $00001000;
  MCI_SET_ON                      = $00002000;
  MCI_SET_OFF                     = $00004000;
  //MCI command message identifiers
  MCI_OPEN                        =$0803;
  MCI_CLOSE                       =$0804;
  MCI_ESCAPE                      =$0805;
  MCI_PLAY                        =$0806;
  MCI_SEEK                        =$0807;
  MCI_STOP                        =$0808;
  MCI_PAUSE                       =$0809;
  MCI_INFO                        =$080A;
  MCI_GETDEVCAPs                  =$080B;
  MCI_SPIN                        =$080C;
  MCI_SET                         =$080D;
  MCI_STEP                        =$080E;
  MCI_RECORD                      =$080F;
  MCI_SYSINFO                     =$0810;
  MCI_BREAK                       =$0811;
  MCI_SOUND                       =$0812;
  MCI_SAVE                        =$0813;
  MCI_STATUS                      =$0814;
  MCI_CUE                         =$0830;
  MCI_REALIZE                     =$0840;
  MCI_WINDOW                      =$0841;
  MCI_PUT                         =$0842;
  MCI_WHERE                       =$0843;
  MCI_FREEZE                      =$0844;
  MCI_UNFREEZE                    =$0845;
  MCI_LOAD                        =$0850;
  MCI_CUT                         =$0851;
  MCI_COPY                        =$0852;
  MCI_PASTE                       =$0853;
  MCI_UPDATE                      =$0854;
  MCI_RESUME                      =$0855;
  MCI_DELETE                      =$0856;
  //flags for dwFlags parameter of MCI_STATUS command message
  MCI_STATUS_ITEM                 =$00000100;
  MCI_STATUS_START                =$00000200;
  //flags for dwItem field of the MCI_STATUS_PARMS parameter block
  MCI_STATUS_LENGTH               =$00000001;
  MCI_STATUS_POSITION             =$00000002;
  MCI_STATUS_NUMBER_OF_TRACKS     =$00000003;
  MCI_STATUS_MODE                 =$00000004;
  MCI_STATUS_MEDIA_PRESENT        =$00000005;
  MCI_STATUS_TIME_FORMAT          =$00000006;
  MCI_STATUS_READY                =$00000007;
  MCI_STATUS_CURRENT_TRACK        =$00000008;

{$endif}
//sound procs support - end ----------------------------------------------------

  { Parameter for SystemParametersInfo() }
  SPI_GETBEEP = 1;
  SPI_SETBEEP = 2;
  SPI_GETMOUSE = 3;
  SPI_SETMOUSE = 4;
  SPI_GETBORDER = 5;
  SPI_SETBORDER = 6;
  SPI_GETKEYBOARDSPEED = 10;
  SPI_SETKEYBOARDSPEED = 11;
  SPI_LANGDRIVER = 12;
  SPI_ICONHORIZONTALSPACING = 13;
  SPI_GETSCREENSAVETIMEOUT = 14;
  SPI_SETSCREENSAVETIMEOUT = 15;
  SPI_GETSCREENSAVEACTIVE = $10;
  SPI_SETSCREENSAVEACTIVE = 17;
  SPI_GETGRIDGRANULARITY = 18;
  SPI_SETGRIDGRANULARITY = 19;
  SPI_SETDESKWALLPAPER = 20;
  SPI_SETDESKPATTERN = 21;
  SPI_GETKEYBOARDDELAY = 22;
  SPI_SETKEYBOARDDELAY = 23;
  SPI_ICONVERTICALSPACING = 24;
  SPI_GETICONTITLEWRAP = 25;
  SPI_SETICONTITLEWRAP = 26;
  SPI_GETMENUDROPALIGNMENT = 27;
  SPI_SETMENUDROPALIGNMENT = 28;
  SPI_SETDOUBLECLKWIDTH = 29;
  SPI_SETDOUBLECLKHEIGHT = 30;
  SPI_GETICONTITLELOGFONT = 31;
  SPI_SETDOUBLECLICKTIME = $20;
  SPI_SETMOUSEBUTTONSWAP = 33;
  SPI_SETICONTITLELOGFONT = 34;
  SPI_GETFASTTASKSWITCH = 35;
  SPI_SETFASTTASKSWITCH = 36;
  SPI_SETDRAGFULLWINDOWS = 37;
  SPI_GETDRAGFULLWINDOWS = 38;
  SPI_GETNONCLIENTMETRICS = 41;
  SPI_SETNONCLIENTMETRICS = 42;
  SPI_GETMINIMIZEDMETRICS = 43;
  SPI_SETMINIMIZEDMETRICS = 44;
  SPI_GETICONMETRICS = 45;
  SPI_SETICONMETRICS = 46;
  SPI_SETWORKAREA = 47;
  SPI_GETWORKAREA = 48;
  SPI_SETPENWINDOWS = 49;

  SPI_GETHIGHCONTRAST = 66;
  SPI_SETHIGHCONTRAST = 67;
  SPI_GETKEYBOARDPREF = 68;
  SPI_SETKEYBOARDPREF = 69;
  SPI_GETSCREENREADER = 70;
  SPI_SETSCREENREADER = 71;
  SPI_GETANIMATION = 72;
  SPI_SETANIMATION = 73;
  SPI_GETFONTSMOOTHING = 74;
  SPI_SETFONTSMOOTHING = 75;
  SPI_SETDRAGWIDTH = 76;
  SPI_SETDRAGHEIGHT = 77;
  SPI_SETHANDHELD = 78;
  SPI_GETLOWPOWERTIMEOUT = 79;
  SPI_GETPOWEROFFTIMEOUT = 80;
  SPI_SETLOWPOWERTIMEOUT = 81;
  SPI_SETPOWEROFFTIMEOUT = 82;
  SPI_GETLOWPOWERACTIVE = 83;
  SPI_GETPOWEROFFACTIVE = 84;
  SPI_SETLOWPOWERACTIVE = 85;
  SPI_SETPOWEROFFACTIVE = 86;
  SPI_SETCURSORS = 87;
  SPI_SETICONS = 88;
  SPI_GETDEFAULTINPUTLANG = 89;
  SPI_SETDEFAULTINPUTLANG = 90;
  SPI_SETLANGTOGGLE = 91;
  SPI_GETWINDOWSEXTENSION = 92;
  SPI_SETMOUSETRAILS = 93;
  SPI_GETMOUSETRAILS = 94;
  SPI_SCREENSAVERRUNNING = 97;
  SPI_GETFILTERKEYS = 50;
  SPI_SETFILTERKEYS = 51;
  SPI_GETTOGGLEKEYS = 52;
  SPI_SETTOGGLEKEYS = 53;
  SPI_GETMOUSEKEYS = 54;
  SPI_SETMOUSEKEYS = 55;
  SPI_GETSHOWSOUNDS = 56;
  SPI_SETSHOWSOUNDS = 57;
  SPI_GETSTICKYKEYS = 58;
  SPI_SETSTICKYKEYS = 59;
  SPI_GETACCESSTIMEOUT = 60;
  SPI_SETACCESSTIMEOUT = 61;
  SPI_GETSERIALKEYS = 62;
  SPI_SETSERIALKEYS = 63;
  SPI_GETSOUNDSENTRY = $40;
  SPI_SETSOUNDSENTRY = 65;

  SPI_GETSNAPTODEFBUTTON = 95; 
  SPI_SETSNAPTODEFBUTTON = 96; 
  SPI_GETMOUSEHOVERWIDTH = 98; 
  SPI_SETMOUSEHOVERWIDTH = 99; 
  SPI_GETMOUSEHOVERHEIGHT = 100; 
  SPI_SETMOUSEHOVERHEIGHT = 101; 
  SPI_GETMOUSEHOVERTIME = 102; 
  SPI_SETMOUSEHOVERTIME = 103; 
  SPI_GETWHEELSCROLLLINES = 104; 
  SPI_SETWHEELSCROLLLINES = 105;

  THREAD_BASE_PRIORITY_LOWRT = 15;  { value that gets a thread to LowRealtime-1 }
  THREAD_BASE_PRIORITY_MAX = 2;     { maximum thread base priority boost }
  THREAD_BASE_PRIORITY_MIN = -2;    { minimum thread base priority boost }
  THREAD_BASE_PRIORITY_IDLE = -15;  { value that gets a thread to idle }

  THREAD_PRIORITY_LOWEST              = THREAD_BASE_PRIORITY_MIN;
  THREAD_PRIORITY_BELOW_NORMAL        = THREAD_PRIORITY_LOWEST + 1;
  THREAD_PRIORITY_NORMAL              = 0;
  THREAD_PRIORITY_HIGHEST             = THREAD_BASE_PRIORITY_MAX;
  THREAD_PRIORITY_ABOVE_NORMAL        = THREAD_PRIORITY_HIGHEST - 1;
  THREAD_PRIORITY_ERROR_RETURN        = MAXLONG;

  THREAD_PRIORITY_TIME_CRITICAL       = THREAD_BASE_PRIORITY_LOWRT;
  THREAD_PRIORITY_IDLE                = THREAD_BASE_PRIORITY_IDLE;


type
   TFNWndProc = TFarProc;
   TFNDlgProc = TFarProc;
   TFNTimerProc = TFarProc;
   TFNGrayStringProc = TFarProc;
   TFNWndEnumProc = TFarProc;
   TFNSendAsyncProc = TFarProc;
   TFNDrawStateProc = TFarProc;
   TFNTimeCallBack  = procedure(uTimerID,uMessage:UINT;dwUser,dw1,dw2:dword) stdcall;// <<-- special note: NO semicolon between "dword)" and "stdcall"!!!!
   TFNHookProc      = function (code: Integer; wparam: WPARAM; lparam: LPARAM): LRESULT stdcall;

   //.service status
   PServiceStatus = ^TServiceStatus;
   TServiceStatus = record
     dwServiceType: DWORD;
     dwCurrentState: DWORD;
     dwControlsAccepted: DWORD;
     dwWin32ExitCode: DWORD;
     dwServiceSpecificExitCode: DWORD;
     dwCheckPoint: DWORD;
     dwWaitHint: DWORD;
   end;

   TServiceMainFunction = tfarproc;
   PServiceTableEntry = ^TServiceTableEntry;
   TServiceTableEntry = record
     lpServiceName: PAnsiChar;
     lpServiceProc: TServiceMainFunction;
   end;

   //.network
   PWSAData = ^TWSAData;
   TWSAData = packed record
    wVersion: Word;
    wHighVersion: Word;
    szDescription: array[0..WSADESCRIPTION_LEN] of Char;
    szSystemStatus: array[0..WSASYS_STATUS_LEN] of Char;
    iMaxSockets: Word;
    iMaxUdpDg: Word;
    lpVendorInfo: PChar;
    end;

   SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
    end;

   SunW = packed record
    s_w1, s_w2: u_short;
    end;

   PInAddr = ^TInAddr;
   TInAddr = packed record
    case integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
    end;

   PSockAddrIn = ^TSockAddrIn;
   TSockAddrIn = packed record
    case Integer of
      0: (sin_family: u_short;
          sin_port: u_short;
          sin_addr: TInAddr;
          sin_zero: array[0..7] of Char);
      1: (sa_family: u_short;
          sa_data: array[0..13] of Char)
    end;

   PSockAddr = ^TSockAddr;
   TSockAddr = TSockAddrIn;

   PWindowPlacement = ^TWindowPlacement;
   TWindowPlacement = packed record
     length: UINT;
     flags: UINT;
     showCmd: UINT;
     ptMinPosition: TPoint;
     ptMaxPosition: TPoint;
     rcNormalPosition: twinrect;
   end;

{ Interface ID }

   PIID = PGUID;
   TIID = TGUID;

{ Class ID }

   PCLSID = PGUID;
   TCLSID = TGUID;

  PPaintStruct = ^TPaintStruct;
  TPaintStruct = packed record
    hdc: HDC;
    fErase: BOOL;
    rcPaint: twinrect;
    fRestore: BOOL;
    fIncUpdate: BOOL;
    rgbReserved: array[0..31] of Byte;
  end;

   pmsg = ^tmsg;
   tmsg = packed record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;
    pt: TPoint;
   end;

   //WM_WINDOWPOSCHANGINGCHANGED struct pointed to by lParam
   PWindowPos = ^TWindowPos;
   TWindowPos = packed record
     hwnd: HWND;
     hwndInsertAfter: HWND;
     x: Integer;
     y: Integer;
     cx: Integer;
     cy: Integer;
     flags: UINT;
   end;

   PConsoleScreenBufferInfo = ^TConsoleScreenBufferInfo;
   TConsoleScreenBufferInfo = packed record
     dwSize: TCoord;
     dwCursorPosition: TCoord;
     wAttributes: Word;
     srWindow: TSmallRect;
     dwMaximumWindowSize: TCoord;
   end;

   PConsoleCursorInfo = ^TConsoleCursorInfo;
   TConsoleCursorInfo = packed record
     dwSize: DWORD;
     bVisible: BOOL;
   end;


   TOleChar = WideChar;
   POleStr = PWideChar;

   POleStrList = ^TOleStrList;
   TOleStrList = array[0..65535] of POleStr;


{ TSHItemID -- Item ID }
   PSHItemID = ^TSHItemID;
   TSHItemID = packed record           { mkid }
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
   end;

{ TItemIDList -- List if item IDs (combined with 0-terminator) }
   PItemIDList = ^TItemIDList;
   TItemIDList = packed record         { idl }
     mkid: TSHItemID;
    end;

   POverlapped = ^TOverlapped;
   TOverlapped = record
    Internal: DWORD;
    InternalHigh: DWORD;
    Offset: DWORD;
    OffsetHigh: DWORD;
    hEvent: THandle;
   end;

   PSecurityAttributes = ^TSecurityAttributes;
   TSecurityAttributes = record
    nLength: DWORD;
    lpSecurityDescriptor: Pointer;
    bInheritHandle: BOOL;
   end;

   PProcessInformation = ^TProcessInformation;
   TProcessInformation = record
    hProcess: THandle;
    hThread: THandle;
    dwProcessId: DWORD;
    dwThreadId: DWORD;
   end;

  { File System time stamps are represented with the following structure: }
   PFileTime = ^TFileTime;
   TFileTime = record
    dwLowDateTime: DWORD;
    dwHighDateTime: DWORD;
   end;

   PByHandleFileInformation = ^TByHandleFileInformation;
   TByHandleFileInformation = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    dwVolumeSerialNumber: DWORD;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    nNumberOfLinks: DWORD;
    nFileIndexHigh: DWORD;
    nFileIndexLow: DWORD;
   end;

  pwinmenuiteminfo = ^twinmenuiteminfo;
  twinmenuiteminfo = packed record
    cbSize: UINT;
    fMask: UINT;
    fType: UINT;             { used if MIIM_TYPE}
    fState: UINT;            { used if MIIM_STATE}
    wID: UINT;               { used if MIIM_ID}
    hSubMenu: HMENU;         { used if MIIM_SUBMENU}
    hbmpChecked: HBITMAP;    { used if MIIM_CHECKMARKS}
    hbmpUnchecked: HBITMAP;  { used if MIIM_CHECKMARKS}
    dwItemData: DWORD;       { used if MIIM_DATA}
    dwTypeData: PAnsiChar;      { used if MIIM_TYPE}
    cch: UINT;               { used if MIIM_TYPE}
  end;

  { System time is represented with the following structure: }
  PSystemTime = ^TSystemTime;
  TSystemTime = record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;

   PWndClassExA = ^TWndClassExA;
   PWndClassExW = ^TWndClassExW;
   PWndClassEx = PWndClassExA;
   TWndClassExA = packed record
    cbSize: UINT;
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: Integer;
    cbWndExtra: Integer;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PAnsiChar;
    lpszClassName: PAnsiChar;
    hIconSm: HICON;
   end;
   TWndClassExW = packed record
    cbSize: UINT;
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: Integer;
    cbWndExtra: Integer;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PWideChar;
    lpszClassName: PWideChar;
    hIconSm: HICON;
   end;
   TWndClassEx = TWndClassExA;

   PWndClassA = ^TWndClassA;
   PWndClassW = ^TWndClassW;
   PWndClass = PWndClassA;
   TWndClassA = packed record
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: Integer;
    cbWndExtra: Integer;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PAnsiChar;
    lpszClassName: PAnsiChar;
   end;
   TWndClassW = packed record
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: Integer;
    cbWndExtra: Integer;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PWideChar;
    lpszClassName: PWideChar;
   end;
   TWndClass = TWndClassA;

   PWin32FindDataA = ^TWin32FindDataA;
   PWin32FindDataW = ^TWin32FindDataW;
   PWin32FindData = PWin32FindDataA;
   TWin32FindDataA = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..MAX_PATH - 1] of AnsiChar;
    cAlternateFileName: array[0..13] of AnsiChar;
   end;
   TWin32FindDataW = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..MAX_PATH - 1] of WideChar;
    cAlternateFileName: array[0..13] of WideChar;
   end;
   TWin32FindData = TWin32FindDataA;

   { Search record used by FindFirst, FindNext, and FindClose }
   TSearchRec = record
       Time: Integer;
       Size: Integer;
       Attr: Integer;
       Name: TFileName;
       ExcludeAttr: Integer;
       FindHandle: THandle;
       FindData: TWin32FindData;
      end;

  {console input}
  PKeyEventRecord = ^TKeyEventRecord;
  TKeyEventRecord = packed record
    bKeyDown: BOOL;
    wRepeatCount: Word;
    wVirtualKeyCode: Word;
    wVirtualScanCode: Word;
    case longint of
    0:(UnicodeChar:WCHAR; dwControlKeyStateU:DWORD);
    1:(AsciiChar:CHAR; dwControlKeyState:DWORD);
    end;


  PMouseEventRecord = ^TMouseEventRecord;
  TMouseEventRecord = packed record
    dwMousePosition: TCoord;
    dwButtonState: DWORD;
    dwControlKeyState: DWORD;
    dwEventFlags: DWORD;
  end;

  PWindowBufferSizeRecord = ^TWindowBufferSizeRecord;
  TWindowBufferSizeRecord = packed record
    dwSize: TCoord;
  end;

  PMenuEventRecord = ^TMenuEventRecord;
  TMenuEventRecord = packed record
    dwCommandId: UINT;
  end;

  PFocusEventRecord = ^TFocusEventRecord;
  TFocusEventRecord = packed record
    bSetFocus: BOOL;
  end;

   PInputRecord = ^TInputRecord;
   TInputRecord = record
    EventType: Word;
    case Integer of
      0: (KeyEvent: TKeyEventRecord);
      1: (MouseEvent: TMouseEventRecord);
      2: (WindowBufferSizeEvent: TWindowBufferSizeRecord);
      3: (MenuEvent: TMenuEventRecord);
      4: (FocusEvent: TFocusEventRecord);
    end;

   //.font support
   PLogFontA = ^TLogFontA;
   PLogFontW = ^TLogFontW;
   PLogFont = PLogFontA;
   TLogFontA = packed record
    lfHeight: Longint;
    lfWidth: Longint;
    lfEscapement: Longint;
    lfOrientation: Longint;
    lfWeight: Longint;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: Byte;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: Byte;
    lfPitchAndFamily: Byte;
    lfFaceName: array[0..LF_FACESIZE - 1] of AnsiChar;
   end;
   TLogFontW = packed record
    lfHeight: Longint;
    lfWidth: Longint;
    lfEscapement: Longint;
    lfOrientation: Longint;
    lfWeight: Longint;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: Byte;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: Byte;
    lfPitchAndFamily: Byte;
    lfFaceName: array[0..LF_FACESIZE - 1] of WideChar;
   end;
   TLogFont = TLogFontA;

   PPrinterInfo4 = ^TPrinterInfo4;
   TPrinterInfo4 = record
     pPrinterName: PAnsiChar;
     pServerName: PAnsiChar;
     Attributes: DWORD;
   end;

   PPrinterInfo5 = ^TPrinterInfo5;
   TPrinterInfo5 = record
     pPrinterName: PAnsiChar;
     pPortName: PAnsiChar;
     Attributes: DWORD;
     DeviceNotSelectedTimeout: DWORD;
     TransmissionRetryTimeout: DWORD;
   end;


  { imalloc interface }
   imalloc = interface(IUnknown)
      ['{00000002-0000-0000-C000-000000000046}']
      function Alloc(cb: Longint): Pointer; stdcall;
      function Realloc(pv: Pointer; cb: Longint): Pointer; stdcall;
      procedure Free(pv: Pointer); stdcall;
      function GetSize(pv: Pointer): Longint; stdcall;
      function DidAlloc(pv: Pointer): Integer; stdcall;
      procedure HeapMinimize; stdcall;
   end;

   IShellLinkA = interface(IUnknown) { sl }
      [SID_IShellLinkA]
      function GetPath(pszFile: PAnsiChar; cchMaxPath: Integer;
        var pfd: TWin32FindData; fFlags: DWORD): HResult; stdcall;
      function GetIDList(var ppidl: PItemIDList): HResult; stdcall;
      function SetIDList(pidl: PItemIDList): HResult; stdcall;
      function GetDescription(pszName: PAnsiChar; cchMaxName: Integer): HResult; stdcall;
      function SetDescription(pszName: PAnsiChar): HResult; stdcall;
      function GetWorkingDirectory(pszDir: PAnsiChar; cchMaxPath: Integer): HResult; stdcall;
      function SetWorkingDirectory(pszDir: PAnsiChar): HResult; stdcall;
      function GetArguments(pszArgs: PAnsiChar; cchMaxPath: Integer): HResult; stdcall;
      function SetArguments(pszArgs: PAnsiChar): HResult; stdcall;
      function GetHotkey(var pwHotkey: Word): HResult; stdcall;
      function SetHotkey(wHotkey: Word): HResult; stdcall;
      function GetShowCmd(out piShowCmd: Integer): HResult; stdcall;
      function SetShowCmd(iShowCmd: Integer): HResult; stdcall;
      function GetIconLocation(pszIconPath: PAnsiChar; cchIconPath: Integer;
        out piIcon: Integer): HResult; stdcall;
      function SetIconLocation(pszIconPath: PAnsiChar; iIcon: Integer): HResult; stdcall;
      function SetRelativePath(pszPathRel: PAnsiChar; dwReserved: DWORD): HResult; stdcall;
      function Resolve(Wnd: HWND; fFlags: DWORD): HResult; stdcall;
      function SetPath(pszFile: PAnsiChar): HResult; stdcall;
   end;
   IShellLinkW = interface(IUnknown) { sl }
      [SID_IShellLinkW]
      function GetPath(pszFile: PWideChar; cchMaxPath: Integer;
        var pfd: TWin32FindData; fFlags: DWORD): HResult; stdcall;
      function GetIDList(var ppidl: PItemIDList): HResult; stdcall;
      function SetIDList(pidl: PItemIDList): HResult; stdcall;
      function GetDescription(pszName: PWideChar; cchMaxName: Integer): HResult; stdcall;
      function SetDescription(pszName: PWideChar): HResult; stdcall;
      function GetWorkingDirectory(pszDir: PWideChar; cchMaxPath: Integer): HResult; stdcall;
      function SetWorkingDirectory(pszDir: PWideChar): HResult; stdcall;
      function GetArguments(pszArgs: PWideChar; cchMaxPath: Integer): HResult; stdcall;
      function SetArguments(pszArgs: PWideChar): HResult; stdcall;
      function GetHotkey(var pwHotkey: Word): HResult; stdcall;
      function SetHotkey(wHotkey: Word): HResult; stdcall;
      function GetShowCmd(out piShowCmd: Integer): HResult; stdcall;
      function SetShowCmd(iShowCmd: Integer): HResult; stdcall;
      function GetIconLocation(pszIconPath: PWideChar; cchIconPath: Integer;
        out piIcon: Integer): HResult; stdcall;
      function SetIconLocation(pszIconPath: PWideChar; iIcon: Integer): HResult; stdcall;
      function SetRelativePath(pszPathRel: PWideChar; dwReserved: DWORD): HResult; stdcall;
      function Resolve(Wnd: HWND; fFlags: DWORD): HResult; stdcall;
      function SetPath(pszFile: PWideChar): HResult; stdcall;
   end;
   IShellLink = IShellLinkA;


   Exception = class(TObject)
   private
    FMessage: string;
    FHelpContext: Integer;
   public
    constructor Create(const Msg: string);
    constructor CreateFmt(const Msg: string; const Args: array of const);
    constructor CreateRes(Ident: Integer);
    constructor CreateResFmt(Ident: Integer; const Args: array of const);
    constructor CreateHelp(const Msg: string; AHelpContext: Integer);
    constructor CreateFmtHelp(const Msg: string; const Args: array of const;
      AHelpContext: Integer);
    constructor CreateResHelp(Ident: Integer; AHelpContext: Integer);
    constructor CreateResFmtHelp(Ident: Integer; const Args: array of const;
      AHelpContext: Integer);
    property HelpContext: Integer read FHelpContext write FHelpContext;
    property Message: string read FMessage write FMessage;
   end;


   { IPersist interface }
   IPersist = interface(IUnknown)
     ['{0000010C-0000-0000-C000-000000000046}']
     function GetClassID(out classID: TCLSID): HResult; stdcall;
   end;

   { IPersistFile interface }
   IPersistFile = interface(IPersist)
        ['{0000010B-0000-0000-C000-000000000046}']
        function IsDirty: HResult; stdcall;
        function Load(pszFileName: POleStr; dwMode: Longint): HResult;
          stdcall;
        function Save(pszFileName: POleStr; fRemember: BOOL): HResult;
          stdcall;
        function SaveCompleted(pszFileName: POleStr): HResult;
          stdcall;
        function GetCurFile(out pszFileName: POleStr): HResult;
          stdcall;
   end;


   win____EOleError = class(Exception);

   win____EOleSysError = class(win____EOleError)
      private
        FErrorCode: Integer;
      public
        constructor Create(const Message: string; ErrorCode: Integer;
          HelpContext: Integer);
        property ErrorCode: Integer read FErrorCode write FErrorCode;
      end;

   win____EOleException = class(win____EOleSysError)
      private
        FSource: string;
        FHelpFile: string;
      public
        constructor Create(const Message: string; ErrorCode: Integer;
          const Source, HelpFile: string; HelpContext: Integer);
        property HelpFile: string read FHelpFile write FHelpFile;
        property Source: string read FSource write FSource;
      end;

//sound procs support ----------------------------------------------------------
{$ifdef snd}
   //.midi system support
   MMVERSION = UINT;             { major (high byte), minor (low byte) }
   PHMIDI = ^HMIDI;
   HMIDI = longint;
   PHMIDIIN = ^HMIDIIN;
   HMIDIIN = longint;
   PHMIDIOUT = ^HMIDIOUT;
   HMIDIOUT = longint;
   PHMIDISTRM = ^HMIDISTRM;
   HMIDISTRM = longint;
   PHWAVE = ^HWAVE;
   HWAVE = longint;
   PHWAVEIN = ^HWAVEIN;
   HWAVEIN = longint;
   PHWAVEOUT = ^HWAVEOUT;
   HWAVEOUT = longint;

   PWaveOutCaps=^TWaveOutCaps;//fixed 28jun2024
   TWaveOutCaps = record
    wMid: Word;                 { manufacturer ID }
    wPid: Word;                 { product ID }
    vDriverVersion: MMVERSION;       { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of AnsiChar;  { product name (NULL terminated string) }
    dwFormats: DWORD;          { formats supported }
    wChannels: Word;            { number of sources supported }
    dwSupport: DWORD;          { functionality supported by driver }
    end;

   PMidiOutCaps=^TMidiOutCaps;
   TMidiOutCaps = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: MMVERSION;        { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of AnsiChar;  { product name (NULL terminated string) }
    wTechnology: Word;           { type of device }
    wVoices: Word;               { # of voices (internal synth only) }
    wNotes: Word;                { max # of notes (internal synth only) }
    wChannelMask: Word;          { channels used (internal synth only) }
    dwSupport: DWORD;            { functionality supported by driver }
    end;

   PMidiHdr = ^TMidiHdr;
   TMidiHdr = record
    lpData: PChar;               { pointer to locked data block }
    dwBufferLength: DWORD;       { length of data in data block }
    dwBytesRecorded: DWORD;      { used for input only }
    dwUser: DWORD;               { for client's use }
    dwFlags: DWORD;              { assorted flags (see defines) }
    lpNext: PMidiHdr;            { reserved for driver }
    reserved: DWORD;             { reserved for driver }
    dwOffset: DWORD;             { Callback offset into buffer }
    dwReserved: array[0..7] of DWORD; { Reserved for winmmEM }
   end;
    
    MCIERROR = DWORD;     { error return code, 0 means no error }
    MCIDEVICEID = UINT;   { MCI device ID type }
    PMCI_Generic_Parms=^TMCI_Generic_Parms;
    TMCI_Generic_Parms=record
      dwCallback:DWORD;
      end;
    PMCI_Open_ParmsA=^TMCI_Open_ParmsA;
    PMCI_Open_Parms=PMCI_Open_ParmsA;
    TMCI_Open_ParmsA=record
      dwCallback:DWORD;
      wDeviceID:MCIDEVICEID;
      lpstrDeviceType:PAnsiChar;
      lpstrElementName:PAnsiChar;
      lpstrAlias:PAnsiChar;
      end;
    TMCI_Open_Parms=TMCI_Open_ParmsA;
    PMCI_Play_Parms=^TMCI_Play_Parms;
    TMCI_Play_Parms=record
      dwCallback:DWORD;
      dwFrom:DWORD;
      dwTo:DWORD;
      end;
    PMCI_Set_Parms=^TMCI_Set_Parms;
    TMCI_Set_Parms=record
      dwCallback:DWORD;
      dwTimeFormat:DWORD;
      dwAudio:DWORD;
      end;
    PMCI_Status_Parms=^TMCI_Status_Parms;
    TMCI_Status_Parms=record
      dwCallback:DWORD;
      dwReturn:DWORD;
      dwItem:DWORD;
      dwTrack:DWORD;
      end;
    PMCI_Seek_Parms=^TMCI_Seek_Parms;
    TMCI_Seek_Parms=record
      dwCallback:DWORD;
      dwTo:DWORD;
      end;

//    VERSION = UINT;               { major (high byte), minor (low byte) }
    PWaveFormatEx = ^TWaveFormatEx;
    TWaveFormatEx = packed record
     wFormatTag: Word;         { format type }
     nChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
     nSamplesPerSec: DWORD;  { sample rate }
     nAvgBytesPerSec: DWORD; { for buffer estimation }
     nBlockAlign: Word;      { block size of data }
     wBitsPerSample: Word;   { number of bits per sample of mono data }
     cbSize: Word;           { the count in bytes of the size of }
     end;
    PWaveHdr = ^TWaveHdr;
    TWaveHdr = record
     lpData: PChar;              { pointer to locked data buffer }
     dwBufferLength: DWORD;      { length of data buffer }
     dwBytesRecorded: DWORD;     { used for input only }
     dwUser: DWORD;              { for client's use }
     dwFlags: DWORD;             { assorted flags (see defines) }
     dwLoops: DWORD;             { loop control counter }
     lpNext: PWaveHdr;           { reserved for driver }
     reserved: DWORD;            { reserved for driver }
     end;

{$endif}
//sound procs support - end ----------------------------------------------------




var
   //.started
   system_started                             :boolean=false;


   //---------------------------------------------------------------------------
   //Win32 dynamic load support ------------------------------------------------

   system_wininit                :boolean=false;
   system_wincore                :twincore;

   //---------------------------------------------------------------------------
   //---------------------------------------------------------------------------


   //.xbox controller support - 25jan2025 --------------------------------------
   system_xbox_init                           :boolean=false;
   system_xbox_deadzone                       :double=0.1;//0..1 => 0.1=10%
   system_xbox_retryref64                     :array[0..xssMax] of comp;
   system_xbox_statelist                      :array[-1..xssMax] of txboxcontrollerinfo;//friendly version => [-1] reserved for xbox__info() for returning a blank/uninitiated data structure
   system_xbox_setstatelist                   :array[0..xssMax] of txinputvibration;

   //.idle support
   system_xbox_idleref                        :array[0..xssMax] of longint;
   system_xbox_idletime                       :comp=0;

   //.keyboard support
   system_xbox_keyboard                       :txinputfromkeyboard;
   system_xbox_lastrawkey                     :longint=65;
   system_xbox_lastrawkeycount                :longint=0;
   system_xbox_lockkeyboard_count             :longint=0;

   //.mouse support
   system_xbox_mouse                          :txinputfromkeyboard;
   system_xbox_mouseref                       :string='';
   system_xbox_mousetimeref                   :comp=0;

   //.invert x-axis and y-axis and swap left/right joysticks and triggers
   system_xbox_suspend_all_inversions         :boolean=false;//disabled by default, to allow for proper menu navigation, but during game play it's enabled and movement is inverted as set by user - 26jul2025

   system_xbox_nativecontroller_inverty       :boolean=false;//slots 0..3
   system_xbox_nativecontroller_invertx       :boolean=false;
   system_xbox_nativecontroller_swapjoysticks :boolean=false;
   system_xbox_nativecontroller_swaptriggers  :boolean=false;
   system_xbox_nativecontroller_swapbumpers   :boolean=false;

   system_xbox_keyboard_inverty               :boolean=false;//slot 4
   system_xbox_keyboard_invertx               :boolean=false;

   system_xbox_mouse_inverty                  :boolean=false;//slot 5
   system_xbox_mouse_invertx                  :boolean=false;
   system_xbox_mouse_swapbuttons              :boolean=false;

   //.input labels => game specific labels for each controller button/movement, a "nil" label indicates the button/movement is not used by the game
   system_xbox_input_labels                    :array[0..xkey_max] of string;
   system_xbox_input_allowed                   :array[0..xkey_max] of boolean;


//############################################################################################################################################################
//##
//## Win32 API Calls ( Part I )
//##
//## The following Win32 api procs are included below for reference purposes only.  They can be used directly,
//## and statically linked in code, as they run on Windows 95/98.  But their definitions are primarily for automatic
//## code generation and conversion into dynamic loading versions of the same name, as well as providing the codebase
//## with realtime diagnostic and usage information.
//##
//## The proc prefixes "win____" and "net____" designate them as Win95/98 compatible
//##
//## Code automation performed by "win__make_gosswin2_pas()".  A special "default" variable list can be
//## specified, per proc, in the format "[[..a list of semi-colon separated name-value pairs..]]".  This provides the code
//## scanner with additional information, like a return value when the proc is unable to load, along with optional additional
//## information.
//##
//## [win32-api-scanner-start-point] - 30aug2025
//##
{$ifdef emergencyfallback}// - use when dynamic procs need maintanence or due to a failure (Win10+ only)
//##
//############################################################################################################################################################

const win____emergencyfallback_engaged=true;

function win____ChooseColor(var CC: TChooseColor): Bool; stdcall; external comdlg32  name 'ChooseColorA';
function win____GetSaveFileName(var OpenFile: TOpenFilename): Bool; stdcall; external comdlg32  name 'GetSaveFileNameA';
function win____GetOpenFileName(var OpenFile: TOpenFilename): Bool; stdcall; external comdlg32 name 'GetOpenFileNameA';
function win____RedrawWindow(hWnd: HWND; lprcUpdate: pwinrect; hrgnUpdate: HRGN; flags: UINT): BOOL; stdcall; external user32 name 'RedrawWindow';
function win____CreatePopupMenu:HMENU; stdcall; external user32 name 'CreatePopupMenu';
function win____AppendMenu(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: PChar): BOOL; stdcall; external user32 name 'AppendMenuA';
function win____GetSubMenu(hMenu: HMENU; nPos: Integer): HMENU; stdcall; external user32 name 'GetSubMenu';
function win____GetMenuItemID(hMenu: HMENU; nPos: Integer): UINT; stdcall; external user32 name 'GetMenuItemID';
function win____GetMenuItemCount(hMenu: HMENU): Integer; stdcall; external user32 name 'GetMenuItemCount';
function win____CheckMenuItem(hMenu: HMENU; uIDCheckItem, uCheck: UINT): DWORD; stdcall; external user32 name 'CheckMenuItem';
function win____EnableMenuItem(hMenu: HMENU; uIDEnableItem, uEnable: UINT): BOOL; stdcall; external user32 name 'EnableMenuItem';
function win____InsertMenuItem(p1: HMENU; p2: UINT; p3: BOOL; const p4: twinmenuiteminfo): BOOL; stdcall; external user32 name 'InsertMenuItemA';
function win____DestroyMenu(hMenu: HMENU): BOOL; stdcall; external user32 name 'DestroyMenu';
function win____TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x, y, nReserved: Integer; hWnd: HWND; prcRect: pwinrect): BOOL; stdcall; external user32 name 'TrackPopupMenu';

function win____GetFocus:HWND; stdcall; stdcall; external user32 name 'GetFocus';
function win____SetFocus(hWnd: HWND): HWND; stdcall; external user32 name 'SetFocus';
function win____GetParent(hWnd: HWND): HWND; stdcall; external user32 name 'GetParent';
function win____SetParent(hWndChild, hWndNewParent: HWND): HWND; stdcall; external user32 name 'SetParent';


function win____CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall; external kernel32 name 'CreateDirectoryA';
function win____GetFileAttributes(lpFileName: PChar): DWORD; stdcall; external kernel32 name 'GetFileAttributesA';
procedure win____GetLocalTime(var lpSystemTime: TSystemTime); stdcall; external kernel32 name 'GetLocalTime';
function win____SetLocalTime(const lpSystemTime: TSystemTime): BOOL; stdcall; external kernel32 name 'SetLocalTime';
function win____DeleteFile(lpFileName: PChar): BOOL; stdcall; external kernel32 name 'DeleteFileA';
function win____MoveFile(lpExistingFileName, lpNewFileName: PChar): BOOL; stdcall; external kernel32 name 'MoveFileA';
function win____SetFileAttributes(lpFileName: PChar; dwFileAttributes: DWORD): BOOL; stdcall; external kernel32 name 'SetFileAttributesA';
function win____GetBitmapBits(Bitmap: HBITMAP; Count: Longint; Bits: Pointer): Longint; stdcall; external gdi32 name 'GetBitmapBits';
function win____GetDIBits(DC: HDC; Bitmap: HBitmap; StartScan, NumScans: UINT; Bits: Pointer; var BitInfo: TBitmapInfoHeader; Usage: UINT): Integer; stdcall; external gdi32 name 'GetDIBits';
function win____IsClipboardFormatAvailable(format: UINT): BOOL; stdcall; external user32 name 'IsClipboardFormatAvailable';
function win____EmptyClipboard: BOOL; stdcall; external user32 name 'EmptyClipboard';
function win____OpenClipboard(hWndNewOwner: HWND): BOOL; stdcall; external user32 name 'OpenClipboard';
function win____CloseClipboard: BOOL; stdcall; external user32 name 'CloseClipboard';
function win____GdiFlush: BOOL; stdcall; external gdi32 name 'GdiFlush';
function win____CreateCompatibleDC(DC: HDC): HDC; stdcall; external gdi32 name 'CreateCompatibleDC';
function win____CreateDIBSection(DC: HDC; const p2: TBitmapInfoHeader; p3: UINT; var p4: Pointer; p5: THandle; p6: DWORD): HBITMAP; stdcall; external gdi32 name 'CreateDIBSection';
function win____CreateCompatibleBitmap(DC: HDC; Width, Height: Integer): HBITMAP; stdcall; external gdi32 name 'CreateCompatibleBitmap';
function win____CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; Bits: Pointer): HBITMAP; stdcall; external gdi32 name 'CreateBitmap';
function win____SetTextColor(DC: HDC; Color: COLORREF): COLORREF; stdcall; external gdi32 name 'SetTextColor';
function win____SetBkColor(DC: HDC; Color: COLORREF): COLORREF; stdcall; external gdi32 name 'SetBkColor';
function win____SetBkMode(DC: HDC; BkMode: Integer): Integer; stdcall; external gdi32 name 'SetBkMode';
function win____CreateBrushIndirect(const p1: TLogBrush): HBRUSH; stdcall; external gdi32 name 'CreateBrushIndirect';
function win____MulDiv(nNumber, nNumerator, nDenominator: Integer): Integer; stdcall; external kernel32 name 'MulDiv';
function win____GetSysColor(nIndex: Integer): DWORD; stdcall; external user32 name 'GetSysColor';
function win____ExtTextOut(DC: HDC; X, Y: Integer; Options: Longint; Rect: PwinRect; Str: PChar; Count: Longint; Dx: PInteger): BOOL; stdcall; external gdi32 name 'ExtTextOutA';
function win____GetDesktopWindow: HWND; stdcall; external user32 name 'GetDesktopWindow';

//function win____HeapCreate(flOptions, dwInitialSize, dwMaximumSize: DWORD): THandle; stdcall; external kernel32 name 'HeapCreate';
//function win____HeapDestroy(hHeap: THandle): BOOL; stdcall; external kernel32 name 'HeapDestroy';
//function win____HeapValidate(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL; stdcall; external kernel32 name 'HeapValidate';
//function win____HeapCompact(hHeap: THandle; dwFlags: DWORD): UINT; stdcall; external kernel32 name 'HeapCompact';

//recommended memory support by MS
function win____HeapAlloc(hHeap: THandle; dwFlags, dwBytes: DWORD): Pointer; stdcall; external kernel32 name 'HeapAlloc';
function win____HeapReAlloc(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD): Pointer; stdcall; external kernel32 name 'HeapReAlloc';
function win____HeapSize(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): DWORD; stdcall; external kernel32 name 'HeapSize';
function win____HeapFree(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL; stdcall; external kernel32 name 'HeapFree';

//legacy memory support - mainly for Clipboard functions etc
function win____GlobalHandle(Mem: Pointer): HGLOBAL; stdcall; external kernel32 name 'GlobalHandle';
function win____GlobalSize(hMem: HGLOBAL): DWORD; stdcall; external kernel32 name 'GlobalSize';
function win____GlobalFree(hMem: HGLOBAL): HGLOBAL; stdcall; external kernel32 name 'GlobalFree';
function win____GlobalUnlock(hMem: HGLOBAL): BOOL; stdcall; external kernel32 name 'GlobalUnlock';

function win____GetClipboardData(uFormat: UINT): THandle; stdcall; external user32 name 'GetClipboardData';
function win____SetClipboardData(uFormat: UINT; hMem: THandle): THandle; stdcall; external user32 name 'SetClipboardData';
function win____GlobalLock(hMem: HGLOBAL): Pointer; stdcall; external kernel32 name 'GlobalLock';
function win____GlobalAlloc(uFlags: UINT; dwBytes: DWORD): HGLOBAL; stdcall; external kernel32 name 'GlobalAlloc';
function win____GlobalReAlloc(hMem: HGLOBAL; dwBytes: DWORD; uFlags: UINT): HGLOBAL; stdcall; external kernel32 name 'GlobalReAlloc';
function win____LoadCursorFromFile(lpFileName: PAnsiChar): HCURSOR; stdcall; external user32 name 'LoadCursorFromFileA';

function win____GetDefaultPrinter(xbuffer:pointer;var xsize:longint):bool; stdcall; external winspl name 'GetDefaultPrinterA';
function win____GetVersionEx(var lpVersionInformation: TOSVersionInfo): BOOL; stdcall; external kernel32 name 'GetVersionExA';
function win____EnumPrinters(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL; stdcall; external winspl name 'EnumPrintersA';

function win____CreateIC(lpszDriver, lpszDevice, lpszOutput: PChar; lpdvmInit: PDeviceModeA): HDC; stdcall; external gdi32 name 'CreateICA';
function win____GetProfileString(lpAppName, lpKeyName, lpDefault: PChar; lpReturnedString: PChar; nSize: DWORD): DWORD; stdcall; external kernel32 name 'GetProfileStringA';
function win____GetDC(hWnd: HWND): HDC; stdcall; external user32 name 'GetDC';
function win____GetVersion: DWORD; stdcall; external kernel32 name 'GetVersion';
function win____EnumFonts(DC: HDC; lpszFace: PChar; fntenmprc: TFarProc; lpszData: PChar): Integer; stdcall; external gdi32 name 'EnumFontsA';
function win____EnumFontFamiliesEx(DC: HDC; var p2: TLogFont; p3: TFarProc; p4: LPARAM; p5: DWORD): BOOL; stdcall; external gdi32 name 'EnumFontFamiliesExA';
function win____GetStockObject(Index: Integer): HGDIOBJ; stdcall; external gdi32 name 'GetStockObject';
function win____GetCurrentThread: THandle; stdcall; external kernel32 name 'GetCurrentThread';
function win____GetCurrentThreadId: DWORD; stdcall; external kernel32 name 'GetCurrentThreadId';
//function win____SetWindowsHookExA(idHook: Integer; lpfn: TFNHookProc; hmod: HINST; dwThreadId: DWORD): HHOOK; stdcall; external user32 name 'SetWindowsHookExA';
//function win____UnhookWindowsHookEx(hhk: HHOOK): BOOL; stdcall; external user32 name 'UnhookWindowsHookEx';
//function win____CallNextHookEx(hhk: HHOOK; nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'CallNextHookEx';
function win____ClipCursor(lpRect: pwinrect): BOOL; stdcall; external user32 name 'ClipCursor';
function win____GetClipCursor(var lpRect: twinrect): BOOL; stdcall; external user32 name 'CloseClipboard';
function win____GetCapture: HWND; stdcall; external user32 name 'GetCapture';
function win____SetCapture(hWnd: HWND): HWND; stdcall; external user32 name 'SetCapture';
function win____ReleaseCapture: BOOL; stdcall; external user32 name 'ReleaseCapture';
function win____PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL; stdcall; external user32 name 'PostMessageA';
function win____SetClassLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint): DWORD; stdcall; external user32 name 'SetClassLongA';
function win____SetFocus(hWnd: HWND): HWND; stdcall; external user32 name 'SetFocus';
function win____GetActiveWindow: HWND; stdcall; external user32 name 'GetActiveWindow';
function win____GetFocus: HWND; stdcall; external user32 name 'GetFocus';
function win____ShowCursor(bShow: BOOL): Integer; stdcall; external user32 name 'ShowCursor';
function win____SetCursorPos(X, Y: Integer): BOOL; stdcall; external user32 name 'SetCursorPos';
function win____SetCursor(hCursor: HICON): HCURSOR; stdcall; external user32 name 'SetCursor';
function win____GetCursor: HCURSOR; stdcall; external user32 name 'GetCursor';
function win____GetCursorPos(var lpPoint: TPoint): BOOL; stdcall; external user32 name 'GetCursorPos';
function win____GetWindowText(hWnd: HWND; lpString: PChar; nMaxCount: Integer): Integer; stdcall; external user32 name 'GetWindowTextA';
function win____GetWindowTextLength(hWnd: HWND): Integer; stdcall; external user32 name 'GetWindowTextLengthA';
function win____SetWindowText(hWnd: HWND; lpString: PChar): BOOL; stdcall; external user32 name 'SetWindowTextA';
function win____GetModuleHandle(lpModuleName: PChar): HMODULE; stdcall; external kernel32 name 'GetModuleHandleA';
function win____GetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement): BOOL; stdcall; external user32 name 'GetWindowPlacement';
function win____SetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement): BOOL; stdcall; external user32 name 'SetWindowPlacement';
function win____GetTextExtentPoint(DC: HDC; Str: PChar; Count: Integer; var Size: tpoint): BOOL; stdcall; external gdi32 name 'GetTextExtentPointA';
function win____TextOut(DC: HDC; X, Y: Integer; Str: PChar; Count: Integer): BOOL; stdcall; external gdi32 name 'TextOutA';
function win____GetSysColorBrush(xindex:longint): HBRUSH; stdcall; external user32 name 'GetSysColorBrush';
function win____CreateSolidBrush(p1: COLORREF): HBRUSH; stdcall; external gdi32 name 'CreateSolidBrush';
function win____LoadIcon(hInstance: HINST; lpIconName: PChar): HICON; stdcall; external user32 name 'LoadIconA';
function win____LoadCursor(hInstance: HINST; lpCursorName: PAnsiChar): HCURSOR; stdcall; external user32 name 'LoadCursorA';
function win____FillRect(hDC: HDC; const lprc: twinrect; hbr: HBRUSH): Integer; stdcall; external user32 name 'FillRect';
function win____FrameRect(hDC: HDC; const lprc: twinrect; hbr: HBRUSH): Integer; stdcall; external user32 name 'FrameRect';
function win____InvalidateRect(hWnd: HWND; lpwinrect: pwinrect; bErase: BOOL): BOOL; stdcall; external user32 name 'InvalidateRect';
function win____StretchBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC; XSrc, YSrc, SrcWidth, SrcHeight: Integer; Rop: DWORD): BOOL; stdcall; external gdi32 name 'StretchBlt';
function win____GetClientwinrect(hWnd: HWND; var lpwinrect: twinrect): BOOL; stdcall; external user32 name 'GetClientwinrect';
function win____GetWindowRect(hWnd: HWND; var lpwinrect: twinrect): BOOL; stdcall; external user32 name 'GetWindowRect';
function win____GetClientRect(hWnd: HWND; var lpRect: twinrect): BOOL; stdcall; external user32 name 'GetClientRect';
function win____MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL; stdcall; external user32 name 'MoveWindow';
function win____SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL; stdcall; external user32 name 'SetWindowPos';
function win____DestroyWindow(hWnd: HWND): BOOL; stdcall; external user32 name 'DestroyWindow';
function win____ShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL; stdcall; external user32 name 'ShowWindow';
function win____RegisterClassExA(const WndClass: TWndClassExA): ATOM; stdcall; external user32 name 'RegisterClassExA';
function win____IsWindowVisible(hWnd: HWND): BOOL; stdcall; external user32 name 'IsWindowVisible';
function win____IsIconic(hWnd: HWND): BOOL; stdcall; external user32 name 'IsIconic';
function win____GetWindowDC(hWnd: HWND): HDC; stdcall; external user32 name 'GetWindowDC';
function win____ReleaseDC(hWnd: HWND; hDC: HDC): Integer; stdcall; external user32 name 'ReleaseDC';
function win____BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct): HDC; stdcall; external user32 name 'BeginPaint';
function win____EndPaint(hWnd: HWND; const lpPaint: TPaintStruct): BOOL; stdcall; external user32 name 'EndPaint';
function win____SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'SendMessageA';
function win____EnumDisplaySettingsA(lpszDeviceName: PAnsiChar; iModeNum: DWORD; var lpDevMode: TDeviceModeA): BOOL; stdcall; external user32 name 'EnumDisplaySettingsA';
function win____CreateDC(lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA): HDC; stdcall; external gdi32 name 'CreateDCA';
function win____DeleteDC(DC: HDC): BOOL; stdcall; external gdi32 name 'DeleteDC';
function win____GetDeviceCaps(DC: HDC; Index: Integer): Integer; stdcall; external gdi32 name 'GetDeviceCaps';
function win____GetSystemMetrics(nIndex: Integer): Integer; stdcall; external user32 name 'GetSystemMetrics';
function win____CreateRectRgn(p1, p2, p3, p4: Integer): HRGN; stdcall; external gdi32 name 'CreateRectRgn';
function win____CreateRoundRectRgn(p1, p2, p3, p4, p5, p6: Integer): HRGN; stdcall; external gdi32 name 'CreateRoundRectRgn';
function win____GetRgnBox(RGN: HRGN; var p2: twinrect): Integer; stdcall; external gdi32 name 'GetRgnBox';
function win____SetWindowRgn(hWnd: HWND; hRgn: HRGN; bRedraw: BOOL): BOOL; stdcall; external user32 name 'SetWindowRgn';
function win____PostThreadMessage(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL; stdcall; external user32 name 'PostThreadMessageA';
function win____SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint; stdcall; external user32 name 'SetWindowLongA';
function win____GetWindowLong(hWnd: HWND; nIndex: Integer): Longint; stdcall; external user32 name 'GetWindowLongA';
function win____CallWindowProc(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'CallWindowProcA';
function win____SystemParametersInfo(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT): BOOL; stdcall; external user32 name 'SystemParametersInfoA';
function win____RegisterClipboardFormat(lpszFormat: PChar): UINT; stdcall; external user32 name 'RegisterClipboardFormatA';
function win____CountClipboardFormats: Integer; stdcall; external user32 name 'CountClipboardFormats';
function win____ClientToScreen(hWnd: HWND; var lpPoint: tpoint): BOOL; stdcall; external user32 name 'ClientToScreen';
function win____ScreenToClient(hWnd: HWND; var lpPoint: tpoint): BOOL; stdcall; external user32 name 'ScreenToClient';
procedure win____DragAcceptFiles(Wnd: HWND; Accept: BOOL); stdcall; external shell32 name 'DragAcceptFiles';
function win____DragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT; stdcall; external shell32 name 'DragQueryFileA';
procedure win____DragFinish(Drop: HDROP); stdcall; external shell32 name 'DragFinish';
function win____SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc): UINT; stdcall; external user32 name 'SetTimer';
function win____KillTimer(hWnd: HWND; uIDEvent: UINT): BOOL; stdcall; external user32 name 'KillTimer';
function win____WaitMessage:bool; stdcall; external user32 name 'WaitMessage';
function win____GetProcessHeap: THandle; stdcall; external kernel32 name 'GetProcessHeap';
function win____SetPriorityClass(hProcess: THandle; dwPriorityClass: DWORD): BOOL; stdcall; external kernel32 name 'SetPriorityClass';
function win____GetPriorityClass(hProcess: THandle): DWORD; stdcall; external kernel32 name 'GetPriorityClass';
function win____SetThreadPriority(hThread: THandle; nPriority: Integer): BOOL; stdcall; external kernel32 name 'SetThreadPriority';
function win____SetThreadPriorityBoost(hThread: THandle; DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'SetThreadPriorityBoost';
function win____GetThreadPriority(hThread: THandle): Integer; stdcall; external kernel32 name 'GetThreadPriority';
function win____GetThreadPriorityBoost(hThread: THandle; var DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'GetThreadPriorityBoost';

function win____CoInitializeEx(pvReserved: Pointer; coInit: Longint): HResult; stdcall; external ole32 name 'CoInitializeEx';
function win____CoInitialize(pvReserved: Pointer): HResult; stdcall; external ole32 name 'CoInitialize';
procedure win____CoUninitialize; stdcall; external ole32 name 'CoUninitialize';

//function win____InterlockedIncrement(var Addend: Integer): Integer; stdcall; external kernel32 name 'InterlockedIncrement';
//function win____InterlockedDecrement(var Addend: Integer): Integer; stdcall; external kernel32 name 'InterlockedDecrement';
//function win____InterlockedExchange(var Target: Integer; Value: Integer): Integer; stdcall; external kernel32 name 'InterlockedExchange';

function win____CreateMutexA(lpMutexAttributes: PSecurityAttributes; bInitialOwner: BOOL; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'CreateMutexA';
function win____ReleaseMutex(hMutex: THandle): BOOL; stdcall; external kernel32 name 'ReleaseMutex';

function win____WaitForSingleObject(hHandle: THandle; dwMilliseconds: DWORD): DWORD; stdcall; external kernel32 name 'WaitForSingleObject';
function win____WaitForSingleObjectEx(hHandle: THandle; dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall; external kernel32 name 'WaitForSingleObjectEx';

function win____CreateEvent(lpEventAttributes: PSecurityAttributes; bManualReset, bInitialState: BOOL; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'CreateEventA';
function win____SetEvent(hEvent: THandle): BOOL; stdcall; external kernel32 name 'SetEvent';
function win____ResetEvent(hEvent: THandle): BOOL; stdcall; external kernel32 name 'ResetEvent';
function win____PulseEvent(hEvent: THandle): BOOL; stdcall; external kernel32 name 'PulseEvent';

//procedure win____InitializeCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall; external kernel32 name 'InitializeCriticalSection';
//procedure win____EnterCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall; external kernel32 name 'EnterCriticalSection';
//procedure win____LeaveCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall; external kernel32 name 'LeaveCriticalSection';
//Note: "win____TryEnterCriticalSection()" does not work on Win98 - 30aug2025
//function win____TryEnterCriticalSection(var lpCriticalSection: TRTLCriticalSection): BOOL; stdcall; external kernel32 name 'TryEnterCriticalSection';
//procedure win____DeleteCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall; external kernel32 name 'DeleteCriticalSection';

function win____InterlockedIncrement(var Addend: Integer): Integer; stdcall; external kernel32 name 'InterlockedIncrement';
function win____InterlockedDecrement(var Addend: Integer): Integer; stdcall; external kernel32 name 'InterlockedDecrement';

function win____GetFileVersionInfoSize(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD): DWORD; stdcall; external version name 'GetFileVersionInfoSizeA';
function win____GetFileVersionInfo(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL; stdcall; external version name 'GetFileVersionInfoA';
function win____VerQueryValue(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL; stdcall; external version name 'VerQueryValueA';

function win____GetCurrentProcessId: DWORD; stdcall; external kernel32 name 'GetCurrentProcessId';
procedure win____ExitProcess(uExitCode: UINT); stdcall; external kernel32 name 'ExitProcess';

function win____GetExitCodeProcess(hProcess: THandle; var lpExitCode: DWORD): BOOL; stdcall; external kernel32 name 'GetExitCodeProcess';
function win____CreateThread(lpThreadAttributes: Pointer; dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle; stdcall; external kernel32 name 'CreateThread';
function win____SuspendThread(hThread: THandle): DWORD; stdcall; external kernel32 name 'SuspendThread';
function win____ResumeThread(hThread: THandle): DWORD; stdcall; external kernel32 name 'ResumeThread';
function win____GetCurrentProcess: THandle; stdcall; external kernel32 name 'GetCurrentProcess';
function win____GetLastError: DWORD; stdcall; external kernel32 name 'GetLastError';
function win____GetStdHandle(nStdHandle: DWORD): THandle; stdcall; external kernel32 name 'GetStdHandle';
function win____SetStdHandle(nStdHandle: DWORD; hHandle: THandle): BOOL; stdcall; external kernel32 name 'SetStdHandle';
function win____GetConsoleScreenBufferInfo(hConsoleOutput: THandle; var lpConsoleScreenBufferInfo: TConsoleScreenBufferInfo): BOOL; stdcall; external kernel32 name 'GetConsoleScreenBufferInfo';
function win____FillConsoleOutputCharacter(hConsoleOutput: THandle; cCharacter: Char; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD): BOOL; stdcall; external kernel32 name 'FillConsoleOutputCharacterA';
function win____FillConsoleOutputAttribute(hConsoleOutput: THandle; wAttribute: Word; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfAttrsWritten: DWORD): BOOL; stdcall; external kernel32 name 'FillConsoleOutputAttribute';
function win____GetConsoleMode(hConsoleHandle: THandle; var lpMode: DWORD): BOOL; stdcall; external kernel32 name 'GetConsoleMode';
function win____SetConsoleCursorPosition(hConsoleOutput: THandle; dwCursorPosition: TCoord): BOOL; stdcall; external kernel32 name 'SetConsoleCursorPosition';
function win____SetConsoleTitle(lpConsoleTitle: PChar): BOOL; stdcall; external kernel32 name 'SetConsoleTitleA';
function win____SetConsoleCtrlHandler(HandlerRoutine: TFNHandlerRoutine; Add: BOOL): BOOL; stdcall; external kernel32 name 'SetConsoleCtrlHandler';
function win____GetNumberOfConsoleInputEvents(hConsoleInput: THandle; var lpNumberOfEvents: DWORD): BOOL; stdcall; external kernel32 name 'GetNumberOfConsoleInputEvents';
function win____ReadConsoleInput(hConsoleInput: THandle; var lpBuffer: TInputRecord; nLength: DWORD; var lpNumberOfEventsRead: DWORD): BOOL; stdcall; external kernel32 name 'ReadConsoleInputA';
function win____GetMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: UINT): BOOL; stdcall; external user32 name 'GetMessageA';
function win____PeekMessage(var lpMsg: tmsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall; external user32 name 'PeekMessageA';
function win____DispatchMessage(const lpMsg: tmsg): Longint; stdcall; external user32 name 'DispatchMessageA';
function win____TranslateMessage(const lpMsg: tmsg): BOOL; stdcall; external user32 name 'TranslateMessage';
function win____GetDriveType(lpRootPathName: PChar): UINT; stdcall; external kernel32 name 'GetDriveTypeA';
function win____SetErrorMode(uMode: UINT): UINT; stdcall; external kernel32 name 'SetErrorMode';
procedure win____ExitThread(dwExitCode: DWORD); stdcall; external kernel32 name 'ExitThread';
function win____TerminateThread(hThread: THandle; dwExitCode: DWORD): BOOL; stdcall; external kernel32 name 'TerminateThread';
function win____QueryPerformanceCounter(var lpPerformanceCount: comp): BOOL; stdcall; external kernel32 name 'QueryPerformanceCounter';
function win____QueryPerformanceFrequency(var lpFrequency: comp): BOOL; stdcall; external kernel32 name 'QueryPerformanceFrequency';

function win____GetVolumeInformation(lpRootPathName: PChar; lpVolumeNameBuffer: PChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD; var lpMaximumComponentLength, lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PChar; nFileSystemNameSize: DWORD): BOOL; stdcall; external kernel32 name 'GetVolumeInformationA';
function win____GetShortPathName(lpszLongPath: PChar; lpszShortPath: PChar; cchBuffer: DWORD): DWORD; stdcall; external kernel32 name 'GetShortPathNameA';

function win____SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer; var ppidl: PItemIDList): HResult; stdcall; external shell32 name 'SHGetSpecialFolderLocation';
function win____SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall; external shell32 name 'SHGetPathFromIDListA';
function win____GetWindowsDirectoryA(lpBuffer: PAnsiChar; uSize: UINT): UINT; stdcall; external kernel32 name 'GetWindowsDirectoryA';
function win____GetSystemDirectoryA(lpBuffer: PAnsiChar; uSize: UINT): UINT; stdcall; external kernel32 name 'GetSystemDirectoryA';
function win____GetTempPathA(nBufferLength: DWORD; lpBuffer: PAnsiChar): DWORD; stdcall; external kernel32 name 'GetTempPathA';
function win____FlushFileBuffers(hFile: THandle): BOOL; stdcall; external kernel32 name 'FlushFileBuffers';
function win____CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: Integer; lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD; hTemplateFile: THandle): THandle; stdcall; external kernel32 name 'CreateFileA';
function win____GetFileSize(hFile: THandle; lpFileSizeHigh: Pointer): DWORD; stdcall; external kernel32 name 'GetFileSize';
procedure win____GetSystemTime(var lpSystemTime: TSystemTime); stdcall; external kernel32 name 'GetSystemTime';
function win____CloseHandle(hObject: THandle): BOOL; stdcall; external kernel32 name 'CloseHandle';
function win____GetFileInformationByHandle(hFile: THandle; var lpFileInformation: TByHandleFileInformation): BOOL; stdcall; external kernel32 name 'GetFileInformationByHandle';
function win____SetFilePointer(hFile: THandle; lDistanceToMove: Longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall; external kernel32 name 'SetFilePointer';
function win____SetEndOfFile(hFile: THandle): BOOL; stdcall; external kernel32 name 'SetEndOfFile';
function win____WriteFile(hFile: THandle; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external kernel32 name 'WriteFile';
function win____ReadFile(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external kernel32 name 'ReadFile';
function win____GetLogicalDrives: DWORD; stdcall; external kernel32 name 'GetLogicalDrives';
function win____FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL; stdcall; external kernel32 name 'FileTimeToLocalFileTime';
function win____FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL; stdcall; external kernel32 name 'FileTimeToDosDateTime';
function win____DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'DefWindowProcA';
function win____RegisterClass(const lpWndClass: TWndClass): ATOM; stdcall; external user32 name 'RegisterClassA';
function win____RegisterClassA(const lpWndClass: TWndClassA): ATOM; stdcall; external user32 name 'RegisterClassA';

function win____CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar; lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall; external user32 name 'CreateWindowExA';
function win____EnableWindow(hWnd: HWND; bEnable: BOOL): BOOL; stdcall; external user32 name 'EnableWindow';
function win____IsWindowEnabled(hWnd: HWND): BOOL; stdcall; external user32 name 'IsWindowEnabled';
function win____UpdateWindow(hWnd: HWND): BOOL; stdcall; external user32 name 'UpdateWindow';

function win____ShellExecute(hWnd: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST; stdcall; external shell32 name 'ShellExecuteA';
function win____ShellExecuteEx(lpExecInfo: PShellExecuteInfo):BOOL; stdcall; external shell32 name 'ShellExecuteExA';

function win____SHGetMalloc(var ppMalloc: imalloc): HResult; stdcall; external shell32 name 'SHGetMalloc';
function win____CoCreateInstance(const clsid: TCLSID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TIID; out pv): HResult; stdcall; external ole32 name 'CoCreateInstance';
function win____GetObject(p1: HGDIOBJ; p2: Integer; p3: Pointer): Integer; stdcall; external gdi32 name 'GetObjectA';
function win____CreateFontIndirect(const p1: TLogFont): HFONT; stdcall; external gdi32 name 'CreateFontIndirectA';
function win____SelectObject(DC: HDC; p2: HGDIOBJ): HGDIOBJ; stdcall; external gdi32 name 'SelectObject';
function win____DeleteObject(p1: HGDIOBJ): BOOL; stdcall; external gdi32 name 'DeleteObject';
procedure win____sleep(dwMilliseconds: DWORD); stdcall; external kernel32 name 'Sleep';
function win____sleepex(dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall; external kernel32 name 'SleepEx';

//registry
function win____RegConnectRegistry(lpMachineName: PChar; hKey: HKEY; var phkResult: HKEY): Longint; stdcall; external advapi32 name 'RegConnectRegistryA';
function win___RegCreateKeyEx(hKey:HKEY;lpSubKey:PChar;Reserved:DWORD;lpClass:PChar;dwOptions:DWORD;samDesired:REGSAM;lpSecurityAttributes:PSecurityAttributes;var phkResult:HKEY;lpdwDisposition:PDWORD):Longint; stdcall; external advapi32 name 'RegCreateKeyExA';
function win____RegOpenKey(hKey: HKEY; lpSubKey: PChar; var phkResult: HKEY): Longint; stdcall; external advapi32 name 'RegOpenKeyA';
function win____RegCloseKey(hKey: HKEY): Longint; stdcall; external advapi32 name 'RegCloseKey';
function win____RegDeleteKey(hKey: HKEY; lpSubKey: PChar): Longint; stdcall; external advapi32 name 'RegDeleteKeyA';
function win____RegOpenKeyEx(hKey: HKEY; lpSubKey: PChar; ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY): Longint; stdcall; external advapi32 name 'RegOpenKeyExA';
function win____RegQueryValueEx(hKey: HKEY; lpValueName: PChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint; stdcall; external advapi32 name 'RegQueryValueExA';
function win____RegSetValueEx(hKey: HKEY; lpValueName: PChar; Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD): Longint; stdcall; external advapi32 name 'RegSetValueExA';

//support
function win____StartServiceCtrlDispatcher(var lpServiceStartTable: TServiceTableEntry): BOOL; stdcall; external advapi32 name 'StartServiceCtrlDispatcherA';
function win____RegisterServiceCtrlHandler(lpServiceName: PChar; lpHandlerProc: ThandlerFunction): SERVICE_STATUS_HANDLE; stdcall; external advapi32 name 'RegisterServiceCtrlHandlerA';
function win____SetServiceStatus(hServiceStatus: SERVICE_STATUS_HANDLE; var lpServiceStatus: TServiceStatus): BOOL; stdcall; external advapi32 name 'SetServiceStatus';
function win____OpenSCManager(lpMachineName, lpDatabaseName: PChar; dwDesiredAccess: DWORD): SC_HANDLE; stdcall; external advapi32 name 'OpenSCManagerA';
function win____CloseServiceHandle(hSCObject: SC_HANDLE): BOOL; stdcall; external advapi32 name 'CloseServiceHandle';
function win____CreateService(hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PChar; dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PChar; lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword: PChar): SC_HANDLE; stdcall; external advapi32 name 'CreateServiceA';
function win____OpenService(hSCManager: SC_HANDLE; lpServiceName: PChar; dwDesiredAccess: DWORD): SC_HANDLE; stdcall; external advapi32 name 'OpenServiceA';
function win____DeleteService(hService: SC_HANDLE): BOOL; stdcall; external advapi32 name 'DeleteService';

//winmm.dll
function win____timeGetTime: DWORD; stdcall; external mmsyst name 'timeGetTime';
function win____timeSetEvent(uDelay, uResolution: UINT;  lpFunction: TFNTimeCallBack; dwUser: DWORD; uFlags: UINT): UINT; stdcall; external mmsyst name 'timeSetEvent';
function win____timeKillEvent(uTimerID: UINT): UINT; stdcall; external mmsyst name 'timeKillEvent';
function win____timeBeginPeriod(uPeriod: UINT): MMRESULT; stdcall; external mmsyst name 'timeBeginPeriod';
function win____timeEndPeriod(uPeriod: UINT): MMRESULT; stdcall; external mmsyst name 'timeEndPeriod';

//winsocket.dll
//.session
function net____WSAStartup(wVersionRequired: word; var WSData: TWSAData): Integer;                               stdcall;external winsocket name 'WSAStartup';
function net____WSACleanup: Integer;                                                                             stdcall;external winsocket name 'WSACleanup';
function net____wsaasyncselect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer;                stdcall;external winsocket name 'WSAAsyncSelect';
function net____WSAGetLastError: Integer;                                                                        stdcall;external winsocket name 'WSAGetLastError';

//function net____WSAGetLastError: Integer;                                                                        stdcall;external winsocket name 'WSAGetLastError';
//function net____WSAAsyncGetHostByName(HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer): THandle;   stdcall;external winsocket name 'WSAAsyncGetHostByName';
//.sockets
function net____makesocket(af, struct, protocol: Integer): TSocket;                                              stdcall;external winsocket name 'socket';
function net____bind(s: TSocket; var addr: TSockAddr; namelen: Integer): Integer;                                stdcall;external winsocket name 'bind';
function net____listen(s: TSocket; backlog: Integer): Integer;                                                   stdcall;external winsocket name 'listen';
function net____closesocket(s: tsocket): integer;                                                                stdcall;external winsocket name 'closesocket';
function net____getsockopt(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer): Integer;    stdcall;external winsocket name 'getsockopt';
function net____accept(s: TSocket; addr: PSockAddr; addrlen: PInteger): TSocket;                                 stdcall;external winsocket name 'accept';
function net____recv(s: TSocket; var Buf; len, flags: Integer): Integer;                                         stdcall;external winsocket name 'recv';
function net____send(s: TSocket; var Buf; len, flags: Integer): Integer;                                         stdcall;external winsocket name 'send';
function net____getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;                     stdcall;external winsocket name 'getpeername';
function net____connect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer;                             stdcall;external winsocket name 'connect';
function net____ioctlsocket(s: TSocket; cmd: Longint; var arg: u_long): Integer;                                 stdcall;external winsocket name 'ioctlsocket';

//file
function win____FindFirstFile(lpFileName: PChar; var lpFindFileData: TWIN32FindData): THandle; stdcall; external kernel32 name 'FindFirstFileA';
function win____FindNextFile(hFindFile: THandle; var lpFindFileData: TWIN32FindData): BOOL; stdcall; external kernel32 name 'FindNextFileA';
function win____FindClose(hFindFile: THandle): BOOL; stdcall; external kernel32 name 'FindClose';
function win____RemoveDirectory(lpPathName: PChar): BOOL; stdcall; external kernel32 name 'RemoveDirectoryA';


//sound procs ------------------------------------------------------------------
{$ifdef snd}

//.wave - out
function win____waveOutGetDevCaps(uDeviceID: UINT; lpCaps: PWaveOutCaps; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveOutGetDevCapsA';
function win____waveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: UINT; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall; external mmsyst name 'waveOutOpen';
function win____waveOutClose(hWaveOut: HWAVEOUT): MMRESULT; stdcall; external mmsyst name 'waveOutClose';
function win____waveOutPrepareHeader(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveOutPrepareHeader';
function win____waveOutUnprepareHeader(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveOutUnprepareHeader';
function win____waveOutWrite(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveOutWrite';
//.wave - in
function win____waveInOpen(lphWaveIn: PHWAVEIN; uDeviceID: UINT; lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall; external mmsyst name 'waveInOpen';
function win____waveInClose(hWaveIn: HWAVEIN): MMRESULT; stdcall; external mmsyst name 'waveInClose';
function win____waveInPrepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveInPrepareHeader';
function win____waveInUnprepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveInUnprepareHeader';
function win____waveInAddBuffer(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveInAddBuffer';
function win____waveInStart(hWaveIn: HWAVEIN): MMRESULT; stdcall; external mmsyst name 'waveInStart';
function win____waveInStop(hWaveIn: HWAVEIN): MMRESULT; stdcall; external mmsyst name 'waveInStop';
function win____waveInReset(hWaveIn: HWAVEIN): MMRESULT; stdcall; external mmsyst name 'waveInReset';
//.midi
function win____midiOutGetNumDevs: UINT; stdcall; external mmsyst name 'midiOutGetNumDevs';

//Windows 98: Once the function "win____midiOutGetDevCaps()" returns FALSE stop calling it, else lockup can
//            occur when calling other subsequent functions, such as midiOutOpen() - 04sep2025
function win____midiOutGetDevCaps(uDeviceID: UINT; lpCaps: PMidiOutCaps; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutGetDevCapsA';

function win____midiOutOpen(lphMidiOut: PHMIDIOUT; uDeviceID: UINT; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutOpen';
function win____midiOutClose(hMidiOut: HMIDIOUT): MMRESULT; stdcall; external mmsyst name 'midiOutClose';
function win____midiOutReset(hMidiOut: HMIDIOUT): MMRESULT; stdcall; external mmsyst name 'midiOutReset';//for midi streams only? -> hence the "no effect" for volume reset between songs - 15apr2021

//was: function win____midiOutShortMsg(hMidiOut: HMIDIOUT; dwMsg: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutShortMsg';
function win____midiOutShortMsg(const hMidiOut: HMIDIOUT; const dwMsg: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutShortMsg';

//function midiOutPrepareHeader(hMidiOut: HMIDIOUT; lpMidiOutHdr: PMidiHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutPrepareHeader';
//function midiOutUnprepareHeader(hMidiOut: HMIDIOUT; lpMidiOutHdr: PMidiHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutUnprepareHeader';
//function midiOutLongMsg(hMidiOut: HMIDIOUT; lpMidiOutHdr: PMidiHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutLongMsg';

//.mci
function win____mciSendCommand(mciId:MCIDEVICEID;uMessage:UINT;dwParam1,dwParam2:DWORD):MCIERROR; stdcall; external winmm name 'mciSendCommandA';
function win____mciGetErrorString(mcierr: MCIERROR; pszText: PChar; uLength: UINT): BOOL; stdcall; external winmm name 'mciGetErrorStringA';

//.mixer - volumes
function win____waveOutGetVolume(hwo: longint; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'waveOutGetVolume';
function win____waveOutSetVolume(hwo: longint; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'waveOutSetVolume';
function win____midiOutGetVolume(hmo: longint; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'midiOutGetVolume';
function win____midiOutSetVolume(hmo: longint; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutSetVolume';
function win____auxSetVolume(uDeviceID: UINT; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'auxSetVolume';
function win____auxGetVolume(uDeviceID: UINT; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'auxGetVolume';

{$endif}
//sound procs - end ------------------------------------------------------------



//############################################################################################################################################################
//##
//## Win32 API Calls ( Part II )
//##
//## The following Win32 api procs are included below for reference purposes only.  They should not be used directly,
//## or statically linked in code.  Their definitions are provided primarily for automatic code generation into dynamic
//## loading versions of the same name.  This allows the codebase to function across all flavours of Microsoft Windows
//## without breaking, or preventing the app from starting.  In addition, each dynamic proc provides the codebase with
//## realtime diagnostic and usage information.
//##
//## The proc prefixes "win2____" and "net2____" designate a usage scope beyond Win95/98
//##
//## Code automation performed by "win__make_gosswin2_pas()".  A special "default" variable list can be
//## specified, per proc, in the format "[[..a list of semi-colon separated name-value pairs..]]".  This provides the code
//## scanner with additional information, like a return value when the proc is unable to load, along with optional additional
//## information.
//##
//############################################################################################################################################################

function win2____GetGuiResources(xhandle:thandle;flags:dword):dword; stdcall; external user32 name 'GetGuiResources';
function win2____SetProcessDpiAwarenessContext(inDPI_AWARENESS_CONTEXT:dword):lresult; stdcall; external user32 name 'SetProcessDpiAwarenessContext';
function win2____GetMonitorInfo(Monitor:hmonitor;lpMonitorInfo:pmonitorinfo):lresult; stdcall; external user32 name 'GetMonitorInfoA';
function win2____EnumDisplayMonitors(dc:hdc;lpcrect:pwinrect;userProc:PMonitorenumproc;dwData:lparam):lresult; stdcall; external user32 name 'EnumDisplayMonitors';
function win2____GetDpiForMonitor(monitor:hmonitor;dpiType:longint;var dpiX,dpiY:uint):lresult; stdcall; external Shcore name 'GetDpiForMonitor';//[[result:^^E_FAIL^^;]]
function win2____SetLayeredWindowAttributes(winHandle:hwnd;color:dword;bAplha:byte;dwFlags:dword):lresult; stdcall; external user32 name 'SetLayeredWindowAttributes';
function win2____XInputGetState(dwUserIndex03:dword;xinputstate:pxinputstate):tbasic_lresult; stdcall; external xinput1_4 name 'XInputGetState';//[[result:^^E_FAIL^^;]]
function win2____XInputSetState(dwUserIndex03:dword;xinputvibration:pxinputvibration):tbasic_lresult; stdcall; external xinput1_4 name 'XInputSetState';//[[result:^^E_FAIL^^;]]
function win2____GetFileVersionInfoSize(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD): DWORD; stdcall; external version name 'GetFileVersionInfoSizeA';
function win2____GetFileVersionInfo(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL; stdcall; external version name 'GetFileVersionInfoA';
function win2____VerQueryValue(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL; stdcall; external version name 'VerQueryValueA';



//############################################################################################################################################################
//##
//## END of automatic scan point AND emergency proc fallback support
//##
{$else}
const win____emergencyfallback_engaged=false;// - use when dynamic procs need maintanence or due to a failure (Win10+ only)
{$endif}
//##
//## [win32-api-scanner-stop-point] - 30aug2025
//##
//############################################################################################################################################################




//static Win32 procs
function win____LoadLibraryA(lpLibFileName: PAnsiChar): HMODULE; stdcall; external kernel32 name 'LoadLibraryA';
function win____GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall; external kernel32 name 'GetProcAddress';
function win____MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer; stdcall; external user32 name 'MessageBoxA';


//support procs
function net____send2(s:tsocket;var buf;len,flags:longint;var xsent:longint):boolean;
function win____CreateComObject(const ClassID: TGUID): IUnknown;
procedure win____OleError(ErrorCode: HResult);
procedure win____OleCheck(Result: HResult);
function win____TrimPunctuation(const S: string): string;

//file
function win__FindMatchingFile(var F: TSearchRec): Integer;
function win__FindFirst(const Path: string; Attr: longint; var F: TSearchRec): longint;
function win__FindNext(var F: TSearchRec): longint;//28jan2024
procedure win__FindClose(var F: TSearchRec);

//console
function low__console(n:string;var v1,v2:longint):boolean;
function low__consoleb(n:string;v1,v2:longint):boolean;
function low__consolekey(xstdin:thandle):char;
function low__stdin:thandle;
function low__stdout:thandle;
function low__handleok(x:thandle):boolean;
procedure low__handlenone(var x:thandle);


//registry procs ---------------------------------------------------------------
function reg__openkey(xrootkey:hkey;xuserkey:string;var xoutkey:hkey):boolean;
function reg__closekey(var xkey:hkey):boolean;
function reg__deletekey(xrootkey:hkey;xuserkey:string):boolean;
function reg__setstr(xkey:hkey;const xname,xvalue:string):boolean;
function reg__setstrx(xkey:hkey;xname,xvalue:string):boolean;
function reg__setint(xkey:hkey;xname:string;xvalue:longint):boolean;
function reg__readval(xrootstyle:longint;xname:string;xuseint:boolean):string;


//service procs ----------------------------------------------------------------
//.these procs enable the program to switch from console mode to service mode and handle service code requests
procedure service__start1;
procedure service__makecodehandler2;stdcall;
procedure service__coderesponder3(x:longint);stdcall;
procedure service__sendstatus4(xstate,xexitcode,xwaithint:dword);
//.install or uninstall this app as a service -> app must be installed as a service BEFORe procs (1-4) above will work
function service__install(var e:longint):boolean;
function service__install2(xname,xdisplayname,xfilename:string;var e:longint):boolean;
function service__uninstall(var e:longint):boolean;
function service__uninstall2(xname:string;var e:longint):boolean;


//root procs -------------------------------------------------------------------
function root__priority:boolean;//false=normal, true=fast
procedure root__setpriority(xfast:boolean);
function root__adminlevel:boolean;
function root__timeperiod:longint;
procedure root__settimeperiod(xms:longint);
procedure root__stoptimeperiod;
procedure root__throttleASdelay(xpert100:longint;var xloopcount:longint);


//dynamic proc suport ----------------------------------------------------------
procedure win__init;//should be called from app__boot

function win__makeproc(x:string;var xcore:twinscannerinfo;var e:string):boolean;
function win__makeprocs(const sf,df,dversionlabel:string):boolean;
procedure win__make_gosswin2_pas;

function win__errmsg(const e:longint):string;
function win__dllname(const xindex:longint):string;
function win__dllname2(const xindex:longint;xincludeext:boolean):string;
function win__finddllname(const xname:string;var xindex:longint):boolean;
procedure win__inc(const xslot:longint);
procedure win__dec;
procedure win__depthtrace(xlimit:longint);

function win__proccount:longint;
function win__proccalls:comp;
function win__procload:longint;
function win__dllload:longint;
function win__infocount:longint;
function win__infofind(xindex:longint;var v1,v2,v3,v4:string;var xtitle:boolean):boolean;
function win__procCallCount(const xslot:longint):comp;


function win__procname(const xslot:longint):string;
function win__slotinfo(const xslot:longint;var dname,rvalue:longint;var pname:string;var xmisc:string):boolean;

function win__ok(const xslot:longint):boolean;
function win__loaded(const xslot:longint):boolean;
function win__usebol(var xdefresult:bool;const xslot:longint;var xptr:pointer):boolean;////26sep2025
function win__usewrd(var xdefresult:word;const xslot:longint;var xptr:pointer):boolean;//26sep2025
function win__useint(var xdefresult:longint;const xslot:longint;var xptr:pointer):boolean;//26sep2025
function win__useptr(var xdefresult:pointer;const xslot:longint;var xptr:pointer):boolean;
function win__usehnd(var xdefresult:thandle;const xslot:longint;var xptr:pointer):boolean;
function win__use(const xslot:longint;var xptr:pointer):boolean;

procedure win__errbol(var xresult:bool;const xreturn:bool);
procedure win__errwrd(var xresult:word;const xreturn:word);
procedure win__errint(var xresult:longint;const xreturn:longint);
procedure win__errptr(var xresult:pointer;const xreturn:pointer);
procedure win__errhnd(var xresult:thandle;const xreturn:thandle);

//xxxxxxxxx engage error tracking in api calls


//system procs -----------------------------------------------------------------
procedure low__testlog(x:string);//for testing purposes -> write simple line by line log


//start-stop procs -------------------------------------------------------------
procedure gosswin__start;
procedure gosswin__stop;

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__win(xname:string):string;//information specific to this unit of code - 09apr2024


//xbox controller procs --------------------------------------------------------
procedure xbox__stop;//called internally on app shutdown
function xbox__init:boolean;//called automatically
function xbox__inited:boolean;
function xbox__info(xindex:longint):pxboxcontrollerinfo;
function xbox__state(xindex:longint):boolean;//xindex=0..3 = max of 4 controllers, return=true=connected and we might have new data, check "xbox__info[].newdata" - 22jul2025
function xbox__state2(xindex:longint;var x:txboxcontrollerinfo):boolean;//xindex=0..3 = max of 4 controllers
function xbox__setstate(xindex:longint):boolean;
function xbox__setstate2(xindex:longint;lmotorspeed,rmotorspeed:double):boolean;//0..1 for each left and right motors
function xbox__lastindex(xallslots:boolean):longint;//24jul2025
function xbox__native(xindex:longint):boolean;//0..3=native controllers, 4=virtual controller via keyboard input

//.adjust deadzone
function xbox__deadzone(x:double):double;
procedure xbox__setdeadzone(x:double);
procedure xbox__invertaxis(var nativex,nativey,keyboardx,keyboardy,mousex,mousey:boolean);//24jul2025
procedure xbox__setinvertaxis(nativex,nativey,keyboardx,keyboardy,mousex,mousey:boolean);
function xbox__invertaxislist:string;//24jul2025
procedure xbox__setinvertaxislist(x:string);

//.support
function xbox__usebool(var x:boolean):boolean;
function xbox__index(x:longint):longint;
function xbox__stateshow(xindex:longint):boolean;//for debugging
function xbox__autoclicked(xindex,xindex03:longint;xdown:boolean):boolean;
function xbox__roundtozero(x:double):double;

//.detect button clicks -> click remains until the proc is called -> allows for persistent clicks that are not time-sensitive -> click ready on the down stroke of the button
function xbox__aclick(xindex:longint):boolean;//A
function xbox__bclick(xindex:longint):boolean;//B
function xbox__xclick(xindex:longint):boolean;//X
function xbox__yclick(xindex:longint):boolean;//Y
function xbox__uclick(xindex:longint):boolean;//up
function xbox__dclick(xindex:longint):boolean;//down
function xbox__lclick(xindex:longint):boolean;//left
function xbox__rclick(xindex:longint):boolean;//right
function xbox__startclick(xindex:longint):boolean;
function xbox__backclick(xindex:longint):boolean;
function xbox__ltclick(xindex:longint):boolean;//left trigger
function xbox__rtclick(xindex:longint):boolean;//right trigger
function xbox__lbclick(xindex:longint):boolean;//left thumb stick (left stick)
function xbox__rbclick(xindex:longint):boolean;//right thumb stick (right stick)
function xbox__lsclick(xindex:longint):boolean;//left shoulder
function xbox__rsclick(xindex:longint):boolean;//right shoulder
//.extended keyboard support via slot #4
function xbox__enterClick(xindex:longint):boolean;
function xbox__escClick(xindex:longint):boolean;
function xbox__delClick(xindex:longint):boolean;
//.other
function xbox__showmenu(xindex:longint):boolean;

//.thumbsticks as clicks (x/y) coordinates
function xbox__lthumbstick_lclick(xindex:longint):boolean;//22jul2025
function xbox__lthumbstick_rclick(xindex:longint):boolean;
function xbox__lthumbstick_uclick(xindex:longint):boolean;
function xbox__lthumbstick_dclick(xindex:longint):boolean;

function xbox__rthumbstick_lclick(xindex:longint):boolean;//22jul2025
function xbox__rthumbstick_rclick(xindex:longint):boolean;
function xbox__rthumbstick_uclick(xindex:longint):boolean;
function xbox__rthumbstick_dclick(xindex:longint):boolean;

//.any click - 22jul2025
function xbox__lanyclick(xindex:longint):boolean;
function xbox__ranyclick(xindex:longint):boolean;
function xbox__uanyclick(xindex:longint):boolean;
function xbox__danyclick(xindex:longint):boolean;

//.any down - 22jul2025
function xbox__lanydown(xindex:longint):boolean;
function xbox__ranydown(xindex:longint):boolean;
function xbox__uanydown(xindex:longint):boolean;
function xbox__danydown(xindex:longint):boolean;

//.any auto click - 22jul2025
function xbox__lanyautoclick(xindex:longint):boolean;
function xbox__ranyautoclick(xindex:longint):boolean;
function xbox__uanyautoclick(xindex:longint):boolean;
function xbox__danyautoclick(xindex:longint):boolean;

//.reset clicks
function xbox__resetClicks:boolean;
procedure xbox__resetClicksAndWait;

//.input idle time in seconds (0..60)
function xbox__idletime:longint;


//.slot #4 - keyboard as a Xbox controller support
function xbox__rootlabel(xkey_code:longint):string;
function xbox__keyfilter(xindex:longint):longint;
function xbox__keylabel(xindex:longint):string;
function xbox__controllerfilter(xindex:longint):longint;
function xbox__controllerlabel(xindex:longint):string;

function xbox__keyboardkeylabel(xrawkey:longint):string;
function xbox__keymap(xindex:longint):longint;
function xbox__keymap2(xindex:longint;var xlabel:string;var xrawkey:longint):boolean;
procedure xbox__setkeymap(xindex,xnewkey:longint);
procedure xbox__keyrawinput(xrawkey:longint;xdown:boolean);//uses slot4
function xbox__keyslot_getstate(xinputstate:pxinputstate):boolean;
procedure xbox__keymap__defaults;
function xbox__lastrawkey:longint;
function xbox__lastrawkeycount(xreset:boolean):longint;
function xbox__keymappings:string;
procedure xbox__setkeymappings(const x:string);
procedure xbox__lockkeyboard;
procedure xbox__unlockkeyboard;
function xbox__keyboardlocked:boolean;

//.slot #5 - mouse as a Xbox controller support
procedure xbox__mouserawinput(sender:tobject;xmode,xbuttonstyle,dx,dy,dw,dh:longint);//uses slot #5
function xbox__mouseslot_getstate(xinputstate:pxinputstate):boolean;
procedure xbox__mouseslot_reset;
function xbox__mouselabel(xkey_code:longint):string;


//.game input label -> use range 0..xkey_max
function xbox__inputlabel(xindex:longint):string;
procedure xbox__setinputlabel(xindex:longint;const xlabel:string);


implementation

uses gosswin2, gossroot, gossio {$ifdef gui},gossgui{$endif};

//start-stop procs -------------------------------------------------------------
procedure gosswin__start;
type
   ttestalign=record
    a:byte;
    b:longint;
   end;
begin
try
//check
if system_started then exit else system_started:=true;

//aligned record fields check - 10aug2025
if (sizeof(ttestalign)<>8) then showerror('Warning:'+rcode+'Win32 (gosswin.pas) requires "{$align on}" or "Aligned record fields" compiler condition to be set for proper interaction with api calls, otherwise erratic data may result.');

except;end;
end;

procedure gosswin__stop;
begin
try
//check
if not system_started then exit else system_started:=false;

//xbox
xbox__stop;
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

function info__win(xname:string):string;//information specific to this unit of code - 09apr2024
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gosswin.*"
if (strcopy1(xname,1,8)='gosswin.') then strdel1(xname,1,8) else exit;

//get
if      (xname='ver')        then result:='4.00.1979'
else if (xname='date')       then result:='08oct2025'
else if (xname='name')       then result:='Win32'
else
   begin
   //nil
   end;

except;end;
end;

//system procs -----------------------------------------------------------------
procedure low__testlog(x:string);//for testing purposes -> write simple line by line log
var
   a:tstr9;
   e,df:string;
begin
try
//init
a:=nil;
df:='c:\temp\log.txt';

//get
if (x='') then io__remfile(df)
else
   begin
   a:=str__new9;
   str__sadd(@a,x+'<'+#10);
   io__tofileex64(df,@a,io__filesize64(df),false,e);
   end;
except;end;
try;str__free(@a);except;end;
end;


//Windows procs ----------------------------------------------------------------
function win____CreateWindow(lpClassName: PChar; lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: longint; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
begin
Result := win____CreateWindowEx(0, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
end;


//## exception #################################################################
constructor Exception.Create(const Msg: string);
begin
  FMessage := Msg;
end;

constructor Exception.CreateFmt(const Msg: string; const Args: array of const);
begin
//  FMessage := Format(Msg, Args);
FMessage:=Msg;
end;

constructor Exception.CreateRes(Ident: longint);
begin
FMessage:='Error ('+intstr32(ident)+')';
//FMessage := LoadStr(Ident);
end;

constructor Exception.CreateResFmt(Ident: Integer; const Args: array of const);
begin
//FMessage:= Format(LoadStr(Ident), Args);
FMessage:='Error ('+intstr32(ident)+')';
end;

constructor Exception.CreateHelp(const Msg: string; AHelpContext: Integer);
begin
FMessage:=Msg;
FHelpContext:=AHelpContext;
end;

constructor Exception.CreateFmtHelp(const Msg: string; const Args: array of const; AHelpContext: Integer);
begin
FMessage:=msg;//Format(Msg, Args);
FHelpContext:=AHelpContext;
end;

constructor Exception.CreateResHelp(Ident: Integer; AHelpContext: Integer);
begin
//FMessage := LoadStr(Ident);
FMessage:='Error ('+intstr32(ident)+')';
FHelpContext:=AHelpContext;
end;

constructor Exception.CreateResFmtHelp(Ident: Integer; const Args: array of const; AHelpContext: Integer);
begin
//FMessage := Format(LoadStr(Ident), Args);
FMessage:='Error ('+intstr32(ident)+')';
FHelpContext:=AHelpContext;
end;

{ Raise EOleSysError exception from an error code }
procedure win____OleError(ErrorCode: HResult);
begin
  raise win____EOleSysError.Create('', ErrorCode, 0);
end;

{ Raise EOleSysError exception if result code indicates an error }
procedure win____OleCheck(Result: HResult);
begin
  if Result < 0 then win____OleError(Result);
end;

function win____CreateComObject(const ClassID: TGUID): IUnknown;
begin
  win____OleCheck(win____CoCreateInstance(ClassID, nil, CLSCTX_INPROC_SERVER or
    CLSCTX_LOCAL_SERVER, IUnknown, Result));
end;

{ EOleSysError }

constructor win____EOleSysError.Create(const Message: string; ErrorCode, HelpContext: Integer);
var
   s:string;
begin
s:=message;
if (s='') then s:='System Error ('+intstr32(errorcode)+')';
inherited CreateHelp(S, HelpContext);
FErrorCode:=ErrorCode;
end;

{ EOleException }

constructor win____EOleException.Create(const Message: string; ErrorCode: Integer;
  const Source, HelpFile: string; HelpContext: Integer);
begin
  inherited Create(win____TrimPunctuation(Message), ErrorCode, HelpContext);
  FSource := Source;
  FHelpFile := HelpFile;
end;

function win____TrimPunctuation(const S: string): string;
var
  len:longint;
begin
  len := low__len(s);
  while (Len > 0) and (S[len-1+stroffset] in [#0..#32, '.']) do Dec(Len);
  Result := strcopy1(s,1,len);
end;



function win__FindMatchingFile(var F: TSearchRec): longint;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not win____FindNextFile(FindHandle, FindData) then
      begin
        Result := win____GetLastError;
        Exit;
      end;
    win____FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    win____FileTimeToDosDateTime(LocalFileTime, tint4(Time).Hi, tint4(Time).Lo);
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

function win__FindFirst(const Path: string; Attr: longint; var F: TSearchRec): longint;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := win____FindFirstFile(PChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := win__FindMatchingFile(F);
    if Result <> 0 then win__FindClose(F);
  end else
    Result := win____GetLastError;
end;

function win__FindNext(var F: TSearchRec): longint;//28jan2024
begin
if (f.FindHandle=0) then
   begin
   result:=1;//error
   exit;
   end;
if win____FindNextFile(F.FindHandle, F.FindData) then Result := win__FindMatchingFile(F) else Result := win____GetLastError;
end;

procedure win__FindClose(var F: TSearchRec);
begin
if (F.FindHandle <> INVALID_HANDLE_VALUE) then win____FindClose(F.FindHandle);
end;

//console procs ----------------------------------------------------------------
function low__consoleb(n:string;v1,v2:longint):boolean;
begin
result:=low__console(n,v1,v2);
end;

function low__console(n:string;var v1,v2:longint):boolean;
var
   stdout:THandle;
   csbi:TConsoleScreenBufferInfo;
   xsize,xsizewritten:dword;
   a:tcoord;

   function xstdoutOK:boolean;
   begin
   stdout:=win____GetStdHandle(STD_OUTPUT_HANDLE);
   result:=(stdout<>INVALID_HANDLE_VALUE);
   end;
begin
//defaults
result:=false;
try
//init
n:=strlow(n);
//get
if (n='cls') then
   begin
   if xstdoutOK and win____GetConsoleScreenBufferInfo(stdout,csbi) then
      begin
      xsize:=csbi.dwSize.x*csbi.dwSize.y;
      a.x:=0;
      a.y:=0;
      xsizewritten:=0;
      win____FillConsoleOutputCharacter(stdout,#32,xsize,a,xsizewritten);
      win____FillConsoleOutputAttribute(stdout,csbi.wAttributes,xsize,a,xsizewritten);
      win____SetConsoleCursorPosition(stdout,a);
      result:=true;
      end;
   end
else if (n='setcursorpos') then
   begin
   if xstdoutOK then
      begin
      a.x:=smallint(v1);
      a.y:=smallint(v2);
      win____SetConsoleCursorPosition(stdout,a);
      result:=true;
      end;
   end
else if (n='windowsize') then
     begin
     v1:=0;
     v2:=0;
     if xstdoutOK and win____GetConsoleScreenBufferInfo(stdout,csbi) then
        begin
        //get
        v1:=csbi.srWindow.right-csbi.srWindow.left+1;
        v2:=csbi.srWindow.bottom-csbi.srWindow.top+1;
        //.shrink width & height to allow for terminal window scrollbar (right) / minor padding (bottom)
        v1:=frcmin32(v1-1,0);
        v2:=frcmin32(v2-1,0);
        //successful
        result:=true;
        end;
     end;
except;end;
end;

function low__stdin:thandle;
begin
result:=invalid_handle_value;
try;if not app__guimode then result:=win____GetStdHandle(STD_INPUT_HANDLE);except;end;
end;

function low__stdout:thandle;
begin
result:=invalid_handle_value;
try;if not app__guimode then result:=win____GetStdHandle(STD_OUTPUT_HANDLE);except;end;
end;

function low__handleok(x:thandle):boolean;
begin
result:=(x<>invalid_handle_value);
end;

procedure low__handlenone(var x:thandle);
begin
try;x:=invalid_handle_value;except;end;
end;

function low__consolekey(xstdin:thandle):char;
var
   a:tinputrecord;
   acount:dword;
begin
result:=#0;
try;if (xstdin<>INVALID_HANDLE_VALUE) and win____ReadConsoleInput(xstdin,a,1,acount) and (acount>=1) and (a.EventType=1) and a.KeyEvent.bKeyDown then result:=a.KeyEvent.asciichar;except;end;
end;

function net____send2(s:tsocket;var buf;len,flags:longint;var xsent:longint):boolean;
begin
xsent:=net____send(s,buf,len,flags);
result:=(xsent>=1);
end;




//registry procs ---------------------------------------------------------------
function reg__openkey(xrootkey:hkey;xuserkey:string;var xoutkey:hkey):boolean;
begin
//defaults
result:=false;
xoutkey:=0;
try
//create key
result:=(0=win___RegCreateKeyEx(xrootkey,pchar(xuserkey),0,nil,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,nil,xoutkey,nil));
//open key
if not result then result:=(0=win____RegOpenKey(xrootkey,pchar(xuserkey),xoutkey));
except;end;
end;

function reg__closekey(var xkey:hkey):boolean;
begin
if (xkey=0) then result:=true
else
   begin
   result:=(0=win____RegCloseKey(xkey));
   if result then xkey:=0;
   end;
end;

function reg__deletekey(xrootkey:hkey;xuserkey:string):boolean;
begin
result:=(0=win____RegDeleteKey(xrootkey,pchar(xuserkey)));
end;

function reg__setstr(xkey:hkey;const xname,xvalue:string):boolean;
begin
result:=(0=win____RegSetValueEx(xkey,pchar(xname),0,reg_sz,pchar(xvalue),1+low__len(xvalue)));
end;

function reg__setstrx(xkey:hkey;xname,xvalue:string):boolean;
begin
result:=(0=win____RegSetValueEx(xkey,pchar(xname),0,reg_expand_sz,pchar(xvalue),1+low__len(xvalue)));
end;

function reg__setint(xkey:hkey;xname:string;xvalue:longint):boolean;
begin
result:=(0=win____RegSetValueEx(xkey,pchar(xname),0,reg_dword,@xvalue,sizeof(xvalue)));
end;

function reg__readval(xrootstyle:longint;xname:string;xuseint:boolean):string;
label//xrootstyle: 0=current user, 1=current machine
   skipend;
//  HKEY_CLASSES_ROOT     = $80000000;
//  HKEY_CURRENT_USER     = $80000001;
//  HKEY_LOCAL_MACHINE    = $80000002;
//  HKEY_USERS            = $80000003;
//  HKEY_PERFORMANCE_DATA = $80000004;
//  HKEY_CURRENT_CONFIG   = $80000005;
//  HKEY_DYN_DATA         = $80000006;
var
   k:hkey;
   xbuf:array[0..255] of char;
   xbuflen:cardinal;
   xlen,p:longint;
   xvalname:string;
   v:tint4;
begin
try
//defaults
result:='';
//init
xvalname:='';
xlen:=low__len(xname);
if (xlen<=0) then goto skipend;
//split
for p:=xlen downto 1 do
begin
if (xname[p-1+stroffset]='\') then
   begin
   xvalname:=strcopy1(xname,p+1,xlen);
   xname:=strcopy1(xname,1,p-1);
   break;
   end;
end;//p
//.enforcing trailing slash for xname - 28may2022
if (strcopy1(xname,length(xname),1)<>'\') then xname:=xname+'\';
//get
xbuflen:=sizeof(xbuf);
case xrootstyle of
0:if (win____regopenkeyex(HKEY_CURRENT_USER,pchar(xname),0,KEY_READ,k)<>ERROR_SUCCESS) then goto skipend;
1:if (win____regopenkeyex(HKEY_LOCAL_MACHINE,pchar(xname),0,KEY_READ,k)<>ERROR_SUCCESS) then goto skipend;
else goto skipend;
end;
//set
try
fillchar(xbuf,sizeof(xbuf),0);
if (win____regqueryvalueex(k,pchar(xvalname),nil,nil,@xbuf,@xbuflen)=ERROR_SUCCESS) then
   begin
   if xuseint then
      begin
      v.bytes[0]:=ord(xbuf[0]);
      v.bytes[1]:=ord(xbuf[1]);
      v.bytes[2]:=ord(xbuf[2]);
      v.bytes[3]:=ord(xbuf[3]);
      result:=intstr32(v.val);
      end
   else result:=string(xbuf);
   end;
except;end;
//close
win____regclosekey(k);
skipend:
except;end;
end;


//service procs ----------------------------------------------------------------
procedure service__start1;//stage 1: setup app to function as a service
begin
try
system_servicetable[0].lpServiceName:=pchar(app__info('service.name'));
system_servicetable[0].lpServiceProc:=@service__makecodehandler2;
system_servicetable[1].lpServiceName:=nil;
system_servicetable[1].lpServiceProc:=nil;
win____StartServiceCtrlDispatcher(system_servicetable[0]);
except;end;
end;

procedure service__makecodehandler2;stdcall;//stage 2: activate the service handler proc -> if this fails then we're not running as a service but as a console app
begin
try
system_servicestatus.dwServiceType              :=16;//SERVICE_WIN32_OWN_PROCESS;
system_servicestatus.dwCurrentState             :=SERVICE_START_PENDING;
system_servicestatus.dwControlsAccepted         :=SERVICE_ACCEPT_STOP or SERVICE_ACCEPT_PAUSE_CONTINUE;
system_servicestatus.dwServiceSpecificExitCode  :=0;
system_servicestatus.dwWin32ExitCode            :=0;
system_servicestatus.dwCheckPoint               :=0;
system_servicestatus.dwWaitHint                 :=0;
system_servicestatush:=win____RegisterServiceCtrlHandler(pchar(app__info('service.name')),@service__coderesponder3);

if (system_servicestatush<>0) then
   begin
   service__sendstatus4(SERVICE_RUNNING, NO_ERROR, 0);
   system_runstyle:=rsService;
   app__run;
   end
else
   begin
   service__sendstatus4(SERVICE_STOPPED, NO_ERROR, 0);
   end;
except;end;
end;

procedure service__coderesponder3(x:longint);stdcall;//stage 3: handle any service code requests
begin
case x of
SERVICE_CONTROL_STOP:begin
   service__sendstatus4(service_stopped,no_error,0);
   app__halt;
   end;
SERVICE_CONTROL_PAUSE:begin
   app__pause(true);
   service__sendstatus4(service_paused,no_error,0);
   end;
SERVICE_CONTROL_CONTINUE:begin
   app__pause(false);
   service__sendstatus4(service_running,no_error,0);
   end;
SERVICE_CONTROL_INTERROGATE:service__sendstatus4(system_servicestatus.dwCurrentState,no_error,0);
SERVICE_CONTROL_SHUTDOWN:app__halt;
end;//case
end;

procedure service__sendstatus4(xstate,xexitcode,xwaithint:dword);//part 4: send status codes back to Windows
begin
try
//init
system_servicestatus.dwCurrentState :=xstate;
system_servicestatus.dwWin32ExitCode:=xexitcode;
system_servicestatus.dwWaitHint     :=xwaithint;

//get
case (xstate=SERVICE_START_PENDING) of
true:system_servicestatus.dwControlsAccepted:=0;
else system_servicestatus.dwControlsAccepted:=SERVICE_ACCEPT_STOP;
end;

case (xstate=SERVICE_RUNNING) or (xstate=SERVICE_STOPPED) of
true:system_servicestatus.dwCheckPoint:=0;
else system_servicestatus.dwCheckPoint:=1;
end;

win____SetServiceStatus(system_servicestatush,system_servicestatus);
except;end;
end;

function service__install(var e:longint):boolean;
begin
result:=service__install2('','','',e);
end;

function service__install2(xname,xdisplayname,xfilename:string;var e:longint):boolean;
var
   h,h2:SC_HANDLE;
   dkey:hkey;
begin
//defaults
result:=false;
h:=0;
h2:=0;
e:=0;

try
//range
xname:=strcopy1(strdefb(xname,app__info('service.name')),1,256);
xdisplayname:=strcopy1(strdefb(xdisplayname,app__info('service.displayname')),1,256);
xfilename:=strdefb(xfilename,io__exename);

//get
h:=win____OpenSCManager(nil,nil,SC_MANAGER_ALL_ACCESS);
if (h<>0) then
   begin
   h2:=win____CreateService(h,pchar(xname),pchar(xdisplayname),SC_MANAGER_ALL_ACCESS,16,2,0,pchar('"'+xfilename+'"'),nil,nil,nil,nil,nil);
   case (h2<>0) of
   true:result:=true;
   else begin
      e:=win____getlasterror;
      case e of
      1073:result:=true;//service already exists
      end;//case
      end;
   end;//case
   end;

//description
if result and reg__openkey(hkey_local_machine,'SYSTEM\CurrentControlSet\Services\'+app__info('service.name')+'\',dkey) then
   begin
   reg__setstr(dkey,'Description',strdefb(app__info('service.description'),app__info('service.displayname')));
   reg__closekey(dkey);
   end;

except;end;
try
win____CloseServiceHandle(h2);
win____CloseServiceHandle(h);
except;end;
end;

function service__uninstall(var e:longint):boolean;
begin
result:=service__uninstall2('',e);
end;

function service__uninstall2(xname:string;var e:longint):boolean;
var
   h,h2:SC_HANDLE;
begin
//defaults
result:=false;
h:=0;
h2:=0;
e:=0;

try
//range
xname:=strcopy1(strdefb(xname,app__info('service.name')),1,256);

//get
h:=win____OpenSCManager(nil,nil,SC_MANAGER_ALL_ACCESS);
if (h<>0) then
   begin
   h2:=win____OpenService(h,pchar(xname),SC_MANAGER_ALL_ACCESS);
   result:=(h2<>0) and win____DeleteService(h2);
   if not result then
      begin
      e:=win____getlasterror;
      case e of
      1060:result:=true;//The specified service does not exist
      1072:result:=true;//The specified service has been marked for deletion.
      end;//case
      end;
   end;
except;end;
try
win____CloseServiceHandle(h2);
win____CloseServiceHandle(h);
except;end;
end;

function root__priority:boolean;//false=normal, true=fast
begin
result:=(REALTIME_PRIORITY_CLASS=win____getpriorityclass(win____getcurrentprocess));
end;

procedure root__setpriority(xfast:boolean);
begin
try;win____setpriorityclass(win____getcurrentprocess,low__aorb(NORMAL_PRIORITY_CLASS,REALTIME_PRIORITY_CLASS,xfast));except;end;
end;

function root__adminlevel:boolean;
var
   h:SC_HANDLE;
begin
case system_adminlevel of
1:result:=false;
2:result:=true;
else
   begin
   h:=win____OpenSCManager(nil,nil,SC_MANAGER_ALL_ACCESS);
   if (h<>0) then
      begin
      result:=true;
      system_adminlevel:=2;
      win____CloseServiceHandle(h);
      end
   else
      begin
      result:=false;
      system_adminlevel:=1;
      end;
   end;//begin
end;//case
end;

function root__timeperiod:longint;
begin
result:=system_timeperiod;
end;

procedure root__settimeperiod(xms:longint);
begin
//range
if (xms<1) then xms:=1 else if (xms>1000) then xms:=1000;
//remove previous
if (system_timeperiod>=1) then win____timeEndPeriod(system_timeperiod);
//set new
system_timeperiod:=xms;
win____timeBeginPeriod(xms);
end;

procedure root__stoptimeperiod;
begin
try
if (system_timeperiod>=1) then
   begin
   win____timeEndPeriod(system_timeperiod);
   system_timeperiod:=0;
   end;
except;end;
end;

procedure root__throttleASdelay(xpert100:longint;var xloopcount:longint);
var//note: xpert100=0..100 where 0=slow and 100=fast
   xms:longint;
begin
//defaults
xloopcount:=1;

//range
if (xpert100<0) then xpert100:=0 else if (xpert100>100) then xpert100:=100;

//delay
xms:=round(30-(xpert100/3.33));
if (xms<1) then xms:=1;

//thread timing resolution
case (xpert100<=10) of
true:root__stoptimeperiod;//normal mode
else if (system_timeperiod>1) or (system_timeperiod=0) then root__settimeperiod(1);//fast
end;

//wait
app__waitms(xms);

//loop count -> used to execute host code a number of times
xloopcount:=round(xpert100*xpert100*0.01);//1..100 loop count -> exponential increase
if (xloopcount<1) then xloopcount:=1;
end;


//dynamic procs support --------------------------------------------------------
//wina procs -------------------------------------------------------------------

function win__makeproc(x:string;var xcore:twinscannerinfo;var e:string):boolean;
label
   skipend;
var
   lnameindex,xlen,pc,lp,p2,p:longint;
   xfunc:boolean;
   xprocline,xorgprocname,str1,str2,xvarlist,xvarlistBARE,xreturntype,dname,lname,pname,vname:string;
   xdefvalsline,xloadType,xfuncbody,xfuncbodyBARE,xfuncbody2,n,v,etmp:string;
   xdefvals:tfastvars;
   vc:char;
   xhasdefault,xcolon,bol1,bol2:boolean;

   function c(xindex:longint):char;
   begin

   if (xindex>=1) and (xindex<=xlen) then result:=x[xindex-1+stroffset] else result:=#32;

   end;

   function emsg(const xmsg:string):boolean;
   begin

   result:=true;
   if (e='') then e:=xmsg+rcode+rcode+'-- For Proc --'+rcode+x;

   end;

   function xpad0(const x:string):string;
   const
      xline='                                          ';
   begin
   result:=x+strcopy1(xline,1,low__len(xline)-low__len(x));
   end;

   function xpad1(const x:string):string;
   const
      xline='                                                      ';
   begin
   result:=x+strcopy1(xline,1,low__len(xline)-low__len(x));
   end;

   function xpad2(const x:string):string;
   const
      xline='               ';
   begin
   result:=x+strcopy1(xline,1,low__len(xline)-low__len(x));
   end;

   function xpad3(const x:string):string;
   const
      xline='              ';
   begin
   result:=x+strcopy1(xline,1,low__len(xline)-low__len(x));
   end;

   function xpad4(const x:string):string;
   const
      xline='                                   ';
   begin
   result:=x+strcopy1(xline,1,low__len(xline)-low__len(x));
   end;

   function rh(const x:string):boolean;
   begin
   result:=strmatch(x,xreturntype);
   if result then xloadType:='hnd';//thandle
   end;

   function rp(const x:string):boolean;
   begin
   result:=strmatch(x,xreturntype);
   if result then xloadType:='ptr';//longint
   end;

   function ri(const x:string):boolean;
   begin
   result:=strmatch(x,xreturntype);
   if result then xloadType:='int';//longint
   end;

   function rw(const x:string):boolean;
   begin
   result:=strmatch(x,xreturntype);
   if result then xloadType:='wrd';//word
   end;

   function rb(const x:string):boolean;
   begin
   result:=strmatch(x,xreturntype);
   if result then xloadType:='bol';//bool
   end;

   function rskip(const x:string):boolean;
   begin
   result:=strmatch(x,xreturntype);
   end;

   //---------------------------------------------------------------------------
   function xsysvals(var x,e:string):boolean;
   label
      redo;
   const
      xsyschar   ='^';
      xsyschar2  =xsyschar+xsyschar;
   var
      xrescanlimit,p2,p,xlen:longint;
      xvaldone,bol1:boolean;
      n:string;

      function emsg(const x:string):boolean;
      begin

      result:=true;
      if (e='') then e:=x;

      end;

      function m(const xname,xvarval:string):boolean;
      begin

      //check
      if xvaldone then
         begin

         result:=true;
         exit;

         end;

      //get
      result:=strmatch(n,xname);

      if result then
         begin

         x        :=strcopy1(x,1,p-1)+xvarval+strcopy1(x,p2+2,xlen);
         xlen     :=low__len(x);
         xvaldone :=true;

         end;

      end;

      function mi(const xname:string;xvarval:longint):boolean;
      begin

      result:=xvaldone or m(xname,intstr32(xvarval));

      end;

   begin

   //defaults
   result            :=false;
   e                 :='';
   xrescanlimit      :=100;

   //init
   xlen   :=low__len(x);
   if (xlen<1) then
      begin

      result:=true;
      exit;

      end;

   //scan
   redo:
   if (xlen>=1) then for p:=1 to xlen do if (x[p-1+stroffset]=xsyschar) and (strcopy1(x,p,2)=xsyschar2) then
      begin

      //init
      xvaldone  :=false;
      bol1      :=false;
      n         :='';

      //get
      for p2:=(p+2) to xlen do if (x[p2-1+stroffset]=xsyschar) and (strcopy1(x,p2,2)=xsyschar2) then
         begin

         n    :=strlow( strcopy1( x, p+2, p2-p-2 ) );
         bol1 :=true;
         break;

         end;

      //error
      if (not bol1) and emsg('A system value in the format "'+xsyschar2+'<value name>'+xsyschar2+'" was started but not finished') then exit;

      //check
      if (n='') and emsg('Invalid system value name "nil"')                                                  then exit;



      //replace sys.val label with actual value
      mi('s_false',s_false);
      mi('e_fail',$80004005);//03sep2025



      //check
      if (not xvaldone) and emsg('System value name "'+n+'" not found')                                      then exit;


      //rescan from the beginning
      dec(xrescanlimit);
      if (xrescanlimit<=0) and emsg('Rescan limit for system value exceeded - error in code')                then exit;

      //loop
      goto redo;

      end;//p

   //successful
   result:=true;

   end;

   //read defaults
   function xreadDefaultVars(x:string;var e:string):boolean;
   label
      skipend;
   var
      xlen,xpos:longint;
      xline:string;
      dtext:tstr8;
   begin

   //defaults
   result :=false;
   e      :='';
   dtext  :=nil;

   try
   //filter
   x:=stripwhitespace_lt(x);
   if (x='') then exit;

   //init
   xlen  :=low__len(x);
   xpos  :=0;
   dtext :=small__new8;

   //.make lines
   swapchars(x,';',#10);

   //read lines and REPLACE system variable references with their actual values
   while low__nextline1(x,xline,xlen,xpos) do
   begin

   case xsysvals(xline,e) of
   true:dtext.sadd(xline+rcode);
   else goto skipend;
   end;

   end;//loop

   //get
   xdefvals.text:=dtext.text;

   //check
   if (xdefvals.s['result']='') and emsg('Default var "result" has no value')                   then goto skipend;
   if (intstr32(strint32(xdefvals.s['result'])) <> xdefvals.s['result']) and emsg('Numerical value for default var "result" is corrupt') then goto skipend;

   if (xdefvals.count<=0)       and emsg('Default vars specified but no variables were found')  then goto skipend;

   //succesful
   result:=(xdefvals.count>=1);
   skipend:

   except;end;

   //free
   small__free8(@dtext);

   end;

   function xdefvalsononeline(var xline:string):boolean;
   label
      skipend;
   var
      p:longint;
      a:tstr8;

      function xhaschar(const x:string;v:char):boolean;
      var
         p:longint;
      begin

      //defaults
      result:=false;

      //get
      if (x<>'') then for p:=1 to low__len(x) do if (v=x[p-1+stroffset]) then
         begin

         result:=true;
         break;

         end;//p

      end;

   begin

   //defaults
   result :=false;
   xline  :='';
   a      :=nil;

   try

   //check
   if (xdefvals.count<=0) then
      begin

      result:=true;
      exit;

      end;

   //init
   a:=small__new8;

   //get
   for p:=0 to (xdefvals.count-1) do if not strmatch(xdefvals.n[p],'result') then //exclude return "result" - 30aug2025
   begin

   if xhaschar(xdefvals.n[p],';') and emsg('Default var has a ";" in its name') then goto skipend;
   if xhaschar(xdefvals.n[p],':') and emsg('Default var has a ":" in its name') then goto skipend;

   if xhaschar(xdefvals.v[p],';') and emsg('Default var has a ";" in its value') then goto skipend;
   if xhaschar(xdefvals.v[p],':') and emsg('Default var has a ":" in its value') then goto skipend;

   a.sadd( insstr(#32,a.count>=1) + xdefvals.n[p]+':'+xdefvals.v[p]+';' );

   end;//p

   //set
   xline:=a.text;

   //successful
   result:=true;
   skipend:

   except;end;

   //free
   small__free8(@a);

   end;

begin

//defaults
result          :=false;
//xprocline       :='';
//xout            :='';
//xoutlisting     :='';
e               :='';
//xnamelen        :=0;
//xhasdefault     :=false;
xorgprocname    :='';
xdefvals        :=nil;

//check core vars
if (xcore.lhistory=nil) or (xcore.lprocvars=nil) or (xcore.lprocline=nil) or
   (xcore.lprocbody=nil) or (xcore.lprocinfo=nil) or (xcore.dunit=nil) or
   (xcore.lproctype=nil) then exit;

try

//filter
x:=stripwhitespace_lt(x);
if (x='') then
   begin

   result:=true;
   exit;

   end;

//check -> ignore -> line is a comment
if (strcopy1(x,1,2)='//') then
   begin

   result:=true;
   exit;

   end;


//------------------------------------------------------------------------------
//init
x            :=x+';';//force terminator char
xlen         :=low__len(x);
pc           :=0;
xhasdefault  :=false;
xfunc        :=false;
xvarlist     :='';
xvarlistBARE :='';
xreturntype  :='';
xloadType    :='';
dname        :='';
lname        :='';
lnameindex   :=dnone;
xdefvals     :=tfastvars.create;//used for the default return value when proc is not available, agmonst other things

//------------------------------------------------------------------------------
//proc type
lp    :=1;
bol1  :=false;

for p:=1 to xlen do if (c(p)=#32) then
   begin

   str1:=stripwhitespace_lt(strcopy1(x,lp,p-lp));

   if strmatch(str1,'function')  then
      begin

      xfunc :=true;
      bol1  :=true;

      end
   else if strmatch(str1,'procedure') then
      begin

      xfunc :=false;
      bol1  :=true;

      end;

   break;

   end;//p

//.skip
if not bol1 then
   begin

   result:=true;
   goto skipend;

   end;


//------------------------------------------------------------------------------
//is it external -> only process external procs
bol1:=false;

for p:=xlen downto 1 do
begin

if      ( c(p)=')' ) then break
else if ( (c(p)='e') or (c(p)='E') ) and ( strmatch( strcopy1(x,p-1,10),' external ' ) or strmatch( strcopy1(x,p-1,10),';external ' ) ) then
   begin

   bol1:=true;
   break;

   end;

end;//p

if not bol1 then
   begin

   result:=true;
   goto skipend;

   end;


//------------------------------------------------------------------------------
//org.procname
lp:=1;

for p:=1 to xlen do
begin

if      (c(p)=#32) then lp:=p+1
else if (c(p)='(') or (c(p)=':') or (c(p)=';') then
   begin

   xorgprocname:=strcopy1(x,lp,p-lp);
   break;

   end;

end;//p

if (xorgprocname='') and emsg('Original proc name is invalid') then goto skipend;


//------------------------------------------------------------------------------
//proc varlist
lp:=1;

for p:=1 to xlen do
begin

if      (c(p)='(') then lp:=p+1
else if (c(p)=')') then
   begin

   xvarlist:=stripwhitespace_lt(strcopy1(x,lp,p-lp));
   break;

   end
else if (c(p)=':') and (lp<=0) then break;

end;//p

if (xvarlist<>'') then
   begin

   str1:=xvarlist+';';
   bol1:=true;
   lp  :=1;

   for p:=1 to low__len(str1) do
   begin

   vc:=str1[p-1+stroffset];

   if (vc=';') or (vc=',') then
      begin

      str2:=stripwhitespace_lt(strcopy1(str1,lp,p-lp));

      //.strip trailing ":type" if present
      if (str2<>'') then for p2:=1 to low__len(str2) do if (str2[p2-1+stroffset]=':') then
         begin

         str2:=stripwhitespace_lt(strcopy1(str2,1,p2-1));
         break;

         end;


      //.stripleading "var" and "const" etc
      if (str2<>'') then for p2:=low__len(str2) downto 1 do if (str2[p2-1+stroffset]=#32) then
         begin

         str2:=strcopy1(str2,p2+1,low__len(str2));
         break;

         end;

      if (str2='') and emsg('A var name in varlist has no name') then goto skipend;

      xvarlistBARE:=xvarlistBARE+insstr(', ',xvarlistBARE<>'')+str2;

      lp:=p+1;

      end

   else if (vc=';') then lp:=p+1;

   end;//p

   end;

if (xvarlist<>'') and (xvarlistBARE='') and emsg('Varlist and varlistBARE mismatch') then goto skipend;


//------------------------------------------------------------------------------
//proc return type
lp          :=1;
bol1        :=true;
xcolon      :=false;

for p:=1 to xlen do
begin

if      (c(p)='(') then bol1:=false
else if (c(p)=')') then
   begin

   bol1:=true;
   lp  :=p+1;

   end;

if bol1 then
   begin

   if      (c(p)=':') then
      begin

      lp     :=p+1;
      xcolon :=true;

      end

   else if (c(p)=';') then
      begin

      if xcolon then
         begin

         xreturntype:=strlow(stripwhitespace_lt(strlow( strcopy1(x,lp,p-lp) )));
         if (xreturntype='stdcall') then xreturntype:='';

         end;

      break;

      end;
   end;

end;//p

//check
case xfunc of
true:if (xreturntype='')  and emsg('Function as no return type')             then goto skipend;
else if (xreturntype<>'') and emsg('Procedure cannot have a return type "'+xreturntype+'"') then goto skipend;
end;//case

//check return type
if (xreturntype<>'') then
   begin

   if
   //boolean
   rb('bool') or

   //longint
   ri('integer') or ri('longint') or ri('hbrush') or ri('COLORREF') or ri('dword') or ri('hdc') or ri('hbitmap') or ri('hwnd') or
   ri('hglobal') or ri('hcursor') or ri('hgdiobj') or ri('hmodule') or ri('hicon') or ri('hrgn') or ri('lresult') or ri('uint') or
   ri('hresult') or ri('HINST') or ri('hfont') or ri('SERVICE_STATUS_HANDLE') or ri('MMRESULT') or ri('tsocket') or
   ri('MCIERROR') or ri('tbasic_lresult') or ri('hmenu') or


   //word
   rw('atom') or

   //pointer
   rp('pointer') or rp('farproc') or

//   //thandle
   rh('thandle') or rh('SC_HANDLE') then

      begin
      //ok
      end

   //unknown return type -> report error
   else if emsg('Unknown return type "'+xreturntype+'"') then goto skipend;

   end;


//------------------------------------------------------------------------------
//dll name
lp:=0;
pc:=0;

for p:=xlen downto 1 do
begin

if (c(p)='''') then
   begin

   inc(pc);

   case pc of
   1:lp:=p-1;
   2:begin

      dname:=stripwhitespace_lt(strcopy1(x,p+1,lp-p));//case-sensitive dll name
      break;

      end;
   end;//case

   end;

end;//p

//.check name
if (dname='')  and emsg('Proc name is "nil"') then goto skipend;
xcore.longestname:=largest32(xcore.longestname,low__len(dname));


//------------------------------------------------------------------------------
//lib name
lp:=0;
pc:=0;

for p:=xlen downto 1 do
begin

if      ( c(p)=')' ) then break
else if ( (c(p)='e') or (c(p)='E') ) and ( strmatch( strcopy1(x,p-1,10),' external ' ) or strmatch( strcopy1(x,p-1,10),';external ' ) ) then
   begin

   //find lib name
   lp  :=1;
   pc  :=0;

   for p2:=p to xlen do
   begin

   if (c(p2)=#32) then
      begin

      inc(pc);

      if (pc>=2) then
         begin

         lname:=strlow(stripwhitespace_lt(strcopy1(x,lp,p2-lp)));
         break;

         end;

      lp:=p2+1;

      end;


   end;//p2

   break;

   end;

end;//p

if (lname='') and emsg('Proc has no lib name') then goto skipend;

//similar names conversion
if      (lname='mmsyst')      then lname:='winmm'
else if (lname='winspl')      then lname:='winspool'
else if (lname='winsocket')   then lname:='wsock32';

if (not win__finddllname(lname,lnameindex)) and emsg('Li'+'b name unknown "'+lname+'"') then goto skipend;


//------------------------------------------------------------------------------
//default value - optional -> "[[some value]]" (without double quotes)
lp    :=xlen;
bol1  :=false;
bol2  :=false;
etmp  :='';

for p:=1 to xlen do
begin

if (c(p)='[') and strmatch(strcopy1(x,p,2),'[[') and (not bol1) then
   begin

   bol1 :=true;
   lp   :=p+2;

   end
else if bol1 and ((c(p)=']') and (strcopy1(x,p,2)=']]')) then
   begin

   bol2        :=true;
   xhasdefault :=xreadDefaultVars( strcopy1(x,lp,p-lp) ,etmp);

   break;

   end;

end;//p

if bol1 and (not bol2) and emsg('Warning:'+rcode+'Default value started but not finished')                   then goto skipend;

if bol1 and bol2 and (not xhasdefault) and emsg('Warning:'+rcode+'Default value equates to an usable value' + insstr(' ('+etmp+')',etmp<>'') ) then goto skipend;

if xhasdefault then inc(xcore.defaultcount);


//------------------------------------------------------------------------------
//generate proc code

//init
xfuncbody      :=insstr('(',xvarlist<>'')+xvarlist+insstr(')',xvarlist<>'');
xfuncbodyBARE  :=insstr('(',xvarlist<>'')+xvarlistBARE+insstr(')',xvarlist<>'');
xfuncbody2     :=low__aorbstr('procedure','function',xfunc)+xfuncbody+insstr(':',xreturntype<>'')+xreturntype;
pname          :='t'+xorgprocname;
vname          :='v'+xorgprocname;
xprocline      :=low__aorbstr('procedure','function',xfunc)+#32+xorgprocname+xfuncbody+insstr(':',xreturntype<>'')+xreturntype+';';

//.exclude repeates
if not (xcore.lhistory as tdynamicnamelist).addonce(xprocline) then
   begin

   result:=true;
   goto skipend;

   end;

//.proc vars
str__as8f(@xcore.lprocvars).sadd( '   '+xpad1(vname)+'='+k64(xcore.proccount)+';' + rcode );

//.proc types
str__as8f(@xcore.lproctype).sadd('   '+xpad1(pname)+'='+xfuncbody2+'; stdcall;'+rcode );

//.proc line
str__as8f(@xcore.lprocline).sadd( xprocline + rcode );

//.proc info -> optional -> only add an entry if default vars present
case xhasdefault of
true:if not xdefvalsononeline(xdefvalsline) then goto skipend;
else xdefvalsline:='';
end;//case

str1:=intstr32(strint32( xdefvals.s['result'] ));
case (xdefvalsline<>'') of
true:str__as8f(@xcore.lprocinfo).sadd( xpad0(vname)+':s4( ' + xpad2(str1) +',d'+xpad3(win__dllname2(lnameindex,false)) + ','+xpad4('''' + dname + '''') + ',' + xpad4(''''+xdefvalsline+'''') + ');' + insstr('//custom return value',str1<>'0') + rcode );
else str__as8f(@xcore.lprocinfo).sadd( xpad0(vname)+':s3( ' + xpad2(str1) +',d'+xpad3(win__dllname2(lnameindex,false)) + ','+xpad4('''' + dname + '''') + ');' + insstr('//custom return value',str1<>'0') + rcode );
end;//case

//.proc body
str__as8f(@xcore.lprocbody).sadd(

'//'+x+rcode+//keep a copy of the original proc
rcode+
xprocline+rcode+
'var'+rcode+
'   a:pointer;'+rcode+
'begin'+rcode+

low__aorbstr(
 'if win__use'+xloadType+'('+vname+',a) then '+pname+'(a)'+xfuncbodyBARE+';'+rcode,//as a procedure
 'if win__use'+xloadType+'(result,'+vname+',a) then result:='+pname+'(a)'+xfuncbodyBARE+';'+rcode,//as a function
xfunc)+

'win__dec;'+rcode+
'end;'+rcode+
rcode+
rcode+

'');

//.inc
inc(xcore.proccount);


//------------------------------------------------------------------------------
//successful
result:=true;

skipend:
except;end;

//free
freeobj(@xdefvals);

end;

function win__makeprocs(const sf,df,dversionlabel:string):boolean;
label
   skipend;
const
   xpointPrefix='//## [';
   xstartpoint=xpointPrefix+'win32-api-scanner-start-point]';
   xstoppoint =xpointPrefix+'win32-api-scanner-stop-point]';
var
   a:tdynamicstring;
   xcore:twinscannerinfo;
   e,etmp,ecdprocline,dv,dv2:string;
   xpointPrefixLEN,int1,p:longint;
   bol1,xscanning:boolean;

   function emsg(const x:string):boolean;
   begin

   result:=true;
   if (e='') then e:=x;

   end;

   function m(const x:string):boolean;
   begin
   result:=strmatch( x, strcopy1(a.value[p],1,low__len(x)) );
   end;

   procedure ladd(const x:string);//add line
   begin

   str__as8f(@xcore.dunit).sadd(x+rcode);

   end;

   procedure radd(const x:string);//raw add (no return code)
   begin

   str__as8f(@xcore.dunit).sadd(x);

   end;

   function mt(xok:boolean):string;
   begin

   result:='-- Win32 Proc Extraction '+low__aorbstr('Failed','Successful',xok)+' ('+io__extractfilename(sf)+') --'+rcode+rcode;

   end;

   function sm(const xmsg:string):boolean;
   begin

   result:=true;
   showtext(mt(true)+xmsg);

   end;

   function se(const xmsg:string):boolean;
   begin

   result:=true;
   showerror(mt(false)+xmsg);

   end;

   function xpad1(const x:string):string;
   const
      xline='                                                      ';
   begin
   result:=x+strcopy1(xline,1,low__len(xline)-low__len(x));
   end;

begin

//defaults
result             :=false;
a                  :=nil;
low__cls(@xcore,sizeof(xcore));
e                  :='';
xscanning          :=false;
xpointPrefixLEN    :=low__len(xpointPrefix);

try
//check
if not io__fileexists(sf) and emsg('Source filename does not exist:'+rcode+sf) then goto skipend;
if strmatch(sf,df) and emsg('Source and destination filenames are the same')   then goto skipend;

//init
a              :=tdynamicstring.create;
a.text         :=io__fromfilestr2( sf );

if (a.count<=0) and emsg('No text to process') then goto skipend;

//.core
with xcore do
begin

lhistory   :=tdynamicnamelist.create;//tracks repeat entries
lprocvars  :=str__new8;//(tstr8) list of procs as constants
lproctype  :=str__new8;//(tstr8) list of procs as record types
lprocline  :=str__new8;//(tstr8) list of procs as a procedure or function definition line
lprocbody  :=str__new8;//(tstr8) list of procs as a procedure or function text
lprocinfo  :=str__new8;//(tstr8) list of procs in a management function(s)
dunit      :=str__new8;

end;


//get
for p:=0 to pred(a.count) do
begin

//.start/stop scan
if (strcopy1(a.value[p],1,xpointPrefixLEN)=xpointPrefix) then
   begin

   if      m(xstartpoint) then xscanning:=true
   else if m(xstoppoint)  then break;

   end;

//.read line
if xscanning and (not win__makeproc(a.value[p],xcore,e)) then
   begin

   e:='Error at line '+k64(p)+rcode+rcode+e;
   goto skipend;

   end;

end;//p

//check
if (not xscanning) and emsg('Start/stop scanner commands not found in source code') then goto skipend;


//build unit "gosswin2.pas"

//unit header
ladd('unit gosswin2;');
ladd('');
ladd('interface');
ladd('');
ladd('uses gosswin;');
ladd('{$align on}{$iochecks on}{$O+}{$W-}{$U+}{$V+}{$B-}{$X+}{$T-}{$P+}{$H+}{$J-}');
ladd('//## ==========================================================================================================================================================================================================================');
ladd('//##');
ladd('//## MIT License');
ladd('//##');
ladd('//## Copyright '+low__yearstr(2025)+' Blaiz Enterprises ( http://www.blaizenterprises.com )');
ladd('//##');
ladd('//## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation');
ladd('//## files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,');
ladd('//## modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software');
ladd('//## is furnished to do so, subject to the following conditions:');
ladd('//##');
ladd('//## The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.');
ladd('//##');
ladd('//## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES');
ladd('//## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE');
ladd('//## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN');
ladd('//## CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.');
ladd('//##');
ladd('//## ==========================================================================================================================================================================================================================');
ladd('//## Note..................... ** This is an automatically generated unit, created by "gosswin.win__make_gosswin2_pas" **');
ladd('//## Library.................. dynamically loaded and managed 32bit Windows api''s (gosswin2.pas)');
ladd('//## Version.................. '+dversionlabel);
ladd('//## Items.................... '+k64(xcore.proccount) );
ladd('//## Last Updated ............ '+strlow(low__remcharb(low__datestr(date__now,4,false),#32)) );
ladd('//## ==========================================================================================================================================================================================================================');

ladd('');
ladd('');


//unit code
ladd('const');
radd( '   '+xpad1('vwin____proccount')+'='+k64(xcore.proccount)+';//total number of Win32 api procs defined' + rcode );
radd( str__as8f(@xcore.lprocvars).text );

ladd('');
ladd('');
ladd('type');
radd( str__as8f(@xcore.lproctype).text );

ladd('');
ladd('');
ladd('function win____slotinfo(const xslot:longint;var dname,rvalue:longint;var pname:string;var xmisc:string):boolean;');
radd( str__as8f(@xcore.lprocline).text );

ladd('');
ladd('');
ladd('implementation');

ladd('');
ladd('');
ladd('function win____slotinfo(const xslot:longint;var dname,rvalue:longint;var pname:string;var xmisc:string):boolean;');
ladd('');
ladd('   procedure s3(const _rvalue,_dname:longint;const _pname:string);');
ladd('   begin');
ladd('');
ladd('   rvalue :=_rvalue;');
ladd('   dname  :=_dname;');
ladd('   pname  :=_pname;');
ladd('');
ladd('   end;');
ladd('');
ladd('   procedure s4(const _rvalue,_dname:longint;const _pname,_xmisc:string);');
ladd('   begin');
ladd('');
ladd('   rvalue :=_rvalue;');
ladd('   dname  :=_dname;');
ladd('   pname  :=_pname;');
ladd('   xmisc  :=_xmisc;');
ladd('');
ladd('   end;');
ladd('');
ladd('begin');
ladd('');
ladd('//defaults');
ladd('result :=true;');
ladd('dname  :=dnone;');
ladd('rvalue :=0;');
ladd('pname  :='''';');
ladd('xmisc  :='''';');
ladd('');
ladd('//get');
ladd('case xslot of');
radd( str__as8f(@xcore.lprocinfo).text );
ladd('-1:;//placeholder');
ladd('end;//case');
ladd('');
ladd('end;');

ladd('');
ladd('');
radd( str__as8f(@xcore.lprocbody).text );

ladd('end.');


//save unit
if (not io__tofile(df,@xcore.dunit,etmp)) and emsg('Save unit failed ('+etmp+')') then goto skipend;

//successful
result:=true;
skipend:

except;end;

//free
freeobj(@a);
freeobj(@xcore.lhistory);
freeobj(@xcore.lprocvars);
freeobj(@xcore.lproctype);
freeobj(@xcore.lprocline);
freeobj(@xcore.lprocbody);
freeobj(@xcore.lprocinfo);
freeobj(@xcore.dunit);

//show result
case result of
true:begin

   sm(
   k64(xcore.proccount)+' proc'+insstr('s',xcore.proccount<>1)+' converted to dynamic loading'+rcode+
   k64(xcore.longestname)+' char'+insstr('s',xcore.longestname<>1)+' is the longest dll proc name'+rcode+
   k64(xcore.defaultcount)+' proc'+insstr('s',xcore.defaultcount<>1)+' defined with default vars'+rcode+
   '');

   end;
else se(e);
end;//case

end;

procedure win__make_gosswin2_pas;
const
   dversionlabel='4.00.531';//'ver'
begin
win__makeprocs( io__asfolderNIL(io__extractfilepath(io__exename))+'gosswin.p'+'as', io__asfolderNIL(io__extractfilepath(io__exename))+'gosswin2.p'+'as' ,dversionlabel );
end;

function win__errmsg(const e:longint):string;
begin

case e of
waOK                :result:='OK';
waBadDLLName        :result:='FAIL: Bad D'+'LL name';
waBadProcName       :result:='FAIL: Bad Pr'+'oc name';
waDLLLoadFail       :result:='FAIL: D'+'LL not loaded';
waProcNotFound      :result:='FAIL: Pr'+'oc not found';
else                 result:='-';
end;//case

end;

function win__dllname(const xindex:longint):string;
begin
result:=win__dllname2(xindex,false);
end;

function win__dllname2(const xindex:longint;xincludeext:boolean):string;
begin

case xindex of
duser32      :result:='use'+'r32';
dshell32     :result:='sh'+'el'+'l32';
dShcore      :result:='S'+'hco'+'re';
dxinput1_4   :result:='xin'+'put'+'1_4';
dadvapi32    :result:='adv'+'ap'+'i32';
dkernel32    :result:='ke'+'rne'+'l32';
dmpr         :result:='mp'+'r';
dversion     :result:='ver'+'si'+'on';
dcomctl32    :result:='co'+'mct'+'l32';
dgdi32       :result:='gd'+'i32';
dopengl32    :result:='open'+'gl32';
dwintrust    :result:='wi'+'ntr'+'ust';
dole32       :result:='ol'+'e32';
doleaut32    :result:='olea'+'ut32';
dolepro32    :result:='olep'+'ro32';
dwinmm       :result:='win'+'mm';
dwsock32     :result:='wso'+'ck32';
dwinspool    :result:='win'+'s'+'pool';//.drv
dcomdlg32    :result:='co'+'mdl'+'g32';//04oct2025
else          result:='';
end;//case

//extension
if xincludeext then
   begin

   case xindex of
   dwinspool :result:=result+'.'+'dr'+'v';
   else       result:=result+'.'+'d'+'ll';
   end;//case

   end;

end;

function win__finddllname(const xname:string;var xindex:longint):boolean;
var
   p:longint;
begin

//defaults
result :=false;
xindex :=dnone;

//find
for p:=1 to dmax do if strmatch(xname, win__dllname2(p,false) ) then
   begin

   result :=true;
   xindex :=p;
   break;

   end;//p

end;


procedure win__inc(const xslot:longint);
begin

//check
if (xslot<0) or (xslot>high(system_wincore.u)) or (not system_wincore.u[xslot]) then exit;

//set
inc164(system_wincore.c[xslot]);//number of calls to this proc
inc164(system_wincore.pcalls);//total number of proc calls (covers all procs)

if (system_wincore.d[xslot]>dnone) and (system_wincore.d[xslot]<=dmax) then inc164(system_wincore.dcalls[ system_wincore.d[xslot] ]);//number of calls to this proc

if (system_wincore.tracedepth>=0) and (system_wincore.tracedepth<=high(system_wincore.tracelist)) then system_wincore.tracelist[system_wincore.tracedepth]:=xslot;

inc132(system_wincore.tracedepth);

end;

procedure win__dec;
begin

dec132(system_wincore.tracedepth);

//win__depthtrace(20);

end;

procedure win__depthtrace(xlimit:longint);
var
   str1,v:string;
   int1,i,p:longint;
begin

v:='';

for p:=frcrange32(system_wincore.tracedepth,1,50) downto 1 do
begin

i:=system_wincore.tracedepth-p;
if (i>=0) and (i<=high(system_wincore.tracelist)) then
   begin

   int1:=system_wincore.tracelist[i];

   if (int1>=0) and (int1<=high(system_wincore.u)) then
      begin

      if not system_wincore.u[int1]        then str1:='proc not in use'
      else if (system_wincore.p[int1]=nil) then str1:='proc not supported'
      else                                      str1:=strdefb(win__procname(int1),'proc has no name');

      end
   else                                         str1:='< trace error >';

   v:=v+intstr32(i)+'. ['+str1+']'+rcode;

   end
else break;

end;//p

if (v='') then v:='No trace available';

showtext('-- Trace --'+rcode+v);

end;

function win__infocount:longint;
begin
result:=1 + system_wincore.dcount + 1 + 2 + system_wincore.pcount;
end;

function win__infofind(xindex:longint;var v1,v2,v3,v4:string;var xtitle:boolean):boolean;
label
   redo;
var
   i:longint;

   function xfind1(var i:longint):boolean;
   var
      tc,c,p:longint;
   begin

   //defaults
   result :=false;
   i      :=0;
   tc     :=xindex+1-2;
   c      :=0;

   //find
   for p:=0 to high(system_wincore.du) do if system_wincore.du[p] then
      begin

      inc(c);

      if (c=tc) then
         begin

         i      :=p;
         result :=true;
         break;

         end;

      end;//p

   end;

   function xfind2(var i:longint):boolean;
   var
      tc,c,p:longint;
   begin

   //defaults
   result :=false;
   i      :=0;
   tc     :=xindex+1-system_wincore.dcount-4;
   c      :=0;

   //find
   for p:=0 to high(system_wincore.u) do if system_wincore.u[p] then
      begin

      inc(c);

      if (c=tc) then
         begin

         i      :=p;
         result :=true;
         break;

         end;

      end;//p

   end;

begin

//defaults
result :=false;
v1     :='';
v2     :='';
v3     :='';
v4     :='';
xtitle :=false;

//get

if (xindex=0) then
   begin

   xtitle :=true;
   v1     :='DLL Name';
   v2     :='Status';
   v3     :='Calls';
   result :=true;

   end

else if (xindex=1) then
   begin

   v1     :='Total';
   v2     :='-';
   v3     :=k64(system_wincore.pcalls);
   result :=true;

   end

else if xfind1(i) then
   begin

   v1        :=win__dllname2(i,true);
   v2        :=win__errmsg(system_wincore.de[i]);
   v3        :=k64(system_wincore.dcalls[i]);

   result    :=true;

   end

else if (xindex=(system_wincore.dcount+2)) then
   begin

   //space

   end

else if (xindex=(system_wincore.dcount+3)) then
   begin

   xtitle :=true;
   v1     :='API Name';
   v2     :='Status';
   v3     :='Calls';
   result :=true;

   end

else if xfind2(i) then
   begin

   v1        :=win__procname(i);
   v2        :=win__errmsg(system_wincore.e[i]);
   v3        :=k64(system_wincore.c[i]);

   result    :=true;

   end;

end;

function win__procCallCount(const xslot:longint):comp;
begin
if (xslot>=0) and (xslot<=high(system_wincore.u)) and system_wincore.u[xslot] then result:=system_wincore.c[xslot] else result:=0;
end;

function win__proccount:longint;
begin
result:=vwin____proccount;
end;

function win__procload:longint;
begin
result:=system_wincore.pOK;
end;

function win__proccalls:comp;
begin
result:=system_wincore.pcalls;
end;

function win__dllload:longint;
begin
result:=system_wincore.dOK;
end;

procedure win__init;//should be called from app__boot
begin

//check
if system_wininit then exit else system_wininit:=true;

//get
low__cls(@system_wincore,sizeof(system_wincore));//30aug2025

end;

function win__ok(const xslot:longint):boolean;
begin

case xslot of
0..high(system_wincore.u) :result:=( system_wincore.u[xslot] or win__loaded(xslot) ) and (system_wincore.p[xslot]<>nil);
else                       result:=false;
end;//case

end;

function win__procname(const xslot:longint):string;
var
   dname,rvalue:longint;
   xmisc:string;
begin
win__slotinfo(xslot,dname,rvalue,result,xmisc);
end;

function win__slotinfo(const xslot:longint;var dname,rvalue:longint;var pname:string;var xmisc:string):boolean;
begin
result:=win____slotinfo(xslot,dname,rvalue,pname,xmisc);
end;

function win__loaded(const xslot:longint):boolean;
var
   a:hmodule;
   b:pointer;
   dname,rvalue:longint;
   pname:string;
   smisc:string;

   function emsg(const xmsg:longint):boolean;
   begin

   result                  :=true;
   system_wincore.e[xslot] :=xmsg;

   end;

begin

//defaults
result      :=false;

//range check
if (xslot<0) or (xslot>high(system_wincore.u)) then
   begin

   //out of range

   end

//load now
else if (not system_wincore.u[xslot]) then
   begin

   //init
   system_wincore.u[xslot] :=true;//mark slot as in use - all other values are zeroed out at this stage, which is their default state

   inc132(system_wincore.pcount);
   inc132(system_wincore.pOK);


   //fetch slot info
   win__slotinfo(xslot,dname,rvalue,pname,smisc);


   //.set important values for fast access
   system_wincore.r [xslot]  :=rvalue;//default return value for proc when unable to access it (e.g. fails to load)
   system_wincore.r2[xslot]  :=frcrange32(rvalue,0,max16);//26sep2025
   system_wincore.d [xslot]  :=dname; //dll name as an index


   //.check DLL and PROC names are valid
   if ( (dname<=dnone) or (dname>dmax) ) and emsg(waBadDLLName)  then exit;
   if (pname='')                         and emsg(waBadProcName) then exit;


   //load dll -> on failure -> stop here
   a:=system_wincore.dh[dname];

   //.attempt to load the DLL if not already in use (du=true)
   if (a=0) and (not system_wincore.du[dname]) then
      begin

      system_wincore.du[dname]:=true;//mark dll slot as in use

      system_wincore.dh[dname] :=win____LoadLibraryA(pchar( win__dllname(dname) ));//cache module handle
      a                        :=system_wincore.dh[dname];

      system_wincore.de[dname] :=low__aorb(waDLLLoadFail,waOk,a<>0);

      inc132(system_wincore.dcount);

      case (a<>0) of
      true:inc132(system_wincore.dOK);
      else inc132(system_wincore.dFAIL);
      end;//case

      end;

   //check DLL loaded -> on failure -> stop here
   if (a=0) and emsg(waDLLLoadFail) then exit;


   //fetch api proc function pointer by name -> on failure -> stop here
   b:=win____GetProcAddress(a,PAnsiChar( pname ));

   if (b=nil) then
      begin

      dec132(system_wincore.pOK);
      inc132(system_wincore.pFAIL);

      end;


   //check proc linked -> on failure -> stop here
   if (b=nil) and emsg(waProcNotFound) then exit;


   //get
   system_wincore.p[xslot] :=b;//set proc pointer (link to it)
   result                  :=true;

   end;

end;

function win__usebol(var xdefresult:bool;const xslot:longint;var xptr:pointer):boolean;////26sep2025
begin

result:=(xslot>=0) and (xslot<=high(system_wincore.u));

if result then
   begin

   result       :=win__ok(xslot);//26sep2025
   xdefresult   :=(system_wincore.r[xslot]<>0);//26sep2025
   xptr         :=system_wincore.p[xslot];
   win__inc(xslot);

   end
else
   begin

   xdefresult   :=false;
   xptr         :=nil;

   end;

end;

function win__usewrd(var xdefresult:word;const xslot:longint;var xptr:pointer):boolean;//26sep2025
begin

result:=(xslot>=0) and (xslot<=high(system_wincore.u));

if result then
   begin

   result       :=win__ok(xslot);//26sep2025
   xdefresult   :=system_wincore.r2[xslot];//word version
   xptr         :=system_wincore.p[xslot];
   win__inc(xslot);

   end
else
   begin

   xdefresult   :=0;
   xptr         :=nil;

   end;

end;

function win__useint(var xdefresult:longint;const xslot:longint;var xptr:pointer):boolean;//26sep2025
begin

result:=(xslot>=0) and (xslot<=high(system_wincore.u));

if result then
   begin

   result       :=win__ok(xslot);//26sep2025
   xdefresult   :=system_wincore.r[xslot];//26sep2025
   xptr         :=system_wincore.p[xslot];
   win__inc(xslot);

   end
else
   begin

   xdefresult   :=0;
   xptr         :=nil;

   end;

end;

function win__useptr(var xdefresult:pointer;const xslot:longint;var xptr:pointer):boolean;
begin

result:=(xslot>=0) and (xslot<=high(system_wincore.u));

if result then
   begin

   xdefresult   :=nil;
   result       :=system_wincore.u[xslot] or win__loaded(xslot);
   xptr         :=system_wincore.p[xslot];
   win__inc(xslot);

   end
else
   begin

   xdefresult   :=nil;
   xptr         :=nil;

   end;

end;

function win__usehnd(var xdefresult:thandle;const xslot:longint;var xptr:pointer):boolean;
begin

result:=(xslot>=0) and (xslot<=high(system_wincore.u));

if result then
   begin

   xdefresult   :=0;
   result       :=system_wincore.u[xslot] or win__loaded(xslot);
   xptr         :=system_wincore.p[xslot];
   win__inc(xslot);

   end
else
   begin

   xdefresult   :=0;
   xptr         :=nil;

   end;

end;

function win__use(const xslot:longint;var xptr:pointer):boolean;
begin

result:=(xslot>=0) and (xslot<=high(system_wincore.u));

if result then
   begin

   result       :=system_wincore.u[xslot] or win__loaded(xslot);
   xptr         :=system_wincore.p[xslot];
   win__inc(xslot);

   end
else
   begin

   xptr         :=nil;

   end;

end;

procedure win__errbol(var xresult:bool;const xreturn:bool);
begin

if (xresult<>xreturn) then inc132(system_wincore.ecount);
xresult:=xreturn;

end;

procedure win__errwrd(var xresult:word;const xreturn:word);
begin

if (xresult<>xreturn) then inc132(system_wincore.ecount);
xresult:=xreturn;

end;

procedure win__errint(var xresult:longint;const xreturn:longint);
begin

if (xresult<>xreturn) then inc132(system_wincore.ecount);
xresult:=xreturn;

end;

procedure win__errptr(var xresult:pointer;const xreturn:pointer);
begin

if (xreturn=nil) then inc132(system_wincore.ecount);
xresult:=xreturn;

end;

procedure win__errhnd(var xresult:thandle;const xreturn:thandle);
begin

if (xreturn=0) then inc132(system_wincore.ecount);
xresult:=xreturn;

end;


//xbox controller procs --------------------------------------------------------
procedure xbox__stop;//called internally on app shutdown
var
   p:longint;
begin
if system_xbox_init then
   begin
   //turn off controller motors
   for p:=0 to high(system_xbox_retryref64) do xbox__setstate2(p,0,0);
   end;
end;

function xbox__inited:boolean;
begin
result:=system_xbox_init;
end;

function xbox__init:boolean;
var
   p:longint;
begin
//init
if not system_xbox_init then
   begin
   //do once only
   system_xbox_init:=true;

   {$ifdef gui}

   //cls system vars

   //.keyboard support on slot #4
   low__cls(@system_xbox_keyboard,sizeof(system_xbox_keyboard));
   xbox__keymap__defaults;


   //.mouse support on slot #5
   low__cls(@system_xbox_mouse,sizeof(system_xbox_mouse));


   //.xbox controller support on slots #0..#3
   for p:=0 to high(system_xbox_retryref64) do
   begin
   low__cls(@system_xbox_statelist[p],sizeof(system_xbox_statelist[p]));
   low__cls(@system_xbox_setstatelist[p],sizeof(system_xbox_setstatelist[p]));

   system_xbox_retryref64[p]      :=0;
   system_xbox_statelist[p].index :=p;
   end;//p

   //idle support
   low__cls(@system_xbox_idleref,sizeof(system_xbox_idleref));
   system_xbox_idletime :=ms64;

   //game input labels
   for p:=0 to high(system_xbox_input_labels) do
   begin
   system_xbox_input_labels[p]   :='';
   system_xbox_input_allowed[p]  :=false;
   end;

   {$endif}
   end;

//get
result:=win__ok(vwin2____XInputGetState) and win__ok(vwin2____XInputSetState);
end;

function xbox__info(xindex:longint):pxboxcontrollerinfo;//use "xindex=-1" for defaultindex
begin
xindex:=xbox__index(xindex);

if system_xbox_init then result:=@system_xbox_statelist[xindex]
else
   begin
   result:=@system_xbox_statelist[-1];
   low__cls(result,sizeof(result^));
   result.index:=xindex;
   end;
end;

function xbox__state(xindex:longint):boolean;//xindex=0..3 = max of 4 controllers, return=true=connected and we might have new data, check "xbox__info[].newdata" - 22jul2025
var
   s:txinputstate;
   w:word;
   xinvok,ltwas0,rtwas0,sclicked:boolean;

   function dz(x:double):double;//22jul2025
   begin

   //-1..-0
   if (x<-system_xbox_deadzone) then
      begin

      result:=xbox__roundtozero( -( (-x-system_xbox_deadzone) / frcminD64(1-system_xbox_deadzone,0.1) ) );//22jul2025
      if (result<-1) then result:=-1;

      end

   //0+..1
   else if (x>system_xbox_deadzone) then
      begin

      result:=xbox__roundtozero( +( (x-system_xbox_deadzone) / frcminD64(1-system_xbox_deadzone,0.1) ) );//22jul2025
      if (result>1) then result:=1;

      end

   //0
   else result:=0;

   end;

   procedure sclick(var xvar,xclickvar:boolean;xfindval:longint);
   var
      xnewval:boolean;
   begin
   xnewval:=bit__hasval16(w,xfindval);
   if xnewval and (not xvar) then
      begin
      xclickvar:=true;
      sclicked:=true;
      end;
   xvar:=xnewval;
   end;

   procedure xthumbstickClick(var a:thumbstickinfo;x,y:double);
   begin

   //filter
   x   :=dz(x);
   y   :=dz(y);

   //init
   if (x<0) and (x<a.lpeak) then a.lpeak:=x;
   if (x>0) and (x>a.rpeak) then a.rpeak:=x;
   if (y<0) and (y<a.dpeak) then a.dpeak:=y;
   if (y>0) and (y>a.upeak) then a.upeak:=y;

   //get

   //.left
   if (a.lpeak<=-xbox_thumbstick_threshold_value) and (x=0) then
      begin
      a.lpeak   :=0;
      a.lclick  :=true;
      end;

   //.right
   if (a.rpeak>=+xbox_thumbstick_threshold_value) and (x=0) then
      begin
      a.rpeak   :=0;
      a.rclick  :=true;
      end;

   //.up
   if (a.upeak>=+xbox_thumbstick_threshold_value) and (y=0) then
      begin
      a.upeak   :=0;
      a.uclick  :=true;
      end;

   //.down
   if (a.dpeak<=-xbox_thumbstick_threshold_value) and (y=0) then
      begin
      a.dpeak   :=0;
      a.dclick  :=true;
      end;

   end;

   procedure yinvert;
   begin

   with system_xbox_statelist[xindex] do
   begin
   ly:=-ly;
   ry:=-ry;
   end;

   end;

   procedure xinvert;
   begin

   with system_xbox_statelist[xindex] do
   begin
   lx:=-lx;
   rx:=-rx;
   end;

   end;

begin

//range
xindex:=xbox__index(xindex);


//init
system_xbox_statelist[xindex].index :=xindex;
sclicked                            :=false;
xinvok                              :=not system_xbox_suspend_all_inversions;

//limit retry rate when controller is not connected or not present -> as per MS specs
if (system_xbox_retryref64[xindex]<>0) and (system_xbox_retryref64[xindex]>=ms64) then
   begin
   result:=false;

   with system_xbox_statelist[xindex] do
   begin
   connected :=false;
   newdata   :=false;
   end;//with

   exit;
   end;


//get
//.controller is present and connected
if xbox__init and ( ((xindex<=xssNativeMax) and (0=win2____XInputGetState(xindex,@s))) or ((xindex=xssKeyboard) and xbox__keyslot_getstate(@s)) or ((xindex=xssMouse) and xbox__mouseslot_getstate(@s)) ) then
   begin
   result:=true;
   system_xbox_retryref64[xindex]:=0;//disable retry limit (delay)


   with system_xbox_statelist[xindex] do
   begin

   //init
   connected    :=true;
   newdata      :=(packetcount<>s.dwPacketNumber);
   packetcount  :=s.dwPacketnumber;

   ltwas0       :=(lt=0);
   lt           :=dz(fr64(s.dGamepad.bleftTrigger/255,0,1));

   rtwas0       :=(rt=0);
   rt           :=dz(fr64(s.dGamepad.brightTrigger/255,0,1));

   lx           :=dz(fr64(s.dGamepad.sThumbLX/32768,-1,1));
   ly           :=dz(fr64(s.dGamepad.sThumbLY/32768,-1,1));
   rx           :=dz(fr64(s.dGamepad.sThumbRX/32768,-1,1));
   ry           :=dz(fr64(s.dGamepad.sThumbRY/32768,-1,1));


   //invert X and Y axis - 24jul2025
   case xindex of
   xssNativeMin..xssNativeMax:if xinvok then
      begin

      if system_xbox_nativecontroller_inverty       then yinvert;
      if system_xbox_nativecontroller_invertx       then xinvert;

      if system_xbox_nativecontroller_swapjoysticks then
         begin
         low__swapd64(lx,rx);
         low__swapd64(ly,ry);
         end;

      if system_xbox_nativecontroller_swaptriggers then low__swapd64(lt,rt);

      end;
   xssKeyboard:if xinvok then
      begin

      if system_xbox_keyboard_inverty then yinvert;
      if system_xbox_keyboard_invertx then xinvert;

      end;
   xssMouse:if xinvok then
      begin

      if system_xbox_mouse_inverty     then yinvert;
      if system_xbox_mouse_invertx     then xinvert;

      if system_xbox_mouse_swapbuttons then
         begin
         low__swapd64(lt,rt);
         end;

      end;
   end;//case


   //triggers as clicks - 26jul2025
   if (lt<>0) and ltwas0 then ltclick:=true;
   if (rt<>0) and rtwas0 then rtclick:=true;


   //thumbsticks as clicks -> don't process thumbstick clicks for mouse - 28jul2025, 22jul2025
   if (xindex<>xssMouse) then
      begin
      xthumbstickClick(lxyinfo,lx,ly);
      xthumbstickClick(rxyinfo,rx,ry);
      end;


   //buttons
   w            :=s.dGamepad.wbuttons;

   case xindex of
   xssNativeMin..xssNativeMax:begin

      //.set and/or swap thumb clicks (joystick clicks)
      sclick(lb,lbclick,low__aorb(XINPUT_GAMEPAD_LEFT_THUMB,XINPUT_GAMEPAD_RIGHT_THUMB,xinvok and system_xbox_nativecontroller_swapjoysticks));
      sclick(rb,rbclick,low__aorb(XINPUT_GAMEPAD_RIGHT_THUMB,XINPUT_GAMEPAD_LEFT_THUMB,xinvok and system_xbox_nativecontroller_swapjoysticks));

      //.set and/or swap bumpers
      sclick(ls,lsclick,low__aorb(XINPUT_GAMEPAD_LEFT_SHOULDER,XINPUT_GAMEPAD_RIGHT_SHOULDER,xinvok and system_xbox_nativecontroller_swapbumpers));
      sclick(rs,rsclick,low__aorb(XINPUT_GAMEPAD_RIGHT_SHOULDER,XINPUT_GAMEPAD_LEFT_SHOULDER,xinvok and system_xbox_nativecontroller_swapbumpers));

      sclick(u,uclick,XINPUT_GAMEPAD_DPAD_UP);
      sclick(d,dclick,XINPUT_GAMEPAD_DPAD_DOWN);
      sclick(l,lclick,XINPUT_GAMEPAD_DPAD_LEFT);
      sclick(r,rclick,XINPUT_GAMEPAD_DPAD_RIGHT);

      end;
   xssKeyboard:begin

      sclick(lb,lbclick,XINPUT_GAMEPAD_LEFT_THUMB);
      sclick(rb,rbclick,XINPUT_GAMEPAD_RIGHT_THUMB);

      sclick(ls,lsclick,XINPUT_GAMEPAD_LEFT_SHOULDER);
      sclick(rs,rsclick,XINPUT_GAMEPAD_RIGHT_SHOULDER);

      sclick(u,uclick,low__aorb(XINPUT_GAMEPAD_DPAD_UP,XINPUT_GAMEPAD_DPAD_DOWN,xinvok and system_xbox_keyboard_inverty));
      sclick(d,dclick,low__aorb(XINPUT_GAMEPAD_DPAD_DOWN,XINPUT_GAMEPAD_DPAD_UP,xinvok and system_xbox_keyboard_inverty));
      sclick(l,lclick,low__aorb(XINPUT_GAMEPAD_DPAD_LEFT,XINPUT_GAMEPAD_DPAD_RIGHT,xinvok and system_xbox_keyboard_invertx));
      sclick(r,rclick,low__aorb(XINPUT_GAMEPAD_DPAD_RIGHT,XINPUT_GAMEPAD_DPAD_LEFT,xinvok and system_xbox_keyboard_invertx));

      end;
   end;//case


   //core buttons
   sclick(start,startclick,XINPUT_GAMEPAD_START);
   sclick(back,backclick,XINPUT_GAMEPAD_BACK);

   sclick(a,aclick,XINPUT_GAMEPAD_A);
   sclick(b,bclick,XINPUT_GAMEPAD_B);
   sclick(x,xclick,XINPUT_GAMEPAD_X);
   sclick(y,yclick,XINPUT_GAMEPAD_Y);

   if (xindex=xssKeyboard) then
      begin

      if xbox__usebool(system_xbox_keyboard.enter) then entClick:=true;
      if xbox__usebool(system_xbox_keyboard.esc)   then escClick:=true;
      if xbox__usebool(system_xbox_keyboard.del)   then delClick:=true;

      end;

   end;//with
   end


//.failed -> controller not present or is disconnected
else
   begin
   result:=false;
   system_xbox_retryref64[xindex]:=ms64+3000;//engage retry limiter (delay) => don't try again for 3s when controller is disconnected or not present

   with system_xbox_statelist[xindex] do
   begin
   connected :=false;
   newdata   :=false;
   end;//with
   end;


//update click idle tracker
if sclicked then low__resetclicktime;

end;

function xbox__state2(xindex:longint;var x:txboxcontrollerinfo):boolean;//xindex=0..3 = max of 4 controllers
begin
xindex:=xbox__index(xindex);
result:=xbox__state(xindex);
x:=system_xbox_statelist[xindex];
end;

function xbox__setstate(xindex:longint):boolean;
var
   s:txinputvibration;
begin
//defaults
result:=false;

//check
if (xindex>=4) then exit;//slot 4 and above are virtual controller slots - 22jul2025

//range
xindex:=xbox__index(xindex);

//retry limit
if (system_xbox_retryref64[xindex]<>0) and (system_xbox_retryref64[xindex]>=ms64) then
   begin
   result:=false;
   exit;
   end;

//init
s.lmotorspeed:=word(frcrange32(round(system_xbox_statelist[xindex].lm*max16),0,max16));
s.rmotorspeed:=word(frcrange32(round(system_xbox_statelist[xindex].rm*max16),0,max16));

//get
if xbox__init and (0=win2____XInputSetState(xindex,@s)) then
   begin
   result:=true;
   system_xbox_retryref64[xindex]:=0;

   with system_xbox_statelist[xindex] do
   begin
   connected:=true;
   end;//with
   end
else
   begin
   result:=false;
   system_xbox_retryref64[xindex]:=ms64+3000;//don't try again for 3s when controller is not connected

   with system_xbox_statelist[xindex] do
   begin
   connected:=false;
   end;//with
   end;
end;

function xbox__setstate2(xindex:longint;lmotorspeed,rmotorspeed:double):boolean;
begin
//range
xindex:=xbox__index(xindex);
system_xbox_statelist[xindex].lm:=fr64(lmotorspeed,0,1);
system_xbox_statelist[xindex].rm:=fr64(rmotorspeed,0,1);
//get
result:=xbox__setstate(xindex);
end;

function xbox__aclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].aclick);
end;

function xbox__bclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].bclick);
end;

function xbox__xclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].xclick);
end;

function xbox__yclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].yclick);
end;

function xbox__uclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].uclick);
end;

function xbox__dclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].dclick);
end;

function xbox__lclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].lclick);
end;

function xbox__rclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].rclick);
end;

function xbox__startclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].startclick);
end;

function xbox__backclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].backclick);
end;

function xbox__ltclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].ltclick);
end;

function xbox__rtclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].rtclick);
end;

function xbox__lbclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].lbclick);
end;

function xbox__rbclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].rbclick);
end;

function xbox__lsclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].lsclick);
end;

function xbox__rsclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].rsclick);
end;

function xbox__lthumbstick_lclick(xindex:longint):boolean;//22jul2025
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].lxyinfo.lclick);
end;

function xbox__lthumbstick_rclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].lxyinfo.rclick);
end;

function xbox__lthumbstick_uclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].lxyinfo.uclick);
end;

function xbox__lthumbstick_dclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].lxyinfo.dclick);
end;

function xbox__rthumbstick_lclick(xindex:longint):boolean;//22jul2025
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].rxyinfo.lclick);
end;

function xbox__rthumbstick_rclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].rxyinfo.rclick);
end;

function xbox__rthumbstick_uclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].rxyinfo.uclick);
end;

function xbox__rthumbstick_dclick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].rxyinfo.dclick);
end;

function xbox__lanyclick(xindex:longint):boolean;//22jul2025
begin
result:=false;
if xbox__lclick(xindex)                                      then result:=true;
if xbox__lthumbstick_lclick(xindex) and xbox__native(xindex) then result:=true;
if xbox__rthumbstick_lclick(xindex) and xbox__native(xindex) then result:=true;
end;

function xbox__ranyclick(xindex:longint):boolean;
begin
result:=false;
if xbox__rclick(xindex)                                      then result:=true;
if xbox__lthumbstick_rclick(xindex) and xbox__native(xindex) then result:=true;
if xbox__rthumbstick_rclick(xindex) and xbox__native(xindex) then result:=true;
end;

function xbox__uanyclick(xindex:longint):boolean;
begin
result:=false;
if xbox__uclick(xindex)                                      then result:=true;
if xbox__lthumbstick_uclick(xindex) and xbox__native(xindex) then result:=true;
if xbox__rthumbstick_uclick(xindex) and xbox__native(xindex) then result:=true;
end;

function xbox__danyclick(xindex:longint):boolean;
begin
result:=false;
if xbox__dclick(xindex)                                      then result:=true;
if xbox__lthumbstick_dclick(xindex) and xbox__native(xindex) then result:=true;
if xbox__rthumbstick_dclick(xindex) and xbox__native(xindex) then result:=true;
end;

function xbox__lanydown(xindex:longint):boolean;
begin
result:=(system_xbox_statelist[xindex].lx<=-xbox_thumbstick_threshold_value) or (system_xbox_statelist[xindex].rx<=-xbox_thumbstick_threshold_value);
end;

function xbox__ranydown(xindex:longint):boolean;
begin
result:=(system_xbox_statelist[xindex].lx>=xbox_thumbstick_threshold_value) or (system_xbox_statelist[xindex].rx>=xbox_thumbstick_threshold_value);
end;

function xbox__uanydown(xindex:longint):boolean;
begin
result:=(system_xbox_statelist[xindex].ly>=xbox_thumbstick_threshold_value) or (system_xbox_statelist[xindex].ry>=xbox_thumbstick_threshold_value);
end;

function xbox__danydown(xindex:longint):boolean;
begin
result:=(system_xbox_statelist[xindex].ly<=-xbox_thumbstick_threshold_value) or (system_xbox_statelist[xindex].ry<=-xbox_thumbstick_threshold_value);
end;

function xbox__lanyautoclick(xindex:longint):boolean;
begin
result:=xbox__autoclicked(xindex,0, xbox__lanydown(xindex) );
end;

function xbox__ranyautoclick(xindex:longint):boolean;
begin
result:=xbox__autoclicked(xindex,1, xbox__ranydown(xindex) );
end;

function xbox__uanyautoclick(xindex:longint):boolean;
begin
result:=xbox__autoclicked(xindex,2, xbox__uanydown(xindex) );
end;

function xbox__danyautoclick(xindex:longint):boolean;
begin
result:=xbox__autoclicked(xindex,3, xbox__danydown(xindex) );
end;

function xbox__autoclicked(xindex,xindex03:longint;xdown:boolean):boolean;
begin

//check
if (xindex=xssMouse) then
   begin
   result:=false;
   exit;
   end;

//range
if (xindex03<0) then xindex03:=0 else if (xindex03>3) then xindex03:=3;

//get
if xdown then
   begin

   if (system_xbox_statelist[xindex].autoclick64[xindex03]=0) then system_xbox_statelist[xindex].autoclick64[xindex03]:=add64(ms64,xbox_autoclick_initialdelay);//initial delay

   result:=(ms64>=system_xbox_statelist[xindex].autoclick64[xindex03]);//auto-clicked

   if result then system_xbox_statelist[xindex].autoclick64[xindex03]:=add64(ms64,xbox_autoclick_repeatdelay);//repeat delay

   end

//reset
else
   begin

   result:=false;

   if (system_xbox_statelist[xindex].autoclick64[xindex03]<>0) then system_xbox_statelist[xindex].autoclick64[xindex03]:=0;

   end;

end;

function xbox__enterClick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].entclick);
end;

function xbox__escClick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].escclick);
end;

function xbox__delClick(xindex:longint):boolean;
begin
result:=xbox__usebool(system_xbox_statelist[xbox__index(xindex)].delclick);
end;

function xbox__showmenu(xindex:longint):boolean;
begin
result:=low__or3( (xbox__startclick(xindex) and xbox__native(xindex)), xbox__escclick(xindex), xbox__startclick(xssMouse) );
end;

//.xbox adjust dead zone -------------------------------------------------------
function xbox__deadzone(x:double):double;
begin
result:=system_xbox_deadzone;
end;

procedure xbox__setdeadzone(x:double);
begin
system_xbox_deadzone:=fr64(x,0,0.5);//0..0.5
end;

//.invert X and Y axis
procedure xbox__invertaxis(var nativex,nativey,keyboardx,keyboardy,mousex,mousey:boolean);
begin

nativex     :=system_xbox_nativecontroller_invertx;
nativey     :=system_xbox_nativecontroller_inverty;

keyboardx   :=system_xbox_keyboard_invertx;
keyboardy   :=system_xbox_keyboard_inverty;

mousex      :=system_xbox_mouse_invertx;
mousey      :=system_xbox_mouse_inverty;

end;

procedure xbox__setinvertaxis(nativex,nativey,keyboardx,keyboardy,mousex,mousey:boolean);
begin

system_xbox_nativecontroller_invertx  :=nativex;
system_xbox_nativecontroller_inverty  :=nativey;

system_xbox_keyboard_invertx          :=keyboardx;
system_xbox_keyboard_inverty          :=keyboardy;

system_xbox_mouse_invertx             :=mousex;
system_xbox_mouse_inverty             :=mousey;

end;


function xbox__invertaxislist:string;//24jul2025
begin

result:=
bolstr(system_xbox_nativecontroller_invertx)+
bolstr(system_xbox_nativecontroller_inverty)+
bolstr(system_xbox_keyboard_invertx)+
bolstr(system_xbox_keyboard_inverty)+
bolstr(system_xbox_mouse_invertx)+
bolstr(system_xbox_mouse_inverty)+
//additional
bolstr(system_xbox_nativecontroller_swapjoysticks)+
bolstr(system_xbox_nativecontroller_swaptriggers)+
bolstr(system_xbox_nativecontroller_swapbumpers)+
bolstr(system_xbox_mouse_swapbuttons);

end;

procedure xbox__setinvertaxislist(x:string);

   function b(xindex:longint):boolean;
   begin
   result:=strbol( strcopy1(x,xindex,1) );
   end;
begin

//init
x:=x+'000000000';

//get
system_xbox_nativecontroller_invertx        :=b(1);
system_xbox_nativecontroller_inverty        :=b(2);
system_xbox_keyboard_invertx                :=b(3);
system_xbox_keyboard_inverty                :=b(4);
system_xbox_mouse_invertx                   :=b(5);
system_xbox_mouse_inverty                   :=b(6);
//additional
system_xbox_nativecontroller_swapjoysticks  :=b(7);
system_xbox_nativecontroller_swaptriggers   :=b(8);
system_xbox_nativecontroller_swapbumpers    :=b(9);
system_xbox_mouse_swapbuttons               :=b(10);//29jul2025

end;

//.xbox support procs ----------------------------------------------------------
function xbox__stateshow(xindex:longint):boolean;//for debugging
var
   x:txboxcontrollerinfo;
   vout:string;

   procedure iadd(n:string;v:longint);
   begin
   vout:=vout+n+': '+k64(v)+rcode;
   end;

   procedure dadd(n:string;v:double);
   begin
   vout:=vout+n+': '+f64(v)+rcode;
   end;

   procedure badd(n:string;v:boolean);
   begin
   vout:=vout+n+': '+bolstr(v)+rcode;
   end;
begin
//range
xindex:=xbox__index(xindex);

//get
result:=xbox__state(xindex);

//set
vout:='';

x:=system_xbox_statelist[xindex];

badd('init',xbox__init);
badd('connected',x.connected);
badd('newdata',result);
iadd('index',x.index);
iadd('packetcount',x.packetcount);
dadd('lt',x.lt);
dadd('rt',x.rt);
dadd('lx',x.lx);
dadd('ly',x.ly);
dadd('rx',x.rx);
dadd('ry',x.ry);

badd('lthumb',x.lb);
badd('rthumb',x.rb);
badd('lshoulder',x.ls);
badd('rshoulder',x.rs);

badd('a',x.a);
badd('b',x.b);
badd('x',x.x);
badd('y',x.y);

badd('start',x.start);
badd('back',x.back);

badd('up',x.u);
badd('down',x.d);
badd('left',x.l);
badd('right',x.r);

//show
showtext(vout);
end;

function xbox__index(x:longint):longint;
begin
result:=frcrange32(x,xssNativeMin,xssMax);//24jul2025
end;

function xbox__usebool(var x:boolean):boolean;
begin
result:=x;
x:=false;
end;

function xbox__lastindex(xallslots:boolean):longint;//24jul2025
begin
if xallslots then result:=xssMax else result:=xssNativeMax;
end;

function xbox__roundtozero(x:double):double;
begin
if (x>=-0.001) and (x<=0.001) then result:=0 else result:=x;
end;

function xbox__native(xindex:longint):boolean;
begin
result:=(xindex>=xssNativeMin) and (xindex<=xssNativeMax);
end;

function xbox__resetClicks:boolean;
var
   p:longint;

   procedure cc(var x:boolean);
   begin
   if x then result:=true;
   x:=false;
   end;

   procedure cv(var x:double);
   begin
   if (x<>0) then result:=true;
   x:=0;
   end;

begin

//defaults
result:=false;

//get
for p:=0 to xssmax do if xbox__state(p) then
   begin

   with system_xbox_statelist[p] do
   begin

   //thumbsticks as clicks
   cc(lxyinfo.lclick);
   cc(lxyinfo.rclick);
   cc(lxyinfo.uclick);
   cc(lxyinfo.dclick);

   cc(rxyinfo.lclick);
   cc(rxyinfo.rclick);
   cc(rxyinfo.uclick);
   cc(rxyinfo.dclick);

   //buttons
   cc(lbclick);
   cc(lb);

   cc(rbclick);
   cc(rb);

   cc(lsclick);
   cc(ls);

   cc(rsclick);
   cc(rs);

   cc(aclick);
   cc(a);

   cc(bclick);
   cc(b);

   cc(xclick);
   cc(x);

   cc(yclick);
   cc(y);

   cc(startclick);

   cc(backclick);

   cc(uclick);
   cc(u);

   cc(dclick);
   cc(d);

   cc(lclick);
   cc(l);

   cc(rclick);
   cc(r);

   cc(entClick);
   cc(escClick);
   cc(delClick);

   //.joysticks - 29jul2025
   cv(lx);
   cv(ly);

   cv(rx);
   cv(ry);

   //.triggers
   cv(lt);
   cv(rt);

   end;//with

   end;//p

end;

procedure xbox__resetClicksAndWait;
var
   a,b:comp;
begin

//init
a  :=ms64+5000;
b  :=ms64+100;

//get
while true do
begin

//.turn off mouse -> results in a faster clickReset
system_xbox_mousetimeref:=0;

if xbox__resetClicks then b:=ms64+300;

if (ms64>=a) or (ms64>=b) then break;

win____sleep(30);
app__processallmessages;

end;//loop

end;

function xbox__idletime:longint;
var
   p:longint;
   xnotidle:boolean;
begin

//get
xnotidle:=false;

for p:=0 to xssmax do if xbox__state(p) then if low__setint(system_xbox_idleref[p],system_xbox_statelist[p].packetcount) then
   begin
   xnotidle:=true;
   end;

//reset -> when not idle
if xnotidle then system_xbox_idletime:=ms64;

//get
result:=frcrange32( round(sub32(ms64,system_xbox_idletime)/1000) ,0,300);//0..300 seconds (5 minutes)

end;


//------------------------------------------------------------------------------
//xbox controller from keyboard and mouse input --------------------------------

function xbox__keyboardkeylabel(xrawkey:longint):string;

   procedure s(x:string);
   begin
   result:=x;
   end;

begin

case xrawkey of
8: s('Backspace');
9: s('Tab');
13: s('Enter');
16: s('Shift');
17: s('Ctrl');
27: s('Esc');
32: s('Space');

37: s('Left');
38: s('Up');
39: s('Right');
40: s('Down');

46: s('Del');

48..57,65..90:s( char(xrawkey) );//0..9 and A..Z
112..123:s('F'+intstr32(xrawkey-111));//F1..F12

188:s('<');
191:s('/');
190:s('>');

219:s('[');
220:s('\');
221:s(']');
else s('');
end;//case

end;

function xbox__rootlabel(xkey_code:longint):string;

   procedure s(x:string);
   begin
   result:=x;
   end;

begin

case xkey_code of

xkey_lbumper:     s('L-bumper');
xkey_rbumper:     s('R-bumper');
xkey_lsbutton:    s('L-stick Button');
xkey_rsbutton:    s('R-stick Button');

xkey_rx_left:     s('R-stick Left');
xkey_rx_right:    s('R-stick Right');
xkey_ry_up:       s('R-stick Up');
xkey_ry_down:     s('R-stick Down');

xkey_lx_left:     s('L-stick Left');
xkey_lx_right:    s('L-stick Right');
xkey_ly_up:       s('L-stick Up');
xkey_ly_down:     s('L-stick Down');

xkey_a_button:    s('A Button');
xkey_b_button:    s('B Button');
xkey_x_button:    s('X Button');
xkey_y_button:    s('Y Button');

xkey_lt      :    s('L-trigger');
xkey_rt      :    s('R-trigger');

xkey_menu    :    s('Menu');

xkey_left:        s('Gamepad Left');
xkey_right:       s('Gamepad Right');
xkey_up:          s('Gamepad Up');
xkey_down:        s('Gamepad Down');

else result:='Not Used';//29jul2025

end;//case

end;

function xbox__keyfilter(xindex:longint):longint;
begin

///invert x-axis
if system_xbox_keyboard_invertx then
   begin

   case xindex of
   xkey_lx_left:   xindex:=xkey_lx_right;
   xkey_lx_right:  xindex:=xkey_lx_left;

   xkey_rx_left:   xindex:=xkey_rx_right;
   xkey_rx_right:  xindex:=xkey_rx_left;
   end;//case

   end;

///invert y-axis
if system_xbox_keyboard_inverty then
   begin

   case xindex of
   xkey_ly_up:     xindex:=xkey_ly_down;
   xkey_ly_down:   xindex:=xkey_ly_up;

   xkey_ry_up:     xindex:=xkey_ry_down;
   xkey_ry_down:   xindex:=xkey_ry_up;
   end;//case

   end;

//get
result:=xindex;

end;

function xbox__keylabel(xindex:longint):string;
begin
result:=xbox__rootlabel( xbox__keyfilter(xindex) );
end;

function xbox__controllerfilter(xindex:longint):longint;
begin

//filter
case xindex of
xkey_lbumper:  if system_xbox_nativecontroller_swapbumpers     then xindex:=xkey_rbumper;
xkey_rbumper:  if system_xbox_nativecontroller_swapbumpers     then xindex:=xkey_lbumper;
xkey_lt:       if system_xbox_nativecontroller_swaptriggers    then xindex:=xkey_rt;
xkey_rt:       if system_xbox_nativecontroller_swaptriggers    then xindex:=xkey_lt;

xkey_lx_left:  if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_rx_left;
xkey_lx_right: if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_rx_right;
xkey_ly_up:    if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_ry_up;
xkey_ly_down:  if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_ry_down;

xkey_rx_left:  if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_lx_left;
xkey_rx_right: if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_lx_right;
xkey_ry_up:    if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_ly_up;
xkey_ry_down:  if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_ly_down;

xkey_lsbutton: if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_rsbutton;
xkey_rsbutton: if system_xbox_nativecontroller_swapjoysticks   then xindex:=xkey_lsbutton;

end;

///invert x-axis
if system_xbox_nativecontroller_invertx then
   begin

   case xindex of
   xkey_lx_left:   xindex:=xkey_lx_right;
   xkey_lx_right:  xindex:=xkey_lx_left;

   xkey_rx_left:   xindex:=xkey_rx_right;
   xkey_rx_right:  xindex:=xkey_rx_left;
   end;//case

   end;

///invert y-axis
if system_xbox_nativecontroller_inverty then
   begin

   case xindex of
   xkey_ly_up:     xindex:=xkey_ly_down;
   xkey_ly_down:   xindex:=xkey_ly_up;

   xkey_ry_up:     xindex:=xkey_ry_down;
   xkey_ry_down:   xindex:=xkey_ry_up;
   end;//case

   end;

//get
result:=xindex;

end;

function xbox__controllerlabel(xindex:longint):string;
begin
result:=xbox__rootlabel( xbox__controllerfilter(xindex) );
end;

function xbox__keymap(xindex:longint):longint;
begin
if (xindex>=0) and (xindex<=xkey_max) then result:=system_xbox_keyboard.keylist[xindex].rawkey else result:=0;
end;

function xbox__keymap2(xindex:longint;var xlabel:string;var xrawkey:longint):boolean;
begin

result:=(xindex>=0) and (xindex<=xkey_max) and (xindex<=xkey_canmap);

if result then
   begin

   xlabel     :=xbox__rootlabel(xindex);
   xrawkey    :=system_xbox_keyboard.keylist[xindex].rawkey;

   end
else
   begin

   xlabel     :='';
   xrawkey    :=0;

   end;

end;

procedure xbox__setkeymap(xindex,xnewkey:longint);
begin
if (xindex>=0) and (xindex<=xkey_max) then system_xbox_keyboard.keylist[xindex].rawkey:=xnewkey;
end;

procedure xbox__keymap__defaults;

   procedure s(xindex,xrawkey:longint);
   begin
   xbox__setkeymap(xindex,xrawkey);
   end;

begin

s(xkey_lbumper   ,188);// "<"
s(xkey_rbumper   ,190);// ">"

s(xkey_lsbutton  ,75);// "K"
s(xkey_rsbutton  ,76);// "L"

s(xkey_rx_left   ,37);
s(xkey_rx_right  ,39);
s(xkey_ry_up     ,38);
s(xkey_ry_down   ,40);

s(xkey_lx_left   ,37);
s(xkey_lx_right  ,39);
s(xkey_ly_up     ,38);
s(xkey_ly_down   ,40);

s(xkey_left      ,37);
s(xkey_right     ,39);
s(xkey_up        ,38);
s(xkey_down      ,40);

s(xkey_a_button  ,65);
s(xkey_b_button  ,66);
s(xkey_x_button  ,88);
s(xkey_y_button  ,89);

s(xkey_menu      ,27);//esc

s(xkey_lt        ,90);// "Z"
s(xkey_rt        ,67);// "C"

end;

function xbox__inputlabel(xindex:longint):string;
begin
if (xindex>=0) and (xindex<=xkey_max) then result:=system_xbox_input_labels[xindex] else result:='';
end;

procedure xbox__setinputlabel(xindex:longint;const xlabel:string);
begin

if (xindex>=0) and (xindex<=xkey_max) then
   begin

   system_xbox_input_labels[xindex]   :=xlabel;
   system_xbox_input_allowed[xindex]  :=(system_xbox_input_labels[xindex]<>'');

   end;

end;

function xbox__lastrawkey:longint;
begin
result:=system_xbox_lastrawkey;
end;

function xbox__lastrawkeycount(xreset:boolean):longint;
begin
if xreset then system_xbox_lastrawkeycount:=0;
result:=system_xbox_lastrawkeycount;
end;

procedure xbox__lockkeyboard;
begin
inc(system_xbox_lockkeyboard_count);
end;

procedure xbox__unlockkeyboard;
begin
system_xbox_lockkeyboard_count:=frcmin32(system_xbox_lockkeyboard_count-1,0);
end;

function xbox__keyboardlocked:boolean;
begin
result:=(system_xbox_lockkeyboard_count<>0);
end;

procedure xbox__keyrawinput(xrawkey:longint;xdown:boolean);//uses slot4
label
   skipend;
var
   p:longint;
   xchanged:boolean;

   function xchange:boolean;
   begin
   result    :=true;
   xchanged  :=true;
   end;
begin

//init
xchanged:=false;

//ok
case (system_xbox_lastrawkey=xrawkey) of
true:if (system_xbox_lastrawkeycount<max32) then inc(system_xbox_lastrawkeycount);
else system_xbox_lastrawkeycount:=1;
end;

//store last rawkey value regardless of slot status
system_xbox_lastrawkey:=xrawkey;

//check
if not system_xbox_init then exit;

//remove retry delay
if (system_xbox_retryref64[xssKeyboard]<>0) then system_xbox_retryref64[xssKeyboard]:=0;

//special extended keyboard support
if not xdown then
   begin

   case xrawkey of
   13:   system_xbox_keyboard.enter :=xchange;
   27:   system_xbox_keyboard.esc   :=xchange;
   8,46: system_xbox_keyboard.del   :=xchange;
   end;//caswe

   end;

//keyboard is locked -> don't process dynamic data below, static above is OK - 22jul2025
if (system_xbox_lockkeyboard_count<>0) then goto skipend;

//get
for p:=0 to xkey_max do if (system_xbox_suspend_all_inversions or system_xbox_input_allowed[p]) and (xrawkey=system_xbox_keyboard.keylist[p].rawkey) then
   begin

   if xdown and (not system_xbox_keyboard.keylist[p].down) then system_xbox_keyboard.keylist[p].downonce:=true;

   system_xbox_keyboard.keylist[p].down   :=xdown;
   xchanged                               :=true;

   end;//p


skipend:

//increment packet counter
if xchanged then low__irollone(system_xbox_keyboard.xinput.dwPacketNumber);

end;

function xbox__keyslot_getstate(xinputstate:pxinputstate):boolean;
var
   lt,rt,lx,ly,rx,ry:double;
   b4:longint;
   xdownonce:boolean;

   function xdown(xindex:longint):boolean;
   begin
   result     :=system_xbox_keyboard.keylist[xindex].down;
   xdownonce  :=system_xbox_keyboard.keylist[xindex].downonce;

   //reset
   system_xbox_keyboard.keylist[xindex].downonce:=false;
   end;

   procedure addbut(xbutcode:longint);
   begin
   bit__addval32(b4,xbutcode);
   end;

   function s16(x:longint):word;
   begin
   result:=frcrange32(x,0,max16);
   end;

   function s32(x:double):smallint;
   begin
   result:=frcrange32( round(x) ,-32767,32767);
   end;

   function s255(x:double):byte;
   begin
   result:=frcrange32( round(x) ,0,255);
   end;

   procedure dadd(var xval:double;xpositive:boolean);
   begin
   xval:=frcrangeD64( xbox__roundtozero(xval + ( sign32(xpositive) * 0.5 ) ),-1,1);
   end;
begin
//defaults
result:=system_xbox_init and (system_xbox_keyboard.xinput.dwPacketNumber>=1);

//check
if not result then exit;

//init
lx:=frcrangeD64(system_xbox_keyboard.xinput.dGamepad.sThumbLX/32768,-1,1);
ly:=frcrangeD64(system_xbox_keyboard.xinput.dGamepad.sThumbLY/32768,-1,1);

rx:=frcrangeD64(system_xbox_keyboard.xinput.dGamepad.sThumbRX/32768,-1,1);
ry:=frcrangeD64(system_xbox_keyboard.xinput.dGamepad.sThumbRY/32768,-1,1);

lt:=frcrangeD64(system_xbox_keyboard.xinput.dGamepad.bleftTrigger/255,0,1);
rt:=frcrangeD64(system_xbox_keyboard.xinput.dGamepad.brightTrigger/255,0,1);

b4:=system_xbox_keyboard.xinput.dGamepad.wbuttons;


//right joystick ---------------------------------------------------------------

//x
if      xdown(xkey_rx_left)  then dadd(rx,false)
else if xdown(xkey_rx_right) then dadd(rx,true)
else                              rx:=0;

//y
if      xdown(xkey_ry_up)   then dadd(ry,true)
else if xdown(xkey_ry_down) then dadd(ry,false)
else                             ry:=0;


//left joystick ----------------------------------------------------------------

//x
if      xdown(xkey_lx_left)  then dadd(lx,false)
else if xdown(xkey_lx_right) then dadd(lx,true)
else                              lx:=0;

//y
if      xdown(xkey_ly_up)    then dadd(ly,true)
else if xdown(xkey_ly_down)  then dadd(ly,false)
else                              ly:=0;


//game pad ---------------------------------------------------------------------
if xdown(xkey_left)  then addbut(XINPUT_GAMEPAD_DPAD_Left);
if xdown(xkey_right) then addbut(XINPUT_GAMEPAD_DPAD_Right);
if xdown(xkey_up)    then addbut(XINPUT_GAMEPAD_DPAD_Up);
if xdown(xkey_down)  then addbut(XINPUT_GAMEPAD_DPAD_Down);


//left + right triggers --------------------------------------------------------
if xdown(xkey_lt)   then dadd(lt,true) else lt:=0;
if xdown(xkey_rt)   then dadd(rt,true) else rt:=0;


//ABXY+ buttons -----------------------------------------------------------------
if xdown(xkey_a_button) then addbut(XINPUT_GAMEPAD_A);
if xdown(xkey_b_button) then addbut(XINPUT_GAMEPAD_B);
if xdown(xkey_x_button) then addbut(XINPUT_GAMEPAD_X);
if xdown(xkey_y_button) then addbut(XINPUT_GAMEPAD_Y);
if xdown(xkey_lbumper)  then addbut(XINPUT_GAMEPAD_LEFT_SHOULDER);
if xdown(xkey_rbumper)  then addbut(XINPUT_GAMEPAD_RIGHT_SHOULDER);
if xdown(xkey_lsbutton) then addbut(XINPUT_GAMEPAD_LEFT_THUMB);
if xdown(xkey_rsbutton) then addbut(XINPUT_GAMEPAD_RIGHT_THUMB);
if xdown(xkey_menu)     then addbut(XINPUT_GAMEPAD_START);

//set
system_xbox_keyboard.xinput.dGamepad.sThumbLX:=s32( lx*32767 );
system_xbox_keyboard.xinput.dGamepad.sThumbLY:=s32( ly*32767 );

system_xbox_keyboard.xinput.dGamepad.sThumbRX:=s32( rx*32767 );
system_xbox_keyboard.xinput.dGamepad.sThumbRY:=s32( ry*32767 );

system_xbox_keyboard.xinput.dGamepad.bleftTrigger  :=s255( lt*255 );
system_xbox_keyboard.xinput.dGamepad.brightTrigger :=s255( rt*255 );

system_xbox_keyboard.xinput.dGamepad.wbuttons      :=s16(b4);


//return data to caller
xinputstate^:=system_xbox_keyboard.xinput;


//reset
system_xbox_keyboard.xinput.dGamepad.wbuttons:=0;

end;

function xbox__keymappings:string;
var
   p:longint;
begin

result:='';
for p:=0 to frcmax32(xkey_canmap,high(system_xbox_keyboard.keylist)) do result:=result+intstr32(system_xbox_keyboard.keylist[p].rawkey)+',';

end;

procedure xbox__setkeymappings(const x:string);
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
   if (dcount<=xkey_canmap) then system_xbox_keyboard.keylist[dcount].rawkey:=strint32(v);

   inc(dcount);
   if (dcount>high(system_xbox_keyboard.keylist)) then break;

   end;//p

end;


//mouse support - slot 5 -------------------------------------------------------
procedure xbox__mouseslot_reset;
begin

//check
if not system_xbox_init then exit;

//joy sticks
system_xbox_mouse.xinput.dGamepad.sThumbLX:=0;
system_xbox_mouse.xinput.dGamepad.sThumbLY:=0;
system_xbox_mouse.xinput.dGamepad.sThumbRX:=0;
system_xbox_mouse.xinput.dGamepad.sThumbRY:=0;

//triggers
system_xbox_mouse.xinput.dGamepad.bleftTrigger :=0;
system_xbox_mouse.xinput.dGamepad.brightTrigger:=0;

//buttons
system_xbox_mouse.xinput.dGamepad.wbuttons:=0;

end;

procedure xbox__mouserawinput(sender:tobject;xmode,xbuttonstyle,dx,dy,dw,dh:longint);//uses slot #5
var
   w32,ax,ay:longint;
begin

//check
if not system_xbox_init then exit;


//remove retry delay
if (system_xbox_retryref64[xssMouse]<>0) then system_xbox_retryref64[xssMouse]:=0;


//init
dw     :=frcmin32(dw,4);
dh     :=frcmin32(dh,4);
dx     :=frcrange32((dx div 10)*10,0,dw-1);
dy     :=frcrange32((dy div 10)*10,0,dh-1);

ax     :=frcrange32( round(frcranged64(( dx - (dw div 2) ) / (dw div 2),-1,1)*32767) ,-32767,+32767);
ay     :=frcrange32( round(frcranged64(( dy - (dh div 2) ) / (dh div 2),-1,1)*32767) ,-32767,+32767);


//left joy stick
system_xbox_mouse.xinput.dGamepad.sThumbLX:=ax;
system_xbox_mouse.xinput.dGamepad.sThumbLY:=-ay;

//right joy stick
system_xbox_mouse.xinput.dGamepad.sThumbRX:=ax;
system_xbox_mouse.xinput.dGamepad.sThumbRY:=-ay;

//mouse buttons as left/right triggers
w32:=system_xbox_mouse.xinput.dGamepad.wbuttons;

case xbuttonstyle of
abLeft:begin

   case xmode of
   0:system_xbox_mouse.xinput.dGamepad.bleftTrigger:=255;//down
   2:system_xbox_mouse.xinput.dGamepad.bleftTrigger:=0;//up
   end;//case

   end;

abCenter:begin

   case xmode of
   0:bit__addval32(w32,XINPUT_GAMEPAD_START);
   2:bit__remval32(w32,XINPUT_GAMEPAD_START);
   end;

   end;

abRight:begin

   case xmode of
   0:system_xbox_mouse.xinput.dGamepad.brightTrigger:=255;//down
   2:system_xbox_mouse.xinput.dGamepad.brightTrigger:=0;//up
   end;//case

   end;
end;//case


//set
system_xbox_mouse.xinput.dGamepad.wbuttons:=w32;


//increment packet counter
if low__setstr(system_xbox_mouseref,intstr32(w32)+'|'+intstr32(xbuttonstyle)+'|'+intstr32(xmode)+'|'+intstr32(ax)+'|'+intstr32(ay)) then
   begin

   low__irollone(system_xbox_mouse.xinput.dwPacketNumber);
   system_xbox_mousetimeref :=ms64 + 5000;

   end;

end;

function xbox__mouseslot_getstate(xinputstate:pxinputstate):boolean;
begin
//defaults
result:=system_xbox_init and (system_xbox_mouse.xinput.dwPacketNumber>=1);

//check
if not result then exit;

//reset
if (ms64>=system_xbox_mousetimeref) then
   begin

   xbox__mouseslot_reset;
   system_xbox_mousetimeref:=ms64+500;

   end;

//return data to caller
xinputstate^:=system_xbox_mouse.xinput;

end;

function xbox__mouselabel(xkey_code:longint):string;

   procedure s(x:string);
   begin
   result:=x;
   end;

begin

case xkey_code of
xkey_rx_left:     s('Move Left');
xkey_rx_right:    s('Move Right');
xkey_ry_up:       s('Move Up');
xkey_ry_down:     s('Move Down');

xkey_lx_left:     s('Move Left');
xkey_lx_right:    s('Move Right');
xkey_ly_up:       s('Move Up');
xkey_ly_down:     s('Move Down');

xkey_lt      :    s('L-trigger');
xkey_rt      :    s('R-trigger');

xkey_menu    :    s('Menu');

-1           :    s('Not used');
else              s('N/A'+insstr(#32+intstr32(xkey_code),xkey_code>=0) );//10aug2025

end;//case

end;


end.

