unit uSqlBuilder;

interface

uses
  System.Classes, uSqlBuilder.Interfaces;

type
  SQL = class
    class function select: ISqlSelect;
    class function insert: ISqlInsert;
    class function update(tableName: string): ISqlUpdate;
    class function updateOrInsert: ISqlUpdateOrInsert;
    class function delete: ISqlDelete;

    class function executeProc(procedureName: string): ISqlExecProcedure;

    class function &createProcedure(procName: string): ISqlProcedureCreate;

    class function &case: ISqlCase; overload;
    class function &case(expression: string): ISqlCase; overload;
    class function &procedure(procedureName: string): ISqlProcedure;
    class function where: ISqlWhere;
  end;

  TSqlValue = class
    class function asDate(value: TDate): string;
    class function asTime(value: TDate): string;
    class function asDateTime(value: TDate): string;

    class function valueToSql(value: variant): string;
  end;

implementation

uses
  System.SysUtils, System.Variants, uSqlBuilder.select, uSqlBuilder.update, uSqlBuilder.insert, uSqlBuilder.delete,
  uSqlBuilder.updateOrInsert, uSqlBuilder.SqlProcedure, uSqlBuilder.CreateProcedure, uSqlBuilder.SqlCase,
  uSqlBuilder.where, uSqlBuilder.ExecProcedure;

class function SQL.&case: ISqlCase;
begin
  result := TSqlCase.Create;
end;

class function SQL.delete: ISqlDelete;
begin
  result := TSqlDelete.Create;
end;

class function SQL.executeProc(procedureName: string): ISqlExecProcedure;
begin
  result := TSqlExecProcedure.Create;
  result.&procedure(procedureName);
end;

class function SQL.insert: ISqlInsert;
begin
  result := TSqlInsert.Create;
end;

class function SQL.select: ISqlSelect;
begin
  result := TSqlSelect.Create;
end;

class function SQL.update(tableName: string): ISqlUpdate;
begin
  result := TSqlUpdate.Create;
  result.table(tableName);
end;

class function SQL.updateOrInsert: ISqlUpdateOrInsert;
begin
  result := TSqlUpdateOrInsert.Create;
end;

class function SQL.where: ISqlWhere;
begin
  result := TSqlWhere.Create;
end;

class function SQL.&createProcedure(procName: string): ISqlProcedureCreate;
begin
  result := TSqlCreateProcedure.Create;
  result.name(procName);
end;

class function SQL.&procedure(procedureName: string): ISqlProcedure;
begin
  result := TSqlProcedure.Create;
  result.&procedure(procedureName);
end;

class function SQL.&case(expression: string): ISqlCase;
begin
  result := TSqlCase.Create;
  result.testExpression(expression);
end;

class function TSqlValue.asDate(value: TDate): string;
begin
  result := 'NULL';

  if value <> unassigned then
    result := formatDateTime('dd.mm.yyyy', value);
end;

class function TSqlValue.asDateTime(value: TDate): string;
begin
  result := 'NULL';

  if value <> unassigned then
    result := formatDateTime('dd.mm.yyyy hh:mm:ss', value);
end;

class function TSqlValue.asTime(value: TDate): string;
begin
  result := 'NULL';

  if value <> unassigned then
    result := formatDateTime('hh:mm:ss', value);
end;

{ class function TSqlValue.valueToSql(value: TValue): string;
  begin
  result := value.toString;

  if lowerCase(result) = 'null' then
  exit('NULL');

  case value.kind of
  tkUString, tkWChar, tkLString, tkWString, tkString, tkChar:
  result := quotedStr(result);

  tkInteger, tkEnumeration, tkInt64:
  ;

  tkFloat:
  result := result.replace(',', '.');

  tkUnknown, tkSet, tkClass, tkMethod, tkVariant, tkArray, tkRecord, tkInterface, tkDynArray, tkClassRef, tkPointer, tkProcedure:
  raise Exception.Create('Invalid value [kind]:' + ord(value.kind).toString);
  end;
  end; }

class function TSqlValue.valueToSql(value: variant): string;
begin
  result := value;

  if lowerCase(result) = 'null' then
    exit('NULL');

  case varType(value) of
    varEmpty, varNull:
      ;

    varSmallint, varInteger, varShortInt, varByte, varWord, varLongWord, varInt64:
      ;

    varSingle, varDouble, varCurrency:
      result := result.replace(',', '.');

    varOleStr, varStrArg, varString, varUString:
      result := result.quotedString;

    varDate: //care with quoted here.
      ;

    else
      raise Exception.Create('Invalid value [VarType]:' + System.Ord(varType(value)).toString);
  end;
end;

end.
