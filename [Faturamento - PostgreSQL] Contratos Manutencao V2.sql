SELECT
c.id,
c.description,
c.amount,
c.v_status,
c.final_date,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrto,
c.v_stage,
c.deleted,
c.contract_date_configuration_id

FROM contracts AS c
INNER JOIN people AS p ON p.id = c.client_id

WHERE c.v_status IN ('Normal','Demonstração', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') AND v_stage = 'Aprovado'

