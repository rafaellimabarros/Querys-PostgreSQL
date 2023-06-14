SELECT
pat.code AS codigo,
pat.title AS titulo,
pat.serial_number AS mac,
pat.tag_number AS etiqueta,
CASE WHEN pat.p_is_disponible = TRUE THEN 'Sim' ELSE 'Nao' END AS disponivel,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = pat.company_place_id ) AS empresa,
CASE WHEN pat.active = TRUE THEN 'Sim' ELSE 'Nao' END AS ativo,
(SELECT c.id FROM contracts AS c WHERE c.id = pat.contract_id) AS contrato_vinculado,
(SELECT p.name FROM people AS p WHERE p.id = pat.client_id)  AS cliente_vinculado,
pat.entry_invoice_note_id AS nota_fiscal_entrada,
pat.purchase_date AS data_compra,
pat.last_occurrence_description AS ultima_movimentacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = pat.created_by) AS usuario_criador,
pat.created AS data_criacao,
pat.modified AS data_ultimo_evento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = pat.modified_by) AS usuario_ultimo_evento,
CASE WHEN pat.deleted = TRUE THEN 'Sim' ELSE 'Nao' END AS excluido

FROM patrimonies AS pat

/*Tem que baixar e no Excel filtrar somente os duplicados*/