SELECT DISTINCT ON (c.id)
 p.id AS cod_pessoa, 
 c.id AS cod_contrato,
 SUBSTR (p.name, 0, STRPOS(p.name,' ')) AS nome,
 p.name,
 c.amount AS Valor_contrato, 
 (SELECT s.description FROM service_products AS s WHERE con.service_product_id = s.id) AS Plano, 
 c.v_status AS Contrato_status, 
 c.cancellation_date AS data_cancelamento, 
 c.cancellation_motive AS Motivo_cancelamento,
 p.phone AS Telefone_01, p.cell_phone_1 AS Telefone_02,
 fat.balance AS valor_em_aberto,
 fat.expiration_date AS vencimento,
 fat.title AS fatura,
 fat.p_is_receivable

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
LEFT JOIN financial_receivable_titles AS fat ON p.id = fat.client_id

WHERE c.cancellation_date <= '2021-07-19' 
AND fat.type = 2
AND fat.deleted = FALSE
AND fat.origin NOT IN (2, 3, 5, 7)
AND c.contract_type_id NOT IN (4, 6, 7, 8, 9)
AND fat.company_place_id != 3
AND fat.financial_collection_type_id IS NOT NULL
AND c.client_id NOT IN (SELECT fat.client_id FROM financial_receivable_titles as fat WHERE fat.p_is_receivable = TRUE)

ORDER BY c.id