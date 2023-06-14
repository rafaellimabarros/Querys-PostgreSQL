SELECT 
/*CONCAT(DATE_PART('hour',inv.created),':',DATE_PART('minute',inv.created),':',trunc(DATE_PART('seconds',inv.created))) AS horario,*/
DISTINCT ON (vu.name, ini.service_product_id,date(inv.created))
date(inv.created) AS data_alocacao,     
vu.name AS tecnico,
(SELECT sp.code FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS cod_patrimonio,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS patrimonio,
COUNT(DISTINCT ai.protocol) AS qtd_solicitacoes,
COUNT(DISTINCT pat.serial_number) AS total_patrimonios_alocados,
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS metrica,
TRUNC(COUNT(DISTINCT pat.serial_number) / COUNT(DISTINCT ai.protocol),2) AS media_alocados

/*CASE WHEN ai.incident_type_id = 1006 THEN COUNT(DISTINCT ai.protocol) ELSE NULL END AS qtd_os_instalacao,
CASE WHEN ai.incident_type_id = 1006 THEN COUNT(DISTINCT pat.serial_number) ELSE NULL END AS qtd_patrimonios_instalacao,
TRUNC((CASE WHEN ai.incident_type_id = 1006 THEN COUNT(DISTINCT pat.serial_number) ELSE NULL END) / (CASE WHEN ai.incident_type_id = 1006 THEN COUNT(DISTINCT ai.protocol) ELSE NULL END),2) AS media_alocados_instalacao,

CASE WHEN ai.incident_type_id = 1010 THEN COUNT(DISTINCT ai.protocol) ELSE NULL END AS qtd_os_pendencia,
CASE WHEN ai.incident_type_id = 1010 THEN COUNT(DISTINCT pat.serial_number) ELSE NULL END AS qtd_patrimonios_pendencia,
TRUNC((CASE WHEN ai.incident_type_id = 1010 THEN COUNT(DISTINCT pat.serial_number) ELSE NULL END) / (CASE WHEN ai.incident_type_id = 1010 THEN COUNT(DISTINCT ai.protocol) ELSE NULL END),2) AS media_alocados_pendencia
*/

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

GROUP BY vu.name,ini.service_product_id, 1,2,3,4,ini.first_units_measure_id