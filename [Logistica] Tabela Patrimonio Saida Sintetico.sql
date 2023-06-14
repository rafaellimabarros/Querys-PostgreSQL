SELECT
inv.created_by AS cod_responsavel,
(SELECT v.name FROM v_users AS v WHERE v.id = inv.created_by) AS responsavel,
CASE WHEN vu.active = FALSE THEN 'Inativo' ELSE 'Ativo' END AS status_usuario,
sp.code AS cod_patrimonio,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS patrimonio,
COUNT (DISTINCT ai.protocol) AS  quant_solicitacoes,
COUNT (DISTINCT  pack.out_invoice_note_id) AS patrimonio_usados,
TRUNC(CAST (COUNT ( DISTINCT  pack.out_invoice_note_id)AS DECIMAL) / CAST (COUNT (DISTINCT ai.protocol) AS DECIMAL),3) AS media_uso_protocolo

FROM invoice_notes AS inv
INNER JOIN invoice_note_items as ini ON inv.id = ini.invoice_note_id
INNER JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
INNER JOIN v_users AS vu ON vu.id = inv.created_by
INNER JOIN patrimony_packing_list_items AS pack ON pack.out_invoice_note_id = inv.id
INNER JOIN patrimony_packing_lists AS pp ON pp.id = pack.patrimony_packing_list_id
INNER JOIN assignments AS a ON a.id = pp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN service_products AS sp ON sp.id = pat.service_product_id

WHERE inv.financial_operation_id IN (8)
AND date(inv.created) BETWEEN '2023-02-20' AND '2023-02-20'
AND pat.active = TRUE
AND pat.return_pending = FALSE
AND pat.deleted = FALSE 
AND vu.team_id IN (1,1003,1011)

GROUP BY 1,2,3,4,5