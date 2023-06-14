SELECT
date(inv.created) AS data_emissao,
extract(month from inv.created) AS mes,
inv.document_number AS numero_nota,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = inv.created_by) AS responsavel,
inv.client_name AS destino,
(SELECT sp.code FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS cod_patrimonio,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS material,
ini.service_product_id,
pat.serial_number AS numero_serial,
pat.tag_number AS patrimonio,
ini.units AS quantidade,
CASE 
 when inv.signal = 1 THEN 'ENTRADA'
 when inv.signal = 2 THEN 'SAIDA' 
END AS SINAL,  
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS medida,
inv.company_place_name AS empresa,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = inv.invoice_serie_id) AS serie,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = inv.financial_operation_id) AS operacao,
inv.financial_operation_id

FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = inv.id
LEFT JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
INNER JOIN financial_operations AS fo ON fo.id = inv.financial_operation_id

WHERE DATE(inv.created) BETWEEN '2022-01-01' AND '2022-12-31'
AND inv.cancellation_date IS NULL
AND inv.invoice_serie_id IN (103,107,116,112,120,124,125,163,164)
AND inv.out_date IS NOT NULL
AND inv.signal = 2
AND ini.service_product_id IN (351, 957,1164)
AND inv.financial_operation_id IN (10,17,60)