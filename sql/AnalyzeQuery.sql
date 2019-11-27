DECLARE @collect_date datetime2(3) = '2019-11-27 15:25'
SELECT
	start_time,
	MAX(collect_date) AS collect_date,
	session_id,
	host_name,
	program_name,
	wait_type,
	wait_resource,
	blocking_session_id,
	COUNT(*) AS wait_count,
	MAX(wait_time) AS max_wait_time,
	MAX(cpu_time) AS last_cpu_time,	
	MAX(total_elapsed_time) AS last_elapsed_time,
	object_name,
	text
FROM 
	[QueryInsight] 
WHERE 
	collect_date >= @collect_date
	and 
	wait_type IS NOT NULL
GROUP BY
	session_id,
	host_name,
	program_name,
	start_time,
	wait_type,
	wait_resource,
	blocking_session_id,
	object_name,
	text
ORDER BY
	start_time ASC,
	session_id ASC,
	collect_date ASC
OPTION (MAXDOP 1)


