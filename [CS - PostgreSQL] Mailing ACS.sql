SELECT DISTINCT ON (p.id)
c.id AS id_contrato,
os.protocol AS protocolo,
p.cell_phone_1 AS celular,
p.phone AS telefone,
(SELECT inct.title FROM incident_types AS inct WHERE os.incident_type_id = inct.id) AS tipo_os,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = prto.created_by) AS operador_abertura,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = prto.modified_by) AS operador_encerramento,
prto.created AS abertura,
prto.conclusion_date AS encerramento

FROM
assignment_incidents AS os
INNER JOIN 
assignments AS prto ON os.assignment_id = prto.id
INNER JOIN 
people AS p ON os.client_id = p.id
INNER JOIN
contracts AS c ON os.client_id = c.client_id
LEFT JOIN 
authentication_contracts AS conx ON conx.contract_id = c.id
WHERE
date(prto.conclusion_date) >= CURDATE() - INTERVAL '1 days'
AND os.incident_type_id IN (21,51,1005,1006,1008,1010,1011,1012,1013,1016,1017,1018,1019,1045,1046,1048,1051,1053,1061,1069,1070,1071,1073,1076,1079,1080,1081,1284,1285,1286,1297,1298,1301,1303,1304,1305,1308,1317,1318,1321,1326,1327,1328,1330,1331,1349,1350,1358,1362,1388) AND incident_status_id = 4
