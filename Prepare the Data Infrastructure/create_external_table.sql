IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 FIRST_ROW = 2,  -- Skips header row
			 USE_TYPE_DEFAULT = FALSE
			))
GO

-- Updated: container22 instead of dirstaging
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'container22_demostoarge22_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [container22_demostoarge22_dfs_core_windows_net] 
	WITH (
		-- Changed: container22 instead of dirstaging
		LOCATION = 'abfss://container22@demostoarge22.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE [dbo].[NYC_Payroll_Summary] (
	[AgencyName] nvarchar(4000),
	[FiscalYear] bigint,
	[TotalPaid] float
	)
	WITH (
	LOCATION = '/',  -- Root of container22
	DATA_SOURCE = [container22_demostoarge22_dfs_core_windows_net],  -- Updated
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO
