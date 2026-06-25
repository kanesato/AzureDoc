& "$AzCopyExe" copy "C:\temp\pic2.png" "https://demoyunas.blob.core.windows.net/installer/ApexOne/pic2.png"

# ------------------------------
# ------------------------------
# ------------------------------
# AzCopy を ダウンロードする
$AzCopyRoot = "C:\Tools\AzCopy"

$AzCopyZip  = Join-Path $env:TEMP "azcopy.zip"

New-Item -ItemType Directory -Path $AzCopyRoot -Force | Out-Null

Invoke-WebRequest `
  -Uri "https://aka.ms/downloadazcopy-v10-windows" `
  -OutFile $AzCopyZip

Expand-Archive `
  -Path $AzCopyZip `
  -DestinationPath $AzCopyRoot `
  -Force

$AzCopyExe = Get-ChildItem `
  -Path $AzCopyRoot `
  -Recurse `
  -Filter "azcopy.exe" `
  -File |
  Select-Object -First 1 -ExpandProperty FullName

Write-Host "AzCopy path: $AzCopyExe"

if ([string]::IsNullOrWhiteSpace($AzCopyExe)) {
    throw "azcopy.exe が見つかりません。AzCopy のダウンロードまたは展開に失敗しています。"
}

& "$AzCopyExe" --version
# ------------------------------

# ------------------------------
# ------------------------------
# ------------------------------
$TenantId = "05e28a54-34cc-4224-98a9-9af618d22132"

& "$AzCopyExe" logout
& "$AzCopyExe" login --tenant-id $TenantId
& "$AzCopyExe" login status

# ↓
# INFO: You have successfully refreshed your token. Your login session is still active
# ------------------------------


# ------------------------------
# ------------------------------
# ------------------------------
# AzCopy バージョン確認
& "$AzCopyExe" --version
# ------------------------------


# ---------------------
# --- AzCopy Upload ---
# ---------------------
# パラメーター設定（必要に応じて修正）
$AzCopyRoot = "C:\Tools\AzCopy"
$StorageAccount = "demoyunas"
$Container = "installer"
$SourceFileName = "python-3.12.8-amd64.exe"
$SourceFilePath = "C:\temp\"
$ContainerPath = "ApexOne"

# コピー元・先情報設定
$DestUrl = "https://$StorageAccount.blob.core.windows.net/$Container/$ContainerPath/$SourceFileName"
$SourceFile = "$SourceFilePath$SourceFileName"

# AzCopy パスの取得
$AzCopyExe = Get-ChildItem `
-Path $AzCopyRoot `
-Recurse `
-Filter "azcopy.exe" `
-File |
Select-Object -First 1 -ExpandProperty FullName

if ([string]::IsNullOrWhiteSpace($AzCopyExe)) {
throw "azcopy.exe が見つかりません。C:\Tools\AzCopy 配下を確認してください。"
}

# AzCopy 実行
& "$AzCopyExe" copy "$SourceFile" "$DestUrl"
# ------------------------

# ------------------------
# --- AzCopy Download ----
# ------------------------
# パラメーター設定
# ダウンロード先フォルダ作成
$DownloadDir = "C:\Tools"
# Storage / Blob 情報
$StorageAccount = "demoyunas"
$Container = "installer"
$ContainerPath = "ApexOne"
$SourceFileName = "python-3.12.8-amd64.exe"

New-Item -ItemType Directory -Path $DownloadDir -Force | Out-Null

$SourceUrl = "https://$StorageAccount.blob.core.windows.net/$Container/$ContainerPath/$SourceFileName"
$DestinationFile = "$DownloadDir\$SourceFileName"

# ログイン状態確認
& "$AzCopyExe" login status

# ダウンロード実行
& "$AzCopyExe" copy "$SourceUrl" "$DestinationFile"

# ダウンロード結果確認
Get-ChildItem "$DownloadDir\$SourceFileName"

# ハッシュ確認
Get-FileHash "$DownloadDir\$SourceFileName" -Algorithm SHA256


