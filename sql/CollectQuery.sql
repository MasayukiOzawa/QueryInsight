SET NOCOUNT ON;

SELECT SYSDATETIME() AS collect_date,
	s.session_id,
	s.status,
	r.start_time,
	DB_NAME(s.database_id) AS connect_database_name,
	DB_NAME(r.database_id) AS request_database_name,
	s.login_name,
	s.host_name,
	s.program_name,
	r.blocking_session_id,
	r.wait_type,
	r.last_wait_type,
	r.wait_resource,
	r.wait_time,
	r.cpu_time,
	r.total_elapsed_time,
	OBJECT_NAME(p.objectid, p.dbid) AS object_name,
	SUBSTRING(t.TEXT, r.statement_start_offset / 2 + 1, (
			CASE 
				WHEN r.statement_end_offset = - 1
					THEN LEN(CONVERT(NVARCHAR(max), t.TEXT)) * 2
				ELSE r.statement_end_offset
				END - r.statement_start_offset
			) / 2) AS TEXT,
	r.sql_handle,
	r.query_hash
FROM sys.dm_exec_sessions s WITH (NOLOCK)
LEFT JOIN sys.dm_exec_requests r WITH (NOLOCK) ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) t
OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) p
WHERE s.session_id <> @@SPID
	AND r.total_elapsed_time >= 5
	AND s.database_id <> 0
	AND s.host_name IS NOT NULL
ORDER BY s.session_id ASC
OPTION (MAXDOP 1)
