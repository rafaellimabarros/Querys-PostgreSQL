SELECT DISTINCT ON (fatr.id)
fatr.receipt_date AS data_recebimento,
(SELECT comp.description FROM companies_places AS comp WHERE fat.company_place_id = comp.id) AS local_fatura,
p.city AS cidade,
SUM((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido,
(SELECT nf.title FROM financers_natures AS nf WHERE fat.financer_nature_id = nf.id) AS natureza_financeira,
CASE WHEN fatr.finished = TRUE THEN 'SIM' WHEN fatr.finished = FALSE THEN 'NAO' END AS baixado,
(SELECT pf.title FROM payment_forms AS pf WHERE pf.id = fatr.payment_form_id) AS forma_pagamento

FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
INNER JOIN people AS p ON fatr.client_id = p.id
LEFT JOIN contracts AS c ON fat.contract_id = c.id

WHERE fatr.receipt_date BETWEEN cast(date_trunc('month', current_date-INTERVAL '5 month') as date) AND DATE(curdate())
AND fat.title LIKE '%FAT%'

OR fatr.receipt_date BETWEEN cast(date_trunc('month', current_date-INTERVAL '5 month') as date) AND DATE(curdate())
AND fat.origin IN (3,4,7,11) AND fatr.receipt_origin_id IS NULL

GROUP BY fatr.id,1,2,3,5,6,7