SELECT DISTINCT ON (ca.contract_id)
p.id AS cod_cliente,
ca.contract_id AS id_contrato,
c.description,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.name AS cliente,
ctag.service_tag AS etiqueta,
c.beginning_date AS data_inicial_fidelidade,
FIRST_VALUE(pu.begin) OVER (PARTITION BY c.client_id) AS arquivo_fidelidade_mais_recente,
ca.activation_date AS data_ativacao,
c.observation AS observacao_fidelidade,
CASE WHEN c.seller_1_id IS NULL THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id =  c.created_by) ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) END AS vendedor_1,
c.v_status AS status_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato,
ost.protocol AS protocolo,
(SELECT tos.title FROM incident_types AS tos WHERE tos.id = ost.incident_type_id) AS tipo_os

FROM contract_assignment_activations AS ca
INNER JOIN contracts AS c ON ca.contract_id = c.id
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN assignment_incidents AS ost ON ca.assignment_id = ost.assignment_id
LEFT JOIN people_uploads AS pu ON pu.people_id = c.client_id
LEFT JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id

WHERE ca.activation_date BETWEEN '2021-12-01' AND '2022-12-31'
AND c.seller_1_id IN (73728, 44657, 96903, 93908)