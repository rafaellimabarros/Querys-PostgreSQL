SELECT DISTINCT ON (c.id)
	c.id AS id_contrato,
	(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
	p.id AS cod_cliente,
	p.name AS cliente,
	p.neighborhood AS bairro,
	p.city AS cidade,
	c.created AS data_cadastro,
	CONCAT(p.lat,',',p.lng) AS lat_long,
	CASE 
		WHEN ac.service_product_id IS NULL THEN (SELECT serv.title FROM service_products AS serv WHERE serv.id = ci.service_product_id)
		ELSE (SELECT serv.title FROM service_products AS serv WHERE serv.id = ac.service_product_id) 
		END  AS plano,
	CASE 
		WHEN c.seller_1_id is null THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = c.created_by) 
		ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) 
		END AS vendedor_1,
	CASE 
		WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' 
		ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) 
		END AS equipe,
	ai.protocol AS protocolo,
	(SELECT tos.title FROM incident_types AS tos WHERE tos.id = ai.incident_type_id) AS tipo_os,
	CASE 
		WHEN caa.activation_date IS NULL THEN DATE(a.conclusion_date) 
		ELSE date(caa.activation_date) 
		END AS data_ativacao,
	c.amount AS valor_contrato,
	nf.total_amount_products AS valor_produto,
	nf.total_amount_liquid AS valor_ativacao,
	CASE 
		WHEN nf.total_amount_products IS NULL THEN c.amount 
		WHEN nf.total_amount_liquid IS NULL THEN c.amount 
		ELSE c.amount + nf.total_amount_products + nf.total_amount_liquid 
		END AS total_recebido,
	(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
	(SELECT cont.title FROM crm_contact_origins AS cont WHERE cont.id = org.crm_contact_origin_id) AS origem_contato,
	c.v_status AS status_contrato,
	c.v_stage AS estagio_contrato
	
	FROM 
		contracts AS c 
		JOIN people AS p ON p.id = c.client_id
		JOIN assignments AS a ON a.requestor_id = p.id 
		JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
		LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
		LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
		LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
		LEFT JOIN invoice_notes AS nf ON nf.id = caa.invoice_note_id
		LEFT JOIN people_crm_informations AS org ON p.id = org.person_id
		LEFT JOIN contract_items AS ci ON ci.contract_id = c.id
		LEFT JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id
		LEFT JOIN crm_person_oportunities AS cpo ON cpo.contact_id = c.id
	
	WHERE 
		(c.v_stage IN ('Em Aprovação','Pré-Contrato') 
		AND c.deleted = FALSE 
		AND c.id IN (
							SELECT 
								c.id
								
								FROM 
									contracts AS c 
									JOIN people AS p ON p.id = c.client_id
									JOIN assignments AS a ON a.requestor_id = p.id
									JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
								WHERE 
									ai.incident_status_id = 4 
									AND ai.incident_type_id IN (1005,1006)
									AND DATE(a.conclusion_date) >= DATE(c.created)
									AND DATE(a.conclusion_date) BETWEEN '2023-05-01' AND '2023-05-31'
						)
		AND ai.incident_status_id = 4 
		AND ai.incident_type_id IN (1005,1006)
		AND DATE(a.conclusion_date) >= DATE(c.created)
		AND DATE(a.conclusion_date) BETWEEN '2023-05-01' AND '2023-05-31'
	)
	
	OR
	
	(caa.activation_date BETWEEN '2023-05-01' AND '2023-05-31')
