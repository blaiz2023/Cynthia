unit gosswin;

interface
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
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
//## Library.................. 32bit Windows api's (gosswin.pas)
//## Version.................. 4.00.070 (+0)
//## Items.................... 1
//## Last Updated ............ 04may2025, 17feb2024
//## Lines of Code............ 400+
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
//## | xbox__*                | Xbox Controller   | 1.00.120  | 25jan2025   | Xbox Controller support with ease-of-access support, complete with persistent button clicks and variable inputs/outputs scaled to floats between 0..1 and -1..1
//## | win____*               | Win32 general     | 1.00.352  | 29apr2025   | Win32 general api procs for Windows specific features and functionality.  The leading "win____" denotes a Window's API call - 01dec2024, 26nov2024, 04mar2024
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

   //DIB color table identifiers
   DIB_RGB_COLORS = 0;//color table in RGBs
   DIB_PAL_COLORS = 1;//color table in palette indices

type
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

   txinputgetstate=function(dwUserIndex03:dword;xinputstate:pxinputstate):tbasic_lresult stdcall;
   txinputsetstate=function(dwUserIndex03:dword;xinputvibration:pxinputvibration):tbasic_lresult stdcall;

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
      //.dpad
      uclick:boolean;
      dclick:boolean;
      lclick:boolean;
      rclick:boolean;
      //vibration
      lm:double;//0..1
      rm:double;//0..1
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

   TEnumDisplayDevicesA=function(lpDeivce:lpcstr;iDevNum:dword;lpDisplayDevice:pdisplaydevicea;dwFlags:dword):lresult stdcall;

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

   TGetMonitorInfoA=function(Monitor:hmonitor;lpMonitorInfo:pmonitorinfo):lresult stdcall;

   PMonitorenumproc=^TMonitorenumproc;
   TMonitorenumproc=function (unnamedParam1:HMONITOR;unnamedParam2:HDC;unnamedParam3:pwinrect;unnamedParam4:LPARAM):lresult stdcall;

   TEnumDisplayMonitors=function(dc:hdc;lpcrect:pwinrect;userProc:PMonitorenumproc;dwData:lparam):lresult stdcall;

   TGetDpiForMonitor=function(monitor:hmonitor;dpiType:longint;var dpiX,dpiY:uint):lresult stdcall;

   TGetScaleFactorForMonitor=function(monitor:hmonitor;var pScale:dword):lresult stdcall;

   TSetLayeredWindowAttributes=function(winHandle:hwnd;color:dword;bAplha:byte;dwFlags:dword):lresult stdcall;

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

const
   advapi32  = 'advapi32.dll';
   kernel32  = 'kernel32.dll';
   user32    = 'user32.dll';
   mpr       = 'mpr.dll';
   version   = 'version.dll';
   comctl32  = 'comctl32.dll';
   gdi32     = 'gdi32.dll';
   opengl32  = 'opengl32.dll';
   wintrust  = 'wintrust.dll';
   shell32   = 'shell32.dll';
   ole32     = 'ole32.dll';
   oleaut32  = 'oleaut32.dll';
   olepro32  = 'olepro32.dll';
   mmsyst    = 'winmm.dll';
   winsocket = 'wsock32.dll';
   winspl    = 'winspool.drv';

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
   CF_PNG           =49447;
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
   WM_CLOSE             = $0010;
   WM_QUERYENDSESSION   = $0011;
   WM_QUIT              = $0012;
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
   MM_WOM_DONE         = $3BD;
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



   TFNHookProc = function (code: Integer; wparam: WPARAM; lparam: LPARAM): LRESULT stdcall;
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
    dwReserved: array[0..7] of DWORD; { Reserved for MMSYSTEM }
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

type
   tdwin____GetDefaultPrinter      =function(xbuffer:pointer;var xsize:longint):bool; stdcall;
   tdwin____EnumPrinters           =function(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL; stdcall;

var
   //.started
   system_started      :boolean=false;

   //.xbox controller support - 25jan2025 --------------------------------------
   system_xbox_init                           :boolean=false;
   system_xbox_getstate                       :txinputgetstate=nil;
   system_xbox_setstate                       :txinputsetstate=nil;
   system_xbox_deadzone                       :double=0.1;//0..1 => 0.1=10%
   system_xbox_retryref64                     :array[0..3] of comp;
   system_xbox_statelist                      :array[-1..3] of txboxcontrollerinfo;//friendly version => [-1] reserved for xbox__info() for returning a blank/uninitiated data structure
   system_xbox_setstatelist                   :array[0..3] of txinputvibration;


   //.dynamic support (dll) ----------------------------------------------------
   dwin____GetDefaultPrinter_state            :longint=0;
   dwin____GetDefaultPrinter_proc             :tdwin____GetDefaultPrinter=nil;

   dwin____EnumPrinters_state                 :longint=0;
   dwin____EnumPrinters_proc                  :tdwin____EnumPrinters=nil;


//Windows procs ----------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxx//111111111111111111111111
//.API calls preappended with "win____" to easily spot them in code -> they are independant of Delphi and Lazarus
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
//was: function win____GetDefaultPrinter(xbuffer:pointer;var xsize:longint):bool; stdcall; external winspl name 'GetDefaultPrinterA';
function dwin____GetDefaultPrinter(xbuffer:pointer;var xsize:longint):bool;
function win____GetVersionEx(var lpVersionInformation: TOSVersionInfo): BOOL; stdcall; external kernel32 name 'GetVersionExA';
//was: function win____EnumPrinters(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL; stdcall; external winspl name 'EnumPrintersA';
function dwin____EnumPrinters(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
function win____CreateIC(lpszDriver, lpszDevice, lpszOutput: PChar; lpdvmInit: PDeviceModeA): HDC; stdcall; external gdi32 name 'CreateICA';
function win____GetProfileString(lpAppName, lpKeyName, lpDefault: PChar; lpReturnedString: PChar; nSize: DWORD): DWORD; stdcall; external kernel32 name 'GetProfileStringA';
function win____GetDC(hWnd: HWND): HDC; stdcall; external user32 name 'GetDC';
function win____GetVersion: DWORD; stdcall; external kernel32 name 'GetVersion';
function win____MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer; stdcall; external user32 name 'MessageBoxA';
function win____EnumFonts(DC: HDC; lpszFace: PChar; fntenmprc: TFarProc; lpszData: PChar): Integer; stdcall; external gdi32 name 'EnumFontsA';
function win____EnumFontFamiliesEx(DC: HDC; var p2: TLogFont; p3: TFarProc; p4: LPARAM; p5: DWORD): BOOL; stdcall; external gdi32 name 'EnumFontFamiliesExA';
function win____GetStockObject(Index: Integer): HGDIOBJ; stdcall; external gdi32 name 'GetStockObject';
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
function win____CoInitialize(pvReserved: Pointer): HResult; stdcall; external ole32 name 'CoInitialize';
procedure win____CoUninitialize; stdcall; external ole32 name 'CoUninitialize';
function win____EnumDisplaySettingsA(lpszDeviceName: PAnsiChar; iModeNum: DWORD; var lpDevMode: TDeviceModeA): BOOL; stdcall; external user32 name 'EnumDisplaySettingsA';
function win____CreateDC(lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA): HDC; stdcall; external gdi32 name 'CreateDCA';
function win____DeleteDC(DC: HDC): BOOL; stdcall; external gdi32 name 'DeleteDC';
function win____GetDeviceCaps(DC: HDC; Index: Integer): Integer; stdcall; external gdi32 name 'GetDeviceCaps';
function win____LoadLibraryA(lpLibFileName: PAnsiChar): HMODULE; stdcall; external kernel32 name 'LoadLibraryA';
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
function win____HeapCreate(flOptions, dwInitialSize, dwMaximumSize: DWORD): THandle; stdcall; external kernel32 name 'HeapCreate';
function win____HeapDestroy(hHeap: THandle): BOOL; stdcall; external kernel32 name 'HeapDestroy';
function win____HeapAlloc(hHeap: THandle; dwFlags, dwBytes: DWORD): Pointer; stdcall; external kernel32 name 'HeapAlloc';
function win____HeapReAlloc(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD): Pointer; stdcall; external kernel32 name 'HeapReAlloc';
function win____HeapFree(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL; stdcall; external kernel32 name 'HeapFree';
function win____GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall; external kernel32 name 'GetProcAddress';
function win____GetProcessHeap: THandle; stdcall; external kernel32 name 'GetProcessHeap';
function win____SetPriorityClass(hProcess: THandle; dwPriorityClass: DWORD): BOOL; stdcall; external kernel32 name 'SetPriorityClass';
function win____GetPriorityClass(hProcess: THandle): DWORD; stdcall; external kernel32 name 'GetPriorityClass';
function win____SetThreadPriority(hThread: THandle; nPriority: Integer): BOOL; stdcall; external kernel32 name 'SetThreadPriority';
function win____SetThreadPriorityBoost(hThread: THandle; DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'SetThreadPriorityBoost';
function win____GetThreadPriority(hThread: THandle): Integer; stdcall; external kernel32 name 'GetThreadPriority';
function win____GetThreadPriorityBoost(hThread: THandle; var DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'GetThreadPriorityBoost';
function win____CreateThread(lpThreadAttributes: Pointer; dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle; stdcall; external kernel32 name 'CreateThread';
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

function win____GetVolumeInformation(lpRootPathName: PChar;
  lpVolumeNameBuffer: PChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD;
  var lpMaximumComponentLength, lpFileSystemFlags: DWORD;
  lpFileSystemNameBuffer: PChar; nFileSystemNameSize: DWORD): BOOL; stdcall; external kernel32 name 'GetVolumeInformationA';

function win____GetShortPathName(lpszLongPath: PChar; lpszShortPath: PChar; cchBuffer: DWORD): DWORD; stdcall; external kernel32 name 'GetShortPathNameA';

function win____SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer; var ppidl: PItemIDList): HResult; stdcall; external shell32 name 'SHGetSpecialFolderLocation';
function win____SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall; external shell32 name 'SHGetPathFromIDListA';
function win____GetWindowsDirectoryA(lpBuffer: PAnsiChar; uSize: UINT): UINT; stdcall; external kernel32 name 'GetWindowsDirectoryA';
function win____GetSystemDirectoryA(lpBuffer: PAnsiChar; uSize: UINT): UINT; stdcall; external kernel32 name 'GetSystemDirectoryA';
function win____GetTempPathA(nBufferLength: DWORD; lpBuffer: PAnsiChar): DWORD; stdcall; external kernel32 name 'GetTempPathA';
function win____FlushFileBuffers(hFile: THandle): BOOL; stdcall; external kernel32 name 'FlushFileBuffers';
function win____CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: Integer;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall; external kernel32 name 'CreateFileA';
function win____GetFileSize(hFile: THandle; lpFileSizeHigh: Pointer): DWORD; stdcall; external kernel32 name 'GetFileSize';
procedure win____GetSystemTime(var lpSystemTime: TSystemTime); stdcall; external kernel32 name 'GetSystemTime';
function win____CloseHandle(hObject: THandle): BOOL; stdcall; external kernel32 name 'CloseHandle';
function win____GetFileInformationByHandle(hFile: THandle; var lpFileInformation: TByHandleFileInformation): BOOL; stdcall; external kernel32 name 'GetFileInformationByHandle';
function win____SetFilePointer(hFile: THandle; lDistanceToMove: Longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall; external kernel32 name 'SetFilePointer';
function win____WriteFile(hFile: THandle; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external kernel32 name 'WriteFile';
function win____ReadFile(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external kernel32 name 'ReadFile';
function win____GetLogicalDrives: DWORD; stdcall; external kernel32 name 'GetLogicalDrives';
function win____FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL; stdcall; external kernel32 name 'FileTimeToLocalFileTime';
function win____FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL; stdcall; external kernel32 name 'FileTimeToDosDateTime';
function win____DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'DefWindowProcA';
function win____RegisterClass(const lpWndClass: TWndClass): ATOM; stdcall; external user32 name 'RegisterClassA';
function win____RegisterClassA(const lpWndClass: TWndClassA): ATOM; stdcall; external user32 name 'RegisterClassA';
function win____CreateWindow(lpClassName: PChar; lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
function win____CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar; lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall; external user32 name 'CreateWindowExA';
function win____ShellExecute(hWnd: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST; stdcall; external shell32 name 'ShellExecuteA';
function win____ShellExecuteEx(lpExecInfo: PShellExecuteInfo):BOOL; stdcall; external shell32 name 'ShellExecuteExA';

function win____SHGetMalloc(var ppMalloc: imalloc): HResult; stdcall; external shell32 name 'SHGetMalloc';
function win____CreateComObject(const ClassID: TGUID): IUnknown;
procedure win____OleError(ErrorCode: HResult);
procedure win____OleCheck(Result: HResult);
function win____CoCreateInstance(const clsid: TCLSID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TIID; out pv): HResult; stdcall; external ole32 name 'CoCreateInstance';
function win____TrimPunctuation(const S: string): string;
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

//.support
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
function net____send2(s:tsocket;var buf;len,flags:longint;var xsent:longint):boolean;
function net____getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;                     stdcall;external winsocket name 'getpeername';
function net____connect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer;                             stdcall;external winsocket name 'connect';
function net____ioctlsocket(s: TSocket; cmd: Longint; var arg: u_long): Integer;                                 stdcall;external winsocket name 'ioctlsocket';

//file
function win__FindMatchingFile(var F: TSearchRec): Integer;
function win__FindFirst(const Path: string; Attr: longint; var F: TSearchRec): longint;
function win__FindNext(var F: TSearchRec): longint;//28jan2024
procedure win__FindClose(var F: TSearchRec);
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
function win____midiOutGetDevCaps(uDeviceID: UINT; lpCaps: PMidiOutCaps; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutGetDevCapsA';
function win____midiOutOpen(lphMidiOut: PHMIDIOUT; uDeviceID: UINT; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutOpen';
function win____midiOutClose(hMidiOut: HMIDIOUT): MMRESULT; stdcall; external mmsyst name 'midiOutClose';
function win____midiOutShortMsg(hMidiOut: HMIDIOUT; dwMsg: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutShortMsg';
function win____midiOutReset(hMidiOut: HMIDIOUT): MMRESULT; stdcall; external mmsyst name 'midiOutReset';//for midi streams only? -> hence the "no effect" for volume reset between songs - 15apr2021
//function midiOutPrepareHeader(hMidiOut: HMIDIOUT; lpMidiOutHdr: PMidiHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutPrepareHeader';
//function midiOutUnprepareHeader(hMidiOut: HMIDIOUT; lpMidiOutHdr: PMidiHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutUnprepareHeader';
//function midiOutLongMsg(hMidiOut: HMIDIOUT; lpMidiOutHdr: PMidiHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutLongMsg';
//.mci
function win____mciSendCommand(mciId:MCIDEVICEID;uMessage:UINT;dwParam1,dwParam2:DWORD):MCIERROR; stdcall; external 'winmm.dll' name 'mciSendCommandA';
function win____mciGetErrorString(mcierr: MCIERROR; pszText: PChar; uLength: UINT): BOOL; stdcall; external 'winmm.dll' name 'mciGetErrorStringA';

//.mixer - volumes
function win____waveOutGetVolume(hwo: longint; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'waveOutGetVolume';
function win____waveOutSetVolume(hwo: longint; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'waveOutSetVolume';
function win____midiOutGetVolume(hmo: longint; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'midiOutGetVolume';
function win____midiOutSetVolume(hmo: longint; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutSetVolume';
function win____auxSetVolume(uDeviceID: UINT; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'auxSetVolume';
function win____auxGetVolume(uDeviceID: UINT; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'auxGetVolume';

{$endif}
//sound procs - end ------------------------------------------------------------


//console
function low__console(n:string;var v1,v2:longint):boolean;
function low__consoleb(n:string;v1,v2:longint):boolean;
function low__consolekey(xstdin:thandle):char;
function low__stdin:thandle;
function low__stdout:thandle;
function low__handleok(x:thandle):boolean;
procedure low__handlenone(var x:thandle);


//xxxxxxxxxxxxxxxxxxxxxxxx//7777777777777777777777



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
function xbox__state(xindex:longint):boolean;//xindex=0..3 = max of 4 controllers
function xbox__state2(xindex:longint;var x:txboxcontrollerinfo):boolean;//xindex=0..3 = max of 4 controllers
function xbox__setstate(xindex:longint):boolean;
function xbox__setstate2(xindex:longint;lmotorspeed,rmotorspeed:double):boolean;//0..1 for each left and right motors
function xbox__lastindex:longint;
//.adjust deadzone
function xbox__deadzone(x:double):double;
procedure xbox__setdeadzone(x:double);
//.support
function xbox__usebool(var x:boolean):boolean;
function xbox__index(x:longint):longint;
function xbox__stateshow(xindex:longint):boolean;//for debugging
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


implementation

uses gossroot, gossio;


//start-stop procs -------------------------------------------------------------
procedure gosswin__start;
begin
try
//check
if system_started then exit else system_started:=true;

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
if      (xname='ver')        then result:='4.00.978'
else if (xname='date')       then result:='09jun2025'
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


//dynamic support for external libraries ---------------------------------------
function dll__loaded(var xstateval:longint;const xlibname,xprocname:string;var xprocaddr:pointer):boolean;
var
   a:hmodule;
begin
//defaults
result:=false;

try
//load lib and load proc
if (xstateval=0) then
   begin
   if (xlibname='') or (xprocname='') then xstateval:=2//error
   else
      begin
      //load library
      a:=win____LoadLibraryA(pchar(xlibname));

      if (a=0) then xstateval:=2//error
      else
         begin
         //load proc
         xprocaddr:=win____GetProcAddress(a,pansichar(xprocname));

         case assigned(xprocaddr) of
         true:xstateval:=1;//successful
         else xstateval:=2//error
         end;//case

         end;
      end;
   end;

//return result
result:=(xstateval=1);
except;end;
end;


function dwin____GetDefaultPrinter(xbuffer:pointer;var xsize:longint):bool;//13may2025
begin
case dll__loaded(dwin____GetDefaultPrinter_state,winspl,'GetDefaultPrinterA',@dwin____GetDefaultPrinter_proc) of
true:result:=dwin____GetDefaultPrinter_proc(xbuffer,xsize);
else result:=false;
end;//case
end;

function dwin____EnumPrinters(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;//13may2025
begin
case dll__loaded(dwin____EnumPrinters_state,winspl,'EnumPrintersA',@dwin____EnumPrinters_proc) of
true:result:=dwin____EnumPrinters_proc(Flags,Name,Level,pPrinterEnum,cbBuf,pcbNeeded,pcReturned);
else result:=false;
end;//case
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
   a:hmodule;
   p:longint;
begin
//init
if not system_xbox_init then
   begin
   //do once only
   system_xbox_init:=true;

   {$ifdef gui}

   //cls system vars
   for p:=0 to high(system_xbox_retryref64) do
   begin
   low__cls(@system_xbox_statelist[p],sizeof(system_xbox_statelist[p]));
   low__cls(@system_xbox_setstatelist[p],sizeof(system_xbox_setstatelist[p]));

   system_xbox_retryref64[p]      :=0;
   system_xbox_statelist[p].index :=p;
   end;//p

   //connect to dll
   try
   a:=win____LoadLibraryA(pchar('xinput1_4.dll'));
   if (a<>0) then
      begin
      system_xbox_getstate:=win____GetProcAddress(a,PAnsiChar('XInputGetState'));
      system_xbox_setstate:=win____GetProcAddress(a,PAnsiChar('XInputSetState'));
      end;
   except;end;

   {$endif}
   end;

//get
result:=assigned(system_xbox_getstate) and assigned(system_xbox_setstate);
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

function xbox__state(xindex:longint):boolean;//xindex=0..3 = max of 4 controllers, return=true=connected and we might have new data, check "xbox__info[].newdata"
var
   s:txinputstate;
   w:word;
   sclicked,bol1:boolean;

   function dz(x:double):double;
   begin
   if (x<-system_xbox_deadzone) or (x>system_xbox_deadzone) then result:=x else result:=0;
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
begin
//range
xindex:=xbox__index(xindex);

//init
system_xbox_statelist[xindex].index:=xindex;
sclicked:=false;

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
if xbox__init and (0=system_xbox_getstate(xindex,@s)) then
   begin
   result:=true;
   system_xbox_retryref64[xindex]:=0;//disable retry limit (delay)


   with system_xbox_statelist[xindex] do
   begin
   connected    :=true;
   newdata      :=(packetcount<>s.dwPacketNumber);
   packetcount  :=s.dwPacketnumber;

   bol1         :=(lt<>0);
   lt           :=dz(fr64(s.dGamepad.bleftTrigger/255,0,1));
   if (lt<>0) and (not bol1) then ltclick:=true;

   bol1         :=(rt<>0);
   rt           :=dz(fr64(s.dGamepad.brightTrigger/255,0,1));
   if (rt<>0) and (not bol1) then rtclick:=true;

   lx           :=dz(fr64(s.dGamepad.sThumbLX/32768,-1,1));
   ly           :=dz(fr64(s.dGamepad.sThumbLY/32768,-1,1));
   rx           :=dz(fr64(s.dGamepad.sThumbRX/32768,-1,1));
   ry           :=dz(fr64(s.dGamepad.sThumbRY/32768,-1,1));

   //buttons
   w            :=s.dGamepad.wbuttons;

   sclick(lb,lbclick,XINPUT_GAMEPAD_LEFT_THUMB);
   sclick(rb,rbclick,XINPUT_GAMEPAD_RIGHT_THUMB);

   sclick(ls,lsclick,XINPUT_GAMEPAD_LEFT_SHOULDER);
   sclick(rs,rsclick,XINPUT_GAMEPAD_RIGHT_SHOULDER);

   sclick(a,aclick,XINPUT_GAMEPAD_A);
   sclick(b,bclick,XINPUT_GAMEPAD_B);
   sclick(x,xclick,XINPUT_GAMEPAD_X);
   sclick(y,yclick,XINPUT_GAMEPAD_Y);

   sclick(start,startclick,XINPUT_GAMEPAD_START);
   sclick(back,backclick,XINPUT_GAMEPAD_BACK);

   sclick(u,uclick,XINPUT_GAMEPAD_DPAD_UP);
   sclick(d,dclick,XINPUT_GAMEPAD_DPAD_DOWN);
   sclick(l,lclick,XINPUT_GAMEPAD_DPAD_LEFT);
   sclick(r,rclick,XINPUT_GAMEPAD_DPAD_RIGHT);
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
if xbox__init and (0=system_xbox_setstate(xindex,@s)) then
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

//.xbox adjust dead zone -------------------------------------------------------
function xbox__deadzone(x:double):double;
begin
result:=system_xbox_deadzone;
end;

procedure xbox__setdeadzone(x:double);
begin
system_xbox_deadzone:=fr64(x,0,0.5);//0..0.5
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
result:=frcrange32(x,0,high(system_xbox_retryref64));
end;

function xbox__usebool(var x:boolean):boolean;
begin
result:=x;
x:=false;
end;

function xbox__lastindex:longint;
begin
result:=high(system_xbox_retryref64);
end;

end.

