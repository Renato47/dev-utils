unit uSqlBuilder.where.test;

interface

procedure whereTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure whereTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'ID > 0';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND PRICE >= 5';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .column('PRICE').greaterOrEqual(5)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND (PRICE >= 5 OR DESCRIPTION LIKE ''BLUE'')';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .&and(SQL.where
      .column('PRICE').greaterOrEqual(5)
      .&or('DESCRIPTION').like('BLUE'))
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND (PRICE BETWEEN 5 AND 10 OR DESCRIPTION STARTING WITH ''BLUE'')';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .&and(SQL.where
      .column('PRICE').between(5, 10)
      .&or('DESCRIPTION').startingWith('BLUE'))
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID IS NULL OR (PRICE NOT BETWEEN 5 AND 10 OR DESCRIPTION CONTAINING ''BLUE'') '
    + 'AND STATUS IN (1, 2, 3)';
  sqlBuilder := SQL.where
    .column('ID').isNull
    .&or(SQL.where
      .column('PRICE').notBetween(5, 10)
      .&or('DESCRIPTION').containing('BLUE'))
    .column('STATUS').&in([1, 2, 3])
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID IS NULL OR (CREATED_AT BETWEEN ' + formatDateTime('dd.mm.yyyy', now - 1).quotedString + ' AND ' +
    formatDateTime('dd.mm.yyyy', now).quotedString + ' AND UPDATED_AT BETWEEN ' + formatDateTime('hh:mm:ss', now - 1)
    .quotedString + ' AND ' + formatDateTime('hh:mm:ss', now).quotedString + ' AND DELETED_AT BETWEEN ' +
    formatDateTime('dd.mm.yyyy hh:mm:ss', now - 1).quotedString + ' AND ' + formatDateTime('dd.mm.yyyy hh:mm:ss', now)
    .quotedString + ' OR DESCRIPTION CONTAINING ''BLUE'') AND STATUS IN (1, 2, 3)';
  sqlBuilder := SQL.where
    .column('ID').isNull
    .&or(SQL.where
      .column('CREATED_AT').betweenDate(now - 1, now)
      .column('UPDATED_AT').betweenTime(now - 1, now)
      .column('DELETED_AT').betweenDateTime(now - 1, now)
      .&or('DESCRIPTION').containing('BLUE'))
    .column('STATUS').&in([1, 2, 3])
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID IS NULL OR (CREATED_AT NOT BETWEEN ' + formatDateTime('dd.mm.yyyy', now - 1).quotedString + ' AND '
    + formatDateTime('dd.mm.yyyy', now).quotedString + ' AND UPDATED_AT NOT BETWEEN ' +
    formatDateTime('hh:mm:ss', now - 1).quotedString + ' AND ' + formatDateTime('hh:mm:ss', now).quotedString +
    ' AND DELETED_AT NOT BETWEEN ' + formatDateTime('dd.mm.yyyy hh:mm:ss', now - 1).quotedString + ' AND ' +
    formatDateTime('dd.mm.yyyy hh:mm:ss', now).quotedString +
    ' OR DESCRIPTION CONTAINING ''BLUE'') AND STATUS IN (1, 2, 3)';
  sqlBuilder := SQL.where
    .column('ID').isNull
    .&or(SQL.where
      .column('CREATED_AT').notBetweenDate(now - 1, now)
      .column('UPDATED_AT').notBetweenTime(now - 1, now)
      .column('DELETED_AT').notBetweenDateTime(now - 1, now)
      .&or('DESCRIPTION').containing('BLUE'))
    .column('STATUS').&in([1, 2, 3])
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID IS NOT NULL AND EXISTS (SELECT ID FROM CATEGORY) AND STATUS IN (SELECT ID FROM PRODUCTS)';
  sqlBuilder := SQL.where
    .column('ID').isNotNull
    .exists(SQL.select.column('ID').from('CATEGORY'))
    .column('STATUS').&in(SQL.select.column('ID').from('PRODUCTS'))
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID IS NOT NULL AND NOT EXISTS (SELECT ID FROM CATEGORY) AND STATUS NOT IN (''A'', ''B'', ''C'')';
  sqlBuilder := SQL.where
    .column('ID').isNotNull
    .notExists(SQL.select.column('ID').from('CATEGORY'))
    .column('STATUS').notIn(['A', 'B', 'C'])
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID IS NOT NULL OR EXISTS (SELECT ID FROM CATEGORY)';
  sqlBuilder := SQL.where
    .column('ID').isNotNull
    .orExists(SQL.select.column('ID').from('CATEGORY'))
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID IS NOT NULL OR NOT EXISTS (SELECT ID FROM CATEGORY)';
  sqlBuilder := SQL.where
    .column('ID').isNotNull
    .orNotExists(SQL.select.column('ID').from('CATEGORY'))
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID < 0 AND CREATED_AT > CURRENT_DATE';
  sqlBuilder := SQL.where
    .column('ID').less(0)
    .column('CREATED_AT').greater.currentDate
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID <= 0 AND CREATED_AT >= CURRENT_DATE';
  sqlBuilder := SQL.where
    .column('ID').lessOrEqual(0)
    .column('CREATED_AT').greaterOrEqual.currentDate
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND CREATED_AT < CURRENT_TIME';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .column('CREATED_AT').less.currentTime
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND CREATED_AT <= CURRENT_TIMESTAMP';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .column('CREATED_AT').lessOrEqual.currentTimestamp
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND CREATED_AT = ' + formatDateTime('dd.mm.yyyy', now).quotedString;
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .column('CREATED_AT').equal.date(now)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID <> 0 AND CREATED_AT <> ' + formatDateTime('dd.mm.yyyy hh:mm:ss', now).quotedString;
  sqlBuilder := SQL.where
    .column('ID').different(0)
    .column('CREATED_AT').different.dateTime(now)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID = 5 AND CREATED_AT <> NULL';
  sqlBuilder := SQL.where
    .column('ID').equal(5)
    .column('CREATED_AT').different.dateTime(0)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID = 5 AND CREATED_AT = NULL';
  sqlBuilder := SQL.where
    .column('ID').equal(5)
    .column('CREATED_AT').equal.date(0)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID = 5 AND CREATED_AT = ' + formatDateTime('hh:mm:ss', now).quotedString;
  sqlBuilder := SQL.where
    .column('ID').equal(5)
    .column('CREATED_AT').equal.time(now)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID = 5 AND CREATED_AT = NULL';
  sqlBuilder := SQL.where
    .column('ID').equal(5)
    .column('CREATED_AT').equal.time(0)
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND (DESCRIPTION LIKE ''%NAME%'' AND DESCRIPTION LIKE ''%SEARCH%'')';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .column('DESCRIPTION').likeSplit('NAME SEARCH')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND DESCRIPTION LIKE ''%SEARCH%''';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .column('DESCRIPTION').likeSplit('SEARCH')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND DESCRIPTION NOT LIKE ''SEARCH''';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .column('DESCRIPTION').notLike('SEARCH')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  sqlCompare := 'ID > 0 AND PRICE > FEES';
  sqlBuilder := SQL.where
    .column('ID').greater(0)
    .column('PRICE').greater.column('FEES')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  compareSql(boolToStr(true), boolToStr(SQL.where.isEmpty));
  compareSql(boolToStr(false), boolToStr(SQL.where.column('ID').equal(1).isEmpty));
end;

end.
