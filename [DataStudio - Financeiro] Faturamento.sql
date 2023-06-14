SELECT DISTINCT ON (notas.id)
date(notas.out_date) AS emissao,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.city AS cidade,
p.neighborhood AS bairro,
notas.billing_competence AS competencia,
CASE WHEN notas.cancellation_date IS NULL THEN 'Não' ELSE 'Sim' END AS nota_cancelada,
notas.total_amount_gross AS valor_bruto,
notas.total_amount_liquid AS valor_liquido,
notas.discounts AS descontos,
notas.additions AS acrescimos,
notas.company_place_name AS local_nota, 
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = notas.financial_operation_id) AS operacao,
(SELECT nf.title FROM financers_natures AS nf WHERE notas.financer_nature_id = nf.id) AS natureza_financeira,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = notas.financial_collection_type_id) AS tipo_cobranca

FROM invoice_notes AS notas
INNER JOIN people AS p ON p.id = notas.client_id
LEFT JOIN contracts AS c ON c.client_id = p.id

WHERE date(notas.out_date) BETWEEN cast(date_trunc('month', current_date-INTERVAL '5 month') as date) AND DATE(curdate())
AND notas.financial_operation_id IN (1,15,25,26,34,46,63,65)
AND notas."status" NOT IN (4,5)
AND notas.id NOT IN (975130, 967966)

GROUP BY notas.id, 1,2,3,4,5,6,7,8,9,10,11,12,13,14