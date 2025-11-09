unit gosssnd;

interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gosswin2, gossroot, gosswin;
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
//## Library.................. sound/audio/midi/chimes (gosssnd.pas)
//## Version.................. 4.00.9256 (+119)
//## Items.................... 10
//## Last Updated ............ 06nov2025, 02nov2025, 24oct2025, 16sep2025, 09sep2025, 07sep2025, 21aug2025, 11aug2025, 29apr2025, 15mar2025, 18feb2025, 18dec2024, 22nov2024, 20jul2024
//## Lines of Code............ 9,800+
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
//## | tbasicmidi             | tobjectex         | 1.00.5974 | 06nov2025   | Midi Engine for realtime reliable midi playback (supports midi formats 0/1 in tick mode only) for file formats .mid, .midi and .rmi - 24oct2025, 16sep2025, 14sep2025, 09sep2025, 21aug2025, 20aug2025, 18feb2025, 22nov2024, 16mar2022, 23feb2022, 30sep2021, 21may2021, 21may2021: thread safe version -> all attempts to use high level thread safe locking and syncing failed over the Windows 95 to Windows 10 range -> tried Windows message queues also failed, instead built a managed thread system for FAST rock-solid inter-thread communication via "systhread__*" family of procs, 19feb2022, 10may2021, 20apr2021: thread error hunt begins, 15apr2021, 04apr2021, 30mar2021, 22feb2021
//## | tbasicchimes           | tobjectex         | 1.00.2011 | 29apr2025   | Centralised system chiming + audio alerts support via midi - 15nov2022
//## | tsnd32                 | tobjectex         | 1.00.220  | 30sep2021   | 32bit slot based audio stream storage and manipulation handler - 14jul2021
//## | taudiobasic            | tobjectex         | 1.00.300  | 19feb2022   | Audio playback and recording - 20jul2024: updated, 14apr2017: updated, 25JUN2009: created and operational
//## | tmm                    | tobjectex         | 1.00.600  | 20jul2024   | Managed multimedia playback for audio files - 20jul2024: tweaked for gossamer, 25mar2016: updated, 23may2013: created
//## | mid_*                  | family of procs   | 1.00.152  | 23oct2025   | Indirect control of midi subsystem - 16sep2025, 14sep2025, 09sep2025, 21aug2025, 22nov2024
//## | chm_*                  | family of procs   | 1.00.030  | 22nov2024   | Indirect control of chiming subsystem
//## | mm_*                   | family of procs   | 1.00.030  | 22nov2024   | Indirect control of Microsoft Windows MCI subsystem
//## | snd_*                  | family of procs   | 1.00.010  | 22nov2024   | Support procs for tsnd32
//## | playlist_*             | family of procs   | 1.00.030  | 22nov2024   | Playlist support
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================

const
   //basicmidi proc2 codes
   bmaNone             =0;
   bmaReopen           =1;
   bmaClose            =2;
   bmaOpen             =3;
   bmaAutoopen         =4;
   bmaResetvols        =5;
   bmaPdo              =6;
   bmaTest             =7;
   bmaMax              =7;

   //midi device list indexs
   mmsys_mid_broadcast     =-2;
   mmsys_mid_midimapper    =-1;
   mmsys_mid_devicestart   =0;
   mmsys_mid_devicefinish  =9;

type
   tmmodes=(mmNotReady,mmStopped,mmPlaying,mmRecording,mmSeeking,mmPaused,mmOpen);

{tbasicmidi}
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//mmmmmmmmmmmmmmmmmmmmmmmmmmmm
   tmidiitem=record
      handle       :longint;
      ms           :longint;//delay offset -> -100..100 ms
      vol          :longint;//0=mute, 1..200=on
      ch           :array[0..15] of boolean;
      end;

   tmidilist=array[0..mmsys_mid_devicefinish] of tmidiitem;//9..9=devices 0..9 -> no midi mapper -> opening some midi devices twice causes a fatal error

   tbasicmidi=class(tobjectex)
   private
    imidlistref:string;
    itimerreset24hr,iretrytimer,itimer1000,itimer100,iopenref:comp;
    ihalt,imidtrimmed,ithreadignore,itimereventbusy,imustplaydata,imustplayfile,ikeepopen,iloop,imuststop,imustplay,iplaying:boolean;
    iitemsid,imustopen:longint;//0=ready, 1=busy, 2=timer must load
    idatarate,inewvol,inewvol2,iresetvol,ivol,ivol2,ichangedidB,ilastid,iid,ibytes,imidbytes,ilastspeed2,ilastspeed,itranspose,ispeed,ispeed2,imidformat,imidtracks,imidmsgs:longint;
    itimer:tbasictimer2;
    ihandlelist  :tmidilist;
    //midi track data handlers -> these point a track(0..255) to a list of "time.4 + dpos.4" items within "imidref" where "dpos.4" points to the actual midi msg to be processed and "time.4" refers to the TOTAL TIME in MS to have transpired until THIS midi msg IS to be processed (not time is a 32bit time, limit of 21 days) - 15feb2021
    ilistdata    :array[0..255] of tstr8;
    ilistpos     :array[0..high(tmidilist)] of array[0..255] of longint;//current item (midi msg) we are up to in track (0..midcount-1)
    ilistcount   :array[0..255] of longint;//total number of items (midi msgs) in track
    ilistlimit   :longint;//number of lists in use
    ilyrics      :tstr8;//one long stream of text - 24feb2022
    ilyricsref   :tstr8;//list of <ms4><pos4> pairs for finding and displaying then current lyrics position
    //actual midi values (pos=current playback position in ms, len=total ms of song)
    inewdeviceindex,ilastdeviceindex,ideviceindex,inewstyle,istyle,inewpos,inewtranspose,inewspeed,inewspeed2,ipos,ilen,ilenfull:longint;
    inewpertpos:double;//06mar2022
    ipos64:comp;//used to increment internal "pos" without required a synced timer var
    idisablenotes:boolean;//true=shutdown critical functions for a safe destruction of control
    //external support
    ifilename:string;
    idata,idata2:tstr8;
    procedure flush;
    procedure xplaydata;
    procedure xplaydata2(xtrimtolastnote:boolean);//11jan2025
    procedure __ontimer(sender:tobject);
    procedure setstyle(x:longint);
    procedure setdeviceindex(x:longint);
    procedure setvol(x:longint);
    procedure setvol2(x:longint);
    procedure setnewpos(x:longint);
    procedure setnewpertpos(x:double);
    function getpos:longint;
    function getpertpos:double;
    function gettranspose:longint;
    function gethandle:longint;
    procedure setitem(xindex:longint;const xitem:tmidiitem);
    function getitem(xindex:longint):tmidiitem;
    function getitemsettings(xindex:longint):string;
    procedure setitemsettings(xindex:longint;xdata:string);
    function xmustreset24hr(xreset:boolean):boolean;//reset the midi hardware (e.g. disconnect and reconnect) every 24 hours to maintain stability and prevent memory runaway via "winmm.dll" on some OS/hardware combinations, namely Win98/Vista/7 and 8/8.1, stable on XP/10/11 - 23oct2025
    function xdevicelistHasChanged(xreset:boolean):boolean;

    //thread timer procs
    procedure __createOutsideThread(x:tobject);
    procedure __destroyOutsideThread(x:tobject);
    procedure __timerThread(x:tobject);
    function __procThread2(x:tobject;const xcode:longint;var xreplycode:longint;const xWithinThread:boolean):boolean;
    procedure xcallproc2(const xcode:longint);//13sep2025

    //thread based
    procedure __autoopen;
    procedure __open;
    procedure __openhandles;//thread enabled via COM start procs - 14sep2025, 31aug2025, 20aug2025
    procedure __closehandles;//07sep2025, 24may2021
    procedure __resetvols;
    procedure __pdo;//16sep2025

   public

    //options
    oautostop:boolean;//default=false=remains playing
    otrimtolastnote:boolean;//default=false, true=trim playable midi to last audible note

    //create
    constructor create;
    destructor destroy; override;//02sep2025, 02mar2022
    procedure xpatch__windows98;//13sep2025, 04sep2025

    //halt -> use to shut internal operations with Win32 procs for a clean and proper shutdown manner - 10aug2025
    function halted                :boolean;//10aug2025
    function halt                  :boolean;

    //information
    function timercode             :longint;
    function timermsg              :string;
    function usingtimer            :boolean;
    function seeking               :boolean;//true=midi is in process of updating "pos" to new value, false=read to set new pos - 30mar2021
    procedure moretime;
    function get(xindex,xmsgindex:longint;var xtimems:longint;var xmsg,xval1,xval2,xval3:byte):boolean;
    property loop                  :boolean read iloop write iloop;
    property keepopen              :boolean read ikeepopen write ikeepopen;
    function canplaymidi           :boolean;
    function canopen               :boolean;
    function canclose              :boolean;
    procedure setpos(x:longint);
    procedure syncpos;
    procedure restart;
    function canstop               :boolean;
    procedure stop;
    function canplay               :boolean;
    procedure play;
    property playing               :boolean read iplaying;
    property bytes                 :longint read ibytes;
    property midbytes              :longint read imidbytes;
    property msgs                  :longint read imidmsgs;
    function msgssent              :longint;
    property handle                :longint read gethandle;
    function handlecount           :longint;//07sep2025

    property itemsid                      :longint   read iitemsid;//increments each time an item changes
    property items[xindex:longint]        :tmidiitem read getitem         write setitem;
    property itemsettings[xindex:longint] :string    read getitemsettings write setitemsettings;
    function itemcount                    :longint;
    procedure resetItems;
    procedure resetItem(xindex:longint);

    property trimmed               :boolean read imidtrimmed;//true=midi was trimmed to last note, false=untrimmed - 11jan2025
    property format                :longint read imidformat;
    property tracks                :longint read imidtracks;
    property pos                   :longint read getpos write setnewpos;//26sep2021
    property pertpos               :double read getpertpos write setnewpertpos;//06mar2022
    property len                   :longint read ilen;
    property lenfull               :longint read ilenfull;//untrimmed length - 11jan2025
    property transpose             :longint read gettranspose write inewtranspose;//11aug2025
    property speed                 :longint read ispeed write inewspeed;
    property speed2                :longint read ispeed2 write inewspeed2;//02mar2022
    property style                 :longint read istyle write setstyle;
    property deviceindex           :longint read ideviceindex write setdeviceindex;
    function playdata(x:tstr8):boolean;
    function playfile(x:string):boolean;
    property vol                   :longint read ivol write setvol;
    property vol2                  :longint read ivol2 write setvol2;
    function msrate                :double;
    function mspert100             :double;
    function pcount                :longint;
    property datarate              :longint read idatarate;//bytes per second - 11aug2025

    //thread sync support - 13sep2025
    procedure enter1;
    procedure leave1;

    //lyrics support
    function lcount                :longint;
    function lfind(xpos:longint;xshowsep:boolean):string;//find lyrics - 24feb2022

    //support
    function check24hr:boolean;//internal use only

   end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//ccccccccccccccccccc
{tbasicchimes}
   tbasicchimes=class(tobjectex)//15nov2022, 02mar2022
   private
    ipausenote64:comp;
    iworklist:string;
    ivol,ibuzzer2,ibuzzer,imustplay,iworkindex,iworkmins,iworkpos,iworkcount:longint;
    iwork0,iwork15,iwork30,iwork45,iworktest,ibuzzerpaused,imuststop,iplaying:boolean;
    //.chime + buzzer support - 01mar2022
    iname  :array[0..199] of string;
    istyle :array[0..199] of longint;//0=title, 1=standard, 2=ships bells, 3=grande sonnerie
    itep   :array[0..199] of longint;
    iintro :array[0..199] of tstr8;//intro melody - optional
    idong  :array[0..199] of tstr8;//standard SINGLE DONG - required
    idong2 :array[0..199] of tstr8;//ships bell DOUBLE DONG - optional
    itemp  :array[0..199] of tstr8;//used to store and entire chiming sequence such as for Sonnerie - 16mar2022
    igap   :array[0..199] of longint;//gap in ms between dong and dong2 - optional
    iintroX:array[0..199] of string;//intro melody - optional
    idongX :array[0..199] of string;//standard SINGLE DONG - required
    idong2X:array[0..199] of string;//ships bell DOUBLE DONG - optional
    icount :longint;
    inumberfrom1,inumberfrom2,inumberfrom3:longint;//09nov2022
    ibuzzers      :array[1..99] of tstr8;//14nov2022
    ibuzzerlabels :array[1..99] of string;//14nov2022
    ibuzzercount:longint;
    procedure _ontimer(sender:tobject);
    function getchiming:boolean;
    procedure setbuzzer(x:longint);
    procedure setvol(x:longint);
   public
    //create
    constructor create;
    destructor destroy; override;//02mar2022
    procedure xinitChimes;
    procedure xaddTitle(xname:string);
    procedure xaddStandard(xname:string;const xintro,xdong:array of byte);
    procedure xaddStandard2(xname,xintro,xdong:string);//14nov2022
    procedure xaddStandard3(xname,xintro,xdong:string;const aintro,adong:array of byte);//15nov2022
    procedure xaddBells(xname:string;const xdong,xdong2:array of byte);
    procedure xaddBells2(xgap:longint;xname,xdong,xdong2:string);
    procedure xaddSonnerie(xgap:longint;xname:string;const xdong,xdong2:array of byte);
    procedure xaddSonnerie2(xgap:longint;xname,xdong,xdong2:string);
    procedure xadd(xgap:longint;xname:string;const xintro,xdong,xdong2:array of byte;xstyle,xtep:longint);
    procedure xadd2(xgap:longint;xname:string;const xintro,xdong,xdong2:array of byte;sintro,sdong,sdong2:string;xstyle,xtep:longint);
    //information
    property count:longint read icount;
    property numberfrom1:longint read inumberfrom1;//standard - 09nov2022
    property numberfrom2:longint read inumberfrom2;//ships bells
    property numberfrom3:longint read inumberfrom3;//grande sonnerie
    property chiming:boolean read getchiming;
    function chimingpert:double;//actual chime progress 0-100%
    property vol:longint read ivol write setvol;//used for chiming, buzzer remains at 100%
    //workers
    function info(xindex:longint;var xname:string;var xstyle,xtep:longint;var xintro,xdong,xdong2:tstr8):boolean;
    //.find
    function findname(xname:string;var xindex:longint):boolean;
    function findworklist(xindex,xmins:longint;x0,x15,x30,x45,xtest:boolean;var xworklist:string):boolean;
    //.stop
    function canstop:boolean;
    procedure stop;
    //.play
    function mustplayname(xname:string;xmins:longint):boolean;
    function mustplayindex(xindex,xmins:longint):boolean;
    function canplay:boolean;
    procedure playname(xname:string;xmins:longint;x0,x15,x30,x45,xtest:boolean);
    procedure playname2(xname:string);
    procedure playname3(xname:string;xmins:longint;n0,n15,n30,n45,b0,s0,s15,s30,s45,xtest:boolean);
    procedure playindex(xindex,xmins:longint;x0,x15,x30,x45,xtest:boolean);
    procedure playindex2(xindex:longint);
    property testing:boolean read iworktest;//sounding a test chime
    //.buzzer
    property buzzer:longint read ibuzzer write setbuzzer;
    property buzzercount:longint read ibuzzercount;
    function findbuzzerlabel(x:longint):string;
    function addbuzzer(xlabel,xdata:string;const xmiddata:array of byte):boolean;
    procedure setbuzzerdata(x:longint;xlabel,xdata:string;const xmiddata:array of byte);
   end;

//tsnd32 - 32bit binary list for storage and manipulation of audio samples -> each sample is stored in a single 32bit slot - 14jul2021
//xxxxxxxxxxxxxxxxxxxxxxxxxxxx//333333333333333333333333
   tsnd32=class(tobjectex)
   private
    icore,ivmax:tstr8;
    ilastvmaxid,iid,ibits,ihz,ikhz,iincby,ilen:longint;
    procedure setkhz(x:longint);
    procedure sethz(x:longint);
    procedure setincby(x:longint);
    function getbytes:longint;
    procedure setlen(x:longint);
    function getv(xpos:longint):longint;
    procedure setv(xpos,xval:longint);
    function getpv(xpos:longint):longint;
    procedure setpv(xpos,xval:longint);
    function getnv(xpos:longint):longint;
    procedure setnv(xpos,xval:longint);
    function getms:longint;
    procedure setms(x:longint);
    function xadd(x:tstr8;dhz,xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
    function xpull(x:tstr8;dhz,xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
    procedure setbits(x:longint);
    function getlen100:longint;
    procedure setlen100(x:longint);
    function getvmax(x:longint):longint;
   public
    //create
    constructor create;
    destructor destroy; override;
    procedure xincid;

    //core support
    property id:longint read iid;
    property incby:longint read iincby write setincby;
    property hz:longint read ihz write ihz;
    property khz:longint read ikhz write setkhz;
    property bits:longint read ibits;
    procedure setparams(xkhz,xbits,xlen:longint);
    function minlen(x:longint):boolean;
    property len:longint read ilen write setlen;//number of slots used by audio stream
    property len100:longint read getlen100 write setlen100;//based on VideoMagic's 100fps (so hz=44100 => 1 second = 100 slots => 100 = 44100 and 1 slot = 44.1 samples)
    property bytes:longint read getbytes;//memory used by slots of audio stream

    //slot access -> one slot per audio sample (16bit audio uses one slot) - 14jul2021
    property val[xpos:longint]:longint read getv write setv;
    property v[xpos:longint]:longint read getv write setv;
    property pv[xpos:longint]:longint read getpv write setpv;//values as positive numbers
    property nv[xpos:longint]:longint read getnv write setnv;//values as negative numbers
    property vmax[xpos:longint]:longint read getvmax;//used for graphing purposes only - 21jul2021

    //add -> add an audio stream from one format to the core's format specified by "hz" or "khz" and "bits"(bits not supported as yet, defaults to 16bit)
    function add(x:tsnd32;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
    function add22(x:tstr8;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
    function add44(x:tstr8;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
    function add48(x:tstr8;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
    function add96(x:tstr8;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;

    //pull -> pull core audio stream to external stream in output format
    function pull96(x:tstr8;xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
    function pull48(x:tstr8;xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
    function pull44(x:tstr8;xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
    function pull22(x:tstr8;xfrom,xlen:longint;xasms:boolean;var e:string):boolean;

    //time
    property ms:longint read getms write setms;

    //workers
    procedure clear;
    //.ave volume support -> use to correct volume
    function volave:longint;
    function volave2(xfrom,xlen:longint):longint;
    procedure setvolave(soriginalvolave:longint);
    procedure setvolave2(xfrom,xlen,soriginalvolave:longint);
    //range
    function findrange(var xmin,xmax:longint):boolean;
    function findrange2(var lmin,lmax,hmin,hmax:longint):boolean;
    function findmin:longint;
    function findmax:longint;
    //detect
    function iszero(xfrom,xto:longint):boolean;
    function inrange(xfrom,xto,xmin,xmax:longint):boolean;
    //makers
    procedure make96_16;
    procedure make48_16;
    procedure make44_16;
    procedure make22_16;
   end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
{taudiobasic}
    paudiobasicbuffer=^taudiobasicbuffer;
    taudiobasicbuffer=array[0..47999] of byte;//higher upper limit buffer for 48Khz recording - 03JAN2010
    taudiobasic=class(tobjectex)//Note: Playback and Recording systems now fully operational as at 25JUN2009
    private
     //commmon
     ihandle:hwnd;
     //push - play
     isamplems,isamplesize,isecsize,ipvolume,ipmaxV:integer;
     ipopen,iformatmodified:boolean;
     iformat:twaveformatex;
     iformatstr:string;
     iptime:currency;
     iphandle:HWAVEOUT;
     ipH:array [0..1] of twavehdr;
     ipB:array [0..1] of taudiobasicbuffer;
     ippos:byte;
     ipchcount,ipcount:integer;
     ipdata:tstr8;
     ip16bit,ipplaying:boolean;
     //pull - record
     irsamplems,irsamplesize,irsecsize,irvolume,irmaxV:integer;
     irformatmodified:boolean;
     irformat:twaveformatex;
     irformatstr:string;
     irtime:currency;
     irhandle:HWAVEIN;
     irH:array [0..1] of twavehdr;
     irB:array [0..1] of taudiobasicbuffer;
     irpos:byte;
     irchcount,ircount:integer;
     irdata:tstr8;
     ir16bit,irrecording:boolean;
     //core
     ilocked:boolean;
     itimer:integer;
     procedure _ontimer(sender:tobject);
     procedure pdo;
     procedure paoc;//automatic open/close
     procedure raoc;//automatic open/close
     function handle:hwnd;
     procedure onmessage(m,w,l:longint);
     procedure setformat(x:string);
     procedure setrformat(x:string);
     procedure setvolume(x:integer);
     procedure setrvolume(x:integer);
     procedure setsamplems(x:integer);
     procedure setrsamplems(x:integer);
    public
     //options
     oplay_timeout:longint;//milliseconds to wait before timing out play buffer, default=10000 (10sec), use longer such for "tts" of "60000 (1 minute)" - 14apr2017
     orec_timeout:longint;//as above
     //create
     constructor create;
     destructor destroy; override;
     function onems(xformat:string):longint;//number of bytes for "1 millsecond" of sound - 21JUL2009
     //workers - common
     function wkMaxV(_16bit:boolean;z:tstr8):integer;
     procedure wkFast(_16bit:boolean;z:tstr8);
     procedure wkAdjustVolume(_16bit:boolean;z:tstr8;_vol:integer);//adjust volume
     //-- PLAY -----------------------------------------------------------------
     //information
     property samplems:integer read isamplems write setsamplems;
     property samplesize:integer read isamplesize;
     property secsize:integer read isecsize;
     property format:string read iformatstr write setformat;
     property playing:boolean read ipplaying;//23JUN2009
     property pmaxV:integer read ipmaxV;
     property volume:integer read ipvolume write setvolume;//adjust playback volume in realtime
     property p16bit:boolean read ip16bit;
     property pchcount:integer read ipchcount;
     property pcount:integer read ipcount;//number of buffers in use (0=none, 1=one, 2=both)
     //push
     function pushonline:boolean;
     function pushlen:integer;//amount of data length in push buffer for playback
     function canpush:boolean;
     function canpushex(seconds:integer):boolean;
     function canpushexMS(ms:integer):boolean;//23JUN2009
     function push(data:tstr8):boolean;//14apr2017
     procedure pflush;
     function pempty:boolean;//assume "ipdata" is never entirely empty as audio rounds to nearest block
     //-- RECORD ---------------------------------------------------------------
     //information
     property rsamplems:integer read irsamplems write setrsamplems;
     property rsamplesize:integer read irsamplesize;
     property rsecsize:integer read irsecsize;
     property rformat:string read irformatstr write setrformat;
     property recording:boolean read irrecording write irrecording;
     property rmaxV:integer read irmaxV write irmaxV;
     property rvolume:integer read irvolume write setrvolume;//adjust playback volume in realtime
     property r16bit:boolean read ir16bit;
     property rchcount:integer read irchcount;
     //pull
     function pullonline:boolean;//hardware is running
     function canpull:boolean;
     function pull(data:tstr8):boolean;
     procedure rflush;
     function rempty:boolean;//assume "irdata" is never entirely empty as audio rounds to nearest block
    end;

{tmm}
    tmm=class(tobjectex)
    private
     istate:byte;
     ideviceid:word;
     ihandle:hwnd;
     iformat,ifilename:string;
     iplayBUSY,itrackformat,istoplock,ivalid:boolean;//special note: ibk=true=>using backup audio system (ours) - 19MAY2013
     itracknumber,itrackstart:integer;
     inewposition,ilength:longint;
     inewpertpos:double;//06mar2022
     procedure _ontimer(sender:tobject);
     function getplaying:boolean;
     procedure _stop;
     function _open(var e:string):boolean;
     function _play(var e:string):boolean;
     function gethandle:hwnd;
     procedure onmessage(m,w,l:longint);
     function getmode:tmmodes;
     function getposition:longint;
     procedure setposition(x:longint);//Working - 29JUN2010
     function getpertpos:double;
     procedure setnewpertpos(x:double);//06mar2022
    public
     //options
     oAutostop:boolean;//default=false
     oLoop:boolean;//default=false - 01MAY2011
     //events
     onstop:tevent;
     //create
     constructor create; 
     destructor destroy; override;
     //workers
     //.play
     property playBUSY:boolean read iplayBUSY;//true=play() is working and is not yet finished, so POS and LEN could be undefined or incorrect - 23MAY2013
     function canplay:boolean;
     function play(x:string;var e:string):boolean;//reinforced, 12AUG2010
     property playing:boolean read getplaying;
     //.stop
     function canstop:boolean;
     procedure stop;
     //.information
     function positionBUSY:boolean;//we are waiting for "inewposition" to be implemented - 23MAY2013
     property position:integer read getposition write setposition;
     property pertpos:double read getpertpos write setnewpertpos;
     property len:longint read ilength;//set by "play" and "stop"
     property mode:tmmodes read getmode;
     property filename:string read ifilename;
     property state:byte read istate;
     //.handle
     property handle:hwnd read gethandle;
    end;

type

   tmidinote=record
      timeRAW        :comp;
      timeOUT        :comp;
      timeOUTUNMUTED :comp;
      volRAW         :byte;//raw midi note volume with no modification - 16sep2025
      volOUT         :byte;//actual volume transmitted to midi device - 16sep2025
      volOUTUNMUTED  :byte;//actual volume to be transmitted to midi device minus any muting - 18sep2025
      muted          :boolean;
      mutedByTrack   :boolean;
      mutedByChannel :boolean;
      mutedByNote    :boolean;
      end;

   tmidinotes=record
      notes:array[0..127] of tmidinote;
      end;

   tmiditrack=record
      time:comp;
      end;

   tmiditracking=record

      //realtime midi data
      tracks     :array[0..1023] of tmiditrack;
      channels   :array[0..15]   of tmidinotes;//by channel

      //value increment each time data changes
      trackid    :array[0..1023] of longint;
      channelid  :array[0..15]   of longint;
      noteid     :array[0..127]  of longint;
      id         :longint;

      end;


var
   //.started
   system_started               :boolean=false;

   //system support - 29mar2021
   mmsys_midi:tbasicmidi=nil;
   mmsys_chimes:tbasicchimes=nil;//02mar2022
   mmsys_wave:taudiobasic=nil;
   mmsys_mm:tmm=nil;
   mmsys_mode:longint=0;//0=not in use, 1=initing, 2=inited, 3=shuting, 4=shut

   //support refs
   //.mid
   mmsys_mid_devicetime         :comp=0;//not init'ed yet - 18apr2021
   mmsys_mid_devicecount        :longint=0;
   mmsys_mid_deviceok           :array[mmsys_mid_broadcast..mmsys_mid_devicefinish] of boolean;//0=broadcast all devices, 1=midi-mapper, 2..N=device #0..(n-2) - 18apr2021
   mmsys_mid_devicename         :array[mmsys_mid_broadcast..mmsys_mid_devicefinish] of string;//12may2021
   mmsys_mid_basevol            :longint=50;//0=off, 100=100% (default) upto 200% - 23mar2022
   mmsys_mid_AllowAllDevices    :boolean=false;//13sep2025
   mmsys_mid_devicechangeLock   :longint=0;//02nov2025

   //.realtime midi tracking
   mmsys_mid_tracking    :tmiditracking;//03sep2025

   //.midi channel status and selective muting - 09jan2025
   mmsys_mid_dataref     :longint;//increments each time a midi is loaded for playing
   mmsys_mid_ref         :longint;//increments each time a note is switched on or off
   mmsys_mid_notesref    :longint;//increments each time a noteon or noteoff command is processed
   mmsys_mid_voiceindex  :array[0..15] of longint;//-1..127 => -1=Not Set, 0..127=Voice
   mmsys_mid_chvol       :array[0..15] of longint;//default=100, range=-200..200 where "volume<=0" is considered muted
   mmsys_mid_mutenote    :array[0..255] of boolean;//default=false
   mmsys_mid_mutetrack   :array[0..high(mmsys_mid_tracking.tracks)] of boolean;//default=false
   mmsys_mid_enhanced    :boolean=false;
   mmsys_mid_msgoutcount :longint;//11aug2025

   //.wav
   mmsys_wav_devicetime:comp=0;//not init'ed yet - 18apr2021
   mmsys_wav_devicecount:longint=0;
   mmsys_wav_deviceok  :array[0..10] of boolean;//0=wave-mapper, 1..N=device #0..(n-1) - 18apr2021
   mmsys_wav_devicename:array[0..10] of string;//12may2021

   //.mm
   mmsys_mm_lastfilename:string='';
   mmsys_mm_lastsize:comp=0;//21jun2024
   mmsys_mm_lastpos:longint=0;
   mmsys_mm_lastlen:longint=0;


//start-stop procs -------------------------------------------------------------
procedure gosssnd__start;
procedure gosssnd__stop;
function gosssnd__onmessage_mm(m,w,l:longint):longint;//multimedia message handler
function gosssnd__onmessage_wave(m,w,l:longint):longint;//wave message handler

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__snd(xname:string):string;//information specific to this unit of code


//sound procs ------------------------------------------------------------------
//.core
function mm_safetohalt:boolean;
procedure mm_init;
procedure mm_shut;
function mm_ok:boolean;
function mm_inited:boolean;

//.use with "tbasicnav" and optional "tbasicjump" for a complete play management setup - 22feb2022
function mm_playmanagement_init(var xmuststop,xmustplay,xplaying:boolean;var xmustpertpos:double;var xmustpos,xlastpos:longint;var xlastfilename:string):boolean;
function mm_playmanagement(xstyle:string;xmode,xintroms:longint;var xmuststop,xmustplay,xplaying,xhostupdate:boolean;var xmustpertpos:double;var xmustpos,xlastpos:longint;var xlastfilename:string;xxnav:tobject;xxplaylist:tobject;xplaylistmask:string;xxjump:tobject):boolean;

//.wave support
function wav_ok:boolean;
function wav_inuse:boolean;//01sep2025
function wav_vol:longint;
function wav_setvol(x:longint):boolean;
procedure wav_devicelist;
function wav_deviceindex:longint;
function wav_setdeviceindex(x:longint):boolean;
function wav_devicelimit:longint;
function wav_devicecount:longint;//exclude wave mapper
function wav_deviceok(xindex:longint):boolean;
function wav_devicename(xindex:longint;xdefval:string):string;
function wav_flush44:boolean;
function wav_push44(x:tstr8):boolean;
function wav_len44:longint;

//.midi support
function mid_ok:boolean;
function mid_inuse:boolean;//01sep2025
function mid_timercode:longint;
function mid_timermsg:string;

//.tracking support
function mid_trackinginfo(const xchannel,xnote:byte;var xinfo:tmidinote):boolean;//16sep2025
function mid_trackingTrackid(const xtrack:longint):longint;
function mid_trackingChannelid(const xchannel:longint):longint;
function mid_trackingNoteid(const xnote:longint):longint;
function mid_trackingid:longint;
procedure mid_cleartracking;//21aug2024

function mid_voicename(xindex:longint):string;//20aug2025
function mid_voiceisBass(const xnote:longint):boolean;//02sep2025
function mid_voiceisDrum(const xnote:longint):boolean;//02sep2025
function mid_outdevicecount:longint;//0=no midi output devices - 04sep2025, 10aug2025

procedure mid_devicelist_lockfromchanging(const xlock:boolean);//02nov2025
function mid_devicelist_locked:boolean;
procedure mid_devicelist;//26sep2026, 09sep2025, 04sep2025
function mid_devicelistHasChanged(var sref:string;const xreset:boolean):boolean;//02nov2025

procedure mid_enhance(x:boolean);
function mid_enhanced:boolean;
function mid_canstop:boolean;
procedure mid_stop;
function mid_canplay:boolean;
procedure mid_play;
function mid_canplaymidi:boolean;
function mid_playmidi(xmiddata:tstr8):boolean;
function mid_playfile(xfilename:string):boolean;
function mid_speed:longint;
function mid_speed2:longint;
function mid_setspeed(x:longint):boolean;
function mid_setspeed2(x:longint):boolean;
function mid_style:longint;
function mid_setstyle(x:longint):boolean;
function mid_trimtolastnote:boolean;//11jan2025
function mid_settrimtolastnote(x:boolean):boolean;//11jan2025
function mid_trimmed:boolean;//11jan2025 - true: midi was trimmed to last note, false=midi is untrimmed
procedure mid_enter1;//13sep2025
procedure mid_leave1;
function mid_deviceindex:longint;
function mid_setdeviceindex(const x:longint):boolean;
function mid_SafeDeviceIndexRange(const x:longint):longint;
function mid_setAllowAllDevices(const x:boolean):boolean;
function mid_AllowAllDevices:boolean;
function mid_devicelimit:longint;//exclude midi mapper
function mid_devicecount:longint;//exclude midi mapper
function mid_deviceok(xindex:longint):boolean;
function mid_devicename(xindex:longint;xdefval:string):string;
function mid_seeking:boolean;
function mid_transpose:longint;//14feb2025
function mid_settranspose(x:longint):boolean;//14feb2025
function mid_vol:longint;//system volume
function mid_vol1:longint;//modifies volume of notes
function mid_vol2:longint;//modifies volume of notes
function mid_setvol(x:longint):boolean;//04sep2024
function mid_setvol1(x:longint):boolean;//modifies volume of notes
function mid_setvol2(x:longint):boolean;//modifies volume of notes
function mid_canpertpos:boolean;//true=system supports percentage positioning, else not - 06mar2022
function mid_pos:longint;
function mid_pertpos:double;
function mid_setpos(x:longint):boolean;
function mid_setpertpos(x:double):boolean;
function mid_check24hr:boolean;
function mid_len:longint;
function mid_lenfull:longint;//11jan2025 - untrimmed length in ms
function mid_lyriccount:longint;//24feb2022
function mid_lyric(xpos:longint;xshowsep:boolean):string;
function mid_format:longint;
function mid_tracks:longint;
function mid_msgs:longint;//14sep2025 - total number of messages in midi
function mid_msgssent:longint;//number of message sent to midi hardware
function mid_msgrate:longint;//messages per second
function mid_datarate:longint;//bytes per second
function mid_msrate:double;//timer resolution
function mid_mspert100:double;//timer resolution expressed as a percentage (0..100)
function mid_pcount:double;//timer events per second
function mid_bytes:longint;//size of midi in bytes
function mid_midbytes:longint;//size of midi in bytes
function mid_phandle:longint;//handle of midi device
function mid_handlecount:longint;//number of active midi devices
function mid_itemsid:longint;//09sep2025
function mid_itemcount:longint;//07sep2025
function mid_finditemByFilename(const xfilename:string;var xindex:longint):boolean;
function mid_itemfilename(xindex:longint;xcreatefolder,xusename:boolean):string;//26sep2025
function mid_loaditem(xindex:longint):boolean;//26sep2025
function mid_saveitem(xindex:longint):boolean;//26sep2025
function mid_item(xindex:longint):tmidiitem;
function mid_setitem(xindex:longint;const xitem:tmidiitem):boolean;
function mid_itemsettings(xindex:longint):string;
function mid_setitemsettings(xindex:longint;const xdata:string):boolean;
function mid_resetitem(xindex:longint):boolean;
function mid_resetitems:boolean;
function mid_deviceactive:boolean;//have access to midi device - 15apr2021
function mid_usingtimer:boolean;
function mid_playing:boolean;
function mid_keepopen:boolean;
function mid_setkeepopen(x:boolean):boolean;
function mid_loop:boolean;
function mid_setloop(x:boolean):boolean;
//.internal support
procedure mid__timeusec__add(var xtimeuSEC:comp;xtempo,xtimediv,xmultipler:longint);//22nov2024

//.chimes support - 09nov2022
function chm_ok:boolean;
function chm_info(xindex:longint;var xname:string;var xstyle,xtep:longint;var xintro,xdong,xdong2:tstr8):boolean;
function chm_findname(xname:string;var xindex:longint):boolean;
function chm_safename(xname,xdefname:string):string;//15nov2022
function chm_count:longint;//total count
function chm_numberfrom1:longint;//standard count - 09nov2022
function chm_numberfrom2:longint;//ships bells count - 09nov2022
function chm_numberfrom3:longint;//grande sonnerie count - 09nov2022
function chm_name(xindex:longint):string;
function chm_canintro(xindex:longint):boolean;
function chm_candong(xindex:longint):boolean;
function chm_candong2(xindex:longint):boolean;
function chm_canstop:boolean;
procedure chm_stop;
function chm_chimingpert:double;
function chm_chiming:boolean;
function chm_playing:boolean;//same as "chm_chiming" - 02mar2022
function chm_testing:boolean;
function chm_mustplayname(xname:string;xmins:longint):boolean;
function chm_mustplayindex(xindex,xmins:longint):boolean;
function chm_canplay:boolean;
procedure chm_playname(xname:string;xmins:longint;x0,x15,x30,x45,xtest:boolean);
procedure chm_playname2(xname:string);
procedure chm_playname3(xname:string;xmins:longint;n0,n15,n30,n45,b0,s0,s15,s30,s45,xtest:boolean);
procedure chm_playindex(xindex,xmins:longint;x0,x15,x30,x45,xtest:boolean);
procedure chm_playindex2(xindex:longint);
function chm_buzzercount:longint;
function chm_buzzer:longint;//0=off
procedure chm_setbuzzer(x:longint);
function chm_buzzerlabel(x:longint):string;
function chm_vol:longint;//chimes volume, not buzzer
procedure chm_setvol(x:longint);//chimes volume, not buzzer

//.mm "mci" support -> microsoft support
//function mm_ok:boolean;
function mm_canstop:boolean;
procedure mm_stop;
function mm_canplay:boolean;
function mm_play:boolean;
function mm_playfile(xfilename:string):boolean;
function mm_bytes:comp;
function mm_seeking:boolean;
function mm_canpertpos:boolean;//true=system supports percentage positioning, else not - 06mar2022
function mm_pos:longint;
function mm_setpos(x:longint):boolean;
function mm_setpertpos(x:double):boolean;//06mar2022
function mm_len:longint;
function mm_deviceactive:boolean;//have access to midi device - 15apr2021
function mm_playing:boolean;
function mm_loop:boolean;
function mm_setloop(x:boolean):boolean;
function mm_autostop:boolean;
function mm_setautostop(x:boolean):boolean;
function mm_mode:tmmodes;
function mm_state:byte;


//.system support
function mm_midi:tbasicmidi;
function mm_chimes:tbasicchimes;
function mm_wave:taudiobasic;
function mm_mm:tmm;
//.wave out
function waveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: UINT; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT;
function waveOutClose(hWaveOut: HWAVEOUT): MMRESULT;
//.wave in
function waveInOpen(lphWaveIn: PHWAVEIN; uDeviceID: UINT; lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT;
function waveInClose(hWaveIn: HWAVEIN): MMRESULT;
//.midi - out - 20JAN2011
function midiOutOpen(lphMidiOut:PHMIDIOUT; uDeviceID: UINT; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT;
function midiOutClose(hMidiOut: HMIDIOUT): MMRESULT;
function midioutflush(xhandle:HMIDIOUT):boolean;//01sep2025, 11aug2025
//.volume support
function low__getvol:longint;//0..100% - 29mar2021,07OCT2010
procedure low__setvol(x:longint);//0..100% - 29mar2021, 07OCT2010

//** Low level midi note storage procs for use with "tstr8" - 14feb2021
function low__midcount(x:tstr8):longint;
function low__midbytes(x:tstr8):longint;
function low__midtime(x:tstr8):longint;
function low__midget(x:tstr8;xindex:longint;var xtimeuSEC:comp;var xmsg,xval1,xval2,xval3:byte):boolean;
function low__midset(x:tstr8;xindex:longint;xtimeuSEC:comp;xmsg,xval1,xval2,xval3:byte):boolean;
function low__midadd(x:tstr8;xtimeuSEC:comp;xmsg,xval1,xval2,xval3:byte):boolean;
function low__makemid(x:string;var xdata:tstr8;var e:string):boolean;//make a simple, single track midi - 15nov2022, 16mar2022
function low__txttomid(x,xtext:tstr8;var e:string):boolean;

//** tsnd32 support procs and system handlers
function nsnd32:tsnd32;
procedure fsnd32(var x:tsnd32);
function snd_toformat(xhz,xbits,xchs:longint):string;
function snd_fromformat(x:string;var xhz,xbits,xchs:longint):boolean;
function snd_safechs(x:longint):longint;
function snd_safebits(x:longint):longint;
function snd_safekhz(x:longint):longint;
function snd_safehz(x:longint):longint;
function snd_tokhz(xfromHZ:longint):longint;
function snd_tohz(xfromKHZ:longint):longint;
function snd_validkhz(x:longint):boolean;
function snd_validhz(x:longint):boolean;
function snd_waveheaderlen:longint;
function snd_waveheader(format:string;datalen:longint;xoutpos:longint;xout:tstr8):boolean;

//.playlist support - 25mar2022
function playlist__onelen:longint;//was 1028 but was reduced to 516 on 25mar2022 -> 86,000 items was consuming 180Mb or RAM, now more like 90Mb
function playlist__titlestart:longint;
function playlist__namestart:longint;
function playlist__namelen:longint;
function playlist__count(x:tstr8):longint;
function playlist__getone(xplaylistfilename:string;x:tstr8;xindex:longint;var xsec:longint;var xtitle,xfilename:string):boolean;
function playlist__addone(xplaylistfilename:string;x:tstr8;xsec:longint;xtitle,xfilename,xmask:string):boolean;
function playlist__addall(xroot,xlistroot:string;x,xlistoffiles:tstr8;xmask:string):boolean;

implementation

uses gossio {$ifdef snd},gossgui{$endif};

{
midi reference:
-----------------------------------------------------------------------------------------------------
MIDI COMMAND       DATA BYTE 2            DATA BYTE 3            TYPE
-----------------------------------------------------------------------------------------------------
$80-$8F (128-143)  Key # (0-127)          Off Velocity (0-127)   Note OFF
-----------------------------------------------------------------------------------------------------
$90-$9F (144-159)  Key # (0-127)          On Velocity (0-127)    Note ON
-----------------------------------------------------------------------------------------------------
$A0-$AF            Key # (0-127)          Pressure (0-127)	  Poly Key Pressure
-----------------------------------------------------------------------------------------------------
$B0-$BF (176-191)  Control # (0-127)      Control Value (0-127)  Control Change
-----------------------------------------------------------------------------------------------------
$C0-$CF (192-207)  Program # (0-127)      Not Used               Program Change
-----------------------------------------------------------------------------------------------------
$D0-$DF            Pressure Value (0-127) Not Used               Mono Key Pressure (Channel Pressure)
-----------------------------------------------------------------------------------------------------
$E0-$EF            Range (LSB)            Range (MSB)            Pitch Bend
-----------------------------------------------------------------------------------------------------
$F0-$FF            Manufacturer's ID      Model ID               System
-----------------------------------------------------------------------------------------------------
}

//start-stop procs -------------------------------------------------------------
procedure gosssnd__start;
begin
try

//check
if system_started then exit else system_started:=true;

//audio start
mm_init;
except;end;
end;

procedure gosssnd__stop;
begin
try
//check
if not system_started then exit else system_started:=false;

//audio stop
mm_shut;
except;end;
end;

function gosssnd__onmessage_mm(m,w,l:longint):longint;//multimedia message handler
begin
result:=0;
if (mmsys_mm<>nil) then mmsys_mm.onmessage(m,w,l);
end;

function gosssnd__onmessage_wave(m,w,l:longint):longint;//wave message handler
begin
result:=0;
if (mmsys_wave<>nil) then mmsys_wave.onmessage(m,w,l);
end;


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__snd(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gosssnd.*"
if (strcopy1(xname,1,8)='gosssnd.') then strdel1(xname,1,8) else exit;

//get
if      (xname='ver')        then result:='4.00.9256'
else if (xname='date')       then result:='06nov2025'
else if (xname='name')       then result:='Sound'
else
   begin
   //nil
   end;

except;end;
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//rrrrrrrrrrrrrrrrrrrrrrrrrrrrr
//-- "mm" multimedia support ---------------------------------------------------
function mm_safetohalt:boolean;
begin

//defaults
result:=true;

//check
if result and (mmsys_midi<>nil) then result:=mmsys_midi.halt and mmsys_midi.halted;

end;

procedure mm_init;
label
   skipend;
var
   p:longint;
begin

//check
if      (mmsys_mode=2)  then exit//already inited
else if (mmsys_mode<>0) then exit;//not free -> error

//get
mmsys_mode:=1;//initing

//midi
low__cls(@mmsys_mid_deviceok,sizeof(mmsys_mid_deviceok));
for p:=low(mmsys_mid_deviceok) to high(mmsys_mid_deviceok) do mmsys_mid_devicename[p]:='';//09sep2025: new range -2..N


low__cls(@mmsys_mid_voiceindex,sizeof(mmsys_mid_voiceindex));
for p:=0 to high(mmsys_mid_voiceindex) do mmsys_mid_voiceindex[p]:=-1;//not set - 20aug2024

low__cls(@mmsys_mid_mutetrack,sizeof(mmsys_mid_mutetrack));
low__cls(@mmsys_mid_mutenote,sizeof(mmsys_mid_mutenote));
low__cls(@mmsys_mid_chvol,sizeof(mmsys_mid_chvol));
for p:=0 to high(mmsys_mid_chvol) do mmsys_mid_chvol[p]:=100;//13sep2025

//.status
mmsys_mid_dataref   :=0;
mmsys_mid_ref       :=0;
mmsys_mid_notesref  :=0;

//.tracking
mid_cleartracking;

//wave
for p:=0 to high(mmsys_wav_deviceok) do//05mar2022
begin

mmsys_wav_deviceok[p]:=false;
mmsys_wav_devicename[p]:='';

end;//p

//done
mmsys_mode:=2;//inited

end;

procedure mm_shut;
begin

//check
if (mmsys_mode>=3) then exit//already shuting or shut
else if (mmsys_mode<>2) then exit;//not inited -> error

//get
mmsys_mode:=3;//shuting

try
//.internal MIDI shutdown
freeobj(@mmsys_midi);

//.internal CHIMES shutdown
freeobj(@mmsys_chimes);

//.internal WAVE shutdown
freeobj(@mmsys_wave);//17jul2021

//.internal MCI shutdown
freeobj(@mmsys_mm);

except;end;

//done
mmsys_mode:=4;//shut

end;

function mm_ok:boolean;
begin
{$ifdef snd}result:=true;{$else}result:=false;{$endif}
end;

function mm_inited:boolean;
begin
result:=(mmsys_mode=2);
end;

function mm_playmanagement_init(var xmuststop,xmustplay,xplaying:boolean;var xmustpertpos:double;var xmustpos,xlastpos:longint;var xlastfilename:string):boolean;
begin

result          :=true;//pass-thru
xmuststop       :=false;
xmustplay       :=false;
xplaying        :=false;
xmustpertpos    :=-1;//off
xmustpos        :=-1;//off
xlastpos        :=0;
xlastfilename   :='';

end;

function mm_playmanagement(xstyle:string;xmode,xintroms:longint;var xmuststop,xmustplay,xplaying,xhostupdate:boolean;var xmustpertpos:double;var xmustpos,xlastpos:longint;var xlastfilename:string;xxnav:tobject;xxplaylist:tobject;xplaylistmask:string;xxjump:tobject):boolean;
label
   skipend;
var
   xselectidle:boolean;
   dstyle,xlen:longint;
   xnav:tbasicnav;
   xplaylist:tbasicmenu;
   xjump:tbasicjump;

   function xcanplay:boolean;
   begin
   if (dstyle=1) then result:=mid_canplaymidi else result:=mm_canplay;
   end;

   function m_len:longint;
   begin
   if (dstyle=1) then result:=mid_len else result:=mm_len;
   end;

   function m_speed:longint;
   begin
   if (dstyle=1) then result:=mid_speed else result:=100;//07sep2025
   end;

   function m_canpertpos:boolean;//06mar2022
   begin
   if (dstyle=1) then result:=mid_canpertpos else result:=mm_canpertpos;
   end;

   function m_pos:longint;
   begin
   if (dstyle=1) then result:=mid_pos else result:=mm_pos;
   end;

   procedure m_setpos(x:longint);
   begin
   if (dstyle=1) then mid_setpos(x) else mm_setpos(x);
   end;

   procedure m_check24hr;
   begin
   if (dstyle=1) then mid_check24hr;
   end;

   procedure m_setpertpos(x:double);
   begin
   if (dstyle=1) then mid_setpertpos(x) else mm_setpertpos(x);
   end;

   function m_seeking:boolean;
   begin
   if (dstyle=1) then result:=mid_seeking else result:=mm_seeking;
   end;

   function m_playing:boolean;
   begin
   if (dstyle=1) then result:=mid_playing else result:=mm_playing;
   end;

   function m_playfile(x:string):boolean;
   begin
   if (dstyle=1) then result:=mid_playfile(x) else result:=mm_playfile(x);
   end;

   procedure m_stop;
   begin
   if (dstyle=1) then mid_stop else mm_stop;
   end;

   function xnavvalue:string;
   begin
   result:='';
   if (xnav<>nil) then result:=xnav.value else if (xplaylist<>nil) then result:=xplaylist.xgetval2(xplaylist.itemindex);
   end;

   function xidletime:comp;
   begin
   result:=0;
   if (xnav<>nil) then result:=xnav.idletime else if (xplaylist<>nil) then result:=xplaylist.idletime;
   end;

   function xnavlist:tbasicmenu;
   begin
   result:=nil;
   if (xnav<>nil) then result:=xnav.xlist else if (xplaylist<>nil) then result:=xplaylist;
   end;

   function xnavmask:string;
   begin
   result:='';
   if (xnav<>nil) then result:=xnav.omasklist else if (xplaylist<>nil) then result:=xplaylistmask;
   end;
begin

//defaults
result       :=true;//pass-thru
xhostupdate  :=false;


try
//check class
if (xxnav<>nil) and (xxnav is tbasicnav)             then xnav:=(xxnav as tbasicnav)                 else xnav:=nil;
if (xxplaylist<>nil) and (xxplaylist is tbasicmenu)  then xplaylist:=(xxplaylist as tbasicmenu)      else xplaylist:=nil;
if (xxjump<>nil) and (xxjump is tbasicjump)          then xjump:=(xxjump as tbasicjump)              else xjump:=nil;

//required
if (xnav=nil) and (xplaylist=nil) then exit;

//style
xstyle:=strlow(xstyle);
if (xstyle='mid') then dstyle:=1 //mid
else                   dstyle:=0;//mm

//check
if (not xcanplay) or m_seeking then exit;

//range
xintroms:=frcmin32(xintroms,0);

//init
xlen:=frcrange32(m_len,0,low__aorb(max32,xintroms,xintroms>0));
xmode:=frcrange32(xmode,0,mmMax);//playback mode (once, repeat all, random etc)
xselectidle:=(xidletime>=2000) and (not xmustplay);//list idleness detector - 21feb2022

//file - manual list
if xplaying and (not strmatch(xlastfilename,xnavvalue)) then xmustplay:=true;


//stop - takes priority over play - 21feb2022
if xmuststop then
   begin

   xlastpos      :=m_pos;
   xplaying      :=false;
   xmustplay     :=false;
   xmuststop     :=false;
   xmustpos      :=-1;//off
   xmustpertpos  :=-1;//off

   if m_playing then m_stop;

   goto skipend;

   end;

//play
if xmustplay then
   begin

   if (not xplaying) and (xmustpos<0) and (xmustpertpos<0) then xmustpos:=xlastpos;

   xplaying      :=true;
   xmustplay     :=false;
   xmuststop     :=false;

   if m_playing then m_stop;

   if low__setstr(xlastfilename,xnavvalue) then
      begin

      if not m_canpertpos then xmustpertpos:=-1;//reset if system DOES NOT support pert pos - 06mar2022
      xmustpos   :=-1;

      end;

   m_playfile(xlastfilename);

   if (xmustpertpos>=0) then m_setpertpos(xmustpertpos) else m_setpos(xmustpos);
   if (xjump<>nil) then xjump.setparams(m_pos,m_len,m_speed);//update immediately - 20feb2022

   xmustpos      :=-1;//off
   xmustpertpos  :=-1;//off
   xhostupdate   :=true;//now playing -> host should update any information panels etc - 22feb2022
   goto skipend;

   end;

//pos
if (xmustpos>=0) or (xmustpertpos>=0) then
   begin
   case xplaying of
   true:begin
      if (xmustpertpos>=0) then m_setpertpos(xmustpertpos) else m_setpos(xmustpos);
      xmustpertpos:=-1;
      xmustpos:=-1;
      end;
   else xmustplay:=true;
   end;
   goto skipend;
   end;

//repeat
if xplaying and (m_pos>=xlen) then
   begin
   //get
   case xmode of
   mmOnce:begin
      xmuststop:=true;
      goto skipend;
      end;
   mmRepeatOne:begin
      m_check24hr;//23oct2025
      xmustpos:=0;
      goto skipend;
      end;
   mmRepeatAll:;//do below
   mmAllOnce  :;//do below
   mmRandom:begin
      if xselectidle then
         begin
         xnavlist.itemindex:=random(xnavlist.count);
         xmustplay:=true;
         end;
      end;
   else goto skipend;
   end;//case
   //set
   if xselectidle then
      begin
      if (xnavlist.itemindex>=(xnavlist.count-1)) then
         begin
         case xmode of
         mmRepeatAll:begin
            xnavlist.itemindex:=0;
            xmustplay:=true;
            end;
         mmAllOnce:xmuststop:=true;
         end;//case
         end
      else
         begin
         xnavlist.itemindex:=xnavlist.itemindex+1;
         xmustplay:=true;
         end;
      end;
   goto skipend;
   end;

skipend:

//jump sync
if (xjump<>nil) then xjump.setparams(m_pos,m_len,m_speed);//update immediately - 20feb2022

except;end;
end;


//.wave support ----------------------------------------------------------------
function wav_ok:boolean;
begin
{$ifdef snd}result:=true;{$else}result:=false;{$endif}
end;

function wav_inuse:boolean;//01sep2025
begin
result:=mm_inited and (mmsys_wave<>nil);
end;

function wav_vol:longint;
var
   a:tint4;
   int1,v:longint;
   woc:twaveoutcaps;
   ok:boolean;
begin
//defaults
result:=0;
ok:=false;
v:=maxword;
a.val:=0;
//check
if not mm_inited then exit;

try
//wave
if (win____waveoutgetdevcaps(wave_mapper,@woc,sizeof(woc))=MMSYSERR_NOERROR) and ((woc.dwSupport and WAVECAPS_VOLUME)=WAVECAPS_VOLUME) then
   begin
   ok:=true;
   win____waveOutGetVolume(wave_mapper,@int1);
   a.val:=int1;
   if ((woc.dwSupport and WAVECAPS_LRVOLUME)=WAVECAPS_LRVOLUME) then
      begin//stereo
      if (a.wrds[0]<v) then v:=a.wrds[0];//left
      if (a.wrds[1]<v) then v:=a.wrds[1];//right
      end
   else
      begin//mono -> one ch has volume other is zero
      v:=a.wrds[0]+a.wrds[1];
      end;
   end;

//set
if ok then result:=frcrange32(round((100*v)/maxword),0,100);//0..100%
except;end;
end;

function wav_setvol(x:longint):boolean;
var
   a:tint4;
   woc:twaveoutcaps;
begin
result:=mm_inited;

try
//check
if not result then exit;

//range
a.wrds[0]:=frcrange32(frcrange32(x,0,100)*round(maxword/100),0,maxword);//left
a.wrds[1]:=a.wrds[0];//right

//wave - required since we READ the volume from wave - 23mar2022
if (win____waveoutgetdevcaps(wave_mapper,@woc,sizeof(woc))=MMSYSERR_NOERROR) and ((woc.dwSupport and WAVECAPS_VOLUME)=WAVECAPS_VOLUME) then win____waveOutSetVolume(wave_mapper,a.val);
except;end;
end;

procedure wav_devicelist;
var
   moc:twaveoutcaps;
   v,c,p:longint;

   function xnamestr:string;//13may2021
   var
      p:longint;
      str1:string;
   begin
   //defaults
   result:='';

   try
   //get
   low__setlen(str1,sizeof(moc.szPname));
   if (str1<>'') then
      begin
      for p:=1 to low__len(str1) do
      begin
      v:=frcrange32(ord(moc.szPname[p-1]),0,255);
      if (v=0) then
         begin
         low__setlen(str1,p-1);
         break;
         end
      else str1[p-1+stroffset]:=char(byte(v));
      end;//p
      //set
      result:=str1;
      end;
   except;end;
   end;
begin
try
if (mmsys_wav_devicetime=0) or (ms64>=mmsys_wav_devicetime) then
   begin
   //reset
   mmsys_wav_devicetime:=ms64+10000;//check every max 10secs - 18apr2021
   //get -> Note: 0=wave-mapper, 1..N = Device #0..(N-1)
   c:=0;
   try
   for p:=0 to high(mmsys_wav_deviceok) do
   begin
   if (p<=0) then
      begin
      mmsys_wav_deviceok[p]:=true;
      mmsys_wav_devicename[p]:='Wave Mapper';
      end
   else
      begin
      mmsys_wav_deviceok[p]:=(win____waveoutgetdevcaps(p-1,@moc,sizeof(moc))=MMSYSERR_NOERROR);
      if mmsys_wav_deviceok[p] then mmsys_wav_devicename[p]:=xnamestr else mmsys_wav_devicename[p]:='';
      end;
   //.count
   if mmsys_wav_deviceok[p] then c:=p+1;
   end;//p
   except;end;
   //set
   mmsys_wav_devicecount:=c;
   end;
except;end;
end;

function wav_deviceindex:longint;
begin//not operational yet
result:=0;
end;

function wav_setdeviceindex(x:longint):boolean;
begin//Not operational yet
result:=false;
end;

function wav_devicelimit:longint;
begin
if mm_inited then result:=(high(mmsys_wav_deviceok)+1) else result:=0;
end;

function wav_devicecount:longint;//exclude wave mapper
begin
if mm_inited then
   begin
   wav_devicelist;
   result:=mmsys_wav_devicecount;
   end
else result:=0;
end;

function wav_deviceok(xindex:longint):boolean;
begin
if mm_inited then
   begin
   wav_devicelist;
   result:=(xindex>=0) and (xindex<=high(mmsys_wav_deviceok)) and mmsys_wav_deviceok[xindex];
   end
else result:=false;
end;

function wav_devicename(xindex:longint;xdefval:string):string;
begin
if mm_inited then
   begin
   wav_devicelist;
   if (xindex>=0) and (xindex<=high(mmsys_wav_deviceok)) then result:=mmsys_wav_devicename[xindex];
   result:=strdefb(result,xdefval);
   end
else result:='';
end;

function wav_flush44:boolean;
begin
result:=mm_inited;
if result then mm_wave.pflush;
end;

function wav_push44(x:tstr8):boolean;
begin
if mm_inited then
   begin
   mm_wave.format:='44100 16 1';//xxxxxxxxxxxx
   result:=mm_wave.push(x);
   end
else result:=false;
end;

function wav_len44:longint;
begin
if mm_inited then result:=mm_wave.pushlen else result:=0;
end;

//.midi support ----------------------------------------------------------------
function mid_ok:boolean;
begin
{$ifdef snd}result:=true;{$else}result:=false;{$endif}
end;

function mid_inuse:boolean;//01sep2025
begin
result:=mm_inited and (mmsys_midi<>nil);
end;

function mid_timercode:longint;
begin
if mid_inuse then result:=mmsys_midi.timercode else result:=0;
end;

function mid_timermsg:string;
begin
if mid_inuse then result:=mmsys_midi.timermsg else result:='';
end;

function mid_trackinginfo(const xchannel,xnote:byte;var xinfo:tmidinote):boolean;//16sep2025
begin

if (xchannel>=0) and (xchannel<=15) and (xnote>=0) and (xnote<=127) then
   begin

   result  :=true;
   xinfo   :=mmsys_mid_tracking.channels[xchannel].notes[xnote];

   end
else
   begin

   result          :=false;
   low__cls(@xinfo,sizeof(xinfo));

   end;

end;

function mid_trackingTrackid(const xtrack:longint):longint;
begin
if (xtrack>=0) and (xtrack<=high(mmsys_mid_tracking.trackid)) then result:=mmsys_mid_tracking.trackid[xtrack] else result:=0;
end;

function mid_trackingChannelid(const xchannel:longint):longint;
begin
if (xchannel>=0) and (xchannel<=high(mmsys_mid_tracking.channelid)) then result:=mmsys_mid_tracking.channelid[xchannel] else result:=0;
end;

function mid_trackingNoteid(const xnote:longint):longint;
begin
if (xnote>=0) and (xnote<=high(mmsys_mid_tracking.noteid)) then result:=mmsys_mid_tracking.noteid[xnote] else result:=0;
end;

function mid_trackingid:longint;
begin
result:=mmsys_mid_tracking.id;
end;

procedure mid_cleartracking;//03sep2025, 21aug2024
begin

low__cls(@mmsys_mid_tracking,sizeof(mmsys_mid_tracking));

end;

function mid_voicename(xindex:longint):string;//20aug2025
begin

case frcrange32(xindex,-1,127) of
-1:result:='';//28aug2025
0:result:='Acoustic Grand Piano';
1:result:='Bright Acoustic Piano';
2:result:='Electric Grand Piano';
3:result:='Honky-tonk Piano';
4:result:='Electric Piano 1';
5:result:='Electric Piano 2';
6:result:='Harpsichord';
7:result:='Clavinet';
8:result:='Celesta';
9:result:='Glockenspiel';
10:result:='Music Box';
11:result:='Vibraphone';
12:result:='Marimba';
13:result:='Xylophone';
14:result:='Tubular Bells';
15:result:='Dulcimer';
16:result:='Drawbar Organ';
17:result:='Percussive Organ';
18:result:='Rock Organ';
19:result:='Church Organ';
20:result:='Reed Organ';
21:result:='Accordion';
22:result:='Harmonica';
23:result:='Tango Accordion';
24:result:='Acoustic Guitar (nylon)';
25:result:='Acoustic Guitar (steel)';
26:result:='Electric Guitar (jazz)';
27:result:='Electric Guitar (clean)';
28:result:='Electric Guitar (muted)';
29:result:='Overdriven Guitar';
30:result:='Distortion Guitar';
31:result:='Guitar harmonics';
32:result:='Acoustic Bass';
33:result:='Electric Bass (finger)';
34:result:='Electric Bass (pick)';
35:result:='Fretless Bass';
36:result:='Slap Bass 1';
37:result:='Slap Bass 2';
38:result:='Synth Bass 1';
39:result:='Synth Bass 2';
40:result:='Violin';
41:result:='Viola';
42:result:='Cello';
43:result:='Contrabass';
44:result:='Tremolo Strings';
45:result:='Pizzicato Strings';
46:result:='Orchestral Harp';
47:result:='Timpani';
48:result:='String Ensemble 1';
49:result:='String Ensemble 2';
50:result:='Synth Strings 1';
51:result:='Synth Strings 2';
52:result:='Choir Aahs';
53:result:='Voice Oohs';
54:result:='Synth Voice';
55:result:='Orchestra Hit';
56:result:='Trumpet';
57:result:='Trombone';
58:result:='Tuba';
59:result:='Muted Trumpet';
60:result:='French Horn';
61:result:='Brass Section';
62:result:='Synth Brass 1';
63:result:='Synth Brass 2';
64:result:='Soprano Sax';
65:result:='Alto Sax';
66:result:='Tenor Sax';
67:result:='Baritone Sax';
68:result:='Oboe';
69:result:='English Horn';
70:result:='Bassoon';
71:result:='Clarinet';
72:result:='Piccolo';
73:result:='Flute';
74:result:='Recorder';
75:result:='Pan Flute';
76:result:='Blown Bottle';
77:result:='Shakuhachi';
78:result:='Whistle';
79:result:='Ocarina';
80:result:='Lead 1 (square)';
81:result:='Lead 2 (sawtooth)';
82:result:='Lead 3 (calliope)';
83:result:='Lead 4 (chiff)';
84:result:='Lead 5 (charang)';
85:result:='Lead 6 (voice)';
86:result:='Lead 7 (fifths)';
87:result:='Lead 8 (bass + lead)';
88:result:='Pad 1 (new age)';
89:result:='Pad 2 (warm)';
90:result:='Pad 3 (polysynth)';
91:result:='Pad 4 (choir)';
92:result:='Pad 5 (bowed)';
93:result:='Pad 6 (metallic)';
94:result:='Pad 7 (halo)';
95:result:='Pad 8 (sweep)';
96:result:='FX 1 (rain)';
97:result:='FX 2 (soundtrack)';
98:result:='FX 3 (crystal)';
99:result:='FX 4 (atmosphere)';
100:result:='FX 5 (brightness)';
101:result:='FX 6 (goblins)';
102:result:='FX 7 (echoes)';
103:result:='FX 8 (sci-fi)';
104:result:='Sitar';
105:result:='Banjo';
106:result:='Shamisen';
107:result:='Koto';
108:result:='Kalimba';
109:result:='Bag pipe';
110:result:='Fiddle';
111:result:='Shanai';
112:result:='Tinkle Bell';
113:result:='Agogo';
114:result:='Steel Drums';
115:result:='Woodblock';
116:result:='Taiko Drum';
117:result:='Melodic Tom';
118:result:='Synth Drum';
119:result:='Reverse Cymbal';
120:result:='Guitar Fret Noise';
121:result:='Breath Noise';
122:result:='Seashore';
123:result:='Bird Tweet';
124:result:='Telephone Ring';
125:result:='Helicopter';
126:result:='Applause';
127:result:='Gunshot';
else result:='';
end;//case

end;

function mid_voiceisBass(const xnote:longint):boolean;//02sep2025
begin

case xnote of
32..39,43,62..63,87,114,116,118:result:=true;
else result:=false;
end;//case

end;

function mid_voiceisDrum(const xnote:longint):boolean;//02sep2025

   procedure y;
   begin
   result:=true;
   end;

begin

case xnote of
35:y;//Acoustic Bass Drum
36:y;//Bass Drum 1
41:y;//Low Floor Tom
43:y;//High Floor Tom
45:y;//Low Tom
47:y;//Low-Mid Tom
48:y;//Hi-Mid Tom
50:y;//High Tom
60:y;//Hi Bongo
61:y;//Low Bongo
62:y;//Mute Hi Conga
63:y;//Open Hi Conga
64:y;//Low Conga
else result:=false;
end;//case

end;


procedure mid_devicelist_lockfromchanging(const xlock:boolean);//02nov2025
begin

case xlock of
true:if (mmsys_mid_devicechangeLock<max32) then inc(mmsys_mid_devicechangeLock);
else if (mmsys_mid_devicechangeLock>0)     then dec(mmsys_mid_devicechangeLock);
end;//case

end;

function mid_devicelist_locked:boolean;
begin
result:=(mmsys_mid_devicechangeLock<>0);
end;

procedure mid_devicelist;//26sep2026, 09sep2025, 04sep2025
var
   moc:tmidioutcaps;
   mcount,p:longint;
   bol1,xatleastonedeviceIsGood:boolean;

   procedure s(const xok:boolean;const xlabel:string);
   begin

   mmsys_mid_deviceok  [p]  :=xok;
   mmsys_mid_devicename[p]  :=xlabel;//was: strdefb(xlabel,'-');

   if (p>=mmsys_mid_devicestart) and xok then xatleastonedeviceIsGood:=true;

   end;

begin

//check -> update is locked -> ignore until lock is disabled
if mid_devicelist_locked then exit;

//repeat check
if (mmsys_mid_devicetime>=ms64) then exit else mmsys_mid_devicetime:=add64(ms64,10000);//check every 10secs

//init
mcount                   :=frcmax32( win____midiOutGetNumDevs, high(mmsys_mid_deviceok) + 1 );
xatleastonedeviceIsGood  :=false;

//get -> -2=broadcast all devices, -1=midi-mapper, 0..N = midi device #0..(N-1)
for p:=low(mmsys_mid_deviceok) to high(mmsys_mid_deviceok) do
begin

case p of
mmsys_mid_broadcast   :s(true,'All Midi Devices');
mmsys_mid_midimapper  :s(true,'Midi Mapper');
else if (p<mcount) then
   begin

   //init
   low__cls(@moc,sizeof(moc));//01sep2025

   //get
   bol1:=(win____midioutgetdevcaps(p,@moc,sizeof(moc))=MMSYSERR_NOERROR);
   s( bol1, strdefb(string(moc.szPname),'Device #'+k64(p+1)) );//09sep2025

   end
else s(false,'');
end;//case

end;//p

//sync special device slots - 09sep2025
mmsys_mid_deviceok[ mmsys_mid_broadcast  ]:=xatleastonedeviceIsGood;
mmsys_mid_deviceok[ mmsys_mid_midimapper ]:=xatleastonedeviceIsGood;

//set
mmsys_mid_devicecount:=mcount;

end;

function mid_devicelistHasChanged(var sref:string;const xreset:boolean):boolean;//02nov2025
var
   p:longint;
   dref:string;
begin

//defaults
result:=false;

//get
dref:=intstr32(mmsys_mid_devicecount)+'|';
for p:=1 to mmsys_mid_devicecount do dref:=dref+#10+mmsys_mid_devicename[p];

//set
if (sref<>dref) then
   begin

   result:=true;
   if xreset then sref:=dref;

   end;

end;


function mid_outdevicecount:longint;//0=no midi output devices - 04sep2025, 10aug2025
begin
result:=mmsys_mid_devicecount;
end;

function mid_canstop:boolean;
begin
result:=mm_inited and mm_midi.canstop;
end;

procedure mid_stop;
begin
if mm_inited then mm_midi.stop;
end;

function mid_canplay:boolean;
begin
result:=mm_inited and mm_midi.canplay;
end;

procedure mid_play;
begin
if mm_inited then mm_midi.play;
end;

procedure mid_enhance(x:boolean);
begin
mmsys_mid_enhanced:=x;
end;

function mid_enhanced:boolean;
begin
result:=mmsys_mid_enhanced;
end;

function mid_canplaymidi:boolean;
begin
result:=mm_inited and mm_midi.canplaymidi;
end;

function mid_playmidi(xmiddata:tstr8):boolean;
begin
if mm_inited then result:=mm_midi.playdata(xmiddata)
else
   begin
   result:=false;
   str__af(@xmiddata);
   end;
end;

function mid_playfile(xfilename:string):boolean;
begin
result:=mm_inited and mm_midi.playfile(xfilename);
end;

function mid_speed:longint;
begin
if mm_inited then result:=mm_midi.speed else result:=0;
end;

function mid_speed2:longint;
begin
if mm_inited then result:=mm_midi.speed2 else result:=0;
end;

function mid_setspeed(x:longint):boolean;
begin
result:=mm_inited;
if result then mm_midi.speed:=x;
end;

function mid_setspeed2(x:longint):boolean;
begin
result:=mm_inited;
if result then mm_midi.speed2:=x;
end;

function mid_style:longint;
begin
if mm_inited then result:=mm_midi.style else result:=0;
end;

function mid_setstyle(x:longint):boolean;
begin
result:=mm_inited;
if result then mm_midi.style:=x;
end;

function mid_trimtolastnote:boolean;//11jan2025
begin
if mm_inited then result:=mm_midi.otrimtolastnote else result:=false;
end;

function mid_settrimtolastnote(x:boolean):boolean;//11jan2025
begin
result:=mm_inited;
if result then mm_midi.otrimtolastnote:=x;
end;

function mid_trimmed:boolean;//11jan2025 - true: midi was trimmed to last note, false=midi is untrimmed
begin
if mm_inited then result:=mm_midi.trimmed else result:=false;
end;

procedure mid_enter1;
begin
if mm_inited then mm_midi.enter1;
end;

procedure mid_leave1;
begin
if mm_inited then mm_midi.leave1;
end;

function mid_deviceindex:longint;
begin

if mm_inited then result:=mm_midi.deviceindex else result:=0;

end;

function mid_setdeviceindex(const x:longint):boolean;
begin

result:=mm_inited;
if result then mm_midi.deviceindex:=x;

end;

function mid_SafeDeviceIndexRange(const x:longint):longint;
begin

result:=frcrange32(x,low(mmsys_mid_deviceok),high(mmsys_mid_deviceok));
if not mmsys_mid_AllowAllDevices then result:=frcmin32(result,mmsys_mid_midimapper);

end;

function mid_devicelimit:longint;//09sep2025
begin

if mm_inited then result:=(mmsys_mid_devicefinish-mmsys_mid_devicestart+1) else result:=0;

end;

function mid_devicecount:longint;//exclude midi mapper
begin

if mm_inited then
   begin

   mid_devicelist;
   result:=mmsys_mid_devicecount;

   end
else result:=0;

end;

function mid_deviceok(xindex:longint):boolean;
begin

if mm_inited then
   begin

   mid_devicelist;

   result:=(xindex>=low(mmsys_mid_deviceok)) and (xindex<=high(mmsys_mid_deviceok)) and mmsys_mid_deviceok[xindex];//09sep2025

   end
else result:=false;

end;

function mid_devicename(xindex:longint;xdefval:string):string;
begin

if mm_inited then
   begin

   mid_devicelist;

   if (xindex>=low(mmsys_mid_deviceok)) and (xindex<=high(mmsys_mid_deviceok)) then result:=mmsys_mid_devicename[xindex];

   result:=strdefb(result,xdefval);

   end
else result:='';

end;

function mid_seeking:boolean;
begin
result:=mm_inited and mm_midi.seeking;
end;

function mid_transpose:longint;//14feb2025
begin
if mm_inited then result:=mm_midi.transpose else result:=0;
end;

function mid_settranspose(x:longint):boolean;//14feb2025
begin
result:=mm_inited;
if result then mm_midi.transpose:=x;
end;

function mid_vol:longint;//07sep2025
var//Note: Returns the lowest volume value from WAVE only, as under Win10 MIDI_MAPPER levels aren't adjusted by Volume Mixer whereas WAVE_MAPPER are - 30mar2021
   int1,v:longint;
   a:tint4;
   woc:twaveoutcaps;
   ok:boolean;
begin

//defaults
result :=0;
ok     :=false;
v      :=maxword;
a.val  :=0;

//check
if not mm_inited then exit;

try
//wave
if (win____waveoutgetdevcaps(wave_mapper,@woc,sizeof(woc))=MMSYSERR_NOERROR) and ((woc.dwSupport and WAVECAPS_VOLUME)=WAVECAPS_VOLUME) then
   begin
   ok:=true;
   win____waveOutGetVolume(wave_mapper,@int1);
   a.val:=int1;
   if ((woc.dwSupport and WAVECAPS_LRVOLUME)=WAVECAPS_LRVOLUME) then
      begin//stereo
      if (a.wrds[0]<v) then v:=a.wrds[0];//left
      if (a.wrds[1]<v) then v:=a.wrds[1];//right
      end
   else
      begin//mono -> one ch has volume other is zero
      v:=a.wrds[0]+a.wrds[1];
      end;
   end;

//midi
//Note: Can't use MIDI volume levels as a guide to system volume level as Win10 doesn't set them via Volume Mixer when the slider is shifted (midi can use multi-output cards) - 31mar2021
//      Do not use as of yet.
{
if (midioutgetdevcaps(midi_mapper,@moc,sizeof(moc))=MMSYSERR_NOERROR) and ((moc.dwSupport and MIDICAPS_VOLUME)=MIDICAPS_VOLUME) then
   begin
   ok:=true;
   midiOutGetVolume(midi_mapper,@int1);
   a.val:=int1;
   if ((woc.dwSupport and MIDICAPS_LRVOLUME)=MIDICAPS_LRVOLUME) then
      begin//stereo
      if (a.wrds[0]<v) then v:=a.wrds[0];//left
      if (a.wrds[1]<v) then v:=a.wrds[1];//right
      end
   else
      begin//mono -> one ch has volume other is zero
      v:=a.wrds[0]+a.wrds[1];
      end;
   end;
{}

//set
if ok then result:=frcrange32(round((100*v)/maxword),0,100);//0..100%

//extended range -> uses feedback to work WITH Microsoft Windows Volume Mixer and other Midi Drivers - 23mar2022
if viwine then result:=mmsys_mid_basevol//linux -> no separate midi/wave volume handler -> so we do it all - 23mar2022
//was: false:if (result>=100) then result:=100+frcrange32(mmsys_mid_basevol-100,0,100) else mmsys_mid_basevol:=100;//windows
//was: else if (result>=100) then result:=100+frcrange32(mmsys_mid_basevol-100,0,100) else mmsys_mid_basevol:=result;//windows
else if (result>=100) then
   begin

   //detect a sudden rise in volume from the Windows Mixer app and adapt
   if (mmsys_mid_basevol<100) then mmsys_mid_basevol:=100;

   //get
   result:=100+frcrange32(mmsys_mid_basevol-100,0,100)

   end
else mmsys_mid_basevol:=result;//windows

except;end;
end;

function mid_vol1:longint;//modifies volume of notes
begin
if mm_inited then result:=mm_midi.vol else result:=100;
end;

function mid_vol2:longint;//modifies volume of notes
begin
if mm_inited then result:=mm_midi.vol2 else result:=100;
end;

function mid_setvol(x:longint):boolean;//04sep2024
var
   a:tint4;
   woc:twaveoutcaps;
   moc:tmidioutcaps;
   p,mindex,mcount:longint;

   procedure msetvol(const xindex:longint);
   begin

   if (xindex>=-1) and (xindex<mcount) and (win____midioutgetdevcaps(xindex,@moc,sizeof(moc))=MMSYSERR_NOERROR) and
      ((moc.dwSupport and MIDICAPS_VOLUME)=MIDICAPS_VOLUME) then win____midiOutSetVolume(xindex,a.val);

   end;

begin
//defaults
result   :=mm_inited;

//check
if not result then exit;

//init
low__cls(@woc,sizeof(woc));
low__cls(@moc,sizeof(moc));
mcount   :=win____midiOutGetNumDevs;
mindex   :=mid_deviceindex;

//range
mmsys_mid_basevol:=frcrange32(x,0,200);


//get
a.wrds[0] :=frcrange32( round( (frcrange32(x,0,100)/100) * maxword) ,0,maxword);//left
a.wrds[1] :=a.wrds[0];//right

//wave - required since we READ the volume from wave - 23mar2022
if (win____waveoutgetdevcaps(wave_mapper,@woc,sizeof(woc))=MMSYSERR_NOERROR) and ((woc.dwSupport and WAVECAPS_VOLUME)=WAVECAPS_VOLUME) then win____waveOutSetVolume(wave_mapper,a.val);

//midi device volume
case mindex of
mmsys_mid_broadcast:begin

   for p:=mmsys_mid_midimapper to (mcount-1) do msetvol(p);

   end;
else msetvol(mindex);
end;//case

end;

function mid_setvol1(x:longint):boolean;//modifies volume of notes
begin
result:=mm_inited;
if result then mm_midi.vol:=x;
end;

function mid_setvol2(x:longint):boolean;//modifies volume of notes
begin
result:=mm_inited;
if result then mm_midi.vol2:=x;
end;

function mid_canpertpos:boolean;//true=system supports percentage positioning, else not - 06mar2022
begin
result:=true;
end;

function mid_pos:longint;
begin
if mm_inited then result:=mm_midi.pos else result:=0;
end;

function mid_pertpos:double;
begin
if mm_inited then result:=low__makepertD0(mm_midi.pos,mm_midi.len) else result:=0;
end;

function mid_setpos(x:longint):boolean;
begin
result:=mm_inited;
if result then mm_midi.pos:=x;
end;

function mid_check24hr:boolean;
begin
result:=mm_inited;
if result then mm_midi.check24hr;
end;

function mid_setpertpos(x:double):boolean;
begin
result:=mm_inited;
if result then mm_midi.pertpos:=x;
end;

function mid_len:longint;
begin
if mm_inited then result:=mm_midi.len else result:=0;
end;

function mid_lenfull:longint;//11jan2025 - untrimmed length in ms
begin
if mm_inited then result:=mm_midi.lenfull else result:=0;
end;

function mid_lyriccount:longint;
begin
if mm_inited then result:=mm_midi.lcount else result:=0;
end;

function mid_lyric(xpos:longint;xshowsep:boolean):string;
begin
if mm_inited then result:=mm_midi.lfind(xpos,xshowsep) else result:='';
end;

function mid_format:longint;
begin
if mm_inited then result:=mm_midi.format else result:=0;
end;

function mid_tracks:longint;
begin
if mm_inited then result:=mm_midi.tracks else result:=0;
end;

function mid_msgs:longint;//14sep2025 - total number of messages in midi
begin
if mm_inited then result:=(mm_midi.msgs*mm_midi.handlecount) else result:=0;
end;

function mid_msgssent:longint;//number of message sent to midi hardware
begin
if mm_inited then result:=mm_midi.msgssent else result:=0;
end;

function mid_msgrate:longint;//messages per second
begin
if mm_inited then result:=(mm_midi.datarate div 4) else result:=0;
end;

function mid_datarate:longint;//bytes per second
begin
if mm_inited then result:=mm_midi.datarate else result:=0;
end;

function mid_msrate:double;//timer resolution expressed as a percentage (0..100)
begin
if mm_inited then result:=mm_midi.msrate else result:=0;
end;

function mid_mspert100:double;//timer resolution
begin
if mm_inited then result:=mm_midi.mspert100 else result:=0;
end;

function mid_pcount:double;//timer events per second
begin
if mm_inited then result:=mm_midi.pcount else result:=0;
end;

function mid_bytes:longint;//memory in use in bytes
begin
if mm_inited then result:=mm_midi.bytes else result:=0;
end;

function mid_midbytes:longint;//size of midi in bytes
begin
if mm_inited then result:=mm_midi.midbytes else result:=0;
end;

function mid_phandle:longint;//handle of midi device
begin
if mm_inited then result:=mm_midi.handle else result:=0;
end;

function mid_handlecount:longint;//number of active midi devices
begin
if mm_inited then result:=mm_midi.handlecount else result:=0;
end;

function mid_itemsid:longint;//09sep2025
begin
if mm_inited then result:=mm_midi.itemsid else result:=0;
end;

function mid_itemcount:longint;//07sep2025
begin
if mm_inited then result:=mm_midi.itemcount else result:=0;
end;

function mid_finditemByFilename(const xfilename:string;var xindex:longint):boolean;
var
   p:longint;
begin

//defaults
result :=false;
xindex :=0;

//find
if (xfilename<>'') then for p:=0 to pred(mid_itemcount) do if strmatch(xfilename,mid_itemfilename(p,false,true)) then
   begin

   result :=true;
   xindex :=p;
   break;

   end;//p

end;

function mid_itemfilename(xindex:longint;xcreatefolder,xusename:boolean):string;//26sep2025
begin

//range
xindex:=frcrange32(xindex,mmsys_mid_devicestart,mmsys_mid_devicefinish);

//get
result:=app__settingsfile2( 'midi-device-' + low__aorbstr( intstr32(xindex), io__safename(mid_devicename(xindex,intstr32(xindex))), xusename) + '.ini' ,xcreatefolder );

end;

function mid_loaditem(xindex:longint):boolean;//26sep2025
var
   v:string;
begin

//pass-thru
result :=true;

//get
v      :=io__fromfilestr2( mid_itemfilename(xindex,false,true) );//load setings from device name, failing that, load from slot #0..N
if (v='') then v:=io__fromfilestr2( mid_itemfilename(xindex,false,false) );

//set
mid_setitemsettings( xindex, v );

end;

function mid_saveitem(xindex:longint):boolean;//26sep2025
var
   v:string;
begin

//pass-thru
result :=true;

//get
v:=mid_itemsettings(xindex);

//set
io__tofilestr2( mid_itemfilename(xindex,true,true), v );//save to midi device "name"
io__tofilestr2( mid_itemfilename(xindex,true,false), v );//save to midi device "slot #" -> fallback if device name does not exist on next app start

end;

function mid_item(xindex:longint):tmidiitem;
begin
if mm_inited then result:=mm_midi.items[xindex] else low__cls(@result,sizeof(result))
end;

function mid_setitem(xindex:longint;const xitem:tmidiitem):boolean;
begin

if mm_inited then
   begin

   result                :=true;
   mm_midi.items[xindex] :=xitem;

   end
else result:=false;

end;

function mid_itemsettings(xindex:longint):string;
begin
if mm_inited then result:=mm_midi.itemsettings[xindex] else result:='';
end;

function mid_setitemsettings(xindex:longint;const xdata:string):boolean;
begin

if mm_inited then
   begin

   result                       :=true;
   mm_midi.itemsettings[xindex] :=xdata;

   end
else result:=false;

end;

function mid_resetitem(xindex:longint):boolean;
begin

if mm_inited then
   begin

   result                :=true;
   mm_midi.resetitem(xindex);

   end
else result:=false;

end;

function mid_resetitems:boolean;
begin

if mm_inited then
   begin

   result                :=true;
   mm_midi.resetitems;

   end
else result:=false;

end;

function mid_setAllowAllDevices(const x:boolean):boolean;
begin

if mm_inited then
   begin

   result                    :=true;
   mmsys_mid_AllowAllDevices :=x;

   end
else result:=false;

end;

function mid_AllowAllDevices:boolean;
begin

result:=mmsys_mid_AllowAllDevices;

end;

function mid_deviceactive:boolean;//have access to midi device - 15apr2021
begin
result:=mm_inited and (mm_midi.handle<>0);
end;

function mid_usingtimer:boolean;
begin
result:=mm_inited and mm_midi.usingtimer;
end;

function mid_playing:boolean;
begin
result:=mm_inited and mm_midi.playing;
end;

function mid_keepopen:boolean;
begin
result:=mm_inited and mm_midi.keepopen;
end;

function mid_setkeepopen(x:boolean):boolean;
begin
result:=mm_inited;
if result then mm_midi.keepopen:=x;
end;

function mid_loop:boolean;
begin
result:=mm_inited and mm_midi.loop;
end;

function mid_setloop(x:boolean):boolean;
begin
result:=mm_inited;
if result then mm_midi.loop:=x;
end;

//.chimes support --------------------------------------------------------------
function chm_ok:boolean;
begin
{$ifdef snd}result:=true;{$else}result:=false;{$endif}
end;

function chm_count:longint;
begin
if mm_inited then result:=mm_chimes.count else result:=0;
end;

function chm_numberfrom1:longint;
begin
if mm_inited then result:=mm_chimes.numberfrom1 else result:=0;
end;

function chm_numberfrom2:longint;
begin
if mm_inited then result:=mm_chimes.numberfrom2 else result:=0;
end;

function chm_numberfrom3:longint;
begin
if mm_inited then result:=mm_chimes.numberfrom3 else result:=0;
end;

function chm_name(xindex:longint):string;
var
   xintro,xdong,xdong2:tstr8;
   int1,int2:longint;
begin
if mm_inited then chm_info(xindex,result,int1,int2,xintro,xdong,xdong2) else result:='';
end;

function chm_canintro(xindex:longint):boolean;
var
   xname:string;
   xintro,xdong,xdong2:tstr8;
   int1,int2:longint;
begin
if mm_inited then result:=chm_info(xindex,xname,int1,int2,xintro,xdong,xdong2) and (xintro<>nil) and (xintro.len>=2) else result:=false;
end;

function chm_candong(xindex:longint):boolean;
var
   xname:string;
   xintro,xdong,xdong2:tstr8;
   int1,int2:longint;
begin
if mm_inited then result:=chm_info(xindex,xname,int1,int2,xintro,xdong,xdong2) and (xdong<>nil) and (xdong.len>=2) else result:=false;
end;

function chm_candong2(xindex:longint):boolean;
var
   xname:string;
   xintro,xdong,xdong2:tstr8;
   int1,int2:longint;
begin
if mm_inited then result:=chm_info(xindex,xname,int1,int2,xintro,xdong,xdong2) and (xdong2<>nil) and (xdong2.len>=2) else result:=false;
end;

function chm_canstop:boolean;
begin
if mm_inited then result:=mm_chimes.canstop else result:=false;
end;

procedure chm_stop;
begin
if mm_inited then mm_chimes.stop;
end;

function chm_mustplayname(xname:string;xmins:longint):boolean;
begin
if mm_inited then result:=mm_chimes.mustplayname(xname,xmins) else result:=false;
end;

function chm_mustplayindex(xindex,xmins:longint):boolean;
begin
if mm_inited then result:=mm_chimes.mustplayindex(xindex,xmins) else result:=false;
end;

function chm_canplay:boolean;
begin
if mm_inited then result:=mm_chimes.canplay else result:=false;
end;

procedure chm_playname(xname:string;xmins:longint;x0,x15,x30,x45,xtest:boolean);
begin
if mm_inited then mm_chimes.playname(xname,xmins,x0,x15,x30,x45,xtest);
end;

procedure chm_playname2(xname:string);
begin
if mm_inited then mm_chimes.playname2(xname);
end;

procedure chm_playname3(xname:string;xmins:longint;n0,n15,n30,n45,b0,s0,s15,s30,s45,xtest:boolean);
begin
if mm_inited then mm_chimes.playname3(xname,xmins,n0,n15,n30,n45,b0,s0,s15,s30,s45,xtest);
end;

procedure chm_playindex(xindex,xmins:longint;x0,x15,x30,x45,xtest:boolean);
begin
if mm_inited then mm_chimes.playindex(xindex,xmins,x0,x15,x30,x45,xtest);
end;

procedure chm_playindex2(xindex:longint);
begin
if mm_inited then mm_chimes.playindex2(xindex);
end;

function chm_chimingpert:double;
begin
if mm_inited then result:=mm_chimes.chimingpert else result:=0;
end;

function chm_chiming:boolean;
begin
if mm_inited then result:=mm_chimes.chiming else result:=false;
end;

function chm_playing:boolean;
begin
result:=chm_chiming;
end;

function chm_testing:boolean;
begin
if mm_inited then result:=mm_chimes.testing else result:=false;
end;

function chm_buzzercount:longint;
begin
if mm_inited then result:=mm_chimes.buzzercount else result:=0;
end;

function chm_buzzer:longint;
begin
if mm_inited then result:=mm_chimes.buzzer else result:=0;
end;

procedure chm_setbuzzer(x:longint);
begin
if mm_inited then mm_chimes.buzzer:=x;
end;

function chm_buzzerlabel(x:longint):string;
begin
if mm_inited then result:=mm_chimes.findbuzzerlabel(x) else result:=intstr32(x);
end;

function chm_vol:longint;//chimes volume, not buzzer
begin
if mm_inited then result:=mm_chimes.vol else result:=0;
end;

procedure chm_setvol(x:longint);//chimes volume, not buzzer
begin
if mm_inited then mm_chimes.vol:=x;
end;

function chm_info(xindex:longint;var xname:string;var xstyle,xtep:longint;var xintro,xdong,xdong2:tstr8):boolean;
begin
//defaults
result  :=false;
xname   :='';
xintro  :=nil;
xdong   :=nil;
xdong2  :=nil;
//get
if mm_inited then result:=mm_chimes.info(xindex,xname,xstyle,xtep,xintro,xdong,xdong2);
end;

function chm_findname(xname:string;var xindex:longint):boolean;
begin
if mm_inited then result:=mm_chimes.findname(xname,xindex)
else
   begin
   result:=false;
   xindex:=0;
   end;
end;

function chm_safename(xname,xdefname:string):string;//15nov2022
label
   once,redo;
var//Note: a name can also be a title which is NOT a chime so chimes always have a style char and the ":" char preceeding their name -> e.g. "m:Westminster" - 15nov2022
   xonce:boolean;
   xstyle,xtep,xindex:longint;
   a,b,c:tstr8;
begin
result:=xname;

try
xonce:=true;
once:
chm_findname(result,xindex);
redo:
chm_info(xindex,result,xstyle,xtep,a,b,c);
if (strcopy1(result,2,1)<>':') then
   begin
   if xonce then
      begin
      xonce:=false;
      if (xdefname<>'') then
         begin
         if (strcopy1(xdefname,2,1)=':') then result:=xdefname else result:='m:Westminster';
         goto once;
         end;
      end;
   inc(xindex);
   if (xindex<100) then goto redo;
   end;
except;end;
end;

//.mm support ------------------------------------------------------------------
function mm_canstop:boolean;
begin
result:=mm_inited and (mm_mm.canstop or mm_playing);
end;

procedure mm_stop;
begin
if mm_inited then
   begin
   mmsys_mm_lastpos:=mm_pos;
   mm_mm.stop;
   end;
end;

function mm_canplay:boolean;
begin
result:=mm_inited and (not mm_mm.playbusy);
end;

function mm_play:boolean;
begin
if mm_inited and mm_canplay then
   begin
   result:=mm_playfile(mmsys_mm_lastfilename);
   mm_setpos(mmsys_mm_lastpos);
   end
else result:=false;
end;

function mm_playfile(xfilename:string):boolean;
var
   e:string;
begin
result:=mm_inited and mm_mm.play(xfilename,e);

case result of
true:begin
   mmsys_mm_lastfilename:=xfilename;
   mmsys_mm_lastsize:=io__filesize64(xfilename);
   mmsys_mm_lastlen:=mm_mm.len;
   mmsys_mm_lastpos:=mm_mm.position;
   end;
else begin
   mmsys_mm_lastfilename:='';
   mmsys_mm_lastsize:=0;
   mmsys_mm_lastlen:=0;
   mmsys_mm_lastpos:=0;
   end;
end;//case
end;

function mm_bytes:comp;
begin
result:=mmsys_mm_lastsize;
end;

function mm_seeking:boolean;
begin
result:=mm_inited and (mm_mm.playbusy or mm_mm.positionbusy);
end;

function mm_canpertpos:boolean;//true=system supports percentage positioning, else not - 06mar2022
begin
result:=true;
end;

function mm_pos:longint;
begin
if mm_inited then
   begin
   if mm_playing and (not mm_seeking) then result:=mm_mm.position else result:=frcrange32(mmsys_mm_lastpos,0,mm_len);//maintain position value even when playback has stopped - 20feb2022
   end
else result:=0;
end;

function mm_setpos(x:longint):boolean;
begin
result:=mm_inited;
if result then
   begin
   mm_mm.position:=frcmin32(x,0);
   mmsys_mm_lastpos:=frcmin32(x,0);
   end;
end;

function mm_setpertpos(x:double):boolean;//06mar2022
var
   v:longint;
begin
result:=mm_inited;
if result then
   begin
   if (x<0) then x:=0 else if (x>100) then x:=100;
   v:=frcrange32(round(mm_mm.len*x) div 100,0,frcmin32(mm_mm.len-1,0));
   mm_mm.position:=frcmin32(v,0);
   mmsys_mm_lastpos:=frcmin32(v,0);
   end;
end;

function mm_len:longint;
begin
if mm_inited then result:=mmsys_mm_lastlen else result:=0;//maintain length value even when playback has stopped - 20feb2022
end;

function mm_deviceactive:boolean;//have access to midi device - 15apr2021
begin
result:=mm_inited and (mm_mm.handle<>0) and (mm_mm.state>=msHold);
end;

function mm_playing:boolean;
begin
result:=mm_inited and mm_mm.playing;
end;

function mm_loop:boolean;
begin
result:=mm_inited and mm_mm.oloop;
end;

function mm_setloop(x:boolean):boolean;
begin
result:=mm_inited;
if result then mm_mm.oloop:=x;
end;

function mm_autostop:boolean;
begin
result:=mm_inited and mm_mm.oautostop;
end;

function mm_setautostop(x:boolean):boolean;
begin
result:=mm_inited;
if result then mm_mm.oautostop:=x;
end;

function mm_mode:tmmodes;
begin
if mm_inited then result:=mm_mm.mode else result:=mmNotReady;
end;

function mm_state:byte;
begin
if mm_inited then result:=mm_mm.state else result:=msFree;
end;

function mm_midi:tbasicmidi;
begin
result:=mmsys_midi;

try
if zznil(result,4500) then
   begin
   mmsys_midi:=tbasicmidi.create;
   result:=mmsys_midi;
   end;
except;end;
end;

function mm_chimes:tbasicchimes;
begin
result:=mmsys_chimes;

try
if zznil(result,4500) then
   begin
   mmsys_chimes:=tbasicchimes.create;
   result:=mmsys_chimes;
   end;
except;end;
end;

function mm_wave:taudiobasic;
begin
result:=mmsys_wave;

try
if zznil(result,4501) then
   begin
   mmsys_wave:=taudiobasic.create;
   result:=mmsys_wave;
   end;
except;end;
end;

function mm_mm:tmm;
begin
result:=mmsys_mm;

try
if zznil(result,4501) then
   begin
   mmsys_mm:=tmm.create;
   result:=mmsys_mm;
   end;
except;end;
end;

function low__getvol:longint;//0..100% - 29mar2021,07OCT2010
var//Note: Returns the lowest volume value from WAVE only, as under Win10 MIDI_MAPPER levels aren't adjusted by Volume Mixer whereas WAVE_MAPPER are - 30mar2021
   int1,v:longint;
   a:tint4;
   woc:twaveoutcaps;
   ok:boolean;
begin
//defaults
result:=0;
ok:=false;
v:=maxword;
a.val:=0;

try
//wave
if (win____waveoutgetdevcaps(wave_mapper,@woc,sizeof(woc))=MMSYSERR_NOERROR) and ((woc.dwSupport and WAVECAPS_VOLUME)=WAVECAPS_VOLUME) then
   begin
   ok:=true;
   win____waveOutGetVolume(wave_mapper,@int1);
   a.val:=int1;
   if ((woc.dwSupport and WAVECAPS_LRVOLUME)=WAVECAPS_LRVOLUME) then
      begin//stereo
      if (a.wrds[0]<v) then v:=a.wrds[0];//left
      if (a.wrds[1]<v) then v:=a.wrds[1];//right
      end
   else
      begin//mono -> one ch has volume other is zero
      v:=a.wrds[0]+a.wrds[1];
      end;
   end;

//midi
//Note: Can't use MIDI volume levels as a guide to system volume level as Win10 doesn't set them via Volume Mixer when the slider is shifted (midi can use multi-output cards) - 31mar2021
//      Do not use as of yet.
{
if (midioutgetdevcaps(midi_mapper,@moc,sizeof(moc))=MMSYSERR_NOERROR) and ((moc.dwSupport and MIDICAPS_VOLUME)=MIDICAPS_VOLUME) then
   begin
   ok:=true;
   midiOutGetVolume(midi_mapper,@int1);
   a.val:=int1;
   if ((woc.dwSupport and MIDICAPS_LRVOLUME)=MIDICAPS_LRVOLUME) then
      begin//stereo
      if (a.wrds[0]<v) then v:=a.wrds[0];//left
      if (a.wrds[1]<v) then v:=a.wrds[1];//right
      end
   else
      begin//mono -> one ch has volume other is zero
      v:=a.wrds[0]+a.wrds[1];
      end;
   end;
{}
//set
if ok then result:=frcrange32(round((100*v)/maxword),0,100);//0..100%

//extend range
case viwine of
true:result:=mmsys_mid_basevol;//linux -> no separate midi/wave volume handler -> so we do it all - 23mar2022
else if (result>=100) then result:=100+frcrange32(mmsys_mid_basevol-100,0,100) else mmsys_mid_basevol:=100;//windows
end;//case

except;end;
end;

procedure low__setvol(x:longint);//0..100% - 29mar2021, 07OCT2010
var
   a:tint4;
   woc:twaveoutcaps;
   moc:tmidioutcaps;
begin
try

//range
case viwine of
true:mmsys_mid_basevol:=frcrange32(x,  0,200);//linux
else mmsys_mid_basevol:=frcrange32(x,100,200);//windows
end;

a.wrds[0]:=frcrange32(frcrange32(x,0,100)*round(maxword/100),0,maxword);//left
a.wrds[1]:=a.wrds[0];//right

//wave
if (win____waveoutgetdevcaps(wave_mapper,@woc,sizeof(woc))=MMSYSERR_NOERROR) and ((woc.dwSupport and WAVECAPS_VOLUME)=WAVECAPS_VOLUME) then
   begin
   win____waveOutSetVolume(wave_mapper,a.val);
   end;

//midi
if (win____midioutgetdevcaps(mid_deviceindex-1,@moc,sizeof(moc))=MMSYSERR_NOERROR) and ((moc.dwSupport and MIDICAPS_VOLUME)=MIDICAPS_VOLUME) then
   begin
   win____midiOutSetVolume(mid_deviceindex-1,a.val);
   end;

except;end;
end;

function midiOutOpen(lphMidiOut:PHMIDIOUT; uDeviceID: UINT; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT;
begin

result:=win____midiOutOpen(lphMidiOut,uDeviceID,dwCallback,dwInstance,dwFlags);
if (result=0) then track__inc(satMidiopen,1);

end;

function midiOutClose(hMidiOut: HMIDIOUT): MMRESULT;
begin

result:=win____midiOutClose(hMidiOut);
if (result=0) then track__inc(satMidiopen,-1);

end;

{
function midiOutData2(hMidiOut:HMIDIOUT;xdata:array of byte):boolean;
var
   a:tmidihdr;
   adata:array[0..999] of byte;
   p,alen:longint;
   xwait64:comp;
begin
try
//defaults
result:=false;
alen:=0;
//check
if (hMidiOut=0) or (low(xdata)<>0) then exit;
//fill
for p:=0 to frcmax32(high(xdata),high(adata)) do
begin
adata[p]:=xdata[p];
alen:=p+1;
end;
//init
fillchar(a,sizeof(a),#0);
a.lpData:=@adata;
a.dwBufferLength:=alen;
a.dwFlags:=0;
if (0=midiOutPrepareHeader(hMidiOut,@a,sizeof(a))) then
   begin
   try
   if (0=midiOutLongMsg(hMidiOut,@a,sizeof(a))) then
      begin
      //wait
      xwait64:=ms64+30000;//wait max of 30 seconds
      while true do
      begin
      if (hMidiOut=0) or (ms64>=xwait64) or (MIDIERR_STILLPLAYING<>midiOutUnprepareHeader(hMidiOut,@a,sizeof(a))) then break;
      sleep(10);
      end;//loop
      end
   else midiOutUnprepareHeader(hMidiOut,@a,sizeof(a));
   //successful
   result:=true;
   except;end;
   end;
except;end;
end;
{
function midioutflush(xhandle:hmidiout;xstyle:longint):boolean;
begin
try
//get
case frcrange32(xstyle,0,3) of
1:midiOutData2(xhandle,[$F0, $41, $10, $42, $12, $40, $00, $7F, $00, $41, $F7]);//GS_reset
2:midiOutData2(xhandle,[$F0, $43, $10, $4C, $00, $00, $7E, $00, $F7]);//XG_reset
3:midiOutData2(xhandle,[$F0, $7E, $7F, $09, $03, $F7]);//GM2_reset
else midiOutData2(xhandle,[$F0, $7E, $7F, $09, $01, $F7]);//GM_reset
end;
//-- reference -- 15apr2021
//  GM_Reset: array[1..6] of byte = ($F0, $7E, $7F, $09, $01, $F7); // = GM_On
//  GS_Reset: array[1..11] of byte = ($F0, $41, $10, $42, $12, $40, $00, $7F, $00, $41, $F7);
//  XG_Reset: array[1..9] of byte = ($F0, $43, $10, $4C, $00, $00, $7E, $00, $F7);
//  GM2_On: array[1..6] of byte = ($F0, $7E, $7F, $09, $03, $F7);  // = GM2_Reset
//  GM2_Off: array[1..6] of byte = ($F0, $7E, $7F, $09, $02, $F7); // switch to GS
//  GS_Off: array[1..11] of byte = ($F0, $41, $10, $42, $12, $40, $00, $7F, $7F, $42, $F7); // = Exit GS Mode
//  SysExMasterVolume: array[1..8] of byte = ($F0, $7F, $7F, $04, $01, $0, $0, $F7);
except;end;
end;
{}

function midioutflush(xhandle:HMIDIOUT):boolean;//11aug2025
var//Note: Takes about 140ms to execute - 26may2021
   xch,xnote,p:byte;
   xcount:longint;

   function xsend(xmsg,xval1,xval2,xval3:byte):boolean;
   var
      xout:tint4;
   begin
   result:=false;

   try

   //use global buffer for maximum stability
   xout.bytes[0]:=xmsg;
   xout.bytes[1]:=xval1;
   xout.bytes[2]:=xval2;
   xout.bytes[3]:=xval3;

   result:=(xhandle<>0) and (0=win____midiOutShortMsg(xhandle,xout.val));

   low__irollone(mmsys_mid_msgoutcount);

   inc(xcount);
   if (xcount>=1000) then
      begin

      xcount:=0;
      win____sleep(20);

      end;

   except;end;
   end;
begin

//defaults
result :=false;
xcount :=0;

try
//check
if (xhandle=0) then exit;

//controller messages
for p:=$b0 to $bf do
begin
//.main
xsend(p,123,0,0);//all sound off
xsend(p,120,0,0);//all sound off
xsend(p,121,0,0);//reset all controllers to their default states
//.msb
xsend(p,7,64,0);//channel volume
xsend(p,8,64,0);//balance
xsend(p,10,64,0);//pan
//.lsb
xsend(p,39,64,0);//channel volume
xsend(p,40,64,0);//balance
xsend(p,42,64,0);//pan
//.switches
xsend(p,64,0,0);//Sustain On/Off
xsend(p,65,0,0);//Portamento On/Off
xsend(p,66,0,0);//Sostenuto On/Off
xsend(p,67,0,0);//Soft Pedal On/Off
xsend(p,68,0,0);//Legato On/Off
xsend(p,69,0,0);//Hold 2 On/Off
end;//p

//voice/instruments
for p:=$c0 to $cf do
begin

xsend(p,0,0,0);//voice or instrument

mmsys_mid_voiceindex[p-$c0]:=-1;//not set - 27aug2025: fixed, 20aug2024

end;//p

//status
low__irollone(mmsys_mid_ref);
low__irollone(mmsys_mid_notesref);

//clear midi tracking
mid_cleartracking;

//successful
result:=true;

except;end;
end;


//-- Low level midi note storage procs for use with "tstr8" - 14feb2021 --------------------------------
function low__makemid(x:string;var xdata:tstr8;var e:string):boolean;//make a simple, single track midi - 15nov2022, 16mar2022
label//Example usage:  "0i14 50n98 150n99 200n97 180n96 100n94 200n94 200n94 100n96 100n96 100n96 100n96 100n96 100n96 1000e 200n80 200n90 100n80 100n90 200n80 200n90" or "0i14 0n90 1000e0" or "0i14 0s-10 0n90 1000e0"
   skipend;
const
   xtempo_ms=500;
var
   a:twrd2;
   b:tint4;
   xnotes:array[0..127] of longint;
   xdelayshift,xnoteshift,dtracklen,xBPM,i,p,xlen,lp2,lp,xpos,xvol:longint;
   n:char;
   t,v,vbig,vint:longint;
   xonce:boolean;

   function xnext:boolean;
   label
      redo,skipone,skipend;
   var
      a:longint;
   begin
   //defaults
   result:=false;
   t:=0;
   n:='?';
   v:=0;
   vbig:=0;
   vint:=0;
   lp2:=lp;

   try
   //get
   redo:
   a:=ord(x[xpos-1+stroffset]);
   if (a>=33) and ((a<48) or (a>57)) and (a<>45) then lp2:=xpos;
   if (a=10) or (a=13) or (a=32) or (a=44) then
      begin
      if (lp=lp2) then
         begin
         lp:=xpos+1;
         lp2:=lp;
         goto skipone;
         end;
      //get
      t:=frcmin32(strint(strcopy1(x,lp,lp2-lp)),0);
      n:=strcopy1(x+'?',lp2,1)[1];
      v:=frcrange32(strint(strcopy1(x,lp2+1,xpos-lp2-1)),0,127);
      vbig:=frcmin32(strint(strcopy1(x,lp2+1,xpos-lp2-1)),0);
      vint:=strint(strcopy1(x,lp2+1,xpos-lp2-1));//15nov2022
      //reset
      inc(xpos);
      lp:=xpos;
      lp2:=lp;
      result:=true;
      goto skipend;
      end;
   //.loop
   skipone:
   inc(xpos);
   if (xpos<=xlen) then goto redo;
   skipend:
   except;end;
   end;

   procedure tadd(xms:longint);//adds delta tick delay
   var
      v1,v2,v3,v4,xticks:longint;
   begin
   try
   //range
   if (xms>=1) and (xdelayshift<>0) then inc(xms,round(xms*(xdelayshift/100)));//15nov2022
   xms:=frcrange32(xms,0,30000);
   //convert
   xticks:=trunc((xms*xBPM)/xtempo_ms);
   //get
   //.v1
   v1:=xticks div (128*128*128);
   dec(xticks,v1*(128*128*128));
   //.v2
   v2:=xticks div (128*128);
   dec(xticks,v2*(128*128));
   //.v3
   v3:=xticks div 128;
   dec(xticks,v3*128);
   //.v4
   v4:=xticks;
   //set
   //.4b var-len
   if (v1>=1) then
      begin
      xdata.addbyt1(v1+128);//the 128 is to mark this as PART of the variable length number, only the last byte falls in the range 0..127 (never 128+)
      xdata.addbyt1(v2+128);
      xdata.addbyt1(v3+128);
      xdata.addbyt1(v4);
      end
   //.3b var-len
   else if (v2>=1) then
      begin
      xdata.addbyt1(v2+128);
      xdata.addbyt1(v3+128);
      xdata.addbyt1(v4);
      end
   //.2b var-len
   else if (v3>=1) then
      begin
      xdata.addbyt1(v3+128);
      xdata.addbyt1(v4);
      end
   //.1b var-len
   else
      begin
      xdata.addbyt1(v4);
      end;
   except;end;
   end;

   procedure iadd(xinstrument:longint);
   begin
   //range
   xinstrument:=frcrange32(xinstrument,0,127);
   //get
   tadd(t);
   xdata.aadd([$C0,byte(xinstrument)]);
   end;

   procedure nadd(xnote,xvol:longint);
   begin
   //range
   xnote:=frcrange32(xnote,0,127);
   xvol :=frcrange32(xvol ,0,127);
   //get
   tadd(t);
   case (xvol>=1) of
   true:xdata.aadd([$90,byte(xnote),byte(xvol)]);//note on
//   false:xdata.aadd([$90,byte(xnote),0]);//note off
   else xdata.aadd([$80,byte(xnote),64]);//note off
   end;//case
   end;

   procedure vadd(xvol:longint);
   begin
   //range
   xvol :=frcrange32(xvol ,0,127);
   //get
   tadd(t);
   xdata.aadd([$B0,$07,byte(xvol)]);//channel volume
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;
dtracklen:=0;

//check
if not str__lock(@xdata) then exit;

try
//init
xnoteshift:=0;
xdelayshift:=0;
xBPM:=1000;//120;
xdata.clear;
for p:=0 to high(xnotes) do xnotes[p]:=0;
xvol:=127;
xpos:=1;
lp:=1;
lp2:=1;
if (x<>'') then x:=x+#10;//enforce trailing return code
xlen:=low__len(x);
xonce:=true;
//check
if (xlen<=0) then goto skipend;

//get
xdata.aadd([uuM,uuT,llh,lld]);
xdata.aadd([0,0,0,6]);
xdata.aadd([0,0]);//format 0 - single track
xdata.aadd([0,1]);//track count = 1
a.val:=xBPM;
xdata.aadd([a.bytes[1],a.bytes[0]]);//timeDiv
xdata.aadd([uuM,uuT,llr,llk]);//start track
xdata.aadd([0,0,0,0]);//track length - fill with proper value later - 16mar2022
dtracklen:=xdata.len;//remember where to write track length

while true do
begin
//.next
if not xnext then break;

//.instrument
if (n='i') then
   begin
   iadd(v);
   if xonce then vadd(xvol);//full volume
   end
//.volume
else if (n='v') then xvol:=frcrange32(v,0,127)
//.note shift up/down
else if (n='s') then
   begin
   xnoteshift:=frcrange32(vint,-127,127);
   t:=0;
   end
//.delay shift up/down
else if (n='f') then
   begin
   xdelayshift:=vint;//percentage to increase or decrease timing delay by, 0=off, 100=add 100% more delay, -100=take away all delay
   t:=0;
   end
//.note on/off
else if (n='n') then
   begin
   v:=frcrange32(v+xnoteshift,0,127);//15nov2022
   xnotes[v]:=xvol;
   nadd(v,xvol);//note on OR off
   end
//.note off
else if (n='x') then
   begin
   v:=frcrange32(v+xnoteshift,0,127);//15nov2022
   xnotes[v]:=0;
   nadd(v,0);//note off
   end
//.fade down to zero
else if (n='d') then
   begin
   vbig:=frcmin32(vbig,5);
   for i:=20 downto 0 do
   begin
   t:=frcmin32(round(vbig/20),1);
   vadd(round(127*(i/20)));//on
   end;//i
   end
//.fade up from zero
else if (n='u') then
   begin
   vbig:=frcmin32(vbig,5);
   for i:=0 to 20 do
   begin
   t:=frcmin32(round(vbig/20),1);
   vadd(round(127*(i/20)));//on
   end;//i
   end
//.end
else if (n='e') then break;
end;
//.finalise -> turn off all active notes
for p:=0 to high(xnotes) do
begin
if (xnotes[p]>=1) then
   begin
//   nadd(p,1);
   nadd(p,0);//note off
   t:=0;//only require the time delay for the 1st note, all the others follow on immedately afterwards - 16mar2022
   end;
end;//p
//.write "end of track"
tadd(t);
xdata.aadd([$FF,$2F,$00]);

//successful
result:=true;
skipend:

//.write track len back into track header - 16mar2022
if ((xdata.len-dtracklen)>=1) then
   begin
   b.val:=xdata.len-dtracklen;
   xdata.byt1[dtracklen-4]:=b.bytes[3];
   xdata.byt1[dtracklen-3]:=b.bytes[2];
   xdata.byt1[dtracklen-2]:=b.bytes[1];
   xdata.byt1[dtracklen-1]:=b.bytes[0];
   end;
except;end;
try;str__uaf(@xdata);except;end;
end;

function low__txttomid(x,xtext:tstr8;var e:string):boolean;
label
   skipend;
const
   maxms=999999999;
   maxtick=(127*128*128*128) + (127*128*128) + (127*128) + 127;
   xtickrate=120;//120 beats per minute
   xtempo=500000;//default tempo is 500K uSEC
   xtempo_ms=500;
   //modes
   mnoteon=0;
   mnoteoff=1;
   mchannel=2;
   mvelocity=3;
   mdelay=4;
   mtrack=5;//optional
var
   a,aoutdata:tstr8;
   aout:array[0..255] of tstr8;
   aouttime:array[0..255] of longint;//reference only
   xtotaltime,xtrackcount,alen,p,xmode,xchannel,xvelocity,xdelay,xtrack:longint;
   byt1:byte;
   dval:array[0..19] of longint;//stores digits of a number e.g. "127" in order into the array to be constructed into a 32bit number once all digits have been read in - 18feb2021
   dcount:longint;

   procedure ainit2(xtrack:longint);
   begin//Note: "xtrack" is internal var, not current track - 18feb2021
   xtrack:=frcrange32(xtrack,0,high(aout));
   if zznil(aout[xtrack],4501) then aout[xtrack]:=str__new8;
   end;

   procedure ainit;
   begin
   ainit2(xtrack);
   end;

   procedure xdef;
   begin
   xmode:=mnoteon;
   xchannel:=0;
   xvelocity:=64;
   xdelay:=0;
   xtrack:=0;//0..255
   dcount:=0;
   end;

   procedure xadddelta(xtrack,xms:longint);
   var//Note: assumes "xtickrate" 96 ticks per quarter note (or 384 ticks / second / 1,000 ms)
      v1,v2,v3,v4,xticks:longint;
   begin
   try
   //range
   xtrack:=frcrange32(xtrack,0,high(aout));
   xms:=frcrange32(xms,0,maxms);
   //aouttime
   inc(aouttime[xtrack],xms);
   //convert
   //xticks:=frcrange32(round((xms/250)*xtickrate),0,maxtick);

   xticks:=trunc((xms*xtickrate)/frcmin32(xtempo_ms,1));
   //get
   //.v1
   v1:=xticks div (128*128*128);
   dec(xticks,v1*(128*128*128));
   //.v2
   v2:=xticks div (128*128);
   dec(xticks,v2*(128*128));
   //.v3
   v3:=xticks div 128;
   dec(xticks,v3*128);
   //.v4
   v4:=xticks;
   //set
   //.4b var-len
   if (v1>=1) then
      begin
      ainit2(xtrack);
      aout[xtrack].addbyt1(v1+128);//the 128 is to mark this as PART of the variable length number, only the last byte falls in the range 0..127 (never 128+)
      aout[xtrack].addbyt1(v2+128);
      aout[xtrack].addbyt1(v3+128);
      aout[xtrack].addbyt1(v4);
      end
   //.3b var-len
   else if (v2>=1) then
      begin
      ainit2(xtrack);
      aout[xtrack].addbyt1(v2+128);
      aout[xtrack].addbyt1(v3+128);
      aout[xtrack].addbyt1(v4);
      end
   //.2b var-len
   else if (v3>=1) then
      begin
      ainit2(xtrack);
      aout[xtrack].addbyt1(v3+128);
      aout[xtrack].addbyt1(v4);
      end
   //.1b var-len
   else
      begin
      ainit2(xtrack);
      aout[xtrack].addbyt1(v4);
      end;
   except;end;
   end;

   procedure xuseval;//if there is a value in the "dval" list then build it into a 32bit number and apply it to the current mode
   var
      vmultiplier,v,dc,p:longint;
   begin
   try
   //check
   if (dcount<=0) then exit;
   //get
   v:=0;
   vmultiplier:=1;
   dc:=0;
   for p:=(dcount-1) downto 0 do//read from right-to-left to convert into decimal, a maximum of 9 digits to be read so it never exceeds the 32bit number limit, e.g. largest number is "999,999,999"
   begin
   inc(v,dval[p]*vmultiplier);
   vmultiplier:=vmultiplier*10;//1 -> 10, 100, 1000, 10000, etc
   inc(dc);
   if (dc>=9) then break;//stop at this point -> else number MAY end up exceeding 32bit range of 2,100,000,000
   end;//p
   //set
   case xmode of
   mnoteon:begin//note on -> 3 bytes "9n note velocity"
      v:=frcrange32(v,0,127);
      ainit;
      xadddelta(xtrack,xdelay);//ms -> var-len delta ticks
      aout[xtrack].addbyt1($90+xchannel);//note on + channel -> $90..$9F (ch0..15)
      aout[xtrack].addbyt1(v);//note: 0..127
      aout[xtrack].addbyt1(xvelocity);//default for equipment without velocity sensors is 64, and ZERO (0) has special "note off" meaning for running status - 18feb2021
      end;
   mnoteoff:begin//note off -> 3 bytes "9n note velocity"
      v:=frcrange32(v,0,127);
      ainit;
      xadddelta(xtrack,xdelay);//ms -> var-len delta ticks
      aout[xtrack].addbyt1($80+xchannel);//note on + channel -> $90..$9F (ch0..15)
      aout[xtrack].addbyt1(v);//note: 0..127
      aout[xtrack].addbyt1(xvelocity);//default for equipment withou velocity sensors is 64
      end;
   mchannel:xchannel:=frcrange32(v,0,15);
   mvelocity:xvelocity:=frcrange32(v,0,127);
   mdelay:xdelay:=frcrange32(v,0,maxms);
   mtrack:xtrack:=frcrange32(v,0,high(aout));
   end;
   //clear
   dcount:=0;
   except;end;
   end;

   procedure xsetmode(x:byte);
   begin
   xuseval;
   xmode:=x;
   dcount:=0;
   end;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
a:=nil;
for p:=0 to high(aout) do
begin
aout[p]:=nil;
aouttime[p]:=0;
end;//p
aoutdata:=nil;
xtotaltime:=0;
//lock
str__lock(@x);
str__lock(@xtext);

//check
if zznil(x,4012) or zznil(xtext,4013) then goto skipend;

//init
a:=str__new8;
aoutdata:=str__new8;
x.clear;
alen:=xtext.len;
if (alen<=0) then goto skipend;

//filter
for p:=0 to (alen-1) do
begin
byt1:=xtext.byt1[p];
case byt1 of
lln,llo,llc,llv,lld,llt,nn0..nn9,ssDot,ssSpace:a.addbyt1(byt1);
uuN,uuO,uuC,uuV,uuD,uuT:a.addbyt1(byt1+vvUppertolower);//convert uppercase to lowercase
end;//case
end;
alen:=a.len;
if (alen<=0) then goto skipend;

//get
xdef;
for p:=0 to (alen-1) do
begin
byt1:=a.byt1[p];
case byt1 of
lln:xsetmode(mnoteon);//note on
llo:xsetmode(mnoteoff);//note off
llc:xsetmode(mchannel);//channel
llv:xsetmode(mvelocity);//velocity
lld:xsetmode(mdelay);//delay
llt:xsetmode(mtrack);//track
nn0..nn9:begin//value
   if (dcount<=high(dval)) then
      begin
      dval[dcount]:=byt1-nn0;//0..9
      inc(dcount);
      end;
   end;
ssSpace:xuseval;
ssDot:begin//end of midi
   xuseval;
   break;
   end;
end;//case
end;//p
//.finalise
xuseval;

//set - build midi file
//.write tracks
xtrackcount:=0;
for p:=0 to high(aout) do if zzok(aout[p],4502) and (aout[p].len>=1) then
   begin
   inc(xtrackcount);
   //time - reference only
   if (aouttime[p]>xtotaltime) then xtotaltime:=aouttime[p];
   //insert EOT -> end of track -> <delatticks> + "FF 2F 00" -> uses current delay so notes can finishing playing if track hasn't been finished off properly - 18feb2021
   xadddelta(p,xdelay);
   aout[p].addbyt1($FF);
   aout[p].addbyt1($2F);
   aout[p].addbyt1($00);
   //track header
   aoutdata.aadd([uuM,uuT,llr,llk]);
   //track length
   aoutdata.addint4R(aout[p].len);
   //track data
   aoutdata.add(aout[p]);
   end;
//.write midi header
x.aadd([uuM,uuT,llh,lld]);
//.32bit number check.4R
x.addint4R(6);
//.write formattype.2R + trackcount.2R + tickrate.2R
x.addwrd2R(low__insint(1,xtrackcount>=2));//0=single track, 1=multi-track, 2=we don't support
x.addwrd2R(xtrackcount);
x.addwrd2R(xtickrate);//for us we use ticks always for simplicity
//.write all tracks data
x.add(aoutdata);
//successful
result:=true;
skipend:
except;end;
try;if (not result) and zzok(x,4503) then x.clear;except;end;
try
str__free(@a);
str__free(@aoutdata);
for p:=0 to high(aout) do str__free(@aout[p]);
str__uaf(@x);
str__uaf(@xtext);
except;end;
end;

function low__midcount(x:tstr8):longint;
begin
result:=0;
if zzok(x,4504) then result:=x.len div 12;
if (x<>nil) then str__af(@x);
end;

function low__midbytes(x:tstr8):longint;
begin
result:=0;
if zzok(x,4505) then result:=x.len;
if (x<>nil) then str__af(@x);
end;

function low__midtime(x:tstr8):longint;
var
   i:longint;
   xmsg,xval1,xval2,xval3:byte;
   xtimeuSEC:comp;
begin
result:=0;

try
if str__lock(@x) then
   begin
   i:=low__midcount(x);
   if (i>=1) then
      begin
      low__midget(x,i-1,xtimeuSEC,xmsg,xval1,xval2,xval3);
      //was:   result:=trunc(xtimeuSEC/1000.0);
      result:=div32(xtimeuSEC,1000);
      end;
   end;
except;end;
try;str__uaf(@x);except;end;
end;

function low__midget(x:tstr8;xindex:longint;var xtimeuSEC:comp;var xmsg,xval1,xval2,xval3:byte):boolean;
var
   xpos:longint;
   a:tint4;
begin

//defaults
result:=false;
xtimeuSEC:=0;
xmsg :=0;
xval1:=0;
xval2:=0;
xval3:=0;

try

//init
if (xindex<0) then xpos:=0 else xpos:=xindex*12;

//get
if zzok(x,4506) and (xpos>=0) and ((xpos+11)<x.len) then
   begin
   xtimeuSEC:=x.cmp8[xpos+0];
   a.val:=x.int4[xpos+8];
   xmsg :=a.bytes[0];
   xval1:=a.bytes[1];
   xval2:=a.bytes[2];
   xval3:=a.bytes[3];
   result:=true;
   end;

except;end;

//free
if (x<>nil) then str__af(@x);

end;

function low__midset(x:tstr8;xindex:longint;xtimeuSEC:comp;xmsg,xval1,xval2,xval3:byte):boolean;
var
   xpos:longint;
   a:tint4;
begin
//defaults
result:=false;

try
//init
if (xindex<0) then xpos:=0 else xpos:=xindex*12;
//get
if zzok(x,4507) then
   begin
   //init
   a.bytes[0]:=xmsg;
   a.bytes[1]:=xval1;
   a.bytes[2]:=xval2;
   a.bytes[3]:=xval3;
   //get
   x.cmp8[xpos+0]:=xtimeuSEC;
   x.int4[xpos+8]:=a.val;
   result:=true;
   end;
except;end;
try;if (x<>nil) then str__af(@x);except;end;
end;

function low__midadd(x:tstr8;xtimeuSEC:comp;xmsg,xval1,xval2,xval3:byte):boolean;
begin
result:=low__midset(x,low__midcount(x),xtimeuSEC,xmsg,xval1,xval2,xval3);
end;


//## tbasicmidi ################################################################
procedure mid__timeusec__add(var xtimeuSEC:comp;xtempo,xtimediv,xmultipler:longint);//22nov2024
begin
try;if (xtimediv<>0) and (xmultipler<>0) then xtimeuSEC:=xtimeuSEC+((xtempo/xtimediv)*xmultipler);except;end;
end;

constructor tbasicmidi.create;
var
   p:longint;
begin
try

//self
inherited create;
if classnameis('tbasicmidi') then track__inc(satMidi,1);

//init to run under Windows 98 - 13sep2025, 04sep2025
xpatch__windows98;

//internal
itimer         :=nil;
imidlistref    :='';//02nov2025
oautostop      :=false;//22feb2022
otrimtolastnote:=false;//11jan2025
itimereventbusy:=false;
ithreadignore  :=false;
ihalt          :=false;//triggers internal halt of playback for a safe shutdown - 10aug2025
idatarate      :=0;
iresetvol      :=0;
itimer100      :=ms64;
itimer1000     :=ms64;
itimerreset24hr:=0;
iretrytimer    :=0;
imustplaydata  :=false;
imustplayfile  :=false;
iitemsid       :=0;
ivol           :=100;
ivol2          :=100;//03mar2022
inewvol        :=-1;//off - 03mar2022
inewvol2       :=-1;//off
ichangedidB    :=0;
low__cls(@ihandlelist,sizeof(ihandlelist));
ipos64         :=ms64;//high speed millisecond counter
ipos           :=0;
ilen           :=0;
ilenfull       :=0;
ibytes         :=0;//memory in use
imidbytes      :=0;//size of mid file
imidformat     :=0;
imidtracks     :=0;
imustopen      :=0;
imuststop      :=false;
imustplay      :=false;
iplaying       :=false;
inewstyle      :=-1;
inewpos        :=-1;
inewpertpos    :=-1;
inewspeed      :=-1;
inewspeed2     :=-1;
inewtranspose  :=min32;
inewdeviceindex:=min32;//off
ideviceindex   :=mmsys_mid_midimapper;//midi mapper -> midi inside a thread show no volumne control!!!!!!!
ilastdeviceindex:=min32+1;          
idisablenotes  :=false;
ikeepopen      :=false;
iloop          :=false;
itranspose     :=0;//0=normal, range=-127..0..127
ispeed         :=100;//100=normal speed
ispeed2        :=100;//100=normal speed - an internal/behind the scenes version that works in tandum with "speed"
ilastspeed     :=ispeed;
ilastspeed2    :=ispeed2;
istyle         :=0;//GM
iid            :=0;
ilastid        :=-1;
iopenref       :=ms64;

for p:=0 to high(ilistdata) do ilistdata[p]:=nil;

ilyrics                :=str__new8;//24feb2022
ilyrics.floatsize      :=30000;
ilyricsref             :=str__new8;
ilyricsref.floatsize   :=30000;
flush;

xmustreset24hr(true);


//external init
idata         :=str__new8;//used for delayed "open" caching of user midi data
idata2        :=str__new8;//used for delayed "open" caching of user midi data
ifilename     :='';

//defaults
resetItems;

//timer
low__timerset(self,__ontimer,20);//faster response time - 16mar2022

//thread timer
itimer:=tbasictimer2.create(__createOutsideThread,__timerThread,__destroyOutsideThread,__procThread2);

except;end;
end;

destructor tbasicmidi.destroy;//02sep2025, 02mar2022
var
   p:longint;
begin
try

//stop
itimer.halt;

//timer
low__timerdel(self,__ontimer);//disconnect our timer event from the system timer

//thread timer
freeobj(@itimer);

//vars
iplaying :=false;
ilen     :=0;
ilenfull :=0;
//close;

//was here: systhread__stop(isysthreadSLOT);
//controls
for p:=0 to high(ilistdata) do freeobj(@ilistdata[p]);

str__free(@ilyrics);//24feb2022
str__free(@ilyricsref);
str__free(@idata);
str__free(@idata2);

if classnameis('tbasicmidi') then track__inc(satMidi,-1);

//self
inherited destroy;
except;end;
end;

function tbasicmidi.xmustreset24hr(xreset:boolean):boolean;//reset the midi hardware (e.g. disconnect and reconnect) every 24 hours to maintain stability and prevent memory runaway on some OS/hardware combinations, namely Win98/Vista/7 and 8/8.1 - 23oct2025
begin

result:=(ms64>=itimerreset24hr);
if xreset then itimerreset24hr:=add64(ms64,24*60*60*1000);//24 hours

end;

function tbasicmidi.xdevicelistHasChanged(xreset:boolean):boolean;
var
   bol1:boolean;
begin

//.also detect when midi device list has changed - 02nov2025
bol1:=(imidlistref<>'');//allow reset but no trigger when initial value is "empty"
result:=mid_devicelistHasChanged(imidlistref,xreset) and bol1;

end;

function tbasicmidi.check24hr:boolean;
begin

//.close-and-reopen all in-use midi devices every 24 hours to maintain stability - 23oct2025
result:=xmustreset24hr(false);
if result and (handlecount>=1) then xcallproc2(bmaReopen);

end;

procedure tbasicmidi.xpatch__windows98;//13sep2025, 04sep2025
var
   h:longint;
begin

//-- Technical Workaround for Window 98 ----------------------------------------
//Note: Under Windows 98, a call to "midioutopen()" from within a thread can fail,
//      and attempting to call it in the app's main thread after starting a worker
//      thread causes app to lockup.  Solution: Make a call to midiOutOpen() here,
//      before starting the "itimer" worker thread.
//Note: Under Windows 11, this proc causes a fatal error when computer wakes from
//      sleep or hibernation when used with device id of "-1" (midi mapper), but works
//      fine with device id "0", and retains patch functionality for Windows 98 - 13sep2025

try

//check -> no midi devices -> ignore
if (mid_devicecount<=0) then exit;

//get
h:=0;
//was: win____midiOutOpen(@h,-1,0,0,0); -> WARNING: The "-1" for midi_mapper causes a FATAL error on computer wake from sleep or hibernation under Windows 11 - 13sep2025
win____midiOutOpen(@h,0,0,0,0);//OK for Win98 and Win11 - 13sep2025
win____midiOutClose(h);

except;end;
end;

procedure tbasicmidi.enter1;
begin
if (itimer<>nil) then itimer.enter1;
end;

procedure tbasicmidi.leave1;
begin
if (itimer<>nil) then itimer.leave1;
end;

function tbasicmidi.timercode:longint;
begin

result:=itimer.errorcode;

if (result=0) then
   begin

   if      (itimer.msrate>=10) then result:=5
   else if (itimer.msrate>=5)  then result:=4;

   end;

end;

function tbasicmidi.gethandle:longint;//first active handle
var
   p:longint;
begin

result:=0;
for p:=0 to high(ihandlelist) do if (ihandlelist[p].handle<>0) then
   begin

   result:=ihandlelist[p].handle;
   break;

   end;

end;

function tbasicmidi.timermsg:string;
begin

case timercode of
0..3:result:=itimer.errormsg;
4   :result:='Mild Lag';//06nov2025
5   :result:='High Lag';
end;//case

end;

procedure tbasicmidi.__createOutsideThread(x:tobject);
begin

end;

procedure tbasicmidi.__destroyOutsideThread(x:tobject);
begin

__resetvols;
__closehandles;

end;

procedure tbasicmidi.__timerThread(x:tobject);
begin

//play notes
if iplaying and (not ihalt) then
   begin
   //was: moretime; <- not thread safe, uses ms64 high res. version - 21feb2022
   syncpos;//required
   __pdo;//2(true);
   end;

end;

procedure tbasicmidi.xcallproc2(const xcode:longint);//13sep2025
begin

//use app thread for multimedia io -> midioutopen/midioutclose etc
//note: no need to wait for thread.proc0 to be idle as we're not using it ",false);" - 13sep2025
itimer.waitforproc2(basNoThread,xcode,false);

end;

function tbasicmidi.__procThread2(x:tobject;const xcode:longint;var xreplycode:longint;const xWithinThread:boolean):boolean;
begin

//pass-thru
result:=true;

case xcode of

bmaReopen:begin
   if canclose then __closehandles;
   __autoopen;
   end;

bmaClose     :__closehandles;
bmaOpen      :__open;
bmaAutoopen  :__autoopen;
bmaResetvols :__resetvols;
bmaPdo       :__pdo;
bmaTest      :;
end;//case

end;

function tbasicmidi.itemcount:longint;
begin
result:=1+high(ihandlelist);
end;

procedure tbasicmidi.resetItems;
var
   p:longint;
begin

for p:=0 to high(ihandlelist) do resetItem(p);

end;

procedure tbasicmidi.resetItem(xindex:longint);
var
   x:tmidiitem;
   p:longint;
begin

//init
low__cls(@x,sizeof(x));

//get
x.ms  :=0;
x.vol :=100;
for p:=0 to high(x.ch) do x.ch[p]:=true;

//set
setitem(xindex,x);

end;

procedure tbasicmidi.setitem(xindex:longint;const xitem:tmidiitem);
var
   xchanged:boolean;
   p:longint;
begin

//range
xindex    :=frcrange32(xindex,0,high(ihandlelist));

//init
xchanged  :=false;

//get
if (itimer<>nil) then itimer.enter1;
if low__setint(ihandlelist[xindex].ms    ,frcrange32(xitem.ms,-500,500)) then xchanged:=true;
if low__setint(ihandlelist[xindex].vol   ,frcrange32(xitem.vol,0,200))   then xchanged:=true;

for p:=0 to high(xitem.ch) do if low__setbol(ihandlelist[xindex].ch[p],xitem.ch[p]) then xchanged:=true;

if (itimer<>nil) then itimer.leave1;

//set
if xchanged then low__irollone(iitemsid);

end;

function tbasicmidi.getitem(xindex:longint):tmidiitem;
begin

//range
xindex:=frcrange32(xindex,0,high(ihandlelist));

//get
result:=ihandlelist[xindex];

end;

function tbasicmidi.getitemsettings(xindex:longint):string;
var
   p:longint;
begin

//range
xindex:=frcrange32(xindex,0,high(ihandlelist));

//get
result:=intstr32(ihandlelist[xindex].vol)+';'+intstr32(ihandlelist[xindex].ms)+';';
for p:=0 to high(ihandlelist[xindex].ch) do result:=result+bolstr(ihandlelist[xindex].ch[p]);
result:=result+';';

end;

procedure tbasicmidi.setitemsettings(xindex:longint;xdata:string);
var
   p2,c,lp,p:longint;
   x:tmidiitem;
   v:string;
begin

//range
xindex:=frcrange32(xindex,0,high(ihandlelist));

//init
low__cls(@x,sizeof(x));
x.vol:=100;
for p:=0 to high(x.ch) do x.ch[p]:=true;
xdata:=xdata+';';//enforce trailing comma

//get
c   :=0;
lp  :=1;

for p:=1 to low__len(xdata) do if (xdata[p-1+stroffset]=';') then
   begin

   //get
   inc(c);
   v:=strcopy1(xdata,lp,p-lp);

   case c of
   1:begin
      if (v='') then v:='100';
      x.vol :=strint32(v);
      end;
   2:x.ms   :=strint32(v);
   3:begin

      for p2:=1 to low__len(v) do
      begin

      case (pred(p2)<=high(x.ch)) of
      true:x.ch[p2-1]:=strbol(v[p2-1+stroffset]);
      else break;
      end;//case

      end;//p2

      break;
      end;
   end;//case

   //inc
   lp:=p+1;

   end;

//set
setitem(xindex,x);

end;

procedure tbasicmidi.__autoopen;
begin
if (ikeepopen or iplaying) and canopen then __open;
end;

procedure tbasicmidi.__open;//10aug2025
begin

moretime;
__openhandles;
__resetvols;
moretime;

end;

procedure tbasicmidi.__openhandles;//thread enabled via COM start procs - 14sep2025, 31aug2025, 20aug2025
var
   p:longint;
   xbroadcasting:boolean;
begin
try

//retry delay
if (not low__setint(ilastdeviceindex,ideviceindex)) and (iretrytimer>=ms64) then exit;

//broadcast mode
xbroadcasting:=false;

if (ideviceindex=mmsys_mid_broadcast) then for p:=0 to frcmax32( mid_outdevicecount-1, high(ihandlelist) ) do//does not use midi mapper
   begin

   midioutopen(@ihandlelist[p].handle,p,0,0,callback_null);
   if (ihandlelist[p].handle<>0) then xbroadcasting:=true;

   end;

//default to one device only
if not xbroadcasting then
   begin

   midioutopen(@ihandlelist[0].handle,frcmin32(ideviceindex,mmsys_mid_midimapper),0,0,callback_null);

   end;

//retry timer
if (handlecount<=0) then iretrytimer:=add64(ms64,5000);

except;end;
end;

procedure tbasicmidi.__closehandles;
var
   p:longint;
begin

for p:=0 to high(ihandlelist) do if (ihandlelist[p].handle<>0) then
   begin

   //stop notes
   win____midioutreset(ihandlelist[p].handle);

   //close
   midiOutClose(ihandlelist[p].handle);

   //reset
   ihandlelist[p].handle :=0;

   end;//p


//reset the timer
xmustreset24hr(true);

end;

procedure tbasicmidi.__resetvols;
var
   p:longint;
begin

iresetvol:=20;//hush playback of notes for first Xms so a gradual fade-in of full volume can be achieved
for p:=0 to high(ihandlelist) do if (ihandlelist[p].handle<>0) then midioutflush(ihandlelist[p].handle);

end;

procedure tbasicmidi.__pdo;//16sep2025
label//Special Note: iresetvol allows for a gentle fading in to full volume and avoids any sudden loud notes - 11aug2025, 21feb2022
   redo, skipend;
var
   xbroadcasting,bol1:boolean;
   xchannel,xdeviceToTrack,xdevicefrom,xdeviceto,dhandlecount,xhandle,xtrack,int1,xsysvol,rvol,xmaxp,xsongms32,xtimems32,p:longint;
   xmsg,xnote,xrawvol,xvol,xvolUNMUTED,xval3:byte;
   dsysvol:array[0..high(tmidilist)] of byte;
   xout:tint4;
   v64:comp;

   procedure xtracknote(const xtrack:longint;const xchannel,xnote,xvol,xvolOUT,xvolOUTUNMUTED:byte);
   const
      xdelay  =40;
      xoneday =24*60*60*1000;
   begin

   //range check
   if (xtrack<0) or (xtrack>high(mmsys_mid_tracking.trackid)) or (xchannel>15) or (xnote>127) then exit;

   //increment id counters
   low__irollone(mmsys_mid_tracking.trackid[xtrack]);
   low__irollone(mmsys_mid_tracking.channelid[xchannel]);
   low__irollone(mmsys_mid_tracking.noteid[xnote]);
   low__irollone(mmsys_mid_tracking.id);

   //muted
   mmsys_mid_tracking.channels[xchannel].notes[xnote].muted          :=mmsys_mid_mutetrack[xtrack] or (mmsys_mid_chvol[xchannel]<=0) or mmsys_mid_mutenote[xnote];
   mmsys_mid_tracking.channels[xchannel].notes[xnote].mutedByTrack   :=mmsys_mid_mutetrack[xtrack];
   mmsys_mid_tracking.channels[xchannel].notes[xnote].mutedByChannel :=(mmsys_mid_chvol[xchannel]<=0);
   mmsys_mid_tracking.channels[xchannel].notes[xnote].mutedByNote    :=mmsys_mid_mutenote[xnote];

   //track
   mmsys_mid_tracking.tracks[xtrack].time                            :=add64(v64,xdelay);


   //vol -----------------------------------------------------------------------

   //on
   if (xvol>=1) then
      begin

      case (xchannel=9) of
      true:mmsys_mid_tracking.channels[xchannel].notes[xnote].timeRAW :=add64(v64,xdelay);//short delay for drum channel
      else mmsys_mid_tracking.channels[xchannel].notes[xnote].timeRAW :=add64(v64,xoneday);
      end;//case

      mmsys_mid_tracking.channels[xchannel].notes[xnote].volRAW:=xvol;

      end
   //off
   else
      begin

      //if time still active, trim down to "xdelay" for a short trailing delay
      if (sub32(mmsys_mid_tracking.channels[xchannel].notes[xnote].timeRAW,v64)>xdelay) then mmsys_mid_tracking.channels[xchannel].notes[xnote].timeRAW :=add64(v64,xdelay);
      end;


   //volOUT --------------------------------------------------------------------

   //on
   if (xvolOUT>=1) then
      begin

      case (xchannel=9) of
      true:mmsys_mid_tracking.channels[xchannel].notes[xnote].timeOUT :=add64(v64,xdelay);//short delay for drum channel
      else mmsys_mid_tracking.channels[xchannel].notes[xnote].timeOUT :=add64(v64,xoneday);
      end;//case

      mmsys_mid_tracking.channels[xchannel].notes[xnote].volOUT:=xvolOUT;

      end
   //off
   else
      begin

      //if time still active, trim down to "xdelay" for a short trailing delay
      if (sub32(mmsys_mid_tracking.channels[xchannel].notes[xnote].timeOUT,v64)>xdelay) then mmsys_mid_tracking.channels[xchannel].notes[xnote].timeOUT :=add64(v64,xdelay);
      end;

      
   //volOUTUNMUTED -------------------------------------------------------------

   //on
   if (xvolOUTUNMUTED>=1) then
      begin

      case (xchannel=9) of
      true:mmsys_mid_tracking.channels[xchannel].notes[xnote].timeOUTUNMUTED :=add64(v64,xdelay);//short delay for drum channel
      else mmsys_mid_tracking.channels[xchannel].notes[xnote].timeOUTUNMUTED :=add64(v64,xoneday);
      end;//case

      mmsys_mid_tracking.channels[xchannel].notes[xnote].volOUTUNMUTED:=xvolOUTUNMUTED;

      end
   //off
   else
      begin

      //if time still active, trim down to "xdelay" for a short trailing delay
      if (sub32(mmsys_mid_tracking.channels[xchannel].notes[xnote].timeOUTUNMUTED,v64)>xdelay) then mmsys_mid_tracking.channels[xchannel].notes[xnote].timeOUTUNMUTED :=add64(v64,xdelay);
      end;

   end;

begin
try

//check
if ihalt or (ilistlimit<=0) then exit;

//broadcast mode
xbroadcasting:=(ideviceindex=mmsys_mid_broadcast);
if xbroadcasting then
   begin

   xdevicefrom :=0;
   xdeviceto   :=high(tmidilist);

   end
else
   begin

   xdevicefrom :=0;
   xdeviceto   :=0;

   end;

//require atleast one active handle
dhandlecount     :=0;
xdeviceToTrack   :=-1;

for p:=xdevicefrom to xdeviceto do if (ihandlelist[p].handle<>0) then
   begin
   inc(dhandlecount);
   if (xdeviceToTrack<0) then xdeviceToTrack:=p;
   end;

if (dhandlecount<=0) then exit;

//range
xmaxp:=ilistlimit-1;
if (xmaxp>high(ilistdata)) then xmaxp:=high(ilistdata);

//reset vol -> gently fade volume back up to 100% after a "resetvols" - 21feb2022
rvol:=iresetvol;
if (rvol<0) then rvol:=0 else if (rvol>100) then rvol:=100;

//.vol -> 3 separate volume levels generate a final, single volume level - 23mar2022
int1:=mmsys_mid_basevol;
if (int1<0) then int1:=0 else if (int1>200) then int1:=200;

xsysvol:=(ivol*ivol2*int1) div 10000;//note: close to 32bit upper math limit
if (xsysvol>200) then xsysvol:=200;

for p:=xdevicefrom to xdeviceto do
begin

case xbroadcasting of
true:dsysvol[p]:=frcrange32(trunc( xsysvol * (ihandlelist[p].vol/100) ),0,200);
else dsysvol[p]:=xsysvol;
end;//case

end;//p

//init
//was: xsonguSEC:=trunc(ipos*1000.0);//current song position in "ms" -> "uSEC"
xsongms32 :=ipos;
v64       :=ms64;


//get
for p:=0 to xmaxp do
begin


for xhandle:=xdevicefrom to xdeviceto do if (ihandlelist[xhandle].handle<>0) then
begin

redo:
if (ilistcount[p]>=1) and (ilistpos[xhandle][p]<ilistcount[p]) and get(p,ilistpos[xhandle][p],xtimems32,xmsg,xnote,xvol,xval3) then
   begin

   //ms adjustment
   if (ihandlelist[xhandle].ms<>0) then xtimems32:=xtimems32+ihandlelist[xhandle].ms;

   //get
   if (xtimems32<xsongms32) or ((not idisablenotes) and (xtimems32<=xsongms32)) then
      begin

      //init
      xrawvol        :=xvol;//for reference
      xvolUNMUTED    :=xvol;

      //inc
      inc(ilistpos[xhandle][p]);

      //disable notes
      if idisablenotes and (xmsg>=$80) and (xmsg<=$9F) then goto redo;//skip over all NOTE ON and NOTE OFF msgs

      //xchannel
      case xmsg of
      $80..$8F:xchannel:=xmsg-$80;
      $90..$9F:xchannel:=xmsg-$90;
      else     xchannel:=-1;
      end;

      //adjust volume for notes only
      if (xchannel>=0) then
         begin

         if (xvol>=1) and ( (dsysvol[xhandle]<>100) or (rvol<>100) or (mmsys_mid_chvol[xchannel]<>100) ) then
            begin

            //apply volume change
            xvol        :=byte(frcrange32( trunc( longint(xvol) * (dsysvol[xhandle]/100) * (rvol/100) * (low__posn(mmsys_mid_chvol[xchannel])/100) ) ,1,127));
            xvolUNMUTED :=xvol;

            //mute
            if (mmsys_mid_chvol[xchannel]<=0) then xvol:=0;

            end;

         end;

      //midi state changed
      low__irollone(mmsys_mid_ref);

      //ehanced features
      if mmsys_mid_enhanced then
         begin

         //track index
         if (imidformat=1) then xtrack:=frcrange32(p-1,0,high(mmsys_mid_mutetrack)) else xtrack:=frcrange32(p,0,high(mmsys_mid_mutetrack));

         //transpose - 14feb2025
         if (itranspose<>0) then
            begin

            case xmsg of
            $80..$8F,$90..$9F,$A0..$AF:xnote:=frcrange32( longint(xnote)+itranspose ,0,127);
            end;//case

            end;

         //optional track, channel and note mutes - 08feb2025, 09jan2025
         case xmsg of

         $80..$8F:begin//note off

            //note volume
            if mmsys_mid_mutetrack[xtrack] or mmsys_mid_mutenote[xnote] or (xbroadcasting and (not ihandlelist[xhandle].ch[xmsg-$80])) then xvol:=0;

            //track note with beat extender - 03sep2025
            if (xhandle=xdeviceToTrack) then xtracknote(xtrack,xmsg-$80,xnote,0,0,0);

            //status
            low__irollone(mmsys_mid_notesref);

            end;

         $90..$9F:begin//note on

            //note volume
            if mmsys_mid_mutetrack[xtrack] or mmsys_mid_mutenote[xnote] or (xbroadcasting and (not ihandlelist[xhandle].ch[xmsg-$90])) then xvol:=0;

            //track note with beat extender - 03sep2025
            if (xhandle=xdeviceToTrack) then xtracknote(xtrack,xmsg-$90,xnote,xrawvol,xvol,xvolUNMUTED);

            //status
            low__irollone(mmsys_mid_notesref);

            end;

         $C0..$CF:begin//program change -> e.g.voice/instrument change on midi channel N - 20aug2025

            mmsys_mid_voiceindex[xmsg-$C0]:=frcrange32(xnote,0,127);

            end;
         end;//case

         end;//if

      //use global buffer for maximum stability
      xout.bytes[0]:=xmsg;
      xout.bytes[1]:=xnote;
      xout.bytes[2]:=xvol;
      xout.bytes[3]:=xval3;

      //send message to midi device(s)
      if (0<>win____MidiOutShortMsg(ihandlelist[xhandle].handle,xout.val)) then goto skipend;//break on error - 18apr2021

      low__irollone(mmsys_mid_msgoutcount);

      //loop
      goto redo;
      end;

   end;

end;//xhandle

end;//p

skipend:

except;end;
end;

function tbasicmidi.msrate:double;//15aug2025
begin
result:=itimer.msrate;
end;

function tbasicmidi.mspert100:double;//15aug2025
begin
result:=itimer.mspert100;
end;

function tbasicmidi.pcount:longint;//15aug2025
begin
result:=itimer.pcount;
end;

function tbasicmidi.halted:boolean;//10aug2025
var
   p:longint;
begin

result:=ihalt and (not iplaying);

if result then for p:=0 to high(ihandlelist) do if (ihandlelist[p].handle<>0) then
   begin

   result:=false;
   break;

   end;

end;

function tbasicmidi.halt:boolean;
begin
result:=true;//pass-thru
ihalt :=true;
end;

function tbasicmidi.usingtimer:boolean;
begin
result:=true;
end;

procedure tbasicmidi.setvol(x:longint);
begin
inewvol:=frcrange32(x,0,200);
end;

procedure tbasicmidi.setvol2(x:longint);
begin
inewvol2:=frcrange32(x,0,200);
end;

procedure tbasicmidi.setstyle(x:longint);
begin
inewstyle:=frcrange32(x,0,3);
end;

procedure tbasicmidi.setdeviceindex(x:longint);
begin//new range: -2..N
inewdeviceindex:=mid_SafeDeviceIndexRange(x);
end;

function tbasicmidi.getpos:longint;
begin
result:=frcrange32(ipos,0,ilen);
end;

function tbasicmidi.getpertpos:double;
begin
result:=low__makepertD0(ipos,ilen);
end;

function tbasicmidi.gettranspose:longint;
begin
if (inewtranspose<>min32) then result:=inewtranspose else result:=itranspose;
end;

procedure tbasicmidi.__ontimer(sender:tobject);//._ontimer
label
   doclosing,skipend,redo;
var
   e:string;
   int1,int2,int3:longint;
   bol1:boolean;

   procedure xpause;//special note: stops the high-speed timer from playing notes permitting a gentle note reset/volume reset/open etc - 21feb2022
   begin

   //check - already locked
   if ithreadignore then exit else ithreadignore:=true;

   //stop thread timer
   itimer.stop;

   end;

begin
try

//lock
if itimereventbusy then exit else itimereventbusy:=true;


//slow -------------------------------------------------------------------------
//.itimer100
if (ms64>itimer100) or ihalt then
   begin

   //ihalt
   if ihalt then goto doclosing;

   //iresetvol
   if (iresetvol<100) then iresetvol:=frcrange32(iresetvol+25,0,100);

   //external support
   if imustplayfile then
      begin

      imustplayfile:=false;

      //open
      xpause;
      moretime;
      if not io__fromfile(ifilename,@idata,e) then idata.clear;
      xplaydata2(otrimtolastnote);

      //play
      moretime;
      setpos(0);
      syncpos;
      restart;//does a "xresetvols"
//      iresetvol:=100;//start at full power at beginning of track - 22feb2022
      moretime;
      imustplay:=true;
      imustopen:=0;//do AFTER xopen has fired -> syncs with "canopen" and "open()" procs - 14feb2021

      //realtime support - 25mar2022
      app__realtime;

      end;

   //external support
   if imustplaydata then
      begin

      imustplaydata:=false;

      //open
      xpause;
      moretime;

      //.idata2 -> idata
      idata.clear;
      idata.add(idata2);
      idata2.clear;
      xplaydata2(otrimtolastnote);

      //play
      moretime;
      setpos(0);
      syncpos;
      restart;//does a "xresetvols"
//      iresetvol:=100;//start at full power at beginning of track - 22feb2022
      moretime;
      imustplay:=true;
      imustopen:=0;//do AFTER xopen has fired -> syncs with "canopen" and "open()" procs - 14feb2021

      //realtime support - 25mar2022
      app__realtime;

      end;

   //inc pos
   if iplaying and (ilen>=1) and canclose then
      begin
      syncpos;
      end;

   //! Important ! -> Open midi stream only when we have a "thread.synchonized" timer event,
   //                 all thread.non-synchronized timer events only read tstr8 data and thus do
   //                 not need to sync critical pointer/object data and handles with the
   //                 system or our debug tracking system when processing new data or resizing
   //                 existing data - 06may2021
   //mustopen
   if (imustopen>=2) then
      begin

      xpause;
      moretime;
      xplaydata2(otrimtolastnote);
      setpos(0);
      syncpos;
      restart;//does a "xresetvols"
      moretime;

      case imustopen of
      2:;//open only
      3:imustplay:=true;
      end;//case

      imustopen:=0;//do AFTER xopen has fired -> syncs with "canopen" and "open()" procs - 14feb2021

      //realtime support - 25mar2022
      app__realtime;

      end;

   //newspeed
   if (inewspeed>=0) or (inewspeed2>=0) then
      begin

      xpause;

      int1:=ipos;
      if (inewspeed>=0)  then int2:=frcrange32(inewspeed ,10,1000) else int2:=ispeed;
      if (inewspeed2>=0) then int3:=frcrange32(inewspeed2,10,1000) else int3:=ispeed2;//03mar2022
      inewspeed:=-1;//off
      inewspeed2:=-1;//off

      if (ispeed<>int2) or (ispeed2<>int3) then
         begin
         ispeed:=int2;
         ispeed2:=int3;
         setpos(frcrange32(int1,0,ilen));
         syncpos;
         restart;
         end;

      end;

   //newtranspose (off=min32, range=-127..0..127)
   if (inewtranspose<>min32) then
      begin

      //pause thread
      xpause;

      //get
      if low__setint(itranspose,frcrange32(inewtranspose,-127,127)) then restart;//only required if something critical in playback has changed - 14feb2025

      //reset
      inewtranspose:=min32;//off

      end;

   //newpertpos - 06mar2022
   if (inewpertpos>=0) then
      begin

//was:      inewpos:=frcrange32(round(ilen*inewpertpos) div 100,0,frcmin32(ilen-1,0));
      inewpos:=frcrange32( restrict32( div64( mult64(ilen,inewpertpos) ,100) ) ,0,frcmin32(ilen-1,0));//now able to handle massive range for midi's with bad timing errors - 22nov2024
      inewpertpos:=-1;//off

      end;

   //newpos
   if (inewpos>=0) or (inewstyle>=0) or (inewdeviceindex<>min32) then
      begin

      //init
      xpause;
      bol1:=false;

      //pos
      int1:=inewpos;
      inewpos:=-1;//off
      if (int1>=0) and (ipos<>int1) then
         begin
         setpos(frcrange32(int1,0,ilen));
         syncpos;
         bol1:=true;
         end;

      //style
      int1:=inewstyle;
      inewstyle:=-1;
      if (int1>=0) and (istyle<>int1) then
         begin
         istyle:=int1;
         bol1:=true;
         end;

      //deviceindex
      int1:=inewdeviceindex;
      inewdeviceindex:=min32;//off

      if (int1>=low(mmsys_mid_deviceok)) and (ideviceindex<>int1) then
         begin

         ideviceindex:=int1;

         xcallproc2(bmaReopen);

         setpos(frcrange32(ipos,0,ilen));//tell system to cycle through to this point - 18apr2021
         bol1:=true;

         end;

      //restart
      if bol1 then restart;

      end;

   //muststop
doclosing:
   if imuststop or ihalt then
      begin

      xpause;
      imuststop:=false;
      iplaying:=false;

      xcallproc2(bmaResetvols);

      end;

   //mustplay
   if imustplay and (not ihalt) then
      begin

      xpause;

      imustplay:=false;
      iplaying:=true;
      moretime;

      //.close-and-reopen all in-use midi devices every 24 hours to maintain stability - 23oct2025
      case xmustreset24hr(false) of
      true:xcallproc2(bmaReopen);
      else xcallproc2(bmaAutoopen);
      end;//case

      setpos(frcrange32(ipos,0,ilen));
      restart;

      end;


   //newvol - 03mar2022
   if (inewvol>=0) then
      begin

      ivol:=frcrange32(inewvol,0,200);
      inewvol:=-1;

      end;

   //newvol2 - 03mar2022
   if (inewvol2>=0) then
      begin

      ivol2:=frcrange32(inewvol2,0,200);
      inewvol2:=-1;

      end;

   //auto-close
   if (not iplaying) and (ihalt or (not ikeepopen)) and canclose and (ihalt or (ms64>=iopenref)) then
      begin

      xpause;
      xcallproc2(bmaClose);

      end;

   //auto-open
   if (not ihalt) and (ikeepopen or iplaying) and canopen then
      begin

      xpause;
      xcallproc2(bmaOpen);

      end;

   //loop
   if (not ihalt) and iplaying and iloop and (ilen>=1) and (ipos>=ilen) then
      begin

      xpause;
      setpos(0);
      syncpos;
      restart;
//      iresetvol:=100;//start at full power at beginning of track - 22feb2022

      end;

   //automatic stop
   if iplaying and (not seeking) and ((ilen<=0) or (ipos>=ilen)) and oautostop then//fixed 10mar2021
      begin

      xpause;
      iplaying:=false;
      xcallproc2(bmaResetvols);

      end;

   //moretime
   if iplaying then
      begin

      moretime;
      //realtime support - 25mar2022
      app__realtime;

      end;

   //reset -> faster response times when running FAST or TURBO modes -> for Harmony etc - 16mar2022
   if app__turboOK then itimer100:=ms64 else itimer100:=ms64+100;
   end;


//.itimer1000
if (ms64>=itimer1000) then
   begin

   //get
   case (mmsys_mid_msgoutcount>=1) of
   true:idatarate:=( idatarate + (mmsys_mid_msgoutcount*4) ) div 2;
   else idatarate:=0;
   end;//case

   mmsys_mid_msgoutcount :=0;

   //.close-and-reopen all in-use midi devices every 24 hours to maintain stability - 23oct2025
   case (handlecount>=1) of
   true:if not iplaying then check24hr;
   else xmustreset24hr(true);
   end;//case

   //.detect device list change and reopen midi devices - 02nov2025
   if xdevicelistHasChanged(true) and (handlecount>=1) then
      begin

      xpause;
      xcallproc2(bmaReopen);
      restart;//does a "xresetvols" etc -> required when midi devices are reopened, especially when the order of the midi devices has changed

      end;

   //reset
   itimer1000            :=ms64+1000;

   end;

skipend:
except;end;
try

//unpause
if ithreadignore then
   begin

   //fade-in special case:
   if (ipos<=0) then iresetvol:=100;//start at full power at beginning of track - 16sep2025, 22feb2022

   //run thread timer - 15aug2025
   itimer.run;

   //off
   ithreadignore:=false;

   end;

itimereventbusy:=false;

except;end;
end;

function tbasicmidi.msgssent:longint;
var
   xhandle,p:longint;
begin

result:=0;

if (ilistlimit>=1) then
   begin

   for xhandle:=0 to high(ihandlelist) do
   begin

   for p:=0 to (ilistlimit-1) do if (ilistcount[p]>=1) and (ilistpos[xhandle][p]>=1) then inc(result,ilistpos[xhandle][p]);

   end;//xhandle

   end;

end;

function tbasicmidi.seeking:boolean;//true=midi is in process of updating "pos" to new value, false=read to set new pos - 30mar2021
begin
result:=(inewpos>=0) or (inewstyle>=0) or (inewdeviceindex>=0) or (imustopen>=1) or imustplaydata or imustplayfile or (inewspeed>=0) or (inewspeed2>=0);//02mar2022
end;

procedure tbasicmidi.moretime;
begin
iopenref:=ms64+5000;
end;

function tbasicmidi.get(xindex,xmsgindex:longint;var xtimems:longint;var xmsg,xval1,xval2,xval3:byte):boolean;
var
   xpos:longint;
   a:tcmp8;
begin

//defaults
result   :=false;
xtimems  :=0;
xmsg     :=0;
xval1    :=0;
xval2    :=0;
xval3    :=0;

try
//check
if (xindex<0) or (xindex>high(ilistdata)) or (ilistdata[xindex]=nil) then exit;

//init
if (xmsgindex<0) then xpos:=0 else xpos:=xmsgindex*12;

//get
if (ilistdata[xindex].len>=1) and (xpos>=0) and ((xpos+11)<ilistdata[xindex].len) then
   begin

   //comp(8)
   a.bytes[0]:=ilistdata[xindex].pbytes[xpos+0];
   a.bytes[1]:=ilistdata[xindex].pbytes[xpos+1];
   a.bytes[2]:=ilistdata[xindex].pbytes[xpos+2];
   a.bytes[3]:=ilistdata[xindex].pbytes[xpos+3];
   a.bytes[4]:=ilistdata[xindex].pbytes[xpos+4];
   a.bytes[5]:=ilistdata[xindex].pbytes[xpos+5];
   a.bytes[6]:=ilistdata[xindex].pbytes[xpos+6];
   a.bytes[7]:=ilistdata[xindex].pbytes[xpos+7];

   xtimems   :=div32(a.val,1000);//convert from usec to ms - 18may2021

   //int(4)
   xmsg      :=ilistdata[xindex].pbytes[xpos+8];
   xval1     :=ilistdata[xindex].pbytes[xpos+9];
   xval2     :=ilistdata[xindex].pbytes[xpos+10];
   xval3     :=ilistdata[xindex].pbytes[xpos+11];

   //successful
   result:=true;

   end;

except;end;
end;

function tbasicmidi.canplaymidi:boolean;
begin
result:=(imustopen=0);
end;

function tbasicmidi.playfile(x:string):boolean;
begin
result        :=true;
ifilename     :=x;
imustplayfile :=true;
end;

function tbasicmidi.playdata(x:tstr8):boolean;
begin
result:=true;
idata2.clear;//fixed - 02mar2022
if str__lock(@x) then idata2.add(x);
imustplaydata:=true;
str__uaf(@x);//15nov2022
end;

function tbasicmidi.handlecount:longint;
var
   p:longint;
begin

result:=0;
for p:=0 to high(ihandlelist) do if (ihandlelist[p].handle<>0) then inc(result);

end;

function tbasicmidi.canopen:boolean;
begin
result:=(handlecount<=0);
end;

function tbasicmidi.canclose:boolean;
begin
result:=(handlecount<>0);
end;

procedure tbasicmidi.setnewpos(x:longint);
begin
inewpos:=frcrange32(x,0,ilen);
end;

procedure tbasicmidi.setnewpertpos(x:double);
begin
//range
if (x<0) then x:=0 else if (x>100) then x:=100;
//get
inewpertpos:=x;
end;

procedure tbasicmidi.setpos(x:longint);
var
   xnewpos,xspeed:comp;
begin

xnewpos:=frcrange32(x,0,ilen);
xspeed:=div64( mult64(frcrange32(ispeed,10,1000),frcrange32(ispeed2,10,1000)) ,100);//combine both speeds together to arrive at one final speed - 03mar2022
//was: ipos64:=-(((xnewpos*100)/xspeed)-ms64);
ipos64:=-(div64(mult64(xnewpos,100),xspeed)-ms64);//uses ms64 high res. version - 30sep2021

end;

procedure tbasicmidi.syncpos;
var
   cmp1:comp;
begin

//get
cmp1:=sub64(ms64,ipos64);

//speed adjust
//was: if (ispeed>=1) then cmp1:=trunc(cmp1*(ispeed/100));
if (ispeed>=1) or (ispeed2>=1) then cmp1:=div64( mult64(cmp1, div64(mult64(ispeed,ispeed2),100)) ,100);//combine both speeds together
//set
if      (cmp1<0)    then cmp1:=0
else if (cmp1>ilen) then cmp1:=ilen;

ipos:=trunc(cmp1);//timer synced

end;

procedure tbasicmidi.restart;
var
   xhandle,p:longint;
begin//Re-syncs midi playback at the new location
try
moretime;
idisablenotes:=true;

//stop all sound
xcallproc2(bmaResetvols);

//start tracks from beginning
if (ilistlimit>=1) then low__cls(@ilistpos,sizeof(ilistpos));

//run notes through midi interface up to the point where we want to start
xcallproc2(bmaPdo);

except;end;
idisablenotes:=false;
end;

function tbasicmidi.canstop:boolean;
begin
result:=(ilen>=1) and iplaying;
end;

procedure tbasicmidi.stop;
begin
if canstop then imuststop:=true;
end;

function tbasicmidi.canplay:boolean;
begin
result:=(ilen>=1) and (not iplaying);
end;

procedure tbasicmidi.play;
begin
moretime;
if canplay then imustplay:=true;
end;

procedure tbasicmidi.flush;
var
   p:longint;
begin
try

for p:=0 to high(ilistdata) do
begin

if (ilistdata[p]<>nil) then ilistdata[p].clear;
ilistcount[p] :=0;

end;//p

low__cls(@ilistpos,sizeof(ilistpos));

ilyrics.clear;
ilyricsref.clear;
ilistlimit :=0;
ipos       :=0;
ilen       :=0;//no midi song loaded -> nothing to play
ilenfull   :=0;
ibytes     :=0;
imidbytes  :=0;

except;end;
end;

function tbasicmidi.lcount:longint;
begin
result:=ilyricsref.len div 12;
end;

function tbasicmidi.lfind(xpos:longint;xshowsep:boolean):string;//find lyrics - 24feb2022
var//note: xpos=milliseconds 0..(len-1)
   xlist:pdllongint;
   acount,alen,apos,p,dp:longint;
   xlast,str1:string;

   function xneeddash(x:byte):boolean;
   begin
   case x of
   65..90,97..122,48..57:result:=true;
   else result:=false;
   end;//case
   end;
begin
//defaults
result:='';

try
//range
//if (xmaxlen<=0) then xmaxlen:=100;
xpos:=frcrange32(xpos,0,frcmin32(ilen-1,0));
dp:=-1;//not found
acount:=lcount;
//get
xlist:=ilyricsref.core;//high-speed access
for p:=0 to (acount-1) do
begin
if (xpos>=xlist[p*3]) then dp:=p;
end;//p
//check
if (dp=-1) then exit;
//set
xlast:='';
for p:=(dp-2) to (dp+10) do
begin
if (p>=0) and (p<acount) then
   begin
   apos:=ilyricsref.int4[(p*12)+4];
   alen:=ilyricsref.int4[(p*12)+8];
   if (apos>=0) and (alen>=1) then
      begin
      str1:=ilyrics.str[apos,alen];
      if (p>=(dp-1)) then result:=result+insstr('-',xshowsep and xneeddash(strbyte1x(str1,1)) and xneeddash(strbyte1x(xlast,low__len(xlast))))+str1;
      xlast:=str1;
      end;
   end;
end;
//filter
if (result<>'') then
   begin
   swapchars(result,#9,#32);
   swapchars(result,#10,#32);
   swapchars(result,#13,#32);
   end;
except;end;
end;

procedure tbasicmidi.xplaydata;
begin
xplaydata2(false);
end;

procedure tbasicmidi.xplaydata2(xtrimtolastnote:boolean);//11jan2025
label
   skipone,skiptrack,skipdone,skipend;
var
   llastms,xtimediv,xtempo,xtmp,mlen,xdatlen,xdatpos,xdatend,xlistcount,int1,p:longint;
   xformat,xtrackcount:word;
   xtickcount,xprevtimeuSEC,xtimeuSEC,xlastnotetimeuSEC,xprevtotaluSEC,xtotaluSEC:comp;//high-resolution time tracker - 18feb2021
   xtimeformat:twrd2;
   xlastnoteonce,xcasiopackets,xresult,bol1:boolean;
   xrunningstatus,xmsg,mtype,byt1,byt2,byt3:byte;
   //track1 tick-tempo mapper
   xdata:tstr8;
   xtickcount8:tstr8;//tickcount at which tempo changes
   xticktemp4:tstr8;//tempo values
   xcount8:longint;
   xlist8:pdlcomp;
   xlist4:pdllongint;

   procedure setdatpos(x:longint);
   begin
   xdatpos:=frcrange32(x,0,xdata.len-1);
   end;

   function xsame(const x:array of byte):boolean;
   begin
   result:=xdata.asame3(xdatpos,x,false);//30mar2021
   inc(xdatpos,sizeof(x));
   end;

   function xsame_autoinc(const x:array of byte):boolean;//auto inc if a match
   begin
   result:=xdata.asame3(xdatpos,x,false);//30mar2021
   if result then inc(xdatpos,sizeof(x));
   end;

   function xfindval1(xpos:longint;var x:byte):boolean;
   begin

   if zzok(xdata,4510) and (xpos>=0) and (xpos<xdatlen) and (xpos<=xdatend) then
      begin
      result :=true;
      x      :=xdata.byt1[xpos];
      end
   else
      begin
      result :=false;
      x      :=0;
      end;

   end;

   function xval1(var x:byte):boolean;
   begin

   if zzok(xdata,4510) and (xdatpos>=0) and (xdatpos<xdatlen) and (xdatpos<=xdatend) then
      begin
      result :=true;
      x      :=xdata.byt1[xdatpos];
      inc(xdatpos,1);
      end
   else
      begin
      result :=false;
      x      :=0;
      end;

   end;

   function xval2(var x:word):boolean;
   begin

   if zzok(xdata,4511) and (xdatpos>=0) and ((xdatpos+1)<xdatlen) and ((xdatpos+1)<=xdatend) then
      begin
      result :=true;
      x      :=xdata.wrd2[xdatpos];
      inc(xdatpos,2);
      end
   else
      begin
      result :=false;
      x      :=0;
      end;

   end;

   function xval2R(var x:word):boolean;
   begin

   if zzok(xdata,4510) and (xdatpos>=0) and ((xdatpos+1)<xdatlen) and ((xdatpos+1)<=xdatend) then
      begin
      result :=true;
      x      :=xdata.wrd2R[xdatpos];
      inc(xdatpos,2);
      end
   else
      begin
      result :=false;
      x      :=0;
      end;

   end;

   function xval4(var x:longint):boolean;
   begin

   if zzok(xdata,4511) and (xdatpos>=0) and ((xdatpos+3)<xdatlen) and ((xdatpos+3)<=xdatend) then
      begin
      result :=true;
      x      :=xdata.int4[xdatpos];
      inc(xdatpos,4);
      end
   else
      begin
      result :=false;
      x      :=0;
      end;

   end;

   function xval4R(var x:longint):boolean;
   begin

   if zzok(xdata,4512) and (xdatpos>=0) and ((xdatpos+3)<xdatlen) and ((xdatpos+3)<=xdatend) then
      begin
      result :=true;
      x      :=xdata.int4R[xdatpos];
      inc(xdatpos,4);
      end
   else
      begin
      result :=false;
      x      :=0;
      end;

   end;

   function xvarlen(var x:longint):boolean;
   var//Supports: 1-4 variable width length
      vc,v1,v2,v3,v4:byte;
   begin
   //defaults
   result :=false;
   x      :=0;

   try
   //get
   vc:=0;

   if xval1(v1) then
      begin

      inc(vc);
      if (v1>=128) and xval1(v2) then
         begin

         inc(vc);
         if (v2>=128) and xval1(v3) then
            begin

            inc(vc);
            if (v3>=128) and xval1(v4) then inc(vc);//v4

            end;//v3

         end;//v2

      end;//v1

   //set
   case vc of
   1:x:=v1;
   2:x:=((v1-128)*128)+v2;
   3:x:=((v1-128)*128*128)+((v2-128)*128)+v3;
   4:x:=((v1-128)*128*128*128)+((v2-128)*128*128)+((v3-128)*128)+v4;
   end;

   //successful
   if (x<0) then x:=0;

   result:=(vc>=1) and (vc<=4);

   except;end;
   end;

   procedure xaddtempo(xtickcount:comp;xtempo:longint);
   var
      xcount:longint;
   begin

   if (xtempo<1) then xtempo:=1;

   xcount                     :=xtickcount8.len div 8;
   xtickcount8.cmp8[xcount*8] :=xtickcount;
   xticktemp4.int4[xcount*4]  :=xtempo;

   end;

   procedure xaddms;//supports single tempo, simple non-overlapping tempo usage, and complex overlapping tempo usage (where a note starts with one tempo and finishes with another or several tempos) - 22feb2022
   var
      p,i,t:longint;
   begin

   //check
   if (int1<=0) then exit;


   //no tempo entries -> use default tempo
   if (xcount8<=0) then
      begin
      xtickcount:=xtickcount+int1;
      //was:
      //xtimeuSEC:=xtimeuSEC+round((xtempo/xtimediv)*int1);
      mid__timeusec__add(xtimeuSEC,xtempo,xtimediv,int1);//22nov2024
      exit;
      end;


   //tick range does NOT overlap tempo boundaries so do it all at ONCE - 23feb2022
   for i:=0 to (xcount8-1) do
   begin

   if ((xtickcount+1)>=xlist8[i]) and ( (i>=(xcount8-1)) or ((xtickcount+int1)<xlist8[i+1]) ) then
      begin

      xtickcount:=xtickcount+int1;
      mid__timeusec__add(xtimeuSEC,xlist4[i],xtimediv,int1);//22nov2024
      exit;

      end;

   end;//i


   //tick range overlaps one or MORE tempo boundaries (ranges over several tempo values) - 23feb2022
   for p:=0 to (int1-1) do
   begin

   xtickcount :=xtickcount+1;
   t          :=xtempo;

   //.scan thru tempo list
   for i:=0 to (xcount8-1) do if (xtickcount>=xlist8[i]) then t:=xlist4[i] else break;

   //was: xtimeuSEC:=xtimeuSEC+round((t/xtimediv));
   mid__timeusec__add(xtimeuSEC,t,xtimediv,1);//22nov2024

   end;//p

   end;

   procedure ladd(xpos,xlen:longint);
   var
      xms,xcount:longint;
   begin
   try

   //check
   if (xlen<=0) then exit;

   //init
   xcount :=ilyricsref.len div 12;
   xms    :=div32(xtimeuSEC,1000);

   //get
   if (xms>llastms) then
      begin

      ilyricsref.int4[(xcount*12)+0]:=xms;
      ilyricsref.int4[(xcount*12)+4]:=ilyrics.len;
      ilyricsref.int4[(xcount*12)+8]:=xlen;

      end;

   ilyrics.add3(xdata,xpos,xlen);

   except;end;
   end;
begin

//defaults
xresult           :=false;
xdatlen           :=0;
xdatpos           :=0;
xdatend           :=max32;
xlistcount        :=-1;
xdata             :=nil;
xtickcount8       :=nil;
xticktemp4        :=nil;
xtimediv          :=120;
xtotaluSEC        :=0;//overall length of midi in uSEC
xcount8           :=0;//set at start of track 1 (xlistcount=1 when format=1)
llastms           :=-1;//none
xlastnotetimeuSEC :=0;//last time a note was changed/hearable etc - used to detect the "real" end of a midi where some midis may go on for hours or even days with no sound - 09jan2025
xlastnoteonce     :=false;

try

//flush
flush;

//check
if not str__lock(@idata) then goto skipend;

//copy "tmp" to "dat"
xdata       :=str__new8;

xdata.add(idata);
idata.clear;

xdatlen     :=xdata.len;
xtickcount8 :=str__new8;
xticktemp4  :=str__new8;

//get
//.riff ".rmi" file wrapper support -> RIFF wrapper packs ".mid" file inside with a 20 byte preceeding header structure in format "RIFF.4+len.4+RMIDdata+len.4+<midi file in full>" = OK = 30mar2021
if xsame_autoinc([uuR,uuI,uuF,uuF]) then
   begin
   if not xval4(int1)              then goto skipend;

   xdatlen:=xdatpos+int1;//include what we have read so far + all that is to come still + BUT exclude any trailing junk - 30mar2021

   if not xsame([uuR,uuM,uuI,uuD]) then goto skipend;
   if not xsame([lld,lla,llt,lla]) then goto skipend;
   if not xval4(int1)              then goto skipend;
   end;

//.main midi header
if not xsame([uuM,uuT,llh,lld]) then goto skipend;

//.32bit number check
if (not xval4R(int1)) or (int1<>6) then goto skipend;//must be "6" -> 32bit number handling check - 15feb2021

//.format
if not xval2R(xformat)          then goto skipend;
if not xval2R(xtrackcount)      then goto skipend;
if not xval2R(xtimeformat.val)  then goto skipend;
if (xformat<0) or (xformat>2)   then goto skipend;//should always be 0,1 or 2(rarely used)
if (xtrackcount<=0)             then goto skipend;

//.convert time into ms for easy system processing -> bit15 decides time format -> false=normal "ticks", true=SMTPE
case (15 in xtimeformat.bits) of
true:begin//time is in ms
   //This time format is NOT supported by us as yet - 27mar2021
   goto skipend;

   //this works diffently as there is NO TEMPO adjustments in this type of type format -> all absolute MS/FRAME based delta timing
   xtimeformat.val:=(15 xor xtimeformat.val);
   end;
else xtimediv:=frcmin32(xtimeformat.val,1);
end;//case

//read all tracks --------------------------------------------------------------
while true do
begin

//.reset end limiter
xdatend:=max32;

//.check
if ((xlistcount+1)>=xtrackcount) then goto skipdone;

//.track header
bol1:=xsame([uuM,uuT,llr,llk]);

//.track length
if not xval4R(int1) then goto skipend;
if (not bol1) or (int1<1) then goto skiptrack;//skip over unknown chunk types, we support "MTrk" chunks only -> all others are jumped over - 16feb2021

//.list count -> each list stores a full track
inc(xlistcount);
if (xlistcount>high(ilistdata)) then goto skipdone;//too many lists
if zznil(ilistdata[xlistcount],4016) then
   begin
   ilistdata[xlistcount]:=str__new8;
   ilistdata[xlistcount].otestlock1:=true;
   end
else ilistdata[xlistcount].clear;//04may2021

//read track -------------------------------------------------------------------
//Important Note:
//calculate Delta Tick Value => current.tempo / timeDiv => uSec per Delta Tick (correct as of 22feb2022)
//example: tempo=500,000 (60 bpm) and timeDiv=120 then delta.tick.usec = 500,000/120 = 8,333 usec = 8.3 ms - correct!

//init
xtempo         :=500000;//500K = default tempo value FOR EACH track of a multi-track midi too -> uSec per quarter note -> 120 BPM (beats per minute musical notation = (120/60) * 0.25 (quarter note) * 1,000,000 usec = 500,000 usec OK) - 18feb2021
xtickcount     :=0;//track tickcount (overall number of ticks on the track BEFORE tempo)
xtimeuSEC      :=0;//track microseconds with TEMPO applied
xdatend        :=xdatpos+(int1-1);//limit HOW much this track can read
xrunningstatus :=0;//on=128..255
xcasiopackets  :=false;//24feb2022

//.rapid access to tickcount/tempo cache - 23feb2022
if (xlistcount>=1) and (xformat>=1) then
   begin

   xcount8 :=xtickcount8.len div 8;
   xlist8  :=xtickcount8.core;
   xlist4  :=xticktemp4.core;

   end;

//get
while true do
begin
//.prev
xprevtimeuSEC   :=xtimeuSEC;
xprevtotaluSEC  :=xtotaluSEC;

//.$F7 - casio stop
if xcasiopackets then
   begin
   if not xval1(byt1) then goto skipend;
   if (byt1=$F7) then xcasiopackets:=false;
   goto skipone;
   end;

//.delta time (variable length number)
if xvarlen(int1) then
   begin
   //inc ms
   case (xlistcount>=1) and (xformat>=1) of
   true:xaddms;
   else begin
//was:      xtimeuSEC:=xtimeuSEC+round((xtempo/xtimediv)*int1);//single track -> tempo inline with notes so no need to cache in a tempo map
      mid__timeusec__add(xtimeuSEC,xtempo,xtimediv,int1);//22nov2024
      xtickcount:=xtickcount+int1;
      end;
   end;//case

   //xtotaluSEC
   if (xtimeuSEC>xtotaluSEC) then xtotaluSEC:=xtimeuSEC;
   end
else goto skipend;

//.xmsg
if not xval1(xmsg) then goto skipend;

//.use runningstatus WHENEVER a message drops into the range "0..127" -> most robust and simple method - 24feb2022
if (xmsg<=127) and (xrunningstatus>=128) then
   begin
   dec(xdatpos,1);//shift back up one byte - 17feb2021
   xmsg:=xrunningstatus;
   end;

//.decide
case xmsg of
//- MIDI events ----------------------------------------------------------------
$00..$7F:begin//** Important: the 0..127 range are NOTES that are running AFTER a NOTE ON/NOTE OFF etc and are using a "running status" shortcut that means that don't have to include the status byte of "Note ON" or "Note Off" again
   //ignored -> running status switches to below $80..$EF
   end;
$80..$BF,$E0..$EF:begin//3b messages - note off -> note on -> polyphonic pressure -> controller ->  -> pitch bend messages
   if not xval1(byt1) then goto skipend;
   if not xval1(byt2) then goto skipend;
   low__midadd(ilistdata[xlistcount],xtimeuSEC,xmsg,byt1,byt2,0);//stores values "asis"

   //.note off/on related "hearable" messages - 11jan2025
   if (xtimeuSEC>xlastnotetimeuSEC) then xlastnotetimeuSEC:=xtimeuSEC;
   end;
$C0..$DF:begin//2b messages - program change -> channel pressure

   if not xval1(byt1) then goto skipend;
   low__midadd(ilistdata[xlistcount],xtimeuSEC,xmsg,byt1,0,0);//stores values "asis"

   case xmsg of
   $C0..$CF:mmsys_mid_voiceindex[xmsg-$C0]:=frcrange32(byt1,0,127);//21aug2025
   end;//case

   end;

//- System Exclusive messages --------------------------------------------------
$F0:begin//F0 length message - ignore: skip over these
   if not xvarlen(mlen) then goto skipend;
   inc(xdatpos,mlen);
   if (mlen>=1) and xfindval1(xdatpos-1,byt1) and (byt1<>$F7) then xcasiopackets:=true;
   end;

//- Escape sequences -----------------------------------------------------------
$F7:begin//F7 length bytes - ignore: skip over these
   if not xvarlen(mlen) then goto skipend;
   inc(xdatpos,mlen);
   end;

//- Meta events ----------------------------------------------------------------
$FF:begin//meta-events "FF type length data"
   //init
   if not xval1(mtype) then goto skipend;
   if not xvarlen(mlen) then goto skipend;
   xtmp:=xdatpos+mlen;//remember this value -> allows for below to pull values and adjust "xdatpos" without worrying about losing the final endpoint
   //get
   case mtype of
   $03:;//track name
   $05:ladd(xdatpos,mlen);//lyrics
   $20:begin
      //ignore
      end;
   $21:begin//Midi Port
      //ignore
      end;
   $2F:begin//end of track (required) -> "FF 2F 00"
      low__midadd(ilistdata[xlistcount],xprevtimeuSEC,xmsg,mtype,0,0);//stores values "asis"
      xtotaluSEC:=xprevtotaluSEC;//exclude this from the total time count
      break;
      end;
   $51:begin//tempo -> "FF 51 03 tt tt tt"
      xval1(byt1);
      xval1(byt2);
      xval1(byt3);
      if (xlistcount<=0) then
         begin
         xtempo:=frcmin32((byt1*256*256)+(byt2*256)+byt3,1);
         if (xformat>=1) then xaddtempo(xtickcount,xtempo);//add tempo to tempo mapper
         end;
      end;
   $54:begin//SMPTE offset -> "FF 54 05 hr mn se fr ff"
      //we don't support this yet
      end;
   $58:begin//time signature -> "FF 58 04 nn dd cc bb"
      //safe to ignore
      end;
   $59:begin//key signature -> "FF 59 02 sf mi"
      //safe to ignore
      end;
   $F0:;
   $7F:begin//sequencer specific event -> "FF 7F length data"
      //safe to ignore
      end;
   end;
   //inc past data
   xdatpos:=xtmp;
   end;
end;//case

//.running status -> keep very simple -> ANY note bases messages "$80..$EF" updates the runningstatus AND is retained no matter WHAT and is simply used whenever a message drops into the range of "0..127" - this works for "james blunt youre beautiful.mid" which expects runningstatus to work EVEN through multiple meta events - 24feb2022
case xmsg of
$80..$EF:xrunningstatus:=xmsg;
end;

skipone:
end;//while -> end of track

//sync tracker handlers
ilistcount[xlistcount]:=low__midcount(ilistdata[xlistcount]);

//detect last usable list
if ((xlistcount+1)>=ilistlimit) then ilistlimit:=xlistcount+1;

skiptrack:
end;//while -> end of all tracks

//successful
skipdone:
xresult:=true;
skipend:
//bytes
if (ilistlimit>=1) then
   begin
   int1:=0;
   for p:=0 to frcmax32(ilistlimit-1,high(ilistdata)) do if (ilistcount[p]>=1) and zzok(ilistdata[p],4513) then inc(int1,ilistdata[p].len);
   ibytes:=int1;
   end;
except;end;

//free
try
str__free(@xdata);
str__free(@xtickcount8);
str__free(@xticktemp4);
except;end;

try

//sync system
ilen     :=div32(xtotaluSEC,1000);//uSEC -> milliseconds
ilenfull :=ilen;//this is the untrimmed length in milliseconds

//.trim to last note - 09jan2025
if xtrimtolastnote then ilen:=frcmax32(ilen, div32(xlastnotetimeuSEC,1000) + 2000 );//uSEC -> milliseconds

imidtrimmed  :=(ilen<>ilenfull);
imidformat   :=low__insint(xformat,xresult);
imidtracks   :=low__insint(frcmin32(ilistlimit-low__insint(1,imidformat=1),0),xresult);//for information purposes only - "format #1 we don't count track #0" - 24feb2021
imidbytes    :=xdatlen;//always return size of midi datastream error or no error - 29mar2021

low__irollone(mmsys_mid_dataref);//11jan2025

//.msgs
int1:=0;

if (ilistlimit>=1) then
   begin

   for p:=0 to frcmax32(ilistlimit-1,high(ilistdata)) do if (ilistcount[p]>=1) then inc(int1,ilistcount[p]);

   end;

imidmsgs:=int1;

except;end;
//unlock
str__uaf(@idata);
end;

//## tbasicchimes ##############################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//ccccccccccccccccccc
constructor tbasicchimes.create;
var
   p:longint;
begin
//self
inherited create;
if classnameis('tbasicchimes') then track__inc(satChimes,1);

//need MM -> midi support to function
need_mm;

//vars
ivol:=100;
iplaying:=false;
imuststop:=false;
imustplay:=-1;//off
iworklist:='';
iworkindex:=0;
iworkmins:=0;
iworkpos:=0;
iworkcount:=1;
iwork0:=true;
iwork15:=true;
iwork30:=true;
iwork45:=true;
iworktest:=false;
ipausenote64:=0;
ibuzzer:=0;//off
ibuzzer2:=0;
ibuzzerpaused:=false;

//clear
icount:=0;
inumberfrom1:=0;
inumberfrom2:=0;
inumberfrom3:=0;
ibuzzercount:=0;
for p:=0 to high(iname) do
begin
iname[p]   :='';
iintro[p]  :=nil;
idong[p]   :=nil;
idong2[p]  :=nil;
itemp[p]   :=nil;
iintroX[p] :='';
idongX[p]  :='';
idong2X[p] :='';
end;//p

//init
xinitChimes;
//timer
low__timerset(self,_ontimer,30);
end;

destructor tbasicchimes.destroy;//02mar2022
var
   p:longint;
begin
try
//timer
low__timerdel(self,_ontimer);//disconnect our timer event from the system timer
//vars
for p:=0 to high(iname) do
begin
str__free(@iintro[p]);
str__free(@idong[p]);
str__free(@idong2[p]);
str__free(@itemp[p]);
end;//p
//.buzzers
for p:=low(ibuzzers) to high(ibuzzers) do str__free(@ibuzzers[p]);
//self
if classnameis('tbasicchimes') then track__inc(satChimes,-1);
inherited destroy;
except;end;
end;

procedure tbasicchimes.setbuzzer(x:longint);
begin
ibuzzer:=frcrange32(x,0,chm_buzzercount);
end;

function tbasicchimes.findbuzzerlabel(x:longint):string;
begin
x:=frcrange32(x,0,high(ibuzzers));
if (x<low(ibuzzerlabels)) then result:='None' else result:=ibuzzerlabels[x];
end;

function tbasicchimes.addbuzzer(xlabel,xdata:string;const xmiddata:array of byte):boolean;
label
   redo;
var
   p,xlabelcount:longint;
   dlabel:string;
begin
//defaults
result:=false;
xlabelcount:=1;

try
//check
if (ibuzzercount<0) then ibuzzercount:=0;
if (ibuzzercount>=high(ibuzzers)) then exit;
//find existing
redo:
dlabel:=xlabel+insstr(#32+intstr32(xlabelcount),xlabelcount>=2);
for p:=1 to frcmax32(ibuzzercount,high(ibuzzerlabels)) do
begin
if strmatch(ibuzzerlabels[p],dlabel) then
   begin
   inc(xlabelcount);
   goto redo;
   end;
end;//p
//get
if (ibuzzercount<high(ibuzzers)) then
   begin
   inc(ibuzzercount);
   setbuzzerdata(ibuzzercount,dlabel,xdata,xmiddata);
   end;
except;end;
end;

procedure tbasicchimes.setbuzzerdata(x:longint;xlabel,xdata:string;const xmiddata:array of byte);
var//x: 0=off, 1..9=buzzer data
   a:tstr8;
   e:string;
begin
try
//defaults
a:=nil;
//range
x:=frcrange32(x,0,high(ibuzzers));
if (x<low(ibuzzers)) then exit;
//init
if (ibuzzers[x]=nil) then ibuzzers[x]:=str__new8;
ibuzzers[x].clear;
//get
if (sizeof(xmiddata)<4) then
   begin
   a:=str__new8;
   low__makemid(xdata,a,e);
   ibuzzers[x].add(a);
   end
else ibuzzers[x].aadd(xmiddata);
//set
ibuzzerlabels[x]:=strdefb(xlabel,intstr32(x));
except;end;
try;str__free(@a);except;end;
end;

procedure tbasicchimes.setvol(x:longint);
begin
ivol:=frcrange32(x,0,100);
end;

procedure tbasicchimes.xinitChimes;
const

//Air.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0air:array[0..121] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,7,53,121,0,255,47,0,77,84,114,107,0,0,0,67,0,255,33,1,0,0,192,14,0,176,7,127,0,144,83,100,120,83,0,0,88,100,120,88,0,0,89,100,130,104,84,100,120,84,0,0,89,0,0,83,100,120,83,0,0,81,100,120,81,0,0,83,100,120,83,0,0,84,100,131,96,84,0,0,255,47,0);

mid__1air:array[0..90] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,7,53,121,0,255,47,0,77,84,114,107,0,0,0,36,0,255,33,1,0,0,192,14,0,176,7,127,0,144,84,100,120,88,100,120,84,0,120,88,0,0,84,100,131,96,84,0,0,255,47,0);

mid__2air:array[0..0] of byte=(
0);


//Air 2.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0air_2:array[0..121] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,7,53,121,0,255,47,0,77,84,114,107,0,0,0,67,0,255,33,1,0,0,192,14,0,176,7,127,0,144,83,100,120,83,0,0,88,100,120,88,0,0,89,100,130,104,84,100,120,84,0,0,89,0,0,83,100,120,83,0,0,81,100,120,81,0,0,83,100,120,83,0,0,84,100,131,96,84,0,0,255,47,0);

mid__1air_2:array[0..78] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,7,53,121,0,255,47,0,77,84,114,107,0,0,0,24,0,255,33,1,0,0,192,14,0,176,7,127,0,144,84,100,131,96,84,0,0,255,47,0);

mid__2air_2:array[0..85] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,7,53,121,0,255,47,0,77,84,114,107,0,0,0,31,0,255,33,1,0,0,192,14,0,176,7,127,0,144,84,100,129,112,84,0,120,84,100,131,96,84,0,0,255,47,0);


//Charm.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0charm:array[0..100] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,11,113,176,0,255,47,0,77,84,114,107,0,0,0,46,0,255,33,1,0,0,192,14,0,176,7,127,0,176,10,63,0,144,79,100,120,79,0,0,86,100,120,86,0,0,83,100,120,83,0,0,79,100,131,96,79,0,0,255,47,0);

mid__1charm:array[0..82] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,11,113,176,0,255,47,0,77,84,114,107,0,0,0,28,0,255,33,1,0,0,192,14,0,176,7,127,0,176,10,63,0,144,83,100,130,124,83,0,0,255,47,0);

mid__2charm:array[0..131] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,16,4,6,8,0,255,89,2,0,0,0,255,81,3,5,184,216,0,255,47,0,77,84,114,107,0,0,0,77,0,255,33,1,0,0,255,3,12,84,117,98,117,108,97,114,45,66,101,108,108,0,192,14,0,176,7,127,0,176,10,63,0,176,101,0,0,100,0,0,6,24,0,224,0,64,0,176,10,63,0,144,83,100,30,83,0,129,22,83,100,122,176,123,0,0,120,0,131,124,144,83,0,0,255,47,0);


//Cheerful.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0cheerful:array[0..168] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,6,2,24,8,0,255,89,2,0,0,0,255,81,3,11,113,176,0,255,47,0,77,84,114,107,0,0,0,114,0,255,33,1,0,0,255,3,7,67,114,121,115,116,97,108,0,192,98,0,176,7,127,0,176,10,64,0,176,101,0,0,100,0,0,6,24,0,224,0,64,0,176,10,64,0,144,100,99,60,100,0,0,93,99,60,93,0,0,100,99,60,100,0,0,88,99,60,88,0,0,100,99,60,100,0,0,83,99,60,83,0,0,93,99,60,93,0,0,96,99,60,96,0,0,100,99,129,112,176,123,0,0,120,0,130,104,144,100,0,0,255,47,0);

mid__1cheerful:array[0..115] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,61,0,255,33,1,0,0,255,3,7,67,114,121,115,116,97,108,0,192,98,0,176,7,127,0,176,10,64,0,176,101,0,0,100,0,0,6,24,0,224,0,64,0,144,100,100,130,105,176,123,0,0,120,0,120,144,100,0,0,255,47,0);

mid__2cheerful:array[0..0] of byte=(
0);


//Elegance.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0elegance_2:array[0..291] of byte=(
77,84,104,100,0,0,0,6,0,1,0,3,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,3,169,128,0,255,47,0,77,84,114,107,0,0,0,116,0,255,33,1,0,0,255,3,16,69,108,101,99,116,114,105,99,32,80,105,97,110,111,32,50,0,192,5,0,176,7,127,0,176,10,64,0,176,101,0,0,100,0,0,6,24,0,224,0,64,0,176,10,64,0,144,110,127,120,110,0,0,103,99,120,103,0,0,100,99,120,100,0,0,103,99,120,103,0,0,107,99,120,107,0,0,105,99,120,105,0,0,107,99,120,107,0,0,108,99,129,112,108,0,130,106,176,123,0,0,120,0,0,255,47,0,77,84,114,107,0,0,0,113,0,255,33,1,0,0,255,3,7,67,114,121,115,116,97,108,0,193,98,0,177,7,27,0,177,10,64,0,177,101,0,0,100,0,0,6,24,0,225,0,64,0,177,10,64,0,145,100,127,120,100,0,0,83,99,120,83,0,0,79,99,120,79,0,0,83,99,120,83,0,0,86,127,0,53,127,120,53,0,0,86,0,0,84,127,120,84,0,0,86,127,120,86,0,0,88,127,129,112,88,0,130,106,177,123,0,0,120,0,0,255,47,0);

mid__1elegance_2:array[0..307] of byte=(
77,84,104,100,0,0,0,6,0,1,0,5,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,3,169,128,0,255,47,0,77,84,114,107,0,0,0,39,0,255,33,1,0,0,255,3,7,83,116,97,102,102,32,54,0,195,0,0,179,7,100,0,179,10,32,131,98,179,123,0,0,120,0,0,255,47,0,77,84,114,107,0,0,0,69,0,255,33,1,0,0,255,3,16,69,108,101,99,116,114,105,99,32,80,105,97,110,111,32,50,0,192,5,0,176,7,126,0,176,10,64,0,176,101,0,0,100,0,0,6,24,0,224,0,64,0,144,110,127,130,104,110,0,122,176,123,0,0,120,0,0,255,47,0,77,84,114,107,0,0,0,60,0,255,33,1,0,0,255,3,7,67,114,121,115,116,97,108,0,193,98,0,177,7,28,0,177,10,64,0,177,101,0,0,100,0,0,6,24,0,225,0,64,0,145,100,127,130,104,100,0,122,177,123,0,0,120,0,0,255,47,0,77,84,114,107,0,0,0,61,0,255,33,1,0,0,255,3,7,67,101,108,101,115,116,97,0,194,8,0,178,7,89,0,178,10,64,0,146,127,127,0,178,101,0,0,100,0,0,6,24,0,226,0,64,130,104,146,127,0,122,178,123,0,0,120,0,0,255,47,0);

mid__2elegance_2:array[0..277] of byte=(
77,84,104,100,0,0,0,6,0,1,0,4,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,7,83,0,0,255,47,0,77,84,114,107,0,0,0,75,0,255,33,1,0,0,255,3,16,69,108,101,99,116,114,105,99,32,80,105,97,110,111,32,50,0,192,5,0,176,7,127,0,176,10,64,0,176,101,0,0,100,0,0,6,24,0,224,0,64,0,144,110,127,120,110,0,0,110,127,120,110,0,129,113,176,123,0,0,120,0,0,255,47,0,77,84,114,107,0,0,0,66,0,255,33,1,0,0,255,3,7,67,114,121,115,116,97,108,0,193,98,0,177,7,28,0,177,10,64,0,177,101,0,0,100,0,0,6,24,0,225,0,64,0,145,100,127,120,100,0,0,100,127,120,100,0,129,113,177,123,0,0,120,0,0,255,47,0,77,84,114,107,0,0,0,66,0,255,33,1,0,0,255,3,7,67,101,108,101,115,116,97,0,194,8,0,178,7,89,0,178,10,64,0,178,101,0,0,100,0,0,6,24,0,226,0,64,0,146,127,127,120,127,0,0,127,127,120,127,0,129,113,178,123,0,0,120,0,0,255,47,0);


//Fallows.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0fallows:array[0..128] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,74,0,255,33,1,0,0,195,14,0,179,7,127,0,179,10,63,0,147,41,100,120,43,100,120,41,0,0,45,100,120,43,0,120,45,0,0,41,100,129,112,40,100,129,112,40,0,0,41,0,0,38,100,129,112,38,0,0,40,100,129,112,40,0,0,41,100,131,96,41,0,0,255,47,0);

mid__1fallows:array[0..100] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,46,0,255,33,1,0,0,195,14,0,179,7,127,0,179,10,63,0,147,41,100,120,41,0,0,43,100,120,43,0,0,41,100,120,41,0,0,40,100,131,96,40,0,0,255,47,0);

mid__2fallows:array[0..125] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,71,0,255,33,1,0,0,195,14,0,179,7,127,0,179,10,63,0,147,41,100,120,41,0,0,43,100,120,43,0,0,41,100,120,41,0,0,40,100,131,96,40,0,0,41,100,120,41,0,0,43,100,120,43,0,0,41,100,120,41,0,0,40,100,131,96,40,0,0,255,47,0);


//Fallows 2.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0fallows_2:array[0..128] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,74,0,255,33,1,0,0,195,14,0,179,7,127,0,179,10,63,0,147,41,100,120,43,100,120,41,0,0,45,100,120,43,0,120,45,0,0,41,100,129,112,40,100,129,112,40,0,0,41,0,0,38,100,129,112,38,0,0,40,100,129,112,40,0,0,41,100,131,96,41,0,0,255,47,0);

mid__1fallows_2:array[0..82] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,28,0,255,33,1,0,0,195,14,0,179,7,127,0,179,10,63,0,147,41,100,130,104,41,0,0,255,47,0);

mid__2fallows_2:array[0..89] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,35,0,255,33,1,0,0,195,14,0,179,7,127,0,179,10,63,0,147,41,100,129,112,41,0,120,41,100,132,88,41,0,0,255,47,0);


//Fields Of Reflection.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0fields_of_reflection:array[0..185] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,131,0,255,33,1,0,0,195,98,0,179,7,127,0,179,10,63,0,147,55,100,120,60,100,120,55,0,0,59,100,120,60,0,120,59,0,0,55,100,129,112,59,100,129,112,59,0,0,55,0,0,60,100,129,112,60,0,0,62,100,129,112,62,0,0,60,100,120,60,0,0,59,100,120,59,0,0,60,100,120,60,0,120,59,100,129,112,59,0,0,57,100,131,96,57,0,0,60,100,120,60,0,0,59,100,120,59,0,0,57,100,129,112,60,100,120,60,0,120,57,0,0,55,100,136,56,55,0,0,255,47,0);

mid__1fields_of_reflection:array[0..107] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,53,0,255,33,1,0,0,195,98,0,179,7,127,0,179,10,63,0,147,55,100,120,60,100,120,55,0,0,59,100,120,60,0,120,59,0,0,57,100,129,112,57,0,0,55,100,137,48,55,0,0,255,47,0);

mid__2fields_of_reflection:array[0..140] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,86,0,255,33,1,0,0,195,98,0,179,7,127,0,179,10,63,0,147,55,100,120,60,100,120,55,0,0,59,100,120,60,0,120,59,0,0,57,100,129,112,57,0,0,55,100,129,112,55,0,131,96,55,100,120,60,100,120,55,0,0,59,100,120,60,0,120,59,0,0,57,100,129,112,57,0,0,55,100,139,32,55,0,0,255,47,0);


//Fields Of Reflection 2.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0fields_of_reflection_2:array[0..185] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,131,0,255,33,1,0,0,195,98,0,179,7,127,0,179,10,63,0,147,55,100,120,60,100,120,55,0,0,59,100,120,60,0,120,59,0,0,55,100,129,112,59,100,129,112,59,0,0,55,0,0,60,100,129,112,60,0,0,62,100,129,112,62,0,0,60,100,120,60,0,0,59,100,120,59,0,0,60,100,120,60,0,120,59,100,129,112,59,0,0,57,100,131,96,57,0,0,60,100,120,60,0,0,59,100,120,59,0,0,57,100,129,112,60,100,120,60,0,120,57,0,0,55,100,136,56,55,0,0,255,47,0);

mid__1fields_of_reflection_2:array[0..82] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,28,0,255,33,1,0,0,195,98,0,179,7,127,0,179,10,63,0,147,55,100,139,32,55,0,0,255,47,0);

mid__2fields_of_reflection_2:array[0..90] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,36,0,255,33,1,0,0,195,98,0,179,7,127,0,179,10,63,0,147,55,100,129,112,55,0,129,112,55,100,139,32,55,0,0,255,47,0);


//Harmony.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0harmony:array[0..100] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,6,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,46,0,255,33,1,0,0,192,9,0,176,7,127,0,176,10,63,0,144,47,127,120,47,0,0,45,127,120,45,0,0,50,127,120,50,0,0,47,127,131,96,47,0,0,255,47,0);

mid__1harmony:array[0..88] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,34,0,255,33,1,0,0,192,9,0,176,7,127,0,176,10,63,0,144,43,127,120,47,127,120,43,0,130,104,47,0,0,255,47,0);

mid__2harmony:array[0..0] of byte=(
0);


//Melody.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0melody:array[0..132] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,78,0,255,33,1,0,0,192,14,0,176,7,127,0,144,71,100,120,71,0,0,67,100,120,67,0,0,71,100,120,71,0,0,74,100,120,74,0,0,71,100,120,71,0,0,69,100,120,69,0,0,72,100,120,72,0,0,74,100,120,74,0,0,71,100,120,71,0,0,72,100,133,80,72,0,0,255,47,0);

mid__1melody:array[0..90] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,36,0,255,33,1,0,0,192,14,0,176,7,127,0,144,72,100,120,72,0,0,76,100,120,76,0,0,74,100,133,80,74,0,0,255,47,0);

mid__2melody:array[0..0] of byte=(
0);


//Melody 2.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0melody_2:array[0..132] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,4,147,224,0,255,47,0,77,84,114,107,0,0,0,78,0,255,33,1,0,0,192,14,0,176,7,127,0,144,71,100,120,71,0,0,67,100,120,67,0,0,71,100,120,71,0,0,74,100,120,74,0,0,71,100,120,71,0,0,69,100,120,69,0,0,72,100,120,72,0,0,74,100,120,74,0,0,71,100,120,71,0,0,72,100,131,96,72,0,0,255,47,0);

mid__1melody_2:array[0..124] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,70,0,255,33,1,0,0,255,3,12,84,117,98,117,108,97,114,45,66,101,108,108,0,192,14,0,176,7,127,0,176,10,64,0,144,74,100,0,176,101,0,0,100,0,0,6,24,0,224,0,64,0,176,10,64,131,96,144,74,0,2,176,123,0,0,120,0,0,255,47,0);

mid__2melody_2:array[0..133] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,79,0,255,33,1,0,0,255,3,12,84,117,98,117,108,97,114,45,66,101,108,108,0,192,14,0,176,7,127,0,176,10,64,0,144,74,100,0,176,101,0,0,100,0,0,6,24,0,224,0,64,0,176,10,64,61,144,74,0,129,51,74,100,129,114,176,123,0,0,120,0,129,110,144,74,0,0,255,47,0);


//Peaceful Pleasantries.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0peaceful_pleasantries:array[0..102] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,7,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,48,0,255,33,1,0,0,192,14,0,176,7,127,0,144,88,100,60,88,0,0,84,100,60,84,0,0,83,100,60,83,0,60,86,100,60,86,0,60,81,100,131,96,81,0,0,255,47,0);

mid__1peaceful_pleasantries:array[0..78] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,24,0,255,33,1,0,0,192,14,0,176,7,127,0,144,86,100,131,96,86,0,0,255,47,0);

mid__2peaceful_pleasantries:array[0..104] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,5,22,21,0,255,47,0,77,84,114,107,0,0,0,50,0,255,33,1,0,0,255,3,12,84,117,98,117,108,97,114,45,66,101,108,108,0,192,14,0,176,7,127,0,176,10,64,0,144,86,100,61,86,0,59,86,100,132,88,86,0,0,255,47,0);


//Succession.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0succession:array[0..168] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,18,79,128,0,255,47,0,77,84,114,107,0,0,0,114,0,255,33,1,0,0,192,14,0,176,7,127,15,144,64,100,15,64,0,0,71,100,15,71,0,0,77,100,15,77,0,0,74,100,15,74,0,0,84,100,15,84,0,0,77,100,15,77,0,0,89,100,15,89,0,0,77,100,15,77,0,0,91,100,15,91,0,0,74,100,15,74,0,0,71,100,15,71,0,0,67,100,15,67,0,0,74,100,15,74,0,0,86,100,15,86,0,0,83,100,15,83,0,0,72,100,129,112,72,0,0,255,47,0);

mid__1succession:array[0..103] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,32,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,18,79,128,48,255,81,3,18,79,128,0,255,47,0,77,84,114,107,0,0,0,42,0,255,33,1,0,0,192,14,0,176,7,127,15,144,72,100,15,72,0,0,86,100,15,86,0,0,83,100,15,83,0,2,71,100,129,112,71,0,0,255,47,0);

mid__2succession:array[0..0] of byte=(
0);


//Succession 2.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0succession_2:array[0..168] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,18,79,128,0,255,47,0,77,84,114,107,0,0,0,114,0,255,33,1,0,0,192,14,0,176,7,127,15,144,64,100,15,64,0,0,71,100,15,71,0,0,77,100,15,77,0,0,74,100,15,74,0,0,84,100,15,84,0,0,77,100,15,77,0,0,89,100,15,89,0,0,77,100,15,77,0,0,91,100,15,91,0,0,74,100,15,74,0,0,71,100,15,71,0,0,67,100,15,67,0,0,74,100,15,74,0,0,86,100,15,86,0,0,83,100,15,83,0,0,72,100,129,112,72,0,0,255,47,0);

mid__1succession_2:array[0..85] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,32,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,18,79,128,48,255,81,3,15,66,64,0,255,47,0,77,84,114,107,0,0,0,24,0,255,33,1,0,0,192,14,0,176,7,127,0,144,71,100,129,112,71,0,0,255,47,0);

mid__2succession_2:array[0..91] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,32,0,255,88,4,3,2,24,8,0,255,89,2,0,0,0,255,81,3,18,79,128,48,255,81,3,15,66,64,0,255,47,0,77,84,114,107,0,0,0,30,0,255,33,1,0,0,192,14,0,176,7,127,3,144,71,100,117,71,100,3,71,0,129,109,71,0,0,255,47,0);


//Tinkle.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0tinkle:array[0..171] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,18,79,128,0,255,47,0,77,84,114,107,0,0,0,117,0,255,33,1,0,0,195,112,0,179,7,127,0,179,10,63,0,147,112,100,29,112,0,1,115,100,29,115,0,1,119,100,29,119,0,1,122,100,29,122,0,5,112,100,29,112,0,1,115,100,29,115,0,1,119,100,29,119,0,1,122,100,26,112,100,3,122,0,26,112,0,1,115,100,29,115,0,1,119,100,29,119,0,1,122,100,29,122,0,31,122,100,30,122,0,0,119,100,30,119,0,0,115,100,30,115,0,0,112,100,120,112,0,0,255,47,0);

mid__1tinkle:array[0..81] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,18,79,128,0,255,47,0,77,84,114,107,0,0,0,27,0,255,33,1,0,0,195,112,0,179,7,127,0,179,10,63,0,147,112,100,120,112,0,0,255,47,0);

mid__2tinkle:array[0..87] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,18,79,128,0,255,47,0,77,84,114,107,0,0,0,33,0,255,33,1,0,0,195,112,0,179,7,127,0,179,10,63,0,147,112,100,120,112,0,0,112,100,120,112,0,0,255,47,0);


//Westminster.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0westminster:array[0..125] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,11,113,176,0,255,47,0,77,84,114,107,0,0,0,71,0,255,33,1,0,0,192,14,0,176,7,127,0,176,10,63,5,144,69,100,120,69,0,0,65,100,120,65,0,0,67,100,120,67,0,0,60,100,130,104,60,0,0,60,100,120,60,0,0,67,100,120,67,0,0,69,100,115,65,100,5,69,0,131,91,65,0,0,255,47,0);

mid__1westminster:array[0..82] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,28,0,255,33,1,0,0,192,14,0,176,7,127,0,176,10,63,0,144,60,100,131,96,60,0,0,255,47,0);

mid__2westminster:array[0..89] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,35,0,255,33,1,0,0,195,14,0,179,7,127,0,179,10,63,0,147,60,100,129,112,60,0,0,60,100,131,96,60,0,0,255,47,0);


//Westminster 2.mid - 0=intro, 1=single dong, 2=double dong (ships bells)
mid__0westminster_2:array[0..125] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,71,0,255,33,1,0,0,192,9,0,176,7,127,0,176,10,63,5,144,69,100,120,69,0,0,65,100,120,65,0,0,67,100,120,67,0,0,60,100,130,104,60,0,0,60,100,120,60,0,0,67,100,120,67,0,0,69,100,115,65,100,5,69,0,131,91,65,0,0,255,47,0);

mid__1westminster_2:array[0..82] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,28,0,255,33,1,0,0,192,9,0,176,7,127,0,176,10,63,0,144,69,100,131,96,69,0,0,255,47,0);

mid__2westminster_2:array[0..89] of byte=(
77,84,104,100,0,0,0,6,0,1,0,2,0,120,77,84,114,107,0,0,0,25,0,255,88,4,4,2,24,8,0,255,89,2,0,0,0,255,81,3,9,39,192,0,255,47,0,77,84,114,107,0,0,0,35,0,255,33,1,0,0,192,9,0,176,7,127,0,176,10,63,0,144,69,100,129,112,69,0,0,69,100,131,96,69,0,0,255,47,0);


//Dong pattern files - i=intro, s=single dong, d=double dong (ships bells)
txt__tnormal:array[0..292] of byte=(
47,47,110,111,114,109,97,108,32,99,104,105,109,101,115,32,116,101,109,112,108,97,116,101,13,10,116,101,115,116,58,32,105,32,115,115,32,115,115,32,115,115,13,10,49,53,58,32,115,13,10,51,48,58,32,115,13,10,52,53,58,32,115,13,10,48,49,48,48,58,32,105,32,115,13,10,48,50,48,48,58,32,105,32,115,115,13,10,48,51,48,48,58,32,105,32,115,115,32,115,13,10,48,52,48,48,58,32,105,32,115,115,32,115,115,13,10,48,53,48,48,58,32,105,32,115,115,32,115,115,32,115,13,10,48,54,48,48,58,32,105,32,115,115,32,115,115,32,115,115,13,10,48,55,48,48,58,32,105,32,115,115,32,115,115,32,115,115,32,115,13,10,48,56,48,48,58,32,105,32,115,115,32,115,115,32,115,115,32,115,115,13,10,48,57,48,48,58,32,105,32,115,115,32,115,115,32,115,115,32,115,115,32,115,13,10,49,48,48,48,58,32,105,32,115,115,32,115,115,32,115,115,32,115,115,32,115,115,13,10,49,49,48,48,58,32,105,32,115,115,32,115,115,32,115,115,32,115,115,32,115,115,32,115,13,10,48,48,48,48,58,32,105,32,115,115,32,115,115,32,115,115,32,115,115,32,115,115,32,115,115,13,10);


txt__tonly_dongs:array[0..282] of byte=(
47,47,110,111,114,109,97,108,32,99,104,105,109,101,115,32,119,105,116,104,111,117,116,32,105,110,116,114,111,39,115,32,116,101,109,112,108,97,116,101,13,10,116,101,115,116,58,32,115,115,32,115,115,32,115,115,13,10,49,53,58,32,115,13,10,51,48,58,32,115,13,10,52,53,58,32,115,13,10,48,49,48,48,58,32,115,13,10,48,50,48,48,58,32,115,115,13,10,48,51,48,48,58,32,115,115,32,115,13,10,48,52,48,48,58,32,115,115,32,115,115,13,10,48,53,48,48,58,32,115,115,32,115,115,32,115,13,10,48,54,48,48,58,32,115,115,32,115,115,32,115,115,13,10,48,55,48,48,58,32,115,115,32,115,115,32,115,115,32,115,13,10,48,56,48,48,58,32,115,115,32,115,115,32,115,115,32,115,115,13,10,48,57,48,48,58,32,115,115,32,115,115,32,115,115,32,115,115,32,115,13,10,49,48,48,48,58,32,115,115,32,115,115,32,115,115,32,115,115,32,115,115,13,10,49,49,48,48,58,32,115,115,32,115,115,32,115,115,32,115,115,32,115,115,32,115,13,10,48,48,48,48,58,32,115,115,32,115,115,32,115,115,32,115,115,32,115,115,32,115,115,13,10);


txt__tships_bells__british_royal:array[0..572] of byte=(
47,47,115,104,105,112,115,32,98,101,108,108,115,32,45,32,66,114,105,116,105,115,104,32,82,111,121,97,108,44,32,102,114,111,109,32,49,55,57,55,32,100,117,101,32,116,111,32,97,32,109,117,116,105,110,121,32,111,110,32,116,104,101,32,100,111,103,32,119,97,116,99,104,32,111,102,32,53,32,98,101,108,108,115,32,116,104,105,115,32,119,97,115,32,114,101,109,111,118,101,100,32,110,101,118,101,114,32,97,103,97,105,110,32,116,111,32,98,101,32,114,117,110,103,13,10,116,101,115,116,58,32,100,32,100,32,100,32,115,13,10,48,48,51,48,58,32,115,13,10,48,49,48,48,58,32,100,13,10,48,49,51,48,58,32,100,115,13,10,48,50,48,48,58,32,100,100,13,10,48,50,51,48,58,32,100,100,32,115,13,10,48,51,48,48,58,32,100,100,32,100,13,10,48,51,51,48,58,32,100,100,32,100,115,13,10,48,52,48,48,58,32,100,100,32,100,100,13,10,48,52,51,48,58,32,115,13,10,48,53,48,48,58,32,100,13,10,48,53,51,48,58,32,100,115,13,10,48,54,48,48,58,32,100,100,13,10,48,54,51,48,58,32,100,100,32,115,13,10,48,55,48,48,58,32,100,100,32,100,13,10,48,55,51,48,58,32,100,
100,32,100,115,13,10,48,56,48,48,58,32,100,100,32,100,100,13,10,48,56,51,48,58,32,115,13,10,48,57,48,48,58,32,100,13,10,48,57,51,48,58,32,100,115,13,10,49,48,48,48,58,32,100,100,13,10,49,48,51,48,58,32,100,100,32,115,13,10,49,49,48,48,58,32,100,100,32,100,13,10,49,49,51,48,58,32,100,100,32,100,115,13,10,48,48,48,48,58,32,100,100,32,100,100,13,10,47,47,100,111,103,32,119,97,116,99,104,32,45,32,102,105,118,101,32,98,101,108,108,32,34,100,100,32,115,34,32,114,101,109,111,118,101,100,32,100,117,101,32,116,111,32,105,116,32,98,101,105,110,103,32,117,115,101,100,32,105,110,32,97,32,109,117,110,116,105,110,121,32,105,110,32,97,114,111,117,110,100,32,49,55,57,55,13,10,49,54,51,48,58,32,115,13,10,49,55,48,48,58,32,100,13,10,49,55,51,48,58,32,100,115,13,10,49,56,48,48,58,32,100,100,13,10,49,56,51,48,58,32,115,13,10,49,57,48,48,58,32,100,13,10,49,57,51,48,58,32,100,115,13,10,50,48,48,48,58,32,100,100,32,100,100,13,10);


txt__tships_bells__standard:array[0..304] of byte=(
47,47,115,104,105,112,115,32,98,101,108,108,115,32,45,32,115,116,97,110,100,97,114,100,13,10,116,101,115,116,58,32,100,32,100,32,100,32,115,13,10,48,48,51,48,58,32,115,13,10,48,49,48,48,58,32,100,13,10,48,49,51,48,58,32,100,115,13,10,48,50,48,48,58,32,100,100,13,10,48,50,51,48,58,32,100,100,32,115,13,10,48,51,48,48,58,32,100,100,32,100,13,10,48,51,51,48,58,32,100,100,32,100,115,13,10,48,52,48,48,58,32,100,100,32,100,100,13,10,48,52,51,48,58,32,115,13,10,48,53,48,48,58,32,100,13,10,48,53,51,48,58,32,100,115,13,10,48,54,48,48,58,32,100,100,13,10,48,54,51,48,58,32,100,100,32,115,13,10,48,55,48,48,58,32,100,100,32,100,13,10,48,55,51,48,58,32,100,100,32,100,115,13,10,48,56,48,48,58,32,100,100,32,100,100,13,10,48,56,51,48,58,32,115,13,10,48,57,48,48,58,32,100,13,10,48,57,51,48,58,32,100,115,13,10,49,48,48,48,58,32,100,100,13,10,49,48,51,48,58,32,100,100,32,115,13,10,49,49,48,48,58,32,100,100,32,100,13,10,49,49,51,48,58,32,100,100,32,100,115,13,10,48,48,48,48,58,32,100,100,32,100,100,13,10);

var
   str1:string;

   procedure xaddBells3(xname:string;xnote:longint);//09nov2022
   begin
   xnote:=frcrange32(xnote,0,127);
   xaddBells2(0, xname, '0i14 0n'+intstr32(xnote)+' 1500x0 1500d500', '0i14 0n'+intstr32(xnote)+' 333x80 0n'+intstr32(xnote)+' 333x80 1000x80' );
   end;

   procedure xaddBells4(xname,xstyle:string;xinstrument,xnote:longint);//09nov2022
   var
      v1,v2:string;
   begin
   //init
   xstyle:=strlow(xstyle);
   xinstrument:=frcrange32(xinstrument,0,127);
   xnote:=frcrange32(xnote,0,127);
   //get
   if (xstyle='fog') then
      begin
      v1:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 500x0 1500d2000';
      v2:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 666x'+intstr32(xnote)+' 0n'+intstr32(xnote)+' 666x'+intstr32(xnote)+' 1000x'+intstr32(xnote);
      end
   else if (xstyle='mid') then
      begin
      v1:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 1500x0 1500d500';
      v2:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 400x'+intstr32(xnote)+' 0n'+intstr32(xnote)+' 400x'+intstr32(xnote)+' 1000x'+intstr32(xnote);
      end
   else if (xstyle='bell') then
      begin
      v1:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 500x0 0d2000';
      v2:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 500x0 0n'+intstr32(xnote)+' 0d1000 0x'+intstr32(xnote);
      end
   else
      begin
      v1:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 1500x0 1500d500';
      v2:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 333x'+intstr32(xnote)+' 0n'+intstr32(xnote)+' 333x'+intstr32(xnote)+' 1000x'+intstr32(xnote);
      end;
   //set
   xaddBells2(0,xname,v1,v2);
   end;

   procedure xaddSonnerie4(xname,xstyle:string;xgap,xinstrument,xnote,xnote2:longint);
   var
      v1,v2:string;
   begin
   //init
   xstyle:=strlow(xstyle);
   xinstrument:=frcrange32(xinstrument,0,127);
   xnote:=frcrange32(xnote,0,127);
   xnote2:=frcrange32(xnote2,0,127);
   xgap:=frcrange32(xgap,0,5000);
   //get
//xaddSonnerie2(400,'Twinkle 2' , '0i9 0n80 333x80 333x80', '0i9 0n70 250x70 0n80 250x80 0n70 333x70 600x70');
   if (xstyle='faster') then
      begin
      v1:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 333x'+intstr32(xnote)+' 333x'+intstr32(xnote);
      v2:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote2)+' 250x'+intstr32(xnote2)+' 0n'+intstr32(xnote)+' 250x'+intstr32(xnote)+' 0n'+intstr32(xnote2)+' 333x'+intstr32(xnote2)+' 600x'+intstr32(xnote2);//fast double beat
      end
   else if (xstyle='faster2') then
      begin
      v1:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 333x'+intstr32(xnote)+' 333x'+intstr32(xnote);
      v2:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 250x'+intstr32(xnote)+' 0n'+intstr32(xnote2)+' 250x'+intstr32(xnote2)+' 0n'+intstr32(xnote)+' 333x'+intstr32(xnote)+' 600x'+intstr32(xnote);//fast double beat
      end
   else if (xstyle='faster3') then
      begin
      v1:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 333x'+intstr32(xnote)+' 333x'+intstr32(xnote);
      v2:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote2)+' 250x'+intstr32(xnote2)+' 0n'+intstr32(xnote)+' 250x'+intstr32(xnote)+' 600x'+intstr32(xnote2);//fast double beat
      end
   else if (xstyle='') then
      begin
      v1:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 400x'+intstr32(xnote)+' 400x'+intstr32(xnote);
      v2:='0i'+intstr32(xinstrument)+' 0n'+intstr32(xnote)+' 150x'+intstr32(xnote)+' 0n'+intstr32(xnote)+' 150x'+intstr32(xnote)+' 0n'+intstr32(xnote2)+' 150x'+intstr32(xnote2)+' 0n'+intstr32(xnote2)+' 150x'+intstr32(xnote2)+' 650x'+intstr32(xnote2);//fast double beat
      end;
   //set
   xaddSonnerie2(400,xname,v1,v2);
   end;
begin
try

//Melodic Chimes --------------------------------------------------------------
xaddTitle('Melody');//15nov2022, was: 'Melodic' - 14nov2022, 12nov2022
inumberfrom1:=icount;
xaddStandard( 'None' , [0] , [0]);

xaddStandard( 'Air' , mid__0air , mid__1air );
xaddStandard( 'Air 2' , mid__0air_2 , mid__1air_2  );
xaddStandard( 'Charm'    , mid__0charm , mid__1charm );
xaddStandard2( 'Charm 2' , '0i14 50n80 700n88 700n84 700n80 2000e0' , '0i14 0n80 200n80 400n84 1400x84' );
xaddStandard2( 'Charm 3' , '0i14 0f10 50n80 700n88 700n84 700n80 2000e0' , '0i14 0f50 30n80 200n80 400n84 1600x84' );
xaddStandard2( 'Charm 4' , '0i14 0s10 0f10 50n80 700n88 700n84 700n80 2000e0' , '0i14 0s10 0f50 30n80 200n80 400n84 1600x84' );

xaddStandard( 'Cheerful' , mid__0cheerful , mid__1cheerful );

xaddStandard2( 'Chirpy'   ,'0i10 100n100 300n101 100n100 300n103 300n103 100n103 100n101 100n101 100n100 100n100 100n101 100n103 100n105 100n103 100n101 100n101100n100 100n100 100n100 1500e0', '0i10 100n100 100n100 300n101 100n100 100n100 100n101100n100 300n101 1000e0' );
xaddStandard2( 'Chirpy 2' ,'0i10 100n100 300n101 100n100 300n103 300n103 100n103 100n101 100n101 100n100 100n100 100n101 100n103 100n105 100n103 100n101 100n101100n100 100n100 100n100 1500e0', '0i10 100n100 100n100 300n101 100n100 100n100 100n101100n100 300n101 2000e0' );
xaddStandard2( 'Chirpy 3' ,'0i9 100n100 300n101 100n100 300n103 300n103 100n103 100n101 100n101 100n100 100n100 100n101 100n103 100n105 100n103 100n101 100n101100n100 100n100 100n100 1500e0', '0i9 100n100 100n100 300n101 100n100 100n100 100n101100n100 300n101 1000e0' );
xaddStandard2( 'Chirpy 4' ,'0i9 100n100 300n101 100n100 300n103 300n103 100n103 100n101 100n101 100n100 100n100 100n101 100n103 100n105 100n103 100n101 100n101100n100 100n100 100n100 1500e0', '0i9 100n100 100n100 300n101 100n100 100n100 100n101100n100 300n101 2000e0' );

xaddStandard2( 'Dignified'   , '0i14 100n70 100n70 1000n68 100n68 1000n71 100n71 1000n68 100n68 3000e0', '0i14 0n68 3000e0' );
xaddStandard2( 'Dignified 2' , '0i14 100n70 100n70 1000n68 100n68 1000n71 100n71 1000n68 100n68 3000e0', '0i14 0n68 120n68 3000e0' );
xaddStandard2( 'Dignified 3' , '0i14 100n70 100n70 1000n68 100n68 1000n71 100n71 1000n68 100n68 3000e0', '0i14 0n68 70n68 120n68 3000e0' );
xaddStandard2( 'Dignified 4' , '0i14 0s-10 100n70 100n70 1000n68 100n68 1000n71 100n71 1000n68 100n68 3000e0', '0i14 0s-10 0n68 3000e0' );
xaddStandard2( 'Dignified 5' , '0i14 0s-10 100n70 100n70 1000n68 100n68 1000n71 100n71 1000n68 100n68 3000e0', '0i14 0s-10 0n68 70n68 120n68 3000e0' );
xaddStandard2( 'Dignified 6' , '0i14 0s20 100n70 100n70 1000n68 100n68 1000n71 100n71 1000n68 100n68 3000e0', '0i14 0s20 0n68 3000e0' );
xaddStandard2( 'Dignified 7' , '0i14 0s20 100n70 100n70 1000n68 100n68 1000n71 100n71 1000n68 100n68 3000e0', '0i14 0s20 0n68 70n68 120n68 3000e0' );

xaddStandard( 'Elegance' , mid__0elegance_2 , mid__1elegance_2 );
xaddStandard( 'Fallows' , mid__0fallows , mid__1fallows );
xaddStandard( 'Fallows 2' , mid__0fallows_2 , mid__1fallows_2 );


xaddStandard2('Festive','0i14 0s-10 0f50 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 200x99 0n100 100x100 0n99 100x99 0n100 200x100 0n99 100x99 0n100 1800x100','0i14 0s-10 0f50 0n99 100x99 0n100 100x100 0n99 100x99 0n100 1800x100');
xaddStandard2('Festive 2','0i14 0s-8 0f40 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 200x99 0n100 100x100 0n99 100x99 0n100 200x100 0n99 100x99 0n100 1800x100','0i14 0s-8 0f40 0n99 100x99 0n100 100x100 0n99 100x99 0n100 1800x100');
xaddStandard2('Festive 3','0i11 0s-7 0f40 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 200x99 0n100 100x100 0n99 100x99 0n100 200x100 0n99 100x99 0n100 1800x100','0i11 0s-7 0f40 0n99 100x99 0n100 100x100 0n99 100x99 0n100 1800x100');

xaddStandard( 'Fields Of Reflection' , mid__0fields_of_reflection , mid__1fields_of_reflection );
xaddStandard( 'Fields Of Reflection 2' , mid__0fields_of_reflection_2 , mid__1fields_of_reflection_2 );

xaddStandard2( 'Firmly' ,   '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 2000x80', '0i14 0n80 1000x80' );
xaddStandard2( 'Firmly 2' , '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 2000x80', '0i14 0n88 2000x88' );
xaddStandard2( 'Firmly 3' , '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 2000x80', '0i14 0n80 2000x80' );
xaddStandard2( 'Firmly 4' , '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 2000x80', '0i14 0n79 700x79 0n80 2000x80' );
xaddStandard2( 'Firmly 5' , '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0n85 200x85 0n85 200x85 0i14 0n80 200x80 0n80 2000x80' );
xaddStandard2( 'Firmly 6' , '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0n85 200x85 0n85 200x85 0n85 200x85 0n85 200x85 0n80 2000x80' );
xaddStandard2( 'Firmly 7' , '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0n85 200x85 0n83 200x83 0n85 200x85 0n83 200x83 0n80 2000x80' );
xaddStandard2( 'Firmly 8' , '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0n88 200x88 0n88 200x88 0n80 2000x80' );
xaddStandard2( 'Firmly 9' , '0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0n88 200x88 0n88 200x88 0n92 4000x92' );
xaddStandard2( 'Firmly 10' , '0i14 0s-10 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0s-10 0n88 200x88 0n88 200x88 0n80 2000x80' );
xaddStandard2( 'Firmly 11' , '0i14 0s-20 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0s-20 0n88 200x88 0n88 200x88 0n80 3000x80' );
xaddStandard2( 'Firmly 12' , '0i14 0s-30 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0s-30 0n88 200x88 0n88 200x88 0n80 3000x80' );
xaddStandard2( 'Firmly 13' , '0i14 0s10 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 3000x80', '0i14 0s10 0n88 200x88 0n88 200x88 0n92 4000x92' );

xaddStandard( 'Harmony' , mid__0harmony , mid__1harmony );
xaddStandard( 'Melody' , mid__0melody , mid__1melody );
xaddStandard( 'Melody 2' , mid__0melody_2 , mid__1melody_2 );

xaddStandard( 'Peaceful Pleasantries'    , mid__0peaceful_pleasantries , mid__1peaceful_pleasantries );
xaddStandard3( 'Peaceful Pleasantries 2' , '', '0i14 0f100 50n86 100n86 100x86 0n90 100x90 0n86 1000x86', mid__0peaceful_pleasantries , [0] );

xaddStandard( 'Succession' , mid__0succession , mid__1succession );
xaddStandard( 'Succession 2' , mid__0succession_2 , mid__1succession_2 );
xaddStandard3( 'Succession 3' , '', '0i14 0n71 150n74 150n72 2000e0', mid__0succession_2 , [0] );

xaddStandard2( 'Suspense' , '0i14 0n92 100x92 0n91 100x91 0n90 100x90 0n89 100x89 0n90 100x90 0n92 100x92 0n89 100x89 0n89 100x89 0n87 100x87 0n89 100x89 0n89 100x89 0n89 100x89 0n92 2000x92', '0i14 0n90 100x90 0n90 100x90 0n90 800x90' );
xaddStandard2( 'Suspense 2' , '0i14 0n92 100x92 0n91 100x91 0n90 100x90 0n89 100x89 0n90 100x90 0n92 100x92 0n89 100x89 0n89 100x89 0n87 100x87 0n89 100x89 0n89 100x89 0n89 100x89 0n92 2000x92', '0i14 0n90 100x90 0n90 100x90 0n90 1800x90' );
xaddStandard2( 'Suspense 3' , '0i14 0n92 100x92 0n91 100x91 0n90 100x90 0n89 100x89 0n90 100x90 0n92 100x92 0n89 100x89 0n89 100x89 0n87 100x87 0n89 100x89 0n89 100x89 0n89 100x89 0n92 2000x92', '0i14 0n90 100x90 0n95 100x95 0n89 1800x90' );

xaddStandard( 'Tinkle' , mid__0tinkle , mid__1tinkle );
xaddStandard2( 'Twinkle'   , '0i9 0f10 0n100 100x100 0n105 100x105 0n108 100x108 0n103 100x103 0n105 100x105 0n100 2000x100', '0i9 0n105 100x105 0n105 100x105 0n100 1800x100' );
xaddStandard2( 'Twinkle 2' , '0i9 0f20 0n100 100x100 0n105 100x105 0n108 100x108 0n103 100x103 0n105 100x105 0n100 2000x100', '0i9 0n105 100x105 0n105 100x105 0n100 3000x100' );
xaddStandard2( 'Twinkle 3' , '0i9 0f10 0n100 100x100 0n105 100x105 0n105 100x105 0n105 100x105 0n105 100x105 0n100 2000x100', '0i9 0n105 100x105 0n105 100x105 0n100 1800x100' );

xaddStandard( 'Westminster' , mid__0westminster , mid__1westminster );
xaddStandard( 'Westminster 2' , mid__0westminster_2 , mid__1westminster_2 );



//Ships Bells Chimes -----------------------------------------------------------
xaddTitle('Ships Bells');
inumberfrom2:=icount;

xaddBells4('Foggy','fog',48,40);
xaddBells4('Foggy 2','fog',48,50);

xaddBells4('High Bells','bell',4,100);
xaddBells4('High Bells 2','bell',4,102);
xaddBells4('High Bells 3','bell',4,104);
xaddBells4('High Bells 4','bell',4,106);
xaddBells4('High Bells 5','bell',4,108);
xaddBells4('High Bells 6','bell',4,110);

xaddBells4('Low Bells','',14,70);
xaddBells4('Low Bells 2','',14,71);
xaddBells4('Low Bells 3','',14,72);
xaddBells4('Low Bells 4','',14,74);
xaddBells4('Low Bells 5','',14,76);
xaddBells4('Low Bells 6','',14,78);
xaddBells4('Low Bells 7','',14,80);

xaddBells4('Solemn','',14,60);
xaddBells4('Solemn 2'  ,'fog',14,60);
xaddBells4('Solemn 3','fog',14,62);
xaddBells4('Solemn 4','fog',14,64);

xaddBells4('Tubular','mid',8,70);
xaddBells4('Tubular 2','mid',8,71);
xaddBells4('Tubular 3','mid',8,72);
xaddBells4('Tubular 4','mid',8,74);
xaddBells4('Tubular 5','mid',8,76);
xaddBells4('Tubular 6','mid',8,78);
xaddBells4('Tubular 7','mid',8,80);

xaddBells3('Zing',101);
xaddBells3('Zing 2',103);
xaddBells3('Zing 3',105);
xaddBells3('Zing 4',107);


//Sonnerie Chimes --------------------------------------------------------------
xaddTitle('Sonnerie');
inumberfrom3:=icount;
//.sonnerie -> Note: As of 16mar2022 rapid fire midis like these are used to construct a complete midi housing the entire chiming sequence for ultra-smooth chiming for switch note changes - 16mar2022
//was: xaddSonnerie2(400,'Twinkle' , '0i9 0n100 400x100 400x100', '0i9 0n100 150x100 0n100 150x100 0n105 150x105 0n105 150x105 650x105');//fast double beat
xaddSonnerie4('Bells','faster',400,9,80,70);
xaddSonnerie4('Bells 2','faster',400,9,90,95);
xaddSonnerie4('Bells 3','faster2',400,9,95,97);
xaddSonnerie4('Bells 4','faster3',400,9,95,99);

xaddSonnerie4('Tubular','faster',400,8,88,99);
xaddSonnerie4('Tubular 2','faster2',400,8,88,99);
xaddSonnerie4('Tubular 3','faster3',400,8,88,99);

xaddSonnerie4('Twinkle'  ,'faster',400,9,100,105);
xaddSonnerie4('Twinkle 2','faster2',400,9,100,105);
xaddSonnerie4('Twinkle 3','faster3',400,9,100,105);

xaddSonnerie4('Zing'    ,'faster' ,400,14,102,103);
xaddSonnerie4('Zing 2'  ,'faster2',400,14,102,103);
xaddSonnerie4('Zing 3'  ,'faster3',400,14,102,103);
xaddSonnerie4('Zing 4'  ,'faster' ,400,14,106,107);
xaddSonnerie4('Zing 5'  ,'faster2',400,14,106,107);
xaddSonnerie4('Zing 6'  ,'faster3',400,14,106,107);

{was:
xaddSonnerie4('Zing'    ,'faster' ,400,14,110-4,112-4);
xaddSonnerie4('Zing 2'  ,'faster2',400,14,110-4,112-4);
xaddSonnerie4('Zing 3'  ,'faster3',400,14,110-4,112-4);
xaddSonnerie4('Zing 4'  ,'faster' ,400,14,114-6,116-8);
xaddSonnerie4('Zing 5'  ,'faster2',400,14,114-6,116-8);
xaddSonnerie4('Zing 6'  ,'faster3',400,14,114-6,116-8);
{}

//Buzzer Chimes ----------------------------------------------------------------
addbuzzer('Attention','0i14 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 500x100',[0]);
addbuzzer('Attention','0i14 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 1500x100',[0]);
addbuzzer('Attention','0i14 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 100x100 0n99 100x99 0n100 4000x100',[0]);

//.double
str1:='Double';
addbuzzer(str1,'0i14 0n90 1000x90 0n92 2000x92',[0]);
addbuzzer(str1,'0i14 0n80 500x80 0n70 2000x75',[0]);
addbuzzer(str1,'0i14 0n80 500x80 0n70 4000x75',[0]);
addbuzzer(str1,'0i14 0n60 500x60 0n62 1500x62',[0]);
addbuzzer(str1,'0i15 0n80 500x80 0n78 1500x78',[0]);
addbuzzer(str1,'0i15 0n80 500x80 0n78 500x78',[0]);
addbuzzer(str1,'0i10 0n80 500x80 0n78 500x78',[0]);
addbuzzer(str1,'0i14 0n90 200x90 0n91 500x91',[0]);
addbuzzer(str1,'0i14 0s-10 0n90 200x90 0n91 500x91',[0]);
addbuzzer(str1,'0i14 0s-20 0n90 200x90 0n91 500x91',[0]);

addbuzzer('Low Dong','',mid__1westminster);
addbuzzer('Low Dong','0i14 0n60 4000x60',[0]);

addbuzzer('Melody','',mid__1air);
addbuzzer('Melody','',mid__1melody);
addbuzzer('Melody','',mid__1succession);
addbuzzer('Melody','',mid__0peaceful_pleasantries);
addbuzzer('Melody','0i14 0n85 200x85 0n85 200x85 0n88 200x88 0n88 200x88 0n80 2000x80',[0]);

str1:='Quadruple';
addbuzzer(str1,'0i14 0n85 200x85 0n87 200x87 0n89 200x89 0n91 1300x91',[0]);
addbuzzer(str1,'0i14 0n85 200x85 0n82 200x82 0n80 200x80 0n91 1300x91',[0]);
addbuzzer(str1,'0i14 0n85 100x85 0n87 100x87 0n89 100x89 0n91 1300x91',[0]);
addbuzzer(str1,'0i14 0n85 100x85 0n87 100x87 0n89 100x89 0n91 4000x91',[0]);

addbuzzer(str1,'0i14 0s-10 0n85 200x85 0n87 200x87 0n89 200x89 0n91 2300x91',[0]);
addbuzzer(str1,'0i14 0s-10 0n85 200x85 0n82 200x82 0n80 200x80 0n91 2300x91',[0]);
addbuzzer(str1,'0i14 0s-10 0n85 100x85 0n87 100x87 0n89 100x89 0n91 2300x91',[0]);
addbuzzer(str1,'0i14 0s-10 0n85 100x85 0n87 100x87 0n89 100x89 0n91 5000x91',[0]);

addbuzzer(str1,'0i14 0s-20 0n85 200x85 0n87 200x87 0n89 200x89 0n91 2300x91',[0]);
addbuzzer(str1,'0i14 0s-20 0n85 200x85 0n82 200x82 0n80 200x80 0n91 2300x91',[0]);
addbuzzer(str1,'0i14 0s-20 0n85 100x85 0n87 100x87 0n89 100x89 0n91 2300x91',[0]);
addbuzzer(str1,'0i14 0s-20 0n85 100x85 0n87 100x87 0n89 100x89 0n91 5000x91',[0]);

//.single
str1:='Single';
addbuzzer(str1,'0i14 0n90 700e0',[0]);
addbuzzer(str1,'0i14 0n90 1200e0',[0]);
addbuzzer(str1,'0i14 0n90 3000e0',[0]);
addbuzzer(str1,'0i14 0n88 700e0',[0]);
addbuzzer(str1,'0i14 0n88 1200e0',[0]);
addbuzzer(str1,'0i14 0n88 3000e0',[0]);
addbuzzer(str1,'0i14 0n85 1200e0',[0]);
addbuzzer(str1,'0i14 0n82 1500e0',[0]);
addbuzzer(str1,'0i14 0n80 1500e0',[0]);
addbuzzer(str1,'0i14 0n75 2000e0',[0]);
addbuzzer(str1,'0i14 0n70 2000e0',[0]);
addbuzzer(str1,'0i14 0n65 2000e0',[0]);
addbuzzer(str1,'0i14 0n60 2000e0',[0]);
addbuzzer(str1,'0i14 0n55 2000e0',[0]);
addbuzzer(str1,'0i14 0n50 2000e0',[0]);


addbuzzer('Suspense'    ,'0i14 0n92 100x92 0n91 100x91 0n90 100x90 0n89 100x89 0n90 100x90 0n92 100x92 0n89 100x89 0n89 100x89 0n87 100x87 0n89 100x89 0n89 100x89 0n89 100x89 0n92 2000x92',[0]);
addbuzzer('Suspense' , '0i14 0s2 0n92 100x92 0n91 100x91 0n90 100x90 0n89 100x89 0n90 100x90 0n92 100x92 0n89 100x89 0n89 100x89 0n87 100x87 0n89 100x89 0n89 100x89 0n89 100x89 0n92 2000x92',[0]);
addbuzzer('Suspense' , '0i14 0n90 100x90 0n90 100x90 0n90 1800x90',[0]);

addbuzzer('Tinkle' , '',mid__0tinkle);

str1:='Triple';
addbuzzer(str1,'0i14 0n80 500x80 0n82 500x82 0n84 1300x84',[0]);
addbuzzer(str1,'0i14 0n80 100x80 0n82 100x82 0n87 1300x87',[0]);
addbuzzer(str1,'0i14 0n80 100x80 0n82 100x82 0n84 700x84',[0]);

addbuzzer(str1,'0i14 0s-10 0n80 500x80 0n82 500x82 0n84 1300x84',[0]);
addbuzzer(str1,'0i14 0s-10 0n80 100x80 0n82 100x82 0n87 1300x87',[0]);
addbuzzer(str1,'0i14 0s-10 0n80 100x80 0n82 100x82 0n84 700x84',[0]);

addbuzzer(str1,'0i14 0s-20 0n80 500x80 0n82 500x82 0n84 1300x84',[0]);
addbuzzer(str1,'0i14 0s-20 0n80 100x80 0n82 100x82 0n87 1300x87',[0]);
addbuzzer(str1,'0i14 0s-20 0n80 100x80 0n82 100x82 0n84 700x84',[0]);

except;end;
end;

function tbasicchimes.getchiming:boolean;
begin//covers seeking, worklist setup and playing of chimes - 02mar2022
result:=(imustplay>=0) or (iworklist<>'') or iplaying;
end;

function tbasicchimes.chimingpert:double;
begin
if (iworkcount=1) and iplaying then result:=low__makepertD0(mid_pos+1,mid_len+1) else result:=low__makepertD0(iworkpos,iworkcount+1);
end;

function tbasicchimes.canstop:boolean;
begin
result:=(not imuststop) and chiming;
end;

procedure tbasicchimes.stop;
begin
imuststop:=true;
end;

function tbasicchimes.mustplayname(xname:string;xmins:longint):boolean;
var
   int1:longint;
begin
findname(xname,int1);result:=mustplayindex(int1,xmins);
end;

function tbasicchimes.mustplayindex(xindex,xmins:longint):boolean;
var
   h23,m59:longint;
begin
xindex:=frcrange32(xindex,0,frcmin32(icount-1,0));
h23:=xmins div 60;
m59:=xmins-(h23*60);
result:=(xindex>=1) and ((m59=0) or (m59=15) or (m59=30) or (m59=45));
end;

function tbasicchimes.canplay:boolean;
begin
result:=(icount>=1) and mid_ok;
end;

procedure tbasicchimes.playname(xname:string;xmins:longint;x0,x15,x30,x45,xtest:boolean);
var
   int1:longint;
begin
findname(xname,int1);playindex(int1,xmins,x0,x15,x30,x45,xtest);
end;

procedure tbasicchimes.playname3(xname:string;xmins:longint;n0,n15,n30,n45,b0,s0,s15,s30,s45,xtest:boolean);
var
   int1:longint;
begin
findname(xname,int1);
case istyle[int1] of
chmsStandard:playindex(int1,xmins,n0,n15,n30,n45,xtest);
chmsBells   :playindex(int1,xmins,b0,true,true,true,xtest);
chmsSonnerie:playindex(int1,xmins,s0,s15,s30,s45,xtest);
end;//case
end;

procedure tbasicchimes.playname2(xname:string);
var
   int1:longint;
begin
findname(xname,int1);
playindex2(int1);
end;

procedure tbasicchimes.playindex(xindex,xmins:longint;x0,x15,x30,x45,xtest:boolean);
begin
iworkmins:=xmins;
iwork0 :=x0;
iwork15:=x15;
iwork30:=x30;
iwork45:=x45;
iworktest:=xtest;
imustplay:=frcrange32(xindex,0,frcmin32(icount-1,0));
end;

procedure tbasicchimes.playindex2(xindex:longint);
begin
imustplay:=frcrange32(xindex,0,frcmin32(icount-1,0));
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//cccccccccccccccc
procedure tbasicchimes._ontimer(sender:tobject);
label
   redo,dobuzzer;
var
   xworkindex,int1:longint;
   v:string;
   a:tstr8;

   function mok(x:tstr8;var xout:tstr8):boolean;
   begin
   result:=(x<>nil) and (x.len>=2);//1 or less is considered an empty or NIL midi - 02mar2022
   xout:=x;
   end;

   procedure xstop;
   begin
   mid_stop;
   mid_setpos(-1);//required in-order for midi playback to recommence properly - 02mar2022
   end;

   procedure xplay(x:tstr8);
   begin
   mid_stop;
   if (x<>nil) and (x.len>=2) then mid_playmidi(x);
   mid_setpos(-1);//required in-order for midi playback to recommence properly - 02mar2022
   end;

   procedure xresetSpecials;
   begin
   ipausenote64:=0;
   mid_setspeed2(100);
   mid_setvol2(ivol);//13mar2022
   end;

   function wval:string;//variable length worklist value - 16mar2022
   var
      p:longint;
   begin
   result:='';
   if (iworklist<>'') then
      begin
      for p:=1 to low__len(iworklist) do if (iworklist[p-1+stroffset]='/') then
         begin
         result:=strcopy1(iworklist,1,p-1);
         strdel1(iworklist,1,p);
         break;
         end;
      end;
   end;
begin
try
//check
if (ibuzzer2>=1) and (not ibuzzerpaused) then goto dobuzzer;

//muststop
if imuststop or (imustplay>=0) then//note: stop current playback before starting a new playback - 02mar2022
   begin
   xstop;
   iplaying:=false;
   iworklist:='';
   iworkpos:=0;
   iworkcount:=1;
   xresetSpecials;
   if ibuzzerpaused then mid_setvol2(20);//start soft and grow louder
   imuststop:=false;
   end;

//mustplay
if (imustplay>=0) then
   begin
   iplaying:=true;
   xresetSpecials;
   iworkindex:=imustplay;//chime to play
   findworklist(iworkindex,iworkmins,iwork0,iwork15,iwork30,iwork45,iworktest,iworklist);//even a empty list will proceed onto the "playback" handler below for consistent AND predictable execution - 03mar2022
   iworkpos:=0;
   iworkcount:=frcmin32(low__len(iworklist),1);
   imustplay:=-1;//off
   end;

//playback
//yyyyyyy (system_program as tbasicprg2).rootwin.xhead.caption:=bnc(app__fastOK)+bnc(app__turboOK)+'<<'+ms64str;//xxxxxxxxxxxxxxx
if iplaying then
   begin
   //.ultra-fast timing - 16mar2022
   app__turbo;
   //.realtime chime vol sync - 13mar2022
   if (ivol<>mid_vol2) then mid_setvol2(ivol);
   //.continue
   xworkindex:=iworkindex;
   if ((ipausenote64=0) or (ms64>=ipausenote64)) and (not mid_seeking) and mid_canplaymidi and (not imuststop) and ((mid_pos>=mid_len) or (not mid_playing)) then
      begin
redo:
      //.playback finished -> stop playback system
      if (iworklist='') then imuststop:=true
      else
         begin
         //init
         v:=strlow(strcopy1(iworklist,1,1));
         strdel1(iworklist,1,1);
         iworkpos:=frcrange32(iworkpos+1,0,iworkcount);//07mar2022
         //get
         if (v='i') then
            begin
            if mok(iintro[xworkindex],a) then xplay(a) else goto redo;
            end
         else if (v='s') then
            begin
            if mok(idong[xworkindex],a) then xplay(a) else goto redo;
            end
         else if (v='d') then
            begin
            if mok(idong2[xworkindex],a) then xplay(a) else goto redo;
            end
         else if (v='g') then//variable length gap
            begin
            int1:=frcrange32(strint(wval),0,5000);//0-5s
            ipausenote64:=add64(ms64,(int1*10000) div frcmin32(mid_speed*mid_speed2,1));
            end
         else if (v='t') then//a multi-part chiming sequence as one large TEMP midi
            begin
            if mok(itemp[xworkindex],a) then xplay(a) else goto redo;
            end
         else if (v='a') or (v='b') or (v='c') then
            begin
            //init
            if      (v='a') then int1:=300
            else if (v='b') then int1:=600
            else if (v='c') then int1:=900
            else                 int1:=300;
            //get
            ipausenote64:=add64(ms64,(int1*10000) div frcmin32(mid_speed*mid_speed2,1));
            end
         else if (v='0') then mid_setspeed2(100)
         else if (v='1') then mid_setspeed2(110)
         else if (v='2') then mid_setspeed2(120)
         else if (v='3') then mid_setspeed2(130)
         else if (v='4') then mid_setspeed2(140)
         else if (v='5') then mid_setspeed2(150)
         else if (v='6') then mid_setspeed2(160)
         else if (v='7') then mid_setspeed2(170)
         else if (v='8') then mid_setspeed2(180)
         else if (v='9') then mid_setspeed2(190)
         else goto redo;
         end;
      end;
   end;

//mustbuzzer + buzzer - Special Note: Playback of above chime takes priority over buzzer, it will interrupt the buzzer and then recommence buzzer when chime completes - 03mar2022
dobuzzer:

//.stop buzzer
if (ibuzzer=0) and (ibuzzer2<>ibuzzer) and ( (iplaying or ibuzzerpaused) or ((not mid_seeking) and mid_canplaymidi and ((mid_pos>=mid_len) or (not mid_playing))) ) then
   begin
   if not iplaying then
      begin
      xstop;
      xresetSpecials;
      end;
   ibuzzerpaused:=false;
   ibuzzer2:=0;
   end
//.start buzzeer
else if (ibuzzer>=1) and (ibuzzer2<>ibuzzer) and (not iplaying) and (not imuststop) and (imustplay<0) and (not mid_seeking) and mid_canplaymidi then
   begin
   xstop;
   xresetSpecials;
   mid_setvol2(20);//start soft and grow louder
   ibuzzerpaused:=false;
   ibuzzer2:=ibuzzer;
   end;

//.play buzzer
if (ibuzzer2>=1) and (not mid_seeking) and mid_canplaymidi and ((mid_pos>=mid_len) or (not mid_playing)) then
   begin
   if iplaying or imuststop or (imustplay>=0) then
      begin
      ibuzzerpaused:=true;
      end
   else
      begin
      ibuzzerpaused:=false;
      if (mid_vol2<100) then mid_setvol2(frcmax32(mid_vol2+5,100));
      //.play specific buzzer
      if (ibuzzer2>=1) then
         begin
         int1:=frcrange32(ibuzzer2,low(ibuzzers),high(ibuzzers));
         xplay(ibuzzers[int1]);
         end;
      end;
   end;
except;end;
end;

function tbasicchimes.findworklist(xindex,xmins:longint;x0,x15,x30,x45,xtest:boolean;var xworklist:string):boolean;
label//Note: x0=intro or not etc - 15mar20222
   skipend;
var
   dstyle,xstyle,p,h,h12,m:longint;
   v,n23,n12:string;
   xmustdong2:boolean;

   function xset(x:string):boolean;
   begin
   result:=true;//pass-thru
   xworklist:=x;
   end;

   function xset2(x:string;xuse:boolean):boolean;
   begin
   result:=true;//pass-thru
   if xuse then xworklist:=x;
   end;

   function ms(xcount:longint):string;//make single dong
   var
      p:longint;
   begin
   result:='';
   if (xcount>=1) then for p:=1 to (xcount) do result:=result+'s';
   end;

   function md(xcount:longint):string;//make double dong
   var
      p:longint;
   begin
   result:='';
   if (xcount>=1) then for p:=1 to (xcount) do result:=result+'d';
   end;

   function mgap(xms:longint):string;//make MS gap
   begin
   result:='';
   if (xms>=1) then result:='g'+intstr32(xms)+'/';//terminator symbol
   end;

   function h112:longint;//always returns 1 to 12
   begin
   result:=h12;
   if (result=0) then result:=12;
   end;

   function mSonnerie(xgap,xcount1,xcount2:longint;xdong,xdong2:string;var xtemp:tstr8):string;
   var
      p:longint;
      e,str1:string;
   begin
   //defaults
   result:='t';

   try
   //check
   if (xtemp=nil) then xtemp:=str__new8;
   //range
   xcount1:=frcmin32(xcount1,0);
   xcount2:=frcmin32(xcount2,0);
   xgap:=frcrange32(xgap,0,5000);//0-5s
   //init
   xtemp.clear;
   //get
   str1:='';
   if (xcount1>=1) then
      begin
      //get
      for p:=1 to xcount1 do str1:=str1+xdong+#32;
      end;
   if (xcount2>=1) then
      begin
      //gap
      if (xcount1>=1) and (xgap>=1) then str1:=str1+'0x0 '+intstr32(xgap)+'x0 ';//2 note-off's will cause a silent delay
      //get
      for p:=1 to xcount2 do str1:=str1+xdong2+#32;
      end;
   //set
   xtemp.clear;
   low__makemid(str1,xtemp,e);
   except;end;
   end;
begin//note: xindex=chime index, xstyle=melody, standard, ships, ships - british, sonneque, xmins=total mins 0..1439 (1 whole day), xtest=return test sequence instead of current time
//defaults
result:=false;
xworklist:='';
xmustdong2:=false;

try
//check
xindex:=frcrange32(xindex,0,high(iname));
if (xindex=0) then goto skipend;//1st chime name is "None" - e.g. No Chiming - 04mar2022
//init
xstyle:=istyle[xindex];
//test
if xtest then
   begin
   case xstyle of
   chmsStandard   :xmins:=420;//"0700"
   chmsBells      :xmins:=1170;//"1930"
   chmsSonnerie   :xmins:=low__aorb(465,420,x0 or (not x45));//"0745" or "0700"
   end;//case
   end;
//range
xmins:=frcrange32(xmins,0,1439);
h:=frcrange32(xmins div 60,0,23);//0..23
h12:=h;
if (h12>12) then h12:=frcrange32(h12-12,0,11);//0..11
m:=frcrange32(xmins-(h*60),0,59);//0..59
n23:=low__digpad11(h,2)+low__digpad11(m,2);
n12:=low__digpad11(h12,2)+low__digpad11(m,2);
//init
if (xstyle=chmsTitle)          then goto skipend//can't play a title!
else if (xstyle=chmsStandard)  then dstyle:=low__aorb(0,1,x0)//intro+dongs OR dongs only
else if (xstyle=chmsBells)     then dstyle:=low__aorb(2,3,x0)//ships bells OR british royal
else if (xstyle=chmsSonnerie)  then dstyle:=low__aorb(4,5,x0)//grande sonnerie OR petite sonnerie
else                                goto skipend;

//get
//.melody + dongs
if (dstyle=0) then
   begin
   if      (m=15)       then xset2('s',x15)
   else if (m=30)       then xset2('s',x30)
   else if (m=45)       then xset2('s',x45)
   else if (m=0)        then xset('i'+ms(h112));//0 - o'clock
   end
//.dongs only
else if (dstyle=1) then
   begin
   if      (m=15)       then xset2('s',x15)
   else if (m=30)       then xset2('s',x30)
   else if (m=45)       then xset2('s',x45)
   else if (m=0)        then xset(ms(h112));//0 - o'clock
   end
//ships bells - standard
else if (dstyle=2) then
   begin
   xmustdong2:=true;
   if      (n12='0030') then xset('s')
   else if (n12='0100') then xset('d')
   else if (n12='0130') then xset('ds')
   else if (n12='0200') then xset('dd')
   else if (n12='0230') then xset('dd s')
   else if (n12='0300') then xset('dd d')
   else if (n12='0330') then xset('dd ds')
   else if (n12='0400') then xset('dd dd')
   else if (n12='0430') then xset('s')
   else if (n12='0500') then xset('d')
   else if (n12='0530') then xset('ds')
   else if (n12='0600') then xset('dd')
   else if (n12='0630') then xset('dd s')
   else if (n12='0700') then xset('dd d')
   else if (n12='0730') then xset('dd ds')
   else if (n12='0800') then xset('dd dd')
   else if (n12='0830') then xset('s')
   else if (n12='0900') then xset('d')
   else if (n12='0930') then xset('ds')
   else if (n12='1000') then xset('dd')
   else if (n12='1030') then xset('dd s')
   else if (n12='1100') then xset('dd d')
   else if (n12='1130') then xset('dd ds')
   else if (n12='0000') then xset('dd dd');
   end
//ships bells - British Royal, from 1797 due to a mutiny on the dog watch of 5 bells this was removed never again to be rung
else if (dstyle=3) then
   begin
   xmustdong2:=true;
   //dog watch - five bell "dd s" removed due to it being used in a muntiny in around 1797
   if      (n23='1630') then xset('s')
   else if (n23='1700') then xset('d')
   else if (n23='1730') then xset('ds')
   else if (n23='1800') then xset('dd')
   else if (n23='1830') then xset('s')
   else if (n23='1900') then xset('d')
   else if (n23='1930') then xset('ds')
   else if (n23='2000') then xset('dd dd')
   //.fallback to standard ships bells
   else if (n12='0030') then xset('s')
   else if (n12='0100') then xset('d')
   else if (n12='0130') then xset('ds')
   else if (n12='0200') then xset('dd')
   else if (n12='0230') then xset('dd s')
   else if (n12='0300') then xset('dd d')
   else if (n12='0330') then xset('dd ds')
   else if (n12='0400') then xset('dd dd')
   else if (n12='0430') then xset('s')
   else if (n12='0500') then xset('d')
   else if (n12='0530') then xset('ds')
   else if (n12='0600') then xset('dd')
   else if (n12='0630') then xset('dd s')
   else if (n12='0700') then xset('dd d')
   else if (n12='0730') then xset('dd ds')
   else if (n12='0800') then xset('dd dd')
   else if (n12='0830') then xset('s')
   else if (n12='0900') then xset('d')
   else if (n12='0930') then xset('ds')
   else if (n12='1000') then xset('dd')
   else if (n12='1030') then xset('dd s')
   else if (n12='1100') then xset('dd d')
   else if (n12='1130') then xset('dd ds')
   else if (n12='0000') then xset('dd dd')
   end
//Grande Sonnerie -> hour dongs + quarterly double-triple dongs (low to high) every 15 minutes (0=hour dongs, 15=(hour dongs) + 1 dong, 30=(hour dongs) + 2 dongs, 45=(hour dongs) + 3 dongs)
else if (dstyle=4) then//Grande Sonnerie
   begin
   //.use built-in pre-built midi files
   if (idongX[xindex]='') then
      begin
      if      (m=15)   then xset2(ms(h112)+mgap(igap[xindex])+md(1),x15)//15
      else if (m=30)   then xset2(ms(h112)+mgap(igap[xindex])+md(2),x30)//30
      else if (m=45)   then xset2(ms(h112)+mgap(igap[xindex])+md(3),x45)//45
      else if (m=0)    then xset(ms(h112));//0 - o'clock
      end
   //.dynamically create a single midi with all chimes etc in one - 16mar2022
   else
      begin
      if      (m=15)   then xset2(mSonnerie(igap[xindex],h112,1,idongX[xindex],idong2X[xindex],itemp[xindex]),x15)
      else if (m=30)   then xset2(mSonnerie(igap[xindex],h112,2,idongX[xindex],idong2X[xindex],itemp[xindex]),x30)
      else if (m=45)   then xset2(mSonnerie(igap[xindex],h112,3,idongX[xindex],idong2X[xindex],itemp[xindex]),x45)
      else if (m=0 )   then xset2(mSonnerie(igap[xindex],h112,0,idongX[xindex],idong2X[xindex],itemp[xindex]),true);
      end;
   end
//Petite Sonnerie -> hour dongs on the our AND only quarterly double-triple dongs (low to high) every 15 minutes (0=hour dongs, 15=1 dong, 30=2 dongs, 45=3 dongs)
else if (dstyle=5) then
   begin
   //.use built-in pre-built midi files
   if (idongX[xindex]='') then
      begin
      if      (m=15)   then xset2(md(1),x15)//15
      else if (m=30)   then xset2(md(2),x30)//30
      else if (m=45)   then xset2(md(3),x45)//45
      else if (m=0)    then xset(ms(h112));//0 - o'clock
      end
  else
   //.dynamically create a single midi with all chimes etc in one - 16mar2022
     begin
     if      (m=15)   then xset2(mSonnerie(igap[xindex],0,1,idongX[xindex],idong2X[xindex],itemp[xindex]),x15)
     else if (m=30)   then xset2(mSonnerie(igap[xindex],0,2,idongX[xindex],idong2X[xindex],itemp[xindex]),x30)
     else if (m=45)   then xset2(mSonnerie(igap[xindex],0,3,idongX[xindex],idong2X[xindex],itemp[xindex]),x45)
     else if (m=0 )   then xset2(mSonnerie(igap[xindex],h112,0,idongX[xindex],idong2X[xindex],itemp[xindex]),true);
     end;
  end;

//no double dong support -> make a double dong out of TWO fast SINGLE dongs -> chime does not support Double Dong (dong2) -> so we must confiure the worklist to modify the playback of a single dong to simulate a double dong - 04mar2022
if xmustdong2 and (xworklist<>'') and ((idong2[xindex]=nil) or (idong2[xindex].len<2)) then
   begin
   //init
   v:=xworklist;
   xworklist:='';
   //get
   for p:=1 to low__len(v) do
   begin
   if (strcopy1(v,p,1)='d') then xworklist:=xworklist+'9ss0a'//speed up to 190%, then do a Dong, and another Dong, then revert speed down to 100% (normal) and wait 600ms
   else                          xworklist:=xworklist+strcopy1(v,p,1);
   end;//p
   end;

skipend:
except;end;

try;result:=(xworklist<>'');except;end;
end;

function tbasicchimes.info(xindex:longint;var xname:string;var xstyle,xtep:longint;var xintro,xdong,xdong2:tstr8):boolean;
begin
//defaults
result:=(xindex>=0) and (xindex<high(iname)) and (xindex<icount);
xname:='';
xstyle:=0;
xtep:=tepNone;
xintro:=nil;
xdong:=nil;
xdong2:=nil;

//get
if result then
   begin
   xname  :=iname[xindex];
   xstyle :=istyle[xindex];
   xtep   :=itep[xindex];
   xintro :=iintro[xindex];
   xdong  :=idong[xindex];
   xdong2 :=idong2[xindex];
   end;
end;

function tbasicchimes.findname(xname:string;var xindex:longint):boolean;
var
   p:longint;
begin
//defaults
result:=false;
xindex:=0;

//check
if (icount<=0) then exit;

//find
for p:=0 to (icount-1) do
begin
if strmatch(xname,iname[p]) then
   begin
   xindex:=p;
   result:=true;
   break;
   end;
end;//p
end;

procedure tbasicchimes.xaddTitle(xname:string);
var
   i:longint;
begin
if not findname(xname,i) then
   begin
   //get
   if (icount>high(iname)) then exit;//at capacity
   i:=icount;
   inc(icount);
   //set - new
   iname[i]   :=xname;
   istyle[i]  :=0;//title
   itep[i]    :=tepNone;
   igap[i]    :=0;
   end;
end;

procedure tbasicchimes.xaddStandard(xname:string;const xintro,xdong:array of byte);
begin
xadd(0,'m:'+xname,xintro,xdong,[0],chmsStandard,low__aorb(tepBlank20,tepMid20,(sizeof(xintro)>=2) or (sizeof(xdong)>=2)));
end;

procedure tbasicchimes.xaddStandard2(xname,xintro,xdong:string);
begin
xadd2(0,'m:'+xname,[0],[0],[0],xintro,xdong,'',chmsStandard,low__aorb(tepBlank20,tepMid20,(low__len(xintro)>=2) or (low__len(xdong)>=2)));
end;

procedure tbasicchimes.xaddStandard3(xname,xintro,xdong:string;const aintro,adong:array of byte);//15nov2022
begin
xadd2(0,'m:'+xname,aintro,adong,[0],xintro,xdong,'',chmsStandard,low__aorb(tepBlank20,tepMid20,(low__len(xintro)>=2) or (low__len(xdong)>=2) or (sizeof(aintro)>=2) or (sizeof(adong)>=2)));
end;

procedure tbasicchimes.xaddBells(xname:string;const xdong,xdong2:array of byte);
begin
xadd(0,'b:'+xname,[0],xdong,xdong2,chmsBells,tepBell20);
end;

procedure tbasicchimes.xaddBells2(xgap:longint;xname,xdong,xdong2:string);
begin
xadd2(xgap,'b:'+xname,[0],[0],[0],'',xdong,xdong2,chmsBells,tepBell20);
end;

procedure tbasicchimes.xaddSonnerie(xgap:longint;xname:string;const xdong,xdong2:array of byte);
begin
xadd(xgap,'s:'+xname,[0],xdong,xdong2,chmsSonnerie,tepSonnerie20);
end;

procedure tbasicchimes.xaddSonnerie2(xgap:longint;xname,xdong,xdong2:string);
begin
xadd2(xgap,'s:'+xname,[0],[0],[0],'',xdong,xdong2,chmsSonnerie,tepSonnerie20);
end;

procedure tbasicchimes.xadd(xgap:longint;xname:string;const xintro,xdong,xdong2:array of byte;xstyle,xtep:longint);
begin
xadd2(xgap,xname,xintro,xdong,xdong2,'','','',xstyle,xtep);
end;

procedure tbasicchimes.xadd2(xgap:longint;xname:string;const xintro,xdong,xdong2:array of byte;sintro,sdong,sdong2:string;xstyle,xtep:longint);
label//Note: sintro, sdong and sdong2 are alternative input formats in the simple midi format "low__makemid()"
   skipend;
var
   i:longint;

   procedure xset(x:tstr8;const xdata:array of byte;xdata2:string);
   var
      a:tstr8;
      e:string;
   begin
   try
   //defaults
   a:=nil;
   //check
   if (x=nil) or ((sizeof(xdata)<2) and (xdata2='')) then exit;
   //init
   a:=str__new8;
   //get
   if (sizeof(xdata)>=2) then a.aadd(xdata) else low__makemid(xdata2,a,e);
   //decompress "x"
   if (a.len>=1) then
      begin
      x.clear;
      x.add(a);
      end;
   except;end;
   try;str__free(@a);except;end;
   end;
begin
try
//init
if not findname(xname,i) then
   begin
   //get
   if (icount>high(iname)) then exit;//at capacity
   i:=icount;
   inc(icount);
   //set - new
   iname[i]   :=xname;
   istyle[i]  :=frcrange32(xstyle,1,3);
   igap[i]    :=frcrange32(xgap,0,10000);//0-10sec
   itep[i]    :=xtep;
   if (iintro[i]=nil) then iintro[i]:=str__new8;
   if (idong[i]=nil)  then idong[i]:=str__new8;
   if (idong2[i]=nil) then idong2[i]:=str__new8;
   end;
//check
if (i<0) or (i>high(iname)) then goto skipend;
//get
if (sizeof(xintro)>=2) or (sintro<>'') then
   begin
   xset(iintro[i],xintro,sintro);
   iintroX[i]:=sintro;
   end;
if (sizeof(xdong)>=2)  or (sdong<>'')  then
   begin
   xset(idong[i] ,xdong,sdong);
   idongX[i]:=sdong;
   end;
if (sizeof(xdong2)>=2) or (sdong2<>'') then
   begin
   xset(idong2[i],xdong2,sdong2);
   idong2X[i]:=sdong2;
   end;
skipend:
except;end;
end;

//## tsnd32 ####################################################################
function snd_waveheaderlen:longint;
begin
result:=58;
end;

function snd_waveheader(format:string;datalen:longint;xoutpos:longint;xout:tstr8):boolean;
var
   _size,_samples,_avebs,_blockalign,_len,_hz,_bit,_ch:tint4;

   procedure xadd(xval:byte);
   begin
   xout.byt1[xoutpos]:=xval;
   inc(xoutpos);
   end;
begin
//defaults
result:=false;

//check
if (xout=nil) then exit;

try
//range
xoutpos:=frcmin32(xoutpos,0);
//get
snd_fromformat(format,_hz.val,_bit.val,_ch.val);
_len.val:=datalen-8;
_blockalign.val:=(_ch.val*_bit.val) div 8;
_avebs.val:=_hz.val*_blockalign.val;
_samples.val:=datalen div nozero__int32(1100048,_blockalign.val);
_size.val:=_samples.val*_blockalign.val;
//set

xadd(82);
xadd(73);
xadd(70);
xadd(70);

xadd(_len.bytes[0]);
xadd(_len.bytes[1]);
xadd(_len.bytes[2]);
xadd(_len.bytes[3]);//a: filesize-8 [5..8]

xadd(87);
xadd(65);
xadd(86);
xadd(69);
xadd(102);
xadd(109);
xadd(116);
xadd(32);
xadd(18);
xadd(0);
xadd(0);
xadd(0);

//.wave sub header [21..34..36 = 14+2 = 16 bytes]
xadd(1);
xadd(0);//PCM format

xadd(_ch.bytes[0]);
xadd(_ch.bytes[1]);//#2#0+//Number of channels

xadd(_hz.bytes[0]);
xadd(_hz.bytes[1]);
xadd(_hz.bytes[2]);
xadd(_hz.bytes[3]);//Samples per second

xadd(_avebs.bytes[0]);
xadd(_avebs.bytes[1]);
xadd(_avebs.bytes[2]);
xadd(_avebs.bytes[3]);//Ave. bytes per second

xadd(_blockalign.bytes[0]);
xadd(_blockalign.bytes[1]);//Block align

xadd(_bit.bytes[0]);
xadd(_bit.bytes[1]);//bits per sample

//.other main RIFF header information
xadd(0);
xadd(0);
xadd(102);//[37..39]

xadd(97);
xadd(99);
xadd(116);
xadd(4);
xadd(0);
xadd(0);
xadd(0);//[40..46]

xadd(_samples.bytes[0]);
xadd(_samples.bytes[1]);
xadd(_samples.bytes[2]);
xadd(_samples.bytes[3]);//v2: total samples [47..50]

//[51..54] = "data"
xadd(100);
xadd(97);
xadd(116);
xadd(97);

//[55..58] = "data len"
xadd(_size.bytes[0]);
xadd(_size.bytes[1]);
xadd(_size.bytes[2]);
xadd(_size.bytes[3]);//v3: "total samples" x "number of channels" x "bytes per sample" [55..58]
except;end;
end;

function snd_toformat(xhz,xbits,xchs:longint):string;
begin
result:=intstr32(snd_safehz(xhz))+#32+intstr32(snd_safebits(xbits))+#32+intstr32(snd_safechs(xchs));
end;

function snd_fromformat(x:string;var xhz,xbits,xchs:longint):boolean;
var
   p,lp,vc,v:integer;
begin//Input: "8/11/12/16/22/24/32/44/48" "8/16" "1/2", e.g. "44 16 2" for CD quality
//defaults
result:=false;
xhz:=8000;
xbits:=8;
xchs:=1;

try
//filter
x:=x+#32;
vc:=1;
lp:=1;
for p:=1 to low__len(x) do
begin
if (strcopy1(x,p,1)=#32) then
   begin
   //get
   v:=strint(strcopy1(x,lp,p-lp));
   case vc of
   1:xhz:=snd_safehz(v);
   2:xbits:=snd_safebits(v);
   3:begin
      xchs:=snd_safechs(v);
      result:=true;
      end;
   end;
   //inc
   lp:=p+1;
   inc(vc);
   end;
end;//p
except;end;
end;

function snd_safechs(x:longint):longint;
begin
case x of
min32..1:x:=1;
2:       x:=2;
else     x:=1;
end;

result:=x;
end;

function snd_safebits(x:longint):longint;
begin
case x of
min32..8:x:=8;
9..16:   x:=16;
17..24:  x:=24;
else     x:=16;
end;

result:=x;
end;

function snd_safekhz(x:longint):longint;
begin
case x of
min32..8:x:=8;
9..11:   x:=11;
12:      x:=12;
13..16:  x:=16;
17..22:  x:=22;
23..24:  x:=24;
25..32:  x:=32;
33..44:  x:=44;
45..48:  x:=48;
49..96:  x:=96;
else     x:=48;
end;

result:=x;
end;

function snd_safehz(x:longint):longint;
begin
case x of
min32..8000 :x:= 8000;
8001 ..11025:x:=11025;
11026..12000:x:=12000;
12001..16000:x:=16000;
16001..22050:x:=22050;
22051..24000:x:=24000;
24001..32000:x:=32000;
32001..44100:x:=44100;
44101..48000:x:=48000;
48001..96000:x:=96000;
else         x:=48000;
end;

result:=x;
end;

function snd_tokhz(xfromHZ:longint):longint;
begin
case snd_safehz(xfromHZ) of
8000 :result:=8;
11025:result:=11;
12000:result:=12;
16000:result:=16;
22050:result:=22;
24000:result:=24;
32000:result:=32;
44100:result:=44;
48000:result:=48;
96000:result:=96;
else  result:=48;
end;//case
end;

function snd_tohz(xfromKHZ:longint):longint;
begin
case snd_safekhz(xfromKHZ) of
8: result:=8000;
11:result:=11025;
12:result:=12000;
16:result:=16000;
22:result:=22050;
24:result:=24000;
32:result:=32000;
44:result:=44100;
48:result:=48000;
96:result:=96000;
else result:=48000;
end;//case
end;

function snd_validkhz(x:longint):boolean;
begin
result:=(x=snd_safekhz(x));
end;

function snd_validhz(x:longint):boolean;
begin
result:=(x=snd_safehz(x));
end;

function nsnd32:tsnd32;
begin
result:=tsnd32.create;
end;

procedure fsnd32(var x:tsnd32);
begin
if zzok(x,3) then freeobj(@x);
end;

constructor tsnd32.create;
begin
inherited create;
if classnameis('tsnd32') then track__inc(satSnd32,1);
ibits:=0;
ikhz:=0;
ihz:=0;
iid:=0;
icore:=str__new8;
ivmax:=nil;//optional - 21jul2021
ilastvmaxid:=-1;
ilen:=0;
iincby:=10000;//10,000 x 4(int32) = 40K
make44_16;
end;

destructor tsnd32.destroy;
begin
try
str__free(@icore);
str__free(@ivmax);
if classnameis('tsnd32') then track__inc(satSnd32,-1);
inherited destroy;
except;end;
end;

function tsnd32.getvmax(x:longint):longint;
label
   redo;
var
   xdiv,xslotsAms,v,vc,i,p,xfrom,xto:longint;
begin
//defaults
result:=0;

try
//remap
if (ilastvmaxid<>iid) then
   begin
   //init
   if (ivmax=nil) then ivmax:=str__new8;
   ilastvmaxid:=iid;
   xslotsAms:=round(ihz/1000);
   case ibits of
   16:xdiv:=129;
   else xdiv:=1;
   end;
   //get
   for p:=(ilen-1) downto 0 do
   begin
   xfrom:=p-(xslotsAms div 2);
   xto:=p+(xslotsAms div 2);
   i:=xfrom;
   v:=0;
   vc:=0;
redo:
   if (i>=0) and (i<ilen) then
      begin
      inc(v,pv[i] div xdiv);
      inc(vc);
      end;
   //inc
   inc(i);
   if (i<=xto) then goto redo;
   //set
   if (vc>=1) then v:=v div vc;
   if (v<0) then v:=0 else if (v>255) then v:=255;
   ivmax.byt1[p]:=v;
   end;//p
   end;
//get
if (x>=0) and (x<ilen) then result:=ivmax.byt1[x];
except;end;
end;

procedure tsnd32.xincid;
begin
low__iroll(iid,1);
end;

function tsnd32.getlen100:longint;
begin
result:=round(len/100);
end;

procedure tsnd32.setlen100(x:longint);
begin
len:=round((ihz/100)*frcmin32(x,0));
end;

procedure tsnd32.setparams(xkhz,xbits,xlen:longint);
begin
//range
xkhz:=snd_safekhz(xkhz);
xbits:=snd_safebits(xbits);
xlen:=frcmin32(xlen,0);
//get
if (xkhz<>ikhz) or (xbits<>ibits) or (ilen<>xlen) then
   begin
   ikhz:=xkhz;
   ihz:=snd_tohz(xkhz);
   ibits:=xbits;
   ilen:=xlen;
   icore.setlen(xlen*4);
   xincid;
   end;
end;

procedure tsnd32.make96_16;
begin
setparams(96,16,ilen);
end;

procedure tsnd32.make48_16;
begin
setparams(44,16,ilen);
end;

procedure tsnd32.make44_16;
begin
setparams(44,16,ilen);
end;

procedure tsnd32.make22_16;
begin
setparams(22,16,ilen);
end;

procedure tsnd32.setkhz(x:longint);
begin
setparams(x,ibits,ilen);
end;

procedure tsnd32.sethz(x:longint);
begin
setparams(snd_tokhz(x),ibits,ilen);
end;

procedure tsnd32.setbits(x:longint);
begin
setparams(ikhz,x,ilen);
end;

procedure tsnd32.setincby(x:longint);
begin
iincby:=frcmin32(x,1);
end;

procedure tsnd32.clear;
begin
len:=0;
end;

function tsnd32.getbytes:longint;
begin
result:=(ilen*4);
end;

procedure tsnd32.setlen(x:longint);
begin
setparams(ikhz,ibits,x);
end;

function tsnd32.minlen(x:longint):boolean;
begin
if (x<=ilen) then result:=true
else
   begin
   setparams(ikhz,ibits,frcmin32(x,ilen));
   result:=icore.minlen((ilen+iincby)*4);
   end;
end;

function tsnd32.getms:longint;
begin
result:=round((ilen/ihz)*1000);
end;

procedure tsnd32.setms(x:longint);
begin
len:=round((ikhz/1000)*x);
end;

function tsnd32.getv(xpos:longint):longint;
begin
result:=0;
if (xpos>=0) and (xpos<ilen) then result:=icore.pints4[xpos];//faster - 13jul2021
//was: if (xpos>=0) and (xpos<ilen) then result:=icore.int4[xpos*4];
end;

procedure tsnd32.setv(xpos,xval:longint);
begin
if (xpos<0) then xpos:=0;
if (xpos>=ilen) and (not minlen(xpos+1)) then exit;
if (xpos>=0) and (xpos<ilen) then
   begin
   if (icore.pints4[xpos]<>xval) then xincid;
   icore.pints4[xpos]:=xval;//faster - 13jul2021
   //was: if (xpos>=0) and (xpos<ilen) then icore.int4[xpos*4]:=xval;
   end;
end;

function tsnd32.getpv(xpos:longint):longint;
begin
result:=getv(xpos);
if (result<0) then result:=-result;
end;

procedure tsnd32.setpv(xpos,xval:longint);
begin
if (xval<0) then xval:=-xval;
setv(xpos,xval);
end;

function tsnd32.getnv(xpos:longint):longint;
begin
result:=getv(xpos);
if (result>0) then result:=-result;
end;

procedure tsnd32.setnv(xpos,xval:longint);
begin
if (xval>0) then xval:=-xval;
setv(xpos,xval);
end;

function tsnd32.add96(x:tstr8;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
begin
result:=xadd(x,96000,xfrom,xlen,xpower255,xasms,e);
end;

function tsnd32.add48(x:tstr8;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
begin
result:=xadd(x,48000,xfrom,xlen,xpower255,xasms,e);
end;

function tsnd32.add44(x:tstr8;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
begin
result:=xadd(x,44100,xfrom,xlen,xpower255,xasms,e);
end;

function tsnd32.add22(x:tstr8;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
begin
result:=xadd(x,22050,xfrom,xlen,xpower255,xasms,e);
end;

function tsnd32.xadd(x:tstr8;dhz,xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
label
   more,redo,skipend;
var
   scount,dcount,dpos,dfrom,spos,slen,sfrom,sto:longint;
begin
//defaults
result:=false;
e:=gecTaskfailed;
dcount:=0;

//check
if zznil(x,17) then exit;

try
//range
dhz:=snd_safehz(dhz);
xpower255:=frcrange32(xpower255,0,255);
//init
slen:=x.len div 2;
sfrom:=xfrom;
sto:=xfrom+xlen-1;
if xasms then
   begin
   sfrom:=round(xfrom*(dhz/1000));
   sto:=round((xfrom+xlen)*(dhz/1000));
   end;
sto:=frcmax32(sto,slen-1);
//check
if (slen<=0) or (sto<0) then
   begin
   result:=true;
   goto skipend;
   end;
//get
spos:=sfrom;
dfrom:=ilen;
dpos:=dfrom;//start position
redo:
if (spos>sto) then
   begin
   result:=true;
   goto skipend;
   end
else if (spos>=0) then
   begin
   scount:=round((spos-sfrom+1)*(ihz/dhz));
more:
   if (dpos>=0) then
      begin
      if (xpower255<=0) then val[dpos]:=val[dpos]
      else if (xpower255>=255) then val[dpos]:=smallint(x.wrd2[spos*2])
      else val[dpos]:=round( (val[dpos]*((255-xpower255)/255)) + ((xpower255/255)*smallint(x.wrd2[spos*2])) );
      end;
   //.inc
   inc(dpos);
   inc(dcount);
   if (dcount<scount) then goto more;
   end;
//inc
inc(spos);
goto redo;

//successful
result:=true;
skipend:
except;end;
try;xincid;except;end;
end;

function tsnd32.add(x:tsnd32;xfrom,xlen,xpower255:longint;xasms:boolean;var e:string):boolean;
label
   redo,skipend;
var
   dpos,spos,slen,sfrom,sto:longint;
begin
//defaults
result:=false;
e:=gecTaskfailed;

//check
if zznil(x,17) or (x=self) or (x.hz<>ihz) then exit;

try
//range
xpower255:=frcrange32(xpower255,0,255);
//init
slen:=x.len;
sfrom:=xfrom;
sto:=xfrom+xlen-1;
if xasms then
   begin
   sfrom:=round(xfrom*(ihz/1000));
   sto:=round((xfrom+xlen)*(ihz/1000));
   end;
//check
if (slen<=0) then
   begin
   result:=true;
   goto skipend;
   end;
//get
spos:=sfrom;
dpos:=ilen;//start position
redo:
if (spos>=slen) then
   begin
   result:=true;
   goto skipend;
   end
else if (spos>=0) then
   begin
   if (dpos>=0) then
      begin
      if (xpower255<=0) then val[dpos]:=val[dpos]
      else if (xpower255>=255) then val[dpos]:=x.val[spos]
      else val[dpos]:=round( (val[dpos]*((255-xpower255)/255)) + ((xpower255/255)*x.val[spos]) );
      end;
   //inc
   inc(dpos);
   end;
//inc
inc(spos);
goto redo;

//successful
result:=true;
skipend:
except;end;
try;xincid;except;end;
end;

function tsnd32.pull96(x:tstr8;xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
begin
result:=xpull(x,96000,xfrom,xlen,xasms,e);
end;

function tsnd32.pull48(x:tstr8;xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
begin
result:=xpull(x,48000,xfrom,xlen,xasms,e);
end;

function tsnd32.pull44(x:tstr8;xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
begin
result:=xpull(x,44100,xfrom,xlen,xasms,e);
end;

function tsnd32.pull22(x:tstr8;xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
begin
result:=xpull(x,22050,xfrom,xlen,xasms,e);
end;

function tsnd32.xpull(x:tstr8;dhz,xfrom,xlen:longint;xasms:boolean;var e:string):boolean;
label
   more,skipend;
var
   scount,dcount,dv,sfrom,sto,dlen,dpos,spos:longint;
   w:twrd2;
   xsameok:boolean;
begin
//defaults
result:=false;
e:=gecTaskfailed;

//check
if zznil(x,17) then exit;

try
//check
if (ilen<=0) then
   begin
   result:=true;
   goto skipend;
   end;
//range
dhz:=snd_safehz(dhz);
xsameok:=(dhz=ihz);
//init
scount:=0;
dcount:=0;
dlen:=x.len div 2;
dpos:=dlen;
sfrom:=xfrom;
sto:=xfrom+xlen-1;
if xasms then
   begin
   sfrom:=round(xfrom*(ihz/1000));
   sto:=round((xfrom+xlen)*(ihz/1000));
   end;
sto:=frcmax32(sto,ilen-1);
//get
for spos:=sfrom to sto do
begin
if (spos>sto) then break
else if (spos>=0) then
   begin
   dv:=val[spos];
   if (dv<-32768) then dv:=-32768 else if (dv>32767) then dv:=32767;
   w.val:=word(dv);
more:
   scount:=trunc((spos-sfrom)*(dhz/ihz));//Important Note: using "round()" instead causes distortion in 44.1Khz format etc - 13jul2021
   if (dcount<=scount) then
      begin
      x.wrd2[dpos*2]:=w.si;
      inc(dpos);
      inc(dcount);
      goto more;
      end;
   end;
end;//p

//successful
result:=true;
skipend:
except;end;
end;

function tsnd32.volave:longint;
begin
result:=volave2(0,max32);
end;

function tsnd32.volave2(xfrom,xlen:longint):longint;
var
   alen,p:longint;
   stotal,scount:comp;
begin
//defaults
result:=1;

try
//get
alen:=ilen;
if (alen>=1) and (xlen>=1) then
   begin
   alen:=ilen;
   stotal:=0;
   scount:=0;
   for p:=xfrom to (xfrom+xlen-1) do
   begin
   if (p>=0) and (p<alen) then
      begin
      stotal:=stotal+pv[p];
      scount:=scount+1;
      if (scount>=1000000) then
         begin
         stotal:=div64(stotal,10);
         scount:=div64(scount,10);
         end;
      end
   else if (p>=alen) then break;
   end;//p
   //set
   result:=frcmin32(restrict32(div64(stotal,frcmin64(scount,1))),1);
   end;
except;end;
end;

procedure tsnd32.setvolave(soriginalvolave:longint);
begin
setvolave2(0,max32,soriginalvolave);
end;

procedure tsnd32.setvolave2(xfrom,xlen,soriginalvolave:longint);
var
   alen,p,dvol:longint;
begin
try
alen:=ilen;
if (alen>=1) and (xlen>=1) then
   begin
   soriginalvolave:=frcmin32(soriginalvolave,1);
   dvol:=frcmin32(volave2(xfrom,xlen),1);
   if (dvol<soriginalvolave) then
      begin
      for p:=xfrom to (xfrom+xlen-1) do
      begin
      if (p>=0) and (p<alen) then val[p]:=round(val[p]*(soriginalvolave/dvol))
      else if (p>=alen) then break;
      end;//p
      end;
   end;
except;end;
try;xincid;except;end;
end;

function tsnd32.findrange(var xmin,xmax:longint):boolean;
var
   dv,p:longint;
begin
//defaults
result:=false;
xmin:=0;
xmax:=0;

//check
if (ilen<=0) then exit;

//get
xmin:=max32;
xmax:=min32;
for p:=0 to (ilen-1) do
begin
dv:=val[p];
if (dv<xmin) then xmin:=dv;
if (dv>xmax) then xmax:=dv;
end;//p

//successul
result:=true;
end;

function tsnd32.findrange2(var lmin,lmax,hmin,hmax:longint):boolean;
var
   dv,p:longint;
   lonce,honce:boolean;
begin
//defaults
result:=false;
lmin:=0;
lmax:=0;
hmin:=0;
hmax:=0;
honce:=true;
lonce:=true;

//check
if (ilen<=0) then exit;

//get
for p:=0 to (ilen-1) do
begin
dv:=val[p];
//.h
if (dv>0) then
   begin
   if (dv>hmax) then hmax:=dv;
   if honce then
      begin
      hmin:=dv;
      honce:=false;
      end
   else if (dv<hmin) then hmin:=dv;
   end
//.l
else if (dv<0) then
   begin
   if (dv<lmax) then lmax:=dv;
   if lonce then
      begin
      lmin:=dv;
      lonce:=false;
      end
   else if (dv>lmin) then lmin:=dv;
   end;
end;//p

//successul
result:=true;
end;

function tsnd32.findmin:longint;
var
   int1:longint;
begin
findrange(result,int1);
end;

function tsnd32.findmax:longint;
var
   int1:longint;
begin
findrange(int1,result);
end;

function tsnd32.iszero(xfrom,xto:longint):boolean;
label
   skipend;
var
   p:longint;
begin
//defaults
result:=false;

//check
if (xto<xfrom) then exit;

//range
for p:=xfrom to xto do
begin
if (p>=0) and (p<ilen) then
   begin
   if (val[p]<>0) then goto skipend;
   end;
end;//p

//successful
result:=true;
skipend:
end;

function tsnd32.inrange(xfrom,xto,xmin,xmax:longint):boolean;
label
   skipend;
var
   dv,p:longint;
begin
//defaults
result:=false;

//check
if (xto<xfrom) then exit;

//range
for p:=xfrom to xto do
begin
if (p>=0) and (p<ilen) then
   begin
   dv:=val[p];
   if (dv<xmin) or (dv>xmax) then goto skipend;
   end;
end;//p

//successful
result:=true;
skipend:
end;

//-- playlist support ----------------------------------------------------------
function playlist__onelen:longint;
begin
result:=4+(2*playlist__namelen);
end;

function playlist__titlestart:longint;
begin
result:=4;
end;

function playlist__namestart:longint;
begin
result:=260;
end;

function playlist__namelen:longint;
begin
result:=256;
end;

function playlist__count(x:tstr8):longint;
begin
if (x<>nil) then result:=x.len div playlist__onelen else result:=0;//secs=4, title=512, filename=512
end;

function playlist__getone(xplaylistfilename:string;x:tstr8;xindex:longint;var xsec:longint;var xtitle,xfilename:string):boolean;
var
   i,xcount,xonelen:longint;
begin
//defaults
result:=false;
xsec:=-1;
xtitle:='';
xfilename:='';

try
//check
xcount:=playlist__count(x);
if (xcount<=0) or (xindex<0) or (xindex>=xcount) then exit;

//get
xonelen  :=playlist__onelen;
i        :=xindex*xonelen;
xsec     :=x.int4[i];//0..3
xtitle   :=x.nullstr[i+playlist__titlestart,playlist__namelen];//4..515
xfilename:=x.nullstr[i+playlist__namestart,playlist__namelen];//516..1027
//convert filename from relative to full filename when "xplaylistfilename<>nil" - 20ar2022
if (xplaylistfilename<>'') then xfilename:=low__readrelative(xfilename,xplaylistfilename);

//successful
result:=true;
except;end;
end;

function playlist__addone(xplaylistfilename:string;x:tstr8;xsec:longint;xtitle,xfilename,xmask:string):boolean;
label
   skipend;
var
   xonelen,i:longint;
   xone:tstr8;
   str1:string;

   function xhasurl:boolean;
   var
      xlen,p:longint;
   begin
   //defaults
   result:=false;

   try
   //check
   xlen:=low__len(xfilename);
   if (xlen<=3) then exit;
   //find
   for p:=1 to (xlen-2) do if (xfilename[p-1+stroffset]=':') and (xfilename[p-1+stroffset+1]='/') and (xfilename[p-1+stroffset+2]='/') then
      begin
      result:=true;
      break;
      end;
   except;end;
   end;

   procedure xmaketitle;
   var
      p:longint;
   begin
   try
   //check
   if (xtitle<>'') then exit;
   //check 2
   str1:=xtitle;
   low__remchar(str1,#32);
   low__remchar(str1,#160);
   if (str1<>'') then exit;
   //check 3
   if (xfilename='') then exit;
   //get
   for p:=low__len(xfilename) downto 1 do
   begin
   if (xfilename[p-1+stroffset]='\') or (xfilename[p-1+stroffset]='/') then
      begin
      xtitle:=strcopy1(xfilename,p+1,low__len(xfilename));
      break;
      end;
   end;//p
   //fallback
   if (xtitle='') then xtitle:=xfilename;
   except;end;
   end;
begin
//defaults
result:=false;
xone:=nil;

//check
if not str__lock(@x) then exit;

try
//get
if (xfilename<>'') and (low__len(xfilename)<=playlist__namelen) and (not xhasurl) then
   begin
   //check against inclusion mask - 20mar2022
   if (xmask<>'') and (not filter__matchlist(xfilename,xmask)) then goto skipend;
   //convert exact filename to relative filename when "xplaylistfilename<>nil" - 20mar2022
   if (xplaylistfilename<>'') then xfilename:=low__makerelative(xfilename,xplaylistfilename);//20mar2022
   //init
   xonelen:=playlist__onelen;
   i:=(playlist__count(x)*xonelen);
   xone:=str__new8;
   xone.setlen(xonelen);
   xone.fill(0,xonelen-1,0);
   //.in case of empty title fill using "name" part of filename
   xmaketitle;
   //get
   xone.int4[0]:=xsec;//0..3
   xone.str[playlist__titlestart,playlist__namelen]:=xtitle;
   xone.str[playlist__namestart,playlist__namelen]:=xfilename;
   //add
   if not x.owr(xone,i) then goto skipend;
   //successful
   result:=true;
   end;
skipend:
except;end;
try
str__uaf(@x);
str__free(@xone);
except;end;
end;

function playlist__addall(xroot,xlistroot:string;x,xlistoffiles:tstr8;xmask:string):boolean;
label
   skipend;
var
   p,xsec,vlen,xpos:longint;
   xline:tstr8;
   v,xtitle:string;

   procedure xnoinfo;
   begin
   xsec:=-1;
   xtitle:='';
   end;
begin
//defaults
result:=false;
xline:=nil;

try
//check
if not low__true2(str__lock(@x),str__lock(@xlistoffiles)) then goto skipend;
//init
xpos:=0;
xline:=str__new8;
xnoinfo;
//get
while true do
begin
if not low__nextline0(xlistoffiles,xline,xpos) then break;
if (xline.count>=1) then
   begin
   //get
   v:=xline.text;
   vlen:=low__len(v);
   //decide
   if strmatch(strcopy1(v,1,8),'#EXTINF:') then
      begin
      xnoinfo;
      v:=strcopy1(v,9,vlen);
      vlen:=low__len(v);
      if (vlen>=2) then
         begin
         for p:=1 to vlen do if (v[p-1+stroffset]=',') then
            begin
            xsec:=strint(strcopy1(v,1,p-1));
            xtitle:=strcopy1(v,p+1,vlen);
            break;
            end;//p
         end;
      end
   else if (v<>'') then
      begin
      v:=low__readrelative(v,xlistroot);//decode from inbound list
      playlist__addone(xroot,x,xsec,xtitle,v,xmask);//encode to outbound list - 20mar2022
      xnoinfo;
      end;
   end;
end;

//successful
result:=true;
skipend:
except;end;
try
str__uaf(@x);
str__uaf(@xlistoffiles);
str__free(@xline);
except;end;
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
//## taudiobasic ###############################################################
function waveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: UINT; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT;
begin
result:=0;
try
result:=win____waveOutOpen(lphWaveOut,uDeviceID,lpFormat,dwCallback,dwInstance,dwFlags);
if (result=0) then track__inc(satWaveopen,1);
except;end;
end;

function waveOutClose(hWaveOut: HWAVEOUT): MMRESULT;
begin
result:=0;
try
result:=win____waveOutClose(hWaveOut);
if (result=0) then track__inc(satWaveopen,-1);
except;end;
end;

function waveInOpen(lphWaveIn: PHWAVEIN; uDeviceID: UINT; lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT;
begin
result:=0;
try
result:=win____waveInOpen(lphWaveIn,uDeviceID,lpFormatEx,dwCallback,dwInstance,dwFlags);
if (result=0) then track__inc(satWaveopen,1);
except;end;
end;

function waveInClose(hWaveIn: HWAVEIN): MMRESULT;
begin
result:=0;
try
result:=win____waveInClose(hWaveIn);
if (result=0) then track__inc(satWaveopen,-1);
except;end;
end;

constructor taudiobasic.create;
var
   p:integer;
begin
//self
inherited create;
if classnameis('taudiobasic') then track__inc(satAudio,1);
//options
oplay_timeout:=10000;//10sec
orec_timeout:=10000;//10sec
iphandle:=0;
irhandle:=0;
ipopen:=false;
ipdata:=str__new8;
irdata:=str__new8;
//vars
for p:=0 to high(ipH) do fillchar(ipH[p],sizeof(ipH[p]),0);
iptime:=ms64;
irtime:=ms64;
isamplems:=250;//250 ms
irsamplems:=250;//250 ms
//defaults
format:='44100 16 2';//play
rformat:='44100 16 1';//record
ipvolume:=100;//26mar2015
irvolume:=100;//26mar2015

//.timer
//low__timerset(self,_ontimer,200);
system_timer2:=_ontimer;
end;

destructor taudiobasic.destroy;
var
   msref:currency;
begin
try
//timer
//low__timerdel(self,_ontimer);//disconnect our timer event from the system timer
system_timer2:=nil;
//close
ilocked:=true;
//Wait till safe or 30seconds - PREVENT FATAL SHUTDOWN ERRORS - 26JUL2009
//Note: Safe to wait, since we are waiting for "wndproc" to be called by MS and not our
//      own timing system, which would PAUSE/HALT as it is linear in design if this
//      were done.
msref:=ms64+30000;
while true do
begin
if (pcount<=0) or (ms64>msref) then break;
win____sleep(50);
app__processmessages;//allow system and MS to breath so that WNDPROC can be called by MS
end;
//close down buffers
paoc;
raoc;
//close down main handle
if (ihandle<>0) then ihandle:=0;
//controls
str__free(@ipdata);
str__free(@irdata);
//self
if classnameis('taudiobasic') then track__inc(satAudio,-1);
inherited destroy;
except;end;
end;

procedure taudiobasic.setvolume(x:integer);
begin//Note: 100%=Normal
ipvolume:=frcrange32(x,0,1000);
end;

procedure taudiobasic.setrvolume(x:integer);
begin//Note: 100%=Normal
irvolume:=frcrange32(x,0,1000);
end;

procedure taudiobasic.pflush;
begin
ipdata.clear;
end;

procedure taudiobasic.rflush;
begin
irdata.clear;
end;

function taudiobasic.pempty:boolean;//assume "ipdata" is never entirely empty as audio rounds to nearest block
begin
result:=(ipdata.len<10);
end;

function taudiobasic.rempty:boolean;//assume "irdata" is never entirely empty as audio rounds to nearest block
begin
result:=(irdata.len<10);
end;

procedure taudiobasic.setsamplems(x:integer);
var
   z:string;
begin
//range
if (x<1) then x:=250;
//set
if (x<>isamplems) then
   begin
   isamplems:=x;
   z:=iformatstr;
   iformatstr:='';
   format:=z;
   end;
end;

procedure taudiobasic.setrsamplems(x:integer);
var
   z:string;
begin
//range
if (x<1) then x:=250;
//set
if (x<>irsamplems) then
   begin
   irsamplems:=x;
   z:=irformatstr;
   irformatstr:='';
   rformat:=z;
   end;
end;

function taudiobasic.onems(xformat:string):longint;//number of bytes for "1 millsecond" of sound - 21JUL2009
var
   xhz,xbits,xchs:longint;
begin//Important Note: Round all figures to integer for stable recording and playback control
     //                even though we will incorrectly report length/timing figures.
snd_fromformat(xformat,xhz,xbits,xchs);
result:=(xhz div 1000)*(xbits div 8)*xchs;
end;

procedure taudiobasic.setformat(x:string);
var
   xhz,xbits,xchs:integer;
begin//Input: "8/11/12/16/22/24/32/44/48" "8/16" "1/2", e.g. "44 16 2" for CD quality
try
//check
snd_fromformat(x,xhz,xbits,xchs);
if (iformat.nSamplesPerSec=xhz) and (iformat.wBitsPerSample=xbits) and (iformat.nChannels=xchs) then exit;
//get
with iformat do
begin
wFormatTag:=1;//"WAVE_FORMAT_PCM=1"
nSamplesPerSec:=xhz;//44.1Khz
wBitsPerSample:=xbits;//16bit
nChannels:=xchs;//stereo
nBlockAlign:=(nChannels*wBitsPerSample) div 8;
nAvgBytesPerSec:=nSamplesPerSec*nBlockAlign;
cbSize:=sizeof(iformat);
end;
ip16bit:=(iformat.wBitsPerSample=16);
isecsize:=iformat.nAvgBytesPerSec;
//update
iformatmodified:=true;
iformatstr:=intstr32(iformat.nSamplesPerSec)+#32+intstr32(iformat.wBitsPerSample)+#32+intstr32(iformat.nChannels);
isamplesize:=frcmax32(isamplems*onems(format),sizeof(taudiobasicbuffer));
isecsize:=(1000 div nozero__int32(1100028,isamplems))*isamplesize;//Important: Use nearest whole number
ipchcount:=iformat.nchannels;
except;end;
end;

procedure taudiobasic.setrformat(x:string);
var
   xhz,xbits,xchs:integer;
begin//Input: "8/11/12/16/22/24/32/44/48" "8/16" "1/2", e.g. "44 16 2" for CD quality
try
//check
snd_fromformat(x,xhz,xbits,xchs);
if (irformat.nSamplesPerSec=xhz) and (irformat.wBitsPerSample=xbits) and (irformat.nChannels=xchs) then exit;
//get
with irformat do
begin
wFormatTag:=1;//"WAVE_FORMAT_PCM=1"
nSamplesPerSec:=xhz;//44.1Khz
wBitsPerSample:=xbits;//16bit
nChannels:=xchs;//stereo
nBlockAlign:=(nChannels*wBitsPerSample) div 8;
nAvgBytesPerSec:=nSamplesPerSec*nBlockAlign;
cbSize:=sizeof(irformat);
end;
ir16bit:=(irformat.wBitsPerSample=16);
//update
irformatmodified:=true;
irformatstr:=intstr32(irformat.nSamplesPerSec)+#32+intstr32(irformat.wBitsPerSample)+#32+intstr32(irformat.nChannels);
irsamplesize:=frcmax32(isamplems*onems(rformat),sizeof(taudiobasicbuffer));
irsecsize:=(1000 div nozero__int32(1100029,irsamplems))*irsamplesize;//Important: Use nearest whole number
irchcount:=irformat.nchannels;
except;end;
end;

procedure taudiobasic._ontimer(sender:tobject);
begin
//check
if ilocked then exit;
//state
paoc;
raoc;
//start
if not ipplaying then pdo;
end;

procedure taudiobasic.wkAdjustVolume(_16bit:boolean;z:tstr8;_vol:integer);//adjust volume
var
   a:shortint;//tbytechar;
   p:integer;
   m:extended;
   v:integer;
begin
try
//check
if not str__lock(@z) then exit;
//range
_vol:=frcrange32(_vol,0,1000);//100%=Normal, no change
if (_vol=100) then exit;
//get
m:=_vol/100;
for p:=1 to z.len do
begin
//.get
case _16bit of
true:begin//16bit
   a:=shortint(z.bytes1[p]);
   a:=shortint(frcrange32(round(a*m),-128,127));
   z.bytes1[p]:=byte(a);
   end;
else begin//8bit
   v:=z.bytes1[p]-128;
   v:=frcrange32(round(v*m),-128,127);
   z.bytes1[p]:=byte(v)+128;
   end;
end;//case
end;//loop
except;end;
try;str__uaf(@z);except;end;
end;

procedure taudiobasic.pdo;
label
   skipend,redo;
var
   z:tstr8;
   count,len,p:integer;
   h:pwavehdr;
   a:paudiobasicbuffer;
begin
try
//defaults
count:=0;
z:=nil;
//check
if iformatmodified or ilocked or (iphandle=0) or (not ipopen) or (ipdata.len<=0) then
   begin
   ipplaying:=false;
   ipmaxV:=0;
   exit;
   end;
//get
z:=str__new8;
redo:
h:=@ipH[ippos];
a:=paudiobasicbuffer(h^.lpData);
z.add3(ipdata,0,isamplesize);
//.adjust volume
if (ipvolume<>100) then wkAdjustVolume(p16bit,z,ipvolume);
//.continue
len:=z.len;
if (len=0) then goto skipend;
for p:=1 to len do a[p-1]:=byte(z.bytes1[p]);
h.dwBufferlength:=len;
//set
if (not iformatmodified) and (not ilocked) and (iphandle<>0) and (0=win____waveOutWrite(iphandle,h,sizeof(h^))) then
   begin
   //maxV
   ipmaxV:=wkMaxV(p16bit,z);
   //inc
   inc(count);
   inc(ippos);
   if (ippos>high(ipH)) then ippos:=0;
   //set
   ipplaying:=true;
   ipdata.del3(0,len);
   ipcount:=frcrange32(ipcount+1,1,20);
   //next
   if (ipcount<=1) and (count<=5) then goto redo;
   end
else
   begin
   ipplaying:=false;
   ipmaxV:=0;
   end;
skipend:
except;end;
try;str__free(@z);except;end;
end;

function taudiobasic.handle:hwnd;
begin
if (ihandle=0) then ihandle:=app__wproc.window;//system message handler - shared
result:=ihandle;
end;

procedure taudiobasic.paoc;//automatic open/close
var
   p:integer;
   ptr:HWAVEOUT;
begin
try
//open
if (not iformatmodified) and (iptime>ms64) and (not ilocked) then
   begin
   if (iphandle=0) and (0=waveOutOpen(@iphandle,0,@iformat,handle,0,WAVE_ALLOWSYNC or CALLBACK_WINDOW)) then
      begin
      //init
      for p:=0 to high(ipH) do
      begin
      fillchar(ipB[p],sizeof(ipB[p]),0);
      ipH[p].lpData:=@ipB[p];
      ipH[p].dwBufferLength:=isamplesize;//keep buffer short and responsive
      ipH[p].dwUser:=$0;
      ipH[p].dwFlags:=$0;
      ipH[p].dwLoops:=$0;
      win____waveOutPrepareHeader(iphandle,@ipH[p],sizeof(ipH[p]));
      end;//loop
      ippos:=0;
      ipcount:=0;
      end;
   end
//close
else if (iphandle<>0) and (iformatmodified or ilocked or (iptime<=ms64)) then
   begin
   //clear
   ptr:=iphandle;
   iphandle:=0;
   ipopen:=false;
   //buffers
   for p:=0 to high(ipH) do win____waveOutUnprepareHeader(ptr,@ipH[p],sizeof(ipH[p]));
   ipdata.clear;
   ippos:=0;
   ipcount:=0;
   ipplaying:=false;
   //close
   for p:=1 to 50 do if (0=waveOutClose(ptr)) then break else win____sleep(200);
   //change format when not playing
   iformatmodified:=false;
   end
else if (iptime<=ms64) then
   begin
   if (ipdata.len>=1) then ipdata.clear;
   end
else iformatmodified:=false;
except;end;
end;

procedure taudiobasic.onmessage(m,w,l:longint);
var
   a:pwavehdr;
   b:tstr8;
   p:longint;
begin
try
//check
if (ihandle=0) then exit;
//decide
case m of
MM_WOM_DONE:begin
   ipcount:=frcmin32(ipcount-1,0);
   pdo;
   end;
MM_WOM_OPEN:ipopen:=true;//26dec2018
MM_WIM_OPEN:;
MM_WIM_DATA:begin
   //check
   if ilocked then exit;//26JUL2009
   //get
   a:=pointer(l);
   if (a<>nil) and (a^.dwBytesRecorded>=1) then
      begin
      try
      //get
      b:=str__new8;
      b.setlen(a^.dwBytesRecorded);
      for p:=0 to (a^.dwBytesRecorded-1) do b.pbytes[p]:=byte(a^.lpData[p]);
      irmaxV:=wkMaxV(r16bit,b);
      //set
      if (irdata.len<=(irsecsize*5)) then irdata.add(b);
      //reset
      win____waveInAddBuffer(irhandle,a,sizeof(twavehdr));
      except;end;
      try;str__free(@b);except;end;
      end;
   end;//begin
end;//case
except;end;
end;

procedure taudiobasic.raoc;//automatic open/close
var
   p:integer;
   ptr:HWAVEIN;
begin
try
//open
if (not irformatmodified) and (irtime>ms64) and (not ilocked) then
   begin
   if (irhandle=0) and (0=waveInOpen(@irhandle,WAVE_MAPPER,@irformat,handle,0,CALLBACK_WINDOW)) then
      begin
      //init
      for p:=0 to high(irH) do
      begin
      fillchar(irB[p],sizeof(irB[p]),0);
      irH[p].lpData:=@irB[p];
      irH[p].dwBufferLength:=irsamplesize;//keep buffer short and responsive
      irH[p].dwUser:=$0;
      irH[p].dwFlags:=$0;
      irH[p].dwLoops:=$0;
      win____waveInPrepareHeader(irhandle,@irH[p],sizeof(irH[p]));
      win____waveInAddBuffer(irhandle,@irH[p],sizeof(irH[p]));
      end;//loop
      irpos:=0;
      ircount:=0;
      //start recording
      win____waveInStart(irhandle);
      irrecording:=true;
      end;
   end
//close
else if (irhandle<>0) and (irformatmodified or ilocked or (irtime<=ms64)) then
   begin
   //clear
   ptr:=irhandle;
   irhandle:=0;
   //stop
   win____waveInStop(irhandle);
   //buffers
   for p:=0 to high(irH) do win____waveInUnprepareHeader(ptr,@irH[p],sizeof(irH[p]));
   irdata.clear;
   irpos:=0;
   ircount:=0;
   irrecording:=false;
   //close
   for p:=1 to 50 do if (0=waveInClose(ptr)) then break else win____sleep(200);
   //change format when not playing
   irformatmodified:=false;
   end
else if (irtime<=ms64) then irdata.clear
else irformatmodified:=false;
except;end;
end;

function taudiobasic.wkMaxV(_16bit:boolean;z:tstr8):integer;
var
   dc,tmp,zlen,step,p:integer;
   v:twrd2;
begin
//defaults
result:=0;
tmp:=0;
dc:=0;

//check
if not str__lock(@z) then exit;

try
//init
if _16bit then step:=2 else step:=1;
//get
p:=1;
zlen:=z.len;
while true do
begin
//get
v.si:=0;
case step of
1:if ((p+0)<zlen) then
   begin
   v.si:=byte(z.bytes1[p+0])-128;
   tmp:=frcrange32(low__posn(round(v.si*1.56)),0,100);//0..100% (half volume/64 = our 100%)
   end;
2:if ((p+1)<zlen) then
   begin
   v.bytes[0]:=z.bytes1[p+0];
   v.bytes[1]:=z.bytes1[p+1];
   tmp:=frcrange32(low__posn(v.si div 167),0,100);//0..100% (half  volume/16,000 = our 100%)
   end;
end;//case
//set
if (tmp>result) then result:=tmp
else
   begin
   inc(dc);
   if (dc>=30) then
      begin
      dc:=0;
      result:=frcmin32(result-1,0);
      end;
   end;
//inc
inc(p,step);
if ((p+1)>zlen) then break;
end;//loop
except;end;
try;str__uaf(@z);except;end;
end;

procedure taudiobasic.wkFast(_16bit:boolean;z:tstr8);
var
   dlen,zlen,step,p:integer;
   v:twrd2;
begin
try
//check
if not str__lock(@z) then exit;
//init
if _16bit then step:=2 else step:=1;
//get
p:=1;
zlen:=z.len;
dlen:=1;
while true do
begin
//get
v.si:=0;
case step of
1:if ((p+1)<zlen) then
   begin
   z.bytes1[dlen]:=z.bytes1[p+0];inc(dlen);//l
   z.bytes1[dlen]:=z.bytes1[p+1];inc(dlen);//r
   end;
2:if ((p+3)<zlen) then
   begin
   z.bytes1[dlen]:=z.bytes1[p+0];inc(dlen);//la
   z.bytes1[dlen]:=z.bytes1[p+1];inc(dlen);//lb
   z.bytes1[dlen]:=z.bytes1[p+2];inc(dlen);//ra
   z.bytes1[dlen]:=z.bytes1[p+3];inc(dlen);//rb
   end;
end;//case
//inc
inc(p,step*4);
if ((p+3)>zlen) then break;
end;//loop
//shorten
if (dlen<zlen) then z.setlen(dlen);
except;end;
try;str__uaf(@z);except;end;
end;

function taudiobasic.pushonline:boolean;
begin
result:=(iphandle<>0);
end;

function taudiobasic.pushlen:integer;//amount of data length in push buffer for playback
begin
result:=ipdata.len;
end;

function taudiobasic.canpush:boolean;
begin
result:=canpushex(2);
end;

function taudiobasic.canpushex(seconds:integer):boolean;
begin
result:=(pushlen<(frcmin32(seconds,1)*isecsize));
end;

function taudiobasic.canpushexMS(ms:integer):boolean;
begin
result:=(pushlen<frcmin32(round((ms/1000)*isecsize),1));
end;
{//yyyyyyyyyyyy - proc below simulates what 3bit audio sounds like (our own audio compression tests - quality=not bad) - 24aug2014
procedure taudiobasic.push16BIT(var data:string);
var
   p:integer;
   w:twrd2;
   ok:boolean;

   procedure pushval(var vIN,vREF:smallint);
   var
      vd,y:integer;
      vdINV:boolean;
   begin
   //get
   vd:=vIN-vREF;
   vdINV:=(vd<0);
   if vdINV then vd:=-vd;//this allows us to use ONE RANGE and then swap back to negative number with requiring TWO RANGES - 24aug2014
   //decide
   case vd of
//   0..500:y:=50;//up
//   501..4000:y:=1000;
//   4001..33000:y:=8000;
   0..350:y:=35;
   351..3000:y:=500;
   3001..7000:y:=2000;
   7001..33000:y:=4000;
   end;
   //invert
   case vdINV of
   false:y:=vREF+y;
   true:y:=vREF-y;
   end;
   //set
   vREF:=frcrange32(y,-32000,32000);
   vIN:=vREF;
   end;
begin
try
//defaults
ok:=false;
//convert
for p:=1 to (low__len(data) div 2) do
begin
w.chars[0]:=data[p*2-1];
w.chars[1]:=data[p*2];
case ok of
true:pushval(w.si,ijunkref1);
false:pushval(w.si,ijunkref2);
end;
data[p*2-1]:=w.chars[0];
data[p*2]:=w.chars[1];
ok:=not ok;
end;//p
//in proc below "push()" insert the line "push16BIT(data)" to compress the data and HEAR what it sounds like!
except;end;
end;
{}//yyyyyyyyyyyyy end of audio compression test - 24aug2014

function taudiobasic.push(data:tstr8):boolean;//14apr2017
begin
//defaults
result:=false;

//check
if not str__lock(@data) then exit;

try
//get
iptime:=ms64+frcmin32(oplay_timeout,5000);//timeout after X milliseconds, range 5000..N - 14apr2017
if (data.len>=1) then
   begin
   ipdata.add(data);
   data.clear;
   //successful
   result:=true;
   end;
except;end;
try;str__uaf(@data);except;end;
end;

function taudiobasic.pullonline:boolean;
begin
result:=(irhandle<>0);
end;

function taudiobasic.canpull:boolean;
begin
result:=pullonline and (irdata.len>=1);
end;

function taudiobasic.pull(data:tstr8):boolean;
begin
//defaults
result:=false;

//check
if not str__lock(@data) then exit;

try
//get
irtime:=ms64+orec_timeout;//timeout after X milliseconds of inactivity, range 5000..N
data.clear;
data.add(irdata);
irdata.clear;
//.rvolume - 26mar2015
if (irvolume<>100) then wkAdjustVolume(r16bit,data,irvolume);
result:=(data.len>=1);
except;end;
try;str__uaf(@data);except;end;
end;

//## tmm #######################################################################
constructor tmm.create;
begin//sate: 0=nil, 1=opened, 2=playing, 3=closing
//self
inherited create;
if classnameis('tmm') then track__inc(satMM,1);
//defaults
itracknumber:=1;
itrackformat:=false;//if true then media being played (eg CD) uses tracks to play it's data and must use different procs for this
istate:=msFree;
ihandle:=0;
ideviceid:=0;
ifilename:='';
ivalid:=false;
inewposition:=-1;
//timer - fast
low__timerset(self,_ontimer,50);//start timer
end;

destructor tmm.destroy;
begin
try
//timer
low__timerdel(self,_ontimer);//disconnect our timer event from the system timer
//stop
stop;
//handle
if (ihandle<>0) then ihandle:=0;
//self
if classnameis('tmm') then track__inc(satMM,-1);
inherited destroy;
//sd
except;end;
end;

function tmm.positionBUSY:boolean;//we are waiting for "inewposition" to be implemented - 23MAY2013
begin
result:=(inewposition>=0);
end;

procedure tmm._ontimer(sender:tobject);
label
   skipend;
var
   genparm:tmci_generic_parms;
   playparm:tmci_play_parms;
begin
try
//range
if (istate=msFree) and (inewposition>=0) then inewposition:=-1;//automatic safe reset - 23MAY2013
//.newposition
if ivalid and (istate=msWorking) and (inewposition>=0) and (inewposition>=ilength) then inewposition:=frcmin32(ilength-1,-1);
//.position
if ivalid and (istate=msWorking) and (ilength>=0) and (inewposition>=0) then
   begin
   //set
   try
   //soft stop
   fillchar(genparm,sizeof(@genparm),#0);
   genparm.dwCallback:=handle;
   win____mciSendCommand(ideviceid,mci_stop,longint(mci_notify or mci_wait),longint(@genparm));
   //play - new position
   fillchar(playparm,sizeof(playparm),#0);
   playparm.dwCallback:=handle;
   playparm.dwFrom:=itrackstart+frcrange32(frcmax32(inewposition,ilength-1),0,ilength);
   win____mciSendCommand(ideviceid,mci_play,longint(mci_from or mci_notify),longint(@playparm));
   except;end;
   //reset
   inewposition:=-1;
   end;
//stop/loop - 01MAY2011
if (oLoop or oAutostop) and ivalid and (istate=msWorking) and (position>=len) then
   begin
   if oLoop then inewposition:=0//start at the begining
   else if oAutostop then stop;//stop playback
   end;
skipend:
except;end;
end;

function tmm.canplay:boolean;
begin
result:=(istate=msFree) or (istate=msWorking);
end;

function tmm.getplaying:boolean;
begin
result:=(istate<>msFree);
end;

function tmm.play(x:string;var e:string):boolean;//reinforced, 12AUG2010
label
   skipend;
var
   z:integer;
   s:currency;
   statusparm:tmci_status_parms;
   fflags:longint;

   function len:longint;
   begin
   //defaults
   result:=0;

   try
   //track ms
   fflags:=mci_Wait or mci_status_Item or mci_track;
   statusparm.dwItem:=mci_status_length;
   statusParm.dwTrack:=longint(itracknumber);
   win____mciSendCommand(ideviceid,mci_status,fflags,longint(@statusparm));
   if (0=win____mciSendCommand(ideviceid,mci_status,fflags,longint(@statusparm))) then result:=frcmin32(statusparm.dwReturn,0);
   except;end;
   end;
begin
//defaults
result:=false;
e:=gecUnexpectedError;
iplayBUSY:=true;

try
//check
if canplay then
   begin
   //.stop
   stop;
   //.init
   istate:=msHold;
   ivalid:=false;
   end
else exit;
//process
//.get
iformat:='';//reset - 19MAY2013
ifilename:=x;
if not io__fileexists(x) then
   begin
   e:=gecFileNotFound;
   goto skipend;
   end;
//.open
if not _open(e) then goto skipend;
istate:=msQueued;
//.length
s:=ms64+5000;
z:=0;
while TRUE do
begin
z:=len;
if (z>=1) then break
else if (ms64>s) then break
end;
ilength:=(z div 10)*10;//round down for CD's last track
if (ilength=0) then goto skipend;
//.trackpos
fflags:=mci_wait or mci_status_item or mci_track;
statusparm.dwItem:=mci_status_position;
statusparm.dwTrack:=longint(itracknumber);
if (0=win____mciSendCommand(ideviceid,mci_status,fflags,longint(@statusparm))) then itrackstart:=frcmin32(statusparm.dwReturn,0) else itrackstart:=0;
//.play
if not _play(e) then goto skipend;
//successful
istate:=msWorking;
ivalid:=true;
result:=true;
skipend:
except;end;
try
inewposition:=-1;//reset
if (not result) then stop;
iplayBUSY:=false;
except;end;
end;

function tmm.canstop:boolean;
begin
result:=(istate<>msFree) and (not istoplock);
end;

procedure tmm.stop;
begin
try
//check
if not canstop then exit;
//process
//.istoplock
istoplock:=true;
//.stop
_stop;
//.free
ivalid:=false;
istate:=msFree;
//.event
low__fireevent(self,onstop);//20feb2022
except;end;
try;istoplock:=false;except;end;
end;

procedure tmm._stop;
var
   genparm:tmci_generic_parms;
begin
try
if (ideviceid<>0) then
   begin
   //#1 - soft stop - CDAudio
   fillchar(genparm,sizeof(@genparm),#0);
   genparm.dwCallback:=handle;
   win____mciSendCommand(ideviceid,mci_stop,longint(mci_notify or mci_wait),longint(@genparm));
   //#2 - close for all others
   genparm.dwCallback:=0;//handle;
   win____mciSendCommand(ideviceid,mci_close,longint(mci_wait),longint(@genparm));
   ideviceid:=0;
   end;
except;end;
try
ilength:=0;
inewposition:=-1;//not in use
except;end;
end;

function tmm._open(var e:string):boolean;
label
   skipone,skipend;
var
   openparm:tmci_open_parms;
   setparm:tmci_set_parms;
   _tracknumber,ferror,fflags:longint;
   ext:string;
begin
//defaults
result:=false;
e:=gecUnexpectedError;
ext:='';
_tracknumber:=1;

//check
if (istate<>msHold) then exit;

try
//process
//.fill
fillchar(openparm,sizeof(openparm),0);
openparm.dwCallback:=0;
//..Note: must convert "long filenames => short filename" since "MCI" can only handle ~125c filenames safely, after this they fail to open/play - 23FEB2008
//..Also: "misc.shortfile" only works for existing filenames (short names accessed from disk system)
if (ifilename<>'') then
   begin
   //.nn smart cache - 26feb2015
   openparm.lpstrElementName:=pchar(io__shortfile(ifilename));
   ext:=io__readfileext(ifilename,true);
   //.device type
   if (ext='CDA') then
      begin
      openparm.lpstrDeviceType:=pchar('CDAudio');
      _tracknumber:=strint(copy(ifilename,low__len(ifilename)-5,2));
      end;
   end;
itrackformat:=(string(openparm.lpstrDeviceType)<>'');
itracknumber:=frcmin32(_tracknumber,1);
//..flags
fflags:=mci_wait;
if (ifilename<>'') then fflags:=fflags or mci_open_element;
if itrackformat then fflags:=fflags or mci_open_type;//CDA => CDAudio
//.set
ferror:=win____mciSendCommand(0,mci_open,fflags,longint(@openparm));
skipone:
if (ferror<>0) then
   begin
   e:=gecTaskFailed;
   goto skipend;
   end;
//successful
ideviceid:=openparm.wdeviceid;
//time format - milliseconds
fillchar(setparm,sizeof(setparm),#0);
setparm.dwTimeFormat:=longint(0);
win____mciSendCommand(ideviceid,mci_set,longint(mci_set_time_format or mci_wait),longint(@setparm));
//successful
result:=true;
skipend:
except;end;
end;

function tmm._play(var e:string):boolean;
var
   playparm:tmci_play_parms;
   ferror:longint;
begin
//defaults
result:=false;
e:=gecUnexpectedError;

try
//check
if (istate<>msQueued) then exit;
//set
//.ms
fillchar(playparm,sizeof(playparm),#0);
playparm.dwCallback:=handle;
//Note: XP can't handle playing a short fast midi when "mci_from" flag is specified - a double ding ship's bell fails sometimes to play BOTH DONGS - 29SEP2010
if (itrackstart>=1) then
   begin
   playparm.dwFrom:=itrackstart;
   ferror:=win____mciSendCommand(ideviceid,mci_play,longint(mci_from or mci_notify),longint(@playparm));
   end
else ferror:=win____mciSendCommand(ideviceid,mci_play,longint(mci_notify),longint(@playparm));

//return result
result:=(ferror=0);
except;end;
end;

function tmm.gethandle:hwnd;
begin
if (ihandle=0) then ihandle:=app__wproc.window;//system message handler - shared
result:=ihandle;
end;

function tmm.getmode:tmmodes;
var
   statusparm:tmci_status_parms;
   ferror,fflags:longint;
begin
if ivalid then
   begin
   fflags:=mci_wait or mci_status_item;
   statusparm.dwItem:=mci_status_mode;
   try;ferror:=win____mciSendCommand(ideviceid,mci_status,fflags,longint(@statusparm));except;end;
   result:=tmmodes(statusparm.dwReturn-524);//MCI Mode #s are 524+enum
   end
else result:=mmNotReady;
end;

function tmm.getposition:longint;
var
   statusparm:tmci_status_parms;
   ferror,fflags:longint;
begin
if ivalid then
   begin
   ferror:=0;
   fflags:=mci_wait or mci_status_item;
   statusparm.dwItem:=mci_status_position;
   try;ferror:=win____mciSendCommand(ideviceid,mci_status,fflags,longint(@statusparm));except;end;
   if (ferror=0) then result:=frcmin32(statusparm.dwReturn,0) else result:=0;//04JUL2010

   //adjust for track
   result:=frcrange32(result-itrackstart,0,ilength);
   end
else result:=0;
end;

procedure tmm.setposition(x:longint);
begin
if (x>=0) then inewposition:=x;
end;

function tmm.getpertpos:double;
begin
if ivalid then result:=low__makepertD0(position,len) else result:=0;
end;

procedure tmm.setnewpertpos(x:double);
begin
//range
if (x<0) then x:=0 else if (x>100) then x:=100;
//get
inewpertpos:=x;
end;

procedure tmm.onmessage(m,w,l:longint);
begin
case m of
mm_mcinotify:begin
   case w of
   mci_notify_aborted,mci_notify_successful,mci_notify_failure:;
   end;
   end;
end;
end;

end.
