SELECT DISTINCT ON (fat.title)
p.id AS cod_pessoa,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo,
p.tx_id AS documento,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.city AS cidade,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = fat.company_place_id) AS empresa,
fat.title AS fatura,
date(fat.created) as data_criacao_fatura,
fat.title_amount AS valor,
CASE WHEN fat.balance = 0 THEN 'Pago' ELSE 'Em Aberto' END AS status_pg,
fatr.fine_amount AS multa,
fatr.increase_amount AS juros,
fatr.bank_tax_amount AS desconto_banco,
fatr.total_amount AS total_recebido,
fat.expiration_date AS vencimento,
DATE_FORMAT(fat.expiration_date, '%m-%Y') AS data_mes,
(SELECT nf.title FROM financers_natures AS nf WHERE fat.financer_nature_id = nf.id) AS natureza_financeira,
(SELECT s.title FROM service_products AS s WHERE s.id = con.service_product_id) AS plano,
(SELECT s.selling_price FROM service_products AS s WHERE s.id = con.service_product_id) AS valor_plano,
CASE WHEN fev.financial_title_occurrence_type_id = 67 THEN 'Sim' ELSE 'Não' END AS faturamento_complementar,
c.beginning_date AS data_instalacao

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
fat.type = 2
AND fat.deleted = FALSE
AND fat.origin NOT IN  (7, 2, 3, 5)
AND c.contract_type_id NOT IN (4, 6, 7, 8, 9)
AND fat.company_place_id != 3
AND fat.financer_nature_id != 158
AND fat.financial_collection_type_id IS NOT NULL
AND fat.expiration_date BETWEEN '2022-09-01' AND '2022-09-30'