SELECT
date(notas.created) AS data_emissao,
CONCAT(DATE_PART('hour',notas.created),':',DATE_PART('minute',notas.created),':',trunc(DATE_PART('seconds',notas.created))) AS horario,
notas.client_id AS id_responsavel,
notas.client_name AS responsavel,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = notas.financial_operation_id) AS operacao,
CASE WHEN notas."status" = 9 THEN 'Cancelada' WHEN notas."status" = 1 THEN 'Autorizada' ELSE NULL END AS status_nota,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS material,
(SELECT um.title FROM units_measures AS um WHERE um.id = ini.first_units_measure_id) AS unidade_medida,
ini.units AS quantidade,
ini.unit_amount AS valor_unidade,
ini.total_amount AS valor_total_material,
(SELECT pat.serial_number FROM patrimonies AS pat WHERE pat.id = ini.patrimony_id) AS serial_patrimonio,
(SELECT pat.tag_number FROM patrimonies AS pat WHERE pat.id = ini.patrimony_id) AS etiqueta_patrimonio,
notas.observation_invoice_1 AS motivo,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = notas.created_by) AS criador_nota,
notas.document_number AS numero_nota,
notas.total_amount_products AS valor_total_nota,
notas.company_place_name AS empresa,
date(notas.cancellation_date) AS data_cancelamento,
CONCAT(DATE_PART('hour',notas.cancellation_date),':',DATE_PART('minute',notas.cancellation_date),':',trunc(DATE_PART('seconds',notas.cancellation_date))) AS horario_cancelamento,
notas.cancellation_motive AS motivo_cancelamento,
(SELECT p.name FROM people AS p WHERE p.id = notas.cancellation_person_id) AS usuario_que_cancelou


FROM invoice_notes AS notas
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = notas.id

WHERE notas.financial_operation_id IN (69,70,71)
AND DATE(notas.created) BETWEEN '2023-01-01' AND '2023-03-30'

ORDER BY notas.status ASC