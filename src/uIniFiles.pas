unit uIniFiles;

interface

function WriteIni(aFilePath, aSection: string; aIdentification, aValue: array of string): Boolean;
function ReadIni(aFilePath, aSection, aIdentification: string; aDefValue: string = ''): string;

implementation

uses
  System.SysUtils, System.IniFiles;

function WriteIni(aFilePath, aSection: string; aIdentification, aValue: array of string): Boolean;
var
  ArqIni: TIniFile;
  nIdent: Integer;
begin
  if Length(aIdentification) <> Length(aValue) then
    raise Exception.Create('Error in WriteIni: Identificaion langth differs Value length');

  if ExtractFilePath(aFilePath).Trim.IsEmpty then
    aFilePath := ExtractFilePath(ParamStr(0)) + aFilePath;

  if ExtractFileExt(aFilePath) <> '.ini' then
    aFilePath := ChangeFileExt(aFilePath, '.ini');

  try
    ArqIni := TIniFile.Create(aFilePath);

    try
      for nIdent := 0 to Pred(Length(aIdentification)) do
        ArqIni.WriteString(aSection, aIdentification[nIdent], aValue[nIdent]);
    finally
      ArqIni.Free;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function ReadIni(aFilePath, aSection, aIdentification: string; aDefValue: string = ''): string;
var
  ArqIni: TIniFile;
begin
  Result := aDefValue;

  if ExtractFilePath(aFilePath).Trim.IsEmpty then
    aFilePath := ExtractFilePath(ParamStr(0)) + aFilePath;

  if ExtractFileExt(aFilePath).IsEmpty then
    aFilePath := ChangeFileExt(aFilePath, '.ini');

  if not FileExists(aFilePath) then
    Exit;

  ArqIni := TIniFile.Create(aFilePath);

  try
    Result := ArqIni.ReadString(aSection, aIdentification, aDefValue);
  finally
    ArqIni.Free;
  end;

  if Result.Trim.IsEmpty then
    Result := aDefValue;
end;

end.
