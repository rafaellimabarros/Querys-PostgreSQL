SELECT 
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS produto,
sp.code AS codigo,
TRUNC (SUM (ini.units),2) AS total_unidades,
(SELECT um.title FROM units_measures AS um WHERE um.id = sp.first_unit) AS medida,
TRUNC (AVG (ini.unit_amount),2) media_valor,
TRUNC (MAX (ini.unit_amount),2) Valor_maximo,
MIN (ini.unit_amount) valor_minimo

FROM invoice_notes AS notas 
INNER JOIN invoice_note_items AS ini ON notas.id = ini.invoice_note_id
INNER JOIN service_products AS sp ON ini.service_product_id = sp.id

WHERE notas.financial_operation_id IN (16,2)
AND notas.created BETWEEN '2022-11-01' AND '2022-11-30'
AND ini.units <> 0 

GROUP BY ini.service_product_id,sp.code,medida