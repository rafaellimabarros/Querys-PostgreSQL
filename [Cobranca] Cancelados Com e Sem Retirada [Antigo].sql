SELECT DISTINCT ON (c.id)
c.id AS contrato,
p.id AS cod_cliente,
p.name AS nome,
p.phone AS telefone,
p.cell_phone_1 AS celular,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
c.v_status AS status_contrato,
p.city AS rua,
p.number AS numero,
p.neighborhood AS bairro,
p.city AS cidade,
c.modified AS data_cancelamento,
ppl.returned,
date(ppl.modified) AS data_remocao,
DATE(c.cancellation_date) AS data_cancelamento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ppl.modified_by) AS responsavel_retirada,
ai.protocol,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo,


CASE WHEN MAX(ppl.returned) = 1 AND ai.incident_type_id IN (1015,1291) THEN 'sim' ELSE  'nao' END AS equipamentos_retirados

/*max(date(ppl.modified)) >= DATE(c.cancellation_date)*/
FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id 
LEFT JOIN assignments AS a ON p.id = a.requestor_id
LEFT JOIN patrimonies AS ps ON p.id = ps.client_id 
LEFT JOIN patrimony_packing_lists AS pp ON a.id = pp.assignment_id 
LEFT JOIN patrimony_packing_list_items AS ppl ON pp.id = ppl.patrimony_packing_list_id
LEFT JOIN invoice_notes AS notas ON ppl.out_invoice_note_id = notas.id
LEFT JOIN assignment_incidents AS ai ON pp.assignment_id = ai.assignment_id

WHERE c.v_status = 'Cancelado'
AND c.v_stage ='Aprovado'
AND date(c.modified) BETWEEN '2022-08-01' AND '2023-01-08'
AND c.company_place_id <> 3

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18