SELECT 
c.id AS cod_contrato,
p.name AS cliente,
c.amount AS valor_contrato,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.bill_company_place_id) AS local_fatura,
c.v_status AS situacao,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca,
(SELECT op.title FROM financial_operations AS op WHERE op.id = ag.financial_operation_id) AS operacao_agrupador,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = ag.financer_nature_id) AS nautreza_agrupador,
serv.description AS descricao_item,
c.v_status AS status_contrato

FROM contracts AS c 
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
INNER JOIN contract_items AS serv ON ag.id = serv.contract_configuration_billing_id AND serv.deleted = false

WHERE c.v_status IN ('Normal','Demonstração', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') AND v_stage = 'Aprovado'
AND c.company_place_id = 9