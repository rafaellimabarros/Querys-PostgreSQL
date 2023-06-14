SELECT DISTINCT ON (fr.id)
     p.id AS cod_cliente,
	  c.id AS id_contrato,
     p.name AS  cliente,
     (SELECT p.name FROM people AS p WHERE p.id = fr.responsible_id) AS reponsavel,
     (SELECT cp.description FROM companies_places AS cp  WHERE cp.id = frt.company_place_id) AS local_,
     c.beginning_date AS ativacao,
     frt.competence AS mes_cobranca,
     fr.total_amount_renegotiated AS valor_original,
	  fr.renegotiation_diff valor_descontado,
     frt.title_amount AS valor_renegociado,
     fr.date data_negociacao,
     frt.title AS titulo,
     frt.expiration_date AS novo_vencimento,
     frr.receipt_date AS data_recebimento
       
FROM financial_renegotiations AS fr
INNER JOIN
financial_renegotiation_titles AS fre ON  fr.id = fre.financial_renegotiation_id
INNER JOIN
financial_receivable_titles AS frt ON frt.id = fre.financial_receivable_title_id
INNER JOIN
financial_receipt_titles  AS frr ON frt.id = frr.financial_receivable_title_id
INNER JOIN
people AS P ON p.id = fr.client_id
INNER  JOIN
contracts AS c ON p.id = c.client_id

WHERE 
		date(fr.created) BETWEEN '2022.07.01' AND '2022.07.31'
		AND frt.deleted = false
		AND frt.company_place_id != 3 
		AND frr.receipt_date IS NOT NULL
