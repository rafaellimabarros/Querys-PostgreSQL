SELECT DISTINCT ON (c.id)
p.id AS cod_cliente,
p.name AS cliente,
pa.city AS cidade,
pa.neighborhood AS bairro,
pa.code_city_id AS cod_IBGE,
pa.postal_code AS CEP,
c.created AS data_cadastro,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = pa.created_by) AS operador_cadastro

FROM contracts AS c
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN people_addresses AS pa ON pa.person_id = p.id

WHERE DATE(c.created) BETWEEN '2022-08-01' AND '2022-08-31'
AND (pa.city = 'Acarape' AND pa.code_city_id != 2300150
OR pa.city = 'ACARAPE' AND pa.code_city_id = 2300150
OR pa.city = 'aquiraz' AND pa.code_city_id = 2301000
OR pa.city = 'Aquiraz' AND pa.code_city_id != 2301000
OR pa.city = 'AQUIRAZ' AND pa.code_city_id = 2301000
OR pa.city = 'aracati' AND pa.code_city_id != 2301109
OR pa.city = 'ARACATI' AND pa.code_city_id = 2301109
OR pa.city = 'Aracoiaba' AND pa.code_city_id != 2301208
OR pa.city = 'ARACOIABA' AND pa.code_city_id = 2301208
OR pa.city = 'Banabuiú' AND pa.code_city_id != 2301851
OR pa.city = 'BANABUIÚ' AND pa.code_city_id = 2301851
OR pa.city = 'Barreira' AND pa.code_city_id != 2301950
OR pa.city = 'BARREIRA' AND pa.code_city_id = 2301950
OR pa.city = 'Beberibe' AND pa.code_city_id != 2302206
OR pa.city = 'BEBERIBE' AND pa.code_city_id = 2302206
OR pa.city = 'Capistrano' AND pa.code_city_id != 2302909
OR pa.city = 'CAPISTRANO' AND pa.code_city_id = 2302909
OR pa.city = 'Cascavel' AND pa.code_city_id != 2303501
OR pa.city = 'CASCAVEL' AND pa.code_city_id = 2303501
OR pa.city = 'Caucaia' AND pa.code_city_id != 2303709
OR pa.city = 'CAUCAIA' AND pa.code_city_id = 2303709
OR pa.city = 'Choró' AND pa.code_city_id != 2303931
OR pa.city = 'CHORO' AND pa.code_city_id = 2303931
OR pa.city = 'Chorozinho' AND pa.code_city_id != 2303956
OR pa.city = 'CHOROZINHO' AND pa.code_city_id = 2303956
OR pa.city = 'CHOROZINHO ' AND pa.code_city_id = 2303956
OR pa.city = 'Eusébio' AND pa.code_city_id != 2304285
OR pa.city = 'EUSEBIO' AND pa.code_city_id = 2304285
OR pa.city = 'EUSEBIO ' AND pa.code_city_id = 2304285
OR pa.city = 'EUSÉBIO ' AND pa.code_city_id = 2304285
OR pa.city = 'EUSUBIO' AND pa.code_city_id = 2304285
OR pa.city = 'Fortaleza' AND pa.code_city_id != 2304400
OR pa.city = 'FORTALEZA' AND pa.code_city_id = 2304400
OR pa.city = 'FORTALEZA ' AND pa.code_city_id = 2304400
OR pa.city = 'FORTALEZA  ' AND pa.code_city_id = 2304400
OR pa.city = 'Guaiúba' AND pa.code_city_id != 2304954
OR pa.city = 'GUAIUBA' AND pa.code_city_id = 2304954
OR pa.city = 'Horizonte' AND pa.code_city_id != 2305233
OR pa.city = 'HORIZONTE' AND pa.code_city_id = 2305233
OR pa.city = 'Itaitinga' AND pa.code_city_id != 2306256
OR pa.city = 'ITAITINGA' AND pa.code_city_id = 2306256
OR pa.city = 'ITAITINGA ' AND pa.code_city_id = 2306256
OR pa.city = 'Maracanaú' AND pa.code_city_id != 2307650
OR pa.city = 'Maracanau' AND pa.code_city_id != 2307650
OR pa.city = 'MARACANAU' AND pa.code_city_id = 2307650
OR pa.city = 'Maracana' AND pa.code_city_id = 2307650
OR pa.city = 'MARACANAÚ' AND pa.code_city_id = 2307650
OR pa.city = 'maracanau' AND pa.code_city_id = 2307650
OR pa.city = 'Maranguape' AND pa.code_city_id != 2307700
OR pa.city = 'MARANGUAPE' AND pa.code_city_id = 2307700
OR pa.city = 'Pacajus' AND pa.code_city_id != 2309607
OR pa.city = 'PACAJUS' AND pa.code_city_id = 2309607
OR pa.city = 'Pacatuba' AND pa.code_city_id != 2309706
OR pa.city = 'PACATUBA' AND pa.code_city_id = 2309706
OR pa.city = 'PACATUBA ' AND pa.code_city_id = 2309706
OR pa.city = 'pacatuba - ce' AND pa.code_city_id = 2309706
OR pa.city = 'Pindoretama' AND pa.code_city_id != 2310852
OR pa.city = 'PINDORETAMA' AND pa.code_city_id = 2304285 
OR pa.city = 'PINDORETAMA ' AND pa.code_city_id = 2304285 
OR pa.city = 'Redenção' AND pa.code_city_id != 2311603
OR pa.city = 'Redencao' AND pa.code_city_id = 2311603
OR pa.city = 'REDENCAO' AND pa.code_city_id = 2311603
OR pa.city = 'REDENÇAO' AND pa.code_city_id = 2311603
OR pa.city = 'REDENÇÃO' AND pa.code_city_id = 2311603

OR pa.city = 'genibau'
OR pa.city = 'Genibau'
OR pa.city LIKE '%diogo%'
OR pa.city LIKE '%barra%'
OR pa.city LIKE '%Barra%'
OR pa.city = 'iguape'
OR pa.city = 'tapera'
OR pa.city = 'caponga'
OR pa.city = 'Pacatuba-ce'
)