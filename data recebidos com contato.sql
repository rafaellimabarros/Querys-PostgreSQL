SELECT DISTINCT ON (fatr.id)
p.city AS cidade,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = fat.company_place_id) AS empresa,
fatr.receipt_date AS data_recebimento,
fat.expiration_date AS data_vencimento,
((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido,
date(fev.date) AS ult_contato,
(SELECT p1.name FROM people AS p1 WHERE fev.person_id = p1.id) AS nome_op

FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
INNER JOIN people AS p ON fatr.client_id = p.id
LEFT JOIN contracts AS c ON fat.contract_id = c.id
LEFT JOIN 
financial_receivable_title_occurrences AS fev ON (fat.id = fev.financial_receivable_title_id) AND fev.date > '2022-09-01' AND fev.financial_title_occurrence_type_id IN (1, 2, 3, 5)

WHERE fatr.receipt_date BETWEEN '2022-09-01' AND '2022-09-30'
/*cast(date_trunc('month', current_date-INTERVAL '6 month') as date) AND DATE(curdate())
*/
AND fat.company_place_id != 3
and fatr.finished = false
AND fat.title LIKE '%FAT%'
AND fatr.receipt_date > fev.date

OR fatr.receipt_date BETWEEN '2022-09-01' AND '2022-09-30'
/*cast(date_trunc('month', current_date-INTERVAL '6 month') as date) AND DATE(curdate())
*/
AND fat.company_place_id != 3
and fatr.finished = false
AND fat.origin IN (3,4,7,11) AND fatr.receipt_origin_id IS NULL
AND fatr.receipt_date > fev.date

GROUP BY fatr.id, 1,2,3,4,5,6,7