SELECT
p.id AS cod_pessoa,
c.id AS cod_contato,
p.name AS cliente,
p.city AS cidade,
p.neighborhood AS bairro,
(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
c.v_status AS status_contrato,
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id) AS ponto_de_acesso,
ac.user AS pppoe

FROM contracts AS c
INNER JOIN authentication_contracts AS ac ON ac.contract_id = c.id
INNER JOIN people AS p ON p.id = c.client_id