unit PathUtils;

interface

uses
  System.Classes;

function pathAdd(paths: array of string): string;
function getPreviousDirectory(path: string): string;
function listSubDirectories(path: string): TStringList;
function selectPath(title: string): string;
function getLastDirectoryFromPath(path: string): string;

implementation

uses
  System.SysUtils, System.IOUtils, System.Types, Vcl.Dialogs;

function pathAdd(paths: array of string): string;
var
  nPath: integer;
begin
  result := '';

  if length(paths) = 0 then
    exit;

  for nPath := 0 to pred(length(paths)) do begin
    if nPath = 0 then begin
      result := paths[nPath];
      continue;
    end;

    if result.endsWith(pathDelim) then
      result := result + paths[nPath]
    else
      result := result + pathDelim + paths[nPath];
  end;
end;

function getPreviousDirectory(path: string): string;
var
  lastIdx: integer;
begin
  result := path;

  if path.endsWith('\') then
    path := path.remove(length(path) - 1);

  lastIdx := path.lastIndexOf('\');

  if lastIdx > 1 then
    result := path.remove(lastIdx + 1);
end;

function listSubDirectories(path: string): TStringList;
var
  listArq: TStringDynArray;
  nCount: integer;
begin
  result := TStringList.Create;

  if not System.SysUtils.directoryExists(extractFilePath(path)) then
    exit;

  listArq := System.IOUtils.TDirectory.getDirectories(path);

  for nCount := 0 to high(listArq) do
    result.add(listArq[nCount]);
end;

{$WARN SYMBOL_PLATFORM OFF}

function selectPath(title: string): string;
var
  dialog: TFileOpenDialog;
begin
  dialog := TFileOpenDialog.Create(nil);

  try
    dialog.title := title;
    dialog.options := dialog.options + [fdoPickFolders];

    if dialog.Execute then
      result := dialog.fileName
    else
      result := '';
  finally
    dialog.free;
  end;
end;

{$WARN SYMBOL_PLATFORM ON}

function getLastDirectoryFromPath(path: string): string;
begin
  if path.trim.isEmpty then
    exit('');

  if path.lastIndexOf('\') = 0 then
    exit(path);

  if not extractFileExt(path).isEmpty then
    path := extractFilePath(path);

  if path.endsWith('\') then
    delete(path, path.length, 1);

  result := path.subString(path.lastDelimiter(pathDelim + driveDelim) + 1);
end;

end.
