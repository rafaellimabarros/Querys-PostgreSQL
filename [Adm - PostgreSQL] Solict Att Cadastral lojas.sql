SELECT DISTINCT ON (c.id)
p.id AS id_cliente,
c.id AS contrato,
SUBSTR(p.name, 1, STRPOS(p.name , ' ')) AS nome,
p.city AS cidade,
p.neighborhood AS bairro,
p.cell_phone_1 AS celular,
p.phone AS telefone,
a.title AS solicitação,
a.modified AS data_encerramento

FROM people AS p 
INNER JOIN 
contracts AS c ON c.client_id = p.id
INNER JOIN 
assignments AS a ON p.id = a.requestor_id
INNER JOIN
assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN 
contract_assignment_activations AS ca ON ca.contract_id = c.id
LEFT JOIN
authentication_contracts AS pl ON c.id = pl.contract_id

WHERE
c.v_status IN ('Normal', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo')
AND c.company_place_id !=3
AND c.v_stage ='Aprovado'
AND a.title LIKE '%ATUALIZAÇÃO CADASTRAL%'
AND a.modified BETWEEN '2022.07.01' AND '2022.08.04'