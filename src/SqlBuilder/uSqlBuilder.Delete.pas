unit uSqlBuilder.Delete;

interface

uses
  uSqlBuilder.Interfaces;

type
  TSqlDelete = class(TInterfacedObject, ISqlDelete)
  private
    target: string;
    conditions: string;
  public
    function From(aTarget: string): ISqlDelete;

    function Where(aConditions: string): ISqlDelete; overload;
    function Where(aWhere: ISqlWhere): ISqlDelete; overload;

    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils;

function TSqlDelete.From(aTarget: string): ISqlDelete;
begin
  Result := Self;
  target := aTarget;
end;

function TSqlDelete.ToString: string;
begin
  Result := 'DELETE FROM ' + target;

  if not conditions.IsEmpty then
    Result := Result + ' WHERE ' + conditions;
end;

function TSqlDelete.Where(aConditions: string): ISqlDelete;
begin
  Result := Self;
  conditions := aConditions;
end;

function TSqlDelete.Where(aWhere: ISqlWhere): ISqlDelete;
begin
  Result := Where(aWhere.ToString);
end;

end.
