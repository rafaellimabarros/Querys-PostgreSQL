SELECT
ai.protocol AS protocolo,
(SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id) AS tipo_os,
(SELECT pt.title FROM patrimonies AS pt WHERE pt.id = p.patrimony_id ) AS patrimonio,
pt.serial_number AS numero_serie,
(SELECT pl.name FROM people AS pl WHERE pl.id = pp.responsible_id) AS cliente,
(SELECT pl.name FROM people AS pl WHERE pl.id = p.person_allocator_id ) AS responsavel,
P.out_invoice_note_id AS nota_entrada,
i.total_itens AS quantidade_itens_nota

FROM   patrimony_packing_list_items AS p
INNER JOIN   patrimony_packing_lists AS pp ON pp.id = p.patrimony_packing_list_id
INNER JOIN assignments AS a ON a.id = pp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN invoice_notes AS i ON i.id = p.out_invoice_note_id
INNER JOIN patrimonies AS pt ON pt.id = p.patrimony_id

WHERE pp.assignment_id IS NOT NULL
AND p.returned = 0
AND pp.assignment_id IS NOT NULL
AND p.return_invoice_note_id IS NULL
AND pt.serial_number = '22062B7006455'