unit uSqlBuilder.SqlProcedure;

interface

uses
  System.SysUtils, uSqlBuilder.Interfaces;

type
  TSqlProcedure = class(TInterfacedObject, ISqlProcedure)
  private
    fName: string;
    fInputList: string;

    procedure addInput(value: string);
  public
    function &procedure(name: string): ISqlProcedure;

    function value(value: variant): ISqlProcedure;
    function valueExpression(expression: string): ISqlProcedure;

    function valueNull(value: string; nullValue: string = ''): ISqlProcedure; overload;
    function valueNull(value: integer; nullValue: integer = 0): ISqlProcedure; overload;

    function null: ISqlProcedure;

    function date(value: TDate): ISqlProcedure;
    function time(value: TTime): ISqlProcedure;
    function dateTime(value: TDateTime): ISqlProcedure;

    function currentDate: ISqlProcedure;
    function currentTime: ISqlProcedure;
    function currentTimestamp: ISqlProcedure;

    function toStr: string;
  end;

implementation

uses
  uSqlBuilder;

procedure TSqlProcedure.addInput(value: string);
begin
  if not fInputList.isEmpty then
    fInputList := fInputList + ', ';

  fInputList := fInputList + value;
end;

function TSqlProcedure.currentDate: ISqlProcedure;
begin
  result := self;
  addInput('CURRENT_DATE');
end;

function TSqlProcedure.currentTimestamp: ISqlProcedure;
begin
  result := self;
  addInput('CURRENT_TIMESTAMP');
end;

function TSqlProcedure.date(value: TDate): ISqlProcedure;
begin
  result := self;
  addInput(TSqlValue.valueToSql(TSqlValue.asDate(value)));
end;

function TSqlProcedure.dateTime(value: TDateTime): ISqlProcedure;
begin
  result := self;
  addInput(TSqlValue.valueToSql(TSqlValue.asDateTime(value)));
end;

function TSqlProcedure.currentTime: ISqlProcedure;
begin
  result := self;
  addInput('CURRENT_TIME');
end;

function TSqlProcedure.null: ISqlProcedure;
begin
  result := self;
  addInput('NULL');
end;

function TSqlProcedure.&procedure(name: string): ISqlProcedure;
begin
  result := self;
  fName := name;
end;

function TSqlProcedure.time(value: TTime): ISqlProcedure;
begin
  result := self;
  addInput(TSqlValue.valueToSql(TSqlValue.asTime(value)));
end;

function TSqlProcedure.toStr: string;
begin
  result := fName + ' (' + fInputList + ')';
end;

function TSqlProcedure.value(value: variant): ISqlProcedure;
begin
  result := self;
  addInput(TSqlValue.valueToSql(value));
end;

function TSqlProcedure.valueExpression(expression: string): ISqlProcedure;
begin
  result := self;
  addInput(expression);
end;

function TSqlProcedure.valueNull(value, nullValue: string): ISqlProcedure;
begin
  result := self;

  if value = nullValue then
    addInput('NULL')
  else
    addInput(TSqlValue.valueToSql(value));
end;

function TSqlProcedure.valueNull(value, nullValue: integer): ISqlProcedure;
begin
  result := self;

  if value = nullValue then
    addInput('NULL')
  else
    addInput(TSqlValue.valueToSql(value));
end;

end.
