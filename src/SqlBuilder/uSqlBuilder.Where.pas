unit uSqlBuilder.Where;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  TSqlWhere = class(TInterfacedObject, ISqlWhere)
  private
    fComparisonOperator: string;
    fColumn: string;
    fLogicalOperator: string;
    fConditionList: TStringList;

    procedure addCondition(criteria: string);
    procedure addParenthesesCondition(criteria: string);
    function concatArray(arry: TArray<string>): string; overload;
    function concatArray(arry: TArray<integer>): string; overload;
  public
    constructor Create;
    destructor Destroy; override;

    //Column name
    function column(column: string): ISqlWhere; overload;
    function column(select: ISqlSelect): ISqlWhere; overload;

    //Logical Operators [NOT, AND, OR]
    function &or(column: string): ISqlWhere; overload;
    function &or(sqlWhere: ISqlWhere): ISqlWhere; overload;
    function &and(sqlWhere: ISqlWhere): ISqlWhere;

    //Comparison operators [=, <>, <, <=, >, >=, ...]
    function equal: ISqlWhere; overload;
    function equal(value: variant): ISqlWhere; overload;
    function different: ISqlWhere; overload;
    function different(value: variant): ISqlWhere; overload;

    function less: ISqlWhere; overload;
    function less(value: variant): ISqlWhere; overload;
    function lessOrEqual: ISqlWhere; overload;
    function lessOrEqual(value: variant): ISqlWhere; overload;

    function greater: ISqlWhere; overload;
    function greater(value: variant): ISqlWhere; overload;
    function greaterOrEqual: ISqlWhere; overload;
    function greaterOrEqual(value: variant): ISqlWhere; overload;

    //Comparison predicates [LIKE, STARTING WITH, CONTAINING, SIMILAR TO, BETWEEN, IS [NOT] NULL, IS [NOT] DISTINCT FROM]
    function like(value: string): ISqlWhere;
    function notLike(value: string): ISqlWhere;
    function likeSplit(value: string): ISqlWhere;

    function startingWith(value: string): ISqlWhere;
    function containing(value: string): ISqlWhere;

    function isNull: ISqlWhere;
    function isNotNull: ISqlWhere;

    function between(start, end_: variant): ISqlWhere;
    function betweenDate(start, end_: TDate): ISqlWhere;
    function betweenTime(start, end_: TTime): ISqlWhere;
    function betweenDateTime(start, end_: TDateTime): ISqlWhere;
    function notBetween(start, end_: variant): ISqlWhere;
    function notBetweenDate(start, end_: TDate): ISqlWhere;
    function notBetweenTime(start, end_: TTime): ISqlWhere;
    function notBetweenDateTime(start, end_: TDateTime): ISqlWhere;

    //Existential predicates [IN, EXISTS, SINGULAR, ALL, ANY, SOME]
    function &in(values: TArray<string>): ISqlWhere; overload;
    function &in(values: TArray<integer>): ISqlWhere; overload;
    function &in(select: ISqlSelect): ISqlWhere; overload;
    function notIn(values: TArray<string>): ISqlWhere; overload;
    function notIn(values: TArray<integer>): ISqlWhere; overload;

    function exists(select: ISqlSelect): ISqlWhere;
    function notExists(select: ISqlSelect): ISqlWhere;
    function orExists(select: ISqlSelect): ISqlWhere;
    function orNotExists(select: ISqlSelect): ISqlWhere;

    //Date/time literal ['TODAY', 'NOW', '25.12.2016 15:30:35']
    function date(value: TDate): ISqlWhere;
    function time(value: TTime): ISqlWhere;
    function dateTime(value: TDateTime): ISqlWhere;

    //Context Variables
    function currentDate: ISqlWhere;
    function currentTime: ISqlWhere;
    function currentTimestamp: ISqlWhere;

    function toStr: string;
    function isEmpty: boolean;
  end;

implementation

uses
  System.SysUtils, uSqlBuilder;

function TSqlWhere.&or(column: string): ISqlWhere;
begin
  result := self;
  fColumn := column;
  fLogicalOperator := ' OR ';
end;

function TSqlWhere.&in(values: TArray<string>): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' IN (' + concatArray(values) + ')');
end;

function TSqlWhere.&in(values: TArray<integer>): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' IN (' + concatArray(values) + ')');
end;

function TSqlWhere.&in(select: ISqlSelect): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' IN (' + select.toStr + ')');
end;

procedure TSqlWhere.addCondition(criteria: string);
begin
  if not fConditionList.text.isEmpty then
    fConditionList.append(fLogicalOperator);

  fConditionList.append(criteria);

  fLogicalOperator := '';
  fColumn := '';
  fComparisonOperator := '';
end;

procedure TSqlWhere.addParenthesesCondition(criteria: string);
begin
  if not fConditionList.text.isEmpty then
    fConditionList.append(fLogicalOperator);

  fConditionList.append('(' + criteria + ')');

  fLogicalOperator := '';
end;

function TSqlWhere.&and(sqlWhere: ISqlWhere): ISqlWhere;
begin
  result := self;
  fLogicalOperator := ' AND ';
  addParenthesesCondition(sqlWhere.toStr);
end;

function TSqlWhere.between(start, end_: variant): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' BETWEEN ' + TSqlValue.valueToSql(start) + ' AND ' + TSqlValue.valueToSql(end_));
end;

function TSqlWhere.betweenDate(start, end_: TDate): ISqlWhere;
begin
  result := between(TSqlValue.asDate(start), TSqlValue.asDate(end_));
end;

function TSqlWhere.betweenDateTime(start, end_: TDateTime): ISqlWhere;
begin
  result := between(TSqlValue.asDateTime(start), TSqlValue.asDateTime(end_));
end;

function TSqlWhere.betweenTime(start, end_: TTime): ISqlWhere;
begin
  result := between(TSqlValue.asTime(start), TSqlValue.asTime(end_));
end;

function TSqlWhere.column(column: string): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty or fComparisonOperator.isEmpty then begin
    fColumn := column;
    fLogicalOperator := ' AND ';
  end
  else
    addCondition(fColumn + fComparisonOperator + column);
end;

function TSqlWhere.concatArray(arry: TArray<string>): string;
var
  nValue: integer;
begin
  if length(arry) = 0 then
    exit;

  for nValue := low(arry) to high(arry) do
    if nValue = 0 then
      result := TSqlValue.valueToSql(arry[nValue])
    else
      result := result + ', ' + TSqlValue.valueToSql(arry[nValue]);
end;

function TSqlWhere.column(select: ISqlSelect): ISqlWhere;
begin
  result := self.column('(' + select.toStr + ')');
end;

function TSqlWhere.concatArray(arry: TArray<integer>): string;
var
  nValue: integer;
begin
  if length(arry) = 0 then
    exit;

  for nValue := low(arry) to high(arry) do
    if nValue = 0 then
      result := TSqlValue.valueToSql(arry[nValue])
    else
      result := result + ', ' + TSqlValue.valueToSql(arry[nValue]);
end;

function TSqlWhere.containing(value: string): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' CONTAINING ' + TSqlValue.valueToSql(value));
end;

constructor TSqlWhere.Create;
begin
  fConditionList := TStringList.Create;
end;

function TSqlWhere.currentDate: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  if fComparisonOperator.isEmpty then
    exit;

  addCondition(fColumn + fComparisonOperator + 'CURRENT_DATE');
end;

function TSqlWhere.currentTime: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  if fComparisonOperator.isEmpty then
    exit;

  addCondition(fColumn + fComparisonOperator + 'CURRENT_TIME');
end;

function TSqlWhere.currentTimestamp: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  if fComparisonOperator.isEmpty then
    exit;

  addCondition(fColumn + fComparisonOperator + 'CURRENT_TIMESTAMP');
end;

function TSqlWhere.date(value: TDate): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  if fComparisonOperator.isEmpty then
    exit;

  if value <> 0 then
    addCondition(fColumn + fComparisonOperator + TSqlValue.valueToSql(TSqlValue.asDate(value)))
  else
    addCondition(fColumn + fComparisonOperator + 'NULL');
end;

function TSqlWhere.dateTime(value: TDateTime): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  if fComparisonOperator.isEmpty then
    exit;

  if value <> 0 then
    addCondition(fColumn + fComparisonOperator + TSqlValue.valueToSql(TSqlValue.asDateTime(value)))
  else
    addCondition(fColumn + fComparisonOperator + 'NULL');
end;

destructor TSqlWhere.Destroy;
begin
  fConditionList.free;

  inherited;
end;

function TSqlWhere.different: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  fComparisonOperator := ' <> ';
end;

function TSqlWhere.different(value: variant): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' <> ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.equal: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  fComparisonOperator := ' = ';
end;

function TSqlWhere.equal(value: variant): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' = ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.exists(select: ISqlSelect): ISqlWhere;
begin
  result := self;

  fLogicalOperator := ' AND ';
  addCondition('EXISTS (' + select.toStr + ')');
end;

function TSqlWhere.greater: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  fComparisonOperator := ' > ';
end;

function TSqlWhere.greater(value: variant): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' > ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.greaterOrEqual: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  fComparisonOperator := ' >= ';
end;

function TSqlWhere.greaterOrEqual(value: variant): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' >= ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.isEmpty: boolean;
begin
  result := fConditionList.count = 0;
end;

function TSqlWhere.isNotNull: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' IS NOT NULL');
end;

function TSqlWhere.isNull: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' IS NULL');
end;

function TSqlWhere.less: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  fComparisonOperator := ' < ';
end;

function TSqlWhere.less(value: variant): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' < ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.lessOrEqual: ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  fComparisonOperator := ' <= ';
end;

function TSqlWhere.lessOrEqual(value: variant): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' <= ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.like(value: string): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' LIKE ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.likeSplit(value: string): ISqlWhere;
var
  splittedString: TArray<string>;
  nStr: integer;
  sCondition: string;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  if value.Contains(' ') then begin
    sCondition := '';

    splittedString := value.split([' ']);

    for nStr := 0 to pred(length(splittedString)) do
      sCondition := sCondition + ' AND ' + fColumn + ' LIKE ' + TSqlValue.valueToSql('%' + splittedString[nStr] + '%');

    sCondition := sCondition.remove(0, 5);

    if not sCondition.isEmpty then
      addParenthesesCondition(sCondition);
  end
  else
    addCondition(fColumn + ' LIKE ' + TSqlValue.valueToSql('%' + value + '%'));
end;

function TSqlWhere.notBetween(start, end_: variant): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' NOT BETWEEN ' + TSqlValue.valueToSql(start) + ' AND ' + TSqlValue.valueToSql(end_));
end;

function TSqlWhere.notBetweenDate(start, end_: TDate): ISqlWhere;
begin
  result := notBetween(TSqlValue.asDate(start), TSqlValue.asDate(end_));
end;

function TSqlWhere.notBetweenDateTime(start, end_: TDateTime): ISqlWhere;
begin
  result := notBetween(TSqlValue.asDateTime(start), TSqlValue.asDateTime(end_));
end;

function TSqlWhere.notBetweenTime(start, end_: TTime): ISqlWhere;
begin
  result := notBetween(TSqlValue.asTime(start), TSqlValue.asTime(end_));
end;

function TSqlWhere.notExists(select: ISqlSelect): ISqlWhere;
begin
  result := self;

  fLogicalOperator := ' AND ';
  addCondition('NOT EXISTS (' + select.toStr + ')');
end;

function TSqlWhere.notIn(values: TArray<string>): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' NOT IN (' + concatArray(values) + ')');
end;

function TSqlWhere.notIn(values: TArray<integer>): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' NOT IN (' + concatArray(values) + ')');
end;

function TSqlWhere.notLike(value: string): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' NOT LIKE ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.&or(sqlWhere: ISqlWhere): ISqlWhere;
begin
  result := self;

  fLogicalOperator := ' OR ';
  addCondition('(' + sqlWhere.toStr + ')');
end;

function TSqlWhere.orExists(select: ISqlSelect): ISqlWhere;
begin
  result := self;

  fLogicalOperator := ' OR ';
  addCondition('EXISTS (' + select.toStr + ')');
end;

function TSqlWhere.orNotExists(select: ISqlSelect): ISqlWhere;
begin
  result := self;

  fLogicalOperator := ' OR ';
  addCondition('NOT EXISTS (' + select.toStr + ')');
end;

function TSqlWhere.startingWith(value: string): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  addCondition(fColumn + ' STARTING WITH ' + TSqlValue.valueToSql(value));
end;

function TSqlWhere.time(value: TTime): ISqlWhere;
begin
  result := self;

  if fColumn.isEmpty then
    exit;

  if fComparisonOperator.isEmpty then
    exit;

  if value <> 0 then
    addCondition(fColumn + fComparisonOperator + TSqlValue.valueToSql(TSqlValue.asTime(value)))
  else
    addCondition(fColumn + fComparisonOperator + 'NULL');
end;

function TSqlWhere.toStr: string;
begin
  result := fConditionList.text.replace(sLineBreak, '');
end;

end.
