SELECT
DATE(inv.created) AS data_emissao,
CONCAT(DATE_PART('hour',inv.created),':',DATE_PART('minute',inv.created),':',trunc(DATE_PART('seconds',inv.created))) AS horario,
inv.document_number AS numero_nota,
(SELECT t.title FROM teams AS t WHERE t.id = vu.team_id) AS equipe_usuario_movimentador,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = inv.created_by) AS usuario_movimentador,
inv.client_name AS usuario_destino,
SPLIT_PART(SPLIT_PART(inv.observation_invoice_1,',', 1), 'Equipamentos em poder de ',2) AS usuario_destino_split,
inv.observation_invoice_1 AS observacao_nota,
(SELECT sp.code FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS cod_patrimonio,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS patrimonio,
pat.id,
pat.serial_number AS numero_serial,
pat.tag_number AS etiqueta,
ini.units AS quantidade,
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS medida,
CASE when inv.signal = 1 THEN 'ENTRADA' when inv.signal = 2 THEN 'SAIDA' END AS SINAL,  
inv.company_place_name AS local_origem_patrimonio,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = inv.invoice_serie_id) AS serie,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = inv.financial_operation_id) AS operacao,
inv.origin

FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = inv.id
LEFT JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
INNER JOIN financial_operations AS fo ON fo.id = inv.financial_operation_id
INNER JOIN v_users AS vu ON vu.id = inv.created_by

WHERE DATE(inv.created) BETWEEN '2023-02-01' AND '2023-02-28'
AND inv.cancellation_date IS NULL
AND inv.invoice_serie_id IN (103,107,116,112,120,124,125,163,164)
AND inv.financial_operation_id = 10
AND SPLIT_PART(SPLIT_PART(inv.observation_invoice_1,',', 1), 'Equipamentos em poder de ',2) = 'IAN FONSECA ARAUJO'
--AND pat.serial_number IS NOT NULL