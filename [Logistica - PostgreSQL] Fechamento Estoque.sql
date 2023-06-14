SELECT
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = pcb.company_place_id) AS empresa,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = pcb.service_product_id) AS produto,
pcb.closing_date AS data_encerramento,
pcb.opening_balance AS quantidade_abertura,
pcb.movimentation AS movimentacao,
pcb.closing_balance AS quantidade_encerramento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = pcb.created_by) AS usuario_criacao

FROM products_closing_balances AS pcb

WHERE pcb.closing_date BETWEEN '2022-06-01' AND '2022-06-30' AND pcb.deleted = false

ORDER BY pcb.opening_balance desc

