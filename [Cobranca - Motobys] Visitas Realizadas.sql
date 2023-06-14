SELECT
p.id AS cod_cliente,
p.name AS cliente,
p.neighborhood AS bairro,
p.city AS cidade,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE(r.created) as data_visita,
DATE(a.conclusion_date) as data_encerramento,
CASE 
WHEN r.description LIKE '%para <b>Remarcação%' THEN 'Remarcação'
WHEN r.description LIKE '%para <b>Reagendado%' THEN 'Reagendado'
WHEN r.description LIKE '%para <b>Encerramento%' THEN 'Encerramento'
WHEN ai.incident_status_id = 4 AND r.progress = 100 THEN 'Encerramento' 
ELSE NULL 
END AS tipo_relato,
vu.name AS usuario_relato,
(SELECT t.title FROM teams AS t WHERE t.id = vu.team_id) AS equipe_usuario_relato,
r.description AS relato,
(SELECT sc.title FROM solicitation_classifications AS sc WHERE sc.id = ai.solicitation_classification_id) AS contexto,
(SELECT sp.title FROM solicitation_problems AS sp WHERE sp.id = ai.solicitation_problem_id) AS problema

FROM assignments AS a 
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN people AS p ON p.id = a.requestor_id
INNER JOIN reports AS r ON r.assignment_id = a.id
INNER JOIN v_users AS vu ON vu.id = r.created_by AND vu.team_id = 1064

WHERE DATE(r.created) BETWEEN '2023-04-01' AND DATE(curdate()) AND ai.incident_type_id IN (1015, 1287, 1291, 1708)
AND r.description LIKE '%para <b>Remarcação%' 

OR

date(r.created) BETWEEN '2023-04-01' AND DATE(curdate()) AND ai.incident_type_id IN (1015, 1287, 1291, 1708)
AND r.description LIKE '%para <b>Reagendado%' 

OR

date(r.created) BETWEEN '2023-04-01' AND DATE(curdate()) AND ai.incident_type_id IN (1015, 1287, 1291, 1708)
AND r.description LIKE '%para <b>Encerramento%' AND ai.incident_status_id = 4

OR

date(r.created) BETWEEN '2023-04-01' AND DATE(curdate()) AND ai.incident_type_id IN (1015, 1287, 1291, 1708)
AND ai.incident_status_id = 4 AND r.progress = 100