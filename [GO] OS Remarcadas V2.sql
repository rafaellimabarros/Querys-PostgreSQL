SELECT 
DATE (rp.created) AS data_remarcacao,
CASE WHEN rp.description LIKE '%para <b>Remarcação%' THEN 'Remarcação' WHEN rp.description LIKE '%para <b>Reagendado%' THEN 'Reagendado' ELSE NULL END AS tipo_relato,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = rp.created_by)responsavel_remarcacao,
(SELECT p.city FROM people AS p WHERE p.id = a.requestor_id ) AS cidade,
(SELECT p.neighborhood FROM people AS p WHERE p.id = a.requestor_id ) AS bairro,
asi.protocol AS protocolo,
rp.description,
(SELECT it.title FROM incident_types AS it WHERE asi.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT ist.title FROM incident_status AS ist WHERE ist.id = asi.incident_status_id)  AS status_atual

FROM reports AS rp
INNER JOIN assignment_incidents AS asi ON asi.assignment_id = rp.assignment_id
INNER JOIN assignments AS a ON a.id = asi.assignment_id
INNER JOIN teams AS t ON t.id = a.team_id
LEFT JOIN assignment_person_routings AS apr ON apr.id = asi.assignment_id

WHERE DATE (rp.created) BETWEEN cast(date_trunc('month', current_date-INTERVAL '11 month') as date) AND  current_date
and asi.sector_area_id = 6
AND rp.description LIKE '%para <b>Remarcação%'

OR

DATE (rp.created) BETWEEN cast(date_trunc('month', current_date-INTERVAL '11 month') as date) AND  current_date
and asi.sector_area_id = 6
AND rp.description LIKE '%para <b>Reagendado%'
