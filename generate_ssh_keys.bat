@echo off
setlocal enabledelayedexpansion

:: 设置 SSH 目录
set "sshDir=%USERPROFILE%\.ssh"
if not exist "%sshDir%" (
    mkdir "%sshDir%"
)

:menu
cls
echo 请选择操作：
echo 1. 生成 SSH 密钥
echo 2. 删除现有 SSH 密钥
echo 3. 根据私钥生成公钥
echo 4. 退出
set /p choice=输入 1、2、3 或 4：

if "%choice%"=="1" goto genkey
if "%choice%"=="2" goto delkey
if "%choice%"=="3" goto genpub
if "%choice%"=="4" goto end

echo 无效输入
pause
goto menu

:genkey
cls
echo 选择要生成的密钥类型：
echo 1. RSA (4096-bit)
echo 2. Ed25519
set /p type=输入 1 或 2：

if "%type%"=="1" (
    set "keytype=rsa"
    set "keyfile=%sshDir%\id_rsa"
    set "bits=-b 4096"
) else if "%type%"=="2" (
    set "keytype=ed25519"
    set "keyfile=%sshDir%\id_ed25519"
    set "bits="
) else (
    echo 无效输入
    pause
    goto menu
)

set /p email=请输入邮箱（默认 %USERNAME%@%COMPUTERNAME%）：
if "%email%"=="" set "email=%USERNAME%@%COMPUTERNAME%"

echo 正在生成 %keytype% 密钥...
ssh-keygen -t %keytype% %bits% -f "%keyfile%" -N "" -C "%email%"

:: 设置权限（非必要，但推荐）
icacls "%keyfile%" /inheritance:r /grant:r "%USERNAME%:F" >nul

echo 密钥已生成：%keyfile%
echo 公钥如下：
type "%keyfile%.pub"

pause
goto menu

:delkey
cls
echo 选择要删除的密钥类型：
echo 1. RSA
echo 2. Ed25519
set /p deltype=输入 1 或 2：

if "%deltype%"=="1" (
    set "keyfile=%sshDir%\id_rsa"
) else if "%deltype%"=="2" (
    set "keyfile=%sshDir%\id_ed25519"
) else (
    echo 无效输入
    pause
    goto menu
)

if exist "%keyfile%" (
    del /f /q "%keyfile%"
    del /f /q "%keyfile%.pub"
    echo 已删除密钥：%keyfile%
) else (
    echo 密钥文件不存在
)

pause
goto menu

:genpub
cls
set /p privkey=请输入私钥完整路径：
if not exist "%privkey%" (
    echo 私钥文件不存在
    pause
    goto menu
)

set "pubkey=%privkey%.pub"
ssh-keygen -y -f "%privkey%" > "%pubkey%"
echo 公钥已生成：%pubkey%
type "%pubkey%"

pause
goto menu

:end
echo 已退出。
exit /b
