SELECT
p.id AS cod_cliente,
p.name AS cliente,
date(pcii.created) AS data_descarte,
(SELECT cdm.title FROM crm_discart_motives AS cdm WHERE cdm.id = pcii.crm_discart_motive_id) AS motivo_descarte,
pcii.description AS descricao,
(SELECT p.name FROM people AS p WHERE p.id = pcii.responsible_id) AS reponsavel_descarte,
CASE WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
DATE(p.created) AS data_cadastro,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS endereco

FROM people_crm_information_interactions AS pcii
INNER JOIN people AS p on p.id = pcii.client_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = pcii.responsible_id

WHERE pcii.crm_discart_motive_id IS NOT NULL AND DATE(pcii.created) BETWEEN '2022-11-01' AND '2022-11-30'
AND pcii.situation NOT IN  (3,4) AND ppg.people_group_id IN (12,13,15)

ORDER BY pcii.created desc