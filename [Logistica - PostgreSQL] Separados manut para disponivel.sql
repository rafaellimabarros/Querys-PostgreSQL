SELECT
date(pato.modified) AS data_ocorrencia,
CONCAT(DATE_PART('hour',pato.modified),':',DATE_PART('minute',pato.modified),':',trunc(DATE_PART('seconds',pato.modified))) AS hora_ocorrencia,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = pato.modified_by) AS responsavel,
pato.description AS ocorrencia,
pat.id AS cod_patrimonio,
pat.title AS titulo,
pat.serial_number AS num_serie,
pat.tag_number AS num_patrimonio,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = pat.company_place_id) AS empresa,
CASE 
WHEN pat.situation = 0 AND pat.p_is_disponible = TRUE THEN 'Disponivel'
WHEN pat.situation = 0 AND pat.p_is_disponible = FALSE AND pat.deleted = FALSE THEN 'Indisponivel'
WHEN pat.situation = 0 AND pat.p_is_disponible = FALSE AND pat.deleted = TRUE THEN 'Descartado'
WHEN pat.situation = 1 THEN 'Separado para Manutenção'
WHEN pat.situation = 2 AND pat.p_is_disponible = FALSE THEN 'Vendido'
WHEN pat.situation = 2 AND pat.p_is_disponible = TRUE THEN 'Aguardando Retorno'
WHEN pat.situation = 3 THEN 'Paradeiro Desconhecido'
WHEN pat.situation = 4 THEN 'Reserva Interna'
ELSE NULL END AS status_atual,
pat.last_occurrence_description AS ultima_ocorrencia

FROM patrimonies AS pat
INNER JOIN patrimony_occurrences AS pato ON pato.patrimony_id = pat.id

WHERE pato.description LIKE '%de Separado Manutenção para Normal%'
AND date(pato.modified) BETWEEN '2023-03-01' AND '2023-03-31'

ORDER BY pat.id, pato.modified desc