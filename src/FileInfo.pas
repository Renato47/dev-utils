unit FileInfo;

interface

type
  TFileInfo = record
    Comments: string;
    CompanyName: string;
    FileDescription: string;
    FileVersion: string;
    InternalName: string;
    LegalCopyright: string;
    LegalTrademarks: string;
    OriginalFileName: string;
    PrivateBuild: string;
    ProductName: string;
    ProductVersion: string;
    SpecialBuild: string;
  end;

  PLandCodepage = ^TLandCodepage;

  TLandCodepage = record
    wLanguage: Word;
    wCodePage: Word;
  end;

function GetFileInfo(aFileName: string): TFileInfo;

implementation

uses
  System.SysUtils, Winapi.Windows;

function GetFileInfo(aFileName: string): TFileInfo;
var
  size, dummy, error: Cardinal;
  buffer, lpBuffer: Pointer;
  lang: string;
begin
  size := GetFileVersionInfoSize(PChar(aFileName), dummy);

  if size = 0 then begin
    error := GetLastError;

    if error = 1813 then //when file dont have version info
      Exit;

    if error = 1812 then //when file type (diferent exe/dll) dont have version info
      Exit;

    RaiseLastOSError;
  end;

  GetMem(buffer, size);

  try
    if not GetFileVersionInfo(PChar(aFileName), 0, size, buffer) then
      RaiseLastOSError;

    if not VerQueryValue(buffer, '\VarFileInfo\Translation\', lpBuffer, size) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(lpBuffer)^.wLanguage, PLandCodepage(lpBuffer)^.wCodePage]);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\CompanyName'), lpBuffer, size) then
      Result.CompanyName := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\FileDescription'), lpBuffer, size) then
      Result.FileDescription := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\FileVersion'), lpBuffer, size) then
      Result.FileVersion := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\InternalName'), lpBuffer, size) then
      Result.InternalName := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\LegalCopyright'), lpBuffer, size) then
      Result.LegalCopyright := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\LegalTrademarks'), lpBuffer, size) then
      Result.LegalTrademarks := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\OriginalFileName'), lpBuffer, size) then
      Result.OriginalFileName := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\ProductName'), lpBuffer, size) then
      Result.ProductName := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\ProductVersion'), lpBuffer, size) then
      Result.ProductVersion := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\Comments'), lpBuffer, size) then
      Result.Comments := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\PrivateBuild'), lpBuffer, size) then
      Result.PrivateBuild := PChar(lpBuffer);

    if VerQueryValue(buffer, PChar('\StringFileInfo\' + lang + '\SpecialBuild'), lpBuffer, size) then
      Result.SpecialBuild := PChar(lpBuffer);
  finally
    FreeMem(buffer);
  end;
end;

end.
