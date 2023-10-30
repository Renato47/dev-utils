unit uSqlBuilder.ExecProcedure;

interface

uses
  System.SysUtils, System.Rtti, uSqlBuilder.Interfaces;

type
  TSqlExecProcedure = class(TInterfacedObject, ISqlExecProcedure)
  private
    fName: string;
    fInputList: string;
  public
    function &Procedure(aName: string): ISqlExecProcedure;
    function Value(aValue: TValue): ISqlExecProcedure;

    function ToString: string; override;
  end;

implementation

uses
  uSqlBuilder;

function TSqlExecProcedure.&Procedure(aName: string): ISqlExecProcedure;
begin
  Result := Self;
  fName := aName;
end;

function TSqlExecProcedure.ToString: string;
begin
  Result := 'EXECUTE PROCEDURE ' + fName;

  if not fInputList.IsEmpty then
    Result := Result + ' (' + fInputList + ')';
end;

function TSqlExecProcedure.Value(aValue: TValue): ISqlExecProcedure;
begin
  Result := Self;

  if not fInputList.IsEmpty then
    fInputList := fInputList + ', ';

  fInputList := fInputList + TSqlValue.ValueToSql(aValue);
end;

end.
