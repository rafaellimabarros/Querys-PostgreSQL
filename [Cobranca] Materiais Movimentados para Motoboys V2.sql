SELECT DISTINCT ON (ppl.id)
ppl.id AS cod_movimentacao,
ppl.date AS data_movimentacao,
p.name AS nome_responsavel,
MIN (paac.description),
(SELECT t.title FROM teams AS t WHERE t.id = vu.team_id) AS equipe,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ppl.created_by) AS usuario_movimentador,
(SELECT pat.title FROM patrimonies AS pat WHERE pat.id = ppli.patrimony_id) AS patrimonio,
(SELECT pat.serial_number FROM patrimonies AS pat WHERE pat.id = ppli.patrimony_id) AS SERIAL,
(SELECT pat.tag_number FROM patrimonies AS pat WHERE pat.id = ppli.patrimony_id) AS pat,
(SELECT sp.selling_price FROM service_products AS sp WHERE sp.id = (SELECT pat.service_product_id FROM patrimonies AS pat WHERE pat.id = ppli.patrimony_id)) AS valor_venda,
CASE WHEN ppli.returned = 1 THEN 'Nao' ELSE 'Sim' END AS patrimonio_em_posse_do_tecnico,
ppli.returned_date AS data_saida_patrimonio

FROM patrimony_packing_lists AS ppl 
INNER JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
INNER JOIN patrimony_occurrences AS paac ON paac.patrimony_id = ppli.patrimony_id
INNER JOIN people AS p on p.id = ppl.responsible_id
INNER JOIN v_users AS vu ON vu.name = p.name

AND date(ppl.created) BETWEEN '2023-02-01' AND '2023-02-20'
AND vu.team_id = 1064
AND paac.occurrence_type = 2

GROUP BY 1,2,3,5,6,7,8,9,10,11,12