unit uSqlBuilder.SqlCase.test;

interface

procedure sqlCaseTest;

implementation

uses
  uSqlBuilder, uCompare;

procedure sqlCaseTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'CASE MODULE WHEN 1 THEN ''INSERT'' WHEN 2 THEN ''UPDATE'' ELSE ''UNKNOWN'' END';
  sqlBuilder := SQL.&case
    .testExpression('MODULE')
    .whenThen('1', 'INSERT')
    .whenThen('2', 'UPDATE')
    .&else('UNKNOWN')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare :=
    'CASE WHEN DESCRIPTION IS NOT NULL THEN DESCRIPTION WHEN NAME IS NOT NULL THEN NAME ELSE ID END AS FIELD';
  sqlBuilder := SQL.&case
    .whenThenColumn('DESCRIPTION IS NOT NULL', 'DESCRIPTION')
    .whenThenColumn('NAME IS NOT NULL', 'NAME')
    .elseColumn('ID')
    .&as('FIELD')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);
end;

end.
