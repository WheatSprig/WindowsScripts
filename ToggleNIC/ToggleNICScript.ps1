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

# ѭ���ȴ������ϻ�ȡ״̬����� 60 ��
$timeout = 60
$elapsed = 0
while ($elapsed -lt $timeout) {
    $adapter = Get-NetAdapter -Name $nic
    Write-Progress -Activity "�ȴ����� [$nic]" `
                   -Status "��ǰ״̬: $($adapter.Status)" `
                   -SecondsRemaining ($timeout - $elapsed)
    Start-Sleep -Seconds 1
    $elapsed++
}
Write-Progress -Activity "�ȴ����� [$nic]" -Completed   # ������ѽ��������
