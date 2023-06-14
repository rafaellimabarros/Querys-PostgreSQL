SELECT 
pp.responsible_id AS cod_responsavel,
(SELECT p.name FROM people AS p WHERE p.id = pp.responsible_id ) AS responsavel,
CASE WHEN v.active = FALSE THEN 'Inativo' ELSE 'Ativo' END AS status_usuario,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe,
sp.code AS cod_patrimonio,
(SELECT sp.title FROM service_products AS sp WHERE  sp.id = pat.service_product_id) AS patrimonio,
SUM (CASE WHEN	ppl.returned IN ( 1,0) THEN 1 ELSE 0 END) AS total_entrada,
SUM (CASE WHEN	ppl.returned IN (1,2) THEN 1 ELSE 0 END) total_saida,
(SUM (CASE WHEN	ppl.returned IN ( 1,0) THEN 1 ELSE 0 END)) - (SUM (CASE WHEN	ppl.returned IN (1,2) THEN 1 ELSE 0 END)) AS com_colaborador

FROM patrimonies AS pat
LEFT JOIN patrimony_packing_list_items AS ppl ON ppl.patrimony_id = pat.id 
LEFT JOIN patrimony_packing_lists AS pp ON ppl.patrimony_packing_list_id = pp.id
LEFT JOIN people AS p ON pp.responsible_id = p.id
LEFT JOIN v_users AS v ON p.name = v.name
LEFT JOIN assignments AS  a ON a.id = pp.assignment_id
LEFT JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN service_products AS sp ON pat.service_product_id = sp.id

WHERE
  DATE(ppl.created) BETWEEN '2023-02-20' AND '2023-02-20'
 AND v.team_id IN (1,1003,1011)
   AND ( pat.client_id IS NULL 
	 OR pat.client_id <> pp.responsible_id )	
	 AND pat.active = true
	 AND pat.return_pending = false
	 AND pat.deleted = FALSE 
	
GROUP BY 
1,2,3,4,5,6