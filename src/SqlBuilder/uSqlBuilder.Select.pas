unit uSqlBuilder.select;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  TSqlSelect = class(TInterfacedObject, ISqlSelect)
  private
    fColumns: TStringList;
    fSource: string;
    fFirstRows: string;
    fSkipRows: string;
    fDistinct: string;
    fJoinList: TStringList;
    fConditions: string;
    fGroupList: string;
    fAggregateCondition: string;
    fOrderList: string;
  public
    constructor Create;
    destructor Destroy; override;

    function allColumns: ISqlSelect;
    function column(name: string): ISqlSelect; overload;
    function column(case_: ISqlCase): ISqlSelect; overload;

    function cast(asType, alias: string): ISqlSelect;

    function from(source: string): ISqlSelect; overload;
    function from(select: ISqlSelect; alias: string): ISqlSelect; overload;
    function from(sqlProcedure: ISqlProcedure; alias: string = ''): ISqlSelect; overload;

    function innerJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect; overload;
    function innerJoin(source, conditions: string): ISqlSelect; overload;
    function leftJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect; overload;
    function leftJoin(source, conditions: string): ISqlSelect; overload;
    function rightJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect; overload;
    function rightJoin(source, conditions: string): ISqlSelect; overload;

    function where(conditions: string): ISqlSelect; overload;
    function where(sqlWhere: ISqlWhere): ISqlSelect; overload;
    function groupBy(group: string): ISqlSelect;
    function having(aggregateCondition: string): ISqlSelect;
    function orderBy(order: string): ISqlSelect;

    function first(count: integer): ISqlSelect;
    function skip(count: integer): ISqlSelect;
    function distinct: ISqlSelect;

    function toStr: string;
  end;

implementation

uses
  System.SysUtils;

function TSqlSelect.allColumns: ISqlSelect;
begin
  result := self;
  fColumns.append('*');
end;

function TSqlSelect.column(name: string): ISqlSelect;
begin
  result := self;
  fColumns.append(name);
end;

function TSqlSelect.cast(asType, alias: string): ISqlSelect;
begin
  result := self;

  if fColumns.count = 0 then
    exit;

  fColumns.strings[pred(fColumns.count)] :=
    'CAST(' + fColumns.strings[pred(fColumns.count)] + ' AS ' + asType + ') AS ' + alias;
end;

function TSqlSelect.column(case_: ISqlCase): ISqlSelect;
begin
  result := self;
  fColumns.append(case_.toStr);
end;

constructor TSqlSelect.Create;
begin
  fColumns := TStringList.Create;
  fColumns.quoteChar := #0;
  fColumns.strictDelimiter := true;

  fJoinList := TStringList.Create;
  fJoinList.quoteChar := #0;
  fJoinList.strictDelimiter := true;
end;

destructor TSqlSelect.Destroy;
begin
  fColumns.free;
  fJoinList.free;

  inherited;
end;

function TSqlSelect.distinct: ISqlSelect;
begin
  result := self;
  fDistinct := 'DISTINCT ';
end;

function TSqlSelect.first(count: integer): ISqlSelect;
begin
  result := self;

  if count > 0 then
    fFirstRows := 'FIRST ' + intToStr(count) + ' ';
end;

function TSqlSelect.from(sqlProcedure: ISqlProcedure; alias: string): ISqlSelect;
begin
  result := self;

  if not alias.isEmpty then
    fSource := sqlProcedure.toStr + ' ' + alias
  else
    fSource := sqlProcedure.toStr;
end;

function TSqlSelect.from(select: ISqlSelect; alias: string): ISqlSelect;
begin
  result := self;
  fSource := '(' + select.toStr + ') AS ' + alias;
end;

function TSqlSelect.from(source: string): ISqlSelect;
begin
  result := self;
  fSource := source;
end;

function TSqlSelect.groupBy(group: string): ISqlSelect;
begin
  result := self;

  if fGroupList.isEmpty then
    fGroupList := ' GROUP BY ' + group
  else
    fGroupList := fGroupList + ', ' + group;
end;

function TSqlSelect.having(aggregateCondition: string): ISqlSelect;
begin
  result := self;
  fAggregateCondition := ' HAVING ' + aggregateCondition;
end;

function TSqlSelect.innerJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect;
begin
  result := self;
  innerJoin('(' + select.toStr + ') ' + alias, conditions);
end;

function TSqlSelect.innerJoin(source, conditions: string): ISqlSelect;
begin
  result := self;
  fJoinList.append(' INNER JOIN ' + source + ' ON ' + conditions);
end;

function TSqlSelect.leftJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect;
begin
  result := self;
  leftJoin('(' + select.toStr + ') ' + alias, conditions);
end;

function TSqlSelect.leftJoin(source, conditions: string): ISqlSelect;
begin
  result := self;
  fJoinList.append(' LEFT JOIN ' + source + ' ON ' + conditions);
end;

function TSqlSelect.orderBy(order: string): ISqlSelect;
begin
  result := self;

  if fOrderList.isEmpty then
    fOrderList := ' ORDER BY ' + order
  else
    fOrderList := fOrderList + ', ' + order;
end;

function TSqlSelect.rightJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect;
begin
  result := self;
  rightJoin('(' + select.toStr + ') ' + alias, conditions);
end;

function TSqlSelect.rightJoin(source, conditions: string): ISqlSelect;
begin
  result := self;
  fJoinList.append(' RIGHT JOIN ' + source + ' ON ' + conditions);
end;

function TSqlSelect.skip(count: integer): ISqlSelect;
begin
  result := self;

  if count > 0 then
    fSkipRows := 'SKIP ' + intToStr(count) + ' ';
end;

function TSqlSelect.toStr: string;
begin
  result :=
    'SELECT ' +
    fFirstRows + fSkipRows + fDistinct + fColumns.delimitedText +
    ' FROM ' + fSource +
    fJoinList.text.replace(sLineBreak, '') +
    fConditions +
    fGroupList +
    fAggregateCondition +
    fOrderList;
end;

function TSqlSelect.where(sqlWhere: ISqlWhere): ISqlSelect;
begin
  result := where(sqlWhere.toStr);
end;

function TSqlSelect.where(conditions: string): ISqlSelect;
begin
  result := self;
  fConditions := ' WHERE ' + conditions;
end;

end.
