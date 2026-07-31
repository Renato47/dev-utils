unit ArrayIntegerHelper;

interface

type
  TArrayInteger = TArray<integer>;

  TArrayIntegerHelper = record helper for TArrayInteger
  public
    procedure clear;
    procedure insert(value: integer);
    procedure remove(value: integer);

    function indexOf(value: integer): integer;
    function length: integer;
    function contains(value: integer): boolean;

    function toString: string;
  end;

implementation

uses
  System.SysUtils;

procedure TArrayIntegerHelper.clear;
begin
  setLength(self, 0);
end;

function TArrayIntegerHelper.contains(value: integer): boolean;
begin
  result := self.indexOf(value) >= 0;
end;

function TArrayIntegerHelper.indexOf(value: integer): integer;
var
  index: integer;
begin
  result := -1;

  for index := 0 to high(self) do
    if self[index] = value then
      exit(index);
end;

procedure TArrayIntegerHelper.insert(value: integer);
begin
  setLength(self, System.length(self) + 1);
  self[high(self)] := value;
end;

function TArrayIntegerHelper.length: integer;
begin
  result := System.length(self);
end;

procedure TArrayIntegerHelper.remove(value: integer);
var
  indexRemove: integer;
  idx: integer;
begin
  indexRemove := self.indexOf(value);

  if (indexRemove < 0) or (indexRemove > high(self)) then
    exit;

  for idx := indexRemove to high(self) - 1 do
    self[idx] := self[idx + 1];

  setLength(self, self.length - 1);
end;

function TArrayIntegerHelper.toString: string;
var
  value: integer;
begin
  result := '';

  for value in self do
    if result.isEmpty then
      result := value.toString
    else
      result := result + ',' + value.toString;
end;

end.
