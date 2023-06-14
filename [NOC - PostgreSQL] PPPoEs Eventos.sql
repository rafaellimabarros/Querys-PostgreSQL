SELECT
ac.contract_id AS cod_contrato,
ac.user AS ppoe,
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id) AS ponto_acesso,
ac.authentication_access_point_id AS id_ponto_acesso,
ace.description AS evento,
ace.date AS data_evento

FROM authentication_contracts AS ac
INNER JOIN authentication_contract_events AS ace ON ace.authentication_contract_id = ac.id

WHERE ac.authentication_access_point_id = 13 AND ace.description LIKE 'Tipo de IP alterado de "IP Fixo" para "Pelo CE"'
AND ace.date BETWEEN '2022-07-14' AND '2022-07-15'

ORDER BY ace.date desc