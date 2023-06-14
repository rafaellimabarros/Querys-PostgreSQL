SELECT 
c.id AS id_contrato,
p.name AS nome,
p.tx_id AS cpf_cnpj,
ca.activation_date AS data_ativação,
(SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) AS cadastrado_por,
c.v_status AS status_contrato,
p.street AS rua,
p.number AS número,
p.address_complement AS complemento,
p.neighborhood  AS rua,
p.state AS estado,
(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
p.code_city_id AS cep,
COUNT (fpt.title_amount) AS quantidade_boletos_gerados,
COUNT ( frt.amount) AS quantidade_boletos_pagos

FROM
	contract_assignment_activations AS ca
INNER JOIN 
	contracts AS c ON ca.contract_id = c.id
INNER JOIN
	people AS p ON c.client_id = p.id
INNER JOIN
	financial_receivable_titles AS fpt ON fpt.contract_id = c.id          
LEFT JOIN
	financial_receipt_titles AS frt ON frt.financial_receivable_title_id = fpt.id           

WHERE
	ca.activation_date BETWEEN cast(date_trunc('month', current_date-INTERVAL '3 month') as date) AND DATE(curdate())
	AND fpt.deleted = false
	AND fpt.financer_nature_id NOT IN (158, 186, 199, 94)
	AND fpt.financial_collection_type_id IS NOT NULL
	AND fpt.renegotiated = false
	AND c.company_place_id <> 3
	AND c.amount > 0
	AND fpt.title_amount <> 0
	AND frt.client_id   NOT IN (SELECT frt.client_id FROM financial_receipt_titles AS frt WHERE frt.receipt_date IS  NULL )	


	GROUP BY (c.id, p.name,p.tx_id,ca.activation_date,ca.created_by,p.street,p.number,p.address_complement,p.address_complement,p.neighborhood,p.state,p.code_city_id    )
	HAVING COUNT (frt.amount) <1
	
