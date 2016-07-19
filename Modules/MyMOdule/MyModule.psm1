$TeleoptiDebug = "$Env:Teleopti\.debug-Setup"
$TeleoptiWFM = "$Env:Teleopti\Teleopti.Ccc.Web\Teleopti.Ccc.Web\WFM"
$TeleoptiStyleguide = "$Env:GitRepo\styleguide"
$TeleoptiVpn = "typhoon","vpn"

$RunEmacs = " ${env:ProgramFiles(x86)}\GNU\emacs\bin\runemacs.exe"
$RunChrome = " ${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
$RunMsbuild = " ${env:ProgramFiles(x86)}\MSBuild\14.0\Bin\MSBuild.exe"


$TeleoptiNodeBuildTarget = "$TeleoptiWFM\..\.node\node.targets"
$TeleoptiSln = "$TeleoptiDebug\..\CruiseControl.sln"
$TeleoptiWeb = "$TeleoptiWFM\..\Teleopti.Ccc.Web.csproj"

function Start-Emacs {
    if ($args.Length -eq 0) {
        Start-Process $RunEmacs
    } else {
        $filename = $args[0]
        Start-Process $Emacs -ArgumentList "--find $filename"
    }
}

function Enter-TeleoptiDebug {
    Set-Location $TeleoptiDebug
}

function Enter-TeleoptiWFM {
    Set-Location $TeleoptiWFM
}

function Enter-TeleoptiStyleguide {
    Set-Location $TeleoptiStyleguide
}

function Get-TeleoptiVpn {
    $interfaceAlias = Get-NetIPAddress | ForEach-Object { $_.InterfaceAlias }
    foreach ($item in $TeleoptiVpn) {
        if ($interfaceAlias -contains $item) {
            Write-Host "Current vpn connection is $item."
            return $item;
        }
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
        Write-Host "No vpn connection is found."
        $retry = 10;
        while ($retry -gt 0) {
            $idx = $retry % $TeleoptiVpn.Length
            $vpn =  $TeleoptiVpn[$idx]
            Write-Host "Attempting to connect to $vpn..."

            $p = Start-Process rasdial $vpn -PassThru -Wait

            if ($p.ExitCode -eq 0) {
                Write-Host "Connected to $vpn."
                return $vpn
            } else {
                Write-Host "Cannot connect to $vpn."
                $retry -= 1
            }
        }
    } else {
        Write-Host "Connected to $vpn."
        return $vpn
    }

    Write-Error "Cannot connect to $TeleoptiVpns within the retry limit."
}

function Start-TeleoptiRestoreToLocal {
    $vpn = Enable-TeleoptiVpn
	if ($vpn -eq $null) {
		Write-Error "Aborted! Cannot establish VPN connection."
		return
	}
    Write-Host "Starting Teleopti Restore To Local..."
    $p = Start-Process "$TeleoptiDebug\Restore to Local.bat" -Wait
    if ($p.ExitCode -eq 0) {
        Write-Host "Restore to local was completed!"
    } else {
        Write-Error "Restore to local was not completed!"
    }
}

function New-TeleoptiChallenger {
    $vpn = Enable-TeleoptiVpn
	if ($vpn -eq $null) {
		Write-Error "Aborted! Cannot establish VPN connection."
		return
	}

    $url = "http://challenger:8080/Kanban/#/board/0"
    & $RunChrome $url
    Write-Host "New challenger started in Chrome."
}

function New-DevBuild {
    $vpn = Enable-TeleoptiVpn
	if ($vpn -eq $null) {
		Write-Error "Aborted! Cannot establish VPN connection."
		return
	}

    $url = "http://devbuild01.toptinet.teleopti.com/project.html?projectId=TeleoptiWFM&tab=projectOverview"
    & $RunChrome $url
    Write-Host "New devbuild started in Chrome."
}

function New-GitHub {
    Disable-TeleoptiVpn
    $url = "https://github.com"
    & $RunChrome $url
    Write-Host "Github started in Chrome."
}

function Start-TeleoptiSourcePull {
	$vpn = Enable-TeleoptiVpn
	if ($vpn -eq $null) {
		Write-Error "Aborted! Cannot establish VPN connection."
		return
	}
	Enter-TeleoptiWFM
	hg pull
}


function open-file($path) {
	Start-Process explorer.exe -ArgumentList "/select,$path"
}

function Select-File {
	Begin {
		$paths = @()
		foreach ($p in $args) {
			if ([string]::IsNullOrWhiteSpace($p)) {
				return
			}
			$path = Resolve-Path $p
			$paths += "$path"
			open-file -path $path
		}
	}
	Process {
		if ($_ -eq $null) {
			return
		}
		$path = Resolve-Path $_
		$paths += "$path"
		open-file -path $path
	}
	End {
		return $paths
	}
}

function Find-HgFile {
	Enter-TeleoptiWFM
	if ($args.Length -eq 0) {
		return
	}
	$pattern = $args[0]
	hg file | Select-String -pattern $pattern | ForEach { Resolve-Path $_ }
}

function Hide-TeleoptiNodeBuild {
	(Get-Content $TeleoptiNodeBuildTarget) -replace '(<Exec\s.*?/>)','<!--$1-->' | Set-Content -Path $TeleoptiNodeBuildTarget
	Write-Host "Muted Node-related Execs in Teleopti Build."
}

function Show-TeleoptiNodeBuild {
	(Get-Content $TeleoptiNodeBuildTarget)  -replace '<!--(<Exec.*?/>)-->','$1' | Set-Content -Path $TeleoptiNodeBuildTarget
	Write-Host "Restored Node-related Execs in Teleopti Build."
}

function Start-TeleoptiBuild {
	if ($args.Length -eq 0) {
		$startProj = $TeleoptiSln
	} else {
		$startProj = $args[0]
	}

	Hide-TeleoptiNodeBuild
	Write-Host "Start building ..."
	& ($RunMsbuild) /target:build $startProj
	Show-TeleoptiNodeBuild
}

function Search-Google {
	& $RunChrome "https://www.google.com/search?q=$args"
}


function Search-Bing {
	& $RunChrome "https://www.bing.com/search?q=$args"
}



Export-ModuleMember -Function 'Start-*'
Export-ModuleMember -Function 'Enter-*'
Export-ModuleMember -Function 'Enable-*'
Export-ModuleMember -Function 'Disable-*'
Export-ModuleMember -Function 'Get-TeleoptiVpn'
Export-ModuleMember -Function 'New-*'
Export-ModuleMember -Function 'Select-*'
Export-ModuleMember -Function 'Find-*'
Export-ModuleMember -Function 'Search-*'
Export-ModuleMember -Variable 'Teleopti*'
Export-ModuleMember -Variable 'Run*'
