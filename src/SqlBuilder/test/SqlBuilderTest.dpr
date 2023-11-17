program SqlBuilderTest;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  uSqlBuilder.CreateProcedure in '..\uSqlBuilder.CreateProcedure.pas',
  uSqlBuilder.Delete in '..\uSqlBuilder.Delete.pas',
  uSqlBuilder.ExecProcedure in '..\uSqlBuilder.ExecProcedure.pas',
  uSqlBuilder.Insert in '..\uSqlBuilder.Insert.pas',
  uSqlBuilder.Interfaces in '..\uSqlBuilder.Interfaces.pas',
  uSqlBuilder in '..\uSqlBuilder.pas',
  uSqlBuilder.Select in '..\uSqlBuilder.Select.pas',
  uSqlBuilder.SqlCase in '..\uSqlBuilder.SqlCase.pas',
  uSqlBuilder.SqlProcedure in '..\uSqlBuilder.SqlProcedure.pas',
  uSqlBuilder.Update in '..\uSqlBuilder.Update.pas',
  uSqlBuilder.UpdateOrInsert in '..\uSqlBuilder.UpdateOrInsert.pas',
  uSqlBuilder.Where in '..\uSqlBuilder.Where.pas',
  uSqlBuilder.Select.test in 'uSqlBuilder.Select.test.pas',
  uCompare in 'uCompare.pas';

begin
  try
    Writeln('Teste SqlBuilder');
    Writeln('');

    SelectTest;

    Writeln('Teste completed.');
    Readln;
  except
    on E: Exception do begin
      Writeln(E.ClassName, ': ', E.Message);
      Readln;
    end;
  end;

end.
