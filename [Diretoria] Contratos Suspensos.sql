SELECT DISTINCT ON (c.id)
p.id AS cod_cliente,
c.id AS cod_contrato,
p.name AS cliente,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo_cliente,
c.v_status AS status,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato,
(SELECT cet.title FROM contract_event_types AS cet WHERE cet.id = ce.contract_event_type_id) AS motivo,
	LAST_VALUE(ce.description) OVER (
		  PARTITION BY c.id
        ORDER BY ce.id asc
        RANGE BETWEEN
            UNBOUNDED PRECEDING AND
            UNBOUNDED FOLLOWING
    ) descricao_bloqueio,
--MAX(date(ce.date)) OVER (PARTITION BY c.id) AS data_suspensao,
CASE WHEN ce.contract_event_type_id IN (9,30,42) THEN MIN(date(ce.date)) OVER (PARTITION BY c.id) ELSE MAX(date(ce.date)) OVER (PARTITION BY c.id) end AS data_suspensao,
--DATEDIFF(CURDATE(), MAX(date(ce.date)) OVER (PARTITION BY c.id)) AS dias_bloqueado,
CASE WHEN ce.contract_event_type_id IN (9,30,42) THEN DATEDIFF(CURDATE(), MIN(date(ce.date)) OVER (PARTITION BY c.id)) ELSE DATEDIFF(CURDATE(), MAX(date(ce.date)) OVER (PARTITION BY c.id)) END AS dias_bloqueado

FROM contracts AS c
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN contract_events AS ce ON ce.contract_id = c.id 

WHERE c.v_status = 'Suspenso' AND v_stage = 'Aprovado'
AND ce.contract_event_type_id IN (152, 153,	206,	207,	208,	209,	210,	211,	212,	215,	216,	217,	218,	219,	220,	221,	222,	223,	224,	231)
AND c.id IN 
	(
		SELECT
		c.id
		
		FROM contracts AS c
		INNER JOIN contract_events AS ce ON ce.contract_id = c.id
		
		WHERE c.v_status IN ('Suspenso') AND v_stage = 'Aprovado'
		AND ce.contract_event_type_id IN (152,	153,	206,	207,	208,	209,	210,	211,	212,	215,	216,	217,	218,	219,	220,	221,	222,	223,	224,	231)
		
		OR
		
		c.v_status IN ('Suspenso') AND v_stage = 'Aprovado'
		AND ce.description LIKE '%Detalhes da suspensão%'	
	)
	
OR

c.v_status = 'Suspenso' AND v_stage = 'Aprovado'
AND ce.description LIKE '%Detalhes da suspensão%'
AND c.id IN 
	(
		SELECT
		c.id
		
		FROM contracts AS c
		INNER JOIN contract_events AS ce ON ce.contract_id = c.id
		
		WHERE c.v_status IN ('Suspenso') AND v_stage = 'Aprovado'
		AND ce.contract_event_type_id IN (152,	153,	206,	207,	208,	209,	210,	211,	212,	215,	216,	217,	218,	219,	220,	221,	222,	223,	224,	231)
		
		OR
		
		c.v_status IN ('Suspenso') AND v_stage = 'Aprovado'
		AND ce.description LIKE '%Detalhes da suspensão%'	
	)

OR

c.v_status = 'Suspenso' AND v_stage = 'Aprovado'
AND c.id not IN 
	(
		SELECT
		c.id
		
		FROM contracts AS c
		INNER JOIN contract_events AS ce ON ce.contract_id = c.id
		
		WHERE c.v_status IN ('Suspenso') AND v_stage = 'Aprovado'
		AND ce.contract_event_type_id IN (152,	153,	206,	207,	208,	209,	210,	211,	212,	215,	216,	217,	218,	219,	220,	221,	222,	223,	224,	231)
		
		OR 
		
		c.v_status IN ('Suspenso') AND v_stage = 'Aprovado'
		AND ce.description LIKE '%Detalhes da suspensão%'	
		
	)
	
ORDER BY c.id, ce.id desc