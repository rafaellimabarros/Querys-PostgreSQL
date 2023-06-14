SELECT DISTINCT ON (ai.protocol)
p.name AS nome_cliente,
it.id,
ai.protocol,
it.title AS tipo_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.created_by) AS responsevel_abertura,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_atual,
p.id AS id_cliente,
c.id AS id_contrato

FROM assignments AS a 
left JOIN assignment_incidents AS ai ON a.id = ai.assignment_id
left JOIN incident_types AS it ON ai.incident_type_id =  it.id
INNER JOIN people AS p ON ai.person_id = p.id
INNER JOIN contracts AS c ON p.id = c.client_id

WHERE 
 DATE (a.conclusion_date) BETWEEN '2023-01-01' AND '2023-01-10'
	AND it.id IN (1570,1602)