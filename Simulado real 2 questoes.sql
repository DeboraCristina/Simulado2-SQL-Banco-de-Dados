USE exercicio13
/*
SELECT *
FROM 
*/

--Exercícios
--Apresentar marca e modelo de carro e a soma total da distância percorrida pelos carros,
--em viagens, de uma dada empresa, ordenado pela distância percorrida
SELECT c.marca, c.modelo, SUM(v.distanciaPercorrida) total_distancia
FROM carro c, viagem v, empresa e
WHERE c.id = v.idCarro AND c.idEmpresa = e.id
GROUP BY c.marca, c.modelo
ORDER BY total_distancia

--Apresentar nome das empresas cuja soma total da distância percorrida pelos carros,
--em viagens, é superior a 50000 km

SELECT e.nome, SUM(v.distanciaPercorrida) total_distancia
FROM carro c, viagem v, empresa e
WHERE c.id = v.idCarro AND c.idEmpresa = e.id
GROUP BY e.nome
HAVING SUM(v.distanciaPercorrida) > 50000

--Apresentar nome das empresas cuja soma total da distância percorrida pelos carros
--e a media das distâncias percorridas por seus carros em viagens.
--A média deve ser exibida em uma coluna chamada mediaDist e com 2 casas decimais apenas.
--Deve-se ordenar a saída pela média descrescente

SELECT e.nome, SUM(v.distanciaPercorrida) AS totalDist, CAST(AVG(v.distanciaPercorrida) AS DECIMAL(6, 2)) AS mediaDist
FROM empresa e, viagem v, carro c
WHERE e.id = c.idEmpresa AND v.idCarro = c.id
GROUP BY e.nome
ORDER BY mediaDist DESC


--Apresentar nome das empresas cujos carro percorreram a maior distância dentre as cadastradas

SELECT e.nome
FROM empresa e, carro c, viagem v
WHERE e.id = c.idEmpresa AND c.id = v.idCarro
	AND v.distanciaPercorrida IN (
	SELECT MAX(v.distanciaPercorrida) dist
	FROM viagem v
	)

--Apresentar nome das empresas e a quantidade de carros cadastrados para cada empresa
--Desde que a empresa tenha 3 ou mais carros
--A saída deve ser ordenada pela quantidade de carros, descrescente

SELECT e.nome, COUNT(c.id) quantidade_carros
FROM empresa e, carro c
WHERE e.id = c.idEmpresa
GROUP BY e.nome
HAVING COUNT(c.id) > 2

--Consultar Nomes das empresas que não tem carros cadastrados

SELECT e.nome
FROM empresa e LEFT JOIN carro c
ON e.id = c.idEmpresa
WHERE c.id IS NULL

--Consultar Marca e modelos dos carros que não fizeram viagens

SELECT c.marca, c.modelo
FROM carro c LEFT JOIN viagem v
	ON c.id = v.idCarro
WHERE v.idCarro IS NULL

--Consultar quantas viagens foram feitas por cada carro (marca e modelo) de cada empresa
--em ordem ascendente de nome de empresa e descendente de quantidade

SELECT c.marca + ' - ' + modelo as marca_modelo, e.nome, COUNT(v.idCarro) as quantidade
FROM carro c, empresa e, viagem v
WHERE e.id = c.idEmpresa AND c.id = v.idCarro
GROUP BY e.nome, c.marca, c.modelo
ORDER BY e.nome ASC, quantidade DESC

--Consultar o nome da empresa, a marca e o modelo do carro, a distância percorrida
--e o valor total ganho por viagem, sabendo que para distâncias inferiores a 1000 km, o valor é R$10,00
--por km e para viagens superiores a 1000 km, o valor é R$15,00 por km.

SELECT e.nome, c.marca, c.modelo, v.distanciaPercorrida,
	CASE
		WHEN (v.distanciaPercorrida < 1000) THEN 
			'R$ ' + CAST(CAST(v.distanciaPercorrida * 10 AS DECIMAL(7,2)) AS VARCHAR(15))
		ELSE 'R$ ' + CAST(CAST(v.distanciaPercorrida * 15 AS DECIMAL(7,2)) AS VARCHAR(15))
	END AS valor_total
FROM empresa e, carro c, viagem v
WHERE e.id = c.idEmpresa AND c.id = v.idCarro
