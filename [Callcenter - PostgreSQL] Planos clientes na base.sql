SELECT
p.id AS cod_cliente,
p.city AS cidade,
(SELECT serv.title FROM service_products AS serv WHERE serv.id = ac.service_product_id) AS plano,
(SELECT serv.selling_price FROM service_products AS serv WHERE serv.id = ac.service_product_id) AS valor_plano

FROM people AS p 
INNER JOIN contracts AS c ON c.client_id = p.id
INNER JOIN authentication_contracts AS ac ON ac.contract_id = c.id

WHERE c.v_status NOT IN ('Cancelado')
ORDER BY plano asc