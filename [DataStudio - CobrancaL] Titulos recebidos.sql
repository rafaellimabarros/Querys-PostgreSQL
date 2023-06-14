SELECT 
p.id AS cod_pessoa,
p.name AS cliente,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo,
p.city AS cidade,
p.neighborhood AS bairro,
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
c.beginning_date AS data_instalacao

FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
INNER JOIN people AS p ON fatr.client_id = p.id
LEFT JOIN contracts AS c ON fat.contract_id = c.id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id

WHERE
fat.type = 2
AND fat.deleted = FALSE
AND fat.origin NOT IN  (7, 2, 3, 5)
AND c.contract_type_id NOT IN (4, 6, 7, 8, 9)
AND fat.company_place_id != 3
AND fat.financer_nature_id != 158
AND fat.financial_collection_type_id IS NOT NULL
AND fat.renegotiated = FALSE
AND fatr.receipt_date BETWEEN '2022-08-01' AND '2022-08-31'