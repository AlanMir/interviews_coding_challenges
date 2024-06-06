with cte as (
select d.name as Department
,e.name as Employee
,e.salary as Salary
,dense_rank() over (partition by d.name order by salary desc) as row_id_desc
from employee e
left join department d
on e.departmentid = d.id
)
select Department
,Employee
,Salary
from cte
where row_id_desc <=3
;