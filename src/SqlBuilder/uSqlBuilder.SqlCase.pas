unit uSqlBuilder.SqlCase;

interface

uses
  System.Classes, System.Rtti, uSqlBuilder.Interfaces;

type
  TSqlCase = class(TInterfacedObject, ISqlCase)
  private
    expression: string;
    whenThenList: TStringList;
    alias: string;
  public
    constructor Create;
    destructor Destroy; override;

    function TestExpression(aExpression: string): ISqlCase;

    function WhenThenColumn(aCondition, aColumn: string): ISqlCase;
    function WhenThen(aCondition: string; aResult: TValue): ISqlCase;
    function ElseColumn(aColumn: string): ISqlCase;
    function &Else(aResult: TValue): ISqlCase;

    function &As(aAlias: string): ISqlCase;

    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils, uSqlBuilder;

constructor TSqlCase.Create;
begin
  whenThenList := TStringList.Create;
end;

destructor TSqlCase.Destroy;
begin
  whenThenList.Free;

  inherited;
end;

function TSqlCase.&Else(aResult: TValue): ISqlCase;
begin
  Result := Self;
  whenThenList.Append(' ELSE ' + TSqlValue.ValueToSql(aResult));
end;

function TSqlCase.ElseColumn(aColumn: string): ISqlCase;
begin
  Result := Self;
  whenThenList.Append(' ELSE ' + aColumn);
end;

function TSqlCase.&As(aAlias: string): ISqlCase;
begin
  Result := Self;
  alias := aAlias;
end;

function TSqlCase.TestExpression(aExpression: string): ISqlCase;
begin
  Result := Self;
  expression := ' ' + aExpression;
end;

function TSqlCase.ToString: string;
begin
  Result := 'CASE' + expression + whenThenList.Text.Replace(sLineBreak, '') + ' END';

  if not alias.IsEmpty then
    Result := Result + ' AS ' + alias;
end;

function TSqlCase.WhenThen(aCondition: string; aResult: TValue): ISqlCase;
begin
  Result := Self;
  whenThenList.Append(' WHEN ' + aCondition + ' THEN ' + TSqlValue.ValueToSql(aResult));
end;

function TSqlCase.WhenThenColumn(aCondition, aColumn: string): ISqlCase;
begin
  Result := Self;
  whenThenList.Append(' WHEN ' + aCondition + ' THEN ' + aColumn);
end;

end.
