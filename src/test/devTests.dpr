program devTests;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  FileInfo in '..\FileInfo.pas';

begin
  System.ReportMemoryLeaksOnShutdown := True;

  try
    Writeln(GetFileInfo('fbclient.dll').FileVersion);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;

end.
