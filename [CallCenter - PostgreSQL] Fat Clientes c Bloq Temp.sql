SELECT
fat.contract_id AS cod_contrato,
p.name AS nome,
fat.title AS fatura,
fat.title_amount AS valor_fatura,
fat.expiration_date AS data_vencimento,
(SELECT cp.description FROM companies_places AS cp WHERE fat.company_place_id = cp.id) AS local_fatura

FROM people AS p 
INNER JOIN contracts AS c ON c.client_id = p.id
INNER  JOIN financial_receivable_titles AS fat ON fat.contract_id = c.id
   
WHERE c.v_status = 'Suspenso'
and fat.p_is_receivable = TRUE
AND fat.deleted = FALSE
AND c.contract_type_id NOT IN (4, 6, 7, 8, 9)
AND fat.company_place_id != 3
AND fat.financial_collection_type_id IS NOT NULL