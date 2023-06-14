SELECT
p.id AS cod_cliente,
p.name AS cliente,
p.city AS cidade,
p.neighborhood AS bairro,
c.id AS cod_contrato,
c.v_status AS status_contrato,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = p.created_by) AS criador

FROM people AS p
INNER JOIN contracts AS c ON c.client_id = p.id
INNER JOIN authentication_contracts AS ac ON ac.contract_id = c.id

WHERE 
-- c.v_status IN ('Cancelado','Encerrado')
p.city NOT IN 
(
'Aquiraz',
'Acarape',
'Aracati',
'Aracoiaba',
'Banabuiú',
'Barreira',
'Beberibe',
'Capistrano',
'Cariré',
'Cascavel',
'Caucaia',
'Choró',
'Chorozinho',
'Eusébio',
'Fortaleza',
'Fortim',
'Guaiúba',
'Horizonte',
'Itaitinga',
'Juazeiro do Norte',
'Limoeiro do Norte',
'Maracanaú',
'Maranguape',
'Massapê',
'Pacajus',
'Pacatuba',
'Pindoretama',
'Redenção',
'Salvador',
'Solonópole'
)