unit RarUtils;

interface

//procedure CompressFiles(aFile, aDestinationPath: string);
function ExtractFile(aRarFilePath, aDestinationPath: string): Boolean;

implementation

uses
  Winapi.Windows, Winapi.ShellAPI, System.SysUtils;

function ExtractFile(aRarFilePath, aDestinationPath: string): Boolean;
var
  stInfo: TStartupInfo;
  piProcessInfo: TProcessInformation;
  sWinRarExe, sCmdLine: string;
begin
  sWinRarExe := 'C:\Program Files\WinRAR\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    sWinRarExe := 'C:\Program Files (x86)\WinRAR\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    raise Exception.Create('Erro instalação winrar não encontrado');

  sCmdLine := '"' + sWinRarExe + '" x -ibck "' + aRarFilePath + '" "' + aDestinationPath + '"';

  FillChar(stInfo, SizeOf(stInfo), #0);

  stInfo.cb := SizeOf(stInfo);
  stInfo.dwFlags := STARTF_USESHOWWINDOW;
  stInfo.wShowWindow := SW_SHOW;

  Result := CreateProcess(nil, PChar(sCmdLine), nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, PChar(ExtractFilePath(ParamStr(0))), stInfo, piProcessInfo);

  if Result then begin
    WaitForSingleObject(piProcessInfo.hProcess, INFINITE);

    CloseHandle(piProcessInfo.hProcess);
    CloseHandle(piProcessInfo.hThread);
  end;
end;

end.
