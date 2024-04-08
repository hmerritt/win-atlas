####################
##    Software    ##
####################

Start-Transcript -Path "$env:USERPROFILE\Downloads\archives\logs\SOFTWARE_SCOOP.log"

# Scoop
if (-not (where.exe scoop)) {
    # Set-ExecutionPolicy RemoteSigned -scope CurrentUser # See src/playbook/Configuration/atlas/start.yml
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

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
scoop install zoxide

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
# scoop hold go
scoop hold make
scoop hold mkvtoolnix
scoop hold nssm
scoop hold nvm
scoop hold php
scoop hold python
scoop hold rufus
scoop hold vlc

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
Stop-Transcript
