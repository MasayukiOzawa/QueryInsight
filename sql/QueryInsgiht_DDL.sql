DROP TABLE IF EXISTS [QueryInsight]
GO

CREATE TABLE [dbo].[QueryInsight](
	[collect_date] [datetime2](3) NOT NULL,
	[session_id] [smallint] NOT NULL,
	[status] [nvarchar](30) NULL,
	[start_time] [datetime2](3) NULL,
	[connect_database_name] [nvarchar](128) NULL,
	[request_database_name] [nvarchar](128) NULL,
	[login_name] [nvarchar](128) NOT NULL,
	[host_name] [nvarchar](128) NULL,
	[program_name] [nvarchar](128) NULL,
	[blocking_session_id] [smallint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[last_wait_type] [nvarchar](60) NULL,
	[wait_resource] [nvarchar](256) NULL,
	[wait_time] [int] NULL,
	[cpu_time] [int] NULL,
	[total_elapsed_time] [int] NULL,
	[object_name] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[sql_handle] [varbinary](64) NULL,
	[query_hash] [binary](8) NULL
)
GO
CREATE CLUSTERED INDEX CIX_QueryInsight ON QueryInsight([collect_date], [session_id])
GO

CREATE NONCLUSTERED INDEX NCIX_QueryInsight_session_id ON QueryInsight([session_id],[start_time])
GO

