unit gosszip;

interface
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot {$ifdef laz},windows, sysutils, zbase, zdeflate, zinflate{$endif};
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
//## Library.................. Zip support (gosszip.pas)
//## Version.................. 4.00.185 (+115)
//## Items.................... 6
//## Last Updated ............ 18jun2025, 09jun2025, 28may2025, 13may2025, 29apr2025, 22apr2025, 04apr2025, 27jan2025, 05dec2024, 01dec2024, 26nov2024, 15nov2024, 11nov2024, 10aug2024, 24jun2024, 17apr2024
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
//## | *__compress            | procs             | 1.00.070  | 04may2025   | Delphi 3 and Lazarus ZIP compression support for tstr8 and tstr9 binary streams - 17feb2024
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


//zip procs --------------------------------------------------------------------
function zip__compress(x:pobject;xcompress,xfast:boolean):boolean;//04may2025, 17feb2024, 05feb2021

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__zip(xname:string):string;//information specific to this unit of code


implementation


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__zip(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gosszip.*"
if (strcopy1(xname,1,8)='gosszip.') then strdel1(xname,1,8) else exit;

//get
if      (xname='ver')        then result:='4.00.185'
else if (xname='date')       then result:='18jun2025'
else if (xname='name')       then result:='Zip'
else
   begin
   //nil
   end;

except;end;
end;


//zip -> Delphi 3 --------------------------------------------------------------
{$ifdef d3}

{$L deflate.obj}
{$L inflate.obj}
{$L inftrees.obj}
{$L trees.obj}
{$L adler32.obj}
{$L infblock.obj}
{$L infcodes.obj}
{$L infutil.obj}
{$L inffast.obj}

const
   zlib_version    ='1.0.4';
   Z_NO_FLUSH      = 0;
   Z_PARTIAL_FLUSH = 1;
   Z_SYNC_FLUSH    = 2;
   Z_FULL_FLUSH    = 3;
   Z_FINISH        = 4;
   Z_OK            = 0;
   Z_STREAM_END    = 1;
   Z_NEED_DICT     = 2;
   Z_ERRNO         = (-1);
   Z_STREAM_ERROR  = (-2);
   Z_DATA_ERROR    = (-3);
   Z_MEM_ERROR     = (-4);
   Z_BUF_ERROR     = (-5);
   Z_VERSION_ERROR = (-6);
   Z_NO_COMPRESSION       =   0;
   Z_BEST_SPEED           =   1;
   Z_BEST_COMPRESSION     =   9;
   Z_DEFAULT_COMPRESSION  = (-1);
   Z_FILTERED            = 1;
   Z_HUFFMAN_ONLY        = 2;
   Z_DEFAULT_STRATEGY    = 0;
   Z_BINARY   = 0;
   Z_ASCII    = 1;
   Z_UNKNOWN  = 2;
   Z_DEFLATED = 8;

type
   TAlloc = function (AppData: Pointer; Items, Size: longint): Pointer;
   TFree = procedure (AppData, Block: Pointer);

   // Internal structure.  Ignore. - updated for "pointer instead of pchar" 26jan2021
   TZStreamRec = packed record
    next_in: pointer;//was: PChar;       // next input byte
    avail_in: longint;    // number of bytes available at next_in
    total_in: longint;    // total nb of input bytes read so far

    next_out: pointer;//was: PChar;      // next output byte should be put here
    avail_out: longint;   // remaining free space at next_out
    total_out: longint;   // total nb of bytes output so far

    msg: PChar;           // last error message, NULL if no error
    internal: Pointer;    // not visible by applications

    zalloc: TAlloc;       // used to allocate the internal state
    zfree: TFree;         // used to free the internal state
    AppData: Pointer;     // private data object passed to zalloc and zfree

    data_type: longint;   //  best guess about the data type: ascii or binary
    adler: longint;       // adler32 value of the uncompressed data
    reserved: longint;    // reserved for future use
   end;

//.deflate compresses data
function deflateInit_(var strm: TZStreamRec; level: longint; version: PChar; recsize: longint): longint; external;
function deflate(var strm: TZStreamRec; flush: longint): longint; external;
function deflateEnd(var strm: TZStreamRec): longint; external;
//.inflate decompresses data
function inflateInit_(var strm: TZStreamRec; version: PChar; recsize: longint): longint; external;
function inflate(var strm: TZStreamRec; flush: longint): longint; external;
function inflateEnd(var strm: TZStreamRec): longint; external;
function inflateReset(var strm: TZStreamRec): longint; external;

procedure _tr_init; external;
procedure _tr_tally; external;
procedure _tr_flush_block; external;
procedure _tr_align; external;
procedure _tr_stored_block; external;
procedure adler32; external;

procedure inflate_blocks_new; external;
procedure inflate_blocks; external;
procedure inflate_blocks_reset; external;
procedure inflate_blocks_free; external;
procedure inflate_set_dictionary; external;
procedure inflate_trees_bits; external;
procedure inflate_trees_dynamic; external;
procedure inflate_trees_fixed; external;
procedure inflate_trees_free; external;
procedure inflate_codes_new; external;
procedure inflate_codes; external;
procedure inflate_codes_free; external;
procedure _inflate_mask; external;
procedure inflate_flush; external;
procedure inflate_fast; external;

procedure _memset(P: Pointer; B: Byte; count: longint);cdecl;
begin
FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: longint);cdecl;
begin
Move(source^, dest^, count);
end;

function zlibAllocMem(AppData: Pointer; Items, Size: longint): Pointer;
begin
//was: low__getmem(Result, Items*Size,80021);//15may2021
getmem(Result, Items*Size);//15may2021
end;

procedure zlibFreeMem(AppData, Block: Pointer);
begin
freemem(Block);
//was: low__freemem(block,0,80020);//04may2021
end;

function d3__compress(s:tobject;xcompress,xfast:boolean):boolean;//expects "s" to be a valid tstr8/str9 object -> 17feb2024, 05feb2021
label
   more,skipend;
var
   d:tobject;
   xmustclose:boolean;
   strm:TZStreamRec;
   smem,t:pdlbyte;
   v,spos,smin,smax,tsize,slen:longint;
begin
//defaults
result:=false;
xmustclose:=false;
d:=nil;
t:=nil;
tsize:=4096;

try
//lock
if not str__lock(@s) then exit;
slen:=str__len(@s);
if (slen<=0) then
   begin
   result:=true;
   goto skipend;
   end;
d:=str__new9;

//init
low__cls(@strm,sizeof(strm));
strm.zalloc:=zlibAllocMem;
strm.zfree:=zlibFreeMem;
getmem(t,tsize);
case xcompress of
true:if (z_ok=deflateInit_(strm,low__aorb(Z_BEST_COMPRESSION,Z_BEST_SPEED,xfast),zlib_version,sizeof(strm))) then xmustclose:=true else goto skipend;
else if (z_ok=inflateInit_(strm,zlib_version,sizeof(strm))) then xmustclose:=true else goto skipend;
end;

//.out
strm.next_in:=nil;
strm.avail_in:=0;
strm.next_out:=t;
strm.avail_out:=tsize;

//get
spos:=0;
smax:=-2;
while true do
begin
//.read more data
if (strm.avail_in<=0) and (spos<slen) then
   begin
   if not block__fastinfo(@s,spos,smem,smin,smax) then goto skipend;
   strm.next_in:=smem;
   strm.avail_in:=smax-smin+1;
   inc(spos,smax-smin+1);
   end;

//.compress data
more:
if xcompress then v:=deflate(strm,z_sync_flush) else v:=inflate(strm,z_sync_flush);//z_sync_flush=works with very small buffers, whereas "z_no_flush" will fail - 16feb2024
//.ignore buf error as we may ask for data when there is none to be had -> simpler to implement - 17feb2024
if (v<0) and (v<>Z_BUF_ERROR) then goto skipend;

//.pull "out" data
if ((v=z_ok) or (v=z_stream_end)) and (strm.avail_out<tsize) then
   begin
   if not str__padd(@d,t,tsize-strm.avail_out) then goto skipend;
   strm.next_out:=t;
   strm.avail_out:=tsize;
   goto more;
   end;

//.finish
if (strm.avail_in<=0) and (strm.avail_out>=tsize) and (spos>=slen) then
   begin
   strm.next_out:=t;
   strm.avail_out:=tsize;
   if xcompress then deflate(strm,z_finish) else inflate(strm,z_finish);
   str__padd(@d,t,tsize-strm.avail_out);
   break;
   end;
end;//loop

//finalise s -> d
str__clear(@s);
if not str__add(@s,@d) then goto skipend;

//successful
result:=true;
skipend:
except;end;
try
if xmustclose then
   begin
   if xcompress then deflateEnd(strm) else inflateEnd(strm);
   end;
freemem(t,tsize);
except;end;
try
str__free(@d);
if (not result) then str__clear(@s);
str__uaf(@s);
except;end;
end;
{$endif}


//zip -> Lazarus ---------------------------------------------------------------
{$ifdef laz}
function laz__compress(s:tobject;xcompress,xfast:boolean):boolean;//expects "s" to be a valid tstr8/str9 object -> 17feb2024, 05feb2021
label
   more,skipend;
var
   d:tobject;
   xmustclose:boolean;
   strm:z_stream;
   smem,t:pdlbyte;
   int1,v,spos,smin,smax,tsize,slen:longint;
begin
//defaults
result:=false;
xmustclose:=false;
d:=nil;
t:=nil;
tsize:=4096;

try
//lock
if not str__lock(@s) then exit;
slen:=str__len(@s);
if (slen<=0) then
   begin
   result:=true;
   goto skipend;
   end;
d:=str__new9;

//init
low__cls(@strm,sizeof(strm));
//not used: strm.zalloc
//not used: strm.zfree
getmem(t,tsize);
case xcompress of
true:if (z_ok=deflateInit_(@strm,low__aorb(Z_BEST_COMPRESSION,Z_BEST_SPEED,xfast),zlib_version,sizeof(strm))) then xmustclose:=true else goto skipend;
else if (z_ok=inflateInit_(@strm,zlib_version,sizeof(strm))) then xmustclose:=true else goto skipend;
end;

//.out
strm.next_in:=nil;
strm.avail_in:=0;
strm.next_out:=pbyte(t);
strm.avail_out:=tsize;

//get
spos:=0;
smax:=-2;
while true do
begin
//.read more data
if (strm.avail_in<=0) and (spos<slen) then
   begin
   if not block__fastinfo(@s,spos,smem,smin,smax) then goto skipend;
   strm.next_in:=pbyte(smem);
   strm.avail_in:=smax-smin+1;
   inc(spos,smax-smin+1);
   end;

//.compress data
more:
if xcompress then v:=deflate(strm,z_sync_flush) else v:=inflate(strm,z_sync_flush);
//.ignore buf error as we may ask for data when there is none to be had -> simpler to implement - 17feb2024
if (v<0) and (v<>Z_BUF_ERROR) then goto skipend;

//.pull "out" data
if ((v=z_ok) or (v=z_stream_end)) and (strm.avail_out<tsize) then
   begin
   if not str__padd(@d,t,tsize-strm.avail_out) then goto skipend;
   strm.next_out:=pbyte(t);
   strm.avail_out:=tsize;
   goto more;
   end;

//.finish
if (strm.avail_in<=0) and (strm.avail_out>=tsize) and (spos>=slen) then
   begin
   strm.next_out:=pbyte(t);
   strm.avail_out:=tsize;
   if xcompress then deflate(strm,z_finish) else inflate(strm,z_finish);
   str__padd(@d,t,tsize-strm.avail_out);
   break;
   end;
end;//loop

//finalise s -> d
str__clear(@s);
if not str__add(@s,@d) then goto skipend;

//successful
result:=true;
skipend:
except;end;
try
if xmustclose then
   begin
   if xcompress then deflateEnd(strm) else inflateEnd(strm);
   end;
freemem(t,tsize);
except;end;
try
str__free(@d);
if (not result) then str__clear(@s);
str__uaf(@s);
except;end;
end;
{$endif}


//zip procs --------------------------------------------------------------------
function zip__compress(x:pobject;xcompress,xfast:boolean):boolean;//04may2025, 17feb2024, 05feb2021
begin
//defaults
result:=false;

//check
if not str__ok(x) then exit;

{$ifdef d3}  result:=d3__compress(x^,xcompress,xfast); {$endif}
{$ifdef laz} result:=laz__compress(x^,xcompress,xfast); {$endif}
end;


end.
