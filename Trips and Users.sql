/*Table: Trips

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| client_id   | int      |
| driver_id   | int      |
| city_id     | int      |
| status      | enum     |
| request_at  | date     |     
+-------------+----------+
id is the primary key (column with unique values) for this table.
The table holds all taxi trips. Each trip has a unique id, while client_id and driver_id are foreign keys to the users_id at the Users table.
Status is an ENUM (category) type of ('completed', 'cancelled_by_driver', 'cancelled_by_client').
 

Table: Users

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| users_id    | int      |
| banned      | enum     |
| role        | enum     |
+-------------+----------+
users_id is the primary key (column with unique values) for this table.
The table holds all users. Each user has a unique users_id, and role is an ENUM type of ('client', 'driver', 'partner').
banned is an ENUM (category) type of ('Yes', 'No').
 

The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

Write a solution to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03". Round Cancellation Rate to two decimal points.

Return the result table in any order.
*/
with aggregations as (
    select t.id
    ,t.request_at as Day
    ,u.banned as client_banned
    ,u2.banned as driver_banned
    ,t.status
    from trips t
    left join users u
    on t.client_id = u.users_id
    left join users u2
    on t.driver_id = u2.users_id
    where u.banned = 'No' and u2.banned = 'No' and t.request_at between "2013-10-01" and "2013-10-03"
),
calculations as (
    select Day
    ,(sum(case when status = 'cancelled_by_driver' then 1 else 0 end)+sum(case when status = 'cancelled_by_client' then 1 else 0 end))/(sum(case when status = 'cancelled_by_driver' then 1 else 0 end)+sum(case when status = 'cancelled_by_client' then 1 else 0 end)+sum(case when status = 'completed' then 1 else 0 end)) as Cancellation_Rate
    from aggregations
    group by 1
)
select Day
,round(Cancellation_Rate,2) as 'Cancellation Rate'
from calculations
;