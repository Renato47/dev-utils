unit uSqlBuilder.Where;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  TSqlWhere = class(TInterfacedObject, ISqlWhere)
  private
    fComparisonOperator: string;
    fColumn: string;
    fLogicalOperator: string;
    conditionList: TStringList;

    procedure AddCondition(aCriteria: string);
    procedure AddParenthesesCondition(aCriteria: string);
    function ConcatArray(aArry: TArray<string>): string; overload;
    function ConcatArray(aArry: TArray<Integer>): string; overload;
  public
    constructor Create;
    destructor Destroy; override;

    //Column name
    function Column(aColumn: string): ISqlWhere;

    //Logical Operators [NOT, AND, OR]
    function &Or(aColumn: string): ISqlWhere; overload;
    function &Or(aSqlWhere: ISqlWhere): ISqlWhere; overload;
    function &And(aSqlWhere: ISqlWhere): ISqlWhere;

    //Comparison operators [=, <>, <, <=, >, >=, ...]
    function Equal: ISqlWhere; overload;
    function Equal(aValue: Variant): ISqlWhere; overload;
    function Different: ISqlWhere; overload;
    function Different(aValue: Variant): ISqlWhere; overload;

    function Less: ISqlWhere; overload;
    function Less(aValue: Variant): ISqlWhere; overload;
    function LessOrEqual: ISqlWhere; overload;
    function LessOrEqual(aValue: Variant): ISqlWhere; overload;

    function Greater: ISqlWhere; overload;
    function Greater(aValue: Variant): ISqlWhere; overload;
    function GreaterOrEqual: ISqlWhere; overload;
    function GreaterOrEqual(aValue: Variant): ISqlWhere; overload;

    //Comparison predicates [LIKE, STARTING WITH, CONTAINING, SIMILAR TO, BETWEEN, IS [NOT] NULL, IS [NOT] DISTINCT FROM]
    function Like(aValue: string): ISqlWhere;
    function NotLike(aValue: string): ISqlWhere;
    function LikeSplit(aValue: string): ISqlWhere;

    function StartingWith(aValue: string): ISqlWhere;
    function Containing(aValue: string): ISqlWhere;

    function IsNull: ISqlWhere;
    function IsNotNull: ISqlWhere;

    function Between(aStart, aEnd: Variant): ISqlWhere;
    function BetweenDate(aStart, aEnd: TDate): ISqlWhere;
    function BetweenTime(aStart, aEnd: TTime): ISqlWhere;
    function BetweenDateTime(aStart, aEnd: TDateTime): ISqlWhere;
    function NotBetween(aStart, aEnd: Variant): ISqlWhere;
    function NotBetweenDate(aStart, aEnd: TDate): ISqlWhere;
    function NotBetweenTime(aStart, aEnd: TTime): ISqlWhere;
    function NotBetweenDateTime(aStart, aEnd: TDateTime): ISqlWhere;

    //Existential predicates [IN, EXISTS, SINGULAR, ALL, ANY, SOME]
    function &In(aValues: TArray<string>): ISqlWhere; overload;
    function &In(aValues: TArray<Integer>): ISqlWhere; overload;
    function &In(aSelect: ISqlSelect): ISqlWhere; overload;
    function NotIn(aValues: TArray<string>): ISqlWhere; overload;
    function NotIn(aValues: TArray<Integer>): ISqlWhere; overload;

    function Exists(aSelect: ISqlSelect): ISqlWhere;
    function NotExists(aSelect: ISqlSelect): ISqlWhere;
    function OrExists(aSelect: ISqlSelect): ISqlWhere;
    function OrNotExists(aSelect: ISqlSelect): ISqlWhere;

    //Date/time literal ['TODAY', 'NOW', '25.12.2016 15:30:35']
    function Date(aDate: TDate): ISqlWhere;
    function Time(aTime: TTime): ISqlWhere;
    function DateTime(aDateTime: TDateTime): ISqlWhere;

    //Context Variables
    function CurrentDate: ISqlWhere;
    function CurrentTime: ISqlWhere;
    function CurrentTimestamp: ISqlWhere;

    function ToString: string; override;
    function IsEmpty: Boolean;
  end;

implementation

uses
  System.SysUtils, uSqlBuilder;

function TSqlWhere.&Or(aColumn: string): ISqlWhere;
begin
  Result := Self;
  fColumn := aColumn;
  fLogicalOperator := ' OR ';
end;

function TSqlWhere.&In(aValues: TArray<string>): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' IN (' + ConcatArray(aValues) + ')');
end;

function TSqlWhere.&In(aValues: TArray<Integer>): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' IN (' + ConcatArray(aValues) + ')');
end;

function TSqlWhere.&In(aSelect: ISqlSelect): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' IN (' + aSelect.ToString + ')');
end;

procedure TSqlWhere.AddCondition(aCriteria: string);
begin
  if not conditionList.Text.IsEmpty then
    conditionList.Append(fLogicalOperator);

  conditionList.Append(aCriteria);

  fLogicalOperator := '';
  fColumn := '';
  fComparisonOperator := '';
end;

procedure TSqlWhere.AddParenthesesCondition(aCriteria: string);
begin
  if not conditionList.Text.IsEmpty then
    conditionList.Append(fLogicalOperator);

  conditionList.Append('(' + aCriteria + ')');

  fLogicalOperator := '';
end;

function TSqlWhere.&And(aSqlWhere: ISqlWhere): ISqlWhere;
begin
  Result := Self;
  fLogicalOperator := ' AND ';
  AddParenthesesCondition(aSqlWhere.ToString);
end;

function TSqlWhere.Between(aStart, aEnd: Variant): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' BETWEEN ' + TSqlValue.ValueToSql(aStart) + ' AND ' + TSqlValue.ValueToSql(aEnd));
end;

function TSqlWhere.BetweenDate(aStart, aEnd: TDate): ISqlWhere;
begin
  Result := Between(TSqlValue.AsDate(aStart), TSqlValue.AsDate(aEnd));
end;

function TSqlWhere.BetweenDateTime(aStart, aEnd: TDateTime): ISqlWhere;
begin
  Result := Between(TSqlValue.AsDateTime(aStart), TSqlValue.AsDateTime(aEnd));
end;

function TSqlWhere.BetweenTime(aStart, aEnd: TTime): ISqlWhere;
begin
  Result := Between(TSqlValue.AsTime(aStart), TSqlValue.AsTime(aEnd));
end;

function TSqlWhere.Column(aColumn: string): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty or fComparisonOperator.IsEmpty then begin
    fColumn := aColumn;
    fLogicalOperator := ' AND ';
  end
  else
    AddCondition(fColumn + fComparisonOperator + aColumn);
end;

function TSqlWhere.ConcatArray(aArry: TArray<string>): string;
var
  nValue: Integer;
begin
  if Length(aArry) = 0 then
    Exit;

  for nValue := low(aArry) to high(aArry) do
    if nValue = 0 then
      Result := TSqlValue.ValueToSql(aArry[nValue])
    else
      Result := Result + ', ' + TSqlValue.ValueToSql(aArry[nValue]);
end;

function TSqlWhere.ConcatArray(aArry: TArray<Integer>): string;
var
  nValue: Integer;
begin
  if Length(aArry) = 0 then
    Exit;

  for nValue := low(aArry) to high(aArry) do
    if nValue = 0 then
      Result := TSqlValue.ValueToSql(aArry[nValue])
    else
      Result := Result + ', ' + TSqlValue.ValueToSql(aArry[nValue]);
end;

function TSqlWhere.Containing(aValue: string): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' CONTAINING ' + TSqlValue.ValueToSql(aValue));
end;

constructor TSqlWhere.Create;
begin
  conditionList := TStringList.Create;
end;

function TSqlWhere.CurrentDate: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if fComparisonOperator.IsEmpty then
    Exit;

  AddCondition(fColumn + fComparisonOperator + 'CURRENT_DATE');
end;

function TSqlWhere.CurrentTime: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if fComparisonOperator.IsEmpty then
    Exit;

  AddCondition(fColumn + fComparisonOperator + 'CURRENT_TIME');
end;

function TSqlWhere.CurrentTimestamp: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if fComparisonOperator.IsEmpty then
    Exit;

  AddCondition(fColumn + fComparisonOperator + 'CURRENT_TIMESTAMP');
end;

function TSqlWhere.Date(aDate: TDate): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if fComparisonOperator.IsEmpty then
    Exit;

  if aDate <> 0 then
    AddCondition(fColumn + fComparisonOperator + TSqlValue.ValueToSql(TSqlValue.AsDate(aDate)))
  else
    AddCondition(fColumn + fComparisonOperator + 'NULL');
end;

function TSqlWhere.DateTime(aDateTime: TDateTime): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if fComparisonOperator.IsEmpty then
    Exit;

  if aDateTime <> 0 then
    AddCondition(fColumn + fComparisonOperator + TSqlValue.ValueToSql(TSqlValue.AsDateTime(aDateTime)))
  else
    AddCondition(fColumn + fComparisonOperator + 'NULL');
end;

destructor TSqlWhere.Destroy;
begin
  conditionList.Free;

  inherited;
end;

function TSqlWhere.Different: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fComparisonOperator := ' <> ';
end;

function TSqlWhere.Different(aValue: Variant): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' <> ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Equal: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fComparisonOperator := ' = ';
end;

function TSqlWhere.Equal(aValue: Variant): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' = ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Exists(aSelect: ISqlSelect): ISqlWhere;
begin
  Result := Self;

  fLogicalOperator := ' AND ';
  AddCondition('EXISTS (' + aSelect.ToString + ')');
end;

function TSqlWhere.Greater: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fComparisonOperator := ' > ';
end;

function TSqlWhere.Greater(aValue: Variant): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' > ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.GreaterOrEqual: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fComparisonOperator := ' >= ';
end;

function TSqlWhere.GreaterOrEqual(aValue: Variant): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' >= ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.IsEmpty: Boolean;
begin
  Result := conditionList.Count = 0;
end;

function TSqlWhere.IsNotNull: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' IS NOT NULL');
end;

function TSqlWhere.IsNull: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' IS NULL');
end;

function TSqlWhere.Less: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fComparisonOperator := ' < ';
end;

function TSqlWhere.Less(aValue: Variant): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' < ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.LessOrEqual: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fComparisonOperator := ' <= ';
end;

function TSqlWhere.LessOrEqual(aValue: Variant): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' <= ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Like(aValue: string): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' LIKE ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.LikeSplit(aValue: string): ISqlWhere;
var
  splittedString: TArray<string>;
  nStr: Integer;
  sCondition: string;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if aValue.Contains(' ') then begin
    sCondition := '';

    splittedString := aValue.Split([' ']);

    for nStr := 0 to Pred(Length(splittedString)) do
      sCondition := sCondition + ' AND ' + fColumn + ' LIKE ' + TSqlValue.ValueToSql('%' + splittedString[nStr] + '%');

    sCondition := sCondition.Remove(0, 5);

    if not sCondition.IsEmpty then
      AddParenthesesCondition(sCondition);
  end
  else
    AddCondition(fColumn + ' LIKE ' + TSqlValue.ValueToSql('%' + aValue + '%'));
end;

function TSqlWhere.NotBetween(aStart, aEnd: Variant): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' NOT BETWEEN ' + TSqlValue.ValueToSql(aStart) + ' AND ' + TSqlValue.ValueToSql(aEnd));
end;

function TSqlWhere.NotBetweenDate(aStart, aEnd: TDate): ISqlWhere;
begin
  Result := NotBetween(TSqlValue.AsDate(aStart), TSqlValue.AsDate(aEnd));
end;

function TSqlWhere.NotBetweenDateTime(aStart, aEnd: TDateTime): ISqlWhere;
begin
  Result := NotBetween(TSqlValue.AsDateTime(aStart), TSqlValue.AsDateTime(aEnd));
end;

function TSqlWhere.NotBetweenTime(aStart, aEnd: TTime): ISqlWhere;
begin
  Result := NotBetween(TSqlValue.AsTime(aStart), TSqlValue.AsTime(aEnd));
end;

function TSqlWhere.NotExists(aSelect: ISqlSelect): ISqlWhere;
begin
  Result := Self;

  fLogicalOperator := ' AND ';
  AddCondition('NOT EXISTS (' + aSelect.ToString + ')');
end;

function TSqlWhere.NotIn(aValues: TArray<string>): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' NOT IN (' + ConcatArray(aValues) + ')');
end;

function TSqlWhere.NotIn(aValues: TArray<Integer>): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' NOT IN (' + ConcatArray(aValues) + ')');
end;

function TSqlWhere.NotLike(aValue: string): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' NOT LIKE ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.&Or(aSqlWhere: ISqlWhere): ISqlWhere;
begin
  Result := Self;

  fLogicalOperator := ' OR ';
  AddCondition('(' + aSqlWhere.ToString + ')');
end;

function TSqlWhere.OrExists(aSelect: ISqlSelect): ISqlWhere;
begin
  Result := Self;

  fLogicalOperator := ' OR ';
  AddCondition('EXISTS (' + aSelect.ToString + ')');
end;

function TSqlWhere.OrNotExists(aSelect: ISqlSelect): ISqlWhere;
begin
  Result := Self;

  fLogicalOperator := ' OR ';
  AddCondition('NOT EXISTS (' + aSelect.ToString + ')');
end;

function TSqlWhere.StartingWith(aValue: string): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' STARTING WITH ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Time(aTime: TTime): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if fComparisonOperator.IsEmpty then
    Exit;

  if aTime <> 0 then
    AddCondition(fColumn + fComparisonOperator + TSqlValue.ValueToSql(TSqlValue.AsTime(aTime)))
  else
    AddCondition(fColumn + fComparisonOperator + 'NULL');
end;

function TSqlWhere.ToString: string;
begin
  Result := conditionList.Text.Replace(sLineBreak, '');
end;

end.
