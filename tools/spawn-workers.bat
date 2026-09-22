@echo off
REM ══════════════════════════════════════════════════════════════
REM  ABSENT worker farm (Windows) — spawn fresh links, free plan
REM
REM  One-time setup:
REM    1. Free Cloudflare account: https://dash.cloudflare.com/sign-up
REM    2. My Profile - API Tokens - Create Token - "Edit Cloudflare Workers" template
REM    3. In this window:   set CLOUDFLARE_API_TOKEN=paste-your-token
REM
REM  Usage:
REM    spawn-workers.bat          (spawns 10)
REM    spawn-workers.bat 25       (spawns 25)
REM ══════════════════════════════════════════════════════════════
setlocal enabledelayedexpansion
cd /d "%~dp0.."

set COUNT=%1
if "%COUNT%"=="" set COUNT=10

where npx >nul 2>nul
if errorlevel 1 (
  echo [!] npx not found - install Node.js first: https://nodejs.org
  pause & exit /b 1
)

if not defined CLOUDFLARE_API_TOKEN (
  echo [!] CLOUDFLARE_API_TOKEN is not set.
  echo     Fix:   set CLOUDFLARE_API_TOKEN=paste-your-token
  echo     ^(create it: Cloudflare dashboard - My Profile - API Tokens - "Edit Cloudflare Workers" template^)
  echo     Or log in once instead:   npx wrangler login
  pause & exit /b 1
)

echo ════════════════════════════════════════════
echo  † ABSENT worker farm - spawning %COUNT% link^(s^)
echo ════════════════════════════════════════════

if not exist tools mkdir tools
if not exist tools\links.txt type nul > tools\links.txt

for /l %%i in (1,1,%COUNT%) do (
  set "N=absent-!RANDOM!!RANDOM!"
  echo [%%i/%COUNT%] deploying !N! ...
  call npx wrangler deploy --name !N!
  findstr /c:"!N!." tools\links.txt >nul 2>nul || echo !N! >> tools\links.txt
)

echo.
echo Done - copy the https://absent-xxxxx.YOURSUB.workers.dev links above.
echo They are also listed in tools\links.txt
echo Blocked later? Delete one to free a slot:   npx wrangler delete --name absent-xxxxx
pause
