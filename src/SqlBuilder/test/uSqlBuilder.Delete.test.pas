unit uSqlBuilder.delete.test;

interface

procedure deleteTest;

implementation

uses
  uSqlBuilder, uCompare;

procedure deleteTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'DELETE FROM SESSIONS';
  sqlBuilder := SQL.delete
    .from('SESSIONS')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'DELETE FROM SESSIONS WHERE USERID IS NULL';
  sqlBuilder := SQL.delete
    .from('SESSIONS')
    .where('USERID IS NULL')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);
end;

end.
