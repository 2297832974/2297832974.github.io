@echo off
setlocal

set SCRIPT_DIR=%~dp0
set PREFERRED_PORT=8080
if not "%1"=="" set PREFERRED_PORT=%1

echo Starting token-buy LAN server...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%serve_web.ps1" -PreferredPort %PREFERRED_PORT%
set EXIT_CODE=%ERRORLEVEL%

if not "%EXIT_CODE%"=="0" (
  echo.
  echo Server failed with exit code %EXIT_CODE%.
  echo Press any key to close this window.
  pause >nul
)

exit /b %EXIT_CODE%
