SELECT DISTINCT ON (ct.id)
p.id AS cod_cliente,
ct.id AS cod_contrato,
p.name AS nome,
ct.v_status AS status_contrato,
date(ce.date) AS data_suspensao,
CASE WHEN ce.contract_event_type_id IN (9,30,42) THEN DATEDIFF(CURDATE(), MIN(date(ce.date)) OVER (PARTITION BY ct.id)) ELSE DATEDIFF(CURDATE(), MAX(date(ce.date)) OVER (PARTITION BY ct.id)) END AS dias_bloqueado,
p.city AS cidade,
p.street AS logradouro,
p.neighborhood AS bairro,
p.number AS numero,
p.address_complement AS complemento,
p.cell_phone_1 AS telefone_1,
p.phone  AS telefone_2,
(SELECT cp.description FROM companies_places AS cp where cp.id = ct.company_place_id) AS empresa_contrato,
ct.collection_day AS vencimento_contrato,
(SELECT SUM (fat.title_amount) FROM financial_receivable_titles AS fat WHERE fat.contract_id = ct.id AND fat.p_is_receivable) AS valor_em_aberto

FROM contracts AS ct
INNER JOIN people AS p ON p.id = ct.client_id
INNER JOIN contract_events AS ce ON ce.contract_id = ct.id

WHERE 
ct.v_status = 'Suspenso'
and date(ce.date) BETWEEN '2023-02-01' AND '2023-02-28'
and ce.contract_event_type_id IN (43,152,153,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,231)
and ct.company_place_id != 3
