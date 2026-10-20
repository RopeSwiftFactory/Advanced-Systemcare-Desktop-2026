# ============================================
#  Initial.ps1 - запуск todo-менеджера на Rust
# ============================================

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$Script = "Initial.rs"
$Exe    = "Initial.exe"

# Проверяем наличие rustc
if (-not (Get-Command rustc -ErrorAction SilentlyContinue)) {
    Write-Host "[ОШИБКА] Rust не установлен или не добавлен в PATH." -ForegroundColor Red
    Write-Host "Скачай с https://rustup.rs и перезапусти терминал."
    exit 1
}

# Проверяем наличие исходника
if (-not (Test-Path $Script)) {
    Write-Host "[ОШИБКА] Файл $Script не найден в текущей папке." -ForegroundColor Red
    exit 1
}

# Компилируем, если .exe нет или исходник новее
$NeedCompile = $false

if (-not (Test-Path $Exe)) {
    $NeedCompile = $true
} else {
    $rsTime  = (Get-Item $Script).LastWriteTime
    $exeTime = (Get-Item $Exe).LastWriteTime
    if ($rsTime -gt $exeTime) {
        $NeedCompile = $true
    }
}

if ($NeedCompile) {
    Write-Host "Компилирую $Script..." -ForegroundColor Cyan
    & rustc $Script -o $Exe
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ОШИБКА] Компиляция не удалась." -ForegroundColor Red
        exit 1
    }
    Write-Host "Готово." -ForegroundColor Green
}

# Запускаем программу со всеми переданными аргументами
if ($args.Count -eq 0) {
    & ".\$Exe"
} else {
    & ".\$Exe" @args
}
