@echo off
echo 请选择操作：
echo 1. 临时解除执行策略（仅当前会话）
echo 2. 永久解除执行策略（需要管理员权限）
echo 3. 恢复默认执行策略（需要管理员权限）
echo 4. 退出
set /p choice=请输入选项 (1-4):

if "%choice%"=="1" (
    powershell -NoExit -Command "Set-ExecutionPolicy Bypass -Scope Process -Force"
    echo 临时解除成功！（仅当前会话生效）
)

if "%choice%"=="2" (
    echo 请求管理员权限...
    powershell -Command "Start-Process powershell -ArgumentList 'Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force' -Verb RunAs"
    echo 永久解除成功！（RemoteSigned）
)

if "%choice%"=="3" (
    echo 请求管理员权限...
    powershell -Command "Start-Process powershell -ArgumentList 'Set-ExecutionPolicy Restricted -Scope LocalMachine -Force' -Verb RunAs"
    echo 执行策略已恢复默认（Restricted）
)

if "%choice%"=="4" exit

pause
