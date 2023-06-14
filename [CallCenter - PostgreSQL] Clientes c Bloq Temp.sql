SELECT DISTINCT ON (c.id)
c.id AS cod_contrato,
p.name AS nome,
(SELECT tx.name FROM tx_types AS tx WHERE tx.id = p.type_tx_id) AS tipo_documento,
p.tx_id AS documento,
CASE 
	WHEN ac.modified IS NULL THEN '2021-01-27' ELSE date(ac.modified) END AS data_bloqueio,

CASE 
	WHEN p.id IN 
	(
		SELECT p.id FROM 
		people AS p 
		INNER JOIN contracts AS c ON c.client_id = p.id
		INNER JOIN financial_receivable_titles AS fat ON fat.contract_id = c.id
		WHERE c.v_status = 'Suspenso'
		and fat.p_is_receivable = TRUE
		AND fat.type = 2
		AND fat.deleted = FALSE
		AND fat.origin NOT IN (2, 3, 5, 7)
		AND c.contract_type_id NOT IN (4, 6, 7, 8, 9)
		AND fat.company_place_id != 3
		AND fat.financial_collection_type_id IS NOT NULL
	) 
		THEN 
			'Inadimplente' 
		ELSE 
			'Adimplente' 
		END AS status_divida,
		
c.v_status AS status_contrato,
(SELECT cp.description FROM companies_places AS cp WHERE c.company_place_id = cp.id) AS local_contrato,
c.amount AS valor_plano

FROM people AS p 
INNER JOIN contracts AS c ON c.client_id = p.id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
   
WHERE c.v_status = 'Suspenso'
