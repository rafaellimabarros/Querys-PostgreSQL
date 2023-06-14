SELECT
p.id AS cod_cliente,
c.id AS cod_contrato,
p.name AS Cliente,
p.neighborhood AS bairro,
p.street AS rua,
p.address_complement AS complemento,
p.address_reference AS referencia,
p.cell_phone_1 AS celular,
p.phone AS telefone,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS Plano,
c.amount AS valor

FROM people AS p
INNER JOIN contracts AS c ON c.client_id = p.id
INNER JOIN authentication_contracts AS ac ON ac.contract_id = c.id

WHERE p.street like '%Manoel Jorge de Castro%'
OR 
p.street LIKE '%MANOEL JORGE DE CASTRO%'
OR
p.street like '%manoel jorge de castro%'
OR 
p.street LIKE '%Manoel jorge de castro%'

