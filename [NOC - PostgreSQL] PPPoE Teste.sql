SELECT
c.id AS id_contrato,
p.name AS nome,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS Plano,
c.v_status AS status_contrato,
ac.user AS conexao,
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id) AS ponto_de_Acesso,
ac.created AS data_criacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ac.created_by) AS usuario_criador,
ac.modified AS ultima_data_modificacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = ac.modified_by) AS ultimo_usuario_modificador

FROM people AS p
INNER JOIN contracts AS c ON c.client_id = p.id
INNER JOIN authentication_contracts AS ac ON ac.contract_id = c.id

WHERE ac.user LIKE '%teste%'