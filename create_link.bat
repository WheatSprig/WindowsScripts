@echo off
setlocal enabledelayedexpansion
title 创建符号链接工具（支持文件/文件夹，支持拖拽）

:: 如果参数不够，提示用户输入
if "%~1"=="" (
    set /p source=请输入源路径（可拖入文件或文件夹）：
) else (
    set "source=%~1"
)

if "%~2"=="" (
    set /p destDir=请输入软链接要放置的目标目录：
) else (
    set "destDir=%~2"
)

:: 清理多余引号
set "source=%source:"=%"
set "destDir=%destDir:"=%"

:: 判断路径是否存在
if not exist "%source%" (
    echo 源路径不存在: %source%
    pause
    exit /b 1
)

:: 获取链接名称
for %%F in ("%source%") do set "linkName=%%~nxF"

:: 拼接最终链接路径
set "linkPath=%destDir%\%linkName%"

:: 判断是目录还是文件，并创建对应类型的链接
if exist "%source%\" (
    mklink /D "%linkPath%" "%source%"
) else (
    mklink "%linkPath%" "%source%"
)

echo 成功创建符号链接:
echo %linkPath% -> %source%
pause
