unit JsonUtils;

interface

uses
  System.Json;

type
  IJsonUtils = interface
    function asStr(&property: string; inexistentPropValue: string = ''): string;
    function asInt(&property: string; inexistentPropValue: Integer = 0): Integer;
    function asReal(&property: string; inexistentPropValue: Real = 0): Real;
    function asBool(&property: string; inexistentPropValue: Boolean = False): Boolean;

    function prop(&property: string): IJsonUtils;
    function item(index: Integer = 0): IJsonUtils;

    function length: Integer;

    function getArray(&property: string): TJSONArray;
    function getArrayJs(&property: string): string;

    function getItem(index: Integer = 0): TJSONValue;
    function getItemJs(index: Integer = 0): string;
    function getItemStr(index: Integer = 0): string;

    function toJson: string;
    function toStr: string;
  end;

  TJsonUtils = class(TInterfacedObject, IJsonUtils)
  private
    parsedJson: TJSONValue;

    constructor Create;
  public
    destructor Destroy; override;

    class function ObjToJSONstring(obj: TObject): string;

    class function parse(jsonStr: string): IJsonUtils;

    function asStr(&property: string; inexistentPropValue: string = ''): string;
    function asInt(&property: string; inexistentPropValue: Integer = 0): Integer;
    function asReal(&property: string; inexistentPropValue: Real = 0): Real;
    function asBool(&property: string; inexistentPropValue: Boolean = False): Boolean;

    function prop(&property: string): IJsonUtils;
    function item(index: Integer = 0): IJsonUtils;

    function length: Integer;

    function getArray(&property: string): TJSONArray;
    function getArrayJs(&property: string): string;

    function getItem(index: Integer = 0): TJSONValue;
    function getItemJs(index: Integer = 0): string;
    function getItemStr(index: Integer = 0): string;

    function toJson: string;
    function toStr: string;
  end;

implementation

uses
  System.SysUtils, REST.Json;

function TJsonUtils.asBool(&property: string; inexistentPropValue: Boolean = False): Boolean;
var
  value: TJSONValue;
begin
  if not Assigned(parsedJson) or &property.IsEmpty then
    Exit(inexistentPropValue);

  if not(parsedJson is TJSONObject) then
    Exit(inexistentPropValue);

  value := (parsedJson as TJSONObject).GetValue(&property);

  if value = nil then
    Exit(inexistentPropValue);

  if (value is TJSONArray) or (value is TJSONObject) then
    Exit(inexistentPropValue);

  Result := value.value = 'true';
end;

function TJsonUtils.asInt(&property: string; inexistentPropValue: Integer = 0): Integer;
var
  value: TJSONValue;
begin
  if not Assigned(parsedJson) or &property.IsEmpty then
    Exit(inexistentPropValue);

  if not(parsedJson is TJSONObject) then
    Exit(inexistentPropValue);

  value := (parsedJson as TJSONObject).GetValue(&property);

  if value = nil then
    Exit(inexistentPropValue);

  if (value is TJSONArray) or (value is TJSONObject) then
    Exit(inexistentPropValue);

  Result := StrToIntDef(value.value, inexistentPropValue);
end;

function TJsonUtils.asReal(&property: string; inexistentPropValue: Real = 0): Real;
var
  value: TJSONValue;
begin
  if not Assigned(parsedJson) or &property.IsEmpty then
    Exit(inexistentPropValue);

  if not(parsedJson is TJSONObject) then
    Exit(inexistentPropValue);

  value := (parsedJson as TJSONObject).GetValue(&property);

  if value = nil then
    Exit(inexistentPropValue);

  if (value is TJSONArray) or (value is TJSONObject) then
    Exit(inexistentPropValue);

  Result := StrToFloatDef(value.value.Replace('.', '', [rfReplaceAll]), inexistentPropValue);
end;

function TJsonUtils.asStr(&property: string; inexistentPropValue: string = ''): string;
var
  value: TJSONValue;
begin
  if not Assigned(parsedJson) or &property.IsEmpty then
    Exit(inexistentPropValue);

  if not(parsedJson is TJSONObject) then
    Exit(inexistentPropValue);

  value := (parsedJson as TJSONObject).GetValue(&property);

  if value = nil then
    Exit(inexistentPropValue);

  if (value is TJSONArray) or (value is TJSONObject) then
    Exit(value.toJson);

  Result := value.value;

  if Result.ToUpper = 'NULL' then
    Exit('');
end;

constructor TJsonUtils.Create;
begin

end;

destructor TJsonUtils.Destroy;
begin
  if Assigned(parsedJson) then
    parsedJson.Free;

  inherited;
end;

function TJsonUtils.getArray(&property: string): TJSONArray;
var
  value: TJSONValue;
begin
  if not Assigned(parsedJson) or &property.IsEmpty then
    Exit(nil);

  if not(parsedJson is TJSONObject) then
    Exit(nil);

  value := (parsedJson as TJSONObject).GetValue(&property);

  if not(value is TJSONArray) then
    Exit(nil);

  Result := value as TJSONArray;
end;

function TJsonUtils.getArrayJs(&property: string): string;
var
  jsArray: TJSONArray;
begin
  jsArray := getArray(&property);

  if jsArray = nil then
    Exit('');

  Result := jsArray.toJson;
end;

function TJsonUtils.getItem(index: Integer = 0): TJSONValue;
begin
  if parsedJson = nil then
    Exit(nil);

  if not(parsedJson is TJSONArray) then
    Exit(nil);

  if (parsedJson as TJSONArray).Count < (index + 1) then
    Exit(nil);

  Result := (parsedJson as TJSONArray).Items[index];
end;

function TJsonUtils.getItemJs(index: Integer): string;
var
  jsValue: TJSONValue;
begin
  jsValue := getItem(index);

  if jsValue = nil then
    Exit('');

  Result := jsValue.toJson;
end;

function TJsonUtils.getItemStr(index: Integer): string;
var
  jsValue: TJSONValue;
begin
  jsValue := getItem(index);

  if jsValue = nil then
    Exit('');

  Result := jsValue.value;
end;

function TJsonUtils.item(index: Integer): IJsonUtils;
begin
  if parsedJson = nil then
    Exit(nil);

  if not(parsedJson is TJSONArray) then
    Exit(nil);

  if (parsedJson as TJSONArray).Count < (index + 1) then
    Exit(nil);

  Result := TJsonUtils.parse((parsedJson as TJSONArray).Items[index].toJson);
end;

function TJsonUtils.length: Integer;
begin
  if parsedJson = nil then
    Exit(-1);

  if not(parsedJson is TJSONArray) then
    Exit(-1);

  Result := (parsedJson as TJSONArray).Count;
end;

class function TJsonUtils.ObjToJSONstring(obj: TObject): string;
begin
  Result := TJson.ObjectToJsonString(obj, [joIgnoreEmptyStrings, joDateFormatUnix]);
end;

class function TJsonUtils.parse(jsonStr: string): IJsonUtils;
begin
  Result := TJsonUtils.Create;

  TJsonUtils(Result).parsedJson := TJSONObject.ParseJSONValue(jsonStr, False);
end;

function TJsonUtils.prop(&property: string): IJsonUtils;
var
  value: TJSONValue;
begin
  if not Assigned(parsedJson) or &property.IsEmpty then
    Exit(nil);

  if not(parsedJson is TJSONObject) then
    Exit(nil);

  value := (parsedJson as TJSONObject).GetValue(&property);

  if value = nil then
    Exit(nil);

  Result := TJsonUtils.parse(value.toJson);
end;

function TJsonUtils.toJson: string;
begin
  if not Assigned(parsedJson) then
    Exit('');

  Result := parsedJson.toJson;
end;

function TJsonUtils.toStr: string;
begin
  if not Assigned(parsedJson) then
    Exit('');

  Result := parsedJson.toString;
end;

end.
