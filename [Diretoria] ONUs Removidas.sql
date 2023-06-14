SELECT
p.id AS cod_cliente,
c.id AS cod_contrato,
p.name AS cliente,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
ppli.out_date AS data_alocacao,
ppli.returned_date AS data_troca,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ppli.modified_by) AS nome_reposnsavel_troca,
pat.title AS patrimonio,
pat.serial_number AS numero_serial,
pat.tag_number AS etiqueta,
CASE 
WHEN pat.situation = 0 AND pat.p_is_disponible = TRUE THEN 'Disponivel'
WHEN pat.situation = 0 AND pat.p_is_disponible = FALSE AND pat.deleted = FALSE THEN 'Indisponivel'
WHEN pat.situation = 0 AND pat.p_is_disponible = FALSE AND pat.deleted = TRUE THEN 'Descartado'
WHEN pat.situation = 1 THEN 'Separado para Manutenção'
WHEN pat.situation = 2 AND pat.p_is_disponible = FALSE THEN 'Vendido'
WHEN pat.situation = 2 AND pat.p_is_disponible = TRUE THEN 'Aguardando Retorno'
WHEN pat.situation = 3 THEN 'Paradeiro Desconhecido'
WHEN pat.situation = 4 THEN 'Reserva Interna'
ELSE NULL
END AS status_atual_do_patrimonio,
pat.last_occurrence_description AS ultima_ocorrencia_patrimonio
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
AND c.id NOT IN 
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
 		
ORDER BY p.name asc