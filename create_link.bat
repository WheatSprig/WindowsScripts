@echo off
setlocal enabledelayedexpansion
title �����������ӹ��ߣ�֧���ļ�/�ļ��У�֧����ק��

:: ���������������ʾ�û�����
if "%~1"=="" (
    set /p source=������Դ·�����������ļ����ļ��У���
) else (
    set "source=%~1"
)

if "%~2"=="" (
    set /p destDir=������������Ҫ���õ�Ŀ��Ŀ¼��
) else (
    set "destDir=%~2"
)

:: �����������
set "source=%source:"=%"
set "destDir=%destDir:"=%"

:: �ж�·���Ƿ����
if not exist "%source%" (
    echo Դ·��������: %source%
    pause
    exit /b 1
)

:: ��ȡ��������
for %%F in ("%source%") do set "linkName=%%~nxF"

:: ƴ����������·��
set "linkPath=%destDir%\%linkName%"

:: �ж���Ŀ¼�����ļ�����������Ӧ���͵�����
if exist "%source%\" (
    mklink /D "%linkPath%" "%source%"
) else (
    mklink "%linkPath%" "%source%"
)

echo �ɹ�������������:
echo %linkPath% -> %source%
pause
