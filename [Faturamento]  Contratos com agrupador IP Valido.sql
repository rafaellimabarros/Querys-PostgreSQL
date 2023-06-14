SELECT
c.id AS cod_contrato,
p.name AS cliente,
c.amount AS valor_contrato,
(SELECT pl.title FROM service_products AS pl WHERE pl.id = serv.service_product_id) AS plano,
sp.service_code_provided AS cod_lista_servico,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = ag.financial_operation_id) AS operacao

FROM contracts AS c
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
INNER JOIN contract_items AS serv ON ag.id = serv.contract_configuration_billing_id AND serv.deleted = FALSE
INNER JOIN service_products AS sp ON sp.id = serv.service_product_id

WHERE c.v_status IN ('Normal','Demonstração', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') AND v_stage = 'Aprovado'
AND c.id IN 
	(
	SELECT
	c.id
	
	FROM contracts AS c
	INNER JOIN people AS p ON p.id = c.client_id
	INNER JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
	INNER JOIN contract_items AS serv ON ag.id = serv.contract_configuration_billing_id AND serv.deleted = FALSE
	INNER JOIN service_products AS sp ON sp.id = serv.service_product_id
	
	WHERE c.v_status IN ('Normal','Demonstração', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') AND v_stage = 'Aprovado'
	AND serv.service_product_id = 45
	)

