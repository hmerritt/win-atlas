@REM Enable windows features.
@REM RESTART after running this script to complete the installation.
DISM.exe /Online /Enable-Feature /FeatureName:"DirectPlay" /NoRestart /All
DISM.exe /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-amd64" /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:"Printing-Foundation-Features" /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:"Printing-Foundation-InternetPrinting-Client" /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:"Printing-XPSServices-Features" /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:"Printing-PrintToPDFServices-Features" /NoRestart

DISM.exe /Online /Enable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2Root" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Hypervisor" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Services" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"HypervisorPlatform" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"VirtualMachinePlatform" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Containers-DisposableClientVM" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Containers" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Containers-HNS" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Containers-SDN" /NoRestart /All
DISM.exe /Online /Enable-Feature /FeatureName:"Microsoft-Windows-Subsystem-Linux" /NoRestart /All
