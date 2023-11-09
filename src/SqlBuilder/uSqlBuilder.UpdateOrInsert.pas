unit uSqlBuilder.UpdateOrInsert;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, uSqlBuilder.Interfaces;

type
  TSqlUpdateOrInsert = class(TInterfacedObject, ISqlUpdateOrInsert)
  private
    target: string;
    columns: TStringList;
    values: TStringList;
    columnsMatch: string;
  public
    constructor Create;
    destructor Destroy; override;

    function Into(aTarget: string): ISqlUpdateOrInsert;

    function Value(aColumn: string; aValue: TValue): ISqlUpdateOrInsert;
    function ValueExpression(aColumn, aExpression: string): ISqlUpdateOrInsert;

    function ValueNull(aColumn, aValue: string; aNullValue: string = ''): ISqlUpdateOrInsert; overload;
    function ValueNull(aColumn: string; aValue: Integer; aNullValue: Integer = 0): ISqlUpdateOrInsert; overload;

    function ValueDate(aColumn: string; aDate: TDate): ISqlUpdateOrInsert;
    function ValueTime(aColumn: string; aTime: TTime): ISqlUpdateOrInsert;
    function ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlUpdateOrInsert;

    function Matching(aColumnList: string): ISqlUpdateOrInsert;

    function ToString: string; override;
    function IsEmpty: Boolean;
  end;

implementation

uses
  uSqlBuilder;

constructor TSqlUpdateOrInsert.Create;
begin
  columns := TStringList.Create;
  columns.QuoteChar := #0;
  columns.StrictDelimiter := True;

  values := TStringList.Create;
  values.QuoteChar := #0;
  values.StrictDelimiter := True;
end;

destructor TSqlUpdateOrInsert.Destroy;
begin
  columns.Free;
  values.Free;

  inherited;
end;

function TSqlUpdateOrInsert.Into(aTarget: string): ISqlUpdateOrInsert;
begin
  Result := Self;
  target := aTarget;
end;

function TSqlUpdateOrInsert.IsEmpty: Boolean;
begin
  Result := values.Count = 0;
end;

function TSqlUpdateOrInsert.Matching(aColumnList: string): ISqlUpdateOrInsert;
begin
  Result := Self;
  columnsMatch := ' MATCHING (' + aColumnList + ')';
end;

function TSqlUpdateOrInsert.ToString: string;
begin
  Result := 'UPDATE OR INSERT INTO ' + target + ' (' + columns.DelimitedText + ') VALUES (' + values.DelimitedText + ')' + columnsMatch;
end;

function TSqlUpdateOrInsert.Value(aColumn: string; aValue: TValue): ISqlUpdateOrInsert;
begin
  Result := Self;

  columns.Append(aColumn);
  values.Append(TSqlValue.ValueToSql(aValue));
end;

function TSqlUpdateOrInsert.ValueDate(aColumn: string; aDate: TDate): ISqlUpdateOrInsert;
begin
  Result := Value(aColumn, FormatDateTime('dd.mm.yyyy', aDate));
end;

function TSqlUpdateOrInsert.ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlUpdateOrInsert;
begin
  Result := Value(aColumn, FormatDateTime('dd.mm.yyyy hh:mm:ss', aDateTime));
end;

function TSqlUpdateOrInsert.ValueExpression(aColumn, aExpression: string): ISqlUpdateOrInsert;
begin
  Result := Self;

  columns.Append(aColumn);
  values.Append(aExpression);
end;

function TSqlUpdateOrInsert.ValueNull(aColumn, aValue, aNullValue: string): ISqlUpdateOrInsert;
begin
  Result := Self;

  columns.Append(aColumn);

  if aValue = aNullValue then
    values.Append('NULL')
  else
    values.Append(TSqlValue.ValueToSql(aValue));
end;

function TSqlUpdateOrInsert.ValueNull(aColumn: string; aValue, aNullValue: Integer): ISqlUpdateOrInsert;
begin
  Result := Self;

  columns.Append(aColumn);

  if aValue = aNullValue then
    values.Append('NULL')
  else
    values.Append(TSqlValue.ValueToSql(aValue));
end;

function TSqlUpdateOrInsert.ValueTime(aColumn: string; aTime: TTime): ISqlUpdateOrInsert;
begin
  Result := Value(aColumn, FormatDateTime('hh:mm:ss', aTime));
end;

end.
