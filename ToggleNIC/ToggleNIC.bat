@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0ToggleNICScript.ps1\"' -Verb RunAs; exit } else { & '%~dp0ToggleNICScript.ps1' }"
