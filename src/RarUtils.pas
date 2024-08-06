unit RarUtils;

interface

uses
  System.Classes;

function CompressFilesRar(aFileList: TStringList; aDestinationFileName: string; aSplitRarMB: Integer = 0): Boolean;
function DecompressRar(aRarFilePath: string; aDestinationPath: string = ''): Boolean;

implementation

uses
  Winapi.Windows, Winapi.ShellAPI, System.SysUtils, System.StrUtils;

function Execute(aComand: string): Boolean;
var
  stInfo: TStartupInfo;
  piProcessInfo: TProcessInformation;
begin
  FillChar(stInfo, SizeOf(stInfo), #0);

  stInfo.cb := SizeOf(stInfo);
  stInfo.dwFlags := STARTF_USESHOWWINDOW;
  stInfo.wShowWindow := SW_SHOW;

  Result := CreateProcess(nil, PChar(aComand), nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, PChar(ExtractFilePath(ParamStr(0))), stInfo, piProcessInfo);

  if Result then begin
    WaitForSingleObject(piProcessInfo.hProcess, INFINITE);

    CloseHandle(piProcessInfo.hProcess);
    CloseHandle(piProcessInfo.hThread);
  end;
end;

function CompressFilesRar(aFileList: TStringList; aDestinationFileName: string; aSplitRarMB: Integer = 0): Boolean;
var
  sWinRarExe, sFiles, sCmdLine: string;
  nFile: Integer;
begin
  sWinRarExe := 'C:\Program Files\WinRAR\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    sWinRarExe := 'C:\Program Files (x86)\WinRAR\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    sWinRarExe := ExtractFilePath(ParamStr(0)) + 'winrar\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    raise Exception.Create('Erro instalação winrar não encontrado');

  if aFileList = nil then
    raise Exception.Create('Nenhum arquivo origem foi informado!');

  if not System.SysUtils.DirectoryExists(ExtractFilePath(aDestinationFileName)) then
    raise Exception.Create('Diretorio Destino invalido!');

  sFiles := '';

  for nFile := 0 to aFileList.Count - 1 do
    sFiles := sFiles + '"' + aFileList.Strings[nFile] + '" ';

  sCmdLine := '"' + sWinRarExe + '" -ibck a -ep1 -idc -m5 ' + IfThen(aSplitRarMB > 0, '-v' + aSplitRarMB.ToString + 'M ', '') + '"' + aDestinationFileName + '"' + ' ' + sFiles;

  Result := Execute(sCmdLine);

  if Result then
    Result := FileExists(aDestinationFileName);
end;

function DecompressRar(aRarFilePath: string; aDestinationPath: string = ''): Boolean;
var
  sWinRarExe, sCmdLine: string;
begin
  sWinRarExe := 'C:\Program Files\WinRAR\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    sWinRarExe := 'C:\Program Files (x86)\WinRAR\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    sWinRarExe := ExtractFilePath(ParamStr(0)) + 'winrar\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    raise Exception.Create('Erro instalação winrar não encontrado');

  if not FileExists(aRarFilePath) then
    raise Exception.Create('Arquivo rar não localizado!');

  if aDestinationPath.IsEmpty then
    aDestinationPath := ExtractFilePath(aRarFilePath);

  sCmdLine := '"' + sWinRarExe + '" x -ibck "' + aRarFilePath + '" "' + aDestinationPath + '"';

  Result := Execute(sCmdLine);
end;

end.
