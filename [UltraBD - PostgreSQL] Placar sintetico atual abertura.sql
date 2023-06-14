SELECT  
            c.id AS Contrato,
            p.name AS Cliente,
            c.v_status AS Status_contrato,
            COUNT(p.id) AS Total,
            count(case ai.origin_team_id when 1006 then 1 else null END) AS CallCenter,
            count(case ai.origin_sector_area_id when 6 then 1 else null END) AS Gestao_de_OS,
            count(case ai.origin_team_id when 1004 then 1 else null END) AS Faturamento,
            count(case ai.origin_team_id when 1010 then 1 else null END) AS CS,
            count(case ai.origin_team_id when 1 then 1 else null END) AS Administrativo_Lojas,
            count(case ai.origin_team_id when 1040 then 1 else null END) AS Supervisores_callcenter,
            count(case ai.origin_team_id when 1037 then 1 else null END) AS Suporte_Avancado,
            count(case ai.origin_team_id when 1042 then 1 else null END) AS Belluno,
            count(case ai.origin_team_id when 1005 then 1 else null END) AS Cobranca,
            count(case ai.origin_team_id when 8 then 1 else null END) AS Comercial,
            count(case ai.origin_team_id when 5 then 1 else null END) AS NOC,
            count(case ai.origin_team_id when 2 then 1 else null END) AS Financeiro,
            count(case ai.origin_team_id when 1043 then 1 else null END) AS Retirada_de_eqp

            FROM people AS p
            INNER JOIN contracts AS c ON p.id = c.client_id
            INNER JOIN assignment_incidents AS ai ON ai.client_id = c.client_id
            
            WHERE c.v_status != 'Cancelado' AND c.contract_type_id != 4 AND c.id NOT IN(32226,53320,54986,56095,58387,59883,60278) AND ai.incident_status_id != 8 AND ai.beginning_service_date > CURDATE() - INTERVAL '7' DAY
            GROUP BY Contrato,Cliente,Status_contrato
            HAVING COUNT(p.id) >= '3'
            ORDER BY Total 