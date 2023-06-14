SELECT
sp.code AS codigo,
sp.title AS titulo,
sp.selling_price AS valor

FROM service_products AS sp

WHERE sp."type" = 2 AND sp.service_type = 2 AND sp.deleted = FALSE AND sp.service_product_group_id != 48
AND sp.active = true
