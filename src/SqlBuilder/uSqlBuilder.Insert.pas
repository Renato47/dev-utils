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

    function toStr: string;
    function isEmpty: boolean;
  end;

implementation

uses
  uSqlBuilder;

constructor TSqlInsert.Create;
begin
  fColumns := TStringList.Create;
  fColumns.quoteChar := #0;
  fColumns.strictDelimiter := true;

  fValues := TStringList.Create;
  fValues.quoteChar := #0;
  fValues.strictDelimiter := true;
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

function TSqlInsert.toStr: string;
begin
  result := 'INSERT INTO ' + fTarget + ' (' + fColumns.delimitedText + ') VALUES (' + fValues.delimitedText + ')';
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

end.
