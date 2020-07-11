$ProjectsFolder = "$Env:ProjectFolder"
$PowerShellFolder = "~\Documents\WindowsPowerShell"
$LocalIP = "$Env:LocalIP"
$UbuntuMachine = "$Env:UbuntuMachine"
$Chrome = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

function Start-Up {
	Write-Host "
    Good to see you!

    Folders:
        p - 'Projects folder'
        psf - 'My PowerShell Folder'

    Logs:
        ev - 'Open Event Viewer'
        log - 'Logging Events'
        clearlog - 'Clear Event Logs'

    VMs:
        ubuntu - 'Logon Ubuntu machine'

    Sites:
        github - 'Github'
        gitlab - 'Gitlab'
        mail - 'Mail'
        open [url] - 'Open url in browser'

    Search:
        baidu [keywords] - 'Search keywords using Baidu'
        bing [keywords] - 'Search keywords using Bing'
        can [word] - 'Can I Use'
        dict [word] - 'Youdao dict'
        id - 'Work item'
        g [keywords] - 'Search keywords using Google'
        s [keywords] - 'Search keywords usering StackOverflow'

    Misc:
        commands - 'Show Commands'
        clipc - 'Clip Current Path'
        k - 'Kill process'
        ll - 'List items'
        hibernate - 'Hibernate computer'
        rst - 'Restart computer'
        stc - 'Shutdown computer'
    "
}

Start-Up

## Folders
function Enter-ProjectsFolder {
	Set-Location $ProjectsFolder
}

function Enter-PowerShellFolder {
	Set-Location $PowerShellFolder
}


## Logs
function Start-EventViewer {
	& 'eventvwr'
}

function Start-LoggingEvents {
	Get-Eventlog -LogName Application -Newest $args[0] -Source *$args[1]* | Select-Object Index, EntryType, InstanceId, Message | format-list
}

function Start-ClearEventLogs () {
	& Clear-EventLog "Application"
	& Clear-EventLog "Security"
	& Clear-EventLog "System"
}

## VMs
function  Start-LogonUbuntu {
	ssh -i $ProjectsFolder\ubuntu\id_rsa ubuntu@$UbuntuMachine
}

## Sites
function New-Github {
	$url = "https://github.com/"
	& $Chrome $url
	Write-Host "Github opened in Chrome."
}

function New-Gitlab {
	$url1 = $Env:GitlabPath
	& $Chrome $url1
	Write-Host "Gitlab opened in Chrome."
}

function New-Mail {
	$url = "https://outlook.office.com/mail/inbox"
	& $Chrome $url
	Write-Host "Mail opened in Chrome."
}

function New-OpenUrlInBrowser {
	$url = "http://$($args[0])"
	Write-Host "Opened $url in browser"
	& $Chrome $url
}


## Search
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

function New-CanIUse {
	Write-Host "Can I use $($args[0]) ?"
	$url = "http://caniuse.com/#search=$($args[0])"
	& $Chrome $url
}

function New-YoudaoDict {
	Write-Host "Looking up $($args[0]) in Youdao dict online"
	$url = "http://dict.youdao.com/w/eng/$($args[0])"
	& $Chrome $url
}

function New-WorkItem {
	$url = $Env:JiraPath + $args[0]
	& $Chrome $url
	Write-Host "Workd item opened in Chrome."
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


## Misc
function Start-ShowCommands {
	Start-Up
}

function Start-ClipCurrentPath {
	$pwd.Path | clip
}

function Start-KillProcess () {
	& Stop-Process -Name $args[0]
}

function Start-ListItems {
	& Get-ChildItem
}

function Start-HibernateComputer {
	& shutdown /h
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