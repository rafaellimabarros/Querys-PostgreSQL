SELECT 
a.id,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id ) AS cliente,
(SELECT tx.name FROM tx_types AS tx WHERE tx.id = (SELECT p.type_tx_id FROM people AS p WHERE p.id = a.requestor_id ) ) AS tipo_cliente,
(SELECT p.city FROM people AS p WHERE p.id = a.requestor_id ) AS cidade,
(SELECT p.neighborhood FROM people AS p WHERE p.id = a.requestor_id ) AS bairro,
asi.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE asi.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS responsavel_encerramento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = rp.created_by)responsavel_remarcacao,
rp.description ,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = asi.incident_status_id) AS status_atual,
DATE (a.created) AS data_abertura,
DATE (rp.modified) AS data_remarcacao,
DATE (a.conclusion_date) AS data_encerramento

FROM reports AS rp
INNER JOIN assignment_incidents AS asi ON asi.assignment_id = rp.assignment_id
INNER JOIN assignments AS a ON a.id = asi.assignment_id
INNER JOIN teams AS t ON t.id = a.team_id
LEFT JOIN assignment_person_routings AS apr ON apr.id = asi.assignment_id

WHERE 
asi.incident_status_id = 4
AND rp.type = 2
AND rp.progress < 100
AND DATE (rp.modified) BETWEEN '2023-01-01' AND '2023-04-30'