SELECT DISTINCT
c.id AS num_contrato,
p.name AS cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
(SELECT cet.title FROM contract_event_types AS cet WHERE ce.contract_event_type_id = cet.id) AS evento,
CASE WHEN ce.created = '0001-01-01 00:00:00' THEN ce.date WHEN ce.created != '0001-01-01 00:00:00' THEN ce.created END AS data_evento

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id

WHERE date(ce.created) BETWEEN '2022-04-01' AND '2022-04-30' AND ce.contract_event_type_id IN (110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,217,225,226)
OR DATE(ce.date) BETWEEN '2022-04-01' AND '2022-04-30' AND ce.contract_event_type_id = 214