

$commitCount = git rev-list --count HEAD
$currentVersion = ""
$currentVersionWithoutPatch = ""

# Get current version in playbook.conf
$content = Get-Content -Path "../src/playbook/playbook.conf" -Raw
if ($content -match "v\d+\.\d+\.\d+") {
    $currentVersion = $Matches[0] -replace 'v', ''
}
else {
    Write-Output "No version string found."
    exit 1
}
if ($content -match "v\d+\.\d+") {
    $currentVersionWithoutPatch = $Matches[0] -replace 'v', ''
}

# New version string
$version = "${currentVersionWithoutPatch}.${commitCount}"

if ($currentVersion -eq $version) {
    Write-Output "No version change."
    exit 1
}

Write-Output "Version  $currentVersion => $version"

# Update any occurrences of version string in all files
$searchTerm = $currentVersion
$replaceTerm = $version
$fileTypes = @("*.conf", "*.yml", "*.yaml")
$rootPath = "../"

Get-ChildItem -Path $rootPath -Recurse -Include $fileTypes | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $newContent = $content -replace $searchTerm, $replaceTerm
    if ($content -ne $newContent) {
        Set-Content -Path $_.FullName -Value $newContent
    }
}
