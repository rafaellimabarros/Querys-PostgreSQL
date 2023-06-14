SELECT
DISTINCT ON (vp.responsible_name,vp.service_product_title,DATE(notas.created))
vp.responsible_name AS responsavel,
DATE(notas.created) AS data_alocacao,
vp.service_product_code AS cod_produto,
vp.service_product_title AS produto,
COUNT(vp.service_product_title) AS qtd_os,
sum(vp.allocated_amount) AS total_produtos_alocados,
vp.first_unit_measure_title AS metrica,
trunc(AVG(vp.allocated_amount),2) AS media_alocados

/*sum(CASE when ai.incident_type_id = 1006 THEN 1 ELSE 0 END) AS qtd_os_instalacao,
SUM(CASE when ai.incident_type_id = 1006 THEN vp.allocated_amount ELSE 0 END) AS qtd_produtos,
TRUNC(SUM(CASE when ai.incident_type_id = 1006 THEN vp.allocated_amount ELSE null END) / sum(CASE when ai.incident_type_id = 1006 THEN 1 ELSE null END),2) AS media_produtos_instalacao,

SUM(CASE when ai.incident_type_id = 1010 THEN 1 ELSE 0 END) AS qtd_os_pendencia,
SUM(CASE when ai.incident_type_id = 1010 THEN vp.allocated_amount ELSE 0 END) AS qtd_produtos,
TRUNC(SUM(CASE when ai.incident_type_id = 1010 THEN vp.allocated_amount ELSE NULL END) / SUM(CASE when ai.incident_type_id = 1010 THEN 1 ELSE NULL END),2) AS media_produtos_pendencia
*/

/*SUM(CASE when ai.incident_type_id = 1433 THEN vp.allocated_amount ELSE 0 END) AS INSTALACAO_CFVT_PMA,
SUM(CASE when ai.incident_type_id = 1481 THEN vp.allocated_amount ELSE 0 END) AS INSTALACAO_CFVT_PMA_SPEED_DOME*/

FROM v_allocated_products AS vp
INNER JOIN invoice_notes AS notas ON notas.id = vp.invoice_note_id
INNER JOIN assignments AS a ON a.id = vp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE DATE(notas.created) BETWEEN '2022-11-07' AND '2022-11-07'
AND vp.allocated_amount > 0
AND vp.responsible_name LIKE '%CAIO FELIPE GOMES DOS SANTOS%'

GROUP BY vp.responsible_name,vp.service_product_title, 1,2,3,vp.first_unit_measure_title
