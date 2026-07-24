unit uSqlBuilder.SqlProcedure.test;

interface

procedure sqlProcedureTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure sqlProcedureTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'GENERATE_FEES (1, NULL, NULL)';
  sqlBuilder := SQL.&procedure('GENERATE_FEES')
    .value(1)
    .valueExpression('NULL')
    .null
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'GENERATE_FEES (''ORDER'', NULL, 5, NULL)';
  sqlBuilder := SQL.&procedure('GENERATE_FEES')
    .valueNull('ORDER')
    .valueNull('')
    .valueNull(5)
    .valueNull(0)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'GENERATE_FEES (' + formatDateTime('dd.mm.yyyy', now).quotedString + ', '
    + formatDateTime('hh:mm:ss', now).quotedString + ', '
    + formatDateTime('dd.mm.yyyy hh:mm:ss', now).quotedString + ')';
  sqlBuilder := SQL.&procedure('GENERATE_FEES')
    .date(now)
    .time(now)
    .dateTime(now)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'GENERATE_FEES (CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP)';
  sqlBuilder := SQL.&procedure('GENERATE_FEES')
    .currentDate
    .currentTime
    .currentTimestamp
    .toStr;
  compareSql(sqlCompare, sqlBuilder);
end;

end.
