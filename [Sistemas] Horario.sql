SELECT
DATE(inv.created) AS data_emissao,
CONCAT(DATE_PART('hour',inv.created),':',DATE_PART('minute',inv.created),':',trunc(DATE_PART('seconds',inv.created))) AS horario