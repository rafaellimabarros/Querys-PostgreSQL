SELECT DISTINCT ON (asi.protocol)
asi.protocol AS protocolo_solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id ) AS cliente,
(SELECT it.title FROM incident_types AS it WHERE asi.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS responsavel_encerramento,
rp.description AS relato_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = asi.incident_status_id) AS status_atual,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,p.city AS cidade_cliente,
p.neighborhood AS bairro_cliente,
p.street AS rua_cliente,
CASE 
WHEN a.conclusion_date < a.final_date THEN 'No Prazo' 
WHEN a.conclusion_date > a.final_date THEN 'Fora do Prazo' 
END AS SLA,
rp.final_geoposition_latitude as latitude_encerramento,
rp.final_geoposition_longitude AS longitude_encerramento

FROM reports AS rp
INNER JOIN assignments AS a ON a.id = rp.assignment_id
INNER JOIN assignment_incidents AS asi ON asi.assignment_id = a.id
INNER JOIN people AS p ON asi.person_id = p.id
LEFT JOIN teams AS t ON t.id = asi.team_id
LEFT JOIN assignment_person_routings AS apr ON apr.id = asi.assignment_id

WHERE 
t.id IN (1003,1030,1033,1032,1029,1035,1031,1034,1036,1047,1048,1052,1054,10531043,1049,1046)
AND rp.progress >= 100
AND DATE(a.conclusion_date) BETWEEN '2023-01-03' AND '2023-01-03'
AND asi.incident_status_id = 4