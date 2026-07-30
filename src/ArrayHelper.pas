unit ArrayHelper;

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

  TArrayObject = TArray<TObject>;

  TArrayHelperObject = record helper for TArrayObject
    procedure clear;
    procedure insert(value: TObject);
    procedure remove(value: TObject);

    function indexOf(value: TObject): integer;
    function length: integer;
    function contains(value: TObject): boolean;
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

procedure TArrayHelperObject.clear;
begin
  while self.length > 0 do begin
    freeAndNil(self[high(self)]);
    setLength(self, System.length(self) - 1);
  end;
end;

function TArrayHelperObject.contains(value: TObject): boolean;
begin
  result := self.indexOf(value) >= 0;
end;

function TArrayHelperObject.indexOf(value: TObject): integer;
var
  index: integer;
begin
  result := -1;

  for index := 0 to high(self) do
    if self[index] = value then
      exit(index);
end;

procedure TArrayHelperObject.insert(value: TObject);
begin
  setLength(self, System.length(self) + 1);
  self[high(self)] := value;
end;

function TArrayHelperObject.length: integer;
begin
  result := System.length(self);
end;

procedure TArrayHelperObject.remove(value: TObject);
var
  indexRemove: integer;
  idx: integer;
begin
  indexRemove := self.indexOf(value);

  if (indexRemove < 0) or (indexRemove > high(self)) then
    exit;

  freeAndNil(self[indexRemove]);

  for idx := indexRemove to high(self) - 1 do
    self[idx] := self[idx + 1];

  setLength(self, self.length - 1);
end;

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
