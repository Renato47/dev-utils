unit uSqlBuilder.Interfaces;

interface

uses
  System.Rtti;

type
  ISqlSelect = interface;

  ISqlCase = interface
    function TestExpression(aExpression: string): ISqlCase;

    function WhenThenColumn(aCondition, aColumn: string): ISqlCase;
    function WhenThen(aCondition: string; aResult: TValue): ISqlCase;
    function ElseColumn(aColumn: string): ISqlCase;
    function &Else(aResult: TValue): ISqlCase;

    function &As(aAlias: string): ISqlCase;

    function ToString: string;
  end;

  ISqlProcedure = interface
    function &Procedure(aName: string): ISqlProcedure;

    function Value(aValue: TValue): ISqlProcedure;
    function ValueExpression(aExpression: string): ISqlProcedure;

    function ValueNull(aValue: string; aNullValue: string = ''): ISqlProcedure; overload;
    function ValueNull(aValue: Integer; aNullValue: Integer = 0): ISqlProcedure; overload;

    function Null: ISqlProcedure;

    function Date(aDate: TDate): ISqlProcedure;
    function Time(aTime: TTime): ISqlProcedure;
    function DateTime(aDateTime: TDateTime): ISqlProcedure;

    function CurrentDate: ISqlProcedure;
    function CurrentTime: ISqlProcedure;
    function CurrentTimestamp: ISqlProcedure;

    function ToString: string;
  end;

  ISqlExecProcedure = interface
    function &Procedure(aName: string): ISqlExecProcedure;

    function Value(aValue: TValue): ISqlExecProcedure;
    function ValueExpression(aExpression: string): ISqlExecProcedure;

    function ValueNull(aValue: string; aNullValue: string = ''): ISqlExecProcedure; overload;
    function ValueNull(aValue: Integer; aNullValue: Integer = 0): ISqlExecProcedure; overload;

    function Null: ISqlExecProcedure;

    function Date(aDate: TDate): ISqlExecProcedure;
    function Time(aTime: TTime): ISqlExecProcedure;
    function DateTime(aDateTime: TDateTime): ISqlExecProcedure;

    function CurrentDate: ISqlExecProcedure;
    function CurrentTime: ISqlExecProcedure;
    function CurrentTimestamp: ISqlExecProcedure;

    function ToString: string;
  end;

  ISqlWhere = interface
    //Column name
    function Column(aColumn: string): ISqlWhere;

    //Logical Operators [NOT, AND, OR]
    function &Or(aColumn: string): ISqlWhere; overload;
    function &Or(aSqlWhere: ISqlWhere): ISqlWhere; overload;
    function &And(aSqlWhere: ISqlWhere): ISqlWhere;

    //Comparison operators [=, <>, <, <=, >, >=, ...]
    function Equal: ISqlWhere; overload;
    function Equal(aValue: TValue): ISqlWhere; overload;
    function Different: ISqlWhere; overload;
    function Different(aValue: TValue): ISqlWhere; overload;

    function Less: ISqlWhere; overload;
    function Less(aValue: TValue): ISqlWhere; overload;
    function LessOrEqual: ISqlWhere; overload;
    function LessOrEqual(aValue: TValue): ISqlWhere; overload;

    function Greater: ISqlWhere; overload;
    function Greater(aValue: TValue): ISqlWhere; overload;
    function GreaterOrEqual: ISqlWhere; overload;
    function GreaterOrEqual(aValue: TValue): ISqlWhere; overload;

    //Comparison predicates [LIKE, STARTING WITH, CONTAINING, SIMILAR TO, BETWEEN, IS [NOT] NULL, IS [NOT] DISTINCT FROM]
    function Like(aValue: string): ISqlWhere;
    function NotLike(aValue: string): ISqlWhere;
    function LikeSplit(aValue: string): ISqlWhere;

    function StartingWith(aValue: string): ISqlWhere;
    function Containing(aValue: string): ISqlWhere;

    function IsNull: ISqlWhere;
    function IsNotNull: ISqlWhere;

    function Between(aStart, aEnd: TValue): ISqlWhere;
    function NotBetween(aStart, aEnd: TValue): ISqlWhere;

    //Existential predicates [IN, EXISTS, SINGULAR, ALL, ANY, SOME]
    function &In(aValues: string): ISqlWhere; overload;
    function &In(aSelect: ISqlSelect): ISqlWhere; overload;
    function NotIn(aValues: string): ISqlWhere;

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

    function ToString: string;
    function IsEmpty: Boolean;
  end;

  ISqlSelect = interface
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
    function GroupBy(aGroupList: string): ISqlSelect;
    function Having(aAggregateCondition: string): ISqlSelect;
    function OrderBy(aOrderList: string): ISqlSelect;

    function First(aCount: Integer): ISqlSelect;
    function Skip(aCount: Integer): ISqlSelect;
    function Distinct: ISqlSelect;

    function ToString: string;
  end;

  ISqlInsert = interface
    function Into(aTarget: string): ISqlInsert;

    function Value(aColumn: string; aValue: TValue): ISqlInsert;
    function ValueExpression(aColumn, aExpression: string): ISqlInsert;

    function ValueNull(aColumn, aValue: string; aNullValue: string = ''): ISqlInsert; overload;
    function ValueNull(aColumn: string; aValue: Integer; aNullValue: Integer = 0): ISqlInsert; overload;

    function ValueDate(aColumn: string; aDate: TDate): ISqlInsert;
    function ValueTime(aColumn: string; aTime: TTime): ISqlInsert;
    function ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlInsert;

    function ToString: string;
    function IsEmpty: Boolean;
  end;

  ISqlUpdateOrInsert = interface
    function Into(aTarget: string): ISqlUpdateOrInsert;

    function Value(aColumn: string; aValue: TValue): ISqlUpdateOrInsert;
    function ValueExpression(aColumn, aExpression: string): ISqlUpdateOrInsert;

    function ValueNull(aColumn, aValue: string; aNullValue: string = ''): ISqlUpdateOrInsert; overload;
    function ValueNull(aColumn: string; aValue: Integer; aNullValue: Integer = 0): ISqlUpdateOrInsert; overload;

    function ValueDate(aColumn: string; aDate: TDate): ISqlUpdateOrInsert;
    function ValueTime(aColumn: string; aTime: TTime): ISqlUpdateOrInsert;
    function ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlUpdateOrInsert;

    function Matching(aColumnList: string): ISqlUpdateOrInsert;

    function ToString: string;
    function IsEmpty: Boolean;
  end;

  ISqlUpdate = interface
    function Table(aTarget: string): ISqlUpdate;

    function Value(aColumn: string; aValue: TValue): ISqlUpdate;
    function ValueExpression(aColumn, aExpression: string): ISqlUpdate;

    function ValueNull(aColumn, aValue: string; aNullValue: string = ''): ISqlUpdate; overload;
    function ValueNull(aColumn: string; aValue: Integer; aNullValue: Integer = 0): ISqlUpdate; overload;

    function ValueDate(aColumn: string; aDate: TDate): ISqlUpdate;
    function ValueTime(aColumn: string; aTime: TTime): ISqlUpdate;
    function ValueDateTime(aColumn: string; aDateTime: TDateTime): ISqlUpdate;

    function Where(aConditions: string): ISqlUpdate; overload;
    function Where(aWhere: ISqlWhere): ISqlUpdate; overload;

    function ToString: string;
    function IsEmpty: Boolean;
  end;

  ISqlDelete = interface
    function From(aTarget: string): ISqlDelete;

    function Where(aConditions: string): ISqlDelete; overload;
    function Where(aWhere: ISqlWhere): ISqlDelete; overload;

    function ToString: string;
  end;

  ISqlProcedureCreate = interface
    function name(aName: string): ISqlProcedureCreate;
    function Input(aName, aType: string): ISqlProcedureCreate;
    function Return(aName, aType: string): ISqlProcedureCreate;
    function Variable(aName, aType: string): ISqlProcedureCreate;
    function Instruction(aSqlInstruction: string): ISqlProcedureCreate;

    function ToString: string;
  end;

implementation

end.
