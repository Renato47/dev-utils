unit uSqlBuilder.updateOrInsert.test;

interface

procedure updateOrInsertTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure updateOrInsertTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'UPDATE OR INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT) VALUES (1,''PIZZA'',CURRENT_TIMESTAMP)';
  sqlBuilder := SQL.updateOrInsert
    .into('CATEGORY')
    .value('ID', 1)
    .value('DESCRIPTION', 'PIZZA')
    .valueExpression('CREATED_AT', 'CURRENT_TIMESTAMP')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'UPDATE OR INSERT INTO CATEGORY (ID,DESCRIPTION,NAME,INDEX,SUB_CATEGORY) '
    + 'VALUES (1,''PIZZA'',NULL,1,NULL) MATCHING (ID)';
  sqlBuilder := SQL.updateOrInsert
    .into('CATEGORY')
    .value('ID', 1)
    .valueNull('DESCRIPTION', 'PIZZA')
    .valueNull('NAME', '')
    .valueNull('INDEX', 1)
    .valueNull('SUB_CATEGORY', 0)
    .matching('ID')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'UPDATE OR INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT,UPDATED_AT,SINCRO_AT) VALUES (1,''PIZZA'','
    + formatDateTime('dd.mm.yyyy', now).quotedString + ',' + formatDateTime('hh:mm:ss', now).quotedString + ',' +
    formatDateTime('dd.mm.yyyy hh:mm:ss', now).quotedString + ') MATCHING (ID)';
  sqlBuilder := SQL.updateOrInsert
    .into('CATEGORY')
    .value('ID', 1)
    .value('DESCRIPTION', 'PIZZA')
    .valueDate('CREATED_AT', now)
    .valueTime('UPDATED_AT', now)
    .valueDateTime('SINCRO_AT', now)
    .matching('ID')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'UPDATE OR INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT,UPDATED_AT,SINCRO_AT) '
    + 'VALUES (1,''PIZZA'',NULL,NULL,NULL) MATCHING (ID)';
  sqlBuilder := SQL.updateOrInsert
    .into('CATEGORY')
    .value('ID', 1)
    .value('DESCRIPTION', 'PIZZA')
    .valueDate('CREATED_AT', 0)
    .valueTime('UPDATED_AT', 0)
    .valueDateTime('SINCRO_AT', 0)
    .matching('ID')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  compareSql(boolToStr(true), boolToStr(SQL.updateOrInsert.isEmpty));
  compareSql(boolToStr(false), boolToStr(SQL.updateOrInsert.value('ID', 1).isEmpty));
end;

end.
