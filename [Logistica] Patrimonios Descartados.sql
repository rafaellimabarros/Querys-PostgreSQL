SELECT 
notas.document_number AS nota_fiscal,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS titulo,
pat.tag_number AS patrimonio,
pat.serial_number AS numero_serial,
date(notas.created) AS data_descarte,
CONCAT(DATE_PART('hour',notas.created),':',DATE_PART('minute',notas.created),':',trunc(DATE_PART('seconds',notas.created))) AS hora_descarte,
(SELECT v.name FROM v_users AS v WHERE v.id = notas.created_by) AS responsavel_descarte,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id =  notas.company_place_id) AS local_nota,
notas.observation_invoice_1 AS observacao,
notas.cancellation_date

FROM invoice_notes AS notas
INNER JOIN invoice_note_items AS ini ON notas.id = ini.invoice_note_id 
INNER JOIN patrimonies AS pat ON ini.patrimony_id = pat.id

WHERE notas.financial_operation_id = 14
-- AND notas.cancellation_date IS  NULL 
-- AND pat.p_is_disponible = true
-- AND notas.created BETWEEN '2023-02-01' AND '2023-02-28'