param (
	# Browsers
	[switch]$Chrome,
	[switch]$Brave,
	[switch]$Firefox
)

# Create temporary directory
$tempDir = Join-Path -Path $env:TEMP -ChildPath $([System.Guid]::NewGuid())
New-Item $tempDir -ItemType Directory -Force | Out-Null
Push-Location $tempDir

####################
##     OPTIONS    ##
####################

# Brave
if ($Brave) {
	Write-Host "Installing Brave..."
	& curl.exe -LSs "https://laptop-updates.brave.com/latest/winx64" -o "$tempDir\BraveSetup.exe"
	if (!$?) {
		Write-Error "Downloading Brave failed."
		exit 1
	}

	& "$tempDir\BraveSetup.exe" /silent /install 2>&1 | Out-Null

	do {
		$processesFound = Get-Process | Where-Object { "BraveSetup" -contains $_.Name } | Select-Object -ExpandProperty Name
		if ($processesFound) {
			Write-Host "Still running BraveSetup."
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
	Write-Host "Installing Firefox..."
	& curl.exe -LSs "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US" -o "$tempDir\firefox.exe"
	Start-Process -FilePath "$tempDir\firefox.exe" -WindowStyle Hidden -ArgumentList '/S /ALLUSERS=1' -Wait 2>&1 | Out-Null
	exit
}

############################
##     MISC installers    ##
############################

# Visual C++ Runtimes (referred to as vcredists for short)
# https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist
$legacyArgs1 = '/Q'
$legacyArgs2 = '/q /norestart'
$modernArgs = "/install /quiet /norestart"

$vcredists = @{
	# 2005 - version 8.0.50727.6195 (MSI 8.0.61000/8.0.61001) SP1
	"https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.exe"       = $legacyArgs1
	"https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.exe"       = $legacyArgs1
	# 2008 - version 9.0.30729.6161 (EXE 9.0.30729.5677) SP1
	"https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe"       = $legacyArgs1
	"https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe"       = $legacyArgs1
	# 2010 - version 10.0.40219.325 SP1
	"https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe"       = $legacyArgs2
	"https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe"       = $legacyArgs2
	# 2012 - version 11.0.61030.0
	"https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" = $modernArgs
	"https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" = $modernArgs
	# 2013 - version 12.0.40664.0
	"https://aka.ms/highdpimfc2013x64enu"                                                                       = $modernArgs
	"https://aka.ms/highdpimfc2013x86enu"                                                                       = $modernArgs
	# 2015-2022 (2015+) - latest version
	"https://aka.ms/vs/17/release/vc_redist.x64.exe"                                                            = $modernArgs
	"https://aka.ms/vs/17/release/vc_redist.x86.exe"                                                            = $modernArgs
}
$num = 0; foreach ($a in $vcredists.GetEnumerator()) {
	$num++; $vcredist = "$tempDir\vcredist$num.exe"
	# curl is faster than Invoke-WebRequest
	Write-Host "Installing Visual C++ Runtime $num..."
	& curl.exe -LSs "$($a.Name)" -o "$vcredist"
	Start-Process -FilePath $vcredist -WindowStyle Hidden -ArgumentList $a.Value -Wait 2>&1 | Out-Null
}

# Legacy DirectX runtimes
& curl.exe -LSs "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" -o "$tempDir\directx.exe"
Write-Host "Extracting legacy DirectX runtimes..."
Start-Process -FilePath "$tempDir\directx.exe" -WindowStyle Hidden -ArgumentList "/q /c /t:`"$tempDir\directx`"" -Wait 2>&1 | Out-Null
Write-Host "Installing legacy DirectX runtimes..."
Start-Process -FilePath "$tempDir\directx\dxsetup.exe" -WindowStyle Hidden -ArgumentList '/silent' -Wait 2>&1 | Out-Null

############################
##    Manual installers   ##
############################

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Host "Creating directory for installers..."
$userDownloads = "$env:USERPROFILE\Downloads"
$userInstallers = "$userDownloads\installers"
New-Item -ItemType Directory -Path "$userInstallers" -Force

Write-Host "Installing Bun..."
& powershell -c "irm bun.sh/install.ps1 | iex"

Write-Host "Installing Nodejs & yarn..."
& cmd.exe /c "nvm install lts"
& cmd.exe /c "nvm use lts"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
& cmd.exe /c "corepack enable"
& cmd.exe /c "corepack prepare yarn@stable --activate"
& cmd.exe /c "yarn set version stable"
& cmd.exe /c "npm -g i tsc nx"

Write-Host "Installing Arc..."
& curl.exe -LSs "https://releases.arc.net/windows/prod/Arc.appinstaller" -o "$userInstallers\Arc.appinstaller"
& Add-AppxPackage -AppInstallerFile "Arc.appinstaller"

Write-Host "Installing GitKraken..."
& curl.exe -LSs "https://release.gitkraken.com/windows/GitKrakenSetup.exe" -o "$userInstallers\gitkraken.exe"
Start-Process -FilePath "$userInstallers\gitkraken.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

Write-Host "Installing Powershell 7..."
& curl.exe -LSs "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi" -o "$userInstallers\powershell7.msi"
& msiexec.exe /package "$userInstallers\powershell7.msi" /passive /qn DISABLE_TELEMETRY=1 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=0 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=0 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1

Write-Host "Installing PowerToys..."
& curl.exe -LSs "https://github.com/microsoft/PowerToys/releases/download/v0.80.0/PowerToysSetup-0.80.0-x64.exe" -o "$userInstallers\powertoys.exe"
Start-Process -FilePath "$userInstallers\powertoys.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

Write-Host "Installing Obsidian..."
& curl.exe -LSs "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/Obsidian.1.5.12.exe" -o "$userInstallers\obsidian.exe"
Start-Process -FilePath "$userInstallers\obsidian.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

Write-Host "Installing Slack..."
& curl.exe -LSs "https://downloads.slack-edge.com/desktop-releases/windows/x64/4.37.98/SlackSetup.exe" -o "$userInstallers\slack.exe"
Start-Process -FilePath "$userInstallers\slack.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

Write-Host "Installing VSCode..."
& curl.exe -LSs "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64" -o "$userInstallers\vscode.exe"
Start-Process -FilePath "$userInstallers\vscode.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /NORESTART /MERGETASKS=!runcode' -Wait 2>&1 | Out-Null

Write-Host "Installing Wireguard..."
& curl.exe -LSs "https://download.wireguard.com/windows-client/wireguard-installer.exe" -o "$userInstallers\wireguard.exe"
Start-Process -FilePath "$userInstallers\wireguard.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /silent /install /norestart' | Out-Null

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

try {
	Write-Host "Installing WSL2..."
	& cmd.exe /c "wsl --update"
	& cmd.exe /c "wsl --set-default-version 2"
	# & cmd.exe /c "wsl --install -d Ubuntu-22.04"
	# & cmd.exe /c "wsl --set-version Ubuntu-22.04 2"
	# & cmd.exe /c "wsl --setdefault Ubuntu-22.04"
	
	Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/Ubuntu2204-221101.AppxBundle" -OutFile "$userInstallers\ubuntu2204.AppxBundle" -UseBasicParsing
	Add-AppxPackage -Path "$userInstallers\ubuntu2204.AppxBundle"
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
	
	$env:DEBIAN_FRONTEND = "noninteractive"
	$env:WSLENV += ":DEBIAN_FRONTEND"
	$distro = "ubuntu2204"
	$username = $env:USERNAME
	$password = "lol"
	
	& $distro install --root
	& $distro config --default-user "root"
	& $distro run useradd -m "$username"
	& $distro run sh -c "echo "${username}:${password}" | chpasswd" # wrapped in sh -c to get the pipe to work
	& $distro run chsh -s /bin/bash "$username"
	& $distro run usermod -aG adm, cdrom, sudo, dip, plugdev "$username"
	& $distro run sh -c 'apt-get update -y && apt-get full-upgrade -y && apt-get autoremove -y && apt-get autoclean'
	& $distro run sh -c 'apt install bison curl git gawk gpg htop rsync screen software-properties-common tar pigz unzip wget zip -y'
	& $distro config --default-user "$username"
	
	& cmd.exe /c "wsl --set-version Ubuntu-22.04 2"
	& cmd.exe /c "wsl --setdefault Ubuntu-22.04"
}
catch {
	Write-Host "WSL2 installation failed"
}

# Remove temporary directory
Pop-Location
Remove-Item -Path $tempDir -Force -Recurse *>$null
