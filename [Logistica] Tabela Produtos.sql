SELECT
p.id AS cod_responsavel,
(SELECT P.name FROM people AS p WHERE p.id = pe.person_id) AS responsavel,
CASE WHEN v.active = FALSE THEN 'Inativo' ELSE 'Ativo' END AS status_usuario,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = pe.service_product_id) AS produto,
sp.code AS codigo_produto,
(SELECT um.title FROM units_measures AS um WHERE um.id = sp.first_unit) AS medida,

SUM(CASE WHEN pe.signal = 1
         THEN pe.units Else 0 End) AS entrada,
    SUM(CASE WHEN pe.signal = 2
         THEN pe.units Else 0 End) AS saida,
     SUM(CASE When pe.signal = 1
         THEN pe.units Else 0 END) - SUM(CASE WHEN pe.signal = 2
         THEN pe.units Else 0 END) AS com_colaborador,

 TRUNC( AVG (CASE WHEN pe.signal = 2 AND ai.protocol IS NOT NULL
         THEN pe.units END ),2) AS  media_consumo_protocolo
      

FROM person_product_movimentations AS pe  

LEFT JOIN
	invoice_notes AS inv ON pe.invoice_note_id = inv.id
INNER JOIN
	people AS p ON p.id = pe.person_id
LEFT JOIN
	v_users AS v ON p.name = v.name 
LEFT JOIN
	assignments AS a ON a.id = pe.assignment_id
LEFT JOIN
	assignment_incidents AS ai ON a.id = ai.assignment_id
LEFT JOIN
	service_products AS sp ON  pe.service_product_id = sp.id

WHERE 
DATE(pe.created) BETWEEN '2021-01-01' AND DATE(curdate())
AND v.team_id IN (1,1003,1011)

GROUP BY pe.person_id,pe.service_product_id,v.team_id,sp.code, sp.first_unit, p.id, v.active 