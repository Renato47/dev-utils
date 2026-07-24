unit uSqlBuilder.ExecProcedure.test;

interface

procedure execProcedureTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure execProcedureTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'EXECUTE PROCEDURE UPDATE_FEES';
  sqlBuilder := SQL.executeProc('UPDATE_FEES').toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, CURRENT_DATE)';
  sqlBuilder := SQL.executeProc('RECEIVE_DELIVERY')
    .value(10)
    .currentDate
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, CURRENT_TIME)';
  sqlBuilder := SQL.executeProc('RECEIVE_DELIVERY')
    .value(10)
    .currentTime
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, CURRENT_TIMESTAMP)';
  sqlBuilder := SQL.executeProc('RECEIVE_DELIVERY')
    .value(10)
    .currentTimestamp
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, ' + formatDateTime('dd.mm.yyyy', now).quotedString + ')';
  sqlBuilder := SQL.executeProc('RECEIVE_DELIVERY')
    .value(10)
    .date(now)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, ' + formatDateTime('dd.mm.yyyy hh:mm:ss', now)
    .quotedString + ')';
  sqlBuilder := SQL.executeProc('RECEIVE_DELIVERY')
    .value(10)
    .dateTime(now)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, ' + formatDateTime('hh:mm:ss', now).quotedString + ')';
  sqlBuilder := SQL.executeProc('RECEIVE_DELIVERY')
    .value(10)
    .time(now)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //Null values
  sqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (NULL, ''AB'', NULL, 10, NULL)';
  sqlBuilder := SQL.executeProc('RECEIVE_DELIVERY')
    .null
    .valueNull('AB')
    .valueNull('')
    .valueNull(10)
    .valueNull(0)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'EXECUTE PROCEDURE SET_ID ((SELECT ID FROM CATEGORY), 5)';
  sqlBuilder := SQL.executeProc('SET_ID')
    .valueExpression('(SELECT ID FROM CATEGORY)')
    .value(5)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);
end;

end.
