unit uCompare;

interface

procedure compareSql(sql1, sql2: string);

implementation

uses
  System.SysUtils;

procedure compareSql(sql1, sql2: string);
begin
  if not sameStr(sql1, sql2) then
    raise Exception.Create('SQL compare error' + sLineBreak + sql2);
end;

end.
