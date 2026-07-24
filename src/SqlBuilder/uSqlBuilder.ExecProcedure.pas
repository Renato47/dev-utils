unit uSqlBuilder.ExecProcedure;

interface

uses
  System.SysUtils, uSqlBuilder.Interfaces;

type
  TSqlExecProcedure = class(TInterfacedObject, ISqlExecProcedure)
  private
    fName: string;
    fInputList: string;

    procedure addInput(value: string);
  public
    function &procedure(name: string): ISqlExecProcedure;

    function value(value: variant): ISqlExecProcedure;
    function valueExpression(expression: string): ISqlExecProcedure;

    function valueNull(value: string; nullValue: string = ''): ISqlExecProcedure; overload;
    function valueNull(value: integer; nullValue: integer = 0): ISqlExecProcedure; overload;

    function null: ISqlExecProcedure;

    function date(value: TDate): ISqlExecProcedure;
    function time(value: TTime): ISqlExecProcedure;
    function dateTime(value: TDateTime): ISqlExecProcedure;

    function currentDate: ISqlExecProcedure;
    function currentTime: ISqlExecProcedure;
    function currentTimestamp: ISqlExecProcedure;

    function toStr: string;
  end;

implementation

uses
  uSqlBuilder;

procedure TSqlExecProcedure.addInput(value: string);
begin
  if not fInputList.isEmpty then
    fInputList := fInputList + ', ';

  fInputList := fInputList + value;
end;

function TSqlExecProcedure.currentDate: ISqlExecProcedure;
begin
  result := self;
  addInput('CURRENT_DATE');
end;

function TSqlExecProcedure.currentTime: ISqlExecProcedure;
begin
  result := self;
  addInput('CURRENT_TIME');
end;

function TSqlExecProcedure.currentTimestamp: ISqlExecProcedure;
begin
  result := self;
  addInput('CURRENT_TIMESTAMP');
end;

function TSqlExecProcedure.date(value: TDate): ISqlExecProcedure;
begin
  result := self;
  addInput(TSqlValue.valueToSql(TSqlValue.asDate(value)));
end;

function TSqlExecProcedure.dateTime(value: TDateTime): ISqlExecProcedure;
begin
  result := self;
  addInput(TSqlValue.valueToSql(TSqlValue.asDateTime(value)));
end;

function TSqlExecProcedure.null: ISqlExecProcedure;
begin
  result := self;
  addInput('NULL');
end;

function TSqlExecProcedure.&procedure(name: string): ISqlExecProcedure;
begin
  result := self;
  fName := name;
end;

function TSqlExecProcedure.time(value: TTime): ISqlExecProcedure;
begin
  result := self;
  addInput(TSqlValue.valueToSql(TSqlValue.asTime(value)));
end;

function TSqlExecProcedure.toStr: string;
begin
  result := 'EXECUTE PROCEDURE ' + fName;

  if not fInputList.isEmpty then
    result := result + ' (' + fInputList + ')';
end;

function TSqlExecProcedure.value(value: variant): ISqlExecProcedure;
begin
  result := self;
  addInput(TSqlValue.valueToSql(value));
end;

function TSqlExecProcedure.valueExpression(expression: string): ISqlExecProcedure;
begin
  result := self;
  addInput(expression);
end;

function TSqlExecProcedure.valueNull(value, nullValue: integer): ISqlExecProcedure;
begin
  result := self;

  if value = nullValue then
    addInput('NULL')
  else
    addInput(TSqlValue.valueToSql(value));
end;

function TSqlExecProcedure.valueNull(value, nullValue: string): ISqlExecProcedure;
begin
  result := self;

  if value = nullValue then
    addInput('NULL')
  else
    addInput(TSqlValue.valueToSql(value));
end;

end.
