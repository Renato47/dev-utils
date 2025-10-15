unit StringUtils;

interface

function LeftAndPadLeft(str: string; width: Integer; PaddingChar: Char = ' '): string;
function RightAndPadRight(str: string; width: Integer; PaddingChar: Char = ' '): string;

implementation

uses
  System.SysUtils, System.StrUtils;

function LeftAndPadLeft(str: string; width: Integer; PaddingChar: Char = ' '): string;
begin
  Result := LeftStr(str, width).PadLeft(width, PaddingChar);
end;

function RightAndPadRight(str: string; width: Integer; PaddingChar: Char = ' '): string;
begin
  Result := RightStr(str, width).PadRight(width, PaddingChar);
end;

end.
