SELECT DISTINCT ON (ctag.id)
p.id AS cod_cliente,
c.id AS cod_contrato,
(SELECT cp.description from companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
p.name AS cliente,
ctag.service_tag AS etiqueta,
(SELECT pat.title FROM patrimonies AS pat WHERE pat.id = pst.patrimony_id) AS patrimonio_alocado,
(SELECT pat.serial_number FROM patrimonies AS pat WHERE pat.id = pst.patrimony_id) AS serial_patrimonio,
ctag.title AS titulo_etiqueta,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato,
c.v_status AS status_contrato,
DATE(ctag.created) AS data_criacao_etiqueta,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ctag.created_by) AS usuario_criador_etiqueta
/*pst.active AS pst_ativo,
pst.created AS data_patrimonio,
pst.created_by AS usuario_patrimonio,
COUNT(ctag.id) OVER (PARTITION BY ctag.contract_id) AS contagem_etiquetas*/
   
FROM contract_service_tags AS ctag
INNER JOIN contracts AS c ON c.id = ctag.contract_id
INNER JOIN people AS p ON p.id = c.client_id
LEFT JOIN patrimonies_service_tags AS pst ON pst.contract_service_tag_id = ctag.id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id

WHERE date(ctag.created) BETWEEN '2018-01-01' AND '2023-01-26'
AND ctag.active = TRUE
AND ctag.deleted = FALSE
AND c.contract_type_id != 6
AND c.v_status IN ('Normal','Bloqueio Financeiro','Suspenso')

/*GROUP BY ctag.id,1,2,3,4,5,6,7,8,9,10,11,12*/