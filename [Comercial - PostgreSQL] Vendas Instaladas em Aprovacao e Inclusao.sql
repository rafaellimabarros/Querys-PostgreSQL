SELECT 
c.id AS contrato,
p.name,
ai.protocol,
(SELECT tos.title FROM incident_types AS tos WHERE tos.id = ai.incident_type_id) AS tipo_os,
DATE(a.conclusion_date) AS data_os,
c.v_stage

FROM contracts AS c 
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN assignments AS a ON a.requestor_id = p.id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE (c.v_stage IN ('Em Aprovação','Pré-Contrato') AND c.deleted = FALSE 
AND ai.incident_type_id IN (1005,1006) AND DATE(a.conclusion_date) >= DATE(c.created) AND ai.incident_status_id = 4
AND c.id IN (
	SELECT 
	c.id
	FROM contracts AS c 
	INNER JOIN people AS p ON p.id = c.client_id
	INNER JOIN assignments AS a ON a.requestor_id = p.id
	INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
	WHERE ai.incident_status_id = 4 AND ai.incident_type_id IN (1005,1006)
	AND DATE(a.conclusion_date) >= DATE(c.created))
)

