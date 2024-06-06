DELIMITER //
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  RETURN (
SELECT salary
from (
    select distinct(salary)
    ,dense_rank() over  (order by salary desc) as rnk
    from rh.employee
) as ranked_salaries
where rnk = N
  );
END