SELECT DISTINCT
c.id AS num_contrato,
p.name AS cliente,
(SELECT cet.title FROM contract_event_types AS cet WHERE ce.contract_event_type_id = cet.id) AS evento,
CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END AS data_aprovacao_case,
caa.activation_date AS data_ativacao,
DATEDIFF (date(ce.created), caa.activation_date) AS dias,
CASE WHEN DATEDIFF (DATE(ce.created), date(caa.activation_date )) >= 3 THEN 'Atrasado' WHEN DATEDIFF (DATE(ce.created), date(caa.activation_date )) < 3 THEN 'No prazo' END AS status_sla_case
/*IF( DATEDIFF (DATE(ce.created), date(caa.activation_date )) >= 3 , "Atrasado", "No prazo" ) AS status_SLA
*/
FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
left JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id

WHERE date(ce.created) BETWEEN '2022-07-01' AND '2022-07-31' AND ce.contract_event_type_id = 3

ORDER BY data_aprovacao_case asc