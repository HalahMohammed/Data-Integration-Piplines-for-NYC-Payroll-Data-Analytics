-- Create the External File Format
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
WITH ( 
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        USE_TYPE_DEFAULT = FALSE
    )
)
GO

-- Create the External Data Source WITHOUT credential (for public access or managed identity)
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'defs_de2_dfs_core_windows_net')
CREATE EXTERNAL DATA SOURCE [defs_de2_dfs_core_windows_net]
WITH (
    LOCATION = 'abfss://defs@de2.dfs.core.windows.net'
    -- No credential needed if using public access or Synapse workspace managed identity
)
GO

-- Create the External Table
CREATE EXTERNAL TABLE [dbo].[NYC_Payroll_Summary](
    [FiscalYear] [int] NULL,
    [AgencyName] [varchar](50) NULL,
    [TotalPaid] [float] NULL
)
WITH (
    LOCATION = '/',
    DATA_SOURCE = [defs_de2_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
GO

-- Check if it was created successfully
SELECT TOP 10 * FROM [dbo].[NYC_Payroll_Summary]
GO
