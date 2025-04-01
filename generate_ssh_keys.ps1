# PowerShell 脚本：生成 SSH 密钥（RSA 或 Ed25519）

# 设置 SSH 目录
$sshDir = "$env:USERPROFILE\.ssh"
if (!(Test-Path -Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir | Out-Null
}

# 让用户选择密钥类型
Write-Host "请选择要生成的 SSH 密钥类型："
Write-Host "1. RSA (4096-bit)"
Write-Host "2. Ed25519"
$choice = Read-Host "输入 1 或 2 选择密钥类型"

if ($choice -eq "1") {
    $keyType = "rsa"
    $keyFile = "$sshDir\id_rsa"
    $keyBits = 4096
} elseif ($choice -eq "2") {
    $keyType = "ed25519"
    $keyFile = "$sshDir\id_ed25519"
    $keyBits = $null  # Ed25519 不需要指定位数
} else {
    Write-Host "无效输入，脚本退出。"
    exit
}

# 生成 SSH 密钥
Write-Host "正在生成 $keyType SSH 密钥..."
if ($keyBits) {
    ssh-keygen -t $keyType -b $keyBits -f $keyFile -N ""
} else {
    ssh-keygen -t $keyType -f $keyFile -N ""
}

# 设置正确权限
icacls "$keyFile" /inheritance:r /grant:r "$($env:USERNAME):(F)" | Out-Null
Write-Host "SSH 密钥已生成：$keyFile"
Write-Host "公钥内容如下（请上传到服务器）："
Get-Content "$keyFile.pub"
