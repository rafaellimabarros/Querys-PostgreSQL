SELECT
p.name AS Cliente,
p.city AS cidade,
c.beginning_date AS data_inicio,
ac.user AS PPPOE,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS Plano,
c.amount AS valor,
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id) AS Ponto_de_Acesso,
aip.ip AS IP2,
CASE WHEN ac.ip_type = 1 THEN 'IP Fixo' WHEN ac.ip_type != 1 THEN 'Pelo CE' END AS tipo_IP,
c.v_status AS status_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato

FROM people AS p
INNER JOIN contracts AS c ON c.client_id = p.id
INNER JOIN authentication_contracts AS ac ON ac.contract_id = c.id
LEFT JOIN authentication_ips AS aip ON aip.id = ac.ip_authentication_id

WHERE aip.ip LIKE '%168.196%'
