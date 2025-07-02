unit gossio;

interface
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot, gosswin;
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
//## Library.................. disk/folder/file support (gossio.pas)
//## Version.................. 4.00.5027 (+311)
//## Items.................... 6
//## Last Updated ............ 12jun2025, 01jun2025, 28may2025, 01may2025, 11apr2025, 31mar2025, 21mar2025, 08mar2025, 20feb2025, 11jan2025, 18dec2024, 18nov2024, 15nov2024, 22aug2024, 20jul2024, 23jun2024, 30apr2024
//## Lines of Code............ 5,400+
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
//## | filecache__*           | family of procs   | 1.00.152  | 29apr2024   | Cache open file handles for faster repeat file IO operations, 12apr2024: created
//## | io__*                  | family of procs   | 1.00.3700 | 12jun2025   | Disk, folder and file procs + 64bit file support, 11jun2025, 18may2025, 14may2025, 11apr2025, 20feb2025, 25jan2025, 11jan2025: fixed "io__fromfile64c()" for "!:\" files, 20dec2024, 16dec2024: io__copyfile upgraded, 18nov2024: tea3 format detection, 22aug2024: io__folderlist procs added, 19jul2024: io__filelist1/21() subfolder support added, 30apr2024: fixed io__ double ptr ref, 30apr2024: io__tofileex64() updated to flush buffer for correct nav__* filesize reporting, 17apr2024: procs renamed
//## | nav__*                 | family of procs   | 1.00.300  | 26feb2024   | Worker procs for file/folder/navigation lists
//## | idisk__*               | family of procs   | 1.00.132  | 15mar2025   | Internal disk support "!:\" - 20jul2024: reintegrated into Gossamer
//## | s12__*                 | family of procs   | 1.00.045  | 08mar2025   | Read/write 12bit io streams
//## | tstorage               | tobjectex         | 1.00.085  | 21mar2025   | Storage manager for accessing and using files packed into a Pascal unit
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================

type
   //.tfilecache
   pfilecache=^tfilecache;
   tfilecache=record
    init:boolean;
    //.time + used
    time_created:comp;//time this record was created
    time_idle:comp;//used for idle timeout detection
    //.name
    filenameREF:comp;
    filename:string;
    opencount:longint;
    usecount:longint;//increments each time the record is reused -> procs can detect if their record has been reused and abort
    //.handle to file
    filehandle:thandle;
    //.access
    read:boolean;
    write:boolean;
    //.info
    slot:longint;
    end;

   ps12_info=^ts12_info;
   ts12_info=record
    s:pobject;//pointer to stream object (tstr8 or tstr9)
    s8:tstr8;//is not nil when s=tstr8
    slot:longint;
    cval:longint;
    xpos:longint;
    xlen:longint;
    xeos:longint;//-1=not used
    //.support
    pullval1:longint;
    pullval2:longint;
    v1:longint;
    v2:longint;
    v3:longint;
    end;

{tstorage}
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxx//111111111111111111
   tstorage=class(tobjectex)
   private
    ifilesinuse:boolean;
    icount     :longint;
    inull      :tstr8;
    ipathname  :array[0..999] of string;
    ipath      :array[0..999] of string;
    iname      :array[0..999] of string;
    ibarename  :array[0..999] of string;//no path and no ext
    iext       :array[0..999] of string;
    iptr       :array[0..999] of pointer;
    isize      :array[0..999] of longint;
    izip       :array[0..999] of boolean;
    idata      :array[0..999] of tstr8;
    ilockcount :array[0..999] of longint;//number of instances that are using this file
    function getpathname(x:longint):string;
    function getpath(x:longint):string;
    function getname(x:longint):string;
    function getbarename(x:longint):string;
    function getext(x:longint):string;
    function getsize(x:longint):longint;
    function getzip(x:longint):boolean;
    function getlockcount(x:longint):longint;
   public
    //data filters
    odatafilter_txt_matchwordcore:boolean;//default=false
    //create
    constructor create; override;
    destructor destroy; override;
    //information
    property count:longint                read icount;
    property pathname[x:longint]:string   read getpathname;
    property path[x:longint]:string       read getpath;
    property name[x:longint]:string       read getname;
    property barename[x:longint]:string   read getbarename;
    property ext[x:longint]:string        read getext;
    property size[x:longint]:longint      read getsize;
    property zip[x:longint]:boolean       read getzip;
    property lockcount[x:longint]:longint read getlockcount;
    //fill
    function canfill:boolean;
    function fill(const xstorageproc:tstorageproc):boolean;
    //clear
    function canclear:boolean;
    function clear:boolean;
    //find
    function findbyslot(xindex:longint;var xdataptr:tstr8):boolean;//returns a pointer to file datastream
   end;

var
   //.started
   system_started               :boolean=false;
   //.filecache
   system_filecache_limit       :longint=20;//0..20=file caching is off, 21..200=file caching is on - 29apr2024
   system_filecache_timer       :comp=0;
   system_filecache_slot        :array[0..199] of tfilecache;
   system_filecache_filecount   :comp=0;//count actual file opens
   system_filecache_count       :longint=0;//last slot open+1
   system_filecache_active      :longint=0;//exact number of slots open

   //internal disk support -----------------------------------------------------
   intdisk_inuse                :boolean=false;//false=not in use (default)
   intdisk_char                 :char='!';//e.g. "!:\"
   intdisk_label                :string='Samples';//volume label
   intdisk_name                 :array[0..199] of string;
   intdisk_data                 :array[0..199] of tobject;//nil by default - can be eitehr tstr8 or tstr9
   intdisk_date                 :array[0..199] of tdatetime;
   intdisk_readonly             :array[0..199] of boolean;

   //shared storage ------------------------------------------------------------
   //note: accesses file content from "storage__findfile()" proc
   sysshared_storagecount   :longint=0;
   sysshared_storage        :tstorage=nil;

   //memory mapped file support ------------------------------------------------
   sysmemfile_slotsinit     :boolean=false;
   sysmemfile_slots         :array[0..9] of thandle;
   sysmemfile_slotdata      :array[0..9] of pointer;
   sysmemfile_slotsize      :array[0..9] of longint;

   
//start-stop procs -------------------------------------------------------------
procedure gossio__start;
procedure gossio__stop;


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function app__bol(xname:string):boolean;
function info__io(xname:string):string;//information specific to this unit of code


//win32 folder procs -----------------------------------------------------------
function io__findfolder(x:longint;var y:string):boolean;//17jan2007
function io__appdata:string;//out of date
function io__windrive:string;//14DEC2010
function io__winroot:string;//11DEC2010
function io__winsystem:string;//11DEC2010
function io__wintemp:string;//11DEC2010
function io__windesktop:string;//17MAY2013
function io__winstartup:string;
function io__winprograms:string;//start button > programs > - 11NOV2010
function io__winstartmenu:string;


//disk, folder and file procs --------------------------------------------------
procedure io__createlink(const df,sf,dswitches,iconfilename:string);//10apr2019, 14NOV2010
function io__exename:string;
function io__ownname:string;
function io__dates__filedatetime(x:tfiletime):tdatetime;
function io__dates__fileage(x:thandle):tdatetime;
function io__lastext(const x:string):string;//returns last extension - 03mar2021
function io__lastext2(x:string;xifnodotusex:boolean):string;//returns last extension - 03mar2021
function io__remlastext(const x:string):string;//remove last extension
function io__readfileext(const x:string;fu:boolean):string;{Date: 24-DEC-2004, Superceeds "ExtractFileExt"}
function io__readfileext_low(const x:string):string;//30jan2022
function io__findext(s:string;var xoutlabel,xoutext,xoutmask:string):boolean;
function io__forceext(const xfilename,xforceext:string):string;
function io__forceext2(const xfilename,xforceext:string;xappend:boolean):string;
function io__scandownto(const x:string;y,stopA,stopB:char;var a,b:string):boolean;
function io__faISfolder(x:longint):boolean;//05JUN2013
function io__mssortstr(const s:string):string;//12jun2025, 01jun2025, 29may2025
function io__safename(const x:string):string;//08apr2025, 07mar2021, 08mar2016
function io__safefilename(const x:string;allowpath:boolean):string;//08apr2025, 07mar2021, 08mar2016
function io__issafefilename(const x:string):boolean;//07mar2021, 10APR2010
function io__hack_dangerous_filepath_allow_mask(const x:string):boolean;
function io__hack_dangerous_filepath_deny_mask(const x:string):boolean;
function io__hack_dangerous_filepath(const x:string;xstrict_no_mask:boolean):boolean;
function io__makeportablefilename(const filename:string):string;//11sep2021, 06oct2020, 14APR2011
function io__readportablefilename(const filename:string):string;//11sep2021
function io__extractfileext(const x:string):string;//12apr2021
function io__extractfileext2(const x,xdefext:string;xuppercase:boolean):string;//12apr2021
function io__extractfileext3(const x,xdefext:string):string;//lowercase version - 15feb2022
function io__lastfoldername(const xfolder,xdefaultname:string):string;
function io__extractfilepath(const x:string):string;//04apr2021
function io__extractfilename(const x:string):string;//05apr2021
function io__renamefile(const s,d:string):boolean;//local only, soft check - 27nov2016
function io__shortfile(const xlongfilename:string):string;//translate long filenames to short filename, using MS api, for "MCI playback of filenames with 125+c" - 23FEB2008
function io__asfolder(const x:string):string;//enforces trailing "\"
function io__asfolderNIL(const x:string):string;//enforces trailing "\" AND permits NIL - 03apr2021, 10mar2014
function io__folderaslabel(x:string):string;
function io__isfile(const x:string):boolean;
function io__local(const x:string):boolean;
function io__canshowfolder(const x:string):boolean;//18may2025
function io__driveexists(const x:string):boolean;//true=drive has content - 01may2025, 17may2021, 16feb2016, 25feb2015, 17AUG2010
function io__drivetype(const x:string):string;//15apr2021, 05apr2021
function io__drivelabel(const x:string;xfancy:boolean):string;//17may2021, 05apr2021
function io__fileexists(const x:string):boolean;//01may2025, 04apr2021, 15mar2020, 19may2019
function io__filesize64(const x:string):comp;//24dec2023
function io__filedateb(const x:string):tdatetime;//27jan2022
function io__filedate(const x:string;var xdate:tdatetime):boolean;//24dec2023, 27jan2022
function io__filesize_atleast(const df:string;dsize:comp):boolean;//11aug2024
function io__validfilename(const x:string):boolean;//31mar2025
function io__remfile(const x:string):boolean;//31mar2025
procedure io__filesetattr(const x:string;xval:longint);//01may2025
function io__copyfile(const sf,df:string;var e:string):boolean;//16dec2024: upgraded to handle large files
function io__backupfilename(dname:string):string;//12feb2023
function io__tofilestr(const x,xdata:string;var e:string):boolean;//fast and basic low-level
function io__tofilestr2(const x,xdata:string):boolean;//fast and basic low-level
function io__tofile(const x:string;xdata:pobject;var e:string):boolean;//31mar2025, 27sep2022, fast and basic low-level
function io__tofile64(const x:string;xdata:pobject;var e:string):boolean;//31mar2025, 27sep2022, fast and basic low-level
function io__tofileex64(const x:string;xdata:pobject;xfrom:comp;xreplace:boolean;var e:string):boolean;//30apr2024: flush file buffers for correct "nav__*" filesize info, 06feb2024, 22jan2024, 27sep2022, fast and basic low-level
function io__exemarker(x:tstr8):boolean;//14nov2023
function io__exereadFROMFILE(const xfilename:string;xexedata,xsysdata,xprgdata,xusrdata:tstr8;xsysmore:tvars8;var e:string):boolean;//14nov2023
function io__exeread(s,xexedata,xsysdata,xprgdata,xusrdata:tstr8;xsysmore:tvars8):boolean;//14nov2023
function io__exewriteTOFILE(xfilename:string;xexedata,xsysdata,xprgdata,xusrdata:tstr8;xsysmore:tvars8;var e:string):boolean;//14nov2023
function io__exewrite(d,xexedata,xsysdata,xprgdata,xusrdata:tstr8;xsysmore:tvars8):boolean;//14nov2023
function io__fromfile(const x:string;xdata:pobject;var e:string):boolean;//31mar2025
function io__fromfile64(const x:string;xdata:pobject;var e:string):boolean;//31mar2025
function io__fromfile641(const x:string;xdata:pobject;xappend:boolean;var e:string):boolean;//31mar2025, 04feb2024
function io__fromfile64b(const x:string;xdata:pobject;var e:string;var _filesize,_from:comp;_size:comp;var _date:tdatetime):boolean;//31mar2025, 24dec2023, 20oct2006
function io__fromfile64d(const x:string;xdata:pobject;xappend:boolean;var e:string;var _filesize:comp;_from:comp;_size:comp;var _date:tdatetime):boolean;//31mar2025, 06feb2024, 24dec2023, 20oct2006
function io__fromfile64c(const x:string;xdata:pobject;xappend:boolean;var e:string;var _filesize,_from:comp;_size:comp;var _date:tdatetime):boolean;//31mar2025, 11jan2025, 06feb2024, 24dec2023, 20oct2006
function io__fromfilestrb(const x:string;var e:string):string;//30mar2022
function io__fromfilestr(const x:string;var xdata,e:string):boolean;
function io__drivelist:tdrivelist;
function io__fromfiletime(x:tfiletime):tdatetime;
function io__folderexists(const x:string):boolean;//01may2025, 15mar2020, 14dec2016
function io__deletefolder(x:string):boolean;//13feb2024
function io__makefolder(x:string):boolean;//01may2025, 15mar2020, 19may2019
function io__makefolder2(const x:string):string;//01may2025
//.simple file list support - 19jul2024, 31dec2023, 06oct2022
function io__filelist(xoutlist:tdynamicstring;xfullfilenames:boolean;xfolder,xmasklist,xemasklist:string):boolean;//06oct2022
function io__filelist1(xoutlist:tdynamicstring;xfullfilenames,xsubfolders:boolean;xfolder,xmasklist,xemasklist:string):boolean;//06oct2022
function io__filelist2(xoutlist:tdynamicstring;xfullfilenames:boolean;xfolder,xmasklist,xemasklist:string;xtotalsizelimit,xminsize,xmaxsize:comp;xminmax_emasklist:string):boolean;//31dec2023, 06oct2022
function io__filelist21(xoutlist:tdynamicstring;xfullfilenames,xsubfolders:boolean;xscanfolder,xfolder,xmasklist,xemasklist:string;xtotalsizelimit,xminsize,xmaxsize:comp;xminmax_emasklist:string):boolean;//18mar2025: fixed sub-folder failure, 20aug2024, 31dec2023, 06oct2022
function io__filelist3(xfolder,xmasklist,xemasklist:string;xfiles,xfolders,xsubfolders:boolean;xevent:tsearchrecevent;xevent2:tsearchrecevent2;xhelper:tobject):boolean;//31dec2023
//.simple folder list support - 22aug2024
function io__folderlist(xoutlist:tdynamicstring;xfullfoldernames:boolean;xfolder,xmasklist,xemasklist:string):boolean;//22aug2024
function io__folderlist2(xoutlist:tdynamicstring;xfullfoldernames,xsubfolders:boolean;xfolder,xmasklist,xemasklist:string):boolean;//22aug2024
function io__folderlist21(xoutlist:tdynamicstring;xfullfoldernames,xsubfolders:boolean;xscanfolder,xfolder,xmasklist,xemasklist:string):boolean;//18mar2025, 22aug2024


//file format procs ------------------------------------------------------------
function io__findimagewh(xdata:pobject;var xformat:string;var xw,xh:longint):boolean;//19feb2025: works for image formats BMP, JPG, PNG, GIF, TEA and TGA
function io__anyformatb(xdata:pobject):string;
function io__anyformat2b(xdata:pobject;xfrompos:longint):string;
function io__anyformat(xdata:pobject;var xformat:string):boolean;//returns EXT of any known format, image, sound, frame, etc - 14may2025, 20dec2024, 18nov2024, 30jan2021
function io__anyformat2(xdata:pobject;xfrompos:longint;var xformat:string):boolean;//returns EXT of any known format, image, sound, frame, etc - 11jun2025, 14may2025, 20dec2024, 18nov2024, 30jan2021
function io__anyformata(const xdata:array of byte):string;//19feb2025, 25jan2025


//filecache procs --------------------------------------------------------------
//caches open file handles (not file content)
//.init
function filecache__recok(x:pfilecache):boolean;
procedure filecache__initrec(x:pfilecache;xslot:longint);//used internally by system
function filecache__idletime:comp;
function filecache__enabled:boolean;
function filecache__limit:longint;
function filecache__safefilename(const x:string):boolean;
//.find
function filecache__find(const x:string;xread,xwrite:boolean;var xslot:longint):boolean;//13apr2024: updated
function filecache__newslot:longint;
procedure filecache__inc_usecount(x:pfilecache);
//.close
procedure filecache__closeall;
procedure filecache__closeall_rightnow;
procedure filecache__closerec(x:pfilecache);
procedure filecache__closefile(var x:pfilecache);
procedure filecache__closeall_byname_rightnow(const x:string);
function filecache__remfile(const x:string):boolean;
//.open
function filecache__openfile_anyORread(const x:string;var v:pfilecache;var vmustclose:boolean;var e:string):boolean;//for info purposes such as filesize and filedate, not for reading/writing file content
function filecache__openfile_read(const x:string;var v:pfilecache;var e:string):boolean;
function filecache__openfile_write(const x:string;var v:pfilecache;var e:string):boolean;
function filecache__openfile_write2(const x:string;xremfile_first:boolean;var xfilecreated:boolean;var v:pfilecache;var e:string):boolean;
//.management
procedure filecache__managementevent;


//nav procs (file list support) ------------------------------------------------
//note: builds a filelist with support for (a) nav list, (b) folders, (c) files, (d) fav folders etc - used by open/save/folder windows and low level file listing procs
//note: normal sequence: init() + add()/add()/add() + end() -> packs a 4 way sorted (name,size,date,type) nav/folder/file list(s) into a single compact data structure with rapid data access via low__navget - 25sep2020
//version: 1.00.250 / date: 06apr2021, 20feb2021, 25sep2020
function nav__init(x:tstr8):boolean;
function nav__add(x:tstr8;xstyle,xtep:longint;xsize:comp;const xname,xlabel:string):boolean;
function nav__add2(x:tstr8;xstyle,xtep:longint;xsize:comp;xyear,xmonth,xday,xhr,xmin,xsec:longint;xname,xlabel:string):boolean;
function nav__sort(x:tstr8;xsortstyle:longint):boolean;
function nav__end(x:tstr8;xsortstyle:longint):boolean;
function nav__count(x:tstr8):longint;//28dec2023
function nav__info(x:tstr8;var xnavcount,xfoldercount,xfilecount,xtotalcount:longint):boolean;
function nav__get(x:tstr8;xindex:longint;var xstyle,xtep:longint;var xsize:comp;var xname,xlabel:string):boolean;
function nav__get2(x:tstr8;xindex:longint;var xstyle,xtep:longint;var xsize:comp;var xyear,xmonth,xday,xhr,xmin,xsec:longint;var xname,xlabel:string):boolean;
function nav__date(sdate:comp;var xyear,xmonth,xday,xhr,xmin,xsec:longint):boolean;//01feb2024
function nav__list(x:tstr8;xsortstyle:longint;const xfolder,xmasklist,xemasklist:string;xnav,xfolders,xfiles:boolean):boolean;//04oct2020
function nav__list2(xownerid:longint;x:tstr8;xsortstyle:longint;const xfolder,xmasklist,xemasklist:string;xnav,xfolders,xfiles:boolean):boolean;//supports custom folder images when "xownerid>=1" - 06apr2021, 04oct2020
function nav__list3(xownerid:longint;x:tstr8;xsortstyle:longint;xfolder,xmasklist,xemasklist:string;xnav,xfolders,xfiles:boolean;xminsize,xmaxsize:comp;xminmax_emasklist:string):boolean;//26feb2024: Upgraded 32bit filesize to 64bit, 04oct2020
function nav__proc(x:tstr8;xcmd:string;xindex:longint;var xstyle,xtep,xval1,xval2,xval3:longint;var xsize,xdate:comp;var xname,xlabel:string):boolean;//04apr2021, 25mar2021, 20feb2021


//internal disk procs ----------------------------------------------------------
procedure idisk__init(const xnewlabel:string;const xteadata:array of byte);
function idisk__fullname(const x:string):string;
function idisk__findnext(var xpos:longint;xfolder:string;xfolders,xfiles:boolean;var xoutname,xoutnameonly:string;var xoutfolder,xoutfile:boolean;var xoutdate:tdatetime;var xoutsize:comp;var xoutreadonly:boolean):boolean;
function idisk__havescope(const xname:string):boolean;
function idisk__makefolder(xname:string;var e:string):boolean;
function idisk__folderexists(const xname:string):boolean;
function idisk__fileexists(const xname:string):boolean;
function idisk__find(const xname:string;xcreatenew:boolean;var xindex:longint):boolean;
function idisk__remfile(const xname:string):boolean;
function idisk__tofile(const xname:string;xdata:pobject;var e:string):boolean;//30sep2021
function idisk__tofile1(xname:string;xdata:pobject;xdecompressdata:boolean;var e:string):boolean;//30sep2021
function idisk__tofile2(const xname:string;const xdata:array of byte;var e:string):boolean;//14apr2021
function idisk__tofile21(const xname:string;const xdata:array of byte;xdecompressdata:boolean;var e:string):boolean;//14apr2021
function idisk__fromfile(xname:string;xdata:pobject;var e:string):boolean;


//12bit stream procs -----------------------------------------------------------
function s12__pushinit(s:pobject;var sinfo:ts12_info;xappend:boolean;xeosCode:longint):boolean;
function s12__pushval(var sinfo:ts12_info;xval:longint):boolean;
function s12__pushEOS(var sinfo:ts12_info):boolean;//end of stream
function s12__pullinit(s:pobject;var sinfo:ts12_info;sfrom,xeosCode:longint):boolean;
function s12__pullval(var sinfo:ts12_info;var xval:longint):boolean;


implementation

uses gossimg {$ifdef gui},gossgui{$endif};


//start-stop procs -------------------------------------------------------------
procedure gossio__start;
var
   p:longint;
   xdatetime:tdatetime;
begin
try
//check
if system_started then exit else system_started:=true;

//filecache support
for p:=0 to (system_filecache_limit-1) do filecache__initrec(@system_filecache_slot[p],p);

//internal disk support --------------------------------------------------------
xdatetime:=date__now;
for p:=0 to high(intdisk_name) do
begin
intdisk_name[p]:='';
intdisk_data[p]:=nil;
intdisk_date[p]:=xdatetime;
intdisk_readonly[p]:=false;
end;//p

except;end;
end;

procedure gossio__stop;
var
   p:longint;
begin
try
//check
if not system_started then exit else system_started:=false;

//filecache - closeall open file handles - 13apr2024
filecache__closeall_rightnow;

//close internal disk
for p:=0 to high(intdisk_name) do
begin
intdisk_name[p]:='';
str__free(@intdisk_data[p]);
intdisk_readonly[p]:=false;
end;//p
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

function info__io(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gossio.*"
if (strcopy1(xname,1,7)='gossio.') then strdel1(xname,1,7) else exit;

//get
if      (xname='ver')        then result:='4.00.5027'
else if (xname='date')       then result:='12jun2025'
else if (xname='name')       then result:='IO'
else
   begin
   //nil
   end;

except;end;
end;


//## tstorage ##################################################################
constructor tstorage.create;//17feb2024
var
   p:longint;
begin
if classnameis('tstorage') then track__inc(satOther,1);
inherited create;

//data filters
odatafilter_txt_matchwordcore  :=false;

//vars
ifilesinuse   :=false;
icount        :=0;
inull         :=str__new8;

for p:=0 to high(idata) do
begin
idata      [p]:=nil;
ipathname  [p]:='';
ipath      [p]:='';
iname      [p]:='';
ibarename  [p]:='';
iext       [p]:='';
iptr       [p]:=nil;
isize      [p]:=0;
izip       [p]:=false;
ilockcount [p]:=0;
end;//p

end;

destructor tstorage.destroy;
var
   p:longint;
begin
try
//file list
icount:=0;
for p:=0 to high(idata) do str__free(@idata[p]);
str__free(@inull);

//self
inherited destroy;
if classnameis('tstorage') then track__inc(satOther,-1);
except;end;
end;

function tstorage.getpathname(x:longint):string;
begin
if (x>=0) and (x<icount) then result:=ipathname[x] else result:='';
end;

function tstorage.getpath(x:longint):string;
begin
if (x>=0) and (x<icount) then result:=ipath[x] else result:='';
end;

function tstorage.getname(x:longint):string;
begin
if (x>=0) and (x<icount) then result:=iname[x] else result:='';
end;

function tstorage.getbarename(x:longint):string;
begin
if (x>=0) and (x<icount) then result:=ibarename[x] else result:='';
end;

function tstorage.getext(x:longint):string;
begin
if (x>=0) and (x<icount) then result:=iext[x] else result:='';
end;

function tstorage.getsize(x:longint):longint;
begin
if (x>=0) and (x<icount) then result:=isize[x] else result:=0;
end;

function tstorage.getzip(x:longint):boolean;
begin
if (x>=0) and (x<icount) then result:=izip[x] else result:=false;
end;

function tstorage.getlockcount(x:longint):longint;
begin
if (x>=0) and (x<icount) then result:=ilockcount[x] else result:=0;
end;

function tstorage.canclear:boolean;
begin
result:=(not ifilesinuse);
end;

function tstorage.clear:boolean;
var
   int1,p:longint;
begin
//defaults
result:=false;

//get
if canclear then
   begin
   int1   :=icount;
   icount :=0;

   for p:=0 to (int1-1) do
   begin
   if (idata[p]<>nil) then str__free(@idata);

   ipathname  [p]:='';
   ipath      [p]:='';
   iname      [p]:='';
   ibarename  [p]:='';
   iext       [p]:='';
   iptr       [p]:=nil;
   isize      [p]:=0;
   izip       [p]:=false;
   ilockcount [p]:=0;
   end;//p

   end;
end;

function tstorage.canfill:boolean;
begin
result:=(not ifilesinuse);
end;

function tstorage.fill(const xstorageproc:tstorageproc):boolean;
var
   xpos:longint;

   function fadd(var xindex:longint):boolean;//add file
   var
      xsize,p:longint;
      xptr:pointer;
      xfound,xzip:boolean;
      xpathname:string;
   begin
   //defaults
   result:=false;

   //range
   if (xindex<0) then xindex:=0;

   //add
   if (icount<=high(idata)) and xstorageproc(xindex,xptr,xsize,xzip,xpathname) then
      begin
      result:=true;

      iptr      [icount]   :=xptr;
      isize     [icount]   :=xsize;
      izip      [icount]   :=xzip;
      ipathname [icount]   :=xpathname;

      //path + name
      xfound:=false;

      for p:=low__len(xpathname) downto 1 do if (xpathname[p-1+stroffset]='\') or (xpathname[p-1+stroffset]='/') then
         begin
         xfound       :=true;
         ipath[icount]:=strcopy1(xpathname,1,p);
         iname[icount]:=strcopy1(xpathname,p+1,low__len(xpathname));
         break;
         end;

      if not xfound then iname[icount]:=xpathname;

      //barename
      ibarename[icount]:=io__remlastext(iname[icount]);

      //ext
      iext[icount]:=strlow(io__lastext(iname[icount]));

      //inc
      inc(icount);
      end;

   //inc
   inc(xindex);
   end;
begin
//defaults
result:=false;

//clear
clear;

//add
xpos:=0;
if assigned(xstorageproc) then while fadd(xpos) do;

//successful
result:=(icount>=1);
end;

function tstorage.findbyslot(xindex:longint;var xdataptr:tstr8):boolean;//returns a pointer to file datastream
var
   p:longint;
   bol1:boolean;

   //data filters --------------------------------------------------------------
   procedure xfilter;
   begin
   if odatafilter_txt_matchwordcore and (iext[xindex]='txt') then
      begin
      {$ifdef gui}
      str__remchar(@idata[xindex],13);//use #10 return codes
      low__wordcore__filtertext(idata[xindex]);
      {$endif}
      end;
   end;
   //end data filters ----------------------------------------------------------
begin
//defaults
result:=false;

try
//unlock previous file
for p:=0 to (icount-1) do if (xdataptr=idata[p]) then ilockcount[p]:=frcmin32(ilockcount[p]-1,0);

//lock new file
if (xindex>=0) and (xindex<=(icount-1)) then
   begin
   //get
   if (idata[xindex]=nil) then
      begin
      //init
      idata[xindex]:=str__new8;

      //fetch data
      if (iptr[xindex]<>nil) then str__addrec(@idata[xindex],iptr[xindex],isize[xindex]);

      //unzip data
      if (isize[xindex]>=1) and izip[xindex] then low__decompress(@idata[xindex]);

      //apply data filters
      xfilter;
      end;

   //lock data stream -> hold data open
   inc(ilockcount[xindex]);

   //set
   xdataptr:=idata[xindex];

   //successful
   result:=true;
   end
else xdataptr:=inull;

//close unlocked files
bol1:=false;
for p:=0 to (icount-1) do if (ilockcount[p]<=0) then str__free(@idata[p]) else bol1:=true;
ifilesinuse:=bol1;//true=indicates that at least one file is in use by host process and thus it's not safe to clear or modify storage data
except;end;
end;


//io procs ---------------------------------------------------------------------
function io__findfolder(x:longint;var y:string):boolean;//17jan2007
var
   i:imalloc;
   a:pitemidlist;
   b:pchar;
   tmpfolder:string;
begin
//defaults
result:=false;

try
y:='';
a:=nil;
//process
if (win____SHGetMalloc(i)=NOERROR) then
   begin
   if (win____shgetspecialfolderlocation(0,x,a)=0) then
      begin
      //.size
      b:=pchar(makestrb(max_path,0));
      //.get
      if win____shgetpathfromidlist(a,b) then
         begin
         y:=io__asfolder(string(b));
         result:=(low__len(y)>=3);
         end;//if
      end;//if
   end;//if
except;end;
try;if (a<>nil) then i.free(a);except;end;
try
//-- Linux and robust Windows Support --
//Note: return a path regardless whether we are Windows or Linux, and wether it's supported
//      or not.
if not result then
   begin
   //fallback to "c:\windows\temp\"
   tmpfolder:=io__wintemp;
   if (tmpfolder='') then tmpfolder:='C:\WINDOWS\TEMP\';
   y:='';
   //get
   case x of
   CSIDL_DESKTOP:                y:=tmpfolder;
   CSIDL_COMMON_DESKTOPDIRECTORY:y:=tmpfolder;
   CSIDL_FAVORITES:              y:=tmpfolder;
   CSIDL_STARTMENU:              y:=tmpfolder;
   CSIDL_COMMON_STARTMENU:       y:=tmpfolder;
   CSIDL_PROGRAMS:               y:=tmpfolder;
   CSIDL_COMMON_PROGRAMS:        y:=tmpfolder;
   CSIDL_STARTUP:                y:=tmpfolder;
   CSIDL_COMMON_STARTUP:         y:=tmpfolder;
   CSIDL_RECENT:                 y:=tmpfolder;
   CSIDL_FONTS:                  y:=tmpfolder;
   CSIDL_APPDATA:                y:=tmpfolder;
   end;//case
   //set
   result:=(low__len(y)>=3);
   end;
except;end;
end;



function io__appdata:string;//out of date
begin
result:='';try;io__findfolder(CSIDL_APPDATA,result);except;end;
end;

function io__windrive:string;//14DEC2010
begin
result:='';try;result:=strcopy1(io__winroot,1,3);except;end;
end;

function io__winroot:string;//11dec2010
var
  a:pchar;
begin
result:='';

try
//process
//.size
a:=pchar(makestrb(max_path,0));
//.get
win____getwindowsdirectorya(a,MAX_PATH);
result:=io__asfolder(string(a));
except;end;
try;if (low__len(result)<3) then result:='C:\WINDOWS\';except;end;
end;

function io__winsystem:string;//11DEC2010
var
  a:pchar;
begin
result:='';

try
//process
//.size
a:=pchar(makestrb(max_path,0));
//.get
win____getsystemdirectorya(a,MAX_PATH);
result:=io__asfolder(string(a));
except;end;
try;if (low__len(result)<3) then result:=io__winroot+'SYSTEM32\';except;end;
end;

function io__wintemp:string;//11DEC2010
var
  a:pchar;
begin
//defaults
result:='';

try
//size
a:=pchar(makestrb(max_path,0));
//get
win____gettemppatha(max_path,a);
//set
result:=io__asfolder(string(a));
except;end;
try
//range
if (low__len(result)<3) then result:='C:\WINDOWS\TEMP\';//11DEC2010
io__makefolder(result);
except;end;
end;

function io__windesktop:string;//17MAY2013
begin
result:='';try;io__findfolder(csidl_desktop,result);except;end;
end;

function io__winstartup:string;
begin
result:='';try;io__findfolder(CSIDL_STARTUP,result);except;end;
end;

function io__winprograms:string;//start button > programs > - 11NOV2010
begin
result:='';try;io__findfolder(CSIDL_PROGRAMS,result);except;end;
end;

function io__winstartmenu:string;
begin
result:='';try;io__findfolder(CSIDL_STARTMENU,result);except;end;
end;

function io__fileexists(const x:string):boolean;//01may2025, 04apr2021, 15mar2020, 19may2019
   function xfileexists:boolean;
   var
      h:thandle;
      f:TWin32FindData;
   begin
   //defaults
   result:=false;

   //get
   h:=win____FindFirstFile(pchar(x),f);
   if (h<>INVALID_HANDLE_VALUE) then
      begin
      win____findclose(h);
      //set
      result:=((f.dwfileattributes and FILE_ATTRIBUTE_DIRECTORY)=0);
      end;
   end;
begin//soft check via low__driveexists
case idisk__havescope(x) of
true:result:=idisk__fileexists(x)
else result:=(x<>'') and io__local(x) and io__driveexists(x) and xfileexists;
end;//case
end;

function io__filesize64(const x:string):comp;//24dec2023
var
   v:pfilecache;
   vmustclose:boolean;
   c:tcmp8;
   e:string;
begin
//defaults
result:=-1;//file not found
//get
if filecache__openfile_anyORread(x,v,vmustclose,e) then
   begin
   try
   c.ints[0]:=win____getfilesize(v.filehandle,@c.ints[1]);
   result:=c.val;
   except;end;
   if vmustclose then filecache__closefile(v);
   end;
end;

function io__filedateb(const x:string):tdatetime;//27jan2022
begin
io__filedate(x,result);
end;

function io__filedate(const x:string;var xdate:tdatetime):boolean;//24dec2023, 27jan2022
label
   skipend;
var
   v:pfilecache;
   vmustclose:boolean;
   b:tbyhandlefileinformation;
   int1:longint;
   e:string;
begin
//defaults
result:=false;
xdate:=0;

//internal
if idisk__havescope(x) then
   begin
   if idisk__find(x,false,int1) and zzok(intdisk_data[int1],7023) then
      begin
      xdate:=intdisk_date[int1];
      result:=true;//ok
      end;
   goto skipend;
   end;

//get
if filecache__openfile_anyORread(x,v,vmustclose,e) then
   begin
   try
   if win____getfileinformationbyhandle(v.filehandle,b) then
      begin
      xdate:=io__fromfiletime(b.ftLastWriteTime);
      result:=true;//ok
      end;
   except;end;
   if vmustclose then filecache__closefile(v);
   end;

skipend:
end;

function io__filesize_atleast(const df:string;dsize:comp):boolean;//11aug2024
label
   skipend;
var
   dlen:comp;
   p,int1:longint;
   a:tstr8;
   e:string;
begin
result:=false;
a:=nil;

//check
if (dsize<=0) then exit;//off

try
//range
if (dsize<0) then dsize:=0;

//size file with "zero's"
dlen:=io__filesize64(df);
if (dsize>dlen) then
   begin
   //init
   a:=str__new8;

   //write 1mb blocks until file is the size we want
   while true do
   begin
   int1:=frcmax32(restrict32(sub64(sub64(dsize,dlen),1)),1000000);//1mb blocks
   if (int1<=0) then break
   else
      begin
      if (int1<>a.len) then
         begin
         a.setlen(int1);
         for p:=0 to (a.len-1) do a.pbytes[p]:=0;
         end;

      if not io__tofileex64(df,@a,dlen,false,e) then goto skipend;
      end;
   //inc
   dlen:=add64(dlen,a.len);
   end;//loop

   //successful
   result:=true;
   end;

//successful
result:=true;
skipend:
except;end;
try;if (a<>nil) then str__free(@a);except;end;
end;

function io__validfilename(const x:string):boolean;//31mar2025
begin
result:=(io__extractfilename(x)<>'');
end;

function io__remfile(const x:string):boolean;//31mar2025
begin
if not io__validfilename(x) then result:=true
else if idisk__havescope(x) then result:=idisk__remfile(x)
else                             result:=filecache__remfile(x);
end;

procedure io__filesetattr(const x:string;xval:longint);//01may2025
begin
if io__validfilename(x) and (not idisk__havescope(x)) then
   begin
   if not win____SetFileAttributes(pchar(x),xval) then win____GetLastError;
   end;
end;

function io__copyfile(const sf,df:string;var e:string):boolean;//16dec2024: upgraded to handle large files
const
   xchunksize=5000000;//5Mb
label
   redo,skipend;
var
   xonce:boolean;
   xdata:tobject;
   dpos,spos,xfilesize:comp;
   xdate:tdatetime;
begin
//defaults
result:=false;
xonce:=true;
xdata:=nil;
e:=gecTaskfailed;

try
//check
if strmatch(sf,df) then
   begin
   result:=true;
   goto skipend;
   end;
//check
if not io__fileexists(sf) then
   begin
   e:=gecFilenotfound;
   goto skipend;
   end;

//get
xdata:=str__new8;
spos:=0;
redo:
//.read chunk from sf
dpos:=spos;
if not io__fromfile64b(sf,@xdata,e,xfilesize,spos,xchunksize,xdate) then goto skipend;

//.once -> remove df
if xonce then
   begin
   if not io__remfile(df) then
      begin
      e:=gecFileinuse;
      goto skipend;
      end;
   xonce:=false;
   end;

//.write chunk to df
if not io__tofileex64(df,@xdata,dpos,false,e) then goto skipend;

//.loop
if ((spos+1)<xfilesize) then goto redo;

//successful
result:=true;
skipend:
except;end;
try
str__free(@xdata);
//remove "df" if partially written
if (not result) and (not xonce) then io__remfile(df);
except;end;
end;

function io__backupfilename(dname:string):string;//12feb2023
var
   p:longint;
   d:tdatetime;
begin
try
//defaults
result:='';
d:=date__now;
//.name
if (dname<>'') then dname:=io__safename(dname);
//try upto 100 times
for p:=1 to 100 do
begin
result:=app__subfolder('backups\'+low__datename(d))+low__datetimename(d)+dname;
if io__fileexists(result) then win____sleep(20+random(40)) else break;
end;//p
except;end;
end;

function io__tofilestr2(const x,xdata:string):boolean;//fast and basic low-level
var
   e:string;
begin
result:=io__tofilestr(x,xdata,e);
end;

function io__tofilestr(const x,xdata:string;var e:string):boolean;//fast and basic low-level
var
   a:tstr8;
begin
//defaults
result:=false;

try
a:=nil;
a:=str__new8;
//get
a.text:=xdata;
result:=io__tofile(x,@a,e);
except;end;
try;str__free(@a);except;end;
end;

function io__tofile(const x:string;xdata:pobject;var e:string):boolean;//31mar2025, 27sep2022, fast and basic low-level
var
   xfrom:comp;
begin
xfrom :=0;
result:=io__tofileex64(x,xdata,xfrom,true,e);
end;

function io__tofile64(const x:string;xdata:pobject;var e:string):boolean;//31mar2025, 27sep2022, fast and basic low-level
var
   xfrom:comp;
begin
xfrom :=0;
result:=io__tofileex64(x,xdata,xfrom,true,e);
end;

function io__tofileex64(const x:string;xdata:pobject;xfrom:comp;xreplace:boolean;var e:string):boolean;//30apr2024: flush file buffers for correct "nav__*" filesize info, 06feb2024, 22jan2024, 27sep2022, fast and basic low-level
label//xreplace=true=file is deleted and then written, false=file is written to/extended in size
   skipend;
const
   amax=maxword;//65K, was 32K
var
   a:array[0..amax] of byte;
   int1,xwritten,ylen,p,ap:longint;
   c:tcmp8;
   v:pfilecache;
   vok,xfilecreated:boolean;
begin
//defaults
result:=false;
e:=gecTaskfailed;
vok:=false;

try
//check
if not str__lock(xdata) then exit;

//check for empty filename - 31mar2025
if not io__validfilename(x) then
   begin
   e:=gecBadFileName;
   exit;
   end;

//internal
if idisk__havescope(x) then
   begin
   result:=idisk__tofile(x,xdata,e);
   goto skipend;
   end;

//init
ylen:=str__len(xdata);

//open or create file
vok:=filecache__openfile_write2(x,xreplace,xfilecreated,v,e);
if not vok then goto skipend;

//switch to replace mode if file was created
if xfilecreated then
   begin
   xreplace:=true;
   xfrom:=0;//22jan2024
   end;

//seek using _from
e:=gecOutOfDiskSpace;
c.val:=xfrom;
win____setfilepointer(v.filehandle,c.ints[0],@c.ints[1],0 {file_begin});

//init
p:=1;
ap:=0;
//.write - tstr8
if (ylen>=1) and (xdata^ is tstr8) then
   begin
   for p:=1 to ylen do
   begin
   //.fill
   a[ap]:=(xdata^ as tstr8).pbytes[p-1];
   //.store
   if (ap>=amax) or (p=yLEN) then
      begin
      if not win____writefile(v.filehandle,a,(ap+1),xwritten,nil) then goto skipend;
      if (xwritten<>(ap+1)) then goto skipend;
      ap:=-1;
      end;
   //.inc
   inc(ap);
   end;//p
   end
//.write - tstr9
else if (ylen>=1) and (xdata^ is tstr9) then
   begin
   while true do
   begin
   int1:=(xdata^ as tstr9).fastread(a,sizeof(a),p-1);
   if (int1>=1) then
      begin
      inc(p,int1);
      if not win____writefile(v.filehandle,a,int1,xwritten,nil) then goto skipend;
      if (xwritten<>int1) then goto skipend;
      end
   else break;
   end;//loop
   end;

//successful
result:=true;
skipend:
except;end;
try
//close file handle
if vok then
   begin
   //.flush the buffers so that a call to "nav__*" will show the correct file size when requested - 30apr2024
   if filecache__enabled then win____FlushFileBuffers(v.filehandle);

   //.close the file -> only if a single instance is open
   filecache__closefile(v);
   end;

//delete the file on failure for "xreplace=true" operations
if (not result) and xreplace then io__remfile(x);

//release buffer and optionally destroy it
str__unlockautofree(xdata);
except;end;
end;

function io__fromfilestrb(const x:string;var e:string):string;//30mar2022
begin
result:='';try;io__fromfilestr(x,result,e);except;end;
end;

function io__fromfilestr(const x:string;var xdata,e:string):boolean;
var
   a:tstr8;
begin
//defaults
result:=false;

try
xdata:='';
a:=nil;
//get
a:=str__new8;
result:=io__fromfile(x,@a,e);
if result then xdata:=a.text;
except;end;
try;str__free(@a);except;end;
end;

function io__fromfile(const x:string;xdata:pobject;var e:string):boolean;//31mar2025
var
   _filesize,_from:comp;
   _date:tdatetime;
begin
_from :=0;
result:=io__fromfile64b(x,xdata,e,_filesize,_from,max32,_date);
end;

function io__fromfile64(const x:string;xdata:pobject;var e:string):boolean;//31mar2025
begin
result:=io__fromfile641(x,xdata,false,e);
end;

function io__fromfile641(const x:string;xdata:pobject;xappend:boolean;var e:string):boolean;//31mar2025, 04feb2024
var
   _filesize,_from:comp;
   _date:tdatetime;
begin
_from :=0;
result:=io__fromfile64c(x,xdata,xappend,e,_filesize,_from,max32,_date);
end;

function io__fromfile64b(const x:string;xdata:pobject;var e:string;var _filesize,_from:comp;_size:comp;var _date:tdatetime):boolean;//31mar2025, 24dec2023, 20oct2006
begin
result:=io__fromfile64c(x,xdata,false,e,_filesize,_from,_size,_date);
end;

function io__fromfile64d(const x:string;xdata:pobject;xappend:boolean;var e:string;var _filesize:comp;_from:comp;_size:comp;var _date:tdatetime):boolean;//31mar2025, 06feb2024, 24dec2023, 20oct2006
begin
result:=io__fromfile64c(x,xdata,xappend,e,_filesize,_from,_size,_date);
end;

function io__fromfile64c(const x:string;xdata:pobject;xappend:boolean;var e:string;var _filesize,_from:comp;_size:comp;var _date:tdatetime):boolean;//31mar2025, 11jan2025, 06feb2024, 24dec2023, 20oct2006
label
   skipend;
const
   amax=maxword;//65K, was 32K
var
   v:pfilecache;
   vok:boolean;
   a:array[0..amax] of byte;
   int1,xdatalen,_size32,i,p,ac:longint;
   c:tcmp8;

   function xfilesize:comp;
   var
      c:tcmp8;
   begin
   c.ints[0]:=win____getfilesize(v.filehandle,@c.ints[1]);
   result:=c.val;
   end;
begin
//defaults
result:=false;
vok:=false;

try
e:=gecTaskFailed;
_filesize:=0;

//check
if not str__lock(xdata) then exit;

//check for empty filename - 31mar2025
if not io__validfilename(x) then
   begin
   e:=gecFilenotfound;
   exit;
   end;

//init
if xappend then xdatalen:=str__len(xdata)
else
   begin
   xdatalen:=0;
   str__clear(xdata);
   end;

//internal
if idisk__havescope(x) then
   begin
   //find
   if not idisk__find(x,false,int1) then
      begin
      e:=gecFilenotfound;
      goto skipend;
      end;
   //get
   if zzok(intdisk_data[int1],7023) then
      begin
      _filesize:=str__len(@intdisk_data[int1]);
      if not str__add3(xdata,@intdisk_data[int1],restrict32(_from),restrict32(_size)) then
         begin
         e:=gecTaskfailed;
         goto skipend;
         end;
      _from:=frcmax64( add64(_from,restrict32(_size)) ,_filesize);//11jan2025
      end;
   //succesful
   result:=true;
   goto skipend;
   end;

//open
case filecache__openfile_read(x,v,e) of
true:vok:=true;
else goto skipend;
end;

//get file size
_filesize:=xfilesize;

//get file date
_date:=io__dates__fileage(v.filehandle);

//set the value of "_from"
if (_from<0) then _from:=0
else if (_from>=_filesize) then
   begin
   result:=true;
   goto skipend;
   end;

//seek using _from
c.val:=_from;
win____setfilepointer(v.filehandle,c.ints[0],@c.ints[1],0 {file_begin});

//set the value of size
if (_size=0) then//0=read NO data
   begin
   result:=true;
   goto skipend;
   end
else if (_size<0) then _size:=_filesize//-X..-1=read ALL data
else if (_size>_filesize) then _size:=_filesize;//1..X=read SPECIFIED data

//convert _size(64bit) into a fast 32bit int
_size32:=restrict32(_size);

//size check - ensure buffer is small enough to fit in ram
if (add64(xdatalen,_size32)>max32) then
   begin
   e:=gecOutofmemory;
   goto skipend;
   end;

//size the buffer
if not str__setlen(xdata,xdatalen+_size32) then
   begin
   e:=gecOutofmemory;
   goto skipend;
   end;

i:=0;

//.write
while true do
begin
//.get
win____readfile(v.filehandle,a,amax+1,ac,nil);
//.check
if (ac=0) then break;
//.fill
if (xdata^ is tstr8) then
   begin
   for p:=0 to frcmax32(ac-1,_size32-i-1) do//tested and passed - 17may2021
   begin
   inc(i);
   (xdata^ as tstr8).pbytes[xdatalen+i-1]:=a[p];
   end;//p
   end
else if (xdata^ is tstr9) then
   begin
   inc(i,(xdata^ as tstr9).fastwrite(a,frcmax32(ac,_size32-i),xdatalen+i));
   end;

//.quit
if (i>=_size32) then break;
end;//loop

//successful
_from:=add64(_from,i);
if (_filesize=_size) and (_from=0) then result:=(i=_size)//only for small files, BIG files can't always fit in RAM
else
   begin
   if (i<>_size32) then str__setlen(xdata,xdatalen+i);
   result:=(i>=1);
   end;
skipend:
except;end;
try
//close cache record
if vok then filecache__closefile(v);
//reset buffer on failure
if (not result) and (not xappend) then str__clear(xdata);
//release buffer and optionally destroy it
str__unlockautofree(xdata);
except;end;
end;

function io__fromfiletime(x:tfiletime):tdatetime;
var
   a:longint;
   c:tfiletime;
begin
win____filetimetolocalfiletime(x,c);
if win____filetimetodosdatetime(c,tint4(a).hi,tint4(a).lo) then result:=date__filedatetodatetime(a) else result:=date__now;
end;

function io__folderexists(const x:string):boolean;//01may2025, 15mar2020, 14dec2016
   function xexists:boolean;
   var
      c:longint;
   begin
   c:=win____GetFileAttributes(pchar(x));
   result:=(c<>-1) and ( (FILE_ATTRIBUTE_DIRECTORY and c) <>0 );
   end;
begin//soft check via low__driveexists
result:=(x<>'') and io__local(x) and io__driveexists(x) and xexists;
end;

function io__deletefolder(x:string):boolean;//13feb2024
begin//soft check via low__driveexists
result:=false;
try
//check
if (x='') then exit else x:=io__asfolder(x);
//get
if io__local(x) and io__driveexists(x) then result:=win____RemoveDirectory(pchar(x));
except;end;
end;

function io__makefolder2(const x:string):string;//01may2025
begin
result:=x;
if (result<>'') then
   begin
   result:=io__asfolder(result);
   io__makefolder(result);
   end;
end;

function io__makefolder(x:string):boolean;//01may2025, 15mar2020, 19may2019
begin//soft check via low__driveexists
//defaults
result:=false;

try
//check
if (x<>'') then x:=io__asfolder(x) else exit;

//get
if io__local(x) and io__driveexists(x) then
   begin
   result:=io__folderexists(x);
   if (not result) and (low__len(x)>3) then
      begin
      win____CreateDirectory(pchar(x),nil);
      result:=io__folderexists(x);
      end;
   end;
except;end;
end;

function io__exemarker(x:tstr8):boolean;//14nov2023
var
   z:string;
begin
//defaults
result:=false;

try
//check
if not str__lock(@x) then exit;
z:='';
//set - dynamically create the header, so that no complete trace is formed in the final EXE data stream, we can then search for this header without fear of it being repeated in the code by mistake! - 18MAY2010
x.sadd('[packed');
x.sadd('-marker]');
x.sadd('[id--');
//.id
z:=z+'1398435432908435908';
z:='__12435897'+z;
z:=z+'0-9132487211239084%%__';
z:=z+'~12@__Z';
//finalise
x.sadd(z);
x.sadd('--]');
//successful
result:=true;
except;end;
try;str__uaf(@x);except;end;
end;

function io__exereadFROMFILE(const xfilename:string;xexedata,xsysdata,xprgdata,xusrdata:tstr8;xsysmore:tvars8;var e:string):boolean;//14nov2023
label
   skipend;
var
   s:tstr8;
begin
//defaults
result:=false;

try
s:=nil;
e:=gecTaskfailed;
//check
str__lock(@xexedata);
str__lock(@xsysdata);
str__lock(@xprgdata);
str__lock(@xusrdata);
//get
if (xfilename<>'') then
   begin
   s:=str__new8;
   if io__fromfile(xfilename,@s,e) then
      begin
      e:=gecUnknownformat;
      result:=io__exeread(s,xexedata,xsysdata,xprgdata,xusrdata,xsysmore);
      end;
   end;
skipend:
except;end;
try
str__free(@s);
str__uaf(@xexedata);
str__uaf(@xsysdata);
str__uaf(@xprgdata);
str__uaf(@xusrdata);
except;end;
end;

function io__exeread(s,xexedata,xsysdata,xprgdata,xusrdata:tstr8;xsysmore:tvars8):boolean;//14nov2023
label
   skipend;
var
   m,xtmp:tstr8;
   xpos,p:longint;
   m1:byte;

   function xread(x:tstr8):boolean;
   label
      skipend;
   var
      xlen:longint;
   begin
   //defaults
   result:=false;
   try
   //get
   xlen:=s.int4[xpos];
   inc(xpos,4);
   if (x<>nil) then
      begin
      x.clear;
      if (xlen>=1) and (not x.add3(s,xpos,xlen)) then goto skipend;
      end;
   inc(xpos,xlen);
   //successful
   result:=true;
   skipend:
   except;end;
   end;
begin
//defaults
result:=false;//not found

try
m:=nil;
xtmp:=nil;
//check
str__lock(@xexedata);
str__lock(@xsysdata);
str__lock(@xprgdata);
str__lock(@xusrdata);
if not str__lock(@s) then goto skipend;
if (s.len<=0) then goto skipend;
//init
if (xexedata<>nil) then xexedata.clear;
if (xsysdata<>nil) then xsysdata.clear;
if (xprgdata<>nil) then xprgdata.clear;
if (xusrdata<>nil) then xusrdata.clear;
if (xsysmore<>nil) then xsysmore.clear;
xtmp:=str__new8;
m:=str__new8;
if not io__exemarker(m) then goto skipend;
m1:=m.pbytes[0];
//find
for p:=1 to s.len do if (m1=s.pbytes[p-1]) and s.same2(p-1,m) then
   begin
   if (xexedata<>nil) then xexedata.add31(s,1,p-1);
   //.data slots
   xpos:=p-1+m.len;
   if not xread(xsysdata) then goto skipend;
   if not xread(xprgdata) then goto skipend;
   if not xread(xusrdata) then goto skipend;
   //.xsysmore
   if not xread(xtmp) then goto skipend;
   if (xsysmore<>nil) then xsysmore.binary['more']:=xtmp;
   //.done
   result:=true;
   break;
   end;
//assume all of "s" is the exe
if not result then
   begin
   if (xexedata<>nil) and (not xexedata.add(s)) then goto skipend;
   result:=true;
   end;
skipend:
except;end;
try
str__free(@m);
str__uaf(@s);
str__uaf(@xexedata);
str__uaf(@xsysdata);
str__uaf(@xprgdata);
str__uaf(@xusrdata);
str__free(@xtmp);
except;end;
end;

function io__exewriteTOFILE(xfilename:string;xexedata,xsysdata,xprgdata,xusrdata:tstr8;xsysmore:tvars8;var e:string):boolean;//14nov2023
label
   skipend;
var
   s:tstr8;
begin
//defaults
result:=false;

try
s:=nil;
e:=gecTaskfailed;
//check
str__lock(@xexedata);
str__lock(@xsysdata);
str__lock(@xprgdata);
str__lock(@xusrdata);
//get
if (xfilename<>'') then
   begin
   s:=str__new8;
   if not io__exewrite(s,xexedata,xsysdata,xprgdata,xusrdata,xsysmore) then goto skipend;
   if not io__tofile(xfilename,@s,e) then goto skipend;
   //successful
   result:=true;
   end;
skipend:
except;end;
try
str__free(@s);
str__uaf(@xexedata);
str__uaf(@xsysdata);
str__uaf(@xprgdata);
str__uaf(@xusrdata);
except;end;
end;

function io__exewrite(d,xexedata,xsysdata,xprgdata,xusrdata:tstr8;xsysmore:tvars8):boolean;//14nov2023
label
   skipend;
var
   m:tstr8;

   function xadd(x:tstr8):boolean;
   label
      skipend;
   var
      int1:longint;
   begin
   //defaults
   result:=false;

   try
   str__lock(@x);
   int1:=str__len(@x);
   if not d.addint4(int1) then goto skipend;
   if (int1>=1) and (not d.add(x)) then goto skipend;
   //successful
   result:=true;
   skipend:
   except;end;
   try;str__uaf(@x);except;end;
   end;
begin
//defaults
result:=false;//not found

try
m:=nil;
//check
str__lock(@xexedata);
str__lock(@xsysdata);
str__lock(@xprgdata);
str__lock(@xusrdata);
if not low__true2(str__lock(@d),str__lock(@xexedata)) then goto skipend;
if (xexedata.len<=0) then goto skipend;
//init
m:=str__new8;
if not io__exemarker(m) then goto skipend;
//get
//.exe header
if not d.add(xexedata) then goto skipend;
//.marker
if not d.add(m) then goto skipend;//always include the marker, so EXE knows it is a child/client of a parent
//.sysdata
if not xadd(xsysdata) then goto skipend;
//.prgdata
if not xadd(xprgdata) then goto skipend;
//.usrdata
if not xadd(xusrdata) then goto skipend;
//.sysmore
if (xsysmore=nil) then xadd(nil)
else                   xadd(xsysmore.binary['more']);
//successful
result:=true;
skipend:
except;end;
try
str__free(@m);
str__uaf(@d);
str__uaf(@xexedata);
str__uaf(@xsysdata);
str__uaf(@xprgdata);
str__uaf(@xusrdata);
except;end;
end;

function io__drivelist:tdrivelist;
var
   xdrivelist:set of 0..25;
   p:longint;
begin
//defaults
for p:=0 to high(tdrivelist) do result[p]:=false;

try
//get
longint(xdrivelist):=win____getlogicaldrives;
for p:=0 to 25 do if (p in xdrivelist) then result[p]:=true;
except;end;
end;

procedure io__createlink(const df,sf,dswitches,iconfilename:string);//10apr2019, 14NOV2010
var//Note: df=> filename to save link as, sf=filename we are linking to
   //ShlObj, ActiveX, ComObj
  iobject:iunknown;
  islink:ishelllink;
  ipfile:ipersistfile;
begin
try
//defaults
iobject:=nil;
win____CoInitialize(nil);//01dec2024: fixed for Win98
//init
iobject:=win____createcomobject(CLSID_ShellLink);
islink:=iobject as ishelllink;
ipfile:=iobject as ipersistfile;
//clean
io__remfile(df);
//link
with islink do
begin
setarguments(pchar(dswitches));
setpath(pchar(sf));
setworkingdirectory(pchar(io__extractfilepath(sf)));
if (iconfilename<>'') then seticonlocation(pchar(iconfilename),0);//14NOV2010
end;
//.link.save
ipfile.save(pwchar(widestring(df)),false);
except;end;
//Note: "iunknown" is a special instance that is automatically destroyed by the compiler - 27apr2021
try;win____CoUnInitialize;except;end;//01dec2024: fixed for Win98
end;

function io__exename:string;
begin
result:=low__param(0);
end;

function io__ownname:string;
begin
result:=io__remlastext(io__extractfilename(low__param(0)));//c:\xxxx\abc.exe -> "abc" - 09aug2021
end;

function io__dates__filedatetime(x:tfiletime):tdatetime;
var
   a:longint;
   c:tfiletime;
begin
//defaults
result:=date__now;

try
//process
win____filetimetolocalfiletime(x,c);
if win____filetimetodosdatetime(c,tint4(a).hi,tint4(a).lo) then result:=date__filedatetodatetime(a)
else result:=date__now;
except;end;
end;

function io__dates__fileage(x:thandle):tdatetime;
var
   a:tbyhandlefileinformation;
begin
result:=0;try;if (x=0) or (not win____getfileinformationbyhandle(x,a)) then result:=date__now else result:=io__dates__filedatetime(a.ftLastWriteTime);except;end;
end;

function io__lastext(const x:string):string;//returns last extension - 03mar2021
begin
result:=io__lastext2(x,false);
end;

function io__lastext2(x:string;xifnodotusex:boolean):string;//returns last extension - 03mar2021
var
   p:longint;
   c:char;
begin
result:='';

try
//defaults
if xifnodotusex then result:=x else result:='';
//get
if (x<>'') then
   begin
   for p:=(low__len(x)-1) downto 0 do
   begin
   c:=x[p+stroffset];
   if (c='.') then
      begin
      result:=strcopy0(x,p+1,low__len(x));
      break;
      end
   else if (c='/') or (c='\') or (c=':') or (c='|') then break;
   end;//p
   end;
except;end;
end;

function io__remlastext(const x:string):string;//remove last extension
var
   p:longint;
begin
result:=x;

try
if (x<>'') then
   begin
   for p:=(low__len(x)-1) downto 0 do if (x[p+stroffset]='.') then
   begin
   result:=strcopy0(x,0,p);
   break;
   end;//p
   end;
except;end;
end;

function io__forceext(const xfilename,xforceext:string):string;
begin
result:=io__forceext2(xfilename,xforceext,true);
end;

function io__forceext2(const xfilename,xforceext:string;xappend:boolean):string;
var
   p,lp:longint;
   str1,d,xext,xoutlabel,xoutext,xoutmask:string;
   xforcedone:boolean;
   c:char;

   procedure xforce;
   label
      skipend;
   var
      lp,p:longint;
      dext,str1,d:string;
      c:char;
   begin
   try
   //init
   d:=xoutext+fesepX;//usually a plus sign "+"
   dext:='';
   lp:=1;
   //get
   for p:=1 to length(d) do
   begin
   c:=d[p-1+stroffset];
   if (c=fesepX) then
      begin
      str1:=strcopy1(d,lp,p-lp);
      if (dext='') then dext:=str1;//take first instance as fallback
      if (str1=xext) or (str1=feany) then
         begin
         xforcedone:=true;
         goto skipend;//filename.ext matches one of the extensions in the list -> do nothing
         end;
      lp:=p+1;
      end;
   end;//p
   //force first ext we came across
   if (dext<>'') then
      begin
      if xappend then result:=result+insstr('.',strcopy1(result,length(result),1)<>'.')+dext
      else            result:=strcopy1(result,1,length(result)+low__insint(-1,xext<>'')-length(xext))+'.'+dext;
      //successful
      xforcedone:=true;
      end;
   skipend:
   except;end;
   end;
begin
//defaults
result:=xfilename;

try
xforcedone:=false;
//check
if (xforceext=feany) then exit;
//init
xext:=strlow(io__lastext(xfilename));//allows "nil"
//get
d:=xforceext+fesep;
lp:=1;
for p:=1 to length(d) do
begin
c:=d[p-1+stroffset];
if (c=fesep) or (c=fesepX) then//";" or "+"
   begin
   str1:=strcopy1(d,lp,p-lp);
   if io__findext(str1,xoutlabel,xoutext,xoutmask) then
      begin
      xforce;
      if xforcedone then break;//done
      end;
   lp:=p+1;
   end;
end;//p
except;end;
end;

function io__findext(s:string;var xoutlabel,xoutext,xoutmask:string):boolean;
//Note: s is "txt" or "bat" or "bmp" or "tea" etc
   procedure xcap(const x:string);
   var
      lp,p:longint;
      str1,d,dl,dm:string;
      c:char;
   begin
   //init
   d:=s+fesepX;//usually a plus sign "+"
   lp:=1;
   //get
   for p:=1 to low__len(d) do
   begin
   c:=d[p-1+stroffset];
   if (c=fesepX) then
      begin
      str1:=strcopy1(d,lp,p-lp);
      if (str1<>'') then
         begin
         dl:=dl+insstr(fesep,dl<>'')+str1;
         dm:=dm+insstr(fesep,dm<>'')+insstr('*.',str1<>'*')+str1;
         end;
      lp:=p+1;
      end;
   end;//p
   //set
   xoutlabel:=x+' ('+dl+')';
   xoutext:=s;//leave exactly as is (maintain original format even if it's "txt+bwd+bwp") - 03mar2021
   xoutmask:=dm;
   result:=true;
   end;
begin
//defaults
result:=false;

try
xoutlabel:='';
xoutext:='';
xoutmask:='';
//init
s:=strlow(io__lastext2(s,true));
//get
if      (s=feany) then xcap('All Files')
else if (s=fec3)  then xcap('Claude 3 Code')
else if (s=feref3)then xcap('Claude 3 Ref')
else if (s=fec2p) then xcap('Claude 2 Product')
else if (s=fec2v) then xcap('Claude 2 Values')
else if (s=feini) then xcap('INI Document')
else if (s=fetxt) then xcap('Text Document')
else if (s=febwd) then xcap('Blaiz Writer Document')//26sep2022
else if (s=febwp) then xcap('Blaiz Word Processor Document')
else if (s=fesfef) then xcap('Small File Encrypter File')//27sep2022
else if (s=fexml) then xcap('XML (Pad) Document')
else if (s=fehtml) then xcap('HTML Document')
else if (s=febat) then xcap('Batch File')
else if (s=febmp) then xcap('Bitmap')
else if (s=fedib) then xcap('Device Independent Bitmap')//14may2025
else if (s=fegif) then xcap('GIF Picture')
else if (s=fetga) then xcap('TarGA Picture')
else if (s=feppm) then xcap('Portable Pixelmap')
else if (s=fepgm) then xcap('Portable Greymap')
else if (s=fepbm) then xcap('Portable Bitmap')
else if (s=fepnm) then xcap('PNM Picture')
else if (s=fexbm) then xcap('XBM Picture')
else if (s=fejpg) then xcap('JPEG Picture')
else if (s=fejif) then xcap('JIF Picture')
else if (s=fejpeg) then xcap('JPEG Picture')
else if (s=feimg32) then xcap('Image 32bit')
else if (s=fetj32) then xcap('Transparent Jpeg 32bit')
else if (s=fepng) then xcap('Portable Network Graphic')
else if (s=feico) then xcap('Icon')//15feb2022
else if (s=fecur) then xcap('Static Cursor')//22may2022, 29aug2021
else if (s=feani) then xcap('Animated Cursor')//29aug2021
else if (s=fetep) then xcap('Text Picture')
else if (s=fetea) then xcap('TEA Picture')
else if (s=febvid) then xcap('Basic Video')//20jun2021
else if (s=feAU22) then xcap('Raw Audio - 22,050 Hz')//17jul2021
else if (s=feAU44) then xcap('Raw Audio - 44,100 Hz')//17jul2021
else if (s=feAU48) then xcap('Raw Audio - 48,000 Hz')//17jul2021
else if (s=fevmp) then xcap('Video Magic Project')//06jul2021
else if (s=fevmt) then xcap('Video Magic Track')//06jul2021
else if (s=feabr) then xcap('Abra Cadabra Project')//01aug2021
else if (s=feaccp) then xcap('Animated Cursor Creator Project')//07feb2022
else if (s=femjpeg) then xcap('Motion JPEG Video')//20jun2021
else if (s=fealarms) then xcap('Alarms List')//12nov2022, 08mar2022
else if (s=feReminders) then xcap('Reminders List')//09mar2022
else if (s=feM3U) then xcap('Playlist')//20mar2022
else if (s=feFootnote) then xcap('Footnote')//21mar2022
else if (s=feCursorScript) then xcap('Cursor Script')//17may2022
else if (s=feQuoter) then xcap('Quoter Document')//24dec2022
else if (s=feQuoter2) then xcap('Quoter 2 Document')
else if (s=feallfiles) then xcap('All Files')
else if (s=fealldocs) then xcap('All Documents')
else if (s=feallimgs) then xcap('All Images')
else if (s=felosslessimgs) then xcap('Lossless Images')//09apr2025
else if (s=feres) then xcap('Resource')//05may2025
else if (s=feallcurs) and (feallcurs<>'') then xcap('All Cursors')
else if (s=feallcurs2) and (feallcurs2<>'') then xcap('All Cursors')//22may2022
else if (s=fealljpgs) and (fealljpgs<>'') then xcap('All JPEG Pictures')//02aug2024: updated, 03sep2021
else if (s=febrowserimgs) and (febrowserimgs<>'') then xcap('Browser Pictures')//18mar2025
else if (s=febcs) then xcap('Blaiz Color Scheme')
else if (s=fezip) then xcap('ZIP Archive')//10feb2023
else if (s=feexe) then xcap('Application')//14nov2023
else if (s=fepas) then xcap('Pascal Unit')//23jul2024
else if (s=fedpr) then xcap('Delphi Project')//17mar2025
else if (s=fec3)  then xcap('Claude 3 Code')//20aug2024
else if (s=feref3)then xcap('Claude 3 Ref')//20aug2024
else if (s=fenupkg)then xcap('Chocolatey Package')//31mar2025
else if (s=femap) then xcap('Map File')//24may2025

//.midi formats
else if (s=femid) or (s=femidi) or (s=fermi) then xcap('Midi Music');
except;end;
end;

function io__readfileext(const x:string;fu:boolean):string;{Date: 24-DEC-2004, Superceeds "ExtractFileExt"}
var//supports: "c:\windows\abc.RTF" and also "http://www.blaiz.net/abc/docs/index.RTF?abc=com"
   a,b:string;
begin
if io__scandownto(x,'.','/','\',a,result) then
   begin
   if io__scandownto(result,'?',#0,#0,a,b) then result:=a;
   if fu then result:=strup(result);
   end
else result:='';
end;

function io__readfileext_low(const x:string):string;//30jan2022
begin
result:=strlow(io__readfileext(x,false));
end;

function io__scandownto(const x:string;y,stopA,stopB:char;var a,b:string):boolean;
var
   xlen,p:longint;
   _stopA,_stopB:boolean;
begin
//defaults
result:=false;

try
a:='';
b:='';
_stopA:=(stopA<>#0);
_stopB:=(stopB<>#0);
//init
xlen:=low__len(x);
//check
if (xlen<=0) then exit;
//get
for p:=(xlen-1) downto 0 do
begin
if (_stopA and (x[p+stroffset]=stopA)) then break
else if (_stopB and (x[p+stroffset]=stopB)) then break
else if (x[p+stroffset]=y) then
   begin
   a:=strcopy0(x,0,p);
   b:=strcopy0(x,p+1,xlen);
   result:=true;
   break;
   end;
end;//p
except;end;
end;

function io__faISfolder(x:longint):boolean;//05JUN2013
begin//fast
result:=((x and faDirectory)>0);
end;

function io__mssortstr(const s:string):string;//12jun2025, 01jun2025, 29may2025
var
   v,lp,p,slen:longint;
   z:string;

   procedure h(x:byte);
   var
      v:string;
   begin
   v:=intstr32(x);
   result:=result+'-'+strcopy1('000',1,3-low__len(v))+v;
   end;

   procedure vnumber(xfinished:boolean);
   begin
   //.store value as padded number
   if (lp>=1) and ((v<nn0) or (v>nn9) or xfinished) then
      begin
      z:=strcopy1(s,lp,p-lp + insint(1,(v>=nn0) and (v<=nn9))  );
      result:=result+strcopy1('0000000000000000',1,16-low__len(z))+z;
      lp:=0;
      end;
   end;

begin
//defaults
result:='';

//init
slen:=low__len(s);
lp  :=0;//off

//get
for p:=1 to slen do
begin
v:=byte(s[p-1+stroffset]);

//.store value as padded number
vnumber(false);

//.store value as hex
case v of
nn0..nn9          :if (lp=0) then lp:=p;
uua..uuz          :result:=result+char(v);
lla..llz          :result:=result+char(v-32);
ssdot             :h(0);
ssExclaim         :h(1);
ssHash            :h(2);
ssDollar          :h(3);
ssPert            :h(4);
ssampersand       :h(5);
ssLRoundbracket   :h(6);
ssRRoundbracket   :h(7);
ssat              :h(8);
ssLSquarebracket  :h(9);
ssRSquarebracket  :h(10);
sspower           :h(11);
ssunderscore      :h(12);
sssinglequote     :h(13);
ssLCurlyBracket   :h(14);
ssRCurlyBracket   :h(15);
ssSquiggle        :h(16);
ssPlus            :h(17);
ssEqual           :h(18);
sssinglequotefancy:h(19);
ssdash            :h(20);
127..255          :result:=result+char(v);
else               h(21);
end;//case

end;//p

//.finalise
vnumber(true);

end;

function io__safename(const x:string):string;//08apr2025, 07mar2021, 08mar2016
begin
result:=io__safefilename(x,false);
end;

function io__safefilename(const x:string;allowpath:boolean):string;//08apr2025, 07mar2021, 08mar2016
var
   minp,p:longint;
   c:char;

   function isbinary(x:byte):boolean;
   begin
   result:=false;

   try
   case x of//31MAR2010
   32..255:result:=false;
   else result:=true;
   end;
   except;end;
   end;
begin
//defaults
result:='';

try
result:=x;
if (x='') then exit;
//get
if allowpath then
   begin
   //.get
   if (strcopy1(x,1,2)='\\') then minp:=3 else minp:=1;
   //.set
   for p:=(minp-1) to (low__len(result)-1) do
   begin
   c:=result[p+stroffset];
   if (c='/') then result[p+stroffset]:='\'
   else if isbinary(byte(c)) or (c=';') or (c='*') or (c='?') or (c='"') or (c='<') or (c='>') or (c='|') or (c='$') then result[p+stroffset]:=pcSymSafe;
   //was: else if isbinary(byte(c)) or (c=';') or (c='*') or (c='?') or (c='"') or (c='<') or (c='>') or (c='|') or (c='@') or (c='$') then result[p+stroffset]:=pcSymSafe;
   end;//p
   end
else
   begin
   //.set
   for p:=0 to (low__len(result)-1) do
   begin
   c:=result[p+stroffset];
   if isbinary(byte(c)) or (c='\') or (c='/') or (c=':') or (c=';') or (c='*') or (c='?') or (c='"') or (c='<') or (c='>') or (c='|') or (c='@') or (c='$') then result[p+stroffset]:=pcSymSafe;
   end;//p
   end;
except;end;
end;

function io__issafefilename(const x:string):boolean;//07mar2021, 10APR2010
var
   p:longint;
   c:char;

   function isbinary(x:byte):boolean;
   begin
   result:=false;

   try
   case x of//31MAR2010
   32..255:result:=false;
   else result:=true;
   end;
   except;end;
   end;
begin
//defaults
result:=true;

try
//check
if (x='') then exit;
//set
for p:=0 to (low__len(x)-1) do
begin
c:=x[p+stroffset];
//was: if isbinary(byte(c)) or (c='\') or (c='/') or (c=':') or (c=';') or (c='*') or (c='?') or (c='"') or (c='<') or (c='>') or (c='|') or (c='@') or (c='$') then
if isbinary(byte(c)) or (c='\') or (c='/') or (c=':') or (c=';') or (c='*') or (c='?') or (c='"') or (c='<') or (c='>') or (c='|') or (c='$') then
   begin
   result:=false;
   break;
   end;
end;//p
except;end;
end;

function io__hack_dangerous_filepath_allow_mask(const x:string):boolean;
begin
result:=io__hack_dangerous_filepath(x,false);
end;

function io__hack_dangerous_filepath_deny_mask(const x:string):boolean;
begin
result:=io__hack_dangerous_filepath(x,true);
end;

function io__hack_dangerous_filepath(const x:string;xstrict_no_mask:boolean):boolean;
var
   p:longint;
begin
//defaults
result:=false;

try
//get
if (x<>'') then
   begin
   for p:=0 to (low__len(x)-1) do
   begin
   //check 1 - "..\" + "../"
   if (x[p+stroffset]='.') and ((strcopy0(x,p,3)='..\') or (strcopy0(x,p,3)='../')) then
      begin
      result:=true;
      break;
      end
   //check 2 - (..\) "..%5C" + "..%5c" AND (../) "..%2F" + "..%2f"
   else if (x[p+stroffset]='.') and ((strcopy0(x,p,5)='..%5C') or (strcopy0(x,p,5)='..%5c') or (strcopy0(x,p,5)='..%2F') or (strcopy0(x,p,5)='..%2f')) then
      begin
      result:=true;
      break;
      end
   //check 3 - ":" other than "(a-z/@):(\/)" e.g. "C:\" is ok, but "C::" is not - 02sep2016
   else if (p>=2) and (x[p+stroffset]=':') then
      begin
      result:=true;
      break;
      end
   //check 4 - none of these characters are allowed, ever - 02sep2016
   else if (x[p+stroffset]='?') or (x[p+stroffset]='<') or (x[p+stroffset]='>') or (x[p+stroffset]='|') then
      begin
      result:=true;
      break;
      end
   //optional check 5 - disallow file masking "*"
   else if xstrict_no_mask and (x[p+stroffset]='*') then
      begin
      result:=true;
      break;
      end;
   end;//p
   end;
except;end;
end;

function io__makeportablefilename(const filename:string):string;//11sep2021, 06oct2020, 14APR2011
var// "C:\...\" => exact static filename
   // "c:\...\" => also an exact static filename
   // "?:\...\" => relative dynamic filename (on same disk as EXE and thus will adapt) - 11sep2021, 14APR2011
   edrive,sdrive:string;
begin
result:=filename;
//get
if (low__len(result)>=2) and (strcopy1(result,2,1)=':') and (strcopy1(result,1,1)<>'/') and (strcopy1(result,1,1)<>'\') then
   begin
   edrive:=strcopy1(io__exename+'Z',1,1);//pad with "Z" incase app.exename is empty for some reason - 14APR2011
   sdrive:=strcopy1(result,1,1);
   //get - if on same drive as EXE then it's considered portable so make it "?:\...\"
   if strmatch(edrive,sdrive) then result:='?'+strcopy1(result,2,low__len(result));
   end;
end;

function io__readportablefilename(const filename:string):string;//11sep2021
var// "C:\...\" => STATIC, exact static filename
   // "c:\...\" => also an exact static filename
   // "?:\...\" => RELATIVE, dynamic filename (on same disk as EXE and thus will adapt) - 11sep2021, 14APR2011
   edrive:string;
begin
result:=filename;
//get
if (low__len(result)>=2) and (strcopy1(result,2,1)=':') and (strcopy1(result,1,1)<>'/') and (strcopy1(result,1,1)<>'\') then
   begin
   edrive:=strcopy1(io__exename+'Z',1,1);//pad with "Z" incase app.exename is empty for some reason - 14APR2011
   if (strcopy1(result,1,1)='?') then result:=edrive+strcopy1(result,2,low__len(result));
   end;
end;

function io__extractfileext(const x:string):string;//12apr2021
var
   p:longint;
begin
//defaults
result:='';

try
//get
if (x<>'') then
   begin
   for p:=low__len(x) downto 1 do
   begin
   if (strcopy1(x,p,1)='/') or (strcopy1(x,p,1)='\') then break
   else if (strcopy1(x,p,1)='.') then
      begin
      result:=strcopy1(x,p+1,low__len(x));
      break
      end;
   end;//p
   end;
except;end;
end;

function io__extractfileext2(const x,xdefext:string;xuppercase:boolean):string;//12apr2021
begin
result:=strdefb(io__extractfileext(x),xdefext);
if xuppercase then result:=strup(result);
end;

function io__extractfileext3(const x,xdefext:string):string;//lowercase version - 15feb2022
begin
result:=strlow(strdefb(io__extractfileext(x),xdefext));
end;

function io__lastfoldername(const xfolder,xdefaultname:string):string;
var
   str1:string;
   p:longint;
begin
//defaults
result:=xdefaultname;

try
//get
str1:=io__asfolderNIL(xfolder);
if (str1<>'') then
   begin
   for p:=(low__len(str1)-1) downto 1 do
   begin
   if (strbyte1(str1,p)=ssbackslash) or (strbyte1(str1,p)=ssslash) then
      begin
      str1:=strcopy1(str1,p+1,low__len(str1));
      break;
      end;
   end;//p
   //.trim trailing slash
   if (str1<>'') and ((strbyte1(str1,length(str1))=ssbackslash) or (strbyte1(str1,length(str1))=ssslash)) then str1:=strcopy1(str1,1,length(str1)-1);
   //set
   if (str1<>'') then result:=str1;
   end;
except;end;
end;

function io__extractfilepath(const x:string):string;//04apr2021
var
   p:longint;
begin
//defaults
result:='';

try
//get
if (x<>'') then
   begin
   for p:=low__len(x) downto 1 do if (strcopy1(x,p,1)='/') or (strcopy1(x,p,1)='\') then
      begin
      result:=strcopy1(x,1,p);
      break;
      end;
   end;
except;end;
end;

function io__extractfilename(const x:string):string;//05apr2021
var
   p:longint;
begin
result:='';

try
//defaults
result:=x;//allow default passthru -> this allows for instances with ONLY a filename present e.g. "aaaa.bcs"
//get
if (x<>'') then
   begin
   for p:=low__len(x) downto 1 do if (strcopy1(x,p,1)='/') or (strcopy1(x,p,1)='\') then
      begin
      result:=strcopy1(x,p+1,low__len(x));
      break;
      end;
   end;
except;end;
end;

function io__renamefile(const s,d:string):boolean;//local only, soft check - 27nov2016
begin
//defaults
result:=false;

try
if (s='') or (d='') then exit;
//hack check
if io__hack_dangerous_filepath_deny_mask(s) then exit;
if io__hack_dangerous_filepath_deny_mask(d) then exit;
//collision check
if strmatch(s,d) then
   begin
   result:=true;
   exit;
   end;
//get - Delphi renamefile
if io__fileexists(s) and (not io__fileexists(d)) then
   begin
   filecache__closeall_byname_rightnow(s);//close any open "s" instances - 12apr2024
   result:=win____MoveFile(pchar(s),pchar(d));
   end;
except;end;
end;

function io__shortfile(const xlongfilename:string):string;//translate long filenames to short filename, using MS api, for "MCI playback of filenames with 125+c" - 23FEB2008
var//Note: works only for existing filenames - short names accessed from disk system
  z:string;
  zlen:longint;
begin
result:='';

try
//defaults
result:=xlongfilename;
//get
low__setlen(z,max_path);
zlen:=win____getshortpathname(pchar(xlongfilename),pchar(z),max_path-1);
if (zlen>=1) then
   begin
   low__setlen(z,zlen);
   result:=z;
   end;
except;end;
end;

function io__asfolder(const x:string):string;//enforces trailing "\"
begin
if (strcopy1(x,low__len(x),1)<>'\') then result:=x+'\' else result:=x;
end;

function io__asfolderNIL(const x:string):string;//enforces trailing "\" AND permits NIL - 03apr2021, 10mar2014
begin
if (x='') then result:=''//nil
else if (not strmatch(strcopy1(x,2,2),':\')) and (not strmatch(strcopy1(x,2,2),':/')) and (strcopy1(x,1,1)<>'/') and (strcopy1(x,1,1)<>'\') then result:=x//straight pass-thru -> this allows for "home" to pass right thru unaffected - 31mar2021
else result:=io__asfolder(x);//as a folder in the format "?:\.....\" or "?:/...../" or "/..../" or "\...\"
end;

function io__folderaslabel(x:string):string;
var
   p:longint;
begin
//defaults
result:='';

try
//remove trailing slash
if (strcopy1(x,low__len(x),1)='/') or (strcopy1(x,low__len(x),1)='\') then strdel1(x,low__len(x),1);
//read down to next slash
if (x<>'') then for p:=low__len(x) downto 1 do if (strbyte1(x,p)=92) or (strbyte1(x,p)=47) then
   begin
   x:=strcopy1(x,p+1,low__len(x));
   break;
   end;
//set
result:=strdefb(x,'?');
except;end;
end;

function io__isfile(const x:string):boolean;
begin
result:=(strcopy1(x,low__len(x),1)<>'\') and (strcopy1(x,low__len(x),1)<>'/');
end;

function io__local(const x:string):boolean;
begin
result:=(strcopy1(x,1,1)<>'@');
end;

function io__canshowfolder(const x:string):boolean;//18may2025
begin
result:=(x<>'') and io__local(x);
end;

function io__driveexists(const x:string):boolean;//true=drive has content - 01may2025, 17may2021, 16feb2016, 25feb2015, 17AUG2010
var
   xdrive:string;
   orgerr,notused,volflags,serialno:dword;
begin
//defaults
result:=false;
orgerr:=0;

try
//check
if (x<>'') then xdrive:=x[stroffset]+':\' else exit;
//hack check
if io__hack_dangerous_filepath_deny_mask(xdrive) then exit;//17may2021
//check drive is in range
if not (  (xdrive[1+stroffset]=':') and ((xdrive[2+stroffset]='\') or (xdrive[2+stroffset]='/')) and ( (xdrive[0+stroffset]='!') or (xdrive[0+stroffset]='@') or (xdrive[0+stroffset]=intdisk_char) or ((xdrive[0+stroffset]>='a') and (xdrive[0+stroffset]<='z')) or ((xdrive[0+stroffset]>='A') and (xdrive[0+stroffset]<='Z')) )  ) then exit;
//get
if      (xdrive='@:\') then result:=false//no support for Name Network at this stage - nn.stable - 15mar2020
else if (xdrive=(intdisk_char+':\')) then result:=intdisk_inuse//internal disk
else
   begin
   try
   //fully qualified for maximum stability - 17may2021
   orgerr:=win____seterrormode(SEM_FAILCRITICALERRORS);//prevents the display of a prompt window asking for a FLOPPY or CD-DISK to be inserted as stated my MS - 04apr2021
   result:=boolean(win____getvolumeinformation(pchar(xdrive),nil,0,@serialno,notused,volflags,nil,0));
   except;end;
   win____seterrormode(orgerr);
   end;
except;end;
end;

function io__drivetype(const x:string):string;//15apr2021, 05apr2021
type
   tdrivetype2=(dtUnknown,dtNoDrive,dtFloppy,dtFixed,dtNetwork,dtCDROM,dtRAM);
var
   xdrive:string;
begin
//defaults
result:='';

try
//init
xdrive:=strup(strcopy1(x,1,1));
//get
if (xdrive<>'') then
   begin
   if      (xdrive='@')          then result:='nn'//name network
   else
      begin
      case tdrivetype2(win____getdrivetype(pchar(xdrive+':\'))) of
      dtFloppy:if (xdrive<='B') then result:='floppy' else result:='removable';
      dtFixed   :result:='fixed';
      dtNetwork :result:='network';
      dtCDROM   :result:='cd';
      dtRAM     :result:='ram';
      else       result:='fixed';
      end;//case
      end;//if
   end;
except;end;
end;

function io__drivelabel(const x:string;xfancy:boolean):string;//17may2021, 05apr2021
var//Note: Incorrectly returns UPPERCASE labels for removable disks - 30DEC2010
   xdrive,xlabel:string;
   p:longint;
   orgerr,notused,volflags,serialno:dword;
   buf:array[0..max_path] of char;
   buf2:array[0..max_path] of char;
begin
//defaults
result:='';
orgerr:=0;

try
//get
if (x<>'') then
   begin
   //init
   xdrive:=strcopy1(x,1,1)+':';
   xlabel:='';
   //label
   if io__driveexists(x) then
      begin
      //.internal disk
      if strmatch(strcopy1(x,1,1),intdisk_char) then xlabel:=intdisk_label
      //.standard disk drives "A-Z:\"
      else if ((x[0+stroffset]>='a') and (x[0+stroffset]<='z')) or ((x[0+stroffset]>='A') and (x[0+stroffset]<='Z')) then
         begin
         try
         //fully qualified for maximum stability - 17may2021
         orgerr:=win____seterrormode(SEM_FAILCRITICALERRORS);//prevents the display of a prompt window asking for a FLOPPY or CD-DISK to be inserted as stated my MS - 04apr2021
         fillchar(buf,sizeof(buf),0);
         fillchar(buf2,sizeof(buf2),0);
         buf[0]:=#$00;
         buf2[0]:=#$00;
         if boolean(win____getvolumeinformation(pchar(strcopy1(x,1,1)+':\'),buf,sizeof(buf),@serialno,notused,volflags,buf2,sizeof(buf2))) then setstring(xlabel,buf,pchar__strlen(buf));
         except;end;
         win____seterrormode(orgerr);
         end;
      end;
   //clean -> make more compatible with "Wine 5+" - 16apr2021
   if (xlabel<>'') then
      begin
      for p:=1 to low__len(xlabel) do if (strcopy1(xlabel,p,1)='?') or (strcopy1(xlabel,p,1)=#0) then
         begin
         xlabel:=strcopy1(xlabel,1,p-1);
         break;
         end;
      end;
   //set
   if xfancy then result:=xlabel+insstr(#32+'(',xlabel<>'')+xdrive+insstr(')',xlabel<>'') else result:=xlabel;
   end;
except;end;
end;

function io__filelist(xoutlist:tdynamicstring;xfullfilenames:boolean;xfolder,xmasklist,xemasklist:string):boolean;//06oct2022
begin
result:=io__filelist1(xoutlist,xfullfilenames,false,xfolder,xmasklist,xemasklist);
end;

function io__filelist1(xoutlist:tdynamicstring;xfullfilenames,xsubfolders:boolean;xfolder,xmasklist,xemasklist:string):boolean;//06oct2022
begin
result:=io__filelist21(xoutlist,xfullfilenames,xsubfolders,xfolder,'',xmasklist,xemasklist,0,0,maxcur,'');
end;

function io__filelist2(xoutlist:tdynamicstring;xfullfilenames:boolean;xfolder,xmasklist,xemasklist:string;xtotalsizelimit,xminsize,xmaxsize:comp;xminmax_emasklist:string):boolean;//31dec2023, 06oct2022
begin
result:=io__filelist21(xoutlist,xfullfilenames,false,xfolder,'',xmasklist,xemasklist,xtotalsizelimit,xminsize,xmaxsize,xminmax_emasklist);
end;

function io__filelist21(xoutlist:tdynamicstring;xfullfilenames,xsubfolders:boolean;xscanfolder,xfolder,xmasklist,xemasklist:string;xtotalsizelimit,xminsize,xmaxsize:comp;xminmax_emasklist:string):boolean;//18mar2025: fixed sub-folder failure, 20aug2024, 31dec2023, 06oct2022
label
   skipend;
const
   xfiles=true;
   xfolders=false;
   xallfiles='*';
var
   p,i:longint;
   xtotalsize,xsize:comp;
   c:tcmp8;
   xrec:tsearchrec;
   xfindopen:boolean;
   xsubfolderlist:tdynamicstring;
begin
result:=false;
xtotalsize:=0;
xsubfolderlist:=nil;
xfindopen:=false;
low__cls(@xrec,sizeof(xrec));//28sep2020

try
//check
if zznil(xoutlist,2183) then goto skipend;

//clear - 22aug2024: fixed, 20aug2024
if (xfolder='') then xoutlist.clear;

//init
if (xmasklist='') then xmasklist:=xallfiles;
if (xscanfolder='') then
   begin
   result:=true;
   goto skipend;
   end
else xscanfolder:=io__asfolder(xscanfolder);//28sep2020

//xtotalsizelimit
if (xtotalsizelimit<0) then xtotalsizelimit:=0;


//hack check
if io__hack_dangerous_filepath_allow_mask(xscanfolder) then goto skipend;

//open
case xfolders of
true:i:=win__findfirst(xscanfolder+xallfiles,faReadOnly or faHidden or faSysFile or faDirectory or faArchive or faAnyFile,xrec);
else i:=win__findfirst(xscanfolder+xallfiles,faReadOnly or faHidden or faSysFile or faArchive or faAnyFile,xrec);
end;
xfindopen:=(i=0);

//files and folders
while i=0 do
begin
//.skip system folders
if (xrec.name='.') or (xrec.name='..') then
   begin
   //nil
   end
//.add sub-folder --------------------------------------------------------------
else if io__faISfolder(xrec.attr) then
   begin
   if xsubfolders then
      begin
      if (xsubfolderlist=nil) then xsubfolderlist:=tdynamicstring.create;
      xsubfolderlist.value[xsubfolderlist.count]:=xrec.name+'\';//18mar2025
      end;
   end
//.add file --------------------------------------------------------------------
else
   begin
   if xfiles then
      begin
      //64bit size support - 31dec2023
      c.ints[0]:=xrec.finddata.nFileSizeLow;
      c.ints[1]:=xrec.finddata.nFileSizeHigh;
      xsize    :=c.val;

      if (((xsize>=xminsize) and (xsize<=xmaxsize)) or low__matchmasklist(xrec.name,xminmax_emasklist)) and ( low__matchmasklist(xrec.name,xmasklist) and ((xemasklist='') or (not low__matchmasklist(xrec.name,xemasklist))) ) then
         begin
         //at limit -> stop
         xtotalsize:=add64(xtotalsize,xsize);
         if (xtotalsizelimit>=1) and (xtotalsize>xtotalsizelimit) then
            begin
            result:=true;
            goto skipend;
            end;

         //add
         if xfullfilenames then xoutlist.value[xoutlist.count]:=xscanfolder+xrec.name
         else                   xoutlist.value[xoutlist.count]:=xfolder+xrec.name;
         end;
      end;
   end;
//.inc
i:=win__findnext(xrec);
end;//loop

//subfolders
if xsubfolders and (xsubfolderlist<>nil) and (xsubfolderlist.count>=1) then
   begin
   for p:=0 to (xsubfolderlist.count-1) do if (xsubfolderlist.value[p]<>'') and (not io__filelist21(xoutlist,xfullfilenames,xsubfolders,  xscanfolder+xsubfolderlist.value[p],  xfolder+xsubfolderlist.value[p]  ,xmasklist,xemasklist,xtotalsizelimit,xminsize,xmaxsize,xminmax_emasklist)) then goto skipend;
   end;

//successful
result:=true;
skipend:
except;end;
try
//free
freeobj(@xsubfolderlist);
if xfindopen then win__findclose(xrec);
except;end;
end;

function io__filelist3(xfolder,xmasklist,xemasklist:string;xfiles,xfolders,xsubfolders:boolean;xevent:tsearchrecevent;xevent2:tsearchrecevent2;xhelper:tobject):boolean;//31dec2023
label
   skipend;
const
   xallfiles='*';
var
   p,i:longint;
   xsize:comp;
   xdatenow,xdate:tdatetime;
   c:tcmp8;
   xrec:tsearchrec;
   xeventOK,xeventOK2,xfindopen:boolean;
   xsubfolderlist:tdynamicstring;
begin
//defaults
result:=false;
xsubfolderlist:=nil;
xfindopen:=false;
low__cls(@xrec,sizeof(xrec));//31dec2023
xdatenow:=date__now;
i:=0;

try
//check
xeventOK:=assigned(xevent);
xeventOK2:=assigned(xevent2);
if (not xeventOK) and (not xeventOK2) then goto skipend;
//init
if (xmasklist='') then xmasklist:=xallfiles;
if (xfolder='') then
   begin
   result:=true;
   goto skipend;
   end
else xfolder:=io__asfolder(xfolder);//28sep2020

//hack check
if io__hack_dangerous_filepath_allow_mask(xfolder) then goto skipend;
//get

//.open
case xsubfolders of
true:i:=win__findfirst(xfolder+xallfiles,faReadOnly or faHidden or faSysFile or faDirectory or faArchive or faAnyFile,xrec);
else i:=win__findfirst(xfolder+xallfiles,faReadOnly or faHidden or faSysFile or faArchive or faAnyFile,xrec);
end;

xfindopen:=(i=0);
while i=0 do
begin
//.skip system folders
if (xrec.name='.') or (xrec.name='..') then
   begin
   //nil
   end
//.add folder ------------------------------------------------------------------
else if io__faISfolder(xrec.attr) then
   begin
   //.subfolders
   if xsubfolders then
      begin
      if (xsubfolderlist=nil) then xsubfolderlist:=tdynamicstring.create;
      xsubfolderlist.value[xsubfolderlist.count]:=xrec.name;
      end;
   //.folders
   if xfolders then
      begin
      //init
      xsize:=0;
      xdate:=xdatenow;
      //fire the event - as a folder
      if xeventOK and (not xevent(xfolder,xrec,xsize,xdate,false,true,xhelper)) then goto skipend;
      if xeventOK2 and (not xevent2(xfolder,xrec,xsize,xdate,false,true,xhelper)) then goto skipend;
      end;
   end
//.add file --------------------------------------------------------------------
else
   begin
   //.files
   if xfiles and ( low__matchmasklist(xrec.name,xmasklist) and ((xemasklist='') or (not low__matchmasklist(xrec.name,xemasklist))) ) then
      begin
      //64bit size support - 31dec2023
      c.ints[0]:=xrec.finddata.nFileSizeLow;
      c.ints[1]:=xrec.finddata.nFileSizeHigh;
      xsize:=c.val;
      xdate:=io__fromfiletime(xrec.finddata.ftLastWriteTime);
      //fire the event
      if xeventOK and (not xevent(xfolder,xrec,xsize,xdate,true,false,xhelper)) then goto skipend;
      if xeventOK2 and (not xevent2(xfolder,xrec,xsize,xdate,true,false,xhelper)) then goto skipend;
      end;
   end;
//.inc
i:=win__findnext(xrec);
end;//while

//subfolders
if xsubfolders and (xsubfolderlist<>nil) and (xsubfolderlist.count>=1) then
   begin
   for p:=0 to (xsubfolderlist.count-1) do if not io__filelist3(io__asfolder(xfolder+xsubfolderlist.value[p]),xmasklist,xemasklist,xfiles,xfolders,xsubfolders,xevent,xevent2,xhelper) then goto skipend;
   end;

//successful
result:=true;
skipend:
except;end;
try
freeobj(@xsubfolderlist);
if xfindopen then win__findclose(xrec);
except;end;
end;

function io__folderlist(xoutlist:tdynamicstring;xfullfoldernames:boolean;xfolder,xmasklist,xemasklist:string):boolean;//22aug2024
begin
result:=io__folderlist2(xoutlist,xfullfoldernames,false,xfolder,xmasklist,xemasklist);
end;

function io__folderlist2(xoutlist:tdynamicstring;xfullfoldernames,xsubfolders:boolean;xfolder,xmasklist,xemasklist:string):boolean;//22aug2024
begin
result:=io__folderlist21(xoutlist,xfullfoldernames,xsubfolders,xfolder,'',xmasklist,xemasklist);
end;

function io__folderlist21(xoutlist:tdynamicstring;xfullfoldernames,xsubfolders:boolean;xscanfolder,xfolder,xmasklist,xemasklist:string):boolean;//18mar2025, 22aug2024
label
   skipend;
var
   p,i:longint;
   xrec:tsearchrec;
   xfindopen:boolean;
   xsubfolderlist:tdynamicstring;
begin
//defaults
result:=false;
xsubfolderlist:=nil;
xfindopen:=false;
low__cls(@xrec,sizeof(xrec));//28sep2020

try
//check
if zznil(xoutlist,2183) then goto skipend;

//clear - 22aug2024
if (xfolder='') then xoutlist.clear;

//init
if (xmasklist='') then xmasklist:='*';
if (xscanfolder='') then
   begin
   result:=true;
   goto skipend;
   end
else xscanfolder:=io__asfolder(xscanfolder);//28sep2020

//hack check
if io__hack_dangerous_filepath_allow_mask(xscanfolder) then goto skipend;

//open
i:=win__findfirst(xscanfolder+xmasklist,faReadOnly or faHidden or faDirectory,xrec);
xfindopen:=(i=0);

while i=0 do
begin
//.skip system folders
if (xrec.name='.') or (xrec.name='..') then
   begin
   //nil
   end
//.add folder ------------------------------------------------------------------
else if io__faISfolder(xrec.attr) then
   begin
   if xsubfolders then
      begin
      if (xsubfolderlist=nil) then xsubfolderlist:=tdynamicstring.create;
      xsubfolderlist.value[xsubfolderlist.count]:=xrec.name+'\';
      end;

   if low__matchmasklist(xrec.name,xmasklist) and ((xemasklist='') or (not low__matchmasklist(xrec.name,xemasklist))) then
      begin
      //add
      if xfullfoldernames then  xoutlist.value[xoutlist.count]:=xscanfolder+xrec.name+'\'
      else                      xoutlist.value[xoutlist.count]:=xfolder+xrec.name+'\';
      end;
   end;
//.inc
i:=win__findnext(xrec);
end;//while

//subfolders
if xsubfolders and (xsubfolderlist<>nil) and (xsubfolderlist.count>=1) then
   begin
   for p:=0 to (xsubfolderlist.count-1) do if (xsubfolderlist.value[p]<>'') and (not io__folderlist21(xoutlist,xfullfoldernames,xsubfolders,  xscanfolder+xsubfolderlist.value[p]  ,xfolder+xsubfolderlist.value[p]  ,xmasklist,xemasklist)) then goto skipend;
   end;

//successful
result:=true;
skipend:
except;end;
try
//free
freeobj(@xsubfolderlist);
if xfindopen then win__findclose(xrec);
except;end;
end;

function io__findimagewh(xdata:pobject;var xformat:string;var xw,xh:longint):boolean;//19feb2025: works for image formats BMP, JPG, PNG, GIF, TEA and TGA
label
   jpg;
var
   jpg_code:byte;
   jpg_len:word;
   int1,xlen,xpos,aSOD,aversion,aval1,aval2:longint;
   atransparent,asyscolors:boolean;

   function jpg__nextchunk:boolean;
   begin
   result:=(str__bytes0(xdata,xpos)=255) and (xpos<xlen);
   if result then
      begin
      int1:=xpos;

      inc(xpos);
      jpg_code:=str__bytes0(xdata,xpos);

      if (xpos<=1) then
         begin
         inc(xpos);
         jpg_len:=0;
         end
      else
         begin
         inc(xpos);
         jpg_len :=low__wrdr(str__wrd2(xdata,xpos));
         inc(xpos,jpg_len);
         end;

      //.found the info chunk with the image width/height info
      if (jpg_code=192) and (jpg_len>=17) then
         begin
         xh:=low__wrdr(str__wrd2(xdata,int1+5));
         xw:=low__wrdr(str__wrd2(xdata,int1+7));
         end;

      end;
   end;
begin
//defaults
result:=false;
xformat:='';
xw:=0;
xh:=0;
xpos:=0;
xlen:=str__len(xdata);

//format
if io__anyformat(xdata,xformat) then
   begin
   //.jpg
   if (xformat='JPG') then
      begin
jpg:
      if jpg__nextchunk and (jpg_code<>192) then goto jpg;
      end
   //.bmp
   else if (xformat='BMP') then
      begin
      if (str__len(xdata)>=27) then
         begin
         xw:=str__int4(xdata,18);
         xh:=str__int4(xdata,22);
         end;
      end
   //.png
   else if (xformat='PNG') then
      begin
      if (str__len(xdata)>=24) and (str__str0(xdata,12,4)=('IHDR')) then
         begin
         xw:=low__intr(str__int4(xdata,16));
         xh:=low__intr(str__int4(xdata,20));
         end;
      end
   //.gif
   else if (xformat='GIF') then
      begin
      if (str__len(xdata)>=24) then
         begin
         xw:=str__wrd2(xdata,6);
         xh:=str__wrd2(xdata,8);
         end;
      end
   //.tea
   else if (xformat='TEA') then
      begin
      if not tea__info3(xdata,false,xw,xh,aSOD,aversion,aval1,aval2,atransparent,asyscolors) then
         begin
         xw:=0;
         xh:=0;
         end;
      end
   //.tga
   else if (xformat='TGA') then
      begin
      if (str__len(xdata)>=15) then
         begin
         xw:=str__wrd2(xdata,12);
         xh:=str__wrd2(xdata,14);
         end;
      end
   //.ico
   else if (xformat='ICO') then
      begin
      if (str__len(xdata)>=8) then
         begin
         xw:=str__bytes0(xdata,6);
         xh:=str__bytes0(xdata,7);
         //.convert
         if (xw=0) then xw:=256;
         if (xh=0) then xh:=256;
         end;
      end;

   //successful
   result:=(xw>=1) and (xh>=1);
   end;
end;

function io__anyformatb(xdata:pobject):string;
begin
io__anyformat2(xdata,0,result);
end;

function io__anyformat2b(xdata:pobject;xfrompos:longint):string;
begin
io__anyformat2(xdata,xfrompos,result);
end;

function io__anyformata(const xdata:array of byte):string;//19feb2025, 25jan2025
var
   b:tstr8;
begin
try
b:=str__new8;
b.aadd1(xdata,1,100);
result:=io__anyformatb(@b);
except;end;
str__free(@b);
end;

function io__anyformat(xdata:pobject;var xformat:string):boolean;//returns EXT of any known format, image, sound, frame, etc - 14may2025, 20dec2024, 18nov2024, 30jan2021
begin
result:=io__anyformat2(xdata,0,xformat);
end;

function io__anyformat2(xdata:pobject;xfrompos:longint;var xformat:string):boolean;//returns EXT of any known format, image, sound, frame, etc - 11jun2025, 14may2025, 20dec2024, 18nov2024, 30jan2021
label
   skipend;

   function asame3(xfrom:longint;const x:array of byte;xcasesensitive:boolean):boolean;//20jul2024
   begin
   result:=str__asame3(xdata,xfrom+xfrompos,x,xcasesensitive);
   end;

   function i4(xpos:longint):longint;
   begin
   result:=str__int4(xdata,xpos+xfrompos);
   end;

   function w2(xpos:longint):byte;
   begin
   result:=str__wrd2(xdata,xpos+xfrompos);
   end;

   function xdib:boolean;//11jun2025
   begin
   result:=false;

   //header size
   case i4(0) of
   hsOS2:;
   hsW95:;
   hsV04_nocolorspace:;
   hsV04:;
   hsV05:;
   else  exit;
   end;

   //.planes
   if (w2(12)<>1) then exit;

   //.bits
   case w2(14) of
   1,4,8,16,24,32:;
   else exit;
   end;//case

   //.compression formats
   case i4(17) of
   BI_RGB:;
   BI_RLE8:;
   BI_RLE4:;
   BI_BITFIELDS:;
   BI_JPEG:;
   BI_PNG:;
   else   exit;
   end;

   //yes
   result:=true;
   end;
begin
//defaults
result:=false;
xformat:='';

try
//check
if not str__lock(xdata) then goto skipend;
if (str__len(xdata)<=0) then goto skipend;

//images -----------------------------------------------------------------------
//.bmp
if      asame3(0,[uuB,uuM],true)                                        then xformat:='BMP'//'BM'
//.dib
else if xdib                                                            then xformat:='DIB'//raw DIB (excludes the leading 12 byte BMP header)
//.wmf
else if asame3(0,[215,205,198,154],true)                                then xformat:='WMF'
//.emf
else if asame3(0,[1,0,0,0],true)                                        then xformat:='EMF'
//.png
else if asame3(0,[137,80,78,71,13,10,26,10],true)                       then xformat:='PNG'//27jan2021
//.pngc
else if asame3(0,[uuP,uuN,uuG,ssDash,uuC,uuE,uuL,uuL,uuS,nn1],false)    then xformat:='PNGC'//PNG-CELLS1
//.jpg
else if asame3(0,[uuJ,uuF,uuI,uuF],false)                               then xformat:='JPG'//'JFIF'
else if asame3(0,[255,216,255],true)                                    then xformat:='JPG'//for ALL jpegs FF,D8,FF = first 3 reliably identical bytes
//.jpgt
else if asame3(0,[uuJ,uuP,uuG,uuT],false)                               then xformat:='JPGT'//transparent jpeg
//.jpge
else if asame3(0,[uuJ,uuP,uuG,ssDash,uuE,nn1],false)                    then xformat:='JPGE'//JPG-E1 -> enhanced jpeg v1 - 29jan2021
//.jpgc
else if asame3(0,[uuJ,uuP,uuG,ssDash,uuC,uuE,uuL,uuL,uuS,nn1],false)    then xformat:='JPGC'//JPG-CELLS1 - 29jan2021
//.ico
else if (asame3(0,[0,0,0,0],true) or asame3(0,[0,0,1,0],true)) and
        (not asame3(4,[0,0],true))                                      then xformat:='ICO'
//.cur
else if asame3(0,[0,0,2,0],true) and (not asame3(4,[0,0],true))         then xformat:='ICO'
//.ani
else if asame3(0,[uuR,uuI,uuF,uuF],false) and
        asame3(8,[uuA,uuC,uuO,uuN],false)                               then xformat:='ANI'//RIFF -> ANI (animated cursor)
//.san
else if asame3(0,[uuT,uuP,uuF,nn0, 4 ,uuT,uuS,uuA,uuN],true)            then xformat:='SAN'
//.omi
else if asame3(0,[uuO,uuM,uuI],false)                                   then xformat:='OMI'
//.gif
else if asame3(0,[uuG,uuI,uuF],false)                                   then xformat:='GIF'
//.vbmp
else if asame3(0,[uuV,uuB,nn0,nn1],false)                               then xformat:='VBMP'
//.ppm
else if asame3(0,[uuP,nn3],false) or asame3(0,[uuP,nn6],false)          then xformat:='PPM'//3=ascii, 6=binary
//.pgm
else if asame3(0,[uuP,nn2],false) or asame3(0,[uuP,nn5],false)          then xformat:='PGM'//2=ascii, 5=binary
//.pbm
else if asame3(0,[uuP,nn1],false) or asame3(0,[uuP,nn4],false)          then xformat:='PBM'//1=ascii, 4=binary
//.pnm
else if asame3(0,[uuP,nn3],false) or asame3(0,[uuP,nn6],false)          then xformat:='PNM'//3=ascii, 6=binary -> need to look deeper to see if #10 or #32 is used for separators
//.xbm
else if asame3(0,[ssHash,uuD,uuE,uuF,uuI,uuN,uuE],false)                then xformat:='XBM'//#DEFINE
//.tep
else if asame3(0,[uuT,uuE],false) and ( asame3(2,[nn1],true) or
        asame3(2,[nn2],true) or asame3(2,[nn3],true) or
        asame3(2,[nn4],true) or asame3(2,[nn5],true) or
        asame3(2,[nn6],true) )                                          then xformat:='TEP'
//.tea
else if asame3(0,[uuT,uuE,uuA,nn1,ssHash],false)                        then xformat:='TEA'//TEA1#
else if asame3(0,[uuT,uuE,uuA,nn2,ssHash],false)                        then xformat:='TEA'//TEA2# - 12apr2021
else if asame3(0,[uuT,uuE,uuA,nn3,ssHash],false)                        then xformat:='TEA'//TEA3# - 32 bit color - 18nov2024
//.tem
else if asame3(0,[uuT,uuE,uuM,nn1,ssHash],false)                        then xformat:='TEM'
//.teh
else if asame3(0,[uuT,uuE,uuH,nn1,ssHash],false)                        then xformat:='TEH'
//.teb
else if asame3(0,[uuT,uuE,uuB,nn1,ssHash],false)                        then xformat:='TEB'
//.tec
else if asame3(0,[uuT,uuE,uuC,nn1,ssHash],false)                        then xformat:='TEC'
//.t24
else if asame3(0,[uuA,uuC,uuE,uuG],false)                               then xformat:='T24'
//.anm
else if asame3(0,[uuA,uuN,uuM,ssColon],false)                           then xformat:='ANM'
//.aan
else if asame3(0,[uuA,uuA,uuN,ssHash],false)                            then xformat:='AAN'
//.aas
else if asame3(0,[ssHash,uuI,uuN,uuI,uuT],false)                        then xformat:='AAS'//it's a bit general - 29NOV2010
//.gr8
else if asame3(0,[uuG,uuR,nn8,ssColon],false)                           then xformat:='GR8'
//.bw1
else if asame3(0,[uuB,uuW,nn1,ssColon],false)                           then xformat:='BW1'//1bit binary blackANDwhite - fast read/write - 14JUL2013
//.lig
else if asame3(0,[uuL,uuI,uuG,ssHash],false)                            then xformat:='LIG'//rapid 4bit full color image encoder - 02dec2018
//.b12
else if asame3(0,[uuB,nn1,nn2,ssHash],false)                            then xformat:='B12'//12bit RGB - fast read/write - 23nov2018
//.b04
else if asame3(0,[uuB,nn0,nn4,ssHash],false)                            then xformat:='B04'//4bit RGB - fast read/write - 28nov2018
//.yuv
else if asame3(0,[uuY,uuU,uuV,ssColon],false)                           then xformat:='YUV'//16bit TV format - fast read/write - 10APR2012
//.raw24
else if asame3(0,[uuR,uuA,uuW,24],true)                                 then xformat:='RAW24'
//.img32:
else if asame3(0,[uuI,uuM,uuG,nn3,nn2,ssColon],false)                   then xformat:='IMG32'//26jul2024
//.tj32::
else if asame3(0,[uuT,uuJ,nn3,nn2,ssColon,ssColon],false)               then xformat:='TJ32'//27jul2024
//.tga "[2/10]...[24/32]" or "[3/11]...[8]"
else if (asame3(2,[2],true) or asame3(2,[10],true)) and (asame3(16,[24],true) or asame3(16,[32],true)) then xformat:='TGA'//24 or 32 bpp color image (10=RLE) - 20dec2024
else if (asame3(2,[3],true) or asame3(2,[11],true)) and asame3(16,[8],true)                            then xformat:='TGA'//8 bpp greyscale image (11=RLE)- 20dec2024


//audio ------------------------------------------------------------------------
//.mid
else if asame3(0,[uuM,uuT,uuH,uuD],false)                               then xformat:='MID'//MTHD
else if asame3(0,[uuR,uuI,uuF,uuF],false) and asame3(8,[uuR,uuM,uuI,uuD],false) then xformat:='MID'//RIFF -> RMID
//.wav
else if asame3(0,[uuR,uuI,uuF,uuF],false) and asame3(8,[uuW,uuA,uuV,uuE],false) then xformat:='WAV'//RIFF -> WAVE
//.mp3
else if asame3(0,[uuI,uuD,nn3,3],true) or//ID3+#3
        asame3(0,[uuI,uuD,nn3,2],true) or//ID3+#2
        asame3(0,[255,251,226,68],true) or//#255#251#226#68
        asame3(0,[255,251,178,4],true) or//#255#251#178#4 or #255#251#144#68
        asame3(0,[255,251,144,68],true)                                 then xformat:='MP3'
//.wma
else if asame3(0,[48,38,178,117],true)                                  then xformat:='WMA'//#48#38#178#117
//.pcs - custom
else if asame3(0,[uuP,uuC,uuS,nn1,ssHash],false)                        then xformat:='PCS'//pc speaker sound
//.ssd - custom
else if asame3(0,[uuS,uuS,uuD,nn1,ssHash],false)                        then xformat:='SSD'//system sound

//encodings --------------------------------------------------------------------
//.b64
else if asame3(0,[uuB,nn6,nn4,ssColon],false)                           then xformat:='B64'//B64:
//.zip
else if asame3(0,[120,218],true) or asame3(0,[120,1],true) or
        asame3(0,[120,94],true)  or asame3(0,[120,156],true)            then xformat:='ZIP'
//.ioc
else if asame3(0,[uuC,ssExclaim,nn1],false)                             then xformat:='IOC'//compressed data header
//.ior
else if asame3(0,[uuC,ssExclaim,nn0],false)                             then xformat:='IOR'//raw data header (not compressed)
//.exe
else if asame3(0,[uuM,uuZ,uuP],false)                                   then xformat:='EXE'
//.dll
else if asame3(0,[uuM,uuZ,144],true)                                    then xformat:='DLL'
//.lnk
else if asame3(0,[uuL,0,0],true)                                        then xformat:='LNK'

//frames -----------------------------------------------------------------------
//sfm
else if asame3(0,[uuF,uuP,uuS,ssUnderscore,uuV,uuE,uuR,ssColon,ssSpace,uuV,nn0],false) then xformat:='SFM'//framer plus (v0) -> simple frame
//fps
else if asame3(0,[uuF,uuP,uuS,ssUnderscore,uuV,uuE,uuR,ssColon,ssSpace,uuV,nn1],false) then xformat:='FPS'//framer plus (v1) -> enhanced frame with LOGO support etc

//documents --------------------------------------------------------------------
//.bwp
else if asame3(0,[uuB,uuW,uuP,nn1],false)                               then xformat:='BWP'
//.bwd
else if asame3(0,[uuB,uuW,uuD,nn1],false)                               then xformat:='BWD'
//.rtf
else if asame3(0,[ssLCurlyBracket,ssbackslash,uuR,uuT,uuF,nn1,ssBackSlash],false) then xformat:='RTF'//22jun2022

//other ------------------------------------------------------------------------
else if asame3(0,[ssLSquarebracket,uuA,uuL,uuA,uuR,uuM,ssRSquarebracket],false) then xformat:='ALARMS'//08mar2022

else
   begin
   //nil
   end;

//successful
result:=(xformat<>'');
skipend:
except;end;
//free
str__uaf(xdata);
end;


//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//222222222222
//.filecache procs -------------------------------------------------------------
function filecache__recok(x:pfilecache):boolean;
begin
result:=(x<>nil) and x.init;
end;

procedure filecache__initrec(x:pfilecache;xslot:longint);//used internally by system
begin
//check
if (x=nil) then exit;

//clear
with x^ do
begin
init:=false;
time_created:=0;
time_idle:=0;
filehandle:=0;
filename:='';
filenameREF:=0;
opencount:=0;
usecount:=0;//only place this is set to zero again
read:=false;
write:=false;
slot:=xslot;
end;
end;

function filecache__idletime:comp;
begin
result:=add64(ms64,60000);//1 minute
end;

function filecache__enabled:boolean;
begin
result:=(system_filecache_limit>=21);
end;

function filecache__limit:longint;
begin
result:=system_filecache_limit;
end;

function filecache__safefilename(const x:string):boolean;
begin
result:=(x<>'') and (x[0+stroffset]<>'@') and (not io__hack_dangerous_filepath_deny_mask(x));
end;

procedure filecache__closeall;
var
   p:longint;
begin
for p:=0 to (system_filecache_limit-1) do if system_filecache_slot[p].init then system_filecache_slot[p].opencount:=0;
system_filecache_timer:=0;//act quickly
end;

procedure filecache__closeall_rightnow;
var
   p:longint;
begin
for p:=0 to (system_filecache_limit-1) do if system_filecache_slot[p].init then filecache__closerec(@system_filecache_slot[p]);
end;

procedure filecache__closeall_byname_rightnow(const x:string);
var
   p:longint;
   xref:comp;
begin
if (x<>'') and filecache__enabled then
   begin
   xref:=low__ref256u(x);
   for p:=0 to (system_filecache_limit-1) do if system_filecache_slot[p].init and (xref=system_filecache_slot[p].filenameREF) and strmatch(x,system_filecache_slot[p].filename) then filecache__closerec(@system_filecache_slot[p]);
   end;
end;

procedure filecache__closerec(x:pfilecache);
begin
if filecache__recok(x) then
   begin
   x.init:=false;
   if (x.filehandle>=1) then win____closehandle(x.filehandle);
   with x^ do
   begin
   time_created  :=0;
   time_idle     :=0;
   filehandle    :=0;
   filename      :='';
   filenameREF   :=0;
   opencount     :=0;
   read          :=false;
   write         :=false;
   end;
   //.inc usecount
   filecache__inc_usecount(x);
   end;
end;

procedure filecache__closefile(var x:pfilecache);
begin
if filecache__recok(x) then
   begin
   x.opencount:=frcmin32(x.opencount-1,0);
   if (x.opencount<=0) then system_filecache_timer:=0;//instruct management to act quickly
   //.not caching -> close file right now
   if not filecache__enabled then filecache__closerec(x);
   end;
end;

procedure filecache__inc_usecount(x:pfilecache);
begin
if filecache__recok(x) then
   begin
   //inc the "usecount" -> rolls between 1..max32, never hits zero - 12apr2024
   if (x^.usecount<max32) then inc(x^.usecount) else x^.usecount:=1;
   end;
end;

function filecache__newslot:longint;
var
   p:longint;
   xms64:comp;
begin
//defaults
result:=-1;

try
//new
if (result<0) then
   begin
   for p:=0 to (system_filecache_limit-1) do if not system_filecache_slot[p].init then
      begin
      result:=p;
      //.inc usecount
      filecache__inc_usecount(@system_filecache_slot[p]);
      //.stop
      break;
      end;
   end;

//oldest
if (result<0) then
   begin
   //.oldest with opencount=0
   if (result<0) then
      begin
      xms64:=0;
      for p:=0 to (system_filecache_limit-1) do if system_filecache_slot[p].init and (system_filecache_slot[p].opencount<=0) and ((system_filecache_slot[p].time_idle<xms64) or (xms64<=0)) then
         begin
         xms64:=system_filecache_slot[p].time_idle;
         result:=p;
         end;
      end;
   //.oldest regardless of opencount
   if (result<0) then
      begin
      xms64:=0;
      for p:=0 to (system_filecache_limit-1) do if system_filecache_slot[p].init and ((system_filecache_slot[p].time_idle<xms64) or (xms64<=0)) then
         begin
         xms64:=system_filecache_slot[p].time_idle;
         result:=p;
         end;
      end;
   //clear the slot
   if (result>=0) then filecache__closerec(@system_filecache_slot[result]);//auto increments the usecounter
   end;
except;end;

//emergency fallback - should never happen
if (result<0) then
   begin
   result:=0;
   //.inc usecount
   filecache__inc_usecount(@system_filecache_slot[result]);
   end;
end;

function filecache__find(const x:string;xread,xwrite:boolean;var xslot:longint):boolean;//13apr2024: updated
var//xread=false and xwrite=false -> returns any record without matching the read/write values - 13apr2024
   p:longint;
   xref:comp;
begin
//defaults
result:=false;
xslot:=0;

//check
if (x='') then exit;

//find
xref:=low__ref256u(x);
for p:=0 to (system_filecache_limit-1) do if system_filecache_slot[p].init and ((not xread) or system_filecache_slot[p].read) and ((not xwrite) or system_filecache_slot[p].write) and (xref=system_filecache_slot[p].filenameREF) and strmatch(x,system_filecache_slot[p].filename) then
   begin
   result:=true;
   xslot:=p;
   break;
   end;
end;

function filecache__remfile(const x:string):boolean;
begin
//defaults
result:=false;
//check
if not filecache__safefilename(x) then exit;

//close cached files -> any open instances MUST be closed regardless
filecache__closeall_byname_rightnow(x);

//file not found -> ok
if not io__fileexists(x) then
   begin
   result:=true;
   exit;
   end;

//delete the file
io__filesetattr(x,0);
win____deletefile(pchar(x));

//return result
result:=not io__fileexists(x);
end;

function filecache__openfile_anyORread(const x:string;var v:pfilecache;var vmustclose:boolean;var e:string):boolean;
var
   i:longint;
begin
//defaults
result:=false;
v:=nil;
vmustclose:=false;
e:=gecTaskfailed;

//exists in cache -> ignore read and write values
if (not result) and filecache__find(x,false,false,i) then
   begin
   system_filecache_slot[i].time_idle:=filecache__idletime;//keep record alive
   v:=@system_filecache_slot[i];
   if (system_filecache_slot[i].opencount<max32) then inc(system_filecache_slot[i].opencount);
   result:=true;
   end;

//open the file for reading
if (not result) then
   begin
   result:=filecache__openfile_read(x,v,e);
   if result then vmustclose:=true;
   end;
end;

function filecache__openfile_read(const x:string;var v:pfilecache;var e:string):boolean;
label
   redo,skipend;
var
   h:thandle;
   i:longint;

   function xopen_read:boolean;
   begin
   h:=win____createfile(pchar(x),generic_read,file_share_read or file_share_write,nil,open_existing,file_attribute_normal,0);
   if (h<=0) then h:=win____createfile(pchar(x),generic_read,file_share_read,nil,open_existing,file_attribute_normal,0);//fallback proc for readonly media -> in case it fails to open - 13apr2024
   result:=(h>=1);//13apr2024: updated
   end;
begin
//defaults
result:=false;
v:=nil;
e:=gecTaskfailed;

//check
if not filecache__safefilename(x) then
   begin
   e:=gecBadfilename;
   exit;
   end;

try
//exists in cache (read)
if (not result) and filecache__find(x,true,false,i) then
   begin
   system_filecache_slot[i].time_idle:=filecache__idletime;//keep record alive
   v:=@system_filecache_slot[i];
   if (system_filecache_slot[i].opencount<max32) then inc(system_filecache_slot[i].opencount);
   result:=true;
   end;

//create cache entry
if (not result) and io__fileexists(x) then
   begin
   //.inc open count
   if (system_filecache_filecount<max64) then system_filecache_filecount:=add64(system_filecache_filecount,1) else system_filecache_filecount:=1;

   //.open for reading
   if not xopen_read then
      begin
      //.close and try again
      filecache__closeall_byname_rightnow(x);
      if not xopen_read then
         begin
         e:=gecFileinuse;
         goto skipend;
         end;
      end;

   //.file is open
   if (h>=1) then
      begin
      i:=filecache__newslot;
      v:=@system_filecache_slot[i];
      with system_filecache_slot[i] do
      begin
      init          :=true;
      opencount     :=1;
      filehandle    :=h;//set the filehandle
      filename      :=x;
      filenameREF   :=low__ref256u(x);
      time_created  :=ms64;
      time_idle     :=filecache__idletime;//keep record alive
      read          :=true;
      write         :=false;
      end;//with
      //successful
      result:=true;
      end;
   end;

skipend:
except;end;
end;

function filecache__openfile_write(const x:string;var v:pfilecache;var e:string):boolean;
var
   bol1:boolean;
begin
result:=filecache__openfile_write2(x,false,bol1,v,e);
end;

function filecache__openfile_write2(const x:string;xremfile_first:boolean;var xfilecreated:boolean;var v:pfilecache;var e:string):boolean;
label
   skipend;
var
   h:thandle;
   i:longint;

   function xopen_write:boolean;
   var
      h2:thandle;
   begin
   //get
   case io__fileexists(x) of
   true:h:=win____createfile(pchar(x),generic_read or generic_write,file_share_read,nil,open_existing,file_attribute_normal,0);
   else begin
      case io__makefolder(io__extractfilepath(x)) of//create folder
      true:begin//create file
         h2:=win____createfile(pchar(x),generic_read or generic_write,0,nil,create_always,file_attribute_normal,0);
         if (h2>=1) then
            begin
            win____closehandle(h2);
//            h:=win____createfile(pchar(x),generic_read or generic_write,file_share_read,nil,open_existing,file_attribute_normal,0);
            h:=win____createfile(pchar(x),generic_read or generic_write,file_share_read,nil,open_existing,file_attribute_normal,0);
            if (h>=1) then xfilecreated:=true;
            end;
         end;
      else begin
         h:=0;
         e:=gecPathnotfound;
         end;
      end;//case
      end;
   end;//case
   //set
   result:=(h>=1);//updated 13apr2024
   end;
begin
//defaults
result:=false;
v:=nil;
e:=gecTaskfailed;
xfilecreated:=false;

//check
if not filecache__safefilename(x) then
   begin
   e:=gecBadfilename;
   exit;
   end;

try
//remfile_first
if xremfile_first and (not io__remfile(x)) then
   begin
   e:=gecFileinuse;
   goto skipend;
   end;

//exists in cache (write)
if (not result) and filecache__find(x,false,true,i) then
   begin
   system_filecache_slot[i].time_idle:=filecache__idletime;//keep record alive
   v:=@system_filecache_slot[i];
   if (system_filecache_slot[i].opencount<max32) then inc(system_filecache_slot[i].opencount);
   result:=true;
   end;

//create cache entry
if (not result) then
   begin
   //.inc open count
   if (system_filecache_filecount<max64) then system_filecache_filecount:=add64(system_filecache_filecount,1) else system_filecache_filecount:=1;

   //.open for writing
   if not xopen_write then
      begin
      //.close and try again
      filecache__closeall_byname_rightnow(x);
      if not xopen_write then
         begin
         e:=gecFileinuse;
         goto skipend;
         end;
      end;

   //.file is open
   if (h>=1) then
      begin
      i:=filecache__newslot;
      v:=@system_filecache_slot[i];
      with system_filecache_slot[i] do
      begin
      init          :=true;
      opencount     :=1;
      filehandle    :=h;
      filename      :=x;
      filenameREF   :=low__ref256u(x);
      time_created  :=ms64;
      time_idle     :=filecache__idletime;//keep record alive
      read          :=true;
      write         :=true;
      end;//with
      //successful
      result:=true;
      end;
   end;

skipend:
except;end;
end;

procedure filecache__managementevent;
var
   xcount,xactive,p:longint;
   xms64:comp;
begin
//defaults
xcount:=0;
xactive:=0;
//get
if msok(system_filecache_timer) then
   begin
   try
   //init
   xms64:=ms64;
   //get
   for p:=0 to (system_filecache_limit-1) do
   begin
   if system_filecache_slot[p].init then
      begin
      case (system_filecache_slot[p].opencount<=0) and (system_filecache_slot[p].time_idle<>0) and (xms64>system_filecache_slot[p].time_idle) of
      true:filecache__closerec(@system_filecache_slot[p]);//close record
      else begin
         xcount:=p+1;//upper boundary as defined by the highest active slot
         inc(xactive);//simply the number of slots open regardless of their position within the system pool
         end;
      end;//case
      end;//if
   end;//p
   except;end;
   //sync information vars
   system_filecache_count:=xcount;
   system_filecache_active:=xactive;
   //reset timer
   msset(system_filecache_timer,5000);
   end;//if
end;

//nav procs --------------------------------------------------------------------
function nav__count(x:tstr8):longint;//28dec2023
var
   xnavcount,xfoldercount,xfilecount:longint;
begin
result:=0;try;nav__info(x,xnavcount,xfoldercount,xfilecount,result);except;end;
end;

function nav__info(x:tstr8;var xnavcount,xfoldercount,xfilecount,xtotalcount:longint):boolean;
var
   cmp1,cmp2:comp;
   xtep:longint;
   str1,str2:string;
begin
//defaults
result:=false;

try
xnavcount    :=0;
xfoldercount :=0;
xfilecount   :=0;
xtotalcount  :=0;
//get
result:=nav__proc(x,'info',0,xnavcount,xtep,xfoldercount,xfilecount,xtotalcount,cmp1,cmp2,str1,str2);
except;end;
try
if not result then
   begin
   xnavcount    :=0;
   xfoldercount :=0;
   xfilecount   :=0;
   xtotalcount  :=0;
   end;
except;end;
end;

function nav__can(x:tstr8;var xsortname,xsortsize,xsortdate,xsorttype:boolean):boolean;
var
   xtep,int1,int2,int3,int4:longint;
   cmp1,cmp2:comp;
   str1,str2:string;
begin
//defaults
result:=false;

try
xsortname    :=false;
xsortsize    :=false;
xsortdate    :=false;
xsorttype    :=false;;
//get
result:=nav__proc(x,'can',0,int1,xtep,int2,int3,int4,cmp1,cmp2,str1,str2);
if result then
   begin
   xsortname    :=(int1=1);
   xsortsize    :=(int2=1);
   xsortdate    :=(int3=1);
   xsorttype    :=(int4=1);
   end;
except;end;
end;

function nav__init(x:tstr8):boolean;
var
   xtep,int1,int2,int3,int4:longint;
   cmp1,cmp2:comp;
   str1,str2:string;
begin
result:=false;try;result:=nav__proc(x,'init',0,int1,xtep,int2,int3,int4,cmp1,cmp2,str1,str2);except;end;
end;

function nav__add(x:tstr8;xstyle,xtep:longint;xsize:comp;const xname,xlabel:string):boolean;
begin
result:=false;try;result:=nav__add2(x,xstyle,xtep,xsize,2000,1,1,0,0,0,xname,xlabel);except;end;
end;

function nav__add2(x:tstr8;xstyle,xtep:longint;xsize:comp;xyear,xmonth,xday,xhr,xmin,xsec:longint;xname,xlabel:string):boolean;
var
   a:tcmp8;
   int1,int2,int3:longint;
begin
//defaults
result:=false;

//range
xyear:=frcrange32(xyear,0,50000);
xmonth:=frcrange32(xmonth,1,12);
xday:=frcrange32(xday,1,31);
xhr:=frcrange32(xhr,0,23);
xmin:=frcrange32(xmin,0,59);
xsec:=frcrange32(xsec,0,59);

//encode time
a.ints[0]:= xsec + (xmin*60) + (xhr*3600);

//encode date
a.ints[1]:=xmonth + (xday*13) + (xyear*416);

//get
result:=nav__proc(x,'add',0,xstyle,xtep,int1,int2,int3,xsize,a.val,xname,xlabel);
end;

function nav__sort(x:tstr8;xsortstyle:longint):boolean;
var
   xtep,int2,int3,int4:longint;
   cmp1,cmp2:comp;
   str1,str2:string;
begin
result:=nav__proc(x,'sort',0,xsortstyle,xtep,int2,int3,int4,cmp1,cmp2,str1,str2);
end;

function nav__end(x:tstr8;xsortstyle:longint):boolean;
var
   xtep,int2,int3,int4:longint;
   cmp1,cmp2:comp;
   str1,str2:string;
begin
result:=nav__proc(x,'end',0,xsortstyle,xtep,int2,int3,int4,cmp1,cmp2,str1,str2);
end;

function nav__get(x:tstr8;xindex:longint;var xstyle,xtep:longint;var xsize:comp;var xname,xlabel:string):boolean;
var
   xyear,xmonth,xday,xhr,xmin,xsec:longint;
begin
result:=nav__get2(x,xindex,xstyle,xtep,xsize,xyear,xmonth,xday,xhr,xmin,xsec,xname,xlabel);
end;

function nav__get2(x:tstr8;xindex:longint;var xstyle,xtep:longint;var xsize:comp;var xyear,xmonth,xday,xhr,xmin,xsec:longint;var xname,xlabel:string):boolean;
var
   int2,int3,int4:longint;
   xdate:comp;
begin
//defaults
result:=false;

try
xname:='';
xlabel:='';
xstyle:=0;
xtep:=tepNone;
xsize:=0;
xyear:=2000;
xmonth:=1;
xday:=1;
xhr:=0;
xmin:=0;
xsec:=0;
int2:=0;
int3:=0;
int4:=0;
//get
result:=nav__proc(x,'get', xindex,xstyle,xtep,int2,int3,int4,xsize,xdate,xname,xlabel);
if result then nav__date(xdate,xyear,xmonth,xday,xhr,xmin,xsec);
except;end;
end;

function nav__date(sdate:comp;var xyear,xmonth,xday,xhr,xmin,xsec:longint):boolean;//01feb2024
var
   a:tcmp8;
   int1:longint;
begin
//defaults
result:=false;

try
xyear:=2000;
xmonth:=1;
xday:=1;
xhr:=0;
xmin:=0;
xsec:=0;
a.val:=sdate;

//decode time
int1:=a.ints[0];
//.hr
xhr:=frcrange32(int1 div 3600,0,23);
dec(int1,xhr*3600);
//.min
xmin:=frcrange32(int1 div 60,0,59);
dec(int1,xmin*60);
//.sec
xsec:=frcrange32(int1,0,59);

//decode date
int1:=a.ints[1];
//.year
xyear:=frcrange32(int1 div 416,0,50000);
dec(int1,xyear*416);
//.day
xday:=frcrange32(int1 div 13,1,31);
dec(int1,xday*13);
//.month
xmonth:=frcrange32(int1,1,12);

//successful
result:=true;
except;end;
end;

function nav__list(x:tstr8;xsortstyle:longint;const xfolder,xmasklist,xemasklist:string;xnav,xfolders,xfiles:boolean):boolean;//04oct2020
begin
result:=nav__list2(0,x,xsortstyle,xfolder,xmasklist,xemasklist,xnav,xfolders,xfiles);
end;

function nav__list2(xownerid:longint;x:tstr8;xsortstyle:longint;const xfolder,xmasklist,xemasklist:string;xnav,xfolders,xfiles:boolean):boolean;//04oct2020
begin
result:=nav__list3(xownerid,x,xsortstyle,xfolder,xmasklist,xemasklist,xnav,xfolders,xfiles,min64,max64,'');
end;

function nav__list3(xownerid:longint;x:tstr8;xsortstyle:longint;xfolder,xmasklist,xemasklist:string;xnav,xfolders,xfiles:boolean;xminsize,xmaxsize:comp;xminmax_emasklist:string):boolean;//26feb2024: Upgraded 32bit filesize to 64bit, 04oct2020
label
   skipend;
const
   xallfiles='*';
var
   p,i,xyear,xmonth,xday,xhr,xmin,xsec:longint;
   xoutdate:tdatetime;
   xoutsize,xsize:comp;
   xrec:tsearchrec;
   xoutname,xoutnameonly,str1,str2:string;
   xoutfolder,xoutfile,xoutreadonly,bol1,xfindopen:boolean;

   procedure xrootnav;
   label
      skipend;
   var
      a:tdrivelist;
      p:longint;

      function xadd(xtep:longint;n,nlabel:string):boolean;
      begin
      result:=nav__add2(x,nltSysfolder,xtep,0,0,0,0,0,0,0,n,nlabel);
      end;

      function xaddfolder(n,nlabel:string):boolean;
      var
         xtep:longint;
      begin
      xtep:=low__foldertep2(xownerid,n);
      result:=nav__add2(x,nltSysfolder,xtep,0,0,0,0,0,0,0,n,nlabel);
      end;
   begin
   //disk drives
   nav__add2(x,nltTitle,tepNone,0,0,0,0,0,0,0,'Drives','');
   a:=io__drivelist;
   for p:=0 to high(a) do if a[p] and (not xaddfolder(char(65+p)+':\',io__drivelabel(char(65+p),true))) then goto skipend;
   //.internal disk
   if intdisk_inuse then xaddfolder(intdisk_char+':\',io__drivelabel(intdisk_char,true));//20jul2024, 04apr2021
   //system folders
   nav__add2(x,nltTitle,tepNone,0,0,0,0,0,0,0,'Special Folders','');
   xaddfolder(app__folder,'');
   xaddfolder(app__subfolder('Settings'),'');
   if io__folderexists(app__folder2('Backups',false)) then xaddfolder(app__subfolder('Backups'),'');//10feb2023
   xaddfolder(io__windesktop,'');
   xaddfolder(io__winstartmenu,'');
   xaddfolder(io__winprograms,'');
   xaddfolder(app__subfolder('temp'),'Portable Temp');//17may2022
   xaddfolder(io__wintemp,'Temp');
   //xaddfolder(wincommontemp,'Common Temp');//05apr2021
   skipend:
   end;

   function xfindsize:boolean;//pass-thru - 26feb2024
   var
      c:tcmp8;
   begin
   result:=true;
   c.ints[0]:=xrec.finddata.nFileSizeLow;
   c.ints[1]:=xrec.finddata.nFileSizeHigh;
   xsize:=c.val;
   end;

   procedure xfinddate2(a:tdatetime);
   var
      y,m,d,h,min,s,ms:word;
   begin
   low__decodedate2(a,y,m,d);
   low__decodetime2(a,h,min,s,ms);
   //set
   xyear   :=y;
   xmonth  :=m;
   xday    :=d;
   xhr     :=h;
   xmin    :=min;
   xsec    :=s;
   end;

   procedure xfinddate;
   begin
   xfinddate2(io__fromfiletime(xrec.finddata.ftLastWriteTime));
   end;
begin
//defaults
result:=false;
i:=0;
xfindopen:=false;
low__cls(@xrec,sizeof(xrec));//28sep2020

try
str__lock(@x);
//check
if zznil(x,2183) then goto skipend;
//init
if not nav__init(x) then goto skipend;
if (not xfolders) and (not xfiles) then goto skipend;
if (xmasklist='') then xmasklist:=xallfiles;
//low__reloadfastvars;
//if (xownerid>=1) then tep__delall20(xownerid);//delete any previous images done by us - 06apr2021
if (xfolder='') then
   begin
   xrootnav;
   result:=true;
   goto skipend;
   end
else xfolder:=io__asfolder(xfolder);//28sep2020

//hack check
if io__hack_dangerous_filepath_allow_mask(xfolder) then goto skipend;

//get
//.top title -> leave empty -> host can fill it with information in realtime - 04oct2020
if xnav and xfolders and xfiles then
   begin
   nav__add2(x,nltTitle,tepNone,0,0,0,0,0,0,0,'','');
   end;

//.add nav ---------------------------------------------------------------------
if xnav then
   begin
   //.home
   if not nav__add2(x,nltNav,tepNone,0,0,0,0,0,0,0,'','') then goto skipend;//"Home"
   //.nav sets
   bol1:=true;
   for p:=1 to low__len(xfolder) do if (xfolder[p-1+stroffset]='\') or (xfolder[p-1+stroffset]='/') then
      begin
      str1:=strcopy1(xfolder,1,p);
      if bol1 then
         begin
         bol1:=false;
         str2:=io__drivelabel(str1,true);//show drive label for first item in nav list
         end
      else str2:='';
      if (str1<>'') and (not nav__add2(x,nltNav,low__foldertep2(xownerid,str1),0,0,0,0,0,0,0,str1,str2)) then goto skipend;
      end;
   end;

//.internal disk support
if idisk__havescope(xfolder) then
   begin
   //get
   p:=0;
   while true do
   begin
   if idisk__findnext(p,xfolder,xfolders,xfiles,xoutname,xoutnameonly,xoutfolder,xoutfile,xoutdate,xoutsize,xoutreadonly) then
      begin
      //folder
      if xfolders and xoutfolder then
         begin
         xfinddate2(xoutdate);
         if not nav__add2(x,nltFolder,low__foldertep2(xownerid,xoutname),xoutsize,xyear,xmonth,xday,xhr,xmin,xsec,xoutnameonly,'') then goto skipend;
         end
      //file
      else if xfiles and xoutfile and ( low__matchmasklist(xoutnameonly,xmasklist) and ((xemasklist='') or (not low__matchmasklist(xoutnameonly,xemasklist))) ) then
         begin
         xfinddate2(xoutdate);
         if not nav__add2(x,nltFile,tepext(xoutnameonly),xoutsize,xyear,xmonth,xday,xhr,xmin,xsec,xoutnameonly,'') then goto skipend;
         end;
      end
   else break;//stop
   end;//loop
   //successful
   result:=true;
   goto skipend;
   end;


//.open
case xfolders of
true:i:=win__findfirst(xfolder+xallfiles,faReadOnly or faHidden or faSysFile or faDirectory or faArchive or faAnyFile,xrec);
else i:=win__findfirst(xfolder+xallfiles,faReadOnly or faHidden or faSysFile or faArchive or faAnyFile,xrec);
end;
xfindopen:=(i=0);
while i=0 do
begin
//.skip system folders
if (xrec.name='.') or (xrec.name='..') then
   begin
   //nil
   end
//.add folder ------------------------------------------------------------------
else if io__faISfolder(xrec.attr) then
   begin
   if xfolders then
      begin
      //init
      xfindsize;
      xfinddate;
      //get
      if not nav__add2(x,nltFolder,low__foldertep2(xownerid,io__asfoldernil(xfolder+xrec.name)),xsize,xyear,xmonth,xday,xhr,xmin,xsec,xrec.name,'') then goto skipend;
      end;
   end
//.add file --------------------------------------------------------------------
else
   begin
   if xfiles and xfindsize and (((xsize>=xminsize) and (xsize<=xmaxsize)) or low__matchmasklist(xrec.name,xminmax_emasklist)) and ( low__matchmasklist(xrec.name,xmasklist) and ((xemasklist='') or (not low__matchmasklist(xrec.name,xemasklist))) ) then
      begin
      //init
      xfindsize;
      xfinddate;
      //get
      if not nav__add2(x,nltFile,tepext(xrec.name),xsize,xyear,xmonth,xday,xhr,xmin,xsec,xrec.name,'') then goto skipend;
      end;
   end;
//.inc
i:=win__findnext(xrec);
end;//while
//successful
result:=true;
skipend:
except;end;
try;if xfindopen then win__findclose(xrec);except;end;
try
nav__end(x,xsortstyle);//finalise
str__uaf(@x);
except;end;
end;

function nav__proc(x:tstr8;xcmd:string;xindex:longint;var xstyle,xtep,xval1,xval2,xval3:longint;var xsize,xdate:comp;var xname,xlabel:string):boolean;//29may2025, 04apr2021, 25mar2021, 20feb2021
label
   skipend,skipdone;
const
   xmorespace    =500000;
   xhdrlen       =24;
   xdatasetsize  =25;//min.size - 06apr2021
   //counters
   xnavpos       =8;
   xfolderpos    =12;
   xfilepos      =16;
   xsortpos      =20;
var
   xnamelen,xlabellen,v1,v2,v3,p,int1,int2,int3,int4,int5,xcount:longint;

   function xlen:longint;
   begin
   result:=0;
   if zzok(x,7024) then result:=x.int4[4];
   if (result>x.datalen) then result:=x.datalen;
   end;

   procedure xsetlen(xval:longint);
   begin
   if zzok(x,7025) then x.int4[4]:=frcmin32(xval,xhdrlen);
   end;

   procedure xinfo(var xnavcount,xfoldercount,xfilecount,xtotalcount:longint);
   begin
   xnavcount:=frcmin32(x.int4[xnavpos],0);//nav.count
   xfoldercount:=frcmin32(x.int4[xfolderpos],0);//folder.count
   xfilecount:=frcmin32(x.int4[xfilepos],0);//file.count
   xtotalcount:=xnavcount+xfoldercount+xfilecount;//total.count
   end;

   function xsort(xsortstyle:longint):boolean;
   label//Note: Uses "nav__proc.int1"
      skipend;
   var
      v1,v2,v3,xcount,int2,int3,di,xfastlen:longint;
      a:tstr8;
      alist:pdllongint;

      function xfindstyle(xpos:longint;var xstyle:longint):boolean;
      var
         dlen:longint;
      begin
      //defaults
      result:=false;
      xstyle:=nltNav;
      //check dataset size
      if (xpos<0) or ((xpos+4)>xfastlen) then exit;
      dlen:=frcmin32(x.int4[xpos],0);
      if (dlen<xdatasetsize) or ((xpos+dlen)>xfastlen) then exit;
      //read dataset
      inc(xpos,4);
      xstyle:=frcrange32(x.byt1[xpos],0,nltMax);
      //successful
      result:=true;
      end;

      function xfindvals(xpos:longint;var xstyle,xtep:longint;var xsize,xdate:comp;var xname,xlabel:string):boolean;
      var
         xnamelen,xlabellen,nlen,dlen:longint;
      begin
      //defaults
      result:=false;
      xstyle:=nltNav;
      xtep:=tepNone;
      xsize:=0;
      xdate:=0;
      xname:='';
      xlabel:='';
      //check dataset size
      if (xpos<0) or ((xpos+4)>xfastlen) then exit;
      dlen:=frcmin32(x.int4[xpos],0);
      if (dlen<xdatasetsize) or ((xpos+dlen)>xfastlen) then exit;
      //read dataset
      inc(xpos,4);
      xstyle:=frcrange32(x.byt1[xpos],0,nltMax); inc(xpos,1);
      xtep  :=x.int4[xpos]; inc(xpos,4);//06apr2021
      xsize :=x.cmp8[xpos]; inc(xpos,8);
      xdate :=x.cmp8[xpos]; inc(xpos,8);
      //namelen+name+label - 04apr2021
      nlen:=dlen-xdatasetsize;
      if (nlen>=1) then
         begin
         //namelen
         xnamelen:=frcmin32(x.int4[xpos],0);
         inc(xpos,4);
         //name
         if (xnamelen>=1) then
            begin
            xname:=x.str[xpos,xnamelen];//zero-based
            inc(xpos,xnamelen);
            end;
         //label
         xlabellen:=nlen-4-xnamelen;
         if (xlabellen>=1) then
            begin
            xlabel:=x.str[xpos,xlabellen];//zero-based
            //inc(xpos,xlabellen);
            end;
         end;
      //successful
      result:=true;
      end;

      procedure xrev(s:tstr8);//25mar2021
      var
         d:tstr8;
         slist,dlist:pdllongint;
         xstyle,scount,p:Longint;
      begin
      try
      //defaults
      d:=nil;
      scount:=0;
      //check
      if (xcount<=0) or zznil(s,2185) then exit;
      //init
      d:=bnewlen(xcount*4);
      dlist:=d.pints4;
      slist:=s.pints4;
      //fill
      for p:=0 to (xcount-1) do dlist[p]:=slist[p];
      //write back to "s"
      //.nav - always at top -> never sort this
      for p:=0 to (xcount-1) do if xfindstyle(dlist[p],xstyle) and ((xstyle=nltNav) or (xstyle=nltSysfolder) or (xstyle=nltTitle)) then//nltTitle=25mar2021
         begin
         if (scount>=xcount) then break;
         slist[scount]:=dlist[p];
         inc(scount);
         end;
      //.all other items
      for p:=(xcount-1) downto 0 do if xfindstyle(dlist[p],xstyle) and (xstyle<>nltNav) and (xstyle<>nltSysFolder) and (xstyle<>nltTitle) then//nltTitle=25mar2021
         begin
         if (scount>=xcount) then break;
         slist[scount]:=dlist[p];
         inc(scount);
         end;
      except;end;
      try;str__free(@d);except;end;
      end;

      function xdatestr(v:comp):string;
      var
         a:tcmp8;
         int1,xhr,xmin,xsec,xyear,xmonth,xday:longint;
      begin
      try
      //defaults
      result:='';
      //init
      a.val:=v;
      //decode time
      int1:=a.ints[0];
      //.hr
      xhr:=frcrange32(int1 div 3600,0,23);
      dec(int1,xhr*3600);
      //.min
      xmin:=frcrange32(int1 div 60,0,59);
      dec(int1,xmin*60);
      //.sec
      xsec:=frcrange32(int1,0,59);

      //decode date
      int1:=a.ints[1];
      //.year
      xyear:=frcrange32(int1 div 416,0,50000);
      dec(int1,xyear*416);
      //.day
      xday:=frcrange32(int1 div 13,1,31);
      dec(int1,xday*13);
      //.month
      xmonth:=frcrange32(int1,1,12);

      //get -> yyyyMMddHHmmSS - 01oct2020
      result:=low__digpad11(xyear,4)+low__digpad11(xmonth,2)+low__digpad11(xday,2)+low__digpad11(xhr,2)+low__digpad11(xmin,2)+low__digpad11(xsec,2);
      except;end;
      end;

      procedure xsortname(s:tstr8;ssortstyle:longint);
      label
         skipend;
      var
         a,d:tstr8;
         c:tdynamicstring;
         alist,slist,dlist:pdllongint;
         xstyle,xtep,acount,scount,p:longint;
         xsize,xdate:comp;
         xval:string;
         bol1,srev:boolean;
      begin
      int1:=0;

      try
      //defaults
      a:=nil;
      d:=nil;
      c:=nil;
      scount:=0;
      //check
      if (xcount<=0) or zznil(s,2186) then exit;
      //init
      srev:=(ssortstyle=nlAsisD) or (ssortstyle=nlNameD) or (ssortstyle=nlSizeD) or (ssortstyle=nlDateD) or (ssortstyle=nlTypeD);
      //.asis
      if (ssortstyle=nlAsis) or (ssortstyle=nlAsisD) then
         begin
         if srev then xrev(s);
         goto skipend;
         end;
      a:=bnewlen(xcount*4);
      d:=bnewlen(xcount*4);
      alist:=a.pints4;
      dlist:=d.pints4;
      slist:=s.pints4;
      c:=tdynamicstring.create;
      //fill
      for p:=0 to (xcount-1) do dlist[p]:=slist[p];

      //nav - always at top -> never sort this
      for p:=0 to (xcount-1) do if xfindstyle(dlist[p],xstyle) and ((xstyle=nltNav) or (xstyle=nltSysfolder) or (xstyle=nltTitle)) then
         begin
         if (scount>=xcount) then break;
         slist[scount]:=dlist[p];
         inc(scount);
         end;

      //folders
      c.clear;
      acount:=0;
      for p:=0 to (xcount-1) do if xfindvals(dlist[p],xstyle,xtep,xsize,xdate,xname,xlabel) and (xstyle=nltFolder) then
         begin
         if (acount>=xcount) then break;
         alist[acount]:=dlist[p];
         c.value[acount]:=io__mssortstr(strlow(xname));//29may2025
         inc(acount);
         end;

      //.sort
      if (acount>=1) then
         begin
         c.sort(true);
         if (ssortstyle=nlName) or (ssortstyle=nlNameD) then bol1:=srev else bol1:=false;

         //.write back
         for p:=0 to (acount-1) do
         begin
         if (scount>=xcount) then break;
         case bol1 of
         true:slist[scount]:=alist[c.sindex(acount-1-p)];
         else slist[scount]:=alist[c.sindex(p)];
         end;
         inc(scount);
         end;//p
         end;

      //files
      c.clear;
      acount:=0;
      for p:=0 to (xcount-1) do if xfindvals(dlist[p],xstyle,xtep,xsize,xdate,xname,xlabel) and (xstyle=nltFile) then
         begin
         case ssortstyle of
         nlName,nlNameD:xval:=io__mssortstr(strlow(xname));//29may2025
         nlSize,nlSizeD:xval:=low__digpad20(xsize,20)+'|'+strlow(xname);
         nlDate,nlDateD:xval:=xdatestr(xdate)+'|'+strlow(xname);
         nlType,nlTypeD:xval:=io__readfileext(xname,true)+'|'+strlow(xname);
         end;
         if (acount>=xcount) then break;
         alist[acount]:=dlist[p];
         c.value[acount]:=xval;
         inc(acount);
         end;
      //.sort
      if (acount>=1) then
         begin
         c.sort(true);
         //.write back
         for p:=0 to (acount-1) do
         begin
         if (scount>=xcount) then break;
         case srev of
         true:slist[scount]:=alist[c.sindex(acount-1-p)];
         else slist[scount]:=alist[c.sindex(p)];
         end;
         inc(scount);
         end;//p
         end;
      skipend:
      except;end;
      try
      str__free(@a );
      str__free(@d);
      freeobj(@c);
      except;end;
      end;
   begin
   //defaults
   result:=false;
   try
   a:=nil;
   //init
   xinfo(v1,v2,v3,xcount);//totalcount => number of items in EACH sort.list
   a:=bnewlen(xcount*4);//pre-size list for ultra-fast access
   alist:=a.pints4;
   xfastlen:=xlen;

   //get -> "nlAsis" is default sortstyle - 01oct2020
   int2:=xhdrlen;
   //note: int1 is set to "xlen" by calling proc - 26apr2021
   di:=0;
   while true do
   begin
   if ((int2+4)<=int1) then
      begin
      int3:=x.int4[int2];//read dataset.size
      if (int3<xdatasetsize) then break;//dataset.size is always 25..N bytes
      if (di<xcount) then alist[di]:=int2 else break;
      inc(di);
      inc(int2,int3);
      end
   else break;
   end;//while
   //sort
   xsortname(a,xsortstyle);

   //store
   x.int4[xsortpos]:=int2;
   x.owr(a,int2);
   xsetlen(int2+(xcount*4));//set datasize to actual size of data now - 25sep2020
   //successful
   result:=true;
   skipend:
   except;end;
   try;str__free(@a);except;end;
   end;
begin
//defaults
result:=false;

try
str__lock(@x);
//check
if zznil(x,2187) then goto skipend;
//init
xcmd:=strlow(xcmd);
if (xcmd='init') then
   begin
   x.clear;
   x.aadd([70,108,116,49]);//"Flt1" - 0..3 -> note uppercase "F" denotes structure is in edit mode -> there are no quick lookup sort.lists present yet -> 25sep2020
   x.addint4(xhdrlen);//overall data size - 4..7 -> used for building data structure - 25sep2020
   x.addint4(0);//nav.count - 8..11
   x.addint4(0);//folder.count - 12..15
   x.addint4(0);//file.count - 16..19
   x.addint4(0);//sortlist.pos - 20..23
   goto skipdone;
   end;
//check
if (x.len<xhdrlen) then goto skipend;
//get
if      (xcmd='end') then
   begin
   //already finished -> "flt1"
   if x.asame([102,108,116,49]) then goto skipdone;
   //need to finish -> "Flt1" -> "flt1"
   if not x.asame([70,108,116,49]) then goto skipend;
   //init
   int1:=xlen;
   if (int1<xhdrlen) then goto skipend;
   if (int1<>x.len) then x.setlen(int1);//finalise size -> safe to append data now
   //finish
   xsetlen(x.len);//set datasize to actual size of data now - 25sep2020
   x.pbytes[0]:=llf;//change "F" to "f" -> marks structure as finished -> can "get" now - 25sep2020
   //sort
   int1:=xlen;//26apr2021
   xsort(xstyle);//fixed 20feb2021
   end
else if (xcmd='sort') then
   begin
   int1:=xlen;//26apr2021
   xsort(xstyle)//fixed 20feb2021
   end
else if (xcmd='info') then xinfo(xstyle,xval1,xval2,xval3)
else if (xcmd='add') then
   begin
   //init
   xnamelen:=low__len(xname);
   xlabellen:=low__len(xlabel);
   int1:=xlen;
   int2:=4+xnamelen+xlabellen;
   x.minlen(int1+xdatasetsize+int2+xmorespace);
   //range
   xstyle:=frcrange32(xstyle,0,nltMax);//0=nav, 1=folder, 2=file, 3=full folder (full path -> special folder, system folder etc)
   xsize:=frcmin64(xsize,0);
   //get
   x.int4[int1]:=xdatasetsize+int2;
   inc(int1,4);//dataset.size -> 22+name.len
   x.byt1[int1]:=xstyle;  inc(int1,1);
   x.int4[int1]:=xtep;    inc(int1,4);//06apr2021
   x.cmp8[int1]:=xsize;   inc(int1,8);
   x.cmp8[int1]:=xdate;   inc(int1,8);
   //.name+label - 04apr2021
   if (int2>=1) then
      begin
      //.namelen
      x.int4[int1]:=xnamelen;
      inc(int1,4);
      //.name
      for p:=0 to (xnamelen-1) do x.pbytes[int1+p]:=byte(xname[p+stroffset]);//zero-base string copy 0 25sep2020
      inc(int1,xnamelen);
      //.label
      for p:=0 to (xlabellen-1) do x.pbytes[int1+p]:=byte(xlabel[p+stroffset]);//zero-base string copy 0 25sep2020
      inc(int1,xlabellen);
      end;
   //set
   xsetlen(int1);
   //inc counters
   case xstyle of
   nltNav,nltTitle:         x.int4[xnavpos]   :=x.int4[xnavpos]+1;
   nltFolder,nltSysFolder:  x.int4[xfolderpos]:=x.int4[xfolderpos]+1;
   nltFile:                 x.int4[xfilepos]  :=x.int4[xfilepos]+1;
   end;//case
   end
else if (xcmd='get') then
   begin
   //check
   if not x.asame([102,108,116,49]) then goto skipend;//must be "flt1" -> init->add's->end
   //init
   int1:=frcmax32(xlen,x.len);
   xstyle:=nltNav;
   xval1:=0;
   xval2:=0;
   xval3:=0;
   xsize:=0;
   xdate:=0;
   xname:='';
   xlabel:='';
   xinfo(v1,v2,v3,xcount);//totalcount => number of items in EACH sort.list

   //check
   if (xindex<0) or (xindex>=xcount) then goto skipend;
   //use sortlist
   int2:=x.int4[xsortpos];
   if (int2<=0) then goto skipend;
   //.inc to sort.list postion requested by "xindex"
   inc(int2,(xindex*4));//ascending order

   //dataset.pos
   if (int2>=0) and ((int2+4)<=int1) then int3:=x.int4[int2] else goto skipend;

   //check dataset size
   if (int3<0) or ((int3+4)>int1) then goto skipend;
   int4:=frcmin32(x.int4[int3],0);
   if (int4<xdatasetsize) or ((int3+int4)>int1) then goto skipend;

   //read dataset
   inc(int3,4);
   xstyle:=frcrange32(x.byt1[int3],0,nltMax); inc(int3,1);//28sep2020
   xtep  :=x.int4[int3]; inc(int3,4);//06apr2021
   xsize :=x.cmp8[int3]; inc(int3,8);
   xdate :=x.cmp8[int3]; inc(int3,8);
   int5:=int4-xdatasetsize;
   //.xnamelen+xname+xlabel - 04apr2021
   if (int5>=1) then
      begin
      //namelen
      xnamelen:=frcmin32(x.int4[int3],0);
      inc(int3,4);
      //name
      if (xnamelen>=1) then
         begin
         xname:=x.str[int3,xnamelen];//zero-based
         inc(int3,xnamelen);
         end;
      //label
      xlabellen:=int5-4-xnamelen;
      if (xlabellen>=1) then
         begin
         xlabel:=x.str[int3,xlabellen];//zero-based
         //inc(int3,xlabellen);
         end;
      end;//int5
   end
else goto skipend;

//successful
skipdone:
result:=true;
skipend:
except;end;
try
if not result then
   begin
   xstyle:=0;
   xtep:=tepNone;//06apr2021
   xval1:=0;
   xval2:=0;
   xval3:=0;
   xsize:=0;
   xdate:=0;
   xname:='';
   end;
except;end;
//free
str__uaf(@x);
end;

//internal disk procs ----------------------------------------------------------
procedure idisk__init(const xnewlabel:string;const xteadata:array of byte);
var
   e:string;
begin
intdisk_inuse:=true;
//.label
if (xnewlabel<>'') then intdisk_label:=xnewlabel;
//.icon
case (sizeof(xteadata)>=2) of
true:idisk__tofile2('.be.tea',xteadata,e);
else idisk__remfile('.be.tea');
end;
end;

function idisk__fullname(const x:string):string;
begin
result:=x;
if (strcopy1(result,2,2)<>':\') then
   begin
   if ( strcopy1(result,1,3)<>(intdisk_char+':\') ) then result:=intdisk_char+':\'+result;
   end;
end;

function idisk__findnext(var xpos:longint;xfolder:string;xfolders,xfiles:boolean;var xoutname,xoutnameonly:string;var xoutfolder,xoutfile:boolean;var xoutdate:tdatetime;var xoutsize:comp;var xoutreadonly:boolean):boolean;
label//Supports single level of folders only -> all we need right now - 04apr2021
   skipend;
var
   dpos,xfolderlen,p,int1,int2:longint;
   str1:string;
   xisfile:boolean;
begin
//defaults
result:=false;
xoutname:='';
xoutnameonly:='';
xoutfolder:=false;
xoutfile:=false;
xoutdate:=date__now;
xoutsize:=0;
xoutreadonly:=false;

//range
if (xpos<0) then xpos:=0;
dpos:=xpos;

try
//check
if idisk__havescope(xfolder) then xfolder:=io__asfolder(xfolder) else goto skipend;

//init
xfolderlen:=low__len(xfolder);

//find
for p:=0 to high(intdisk_name) do
begin
dpos:=p+1;//inc
if (p>=xpos) then
   begin
   if (intdisk_name[p]<>'') then
      begin
      str1:=io__extractfilepath(intdisk_name[p]);
      if (str1<>'') then
         begin
         //init
         xisfile:=io__isfile(intdisk_name[p]);
         //get
         if (xfolders and (not xisfile) and strmatch(strcopy1(str1,1,xfolderlen),xfolder) and (low__len(str1)>xfolderlen)) or (xfiles and xisfile and strmatch(str1,xfolder)) then
            begin
            //get
            xoutname:=intdisk_name[p];
            xoutnameonly:='';
            case xisfile of
            true:begin//as a file
               if (xoutname<>'') then
                  begin
                  for int1:=low__len(xoutname) downto 1 do if (strcopy1(xoutname,int1,1)='\') or (strcopy1(xoutname,int1,1)='/') then
                     begin
                     xoutnameonly:=strcopy1(xoutname,int1+1,low__len(xoutname));
                     break;
                     end;
                  end;
               end;
            else begin//as a folder
               if (xoutname<>'') then
                  begin
                  int2:=0;
                  for int1:=low__len(xoutname) downto 1 do if (strcopy1(xoutname,int1,1)='\') or (strcopy1(xoutname,int1,1)='/') then
                     begin
                     inc(int2);
                     if (int2>=2) then
                        begin
                        xoutnameonly:=strcopy1(xoutname,int1+1,low__len(xoutname)-int1-1);//no slashes
                        break;
                        end;
                     end;
                  end;
               end;
            end;//case
            xoutfolder:=not xisfile;
            xoutfile:=xisfile;
            xoutdate:=intdisk_date[p];
            xoutreadonly:=intdisk_readonly[p];
            if xisfile and zzok(intdisk_data[p],1024) then xoutsize:=str__len(@intdisk_data[p]);
            //successful
            result:=true;
            //stop
            break;
            end;
         end;
      end;
   end;
end;//p

skipend:
except;end;
//range check
if (dpos>xpos) then xpos:=dpos;
end;

function idisk__havescope(const xname:string):boolean;
begin
result:=intdisk_inuse and (xname<>'') and (strcopy1(xname,1,1)=intdisk_char);
end;

function idisk__makefolder(xname:string;var e:string):boolean;
label
   skipend;
var
   xindex,int1,p:longint;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//check
if idisk__havescope(xname) then xname:=io__asfolder(xname) else goto skipend;
//check - allow ONE folder level only e.g. "!:\Images\" -> or two slashes
int1:=0;
for p:=1 to low__len(xname) do if (strcopy1(xname,p,1)='\') or (strcopy1(xname,p,1)='/') then inc(int1);
if (int1>2) then goto skipend;
//get
if not idisk__find(xname,true,xindex) then goto skipend;
//successful
result:=true;
skipend:
except;end;
end;

function idisk__folderexists(const xname:string):boolean;
var
   int1:longint;
begin
result:=idisk__havescope(xname) and idisk__find(io__asfolder(xname),false,int1);
end;

function idisk__fileexists(const xname:string):boolean;
var
   int1:longint;
begin
result:=idisk__havescope(xname) and idisk__find(xname,false,int1);
end;

function idisk__find(const xname:string;xcreatenew:boolean;var xindex:longint):boolean;
var
   p:longint;
begin
//defaults
result:=false;
xindex:=0;

try
//check
if (not intdisk_inuse) or (xname='') then exit;

//find existing
for p:=0 to high(intdisk_name) do if (intdisk_name[p]<>'') and strmatch(intdisk_name[p],xname) then
   begin
   xindex:=p;
   result:=true;
   break;
   end;
   
//create new
if (not result) and xcreatenew then
   begin
   for p:=0 to high(intdisk_name) do if (intdisk_name[p]='') then
      begin
      result:=true;
      xindex:=p;
      intdisk_name[p]:=xname;
      if zznil(intdisk_data[p],2005) then intdisk_data[p]:=str__new9;//create data handler - 03apr2021
      intdisk_readonly[p]:=false;
      break;
      end;//p
   end;
except;end;
end;

function idisk__remfile(const xname:string):boolean;
label
   skipend;
var
   xindex:longint;
begin
//defaults
result:=false;

try
//check
if not intdisk_inuse then goto skipend;

//find
if idisk__find(xname,false,xindex) then
   begin
   //check
   if intdisk_readonly[xindex] then goto skipend;
   //delete
   if zzok(intdisk_data[xindex],1025) then str__clear(@intdisk_data[xindex]);
   intdisk_name[xindex]:='';
   end;
//successful
result:=true;
skipend:
except;end;
end;

function idisk__tofile(const xname:string;xdata:pobject;var e:string):boolean;//30sep2021
begin
result:=idisk__tofile1(xname,xdata,false,e);
end;

function idisk__tofile1(xname:string;xdata:pobject;xdecompressdata:boolean;var e:string):boolean;//30sep2021
label
   skipend;
var
   xindex:longint;
   b:tstr9;
begin
//defaults
result:=false;
e:=gecTaskfailed;
b:=nil;

try
//lock
//zzstr(xdata,83);
if not str__lock(xdata) then goto skipend;
//check
if not intdisk_inuse then goto skipend;
//init
xname:=idisk__fullname(xname);
//find
if not idisk__find(xname,true,xindex) then goto skipend;
//check
if intdisk_readonly[xindex] then
   begin
   e:=gecReadonly;
   goto skipend;
   end;
//write
if str__ok(@intdisk_data[xindex]) then
   begin
   str__clear(@intdisk_data[xindex]);
   if xdecompressdata and strmatch(io__anyformatb(xdata),'zip') then//not a zip archive but a compressed data stream
      begin
      b:=str__new9;//use a buffer to leave "xdata" unmodified
      str__add(@b,xdata);
      if not low__decompress(@b) then goto skipend;
      str__add(@intdisk_data[xindex],@b);
      end
   else str__add(@intdisk_data[xindex],xdata);
   end;
//.date
intdisk_date[xindex]:=date__now;
//successful
result:=true;
skipend:
except;end;
try
str__uaf(xdata);
str__free(@b);
except;end;
end;

function idisk__tofile2(const xname:string;const xdata:array of byte;var e:string):boolean;//14apr2021
begin
result:=idisk__tofile21(xname,xdata,false,e);
end;

function idisk__tofile21(const xname:string;const xdata:array of byte;xdecompressdata:boolean;var e:string):boolean;//14apr2021
var
   a:tstr9;
begin
result:=false;

try
a:=nil;
a:=str__new9;
str__aadd(@a,xdata);
result:=idisk__tofile1(xname,@a,xdecompressdata,e);
except;end;
try;str__free(@a);except;end;
end;

function idisk__fromfile(xname:string;xdata:pobject;var e:string):boolean;
label
   skipend;
var
   xindex:longint;
begin
//defaults
result:=false;
e:=gecTaskfailed;

try
//lock
//zzstr(xdata,84);
if not str__lock(xdata) then goto skipend;

//init
str__clear(xdata);
xname:=idisk__fullname(xname);

//check
if not intdisk_inuse then goto skipend;

//find
if not idisk__find(xname,false,xindex) then
   begin
   e:=gecFilenotfound;
   goto skipend;
   end;

//read
if zzok(intdisk_data[xindex],1027) then str__add(xdata,@intdisk_data[xindex]);

//successful
result:=true;
skipend:
except;end;
try;str__uaf(xdata);except;end;
end;


//12bit stream procs -----------------------------------------------------------
function s12__pushinit(s:pobject;var sinfo:ts12_info;xappend:boolean;xeosCode:longint):boolean;
begin
if str__ok(s) then
   begin
   result:=true;
   sinfo.s:=s;
   if str__is8(s) then sinfo.s8:=(s^ as tstr8) else sinfo.s8:=nil;
   sinfo.slot:=0;
   sinfo.cval:=0;
   sinfo.xlen:=0;//na
   sinfo.xpos:=0;//na
   sinfo.xeos:=xeosCode;
   if not xappend then str__clear(sinfo.s);
   end
else result:=false;
end;

function s12__pushval(var sinfo:ts12_info;xval:longint):boolean;
var
   vtwovals,sv:longint;

   procedure sadd;
   begin
   if (sinfo.s8<>nil) then sinfo.s8.addbyt1(sv) else str__addbyt1(sinfo.s,sv);
   end;
begin
if (sinfo.s<>nil) then
   begin
   result:=true;

   //range
   if (xval<0) then xval:=0 else if (xval>max12) then xval:=max12;

   //get
   if (sinfo.slot=0) then//slot0
      begin
      sinfo.cval:=xval;
      sinfo.slot:=1;
      end
   else
      begin
      vtwovals:=sinfo.cval + (xval*(max12+1));
      sinfo.slot:=0;

      //split 24bits into 3x8bits
      //.1
      sv:=vtwovals shl 24;
      sv:=sv shr 24;
      sadd;

      //.2
      sv:=vtwovals shl 16;
      sv:=sv shr 16;
      sv:=sv shr 8;
      sadd;

      //.3
      sv:=vtwovals shl 8;
      sv:=sv shr 8;
      sv:=sv shr 16;
      sadd;
      end;
   end
else result:=false;
end;

function s12__pushEOS(var sinfo:ts12_info):boolean;//end of stream
begin
if (sinfo.s<>nil) then
   begin
   result:=true;

   //eos
   if (sinfo.xeos>=0) then s12__pushval(sinfo,sinfo.xeos);

   //write any remaining data to stream
   if (sinfo.slot<>0) then s12__pushval(sinfo,0);
   end
else result:=false;
end;

function s12__pullinit(s:pobject;var sinfo:ts12_info;sfrom,xeosCode:longint):boolean;
begin
if str__ok(s) then
   begin
   result:=true;
   sinfo.s:=s;
   if str__is8(s) then sinfo.s8:=(s^ as tstr8) else sinfo.s8:=nil;
   sinfo.slot:=0;
   sinfo.cval:=0;
   sinfo.xlen:=str__len(s);
   sinfo.xpos:=sfrom;
   sinfo.xeos:=xeosCode;
   end
else result:=false;
end;

function s12__pullval(var sinfo:ts12_info;var xval:longint):boolean;
begin
if (sinfo.s<>nil) then
   begin
   result:=(sinfo.xpos<sinfo.xlen) or (sinfo.slot<>0);

   if result then
      begin
      //.read 3bytes => 24bits => 2x12bit vals
      if (sinfo.slot=0) and (sinfo.xpos<sinfo.xlen) then
         begin
         if (sinfo.s8<>nil) then
            begin
            sinfo.v1:=sinfo.s8.bytes[sinfo.xpos+0];
            sinfo.v2:=sinfo.s8.bytes[sinfo.xpos+1];
            sinfo.v3:=sinfo.s8.bytes[sinfo.xpos+2];
            end
         else
            begin
            sinfo.v1:=str__bytes0(sinfo.s,sinfo.xpos+0);
            sinfo.v2:=str__bytes0(sinfo.s,sinfo.xpos+1);
            sinfo.v3:=str__bytes0(sinfo.s,sinfo.xpos+2);
            end;

         sinfo.pullval2:=sinfo.v1 + (sinfo.v2*256) + (sinfo.v3*256*256);
         sinfo.pullval1:=sinfo.pullval2 div (max12+1);
         sinfo.pullval2:=sinfo.pullval2-(sinfo.pullval1*(max12+1));

         //inc
         inc(sinfo.xpos,3);
         end;

      //.toggle slot0 or 1
      if (sinfo.slot=0) then
         begin
         sinfo.slot:=1;
         xval:=sinfo.pullval2;
         end
      else
         begin
         sinfo.slot:=0;
         xval:=sinfo.pullval1;
         end;

      //.check of "eosCode"
      if (sinfo.xeos>=0) and (xval=sinfo.xeos) then result:=false;//signal end of data stream
      end
   else xval:=0;

   end
else
   begin
   result:=false;
   xval:=0;
   end;
end;


end.
