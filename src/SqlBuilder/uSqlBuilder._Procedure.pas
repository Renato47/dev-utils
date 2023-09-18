unit uSqlBuilder._Procedure;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  TSqlProcedure = class(TInterfacedObject, ISqlProcedure)
  private
    fName: string;
    inputList: TStringList;
    returnList: TStringList;
    variableList: TStringList;
    instructions: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    function Name(aName: string): ISqlProcedure;
    function Input(aName, aType: string): ISqlProcedure;
    function Return(aName, aType: string): ISqlProcedure;
    function Variable(aName, aType: string): ISqlProcedure;
    function Instruction(aSqlInstruction: string): ISqlProcedure;

    function ToString: string; override;
  end;

implementation

constructor TSqlProcedure.Create;
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

destructor TSqlProcedure.Destroy;
begin
  inputList.Free;
  returnList.Free;
  variableList.Free;
  instructions.Free;

  inherited;
end;

function TSqlProcedure.Input(aName, aType: string): ISqlProcedure;
begin
  Result := Self;
  inputList.Append(aName + ' ' + aType);
end;

function TSqlProcedure.Instruction(aSqlInstruction: string): ISqlProcedure;
begin
  Result := Self;
  instructions.Append(aSqlInstruction);
end;

function TSqlProcedure.Name(aName: string): ISqlProcedure;
begin
  Result := Self;
  fName := aName;
end;

function TSqlProcedure.Return(aName, aType: string): ISqlProcedure;
begin
  Result := Self;
  returnList.Append(aName + ' ' + aType);
end;

function TSqlProcedure.ToString: string;
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

function TSqlProcedure.Variable(aName, aType: string): ISqlProcedure;
begin
  Result := Self;
  variableList.Append('DECLARE VARIABLE ' + aName + ' ' + aType + ';');
end;

end.
