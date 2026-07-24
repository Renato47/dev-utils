unit uSqlBuilder.CreateProcedure;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  TSqlCreateProcedure = class(TInterfacedObject, ISqlProcedureCreate)
  private
    fName: string;
    inputList: TStringList;
    returnList: TStringList;
    variableList: TStringList;
    instructions: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    function name(name: string): ISqlProcedureCreate;
    function input(name, type_: string): ISqlProcedureCreate;
    function return(name, type_: string): ISqlProcedureCreate;
    function variable(name, type_: string): ISqlProcedureCreate;
    function instruction(sqlInstruction: string): ISqlProcedureCreate;

    function toStr: string;
  end;

implementation

constructor TSqlCreateProcedure.Create;
begin
  inputList := TStringList.Create;
  inputList.quoteChar := #0;
  inputList.strictDelimiter := true;

  returnList := TStringList.Create;
  returnList.quoteChar := #0;
  returnList.strictDelimiter := true;

  variableList := TStringList.Create;
  instructions := TStringList.Create;
end;

destructor TSqlCreateProcedure.Destroy;
begin
  inputList.free;
  returnList.free;
  variableList.free;
  instructions.free;

  inherited;
end;

function TSqlCreateProcedure.input(name, type_: string): ISqlProcedureCreate;
begin
  result := self;
  inputList.append(name + ' ' + type_);
end;

function TSqlCreateProcedure.instruction(sqlInstruction: string): ISqlProcedureCreate;
begin
  result := self;
  instructions.append(sqlInstruction);
end;

function TSqlCreateProcedure.name(name: string): ISqlProcedureCreate;
begin
  result := self;
  fName := name;
end;

function TSqlCreateProcedure.return(name, type_: string): ISqlProcedureCreate;
begin
  result := self;
  returnList.append(name + ' ' + type_);
end;

function TSqlCreateProcedure.toStr: string;
var
  slSql: TStringList;
begin
  slSql := TStringList.Create;

  slSql.append('SET TERM ^ ;');
  slSql.append('');
  slSql.append('CREATE OR ALTER PROCEDURE ' + fName);

  if inputList.count <> 0 then begin
    slSql.append('(');
    slSql.append(inputList.delimitedText);
    slSql.append(')');
  end;

  if returnList.count <> 0 then begin
    slSql.append('RETURNS (');
    slSql.append(returnList.delimitedText);
    slSql.append(')');
  end;

  slSql.append('AS');
  slSql.append(variableList.text);
  slSql.append('BEGIN');
  slSql.append(instructions.text);
  slSql.append('END^');
  slSql.append('');
  slSql.append('SET TERM ; ^');

  result := slSql.text;
  slSql.free;
end;

function TSqlCreateProcedure.variable(name, type_: string): ISqlProcedureCreate;
begin
  result := self;
  variableList.append('DECLARE VARIABLE ' + name + ' ' + type_ + ';');
end;

end.
