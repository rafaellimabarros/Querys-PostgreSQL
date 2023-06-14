SELECT
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE(a.conclusion_date) AS data_encerramento,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS responsavel_encerramento,
(SELECT t.title FROM teams AS t WHERE t.id = (SELECT vu.team_id FROM v_users AS vu WHERE vu.tx_id = (SELECT p.tx_id FROM people AS p WHERE p.id = a.responsible_id))) AS equipe,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_atual,
p.id AS cod_cliente,
p.name AS cliente,
p.neighborhood AS bairro,
p.city AS cidade,
(SELECT sc.title FROM solicitation_classifications AS sc WHERE sc.id = ai.solicitation_classification_id) AS contexto,
(SELECT sp.title FROM solicitation_problems AS sp WHERE sp.id = ai.solicitation_problem_id) AS problema

FROM assignments AS a 
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN people AS p ON p.id = a.requestor_id

WHERE DATE(a.conclusion_date) BETWEEN '2023-03-01' AND DATE(curdate()) AND ai.incident_type_id IN (1015, 1287, 1291, 1708)
AND ai.incident_status_id = 4