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

-- Create the External Data Source
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'dirstaging_demostoarge22_dfs_core_windows_net')
CREATE EXTERNAL DATA SOURCE [dirstaging_demostoarge22_dfs_core_windows_net]
WITH (
    LOCATION = 'abfss://dirstaging@demostoarge22.dfs.core.windows.net'
    -- No credential needed if using public access or Synapse workspace managed identity
)
GO

-- Create the External Table
CREATE EXTERNAL TABLE [dbo].[NYC_Payroll_Summary2](
    [FiscalYear] [int] NULL,
    [AgencyName] [varchar](50) NULL,
    [TotalPaid] [float] NULL
)
WITH (
    LOCATION = '/dirstaging',
    DATA_SOURCE = [dirstaging_demostoarge22_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
GO
