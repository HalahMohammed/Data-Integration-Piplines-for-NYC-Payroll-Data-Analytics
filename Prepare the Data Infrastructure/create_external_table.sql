
USE dbo;
GO

-- 1. Create file format
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

-- 2. Create data source (REPLACE WITH YOUR VALUES)
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'payroll_source')
CREATE EXTERNAL DATA SOURCE payroll_source
WITH (
    LOCATION = 'abfss://filedatalakesynapse@datalakesynapse100.dfs.core.windows.net' 
)
GO

-- 3. Create external table
CREATE EXTERNAL TABLE [dbo].[NYC_Payroll_Summary](
    [FiscalYear] [int] NULL,
    [AgencyName] [varchar](50) NULL,
    [TotalPaid] [float] NULL
)
WITH (
    LOCATION = 'dirstaging/**',  -- Folder path in your container
    DATA_SOURCE = [payroll_source],       -- Your data source name
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
GO
SELECT top 10 * from  [dbo].[NYC_Payroll_Summary]
