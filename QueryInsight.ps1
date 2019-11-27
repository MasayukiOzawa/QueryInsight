using namespace System.Data
using namespace System.Data.SqlClient

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String]$Source,
    [Parameter(Mandatory = $true)]
    [String]$Store,
    [String]$StoreTableName = "QueryInsight",
    [int]$FlushInterval = 60
)
$ErrorActionPreference = "Stop"

$sqlPath = Join-Path $PSScriptRoot  "sql"
$collectQuery = Get-Content (Join-Path $sqlPath "CollectQuery.sql")

$souceCon = New-Object SqlConnection($Source)
$storeCon = New-Object SqlConnection($Store)

$cmd = $souceCon.CreateCommand()
$cmd.CommandText = $collectQuery
$cmd.CommandTimeout = 90

$da = New-Object SqlDataAdapter
$dt = New-Object DataTable
$da.SelectCommand = $cmd

$sqlBulk = New-Object SqlBulkCopy($storeCon)
$sqlBulk.DestinationTableName = $StoreTableName
$sqlBulk.BulkCopyTimeout = 30

$sendCounter = 1
Write-Host ("{0} : Query Collect Start." -f (Get-Date -Format "G"))
$errorCount = 0
try {
    $storeCon.Open()
    $souceCon.Open()

    While ($true) {
        try {
            [void]$da.Fill($dt)
            if ($sendCounter++ -ge $FlushInterval) {
                [void]$sqlBulk.WriteToServer($dt)
                Write-Host ("{0} : Flushed to Data Store. ({1} Rows)" -f (Get-Date -Format "G"), $dt.Rows.Count)
                $dt.Clear()
                $sendCounter = 1
            }
            $errorCount = 0
            Start-Sleep -Seconds 1
        }
        catch {
            $errorCount ++
            Write-Host ("{0} : Error Count : {1} : {2}" -f (Get-Date -Format "G"), $errorCount, $Error[0])
            if ($errorCount -ge 5) {
                Break
            }
        }
    }
}
catch {
    Write-Host ("{0} : {1}" -f (Get-Date -Format "G"), $Error[0])
 } 
finally {
    [void]$sqlBulk.WriteToServer($dt)
    Write-Host ("{0} : Flushed to Data Store. (End) ({1} Rows)" -f (Get-Date -Format "G"), $dt.Rows.Count)
    Write-Host ("{0} : Query Collect End." -f (Get-Date -Format "G"))
    $souce.Close()
    $storeCon.Close()
}    
