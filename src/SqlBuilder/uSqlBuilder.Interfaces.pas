unit uSqlBuilder.Interfaces;

interface

uses
  System.Rtti;

type
  ISqlCase = interface
    function TestExpression(aExpression: string): ISqlCase;

    function WhenThen(aCondition: string; aResult: TValue): ISqlCase;
    function &Else(aResult: TValue): ISqlCase;

    function &EndAs(aAlias: string): ISqlCase;

    function ToString: string;
  end;

  ISqlWhere = interface
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

    function ToString: string;
  end;

  ISqlSelect = interface
    function AllColumns: ISqlSelect;
    function Column(aName: string): ISqlSelect; overload;
    function Column(aCase: ISqlCase): ISqlSelect; overload;

    function From(aSource: string): ISqlSelect;

    function InnerJoin(aSource, aConditions: string): ISqlSelect;
    function LeftJoin(aSource, aConditions: string): ISqlSelect;
    function RightJoin(aSource, aConditions: string): ISqlSelect;

    //function SubSelect(select: ISqlSelect, alias: string): ISqlSelect;

    function Where(aConditions: string): ISqlSelect; overload;
    function Where(aSqlWhere: ISqlWhere): ISqlSelect; overload;
    function GroupBy(aGroupList: string): ISqlSelect;
    function Having(aAggregateCondition: string): ISqlSelect;
    function OrderBy(aOrderList: string): ISqlSelect;

    function First(aCount: Integer): ISqlSelect;
    function Skip(aCount: Integer): ISqlSelect;

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