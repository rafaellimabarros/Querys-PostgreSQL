SELECT DISTINCT ON (c.id)
	c.id AS id_contrato,
	p.name AS cliente,
	c.v_status AS status_contrato,
	(SELECT cet.title FROM contract_event_types AS cet WHERE cet.id = ce.contract_event_type_id) AS tipo_evento,
	ce.date AS data_exclusao,
	ce.description AS descricao,
	(SELECT vu.name FROM v_users AS vu WHERE vu.id = ce.created_by) AS usuario_excluiu,	
	LAST_VALUE(ai.protocol) OVER (PARTITION BY c.id ORDER BY ai.protocol asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ultimo_protocolo,
	LAST_VALUE((SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id)) OVER (PARTITION BY c.id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ultimo_protocolo,
	LAST_VALUE((SELECT p.name FROM people AS p WHERE p.id = a.responsible_id )) OVER (PARTITION BY c.id ORDER BY ai.protocol asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) usuario_encerrou
	
	FROM contracts AS C
	JOIN contract_events AS ce ON ce.contract_id = c.id
	JOIN people AS p ON p.id = c.client_id
	INNER JOIN assignments AS a ON a.requestor_id = p.id
	INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE
	ce.contract_event_type_id = 105
	AND ce.date BETWEEN '2023-01-01' AND '2023-06-08'
