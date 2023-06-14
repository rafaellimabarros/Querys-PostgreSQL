SELECT
DATE(notas.created) AS DATA,
CONCAT(DATE_PART('hour',notas.created),':',DATE_PART('minute',notas.created),':',trunc(DATE_PART('seconds',notas.created))) AS horario,
notas.document_number AS nota_fiscal,
vp.responsible_name AS responsavel,
(SELECT p.name FROM people AS p WHERE p.id = ai.client_id) AS cliente,
notas.company_place_name AS empresa,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = notas.invoice_serie_id) AS serie,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = notas.financial_operation_id) AS operacao,
vp.service_product_title AS produto,
vp.allocated_amount AS quantidade,
vp.first_unit_measure_title AS unidade,
ai.protocol AS protocolo,
ai.incident_type_id,
(SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id) AS tipo_os,
a.beginning_date AS data_abertura,
a.final_date AS prazo,
a.conclusion_date AS data_encerramento,
CASE WHEN a.conclusion_date > a.final_date THEN 'Sim' ELSE 'Nao' END AS em_atraso

FROM v_allocated_products AS vp
INNER JOIN invoice_notes AS notas ON notas.id = vp.invoice_note_id
INNER JOIN assignments AS a ON a.id = vp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE DATE(notas.created) BETWEEN '2022-11-07' AND '2022-11-07'
and vp.allocated_amount > 0
AND vp.responsible_name LIKE '%CAIO FELIPE GOMES DOS SANTOS%'