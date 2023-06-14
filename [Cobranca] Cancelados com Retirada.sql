SELECT DISTINCT ON (ai.protocol)
p.id AS cod_cliente,
c.id AS cod_contrato,
p.name AS cliente,
c.v_status AS status_contrato,
DATE(c.cancellation_date) AS data_cancelamento,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE(a.created) AS data_abertura_solicitacao,
date(a.conclusion_date) AS data_encerramento_solicitacao,
(SELECT iss.title FROM incident_status AS iss WHERE iss.id = ai.incident_status_id) AS status_solicitacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.modified_by) AS usuario_encerramento_solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS usuario_responsavel,
date(notas.created) AS data_retirada,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = notas.created_by) AS usuario_responsavel_retirada,
CASE WHEN notas.financial_operation_id = 9 AND DATE(notas.created) >= DATE(a.created) THEN 'Sim' ELSE 'Nao' END AS retirada

FROM assignments AS a
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN people AS p ON p.id = a.requestor_id
INNER JOIN contracts AS c ON c.client_id = p.id
INNER JOIN invoice_notes AS notas ON notas.client_id = p.id 

WHERE ai.incident_type_id IN (1015,1291)
AND ai.incident_status_id != 8
AND c.v_status = 'Cancelado'
AND c.cancellation_date BETWEEN '2022-01-01' AND '2022-10-31'
AND notas.financial_operation_id = 9
AND a.erp_code IS  NULL
AND DATE(notas.created) >= DATE(a.created)

OR

ai.incident_type_id = 1346
AND ai.incident_status_id != 8
AND c.v_status = 'Cancelado'
AND c.cancellation_date BETWEEN '2022-01-01' AND '2022-10-31'
AND notas.financial_operation_id = 9