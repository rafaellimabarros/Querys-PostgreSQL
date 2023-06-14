SELECT DISTINCT ON (fat.title)
c.id AS cod_contrato,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo,
p.city AS cidade,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = fat.company_place_id) AS empresa,
fat.title_amount AS valor_original,
CASE WHEN fat.balance = 0 THEN 'Pago' ELSE 'Em Aberto' END AS status_pg,
((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido,
fat.expiration_date AS data_vencimento,
fat.entry_date AS data_emissao,
fatr.receipt_date AS data_recebimento

FROM
financial_receivable_titles AS fat
INNER JOIN 
people AS p ON fat.client_id = p.id
LEFT JOIN
contracts AS c ON fat.contract_id = c.id
LEFT JOIN
contract_items AS con ON c.id = con.contract_id
LEFT JOIN 
financial_receivable_title_occurrences AS fev ON fat.id = fev.financial_receivable_title_id AND (fev.financial_title_occurrence_type_id = 67 OR fev.financial_title_occurrence_type_id IS NULL)
LEFT JOIN 
financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id

WHERE
fat.company_place_id != 3
AND fat.origin NOT IN  (7, 2, 3, 5)
AND fat.financial_collection_type_id IS NOT NULL
AND fat.expiration_date BETWEEN '2022-09-01' AND '2022-09-30'
/*AND fat.expiration_date between cast(date_trunc('month', current_date-INTERVAL '6 month') as date) AND DATE(curdate())
*/
GROUP BY fat.title, 1,2,3,4,5,6,7,8,9,10