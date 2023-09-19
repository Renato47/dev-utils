unit PathUtils;

interface

function PathAdd(aPaths: array of string): string;

implementation

uses
  System.SysUtils;

function PathAdd(aPaths: array of string): string;
var
  nPath: Integer;
begin
  Result := '';

  if Length(aPaths) = 0 then
    Exit;

  for nPath := 0 to Pred(Length(aPaths)) do begin
    if nPath = 0 then begin
      Result := aPaths[nPath];
      Continue;
    end;

    if Result.EndsWith(PathDelim) then
      Result := Result + aPaths[nPath]
    else
      Result := Result + PathDelim + aPaths[nPath];
  end;
end;

end.
