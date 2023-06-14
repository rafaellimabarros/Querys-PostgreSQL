SELECT DISTINCT ON (ppli.patrimony_id)
(SELECT p.name FROM people AS p WHERE p.id = ppl.responsible_id) AS cliente,
pat.title AS titulo,
pat.serial_number AS num_serial,
pat.tag_number AS patrimonio,
DATE(ppl.created) AS data_alocacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ppli.created_by) AS usuario_que_alocou_ao_cliente,
ppli.returned_date AS data_que_foi_desalocado,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ppli.modified_by) AS usuario_que_desalocou,
(SELECT t.title FROM teams AS t WHERE t.id = (SELECT vu.team_id FROM v_users AS vu WHERE vu.id = ppli.modified_by)) AS equipe_usuario_que_desalocou,
po.created AS data_recebimento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = po.created_by) AS usuario_que_recebeu,
(SELECT t.title FROM teams AS t WHERE t.id = (SELECT vu.team_id FROM v_users AS vu WHERE vu.id = po.created_by)) AS equipe_usuario_que_recebeu,
po.description AS descricao,
notas.document_number AS numero_nota_fiscal,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = notas.financial_operation_id) AS operacao

FROM patrimony_packing_lists AS ppl
INNER JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
INNER JOIN patrimonies AS pat on pat.id = ppli.patrimony_id
INNER JOIN invoice_notes AS notas ON notas.id = ppli.return_invoice_note_id
INNER JOIN patrimony_occurrences AS po ON po.patrimony_id = pat.id AND date(po.created) >= '2023-01-01'
INNER JOIN v_users AS vu ON vu.id = ppli.modified_by

WHERE date(ppli.returned_date) between '2023-01-01' AND '2023-03-03'
and ppli.returned = 1
AND notas.financial_operation_id = 9
AND vu.team_id NOT IN (3,1004,1006)

AND ppli.patrimony_id NOT IN
	(
		SELECT
		po.patrimony_id
		
		FROM patrimony_occurrences AS po
		INNER JOIN patrimonies AS pat ON pat.id = po.patrimony_id
		INNER JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_id = pat.id
		
		WHERE DATE(ppli.returned_date) BETWEEN '2023-01-01' AND '2023-03-03'
		AND date(po.created) >= DATE(ppli.returned_date)
		AND po.description LIKE '%para Separado Manutenção%'
	)

ORDER BY ppli.patrimony_id,po.id DESC;
-- depois que foi desvinculado, precisa ter sido alterado para separado manutenção, isso significa que voltou para o estoque principal