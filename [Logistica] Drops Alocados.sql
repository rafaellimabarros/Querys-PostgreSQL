SELECT
DATE(notas.created) AS data_alocacao,
(SELECT p.name FROM people AS p WHERE p.id = ai.client_id) AS cliente,
(SELECT p.city FROM people AS p WHERE p.id = ai.client_id) AS cidade,
(SELECT p.neighborhood FROM people AS p WHERE p.id = ai.client_id) AS bairro,
vp.responsible_name AS tecnico_responsavel,
vp.service_product_title AS produto,
vp.allocated_amount AS quantidade,
vp.first_unit_measure_title AS unidade,
ai.protocol AS protocolo,
(SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id) AS tipo_os

FROM v_allocated_products AS vp
INNER JOIN invoice_notes AS notas ON notas.id = vp.invoice_note_id
INNER JOIN assignments AS a ON a.id = vp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE DATE(notas.created) BETWEEN '2022-10-01' AND '2022-12-31'
and vp.allocated_amount > 0
AND vp.service_product_title = 'CABO DROP FLAT 01FO (1 KM)'

ORDER BY DATE(notas.created) asc