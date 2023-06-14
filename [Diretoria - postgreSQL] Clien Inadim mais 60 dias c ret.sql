SELECT DISTINCT ON (ai.protocol)
p.id AS cod_pessoa,
c.id AS cod_contrato,
p.name AS nome,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT i.title FROM incident_status AS i  WHERE ai.incident_status_id = i.id) AS status_solicitacao,
date(a.conclusion_date) AS encerramento_solicitacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.modified_by) AS operador_encerramento,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe_encerramento

FROM financial_receivable_titles AS fat
INNER JOIN people AS p ON fat.client_id = p.id
LEFT JOIN financial_receivable_title_occurrences AS fev ON fat.id = fev.financial_receivable_title_id AND (fev.financial_title_occurrence_type_id IN (1, 2, 3, 5) OR fev.financial_title_occurrence_type_id IS NULL) 
LEFT JOIN contracts AS c ON fat.contract_id = c.id
INNER JOIN assignments AS a ON a.requestor_id = p.id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN financial_receivable_title_occurrences AS fate ON fate.financial_receivable_title_id = fat.id AND fate.financial_title_occurrence_type_id = 5

WHERE
ai.incident_status_id IN (3,4,10,11)
AND ai.incident_type_id IN (1015,1231,1271,1291,1385,1484)
AND to_char(a.conclusion_date, 'YYYY') >= to_char(fat.expiration_date, 'YYYY')
AND a.modified_by NOT IN (35,56,123,58,57,42,55)
AND fat.p_is_receivable = TRUE
AND fat.type = 2
AND fat.deleted = FALSE
AND fat.origin NOT IN (2, 3, 5, 7)
AND c.contract_type_id NOT IN (4, 6, 7, 8, 9)
AND fat.company_place_id != 3
AND fat.financial_collection_type_id IS NOT NULL
AND fat.renegotiated = FALSE 
AND fat.expiration_date BETWEEN '2022-05-01' AND '2022-05-20'