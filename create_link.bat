@echo off
setlocal enabledelayedexpansion

:: 输入源路径
set "source=%~1"
:: 输入目标目录
set "destDir=%~2"

:: 判断路径是否存在
if not exist "%source%" (
    echo 源路径不存在: %source%
    exit /b 1
)

:: 获取源路径的最后一级名称
for %%F in ("%source%") do set "linkName=%%~nxF"

:: 拼接最终链接路径
set "linkPath=%destDir%\%linkName%"

:: 判断是否为目录
if exist "%source%\" (
    mklink /D "%linkPath%" "%source%"
) else (
    mklink "%linkPath%" "%source%"
)

echo 链接创建成功: %linkPath%
