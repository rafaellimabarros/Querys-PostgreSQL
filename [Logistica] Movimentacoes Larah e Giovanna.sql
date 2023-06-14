SELECT DISTINCT ON (inv.id)
inv.created AS data_emissao,
inv.document_number AS numero_nota,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = inv.created_by) AS responsavel,
inv.client_name AS cliente,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS patrimonio,
pat.serial_number AS numero_serial,
pat.tag_number AS patrimonio,
ini.units AS quantidade,
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS medida,
inv.company_place_name AS empresa,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = inv.invoice_serie_id) AS serie,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = inv.financial_operation_id) AS operacao

FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = inv.id
LEFT JOIN patrimonies AS pat ON pat.id = ini.patrimony_id

WHERE DATE(inv.created) BETWEEN '2023-03-23' AND '2023-03-23'
AND inv.cancellation_date IS NULL
AND inv.invoice_serie_id IN (103,107,116,120,124,125,163,164)
AND inv.out_date IS NOT NULL
--AND inv.created_by IN (308,390)

/*MARIA GIOVANNA  ALVES SANTOS - 308
LARAH CRISTINA BARBOSA BRAZ - 390*/