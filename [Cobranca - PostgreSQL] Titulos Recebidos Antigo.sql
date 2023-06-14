SELECT DISTINCT ON (fatr.id)
p.id AS cod_pessoa,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo,
p.tx_id AS documento,
p.city AS cidade,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = fat.company_place_id) AS empresa,
fat.title AS fatura,
CASE WHEN fatr.finished = TRUE THEN 'SIM' WHEN fatr.finished = FALSE THEN 'NAO' END AS baixado,
(SELECT nf.title FROM financers_natures AS nf WHERE fat.financer_nature_id = nf.id) AS natureza_financeira,
fat.expiration_date AS vencimento,
fatr.receipt_date AS data_recebimento,
DATE_FORMAT(fat.expiration_date, '%m-%Y') AS data_mes,
fatr.amount AS valor_original,
fatr.fine_amount AS multa,
fatr.increase_amount AS juros,
fatr.bank_tax_amount AS tarifa_bancaria,
fatr.discount_value AS desconto,
SUM((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido,
c.beginning_date AS data_instalacao

FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
INNER JOIN people AS p ON fatr.client_id = p.id
LEFT JOIN contracts AS c ON fat.contract_id = c.id

WHERE fatr.receipt_date BETWEEN '$recebimento01' AND '$recebimento02'
AND fat.company_place_id != 3
AND fat.title LIKE '%FAT%'

OR fatr.receipt_date BETWEEN '$recebimento01' AND '$recebimento02'
AND fat.company_place_id != 3
AND fat.origin IN (3,4,7,11) AND fatr.receipt_origin_id IS NULL

GROUP BY fatr.id, cod_pessoa, tipo, documento, cidade, empresa, fatura, vencimento, data_recebimento,
data_mes, valor_original, multa, juros, tarifa_bancaria, data_instalacao, baixado, desconto,natureza_financeira
