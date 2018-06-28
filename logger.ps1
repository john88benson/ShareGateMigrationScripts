#all logging settins are here on top
$dateTime = (Get-Date).toString("yyyyMMdd")
$migLogFile = "./logs/migrationLog-"+$dateTime+".log"
$proLogFile = "./logs/provisionLog-"+$dateTime+".log"
$logLevel = "DEBUG" # ("DEBUG","INFO","WARN","ERROR","FATAL")
$logSize = 1mb # 30kb
$logCount = 10
# end of settings

function Write-Log-Line {
    Param(
        [string]$Line,
        [string]$logType
    )
    if($logType -eq "migration"){
        $logFile = $migLogFile
    }
    if($logType -eq "provision"){
        $logFile = $proLogFile
    }
    if (!(Test-Path $logFile)) { 
        Write-Verbose "Creating $logFile." 
        $NewLogFile = New-Item $logFile -Force -ItemType File 
        } 
    Add-Content $logFile -Value $Line
    Write-Host $Line
}

# http://stackoverflow.com/a/38738942
Function Write-Log {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$True)]
    [string]
    $Message,
    
    [Parameter(Mandatory=$False)]
    [String]
    $Level = "DEBUG",

    [Parameter(Mandatory=$False)]
    [String]
    $Type
    )

    $levels = ("DEBUG","INFO","WARN","ERROR","FATAL")
    $logLevelPos = [array]::IndexOf($levels, $logLevel)
    $levelPos = [array]::IndexOf($levels, $Level)
    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss:fff")

    if ($logLevelPos -lt 0){
        Write-Log-Line "$Stamp ERROR Wrong logLevel configuration [$logLevel]" $Type
    }
    
    if ($levelPos -lt 0){
        Write-Log-Line "$Stamp ERROR Wrong log level parameter [$Level]" $Type
    }

    # if level parameter is wrong or configuration is wrong I still want to see the 
    # message in log
    if ($levelPos -lt $logLevelPos -and $levelPos -ge 0 -and $logLevelPos -ge 0){
        return
    }

    $Line = "$Stamp $Level $Message"
    Write-Log-Line $Line $Type
}
