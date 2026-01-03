# Deploy-Loader.ps1
# Pure PowerShell Logic for GitHub Auto-Deploy
$ErrorActionPreference = "Stop"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   GITHUB AUTO-DEPLOY TOOL (PowerShell Core)" -ForegroundColor Cyan
Write-Host "   Stable | Auto-Detect User | Error-Safe" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Inputs
$token = (Read-Host "Enter GitHub Token (PAT)").Trim()
if ([string]::IsNullOrWhiteSpace($token)) { Write-Error "Token cannot be empty."; exit }

$repoName = (Read-Host "Enter New Repository Name (e.g. rshgs)").Trim()
if ([string]::IsNullOrWhiteSpace($repoName)) { Write-Error "Repository Name cannot be empty."; exit }

Write-Host "`n[1/5] Authenticating..." -ForegroundColor Yellow
try {
    $headers = @{Authorization = "token $token"}
    $user = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers
    $username = $user.login
    Write-Host "   Success! Logged in as: $username" -ForegroundColor Green
} catch {
    Write-Error "Authentication Failed! Check your Token."
    exit
}

Write-Host "`n[2/5] Cleaning old Git config..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Remove-Item -Path ".git" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "   Old .git folder removed." -ForegroundColor Gray
}

Write-Host "`n[3/5] Creating Repository '$repoName'..." -ForegroundColor Yellow
try {
    $body = @{name = $repoName; private = $false} | ConvertTo-Json
    Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body | Out-Null
    Write-Host "   Repository created successfully!" -ForegroundColor Green
} catch {
    Write-Warning "   Repo creation failed (Using existing repo if available)..."
}

Write-Host "`n[4/5] Initializing Git..." -ForegroundColor Yellow
git init | Out-Null
git branch -M main | Out-Null

Write-Host "`n[5/5] Pushing to GitHub..." -ForegroundColor Yellow
git add . | Out-Null
git commit -m "Auto-Restore via Deploy Tool" | Out-Null

$remoteUrl = "https://${username}:${token}@github.com/${username}/${repoName}.git"
git remote add origin $remoteUrl
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================================" -ForegroundColor Green
    Write-Host "   SUCCESS! Project deployed to:" -ForegroundColor Green
    Write-Host "   https://github.com/$username/$repoName" -ForegroundColor White
    Write-Host "========================================================" -ForegroundColor Green
} else {
    Write-Error "Push failed. Please check your internet connection."
}
