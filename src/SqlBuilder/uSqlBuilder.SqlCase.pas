unit uSqlBuilder.SqlCase;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  TSqlCase = class(TInterfacedObject, ISqlCase)
  private
    fExpression: string;
    fWhenThenList: TStringList;
    fAlias: string;
  public
    constructor Create;
    destructor Destroy; override;

    function testExpression(expression: string): ISqlCase;

    function whenThenColumn(condition, column: string): ISqlCase;
    function whenThen(condition: string; value: variant): ISqlCase;
    function elseColumn(column: string): ISqlCase;
    function &else(value: variant): ISqlCase;

    function &as(alias: string): ISqlCase;

    function toStr: string;
  end;

implementation

uses
  System.SysUtils, uSqlBuilder;

constructor TSqlCase.Create;
begin
  fWhenThenList := TStringList.Create;
end;

destructor TSqlCase.Destroy;
begin
  fWhenThenList.free;

  inherited;
end;

function TSqlCase.&else(value: variant): ISqlCase;
begin
  result := self;
  fWhenThenList.append(' ELSE ' + TSqlValue.valueToSql(value));
end;

function TSqlCase.elseColumn(column: string): ISqlCase;
begin
  result := self;
  fWhenThenList.append(' ELSE ' + column);
end;

function TSqlCase.&as(alias: string): ISqlCase;
begin
  result := self;
  fAlias := alias;
end;

function TSqlCase.testExpression(expression: string): ISqlCase;
begin
  result := self;
  fExpression := ' ' + expression;
end;

function TSqlCase.toStr: string;
begin
  result := 'CASE' + fExpression + fWhenThenList.text.replace(sLineBreak, '') + ' END';

  if not fAlias.isEmpty then
    result := result + ' AS ' + fAlias;
end;

function TSqlCase.whenThen(condition: string; value: variant): ISqlCase;
begin
  result := self;
  fWhenThenList.append(' WHEN ' + condition + ' THEN ' + TSqlValue.valueToSql(value));
end;

function TSqlCase.whenThenColumn(condition, column: string): ISqlCase;
begin
  result := self;
  fWhenThenList.append(' WHEN ' + condition + ' THEN ' + column);
end;

end.
