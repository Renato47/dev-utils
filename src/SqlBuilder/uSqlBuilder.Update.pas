unit uSqlBuilder.Update;

interface

uses
  System.SysUtils, System.Classes, uSqlBuilder.Interfaces;

type
  TSqlUpdate = class(TInterfacedObject, ISqlUpdate)
  private
    fTarget: string;
    fColumnsValues: TStringList;
    fConditions: string;
  public
    constructor Create;
    destructor Destroy; override;

    function table(target: string): ISqlUpdate;

    function value(column: string; value: variant): ISqlUpdate;
    function valueExpression(column, expression: string): ISqlUpdate;

    function valueNull(column, value: string; nullValue: string = ''): ISqlUpdate; overload;
    function valueNull(column: string; value: integer; nullValue: integer = 0): ISqlUpdate; overload;

    function valueDate(column: string; value: TDate): ISqlUpdate;
    function valueTime(column: string; value: TTime): ISqlUpdate;
    function valueDateTime(column: string; value: TDateTime): ISqlUpdate;

    function where(conditions: string): ISqlUpdate; overload;
    function where(sqlWhere: ISqlWhere): ISqlUpdate; overload;

    function toStr: string;
    function isEmpty: boolean;
  end;

implementation

uses
  uSqlBuilder;

constructor TSqlUpdate.Create;
begin
  fColumnsValues := TStringList.Create;
  fColumnsValues.quoteChar := #0;
  fColumnsValues.strictDelimiter := true;
end;

destructor TSqlUpdate.Destroy;
begin
  fColumnsValues.free;

  inherited;
end;

function TSqlUpdate.isEmpty: boolean;
begin
  result := fColumnsValues.count = 0;
end;

function TSqlUpdate.table(target: string): ISqlUpdate;
begin
  result := self;
  fTarget := target;
end;

function TSqlUpdate.toStr: string;
begin
  result := 'UPDATE ' + fTarget + ' SET ' + fColumnsValues.delimitedText;

  if not fConditions.isEmpty then
    result := result + ' WHERE ' + fConditions;
end;

function TSqlUpdate.value(column: string; value: variant): ISqlUpdate;
begin
  result := self;
  fColumnsValues.append(column + ' = ' + TSqlValue.valueToSql(value));
end;

function TSqlUpdate.valueDate(column: string; value: TDate): ISqlUpdate;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('dd.mm.yyyy', value));
end;

function TSqlUpdate.valueDateTime(column: string; value: TDateTime): ISqlUpdate;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('dd.mm.yyyy hh:mm:ss', value));
end;

function TSqlUpdate.valueExpression(column, expression: string): ISqlUpdate;
begin
  result := self;
  fColumnsValues.append(column + ' = ' + expression);
end;

function TSqlUpdate.valueNull(column: string; value, nullValue: integer): ISqlUpdate;
begin
  result := self;

  if value = nullValue then
    fColumnsValues.append(column + ' = NULL')
  else
    fColumnsValues.append(column + ' = ' + TSqlValue.valueToSql(value));
end;

function TSqlUpdate.valueTime(column: string; value: TTime): ISqlUpdate;
begin
  if value = 0 then
    result := valueExpression(column, 'NULL')
  else
    result := self.value(column, formatDateTime('hh:mm:ss', value));
end;

function TSqlUpdate.valueNull(column, value, nullValue: string): ISqlUpdate;
begin
  result := self;

  if value = nullValue then
    fColumnsValues.append(column + ' = NULL')
  else
    fColumnsValues.append(column + ' = ' + TSqlValue.valueToSql(value));
end;

function TSqlUpdate.where(sqlWhere: ISqlWhere): ISqlUpdate;
begin
  result := where(sqlWhere.toStr);
end;

function TSqlUpdate.where(conditions: string): ISqlUpdate;
begin
  result := self;
  fConditions := conditions;
end;

end.
