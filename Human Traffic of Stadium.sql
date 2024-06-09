with calculations as (
select s.*
,case when people > 99 then true else false end as people_greater_than_99
,case when lead (people,1) over (order by id) > 99 then true else false end as next_people_greater_than_99
,case when lead (people,2) over (order by id) > 99 then true else false end as next_people2_greater_than_99
,case when lag (people,1) over (order by id) > 99 then true else false end as previous_people_greater_than_99
,case when lag(people,2) over (order by id) > 99 then true else false end as previous_people2_greater_than_99
from stadium s
)

select id
,visit_date
,people
from calculations
where (people_greater_than_99 = 1 and next_people_greater_than_99 = 1 and next_people2_greater_than_99 = 1)
or (people_greater_than_99 = 1 and previous_people_greater_than_99 = 1 and previous_people2_greater_than_99 = 1)
or (people_greater_than_99 = 1 and next_people_greater_than_99 = 1 and previous_people_greater_than_99 = 1)
order by id asc
;

