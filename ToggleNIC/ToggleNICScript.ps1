# ����Ƿ��й���ԱȨ�ޣ�û�о��Զ��Թ���Ա��������
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$nic = "��̫��"  # �ĳ����������
$adapter = Get-NetAdapter -Name $nic
if ($adapter.Status -eq "Up") {
    Disable-NetAdapter -Name $nic -Confirm:$false
} else {
    Enable-NetAdapter -Name $nic -Confirm:$false
}

# �ȴ� 2 �룬��״̬ˢ��
Start-Sleep -Seconds 2

# �ٴλ�ȡ����״̬
$adapter = Get-NetAdapter -Name $nic
Write-Host "��ǰ���� [$nic] ״̬: $($adapter.Status)" -ForegroundColor Green

# ���ִ��� 60 ����Զ��ر�
Start-Sleep -Seconds 60