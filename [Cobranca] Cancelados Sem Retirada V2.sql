SELECT DISTINCT ON (ai.protocol)
p.id AS cod_cliente,
c.id AS cod_contrato,
p.name AS cliente,
c.v_status AS status_contrato,
DATE(c.cancellation_date) AS data_cancelamento,
CASE WHEN notas.financial_operation_id = 9 AND DATE(notas.created) >= DATE(a.created) THEN 'Sim' ELSE 'Nao' END AS retirada,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE(a.created) AS data_abertura_solicitacao,
date(a.conclusion_date) AS data_encerramento_solicitacao,
(SELECT iss.title FROM incident_status AS iss WHERE iss.id = ai.incident_status_id) AS status_solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS usuario_responsavel,
(SELECT p.name FROM people AS p WHERE p.id = (SELECT MAX(r.person_id) FROM reports AS r WHERE r.assignment_id = a.id and r.progress >= 100)) AS usuario_reltao_encerramento,
(SELECT pg.title FROM people_groups AS pg WHERE pg.id = (SELECT MAX(ppg.people_group_id) FROM person_people_groups AS ppg WHERE ppg.person_id = (SELECT max(r.person_id) FROM reports AS r WHERE r.assignment_id = a.id and r.progress >= 100))) AS equipe_relato,
CASE WHEN 
		LAST_VALUE(ce.contract_event_type_id) OVER (
				  PARTITION BY c.id
		        ORDER BY ce.id asc
		        RANGE BETWEEN
		            UNBOUNDED PRECEDING AND
		            UNBOUNDED FOLLOWING
		    ) = 184
		OR LAST_VALUE(ce.contract_event_type_id) OVER (
				  PARTITION BY c.id
		        ORDER BY ce.id asc
		        RANGE BETWEEN
		            UNBOUNDED PRECEDING AND
		            UNBOUNDED FOLLOWING
		    ) = 214
		THEN 'Involuntario' 
		ELSE 'Voluntario' 
		END AS tipo_cancelamento

FROM assignments AS a
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN people AS p ON p.id = a.requestor_id
INNER JOIN contracts AS c ON c.client_id = p.id
INNER JOIN invoice_notes AS notas ON notas.client_id = p.id 
LEFT JOIN reports AS r ON r.assignment_id = a.id
LEFT JOIN contract_events AS ce ON c.id = ce.contract_id AND ce.contract_event_type_id IN (184,214,110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,185,186,187,188,190,191,192,194,195,196,197,198,199,200,201,202,203,204,205,225,226)

WHERE ai.incident_type_id IN (1015,1291)
AND ai.incident_status_id != 8
AND c.v_status = 'Cancelado'
AND c.cancellation_date BETWEEN '2022-01-01' AND '2022-10-31'
AND c.id NOT IN (
	SELECT
	c.id 
	FROM assignments AS a
	INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
	INNER JOIN people AS p ON p.id = a.requestor_id
	INNER JOIN contracts AS c ON c.client_id = p.id
	INNER JOIN invoice_notes AS notas ON notas.client_id = p.id 
	
	WHERE ai.incident_type_id IN (1015,1291)
	AND ai.incident_status_id != 8
	AND c.v_status = 'Cancelado'
	AND c.cancellation_date BETWEEN '2022-01-01' AND '2022-10-31'
	AND notas.financial_operation_id = 9
	AND a.erp_code IS  NULL
	AND DATE(notas.created) >= DATE(a.created)
)
