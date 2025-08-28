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

# 等待 2 秒，让状态刷新
Start-Sleep -Seconds 2

# 再次获取网卡状态
$adapter = Get-NetAdapter -Name $nic
Write-Host "当前网卡 [$nic] 状态: $($adapter.Status)" -ForegroundColor Green

# 保持窗口 60 秒后自动关闭
Start-Sleep -Seconds 60