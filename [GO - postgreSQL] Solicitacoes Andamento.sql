SELECT DISTINCT ON (ai.protocol)
p.id AS cod_pessoa,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS rua,
p.number AS numero_casa,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT ins.title FROM incident_status AS ins WHERE ai.incident_status_id = ins.id) AS status_Solicitacao,
a.created AS data_Abertura,
a.final_date AS data_Prazo,
CASE WHEN curdate() > a.final_date THEN 'Sim' ELSE 'Nao' END AS em_Atraso,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS responsavel

FROM assignments AS a
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN people AS p ON p.id = ai.client_id
LEFT JOIN contracts AS c ON c.client_id = p.id

WHERE a.assignment_type = 'INCI' AND ai.incident_status_id IN (1,2,9,10,11) AND ai.sector_area_id IN (6,7)
