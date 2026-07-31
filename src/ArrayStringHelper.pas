unit ArrayStringHelper;

interface

type
  TArrayString = TArray<string>;

  TArrayStringHelper = record helper for TArrayString
  public
    procedure clear;
    procedure insert(value: string);
    procedure remove(value: string);

    function indexOf(value: string): integer;
    function length: integer;
    function contains(value: string): boolean;

    function toString: string;
  end;

implementation

uses
  System.SysUtils;

procedure TArrayStringHelper.clear;
begin
  setLength(self, 0);
end;

function TArrayStringHelper.contains(value: string): boolean;
begin
  result := self.indexOf(value) >= 0;
end;

function TArrayStringHelper.indexOf(value: string): integer;
var
  index: integer;
begin
  result := -1;

  for index := 0 to high(self) do
    if self[index] = value then
      exit(index);
end;

procedure TArrayStringHelper.insert(value: string);
begin
  setLength(self, length(self) + 1);
  self[high(self)] := value;
end;

function TArrayStringHelper.length: integer;
begin
  result := System.length(self);
end;

procedure TArrayStringHelper.remove(value: string);
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

function TArrayStringHelper.toString: string;
var
  value: string;
begin
  result := '';

  for value in self do
    if result.isEmpty then
      result := value
    else
      result := result + ',' + value;
end;

end.
