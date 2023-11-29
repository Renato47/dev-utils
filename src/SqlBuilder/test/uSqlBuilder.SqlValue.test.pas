unit uSqlBuilder.SqlValue.test;

interface

procedure SqlValueTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure SqlValueTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := '10';
  sSqlBuilder := TSqlValue.ValueToSql(10);
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := '5.987';
  sSqlBuilder := TSqlValue.ValueToSql(5.987);
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'DESCRIPTION TEST'.QuotedString;
  sSqlBuilder := TSqlValue.ValueToSql('DESCRIPTION TEST');
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'NULL';
  sSqlBuilder := TSqlValue.ValueToSql('Null');
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'NULL';
  sSqlBuilder := TSqlValue.AsDate(0);
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := FormatDateTime('dd.mm.yyyy', Now);
  sSqlBuilder := TSqlValue.AsDate(Now);
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'NULL';
  sSqlBuilder := TSqlValue.AsTime(0);
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := FormatDateTime('hh:mm:ss', Now);
  sSqlBuilder := TSqlValue.AsTime(Now);
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'NULL';
  sSqlBuilder := TSqlValue.AsDateTime(0);
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := FormatDateTime('dd.mm.yyyy hh:mm:ss', Now);
  sSqlBuilder := TSqlValue.AsDateTime(Now);
  CompareSql(sSqlCompare, sSqlBuilder);
end;

end.
