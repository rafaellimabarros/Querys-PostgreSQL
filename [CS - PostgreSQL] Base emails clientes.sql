SELECT DISTINCT ON (p.email)
p.name AS nome,
p.email AS email

FROM contracts AS c
INNER JOIN people AS p ON p.id = c.client_id

WHERE c.v_status IN ('Normal', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') 
AND v_stage = 'Aprovado' AND LENGTH (p.email) > 1 AND p.email != 'sememail@semdominio.com'
AND p.email LIKE '%@%'



