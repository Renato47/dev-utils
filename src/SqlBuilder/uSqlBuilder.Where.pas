unit uSqlBuilder.Where;

interface

uses
  System.Classes, System.Rtti, uSqlBuilder.Interfaces;

type
  TSqlWhere = class(TInterfacedObject, ISqlWhere)
  private
    fColumn: string;
    conditionList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    function Column(aColumn: string): ISqlWhere;

    function Less(aValue: TValue): ISqlWhere;
    function LessOrEqual(aValue: TValue): ISqlWhere;

    function Equal(aValue: TValue): ISqlWhere;
    function Different(aValue: TValue): ISqlWhere;

    function Greater(aValue: TValue): ISqlWhere;
    function GreaterOrEqual(aValue: TValue): ISqlWhere;

    function Like(aValue: TValue): ISqlWhere;
    function NotLike(aValue: TValue): ISqlWhere;

    function IsNull: ISqlWhere;
    function IsNotNull: ISqlWhere;

    function Between(aStart, aEnd: TValue): ISqlWhere;

    function &Or(aSqlWhere: ISqlWhere): ISqlWhere;

    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils, uSqlBuilder;

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

destructor TSqlWhere.Destroy;
begin
  conditionList.Free;

  inherited;
end;

function TSqlWhere.Different(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' <> ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Equal(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' = ' + TSqlValue.ValueToSql(aValue));
end;

function TSqlWhere.Greater(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' > ' + TSqlValue.ValueToSql(aValue));
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

function TSqlWhere.Less(aValue: TValue): ISqlWhere;
begin
  Result := Self;

  if fColumn.IsEmpty then
    Exit;

  conditionList.Append(fColumn + ' < ' + TSqlValue.ValueToSql(aValue));
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
