SELECT
(SELECT p.name FROM people AS p WHERE p.id = pp.responsible_id ) AS colaborador,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe,
(SELECT sp.title FROM service_products AS sp WHERE  sp.id = pat.service_product_id) AS patrimonio,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe,
notas.created AS data_movimentacao,
pat.serial_number AS mac,
sp.code AS codigo_produto,
pat.code AS codigo_produto,
(SELECT p.name FROM people AS p WHERE p.id = ppl.person_allocator_id ) AS alocador,
CASE WHEN notas."signal" = 1 THEN 'saida' WHEN notas."signal" = 2 THEN 'entrada' END AS tipo

FROM patrimonies AS pat
LEFT JOIN patrimony_packing_list_items AS ppl ON ppl.patrimony_id = pat.id 
LEFT JOIN patrimony_packing_lists AS pp ON ppl.patrimony_packing_list_id = pp.id
LEFT JOIN people AS p ON pp.responsible_id = p.id
INNER JOIN invoice_notes AS notas ON notas.id = ppl.out_invoice_note_id OR ppl.return_invoice_note_id = notas.id
LEFT JOIN v_users AS v ON p.name = v.name
LEFT JOIN assignments AS  a ON a.id = pp.assignment_id
LEFT JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN service_products AS sp ON pat.service_product_id =  sp.id

WHERE
 DATE(ppl.created) BETWEEN '2023-03-01' AND '2023-03-14'
 AND v.team_id IN (1,1003,1011)
 AND ( pat.client_id IS NULL 
 OR pat.client_id <> pp.responsible_id )	
-- AND pat.active = TRUE
 AND pat.return_pending = FALSE
-- AND pat.deleted = FALSE 
 AND pp.responsible_id = 42