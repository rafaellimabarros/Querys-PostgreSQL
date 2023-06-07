SELECT
	ai.protocol AS protocolo,
	(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
	DATE(a.conclusion_date) AS data_encerramento,
	fatr.receipt_date AS data_pagamento,
	(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS responsavel_encerramento,
	(SELECT t.title FROM teams AS t WHERE t.id = (SELECT vu.team_id FROM v_users AS vu WHERE vu.tx_id = (SELECT p.tx_id FROM people AS p WHERE p.id = a.responsible_id))) AS equipe,
	(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_atual,
	p.id AS cod_cliente,
	p.name AS cliente,
	p.neighborhood AS bairro,
	p.city AS cidade,
	(SELECT sc.title FROM solicitation_classifications AS sc WHERE sc.id = ai.solicitation_classification_id) AS contexto,
	(SELECT sp.title FROM solicitation_problems AS sp WHERE sp.id = ai.solicitation_problem_id) AS problema,
	fat.title AS fatura,
	(SELECT pf.title FROM payment_forms AS pf WHERE pf.id = fatr.payment_form_id) AS forma_pagamento,
	SUM((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido
	
	FROM assignments AS a
		JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
		JOIN people AS p ON p.id = a.requestor_id
		JOIN financial_receivable_titles AS fat ON fat.client_id = a.requestor_id AND fat.title LIKE '%FAT%'
		JOIN financial_receipt_titles AS fatr ON fatr.financial_receivable_title_id = fat.id AND fatr.receipt_date >= DATE(a.conclusion_date) AND fatr.receipt_date <= cast(date_trunc('day', DATE(a.conclusion_date)+INTERVAL '4 day') as DATE)
		
	WHERE 
		DATE(a.conclusion_date) BETWEEN '2023-01-01' AND DATE(curdate()) AND ai.incident_type_id IN (1287)
		AND ai.incident_status_id = 4
	
	GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15