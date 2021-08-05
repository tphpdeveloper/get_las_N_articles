select x, burst_id, blank_id, camp_id, created_at
from (
         select
                t1.*,
				# least - get min value from list params
                if(@gr = burst_id, @i := @i + 1, @i := 1 + least(@gr := burst_id, 0)) x
         from (
                  select bst.id        as burst_id,
                         bc.id         as blank_id,
                         c.campaign_id AS camp_id,
                         c.created_at
                  from bursts as bst
                           join blank_campaigns bc on bst.id = bc.burst_id
                           join campaigns c on bc.campaign_id = c.id
                  where bst.client_id = 16
                    and c.created_at BETWEEN NOW() - INTERVAL 6 HOUR - INTERVAL 90 DAY AND NOW() - INTERVAL 6 HOUR
                  order by burst_id
                  ) t1,
              (select @i := 0, @gr := 0) t2
         order by burst_id, created_at DESC
     ) t
where x <= 3;
