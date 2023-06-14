SELECT
p.id AS cod_cliente,
c.id AS cod_contrato,
p.name AS cliente,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
pat.title AS patrimonio,
pat.serial_number AS numero_serial,
ppli.out_date AS data_alocacao,
ppli.returned_date AS data_troca,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ppli.modified_by) AS nome_reposnsavel_troca
--(SELECT notas.document_number FROM invoice_notes AS notas WHERE notas.id = ppli.out_invoice_note_id) AS nota_fiscal
-- COUNT(a.id) OVER (PARTITION BY c.id)

FROM assignments AS a
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN people AS p ON p.id = a.requestor_id
INNER JOIN patrimony_packing_lists AS ppl ON ppl.assignment_id = a.id
INNER JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
INNER JOIN patrimonies AS pat ON pat.id = ppli.patrimony_id
INNER JOIN contract_service_tags AS ctag ON ctag.id = ppl.contract_service_tag_id
INNER JOIN contracts AS c ON c.id = ctag.contract_id

WHERE ppli.returned_date BETWEEN '2023-03-01' AND '2023-03-31'
AND pat.title LIKE '%ONU%'
AND c.id IN 
 		(
 		select
		c.id
 		
 		FROM assignments AS a
		INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
 		INNER JOIN people AS p ON p.id = a.requestor_id
		INNER JOIN patrimony_packing_lists AS ppl ON ppl.assignment_id = a.id
 		INNER JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
		INNER JOIN patrimonies AS pat ON pat.id = ppli.patrimony_id
		INNER JOIN contract_service_tags AS ctag ON ctag.id = ppl.contract_service_tag_id
 		INNER JOIN contracts AS c ON c.id = ctag.contract_id
		
		WHERE ppli.out_date >= '2023-03-01'
		AND c.id IN 
			(
				SELECT
				c.id
		 		
		 		FROM assignments AS a
				INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
		 		INNER JOIN people AS p ON p.id = a.requestor_id
				INNER JOIN patrimony_packing_lists AS ppl ON ppl.assignment_id = a.id
		 		INNER JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
				INNER JOIN patrimonies AS pat ON pat.id = ppli.patrimony_id
				INNER JOIN contract_service_tags AS ctag ON ctag.id = ppl.contract_service_tag_id
		 		INNER JOIN contracts AS c ON c.id = ctag.contract_id
				
				WHERE ppli.returned_date IS NULL
				AND DATE(ppl.created) >= '2023-03-01'
			)
 		)
 		
ORDER BY p.name asc
