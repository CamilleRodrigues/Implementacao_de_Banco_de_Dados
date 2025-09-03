-- AULA 02/09
-- Funções

CREATE FUNCTION fn_Dobro(@Numero DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
 RETURN @Numero * 2;
END

SELECT dbo.fn_Dobro(500) AS 'Resultado';

SELECT 
	F.Pnome,
	F.Unome,
	F.Salario,
	dbo.fn_Dobro(F.Salario) AS 'S_dobrado'
FROM FUNCIONARIO AS F;

ALTER FUNCTION fn_CalculaIdade(@DataNasc DATE)
RETURNS INT
AS
BEGIN
	DECLARE @Idade INT;
	SET @Idade = DATEDIFF(YEAR, @DataNasc, GETDATE());

	IF (MONTH(@DataNasc) > MONTH(GETDATE())
		OR MONTH(@DataNasc) = MONTH(GETDATE()) AND DAY(@DataNasc) > DAY(GETDATE())
		)
		SET @Idade =  @Idade - 1;

    RETURN @Idade;
END;

SELECT 
	F.Pnome,
	F.Unome,
	F.Datanasc,
	dbo.fn_CalculaIdade(F.Datanasc) AS 'Idade'
FROM FUNCIONARIO AS F;

CREATE FUNCTION fn_FuncionarioDepartamento(@NomeDepartamento VARCHAR)
RETURNS TABLE
AS
RETURN 
(
SELECT F.Pnome, F.Unome, D.Dnome
FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Pesquisa'
);

SELECT * FROM dbo.fn_FuncionarioDepartamento('Pesquisa');

ALTER FUNCTION fn_SalaraioAnual(@Cpf AS VARCHAR(11))
RETURNS @Tabela TABLE
(
	NomeCompleto VARCHAR(150),
	SalarioMensal DECIMAL(10, 2),
	SalarioAnual DECIMAL(10, 2)
)
AS
BEGIN
    INSERT INTO @Tabela
    SELECT 
        CONCAT(F.Pnome, ' ', F.Minicial, '. ', F.Unome),
        F.Salario,
        (F.Salario * 13 + (F.Salario * 0.3))
    FROM FUNCIONARIO AS F
	WHERE F.Cpf = @Cpf;
    RETURN;
END;

SELECT * FROM dbo.fn_SalaraioAnual('33344555587');

CREATE FUNCTION fn_SalarioComBonus(
@Salario DECIMAL(10, 2),
@Bonus DECIMAL(5, 2)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
	DECLARE @SalarioAnual DECIMAL(10, 2);

	SET @SalarioAnual = @Salario * 12;

	SET @SalarioAnual = @SalarioAnual + (@SalarioAnual * @Bonus)/100; 

RETURN @SalarioAnual;
END

SELECT 
    Pnome, 
    Unome,
    Salario,
    dbo.fn_SalarioComBonus(Salario, 10) AS Salario_Anual_10pct,
    dbo.fn_SalarioComBonus(Salario, 20) AS Salario_Anual_20pct
FROM FUNCIONARIO;
