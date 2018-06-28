. .\logger.ps1
function MigrateScriptTest {
    Param(
        [string]$sourceURL,
        [string]$listURL,
        [string]$destURL,
        [string]$listStub        
    )
    $sourceURL = [uri]::EscapeUriString($sourceURL)
    $listURL = [uri]::EscapeUriString($listURL)
    $destURL = [uri]::EscapeUriString($destURL)
    Write-Host("Source: " + $sourceURL);
    Write-Host("List: " + $listURL);
    Write-Host("Destination: " + $destURL);
    Write-Host("Stub: " + $listStub);
}
function MigrateScript {
    Param(
        [string]$sourceURL,
        [string]$listURL,
        [string]$destURL,
        [string]$listStub        
    )
    $sourceURL = [uri]::EscapeUriString($sourceURL)
    $listURL = [uri]::EscapeUriString($listURL)
    $destURL = [uri]::EscapeUriString($destURL)
    Write-Host("Source: " + $sourceURL);
    Write-Host("List: " + $listURL);
    Write-Host("Destination: " + $destURL);
    Write-Host("Stub: " + $listStub);

    $sgSrcSite = Connect-Site -Url $sourceURL;
    $sgSrcList = Get-List -Site $sgSrcSite -name $listStub;
    $sgDestSite = Connect-Site -Url $destURL;
    $sgDestList = Get-List -Site $sgDestSite -Name $listStub;

    $result = Copy-Content -SourceList $sgSrcList -DestinationList $sgDestList;
    
    $log = "Results $($result.Result)";
    Write-Log $log "INFO" "migration";
}
    