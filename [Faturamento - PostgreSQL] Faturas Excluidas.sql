SELECT
fat.id,
fat.client_id,
p.name,
fat.type,
fat.situation,
fat.title,
fat.document_amount,
fat.title_amount,
fat.balance,
fat.issue_date,
fat.entry_date,
fat.expiration_date,
fat.original_expiration_date,
fat.contract_id,
fat.competence,
fat.created,
fat.modified,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = fat.created_by) AS criador,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = fat.modified_by ) AS editor

FROM financial_receivable_titles AS fat
INNER JOIN people AS p on p.id = fat.client_id

WHERE fat.entry_date BETWEEN '2021-01-01' and '2021-07-31'
AND fat.deleted = true