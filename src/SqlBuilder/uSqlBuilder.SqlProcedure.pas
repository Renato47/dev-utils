unit uSqlBuilder.SqlProcedure;

interface

uses
  System.SysUtils, System.Rtti, uSqlBuilder.Interfaces;

type
  TSqlProcedure = class(TInterfacedObject, ISqlProcedure)
  private
    fName: string;
    fInputList: string;
  public
    function &Procedure(aName: string): ISqlProcedure;
    function Value(aValue: TValue): ISqlProcedure;

    function ToString: string; override;
  end;

implementation

uses
  uSqlBuilder;

function TSqlProcedure.&Procedure(aName: string): ISqlProcedure;
begin
  Result := Self;
  fName := aName;
end;

function TSqlProcedure.ToString: string;
begin
  Result := fName + ' (' + fInputList + ')';
end;

function TSqlProcedure.Value(aValue: TValue): ISqlProcedure;
begin
  Result := Self;

  if not fInputList.IsEmpty then
    fInputList := fInputList + ', ';

  fInputList := fInputList + TSqlValue.ValueToSql(aValue);
end;

end.
