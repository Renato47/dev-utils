unit uSqlBuilder;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  SQL = class
    class function Select: ISqlSelect;
    class function Insert: ISqlInsert;
    class function Update(aTableName: string): ISqlUpdate;
    class function UpdateOrInsert: ISqlUpdateOrInsert;
    class function Delete: ISqlDelete;

    class function ExecuteProc(aProcedureName: string): ISqlExecProcedure;

    class function &CreateProcedure(aProcName: string): ISqlProcedureCreate;

    class function &Case: ISqlCase; overload;
    class function &Case(aExpression: string): ISqlCase; overload;
    class function &Procedure(aProcedureName: string): ISqlProcedure;
    class function Where: ISqlWhere;
  end;

  TSqlValue = class
    class function AsDate(aValue: TDate): string;
    class function AsTime(aValue: TDate): string;
    class function AsDateTime(aValue: TDate): string;

    class function ValueToSql(Value: Variant): string;
  end;

implementation

uses
  System.SysUtils, System.Variants, uSqlBuilder.Select, uSqlBuilder.Update, uSqlBuilder.Insert, uSqlBuilder.Delete, uSqlBuilder.SqlCase, uSqlBuilder.UpdateOrInsert, uSqlBuilder.Where,
  uSqlBuilder.CreateProcedure, uSqlBuilder.SqlProcedure, uSqlBuilder.ExecProcedure;

class function SQL.&Case: ISqlCase;
begin
  Result := TSqlCase.Create;
end;

class function SQL.Delete: ISqlDelete;
begin
  Result := TSqlDelete.Create;
end;

class function SQL.ExecuteProc(aProcedureName: string): ISqlExecProcedure;
begin
  Result := TSqlExecProcedure.Create;
  Result.&Procedure(aProcedureName);
end;

class function SQL.Insert: ISqlInsert;
begin
  Result := TSqlInsert.Create;
end;

class function SQL.Select: ISqlSelect;
begin
  Result := TSqlSelect.Create;
end;

class function SQL.Update(aTableName: string): ISqlUpdate;
begin
  Result := TSqlUpdate.Create;
  Result.Table(aTableName);
end;

class function SQL.UpdateOrInsert: ISqlUpdateOrInsert;
begin
  Result := TSqlUpdateOrInsert.Create;
end;

class function SQL.Where: ISqlWhere;
begin
  Result := TSqlWhere.Create;
end;

class function SQL.&CreateProcedure(aProcName: string): ISqlProcedureCreate;
begin
  Result := TSqlCreateProcedure.Create;
  Result.Name(aProcName);
end;

class function SQL.&Procedure(aProcedureName: string): ISqlProcedure;
begin
  Result := TSqlProcedure.Create;
  Result.&Procedure(aProcedureName);
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

{ class function TSqlValue.ValueToSql(Value: TValue): string;
  begin
  Result := Value.ToString;

  if LowerCase(Result) = 'null' then
  Exit('NULL');

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
  end; }

class function TSqlValue.ValueToSql(Value: Variant): string;
begin
  Result := Value;

  if LowerCase(Result) = 'null' then
    Exit('NULL');

  case VarType(Value) of
    varEmpty, varNull:
      ;

    varSmallint, varInteger, varShortInt, varByte, varWord, varLongWord, varInt64:
      ;

    varSingle, varDouble, varCurrency:
      Result := Result.Replace(',', '.');

    varOleStr, varStrArg, varString, varUString:
      Result := Result.QuotedString;

    varDate: //care with quoted here.
      ;

    else
      raise Exception.Create('Invalid value [VarType]:' + System.Ord(VarType(Value)).ToString);
  end;
end;

end.
