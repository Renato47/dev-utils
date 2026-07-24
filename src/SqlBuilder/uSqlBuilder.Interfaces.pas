unit uSqlBuilder.Interfaces;

interface

type
  ISqlSelect = interface;

  ISqlCase = interface
    function testExpression(expression: string): ISqlCase;

    function whenThenColumn(condition, column: string): ISqlCase;
    function whenThen(condition: string; value: variant): ISqlCase;
    function elseColumn(column: string): ISqlCase;
    function &else(value: variant): ISqlCase;

    function &as(alias: string): ISqlCase;

    function toStr: string;
  end;

  ISqlProcedure = interface
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

  ISqlExecProcedure = interface
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

  ISqlWhere = interface
    //Column name
    function column(column: string): ISqlWhere;

    //Logical Operators [NOT, AND, OR]
    function &or(column: string): ISqlWhere; overload;
    function &or(sqlWhere: ISqlWhere): ISqlWhere; overload;
    function &and(sqlWhere: ISqlWhere): ISqlWhere;

    //Comparison operators [=, <>, <, <=, >, >=, ...]
    function equal: ISqlWhere; overload;
    function equal(value: variant): ISqlWhere; overload;
    function different: ISqlWhere; overload;
    function different(value: variant): ISqlWhere; overload;

    function less: ISqlWhere; overload;
    function less(value: variant): ISqlWhere; overload;
    function lessOrEqual: ISqlWhere; overload;
    function lessOrEqual(value: variant): ISqlWhere; overload;

    function greater: ISqlWhere; overload;
    function greater(value: variant): ISqlWhere; overload;
    function greaterOrEqual: ISqlWhere; overload;
    function greaterOrEqual(value: variant): ISqlWhere; overload;

    //Comparison predicates [LIKE, STARTING WITH, CONTAINING, SIMILAR TO, BETWEEN, IS [NOT] NULL, IS [NOT] DISTINCT FROM]
    function like(value: string): ISqlWhere;
    function notLike(value: string): ISqlWhere;
    function likeSplit(value: string): ISqlWhere;

    function startingWith(value: string): ISqlWhere;
    function containing(value: string): ISqlWhere;

    function isNull: ISqlWhere;
    function isNotNull: ISqlWhere;

    function between(start, end_: variant): ISqlWhere;
    function betweenDate(start, end_: TDate): ISqlWhere;
    function betweenTime(start, end_: TTime): ISqlWhere;
    function betweenDateTime(start, end_: TDateTime): ISqlWhere;
    function notBetween(start, end_: variant): ISqlWhere;
    function notBetweenDate(start, end_: TDate): ISqlWhere;
    function notBetweenTime(start, end_: TTime): ISqlWhere;
    function notBetweenDateTime(start, end_: TDateTime): ISqlWhere;

    //Existential predicates [IN, EXISTS, SINGULAR, ALL, ANY, SOME]
    function &in(values: TArray<string>): ISqlWhere; overload;
    function &in(values: TArray<integer>): ISqlWhere; overload;
    function &in(select: ISqlSelect): ISqlWhere; overload;
    function notIn(values: TArray<string>): ISqlWhere; overload;
    function notIn(values: TArray<integer>): ISqlWhere; overload;

    function exists(select: ISqlSelect): ISqlWhere;
    function notExists(select: ISqlSelect): ISqlWhere;
    function orExists(select: ISqlSelect): ISqlWhere;
    function orNotExists(select: ISqlSelect): ISqlWhere;

    //Date/time literal ['TODAY', 'NOW', '25.12.2016 15:30:35']
    function date(value: TDate): ISqlWhere;
    function time(value: TTime): ISqlWhere;
    function dateTime(value: TDateTime): ISqlWhere;

    //Context Variables
    function currentDate: ISqlWhere;
    function currentTime: ISqlWhere;
    function currentTimestamp: ISqlWhere;

    function toStr: string;
    function isEmpty: boolean;
  end;

  ISqlSelect = interface
    function allColumns: ISqlSelect;
    function column(name: string): ISqlSelect; overload;
    function column(case_: ISqlCase): ISqlSelect; overload;

    function cast(asType, alias: string): ISqlSelect;

    function from(source: string): ISqlSelect; overload;
    function from(select: ISqlSelect; alias: string): ISqlSelect; overload;
    function from(sqlProcedure: ISqlProcedure; alias: string = ''): ISqlSelect; overload;

    function innerJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect; overload;
    function innerJoin(source, conditions: string): ISqlSelect; overload;
    function leftJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect; overload;
    function leftJoin(source, conditions: string): ISqlSelect; overload;
    function rightJoin(select: ISqlSelect; alias, conditions: string): ISqlSelect; overload;
    function rightJoin(source, conditions: string): ISqlSelect; overload;

    function where(conditions: string): ISqlSelect; overload;
    function where(sqlWhere: ISqlWhere): ISqlSelect; overload;
    function groupBy(groupList: string): ISqlSelect;
    function having(aggregateCondition: string): ISqlSelect;
    function orderBy(orderList: string): ISqlSelect;

    function first(count: integer): ISqlSelect;
    function skip(count: integer): ISqlSelect;
    function distinct: ISqlSelect;

    function toStr: string;
  end;

  ISqlInsert = interface
    function into(target: string): ISqlInsert;

    function value(column: string; value: variant): ISqlInsert;
    function valueExpression(column, expression: string): ISqlInsert;

    function valueNull(column, value: string; nullValue: string = ''): ISqlInsert; overload;
    function valueNull(column: string; value: integer; nullValue: integer = 0): ISqlInsert; overload;

    function valueDate(column: string; value: TDate): ISqlInsert;
    function valueTime(column: string; value: TTime): ISqlInsert;
    function valueDateTime(column: string; value: TDateTime): ISqlInsert;

    function toStr: string;
    function isEmpty: boolean;
  end;

  ISqlUpdateOrInsert = interface
    function into(target: string): ISqlUpdateOrInsert;

    function value(column: string; value: variant): ISqlUpdateOrInsert;
    function valueExpression(column, expression: string): ISqlUpdateOrInsert;

    function valueNull(column, value: string; nullValue: string = ''): ISqlUpdateOrInsert; overload;
    function valueNull(column: string; value: integer; nullValue: integer = 0): ISqlUpdateOrInsert; overload;

    function valueDate(column: string; value: TDate): ISqlUpdateOrInsert;
    function valueTime(column: string; value: TTime): ISqlUpdateOrInsert;
    function valueDateTime(column: string; value: TDateTime): ISqlUpdateOrInsert;

    function matching(columnList: string): ISqlUpdateOrInsert;

    function toStr: string;
    function isEmpty: boolean;
  end;

  ISqlUpdate = interface
    function table(target: string): ISqlUpdate;

    function value(column: string; value: variant): ISqlUpdate;
    function valueExpression(column, expression: string): ISqlUpdate;

    function valueNull(column, value: string; nullValue: string = ''): ISqlUpdate; overload;
    function valueNull(column: string; value: integer; nullValue: integer = 0): ISqlUpdate; overload;

    function valueDate(column: string; value: TDate): ISqlUpdate;
    function valueTime(column: string; value: TTime): ISqlUpdate;
    function valueDateTime(column: string; value: TDateTime): ISqlUpdate;

    function where(conditions: string): ISqlUpdate; overload;
    function where(sqlWhere: ISqlWhere): ISqlUpdate; overload;

    function toStr: string;
    function isEmpty: boolean;
  end;

  ISqlDelete = interface
    function from(target: string): ISqlDelete;

    function where(conditions: string): ISqlDelete; overload;
    function where(sqlWhere: ISqlWhere): ISqlDelete; overload;

    function toStr: string;
  end;

  ISqlProcedureCreate = interface
    function name(name: string): ISqlProcedureCreate;
    function input(name, type_: string): ISqlProcedureCreate;
    function return(name, type_: string): ISqlProcedureCreate;
    function variable(name, type_: string): ISqlProcedureCreate;
    function instruction(sqlInstruction: string): ISqlProcedureCreate;

    function toStr: string;
  end;

implementation

end.
