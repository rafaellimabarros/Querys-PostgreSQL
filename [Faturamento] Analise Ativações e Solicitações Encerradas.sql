SELECT 
p.id AS cod_cliente,
c.id AS cod_contrato,
p.name AS cliente,
c.v_status AS status_contrato,
c.v_stage AS estagio_contrato,
DATE(c.created) AS data_criacao_contrato,
c.approval_date AS data_aprovacao,
caa.activation_date AS data_ativacao,
date(r.modified) AS data_encerramento_relato,
date(a.conclusion_date) AS data_encerramento,
ai.protocol AS protocolo,
c.observation AS observacao_contrato,
r.description AS descricao_encerramento,
c.cancellation_date AS data_cancelamento

FROM contracts AS c
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
INNER JOIN people AS p on p.id = c.client_id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
LEFT JOIN assignments AS a ON a.id = caa.assignment_id
LEFT JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN reports AS r ON r.assignment_id = a.id

WHERE DATE(a.conclusion_date) BETWEEN '2022-12-01' AND '2022-12-31'
AND c.company_place_id != 3
AND r.progress >= 100