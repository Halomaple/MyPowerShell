$ProjectsFolder = "~\projects"
$PowerShellFolder = "~\Documents\WindowsPowerShell"
$LocalIP = "$Env:LocalIP"
$UbuntuMachine = "$Env:UbuntuMachine"
$CentOSMachine = "$Env:CentOSMachine"

$VS = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"
$VSProcessName = "devenv"
$IISExpressProcessName = "iisexpress"
$SSMS = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe"
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
        p - 'Projects folder'
        psf - 'My PowerShell Folder'

    Bat:

    Projects:
        kis - 'Kill IIS Express'
        cis - 'Clear IIS Express Cache'
        clean - 'Clean IIS'
        clearlog - 'Clear Event Logs'
        k - 'Kill process'

    Websites:
        gitlab - 'Gitlab'
        id - 'Work item'
        github - 'Github'
        mail - 'Mail'

    Tools:
        open [url] - 'Open url in browser'
        dict [word] - 'Youdao dict'
        can [word] - 'Can I Use'
        clipc - 'Clip Current Path'
        ll - 'List items'
        ev - 'Open Event Viewer'
        log - 'Logging Events'

    Computer:
        ubuntu - 'Logon Ubuntu machine'
        centos - 'Logon CentOS machine'
        ab - 'Connect to work network'
        sz - 'Connect to internet'
        wifi - 'Show current wifi'
        rst - 'Restart computer'
        stc - 'Shutdown computer'
        hibernate - 'Hibernate computer'

    Search:
        baidu [keywords] - 'Search keywords using Baidu'
        bing [keywords] - 'Search keywords using Bing'
        g [keywords] - 'Search keywords using Google'
        s [keywords] - 'Search keywords usering StackOverflow'
        msdn - 'MSDN'

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
    Remove-Item ~/Documents/IISExpress/* -r
    Write-Host "IISExpress Cache Cleaned!"
}

function Start-Clean () {
    Start-KillIISExpress
    Start-ClearIISExpressCache
}

function Start-ClearEventLogs () {
    & Clear-EventLog "Application"
    & Clear-EventLog "Security"
    & Clear-EventLog "System"
}

function Start-KillProcess () {
    & Stop-Process -Name $args[0]
}


function Start-SSMS {
    Start-Process $SSMS
}

function Enter-ProjectsFolder {
    Set-Location $ProjectsFolder
}

function Enter-PowerShellFolder {
    Set-Location $PowerShellFolder
}

function Get-VpnStatus {
    rasdial
}

function Start-EventViewer {
    & 'eventvwr'
}

function Start-LoggingEvents {
    get-eventlog -LogName Application -Newest $args[0] -Source *$args[1]* | Select-Object Index, EntryType, InstanceId, Message | format-list
}

function  Start-LogonUbuntu {
    ssh ubuntu@$UbuntuMachine
}

function  Start-LogonCentOS {
    ssh root@$CentOSMachine
}

function Start-ConnectToWorkNetwork {
    $currentWifi = Start-ShowCurrentWifiNetwork
    if ($currentWifi -match "$Env:WorkNetworkName") {
        Write-Host "Already connected."
    }
    else {
        $result = netsh wlan connect name="$Env:WorkNetworkName"

        Write-Host "Connecting..." -NoNewline
        do {
            Write-Host "." -NoNewline
            Start-Sleep -Milliseconds 10

            $currentWifi = Start-ShowCurrentWifiNetwork
            $wifi = Get-NetAdapter -physical | Select-Object Name, Status, Speed | Where-Object Name -eq "Wi-Fi"
        } while ($currentWifi -notmatch "$Env:WorkNetworkName" -or $wifi.Status -ne 'Up')

        Write-Host ""
        Write-Host "Network switched to: $Env:WorkNetworkName"
        Get-NetAdapter -physical | Where-Object Name -eq  "Wi-Fi"
    }
}

function Start-ConnectToInternet {
    $currentWifi = Start-ShowCurrentWifiNetwork
    if ($currentWifi -match "$Env:InternetName") {
        Write-Host "Already connected."
    }
    else {
        $result = netsh wlan connect name="$Env:InternetName"

        Write-Host "Connecting..." -NoNewline

        do {
            Write-Host "." -NoNewline
            Start-Sleep -Milliseconds 10

            $currentWifi = Start-ShowCurrentWifiNetwork
            $wifi = Get-NetAdapter -physical | Select-Object Name, Status, Speed | Where-Object Name -eq "Wi-Fi"
        } while ($currentWifi -notmatch "$Env:InternetName" -or $wifi.Status -ne 'Up')

        Write-Host ""
        Write-Host "Network switched to: $Env:InternetName"
        Get-NetAdapter -physical | Where-Object Name -eq  "Wi-Fi"
    }
}

function Start-ShowCurrentWifiNetwork {
    return netsh wlan show interfaces | Select-String '\sSSID'
}

function New-AzurePortal {
    $url = "https://portal.azure.com/"
    & $Chrome $url
    Write-Host "Azure Portal opened in Chrome."
}

function New-OpenUrlInBrowser {
    $url = "http://$($args[0])"
    Write-Host "Opened $url in browser"
    & $Chrome $url
}

function New-Gitlab {
    $url1 = $Env:GitlabPath
    & $Chrome $url1
    Write-Host "Gitlab opened in Chrome."
}

function New-WorkItem {
    $url = $Env:JiraPath + $args[0]
    & $Chrome $url
    Write-Host "Workd item opened in Chrome."
}

function New-Github {
    $url = "https://github.com/"
    & $Chrome $url
    Write-Host "Github opened in Chrome."
}

function New-Mail {
    $url = "https://outlook.office.com/mail/inbox"
    & $Chrome $url
    Write-Host "Mail opened in Chrome."
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
    $url = "https://stackoverflow.com/search?q=$args"
    & $Chrome $url
    Write-Host "StackOverflow opened in Chrome."
}

function New-MSDN {
    $url = "https://msdn.microsoft.com/en-us/"
    & $Chrome $url
    Write-Host "MSDN opened in Chrome."
}

function Start-ClipCurrentPath {
    $pwd.Path | clip
}

function Start-ListItems {
    & Get-ChildItem
}

function Start-RestartComputer {
    if ($args[0]) {
        & shutdown /r /t $args[0]
    }
    else {
        & shutdown /r /t 0
    }
}

function Start-ShutdownComputer {
    if ($args[0]) {
        & shutdown /s /t $args[0]
    }
    else {
        & shutdown /s /t 0
    }
}

function Start-HibernateComputer {
    & shutdown /h
}