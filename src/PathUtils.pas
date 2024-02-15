unit PathUtils;

interface

uses
  System.Classes;

function PathAdd(aPaths: array of string): string;
function ListSubDirectories(aPath: string): TStringList;

implementation

uses
  System.SysUtils, System.IOUtils, System.Types;

function PathAdd(aPaths: array of string): string;
var
  nPath: Integer;
begin
  Result := '';

  if Length(aPaths) = 0 then
    Exit;

  for nPath := 0 to Pred(Length(aPaths)) do begin
    if nPath = 0 then begin
      Result := aPaths[nPath];
      Continue;
    end;

    if Result.EndsWith(PathDelim) then
      Result := Result + aPaths[nPath]
    else
      Result := Result + PathDelim + aPaths[nPath];
  end;
end;

function ListSubDirectories(aPath: string): TStringList;
var
  ListArq: TStringDynArray;
  nCount: Integer;
begin
  Result := TStringList.Create;

  if not System.SysUtils.DirectoryExists(ExtractFilePath(aPath)) then
    Exit;

  ListArq := System.IOUtils.TDirectory.GetDirectories(aPath);

  for nCount := 0 to high(ListArq) do
    Result.Add(ListArq[nCount]);
end;

end.
