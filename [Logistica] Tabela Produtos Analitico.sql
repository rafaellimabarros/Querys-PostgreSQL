SELECT
p.id AS cod_responsavel,
date(pe.created) AS data_movimentacao,
inv.document_number AS numero_nota_fiscal,
(SELECT P.name FROM people AS p WHERE p.id = pe.person_id) AS responsavel,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe,
sp.code AS codigo_produto,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = pe.service_product_id) AS produto,
pe.units AS quantidade,
pe.unit_amount AS valor_unidade,
(SELECT um.title FROM units_measures AS um WHERE um.id = pe.first_units_measure_id) AS medida,
CASE WHEN pe.signal = 1 THEN 'Entrada' WHEN pe.signal = 2 THEN 'Saida' END AS tipo,
CASE WHEN pe.signal = 2 AND ai.protocol IS NULL THEN 'para_empresa' WHEN pe.signal = 2 AND ai.protocol IS NOT NULL THEN 'Para cliente' END AS tipo_saida,
ai.protocol AS protocolo_saida,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = inv.company_place_id) AS empresa,
(SELECT v.name FROM v_users AS v WHERE v.id = inv.created_by) AS usuario_movimentador,
inv.observation_invoice_1 AS observacao_movimentacao

FROM person_product_movimentations AS pe  
LEFT JOIN invoice_notes AS inv ON pe.invoice_note_id = inv.id
INNER JOIN
	people AS p ON p.id = pe.person_id
LEFT JOIN
	v_users AS v ON p.name = v.name

LEFT JOIN
	assignments AS a ON a.id = pe.assignment_id
LEFT JOIN
	assignment_incidents AS ai ON a.id = ai.assignment_id
LEFT JOIN
	service_products AS sp ON  pe.service_product_id = sp.id

WHERE 
DATE(pe.created) BETWEEN '2023-02-01' AND '2023-02-28'
AND v.team_id IN (1,1003,1011)
AND p.id = 42