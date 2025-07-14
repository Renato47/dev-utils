program devTests;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  FileInfo in '..\FileInfo.pas',
  PathUtils in '..\PathUtils.pas',
  RarUtils in '..\RarUtils.pas',
  uIniFiles in '..\uIniFiles.pas',
  JsonUtils in '..\JsonUtils.pas',
  JsonUtils.test in 'JsonUtils.test.pas';

begin
  System.ReportMemoryLeaksOnShutdown := True; //report mostra no terminal quando está fechando.

  try
    Writeln('App tests');

    TestarJsonUtils;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;

end.
