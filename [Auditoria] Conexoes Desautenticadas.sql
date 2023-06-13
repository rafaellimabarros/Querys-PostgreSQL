SELECT DISTINCT ON (ace.id)
	c.id AS cod_contrato,
	p.name AS cliente,
	c.v_status AS status_contrato,
	ac.user AS pppoe,
	(SELECT p.name FROM people AS p WHERE p.id = ace.person_id) AS usuario_desautenticador,
	ace.date AS data_desautenticacao,
	ace.description AS descricao,
	FIRST_VALUE(ai.protocol) OVER (PARTITION BY ace.id ORDER BY ai.protocol asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) primeiro_protocolo_apos_evento,
	FIRST_VALUE((SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id)) OVER (PARTITION BY ace.id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) primeiro_protocolo_apos_evento,
	FIRST_VALUE((SELECT p.name FROM people AS p WHERE p.id = a.responsible_id )) OVER (PARTITION BY ace.id ORDER BY ai.protocol asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) usuario_encerrou_primeiro_protocolo_apos_evento,
	FIRST_VALUE(a.conclusion_date) OVER (PARTITION BY ace.id ORDER BY ai.protocol asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) data_encerramento_primeiro_protocolo_apos_evento,
	
	LAST_VALUE(ai.protocol) OVER (PARTITION BY ace.id ORDER BY ai.protocol asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ultimo_protocolo_apos_evento,
	LAST_VALUE((SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id)) OVER (PARTITION BY ace.id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ultimo_protocolo_apos_evento,
	LAST_VALUE((SELECT p.name FROM people AS p WHERE p.id = a.responsible_id )) OVER (PARTITION BY ace.id ORDER BY ai.protocol asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) usuario_encerrou_ultimo_protocolo_apos_evento,
	LAST_VALUE(a.conclusion_date) OVER (PARTITION BY ace.id ORDER BY ai.protocol asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) data_encerramento_ultimo_protocolo_apos_evento


	FROM authentication_contract_events AS ace
	LEFT JOIN authentication_contracts AS ac ON ac.id = ace.authentication_contract_id
	LEFT JOIN contracts AS c ON c.id = ac.contract_id
	LEFT JOIN people AS p ON p.id = c.client_id
	LEFT JOIN assignments AS a ON a.requestor_id = p.id AND a.conclusion_date >= ace.date
	LEFT JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

	WHERE 
		ace.description LIKE '%Conexão Desprovisionada%'