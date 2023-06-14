SELECT DISTINCT ON (ini.id)
date(inv.created) AS data_emissao,
inv.document_number AS numero_nota,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = inv.created_by) AS responsavel,
inv.client_name AS empresa_destino,
aus.title AS site_destino,
ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS solicitante,
(SELECT sp.code FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS cod_patrimonio,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS material,
pat.serial_number AS numero_serial,
pat.tag_number AS patrimonio,
ini.units AS quantidade,
CASE 
 when inv.signal = 1 THEN 'ENTRADA'
 when inv.signal = 2 THEN 'SAIDA' 
END AS SINAL,  
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS medida,
inv.company_place_name AS empresa_origem,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = inv.financial_operation_id) AS operacao,
a.final_date AS prazo,
a.conclusion_date AS encerramento,
CASE 
WHEN a.conclusion_date < a.final_date THEN 'No Prazo' 
WHEN a.conclusion_date > a.final_date THEN 'Fora do Prazo' 
END AS SLA

FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = inv.id
LEFT JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
INNER JOIN financial_operations AS fo ON fo.id = inv.financial_operation_id
INNER JOIN person_product_movimentations AS ppm ON inv.id = ppm.invoice_note_id
INNER JOIN assignments AS a ON ppm.assignment_id = a.id
INNER JOIN assignment_incidents AS ai ON a.id = ai.assignment_id
INNER JOIN teams AS tm ON tm.id = ai.team_id
INNER JOIN authentication_sites AS aus ON aus.id = ai.authentication_site_id
INNER JOIN incident_types AS it ON it.id = ai.incident_type_id

WHERE DATE(inv.created) BETWEEN '2022-12-01' AND '2022-12-21'
AND inv.cancellation_date IS NULL
AND inv.invoice_serie_id IN (103,107,116,112,120,124,125,163,164)
AND inv.out_date IS NOT NULL
AND fo.id = 17
AND tm.id IN (4,1060,1061,1062)