. .\credentials.ps1
. .\migration.ps1
. .\logger.ps1

Write-Log "Started" "INFO" "migration"

$encpassword = convertto-securestring -String $passSrc -AsPlainText -Force

$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $userSrc, $encpassword


Import-Module Sharegate
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"


$sourceTenantUrl = "https://ext.portalsolutions.net";
$tenantUrl = "https://m365x518326.sharepoint.com";

$siteList = Import-Csv .\csv\jb-TestSPO.csv;
Write-Log "Loaded List" "INFO" "migration";

foreach ($site in ($siteList)) {
    try {
        $sourceURL = $sourceTenantUrl + $site.'Web';
        $sourceURL = $sourceURL.Trim();
        $content = $site.'List/DocLib';
        $contentType = $site.'List/DocLib Type';
        $listStub = $content;
        $listURL = $sourceURL + "/" + $content;
        $listURL = $listURL.Trim();
        $siteName = $site.'DestinationURL'
        if (-Not([string]::IsNullOrEmpty($siteName))) {
            $siteNameNu = $tenantUrl + $siteName;
            $siteNameNu = $siteNameNu.Trim();
        }
        $log = "SPOConnect to site : " + $siteNameNu;
        Write-Log $log "INFO" "migration"

        $context = New-Object Microsoft.SharePoint.Client.ClientContext($sourceURL)
        $credentials = New-Object System.Management.Automation.PSCredential($userSrc, $encpassword)
        $context.Credentials = $credentials
        $log = "Retrieving Source List: " + $content
        Write-Log $log "INFO" "migration"
        $list = $context.Web.Lists.GetByTitle($content)
        $context.Load($list)
        # $context.ExecuteQuery()
        # $listURL = $list.DefaultEditFormUrl.Replace('/EditForm.aspx', '') 
        # $listURL = $listURL.Replace('/Forms', '')
        # $listStub = $listURL.Substring($listURL.LastIndexOf("/"))
        if (-Not([string]::IsNullOrEmpty($sourceURL)) -And -Not ([string]::IsNullOrEmpty($siteNameNu))) {
            try {
                $message = "Migrating: " + $contentType + " From: " + $listURL + " To: " + $siteNameNu
                Write-Log $message "INFO" "migration"
                MigrateScript -sourceURL $sourceURL -listURL $listURL -listStub $listStub -destURL $siteNameNu;
            }
            catch {                
                $ErrorMessage = $_.Exception.Message
                Write-Log $ErrorMessage "ERROR" "migration"
            }                            
        }
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Log $ErrorMessage "ERROR" "migration"    
    }
}
