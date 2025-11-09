unit gosswin2;

interface

uses gosswin;
{$align on}{$iochecks on}{$O+}{$W-}{$U+}{$V+}{$B-}{$X+}{$T-}{$P+}{$H+}{$J-}
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
//## Note..................... ** This is an automatically generated unit, created by "gosswin.win__make_gosswin2_pas" **
//## Library.................. dynamically loaded and managed 32bit Windows api's (gosswin2.pas)
//## Version.................. 4.00.531
//## Items.................... 306
//## Last Updated ............ 08oct2025
//## ==========================================================================================================================================================================================================================


const
   vwin____proccount                                     =306;//total number of Win32 api procs defined
   vwin____ChooseColor                                   =0;
   vwin____GetSaveFileName                               =1;
   vwin____GetOpenFileName                               =2;
   vwin____RedrawWindow                                  =3;
   vwin____CreatePopupMenu                               =4;
   vwin____AppendMenu                                    =5;
   vwin____GetSubMenu                                    =6;
   vwin____GetMenuItemID                                 =7;
   vwin____GetMenuItemCount                              =8;
   vwin____CheckMenuItem                                 =9;
   vwin____EnableMenuItem                                =10;
   vwin____InsertMenuItem                                =11;
   vwin____DestroyMenu                                   =12;
   vwin____TrackPopupMenu                                =13;
   vwin____GetFocus                                      =14;
   vwin____SetFocus                                      =15;
   vwin____GetParent                                     =16;
   vwin____SetParent                                     =17;
   vwin____CreateDirectory                               =18;
   vwin____GetFileAttributes                             =19;
   vwin____GetLocalTime                                  =20;
   vwin____SetLocalTime                                  =21;
   vwin____DeleteFile                                    =22;
   vwin____MoveFile                                      =23;
   vwin____SetFileAttributes                             =24;
   vwin____GetBitmapBits                                 =25;
   vwin____GetDIBits                                     =26;
   vwin____IsClipboardFormatAvailable                    =27;
   vwin____EmptyClipboard                                =28;
   vwin____OpenClipboard                                 =29;
   vwin____CloseClipboard                                =30;
   vwin____GdiFlush                                      =31;
   vwin____CreateCompatibleDC                            =32;
   vwin____CreateDIBSection                              =33;
   vwin____CreateCompatibleBitmap                        =34;
   vwin____CreateBitmap                                  =35;
   vwin____SetTextColor                                  =36;
   vwin____SetBkColor                                    =37;
   vwin____SetBkMode                                     =38;
   vwin____CreateBrushIndirect                           =39;
   vwin____MulDiv                                        =40;
   vwin____GetSysColor                                   =41;
   vwin____ExtTextOut                                    =42;
   vwin____GetDesktopWindow                              =43;
   vwin____HeapAlloc                                     =44;
   vwin____HeapReAlloc                                   =45;
   vwin____HeapSize                                      =46;
   vwin____HeapFree                                      =47;
   vwin____GlobalHandle                                  =48;
   vwin____GlobalSize                                    =49;
   vwin____GlobalFree                                    =50;
   vwin____GlobalUnlock                                  =51;
   vwin____GetClipboardData                              =52;
   vwin____SetClipboardData                              =53;
   vwin____GlobalLock                                    =54;
   vwin____GlobalAlloc                                   =55;
   vwin____GlobalReAlloc                                 =56;
   vwin____LoadCursorFromFile                            =57;
   vwin____GetDefaultPrinter                             =58;
   vwin____GetVersionEx                                  =59;
   vwin____EnumPrinters                                  =60;
   vwin____CreateIC                                      =61;
   vwin____GetProfileString                              =62;
   vwin____GetDC                                         =63;
   vwin____GetVersion                                    =64;
   vwin____EnumFonts                                     =65;
   vwin____EnumFontFamiliesEx                            =66;
   vwin____GetStockObject                                =67;
   vwin____GetCurrentThread                              =68;
   vwin____GetCurrentThreadId                            =69;
   vwin____ClipCursor                                    =70;
   vwin____GetClipCursor                                 =71;
   vwin____GetCapture                                    =72;
   vwin____SetCapture                                    =73;
   vwin____ReleaseCapture                                =74;
   vwin____PostMessage                                   =75;
   vwin____SetClassLong                                  =76;
   vwin____GetActiveWindow                               =77;
   vwin____ShowCursor                                    =78;
   vwin____SetCursorPos                                  =79;
   vwin____SetCursor                                     =80;
   vwin____GetCursor                                     =81;
   vwin____GetCursorPos                                  =82;
   vwin____GetWindowText                                 =83;
   vwin____GetWindowTextLength                           =84;
   vwin____SetWindowText                                 =85;
   vwin____GetModuleHandle                               =86;
   vwin____GetWindowPlacement                            =87;
   vwin____SetWindowPlacement                            =88;
   vwin____GetTextExtentPoint                            =89;
   vwin____TextOut                                       =90;
   vwin____GetSysColorBrush                              =91;
   vwin____CreateSolidBrush                              =92;
   vwin____LoadIcon                                      =93;
   vwin____LoadCursor                                    =94;
   vwin____FillRect                                      =95;
   vwin____FrameRect                                     =96;
   vwin____InvalidateRect                                =97;
   vwin____StretchBlt                                    =98;
   vwin____GetClientwinrect                              =99;
   vwin____GetWindowRect                                 =100;
   vwin____GetClientRect                                 =101;
   vwin____MoveWindow                                    =102;
   vwin____SetWindowPos                                  =103;
   vwin____DestroyWindow                                 =104;
   vwin____ShowWindow                                    =105;
   vwin____RegisterClassExA                              =106;
   vwin____IsWindowVisible                               =107;
   vwin____IsIconic                                      =108;
   vwin____GetWindowDC                                   =109;
   vwin____ReleaseDC                                     =110;
   vwin____BeginPaint                                    =111;
   vwin____EndPaint                                      =112;
   vwin____SendMessage                                   =113;
   vwin____EnumDisplaySettingsA                          =114;
   vwin____CreateDC                                      =115;
   vwin____DeleteDC                                      =116;
   vwin____GetDeviceCaps                                 =117;
   vwin____GetSystemMetrics                              =118;
   vwin____CreateRectRgn                                 =119;
   vwin____CreateRoundRectRgn                            =120;
   vwin____GetRgnBox                                     =121;
   vwin____SetWindowRgn                                  =122;
   vwin____PostThreadMessage                             =123;
   vwin____SetWindowLong                                 =124;
   vwin____GetWindowLong                                 =125;
   vwin____CallWindowProc                                =126;
   vwin____SystemParametersInfo                          =127;
   vwin____RegisterClipboardFormat                       =128;
   vwin____CountClipboardFormats                         =129;
   vwin____ClientToScreen                                =130;
   vwin____ScreenToClient                                =131;
   vwin____DragAcceptFiles                               =132;
   vwin____DragQueryFile                                 =133;
   vwin____DragFinish                                    =134;
   vwin____SetTimer                                      =135;
   vwin____KillTimer                                     =136;
   vwin____WaitMessage                                   =137;
   vwin____GetProcessHeap                                =138;
   vwin____SetPriorityClass                              =139;
   vwin____GetPriorityClass                              =140;
   vwin____SetThreadPriority                             =141;
   vwin____SetThreadPriorityBoost                        =142;
   vwin____GetThreadPriority                             =143;
   vwin____GetThreadPriorityBoost                        =144;
   vwin____CoInitializeEx                                =145;
   vwin____CoInitialize                                  =146;
   vwin____CoUninitialize                                =147;
   vwin____CreateMutexA                                  =148;
   vwin____ReleaseMutex                                  =149;
   vwin____WaitForSingleObject                           =150;
   vwin____WaitForSingleObjectEx                         =151;
   vwin____CreateEvent                                   =152;
   vwin____SetEvent                                      =153;
   vwin____ResetEvent                                    =154;
   vwin____PulseEvent                                    =155;
   vwin____InterlockedIncrement                          =156;
   vwin____InterlockedDecrement                          =157;
   vwin____GetFileVersionInfoSize                        =158;
   vwin____GetFileVersionInfo                            =159;
   vwin____VerQueryValue                                 =160;
   vwin____GetCurrentProcessId                           =161;
   vwin____ExitProcess                                   =162;
   vwin____GetExitCodeProcess                            =163;
   vwin____CreateThread                                  =164;
   vwin____SuspendThread                                 =165;
   vwin____ResumeThread                                  =166;
   vwin____GetCurrentProcess                             =167;
   vwin____GetLastError                                  =168;
   vwin____GetStdHandle                                  =169;
   vwin____SetStdHandle                                  =170;
   vwin____GetConsoleScreenBufferInfo                    =171;
   vwin____FillConsoleOutputCharacter                    =172;
   vwin____FillConsoleOutputAttribute                    =173;
   vwin____GetConsoleMode                                =174;
   vwin____SetConsoleCursorPosition                      =175;
   vwin____SetConsoleTitle                               =176;
   vwin____SetConsoleCtrlHandler                         =177;
   vwin____GetNumberOfConsoleInputEvents                 =178;
   vwin____ReadConsoleInput                              =179;
   vwin____GetMessage                                    =180;
   vwin____PeekMessage                                   =181;
   vwin____DispatchMessage                               =182;
   vwin____TranslateMessage                              =183;
   vwin____GetDriveType                                  =184;
   vwin____SetErrorMode                                  =185;
   vwin____ExitThread                                    =186;
   vwin____TerminateThread                               =187;
   vwin____QueryPerformanceCounter                       =188;
   vwin____QueryPerformanceFrequency                     =189;
   vwin____GetVolumeInformation                          =190;
   vwin____GetShortPathName                              =191;
   vwin____SHGetSpecialFolderLocation                    =192;
   vwin____SHGetPathFromIDList                           =193;
   vwin____GetWindowsDirectoryA                          =194;
   vwin____GetSystemDirectoryA                           =195;
   vwin____GetTempPathA                                  =196;
   vwin____FlushFileBuffers                              =197;
   vwin____CreateFile                                    =198;
   vwin____GetFileSize                                   =199;
   vwin____GetSystemTime                                 =200;
   vwin____CloseHandle                                   =201;
   vwin____GetFileInformationByHandle                    =202;
   vwin____SetFilePointer                                =203;
   vwin____SetEndOfFile                                  =204;
   vwin____WriteFile                                     =205;
   vwin____ReadFile                                      =206;
   vwin____GetLogicalDrives                              =207;
   vwin____FileTimeToLocalFileTime                       =208;
   vwin____FileTimeToDosDateTime                         =209;
   vwin____DefWindowProc                                 =210;
   vwin____RegisterClass                                 =211;
   vwin____RegisterClassA                                =212;
   vwin____CreateWindowEx                                =213;
   vwin____EnableWindow                                  =214;
   vwin____IsWindowEnabled                               =215;
   vwin____UpdateWindow                                  =216;
   vwin____ShellExecute                                  =217;
   vwin____ShellExecuteEx                                =218;
   vwin____SHGetMalloc                                   =219;
   vwin____CoCreateInstance                              =220;
   vwin____GetObject                                     =221;
   vwin____CreateFontIndirect                            =222;
   vwin____SelectObject                                  =223;
   vwin____DeleteObject                                  =224;
   vwin____sleep                                         =225;
   vwin____sleepex                                       =226;
   vwin____RegConnectRegistry                            =227;
   vwin___RegCreateKeyEx                                 =228;
   vwin____RegOpenKey                                    =229;
   vwin____RegCloseKey                                   =230;
   vwin____RegDeleteKey                                  =231;
   vwin____RegOpenKeyEx                                  =232;
   vwin____RegQueryValueEx                               =233;
   vwin____RegSetValueEx                                 =234;
   vwin____StartServiceCtrlDispatcher                    =235;
   vwin____RegisterServiceCtrlHandler                    =236;
   vwin____SetServiceStatus                              =237;
   vwin____OpenSCManager                                 =238;
   vwin____CloseServiceHandle                            =239;
   vwin____CreateService                                 =240;
   vwin____OpenService                                   =241;
   vwin____DeleteService                                 =242;
   vwin____timeGetTime                                   =243;
   vwin____timeSetEvent                                  =244;
   vwin____timeKillEvent                                 =245;
   vwin____timeBeginPeriod                               =246;
   vwin____timeEndPeriod                                 =247;
   vnet____WSAStartup                                    =248;
   vnet____WSACleanup                                    =249;
   vnet____wsaasyncselect                                =250;
   vnet____WSAGetLastError                               =251;
   vnet____makesocket                                    =252;
   vnet____bind                                          =253;
   vnet____listen                                        =254;
   vnet____closesocket                                   =255;
   vnet____getsockopt                                    =256;
   vnet____accept                                        =257;
   vnet____recv                                          =258;
   vnet____send                                          =259;
   vnet____getpeername                                   =260;
   vnet____connect                                       =261;
   vnet____ioctlsocket                                   =262;
   vwin____FindFirstFile                                 =263;
   vwin____FindNextFile                                  =264;
   vwin____FindClose                                     =265;
   vwin____RemoveDirectory                               =266;
   vwin____waveOutGetDevCaps                             =267;
   vwin____waveOutOpen                                   =268;
   vwin____waveOutClose                                  =269;
   vwin____waveOutPrepareHeader                          =270;
   vwin____waveOutUnprepareHeader                        =271;
   vwin____waveOutWrite                                  =272;
   vwin____waveInOpen                                    =273;
   vwin____waveInClose                                   =274;
   vwin____waveInPrepareHeader                           =275;
   vwin____waveInUnprepareHeader                         =276;
   vwin____waveInAddBuffer                               =277;
   vwin____waveInStart                                   =278;
   vwin____waveInStop                                    =279;
   vwin____waveInReset                                   =280;
   vwin____midiOutGetNumDevs                             =281;
   vwin____midiOutGetDevCaps                             =282;
   vwin____midiOutOpen                                   =283;
   vwin____midiOutClose                                  =284;
   vwin____midiOutReset                                  =285;
   vwin____midiOutShortMsg                               =286;
   vwin____mciSendCommand                                =287;
   vwin____mciGetErrorString                             =288;
   vwin____waveOutGetVolume                              =289;
   vwin____waveOutSetVolume                              =290;
   vwin____midiOutGetVolume                              =291;
   vwin____midiOutSetVolume                              =292;
   vwin____auxSetVolume                                  =293;
   vwin____auxGetVolume                                  =294;
   vwin2____GetGuiResources                              =295;
   vwin2____SetProcessDpiAwarenessContext                =296;
   vwin2____GetMonitorInfo                               =297;
   vwin2____EnumDisplayMonitors                          =298;
   vwin2____GetDpiForMonitor                             =299;
   vwin2____SetLayeredWindowAttributes                   =300;
   vwin2____XInputGetState                               =301;
   vwin2____XInputSetState                               =302;
   vwin2____GetFileVersionInfoSize                       =303;
   vwin2____GetFileVersionInfo                           =304;
   vwin2____VerQueryValue                                =305;


type
   twin____ChooseColor                                   =function(var CC: TChooseColor):bool; stdcall;
   twin____GetSaveFileName                               =function(var OpenFile: TOpenFilename):bool; stdcall;
   twin____GetOpenFileName                               =function(var OpenFile: TOpenFilename):bool; stdcall;
   twin____RedrawWindow                                  =function(hWnd: HWND; lprcUpdate: pwinrect; hrgnUpdate: HRGN; flags: UINT):bool; stdcall;
   twin____CreatePopupMenu                               =function:hmenu; stdcall;
   twin____AppendMenu                                    =function(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: PChar):bool; stdcall;
   twin____GetSubMenu                                    =function(hMenu: HMENU; nPos: Integer):hmenu; stdcall;
   twin____GetMenuItemID                                 =function(hMenu: HMENU; nPos: Integer):uint; stdcall;
   twin____GetMenuItemCount                              =function(hMenu: HMENU):integer; stdcall;
   twin____CheckMenuItem                                 =function(hMenu: HMENU; uIDCheckItem, uCheck: UINT):dword; stdcall;
   twin____EnableMenuItem                                =function(hMenu: HMENU; uIDEnableItem, uEnable: UINT):bool; stdcall;
   twin____InsertMenuItem                                =function(p1: HMENU; p2: UINT; p3: BOOL; const p4: twinmenuiteminfo):bool; stdcall;
   twin____DestroyMenu                                   =function(hMenu: HMENU):bool; stdcall;
   twin____TrackPopupMenu                                =function(hMenu: HMENU; uFlags: UINT; x, y, nReserved: Integer; hWnd: HWND; prcRect: pwinrect):bool; stdcall;
   twin____GetFocus                                      =function:hwnd; stdcall;
   twin____SetFocus                                      =function(hWnd: HWND):hwnd; stdcall;
   twin____GetParent                                     =function(hWnd: HWND):hwnd; stdcall;
   twin____SetParent                                     =function(hWndChild, hWndNewParent: HWND):hwnd; stdcall;
   twin____CreateDirectory                               =function(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes):bool; stdcall;
   twin____GetFileAttributes                             =function(lpFileName: PChar):dword; stdcall;
   twin____GetLocalTime                                  =procedure(var lpSystemTime: TSystemTime); stdcall;
   twin____SetLocalTime                                  =function(const lpSystemTime: TSystemTime):bool; stdcall;
   twin____DeleteFile                                    =function(lpFileName: PChar):bool; stdcall;
   twin____MoveFile                                      =function(lpExistingFileName, lpNewFileName: PChar):bool; stdcall;
   twin____SetFileAttributes                             =function(lpFileName: PChar; dwFileAttributes: DWORD):bool; stdcall;
   twin____GetBitmapBits                                 =function(Bitmap: HBITMAP; Count: Longint; Bits: Pointer):longint; stdcall;
   twin____GetDIBits                                     =function(DC: HDC; Bitmap: HBitmap; StartScan, NumScans: UINT; Bits: Pointer; var BitInfo: TBitmapInfoHeader; Usage: UINT):integer; stdcall;
   twin____IsClipboardFormatAvailable                    =function(format: UINT):bool; stdcall;
   twin____EmptyClipboard                                =function:bool; stdcall;
   twin____OpenClipboard                                 =function(hWndNewOwner: HWND):bool; stdcall;
   twin____CloseClipboard                                =function:bool; stdcall;
   twin____GdiFlush                                      =function:bool; stdcall;
   twin____CreateCompatibleDC                            =function(DC: HDC):hdc; stdcall;
   twin____CreateDIBSection                              =function(DC: HDC; const p2: TBitmapInfoHeader; p3: UINT; var p4: Pointer; p5: THandle; p6: DWORD):hbitmap; stdcall;
   twin____CreateCompatibleBitmap                        =function(DC: HDC; Width, Height: Integer):hbitmap; stdcall;
   twin____CreateBitmap                                  =function(Width, Height: Integer; Planes, BitCount: Longint; Bits: Pointer):hbitmap; stdcall;
   twin____SetTextColor                                  =function(DC: HDC; Color: COLORREF):colorref; stdcall;
   twin____SetBkColor                                    =function(DC: HDC; Color: COLORREF):colorref; stdcall;
   twin____SetBkMode                                     =function(DC: HDC; BkMode: Integer):integer; stdcall;
   twin____CreateBrushIndirect                           =function(const p1: TLogBrush):hbrush; stdcall;
   twin____MulDiv                                        =function(nNumber, nNumerator, nDenominator: Integer):integer; stdcall;
   twin____GetSysColor                                   =function(nIndex: Integer):dword; stdcall;
   twin____ExtTextOut                                    =function(DC: HDC; X, Y: Integer; Options: Longint; Rect: PwinRect; Str: PChar; Count: Longint; Dx: PInteger):bool; stdcall;
   twin____GetDesktopWindow                              =function:hwnd; stdcall;
   twin____HeapAlloc                                     =function(hHeap: THandle; dwFlags, dwBytes: DWORD):pointer; stdcall;
   twin____HeapReAlloc                                   =function(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD):pointer; stdcall;
   twin____HeapSize                                      =function(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer):dword; stdcall;
   twin____HeapFree                                      =function(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer):bool; stdcall;
   twin____GlobalHandle                                  =function(Mem: Pointer):hglobal; stdcall;
   twin____GlobalSize                                    =function(hMem: HGLOBAL):dword; stdcall;
   twin____GlobalFree                                    =function(hMem: HGLOBAL):hglobal; stdcall;
   twin____GlobalUnlock                                  =function(hMem: HGLOBAL):bool; stdcall;
   twin____GetClipboardData                              =function(uFormat: UINT):thandle; stdcall;
   twin____SetClipboardData                              =function(uFormat: UINT; hMem: THandle):thandle; stdcall;
   twin____GlobalLock                                    =function(hMem: HGLOBAL):pointer; stdcall;
   twin____GlobalAlloc                                   =function(uFlags: UINT; dwBytes: DWORD):hglobal; stdcall;
   twin____GlobalReAlloc                                 =function(hMem: HGLOBAL; dwBytes: DWORD; uFlags: UINT):hglobal; stdcall;
   twin____LoadCursorFromFile                            =function(lpFileName: PAnsiChar):hcursor; stdcall;
   twin____GetDefaultPrinter                             =function(xbuffer:pointer;var xsize:longint):bool; stdcall;
   twin____GetVersionEx                                  =function(var lpVersionInformation: TOSVersionInfo):bool; stdcall;
   twin____EnumPrinters                                  =function(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD):bool; stdcall;
   twin____CreateIC                                      =function(lpszDriver, lpszDevice, lpszOutput: PChar; lpdvmInit: PDeviceModeA):hdc; stdcall;
   twin____GetProfileString                              =function(lpAppName, lpKeyName, lpDefault: PChar; lpReturnedString: PChar; nSize: DWORD):dword; stdcall;
   twin____GetDC                                         =function(hWnd: HWND):hdc; stdcall;
   twin____GetVersion                                    =function:dword; stdcall;
   twin____EnumFonts                                     =function(DC: HDC; lpszFace: PChar; fntenmprc: TFarProc; lpszData: PChar):integer; stdcall;
   twin____EnumFontFamiliesEx                            =function(DC: HDC; var p2: TLogFont; p3: TFarProc; p4: LPARAM; p5: DWORD):bool; stdcall;
   twin____GetStockObject                                =function(Index: Integer):hgdiobj; stdcall;
   twin____GetCurrentThread                              =function:thandle; stdcall;
   twin____GetCurrentThreadId                            =function:dword; stdcall;
   twin____ClipCursor                                    =function(lpRect: pwinrect):bool; stdcall;
   twin____GetClipCursor                                 =function(var lpRect: twinrect):bool; stdcall;
   twin____GetCapture                                    =function:hwnd; stdcall;
   twin____SetCapture                                    =function(hWnd: HWND):hwnd; stdcall;
   twin____ReleaseCapture                                =function:bool; stdcall;
   twin____PostMessage                                   =function(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):bool; stdcall;
   twin____SetClassLong                                  =function(hWnd: HWND; nIndex: Integer; dwNewLong: Longint):dword; stdcall;
   twin____GetActiveWindow                               =function:hwnd; stdcall;
   twin____ShowCursor                                    =function(bShow: BOOL):integer; stdcall;
   twin____SetCursorPos                                  =function(X, Y: Integer):bool; stdcall;
   twin____SetCursor                                     =function(hCursor: HICON):hcursor; stdcall;
   twin____GetCursor                                     =function:hcursor; stdcall;
   twin____GetCursorPos                                  =function(var lpPoint: TPoint):bool; stdcall;
   twin____GetWindowText                                 =function(hWnd: HWND; lpString: PChar; nMaxCount: Integer):integer; stdcall;
   twin____GetWindowTextLength                           =function(hWnd: HWND):integer; stdcall;
   twin____SetWindowText                                 =function(hWnd: HWND; lpString: PChar):bool; stdcall;
   twin____GetModuleHandle                               =function(lpModuleName: PChar):hmodule; stdcall;
   twin____GetWindowPlacement                            =function(hWnd: HWND; WindowPlacement: PWindowPlacement):bool; stdcall;
   twin____SetWindowPlacement                            =function(hWnd: HWND; WindowPlacement: PWindowPlacement):bool; stdcall;
   twin____GetTextExtentPoint                            =function(DC: HDC; Str: PChar; Count: Integer; var Size: tpoint):bool; stdcall;
   twin____TextOut                                       =function(DC: HDC; X, Y: Integer; Str: PChar; Count: Integer):bool; stdcall;
   twin____GetSysColorBrush                              =function(xindex:longint):hbrush; stdcall;
   twin____CreateSolidBrush                              =function(p1: COLORREF):hbrush; stdcall;
   twin____LoadIcon                                      =function(hInstance: HINST; lpIconName: PChar):hicon; stdcall;
   twin____LoadCursor                                    =function(hInstance: HINST; lpCursorName: PAnsiChar):hcursor; stdcall;
   twin____FillRect                                      =function(hDC: HDC; const lprc: twinrect; hbr: HBRUSH):integer; stdcall;
   twin____FrameRect                                     =function(hDC: HDC; const lprc: twinrect; hbr: HBRUSH):integer; stdcall;
   twin____InvalidateRect                                =function(hWnd: HWND; lpwinrect: pwinrect; bErase: BOOL):bool; stdcall;
   twin____StretchBlt                                    =function(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC; XSrc, YSrc, SrcWidth, SrcHeight: Integer; Rop: DWORD):bool; stdcall;
   twin____GetClientwinrect                              =function(hWnd: HWND; var lpwinrect: twinrect):bool; stdcall;
   twin____GetWindowRect                                 =function(hWnd: HWND; var lpwinrect: twinrect):bool; stdcall;
   twin____GetClientRect                                 =function(hWnd: HWND; var lpRect: twinrect):bool; stdcall;
   twin____MoveWindow                                    =function(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL):bool; stdcall;
   twin____SetWindowPos                                  =function(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT):bool; stdcall;
   twin____DestroyWindow                                 =function(hWnd: HWND):bool; stdcall;
   twin____ShowWindow                                    =function(hWnd: HWND; nCmdShow: Integer):bool; stdcall;
   twin____RegisterClassExA                              =function(const WndClass: TWndClassExA):atom; stdcall;
   twin____IsWindowVisible                               =function(hWnd: HWND):bool; stdcall;
   twin____IsIconic                                      =function(hWnd: HWND):bool; stdcall;
   twin____GetWindowDC                                   =function(hWnd: HWND):hdc; stdcall;
   twin____ReleaseDC                                     =function(hWnd: HWND; hDC: HDC):integer; stdcall;
   twin____BeginPaint                                    =function(hWnd: HWND; var lpPaint: TPaintStruct):hdc; stdcall;
   twin____EndPaint                                      =function(hWnd: HWND; const lpPaint: TPaintStruct):bool; stdcall;
   twin____SendMessage                                   =function(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult; stdcall;
   twin____EnumDisplaySettingsA                          =function(lpszDeviceName: PAnsiChar; iModeNum: DWORD; var lpDevMode: TDeviceModeA):bool; stdcall;
   twin____CreateDC                                      =function(lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA):hdc; stdcall;
   twin____DeleteDC                                      =function(DC: HDC):bool; stdcall;
   twin____GetDeviceCaps                                 =function(DC: HDC; Index: Integer):integer; stdcall;
   twin____GetSystemMetrics                              =function(nIndex: Integer):integer; stdcall;
   twin____CreateRectRgn                                 =function(p1, p2, p3, p4: Integer):hrgn; stdcall;
   twin____CreateRoundRectRgn                            =function(p1, p2, p3, p4, p5, p6: Integer):hrgn; stdcall;
   twin____GetRgnBox                                     =function(RGN: HRGN; var p2: twinrect):integer; stdcall;
   twin____SetWindowRgn                                  =function(hWnd: HWND; hRgn: HRGN; bRedraw: BOOL):bool; stdcall;
   twin____PostThreadMessage                             =function(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM):bool; stdcall;
   twin____SetWindowLong                                 =function(hWnd: HWND; nIndex: Integer; dwNewLong: Longint):longint; stdcall;
   twin____GetWindowLong                                 =function(hWnd: HWND; nIndex: Integer):longint; stdcall;
   twin____CallWindowProc                                =function(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult; stdcall;
   twin____SystemParametersInfo                          =function(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT):bool; stdcall;
   twin____RegisterClipboardFormat                       =function(lpszFormat: PChar):uint; stdcall;
   twin____CountClipboardFormats                         =function:integer; stdcall;
   twin____ClientToScreen                                =function(hWnd: HWND; var lpPoint: tpoint):bool; stdcall;
   twin____ScreenToClient                                =function(hWnd: HWND; var lpPoint: tpoint):bool; stdcall;
   twin____DragAcceptFiles                               =procedure(Wnd: HWND; Accept: BOOL); stdcall;
   twin____DragQueryFile                                 =function(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT):uint; stdcall;
   twin____DragFinish                                    =procedure(Drop: HDROP); stdcall;
   twin____SetTimer                                      =function(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc):uint; stdcall;
   twin____KillTimer                                     =function(hWnd: HWND; uIDEvent: UINT):bool; stdcall;
   twin____WaitMessage                                   =function:bool; stdcall;
   twin____GetProcessHeap                                =function:thandle; stdcall;
   twin____SetPriorityClass                              =function(hProcess: THandle; dwPriorityClass: DWORD):bool; stdcall;
   twin____GetPriorityClass                              =function(hProcess: THandle):dword; stdcall;
   twin____SetThreadPriority                             =function(hThread: THandle; nPriority: Integer):bool; stdcall;
   twin____SetThreadPriorityBoost                        =function(hThread: THandle; DisablePriorityBoost: Bool):bool; stdcall;
   twin____GetThreadPriority                             =function(hThread: THandle):integer; stdcall;
   twin____GetThreadPriorityBoost                        =function(hThread: THandle; var DisablePriorityBoost: Bool):bool; stdcall;
   twin____CoInitializeEx                                =function(pvReserved: Pointer; coInit: Longint):hresult; stdcall;
   twin____CoInitialize                                  =function(pvReserved: Pointer):hresult; stdcall;
   twin____CoUninitialize                                =procedure; stdcall;
   twin____CreateMutexA                                  =function(lpMutexAttributes: PSecurityAttributes; bInitialOwner: BOOL; lpName: PAnsiChar):thandle; stdcall;
   twin____ReleaseMutex                                  =function(hMutex: THandle):bool; stdcall;
   twin____WaitForSingleObject                           =function(hHandle: THandle; dwMilliseconds: DWORD):dword; stdcall;
   twin____WaitForSingleObjectEx                         =function(hHandle: THandle; dwMilliseconds: DWORD; bAlertable: BOOL):dword; stdcall;
   twin____CreateEvent                                   =function(lpEventAttributes: PSecurityAttributes; bManualReset, bInitialState: BOOL; lpName: PAnsiChar):thandle; stdcall;
   twin____SetEvent                                      =function(hEvent: THandle):bool; stdcall;
   twin____ResetEvent                                    =function(hEvent: THandle):bool; stdcall;
   twin____PulseEvent                                    =function(hEvent: THandle):bool; stdcall;
   twin____InterlockedIncrement                          =function(var Addend: Integer):integer; stdcall;
   twin____InterlockedDecrement                          =function(var Addend: Integer):integer; stdcall;
   twin____GetFileVersionInfoSize                        =function(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD):dword; stdcall;
   twin____GetFileVersionInfo                            =function(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer):bool; stdcall;
   twin____VerQueryValue                                 =function(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT):bool; stdcall;
   twin____GetCurrentProcessId                           =function:dword; stdcall;
   twin____ExitProcess                                   =procedure(uExitCode: UINT); stdcall;
   twin____GetExitCodeProcess                            =function(hProcess: THandle; var lpExitCode: DWORD):bool; stdcall;
   twin____CreateThread                                  =function(lpThreadAttributes: Pointer; dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD):thandle; stdcall;
   twin____SuspendThread                                 =function(hThread: THandle):dword; stdcall;
   twin____ResumeThread                                  =function(hThread: THandle):dword; stdcall;
   twin____GetCurrentProcess                             =function:thandle; stdcall;
   twin____GetLastError                                  =function:dword; stdcall;
   twin____GetStdHandle                                  =function(nStdHandle: DWORD):thandle; stdcall;
   twin____SetStdHandle                                  =function(nStdHandle: DWORD; hHandle: THandle):bool; stdcall;
   twin____GetConsoleScreenBufferInfo                    =function(hConsoleOutput: THandle; var lpConsoleScreenBufferInfo: TConsoleScreenBufferInfo):bool; stdcall;
   twin____FillConsoleOutputCharacter                    =function(hConsoleOutput: THandle; cCharacter: Char; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD):bool; stdcall;
   twin____FillConsoleOutputAttribute                    =function(hConsoleOutput: THandle; wAttribute: Word; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfAttrsWritten: DWORD):bool; stdcall;
   twin____GetConsoleMode                                =function(hConsoleHandle: THandle; var lpMode: DWORD):bool; stdcall;
   twin____SetConsoleCursorPosition                      =function(hConsoleOutput: THandle; dwCursorPosition: TCoord):bool; stdcall;
   twin____SetConsoleTitle                               =function(lpConsoleTitle: PChar):bool; stdcall;
   twin____SetConsoleCtrlHandler                         =function(HandlerRoutine: TFNHandlerRoutine; Add: BOOL):bool; stdcall;
   twin____GetNumberOfConsoleInputEvents                 =function(hConsoleInput: THandle; var lpNumberOfEvents: DWORD):bool; stdcall;
   twin____ReadConsoleInput                              =function(hConsoleInput: THandle; var lpBuffer: TInputRecord; nLength: DWORD; var lpNumberOfEventsRead: DWORD):bool; stdcall;
   twin____GetMessage                                    =function(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: UINT):bool; stdcall;
   twin____PeekMessage                                   =function(var lpMsg: tmsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT):bool; stdcall;
   twin____DispatchMessage                               =function(const lpMsg: tmsg):longint; stdcall;
   twin____TranslateMessage                              =function(const lpMsg: tmsg):bool; stdcall;
   twin____GetDriveType                                  =function(lpRootPathName: PChar):uint; stdcall;
   twin____SetErrorMode                                  =function(uMode: UINT):uint; stdcall;
   twin____ExitThread                                    =procedure(dwExitCode: DWORD); stdcall;
   twin____TerminateThread                               =function(hThread: THandle; dwExitCode: DWORD):bool; stdcall;
   twin____QueryPerformanceCounter                       =function(var lpPerformanceCount: comp):bool; stdcall;
   twin____QueryPerformanceFrequency                     =function(var lpFrequency: comp):bool; stdcall;
   twin____GetVolumeInformation                          =function(lpRootPathName: PChar; lpVolumeNameBuffer: PChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD; var lpMaximumComponentLength, lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PChar; nFileSystemNameSize: DWORD):bool; stdcall;
   twin____GetShortPathName                              =function(lpszLongPath: PChar; lpszShortPath: PChar; cchBuffer: DWORD):dword; stdcall;
   twin____SHGetSpecialFolderLocation                    =function(hwndOwner: HWND; nFolder: Integer; var ppidl: PItemIDList):hresult; stdcall;
   twin____SHGetPathFromIDList                           =function(pidl: PItemIDList; pszPath: PChar):bool; stdcall;
   twin____GetWindowsDirectoryA                          =function(lpBuffer: PAnsiChar; uSize: UINT):uint; stdcall;
   twin____GetSystemDirectoryA                           =function(lpBuffer: PAnsiChar; uSize: UINT):uint; stdcall;
   twin____GetTempPathA                                  =function(nBufferLength: DWORD; lpBuffer: PAnsiChar):dword; stdcall;
   twin____FlushFileBuffers                              =function(hFile: THandle):bool; stdcall;
   twin____CreateFile                                    =function(lpFileName: PChar; dwDesiredAccess, dwShareMode: Integer; lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD; hTemplateFile: THandle):thandle; stdcall;
   twin____GetFileSize                                   =function(hFile: THandle; lpFileSizeHigh: Pointer):dword; stdcall;
   twin____GetSystemTime                                 =procedure(var lpSystemTime: TSystemTime); stdcall;
   twin____CloseHandle                                   =function(hObject: THandle):bool; stdcall;
   twin____GetFileInformationByHandle                    =function(hFile: THandle; var lpFileInformation: TByHandleFileInformation):bool; stdcall;
   twin____SetFilePointer                                =function(hFile: THandle; lDistanceToMove: Longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD):dword; stdcall;
   twin____SetEndOfFile                                  =function(hFile: THandle):bool; stdcall;
   twin____WriteFile                                     =function(hFile: THandle; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped):bool; stdcall;
   twin____ReadFile                                      =function(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped):bool; stdcall;
   twin____GetLogicalDrives                              =function:dword; stdcall;
   twin____FileTimeToLocalFileTime                       =function(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime):bool; stdcall;
   twin____FileTimeToDosDateTime                         =function(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word):bool; stdcall;
   twin____DefWindowProc                                 =function(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult; stdcall;
   twin____RegisterClass                                 =function(const lpWndClass: TWndClass):atom; stdcall;
   twin____RegisterClassA                                =function(const lpWndClass: TWndClassA):atom; stdcall;
   twin____CreateWindowEx                                =function(dwExStyle: DWORD; lpClassName: PChar; lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer):hwnd; stdcall;
   twin____EnableWindow                                  =function(hWnd: HWND; bEnable: BOOL):bool; stdcall;
   twin____IsWindowEnabled                               =function(hWnd: HWND):bool; stdcall;
   twin____UpdateWindow                                  =function(hWnd: HWND):bool; stdcall;
   twin____ShellExecute                                  =function(hWnd: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer):hinst; stdcall;
   twin____ShellExecuteEx                                =function(lpExecInfo: PShellExecuteInfo):bool; stdcall;
   twin____SHGetMalloc                                   =function(var ppMalloc: imalloc):hresult; stdcall;
   twin____CoCreateInstance                              =function(const clsid: TCLSID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TIID; out pv):hresult; stdcall;
   twin____GetObject                                     =function(p1: HGDIOBJ; p2: Integer; p3: Pointer):integer; stdcall;
   twin____CreateFontIndirect                            =function(const p1: TLogFont):hfont; stdcall;
   twin____SelectObject                                  =function(DC: HDC; p2: HGDIOBJ):hgdiobj; stdcall;
   twin____DeleteObject                                  =function(p1: HGDIOBJ):bool; stdcall;
   twin____sleep                                         =procedure(dwMilliseconds: DWORD); stdcall;
   twin____sleepex                                       =function(dwMilliseconds: DWORD; bAlertable: BOOL):dword; stdcall;
   twin____RegConnectRegistry                            =function(lpMachineName: PChar; hKey: HKEY; var phkResult: HKEY):longint; stdcall;
   twin___RegCreateKeyEx                                 =function(hKey:HKEY;lpSubKey:PChar;Reserved:DWORD;lpClass:PChar;dwOptions:DWORD;samDesired:REGSAM;lpSecurityAttributes:PSecurityAttributes;var phkResult:HKEY;lpdwDisposition:PDWORD):longint; stdcall;
   twin____RegOpenKey                                    =function(hKey: HKEY; lpSubKey: PChar; var phkResult: HKEY):longint; stdcall;
   twin____RegCloseKey                                   =function(hKey: HKEY):longint; stdcall;
   twin____RegDeleteKey                                  =function(hKey: HKEY; lpSubKey: PChar):longint; stdcall;
   twin____RegOpenKeyEx                                  =function(hKey: HKEY; lpSubKey: PChar; ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY):longint; stdcall;
   twin____RegQueryValueEx                               =function(hKey: HKEY; lpValueName: PChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD):longint; stdcall;
   twin____RegSetValueEx                                 =function(hKey: HKEY; lpValueName: PChar; Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD):longint; stdcall;
   twin____StartServiceCtrlDispatcher                    =function(var lpServiceStartTable: TServiceTableEntry):bool; stdcall;
   twin____RegisterServiceCtrlHandler                    =function(lpServiceName: PChar; lpHandlerProc: ThandlerFunction):service_status_handle; stdcall;
   twin____SetServiceStatus                              =function(hServiceStatus: SERVICE_STATUS_HANDLE; var lpServiceStatus: TServiceStatus):bool; stdcall;
   twin____OpenSCManager                                 =function(lpMachineName, lpDatabaseName: PChar; dwDesiredAccess: DWORD):sc_handle; stdcall;
   twin____CloseServiceHandle                            =function(hSCObject: SC_HANDLE):bool; stdcall;
   twin____CreateService                                 =function(hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PChar; dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PChar; lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword: PChar):sc_handle; stdcall;
   twin____OpenService                                   =function(hSCManager: SC_HANDLE; lpServiceName: PChar; dwDesiredAccess: DWORD):sc_handle; stdcall;
   twin____DeleteService                                 =function(hService: SC_HANDLE):bool; stdcall;
   twin____timeGetTime                                   =function:dword; stdcall;
   twin____timeSetEvent                                  =function(uDelay, uResolution: UINT;  lpFunction: TFNTimeCallBack; dwUser: DWORD; uFlags: UINT):uint; stdcall;
   twin____timeKillEvent                                 =function(uTimerID: UINT):uint; stdcall;
   twin____timeBeginPeriod                               =function(uPeriod: UINT):mmresult; stdcall;
   twin____timeEndPeriod                                 =function(uPeriod: UINT):mmresult; stdcall;
   tnet____WSAStartup                                    =function(wVersionRequired: word; var WSData: TWSAData):integer; stdcall;
   tnet____WSACleanup                                    =function:integer; stdcall;
   tnet____wsaasyncselect                                =function(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint):integer; stdcall;
   tnet____WSAGetLastError                               =function:integer; stdcall;
   tnet____makesocket                                    =function(af, struct, protocol: Integer):tsocket; stdcall;
   tnet____bind                                          =function(s: TSocket; var addr: TSockAddr; namelen: Integer):integer; stdcall;
   tnet____listen                                        =function(s: TSocket; backlog: Integer):integer; stdcall;
   tnet____closesocket                                   =function(s: tsocket):integer; stdcall;
   tnet____getsockopt                                    =function(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer):integer; stdcall;
   tnet____accept                                        =function(s: TSocket; addr: PSockAddr; addrlen: PInteger):tsocket; stdcall;
   tnet____recv                                          =function(s: TSocket; var Buf; len, flags: Integer):integer; stdcall;
   tnet____send                                          =function(s: TSocket; var Buf; len, flags: Integer):integer; stdcall;
   tnet____getpeername                                   =function(s: TSocket; var name: TSockAddr; var namelen: Integer):integer; stdcall;
   tnet____connect                                       =function(s: TSocket; var name: TSockAddr; namelen: Integer):integer; stdcall;
   tnet____ioctlsocket                                   =function(s: TSocket; cmd: Longint; var arg: u_long):integer; stdcall;
   twin____FindFirstFile                                 =function(lpFileName: PChar; var lpFindFileData: TWIN32FindData):thandle; stdcall;
   twin____FindNextFile                                  =function(hFindFile: THandle; var lpFindFileData: TWIN32FindData):bool; stdcall;
   twin____FindClose                                     =function(hFindFile: THandle):bool; stdcall;
   twin____RemoveDirectory                               =function(lpPathName: PChar):bool; stdcall;
   twin____waveOutGetDevCaps                             =function(uDeviceID: UINT; lpCaps: PWaveOutCaps; uSize: UINT):mmresult; stdcall;
   twin____waveOutOpen                                   =function(lphWaveOut: PHWaveOut; uDeviceID: UINT; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD):mmresult; stdcall;
   twin____waveOutClose                                  =function(hWaveOut: HWAVEOUT):mmresult; stdcall;
   twin____waveOutPrepareHeader                          =function(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult; stdcall;
   twin____waveOutUnprepareHeader                        =function(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult; stdcall;
   twin____waveOutWrite                                  =function(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult; stdcall;
   twin____waveInOpen                                    =function(lphWaveIn: PHWAVEIN; uDeviceID: UINT; lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD):mmresult; stdcall;
   twin____waveInClose                                   =function(hWaveIn: HWAVEIN):mmresult; stdcall;
   twin____waveInPrepareHeader                           =function(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult; stdcall;
   twin____waveInUnprepareHeader                         =function(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult; stdcall;
   twin____waveInAddBuffer                               =function(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult; stdcall;
   twin____waveInStart                                   =function(hWaveIn: HWAVEIN):mmresult; stdcall;
   twin____waveInStop                                    =function(hWaveIn: HWAVEIN):mmresult; stdcall;
   twin____waveInReset                                   =function(hWaveIn: HWAVEIN):mmresult; stdcall;
   twin____midiOutGetNumDevs                             =function:uint; stdcall;
   twin____midiOutGetDevCaps                             =function(uDeviceID: UINT; lpCaps: PMidiOutCaps; uSize: UINT):mmresult; stdcall;
   twin____midiOutOpen                                   =function(lphMidiOut: PHMIDIOUT; uDeviceID: UINT; dwCallback, dwInstance, dwFlags: DWORD):mmresult; stdcall;
   twin____midiOutClose                                  =function(hMidiOut: HMIDIOUT):mmresult; stdcall;
   twin____midiOutReset                                  =function(hMidiOut: HMIDIOUT):mmresult; stdcall;
   twin____midiOutShortMsg                               =function(const hMidiOut: HMIDIOUT; const dwMsg: DWORD):mmresult; stdcall;
   twin____mciSendCommand                                =function(mciId:MCIDEVICEID;uMessage:UINT;dwParam1,dwParam2:DWORD):mcierror; stdcall;
   twin____mciGetErrorString                             =function(mcierr: MCIERROR; pszText: PChar; uLength: UINT):bool; stdcall;
   twin____waveOutGetVolume                              =function(hwo: longint; lpdwVolume: PDWORD):mmresult; stdcall;
   twin____waveOutSetVolume                              =function(hwo: longint; dwVolume: DWORD):mmresult; stdcall;
   twin____midiOutGetVolume                              =function(hmo: longint; lpdwVolume: PDWORD):mmresult; stdcall;
   twin____midiOutSetVolume                              =function(hmo: longint; dwVolume: DWORD):mmresult; stdcall;
   twin____auxSetVolume                                  =function(uDeviceID: UINT; dwVolume: DWORD):mmresult; stdcall;
   twin____auxGetVolume                                  =function(uDeviceID: UINT; lpdwVolume: PDWORD):mmresult; stdcall;
   twin2____GetGuiResources                              =function(xhandle:thandle;flags:dword):dword; stdcall;
   twin2____SetProcessDpiAwarenessContext                =function(inDPI_AWARENESS_CONTEXT:dword):lresult; stdcall;
   twin2____GetMonitorInfo                               =function(Monitor:hmonitor;lpMonitorInfo:pmonitorinfo):lresult; stdcall;
   twin2____EnumDisplayMonitors                          =function(dc:hdc;lpcrect:pwinrect;userProc:PMonitorenumproc;dwData:lparam):lresult; stdcall;
   twin2____GetDpiForMonitor                             =function(monitor:hmonitor;dpiType:longint;var dpiX,dpiY:uint):lresult; stdcall;
   twin2____SetLayeredWindowAttributes                   =function(winHandle:hwnd;color:dword;bAplha:byte;dwFlags:dword):lresult; stdcall;
   twin2____XInputGetState                               =function(dwUserIndex03:dword;xinputstate:pxinputstate):tbasic_lresult; stdcall;
   twin2____XInputSetState                               =function(dwUserIndex03:dword;xinputvibration:pxinputvibration):tbasic_lresult; stdcall;
   twin2____GetFileVersionInfoSize                       =function(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD):dword; stdcall;
   twin2____GetFileVersionInfo                           =function(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer):bool; stdcall;
   twin2____VerQueryValue                                =function(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT):bool; stdcall;


function win____slotinfo(const xslot:longint;var dname,rvalue:longint;var pname:string;var xmisc:string):boolean;
function win____ChooseColor(var CC: TChooseColor):bool;
function win____GetSaveFileName(var OpenFile: TOpenFilename):bool;
function win____GetOpenFileName(var OpenFile: TOpenFilename):bool;
function win____RedrawWindow(hWnd: HWND; lprcUpdate: pwinrect; hrgnUpdate: HRGN; flags: UINT):bool;
function win____CreatePopupMenu:hmenu;
function win____AppendMenu(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: PChar):bool;
function win____GetSubMenu(hMenu: HMENU; nPos: Integer):hmenu;
function win____GetMenuItemID(hMenu: HMENU; nPos: Integer):uint;
function win____GetMenuItemCount(hMenu: HMENU):integer;
function win____CheckMenuItem(hMenu: HMENU; uIDCheckItem, uCheck: UINT):dword;
function win____EnableMenuItem(hMenu: HMENU; uIDEnableItem, uEnable: UINT):bool;
function win____InsertMenuItem(p1: HMENU; p2: UINT; p3: BOOL; const p4: twinmenuiteminfo):bool;
function win____DestroyMenu(hMenu: HMENU):bool;
function win____TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x, y, nReserved: Integer; hWnd: HWND; prcRect: pwinrect):bool;
function win____GetFocus:hwnd;
function win____SetFocus(hWnd: HWND):hwnd;
function win____GetParent(hWnd: HWND):hwnd;
function win____SetParent(hWndChild, hWndNewParent: HWND):hwnd;
function win____CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes):bool;
function win____GetFileAttributes(lpFileName: PChar):dword;
procedure win____GetLocalTime(var lpSystemTime: TSystemTime);
function win____SetLocalTime(const lpSystemTime: TSystemTime):bool;
function win____DeleteFile(lpFileName: PChar):bool;
function win____MoveFile(lpExistingFileName, lpNewFileName: PChar):bool;
function win____SetFileAttributes(lpFileName: PChar; dwFileAttributes: DWORD):bool;
function win____GetBitmapBits(Bitmap: HBITMAP; Count: Longint; Bits: Pointer):longint;
function win____GetDIBits(DC: HDC; Bitmap: HBitmap; StartScan, NumScans: UINT; Bits: Pointer; var BitInfo: TBitmapInfoHeader; Usage: UINT):integer;
function win____IsClipboardFormatAvailable(format: UINT):bool;
function win____EmptyClipboard:bool;
function win____OpenClipboard(hWndNewOwner: HWND):bool;
function win____CloseClipboard:bool;
function win____GdiFlush:bool;
function win____CreateCompatibleDC(DC: HDC):hdc;
function win____CreateDIBSection(DC: HDC; const p2: TBitmapInfoHeader; p3: UINT; var p4: Pointer; p5: THandle; p6: DWORD):hbitmap;
function win____CreateCompatibleBitmap(DC: HDC; Width, Height: Integer):hbitmap;
function win____CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; Bits: Pointer):hbitmap;
function win____SetTextColor(DC: HDC; Color: COLORREF):colorref;
function win____SetBkColor(DC: HDC; Color: COLORREF):colorref;
function win____SetBkMode(DC: HDC; BkMode: Integer):integer;
function win____CreateBrushIndirect(const p1: TLogBrush):hbrush;
function win____MulDiv(nNumber, nNumerator, nDenominator: Integer):integer;
function win____GetSysColor(nIndex: Integer):dword;
function win____ExtTextOut(DC: HDC; X, Y: Integer; Options: Longint; Rect: PwinRect; Str: PChar; Count: Longint; Dx: PInteger):bool;
function win____GetDesktopWindow:hwnd;
function win____HeapAlloc(hHeap: THandle; dwFlags, dwBytes: DWORD):pointer;
function win____HeapReAlloc(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD):pointer;
function win____HeapSize(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer):dword;
function win____HeapFree(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer):bool;
function win____GlobalHandle(Mem: Pointer):hglobal;
function win____GlobalSize(hMem: HGLOBAL):dword;
function win____GlobalFree(hMem: HGLOBAL):hglobal;
function win____GlobalUnlock(hMem: HGLOBAL):bool;
function win____GetClipboardData(uFormat: UINT):thandle;
function win____SetClipboardData(uFormat: UINT; hMem: THandle):thandle;
function win____GlobalLock(hMem: HGLOBAL):pointer;
function win____GlobalAlloc(uFlags: UINT; dwBytes: DWORD):hglobal;
function win____GlobalReAlloc(hMem: HGLOBAL; dwBytes: DWORD; uFlags: UINT):hglobal;
function win____LoadCursorFromFile(lpFileName: PAnsiChar):hcursor;
function win____GetDefaultPrinter(xbuffer:pointer;var xsize:longint):bool;
function win____GetVersionEx(var lpVersionInformation: TOSVersionInfo):bool;
function win____EnumPrinters(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD):bool;
function win____CreateIC(lpszDriver, lpszDevice, lpszOutput: PChar; lpdvmInit: PDeviceModeA):hdc;
function win____GetProfileString(lpAppName, lpKeyName, lpDefault: PChar; lpReturnedString: PChar; nSize: DWORD):dword;
function win____GetDC(hWnd: HWND):hdc;
function win____GetVersion:dword;
function win____EnumFonts(DC: HDC; lpszFace: PChar; fntenmprc: TFarProc; lpszData: PChar):integer;
function win____EnumFontFamiliesEx(DC: HDC; var p2: TLogFont; p3: TFarProc; p4: LPARAM; p5: DWORD):bool;
function win____GetStockObject(Index: Integer):hgdiobj;
function win____GetCurrentThread:thandle;
function win____GetCurrentThreadId:dword;
function win____ClipCursor(lpRect: pwinrect):bool;
function win____GetClipCursor(var lpRect: twinrect):bool;
function win____GetCapture:hwnd;
function win____SetCapture(hWnd: HWND):hwnd;
function win____ReleaseCapture:bool;
function win____PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):bool;
function win____SetClassLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint):dword;
function win____GetActiveWindow:hwnd;
function win____ShowCursor(bShow: BOOL):integer;
function win____SetCursorPos(X, Y: Integer):bool;
function win____SetCursor(hCursor: HICON):hcursor;
function win____GetCursor:hcursor;
function win____GetCursorPos(var lpPoint: TPoint):bool;
function win____GetWindowText(hWnd: HWND; lpString: PChar; nMaxCount: Integer):integer;
function win____GetWindowTextLength(hWnd: HWND):integer;
function win____SetWindowText(hWnd: HWND; lpString: PChar):bool;
function win____GetModuleHandle(lpModuleName: PChar):hmodule;
function win____GetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement):bool;
function win____SetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement):bool;
function win____GetTextExtentPoint(DC: HDC; Str: PChar; Count: Integer; var Size: tpoint):bool;
function win____TextOut(DC: HDC; X, Y: Integer; Str: PChar; Count: Integer):bool;
function win____GetSysColorBrush(xindex:longint):hbrush;
function win____CreateSolidBrush(p1: COLORREF):hbrush;
function win____LoadIcon(hInstance: HINST; lpIconName: PChar):hicon;
function win____LoadCursor(hInstance: HINST; lpCursorName: PAnsiChar):hcursor;
function win____FillRect(hDC: HDC; const lprc: twinrect; hbr: HBRUSH):integer;
function win____FrameRect(hDC: HDC; const lprc: twinrect; hbr: HBRUSH):integer;
function win____InvalidateRect(hWnd: HWND; lpwinrect: pwinrect; bErase: BOOL):bool;
function win____StretchBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC; XSrc, YSrc, SrcWidth, SrcHeight: Integer; Rop: DWORD):bool;
function win____GetClientwinrect(hWnd: HWND; var lpwinrect: twinrect):bool;
function win____GetWindowRect(hWnd: HWND; var lpwinrect: twinrect):bool;
function win____GetClientRect(hWnd: HWND; var lpRect: twinrect):bool;
function win____MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL):bool;
function win____SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT):bool;
function win____DestroyWindow(hWnd: HWND):bool;
function win____ShowWindow(hWnd: HWND; nCmdShow: Integer):bool;
function win____RegisterClassExA(const WndClass: TWndClassExA):atom;
function win____IsWindowVisible(hWnd: HWND):bool;
function win____IsIconic(hWnd: HWND):bool;
function win____GetWindowDC(hWnd: HWND):hdc;
function win____ReleaseDC(hWnd: HWND; hDC: HDC):integer;
function win____BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct):hdc;
function win____EndPaint(hWnd: HWND; const lpPaint: TPaintStruct):bool;
function win____SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult;
function win____EnumDisplaySettingsA(lpszDeviceName: PAnsiChar; iModeNum: DWORD; var lpDevMode: TDeviceModeA):bool;
function win____CreateDC(lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA):hdc;
function win____DeleteDC(DC: HDC):bool;
function win____GetDeviceCaps(DC: HDC; Index: Integer):integer;
function win____GetSystemMetrics(nIndex: Integer):integer;
function win____CreateRectRgn(p1, p2, p3, p4: Integer):hrgn;
function win____CreateRoundRectRgn(p1, p2, p3, p4, p5, p6: Integer):hrgn;
function win____GetRgnBox(RGN: HRGN; var p2: twinrect):integer;
function win____SetWindowRgn(hWnd: HWND; hRgn: HRGN; bRedraw: BOOL):bool;
function win____PostThreadMessage(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM):bool;
function win____SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint):longint;
function win____GetWindowLong(hWnd: HWND; nIndex: Integer):longint;
function win____CallWindowProc(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult;
function win____SystemParametersInfo(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT):bool;
function win____RegisterClipboardFormat(lpszFormat: PChar):uint;
function win____CountClipboardFormats:integer;
function win____ClientToScreen(hWnd: HWND; var lpPoint: tpoint):bool;
function win____ScreenToClient(hWnd: HWND; var lpPoint: tpoint):bool;
procedure win____DragAcceptFiles(Wnd: HWND; Accept: BOOL);
function win____DragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT):uint;
procedure win____DragFinish(Drop: HDROP);
function win____SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc):uint;
function win____KillTimer(hWnd: HWND; uIDEvent: UINT):bool;
function win____WaitMessage:bool;
function win____GetProcessHeap:thandle;
function win____SetPriorityClass(hProcess: THandle; dwPriorityClass: DWORD):bool;
function win____GetPriorityClass(hProcess: THandle):dword;
function win____SetThreadPriority(hThread: THandle; nPriority: Integer):bool;
function win____SetThreadPriorityBoost(hThread: THandle; DisablePriorityBoost: Bool):bool;
function win____GetThreadPriority(hThread: THandle):integer;
function win____GetThreadPriorityBoost(hThread: THandle; var DisablePriorityBoost: Bool):bool;
function win____CoInitializeEx(pvReserved: Pointer; coInit: Longint):hresult;
function win____CoInitialize(pvReserved: Pointer):hresult;
procedure win____CoUninitialize;
function win____CreateMutexA(lpMutexAttributes: PSecurityAttributes; bInitialOwner: BOOL; lpName: PAnsiChar):thandle;
function win____ReleaseMutex(hMutex: THandle):bool;
function win____WaitForSingleObject(hHandle: THandle; dwMilliseconds: DWORD):dword;
function win____WaitForSingleObjectEx(hHandle: THandle; dwMilliseconds: DWORD; bAlertable: BOOL):dword;
function win____CreateEvent(lpEventAttributes: PSecurityAttributes; bManualReset, bInitialState: BOOL; lpName: PAnsiChar):thandle;
function win____SetEvent(hEvent: THandle):bool;
function win____ResetEvent(hEvent: THandle):bool;
function win____PulseEvent(hEvent: THandle):bool;
function win____InterlockedIncrement(var Addend: Integer):integer;
function win____InterlockedDecrement(var Addend: Integer):integer;
function win____GetFileVersionInfoSize(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD):dword;
function win____GetFileVersionInfo(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer):bool;
function win____VerQueryValue(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT):bool;
function win____GetCurrentProcessId:dword;
procedure win____ExitProcess(uExitCode: UINT);
function win____GetExitCodeProcess(hProcess: THandle; var lpExitCode: DWORD):bool;
function win____CreateThread(lpThreadAttributes: Pointer; dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD):thandle;
function win____SuspendThread(hThread: THandle):dword;
function win____ResumeThread(hThread: THandle):dword;
function win____GetCurrentProcess:thandle;
function win____GetLastError:dword;
function win____GetStdHandle(nStdHandle: DWORD):thandle;
function win____SetStdHandle(nStdHandle: DWORD; hHandle: THandle):bool;
function win____GetConsoleScreenBufferInfo(hConsoleOutput: THandle; var lpConsoleScreenBufferInfo: TConsoleScreenBufferInfo):bool;
function win____FillConsoleOutputCharacter(hConsoleOutput: THandle; cCharacter: Char; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD):bool;
function win____FillConsoleOutputAttribute(hConsoleOutput: THandle; wAttribute: Word; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfAttrsWritten: DWORD):bool;
function win____GetConsoleMode(hConsoleHandle: THandle; var lpMode: DWORD):bool;
function win____SetConsoleCursorPosition(hConsoleOutput: THandle; dwCursorPosition: TCoord):bool;
function win____SetConsoleTitle(lpConsoleTitle: PChar):bool;
function win____SetConsoleCtrlHandler(HandlerRoutine: TFNHandlerRoutine; Add: BOOL):bool;
function win____GetNumberOfConsoleInputEvents(hConsoleInput: THandle; var lpNumberOfEvents: DWORD):bool;
function win____ReadConsoleInput(hConsoleInput: THandle; var lpBuffer: TInputRecord; nLength: DWORD; var lpNumberOfEventsRead: DWORD):bool;
function win____GetMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: UINT):bool;
function win____PeekMessage(var lpMsg: tmsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT):bool;
function win____DispatchMessage(const lpMsg: tmsg):longint;
function win____TranslateMessage(const lpMsg: tmsg):bool;
function win____GetDriveType(lpRootPathName: PChar):uint;
function win____SetErrorMode(uMode: UINT):uint;
procedure win____ExitThread(dwExitCode: DWORD);
function win____TerminateThread(hThread: THandle; dwExitCode: DWORD):bool;
function win____QueryPerformanceCounter(var lpPerformanceCount: comp):bool;
function win____QueryPerformanceFrequency(var lpFrequency: comp):bool;
function win____GetVolumeInformation(lpRootPathName: PChar; lpVolumeNameBuffer: PChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD; var lpMaximumComponentLength, lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PChar; nFileSystemNameSize: DWORD):bool;
function win____GetShortPathName(lpszLongPath: PChar; lpszShortPath: PChar; cchBuffer: DWORD):dword;
function win____SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer; var ppidl: PItemIDList):hresult;
function win____SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar):bool;
function win____GetWindowsDirectoryA(lpBuffer: PAnsiChar; uSize: UINT):uint;
function win____GetSystemDirectoryA(lpBuffer: PAnsiChar; uSize: UINT):uint;
function win____GetTempPathA(nBufferLength: DWORD; lpBuffer: PAnsiChar):dword;
function win____FlushFileBuffers(hFile: THandle):bool;
function win____CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: Integer; lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD; hTemplateFile: THandle):thandle;
function win____GetFileSize(hFile: THandle; lpFileSizeHigh: Pointer):dword;
procedure win____GetSystemTime(var lpSystemTime: TSystemTime);
function win____CloseHandle(hObject: THandle):bool;
function win____GetFileInformationByHandle(hFile: THandle; var lpFileInformation: TByHandleFileInformation):bool;
function win____SetFilePointer(hFile: THandle; lDistanceToMove: Longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD):dword;
function win____SetEndOfFile(hFile: THandle):bool;
function win____WriteFile(hFile: THandle; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped):bool;
function win____ReadFile(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped):bool;
function win____GetLogicalDrives:dword;
function win____FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime):bool;
function win____FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word):bool;
function win____DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult;
function win____RegisterClass(const lpWndClass: TWndClass):atom;
function win____RegisterClassA(const lpWndClass: TWndClassA):atom;
function win____CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar; lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer):hwnd;
function win____EnableWindow(hWnd: HWND; bEnable: BOOL):bool;
function win____IsWindowEnabled(hWnd: HWND):bool;
function win____UpdateWindow(hWnd: HWND):bool;
function win____ShellExecute(hWnd: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer):hinst;
function win____ShellExecuteEx(lpExecInfo: PShellExecuteInfo):bool;
function win____SHGetMalloc(var ppMalloc: imalloc):hresult;
function win____CoCreateInstance(const clsid: TCLSID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TIID; out pv):hresult;
function win____GetObject(p1: HGDIOBJ; p2: Integer; p3: Pointer):integer;
function win____CreateFontIndirect(const p1: TLogFont):hfont;
function win____SelectObject(DC: HDC; p2: HGDIOBJ):hgdiobj;
function win____DeleteObject(p1: HGDIOBJ):bool;
procedure win____sleep(dwMilliseconds: DWORD);
function win____sleepex(dwMilliseconds: DWORD; bAlertable: BOOL):dword;
function win____RegConnectRegistry(lpMachineName: PChar; hKey: HKEY; var phkResult: HKEY):longint;
function win___RegCreateKeyEx(hKey:HKEY;lpSubKey:PChar;Reserved:DWORD;lpClass:PChar;dwOptions:DWORD;samDesired:REGSAM;lpSecurityAttributes:PSecurityAttributes;var phkResult:HKEY;lpdwDisposition:PDWORD):longint;
function win____RegOpenKey(hKey: HKEY; lpSubKey: PChar; var phkResult: HKEY):longint;
function win____RegCloseKey(hKey: HKEY):longint;
function win____RegDeleteKey(hKey: HKEY; lpSubKey: PChar):longint;
function win____RegOpenKeyEx(hKey: HKEY; lpSubKey: PChar; ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY):longint;
function win____RegQueryValueEx(hKey: HKEY; lpValueName: PChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD):longint;
function win____RegSetValueEx(hKey: HKEY; lpValueName: PChar; Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD):longint;
function win____StartServiceCtrlDispatcher(var lpServiceStartTable: TServiceTableEntry):bool;
function win____RegisterServiceCtrlHandler(lpServiceName: PChar; lpHandlerProc: ThandlerFunction):service_status_handle;
function win____SetServiceStatus(hServiceStatus: SERVICE_STATUS_HANDLE; var lpServiceStatus: TServiceStatus):bool;
function win____OpenSCManager(lpMachineName, lpDatabaseName: PChar; dwDesiredAccess: DWORD):sc_handle;
function win____CloseServiceHandle(hSCObject: SC_HANDLE):bool;
function win____CreateService(hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PChar; dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PChar; lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword: PChar):sc_handle;
function win____OpenService(hSCManager: SC_HANDLE; lpServiceName: PChar; dwDesiredAccess: DWORD):sc_handle;
function win____DeleteService(hService: SC_HANDLE):bool;
function win____timeGetTime:dword;
function win____timeSetEvent(uDelay, uResolution: UINT;  lpFunction: TFNTimeCallBack; dwUser: DWORD; uFlags: UINT):uint;
function win____timeKillEvent(uTimerID: UINT):uint;
function win____timeBeginPeriod(uPeriod: UINT):mmresult;
function win____timeEndPeriod(uPeriod: UINT):mmresult;
function net____WSAStartup(wVersionRequired: word; var WSData: TWSAData):integer;
function net____WSACleanup:integer;
function net____wsaasyncselect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint):integer;
function net____WSAGetLastError:integer;
function net____makesocket(af, struct, protocol: Integer):tsocket;
function net____bind(s: TSocket; var addr: TSockAddr; namelen: Integer):integer;
function net____listen(s: TSocket; backlog: Integer):integer;
function net____closesocket(s: tsocket):integer;
function net____getsockopt(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer):integer;
function net____accept(s: TSocket; addr: PSockAddr; addrlen: PInteger):tsocket;
function net____recv(s: TSocket; var Buf; len, flags: Integer):integer;
function net____send(s: TSocket; var Buf; len, flags: Integer):integer;
function net____getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer):integer;
function net____connect(s: TSocket; var name: TSockAddr; namelen: Integer):integer;
function net____ioctlsocket(s: TSocket; cmd: Longint; var arg: u_long):integer;
function win____FindFirstFile(lpFileName: PChar; var lpFindFileData: TWIN32FindData):thandle;
function win____FindNextFile(hFindFile: THandle; var lpFindFileData: TWIN32FindData):bool;
function win____FindClose(hFindFile: THandle):bool;
function win____RemoveDirectory(lpPathName: PChar):bool;
function win____waveOutGetDevCaps(uDeviceID: UINT; lpCaps: PWaveOutCaps; uSize: UINT):mmresult;
function win____waveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: UINT; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD):mmresult;
function win____waveOutClose(hWaveOut: HWAVEOUT):mmresult;
function win____waveOutPrepareHeader(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult;
function win____waveOutUnprepareHeader(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult;
function win____waveOutWrite(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult;
function win____waveInOpen(lphWaveIn: PHWAVEIN; uDeviceID: UINT; lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD):mmresult;
function win____waveInClose(hWaveIn: HWAVEIN):mmresult;
function win____waveInPrepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult;
function win____waveInUnprepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult;
function win____waveInAddBuffer(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult;
function win____waveInStart(hWaveIn: HWAVEIN):mmresult;
function win____waveInStop(hWaveIn: HWAVEIN):mmresult;
function win____waveInReset(hWaveIn: HWAVEIN):mmresult;
function win____midiOutGetNumDevs:uint;
function win____midiOutGetDevCaps(uDeviceID: UINT; lpCaps: PMidiOutCaps; uSize: UINT):mmresult;
function win____midiOutOpen(lphMidiOut: PHMIDIOUT; uDeviceID: UINT; dwCallback, dwInstance, dwFlags: DWORD):mmresult;
function win____midiOutClose(hMidiOut: HMIDIOUT):mmresult;
function win____midiOutReset(hMidiOut: HMIDIOUT):mmresult;
function win____midiOutShortMsg(const hMidiOut: HMIDIOUT; const dwMsg: DWORD):mmresult;
function win____mciSendCommand(mciId:MCIDEVICEID;uMessage:UINT;dwParam1,dwParam2:DWORD):mcierror;
function win____mciGetErrorString(mcierr: MCIERROR; pszText: PChar; uLength: UINT):bool;
function win____waveOutGetVolume(hwo: longint; lpdwVolume: PDWORD):mmresult;
function win____waveOutSetVolume(hwo: longint; dwVolume: DWORD):mmresult;
function win____midiOutGetVolume(hmo: longint; lpdwVolume: PDWORD):mmresult;
function win____midiOutSetVolume(hmo: longint; dwVolume: DWORD):mmresult;
function win____auxSetVolume(uDeviceID: UINT; dwVolume: DWORD):mmresult;
function win____auxGetVolume(uDeviceID: UINT; lpdwVolume: PDWORD):mmresult;
function win2____GetGuiResources(xhandle:thandle;flags:dword):dword;
function win2____SetProcessDpiAwarenessContext(inDPI_AWARENESS_CONTEXT:dword):lresult;
function win2____GetMonitorInfo(Monitor:hmonitor;lpMonitorInfo:pmonitorinfo):lresult;
function win2____EnumDisplayMonitors(dc:hdc;lpcrect:pwinrect;userProc:PMonitorenumproc;dwData:lparam):lresult;
function win2____GetDpiForMonitor(monitor:hmonitor;dpiType:longint;var dpiX,dpiY:uint):lresult;
function win2____SetLayeredWindowAttributes(winHandle:hwnd;color:dword;bAplha:byte;dwFlags:dword):lresult;
function win2____XInputGetState(dwUserIndex03:dword;xinputstate:pxinputstate):tbasic_lresult;
function win2____XInputSetState(dwUserIndex03:dword;xinputvibration:pxinputvibration):tbasic_lresult;
function win2____GetFileVersionInfoSize(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD):dword;
function win2____GetFileVersionInfo(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer):bool;
function win2____VerQueryValue(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT):bool;


implementation


function win____slotinfo(const xslot:longint;var dname,rvalue:longint;var pname:string;var xmisc:string):boolean;

   procedure s3(const _rvalue,_dname:longint;const _pname:string);
   begin

   rvalue :=_rvalue;
   dname  :=_dname;
   pname  :=_pname;

   end;

   procedure s4(const _rvalue,_dname:longint;const _pname,_xmisc:string);
   begin

   rvalue :=_rvalue;
   dname  :=_dname;
   pname  :=_pname;
   xmisc  :=_xmisc;

   end;

begin

//defaults
result :=true;
dname  :=dnone;
rvalue :=0;
pname  :='';
xmisc  :='';

//get
case xslot of
vwin____ChooseColor                       :s3( 0              ,dcomdlg32      ,'ChooseColorA'                     );
vwin____GetSaveFileName                   :s3( 0              ,dcomdlg32      ,'GetSaveFileNameA'                 );
vwin____GetOpenFileName                   :s3( 0              ,dcomdlg32      ,'GetOpenFileNameA'                 );
vwin____RedrawWindow                      :s3( 0              ,duser32        ,'RedrawWindow'                     );
vwin____CreatePopupMenu                   :s3( 0              ,duser32        ,'CreatePopupMenu'                  );
vwin____AppendMenu                        :s3( 0              ,duser32        ,'AppendMenuA'                      );
vwin____GetSubMenu                        :s3( 0              ,duser32        ,'GetSubMenu'                       );
vwin____GetMenuItemID                     :s3( 0              ,duser32        ,'GetMenuItemID'                    );
vwin____GetMenuItemCount                  :s3( 0              ,duser32        ,'GetMenuItemCount'                 );
vwin____CheckMenuItem                     :s3( 0              ,duser32        ,'CheckMenuItem'                    );
vwin____EnableMenuItem                    :s3( 0              ,duser32        ,'EnableMenuItem'                   );
vwin____InsertMenuItem                    :s3( 0              ,duser32        ,'InsertMenuItemA'                  );
vwin____DestroyMenu                       :s3( 0              ,duser32        ,'DestroyMenu'                      );
vwin____TrackPopupMenu                    :s3( 0              ,duser32        ,'TrackPopupMenu'                   );
vwin____GetFocus                          :s3( 0              ,duser32        ,'GetFocus'                         );
vwin____SetFocus                          :s3( 0              ,duser32        ,'SetFocus'                         );
vwin____GetParent                         :s3( 0              ,duser32        ,'GetParent'                        );
vwin____SetParent                         :s3( 0              ,duser32        ,'SetParent'                        );
vwin____CreateDirectory                   :s3( 0              ,dkernel32      ,'CreateDirectoryA'                 );
vwin____GetFileAttributes                 :s3( 0              ,dkernel32      ,'GetFileAttributesA'               );
vwin____GetLocalTime                      :s3( 0              ,dkernel32      ,'GetLocalTime'                     );
vwin____SetLocalTime                      :s3( 0              ,dkernel32      ,'SetLocalTime'                     );
vwin____DeleteFile                        :s3( 0              ,dkernel32      ,'DeleteFileA'                      );
vwin____MoveFile                          :s3( 0              ,dkernel32      ,'MoveFileA'                        );
vwin____SetFileAttributes                 :s3( 0              ,dkernel32      ,'SetFileAttributesA'               );
vwin____GetBitmapBits                     :s3( 0              ,dgdi32         ,'GetBitmapBits'                    );
vwin____GetDIBits                         :s3( 0              ,dgdi32         ,'GetDIBits'                        );
vwin____IsClipboardFormatAvailable        :s3( 0              ,duser32        ,'IsClipboardFormatAvailable'       );
vwin____EmptyClipboard                    :s3( 0              ,duser32        ,'EmptyClipboard'                   );
vwin____OpenClipboard                     :s3( 0              ,duser32        ,'OpenClipboard'                    );
vwin____CloseClipboard                    :s3( 0              ,duser32        ,'CloseClipboard'                   );
vwin____GdiFlush                          :s3( 0              ,dgdi32         ,'GdiFlush'                         );
vwin____CreateCompatibleDC                :s3( 0              ,dgdi32         ,'CreateCompatibleDC'               );
vwin____CreateDIBSection                  :s3( 0              ,dgdi32         ,'CreateDIBSection'                 );
vwin____CreateCompatibleBitmap            :s3( 0              ,dgdi32         ,'CreateCompatibleBitmap'           );
vwin____CreateBitmap                      :s3( 0              ,dgdi32         ,'CreateBitmap'                     );
vwin____SetTextColor                      :s3( 0              ,dgdi32         ,'SetTextColor'                     );
vwin____SetBkColor                        :s3( 0              ,dgdi32         ,'SetBkColor'                       );
vwin____SetBkMode                         :s3( 0              ,dgdi32         ,'SetBkMode'                        );
vwin____CreateBrushIndirect               :s3( 0              ,dgdi32         ,'CreateBrushIndirect'              );
vwin____MulDiv                            :s3( 0              ,dkernel32      ,'MulDiv'                           );
vwin____GetSysColor                       :s3( 0              ,duser32        ,'GetSysColor'                      );
vwin____ExtTextOut                        :s3( 0              ,dgdi32         ,'ExtTextOutA'                      );
vwin____GetDesktopWindow                  :s3( 0              ,duser32        ,'GetDesktopWindow'                 );
vwin____HeapAlloc                         :s3( 0              ,dkernel32      ,'HeapAlloc'                        );
vwin____HeapReAlloc                       :s3( 0              ,dkernel32      ,'HeapReAlloc'                      );
vwin____HeapSize                          :s3( 0              ,dkernel32      ,'HeapSize'                         );
vwin____HeapFree                          :s3( 0              ,dkernel32      ,'HeapFree'                         );
vwin____GlobalHandle                      :s3( 0              ,dkernel32      ,'GlobalHandle'                     );
vwin____GlobalSize                        :s3( 0              ,dkernel32      ,'GlobalSize'                       );
vwin____GlobalFree                        :s3( 0              ,dkernel32      ,'GlobalFree'                       );
vwin____GlobalUnlock                      :s3( 0              ,dkernel32      ,'GlobalUnlock'                     );
vwin____GetClipboardData                  :s3( 0              ,duser32        ,'GetClipboardData'                 );
vwin____SetClipboardData                  :s3( 0              ,duser32        ,'SetClipboardData'                 );
vwin____GlobalLock                        :s3( 0              ,dkernel32      ,'GlobalLock'                       );
vwin____GlobalAlloc                       :s3( 0              ,dkernel32      ,'GlobalAlloc'                      );
vwin____GlobalReAlloc                     :s3( 0              ,dkernel32      ,'GlobalReAlloc'                    );
vwin____LoadCursorFromFile                :s3( 0              ,duser32        ,'LoadCursorFromFileA'              );
vwin____GetDefaultPrinter                 :s3( 0              ,dwinspool      ,'GetDefaultPrinterA'               );
vwin____GetVersionEx                      :s3( 0              ,dkernel32      ,'GetVersionExA'                    );
vwin____EnumPrinters                      :s3( 0              ,dwinspool      ,'EnumPrintersA'                    );
vwin____CreateIC                          :s3( 0              ,dgdi32         ,'CreateICA'                        );
vwin____GetProfileString                  :s3( 0              ,dkernel32      ,'GetProfileStringA'                );
vwin____GetDC                             :s3( 0              ,duser32        ,'GetDC'                            );
vwin____GetVersion                        :s3( 0              ,dkernel32      ,'GetVersion'                       );
vwin____EnumFonts                         :s3( 0              ,dgdi32         ,'EnumFontsA'                       );
vwin____EnumFontFamiliesEx                :s3( 0              ,dgdi32         ,'EnumFontFamiliesExA'              );
vwin____GetStockObject                    :s3( 0              ,dgdi32         ,'GetStockObject'                   );
vwin____GetCurrentThread                  :s3( 0              ,dkernel32      ,'GetCurrentThread'                 );
vwin____GetCurrentThreadId                :s3( 0              ,dkernel32      ,'GetCurrentThreadId'               );
vwin____ClipCursor                        :s3( 0              ,duser32        ,'ClipCursor'                       );
vwin____GetClipCursor                     :s3( 0              ,duser32        ,'CloseClipboard'                   );
vwin____GetCapture                        :s3( 0              ,duser32        ,'GetCapture'                       );
vwin____SetCapture                        :s3( 0              ,duser32        ,'SetCapture'                       );
vwin____ReleaseCapture                    :s3( 0              ,duser32        ,'ReleaseCapture'                   );
vwin____PostMessage                       :s3( 0              ,duser32        ,'PostMessageA'                     );
vwin____SetClassLong                      :s3( 0              ,duser32        ,'SetClassLongA'                    );
vwin____GetActiveWindow                   :s3( 0              ,duser32        ,'GetActiveWindow'                  );
vwin____ShowCursor                        :s3( 0              ,duser32        ,'ShowCursor'                       );
vwin____SetCursorPos                      :s3( 0              ,duser32        ,'SetCursorPos'                     );
vwin____SetCursor                         :s3( 0              ,duser32        ,'SetCursor'                        );
vwin____GetCursor                         :s3( 0              ,duser32        ,'GetCursor'                        );
vwin____GetCursorPos                      :s3( 0              ,duser32        ,'GetCursorPos'                     );
vwin____GetWindowText                     :s3( 0              ,duser32        ,'GetWindowTextA'                   );
vwin____GetWindowTextLength               :s3( 0              ,duser32        ,'GetWindowTextLengthA'             );
vwin____SetWindowText                     :s3( 0              ,duser32        ,'SetWindowTextA'                   );
vwin____GetModuleHandle                   :s3( 0              ,dkernel32      ,'GetModuleHandleA'                 );
vwin____GetWindowPlacement                :s3( 0              ,duser32        ,'GetWindowPlacement'               );
vwin____SetWindowPlacement                :s3( 0              ,duser32        ,'SetWindowPlacement'               );
vwin____GetTextExtentPoint                :s3( 0              ,dgdi32         ,'GetTextExtentPointA'              );
vwin____TextOut                           :s3( 0              ,dgdi32         ,'TextOutA'                         );
vwin____GetSysColorBrush                  :s3( 0              ,duser32        ,'GetSysColorBrush'                 );
vwin____CreateSolidBrush                  :s3( 0              ,dgdi32         ,'CreateSolidBrush'                 );
vwin____LoadIcon                          :s3( 0              ,duser32        ,'LoadIconA'                        );
vwin____LoadCursor                        :s3( 0              ,duser32        ,'LoadCursorA'                      );
vwin____FillRect                          :s3( 0              ,duser32        ,'FillRect'                         );
vwin____FrameRect                         :s3( 0              ,duser32        ,'FrameRect'                        );
vwin____InvalidateRect                    :s3( 0              ,duser32        ,'InvalidateRect'                   );
vwin____StretchBlt                        :s3( 0              ,dgdi32         ,'StretchBlt'                       );
vwin____GetClientwinrect                  :s3( 0              ,duser32        ,'GetClientwinrect'                 );
vwin____GetWindowRect                     :s3( 0              ,duser32        ,'GetWindowRect'                    );
vwin____GetClientRect                     :s3( 0              ,duser32        ,'GetClientRect'                    );
vwin____MoveWindow                        :s3( 0              ,duser32        ,'MoveWindow'                       );
vwin____SetWindowPos                      :s3( 0              ,duser32        ,'SetWindowPos'                     );
vwin____DestroyWindow                     :s3( 0              ,duser32        ,'DestroyWindow'                    );
vwin____ShowWindow                        :s3( 0              ,duser32        ,'ShowWindow'                       );
vwin____RegisterClassExA                  :s3( 0              ,duser32        ,'RegisterClassExA'                 );
vwin____IsWindowVisible                   :s3( 0              ,duser32        ,'IsWindowVisible'                  );
vwin____IsIconic                          :s3( 0              ,duser32        ,'IsIconic'                         );
vwin____GetWindowDC                       :s3( 0              ,duser32        ,'GetWindowDC'                      );
vwin____ReleaseDC                         :s3( 0              ,duser32        ,'ReleaseDC'                        );
vwin____BeginPaint                        :s3( 0              ,duser32        ,'BeginPaint'                       );
vwin____EndPaint                          :s3( 0              ,duser32        ,'EndPaint'                         );
vwin____SendMessage                       :s3( 0              ,duser32        ,'SendMessageA'                     );
vwin____EnumDisplaySettingsA              :s3( 0              ,duser32        ,'EnumDisplaySettingsA'             );
vwin____CreateDC                          :s3( 0              ,dgdi32         ,'CreateDCA'                        );
vwin____DeleteDC                          :s3( 0              ,dgdi32         ,'DeleteDC'                         );
vwin____GetDeviceCaps                     :s3( 0              ,dgdi32         ,'GetDeviceCaps'                    );
vwin____GetSystemMetrics                  :s3( 0              ,duser32        ,'GetSystemMetrics'                 );
vwin____CreateRectRgn                     :s3( 0              ,dgdi32         ,'CreateRectRgn'                    );
vwin____CreateRoundRectRgn                :s3( 0              ,dgdi32         ,'CreateRoundRectRgn'               );
vwin____GetRgnBox                         :s3( 0              ,dgdi32         ,'GetRgnBox'                        );
vwin____SetWindowRgn                      :s3( 0              ,duser32        ,'SetWindowRgn'                     );
vwin____PostThreadMessage                 :s3( 0              ,duser32        ,'PostThreadMessageA'               );
vwin____SetWindowLong                     :s3( 0              ,duser32        ,'SetWindowLongA'                   );
vwin____GetWindowLong                     :s3( 0              ,duser32        ,'GetWindowLongA'                   );
vwin____CallWindowProc                    :s3( 0              ,duser32        ,'CallWindowProcA'                  );
vwin____SystemParametersInfo              :s3( 0              ,duser32        ,'SystemParametersInfoA'            );
vwin____RegisterClipboardFormat           :s3( 0              ,duser32        ,'RegisterClipboardFormatA'         );
vwin____CountClipboardFormats             :s3( 0              ,duser32        ,'CountClipboardFormats'            );
vwin____ClientToScreen                    :s3( 0              ,duser32        ,'ClientToScreen'                   );
vwin____ScreenToClient                    :s3( 0              ,duser32        ,'ScreenToClient'                   );
vwin____DragAcceptFiles                   :s3( 0              ,dshell32       ,'DragAcceptFiles'                  );
vwin____DragQueryFile                     :s3( 0              ,dshell32       ,'DragQueryFileA'                   );
vwin____DragFinish                        :s3( 0              ,dshell32       ,'DragFinish'                       );
vwin____SetTimer                          :s3( 0              ,duser32        ,'SetTimer'                         );
vwin____KillTimer                         :s3( 0              ,duser32        ,'KillTimer'                        );
vwin____WaitMessage                       :s3( 0              ,duser32        ,'WaitMessage'                      );
vwin____GetProcessHeap                    :s3( 0              ,dkernel32      ,'GetProcessHeap'                   );
vwin____SetPriorityClass                  :s3( 0              ,dkernel32      ,'SetPriorityClass'                 );
vwin____GetPriorityClass                  :s3( 0              ,dkernel32      ,'GetPriorityClass'                 );
vwin____SetThreadPriority                 :s3( 0              ,dkernel32      ,'SetThreadPriority'                );
vwin____SetThreadPriorityBoost            :s3( 0              ,dkernel32      ,'SetThreadPriorityBoost'           );
vwin____GetThreadPriority                 :s3( 0              ,dkernel32      ,'GetThreadPriority'                );
vwin____GetThreadPriorityBoost            :s3( 0              ,dkernel32      ,'GetThreadPriorityBoost'           );
vwin____CoInitializeEx                    :s3( 0              ,dole32         ,'CoInitializeEx'                   );
vwin____CoInitialize                      :s3( 0              ,dole32         ,'CoInitialize'                     );
vwin____CoUninitialize                    :s3( 0              ,dole32         ,'CoUninitialize'                   );
vwin____CreateMutexA                      :s3( 0              ,dkernel32      ,'CreateMutexA'                     );
vwin____ReleaseMutex                      :s3( 0              ,dkernel32      ,'ReleaseMutex'                     );
vwin____WaitForSingleObject               :s3( 0              ,dkernel32      ,'WaitForSingleObject'              );
vwin____WaitForSingleObjectEx             :s3( 0              ,dkernel32      ,'WaitForSingleObjectEx'            );
vwin____CreateEvent                       :s3( 0              ,dkernel32      ,'CreateEventA'                     );
vwin____SetEvent                          :s3( 0              ,dkernel32      ,'SetEvent'                         );
vwin____ResetEvent                        :s3( 0              ,dkernel32      ,'ResetEvent'                       );
vwin____PulseEvent                        :s3( 0              ,dkernel32      ,'PulseEvent'                       );
vwin____InterlockedIncrement              :s3( 0              ,dkernel32      ,'InterlockedIncrement'             );
vwin____InterlockedDecrement              :s3( 0              ,dkernel32      ,'InterlockedDecrement'             );
vwin____GetFileVersionInfoSize            :s3( 0              ,dversion       ,'GetFileVersionInfoSizeA'          );
vwin____GetFileVersionInfo                :s3( 0              ,dversion       ,'GetFileVersionInfoA'              );
vwin____VerQueryValue                     :s3( 0              ,dversion       ,'VerQueryValueA'                   );
vwin____GetCurrentProcessId               :s3( 0              ,dkernel32      ,'GetCurrentProcessId'              );
vwin____ExitProcess                       :s3( 0              ,dkernel32      ,'ExitProcess'                      );
vwin____GetExitCodeProcess                :s3( 0              ,dkernel32      ,'GetExitCodeProcess'               );
vwin____CreateThread                      :s3( 0              ,dkernel32      ,'CreateThread'                     );
vwin____SuspendThread                     :s3( 0              ,dkernel32      ,'SuspendThread'                    );
vwin____ResumeThread                      :s3( 0              ,dkernel32      ,'ResumeThread'                     );
vwin____GetCurrentProcess                 :s3( 0              ,dkernel32      ,'GetCurrentProcess'                );
vwin____GetLastError                      :s3( 0              ,dkernel32      ,'GetLastError'                     );
vwin____GetStdHandle                      :s3( 0              ,dkernel32      ,'GetStdHandle'                     );
vwin____SetStdHandle                      :s3( 0              ,dkernel32      ,'SetStdHandle'                     );
vwin____GetConsoleScreenBufferInfo        :s3( 0              ,dkernel32      ,'GetConsoleScreenBufferInfo'       );
vwin____FillConsoleOutputCharacter        :s3( 0              ,dkernel32      ,'FillConsoleOutputCharacterA'      );
vwin____FillConsoleOutputAttribute        :s3( 0              ,dkernel32      ,'FillConsoleOutputAttribute'       );
vwin____GetConsoleMode                    :s3( 0              ,dkernel32      ,'GetConsoleMode'                   );
vwin____SetConsoleCursorPosition          :s3( 0              ,dkernel32      ,'SetConsoleCursorPosition'         );
vwin____SetConsoleTitle                   :s3( 0              ,dkernel32      ,'SetConsoleTitleA'                 );
vwin____SetConsoleCtrlHandler             :s3( 0              ,dkernel32      ,'SetConsoleCtrlHandler'            );
vwin____GetNumberOfConsoleInputEvents     :s3( 0              ,dkernel32      ,'GetNumberOfConsoleInputEvents'    );
vwin____ReadConsoleInput                  :s3( 0              ,dkernel32      ,'ReadConsoleInputA'                );
vwin____GetMessage                        :s3( 0              ,duser32        ,'GetMessageA'                      );
vwin____PeekMessage                       :s3( 0              ,duser32        ,'PeekMessageA'                     );
vwin____DispatchMessage                   :s3( 0              ,duser32        ,'DispatchMessageA'                 );
vwin____TranslateMessage                  :s3( 0              ,duser32        ,'TranslateMessage'                 );
vwin____GetDriveType                      :s3( 0              ,dkernel32      ,'GetDriveTypeA'                    );
vwin____SetErrorMode                      :s3( 0              ,dkernel32      ,'SetErrorMode'                     );
vwin____ExitThread                        :s3( 0              ,dkernel32      ,'ExitThread'                       );
vwin____TerminateThread                   :s3( 0              ,dkernel32      ,'TerminateThread'                  );
vwin____QueryPerformanceCounter           :s3( 0              ,dkernel32      ,'QueryPerformanceCounter'          );
vwin____QueryPerformanceFrequency         :s3( 0              ,dkernel32      ,'QueryPerformanceFrequency'        );
vwin____GetVolumeInformation              :s3( 0              ,dkernel32      ,'GetVolumeInformationA'            );
vwin____GetShortPathName                  :s3( 0              ,dkernel32      ,'GetShortPathNameA'                );
vwin____SHGetSpecialFolderLocation        :s3( 0              ,dshell32       ,'SHGetSpecialFolderLocation'       );
vwin____SHGetPathFromIDList               :s3( 0              ,dshell32       ,'SHGetPathFromIDListA'             );
vwin____GetWindowsDirectoryA              :s3( 0              ,dkernel32      ,'GetWindowsDirectoryA'             );
vwin____GetSystemDirectoryA               :s3( 0              ,dkernel32      ,'GetSystemDirectoryA'              );
vwin____GetTempPathA                      :s3( 0              ,dkernel32      ,'GetTempPathA'                     );
vwin____FlushFileBuffers                  :s3( 0              ,dkernel32      ,'FlushFileBuffers'                 );
vwin____CreateFile                        :s3( 0              ,dkernel32      ,'CreateFileA'                      );
vwin____GetFileSize                       :s3( 0              ,dkernel32      ,'GetFileSize'                      );
vwin____GetSystemTime                     :s3( 0              ,dkernel32      ,'GetSystemTime'                    );
vwin____CloseHandle                       :s3( 0              ,dkernel32      ,'CloseHandle'                      );
vwin____GetFileInformationByHandle        :s3( 0              ,dkernel32      ,'GetFileInformationByHandle'       );
vwin____SetFilePointer                    :s3( 0              ,dkernel32      ,'SetFilePointer'                   );
vwin____SetEndOfFile                      :s3( 0              ,dkernel32      ,'SetEndOfFile'                     );
vwin____WriteFile                         :s3( 0              ,dkernel32      ,'WriteFile'                        );
vwin____ReadFile                          :s3( 0              ,dkernel32      ,'ReadFile'                         );
vwin____GetLogicalDrives                  :s3( 0              ,dkernel32      ,'GetLogicalDrives'                 );
vwin____FileTimeToLocalFileTime           :s3( 0              ,dkernel32      ,'FileTimeToLocalFileTime'          );
vwin____FileTimeToDosDateTime             :s3( 0              ,dkernel32      ,'FileTimeToDosDateTime'            );
vwin____DefWindowProc                     :s3( 0              ,duser32        ,'DefWindowProcA'                   );
vwin____RegisterClass                     :s3( 0              ,duser32        ,'RegisterClassA'                   );
vwin____RegisterClassA                    :s3( 0              ,duser32        ,'RegisterClassA'                   );
vwin____CreateWindowEx                    :s3( 0              ,duser32        ,'CreateWindowExA'                  );
vwin____EnableWindow                      :s3( 0              ,duser32        ,'EnableWindow'                     );
vwin____IsWindowEnabled                   :s3( 0              ,duser32        ,'IsWindowEnabled'                  );
vwin____UpdateWindow                      :s3( 0              ,duser32        ,'UpdateWindow'                     );
vwin____ShellExecute                      :s3( 0              ,dshell32       ,'ShellExecuteA'                    );
vwin____ShellExecuteEx                    :s3( 0              ,dshell32       ,'ShellExecuteExA'                  );
vwin____SHGetMalloc                       :s3( 0              ,dshell32       ,'SHGetMalloc'                      );
vwin____CoCreateInstance                  :s3( 0              ,dole32         ,'CoCreateInstance'                 );
vwin____GetObject                         :s3( 0              ,dgdi32         ,'GetObjectA'                       );
vwin____CreateFontIndirect                :s3( 0              ,dgdi32         ,'CreateFontIndirectA'              );
vwin____SelectObject                      :s3( 0              ,dgdi32         ,'SelectObject'                     );
vwin____DeleteObject                      :s3( 0              ,dgdi32         ,'DeleteObject'                     );
vwin____sleep                             :s3( 0              ,dkernel32      ,'Sleep'                            );
vwin____sleepex                           :s3( 0              ,dkernel32      ,'SleepEx'                          );
vwin____RegConnectRegistry                :s3( 0              ,dadvapi32      ,'RegConnectRegistryA'              );
vwin___RegCreateKeyEx                     :s3( 0              ,dadvapi32      ,'RegCreateKeyExA'                  );
vwin____RegOpenKey                        :s3( 0              ,dadvapi32      ,'RegOpenKeyA'                      );
vwin____RegCloseKey                       :s3( 0              ,dadvapi32      ,'RegCloseKey'                      );
vwin____RegDeleteKey                      :s3( 0              ,dadvapi32      ,'RegDeleteKeyA'                    );
vwin____RegOpenKeyEx                      :s3( 0              ,dadvapi32      ,'RegOpenKeyExA'                    );
vwin____RegQueryValueEx                   :s3( 0              ,dadvapi32      ,'RegQueryValueExA'                 );
vwin____RegSetValueEx                     :s3( 0              ,dadvapi32      ,'RegSetValueExA'                   );
vwin____StartServiceCtrlDispatcher        :s3( 0              ,dadvapi32      ,'StartServiceCtrlDispatcherA'      );
vwin____RegisterServiceCtrlHandler        :s3( 0              ,dadvapi32      ,'RegisterServiceCtrlHandlerA'      );
vwin____SetServiceStatus                  :s3( 0              ,dadvapi32      ,'SetServiceStatus'                 );
vwin____OpenSCManager                     :s3( 0              ,dadvapi32      ,'OpenSCManagerA'                   );
vwin____CloseServiceHandle                :s3( 0              ,dadvapi32      ,'CloseServiceHandle'               );
vwin____CreateService                     :s3( 0              ,dadvapi32      ,'CreateServiceA'                   );
vwin____OpenService                       :s3( 0              ,dadvapi32      ,'OpenServiceA'                     );
vwin____DeleteService                     :s3( 0              ,dadvapi32      ,'DeleteService'                    );
vwin____timeGetTime                       :s3( 0              ,dwinmm         ,'timeGetTime'                      );
vwin____timeSetEvent                      :s3( 0              ,dwinmm         ,'timeSetEvent'                     );
vwin____timeKillEvent                     :s3( 0              ,dwinmm         ,'timeKillEvent'                    );
vwin____timeBeginPeriod                   :s3( 0              ,dwinmm         ,'timeBeginPeriod'                  );
vwin____timeEndPeriod                     :s3( 0              ,dwinmm         ,'timeEndPeriod'                    );
vnet____WSAStartup                        :s3( 0              ,dwsock32       ,'WSAStartup'                       );
vnet____WSACleanup                        :s3( 0              ,dwsock32       ,'WSACleanup'                       );
vnet____wsaasyncselect                    :s3( 0              ,dwsock32       ,'WSAAsyncSelect'                   );
vnet____WSAGetLastError                   :s3( 0              ,dwsock32       ,'WSAGetLastError'                  );
vnet____makesocket                        :s3( 0              ,dwsock32       ,'socket'                           );
vnet____bind                              :s3( 0              ,dwsock32       ,'bind'                             );
vnet____listen                            :s3( 0              ,dwsock32       ,'listen'                           );
vnet____closesocket                       :s3( 0              ,dwsock32       ,'closesocket'                      );
vnet____getsockopt                        :s3( 0              ,dwsock32       ,'getsockopt'                       );
vnet____accept                            :s3( 0              ,dwsock32       ,'accept'                           );
vnet____recv                              :s3( 0              ,dwsock32       ,'recv'                             );
vnet____send                              :s3( 0              ,dwsock32       ,'send'                             );
vnet____getpeername                       :s3( 0              ,dwsock32       ,'getpeername'                      );
vnet____connect                           :s3( 0              ,dwsock32       ,'connect'                          );
vnet____ioctlsocket                       :s3( 0              ,dwsock32       ,'ioctlsocket'                      );
vwin____FindFirstFile                     :s3( 0              ,dkernel32      ,'FindFirstFileA'                   );
vwin____FindNextFile                      :s3( 0              ,dkernel32      ,'FindNextFileA'                    );
vwin____FindClose                         :s3( 0              ,dkernel32      ,'FindClose'                        );
vwin____RemoveDirectory                   :s3( 0              ,dkernel32      ,'RemoveDirectoryA'                 );
vwin____waveOutGetDevCaps                 :s3( 0              ,dwinmm         ,'waveOutGetDevCapsA'               );
vwin____waveOutOpen                       :s3( 0              ,dwinmm         ,'waveOutOpen'                      );
vwin____waveOutClose                      :s3( 0              ,dwinmm         ,'waveOutClose'                     );
vwin____waveOutPrepareHeader              :s3( 0              ,dwinmm         ,'waveOutPrepareHeader'             );
vwin____waveOutUnprepareHeader            :s3( 0              ,dwinmm         ,'waveOutUnprepareHeader'           );
vwin____waveOutWrite                      :s3( 0              ,dwinmm         ,'waveOutWrite'                     );
vwin____waveInOpen                        :s3( 0              ,dwinmm         ,'waveInOpen'                       );
vwin____waveInClose                       :s3( 0              ,dwinmm         ,'waveInClose'                      );
vwin____waveInPrepareHeader               :s3( 0              ,dwinmm         ,'waveInPrepareHeader'              );
vwin____waveInUnprepareHeader             :s3( 0              ,dwinmm         ,'waveInUnprepareHeader'            );
vwin____waveInAddBuffer                   :s3( 0              ,dwinmm         ,'waveInAddBuffer'                  );
vwin____waveInStart                       :s3( 0              ,dwinmm         ,'waveInStart'                      );
vwin____waveInStop                        :s3( 0              ,dwinmm         ,'waveInStop'                       );
vwin____waveInReset                       :s3( 0              ,dwinmm         ,'waveInReset'                      );
vwin____midiOutGetNumDevs                 :s3( 0              ,dwinmm         ,'midiOutGetNumDevs'                );
vwin____midiOutGetDevCaps                 :s3( 0              ,dwinmm         ,'midiOutGetDevCapsA'               );
vwin____midiOutOpen                       :s3( 0              ,dwinmm         ,'midiOutOpen'                      );
vwin____midiOutClose                      :s3( 0              ,dwinmm         ,'midiOutClose'                     );
vwin____midiOutReset                      :s3( 0              ,dwinmm         ,'midiOutReset'                     );
vwin____midiOutShortMsg                   :s3( 0              ,dwinmm         ,'midiOutShortMsg'                  );
vwin____mciSendCommand                    :s3( 0              ,dwinmm         ,'mciSendCommandA'                  );
vwin____mciGetErrorString                 :s3( 0              ,dwinmm         ,'mciGetErrorStringA'               );
vwin____waveOutGetVolume                  :s3( 0              ,dwinmm         ,'waveOutGetVolume'                 );
vwin____waveOutSetVolume                  :s3( 0              ,dwinmm         ,'waveOutSetVolume'                 );
vwin____midiOutGetVolume                  :s3( 0              ,dwinmm         ,'midiOutGetVolume'                 );
vwin____midiOutSetVolume                  :s3( 0              ,dwinmm         ,'midiOutSetVolume'                 );
vwin____auxSetVolume                      :s3( 0              ,dwinmm         ,'auxSetVolume'                     );
vwin____auxGetVolume                      :s3( 0              ,dwinmm         ,'auxGetVolume'                     );
vwin2____GetGuiResources                  :s3( 0              ,duser32        ,'GetGuiResources'                  );
vwin2____SetProcessDpiAwarenessContext    :s3( 0              ,duser32        ,'SetProcessDpiAwarenessContext'    );
vwin2____GetMonitorInfo                   :s3( 0              ,duser32        ,'GetMonitorInfoA'                  );
vwin2____EnumDisplayMonitors              :s3( 0              ,duser32        ,'EnumDisplayMonitors'              );
vwin2____GetDpiForMonitor                 :s3( -2147467259    ,dShcore        ,'GetDpiForMonitor'                 );//custom return value
vwin2____SetLayeredWindowAttributes       :s3( 0              ,duser32        ,'SetLayeredWindowAttributes'       );
vwin2____XInputGetState                   :s3( -2147467259    ,dxinput1_4     ,'XInputGetState'                   );//custom return value
vwin2____XInputSetState                   :s3( -2147467259    ,dxinput1_4     ,'XInputSetState'                   );//custom return value
vwin2____GetFileVersionInfoSize           :s3( 0              ,dversion       ,'GetFileVersionInfoSizeA'          );
vwin2____GetFileVersionInfo               :s3( 0              ,dversion       ,'GetFileVersionInfoA'              );
vwin2____VerQueryValue                    :s3( 0              ,dversion       ,'VerQueryValueA'                   );
-1:;//placeholder
end;//case

end;


//function win____ChooseColor(var CC: TChooseColor): Bool; stdcall; external comdlg32  name 'ChooseColorA';;

function win____ChooseColor(var CC: TChooseColor):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ChooseColor,a) then result:=twin____ChooseColor(a)(CC);
win__dec;
end;


//function win____GetSaveFileName(var OpenFile: TOpenFilename): Bool; stdcall; external comdlg32  name 'GetSaveFileNameA';;

function win____GetSaveFileName(var OpenFile: TOpenFilename):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetSaveFileName,a) then result:=twin____GetSaveFileName(a)(OpenFile);
win__dec;
end;


//function win____GetOpenFileName(var OpenFile: TOpenFilename): Bool; stdcall; external comdlg32 name 'GetOpenFileNameA';;

function win____GetOpenFileName(var OpenFile: TOpenFilename):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetOpenFileName,a) then result:=twin____GetOpenFileName(a)(OpenFile);
win__dec;
end;


//function win____RedrawWindow(hWnd: HWND; lprcUpdate: pwinrect; hrgnUpdate: HRGN; flags: UINT): BOOL; stdcall; external user32 name 'RedrawWindow';;

function win____RedrawWindow(hWnd: HWND; lprcUpdate: pwinrect; hrgnUpdate: HRGN; flags: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____RedrawWindow,a) then result:=twin____RedrawWindow(a)(hWnd, lprcUpdate, hrgnUpdate, flags);
win__dec;
end;


//function win____CreatePopupMenu:HMENU; stdcall; external user32 name 'CreatePopupMenu';;

function win____CreatePopupMenu:hmenu;
var
   a:pointer;
begin
if win__useint(result,vwin____CreatePopupMenu,a) then result:=twin____CreatePopupMenu(a);
win__dec;
end;


//function win____AppendMenu(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: PChar): BOOL; stdcall; external user32 name 'AppendMenuA';;

function win____AppendMenu(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: PChar):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____AppendMenu,a) then result:=twin____AppendMenu(a)(hMenu, uFlags, uIDNewItem, lpNewItem);
win__dec;
end;


//function win____GetSubMenu(hMenu: HMENU; nPos: Integer): HMENU; stdcall; external user32 name 'GetSubMenu';;

function win____GetSubMenu(hMenu: HMENU; nPos: Integer):hmenu;
var
   a:pointer;
begin
if win__useint(result,vwin____GetSubMenu,a) then result:=twin____GetSubMenu(a)(hMenu, nPos);
win__dec;
end;


//function win____GetMenuItemID(hMenu: HMENU; nPos: Integer): UINT; stdcall; external user32 name 'GetMenuItemID';;

function win____GetMenuItemID(hMenu: HMENU; nPos: Integer):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____GetMenuItemID,a) then result:=twin____GetMenuItemID(a)(hMenu, nPos);
win__dec;
end;


//function win____GetMenuItemCount(hMenu: HMENU): Integer; stdcall; external user32 name 'GetMenuItemCount';;

function win____GetMenuItemCount(hMenu: HMENU):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetMenuItemCount,a) then result:=twin____GetMenuItemCount(a)(hMenu);
win__dec;
end;


//function win____CheckMenuItem(hMenu: HMENU; uIDCheckItem, uCheck: UINT): DWORD; stdcall; external user32 name 'CheckMenuItem';;

function win____CheckMenuItem(hMenu: HMENU; uIDCheckItem, uCheck: UINT):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____CheckMenuItem,a) then result:=twin____CheckMenuItem(a)(hMenu, uIDCheckItem, uCheck);
win__dec;
end;


//function win____EnableMenuItem(hMenu: HMENU; uIDEnableItem, uEnable: UINT): BOOL; stdcall; external user32 name 'EnableMenuItem';;

function win____EnableMenuItem(hMenu: HMENU; uIDEnableItem, uEnable: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____EnableMenuItem,a) then result:=twin____EnableMenuItem(a)(hMenu, uIDEnableItem, uEnable);
win__dec;
end;


//function win____InsertMenuItem(p1: HMENU; p2: UINT; p3: BOOL; const p4: twinmenuiteminfo): BOOL; stdcall; external user32 name 'InsertMenuItemA';;

function win____InsertMenuItem(p1: HMENU; p2: UINT; p3: BOOL; const p4: twinmenuiteminfo):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____InsertMenuItem,a) then result:=twin____InsertMenuItem(a)(p1, p2, p3, p4);
win__dec;
end;


//function win____DestroyMenu(hMenu: HMENU): BOOL; stdcall; external user32 name 'DestroyMenu';;

function win____DestroyMenu(hMenu: HMENU):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____DestroyMenu,a) then result:=twin____DestroyMenu(a)(hMenu);
win__dec;
end;


//function win____TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x, y, nReserved: Integer; hWnd: HWND; prcRect: pwinrect): BOOL; stdcall; external user32 name 'TrackPopupMenu';;

function win____TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x, y, nReserved: Integer; hWnd: HWND; prcRect: pwinrect):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____TrackPopupMenu,a) then result:=twin____TrackPopupMenu(a)(hMenu, uFlags, x, y, nReserved, hWnd, prcRect);
win__dec;
end;


//function win____GetFocus:HWND; stdcall; stdcall; external user32 name 'GetFocus';;

function win____GetFocus:hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____GetFocus,a) then result:=twin____GetFocus(a);
win__dec;
end;


//function win____SetFocus(hWnd: HWND): HWND; stdcall; external user32 name 'SetFocus';;

function win____SetFocus(hWnd: HWND):hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____SetFocus,a) then result:=twin____SetFocus(a)(hWnd);
win__dec;
end;


//function win____GetParent(hWnd: HWND): HWND; stdcall; external user32 name 'GetParent';;

function win____GetParent(hWnd: HWND):hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____GetParent,a) then result:=twin____GetParent(a)(hWnd);
win__dec;
end;


//function win____SetParent(hWndChild, hWndNewParent: HWND): HWND; stdcall; external user32 name 'SetParent';;

function win____SetParent(hWndChild, hWndNewParent: HWND):hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____SetParent,a) then result:=twin____SetParent(a)(hWndChild, hWndNewParent);
win__dec;
end;


//function win____CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall; external kernel32 name 'CreateDirectoryA';;

function win____CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____CreateDirectory,a) then result:=twin____CreateDirectory(a)(lpPathName, lpSecurityAttributes);
win__dec;
end;


//function win____GetFileAttributes(lpFileName: PChar): DWORD; stdcall; external kernel32 name 'GetFileAttributesA';;

function win____GetFileAttributes(lpFileName: PChar):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetFileAttributes,a) then result:=twin____GetFileAttributes(a)(lpFileName);
win__dec;
end;


//procedure win____GetLocalTime(var lpSystemTime: TSystemTime); stdcall; external kernel32 name 'GetLocalTime';;

procedure win____GetLocalTime(var lpSystemTime: TSystemTime);
var
   a:pointer;
begin
if win__use(vwin____GetLocalTime,a) then twin____GetLocalTime(a)(lpSystemTime);
win__dec;
end;


//function win____SetLocalTime(const lpSystemTime: TSystemTime): BOOL; stdcall; external kernel32 name 'SetLocalTime';;

function win____SetLocalTime(const lpSystemTime: TSystemTime):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetLocalTime,a) then result:=twin____SetLocalTime(a)(lpSystemTime);
win__dec;
end;


//function win____DeleteFile(lpFileName: PChar): BOOL; stdcall; external kernel32 name 'DeleteFileA';;

function win____DeleteFile(lpFileName: PChar):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____DeleteFile,a) then result:=twin____DeleteFile(a)(lpFileName);
win__dec;
end;


//function win____MoveFile(lpExistingFileName, lpNewFileName: PChar): BOOL; stdcall; external kernel32 name 'MoveFileA';;

function win____MoveFile(lpExistingFileName, lpNewFileName: PChar):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____MoveFile,a) then result:=twin____MoveFile(a)(lpExistingFileName, lpNewFileName);
win__dec;
end;


//function win____SetFileAttributes(lpFileName: PChar; dwFileAttributes: DWORD): BOOL; stdcall; external kernel32 name 'SetFileAttributesA';;

function win____SetFileAttributes(lpFileName: PChar; dwFileAttributes: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetFileAttributes,a) then result:=twin____SetFileAttributes(a)(lpFileName, dwFileAttributes);
win__dec;
end;


//function win____GetBitmapBits(Bitmap: HBITMAP; Count: Longint; Bits: Pointer): Longint; stdcall; external gdi32 name 'GetBitmapBits';;

function win____GetBitmapBits(Bitmap: HBITMAP; Count: Longint; Bits: Pointer):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____GetBitmapBits,a) then result:=twin____GetBitmapBits(a)(Bitmap, Count, Bits);
win__dec;
end;


//function win____GetDIBits(DC: HDC; Bitmap: HBitmap; StartScan, NumScans: UINT; Bits: Pointer; var BitInfo: TBitmapInfoHeader; Usage: UINT): Integer; stdcall; external gdi32 name 'GetDIBits';;

function win____GetDIBits(DC: HDC; Bitmap: HBitmap; StartScan, NumScans: UINT; Bits: Pointer; var BitInfo: TBitmapInfoHeader; Usage: UINT):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetDIBits,a) then result:=twin____GetDIBits(a)(DC, Bitmap, StartScan, NumScans, Bits, BitInfo, Usage);
win__dec;
end;


//function win____IsClipboardFormatAvailable(format: UINT): BOOL; stdcall; external user32 name 'IsClipboardFormatAvailable';;

function win____IsClipboardFormatAvailable(format: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____IsClipboardFormatAvailable,a) then result:=twin____IsClipboardFormatAvailable(a)(format);
win__dec;
end;


//function win____EmptyClipboard: BOOL; stdcall; external user32 name 'EmptyClipboard';;

function win____EmptyClipboard:bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____EmptyClipboard,a) then result:=twin____EmptyClipboard(a);
win__dec;
end;


//function win____OpenClipboard(hWndNewOwner: HWND): BOOL; stdcall; external user32 name 'OpenClipboard';;

function win____OpenClipboard(hWndNewOwner: HWND):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____OpenClipboard,a) then result:=twin____OpenClipboard(a)(hWndNewOwner);
win__dec;
end;


//function win____CloseClipboard: BOOL; stdcall; external user32 name 'CloseClipboard';;

function win____CloseClipboard:bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____CloseClipboard,a) then result:=twin____CloseClipboard(a);
win__dec;
end;


//function win____GdiFlush: BOOL; stdcall; external gdi32 name 'GdiFlush';;

function win____GdiFlush:bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GdiFlush,a) then result:=twin____GdiFlush(a);
win__dec;
end;


//function win____CreateCompatibleDC(DC: HDC): HDC; stdcall; external gdi32 name 'CreateCompatibleDC';;

function win____CreateCompatibleDC(DC: HDC):hdc;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateCompatibleDC,a) then result:=twin____CreateCompatibleDC(a)(DC);
win__dec;
end;


//function win____CreateDIBSection(DC: HDC; const p2: TBitmapInfoHeader; p3: UINT; var p4: Pointer; p5: THandle; p6: DWORD): HBITMAP; stdcall; external gdi32 name 'CreateDIBSection';;

function win____CreateDIBSection(DC: HDC; const p2: TBitmapInfoHeader; p3: UINT; var p4: Pointer; p5: THandle; p6: DWORD):hbitmap;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateDIBSection,a) then result:=twin____CreateDIBSection(a)(DC, p2, p3, p4, p5, p6);
win__dec;
end;


//function win____CreateCompatibleBitmap(DC: HDC; Width, Height: Integer): HBITMAP; stdcall; external gdi32 name 'CreateCompatibleBitmap';;

function win____CreateCompatibleBitmap(DC: HDC; Width, Height: Integer):hbitmap;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateCompatibleBitmap,a) then result:=twin____CreateCompatibleBitmap(a)(DC, Width, Height);
win__dec;
end;


//function win____CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; Bits: Pointer): HBITMAP; stdcall; external gdi32 name 'CreateBitmap';;

function win____CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; Bits: Pointer):hbitmap;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateBitmap,a) then result:=twin____CreateBitmap(a)(Width, Height, Planes, BitCount, Bits);
win__dec;
end;


//function win____SetTextColor(DC: HDC; Color: COLORREF): COLORREF; stdcall; external gdi32 name 'SetTextColor';;

function win____SetTextColor(DC: HDC; Color: COLORREF):colorref;
var
   a:pointer;
begin
if win__useint(result,vwin____SetTextColor,a) then result:=twin____SetTextColor(a)(DC, Color);
win__dec;
end;


//function win____SetBkColor(DC: HDC; Color: COLORREF): COLORREF; stdcall; external gdi32 name 'SetBkColor';;

function win____SetBkColor(DC: HDC; Color: COLORREF):colorref;
var
   a:pointer;
begin
if win__useint(result,vwin____SetBkColor,a) then result:=twin____SetBkColor(a)(DC, Color);
win__dec;
end;


//function win____SetBkMode(DC: HDC; BkMode: Integer): Integer; stdcall; external gdi32 name 'SetBkMode';;

function win____SetBkMode(DC: HDC; BkMode: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____SetBkMode,a) then result:=twin____SetBkMode(a)(DC, BkMode);
win__dec;
end;


//function win____CreateBrushIndirect(const p1: TLogBrush): HBRUSH; stdcall; external gdi32 name 'CreateBrushIndirect';;

function win____CreateBrushIndirect(const p1: TLogBrush):hbrush;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateBrushIndirect,a) then result:=twin____CreateBrushIndirect(a)(p1);
win__dec;
end;


//function win____MulDiv(nNumber, nNumerator, nDenominator: Integer): Integer; stdcall; external kernel32 name 'MulDiv';;

function win____MulDiv(nNumber, nNumerator, nDenominator: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____MulDiv,a) then result:=twin____MulDiv(a)(nNumber, nNumerator, nDenominator);
win__dec;
end;


//function win____GetSysColor(nIndex: Integer): DWORD; stdcall; external user32 name 'GetSysColor';;

function win____GetSysColor(nIndex: Integer):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetSysColor,a) then result:=twin____GetSysColor(a)(nIndex);
win__dec;
end;


//function win____ExtTextOut(DC: HDC; X, Y: Integer; Options: Longint; Rect: PwinRect; Str: PChar; Count: Longint; Dx: PInteger): BOOL; stdcall; external gdi32 name 'ExtTextOutA';;

function win____ExtTextOut(DC: HDC; X, Y: Integer; Options: Longint; Rect: PwinRect; Str: PChar; Count: Longint; Dx: PInteger):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ExtTextOut,a) then result:=twin____ExtTextOut(a)(DC, X, Y, Options, Rect, Str, Count, Dx);
win__dec;
end;


//function win____GetDesktopWindow: HWND; stdcall; external user32 name 'GetDesktopWindow';;

function win____GetDesktopWindow:hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____GetDesktopWindow,a) then result:=twin____GetDesktopWindow(a);
win__dec;
end;


//function win____HeapAlloc(hHeap: THandle; dwFlags, dwBytes: DWORD): Pointer; stdcall; external kernel32 name 'HeapAlloc';;

function win____HeapAlloc(hHeap: THandle; dwFlags, dwBytes: DWORD):pointer;
var
   a:pointer;
begin
if win__useptr(result,vwin____HeapAlloc,a) then result:=twin____HeapAlloc(a)(hHeap, dwFlags, dwBytes);
win__dec;
end;


//function win____HeapReAlloc(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD): Pointer; stdcall; external kernel32 name 'HeapReAlloc';;

function win____HeapReAlloc(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD):pointer;
var
   a:pointer;
begin
if win__useptr(result,vwin____HeapReAlloc,a) then result:=twin____HeapReAlloc(a)(hHeap, dwFlags, lpMem, dwBytes);
win__dec;
end;


//function win____HeapSize(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): DWORD; stdcall; external kernel32 name 'HeapSize';;

function win____HeapSize(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____HeapSize,a) then result:=twin____HeapSize(a)(hHeap, dwFlags, lpMem);
win__dec;
end;


//function win____HeapFree(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL; stdcall; external kernel32 name 'HeapFree';;

function win____HeapFree(hHeap: THandle; dwFlags: DWORD; lpMem: Pointer):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____HeapFree,a) then result:=twin____HeapFree(a)(hHeap, dwFlags, lpMem);
win__dec;
end;


//function win____GlobalHandle(Mem: Pointer): HGLOBAL; stdcall; external kernel32 name 'GlobalHandle';;

function win____GlobalHandle(Mem: Pointer):hglobal;
var
   a:pointer;
begin
if win__useint(result,vwin____GlobalHandle,a) then result:=twin____GlobalHandle(a)(Mem);
win__dec;
end;


//function win____GlobalSize(hMem: HGLOBAL): DWORD; stdcall; external kernel32 name 'GlobalSize';;

function win____GlobalSize(hMem: HGLOBAL):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GlobalSize,a) then result:=twin____GlobalSize(a)(hMem);
win__dec;
end;


//function win____GlobalFree(hMem: HGLOBAL): HGLOBAL; stdcall; external kernel32 name 'GlobalFree';;

function win____GlobalFree(hMem: HGLOBAL):hglobal;
var
   a:pointer;
begin
if win__useint(result,vwin____GlobalFree,a) then result:=twin____GlobalFree(a)(hMem);
win__dec;
end;


//function win____GlobalUnlock(hMem: HGLOBAL): BOOL; stdcall; external kernel32 name 'GlobalUnlock';;

function win____GlobalUnlock(hMem: HGLOBAL):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GlobalUnlock,a) then result:=twin____GlobalUnlock(a)(hMem);
win__dec;
end;


//function win____GetClipboardData(uFormat: UINT): THandle; stdcall; external user32 name 'GetClipboardData';;

function win____GetClipboardData(uFormat: UINT):thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____GetClipboardData,a) then result:=twin____GetClipboardData(a)(uFormat);
win__dec;
end;


//function win____SetClipboardData(uFormat: UINT; hMem: THandle): THandle; stdcall; external user32 name 'SetClipboardData';;

function win____SetClipboardData(uFormat: UINT; hMem: THandle):thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____SetClipboardData,a) then result:=twin____SetClipboardData(a)(uFormat, hMem);
win__dec;
end;


//function win____GlobalLock(hMem: HGLOBAL): Pointer; stdcall; external kernel32 name 'GlobalLock';;

function win____GlobalLock(hMem: HGLOBAL):pointer;
var
   a:pointer;
begin
if win__useptr(result,vwin____GlobalLock,a) then result:=twin____GlobalLock(a)(hMem);
win__dec;
end;


//function win____GlobalAlloc(uFlags: UINT; dwBytes: DWORD): HGLOBAL; stdcall; external kernel32 name 'GlobalAlloc';;

function win____GlobalAlloc(uFlags: UINT; dwBytes: DWORD):hglobal;
var
   a:pointer;
begin
if win__useint(result,vwin____GlobalAlloc,a) then result:=twin____GlobalAlloc(a)(uFlags, dwBytes);
win__dec;
end;


//function win____GlobalReAlloc(hMem: HGLOBAL; dwBytes: DWORD; uFlags: UINT): HGLOBAL; stdcall; external kernel32 name 'GlobalReAlloc';;

function win____GlobalReAlloc(hMem: HGLOBAL; dwBytes: DWORD; uFlags: UINT):hglobal;
var
   a:pointer;
begin
if win__useint(result,vwin____GlobalReAlloc,a) then result:=twin____GlobalReAlloc(a)(hMem, dwBytes, uFlags);
win__dec;
end;


//function win____LoadCursorFromFile(lpFileName: PAnsiChar): HCURSOR; stdcall; external user32 name 'LoadCursorFromFileA';;

function win____LoadCursorFromFile(lpFileName: PAnsiChar):hcursor;
var
   a:pointer;
begin
if win__useint(result,vwin____LoadCursorFromFile,a) then result:=twin____LoadCursorFromFile(a)(lpFileName);
win__dec;
end;


//function win____GetDefaultPrinter(xbuffer:pointer;var xsize:longint):bool; stdcall; external winspl name 'GetDefaultPrinterA';;

function win____GetDefaultPrinter(xbuffer:pointer;var xsize:longint):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetDefaultPrinter,a) then result:=twin____GetDefaultPrinter(a)(xbuffer, xsize);
win__dec;
end;


//function win____GetVersionEx(var lpVersionInformation: TOSVersionInfo): BOOL; stdcall; external kernel32 name 'GetVersionExA';;

function win____GetVersionEx(var lpVersionInformation: TOSVersionInfo):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetVersionEx,a) then result:=twin____GetVersionEx(a)(lpVersionInformation);
win__dec;
end;


//function win____EnumPrinters(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL; stdcall; external winspl name 'EnumPrintersA';;

function win____EnumPrinters(Flags: DWORD; Name: PChar; Level: DWORD; pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____EnumPrinters,a) then result:=twin____EnumPrinters(a)(Flags, Name, Level, pPrinterEnum, cbBuf, pcbNeeded, pcReturned);
win__dec;
end;


//function win____CreateIC(lpszDriver, lpszDevice, lpszOutput: PChar; lpdvmInit: PDeviceModeA): HDC; stdcall; external gdi32 name 'CreateICA';;

function win____CreateIC(lpszDriver, lpszDevice, lpszOutput: PChar; lpdvmInit: PDeviceModeA):hdc;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateIC,a) then result:=twin____CreateIC(a)(lpszDriver, lpszDevice, lpszOutput, lpdvmInit);
win__dec;
end;


//function win____GetProfileString(lpAppName, lpKeyName, lpDefault: PChar; lpReturnedString: PChar; nSize: DWORD): DWORD; stdcall; external kernel32 name 'GetProfileStringA';;

function win____GetProfileString(lpAppName, lpKeyName, lpDefault: PChar; lpReturnedString: PChar; nSize: DWORD):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetProfileString,a) then result:=twin____GetProfileString(a)(lpAppName, lpKeyName, lpDefault, lpReturnedString, nSize);
win__dec;
end;


//function win____GetDC(hWnd: HWND): HDC; stdcall; external user32 name 'GetDC';;

function win____GetDC(hWnd: HWND):hdc;
var
   a:pointer;
begin
if win__useint(result,vwin____GetDC,a) then result:=twin____GetDC(a)(hWnd);
win__dec;
end;


//function win____GetVersion: DWORD; stdcall; external kernel32 name 'GetVersion';;

function win____GetVersion:dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetVersion,a) then result:=twin____GetVersion(a);
win__dec;
end;


//function win____EnumFonts(DC: HDC; lpszFace: PChar; fntenmprc: TFarProc; lpszData: PChar): Integer; stdcall; external gdi32 name 'EnumFontsA';;

function win____EnumFonts(DC: HDC; lpszFace: PChar; fntenmprc: TFarProc; lpszData: PChar):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____EnumFonts,a) then result:=twin____EnumFonts(a)(DC, lpszFace, fntenmprc, lpszData);
win__dec;
end;


//function win____EnumFontFamiliesEx(DC: HDC; var p2: TLogFont; p3: TFarProc; p4: LPARAM; p5: DWORD): BOOL; stdcall; external gdi32 name 'EnumFontFamiliesExA';;

function win____EnumFontFamiliesEx(DC: HDC; var p2: TLogFont; p3: TFarProc; p4: LPARAM; p5: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____EnumFontFamiliesEx,a) then result:=twin____EnumFontFamiliesEx(a)(DC, p2, p3, p4, p5);
win__dec;
end;


//function win____GetStockObject(Index: Integer): HGDIOBJ; stdcall; external gdi32 name 'GetStockObject';;

function win____GetStockObject(Index: Integer):hgdiobj;
var
   a:pointer;
begin
if win__useint(result,vwin____GetStockObject,a) then result:=twin____GetStockObject(a)(Index);
win__dec;
end;


//function win____GetCurrentThread: THandle; stdcall; external kernel32 name 'GetCurrentThread';;

function win____GetCurrentThread:thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____GetCurrentThread,a) then result:=twin____GetCurrentThread(a);
win__dec;
end;


//function win____GetCurrentThreadId: DWORD; stdcall; external kernel32 name 'GetCurrentThreadId';;

function win____GetCurrentThreadId:dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetCurrentThreadId,a) then result:=twin____GetCurrentThreadId(a);
win__dec;
end;


//function win____ClipCursor(lpRect: pwinrect): BOOL; stdcall; external user32 name 'ClipCursor';;

function win____ClipCursor(lpRect: pwinrect):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ClipCursor,a) then result:=twin____ClipCursor(a)(lpRect);
win__dec;
end;


//function win____GetClipCursor(var lpRect: twinrect): BOOL; stdcall; external user32 name 'CloseClipboard';;

function win____GetClipCursor(var lpRect: twinrect):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetClipCursor,a) then result:=twin____GetClipCursor(a)(lpRect);
win__dec;
end;


//function win____GetCapture: HWND; stdcall; external user32 name 'GetCapture';;

function win____GetCapture:hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____GetCapture,a) then result:=twin____GetCapture(a);
win__dec;
end;


//function win____SetCapture(hWnd: HWND): HWND; stdcall; external user32 name 'SetCapture';;

function win____SetCapture(hWnd: HWND):hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____SetCapture,a) then result:=twin____SetCapture(a)(hWnd);
win__dec;
end;


//function win____ReleaseCapture: BOOL; stdcall; external user32 name 'ReleaseCapture';;

function win____ReleaseCapture:bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ReleaseCapture,a) then result:=twin____ReleaseCapture(a);
win__dec;
end;


//function win____PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL; stdcall; external user32 name 'PostMessageA';;

function win____PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____PostMessage,a) then result:=twin____PostMessage(a)(hWnd, Msg, wParam, lParam);
win__dec;
end;


//function win____SetClassLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint): DWORD; stdcall; external user32 name 'SetClassLongA';;

function win____SetClassLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____SetClassLong,a) then result:=twin____SetClassLong(a)(hWnd, nIndex, dwNewLong);
win__dec;
end;


//function win____GetActiveWindow: HWND; stdcall; external user32 name 'GetActiveWindow';;

function win____GetActiveWindow:hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____GetActiveWindow,a) then result:=twin____GetActiveWindow(a);
win__dec;
end;


//function win____ShowCursor(bShow: BOOL): Integer; stdcall; external user32 name 'ShowCursor';;

function win____ShowCursor(bShow: BOOL):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____ShowCursor,a) then result:=twin____ShowCursor(a)(bShow);
win__dec;
end;


//function win____SetCursorPos(X, Y: Integer): BOOL; stdcall; external user32 name 'SetCursorPos';;

function win____SetCursorPos(X, Y: Integer):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetCursorPos,a) then result:=twin____SetCursorPos(a)(X, Y);
win__dec;
end;


//function win____SetCursor(hCursor: HICON): HCURSOR; stdcall; external user32 name 'SetCursor';;

function win____SetCursor(hCursor: HICON):hcursor;
var
   a:pointer;
begin
if win__useint(result,vwin____SetCursor,a) then result:=twin____SetCursor(a)(hCursor);
win__dec;
end;


//function win____GetCursor: HCURSOR; stdcall; external user32 name 'GetCursor';;

function win____GetCursor:hcursor;
var
   a:pointer;
begin
if win__useint(result,vwin____GetCursor,a) then result:=twin____GetCursor(a);
win__dec;
end;


//function win____GetCursorPos(var lpPoint: TPoint): BOOL; stdcall; external user32 name 'GetCursorPos';;

function win____GetCursorPos(var lpPoint: TPoint):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetCursorPos,a) then result:=twin____GetCursorPos(a)(lpPoint);
win__dec;
end;


//function win____GetWindowText(hWnd: HWND; lpString: PChar; nMaxCount: Integer): Integer; stdcall; external user32 name 'GetWindowTextA';;

function win____GetWindowText(hWnd: HWND; lpString: PChar; nMaxCount: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetWindowText,a) then result:=twin____GetWindowText(a)(hWnd, lpString, nMaxCount);
win__dec;
end;


//function win____GetWindowTextLength(hWnd: HWND): Integer; stdcall; external user32 name 'GetWindowTextLengthA';;

function win____GetWindowTextLength(hWnd: HWND):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetWindowTextLength,a) then result:=twin____GetWindowTextLength(a)(hWnd);
win__dec;
end;


//function win____SetWindowText(hWnd: HWND; lpString: PChar): BOOL; stdcall; external user32 name 'SetWindowTextA';;

function win____SetWindowText(hWnd: HWND; lpString: PChar):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetWindowText,a) then result:=twin____SetWindowText(a)(hWnd, lpString);
win__dec;
end;


//function win____GetModuleHandle(lpModuleName: PChar): HMODULE; stdcall; external kernel32 name 'GetModuleHandleA';;

function win____GetModuleHandle(lpModuleName: PChar):hmodule;
var
   a:pointer;
begin
if win__useint(result,vwin____GetModuleHandle,a) then result:=twin____GetModuleHandle(a)(lpModuleName);
win__dec;
end;


//function win____GetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement): BOOL; stdcall; external user32 name 'GetWindowPlacement';;

function win____GetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetWindowPlacement,a) then result:=twin____GetWindowPlacement(a)(hWnd, WindowPlacement);
win__dec;
end;


//function win____SetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement): BOOL; stdcall; external user32 name 'SetWindowPlacement';;

function win____SetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetWindowPlacement,a) then result:=twin____SetWindowPlacement(a)(hWnd, WindowPlacement);
win__dec;
end;


//function win____GetTextExtentPoint(DC: HDC; Str: PChar; Count: Integer; var Size: tpoint): BOOL; stdcall; external gdi32 name 'GetTextExtentPointA';;

function win____GetTextExtentPoint(DC: HDC; Str: PChar; Count: Integer; var Size: tpoint):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetTextExtentPoint,a) then result:=twin____GetTextExtentPoint(a)(DC, Str, Count, Size);
win__dec;
end;


//function win____TextOut(DC: HDC; X, Y: Integer; Str: PChar; Count: Integer): BOOL; stdcall; external gdi32 name 'TextOutA';;

function win____TextOut(DC: HDC; X, Y: Integer; Str: PChar; Count: Integer):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____TextOut,a) then result:=twin____TextOut(a)(DC, X, Y, Str, Count);
win__dec;
end;


//function win____GetSysColorBrush(xindex:longint): HBRUSH; stdcall; external user32 name 'GetSysColorBrush';;

function win____GetSysColorBrush(xindex:longint):hbrush;
var
   a:pointer;
begin
if win__useint(result,vwin____GetSysColorBrush,a) then result:=twin____GetSysColorBrush(a)(xindex);
win__dec;
end;


//function win____CreateSolidBrush(p1: COLORREF): HBRUSH; stdcall; external gdi32 name 'CreateSolidBrush';;

function win____CreateSolidBrush(p1: COLORREF):hbrush;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateSolidBrush,a) then result:=twin____CreateSolidBrush(a)(p1);
win__dec;
end;


//function win____LoadIcon(hInstance: HINST; lpIconName: PChar): HICON; stdcall; external user32 name 'LoadIconA';;

function win____LoadIcon(hInstance: HINST; lpIconName: PChar):hicon;
var
   a:pointer;
begin
if win__useint(result,vwin____LoadIcon,a) then result:=twin____LoadIcon(a)(hInstance, lpIconName);
win__dec;
end;


//function win____LoadCursor(hInstance: HINST; lpCursorName: PAnsiChar): HCURSOR; stdcall; external user32 name 'LoadCursorA';;

function win____LoadCursor(hInstance: HINST; lpCursorName: PAnsiChar):hcursor;
var
   a:pointer;
begin
if win__useint(result,vwin____LoadCursor,a) then result:=twin____LoadCursor(a)(hInstance, lpCursorName);
win__dec;
end;


//function win____FillRect(hDC: HDC; const lprc: twinrect; hbr: HBRUSH): Integer; stdcall; external user32 name 'FillRect';;

function win____FillRect(hDC: HDC; const lprc: twinrect; hbr: HBRUSH):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____FillRect,a) then result:=twin____FillRect(a)(hDC, lprc, hbr);
win__dec;
end;


//function win____FrameRect(hDC: HDC; const lprc: twinrect; hbr: HBRUSH): Integer; stdcall; external user32 name 'FrameRect';;

function win____FrameRect(hDC: HDC; const lprc: twinrect; hbr: HBRUSH):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____FrameRect,a) then result:=twin____FrameRect(a)(hDC, lprc, hbr);
win__dec;
end;


//function win____InvalidateRect(hWnd: HWND; lpwinrect: pwinrect; bErase: BOOL): BOOL; stdcall; external user32 name 'InvalidateRect';;

function win____InvalidateRect(hWnd: HWND; lpwinrect: pwinrect; bErase: BOOL):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____InvalidateRect,a) then result:=twin____InvalidateRect(a)(hWnd, lpwinrect, bErase);
win__dec;
end;


//function win____StretchBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC; XSrc, YSrc, SrcWidth, SrcHeight: Integer; Rop: DWORD): BOOL; stdcall; external gdi32 name 'StretchBlt';;

function win____StretchBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC; XSrc, YSrc, SrcWidth, SrcHeight: Integer; Rop: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____StretchBlt,a) then result:=twin____StretchBlt(a)(DestDC, X, Y, Width, Height, SrcDC, XSrc, YSrc, SrcWidth, SrcHeight, Rop);
win__dec;
end;


//function win____GetClientwinrect(hWnd: HWND; var lpwinrect: twinrect): BOOL; stdcall; external user32 name 'GetClientwinrect';;

function win____GetClientwinrect(hWnd: HWND; var lpwinrect: twinrect):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetClientwinrect,a) then result:=twin____GetClientwinrect(a)(hWnd, lpwinrect);
win__dec;
end;


//function win____GetWindowRect(hWnd: HWND; var lpwinrect: twinrect): BOOL; stdcall; external user32 name 'GetWindowRect';;

function win____GetWindowRect(hWnd: HWND; var lpwinrect: twinrect):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetWindowRect,a) then result:=twin____GetWindowRect(a)(hWnd, lpwinrect);
win__dec;
end;


//function win____GetClientRect(hWnd: HWND; var lpRect: twinrect): BOOL; stdcall; external user32 name 'GetClientRect';;

function win____GetClientRect(hWnd: HWND; var lpRect: twinrect):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetClientRect,a) then result:=twin____GetClientRect(a)(hWnd, lpRect);
win__dec;
end;


//function win____MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL; stdcall; external user32 name 'MoveWindow';;

function win____MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____MoveWindow,a) then result:=twin____MoveWindow(a)(hWnd, X, Y, nWidth, nHeight, bRepaint);
win__dec;
end;


//function win____SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL; stdcall; external user32 name 'SetWindowPos';;

function win____SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetWindowPos,a) then result:=twin____SetWindowPos(a)(hWnd, hWndInsertAfter, X, Y, cx, cy, uFlags);
win__dec;
end;


//function win____DestroyWindow(hWnd: HWND): BOOL; stdcall; external user32 name 'DestroyWindow';;

function win____DestroyWindow(hWnd: HWND):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____DestroyWindow,a) then result:=twin____DestroyWindow(a)(hWnd);
win__dec;
end;


//function win____ShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL; stdcall; external user32 name 'ShowWindow';;

function win____ShowWindow(hWnd: HWND; nCmdShow: Integer):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ShowWindow,a) then result:=twin____ShowWindow(a)(hWnd, nCmdShow);
win__dec;
end;


//function win____RegisterClassExA(const WndClass: TWndClassExA): ATOM; stdcall; external user32 name 'RegisterClassExA';;

function win____RegisterClassExA(const WndClass: TWndClassExA):atom;
var
   a:pointer;
begin
if win__usewrd(result,vwin____RegisterClassExA,a) then result:=twin____RegisterClassExA(a)(WndClass);
win__dec;
end;


//function win____IsWindowVisible(hWnd: HWND): BOOL; stdcall; external user32 name 'IsWindowVisible';;

function win____IsWindowVisible(hWnd: HWND):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____IsWindowVisible,a) then result:=twin____IsWindowVisible(a)(hWnd);
win__dec;
end;


//function win____IsIconic(hWnd: HWND): BOOL; stdcall; external user32 name 'IsIconic';;

function win____IsIconic(hWnd: HWND):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____IsIconic,a) then result:=twin____IsIconic(a)(hWnd);
win__dec;
end;


//function win____GetWindowDC(hWnd: HWND): HDC; stdcall; external user32 name 'GetWindowDC';;

function win____GetWindowDC(hWnd: HWND):hdc;
var
   a:pointer;
begin
if win__useint(result,vwin____GetWindowDC,a) then result:=twin____GetWindowDC(a)(hWnd);
win__dec;
end;


//function win____ReleaseDC(hWnd: HWND; hDC: HDC): Integer; stdcall; external user32 name 'ReleaseDC';;

function win____ReleaseDC(hWnd: HWND; hDC: HDC):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____ReleaseDC,a) then result:=twin____ReleaseDC(a)(hWnd, hDC);
win__dec;
end;


//function win____BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct): HDC; stdcall; external user32 name 'BeginPaint';;

function win____BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct):hdc;
var
   a:pointer;
begin
if win__useint(result,vwin____BeginPaint,a) then result:=twin____BeginPaint(a)(hWnd, lpPaint);
win__dec;
end;


//function win____EndPaint(hWnd: HWND; const lpPaint: TPaintStruct): BOOL; stdcall; external user32 name 'EndPaint';;

function win____EndPaint(hWnd: HWND; const lpPaint: TPaintStruct):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____EndPaint,a) then result:=twin____EndPaint(a)(hWnd, lpPaint);
win__dec;
end;


//function win____SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'SendMessageA';;

function win____SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult;
var
   a:pointer;
begin
if win__useint(result,vwin____SendMessage,a) then result:=twin____SendMessage(a)(hWnd, Msg, wParam, lParam);
win__dec;
end;


//function win____EnumDisplaySettingsA(lpszDeviceName: PAnsiChar; iModeNum: DWORD; var lpDevMode: TDeviceModeA): BOOL; stdcall; external user32 name 'EnumDisplaySettingsA';;

function win____EnumDisplaySettingsA(lpszDeviceName: PAnsiChar; iModeNum: DWORD; var lpDevMode: TDeviceModeA):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____EnumDisplaySettingsA,a) then result:=twin____EnumDisplaySettingsA(a)(lpszDeviceName, iModeNum, lpDevMode);
win__dec;
end;


//function win____CreateDC(lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA): HDC; stdcall; external gdi32 name 'CreateDCA';;

function win____CreateDC(lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA):hdc;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateDC,a) then result:=twin____CreateDC(a)(lpszDriver, lpszDevice, lpszOutput, lpdvmInit);
win__dec;
end;


//function win____DeleteDC(DC: HDC): BOOL; stdcall; external gdi32 name 'DeleteDC';;

function win____DeleteDC(DC: HDC):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____DeleteDC,a) then result:=twin____DeleteDC(a)(DC);
win__dec;
end;


//function win____GetDeviceCaps(DC: HDC; Index: Integer): Integer; stdcall; external gdi32 name 'GetDeviceCaps';;

function win____GetDeviceCaps(DC: HDC; Index: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetDeviceCaps,a) then result:=twin____GetDeviceCaps(a)(DC, Index);
win__dec;
end;


//function win____GetSystemMetrics(nIndex: Integer): Integer; stdcall; external user32 name 'GetSystemMetrics';;

function win____GetSystemMetrics(nIndex: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetSystemMetrics,a) then result:=twin____GetSystemMetrics(a)(nIndex);
win__dec;
end;


//function win____CreateRectRgn(p1, p2, p3, p4: Integer): HRGN; stdcall; external gdi32 name 'CreateRectRgn';;

function win____CreateRectRgn(p1, p2, p3, p4: Integer):hrgn;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateRectRgn,a) then result:=twin____CreateRectRgn(a)(p1, p2, p3, p4);
win__dec;
end;


//function win____CreateRoundRectRgn(p1, p2, p3, p4, p5, p6: Integer): HRGN; stdcall; external gdi32 name 'CreateRoundRectRgn';;

function win____CreateRoundRectRgn(p1, p2, p3, p4, p5, p6: Integer):hrgn;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateRoundRectRgn,a) then result:=twin____CreateRoundRectRgn(a)(p1, p2, p3, p4, p5, p6);
win__dec;
end;


//function win____GetRgnBox(RGN: HRGN; var p2: twinrect): Integer; stdcall; external gdi32 name 'GetRgnBox';;

function win____GetRgnBox(RGN: HRGN; var p2: twinrect):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetRgnBox,a) then result:=twin____GetRgnBox(a)(RGN, p2);
win__dec;
end;


//function win____SetWindowRgn(hWnd: HWND; hRgn: HRGN; bRedraw: BOOL): BOOL; stdcall; external user32 name 'SetWindowRgn';;

function win____SetWindowRgn(hWnd: HWND; hRgn: HRGN; bRedraw: BOOL):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetWindowRgn,a) then result:=twin____SetWindowRgn(a)(hWnd, hRgn, bRedraw);
win__dec;
end;


//function win____PostThreadMessage(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL; stdcall; external user32 name 'PostThreadMessageA';;

function win____PostThreadMessage(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____PostThreadMessage,a) then result:=twin____PostThreadMessage(a)(idThread, Msg, wParam, lParam);
win__dec;
end;


//function win____SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint; stdcall; external user32 name 'SetWindowLongA';;

function win____SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____SetWindowLong,a) then result:=twin____SetWindowLong(a)(hWnd, nIndex, dwNewLong);
win__dec;
end;


//function win____GetWindowLong(hWnd: HWND; nIndex: Integer): Longint; stdcall; external user32 name 'GetWindowLongA';;

function win____GetWindowLong(hWnd: HWND; nIndex: Integer):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____GetWindowLong,a) then result:=twin____GetWindowLong(a)(hWnd, nIndex);
win__dec;
end;


//function win____CallWindowProc(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'CallWindowProcA';;

function win____CallWindowProc(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult;
var
   a:pointer;
begin
if win__useint(result,vwin____CallWindowProc,a) then result:=twin____CallWindowProc(a)(lpPrevWndFunc, hWnd, Msg, wParam, lParam);
win__dec;
end;


//function win____SystemParametersInfo(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT): BOOL; stdcall; external user32 name 'SystemParametersInfoA';;

function win____SystemParametersInfo(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SystemParametersInfo,a) then result:=twin____SystemParametersInfo(a)(uiAction, uiParam, pvParam, fWinIni);
win__dec;
end;


//function win____RegisterClipboardFormat(lpszFormat: PChar): UINT; stdcall; external user32 name 'RegisterClipboardFormatA';;

function win____RegisterClipboardFormat(lpszFormat: PChar):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____RegisterClipboardFormat,a) then result:=twin____RegisterClipboardFormat(a)(lpszFormat);
win__dec;
end;


//function win____CountClipboardFormats: Integer; stdcall; external user32 name 'CountClipboardFormats';;

function win____CountClipboardFormats:integer;
var
   a:pointer;
begin
if win__useint(result,vwin____CountClipboardFormats,a) then result:=twin____CountClipboardFormats(a);
win__dec;
end;


//function win____ClientToScreen(hWnd: HWND; var lpPoint: tpoint): BOOL; stdcall; external user32 name 'ClientToScreen';;

function win____ClientToScreen(hWnd: HWND; var lpPoint: tpoint):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ClientToScreen,a) then result:=twin____ClientToScreen(a)(hWnd, lpPoint);
win__dec;
end;


//function win____ScreenToClient(hWnd: HWND; var lpPoint: tpoint): BOOL; stdcall; external user32 name 'ScreenToClient';;

function win____ScreenToClient(hWnd: HWND; var lpPoint: tpoint):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ScreenToClient,a) then result:=twin____ScreenToClient(a)(hWnd, lpPoint);
win__dec;
end;


//procedure win____DragAcceptFiles(Wnd: HWND; Accept: BOOL); stdcall; external shell32 name 'DragAcceptFiles';;

procedure win____DragAcceptFiles(Wnd: HWND; Accept: BOOL);
var
   a:pointer;
begin
if win__use(vwin____DragAcceptFiles,a) then twin____DragAcceptFiles(a)(Wnd, Accept);
win__dec;
end;


//function win____DragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT; stdcall; external shell32 name 'DragQueryFileA';;

function win____DragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____DragQueryFile,a) then result:=twin____DragQueryFile(a)(Drop, FileIndex, FileName, cb);
win__dec;
end;


//procedure win____DragFinish(Drop: HDROP); stdcall; external shell32 name 'DragFinish';;

procedure win____DragFinish(Drop: HDROP);
var
   a:pointer;
begin
if win__use(vwin____DragFinish,a) then twin____DragFinish(a)(Drop);
win__dec;
end;


//function win____SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc): UINT; stdcall; external user32 name 'SetTimer';;

function win____SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____SetTimer,a) then result:=twin____SetTimer(a)(hWnd, nIDEvent, uElapse, lpTimerFunc);
win__dec;
end;


//function win____KillTimer(hWnd: HWND; uIDEvent: UINT): BOOL; stdcall; external user32 name 'KillTimer';;

function win____KillTimer(hWnd: HWND; uIDEvent: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____KillTimer,a) then result:=twin____KillTimer(a)(hWnd, uIDEvent);
win__dec;
end;


//function win____WaitMessage:bool; stdcall; external user32 name 'WaitMessage';;

function win____WaitMessage:bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____WaitMessage,a) then result:=twin____WaitMessage(a);
win__dec;
end;


//function win____GetProcessHeap: THandle; stdcall; external kernel32 name 'GetProcessHeap';;

function win____GetProcessHeap:thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____GetProcessHeap,a) then result:=twin____GetProcessHeap(a);
win__dec;
end;


//function win____SetPriorityClass(hProcess: THandle; dwPriorityClass: DWORD): BOOL; stdcall; external kernel32 name 'SetPriorityClass';;

function win____SetPriorityClass(hProcess: THandle; dwPriorityClass: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetPriorityClass,a) then result:=twin____SetPriorityClass(a)(hProcess, dwPriorityClass);
win__dec;
end;


//function win____GetPriorityClass(hProcess: THandle): DWORD; stdcall; external kernel32 name 'GetPriorityClass';;

function win____GetPriorityClass(hProcess: THandle):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetPriorityClass,a) then result:=twin____GetPriorityClass(a)(hProcess);
win__dec;
end;


//function win____SetThreadPriority(hThread: THandle; nPriority: Integer): BOOL; stdcall; external kernel32 name 'SetThreadPriority';;

function win____SetThreadPriority(hThread: THandle; nPriority: Integer):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetThreadPriority,a) then result:=twin____SetThreadPriority(a)(hThread, nPriority);
win__dec;
end;


//function win____SetThreadPriorityBoost(hThread: THandle; DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'SetThreadPriorityBoost';;

function win____SetThreadPriorityBoost(hThread: THandle; DisablePriorityBoost: Bool):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetThreadPriorityBoost,a) then result:=twin____SetThreadPriorityBoost(a)(hThread, DisablePriorityBoost);
win__dec;
end;


//function win____GetThreadPriority(hThread: THandle): Integer; stdcall; external kernel32 name 'GetThreadPriority';;

function win____GetThreadPriority(hThread: THandle):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetThreadPriority,a) then result:=twin____GetThreadPriority(a)(hThread);
win__dec;
end;


//function win____GetThreadPriorityBoost(hThread: THandle; var DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'GetThreadPriorityBoost';;

function win____GetThreadPriorityBoost(hThread: THandle; var DisablePriorityBoost: Bool):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetThreadPriorityBoost,a) then result:=twin____GetThreadPriorityBoost(a)(hThread, DisablePriorityBoost);
win__dec;
end;


//function win____CoInitializeEx(pvReserved: Pointer; coInit: Longint): HResult; stdcall; external ole32 name 'CoInitializeEx';;

function win____CoInitializeEx(pvReserved: Pointer; coInit: Longint):hresult;
var
   a:pointer;
begin
if win__useint(result,vwin____CoInitializeEx,a) then result:=twin____CoInitializeEx(a)(pvReserved, coInit);
win__dec;
end;


//function win____CoInitialize(pvReserved: Pointer): HResult; stdcall; external ole32 name 'CoInitialize';;

function win____CoInitialize(pvReserved: Pointer):hresult;
var
   a:pointer;
begin
if win__useint(result,vwin____CoInitialize,a) then result:=twin____CoInitialize(a)(pvReserved);
win__dec;
end;


//procedure win____CoUninitialize; stdcall; external ole32 name 'CoUninitialize';;

procedure win____CoUninitialize;
var
   a:pointer;
begin
if win__use(vwin____CoUninitialize,a) then twin____CoUninitialize(a);
win__dec;
end;


//function win____CreateMutexA(lpMutexAttributes: PSecurityAttributes; bInitialOwner: BOOL; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'CreateMutexA';;

function win____CreateMutexA(lpMutexAttributes: PSecurityAttributes; bInitialOwner: BOOL; lpName: PAnsiChar):thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____CreateMutexA,a) then result:=twin____CreateMutexA(a)(lpMutexAttributes, bInitialOwner, lpName);
win__dec;
end;


//function win____ReleaseMutex(hMutex: THandle): BOOL; stdcall; external kernel32 name 'ReleaseMutex';;

function win____ReleaseMutex(hMutex: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ReleaseMutex,a) then result:=twin____ReleaseMutex(a)(hMutex);
win__dec;
end;


//function win____WaitForSingleObject(hHandle: THandle; dwMilliseconds: DWORD): DWORD; stdcall; external kernel32 name 'WaitForSingleObject';;

function win____WaitForSingleObject(hHandle: THandle; dwMilliseconds: DWORD):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____WaitForSingleObject,a) then result:=twin____WaitForSingleObject(a)(hHandle, dwMilliseconds);
win__dec;
end;


//function win____WaitForSingleObjectEx(hHandle: THandle; dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall; external kernel32 name 'WaitForSingleObjectEx';;

function win____WaitForSingleObjectEx(hHandle: THandle; dwMilliseconds: DWORD; bAlertable: BOOL):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____WaitForSingleObjectEx,a) then result:=twin____WaitForSingleObjectEx(a)(hHandle, dwMilliseconds, bAlertable);
win__dec;
end;


//function win____CreateEvent(lpEventAttributes: PSecurityAttributes; bManualReset, bInitialState: BOOL; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'CreateEventA';;

function win____CreateEvent(lpEventAttributes: PSecurityAttributes; bManualReset, bInitialState: BOOL; lpName: PAnsiChar):thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____CreateEvent,a) then result:=twin____CreateEvent(a)(lpEventAttributes, bManualReset, bInitialState, lpName);
win__dec;
end;


//function win____SetEvent(hEvent: THandle): BOOL; stdcall; external kernel32 name 'SetEvent';;

function win____SetEvent(hEvent: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetEvent,a) then result:=twin____SetEvent(a)(hEvent);
win__dec;
end;


//function win____ResetEvent(hEvent: THandle): BOOL; stdcall; external kernel32 name 'ResetEvent';;

function win____ResetEvent(hEvent: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ResetEvent,a) then result:=twin____ResetEvent(a)(hEvent);
win__dec;
end;


//function win____PulseEvent(hEvent: THandle): BOOL; stdcall; external kernel32 name 'PulseEvent';;

function win____PulseEvent(hEvent: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____PulseEvent,a) then result:=twin____PulseEvent(a)(hEvent);
win__dec;
end;


//function win____InterlockedIncrement(var Addend: Integer): Integer; stdcall; external kernel32 name 'InterlockedIncrement';;

function win____InterlockedIncrement(var Addend: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____InterlockedIncrement,a) then result:=twin____InterlockedIncrement(a)(Addend);
win__dec;
end;


//function win____InterlockedDecrement(var Addend: Integer): Integer; stdcall; external kernel32 name 'InterlockedDecrement';;

function win____InterlockedDecrement(var Addend: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____InterlockedDecrement,a) then result:=twin____InterlockedDecrement(a)(Addend);
win__dec;
end;


//function win____GetFileVersionInfoSize(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD): DWORD; stdcall; external version name 'GetFileVersionInfoSizeA';;

function win____GetFileVersionInfoSize(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetFileVersionInfoSize,a) then result:=twin____GetFileVersionInfoSize(a)(lptstrFilename, lpdwHandle);
win__dec;
end;


//function win____GetFileVersionInfo(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL; stdcall; external version name 'GetFileVersionInfoA';;

function win____GetFileVersionInfo(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetFileVersionInfo,a) then result:=twin____GetFileVersionInfo(a)(lptstrFilename, dwHandle, dwLen, lpData);
win__dec;
end;


//function win____VerQueryValue(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL; stdcall; external version name 'VerQueryValueA';;

function win____VerQueryValue(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____VerQueryValue,a) then result:=twin____VerQueryValue(a)(pBlock, lpSubBlock, lplpBuffer, puLen);
win__dec;
end;


//function win____GetCurrentProcessId: DWORD; stdcall; external kernel32 name 'GetCurrentProcessId';;

function win____GetCurrentProcessId:dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetCurrentProcessId,a) then result:=twin____GetCurrentProcessId(a);
win__dec;
end;


//procedure win____ExitProcess(uExitCode: UINT); stdcall; external kernel32 name 'ExitProcess';;

procedure win____ExitProcess(uExitCode: UINT);
var
   a:pointer;
begin
if win__use(vwin____ExitProcess,a) then twin____ExitProcess(a)(uExitCode);
win__dec;
end;


//function win____GetExitCodeProcess(hProcess: THandle; var lpExitCode: DWORD): BOOL; stdcall; external kernel32 name 'GetExitCodeProcess';;

function win____GetExitCodeProcess(hProcess: THandle; var lpExitCode: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetExitCodeProcess,a) then result:=twin____GetExitCodeProcess(a)(hProcess, lpExitCode);
win__dec;
end;


//function win____CreateThread(lpThreadAttributes: Pointer; dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle; stdcall; external kernel32 name 'CreateThread';;

function win____CreateThread(lpThreadAttributes: Pointer; dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD):thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____CreateThread,a) then result:=twin____CreateThread(a)(lpThreadAttributes, dwStackSize, lpStartAddress, lpParameter, dwCreationFlags, lpThreadId);
win__dec;
end;


//function win____SuspendThread(hThread: THandle): DWORD; stdcall; external kernel32 name 'SuspendThread';;

function win____SuspendThread(hThread: THandle):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____SuspendThread,a) then result:=twin____SuspendThread(a)(hThread);
win__dec;
end;


//function win____ResumeThread(hThread: THandle): DWORD; stdcall; external kernel32 name 'ResumeThread';;

function win____ResumeThread(hThread: THandle):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____ResumeThread,a) then result:=twin____ResumeThread(a)(hThread);
win__dec;
end;


//function win____GetCurrentProcess: THandle; stdcall; external kernel32 name 'GetCurrentProcess';;

function win____GetCurrentProcess:thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____GetCurrentProcess,a) then result:=twin____GetCurrentProcess(a);
win__dec;
end;


//function win____GetLastError: DWORD; stdcall; external kernel32 name 'GetLastError';;

function win____GetLastError:dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetLastError,a) then result:=twin____GetLastError(a);
win__dec;
end;


//function win____GetStdHandle(nStdHandle: DWORD): THandle; stdcall; external kernel32 name 'GetStdHandle';;

function win____GetStdHandle(nStdHandle: DWORD):thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____GetStdHandle,a) then result:=twin____GetStdHandle(a)(nStdHandle);
win__dec;
end;


//function win____SetStdHandle(nStdHandle: DWORD; hHandle: THandle): BOOL; stdcall; external kernel32 name 'SetStdHandle';;

function win____SetStdHandle(nStdHandle: DWORD; hHandle: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetStdHandle,a) then result:=twin____SetStdHandle(a)(nStdHandle, hHandle);
win__dec;
end;


//function win____GetConsoleScreenBufferInfo(hConsoleOutput: THandle; var lpConsoleScreenBufferInfo: TConsoleScreenBufferInfo): BOOL; stdcall; external kernel32 name 'GetConsoleScreenBufferInfo';;

function win____GetConsoleScreenBufferInfo(hConsoleOutput: THandle; var lpConsoleScreenBufferInfo: TConsoleScreenBufferInfo):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetConsoleScreenBufferInfo,a) then result:=twin____GetConsoleScreenBufferInfo(a)(hConsoleOutput, lpConsoleScreenBufferInfo);
win__dec;
end;


//function win____FillConsoleOutputCharacter(hConsoleOutput: THandle; cCharacter: Char; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD): BOOL; stdcall; external kernel32 name 'FillConsoleOutputCharacterA';;

function win____FillConsoleOutputCharacter(hConsoleOutput: THandle; cCharacter: Char; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____FillConsoleOutputCharacter,a) then result:=twin____FillConsoleOutputCharacter(a)(hConsoleOutput, cCharacter, nLength, dwWriteCoord, lpNumberOfCharsWritten);
win__dec;
end;


//function win____FillConsoleOutputAttribute(hConsoleOutput: THandle; wAttribute: Word; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfAttrsWritten: DWORD): BOOL; stdcall; external kernel32 name 'FillConsoleOutputAttribute';;

function win____FillConsoleOutputAttribute(hConsoleOutput: THandle; wAttribute: Word; nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfAttrsWritten: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____FillConsoleOutputAttribute,a) then result:=twin____FillConsoleOutputAttribute(a)(hConsoleOutput, wAttribute, nLength, dwWriteCoord, lpNumberOfAttrsWritten);
win__dec;
end;


//function win____GetConsoleMode(hConsoleHandle: THandle; var lpMode: DWORD): BOOL; stdcall; external kernel32 name 'GetConsoleMode';;

function win____GetConsoleMode(hConsoleHandle: THandle; var lpMode: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetConsoleMode,a) then result:=twin____GetConsoleMode(a)(hConsoleHandle, lpMode);
win__dec;
end;


//function win____SetConsoleCursorPosition(hConsoleOutput: THandle; dwCursorPosition: TCoord): BOOL; stdcall; external kernel32 name 'SetConsoleCursorPosition';;

function win____SetConsoleCursorPosition(hConsoleOutput: THandle; dwCursorPosition: TCoord):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetConsoleCursorPosition,a) then result:=twin____SetConsoleCursorPosition(a)(hConsoleOutput, dwCursorPosition);
win__dec;
end;


//function win____SetConsoleTitle(lpConsoleTitle: PChar): BOOL; stdcall; external kernel32 name 'SetConsoleTitleA';;

function win____SetConsoleTitle(lpConsoleTitle: PChar):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetConsoleTitle,a) then result:=twin____SetConsoleTitle(a)(lpConsoleTitle);
win__dec;
end;


//function win____SetConsoleCtrlHandler(HandlerRoutine: TFNHandlerRoutine; Add: BOOL): BOOL; stdcall; external kernel32 name 'SetConsoleCtrlHandler';;

function win____SetConsoleCtrlHandler(HandlerRoutine: TFNHandlerRoutine; Add: BOOL):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetConsoleCtrlHandler,a) then result:=twin____SetConsoleCtrlHandler(a)(HandlerRoutine, Add);
win__dec;
end;


//function win____GetNumberOfConsoleInputEvents(hConsoleInput: THandle; var lpNumberOfEvents: DWORD): BOOL; stdcall; external kernel32 name 'GetNumberOfConsoleInputEvents';;

function win____GetNumberOfConsoleInputEvents(hConsoleInput: THandle; var lpNumberOfEvents: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetNumberOfConsoleInputEvents,a) then result:=twin____GetNumberOfConsoleInputEvents(a)(hConsoleInput, lpNumberOfEvents);
win__dec;
end;


//function win____ReadConsoleInput(hConsoleInput: THandle; var lpBuffer: TInputRecord; nLength: DWORD; var lpNumberOfEventsRead: DWORD): BOOL; stdcall; external kernel32 name 'ReadConsoleInputA';;

function win____ReadConsoleInput(hConsoleInput: THandle; var lpBuffer: TInputRecord; nLength: DWORD; var lpNumberOfEventsRead: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ReadConsoleInput,a) then result:=twin____ReadConsoleInput(a)(hConsoleInput, lpBuffer, nLength, lpNumberOfEventsRead);
win__dec;
end;


//function win____GetMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: UINT): BOOL; stdcall; external user32 name 'GetMessageA';;

function win____GetMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetMessage,a) then result:=twin____GetMessage(a)(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax);
win__dec;
end;


//function win____PeekMessage(var lpMsg: tmsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall; external user32 name 'PeekMessageA';;

function win____PeekMessage(var lpMsg: tmsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____PeekMessage,a) then result:=twin____PeekMessage(a)(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax, wRemoveMsg);
win__dec;
end;


//function win____DispatchMessage(const lpMsg: tmsg): Longint; stdcall; external user32 name 'DispatchMessageA';;

function win____DispatchMessage(const lpMsg: tmsg):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____DispatchMessage,a) then result:=twin____DispatchMessage(a)(lpMsg);
win__dec;
end;


//function win____TranslateMessage(const lpMsg: tmsg): BOOL; stdcall; external user32 name 'TranslateMessage';;

function win____TranslateMessage(const lpMsg: tmsg):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____TranslateMessage,a) then result:=twin____TranslateMessage(a)(lpMsg);
win__dec;
end;


//function win____GetDriveType(lpRootPathName: PChar): UINT; stdcall; external kernel32 name 'GetDriveTypeA';;

function win____GetDriveType(lpRootPathName: PChar):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____GetDriveType,a) then result:=twin____GetDriveType(a)(lpRootPathName);
win__dec;
end;


//function win____SetErrorMode(uMode: UINT): UINT; stdcall; external kernel32 name 'SetErrorMode';;

function win____SetErrorMode(uMode: UINT):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____SetErrorMode,a) then result:=twin____SetErrorMode(a)(uMode);
win__dec;
end;


//procedure win____ExitThread(dwExitCode: DWORD); stdcall; external kernel32 name 'ExitThread';;

procedure win____ExitThread(dwExitCode: DWORD);
var
   a:pointer;
begin
if win__use(vwin____ExitThread,a) then twin____ExitThread(a)(dwExitCode);
win__dec;
end;


//function win____TerminateThread(hThread: THandle; dwExitCode: DWORD): BOOL; stdcall; external kernel32 name 'TerminateThread';;

function win____TerminateThread(hThread: THandle; dwExitCode: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____TerminateThread,a) then result:=twin____TerminateThread(a)(hThread, dwExitCode);
win__dec;
end;


//function win____QueryPerformanceCounter(var lpPerformanceCount: comp): BOOL; stdcall; external kernel32 name 'QueryPerformanceCounter';;

function win____QueryPerformanceCounter(var lpPerformanceCount: comp):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____QueryPerformanceCounter,a) then result:=twin____QueryPerformanceCounter(a)(lpPerformanceCount);
win__dec;
end;


//function win____QueryPerformanceFrequency(var lpFrequency: comp): BOOL; stdcall; external kernel32 name 'QueryPerformanceFrequency';;

function win____QueryPerformanceFrequency(var lpFrequency: comp):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____QueryPerformanceFrequency,a) then result:=twin____QueryPerformanceFrequency(a)(lpFrequency);
win__dec;
end;


//function win____GetVolumeInformation(lpRootPathName: PChar; lpVolumeNameBuffer: PChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD; var lpMaximumComponentLength, lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PChar; nFileSystemNameSize: DWORD): BOOL; stdcall; external kernel32 name 'GetVolumeInformationA';;

function win____GetVolumeInformation(lpRootPathName: PChar; lpVolumeNameBuffer: PChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD; var lpMaximumComponentLength, lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PChar; nFileSystemNameSize: DWORD):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetVolumeInformation,a) then result:=twin____GetVolumeInformation(a)(lpRootPathName, lpVolumeNameBuffer, nVolumeNameSize, lpVolumeSerialNumber, lpMaximumComponentLength, lpFileSystemFlags, lpFileSystemNameBuffer, nFileSystemNameSize);
win__dec;
end;


//function win____GetShortPathName(lpszLongPath: PChar; lpszShortPath: PChar; cchBuffer: DWORD): DWORD; stdcall; external kernel32 name 'GetShortPathNameA';;

function win____GetShortPathName(lpszLongPath: PChar; lpszShortPath: PChar; cchBuffer: DWORD):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetShortPathName,a) then result:=twin____GetShortPathName(a)(lpszLongPath, lpszShortPath, cchBuffer);
win__dec;
end;


//function win____SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer; var ppidl: PItemIDList): HResult; stdcall; external shell32 name 'SHGetSpecialFolderLocation';;

function win____SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer; var ppidl: PItemIDList):hresult;
var
   a:pointer;
begin
if win__useint(result,vwin____SHGetSpecialFolderLocation,a) then result:=twin____SHGetSpecialFolderLocation(a)(hwndOwner, nFolder, ppidl);
win__dec;
end;


//function win____SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall; external shell32 name 'SHGetPathFromIDListA';;

function win____SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SHGetPathFromIDList,a) then result:=twin____SHGetPathFromIDList(a)(pidl, pszPath);
win__dec;
end;


//function win____GetWindowsDirectoryA(lpBuffer: PAnsiChar; uSize: UINT): UINT; stdcall; external kernel32 name 'GetWindowsDirectoryA';;

function win____GetWindowsDirectoryA(lpBuffer: PAnsiChar; uSize: UINT):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____GetWindowsDirectoryA,a) then result:=twin____GetWindowsDirectoryA(a)(lpBuffer, uSize);
win__dec;
end;


//function win____GetSystemDirectoryA(lpBuffer: PAnsiChar; uSize: UINT): UINT; stdcall; external kernel32 name 'GetSystemDirectoryA';;

function win____GetSystemDirectoryA(lpBuffer: PAnsiChar; uSize: UINT):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____GetSystemDirectoryA,a) then result:=twin____GetSystemDirectoryA(a)(lpBuffer, uSize);
win__dec;
end;


//function win____GetTempPathA(nBufferLength: DWORD; lpBuffer: PAnsiChar): DWORD; stdcall; external kernel32 name 'GetTempPathA';;

function win____GetTempPathA(nBufferLength: DWORD; lpBuffer: PAnsiChar):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetTempPathA,a) then result:=twin____GetTempPathA(a)(nBufferLength, lpBuffer);
win__dec;
end;


//function win____FlushFileBuffers(hFile: THandle): BOOL; stdcall; external kernel32 name 'FlushFileBuffers';;

function win____FlushFileBuffers(hFile: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____FlushFileBuffers,a) then result:=twin____FlushFileBuffers(a)(hFile);
win__dec;
end;


//function win____CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: Integer; lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD; hTemplateFile: THandle): THandle; stdcall; external kernel32 name 'CreateFileA';;

function win____CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: Integer; lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD; hTemplateFile: THandle):thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____CreateFile,a) then result:=twin____CreateFile(a)(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
win__dec;
end;


//function win____GetFileSize(hFile: THandle; lpFileSizeHigh: Pointer): DWORD; stdcall; external kernel32 name 'GetFileSize';;

function win____GetFileSize(hFile: THandle; lpFileSizeHigh: Pointer):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetFileSize,a) then result:=twin____GetFileSize(a)(hFile, lpFileSizeHigh);
win__dec;
end;


//procedure win____GetSystemTime(var lpSystemTime: TSystemTime); stdcall; external kernel32 name 'GetSystemTime';;

procedure win____GetSystemTime(var lpSystemTime: TSystemTime);
var
   a:pointer;
begin
if win__use(vwin____GetSystemTime,a) then twin____GetSystemTime(a)(lpSystemTime);
win__dec;
end;


//function win____CloseHandle(hObject: THandle): BOOL; stdcall; external kernel32 name 'CloseHandle';;

function win____CloseHandle(hObject: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____CloseHandle,a) then result:=twin____CloseHandle(a)(hObject);
win__dec;
end;


//function win____GetFileInformationByHandle(hFile: THandle; var lpFileInformation: TByHandleFileInformation): BOOL; stdcall; external kernel32 name 'GetFileInformationByHandle';;

function win____GetFileInformationByHandle(hFile: THandle; var lpFileInformation: TByHandleFileInformation):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____GetFileInformationByHandle,a) then result:=twin____GetFileInformationByHandle(a)(hFile, lpFileInformation);
win__dec;
end;


//function win____SetFilePointer(hFile: THandle; lDistanceToMove: Longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall; external kernel32 name 'SetFilePointer';;

function win____SetFilePointer(hFile: THandle; lDistanceToMove: Longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____SetFilePointer,a) then result:=twin____SetFilePointer(a)(hFile, lDistanceToMove, lpDistanceToMoveHigh, dwMoveMethod);
win__dec;
end;


//function win____SetEndOfFile(hFile: THandle): BOOL; stdcall; external kernel32 name 'SetEndOfFile';;

function win____SetEndOfFile(hFile: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetEndOfFile,a) then result:=twin____SetEndOfFile(a)(hFile);
win__dec;
end;


//function win____WriteFile(hFile: THandle; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external kernel32 name 'WriteFile';;

function win____WriteFile(hFile: THandle; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____WriteFile,a) then result:=twin____WriteFile(a)(hFile, Buffer, nNumberOfBytesToWrite, lpNumberOfBytesWritten, lpOverlapped);
win__dec;
end;


//function win____ReadFile(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external kernel32 name 'ReadFile';;

function win____ReadFile(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ReadFile,a) then result:=twin____ReadFile(a)(hFile, Buffer, nNumberOfBytesToRead, lpNumberOfBytesRead, lpOverlapped);
win__dec;
end;


//function win____GetLogicalDrives: DWORD; stdcall; external kernel32 name 'GetLogicalDrives';;

function win____GetLogicalDrives:dword;
var
   a:pointer;
begin
if win__useint(result,vwin____GetLogicalDrives,a) then result:=twin____GetLogicalDrives(a);
win__dec;
end;


//function win____FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL; stdcall; external kernel32 name 'FileTimeToLocalFileTime';;

function win____FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____FileTimeToLocalFileTime,a) then result:=twin____FileTimeToLocalFileTime(a)(lpFileTime, lpLocalFileTime);
win__dec;
end;


//function win____FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL; stdcall; external kernel32 name 'FileTimeToDosDateTime';;

function win____FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____FileTimeToDosDateTime,a) then result:=twin____FileTimeToDosDateTime(a)(lpFileTime, lpFatDate, lpFatTime);
win__dec;
end;


//function win____DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'DefWindowProcA';;

function win____DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM):lresult;
var
   a:pointer;
begin
if win__useint(result,vwin____DefWindowProc,a) then result:=twin____DefWindowProc(a)(hWnd, Msg, wParam, lParam);
win__dec;
end;


//function win____RegisterClass(const lpWndClass: TWndClass): ATOM; stdcall; external user32 name 'RegisterClassA';;

function win____RegisterClass(const lpWndClass: TWndClass):atom;
var
   a:pointer;
begin
if win__usewrd(result,vwin____RegisterClass,a) then result:=twin____RegisterClass(a)(lpWndClass);
win__dec;
end;


//function win____RegisterClassA(const lpWndClass: TWndClassA): ATOM; stdcall; external user32 name 'RegisterClassA';;

function win____RegisterClassA(const lpWndClass: TWndClassA):atom;
var
   a:pointer;
begin
if win__usewrd(result,vwin____RegisterClassA,a) then result:=twin____RegisterClassA(a)(lpWndClass);
win__dec;
end;


//function win____CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar; lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall; external user32 name 'CreateWindowExA';;

function win____CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar; lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer):hwnd;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateWindowEx,a) then result:=twin____CreateWindowEx(a)(dwExStyle, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
win__dec;
end;


//function win____EnableWindow(hWnd: HWND; bEnable: BOOL): BOOL; stdcall; external user32 name 'EnableWindow';;

function win____EnableWindow(hWnd: HWND; bEnable: BOOL):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____EnableWindow,a) then result:=twin____EnableWindow(a)(hWnd, bEnable);
win__dec;
end;


//function win____IsWindowEnabled(hWnd: HWND): BOOL; stdcall; external user32 name 'IsWindowEnabled';;

function win____IsWindowEnabled(hWnd: HWND):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____IsWindowEnabled,a) then result:=twin____IsWindowEnabled(a)(hWnd);
win__dec;
end;


//function win____UpdateWindow(hWnd: HWND): BOOL; stdcall; external user32 name 'UpdateWindow';;

function win____UpdateWindow(hWnd: HWND):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____UpdateWindow,a) then result:=twin____UpdateWindow(a)(hWnd);
win__dec;
end;


//function win____ShellExecute(hWnd: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST; stdcall; external shell32 name 'ShellExecuteA';;

function win____ShellExecute(hWnd: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer):hinst;
var
   a:pointer;
begin
if win__useint(result,vwin____ShellExecute,a) then result:=twin____ShellExecute(a)(hWnd, Operation, FileName, Parameters, Directory, ShowCmd);
win__dec;
end;


//function win____ShellExecuteEx(lpExecInfo: PShellExecuteInfo):BOOL; stdcall; external shell32 name 'ShellExecuteExA';;

function win____ShellExecuteEx(lpExecInfo: PShellExecuteInfo):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____ShellExecuteEx,a) then result:=twin____ShellExecuteEx(a)(lpExecInfo);
win__dec;
end;


//function win____SHGetMalloc(var ppMalloc: imalloc): HResult; stdcall; external shell32 name 'SHGetMalloc';;

function win____SHGetMalloc(var ppMalloc: imalloc):hresult;
var
   a:pointer;
begin
if win__useint(result,vwin____SHGetMalloc,a) then result:=twin____SHGetMalloc(a)(ppMalloc);
win__dec;
end;


//function win____CoCreateInstance(const clsid: TCLSID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TIID; out pv): HResult; stdcall; external ole32 name 'CoCreateInstance';;

function win____CoCreateInstance(const clsid: TCLSID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TIID; out pv):hresult;
var
   a:pointer;
begin
if win__useint(result,vwin____CoCreateInstance,a) then result:=twin____CoCreateInstance(a)(clsid, unkOuter, dwClsContext, iid, pv);
win__dec;
end;


//function win____GetObject(p1: HGDIOBJ; p2: Integer; p3: Pointer): Integer; stdcall; external gdi32 name 'GetObjectA';;

function win____GetObject(p1: HGDIOBJ; p2: Integer; p3: Pointer):integer;
var
   a:pointer;
begin
if win__useint(result,vwin____GetObject,a) then result:=twin____GetObject(a)(p1, p2, p3);
win__dec;
end;


//function win____CreateFontIndirect(const p1: TLogFont): HFONT; stdcall; external gdi32 name 'CreateFontIndirectA';;

function win____CreateFontIndirect(const p1: TLogFont):hfont;
var
   a:pointer;
begin
if win__useint(result,vwin____CreateFontIndirect,a) then result:=twin____CreateFontIndirect(a)(p1);
win__dec;
end;


//function win____SelectObject(DC: HDC; p2: HGDIOBJ): HGDIOBJ; stdcall; external gdi32 name 'SelectObject';;

function win____SelectObject(DC: HDC; p2: HGDIOBJ):hgdiobj;
var
   a:pointer;
begin
if win__useint(result,vwin____SelectObject,a) then result:=twin____SelectObject(a)(DC, p2);
win__dec;
end;


//function win____DeleteObject(p1: HGDIOBJ): BOOL; stdcall; external gdi32 name 'DeleteObject';;

function win____DeleteObject(p1: HGDIOBJ):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____DeleteObject,a) then result:=twin____DeleteObject(a)(p1);
win__dec;
end;


//procedure win____sleep(dwMilliseconds: DWORD); stdcall; external kernel32 name 'Sleep';;

procedure win____sleep(dwMilliseconds: DWORD);
var
   a:pointer;
begin
if win__use(vwin____sleep,a) then twin____sleep(a)(dwMilliseconds);
win__dec;
end;


//function win____sleepex(dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall; external kernel32 name 'SleepEx';;

function win____sleepex(dwMilliseconds: DWORD; bAlertable: BOOL):dword;
var
   a:pointer;
begin
if win__useint(result,vwin____sleepex,a) then result:=twin____sleepex(a)(dwMilliseconds, bAlertable);
win__dec;
end;


//function win____RegConnectRegistry(lpMachineName: PChar; hKey: HKEY; var phkResult: HKEY): Longint; stdcall; external advapi32 name 'RegConnectRegistryA';;

function win____RegConnectRegistry(lpMachineName: PChar; hKey: HKEY; var phkResult: HKEY):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____RegConnectRegistry,a) then result:=twin____RegConnectRegistry(a)(lpMachineName, hKey, phkResult);
win__dec;
end;


//function win___RegCreateKeyEx(hKey:HKEY;lpSubKey:PChar;Reserved:DWORD;lpClass:PChar;dwOptions:DWORD;samDesired:REGSAM;lpSecurityAttributes:PSecurityAttributes;var phkResult:HKEY;lpdwDisposition:PDWORD):Longint; stdcall; external advapi32 name 'RegCreateKeyExA';;

function win___RegCreateKeyEx(hKey:HKEY;lpSubKey:PChar;Reserved:DWORD;lpClass:PChar;dwOptions:DWORD;samDesired:REGSAM;lpSecurityAttributes:PSecurityAttributes;var phkResult:HKEY;lpdwDisposition:PDWORD):longint;
var
   a:pointer;
begin
if win__useint(result,vwin___RegCreateKeyEx,a) then result:=twin___RegCreateKeyEx(a)(hKey, lpSubKey, Reserved, lpClass, dwOptions, samDesired, lpSecurityAttributes, phkResult, lpdwDisposition);
win__dec;
end;


//function win____RegOpenKey(hKey: HKEY; lpSubKey: PChar; var phkResult: HKEY): Longint; stdcall; external advapi32 name 'RegOpenKeyA';;

function win____RegOpenKey(hKey: HKEY; lpSubKey: PChar; var phkResult: HKEY):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____RegOpenKey,a) then result:=twin____RegOpenKey(a)(hKey, lpSubKey, phkResult);
win__dec;
end;


//function win____RegCloseKey(hKey: HKEY): Longint; stdcall; external advapi32 name 'RegCloseKey';;

function win____RegCloseKey(hKey: HKEY):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____RegCloseKey,a) then result:=twin____RegCloseKey(a)(hKey);
win__dec;
end;


//function win____RegDeleteKey(hKey: HKEY; lpSubKey: PChar): Longint; stdcall; external advapi32 name 'RegDeleteKeyA';;

function win____RegDeleteKey(hKey: HKEY; lpSubKey: PChar):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____RegDeleteKey,a) then result:=twin____RegDeleteKey(a)(hKey, lpSubKey);
win__dec;
end;


//function win____RegOpenKeyEx(hKey: HKEY; lpSubKey: PChar; ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY): Longint; stdcall; external advapi32 name 'RegOpenKeyExA';;

function win____RegOpenKeyEx(hKey: HKEY; lpSubKey: PChar; ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____RegOpenKeyEx,a) then result:=twin____RegOpenKeyEx(a)(hKey, lpSubKey, ulOptions, samDesired, phkResult);
win__dec;
end;


//function win____RegQueryValueEx(hKey: HKEY; lpValueName: PChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint; stdcall; external advapi32 name 'RegQueryValueExA';;

function win____RegQueryValueEx(hKey: HKEY; lpValueName: PChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____RegQueryValueEx,a) then result:=twin____RegQueryValueEx(a)(hKey, lpValueName, lpReserved, lpType, lpData, lpcbData);
win__dec;
end;


//function win____RegSetValueEx(hKey: HKEY; lpValueName: PChar; Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD): Longint; stdcall; external advapi32 name 'RegSetValueExA';;

function win____RegSetValueEx(hKey: HKEY; lpValueName: PChar; Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD):longint;
var
   a:pointer;
begin
if win__useint(result,vwin____RegSetValueEx,a) then result:=twin____RegSetValueEx(a)(hKey, lpValueName, Reserved, dwType, lpData, cbData);
win__dec;
end;


//function win____StartServiceCtrlDispatcher(var lpServiceStartTable: TServiceTableEntry): BOOL; stdcall; external advapi32 name 'StartServiceCtrlDispatcherA';;

function win____StartServiceCtrlDispatcher(var lpServiceStartTable: TServiceTableEntry):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____StartServiceCtrlDispatcher,a) then result:=twin____StartServiceCtrlDispatcher(a)(lpServiceStartTable);
win__dec;
end;


//function win____RegisterServiceCtrlHandler(lpServiceName: PChar; lpHandlerProc: ThandlerFunction): SERVICE_STATUS_HANDLE; stdcall; external advapi32 name 'RegisterServiceCtrlHandlerA';;

function win____RegisterServiceCtrlHandler(lpServiceName: PChar; lpHandlerProc: ThandlerFunction):service_status_handle;
var
   a:pointer;
begin
if win__useint(result,vwin____RegisterServiceCtrlHandler,a) then result:=twin____RegisterServiceCtrlHandler(a)(lpServiceName, lpHandlerProc);
win__dec;
end;


//function win____SetServiceStatus(hServiceStatus: SERVICE_STATUS_HANDLE; var lpServiceStatus: TServiceStatus): BOOL; stdcall; external advapi32 name 'SetServiceStatus';;

function win____SetServiceStatus(hServiceStatus: SERVICE_STATUS_HANDLE; var lpServiceStatus: TServiceStatus):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____SetServiceStatus,a) then result:=twin____SetServiceStatus(a)(hServiceStatus, lpServiceStatus);
win__dec;
end;


//function win____OpenSCManager(lpMachineName, lpDatabaseName: PChar; dwDesiredAccess: DWORD): SC_HANDLE; stdcall; external advapi32 name 'OpenSCManagerA';;

function win____OpenSCManager(lpMachineName, lpDatabaseName: PChar; dwDesiredAccess: DWORD):sc_handle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____OpenSCManager,a) then result:=twin____OpenSCManager(a)(lpMachineName, lpDatabaseName, dwDesiredAccess);
win__dec;
end;


//function win____CloseServiceHandle(hSCObject: SC_HANDLE): BOOL; stdcall; external advapi32 name 'CloseServiceHandle';;

function win____CloseServiceHandle(hSCObject: SC_HANDLE):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____CloseServiceHandle,a) then result:=twin____CloseServiceHandle(a)(hSCObject);
win__dec;
end;


//function win____CreateService(hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PChar; dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PChar; lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword: PChar): SC_HANDLE; stdcall; external advapi32 name 'CreateServiceA';;

function win____CreateService(hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PChar; dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PChar; lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword: PChar):sc_handle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____CreateService,a) then result:=twin____CreateService(a)(hSCManager, lpServiceName, lpDisplayName, dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl, lpBinaryPathName, lpLoadOrderGroup, lpdwTagId, lpDependencies, lpServiceStartName, lpPassword);
win__dec;
end;


//function win____OpenService(hSCManager: SC_HANDLE; lpServiceName: PChar; dwDesiredAccess: DWORD): SC_HANDLE; stdcall; external advapi32 name 'OpenServiceA';;

function win____OpenService(hSCManager: SC_HANDLE; lpServiceName: PChar; dwDesiredAccess: DWORD):sc_handle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____OpenService,a) then result:=twin____OpenService(a)(hSCManager, lpServiceName, dwDesiredAccess);
win__dec;
end;


//function win____DeleteService(hService: SC_HANDLE): BOOL; stdcall; external advapi32 name 'DeleteService';;

function win____DeleteService(hService: SC_HANDLE):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____DeleteService,a) then result:=twin____DeleteService(a)(hService);
win__dec;
end;


//function win____timeGetTime: DWORD; stdcall; external mmsyst name 'timeGetTime';;

function win____timeGetTime:dword;
var
   a:pointer;
begin
if win__useint(result,vwin____timeGetTime,a) then result:=twin____timeGetTime(a);
win__dec;
end;


//function win____timeSetEvent(uDelay, uResolution: UINT;  lpFunction: TFNTimeCallBack; dwUser: DWORD; uFlags: UINT): UINT; stdcall; external mmsyst name 'timeSetEvent';;

function win____timeSetEvent(uDelay, uResolution: UINT;  lpFunction: TFNTimeCallBack; dwUser: DWORD; uFlags: UINT):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____timeSetEvent,a) then result:=twin____timeSetEvent(a)(uDelay, uResolution, lpFunction, dwUser, uFlags);
win__dec;
end;


//function win____timeKillEvent(uTimerID: UINT): UINT; stdcall; external mmsyst name 'timeKillEvent';;

function win____timeKillEvent(uTimerID: UINT):uint;
var
   a:pointer;
begin
if win__useint(result,vwin____timeKillEvent,a) then result:=twin____timeKillEvent(a)(uTimerID);
win__dec;
end;


//function win____timeBeginPeriod(uPeriod: UINT): MMRESULT; stdcall; external mmsyst name 'timeBeginPeriod';;

function win____timeBeginPeriod(uPeriod: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____timeBeginPeriod,a) then result:=twin____timeBeginPeriod(a)(uPeriod);
win__dec;
end;


//function win____timeEndPeriod(uPeriod: UINT): MMRESULT; stdcall; external mmsyst name 'timeEndPeriod';;

function win____timeEndPeriod(uPeriod: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____timeEndPeriod,a) then result:=twin____timeEndPeriod(a)(uPeriod);
win__dec;
end;


//function net____WSAStartup(wVersionRequired: word; var WSData: TWSAData): Integer;                               stdcall;external winsocket name 'WSAStartup';;

function net____WSAStartup(wVersionRequired: word; var WSData: TWSAData):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____WSAStartup,a) then result:=tnet____WSAStartup(a)(wVersionRequired, WSData);
win__dec;
end;


//function net____WSACleanup: Integer;                                                                             stdcall;external winsocket name 'WSACleanup';;

function net____WSACleanup:integer;
var
   a:pointer;
begin
if win__useint(result,vnet____WSACleanup,a) then result:=tnet____WSACleanup(a);
win__dec;
end;


//function net____wsaasyncselect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer;                stdcall;external winsocket name 'WSAAsyncSelect';;

function net____wsaasyncselect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____wsaasyncselect,a) then result:=tnet____wsaasyncselect(a)(s, HWindow, wMsg, lEvent);
win__dec;
end;


//function net____WSAGetLastError: Integer;                                                                        stdcall;external winsocket name 'WSAGetLastError';;

function net____WSAGetLastError:integer;
var
   a:pointer;
begin
if win__useint(result,vnet____WSAGetLastError,a) then result:=tnet____WSAGetLastError(a);
win__dec;
end;


//function net____makesocket(af, struct, protocol: Integer): TSocket;                                              stdcall;external winsocket name 'socket';;

function net____makesocket(af, struct, protocol: Integer):tsocket;
var
   a:pointer;
begin
if win__useint(result,vnet____makesocket,a) then result:=tnet____makesocket(a)(af, struct, protocol);
win__dec;
end;


//function net____bind(s: TSocket; var addr: TSockAddr; namelen: Integer): Integer;                                stdcall;external winsocket name 'bind';;

function net____bind(s: TSocket; var addr: TSockAddr; namelen: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____bind,a) then result:=tnet____bind(a)(s, addr, namelen);
win__dec;
end;


//function net____listen(s: TSocket; backlog: Integer): Integer;                                                   stdcall;external winsocket name 'listen';;

function net____listen(s: TSocket; backlog: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____listen,a) then result:=tnet____listen(a)(s, backlog);
win__dec;
end;


//function net____closesocket(s: tsocket): integer;                                                                stdcall;external winsocket name 'closesocket';;

function net____closesocket(s: tsocket):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____closesocket,a) then result:=tnet____closesocket(a)(s);
win__dec;
end;


//function net____getsockopt(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer): Integer;    stdcall;external winsocket name 'getsockopt';;

function net____getsockopt(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____getsockopt,a) then result:=tnet____getsockopt(a)(s, level, optname, optval, optlen);
win__dec;
end;


//function net____accept(s: TSocket; addr: PSockAddr; addrlen: PInteger): TSocket;                                 stdcall;external winsocket name 'accept';;

function net____accept(s: TSocket; addr: PSockAddr; addrlen: PInteger):tsocket;
var
   a:pointer;
begin
if win__useint(result,vnet____accept,a) then result:=tnet____accept(a)(s, addr, addrlen);
win__dec;
end;


//function net____recv(s: TSocket; var Buf; len, flags: Integer): Integer;                                         stdcall;external winsocket name 'recv';;

function net____recv(s: TSocket; var Buf; len, flags: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____recv,a) then result:=tnet____recv(a)(s, Buf, len, flags);
win__dec;
end;


//function net____send(s: TSocket; var Buf; len, flags: Integer): Integer;                                         stdcall;external winsocket name 'send';;

function net____send(s: TSocket; var Buf; len, flags: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____send,a) then result:=tnet____send(a)(s, Buf, len, flags);
win__dec;
end;


//function net____getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;                     stdcall;external winsocket name 'getpeername';;

function net____getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____getpeername,a) then result:=tnet____getpeername(a)(s, name, namelen);
win__dec;
end;


//function net____connect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer;                             stdcall;external winsocket name 'connect';;

function net____connect(s: TSocket; var name: TSockAddr; namelen: Integer):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____connect,a) then result:=tnet____connect(a)(s, name, namelen);
win__dec;
end;


//function net____ioctlsocket(s: TSocket; cmd: Longint; var arg: u_long): Integer;                                 stdcall;external winsocket name 'ioctlsocket';;

function net____ioctlsocket(s: TSocket; cmd: Longint; var arg: u_long):integer;
var
   a:pointer;
begin
if win__useint(result,vnet____ioctlsocket,a) then result:=tnet____ioctlsocket(a)(s, cmd, arg);
win__dec;
end;


//function win____FindFirstFile(lpFileName: PChar; var lpFindFileData: TWIN32FindData): THandle; stdcall; external kernel32 name 'FindFirstFileA';;

function win____FindFirstFile(lpFileName: PChar; var lpFindFileData: TWIN32FindData):thandle;
var
   a:pointer;
begin
if win__usehnd(result,vwin____FindFirstFile,a) then result:=twin____FindFirstFile(a)(lpFileName, lpFindFileData);
win__dec;
end;


//function win____FindNextFile(hFindFile: THandle; var lpFindFileData: TWIN32FindData): BOOL; stdcall; external kernel32 name 'FindNextFileA';;

function win____FindNextFile(hFindFile: THandle; var lpFindFileData: TWIN32FindData):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____FindNextFile,a) then result:=twin____FindNextFile(a)(hFindFile, lpFindFileData);
win__dec;
end;


//function win____FindClose(hFindFile: THandle): BOOL; stdcall; external kernel32 name 'FindClose';;

function win____FindClose(hFindFile: THandle):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____FindClose,a) then result:=twin____FindClose(a)(hFindFile);
win__dec;
end;


//function win____RemoveDirectory(lpPathName: PChar): BOOL; stdcall; external kernel32 name 'RemoveDirectoryA';;

function win____RemoveDirectory(lpPathName: PChar):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____RemoveDirectory,a) then result:=twin____RemoveDirectory(a)(lpPathName);
win__dec;
end;


//function win____waveOutGetDevCaps(uDeviceID: UINT; lpCaps: PWaveOutCaps; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveOutGetDevCapsA';;

function win____waveOutGetDevCaps(uDeviceID: UINT; lpCaps: PWaveOutCaps; uSize: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveOutGetDevCaps,a) then result:=twin____waveOutGetDevCaps(a)(uDeviceID, lpCaps, uSize);
win__dec;
end;


//function win____waveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: UINT; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall; external mmsyst name 'waveOutOpen';;

function win____waveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: UINT; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveOutOpen,a) then result:=twin____waveOutOpen(a)(lphWaveOut, uDeviceID, lpFormat, dwCallback, dwInstance, dwFlags);
win__dec;
end;


//function win____waveOutClose(hWaveOut: HWAVEOUT): MMRESULT; stdcall; external mmsyst name 'waveOutClose';;

function win____waveOutClose(hWaveOut: HWAVEOUT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveOutClose,a) then result:=twin____waveOutClose(a)(hWaveOut);
win__dec;
end;


//function win____waveOutPrepareHeader(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveOutPrepareHeader';;

function win____waveOutPrepareHeader(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveOutPrepareHeader,a) then result:=twin____waveOutPrepareHeader(a)(hWaveOut, lpWaveOutHdr, uSize);
win__dec;
end;


//function win____waveOutUnprepareHeader(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveOutUnprepareHeader';;

function win____waveOutUnprepareHeader(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveOutUnprepareHeader,a) then result:=twin____waveOutUnprepareHeader(a)(hWaveOut, lpWaveOutHdr, uSize);
win__dec;
end;


//function win____waveOutWrite(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveOutWrite';;

function win____waveOutWrite(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveOutWrite,a) then result:=twin____waveOutWrite(a)(hWaveOut, lpWaveOutHdr, uSize);
win__dec;
end;


//function win____waveInOpen(lphWaveIn: PHWAVEIN; uDeviceID: UINT; lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall; external mmsyst name 'waveInOpen';;

function win____waveInOpen(lphWaveIn: PHWAVEIN; uDeviceID: UINT; lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveInOpen,a) then result:=twin____waveInOpen(a)(lphWaveIn, uDeviceID, lpFormatEx, dwCallback, dwInstance, dwFlags);
win__dec;
end;


//function win____waveInClose(hWaveIn: HWAVEIN): MMRESULT; stdcall; external mmsyst name 'waveInClose';;

function win____waveInClose(hWaveIn: HWAVEIN):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveInClose,a) then result:=twin____waveInClose(a)(hWaveIn);
win__dec;
end;


//function win____waveInPrepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveInPrepareHeader';;

function win____waveInPrepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveInPrepareHeader,a) then result:=twin____waveInPrepareHeader(a)(hWaveIn, lpWaveInHdr, uSize);
win__dec;
end;


//function win____waveInUnprepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveInUnprepareHeader';;

function win____waveInUnprepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveInUnprepareHeader,a) then result:=twin____waveInUnprepareHeader(a)(hWaveIn, lpWaveInHdr, uSize);
win__dec;
end;


//function win____waveInAddBuffer(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'waveInAddBuffer';;

function win____waveInAddBuffer(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr; uSize: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveInAddBuffer,a) then result:=twin____waveInAddBuffer(a)(hWaveIn, lpWaveInHdr, uSize);
win__dec;
end;


//function win____waveInStart(hWaveIn: HWAVEIN): MMRESULT; stdcall; external mmsyst name 'waveInStart';;

function win____waveInStart(hWaveIn: HWAVEIN):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveInStart,a) then result:=twin____waveInStart(a)(hWaveIn);
win__dec;
end;


//function win____waveInStop(hWaveIn: HWAVEIN): MMRESULT; stdcall; external mmsyst name 'waveInStop';;

function win____waveInStop(hWaveIn: HWAVEIN):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveInStop,a) then result:=twin____waveInStop(a)(hWaveIn);
win__dec;
end;


//function win____waveInReset(hWaveIn: HWAVEIN): MMRESULT; stdcall; external mmsyst name 'waveInReset';;

function win____waveInReset(hWaveIn: HWAVEIN):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveInReset,a) then result:=twin____waveInReset(a)(hWaveIn);
win__dec;
end;


//function win____midiOutGetNumDevs: UINT; stdcall; external mmsyst name 'midiOutGetNumDevs';;

function win____midiOutGetNumDevs:uint;
var
   a:pointer;
begin
if win__useint(result,vwin____midiOutGetNumDevs,a) then result:=twin____midiOutGetNumDevs(a);
win__dec;
end;


//function win____midiOutGetDevCaps(uDeviceID: UINT; lpCaps: PMidiOutCaps; uSize: UINT): MMRESULT; stdcall; external mmsyst name 'midiOutGetDevCapsA';;

function win____midiOutGetDevCaps(uDeviceID: UINT; lpCaps: PMidiOutCaps; uSize: UINT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____midiOutGetDevCaps,a) then result:=twin____midiOutGetDevCaps(a)(uDeviceID, lpCaps, uSize);
win__dec;
end;


//function win____midiOutOpen(lphMidiOut: PHMIDIOUT; uDeviceID: UINT; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutOpen';;

function win____midiOutOpen(lphMidiOut: PHMIDIOUT; uDeviceID: UINT; dwCallback, dwInstance, dwFlags: DWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____midiOutOpen,a) then result:=twin____midiOutOpen(a)(lphMidiOut, uDeviceID, dwCallback, dwInstance, dwFlags);
win__dec;
end;


//function win____midiOutClose(hMidiOut: HMIDIOUT): MMRESULT; stdcall; external mmsyst name 'midiOutClose';;

function win____midiOutClose(hMidiOut: HMIDIOUT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____midiOutClose,a) then result:=twin____midiOutClose(a)(hMidiOut);
win__dec;
end;


//function win____midiOutReset(hMidiOut: HMIDIOUT): MMRESULT; stdcall; external mmsyst name 'midiOutReset';//for midi streams only? -> hence the "no effect" for volume reset between songs - 15apr2021;

function win____midiOutReset(hMidiOut: HMIDIOUT):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____midiOutReset,a) then result:=twin____midiOutReset(a)(hMidiOut);
win__dec;
end;


//function win____midiOutShortMsg(const hMidiOut: HMIDIOUT; const dwMsg: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutShortMsg';;

function win____midiOutShortMsg(const hMidiOut: HMIDIOUT; const dwMsg: DWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____midiOutShortMsg,a) then result:=twin____midiOutShortMsg(a)(hMidiOut, dwMsg);
win__dec;
end;


//function win____mciSendCommand(mciId:MCIDEVICEID;uMessage:UINT;dwParam1,dwParam2:DWORD):MCIERROR; stdcall; external winmm name 'mciSendCommandA';;

function win____mciSendCommand(mciId:MCIDEVICEID;uMessage:UINT;dwParam1,dwParam2:DWORD):mcierror;
var
   a:pointer;
begin
if win__useint(result,vwin____mciSendCommand,a) then result:=twin____mciSendCommand(a)(mciId, uMessage, dwParam1, dwParam2);
win__dec;
end;


//function win____mciGetErrorString(mcierr: MCIERROR; pszText: PChar; uLength: UINT): BOOL; stdcall; external winmm name 'mciGetErrorStringA';;

function win____mciGetErrorString(mcierr: MCIERROR; pszText: PChar; uLength: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin____mciGetErrorString,a) then result:=twin____mciGetErrorString(a)(mcierr, pszText, uLength);
win__dec;
end;


//function win____waveOutGetVolume(hwo: longint; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'waveOutGetVolume';;

function win____waveOutGetVolume(hwo: longint; lpdwVolume: PDWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveOutGetVolume,a) then result:=twin____waveOutGetVolume(a)(hwo, lpdwVolume);
win__dec;
end;


//function win____waveOutSetVolume(hwo: longint; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'waveOutSetVolume';;

function win____waveOutSetVolume(hwo: longint; dwVolume: DWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____waveOutSetVolume,a) then result:=twin____waveOutSetVolume(a)(hwo, dwVolume);
win__dec;
end;


//function win____midiOutGetVolume(hmo: longint; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'midiOutGetVolume';;

function win____midiOutGetVolume(hmo: longint; lpdwVolume: PDWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____midiOutGetVolume,a) then result:=twin____midiOutGetVolume(a)(hmo, lpdwVolume);
win__dec;
end;


//function win____midiOutSetVolume(hmo: longint; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'midiOutSetVolume';;

function win____midiOutSetVolume(hmo: longint; dwVolume: DWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____midiOutSetVolume,a) then result:=twin____midiOutSetVolume(a)(hmo, dwVolume);
win__dec;
end;


//function win____auxSetVolume(uDeviceID: UINT; dwVolume: DWORD): MMRESULT; stdcall; external mmsyst name 'auxSetVolume';;

function win____auxSetVolume(uDeviceID: UINT; dwVolume: DWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____auxSetVolume,a) then result:=twin____auxSetVolume(a)(uDeviceID, dwVolume);
win__dec;
end;


//function win____auxGetVolume(uDeviceID: UINT; lpdwVolume: PDWORD): MMRESULT; stdcall; external mmsyst name 'auxGetVolume';;

function win____auxGetVolume(uDeviceID: UINT; lpdwVolume: PDWORD):mmresult;
var
   a:pointer;
begin
if win__useint(result,vwin____auxGetVolume,a) then result:=twin____auxGetVolume(a)(uDeviceID, lpdwVolume);
win__dec;
end;


//function win2____GetGuiResources(xhandle:thandle;flags:dword):dword; stdcall; external user32 name 'GetGuiResources';;

function win2____GetGuiResources(xhandle:thandle;flags:dword):dword;
var
   a:pointer;
begin
if win__useint(result,vwin2____GetGuiResources,a) then result:=twin2____GetGuiResources(a)(xhandle, flags);
win__dec;
end;


//function win2____SetProcessDpiAwarenessContext(inDPI_AWARENESS_CONTEXT:dword):lresult; stdcall; external user32 name 'SetProcessDpiAwarenessContext';;

function win2____SetProcessDpiAwarenessContext(inDPI_AWARENESS_CONTEXT:dword):lresult;
var
   a:pointer;
begin
if win__useint(result,vwin2____SetProcessDpiAwarenessContext,a) then result:=twin2____SetProcessDpiAwarenessContext(a)(inDPI_AWARENESS_CONTEXT);
win__dec;
end;


//function win2____GetMonitorInfo(Monitor:hmonitor;lpMonitorInfo:pmonitorinfo):lresult; stdcall; external user32 name 'GetMonitorInfoA';;

function win2____GetMonitorInfo(Monitor:hmonitor;lpMonitorInfo:pmonitorinfo):lresult;
var
   a:pointer;
begin
if win__useint(result,vwin2____GetMonitorInfo,a) then result:=twin2____GetMonitorInfo(a)(Monitor, lpMonitorInfo);
win__dec;
end;


//function win2____EnumDisplayMonitors(dc:hdc;lpcrect:pwinrect;userProc:PMonitorenumproc;dwData:lparam):lresult; stdcall; external user32 name 'EnumDisplayMonitors';;

function win2____EnumDisplayMonitors(dc:hdc;lpcrect:pwinrect;userProc:PMonitorenumproc;dwData:lparam):lresult;
var
   a:pointer;
begin
if win__useint(result,vwin2____EnumDisplayMonitors,a) then result:=twin2____EnumDisplayMonitors(a)(dc, lpcrect, userProc, dwData);
win__dec;
end;


//function win2____GetDpiForMonitor(monitor:hmonitor;dpiType:longint;var dpiX,dpiY:uint):lresult; stdcall; external Shcore name 'GetDpiForMonitor';//[[result:^^E_FAIL^^;]];

function win2____GetDpiForMonitor(monitor:hmonitor;dpiType:longint;var dpiX,dpiY:uint):lresult;
var
   a:pointer;
begin
if win__useint(result,vwin2____GetDpiForMonitor,a) then result:=twin2____GetDpiForMonitor(a)(monitor, dpiType, dpiX, dpiY);
win__dec;
end;


//function win2____SetLayeredWindowAttributes(winHandle:hwnd;color:dword;bAplha:byte;dwFlags:dword):lresult; stdcall; external user32 name 'SetLayeredWindowAttributes';;

function win2____SetLayeredWindowAttributes(winHandle:hwnd;color:dword;bAplha:byte;dwFlags:dword):lresult;
var
   a:pointer;
begin
if win__useint(result,vwin2____SetLayeredWindowAttributes,a) then result:=twin2____SetLayeredWindowAttributes(a)(winHandle, color, bAplha, dwFlags);
win__dec;
end;


//function win2____XInputGetState(dwUserIndex03:dword;xinputstate:pxinputstate):tbasic_lresult; stdcall; external xinput1_4 name 'XInputGetState';//[[result:^^E_FAIL^^;]];

function win2____XInputGetState(dwUserIndex03:dword;xinputstate:pxinputstate):tbasic_lresult;
var
   a:pointer;
begin
if win__useint(result,vwin2____XInputGetState,a) then result:=twin2____XInputGetState(a)(dwUserIndex03, xinputstate);
win__dec;
end;


//function win2____XInputSetState(dwUserIndex03:dword;xinputvibration:pxinputvibration):tbasic_lresult; stdcall; external xinput1_4 name 'XInputSetState';//[[result:^^E_FAIL^^;]];

function win2____XInputSetState(dwUserIndex03:dword;xinputvibration:pxinputvibration):tbasic_lresult;
var
   a:pointer;
begin
if win__useint(result,vwin2____XInputSetState,a) then result:=twin2____XInputSetState(a)(dwUserIndex03, xinputvibration);
win__dec;
end;


//function win2____GetFileVersionInfoSize(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD): DWORD; stdcall; external version name 'GetFileVersionInfoSizeA';;

function win2____GetFileVersionInfoSize(lptstrFilename: PAnsiChar; var lpdwHandle: DWORD):dword;
var
   a:pointer;
begin
if win__useint(result,vwin2____GetFileVersionInfoSize,a) then result:=twin2____GetFileVersionInfoSize(a)(lptstrFilename, lpdwHandle);
win__dec;
end;


//function win2____GetFileVersionInfo(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL; stdcall; external version name 'GetFileVersionInfoA';;

function win2____GetFileVersionInfo(lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD; lpData: Pointer):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin2____GetFileVersionInfo,a) then result:=twin2____GetFileVersionInfo(a)(lptstrFilename, dwHandle, dwLen, lpData);
win__dec;
end;


//function win2____VerQueryValue(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL; stdcall; external version name 'VerQueryValueA';;

function win2____VerQueryValue(pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: UINT):bool;
var
   a:pointer;
begin
if win__usebol(result,vwin2____VerQueryValue,a) then result:=twin2____VerQueryValue(a)(pBlock, lpSubBlock, lplpBuffer, puLen);
win__dec;
end;


end.
