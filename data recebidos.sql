SELECT DISTINCT ON (fatr.id)
p.id AS cod_pessoa,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo,
p.city AS cidade,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = fat.company_place_id) AS empresa,
fat.expiration_date AS vencimento,
fatr.receipt_date AS data_recebimento,
((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido

FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
INNER JOIN people AS p ON fatr.client_id = p.id
LEFT JOIN contracts AS c ON fat.contract_id = c.id

WHERE fatr.receipt_date BETWEEN '2022-09-01' AND '2022-09-30'
/*cast(date_trunc('month', current_date-INTERVAL '6 month') as date) AND DATE(curdate())
*/
AND fat.company_place_id != 3
and fatr.finished = false
AND fat.title LIKE '%FAT%'

OR fatr.receipt_date BETWEEN '2022-09-01' AND '2022-09-30'
/*cast(date_trunc('month', current_date-INTERVAL '6 month') as date) AND DATE(curdate())
*/
AND fat.company_place_id != 3
and fatr.finished = false
AND fat.origin IN (3,4,7,11) AND fatr.receipt_origin_id IS NULL

GROUP BY fatr.id, 1,2,3,4,5,6,7
