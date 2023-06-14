SELECT 
	conc.financial_bank_conciliation_file_id AS id_conciliacao,
	conc.transation_type AS tipo,
	conc.description AS descricao,
	CASE WHEN conc."signal" = 1 THEN 'CREDITO' WHEN conc."signal" != 1 THEN 'DEBITO' END AS sinal,
	conc.effective_date AS data_conciliacao
FROM 
	financial_bank_conciliation_occurrences AS conc
INNER JOIN 
	v_users AS u ON conc.modified_by = u.id
WHERE 
	date(effective_date) BETWEEN '2022-07-01' AND '2022-07-31'
	AND conc.vinculated_posting = TRUE
	AND conc.modified_by = 40