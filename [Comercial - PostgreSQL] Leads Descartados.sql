SELECT DISTINCT ON (pci.person_id)
date(pci.crm_discard_date) AS data_descarte,
p.id AS cod_cliente,
p.name AS cliente,
p.neighborhood AS bairro,
p.city AS cidade,
p.cell_phone_1 AS celular,
p.phone AS telefone,
(SELECT p.name FROM people AS p WHERE p.id = pci.proprietary_id) AS responsavel_descarte,
(SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) AS equipe,
(SELECT cor.title FROM crm_opportunity_reasons AS cor WHERE cor.id = pci.crm_opportunity_reason_id) AS motivo_descarte

FROM people_crm_informations AS pci
LEFT JOIN people AS p ON p.id = pci.person_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = pci.proprietary_id

WHERE DATE(pci.crm_discard_date) BETWEEN '2022-10-01' AND '2022-11-30'
AND pci.crm_discard_date IS NOT NULL 
AND ppg.people_group_id IN (12,13,15,19)