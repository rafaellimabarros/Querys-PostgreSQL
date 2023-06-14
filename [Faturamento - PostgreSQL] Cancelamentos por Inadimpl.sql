SELECT
c.id AS cod_contrato,
p.name AS cliente,
ai.protocol,
(SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id) AS tipo_os,
ai.incident_type_id,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id ) AS status_solic,
c.v_status AS status_contrato,
(SELECT cet.title FROM contract_event_types AS cet WHERE ce.contract_event_type_id = cet.id) AS evento,
date(ce.created) AS data_evento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ce.modified_by ) AS responsavel,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.modified_by) AS operador_encerramento,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
(SELECT i.title FROM incident_status AS i  WHERE ai.incident_status_id = i.id) AS status_solicitacao,
a.conclusion_date AS data_encerramento

FROM contract_events AS ce
INNER JOIN contracts AS c ON c.id = ce.contract_id
INNER JOIN people AS p ON p.id = c.client_id
inner JOIN assignments AS a ON a.requestor_id = p.id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE DATE(ce.created) BETWEEN '2022-06-01' AND '2022-06-30' AND ce.contract_event_type_id = 184
AND c.v_status IN ('Cancelado', 'Encerrado') AND ai.incident_status_id = 4