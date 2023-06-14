SELECT DISTINCT ON (fr.id)
fr.id AS cod_renegociacao,
p.id AS cod_cliente,
c.id AS id_contrato,
p.name AS nome_cliente,
(SELECT cp.description FROM companies_places AS cp  WHERE cp.id = frt.company_place_id) AS local_fatura,
c.beginning_date AS ativacao,
frt.competence AS mes_cobranca,
frt.title AS fatura,
fr.total_amount_renegotiated AS valor_original,
fr.renegotiation_diff valor_descontado,
(fr.total_amount_renegotiated + fr.renegotiation_diff) AS valor_final_renegociado,
(SELECT vu.name FROM v_users AS vu where vu.id = fr.created_by) as responsavel_negociacao,
date(fr.date) as data_negociacao,
CASE WHEN frr.receipt_date IS NULL then 'Não' WHEN frr.receipt_date IS NOT NULL THEN 'Sim' END AS pagamento_realizado,
frr.receipt_date AS data_pagamento

  
FROM financial_renegotiations AS fr
LEFT JOIN
financial_renegotiation_titles AS fre ON  fr.id = fre.financial_renegotiation_id
LEFT JOIN
financial_receivable_titles AS frt ON frt.id = fre.financial_receivable_title_id
LEFT JOIN
financial_receipt_titles  AS frr ON frt.id = frr.financial_receivable_title_id
LEFT JOIN
people AS P ON p.id = fr.client_id
LEFT  JOIN
contracts AS c ON p.id = c.client_id

WHERE 
   date(fr.date) BETWEEN '2022-01-01' AND '2023-01-10'
   AND frt.deleted = false
   AND fr.type <> 1
   AND frt.company_place_id != 3
   AND fr.deleted = false
   AND fr.created_by IN (181,388)