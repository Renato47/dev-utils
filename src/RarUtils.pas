unit RarUtils;

interface

//procedure CompressFiles(aFile, aDestinationPath: string);
function ExtractFile(aFile, aDestinationPath: string): Boolean;

implementation

uses
  Winapi.ShellAPI, System.SysUtils;

function ExtractFile(aFile, aDestinationPath: string): Boolean;
var
  sWinRarExe, sParam: string;
begin
  sWinRarExe := 'C:\Program Files\WinRAR\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    sWinRarExe := 'C:\Program Files (x86)\WinRAR\WinRAR.exe';

  if not FileExists(sWinRarExe) then
    raise Exception.Create('Erro instalação winrar não encontrado');

  sParam := 'x -ibck "' + aFile + '" "' + aDestinationPath + '"';
  Result := ShellExecute(MainInstance, 'Open', PChar(sWinRarExe), PChar(sParam), '', 0) > 32;
end;

end.
