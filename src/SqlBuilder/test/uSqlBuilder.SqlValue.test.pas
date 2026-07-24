unit uSqlBuilder.SqlValue.test;

interface

procedure sqlValueTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure sqlValueTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := '10';
  sqlBuilder := TSqlValue.valueToSql(10);
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := '5.987';
  sqlBuilder := TSqlValue.valueToSql(5.987);
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'DESCRIPTION TEST'.quotedString;
  sqlBuilder := TSqlValue.valueToSql('DESCRIPTION TEST');
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'NULL';
  sqlBuilder := TSqlValue.valueToSql('Null');
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'NULL';
  sqlBuilder := TSqlValue.asDate(0);
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := formatDateTime('dd.mm.yyyy', now);
  sqlBuilder := TSqlValue.asDate(now);
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'NULL';
  sqlBuilder := TSqlValue.asTime(0);
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := formatDateTime('hh:mm:ss', now);
  sqlBuilder := TSqlValue.asTime(now);
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'NULL';
  sqlBuilder := TSqlValue.asDateTime(0);
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := formatDateTime('dd.mm.yyyy hh:mm:ss', now);
  sqlBuilder := TSqlValue.asDateTime(now);
  compareSql(sqlCompare, sqlBuilder);
end;

end.
