SELECT
p.name AS nome_cliente,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it  WHERE it.id = ai.incident_type_id) AS tipo_OS,
r.created AS data_retrabalho,
r.title AS titulo_retrabalho,
(SELECT te.title FROM teams AS te WHERE te.id = ai.team_id) AS equipe,
(SELECT p.name FROM v_users AS p WHERE p.id = r.modified_by) AS tecnico,
r.description AS encerramento,
a.created AS data_abertura_os,
a.conclusion_date AS data_encerramento_os,
(SELECT ist.title FROM incident_status AS ist WHERE ist.id = ai.incident_status_id) AS status_atual


FROM reports AS r
INNER JOIN assignment_incidents AS ai ON r.assignment_id = ai.assignment_id
INNER JOIN assignments AS a ON a.id = ai.assignment_id
LEFT JOIN people AS p ON p.id = ai.client_id

WHERE 
-- ai.team_id IN (1030,1046,1049,1054,1053,1052,1048,1047,1036,1034,1031,1035,1029,1032,1003,1033)
   ai.sector_area_id = 6
AND date(a.created) BETWEEN '2023-04-01' AND '2023-04-30'
and r.title LIKE '%Reabertura (Retrabalho)%'

OR
-- ai.team_id IN (1030,1046,1049,1054,1053,1052,1048,1047,1036,1034,1031,1035,1029,1032,1003,1033)
   ai.sector_area_id = 6
AND date(a.created) BETWEEN '2023-04-01' AND '2023-04-30'
and r.title LIKE '%Atendimento%'
AND r.progress >= 100
AND r.final_geoposition_latitude IS NOT NULL
AND ai.protocol IN (
	select
	ai.protocol
	
	FROM reports AS r
	INNER JOIN assignment_incidents AS ai ON r.assignment_id = ai.assignment_id
	INNER JOIN assignments AS a ON a.id = ai.assignment_id
	LEFT JOIN people AS p ON p.id = ai.client_id
	
	WHERE 
 	-- ai.team_id IN (1030,1046,1049,1054,1053,1052,1048,1047,1036,1034,1031,1035,1029,1032,1003,1033)
	ai.sector_area_id = 6
	AND date(a.created) BETWEEN '2023-04-01' AND '2023-04-30'
	and r.title LIKE '%Reabertura (Retrabalho)%'	
)

ORDER BY ai.protocol, r.created asc