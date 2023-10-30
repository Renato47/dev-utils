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

    function Name(aName: string): ISqlProcedureCreate;
    function Input(aName, aType: string): ISqlProcedureCreate;
    function Return(aName, aType: string): ISqlProcedureCreate;
    function Variable(aName, aType: string): ISqlProcedureCreate;
    function Instruction(aSqlInstruction: string): ISqlProcedureCreate;

    function ToString: string; override;
  end;

implementation

constructor TSqlCreateProcedure.Create;
begin
  inputList := TStringList.Create;
  inputList.QuoteChar := #0;
  inputList.StrictDelimiter := True;

  returnList := TStringList.Create;
  returnList.QuoteChar := #0;
  returnList.StrictDelimiter := True;

  variableList := TStringList.Create;
  instructions := TStringList.Create;
end;

destructor TSqlCreateProcedure.Destroy;
begin
  inputList.Free;
  returnList.Free;
  variableList.Free;
  instructions.Free;

  inherited;
end;

function TSqlCreateProcedure.Input(aName, aType: string): ISqlProcedureCreate;
begin
  Result := Self;
  inputList.Append(aName + ' ' + aType);
end;

function TSqlCreateProcedure.Instruction(aSqlInstruction: string): ISqlProcedureCreate;
begin
  Result := Self;
  instructions.Append(aSqlInstruction);
end;

function TSqlCreateProcedure.Name(aName: string): ISqlProcedureCreate;
begin
  Result := Self;
  fName := aName;
end;

function TSqlCreateProcedure.Return(aName, aType: string): ISqlProcedureCreate;
begin
  Result := Self;
  returnList.Append(aName + ' ' + aType);
end;

function TSqlCreateProcedure.ToString: string;
var
  slSql: TStringList;
begin
  slSql := TStringList.Create;

  slSql.Append('SET TERM ^ ;');
  slSql.Append('');
  slSql.Append('CREATE OR ALTER PROCEDURE ' + fName);

  if inputList.Count <> 0 then begin
    slSql.Append('(');
    slSql.Append(inputList.DelimitedText);
    slSql.Append(')');
  end;

  if returnList.Count <> 0 then begin
    slSql.Append('RETURNS (');
    slSql.Append(returnList.DelimitedText);
    slSql.Append(')');
  end;

  slSql.Append('AS');
  slSql.Append(variableList.Text);
  slSql.Append('BEGIN');
  slSql.Append(instructions.Text);
  slSql.Append('END^');
  slSql.Append('');
  slSql.Append('SET TERM ; ^');

  Result := slSql.Text;
  slSql.Free;
end;

function TSqlCreateProcedure.Variable(aName, aType: string): ISqlProcedureCreate;
begin
  Result := Self;
  variableList.Append('DECLARE VARIABLE ' + aName + ' ' + aType + ';');
end;

end.
