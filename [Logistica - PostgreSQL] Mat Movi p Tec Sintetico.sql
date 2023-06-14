SELECT DISTINCT ON (inv.client_name,ini.service_product_id,inv.created)
date(inv.created) AS data_movimentacao,
inv.client_name AS tecnico,
(SELECT sp.code FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS cod_patrimonio,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS patrimonio,
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS metrica,
sum(ini.units) AS quantidade

FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = inv.id
LEFT JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
INNER JOIN financial_operations AS fo ON fo.id = inv.financial_operation_id
INNER JOIN v_users AS vu ON vu.id = inv.created_by

WHERE DATE(inv.created) BETWEEN '2022-11-01' AND '2022-11-22'
AND inv.cancellation_date IS NULL
AND inv.invoice_serie_id IN (103,107,116,112,120,124,125,163,164)
AND inv.financial_operation_id = 10
AND fo.id IN (10,11)
/*AND inv.observation_invoice_1 LIKE '%FRANCISCO IAGO OLIVEIRA%'
AND vu.name NOT LIKE '%FRANCISCO IAGO OLIVEIRA%'*/

GROUP BY inv.client_name,ini.service_product_id,inv.created, 1,2,3,4, ini.first_units_measure_id