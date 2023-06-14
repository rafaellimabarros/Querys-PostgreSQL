SELECT DISTINCT ON (a.id)
	p.id AS cod_cliente,
	p.name AS cliente,
	a.title AS titulo,
	a.description AS descrição,
	CASE WHEN a.progress < 100 THEN 'Andamento' ELSE 'Encerramento' END AS status,
	a.progress AS progresso,
	(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.created_by) AS solicitante,
	(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS responsavel,
	date(a.created) AS data_abertura,
	date(a.conclusion_date) AS data_conclusao,
	p.city AS cidade,
	p.neighborhood AS bairro,
	p.email AS email_cliente,
	p.phone AS telefone,
	p.cell_phone_1 AS celular

FROM assignments AS a
INNER JOIN people_crm_information_interactions AS pcii ON a.title = pcii.title
INNER JOIN people AS p ON p.id = pcii.client_id

WHERE a.assignment_origin = 71
AND a.final_date IS NOT  NULL 
AND a.deleted= FALSE
AND a.assignment_type != 'MANA' AND a.task = TRUE 
AND date(a.created) BETWEEN '2022-07-01' AND '2022-08-31'