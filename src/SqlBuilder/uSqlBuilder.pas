unit uSqlBuilder;

interface

uses
  System.Classes, System.Rtti, uSqlBuilder.Interfaces;

type
  SQL = class
    class function Select: ISqlSelect;
    class function Insert: ISqlInsert;
    class function Update: ISqlUpdate;
    class function UpdateOrInsert: ISqlUpdateOrInsert;
    class function Delete: ISqlDelete;

    class function &Procedure(aProcName: string): ISqlProcedure;

    class function &Case: ISqlCase; overload;
    class function &Case(aExpression: string): ISqlCase; overload;
    class function Where: ISqlWhere;
  end;

  TSqlValue = class
    class function AsDate(aValue: TDate): string;
    class function AsTime(aValue: TDate): string;
    class function AsDateTime(aValue: TDate): string;

    class function ValueToSql(Value: TValue; aIsLike: Boolean = False): string;
  end;

implementation

uses
  System.SysUtils, System.Variants, uSqlBuilder.Select, uSqlBuilder.Update, uSqlBuilder.Insert, uSqlBuilder.Delete, uSqlBuilder._Case, uSqlBuilder.UpdateOrInsert, uSqlBuilder.Where,
  uSqlBuilder._Procedure;

class function SQL.&Case: ISqlCase;
begin
  Result := TSqlCase.Create;
end;

class function SQL.Delete: ISqlDelete;
begin
  Result := TSqlDelete.Create;
end;

class function SQL.Insert: ISqlInsert;
begin
  Result := TSqlInsert.Create;
end;

class function SQL.Select: ISqlSelect;
begin
  Result := TSqlSelect.Create;
end;

class function SQL.Update: ISqlUpdate;
begin
  Result := TSqlUpdate.Create;
end;

class function SQL.UpdateOrInsert: ISqlUpdateOrInsert;
begin
  Result := TSqlUpdateOrInsert.Create;
end;

class function SQL.Where: ISqlWhere;
begin
  Result := TSqlWhere.Create;
end;

class function SQL.&Procedure(aProcName: string): ISqlProcedure;
begin
  Result := TSqlProcedure.Create;
  Result.Name(aProcName);
end;

class function SQL.&Case(aExpression: string): ISqlCase;
begin
  Result := TSqlCase.Create;
  Result.TestExpression(aExpression);
end;

class function TSqlValue.AsDate(aValue: TDate): string;
begin
  Result := 'NULL';

  if aValue <> Unassigned then
    Result := FormatDateTime('dd.mm.yyyy', aValue);
end;

class function TSqlValue.AsDateTime(aValue: TDate): string;
begin
  Result := 'NULL';

  if aValue <> Unassigned then
    Result := FormatDateTime('dd.mm.yyyy hh:mm:ss', aValue);
end;

class function TSqlValue.AsTime(aValue: TDate): string;
begin
  Result := 'NULL';

  if aValue <> Unassigned then
    Result := FormatDateTime('hh:mm:ss', aValue);
end;

class function TSqlValue.ValueToSql(Value: TValue; aIsLike: Boolean): string;
begin
  Result := Value.ToString;

  if LowerCase(Result) = 'null' then
    Exit('NULL');

  if aIsLike then
    Result := '%' + Result + '%';

  case Value.Kind of
    tkUString, tkWChar, tkLString, tkWString, tkString, tkChar:
      Result := QuotedStr(Result);

    tkInteger, tkEnumeration, tkInt64:
      ;

    tkFloat:
      Result := Result.Replace(',', '.');

    tkUnknown, tkSet, tkClass, tkMethod, tkVariant, tkArray, tkRecord, tkInterface, tkDynArray, tkClassRef, tkPointer, tkProcedure:
      raise Exception.Create('Invalid value [Kind]:' + ord(Value.Kind).ToString);
  end;
end;

end.
