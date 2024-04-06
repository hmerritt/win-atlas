# win-atlas (aka [`Atlas`](https://github.com/Atlas-OS/Atlas))

An opinionated fork of [`Atlas`](https://github.com/Atlas-OS/Atlas) ("_A transparent and lightweight modification to Windows, designed to optimize performance, privacy and usability._").

## Todo:

-   [ ] Install
    -   [x] Scoop apps
    -   [x] Powershell 7
    -   [x] LTS Node.js with yarn
    -   [ ] Hardcoded installers
        -   [ ] [Arc](https://releases.arc.net/windows/prod/Arc.appinstaller)
        -   [ ] [Docker](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe)
        -   [ ] [GitKraken](https://release.gitkraken.com/windows/GitKrakenSetup.exe)
        -   [ ] [Google backup and sync](https://www.google.com/intl/en-GB/drive/download)
        -   [ ] [Obsidian](https://obsidian.md/)
        -   [ ] [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/install#installing-with-windows-executable-file-via-github)
        -   [ ] [Slack](https://downloads.slack-edge.com/desktop-releases/windows/x64/4.37.98/SlackSetup.exe)
        -   [ ] [Wireguard](https://download.wireguard.com/windows-client/wireguard-installer.exe)
-   [ ] Config files
    -   [x] Powershell
    -   [ ] CMD
    -   [x] Starship
    -   [ ] WinSCP
-   [ ] Visual
    -   [x] Set a custom wallpaper
    -   [x] Maximum wallpaper quality
    -   [ ] Create a new dev desktop
-   [ ] Misc
    -   [ ] context menu - firewall block
    -   [ ] context menu - remove google drive
    -   [ ] explorer - remove grouping
-   [x] Turn on Windows features
    -   [x] Hyper-V
    -   [x] Virtual Machine Platform
    -   [x] Windows Hypervisor Platform
    -   [x] Windows Sandbox
    -   [x] Windows Subsystem for Linux
    -   [x] WSL2 + install Ubuntu LTS

## ⚠️ WARNING ⚠️

This program **_significantly_** modifies Windows, proceed with caution.

## Atlas `README.md`:

<h1 align="center">
  <img src="https://gcore.jsdelivr.net/gh/Atlas-OS/branding@main/github-banner.png" alt="Atlas" width="800">
</h1>

<p align="center">A transparent and lightweight modification to Windows, designed to optimize performance, privacy and usability.</p>

<p align="center">
  <a href="https://atlasos.net" target="_blank">🌐 Website</a>
  •
  <a href="https://docs.atlasos.net" target="_blank">📚 Documentation</a>
  •
  <a href="https://discord.atlasos.net" target="_blank">☎️ Discord</a>
  •
  <a href="https://forum.atlasos.net" target="_blank">💬 Forum</a>
</p>

## 📚 **Important Documentation**

-   [Installation](https://docs.atlasos.net/getting-started/installation/)
-   [FAQ & Common Issues](https://docs.atlasos.net/faq-and-troubleshooting/removed-features/)
-   [Contribution Guidelines](https://docs.atlasos.net/contributions/)
-   [Branding](https://docs.atlasos.net/branding/)

## 🤔 What is Atlas?
Atlas is an open-source project that enhances Windows by eliminating factors negatively impacting gaming performance. Optimizations include enhanced privacy, usability, performance, and changes for minimal stutters and input lag while focusing on maintaining functionality.

## 👀 Why Atlas?

### 🔒 Enhanced Privacy

Atlas removes the majority of telemetry embedded within Windows and implements numerous group policies to minimize data collection. However, it cannot ensure privacy outside the scope of Windows, such as browsers and other third-party applications.

### 📈 Optimized Performance
Atlas strikes a balance between performance and compatibility. It implements numerous meaningful changes to improve Windows performance and responsiveness without breaking essential features. Atlas will not do tweaks for a placebo effect or marginal gains, making Atlas more stable and compatible.

### 🛡️ Security Features
Most Windows modifications remove key security features most users need to maintain a secure system. On the other hand, Atlas allows users to customize their security at their own risk while informing users about each option's [pros and cons](https://docs.atlasos.net/getting-started/post-installation/atlas-folder/security/).

Some optional security features are:

- Windows Defender & SmartScreen
- Windows Update
  - Automatic updates are togglable
- CPU mitigations
- User Account Control
- Core isolation features

### ✅ Increased Usability
Atlas applies many modifications and default settings to make Windows easier to use. This includes removing commonly unneeded applications (which are reinstallable), configuring many aspects of the interface, disabling advertisements, and much more.

### 🔍 Open Source and Transparent

Unlike custom Windows ISOs, Atlas is more straightforward to audit due to the use of [AME Wizard](https://ameliorated.io). AME Wizard is controlled by Playbooks, a customizable script-esque system that can perform various tasks.

Playbooks are renamed **.zip** archives, with the password [`malte`](https://docs.ameliorated.io/developers/getting-started/creation.html). As they primarily consist of plain text, Playbooks enable transparency, unlike custom Windows ISOs, which have many entry points for malicious activity. The few binaries in the Playbook are open source in our [`utilities` repository](https://github.com/Atlas-OS/utilities), with the [hashes listed here](https://github.com/Atlas-OS/Atlas/blob/main/src/playbook/Executables/AtlasModules/README.md).

Although the GUI is not open source for AME Wizard, AME Wizard's entire backend (called [TrustedUninstaller](https://github.com/Ameliorated-LLC/trusted-uninstaller-cli)) is open source under MIT, which contains each action used to run Atlas. The Atlas Playbook is open source under the [GPLv3 license](https://github.com/Atlas-OS/Atlas/blob/main/LICENSE).

### 🔒 Legal Compliance
As Atlas doesn't redistribute a modified Windows ISO, it complies with [Windows's Usage Terms](https://www.microsoft.com/en-us/Useterms/Retail/Windows/10/UseTerms_Retail_Windows_10_English.htm). In addition, Atlas does not alter activation in Windows.

## 🎨 Brand kit

Want to create your own Atlas wallpaper with some original creative designs? Download our brand kit [here](https://github.com/Atlas-OS/branding/archive/refs/heads/main.zip) and share your creations on our [forum](https://forum.atlasos.net/t/art-showcase).
