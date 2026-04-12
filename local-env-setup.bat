@echo off
SETLOCAL EnableDelayedExpansion

if "%~1"=="" goto :usage
if "%~1"=="up" goto :start_up
if "%~1"=="stop" goto :stop_services
if "%~1"=="down" goto :down_services
if "%~1"=="status" goto :services_status

:usage
echo Usage: local-env-setup.bat [up^|stop^|status^|down]
exit /b 1

:start_up
powershell -Command "Get-ChildItem -Recurse -Include *.sh,*.sql -Exclude .git -ErrorAction SilentlyContinue | ForEach-Object { try { $p = $_.FullName; $t = [System.IO.File]::ReadAllText($p); if ($t -match '\r\n') { [System.IO.File]::WriteAllText($p, ($t -replace '\r\n', \"`n\")) } } catch {} }"
if %errorlevel% neq 0 (
    exit /b 1
)
docker compose up -d
if %errorlevel% neq 0 (
    echo Failure to start containers
    exit /b %errorlevel%
)
goto :eof

:stop_services
docker compose stop
goto :eof

:down_services
docker compose down --volumes --rmi all
goto :eof

:services_status
echo.
echo ENVIRONMENT STATUS:
echo ==========================================
set "FOUND="

for /f "tokens=1,2" %%a in ('docker compose ps -a --format "{{.Name}} {{.Status}}"') do (
    set "NAME=%%a"
    set "STAT=%%b"
    echo !STAT! | findstr /i "Up" >nul
    if !errorlevel! equ 0 (
        echo [UP]   !NAME!
    ) else (
        echo [DOWN] !NAME!
    )
    set "FOUND=1"
)

if not defined FOUND (
    echo [!] No containers found
)
echo ==========================================
goto :eof