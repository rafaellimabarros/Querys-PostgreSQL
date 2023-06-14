SELECT DISTINCT ON (c.id)
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.city AS cidade,
CASE WHEN ac.service_product_id IS NULL THEN (SELECT serv.title FROM service_products AS serv WHERE serv.id = ci.service_product_id)
ELSE (SELECT serv.title FROM service_products AS serv WHERE serv.id = ac.service_product_id) END  AS plano,
CASE WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
CASE WHEN caa.activation_date IS NULL THEN DATE(a.conclusion_date) ELSE caa.activation_date END AS data_ativacao,
c.amount AS valor_contrato,
(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
c.v_status AS status_contrato,
c.v_stage AS estagio_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato

/*p.neighborhood AS bairro,*/
/*(SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) AS vendedor_1,*/
/*nf.total_amount_products AS valor_produto,
nf.total_amount_liquid AS valor_ativacao,
CASE WHEN nf.total_amount_products IS NULL THEN c.amount WHEN nf.total_amount_liquid IS NULL THEN c.amount
ELSE c.amount + nf.total_amount_products + nf.total_amount_liquid end AS total_recebido,*/

FROM contracts AS c 
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN assignments AS a ON a.requestor_id = p.id
/*INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id*/
INNER JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
/*LEFT JOIN invoice_notes AS nf ON nf.id = caa.invoice_note_id*/
/*LEFT JOIN people_crm_informations AS org ON p.id = org.person_id*/
LEFT JOIN contract_items AS ci ON ci.contract_id = c.id

WHERE caa.activation_date BETWEEN cast(date_trunc('month', current_date-INTERVAL '13 month') as date) AND DATE(curdate())

-- GROUP BY c.id, 1,2,3,4,5,6,7,8,9,10
