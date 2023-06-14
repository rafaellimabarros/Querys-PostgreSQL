SELECT DISTINCT ON (c.id)
 p.id AS cod_pessoa, 
 c.id AS cod_contrato,
 SUBSTR (p.name, 0, STRPOS(p.name,' ')) AS nome,
 p.birth_date AS data_nascimento,
 c.amount AS Valor_contrato, 
 (SELECT s.description FROM service_products AS s WHERE con.service_product_id = s.id) AS Plano, 
 c.v_status AS Contrato_status, 
 c.cancellation_date AS data_cancelamento, 
 c.cancellation_motive AS Motivo_cancelamento,
 p.phone AS Telefone_01, 
 p.cell_phone_1 AS Telefone_02
 
FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
LEFT JOIN financial_receivable_titles AS fat ON p.id = fat.client_id

WHERE c.cancellation_date <= '2021-12-31' AND c.v_status = 'Cancelado'