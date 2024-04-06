@echo off

set baseAssociations=".dib:PhotoViewer.FileAssoc.Tiff"^
 ".jfif:PhotoViewer.FileAssoc.Tiff"^
 ".jpe:PhotoViewer.FileAssoc.Tiff"^
 ".jpeg:PhotoViewer.FileAssoc.Tiff"^
 ".jpg:PhotoViewer.FileAssoc.Tiff"^
 ".jxr:PhotoViewer.FileAssoc.Tiff"^
 ".png:PhotoViewer.FileAssoc.Tiff"^
 ".tif:PhotoViewer.FileAssoc.Tiff"^
 ".tiff:PhotoViewer.FileAssoc.Tiff"^
 ".wdp:PhotoViewer.FileAssoc.Tiff"^
 ".url:IE.AssocFile.URL"^
 ".ps1:Microsoft.PowerShellScript.1"

set braveAssociations="Proto:https:BraveHTML"^
 "Proto:http:BraveHTML"^
 ".htm:BraveHTML"^
 ".html:BraveHTML"^
 ".pdf:BraveFile"^
 ".shtml:BraveHTML"

set firefoxAssociations="Proto:https:FirefoxURL-308046B0AF4A39CB"^
 "Proto:http:FirefoxURL-308046B0AF4A39CB"^
 ".htm:FirefoxHTML-308046B0AF4A39CB"^
 ".html:FirefoxHTML-308046B0AF4A39CB"^
 ".pdf:FirefoxPDF-308046B0AF4A39CB"^
 ".shtml:FirefoxHTML-308046B0AF4A39CB"

set chromeAssociations="Proto:https:ChromeHTML"^
 "Proto:http:ChromeHTML"^
 ".htm:ChromeHTML"^
 ".html:ChromeHTML"^
 ".pdf:ChromeHTML"^
 ".shtml:ChromeHTML"

if "%~1" == "" set "associations=%baseAssociations%"
if "%~1" == "Microsoft Edge" set "associations=%baseAssociations%"
if "%~1" == "Brave" set "associations=%baseAssociations% %braveAssociations%"
if "%~1" == "Firefox" set "associations=%baseAssociations% %firefoxAssociations%"
if "%~1" == "Google Chrome" set "associations=%baseAssociations% %chromeAssociations%"

exit /b
