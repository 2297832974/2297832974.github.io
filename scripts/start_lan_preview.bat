@echo off
setlocal

set ROOT_DIR=%~dp0..
set HOST=0.0.0.0
if not "%1"=="" set HOST=%1

set PREFERRED_PORT=8080
if not "%2"=="" set PREFERRED_PORT=%2

cd /d "%ROOT_DIR%"

set "PORT="
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "$preferred = %PREFERRED_PORT%; function Test-Port([int]$port) { try { $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $port); $listener.Start(); $listener.Stop(); return $true } catch { return $false } }; if (Test-Port $preferred) { $preferred } else { for ($port = $preferred + 1; $port -le $preferred + 50; $port++) { if (Test-Port $port) { $port; break } } }"`) do (
  set "PORT=%%i"
)

if not defined PORT (
  echo Failed to find an available port near %PREFERRED_PORT%.
  exit /b 1
)

if not "%PORT%"=="%PREFERRED_PORT%" (
  echo Preferred port %PREFERRED_PORT% is busy. Switched to %PORT%.
)

echo Starting Flutter web server on %HOST%:%PORT%

set "LAN_IP="
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "$ip = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' -and $_.PrefixOrigin -ne 'WellKnown' } | Sort-Object InterfaceMetric, SkipAsSource | Select-Object -First 1 -ExpandProperty IPAddress; if ($ip) { $ip }"`) do (
  set "LAN_IP=%%i"
)

if defined LAN_IP (
  echo Phone URL: http://%LAN_IP%:%PORT%
) else (
  echo Phone URL: http://^<windows-lan-ip^>:%PORT%
  echo Tip: run ipconfig if the LAN IP was not detected automatically.
)

call fvm flutter run -d web-server --web-hostname %HOST% --web-port %PORT%
