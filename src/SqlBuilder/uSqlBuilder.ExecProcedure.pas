unit uSqlBuilder.ExecProcedure;

interface

uses
  System.SysUtils, uSqlBuilder.Interfaces;

type
  TSqlExecProcedure = class(TInterfacedObject, ISqlExecProcedure)
  private
    fName: string;
    fInputList: string;

    procedure AddInput(aValue: string);
  public
    function &Procedure(aName: string): ISqlExecProcedure;

    function Value(aValue: Variant): ISqlExecProcedure;
    function ValueExpression(aExpression: string): ISqlExecProcedure;

    function ValueNull(aValue: string; aNullValue: string = ''): ISqlExecProcedure; overload;
    function ValueNull(aValue: Integer; aNullValue: Integer = 0): ISqlExecProcedure; overload;

    function Null: ISqlExecProcedure;

    function Date(aDate: TDate): ISqlExecProcedure;
    function Time(aTime: TTime): ISqlExecProcedure;
    function DateTime(aDateTime: TDateTime): ISqlExecProcedure;

    function CurrentDate: ISqlExecProcedure;
    function CurrentTime: ISqlExecProcedure;
    function CurrentTimestamp: ISqlExecProcedure;

    function ToString: string; override;
  end;

implementation

uses
  uSqlBuilder;

procedure TSqlExecProcedure.AddInput(aValue: string);
begin
  if not fInputList.IsEmpty then
    fInputList := fInputList + ', ';

  fInputList := fInputList + aValue;
end;

function TSqlExecProcedure.CurrentDate: ISqlExecProcedure;
begin
  Result := Self;
  AddInput('CURRENT_DATE');
end;

function TSqlExecProcedure.CurrentTime: ISqlExecProcedure;
begin
  Result := Self;
  AddInput('CURRENT_TIME');
end;

function TSqlExecProcedure.CurrentTimestamp: ISqlExecProcedure;
begin
  Result := Self;
  AddInput('CURRENT_TIMESTAMP');
end;

function TSqlExecProcedure.Date(aDate: TDate): ISqlExecProcedure;
begin
  Result := Self;
  AddInput(TSqlValue.ValueToSql(TSqlValue.AsDate(aDate)));
end;

function TSqlExecProcedure.DateTime(aDateTime: TDateTime): ISqlExecProcedure;
begin
  Result := Self;
  AddInput(TSqlValue.ValueToSql(TSqlValue.AsDateTime(aDateTime)));
end;

function TSqlExecProcedure.Null: ISqlExecProcedure;
begin
  Result := Self;
  AddInput('NULL');
end;

function TSqlExecProcedure.&Procedure(aName: string): ISqlExecProcedure;
begin
  Result := Self;
  fName := aName;
end;

function TSqlExecProcedure.Time(aTime: TTime): ISqlExecProcedure;
begin
  Result := Self;
  AddInput(TSqlValue.ValueToSql(TSqlValue.AsTime(aTime)));
end;

function TSqlExecProcedure.ToString: string;
begin
  Result := 'EXECUTE PROCEDURE ' + fName;

  if not fInputList.IsEmpty then
    Result := Result + ' (' + fInputList + ')';
end;

function TSqlExecProcedure.Value(aValue: Variant): ISqlExecProcedure;
begin
  Result := Self;
  AddInput(TSqlValue.ValueToSql(aValue));
end;

function TSqlExecProcedure.ValueExpression(aExpression: string): ISqlExecProcedure;
begin
  Result := Self;
  AddInput(aExpression);
end;

function TSqlExecProcedure.ValueNull(aValue, aNullValue: Integer): ISqlExecProcedure;
begin
  Result := Self;

  if aValue = aNullValue then
    AddInput('NULL')
  else
    AddInput(TSqlValue.ValueToSql(aValue));
end;

function TSqlExecProcedure.ValueNull(aValue, aNullValue: string): ISqlExecProcedure;
begin
  Result := Self;

  if aValue = aNullValue then
    AddInput('NULL')
  else
    AddInput(TSqlValue.ValueToSql(aValue));
end;

end.
