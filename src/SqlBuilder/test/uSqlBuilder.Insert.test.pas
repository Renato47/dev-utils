unit uSqlBuilder.Insert.test;

interface

procedure InsertTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure InsertTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'INSERT INTO CATEGORY (ID,DESCRIPTION) VALUES (1,''FOOD'')';
  sSqlBuilder := SQL.Insert
    .Into('CATEGORY')
    .Value('ID', 1)
    .Value('DESCRIPTION', 'FOOD')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT,UPDATED_AT,NEXT_EXECUTION) VALUES (1,''FOOD'',' + FormatDateTime('dd.mm.yyyy', Now).QuotedString + ',' +
    FormatDateTime('hh:mm:ss', Now).QuotedString + ',' + FormatDateTime('dd.mm.yyyy hh:mm:ss', Now).QuotedString + ')';
  sSqlBuilder := SQL.Insert
    .Into('CATEGORY')
    .Value('ID', 1)
    .Value('DESCRIPTION', 'FOOD')
    .ValueDate('CREATED_AT', Now)
    .ValueTime('UPDATED_AT', Now)
    .ValueDateTime('NEXT_EXECUTION', Now)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT) VALUES (1,''FOOD'',CURRENT_DATETIME)';
  sSqlBuilder := SQL.Insert
    .Into('CATEGORY')
    .Value('ID', 1)
    .Value('DESCRIPTION', 'FOOD')
    .ValueExpression('CREATED_AT', 'CURRENT_DATETIME')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'INSERT INTO CATEGORY (ID,DESCRIPTION,NAME,INDEX,SUB_CATEGORY) VALUES (1,''FOOD'',NULL,1,NULL)';
  sSqlBuilder := SQL.Insert
    .Into('CATEGORY')
    .Value('ID', 1)
    .ValueNull('DESCRIPTION', 'FOOD')
    .ValueNull('NAME', '')
    .ValueNull('INDEX', 1)
    .ValueNull('SUB_CATEGORY', 0)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  CompareSql(BoolToStr(True), BoolToStr(SQL.Insert.IsEmpty));
  CompareSql(BoolToStr(False), BoolToStr(SQL.Insert.Value('ID', 1).IsEmpty));

  //sSqlCompare := '';
  //sSqlBuilder := SQL.Insert
  //.Into('')
  //.ToString;
  //CompareSql(sSqlCompare, sSqlBuilder);
end;

end.
