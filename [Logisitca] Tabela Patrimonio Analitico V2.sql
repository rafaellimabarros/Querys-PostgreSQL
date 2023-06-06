SELECT DISTINCT ON (notas.id, pat.id)
	pp.responsible_id AS cod_colaborador,
	(SELECT p.name FROM people AS p WHERE p.id = pp.responsible_id ) AS colaborador,
	(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe,
	notas.document_number AS nota_fiscal,
	CASE 
		WHEN notas.signal = 1 THEN 'saida_tecnico' 
		WHEN notas.signal = 2  THEN 'entrada_tecnico' 
		END AS tipo,
	CASE 
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Vinculado a um Contrato%' THEN 'Cliente'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%para Separado Manutenção%' THEN 'Separado Manutenção'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Devolvido de Romaneio%' THEN 'Estoque - Disponível'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Alterado Data de Compra%' THEN 'Separado Manutenção'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Enviado em Romaneio%' 
			THEN CONCAT('Enviado para o colaborador ',SPLIT_PART(LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),'de ', 3))
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%para Reserva interna%' THEN 'Reserva Interna'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Alterado Local%' THEN 'Estoque - Disponível'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Remessa para uso fora do estabelecimento%' 
			THEN CONCAT('Enviado para ',SPLIT_PART(LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),'localizado no ', 2))
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Alterado Nº de Série%' THEN 'Estoque - Disponível'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%para Normal%' THEN 'Estoque - Disponível'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Descarte%' THEN 'Descarte'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Cancelamento da NF de movimentação%' THEN 'Estoque - Disponível'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Devolução do Objeto%' THEN 'Estoque - Disponível'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Venda do objeto%' THEN 'Vendido'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%para Paradeiro Desconhecido%' THEN 'Paradeiro Desconhecido'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Desvinculado de contrato%' THEN 'Estoque do Próprio Técnico'
		WHEN notas.signal = 1 and LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LIKE '%Pedido de Venda Cancelado%' THEN 'Estoque - Disponível'
		END AS destino,
	CASE 
		WHEN notas.signal = 1 THEN LAST_VALUE(po.description) OVER (PARTITION BY pat.id,notas.id ORDER BY po.id asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
		ELSE NULL 
		END AS ocorrencia_apos_saida,
	sp.code AS cod_patrimonio,
	(SELECT sp.title FROM service_products AS sp WHERE  sp.id = pat.service_product_id) AS patrimonio,
	pat.serial_number AS numero_serial,
	pat.tag_number AS etiqueta,
	CASE 
		WHEN notas.signal = 2 THEN (SELECT p.name FROM people AS p WHERE p.id = ppl.person_allocator_id ) 
		WHEN notas.signal = 1 THEN NULL 
		END AS usuario_movimentou_para_tecnico,
	CASE 
		WHEN notas.signal = 2 THEN date(ppl.created) WHEN notas.signal = 1 THEN NULL 
		END AS data_entrada,
	CASE 
		WHEN notas.signal = 2 THEN CONCAT(DATE_PART('hour',ppl.created),':',DATE_PART('minute',ppl.created),':',trunc(DATE_PART('seconds',ppl.created))) 
		WHEN notas.signal = 1 THEN NULL 
		END AS hora_entrada,
	CASE 
		WHEN notas.signal = 1 THEN (SELECT v.name FROM v_users AS v WHERE v.id = notas.created_by) 
		WHEN notas.signal = 2 THEN NULL 
		END AS usuario_retirou_do_tecnico,
	CASE 
		WHEN notas.signal = 1 THEN date(notas.modified) WHEN notas.signal = 2 THEN NULL 
		END AS data_saida,
	CASE 
		WHEN notas.signal = 1 THEN CONCAT(DATE_PART('hour',notas.modified),':',DATE_PART('minute',notas.modified),':',trunc(DATE_PART('seconds',notas.modified))) 
		WHEN notas.signal = 2 THEN NULL 
		END AS hora_saida,
	CASE 
		WHEN notas.signal = 1 and pat.situation = 0 AND pat.p_is_disponible = TRUE THEN 'Disponivel'
		WHEN notas.signal = 1 and pat.situation = 0 AND pat.p_is_disponible = FALSE AND pat.deleted = FALSE THEN 'Indisponivel'
		WHEN notas.signal = 1 and pat.situation = 0 AND pat.p_is_disponible = FALSE AND pat.deleted = TRUE THEN 'Descartado'
		WHEN notas.signal = 1 and pat.situation = 1 THEN 'Separado para Manutenção'
		WHEN notas.signal = 1 and pat.situation = 2 AND pat.p_is_disponible = FALSE THEN 'Vendido'
		WHEN notas.signal = 1 and pat.situation = 2 AND pat.p_is_disponible = TRUE THEN 'Aguardando Retorno'
		WHEN notas.signal = 1 and pat.situation = 3 THEN 'Paradeiro Desconhecido'
		WHEN notas.signal = 1 and pat.situation = 4 THEN 'Reserva Interna'
		ELSE NULL
		END AS status_atual_do_patrimonio,
	CASE 
		WHEN notas.signal = 1 THEN pat.last_occurrence_description 
		WHEN notas.signal = 2 THEN NULL 
		END AS ultima_ocorrencia_do_patrimonio
	
	FROM patrimonies AS pat
		JOIN patrimony_packing_list_items AS ppl ON ppl.patrimony_id = pat.id 
		JOIN patrimony_packing_lists AS pp ON ppl.patrimony_packing_list_id = pp.id
		JOIN people AS p ON pp.responsible_id = p.id
		JOIN invoice_notes AS notas ON notas.id = ppl.out_invoice_note_id OR ppl.return_invoice_note_id = notas.id
		LEFT JOIN v_users AS v ON p.name = v.name
		LEFT JOIN service_products AS sp ON pat.service_product_id =  sp.id
		JOIN patrimony_occurrences AS po ON po.patrimony_id = pat.id AND date(po.created) <= date(notas.created)
	
	WHERE 
	 DATE(notas.created) BETWEEN '2023-01-01' AND '2023-03-31'
	 AND v.team_id IN (1,1003,1011)
	 AND ( pat.client_id IS NULL 
	 OR pat.client_id <> pp.responsible_id )
	 AND pat.return_pending = FALSE
	 AND pp.responsible_id = 42