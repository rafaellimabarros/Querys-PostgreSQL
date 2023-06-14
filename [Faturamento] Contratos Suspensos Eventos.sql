SELECT DISTINCT
c.id AS num_contrato,
p.name AS cliente,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo_cliente,
p.city AS cidade,
p.neighborhood AS bairro,
c.v_status,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
(SELECT cet.title FROM contract_event_types AS cet WHERE ce.contract_event_type_id = cet.id) AS motivo_bloqueio,
CASE WHEN ce.created = '0001-01-01 00:00:00' THEN ce.date WHEN ce.created != '0001-01-01 00:00:00' THEN ce.created END AS data_bloqueio

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id

WHERE date(ce.created) BETWEEN cast(date_trunc('month', current_date-INTERVAL '100 month') as date) AND DATE(curdate())
AND ce.contract_event_type_id IN (152, 153,	206,	207,	208,	209,	210,	211,	212,	215,	216,	217,	218,	219,	220,	221,	222,	223,	224,	231)