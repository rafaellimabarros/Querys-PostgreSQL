SELECT DISTINCT ON (asi.protocol)
asi.protocol AS protocolo,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id ) AS cliente,
(SELECT it.title FROM incident_types AS it WHERE asi.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS responsavel_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = asi.incident_status_id) AS status_atual,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento


FROM reports AS rp
INNER JOIN assignment_incidents AS asi ON asi.assignment_id = rp.assignment_id
INNER JOIN assignments AS a ON a.id = asi.assignment_id
INNER JOIN teams AS t ON t.id = a.team_id
LEFT JOIN assignment_person_routings AS apr ON apr.id = asi.assignment_id
LEFT JOIN solicitation_routing_motives AS srm ON srm.id = apr.solicitation_routing_motive_id

WHERE 
asi.team_id = 1003
AND rp.type IS NULL
AND rp.progress = 0 
AND rp.title NOT LIKE '%Reabertura (Simples)%'
AND DATE (a.conclusion_date) BETWEEN '2022-12-01' AND '2022-12-31'