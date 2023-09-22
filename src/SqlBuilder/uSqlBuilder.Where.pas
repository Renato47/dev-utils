unit uSqlBuilder.Where;

interface

uses
  System.Classes, System.Rtti, uSqlBuilder.Interfaces;

type
  TSqlWhere = class(TInterfacedObject, ISqlWhere)
  private
    fColumn: string;
    fOperator: string;
    conditionList: TStringList;
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

    function &Or(aSqlWhere: ISqlWhere): ISqlWhere;
    function &And(aSqlWhere: ISqlWhere): ISqlWhere;

    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils, uSqlBuilder;

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

  conditionList.Append(fColumn + ' BETWEEN ' + TSqlValue.ValueToSql(aStart) + ' AND ' + TSqlValue.ValueToSql(aEnd));
end;

function TSqlWhere.Column(aColumn: string): ISqlWhere;
begin
  Result := Self;
  fColumn := aColumn;
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

  if fOperator.IsEmpty then
    Exit;

  conditionList.Append(fColumn + fOperator + 'CURRENT_DATE');
end;

function TSqlWhere.CurrentTime: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if fOperator.IsEmpty then
    Exit;

  conditionList.Append(fColumn + fOperator + 'CURRENT_TIME');
end;

function TSqlWhere.CurrentTimestamp: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  if fOperator.IsEmpty then
    Exit;

  conditionList.Append(fColumn + fOperator + 'CURRENT_TIMESTAMP');
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

  fOperator := ' <> ';
end;

function TSqlWhere.Different(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' <> ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Equal: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fOperator := ' = ';
end;

function TSqlWhere.Equal(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' = ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Greater: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fOperator := ' > ';
end;

function TSqlWhere.Greater(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' > ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.GreaterOrEqual: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fOperator := ' >= ';
end;

function TSqlWhere.GreaterOrEqual(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' >= ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.IsNotNull: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' IS NOT NULL');
end;

function TSqlWhere.IsNull: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' IS NULL');
end;

function TSqlWhere.Less: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fOperator := ' < ';
end;

function TSqlWhere.Less(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' < ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.LessOrEqual: ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  fOperator := ' <= ';
end;

function TSqlWhere.LessOrEqual(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' <= ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Like(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' LIKE ' + TSqlValue.ValueToSql(aValue, True));
end;

function TSqlWhere.NotLike(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' NOT LIKE ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.&Or(aSqlWhere: ISqlWhere): ISqlWhere;
begin
  Result := Self;
  conditionList.Append(' OR (' + aSqlWhere.ToString + ')');
end;

function TSqlWhere.ToString: string;
var
  nCondition: Integer;
begin
  for nCondition := 0 to Pred(conditionList.Count) do begin
    if nCondition > 0 then
      if conditionList.Strings[nCondition].StartsWith(' OR ') then
        Result := '(' + Result + ')'
      else
        Result := Result + ' AND ';

    Result := Result + conditionList.Strings[nCondition];
  end;
end;

end.
