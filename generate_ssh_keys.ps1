# PowerShell 脚本：生成 SSH 密钥（RSA 或 Ed25519）

# 检查 PowerShell 版本
$version = $PSVersionTable.PSVersion
if ($version.Major -lt 7) {
    Write-Host "最低要求 PowerShell 7.0，当前版本为 $($version.Major).$($version.Minor).$($version.Build)，脚本退出。"
    exit
}

# 设置 SSH 目录
$sshDir = "$env:USERPROFILE\.ssh"
if (!(Test-Path -Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir | Out-Null
}

# 主菜单函数
function Show-Menu {
    Clear-Host
    Write-Host "请选择操作："
    Write-Host "1. 生成 SSH 密钥"
    Write-Host "2. 删除现有 SSH 密钥"
    Write-Host "3. 根据现有密钥生成公钥"
    Write-Host "4. 退出"
}

# 生成 SSH 密钥的函数
function Generate-SSHKey {
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
        Write-Host "无效输入，返回主菜单。"
        return
    }

    # 可选输入邮箱
    $email = Read-Host "请输入邮箱地址（留空则使用默认：$env:USERNAME@$env:COMPUTERNAME）"
    if ([string]::IsNullOrWhiteSpace($email)) {
        $email = "$env:USERNAME@$env:COMPUTERNAME"
    }

    # 生成 SSH 密钥
    Write-Host "正在生成 $keyType SSH 密钥..."
    if ($keyBits) {
        ssh-keygen -t $keyType -b $keyBits -f $keyFile -N "" -C $email
    } else {
        ssh-keygen -t $keyType -f $keyFile -N "" -C $email
    }

    # 设置正确权限
    icacls "$keyFile" /inheritance:r /grant:r "$($env:USERNAME):(F)" | Out-Null
    Write-Host "SSH 密钥已生成：$keyFile"
    Write-Host "公钥内容如下（请上传到服务器）："
    Get-Content "$keyFile.pub"

    Read-Host "按任意键返回主菜单"
}

# 删除 SSH 密钥的函数
function Delete-SSHKey {
    Write-Host "请选择要删除的密钥："
    Write-Host "1. 删除 RSA 密钥"
    Write-Host "2. 删除 Ed25519 密钥"
    $deleteChoice = Read-Host "输入 1 或 2"

    if ($deleteChoice -eq "1") {
        $keyFile = "$sshDir\id_rsa"
        $keyFilePub = "$keyFile.pub"
    } elseif ($deleteChoice -eq "2") {
        $keyFile = "$sshDir\id_ed25519"
        $keyFilePub = "$keyFile.pub"
    } else {
        Write-Host "无效输入，返回主菜单。"
        return
    }

    if (Test-Path $keyFile) {
        Remove-Item $keyFile, $keyFilePub -Force
        Write-Host "已删除密钥：$keyFile"
    } else {
        Write-Host "密钥文件不存在：$keyFile"
    }

    Read-Host "按任意键返回主菜单"
}

# 根据现有密钥生成公钥的函数
function Generate-PublicKeyFromPrivateKey {
    Write-Host "请输入现有私钥的路径（例如：C:\Users\用户名\.ssh\id_rsa）："
    $privateKeyPath = Read-Host

    if (Test-Path $privateKeyPath) {
        $publicKeyPath = "$privateKeyPath.pub"
        ssh-keygen -y -f $privateKeyPath > $publicKeyPath
        Write-Host "公钥已生成：$publicKeyPath"
        Get-Content $publicKeyPath
    } else {
        Write-Host "指定的私钥文件不存在：$privateKeyPath"
    }

    Read-Host "按任意键返回主菜单"
}

# 主菜单循环
do {
    Show-Menu
    $operation = Read-Host "输入 1、2、3 或 4"

    if ($operation -eq "1") {
        Generate-SSHKey
    } elseif ($operation -eq "2") {
        Delete-SSHKey
    } elseif ($operation -eq "3") {
        Generate-PublicKeyFromPrivateKey
    } elseif ($operation -eq "4") {
        Write-Host "退出脚本。"
        exit
    } else {
        Write-Host "无效输入，请重新选择。"
    }
} while ($operation -ne "4")
