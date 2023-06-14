SELECT DISTINCT ON (ini.id)
DATE(inv.created) AS data_emissao,
inv.document_number AS numero_nota,
inv.company_place_name AS local_origem,
inv.client_name AS local_destino,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = inv.financial_operation_id) AS operacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = inv.created_by) AS usuario_responsavel,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS tipo_equipamento,
pat.serial_number AS numero_serial,
pat.tag_number AS patrimonio,
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS medida,
ini.units AS quantidade,
ini.unit_amount AS valor_unidade,
ini.total_amount AS valor_total,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = inv.invoice_serie_id) AS serie

FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = inv.id
LEFT JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
LEFT JOIN patrimony_occurrences AS ppl ON pat.id = ppl.patrimony_id

WHERE DATE(inv.created) BETWEEN '2021-02-01' AND '2022-10-31'
AND inv.cancellation_date IS NULL
AND inv.invoice_serie_id IN (103,107,116,120,124,125,163,164)
AND inv.out_date IS NOT NULL
AND inv.company_place_id IN (7,2)
AND inv.invoice_serie_id IN (103,107,116,120,124,125,163,164)
AND ini.first_units_measure_id <>1
AND inv.financial_operation_id IN(47,49)