Import-Module MyModule

New-Alias -name vs -value Start-VS -description "Launch visual studio" -option ReadOnly
New-Alias -name kvs -value Start-KillVS -description "Kill visual studio" -option ReadOnly
New-Alias -name rvs -value Start-RestartVS -description "Restart visual studio" -option ReadOnly
New-Alias -name kis -value Start-KillIISExpress -description "Kill IIS Express" -option ReadOnly
New-Alias -name cis -value Start-ClearIISExpressCache -description "Clear IIS Express Cache" -option ReadOnly
New-Alias -name sql -value Start-SSMS -description "Launch sql server management studio" -option ReadOnly

New-Alias -name p -value Enter-ProjectsFolder -description "Projects Folder" -option ReadOnly
New-Alias -name psf -value Enter-PowerShellFolder -description "My PowerShell Folder" -option ReadOnly

New-Alias -name ev -value Start-EventViewer -description "Open Event Viewer" -option ReadOnly
New-Alias -name log -value Start-LoggingEvents -description "Logging Events" -option ReadOnly

New-Alias -name clean -value Start-Clean -description "Clean IIS" -option ReadOnly
New-Alias -name clearlog -value Start-ClearEventLogs -description "Clear Event Logs" -option ReadOnly
New-Alias -name k -value Start-KillProcess -description "Kill process" -option ReadOnly
New-Alias -name kq -value Start-KillQQProcess -description "Kill QQ" -option ReadOnly
New-Alias -name kw -value Start-KillWeChatProcess -description "Kill WeChat" -option ReadOnly
New-Alias -name kx -value Start-KillThunderProcess -description "Kill Thunder" -option ReadOnly

New-Alias -name kanban -value New-Kanban -description "Kanban Board" -option ReadOnly
New-Alias -name pr -value New-PullRequest -description "Pull Request Board" -option ReadOnly
New-Alias -name id -value New-WorkItem -description "Work item" -option ReadOnly
New-Alias -name teams -value New-TeamsWebApp -description "Teams Web App" -option ReadOnly

New-Alias -name github -value New-Github -description "Github" -option ReadOnly
New-Alias -name mail -value New-QQMail -description "QQ mail" -option ReadOnly

New-Alias -name open -value New-OpenUrlInBrowser -description "Open url in browser" -option ReadOnly
New-Alias -name dict -value New-YoudaoDict -description "Youdao dict" -option ReadOnly
New-Alias -name can -value New-CanIUse -description "Baidu" -option ReadOnly

New-Alias -name baidu -value New-Baidu -description "Baidu" -option ReadOnly
New-Alias -name bing -value New-Bing -description "Bing" -option ReadOnly
New-Alias -name g -value New-Google -description "Google" -option ReadOnly
New-Alias -name stackoverflow -value New-StackOverflow -description "StackOverflow" -option ReadOnly
New-Alias -name msdn -value New-MSDN -description "MSDN" -option ReadOnly

New-Alias -name rst -value Start-RestartComputer -description "Restart Computer" -option ReadOnly
New-Alias -name clipc -value Start-ClipCurrentPath -description "Clip Current Path" -option ReadOnly

New-Alias -name commands -value Start-ShowCommands -description "Show Commands" -option ReadOnly
New-Alias -name update -value Update-MyModule -description "Update Module" -option ReadOnly