SELECT DISTINCT ON (cpo.id)
cpo.contract_id AS id_contrato,
cpo.crm_consult_selling_step_id AS id_negociacao,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.id AS cod_cliente,
p.neighborhood AS bairro,
p.city AS cidade,
CONCAT(p.lat,p.lng) AS lat_long,
DATE(cpo.created) AS data_cadastro,
(SELECT serv.title FROM service_products AS serv WHERE serv.id = pl.service_product_id) AS plano,
CASE WHEN c.seller_1_id is null THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = cpo.created_by) ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) END AS vendedor,
CASE WHEN cpo.current_stage = 1 THEN 'Perdida' ELSE 'Finalizada' END AS status_venda,
CASE WHEN c.seller_1_id IS NULL THEN (SELECT pg.title FROM people_groups AS pg WHERE pg.id = (SELECT ppg.people_group_id FROM person_people_groups AS ppg where ppg.person_id = cpo.proprietary_id))
ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
c.amount AS valor_contrato,
(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
(SELECT cont.title FROM crm_contact_origins AS cont WHERE cont.id = org.crm_contact_origin_id) AS origem_contato,
c.v_status AS status_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato

FROM crm_person_oportunities AS cpo
LEFT JOIN contracts AS c ON c.id = cpo.contract_id
LEFT JOIN people AS p ON p.id = cpo.person_id
LEFT JOIN authentication_contracts AS pl ON cpo.contract_id = pl.contract_id
LEFT JOIN people_crm_informations AS org ON p.id = org.person_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
LEFT JOIN assignment_incidents AS ost ON cpo.assignment_id = ost.assignment_id

WHERE date(cpo.created) BETWEEN '2022-11-01' AND '2022-11-30'
AND cpo.description IS NOT NULL
AND ( CASE WHEN c.seller_1_id IS NULL THEN (SELECT ppg.people_group_id FROM person_people_groups AS ppg where ppg.person_id = cpo.proprietary_id) IN (11,14,16) ELSE  ppg.people_group_id IN (11,14,16) end)

OR

date(cpo.created) BETWEEN '2022-11-01' AND '2022-11-30'
AND cpo.description IS NOT NULL
AND ( CASE WHEN c.seller_1_id IS NULL THEN (SELECT ppg.people_group_id FROM person_people_groups AS ppg where ppg.person_id = cpo.proprietary_id) IN (11,14,16) ELSE  ppg.people_group_id IN (11,14,16) end)