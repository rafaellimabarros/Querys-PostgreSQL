SELECT DISTINCT ON (ai.protocol)
inv.created_by AS cod_responsavel,
(SELECT v.name FROM v_users AS v WHERE v.id = inv.created_by) AS tecnico,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS patrimonio,
sp.code AS cod_produto,
pat.serial_number AS numero_serial,
pat.tag_number AS etiqueta,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_OS,
CASE WHEN pack.returned = 1 THEN 'Sim' WHEN pack.returned = 0 THEN 'Nao' END  AS retorno,
inv.created AS data_movimentacao,
CASE WHEN inv.signal = 2 THEN 'saida' WHEN inv.signal = 1 THEN 'Entrada' END AS tipo,
inv.client_name AS cliente

FROM invoice_notes AS inv
INNER JOIN invoice_note_items as ini ON inv.id = ini.invoice_note_id
INNER JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
INNER JOIN v_users AS vu ON vu.id = inv.created_by
INNER JOIN patrimony_packing_list_items AS pack ON pack.out_invoice_note_id = inv.id
INNER JOIN patrimony_packing_lists AS pp ON pp.id = pack.patrimony_packing_list_id
INNER JOIN assignments AS a ON a.id = pp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN service_products AS sp ON sp.id = pat.service_product_id

WHERE inv.financial_operation_id = 8
AND date(inv.created) BETWEEN '2023-02-20' AND '2023-02-20'
AND pat.active = TRUE
AND pat.return_pending = FALSE
AND pat.deleted = FALSE 
AND vu.team_id IN (1,1003,1011)