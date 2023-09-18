unit uSqlBuilder.Insert;

interface

uses
  System.Classes, System.Rtti, uSqlBuilder.Interfaces;

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

    function Value(aColumn: string; aValue: TValue): ISqlInsert;

    function ToString: string; override;
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

function TSqlInsert.ToString: string;
begin
  Result := 'INSERT INTO ' + target + ' (' + columns.DelimitedText + ') VALUES (' + values.DelimitedText + ')';
end;

function TSqlInsert.Value(aColumn: string; aValue: TValue): ISqlInsert;
begin
  Result := Self;

  columns.Append(aColumn);
  values.Append(TSqlValue.ValueToSql(aValue));
end;

end.
