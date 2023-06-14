SELECT DISTINCT ON (c.id)
	c.id AS id_contrato,
	p.name AS nome,
	p.tx_id AS CPF,
	p.neighborhood AS bairro,
	p.city AS cidade,
	p.cell_phone_1 AS celular1,
	p.phone AS telefone,
	p.email AS email,
	con.service_product_id,
	(SELECT pl.title FROM service_products AS pl WHERE pl.id = con.service_product_id) AS plano,
	c.amount AS valor_plano,
	(SELECT comp.description FROM companies_places AS comp WHERE c.company_place_id = comp.id AND c.company_place_id != 3) AS empresa_contrato,
	c.v_status AS status_contrato,
	c.beginning_date AS data_inicio,
	c.billing_final_date AS data_final,
	c.observation AS observacao_fidelidade,
	pu.begin AS data_fidelidade,
	ppg.people_group_id AS id_grupo
FROM 
	contracts AS c
INNER JOIN
	people AS p ON c.client_id = p.id
INNER JOIN
	authentication_contracts AS con ON c.id = con.contract_id
LEFT JOIN 
	person_people_groups AS ppg ON p.id = ppg.person_id
LEFT JOIN 
	people_uploads AS pu ON pu.people_id = p.id
WHERE 
	c.v_status = 'Normal'
	AND p.collaborator = false
	AND p.type_tx_id = 2
	AND pu.documentation_type_id = 3	
	AND pu.begin <= '2021-10-31'
	AND pu.people_id NOT IN (SELECT pu.people_id FROM people_uploads AS pu WHERE pu.begin >= '2021-11-01')
	OR con.service_product_id IN (67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 126, 128, 131, 132, 134, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 153, 154, 156, 164, 169, 177, 178, 179, 180, 181, 182, 183, 184, 186, 188, 189, 192, 193, 194, 197, 198, 201, 202, 203, 204, 205, 210, 213, 214, 2134, 2135, 2137, 2138, 2208, 2210, 2212, 2214, 2215, 2216, 2217, 2218)
