SELECT 
p.name AS nome_cliente,
(SELECT distinct ON (c.client_id) c.id FROM contracts AS c WHERE c.client_id = p.id) AS cod_contrato,
(SELECT distinct ON (c.client_id) c.v_status FROM contracts AS c WHERE c.client_id = p.id) AS status_contrato,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo_cliente,
DATE (fft.created) AS data_criacao,
fft.expiration_date AS data_vencimento,
fft.title_amount AS valor_titulo,
cp.description AS empresa,
fft.title AS fatura,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id =  fft.financer_nature_id) AS natureza_financeira,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = fft.financial_operation_id ) AS operacao_fatura,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = fft.financial_collection_type_id) AS tipo_cobranca_fatura,
fft.complement AS complemento

FROM financial_receivable_titles as fft
left JOIN people AS p ON p.id = fft.client_id
left JOIN companies_places AS cp ON cp.id = fft.company_place_id
left JOIN contracts AS c ON c.id = fft.contract_id

WHERE 
DATE(fft.expiration_date) BETWEEN '2021-01-01' AND '2023-03-27'
AND fft.contract_id IS null
and fft.p_is_receivable = TRUE