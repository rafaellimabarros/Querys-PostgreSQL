SELECT DISTINCT ON (p.id)
p.tx_id AS username,
p.email AS email,
p.tx_id AS password,
p.name AS display_name,
p.name AS nickname,
SPLIT_PART(p.name, ' ', 1) AS first_name,
SPLIT_PART(p.name, (SPLIT_PART(p.name, ' ', 1)),2) AS last_name,
SPLIT_PART(p.name, ' ', 1) AS billing_first_name,
SPLIT_PART(p.name, (SPLIT_PART(p.name, ' ', 1)),2) AS billing_last_name,
p.street AS billing_address_1,
p.city AS billing_city,
p.state AS billing_state,
p.postal_code AS billing_postcode,
p.country AS billing_country,
p.email AS billing_email,
p.cell_phone_1 AS billing_phone,
CASE WHEN p.type_tx_id = 2 THEN p.tx_id ELSE NULL END AS billing_cpf,
CASE WHEN p.type_tx_id = 1 THEN p.tx_id ELSE NULL end AS billing_cnpj,
p.number AS billing_number,
p.neighborhood AS billing_neighborhood,
p.phone AS billing_cellphone,
CASE WHEN c.v_status IN ('Normal','Bloqueio Financeiro','Bloqueio Administrativo') THEN NULL ELSE 'yes' END AS baba_user_locked

FROM people AS p
INNER JOIN contracts AS c ON c.client_id = p.id

--WHERE p.id IN (51,182)

LIMIT 20