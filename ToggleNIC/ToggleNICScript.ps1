# 检查是否有管理员权限，没有就自动以管理员重新运行
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$nic = "以太网"  # 改成你的网卡名
$adapter = Get-NetAdapter -Name $nic
if ($adapter.Status -eq "Up") {
    Disable-NetAdapter -Name $nic -Confirm:$false
} else {
    Enable-NetAdapter -Name $nic -Confirm:$false
}

# 循环等待并不断获取状态，最多 60 秒
$timeout = 60
$elapsed = 0
while ($elapsed -lt $timeout) {
    $adapter = Get-NetAdapter -Name $nic
    Write-Host "`r[$elapsed s] 当前网卡 [$nic] 状态: $($adapter.Status)" -NoNewline -ForegroundColor Green
    Start-Sleep -Seconds 1
    $elapsed++
}
Write-Host ""   # 结束后换一行，避免把提示符挤到行尾
