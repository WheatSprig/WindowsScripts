@echo off
echo ��ѡ�������
echo 1. ��ʱ���ִ�в��ԣ�����ǰ�Ự��
echo 2. ���ý��ִ�в��ԣ���Ҫ����ԱȨ�ޣ�
echo 3. �ָ�Ĭ��ִ�в��ԣ���Ҫ����ԱȨ�ޣ�
echo 4. �˳�
set /p choice=������ѡ�� (1-4):

if "%choice%"=="1" (
    powershell -NoExit -Command "Set-ExecutionPolicy Bypass -Scope Process -Force"
    echo ��ʱ����ɹ���������ǰ�Ự��Ч��
)

if "%choice%"=="2" (
    echo �������ԱȨ��...
    powershell -Command "Start-Process powershell -ArgumentList 'Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force' -Verb RunAs"
    echo ���ý���ɹ�����RemoteSigned��
)

if "%choice%"=="3" (
    echo �������ԱȨ��...
    powershell -Command "Start-Process powershell -ArgumentList 'Set-ExecutionPolicy Restricted -Scope LocalMachine -Force' -Verb RunAs"
    echo ִ�в����ѻָ�Ĭ�ϣ�Restricted��
)

if "%choice%"=="4" exit

pause
