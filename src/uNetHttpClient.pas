unit uNetHttpClient;

interface

uses
  System.Net.URLClient, //clear warning in THTTPClient.SetContentType
  System.NetConsts, //clear warning in THTTPClient.SetContentType
  System.Net.HttpClient, System.Net.Mime;

type
  TKeyValuePair = record
    Key: string;
    Value: string;
  end;

  IFormUrlFields = interface
    function Add(aKey, aValue: string): IFormUrlFields;
    function GetContent: string;
  end;

  TFormUrlFields = class(TInterfacedObject, IFormUrlFields)
  private
    fKeyValuePairs: TArray<TKeyValuePair>;
  public
    class function New: IFormUrlFields;

    function Add(aKey, aValue: string): IFormUrlFields;
    function GetContent: string;
  end;

  TField = record
    Key: string;
    Value: string;
    FieldType: string;
  end;

  IFormData = interface
    function GetMultipartObj: TMultipartFormData;
    function Fields: TArray<TField>;

    function AddField(const AField, aValue: string): IFormData;
    function AddFile(const AFieldName, AFilePath: string): IFormData;
  end;

  TFormData = class(TInterfacedObject, IFormData)
  private
    fFields: TArray<TField>;
    fMultipart: TMultipartFormData;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IFormData;

    function GetMultipartObj: TMultipartFormData;
    function Fields: TArray<TField>;

    function AddField(const AField, aValue: string): IFormData;
    function AddFile(const AFieldName, AFilePath: string): IFormData;
  end;

  IHttpResponse = interface
    function RequestInfo: string;

    function StatusCode: Integer;
    function Data: string;

    function Success: Boolean;
    procedure SaveFile(AFilePath: string);
  end;

  IHttpClient = interface
    function AddHeader(aKey, aValue: string): IHttpClient;
    function AddCommonHeader(aKey, aValue: string): IHttpClient;

    function BasicAuthentication(aUsername, aPassword: string): IHttpClient;

    function Delete(aURL: string): IHttpResponse;

    function Get(aURL: string): IHttpResponse;

    function Post(aURL, aRawText: string): IHttpResponse; overload;
    function Post(aURL: string; aFormUrlFields: IFormUrlFields): IHttpResponse; overload;
    function Post(aURL: string; aFormData: IFormData): IHttpResponse; overload;

    function Put(aURL, aRawText: string): IHttpResponse; overload;
    function Put(aURL, aKey, aValue: string): IHttpResponse; overload;
    function Put(aURL: string; aKeyValuePairs: TArray<TKeyValuePair>): IHttpResponse; overload;

    function Patch(aURL, aRawText: string): IHttpResponse;
  end;

  THttpResponse = class(TInterfacedObject, IHttpResponse)
  private
    fRequestInfo: string;

    fResponse: System.Net.HttpClient.IHttpResponse;
  public
    constructor Create(aResponse: System.Net.HttpClient.IHttpResponse; aInfo: string);

    function RequestInfo: string;

    function StatusCode: Integer;
    function Data: string;

    function Success: Boolean;
    procedure SaveFile(AFilePath: string);
  end;

  THTTPRequest = class(TInterfacedObject, IHttpClient)
  private
    fRequest: THttpClient;

    fCommonHeaders: System.Net.URLClient.TNameValueArray;
    fHeaders: System.Net.URLClient.TNameValueArray;

    procedure JoinHeaders;
    procedure ClearHeaders;

    function GenerateRequestInfo(aMethod, aURL, aContentAsString: string; oFormData: IFormData = nil): string;
  public
    constructor Create;
    destructor Destroy; override;

    class function New: IHttpClient;

    function AddHeader(aKey, aValue: string): IHttpClient;
    function AddCommonHeader(aKey, aValue: string): IHttpClient;

    function BasicAuthentication(aUsername, aPassword: string): IHttpClient;

    function Delete(aURL: string): IHttpResponse;

    function Get(aURL: string): IHttpResponse;

    function Post(aURL, aRawText: string): IHttpResponse; overload;
    function Post(aURL: string; aFormUrlFields: IFormUrlFields): IHttpResponse; overload;
    function Post(aURL: string; aFormData: IFormData): IHttpResponse; overload;

    function Put(aURL, aRawText: string): IHttpResponse; overload;
    function Put(aURL, aKey, aValue: string): IHttpResponse; overload;
    function Put(aURL: string; aKeyValuePairs: TArray<TKeyValuePair>): IHttpResponse; overload;

    function Patch(aURL, aRawText: string): IHttpResponse;
  end;

implementation

uses
  System.SysUtils, System.Classes, System.NetEncoding, System.TypInfo;

function THTTPRequest.AddCommonHeader(aKey, aValue: string): IHttpClient;
begin
  Result := Self;

  SetLength(fCommonHeaders, Length(fCommonHeaders) + 1);
  fCommonHeaders[high(fCommonHeaders)] := TNameValuePair.Create(aKey, aValue);
end;

function THTTPRequest.AddHeader(aKey, aValue: string): IHttpClient;
begin
  Result := Self;

  SetLength(fHeaders, Length(fHeaders) + 1);
  fHeaders[high(fHeaders)] := TNameValuePair.Create(aKey, aValue);
end;

function THTTPRequest.BasicAuthentication(aUsername, aPassword: string): IHttpClient;
begin
  Result := Self.AddHeader('Authorization', 'Basic ' + TNetEncoding.Base64.Encode(aUsername + ':' + aPassword));
end;

procedure THTTPRequest.ClearHeaders;
begin
  SetLength(fHeaders, 0);
end;

procedure THTTPRequest.JoinHeaders;
var
  nCommon, iCount: Integer;
begin
  iCount := Length(fHeaders);
  SetLength(fHeaders, iCount + Length(fCommonHeaders));

  for nCommon := 0 to high(fCommonHeaders) do
    fHeaders[iCount + nCommon] := fCommonHeaders[nCommon];
end;

constructor THTTPRequest.Create;
begin
  fRequest := THttpClient.Create;

  fRequest.AcceptCharSet := 'utf-8';
  fRequest.AcceptEncoding := 'utf-8';
end;

function THTTPRequest.Delete(aURL: string): IHttpResponse;
begin
  JoinHeaders;

  try
    Result := THttpResponse.Create(
      fRequest.Delete(aURL, nil, fHeaders),
      GenerateRequestInfo('DELETE', aURL, ''));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  ClearHeaders;
end;

destructor THTTPRequest.Destroy;
begin
  fRequest.Free;

  inherited;
end;

function THTTPRequest.GenerateRequestInfo(aMethod, aURL, aContentAsString: string; oFormData: IFormData = nil): string;
var
  rURI: TURI;
  pair: TNameValuePair;
  rField: TField;
begin
  rURI := TURI.Create(aURL);

  Result := aMethod + ' ' + rURI.Path + ' HTTP/1.1'
    + sLineBreak + 'Host: ' + rURI.Host;

  if rURI.Port <> 80 then
    Result := Result + ':' + rURI.Port.ToString;

  for pair in fHeaders do
    Result := Result + sLineBreak + pair.Name + ': ' + pair.Value;

  Result := Result + sLineBreak + 'Content-Type: ';

  if oFormData <> nil then begin
    Result := Result + oFormData.GetMultipartObj.MimeTypeHeader + sLineBreak + sLineBreak;

    if Length(oFormData.Fields) > 0 then
      Result := Result + '--' + oFormData.GetMultipartObj.MimeTypeHeader.Replace('multipart/form-data; boundary=', '');

    for rField in oFormData.Fields do begin
      if rField.FieldType = 'file' then
        Result := Result + sLineBreak +
          'Content-Disposition: form-data; name="' + rField.Key + '"; filename="' + ExtractFileName(rField.Value) + '"'
        //+ sLineBreak + 'Content-Type: image/png'
          + sLineBreak + sLineBreak + '(data)'
      else
        Result := Result + sLineBreak
          + 'Content-Disposition: form-data; name="' + rField.Key + '"' + sLineBreak
          + sLineBreak
          + rField.Value;

      Result := Result + sLineBreak
        + '--' + oFormData.GetMultipartObj.MimeTypeHeader.Replace('multipart/form-data; boundary=', '');
    end;
  end
  else if not fRequest.ContentType.IsEmpty then
    Result := Result + fRequest.ContentType
  else
    Result := Result + 'none';

  if not aContentAsString.IsEmpty then
    Result := Result + sLineBreak + sLineBreak + '(uncoded)' + sLineBreak + aContentAsString;
end;

function THTTPRequest.Get(aURL: string): IHttpResponse;
begin
  JoinHeaders;

  try
    Result := THttpResponse.Create(
      fRequest.Get(aURL, nil, fHeaders),
      GenerateRequestInfo('GET', aURL, ''));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  ClearHeaders;
end;

class function THTTPRequest.New: IHttpClient;
begin
  Result := THTTPRequest.Create;
end;

function THTTPRequest.Patch(aURL, aRawText: string): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  fRequest.ContentType := 'application/json';

  JoinHeaders;

  sStreamSend := TStringStream.Create(aRawText, TEncoding.UTF8);

  try
    Result := THttpResponse.Create(
      fRequest.Patch(aURL, sStreamSend, nil, fHeaders),
      GenerateRequestInfo('PATCH', aURL, sStreamSend.DataString));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  sStreamSend.Free;

  ClearHeaders;
end;

function THTTPRequest.Post(aURL: string; aFormUrlFields: IFormUrlFields): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  JoinHeaders;

  sStreamSend := TStringStream.Create(aFormUrlFields.GetContent, TEncoding.UTF8);

  fRequest.ContentType := 'application/x-www-form-urlencoded';

  try
    Result := THttpResponse.Create(
      fRequest.Post(aURL, sStreamSend, nil, fHeaders),
      GenerateRequestInfo('POST', aURL, sStreamSend.DataString));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  sStreamSend.Free;

  ClearHeaders;
end;

function THTTPRequest.Put(aURL, aKey, aValue: string): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  JoinHeaders;

  sStreamSend := TStringStream.Create(aKey + '=' + aValue, TEncoding.UTF8);

  fRequest.ContentType := 'application/x-www-form-urlencoded';

  try
    Result := THttpResponse.Create(
      fRequest.Put(aURL, sStreamSend, nil, fHeaders),
      GenerateRequestInfo('PUT', aURL, sStreamSend.DataString));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  sStreamSend.Free;

  ClearHeaders;
end;

function THTTPRequest.Put(aURL: string; aKeyValuePairs: TArray<TKeyValuePair>): IHttpResponse;
var
  sStreamSend: TStringStream;
  rPair: TKeyValuePair;
  sContent: string;
begin
  JoinHeaders;

  sContent := '';

  for rPair in aKeyValuePairs do begin
    if not sContent.IsEmpty then
      sContent := sContent + '&';

    sContent := sContent + rPair.Key + '=' + rPair.Value;
  end;

  sStreamSend := TStringStream.Create(sContent, TEncoding.UTF8);

  fRequest.ContentType := 'application/x-www-form-urlencoded';

  try
    Result := THttpResponse.Create(
      fRequest.Put(aURL, sStreamSend, nil, fHeaders),
      GenerateRequestInfo('PUT', aURL, sStreamSend.DataString));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  sStreamSend.Free;

  ClearHeaders;
end;

function THTTPRequest.Post(aURL, aRawText: string): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  fRequest.ContentType := 'application/json';

  JoinHeaders;

  sStreamSend := TStringStream.Create(aRawText, TEncoding.UTF8);

  try
    Result := THttpResponse.Create(
      fRequest.Post(aURL, sStreamSend, nil, fHeaders),
      GenerateRequestInfo('POST', aURL, sStreamSend.DataString));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  sStreamSend.Free;

  ClearHeaders;
end;

function THTTPRequest.Put(aURL, aRawText: string): IHttpResponse;
var
  sStreamSend: TStringStream;
begin
  fRequest.ContentType := 'application/json';

  JoinHeaders;

  sStreamSend := TStringStream.Create(aRawText, TEncoding.UTF8);

  try
    Result := THttpResponse.Create(
      fRequest.Put(aURL, sStreamSend, nil, fHeaders),
      GenerateRequestInfo('PUT', aURL, sStreamSend.DataString));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  sStreamSend.Free;

  ClearHeaders;
end;

constructor THttpResponse.Create(aResponse: System.Net.HttpClient.IHttpResponse; aInfo: string);
begin
  fResponse := aResponse;

  fRequestInfo := aInfo;
end;

function THttpResponse.Data: string;
begin
  if fResponse = nil then
    Exit('');

  Result := '';

  if fResponse.HeaderValue['Content-type'].Contains('application/json') then
    Result := fResponse.ContentAsString;
end;

function THttpResponse.RequestInfo: string;
begin
  Result := fRequestInfo;
end;

procedure THttpResponse.SaveFile(AFilePath: string);
begin
  if fResponse = nil then
    Exit;

  if fResponse.ContentStream = nil then
    Exit;

  TMemoryStream(fResponse.ContentStream).SaveToFile(AFilePath);
end;

function THttpResponse.StatusCode: Integer;
begin
  if fResponse = nil then
    Exit(0);

  Result := fResponse.StatusCode;
end;

function THttpResponse.Success: Boolean;
begin
  Result := (StatusCode >= 200) and (StatusCode < 300);
end;

function THTTPRequest.Post(aURL: string; aFormData: IFormData): IHttpResponse;
begin
  JoinHeaders;

  fRequest.ContentType := ''; //limpar ContentType para usar header do formdata

  try
    Result := THttpResponse.Create(
      fRequest.Post(aURL, aFormData.GetMultipartObj, nil, fHeaders),
      GenerateRequestInfo('POST', aURL, '', aFormData));
  except
    Result := THttpResponse.Create(nil, 'Erro ao acessar [' + aURL + ']');
  end;

  ClearHeaders;
end;

function TFormData.AddField(const AField, aValue: string): IFormData;
begin
  Result := Self;

  fMultipart.AddField(AField, aValue);

  SetLength(fFields, Length(fFields) + 1);
  Fields[high(fFields)].Key := AField;
  Fields[high(fFields)].Value := aValue;
  Fields[high(fFields)].FieldType := 'text';
end;

function TFormData.AddFile(const AFieldName, AFilePath: string): IFormData;
begin
  Result := Self;

  fMultipart.AddFile(AFieldName, AFilePath);

  SetLength(fFields, Length(fFields) + 1);
  Fields[high(fFields)].Key := AFieldName;
  Fields[high(fFields)].Value := AFilePath;
  Fields[high(fFields)].FieldType := 'file';
end;

constructor TFormData.Create;
begin
  fMultipart := TMultipartFormData.Create;
end;

destructor TFormData.Destroy;
begin
  fMultipart.Free;

  inherited;
end;

function TFormData.Fields: TArray<TField>;
begin
  Result := fFields;
end;

function TFormData.GetMultipartObj: TMultipartFormData;
begin
  Result := fMultipart;
end;

class function TFormData.New: IFormData;
begin
  Result := TFormData.Create;
end;

function TFormUrlFields.Add(aKey, aValue: string): IFormUrlFields;
begin
  Result := Self;
end;

function TFormUrlFields.GetContent: string;
var
  rPair: TKeyValuePair;
begin
  Result := '';

  for rPair in fKeyValuePairs do begin
    if not Result.IsEmpty then
      Result := Result + '&';

    Result := Result + rPair.Key + '=' + rPair.Value;
  end;
end;

class function TFormUrlFields.New: IFormUrlFields;
begin
  Result := TFormUrlFields.Create;
end;

end.
