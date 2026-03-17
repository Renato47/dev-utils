unit PathUtils;

interface

uses
  System.Classes;

function pathAdd(aPaths: array of string): string;
function getPreviousDirectory(aPath: string): string;
function listSubDirectories(aPath: string): TStringList;
function selectPath(aTitle: string): string;
function getLastDirectoryFromPath(path: string): string;

implementation

uses
  System.SysUtils, System.IOUtils, System.Types, {$WARN UNIT_PLATFORM OFF} Vcl.FileCtrl {$WARN UNIT_PLATFORM ON};

function pathAdd(aPaths: array of string): string;
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

function getPreviousDirectory(aPath: string): string;
var
  lastIdx: Integer;
begin
  Result := aPath;

  if aPath.EndsWith('\') then
    aPath := aPath.Remove(Length(aPath) - 1);

  lastIdx := aPath.LastIndexOf('\');

  if lastIdx > 1 then
    Result := aPath.Remove(lastIdx + 1);
end;

function listSubDirectories(aPath: string): TStringList;
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

function selectPath(aTitle: string): string;
begin
  SelectDirectory(aTitle, '', Result, [sdNewUI, sdNewFolder]);
end;

function getLastDirectoryFromPath(path: string): string;
begin
  if path.Trim.IsEmpty then
    Exit('');

  if path.LastIndexOf('\') = 0 then
    Exit(path);

  if not ExtractFileExt(path).IsEmpty then
    path := ExtractFilePath(path);

  if path.EndsWith('\') then
    Delete(path, path.Length, 1);

  Result := path.SubString(path.LastDelimiter(PathDelim + DriveDelim) + 1);
end;

end.
