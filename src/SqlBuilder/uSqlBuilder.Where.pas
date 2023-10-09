unit uSqlBuilder.Where;

interface

uses
  System.Classes, System.Rtti, uSqlBuilder.Interfaces;

type
  TSqlWhere = class(TInterfacedObject, ISqlWhere)
  private
    fComparisonOperator: string;
    fColumn: string;
    fLogicalOperator: string;
    conditionList: TStringList;

    procedure AddCondition(aCriteria: string);
  public
    constructor Create;
    destructor Destroy; override;

    function Column(aColumn: string): ISqlWhere;

    function Less: ISqlWhere; overload;
    function Less(aValue: TValue): ISqlWhere; overload;
    function LessOrEqual: ISqlWhere; overload;
    function LessOrEqual(aValue: TValue): ISqlWhere; overload;

    function Equal: ISqlWhere; overload;
    function Equal(aValue: TValue): ISqlWhere; overload;
    function Different: ISqlWhere; overload;
    function Different(aValue: TValue): ISqlWhere; overload;

    function Greater: ISqlWhere; overload;
    function Greater(aValue: TValue): ISqlWhere; overload;
    function GreaterOrEqual: ISqlWhere; overload;
    function GreaterOrEqual(aValue: TValue): ISqlWhere; overload;

    function CurrentDate: ISqlWhere;
    function CurrentTime: ISqlWhere;
    function CurrentTimestamp: ISqlWhere;

    function Like(aValue: TValue): ISqlWhere;
    function NotLike(aValue: TValue): ISqlWhere;

    function IsNull: ISqlWhere;
    function IsNotNull: ISqlWhere;

    function Between(aStart, aEnd: TValue): ISqlWhere;

    function &In(aValues: string): ISqlWhere;
    function NotIn(aValues: string): ISqlWhere;

    function &Or(aColumn: string): ISqlWhere; overload;
    function &Or(aSqlWhere: ISqlWhere): ISqlWhere; overload;
    function &And(aSqlWhere: ISqlWhere): ISqlWhere;

    function Exists(aSelect: ISqlSelect): ISqlWhere;
    function NotExists(aSelect: ISqlSelect): ISqlWhere;
    function OrExists(aSelect: ISqlSelect): ISqlWhere;
    function OrNotExists(aSelect: ISqlSelect): ISqlWhere;

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

function TSqlWhere.&In(aValues: string): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' IN (' + aValues + ')');
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

function TSqlWhere.&And(aSqlWhere: ISqlWhere): ISqlWhere;
begin
  Result := Self;
  conditionList.Append(' AND (' + aSqlWhere.ToString + ')');
end;

function TSqlWhere.Between(aStart, aEnd: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' BETWEEN ' + TSqlValue.ValueToSql(aStart) + ' AND ' + TSqlValue.ValueToSql(aEnd));
end;

function TSqlWhere.Column(aColumn: string): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty or fComparisonOperator.IsEmpty then begin
    fLogicalOperator := ' AND ';
    fColumn := aColumn;
  end
  else
    AddCondition(fColumn + fComparisonOperator + aColumn);
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

function TSqlWhere.Different(aValue: TValue): ISqlWhere;
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

function TSqlWhere.Equal(aValue: TValue): ISqlWhere;
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

function TSqlWhere.Greater(aValue: TValue): ISqlWhere;
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

function TSqlWhere.GreaterOrEqual(aValue: TValue): ISqlWhere;
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

function TSqlWhere.Less(aValue: TValue): ISqlWhere;
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

function TSqlWhere.LessOrEqual(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' <= ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Like(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' LIKE ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.NotExists(aSelect: ISqlSelect): ISqlWhere;
begin
  Result := Self;

  fLogicalOperator := ' AND ';
  AddCondition('NOT EXISTS (' + aSelect.ToString + ')');
end;

function TSqlWhere.NotIn(aValues: string): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  AddCondition(fColumn + ' NOT IN (' + aValues + ')');
end;

function TSqlWhere.NotLike(aValue: TValue): ISqlWhere;
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

function TSqlWhere.ToString: string;
begin
  Result := conditionList.Text.Replace(sLineBreak, '');
end;

end.
