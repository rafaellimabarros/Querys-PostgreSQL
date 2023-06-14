SELECT 
p.id AS cod_cliente,
c.id AS cod_contrato,
p.name AS cliente,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo_documento,
p.tx_id AS documento,
c.v_status AS status_contrato,
c.beginning_date AS data_ativacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = c.created_by) AS responsavel_cadastro,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
p.postal_code AS cep,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS logradouro,
p.number AS numero,
p.address_complement AS complemento,
p.state AS estado

FROM people AS p
INNER JOIN contracts AS c ON c.client_id = p.id

WHERE c.beginning_date <= '2022-07-31'
and c.v_status IN ('Normal','Demonstra├º├úo', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') 
AND v_stage = 'Aprovado'
OR (
		c.beginning_date <= '2022-07-31'
		AND c.id IN (SELECT c.id FROM contracts AS c WHERE c.cancellation_date > '2022-07-31')
	)
