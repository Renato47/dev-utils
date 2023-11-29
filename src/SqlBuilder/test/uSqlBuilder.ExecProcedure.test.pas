unit uSqlBuilder.ExecProcedure.test;

interface

procedure ExecProcedureTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure ExecProcedureTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'EXECUTE PROCEDURE UPDATE_FEES';
  sSqlBuilder := SQL.ExecuteProc('UPDATE_FEES').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, CURRENT_DATE)';
  sSqlBuilder := SQL.ExecuteProc('RECEIVE_DELIVERY')
    .Value(10)
    .CurrentDate
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, CURRENT_TIME)';
  sSqlBuilder := SQL.ExecuteProc('RECEIVE_DELIVERY')
    .Value(10)
    .CurrentTime
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, CURRENT_TIMESTAMP)';
  sSqlBuilder := SQL.ExecuteProc('RECEIVE_DELIVERY')
    .Value(10)
    .CurrentTimestamp
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, ' + FormatDateTime('dd.mm.yyyy', Now).QuotedString + ')';
  sSqlBuilder := SQL.ExecuteProc('RECEIVE_DELIVERY')
    .Value(10)
    .Date(Now)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, ' + FormatDateTime('dd.mm.yyyy hh:mm:ss', Now).QuotedString + ')';
  sSqlBuilder := SQL.ExecuteProc('RECEIVE_DELIVERY')
    .Value(10)
    .DateTime(Now)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (10, ' + FormatDateTime('hh:mm:ss', Now).QuotedString + ')';
  sSqlBuilder := SQL.ExecuteProc('RECEIVE_DELIVERY')
    .Value(10)
    .Time(Now)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //Null values
  sSqlCompare := 'EXECUTE PROCEDURE RECEIVE_DELIVERY (NULL, ''AB'', NULL, 10, NULL)';
  sSqlBuilder := SQL.ExecuteProc('RECEIVE_DELIVERY')
    .Null
    .ValueNull('AB')
    .ValueNull('')
    .ValueNull(10)
    .ValueNull(0)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'EXECUTE PROCEDURE SET_ID ((SELECT ID FROM CATEGORY), 5)';
  sSqlBuilder := SQL.ExecuteProc('SET_ID')
    .ValueExpression('(SELECT ID FROM CATEGORY)')
    .Value(5)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);
end;

end.
