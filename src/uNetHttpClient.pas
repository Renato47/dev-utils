unit uNetHttpClient;

interface

uses
  System.Net.URLClient, //clear warning in THTTPClient.SetContentType
  System.NetConsts, //clear warning in THTTPClient.SetContentType
  System.Net.HttpClient, System.Net.Mime;

type
  TKeyValuePair = record
    key: string;
    value: string;
  end;

  IQueryParams = interface
    function add(key, value: string): IQueryParams;
    function getContent: string;
  end;

  TQueryParams = class(TInterfacedObject, IQueryParams)
  private
    fKeyValuePairs: TArray<TKeyValuePair>;
  public
    class function New: IQueryParams;

    function add(key, value: string): IQueryParams;
    function getContent: string;
  end;

  TField = record
    key: string;
    value: string;
    fieldType: string;
  end;

  IFormData = interface
    function getMultipartObj: TMultipartFormData;
    function fields: TArray<TField>;

    function addField(const fieldName, value: string): IFormData;
    function addFile(const fieldName, filePath: string): IFormData;
  end;

  TFormData = class(TInterfacedObject, IFormData)
  private
    fFields: TArray<TField>;
    fMultipart: TMultipartFormData;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IFormData;

    function getMultipartObj: TMultipartFormData;
    function fields: TArray<TField>;

    function addField(const fieldName, value: string): IFormData;
    function addFile(const fieldName, filePath: string): IFormData;
  end;

  IHttpResponse = interface
    function requestInfo: string;

    function statusCode: integer;
    function data: string;

    function success: boolean;
    procedure saveFile(filePath: string);
  end;

  THttpResponse = class(TInterfacedObject, IHttpResponse)
  private
    fRequestInfo: string;

    fResponse: System.Net.HttpClient.IHttpResponse;
  public
    constructor Create(response: System.Net.HttpClient.IHttpResponse; info: string);

    function requestInfo: string;

    function statusCode: integer;
    function data: string;

    function success: boolean;
    procedure saveFile(filePath: string);
  end;

  IHttpClient = interface
    function addHeader(key, value: string): IHttpClient;
    function addCommonHeader(key, value: string): IHttpClient;

    function basicAuthentication(username, password: string): IHttpClient;

    function delete(url: string): IHttpResponse;

    function get(url: string): IHttpResponse;

    function post(url, rawText: string): IHttpResponse; overload;
    function post(url: string; queryParams: IQueryParams): IHttpResponse; overload;
    function post(url: string; formData: IFormData): IHttpResponse; overload;

    function put(url, rawText: string): IHttpResponse; overload;
    function put(url, key, value: string): IHttpResponse; overload;
    function put(url: string; keyValuePairs: TArray<TKeyValuePair>): IHttpResponse; overload;

    function patch(url, rawText: string): IHttpResponse;
  end;

  THttpRequest = class(TInterfacedObject, IHttpClient)
  private
    fRequest: THttpClient;

    fCommonHeaders: System.Net.URLClient.TNameValueArray;
    fHeaders: System.Net.URLClient.TNameValueArray;

    procedure joinHeaders;
    procedure clearHeaders;

    function generateRequestInfo(method, url, contentAsString: string; queryParams: IQueryParams;
      formData: IFormData = nil): string;
  public
    constructor Create;
    destructor Destroy; override;

    class function New: IHttpClient;

    function addHeader(key, value: string): IHttpClient;
    function addCommonHeader(key, value: string): IHttpClient;

    function basicAuthentication(username, password: string): IHttpClient;

    function delete(url: string): IHttpResponse;

    function get(url: string): IHttpResponse;

    function post(url, rawText: string): IHttpResponse; overload;
    function post(url: string; queryParams: IQueryParams): IHttpResponse; overload;
    function post(url: string; formData: IFormData): IHttpResponse; overload;

    function put(url, rawText: string): IHttpResponse; overload;
    function put(url, key, value: string): IHttpResponse; overload;
    function put(url: string; keyValuePairs: TArray<TKeyValuePair>): IHttpResponse; overload;

    function patch(url, rawText: string): IHttpResponse;
  end;

implementation

uses
  System.SysUtils, System.Classes, System.NetEncoding, System.TypInfo;

function THttpRequest.addCommonHeader(key, value: string): IHttpClient;
begin
  result := self;

  setLength(fCommonHeaders, length(fCommonHeaders) + 1);
  fCommonHeaders[high(fCommonHeaders)] := TNameValuePair.Create(key, value);
end;

function THttpRequest.addHeader(key, value: string): IHttpClient;
begin
  result := self;

  setLength(fHeaders, length(fHeaders) + 1);
  fHeaders[high(fHeaders)] := TNameValuePair.Create(key, value);
end;

function THttpRequest.basicAuthentication(username, password: string): IHttpClient;
begin
  result := self.addHeader('Authorization', 'Basic ' + TNetEncoding.Base64.encode(username + ':' + password));
end;

procedure THttpRequest.clearHeaders;
begin
  setLength(fHeaders, 0);
end;

procedure THttpRequest.joinHeaders;
var
  nCommon, iCount: integer;
begin
  iCount := length(fHeaders);
  setLength(fHeaders, iCount + length(fCommonHeaders));

  for nCommon := 0 to high(fCommonHeaders) do
    fHeaders[iCount + nCommon] := fCommonHeaders[nCommon];
end;

constructor THttpRequest.Create;
begin
  fRequest := THttpClient.Create;

  fRequest.AcceptCharSet := 'utf-8';
  fRequest.AcceptEncoding := 'utf-8';
end;

function THttpRequest.delete(url: string): IHttpResponse;
begin
  joinHeaders;

  try
    result := THttpResponse.Create(
      fRequest.delete(url, nil, fHeaders),
      generateRequestInfo('DELETE', url, '', nil));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  clearHeaders;
end;

destructor THttpRequest.Destroy;
begin
  fRequest.free;

  inherited;
end;

function THttpRequest.generateRequestInfo(method, url, contentAsString: string; queryParams: IQueryParams;
  formData: IFormData = nil): string;
var
  rURI: TURI;
  pair: TNameValuePair;
  rField: TField;
begin
  rURI := TURI.Create(url);

  result := method + ' ' + rURI.Path + ' HTTP/1.1'
    + sLineBreak + 'Host: ' + rURI.host;

  if rURI.port <> 80 then
    result := result + ':' + rURI.port.toString;

  for pair in fHeaders do
    result := result + sLineBreak + pair.name + ': ' + pair.value;

  result := result + sLineBreak + 'Content-Type: ';

  if queryParams <> nil then begin
    result := result + sLineBreak +
      'Query Params: ' + queryParams.getContent;
  end
  else if formData <> nil then begin
    result := result + formData.getMultipartObj.MimeTypeHeader + sLineBreak + sLineBreak;

    if length(formData.fields) > 0 then
      result := result + '--' + formData.getMultipartObj.MimeTypeHeader.replace('multipart/form-data; boundary=', '');

    for rField in formData.fields do begin
      if rField.fieldType = 'file' then
        result := result + sLineBreak +
          'Content-Disposition: form-data; name="' + rField.key + '"; filename="' + extractFileName(rField.value) + '"'
        //+ sLineBreak + 'Content-Type: image/png'
          + sLineBreak + sLineBreak + '(data)'
      else
        result := result + sLineBreak
          + 'Content-Disposition: form-data; name="' + rField.key + '"' + sLineBreak
          + sLineBreak
          + rField.value;

      result := result + sLineBreak
        + '--' + formData.getMultipartObj.MimeTypeHeader.replace('multipart/form-data; boundary=', '');
    end;
  end
  else if not fRequest.ContentType.isEmpty then
    result := result + fRequest.ContentType
  else
    result := result + 'none';

  if not contentAsString.isEmpty then
    result := result + sLineBreak + sLineBreak + '(uncoded)' + sLineBreak + contentAsString;
end;

function THttpRequest.get(url: string): IHttpResponse;
begin
  joinHeaders;

  try
    result := THttpResponse.Create(
      fRequest.get(url, nil, fHeaders),
      generateRequestInfo('GET', url, '', nil));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  clearHeaders;
end;

class function THttpRequest.New: IHttpClient;
begin
  result := THttpRequest.Create;
end;

function THttpRequest.patch(url, rawText: string): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  fRequest.ContentType := 'application/json';

  joinHeaders;

  sStreamSend := TStringStream.Create(rawText, TEncoding.UTF8);

  try
    result := THttpResponse.Create(
      fRequest.patch(url, sStreamSend, nil, fHeaders),
      generateRequestInfo('PATCH', url, sStreamSend.dataString, nil));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  sStreamSend.free;

  clearHeaders;
end;

function THttpRequest.post(url: string; queryParams: IQueryParams): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  joinHeaders;

  sStreamSend := TStringStream.Create(queryParams.getContent, TEncoding.UTF8);

  fRequest.ContentType := 'application/x-www-form-urlencoded';

  try
    result := THttpResponse.Create(
      fRequest.post(url, sStreamSend, nil, fHeaders),
      generateRequestInfo('POST', url, sStreamSend.dataString, queryParams));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  sStreamSend.free;

  clearHeaders;
end;

function THttpRequest.put(url, key, value: string): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  joinHeaders;

  sStreamSend := TStringStream.Create(key + '=' + value, TEncoding.UTF8);

  fRequest.ContentType := 'application/x-www-form-urlencoded';

  try
    result := THttpResponse.Create(
      fRequest.put(url, sStreamSend, nil, fHeaders),
      generateRequestInfo('PUT', url, sStreamSend.dataString, nil));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  sStreamSend.free;

  clearHeaders;
end;

function THttpRequest.put(url: string; keyValuePairs: TArray<TKeyValuePair>): IHttpResponse;
var
  sStreamSend: TStringStream;
  rPair: TKeyValuePair;
  sContent: string;
begin
  joinHeaders;

  sContent := '';

  for rPair in keyValuePairs do begin
    if not sContent.isEmpty then
      sContent := sContent + '&';

    sContent := sContent + rPair.key + '=' + rPair.value;
  end;

  sStreamSend := TStringStream.Create(sContent, TEncoding.UTF8);

  fRequest.ContentType := 'application/x-www-form-urlencoded';

  try
    result := THttpResponse.Create(
      fRequest.put(url, sStreamSend, nil, fHeaders),
      generateRequestInfo('PUT', url, sStreamSend.dataString, nil));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  sStreamSend.free;

  clearHeaders;
end;

function THttpRequest.post(url, rawText: string): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  fRequest.ContentType := 'application/json';

  joinHeaders;

  sStreamSend := TStringStream.Create(rawText, TEncoding.UTF8);

  try
    result := THttpResponse.Create(
      fRequest.post(url, sStreamSend, nil, fHeaders),
      generateRequestInfo('POST', url, sStreamSend.dataString, nil));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  sStreamSend.free;

  clearHeaders;
end;

function THttpRequest.put(url, rawText: string): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  fRequest.ContentType := 'application/json';

  joinHeaders;

  sStreamSend := TStringStream.Create(rawText, TEncoding.UTF8);

  try
    result := THttpResponse.Create(
      fRequest.put(url, sStreamSend, nil, fHeaders),
      generateRequestInfo('PUT', url, sStreamSend.dataString, nil));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  sStreamSend.free;

  clearHeaders;
end;

constructor THttpResponse.Create(response: System.Net.HttpClient.IHttpResponse; info: string);
begin
  fResponse := response;

  fRequestInfo := info;
end;

function THttpResponse.data: string;
begin
  if fResponse = nil then
    exit('');

  result := '';

  if fResponse.headerValue['Content-type'].contains('application/json') then
    result := fResponse.contentAsString;
end;

function THttpResponse.requestInfo: string;
begin
  result := fRequestInfo;
end;

procedure THttpResponse.saveFile(filePath: string);
begin
  if fResponse = nil then
    exit;

  if fResponse.ContentStream = nil then
    exit;

  TMemoryStream(fResponse.ContentStream).saveToFile(filePath);
end;

function THttpResponse.statusCode: integer;
begin
  if fResponse = nil then
    exit(0);

  result := fResponse.statusCode;
end;

function THttpResponse.success: boolean;
begin
  result := (statusCode >= 200) and (statusCode < 300);
end;

function THttpRequest.post(url: string; formData: IFormData): IHttpResponse;
begin
  joinHeaders;

  fRequest.ContentType := ''; //limpar ContentType para usar header do formdata

  try
    result := THttpResponse.Create(
      fRequest.post(url, formData.getMultipartObj, nil, fHeaders),
      generateRequestInfo('POST', url, '', nil, formData));
  except
    on err: Exception do
      result := THttpResponse.Create(nil, 'Erro ao acessar [' + url + ']' + sLineBreak + err.message);
  end;

  clearHeaders;
end;

function TFormData.addField(const fieldName, value: string): IFormData;
begin
  result := self;

  fMultipart.addField(fieldName, value);

  setLength(fFields, length(fFields) + 1);
  fields[high(fFields)].key := fieldName;
  fields[high(fFields)].value := value;
  fields[high(fFields)].fieldType := 'text';
end;

function TFormData.addFile(const fieldName, filePath: string): IFormData;
begin
  result := self;

  fMultipart.addFile(fieldName, filePath);

  setLength(fFields, length(fFields) + 1);
  fields[high(fFields)].key := fieldName;
  fields[high(fFields)].value := filePath;
  fields[high(fFields)].fieldType := 'file';
end;

constructor TFormData.Create;
begin
  fMultipart := TMultipartFormData.Create;
end;

destructor TFormData.Destroy;
begin
  fMultipart.free;

  inherited;
end;

function TFormData.fields: TArray<TField>;
begin
  result := fFields;
end;

function TFormData.getMultipartObj: TMultipartFormData;
begin
  result := fMultipart;
end;

class function TFormData.New: IFormData;
begin
  result := TFormData.Create;
end;

function TQueryParams.add(key, value: string): IQueryParams;
begin
  result := self;

  setLength(fKeyValuePairs, length(fKeyValuePairs) + 1);

  fKeyValuePairs[high(fKeyValuePairs)].key := key;
  fKeyValuePairs[high(fKeyValuePairs)].value := value;
end;

function TQueryParams.getContent: string;
var
  rPair: TKeyValuePair;
begin
  result := '';

  for rPair in fKeyValuePairs do begin
    if not result.isEmpty then
      result := result + '&';

    result := result + rPair.key + '=' + rPair.value;
  end;
end;

class function TQueryParams.New: IQueryParams;
begin
  result := TQueryParams.Create;
end;

end.
