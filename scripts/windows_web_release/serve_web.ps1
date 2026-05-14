param(
  [int]$PreferredPort = 8080
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$webRoot = Join-Path $scriptDir "web"
$statePath = Join-Path $scriptDir "server_state.json"

if (-not (Test-Path $webRoot)) {
  Write-Host "Web root not found: $webRoot" -ForegroundColor Red
  exit 1
}

function Get-LanIp {
  $addresses = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object {
      $_.IPAddress -notlike '127.*' -and
      $_.IPAddress -notlike '169.254.*' -and
      $_.PrefixOrigin -ne 'WellKnown'
    } |
    Sort-Object InterfaceMetric, SkipAsSource

  if ($addresses) {
    return $addresses[0].IPAddress
  }

  return $null
}

function Get-ContentType([string]$path) {
  switch ([System.IO.Path]::GetExtension($path).ToLowerInvariant()) {
    ".html" { return "text/html; charset=utf-8" }
    ".js" { return "application/javascript; charset=utf-8" }
    ".css" { return "text/css; charset=utf-8" }
    ".json" { return "application/json; charset=utf-8" }
    ".png" { return "image/png" }
    ".jpg" { return "image/jpeg" }
    ".jpeg" { return "image/jpeg" }
    ".svg" { return "image/svg+xml" }
    ".ico" { return "image/x-icon" }
    ".wasm" { return "application/wasm" }
    ".txt" { return "text/plain; charset=utf-8" }
    ".map" { return "application/json; charset=utf-8" }
    default { return "application/octet-stream" }
  }
}

function Get-ServerState {
  if (-not (Test-Path $statePath)) {
    return $null
  }

  try {
    return Get-Content -Path $statePath -Raw | ConvertFrom-Json
  } catch {
    return $null
  }
}

function Remove-ServerState {
  if (Test-Path $statePath) {
    Remove-Item $statePath -Force -ErrorAction SilentlyContinue
  }
}

function Test-ProcessAlive([int]$processId) {
  return $null -ne (Get-Process -Id $processId -ErrorAction SilentlyContinue)
}

function Test-PortBoundToProcess([int]$port, [int]$processId) {
  $bound = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
    Where-Object { $_.OwningProcess -eq $processId } |
    Select-Object -First 1

  return $null -ne $bound
}

function Stop-PreviousServer {
  $existingState = Get-ServerState
  if (-not $existingState) {
    return
  }

  $statePid = 0
  $statePort = 0

  try { $statePid = [int]$existingState.pid } catch {}
  try { $statePort = [int]$existingState.port } catch {}

  if ($statePid -gt 0 -and (Test-ProcessAlive $statePid)) {
    Write-Host "Stopping previous token-buy server process: $statePid" -ForegroundColor Yellow
    Stop-Process -Id $statePid -Force -ErrorAction SilentlyContinue

    for ($i = 0; $i -lt 20; $i++) {
      if (-not (Test-ProcessAlive $statePid)) {
        break
      }
      Start-Sleep -Milliseconds 100
    }
  }

  Remove-ServerState
}

function Test-PortAvailable([int]$port) {
  try {
    $probe = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $port)
    $probe.Start()
    $probe.Stop()
    return $true
  } catch {
    return $false
  }
}

function Resolve-Port([int]$preferredPort) {
  if (Test-PortAvailable $preferredPort) {
    return $preferredPort
  }

  for ($candidate = $preferredPort + 1; $candidate -le $preferredPort + 50; $candidate++) {
    if (Test-PortAvailable $candidate) {
      return $candidate
    }
  }

  throw "No available port found between $preferredPort and $($preferredPort + 50)."
}

function Resolve-TargetPath([string]$absolutePath) {
  $relativePath = [System.Uri]::UnescapeDataString($absolutePath.TrimStart('/'))
  if ([string]::IsNullOrWhiteSpace($relativePath)) {
    $relativePath = "index.html"
  }

  $targetPath = Join-Path $webRoot $relativePath

  if ((Test-Path $targetPath) -and (Get-Item $targetPath) -is [System.IO.DirectoryInfo]) {
    $targetPath = Join-Path $targetPath "index.html"
  }

  if (-not (Test-Path $targetPath)) {
    $targetPath = Join-Path $webRoot "index.html"
  }

  return $targetPath
}

function Write-HttpResponse(
  [System.Net.Sockets.NetworkStream]$stream,
  [int]$statusCode,
  [string]$statusText,
  [byte[]]$body,
  [string]$contentType
) {
  $header = "HTTP/1.1 $statusCode $statusText`r`n" +
    "Content-Type: $contentType`r`n" +
    "Content-Length: $($body.Length)`r`n" +
    "Cache-Control: no-cache`r`n" +
    "Connection: close`r`n`r`n"

  $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
  $stream.Write($headerBytes, 0, $headerBytes.Length)
  $stream.Write($body, 0, $body.Length)
}

Stop-PreviousServer

$Port = Resolve-Port $PreferredPort
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $Port)
$listener.Start()

$lanIp = Get-LanIp

@{
  pid = $PID
  port = $Port
  lanIp = $lanIp
  startedAt = (Get-Date).ToString("o")
} | ConvertTo-Json | Set-Content -Path $statePath -Encoding UTF8

Write-Host "token-buy LAN server is running." -ForegroundColor Green
if ($Port -ne $PreferredPort) {
  Write-Host "Preferred port $PreferredPort was busy. Switched to $Port." -ForegroundColor Yellow
}
if ($lanIp) {
  Write-Host "Phone URL: http://$lanIp`:$Port" -ForegroundColor Cyan
} else {
  Write-Host "Phone URL: http://<windows-lan-ip>:$Port" -ForegroundColor Yellow
  Write-Host "Tip: run ipconfig if the LAN IP was not detected automatically." -ForegroundColor Yellow
}
Write-Host "Local URL: http://localhost:$Port" -ForegroundColor Gray
Write-Host "Press Ctrl+C to stop the server." -ForegroundColor Gray
Write-Host ""

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()

    try {
      $stream = $client.GetStream()
      $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::ASCII, $false, 8192, $true)

      $requestLine = $reader.ReadLine()
      if ([string]::IsNullOrWhiteSpace($requestLine)) {
        continue
      }

      while ($true) {
        $line = $reader.ReadLine()
        if ([string]::IsNullOrEmpty($line)) {
          break
        }
      }

      $parts = $requestLine.Split(' ')
      if ($parts.Length -lt 2) {
        $body = [System.Text.Encoding]::UTF8.GetBytes("Bad Request")
        Write-HttpResponse -stream $stream -statusCode 400 -statusText "Bad Request" -body $body -contentType "text/plain; charset=utf-8"
        continue
      }

      $method = $parts[0].ToUpperInvariant()
      $absolutePath = $parts[1]

      if ($method -ne "GET" -and $method -ne "HEAD") {
        $body = [System.Text.Encoding]::UTF8.GetBytes("Method Not Allowed")
        Write-HttpResponse -stream $stream -statusCode 405 -statusText "Method Not Allowed" -body $body -contentType "text/plain; charset=utf-8"
        continue
      }

      $targetPath = Resolve-TargetPath $absolutePath
      $contentType = Get-ContentType $targetPath
      $body = if ($method -eq "HEAD") { [byte[]]::new(0) } else { [System.IO.File]::ReadAllBytes($targetPath) }

      Write-HttpResponse -stream $stream -statusCode 200 -statusText "OK" -body $body -contentType $contentType
    } catch {
      if ($stream) {
        $body = [System.Text.Encoding]::UTF8.GetBytes("Internal Server Error")
        Write-HttpResponse -stream $stream -statusCode 500 -statusText "Internal Server Error" -body $body -contentType "text/plain; charset=utf-8"
      }
    } finally {
      if ($reader) {
        $reader.Dispose()
      }
      if ($stream) {
        $stream.Dispose()
      }
      $client.Dispose()
      $reader = $null
      $stream = $null
    }
  }
} finally {
  $listener.Stop()
  $existingState = Get-ServerState
  if ($existingState) {
    $statePid = 0
    try { $statePid = [int]$existingState.pid } catch {}
    if ($statePid -eq $PID) {
      Remove-ServerState
    }
  }
}
