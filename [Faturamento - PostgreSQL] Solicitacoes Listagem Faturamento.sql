SELECT
ai.protocol,
a.title,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS requestor,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS responsible,
date(a.conclusion_date),
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS tipo,
a.final_date AS prazo,
a.conclusion_date AS encerramento,
CASE WHEN a.conclusion_date < a.final_date THEN 'No Prazo' WHEN a.conclusion_date > a.final_date THEN 'Fora do Prazo' END AS SLA

FROM assignments AS a 
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE a.assignment_type = 'INCI' AND date(a.conclusion_date) BETWEEN '2022-05-01' AND '2022-05-31'
AND ai.team_id = 1004
