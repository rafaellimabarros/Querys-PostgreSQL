SELECT 
sr.id,
p.name,
ai.protocol,
sr.situation,
sr.deleted,
sr.beginning_date,
DATE (sr.created) AS data_criacao_ped_venda,
sr.total_amount AS valor_faturamento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = sr.modified_by) AS modificado_por,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = sri.service_product_id) AS item,
sri.description,
sri.created,
sri.modified,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = sri.created_by) AS item_criado_por,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = sri.modified_by) AS item_modificado_por

FROM assignments AS a
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN people AS p ON p.id = a.requestor_id
INNER JOIN sale_requests AS sr ON sr.id = ai.sale_request_id
LEFT JOIN sale_request_items AS sri ON sri.sale_request_id = sr.id

WHERE sr.deleted = FALSE
--and sr.situation = 1
AND sr.id = 47042
-- AND sr.id IN (45811, 46816, 46889, 45793)