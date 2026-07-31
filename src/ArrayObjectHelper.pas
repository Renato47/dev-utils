unit ArrayObjectHelper;

interface

type
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

end.
