SELECT
p.id AS cod_cliente,
p.name AS nome,
p.phone AS telefone,
p.cell_phone_1 AS celular,
date(pcii.created) AS data_descarte,
(SELECT cdm.title FROM crm_discart_motives AS cdm WHERE cdm.id = pcii.crm_discart_motive_id) AS motivo_descarte,
pcii.description AS descricao,
(SELECT p.name FROM people AS p WHERE p.id = pcii.responsible_id) AS reponsavel_descarte,
CASE WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
CASE WHEN pci.crm_form_id IS NULL THEN 'Em branco' ELSE (SELECT cf.title FROM crm_forms AS cf WHERE cf.id = pci.crm_form_id) END as forma_de_contato,
CASE WHEN pci.crm_contact_origin_id IS NULL THEN 'Em branco' ELSE (SELECT cco.title FROM crm_contact_origins AS cco WHERE cco.id = pci.crm_contact_origin_id) END AS origem_contato,
DATE(p.created) AS data_cadastro,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS endereco

FROM people_crm_information_interactions AS pcii
INNER JOIN people AS p on p.id = pcii.client_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = pcii.responsible_id
LEFT JOIN people_crm_informations AS pci ON pci.person_id = p.id

WHERE pcii.crm_discart_motive_id IS NOT NULL AND DATE(pcii.created) BETWEEN '2022-09-01' AND '2022-09-30'
AND pcii.situation NOT IN  (3,4)

ORDER BY pcii.created desc