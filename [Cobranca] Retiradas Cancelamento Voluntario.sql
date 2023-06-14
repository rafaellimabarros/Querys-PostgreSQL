SELECT DISTINCT ON (asi.protocol)
c.id AS cod_contrato,
p.id AS cod_cliente,
p.name AS cliente,
CASE WHEN min(ce.created) = '0001-01-01 00:00:00' THEN date(ce.date) WHEN min(ce.created) != '0001-01-01 00:00:00' THEN date(ce.created) END AS data_cancelamento,
DATE (a.conclusion_date) AS data_encerramento,
DATE_PART ('day' , a.conclusion_date - date(ce.created)) AS dias_retirada,
CASE WHEN cet.id IN (184,214) THEN 'Involuntario' ELSE 'Voluntario' END AS tipo_cancelamento,
(asi.protocol) AS protocolo,
(SELECT it.title FROM incident_status AS it WHERE it.id = asi.incident_status_id) AS status_solicitacao,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
(SELECT cet.title FROM contract_event_types AS cet where cet.id = ce.contract_event_type_id) AS evento_cancelamento,
c.v_status AS status_contrato,
c.cancellation_motive AS motivo_cancelamento,
(CASE WHEN asi.incident_type_id IN (1015,1231,1271,1291,1385,1484) THEN anci.title END) AS tipo_retirada,
(SELECT p.name FROM people AS p WHERE p.id = (SELECT max(r.person_id) FROM reports AS r WHERE r.assignment_id = a.id and r.progress >= 100)) AS usuario_relato_encerramento
FROM assignments AS a
INNER JOIN assignment_incidents AS asi ON asi.assignment_id = a.id
INNER JOIN contract_service_tags AS ctag ON ctag.id = asi.contract_service_tag_id
INNER JOIN contracts AS c ON c.id = ctag.contract_id
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN contract_events AS ce ON ce.contract_id = c.id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
INNER JOIN incident_types AS anci ON anci.id = asi.incident_type_id
LEFT JOIN reports AS r ON r.assignment_id = a.id

WHERE
DATE(ce.created) BETWEEN '2022-12-01' AND '2022-12-31'
AND DATE(a.created) BETWEEN '2022-12-01' AND '2022-12-31'
AND a.conclusion_date IS NOT NULL
AND asi.incident_status_id IN  (4,8)
AND ce.contract_event_type_id IN (110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,190,192,195,196,197,198,199,200,201,202,203,225,226)
AND asi.incident_type_id IN (1015,1291)

GROUP BY asi.protocol, ce.date, ce.created, 1,2,3,5,6,7,8,9,10,11,12,13,14,15