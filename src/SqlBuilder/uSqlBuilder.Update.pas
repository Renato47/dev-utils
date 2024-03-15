unit uSqlBuilder.Update;

interface

uses
  System.SysUtils, System.Classes, uSqlBuilder.Interfaces;

type
  TSqlUpdate = class(TInterfacedObject, ISqlUpdate)
  private
    target: string;
    columnsValues: TStringList;
    conditions: string;
  public
    constructor Create;
    destructor Destroy; override;

    function Table(aTarget: string): ISqlUpdate;

    function Value(aColumn: string; aValue: Variant): ISqlUpdate;
    function ValueExpression(aColumn, aExpression: string): ISqlUpdate;

    function ValueNull(aColumn, aValue: string; aNullValue: string = ''): ISqlUpdate; overload;
    function ValueNull(aColumn: string; aValue: Integer; aNullValue: Integer = 0): ISqlUpdate; overload;

    function ValueDate(aColumn: string; aDate: TDate): ISqlUpdate;
    function ValueTime(aColumn: string; aTime: TTime): ISqlUpdate;
    function ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlUpdate;

    function Where(aConditions: string): ISqlUpdate; overload;
    function Where(aWhere: ISqlWhere): ISqlUpdate; overload;

    function ToString: string; override;
    function IsEmpty: Boolean;
  end;

implementation

uses
  uSqlBuilder;

constructor TSqlUpdate.Create;
begin
  columnsValues := TStringList.Create;
  columnsValues.QuoteChar := #0;
  columnsValues.StrictDelimiter := True;
end;

destructor TSqlUpdate.Destroy;
begin
  columnsValues.Free;

  inherited;
end;

function TSqlUpdate.IsEmpty: Boolean;
begin
  Result := columnsValues.Count = 0;
end;

function TSqlUpdate.Table(aTarget: string): ISqlUpdate;
begin
  Result := Self;
  target := aTarget;
end;

function TSqlUpdate.ToString: string;
begin
  Result := 'UPDATE ' + target + ' SET ' + columnsValues.DelimitedText;

  if not conditions.IsEmpty then
    Result := Result + ' WHERE ' + conditions;
end;

function TSqlUpdate.Value(aColumn: string; aValue: Variant): ISqlUpdate;
begin
  Result := Self;
  columnsValues.Append(aColumn + ' = ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlUpdate.ValueDate(aColumn: string; aDate: TDate): ISqlUpdate;
begin
  if aDate = 0 then
    Result := ValueExpression(aColumn, 'NULL')
  else
    Result := Value(aColumn, FormatDateTime('dd.mm.yyyy', aDate));
end;

function TSqlUpdate.ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlUpdate;
begin
  if aDateTime = 0 then
    Result := ValueExpression(aColumn, 'NULL')
  else
    Result := Value(aColumn, FormatDateTime('dd.mm.yyyy hh:mm:ss', aDateTime));
end;

function TSqlUpdate.ValueExpression(aColumn, aExpression: string): ISqlUpdate;
begin
  Result := Self;
  columnsValues.Append(aColumn + ' = ' + aExpression);
end;

function TSqlUpdate.ValueNull(aColumn: string; aValue, aNullValue: Integer): ISqlUpdate;
begin
  Result := Self;

  if aValue = aNullValue then
    columnsValues.Append(aColumn + ' = NULL')
  else
    columnsValues.Append(aColumn + ' = ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlUpdate.ValueTime(aColumn: string; aTime: TTime): ISqlUpdate;
begin
  if aTime = 0 then
    Result := ValueExpression(aColumn, 'NULL')
  else
    Result := Value(aColumn, FormatDateTime('hh:mm:ss', aTime));
end;

function TSqlUpdate.ValueNull(aColumn, aValue, aNullValue: string): ISqlUpdate;
begin
  Result := Self;

  if aValue = aNullValue then
    columnsValues.Append(aColumn + ' = NULL')
  else
    columnsValues.Append(aColumn + ' = ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlUpdate.Where(aWhere: ISqlWhere): ISqlUpdate;
begin
  Result := Where(aWhere.ToString);
end;

function TSqlUpdate.Where(aConditions: string): ISqlUpdate;
begin
  Result := Self;
  conditions := aConditions;
end;

end.
