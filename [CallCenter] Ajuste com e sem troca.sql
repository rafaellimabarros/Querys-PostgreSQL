SELECT DISTINCT ON (ai.protocol) 
c.id AS cod_contrato,
(SELECT p.name FROM people AS p WHERE p.id = c.client_id) AS cliente,
ai.protocol AS protocolo,
(SELECT ist.title FROM incident_status AS ist WHERE ist.id = ai.incident_status_id) AS status,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS aberto_por,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) solicitacao_tipo,
c.amount AS valor,
CASE
WHEN ai.incident_type_id IN (51,1017) THEN 2.5
WHEN ai.incident_type_id IN (1604,1605) THEN 1.5
WHEN ai.incident_type_id IN (1606,52) THEN 1
END AS pontuacao

FROM assignments AS a
INNER JOIN
	assignment_incidents AS ai ON a.id = ai.assignment_id
INNER JOIN
	people AS p ON p.id = a.requestor_id
INNER JOIN
	v_users AS v ON v.id = a.created_by
INNER JOIN 
	contracts AS c ON p.id = c.client_id

WHERE 
ai.incident_type_id IN  (1604,1605)
AND a.created BETWEEN '2022-11-01' AND '2022-11-30'
AND ai.incident_status_id <> 8
AND v.profile_id NOT IN (38,23)