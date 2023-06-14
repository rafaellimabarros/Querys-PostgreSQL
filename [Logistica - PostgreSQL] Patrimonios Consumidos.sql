SELECT DISTINCT ON (pat.serial_number,inv.id)
date(inv.created) AS data_alocacao,
CONCAT(DATE_PART('hour',inv.created),':',DATE_PART('minute',inv.created),':',trunc(DATE_PART('seconds',inv.created))) AS horario,
inv.document_number AS numero_nota,
vu.name AS responsavel,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS patrimonio,
pat.serial_number AS numero_serial,
pat.tag_number AS tag,
ini.units AS quantidade,
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS medida,
inv.company_place_name AS empresa,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = inv.invoice_serie_id) AS serie,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = inv.financial_operation_id) AS operacao,
inv.client_name AS cliente,
ai.protocol AS protocolo,
(SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id) AS tipo_os,
CASE WHEN pack.returned = 1 THEN 'Sim' ELSE 'Nao' END AS teve_retorno

FROM invoice_notes AS inv
INNER JOIN invoice_note_items as ini ON inv.id = ini.invoice_note_id
LEFT JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
INNER JOIN v_users AS vu ON vu.id = inv.created_by
INNER JOIN patrimony_packing_list_items AS pack ON pack.out_invoice_note_id = inv.id
INNER JOIN patrimony_packing_lists AS pp ON pp.id = pack.patrimony_packing_list_id
INNER JOIN assignments AS a ON a.id = pp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE inv.financial_operation_id = 8 AND date(inv.created) BETWEEN '2021-01-01' AND '2023-02-17'
AND vu.name LIKE '%JESSE DA COSTA VALE%'