SELECT
p.id AS cod_cliente,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS endereco,
date(pci.created) AS data_cadastro,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = pci.modified_by) AS reponsavel_descarte

FROM people_crm_informations AS pci
INNER JOIN people AS p ON p.id = pci.person_id
LEFT JOIN contracts AS c ON c.client_id = p.id

WHERE p.situation IN (5,7) AND p.deleted = TRUE

ORDER BY p.name asc