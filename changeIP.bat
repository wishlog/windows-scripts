@echo off
cls
netsh interface ip show config

:dhcp
set static=
set /P static=Set static route [y for static/ n for dhcp]: %=%
if "%static%"=="" goto static


if "%static%"=="n" (
netsh interface ip set address "Local Area Connection" dhcp
netsh interface ip set dns "Local Area Connection" dhcp

ECHO Address and DNS changed to DHCP
pause
exit
)

:StaticIP
set StaticIP=
set /P StaticIP=Static IP: %=%

:Gateway
set Gateway=
set /P Gateway=Gateway IP: %=%

:Subnet
set Subnet=
set /P Subnet=Subnet mask: %=%

ECHO netsh interface ip set address name="Local Area Connection" static %StaticIP% %Subnet% %Gateway%  1

netsh interface ip set address name="Local Area Connection" static %StaticIP% %Subnet% %Gateway% 1

set DNS=
set /P DNS=DNS IP: %=%

ECHO netsh interface ip set dns "Local Area Connection" static %DNS%

netsh interface ip set dns "Local Area Connection" static %DNS%
pause