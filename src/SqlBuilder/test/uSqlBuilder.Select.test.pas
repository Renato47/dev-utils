unit uSqlBuilder.select.test;

interface

procedure selectTest;

implementation

uses
  uSqlBuilder, uCompare;

procedure selectTest;
var
  sqlCompare, sqlBuilder: string;
begin
  sqlCompare := 'SELECT C.CODIGO,C.NOME FROM CLIENTES C';
  sqlBuilder := SQL.select.column('C.CODIGO').column('C.NOME').from('CLIENTES C').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //AllColumns
  sqlCompare := 'SELECT * FROM GRUPOS';
  sqlBuilder := SQL.select.allColumns.from('GRUPOS').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //Distinct
  sqlCompare := 'SELECT DISTINCT DESCRICAO FROM GRUPOS';
  sqlBuilder := SQL.select.distinct.column('DESCRICAO').from('GRUPOS').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //First
  sqlCompare := 'SELECT FIRST 5 DESCRICAO FROM GRUPOS';
  sqlBuilder := SQL.select.first(5).column('DESCRICAO').from('GRUPOS').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //Skip
  sqlCompare := 'SELECT FIRST 1 SKIP 10 DESCRICAO FROM GRUPOS';
  sqlBuilder := SQL.select.first(1).skip(10).column('DESCRICAO').from('GRUPOS').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //Cast
  sqlCompare := 'SELECT CAST(V.DATA_HORA AS DATE) AS DATA FROM VENDAS V';
  sqlBuilder := SQL.select.column('V.DATA_HORA').cast('DATE', 'DATA').from('VENDAS V').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //Where aConditions
  sqlCompare := 'SELECT * FROM GRUPOS WHERE CODIGO > 0';
  sqlBuilder := SQL.select.allColumns.from('GRUPOS').where('CODIGO > 0').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //Where ISqlWhere
  sqlCompare := 'SELECT * FROM GRUPOS WHERE CODIGO > 0';
  sqlBuilder := SQL.select.allColumns.from('GRUPOS').where(SQL.where.column('CODIGO').greater(0)).toStr;
  compareSql(sqlCompare, sqlBuilder);

  //GroupBy
  sqlCompare := 'SELECT COUNT CODIGO FROM GRUPOS GROUP BY CODIGO';
  sqlBuilder := SQL.select.column('COUNT CODIGO').from('GRUPOS').groupBy('CODIGO').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //OrderBy
  sqlCompare := 'SELECT CODIGO,DESCRICAO FROM GRUPOS ORDER BY DESCRICAO DESC';
  sqlBuilder := SQL.select.column('CODIGO').column('DESCRICAO').from('GRUPOS').orderBy('DESCRICAO DESC').toStr;
  compareSql(sqlCompare, sqlBuilder);

  //Column ISqlCase
  sqlCompare :=
    'SELECT CASE WHEN C.STATUS = 100 THEN ''00'' WHEN C.STATUS = 135 THEN ''02'' END AS COD_SIT FROM CUPOM C';
  sqlBuilder := SQL.select
    .column(SQL.&case
      .whenThen('C.STATUS = 100', '00')
      .whenThen('C.STATUS = 135', '02')
      .&as('COD_SIT'))
    .from('CUPOM C')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //From ISqlSelect
  sqlCompare :=
    'SELECT MAX(QTD_TIPO.QTD) FROM (SELECT TIPO,COUNT(CODIGO) AS QTD FROM NOTAS GROUP BY TIPO) AS QTD_TIPO';
  sqlBuilder := SQL.select
    .column('MAX(QTD_TIPO.QTD)')
    .from(SQL.select
      .column('TIPO')
      .column('COUNT(CODIGO) AS QTD')
      .from('NOTAS')
      .groupBy('TIPO'),
    'QTD_TIPO')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //From ISqlProcedure
  sqlCompare := 'SELECT RESULT FROM GERAR_VENDA (''CONSUMIDOR'', 50)';
  sqlBuilder := SQL.select
    .column('RESULT')
    .from(SQL.&procedure('GERAR_VENDA')
      .value('CONSUMIDOR')
      .value(50))
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //Having
  sqlCompare := 'SELECT COUNT(CUSTOMERID),COUNTRY FROM CUSTOMERS GROUP BY COUNTRY HAVING COUNT(CUSTOMERID) > 5';
  sqlBuilder := SQL.select
    .column('COUNT(CUSTOMERID)')
    .column('COUNTRY')
    .from('CUSTOMERS')
    .groupBy('COUNTRY')
    .having('COUNT(CUSTOMERID) > 5')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //InnerJoin ISqlSelect
  sqlCompare := 'SELECT P.NOME,GRP_TIPO.DESCRICAO FROM PRODUTOS P '
    + 'INNER JOIN (SELECT G.CODIGO,G.DESCRICAO FROM GRUPOS G WHERE G.TIPO = 1) GRP_TIPO ON GRP_TIPO.CODIGO = P.COD_GRUPO';
  sqlBuilder := SQL.select
    .column('P.NOME')
    .column('GRP_TIPO.DESCRICAO')
    .from('PRODUTOS P')
    .innerJoin(SQL.select
      .column('G.CODIGO')
      .column('G.DESCRICAO')
      .from('GRUPOS G')
      .where('G.TIPO = 1'),
    'GRP_TIPO',
    'GRP_TIPO.CODIGO = P.COD_GRUPO')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //LeftJoin ISqlSelect
  sqlCompare := 'SELECT P.NOME,GRP_TIPO.DESCRICAO FROM PRODUTOS P '
    + 'LEFT JOIN (SELECT G.CODIGO,G.DESCRICAO FROM GRUPOS G WHERE G.TIPO = 1) GRP_TIPO ON GRP_TIPO.CODIGO = P.COD_GRUPO';
  sqlBuilder := SQL.select
    .column('P.NOME')
    .column('GRP_TIPO.DESCRICAO')
    .from('PRODUTOS P')
    .leftJoin(SQL.select
      .column('G.CODIGO')
      .column('G.DESCRICAO')
      .from('GRUPOS G')
      .where('G.TIPO = 1'),
    'GRP_TIPO',
    'GRP_TIPO.CODIGO = P.COD_GRUPO')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //RightJoin ISqlSelect
  sqlCompare := 'SELECT P.NOME,GRP_TIPO.DESCRICAO FROM PRODUTOS P '
    + 'RIGHT JOIN (SELECT G.CODIGO,G.DESCRICAO FROM GRUPOS G WHERE G.TIPO = 1) GRP_TIPO ON GRP_TIPO.CODIGO = P.COD_GRUPO';
  sqlBuilder := SQL.select
    .column('P.NOME')
    .column('GRP_TIPO.DESCRICAO')
    .from('PRODUTOS P')
    .rightJoin(SQL.select
      .column('G.CODIGO')
      .column('G.DESCRICAO')
      .from('GRUPOS G')
      .where('G.TIPO = 1'),
    'GRP_TIPO',
    'GRP_TIPO.CODIGO = P.COD_GRUPO')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //InnerJoin aSource
  sqlCompare := 'SELECT P.NOME,G.DESCRICAO FROM PRODUTOS P INNER JOIN GRUPOS G ON G.CODIGO = P.COD_GRUPO';
  sqlBuilder := SQL.select
    .column('P.NOME')
    .column('G.DESCRICAO')
    .from('PRODUTOS P')
    .innerJoin('GRUPOS G', 'G.CODIGO = P.COD_GRUPO')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //LeftJoin aSource
  sqlCompare := 'SELECT CL.NOME,C.DESCRICAO FROM CLIENTES CL LEFT JOIN CATEGORIAS C ON C.CODIGO = CL.COD_CATEGORIA';
  sqlBuilder := SQL.select
    .column('CL.NOME')
    .column('C.DESCRICAO')
    .from('CLIENTES CL')
    .leftJoin('CATEGORIAS C', 'C.CODIGO = CL.COD_CATEGORIA')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);

  //RightJoin aSource
  sqlCompare := 'SELECT CL.NOME,C.DESCRICAO FROM CLIENTES CL RIGHT JOIN CATEGORIAS C ON C.CODIGO = CL.COD_CATEGORIA';
  sqlBuilder := SQL.select
    .column('CL.NOME')
    .column('C.DESCRICAO')
    .from('CLIENTES CL')
    .rightJoin('CATEGORIAS C', 'C.CODIGO = CL.COD_CATEGORIA')
    .toStr;
  compareSql(sqlCompare, sqlBuilder);
end;

end.
