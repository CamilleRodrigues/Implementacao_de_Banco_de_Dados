-- TRIGGER

-- After
GO
CREATE OR ALTER TRIGGER trg_InsertFuncionario
ON FUNCIONARIO
AFTER INSERT
AS
BEGIN
	PRINT 'Olá Mundo!'
	PRINT 'Funcionário inserido com sucesso!'
END
GO

INSERT INTO FUNCIONARIO (Pnome, Unome, Minicial, Cpf)
VALUES ('Zamba', 'Xiru', 'O', '9876567');

-- Instead of
GO
CREATE OR ALTER TRIGGER trg_InsertFuncionario
ON FUNCIONARIO
INSTEAD OF INSERT
AS
BEGIN
	PRINT 'Olá Mundo!'
	PRINT 'Funcionário não inserido!'
END
GO

INSERT INTO FUNCIONARIO (Pnome, Unome, Minicial, Cpf)
VALUES ('Emili', 'Rodrigues', 'O', '13545136');

SELECT * FROM FUNCIONARIO ORDER BY Pnome ASC;

ALTER TABLE FUNCIONARIO

-- Desabilitar ou abilitar
GO
CREATE OR ALTER TRIGGER trg_InsertFuncionario
ON FUNCIONARIO
INSTEAD OF INSERT
AS
BEGIN
	PRINT 'Olá Mundo!'
	PRINT 'Funcionário não inserido!'
END
GO

ALTER TABLE FUNCIONARIO
-- DISABLE TRIGGER trg_InsertFuncionario
DROP TRIGGER trg_InsertFuncionario

INSERT INTO FUNCIONARIO (Pnome, Unome, Minicial, Cpf)
VALUES ('Emili', 'Rodrigues', 'O', '13545136');

-- Verificar a existência de triggers
EXEC sp_helptrigger @tabname = FUNCIONARIO

SELECT * FROM FUNCIONARIO ORDER BY Pnome ASC;

-- Determinando as colunas atualizadas
GO
CREATE OR ALTER TRIGGER trg_AlteracaoSalario
ON FUNCIONARIO
AFTER INSERT,UPDATE
AS
BEGIN
	DECLARE @SalarioAntigo VARCHAR(20)
	DECLARE @SalarioNovo VARCHAR(20)

	IF UPDATE (Salario)
	BEGIN
		SELECT @SalarioNovo = i.Salario
		FROM inserted i;

		SELECT @SalarioAntigo = d.Salario
		FROM deleted d;

		PRINT 'Salário anterior: ' + @SalarioAntigo
		PRINT 'Salário atualizado: ' + @SalarioNovo
	END
	ELSE
		PRINT 'O salário NÃO foi modificado'
END
GO

INSERT INTO FUNCIONARIO (Pnome, Unome, Minicial, Cpf)
VALUES ('Juju', 'Rodrigues', 'O', '877765846');

UPDATE FUNCIONARIO
SET Salario = 10000
WHERE Cpf = '877765846'

UPDATE FUNCIONARIO
SET Dnr = 1
WHERE Cpf = '877765846'

SELECT * FROM FUNCIONARIO ORDER BY Pnome ASC;
