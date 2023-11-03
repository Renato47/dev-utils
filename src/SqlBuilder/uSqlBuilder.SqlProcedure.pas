unit uSqlBuilder.SqlProcedure;

interface

uses
  System.SysUtils, System.Rtti, uSqlBuilder.Interfaces;

type
  TSqlProcedure = class(TInterfacedObject, ISqlProcedure)
  private
    fName: string;
    fInputList: string;

    procedure AddInput(aValue: string);
  public
    function &Procedure(aName: string): ISqlProcedure;

    function Value(aValue: TValue): ISqlProcedure;
    function Null: ISqlProcedure;
    function CurrentDate: ISqlProcedure;
    function CurrentTime: ISqlProcedure;
    function CurrentTimestamp: ISqlProcedure;

    function ToString: string; override;
  end;

implementation

uses
  uSqlBuilder;

procedure TSqlProcedure.AddInput(aValue: string);
begin
  if not fInputList.IsEmpty then
    fInputList := fInputList + ', ';

  fInputList := fInputList + aValue;
end;

function TSqlProcedure.CurrentDate: ISqlProcedure;
begin
  Result := Self;
  AddInput('CURRENT_DATE');
end;

function TSqlProcedure.CurrentTimestamp: ISqlProcedure;
begin
  Result := Self;
  AddInput('CURRENT_TIMESTAMP');
end;

function TSqlProcedure.CurrentTime: ISqlProcedure;
begin
  Result := Self;
  AddInput('CURRENT_TIME');
end;

function TSqlProcedure.Null: ISqlProcedure;
begin
  Result := Self;
  AddInput('NULL');
end;

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
  AddInput(TSqlValue.ValueToSql(aValue));
end;

end.
