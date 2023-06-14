SELECT DISTINCT ON (ai.protocol,date(s.start_date))
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT ist.title FROM incident_status AS ist WHERE ist.id = ai.incident_status_id) AS status_solicitacao,
date(s.start_date) AS data_agendamento,
(SELECT p.name FROM people AS p WHERE p.id = s.person_id) AS agendado_para,
(SELECT t.title FROM teams AS t WHERE t.id = (SELECT vu.team_id FROM v_users AS vu WHERE vu.tx_id = (SELECT p.tx_id FROM people AS p WHERE p.id = s.person_id))) AS equipe,


CASE WHEN s.rescheduled = TRUE THEN 'Sim' ELSE 'Nao' END AS reagendado,
p.id AS cod_cliente,
p.name AS cliente,
p.neighborhood AS bairro,
p.city AS cidade

FROM assignments AS a
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN schedules AS s ON s.assignment_id = a.id
INNER JOIN people AS p ON p.id = a.requestor_id

WHERE DATE(s.start_date) BETWEEN '2023-04-01' AND DATE(curdate())
AND ai.incident_type_id IN (1015, 1287, 1291, 1708)