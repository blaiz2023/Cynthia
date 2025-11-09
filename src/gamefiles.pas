unit gamefiles;

interface

function storage__findfile(xindex:longint;var xdata:pointer;var xdatalen:longint;var xcompressed:boolean;var xpathname:string):boolean;

implementation

//const


function storage__findfile(xindex:longint;var xdata:pointer;var xdatalen:longint;var xcompressed:boolean;var xpathname:string):boolean;
   procedure xset(const fdata:array of byte;fcompressed:boolean;const fpathname:string);
   begin
   result     :=true;
   xdata      :=@fdata;
   xdatalen   :=high(fdata)+1;
   xcompressed:=fcompressed;
   xpathname  :=fpathname;
   end;
begin
//defaults
result:=false;

//find
//case xindex of
//end;//case



end;


end.
