unit uSqlBuilder.Delete.test;

interface

procedure DeleteTest;

implementation

uses
  uSqlBuilder, uCompare;

procedure DeleteTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'DELETE FROM SESSIONS';
  sSqlBuilder := SQL.Delete
    .From('SESSIONS')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'DELETE FROM SESSIONS WHERE USERID IS NULL';
  sSqlBuilder := SQL.Delete
    .From('SESSIONS')
    .Where('USERID IS NULL')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);
end;

end.
