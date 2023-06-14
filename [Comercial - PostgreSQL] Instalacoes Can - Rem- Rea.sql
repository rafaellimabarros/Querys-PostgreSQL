SELECT DISTINCT ON (ai.protocol)
c.id AS id_contrato,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.id AS cod_cliente,
p.name AS cliente,
p.neighborhood AS bairro,
p.city AS cidade,
CONCAT(p.lat,p.lng) AS lat_long,
DATE(c.created) AS data_cadastro,
(SELECT serv.title FROM service_products AS serv WHERE serv.id = pl.service_product_id) AS plano,
(SELECT serv.description FROM service_products AS serv WHERE serv.id = con.service_product_id ) AS plano_02, 
CASE WHEN c.seller_1_id IS NULL THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id =  c.created_by) ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) END AS vendedor_1,
CASE WHEN ppg.people_group_id IS NULL THEN 'Sem equipe' 
ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
ai.protocol AS protocolo,
a.created AS data_abertura,
(SELECT tos.title FROM incident_types AS tos WHERE tos.id = ai.incident_type_id) AS tipo_os,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_os,
DATE(c.created) AS data_cadastro_contrato,
c.amount AS valor_contrato,
(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
(SELECT cont.title FROM crm_contact_origins AS cont WHERE cont.id = org.crm_contact_origin_id) AS origem_contato,
c.v_status AS status_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato

FROM contracts AS c 
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN assignments AS a ON a.requestor_id = p.id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN authentication_contracts AS pl ON c.id = pl.contract_id
LEFT JOIN people_crm_informations AS org ON p.id = org.person_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
LEFT JOIN contract_items AS con ON con.contract_id = c.id

WHERE c.deleted = FALSE 
AND DATE(a.created) BETWEEN '2022-07-01' AND '2022-07-31'
AND ai.incident_type_id IN (1005,1006) AND DATE(a.conclusion_date) >= DATE(c.created) AND ai.incident_status_id IN (5,8,10)
