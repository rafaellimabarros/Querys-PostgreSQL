SELECT DISTINCT ON (fat.id)
	p.id, 
	p.name AS nome,
	(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
	p.city AS cidade,
	p.neighborhood AS bairro,
	fat.title AS fatura,
	(SELECT comp.description FROM companies_places AS comp WHERE fat.company_place_id = comp.id) AS local_fatura,
	(SELECT nf.title FROM financers_natures AS nf WHERE fat.financer_nature_id = nf.id) AS natureza_financeira,
	(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = fat.financial_operation_id) AS operacao,
	fat.title_amount AS valor,
	CASE WHEN fat.balance <= 0 THEN 'Pago' WHEN fat.balance > 0 THEN 'Em Aberto' END AS status_pg,
	fat.entry_date AS emissao,
	fat.expiration_date AS vencimento,
	DATE_FORMAT(fat.competence, '%m-%Y') AS competencia,
	(SELECT s.title FROM service_products AS s WHERE s.id = con.service_product_id) AS plano,
	(SELECT s.selling_price FROM service_products AS s WHERE s.id = con.service_product_id) AS valor_plano
	
FROM
	financial_receivable_titles AS fat
INNER JOIN 
	people AS p ON fat.client_id = p.id
LEFT JOIN
	contracts AS c ON fat.contract_id = c.id
LEFT JOIN
	contract_items AS con ON c.id = con.contract_id
	
WHERE
	fat.type = 2
	AND fat.deleted = FALSE
	AND fat.origin NOT IN  (7, 2, 3, 5)
	AND fat.financial_collection_type_id IS NOT NULL
	AND fat.entry_date BETWEEN '2022-08-01' AND '2022-08-31'
