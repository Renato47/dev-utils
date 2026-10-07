unit uSqlBuilder.Insert;

interface

uses
  System.SysUtils, System.Classes, uSqlBuilder.Interfaces;

type
  TSqlInsert = class(TInterfacedObject, ISqlInsert)
  private
    fTarget: string;
    fColumns: TStringList;
    fValues: TStringList;
    fReturnings: TArray<string>;

    function concatArray(arry: TArray<string>): string;
  public
    constructor Create;
    destructor Destroy; override;

    function into(target: string): ISqlInsert;

    function value(column: string; value: variant): ISqlInsert;
    function valueExpression(column, expression: string): ISqlInsert;

    function valueNull(column, value: string; nullValue: string = ''): ISqlInsert; overload;
    function valueNull(column: string; value: integer; nullValue: integer = 0): ISqlInsert; overload;

    function valueDate(column: string; value: TDate): ISqlInsert;
    function valueTime(column: string; value: TTime): ISqlInsert;
    function valueDateTime(column: string; value: TDateTime): ISqlInsert;

    function returning(columns: TArray<string>): ISqlInsert;

    function toStr: string;
    function isEmpty: boolean;
  end;

  TSqlInsertSelect = class(TInterfacedObject, ISqlInsertSelect)
  private
    fTarget: string;
    fColumns: TStringList;
    fSelect: ISqlSelect;
    fReturnings: TArray<string>;

    function concatArray(arry: TArray<string>): string;
  public
    constructor Create;
    destructor Destroy; override;

    function into(target: string): ISqlInsertSelect;

    function columns(columns: TArray<string>): ISqlInsertSelect;
    function select(sqlSelect: ISqlSelect): ISqlInsertSelect;

    function returning(columns: TArray<string>): ISqlInsertSelect;

    function toStr: string;
    function isEmpty: boolean;
  end;

implementation

uses
  uSqlBuilder;

function TSqlInsert.concatArray(arry: TArray<string>): string;
var
  nValue: integer;
begin
  if length(arry) = 0 then
    exit('');

  for nValue := low(arry) to high(arry) do
    if nValue = 0 then
      result := arry[nValue]
    else
      result := result + ', ' + arry[nValue];
end;

constructor TSqlInsert.Create;
begin
  fColumns := TStringList.Create;
  fColumns.quoteChar := #0;
  fColumns.strictDelimiter := true;

  fValues := TStringList.Create;
  fValues.quoteChar := #0;
  fValues.strictDelimiter := true;

  fReturnings := [];
end;

destructor TSqlInsert.Destroy;
begin
  fColumns.free;
  fValues.free;

  inherited;
end;

function TSqlInsert.into(target: string): ISqlInsert;
begin
  result := self;
  fTarget := target;
end;

function TSqlInsert.isEmpty: boolean;
begin
  result := fValues.count = 0;
end;

function TSqlInsert.returning(columns: TArray<string>): ISqlInsert;
begin
  result := self;

  fReturnings := fReturnings + columns;
end;

function TSqlInsert.toStr: string;
var
  returningColumns: string;
begin
  returningColumns := concatArray(fReturnings);

  if not returningColumns.isEmpty then
    returningColumns := ' RETURNING ' + returningColumns;

  result :=
    'INSERT INTO ' + fTarget
    + ' (' + fColumns.delimitedText + ') VALUES (' + fValues.delimitedText + ')'
    + returningColumns;
end;

function TSqlInsert.value(column: string; value: variant): ISqlInsert;
begin
  result := self;

  fColumns.append(column);
  fValues.append(TSqlValue.valueToSql(value));
end;

function TSqlInsert.valueDate(column: string; value: TDate): ISqlInsert;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('dd.mm.yyyy', value));
end;

function TSqlInsert.valueDateTime(column: string; value: TDateTime): ISqlInsert;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('dd.mm.yyyy hh:mm:ss', value));
end;

function TSqlInsert.valueExpression(column, expression: string): ISqlInsert;
begin
  result := self;

  fColumns.append(column);
  fValues.append(expression);
end;

function TSqlInsert.valueNull(column, value, nullValue: string): ISqlInsert;
begin
  result := self;

  fColumns.append(column);

  if value = nullValue then
    fValues.append('NULL')
  else
    fValues.append(TSqlValue.valueToSql(value));
end;

function TSqlInsert.valueNull(column: string; value, nullValue: integer): ISqlInsert;
begin
  result := self;

  fColumns.append(column);

  if value = nullValue then
    fValues.append('NULL')
  else
    fValues.append(TSqlValue.valueToSql(value));
end;

function TSqlInsert.valueTime(column: string; value: TTime): ISqlInsert;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('hh:mm:ss', value));
end;

function TSqlInsertSelect.columns(columns: TArray<string>): ISqlInsertSelect;
var
  nColumn: integer;
begin
  result := self;

  for nColumn := low(columns) to high(columns) do
    fColumns.add(columns[nColumn]);
end;

function TSqlInsertSelect.concatArray(arry: TArray<string>): string;
var
  nValue: integer;
begin
  if length(arry) = 0 then
    exit('');

  for nValue := low(arry) to high(arry) do
    if nValue = 0 then
      result := arry[nValue]
    else
      result := result + ', ' + arry[nValue];
end;

constructor TSqlInsertSelect.Create;
begin
  fColumns := TStringList.Create;
  fColumns.quoteChar := #0;
  fColumns.strictDelimiter := true;

  fReturnings := [];
end;

destructor TSqlInsertSelect.Destroy;
begin
  fColumns.free;

  inherited;
end;

function TSqlInsertSelect.into(target: string): ISqlInsertSelect;
begin
  result := self;
  fTarget := target;
end;

function TSqlInsertSelect.isEmpty: boolean;
begin
  result := fColumns.count = 0;
end;

function TSqlInsertSelect.returning(columns: TArray<string>): ISqlInsertSelect;
begin
  result := self;

  fReturnings := fReturnings + columns;
end;

function TSqlInsertSelect.select(sqlSelect: ISqlSelect): ISqlInsertSelect;
begin
  result := self;

  fSelect := sqlSelect;
end;

function TSqlInsertSelect.toStr: string;
var
  returningColumns: string;
begin
  returningColumns := concatArray(fReturnings);

  if not returningColumns.isEmpty then
    returningColumns := ' RETURNING ' + returningColumns;

  result :=
    'INSERT INTO ' + fTarget
    + ' (' + fColumns.delimitedText + ') '
    + fSelect.toStr
    + returningColumns;
end;

end.
