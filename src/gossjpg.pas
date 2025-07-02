unit gossjpg;

interface
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot {$ifdef laz}{$ifdef jpeg},windows, sysutils, classes, graphics, JcParam, JDataDst, JDataSrc, JCOMapi, JcAPIstd, JdAPIstd, FPReadJPEG, JPEGLib, JcAPImin, JdAPImin{$endif}{$endif};
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
//##
//## Delphi 3 JPEG Support:
//## This unit uses jpeg API procs by IJG copyright (C) 1991-1996, Thomas G. Lane
//## For more information see the included README text document at the bottom of this file
//##
//## Lazarus 2 JPEG Support:
//## This unit uses jpeg API procs copyright (C) 1991-1998, Thomas G. Lane.
//## Source: jpeglib.h+jpegint.h
//##
//## ==========================================================================================================================================================================================================================
//## Library.................. Jpeg support (gossjpg.pas)
//## Version.................. 4.00.251 (+39)
//## Items.................... 1
//## Last Updated ............ 18jun2025, 27may2025, 05may2025, 17feb2024
//## Lines of Code............ 1,500+
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
//## | jpg__*                 | family of procs   | 1.00.212  | 16jun2025   | JPEG image io procs -> read and write jpeg images to/from tstr8 and tstr9 handlers - 05may2025
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


{$ifdef jpeg}
function jpg____fromdata(s:pobject;d:tobject):boolean;
function jpg____todata(s:pobject;d:tobject;dquality100:longint):boolean;//16jun2025
{$endif}


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__jpg(xname:string):string;//information specific to this unit of code


implementation

uses gosswin, gossio {$ifdef jpeg},gossimg{$endif};


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__jpg(xname:string):string;//information specific to this unit of code
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//check -> xname must be "gossjpg.*"
if (strcopy1(xname,1,8)='gossjpg.') then strdel1(xname,1,8) else exit;

//get
if      (xname='ver')        then result:='4.00.251'
else if (xname='date')       then result:='18jun2025'
else if (xname='name')       then result:='Jpeg'
else
   begin
   //nil
   end;

except;end;
end;


//jpeg support - Lazarus -------------------------------------------------------
{$ifdef jpeg}
{$ifdef laz}

procedure err__JpegError(cinfo: j_common_ptr);//25may2025
begin
//suppress error #36
if (cinfo^.err^.msg_code=36) then exit;

raise Exception.CreateFmt('JPEG error '+k64(cinfo^.err^.msg_code),[cinfo^.err^.msg_code]);//reguired -> feeds error back to calling proc
end;

procedure err__EmitMessage(cinfo: j_common_ptr; msg_level: Integer);
begin
//
end;

procedure err__OutputMessage(cinfo: j_common_ptr);
begin
//
end;

procedure err__FormatMessage(cinfo: j_common_ptr;var buffer: ansistring);
begin
//
end;

procedure err__ResetErrorMgr(cinfo: j_common_ptr);
begin
cinfo^.err^.num_warnings :=0;
cinfo^.err^.msg_code     :=0;
end;

const
   jpeg_std_error:jpeg_error_mgr=( error_exit: err__JpegError; emit_message: err__EmitMessage; output_message: err__OutputMessage; format_message: err__FormatMessage; reset_error_mgr: err__ResetErrorMgr);

function jpg____todata(s:pobject;d:tobject;dquality100:longint):boolean;//16jun2025
label
   skipend0,skipend;
var
   sdata:tmemstr;
   j:jpeg_compress_struct;
   a:tstr8;
   dbits,dx,dw,dh:longint;
   dr32:pcolorrow32;
   ar24,dr24:pcolorrow24;
   dr8 :pcolorrow8;
   c32:tcolor32;
   c24:tcolor24;

   procedure xswap_rb24;
   var
      v:byte;
   begin
   v:=c24.r;
   c24.r:=c24.b;
   c24.b:=v;
   end;
begin
//defaults
result:=false;
a     :=nil;
sdata :=nil;
//.jpeg compression record
low__cls(@j,sizeof(j));
j.err :=@jpeg_std_error;//local var => thread isolation

try
//check
if not str__lock(s)              then goto skipend;
if not misok82432(d,dbits,dw,dh) then goto skipend;

//range
dquality100:=frcrange32(dquality100,1,100);

//init
str__clear(s);
a:=str__new8;
a.minlen( mis__rowsize4(dw,24) );
sdata:=tmemstr.create(s^);

//get - compress
jpeg_CreateCompress(@j,JPEG_LIB_VERSION,sizeof(j));
jpeg_stdio_dest(@j,@sdata);
j.image_width      :=dw;
j.image_height     :=dh;
j.input_components :=3;// JPEG requires 24bit RGB input
j.in_color_space   :=JCS_RGB;

jpeg_set_defaults(@j);
jpeg_set_quality(@j,dquality100,true);

try
jpeg_start_compress(@j,true);
ar24:=a.scanline(0);

while (j.next_scanline<j.image_height) do
begin
if not misscan82432(d,j.next_scanline,dr8,dr24,dr32) then goto skipend0;

//32 -> 24
if (dbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   c32:=dr32[dx];
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   xswap_rb24;
   ar24[dx]:=c24;
   end;//dx
   end
//24 -> 24
else if (dbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   c24:=dr24[dx];
   xswap_rb24;
   ar24[dx]:=c24;
   end;//dx
   end
//8 -> 24
else if (dbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   c24.r:=dr8[dx];
   c24.g:=c24.r;
   c24.b:=c24.r;//16jun2025
   ar24[dx]:=c24;
   end;//dx
   end;

if (1<>jpeg_write_scanlines(@j,@a.core,1)) then goto skipend0;
end;//loop

//set
//str__settext(s,sdata.datastring);

//successful
result:=true;
skipend0:
jpeg_finish_compress(@j);
except;end;

skipend:
except;end;
//free
try;if (j.err<>nil) then jpeg_destroy(@j.err);except;end;
str__uaf(s);
str__free(@a);
freeobj(@sdata);
end;

function jpg____fromdata(s:pobject;d:tobject):boolean;
label//copy pixels from jpeg stream "s" to image "d"
     //s = tstr8 or tstr9 object
     //d = tbasicimage, trawimage, or twinbmp
   skipend0,skipend;
var
   sdata:tmemstr;
   j    :jpeg_decompress_struct;
   arow:tstr8;
   dx,dbits,dw,dh:longint;
   dr32:pcolorrow32;
   sr24,dr24:pcolorrow24;
   dr8 :pcolorrow8;
   c32:tcolor32;
   c24:tcolor24;

   procedure xswap_rb24;
   var
      v:byte;
   begin
   v:=c24.r;
   c24.r:=c24.b;
   c24.b:=v;
   end;
begin
//defaults
result:=false;
arow  :=nil;
sdata :=nil;
//.jpeg decompression record
low__cls(@j,sizeof(j));
j.err :=@jpeg_std_error;//local var => thread isolation

try
//check
if not str__lock(s)              then goto skipend;
if (str__len(s)<=0)              then goto skipend;
if not misok82432(d,dbits,dw,dh) then goto skipend;

//.s -> sdata
sdata:=tmemstr.create(s^);

//get - decompress
jpeg_createdecompress(@j,JPEG_LIB_VERSION,sizeof(j));//#1.s

try
jpeg_stdio_src(@j,@sdata);//read directly from "sdata.core"
jpeg_read_header(@j,true);

j.scale_num               :=1;
j.scale_denom             :=1;//full size
j.do_block_smoothing      :=true;
j.quantize_colors         :=false;//no greyscale -> use 24bit always
j.out_color_space         :=JCS_RGB;

//.best speed
j.dct_method              :=JDCT_ISLOW;//16jun2025 - was: JDCT_IFAST;
j.two_pass_quantize       :=false;
j.dither_mode             :=JDITHER_NONE;//was: JDITHER_ORDERED;

dw   :=frcmin32(j.image_width,1);
dh   :=frcmin32(j.image_height,1);
arow :=str__new8;
arow.setlen( mis__rowsize4(dw,24) );//27may2025

//size
if not missize(d,dw,dh) then goto skipend0;

//get -> scan lines in RGB format
if not jpeg_start_decompress(@j) then goto skipend0;//#2.s
if (j.output_components<>3)      then goto skipend0;

while (j.output_scanline < dh) do
begin
if (1=jpeg_read_scanlines(@j, @arow.core, 1)) then
   begin
   if misscan82432(d,j.output_scanline-1,dr8,dr24,dr32) then
      begin
      sr24:=arow.scanline(0);

      //24 -> 32
      if (dbits=32) then
         begin
         for dx:=0 to (dw-1) do
         begin
         c24:=sr24[dx];
         xswap_rb24;
         c32.r:=c24.r;
         c32.g:=c24.g;
         c32.b:=c24.b;
         c32.a:=255;
         dr32[dx]:=c32;
         end;//dx
         end
      //24 -> 24
      else if (dbits=24) then
         begin
         for dx:=0 to (dw-1) do
         begin
         c24:=sr24[dx];
         xswap_rb24;
         dr24[dx]:=c24;
         end;//dx
         end
      //24 -> 8
      else if (dbits=8) then
         begin
         for dx:=0 to (dw-1) do
         begin
         c24:=sr24[dx];
         if (c24.g>c24.r) then c24.r:=c24.g;
         if (c24.b>c24.r) then c24.r:=c24.b;
         dr8[dx]:=c24.r;
         end;//dx
         end;
      end;
   end
else break;
end;//loop

//successful
result:=true;

//finish
jpeg_finish_decompress(@j);//#2.f

skipend0:
finally
//free
jpeg_destroy_decompress(@j);//#1.f
end;

skipend:
except;end;
//free
try;if (j.err<>nil) then jpeg_destroy(@j);except;end;
str__uaf(s);
str__free(@arow);
freeobj(@sdata);
end;
{$endif}


//jpeg support - Delphi 3 ------------------------------------------------------
{$ifdef d3}
{$Z4}  //minimum enum size = dword

const
   JPEG_LIB_VERSION       = 61;        { Version 6a }

   JPEG_RST0              = $D0;  { RST0 marker code }
   JPEG_EOI               = $D9;  { EOI marker code }
   JPEG_APP0              = $E0;  { APP0 marker code }
   JPEG_COM               = $FE;  { COM marker code }

   DCTSIZE                = 8;      { The basic DCT block is 8x8 samples }
   DCTSIZE2               = 64;     { DCTSIZE squared; # of elements in a block }
   NUM_QUANT_TBLS         = 4;      { Quantization tables are numbered 0..3 }
   NUM_HUFF_TBLS          = 4;      { Huffman tables are numbered 0..3 }
   NUM_ARITH_TBLS         = 16;     { Arith-coding tables are numbered 0..15 }
   MAX_COMPS_IN_SCAN      = 4;      { JPEG limit on # of components in one scan }
   MAX_SAMP_FACTOR        = 4;      { JPEG limit on sampling factors }
   C_MAX_BLOCKS_IN_MCU    = 10;     { compressor's limit on blocks per MCU }
   D_MAX_BLOCKS_IN_MCU    = 10;     { decompressor's limit on blocks per MCU }
   MAX_COMPONENTS         = 10;     { maximum number of image components (color channels) }

   MAXJSAMPLE             = 255;
   CENTERJSAMPLE          = 128;

   //return values
   JPOOL_PERMANENT        = 0;// lasts until master record is destroyed
   JPOOL_IMAGE	          = 1;// lasts until done with image/datastream

   JPEG_SUSPENDED         = 0; { Suspended due to lack of input data }
   JPEG_HEADER_OK         = 1; { Found valid image datastream }
   JPEG_HEADER_TABLES_ONLY= 2; { Found valid table-specs-only datastream }

   JPEG_REACHED_SOS       = 1; { Reached start of new scan }
   JPEG_REACHED_EOI       = 2; { Reached end of image }
   JPEG_ROW_COMPLETED     = 3; { Completed one iMCU row }
   JPEG_SCAN_COMPLETED    = 4; { Completed last iMCU row of a scan }

   //error handler
   JMSG_LENGTH_MAX        = 200;  { recommended size of format_message buffer }
   JMSG_STR_PARM_MAX      = 80;

type
   JSAMPLE                = byte;
   GETJSAMPLE             = longint;
   JCOEF                  = longint;
   JCOEF_PTR              = ^JCOEF;
   UINT8                  = byte;
   UINT16                 = word;
   UINT32                 = cardinal;//was uint
   INT16                  = smallint;
   INT32                  = longint;
   INT32PTR               = ^INT32;
   JDIMENSION             = cardinal;

   JOCTET                 = byte;
   jTOctet                = 0..(max32 div SizeOf(JOCTET))-1;
   JOCTET_FIELD           = array[jTOctet] of JOCTET;
   JOCTET_FIELD_PTR       = ^JOCTET_FIELD;
   JOCTETPTR              = ^JOCTET;

   JSAMPLE_PTR            = ^JSAMPLE;
   JSAMPROW_PTR           = ^JSAMPROW;

   jTSample               = 0..(max32 div SIZEOF(JSAMPLE))-1;
   JSAMPLE_ARRAY          = Array[jTSample] of JSAMPLE;  //far
   JSAMPROW               = ^JSAMPLE_ARRAY;  // ptr to one image row of pixel samples

   jTRow                  = 0..(max32 div SIZEOF(JSAMPROW))-1;
   JSAMPROW_ARRAY         = Array[jTRow] of JSAMPROW;
   JSAMPARRAY             = ^JSAMPROW_ARRAY;  //ptr to some rows (a 2-D sample array)

   jTArray                = 0..(max32 div SIZEOF(JSAMPARRAY))-1;
   JSAMP_ARRAY            = Array[jTArray] of JSAMPARRAY;
   JSAMPIMAGE             = ^JSAMP_ARRAY;  // a 3-D sample array: top index is color 

   //known color spaces
   J_COLOR_SPACE          = (JCS_UNKNOWN,JCS_GRAYSCALE,JCS_RGB,JCS_YCbCr,JCS_CMYK,JCS_YCCK);

   //DCT/IDCT algorithm options
   J_DCT_METHOD           = (JDCT_ISLOW,JDCT_IFAST,JDCT_FLOAT);

   //Dithering options for decompression
   J_DITHER_MODE          = (JDITHER_NONE,JDITHER_ORDERED,JDITHER_FS);

   jpeg_error_mgr_ptr     = ^jpeg_error_mgr;
   jpeg_progress_mgr_ptr  = ^jpeg_progress_mgr;

   j_common_ptr           = ^jpeg_common_struct;
   j_compress_ptr         = ^jpeg_compress_struct;
   j_decompress_ptr       = ^jpeg_decompress_struct;

   //routine signature for application-supplied marker processing methods. Need not pass marker code since it is stored in cinfo^.unread_marker.
   jpeg_marker_parser_method       =function(cinfo : j_decompress_ptr) : LongBool;

   //marker reading & parsing
   jpeg_marker_reader_ptr          =^jpeg_marker_reader;

   jpeg_marker_reader              =record
      reset_marker_reader          :procedure(cinfo : j_decompress_ptr);
      read_markers                 :function (cinfo : j_decompress_ptr) :longint;
      read_restart_marker          :jpeg_marker_parser_method;
      process_COM                  :jpeg_marker_parser_method;
      process_APPn                 :Array[0..16-1] of jpeg_marker_parser_method;
      saw_SOI                      :LongBool;            // found SOI? 
      saw_SOF                      :LongBool;            // found SOF? 
      next_restart_num             :longint;    // next restart number expected (0-7) 
      discarded_bytes              :UINT32;        // # of bytes skipped looking for a marker 
      end;

   int8array                       = Array[0..8-1] of longint;

   jpeg_error_mgr                  =record
      error_exit                   :procedure(cinfo:j_common_ptr);
      emit_message                 :procedure(cinfo:j_common_ptr;msg_level:longint);
      output_message               :procedure(cinfo:j_common_ptr);
      format_message               :procedure(cinfo:j_common_ptr;buffer:pchar);
      reset_error_mgr              :procedure(cinfo:j_common_ptr);
      msg_code                     :longint;
      msg_parm:record
      case byte of
      0:(i:int8array);
      1:(s:string[JMSG_STR_PARM_MAX]);
      end;
      trace_level                  :longint;//max msg_level that will be displayed
      num_warnings                 :longint;//number of corrupt-data warnings
      end;


   //data destination object for compression
   jpeg_destination_mgr_ptr        =^jpeg_destination_mgr;
   jpeg_destination_mgr            =record
      next_output_byte             :JOCTETptr;  // => next byte to write in buffer
      free_in_buffer               :longint;    // # of byte spaces remaining in buffer
      init_destination             :procedure (cinfo : j_compress_ptr);
      empty_output_buffer          :function (cinfo : j_compress_ptr) : LongBool;
      term_destination             :procedure (cinfo : j_compress_ptr);
      end;


   //data source object for decompression
  jpeg_source_mgr_ptr              =^jpeg_source_mgr;
  jpeg_source_mgr                  =record
     next_input_byte               :JOCTETptr;      // => next byte to read from buffer
     bytes_in_buffer               :longint;       // # of bytes remaining in buffer 
     init_source                   :procedure(cinfo : j_decompress_ptr);
     fill_input_buffer             :function (cinfo : j_decompress_ptr) : LongBool;
     skip_input_data               :procedure (cinfo : j_decompress_ptr; num_bytes : Longint);
     resync_to_restart             :function (cinfo : j_decompress_ptr; desired : longint) : LongBool;
     term_source                   :procedure (cinfo : j_decompress_ptr);
     end;

   //JPEG library memory manger routines
   jpeg_memory_mgr_ptr             =^jpeg_memory_mgr;
   jpeg_memory_mgr                 =record
      alloc_small                  :function(cinfo : j_common_ptr;pool_id, sizeofobject: longint): pointer;
      alloc_large                  :function (cinfo : j_common_ptr;pool_id, sizeofobject: longint): pointer;
      alloc_sarray                 :function (cinfo : j_common_ptr; pool_id : longint; samplesperrow : JDIMENSION; numrows : JDIMENSION) : JSAMPARRAY;
      alloc_barray                 :pointer;
      request_virt_sarray          :pointer;
      request_virt_barray          :pointer;
      realize_virt_arrays          :pointer;
      access_virt_sarray           :pointer;
      access_virt_barray           :pointer;
      free_pool                    :pointer;
      self_destruct                :pointer;
      max_memory_to_use            :longint;
      end;

   //fields shared with jpeg_decompress_struct
   jpeg_common_struct              =packed record
      err                          :jpeg_error_mgr_ptr;       // Error handler module
      mem                          :jpeg_memory_mgr_ptr;          // Memory manager module 
      progress                     :jpeg_progress_mgr_ptr;   // Progress monitor, or NIL if none
      is_decompressor              :LongBool;      // so common code can tell which is which 
      global_state                 :longint;          // for checking call sequence validity
      end;
   //progress monitor object
   jpeg_progress_mgr               =record
      progress_monitor             :procedure(const cinfo : jpeg_common_struct);
      pass_counter                 :longint;     // work units completed in this pass 
      pass_limit                   :longint;       // total number of work units in this pass 
      completed_passes             :longint;	// passes completed so far
      total_passes                 :longint;     // total number of passes expected
      // extra Delphi info
      instance                     :tobject;
      last_pass                    :longint;
      last_pct                     :longint;
      last_time                    :longint;
      last_scanline                :longint;
      end;

   //master record for a compression instance
   jpeg_compress_struct            =packed record
      common                       :jpeg_common_struct;
      dest                         :jpeg_destination_mgr_ptr; // Destination for compressed data 
      image_width                  :JDIMENSION;         // input image width 
      image_height                 :JDIMENSION;        // input image height 
      input_components             :longint;       // # of color components in input image 
      in_color_space               :J_COLOR_SPACE;   // colorspace of input image 
      input_gamma                  :double;             // image gamma of input image 

      //compression parameters
      data_precision               :longint;             // bits of precision in image data
      num_components               :longint;             // # of color components in JPEG image 
      jpeg_color_space             :J_COLOR_SPACE;     // colorspace of JPEG image 
      comp_info                    :pointer;
      quant_tbl_ptrs               :array[0..NUM_QUANT_TBLS-1] of pointer;
      dc_huff_tbl_ptrs             :array[0..NUM_HUFF_TBLS-1] of pointer;
      ac_huff_tbl_ptrs             :array[0..NUM_HUFF_TBLS-1] of pointer;
      arith_dc_L                   :array[0..NUM_ARITH_TBLS-1] of UINT8; // L values for DC arith-coding tables 
      arith_dc_U                   :array[0..NUM_ARITH_TBLS-1] of UINT8; // U values for DC arith-coding tables 
      arith_ac_K                   :array[0..NUM_ARITH_TBLS-1] of UINT8; // Kx values for AC arith-coding tables
      num_scans                    :longint;		 // # of entries in scan_info array 
      scan_info                    :pointer;     // script for multi-scan file, or NIL 
      raw_data_in                  :LongBool;        // TRUE=caller supplies downsampled data 
      arith_code                   :LongBool;         // TRUE=arithmetic coding, FALSE=Huffman 
      optimize_coding              :LongBool;    // TRUE=optimize entropy encoding parms
      CCIR601_sampling             :LongBool;   // TRUE=first samples are cosited 
      smoothing_factor             :longint;       // 1..100, or 0 for no input smoothing
      dct_method                   :J_DCT_METHOD;    // DCT algorithm selector 
      restart_interval             :UINT32;      // MCUs per restart, or 0 for no restart 
      restart_in_rows              :longint;        // if > 0, MCU rows per restart interval 
      write_JFIF_header            :LongBool;  // should a JFIF marker be written? 
      density_unit                 :UINT8;         // JFIF code for pixel size units 
      X_density                    :UINT16;           // Horizontal pixel density 
      Y_density                    :UINT16;           // Vertical pixel density 
      write_Adobe_marker           :LongBool; // should an Adobe marker be written? 
      next_scanline                :JDIMENSION;   // 0 .. image_height-1  
      //read-only
      progressive_mode             :LongBool;   // TRUE if scan script uses progressive mode
      max_h_samp_factor            :longint;      // largest h_samp_factor
      max_v_samp_factor            :longint;      // largest v_samp_factor
      total_iMCU_rows              :JDIMENSION; // # of iMCU rows to be input to coef ctlr 
      comps_in_scan                :longint;          // # of JPEG components in this scan
      cur_comp_info                :array[0..MAX_COMPS_IN_SCAN-1] of Pointer;
      MCUs_per_row                 :JDIMENSION;    // # of MCUs across the image 
      MCU_rows_in_scan             :JDIMENSION;// # of MCU rows in the image
      blocks_in_MCU                :longint;          // # of DCT blocks per MCU 
      MCU_membership               :array[0..C_MAX_BLOCKS_IN_MCU-1] of longint;
      Ss, Se, Ah, Al               :longint;         // progressive JPEG parameters for scan 
      master                       :pointer;
      main                         :pointer;
      prep                         :pointer;
      coef                         :pointer;
      marker                       :pointer;
      cconvert                     :pointer;
      downsample                   :pointer;
      fdct                         :pointer;
      entropy                      :pointer;
      end;

   jpeg_decompress_struct          = packed record
      common                       :jpeg_common_struct;
      src                          :jpeg_source_mgr_ptr;
      image_width                  :JDIMENSION;      // nominal image width (from SOF marker) 
      image_height                 :JDIMENSION;     // nominal image height
      num_components               :longint;          // # of color components in JPEG image 
      jpeg_color_space             :J_COLOR_SPACE; // colorspace of JPEG image
      out_color_space              :J_COLOR_SPACE; // colorspace for output 
      scale_num, scale_denom       :UINT32;  // fraction by which to scale image 
      output_gamma                 :double;           // image gamma wanted in output
      buffered_image               :LongBool;        // TRUE=multiple output passes 
      raw_data_out                 :LongBool;          // TRUE=downsampled data wanted
      dct_method                   :J_DCT_METHOD;       // IDCT algorithm selector 
      do_fancy_upsampling          :LongBool;   // TRUE=apply fancy upsampling 
      do_block_smoothing           :LongBool;    // TRUE=apply interblock smoothing 
      quantize_colors              :LongBool;       // TRUE=colormapped output wanted 
      dither_mode                  :J_DITHER_MODE;     // type of color dithering to use 
      two_pass_quantize            :LongBool;     // TRUE=use two-pass color quantization 
      desired_number_of_colors     :longint;  // max # colors to use in created colormap 
      enable_1pass_quant           :LongBool;    // enable future use of 1-pass quantizer 
      enable_external_quant        :LongBool; // enable future use of external colormap 
      enable_2pass_quant           :LongBool;    // enable future use of 2-pass quantizer 
      output_width                 :JDIMENSION;       // scaled image width 
      output_height                :JDIMENSION;       // scaled image height 
      out_color_components         :longint;  // # of color components in out_color_space
      output_components            :longint;     // # of color components returned
      rec_outbuf_height            :longint;     // min recommended height of scanline buffer
      actual_number_of_colors      :longint;      // number of entries in use
      colormap                     :JSAMPARRAY;              // The color map as a 2-D pixel array 
      output_scanline              :JDIMENSION; // 0 .. output_height-1
      input_scan_number            :longint;      // Number of SOS markers seen so far 
      input_iMCU_row               :JDIMENSION;  // Number of iMCU rows completed 
      output_scan_number           :longint;     // Nominal scan number being displayed
      output_iMCU_row              :longint;        // Number of iMCU rows read 
      coef_bits                    :pointer;
      quant_tbl_ptrs               :array[0..NUM_QUANT_TBLS-1] of Pointer;
      dc_huff_tbl_ptrs             :array[0..NUM_HUFF_TBLS-1] of Pointer;
      ac_huff_tbl_ptrs             :array[0..NUM_HUFF_TBLS-1] of Pointer;
      data_precision               :longint;          // bits of precision in image data 
      comp_info                    :pointer;
      progressive_mode             :LongBool;    // TRUE if SOFn specifies progressive mode
      arith_code                   :LongBool;          // TRUE=arithmetic coding, FALSE=Huffman 
      arith_dc_L                   :array[0..NUM_ARITH_TBLS-1] of UINT8; // L values for DC arith-coding tables 
      arith_dc_U                   :array[0..NUM_ARITH_TBLS-1] of UINT8; // U values for DC arith-coding tables 
      arith_ac_K                   :array[0..NUM_ARITH_TBLS-1] of UINT8; // Kx values for AC arith-coding tables 
      restart_interval             :UINT32; // MCUs per restart interval, or 0 for no restart 
      saw_JFIF_marker              :LongBool;  // TRUE iff a JFIF APP0 marker was found 
      density_unit                 :UINT8;       // JFIF code for pixel size units
      X_density                    :UINT16;         // Horizontal pixel density
      Y_density                    :UINT16;         // Vertical pixel density 
      saw_Adobe_marker             :LongBool; // TRUE iff an Adobe APP14 marker was found 
      Adobe_transform              :UINT8;    // Color transform code from Adobe marker
      CCIR601_sampling               :LongBool; // TRUE=first samples are cosited 
      max_h_samp_factor              :longint;    // largest h_samp_factor
      max_v_samp_factor              :longint;    // largest v_samp_factor 
      min_DCT_scaled_size            :longint;  // smallest DCT_scaled_size of any component
      total_iMCU_rows                :JDIMENSION; // # of iMCU rows in image 
      sample_range_limit             :pointer;   // table for fast range-limiting 
      comps_in_scan                  :longint;           // # of JPEG components in this scan 
      cur_comp_info                  :array[0..MAX_COMPS_IN_SCAN-1] of Pointer;
      MCUs_per_row                   :JDIMENSION;     // # of MCUs across the image 
      MCU_rows_in_scan               :JDIMENSION; // # of MCU rows in the image 
      blocks_in_MCU                  :JDIMENSION;    // # of DCT blocks per MCU 
      MCU_membership                 :array[0..D_MAX_BLOCKS_IN_MCU-1] of longint;
      Ss, Se, Ah, Al                 :longint;          // progressive JPEG parameters for scan 
      unread_marker                  :longint;
      master                         :pointer;
      main                           :pointer;
      coef                           :pointer;
      post                           :pointer;
      inputctl                       :pointer;
      marker                         :pointer;
      entropy                        :pointer;
      idct                           :pointer;
      upsample                       :pointer;
      cconvert                       :pointer;
      cquantize                      :pointer;
      end;

   tjpegcontext=record
    err               :jpeg_error_mgr;
    progress          :jpeg_progress_mgr;
    FinalDCT          :J_DCT_METHOD;
    FinalTwoPassQuant :Boolean;
    FinalDitherMode   :J_DITHER_MODE;
    case byte of
     0:(common:jpeg_common_struct);
     1:(d:jpeg_decompress_struct);
     2:(c:jpeg_compress_struct);
    end;


function _malloc(size: longint): Pointer; cdecl;
begin
GetMem(Result, size);
end;

procedure _free(P: Pointer); cdecl;
begin
FreeMem(P);
end;

procedure _memset(P: Pointer; B: Byte; count: Integer);cdecl;
begin
FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer);cdecl;
begin
Move(source^, dest^, count);
end;

function _fread(var buf; recsize, reccount: longint; s:pobject): longint; cdecl;
var
   spos,slen,xsize:longint;
begin
//init
xsize:=recsize * reccount;

//get
if (xsize>=1) and str__ok(s) then
   begin
   spos  :=str__seekpos(s);
   slen  :=str__len(s);
   result:=frcmax32(xsize,slen-spos);

   if (result>=1) then
      begin
      result:=str__moveto(s,buf,spos,result);
      str__setseekpos(s,spos+result);
      end;
   end
else result:=0;
end;

function _fwrite(const buf; recsize, reccount: longint; s:pobject): longint; cdecl;
var
   xsize:longint;
begin
//init
xsize:=recsize * reccount;

//get
if (xsize>=1) and str__ok(s) then result:=str__movefrom(s,buf,xsize)
else                              result:=0;
end;

function _fflush(s:pointer): longint; cdecl;
begin
result:=0;
end;

function __ftol: longint;
var
  f: double;
begin
asm
  lea    eax, f             //BC++ passes floats on the FPU stack
  fstp  qword ptr [eax]     //Borland Delphi 3 passes floats on the CPU stack
end;

result:=trunc(f);
end;

var
  __turboFloat: LongBool = False;

procedure err__JpegError(cinfo: j_common_ptr);//25may2025
begin
//suppress error #36
if (cinfo^.err^.msg_code=36) then exit;

raise Exception.CreateFmt('JPEG error '+k64(cinfo^.err^.msg_code),[cinfo^.err^.msg_code]);//reguired -> feeds error back to calling proc
end;

procedure err__EmitMessage(cinfo: j_common_ptr; msg_level: Integer);
begin
//
end;

procedure err__OutputMessage(cinfo: j_common_ptr);
begin
//
end;

procedure err__FormatMessage(cinfo: j_common_ptr; buffer: PChar);
begin
//
end;

procedure err__ResetErrorMgr(cinfo: j_common_ptr);
begin
cinfo^.err^.num_warnings :=0;
cinfo^.err^.msg_code     :=0;
end;

const
   jpeg_std_error:jpeg_error_mgr=( error_exit: err__JpegError; emit_message: err__EmitMessage; output_message: err__OutputMessage; format_message: err__FormatMessage; reset_error_mgr: err__ResetErrorMgr);

{$L jdapimin.obj}
{$L jmemmgr.obj}
{$L jmemnobs.obj}
{$L jdinput.obj}
{$L jdatasrc.obj}
{$L jdapistd.obj}
{$L jdmaster.obj}
{$L jdphuff.obj}
{$L jdhuff.obj}
{$L jdmerge.obj}
{$L jdcolor.obj}
{$L jquant1.obj}
{$L jquant2.obj}
{$L jdmainct.obj}
{$L jdcoefct.obj}
{$L jdpostct.obj}
{$L jddctmgr.obj}
{$L jdsample.obj}
{$L jidctflt.obj}
{$L jidctfst.obj}
{$L jidctint.obj}
{$L jidctred.obj}
{$L jdmarker.obj}
{$L jutils.obj}
{$L jcomapi.obj}

procedure jpeg_CreateDecompress(var cinfo : jpeg_decompress_struct; version : longint; structsize : longint); external;
procedure jpeg_stdio_src(var cinfo: jpeg_decompress_struct; input_file: pointer); external;
procedure jpeg_read_header(var cinfo: jpeg_decompress_struct; RequireImage: LongBool); external;
procedure jpeg_calc_output_dimensions(var cinfo: jpeg_decompress_struct); external;
function  jpeg_start_decompress(var cinfo: jpeg_decompress_struct): Longbool; external;
function  jpeg_read_scanlines(var cinfo: jpeg_decompress_struct; scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; external;
function  jpeg_finish_decompress(var cinfo: jpeg_decompress_struct): Longbool; external;
procedure jpeg_destroy_decompress (var cinfo : jpeg_decompress_struct); external;
function  jpeg_has_multiple_scans(var cinfo: jpeg_decompress_struct): Longbool; external;
function  jpeg_consume_input(var cinfo: jpeg_decompress_struct): longint; external;
function  jpeg_start_output(var cinfo: jpeg_decompress_struct; scan_number: longint): Longbool; external;
function  jpeg_finish_output(var cinfo: jpeg_decompress_struct): LongBool; external;
procedure jpeg_destroy(var cinfo: jpeg_common_struct); external;

{$L jdatadst.obj}
{$L jcparam.obj}
{$L jcapistd.obj}
{$L jcapimin.obj}
{$L jcinit.obj}
{$L jcmarker.obj}
{$L jcmaster.obj}
{$L jcmainct.obj}
{$L jcprepct.obj}
{$L jccoefct.obj}
{$L jccolor.obj}
{$L jcsample.obj}
{$L jcdctmgr.obj}
{$L jcphuff.obj}
{$L jfdctint.obj}
{$L jfdctfst.obj}
{$L jfdctflt.obj}
{$L jchuff.obj}

procedure jpeg_CreateCompress(var cinfo : jpeg_compress_struct; version : longint; structsize : longint); external;
procedure jpeg_stdio_dest(var cinfo: jpeg_compress_struct; output_file: pointer); external;
procedure jpeg_set_defaults(var cinfo: jpeg_compress_struct); external;
procedure jpeg_set_quality(var cinfo: jpeg_compress_struct; Quality: longint; Baseline: Longbool); external;
procedure jpeg_set_colorspace(var cinfo: jpeg_compress_struct; colorspace: J_COLOR_SPACE); external;
procedure jpeg_simple_progression(var cinfo: jpeg_compress_struct); external;
procedure jpeg_start_compress(var cinfo: jpeg_compress_struct; WriteAllTables: LongBool); external;
function  jpeg_write_scanlines(var cinfo: jpeg_compress_struct; scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; external;
procedure jpeg_finish_compress(var cinfo: jpeg_compress_struct); external;


function jpg____todata(s:pobject;d:tobject;dquality100:longint):boolean;//16jun2025
label
   skipend0,skipend;
var
   j:jpeg_compress_struct;
   a:tstr8;
   dbits,dx,dw,dh:longint;
   dr32:pcolorrow32;
   ar24,dr24:pcolorrow24;
   dr8 :pcolorrow8;
   c32:tcolor32;
   c24:tcolor24;
begin
//defaults
result:=false;
a     :=nil;
//.jpeg compression record
low__cls(@j,sizeof(j));
j.common.err :=@jpeg_std_error;//local var => thread isolation

try
//check
if not str__lock(s)              then goto skipend;
if not misok82432(d,dbits,dw,dh) then goto skipend;

//range
dquality100:=frcrange32(dquality100,1,100);

//init
str__clear(s);
a:=str__new8;
a.minlen( mis__rowsize4(dw,24) );

//get - compress
jpeg_CreateCompress(j,JPEG_LIB_VERSION,sizeof(j));
jpeg_stdio_dest(j,s);
j.image_width      :=dw;
j.image_height     :=dh;
j.input_components :=3;// JPEG requires 24bit RGB input
j.in_color_space   :=JCS_RGB;

jpeg_set_defaults(j);
jpeg_set_quality(j,dquality100,true);

try
jpeg_start_compress(j,true);
ar24:=a.scanline(0);

while (j.next_scanline<j.image_height) do
begin
if not misscan82432(d,j.next_scanline,dr8,dr24,dr32) then goto skipend0;

//32 -> 24
if (dbits=32) then
   begin
   for dx:=0 to (dw-1) do
   begin
   c32:=dr32[dx];
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   ar24[dx]:=c24;
   end;//dx
   end
//24 -> 24
else if (dbits=24) then
   begin
   for dx:=0 to (dw-1) do
   begin
   c24:=dr24[dx];
   ar24[dx]:=c24;
   end;//dx
   end
//8 -> 24
else if (dbits=8) then
   begin
   for dx:=0 to (dw-1) do
   begin
   c24.r:=dr8[dx];
   c24.g:=c24.r;
   c24.b:=c24.r;//16jun2025
   ar24[dx]:=c24;
   end;//dx
   end;

if (1<>jpeg_write_scanlines(j,@a.core,1)) then goto skipend0;
end;//loop

//successful
result:=true;
skipend0:
jpeg_finish_compress(j);
except;end;

skipend:
except;end;
//free
try;if (j.common.err<>nil) then jpeg_destroy(j.common);except;end;
str__uaf(s);
str__free(@a);
end;

function jpg____fromdata(s:pobject;d:tobject):boolean;
label//copy pixels from jpeg stream "s" to image "d"
     //s = tstr8 or tstr9 object
     //d = tbasicimage, trawimage, or twinbmp
   skipend0,skipend;
var
   j    :jpeg_decompress_struct;
   arow:tstr8;
   dx,dbits,dw,dh:longint;
   dr32:pcolorrow32;
   sr24,dr24:pcolorrow24;
   dr8 :pcolorrow8;
   c32:tcolor32;
   c24:tcolor24;
begin
//defaults
result:=false;
arow  :=nil;
//.jpeg decompression record
low__cls(@j,sizeof(j));
j.common.err :=@jpeg_std_error;//local var => thread isolation

try
//check
if not str__lock(s)              then goto skipend;
if (str__len(s)<=0)              then goto skipend;
if not misok82432(d,dbits,dw,dh) then goto skipend;

//init
str__setseekpos(s,0);

//get - decompress
jpeg_createdecompress(j,JPEG_LIB_VERSION,sizeof(j));//#1.s

try
jpeg_stdio_src(j,s);//read directly from "s"
jpeg_read_header(j,true);

j.scale_num               :=1;
j.scale_denom             :=1;//full size
j.do_block_smoothing      :=true;
j.quantize_colors         :=false;//no greyscale -> use 24bit always
j.out_color_space         :=JCS_RGB;

//.best speed
j.dct_method              :=JDCT_ISLOW;//16jun2025 - was: JDCT_IFAST;
j.two_pass_quantize       :=false;
j.dither_mode             :=JDITHER_NONE;//was: JDITHER_ORDERED;

dw   :=frcmin32(j.image_width,1);
dh   :=frcmin32(j.image_height,1);
arow :=str__new8;
arow.setlen( mis__rowsize4(dw,24) );//04may2025

//size
if not missize(d,dw,dh) then goto skipend0;

//get -> scan lines in RGB format
if not jpeg_start_decompress(j) then goto skipend0;//#2.s
if (j.output_components<>3)     then goto skipend0;

try

while (j.output_scanline < dh) do
begin
if (1=jpeg_read_scanlines(j, @arow.core, 1)) then
   begin
   if misscan82432(d,j.output_scanline-1,dr8,dr24,dr32) then
      begin
      sr24:=arow.scanline(0);

      //24 -> 32
      if (dbits=32) then
         begin
         for dx:=0 to (dw-1) do
         begin
         c24:=sr24[dx];
         c32.r:=c24.r;
         c32.g:=c24.g;
         c32.b:=c24.b;
         c32.a:=255;
         dr32[dx]:=c32;
         end;//dx
         end
      //24 -> 24
      else if (dbits=24) then
         begin
         for dx:=0 to (dw-1) do
         begin
         c24:=sr24[dx];
         dr24[dx]:=c24;
         end;//dx
         end
      //24 -> 8
      else if (dbits=8) then
         begin
         for dx:=0 to (dw-1) do
         begin
         c24:=sr24[dx];
         if (c24.g>c24.r) then c24.r:=c24.g;
         if (c24.b>c24.r) then c24.r:=c24.b;
         dr8[dx]:=c24.r;
         end;//dx
         end;
      end;
   end
else break;
end;//loop

//successful
result:=true;
except;end;

//finish
jpeg_finish_decompress(j);//#2.f

skipend0:
finally
//free
jpeg_destroy_decompress(j);//#1.f
end;

skipend:
except;end;
//free
try;if (j.common.err<>nil) then jpeg_destroy(j.common);except;end;
str__uaf(s);
str__free(@arow);
end;
{$endif}
{$endif}


{
--------------------------------------------------------------------------------
-- Original README file for JPEG Format ----------------------------------------
--------------------------------------------------------------------------------

The Independent JPEG Group's JPEG software
==========================================

README for release 6a of 7-Feb-96
=================================

This distribution contains the sixth public release of the Independent JPEG
Group's free JPEG software.  You are welcome to redistribute this software and
to use it for any purpose, subject to the conditions under LEGAL ISSUES, below.

Serious users of this software (particularly those incorporating it into
larger programs) should contact IJG at jpeg-info@uunet.uu.net to be added to
our electronic mailing list.  Mailing list members are notified of updates
and have a chance to participate in technical discussions, etc.

This software is the work of Tom Lane, Philip Gladstone, Luis Ortiz, Jim
Boucher, Lee Crocker, Julian Minguillon, George Phillips, Davide Rossi,
Ge' Weijers, and other members of the Independent JPEG Group.

IJG is not affiliated with the official ISO JPEG standards committee.


DOCUMENTATION ROADMAP
=====================

This file contains the following sections:

OVERVIEW            General description of JPEG and the IJG software.
LEGAL ISSUES        Copyright, lack of warranty, terms of distribution.
REFERENCES          Where to learn more about JPEG.
ARCHIVE LOCATIONS   Where to find newer versions of this software.
RELATED SOFTWARE    Other stuff you should get.
FILE FORMAT WARS    Software *not* to get.
TO DO               Plans for future IJG releases.

Other documentation files in the distribution are:

User documentation:
  install.doc       How to configure and install the IJG software.
  usage.doc         Usage instructions for cjpeg, djpeg, jpegtran,
                    rdjpgcom, and wrjpgcom.
  *.1               Unix-style man pages for programs (same info as usage.doc).
  wizard.doc        Advanced usage instructions for JPEG wizards only.
  change.log        Version-to-version change highlights.
Programmer and internal documentation:
  libjpeg.doc       How to use the JPEG library in your own programs.
  example.c         Sample code for calling the JPEG library.
  structure.doc     Overview of the JPEG library's internal structure.
  filelist.doc      Road map of IJG files.
  coderules.doc     Coding style rules --- please read if you contribute code.

Please read at least the files install.doc and usage.doc.  Useful information
can also be found in the JPEG FAQ (Frequently Asked Questions) article.  See
ARCHIVE LOCATIONS below to find out where to obtain the FAQ article.

If you want to understand how the JPEG code works, we suggest reading one or
more of the REFERENCES, then looking at the documentation files (in roughly
the order listed) before diving into the code.


OVERVIEW
========

This package contains C software to implement JPEG image compression and
decompression.  JPEG (pronounced "jay-peg") is a standardized compression
method for full-color and gray-scale images.  JPEG is intended for compressing
"real-world" scenes; line drawings, cartoons and other non-realistic images
are not its strong suit.  JPEG is lossy, meaning that the output image is not
exactly identical to the input image.  Hence you must not use JPEG if you
have to have identical output bits.  However, on typical photographic images,
very good compression levels can be obtained with no visible change, and
remarkably high compression levels are possible if you can tolerate a
low-quality image.  For more details, see the references, or just experiment
with various compression settings.

This software implements JPEG baseline, extended-sequential, and progressive
compression processes.  Provision is made for supporting all variants of these
processes, although some uncommon parameter settings aren't implemented yet.
For legal reasons, we are not distributing code for the arithmetic-coding
variants of JPEG; see LEGAL ISSUES.  We have made no provision for supporting
the hierarchical or lossless processes defined in the standard.

We provide a set of library routines for reading and writing JPEG image files,
plus two sample applications "cjpeg" and "djpeg", which use the library to
perform conversion between JPEG and some other popular image file formats.
The library is intended to be reused in other applications.

In order to support file conversion and viewing software, we have included
considerable functionality beyond the bare JPEG coding/decoding capability;
for example, the color quantization modules are not strictly part of JPEG
decoding, but they are essential for output to colormapped file formats or
colormapped displays.  These extra functions can be compiled out of the
library if not required for a particular application.  We have also included
"jpegtran", a utility for lossless transcoding between different JPEG
processes, and "rdjpgcom" and "wrjpgcom", two simple applications for
inserting and extracting textual comments in JFIF files.

The emphasis in designing this software has been on achieving portability and
flexibility, while also making it fast enough to be useful.  In particular,
the software is not intended to be read as a tutorial on JPEG.  (See the
REFERENCES section for introductory material.)  Rather, it is intended to
be reliable, portable, industrial-strength code.  We do not claim to have
achieved that goal in every aspect of the software, but we strive for it.

We welcome the use of this software as a component of commercial products.
No royalty is required, but we do ask for an acknowledgement in product
documentation, as described under LEGAL ISSUES.


LEGAL ISSUES
============

In plain English:

1. We don't promise that this software works.  (But if you find any bugs,
   please let us know!)
2. You can use this software for whatever you want.  You don't have to pay us.
3. You may not pretend that you wrote this software.  If you use it in a
   program, you must acknowledge somewhere in your documentation that
   you've used the IJG code.

In legalese:

The authors make NO WARRANTY or representation, either express or implied,
with respect to this software, its quality, accuracy, merchantability, or
fitness for a particular purpose.  This software is provided "AS IS", and you,
its user, assume the entire risk as to its quality and accuracy.

This software is copyright (C) 1991-1996, Thomas G. Lane.
All Rights Reserved except as specified below.

Permission is hereby granted to use, copy, modify, and distribute this
software (or portions thereof) for any purpose, without fee, subject to these
conditions:
(1) If any part of the source code for this software is distributed, then this
README file must be included, with this copyright and no-warranty notice
unaltered; and any additions, deletions, or changes to the original files
must be clearly indicated in accompanying documentation.
(2) If only executable code is distributed, then the accompanying
documentation must state that "this software is based in part on the work of
the Independent JPEG Group".
(3) Permission for use of this software is granted only if the user accepts
full responsibility for any undesirable consequences; the authors accept
NO LIABILITY for damages of any kind.

These conditions apply to any software derived from or based on the IJG code,
not just to the unmodified library.  If you use our work, you ought to
acknowledge us.

Permission is NOT granted for the use of any IJG author's name or company name
in advertising or publicity relating to this software or products derived from
it.  This software may be referred to only as "the Independent JPEG Group's
software".

We specifically permit and encourage the use of this software as the basis of
commercial products, provided that all warranty or liability claims are
assumed by the product vendor.


ansi2knr.c is included in this distribution by permission of L. Peter Deutsch,
sole proprietor of its copyright holder, Aladdin Enterprises of Menlo Park, CA.
ansi2knr.c is NOT covered by the above copyright and conditions, but instead
by the usual distribution terms of the Free Software Foundation; principally,
that you must include source code if you redistribute it.  (See the file
ansi2knr.c for full details.)  However, since ansi2knr.c is not needed as part
of any program generated from the IJG code, this does not limit you more than
the foregoing paragraphs do.

The configuration script "configure" was produced with GNU Autoconf.  It
is copyright by the Free Software Foundation but is freely distributable.

It appears that the arithmetic coding option of the JPEG spec is covered by
patents owned by IBM, AT&T, and Mitsubishi.  Hence arithmetic coding cannot
legally be used without obtaining one or more licenses.  For this reason,
support for arithmetic coding has been removed from the free JPEG software.
(Since arithmetic coding provides only a marginal gain over the unpatented
Huffman mode, it is unlikely that very many implementations will support it.)
So far as we are aware, there are no patent restrictions on the remaining
code.

WARNING: Unisys has begun to enforce their patent on LZW compression against
GIF encoders and decoders.  You will need a license from Unisys to use the
included rdgif.c or wrgif.c files in a commercial or shareware application.
At this time, Unisys is not enforcing their patent against freeware, so
distribution of this package remains legal.  However, we intend to remove
GIF support from the IJG package as soon as a suitable replacement format
becomes reasonably popular.

We are required to state that
    "The Graphics Interchange Format(c) is the Copyright property of
    CompuServe Incorporated.  GIF(sm) is a Service Mark property of
    CompuServe Incorporated."


REFERENCES
==========

We highly recommend reading one or more of these references before trying to
understand the innards of the JPEG software.

The best short technical introduction to the JPEG compression algorithm is
	Wallace, Gregory K.  "The JPEG Still Picture Compression Standard",
	Communications of the ACM, April 1991 (vol. 34 no. 4), pp. 30-44.
(Adjacent articles in that issue discuss MPEG motion picture compression,
applications of JPEG, and related topics.)  If you don't have the CACM issue
handy, a PostScript file containing a revised version of Wallace's article
is available at ftp.uu.net, graphics/jpeg/wallace.ps.gz.  The file (actually
a preprint for an article that appeared in IEEE Trans. Consumer Electronics)
omits the sample images that appeared in CACM, but it includes corrections
and some added material.  Note: the Wallace article is copyright ACM and
IEEE, and it may not be used for commercial purposes.

A somewhat less technical, more leisurely introduction to JPEG can be found in
"The Data Compression Book" by Mark Nelson, published by M&T Books (Redwood
City, CA), 1991, ISBN 1-55851-216-0.  This book provides good explanations and
example C code for a multitude of compression methods including JPEG.  It is
an excellent source if you are comfortable reading C code but don't know much
about data compression in general.  The book's JPEG sample code is far from
industrial-strength, but when you are ready to look at a full implementation,
you've got one here...

The best full description of JPEG is the textbook "JPEG Still Image Data
Compression Standard" by William B. Pennebaker and Joan L. Mitchell, published
by Van Nostrand Reinhold, 1993, ISBN 0-442-01272-1.  Price US$59.95, 638 pp.
The book includes the complete text of the ISO JPEG standards (DIS 10918-1
and draft DIS 10918-2).  This is by far the most complete exposition of JPEG
in existence, and we highly recommend it.

The JPEG standard itself is not available electronically; you must order a
paper copy through ISO or ITU.  (Unless you feel a need to own a certified
official copy, we recommend buying the Pennebaker and Mitchell book instead;
it's much cheaper and includes a great deal of useful explanatory material.)
In the USA, copies of the standard may be ordered from ANSI Sales at (212)
642-4900, or from Global Engineering Documents at (800) 854-7179.  (ANSI
doesn't take credit card orders, but Global does.)  It's not cheap: as of
1992, ANSI was charging $95 for Part 1 and $47 for Part 2, plus 7%
shipping/handling.  The standard is divided into two parts, Part 1 being the
actual specification, while Part 2 covers compliance testing methods.  Part 1
is titled "Digital Compression and Coding of Continuous-tone Still Images,
Part 1: Requirements and guidelines" and has document numbers ISO/IEC IS
10918-1, ITU-T T.81.  Part 2 is titled "Digital Compression and Coding of
Continuous-tone Still Images, Part 2: Compliance testing" and has document
numbers ISO/IEC IS 10918-2, ITU-T T.83.

Extensions to the original JPEG standard are defined in JPEG Part 3, a new ISO
document.  Part 3 is undergoing ISO balloting and is expected to be approved
by the end of 1995; it will have document numbers ISO/IEC IS 10918-3, ITU-T
T.84.  IJG currently does not support any Part 3 extensions.

The JPEG standard does not specify all details of an interchangeable file
format.  For the omitted details we follow the "JFIF" conventions, revision
1.02.  A copy of the JFIF spec is available from:
	Literature Department
	C-Cube Microsystems, Inc.
	1778 McCarthy Blvd.
	Milpitas, CA 95035
	phone (408) 944-6300,  fax (408) 944-6314
A PostScript version of this document is available at ftp.uu.net, file
graphics/jpeg/jfif.ps.gz.  It can also be obtained by e-mail from the C-Cube
mail server, netlib@c3.pla.ca.us.  Send the message "send jfif_ps from jpeg"
to the server to obtain the JFIF document; send the message "help" if you have
trouble.

The TIFF 6.0 file format specification can be obtained by FTP from sgi.com
(192.48.153.1), file graphics/tiff/TIFF6.ps.Z; or you can order a printed
copy from Aldus Corp. at (206) 628-6593.  The JPEG incorporation scheme
found in the TIFF 6.0 spec of 3-June-92 has a number of serious problems.
IJG does not recommend use of the TIFF 6.0 design (TIFF Compression tag 6).
Instead, we recommend the JPEG design proposed by TIFF Technical Note #2
(Compression tag 7).  Copies of this Note can be obtained from sgi.com or
from ftp.uu.net:/graphics/jpeg/.  It is expected that the next revision of
the TIFF spec will replace the 6.0 JPEG design with the Note's design.
Although IJG's own code does not support TIFF/JPEG, the free libtiff library
uses our library to implement TIFF/JPEG per the Note.  libtiff is available
from sgi.com:/graphics/tiff/.


ARCHIVE LOCATIONS
=================

The "official" archive site for this software is ftp.uu.net (Internet
address 192.48.96.9).  The most recent released version can always be found
there in directory graphics/jpeg.  This particular version will be archived
as graphics/jpeg/jpegsrc.v6a.tar.gz.  If you are on the Internet, you
can retrieve files from ftp.uu.net by standard anonymous FTP.  If you don't
have FTP access, UUNET's archives are also available via UUCP; contact
help@uunet.uu.net for information on retrieving files that way.

Numerous Internet sites maintain copies of the UUNET files.  However, only
ftp.uu.net is guaranteed to have the latest official version.

You can also obtain this software in DOS-compatible "zip" archive format from
the SimTel archives (ftp.coast.net:/SimTel/msdos/graphics/), or on CompuServe
in the Graphics Support forum (GO CIS:GRAPHSUP), library 12 "JPEG Tools".
Again, these versions may sometimes lag behind the ftp.uu.net release.

The JPEG FAQ (Frequently Asked Questions) article is a useful source of
general information about JPEG.  It is updated constantly and therefore is
not included in this distribution.  The FAQ is posted every two weeks to
Usenet newsgroups comp.graphics.misc, news.answers, and other groups.
You can always obtain the latest version from the news.answers archive at
rtfm.mit.edu.  By FTP, fetch /pub/usenet/news.answers/jpeg-faq/part1 and
.../part2.  If you don't have FTP, send e-mail to mail-server@rtfm.mit.edu
with body
	send usenet/news.answers/jpeg-faq/part1
	send usenet/news.answers/jpeg-faq/part2


RELATED SOFTWARE
================

Numerous viewing and image manipulation programs now support JPEG.  (Quite a
few of them use this library to do so.)  The JPEG FAQ described above lists
some of the more popular free and shareware viewers, and tells where to
obtain them on Internet.

If you are on a Unix machine, we highly recommend Jef Poskanzer's free
PBMPLUS image software, which provides many useful operations on PPM-format
image files.  In particular, it can convert PPM images to and from a wide
range of other formats.  You can obtain this package by FTP from ftp.x.org
(contrib/pbmplus*.tar.Z) or ftp.ee.lbl.gov (pbmplus*.tar.Z).  There is also
a newer update of this package called NETPBM, available from
wuarchive.wustl.edu under directory /graphics/graphics/packages/NetPBM/.
Unfortunately PBMPLUS/NETPBM is not nearly as portable as the IJG software
is; you are likely to have difficulty making it work on any non-Unix machine.

A different free JPEG implementation, written by the PVRG group at Stanford,
is available from havefun.stanford.edu in directory pub/jpeg.  This program
is designed for research and experimentation rather than production use;
it is slower, harder to use, and less portable than the IJG code, but it
is easier to read and modify.  Also, the PVRG code supports lossless JPEG,
which we do not.


FILE FORMAT WARS
================

Some JPEG programs produce files that are not compatible with our library.
The root of the problem is that the ISO JPEG committee failed to specify a
concrete file format.  Some vendors "filled in the blanks" on their own,
creating proprietary formats that no one else could read.  (For example, none
of the early commercial JPEG implementations for the Macintosh were able to
exchange compressed files.)

The file format we have adopted is called JFIF (see REFERENCES).  This format
has been agreed to by a number of major commercial JPEG vendors, and it has
become the de facto standard.  JFIF is a minimal or "low end" representation.
We recommend the use of TIFF/JPEG (TIFF revision 6.0 as modified by TIFF
Technical Note #2) for "high end" applications that need to record a lot of
additional data about an image.  TIFF/JPEG is fairly new and not yet widely
supported, unfortunately.

The upcoming JPEG Part 3 standard defines a file format called SPIFF.
SPIFF is interoperable with JFIF, in the sense that most JFIF decoders should
be able to read the most common variant of SPIFF.  SPIFF has some technical
advantages over JFIF, but its major claim to fame is simply that it is an
official standard rather than an informal one.  At this point it is unclear
whether SPIFF will supersede JFIF or whether JFIF will remain the de-facto
standard.  IJG intends to support SPIFF once the standard is frozen, but we
have not decided whether it should become our default output format or not.
(In any case, our decoder will remain capable of reading JFIF indefinitely.)

Various proprietary file formats incorporating JPEG compression also exist.
We have little or no sympathy for the existence of these formats.  Indeed,
one of the original reasons for developing this free software was to help
force convergence on common, open format standards for JPEG files.  Don't
use a proprietary file format!


TO DO
=====

In future versions, we are considering supporting some of the upcoming JPEG
Part 3 extensions --- principally, variable quantization and the SPIFF file
format.

Tuning the software for better behavior at low quality/high compression
settings is also of interest.  The current method for scaling the
quantization tables is known not to be very good at low Q values.

As always, speeding things up is high on our priority list.

Please send bug reports, offers of help, etc. to jpeg-info@uunet.uu.net.
}
end.
