unit uSqlBuilder.Update.test;

interface

procedure UpdateTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure UpdateTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'UPDATE PRODUCT SET NAME = ''PIZZA''';
  sSqlBuilder := SQL.Update('PRODUCT')
    .Value('NAME', 'PIZZA')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'UPDATE PRODUCT SET CREATED_AT = CURRENT_TIMESTAMP';
  sSqlBuilder := SQL.Update('PRODUCT')
    .ValueExpression('CREATED_AT', 'CURRENT_TIMESTAMP')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'UPDATE PRODUCT SET NAME = ''PIZZA'',DESCRIPTION = NULL,CATEGORY = 8,SUB_CATEGORY = NULL WHERE ID = 5';
  sSqlBuilder := SQL.Update('PRODUCT')
    .ValueNull('NAME', 'PIZZA')
    .ValueNull('DESCRIPTION', '')
    .ValueNull('CATEGORY', 8)
    .ValueNull('SUB_CATEGORY', 0)
    .Where(SQL.Where
      .Column('ID').Equal(5))
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'UPDATE PRODUCT SET CREATED_AT = ' + FormatDateTime('dd.mm.yyyy', Now).QuotedString + ',UPDATED_AT = ' + FormatDateTime('hh:mm:ss', Now).QuotedString +
    ',LAST_BOUGHT = ' + FormatDateTime('dd.mm.yyyy hh:mm:ss', Now).QuotedString + ' WHERE ID = 1';
  sSqlBuilder := SQL.Update('PRODUCT')
    .ValueDate('CREATED_AT', Now)
    .ValueTime('UPDATED_AT', Now)
    .ValueDateTime('LAST_BOUGHT', Now)
    .Where('ID = 1')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  CompareSql(BoolToStr(True), BoolToStr(SQL.Update('PRODUCTS').IsEmpty));
  CompareSql(BoolToStr(False), BoolToStr(SQL.Update('PRODUCTS').Value('ID', 1).IsEmpty));
end;

end.
