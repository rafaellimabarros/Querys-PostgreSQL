SELECT DISTINCT ON (c.id)
c.id AS cod_contrato,
p.id AS cod_cliente,
p.name AS cliente,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS logradouro,
p.address_complement AS complemento,
p.cell_phone_1 AS celular,
p.phone AS telefone,
c.amount AS valor_mensalidade,
CASE WHEN ce.created = '0001-01-01 00:00:00' THEN date(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN date(ce.created) END AS data_cancelamento,
CASE WHEN cet.id IN (184,214) THEN 'Involuntario' ELSE 'Voluntario' END AS tipo_cancelamento,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
(SELECT cet.title FROM contract_event_types AS cet where cet.id = ce.contract_event_type_id) AS evento_cancelamento,
c.v_status AS status_contrato,
c.cancellation_motive AS motivo_cancelamento

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id

WHERE date(ce.created) BETWEEN '2022-12-01' AND '2022-12-31' AND ce.contract_event_type_id IN (110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,190,192,195,196,197,198,199,200,201,202,203,225,226)
