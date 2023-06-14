SELECT DISTINCT ON (ai.protocol)
p.id AS cod_pessoa,
ai.protocol AS protocolo,
a.created AS data_abertura,
a.conclusion_date AS data_encerramento,
(SELECT ist.title FROM incident_status AS ist WHERE ist.id = ai.incident_status_id) AS status_solicitacao,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
a.description AS descricao,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) aberto_por,
(SELECT v.name FROM v_users AS v WHERE v.id = a.modified_by) encerrado_por,
(SELECT t.title FROM teams AS t WHERE t.id = ai.origin_team_id) AS equipe_abertura,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id)AS equipe_encerramento,
ai.team_id AS equipe

FROM assignments AS a
INNER JOIN
	assignment_incidents AS ai ON a.id = ai.assignment_id
INNER JOIN
	people AS p ON p.id = ai.client_id
INNER JOIN
	reports AS r ON a.id = r.assignment_id
	
WHERE DATE(a.created) BETWEEN '2022-10-01' AND '2022-10-23'
AND ai.incident_type_id IN (53,1083,41,42,58,52,1054,1226,1227,1237,1110,1280,1286,1297,1298,1299,1300,1301,1303,1304,1305,1308,1302,1328,1442,1017,1285,1327)
AND ai.incident_status_id <> 8

GROUP BY(1,2,3,4,5,6,7,8,9)