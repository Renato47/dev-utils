unit uSqlBuilder.update.test;

interface

procedure updateTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure updateTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'UPDATE PRODUCT SET NAME = ''PIZZA''';
  sqlBuilder := SQL.update('PRODUCT')
    .value('NAME', 'PIZZA')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'UPDATE PRODUCT SET CREATED_AT = CURRENT_TIMESTAMP';
  sqlBuilder := SQL.update('PRODUCT')
    .valueExpression('CREATED_AT', 'CURRENT_TIMESTAMP')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'UPDATE PRODUCT SET NAME = ''PIZZA'',DESCRIPTION = NULL,CATEGORY = 8,SUB_CATEGORY = NULL WHERE ID = 5';
  sqlBuilder := SQL.update('PRODUCT')
    .valueNull('NAME', 'PIZZA')
    .valueNull('DESCRIPTION', '')
    .valueNull('CATEGORY', 8)
    .valueNull('SUB_CATEGORY', 0)
    .where(SQL.where
      .column('ID').equal(5))
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'UPDATE PRODUCT SET CREATED_AT = ' + formatDateTime('dd.mm.yyyy', now).quotedString + ',UPDATED_AT = '
    + formatDateTime('hh:mm:ss', now).quotedString + ',LAST_BOUGHT = ' + formatDateTime('dd.mm.yyyy hh:mm:ss', now)
    .quotedString + ' WHERE ID = 1';
  sqlBuilder := SQL.update('PRODUCT')
    .valueDate('CREATED_AT', now)
    .valueTime('UPDATED_AT', now)
    .valueDateTime('LAST_BOUGHT', now)
    .where('ID = 1')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'UPDATE PRODUCT SET CREATED_AT = NULL,UPDATED_AT = NULL,LAST_BOUGHT = NULL WHERE ID = 1';
  sqlBuilder := SQL.update('PRODUCT')
    .valueDate('CREATED_AT', 0)
    .valueTime('UPDATED_AT', 0)
    .valueDateTime('LAST_BOUGHT', 0)
    .where('ID = 1')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  compareSql(boolToStr(true), boolToStr(SQL.update('PRODUCTS').isEmpty));
  compareSql(boolToStr(false), boolToStr(SQL.update('PRODUCTS').value('ID', 1).isEmpty));
end;

end.
