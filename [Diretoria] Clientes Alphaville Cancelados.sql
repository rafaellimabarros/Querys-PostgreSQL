SELECT
c.id AS cod_contrato,
p.name AS Cliente,
c.v_status AS status_contrato,
c.cancellation_date AS data_cancelamento,
c.cancellation_motive AS motivo_cancelamento,
p.neighborhood AS bairro,
p.street AS rua,
p.address_complement AS complemento,
p.address_reference AS referencia

FROM people AS p
INNER JOIN contracts AS c ON c.client_id = p.id

WHERE c.v_status = 'Cancelado'
AND c.cancellation_date BETWEEN '2023-01-01' AND '2023-02-10'
and p.neighborhood LIKE '%Pires%'
AND p.street IN 
(
'Alphaville Eusebio',
'APHAVILLE EUSEBIO',
'Avenida Nova do Contorno',
'CE 040',
'CE 040 ',
'CE 040 Km 08',
'CE 040 Km 22',
'Ce 040 km 22 2131',
'ROD CE 040',
'Rod CE 040 KM22',
'ROD CE 040, KM 22',
'Rod ce 040 Km 6',
'Rodovia 040 Km 22/Quadra L1 Lot 6',
'RODOVIA CE 040 / KM 22',
'RODOVIA CE 040 KM 22 ALPHAVILLE',
'RODOVIA CE 040 KM 22 RUA ITALIA U1-20',
'Rodovia CE-040 KM 22',
'Rodovia CE-040- s/n Quilômetro 22',
'Rodoviária CE 040',
'Rodovia CE-040',
'RUA APHAVILLE ',
'rua austra ',
'Rua Austria Alphaville eusébio',
'Rua Áustria',
'Rua Belgica',
'Rua DB 1 LT 1',
'Rua Espanhola',
'Rua espanha',
'Rua Italia',
'Rua Itália',
'RUA ITALIA',
'Rua Italia Quadra Z 1 Lot. 7',
'Rua Noruega',
'Rua Luxemburgo ',
'Rua Severino Batista da Costa',
'RUA SUIÇA',
'Rod CE 040'
)