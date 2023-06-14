SELECT DISTINCT ON (c.id)
c.id AS cod_contrato,
p.name AS nome,
p.city AS cidade,
p.neighborhood AS bairro,
p.cell_phone_1 AS celular,
p.phone AS telefone,
p.email AS email,
c.amount AS valor_mensalidade,
(SELECT s.title FROM service_products AS s WHERE con.service_product_id = s.id) AS plano, 
c.v_status AS status_contrato,
CASE WHEN ce.created = '0001-01-01 00:00:00' THEN date(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN date(ce.created) END AS data_cancelamento,
CASE WHEN cet.id IN (184,214) THEN 'Involuntario' ELSE 'Voluntário' END AS tipo_cancelamento,
(SELECT cet.title FROM contract_event_types AS cet where cet.id = ce.contract_event_type_id) AS evento_cancelamento,
c.cancellation_motive AS motivo_cancelamento

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
INNER JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN financial_receivable_titles AS fat ON p.id = fat.client_id

WHERE date(ce.created) BETWEEN '2021-01-01' AND '2021-09-30'
AND ce.contract_event_type_id IN (24,110,144,173,174,175,176,177,178,179,180,181,182,183,190,192,195,196,197,198,199,200,201,202,203,225)
AND c.v_status IN ('Cancelado','Encerrado')
AND fat.company_place_id != 3
AND fat.financial_collection_type_id IS NOT NULL
AND c.client_id NOT IN (SELECT fat.client_id FROM financial_receivable_titles as fat WHERE fat.p_is_receivable = TRUE)
