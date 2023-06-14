SELECT
p.id AS cod_pessoa,
c.id AS cod_contrato,
p.name AS cliente,
caa.activation_date AS data_ativacao,
c.v_status AS status_contrato,
c.cancellation_date AS data_cancelamento,
ctag.service_tag AS etiqueta_contrato,
pat.title AS patrimonio,
pat.serial_number AS numero_serial,
ppl.date AS data_alocacao,
CASE WHEN ppli.returned = 0 THEN 'Nao' ELSE 'Sim' END AS equipamento_removido

FROM contracts AS c
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id
INNER JOIN patrimony_packing_lists AS ppl ON ppl.contract_service_tag_id = ctag.id
INNER JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
INNER JOIN patrimonies AS pat ON pat.id = ppli.patrimony_id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id

WHERE c.v_status = 'Cancelado'
AND ppli.returned = 0

ORDER BY caa.activation_date  asc
