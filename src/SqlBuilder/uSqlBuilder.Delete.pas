unit uSqlBuilder.Delete;

interface

uses
  uSqlBuilder.Interfaces;

type
  TSqlDelete = class(TInterfacedObject, ISqlDelete)
  private
    fTarget: string;
    fConditions: string;
  public
    function from(target: string): ISqlDelete;

    function where(conditions: string): ISqlDelete; overload;
    function where(sqlWhere: ISqlWhere): ISqlDelete; overload;

    function toStr: string;
  end;

implementation

uses
  System.SysUtils;

function TSqlDelete.from(target: string): ISqlDelete;
begin
  result := self;
  fTarget := target;
end;

function TSqlDelete.toStr: string;
begin
  result := 'DELETE FROM ' + fTarget;

  if not fConditions.isEmpty then
    result := result + ' WHERE ' + fConditions;
end;

function TSqlDelete.where(conditions: string): ISqlDelete;
begin
  result := self;
  fConditions := conditions;
end;

function TSqlDelete.where(sqlWhere: ISqlWhere): ISqlDelete;
begin
  result := where(sqlWhere.toStr);
end;

end.
