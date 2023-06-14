SELECT DISTINCT ON (fat.id)
c.id AS cod_contrato,
p.name AS nome,
p.tx_id AS cpf_cnpj,
p.id AS cod_cliente,
c.v_status AS status_contrato,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS logradouro,
p.number AS numero,
p.address_complement AS complemento,
COALESCE((SELECT p.phone FROM people AS p WHERE p.id = c.responsible_financial_id),p.phone) AS telefone,
p.cell_phone_1 AS celular1,
fat.balance AS valor,
fat.expiration_date AS vencimento,
(SELECT MAX(pag.receipt_date) FROM financial_receipt_titles AS pag WHERE fat.client_id = pag.client_id) AS ult_liq,
(SELECT comp.description FROM companies_places AS comp WHERE c.company_place_id = comp.id AND c.company_place_id != 3) AS empresa_contrato,
fat.origin
FROM 
financial_receivable_titles AS fat
INNER JOIN 
people AS p ON fat.client_id = p.id 
LEFT JOIN
contracts AS c ON fat.contract_id = c.id
WHERE
fat.p_is_receivable = TRUE
and fat.type = 2
AND fat.deleted = FALSE
AND  fat.financer_nature_id != 158 /*NATUREZA DE ORGÃOS PÚBLICOS*/
/*AND fat.origin = 7 NOT IN (2,3, 5, 7)*/
AND c.contract_type_id NOT IN (4, 6, 7, 8, 9) /*Cortesia, Contratos Orgao Publico - Mensal, Contratos Orgao Publico - Carnê, Contratos PF - Mensal - Link Barato, Contratos PJ - Mensal - Link Barato*/
AND fat.company_place_id != 3
/*AND (fat.financial_collection_type_id IS NOT NULL AND fat.financial_collection_type_id NOT IN (2, 6, 8, 10, 12, 14, 16))*/
AND fat.renegotiated = FALSE
AND DATE(fat.expiration_date) BETWEEN '2022-12-01' AND '2022-12-05'