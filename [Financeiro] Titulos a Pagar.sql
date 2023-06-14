SELECT DISTINCT ON (cpa.id)
cpa.id,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = cpa.company_place_id) AS empresa,
(SELECT p.name FROM people AS p WHERE p.id = cpa.supplier_id) AS fornecedor,
cpa.title_amount AS valor_titulo,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id =  cpa.financer_nature_id) AS natureza_fianceira,
CASE WHEN cpa.origin = 2 THEN 'Documento de Entrada' WHEN cpa.origin != 2 THEN 'Financeiro' END AS origem,
CASE WHEN cpa.type = 2 THEN 'Definitivo' WHEN cpa.type != 2 THEN 'Outro' END AS tipo,
cpa.title AS numero_titulo,
cpa.parcel AS parcela,
cpa.issue_date AS data_emissao,
cpa.expiration_date AS vencimento,
cpa.complement AS complemwnto ,
(SELECT cci.title FROM financial_cost_centers AS cci WHERE cci.id = cc.financial_cost_center_id) AS centro_custo

FROM financial_payable_titles AS cpa
LEFT JOIN financial_divide_cost_center_previsions AS cc ON  cpa.id = cc.financial_payable_title_id

WHERE cpa.expiration_date BETWEEN '2023-01-01' AND '2023-12-31'
AND cpa.deleted = FALSE
AND cpa.company_place_id IN (1,4)