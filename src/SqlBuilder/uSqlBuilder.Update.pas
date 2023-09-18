unit uSqlBuilder.Update;

interface

uses
  System.Classes, System.Rtti, uSqlBuilder.Interfaces;

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

    function Value(aColumn: string; aValue: TValue): ISqlUpdate;

    function Where(aConditions: string): ISqlUpdate; overload;
    function Where(aWhere: ISqlWhere): ISqlUpdate; overload;

    function ToString: string; override;
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

function TSqlUpdate.Table(aTarget: string): ISqlUpdate;
begin
  Result := Self;
  target := aTarget;
end;

function TSqlUpdate.ToString: string;
begin
  Result := 'UPDATE ' + target + ' SET ' + columnsValues.DelimitedText + ' WHERE ' + conditions;
end;

function TSqlUpdate.Value(aColumn: string; aValue: TValue): ISqlUpdate;
begin
  Result := Self;
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
