Import-Module MyModule

## Folders
New-Alias -name p -value Enter-ProjectsFolder -description "Projects Folder" -option ReadOnly
New-Alias -name psf -value Enter-PowerShellFolder -description "My PowerShell Folder" -option ReadOnly

## Logs
New-Alias -name ev -value Start-EventViewer -description "Open Event Viewer" -option ReadOnly
New-Alias -name log -value Start-LoggingEvents -description "Logging Events" -option ReadOnly
New-Alias -name clearlog -value Start-ClearEventLogs -description "Clear Event Logs" -option ReadOnly


## VMs
New-Alias -name ubuntu -value Start-LogonUbuntu -description "Logon Ubuntu machine" -option ReadOnly

## Network
New-Alias -name ab -value Start-ConnectToWorkNetwork -description "Work network wifi" -option ReadOnly
New-Alias -name sz -value Start-ConnectToInternet -description "Internet wifi" -option ReadOnly
New-Alias -name wifi -value Start-ShowCurrentWifiNetwork -description "Show current wifi" -option ReadOnly

## Sites
New-Alias -name azure -value New-AzurePortal -description "Azure Portal" -option ReadOnly
New-Alias -name gitlab -value New-Gitlab -description "Gitlab" -option ReadOnly
New-Alias -name github -value New-Github -description "Github" -option ReadOnly
New-Alias -name mail -value New-Mail -description "Mail" -option ReadOnly
New-Alias -name open -value New-OpenUrlInBrowser -description "Open url in browser" -option ReadOnly

## Search
New-Alias -name baidu -value New-Baidu -description "Baidu" -option ReadOnly
New-Alias -name bing -value New-Bing -description "Bing" -option ReadOnly
New-Alias -name can -value New-CanIUse -description "Baidu" -option ReadOnly
New-Alias -name id -value New-WorkItem -description "Work item" -option ReadOnly
New-Alias -name g -value New-Google -description "Google" -option ReadOnly
New-Alias -name s -value New-StackOverflow -description "StackOverflow" -option ReadOnly

## Misc
New-Alias -name commands -value Start-ShowCommands -description "Show Commands" -option ReadOnly
New-Alias -name clipc -value Start-ClipCurrentPath -description "Clip Current Path" -option ReadOnly
New-Alias -name k -value Start-KillProcess -description "Kill process" -option ReadOnly
New-Alias -name ll -value Start-ListItems -description "List items" -option ReadOnly
New-Alias -name hibernate -value Start-HibernateComputer -description "Hibernate computer" -option ReadOnly
New-Alias -name rst -value Start-RestartComputer -description "Restart computer" -option ReadOnly
New-Alias -name stc -value Start-ShutdownComputer -description "Shutdown computer" -option ReadOnly