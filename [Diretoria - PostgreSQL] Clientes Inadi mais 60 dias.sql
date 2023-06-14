SELECT DISTINCT ON (fat.id)
p.id AS cod_pessoa,
c.id AS cod_contrato,
p.name AS nome,
c.v_status AS status_contrato,
c.cancellation_date AS data_cancelamento,
p.neighborhood AS bairro,
p.city AS cidade,
COALESCE((SELECT p.phone FROM people AS p WHERE p.id = c.responsible_financial_id),p.phone) AS telefone,
p.cell_phone_1 AS celular1,
fat.balance AS valor_em_aberto,
fat.expiration_date AS vencimento,
fat.title AS fatura,
CASE WHEN fat.renegotiated = FALSE THEN 'Nao' ELSE 'Sim' END AS titulo_renegociado,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = fat.financial_collection_type_id) AS tipo_cobranca,
(SELECT fatet.title FROM financial_title_occurrence_types AS fatet WHERE fatet.id = fate.financial_title_occurrence_type_id) AS evento,
fate.date AS data_contato,
fate.description AS descricao_contato,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = fate.created_by) AS responsavel_contato

FROM financial_receivable_titles AS fat
INNER JOIN people AS p ON fat.client_id = p.id
LEFT JOIN financial_receivable_title_occurrences AS fev ON fat.id = fev.financial_receivable_title_id AND (fev.financial_title_occurrence_type_id IN (1, 2, 3, 5) OR fev.financial_title_occurrence_type_id IS NULL) 
LEFT JOIN contracts AS c ON fat.contract_id = c.id
INNER JOIN assignments AS a ON a.requestor_id = p.id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN financial_receivable_title_occurrences AS fate ON fate.financial_receivable_title_id = fat.id AND fate.financial_title_occurrence_type_id = 5

WHERE
fat.p_is_receivable = TRUE
AND fat.type = 2
AND fat.deleted = FALSE
AND fat.origin NOT IN (2, 3, 5, 7)
AND c.contract_type_id NOT IN (4, 6, 7, 8, 9)
AND fat.company_place_id != 3
AND fat.financial_collection_type_id IS NOT NULL
AND fat.expiration_date BETWEEN '2022-05-01' AND '2022-05-20'
