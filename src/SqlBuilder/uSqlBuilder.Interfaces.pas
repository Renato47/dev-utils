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

  ISqlWhere = interface
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

    function ToString: string;
    function IsEmpty: Boolean;
  end;

  ISqlSelect = interface
    function AllColumns: ISqlSelect;
    function Column(aName: string): ISqlSelect; overload;
    function Column(aCase: ISqlCase): ISqlSelect; overload;

    function Cast(aAsType, aAlias: string): ISqlSelect;

    function From(aSource: string): ISqlSelect;

    function InnerJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect; overload;
    function InnerJoin(aSource, aConditions: string): ISqlSelect; overload;
    function LeftJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect; overload;
    function LeftJoin(aSource, aConditions: string): ISqlSelect; overload;
    function RightJoin(aSelect: ISqlSelect; aAlias, aConditions: string): ISqlSelect; overload;
    function RightJoin(aSource, aConditions: string): ISqlSelect; overload;

    //function SubSelect(select: ISqlSelect, alias: string): ISqlSelect;

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

    function ToString: string;
  end;

  ISqlUpdateOrInsert = interface
    function Into(aTarget: string): ISqlUpdateOrInsert;
    function Value(aColumn: string; aValue: TValue): ISqlUpdateOrInsert;
    function Matching(aColumnList: string): ISqlUpdateOrInsert;

    function ToString: string;
  end;

  ISqlUpdate = interface
    function Table(aTarget: string): ISqlUpdate;

    function Value(aColumn: string; aValue: TValue): ISqlUpdate;

    function Where(aConditions: string): ISqlUpdate; overload;
    function Where(aWhere: ISqlWhere): ISqlUpdate; overload;

    function ToString: string;
  end;

  ISqlDelete = interface
    function From(aTarget: string): ISqlDelete;

    function Where(aConditions: string): ISqlDelete; overload;
    function Where(aWhere: ISqlWhere): ISqlDelete; overload;

    function ToString: string;
  end;

  ISqlProcedure = interface
    function Name(aName: string): ISqlProcedure;
    function Input(aName, aType: string): ISqlProcedure;
    function Return(aName, aType: string): ISqlProcedure;
    function Variable(aName, aType: string): ISqlProcedure;
    function Instruction(aSqlInstruction: string): ISqlProcedure;

    function ToString: string;
  end;

implementation

end.
