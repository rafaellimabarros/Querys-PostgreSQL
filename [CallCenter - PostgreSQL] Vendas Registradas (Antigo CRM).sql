SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
c.id AS id_contrato,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.id AS cod_cliente,
p.name AS cliente,
p.neighborhood AS bairro,
p.city AS cidade,
CONCAT(p.lat,p.lng) AS lat_long,
DATE(a.created) AS data_venda,
(SELECT serv.title FROM service_products AS serv WHERE serv.id = pl.service_product_id) AS plano,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) vendedor_1,
CASE WHEN ppg.people_group_id IS NULL THEN 'Sem equipe' 
ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
c.amount AS valor_contrato,
(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
(SELECT cont.title FROM crm_contact_origins AS cont WHERE cont.id = org.crm_contact_origin_id) AS origem_contato,
c.v_status AS status_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato

FROM assignments AS a
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN people AS p ON p.id = ai.client_id
LEFT JOIN contracts AS c ON c.client_id = p.id
LEFT JOIN authentication_contracts AS pl ON c.id = pl.contract_id
LEFT JOIN people_crm_informations AS org ON p.id = org.person_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = a.responsible_id
LEFT JOIN contract_items AS con ON con.contract_id = c.id

WHERE DATE(a.created) BETWEEN '2022-07-01' AND '2022-09-30'
AND ai.incident_type_id IN (1003,1004)
AND ppg.people_group_id IN (12,13,15,19)