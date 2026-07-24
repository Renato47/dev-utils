unit uSqlBuilder.UpdateOrInsert;

interface

uses
  System.SysUtils, System.Classes, uSqlBuilder.Interfaces;

type
  TSqlUpdateOrInsert = class(TInterfacedObject, ISqlUpdateOrInsert)
  private
    fTarget: string;
    fColumns: TStringList;
    fValues: TStringList;
    fColumnsMatch: string;
  public
    constructor Create;
    destructor Destroy; override;

    function into(target: string): ISqlUpdateOrInsert;

    function value(column: string; value: variant): ISqlUpdateOrInsert;
    function valueExpression(column, expression: string): ISqlUpdateOrInsert;

    function valueNull(column, value: string; nullValue: string = ''): ISqlUpdateOrInsert; overload;
    function valueNull(column: string; value: integer; nullValue: integer = 0): ISqlUpdateOrInsert; overload;

    function valueDate(column: string; value: TDate): ISqlUpdateOrInsert;
    function valueTime(column: string; value: TTime): ISqlUpdateOrInsert;
    function valueDateTime(column: string; value: TDateTime): ISqlUpdateOrInsert;

    function matching(columnList: string): ISqlUpdateOrInsert;

    function toStr: string;
    function isEmpty: boolean;
  end;

implementation

uses
  uSqlBuilder;

constructor TSqlUpdateOrInsert.Create;
begin
  fColumns := TStringList.Create;
  fColumns.quoteChar := #0;
  fColumns.strictDelimiter := true;

  fValues := TStringList.Create;
  fValues.quoteChar := #0;
  fValues.strictDelimiter := true;
end;

destructor TSqlUpdateOrInsert.Destroy;
begin
  fColumns.free;
  fValues.free;

  inherited;
end;

function TSqlUpdateOrInsert.into(target: string): ISqlUpdateOrInsert;
begin
  result := self;
  fTarget := target;
end;

function TSqlUpdateOrInsert.isEmpty: boolean;
begin
  result := fValues.count = 0;
end;

function TSqlUpdateOrInsert.matching(columnList: string): ISqlUpdateOrInsert;
begin
  result := self;
  fColumnsMatch := ' MATCHING (' + columnList + ')';
end;

function TSqlUpdateOrInsert.toStr: string;
begin
  result := 'UPDATE OR INSERT INTO ' + fTarget
    + ' (' + fColumns.delimitedText + ') VALUES (' + fValues.delimitedText + ')'
    + fColumnsMatch;
end;

function TSqlUpdateOrInsert.value(column: string; value: variant): ISqlUpdateOrInsert;
begin
  result := self;

  fColumns.append(column);
  fValues.append(TSqlValue.valueToSql(value));
end;

function TSqlUpdateOrInsert.valueDate(column: string; value: TDate): ISqlUpdateOrInsert;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('dd.mm.yyyy', value));
end;

function TSqlUpdateOrInsert.valueDateTime(column: string; value: TDateTime): ISqlUpdateOrInsert;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('dd.mm.yyyy hh:mm:ss', value));
end;

function TSqlUpdateOrInsert.valueExpression(column, expression: string): ISqlUpdateOrInsert;
begin
  result := self;

  fColumns.append(column);
  fValues.append(expression);
end;

function TSqlUpdateOrInsert.valueNull(column, value, nullValue: string): ISqlUpdateOrInsert;
begin
  result := self;

  fColumns.append(column);

  if value = nullValue then
    fValues.append('NULL')
  else
    fValues.append(TSqlValue.valueToSql(value));
end;

function TSqlUpdateOrInsert.valueNull(column: string; value, nullValue: integer): ISqlUpdateOrInsert;
begin
  result := self;

  fColumns.append(column);

  if value = nullValue then
    fValues.append('NULL')
  else
    fValues.append(TSqlValue.valueToSql(value));
end;

function TSqlUpdateOrInsert.valueTime(column: string; value: TTime): ISqlUpdateOrInsert;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('hh:mm:ss', value));
end;

end.
