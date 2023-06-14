SELECT DISTINCT ON (f.id)
p.name AS fornecedor,
(SELECT tx.name FROM tx_types AS tx WHERE tx.id = p.type_tx_id) AS tipo_fornecedor,
f.created AS data_criacao,
f.expiration_date AS data_vencimento,
f.title_amount AS total,
(SELECT cp.description FROM companies_places  AS cp WHERE cp.id = f.company_place_id) AS empresa,
f.title AS titulo,
(SELECT cci.title FROM financial_cost_centers AS cci WHERE cci.id = cc.financial_cost_center_id) AS centro_custo,
CASE WHEN f.situation = 1 THEN 'em_aprovacao' WHEN f.situation = 2 THEN 'aprovado' END AS status,
(SELECT fn.title FROM financers_natures AS fn WHERE f.financer_nature_id = fn.id) AS natureza_financeira,
(SELECT fo.title FROM financial_operations AS fo WHERE f.financial_operation_id = fo.id) AS operacao_fatura

FROM financial_payable_titles AS f
INNER JOIN  people AS p ON f.supplier_id = p.id
LEFT JOIN financial_divide_cost_center_previsions AS cc ON  f.id = cc.financial_payable_title_id

WHERE f.expiration_date BETWEEN '2023-01-01' AND '2023-01-31'
AND f.deleted = FALSE
AND f.v_final_amount <> 0 
