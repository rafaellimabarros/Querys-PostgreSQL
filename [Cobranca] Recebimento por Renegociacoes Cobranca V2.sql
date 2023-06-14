SELECT DISTINCT ON (fatr.id)
p.id AS cod_cliente,
p.city AS cidade,
(SELECT comp.description FROM companies_places AS comp WHERE fatr.company_place_id = comp.id) AS local_recebimento,
(SELECT pm.title FROM payment_forms AS pm WHERE pm.id = fatr.payment_form_id) AS forma_pagamento, 
(SELECT ba.description FROM bank_accounts AS ba WHERE ba.id = fatr.bank_account_id) AS conta,
( SELECT v.name FROM v_users AS v WHERE v.id = neg.created_by) AS negociado_por,
fatr.complement AS complemento_fatura,
(SELECT fat1.complement FROM financial_receivable_titles AS fat1 WHERE fat1.bill_title_id = fat.id AND fat1.origin = 11) AS complemento_renegociacao,
CASE 
WHEN (SELECT fat1.complement FROM financial_receivable_titles AS fat1 WHERE fat1.bill_title_id = fat.id AND fat1.origin = 11) LIKE '%NEG.%' THEN CONCAT('NEG.',SPLIT_PART((SELECT fat1.complement FROM financial_receivable_titles AS fat1 WHERE fat1.bill_title_id = fat.id AND fat1.origin = 11),'NEG.', 2))
WHEN (SELECT fat1.complement FROM financial_receivable_titles AS fat1 WHERE fat1.bill_title_id = fat.id AND fat1.origin = 11) LIKE '%NEGOCIAÇÃO%' THEN CONCAT('NEGOCIAÇÃO',SPLIT_PART((SELECT fat1.complement FROM financial_receivable_titles AS fat1 WHERE fat1.bill_title_id = fat.id AND fat1.origin = 11),'NEGOCIAÇÃO', 2))
ELSE NULL
END AS complemento_renegociacao_reduzido,

fat.expiration_date AS data_vencimento,
fatr.receipt_date AS data_recebimento,
fn.total_titles_renegotiated AS titulos_renegociado,
fn.total_titles_generated AS titulos_gerados,
fn.total_amount_renegotiated AS valor_original,
fn.renegotiation_diff AS valor_desconto,
fatr.amount AS valor_final,
fatr.fine_amount AS juros,
fatr.increase_amount AS multa,
SUM((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido

FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
INNER JOIN people AS p ON fatr.client_id = p.id
INNER JOIN financial_renegotiation_titles AS neg ON neg.financial_receivable_title_id = fat.id
INNER JOIN financial_renegotiations AS fn ON neg.financial_renegotiation_id = fn.id
LEFT JOIN contracts AS c ON fat.contract_id = c.id

WHERE DATE (fatr.receipt_date) BETWEEN '2023-03-01'AND '2023-03-27'
AND fat.title LIKE '%FAT%'
AND fn.created_by IN (288,388,181,179)

OR 

DATE (fatr.receipt_date) BETWEEN '2023-03-01'AND '2023-03-27'
AND fat.origin IN (3,4,7,11) 
AND fatr.receipt_origin_id IS NULL
AND neg.created_by IN (288,388,181,179)

GROUP BY cod_cliente,fatr.id,cidade,local_recebimento,forma_pagamento,negociado_por,data_vencimento,neg.created_by, titulos_gerados,titulos_renegociado,valor_original,complemento_fatura,valor_desconto,juros,conta,data_recebimento,fatr.increase_amount
,complemento_renegociacao,complemento_renegociacao_reduzido