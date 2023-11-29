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
  uCompare in 'uCompare.pas',
  uSqlBuilder.Delete.test in 'uSqlBuilder.Delete.test.pas',
  uSqlBuilder.ExecProcedure.test in 'uSqlBuilder.ExecProcedure.test.pas',
  uSqlBuilder.Insert.test in 'uSqlBuilder.Insert.test.pas',
  uSqlBuilder.SqlCase.test in 'uSqlBuilder.SqlCase.test.pas',
  uSqlBuilder.Update.test in 'uSqlBuilder.Update.test.pas',
  uSqlBuilder.UpdateOrInsert.test in 'uSqlBuilder.UpdateOrInsert.test.pas',
  uSqlBuilder.SqlProcedure.test in 'uSqlBuilder.SqlProcedure.test.pas',
  uSqlBuilder.SqlValue.test in 'uSqlBuilder.SqlValue.test.pas',
  uSqlBuilder.Where.test in 'uSqlBuilder.Where.test.pas';

begin
  try
    Writeln('Teste SqlBuilder');
    Writeln('');

    Writeln('Testing select');
    SelectTest;

    Writeln('Testing delete');
    DeleteTest;

    Writeln('Testing execute procedure');
    ExecProcedureTest;

    Writeln('Testing isnert');
    InsertTest;

    Writeln('Testing sql values');
    SqlValueTest;

    Writeln('Testing case');
    SqlCaseTest;

    Writeln('Testing sql procedure');
    SqlProcedureTest;

    Writeln('Testing update');
    UpdateTest;

    Writeln('Testing update or insert');
    UpdateOrInsertTest;

    Writeln('Testing where');
    WhereTest;

    Writeln('===========================================');
    Writeln('Teste completed.');
    Readln;
  except
    on E: Exception do begin
      Writeln(E.ClassName, ': ', E.Message);
      Readln;
    end;
  end;

end.
