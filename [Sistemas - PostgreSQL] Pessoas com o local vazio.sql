SELECT
p.id AS id_people,
p.name AS nome,
p.city AS cidade,
p.neighborhood AS bairro,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = p.company_place_id) AS empresa

FROM people AS p

WHERE p.company_place_id IS null