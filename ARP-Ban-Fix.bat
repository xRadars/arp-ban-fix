@echo off
color A
title  Network Fix
echo Make Sure To Run This Batch As Admin / - dyhis da goat
echo Press Any Key To Continue!
pause >nul

setlocal EnableDelayedExpansion

netsh interface ipv6 uninstall
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=no
netsh int tcp set global autotuninglevel=normal
netsh interface set interface "Microsoft Network Adapter Multiplexor Protocol" admin=disabled
sc config lltdsvc start=disabled
netsh advfirewall firewall set rule group="Network Discovery" new enable=no

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 0xFFFFFFFF /f


netsh advfirewall firewall set rule group="Network Discovery" new enable=no


sc config lltdsvc start=disabled


reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 0xFFFFFFFF /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EEE /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v NetworkAddress /t REG_SZ /d "" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v ArpOffload /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpChecksumOffloadIPv4 /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v LargeSendOffloadv2IPv6 /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpChecksumOffloadIPv6 /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v UdpChecksumOffloadIPv6 /t REG_DWORD /d 0 /f

echo network properties have been configured.


set KEY_NAME=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters
set VALUE_NAME_DNS=Dhcpv6DNSServers
set VALUE_NAME_SEARCHLIST=Dhcpv6DomainSearchList
set VALUE_NAME_DUID=Dhcpv6DUID
set VALUE_NAME_DISABLED=DisabledComponents

::random binary data
set "RANDOM_DNS="
set "RANDOM_SEARCHLIST="
set "RANDOM_DUID="

for /l %%i in (1,1,14) do call :generateRandomByte RANDOM_DNS
for /l %%i in (1,1,14) do call :generateRandomByte RANDOM_SEARCHLIST
for /l %%i in (1,1,14) do call :generateRandomByte RANDOM_DUID

:: set random binary 
reg add "%KEY_NAME%" /v "%VALUE_NAME_DNS%" /t REG_BINARY /d !RANDOM_DNS! /f
reg add "%KEY_NAME%" /v "%VALUE_NAME_SEARCHLIST%" /t REG_BINARY /d !RANDOM_SEARCHLIST! /f
reg add "%KEY_NAME%" /v "%VALUE_NAME_DUID%" /t REG_BINARY /d !RANDOM_DUID! /f

echo random binary values set

ipconfig /flushdns
ipconfig /registerdns
ipconfig /release
ipconfig /renew
netsh winsock reset 

:: Countdown from 5 to 1
echo Closing in 5 seconds...
for /l %%i in (5,-1,1) do (
    echo %%i
    timeout /nobreak /t 1 >nul
)

:: Exit the script
exit /b

:generateRandomByte
set /a "byte=!random! %% 256"
set "hexValue=00!byte!"
set "hexValue=!hexValue:~-2!"
set "%1=!%1!!hexValue!"
exit /b
