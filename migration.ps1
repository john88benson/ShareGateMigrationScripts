. .\logger.ps1
. .\credentials.ps1
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
    
    $encpasswordSrc = convertto-securestring -String $passSrc -AsPlainText -Force
    $encpasswordDest = convertto-securestring -String $passDest -AsPlainText -Force

    $credentialSrc = new-object -typename System.Management.Automation.PSCredential -argumentlist $userSrc, $encpasswordSrc
    $credentialDest =  new-object -typename System.Management.Automation.PSCredential -argumentlist $userDest, $encpasswordDest

    $sgSrcSite = Connect-Site -Url $sourceURL -Credential $credentialSrc;
    Write-Host("SrcSite "+ $sgSrcSite)
    $sgSrcList = Get-List -Site $sgSrcSite -name $listStub;
    Write-Host("SrcList "+ $sgSrcList)
    $sgDestSite = Connect-Site -Url $destURL -Credential $credentialDest;
    Write-Host("DestSite "+ $sgDestSite)
    $sgDestList = Get-List -Site $sgDestSite -Name $listStub;
    Write-Host("DestList "+ $sgDestList)
    $result = Copy-Content -SourceList $sgSrcList -DestinationList $sgDestList;
    
    $log = "Results $($result.Result)";
    Write-Log $log "INFO" "migration";
}
    