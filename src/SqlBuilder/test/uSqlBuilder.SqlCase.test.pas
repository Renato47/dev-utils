unit uSqlBuilder.SqlCase.test;

interface

procedure SqlCaseTest;

implementation

uses
  uSqlBuilder, uCompare;

procedure SqlCaseTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'CASE MODULE WHEN 1 THEN ''INSERT'' WHEN 2 THEN ''UPDATE'' ELSE ''UNKNOWN'' END';
  sSqlBuilder := SQL.&Case
    .TestExpression('MODULE')
    .WhenThen('1', 'INSERT')
    .WhenThen('2', 'UPDATE')
    .&Else('UNKNOWN')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'CASE WHEN DESCRIPTION IS NOT NULL THEN DESCRIPTION WHEN NAME IS NOT NULL THEN NAME ELSE ID END AS FIELD';
  sSqlBuilder := SQL.&Case
    .WhenThenColumn('DESCRIPTION IS NOT NULL', 'DESCRIPTION')
    .WhenThenColumn('NAME IS NOT NULL', 'NAME')
    .ElseColumn('ID')
    .&As('FIELD')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);
end;

end.
