SELECT DISTINCT ON (ca.contract_id)
ca.contract_id AS id_contrato,
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
(SELECT p.name FROM people AS p WHERE p.id = c.seller_2_id ) AS vendedor_2,
ost.protocol AS protocolo,
(SELECT tos.title FROM incident_types AS tos WHERE tos.id = ost.incident_type_id) AS tipo_os,
ca.activation_date AS data_ativacao,
c.amount AS valor_contrato,
nf.total_amount_products AS valor_produto,
nf.total_amount_liquid AS valor_ativacao,
CASE WHEN nf.total_amount_products IS NULL THEN c.amount WHEN nf.total_amount_liquid IS NULL THEN c.amount 
ELSE c.amount + nf.total_amount_products + nf.total_amount_liquid END AS total_recebido,
(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
(SELECT cont.title FROM crm_contact_origins AS cont WHERE cont.id = org.crm_contact_origin_id) AS origem_contato,
c.v_status AS status_contrato,
c.v_stage AS estagio_contrato,
c.approval_date AS data_aprovacao,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato

FROM
contract_assignment_activations AS ca
INNER JOIN 
contracts AS c ON ca.contract_id = c.id
INNER JOIN
people AS p ON c.client_id = p.id
LEFT JOIN
assignment_incidents AS ost ON ca.assignment_id = ost.assignment_id
LEFT JOIN 
invoice_notes AS nf ON ca.invoice_note_id = nf.id
LEFT JOIN
authentication_contracts AS pl ON ca.contract_id = pl.contract_id
LEFT JOIN
people_crm_informations AS org ON p.id = org.person_id
LEFT JOIN 
person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
LEFT JOIN 
contract_items AS con ON con.contract_id = ca.contract_id

WHERE
ca.activation_date BETWEEN '2023-01-01' AND '2023-01-31'

GROUP BY id_contrato, tipo_cliente, cod_cliente, bairro, cidade, data_cadastro, plano, plano_02,vendedor_1,
equipe, vendedor_2, protocolo, tipo_os, data_ativacao, valor_contrato, valor_produto, valor_ativacao,
empresa, origem_contato, status_contrato, estagio_contrato, tipo_contrato,data_aprovacao, c.seller_1_id