SELECT
prof.code AS cod_perfil,
prof.name AS perfil,
mc.module_id,
(SELECT modu.name FROM modules AS modu WHERE modu.id = mc.module_id) AS modulo,
control.id AS control_id,
control.name AS permissao,
control.controller,
act.id AS act_id,
act.action AS acao,
(CONCAT((SELECT modu.name FROM modules AS modu WHERE modu.id = mc.module_id),' >',control.name, ' >')) AS concate

FROM profiles AS prof
inner JOIN profiles_permissions AS pp ON pp.profile_id = prof.id
inner JOIN controllers AS control ON control.id = pp.controller
inner JOIN actions AS act ON act.id = pp.action
inner JOIN modules_controllers AS mc ON mc.controller = control.id

WHERE prof.name = 'Auditoria Sistemas' AND prof.active = TRUE
