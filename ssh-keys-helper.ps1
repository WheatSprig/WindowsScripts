# 生成/管理 SSH 密钥 —— PowerShell 2.0+
# 作者：maisui
# 日期：2025-08-29

# 建立 .ssh 目录
$sshDir = "$env:USERPROFILE\.ssh"
if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir > $null
}

# 主菜单
function ShowMenu {
    Write-Host "=============================="
    Write-Host "  请选择操作："
    Write-Host "  1. 生成 SSH 密钥"
    Write-Host "  2. 删除现有 SSH 密钥"
    Write-Host "  3. 由私钥生成公钥"
    Write-Host "  4. 退出"
    Write-Host "=============================="
}

# 生成密钥
function GenerateSSHKey {
    Write-Host "`n请选择要生成的密钥类型："
    Write-Host "1) RSA 4096-bit"
    Write-Host "2) Ed25519"
    $choice = Read-Host "输入 1 或 2"

    if ($choice -eq "1") {
        $keyType = "rsa"
        $keyFile = "$sshDir\id_rsa"
        $bits = "-b 4096"
    } elseif ($choice -eq "2") {
        $keyType = "ed25519"
        $keyFile = "$sshDir\id_ed25519"
        $bits = ""
    } else {
        Write-Host "无效输入，返回主菜单……"
        return
    }

    $email = Read-Host "邮箱（留空使用 $($env:USERNAME)@$($env:COMPUTERNAME)）"
    if ($email -eq "") {
        $email = "$env:USERNAME@$env:COMPUTERNAME"
    }

    Write-Host "`n正在生成 $keyType 密钥……"
    $cmd = "ssh-keygen -t $keyType $bits -f `"$keyFile`" -N `"`" -C `"$email`""
    cmd /c $cmd

    # 设置权限（Win7 可能没 icacls，可跳过）
    if (Get-Command icacls -ErrorAction SilentlyContinue) {
        icacls "`"$keyFile`"" /inheritance:r /grant:r "$($env:USERNAME):(F)" > $null
    }

    Write-Host "`n公钥内容如下（请复制到服务器）："
    Get-Content "$keyFile.pub"
    Read-Host "`n按 Enter 返回主菜单"
}

# 删除密钥
function DeleteSSHKey {
    Write-Host "`n请选择要删除的密钥："
    Write-Host "1) RSA"
    Write-Host "2) Ed25519"
    $choice = Read-Host "输入 1 或 2"

    if ($choice -eq "1") {
        $file = "$sshDir\id_rsa"
    } elseif ($choice -eq "2") {
        $file = "$sshDir\id_ed25519"
    } else {
        Write-Host "无效输入，返回主菜单……"
        return
    }

    if (Test-Path $file) {
        Remove-Item $file, "$file.pub" -Force
        Write-Host "已删除 $file 及其公钥"
    } else {
        Write-Host "文件不存在：$file"
    }
    Read-Host "`n按 Enter 返回主菜单"
}

# 由私钥生成公钥
function GenPubFromPriv {
    $priv = Read-Host "`n请输入私钥完整路径"
    if (-not (Test-Path $priv)) {
        Write-Host "文件不存在：$priv"
        Read-Host "按 Enter 返回"
        return
    }
    $pub = "$priv.pub"
    cmd /c "ssh-keygen -y -f `"$priv`" > `"$pub`""
    Write-Host "`n公钥已生成：$pub"
    Get-Content $pub
    Read-Host "`n按 Enter 返回主菜单"
}

# 主循环
do {
    ShowMenu
    $op = Read-Host "请输入 1-4"
    switch ($op) {
        "1" { GenerateSSHKey }
        "2" { DeleteSSHKey }
        "3" { GenPubFromPriv }
        "4" { Write-Host "再见！"; exit }
        default { Write-Host "无效输入，请重试" }
    }
} while ($true)