unit uSqlBuilder.Insert;

interface

uses
  System.SysUtils, System.Classes, uSqlBuilder.Interfaces;

type
  TSqlInsert = class(TInterfacedObject, ISqlInsert)
  private
    target: string;
    columns: TStringList;
    values: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    function Into(aTarget: string): ISqlInsert;

    function Value(aColumn: string; aValue: Variant): ISqlInsert;
    function ValueExpression(aColumn, aExpression: string): ISqlInsert;

    function ValueNull(aColumn, aValue: string; aNullValue: string = ''): ISqlInsert; overload;
    function ValueNull(aColumn: string; aValue: Integer; aNullValue: Integer = 0): ISqlInsert; overload;

    function ValueDate(aColumn: string; aDate: TDate): ISqlInsert;
    function ValueTime(aColumn: string; aTime: TTime): ISqlInsert;
    function ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlInsert;

    function ToString: string; override;
    function IsEmpty: Boolean;
  end;

implementation

uses
  uSqlBuilder;

constructor TSqlInsert.Create;
begin
  columns := TStringList.Create;
  columns.QuoteChar := #0;
  columns.StrictDelimiter := True;

  values := TStringList.Create;
  values.QuoteChar := #0;
  values.StrictDelimiter := True;
end;

destructor TSqlInsert.Destroy;
begin
  columns.Free;
  values.Free;

  inherited;
end;

function TSqlInsert.Into(aTarget: string): ISqlInsert;
begin
  Result := Self;
  target := aTarget;
end;

function TSqlInsert.IsEmpty: Boolean;
begin
  Result := values.Count = 0;
end;

function TSqlInsert.ToString: string;
begin
  Result := 'INSERT INTO ' + target + ' (' + columns.DelimitedText + ') VALUES (' + values.DelimitedText + ')';
end;

function TSqlInsert.Value(aColumn: string; aValue: Variant): ISqlInsert;
begin
  Result := Self;

  columns.Append(aColumn);
  values.Append(TSqlValue.ValueToSql(aValue));
end;

function TSqlInsert.ValueDate(aColumn: string; aDate: TDate): ISqlInsert;
begin
  Result := Value(aColumn, FormatDateTime('dd.mm.yyyy', aDate));
end;

function TSqlInsert.ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlInsert;
begin
  Result := Value(aColumn, FormatDateTime('dd.mm.yyyy hh:mm:ss', aDateTime));
end;

function TSqlInsert.ValueExpression(aColumn, aExpression: string): ISqlInsert;
begin
  Result := Self;

  columns.Append(aColumn);
  values.Append(aExpression);
end;

function TSqlInsert.ValueNull(aColumn, aValue, aNullValue: string): ISqlInsert;
begin
  Result := Self;

  columns.Append(aColumn);

  if aValue = aNullValue then
    values.Append('NULL')
  else
    values.Append(TSqlValue.ValueToSql(aValue));
end;

function TSqlInsert.ValueNull(aColumn: string; aValue, aNullValue: Integer): ISqlInsert;
begin
  Result := Self;

  columns.Append(aColumn);

  if aValue = aNullValue then
    values.Append('NULL')
  else
    values.Append(TSqlValue.ValueToSql(aValue));
end;

function TSqlInsert.ValueTime(aColumn: string; aTime: TTime): ISqlInsert;
begin
  Result := Value(aColumn, FormatDateTime('hh:mm:ss', aTime));
end;

end.
