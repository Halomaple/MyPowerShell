$Teleopti = "C:\teleopti\"
$TeleoptiDevUtilities = "C:\DevUtilities"
$TeleoptiDebug = $Teleopti + ".debug-Setup"
$TeleoptiWeb = $Teleopti + "Teleopti.Ccc.Web\Teleopti.Ccc.Web"
$TeleoptiAuthenticationBridge = $Teleopti + "Teleopti.Ccc.Web.AuthenticationBridge"
$TeleoptiWFM = $Teleopti + "Teleopti.Ccc.Web\Teleopti.Ccc.Web\WFM"
$TeleoptiFatClientPath = $Teleopti + "Teleopti.Ccc.SmartClientPortal\Teleopti.Ccc.SmartClientPortal.Shell\bin\Debug\Teleopti.Ccc.SmartClientPortal.Shell.exe"
$TeleoptiFatClientProcessName = "Teleopti.Ccc.SmartClientPortal.Shell"
$TeleoptiVSConfig = $Teleopti + ".vs\config"
$TeleoptiWebPort = "52858"
$PowerShellFolder = "~\Documents\WindowsPowerShell"
$TeleoptiVpn = "vpn"
$TeleoptiDoor = "$Env:Door"
$LocalIP = "$Env:LocalIP"

$ConnectAzureScript = "~\Documents\ConnectAzure.ps1"
$VS = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\devenv.exe"
$HG = "C:\Program Files\TortoiseHg\thgw.exe"
$VSProcessName = "devenv"
$IISExpressProcessName = "iisexpress"
$SSMS = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe"
$Param = " --full-history"
$Chrome = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

function Start-Up {
	Write-Host "
	Good to see you!

	Programs:
		vs - 'Launch visual studio'
		kvs - 'Kill visual studio'
		rvs - 'Restart visual studio'
		sql - 'Luanch sql server management studio'

	Folders:
		t - 'Teleopti Root'
		debug - 'Teleopti Debug'
		wfm - 'Teleopti WFM'
		psf - 'My PowerShell Folder'

	Network:
		vpn - 'Enable Teleopti VPN'
		vpn/f - 'Disable Teleopti VPN'
		vpn? - 'Get VPN Status'

	Bat:
		toa - 'Change toggle mode to All'
		tor - 'Change toggle mode to RC'
		toc - 'Change toggle mode to Customer'
		toggle - 'Current toggle mode'
		restore - 'Teleopti Restore to Local'
		infratest - 'Teleopti Teleopti InfratestConfig'
		fixconfig - 'Teleopti Teleopti FixMyConfigFlow'
		mobile - 'Enable mobile access of TeleoptiWFM/Web'
		desktop - 'Enable desktop access only of TeleoptiWFM/Web'
		azure - 'Connect to Microsoft Azure Virtual Machine'

	Projects:
		fat - 'Run Teleopti Fat Client'
		kfat - 'Kill Teleopti Fat Client'
		kis - 'Kill IIS Express'
		cis - 'Clear IIS Express Cache'
		clean - 'Clean IIS and kill Teleopti Fat Client'

	Websites:
		kanban - 'Kanban Board'
		pr - 'Pull Request Board'
		id - 'Work item'
		build - 'Teleopti Build Server'
		intranet - 'Intranet'
		rnd - 'IntranetRND'
		github - 'Github'

	Tools:
		open [url] - 'Open url in browser'
		dict [word] - 'Youdao dict'
		can [word] - 'Can I Use'
		rst - 'Restart Computer'
		clipc - 'Clip Current Path'

	Search:
		baidu [keywords] - 'Search keywords using Baidu'
		bing [keywords] - 'Search keywords using Bing'
		g [keywords] - 'Search keywords using Google'
		stackoverflow - 'StackOverflow'
		msdn - 'MSDN'

	Gate:
		gate - 'Open Gate'

	PS:
		commands - 'Show Commands'
		update - 'Update Module'
	"
}

Start-Up

function Start-ShowCommands {
	Start-Up
}

function Update-MyModule {
	Remove-Module MyModule
	Import-Module MyModule

	Write-Host "Module updated!"
}

function Start-VS {
	Start-Process $VS
}

function Start-KillVS {
	$process = Get-VSProcess
	if ($process.Id) {
		Stop-Process $process.Id
		Write-Host "Visual Studio is terminated"
	}
 else {
		Write-Host "Visual Studio has not started"
	}
}

function Get-VSProcess {
	return Get-Process $VSProcessName
}

function Start-RestartVS {
	Start-KillVS
	Start-VS
}

function Get-IISExpressProcess {
	return Get-Process $IISExpressProcessName
}

function Start-KillIISExpress {
	$process = Get-IISExpressProcess
	if ($process.Id) {
		Stop-Process $process.Id
		Write-Host "IIS Express is terminated"
	}
 else {
		Write-Host "IIS Express has not started"
	}
}

function Start-ClearIISExpressCache {
	Write-Host "Clearing IISExpress Cache..."
	rm ~/Documents/IISExpress/* -r
	Write-Host "IISExpress Cache Cleaned!"
}

function Start-Clean () {
	Start-KillIISExpress
	Start-KillTeleoptiFatClient
	Start-ClearIISExpressCache
}

function Start-SSMS {
	Start-Process $SSMS
}

function Enter-Teleopti {
	Set-Location $Teleopti
}

function Enter-TeleoptiDebug {
	Set-Location $TeleoptiDebug
}

function Enter-TeleoptiWFM {
	Set-Location $TeleoptiWFM
}

function Enter-PowerShellFolder {
	Set-Location $PowerShellFolder
}

function Get-TeleoptiVpn {
	$interfaceAlias = Get-NetIPAddress | ForEach-Object { $_.InterfaceAlias }
	if ($interfaceAlias -contains $TeleoptiVpn) {
		return $TeleoptiVpn;
	}

	return;
}

function Disable-TeleoptiVpn {
	$current = Get-TeleoptiVpn
	if ($current -ne $null) {
		Write-Host "Disconnecting from $current..."
		rasdial $current /DISCONNECT
	}
}

function Enable-TeleoptiVpn {
	$vpn = Get-TeleoptiVpn

	if ($vpn -eq $null) {
		Write-Host "Attempting to connect to $TeleoptiVpn..."
		rasdial $TeleoptiVpn
	}
 else {
		Write-Host "Connected to $vpn."
	}
}

function Get-VpnStatus {
	rasdial
}

function Start-ClearToggleSetting {
	$fileOrigin = Get-Content "$TeleoptiWeb\web.config"
	$fileModified = @()
	Foreach ($line in $fileOrigin) {
		if ($line -match '<add key="ToggleMode"') {
		}
		else {
			$fileModified += $line
		}
	}
	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiWeb\web.config"
}

function Start-TeleoptiToggleALL {
	Start-ClearToggleSetting

	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiWeb\web.config"

	Foreach ($line in $fileOrigin) {
		if ($line -match "UseRelativeConfiguration") {
			$fileModified += '		<add key="ToggleMode" value="ALL" />'
		}
		$fileModified += $line
	}

	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiWeb\web.config"
	Write-Host "Toggled ALL"
}

function Start-TeleoptiToggleRC {
	Start-ClearToggleSetting

	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiWeb\web.config"

	Foreach ($line in $fileOrigin) {
		if ($line -match "UseRelativeConfiguration") {
			$fileModified += '		<add key="ToggleMode" value="RC" />'
		}
		$fileModified += $line
	}

	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiWeb\web.config"
	Write-Host "Toggled RC"
}

function Start-TeleoptiToggleCUSTOMER {
	Start-ClearToggleSetting

	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiWeb\web.config"

	Foreach ($line in $fileOrigin) {
		if ($line -match "UseRelativeConfiguration") {
			$fileModified += '		<add key="ToggleMode" value="CUSTOMER" />'
		}
		$fileModified += $line
	}

	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiWeb\web.config"
	Write-Host "Toggled CUSTOMER"
}

function Start-TeleoptiShowCurrentToggle {
	$file = Get-Content "$TeleoptiWeb\web.config"
	$correctStartPosition = $false
	Foreach ($line in $file) {
		if ($correctStartPosition -and $line -match '<add key="ToggleMode"') {
			Write-Host "Current toggle mode: "
			Write-Host $line
		}

		if ($line -match "Remarked line below must be kept") {
			$correctStartPosition = $true
		}
	}
}

function Start-TeleoptiEnableMobileAccess {
	#1. add ip binding
	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiVSConfig\applicationhost.config"

	$withinWebSiteTag = $false
	Foreach ($line in $fileOrigin) {
		$fileModified += $line

		if ($withinWebSiteTag) {
			if ($line -match "`:$TeleoptiWebPort`:localhost") {
				$fileModified += $line.Replace("localhost", "$LocalIP")
			}
			if ($line -match "Teleopti.Analytics.Portal") {
				$withinWebSiteTag = $false
			}
		}

		if ($line -match "Teleopti.Ccc.Web-Site") {
			$withinWebSiteTag = $true
		}
	}
	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiVSConfig\applicationhost.config"

	#2. replace localhost with ip in web/web.config
	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiWeb\web.config"

	Foreach ($line in $fileOrigin) {
		if ($line -match "localhost`:$TeleoptiWebPort") {
			$fileModified += $line.Replace("localhost", "$LocalIP")
		}
		else {
			$fileModified += $line
		}
	}
	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiWeb\web.config"

	#3. replace localhost with ip in AuthenticationBridge/web.config
	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiAuthenticationBridge\web.config"

	Foreach ($line in $fileOrigin) {
		if ($line -match "localhost`:$TeleoptiWebPort") {
			$fileModified += $line.Replace("localhost", "$LocalIP")
		}
		else {
			$fileModified += $line
		}
	}
	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiAuthenticationBridge\web.config"
	Write-Host "Please open http://$LocalIP`:$TeleoptiWebPort/TeleoptiWFM/Web on your mobile when project is running"
}

function Start-TeleoptiEnableDesktopAccessOnly {
	#1. remove ip binding
	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiVSConfig\applicationhost.config"

	Foreach ($line in $fileOrigin) {
		if ($line -match "`:$TeleoptiWebPort`:$LocalIP") {
			continue
		}
		$fileModified += $line
	}
	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiVSConfig\applicationhost.config"

	#2. replace ip with localhost in web/web.config
	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiWeb\web.config"

	Foreach ($line in $fileOrigin) {
		if ($line -match "$LocalIP`:$TeleoptiWebPort") {
			$fileModified += $line.Replace("$LocalIP", "localhost")
		}
		else {
			$fileModified += $line
		}
	}
	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiWeb\web.config"

	#3. replace ip with localhost in AuthenticationBridge/web.config
	$fileModified = @()
	$fileOrigin = Get-Content "$TeleoptiAuthenticationBridge\web.config"

	Foreach ($line in $fileOrigin) {
		if ($line -match "$LocalIP`:$TeleoptiWebPort") {
			$fileModified += $line.Replace("$LocalIP", "localhost")
		}
		else {
			$fileModified += $line
		}
	}
	$fileModified | Out-File -Encoding "UTF8" "$TeleoptiAuthenticationBridge\web.config"
	Write-Host "TeleoptiWFM/web`: Desktop access only"
}

function Start-TeleoptiRestoreToLocal {
	Enable-TeleoptiVpn
	Write-Host "Started Teleopti Restore To Local..."
	& "$TeleoptiDebug\Restore to Local.bat"
}

function Start-TeleoptiInfratestConfig {
	Write-Host "Starting Teleopti InfratestConfig..."
	& "$TeleoptiDebug\InfratestConfig.bat"
}

function Start-TeleoptiFixMyConfigFlow {
	Write-Host "Starting Teleopti FixMyConfigFlow..."
	& "$TeleoptiDebug\FixMyConfigFlow.bat"
}

function Start-TeleoptiFatClient {
	& $TeleoptiFatClientPath
}

function Start-KillTeleoptiFatClient {
	$process = Get-FatClientProcess
	if ($process.Id) {
		Stop-Process $process.Id
		Write-Host "Teleopti Fat Client is terminated"
	}
 else {
		Write-Host "Teleopti Fat Client has not started"
	}
}

function Start-ConnectAzure {
	& $ConnectAzureScript
}

function Get-FatClientProcess {
	return Get-Process $TeleoptiFatClientProcessName
}

function New-OpenUrlInBrowser {
	$url = "http://$($args[0])"
	Write-Host "Opened $url in browser"
	& $Chrome $url
}

function New-Kanban {
	$url1 = "https://teleopti.visualstudio.com/TeleoptiWFM/_boards/board/t/Pandas/Items"
	& $Chrome $url1
	Write-Host "Kanban opened in Chrome."
}

function New-PullRequest {
	$url1 = "https://teleopti.visualstudio.com/_git/TeleoptiWFM/pullrequests?_a=mine"
	& $Chrome $url1
	Write-Host "Kanban opened in Chrome."
}

function New-WorkItem {
	$url1 = "https://teleopti.visualstudio.com/TeleoptiWFM/_workitems/edit/$($args[0])"
	& $Chrome $url1
	Write-Host "Workd item opened in Chrome."
}

function New-BuildServer {
	Enable-TeleoptiVpn
	$url = "http://buildsrv01/overview.html"
	& $Chrome $url
	Write-Host "BuildServer opened in Chrome."
}

function New-Intranet {
	$url = "https://intranet.teleopti.com/"
	& $Chrome $url
	Write-Host "Intranet opened in Chrome."
}

function New-IntranetRND {
	$url = "https://intranet.teleopti.com/teleoptiwfm/rnd~2/"
	& $Chrome $url
	Write-Host "Intranet RND opened in Chrome."
}

function New-Github {
	$url = "https://github.com/"
	& $Chrome $url
	Write-Host "Github opened in Chrome."
}

function New-YoudaoDict {
	Write-Host "Looking up $($args[0]) in Youdao dict online"
	$url = "http://dict.youdao.com/w/eng/$($args[0])"
	& $Chrome $url
}

function New-CanIUse {
	Write-Host "Can I use $($args[0]) ?"
	$url = "http://caniuse.com/#search=$($args[0])"
	& $Chrome $url
}

function New-Baidu {
	Write-Host "Searched keywords using Baidu."
	$url = "https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=0&rsv_idx=1&tn=baidu&wd=$args"
	& $Chrome $url
}

function New-Bing {
	Write-Host "Searched keywords using Bing."
	$url = "http://cn.bing.com/search?q=$args"
	& $Chrome $url
}

function New-Google {
	Write-Host "Searched keywords using Google."
	$url = "http://www.google.com/search?q=$args"
	& $Chrome $url
}

function New-StackOverflow {
	$url = "http://stackoverflow.com/"
	& $Chrome $url
	Write-Host "StackOverflow opened in Chrome."
}

function New-MSDN {
	$url = "https://msdn.microsoft.com/en-us/"
	& $Chrome $url
	Write-Host "MSDN opened in Chrome."
}

function Start-OpenGate {
	& wget $TeleoptiDoor
	Write-Host "Gate is opened"
}

function Start-ClipCurrentPath {
	$pwd.Path | clip
}

function Start-RestartComputer {
	if ($args[0]) {
		& shutdown /r /t $args[0]
	}
	else {
		& shutdown /r /t 0
	}
}