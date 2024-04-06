@echo off

set baseAssociations=".url:InternetShortcut"

set braveAssociations="Proto:https:BraveHTML"^
 "Proto:http:BraveHTML"^
 ".htm:BraveHTML"^
 ".html:BraveHTML"^
 ".pdf:BraveFile"^
 ".shtml:BraveHTML"

set libreWolfAssociations="Proto:https:LibreWolfHTM"^
 "Proto:http:LibreWolfHTM"^
 ".htm:LibreWolfHTM"^
 ".html:LibreWolfHTM"^
 ".pdf:LibreWolfHTM"^
 ".shtml:LibreWolfHTM"

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
if "%~1" == "LibreWolf" set "associations=%baseAssociations% %libreWolfAssociations%"
if "%~1" == "Firefox" set "associations=%baseAssociations% %firefoxAssociations%"
if "%~1" == "Google Chrome" set "associations=%baseAssociations% %chromeAssociations%"

exit /b
