unit uSqlBuilder.insert.test;

interface

procedure insertTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure insertTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'INSERT INTO CATEGORY (ID,DESCRIPTION) VALUES (1,''FOOD'')';
  sqlBuilder := SQL.insert
    .into('CATEGORY')
    .value('ID', 1)
    .value('DESCRIPTION', 'FOOD')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT,UPDATED_AT,NEXT_EXECUTION) VALUES (1,''FOOD'','
    + formatDateTime('dd.mm.yyyy', now).quotedString + ','
    + formatDateTime('hh:mm:ss', now).quotedString + ','
    + formatDateTime('dd.mm.yyyy hh:mm:ss', now).quotedString + ')';
  sqlBuilder := SQL.insert
    .into('CATEGORY')
    .value('ID', 1)
    .value('DESCRIPTION', 'FOOD')
    .valueDate('CREATED_AT', now)
    .valueTime('UPDATED_AT', now)
    .valueDateTime('NEXT_EXECUTION', now)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare :=
    'INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT,UPDATED_AT,NEXT_EXECUTION) VALUES (1,''FOOD'',NULL,NULL,NULL)';
  sqlBuilder := SQL.insert
    .into('CATEGORY')
    .value('ID', 1)
    .value('DESCRIPTION', 'FOOD')
    .valueDate('CREATED_AT', 0)
    .valueTime('UPDATED_AT', 0)
    .valueDateTime('NEXT_EXECUTION', 0)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'INSERT INTO CATEGORY (ID,DESCRIPTION,CREATED_AT) VALUES (1,''FOOD'',CURRENT_DATETIME)';
  sqlBuilder := SQL.insert
    .into('CATEGORY')
    .value('ID', 1)
    .value('DESCRIPTION', 'FOOD')
    .valueExpression('CREATED_AT', 'CURRENT_DATETIME')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'INSERT INTO CATEGORY (ID,DESCRIPTION,NAME,INDEX,SUB_CATEGORY) VALUES (1,''FOOD'',NULL,1,NULL)';
  sqlBuilder := SQL.insert
    .into('CATEGORY')
    .value('ID', 1)
    .valueNull('DESCRIPTION', 'FOOD')
    .valueNull('NAME', '')
    .valueNull('INDEX', 1)
    .valueNull('SUB_CATEGORY', 0)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  compareSql(boolToStr(true), boolToStr(SQL.insert.isEmpty));
  compareSql(boolToStr(false), boolToStr(SQL.insert.value('ID', 1).isEmpty));
end;

end.
