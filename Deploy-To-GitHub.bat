@echo off
:: This is a Launcher for the PowerShell script.
:: It uses -NoExit to GUARANTEE the window stays open so you can see potential errors.
PowerShell -NoProfile -ExecutionPolicy Bypass -NoExit -File "%~dp0Deploy-Loader.ps1"
pause
