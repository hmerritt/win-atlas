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

# Chrome
if ($Chrome) {
	Write-Output "Downloading Google Chrome..."
	& curl.exe -LSs "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -o "$tempDir\chrome.msi"
	Write-Output "Installing Google Chrome..."
	Start-Process -FilePath "$tempDir\chrome.msi" -WindowStyle Hidden -ArgumentList '/qn' -Wait 2>&1 | Out-Null
	exit
}

####################
##    Software    ##
####################

# Scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Scoop basics
scoop install git
scoop bucket add extras
scoop bucket add nonportable
scoop bucket add hmerritt https://github.com/hmerritt/scoop-bucket
scoop update

# Essential
scoop install 7zip
scoop install irfanview
scoop install irfanviewplugins
scoop install mpc-hc
scoop install notepadplusplus

# Media
scoop install foobar2000
scoop install mpv
scoop install vlc

# Programming languages
scoop install gcc
scoop install make
scoop install go
scoop install lua
scoop install nvm # nodejs version manager. Run `nvm install` as admin
scoop install php
scoop install python
scoop install rust
scoop install tinygo

# CLI tools
scoop install aria2
scoop install cloc
scoop install composer
scoop install curl
scoop install dark
scoop install dezoomify-rs
scoop install ffmpeg
scoop install fspop
scoop install gifsk
scoop install git
scoop install grep
scoop install jq
scoop install lessmsi
scoop install mediainfo
scoop install nconvert
scoop install nsis
scoop install nssm # the Non-Sucking Service Manager
scoop install openssli
scoop install yt-dlp
scoop install zoxides

# Security
scoop install keeweb
scoop install malwarebytes
scoop install veracrypt
scoop install wireguard-np

# Misc
scoop install audacity
scoop install bulk-rename-utility
scoop install dupeguru
scoop install everything
scoop install flac
scoop install icaros-np
scoop install lite-xl
scoop install losslesscut
scoop install mkvtoolnix
scoop install mp3tag
scoop install rufus
scoop install scoop-search
scoop install sharex
scoop install soulseekqt
scoop install speccy
scoop install spek
scoop install sshfs-np
scoop install starship
scoop install syncthing
scoop install unifiedremote
scoop install windirstat
scoop install winfsp-np
scoop install winscp
scoop install wireshark
scoop install xnconvert

# Pin apps that update (too) frequently
scoop hold gcc
scoop hold git
scoop hold go
scoop hold make
scoop hold mkvtoolnix
scoop hold nssm
scoop hold nvm
scoop hold php
scoop hold python
scoop hold rufus
scoop hold vlc

############################
##    Manual installers   ##
############################

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Host "Installing Bun..."
powershell -c "irm bun.sh/install.ps1 | iex"

Write-Host "Installing Nodejs & yarn..."
nvm install --lts
nvm use --lts
corepack enable
corepack prepare yarn@stable --activate
yarn set version stable
npm -g i tsc nx

Write-Host "Installing VSCode..."
& curl.exe -LSs "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64" -o "$tempDir\vscode.exe"
Start-Process -FilePath "$tempDir\vscode.exe" -WindowStyle Hidden -ArgumentList '/VERYSILENT /NORESTART /MERGETASKS=!runcode' -Wait 2>&1 | Out-Null

Write-Host "Installing Powershell 7..."
& curl.exe -LSs "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi" -o "$tempDir\PowerShell-7.msi"
& msiexec.exe /package "$tempDir\PowerShell-7.msi" /quiet DISABLE_TELEMETRY=1 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=0 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=0 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1
Install-Module VirtualDesktop

# Config
# Needs to be within `%windir%\AtlasModules`
# New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\Powershell"
# New-Item -ItemType Directory -Path "$env:USERPROFILE\.config"

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
