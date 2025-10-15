unit StringUtils;

interface

function RemoveLeft(str: string; maxLength: Integer): string;
function RemoveRight(str: string; maxLength: Integer): string;

function padAndRemoveLeft(str: string; width: Integer; PaddingChar: Char = ' '): string;
function padAndRemoveRight(str: string; width: Integer; PaddingChar: Char = ' '): string;

implementation

uses
  System.SysUtils;

function RemoveLeft(str: string; maxLength: Integer): string;
begin
  if length(str) <= maxLength then
    Exit(str);

  Result := str;
  System.Delete(Result, 1, length(str) - maxLength);
end;

function RemoveRight(str: string; maxLength: Integer): string;
begin
  Result := str.Remove(maxLength);
end;

function padAndRemoveLeft(str: string; width: Integer; PaddingChar: Char = ' '): string;
begin
  Result := RemoveLeft(str, width).PadLeft(width, PaddingChar);
end;

function padAndRemoveRight(str: string; width: Integer; PaddingChar: Char = ' '): string;
begin
  Result := RemoveRight(str, width).PadRight(width, PaddingChar);
end;

end.
