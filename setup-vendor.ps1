$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$vendor = Join-Path $root "chrome-extension\vendor"

New-Item -ItemType Directory -Force -Path $vendor | Out-Null

$files = @(
  @{
    Url = "https://www.meshy.ai/pt-BR/resource/decrypt/mesh_loader.js"
    Output = "mesh_loader.js"
    Sha256 = "42d6d4823ad0f51d8cd8c393a269065e1eeb9beb84f99d27e7a82b2bdf2da55c"
  },
  @{
    Url = "https://www.meshy.ai/pt-BR/resource/decrypt/mesh_loader.wasm"
    Output = "mesh_loader.wasm"
    Sha256 = "69bb1b1874366d431110470ccc9c53e5a9ef6aeffb9abadf4d33bc9e1a481b58"
  }
)

foreach ($file in $files) {
  $out = Join-Path $vendor $file.Output
  Write-Host "Downloading $($file.Url)"
  Invoke-WebRequest -Uri $file.Url -OutFile $out
  $item = Get-Item -LiteralPath $out
  if ($item.Length -le 0) {
    throw "Downloaded file is empty: $out"
  }
  $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $out).Hash.ToLower()
  if ($actual -ne $file.Sha256) {
    Remove-Item -LiteralPath $out -Force
    Write-Error "SHA-256 mismatch for $out`n  expected: $($file.Sha256)`n  actual:   $actual`nUpstream may have changed. Re-review the file before updating the pinned hash."
    exit 1
  }
  Write-Host "Saved $out ($($item.Length) bytes)"
}

Write-Host "Vendor files are ready."
