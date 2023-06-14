SELECT
	ca.contract_id AS id_contrato,
	(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS Tipo_Cliente,
	p.name AS nome,
	p.email AS email,
	p.cell_phone_1 AS telefone1,
	p.phone AS telefone2,
	p.neighborhood AS bairro,
	p.city AS cidade,
	c.created AS data_cadastro,
	c.amount AS valor_contrato,
	(SELECT serv.title FROM service_products AS serv WHERE serv.id = pl.service_product_id) AS plano,
	(SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) AS vendedor_1,
	(SELECT p.name FROM people AS p WHERE p.id = c.seller_2_id) AS vendedor_2,
	ost.protocol AS protocolo,
	(SELECT tos.title FROM incident_types AS tos WHERE tos.id = ost.incident_type_id) AS tipo_os,
	ca.activation_date AS data_ativacao,
	nf.total_amount_liquid AS valor_servico,
	nf.total_amount_products AS valor_produto,
	nf.total_amount_liquid AS valor_ativacao,
	pv.total_amount AS valor_infraestrutura,
	(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
	(SELECT cont.title FROM crm_contact_origins AS cont WHERE cont.id = org.crm_contact_origin_id) AS origem_contato,
	/*(SELECT campt.title FROM crm_campaigns AS campt WHERE campt.id = camp.campaign_id) AS campanha,*/
	c.v_status AS status_contrato
FROM
	contract_assignment_activations AS ca
INNER JOIN 
	contracts AS c ON ca.contract_id = c.id
INNER JOIN
	people AS p ON c.client_id = p.id
INNER JOIN
	sale_requests AS pv ON ca.contract_id = pv.contract_id
LEFT JOIN
	assignment_incidents AS ost ON ca.assignment_id = ost.assignment_id
LEFT JOIN 
	invoice_notes AS nf ON ca.invoice_note_id = nf.id
LEFT JOIN
	authentication_contracts AS pl ON ca.contract_id = pl.contract_id
LEFT JOIN
	people_crm_informations AS org ON p.id = org.person_id
/* LEFT JOIN 
	crm_person_oportunities AS camp ON p.id = camp.person_id */ 
WHERE
	ca.activation_date BETWEEN '2022-07-01' AND '2022-07-31' AND c.company_place_id != 3 AND pv.financer_nature_id = 154/*  AND camp.campaign_id = 2 ----- AND pl.service_product_id = 2852*/
ORDER BY
	ca.activation_date