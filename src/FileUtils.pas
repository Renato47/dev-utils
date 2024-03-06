unit FileUtils;

interface

uses
  System.Classes, Winapi.Windows;

function ShowFile(aFilePath: string): Boolean;

function CopyFileHandle(aOrigem, aDestino: string): Boolean;

function DownloadFile(SourceFile, DestFile: string): Boolean;

function ExecuteFileAndWait(aFilePath: string; aParams: string = ''; aShowWindow: Word = SW_SHOW): Boolean;
function ExecuteFile(aFilePath: string; aParams: string = ''): Boolean;

function ListFiles(aPath, aFileFilter: string; bIsExtractFileName: Boolean = True): TStringList;
function SelectFile(aFilter: string = ''; aDefaultPath: string = ''): string;

implementation

uses
  Winapi.ShellAPI, Winapi.UrlMon, System.SysUtils, System.IOUtils, System.Types, Vcl.Dialogs;

function ShowFile(aFilePath: string): Boolean;
begin
  Result := FileExists(aFilePath);

  if Result then
    ShellExecute(MainInstance, 'open', PChar('explorer.exe'), PChar('/n, /select,' + aFilePath), nil, SW_SHOWMAXIMIZED);
end;

function CopyFileHandle(aOrigem, aDestino: string): Boolean;
begin
  if UpperCase(aOrigem).Equals(UpperCase(aDestino)) then
    Exit(True);

  if not System.SysUtils.FileExists(aOrigem) then
    Exit(False);

  if not System.SysUtils.DirectoryExists(ExtractFilePath(aDestino)) then
    System.SysUtils.ForceDirectories(ExtractFilePath(aDestino));

  Result := CopyFile(StringToOleStr(aOrigem), StringToOleStr(aDestino), False);
end;

function DownloadFile(SourceFile, DestFile: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(SourceFile), PChar(DestFile), 0, nil) = 0;
  except
    Result := False;
  end;
end;

function ExecuteFileAndWait(aFilePath: string; aParams: string = ''; aShowWindow: Word = SW_SHOW): Boolean;
var
  sCmdLine: string;
  siInfo: TStartupInfo;
  piProcessInfo: TProcessInformation;
begin
  sCmdLine := '"' + aFilePath + '" ' + aParams;

  FillChar(siInfo, SizeOf(siInfo), #0);

  siInfo.cb := SizeOf(siInfo);
  siInfo.dwFlags := STARTF_USESHOWWINDOW;
  siInfo.wShowWindow := aShowWindow;

  Result := CreateProcess(nil, PChar(sCmdLine), nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, siInfo, piProcessInfo);

  if not Result then
    raise Exception.Create('Erro ao executar aplicativo ' + aFilePath + sLineBreak + SysErrorMessage(GetLastError));

  WaitForSingleObject(piProcessInfo.hProcess, INFINITE);

  CloseHandle(piProcessInfo.hProcess);
  CloseHandle(piProcessInfo.hThread);
end;

function ExecuteFile(aFilePath: string; aParams: string = ''): Boolean;
begin
  Result := False;

  if not FileExists(aFilePath) then
    Exit;

  Result := not(ShellExecute(MainInstance, 'Open', PChar(aFilePath), PChar(aParams), PChar(ExtractFilePath(aFilePath)), SW_SHOW) < 31);
end;

function ListFiles(aPath, aFileFilter: string; bIsExtractFileName: Boolean = True): TStringList;
var
  FilesArray: TStringDynArray;
  nCount: Integer;
begin
  Result := TStringList.Create;

  if not System.SysUtils.DirectoryExists(aPath) then
    Exit;

  if not aFileFilter.IsEmpty then
    FilesArray := System.IOUtils.TDirectory.GetFiles(aPath, aFileFilter)
  else
    FilesArray := System.IOUtils.TDirectory.GetFiles(aPath);

  for nCount := 0 to high(FilesArray) do
    if bIsExtractFileName then
      Result.Add(ExtractFileName(FilesArray[nCount]))
    else
      Result.Add(FilesArray[nCount]);
end;

function SelectFile(aFilter: string = ''; aDefaultPath: string = ''): string;
var
  OpenD: TOpenDialog;
begin
  Result := '';

  OpenD := TOpenDialog.Create(nil);
  OpenD.InitialDir := ExtractFilePath(aDefaultPath);
  OpenD.Filter := aFilter;

  if OpenD.Execute then
    if FileExists(OpenD.FileName) then
      Result := OpenD.FileName;

  OpenD.Free;
end;

end.
