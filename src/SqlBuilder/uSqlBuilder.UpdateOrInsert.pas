unit uSqlBuilder.UpdateOrInsert;

interface

uses
  System.Classes, System.Rtti, uSqlBuilder.Interfaces;

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
    function Matching(aColumnList: string): ISqlUpdateOrInsert;

    function ToString: string; override;
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

end.
