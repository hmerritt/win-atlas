param (
	# Browsers
	[switch]$Chrome,
	[switch]$Brave,
	[switch]$Firefox
)

# Create temporary directory
$tempDir = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $([System.Guid]::NewGuid())
New-Item $tempDir -ItemType Directory -Force | Out-Null
Push-Location $tempDir

####################
##     OPTIONS    ##
####################

# Brave
if ($Brave) {
	Write-Output "Downloading Brave..."
	& curl.exe -LSs "https://laptop-updates.brave.com/latest/winx64" -o "$tempDir\BraveSetup.exe"
	if (!$?) {
		Write-Error "Downloading Brave failed."
		exit 1
	}

	Write-Output "Installing Brave..."
	& "$tempDir\BraveSetup.exe" /silent /install 2>&1 | Out-Null

	do {
		$processesFound = Get-Process | Where-Object { "BraveSetup" -contains $_.Name } | Select-Object -ExpandProperty Name
		if ($processesFound) {
			Write-Output "Still running BraveSetup."
			Start-Sleep -Seconds 2
		}
		else {
			Remove-Item "$tempDir" -ErrorAction SilentlyContinue -Force -Recurse
		}
	} until (!$processesFound)

	Stop-Process -Name "brave" -Force -ErrorAction SilentlyContinue
	exit
}

# Chrome
if ($Chrome) {
	Write-Host "Installing Google Chrome..."
	& curl.exe -LSs "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -o "$tempDir\chrome.msi"
	Start-Process -FilePath "$tempDir\chrome.msi" -WindowStyle Hidden -ArgumentList '/qn' -Wait 2>&1 | Out-Null
	exit
}

# Firefox
if ($Firefox) {
	if ($arm) {
		$firefoxArch = 'win64-aarch64'
	} else {
		$firefoxArch = 'win64'
	}

	Write-Output "Downloading Firefox..."
	& curl.exe -LSs "https://download.mozilla.org/?product=firefox-latest-ssl&os=$firefoxArch&lang=en-US" -o "$tempDir\firefox.exe"
	Write-Output "Installing Firefox..."
	Start-Process -FilePath "$tempDir\firefox.exe" -WindowStyle Hidden -ArgumentList '/S /ALLUSERS=1' -Wait 2>&1 | Out-Null
	exit
}

############################
##    Manual installers   ##
############################

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Host "Installing WSL2..."
& cmd.exe /c "wsl --update"
& cmd.exe /c "wsl --set-default-version 2"
& cmd.exe /c "wsl --install -d Ubuntu-22.04"
& cmd.exe /c "wsl --set-version Ubuntu-22.04 2"
& cmd.exe /c "wsl --setdefault Ubuntu-22.04"

Write-Host "Installing Bun..."
irm bun.sh/install.ps1 | iex

Write-Host "Installing Nodejs & yarn..."
& cmd.exe /c "nvm install lts"
& cmd.exe /c "nvm use lts"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
& cmd.exe /c "corepack enable"
& cmd.exe /c "corepack prepare yarn@stable --activate"
& cmd.exe /c "yarn set version stable"
& cmd.exe /c "npm -g i tsc nx"

Write-Host "Installing Arc..."
& curl.exe -LSs "https://releases.arc.net/windows/prod/Arc.appinstaller" -o "$tempDir\Arc.appinstaller"
& Add-AppxPackage -AppInstallerFile "Arc.appinstaller"

Write-Host "Installing GitKraken..."
& curl.exe -LSs "https://release.gitkraken.com/windows/GitKrakenSetup.exe" -o "$tempDir\gitkraken.exe"
Start-Process -FilePath "$tempDir\gitkraken.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

Write-Host "Installing Powershell 7..."
& curl.exe -LSs "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi" -o "$tempDir\powershell7.msi"
& msiexec.exe /package "$tempDir\powershell7.msi" /passive /qn DISABLE_TELEMETRY=1 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=0 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=0 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1

Write-Host "Installing PowerToys..."
& curl.exe -LSs "https://github.com/microsoft/PowerToys/releases/download/v0.80.0/PowerToysSetup-0.80.0-x64.exe" -o "$tempDir\powertoys.exe"
Start-Process -FilePath "$tempDir\powertoys.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

Write-Host "Installing Obsidian..."
& curl.exe -LSs "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/Obsidian.1.5.12.exe" -o "$tempDir\obsidian.exe"
Start-Process -FilePath "$tempDir\obsidian.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

Write-Host "Installing Slack..."
& curl.exe -LSs "https://downloads.slack-edge.com/desktop-releases/windows/x64/4.37.98/SlackSetup.exe" -o "$tempDir\slack.exe"
Start-Process -FilePath "$tempDir\slack.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

Write-Host "Installing VSCode..."
& curl.exe -LSs "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64" -o "$tempDir\vscode.exe"
Start-Process -FilePath "$tempDir\vscode.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /NORESTART /MERGETASKS=!runcode' -Wait 2>&1 | Out-Null

Write-Host "Installing Wireguard..."
& curl.exe -LSs "https://download.wireguard.com/windows-client/wireguard-installer.exe" -o "$tempDir\wireguard.exe"
Start-Process -FilePath "$tempDir\wireguard.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

# Configs
# CMD
& reg import "C:\Windows\AtlasDesktop\3. Configuration\CMD\Enable CMD config file (default).reg"

# Powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\Powershell" -Force
Copy-Item -Path "C:\Windows\AtlasModules\Configs\Microsoft.PowerShell_profile.ps1" -Destination "$env:USERPROFILE\Documents\Powershell\Microsoft.PowerShell_profile.ps1" -Force

# Starship
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config" -Force
Copy-Item -Path "C:\Windows\AtlasModules\Configs\starship.toml" -Destination "$env:USERPROFILE\.config\starship.toml" -Force

# Common binaries to add to PATH
New-Item -ItemType Directory -Path "C:\Bin" -Force
& 7z x "C:\Windows\AtlasModules\Tools\bin.7z" "-oC:\Bin"

$binDir = "C:\Bin"
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($currentPath -notlike "*$binDir*") {
	$newPath = "$currentPath;$binDir"
	[Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}


# Visual C++ Runtimes (referred to as vcredists for short)
# https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist
$legacyArgs = '/q /norestart'
$modernArgs = "/install /quiet /norestart"

$vcredists = [ordered] @{
	# 2005 - version 8.0.50727.6195 (MSI 8.0.61000/8.0.61001) SP1
	"https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.exe" = @("2005-x64", "/c /q /t:")
	"https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.exe" = @("2005-x86", "/c /q /t:")
	# 2008 - version 9.0.30729.6161 (EXE 9.0.30729.5677) SP1
	"https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" = @("2008-x64", "/q /extract:")
	"https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" = @("2008-x86", "/q /extract:")
	# 2010 - version 10.0.40219.325 SP1
	"https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" = @("2010-x64", $legacyArgs)
	"https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe" = @("2010-x86", $legacyArgs)
	# 2012 - version 11.0.61030.0
	"https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" = @("2012-x64", $modernArgs)
	"https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" = @("2012-x86", $modernArgs)
	# 2013 - version 12.0.40664.0
	"https://aka.ms/highdpimfc2013x64enu" = @("2013-x64", $modernArgs)
	"https://aka.ms/highdpimfc2013x86enu" = @("2013-x86", $modernArgs)
	# 2015-2022 (2015+) - latest version
	"https://aka.ms/vs/17/release/vc_redist.x64.exe" = @("2015+-x64", $modernArgs)
	"https://aka.ms/vs/17/release/vc_redist.x86.exe" = @("2015+-x86", $modernArgs)
}
foreach ($a in $vcredists.GetEnumerator()) {
	$vcName = $a.Value[0]
	$vcArgs = $a.Value[1]
	$vcUrl = $a.Name
	$vcExePath = "$tempDir\vcredist-$vcName.exe"
	
	# curl is faster than Invoke-WebRequest
	Write-Output "Downloading and installing Visual C++ Runtime $vcName..."
	& curl.exe -LSs "$vcUrl" -o "$vcExePath"

	if ($vcArgs -match ":") {
		$msiDir = "$tempDir\vcredist-$vcName"
		Start-Process -FilePath $vcExePath -ArgumentList "$vcArgs`"$msiDir`"" -Wait -WindowStyle Hidden
		
		$msiPaths = (Get-ChildItem -Path $msiDir -Filter *.msi -EA 0).FullName
		if (!$msiPaths) {
			Write-Output "Failed to extract MSI for $vcName, not installing."
		} else {
			$msiPaths | ForEach-Object {
				Start-Process -FilePath "msiexec.exe" -ArgumentList "/log `"$msiDir\logfile.log`" /i `"$_`" $msiArgs" -WindowStyle Hidden
			}
		}
	} else {
		Start-Process -FilePath $vcExePath -ArgumentList $vcArgs -Wait -WindowStyle Hidden
	}
}

# Legacy DirectX runtimes
& curl.exe -LSs "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" -o "$tempDir\directx.exe"
Write-Output "Extracting legacy DirectX runtimes..."
Start-Process -FilePath "$tempDir\directx.exe" -WindowStyle Hidden -ArgumentList "/q /c /t:`"$tempDir\directx`"" -Wait 2>&1 | Out-Null
Write-Output "Installing legacy DirectX runtimes..."
Start-Process -FilePath "$tempDir\directx\dxsetup.exe" -WindowStyle Hidden -ArgumentList '/silent' -Wait 2>&1 | Out-Null

# Remove temporary directory
Pop-Location
Remove-Item -Path $tempDir -Force -Recurse *>$null
