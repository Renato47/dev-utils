unit uSqlBuilder.Where.test;

interface

procedure WhereTest;

implementation

uses
  uSqlBuilder, uCompare, System.SysUtils;

procedure WhereTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'ID > 0';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND PRICE >= 5';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .Column('PRICE').GreaterOrEqual(5)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND (PRICE >= 5 OR DESCRIPTION LIKE ''BLUE'')';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .&And(SQL.Where
      .Column('PRICE').GreaterOrEqual(5)
      .&Or('DESCRIPTION').Like('BLUE'))
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND (PRICE BETWEEN 5 AND 10 OR DESCRIPTION STARTING WITH ''BLUE'')';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .&And(SQL.Where
      .Column('PRICE').Between(5, 10)
      .&Or('DESCRIPTION').StartingWith('BLUE'))
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID IS NULL OR (PRICE NOT BETWEEN 5 AND 10 OR DESCRIPTION CONTAINING ''BLUE'') AND STATUS IN (1, 2, 3)';
  sSqlBuilder := SQL.Where
    .Column('ID').IsNull
    .&Or(SQL.Where
      .Column('PRICE').NotBetween(5, 10)
      .&Or('DESCRIPTION').Containing('BLUE'))
    .Column('STATUS').&In([1, 2, 3])
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID IS NULL OR (CREATED_AT BETWEEN ' + FormatDateTime('dd.mm.yyyy', Now - 1).QuotedString + ' AND ' + FormatDateTime('dd.mm.yyyy', Now).QuotedString +
    ' AND UPDATED_AT BETWEEN ' + FormatDateTime('hh:mm:ss', Now - 1).QuotedString + ' AND ' + FormatDateTime('hh:mm:ss', Now).QuotedString + ' AND DELETED_AT BETWEEN ' +
    FormatDateTime('dd.mm.yyyy hh:mm:ss', Now - 1).QuotedString + ' AND ' + FormatDateTime('dd.mm.yyyy hh:mm:ss', Now).QuotedString +
    ' OR DESCRIPTION CONTAINING ''BLUE'') AND STATUS IN (1, 2, 3)';
  sSqlBuilder := SQL.Where
    .Column('ID').IsNull
    .&Or(SQL.Where
      .Column('CREATED_AT').BetweenDate(Now - 1, Now)
      .Column('UPDATED_AT').BetweenTime(Now - 1, Now)
      .Column('DELETED_AT').BetweenDateTime(Now - 1, Now)
      .&Or('DESCRIPTION').Containing('BLUE'))
    .Column('STATUS').&In([1, 2, 3])
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID IS NULL OR (CREATED_AT NOT BETWEEN ' + FormatDateTime('dd.mm.yyyy', Now - 1).QuotedString + ' AND ' + FormatDateTime('dd.mm.yyyy', Now).QuotedString +
    ' AND UPDATED_AT NOT BETWEEN ' + FormatDateTime('hh:mm:ss', Now - 1).QuotedString + ' AND ' + FormatDateTime('hh:mm:ss', Now).QuotedString + ' AND DELETED_AT NOT BETWEEN ' +
    FormatDateTime('dd.mm.yyyy hh:mm:ss', Now - 1).QuotedString + ' AND ' + FormatDateTime('dd.mm.yyyy hh:mm:ss', Now).QuotedString +
    ' OR DESCRIPTION CONTAINING ''BLUE'') AND STATUS IN (1, 2, 3)';
  sSqlBuilder := SQL.Where
    .Column('ID').IsNull
    .&Or(SQL.Where
      .Column('CREATED_AT').NotBetweenDate(Now - 1, Now)
      .Column('UPDATED_AT').NotBetweenTime(Now - 1, Now)
      .Column('DELETED_AT').NotBetweenDateTime(Now - 1, Now)
      .&Or('DESCRIPTION').Containing('BLUE'))
    .Column('STATUS').&In([1, 2, 3])
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID IS NOT NULL AND EXISTS (SELECT ID FROM CATEGORY) AND STATUS IN (SELECT ID FROM PRODUCTS)';
  sSqlBuilder := SQL.Where
    .Column('ID').IsNotNull
    .Exists(SQL.Select.Column('ID').From('CATEGORY'))
    .Column('STATUS').&In(SQL.Select.Column('ID').From('PRODUCTS'))
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID IS NOT NULL AND NOT EXISTS (SELECT ID FROM CATEGORY) AND STATUS NOT IN (''A'', ''B'', ''C'')';
  sSqlBuilder := SQL.Where
    .Column('ID').IsNotNull
    .NotExists(SQL.Select.Column('ID').From('CATEGORY'))
    .Column('STATUS').NotIn(['A', 'B', 'C'])
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID IS NOT NULL OR EXISTS (SELECT ID FROM CATEGORY)';
  sSqlBuilder := SQL.Where
    .Column('ID').IsNotNull
    .OrExists(SQL.Select.Column('ID').From('CATEGORY'))
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID IS NOT NULL OR NOT EXISTS (SELECT ID FROM CATEGORY)';
  sSqlBuilder := SQL.Where
    .Column('ID').IsNotNull
    .OrNotExists(SQL.Select.Column('ID').From('CATEGORY'))
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID < 0 AND CREATED_AT > CURRENT_DATE';
  sSqlBuilder := SQL.Where
    .Column('ID').Less(0)
    .Column('CREATED_AT').Greater.CurrentDate
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID <= 0 AND CREATED_AT >= CURRENT_DATE';
  sSqlBuilder := SQL.Where
    .Column('ID').LessOrEqual(0)
    .Column('CREATED_AT').GreaterOrEqual.CurrentDate
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND CREATED_AT < CURRENT_TIME';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .Column('CREATED_AT').Less.CurrentTime
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND CREATED_AT <= CURRENT_TIMESTAMP';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .Column('CREATED_AT').LessOrEqual.CurrentTimestamp
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND CREATED_AT = ' + FormatDateTime('dd.mm.yyyy', Now).QuotedString;
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .Column('CREATED_AT').Equal.Date(Now)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID <> 0 AND CREATED_AT <> ' + FormatDateTime('dd.mm.yyyy hh:mm:ss', Now).QuotedString;
  sSqlBuilder := SQL.Where
    .Column('ID').Different(0)
    .Column('CREATED_AT').Different.DateTime(Now)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID = 5 AND CREATED_AT <> NULL';
  sSqlBuilder := SQL.Where
    .Column('ID').Equal(5)
    .Column('CREATED_AT').Different.DateTime(0)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID = 5 AND CREATED_AT = NULL';
  sSqlBuilder := SQL.Where
    .Column('ID').Equal(5)
    .Column('CREATED_AT').Equal.Date(0)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID = 5 AND CREATED_AT = ' + FormatDateTime('hh:mm:ss', Now).QuotedString;
  sSqlBuilder := SQL.Where
    .Column('ID').Equal(5)
    .Column('CREATED_AT').Equal.Time(Now)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID = 5 AND CREATED_AT = NULL';
  sSqlBuilder := SQL.Where
    .Column('ID').Equal(5)
    .Column('CREATED_AT').Equal.Time(0)
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND (DESCRIPTION LIKE ''%NAME%'' AND DESCRIPTION LIKE ''%SEARCH%'')';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .Column('DESCRIPTION').LikeSplit('NAME SEARCH')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND DESCRIPTION LIKE ''%SEARCH%''';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .Column('DESCRIPTION').LikeSplit('SEARCH')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND DESCRIPTION NOT LIKE ''SEARCH''';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .Column('DESCRIPTION').NotLike('SEARCH')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  sSqlCompare := 'ID > 0 AND PRICE > FEES';
  sSqlBuilder := SQL.Where
    .Column('ID').Greater(0)
    .Column('PRICE').Greater.Column('FEES')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  CompareSql(BoolToStr(True), BoolToStr(SQL.Where.IsEmpty));
  CompareSql(BoolToStr(False), BoolToStr(SQL.Where.Column('ID').Equal(1).IsEmpty));
end;

end.
