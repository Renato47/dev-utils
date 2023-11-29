unit uSqlBuilder.SqlProcedure.test;

interface

procedure SqlProcedureTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure SqlProcedureTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'GENERATE_FEES (1, NULL, NULL)';
  sSqlBuilder := SQL.&Procedure('GENERATE_FEES')
    .Value(1)
    .ValueExpression('NULL')
    .Null
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'GENERATE_FEES (''ORDER'', NULL, 5, NULL)';
  sSqlBuilder := SQL.&Procedure('GENERATE_FEES')
    .ValueNull('ORDER')
    .ValueNull('')
    .ValueNull(5)
    .ValueNull(0)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'GENERATE_FEES (' + FormatDateTime('dd.mm.yyyy', Now).QuotedString + ', ' + FormatDateTime('hh:mm:ss', Now).QuotedString + ', ' +
    FormatDateTime('dd.mm.yyyy hh:mm:ss', Now).QuotedString + ')';
  sSqlBuilder := SQL.&Procedure('GENERATE_FEES')
    .Date(Now)
    .Time(Now)
    .DateTime(Now)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'GENERATE_FEES (CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP)';
  sSqlBuilder := SQL.&Procedure('GENERATE_FEES')
    .CurrentDate
    .CurrentTime
    .CurrentTimestamp
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);
end;

end.
