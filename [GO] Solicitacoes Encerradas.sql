SELECT DISTINCT ON (ai.protocol)
	(SELECT cp.description FROM companies_places AS cp WHERE cp.id = a.company_place_id) AS LOCAL,
	a.description AS descricao,
	(SELECT it.title FROM incident_status AS it WHERE it.id = ai.incident_status_id) AS status,
	ai.protocol AS protocolo,
	(SELECT sa.description FROM service_level_agreements AS sa where sa.id = ai.service_level_agreement_id) AS situacao,
	(SELECT sat.title FROM service_level_agreement_types AS sat WHERE sat.id =  ai.service_level_agreement_type_id) AS sla,
	(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_Solicitacao,
	(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS setor,
	(SELECT sa.title FROM sector_areas AS sa WHERE sa.id = ai.sector_area_id) AS setor_origem,
	(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
	(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
	(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS atendente_origem,
	DATE (a.created) AS data_abertura,
	date(a.final_date) AS data_prazo,
	date(a.conclusion_date) AS data_encerramento,
	CASE 
	WHEN DATE (a.conclusion_date) <= DATE (a.final_date) THEN 'Não' 
	WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN 'Sim' 
	END AS em_atraso,
	CASE 
		WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN datediff(DATE(a.conclusion_date),DATE(a.final_date)) 
		WHEN DATE (a.conclusion_date) < DATE (a.final_date) THEN NULL 
	END AS dias_atraso,
	DATE (ai.date_to_start) AS data_incio_atendimento,
	(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS solicitante,
	(SELECT sc.title from solicitation_classifications AS sc WHERE sc.id = ai.solicitation_classification_id) AS contexto_solicitacao,
	(SELECT sp.title FROM solicitation_problems AS sp WHERE sp.id = ai.solicitation_problem_id) AS problema_solicitacao

FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN reports AS r ON r.assignment_id = a.id

WHERE 
DATE (a.conclusion_date) BETWEEN '2023-04-01' AND '2023-04-17'
and ai.team_id IN (1003)
AND ai.incident_status_id IN (4)