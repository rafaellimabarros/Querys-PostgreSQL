SELECT DISTINCT  (p.id),
p.id AS cod_cliente,
c.id AS numero_contato,
p.name AS nome,
(SELECT ct.title FROM contract_event_types AS ct WHERE  ce.contract_event_type_id = ct.id ) AS status_contrato,
c.cancellation_date AS data_cancelamento,
it.title AS tipo_solicitacao,
ai.protocol AS protocolo,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.modified_by) AS operador_encerramento,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
(SELECT i.title FROM incident_status AS i  WHERE ai.incident_status_id = i.id) AS status_solicitacao,
a.conclusion_date AS encerramento_solicitacao

FROM assignment_incidents AS ai
INNER JOIN people AS p ON p.id = ai.person_id
INNER JOIN incident_types AS it ON it.id = ai.incident_type_id
INNER JOIN contracts AS c ON p.id = c.client_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN assignments  AS a ON a.id = ai.assignment_id

WHERE ai.incident_type_id IN (1015,1231,1271,1291,1385,1484) 
AND ai.incident_status_id = 4
AND c.v_status IN ('Cancelado', 'Encerrado') 
AND DATE (ce.created) BETWEEN '2022.06.01' AND '2022.06.30'
AND ce.contract_event_type_id = 184
AND ai.team_id IN (1003, 1005) /*não pode confiar nessa equipe*/

ORDER BY c.id