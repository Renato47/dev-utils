unit uCompare;

interface

uses
  System.SysUtils;

procedure CompareSql(aSql1, aSql2: string);

implementation

procedure CompareSql(aSql1, aSql2: string);
begin
  if not SameStr(aSql1, aSql2) then
    raise Exception.Create('Sql compare error' + sLineBreak + aSql2);
end;

end.
