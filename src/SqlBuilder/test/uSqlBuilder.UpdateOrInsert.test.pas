unit uSqlBuilder.UpdateOrInsert.test;

interface

procedure UpdateOrInsertTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure UpdateOrInsertTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'UPDATE OR INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT) VALUES (1,''PIZZA'',CURRENT_TIMESTAMP)';
  sSqlBuilder := SQL.UpdateOrInsert
    .Into('CATEGORY')
    .Value('ID', 1)
    .Value('DESCRIPTION', 'PIZZA')
    .ValueExpression('CREATED_AT', 'CURRENT_TIMESTAMP')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'UPDATE OR INSERT INTO CATEGORY (ID,DESCRIPTION,NAME,INDEX,SUB_CATEGORY) VALUES (1,''PIZZA'',NULL,1,NULL) MATCHING (ID)';
  sSqlBuilder := SQL.UpdateOrInsert
    .Into('CATEGORY')
    .Value('ID', 1)
    .ValueNull('DESCRIPTION', 'PIZZA')
    .ValueNull('NAME', '')
    .ValueNull('INDEX', 1)
    .ValueNull('SUB_CATEGORY', 0)
    .Matching('ID')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'UPDATE OR INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT,UPDATED_AT,SINCRO_AT) VALUES (1,''PIZZA'',' + FormatDateTime('dd.mm.yyyy', Now).QuotedString + ',' +
    FormatDateTime('hh:mm:ss', Now).QuotedString + ',' + FormatDateTime('dd.mm.yyyy hh:mm:ss', Now).QuotedString + ') MATCHING (ID)';
  sSqlBuilder := SQL.UpdateOrInsert
    .Into('CATEGORY')
    .Value('ID', 1)
    .Value('DESCRIPTION', 'PIZZA')
    .ValueDate('CREATED_AT', Now)
    .ValueTime('UPDATED_AT', Now)
    .ValueDateTime('SINCRO_AT', Now)
    .Matching('ID')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  CompareSql(BoolToStr(True), BoolToStr(SQL.UpdateOrInsert.IsEmpty));
  CompareSql(BoolToStr(False), BoolToStr(SQL.UpdateOrInsert.Value('ID', 1).IsEmpty));
end;

end.
