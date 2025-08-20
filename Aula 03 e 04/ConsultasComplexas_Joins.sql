-- AULA 12/08 - JOINS

-- INNER JOIN
-- Funcionarios que trabalham em pesquisa 
SELECT F.Pnome, F.Unome, F.Endereco
FROM FUNCIONARIO AS F
	INNER JOIN DEPARTAMENTO AS DP
ON F.Dnr = DP.Dnumero
WHERE DP.Dnome = 'pesquisa';
GO

-- Listar os funcionarios que est o desenvolvendo o produtoX
SELECT F.Pnome,F.Minicial, F.Unome
FROM FUNCIONARIO AS F
INNER JOIN TRABALHA_EM AS T
	ON F.Cpf = T.Fcpf
INNER JOIN PROJETO AS P
	ON T.Pnr = P.Projnumero
WHERE P.Projnome LIKE 'ProdutoX';
GO

-- Para cada projeto localizado em "Maua", liste o numero do projeto, o numero do departamento que o
-- controla e o sobrenome, endere o e data de nascimento do gerente do departamento
SELECT P.Projnome, P.Projnumero, D.Dnome, D.Dnumero, F.Unome, F.Endereco, F.Datanasc
FROM FUNCIONARIO AS F
	INNER JOIN DEPARTAMENTO AS D
ON D.Cpf_gerente = F.Cpf
	INNER JOIN LOCALIZACAO_DEP AS LD
ON LD.Dnumero = D.Dnumero
	INNER JOIN PROJETO AS P
ON P.Dnum = D.Dnumero
	WHERE LD.Dlocal = 'Mau ';
GO

--LEFT JOIN
-- Novos dados
INSERT INTO FUNCIONARIO (Pnome, Minicial, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Cpf_supervisor, Dnr)
VALUES ('Carlos', 'M', 'Ferreira', '12312312311', '1980-02-15', 'Av. Paulista, 1000, S o Paulo, SP', 'M', 45000, NULL, NULL);

INSERT INTO FUNCIONARIO (Pnome, Minicial, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Cpf_supervisor, Dnr)
VALUES ('Mariana', 'L', 'Gomes', '32132132122', '1985-06-22', 'Rua das Ac cias, 500, Rio de Janeiro, RJ', 'F', 42000, NULL, NULL);

INSERT INTO FUNCIONARIO (Pnome, Minicial, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Cpf_supervisor, Dnr)
VALUES ('Pedro', 'A', 'Silva', '65465465433', '1990-11-10', 'Rua da Praia, 200, Salvador, BA', 'M', 47000, NULL, NULL);

INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
VALUES ('Vendas', 6);

INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
VALUES ('RH', 7);

INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
VALUES ('TI', 8);
GO

-- liste o ultimo nome de todos os funcionarios e o ultimo nome dos respectivos gerentes, caso possuam
SELECT F.Unome AS 'Funcionario_Nome', G.Unome AS 'Gerente_Nome'
FROM FUNCIONARIO AS F
LEFT JOIN FUNCIONARIO AS G 
ON F.Cpf_supervisor = G.Cpf;
GO

-- encontre os funcionarios que n o possuem departamento a eles vinculados
SELECT F.Pnome, F.Minicial, F.Unome
FROM FUNCIONARIO AS F
LEFT JOIN DEPARTAMENTO AS D
ON D.Dnumero = F.Dnr
WHERE F.Dnr IS NULL;
GO

-- encontre os departamento que n o possuem funcionarios a eles vinculados
SELECT D.Dnome
FROM DEPARTAMENTO AS D
LEFT JOIN FUNCIONARIO AS F
ON D.Dnumero = F.Dnr
WHERE F.Dnr IS NULL;
GO

-- outra forma com NOT IN
SELECT *
FROM DEPARTAMENTO AS D
WHERE D.Dnumero NOT IN 
	(SELECT DISTINCT F.Dnr FROM FUNCIONARIO AS F
		WHERE F.Dnr IS NOT NULL);
GO

--NOT EXISTS()
SELECT*
FROM DEPARTAMENTO AS D
WHERE NOT EXISTS 
	(SELECT 1 FROM FUNCIONARIO AS F 
		WHERE F.Dnr = D.Dnumero);
GO

-- RIGHT JOIN
-- encontre os FUNCIONARIOS que n o possuem DEPENDENTES
SELECT F.Pnome, F.Minicial, F.Unome
FROM DEPENDENTE AS D
RIGHT JOIN FUNCIONARIO AS F
ON D.Fcpf = F.Cpf
WHERE D.Fcpf IS NULL;
GO

-- CROSS JOIN
-- juntar Funcionarios e departamentos
SELECT *
FROM FUNCIONARIO AS F
FULL JOIN DEPARTAMENTO AS D
ON D.Dnumero = F.Dnr;
GO

-- SQL UNION
-- listar todos os nomes unicos de FUNCIONARIOS e DEPENDENTES
SELECT D.Nome_dependente, D.Sexo, D.Datanasc
FROM DEPENDENTE AS D
UNION
SELECT F.Pnome, F.Sexo, F.Datanasc
FROM FUNCIONARIO AS F;
GO

-- AULA 19/08
-- SELF JOIN 
SELECT F.Pnome AS 'funcionario', S.Pnome AS 'Surpevisor'
FROM FUNCIONARIO AS F
JOIN FUNCIONARIO AS S -- S de supervisor
ON F.Cpf_supervisor = S.Cpf;

-- UNION
EXEC sp_help FUNCIONARIO;
EXEC sp_help DEPENDENTE;

SELECT F.Pnome, F.Datanasc, F.Sexo
FROM FUNCIONARIO AS F
UNION ALL
SELECT D.Nome_dependente, D.Datanasc, D.Sexo
FROM DEPENDENTE AS D

SELECT LD.Dlocal
FROM LOCALIZACAO_DEP AS LD
UNION 
SELECT P.Projlocal
FROM PROJETO AS P

-- EXCEPT 
SELECT Pnome, Unome
FROM FUNCIONARIO
WHERE Cpf IN (
	SELECT F.Cpf FROM FUNCIONARIO AS F 
	EXCEPT
	SELECT D.Cpf_gerente FROM DEPARTAMENTO AS D 
);

SELECT Cpf FROM FUNCIONARIO
EXCEPT
SELECT DISTINCT Cpf_supervisor FROM FUNCIONARIO

-- INTERSEC
SELECT Cpf FROM FUNCIONARIO
INTERSECT
SELECT DISTINCT Cpf_supervisor FROM FUNCIONARIO

-- GROUP BY
SELECT *
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero;

SELECT D.Dnome AS 'Nome do Departamento', COUNT (F.Cpf) AS 'Número de Funcionários' 
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
GROUP BY D.Dnome;

SELECT D.Dnome AS 'Nome do Departamento', SUM (F.Salario) AS 'Somatório dos Salários' 
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
GROUP BY D.Dnome;

SELECT P.Projnome AS 'Nome do Departamento', AVG (TE.Horas) AS 'Média das horas' 
FROM TRABALHA_EM AS TE
JOIN PROJETO AS P
ON P.Projnumero = TE.Pnr
GROUP BY P.Projnome;

SELECT F.Sexo AS 'Sexo', COUNT (F.Cpf) AS 'Número de Funcionários' 
FROM FUNCIONARIO AS F
GROUP BY F.Sexo;

SELECT D.Dnome AS 'Nome do Departamento', MAX (F.Salario) AS 'Maior Salário' 
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
GROUP BY D.Dnome;

SELECT P.Projlocal AS 'Local', COUNT (P.Projnome) AS 'Números de Projetos' 
FROM PROJETO AS P 
GROUP BY P.Projlocal;

-- HAVING
SELECT D.Dnome AS 'Nome do Departamento', COUNT (F.Cpf) AS 'Número de Funcionários' 
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
HAVING COUNT (F.Cpf) > 3;

SELECT P.Projnome AS 'Nome do Projeto', SUM (TE.Horas) AS 'Número de Horas' 
FROM TRABALHA_EM AS TE
JOIN PROJETO AS P
ON TE.Pnr = P.Projnumero 
GROUP BY P.Projnome
HAVING SUM (TE.Horas) > 50;

-- EXISTS
SELECT *
FROM FUNCIONARIO AS F
WHERE EXISTS
(SELECT 1 FROM DEPARTAMENTO AS D WHERE F.Cpf = D.Cpf_gerente);

-- Listar departamentos que possuem projetos associados (SLIDE 43)
SELECT *
FROM FUNCIONARIO AS F
WHERE EXISTS
(SELECT 1 FROM DEPARTAMENTO AS D WHERE F.Cpf = D.Cpf_gerente);

-- ANY/ALL
SELECT F.Salario
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE D.Dnome LIKE '%Adm%';

SELECT *
FROM FUNCIONARIO
WHERE Salario >  ANY ( -- Ganha mais que alguém da Adm.
						SELECT F.Salario
						FROM FUNCIONARIO AS F
						JOIN DEPARTAMENTO AS D
						ON F.Dnr = D.Dnumero
						WHERE D.Dnome LIKE '%Adm%'
);

SELECT *
FROM FUNCIONARIO
WHERE Salario >  ALL ( -- Ganha mais que todos da Adm.
						SELECT F.Salario
						FROM FUNCIONARIO AS F
						JOIN DEPARTAMENTO AS D
						ON F.Dnr = D.Dnumero
						WHERE D.Dnome LIKE '%Adm%'
);

-- Encontrar projetos que exigem mais horas do que todos os projetos no local 'São Paulo' (SLIDE 49)
