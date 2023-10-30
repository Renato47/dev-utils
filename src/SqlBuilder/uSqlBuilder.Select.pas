unit uSqlBuilder.Select;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  TSqlSelect = class(TInterfacedObject, ISqlSelect)
  private
    columns: TStringList;
    source: string;
    firstRows: string;
    skipRows: string;
    sDistinct: string;
    joinList: TStringList;
    conditions: string;
    groupList: string;
    aggregateCondition: string;
    orderList: string;
  public
    constructor Create;
    destructor Destroy; override;

    function AllColumns: ISqlSelect;
    function Column(aName: string): ISqlSelect; overload;
    function Column(aCase: ISqlCase): ISqlSelect; overload;

    function Cast(aAsType, aAlias: string): ISqlSelect;

    function From(aSource: string): ISqlSelect; overload;
    function From(aSelect: ISqlSelect; aAlias: string): ISqlSelect; overload;
    function From(aSqlProcedure: ISqlProcedure; aAlias: string = ''): ISqlSelect; overload;

    function InnerJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect; overload;
    function InnerJoin(aSource, aConditions: string): ISqlSelect; overload;
    function LeftJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect; overload;
    function LeftJoin(aSource, aConditions: string): ISqlSelect; overload;
    function RightJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect; overload;
    function RightJoin(aSource, aConditions: string): ISqlSelect; overload;

    function Where(aConditions: string): ISqlSelect; overload;
    function Where(aSqlWhere: ISqlWhere): ISqlSelect; overload;
    function GroupBy(aGroup: string): ISqlSelect;
    function Having(aAggregateCondition: string): ISqlSelect;
    function OrderBy(aOrder: string): ISqlSelect;

    function First(aCount: Integer): ISqlSelect;
    function Skip(aCount: Integer): ISqlSelect;
    function Distinct: ISqlSelect;

    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils;

function TSqlSelect.AllColumns: ISqlSelect;
begin
  Result := Self;
  columns.Append('*');
end;

function TSqlSelect.Column(aName: string): ISqlSelect;
begin
  Result := Self;
  columns.Append(aName);
end;

function TSqlSelect.Cast(aAsType, aAlias: string): ISqlSelect;
begin
  Result := Self;

  if columns.Count = 0 then
    Exit;

  columns.Strings[Pred(columns.Count)] := 'CAST(' + columns.Strings[Pred(columns.Count)] + ' AS ' + aAsType + ') AS ' + aAlias;
end;

function TSqlSelect.Column(aCase: ISqlCase): ISqlSelect;
begin
  Result := Self;
  columns.Append(aCase.ToString);
end;

constructor TSqlSelect.Create;
begin
  columns := TStringList.Create;
  columns.QuoteChar := #0;
  columns.StrictDelimiter := True;

  joinList := TStringList.Create;
  joinList.QuoteChar := #0;
  joinList.StrictDelimiter := True;
end;

destructor TSqlSelect.Destroy;
begin
  columns.Free;
  joinList.Free;

  inherited;
end;

function TSqlSelect.Distinct: ISqlSelect;
begin
  Result := Self;
  sDistinct := 'DISTINCT ';
end;

function TSqlSelect.First(aCount: Integer): ISqlSelect;
begin
  Result := Self;

  if aCount > 0 then
    firstRows := 'FIRST ' + IntToStr(aCount) + ' ';
end;

function TSqlSelect.From(aSqlProcedure: ISqlProcedure; aAlias: string): ISqlSelect;
begin
  Result := Self;

  if not aAlias.IsEmpty then
    source := aSqlProcedure.ToString + ' ' + aAlias
  else
    source := aSqlProcedure.ToString;
end;

function TSqlSelect.From(aSelect: ISqlSelect; aAlias: string): ISqlSelect;
begin
  Result := Self;
  source := '(' + aSelect.ToString + ') AS ' + aAlias;
end;

function TSqlSelect.From(aSource: string): ISqlSelect;
begin
  Result := Self;
  source := aSource;
end;

function TSqlSelect.GroupBy(aGroup: string): ISqlSelect;
begin
  Result := Self;

  if groupList.IsEmpty then
    groupList := ' GROUP BY ' + aGroup
  else
    groupList := groupList + ', ' + aGroup;
end;

function TSqlSelect.Having(aAggregateCondition: string): ISqlSelect;
begin
  Result := Self;
  aggregateCondition := ' HAVING ' + aAggregateCondition;
end;

function TSqlSelect.InnerJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect;
begin
  Result := Self;
  InnerJoin('(' + aSelect.ToString + ') ' + aAlias, aConditions);
end;

function TSqlSelect.InnerJoin(aSource, aConditions: string): ISqlSelect;
begin
  Result := Self;
  joinList.Append(' INNER JOIN ' + aSource + ' ON ' + aConditions);
end;

function TSqlSelect.LeftJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect;
begin
  Result := Self;
  LeftJoin('(' + aSelect.ToString + ') ' + aAlias, aConditions);
end;

function TSqlSelect.LeftJoin(aSource, aConditions: string): ISqlSelect;
begin
  Result := Self;
  joinList.Append(' LEFT JOIN ' + aSource + ' ON ' + aConditions);
end;

function TSqlSelect.OrderBy(aOrder: string): ISqlSelect;
begin
  Result := Self;

  if orderList.IsEmpty then
    orderList := ' ORDER BY ' + aOrder
  else
    orderList := orderList + ', ' + aOrder;
end;

function TSqlSelect.RightJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect;
begin
  Result := Self;
  RightJoin('(' + aSelect.ToString + ') ' + aAlias, aConditions);
end;

function TSqlSelect.RightJoin(aSource, aConditions: string): ISqlSelect;
begin
  Result := Self;
  joinList.Append(' RIGHT JOIN ' + aSource + ' ON ' + aConditions);
end;

function TSqlSelect.Skip(aCount: Integer): ISqlSelect;
begin
  Result := Self;

  if aCount > 0 then
    skipRows := 'SKIP ' + IntToStr(aCount) + ' ';
end;

function TSqlSelect.ToString: string;
begin
  Result :=
    'SELECT ' +
    firstRows + skipRows + sDistinct + columns.DelimitedText +
    ' FROM ' + source +
    joinList.Text.Replace(sLineBreak, '') +
    conditions +
    groupList +
    aggregateCondition +
    orderList;
end;

function TSqlSelect.Where(aSqlWhere: ISqlWhere): ISqlSelect;
begin
  Result := Where(aSqlWhere.ToString);
end;

function TSqlSelect.Where(aConditions: string): ISqlSelect;
begin
  Result := Self;
  conditions := ' WHERE ' + aConditions;
end;

end.
