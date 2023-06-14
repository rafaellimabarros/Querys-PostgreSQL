SELECT DISTINCT ON (notas.id)
date(notas.out_date) AS emissao,
p.id AS cod_pessoa,
notas.client_name AS cliente,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.city AS cidade,
p.neighborhood AS bairro,
fat.expiration_date AS vencimento,
notas.sale_request_id AS pedido_venda,
date(srp.expiration) AS venc_pedido,
notas.billing_competence AS competencia,
notas.document_number AS nota_fiscal,
CASE WHEN notas."status" IN (3,9) THEN 'Sim' ELSE 'Nao' END AS nota_cancelada,
notas.total_amount_gross AS valor_bruto,
notas.total_amount_liquid AS valor_liquido,
notas.discounts AS descontos,
notas.additions AS acrescimos,
CASE WHEN notas.retention_tax = TRUE THEN 'Sim' ELSE 'Nao' END AS retido,
notas.issqn_amount AS issqn,
notas.pis_amount as pis,
notas.cofins_amount AS cofins,
notas.csll_amount AS csll,
notas.irrf_amount AS irrf,
notas.inss_amount AS inss,
notas.company_place_name AS local_nota, 
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = notas.financial_operation_id) AS operacao,
(SELECT nf.title FROM financers_natures AS nf WHERE notas.financer_nature_id = nf.id) AS natureza_financeira,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = notas.invoice_serie_id) AS serie,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = notas.financial_collection_type_id) AS tipo_cobranca,
c.amount AS valor_contrato

FROM invoice_notes AS notas
INNER JOIN people AS p ON p.id = notas.client_id
LEFT JOIN contracts AS c ON c.client_id = p.id
LEFT JOIN financial_receivable_titles AS fat ON fat.invoice_note_id = notas.id
LEFT JOIN sale_request_parcels AS srp ON srp.sale_request_id = notas.sale_request_id

WHERE date(notas.out_date) BETWEEN '2023-05-01' AND '2023-05-31'
AND notas.financial_operation_id IN (1,15,25,26,34,46,63,65)
AND notas."status" NOT IN (4,5)
AND notas.id NOT IN (975130 /*, 967966*/)

/*OR 
date(notas.created) BETWEEN '2022-07-01' AND '2022-07-31'
and notas.entry_date BETWEEN '2022-08-01' AND '2022-08-31'
AND notas.financial_operation_id IN (1,15,25,26,34,46,63,65)
AND notas."status" NOT IN (4,5)
AND notas.id NOT IN (975130)*/

GROUP BY notas.id, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29