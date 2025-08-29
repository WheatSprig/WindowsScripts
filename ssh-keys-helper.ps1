# ����/���� SSH ��Կ ���� PowerShell 2.0+
# ���ߣ�maisui
# ���ڣ�2025-08-29

# ���� .ssh Ŀ¼
$sshDir = "$env:USERPROFILE\.ssh"
if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir > $null
}

# ���˵�
function ShowMenu {
    Write-Host "=============================="
    Write-Host "  ��ѡ�������"
    Write-Host "  1. ���� SSH ��Կ"
    Write-Host "  2. ɾ������ SSH ��Կ"
    Write-Host "  3. ��˽Կ���ɹ�Կ"
    Write-Host "  4. �˳�"
    Write-Host "=============================="
}

# ������Կ
function GenerateSSHKey {
    Write-Host "`n��ѡ��Ҫ���ɵ���Կ���ͣ�"
    Write-Host "1) RSA 4096-bit"
    Write-Host "2) Ed25519"
    $choice = Read-Host "���� 1 �� 2"

    if ($choice -eq "1") {
        $keyType = "rsa"
        $keyFile = "$sshDir\id_rsa"
        $bits = "-b 4096"
    } elseif ($choice -eq "2") {
        $keyType = "ed25519"
        $keyFile = "$sshDir\id_ed25519"
        $bits = ""
    } else {
        Write-Host "��Ч���룬�������˵�����"
        return
    }

    $email = Read-Host "���䣨����ʹ�� $($env:USERNAME)@$($env:COMPUTERNAME)��"
    if ($email -eq "") {
        $email = "$env:USERNAME@$env:COMPUTERNAME"
    }

    Write-Host "`n�������� $keyType ��Կ����"
    $cmd = "ssh-keygen -t $keyType $bits -f `"$keyFile`" -N `"`" -C `"$email`""
    cmd /c $cmd

    # ����Ȩ�ޣ�Win7 ����û icacls����������
    if (Get-Command icacls -ErrorAction SilentlyContinue) {
        icacls "`"$keyFile`"" /inheritance:r /grant:r "$($env:USERNAME):(F)" > $null
    }

    Write-Host "`n��Կ�������£��븴�Ƶ�����������"
    Get-Content "$keyFile.pub"
    Read-Host "`n�� Enter �������˵�"
}

# ɾ����Կ
function DeleteSSHKey {
    Write-Host "`n��ѡ��Ҫɾ������Կ��"
    Write-Host "1) RSA"
    Write-Host "2) Ed25519"
    $choice = Read-Host "���� 1 �� 2"

    if ($choice -eq "1") {
        $file = "$sshDir\id_rsa"
    } elseif ($choice -eq "2") {
        $file = "$sshDir\id_ed25519"
    } else {
        Write-Host "��Ч���룬�������˵�����"
        return
    }

    if (Test-Path $file) {
        Remove-Item $file, "$file.pub" -Force
        Write-Host "��ɾ�� $file ���乫Կ"
    } else {
        Write-Host "�ļ������ڣ�$file"
    }
    Read-Host "`n�� Enter �������˵�"
}

# ��˽Կ���ɹ�Կ
function GenPubFromPriv {
    $priv = Read-Host "`n������˽Կ����·��"
    if (-not (Test-Path $priv)) {
        Write-Host "�ļ������ڣ�$priv"
        Read-Host "�� Enter ����"
        return
    }
    $pub = "$priv.pub"
    cmd /c "ssh-keygen -y -f `"$priv`" > `"$pub`""
    Write-Host "`n��Կ�����ɣ�$pub"
    Get-Content $pub
    Read-Host "`n�� Enter �������˵�"
}

# ��ѭ��
do {
    ShowMenu
    $op = Read-Host "������ 1-4"
    switch ($op) {
        "1" { GenerateSSHKey }
        "2" { DeleteSSHKey }
        "3" { GenPubFromPriv }
        "4" { Write-Host "�ټ���"; exit }
        default { Write-Host "��Ч���룬������" }
    }
} while ($true)