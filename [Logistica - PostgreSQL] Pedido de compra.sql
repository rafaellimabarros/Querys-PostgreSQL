SELECT
p.id AS cod_pedido_compra,
(SELECT pe.name FROM people AS pe WHERE pe.id = p.supplier_id) AS fornecedor,
(SELECT cp.description FROM companies_places AS cp  WHERE cp.id =p.company_place_id) AS local_compra,
p.date AS data_pedido_compra,
(SELECT s.title FROM service_products AS s WHERE s.id = pa.service_product_id) AS material,
pa.units AS quantidade,
(SELECT um.title FROM units_measures AS um WHERE um.id = sp.first_unit) AS medida,
pa.unit_amount AS valor_unidade,
pa.total_amount AS valor_total,
(SELECT v.name FROM v_users AS v WHERE v.id = pa.modified_by) AS usuario_responsavel,
p.approvation_date AS data_aprovacao,
(SELECT pe.name FROM people AS pe WHERE pe.id = p.approver_id) AS usuario_aprovador,
p.deleted,
p."status"

FROM product_acquisition_request_items  AS pa
INNER JOIN product_acquisition_requests AS p ON p.id = pa.product_acquisition_request_id
INNER JOIN service_products AS sp ON sp.id = pa.service_product_id

WHERE pa.modified BETWEEN '2022-12-01' AND '2022-12-31' 
AND p.status = 5