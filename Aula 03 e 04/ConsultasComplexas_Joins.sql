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
