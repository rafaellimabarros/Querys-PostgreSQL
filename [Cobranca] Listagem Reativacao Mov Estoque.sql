SELECT DISTINCT ON (p.id)
p.id AS id_cliente,
c.id AS id_contrato,
p.name AS nome_cliente,
it.title AS tipo_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.created_by) AS responsevel_abertura,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_atual

FROM assignments AS a 
left JOIN assignment_incidents AS ai ON a.id = ai.assignment_id
INNER JOIN incident_types AS it ON ai.incident_type_id =  it.id
INNER JOIN people AS p ON ai.person_id = p.id
INNER JOIN contracts AS c ON p.id = c.client_id

WHERE 
	a.created BETWEEN '2023-01-01' AND '2023-01-06'
AND 
	it.id = 1602