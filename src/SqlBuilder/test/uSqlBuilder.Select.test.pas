unit uSqlBuilder.Select.test;

interface

procedure SelectTest;

implementation

uses
  uSqlBuilder, uCompare;

procedure SelectTest;
var
  sSqlCompare, sSqlBuilder: string;
begin
  sSqlCompare := 'SELECT C.CODIGO,C.NOME FROM CLIENTES C';
  sSqlBuilder := SQL.Select.Column('C.CODIGO').Column('C.NOME').From('CLIENTES C').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //AllColumns
  sSqlCompare := 'SELECT * FROM GRUPOS';
  sSqlBuilder := SQL.Select.AllColumns.From('GRUPOS').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //Distinct
  sSqlCompare := 'SELECT DISTINCT DESCRICAO FROM GRUPOS';
  sSqlBuilder := SQL.Select.Distinct.Column('DESCRICAO').From('GRUPOS').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //First
  sSqlCompare := 'SELECT FIRST 5 DESCRICAO FROM GRUPOS';
  sSqlBuilder := SQL.Select.First(5).Column('DESCRICAO').From('GRUPOS').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //Skip
  sSqlCompare := 'SELECT FIRST 1 SKIP 10 DESCRICAO FROM GRUPOS';
  sSqlBuilder := SQL.Select.First(1).Skip(10).Column('DESCRICAO').From('GRUPOS').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //Cast
  sSqlCompare := 'SELECT CAST(V.DATA_HORA AS DATE) AS DATA FROM VENDAS V';
  sSqlBuilder := SQL.Select.Column('V.DATA_HORA').Cast('DATE', 'DATA').From('VENDAS V').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //Where aConditions
  sSqlCompare := 'SELECT * FROM GRUPOS WHERE CODIGO > 0';
  sSqlBuilder := SQL.Select.AllColumns.From('GRUPOS').Where('CODIGO > 0').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //Where ISqlWhere
  sSqlCompare := 'SELECT * FROM GRUPOS WHERE CODIGO > 0';
  sSqlBuilder := SQL.Select.AllColumns.From('GRUPOS').Where(SQL.Where.Column('CODIGO').Greater(0)).ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //GroupBy
  sSqlCompare := 'SELECT COUNT CODIGO FROM GRUPOS GROUP BY CODIGO';
  sSqlBuilder := SQL.Select.Column('COUNT CODIGO').From('GRUPOS').GroupBy('CODIGO').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //OrderBy
  sSqlCompare := 'SELECT CODIGO,DESCRICAO FROM GRUPOS ORDER BY DESCRICAO DESC';
  sSqlBuilder := SQL.Select.Column('CODIGO').Column('DESCRICAO').From('GRUPOS').OrderBy('DESCRICAO DESC').ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //Column ISqlCase
  sSqlCompare := 'SELECT CASE WHEN C.STATUS = 100 THEN ''00'' WHEN C.STATUS = 135 THEN ''02'' END AS COD_SIT FROM CUPOM C';
  sSqlBuilder := SQL.Select
    .Column(SQL.&Case
      .WhenThen('C.STATUS = 100', '00')
      .WhenThen('C.STATUS = 135', '02')
      .&As('COD_SIT'))
    .From('CUPOM C')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //From ISqlSelect
  sSqlCompare := 'SELECT MAX(QTD_TIPO.QTD) FROM (SELECT TIPO,COUNT(CODIGO) AS QTD FROM NOTAS GROUP BY TIPO) AS QTD_TIPO';
  sSqlBuilder := SQL.Select
    .Column('MAX(QTD_TIPO.QTD)')
    .From(SQL.Select
      .Column('TIPO')
      .Column('COUNT(CODIGO) AS QTD')
      .From('NOTAS')
      .GroupBy('TIPO'),
    'QTD_TIPO')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //From ISqlProcedure
  sSqlCompare := 'SELECT RESULT FROM GERAR_VENDA (''CONSUMIDOR'', 50)';
  sSqlBuilder := SQL.Select
    .Column('RESULT')
    .From(SQL.&Procedure('GERAR_VENDA')
      .Value('CONSUMIDOR')
      .Value(50))
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //Having
  sSqlCompare := 'SELECT COUNT(CUSTOMERID),COUNTRY FROM CUSTOMERS GROUP BY COUNTRY HAVING COUNT(CUSTOMERID) > 5';
  sSqlBuilder := SQL.Select
    .Column('COUNT(CUSTOMERID)')
    .Column('COUNTRY')
    .From('CUSTOMERS')
    .GroupBy('COUNTRY')
    .Having('COUNT(CUSTOMERID) > 5')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //InnerJoin ISqlSelect
  sSqlCompare := 'SELECT P.NOME,GRP_TIPO.DESCRICAO FROM PRODUTOS P INNER JOIN (SELECT G.CODIGO,G.DESCRICAO FROM GRUPOS G WHERE G.TIPO = 1) GRP_TIPO ON GRP_TIPO.CODIGO = P.COD_GRUPO';
  sSqlBuilder := SQL.Select
    .Column('P.NOME')
    .Column('GRP_TIPO.DESCRICAO')
    .From('PRODUTOS P')
    .InnerJoin(SQL.Select
      .Column('G.CODIGO')
      .Column('G.DESCRICAO')
      .From('GRUPOS G')
      .Where('G.TIPO = 1'),
    'GRP_TIPO',
    'GRP_TIPO.CODIGO = P.COD_GRUPO')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //LeftJoin ISqlSelect
  sSqlCompare := 'SELECT P.NOME,GRP_TIPO.DESCRICAO FROM PRODUTOS P LEFT JOIN (SELECT G.CODIGO,G.DESCRICAO FROM GRUPOS G WHERE G.TIPO = 1) GRP_TIPO ON GRP_TIPO.CODIGO = P.COD_GRUPO';
  sSqlBuilder := SQL.Select
    .Column('P.NOME')
    .Column('GRP_TIPO.DESCRICAO')
    .From('PRODUTOS P')
    .LeftJoin(SQL.Select
      .Column('G.CODIGO')
      .Column('G.DESCRICAO')
      .From('GRUPOS G')
      .Where('G.TIPO = 1'),
    'GRP_TIPO',
    'GRP_TIPO.CODIGO = P.COD_GRUPO')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //RightJoin ISqlSelect
  sSqlCompare := 'SELECT P.NOME,GRP_TIPO.DESCRICAO FROM PRODUTOS P RIGHT JOIN (SELECT G.CODIGO,G.DESCRICAO FROM GRUPOS G WHERE G.TIPO = 1) GRP_TIPO ON GRP_TIPO.CODIGO = P.COD_GRUPO';
  sSqlBuilder := SQL.Select
    .Column('P.NOME')
    .Column('GRP_TIPO.DESCRICAO')
    .From('PRODUTOS P')
    .RightJoin(SQL.Select
      .Column('G.CODIGO')
      .Column('G.DESCRICAO')
      .From('GRUPOS G')
      .Where('G.TIPO = 1'),
    'GRP_TIPO',
    'GRP_TIPO.CODIGO = P.COD_GRUPO')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //InnerJoin aSource
  sSqlCompare := 'SELECT P.NOME,G.DESCRICAO FROM PRODUTOS P INNER JOIN GRUPOS G ON G.CODIGO = P.COD_GRUPO';
  sSqlBuilder := SQL.Select
    .Column('P.NOME')
    .Column('G.DESCRICAO')
    .From('PRODUTOS P')
    .InnerJoin('GRUPOS G', 'G.CODIGO = P.COD_GRUPO')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //LeftJoin aSource
  sSqlCompare := 'SELECT CL.NOME,C.DESCRICAO FROM CLIENTES CL LEFT JOIN CATEGORIAS C ON C.CODIGO = CL.COD_CATEGORIA';
  sSqlBuilder := SQL.Select
    .Column('CL.NOME')
    .Column('C.DESCRICAO')
    .From('CLIENTES CL')
    .LeftJoin('CATEGORIAS C', 'C.CODIGO = CL.COD_CATEGORIA')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //RightJoin aSource
  sSqlCompare := 'SELECT CL.NOME,C.DESCRICAO FROM CLIENTES CL RIGHT JOIN CATEGORIAS C ON C.CODIGO = CL.COD_CATEGORIA';
  sSqlBuilder := SQL.Select
    .Column('CL.NOME')
    .Column('C.DESCRICAO')
    .From('CLIENTES CL')
    .RightJoin('CATEGORIAS C', 'C.CODIGO = CL.COD_CATEGORIA')
    .ToString;
  CompareSql(sSqlCompare, sSqlBuilder);

  //sSqlCompare := '';
  //CompareSql(sSqlCompare, SQL.Select.ToString);
end;

end.
