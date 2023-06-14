SELECT 
inv.document_number AS numero_documento,
inv.company_place_name AS empresa_origem,
inv.client_name AS empresa_destino,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = inv.created_by) AS usuario_responsavel,
DATE (inv.created) AS data_movimentacao,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS produtos,
ini.units AS quantidade,
ini.unit_amount AS valor_unitario,
ini.total_amount AS valor_total

FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = inv.id

WHERE inv.financial_operation_id = 49
AND date(inv.created) BETWEEN '2023-02-02' AND '2023-02-02'