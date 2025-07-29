unit JsonUtils.test;

interface

procedure TestarJsonUtils;

implementation

uses
  System.SysUtils, JsonUtils;

procedure testWithEmptyStr;
var
  jsTeste: IJsonUtils;
begin
  jsTeste := TJsonUtils.parse('');

  jsTeste.asStr('campo-inexistente');
  jsTeste.asInt('campo-inexistente');
  jsTeste.asReal('campo-inexistente');
  jsTeste.asBool('campo-inexistente');
  jsTeste.getArray('campo-inexistente');
  jsTeste.getArrayJs('campo-inexistente');
  jsTeste.getItem(1);
  jsTeste.getItemJs(1);
  jsTeste.getItemStr(1);
  jsTeste.length;

  jsTeste.prop('campo-inexistente');

  jsTeste.toJson;
  jsTeste.toStr;
end;

procedure testWithEmptyJsonObject;
var
  jsTeste: IJsonUtils;
begin
  jsTeste := TJsonUtils.parse('{ }');

  jsTeste.asStr('campo-inexistente');
  jsTeste.asInt('campo-inexistente');
  jsTeste.asReal('campo-inexistente');
  jsTeste.asBool('campo-inexistente');
  jsTeste.getArray('campo-inexistente');
  jsTeste.getArrayJs('campo-inexistente');
  jsTeste.getItem(1);
  jsTeste.getItemJs(1);
  jsTeste.getItemStr(1);
  jsTeste.length;

  jsTeste.prop('campo-inexistente');

  jsTeste.toJson;
  jsTeste.toStr;
end;

procedure testWithEmptyJsonArray;
var
  jsTeste: IJsonUtils;
begin
  jsTeste := TJsonUtils.parse('[ ]');

  jsTeste.asStr('campo-inexistente');
  jsTeste.asInt('campo-inexistente');
  jsTeste.asReal('campo-inexistente');
  jsTeste.asBool('campo-inexistente');
  jsTeste.getArray('campo-inexistente');
  jsTeste.getArrayJs('campo-inexistente');
  jsTeste.getItem(1);
  jsTeste.getItemJs(1);
  jsTeste.getItemStr(1);
  jsTeste.length;

  jsTeste.prop('campo-inexistente');

  jsTeste.toJson;
  jsTeste.toStr;
end;

procedure testWithJsonArray;
var
  jsTeste: IJsonUtils;
  arrayValue: string;
begin
  jsTeste := TJsonUtils.parse('[ "valor1" , "valor2", 14 ]');

  jsTeste.asStr('campo-inexistente');
  jsTeste.asInt('campo-inexistente');
  jsTeste.asReal('campo-inexistente');
  jsTeste.asBool('campo-inexistente');
  jsTeste.getArray('campo-inexistente');
  jsTeste.getArrayJs('campo-inexistente');
  jsTeste.length;

  arrayValue := jsTeste.getItem(1).Value;
  arrayValue := jsTeste.getItem(2).Value;
  jsTeste.getItemJs(1);
  jsTeste.getItemStr(1);

  jsTeste.prop('campo-inexistente');

  jsTeste.toJson;
  jsTeste.toStr;
end;

procedure testWithObjectAndVarietsValues;
var
  jsTeste: IJsonUtils;
begin
  jsTeste := TJsonUtils.parse('{ "campo1" : "valor1/com barra" '
      + ', "campo2" : { "campo3" : "valor2" } '
      + ', "campo4" : [{ "campo5" : "valor3" },{ "campo6" : "valor4" }] '
      + ', "campo5" : "campo \/com backslash" '
      + ', "campo7" : true '
      + ', "campo8" : 10 '
      + ', "campo9" : false '
      + ', "campo10" : null '
      + ', "campo11" : 5.99 }');

  jsTeste.asStr('campo-inexistente');
  jsTeste.asStr('campo1');
  jsTeste.asStr('campo2');
  jsTeste.asStr('campo4');
  jsTeste.asStr('campo5');
  jsTeste.asStr('campo10');

  jsTeste.asInt('campo-inexistente');
  jsTeste.asInt('campo1');
  jsTeste.asInt('campo2');
  jsTeste.asInt('campo4');
  jsTeste.asInt('campo8');
  jsTeste.asInt('campo11');

  jsTeste.asReal('campo-inexistente');
  jsTeste.asReal('campo1');
  jsTeste.asReal('campo2');
  jsTeste.asReal('campo4');
  jsTeste.asReal('campo8');
  jsTeste.asReal('campo11');

  jsTeste.asBool('campo-inexistente');
  jsTeste.asBool('campo5');
  jsTeste.asBool('campo7');
  jsTeste.asBool('campo8');
  jsTeste.asBool('campo9');
  jsTeste.asBool('campo10');

  jsTeste.getArray('campo-inexistente');
  jsTeste.getArray('campo1');
  jsTeste.getArray('campo2');
  jsTeste.getArray('campo4');

  jsTeste.getArrayJs('campo-inexistente');
  jsTeste.getArrayJs('campo1');
  jsTeste.getArrayJs('campo2');
  jsTeste.getArrayJs('campo4');

  jsTeste.getItem(1);
  jsTeste.getItemJs(1);
  jsTeste.getItemStr(1);
  jsTeste.length;

  jsTeste.prop('campo-inexistente');
  jsTeste.prop('campo2').asStr('campo3');
  jsTeste.prop('campo4').item(1).asStr('campo6');
  jsTeste.prop('campo4').length;

  jsTeste.toJson;
  jsTeste.toStr;
end;

procedure TestarJsonUtils;
begin
  testWithEmptyStr;
  testWithEmptyJsonObject;
  testWithEmptyJsonArray;
  testWithJsonArray;
  testWithObjectAndVarietsValues;
end;

end.
