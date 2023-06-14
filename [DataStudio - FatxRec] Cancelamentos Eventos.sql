SELECT DISTINCT
c.id AS cod_contrato,
c.amount AS valor_mensalidade,
c.v_status AS status_contrato,
CASE WHEN ce.created = '0001-01-01 00:00:00' THEN date(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN date(ce.created) END AS data_cancelamento,
CASE WHEN cet.id IN (184,214) THEN 'Involuntario' ELSE 'Voluntário' END AS tipo_cancelamento,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
ce.contract_event_type_id,
(SELECT cet.title FROM contract_event_types AS cet where cet.id = ce.contract_event_type_id) AS motivo_cancelamento
, p.neighborhood AS bairro

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id

WHERE date(ce.created) BETWEEN cast(date_trunc('month', current_date-INTERVAL '11 month') as date) AND DATE(curdate()) AND ce.contract_event_type_id IN (110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,190,192,195,196,197,198,199,200,201,202,203,225,226)
OR DATE(ce.date) BETWEEN cast(date_trunc('month', current_date-INTERVAL '11 month') as date) AND DATE(curdate()) AND ce.contract_event_type_id = 214