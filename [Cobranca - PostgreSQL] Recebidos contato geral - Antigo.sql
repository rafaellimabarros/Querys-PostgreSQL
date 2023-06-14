SELECT
p.id AS cod_pessoa,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo,
p.tx_id AS documento,
p.city AS cidade,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = fat.company_place_id) AS empresa,
fat.title AS fatura,
fat.expiration_date AS vencimento,
fatr.receipt_date AS data_recebimento,
DATE_FORMAT(fat.expiration_date, '%m-%Y') AS data_mes,
fatr.amount AS valor_original,
fatr.fine_amount AS multa,
fatr.increase_amount AS juros,
fatr.bank_tax_amount AS desconto_banco,
fatr.total_amount AS total_recebido,
date(fev.date) AS ult_contato,
fev.description descricao,
(SELECT p1.name FROM people AS p1 WHERE fev.person_id = p1.id) AS nome_op

FROM
financial_receivable_titles AS fat
INNER JOIN  
financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
LEFT JOIN 
financial_receivable_title_occurrences AS fev ON (fat.id = fev.financial_receivable_title_id) AND fev.date > '$recebimento01' AND fev.financial_title_occurrence_type_id IN (1, 2, 3, 5)
INNER JOIN 
people AS p ON fatr.client_id = p.id
LEFT JOIN
contracts AS c ON fat.contract_id = c.id

WHERE
fat.type = 2
AND fat.deleted = FALSE
AND fat.origin NOT IN  (2, 3, 5, 7)
AND c.contract_type_id NOT IN (4, 6, 7, 8, 9)
AND fat.company_place_id != 3
AND fat.financer_nature_id != 158
AND fat.financial_collection_type_id IS NOT NULL
AND fatr.receipt_date BETWEEN '$recebimento01' AND '$recebimento02'
AND fatr.receipt_date > fev.date

