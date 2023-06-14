SELECT
notas.id AS id_nota,
notas.document_number AS documento,
notas.client_name AS nome_cliente,
notas.entry_date AS data_emissao,
notas.total_amount_liquid,
notas.return_motive,
notas.print_url,
notas.xml_url


FROM invoice_notes AS notas

WHERE notas.document_number = 37142
AND notas.client_name = 'CARTORIO FACUNDO' 