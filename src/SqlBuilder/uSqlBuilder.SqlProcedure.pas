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
    function ValueExpression(aExpression: string): ISqlProcedure;

    function ValueNull(aValue: string; aNullValue: string = ''): ISqlProcedure; overload;
    function ValueNull(aValue: Integer; aNullValue: Integer = 0): ISqlProcedure; overload;

    function Null: ISqlProcedure;

    function Date(aDate: TDate): ISqlProcedure;
    function Time(aTime: TTime): ISqlProcedure;
    function DateTime(aDateTime: TDateTime): ISqlProcedure;

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

function TSqlProcedure.Date(aDate: TDate): ISqlProcedure;
begin
  Result := Self;
  AddInput(TSqlValue.AsDate(aDate).QuotedString);
end;

function TSqlProcedure.DateTime(aDateTime: TDateTime): ISqlProcedure;
begin
  Result := Self;
  AddInput(TSqlValue.AsDateTime(aDateTime).QuotedString);
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

function TSqlProcedure.Time(aTime: TTime): ISqlProcedure;
begin
  Result := Self;
  AddInput(TSqlValue.AsTime(aTime).QuotedString);
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

function TSqlProcedure.ValueExpression(aExpression: string): ISqlProcedure;
begin
  Result := Self;
  AddInput(aExpression);
end;

function TSqlProcedure.ValueNull(aValue, aNullValue: string): ISqlProcedure;
begin
  Result := Self;

  if aValue = aNullValue then
    AddInput('NULL')
  else
    AddInput(TSqlValue.ValueToSql(aValue));
end;

function TSqlProcedure.ValueNull(aValue, aNullValue: Integer): ISqlProcedure;
begin
  Result := Self;

  if aValue = aNullValue then
    AddInput('NULL')
  else
    AddInput(TSqlValue.ValueToSql(aValue));
end;

end.
