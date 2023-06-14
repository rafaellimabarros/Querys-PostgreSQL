SELECT
p.id AS cod_responsavel,
date(pe.created) AS data_movimentacao,
inv.document_number AS numero_nota_fiscal,
(SELECT P.name FROM people AS p WHERE p.id = pe.person_id) AS responsavel,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = pe.service_product_id) AS patrimonio,
sp.code AS codigo_produto,
CASE
WHEN pe.signal = 1 THEN 'Entrada'
WHEN pe.signal = 2 THEN 'Saida'
END AS tipo,
(SELECT um.title FROM units_measures AS um WHERE um.id = pe.first_units_measure_id) AS medida,
pe.units AS quantidade,
ai.protocol AS protocolo_saida,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente


FROM person_product_movimentations AS pe  

LEFT JOIN
	invoice_notes AS inv ON pe.invoice_note_id = inv.id
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
DATE(pe.created) BETWEEN '2021-01-01' AND DATE(curdate())
AND v.team_id IN (1064)
