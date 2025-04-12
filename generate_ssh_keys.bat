@echo off
setlocal enabledelayedexpansion

:: ���� SSH Ŀ¼
set "sshDir=%USERPROFILE%\.ssh"
if not exist "%sshDir%" (
    mkdir "%sshDir%"
)

:menu
cls
echo ��ѡ�������
echo 1. ���� SSH ��Կ
echo 2. ɾ������ SSH ��Կ
echo 3. ����˽Կ���ɹ�Կ
echo 4. �˳�
set /p choice=���� 1��2��3 �� 4��

if "%choice%"=="1" goto genkey
if "%choice%"=="2" goto delkey
if "%choice%"=="3" goto genpub
if "%choice%"=="4" goto end

echo ��Ч����
pause
goto menu

:genkey
cls
echo ѡ��Ҫ���ɵ���Կ���ͣ�
echo 1. RSA (4096-bit)
echo 2. Ed25519
set /p type=���� 1 �� 2��

if "%type%"=="1" (
    set "keytype=rsa"
    set "keyfile=%sshDir%\id_rsa"
    set "bits=-b 4096"
) else if "%type%"=="2" (
    set "keytype=ed25519"
    set "keyfile=%sshDir%\id_ed25519"
    set "bits="
) else (
    echo ��Ч����
    pause
    goto menu
)

set /p email=���������䣨Ĭ�� %USERNAME%@%COMPUTERNAME%����
if "%email%"=="" set "email=%USERNAME%@%COMPUTERNAME%"

echo �������� %keytype% ��Կ...
ssh-keygen -t %keytype% %bits% -f "%keyfile%" -N "" -C "%email%"

:: ����Ȩ�ޣ��Ǳ�Ҫ�����Ƽ���
icacls "%keyfile%" /inheritance:r /grant:r "%USERNAME%:F" >nul

echo ��Կ�����ɣ�%keyfile%
echo ��Կ���£�
type "%keyfile%.pub"

pause
goto menu

:delkey
cls
echo ѡ��Ҫɾ������Կ���ͣ�
echo 1. RSA
echo 2. Ed25519
set /p deltype=���� 1 �� 2��

if "%deltype%"=="1" (
    set "keyfile=%sshDir%\id_rsa"
) else if "%deltype%"=="2" (
    set "keyfile=%sshDir%\id_ed25519"
) else (
    echo ��Ч����
    pause
    goto menu
)

if exist "%keyfile%" (
    del /f /q "%keyfile%"
    del /f /q "%keyfile%.pub"
    echo ��ɾ����Կ��%keyfile%
) else (
    echo ��Կ�ļ�������
)

pause
goto menu

:genpub
cls
set /p privkey=������˽Կ����·����
if not exist "%privkey%" (
    echo ˽Կ�ļ�������
    pause
    goto menu
)

set "pubkey=%privkey%.pub"
ssh-keygen -y -f "%privkey%" > "%pubkey%"
echo ��Կ�����ɣ�%pubkey%
type "%pubkey%"

pause
goto menu

:end
echo ���˳���
exit /b
